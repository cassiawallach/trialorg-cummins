//Updated By Sangeeta on 15th March 2021
//Updated Sharad
//Updated Dhiraj
//Updated Sangeeta
//Update Subbu
@isTest
public with sharing class OSM_CancelLicenses_ServicesH_Test {

    public static testMethod void testMethodforCallingCancelLicenseApi()
    {
        //Create account
        Account portalAccount1 = new Account(
        Name = 'TestAccount2',
        OwnerId = UserInfo.getUserId()
        );
        Database.insert(portalAccount1);

        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty2',
        AccountId = portalAccount1.Id,IAM_Contact_Status__c = 'Active',
        Username__c='OSM1Test6662'+'test@test.com',
        Email = 'test2' + 'test@test.com'
        );
        
        Database.insert(contact1);
        ccrz__E_Order__c order = new ccrz__E_Order__c();
        order.ccrz__Contact__c=contact1.id;
        order.Activation_Key_Failure_Mail_Sent__c=true;
        order.OSM_SW_Should_mail_Send__c=false;
        //order.Max_Activation_Keys__c =1;
        insert order;
        
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'INSITE™ Pro';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        
                
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c = order.ID; 
        orderItem.ccrz__Price__c = 50.00;
        orderItem.OMS_Item_ID__c='1234';
        orderItem.OMS_Product__c=true;
        orderItem.Tool_Instance_Key__c='';
        orderItem.ccrz__Quantity__c = 1;
        orderItem.ccrz__SubAmount__c = 50.00;
        orderItem.ccrz__Product__c=prod.id;
        orderItem.OMS_Product__c=true;
        orderItem.OSM_GetTI_Success__c=true;
                //orderItem.CancelLicenseAPICalled__c=false;
        orderItem.OMS_Order_ID__c = '123';
        //orderItem.IsRevokeLicenseSucess__c=true;
        orderItem.ccrz__DisplayProduct__c=prod.id;
        //orderItem.ccrz__Order__r.ccrz__Account__c = portalAccount1.id;//Added by Dhiraj
        insert orderItem;
        
        ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
        sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        //sub.ccrz__SPT__c = spt.Billing_Display_Name__c;
        sub.ccrz__Storefront__c = 'SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.ccrz__SubscriptionStatus__c = 'Active';
        sub.OSM_Subscription_End_Date__c = system.today()-2;
        sub.ccrz__CCOrderItem__c=orderItem.id;
        //sub.OSM_Free_Trial__c =true;
        //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
       
        //insert sub;

        Set<Id> orderItemIdSet=new Set<Id>();
        orderItemIdSet.add(orderItem.id);
        
        OSM_Order_Item_License__c license=new OSM_Order_Item_License__c();
        license.CC_Order_Item__c=orderItem.id;
        license.Status__c ='New';
        license.OMS_Item_Id__c='1234';
        license.Tool_Instance_Key__c='';
        //license.Activation_Key__c='D8QV7BPP1BJ2';
   //     license.OMS_Item_Id_Basic__c='3333';
        insert license;
        
        OSM_Order_Item_License__c licenseChild=new OSM_Order_Item_License__c();
        licenseChild.CC_Order_Item__c=orderItem.id;
        licenseChild.Status__c ='New';
        licenseChild.OMS_Item_Id__c='1244';
        licenseChild.Tool_Instance_Key__c='F11111';
        licenseChild.Parent_Activation_Key__c=license.id;
      //  licenseChild.Activation_Key__c='D8QV7BPP1BJ2';
        licenseChild.IsCancelCalledSuccess__c=true;
        licenseChild.Revoked_ReIssue_Lisence__c=license.id;
   //     licenseChild.OMS_Item_Id_Basic__c='3333';
        insert licenseChild;
        
        Test.StartTest();
        OSM_CancelLicenses_ServiceHandler.callCancelLicensesAPI(orderItemIdSet);
        String jsonInput='{"Header":{"Target":{"TargetID":"OMS"},"Sender":{"ServiceName":"CancelLicense","SenderID":"Mrktplc"}},"CancelLicensesInput":{"TotalCopies":1,"ToolName":"INSITE","RequesterId":"nu6155@cummins.com","ItemId":"8559950"}}';
        String jsonOutput='{"Header":{"Sender":{"ServiceName":"CancelLicense","SenderID":"Mrktplc"},"Status":"Success","Target":{"TargetID":"OMS"},"ReturnCodeDescription":"Success"},"CancelLicensesOutput":{"CancelledCopies":1,"CancelLicenseStatus":true,"RemainingCopies":0}}';
        OSM_CancelLicensesREQWrapper reqWrap=new OSM_CancelLicensesREQWrapper();
        OSM_CancelLicensesREQWrapper.parse(jsonInput);
        OSM_CancelLicensesREQ_GeneralizedWrapper reqGenWrap=new OSM_CancelLicensesREQ_GeneralizedWrapper();
        OSM_CancelLicensesREQ_GeneralizedWrapper.parse(jsonInput);
        OSM_CancelLicensesRESWrapper resWrap=new OSM_CancelLicensesRESWrapper();
        OSM_CancelLicensesRESWrapper.parse(jsonOutput);
        OSM_CancelLicensesRES_GeneralizedWrapper resGenWrap=new OSM_CancelLicensesRES_GeneralizedWrapper();
        OSM_CancelLicensesRES_GeneralizedWrapper.parse(jsonOutput);
        
        Test.StopTest();
       }
     public static testMethod void testMethodforCallingCancelLicenseApi2()
     {
        //Create account
        Account portalAccount1 = new Account(
        Name = 'TestAccount2',
        OwnerId = UserInfo.getUserId()
        );
        Database.insert(portalAccount1);

        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty2',
        AccountId = portalAccount1.Id,IAM_Contact_Status__c = 'Active',
        Username__c='OSM1Test6662'+'test@test.com',
        Email = 'test2' + 'test@test.com'
        );
        
        Database.insert(contact1);
        ccrz__E_Order__c order = new ccrz__E_Order__c();
        order.ccrz__Contact__c=contact1.id;
        order.Activation_Key_Failure_Mail_Sent__c=true;
        order.OSM_SW_Should_mail_Send__c=false;
        //order.Max_Activation_Keys__c =1;
        insert order;
        
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'INSITE™ Pro';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        
                
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c = order.ID; 
        orderItem.ccrz__Price__c = 50.00;
        orderItem.OMS_Item_ID__c='1234';
        orderItem.OMS_Product__c=true;
        orderItem.Tool_Instance_Key__c='';
        orderItem.ccrz__Quantity__c = 1;
        orderItem.ccrz__SubAmount__c = 50.00;
        orderItem.ccrz__Product__c=prod.id;
        orderItem.OMS_Product__c=true;
        orderItem.OSM_GetTI_Success__c=true;
                //orderItem.CancelLicenseAPICalled__c=false;
        orderItem.OMS_Order_ID__c = '123';
        //orderItem.IsRevokeLicenseSucess__c=true;
        orderItem.ccrz__DisplayProduct__c=prod.id;
        insert orderItem;
        
        ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
        sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        //sub.ccrz__SPT__c = spt.Billing_Display_Name__c;
        sub.ccrz__Storefront__c = 'SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.ccrz__SubscriptionStatus__c = 'Active';
        sub.OSM_Subscription_End_Date__c = system.today()-2;
        sub.ccrz__CCOrderItem__c=orderItem.id;
        //sub.OSM_Free_Trial__c =true;
        //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
       
        //insert sub;

        Set<Id> orderItemIdSet=new Set<Id>();
        orderItemIdSet.add(orderItem.id);
        
        OSM_Order_Item_License__c license=new OSM_Order_Item_License__c();
        license.CC_Order_Item__c=orderItem.id;
        license.Status__c ='New';
        license.OMS_Item_Id__c='1234';
        license.Tool_Instance_Key__c='';
        //license.Activation_Key__c='D8QV7BPP1BJ2';
   //     license.OMS_Item_Id_Basic__c='3333';
        insert license;
        
        OSM_Order_Item_License__c licenseChild=new OSM_Order_Item_License__c();
        licenseChild.CC_Order_Item__c=orderItem.id;
        licenseChild.Status__c ='New';
        licenseChild.OMS_Item_Id__c='1244';
        licenseChild.Tool_Instance_Key__c='F11111';
        licenseChild.Parent_Activation_Key__c=license.id;
      //  licenseChild.Activation_Key__c='D8QV7BPP1BJ2';
        licenseChild.IsCancelCalledSuccess__c=true;
        //licenseChild.Revoked_ReIssue_Lisence__c=license.id;
   //     licenseChild.OMS_Item_Id_Basic__c='3333';
        insert licenseChild;
        
        Test.StartTest();
        OSM_CancelLicenses_ServiceHandler.callCancelLicensesAPI(orderItemIdSet);
        String jsonInput='{"Header":{"Target":{"TargetID":"OMS"},"Sender":{"ServiceName":"CancelLicense","SenderID":"Mrktplc"}},"CancelLicensesInput":{"TotalCopies":1,"ToolName":"INSITE","RequesterId":"nu6155@cummins.com","ItemId":"8559950"}}';
        String jsonOutput='{"Header":{"Sender":{"ServiceName":"CancelLicense","SenderID":"Mrktplc"},"Status":"Success","Target":{"TargetID":"OMS"},"ReturnCodeDescription":"Success"},"CancelLicensesOutput":{"CancelledCopies":1,"CancelLicenseStatus":true,"RemainingCopies":0}}';
        OSM_CancelLicensesREQWrapper reqWrap=new OSM_CancelLicensesREQWrapper();
        OSM_CancelLicensesREQWrapper.parse(jsonInput);
        OSM_CancelLicensesREQ_GeneralizedWrapper reqGenWrap=new OSM_CancelLicensesREQ_GeneralizedWrapper();
        OSM_CancelLicensesREQ_GeneralizedWrapper.parse(jsonInput);
        OSM_CancelLicensesRESWrapper resWrap=new OSM_CancelLicensesRESWrapper();
        OSM_CancelLicensesRESWrapper.parse(jsonOutput);
        OSM_CancelLicensesRES_GeneralizedWrapper resGenWrap=new OSM_CancelLicensesRES_GeneralizedWrapper();
        OSM_CancelLicensesRES_GeneralizedWrapper.parse(jsonOutput);
        
        Test.StopTest();
       }
       
}