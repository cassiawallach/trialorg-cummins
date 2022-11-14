@IsTest  
Public Class CSS_WS_RescueController_Test{
    Public Static testMethod Void testMethodsLists(){
        PageReference pageRef = Page.CSS_WS_RescueFormat;
        CSS_WS_Engine_Application_Code__c EngineAppCode = new CSS_WS_Engine_Application_Code__c(
            Name = 'Examp1',
            Application_Code__c = 'AppCod',
            Application_Description__c = 'ExampleApp',
            Default_Measurement__c = '001',
            Automotive_Flag__c = 'N',
            Marine_Flag__c = 'N');  
        insert EngineAppCode;
        
        CSS_WS_Failure_Master__c FailureMaster = new CSS_WS_Failure_Master__c(
            Name = 'Examp1',
            Engine_System_Code__c = 'CH',
            Engine_System_Code_Description__c = 'SystemCodeExample',
            Engine_Family_Code__c = 'EX',
            Engine_Component_Code__c = 'R1',
            Engine_Component_Code_Description__c = 'R2',
            CSS_WS_Unique_Id__c = 'EX-CH-R1');
        insert FailureMaster;
        
        CSS_WS_Fail_Mode_Catalog__c FailModeCatalog = new CSS_WS_Fail_Mode_Catalog__c(
            Name = 'Examp1',
            CSS_WS_Name__c = 'FailModeNameExample',
            CSS_WS_FailMode__c = 'CA',
            CSS_WS_Active__c = 'Y');
        insert FailModeCatalog;
        
        CSS_WS_Make_And_Model__c AccsCodeMasterCta = new CSS_WS_Make_And_Model__c(
            Name = 'Examp1',
            CSS_WS_Make__c = 'Sony',
            CSS_WS_Engine_Family_Code__c = 'EX',
            CSS_WS_Model__c = 'XperiaZL',
            CSS_WS_Unique_Id__c = '123-abc-01');
        insert AccsCodeMasterCta;
        
        CSS_WS_Make_And_Model__c AccsCodeMasterCtaSeries = new CSS_WS_Make_And_Model__c(
            Name = 'Examp2',
            CSS_WS_Make__c = 'Sony',
            CSS_WS_Engine_Family_Code__c = 'EX',
            CSS_WS_Model__c = 'XperiaXZ',
            CSS_WS_Unique_Id__c = '123-abc-02');
        insert AccsCodeMasterCtaSeries;
        
        Account DRTest = new Account(
            IAM_Service_Provider_Code__c = '12346',
            CSS_DBCode__c = '12346',
            Type = 'Distributor Account',
            Name = 'Dummy DR',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert DRTest;
        
        CSS_WS_Rescue__c rescue = new CSS_WS_Rescue__c(
            CSS_WS_Engine_Family_Code__c = 'EX',
            CSS_WS_Engine_Serial_Number__c = '10000000',
            CSS_WS_Manufacturer__c = 'Sony',
            CSS_WS_Model_Series__c = 'XperiaZL',
            CSS_WS_Service_Provider_DR__c = '12346');
        insert rescue;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxAccCov',
            ApplicationName__c = 'MxAccCov',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxAccCov',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthWarr',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('12345'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('44D61a8cfd674608AD155831cEA89Bdc'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('f0036e9ab48d4f37a16a6e7fa2566e85')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxAuthWarr',
            ApplicationName__c = 'MxAuthWarr',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2; 
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxEngData',
            ApplicationName__c = 'MxEngData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxEngData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(rescue);
        CSS_WS_RescueController controller = new CSS_WS_RescueController(standardController);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());  
        controller.getEngineApplications();//Method getEngineApplications()
        
        controller.mapEngineApplication('');//Catch in method mapEngineApplication()
        controller.mapEngineApplication('ExampleApp');//Try in method mapEngineApplication()
        
        List<selectOption> OptionsFailure = new List<selectOption>();
        OptionsFailure = controller.GetFailureList;//Method GetFailureList()

        List<selectOption> OptionsFailureMode = new List<selectOption>();
        OptionsFailureMode = controller.GetFailureModeList;//Method GetFailureModeList()     
        
        controller.getManufacturerSelectList();//When manufacturerDis != 0
        controller.manufacturerDis = 1;
        rescue.CSS_WS_Manufacturer__c = 'Sony';
        upsert rescue;
        controller.getManufacturerSelectList();//When manufacturerDis = 1 and the CSS_WS_Manufacturer__c = CSS_WS_Equip_Manufacturer__c
             
        rescue.CSS_WS_Manufacturer__c = 'Sony';
        rescue.CSS_WS_Model_Series__c = 'XperiaZL';
        upsert rescue;
        controller.getModelSeriesSelectList();//Method getModelSeriesSelectList()
        
        controller.getDealersSelectList();
        
        rescue.CSS_WS_Engine_System__c = 'CH&CA';
        controller.SetComponentList();
        Test.stopTest();
    }
    
    Public Static testMethod Void testMethodsPageReferencesSave(){
        PageReference pageRef = Page.CSS_WS_RescueFormat;
        CSS_WS_Engine_Application_Code__c EngineAppCode = new CSS_WS_Engine_Application_Code__c(
            Name = 'Examp1',
            Application_Code__c = 'AppCod',
            Application_Description__c = 'ExampleApp',
            Default_Measurement__c = '001',
            Automotive_Flag__c = 'N',
            Marine_Flag__c = 'N');  
        
        Account DRTest = new Account(
            IAM_Service_Provider_Code__c = '12346',
            CSS_DBCode__c = '12346',
            Type = 'Distributor Account',
            Name = 'Dummy DR',
            CMI_Account_Status__c = 'Active',
            BillingCountry = 'Mexico');
        insert DRTest;
        
        Account Cliente = new Account(
            IAM_Service_Provider_Code__c = '23456',
            CSS_DBCode__c = '23456',
            Type = 'Customer',
            Name = 'Juan Carlos');
        insert Cliente;
        
        CSS_WS_Make_And_Model__c AccsCodeMasterCta = new CSS_WS_Make_And_Model__c(
            Name = 'Examp2',
            CSS_WS_Make__c = 'Sony',
            CSS_WS_Engine_Family_Code__c = 'EX',
            CSS_WS_Model__c = 'XperiaXZ',
            CSS_WS_Unique_Id__c = '123-abc-03');
        insert AccsCodeMasterCta;
        
        CSS_WS_Rescue__c rescue = new CSS_WS_Rescue__c(
            CSS_WS_Engine_Family_Code__c = 'EX',
            CSS_WS_Engine_Serial_Number__c = '10000000',
            CSS_WS_Manufacturer__c = 'Sony',
            CSS_WS_Model_Series__c = 'XperiaXZ',
            CSS_WS_Service_Provider_DR__c = '12346',
            CSS_WS_Engine_Application_Code__c = 'Examp1');
        insert rescue;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxAccCov',
            ApplicationName__c = 'MxAccCov',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxAccCov',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthWarr',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('12345'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('44D61a8cfd674608AD155831cEA89Bdc'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('f0036e9ab48d4f37a16a6e7fa2566e85')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxAuthWarr',
            ApplicationName__c = 'MxAuthWarr',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2; 
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxEngData',
            ApplicationName__c = 'MxEngData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxEngData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(rescue);
        CSS_WS_RescueController controller = new CSS_WS_RescueController(standardController);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        Approval.Lock(rescue.id);//Catch in all the methods
        //controller.saveGeneralData();
        //controller.saveGeneralDataDisabled();
        //controller.saveBitacora();
        Approval.Unlock(rescue.id);
        
        controller.reloadEngineApplication();//Catch in method reloadEngineApplication()
        insert EngineAppCode;
        controller.reloadEngineApplication();//Try in method reloadEngineApplication()
        
        controller.saveGeneralData();//Try and Return null in method saveGeneralData() 
        rescue.CSS_WS_Service_Provider_Dealer__c = '12346';
        rescue.CSS_WS_CoordinatedBy__c = 'DR';
        rescue.CSS_WS_Service_Model__c = 'Xperia';
        rescue.CSS_WS_Engine_Application__c = 'Automotive';
        rescue.CSS_WS_Customer_Name_Internal__c = Cliente.id;
        rescue.CSS_WS_Failure_Point_Quantity__c = '12000';
        rescue.CSS_WS_ServiceRequest__c = system.today();
        rescue.CSS_WS_Failure_Measure__c = 'KM';
        rescue.CSS_WS_Engine_System__c = 'XL';
        rescue.CSS_WS_Component__c = 'Celphone';
        rescue.CSS_WS_Failure_Mode__c = 'CA';
        rescue.CSS_WS_Before_In_Service__c = false;   
        rescue.CSS_WS_Warranty_Start_Date__c = system.today();
        rescue.CSS_WS_Years_In_Service__c = 2;
        rescue.CSS_WS_Charged_To__c = 'Cliente';
        upsert rescue;
        controller.saveGeneralData();//Try and Return rescuePage in method saveGeneralData()
        
        controller.saveGeneralDataDisabled();
        
        controller.saveBitacora();
        rescue.CSS_WS_ServiceCoordination__c = system.today();
        rescue.CSS_WS_ExpertOutput__c = system.today();
        rescue.CSS_WS_RepairEnding__c = system.today();
        rescue.CSS_WS_RepairEnding__c = system.today();
        rescue.CSS_WS_Returns__c = 1;
        rescue.CSS_WS_TravelKmRoundTrip__c = 12;
        rescue.CSS_WS_TravelHoursRoundTrip__c = 12;
        controller.saveBitacora();
        
        controller.saveMinimumFare();
        rescue.Towing_Flag__c = true;
        rescue.CSS_WS_Towing_Amount_MXN__c = -1;
        rescue.CSS_WS_Crane_Justification__c = null;
        upsert rescue;
        controller.saveMinimumFare();
        rescue.CSS_WS_Crane_Justification__c = 'JustExam1';
        rescue.CSS_WS_Authorizer__c = null;
        upsert rescue;
        controller.saveMinimumFare();
        rescue.CSS_WS_Authorizer__c = 'AuthExam1';
        rescue.CSS_WS_SignalTime__c = null;
        upsert rescue;
        controller.saveMinimumFare();
        rescue.CSS_WS_SignalTime__c = 'Day';
        rescue.CSS_WS_SignalBy__c = 'Policy';
        rescue.CSS_WS_Towing_Amount_MXN__c = null;
        upsert rescue;
        controller.saveMinimumFare();
        
        CSS_WS_Travel_Prices__c TravelPrice1 = new CSS_WS_Travel_Prices__c(
            Name = 'Tipo Cambio',
            Local_Rate__c = 10);
        insert TravelPrice1;
        CSS_WS_Travel_Prices__c TravelPrice2 = new CSS_WS_Travel_Prices__c(
            Name = 'KM Adicional',
            Local_Rate__c = 10);
        insert TravelPrice2;
        CSS_WS_Travel_Prices__c TravelPrice3 = new CSS_WS_Travel_Prices__c(
            Name = 'Banderazo Nocturno',
            Local_Rate__c = 10);
        insert TravelPrice3;
        CSS_WS_Travel_Prices__c TravelPrice4 = new CSS_WS_Travel_Prices__c(
            Name = 'HR Adicional',
            Local_Rate__c = 10);
        insert TravelPrice4;
        CSS_WS_Travel_Prices__c TravelPrice5 = new CSS_WS_Travel_Prices__c(
            Name = 'Banderazo Diurno',
            Local_Rate__c = 10);
        insert TravelPrice5;
        
        controller.saveRescue();//Method saveRescue() Return null
        rescue.CSS_WS_Towing_Amount_MXN__c = 12;
        rescue.CSS_WS_FailurePlace__c = '12';
        rescue.CSS_WS_RoadSection__c = '12';
        rescue.CSS_WS_ReportedFailure__c = 'Fail reported';
        rescue.CSS_WS_TechnicalCause__c = 'Tec cause';
        rescue.CSS_WS_TecnhicalCorrection__c = 'Tec correction';
        rescue.CSS_WS_FailureIsProductProblem__c = 'Yes';
        rescue.CSS_WS_FailureRelatedTo__c = 'Baterías';
        rescue.CSS_WS_OtherObservation__c = 'Other';
        rescue.CSS_WS_TechnicianPromotion__c = 'No Promotion Id';
        rescue.CSS_WS_ReasonNoTargetTime__c = 'El camino estaba accidentado';
        rescue.CSS_WS_MinimumFare__c = 11;
        rescue.CSS_WS_Returns__c = 10;
        rescue.CSS_WS_TravelKmRoundTripPolicy__c = 120;
        rescue.CSS_WS_TravelHoursRoundTripPolicy__c = 12;
        controller.KmsPrice = 10;
        controller.Hrsprice = 10;
        upsert rescue;
        controller.saveRescue();//Method saveRescue() Return rescuePage
        Test.stopTest();
    }
    
    Public Static testMethod Void testMethodsPageReferencesBack(){
        PageReference pageRef = Page.CSS_WS_RescueFormat;

        CSS_WS_Rescue__c Rescue = new CSS_WS_Rescue__c();

        ApexPages.StandardController standardController = new ApexPages.StandardController(rescue);
        CSS_WS_RescueController controller = new CSS_WS_RescueController(standardController);
        
        Test.startTest();//Catch for all the methods except ReviewRescue()
        controller.backBitacora();
        controller.backMinimumFare();
        controller.backServiceDetail();
        controller.ReviewRescue();
        
        Rescue.CSS_WS_Engine_Family_Code__c = '40';
        upsert Rescue;
        controller.wId = Rescue.Id;
        controller.backBitacora();
        controller.backMinimumFare();
        controller.backServiceDetail();
        controller.ReviewRescue();        
        Test.stopTest();
    }
    
    Public Static testMethod Void testMethodsPageReferencesOthers(){
        PageReference pageRef = Page.CSS_WS_RescueFormat;
        CSS_WS_Rescue__c Rescue = new CSS_WS_Rescue__c();
        insert Rescue;
        
        CSS_WS_Rescue_Parts__c ResParts =  new CSS_WS_Rescue_Parts__c(
            CSS_WS_Part_ID__c = '006439500',
            CSS_WS_Quantity__c = 2,
            CSS_WS_Description__c = 'GSK,COV',
            Rescue_Id__c = Rescue.Id);
        insert ResParts;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxAccCov',
            ApplicationName__c = 'MxAccCov',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxAccCov',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthWarr',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('12345'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('44D61a8cfd674608AD155831cEA89Bdc'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('f0036e9ab48d4f37a16a6e7fa2566e85')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxAuthWarr',
            ApplicationName__c = 'MxAuthWarr',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2; 
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxEngData',
            ApplicationName__c = 'MxEngData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxEngData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(rescue);
        CSS_WS_RescueController controller = new CSS_WS_RescueController(standardController);
        
        Test.startTest();
        Controller.PartCounter = 0;//Add a normal part
        Controller.partNumber = '006439500';
        Controller.quantity = 5; 
        Controller.description = 'GSK,COV';
        Controller.AddNewPart();
        Controller.SavePartsGrids();
        Controller.PartCounter = 1;//Ads part without partNumber
        Controller.partNumber = ' ';
        Controller.quantity = 5; 
        Controller.description = 'GSR,COB';
        Controller.AddNewPart();
        Controller.SavePartsGrids();
        Controller.PartCounter = 2;//Add part with quantity 26, this make error
        Controller.partNumber = '006439510';
        Controller.quantity = 26; 
        Controller.description = 'GSR,COB';
        Controller.AddNewPart();
        Controller.SavePartsGrids();
        Controller.PartCounter = 2;//Add part with quantity -1, this make error
        Controller.partNumber = '006439510';
        Controller.quantity = -1; 
        Controller.description = 'GSR,COB';
        Controller.AddNewPart();
        Controller.SavePartsGrids();
        
        Controller.GetPartsInfo();//There are not part to update
        Controller.PartToUpdate = 1;
        Controller.GetPartsInfo();//Web service response is null        
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        Controller.GetPartsInfo();//
        
        Controller.getRouter();//The rescue is unlock
        Approval.Lock(Rescue);
        Controller.getRouter();//The rescue is lock
        Test.stopTest();
    }//Check

    Public Static testMethod Void testMethodsPageReferencesVoidRulesAndChangesFields(){
        PageReference pageRef = Page.CSS_WS_RescueFormat;
        CSS_WS_Rescue__c Rescue = new CSS_WS_Rescue__c(
            CSS_WS_SignalBy__c = 'Customer',    
            CSS_WS_Towing_Amount_MXN__c = 10,
            CSS_WS_Engine_Serial_Number__c = '10000000',
            CSS_WS_Years_In_Service__c = 4, 
            CSS_WS_Engine_Application_Code__c = '130',
            CSS_WS_Failure_Point_Quantity__c = '-1',
            CSS_WS_Warranty_Start_Date__c = (system.today().addDays(1)),
            CSS_WS_Build_Date__c = (system.today()).addDays(5),
            CSS_WS_ServiceRequest__c = system.today());
        insert Rescue;
        
        CSS_WS_Warranty__c Claim =  new CSS_WS_Warranty__c();
        insert Claim;
        
        CSS_WS_Rescue_Parts__c ResParts =  new CSS_WS_Rescue_Parts__c(
            CSS_WS_Part_ID__c = '006439500',
            CSS_WS_Quantity__c = 2,
            CSS_WS_Description__c = 'GSK,COV',
            Rescue_Id__c = Rescue.Id);
        insert ResParts;
        
        CSS_WS_Warranty_Parts__c WarParts = new CSS_WS_Warranty_Parts__c(
            CSS_WS_WarrantyID__c = Claim.Id);
        insert WarParts;
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(rescue);
        CSS_WS_RescueController controller = new CSS_WS_RescueController(standardController);
        
        Test.startTest();
        Controller.yearsInService();//Service Request cannot be lesser than Warranty Start Date
        Controller.yearsInService();//this.Rescue.CSS_WS_Years_In_Service__c = null 
        Rescue.CSS_WS_Warranty_Start_Date__c = system.today();
        Rescue.CSS_WS_ServiceRequest__c = (system.today().AddDays(1));
        Rescue.CSS_WS_Build_Date__c = system.today();
        Controller.yearsInService();
        
        Controller.EmptyValues(WarParts);
        
        Controller.PartList.add(new CSS_WS_RescueController.CreateNewPart(1, 'Lorem', 1, '112', rescue.Id));
        Controller.countParts();

        Controller.GetLunchAmount();
        Controller.GetLodgingAmount();
        Controller.GetTowingAmount();
        Controller.RR35RR36RR37();
        
        Controller.RR02RR04();
        Rescue.CSS_WS_Years_In_Service__c = 5;
        Controller.RR02RR04();

        Controller.R04067_SF17();       
        Test.stopTest();
    }    
    
    Public Static testMethod Void testMethodsGetESNandgetCoverageInfo(){
        PageReference pageRef = Page.CSS_WS_RescueFormat;
        CSS_WS_Rescue__c Rescue = new CSS_WS_Rescue__c();
        insert Rescue;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxAccCov',
            ApplicationName__c = 'MxAccCov',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxAccCov',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthWarr',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('12345'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('44D61a8cfd674608AD155831cEA89Bdc'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('f0036e9ab48d4f37a16a6e7fa2566e85')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxAuthWarr',
            ApplicationName__c = 'MxAuthWarr',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2; 
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxEngData',
            ApplicationName__c = 'MxEngData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxEngData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
        
        ApexPages.StandardController standardController = new ApexPages.StandardController(Rescue);
        CSS_WS_RescueController controller = new CSS_WS_RescueController(standardController);
        
        Test.startTest();
        Controller.GetESN();
        Rescue.CSS_WS_Engine_Serial_Number__c = '12345678';
        Rescue.CSS_WS_Before_In_Service__c = true;
        Controller.GetESN();
        Rescue.CSS_WS_Engine_Serial_Number__c = '12345678';
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());  
        Controller.GetESN();
        
        Rescue.CSS_WS_Engine_System__c = 'CH&PH';
        Rescue.CSS_WS_Component__c =  'CH&PH';
        Rescue.CSS_WS_Service_Provider_Dealer__c = '12345';
        Rescue.CSS_WS_ServiceRequest__c = system.today();
        Rescue.CSS_WS_Failure_Point_Quantity__c = '10';
        Rescue.CSS_WS_Failure_Measure__c = 'KM';
        Rescue.CSS_WS_Engine_Application_Code__c = 'AUTOMOTIVE';
        Rescue.CSS_WS_Warranty_Start_Date__c = system.today();
        Controller.getCoverageInfo();
        Rescue.CSS_WS_Engine_Serial_Number__c = '60345678';
        Controller.getCoverageInfo();
        Test.stopTest();
    }
   
    Public Static testMethod Void testMethodsOtherVoid(){
        PageReference pageRef = Page.CSS_WS_RescueFormat;  
        CSS_WS_Rescue__c Rescue = new CSS_WS_Rescue__c(
            CSS_WS_Service_Provider_DR__c = '47591',
            CSS_WS_Service_Provider_Dealer__c = '4759');
        insert Rescue;
        
        CSS_WS_Rescue_Parts__c ResParts =  new CSS_WS_Rescue_Parts__c(
            CSS_WS_Part_ID__c = '006439500',
            CSS_WS_Quantity__c = 2,
            CSS_WS_Description__c = 'GSK,COV',
            Rescue_Id__c = Rescue.Id);
        insert ResParts;
        
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxAccCov',
            ApplicationName__c = 'MxAccCov',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxAccCov',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthWarr',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('12345'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('44D61a8cfd674608AD155831cEA89Bdc'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('f0036e9ab48d4f37a16a6e7fa2566e85')))
        );        
        insert MxTestConnection1; 
        
        CSS_Integration_Details__c MxTestConnection2 = new CSS_Integration_Details__c(
            Name = 'MxAuthWarr',
            ApplicationName__c = 'MxAuthWarr',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = '',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection2; 
        
        CSS_Integration_Details__c MxTestConnection3 = new CSS_Integration_Details__c(
            Name = 'MxEngData',
            ApplicationName__c = 'MxEngData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxEngData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection3; 
    
        ApexPages.StandardController standardController = new ApexPages.StandardController(Rescue);
        CSS_WS_RescueController controller = new CSS_WS_RescueController(standardController);
        
        Test.startTest();
        controller.UpdateMap(ResParts, 1);
        controller.UpdateMap(ResParts, 2);
        
        controller.EmptyValues(ResParts);
        
        controller.PartList.add(new CSS_WS_RescueController.CreateNewPart(1,'Lorem1',1,'112',rescue.Id));
        controller.PartList.add(new CSS_WS_RescueController.CreateNewPart(2,'Lorem2',2,'113',rescue.Id));
        controller.PartToDelete = 1;
        controller.DeletePart();
        
        controller.addRow();
        
        controller.WhoCaptureFunction();
        rescue.CSS_WS_Service_Provider_Dealer__c = '47591';
        controller.WhoCaptureFunction();
        rescue.CSS_WS_Service_Provider_DR__c = '47592';
        controller.WhoCaptureFunction();
        
        rescue.CSS_WS_Service_Model__c = 'IXS-190';
        rescue.CSS_WS_ServiceRequest__c = system.today();
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        controller.getPromotionIDs();
        
        rescue.CSS_WS_TechnicianPromotion__c = 'B982732';
        controller.PromotionIDInformation();
        
        rescue.CSS_WS_FailureIsProductProblem__c = 'No';
        controller.clearHiddenFields();
        
        rescue.CSS_WS_Responsable__c = 'Example';
        controller.CheckResponsableValue();
        
        rescue.CSS_WS_ReasonNoTargetTime__c = 'Example;For;This;Method';
        controller.ReasonNoTargetTimeSelectedValues();
        
        rescue.CSS_WS_Repair__c = true;
        controller.selectRepair();
        
        rescue.CSS_WS_Exit__c = true;
        controller.selectExit();
        
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        Attachment attach=new Attachment(
            Name = 'Unit Test Attachment',
            Body = bodyBlob,
            ParentId = rescue.id);
        insert attach;
        controller.rescueSelectedRowId = attach.id;
        controller.rescue_attachment_list.add(attach);
        controller.rescueDeleteAttachmentRow();
        
        rescue.CSS_WS_Years_In_Service__c = 2;
        controller.GetSignalBy();
        Rescue.CSS_WS_AccCoverage__c = true;
        Rescue.CSS_WS_CoveredTravelLabor__c = 2;
        Rescue.CSS_WS_TravelHoursRoundTripPolicy__c = 4;
        controller.GetSignalBy();
        Rescue.CSS_WS_CoveredTravelLabor__c = 4;
        Rescue.CSS_WS_TravelHoursRoundTripPolicy__c = 2;
        controller.GetSignalBy();
        
        rescue.CSS_WS_TravelKmRoundTrip__c = 0;
        controller.GetKMRoundtravelPolicy();
        rescue.CSS_WS_TravelKmRoundTrip__c = 1;
        rescue.CSS_WS_Charged_To__c = 'Cliente';
        controller.GetKMRoundtravelPolicy();
        rescue.CSS_WS_Charged_To__c = 'NoCliente';
        controller.GetKMRoundtravelPolicy();
        
        rescue.CSS_WS_TravelHoursRoundTrip__c = 0;
        controller.GetHRRoundTravelPolicy();
        rescue.CSS_WS_TravelHoursRoundTrip__c = 1;
        rescue.CSS_WS_Charged_To__c = 'Cliente';
        controller.GetHRRoundTravelPolicy();
        rescue.CSS_WS_Charged_To__c = 'NoCliente';
        controller.GetHRRoundTravelPolicy();
        Test.stopTest();
    }

    Public Static testMethod Void testMethodsBooleanMethods(){
        PageReference pageRef = Page.CSS_WS_RescueFormat;
        CSS_WS_Rescue__c Rescue = new CSS_WS_Rescue__c(
            CSS_WS_Service_Provider_DR__c = '47591',
            CSS_WS_Service_Provider_Dealer__c = '4759');
        insert Rescue;
        
        Holidays__c Holi = new Holidays__c(
            Name = 'TestDay',
            Holiday_Date__c = system.today());
        insert Holi;
    
        ApexPages.StandardController standardController = new ApexPages.StandardController(Rescue);
        CSS_WS_RescueController controller = new CSS_WS_RescueController(standardController);
        
        Test.startTest();
        controller.checkifItisWorkingDay(system.today());
        Holi.Holiday_Date__c = system.today().addDays(6);
        upsert Holi;
        controller.checkifItisWorkingDay(system.today());
        
        controller.ValidateBitacoraFields();//Service request can not be empty
        rescue.CSS_WS_ServiceRequest__c = system.today();
        controller.ValidateBitacoraFields();//Service Coordination Date cannot be empty
        rescue.CSS_WS_ServiceCoordination__c = system.today();
        controller.ValidateBitacoraFields();//Technician Completion Date cannot be empty
        rescue.CSS_WS_ExpertOutput__c = system.today();
        controller.ValidateBitacoraFields();//Repair Completion Date cannot be empty
        rescue.CSS_WS_RepairEnding__c = system.today();
        controller.ValidateBitacoraFields();//Laps value cannot be empty or lower than 1
        rescue.CSS_WS_Returns__c = 1;
        controller.ValidateBitacoraFields();//Travel KM Round Trip value cannot be empty
        rescue.CSS_WS_TravelKmRoundTrip__c = 10;
        controller.ValidateBitacoraFields();//Travel Hours Round Trip value cannot be empty
        rescue.CSS_WS_TravelHoursRoundTrip__c = 10;
        controller.ValidateBitacoraFields();//Return true
        rescue.CSS_WS_ServiceRequest__c = system.today().addDays(1);
        rescue.CSS_WS_ServiceCoordination__c = system.today();
        controller.ValidateBitacoraFields();//Service Coordination Date must be greater than Service Request Date
        rescue.CSS_WS_ServiceRequest__c = system.today();
        rescue.CSS_WS_ServiceCoordination__c = system.today().addDays(1);
        rescue.CSS_WS_RepairEnding__c = system.today();
        controller.ValidateBitacoraFields();//Leave Shop Date must be greater than Service Coordination Date
        rescue.CSS_WS_ServiceCoordination__c = system.today();
        rescue.CSS_WS_ExpertOutput__c = system.today().addDays(1);
        controller.ValidateBitacoraFields();//Repair Completion Date must be greater then Leave Shop Date
        //rescue.CSS_WS_ExpertOutput__c = system.today().addDays(1);
        //rescue.CSS_WS_ServiceCoordination__c = system.today();
        //controller.ValidateBitacoraFields();//Technician Completion Date is not valid
        rescue.CSS_WS_ExpertOutput__c = system.today();
        rescue.CSS_WS_TravelHoursRoundTripPolicy__c = 10;
        rescue.CSS_WS_TravelHoursRoundTrip__c = 9;
        controller.ValidateBitacoraFields();//Approved travel KM are greather than requested travel KM
        rescue.CSS_WS_TravelHoursRoundTripPolicy__c = 8;
        rescue.CSS_WS_TravelKmRoundTripPolicy__c = 10;
        rescue.CSS_WS_TravelKmRoundTrip__c = 9;
        controller.ValidateBitacoraFields();//Approved travel KM are greather than requested travel KM
        
        controller.UpdatePart();
        Test.stopTest();
    }
}