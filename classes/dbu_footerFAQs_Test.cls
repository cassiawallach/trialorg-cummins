@isTest
public class dbu_footerFAQs_Test {
    static testMethod void testfetchFAQsName() {  
        
        dbu_FAQ__c objFAQ = new dbu_FAQ__c();
        //objFAQ.Name = 'Test FAQ';
        objFAQ.Question__c= 'Test Question';
        objFAQ.Answer__c= 'Test Answer';
         objFAQ.FAQCategory__c= 'Order';
        
        Insert objFAQ;
        
         dbu_FAQ__c objFAQ1 = new dbu_FAQ__c();
        //objFAQ.Name = 'Test FAQ';
        objFAQ1.Question__c= 'Test Question';
        objFAQ1.Answer__c= 'Test Answer';
         objFAQ1.FAQCategory__c= 'Order';
        
        Insert objFAQ1;
        
        Test.startTest();  
            dbu_footerFAQs.fetchFAQsName();   
        Test.stopTest();  
    } 
}