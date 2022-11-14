//Updated By Singaiah for MAR-1994 27-09-2021
//Updated for US-867
@isTest
private class OSM_Intercompany_BusinessLayerHand_Test {

	private static testMethod void intercompany_BusinessLayerHandler_Test() {
	    
        Account objAccount = new Account(Name = 'Test Account',
                                         BMS_Customer_ID__c  = '12345',
                                         CSS_DistributorCode__c  = '12345',
                                         //EBU_Channel_of_Distribution__c = 'CIHR',
                                         //PSBU_Channel_of_Distribution__c = 'CIHR',
                                         OSM_SW_Responsible_Region__c = 'test',
                                         BMS_Customer_ID_Junction__c = '12345');
        insert objAccount;
        
        ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true,
                                                      Order_Source_Type__c = 'OSM',
                                                      BMS_OrderRefNumber__c = 12345,
                                                      BMS_BranchLocation__c = 'test',
                                                      OSM_SW_Refund_Order_Source_Type__c = 'OSM',
                                                      BMS_Order_reference_number_Refund__c = 12345);
        insert order;
            
       	ccrz__E_Product__c prod = TestingUtils.insertProduct();
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        orderList.add(order);
        
        List<ccrz__E_OrderItem__c> orderItems = TestingUtils.insertOrderItemList(orderList, prod);
        ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
        ccInvoices.ccrz__CCOrder__c = order.id;
        // ccInvoices.ccrz__Contact__c = contact1.id;
        ccInvoices.ccrz__CurrencyCode__c = 'USD';
        ccInvoices.ccrz__Status__c = 'Open';
        ccInvoices.ccrz__Storefront__c = 'Software';
        ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
        ccInvoices.ccrz__OriginalAmount__c = 200;
        ccInvoices.ccrz__Terms__c = 'TestDataTerms';
        ccInvoices.BMS_PONumber__c='123456';
        ccInvoices.BMS_InvoiceNumber__c=123456;
        ccInvoices.OSM_Child_Account__c = objAccount.Id;
        //ccInvoices.ccrz__SoldTo__c = objAccount.Id;
        insert ccInvoices;
	    

        List<ccrz__E_Invoice__c> invList = new List<ccrz__E_Invoice__c>();
        invList.add(ccInvoices);
        List<ccrz__E_InvoiceItem__c> invItemlist = TestingUtils.insertInvoiceItemList( invList, order.id, orderItems[0].Id );
	    Test.startTest();
	    
