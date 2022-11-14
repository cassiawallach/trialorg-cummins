@isTest
Public Class CSS_WS_ControllerStatement_Test {
    Public Static testMethod Void approveMethodsLists(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Account DealerTest = new Account(
            IAM_Service_Provider_Code__c = '54732',
            CSS_DBCode__c = '54734',
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
            CMI_Account_Status__c = 'Active',
            Type = 'Customer',
            Name = 'Sony');
        insert CustomerTest;
        
        CSS_WS_Statement__c Statement = new CSS_WS_Statement__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54734');
        insert Statement; 
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54734',
            CSS_WS_Service_Provider_Name_DR__c = 'Tony',
            CSS_WS_Service_Provider_Name_Dealer__c = 'Tony',
            CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            CSS_WS_Claim_Status__c = 'Pending Planta Payment Policy',
            CSS_WS_Policy_Flag__c = 'Policy',
            CSS_WS_Total_Claim_Approved__c = 100,
            CSS_WS_Total_Amount_Part__c = 1,
            CSS_WS_Total_Amount_SRT__c = 1,
            CSS_WS_Total_Amount_Other_Claimables__c = 1,
            CSS_WS_Total_Amount_Travel__c = 1);
        insert claim;
        
        Test.StartTest();
        //Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', Statement.id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(Statement); 
        CSS_WS_ControllerStatement controller = new CSS_WS_ControllerStatement(standardController);
        controller.getDistributorsSelectList();
        controller.getDealersSelectList();
        controller.Statement.CSS_WS_Service_Provider_DR__c = 'All Distributors';
        controller.getDealersSelectList();
        controller.getClaimsList();
        controller.updateClaimsList();
        controller.getClaimsList();
        
        controller.approveStatement();
        Account customer = [SELECT Name FROM Account WHERE id =: claim.CSS_WS_Customer_Name_Internal__c LIMIT 1];
        controller.Index = 1;
        controller.ClaimNumber = claim.Name;
        controller.PolicyFlag = claim.CSS_WS_Policy_Flag__c;
        controller.DRCode = claim.CSS_WS_Service_Provider_DR__c;
        controller.DealerCode = claim.CSS_WS_Service_Provider_Dealer__c;
        controller.DRName = claim.CSS_WS_Service_Provider_Name_DR__c;
        controller.DealerName = claim.CSS_WS_Service_Provider_Name_Dealer__c;
        controller.CustomerName = customer.Name;
        controller.Status = claim.CSS_WS_Claim_Status__c;                
        controller.ClaimAmount = claim.CSS_WS_Total_Claim_Approved__c;
        controller.AddNewClaim();
        controller.ClaimsLists[0].UpdateClaim = true;
        controller.approveStatement();
        
        claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54734',
            CSS_WS_Service_Provider_Name_DR__c = 'Tony',
            CSS_WS_Service_Provider_Name_Dealer__c = 'Tony',
            CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            CSS_WS_Claim_Status__c = 'Pending Planta Payment Policy',
            CSS_WS_Policy_Flag__c = 'Policy',
            CSS_WS_Total_Claim_Approved__c = 100,
            CSS_WS_Total_Amount_Part__c = 0,
            CSS_WS_Total_Amount_SRT__c = 0,
            CSS_WS_Total_Amount_Other_Claimables__c = 0,
            CSS_WS_Total_Amount_Travel__c = 0);
        insert claim;   
        
        controller.getDistributorsSelectList();
        controller.getDealersSelectList();
        controller.getClaimsList();
        controller.updateClaimsList();
        controller.getClaimsList();
        
        controller.approveStatement();
        customer = [SELECT Name FROM Account WHERE id =: claim.CSS_WS_Customer_Name_Internal__c LIMIT 1];
        controller.Index = 1;
        controller.ClaimNumber = claim.Name;
        controller.PolicyFlag = claim.CSS_WS_Policy_Flag__c;
        controller.DRCode = claim.CSS_WS_Service_Provider_DR__c;
        controller.DealerCode = claim.CSS_WS_Service_Provider_Dealer__c;
        controller.DRName = claim.CSS_WS_Service_Provider_Name_DR__c;
        controller.DealerName = claim.CSS_WS_Service_Provider_Name_Dealer__c;
        controller.CustomerName = customer.Name;
        controller.Status = claim.CSS_WS_Claim_Status__c;                
        controller.ClaimAmount = claim.CSS_WS_Total_Claim_Approved__c;
        controller.AddNewClaim();
        controller.selected = true;
        controller.selectAllClaims();
        controller.selected = false;
        controller.selectAllClaims();
        controller.ClaimsLists[0].UpdateClaim = true;
        controller.sumTotal();
        controller.approveStatement();
        //controller.exitStatement();
        
        controller.sumTotal();
        controller.approveStatement();
        Test.StopTest();
    }
    
    Public Static testMethod Void declineMethodsLists(){
        PageReference pageRef = Page.CSS_WS_ClaimFormat;
        Account DealerTest = new Account(
            IAM_Service_Provider_Code__c = '54732',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            CMI_Account_Status__c = 'Active',
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
        
        CSS_WS_Statement__c Statement = new CSS_WS_Statement__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54734');
        insert Statement; 
        
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54734',
            CSS_WS_Service_Provider_Name_DR__c = 'Tony',
            CSS_WS_Service_Provider_Name_Dealer__c = 'Tony',
            CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            CSS_WS_Claim_Status__c = 'Pending Planta Payment Policy',
            CSS_WS_Policy_Flag__c = 'Policy',
            CSS_WS_Total_Claim_Approved__c = 100,
            CSS_WS_Total_Amount_Part__c = 1,
            CSS_WS_Total_Amount_SRT__c = 1,
            CSS_WS_Total_Amount_Other_Claimables__c = 1,
            CSS_WS_Total_Amount_Travel__c = 1);
        insert claim; 
        
        Test.StartTest();
        //Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id', Statement.id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(Statement); 
        CSS_WS_ControllerStatement controller = new CSS_WS_ControllerStatement(standardController);
        controller.getDistributorsSelectList();
        controller.getDealersSelectList();
        controller.Statement.CSS_WS_Service_Provider_DR__c = 'All Distributors';
        controller.getDealersSelectList();
        controller.getClaimsList();
        controller.updateClaimsList();
        controller.getClaimsList();
        
        controller.declineStatement();
        Account customer = [SELECT Name FROM Account WHERE id =: claim.CSS_WS_Customer_Name_Internal__c LIMIT 1];
        controller.Index = 1;
        controller.ClaimNumber = claim.Name;
        controller.PolicyFlag = claim.CSS_WS_Policy_Flag__c;
        controller.DRCode = claim.CSS_WS_Service_Provider_DR__c;
        controller.DealerCode = claim.CSS_WS_Service_Provider_Dealer__c;
        controller.DRName = claim.CSS_WS_Service_Provider_Name_DR__c;
        controller.DealerName = claim.CSS_WS_Service_Provider_Name_Dealer__c;
        controller.CustomerName = customer.Name;
        controller.Status = claim.CSS_WS_Claim_Status__c;                
        controller.ClaimAmount = claim.CSS_WS_Total_Claim_Approved__c;
        controller.AddNewClaim();
        controller.selected = true;
        controller.selectAllClaims();
        controller.selected = false;
        controller.selectAllClaims();
        controller.ClaimsLists[0].UpdateClaim = true;
        controller.declineStatement();

        claim = new CSS_WS_Warranty__c(
            CSS_WS_Service_Provider_DR__c = '54734',
            CSS_WS_Service_Provider_Dealer__c = '54734',
            CSS_WS_Service_Provider_Name_DR__c = 'Tony',
            CSS_WS_Service_Provider_Name_Dealer__c = 'Tony',
            CSS_WS_Customer_Name_Internal__c = CustomerTest.id,
            CSS_WS_Claim_Status__c = 'Pending Planta Payment Policy',
            CSS_WS_Policy_Flag__c = 'Policy',
            CSS_WS_Total_Claim_Approved__c = 100,
            CSS_WS_Total_Amount_Part__c = 0,
            CSS_WS_Total_Amount_SRT__c = 0,
            CSS_WS_Total_Amount_Other_Claimables__c = 0,
            CSS_WS_Total_Amount_Travel__c = 0);
        insert claim;   
        
        controller.getDistributorsSelectList();
        controller.getDealersSelectList();
        controller.getClaimsList();
        controller.updateClaimsList();
        controller.getClaimsList();
        
        controller.declineStatement();
        customer = [SELECT Name FROM Account WHERE id =: claim.CSS_WS_Customer_Name_Internal__c LIMIT 1];
        controller.Index = 1;
        controller.ClaimNumber = claim.Name;
        controller.PolicyFlag = claim.CSS_WS_Policy_Flag__c;
        controller.DRCode = claim.CSS_WS_Service_Provider_DR__c;
        controller.DealerCode = claim.CSS_WS_Service_Provider_Dealer__c;
        controller.DRName = claim.CSS_WS_Service_Provider_Name_DR__c;
        controller.DealerName = claim.CSS_WS_Service_Provider_Name_Dealer__c;
        controller.CustomerName = customer.Name;
        controller.Status = claim.CSS_WS_Claim_Status__c;                
        controller.ClaimAmount = claim.CSS_WS_Total_Claim_Approved__c;
        controller.AddNewClaim();
        controller.selected = true;
        controller.selectAllClaims();
        controller.selected = false;
        controller.selectAllClaims();
        controller.ClaimsLists[0].UpdateClaim = true;
        controller.sumTotal();
        
        controller.declineStatement();
        //controller.exitStatement();
        Test.StopTest();
    }
}