@RestResource(urlMapping='/rswstatus/*')
global  class IAM_RSW_Inbound{
    
    //==============================================================================================
    // *** REST Post *** :  Requires the IAM Cummins Login ID to fetch contact and respective user access
    // record in order to update the Status of that record.
    //===============================================================================================
    @HttpPost
    global static CMI_ResponseHandler Post(rswIAMUserResponseDetails rswIAMUserResponseDetails){
        system.debug('request====' + rswIAMUserResponseDetails);
                                
        //RestRequest req = RestContext.request;
        CMI_ResponseHandler response = new CMI_ResponseHandler(); 
		 List<User> usr;        
        string Fieldname = ValidateRequest(rswIAMUserResponseDetails);
        if(String.isEmpty(Fieldname)) {
        	try{
        		RestRequest request = RestContext.request;                
                List<Contact> rswContact = getContactList(rswIAMUserResponseDetails.userID);
                System.debug('Printing Contact from the call'+rswContact);                
                if(!rswContact.isEmpty()){
                    Set<id> updateId= new Set<id>();
                    updateId.add(rswContact[0].id);
                    if(!rswContact[0].Contact_Provisionings__r.isEmpty()){
                        System.debug('Printing User access Feature Records'+rswContact[0].Contact_Provisionings__r );
                        if(rswIAMUserResponseDetails.status == Label.IAM_Status_Active) {
                            rswContact[0].Contact_Provisionings__r[0].IAM_Status__c = Label.IAM_Status_Active;
                        } else if(rswIAMUserResponseDetails.status == Label.IAM_RSW_Status_Cancelled) {
                            rswContact[0].Contact_Provisionings__r[0].IAM_Status__c = Label.IAM_Status_Inactive;
                        }                        
                        rswContact[0].Contact_Provisionings__r[0].IAM_Role__c=rswIAMUserResponseDetails.roleID;
                        System.debug('Status that is going to get updated'+rswIAMUserResponseDetails.status);
                        //
                        if(rswContact[0].IAM_Contact_Owner__c != null){
                            rswContact[0].Contact_Provisionings__r[0].IAM_User__c=rswContact[0].IAM_Contact_Owner__c;   
                        }
                        update rswContact[0].Contact_Provisionings__r[0];  
                        
                        id jobID=system.enqueueJob(new IAM_RSW_Inbound_Contact_Update(rswIAMUserResponseDetails.status,rswContact[0].id,rswIAMUserResponseDetails.userID,rswContact[0].Contact_Provisionings__r[0].id));
                        //On succesfull update.
                        response = getResponse(true, 'Record Updated Successfully', rswIAMUserResponseDetails.userID);                           
                    } else {
                        //response to send if there is no User access feature Record.
                        String errMsg = 'No User Access Feature record is present';
                        cmiError(errMsg,rswIAMUserResponseDetails.userID,rswIAMUserResponseDetails.status);
                        response = getResponse(false, errMsg, rswIAMUserResponseDetails.userID);
                    }                     
                } else {
                    //response to send if there is no contact with the given username.
                    String errMsg = 'No Contact is present with given Username';
                    cmiError(errMsg,rswIAMUserResponseDetails.userID,rswIAMUserResponseDetails.status);
                    response = getResponse(false, errMsg, rswIAMUserResponseDetails.userID);
                }    
            } catch (System.DmlException e) {          
                String errMsg = '';
                for (Integer i = 0; i < e.getNumDml(); i++) {
					errMsg = errMsg + ',' + e.getDmlMessage(i); 
                }
				response = getResponse(false, errMsg, rswIAMUserResponseDetails.userID);
				cmiError(e.getMessage(),rswIAMUserResponseDetails.userID,rswIAMUserResponseDetails.status);
            } catch(Exception e) {
				response = getResponse(false, e.getMessage(), rswIAMUserResponseDetails.userID);
				cmiError(e.getMessage(),rswIAMUserResponseDetails.userID,rswIAMUserResponseDetails.status);
			}          
        } else {
            response = getResponse(false, fieldName, rswIAMUserResponseDetails.userID);
            cmiError(fieldName, rswIAMUserResponseDetails.userID,rswIAMUserResponseDetails.status); 
        }
        System.debug('Printing response for RSW'+response);
        return response;
    }
    
   	/* In case of Success and Failure, draft a response and return */
	private static CMI_ResponseHandler getResponse(Boolean isSuccess, String message, String userId) {
		CMI_ResponseHandler response = new CMI_ResponseHandler();
		if(isSuccess) {
			response.Description = message;
			response.Status_Code = '200';
			response.User_ID = 'Success';
		} else {			
			response.Status_Code = '404';
			response.User_ID = userId;
			response.Description = 'Fail : ' + message;
		}
		return response;
	} 
    
	/* Check if all required fields have valid data */
	private static string validateRequest(rswIAMUserResponseDetails newUserInfoObj) {
        string fieldName = '';  
        
        System.debug('Printing email'+newUserInfoObj.userEmail);
        if(String.isBlank(newUserInfoObj.userEmail)) {
             fieldName = fieldName +' User email cannot be blank,';    
        }
        //Condition for checking email is valid or not
        if(String.isNotBlank(newUserInfoObj.userEmail)){
            List<String> emails= new List<String>();
            emails.add(newUserInfoObj.userEmail);
            if(!validateEmail(emails)){
                fieldName = fieldName + 'Provide a valid  email, ';
            }
        }    
        if(newUserInfoObj.userID== null || newUserInfoObj.userID.trim() == ''){
            fieldName = fieldName +' UserID or Username cannot be blank,';   
        }        
        /*if(String.isNotBlank(newUserInfoObj.userID)) {
           List<String> emails= new List<String>();
            emails.add(newUserInfoObj.userID);
            if(!validateEmail(emails)){
                fieldName = fieldName + 'Provide a valid  username, ';
            }   
        } */ //Removing username validation because rsw team is sending both legacy usernames and new USernames.       
        if(String.isBlank(newUserInfoObj.status)){
           fieldName = fieldName +' Status is required,';          
        }        
        if(String.isBlank(newUserInfoObj.roleID)){
             fieldName = fieldName +' Role is Required,';
        }                
        if(String.isNotBlank(newUserInfoObj.roleID)) {
            Set<string> tmplist = IAM_ExistCompUserSubCreation.getPicklistValues('IAM_Role__c','IAM_Contact_Provisioning__c');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(newUserInfoObj.roleID.trim())){
				fieldName = fieldName +newUserInfoObj.roleID+' is not a valid picklist Value for Role,';
            }           
        }		
		if(String.isNotBlank(fieldName)){
		  	fieldName = fieldName.removeEnd(',')+'.';
		}		
        return fieldName;
    }
    
    /* Adding custom Exception sub-class */
    public class NoRecordMatchException extends Exception {}    
    
	/* It store error in IAM_Identity_Management_Errors__c object */
    public static void cmiError(String msg,String username,String Status){
        IAM_Identity_Management_Errors__c errObj = new IAM_Identity_Management_Errors__c();        
        errObj.IAM_Error_Description__c= msg;
        errObj.IAM_Error_Source__c='IDENTITY-RSW';
        errObj.IAM_Processed_Data__c='UserName from payload '+username+'. Staus from the payload '+Status+'.';        
        insert errObj;
    }
	
	/* Return response in this wrapper to RSW system */
    global class CMI_ResponseHandler {
        //List of custom attributes that we want to check the status of the org
        public String Status_Code {get; set;}
        public String User_ID{get;set;}
        public String Description {get; set;} 
    }
    
    /* Request wrapper for RSW system */          
    global class rswIAMUserResponseDetails{
        public String userID{get;set;}
        public String roleID{get;set;}
        Public String status{get;set;}
        public String userEmail{get;set;}
    }
    
	/* Validate email addresses */
    public static Boolean validateEmail(List<String> lstemails) {
        Boolean res = true;     
        system.debug('lstemails==' + lstemails);        
        for(string email: lstemails) {
            system.debug('email==' + email); 
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.([a-zA-Z]{2,4})+$';
            Pattern MyPattern = Pattern.compile(emailRegex);        
            Matcher MyMatcher = MyPattern.matcher(email);       
            if (!MyMatcher.matches()) {       
                res = false;        
            }
			system.debug('res==' + res);            
        }       
        system.debug('res==' + res);        
        return res; 
    }
    
	
    public static List<Contact> getContactList(String userName) {
    	return [
            SELECT Id
                 , Name
                 , Email
            	 , IAM_from_Registration__c
            	 , IAM_Contact_Status__c
            	 , Username__c
            	 , IAM_contact_check__c
            	 , IAM_Contact_Owner__c
            	 , (SELECT Id
                    	 , IAM_Application_Name__c
                    	 , IAM_User__c 
                      FROM Contact_Provisionings__r 
                     WHERE IAM_Application_Name__c = :System.label.IAM_Rapid_Serve_Web 
                       AND IAM_Status__c=: Label.IAM_Status_Pending)
               FROM Contact
              WHERE (Username__c = :userName OR IAM_Ext_Legacy_UID__c=:userName)
              LIMIT 1
        ];
    }
}