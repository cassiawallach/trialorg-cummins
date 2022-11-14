public class IAM_CSTServiceTrnIdUpdateCallout {
    @future (callout=true)    
    public static void cstUserServiceTrainingIdUpdate(Set<Id> userId){
        String cstUser;
        String uName = '';
        String promotionId = '';
        String oldUserName = '';
        try {           
            IAM_Contact_Provisioning__c useRecords = [
                SELECT Id
                     , IAM_Promotion__c
                     , IAM_User__r.Username
                     , IAM_Contact__c
                  FROM IAM_Contact_Provisioning__c
                 WHERE Id IN :userId
                 LIMIT 1
            ]; 
            List<Contact> con = [
                SELECT Id
                     , FirstName
                     , LastName
                     , Phone
                     , Account.IAM_Service_Provider_Code__c
                     , Email
                     , IAM_Promotion__c
                     , Username__c
                  FROM Contact
                 WHERE Id = :useRecords.IAM_Contact__c
            ];
            if(String.isNotBlank(useRecords.IAM_User__r.Username)){
                uName = useRecords.IAM_User__r.Username;                
            } else {
                uName = con[0].Username__c;
            }
            promotionId = useRecords.IAM_Promotion__c;
            System.debug('#### uName - '+uName);       
                     
            HttpResponse response = getResponse(uName, promotionId); 
            

            
            // If the request is successful, parse the JSON response.
            System.debug('#### response - ' +response);
            System.debug('#### response statue - ' +response.getStatusCode());
            System.debug('#### response body - ' +response.getBody());
            String body = response.getBody();
            System.debug('Printing response from CST Associate API'+response.getBody());
            //String body = '{"totalSize": 0,"userMessage": "Unknown Service Training ID","records": {}}';// Need to change the body instead of hard coded 
            if(String.isNotBlank(body)) {
                CSTResponse cstResp = new CSTResponse();
                cstResp = (CSTResponse) JSON.deserialize(body, CSTResponse.class);
                System.debug('#### cstResp - '+cstResp);
                System.debug('#### cstResp userMessage - '+cstResp.userMessage);
                if((cstResp.userMessage).equalsIgnoreCase(Label.IAM_CST_ErrMsg_Unknown_Service_Training_ID)) {
                    sendEmail(con[0]);  //sending email to CST team.
                    useRecords.IAM_Promotion__c = '';
                    update useRecords;
                    
                    //Updating Contact value to blank value.
                    
                    con[0].IAM_Promotion__c='';
                    Update Con;
                    
                    
                                      
                    //IAM_CSTUserOutboundHelper.CstOutboundCall(userId); Commenting this line of code.
                    /*System.debug('#### before useRecords.IAM_Promotion__c '+useRecords.IAM_Promotion__c);
                    System.debug('#### before contact IAM_Promotion__c '+con[0].IAM_Promotion__c);
                                       System.debug('#### aft useRecords.IAM_Promotion__c '+useRecords.IAM_Promotion__c);
                    System.debug('#### after contact IAM_Promotion__c '+con[0].IAM_Promotion__c);*/
                }/* else if(cstResp.totalSize == '1' && (cstResp.userMessage).equalsIgnoreCase(Label.IAM_CST_Msg_Promotion_Id_Associated)) {
                    oldUserName = cstResp.records.get('LOGIN_ID');
                    String trainingCode = IAM_CSTUserOutboundHelper_Reclaim.CstOutboundCall(con[0].FirstName,con[0].LastName,con[0].Email,
                        con[0].Phone,con[0].Account.IAM_Service_Provider_Code__c,con[0].Id,oldUserName,
                        con[0].Username__c);
                    if(String.isNotBlank(trainingCode) && trainingCode != 'error') {
                        useRecords.IAM_Promotion__c = trainingCode;
                        update useRecords;    
                    }
                }*/
            }          
        }catch(Exception e){
            System.debug('#### Exception in CST user status update - ' + e.getMessage());
            cmiError(e.getMessage());
        }
    }
    
    /* Make callout to CST system to update Service Traing Id in CST */
    public static HTTPResponse getResponse(String uName, String promotionId) {
        String cstUser ='username='+uName+'&service_training_id='+promotionId+'&current_username='+UserInfo.getUserName();
        System.debug('#### cstUser - '+ cstUser);
        CSS_Integration_Details__c IAMcon = new CSS_Integration_Details__c();
        IAMcon = CSS_getConnnectionDetails.getConnection('IAM_CST_User');
        String accessToken = IAM_CST_Authentication.getBearer('IAM_CST_User');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(Label.IAM_Endpoint_Update_Service_Training_Id);
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Authorization','Bearer '+accessToken);
        request.setMethod('POST');
        request.setBody(cstUser);
        System.debug('#### request - '+request);
        System.debug('#### request body - '+request.getBody()); 
        return http.send(request);
    }
    
    /* Send email to Contact owner if CST returns it is a unknown service training Id */
    public static void sendEmail(Contact con) {
        System.debug('#### in send email con ' + con);     

        String sEmailAddresses = String.valueOf(con.email);
        EmailTemplate template = [
            SELECT Id
             FROM EmailTemplate
            WHERE Name = 'IAM_Unknown_Service_Training_ID'
        ];
        List<OrgWideEmailAddress> noReplyEmailAddress = [
            SELECT Id
              FROM OrgWideEmailAddress
             WHERE Address = :Label.IAM_Email_Address_No_Reply
        ];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(!noReplyEmailAddress.isEmpty()) {
            mail.setOrgWideEmailAddressId(noReplyEmailAddress[0].id);
        }
        
        String[] toaddr = sEmailAddresses.split(',');
        mail.setTargetObjectId(con.Id);
        mail.setTemplateId(template.id);
        mail.setTreatTargetObjectAsRecipient(false);
        //mail.setWhatId(accId);
        mail.setToAddresses(toaddr);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            mail
        });
    }
    
    /* It store error in IAM_Identity_Management_Errors__c object */
    public static void cmiError(String msg){
        IAM_Identity_Management_Errors__c errObj = new IAM_Identity_Management_Errors__c();        
        errObj.IAM_Error_Description__c = msg;
        errObj.IAM_Error_Source__c = 'IDENTITY-CST';
        errObj.IAM_Processed_Data__c = 'Error in updating Service Training ID';        
        insert errObj;
    }
    
    /* It store response */
    public class CSTResponse {
        //String error;
        //String error_description;
        //String totalSize;
        String userMessage;
        //Map<String, String> records;
    }
}