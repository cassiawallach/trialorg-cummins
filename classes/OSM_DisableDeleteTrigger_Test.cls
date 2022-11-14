@isTest
public class OSM_DisableDeleteTrigger_Test 
{
    static testmethod void testDisableDeleteTriggers()
    {
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        System.RunAs(usr){       
            try{  
                ccrz__E_Cart__c cart = new ccrz__E_Cart__c();
                insert cart;
                delete cart;
            }
            catch(Exception e)
            {
                Boolean expectedExceptionThrown = e.getMessage().contains('ERROR : You do not have delete permission') ? true : false;
                
                System.AssertEquals(expectedExceptionThrown, true);
            }
            
            // test case for Contact Address Disable Delete Trigger
            try
            {
                ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c();
                contactAddress.ccrz__AddressFirstline__c = 'Test Address';
                contactAddress.ccrz__City__c = 'Columbus';
                
                insert contactAddress;
                delete contactAddress;
            }
            catch(Exception e)
            {
                Boolean expectedExceptionThrown = e.getMessage().contains('ERROR : You do not have delete permission') ? true : false;
                
                System.AssertEquals(expectedExceptionThrown, true);
            }
            
            // test case for Invoice Disable Delete Trigger
            try
            {
                ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
                
                insert invoice;
                delete invoice;
            }
            catch(Exception e)
            {
                Boolean expectedExceptionThrown = e.getMessage().contains('ERROR : You do not have delete permission') ? true : false;
                
                System.AssertEquals(expectedExceptionThrown, true);
            }
            
            // test case for Invoice Item Disable Delete Trigger
            try
            {
                ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c();
                
                insert invoice;
                ccrz__E_InvoiceItem__c invoiceItem = new ccrz__E_InvoiceItem__c();
                invoiceItem.ccrz__Invoice__c = invoice.ID;
                
                insert invoiceItem;
                delete invoiceItem;
            }
            catch(Exception e)
            {
                Boolean expectedExceptionThrown = e.getMessage().contains('ERROR : You do not have delete permission') ? true : false;
                
                System.AssertEquals(expectedExceptionThrown, true);
            }
            
            // test case for Order Disable Delete Trigger
            try
            { 
                ccrz__E_Order__c order = new ccrz__E_Order__c();
                insert order;
                delete order;
            }
            catch(Exception e)
            {
                Boolean expectedExceptionThrown = e.getMessage().contains('ERROR : You do not have delete permission') ? true : false;
                
                System.AssertEquals(expectedExceptionThrown, true);
            }
            
            // test case for Order Item Disable Delete Trigger
            try
            {
                ccrz__E_Order__c order = new ccrz__E_Order__c();
                insert order;
                
                ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
                orderItem.ccrz__Order__c = order.ID;
                orderItem.ccrz__Price__c = 20.00;
                orderItem.ccrz__Quantity__c = 10;
                orderItem.ccrz__SubAmount__c = 15.00;
                
                insert orderItem;
                delete orderItem;
            }
            catch(Exception e)
            {
                Boolean expectedExceptionThrown = e.getMessage().contains('ERROR : You do not have delete permission') ? true : false;
                
                System.AssertEquals(expectedExceptionThrown, true);
            }
            
            // test case for Subscription Disable Delete Trigger
            try
            {
                ccrz__E_Subscription__c subscription = new ccrz__E_Subscription__c();
                subscription.ccrz__Sequence__c = 500;
                subscription.ccrz__Storefront__c = 'SoftwareStore';
                subscription.ccrz__SubscriptionStatus__c = 'Active';
                subscription.ccrz__SubscriptionStartDate__c = System.today();
                
                insert subscription;
                delete subscription;
            }
            catch(Exception e)
            {
                Boolean expectedExceptionThrown = e.getMessage().contains('ERROR : You do not have delete permission') ? true : false;
                
                System.AssertEquals(expectedExceptionThrown, true);
            }
            try
            {
                ccrz__E_TransactionPayment__c transactionPayment = new ccrz__E_TransactionPayment__c();
                
                insert transactionPayment;
                delete transactionPayment;
            }
            catch(Exception e)
            {
                Boolean expectedExceptionThrown = e.getMessage().contains('ERROR : You do not have delete permission') ? true : false;
                
                System.AssertEquals(expectedExceptionThrown, true);
            }
        }
    }
}