global class IAM_CSTUserOutboundHelper_Reclaim{
  
     
    public static String CstOutboundCall(String firstname,String lastname,string email,string phone,string spCode,string ContactId,String oldUserName,String NewUserName){
    
    //System.debug('Printing user Id'+userId);
    System.debug('Printing Old User Id'+oldUserName);
    System.debug('Printing New UserName'+newUserNAme);
       User useRecords;
       String cstUser;
       String Trainingcode='';
        try{
              System.debug('Printing User details'+useRecords);
              cstUser ='first_name='+firstname+'&middle_name='+'&last_name='+lastname+'&company_email='+email+'&company_phone='+phone+'&sp_code='+spCode+'&username='+NewUserName+'&current_username='+UserInfo.getUserName()+'&sfiam_id='+Contactid+'&previous_username='+oldUserName;
             
            CSS_Integration_Details__c IAMcon = new CSS_Integration_Details__c();
             IAMcon = CSS_getConnnectionDetails.getConnection('IAM_CST_User');
             String accessToken=IAM_CST_Authentication.getBearer('IAM_CST_User');
                  Http http = new Http();
                  HttpRequest request = new HttpRequest();
                  request.setEndpoint(Label.IAM_Create_Service_Training_User);
                  request.setHeader('Content-Type','application/x-www-form-urlencoded');
                  request.setHeader('Authorization','Bearer '+accessToken);
                  request.setMethod('POST');
                  request.setBody(cstUser);
                  System.debug('Printng request'+request);
                  System.debug('Printing request body'+request.getBody()); 

              HttpResponse response = new HttpResponse();
              if(!Test.isRunningTest()){
                  response= http.send(request);
              }else{
                  HttpResponse responseTest= new HttpResponse();
                responseTest.setStatusCode(200);
                responseTest.setBody(System.Label.IAM_LDAP_Success_Messgae);
                response=responseTest;
              }
              // If the request is successful, parse the JSON response.
                            System.debug('response status' +response.getStatus() + response.getBody());

              System.debug('response status' +response.getStatusCode() + response.getBody());
              String cstResponseValue = response.getBody(); 
              if (response.getStatusCode() == 200 ) {
               IAM_CST_OUT_User_wrapper ctsResponse = (IAM_CST_OUT_User_wrapper)System.JSON.deserialize(cstResponseValue, IAM_CST_OUT_User_wrapper.class);
                 if(ctsResponse.records.SERVICE_TRAINING_ID!=null && ctsResponse.totalSize==1){ 
                    system.debug('Service training ID in response:'+ctsResponse.records.SERVICE_TRAINING_ID);            
                   if(String.isNotBlank(ctsResponse.records.SERVICE_TRAINING_ID)){
                     Trainingcode=ctsResponse.records.SERVICE_TRAINING_ID;
                     }else{
                         TrainingCode='error';
                     }
                     
                  
                  }   
             }
         }catch(Exception ex){
            System.debug('Exception in CST user creation' + ex);
             System.debug('Printing Stack Trace string'+ex.getStackTraceString());
          }
          
          return Trainingcode;
     } 
              
 
       
  }