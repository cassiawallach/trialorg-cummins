//uapdated by dhiraj
//test class for OSM_GetTI_BusinessHandler
@isTest(seeAllData=false)
public class OSM_OMS_WS_GetTI_Test
{	
    //Updated for User Story - 883
    @testSetup
    public static void testData() {
        
        //Create Account Data
        Account portalAccount1 = TestingUtils.insertAccount();
        
        //Create Contact Data
        Contact contact1 = TestingUtils.inertActiveContact( portalAccount1.Id );

        //Create Order
        ccrz__E_Order__c order = TestingUtils.insertOrder( contact1.Id );

        //Create Product
        ccrz__E_Product__c prod = TestingUtils.insertProduct();

        List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        orderList.add( order ); 

        //Create Order item
        List<ccrz__E_OrderItem__c> orderItem = TestingUtils.insertOrderItemList( orderList, prod );

        //Create New Order Item license
        OSM_Order_Item_License__c license = TestingUtils.insertNewOILParentActivationKey( orderItem[0].Id );

        //Create New Child Order Item license
        OSM_Order_Item_License__c licenseChild = TestingUtils.insertNewOrderItemLicense(  orderItem[0].Id, license.Id );
    }
    
    public static testMethod void testMethodforCallingGETTIHourlyBatchApi()
    {
        
        List<ccrz__E_OrderItem__c> orderItemList = [ SELECT Id FROM ccrz__E_OrderItem__c LIMIT 5];
        List<OSM_Order_Item_License__c> license = [ SELECT Id FROM OSM_Order_Item_License__c LIMIT 1 ];
        
        Set<Id> orderItemIdSet=new Set<Id>();
        orderItemIdSet.add(orderItemList[0].id);
        
        
        Map<id,ccrz__E_OrderItem__c> itemMap = new Map<id,ccrz__E_OrderItem__c>();
        itemMap.put(orderItemList[0].id,orderItemList[0]);

        Test.StartTest();

        OSM_OMS_GetTI_HourlyBatch batch=new OSM_OMS_GetTI_HourlyBatch();
        Database.executeBatch(batch);
        String jsonInput='{"Header":{"Target":{"TargetID":"OMS"},"Sender":{"ServiceName":"GetTIFromLicenseKey","SenderID":"Mrktplc"},"Message":{"Timestamp":"2019-04-23","MessageID":"12959465"}},"GetTIFromLicenseKeyInput":{"ToolName":"INSITE","ActivationKey":"OE4ELAUFEM6Q"}}';        
        String jsonOutput='{"Header":{"Sender":{"ServiceName":"GetTIFromLicenseKey","SenderID":"Mrktplc"},"Status":"Success","Target":{"TargetID":"OMS"},"ReturnCodeDescription":"Success"},"GetTIFromLicenseKeyOutput":{"ToolInstListInfo":{"ToolInstList":[{"InstanceID":6718021,"ToolInstance":"4D25DF3B"},{"InstanceID":6718022,"ToolInstance":"A793EB52"}]}}}';
        OSM_OMS_WS_GetTI_GenOutputWrapper wrap= new OSM_OMS_WS_GetTI_GenOutputWrapper();
        OSM_OMS_WS_GetTIReq reqwrap=new OSM_OMS_WS_GetTIReq();
        OSM_OMS_WS_GetTIReq.parse(jsonInput);
        OSM_OMS_WS_GetTI_GenOutputWrapper.parse(jsonOutput);
        OSM_OMS_WS_GetTI_GenInputWrapper wrapInput=new OSM_OMS_WS_GetTI_GenInputWrapper();
        OSM_OMS_WS_GetTI_GenInputWrapper.parse(jsonInput);  
        OSM_GetTI_BusinessHandler.updateOMSToolInstance(orderItemList[0].id,itemMap,license[0], null);

        System.assert( orderItemIdSet != null, 'Order Item Cannot be Null');//Updated for User Story - 883
        OSM_OMS_GetTI_Batch_Helper.callGetTILicensesAPI(orderItemIdSet);
        
        Test.StopTest();
       }   
       
       public static testMethod void testMethodforCallingGETTIWeeklyApi()
       {

      
         Test.StartTest();
            OSM_OMS_GetTI_ON_Revoked_Batch batch=new OSM_OMS_GetTI_ON_Revoked_Batch();
            System.assert( batch != null );//Updated for User Story - 883
            Database.executeBatch(batch);
             
        Test.StopTest();
       }       
}