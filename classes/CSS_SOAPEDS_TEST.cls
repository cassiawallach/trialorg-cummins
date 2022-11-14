@isTest
public class CSS_SOAPEDS_TEST {
    
    @isTest  static void testcreateDS() {              
        
        Test.setMock(WebServiceMock.class, new CSS_EDSwebcalloutMockImpl_Test());
        String title = 'Customer Name:CSS EDS WS Test ';
        String workorder = 'workorder1';
        String model = 'null'; //"ISC CM2150"; //"ISB CM850";
        String serialNumber = '46826048';
        String locale = 'en';
        string userGroup='Admin';
        string userName='edstestuser1';
        string encryptedKey = 'HcWJe/EWbPmLtsVBgT8d464TldQDZXDJM+pkt6QWQ04RxRA1V10Py/fjC1ke7cxr';
        string systemDate;
        string token=userName+';'+userGroup+';datetime-'+systemDate;
        string session = 'session';
        String output = CSS_SOAPEDS.createDS(session,title,serialNumber,model,workorder);
        System.assertEquals('DSBDT3829', output);
    }
    
    @isTest  static void testgetgenerateToken() {         
        string userGroup='ADMIN';
        string userName='edstestuser1';
        Blob key = Crypto.generateAesKey(128);
        string passPhrase = 'wEC38PruRaSw.bEm';
        Blob secretKey = Blob.valueOf(passPhrase);
        Blob tokenString = Blob.valueOf(CSS_SOAPEDS.getToken(userName,userGroup)); 
        Blob encryptedStr = Crypto.encrypt('AES128',secretkey,secretKey,tokenString);       
        String encryptedKey = EncodingUtil.base64Encode(encryptedStr);
        String output = CSS_SOAPEDS.getgenerateToken(userName,userGroup);
        System.assertEquals(encryptedKey, output);   
    }
    @isTest  static void testlogin() {         
        string SessionExpected='Session key Mock response';
        String tokenID = 'tokenID';
        String locale ='en';
        Test.setMock(WebServiceMock.class, new CSS_SOAPEDS_login_MockImpl_Test());
        String SessionActual = CSS_SOAPEDS.login(tokenID,locale);
        System.assertEquals(SessionExpected, SessionActual);
    }
    @isTest static void testSolutions(){
        string session = 'session';
        string dsId='DSBDT3829';
        ID jobnum= 'a093B0000006rOw';
        Test.setMock(WebServiceMock.class, new CSS_SOAPEDS_SOLUTIONS_Test());
        System.debug('Before Solutions Method');
        string key = CSS_SOAPEDS.retrieveDSSolutionDetails(session,dsId,jobnum);
        System.debug('After web service call');
        CSS_Solutions__c solution = new CSS_Solutions__c(Name=key);
        insert solution;
        System.assertEquals('K07940700', key);
    }
    @isTest static void getCSSproperty(){
        string session = 'session';
        string dsId='DSBDT3829';
        string propertyName='CSS';	
        string propertyValue='true';
        CSS_SOAPEDS.setDiagnosticSessionProperty(session, dsID, propertyName, propertyValue);
    }
    @isTest static void getErrors(){
        CSS_SOAPEDS.edsIntegrationError('ABC');
        string session = 'session';
        string dsId='DSBDT3829';
        string ds_Status='Close';
        ID name= 'a093B0000006rOw';
        CSS_SOAPEDS.retrieveDSListByLoggedInUser(session, dsid, ds_Status, name);
    }
    
    
}