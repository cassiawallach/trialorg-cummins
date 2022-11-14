/************************************************************
Purpose: Test class of IAM_GuidanzMobile_GetAvailableCount.                        
=============================================================
History                                                                                                                     
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Shubhangi Sardar              02/08/2021        INITIAL DEVELOPMENT
***********************************************************************************/

@isTest
public class IAM_GuidanzMobile_GetAvailableCount_Test {
    static Contact con;
    static void buidData() {
        Account acc = IAM_TestData.createAccount();
        con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c appGM = IAM_TestData.createAccountSubscriptionGMFT(acc.Id,
        'Field Test Guidanz Mobile', 'Field Test Intapp Units Guidanz Mobile');
        IAM_TestData.createUserSubscriptionGMFT(con.Id, appGM.Id, 'Field Test Guidanz Mobile',
        'Field Test Intapp Units Guidanz Mobile');
    }

    static testMethod void validateRequest1(){
        buidData();
        IAM_GuidanzMobile_GetAvailableCount.InputRequest obj = 
        new IAM_GuidanzMobile_GetAvailableCount.InputRequest();
        obj.Type = null;
        obj.UserID = '';
        obj.DeviceInfo = '';
        IAM_GuidanzMobile_GetAvailableCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_GetAvailableCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));
    }
    
    static testMethod void validateRequest2(){
        buidData();
        IAM_GuidanzMobile_GetAvailableCount.InputRequest obj = 
        new IAM_GuidanzMobile_GetAvailableCount.InputRequest();
        obj.Type = 0;
        obj.UserID = '';
        obj.DeviceInfo = 'Android';
        IAM_GuidanzMobile_GetAvailableCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_GetAvailableCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));
    }
    
    static testMethod void validateRequest3(){
        buidData();
        IAM_GuidanzMobile_GetAvailableCount.InputRequest obj = 
        new IAM_GuidanzMobile_GetAvailableCount.InputRequest();
        obj.Type = 0;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = '';
        IAM_GuidanzMobile_GetAvailableCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_GetAvailableCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));
    }
    
    static testMethod void validateRequest4(){
        buidData();
        IAM_GuidanzMobile_GetAvailableCount.InputRequest obj = 
        new IAM_GuidanzMobile_GetAvailableCount.InputRequest();
        obj.Type = 4;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        IAM_GuidanzMobile_GetAvailableCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_GetAvailableCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));
    }
    
    static testMethod void checkCalAssistSub(){
        buidData();
        IAM_GuidanzMobile_GetAvailableCount.InputRequest obj = 
        new IAM_GuidanzMobile_GetAvailableCount.InputRequest();
        obj.Type = 0;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        IAM_GuidanzMobile_GetAvailableCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_GetAvailableCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));    
    }
    
    static testMethod void checkIntappOEMSub(){
        buidData();
        IAM_GuidanzMobile_GetAvailableCount.InputRequest obj = 
        new IAM_GuidanzMobile_GetAvailableCount.InputRequest();
        obj.Type = 2;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        IAM_GuidanzMobile_GetAvailableCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_GetAvailableCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));    
    }
    
    static testMethod void checkNoContact(){
        buidData();
        IAM_GuidanzMobile_GetAvailableCount.InputRequest obj = 
        new IAM_GuidanzMobile_GetAvailableCount.InputRequest();
        obj.Type = 2;
        obj.UserID = 'test@123.com';
        obj.DeviceInfo = 'Android';
        IAM_GuidanzMobile_GetAvailableCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_GetAvailableCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));    
    }
    
    static testMethod void getAvailableCount(){
        buidData();
        IAM_GuidanzMobile_GetAvailableCount.InputRequest obj = 
        new IAM_GuidanzMobile_GetAvailableCount.InputRequest();
        obj.Type = 1;
        obj.UserID = con.Username__c;
        obj.DeviceInfo = 'Android';
        IAM_GuidanzMobile_GetAvailableCount.CMI_ResponseHandler responseObj;
        Test.startTest();
        responseObj= IAM_GuidanzMobile_GetAvailableCount.doPost(obj);
        Test.stopTest();
        System.assert(String.isNotBlank(responseObj.Status));       
    }
}