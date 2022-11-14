@IsTest
public class FSL_4c_CompClass_Test {
    @testSetup static void dataSetup() 
    {
        FSLTestDataSetupCls.createIntegrationConfigs();   
    }
    static testMethod void CSS_4c_CompClass_Test_method(){
        
        Test.startTest();
        Profile p = [SELECT Id 
                     FROM Profile 
                     WHERE Name='CSS_Service_Advanced' LIMIT 1];
        UserRole ur = [SELECT id 
                       from UserRole 
                       WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User( Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');        
        insert newUser;
       
        system.runas(newUser){
            Account a = FSLTestDataSetupCls.createAccountData();
            Asset ast=FSLTestDataSetupCls.createAssetRecord();
            ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
            Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st);	
            PageReference pageRef = new PageReference('/apex/Jobplan?id=');
            test.setCurrentPage(pageRef);        
            pageRef.getParameters().put('id',wo.id);
            system.debug('job1.id>>>>'+wo.id);
            css_jobHistory__c jh = new css_jobHistory__c(css_field_name__c='EditComplaint__C',  css_Job_Id__c=wo.id);
            insert jh;
            css_jobHistory__c jh2 = new css_jobHistory__c(css_field_name__c='EditCause__c',css_Job_Id__c=wo.id);
            insert jh2;
            css_jobHistory__c jh3 = new css_jobHistory__c(css_field_name__c='EditCorrection__c', css_Job_Id__c=wo.id);
            insert jh3;
            css_jobHistory__c jh4 = new css_jobHistory__c(css_field_name__c='EditCoverage__c',  css_Job_Id__c=wo.id);
            insert jh4;          
            
            
                FSL_4c_CompClass fourc= new FSL_4c_CompClass();
            fourc.getFourCNotes();        
            fourc.getSortvalues(); 
            fourc.JobID = wo.id;  
            Test.stopTest();
        }
    }
}