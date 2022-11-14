global with sharing class IAM_CSTUserOutboundHelper{
    
  @future (callout=true)
  // After new user created
  public static void CstOutboundCall(Set<Id> conProvId){
      
      System.debug('Printing the size of the list'+conProvId.Size());
      String cstResponseValue='';
      String cstUser;
      String cstBody='';
      Integer cstResponseStatusCode;
      String accessToken='';
      Map<String,IAM_Contact_Provisioning__c> conProvMap = new Map<String, IAM_Contact_Provisioning__c>();
      Map<String,Contact> conMap= new Map<String,Contact>();
      HttpResponse response=new HttpResponse();
      try{
          if(!conProvId.isEmpty()){
              Set<id> ConIds = new Set<id>(); //Variable to store contact IDS.
                  List<IAM_Contact_Provisioning__c> conProv= [SELECT id,IAM_Contact__c,IAM_Contact__r.Username__c,IAM_Promotion__c FROM IAM_Contact_Provisioning__c WHERE id=:conProvId AND IAM_Status__c='Active'];
              
              if(!conProv.isEmpty()){
                  for(IAM_Contact_Provisioning__c cp:conProv){
                      ConIds.add(cp.IAM_Contact__c);
                      if(!conProvMap.ContainsKey(cp.IAM_Contact__r.Username__c)){
                        ConProvMap.put(cp.IAM_Contact__r.Username__c,cp);
                      }
                  }
              }
              
              System.debug('Printing the Size of the Contact IDs Set'+ConIds.Size());
              if(!ConIds.isEmpty()){
                  //Calling Request Parser class to get the body.
                  cstBody=IAM_CST_ReqParserNew.newCSTPayload(ConIds);
                  if(!String.isBlank(cstBody)){
                      //making call to call get the Authentication token.
                      CSS_Integration_Details__c IAMcon = new CSS_Integration_Details__c();
                      IAMcon = CSS_getConnnectionDetails.getConnection('IAM_CST_User');
                      if(!Test.isRunningTest()){
                          accessToken=IAM_CST_Authentication.getBearer('IAM_CST_User'); 
                      }else{
                          accessToken='value is okokokoko access Token'; 
                      }
                       if(!String.isBlank(accessToken)){
                          Http http = new Http();
                          HttpRequest request = new HttpRequest();
                          request.setEndpoint(Label.IAM_Create_Service_Training_User);
                          request.setHeader('Content-Type','application/json');
                          request.setHeader('Authorization','Bearer '+accessToken);
                          request.setMethod('POST');
                          request.setTimeout(120000);
                          request.setBody(cstBody);
                          if(!Test.isRunningTest()){  
                              response = http.send(request);
                              cstResponseValue = response.getBody();
                              cstResponseStatusCode=response.getStatusCode();
                              }else{
                              cstResponseValue='{"error":"success","error_description":"user created","totalSize":1,"userMessage":"user created","records":[{"username":"usernamereclaim3@cmiuser.com","status":1,"message":"User Added","service_training_id":"1164296"}]}';
                          		cstResponseStatusCode=200;
                              }
                              if (cstResponseStatusCode == 200 ) {
                                  
                                  System.debug('response status' +response.getStatus() + response.getBody());
                                  //calling the respective PArser class to update the contacts and provisionings.
                                  IAM_CST_Create_Res_Parser_New respBody= IAM_CST_Create_Res_Parser_New.Parse(cstResponseValue);
                                  System.debug('Priniting response body partialized'+respBody);
                                  System.debug('Prinitng list of records'+respBody.records);
                                  List<IAM_CST_Create_Res_Parser_New.Records> cstIDRecords= respBody.records;
                                  List<Contact> conUpdate= [SELECT id,Username__c,IAM_Promotion__C from Contact WHERE id=:ConIds];
                                  if(!conUpdate.isEmpty()){
                                    for(Contact C:conUpdate)
                                    if(!conMap.ContainsKey(c.Username__c)){
                                      conMap.put(c.Username__c,c);
                                    }
                                  }
                                  if(respBody.error.endsWithIgnoreCase('success')){
                                    System.debug('Printing inside Success');
                                      if(!cstIDRecords.isEmpty()){
                                        for(IAM_CST_Create_Res_Parser_New.Records rec: cstIDRecords){
                                          if(rec.status==1){
                                            if(!conProvMap.isEmpty()){
                                              if(conProvMap.ContainsKey(rec.username)){
                                                conProvMap.get(rec.Username).IAM_Promotion__c=rec.service_training_id;
                                              }
                                            }
                                            
                                            if(!conMap.isEmpty()){
                                              if(conMap.containsKey(rec.username)){
                                                conMap.get(rec.username).IAM_Promotion__c=rec.service_training_id;
                                              }
                                            }
                                          }
                                        }

                                        //Performing an Update DML Stamenet on Both the Contact and Contact Provisioning Objects.
                                        System.debug('Printing before update');
                                        Update conUpdate;
                                        Update conProv;
                                      }
                                  }else{
                                    //response from the cst API is not success from error variable
                                    IAM_ErrorHandling.IAMerrorcapture(cstBody,'IAM_CST_API',response.getBody());
                                  }  
                              }else{
                                //response is not 200.SELECT 
                                IAM_ErrorHandling.IAMerrorcapture(cstBody,'IAM_CST_API',response.getBody());
                              }
                      }else{
                          //Access token is empty
                          IAM_ErrorHandling.IAMerrorcapture(cstBody,'IAM_CST_API','Access Token not generated.');
                      }
                  }else{
                      //if JSON request body is empty
                      IAM_ErrorHandling.IAMerrorcapture(cstBody,'IAM_CST_API','JSON Body not got generated not generated.');
                  }
              }else{
                  //Contact list is empty.
                  IAM_ErrorHandling.IAMerrorcapture(cstBody,'IAM_CST_API','Contact list is Empty.');
              }
          }
        }catch(exception ex){
            System.debug('Priniting Exception'+ex.getStackTraceString());
            IAM_ErrorHandling.IAMerrorcapture(cstBody,'IAM_CST_API',ex.getStackTraceString());     
        }
             
  } 
             
             
             
             /*  public static String getCstOuboundUpdate(User userCreate){
String cstUser ='';
IAM_CST_OUT_User_wrapper cstOut = new IAM_CST_OUT_User_wrapper();
cstOut.FIRST_NAME = userCreate.FirstName;
cstOut.MIDDLE_NAME = userCreate.LastName;
cstOut.LAST_NAME =userCreate.LastName;
cstOut.COMPANY_EMAIL =userCreate.Email;
cstOut.COMPANY_PHONE =userCreate.Phone;
cstOut.sp_code =userCreate.IAM_Customercode__c;         
cstOut.username =userCreate.Username;         
cstOut.current_username = UserInfo.getUserEmail();
cstUser = JSON.serialize(cstOut); 
System.debug('cstUser' + cstUser);
return cstUser;
} */
             
             }