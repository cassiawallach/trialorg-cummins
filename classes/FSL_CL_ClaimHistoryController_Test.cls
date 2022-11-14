//Adding comment for deployment -- Akansha MV_688 8/25/2022
/* Adding comment for deployment
* Test Class for Apex Controller - FSL_CL_ClaimHistoryController
* Author - Piyush Rani - Sriprada S
* Author - Diksha Rajpurohit increase test coverage
*/ 
@isTest
public class FSL_CL_ClaimHistoryController_Test {
    
    @isTest
    static void SearchClaimHistory_Test() {
        Test.startTest();
        
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79393939';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        insert jo;
        
        CSS_Claims__c cl = new CSS_Claims__c();
        cl.CSS_Job__c = CSS_TestData.createJobOrder(true).id;
        cl.CSS_Job__c=jo.id;
        
        insert cl;
        
        
        Asset aset = FSL_TestDataUtility.createAsset();
        FSL_CL_ClaimHistoryController.claimID = cl.Id;
       
        List<FSL_CL_ClaimHistoryController.ClaimHistoryWrapper> ClaimHistoryWrapperList = new 
        								List<FSL_CL_ClaimHistoryController.ClaimHistoryWrapper>();
        ClaimHistoryWrapperList = FSL_CL_ClaimHistoryController.SearchClaimHistory(aset.Name);
        ClaimHistoryWrapperList = FSL_CL_ClaimHistoryController.SearchClaimHistory('');
        ClaimHistoryWrapperList = FSL_CL_ClaimHistoryController.SearchClaimHistory('123456');
        Test.stopTest();
    }
    
    @isTest static void SearchClaimHistory_Test1() {
        Test.startTest();

        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '567328412';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'open';
        jo.Service_Model__c = 'model';
        insert jo;

        CSS_Claims__c cl = new CSS_Claims__c();
        cl.CSS_Job__c = CSS_TestData.createJobOrder(false).id;
        insert cl;

        Asset aset = FSL_TestDataUtility.createAsset();
        List<FSL_CL_ClaimHistoryController.ClaimHistoryWrapper> ClaimHistoryWrapperList = new 
        								List<FSL_CL_ClaimHistoryController.ClaimHistoryWrapper>();
        Test.stopTest();
    }
    
    Public static testmethod void performClaimHistoryBusinessLogic_Test(){ 
        
        Test.startTest();  
        
         CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
         cid.name = 'SiebelClaimHistory';
         cid.ApplicationName__c = 'SiebelClaimHistory';
         cid.End_Point__c = 'https://services-test.cummins.com/csswarranty/claimhistory';
         cid.logging__c = 'BOTH';
         cid.AuthEnv__c = 'OAGOAuthTest';
         cid.Method_Type__c = 'GET';
         cid.Timeout__c = 120000;
         insert cid;
        
        CG_BL_Claims Claim = new CG_BL_Claims();
        FSL_CL_ClaimHistoryController.performClaimHistoryBusinessLogic('79464646');
        
        FSL_CL_ClaimHistoryController.ClaimHistoryWrapper obj = new FSL_CL_ClaimHistoryController.ClaimHistoryWrapper();
        obj.sFailure_date = 'testF';
        obj.sDistributor_s_Invoice_Paid = 'testF';
        obj.isExceptionFlag = FALSE;
        Test.stopTest(); 
    }
}