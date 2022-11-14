//This is the test class for OSM_SW_CreateOrderRequestDataSetup        
//Changes added as part of MP-139, to add requesterId
//in JSON request when CreateOrder service is triggered
// updated by sharad
//Changes added as part ofMP-141, to get correct duration of subscription. Class modified to increase coverage
//Changes added as part of MP-402
//updated on 6th Jan for MP-494 by Sangeeta
//updated Ashish G            26/03/2022     Test Class Coverage
//Changed
@isTest 
public class OSM_SW_CreateOrderRequestDataSetup_Test 
{
    public static Account createTestAccount()
    {  
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
        insert testAccount;
        return testAccount;
    }
    //Verify Productid
    public static ID getProductID(String productType)
    {
        
        ccrz__E_Product__c product = null;
        
        if('Bundle' == productType)
        {
            product = [Select ID from ccrz__E_Product__c where ccrz__ProductType__c = 'Bundle' Limit 1];
        }
        if('Add-On' == productType)
        {
            product = [Select ID from ccrz__E_Product__c where Name like '%Service Tech Kit%' Limit 1];
        }
        if('Insite' == productType)
        {
            product = [Select ID from ccrz__E_Product__c where Name like '%Insite%' Limit 1];
        }
        if('Zap-It' == productType)
        {
            product = [Select ID from ccrz__E_Product__c where Name like '%Zap-It%' Limit 1];
        }
        
        return product.ID;
        
        //}
        //return null;
        
    }
    
    
    static testMethod void createOrderOMS_BundleProduct3()
    {
        /* try
{*/
        // Creating the Products records data
        set<string> prodid = new set<string>();
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Service Tech Kit';
        prod.ccrz__SKU__c = '15458771';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        prod.ccrz__ProductType__c = 'Add-On';
        insert prod;
        ccrz__E_Product__c prod1 = new ccrz__E_Product__c();
        prod1.name = 'Service Tech Kit';
        prod1.ccrz__SKU__c = '15458772';
        prod1.ccrz__Quantityperunit__c = 3343;
        prod1.ccrz__StartDate__c = system.today();
        prod1.ccrz__EndDate__c = system.today()+1;
        prod1.ccrz__ShortDesc__c = 'testing';
        prod1.ccrz__ProductType__c = 'Bundle';
        insert prod1;
        
        ccrz__E_Product__c prod2 = new ccrz__E_Product__c();
        prod2.name = 'Insite';
        prod2.ccrz__SKU__c = 'INS-Pro-P-02300';
        prod2.ccrz__Quantityperunit__c = 3343;
        prod2.ccrz__StartDate__c = system.today();
        prod2.ccrz__EndDate__c = system.today()+1;
        prod2.ccrz__ShortDesc__c = 'testing';
        prod2.ccrz__ProductType__c = 'Insite';
        prod2.LicenseName__c='MR-HD Automotive Basic';
        insert prod2;
        
        ccrz__E_Product__c prod3 = new ccrz__E_Product__c();
        prod3.name = 'Zap-It';
        prod3.ccrz__SKU__c = 'FLTCNT-12345';
        prod3.ccrz__Quantityperunit__c = 3343;
        prod3.ccrz__StartDate__c = system.today();
        prod3.ccrz__EndDate__c = system.today()+1;
        prod3.ccrz__ShortDesc__c = 'testing';
        prod3.ccrz__ProductType__c = 'Zap-It';
        insert prod3;
        List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
        
        Account acc = createTestAccount();
        //create Test Contact
        Contact testCon = new Contact();        	
        testCon.LastName = 'Cont';
        testCon.FirstName = 'Test';
        testCon.Username__c = 'agt145@gtest.com'; //added Subbu
        insert testCon;
        
        // create an order
        ccrz__E_Order__c order = new ccrz__E_Order__c();
        order.ccrz__Account__c = acc.ID;
        order.OSM_SW_Should_mail_Send__c = true;
        order.OSM_SW_Is_InterCompany_Order__c = false;
        order.ccrz__OrderStatus__c='Order Submitted';            
        order.ccrz__Contact__c = testCon.Id;
        insert order;
        
        // create an order item - with Bundle
        ccrz__E_OrderItem__c bundleOrderItem = new ccrz__E_OrderItem__c();
        bundleOrderItem.ccrz__Order__c = order.ID;
        bundleOrderItem.ccrz__Quantity__c = 1;
        bundleOrderItem.ccrz__Product__c = getProductID('Bundle');
        bundleOrderItem.ccrz__DisplayProduct__c = getProductID('Bundle');
        bundleOrderItem.Number_of_Bundles__c = 0;
        bundleOrderItem.Number_of_Counts__c = 0;
        bundleOrderItem.ccrz__Price__c = 15.00;
        bundleOrderItem.ccrz__SubAmount__c = 15.00;
        orderItemList.add(bundleOrderItem);
        
        // create an order Item - with Add-On
        ccrz__E_OrderItem__c addOnOrderItem = new ccrz__E_OrderItem__c();
        addOnOrderItem.ccrz__Order__c = order.ID;
        addOnOrderItem.ccrz__Quantity__c = 2;
        addOnOrderItem.ccrz__Product__c = getProductID('Add-On');
        addOnOrderItem.ccrz__DisplayProduct__c = getProductID('Bundle');
        addOnOrderItem.Number_of_Bundles__c = 0;
        addOnOrderItem.Number_of_Counts__c = 0;
        addOnOrderItem.ccrz__Price__c = 15.00;
        addOnOrderItem.ccrz__SubAmount__c = 15.00;
        orderItemList.add(addOnOrderItem);
        
        // create an order Item with Zap-It
        ccrz__E_OrderItem__c nonSubscOrderItem = new ccrz__E_OrderItem__c();
        nonSubscOrderItem.ccrz__Order__c = order.ID;
        nonSubscOrderItem.ccrz__Quantity__c = 1;
        nonSubscOrderItem.ccrz__Product__c = prod3.id;
        nonSubscOrderItem.ccrz__DisplayProduct__c = prod3.id;
        nonSubscOrderItem.Number_of_Bundles__c = 5;
        nonSubscOrderItem.Number_of_Counts__c = 2;
        nonSubscOrderItem.ccrz__Price__c = 15.00;
        nonSubscOrderItem.ccrz__SubAmount__c = 15.00;
        orderItemList.add(nonSubscOrderItem);
        
        
        ccrz__E_SubProdTerm__c spt = new ccrz__E_SubProdTerm__c();
        spt.ccrz__DisplayName__c = '1 Year';
        spt.ccrz__CCProduct__c = prod2.Id;
        spt.ccrz__EffectiveEnd__c = system.today()+1;
        spt.ccrz__EffectiveStart__c = system.today();
        insert spt;      
        
        // create an order Item with Zap-It
        ccrz__E_OrderItem__c subscOrderItem = new ccrz__E_OrderItem__c();
        subscOrderItem.ccrz__Order__c = order.ID;
        subscOrderItem.ccrz__Quantity__c = 1;
        subscOrderItem.ccrz__Product__c =  prod2.id;
        subscOrderItem.ccrz__DisplayProduct__c = prod2.id;
        subscOrderItem.Number_of_Bundles__c = 5;
        subscOrderItem.Number_of_Counts__c = 2;
        subscOrderItem.ccrz__Price__c = 15.00;
        subscOrderItem.ccrz__SubAmount__c = 15.00;
        subscOrderItem.ccrz__SubProdTerm__c = spt.Id;
        orderItemList.add(subscOrderItem);
        
        insert orderItemList;
        
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new OMS_OMS_CreateAndGetOrder_Mock());
        OMS_OMS_CreateAndGetOrder_Mock osmoc = new OMS_OMS_CreateAndGetOrder_Mock();
        //Requ
        httpRequest res = new httpRequest();
        osmoc.respond(res);
        // OMS_OMS_CreateAndGetOrder_Mock.
        Set<ID> s1 = new Set<ID>();
        s1.add(order.ID);
        OSM_SW_OrderActions.call_OMS_GetAndCreateOrder(s1,null,null,false);
        Test.stopTest();         
        
