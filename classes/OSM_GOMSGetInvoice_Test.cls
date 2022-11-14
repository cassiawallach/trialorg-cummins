//Test Class for the class OSM_GOMSGetInvoice
@istest
public class OSM_GOMSGetInvoice_Test {
    @testSetup
    static void dataSetup() {
        Account acc = new Account(Name = 'Testing');
        insert acc;
    }
    
    static testMethod void testPost() {
    
    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/GOMSGetInvoice/';
        req.httpMethod = 'POST';
        req.requestBody=Blob.valueof('{"INVOICE_DATA": [{"TRANSACTION_ID": "I-0000013990","SHIP_TO_ABBR": "2860","INVOICE_ID": "6128890","STATUS": "SUCCESS","MESSAGE": "SUCCESS"},{"TRANSACTION_ID": "I-00002","SHIP_TO_ABBR": "2930","INVOICE_ID": [], "STATUS": "FAILURE", "MESSAGE": "INVALID CUSTOMER NO." },{"TRANSACTION_ID": "I-00003","SHIP_TO_ABBR": "2400","INVOICE_ID": "6128891","STATUS": "SUCCESS", "MESSAGE": "SUCCESS"}]}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
        req.requestBody=Blob.valueof('{"INVOICE_DATA": [{"TRANSACTION_ID": "I-0000013990","SHIP_TO_ABBR": "2860","INVOICE_ID": "6128890","STATUS": "SUCCESS","MESSAGE": "SUCCESS"},{"TRANSACTION_ID": "I-00003","SHIP_TO_ABBR": "2400","INVOICE_ID": "6128891","STATUS": "SUCCESS", "MESSAGE": "SUCCESS"}]}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
        req.requestBody=Blob.valueof('{"INVOICE_DATA": []}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
        req.requestBody=Blob.valueof('{"INVOICE_DATA": [{"TRANSACTION_ID": "I-0000013990","SHIP_TO_ABBR": "2860","INVOICE_ID": "6128890","STATUS": "SUCCESS","MESSAGE": "SUCCESS"},,{"TRANSACTION_ID": "I-00003","SHIP_TO_ABBR": "2400","INVOICE_ID": "6128891","STATUS": "SUCCESS", "MESSAGE": "SUCCESS"}]}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
        
    }
    
    static testMethod void testPost2() {
     Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CSS_DistributorCode__c = '02850';
        testAccount.CSS_DBCode__c = '020400';
        testAccount.BMS_Customer_ID__c = '22925';
        testAccount.Customer_Location_Code__c = '123';

        insert testAccount;

        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = testAccount.Id, Username__c = 'testqwerty123@gmail.com',
            Email = System.now().millisecond() + 'test@test.com',
            recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()
        );
        insert contact1;
    
        ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c();
        contactAddress.Account__c = testAccount.id;
        contactAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
        contactAddress.ccrz__City__c = 'Scottsdale';
        contactAddress.ccrz__State__c = 'Arizona';
        contactAddress.ccrz__StateISOCode__c = 'AZ';
        contactAddress.ccrz__PostalCode__c = '85259';
        contactAddress.ccrz__CountryISOCode__c = 'US';
        insert contactAddress;

        List < ccrz__E_Cart__c > lstECart = new List < ccrz__E_Cart__c > ();
        ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
        testCart.ccrz__Storefront__c = 'Software';
        testCart.ccrz__CartType__c = 'Cart';
        testCart.ccrz__ActiveCart__c = true;
        testCart.ccrz__CartStatus__c = 'Open';
        testCart.ccrz__User__c = UserInfo.getUserId();
        testCart.ccrz__EncryptedId__c = 'encrypt';
        lstECart.add(testCart);
        insert lstECart;
        
        ccrz__E_Order__c testOrder = new ccrz__E_Order__c();
        testOrder.ccrz__Name__c = 'TestOrder';
        testOrder.ccrz__Contact__c = contact1.id;
        testOrder.ccrz__Account__c = testAccount.Id;
        testOrder.BMS_BranchLocation__c = 'E4';
        testOrder.Order_Source_Type__c = 'OSM';
        testOrder.BMS_OrderRefNumber__c = 12345;
        
        testOrder.ccrz__OriginatedCart__c = testCart.id;
        testOrder.ccrz__BillTo__c = contactAddress.id;
        testOrder.ccrz__ShipTo__c = contactAddress.id;
        insert testOrder;
    
    ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
//        ccInvoices.Name='TRANSACTION_ID';
        ccInvoices.ccrz__CCOrder__c = testOrder.id;
        ccInvoices.ccrz__Contact__c = contact1.id;
        ccInvoices.ccrz__CurrencyCode__c = 'USD';
        ccInvoices.ccrz__Status__c = 'Open';
        ccInvoices.ccrz__Storefront__c = 'Software';
        ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
        ccInvoices.ccrz__OriginalAmount__c = 200;
        ccInvoices.ccrz__Terms__c = 'TestDataTerms';
        ccInvoices.BMS_PONumber__c = '123456';
        ccInvoices.BMS_InvoiceNumber__c = 123456;
        
        insert ccInvoices;
        
        system.debug('Invoice ID'+ccInvoices);
        
        ccrz__E_TransactionPayment__c transactionPayment = new ccrz__E_TransactionPayment__c();
        // transactionPayment.Transaction_Status__c = transactionStatus;
        transactionPayment.ccrz__Storefront__c = 'SoftwareStore';
        transactionPayment.ccrz__Token__c = 'TestToken';
        transactionPayment.ccrz__TransactionCode__c = 'TestTransactionCode';
        transactionPayment.ccrz__CCOrder__c = testOrder.id;
        // transactionPayment.ccrz__InvoiceAppliedTo__c = lstCCInvoices[0].id;
        transactionPayment.ccrz__InvoiceAppliedTo__c = ccInvoices.id;
        transactionPayment.ccrz__BillTo__c = testAccount.id;
        transactionPayment.ccrz__SoldTo__c = testAccount.id;
        transactionPayment.ccrz__Account__c = testAccount.id;
        transactionPayment.ccrz__Contact__c = contact1.id;
        //  transactionPayment.ccrz__User__c = userID;
        //  transactionPayment.ccrz__AccountType__c = accountType;
        transactionPayment.ccrz__AccountNumber__c = '1';
        insert transactionPayment;
        
         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/GOMSGetInvoice/';
        req.httpMethod = 'POST';
        req.requestBody=Blob.valueof('{"INVOICE_DATA": [{"TRANSACTION_ID": '+ccInvoices.Name+',"SHIP_TO_ABBR": "2860","INVOICE_ID": "6128890","STATUS": "SUCCESS","MESSAGE": "SUCCESS"},{"TRANSACTION_ID": "I-00002","SHIP_TO_ABBR": "2930","INVOICE_ID": [], "STATUS": "FAILURE", "MESSAGE": "INVALID CUSTOMER NO." },{"TRANSACTION_ID": "I-00003","SHIP_TO_ABBR": "2400","INVOICE_ID": "6128891","STATUS": "SUCCESS", "MESSAGE": "SUCCESS"}]}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
        req.requestBody=Blob.valueof('{"INVOICE_DATA": [{"TRANSACTION_ID": "ccInvoices.Name","SHIP_TO_ABBR": "2860","INVOICE_ID": "6128890","STATUS": "SUCCESS","MESSAGE": "SUCCESS"},{"TRANSACTION_ID": "I-00003","SHIP_TO_ABBR": "2400","INVOICE_ID": "6128891","STATUS": "SUCCESS", "MESSAGE": "SUCCESS"}]}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
        req.requestBody=Blob.valueof('{"INVOICE_DATA": []}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
       // req.requestBody=Blob.valueof('{"INVOICE_DATA": [{"TRANSACTION_ID": "ccInvoices.Name","SHIP_TO_ABBR": "2860","INVOICE_ID": "6128890","STATUS": "SUCCESS","MESSAGE": "SUCCESS"},,{"TRANSACTION_ID": "I-00003","SHIP_TO_ABBR": "2400","INVOICE_ID": "6128891","STATUS": "SUCCESS", "MESSAGE": "SUCCESS"}]}');
        RestContext.request = req;
        RestContext.response= res; 
        OSM_GOMSGetInvoice.UpdateInvoice(); 
    }
    static testMethod void testPost3() {
     Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CSS_DistributorCode__c = '02850';
        testAccount.CSS_DBCode__c = '020400';
        testAccount.BMS_Customer_ID__c = '22925';
        testAccount.Customer_Location_Code__c = '123';

        insert testAccount;

        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = testAccount.Id, Username__c = 'testqwerty123@gmail.com',
            Email = System.now().millisecond() + 'test@test.com',
            recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()
        );
        insert contact1;
    
        ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c();
        contactAddress.Account__c = testAccount.id;
        contactAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
        contactAddress.ccrz__City__c = 'Scottsdale';
        contactAddress.ccrz__State__c = 'Arizona';
        contactAddress.ccrz__StateISOCode__c = 'AZ';
        contactAddress.ccrz__PostalCode__c = '85259';
        contactAddress.ccrz__CountryISOCode__c = 'US';
        insert contactAddress;

        List < ccrz__E_Cart__c > lstECart = new List < ccrz__E_Cart__c > ();
        ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
        testCart.ccrz__Storefront__c = 'Software';
        testCart.ccrz__CartType__c = 'Cart';
        testCart.ccrz__ActiveCart__c = true;
        testCart.ccrz__CartStatus__c = 'Open';
        testCart.ccrz__User__c = UserInfo.getUserId();
        testCart.ccrz__EncryptedId__c = 'encrypt';
        lstECart.add(testCart);
        insert lstECart;
        
        ccrz__E_Order__c testOrder = new ccrz__E_Order__c();
        testOrder.ccrz__Name__c = 'TestOrder';
        testOrder.ccrz__Contact__c = contact1.id;
        testOrder.ccrz__Account__c = testAccount.Id;
        testOrder.BMS_BranchLocation__c = 'E4';
        testOrder.Order_Source_Type__c = 'OSM';
        testOrder.BMS_OrderRefNumber__c = 12345;
        
        testOrder.ccrz__OriginatedCart__c = testCart.id;
        testOrder.ccrz__BillTo__c = contactAddress.id;
        testOrder.ccrz__ShipTo__c = contactAddress.id;
        insert testOrder;
    
        ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();

        ccInvoices.ccrz__CCOrder__c = testOrder.id;
        ccInvoices.ccrz__Contact__c = contact1.id;
        ccInvoices.ccrz__CurrencyCode__c = 'USD';
        ccInvoices.ccrz__Status__c = 'Open';
        ccInvoices.ccrz__Storefront__c = 'Software';
        ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
        ccInvoices.ccrz__OriginalAmount__c = 200;
        ccInvoices.ccrz__Terms__c = 'TestDataTerms';
        ccInvoices.BMS_PONumber__c = '123456';
        ccInvoices.BMS_InvoiceNumber__c = 123456;
        
        insert ccInvoices;
        
        system.debug('Invoice records id '+ccInvoices.id);
        
        ccrz__E_TransactionPayment__c transactionPayment = new ccrz__E_TransactionPayment__c();
        // transactionPayment.Transaction_Status__c = transactionStatus;
        transactionPayment.ccrz__Storefront__c = 'SoftwareStore';
        transactionPayment.ccrz__Token__c = 'TestToken';
        transactionPayment.ccrz__TransactionCode__c = 'TestTransactionCode';
        transactionPayment.ccrz__CCOrder__c = testOrder.id;
        // transactionPayment.ccrz__InvoiceAppliedTo__c = lstCCInvoices[0].id;
        transactionPayment.ccrz__InvoiceAppliedTo__c = ccInvoices.id;
        transactionPayment.ccrz__BillTo__c = testAccount.id;
        transactionPayment.ccrz__SoldTo__c = testAccount.id;
        transactionPayment.ccrz__Account__c = testAccount.id;
        transactionPayment.ccrz__Contact__c = contact1.id;
        //  transactionPayment.ccrz__User__c = userID;
        //  transactionPayment.ccrz__AccountType__c = accountType;
        transactionPayment.ccrz__AccountNumber__c = '1';
        insert transactionPayment;
        
         RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/GOMSGetInvoice/';
        req.httpMethod = 'POST';
        req.requestBody=Blob.valueof('{"INVOICE_DATA": []}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
         req.requestBody=Blob.valueof('{"INVOICE_DATA": [{"TRANSACTION_ID": "","SHIP_TO_ABBR": "2860","INVOICE_ID": "6128890","STATUS": "SUCCESS","MESSAGE": "SUCCESS"},,{"TRANSACTION_ID": "","SHIP_TO_ABBR": "2400","INVOICE_ID": "","STATUS": "SUCCESS", "MESSAGE": "SUCCESS"}]}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
        req = new RestRequest(); 
        res = new RestResponse();             
        req.requestURI = '/services/apexrest/GOMSGetInvoice/';
        req.httpMethod = 'POST';
        
        system.debug('Invoice id '+ccInvoices.id);
        req.requestBody=Blob.valueof('{"INVOICE_DATA": [{"TRANSACTION_ID":'+ccInvoices.id+',"SHIP_TO_ABBR": "2860","INVOICE_ID": "6128890","STATUS": "SUCCESS","MESSAGE": "SUCCESS"}]}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
         req.requestBody=Blob.valueof('{"INVOICE_DATA": [{"TRANSACTION_ID":"'+ccInvoices.id+'","SHIP_TO_ABBR": "2860","INVOICE_ID": "6128890","STATUS": "ERROR","MESSAGE": "SUCCESS"},{"TRANSACTION_ID": "'+ccInvoices.id+'","SHIP_TO_ABBR": "2400","INVOICE_ID": "6128890","STATUS": "Failure", "MESSAGE": "Failure"}]}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
         req.requestBody=Blob.valueof('{"INVOICE_DATA": [{"TRANSACTION_ID":"'+ccInvoices.id+'","SHIP_TO_ABBR": "2860","INVOICE_ID": "6128890","STATUS": "SUCCESS","MESSAGE": "SUCCESS"} ]}');
        RestContext.request = req;
        RestContext.response= res;
        OSM_GOMSGetInvoice.UpdateInvoice();
        

    }
}