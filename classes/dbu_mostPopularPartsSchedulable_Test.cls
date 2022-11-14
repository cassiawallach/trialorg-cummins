@isTest
public class dbu_mostPopularPartsSchedulable_Test 
{
    static testmethod void schedulerTest() 
    {
        String CRON_EXP = '0 0 0 15 3 ? *';
        
        // Create your test data
        List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
        List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>(); 
        
        //ccrz__E_Product__c objProduct = new ccrz__E_Product__c();
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        //Product
          ccrz__E_Product__c objProduct = new ccrz__E_Product__c(ccrz__SKU__c = '15458776',
                                                               Name = 'Connected Advisor',
                                                               ccrz__ShortDesc__c = 'testing',
                                                               ccrz__Quantityperunit__c = 3343,
                                                               ccrz__StartDate__c = system.today(),
                                                               ccrz__EndDate__c = system.today()+1,
        													   dbu_mostPopularParts__c = false);
        insert objProduct;
        
        ccrz__E_Product__c objProduct2 = new ccrz__E_Product__c(Name = 'Test',
                                                                ccrz__SKU__c = '15458777',
                                                                ccrz__ShortDesc__c = 'testing',
                                                                ccrz__Quantityperunit__c = 3343,
                                                                ccrz__StartDate__c = system.today(),
                                                                ccrz__EndDate__c = system.today()+1,
            												    dbu_mostPopularParts__c = false);
        insert objProduct2;
        //Order
        ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true);
        order.ccrz__OrderStatus__c='Cancellation Pending'; 
        Insert order;
        
        // OrderItem 
        orderItem.ccrz__Price__c = 500;
        orderItem.ccrz__Quantity__c = 55;
        orderItem.ccrz__SubAmount__c = 250;
        orderItem.ccrz__Order__c = order.id;
        orderItem.ccrz__Product__c = objProduct.Id; 
        Insert orderItem;
        
        ccrz__E_OrderItem__c orderItem2 = new ccrz__E_OrderItem__c();
        orderItem2.ccrz__Price__c = 500;
        orderItem2.ccrz__Quantity__c = 75;
        orderItem2.ccrz__SubAmount__c = 250;
        orderItem2.ccrz__Order__c = order.id;
        orderItem2.ccrz__Product__c = objProduct2.Id;
        Insert orderItem2;
        
        Test.startTest();

            String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new dbu_mostPopularPartsSchedulableClass());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
        // Add assert here to validate result
    }

}