        OSM_OMS_WS_CreateOrderRes newObj = new OSM_OMS_WS_CreateOrderRes();
        // newObj.Header = '';
        OSM_OMS_WS_CreateOrderRes.Sender newObj2 = new OSM_OMS_WS_CreateOrderRes.Sender();
        newObj2.ServiceName = '';
        newObj2.SenderID = '';
        OSM_OMS_WS_CreateOrderRes.Target newObj3 = new OSM_OMS_WS_CreateOrderRes.Target();
        newObj3.TargetID='';
        OSM_OMS_WS_CreateOrderRes.Header newObj4 = new OSM_OMS_WS_CreateOrderRes.Header();
        newObj4.Sender = newObj2;
        newObj4.Target = newObj3;
        //   newObj4.
        OSM_OMS_WS_CreateOrderRes.Error newObj5 = new OSM_OMS_WS_CreateOrderRes.Error();
        
        newObj5.ErrorCode = '';
        newObj5.ErrorDescription = '';
        OSM_OMS_WS_CreateOrderRes.CreateOrderOutput newObj6 = new OSM_OMS_WS_CreateOrderRes.CreateOrderOutput();
        newObj6.OMSOrderID = 0;
        String str = '';
        newObj.Header = newObj4;
        newObj.CreateOrderOutput = newObj6;
        newObj.Error = newObj5;
        // OSM_OMS_WS_CreateOrderRes.parse(str);
        OSM_OMS_CreateOrderGeneral_IP_Wrapper ipwrapper1=new OSM_OMS_CreateOrderGeneral_IP_Wrapper();
        OSM_OMS_CreateOrderGeneral_IP_Wrapper ipwrapper2=new OSM_OMS_CreateOrderGeneral_IP_Wrapper();
        
