/************************************************************
Name:  IAM_RSWOutboundHelper
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Class for RSW out bound service                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Golakaram       09/02/2020        INITIAL DEVELOPMENT 
1.1 -    Karthik Golakaram       12/09/2020    Made changes for Mule API conversion.   
1.2 -    Chetan Gaikwad          07/01/2021    Made changes for tracking failure outbound call records
*****************************************************/
global class IAM_RSWOutboundHelper{
  
   @future (callout=true)
    public static void RSWOutboundCall(Id appId){  
       //code start - declaring string outside try block to use it later - Chetan Gaikwad 07/01/2021
       String rsRegister=''; 
       try{  
                rsRegister =IAM_RSW_OutBoundReqParser.IAM_RSW_ReqParserClass(appId);
                System.debug('Printing registration payload'+rsRegister);
                //String accessToken = IAM_RSW_Authentication.getBearer();
                //String accessToken=IAM_OAG_getoAuthToken.getAccessToken('IAM_RSW_oAuth');
                
                String accessToken = IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_Mule_oAuth');
                CSS_Integration_Details__c iamRSW = IAM_getConnnectionDetails.getConnection('IAM_RSW_Registration_Mule');
                Http http = new Http();
                HttpResponse response;
                HttpRequest request = new HttpRequest();
                request.setEndpoint(iamRSW.End_Point__c);
                request.setHeader('Content-Type','application/json');
                request.setHeader('Authorization','Bearer '+accessToken);
                request.setMethod(iamRSW.Method_Type__c);
                request.setHeader('resource', iamRSW.Resource__c);
                request.setBody(rsRegister);
                System.debug('Printng request'+request);
                System.debug('Printing request body'+request.getBody()); 
   
             response = http.send(request);
             // If the request is successful, parse the JSON response.
             System.debug('response status' +response.getStatus() + response.getBody() +response.getStatusCode());
             
              IAM_Contact_Provisioning__c rswUseRecords = [select id,IAM_RSW_Status__c from IAM_Contact_Provisioning__c where id=:appId];
             //code start - checking success or failure and tracking response for failure - Chetan Gaikwad 07/01/2021
             if(response.getStatusCode() == 200) {
               IAM_RSW_OutBoundReqParser.DataArea rswResponseValue = IAM_RSW_OutBoundReqParser.getResponseuserrequest(response.getBody());
               //{"DataArea":{"Description":"Recored Successfully Inserted","StatusCode":200}}200
               system.debug('Hey, You succeded to desrialize response');
               system.debug('@response - '+response.getBody());
               
               string MWStatus=string.valueof(rswResponseValue.StatusCode);
               if(rswResponseValue.StatusCode == 200 && rswResponseValue.Description.contains('Success')){
                  rswUseRecords.IAM_RSW_Status__c = '200';
                  update rswUseRecords;
               }else {
                  rswUseRecords.IAM_RSW_Status__c = MWStatus;
                  update rswUseRecords;
                  IAM_ErrorHandling.IAMerrorcapture(rsRegister,'IDENTITY-RSW',rswResponseValue.Description);
               }
             } else{
                  string Status=string.valueof(response.getStatusCode());
                  string responsebody = string.valueof(response.getBody());
                  rswUseRecords.IAM_RSW_Status__c = Status;
                  update rswUseRecords;
                  IAM_ErrorHandling.IAMerrorcapture(rsRegister,'IDENTITY-RSW',responsebody);
               }  
             //code end - checking success or failure and tracking response for failure - Chetan Gaikwad 07/01/2021       
         } 
        catch(Exception ex){
           System.debug('Exception in RSW user creation' + ex);
           System.debug('Printing Stack Trace String'+ex.getStackTraceString());
           //code start - capturing error in IAM_ErrorHandling class for exceptions - Chetan Gaikwad - 07/01/2021
           String msg = ex.getMessage();
           msg = msg + '<br>Details: '+ ex.getStackTraceString();
           IAM_ErrorHandling.IAMerrorcapture(rsRegister,'IDENTITY-RSW',msg);
           //code end - capturing error in IAM_ErrorHandling class for exceptions - Chetan Gaikwad - 07/01/2021
         }
    }  
           
   }