//Test Class for the class OSM_CancelLicenses_Service***
//Updated Dhiraj
//Updated by Pooja 8/5/2022 story 1054
@isTest
private class OSM_CancelLicenses_Test {

  private static testMethod void cancelLicenses_BusinessHandler_Test() {
      
      ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true);
        insert order;
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c       = order.id;
        orderItem.ccrz__Price__c       = 500;
        orderItem.ccrz__Quantity__c    = 55;
        orderItem.ccrz__SubAmount__c   = 250;
        insert orderItem;
        
        OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
        ParentActivationKey.Activation_Key__c         = 'testActivationKey';
        ParentActivationKey.CC_Order_Item__c          = orderItem.id;
        ParentActivationKey.Parent_Activation_Key__c  = null;
        ParentActivationKey.OMS_Item_Id__c            = '1234';
        ParentActivationKey.Tool_Instance_Key__c      = '12345';
        ParentActivationKey.Status__c                 = 'Revoke Intitiated';
        ParentActivationKey.type__c                   = 'Tool instance';
        insert ParentActivationKey;
        
        OSM_Order_Item_License__c orderItemLicense = new OSM_Order_Item_License__c();
        orderItemLicense.Activation_Key__c         = 'testActivationKey';
        orderItemLicense.CC_Order_Item__c          = orderItem.id;
        orderItemLicense.Parent_Activation_Key__c  = ParentActivationKey.id;
        orderItemLicense.OMS_Item_Id__c            = '1234';
        orderItemLicense.Tool_Instance_Key__c      = '12345';
        orderItemLicense.Status__c                 = 'New';
        orderItemLicense.type__c                   = 'Tool instance';
        insert orderItemLicense;
        
        Test.startTest();
        
        OSM_CancelLicenses_BusinessHandler.getOrderItemInfo(orderItemLicense.Id, null, new Map<Id,OSM_Order_Item_License__c>{orderItemLicense.Id =>orderItemLicense, ParentActivationKey.Id => ParentActivationKey},orderItem,true);
        OSM_CancelLicenses_BusinessHandler.getOrderItemInfo(orderItemLicense.Id, '12345', new Map<Id,OSM_Order_Item_License__c>{orderItemLicense.Id =>orderItemLicense, ParentActivationKey.Id => ParentActivationKey},orderItem,false);
        OSM_CancelLicensesRetryIntBatch obj = new OSM_CancelLicensesRetryIntBatch();
       // OSM_SW_SubscriptionRenewToActiveBatch obj = new OSM_SW_SubscriptionRenewToActiveBatch();
        DataBase.executeBatch(obj); 
        
