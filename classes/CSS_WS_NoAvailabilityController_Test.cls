@isTest(SeeAllData=true)
Public Class CSS_WS_NoAvailabilityController_Test{

    Public Static TestMethod Void testMethodSave(){
        PageReference pageRef = Page.CSS_WS_NoAvailability_Form;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_No_Availability__c NoAvailability = new CSS_WS_No_Availability__c(
            CSS_WS_Authorizer__c = null,
            CSS_WS_Brand_Unit__c ='A C INDUSTRIES',
            CSS_WS_Client__c ='Castores',
            CSS_WS_Comments__c ='No comments',
            CSS_WS_Created_By_Display__c ='No',
            CSS_WS_Creation_Date__c = Date.today(),
            CSS_WS_Dealer__c ='12345',
            CSS_WS_After_Sales_Engineer__c ='No',
            CSS_WS_DR_Contact__c ='73011',
            CSS_WS_Number_Unit__c ='111',
            CSS_WS_ESN__c ='11111111',
            CSS_WS_Factory_Distribution__c ='No',
            CSS_WS_Model_Unit__c ='DM1',
            CSS_WS_No_attention_reason__c ='Otra',
            CSS_WS_Attention_Dealer__c ='54699',
            CSS_WS_Attention_DR__c ='73011',
            CSS_WS_OEM__c ='No',
            CSS_WS_Regional_Distributor__c ='54734',
            CSS_WS_Special_Delivery__c ='No',
            CSS_WS_Status__c ='Draft');
            
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(NoAvailability); 
        CSS_WS_NoAvailabilityController controller = new CSS_WS_NoAvailabilityController(standardController);  
        controller.Save_NoAvailability_Format();
        controller.language = 'es_MX';
        controller.esn='';
        controller.model ='';
        controller.brand = '';
        controller.startDate=String.valueOf(system.today());
        controller.getPermissionSet('CSS_WS_Factory_Warranty_Manager');
        Test.stopTest();      
    }

    Public Static TestMethod Void testMethodSaveError(){
        PageReference pageRef = Page.CSS_WS_NoAvailability_Form;
        Account account = new Account(
            Name = 'TestAccount2',
            type = 'Dealer Account',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO',
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734');
        insert account;
        
        CSS_WS_No_Availability__c NoAvailability = new CSS_WS_No_Availability__c(
            CSS_WS_Authorizer__c = null,
            CSS_WS_Brand_Unit__c = 'A C INDUSTRIES',
            CSS_WS_Client__c = 'Castores',
            CSS_WS_Comments__c = 'No Comments',
            CSS_WS_Created_By_Display__c = 'No',
            CSS_WS_Creation_Date__c =  Date.today(),
            CSS_WS_Dealer__c = '12345',
            CSS_WS_After_Sales_Engineer__c = 'No',
            CSS_WS_DR_Contact__c = 'kiwl099',
            CSS_WS_Number_Unit__c = '111',
            CSS_WS_ESN__c = '11111111',
            CSS_WS_Factory_Distribution__c = 'No',
            CSS_WS_Model_Unit__c = 'DM1',
            CSS_WS_No_attention_reason__c = 'Otra',
            CSS_WS_Attention_Dealer__c = '54699',
            CSS_WS_Attention_DR__c = '73011',
            CSS_WS_OEM__c = 'No',
            CSS_WS_Regional_Distributor__c = '54734',
            CSS_WS_Special_Delivery__c = 'No',
            CSS_WS_Status__c = 'Draft');

        ApexPages.StandardController standardController = new ApexPages.StandardController(NoAvailability); 
        CSS_WS_NoAvailabilityController controller = new CSS_WS_NoAvailabilityController(standardController);  
        controller.Save_NoAvailability_Format();   
        controller.deletESN();
    }
        
    Public Static TestMethod Void testMethodIncompleteInfo(){
        PageReference pageRef = Page.CSS_WS_NoAvailability_Form;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_No_Availability__c NoAvailability = new CSS_WS_No_Availability__c(
            CSS_WS_Authorizer__c = null,
            CSS_WS_Brand_Unit__c = 'A C INDUSTRIES',
            CSS_WS_Client__c = 'Castores',
            CSS_WS_Comments__c = null,
            CSS_WS_Created_By_Display__c = 'No',
            CSS_WS_Creation_Date__c = Date.today(),
            CSS_WS_Dealer__c = '12345',
            CSS_WS_After_Sales_Engineer__c = 'No',
            CSS_WS_DR_Contact__c = '73011',
            CSS_WS_Number_Unit__c = '111',
            CSS_WS_ESN__c = '12345678',
            CSS_WS_Factory_Distribution__c = 'No',
            CSS_WS_Model_Unit__c = 'DM1',
            CSS_WS_No_attention_reason__c = 'Otra',
            CSS_WS_Attention_Dealer__c = '54699',
            CSS_WS_Attention_DR__c = '73011',
            CSS_WS_OEM__c = 'No',
            CSS_WS_Regional_Distributor__c = '54734',
            CSS_WS_Special_Delivery__c =  null,
            CSS_WS_Status__c = 'Draft');
        
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(NoAvailability); 
        CSS_WS_NoAvailabilityController controller = new CSS_WS_NoAvailabilityController(standardController);  
        controller.Save_NoAvailability_Format();
        Test.stopTest();
    }
    
    Public Static TestMethod Void testMethodDealerAndDR(){
        PageReference pageRef = Page.CSS_WS_NoAvailability_Form;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '54321',
            CSS_DBCode__c = '54321',
            Type = 'Distributor Account',
            Name = 'MEGAMAK SURESTE',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_No_Availability__c NoAvailability = new CSS_WS_No_Availability__c(
            CSS_WS_Authorizer__c = null,
            CSS_WS_Brand_Unit__c = 'A C INDUSTRIES',
            CSS_WS_Client__c = 'Castores',
            CSS_WS_Comments__c = 'No comments',
            CSS_WS_Created_By_Display__c = 'No',
            CSS_WS_Creation_Date__c = Date.today(),
            CSS_WS_Dealer__c = '54321',
            CSS_WS_After_Sales_Engineer__c = 'No',
            CSS_WS_DR_Contact__c = '73011',
            CSS_WS_Number_Unit__c = '111',
            CSS_WS_ESN__c = '11111111',
            CSS_WS_Factory_Distribution__c = 'No',
            CSS_WS_Model_Unit__c = 'DM1',
            CSS_WS_No_attention_reason__c = 'Otra',
            CSS_WS_Attention_Dealer__c = '54321',
            CSS_WS_Attention_DR__c = '54321',
            CSS_WS_OEM__c = 'No',
            CSS_WS_Regional_Distributor__c = '54321',
            CSS_WS_Special_Delivery__c = 'No',
            CSS_WS_Status__c = 'Draft');
              
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(NoAvailability); 
        CSS_WS_NoAvailabilityController controller = new CSS_WS_NoAvailabilityController(standardController);   
        controller.getnaDistributorsSelectList();
        controller.getnaDealersSelectList();
        Test.stopTest();
    }

    Public Static TestMethod Void testMethodAttentionDealerAndDR(){
        PageReference pageRef = Page.CSS_WS_NoAvailability_Form;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '54321',
            CSS_DBCode__c = '54321',
            Type = 'Distributor Account',
            Name = 'MEGAMAK SURESTE',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_No_Availability__c NoAvailability = new CSS_WS_No_Availability__c(
            CSS_WS_Authorizer__c = null,
            CSS_WS_Brand_Unit__c = 'A C INDUSTRIES',
            CSS_WS_Client__c = 'Castores',
            CSS_WS_Comments__c = 'No comments',
            CSS_WS_Created_By_Display__c = 'No',
            CSS_WS_Creation_Date__c = Date.today(),
            CSS_WS_Dealer__c = '54321',
            CSS_WS_After_Sales_Engineer__c = 'No',
            CSS_WS_DR_Contact__c = '73011',
            CSS_WS_Number_Unit__c = '111',
            CSS_WS_ESN__c = '11111111',
            CSS_WS_Factory_Distribution__c = 'No',
            CSS_WS_Model_Unit__c = 'DM1',
            CSS_WS_No_attention_reason__c = 'Otra',
            CSS_WS_Attention_Dealer__c = '54321',
            CSS_WS_Attention_DR__c = '54321',
            CSS_WS_OEM__c = 'No',
            CSS_WS_Regional_Distributor__c = '54321',
            CSS_WS_Special_Delivery__c = 'No',
            CSS_WS_Status__c ='Draft');
        
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(NoAvailability); 
        CSS_WS_NoAvailabilityController controller = new CSS_WS_NoAvailabilityController(standardController);   
        controller.getnaAttentionDRSelectList();
        controller.getnaAttentionDealersSelectList();
        Test.stopTest();
    }
        
    Public Static TestMethod Void testMethodIncompleteESN(){
        PageReference pageRef = Page.CSS_WS_NoAvailability_Form;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_No_Availability__c NoAvailability = new CSS_WS_No_Availability__c(
            CSS_WS_Authorizer__c = null,
            CSS_WS_Brand_Unit__c = 'A C INDUSTRIES',
            CSS_WS_Client__c = 'Castores',
            CSS_WS_Comments__c = 'No comments',
            CSS_WS_Created_By_Display__c = 'No',
            CSS_WS_Creation_Date__c = Date.today(),
            CSS_WS_Dealer__c = '12345',
            CSS_WS_After_Sales_Engineer__c = 'No',
            CSS_WS_DR_Contact__c = '73011',
            CSS_WS_Number_Unit__c = '111',
            CSS_WS_ESN__c = 'ESN',
            CSS_WS_Factory_Distribution__c = 'No',
            CSS_WS_Model_Unit__c = 'DM1',
            CSS_WS_No_attention_reason__c = 'Otra',
            CSS_WS_Attention_Dealer__c = '54699',
            CSS_WS_Attention_DR__c = '73011',
            CSS_WS_OEM__c = 'No',
            CSS_WS_Regional_Distributor__c = '54734',
            CSS_WS_Special_Delivery__c = 'No',
            CSS_WS_Status__c = 'Draft');
    
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(NoAvailability); 
        CSS_WS_NoAvailabilityController controller = new CSS_WS_NoAvailabilityController(standardController);  
        controller.nagetESN();
        Test.stopTest();
    }
    
    Public Static TestMethod Void testMethodNullESN(){
        PageReference pageRef = Page.CSS_WS_NoAvailability_Form;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54743',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_No_Availability__c NoAvailability = new CSS_WS_No_Availability__c(
            CSS_WS_Authorizer__c = null,
            CSS_WS_Brand_Unit__c = 'A C INDUSTRIES',
            CSS_WS_Client__c = 'Castores',
            CSS_WS_Comments__c = 'No comments',
            CSS_WS_Created_By_Display__c = 'No',
            CSS_WS_Creation_Date__c = Date.today(),
            CSS_WS_Dealer__c = '12345',
            CSS_WS_After_Sales_Engineer__c = 'No',
            CSS_WS_DR_Contact__c = '73011',
            CSS_WS_Number_Unit__c = '111',
            CSS_WS_ESN__c = null,
            CSS_WS_Factory_Distribution__c = 'No',
            CSS_WS_Model_Unit__c = 'DM1',
            CSS_WS_No_attention_reason__c  = 'Otra',
            CSS_WS_Attention_Dealer__c = '54699',
            CSS_WS_Attention_DR__c = '73011',
            CSS_WS_OEM__c = 'No',
            CSS_WS_Regional_Distributor__c = '54743',
            CSS_WS_Special_Delivery__c = 'No',
            CSS_WS_Status__c = 'Draft');
        
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(NoAvailability); 
        CSS_WS_NoAvailabilityController controller = new CSS_WS_NoAvailabilityController(standardController);  
        controller.nagetESN();   
        Test.stopTest();
    }    
    
    Public Static TestMethod Void testMethodgetESN(){
        PageReference pageRef = Page.CSS_WS_NoAvailability_Form;
        Account SPDLTest = new Account(
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54743',
            Type = 'Dealer Account',
            Name = 'DUMMY DEALER',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO');
        insert SPDLTest;
        
        CSS_WS_No_Availability__c NoAvailability = new CSS_WS_No_Availability__c(
            CSS_WS_Authorizer__c = null,
            CSS_WS_Brand_Unit__c = 'A C INDUSTRIES',
            CSS_WS_Client__c = 'Castores',
            CSS_WS_Comments__c = 'No comments',
            CSS_WS_Created_By_Display__c = 'No',
            CSS_WS_Creation_Date__c = Date.today(),
            CSS_WS_Dealer__c = '12345',
            CSS_WS_After_Sales_Engineer__c = 'No',
            CSS_WS_DR_Contact__c = '73011',
            CSS_WS_Number_Unit__c = '111',
            CSS_WS_ESN__c = '11111111',
            CSS_WS_Factory_Distribution__c = 'No',
            CSS_WS_Model_Unit__c = 'DM1',
            CSS_WS_No_attention_reason__c = 'Otra',
            CSS_WS_Attention_Dealer__c = '54699',
            CSS_WS_Attention_DR__c = '73011',
            CSS_WS_OEM__c = 'No',
            CSS_WS_Regional_Distributor__c = '54743',
            CSS_WS_Special_Delivery__c = 'No',
            CSS_WS_Status__c = 'Draft');
            
        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController (NoAvailability); 
        CSS_WS_NoAvailabilityController controller = new CSS_WS_NoAvailabilityController(standardController);  
        Test.setCurrentPage(pageRef);
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());       
        controller.nagetESN();
        Test.stopTest();
    }   

    Public Static TestMethod Void testMethodgetSPListDR(){
        PageReference pageRef = Page.CSS_WS_NoAvailability_Form;
        CSS_WS_No_Availability__c NoAvailability = new CSS_WS_No_Availability__c(
            CSS_WS_Dealer__c ='12345',
            CSS_WS_Regional_Distributor__c = '12345');
        Database.insert(NoAvailability);
    
        Account account = new Account(
            Name = 'TestAccount',
            type = 'Distributor Account',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO',
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '12345');
        insert account;
                      
        Test.startTest();
        //System.runAs(user){
        ApexPages.StandardController standardController = new ApexPages.StandardController (NoAvailability); 
        CSS_WS_NoAvailabilityController controller = new CSS_WS_NoAvailabilityController(standardController);  
        Test.setCurrentPage(pageRef);
        controller.getSPList(); 
        controller.getRouter();
        //}
        Test.stopTest();
    }

    Public Static TestMethod Void testMethodgetSPListDealer(){
        PageReference pageRef = Page.CSS_WS_NoAvailability_Form;
        CSS_WS_No_Availability__c NoAvailability = new CSS_WS_No_Availability__c(
            CSS_WS_Dealer__c ='12345',
            CSS_WS_Regional_Distributor__c = '54734');
    
        Account account = new Account(
            Name = 'TestAccount2',
            type = 'Dealer Account',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'MEXICO',
            IAM_Service_Provider_Code__c = '12345',
            CSS_DBCode__c = '54734');
        insert account;
      
        //System.runAs(user){
        ApexPages.StandardController standardController = new ApexPages.StandardController(NoAvailability); 
        CSS_WS_NoAvailabilityController controller = new CSS_WS_NoAvailabilityController(standardController);  
        Test.setCurrentPage(pageRef);
        controller.getSPList(); 
        controller.getRouter();
        //} 
    }
}