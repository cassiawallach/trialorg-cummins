@isTest
public class CSS_ServicejobNotesClass_Test{

    static testMethod void test(){
        test.startTest();   
    
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'RoopaTnD';
                    
        insert(JO);
        
        JO.status__c = 'repair';
        update(JO);
        
        test.stopTest();
    }
}