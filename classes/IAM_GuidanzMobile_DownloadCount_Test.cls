/************************************************************
Purpose: Test class of IAM_GuidanzMobile_DownloadCount.                        
=============================================================
History                                                                                                                     
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Shubhangi Sardar              02/08/2021        INITIAL DEVELOPMENT
***********************************************************************************/

@isTest
public class IAM_GuidanzMobile_DownloadCount_Test {
	static Contact con;
    static void buidData() {
        Account acc = IAM_TestData.createAccount();
        con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c appGM = IAM_TestData.createAccountSubscriptionGMFT(acc.Id,
        'Field Test Guidanz Mobile', 'Field Test Intapp Units Guidanz Mobile');
        IAM_TestData.createUserSubscriptionGMFT(con.Id, appGM.Id, 'Field Test Guidanz Mobile',
        'Field Test Intapp Units Guidanz Mobile');
        IAM_Application__c appGMPaid = IAM_TestData.createAccountSubscriptionGMFT(acc.Id,
        'Guidanz Mobile', 'Guidanz Mobile Intapp Units');
        IAM_TestData.createUserSubscriptionGMFT(con.Id, appGMPaid.Id, 'Guidanz Mobile', 'Guidanz Mobile Intapp Units');
    }
	
    static testMethod void validateRequest1(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = null;
        obj.UserID = '';
        obj.DeviceInfo = '';
        obj.RequestedCount = 1;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));
    }
    
    static testMethod void validateRequest2(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = 0;
        obj.UserID = '';
        obj.DeviceInfo = 'Android';
        obj.RequestedCount = 1;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));
    }
    
    static testMethod void validateRequest3(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = 0;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = '';
        obj.RequestedCount = 1;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));
    }
    
    static testMethod void validateRequest4(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = 4;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        obj.RequestedCount = 1;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));
    }
    
    static testMethod void validateRequest5(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = 1;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        obj.RequestedCount = 0;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));
    }
    
    static testMethod void validateRequest6(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = 1;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        obj.RequestedCount = null;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));
    }
    
    static testMethod void checkCalAssistSub(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = 0;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        obj.RequestedCount = 1;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));    
    }
    
    static testMethod void checkIntappOEMSub(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = 2;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        obj.RequestedCount = 1;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));    
    }
    
    static testMethod void checkNoContact(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = 2;
        obj.UserID = 'test@123.com';
        obj.DeviceInfo = 'Android';
        obj.RequestedCount = 1;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));    
    }
    
    static testMethod void checkDownloadCount1(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = 1;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        obj.RequestedCount = 1;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));       
    }
    
    static testMethod void checkDownloadCount2(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = 1;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        obj.RequestedCount = 5;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));       
    }
    
    static testMethod void checkDownloadCount3(){
        buidData();
        IAM_GuidanzMobile_DownloadCount.InputRequest obj = 
        new IAM_GuidanzMobile_DownloadCount.InputRequest();
        obj.Type = 1;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        obj.RequestedCount = 11;
        IAM_GuidanzMobile_DownloadCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_DownloadCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));       
    }
}