global with sharing class IAM_CSTUserLocationOutboundHelper{
  
     @future (callout=true)    
    // After User Location updated 
      public static void CstUserLocationUpdate(Set<Id> conIds){
       String cstResponseBody=''; 
       Integer cstResponseStatusCode;    
       String cstRequestBody='';
       String accessToken='';
           HttpResponse response = new HttpResponse();
        try{
          //calling the cst loc Resquest class to generate json response.
          cstRequestBody= IAM_CST_Loc_Change_Req_Parser.newCSTUserLocationChangePayload(conIds);
          if(!String.isBlank(cstRequestBody)){
            //caling access token class to get the access token.
            CSS_Integration_Details__c IAMcon = new CSS_Integration_Details__c();
            IAMcon = CSS_getConnnectionDetails.getConnection('IAM_CST_User');
              if(!Test.isRunningTest()){
            	accessToken=IAM_CST_Authentication.getBearer('IAM_CST_User');
              }else{
                accessToken='name test taken';
              }
            if(!String.isBlank(accessToken)){
              Http http = new Http();
              HttpRequest request = new HttpRequest();
              request.setEndpoint(System.Label.IAM_Update_Service_Training_User_Location_URL);
              request.setHeader('Content-Type','application/json');
              request.setHeader('Authorization','Bearer '+accessToken);
              request.setMethod('POST');
               request.setTimeout(120000);
              request.setBody(cstRequestBody);
              System.debug('Printng request'+request);
              System.debug('Printing request body'+request.getBody()); 
                if(!Test.isRunningTest()){
                    response = http.send(request);
                     cstResponseBody = response.getBody();
                    cstResponseStatusCode=response.getStatusCode();
                }else{
                    cstResponseBody ='{'+
        '    \"error\": \"success\",'+
        '    \"error_description\": \"user location updated\",'+
        '    \"totalSize\": 1,'+
        '    \"userMessage\": \"user location updated\",'+
        '    \"records\": ['+
        '        {'+
        '            \"username\": \"usernamereclaim3@cmiuser.com\",'+
        '            \"status\": 1,'+
        '            \"message\": \"User moved\"'+
        '        }'+
        '    ]'+
        '}'; 
                    cstResponseStatusCode=200;
                }
                
                // If the request is successful, parse the JSON response.
               // System.debug('response statue' +response.getStatusCode() + response.getBody());
                
                if (cstResponseStatusCode == 200) {
                  if(!String.isBlank(cstResponseBody)){
                    IAM_CST_Loc_Change_Res_Parser responseParser= IAM_CST_Loc_Change_Res_Parser.parse(cstResponseBody);
                    System.debug('Printing response from CST service'+ responseParser.error);
                    if(responseParser.error.equalsIgnoreCase('success')){
                      List<IAM_CST_Loc_Change_Res_Parser.Records> records = responseParser.records;
                      boolean partialSucess = false;
                      for(IAM_CST_Loc_Change_Res_Parser.Records ip : responseParser.records){
                        if(!ip.message.equalsIgnoreCase('User moved')){
                          //partial success
                          partialSucess=true;
                        }
                      }
                      if(partialSucess){
                        //call iam identity error method.
                        IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API','Partial Success'+response.getBody());
                      }
                    }else{
                      //response from CST is error.
                      IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API','Error is CST Response'+response.getBody());
                    }
                  }else{
                    //Response from CST is blank
                    IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API','Response body is Empty'+response.getBody());
                  }
                }else{
                  //if response not equal to 200.
                  IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API','Response is not 200'+response.getBody());
                }
            }
          }
         }catch(Exception ex){
            System.debug('Exception in CST user creation' + ex);
            IAM_ErrorHandling.IAMerrorcapture(cstRequestBody,'IAM_CST_API','System Exception'+ex.getStackTraceString());
          }
     } 
  }