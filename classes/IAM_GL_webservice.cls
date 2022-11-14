/************************************************************
Name:  IAM_GL_webservice
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This Class will give the nearest distributor when address is sent to Global Locator team   2                     
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020      Changes made for Mule API 
1.2 -    Karthik Raj Golakaram     03/26/2021      Added Space after bearer     
*****************************************************/
/********************************************************************************
***********************************************************************************/
global without sharing class IAM_GL_webservice {

    public static Id parentDistributorId;
     public static void makeCallout(String billingStreet, string BillingCity, string BillingCountry, string BillingPostalCode) {
         //calling IAM OAG oAuth class to get the token details
         String responseBody='';
         try {
             String accessToken;
             HttpResponse response;
             if(Test.isRunningTest()) {
                 accessToken = 'lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz';
                 System.debug('#### In Test.isRunningTest - accessToken - '+accessToken);
             } else {
                 //accessToken = IAM_OAG_Authentication.getBearer('IAM_GL_oAuth'); - OAG Access Token
                 accessToken= IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_Mule_oAuth'); // class to get mule access token.
             }
 
             
             if (String.isNotBlank(BillingPostalCode)) {
                 if (String.isNotBlank(accessToken)) {
                     String ReqBody = IAM_GL_ReqParser.IAM_GL_ReqParserClass(billingStreet, BillingCity, BillingCountry, BillingPostalCode);
                     //getting Connection details for GL service 
                     //CSS_Integration_Details__c IAMcon = new CSS_Integration_Details__c();
                     //IAMcon = CSS_getConnnectionDetails.getConnection('IAM_GL_Service');
                     CSS_Integration_Details__c IAMcon = IAM_getConnnectionDetails.getConnection('IAM_Global_Locator_Mule');
                     Http http = new Http();
                     HttpRequest request = new HttpRequest();
                     request.setEndpoint(IAMcon.End_Point__c);
                     request.setHeader('Content-Type', 'application/json');
                     request.setHeader('Authorization', 'Bearer ' + accessToken);
                     request.setMethod(IAMcon.Method_Type__c);
                     request.setHeader('resource',IAMcon.Resource__c);
                     request.setBody(ReqBody);
                     System.debug('Printng request' + request);
                     System.debug('Printing request body' + request.getBody());
                     //if(!Test.isRunningTest()){
                         response = http.send(request);
                         responseBody=response.getBody();
                     /*}else{
                         responseBody='{"getSPSearchResultsReturn":{"cumminsLocationDTO":{"branchDTO":{"zipCode":"46241-0917","durationText":"53 mins","spName":"East - Indianapolis, In","countyDistrict":"Marion","hqCode":"02850","tollFreePhone":"800 792-3557","tollFreeFax":{"nil":true},"latitude":39.749269,"cityName":"Indianapolis","stateName":"Indiana","distanceText":"47.9 mi","marketProgram":{"nil":true},"spcode":"02651","fax":"317 240-1215","spLocType":101,"email":"kevin.gilles@cummins.com","longitude":-86.22155190000001,"address3":{"nil":true},"address2":{"nil":true},"address1":"3621 West Morris Street","webAddress":{"nil":true},"custServicePhone":{"nil":true},"amenityComments":{"nil":true},"distanceValue":0,"countryName":"United States","businessPhone":"317 244-7251","emergencyPhone":{"nil":true}},"hqDTO":{"nil":true}},"errorCode":{"nil":true},"spDTO":{"nil":true},"paginationDTO":{"nil":true},"langId":1,"omrResultFlag":{"nil":true}}}';
                     }*/
                     
                     if (String.isNotEmpty(responseBody)) {
                         // Deserializes the JSON string into collections of primitive data types.
                         IAM_GL_ResponseParser iam = IAM_GL_ResponseParser.parse(responseBody);
                         String branchdto = iam.getSPSearchResultsReturn.cumminsLocationDTO.branchDTO.hqCode;
                         System.debug('branchdto' + branchdto);
                         if (String.isNotBlank(branchdto)) {
                             List < Account > parentToBe = [select id, name from Account where IAM_Service_Provider_Code__c =: branchdto];
                             System.debug('Printing distributor account id that is account that is going to associated to be as a parent' + parentToBe);
                             if (!parentToBe.isEmpty()) {
                                 System.debug('accountId' + parentToBe[0].id);
                                 parentDistributorId = parentToBe[0].id;
                             } else {
                                 //Need to update Account with default because we do not have any such distributor locations
                             }
                         } else {
                             //Need to write logic to update the parent because return string is empty
                         }
                     } else {
                         //Need to write logic to assaign parent account id to a default factory account.Since response is not 200
                     }
                 } else {
                     //Need to write logic to assaign parent account id to a default factory account.
                 }
             } else {
                 //Since billing is null
             }
         } catch (exception e) {
             System.debug('Printing exception in catch' + e.getMessage());
             System.debug('Printing exception stack trace' + e.getStackTraceString());
         }
     }
 
 
     /*Public Static Void defaultParentUpdate(Account AccountToUpdate) {
         try {
             List < Account > CumminsAcnt = [select id, Name from Account where Name = 'Cummins'and Type = 'Factory'];
             System.debug('Printing Default parent account id' + CumminsAcnt);
             if (!CumminsAcnt.isEmpty()) {
                 // AccountToUpdate.parentid= CumminsAcnt[0].id;
                 // update AccountToUpdate;
             }
         } catch (exception e) {
             System.debug('Printing exception while updating the account with parent ' + e);
         }
     }*/
 }