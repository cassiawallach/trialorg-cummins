@RestResource(urlMapping='/RegistrationNotification/*')
global with sharing class CMI_RegistrationNotificationAPI {
    
    //==============================================================================================
    // *** REST Post *** :  Requires the id of Account and reutrn results as Response Type
    //===============================================================================================
    @HttpPost
    global static CMI_ResponseHandler Post(string signedBy,string signedByTitle,string email,string signedOn)
    {
     CMI_ResponseHandler response = new CMI_ResponseHandler();
    try{
       
        Account  returnAccount = getAccount();
        List<IAM_Application__c> DAapp=[select id,CMI_CDA_Status__c,CMI_signedBy__c,CMI_signedByEmail__c,CMI_signedByTitle__c,CMI_signedOn__c from IAM_Application__c where IAM_Account_Name__c=:returnAccount.id and IAM_Application_Name__c=:System.Label.IAM_AppName_ConnectedSolutions  LIMIT 1];
        system.debug('account details==='+returnAccount);
        System.debug('Printing Da app Details'+DAapp);
        RestRequest req = RestContext.request;
        String CId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1); 
        system.debug('CID value is==='+CId);
        if(returnAccount!=null&&!DAapp.isEmpty())
        {
        
            response.Status = 'Success';
           if(response.StatusCode == '200'|| DAapp[0].CMI_CDA_Status__c != 'Signed by customer')
            {
                DAapp[0].CMI_CDA_Status__c= 'Signed by customer';
                if(signedBy != null && signedBy != '')
                    DAapp[0].CMI_signedBy__c = signedBy;
                if(email != null && email != '')
                    DAapp[0].CMI_signedByEmail__c = email;
                if(signedByTitle != null && signedByTitle != '')
                    DAapp[0].CMI_signedByTitle__c = signedByTitle;
                if(signedOn != null && signedOn != '')
                {
                    try{
                        //DateTime signedOndt = DateTime.parse(signedOn);
                        DAapp[0].CMI_signedOn__c= signedOn;
                    }
                    Catch(exception e)
                    {
                        cmiError(e.getMessage());
                        
                    }
                }
                    system.debug('after updating the return account'+DAapp);
                update DAapp;
            }
            /*List<sObject> thesObjectList = new List<sObject>();
            thesObjectList.add((sObject)returnAccount);
            response.Data = thesObjectList;*/
            response.Message = 'Success : The signed notification has been received.';
        }
        
        else
        {
        system.debug('error message is');
            response.StatusCode = '404';
            response.Status = 'error';
            response.Data = null;
            response.Message = 'Fail : There are no customers associated with the  Id:' + CId;
            
        }
        }
        catch(Exception e)
        {
        system.debug('get stack trace'+e.getStackTraceString());
         cmiError(e.getStackTraceString());
         System.debug('ERROR Message:-->:'+ e);
            return null;
        }
        
        return response;
    }
    
    //Adding custom Exception sub-class 
    public class NoRecordMatchException extends Exception {}
    
    public static Account getAccount()
    {
        //Read the Request from the URL
        
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Account result;
        try{
        String CId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1); 
        System.debug('CId:-->:'+ CId);
       // String CId = RestContext.request.params.get('cId')
        //String Cref = RestContext.request.params.get('cref')
        
        
           result = [SELECT Id,CMI_CDA_Status__c FROM Account WHERE CMI_CId__c =:CId];
            //result = [SELECT Id,CMI_Account_Num__c FROM Account WHERE CMI_Account_Num__c like :CId];
            System.debug('result of:-->:'+ result);
            //result = [SELECT Id,CMI_Account_Num__c,CMI_CDA_Status__c,CMI_Telematics_Provider_Customer_ID__c FROM Account WHERE CMI_Account_Num__c = :CId AND CMI_Telematics_Provider_Customer_ID__c = :Cref];
        }
        Catch(exception e)
        {
            system.debug('get stack trace for result'+e.getStackTraceString());
            cmiError(e.getmessage());
            System.debug('ERROR Message:-->:'+ e);
            return null;
        }
        return result;
    }
    public static void cmiError(String msg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c='IDENTITY';
        errObj.Error_Description__c = msg;
        /*
        errObj.Source__c='IDENTITY';
       errObj.Error_Type__c='Rest Service CMI_RegistrationNotificationAPI';
       errObj.Error_Description__c = msg;
       errObj.Processed_Data__c=s;
        */
        insert errObj;
    }
    global class CMI_ResponseHandler {
    
        //List of custom attributes that we want to check the status of the org
        public String Status {get; set;}
        public List<sObject> Data {get;set;}
        public String Message {get;set;}
        public String StatusCode {get; set;}
        
         
    }
    
}