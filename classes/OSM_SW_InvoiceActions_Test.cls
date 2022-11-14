@isTest 
public class OSM_SW_InvoiceActions_Test {

    static testMethod void testOSM_SW_InvoiceActions(){
        
        //Create User
        User objUser = TestingUtils.ADMIN_USER;
        
        //Create Account Group
        List<ccrz__E_AccountGroup__c> listAccountGrp = TestingUtils.createAccountGroup(5, 'TestDataAccountGroup', 'Best Price', true);
        
        //Create Account
        List<Account> listAccount = TestingUtils.createAccount(1, 'TestAccountData', listAccountGrp[0].Id, objUser.Id, true);
        
        //Create Contact
        List<Contact> listContact  = TestingUtils.createContact(1, listAccount[0].Id, null, true);
       
        // Create Order
        ccrz__E_Order__c objOrder = TestingUtils.createOrder(listContact[0].Id, 'TestDataOrder', true);
        
        // Create CC Invoices
        List<ccrz__E_Invoice__c> listCCInvoices = TestingUtils.createCCInvoices(1,objOrder.Id, listContact[0].Id,'Open','SoftwareStore', true);
        
        // Get List of Invoice Id's
        List<Id> listInvoiceIds = new List<Id>();
        if(!listCCInvoices.isEmpty()){
            for(ccrz__E_Invoice__c objInvoice: listCCInvoices){
            	listInvoiceIds.add(objInvoice.Id);
        	}
        }
        
        // Start Test
        Test.startTest();
        	
        	//OSM_SW_InvoiceActions.setARInvoiceOutboundWrapper(listInvoiceIds);
        
        // Stop Test
        Test.stopTest();
    }
}