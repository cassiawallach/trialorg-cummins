/**********************************************************************
Name: CSS_SOAPEDS
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
Class that’s implements web service call.                                                            
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                  DETAIL                          
1.0 - Varun Sinha   11/30/2015 10:19 AM      INITIAL DEVELOPMENT              
2.0 - Varun Sinha    2/9/2016 12:25 PM        UDAC WIRE FRAME CHANGES         
3.0 - Anirudh        2/11/2016                Coding Standards
***********************************************************************/
global class CSS_SOAPEDS {
    public static boolean flag=false;
    public string getgenerateToken{set;}
    public static string encryptedKey{get;set;}
    public CSS_SOAPEDS(ApexPages.StandardController controller){             
    }
    
    @RemoteAction
    global static string getgenerateToken(string userName1,string userGroup1){
        System.debug('Inside generate token method');
        Blob key = Crypto.generateAesKey(128);
        string passPhrase = 'wEC38PruRaSw.bEm';
        Blob secretKey = Blob.valueOf(passPhrase);
        Blob tokenString = Blob.valueOf(getToken(userName1,userGroup1)); 
        Blob encryptedStr = Crypto.encrypt('AES128',secretkey,secretKey,tokenString);       
        System.debug('>> encryptedStr >> ' + encryptedStr);
        String encodedEncrypedStr = EncodingUtil.base64Encode(encryptedStr);
        return encodedEncrypedStr;
    }
    //Generate token based on the passed user name and group
    public static String getToken(String userName1, String userGroup1){
        System.debug('Inside gettoken method');
        DateTime dt = System.now();
        String dateTimeStr = dt.formatGMT('yyyyMMddHHmmss');
        String tokenStr = userName1+';'+userGroup1+';datetime-'+dateTimeStr;
        System.debug('>> tokenStr >> ' + tokenStr);
        return(tokenStr);
    }
    @RemoteAction 
    global Static string login(String tokenID,String locale){        
        string identifierId;
        string questId;
        string a;
        try
        {
            System.debug('Inside login Method');
            String username1 =  'cssapp'; //"scharette';
            String password = 'css4ever'; //"";
            Blob beforeblob = Blob.valueOf(username1+':'+password);
            string paramvalue = EncodingUtil.base64Encode(beforeblob);        
            wwwKaidaraCom.loginWithToken loginDetails = new wwwKaidaraCom.loginWithToken();
            loginDetails.locale=locale;
            loginDetails.token=tokenID;
            String authorizationHeader = 'Basic ' + paramvalue;
            wwwKaidaraComKaidaraservice.kaidaraSession sesID = new wwwKaidaraComKaidaraservice.kaidaraSession();
            wwwKaidaraCom.KaidaraServiceImplPort wsCall = new wwwKaidaraCom.KaidaraServiceImplPort();
            wsCall.inputHttpHeaders_x = new Map <String, String>();  
            wsCall.inputHttpHeaders_x.put('Authorization', authorizationHeader);
            wsCall.timeout_x=90000;
            sesID = wscall.loginWithToken(loginDetails.token,loginDetails.locale);
            a=string.valueOf(sesID.key);
            System.debug('The session id key is'+a);
            if(flag==false){
                wwwKaidaraComKaidaraservice.project pro = new wwwKaidaraComKaidaraservice.project();
                pro=wscall.open(a,sesID.projects[0].name,2);
            }
        }
        catch(Exception e){
            if(e.getTypeName() == 'System.CalloutException'){
                string excep=e.getMessage();
                edsIntegrationError(excep);
            }
            else{
                edsIntegrationError(e.getMessage());
            }            
        }
        return a;
    }
    @RemoteAction 
    global Static void setDiagnosticSessionProperty(String sessionKey,String dsID,String propertyName,String propertyValue){        
        try
        {
            System.debug('Inside diagnostic session property');
            System.debug('Inside login Method');
            String username1 =  'cssapp'; //"scharette';
            String password = 'css4ever'; //"";
            Blob beforeblob = Blob.valueOf(username1+':'+password);
            string paramvalue = EncodingUtil.base64Encode(beforeblob);        
            wwwKaidaraCom.setDiagnosticSessionProperty sessionProperty = new wwwKaidaraCom.setDiagnosticSessionProperty();
            sessionProperty.sessionKey=sessionKey;
            sessionProperty.dsID=dsID;
            sessionProperty.propertyName = propertyName;
            sessionProperty.propertyValue = propertyValue;
            String authorizationHeader = 'Basic ' + paramvalue;
            wwwKaidaraComKaidaraservice.kaidaraSession sesID = new wwwKaidaraComKaidaraservice.kaidaraSession();
            wwwKaidaraCom.KaidaraServiceImplPort wsCall = new wwwKaidaraCom.KaidaraServiceImplPort();
            wsCall.inputHttpHeaders_x = new Map <String, String>();  
            wsCall.inputHttpHeaders_x.put('Authorization', authorizationHeader);
            wsCall.timeout_x=90000;
            wscall.setDiagnosticSessionProperty(sessionProperty.sessionKey,sessionProperty.dsID,sessionProperty.propertyName,sessionProperty.propertyValue);
        }
        catch(Exception e){
            if(e.getTypeName() == 'System.CalloutException'){
                string excep=e.getMessage();
                edsIntegrationError(excep);
            }
            else{
                edsIntegrationError(e.getMessage());
            }            
        }
        //return a;
    }
    @RemoteAction
    global Static string createDS(String session,String title,string serialNumber,string model,string workorder){
        string diagnosticID;
        try{
            System.debug('Inside createds method');
            String username1 =  'cssapp'; //"scharette';
            String password = 'css4ever'; //"";
            Blob beforeblob = Blob.valueOf(username1+':'+password);
            string paramvalue = EncodingUtil.base64Encode(beforeblob);
            String authorizationHeader = 'Basic ' + paramvalue;
            wwwKaidaraCom.KaidaraServiceImplPort wsCall = new wwwKaidaraCom.KaidaraServiceImplPort();
            wsCall.inputHttpHeaders_x = new Map <String, String>();  
            wsCall.inputHttpHeaders_x.put('Authorization', authorizationHeader);
            wsCall.timeout_x=90000;
            wwwKaidaraCom.createDiagnosticSession ds = new wwwKaidaraCom.createDiagnosticSession();
            ds.sessionKey=session;
            ds.title=title;
            ds.serialNumber=serialNumber;
            ds.model=model;
            ds.workorder=workorder;
            wwwKaidaraComKaidaraservice.resultDiagnosticSession dsID = new wwwKaidaraComKaidaraservice.resultDiagnosticSession();
            dsID = wsCall.createDiagnosticSession(ds.sessionKey,ds.title,ds.workorder,ds.model,ds.serialNumber);
            diagnosticID = string.valueof(dsID.ID);
        }
        catch(Exception e){
            System.debug('The exception is'+e.getCause());
            if(e.getTypeName() == 'System.CalloutException'){
                string excep=e.getMessage();
                edsIntegrationError(excep);
            }
            else{
                edsIntegrationError(e.getMessage());
            }             
        }
        return diagnosticID;
    }
    @RemoteAction
    global static void edsIntegrationError(string errDesc){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c='EDS';
        errObj.Error_Description__c = errDesc;
        insert errObj;
    }
    @RemoteAction
    global static void retrieveDSListByLoggedInUser(string session,string dsid,string ds_Status,id name){
        if(ds_Status.equals('CLOSE')){
            string caseName=retrieveDSSolutionDetails(session,dsid,name);
        }
    }
    @RemoteAction
    global static string retrieveDSSolutionDetails(string session, String dsId,id name) {
        string caseName;
        try{
            List<CSS_Solutions__c> solutions = new List<CSS_Solutions__c>();
            System.debug('Inside retrieve ds solution details method' + session);
            String username1 =  'cssapp'; //"scharette';
            String password = 'css4ever'; //"";
            Blob beforeblob = Blob.valueOf(username1+':'+password);
            string paramvalue = EncodingUtil.base64Encode(beforeblob);
            String authorizationHeader = 'Basic ' + paramvalue;
            wwwKaidaraCom.KaidaraServiceImplPort wsCall = new wwwKaidaraCom.KaidaraServiceImplPort();
            wsCall.inputHttpHeaders_x = new Map <String, String>();  
            wsCall.inputHttpHeaders_x.put('Authorization', authorizationHeader);
            wsCall.timeout_x=90000;
            List<wwwKaidaraComKaidaraservice.dsCaseAction> dsAct = new List<wwwKaidaraComKaidaraservice.dsCaseAction>();
            wwwKaidaraCom.getDiagnosticSessionSolutions diagFilter = new  wwwKaidaraCom.getDiagnosticSessionSolutions();
            diagFilter.sessionKey=session;
            diagFilter.dsId=dsId;
            dsAct=wsCall.getDiagnosticSessionSolutions(diagFilter.sessionKey,diagFilter.dsId);
            String actDS=string.valueOf(dsAct);
            System.debug('The DSACTION IS');
            if(actDS==null){
                System.debug('No Solution found in DS');
            }
            else{
                for(wwwKaidaraComKaidaraservice.dsCaseAction dsAction:dsAct){
                    //System.debug('The DS Case Action key inside retrieveDSSolutionDetails is::::'+dsAction.key);
                    //System.debug('The DS Case Action Case Name inside retrieveDSSolutionDetails is:::'+dsAction.caseName);
                    //System.debug('The DS Case Action Comment Name inside retrieveDSSolutionDetails is::'+dsAction.comment); 
                    //System.debug('The DS case Action Title inside retrieveDSSolutionDetails is::'+dsAction.caseTitle);
                    CSS_Solutions__c solution = new CSS_Solutions__c();
                    if(dsAction.key == 'repair-succeded-as-is'){
                        solution.Name = 'Repair Successful - Problem Solved';
                    }
                    if(dsAction.key == 'repair-succeded-based-on'){
                        solution.Name = 'Repair Successful - Solved with additional parts/procedure';
                    }
                    if(dsAction.key == 'repair-failed'){
                        solution.Name = 'Repair Performed - Did not resolve root cause';
                    }
                    if(dsAction.key == 'repair-not-performed'){
                        solution.Name = 'Repair not performed';
                    }
                    solution.Solution_Title__c = dsAction.caseTitle;
                    solution.Service_Job__c = name;
                    solution.Case_Name__c = dsAction.caseName;
                    System.debug('The solution title is!!!!!!!!'+dsAction.caseTitle);
                    System.debug('The service job number is!!!!!!!!>>>>>>'+name);
                    System.debug('The case name is~~~~~<<<<<<<'+dsAction.caseName);
                    System.debug('The case name is~~~~~<<<<<<<'+caseName);
                    solutions.add(solution);
                    caseName=string.valueOf(dsAction.caseName);
                    string status=string.valueOf(dsAction.key);
                }
                insert solutions;
            }
        }
        catch(Exception e){
            System.debug('The exception is'+e.getCause());
            if(e.getTypeName() == 'System.CalloutException'){
                string excep=e.getMessage();
                edsIntegrationError(excep);
            }
            else{
                edsIntegrationError(e.getMessage());
            }             
        }
        return caseName;
    }
}