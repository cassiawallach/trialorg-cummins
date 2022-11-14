Public Class IAM_PWC_RedirectCumpas{

    Public pageReference redirect(){
        
        pageReference pg;
        String currentRecordId  = ApexPages.CurrentPage().getparameters().get('appid');
        String fedexReturnURL=ApexPages.currentpage().getParameters().get('fedexReturnUrl');
        String fedexEmail=ApexPages.CurrentPage().getParameters().get('FedexemailId');
        String fedexSessionId=ApexPages.CurrentPage().getParameters().get('sessionId');
        
         App_Mapping__c ap=[select id,CMI_External_Start_Url__c from App_Mapping__c where id=:currentrecordId];
         System.debug('Printing Random Number'+IAM_PWC_CumminsRedirectPage.loginNumber);
        
        
        
        
        System.debug('Pritning appid '+currentRecordId);
        System.debug('Printing federation return URL'+fedexReturnURL);
        System.debug('Printing fedex email'+fedexemail);
        System.debug('Printing session ID'+fedexSessionId);
        
        String relayState=System.Label.IAM_PWC_Cumpas_Instance_URL+fedexReturnURL+'&FedexemailId='+fedexEmail+'&sessionId='+fedexSessionId;
                String encodedURL = EncodingUtil.urlEncode(relayState, 'UTF-8');
        pg=new pageReference(ap.CMI_External_Start_URL__c+'&RelayState='+encodedURL);
        return pg;
    }

}