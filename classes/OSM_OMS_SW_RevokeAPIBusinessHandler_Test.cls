//This is the test class for OSM_OMS_SW_RevokeAPIUtility
//updated on 2nd Dec 20
// Updated Sharad
// Updated Sharad on 26?nov?21
//Update by sharad on 29/Nov/21
//test class update
//Updated by Pooja 8/5/2022 story 1054
@isTest
public class OSM_OMS_SW_RevokeAPIBusinessHandler_Test {
 Static TestMethod Void RevokeAPITestMethod(){
       ccrz__E_Order__c ord = new ccrz__E_Order__c(ByPassFlow__c = true);
       ord.ccrz__OrderNumber__c = 2323999;
       insert ord;
       
       
       List<ccrz__E_OrderItem__c >itemList = new list <ccrz__E_OrderItem__c >();
       ccrz__E_OrderItem__c orditem = new ccrz__E_OrderItem__c();
       orditem.ccrz__Order__c = ord.id;
       orditem.ccrz__Price__c = 10;
       orditem.ccrz__Quantity__c =1;
       orditem.ccrz__SubAmount__c = 5;
       //orditem.OMS_Revoke_API_failure__c = true;
       orditem.OMS_Instance_ID__c = '123455';
       //orditem.Contact__c = con[0].id;
       itemList.add(orditem);
       insert itemList;
       
       OSM_Order_Item_License__c orderItemLicense=new OSM_Order_Item_License__c();
       orderItemLicense.Activation_Key__c='1234';
       orderItemLicense.CC_Order_Item__c=orditem.id;
       orderItemLicense.OMS_Item_Id__c='1234';
       orderItemLicense.Tool_Instance_Id__c='1234';
       orderItemLicense.Status__c='New';
       insert orderItemLicense;
       
       Set<id> itemIdList=new Set<id>();
       itemIdList.add(orditem.id);
       Test.StartTest();
       //OSM_OMS_SW_RevokeAPIBusinessLayerHandler.getBMSAvailableCredit(itemList[0].OMS_Instance_ID__c );
       OSM_OMS_SW_RevokeAPIUtility.revokeAPIcall(itemIdList);
       OSM_OMS_SW_RevokeAPIUtility.revokeAPIcallSingleInstance(orditem.id,orderItemLicense.id);
       OSM_OMS_WS_RevokeGeneralized_OP_Wrapper op=new OSM_OMS_WS_RevokeGeneralized_OP_Wrapper();
       OSM_OMS_WS_RevokeLicenseRes res=new OSM_OMS_WS_RevokeLicenseRes();
       res.Header=null;
       res.body=null;
       op.Header=null;
       op.body=null;
       string jsonS='{"Header":null,"Body":{"Fault":{"faultcode":"soapenv:Server","faultstring":"LOSFaultMessage","detail":{"LosFault":{"faultCode":1115,"errorInfo":"License already revoked. Can not revoke again."}}}}}';
       OSM_OMS_WS_RevokeLicenseReq.parse(jsonS);
       OSM_OMS_WS_RevokeLicenseRes.parse(jsonS);
       OSM_OMS_SW_RevokeAPIFailbatchScheduler sc=new OSM_OMS_SW_RevokeAPIFailbatchScheduler();
       String sch = '0 0 23 * * ?'; 
       system.schedule('Test Territory Check', sch, sc); 
       Test.StopTest();
       
       
 }
}