@isTest
public class IAM_ContactAppInfoControllerTest{
    static testMethod void testMethod1(){
        App_Mapping__c appMapping = new App_Mapping__c();
        appMapping.Name = 'Online Login';
        appMapping.IAM_Default_Role__c = 'User';
        appMapping.IAM_App_Protected_By__c = 'SAML';
        insert appMapping;
        
        
        User usr = [Select id,IAM_Final_Approver__c from User where Id = :UserInfo.getUserId()];
        System.RunAs(usr){
            Test.startTest();
            IAM_ContactAppInfoController.getContactAppInfo(appMapping.id);
            IAM_ContactAppInfoController.getContactAppInfo(null);
            Test.stopTest();
        }
    }   
        
    /*static testMethod void testMethod2(){
        
    }*/
    
}