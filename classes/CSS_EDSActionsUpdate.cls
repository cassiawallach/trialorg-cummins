global class CSS_EDSActionsUpdate {
    //Selected Access SRT - Closing the job
    global static void SelectAccessSRT(CSS_ActionRequestWrapper wrapper){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        HttpResponse res = new HttpResponse();  
        String edsUsername;
        String edsPassword;
        try{            
            string ds = wrapper.dsid;            
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c;
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/TestDSID/actions';
                edsUsername = 'cssapp';
                edsPassword = 'css4ever';
            }            
            string encodedEncrypedStr = CSS_EDSAuthentication.getgenerateToken();
            endPoint = endPoint + '/'+ds+'/actions';
            for(String kNumber:wrapper.mapkNumSRTS.keyset()){
                List<CSS_srt__c> accList = wrapper.mapkNumSRTS.get(kNumber);
                http h = new http();                
                httpRequest req = new httpRequest();
                Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
                string paramvalue = EncodingUtil.base64Encode(beforeblob); 
                String authorizationHeader = 'Basic ' + paramvalue;
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('CMIAuthToken', encodedEncrypedStr);
                req.setMethod('POST');                
                req.setEndpoint(endPoint);
                //req.setEndpoint('https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/'+ds+'/actions');
                String reqBody = '{"actionType": "selectAccessSRT","actionProperties": {"properties":[{"propertyName": "SELECTED_ACCESS_SRT","propertyValue":';
                string srtID='';
                for(integer i=0;i<accList.size();i++){
                    if(i>0){
                        srtID = srtID + ',';
                    }
                    srtID = srtID + accList[i].Step_Id__c+':'+accList[i].SRT_Details__c;     
                }
                reqBody = reqBody + '"'+srtID+'"';
                reqBody = reqBody + '},{"propertyName": "CASENAME","propertyValue": "'+kNumber+'"}],"accessSRTList":[';
                for(integer j=0;j<accList.size();j++){
                    if(j>0){
                        reqBody = reqBody + ',';
                    }
                    reqBody = reqBody + '{"id":"'+accList[j].SRT_ID__c+'","displayId":"'+accList[j].SRT_Details__c+'","caption":"'+accList[j].SRT_Title__c+'"}'; 
                }
                reqBody = reqBody + ']}}';
                System.debug('The accRequest is'+reqBody);
                req.setBody(reqBody);          
                res = h.send(req);
                System.debug('The httpResponse is++++'+res.getBody());
            }
        }catch(exception e){
            if(!Test.isRunningTest())
                css_utility.LogOutIntError(endPoint,e.getMessage()+'-Access SRT Service', res.getBody(), 'EDS');
        }
    }    
    //Selected Components - closing the job
    global static void SelectComponents(CSS_ComponentRequestWrapper wrapper){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        HttpResponse res = new HttpResponse();  
        String edsUsername;
        String edsPassword;
        try{            
            string ds = wrapper.dsid;            
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c;
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/TestDSID/actions';
                edsUsername = 'cssapp';
                edsPassword = 'css4ever';
            }            
            string encodedEncrypedStr = CSS_EDSAuthentication.getgenerateToken();
            endPoint = endPoint + '/'+ds+'/actions';
            for(String kNumber: wrapper.kNumSolComps.keySet()){
                List<String> comps = wrapper.kNumSolComps.get(kNumber);
                String compNames = String.join(comps,',');
                http h = new http();
                httpRequest req = new httpRequest();
                Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
                string paramvalue = EncodingUtil.base64Encode(beforeblob); 
                String authorizationHeader = 'Basic ' + paramvalue;
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('CMIAuthToken', encodedEncrypedStr);
                req.setMethod('POST');                
                req.setEndpoint(endPoint);            
                //req.setEndpoint('https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/DSBDT7051/actions');
                String reBody = '{"actionType": "selectComponents","actionProperties": {"properties": [{"propertyName": "SELECTED_COMPONENTS","propertyValue": "'+compNames+'"},{"propertyName": "CASENAME","propertyValue": "'+kNumber+'"}]}}';
                System.debug('reBody: '+reBody);
                req.setBody(reBody);
                res = h.send(req);
                System.debug('The httpResponse is++++'+res.getBody());
            }
        }
        catch(exception e){
            if(!Test.isRunningTest())
                css_utility.LogOutIntError(endPoint,e.getMessage()+'-Select Component Service', res.getBody(), 'EDS');
        }
    }
    //Send Fault Codes - On click of pull in fault codes
    global static void insiteFaultCodes(List<CSS_Fault_Code__c> faultCode,string dsid){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        HttpResponse res = new HttpResponse();  
        String edsUsername;
        String edsPassword;
        try{            
            string ds = dsid;            
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c;
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/TestDSID/actions';
                edsUsername = 'cssapp';
                edsPassword = 'css4ever';
            }         
            System.debug('The fault code and related fault code is'+faultcode[0].name+'   '+faultcode[0].Related_Fault_Code__c);
            endPoint = endPoint + '/'+ds+'/actions';
            string propertyName ='INSITE_FAULTCODES';
            string propertyValue ='relFcCode[20]';
            List<String> faultycode = new List<String>{'','','','',''};
                List<String> relfaultycode = new List<String>{'','','','',''};
                    for(Integer i=0;i<5;i++) {
                        faultycode[i] =String.valueOf(faultCode[i].name);
                        relfaultycode[i]=String.valueOf(faultCode[i].Related_Fault_Code__c);
                    }
            string encodedEncrypedStr = CSS_EDSAuthentication.getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setMethod('POST');
            req.setEndpoint(endPoint);
            System.debug('The endpoint is'+endPoint);
            //req.setEndpoint('https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/'+ds+'/actions');
            CSS_InsiteActReqWrapper obj = new CSS_InsiteActReqWrapper();
            obj.actionType = 'insiteFaultCodes';            
            List<CSS_InsiteActReqWrapper.Properties> listProp = new List<CSS_InsiteActReqWrapper.Properties>();                          
            CSS_InsiteActReqWrapper.Properties p1 = new CSS_InsiteActReqWrapper.Properties();
            p1.propertyName = 'INSITE_FAULTCODES';                                
            p1.propertyValue = '{"fcCode1":"'+faultycode[0]+'","relFcCode1":"'+relfaultycode[0]+'","fcCode2":"'+faultycode[1]+'","relFcCode2":"'+relfaultycode[1]+'","fcCode3":"'+faultycode[2]+'","relFcCode3":"'+relfaultycode[2]+'","fcCode4":"'+faultycode[3]+'","relFcCode4":"'+relfaultycode[3]+'","fcCode5":"'+faultycode[4]+'","relFcCode5":"'+relfaultycode[4]+'"}';  
            listProp.add(p1);
            CSS_InsiteActReqWrapper.ActionProperties ap = new CSS_InsiteActReqWrapper.ActionProperties();
            ap.properties = listProp;
            obj.dsProperties = ap;                                                
            String reqJSON = CSS_InsiteActReqWrapper.parse(obj);
            system.debug('reqJSON: '+reqJSON); 
            req.setBody(reqJSON);
            //System.debug('The fault code and related fault code is'+faultycode[0]+'   '+relfaultycode[0]);
            //string insiteRequest = '{"actionType": "insiteFaultCodes","dsProperties":{"properties":[{"propertyName": "INSITE_FAULTCODES",';
            //insiteRequest = insiteRequest + '"propertyValue": "{"fcCode1":"'+faultycode[0]+'","relFcCode1":"'+relfaultycode[0]+'","fcCode2":"'+faultycode[1]+'","relFcCode2":"'+relfaultycode[1]+'","fcCode3":"'+faultycode[2]+'","relFcCode3":"'+relfaultycode[2]+'","fcCode4":"'+faultycode[3]+'","relFcCode4":"'+relfaultycode[3]+'","fcCode5":"'+faultycode[4]+'","relFcCode5":"'+relfaultycode[4]+'"}"}]}}';
            //System.debug('The request is'+insiteRequest);
            //req.setBody(insiteRequest); 
            res = h.send(req);
            System.debug('The httpResponse is++++'+res.getBody());
            
        }
        catch(exception e){
            if(!Test.isRunningTest()){}
               // css_utility.LogOutIntError(endPoint,e.getMessage()+'-EDS Update Insite fault codes', res.getBody(), 'EDS');
        }
    }
    //global static void outOfOrderAck(string name,decimal rank,string dsid){
    global static void outOfOrderAck(List<CSS_SOLUTIONS__c> sol,string dsid){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        HttpResponse res = new HttpResponse();  
        String edsUsername;
        String edsPassword;
        try{            
            string ds = dsid;            
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c;
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/TestDSID/actions';
                edsUsername = 'cssapp';
                edsPassword = 'css4ever';
            }            
            endPoint = endPoint + '/'+ds+'/actions';
            //decimal cIndexResult =rank;
            for(integer i=0;i<sol.size();i++){
                string encodedEncrypedStr = CSS_EDSAuthentication.getgenerateToken();
                http h = new http();
                httpRequest req = new httpRequest();
                Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
                string paramvalue = EncodingUtil.base64Encode(beforeblob); 
                String authorizationHeader = 'Basic ' + paramvalue;
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('CMIAuthToken', encodedEncrypedStr);
                req.setMethod('POST');
                req.setEndpoint(endPoint);
                //req.setEndpoint('https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/'+ds+'/actions');
                CSS_CaseActReqWrapper obj = new CSS_CaseActReqWrapper();
                obj.actionType = 'outOfOrderAck';
                CSS_CaseActReqWrapper.CaseProperties csp = new CSS_CaseActReqWrapper.CaseProperties();
                csp.caseName = sol[i].Name;
                csp.caseIndexInResultSet = sol[i].Rank__c;
                obj.caseProperties = csp;
                String reqJSON = CSS_CaseActReqWrapper.parse(obj);
                system.debug('reqJSON: '+reqJSON); 
                req.setBody(reqJSON);                
                //req.setBody('{ "actionType": "outOfOrderAck", "caseProperties": { "caseName": "'+sol[i].Name+'","caseIndexInResultSet":"'+sol[i].Rank__c+'"}}');
                res = h.send(req);
                System.debug('The httpResponse is++++'+res.getBody());
            }
        }
        catch(exception e){
            if(!Test.isRunningTest())
                css_utility.LogOutIntError(endPoint,e.getMessage()+'-EDS Update Out of Order', res.getBody(), 'EDS');
        }
    }
    //Send control Number - calling from rpvContinue from css_tnd_job
    global static void RepeatFlagAck(string controlNum,string ds){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        HttpResponse res = new HttpResponse();  
        String edsUsername;
        String edsPassword;
        try{                    
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c;
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/TestDSID/actions';
                edsUsername = 'cssapp';
                edsPassword = 'css4ever';
            }            
            endPoint = endPoint + '/'+ds+'/actions';
            string Pname ='RF_CTRL_NB';
            string Pvalue = controlNum;
            string dsid = ds;
            string encodedEncrypedStr = CSS_EDSAuthentication.getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setMethod('POST');
            req.setEndpoint(endpoint);
            //req.setEndpoint('https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/'+dsid+'/actions');
            CSS_InsiteActReqWrapper obj = new CSS_InsiteActReqWrapper();
            obj.actionType = 'repeatFlagAck';            
            List<CSS_InsiteActReqWrapper.Properties> listProp = new List<CSS_InsiteActReqWrapper.Properties>();                          
            CSS_InsiteActReqWrapper.Properties p1 = new CSS_InsiteActReqWrapper.Properties();
            p1.propertyName = 'RF_CTRL_NB';                                
            p1.propertyValue = Pvalue;
            listProp.add(p1);
            CSS_InsiteActReqWrapper.ActionProperties ap = new CSS_InsiteActReqWrapper.ActionProperties();
            ap.properties = listProp;
            obj.dsProperties = ap;                                                
            String reqJSON = CSS_InsiteActReqWrapper.parse(obj);
            system.debug('reqJSON: '+reqJSON); 
            req.setBody(reqJSON);            
            //req.setBody('{"actionType": "repeatFlagAck","dsProperties": {"properties": [{"propertyName": "RF_CTRL_NB","propertyValue": "'+Pvalue+'"}]}}');
            res = h.send(req);
            System.debug('The httpResponse is++++'+res.getBody());
        }
        catch(exception e){
            if(!Test.isRunningTest())
                css_utility.LogOutIntError(endPoint,e.getMessage()+'-EDS Update Repeat Flag', res.getBody(), 'EDS');
        }
    }
    //Case Viewed - When click on any of the nested solution
    global  static HttpResponse caseViewed(string casVie,integer rank,string ds){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        System.debug('The casVie is'+casVie+'   '+rank);
        integer ra = rank + 1;
        string endPoint;
        HttpResponse res = new HttpResponse();  
        String edsUsername;
        String edsPassword;
        try{                    
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                endPoint =  conDetails.End_Point__c;
                edsUsername = conDetails.Username__c;
                edsPassword = conDetails.Passcode__c;
            }else{
                endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/TestDSID/actions';
                edsUsername = 'cssapp';
                edsPassword = 'css4ever';
            }            
            endPoint = endPoint + '/'+ds+'/actions';
            string dsid = ds;
            // for(integer i=0;i<casVie.size();i++){
            string encodedEncrypedStr = CSS_EDSAuthentication.getgenerateToken();
            http h = new http();
            httpRequest req = new httpRequest();
            Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
            string paramvalue = EncodingUtil.base64Encode(beforeblob); 
            String authorizationHeader = 'Basic ' + paramvalue;
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setMethod('POST');
            req.setEndpoint(endpoint);
            //req.setEndpoint('https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/'+dsid+'/actions');
            string reqJSON = '{  "actionType": "case-viewed","caseProperties": {"caseName": "'+casVie+'","caseIndexInResultSet":'+ra+'}}';
            System.debug('The json is'+reqJSON);
            req.setBody(reqJSON);                  
            //req.setBody('{"actionType": "case-viewed",   "caseProperties": { "caseName": "'+casVie[i]+'" }}');                 
            res = h.send(req);
            System.debug('The httpResponse is++++'+res.getBody());
            //  }
        }
        catch(exception e){
            if(!Test.isRunningTest())
                css_utility.LogOutIntError(endPoint,e.getMessage()+'-EDS Update Case Viewed', res.getBody(), 'EDS');
        }
        return res;
    }
    //Calling from trigger when diagnostic response has been changed
   // @future(callout = true)
    global static void caseDiagStatusUpdate(List<string> solAdd){
        System.debug('The wrapper is'+solAdd);
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        string solStatus;
        solWrapper solution = null;
        HttpResponse res = new HttpResponse();  
        String edsUsername;
        String edsPassword;
        try{
            for(string sol:solAdd){   
                solution = (solWrapper)JSON.deserialize(sol,solWrapper.class);
                string ds = solution.dsid;            
                if(!Test.isRunningTest()){
                    conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                    endPoint =  conDetails.End_Point__c;
                    edsUsername = conDetails.Username__c;
                    edsPassword = conDetails.Passcode__c;
                }else{
                    endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/TestDSID/actions';
                    edsUsername = 'cssapp';
                    edsPassword = 'css4ever';
                }            
                string encodedEncrypedStr = CSS_EDSAuthentication.getgenerateToken();
                endPoint = endPoint + '/'+ds+'/case/'+solution.solNum+'/status';
                http h = new http();                
                httpRequest req = new httpRequest();
                Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
                string paramvalue = EncodingUtil.base64Encode(beforeblob); 
                String authorizationHeader = 'Basic ' + paramvalue;
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('CMIAuthToken', encodedEncrypedStr);
                req.setMethod('POST');                
                req.setEndpoint(endPoint);
                if(solution.status == 'Most likely the solution'){
                    solStatus = 'verif-out-of-spec';
                }else if(solution.status == 'Not the solution'){
                    solStatus = 'verif-in-spec';
                }else if(solution.status == 'Could not perform the solution verification'){
                    solStatus = 'verif-not-performed';
                }
                string reqBody = '{"status":"'+solStatus+'","comment":"'+solution.comment+'"}';
                System.debug('The accRequest is'+reqBody);
                req.setBody(reqBody);          
                res = h.send(req);
                System.debug('The httpResponse inside case diag is++++'+res.getBody());
            }
        }catch(exception e){
            if(!Test.isRunningTest())
                css_utility.LogOutIntError(endPoint,e.getMessage()+'-EDS Update Verification', res.getBody(), 'EDS');
        }
    }
    //Calling from trigger when repair response has been changed
   // @future(callout = true)
    global static void caseRepStatusUpdate(List<string> solAdd){
        System.debug('The wrapper is'+solAdd);
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string endPoint;
        string solStatus;
        solWrapper solution = null;
        HttpResponse res = new HttpResponse();  
        String edsUsername;
        String edsPassword;
        try{
            for(string sol:solAdd){   
                solution = (solWrapper)JSON.deserialize(sol,solWrapper.class);
                string ds = solution.dsid;            
                if(!Test.isRunningTest()){
                    conDetails = CSS_getConnnectionDetails.getConnection('Symp_EDS');
                    endPoint =  conDetails.End_Point__c;
                    edsUsername = conDetails.Username__c;
                    edsPassword = conDetails.Passcode__c;
                }else{
                    endPoint = 'https://eds-test58.ptcmanaged.com/skdservice/rest/api/cmi_diagnostic_sessions/TestDSID/actions';
                    edsUsername = 'cssapp';
                    edsPassword = 'css4ever';
                }            
                string encodedEncrypedStr = CSS_EDSAuthentication.getgenerateToken();
                endPoint = endPoint + '/'+ds+'/case/'+solution.solNum+'/status';
                http h = new http();                
                httpRequest req = new httpRequest();
                Blob beforeblob = Blob.valueOf(edsUsername+':'+edsPassword);
                string paramvalue = EncodingUtil.base64Encode(beforeblob); 
                String authorizationHeader = 'Basic ' + paramvalue;
                req.setHeader('Authorization', authorizationHeader);
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('CMIAuthToken', encodedEncrypedStr);
                req.setMethod('POST');                
                req.setEndpoint(endPoint);
                if(solution.status == 'Repair Successful.'){
                    solStatus = 'repair-succeded-as-is';
                }else if(solution.status == 'Repair Successful with additional parts/procedures.'){
                    solStatus = 'repair-succeded-based-on';
                }else if(solution.status == 'Repair performed but didnot resolve the root cause.'){
                    solStatus = 'repair-failed';
                }else if(solution.status == 'Repair not performed.'){
                    solStatus = 'repair-not-performed';
                }
                string reqBody = '{"status":"'+solStatus+'","comment":"'+solution.comment+'"}';
                System.debug('The accRequest is'+reqBody);
                req.setBody(reqBody);          
                res = h.send(req);
                System.debug('The httpResponse inside case diag is++++'+res.getBody());
            }
        }catch(exception e){
            if(!Test.isRunningTest())
                css_utility.LogOutIntError(endPoint,e.getMessage()+'-EDS Update Verification', res.getBody(), 'EDS');
        }
    }
    global class solWrapper{
        public string solNum{get;set;}
        public string status{get;set;}
        public string comment{get;set;}
        public string dsid{get;set;}  
        public solWrapper(string solNum,string status,string comment,string dsid){
            this.solNum = solNum;
            this.status = status;
            this.comment = comment;
            this.dsid=dsid;
        }
    }   
}