        Test.stopTest();
  }
  
  /*private static testMethod void cancelLicenses_Helper_Test() {
      
      OSM_CancelLicensesREQ_GeneralizedWrapper inputWrapperObj = new OSM_CancelLicensesREQ_GeneralizedWrapper();
      OSM_CancelLicensesREQ_GeneralizedWrapper.CancelLicensesInput objCI = new OSM_CancelLicensesREQ_GeneralizedWrapper.CancelLicensesInput();
      objCI.TotalCopies = 5;
      objCI.ItemId = '12345';
      objCI.ToolName = 'Test';
      objCI.RequesterId = '12345';
      inputWrapperObj.CancelLicensesInput = objCI;
      
      Test.startTest();
      
      OSM_CancelLicenses_Helper.populateRequestObjectData(inputWrapperObj);
      
      Test.stopTest();
  }*/
  
    private static testMethod void cancelLicenses_Service_Test() {
      
      OSM_CancelLicensesREQ_GeneralizedWrapper inputWrapperObj = new OSM_CancelLicensesREQ_GeneralizedWrapper();
      OSM_CancelLicensesREQ_GeneralizedWrapper.CancelLicensesInput objCI = new OSM_CancelLicensesREQ_GeneralizedWrapper.CancelLicensesInput();
      objCI.TotalCopies = 5;
      objCI.ItemId = '12345';
      objCI.ToolName = 'Test';
      objCI.RequesterId = '12345';
      inputWrapperObj.CancelLicensesInput = objCI;
      
      Test.startTest();
      
      OSM_CancelLicenses_Service.callCancelLicensesService(inputWrapperObj);
      
      Test.stopTest();
  }
  
  private static testMethod void cancelLicenses_ServiceHandler_Test() {
      
      ccrz__E_Product__c objProduct = new ccrz__E_Product__c(ccrz__SKU__c = '15458776',
                                                             Name = 'Connected Advisor',
                                                             ccrz__ShortDesc__c = 'testing',
                                                             ccrz__Quantityperunit__c = 3343,
                                                             ccrz__StartDate__c = system.today(),
                                                             ccrz__EndDate__c = system.today()+1);
        insert objProduct;
        
        ccrz__E_Product__c objProduct2 = new ccrz__E_Product__c(Name = 'Test',
                                                             ccrz__SKU__c = '15458777',
                                                             ccrz__ShortDesc__c = 'testing',
                                                             ccrz__Quantityperunit__c = 3343,
                                                             ccrz__StartDate__c = system.today(),
                                                             ccrz__EndDate__c = system.today()+1);
        insert objProduct2;
        
      ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true);
        insert order;
        
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Price__c = 500;
        orderItem.ccrz__Quantity__c = 55;
        orderItem.ccrz__SubAmount__c = 250;
        orderItem.Number_of_Bundles__c = 20;
        orderItem.ccrz__Order__c = order.id;
        orderItem.OSM_GetTI_Success__c = true;
        orderItem.ccrz__OriginalQuantity__c = 20;
        orderItem.ccrz__Product__c = objProduct.Id;
        insert orderItem;
        
        ccrz__E_OrderItem__c orderItem2 = new ccrz__E_OrderItem__c();
        orderItem2.ccrz__Price__c = 500;
        orderItem2.ccrz__Quantity__c = 55;
        orderItem2.ccrz__SubAmount__c = 250;
        orderItem2.Number_of_Bundles__c = 20;
        orderItem2.ccrz__Order__c = order.id;
        orderItem2.OSM_GetTI_Success__c = true;
        orderItem2.ccrz__OriginalQuantity__c = 20;
        orderItem2.ccrz__Product__c = objProduct2.Id;
        insert orderItem2;
        
        OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
        ParentActivationKey.OMS_Item_Id__c = '1234';
        ParentActivationKey.type__c = 'Tool instance';
        ParentActivationKey.Tool_Instance_Key__c = '12345';
        ParentActivationKey.CC_Order_Item__c = orderItem.id;
        ParentActivationKey.Parent_Activation_Key__c = null;
        ParentActivationKey.Status__c = 'Revoke Intitiated';
        ParentActivationKey.Activation_Key__c = 'testActivationKey';
        insert ParentActivationKey;
        
        OSM_Order_Item_License__c orderItemLicense = new OSM_Order_Item_License__c();
        orderItemLicense.Status__c = 'New';
        orderItemLicense.OMS_Item_Id__c = '1234';
        orderItemLicense.type__c = 'Tool instance';
        orderItemLicense.Tool_Instance_Key__c = '12345';
        orderItemLicense.CC_Order_Item__c = orderItem.id;
        orderItemLicense.Activation_Key__c = 'testActivationKey';
        orderItemLicense.Parent_Activation_Key__c = ParentActivationKey.id;
        orderItemLicense.Revoked_ReIssue_Lisence__c = ParentActivationKey.id;
        insert orderItemLicense;
        
        OSM_Order_Item_License__c orderItemLicense1 = new OSM_Order_Item_License__c();
        orderItemLicense1.Status__c = 'New';
        orderItemLicense1.OMS_Item_Id__c = '1234';
        orderItemLicense1.type__c = 'Tool instance';
        orderItemLicense1.Tool_Instance_Key__c = '12345';
        orderItemLicense1.CC_Order_Item__c = orderItem.id;
        orderItemLicense1.Activation_Key__c = 'testActivationKey';
        orderItemLicense1.Parent_Activation_Key__c = ParentActivationKey.id;
        //orderItemLicense1.Revoked_ReIssue_Lisence__c = ParentActivationKey.id;
        insert orderItemLicense1;
        
        OSM_Order_Item_License__c ParentActivationKey2 = new OSM_Order_Item_License__c();
        ParentActivationKey2.OMS_Item_Id__c = '1234';
        ParentActivationKey2.type__c = 'Tool instance';
        ParentActivationKey2.Tool_Instance_Key__c = '12345';
        ParentActivationKey2.Parent_Activation_Key__c = null;
        ParentActivationKey2.Status__c = 'Revoke Intitiated';
        ParentActivationKey2.CC_Order_Item__c = orderItem2.id;
        ParentActivationKey2.Activation_Key__c = 'testActivationKey2';
        insert ParentActivationKey2;
        
        OSM_Order_Item_License__c orderItemLicense2 = new OSM_Order_Item_License__c();
        orderItemLicense2.Status__c = 'New';
        orderItemLicense2.OMS_Item_Id__c = '1234';
        orderItemLicense2.type__c = 'Tool instance';
        orderItemLicense2.Tool_Instance_Key__c = '12345';
        orderItemLicense2.CC_Order_Item__c = orderItem2.id;
        orderItemLicense2.Activation_Key__c = 'testActivationKey02';
        orderItemLicense2.Parent_Activation_Key__c = ParentActivationKey2.id;
        orderItemLicense2.Revoked_ReIssue_Lisence__c= ParentActivationKey2.id;
        insert orderItemLicense2;
        
        OSM_Order_Item_License__c orderItemLicense3 = new OSM_Order_Item_License__c();
        orderItemLicense3.Status__c = 'New';
        orderItemLicense3.OMS_Item_Id__c = '1234';
        orderItemLicense3.type__c = 'Tool instance';
        orderItemLicense3.Tool_Instance_Key__c = '12345';
        orderItemLicense3.CC_Order_Item__c = orderItem2.id;
        orderItemLicense3.Activation_Key__c = 'testActivationKey02';
        orderItemLicense3.Parent_Activation_Key__c = ParentActivationKey2.id;
        orderItemLicense3.Revoked_ReIssue_Lisence__c= ParentActivationKey2.id;
        insert orderItemLicense3;
        
        Test.startTest();
        
        OSM_CancelLicenses_ServiceHandler.callCancelLicensesAPI(new Set<Id> {orderItem.Id, orderItem2.Id});
        
        objProduct.Name = 'Service Tech Kit 1';
        update objProduct;
        
        objProduct2.Name = 'Service Tech Kit 1';
        update objProduct2;
        
        //OSM_CancelLicenses_ServiceHandler.callCancelLicensesAPI(new Set<Id> {orderItem.Id, orderItem2.Id});
        
        Test.stopTest();
  }
  private static testMethod void cancelLicenses_ServiceHandler2_Test() {
      
      ccrz__E_Product__c objProduct = new ccrz__E_Product__c(ccrz__SKU__c = '15458776',
                                                             Name = 'Service Tech Kit 1',
                                                             ccrz__ShortDesc__c = 'testing',
                                                             ccrz__Quantityperunit__c = 3343,
                                                             ccrz__StartDate__c = system.today(),
                                                             ccrz__EndDate__c = system.today()+1);
        insert objProduct;
        
        ccrz__E_Product__c objProduct2 = new ccrz__E_Product__c(Name = 'Service Tech Kit 1',
                                                             ccrz__SKU__c = '15458777',
                                                             ccrz__ShortDesc__c = 'testing',
                                                             ccrz__Quantityperunit__c = 3343,
                                                             ccrz__StartDate__c = system.today(),
                                                             ccrz__EndDate__c = system.today()+1);
        insert objProduct2;
        
      ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true);
        insert order;
        
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Price__c = 500;
        orderItem.ccrz__Quantity__c = 55;
        orderItem.ccrz__SubAmount__c = 250;
        orderItem.Number_of_Bundles__c = 20;
        orderItem.ccrz__Order__c = order.id;
        orderItem.OSM_GetTI_Success__c = true;
        orderItem.ccrz__OriginalQuantity__c = 20;
        orderItem.ccrz__Product__c = objProduct.Id;
        insert orderItem;
        
        ccrz__E_OrderItem__c orderItem2 = new ccrz__E_OrderItem__c();
        orderItem2.ccrz__Price__c = 500;
        orderItem2.ccrz__Quantity__c = 55;
        orderItem2.ccrz__SubAmount__c = 250;
        orderItem2.Number_of_Bundles__c = 20;
        orderItem2.ccrz__Order__c = order.id;
        orderItem2.OSM_GetTI_Success__c = true;
        orderItem2.ccrz__OriginalQuantity__c = 20;
        orderItem2.ccrz__Product__c = objProduct2.Id;
        insert orderItem2;
        
        OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
        ParentActivationKey.OMS_Item_Id__c = '1234';
        ParentActivationKey.type__c = 'Tool instance';
        ParentActivationKey.Tool_Instance_Key__c = '12345';
        ParentActivationKey.CC_Order_Item__c = orderItem.id;
        ParentActivationKey.Parent_Activation_Key__c = null;
        ParentActivationKey.Status__c = 'Revoke Intitiated';
        ParentActivationKey.Activation_Key__c = 'testActivationKey';
        insert ParentActivationKey;
        
        OSM_Order_Item_License__c orderItemLicense = new OSM_Order_Item_License__c();
        orderItemLicense.Status__c = 'New';
        orderItemLicense.OMS_Item_Id__c = '1234';
        orderItemLicense.type__c = 'Tool instance';
        orderItemLicense.Tool_Instance_Key__c = '12345';
        orderItemLicense.CC_Order_Item__c = orderItem.id;
        orderItemLicense.Activation_Key__c = 'testActivationKey';
        orderItemLicense.Parent_Activation_Key__c = ParentActivationKey.id;
        orderItemLicense.Revoked_ReIssue_Lisence__c = ParentActivationKey.id;
        insert orderItemLicense;
        
        OSM_Order_Item_License__c orderItemLicense1 = new OSM_Order_Item_License__c();
        orderItemLicense1.Status__c = 'New';
        orderItemLicense1.OMS_Item_Id__c = '1234';
        orderItemLicense1.type__c = 'Tool instance';
        orderItemLicense1.Tool_Instance_Key__c = '12345';
        orderItemLicense1.CC_Order_Item__c = orderItem.id;
        orderItemLicense1.Activation_Key__c = 'testActivationKey';
        //orderItemLicense1.Parent_Activation_Key__c = ParentActivationKey.id;
        //orderItemLicense1.Revoked_ReIssue_Lisence__c = ParentActivationKey.id;
        insert orderItemLicense1;
        
        OSM_Order_Item_License__c ParentActivationKey2 = new OSM_Order_Item_License__c();
        ParentActivationKey2.OMS_Item_Id__c = '1234';
        ParentActivationKey2.type__c = 'Tool instance';
        ParentActivationKey2.Tool_Instance_Key__c = '12345';
        ParentActivationKey2.Parent_Activation_Key__c = null;
        ParentActivationKey2.Status__c = 'Revoke Intitiated';
        ParentActivationKey2.CC_Order_Item__c = orderItem2.id;
        ParentActivationKey2.Activation_Key__c = 'testActivationKey2';
        insert ParentActivationKey2;
        
        OSM_Order_Item_License__c orderItemLicense2 = new OSM_Order_Item_License__c();
        orderItemLicense2.Status__c = 'New';
        orderItemLicense2.OMS_Item_Id__c = '1234';
        orderItemLicense2.type__c = 'Tool instance';
        orderItemLicense2.Tool_Instance_Key__c = '12345';
        orderItemLicense2.CC_Order_Item__c = orderItem2.id;
        orderItemLicense2.Activation_Key__c = 'testActivationKey02';
        orderItemLicense2.Parent_Activation_Key__c = ParentActivationKey2.id;
        orderItemLicense2.Revoked_ReIssue_Lisence__c= ParentActivationKey2.id;
        insert orderItemLicense2;
        
        OSM_Order_Item_License__c orderItemLicense3 = new OSM_Order_Item_License__c();
        orderItemLicense3.Status__c = 'New';
        orderItemLicense3.OMS_Item_Id__c = '1234';
        orderItemLicense3.type__c = 'Tool instance';
        orderItemLicense3.Tool_Instance_Key__c = '12345';
        orderItemLicense3.CC_Order_Item__c = orderItem2.id;
        orderItemLicense3.Activation_Key__c = 'testActivationKey02';
        orderItemLicense3.Parent_Activation_Key__c = ParentActivationKey2.id;
        orderItemLicense3.Revoked_ReIssue_Lisence__c= ParentActivationKey2.id;
        insert orderItemLicense3;
        
        Test.startTest();
        
        OSM_CancelLicenses_ServiceHandler.callCancelLicensesAPI(new Set<Id> {orderItem.Id, orderItem2.Id});
        
        
        
        Test.stopTest();
  }
}