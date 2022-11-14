@isTest
public class CSS_JobOrderWrapperTest {
     static TestMethod void joborder() {

              Test.startTest();
               CSS_Job_Order__c JO = new CSS_Job_Order__c();
               JO.Customer_Name__c = 'Test user';
               JO.Model__c = 'Test';
               JO.Make__c = 'CSSTest';
               JO.Failure_Point__c = 122;
               JO.Failure_Point_Measure__c ='Miles';
               JO.VIN__c='12345677890';
               JO.Failure_Date__c =date.today()-20;
               JO.Warranty_Start_Date__c =date.today()-365;
               JO.Location_Certification__c='abc';
               JO.jobLocation__c='abc';
               JO.Status__c = 'Repair Complete';
               JO.Unit_Number__c = 'test123';
               Jo.Assigned_To__c = UserInfo.getUserId();
               Jo.esn__c='79464646';
              insert(JO);
       CSS_JobOrderWrapper jobOrder =  new CSS_JobOrderWrapper(JO,'CSSTest','Test','Miles','Miles','US','IN',True,'venkat','@cummins.com',True);
        Test.stopTest();
     } 
}