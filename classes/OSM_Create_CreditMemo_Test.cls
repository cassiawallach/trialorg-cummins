@isTest
// updated Sharad 2-Aug 21
// updated Sharad 13-Aug 21
// updated Sangeeta 27-Aug 21
// updated Sangeeta 31-Aug 21 
// updated Sharad 16-Sept 21 
// updated Sharad 23-Sept 21 
public class OSM_Create_CreditMemo_Test {

        static testMethod void testMethodForInvoice() {

        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';


        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        System.debug('transecRes: -- ' + transecRes);
        List<ccrz__E_OrderItem__c> orderItemList=new List<ccrz__E_OrderItem__c>();
        ccrz__E_Order__c order1=transecRes.order;
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        //pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = order1.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        oi1.Vertex_Tax__c=11;
        insert oi1;
        orderItemList.add(oi1);
            try {
                    
                List<Id> ss = new List<Id>();
                ss.add(transecRes.invoice.Id);
                OSM_Create_CreditMemo.createCreditMemo(ss,Null);
                OSM_Create_CreditMemo.createCreditMemo(ss,orderItemList);
            } catch (Exception ex) {}
        
    }

}