        ipwrapper1.orderId = order.ID;
        ipwrapper1.orderName = order.Name;
        ipwrapper1.timestamp = OSM_SW_OrderActions.getRequiredDateFormat(System.today(), 'yyyy-MM-dd');
        ipwrapper1.toolName = 'INSITE';    // static value...will not change
        ipwrapper1.requesterId='1234';
        ipwrapper1.orderItemDetailsList = new List<OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails>();
        ipwrapper2.orderId = order.ID;
        ipwrapper2.orderName = order.Name;
        ipwrapper2.timestamp = OSM_SW_OrderActions.getRequiredDateFormat(System.today(), 'yyyy-MM-dd');
        ipwrapper2.toolName = 'INSITE';    // static value...will not change
        ipwrapper2.requesterId='1234';
        ipwrapper2.orderItemDetailsList = new List<OSM_OMS_CreateOrderGeneral_IP_Wrapper.OrderItemDetails>();
        OSM_Order_Item_License__c itemLic=new OSM_Order_Item_License__c();
        ccrz__E_OrderItem__c ord = [select id, name,isRenew__c,OSM_SW_Is_without_Coterm__c, ccrz__Order__c,ccrz__Quantity__c,ccrz__DisplayProduct__r.ccrz__SKU__c,Number_of_Bundles__c,Number_of_Counts__c,ccrz__Price__c,ccrz__SubAmount__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c from ccrz__E_OrderItem__c where id = :nonSubscOrderItem.id];
        ccrz__E_OrderItem__c ord1 = [select id, name,isRenew__c,OSM_SW_Is_without_Coterm__c, ccrz__Order__c,ccrz__Quantity__c,ccrz__DisplayProduct__r.ccrz__SKU__c,Number_of_Bundles__c,Number_of_Counts__c,ccrz__Price__c,ccrz__SubAmount__c,ccrz__SubProdTerm__r.ccrz__DisplayName__c from ccrz__E_OrderItem__c where id = :SubscOrderItem.id];
        OSM_SW_CreateOrderRequestDataSetup.reqDataSetupNonInsite(prod3,order,ord,1,ipwrapper1);
        OSM_SW_CreateOrderRequestDataSetup.reqDataSetupNonInsite(prod3,order,ord1,1,ipwrapper1);
        OSM_SW_CreateOrderRequestDataSetup.reqDataSetupInsite(prod2,order,ord1,1,ipwrapper2,itemLic);
        OSM_SW_CreateOrderRequestDataSetup.reqDataSetupInsite(prod2,order,ord,1,ipwrapper2,itemLic);
        /*prod2.LicenseName__c='MR-HD Plus Basic';
update prod2;
OSM_SW_CreateOrderRequestDataSetup.reqDataSetupInsite(prod2,order,subscOrderItem,1,ipwrapper2,itemLic);
prod2.LicenseName__c='MR-HD Automotive Basic';
update prod2;
OSM_SW_CreateOrderRequestDataSetup.reqDataSetupInsite(prod2,order,subscOrderItem,1,ipwrapper2,itemLic);
prod2.LicenseName__c='Service Plus Basic';
update prod2;
OSM_SW_CreateOrderRequestDataSetup.reqDataSetupInsite(prod2,order,subscOrderItem,1,ipwrapper2,itemLic);*/
        
    }
}