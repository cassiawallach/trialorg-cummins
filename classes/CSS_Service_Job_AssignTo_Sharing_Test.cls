@isTest
private class CSS_Service_Job_AssignTo_Sharing_Test
{

static testMethod void testAddShares() {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi9@cummins.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi9@cummins.com', User_Location__c='123456');
        insert objUser1;
        User objUser2 = new User(Alias = 'cmi-u1', Email='css-cmi2@cummins.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi2@cummins.com',User_Location__c='123456');
        insert objUser2;

           
       CSS_Job_Order__c obj = new CSS_Job_Order__c();
        obj.ESN__c = '79586617';
        obj.Mileage__c = 12345;
        obj.Mileage_measure__c = 'Miles'; 
        insert obj;
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator_Test());  
        
        //CSS_receive30DayAlerts.requestAlerts(obj.Id,obj.ESN__c,obj.Name,obj.Mileage__c,obj.Mileage_measure__c);
    
            Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator_Test());
            CSS_Remote_Connection__c ConnectionObj = new CSS_Remote_Connection__c(Application_Name__c='ConnectedDiagnostics-30DayAlert');
            insert ConnectionObj;

            Set<ID> ids = new Set<ID>();
            List<CSS_Job_Order__c> jobs = new List<CSS_Job_Order__c>();
            
            for (Integer i=0;i<10;i++)
              jobs.add(new CSS_Job_Order__c(Customer_Name__c='Name '+i, Assigned_To__c=objUser1.Id));
        
            insert jobs;
        
            for (CSS_Job_Order__c j1 : jobs)
              ids.add(j1.id);
        
            // Assert no share exists
            List<CSS_Job_Order__share> shares = [select id from CSS_Job_Order__share where ParentId IN :ids and RowCause = 'CSS_Apex_AssignedTo_Sharing__c'];
            System.assertEquals(shares.size(),0);
    
                for (CSS_Job_Order__c j2 : jobs){
                  j2.Assigned_To__c=objUser2.Id;
                //  j2.ESN__c = 'sampleEsn';
                }
            
                update jobs;
        
            // Assert share exists
            List<CSS_Job_Order__share> shares1 = [select id from CSS_Job_Order__share where ParentId IN :ids and RowCause = 'CSS_Apex_AssignedTo_Sharing__c'];
            //System.assertEquals(shares1.size(),10);


             for (CSS_Job_Order__c j3 : jobs)
                  j3.Assigned_To__c=objUser1.Id;
            
                update jobs;
        
            // Assert no share exists
            List<CSS_Job_Order__share> shares2 = [select id from CSS_Job_Order__share where ParentId IN :ids and RowCause = 'CSS_Apex_AssignedTo_Sharing__c'];
            //System.assertEquals(shares2.size(),20);

        }
  CSS_Remote_Connection__c req = new CSS_Remote_Connection__c();
  CSS_Remote_Connection__c ConnectionObj = [SELECT Application_URL__c,Password1__c from CSS_Remote_Connection__c where Application_Name__c='ConnectedDiagnostics-30DayAlert'];
}