@isTest
public class IAM_ContactDistributorInfoTest{
    static testMethod void testMethod1(){
        App_Mapping__c appMapping = new App_Mapping__c();
        appMapping.Name = 'Online Login';
        appMapping.IAM_Default_Role__c = 'User';
        appMapping.IAM_App_Protected_By__c = 'SAML';
        appMapping.Back_page__c = 'https://www.cummins.com/';
        appMapping.Login_Url__c = 'https://iamdev-cumminscss.cs63.force.com/cw/IAM_NewRegistration?appid=a1a6C0000002SXr';
        insert appMapping;
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Distributor Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get(System.Label.IAM_WWSPS).getRecordTypeId();
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1';
        acc1.Type = 'Dealer Account';
        acc1.parentid = acc.id;
        insert acc1;
        
        ApexPages.CurrentPage().getparameters().put('appid',appMapping.id);
        ApexPages.CurrentPage().getparameters().put('accid',acc.id);
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
            IAM_ContactDistributorInfo contDInfo = new IAM_ContactDistributorInfo();
            contDInfo.redirectBackpage();
            contDInfo.Login();
            contDInfo.SaveandClose();
            contDInfo.Close();
            ApexPages.CurrentPage().getparameters().put('accid',acc1.id);
            IAM_ContactDistributorInfo contDInfo1 = new IAM_ContactDistributorInfo();
            
            Test.stopTest();
        }
    }   
        
    /*static testMethod void testMethod2(){
        
    }*/
    
}