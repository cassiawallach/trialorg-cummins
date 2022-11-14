@isTest
public class CSS_WS_EDS_Test {
    static CSS_WS_EDS ext;
    static CSS_Job_Order__c JO;
    static PageReference pref; 
    
    @isTest private static void init() {
        //CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.DSID__c = 'DSBDT4082'; 
        insert(JO);
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string  edsUsername = conDetails.Username__c; //"scharette';
        string edsPassword = conDetails.Passcode__c;
        Test.setCurrentPage(pref);
        //ApexPages.StandardController con = new ApexPages.StandardController(JO);
        ext = new CSS_WS_EDS();        
    }
    @isTest  static void testgetgenerateToken() {         
        string userGroup='ADMIN';
        string userName='edstestuser1';
        Blob key = Crypto.generateAesKey(128);
        string passPhrase = 'wEC38PruRaSw.bEm';
        Blob secretKey = Blob.valueOf(passPhrase);
        Blob tokenString = Blob.valueOf(CSS_EDSAuthentication.getToken(userName,userGroup)); 
        Blob encryptedStr = Crypto.encrypt('AES128',secretkey,secretKey,tokenString);       
        String encryptedKey = EncodingUtil.base64Encode(encryptedStr);
        String output = CSS_EDSAuthentication.getgenerateToken();  
    }
    @isTest static void testdetailsDSID(){
        Test.setMock(HttpCalloutMock.class, new CSS_DetailsDsid_Test());
        CSS_WS_EDS.getDSIDDetails('DSBDT5280','en');     
    }
    @isTest static void testdetailsDSI(){
        Test.setMock(HttpCalloutMock.class, new CSS_DetailsDS_Test());
        CSS_WS_EDS.getDSIDDetails('DSBDT5280','en');     
    }
    @IsTest static void testUnlockDsid(){
        Test.setMock(HttpCalloutMock.class, new CSS_ReportProblem_Test());
        string dsid = 'DSBDT6091';
        CSS_WS_EDS.unlockDsid('DSBDT4780'); 
    }
}