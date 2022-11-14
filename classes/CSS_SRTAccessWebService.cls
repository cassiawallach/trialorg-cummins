/**********************************************************************
Name:CSS_SRTAccessWebService
Copyright © 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
We are using this Webservice to receive Access SRTs.

===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR                    DATE                  DETAIL                                 
1.0                                                     INITIAL DEVELOPMENT
2.0      Miruthula Kanagaraj        04/17/2019          Added SRT fields & mapped to ECMFlag, PrivateFlag, Regions from response  #179757
*******************************************************************************/

public class CSS_SRTAccessWebService{
    
    public static string splreceiveToken(string sConn){
        
        string accessToken;
        string endPoint;
        HttpResponse res = new HttpResponse();
        
        try{
            HttpRequest req = new HttpRequest();
            Http oagHTTP = new Http();
            string client_id;
            string client_secret;
            string sConnection;
            system.debug('splreceiveToken before sConnection, the sConn value is: ' + sConn);
            
            if (sConn == null) {sConnection = 'OAGOAuth';} else {sConnection = sConn;}
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            system.debug('splreceiveToken before Endpoint fetch connection value is: ' + sConnection);
            
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection(sConnection);
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c; 
            }
            else{
                endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                client_id = 'd65101fd-601d-410a-9b12-8a72a6d98fae';
                client_secret = '7b398614-6612-4d52-9687-04fa654083bd';
            }
            system.debug('splreceiveToken after Endpoint fetch Endpoint value is: ' + endPoint);
            
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
            
            if(!Test.isRunningTest()){
            res = oagHTTP.send(req);
            }else{
                res.setBody('{"access_token":"94pPkrL0Yt2guPTJJxM9PYTxZZ8it2YYy2twpGN8q7EN313l1GU6sX","token_type":"Bearer","expires_in":24000,"refresh_token":"VGaPh5uivMb7vtGUoT7aXeN9pyaa0QiYH7Im1qE7g7WNLZ","scope":"CSSCloud"}');
                res.setStatusCode(200);
            }
            system.debug('splreceiveToken after request, response value is: ' + res.getBody());
            
            string jSONResponseBody = res.getBody();
            
            CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONResponseBody,CSS_J2AToken_SRT.class); 
            accessToken = wo1.access_token;
            system.debug('splreceiveToken after parsing request, accessToken value is: ' + accessToken);
        }
        catch (exception e) {
            System.debug('accessToken Error in splreceiveToken method for '+ sConn +' is: ' + e.getLineNumber() + e.getMessage());
            accessToken = 'ERROR';
            if(!Test.isRunningTest()){
            css_utility.LogOutIntError(endPoint,e.getMessage()+'- OAG Token', res==null?'RESPONSE IS NULL':res.getBody(), 'BMSLOGIN');
            }
        }
        System.debug('accessToken Value in splreceiveToken method for '+ sConn +' set to: ' + accessToken );
        
        return accessToken;
    }
    
    public static string receiveToken(){
        
        HttpRequest req = new HttpRequest();
        Http http = new Http(); 
        string endPoint;
        string client_id;
        string client_secret;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        if(!Test.isRunningTest()){
            conDetails = CSS_getConnnectionDetails.getConnection('OAGOAuth');
            endPoint = conDetails.End_Point__c;
            client_id = conDetails.Username__c;   
            client_secret = ConDetails.Passcode__c;
        }
        else{
            endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
            client_id = 'd65101fd-601d-410a-9b12-8a72a6d98fae';
            client_secret = '7b398614-6612-4d52-9687-04fa654083bd';
        }
        
        req.setEndpoint(endPoint);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
        req.setTimeout(120000);
        
        HttpResponse res = http.send(req);
        string jSONRequestBody = res.getBody();
        CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
        string accessToken = wo1.access_token;
        System.debug('BODY: '+res.getBody());  
        System.debug('Status: '+res.getStatus());
        System.debug('Status Code: '+res.getStatusCode());
        return accessToken;
    }
    
    public static List<css_JobEventTemporary__c> accessSRT(Id SolId,string equipID, string serviceModelName, String engineFamilyCode){
        
        string accessToken;
        Boolean acSrtRetry;
        Integer acSrtRetryCount = 1;
        
        List<CSS_JobEventTemporary__c> srtempList= new List<CSS_JobEventTemporary__c >();
          do{
              acSrtRetry=FALSE;
              try
              {
                if(!Test.isRunningTest()){
                  accessToken=splreceiveToken(Label.CSS_SRTAltOAuth);
                 }
                else{
                accessToken ='Test';
                 }
                 
            HttpRequest req = new HttpRequest();   
            
            string equipmentID =equipID; //'EQ7667';
            string serviceModel = serviceModelName;//'ISL9 CM2250';
            string endPoint;    
           // req.setEndpoint('https://services-dev.cummins.com/css/RetrieveStandardRepairTime');
           
           if(!Test.isRunningTest()){
             endPoint = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;
           }
           else{
             endPoint ='https://services-dev.cummins.com/css/RetrieveStandardRepairTime';
            }
            system.debug('endPoint=====>'+endPoint);
            
            req.setEndpoint(endPoint);
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer '+accessToken);
            
            string accessRequest = '{"Header":{"Sender":{"MessageID": "unique message ID at SF","SenderID": "SF","ServiceName": "Eg:GetStandardRepairTime"},"Target":{"TargetID":"SRT"}},';
            accessRequest = accessRequest + '"DataArea":{"EngineFamilyCode": "'+engineFamilyCode+'","EquipmentID": "'+equipmentID +'","ServiceModelName": "'+serviceModel+'","SRTType":"ACC"}}'; 
            System.debug('The accessRequest is!@!@#'+accessRequest);
            
            req.setBody(accessRequest);
            req.setMethod('POST');
            req.setTimeout(120000);
            
            Http http = new Http();     
            HTTPResponse res = new HTTPResponse();
            if(!Test.isRunningTest()){
                res = http.send(req);                    
            }
            else{
                res.setBody('{"DataArea":{"CaseResponse":[{"SRTTitle":"Air Cleaner Assembly (Including Bracket) - Remove and Install, Each","SRTDetails":"10-117","SRTID":116840},{"SRTTitle":"Vehicle Fairing - Remove and Install","SRTDetails":"17-185","SRTID":109690},{"SRTTitle":"Vehicle Steps - Remove and Install","SRTDetails":"17-184","SRTID":109689},{"SRTTitle":"DUMMY"},{"SRTTitle":"DUMMY"}],"ResponseMessage":""},"Header":{"ReturnCodeDescription":"","Status":"Success"}}');                
            }
            
           string jSONRequestBody = res.getBody();
           System.debug('The body is'+jSONRequestBody);
           
          //try {
              if(jSONRequestBody.contains('No SRT Found')){
                   System.debug('Incorrect json format');
                   System.debug('BODY: '+res.getBody());
                   System.debug('STATUS:'+res.getStatus());
                   System.debug('STATUS_CODE:'+res.getStatusCode());
                   return srtempList;
                }
              else{
               // string jSONRequestBody = res.getBody();
                CSS_J2AAccess_SRT wo1 = (CSS_J2AAccess_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AAccess_SRT.class);
                System.debug('The srt id is'+wo1);
                System.debug('BODY: '+res.getBody());
                System.debug('STATUS:'+res.getStatus());
                System.debug('STATUS_CODE:'+res.getStatusCode());
                
                List<CSS_JobEventTemporary__c> delsrtList= new List<CSS_JobEventTemporary__c>();
                for(integer i=0;i<wo1.DataArea.CaseResponse.size();i++){
                    
                    //The Access SRTs are temporarily stored in JET object.
                    CSS_JobEventTemporary__c srtemp = new CSS_JobEventTemporary__c();
                  if(wo1.DataArea.CaseResponse[i].SRTTitle.equalsIgnoreCase('Dummy') ||
                      wo1.DataArea.CaseResponse[i].SRTTitle.equalsIgnoreCase('No Configuration Found')){
                        srtemp.Attribute3__c = wo1.DataArea.CaseResponse[i].SRTTitle;
                  } else {
                        srtemp.Attribute1__c = enginefamilycode;
                        srtemp.Attribute2__c = equipmentID;
                        srtemp.Attribute3__c = string.valueof(wo1.DataArea.CaseResponse[i].SRTID);//SRT ID
                        srtemp.Attribute4__c = wo1.DataArea.CaseResponse[i].SRTTitle; // SRT Title
                        srtemp.Attribute5__c = wo1.DataArea.CaseResponse[i].SRTDetails; // SRT details
                        srtemp.Attribute6__c = SolId; // Solution ID
                        srtemp.Attribute7__c = wo1.DataArea.CaseResponse[i].ECMFlag;//ECM Flag
                        srtemp.Attribute8__c = wo1.DataArea.CaseResponse[i].PrivateFlag; //Private Flag
                        srtemp.Attribute9__c = wo1.DataArea.CaseResponse[i].Regions; // Regions
                        srtemp.Service_Model_Name__c=serviceModel;
                    srtempList.add(srtemp);
                  }  
                }
                 System.debug('Srt details : '+srtempList);
                     return srtempList;
               }
           } Catch (Exception e) {
               String message = e.getMessage(); //System.CalloutException e
               system.debug('exception message is -->'+ e.getTypeName());
               if(message.equalsignorecase('Read timed out') || e.getTypeName() == 'System.CalloutException'){
                   acSrtRetryCount = acSrtRetryCount + 1; 
                   acSrtRetry = TRUE;
                    system.debug('retryValue is -->' +acSrtRetryCount);
                    system.debug('reTry flag is -->' +acSrtRetry); 
               }
               System.debug('SRT Service is Down--->'+e);
           }
     }while(acSrtRetryCount <= integer.valueof(Label.CSS_SRT_RETRY_TIME) && acSrtRetry == TRUE);
        return srtempList;
    }
    
    public static Decimal accessSRTStepDetails(string equipId,string stepid){
        
           string accessToken;
           Boolean acSrtStpRetry;
           Integer acSrtStpRetryCnt=1;
           //CSS_SRT__c srtTimeToUpdate = new CSS_SRT__c();
           Decimal iSRTime =0.0;
        do
        {
            acSrtStpRetry=FALSE;
        try{
             if(!Test.isRunningTest()){
               accessToken=splreceiveToken(Label.CSS_SRTAltOAuth);
              }
            else{
                accessToken ='Test';
            }                       
            System.debug('The step id is'+stepid);                       
            System.debug('*****Equipment ID '+equipId);
      
            HttpRequest req = new HttpRequest();           
            string endPoint;   
                //integer SRTstepId = Integer.valueof(stepid);
                         if(!Test.isRunningTest()){
           
                endPoint = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;
           }
               else{
            endPoint ='https://services-dev.cummins.com/css/RetrieveStandardRepairTime';
                   }
                 
                req.setEndpoint(endPoint);
                req.setHeader('Content-Type','application/json');
                req.setHeader('Authorization', 'Bearer '+accessToken);
                string accessRequest = '{"Header":{"Sender":{"MessageID": "unique message ID at SF","SenderID": "SF","ServiceName": "Eg:GetStandardRepairTime"},"Target": {"TargetID": "SRT"}},';
                accessRequest = accessRequest + '"DataArea": {"EquipmentID": "'+equipID +'","SRTType": "SRT_D","StepID":"'+stepId+'",}}'; 
                System.debug('The accessRequest is!@!@#'+accessRequest);
                req.setBody(accessRequest);
                req.setMethod('POST');     
                req.setTimeout(120000);
                Http http = new Http();    
                HTTPResponse res;               
                if(!Test.isRunningTest()){
                    res = http.send(req);
                }
              else{
                    res.setBody('{"DataArea":{"CaseResponse":[{"SRTTitle":"Air Governor - Remove and Install","SRTContent":"(Refer to the appropriate Troubleshooting and\nRepair Manual)\nIncludes:\n -Remove and install cover\n -Adjust\n -Operate engine to check for proper operation","SRTTime":0.2,"SRTAccessCode":"C","SRTGroupProcedure":"12-104"},{"SRTTitle":"DUMMY"},{"SRTTitle":"DUMMY"}],"ResponseMessage":""},"Header":{"ReturnCodeDescription":"","Status":"Success"}}');                               
                }
                
                string jSONRequestBody = res.getBody();
                System.debug('The body is'+jSONRequestBody);
                CSS_J2AAccessStepDetails_SRT wo1 = (CSS_J2AAccessStepDetails_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AAccessStepDetails_SRT.class);
                System.debug('The srt id is'+wo1);
                system.debug('**2ndmethodwo1.DataArea**'+wo1.DataArea );
                system.debug('**2ndMethodwo1.DataArea.CaseResponse **'+wo1.DataArea.CaseResponse );
                system.debug('**wo1.DataArea**'+wo1.DataArea );
                system.debug('**wo1.DataArea.CaseResponse **'+wo1.DataArea.CaseResponse );
                system.debug('**2ndMethodwo1.DataArea.CaseResponsesize **'+wo1.DataArea.CaseResponse.size() );
                
                if(wo1.DataArea.CaseResponse!=null){
                    for(integer a=0;a<wo1.DataArea.CaseResponse.size();a++){
                        /*system.debug('***wo1.DataArea.CaseResponse[a].SRTTime-->'+wo1.DataArea.CaseResponse[a].SRTTime); 
                        system.debug('***stepid-->'+stepid); 
                        system.debug('***wo1.DataArea.CaseResponse[a].SRTGroupProcedure-->'+wo1.DataArea.CaseResponse[a].SRTGroupProcedure);                      
                        if(wo1.DataArea.CaseResponse[a].SRTAccessCode != null){                        
                            srtTimeToUpdate.Access_Code__c=wo1.DataArea.CaseResponse[a].SRTAccessCode;
                        }*/
                        if(wo1.DataArea.CaseResponse[a].SRTTime != null){
                            iSRTime  = wo1.DataArea.CaseResponse[a].SRTTime; //* 60); Anirudh
                        }                    
                    }
                }
                System.debug('srtTimeToUpdate--->'+iSRTime ); 
            }               
            catch(exception e){
                iSRTime =0;
                String exMessage = e.getMessage(); //System.CalloutException e
                String exType = e.getTypeName();
                system.debug('exception message is -->'+ e.getTypeName());
                if(exMessage.equalsignorecase('Read timed out') || exType.contains('CalloutException')){
                    acSrtStpRetryCnt = acSrtStpRetryCnt + 1;
                    acSrtStpRetry=TRUE;
                }
               // srtIntegrationError(e.getMessage());
                System.debug('ERROR Message:-->:'+ e);
            }
       }while(acSrtStpRetryCnt <= integer.valueof(Label.CSS_SRT_RETRY_TIME) && acSrtStpRetry == TRUE);
            return iSRTime ;
    } 
    //Method added for the story#172627
    public static CSS_J2AAccessStepDetails_SRT accessSRTStepDetails_New(string equipId,string stepid){
        
           string accessToken;
           Boolean acSrtStpRetry;
           Integer acSrtStpRetryCnt=1;
           //CSS_SRT__c srtTimeToUpdate = new CSS_SRT__c();
           Decimal iSRTime =0.0;
           CSS_J2AAccessStepDetails_SRT wo1 = new CSS_J2AAccessStepDetails_SRT();
        do
        {
            acSrtStpRetry=FALSE;
        try{
             if(!Test.isRunningTest()){
               accessToken=splreceiveToken(Label.CSS_SRTAltOAuth);
              }
            else{
                accessToken ='Test';
            }                       
            System.debug('The step id is'+stepid);                       
            System.debug('*****Equipment ID '+equipId);
      
            HttpRequest req = new HttpRequest();           
            string endPoint;   
                //integer SRTstepId = Integer.valueof(stepid);
                         if(!Test.isRunningTest()){
           
                endPoint = CSS_getConnnectionDetails.getConnection('SRT').End_Point__c;
           }
               else{
            endPoint ='https://services-dev.cummins.com/css/RetrieveStandardRepairTime';
                   }
                 
                req.setEndpoint(endPoint);
                req.setHeader('Content-Type','application/json');
                req.setHeader('Authorization', 'Bearer '+accessToken);
                string accessRequest = '{"Header":{"Sender":{"MessageID": "unique message ID at SF","SenderID": "SF","ServiceName": "Eg:GetStandardRepairTime"},"Target": {"TargetID": "SRT"}},';
                accessRequest = accessRequest + '"DataArea": {"EquipmentID": "'+equipID +'","SRTType": "SRT_D","StepID":"'+stepId+'",}}'; 
                System.debug('The accessRequest is!@!@#'+accessRequest);
                req.setBody(accessRequest);
                req.setMethod('POST');     
                req.setTimeout(120000);
                Http http = new Http();    
                HTTPResponse res;               
                if(!Test.isRunningTest()){
                    res = http.send(req);
                }
              else{
                  res = new HttpResponse();
                  res.setHeader('Content-Type', 'application/json');
                  res.setStatusCode(200); 
                    res.setBody('{"DataArea":{"CaseResponse":[{"SRTTitle":"Air Governor - Remove and Install","SRTContent":"(Refer to the appropriate Troubleshooting and Repair Manual)Includes: -Remove and install cover -Adjust -Operate engine to check for proper operation","SRTTime":0.2,"SRTAccessCode":"C","SRTGroupProcedure":"12-104"},{"SRTTitle":"DUMMY"},{"SRTTitle":"DUMMY"}],"ResponseMessage":""},"Header":{"ReturnCodeDescription":"","Status":"Success"}}');
                }
                
                string jSONRequestBody = res.getBody();
                System.debug('The body is'+jSONRequestBody);
                wo1 = (CSS_J2AAccessStepDetails_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AAccessStepDetails_SRT.class);
               
            }               
            catch(exception e){
                iSRTime =0;
              
                String exMessage = e.getMessage(); //System.CalloutException e
                String exType = e.getTypeName();
                system.debug('exception message is -->'+ e.getTypeName());
                if(exMessage.equalsignorecase('Read timed out') || exType.contains('CalloutException')){
                    acSrtStpRetryCnt = acSrtStpRetryCnt + 1;
                    acSrtStpRetry=TRUE;
                }
             
                System.debug('ERROR Message:-->:'+ e);
            }
       }while(acSrtStpRetryCnt <= integer.valueof(Label.CSS_SRT_RETRY_TIME) && acSrtStpRetry == TRUE);
            return wo1 ;
    } 
    
    public static void srtIntegrationError(String msg){
        
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c='SRT';
        errObj.Error_Description__c = msg;
        insert errObj;
    }

    }