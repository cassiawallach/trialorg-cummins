global class CSS_EDSAuthentication {
    public static List<faultCodeID> faultCodes = new List<faultCodeID>();
    public static List<nextQues> nextQuestion = new List<nextQues>();
    // public static List<ansChoice> ansChoiceAdd = new List<ansChoice>();
    public static List<solutionEDS> solChoiceAdd = new List<solutionEDS>();
    public ID Wid;
    global static css_job_order__c workJob {get;set;}
    //global static User u {get;set;}
    public CSS_EDSAuthentication(){
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        try{
            // workJob=[Select Id,Name,DSID__c,Customer_Name__c,Failure_Point__c,Make__c,Model__c,Equipment_ID__c,Application__c,Unit_Number__c,
            //        Failure_Point_Measure__c,ESN__c from CSS_Job_Order__c where id= :Wid];
        }
        catch(exception e){
            
        }
    }
    @RemoteAction
    global static string getgenerateToken(){
        System.debug('Inside generate token method');
        User u = css_utility.getUserAttributes(Userinfo.getUserId());
        string userName = u.FederationIdentifier;
        //string userName = 'il204';
        string userGroup = u.UserGroup__c;
        Blob key = Crypto.generateAesKey(128);
       // string passPhrase = 'wEC38PruRaSw.bEm';
          String passPhrase = System.Label.CSS_EDS_Passphrase; // Added by Rajesh Narra on 1/21/2020 due to PTC changes. 
        Blob secretKey = Blob.valueOf(passPhrase);
        Blob tokenString = Blob.valueOf(getToken(userName,userGroup)); 
        Blob encryptedStr = Crypto.encrypt('AES128',secretkey,secretKey,tokenString);       
        System.debug('>> encryptedStr >> ' + encryptedStr);
        String encodedEncrypedStr = EncodingUtil.base64Encode(encryptedStr);
        System.debug('The encrypted string is>>>>>>>>>>>>>>>>'+encodedEncrypedStr);
        return encodedEncrypedStr;
    }
    
    //Get esn history details(calling from trigger)
    @Future(callout=true)
    global static void getESNHistory(id jobOrder, string esn,string lang){
        System.debug('The language inside esn history is'+lang);
        List<CSS_JobEventTemporary__c> jet = new List<CSS_JobEventTemporary__c>();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        HttpResponse res = new HttpResponse();
        try{
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('ESNHis_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions_history?sort=creation_date&filter=SERIAL_NUMBER%3A%3A79464646';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setHeader('Accept-Language', lang);    
            req.setMethod('GET');
            req.setTimeout(120000);// Sai:0923: For DSID Timeout issue.
            //https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions_history?sort=creation_date&filter=SERIAL_NUMBER%3A%3A'+esn
            req.setEndpoint(endPoint+'?sort=creation_date&filter=SERIAL_NUMBER%3A%3A'+esn);
            // if(!Test.isRunningTest()){
            res = h.send(req);
            /*}else{
res.setBody('{"diagnosticSession":[{"id":"DSBDT6104","ticket":"234","creationDate":"2016-06-21 10:53 EDT","owner":"MOUNT PEARL-CUMMINS SALES & SERVICE - EASTERN CANADA REGION-56334","title":"test","model":"ISX15 CM2250","status":"Closed","serialNumber":"79464646","additionalProp":{"application":"Automotive [130]","failurePoint":"324","INITIAL_PROBLEM":"2387","failureType":"MI","unitNumber":"324"}},{"id":"DSBDT6095","creationDate":"2016-06-21 09:53 EDT","owner":"edstestuser2","title":"test","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"application":"Automotive [130]","failureType":"MI"}},{"id":"DSBDT6082","ticket":"CSS ticket","creationDate":"2016-06-20 20:44 EDT","owner":"edstestuser1","title":"CSS Title - Casedetails issue","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"INITIAL_PROBLEM":"Blue smoke"}},{"id":"DSBDT6062","ticket":"CSS ticket","creationDate":"2016-06-20 14:44 EDT","owner":"il204","title":"CSS Title - Casedetails issue","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"INITIAL_PROBLEM":"Blue smoke"}},{"id":"DSBDT6060","ticket":"CSS ticket","creationDate":"2016-06-20 14:40 EDT","owner":"od319","title":"CSS Title - Casedetails issue","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"INITIAL_PROBLEM":"Blue smoke"}},{"id":"DSBDT6055","ticket":"CSS ticket","creationDate":"2016-06-20 14:16 EDT","owner":"GLEN BURNIE-CUMMINS POWER SYSTEMS, LLC-02231","title":"CSS Title - Casedetails issue","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"INITIAL_PROBLEM":"Blue smoke"}},{"id":"DSBDT6054","ticket":"CSS ticket","creationDate":"2016-06-20 14:13 EDT","owner":"GLEN BURNIE-CUMMINS POWER SYSTEMS, LLC-02231","title":"CSS Title - Casedetails issue","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"INITIAL_PROBLEM":"Blue smoke"}},{"id":"DSBDT6053","ticket":"CSS ticket","creationDate":"2016-06-20 14:08 EDT","owner":"venusukka","title":"CSS Title - Casedetails issue","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"INITIAL_PROBLEM":"Blue smoke"}},{"id":"DSBDT6045","ticket":"CSS ticket","creationDate":"2016-06-20 12:15 EDT","owner":"GLEN BURNIE-CUMMINS POWER SYSTEMS, LLC-02231","title":"CSS Title - Casedetails issue","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"INITIAL_PROBLEM":"Blue smoke"}},{"id":"DSBDT6024","creationDate":"2016-06-20 11:22 EDT","owner":" MUSWELLBROOK    -219 - XSTRATA COAL MANGOOLA-C149759","title":"CSS Test","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"application":"Automotive [130]","INITIAL_PROBLEM":"smoke","failureType":"MI"}},{"id":"DSBDT5895","ticket":"2345","creationDate":"2016-06-15 15:13 EDT","owner":"edstestuser2","title":"scenario16","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"application":"Automotive [130]","failurePoint":"435","failureType":"MI","unitNumber":"2354"}},{"id":"DSBDT5889","ticket":"345","creationDate":"2016-06-15 15:06 EDT","owner":"CHARLOTTE-CUMMINS ATLANTIC, LLC-02400","title":"scenario8","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"application":"Automotive [130]","failurePoint":"345","failureType":"MI","unitNumber":"324"}},{"id":"DSBDT5886","ticket":"test","creationDate":"2016-06-15 15:03 EDT","owner":"00000-DTS-Columbus","title":"test","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"application":"Automotive [130]","failurePoint":"test","INITIAL_PROBLEM":"turbocharger noise","failureType":"MI","unitNumber":"test"}},{"id":"DSBDT5710","creationDate":"2016-06-10 19:44 EDT","owner":"GLEN BURNIE-CUMMINS POWER SYSTEMS, LLC-02231","title":"79464646","model":"ISX15 CM2250","status":"Open","serialNumber":"79464646","additionalProp":{"application":"Automotive [130]","INITIAL_PROBLEM":"FC559 ","failureType":"MI"}},{"id":"DSBDT5568","creationDate":"2016-06-10 08:23 EDT","owner":"00000-DTS-Columbus","title":"No match solo","model":"ISX15 CM2250","status":"Closed","serialNumber":"79464646","additionalProp":{"application":"Automotive [130]","INITIAL_PROBLEM":"start\n","failureType":"MI"}}],"pagination":{"totalNumberOfRecord":599,"numberOfPages":40,"numberPerPage":15,"currentPage":1}}');
}*/
            System.debug('The httpResponse is++++'+res.getBody());
            string jSONRequestBody = res.getBody();
            CSS_J2AESNHistory wo1 = (CSS_J2AESNHistory)JSON.deserializeStrict(jSONRequestBody,CSS_J2AESNHistory.class);
            System.debug (wo1);
            integer k =0;
            for(integer i=0;i<wo1.Pagination.numberOfPages;i++){
                for(integer j=0;j<wo1.Pagination.numberPerPage;j++){
                    CSS_JobEventTemporary__c cjet = new CSS_JobEventTemporary__c();
                    if(wo1.Pagination.totalNumberOfRecord>k){
                        cjet.Name = 'EDS';
                        cjet.Source__c = 'EDS';
                        if(wo1.diagnosticSession[j].additionalProp!=null){
                            cjet.Attribute1__c = wo1.diagnosticSession[j].additionalProp.REPEAT_FLAG;
                            cjet.Attribute8__c = wo1.diagnosticSession[j].additionalProp.INITIAL_PROBLEM;
                            cjet.Attribute9__c = wo1.diagnosticSession[j].additionalProp.failurePoint+' '+wo1.diagnosticSession[j].additionalProp.failureType;
                            cjet.Attribute10__c = wo1.diagnosticSession[j].additionalProp.application;
                            cjet.Attribute14__c = wo1.diagnosticSession[j].additionalProp.failurePoint;
                        }
                        cjet.Attribute2__c = wo1.diagnosticSession[j].creationDate;
                        System.debug('The cjet.Attribute2__c is!#!@#!@'+cjet.Attribute2__c);
                        string str2 = cjet.Attribute2__c;
                        string yy = str2.substring(0, 4);
                        System.debug('The dd isW!@!'+yy);
                        string mm = str2.substring(5, 7);
                        System.debug('The months is@!#@!'+mm);
                        string dd= str2.substring(8,10);
                        System.debug('The yy is#@!#!@'+dd);
                        string hh = str2.substring(11,13);
                        string min = str2.substring(14,16);
                        string hhmin= str2.substring(11,16);
                        System.debug('The hh is@!#!@'+hh);
                        System.debug('The min is@!#!@'+min);
                        System.debug('The hhmin is@!#!@'+hhmin);
                        string stringDate = yy+'-'+mm+'-'+dd+' '+hhmin+':'+0;
                        // datetime gmtTimeConvert = datetime.valueOf(stringDate); Commented By Sai.
                        datetime gmtTimeConvert = datetime.valueOfGmt(stringDate); // Sai:09-21- Added the below Code to convert the date to GMT                      
                        //string gmtTimeStore = gmtTimeConvert.formatGmt('YYYY-MM-DD HH:mm:ss a'); Sai:09-21 Commented
                        //datetime gmtTimeConversion = datetime.valueOf(gmtTimeStore); Sai:09-21 Commented 
                        cjet.Key__c = esn;
                        cjet.Attribute3__c = wo1.diagnosticSession[j].title;
                        cjet.Attribute4__c = wo1.diagnosticSession[j].id;
                        cjet.Attribute5__c = wo1.diagnosticSession[j].ticket;
                        cjet.Attribute6__c = wo1.diagnosticSession[j].model;
                        cjet.Attribute7__c = wo1.diagnosticSession[j].owner;
                        cjet.Attribute11__c = wo1.diagnosticSession[j].status;
                        cjet.Attribute12__c = wo1.diagnosticSession[j].serialNumber;                        
                        //cjet.Attribute13__c = gmtTimeConversion; Sai : 09-21 Commented
                        cjet.Attribute13__c = gmtTimeConvert; // Sai:09-21- Added the Code to convert the date to GMT  
                        k++;
                        jet.add(cjet);
                    }
                }
            }
            System.debug('Hello varun the k value is   '+k);
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint,e.getMessage()+'-ESN Service History', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint,e.getMessage()+'-ESN Service History', res.getBody(), 'EDS');
                }
            }
        }
        insert jet;
    }
    
    // Sai: 4/4/2017 : This method is the clone of getEDSUpdate for TakeControl which is being invoked from TndRepOverview Controller for TakeControl Logic.
    global static void getTCUpdate(string dsi,string fedID,string custName,string make,string model,string accessC,string equipID,decimal fPoint,string fMeasure,string uNum,string esn,string wOrder){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        string dsid;
        HttpResponse res;
        try{
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4780';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            dsid=dsi;
            string owner = fedID;
            string title = custName;
            if(fMeasure=='Miles'){
                fMeasure='MI';
            }else if(fMeasure=='Hours'){
                fMeasure='HR';
            }if(fMeasure=='Kilometers'){
                fMeasure='KM';
            }
            string unit = uNum;
            string EQUIPMENT_DETAILS = make+','+model+','+equipID+','+accessC;//Make,model serial,equip id,access code
            string failurePoint = string.valueof(fPoint);
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setMethod('POST');
            req.setEndpoint(endPoint+'/'+dsid);
            req.setBody('[{"propertyName": "OWNER","propertyValue":"'+owner+'"},{"propertyName": "WORKORDER","propertyValue":"'+wOrder+'"},{"propertyName": "TITLE","propertyValue":"'+title+'"},{"propertyName": "EQUIPMENT_DETAILS","propertyValue":"'+EQUIPMENT_DETAILS+'"},{"propertyName": "failurePoint","propertyValue":"'+failurePoint+'"},{"propertyName": "failureType","propertyValue": "'+fMeasure+'"},{"propertyName": "unitNumber","propertyValue": "'+unit+'"},{"propertyName": "SERIAL_NUMBER","propertyValue": "'+esn+'"}]');
            res = h.send(req);
            System.debug('The httpResponse is++++'+res.getBody());
            string jSONRequestBody = res.getBody();
            string diagError = '{"key": "ds.error.dsiddoesntexist","message": "Error: Diagnostic Session not found"}';
            if(jSONRequestBody.equals(diagError))
            {
                //edsIntegrationError(diagError);
            }
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid,e.getMessage()+'-Update DSID', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid,e.getMessage()+'-Update DSID', res.getBody(), 'EDS');
                }
            }
        }
    }
    @future(callout=true)
    global static void getEDSUpdate(string dsi,string fedID,string custName,string make,string model,string accessC,string equipID,decimal fPoint,string fMeasure,string uNum,string esn,string wOrder){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        string dsid;
        HttpResponse res;
        try{
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4780';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            dsid=dsi;
            string owner = fedID;
            string title = custName;
            if(fMeasure=='Miles'){
                fMeasure='MI';
            }else if(fMeasure=='Hours'){
                fMeasure='HR';
            }if(fMeasure=='Kilometers'){
                fMeasure='KM';
            }
            string unit = uNum;
            string EQUIPMENT_DETAILS = make+','+model+','+equipID+','+accessC;//Make,model serial,equip id,access code
            string failurePoint = string.valueof(fPoint);
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setMethod('POST');
            req.setEndpoint(endPoint+'/'+dsid);
            req.setBody('[{"propertyName": "OWNER","propertyValue":"'+owner+'"},{"propertyName": "WORKORDER","propertyValue":"'+wOrder+'"},{"propertyName": "TITLE","propertyValue":"'+title+'"},{"propertyName": "EQUIPMENT_DETAILS","propertyValue":"'+EQUIPMENT_DETAILS+'"},{"propertyName": "failurePoint","propertyValue":"'+failurePoint+'"},{"propertyName": "failureType","propertyValue": "'+fMeasure+'"},{"propertyName": "unitNumber","propertyValue": "'+unit+'"},{"propertyName": "SERIAL_NUMBER","propertyValue": "'+esn+'"}]');
            res = h.send(req);
            System.debug('The httpResponse is++++'+res.getBody());
            string jSONRequestBody = res.getBody();
            string diagError = '{"key": "ds.error.dsiddoesntexist","message": "Error: Diagnostic Session not found"}';
            if(jSONRequestBody.equals(diagError))
            {
                //edsIntegrationError(diagError);
            }
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid,e.getMessage()+'-Update DSID', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid,e.getMessage()+'-Update DSID', res.getBody(), 'EDS');
                }
            }
        }
    }
    //Update DSID
    global static void getEDSUpdateTnR(string dsi,string fedID,string custName,string make,string model,string accessC,string equipID,decimal fPoint,string fMeasure,string uNum,string esn,string wOrder){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        string dsid;
        HttpResponse res;
        try{
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4780';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            dsid=dsi;
            string owner = fedID;
            string title = custName;
            if(fMeasure=='Miles'){
                fMeasure='MI';
            }else if(fMeasure=='Hours'){
                fMeasure='HR';
            }if(fMeasure=='Kilometers'){
                fMeasure='KM';
            }
            string unit = uNum;
            string EQUIPMENT_DETAILS = make+','+model+','+equipID+','+accessC;//Make,model serial,equip id,access code
            string failurePoint = string.valueof(fPoint);
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setMethod('POST');
            req.setEndpoint(endPoint+'/'+dsid);
            req.setBody('[{"propertyName": "OWNER","propertyValue":"'+owner+'"},{"propertyName": "WORKORDER","propertyValue":"'+wOrder+'"},{"propertyName": "TITLE","propertyValue":"'+title+'"},{"propertyName": "EQUIPMENT_DETAILS","propertyValue":"'+EQUIPMENT_DETAILS+'"},{"propertyName": "failurePoint","propertyValue":"'+failurePoint+'"},{"propertyName": "failureType","propertyValue": "'+fMeasure+'"},{"propertyName": "unitNumber","propertyValue": "'+unit+'"},{"propertyName": "SERIAL_NUMBER","propertyValue": "'+esn+'"}]');
            res = h.send(req);
            System.debug('The httpResponse is++++'+res.getBody());
            string jSONRequestBody = res.getBody();
            string diagError = '{"key": "ds.error.dsiddoesntexist","message": "Error: Diagnostic Session not found"}';
            if(jSONRequestBody.equals(diagError))
            {
                //edsIntegrationError(diagError);
            }
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid,e.getMessage()+'-Update DSID', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid,e.getMessage()+'-Update DSID', res.getBody(), 'EDS');
                }
            }
        }
    }
    
    global static void exitDSID(string workGroup,string dsid){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        string ds=dsid;
        HttpResponse res;
        try{
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4783/exit/';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            string workgroupID = workGroup;
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setMethod('POST');
            // req.setEndpoint('https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4763');
            // https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/'+ds+'/exit/'+workgroupID
            req.setEndpoint(endPoint+'/'+ds+'/exit');
            System.debug('https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/'+dsid+'/exit/'+workgroupID);
            req.setBody('{"propertyName": "WORKGROUP_NAME","propertyValue": "'+workGroup+'"}');
            //req.setBody('[{"propertyName": "OWNER","propertyValue":"'+owner+'"},{"propertyName": "TITLE","propertyValue":"'+title+'"},{"propertyName": "EQUIPMENT_DETAILS","propertyValue":"'+EQUIPMENT_DETAILS+'"},{"propertyName": "failurePoint","propertyValue":"'+failurePoint+'"}]');
            res = h.send(req);
            System.debug('The code is!!!'+res.getStatusCode());
            System.debug('The status is!@!'+res.getStatus());
            System.debug('The httpResponse is++++'+res.getBody());
            string jSONRequestBody = res.getBody();
            string diagError = '{"key":"ds.error.dsidinvalid","message":"Error: Invalid ID supplied"}';
            if(jSONRequestBody.equals(diagError))
            {
                css_utility.LogOutIntError(endPoint+'/'+ds+'/exit',diagError+'-Exit DSID', res.getBody(), 'EDS');
            }
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+ds+'/exit',e.getMessage()+'-Exit DSID', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+ds+'/exit',e.getMessage()+'-Exit DSID', res.getBody(), 'EDS');
                }
            }
        }
    }
    global static void detailsDSID(string ds,string lang){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        HttpResponse res;
        string endPoint;
        string dsid=ds;
        string dsidOwner;
        try{
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4783/details';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setHeader('Accept-Language', lang);    
            req.setMethod('GET');
            req.setEndpoint(endPoint+'/'+dsid+'/details');
            //req.setBody('[{"propertyName": "OWNER","propertyValue":"'+owner+'"},{"propertyName": "TITLE","propertyValue":"'+title+'"},{"propertyName": "EQUIPMENT_DETAILS","propertyValue":"'+EQUIPMENT_DETAILS+'"},{"propertyName": "failurePoint","propertyValue":"'+failurePoint+'"}]');
            res = h.send(req);
            System.debug('The code is!!!'+res.getStatusCode());
            System.debug('The status is!@!getESNHistory'+res.getStatus());
            System.debug('The httpResponse is++++'+res.getBody());
            string jSONRequestBody = res.getBody();
            string jsonReq = jSONRequestBody.replace('"time":', '"time_x":');
            string jsonRequest = jsonReq.replace('"date":','"date_x":');
            CSS_J2ADSIDDetails_EDS wo6 = (CSS_J2ADSIDDetails_EDS)JSON.deserializeStrict(jsonRequest,CSS_J2ADSIDDetails_EDS.class);
            System.debug('The json string is'+wo6);
            System.debug('The details is'+wo6.details.details[0]);
            for(integer i=0;i<wo6.details.details.size();i++){
                if(wo6.Details.details[i].name=='OWNER'){
                    dsidOwner = wo6.Details.details[i].value;
                    System.debug('The name of the owner is:'+wo6.Details.details[i].value);
                }
            }
            string diagError = '{"key":"ds.error.dsidinvalid","message":"Error: Invalid ID supplied"}';
            if(jSONRequestBody.equals(diagError))
            {
                css_utility.LogOutIntError(endPoint+'/'+dsid+'/details',diagError+'-Details DSID', res.getBody(), 'EDS');
            }
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/details',e.getMessage()+'-Details DSID', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/details',e.getMessage()+'-Details DSID', res.getBody(), 'EDS');
                }
            }
        }
    }
    public static List<nextQues> getPreviousQues(string ds,integer nbPrevious,string lang,string dsidIndi){
        System.debug('The language inside previous ques is'+lang);
        System.debug('The value of previous call is'+nbPrevious);
        string endPoint;
        string dsid = ds;
        integer previous = nbPrevious;
        HttpResponse res;
        boolean blnPole = false;
        try{
            List<ansChoice> ansChoiceAdd;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }
            else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4783/previous?nbPrevious=1';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            List<string> ansID = new List<string>{'18262#36229','18262#46271'};
                httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setHeader('Accept-Language', lang);    
            req.setMethod('POST');
            req.setTimeout(120000);
            //req.setEndpoint('https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_session/'+dsid+'/question/'+quesID+'/');
            if(previous!=null){
                if(dsidIndi=='N' || dsidIndi=='G'){
                    req.setEndpoint(endPoint+'/'+dsid+'/previous?nbPrevious='+previous+'?DSReadOnly=true');   
                }
                else{
                    req.setEndpoint(endPoint+'/'+dsid+'/previous?nbPrevious='+previous);
                }
            }
            res = h.send(req);
            System.debug('The httpResponse is++++'+res.getBody());
            System.debug('The code is@##!'+res.getStatusCode());
            string jSONRequestBody = res.getBody();
         //   string SymSearchAttributes = res.getBody();
            
            CSS_J2AQues_EDS wo6 = (CSS_J2AQues_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2AQues_EDS.class);
            
            CSS_J2AQues_EDS.cls_guidanzQuery  QuestAttributes = new  CSS_J2AQues_EDS.cls_guidanzQuery();
            QuestAttributes = wo6.guidanzQuery;
           
            System.debug('The json is!#@!@'+wo6);
            if(wo6.views.guide.searchCompleted==false){
                System.debug('Questions');
                for(integer i=0;i<wo6.views.guide.questions.size();i++){
                    if(wo6.views.guide.questions[i].id!=null){
                        ansChoiceAdd = new List<ansChoice>();
                        for(integer j=0;j<wo6.views.guide.questions[i].values.size();j++){
                            System.debug('The question is'+wo6.views.guide.questions[i].values[j].caption);
                            //faultCodes.add(new faultCodeID(wo2.faultcode[0].views.guide.questions[0].values[i].caption,wo2.faultcode[0].views.guide.questions[0].values[i].id,wo2.faultcode[0].views.guide.questions[0].question,wo2.faultcode[0].views.guide.questions[0].id,wo2.faultcode[0].views.guide.questions[0].cardinality)); 
                            ansChoiceAdd.add(new ansChoice(wo6.views.guide.questions[i].values[j].caption,wo6.views.guide.questions[i].values[j].id));
                        }
                    }
                    nextQuestion.add(new nextQues(wo6.views.guide.questions[i].question,wo6.views.guide.questions[i].id,ansChoiceAdd,wo6.views.guide.questions[i].cardinality,null,wo6.views.Result.Pagination.totalNumberOfRecord,blnPole,0,null,QuestAttributes,null,null,null));
                }
                System.debug('The nextQuestion is#!#'+nextQuestion);
            }
            else
                if(wo6.views.guide.searchCompleted==true && wo6.views.result.searchCompleted==false){
                    for(integer j=0;j<wo6.views.Result.cases.size();j++){
                        
                        solChoiceAdd.add(new solutionEDS(wo6.Views.Result.cases[j].name,wo6.Views.Result.cases[j].title,wo6.Views.Result.cases[j].rank));   
                    }
                    nextQuestion.add(new nextQues('','',null,0,solChoiceAdd,wo6.views.Result.Pagination.totalNumberOfRecord,blnPole,0,null,QuestAttributes,null,null,null));
                    System.debug('The solution number is#@!@#!'+wo6.Views.Result.cases[0].name);
                    System.debug('The solution title is@!!'+wo6.Views.Result.cases[0].title);  
                }       
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/previous?nbPrevious='+previous,e.getMessage()+'-Previous Ques', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/previous?nbPrevious='+previous,e.getMessage()+'-Previous Ques', res.getBody(),'EDS');
                }
            }
        }
        System.debug('The next question inside previous is'+nextQuestion);
        return nextQuestion;
        
    }
    
    //To create a DSID
    global static string getDSID(string esn1, string name, string application,string unitNum,decimal failurePoi,string measure,string mak,string mod,string eqID,string custName,string servModel,string shopWork,string accessCode){
        System.debug('esn>>>>>>>>>>>>>>'+esn1+'   '+failurePoi);
        string dsi;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        HttpResponse res;
        try{
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            string esn = esn1;
            string propertyValue = application;
            string unitNumber = unitNum;
            string failurePoint = string.valueOf(failurePoi);
            if(failurePoint == null || failurePoint==''){
                failurePoint='';
            }
            if(measure ==null || measure=='')
            {
                measure ='';
            }
            if( eqID==null || eqID=='')
            {
                eqID ='';
            }
            string failureType = measure;
            if(failureType=='Miles'){
                failureType='MI';
            }else if(failureType=='Hours'){
                failureType='HR';
            }if(failureType=='Kilometers'){
                failureType='KM';
            }
            string ticket= shopWork;
            string serviceModel = servModel;
            string shop = shopWork;
            System.debug('The equipment id is'+eqID);
            string equipmentDetails = mak+','+mod+','+eqID+','+accessCode;//Access code missing need to add that after make and model story
            string title=custName;
            string propertyName = 'application';
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setMethod('GET');
            req.setTimeout(120000);
            req.setEndpoint(endPoint);
            req.setBody('{"properties":[{"propertyName": "CSS","propertyValue": "true"},{"propertyName": "'+propertyName+'","propertyValue": "'+propertyValue+'"},{"propertyName": "unitNumber","propertyValue":"'+unitNumber+'"},{"propertyName": "failurePoint","propertyValue":"'+failurePoint+'"},{"propertyName":"failureType","propertyValue": "'+failureType+'"},{"propertyName": "EQUIPMENT_DETAILS","propertyValue": "'+equipmentDetails+'"}],"jobId": "'+ name +'","serialNumber": "'+esn+'","ticket": "'+ticket+'","title": "'+title+'"}');
            system.debug('DSID Request ' + '{"properties":[{"propertyName": "CSS","propertyValue": "true"},{"propertyName": "'+propertyName+'","propertyValue": "'+propertyValue+'"},{"propertyName": "unitNumber","propertyValue":"'+unitNumber+'"},{"propertyName": "failurePoint","propertyValue":"'+failurePoint+'"},{"propertyName":"failureType","propertyValue": "'+failureType+'"},{"propertyName": "EQUIPMENT_DETAILS","propertyValue": "'+equipmentDetails+'"}],"jobId": "'+ name +'","serialNumber": "'+esn+'","ticket": "'+ticket+'","title": "'+title+'"}');
            // req.setBody('{"properties":[{"propertyName": "'+propertyName+'","propertyValue": "'+propertyValue+'"},{"propertyName": "unitNumber","propertyValue":"'+unitNumber+'"},{"propertyName": "failurePoint","propertyValue":"'+failurePoint+'"},{"propertyName":"failureType","propertyValue": "'+failureType+'"},{"propertyName": "EQUIPMENT_DETAILS","propertyValue": "'+equipmentDetails+'"}],"serialNumber": "'+esn+'","ticket": "13456","title": "'+title+'"}');
            res = h.send(req);
            System.debug('The httpResponse is++++'+res.getBody());
            string jSONRequestBody = res.getBody();
            CSS_J2ADsid_EDS wo1 = (CSS_J2ADsid_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2ADsid_EDS.class);
            System.debug (wo1);
            System.debug('The dsid is+++'+wo1.dsid);
            if(wo1.dsid!=null){
            dsi = wo1.dsid;
            }else{
                dsi = wo1.message;
            }
        }
        catch(exception e){
            System.debug('inside getDSID catch block.......esn>>>>>>>>>>>>>>'+esn1);
            if(!Test.isRunningTest()) {
                //css_utility.LogOutIntError(endPoint,e.getMessage()+'-Get DSID', res.getBody(), 'EDS'); 
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint,e.getMessage()+'-Create DSID', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint,e.getMessage()+'-Create DSID', res==null?'RESPONSE IS NULL':res.getBody(), 'EDS'); 
                }
            }
        }
        return dsi;
    }
    
    //Fault Code Search
    // @Future(callout=true)
    public static List<nextQues> getSymptomSearch(String freeText, string esn1,string application,string unitNum,decimal failurePoi,string measure,string mak,string mod,string eqID,string custName,string servModel,string shopWork,string ds,string lang,string dsidIndi){
        System.debug('The language inside symptom search is'+lang);
        System.debug('Inside fault code serahc'+ds);
        HttpResponse res;
        string endPoint;
        string dsid = ds;
        boolean blnPole = false;
        try{
            List<ansChoice> ansChoiceAdd;
            string propertyValue = application;
            string unitNumber = unitNum;
            string failurePoint = string.valueof(failurePoi);
            if(failurePoint == null || failurePoint==''){
                failurePoint='';
            }
            string failureType = measure;
            if(failureType=='Miles'){
                failureType='MI';
            }else if(failureType=='Hours'){
                failureType='HR';
            }if(failureType=='Kilometers'){
                failureType='KM';
            }
            string make = mak;
            string model = mod;
            string servMode = servModel;
            string shop = shopWork;
            string equipID = eqID;
            string accessCode ='';
            string title = custName;
            string EQUIPMENT_DETAILS = make+','+model+','+equipID+','+accessCode;
            string esn = esn1;
            string edsUsername;
            string edsPassword;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4783/search';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            string faultCode = '';
            string freeTextSearch = freeText;
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setHeader('Accept-Language', lang);    
            req.setMethod('POST');
            req.setTimeout(120000);
            if(dsidIndi=='N' || dsidIndi=='G'){
                req.setEndpoint(endPoint+'/'+dsid+'/search?DSReadOnly=true');                
            }else{
                req.setEndpoint(endPoint+'/'+dsid+'/search');
            }
            req.setBody('{"faultCode":["'+faultCode+'"],"properties":[{"propertyName":"Application","propertyValue": "'+propertyValue+'"}],"serialNumber": "'+esn+'","project": "Engine","branch": "Prod","title": "'+title+'","ticket": "'+shop+'","model": "'+servMode+'","freeTextSearch":"'+freeTextSearch+'"}');
            res = h.send(req);
            System.debug('The httpResponse is++++'+res.getBody());
            System.debug('The code is@##!'+res.getStatusCode());
            string jSONRequestBody = res.getBody();
        
            CSS_J2ASymptomSearch_EDS wo2 = (CSS_J2ASymptomSearch_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2ASymptomSearch_EDS.class);
            CSS_J2ASymptomSearch_EDS.cls_guidanzQuery  SymSearchAttributes = new  CSS_J2ASymptomSearch_EDS.cls_guidanzQuery();
             SymSearchAttributes = wo2.search.guidanzQuery;
         
             //System.debug('The dialog question is'+wo2.search.guidanzQuery.attributeValues.attributeCaption); //roopa added the code
            if(jSONRequestBody.contains('dialogState')){
                if(wo2.search.views.dialog.dialogState == 'dialog-undecided-value'){
                    ansChoiceAdd = new List<ansChoice>();
                    for(integer i=0;i<wo2.search.views.dialog.question.values.size();i++){
                        
                        //  faultCodes.add(new faultCodeID(wo2.search.views.dialog.question.values[i].caption,wo2.search.views.dialog.question.values[i].id,wo2.search.views.dialog.question.question,wo2.search.views.dialog.question.id,wo2.search.views.dialog.question.cardinality)); 
                        ansChoiceAdd.add(new ansChoice(wo2.search.views.dialog.question.values[i].caption,wo2.search.views.dialog.question.values[i].id)); 
                    }
                    nextQuestion.add(new nextQues(wo2.search.views.dialog.question.question,wo2.search.views.dialog.question.id,ansChoiceAdd,wo2.search.views.dialog.question.cardinality,null,0,blnPole,wo2.search.views.Result.Pagination.totalNumberOfRecord,SymSearchAttributes,null,null,null,null)); //Sai:Added Pagination for RTC# 94998 SymSearchAttributes 
                }
                
                else if(wo2.search.views.dialog.dialogState == 'dialog-end' && jSONRequestBody.contains('cases')){
                    System.debug('The dialog state is'+wo2.search.views.dialog.dialogState);
                    ansChoiceAdd = new List<ansChoice>();
                    if(wo2.search.views.result.cases.size()>0){
                        for(integer i=0;i<wo2.search.views.result.cases.size();i++){
                            solChoiceAdd.add(new solutionEDS(wo2.search.views.result.cases[i].name,wo2.search.views.result.cases[i].title,wo2.search.views.result.cases[i].rank));   
                        }
                        nextQuestion.add(new nextQues('','',null,0,solChoiceAdd,0,blnPole,wo2.search.views.Result.Pagination.totalNumberOfRecord,SymSearchAttributes,null,null,null,null));
                    }
                }
               else{
                    ansChoiceAdd = new List<ansChoice>();
                    for(integer i=0;i<wo2.search.views.dialog.question.values.size();i++){
                        
                        //  faultCodes.add(new faultCodeID(wo2.search.views.dialog.question.values[i].caption,wo2.search.views.dialog.question.values[i].id,wo2.search.views.dialog.question.question,wo2.search.views.dialog.question.id,wo2.search.views.dialog.question.cardinality)); 
                        ansChoiceAdd.add(new ansChoice(wo2.search.views.dialog.question.values[i].caption,wo2.search.views.dialog.question.values[i].id)); 
                    }
                   // nextQuestion.add(new nextQues(wo2.search.views.dialog.question.question,wo2.search.views.dialog.question.id,ansChoiceAdd,wo2.search.views.dialog.question.cardinality,null,0,blnPole)); 
                    nextQuestion.add(new nextQues(wo2.search.views.dialog.question.question,wo2.search.views.dialog.question.id,ansChoiceAdd,1,null,0,blnPole,wo2.search.views.Result.Pagination.totalNumberOfRecord,SymSearchAttributes,null,null,null,null)); 
                    
                }
            }else if(jSONRequestBody.contains('cases')&& jSONRequestBody.contains('questions')){
                for(integer i=0;i<wo2.search.views.guide.questions.size();i++){
                    if(wo2.search.views.guide.questions[i].id!=null){
                        ansChoiceAdd = new List<ansChoice>();
                        System.debug('The size of values is'+wo2.search.views.guide.questions[i].values.size());
                        for(integer j=0;j<wo2.search.views.guide.questions[i].values.size();j++){
                            //faultCodes.add(new faultCodeID(wo2.faultcode[0].views.guide.questions[0].values[i].caption,wo2.faultcode[0].views.guide.questions[0].values[i].id,wo2.faultcode[0].views.guide.questions[0].question,wo2.faultcode[0].views.guide.questions[0].id,wo2.faultcode[0].views.guide.questions[0].cardinality)); 
                            ansChoiceAdd.add(new ansChoice(wo2.search.views.guide.questions[i].values[j].caption,wo2.search.views.guide.questions[i].values[j].id));
                        }
                    }
                    System.debug('The size of cases is@!#!@'+wo2.search.views.Result.cases.size());
                    for(integer j=0;j<wo2.search.views.Result.cases.size();j++){
                        solChoiceAdd.add(new solutionEDS(wo2.search.Views.Result.cases[j].name,wo2.search.Views.Result.cases[j].title,wo2.search.Views.Result.cases[j].rank));   
                    }
                    nextQuestion.add(new nextQues(wo2.search.views.guide.questions[i].question,wo2.search.views.guide.questions[i].id,ansChoiceAdd,wo2.search.views.guide.questions[i].cardinality,solChoiceAdd,wo2.search.views.Result.Pagination.totalNumberOfRecord,blnPole,wo2.search.views.Result.Pagination.totalNumberOfRecord,SymSearchAttributes,null,null,null,null));
                }
            }else if(jSONRequestBody.contains('questions')){
                for(integer i=0;i<wo2.search.views.guide.questions.size();i++){
                    if(wo2.search.views.guide.questions[i].id!=null){
                        ansChoiceAdd = new List<ansChoice>();
                        System.debug('The size of values is'+wo2.search.views.guide.questions[i].values.size());
                        for(integer j=0;j<wo2.search.views.guide.questions[i].values.size();j++){
                            //faultCodes.add(new faultCodeID(wo2.faultcode[0].views.guide.questions[0].values[i].caption,wo2.faultcode[0].views.guide.questions[0].values[i].id,wo2.faultcode[0].views.guide.questions[0].question,wo2.faultcode[0].views.guide.questions[0].id,wo2.faultcode[0].views.guide.questions[0].cardinality)); 
                            ansChoiceAdd.add(new ansChoice(wo2.search.views.guide.questions[i].values[j].caption,wo2.search.views.guide.questions[i].values[j].id));
                        }
                    }
                    nextQuestion.add(new nextQues(wo2.search.views.guide.questions[i].question,wo2.search.views.guide.questions[i].id,ansChoiceAdd,wo2.search.views.guide.questions[i].cardinality,null,0,blnPole,wo2.search.views.Result.Pagination.totalNumberOfRecord,SymSearchAttributes,null,null,null,null)); 
                }
            }
            System.debug('The fault code is'+nextQuestion);
            
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/search',e.getMessage()+'-Symptom Search', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/search',e.getMessage()+'-Symptom Search', res.getBody(), 'EDS');
                }
            }
        }
        return nextQuestion;
    }
    public static List<nextQues> getFCSympSearch(String freeText,string esn1,string application,string unitNum,decimal failurePoi,string measure,string mak,string mod,string eqID,string custName,string servModel,string shopWor,string ds,string lang,string dsidIndi){
        System.debug('Inside fault code serahc'+ds);
        System.debug('The language inside fc symp search is'+lang);
        string endPoint;
        HttpResponse res; 
        string dsid;
        try{
            string propertyValue = application;
            string unitNumber = unitNum;
            string failurePoint = string.valueof(failurePoi);
            string failureType = measure;
            dsid = ds;
            if(failureType=='Miles'){
                failureType='MI';
            }else if(failureType=='Hours'){
                failureType='HR';
            }if(failureType=='Kilometers'){
                failureType='KM';
            }
            string make = mak;
            string model = mod;
            string servMod = servModel;
            string shopWork = shopWor;
            string equipID = eqID;
            string accessCode ='';
            string title = custName;
            string EQUIPMENT_DETAILS = make+','+model+','+equipID+','+accessCode;
            string esn = esn1;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4783/search';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            string faultCode = freeText;
            string freeTextSearch = '';
            List<ansChoice> ansChoiceAdd;
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setHeader('Accept-Language', lang);    
            req.setMethod('POST');
            req.setTimeout(120000);
            if(dsidIndi=='N' || dsidIndi=='G'){
                req.setEndpoint(endPoint+'/'+dsid+'/search?DSReadOnly=true');   
            }else{
                req.setEndpoint(endPoint+'/'+dsid+'/search');
            }
            req.setBody('{"faultCode":["'+faultCode+'"],"properties":[{"propertyName":"Application","propertyValue": "'+propertyValue+'"}],"serialNumber": "'+esn+'","project": "Engine","branch": "prd","title": "'+title+'","ticket": "'+shopWork+'","model": "'+servMod+'","freeTextSearch":""}');
            system.debug('req--->'+req);
            res = h.send(req);
            //System.debug('The setbody is {"faultCode":["'+faultCode+'"],"properties":[{"propertyName":"Application","propertyValue": "'+propertyValue+'"}],"serialNumber": "'+esn+'","project": "Engine","branch": "prd","title": "'+title+'","ticket": "'+shopWork+'","model": "'+servMod+'","freeTextSearch":""}');
            System.debug('The setbody is {"faultCode":["'+faultCode+'"],"properties":[{"propertyName":"Application","propertyValue": "'+propertyValue+'"}],"serialNumber": "'+esn+'","project": "Engine","branch": "prd","title": "'+title+'","ticket": "'+shopWork+'","model": "'+servMod+'","freeTextSearch":""}');
            System.debug('The httpResponse is++++'+res.getBody());
            System.debug('The code is@##!'+res.getStatusCode());
            string jSONRequestBody = res.getBody();
            string SymSearchAttributes = res.getBody();
            boolean blnpole=false;
            if(jSONRequestBody.contains('cases')){
                
                CSS_J2AFCSearch_EDS wo2 = (CSS_J2AFCSearch_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2AFCSearch_EDS.class);
                System.debug('Roopa Wo2'+wo2);
                 CSS_J2AFCSearch_EDS.cls_guidanzQuery FCSearchAttributes = new  CSS_J2AFCSearch_EDS.cls_guidanzQuery();
                 FCSearchAttributes = wo2.faultCode[0].guidanzQuery;
                
                for(integer i = 0;i<wo2.faultCode.size();i++){
                    if(wo2.faultCode[i].views.result.cases.size()>0){
                        for(integer j=0;j<wo2.faultCode[i].views.result.cases.size();j++){
                            if(wo2.faultCode[i].views.result.cases[j].title.contains('requires that ALL solutions be performed')){
                                blnpole = true;
                            }
                            solChoiceAdd.add(new solutionEDS(wo2.faultCode[i].views.result.cases[j].name,wo2.faultCode[i].views.result.cases[j].title,wo2.faultCode[i].views.result.cases[j].rank));   
                        }
                        nextQuestion.add(new nextQues('','',null,0,solChoiceAdd,0,blnPole,0,null,null,FCSearchAttributes,null,null));
                    }
                }
            }
            else{
                CSS_J2AFCSearch_EDS wo2 = (CSS_J2AFCSearch_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2AFCSearch_EDS.class);
                CSS_J2AFCSearch_EDS.cls_guidanzQuery FCSearchAttributes = new  CSS_J2AFCSearch_EDS.cls_guidanzQuery();
                 FCSearchAttributes = wo2.faultCode[0].guidanzQuery;
                
                for(integer i = 0;i<wo2.faultCode.size();i++){
                    for(integer k=0;k<wo2.faultCode[i].views.guide.questions.size();k++){
                        if(wo2.faultCode[i].views.guide.questions[k].id!=null){
                            ansChoiceAdd = new List<ansChoice>();
                            for(integer l=0;l<wo2.faultCode[i].views.guide.questions[k].values.size();l++){
                                //System.debug('The question is'+wo6.views.guide.questions[i].values[j].caption);
                                //faultCodes.add(new faultCodeID(wo2.faultcode[0].views.guide.questions[0].values[i].caption,wo2.faultcode[0].views.guide.questions[0].values[i].id,wo2.faultcode[0].views.guide.questions[0].question,wo2.faultcode[0].views.guide.questions[0].id,wo2.faultcode[0].views.guide.questions[0].cardinality)); 
                                ansChoiceAdd.add(new ansChoice(wo2.faultCode[i].views.guide.questions[k].values[l].caption,wo2.faultCode[i].views.guide.questions[k].values[l].id));
                            }
                        }
                        nextQuestion.add(new nextQues(wo2.faultCode[i].views.guide.questions[k].question,wo2.faultCode[i].views.guide.questions[k].id,ansChoiceAdd,wo2.faultCode[i].views.guide.questions[k].cardinality,null,0,blnPole,0,null,null,FCSearchAttributes,null,null));
                    }
                }
            }
            
            System.debug('The fault Code is'+nextQuestion);
        }
        catch(exception e){
            system.debug('line number'+e.getLineNumber()+'message'+e.getMessage());
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/search',e.getMessage()+'-FCSym Search', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/search',e.getMessage()+'-FCSymp Search', res.getBody(), 'EDS');
                }
            }
        }
        return nextQuestion;
    }
    
    public class faultCodeID{
        public string faultCode{get;set;}
        public string fcID {get;set;}
        public string question{get;set;}
        public string quesID{get;set;}
        public integer cardinality{get;set;}
        public faultCodeID(string faultCode,string fcID,string question,string quesID,integer cardinality){
            this.faultCode = faultCode;
            this.fcID = fcID;
            this.question = question;
            this.quesID = quesID;
            this.cardinality = cardinality;
        }
    }
    // @future(callout=true)
    global static void getFaultCodeSearch(Map<ID,ID> jobOrder, Map<ID,String> faultCod,string dsi,string lang, CSS_Job_Order__c workJob){
        System.debug('Inside fault code serahc'+jobOrder+''+faultCod);
        System.debug('The language inside fault code search is'+lang);
        List<string> fauCod;
        string dsid; 
        List<CSS_Solutions__c> insSol = new List<CSS_Solutions__c>();
        List<CSS_Fault_Code__c> insTotSol = new List<CSS_Fault_Code__c>();
        string endPoint;
        boolean blnpole;
        HttpResponse res; 
        try{
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4783/search';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            string propertyName = 'application';
            string propertyValue = 'Automotive [130]';
            string unitNumber = '1234';
            string failurePoint = '10000';
            string failureType = 'MI';
            dsid = dsi;
            string a;
            string freeTextSearch = '';
            string equipmentDetails = 'STERLING,L8500,EQ3382,C';
            string esn = '46783622';
            string title = 'csstest';
            List<string> preLstFault = new List<string>();
            set<string> preSetFault = new set<string>();
            fauCod = new List<string>();
            for(ID key: faultCod.keySet() ){
                string fc = faultCod.get(key);
                preLstFault.add(fc);
            }
            preSetFault.addAll(preLstFault);
            fauCod.addAll(preSetFault);
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setHeader('Accept-Language', lang);    
            req.setMethod('POST');
            req.setEndpoint(endPoint+'/'+dsid+'/search');
            string faultCodeBody ='{"faultCode":[';
            for(integer i=0;i<fauCod.size();i++){
                if(i>0) {
                    faultCodeBody = faultCodeBody + ',';
                }
                faultCodeBody = faultCodeBody +   '"'+fauCod[i]+'"';
            }
            faultCodeBody = faultCodeBody + '],"properties":[{"propertyName":"","propertyValue": ""}], "serialNumber": "","project": "","branch": "","title": "","ticket": "","model": "","freeTextSearch":""}';
            req.setBody(faultCodeBody);
            req.setTimeout(120000);
            string  jSONRequestBody;
            // testing
            if(!Test.isRunningTest()){
                res = h.send(req);
                jSONRequestBody = res.getBody();
            }else{
                //    res.setHeader('Content-Type', 'application/json');
                //res.setBody('{"faultCode":[{"state":{"name":"dialog","dialogParamater":{"freeTextSearch":"123"}},"views":{"result":{"pagination":{"totalNumberOfRecord":6,"currentPage":0,"numberPerPage":6,"numberOfPages":1},"cases":[{"rank":0,"name":"K24241010","imageUseStyle":false,"caseId":29165,"title":"Fault Code 123 triggered by another fault code","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:55","name":"Fri Dec 09 08:55:53 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Fault Code 123 triggered by another fault code","name":"Fault Code 123 triggered by another fault code"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false},{"rank":1,"name":"K03070139","imageUseStyle":false,"caseId":29066,"title":"Intake manifold pressure sensor supply voltage check","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:40","name":"Fri Dec 09 08:40:14 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Intake manifold pressure sensor supply voltage check","name":"Intake manifold pressure sensor supply voltage check"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false},{"rank":2,"name":"K13306520","imageUseStyle":false,"caseId":24386,"title":"Circuit response check of intake manifold pressure sensor<br />","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:42","name":"Fri Dec 09 08:42:25 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Circuit response check of intake manifold pressure sensor<br />","name":"Circuit response check of intake manifold pressure sensor<br />"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false},{"rank":3,"name":"K53992470","imageUseStyle":false,"caseId":23899,"title":"Intake manifold pressure sensor SIGNAL pin shorted to another pin","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:43","name":"Fri Dec 09 08:43:18 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Intake manifold pressure sensor SIGNAL pin shorted to another pin","name":"Intake manifold pressure sensor SIGNAL pin shorted to another pin"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false},{"rank":4,"name":"K14152101","imageUseStyle":false,"caseId":29072,"title":"Intake manifold pressure sensor ECM circuit response","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:44","name":"Fri Dec 09 08:44:02 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Intake manifold pressure sensor ECM circuit response","name":"Intake manifold pressure sensor ECM circuit response"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false},{"rank":5,"name":"K81572426","imageUseStyle":false,"caseId":34124,"title":"Engine control module (ECM) Calibration Revision History check","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:31","name":"Fri Dec 09 08:31:47 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Engine control module (ECM) Calibration Revision History check","name":"Engine control module (ECM) Calibration Revision History check"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false}],"state":"results","searchCompleted":false},"guide":{"searchCompleted":false},"dialog":{"freeTextSearch":"123","dialogState":"dialog-end","state":"dialog","searchCompleted":true}}}]}');
                jSONRequestBody = '{"faultCode":[{"state":{"name":"dialog","dialogParamater":{"freeTextSearch":"123"}},"views":{"result":{"pagination":{"totalNumberOfRecord":6,"currentPage":0,"numberPerPage":6,"numberOfPages":1},"cases":[{"rank":0,"name":"K24241010","imageUseStyle":false,"caseId":29165,"title":"Fault Code 123 triggered by another fault code","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:55","name":"Fri Dec 09 08:55:53 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Fault Code 123 triggered by another fault code","name":"Fault Code 123 triggered by another fault code"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false},{"rank":1,"name":"K03070139","imageUseStyle":false,"caseId":29066,"title":"Intake manifold pressure sensor supply voltage check","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:40","name":"Fri Dec 09 08:40:14 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Intake manifold pressure sensor supply voltage check","name":"Intake manifold pressure sensor supply voltage check"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false},{"rank":2,"name":"K13306520","imageUseStyle":false,"caseId":24386,"title":"Circuit response check of intake manifold pressure sensor<br />","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:42","name":"Fri Dec 09 08:42:25 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Circuit response check of intake manifold pressure sensor<br />","name":"Circuit response check of intake manifold pressure sensor<br />"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false},{"rank":3,"name":"K53992470","imageUseStyle":false,"caseId":23899,"title":"Intake manifold pressure sensor SIGNAL pin shorted to another pin","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:43","name":"Fri Dec 09 08:43:18 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Intake manifold pressure sensor SIGNAL pin shorted to another pin","name":"Intake manifold pressure sensor SIGNAL pin shorted to another pin"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false},{"rank":4,"name":"K14152101","imageUseStyle":false,"caseId":29072,"title":"Intake manifold pressure sensor ECM circuit response","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:44","name":"Fri Dec 09 08:44:02 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Intake manifold pressure sensor ECM circuit response","name":"Intake manifold pressure sensor ECM circuit response"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false},{"rank":5,"name":"K81572426","imageUseStyle":false,"caseId":34124,"title":"Engine control module (ECM) Calibration Revision History check","similarity":95,"similarityImage":"/images/64x16_star5.gif","caseViews":[{"sections":[{"caption":"Admin","baseType":"CLASS","id":"4#104","attributes":[{"caption":"Modification Date","templateName":"case-modification-date","baseType":"LONG","id":"4#55","values":[{"caption":"2016-12-09 08:31","name":"Fri Dec 09 08:31:47 EST 2016"}]},{"caption":"Status","templateName":"case-status","baseType":"SYMBOL","id":"4#86","values":[{"caption":"Released","id":"31#34","name":"Released","properties":[{"name":"ICON","value":"./UserFiles/Image/R.png"}]}]}]}],"viewName":"Results List Body","viewCaption":"Results List Body"}],"versionNumber":0,"selected":false,"headerView":{"sections":[{"caption":"Solution","baseType":"CLASS","id":"4#108","attributes":[{"caption":"Title","templateName":"case-title","baseType":"TEXT","id":"4#82","values":[{"caption":"Engine control module (ECM) Calibration Revision History check","name":"Engine control module (ECM) Calibration Revision History check"}]}]}],"viewName":"_TEK_RHEADER","viewCaption":"Results List Header"},"favorite":false}],"state":"results","searchCompleted":false},"guide":{"searchCompleted":false},"dialog":{"freeTextSearch":"123","dialogState":"dialog-end","state":"dialog","searchCompleted":true}}}]}';
            }
            //System.debug('The httpResponse is++++'+res.getBody());
            //string jSONRequestBody = res.getBody();
            CSS_J2AFaultCodeSearch_EDS wo3 = (CSS_J2AFaultCodeSearch_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2AFaultCodeSearch_EDS.class);
            boolean blnAddSol;
            for(ID FCIds :faultCod.keySet()){
                blnpole=false;
                for(integer i=0;i<wo3.faultCode.size();i++){
                    CSS_Fault_Code__c fault = new CSS_Fault_Code__c();
                    if(wo3.faultCode[i].views.result.cases!=null){
                        if(faultCod.get(FCIds)!=null){
                            blnAddSol =  false;
                            if(faultCod.get(FCIds) == (wo3.faultCode[i].state.dialogParamater.freeTextSearch) ){
                                System.debug('The fcids is'+FCIds);
                                System.debug('The size of solutions is'+wo3.faultCode[i].views.result.cases.size());
                                for(integer j=0;j<wo3.faultCode[i].views.result.cases.size();j++){
                                    CSS_Solutions__c sol = new CSS_Solutions__c();
                                    sol.Name = wo3.faultCode[i].views.result.cases[j].name;
                                    sol.Case_Name__c = wo3.faultCode[i].views.result.cases[j].name;
                                    sol.Rank__c = wo3.faultCode[i].views.result.cases[j].rank;
                                    sol.Solution_Title__c = wo3.faultCode[i].views.result.cases[j].title;  
                                    if(wo3.faultCode[i].views.result.cases[j].title.contains('requires that ALL solutions be performed')){
                                        blnpole = true;
                                    }
                                    //sol.FaultCode__c = faultCod.get(FCIds.id);
                                    sol.FaultCode__c = FCIds;
                                    sol.Service_Job__c = jobOrder.get(FCIds) ;
                                    sol.Unique_Solution__c = FCIds +'-'+wo3.faultCode[i].views.result.cases[j].name;
                                    insSol.add(sol);
                                }
                                fault.Number_of_Solutions__c = String.valueOf(wo3.faultCode[i].views.result.pagination.totalNumberOfRecord);
                                fault.isPole__c = blnPole;
                                fault.id = FCIds;
                                if(insTotSol.size()>0){
                                    for(integer k=0;k<insTotSol.size();k++){
                                        if(insTotSol[k].id==FCIds){
                                            blnAddSol=false;
                                            break;
                                        }
                                        else{
                                            blnAddSol=true;
                                        }
                                    }
                                }else
                                {
                                    blnAddSol=true;
                                }
                                if(blnAddSol){
                                    insTotSol.add(fault);
                                    System.debug('The insTotsol is'+i+'    '+fault);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/search',e.getMessage()+'-Fault Code Search', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/search',e.getMessage()+'-Fault code Search', res.getBody(), 'EDS');
                }
            }
        }
        
        //GSSC-155 Start
        List<string> lstSolnumbers = new List<string>();
        for (CSS_Solutions__c s : insSol){
            lstSolnumbers.add(s.name);
        }
        
        CG_DiagTargetTimeResponse diagTargetTimeResp = new CG_DiagTargetTimeResponse();
        diagTargetTimeResp = CSS_FN_SRT.getDiagnosticTargetTime(lstSolnumbers,workJob.Equipment_ID__c,workJob.Service_Model__c,workJob.EngineFamilyCode__c,'en'); 

        Map<string, CG_DiagTargetTimeResponse.Solutions> mapSolIdTargetTime = new Map<string, CG_DiagTargetTimeResponse.Solutions>();
        
        system.debug('diagTargetTimeResp--'+diagTargetTimeResp);

        if(diagTargetTimeResp != null && diagTargetTimeResp.DataArea != null){
            for(CG_DiagTargetTimeResponse.Solutions sol: diagTargetTimeResp.DataArea.Solutions){
                mapSolIdTargetTime.put(sol.SolutionId,sol);
            }
        }
        
        for (CSS_Solutions__c sol : insSol){
            CG_DiagTargetTimeResponse.Solutions solution = new CG_DiagTargetTimeResponse.Solutions();

            solution = mapSolIdTargetTime.get(sol.Name);
            if(solution != null){
                sol.DiagTargetTime__c = (solution.DiagnosticTargetTime != null && solution.DiagnosticTargetTime != '') ? decimal.valueof(solution.DiagnosticTargetTime) : 0;
                sol.TargetMessage__c = solution.TargetMessage;  
            }
        }
        //GSSC-155 End
        
        upsert insSol sol.Unique_Solution__c;
        update insTotSol;
    }
    
    //Question for solution identifier
    public static List<nextQues> getQues(List<string> ansCho, string ansRadio,string ques,string ds,string lang,string dsidIndi){
        System.debug('The language inside question is'+lang);
        string endPoint;    
        string dsid;
        string quesRep;
        HttpResponse res;
        try{
            boolean blnPole=false;
            string quesSub;
            System.debug('varun The ansCho is'+ansCho);
            System.debug('varun The ansRadio is'+ansRadio);
            System.debug('varun The quesID is'+ques);
            if(ques!=null){
            quesSub = ques;
            }else{
               quesSub = ansRadio; 
            }
            quesRep = quesSub.replace('#', '%23');
            System.debug('The quesRep is '+quesRep);
            List<ansChoice> ansChoiceAdd;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4783/question/10%231499';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            dsid = ds;
            //string quesID = '10%231499';
            string quesID = ques;
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            System.debug('The end point is https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/'+dsid+'/question/'+quesID);
            //List<string> ansID = new List<string>{'18262#36229','18262#46271'};
            List<string> ansID = new List<string>{'DUMMY','DUMMY'};
                httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setHeader('Accept-Language', lang);    
            req.setMethod('POST');
            req.setTimeout(120000);
            system.debug('quesRep---->'+quesRep);
            if(ansRadio!=null){
                if(ques!=null){
                    if(dsidIndi=='N' || dsidIndi=='G'){
                        req.setEndpoint(endPoint+'/'+dsid+'/question/'+quesRep+'?DSReadOnly=true');
                    }
                    else{
                        req.setEndpoint(endPoint+'/'+dsid+'/question/'+quesRep);
                    }
                    req.setBody('["'+ansRadio+'"]');
                }
                else{
                    System.debug('Inside clarifying question'+quesRep);
                    if(dsidIndi=='N' || dsidIndi=='G'){
                        req.setEndpoint(endPoint+'/'+dsid+'/question/'+quesRep+'?DSReadOnly=true');
                    }
                    else{
                        req.setEndpoint(endPoint+'/'+dsid+'/question/'+quesRep);
                    }
                    req.setBody('["dummy"]');
                    //req.setBody('dummy');
                }
            }else{
                if(ansCho.size()>0){
                    if(dsidIndi=='N' || dsidIndi=='G'){
                        req.setEndpoint(endPoint+'/'+dsid+'/question/'+quesRep+'?DSReadOnly=true');
                    }
                    else{
                        req.setEndpoint(endPoint+'/'+dsid+'/question/'+quesRep);
                    }
                    for(integer i=0;i<ansCho.size();i++){
                        req.setBody('["'+ansCho[i]+'"]');
                    }
                }
            }
            system.debug('final request for next--->'+req);
            res = h.send(req);
            System.debug('The httpResponse is++++'+res.getBody());
            string jSONRequestBody = res.getBody();
            string SymSearchAttributes = res.getBody();
            CSS_J2AQues_EDS wo6 = (CSS_J2AQues_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2AQues_EDS.class);
            CSS_J2AQues_EDS.cls_guidanzQuery  QuestAttributes = new  CSS_J2AQues_EDS.cls_guidanzQuery();
            QuestAttributes = wo6.guidanzQuery;
            
            
            if(wo6.views.guide.searchCompleted==false && wo6.views.result.searchCompleted==false && jSONRequestBody.contains('cases') && jSONRequestBody.contains('questions')){
                for(integer i=0;i<wo6.views.guide.questions.size();i++){
                    if(wo6.views.guide.questions[i].id!=null){
                        ansChoiceAdd = new List<ansChoice>();
                        for(integer j=0;j<wo6.views.guide.questions[i].values.size();j++){
                            ansChoiceAdd.add(new ansChoice(wo6.views.guide.questions[i].values[j].caption,wo6.views.guide.questions[i].values[j].id));
                        }
                    }
                    for(integer j=0;j<wo6.views.Result.cases.size();j++){
                        solChoiceAdd.add(new solutionEDS(wo6.Views.Result.cases[j].name,wo6.Views.Result.cases[j].title,wo6.Views.Result.cases[j].rank));   
                    }
                    nextQuestion.add(new nextQues(wo6.views.guide.questions[i].question,wo6.views.guide.questions[i].id,ansChoiceAdd,wo6.views.guide.questions[i].cardinality,solChoiceAdd,wo6.views.Result.Pagination.totalNumberOfRecord,blnPole,0,null,QuestAttributes,null,null,null));
                }
            }else
                if(wo6.views.guide.searchCompleted==false && jSONRequestBody.contains('questions')){
                    for(integer i=0;i<wo6.views.guide.questions.size();i++){
                        if(wo6.views.guide.questions[i].id!=null){
                            ansChoiceAdd = new List<ansChoice>();
                            for(integer j=0;j<wo6.views.guide.questions[i].values.size();j++){
                                ansChoiceAdd.add(new ansChoice(wo6.views.guide.questions[i].values[j].caption,wo6.views.guide.questions[i].values[j].id));
                            }
                        }
                        nextQuestion.add(new nextQues(wo6.views.guide.questions[i].question,wo6.views.guide.questions[i].id,ansChoiceAdd,wo6.views.guide.questions[i].cardinality,null,0,blnPole,0,null,QuestAttributes,null,null,null));
                    }
                }
            else if(wo6.views.guide.searchCompleted==true && wo6.views.result.searchCompleted==false && jSONRequestBody.contains('error.search.nosolutions')){
                nextQuestion.add(new nextQues(null,null,null,0,null,0,blnPole,0,null,QuestAttributes,null,null,null));  
            }else if(wo6.views.guide.searchCompleted==true && wo6.views.result.searchCompleted==false){
                for(integer j=0;j<wo6.views.Result.cases.size();j++){  
                    if(wo6.Views.result.cases[j].title.contains('requires that ALL solutions be performed')){
                        blnpole = true;
                    }
                    solChoiceAdd.add(new solutionEDS(wo6.Views.Result.cases[j].name,wo6.Views.Result.cases[j].title,wo6.Views.Result.cases[j].rank));   
                }
                nextQuestion.add(new nextQues('','',null,0,solChoiceAdd,0,blnPole,0,null,QuestAttributes,null,null,null));
            }
            else if(wo6.views.guide.searchCompleted==false && wo6.views.result.searchCompleted==false && jSONRequestBody.contains('cases')){
                for(integer j=0;j<wo6.views.Result.cases.size();j++){
                    
                    solChoiceAdd.add(new solutionEDS(wo6.Views.Result.cases[j].name,wo6.Views.Result.cases[j].title,wo6.Views.Result.cases[j].rank));   
                }
                nextQuestion.add(new nextQues('','',null,0,solChoiceAdd,0,blnPole,0,null,QuestAttributes,null,null,null)); 
            }   
        } 
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/question/'+quesRep,e.getMessage()+'-Get Question', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/question/'+quesRep,e.getMessage()+'-Get Question', res.getBody(), 'EDS');
                }
            }
        }
        return nextQuestion;
    }
    //Method  to get solution details
    global static HttpResponse getSolutionDetails(String solId,string ds,string language,integer rank,string dsidIndi){
        System.debug('The language inside solution details is'+language);
        System.debug('The rank is'+rank);
        CSS_J2ASolution_EDS wo4 = null;
        string jSONRequestBody ;
        HttpResponse res = new HttpResponse();
        string endPoint;
        integer ra = rank+1;
        try{
            string edsUsername;
            string edsPassword;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('EDSgetSol');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            
            endPoint = endPoint + ds + '/case/' + solId;
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setHeader('Accept-Language', language);    
            req.setMethod('POST');
            req.setTimeout(120000);
            if(dsidIndi=='N' || dsidIndi=='G'){
                req.setEndpoint(endPoint+'?DSReadOnly=true');  
            }
            else{
                req.setEndpoint(endPoint);
            }
            req.setBody('{"casePosition":'+ra+'}');
            System.debug('The body is:'+'"casePosition":'+ra);
            if(!Test.isRunningTest()){
                res = h.send(req);
            }else{
                //  res.setBody('"solutionNumber":"K80756548","solutionTitle":"Check engine build date for possible update to VGT actuator calibration","coreIssue":"There is a VGT actuator calibration involved with In-Shop Campaign C1697 that includes an update to reduce the occurrences of this fault or symptom.","modificationDate":"2016-04-04 10:20","status":"Released","verification":"<strong>Conditions</strong><ul><li>N.A.</li></ul><strong>Action</strong><ul><li>Determine the build date of this engine.</li></ul><strong>Specification</strong><ul><li>If the build date of this engine is prior to 18-October-2013, then proceed to the <strong>Repair</strong> tab.</li><li>If the build date of this engine is <strong>not </strong>prior to 18-October-2013, then proceed to the next solution.</li></ul>","resolution":"NOTES: <br />-  This repair is for the VGT actuator calibration and NOT for the ECM calibration.<br />-  At this time, the VGT actuator calibration is only available on the InCal DVD.  If there is no InCal DVD access at the time of the repair, proceed to the next solution.<br /><br />Perform a <a href=\"/attachments/File/VGTActuatorCalibration.zip\" target=\"_blank\">VGT actuator calibration</a> update in accordance with In-Shop Campaign <a href=\"/apex/css_qsolRedirect?doctype=cam&amp;docid=C1697&amp;pgroup=EBU\" target=\"_blank\">C1697</a>.","poleLogicSolution":false,"components":[{"failureId":"F10000130","value":"Variable Geometry Turbocharger Actuator"},{"failureId":"F19000540","value":"Engine Control Module Calibration"}]');
                res.setBody('{"solutionNumber":"K47452115","solutionTitle":"Injector solenoid driver cylinder 4 current below normal or open circuit","coreIssue":"The ECM has detected the current is below normal, or there is an open circuit at injector solenoid driver.<br />","modificationDate":"2016-04-06 08:29","status":"Released","verification":"<strong>Conditions</strong>\n<ul>\n\t<li>\n\t\tTurn keyswitch ON.</li>\n\t<li>\n\t\tConnect INSITE&trade; electronic service tool.</li>\n</ul>\n<strong>Action</strong><br />\nOperate the engine and observe the fault codes.<br />\n<ul>\n\t<li>\n\t\tUse INSITE&trade; electronic service tool to clear the fault codes.</li>\n\t<li>\n\t\tStart the engine and let it idle for 1 minute.</li>\n\t<li>\n\t\tUse INSITE&trade; electronic service tool to read the fault codes.</li>\n</ul>\n<strong>Specification</strong><br />\n<ul>\n\t<li>\n\t\tIf Fault Codes 323, 325 and 332 are all active, or more than 1 inactive count, then proceed to the <strong>next </strong>solution.</li>\n\t<li>\n\t\tIf Fault Code 332 is active, or more than 1 inactive count, proceed to next<strong> Action</strong>.</li>\n</ul>\n<strong>Action</strong><br />\n<ul>\n\t<li>\n\t\t<span>Injector solenoid short or open circuit check</span></li>\n</ul>\n","poleLogicSolution":false,"verCompoundSolutions":[{"solutionNumber":"K87481914","solutionTitle":"Fuel injector solenoid or engine harness has a short or open circuit","coreIssue":"This fault is recorded when the ECM detects a persistent circuit error on the cylinder  injector circuit.<br /><br />Single injector malfunctions include:<ul><li>Below normal current in a single fuel injector or injector solenoid</li><li>High resistance in an injector solenoid (fuel injector shorted low or open circuit)</li><li>Shorted or Open circuit in the engine harness or injector harness</li></ul>","modificationDate":"2016-04-06 08:28","status":"Released","verification":"<strong>Conditions</strong><ul><li>Turn keyswitch OFF.</li><li>Remove the ECM engine harness connector. </li></ul><strong>Action</strong><br /><br />Inspect the pins and connector for damage. Refer to Procedure: <a href=\"/apex/css_qsolRedirect?doctype=pro&amp;docid=019-361&amp;pgroup=EBU\" target=\"_blank\">019-361</a>.<br /><br />Check for an open in the fuel injector solenoid circuit.<ul><li>Measure the resistance between the fuel injector solenoid SIGNAL pin and the fuel injector solenoid RETURN pin of the ECM engine harness connector for the fuel injector being tested.</li></ul>Refer to the circuit diagram or wiring diagram for component pin identification.<br /><br />Use the following procedure for general resistance measurement techniques. Refer to Procedure: <a href=\"/apex/css_qsolRedirect?doctype=pro&amp;docid=019-360&amp;pgroup=EBU\" target=\"_blank\">019-360</a>.<br /><br /><strong>Specification</strong><ul><li>If the resistance is greater than 2 ohms, proceed to the<strong> </strong>next<strong> Action.</strong></li><li>If the resistance is less than 2 ohms, return to search and proceed to the <strong>next</strong> solution<strong>.</strong></li></ul><strong>Action</strong><ul><li>Remove the rocker cover.</li><li>\t<div>\t<div>Verify the rocker levers are not contacting the fuel injector wiring harness. Refer to the the attached picture for <a href=\"https://eds-author.servigistics.com/cummins/UserFiles/Image/k59131742_injector.JPG\" target=\"_blank\">rocker lever contacting the wiring harness</a>.</div>\t</div>\t</li><li>Disconnect the fuel injector harness from the fuel injector solenoid.</li><li>Measure the resistance between the fuel injector solenoid SIGNAL post and the injector solenoid RETURN post on the fuel injector solenoid for the fuel injector being tested.</li></ul><p>Refer to the circuit diagram or the wiring diagram for connector pin identification.<br /><br /><strong>Specification</strong></p><ul><li>If resistance is greater than 2 ohms, then a malfunctioning fuel injector has been detected.</li><li>If resistance is less than 2 ohms, then a malfunctioning engine harness has been detected.</li></ul>","resolution":"Troubleshoot the engine harness, injector harness, and interconnects.<ul><li>For a malfunctioning fuel injector, replace the injector(s). Refer to Procedure: <a href=\"/apex/css_qsolRedirect?doctype=pro&amp;docid=006-026&amp;pgroup=EBU\" target=\"_blank\">006-026</a></li><li>For a malfunctioning engine harness, repair or replace the engine harness.  Refer to Procedure: <a href=\"/apex/css_qsolRedirect?doctype=pro&amp;docid=019-043&amp;pgroup=EBU\" target=\"_blank\">019-043</a>.</li></ul>","poleLogicSolution":false,"components":[{"failureId":"F05000100","value":"Fuel Injector"},{"failureId":"F19000660","value":"Engine Wiring Harness"}]}]}');
                res.setStatusCode(200);
            }
            System.debug('The request is'+req);
            System.debug('The httpResponse is++++'+res.getBody());
            System.debug('The code is@##!'+res.getStatusCode());
            jSONRequestBody = res.getBody();
            String SymSearchAttributes= res.getBody();
            wo4 = (CSS_J2ASolution_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2ASolution_EDS.class);
            System.debug('The solution is#!#!'+wo4);
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                //Defect Fix - 68619
                if(message!='Read timed out'){
                    if(message != 'No content to map to Object due to end of input'){
                        if(message.contains('timed out')){
                            css_utility.LogOutIntError(endPoint + ds + '/case/' + solId,e.getMessage()+'-Solution Details', 'RESPONSE IS NULL', 'EDS');
                        }
                        else{
                            css_utility.LogOutIntError(endPoint + ds + '/case/' + solId,e.getMessage()+'-Solution Details', res.getBody(), 'EDS');
                        }
                    }
                }
            }
        }
        return res;
    }
    //Webservice if no options selected
    public static List<nextQues> getNextQues(string ques,string ds,string lang,string dsidIndi){
        string endPoint;
        string dsid;
        string quesRep;
        HttpResponse res;
        boolean blnPole=false;
        try{ 
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4783/next_question/10%238893';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            string propertyName = 'application';
            string propertyValue = 'Automotive [130]';
            string unitNumber = '1234';
            string failurePoint = '10000';
            string failureType = 'MI';
            string quesSub = ques;
            quesRep = quesSub.replace('#', '%23');
            System.debug('The quesRep is '+quesRep);
            List<ansChoice> ansChoiceAdd;
            dsid = ds;
            string faultCode = '2372';
            string equipmentDetails = 'STERLING,L8500,EQ3382,C';
            string esn = '46783622';
            string title = 'csstest';
            string quesID ='10%238893'; 
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            List<string> ansID = new List<string>{'1132#38782'};
                httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            System.debug('The authorization header is'+authorizationHeader);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setHeader('Accept-Language', lang);    
            req.setMethod('POST');
            if(dsidIndi=='N' || dsidIndi=='G'){
                req.setEndpoint(endPoint+'/'+dsid+'/next_question/'+quesRep+'?DSReadOnly=true');
            }
            else{
                req.setEndpoint(endPoint+'/'+dsid+'/next_question/'+quesRep);
            }
            req.setBody('');
            res = h.send(req);
            string jSONRequestBody = res.getBody();
             string SymSearchAttributes = res.getBody();
            
            CSS_J2ANextQues_EDS wo5 = (CSS_J2ANextQues_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2ANextQues_EDS.class);
             CSS_J2ANextQues_EDS.cls_guidanzQuery  nextQuestAttributesAttributes = new  CSS_J2ANextQues_EDS.cls_guidanzQuery();
             nextQuestAttributesAttributes = wo5.guidanzQuery;
            
            if(wo5.views.guide.searchCompleted==false && wo5.views.result.searchCompleted==false && jSONRequestBody.contains('cases') && jSONRequestBody.contains('questions')){
                for(integer i=0;i<wo5.views.guide.questions.size();i++){
                    if(wo5.views.guide.questions[i].id!=null){
                        ansChoiceAdd = new List<ansChoice>();
                        for(integer j=0;j<wo5.views.guide.questions[i].values.size();j++){
                            //faultCodes.add(new faultCodeID(wo2.faultcode[0].views.guide.questions[0].values[i].caption,wo2.faultcode[0].views.guide.questions[0].values[i].id,wo2.faultcode[0].views.guide.questions[0].question,wo2.faultcode[0].views.guide.questions[0].id,wo2.faultcode[0].views.guide.questions[0].cardinality)); 
                            ansChoiceAdd.add(new ansChoice(wo5.views.guide.questions[i].values[j].caption,wo5.views.guide.questions[i].values[j].id));
                        }
                    }
                    for(integer j=0;j<wo5.views.Result.cases.size();j++){
                        solChoiceAdd.add(new solutionEDS(wo5.Views.Result.cases[j].name,wo5.Views.Result.cases[j].title,wo5.Views.Result.cases[j].rank));   
                    }
                    nextQuestion.add(new nextQues(wo5.views.guide.questions[i].question,wo5.views.guide.questions[i].id,ansChoiceAdd,wo5.views.guide.questions[i].cardinality,solChoiceAdd,wo5.views.Result.Pagination.totalNumberOfRecord,blnPole,0,null,null,null,null,nextQuestAttributesAttributes));
                }
            }else
                if(wo5.views.guide.searchCompleted==false){
                    System.debug('Questions');
                    for(integer i=0;i<wo5.views.guide.questions.size();i++){
                        if(wo5.views.guide.questions[i].id!=null){
                            ansChoiceAdd = new List<ansChoice>();
                            for(integer j=0;j<wo5.views.guide.questions[i].values.size();j++){
                                ansChoiceAdd.add(new ansChoice(wo5.views.guide.questions[i].values[j].caption,wo5.views.guide.questions[i].values[j].id));
                            }
                        }
                        nextQuestion.add(new nextQues(wo5.views.guide.questions[i].question,wo5.views.guide.questions[i].id,ansChoiceAdd,wo5.views.guide.questions[i].cardinality,null,0,blnPole,0,null,null,null,null,nextQuestAttributesAttributes));
                    }
                }
            else if(wo5.views.guide.searchCompleted==true && wo5.views.result.searchCompleted==false && jSONRequestBody.contains('error.search.nosolutions')){
                nextQuestion.add(new nextQues(null,null,null,0,null,0,blnPole,0,null,null,null,null,nextQuestAttributesAttributes));  
            }else if(wo5.views.guide.searchCompleted==true && wo5.views.result.searchCompleted==false){
                for(integer j=0;j<wo5.views.Result.cases.size();j++){
                    if(wo5.Views.result.cases[j].title.contains('requires that ALL solutions be performed')){
                        blnpole = true;
                    }
                    solChoiceAdd.add(new solutionEDS(wo5.Views.Result.cases[j].name,wo5.Views.Result.cases[j].title,wo5.Views.Result.cases[j].rank));   
                }
                nextQuestion.add(new nextQues('','',null,0,solChoiceAdd,wo5.views.Result.Pagination.totalNumberOfRecord,blnPole,0,null,null,null,null,nextQuestAttributesAttributes));
            } else if(wo5.views.guide.searchCompleted==false && wo5.views.result.searchCompleted==false && jSONRequestBody.contains('cases')){
                for(integer j=0;j<wo5.views.Result.cases.size();j++){
                    if(wo5.Views.result.cases[j].title.contains('requires that ALL solutions be performed')){
                        blnpole = true;
                    }
                    solChoiceAdd.add(new solutionEDS(wo5.Views.Result.cases[j].name,wo5.Views.Result.cases[j].title,wo5.Views.Result.cases[j].rank));   
                }
                nextQuestion.add(new nextQues('','',null,0,solChoiceAdd,0,blnPole,0,null,null,null,null,nextQuestAttributesAttributes));  
            }            
        }
        
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/next_question/'+quesRep,e.getMessage()+'-Next Ques', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/next_question/'+quesRep,e.getMessage()+'-Next Ques', res.getBody(), 'EDS');
                }
            }
        }
        return nextQuestion;
    }
    global static void reportProblem(string dsid,string caseNum,string feedback){
        HttpResponse res;
        string endPoint;
        try{
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            string edsUsername;
            string edsPassword;
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT4783/next_question/10%238893';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            httpRequest req = new httpRequest();
            http h = new http();
            string encodedEncrypedStr = getgenerateToken();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            System.debug('Inside Report Problem websrvice call');
            System.debug('The authorization header is'+authorizationHeader);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setMethod('POST');
            req.setEndpoint(endPoint+'/'+dsid+'/case/'+caseNum+'/feedback');
            req.setBody('{"comment": "'+feedback+'"}');
            res = h.send(req);
            string jSONRequestBody = res.getBody();
            CSS_J2AProblem_EDS wo5 = (CSS_J2AProblem_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2AProblem_EDS.class);
            System.debug('The status success is'+wo5.status);
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/case/'+caseNum+'/feedback',e.getMessage()+'-Solution Feedback', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/case/'+caseNum+'/feedback',e.getMessage()+'-Solution Feedback', res.getBody(), 'EDS');
                }
            }
        }
    }
    public class nextQues{
        public string question{get;set;}
        public string quesID {get;set;}
        public boolean isPole{get;set;}
        public integer cardinality{get;set;}
        public integer solRank{get;set;}
        public integer edsSolutionCount{get;set;}
        public List<solutionEDS> solEDS {get;set;}
        public List<ansChoice> answersNext{get;set;}
        //public string SymSearchAttributes{get;set;}
         public CSS_J2ASymptomSearch_EDS.cls_guidanzQuery SymSearchAttributes{get;set;}
         public CSS_J2AQues_EDS.cls_guidanzQuery QuestAttributes{get;set;}
     public CSS_J2AFCSearch_EDS.cls_guidanzQuery FCSearchAttributes{get;set;}
     public CSS_J2AFaultCodeSearch_EDS.cls_guidanzQuery FaultCodeSearchAttributes{get;set;}
     public CSS_J2ANextQues_EDS.cls_guidanzQuery nextQuestAttributesAttributes{get;set;}
        public nextQues(string question,string quesID,List<ansChoice> answersNext,integer cardinality,List<solutionEDS> solEDS,integer solRank,boolean isPole,integer edsSolutionCount,CSS_J2ASymptomSearch_EDS.cls_guidanzQuery SymSearchAttributes,CSS_J2AQues_EDS.cls_guidanzQuery QuestAttributes,CSS_J2AFCSearch_EDS.cls_guidanzQuery FCSearchAttributes,CSS_J2AFaultCodeSearch_EDS.cls_guidanzQuery FaultCodeSearchAttributes,CSS_J2ANextQues_EDS.cls_guidanzQuery nextQuestAttributesAttributes){
            this.question = question;
            this.quesID = quesID;
            this.answersNext=answersNext;
            this.cardinality = cardinality;
            this.solEDS = solEDS;
            this.solRank = solRank;
            this.isPole=isPole;
            this.edsSolutionCount=edsSolutionCount;
            this.SymSearchAttributes=SymSearchAttributes;
            this.QuestAttributes=QuestAttributes;
            this.FCSearchAttributes=FCSearchAttributes;
            this.FaultCodeSearchAttributes=FaultCodeSearchAttributes;
            this.nextQuestAttributesAttributes=nextQuestAttributesAttributes;
        }
    }
    
    public class ansChoice{
        public string ansCaption{get;set;}
        public string ansID{get;set;}
        public ansChoice(string ansCaption,string ansID){
            this.ansCaption = ansCaption;
            this.ansID = ansID;  
        }        
    }
    public class solutionEDS{
        public string name{get;set;}
        public string title{get;set;}
        public integer rank{get;set;}
        public solutionEDS(string name,string title,integer rank){
            this.name = name;
            this.title = title;   
            this.rank = rank;
        }  
    }
    
    // Close DSID - Start
    global static HttpResponse getDsidclose(String feedbk,string wrkgrp, string campid, string resolution, string dsid){
        CSS_J2Adsidclose_EDS  wo4 = null;
        string jSONRequestBody ;
        HttpResponse res = new HttpResponse();
        string endPoint;
        string ds;
        try{
            System.debug('The httpResponse is++++');
            string edsUsername;
            string edsPassword;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c; //"scharette';
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/';
                edsUsername = 'cssapp'; //"scharette';
                edsPassword = 'css4ever';
            }
            
            string fdbk = feedbk;
            string wkgp = wrkgrp;
            
            string caid = campid;
            ds   = dsid;
            string resol = resolution;
            endPoint = endPoint +'/'+ds + '/close/';
            
            string encodedEncrypedStr = getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json;charset=UTF-8');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setHeader('Accept-Language', 'en');    
            req.setMethod('POST');
            req.setEndpoint(endPoint);
            req.setBody('{ "feedback": "'+fdbk+'","workgroup": "'+wkgp+'","campaign": [ "'+caid+'" ],"resolution": "'+resol+'"}');
            //if(!Test.isRunningTest()){
            res = h.send(req);
            System.debug('The httpResponse is++++'+res.getBody());
            System.debug('The code is@##!'+res.getStatusCode());
            jSONRequestBody = res.getBody();
            System.debug('The response is'+jSONRequestBody);
            //wo4 = (CSS_J2Adsidclose_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2Adsidclose_EDS.class);
            //System.debug('The solution is#!#!'+wo4);
        }
        catch(exception e)
        {
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+ ds + '/close',e.getMessage()+'-Close DSID', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint + ds + '/close',e.getMessage()+'-Close DSID', res.getBody(), 'EDS');
                }
            }
        } 
        return res;
    }
    //Generate token based on the passed user name and group
    public static String getToken(String userName1, String userGroup1){
        System.debug('Inside gettoken method');
        User u = css_utility.getUserAttributes(Userinfo.getUserId());
        string PGA_GRP = u.Product_Group_Access__c;
        string USER_TYP = u.UserGroup__c;
        string EDS_PROJECT = 'Engine';
        string EDS_PRJ_BRNCH ='prd';
        DateTime dt = System.now();
        String dateTimeStr = dt.formatGMT('yyyyMMddHHmmss');
        System.debug('The time stamp is!!!!!!!!!!!!!1'+dateTimeStr);
        String tokenStr = userName1+';'+userGroup1+';EDS_PROJECT-'+EDS_PROJECT+';USER_TYP-'+USER_TYP+';EDS_PRJ_BRNCH-'+EDS_PRJ_BRNCH+';PGA_GRP-'+PGA_GRP+';datetime-'+dateTimeStr;
        System.debug('>> tokenStr >> ' + tokenStr);
        return(tokenStr);
    }
}