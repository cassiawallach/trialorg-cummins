public class CSS_RPV {
    public static CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
    @future(callout=true)
    public static void repeatVisit(string vpersonType, string vesn, decimal vmiles, string vmileage, string vequipID, string vcssJobNum, string vdsid, datetime vDSIDCrDt, string vcontrolNum, ID vJobId){
        //    public static void repeatVisit(){    
        //try{ 
            
            string personType = vpersonType;
            string accessToken;
            HttpRequest req = new HttpRequest();
            string esn = vesn;
            string miles = string.valueOf(vmiles);
            string cssJobNum = vcssJobNum;
            string equipID;
            if (vequipID==null){
                equipID = '';
            }else {equipID = vequipID;}
            
            string controlNum;//12770007
            
            if (vcontrolNum==null){
                controlNum = '';
            }else {controlNum = vcontrolNum;}
            
            
            string dsid;//DSBKD5715
            
            if (vdsid==null){
                dsid = '';
            }else {dsid = vdsid;}
            
            string mileage; //=vmileage;
            
            if(vmileage=='Miles'){
                mileage = 'MI';
            } else if(vmileage=='Kilometers'){
                mileage = 'KM';
            } else {
                mileage = 'HR';
            }
            
            
            
            string DISIDCrDt=string.valueOf(vDSIDCrDt); 
            
            if (DISIDCrDt==null){
                DISIDCrDt = '';
            }
            
            string endPoint;
            string client_id;
            string client_secret;
            if (miles!=null){
                string timestamp=string.valueof(system.now());  //"MM-DD-YYYY HH:MM:SS"
                 CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                if(!Test.isRunningTest()){
                conDetails =CSS_getConnnectionDetails.getConnection('RPV');
                endPoint = conDetails.End_Point__c; 
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c;
                //accessToken=CSS_SRT.receiveToken();  //Commented for dynamic Authentication and added below lines
                    //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('RPV').AuthEnv__c);//Commented the line as part of Mule Integration
                    CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('RPV').AuthEnv__c,'RPV');
                    accesstoken = accessTokenOPWrap.accessToken;    
                }else{
                    endPoint = 'https://services-dev.cummins.com/css/QueryRepeatVisitFlag';
                    accessToken='Test';
                    client_id = 'gyr3X2qsCi4mIivcj4ndefGc5yNJn9+G8TSMoejZCitMlkQFo8DBQ4Ycy+gW6zsEnJVsmhPqBltCUnutiFXf7w==';   
                    client_secret = 'UZvRxj9SjjcepsRMWDHhuQduplleXWBfrWhodykLHcOBMci7kZ+Pil8ZRfPCDz5vRH/JbvXoZ19qBi5A0EJ0oA==';
                }
                req.setEndpoint(endPoint);
                req.setHeader('Content-Type','application/json');
                req.setHeader('client-id',client_id);
                req.setHeader('client-secret',client_secret);
                req.setHeader('Authorization', 'Bearer '+accessToken);
                string rpvRequest='{"Header":{"Sender":{"MessageID": "unique message ID at SF","ServiceName": "ServiceRequest","SenderID": "SF"},"Target":{"TargetID":"RPV"}},';
                rpvRequest = rpvRequest + '"DataArea":{"ESN":"'+esn+'","Mileage": "'+miles+'","MileageMSR":"'+mileage+'","FailDate": "","JobNumber":"'+cssJobNum+'","DealerDistributorFlag": "'+personType+'",'; 
                rpvRequest = rpvRequest + '"ControlNumber": "'+controlNum+'","DSID": "'+dsid+'","DSIDOpenedDate":"'+DISIDCrDt+'","TimeStamp":"'+timestamp+'" }}';
                System.debug('The repairRequest is!@!@#'+rpvRequest);
                req.setBody(rpvRequest);
                req.setMethod('POST');
                Http http = new Http();
                HTTPResponse res = http.send(req);
                string jSONRequestBody = res.getBody();
                System.debug('The body is'+jSONRequestBody);
                //req.setTimeout(120000);
                CSS_J2ARPV wo5 = (CSS_J2ARPV)JSON.deserializeStrict(jSONRequestBody,CSS_J2ARPV.class);
                
                if(wo5.DataArea!=null){  
                    System.debug('The json format is'+wo5);
                    System.debug('BODY: '+res.getBody());
                    System.debug('STATUS:'+res.getStatus());
                    System.debug('STATUS_CODE:'+res.getStatusCode()); 
                    //if (dsid!=null){
                    jobOrder.RPV_Notification_Message__c = wo5.DataArea.NotificationMessage;
                    
                    jobOrder.RPV_Repeat_Visit_Flag__c = wo5.DataArea.RepeatVisitFlag;
                    //jobOrder.RPV_Error_Code__c = wo5.DataArea.ErrorCode;
                    jobOrder.RPV_Notification_Flag__c = wo5.DataArea.NotificationFlag;
                   
                    if(wo5.DataArea.RepeatVisitFlag =='RF' || wo5.DataArea.RepeatVisitFlag =='RN'){
                        jobOrder.Repeat_Visit__c = true;
                        jobOrder.RPV_SecondWebserviceCall__c = true; 
                        jobOrder.RPV_Email_Address__c = 'enginetechsupport@cummins.com';
                        jobOrder.RPV_Email_Has_Sent__c = false;
                        if(wo5.DataArea.NotificationFlag == 'ON'){
                        jobOrder.RPVControlNumber__c=null;
                            
                        }
                    }
                    
                    if(wo5.DataArea.RepeatVisitFlag =='FS'){
                        jobOrder.RPV_SecondWebserviceCall__c = true; 
                        jobOrder.Repeat_Visit__c = false; //TSR Changes
                        if(wo5.DataArea.NotificationFlag == 'ON'){
                            jobOrder.RPV_Email_Address__c = 'enginetechsupport@cummins.com';
                            jobOrder.RPV_Email_Has_Sent__c = false;
                            jobOrder.RPVControlNumber__c='NoInput';
                            jobOrder.RPV_Notification_Flag__c = 'OFF';
                        } 
                    }
                    
                    if(vdsid==null) {
                        system.debug('jobOrder.Repeat_Visit__c'+jobOrder.Repeat_Visit__c ); 
                        jobOrder.id = vJobId;
                        update jobOrder;
                    }
                }
            }
            
            System.debug('RPV after DataArea check');
            
/*        }catch(exception e){
            rpvIntegrationError(e.getMessage());
        }*/
        
    }
    
    public static void repeatVisitSecond(string vpersonType, string vesn, decimal vmiles, string vmileage, string vequipID, string vcssJobNum, string vdsid, datetime vDSIDCrDt, string vcontrolNum, ID vJobId){
        //    public static void repeatVisit(){    
        try{             
            string personType = vpersonType;
            string accessToken;
            string endPoint;
            HttpRequest req = new HttpRequest();
            string esn = vesn;
            string miles = string.valueOf(vmiles);
            string cssJobNum = vcssJobNum;
            string equipID;
            if (vequipID==null){
                equipID = '';
            }else {equipID = vequipID;}
            
            string controlNum;//12770007
            
            if (vcontrolNum==null){
                controlNum = '';
            }else {controlNum = vcontrolNum;}
            
            
            string dsid;//DSBKD5715
            
            if (vdsid==null){
                dsid = '';
            }else {dsid = vdsid;}
            
            string mileage; //=vmileage;
            
            if(vmileage=='Miles'){
                mileage = 'MI';
            } else if(vmileage=='Kilometers'){
                mileage = 'KM';
            } else {
                mileage = 'HR';
            }
            
            string DISIDCrDt=string.valueOf(vDSIDCrDt); 
            
            if (DISIDCrDt==null){
                DISIDCrDt = '';
            }
            
            string client_id;
            string client_secret;
            if (miles!=null){
                string timestamp=string.valueof(system.now());  //"MM-DD-YYYY HH:MM:SS"
                
                   CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                if(!Test.isRunningTest()){
                    conDetails =CSS_getConnnectionDetails.getConnection('RPV');
                    endPoint = conDetails.End_Point__c; 
                    client_id = conDetails.Username__c;   
                    client_secret = ConDetails.Passcode__c;
                    //Commented below line as part of Mule Integration
                    //accessToken=CSS_SRT.receiveToken();
                    //Added below lines as part of Mule Integration
                    CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('RPV').AuthEnv__c,'RPV');
                    accesstoken = accessTokenOPWrap.accessToken;   
                }else{
                    endPoint = 'https://services-dev.cummins.com/css/QueryRepeatVisitFlag';
                    accessToken='Test';
                    client_id = 'gyr3X2qsCi4mIivcj4ndefGc5yNJn9+G8TSMoejZCitMlkQFo8DBQ4Ycy+gW6zsEnJVsmhPqBltCUnutiFXf7w==';   
                    client_secret = 'UZvRxj9SjjcepsRMWDHhuQduplleXWBfrWhodykLHcOBMci7kZ+Pil8ZRfPCDz5vRH/JbvXoZ19qBi5A0EJ0oA==';
                }
                req.setEndpoint(endPoint);
                req.setHeader('Content-Type','application/json');
                //Added below lines as part of Mule Integration
                req.setHeader('client-id',client_id);
                req.setHeader('client-secret',client_secret);
                req.setHeader('Authorization', 'Bearer '+accessToken);
                string rpvRequest='{"Header":{"Sender":{"MessageID": "unique message ID at SF","ServiceName": "ServiceRequest","SenderID": "SF"},"Target":{"TargetID":"RPV"}},';
                rpvRequest = rpvRequest + '"DataArea":{"ESN":"'+esn+'","Mileage": "'+miles+'","MileageMSR":"'+mileage+'","FailDate": "","JobNumber":"'+cssJobNum+'","DealerDistributorFlag": "'+personType+'",'; 
                rpvRequest = rpvRequest + '"ControlNumber": "'+controlNum+'","DSID": "'+dsid+'","DSIDOpenedDate":"'+DISIDCrDt+'","TimeStamp":"'+timestamp+'" }}';
                System.debug('The repairRequest is!@!@#'+rpvRequest);
                req.setBody(rpvRequest);
                req.setMethod('POST');
                Http http = new Http();
                HTTPResponse res = http.send(req);
                string jSONRequestBody = res.getBody();
                System.debug('The body is'+jSONRequestBody);
                //req.setTimeout(120000);
                /*CSS_J2ARPV wo5 = (CSS_J2ARPV)JSON.deserializeStrict(jSONRequestBody,CSS_J2ARPV.class);
                
                if(wo5.DataArea!=null){  
                    System.debug('The json format is'+wo5);
                    System.debug('BODY: '+res.getBody());
                    System.debug('STATUS:'+res.getStatus());
                    System.debug('STATUS_CODE:'+res.getStatusCode()); 
                    //if (dsid!=null){
                    
                }*/
            }
            
            System.debug('RPV after DataArea check');
            
        }catch(exception e){
            rpvIntegrationError(e.getMessage());
        }
        
    }
    
    
    public static void rpvIntegrationError(String msg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c='RPV';
        errObj.Error_Description__c = msg;
        insert errObj;
    }
    
}