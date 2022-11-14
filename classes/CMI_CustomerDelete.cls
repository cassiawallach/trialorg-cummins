@RestResource(urlMapping='/Customer/Delete/')
global with sharing class CMI_CustomerDelete {
    
    //==============================================================================================
    // *** REST Post *** :  Requires the cummins customer id of Account and reutrn results as Response Type
    // Class is mainly used to delete or deactivate Customer.
    //===============================================================================================
    @HttpPost
    global static CMI_ResponseHandler Post(DeactivateCompanyPayload DeactivateCompanyPayload)
    {
        system.debug('request====' + DeactivateCompanyPayload );
                                string duplicate='';
        RestRequest req = RestContext.request;
        CMI_ResponseHandler response = new CMI_ResponseHandler();
        List<Account> acc;
        List<CMI_TSP__c> tsp;  
        //String Cid =  req.requestURI.substring(req.requestURI.indexof('/')+10,req.requestURI.indexof('/delete/'));
        String Cid=DeactivateCompanyPayload.CustomerSK;
        system.debug('CID value is==='+Cid);
        if(!string.isempty(Cid)){
        acc=[Select id,name,CMI_Account_Status__c,IsCustomerPortal from account where CMI_CId__c=:Cid Limit 1];
        System.debug('Printing the account details of the customer sk obtained in the url'+acc);
         if(!acc.isEmpty()){
           tsp=[SELECT id,CMI_Account_Name__c,CMI_Telematics_ID__c,CMI_TSP_Id__c,CMI_TSP_Name__c FROM CMI_TSP__c WHERE CMI_Account_Name__c =:acc[0].id];
          System.debug('Printing the datails of TSP to be Updated'+tsp);
            } 
        }                    
        string Fieldname = ValidateRequest(DeactivateCompanyPayload ,acc,tsp,Cid);
        system.debug('Fieldname====' + Fieldname);
       
        
        if(Fieldname == '')
           { 
            try
            {
                Savepoint sp = Database.setSavepoint();      
               try{
              
              /*Check if  all the contacts in that account .then call the class in
              Company information to deactivate users by passing contact ids and De-Activate string.then again check for any active users for the account if not present update account with 
                Inactive status then make a future call out to send to pc*/
                    System.debug('Account is Customer portal accounnt');
                   List<id> aid= new List<id>();
                   List<id> cids=new List<id>();
                   List<user> u;
                   /* for(Account a : acc){
                            aid.add(acc[0].id);
                            system.debug('All the copntact ids under the account with given Customer SK'+aid);
                        }*/

                        List<Contact> con=[Select id,firstname,Lastname,email from contact where accountid=:acc[0].id];
                        for(Contact c : con){
                                cids.add(c.id);
                                System.debug('Contact ids from the Account are'+cids);
                             }
                    /*Got all the Contacts irrespective of theeir users active or not.Calling User update class in company
                       information class to deactive users.Noo need to check for contact list size because comp info class performs 
                       all actions and checks the list size.*/ 
                    CMI_CompanyInformation.userUpdate(acc[0].id,cids,'De-Activate');
                    /* After calling company information class to deactiver uers.Then again check all the users for that
                    particular account area inactive or not.*/
                    if(!cids.isEmpty())
                     {
                        System.debug('Eneterd into user query because contact ids are not null');
                        u=[Select id,FirstName,LastName,Email,username,isActive from user where Contactid=:cids and isActive=True];
                        system.debug('Users after deactivating the users by calling company info class'+u);
                     }
                    /* Irrespective of account status and any other cases and if users from the above query is empty and it should be empty.
                    calling future method to do send to pc and update the account status to Inactive. */ 
                    if(u.isEmpty()|| cids.isEmpty())
                        {
                            System.debug('Eneterd into user query because user ids are null');
                            DoCallout(acc[0].id);
                        }
                    
                    /*Simply calling future method without any check on account
                    System.debug('Making future callout.');
                    DoCallout(acc[0].id);*/

                response.StatusCode = '200';
                response.Status = 'Success';
                response.Data = null;
                response.Message = 'Customer with '+Cid+' is deactivated Successfully';
              }
            catch (System.DmlException e) {
                CMI_APIAccountCreation.cmiError(e.getMessage());
                system.debug('DmlException====' + e);
                response.StatusCode = '404';
                response.Status = 'Unable to delete the Customer Based on the given Customer SK '+Cid;
                response.Data = null;
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                    response.Message =  e.getDmlMessage(i); 
                }
                Database.rollback(sp);
                return response;
             
             }  
                 
           
            }
            catch (System.DmlException e) {
            CMI_APIAccountCreation.cmiError(e.getMessage());
                response.StatusCode = '404';
                response.Status = 'Unable to delete the Customer Based on the given Customer SK '+Cid;
                response.Data = null;
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                    response.Message =  e.getDmlMessage(i); 
                }
                 
                
            //sendmailToAdmin(DeactivateCompanyPayload.AccountName,DeactivateCompanyPayload.ContactfirstName,DeactivateCompanyPayload.ContactLastName,DeactivateCompanyPayload.Contactemail,response.Message);
            }            
        }
        else
        {
            CMI_APIAccountCreation.cmiError(Fieldname);
            response.StatusCode = '404';
            response.Status = 'Unable to delete the Customer Based on the given Customer SK '+Cid;
            response.Data = null;
            string tspexist = '';            
            response.Message = 'Fail : ' + Fieldname;
            //sendmailToAdmin(CustomerPayloadInfo.AccountName,CustomerPayloadInfo.ContactfirstName,CustomerPayloadInfo.ContactLastName,CustomerPayloadInfo.Contactemail,response.Message);
        }
        return response;
    }
    
    private static string ValidateRequest(DeactivateCompanyPayload customerdeleteObj,List<account> accnt,List<CMI_TSP__c> TSP,String CId)
    {

        
        
        string Fieldname = '';
        if(String.isEmpty(CId)){

            Fieldname=Fieldname+'Not able to find Customer with Specified SK , ';
        }
        if(!String.isEmpty(CId)&&accnt.isEmpty()){

            Fieldname=Fieldname+'There is no Customer with specified Customer SK '+CId+' ,';
        }
        
        
        //Checcking if all the four required fields match data base 
        if(!String.isEmpty(CId) && !accnt.isEmpty()){
           /* if(customerdeleteObj.CustomerSK!=null  &&  customerdeleteObj.CustomerSK !=accnt[0].CMI_CId__c){
                Fieldname=Fieldname+'Customer does not match with the record specified,';
            }*/
            if(accnt[0].CMI_Account_Status__c=='Inactive'){

            Fieldname=Fieldname+'Account cannot be deactivaed because,its status is already Inactive , ';
            }
            if(customerdeleteObj.AccountName != null && customerdeleteObj.AccountName!=accnt[0].Name){
                Fieldname=Fieldname+'Customer name does not match with the record specified, ';
            }
            if(customerdeleteObj.tspcustRef != null && customerdeleteObj.tspcustRef!=TSP[0].CMI_TSP_Id__c){
                Fieldname=Fieldname+'TSP Custreference does not match with the record specified ,';
            }
            if(customerdeleteObj.Tspname != null && customerdeleteObj.Tspname.trim() != '' && customerdeleteObj.Tspname!=TSP[0].CMI_TSP_Name__c){
                Fieldname=Fieldname+'Customer TSP name does not match with the name specified in record, ';
            }
        }

        if(customerdeleteObj.CustomerSK == null || customerdeleteObj.CustomerSK.trim() == '')
        {
            Fieldname = Fieldname + 'CustomerSK is required, ';            
        }
        if(customerdeleteObj.AccountName == null || customerdeleteObj.AccountName.trim() == '')
        {
            Fieldname = Fieldname + 'AccountName is required, ';
        }
            
            if(customerdeleteObj.AccountName != null && customerdeleteObj.AccountName.length() > 50)
        {
            Fieldname = Fieldname + 'AccountName maximum length is 50 characters., ';
        }

         if(customerdeleteObj.tspcustRef == null || customerdeleteObj.tspcustRef.trim() == '')
        {
            Fieldname = Fieldname + 'tspcustRef is required, ';
        }
            
            if(customerdeleteObj.tspcustRef != null && customerdeleteObj.tspcustRef.length() > 50)
        {
            Fieldname = Fieldname + 'tspcustRef maximum length is 25 characters., ';
        }
        if(customerdeleteObj.Tspname==null || customerdeleteObj.Tspname==''){
            Fieldname=Fieldname+'TSP name is required, ';
        }
        if(customerdeleteObj.Tspname != null && customerdeleteObj.Tspname.trim() != '')
        {
            Set<string> tmplist = CMI_APIAccountCreation.getPicklistValues('CMI_TSP_Name__c','CMI_TSP__c');
            System.debug('tmplist***************'+tmplist );
            if(!tmplist.contains(customerdeleteObj.Tspname))
            {
                Fieldname = Fieldname + 'Provide a valid Tspname ,' ;
            }

        }
             
            Fieldname = Fieldname.removeEnd(', ');
        
        
        return Fieldname ;
    }
    
    
    //Adding custom Exception sub-class 
    public class NoRecordMatchException extends Exception {}    
    
    
    global class CMI_ResponseHandler {
    
        //List of custom attributes that we want to check the status of the org
        public String Status {get; set;}
        public List<sObject> Data {get;set;}
        public String Message {get;set;}
        public String StatusCode {get; set;}
        
         
    }
   
    global class DeactivateCompanyPayload{
           
              public string CustomerSK{set;get;}
             public string accountName{set;get;}
             public string tspname{set;get;}
             public string tspcustRef{set;get;}
             public string userId{set;get;}
             
        }  
   
@future(callout=true)
private static void DoCallout(String accid)
{
 List<Account> accnt=[Select id,name,CMI_Account_Status__c from account where id=:accid LIMIT 1];
    System.debug('Account in the Future call'+accnt);
    //Making call out to PC(Send to pc)
       String strResponse=CMI_CompanyInformation.CalloutResponseContents(accid,'Inactive','Send To PC');
       System.debug('Printing response coming from the Company information class'+ strResponse);
       //Making account status inactive depending upon the send to pc response
    if(strResponse =='successfull'||strResponse =='OK')
    {
        System.debug('Making Account Status Inactive');
        accnt[0].CMI_Account_Status__c='Inactive';
        //updating the account with the Inactive status.
        Savepoint sp = Database.setSavepoint();
        try{
            update accnt;
            system.debug('Account after updation'+accnt);
            }catch(exception e){
            CMI_APIAccountCreation.cmiError(e.getMessage());
            Database.rollback(sp);
            }

    }
    
 }

}