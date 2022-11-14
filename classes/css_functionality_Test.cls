@isTest
public class css_functionality_Test{
   static testmethod void css_functionality_Test_method(){
       test.startTest();
            css_job_order__c work = new css_job_order__c();
            work.Customer_Name__c = 'Test';
            work.Shop_Work_Order__c='123';
            work.Application__c = '7896';
            work.DSID_WorkGroup__c='qwer';
            work.Unit_Number__c='456';  
            work.Failure_Point__c= 123;
            insert(work);
            css_functionality cssfunc = new css_functionality();
            css_functionality.addToJobHistory('objName',work.Id,'fieldname','oldvalue','newvalue');
       test.stopTest();
   }
    
}