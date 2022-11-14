global class CSS_WS_EDS {

    global static string getgenerateToken(){
        System.debug('Inside generate token method');
        User u = css_utility.getUserAttributes(Userinfo.getUserId());
        string userName = u.FederationIdentifier;
        string userGroup = u.UserGroup__c;
        Blob key = Crypto.generateAesKey(128);
        //string passPhrase = 'wEC38PruRaSw.bEm'; This is commented by Rajesh Narra on 1/21/2020 due to security reasons.
        String passPhrase = System.Label.CSS_EDS_Passphrase; // Added by Rajesh Narra on 1/21/2020 due to PTC changes. 
        Blob secretKey = Blob.valueOf(passPhrase);
        Blob tokenString = Blob.valueOf(getToken(userName,userGroup)); 
        Blob encryptedStr = Crypto.encrypt('AES128',secretkey,secretKey,tokenString);       
        System.debug('>> encryptedStr >> ' + encryptedStr);
        String encodedEncrypedStr = EncodingUtil.base64Encode(encryptedStr);
        System.debug('The encrypted string is>>>>>>>>>>>>>>>>'+encodedEncrypedStr);
        return encodedEncrypedStr;
    }
    
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
    //To get the DSID Owner
    global static string getDSIDDetails(string ds,string lang){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        HttpResponse res;
        string endPoint;
        string dsid=ds;
        string dsidOwner;
        CSS_J2ADSIDDetails_EDS wo6;
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
            System.debug('The status is!@!'+res.getStatus());
            System.debug('The httpResponse is++++'+res.getBody());
            string jSONRequestBody = res.getBody();
            string jsonReq = jSONRequestBody.replace('"time":', '"time_x":');
            string jsonRequest = jsonReq.replace('"date":','"date_x":');
            wo6 = (CSS_J2ADSIDDetails_EDS)JSON.deserializeStrict(jsonRequest,CSS_J2ADSIDDetails_EDS.class);
            System.debug('The json string is'+wo6);
            System.debug('The details is'+wo6.details.details[0]);
            for(integer i=0;i<wo6.details.details.size();i++){
                if(wo6.Details.details[i].name=='OWNER'){
                    dsidOwner = wo6.Details.details[i].value;
                    System.debug('The name of the owner is:'+wo6.Details.details[i].value);
                }
            }
       }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                //if(wo6.key!='error.unhandled' || wo6.key!='ds.error.dsidinvalid'){
                if(wo6.details!=null){
                    if(message.contains('timed out')){
                        css_utility.LogOutIntError(endPoint+'/'+dsid+'/details',e.getMessage()+'-Details DSID', 'RESPONSE IS NULL', 'EDS');
                    }
                    else{
                        css_utility.LogOutIntError(endPoint+'/'+dsid+'/details',e.getMessage()+'-Details DSID', res.getBody(), 'EDS');
                    }
                }
            }
        }
        return dsidOwner;
    }
    //Unlock DSID - Story Number 67550
    public static void unlockDsid(string DSID){
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
            System.debug('Inside Unlock DSID websrvice call');
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('CMIAuthToken', encodedEncrypedStr);
            req.setMethod('POST');
            req.setEndpoint(endPoint+'/'+dsid+'/unlock');
            res = h.send(req);
            string jSONRequestBody = res.getBody();
            CSS_J2AProblem_EDS wo5 = (CSS_J2AProblem_EDS)JSON.deserializeStrict(jSONRequestBody,CSS_J2AProblem_EDS.class);
            System.debug('The status success is'+wo5.status);
        }
        catch(exception e){
            if(!Test.isRunningTest()){
                string message = e.getMessage();
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/unlock',e.getMessage()+'-Unlock DSID', 'RESPONSE IS NULL', 'EDS');
                }
                else{
                    css_utility.LogOutIntError(endPoint+'/'+dsid+'/unlock',e.getMessage()+'-Unlock DSID', res.getBody(), 'EDS');
                }
            }
        }
    }
}