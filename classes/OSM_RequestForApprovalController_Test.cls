/******
Name:  OSM_RequestForApprovalController_Test
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            	DATE              	DETAIL                                
1.0 -   Neha Mehta       	27/03/2019     		INITIAL DEVELOPMENT
2.0	-	Charlynn Stubbert	10/08/2022			Changes for LL-34 test Revoke Approval button logic and added test for reject Approval button logic
*******/

@isTest
public class OSM_RequestForApprovalController_Test{
    // Create CC Request For Approval
    public static testMethod void reqData(){
        
        List<CC_Request_For_Approval__c> listreq = new List<CC_Request_For_Approval__c>();
        CC_Request_For_Approval__c req = new CC_Request_For_Approval__c ();
        req.Distributor_Comments__c = 'testComments';
        listreq.add(req);
        insert listreq ;
        Test.StartTest();
        OSM_RequestForApprovalController con=new  OSM_RequestForApprovalController(new ApexPages.StandardController(req));
        con.acceptRequest();
        con.rejectRequest();
        
        Test.StopTest();
    }
    
    //Charlynn - 8/9/2022 - Added to increase test coverage and test negative reject data scenario
    public static testMethod void rejectData_negative(){
        
        List<CC_Request_For_Approval__c> listreq = new List<CC_Request_For_Approval__c>();
        CC_Request_For_Approval__c req = new CC_Request_For_Approval__c ();
        req.Distributor_Comments__c = '';
        listreq.add(req);
        insert listreq;

        PageReference pageRef = Page.CCRequestForApprovalVFPage;
        Test.StartTest();
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOF(listreq[0].Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(req);       
        OSM_RequestForApprovalController con= new  OSM_RequestForApprovalController(sc);        
		PageReference redPage = con.rejectRequest();
        
        Test.StopTest();
        
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Please enter distributor comments.')) b = true;
        }
        system.assert(b);
    }
    //Charlynn - 8/9/2022 - Addition end
    //LL-34 Code Start

        public static testMethod void revokeData_positive(){
        
            // LL-34 Hotfix - DO NOT USE
            //List<OSM_Revoke_Approval_Products__mdt> revokeApprovalProducts = [SELECT id, label FROM OSM_Revoke_Approval_Products__mdt];
            List<ccrz__E_Product__c> products = new List<ccrz__E_Product__c>();
        	ccrz__E_Product__c prod = new ccrz__E_Product__c();
            prod.Name = 'FLEET COUNT';
            // LL-34 Hotfix - Removed metadata
            prod.ccrz__SKU__c = 'FLTCNT-54321-1';
            products.add(prod);
            insert products;
            
            System.assert(products[0].id != null, 'Product did not insert.');
            
        List<CC_Request_For_Approval__c> listreq = new List<CC_Request_For_Approval__c>();
        CC_Request_For_Approval__c req = new CC_Request_For_Approval__c ();
        req.Distributor_Comments__c = 'test comments';
            req.Product_Name__c = products[0].id;
        listreq.add(req);
        insert listreq;

        PageReference pageRef = Page.CCRequestForApprovalVFPage;
        Test.StartTest();
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', String.valueOF(listreq[0].Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(req);       
        OSM_RequestForApprovalController con= new  OSM_RequestForApprovalController(sc);
        PageReference redPage = con.revokeRequest();
		Test.StopTest();
        
            //verify there are no error messages in vfp
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = true;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Please enter distributor comments.')) b = false;
        }
        system.assert(b);
            
            //verify the CC_Request_For_Approval__c was updated to 'Revoke Approval'
        List<CC_Request_For_Approval__c> resultReq = [SELECT Id,Request_Status__c FROM CC_Request_For_Approval__c];
            System.assertEquals(true, !resultReq.isEmpty(), 'revokeData_positive: The Request for Approval list is empty.');
            System.assertEquals('Approval Revoked', resultReq[0].Request_Status__c, 'revokeData_positive: The request status did not update to Revoke Approval');
    }
    // LL-34 Code End
    
    public static testMethod void UpdateRFATest(){   
        
        List<CC_Request_For_Approval__c> listreq = new List<CC_Request_For_Approval__c>();
        CC_Request_For_Approval__c req = new CC_Request_For_Approval__c ();
        req.Distributor_Comments__c = 'testComments';
        listreq .add(req);
        insert listreq ;
        
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
        
        ccrz__E_Order__c order = new ccrz__E_Order__c();
        order.ccrz__Account__c = testAccount.ID;
        order.OSM_SW_Should_mail_Send__c = true;
        order.OSM_SW_Is_InterCompany_Order__c = false;
        order.ccrz__OrderStatus__c='Order Submitted';
        
        insert order;
        
        List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
        
        ccrz__E_OrderItem__c subscOrderItem = new ccrz__E_OrderItem__c();
        subscOrderItem.ccrz__Order__c = order.ID;
        subscOrderItem.ccrz__Quantity__c = 1;
        //subscOrderItem.ccrz__Product__c = null;
        //subscOrderItem.ccrz__Product__c = getProductID('Insite');
        // subscOrderItem.ccrz__DisplayProduct__c = getProductID('Insite');
        subscOrderItem.Number_of_Bundles__c = 5;
        subscOrderItem.Number_of_Counts__c = 2;
        subscOrderItem.ccrz__Price__c = 15.00;
        subscOrderItem.ccrz__SubAmount__c = 15.00;
        subscOrderItem.OSM_SW_Is_without_Coterm__c= false;
        orderItemList.add(subscOrderItem);
        
        insert orderItemList;
        
        Set<Id> orderIdSet = new Set<Id>();
        orderIdSet.add(order.id);
        
        Test.StartTest();
        OSM_RequestForApprovalController.UpdateRFA_OnOrderCancellation(orderIdSet);
        Test.StopTest();  
    }
}