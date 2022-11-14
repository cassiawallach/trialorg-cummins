@IsTest
Public Class CSS_WS_ControllerApproveClaims_Test {
    Public Static TestMethod Void notUpdateMethods(){
        Account DealerTest = new Account(
            IAM_Service_Provider_Code__c = '54731',
            CSS_DBCode__c = '54733',
            Type = 'Dealer Account',
            CMI_Account_Status__c = 'Active',
            Name = 'Dummy Dealer');
        insert DealerTest;
        
        Account DRTest = new Account(
            IAM_Service_Provider_Code__c = '54734',
            CSS_DBCode__c = '54734',
            Type = 'Distributor Account',
            CMI_Account_Status__c = 'Active',
            Name = 'Dummy DR');
        insert DRTest;
        
        Account CustomerTest = new Account(
            IAM_Service_Provider_Code__c = '1234',
            CSS_DBCode__c = '5432',
            Type = 'Customer',
            CMI_Account_Status__c = 'Active',
            Name = 'Sony');
        insert CustomerTest;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54734',
            CSS_WS_Service_Provider_Name_DR__c = 'Tony',
            CSS_WS_Service_Provider_Name_Dealer__c = 'Tony',
            CSS_WS_Claim_Status__c = 'Pending DR Payment to DL',
            CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            CSS_WS_Policy_Flag__c = 'Policy',
            CSS_WS_CM_Document_Type__c = 'COMC', 
            CSS_WS_CM_Transaction_Number__c = '12345',
            CSS_WS_Total_Claim_Approved__c = 100,
            CSS_WS_Total_Amount_Part__c = 1,
            CSS_WS_Total_Amount_SRT__c = 1,
            CSS_WS_Total_Amount_Other_Claimables__c = 1,
            CSS_WS_Total_Amount_Travel__c = 1);
        insert claim;
        
        claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54733',
            CSS_WS_Service_Provider_Name_DR__c = 'Tony',
            CSS_WS_Service_Provider_Name_Dealer__c = 'Tony',
            CSS_WS_Claim_Status__c = 'Pending DR Payment to DL',
            CSS_WS_Policy_Flag__c = 'Policy',
            CSS_WS_CM_Document_Type__c = 'COMC', 
            CSS_WS_CM_Transaction_Number__c = '12345',
            CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            CSS_WS_Total_Claim_Approved__c = 100,
            CSS_WS_Total_Amount_Part__c = 1,
            CSS_WS_Total_Amount_SRT__c = 1,
            CSS_WS_Total_Amount_Other_Claimables__c = 1,
            CSS_WS_Total_Amount_Travel__c = 1);
        insert claim;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_ControllerApproveClaims controller = new CSS_WS_ControllerApproveClaims(standardController);
        
        Test.startTest();
        controller.DealerSel = '54734';
        controller.DistributorSel = '54734';
        controller.getClaimsList();
        controller.DealerSel = 'All Dealers';
        controller.DistributorSel = '54734';
        controller.ComcValue = 'COMC 12345';
        controller.getClaimsList();
        
        controller.updateClaimsList();
        controller.exitClaimsUpdate();
        controller.getDistributorsSelectList();
        controller.getDealersSelectList();
        
        //controller.getSpName('54734', 'DR');
        //controller.getSpName('54734', 'Distributor');
        
        controller.claimToUpdate = 1;
        controller.claimTemp.CSS_WS_DLR_Payment_Date__c = system.today();
        controller.claimTemp.CSS_WS_DLR_Credit_Number__c = '9001';
        controller.ClaimsLists[0].ChangeValueClaim = true;
        
        controller.claimToUpdate = 1;
        controller.enableDisabledButtons();
        controller.ClaimsLists[0].claim.CSS_WS_DLR_Payment_Date__c = system.today();
        controller.ClaimsLists[0].claim.CSS_WS_DLR_Credit_Number__c = '9001';
        controller.enableDisabledButtons();
        controller.enableDisabledButtonApplyAll();
        controller.CheckSelected();
        controller.SelectAll = true;
        controller.enableDisabledButtonApplyAll();
        controller.ClaimsLists[0].UpdateClaim = true;
        controller.CheckSelected();
        controller.enableDisabledButtons();
                
        controller.updateClaimsListValues();
        Test.stopTest();
    }
    
    Public Static TestMethod Void updateMethods(){
        Account DealerTest = new Account(
            IAM_Service_Provider_Code__c = '54733',
            CSS_DBCode__c = '54733',
            CMI_Account_Status__c = 'Active',
            Type = 'Distributor Account',
            Name = 'Dummy Dealer');
        insert DealerTest;
        
        Account DRTest = new Account(
            IAM_Service_Provider_Code__c = '54734',
            CSS_DBCode__c = '54734',
            CMI_Account_Status__c = 'Active',
            Type = 'Distributor Account',
            Name = 'Dummy DR');
        insert DRTest;
        
        Account CustomerTest = new Account(
            IAM_Service_Provider_Code__c = '1234',
            CSS_DBCode__c = '5432',
            CMI_Account_Status__c = 'Active',
            Type = 'Customer',
            Name = 'Sony');
        insert CustomerTest;
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54734',
            CSS_WS_Service_Provider_Name_DR__c = 'Tony',
            CSS_WS_Service_Provider_Name_Dealer__c = 'Tony',
            CSS_WS_Claim_Status__c = 'Pending DR Payment to DL',
            CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            CSS_WS_CM_Document_Type__c = 'COMC', 
            CSS_WS_CM_Transaction_Number__c = '12345',
            CSS_WS_Policy_Flag__c = 'Policy');
        insert claim;
        claim.Name = [SELECT CSS_WS_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: claim.Id].CSS_WS_Claim_Number__c;
        update claim;
        
        claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54734',
            CSS_WS_Service_Provider_Name_DR__c = 'Tony',
            CSS_WS_Service_Provider_Name_Dealer__c = 'Tony',
            CSS_WS_Claim_Status__c = 'Pending DR Payment to DL',
            CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            CSS_WS_CM_Document_Type__c = 'COMC', 
            CSS_WS_CM_Transaction_Number__c = '12345',
            CSS_WS_Policy_Flag__c = 'Policy');
        insert claim;
        claim.Name = [SELECT CSS_WS_Claim_Number__c FROM CSS_WS_Warranty__c WHERE Id =: claim.Id].CSS_WS_Claim_Number__c;
        update claim;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Claim);
        CSS_WS_ControllerApproveClaims controller = new CSS_WS_ControllerApproveClaims(standardController);
        
        Test.startTest();
        controller.DealerSel = '54734';
        controller.DistributorSel = '54734';
        controller.ComcValue = 'COMC 12345';
        controller.getClaimsList();
        controller.claimToUpdate = 1;
        controller.updateClaimsListValues();
        controller.ClaimsLists[0].claim.CSS_WS_DLR_Payment_Date__c = system.today();
        controller.ClaimsLists[0].claim.CSS_WS_DLR_Credit_Number__c = '9001';
        controller.updateSelectedClaim();
        
        controller.ClaimsLists[0].UpdateClaim = true;
        controller.ClaimsLists[0].claim.CSS_WS_DLR_Payment_Date__c = system.today();
        controller.ClaimsLists[0].claim.CSS_WS_DLR_Credit_Number__c = '9001';
        controller.updateAllSelectedClaims();
        Test.stopTest();
    }
}