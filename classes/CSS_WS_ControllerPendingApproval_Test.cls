@IsTest
Public Class CSS_WS_ControllerPendingApproval_Test {
    Public Static TestMethod Void listPendingTSMClaims(){
               
        Account CustomerTest = new Account(
            Type = 'Customer',
            Name = 'Sony');
        insert CustomerTest;
               
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54701',
            CSS_WS_Service_Provider_Dealer__c = '54701',
            CSS_WS_Service_Provider_Name_DR__c = 'MEGAMAK OCCIDENTE',
            CSS_WS_Service_Provider_Name_Dealer__c = 'MEGAMAK OCCIDENTE',
            CSS_WS_Claim_Status__c = 'Pending TSM',
            CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            CSS_WS_Account_Code__c = 'P88',
            CSS_WS_Policy_Flag__c = 'Policy');
        insert claim;
               
        //Query to "CSS_WS_Queue_TSM" queue
        List<GroupMember> group_test = [SELECT GroupId FROM GroupMember WHERE Group.DeveloperName = 'CSS_WS_Queue_TSM' LIMIT 1];
        
        // Create an approval request for the claim
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setObjectId(claim.id);

        // Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('CSS_WS_Policy_88_Approval_Proc_FA_V3');
        req1.setSkipEntryCriteria(true);

        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_ControllerPendingApproval controller = new CSS_WS_ControllerPendingApproval(standardController);
        
        controller.ApproverSel = 'All';
        controller.getClaimsListApprover();
        controller.ApproverSel = String.valueOf(group_test[0].GroupId);
        controller.getClaimsListApprover();
        
        controller.exitClaimsUpdate();
        controller.getApproversSelectList();

        Test.stopTest();
    }
}