	    ccrz__E_Invoice__c objInvoice = [SELECT Id,Name,CreatedDate,ccrz__OriginalAmount__c, OSM_Child_Account__r.Customer_BMS_number__c, 
	                                            OSM_Child_Account__r.OSM_Location_ID__c,
                                                OSM_Child_Account__r.EBU_Channel_of_Distribution__c,
	                                            ccrz__CCOrder__r.BMS_OrderRefNumber__c,
                                               ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c,
                                                ccrz__SoldTo__r.OSM_Location_ID__c,
                                                ccrz__SoldTo__r.CSS_DBCode__c,
                                                ccrz__CCOrder__r.OSM_BMS_Customer_Number__c,                                         
	                                            ccrz__CCOrder__r.BMS_Order_reference_number_Refund__c,
	                                            ccrz__CCOrder__r.BMS_BranchLocation__c,
	                                            ccrz__CCOrder__r.Order_Source_Type__c,
	                                            ccrz__CCOrder__r.OSM_SW_Refund_Order_Source_Type__c,
	                                            BMS_PONumber__c, BMS_InvoiceNumber__c,
	                                            ICInvoice_Number__c, ICInvoice_Date__c
	                                       FROM ccrz__E_Invoice__c
	                                       WHERE Id =: ccInvoices.Id];
	    
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, false,'12345');
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, false,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(null, null, true, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, false,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, true,'12345');
	    
	    Test.stopTest();
	}
    private static testMethod void intercompany_BusinessLayerHandler_Test1() {
	    
        Account objAccount = new Account(Name = 'Test Account',
                                         BMS_Customer_ID__c  = '12345',
                                         CSS_DistributorCode__c  = '12345',
                                         //EBU_Channel_of_Distribution__c = 'CIHR',
                                         //PSBU_Channel_of_Distribution__c = 'CIHR',
                                         OSM_SW_Responsible_Region__c = 'test',
                                         BMS_Customer_ID_Junction__c = '12345');
        insert objAccount;
        
        ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true,
                                                      Order_Source_Type__c = 'OSM',
                                                      BMS_OrderRefNumber__c = 12345,
                                                      BMS_BranchLocation__c = 'test',
                                                      OSM_SW_Refund_Order_Source_Type__c = 'OSM',
                                                      BMS_Order_reference_number_Refund__c = 12345);
        insert order;
            
        ccrz__E_Product__c prod = TestingUtils.insertProduct();
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        orderList.add(order);
        
        List<ccrz__E_OrderItem__c> orderItems = TestingUtils.insertOrderItemList(orderList, prod);
        
        ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
        ccInvoices.ccrz__CCOrder__c = order.id;
        // ccInvoices.ccrz__Contact__c = contact1.id;
        ccInvoices.ccrz__CurrencyCode__c = 'USD';
        ccInvoices.ccrz__Status__c = 'Open';
        ccInvoices.ccrz__Storefront__c = 'Software';
        ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
        ccInvoices.ccrz__OriginalAmount__c = 200;
        ccInvoices.ccrz__Terms__c = 'TestDataTerms';
        ccInvoices.BMS_PONumber__c='123456';
        ccInvoices.BMS_InvoiceNumber__c=123456;
        ccInvoices.OSM_Child_Account__c = objAccount.Id;
        //ccInvoices.ccrz__SoldTo__c = objAccount.Id;
        insert ccInvoices;

        List<ccrz__E_Invoice__c> invList = new List<ccrz__E_Invoice__c>();
        invList.add(ccInvoices);
        List<ccrz__E_InvoiceItem__c> invItemlist = TestingUtils.insertInvoiceItemList( invList, order.id, orderItems[0].Id );
	    
	    Test.startTest();
		OSM_ReturnWrapper osmReturnWrp = new OSM_ReturnWrapper();
        osmReturnWrp.exceptionMessage ='testing';
	    
	    ccrz__E_Invoice__c objInvoice = [SELECT Id,ccrz__OriginalAmount__c, OSM_Child_Account__r.Customer_BMS_number__c, 
	                                            OSM_Child_Account__r.OSM_Location_ID__c,
                                                OSM_Child_Account__r.EBU_Channel_of_Distribution__c,
	                                            ccrz__CCOrder__r.BMS_OrderRefNumber__c,
                                               ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c,
                                                ccrz__SoldTo__r.OSM_Location_ID__c,
                                                ccrz__SoldTo__r.CSS_DBCode__c,
                                                ccrz__CCOrder__r.OSM_BMS_Customer_Number__c,                                         
	                                            ccrz__CCOrder__r.BMS_Order_reference_number_Refund__c,
	                                            ccrz__CCOrder__r.BMS_BranchLocation__c,
	                                            ccrz__CCOrder__r.Order_Source_Type__c,
	                                            ccrz__CCOrder__r.OSM_SW_Refund_Order_Source_Type__c,
	                                            BMS_PONumber__c, BMS_InvoiceNumber__c,
	                                            ICInvoice_Number__c, ICInvoice_Date__c
	                                       FROM ccrz__E_Invoice__c
	                                       WHERE Id =: ccInvoices.Id];
	    
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, false,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, false,'12345');
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(null, null, true, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, false,'12345');
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, true,'12345');
	  
       	    
	    Test.stopTest();
	}
    
    private static testMethod void intercompany_BusinessLayerHandler_Test2() {
	    
        Account objAccount = new Account(Name = 'Test Account',
                                         BMS_Customer_ID__c  = '12345',
                                         CSS_DistributorCode__c  = '12345',
                                         OSM_SW_Responsible_Region__c = 'test',
                                         BMS_Customer_ID_Junction__c = '12345');
        insert objAccount;
        
        ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true,
                                                      Order_Source_Type__c = 'OSM',
                                                      BMS_OrderRefNumber__c = 12345,
                                                      BMS_BranchLocation__c = 'test',
                                                      OSM_SW_Refund_Order_Source_Type__c = 'OSM',
                                                      BMS_Order_reference_number_Refund__c = 12345);
        insert order;
            
       	ccrz__E_Product__c prod = TestingUtils.insertProduct();
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        orderList.add(order);
        
        List<ccrz__E_OrderItem__c> orderItems = TestingUtils.insertOrderItemList(orderList, prod);
        ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
        ccInvoices.ccrz__CCOrder__c = order.id;
        // ccInvoices.ccrz__Contact__c = contact1.id;
        ccInvoices.ccrz__CurrencyCode__c = 'USD';
        ccInvoices.ccrz__Status__c = 'Open';
        ccInvoices.ccrz__Storefront__c = 'Software';
        ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
        ccInvoices.ccrz__OriginalAmount__c = 200;
        ccInvoices.ccrz__Terms__c = 'TestDataTerms';
        ccInvoices.BMS_PONumber__c='123456';
        ccInvoices.BMS_InvoiceNumber__c=123456;
        ccInvoices.OSM_Child_Account__c = objAccount.Id;
        //ccInvoices.ccrz__SoldTo__r.OSM_Location_ID__c = 
        //ccInvoices.ccrz__SoldTo__c = objAccount.Id;
        insert ccInvoices;
	    

        List<ccrz__E_Invoice__c> invList = new List<ccrz__E_Invoice__c>();
        invList.add(ccInvoices);
        List<ccrz__E_InvoiceItem__c> invItemlist = TestingUtils.insertInvoiceItemList( invList, order.id, orderItems[0].Id );
	    Test.startTest();
	    
	    ccrz__E_Invoice__c objInvoice = [SELECT Id,Name,CreatedDate,ccrz__OriginalAmount__c, OSM_Child_Account__r.Customer_BMS_number__c, 
	                                            OSM_Child_Account__r.OSM_Location_ID__c,
                                                OSM_Child_Account__r.PSBU_Channel_of_Distribution__c,
                                                OSM_Child_Account__r.EBU_Channel_of_Distribution__c,
	                                            ccrz__CCOrder__r.BMS_OrderRefNumber__c,
                                               ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c,
                                                ccrz__SoldTo__r.OSM_Location_ID__c,
                                                ccrz__SoldTo__r.CSS_DBCode__c,
                                                ccrz__CCOrder__r.OSM_BMS_Customer_Number__c,                                         
	                                            ccrz__CCOrder__r.BMS_Order_reference_number_Refund__c,
	                                            ccrz__CCOrder__r.BMS_BranchLocation__c,
	                                            ccrz__CCOrder__r.Order_Source_Type__c,
	                                            ccrz__CCOrder__r.OSM_SW_Refund_Order_Source_Type__c,
	                                            BMS_PONumber__c, BMS_InvoiceNumber__c,
	                                            ICInvoice_Number__c, ICInvoice_Date__c
	                                       FROM ccrz__E_Invoice__c
	                                       WHERE Id =: ccInvoices.Id];
	    
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, false,'12345');
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, false,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(null, null, true, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, false,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, true,'12345');
	    
	    Test.stopTest();
	}
    
    private static testMethod void intercompany_BusinessLayerHandler_Test3() {
	    
        Account objAccount = new Account(Name = 'Test Account',
                                         BMS_Customer_ID__c  = '12345',
                                         CSS_DistributorCode__c  = '12345',
                                         CSS_DealerCode__c = 'Test',
                                         CSS_DBCode__c = 'Test',
                                         IAM_Service_Provider_Code__c = '01339',
                                         OSM_SW_Responsible_Region__c = 'test',
                                         BMS_Customer_ID_Junction__c = '12345');
        insert objAccount;
        
        ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true,
                                                      Order_Source_Type__c = 'OSM',
                                                      BMS_OrderRefNumber__c = 12345,
                                                      BMS_BranchLocation__c = 'test',
                                                      OSM_SW_Refund_Order_Source_Type__c = 'OSM',
                                                      BMS_Order_reference_number_Refund__c = 12345);
        insert order;
            
       	ccrz__E_Product__c prod = TestingUtils.insertProduct();
        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        orderList.add(order);
        
        List<ccrz__E_OrderItem__c> orderItems = TestingUtils.insertOrderItemList(orderList, prod);
        ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
        ccInvoices.ccrz__CCOrder__c = order.id;
        // ccInvoices.ccrz__Contact__c = contact1.id;
        ccInvoices.ccrz__CurrencyCode__c = 'USD';
        ccInvoices.ccrz__Status__c = 'Open';
        ccInvoices.ccrz__Storefront__c = 'Software';
        ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
        ccInvoices.ccrz__OriginalAmount__c = 200;
        ccInvoices.ccrz__Terms__c = 'TestDataTerms';
        ccInvoices.BMS_PONumber__c='123456';
        ccInvoices.BMS_InvoiceNumber__c=123456;
        ccInvoices.OSM_Child_Account__c = objAccount.Id;
        //ccInvoices.ccrz__SoldTo__r.OSM_Location_ID__c =  
        ccInvoices.ccrz__SoldTo__c = objAccount.Id;
        insert ccInvoices;
	    

        List<ccrz__E_Invoice__c> invList = new List<ccrz__E_Invoice__c>();
        invList.add(ccInvoices);
        List<ccrz__E_InvoiceItem__c> invItemlist = TestingUtils.insertInvoiceItemList( invList, order.id, orderItems[0].Id );
	    Test.startTest();
	    
	    ccrz__E_Invoice__c objInvoice = [SELECT Id,Name,CreatedDate,ccrz__OriginalAmount__c, OSM_Child_Account__r.Customer_BMS_number__c, 
	                                            OSM_Child_Account__r.OSM_Location_ID__c,
                                                OSM_Child_Account__r.PSBU_Channel_of_Distribution__c,
                                                OSM_Child_Account__r.EBU_Channel_of_Distribution__c,
	                                            ccrz__CCOrder__r.BMS_OrderRefNumber__c,
                                               ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c,
                                                ccrz__SoldTo__r.OSM_Location_ID__c,
                                                ccrz__SoldTo__r.Location__c,
                                                ccrz__SoldTo__r.CSS_DBCode__c,
                                                ccrz__CCOrder__r.OSM_BMS_Customer_Number__c,                                         
	                                            ccrz__CCOrder__r.BMS_Order_reference_number_Refund__c,
	                                            ccrz__CCOrder__r.BMS_BranchLocation__c,
	                                            ccrz__CCOrder__r.Order_Source_Type__c,
	                                            ccrz__CCOrder__r.OSM_SW_Refund_Order_Source_Type__c,
	                                            BMS_PONumber__c, BMS_InvoiceNumber__c,
	                                            ICInvoice_Number__c, ICInvoice_Date__c
	                                       FROM ccrz__E_Invoice__c
	                                       WHERE Id =: ccInvoices.Id];
	    
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, false,'12345');
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, false,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(null, null, true, true,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false, false,null);
      OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true, true,'12345');
	  
	    	    Test.stopTest();
	}


}