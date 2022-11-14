//Test Class for the class OSM_SW_ccLogicOrderAuthCancel
// sharad 18 may 2021
// update by Dhiraj 23rd June 2021
//update by Dhiraj 29th June 2021
//updated by Singaiah for MAR-1550 & MAR-2021
///*****************************************************/
@isTest
  public class OSM_SW_ccLogicOrderAuthCancel_Test 
{
   /* static testmethod void testProcess_greaterThan24hrs()
    {
        Map<String,Object> inputData = new Map<String,Object>();
        
        Map<String,Object> fieldMap = new Map<String,Object>();
        fieldMap.put('hoursSinceOrderDate', 26);
        
        List<Object> orderLst = new List<Object>(); 
        orderLst.add(fieldMap);
        
        inputData.put('orderList', orderLst);
        
        OSM_SW_ccLogicOrderAuthCancel ob = new OSM_SW_ccLogicOrderAuthCancel();
        
        ob.process(inputData);
    }*/
    
    
    static testMethod void testProcess_greaterThan24hrs1(){
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
        
        
        System.debug('transecRes: '+transecRes);
        
        
        
        PermissionSet objPer = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Support_Admin' Limit 1];
        if(objPer != null)
        {
            
            List<PermissionSetAssignment> psaLst = new List<PermissionSetAssignment>();
            psaLst = [Select Id from PermissionSetAssignment where PermissionSetId =: objPer.Id];
            if(psaLst.size() > 0)
                delete psaLst;
        
            PermissionSetAssignment psa = new PermissionSetAssignment
            (PermissionSetId = objPer.Id, AssigneeId = transecRes.objSetupDate.loggedInUser.Id);
            insert psa;  
        }
        // Creating address
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
            
        
            try
            {
                
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
                Map<String,Object> inputData = new Map<String,Object>();
            
                Map<String,Object> fieldMap = new Map<String,Object>();
                fieldMap.put('hoursSinceOrderDate', 26);
                fieldMap.put('minimumSubscriptionlength', 2);
                fieldMap.put('OSMSWDaysSinceOrderDate', 1);
                
                List<Object> orderLst = new List<Object>();
                orderLst.add(fieldMap);
                
                inputData.put('orderList', orderLst);
                
                OSM_SW_ccLogicOrderAuthCancel ob = new OSM_SW_ccLogicOrderAuthCancel();
                
                ob.process(inputData);
            }
            Catch(Exception ex){}
        
        }

    }
    
    static testMethod void testProcess_greaterThan24hrs2(){
    
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
        
        
        System.debug('transecRes: '+transecRes);
        
        
        
        
        PermissionSet objPer = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Support_Admin' Limit 1];
        if(objPer != null)
        {
            List<PermissionSetAssignment> psaLst = new List<PermissionSetAssignment>();
            psaLst = [Select Id from PermissionSetAssignment where PermissionSetId =: objPer.Id];
            if(psaLst.size() > 0)
                delete psaLst;
            
            PermissionSetAssignment psa = new PermissionSetAssignment
            (PermissionSetId = objPer.Id, AssigneeId = transecRes.objSetupDate.loggedInUser.Id);
            insert psa;  
        }
        

        // Creating address
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
            
        
            try
            {
                
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
                Map<String,Object> inputData = new Map<String,Object>();
            
                Map<String,Object> fieldMap = new Map<String,Object>();
                fieldMap.put('hoursSinceOrderDate', 26);
                fieldMap.put('minimumSubscriptionlength', 2);
                fieldMap.put('OSMSWNoofRevokedOrderItem', 1);
                
                List<Object> orderLst = new List<Object>();
                orderLst.add(fieldMap);
                
                inputData.put('orderList', orderLst);
                
                OSM_SW_ccLogicOrderAuthCancel ob = new OSM_SW_ccLogicOrderAuthCancel();
                
                ob.process(inputData);
            }
            Catch(Exception ex){}
        
        }

    }
    
    static testMethod void testProcess_greaterThan24hrs3(){
    
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
        
        
        System.debug('transecRes: '+transecRes);
        
        
        
        
        PermissionSet objPer = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Support_Admin' Limit 1];
        if(objPer != null)
        {
            List<PermissionSetAssignment> psaLst = new List<PermissionSetAssignment>();
            psaLst = [Select Id from PermissionSetAssignment where PermissionSetId =: objPer.Id];
            if(psaLst.size() > 0)
                delete psaLst;
            PermissionSetAssignment psa = new PermissionSetAssignment
            (PermissionSetId = objPer.Id, AssigneeId = transecRes.objSetupDate.loggedInUser.Id);
            insert psa;  
        }
        

        // Creating address
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
            
        
            try
            {
                
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
                Map<String,Object> inputData = new Map<String,Object>();
            
                Map<String,Object> fieldMap = new Map<String,Object>();
                fieldMap.put('hoursSinceOrderDate', 26);
                fieldMap.put('minimumSubscriptionlength', 3);
                
                List<Object> orderLst = new List<Object>();
                orderLst.add(fieldMap);
                
                inputData.put('orderList', orderLst);
                
                OSM_SW_ccLogicOrderAuthCancel ob = new OSM_SW_ccLogicOrderAuthCancel();
                
                ob.process(inputData);
            }
            Catch(Exception ex){}
        
        }

    }
    
}