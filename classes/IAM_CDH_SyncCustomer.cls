/************************************************************
Name:  IAM_CDH_SyncCustomer
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Apex class to sync Customer Data to CDH and Capture the repsonse and update it Accordingly 2                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020     Changed the end points for Mule API convertion API      
*****************************************************/
/********************************************************************************
***********************************************************************************/

global with sharing class IAM_CDH_SyncCustomer{
    
public static boolean sync=false;    
    @future (callout=true)
    public static void CDHOutboundCall( String cdhAcc,String accId){
        
        System.debug('Printing CDH Service'+cdhAcc);
        
        try{
            String accessToken;
            if(Test.isRunningTest()) {
                accessToken = 'lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz';
                System.debug('#### In Test.isRunningTest - accessToken - '+accessToken);
            } else {
                //accessToken = IAM_OAG_getoAuthToken.getAccessToken('IAM_CDH_oAuth'); - OAG Connection Details.
                accessToken=IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_CDH_Sync_Mule_oAuth');
            }
            
            //calling get connection details class to get URLS for Sync Customer
            //CSS_Integration_Details__c IAMCDH = new CSS_Integration_Details__c();
            //IAMCDH = IAM_getConnnectionDetails.getConnection('IAM_CDH_Sync_Customer'); - OAG Connection details from CSS Integration Object. 
            
            CSS_Integration_Details__c IAMCDH = IAM_getConnnectionDetails.getConnection('IAM_CDH_Mule_Customer_Sync'); 
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+''+accessToken);
            //String endpoint = System.Label.IAM_OAG_URL+'/cdh/iam/synccustomer';
            req.setMethod(IAMCDH.Method_Type__c);
            req.setEndpoint(IAMCDH.End_Point__c); 
            req.setbody(cdhAcc);
            req.setTimeout(120000);
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setHeader('resourse',IAMCDH.Resource__c);
            system.debug('CDH request' +req);
            Sync=True;
            //system.debug(JsonString);
            //Http response method 
            Http http = new Http();
            HTTPResponse res = http.send(req);
            String cdhResponse = res.getBody();
            System.debug('cdhResponse.....  ' + cdhResponse);
            System.debug('Printing response get code'+res.getstatusCode());
            System.debug('Printing Response Body'+res.getBody());
           
            IAM_CDH_Sync_ResponseParser asp= IAM_CDH_Sync_ResponseParser.parse(cdhResponse);
            System.debug('Printing asp'+asp);
            System.debug('Printing application record'+asp.Header);
           
            
           // Account acc = [select BMS_Customer_ID__c, BMS_PartySite_ID__c, GOMS_Customer_ID__c, GOMS_PartySite_ID__c, SOMS_Customer_ID__c, SOMS_PartySite_ID__c, GIEA_Customer_ID__c, GIEA_PartySide_ID__c, CARE_Customer_ID__c, CARE_PartySite_ID__c from account where id =: accId];
            Account acc = [select id,IAM_ECN__c from account where id =: accId];
            System.debug('Printing Account number and updatig account with ECN number'+acc);
            if(Test.isRunningTest()) {
                acc.IAM_ECN__c = '23455';
            } else {
            	acc.IAM_ECN__c=String.valueof(asp.createOrganization_Output.ListOfSwiOrganizationIO.Account.ECN);
            }
            acc.IAM_CDH_Sync__c=True;
            
            Update acc;
           
        }catch(Exception ex){
            System.debug('Exception thrown during CDH callout ... ' + ex);
        }

    }

    //Method to get the Payload by sending account information to the Parser class.
   public static String getCDHOutboundReq(Account acc){
        String cdhReqBody = '';
        IAM_CDH_SyncRequestJsonParser chdpayLoad = new IAM_CDH_SyncRequestJsonParser();
        cdhReqBody = chdpayLoad.getIAMCDHRequestJson(acc);
        
        System.debug('cdhReqBody.....  ' + cdhReqBody);
        return cdhReqBody;
    }
}