@isTest
public class CSS_RPV_Test {
    @isTest  static void testRPV() {
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        CSS_JOB_Order__c cjb = new CSS_JOB_Order__c();
        cjb.Mileage__c = 1000;
        cjb.ESN__c = '79464646';
        cjb.Mileage_Measure__c = 'Kilometers';
        cjb.Equipment_ID__c = 'EQ7667';
        cjb.DSID__c = 'DSBDT4760';
        cjb.DSID_Creation_Timestamp__c = System.now();
        cjb.Control_Number__c = '1001';
        string vpersonType = 'DLR';
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='RPV';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='RPV';
        conDetails.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-services/repeatvisitflag';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='UCAWpwjTAyl9GA07EtVfLE7ZRneHQbe9tFdQr3Scppo=';
        conDetails.Passcode__c='tMV5G63AROB3ltlx1IFVDNI4xLPsdIh/92EJmPAsEMydxPXrM67Yx/tZw0Q4vUUAyp7iP9rLi9kGyEHJErsIXA=';
        conDetails.Username__c='m2ky1dU1LZj7LEn5Y7NjNs3+QOUWH8C/YokIo5KfwFW98WYpKY9QWzBYr+TKyg5Xhy5Hf7kHM8pfLGbwUrJbCQ==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';        
        insert conDetails;
        
        Test.setMock(HttpCalloutMock.class, new CSS_RPVMock_Test());
        CSS_RPV.repeatVisit(vpersonType, cjb.ESN__c, cjb.Mileage__c , cjb.Mileage_Measure__c, cjb.Equipment_ID__c, cjb.Name, cjb.DSID__c, cjb.DSID_Creation_Timestamp__c, cjb.Control_Number__c, cjb.id);
        insert cjb;
        
    }
        @isTest  static void testRPVSec() {
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        CSS_JOB_Order__c cjb = new CSS_JOB_Order__c();
        cjb.Mileage__c = 1000;
        cjb.ESN__c = '79464646';
        cjb.Mileage_Measure__c = 'Miles';
        cjb.Equipment_ID__c = '';
        cjb.DSID__c = '';
        cjb.DSID_Creation_Timestamp__c = null;
        cjb.Control_Number__c = '';
        string vpersonType = 'DLR';
            
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='RPV';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='RPV';
        conDetails.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-services/repeatvisitflag';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='UCAWpwjTAyl9GA07EtVfLE7ZRneHQbe9tFdQr3Scppo=';
        conDetails.Passcode__c='tMV5G63AROB3ltlx1IFVDNI4xLPsdIh/92EJmPAsEMydxPXrM67Yx/tZw0Q4vUUAyp7iP9rLi9kGyEHJErsIXA=';
        conDetails.Username__c='m2ky1dU1LZj7LEn5Y7NjNs3+QOUWH8C/YokIo5KfwFW98WYpKY9QWzBYr+TKyg5Xhy5Hf7kHM8pfLGbwUrJbCQ==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';        
        insert conDetails;
        Test.setMock(HttpCalloutMock.class, new CSS_RPVSecMock_Test());
        CSS_RPV.repeatVisit(vpersonType, cjb.ESN__c, cjb.Mileage__c , cjb.Mileage_Measure__c, cjb.Equipment_ID__c, cjb.Name, cjb.DSID__c, cjb.DSID_Creation_Timestamp__c, cjb.Control_Number__c, cjb.id);
        insert cjb;
        
    }
    @isTest static void testRPVSecond(){
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        CSS_JOB_Order__c cjb = new CSS_JOB_Order__c();
        cjb.Mileage__c = 1000;
        cjb.ESN__c = '79464646';
        cjb.Mileage_Measure__c = 'Miles';
        cjb.Equipment_ID__c = 'EQ7667';
        cjb.DSID__c = 'DSBDT4760';
        cjb.DSID_Creation_Timestamp__c = System.now();
        cjb.Control_Number__c = '1001';
        insert cjb;
        string vpersonType = 'DLR';
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='RPV';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='RPV';
        conDetails.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-services/repeatvisitflag';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='UCAWpwjTAyl9GA07EtVfLE7ZRneHQbe9tFdQr3Scppo=';
        conDetails.Passcode__c='tMV5G63AROB3ltlx1IFVDNI4xLPsdIh/92EJmPAsEMydxPXrM67Yx/tZw0Q4vUUAyp7iP9rLi9kGyEHJErsIXA=';
        conDetails.Username__c='m2ky1dU1LZj7LEn5Y7NjNs3+QOUWH8C/YokIo5KfwFW98WYpKY9QWzBYr+TKyg5Xhy5Hf7kHM8pfLGbwUrJbCQ==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';        
        insert conDetails;
        
        Test.setMock(HttpCalloutMock.class, new CSS_RPVMockSecond_Test());
        CSS_RPV.repeatVisitSecond(vpersonType, cjb.ESN__c, cjb.Mileage__c , cjb.Mileage_Measure__c, cjb.Equipment_ID__c, cjb.Name, cjb.DSID__c, cjb.DSID_Creation_Timestamp__c, cjb.Control_Number__c, cjb.id);
        
    }
     @isTest  static void testRPVSecMo() {
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test());
        CSS_JOB_Order__c cjb = new CSS_JOB_Order__c();
        cjb.Mileage__c = 1000;
        cjb.ESN__c = '79464646';
        cjb.Mileage_Measure__c = 'Kilometers';
        cjb.Equipment_ID__c = '';
        cjb.DSID__c = null;
        cjb.DSID_Creation_Timestamp__c = null;
        cjb.Control_Number__c = null;
        string vpersonType = 'DLR';
         
         CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name='RPV';
        conDetails.IsActive__c=true;
        conDetails.ApplicationName__c='RPV';
        conDetails.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-services/repeatvisitflag';
        conDetails.Method_Type__c='POST';
        conDetails.Key__c='UCAWpwjTAyl9GA07EtVfLE7ZRneHQbe9tFdQr3Scppo=';
        conDetails.Passcode__c='tMV5G63AROB3ltlx1IFVDNI4xLPsdIh/92EJmPAsEMydxPXrM67Yx/tZw0Q4vUUAyp7iP9rLi9kGyEHJErsIXA=';
        conDetails.Username__c='m2ky1dU1LZj7LEn5Y7NjNs3+QOUWH8C/YokIo5KfwFW98WYpKY9QWzBYr+TKyg5Xhy5Hf7kHM8pfLGbwUrJbCQ==';
        conDetails.AuthEnv__c='MuleAuth';
        conDetails.Timeout__c=120000;
        conDetails.Logging__c='BOTH';        
        insert conDetails;
         
        Test.setMock(HttpCalloutMock.class, new CSS_RPVSecMock_Test());
        CSS_RPV.repeatVisitSecond(vpersonType, cjb.ESN__c, cjb.Mileage__c , cjb.Mileage_Measure__c, cjb.Equipment_ID__c, cjb.Name, cjb.DSID__c, cjb.DSID_Creation_Timestamp__c, cjb.Control_Number__c, cjb.id);
        insert cjb;
        
    }
}