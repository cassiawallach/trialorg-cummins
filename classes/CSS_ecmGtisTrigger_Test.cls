@isTest
public class CSS_ecmGtisTrigger_Test {
    
    public static testMethod void testGtis() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        CSS_Job_Order__c job1;
        CSS_Job_Order__c job2;
        CSS_ECM__c ecm;
        CSS_ECM__c ecm2;
        
        System.runAs(newUser) {
            job1 = new CSS_Job_Order__c(ownerId = newUser.id,Customer_Name__c='Nick',service_model__c='Test');
            insert job1;
             ecm = new CSS_ecm__c(ECM_Number__c=0,name='ECM1',CORE__c = 'GTIS_20' ,Job_Order__c=job1.id);
            insert ecm;           
            
            job2 = new CSS_Job_Order__c(ownerId = newUser.id,Customer_Name__c='Nick',service_model__c='Test');
            insert job2;
             ecm2 = new CSS_ecm__c(ECM_Number__c=0,name='ECM2',CORE__c = 'GTIS_38' ,Job_Order__c=job2.id);
            insert ecm2; 
            
        }
    }


}