global with sharing class IAM_CSTUserStatusOutboundHelper{
    
    @future (callout=true)
    // After user status get updated 
      public static void CstUserStatusUpdate(Set<Id> conProvIds){
      // IAM_CST_OUT_User_wrapper ctsResponse{get;set;}
        IAM_Contact_Provisioning__c useRecords;
        String cstRequestBody='';
        String cstResponseValue='';
        String accessToken='';
        HttpResponse response = new HttpResponse();
        Map<id,IAM_Contact_Provisioning__c> conToconProvMap = new Map<id,IAM_Contact_Provisioning__c>();
        
        try{
          List<IAM_Contact_Provisioning__c> conProv= [SELECT id,IAM_Contact__c,IAM_Status__c FROM IAM_Contact_Provisioning__c WHERE id=:conProvIds];
          if(!conProv.isEmpty()){
            Set<id> conIds = new Set<id>();
            for(IAM_Contact_Provisioning__c cp:conProv){
              conIds.add(cp.IAM_Contact__c);
              if(!conToconProvMap.ContainsKey(cp.IAM_Contact__c)){
                conToconProvMap.put(cp.IAM_Contact__c,cp);
              }
            }
            if(!conIds.isEmpty()){
              //calling CST body class.
              cstRequestBody=IAM_CST_User_Status_Req_Parser.newCSTUserStatusPayload(conids,conToconProvMap);
              System.debug('Printing request body'+cstRequestBody);
              if(!String.isBlank(cstRequestBody)){
                //call CST access token to get token.
                CSS_Integration_Details__c IAMcon = new CSS_Integration_Details__c();
                IAMcon = CSS_getConnnectionDetails.getConnection('IAM_CST_User');
                  if(!Test.isRunningTest()){
                     accessToken=IAM_CST_Authentication.getBearer('IAM_CST_User'); 
                  }else{
                      accessToken='testacesstoken value';
                  }
                
                if(!String.isBlank(accessToken)){
                  Http http = new Http();
                  HttpRequest request = new HttpRequest();
                  request.setEndpoint(System.Label.IAM_Update_Service_Training_User_Status);
                  request.setHeader('Content-Type','application/json');
                  request.setHeader('Authorization','Bearer '+accessToken);
                  request.setMethod('POST');
                  request.setTimeout(120000);
                  request.setBody(cstRequestBody);
                  System.debug('Printng request'+request);
                  System.debug('Printing request body'+request.getBody()); 

                  if(!Test.isRunningTest()){  
                    response = http.send(request);
                    // If the request is successful, parse the JSON response.
                    System.debug('response statue' +response.getStatusCode() + response.getBody());
                    if(response.getStatusCode() == 200){
                      cstResponseValue = response.getBody();
                    }
                  }else{
                    cstResponseValue='{"totalSize": 1,"userMessage": "user created","records": {"id": 0,"LOGIN_ID": "some.email@someco.com1","SERVICE_TRAINING_ID": "1164157","FIRST_NAME": "Test","MIDDLE_NAME": "A","LAST_NAME": "Sfimuser","COMPANY_EMAIL": "some.email@someco.com1","COMPANY_PHONE": "888-555-1212","JOBCODE": "168","JOBTITLE": "Service - Technician","STATUS_ID": "1","STATUS": "Active","CREATED_BY_ID": "cst_dist_admin@cumminstest.com.iamdev","CREATED_DATE": "2018-09-11 14:55","LAST_MODIFIED_BY_ID": null,"LAST_MODIFIED_DATE": null,"SERVICE_PROVIDER_ID": "23170","SERVICE_PROVIDER_NAME": "BEDFORD FORD LINCOLN, INC.","SERVICE_PROVIDER_CITY": "BEDFORD","SERVICE_PROVIDER_STATE": "PENNSYLVANIA","SERVICE_PROVIDER_COUNTRY": "UNITED STATES OF AMERICA","SERVICE_PROVIDER_POSTAL_CODE": "15522-0158"}}';
                  } 
                  if (!String.isBlank(cstResponseValue)) {              
                    //Parsing the CST Response.
                    IAM_CST_User_Status_Res_Parser cstParsed = IAM_CST_User_Status_Res_Parser.parse(cstResponseValue);
                    System.debug('Printing Error or Success '+cstParsed.error);
                    if(!cstParsed.error.equalsIgnoreCase('success')){
                      //List<IAM_CST_User_Status_Res_Parser.Records> lstContacts = cstParsed.records;
                      //No Action Needed in case of Success.
                      System.debug('CST Status Update is Successfull.');
                    }else{
                      //Error Scenarion where response from CST is not succcess.
                      IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API',response.getBody());  
                    }
                  }else{
                    //Error Scenarion where CST Response is blank.
                    IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API',response.getBody());
                  } 
                }else{
                  //Error Scenario where Access token is Empty.
                  IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API','Access token is missing.');
                }
              }else{
                //Error Scenario where CST Request body is empty.
                IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API','CST Request Body is Empty.');
              }

            }else{
              //Error scenario where User Provisionings do not have Contacts.
              IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API','Contact  list is Empty.');
            }

          }else{
            //List of Contact Provisionings  is Empty. error Capture
            IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API','Contact Provisionings list is Empty.');
          }

        }catch(Exception ex){
          System.debug('Printing Exception'+ex.getStackTraceString());
          IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API',ex.getStackTraceString());
        }
      }   
        
  }