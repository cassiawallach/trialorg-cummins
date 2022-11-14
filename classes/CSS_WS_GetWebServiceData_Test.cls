@isTest
private class CSS_WS_GetWebServiceData_Test {

    // Test for WS_GetAccountCoverage
    @isTest static void testGetAccountCoverage() {
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
        
        // List of incoming parameters for WS callout
        List<String> DATA = new String[13];
        DATA[0] = '33137149';  //esn
        DATA[1] = '37320';  //spcode
        DATA[2] = '01/05/2016';  //failure date
        DATA[3] = '120';  //failure point
        DATA[4] = 'Miles';  //failure measure
        DATA[5] = '130';  // engine application code
        DATA[6] = '1121';  //fault code
        DATA[7] = '01/05/2010';  //warranty start date
        DATA[8] = '1-89798987';  //campaign number
        DATA[9] = 'Y';  //new parts warranty flag
        DATA[10] = 'Y';  //recon parts warranty flag
        DATA[11] = 'Y';  //road relay warranty flag
        DATA[12] = '98';  // account code
        List<String> details = new String[1];
        details[0] = 'IR,TC';  //system code, component code
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetAccountCoverage obj = CSS_WS_GetWebServiceData.getAccountCoverage(DATA, details);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_GetEngineData
    @isTest static void testGetEngineData() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
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
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        String esn = '79384192';
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetEngineData obj = CSS_WS_GetWebServiceData.getEngineData(esn);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_GetCampaignData
    @isTest static void testGetCampaignData() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxCampData',
            ApplicationName__c = 'MxCampData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxCampData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        List<String> DATA = new String[2];
        DATA[0] = '79384192';  //esn
        DATA[1] = '12/07/2016';  //failure date
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetCampaignData obj = CSS_WS_GetWebServiceData.getCampaignData(DATA);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_ValidateMultiESN
    @isTest static void testValidateMultiESN() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxMultiESN',
            ApplicationName__c = 'MxMultiESN',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxMultiESN',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        String campaign_number = '456789';
        List<String> details = new String[3];
        details[0] = '79384192,12/07/2016';
        details[1] = '35089518,11/07/2016';
        details[2] = '79384290,10/06/2016';
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_ValidateMultiESN obj = CSS_WS_GetWebServiceData.validateMultiESN(campaign_number, details);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_GetSPData
    @isTest static void testGetSPData() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSPData',
            ApplicationName__c = 'MxSPData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSPData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthServ',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        List<String> DATA = new String[3];
        DATA[0] = '20593';  //spcode
        DATA[1] = 'ISX CM871';  //service model name
        DATA[2] = '12/07/2016';  //failure date
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetSPData obj = CSS_WS_GetWebServiceData.getSPData(DATA);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_GetSRTData
    @isTest static void testGetSRTData() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSRTData',
            ApplicationName__c = 'MxSRTData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        List<String> DATA = new String[3];
        DATA[0] = 'ISX CM871';  //service model name
        DATA[1] = '31';  //engine family code
        DATA[2] = 'C';  //access code
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetSRTData obj = CSS_WS_GetWebServiceData.getSRTData(DATA);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_GetSRTOverlap2
    @isTest static void testGetSRTOverlap2() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSRTOver2',
            ApplicationName__c = 'MxSRTOver2',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTOver2',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        String claim_number = 'MX00012317';
        List<Map<String,String>> details = new List<Map<String,String>>{};
        Map<String,String> detail = new Map<String,String>{};
        detail.put('StepId','StepId');
        detail.put('AccessCode','AccessCode');
        detail.put('Qty','Qty');
        details.add(detail);
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetSRTOverlap2 obj = CSS_WS_GetWebServiceData.getSRTOverlap2(claim_number, details);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.MessageIdentifier, 'S');
        Test.stopTest();
    }
    
    // Test for WS_GetSRTOverlap
    @isTest static void testGetSRTOverlap() {
        // List of incoming parameters for WS callout
        List<Map<String,String>> details = new List<Map<String,String>>{};
        Map<String,String> detail = new Map<String,String>{};
        detail.put('EngineFamilyCode','EngineFamilyCode');
        detail.put('SrtAccessCode','SrtAccessCode');
        detail.put('SrtCode','SrtCode');
        detail.put('SrtHours','SrtHours');
        detail.put('SrtQty','SrtQty');
        details.add(detail);
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetSRTOverlap obj = CSS_WS_GetWebServiceData.getSRTOverlap(details);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }

    
    // Test for WS_GetPartsData
    @isTest static void testGetPartsData() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxPrtsData',
            ApplicationName__c = 'MxPrtsData',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPrtsData',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        String part_number_short = 'FB05456';
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetPartsData obj = CSS_WS_GetWebServiceData.getPartsData(part_number_short);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_CreateStatementMX
    @isTest static void testCreateStatementMX() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxCreatStm',
            ApplicationName__c = 'MxCreatStm',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxCreatStm',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthWarr',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        Map<String, String> header = new Map<String,String>{};
        List<Map<String,String>> details = new List<Map<String,String>>{};
        header.put('InterfaceLineAttribute1','CSSMX-002');
        header.put('Amount',String.valueof(100));
        
        Map<String,String> detail = new Map<String,String>{};
        detail.put('Attribute1','PAGO GARANTIAS Linea: 1');
        detail.put('Description','PAGO GARANTIAS');
        detail.put('CustTrxTypeId','1018');
        detail.put('TermName','NET 30');
        detail.put('TermId','1000');
        detail.put('LineNumber','0');
        detail.put('InterfaceLineAttribute6',String.valueof(0));
        detail.put('InventoryItemId','85267');
        detail.put('BatchSourceName','Nota de credito importada Motores');
        detail.put('Amount',String.valueof(100 * -1));
        detail.put('OrigSystemBillCustomerId',String.valueof(54432));
        detail.put('OrigSystemBillAddressId',String.valueof(6707));
        detail.put('OrigSystemShipCustomerId',String.valueof(54432));
        detail.put('OrigSystemShipAddressId',String.valueof(6694));
        detail.put('UnitSellingPrice',String.valueof(100));
        detail.put('Quantity',String.valueof(-1));
        detail.put('OrigSystemSoldCustomerId',String.valueof(54432));
        detail.put(
            'TranslatedDescription',
                'Folio: CSSMX-MX0058516' +
                'Monto Partes: 25' +
                'Monto Mano de Obra: 25' +
                'Monto Otros Rec.: 25' +
                'Monto Viaje: 25'
        );
        details.add(detail);
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_CreateStatementMX obj = CSS_WS_GetWebServiceData.createStatementMX(header, details);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'success');
        Test.stopTest();
    }
    
    // Test for WS_GetRatesMX
    @isTest static void testGetCurrencyExchange() {
        // List of incoming parameters for WS callout
        List<String> DATA = new String[4];
        DATA[0] = 'data_1'; 
        DATA[1] = 'data_2'; 
        DATA[2] = 'data_3'; 
        DATA[3] = 'data_4'; 
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetCurrencyExchange obj = CSS_WS_GetWebServiceData.getCurrencyExchange(DATA);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'success');
        Test.stopTest();
    }
    
    // Test for WS_ODM_Validation_Header
    @isTest static void testGetODMValidationHeader() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxHeadVal',
            ApplicationName__c = 'MxHeadVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxHeadVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
            
        Test.startTest();    
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_ODM_Validation obj = CSS_WS_GetWebServiceData.getODMValidationHeader(header);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'OK');
        Test.stopTest();
    }
    
    // Test for WS_ODM_Validation_Failure
    @isTest static void testGetODMValidationFailure() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxFailVal',
            ApplicationName__c = 'MxFailVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxFailVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        
        //FAILURE       
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode');
        failureData.put('inShopCampaignFlag','inShopCampaignFlag');   
        failure.add(failureData);
        
        Test.startTest();              
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_ODM_Validation obj = CSS_WS_GetWebServiceData.getODMValidationFailure(header, failure);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'OK');
        Test.stopTest();
    }
    
    // Test for WS_ODM_Validation_Parts
    @isTest static void testGetODMValidationParts() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxPrtsVal',
            ApplicationName__c = 'MxPrtsVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPrtsVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        
        //FAILURE      
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode');  
        failureData.put('inShopCampaignFlag','inShopCampaignFlag'); 
        failure.add(failureData);
        
        //PARTS
        List<Map<String, String>> parts = new List<Map<String, String>> ();
        Map<String, String> partData = new Map<String,String>{};
        partData.put('partPrice','partPrice');
        partData.put('partId','partId');
        partData.put('partAllowedFlag','partAllowedFlag');
        parts.add(partData); 
        
        Test.startTest();          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_ODM_Validation obj = CSS_WS_GetWebServiceData.getODMValidationParts(header, failure, parts);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'OK');
        Test.stopTest();
    }
    
    // Test for WS_ODM_Validation_Travel
    @isTest static void testGetODMValidationTravel() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxTraVal',
            ApplicationName__c = 'MxTraVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxTraVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        
        //FAILURE      
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode');
        failureData.put('inShopCampaignFlag','inShopCampaignFlag');   
        failure.add(failureData);
        
        //TRAVEL
        List<Map<String, String>> travel = new List<Map<String, String>> ();
        Map<String, String> travelData = new Map<String,String>{};
        travelData.put('mealsCharges','mealsCharges');
        travelData.put('towingCharges','towingCharges');
        travelData.put('hours','hours');
        travelData.put('travelDistance','travelDistance');        
        travel.add(travelData);
        
        Test.startTest();                
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_ODM_Validation obj = CSS_WS_GetWebServiceData.getODMValidationTravel(header, failure, travel);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'OK');
        Test.stopTest();
    }

    // Test for WS_ODM_Validation_Other_Claimables
    @isTest static void testGetODMValidationClaimable() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxOCVal',
            ApplicationName__c = 'MxOCVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxOCVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        
        //FAILURE      
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode');
        failureData.put('inShopCampaignFlag','inShopCampaignFlag');   
        failure.add(failureData);
        
        //CLAIMABLE 
        List<Map<String, String>> claimable = new List<Map<String, String>> ();
        Map<String, String> ocData = new Map<String,String>{};
        ocData.put('Amount','Amount');
        ocData.put('details','details');
        ocData.put('item','item');
        claimable.add(ocData); 
        
        Test.startTest();                
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_ODM_Validation obj = CSS_WS_GetWebServiceData.getODMValidationClaimable(header, failure, claimable);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'OK');
        Test.stopTest();
    }

    // Test for WS_ODM_Validation_SRT
    @isTest static void testGetODMValidationSRT() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxSRTVal',
            ApplicationName__c = 'MxSRTVal',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxSRTVal',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        
        //FAILURE      
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode');  
        failureData.put('inShopCampaignFlag','inShopCampaignFlag'); 
        failure.add(failureData);
        
        //SRT
        List<Map<String, String>> srt= new List<Map<String, String>> ();
        Map<String, String> srtData = new Map<String,String>{};
        srtData.put('description','description');
        srtData.put('hours','hours');
        srtData.put('offsiteCheck','offsiteCheck');
        srtData.put('quantity','quantity');
        srtData.put('code','code');
        srtData.put('srtAllowedFlag','srtAllowedFlag');
        srt.add(srtData);    
        
        Test.startTest();            
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_ODM_Validation obj = CSS_WS_GetWebServiceData.getODMValidationSRT(header, failure, srt);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'OK');
        Test.stopTest();
    }
    
    // Test for WS_ODM_Validation_PRE-SUBMIT
    @isTest static void testGetODMValidationPreSubmit() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxPreSub',
            ApplicationName__c = 'MxPreSub',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPreSub',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        
        //FAILURE      
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode'); 
        failureData.put('inShopCampaignFlag','inShopCampaignFlag');  
        failure.add(failureData);
        
        //PARTS
        List<Map<String, String>> parts = new List<Map<String, String>> ();
        Map<String, String> partData = new Map<String,String>{};
        partData.put('partPrice','partPrice');
        partData.put('partId','partId');
        partData.put('partAllowedFlag','partAllowedFlag');
        parts.add(partData); 
        
        //TRAVEL
        List<Map<String, String>> travel = new List<Map<String, String>> ();
        Map<String, String> travelData = new Map<String,String>{};
        travelData.put('mealsCharges','mealsCharges');
        travelData.put('towingCharges','towingCharges');
        travelData.put('hours','hours');
        travelData.put('travelDistance','travelDistance');        
        travel.add(travelData);
        
        //CLAIMABLE 
        List<Map<String, String>> claimable = new List<Map<String, String>> ();
        Map<String, String> ocData = new Map<String,String>{};
        ocData.put('Amount','Amount');
        ocData.put('details','details');
        ocData.put('item','item');
        claimable.add(ocData); 
        
        //SRT
        List<Map<String, String>> srt= new List<Map<String, String>> ();
        Map<String, String> srtData = new Map<String,String>{};
        srtData.put('description','description');
        srtData.put('hours','hours');
        srtData.put('offsiteCheck','offsiteCheck');
        srtData.put('quantity','quantity');
        srtData.put('code','code');
        srtData.put('srtAllowedFlag','srtAllowedFlag');
        srt.add(srtData);
        
        Test.startTest();                      
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_ODM_PreSubmit obj = CSS_WS_GetWebServiceData.getODMValidationPreSubmit(header, failure, parts, travel, claimable, srt);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'OK');
        Test.stopTest();
    }
    
    // Test for WS_ClaimSubmission
    @isTest static void testGetClaimSubmission() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxClaimSub',
            ApplicationName__c = 'MxClaimSub',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxClaimSub',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for Request Creation
        Map<String, String> header = new Map<String,String>{};
        header.put('ServiceProviderCode','ServiceProviderCode');
        header.put('DistributorCode','DistributorCode');
        header.put('EngineSerialNumber','EngineSerialNumber');
        header.put('RONumber','RONumber');
        header.put('WarrantyStartDate','WarrantyStartDate');
        header.put('EngineApplicationCode','EngineApplicationCode');
        header.put('Manufacturer','Manufacturer');
        header.put('ModelSeries','ModelSeries');
        header.put('FirstName','');
        header.put('LastName','');
        header.put('BISFlag','BISFlag');
        header.put('MultiESNFlg','MultiESNFlg');
        header.put('CampaignNumber','CampaignNumber');
        header.put('NewPartsWarrantyFlg','NewPartsWarrantyFlg');
        header.put('ReConPartsWarrantyFlg','ReConPartsWarrantyFlg');
        header.put('RoadRelayWarrantyFlg','RoadRelayWarrantyFlg');
        header.put('FailureDate','FailureDate');
        header.put('FailurePoint','FailurePoint');
        header.put('FailureMeasure','FailureMeasure');
        header.put('MissionDisablingFlag','MissionDisablingFlag');
        header.put('CatastrophicFlag','CatastrophicFlag');
        header.put('CatastrophicFlag','CatastrophicFlag');
        header.put('ReplacementPart','ReplacementPart');
        header.put('WarrantyTrainedFlag','WarrantyTrainedFlag');
        header.put('DISDNumber','DISDNumber');
        header.put('CustomerName','CustomerName');
        header.put('ECMCalibAfter','ECMCalibAfter');
        header.put('ECMCalibBefore','ECMCalibBefore');
        header.put('ESNCount','ESNCount');
        header.put('TSRNumber','TSRNumber');
        header.put('PenaltyFlag','PenaltyFlag');
        header.put('DealerClaimNumber','DealerClaimNumber');
        header.put('manualAdjudicationFlag','');
        header.put('ClaimFiledDate','ClaimFiledDate');
        header.put('SPInShopLaborRate','SPInShopLaborRate');
        header.put('SPLaborRate','SPLaborRate');
        header.put('SPTravelRate','SPTravelRate');
        
        //COMPLAINTS
        List<String> complaints = new String[]{};
        complaints.add('ComplaintCode1'); //ComplaintCode
        complaints.add('ComplaintCode2');
        complaints.add('ComplaintCode3');
        
        List<String> promotionIds = new String[]{};
        promotionIds.add('PromotionID'); //PromotionID
                
        //MULTIESN
        List<Map<String, String>> multiESN = new List<Map<String, String>> ();

        Map<String, String> esnData = new Map<String,String>{};
        esnData.put('EngineSerialNumber','EngineSerialNumber');
        esnData.put('BISFlag','BISFlag');
        esnData.put('FailureDate','FailureDate');
        esnData.put('FailurePoint','FailurePoint');
        esnData.put('FailureMeasure','FailureMeasure');
        esnData.put('ECMCalibAfter','ECMCalibAfter');
        esnData.put('ECMCalibBefore','ECMCalibBefore');
        esnData.put('WarrantyStartDate','WarrantyStartDate');
        multiESN.add(esnData);  
               
        //NOTES
        List<Map<String, String>> notes = new List<Map<String, String>> ();
        Map<String, String> notesNarrative = new Map<String,String>{};
        notesNarrative.put('Note','Note');
        notesNarrative.put('NoteType','Narrative');
        notes.add(notesNarrative);
    
        //FAILURES         
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('SystemCode','SystemCode');
        failureData.put('ComponentCode','ComponentCode');
        failureData.put('FailMode','FailMode');
        failureData.put('AccountCode','AccountCode');
        failureData.put('PayCode','PayCode');
        failureData.put('CertificateNumber','CertificateNumber');
        failureData.put('CampaignNumber','CampaignNumber');
        failureData.put('PolicyFlag','PolicyFlag');
        failureData.put('WarrantyId','WarrantyId');
        failureData.put('ApproverCode','ApproverCode');
        failureData.put('CoverageType','CoverageType');
        failureData.put('CoveredLaborHours','CoveredLaborHours');
        failureData.put('CoveredMealsLodgingAmt','CoveredLaborHours');
        failureData.put('CoveredOCAmount','CoveredLaborHours');   
        failureData.put('CoveredPartsQuantity','CoveredLaborHours');
        failureData.put('CoveredTowingMiles','CoveredTowingMiles');
        failureData.put('CoveredTravelLabor','CoveredTravelLabor');
        failureData.put('CoveredTravelMiles','CoveredTravelMiles');
        failureData.put('DeductibleAmount','DeductibleAmount');
        failureData.put('AuthorizationNum','AuthorizationNum');
        failureData.put('CampaignLabourPrcnt','CampaignLabourPrcnt');
        failureData.put('CampaignOCPrcnt','CampaignOCPrcnt');
        failureData.put('CampaignPartsPrcnt','CampaignPartsPrcnt');
        failureData.put('CampaignTowingPrcnt','CampaignTowingPrcnt');
        failureData.put('CampaignTravelPrcnt','CampaignTravelPrcnt');
        failure.add(failureData);
        
        //CLAIMABLE 
        List<Map<String, String>> claimable = new List<Map<String, String>> ();
        Map<String, String> ocData = new Map<String,String>{};
        ocData.put('Item','Item');
        ocData.put('OtherClaimableDetails','OtherClaimableDetails');
        ocData.put('ClaimedReason','ClaimedReason');
        ocData.put('ClaimedAmount','ClaimedAmount');
        ocData.put('ClaimedAmount','ClaimedAmount');
        claimable.add(ocData); 
        
        //PARTS  
        List<Map<String, String>> parts = new List<Map<String, String>> ();
        Map<String, String> partData = new Map<String,String>{};
        partData.put('PartNumber','PartNumber');
        partData.put('QtyClaimed','QtyClaimed');
        partData.put('PartUnitPrice','PartUnitPrice');
        partData.put('PartPercentage','PartPercentage');
        partData.put('ReplacementReason','ReplacementReason');
        parts.add(partData); 
    
        //SRT  
        List<Map<String, String>> srt= new List<Map<String, String>> ();
        Map<String, String> srtData = new Map<String,String>{};
        srtData.put('SRTCode','SRTCode');
        srtData.put('SRTAccessCode','SRTAccessCode');
        srtData.put('SRTHours','SRTHours');
        srtData.put('SRTQty','SRTQty');
        srtData.put('SRTPrcnt','SRTPrcnt');
        srtData.put('OutOfChasis','OutOfChasis');
        srtData.put('OverlapHrs','OverlapHrs');
        srtData.put('Offiste','Offiste');
        srt.add(srtData);
        
        //TRAVEL 
        //Map<String, String> travel = new Map<String,String>{};
        List<Map<String, String>> travel= new List<Map<String, String>> ();
        Map<String, String> travelData = new Map<String,String>{};
        travelData.put('TravelType','TravelType');
        travelData.put('TravelMode','TravelMode');
        travelData.put('OtherModeDetails','OtherModeDetails');
        travelData.put('BaseFare','BaseFare');
        travelData.put('Hours','Hours');
        travelData.put('Distance','Distance');
        travelData.put('MealsAmount','MealsAmount');
        travelData.put('TowingAmount','TowingAmount');
        travelData.put('TravelType','TravelType');
        travel.add(travelData);
         
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_ClaimSubmission obj = CSS_WS_GetWebServiceData.getClaimSubmission(header, complaints, promotionIds, multiESN, notes, failure, claimable, parts, srt, travel);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_GetPartPrice
    @isTest static void testGetPartPrice() {        
        // List of incoming parameters for WS callout
        Map<String, String> partData = new Map<String,String>{};
        partData.put('PartNumber','12345');
        // Set mock callout class 
        //Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetPartPrice obj = CSS_WS_GetWebServiceData.getPartPrice(partData);
        // Verify mock response is not null
        System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        System.assertEquals(obj.Header.Status, 'Success');
    }
    
    // Test for WS_GetCSSDetails
    @isTest static void testGetCSSDetails() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxCssDet',
            ApplicationName__c = 'MxCssDet',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxCssDet',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        Map<String, String> Data = new Map<String,String>{};
        Data.put('IMSClaimNumber','12345'); //IMSClaimNumber
        Data.put('ClaimNumber','MX0020816'); //ClaimNumber
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetCSSDetails obj = CSS_WS_GetWebServiceData.getCSSDetails(Data);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_GetGSQFailure
    @isTest static void testGetGSQFailure() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxGsqFai',
            ApplicationName__c = 'MxGsqFai',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxGsqFai',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        Map<String, String> Data = new Map<String,String>{};
        Data.put('ServiceModelName','ISBE CM2150'); //ServiceModelName
        Data.put('LanguageCode','en'); //LanguageCode
        Data.put('EngineFamilyCode','31'); //EngineFamilyCode
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetGSQFailure obj = CSS_WS_GetWebServiceData.getGSQFailure(Data);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.MessageIdentifier, 'S');
        Test.stopTest();
    }
    
    // Test for WS_GetGSQSRT
    @isTest static void testGetGSQSRT() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxGsqSrt',
            ApplicationName__c = 'MxGsqSrt',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxGsqSrt',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        Map<String, String> Data = new Map<String,String>{};
        Data.put('EngineFamilyCode','31'); //EngineFamilyCode
        Data.put('SRTType','REP'); //SRTType
        Data.put('EquipmentID','EQ7742'); //EquipmentID
        Data.put('FailureID','F12000000'); //FailureID
        Data.put('ServiceModelName','ISBE CM2150'); //ServiceModelName
        Data.put('CSSJobId','MX2821719'); //CSSJobId
        Data.put('Timestamp','2019-04-25'); //Timestamp
        Data.put('EffectiveDateTime','2019-04-25'); //EffectiveDateTime
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetGSQSRT obj = CSS_WS_GetWebServiceData.getGSQSRT(Data);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_GetServiceModel
    @isTest static void testGetServiceModel() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxServMod',
            ApplicationName__c = 'MxServMod',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxServMod',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        Map<String, String> Data = new Map<String,String>{};
        Data.put('LastRunDate','2019-01-18'); //LastRunDate
        Data.put('LangCode','en'); //LangCode
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetServiceModel obj = CSS_WS_GetWebServiceData.getServiceModel(Data);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'SUCCESS');
        Test.stopTest();
    }
    
    // Test for WS_GetPartReturn
    @isTest static void testGetPartReturn() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxPartRet',
            ApplicationName__c = 'MxPartRet',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxPartRet',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        Map<String, String> header = new Map<String,String>{};
        List<Map<String,String>> details = new List<Map<String,String>>{};
        header.put('PSN','35347249');
        header.put('FAILDATE','2018-09-26');
        header.put('DISTICHANNEL','110');
        
        Map<String,String> detail = new Map<String,String>{};
        detail.put('TERRITORYCLASS','401');
        detail.put('PRODUCTFAMILY','35');
        detail.put('PARTNUMBER','528408300');
        detail.put('FAILCODE','THAC');
        detail.put('ACCOUNTCODE','65');
        details.add(detail);
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetPartReturn obj = CSS_WS_GetWebServiceData.getPartReturn(header, details);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_GetFailCodes
    @isTest static void testGetFailCodes() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxFailCod',
            ApplicationName__c = 'MxFailCod',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxFailCod',
            IsActive__c = True,
            Method_Type__c = 'GET',
            AuthEnv__c = 'MxAuthEngi',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for WS callout
        String LAST_PROCESSED_DATE = '2019-03-18';
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_GetFailCodes obj = CSS_WS_GetWebServiceData.getFailCodes(LAST_PROCESSED_DATE);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
    
    // Test for WS_ClaimReliability
    @isTest static void testGetClaimReliability() {
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        CSS_Integration_Details__c MxTestConnection1 = new CSS_Integration_Details__c(
            Name = 'MxClaimRel',
            ApplicationName__c = 'MxClaimRel',
            End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token/MxClaimRel',
            IsActive__c = True,
            Method_Type__c = 'POST',
            AuthEnv__c = 'MxAuthClai',
            Key__c =  EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('https://api-ue-devnf-aw-ex.cummins.com/cmi-engine'))),
            Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('~6_5~e.~8D19I0Sw7YSNtq2kiAgK5bA.w3'))),
            Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('400529c8-31be-4749-acfe-7549baa2fcb2')))
        );        
        insert MxTestConnection1; 
        
        // List of incoming parameters for Request Creation
        Map<String, String> header = new Map<String,String>{};
        header.put('operationCode','operationCode');
        header.put('distributorCode','distributorCode');
        header.put('claimNum','claimNum');
        header.put('claimYear','claimYear');
        header.put('reinstatementCode','reinstatementCode');
        header.put('engineSerialNum','engineSerialNum');
        header.put('programPaymentCode','programPaymentCode');
        header.put('programAccountCode','programAccountCode');
        header.put('authorizationNum','authorizationNum');
        header.put('claimDate','claimDate');
        header.put('materialsAmount','materialsAmount');
        header.put('repairLaborAmount','repairLaborAmount');
        header.put('otherExpenseAmount','otherExpenseAmount');
        header.put('engineMiles','engineMiles');
        header.put('engineKm','engineKm');
        header.put('engineHours','engineHours');
        header.put('failureDate','failureDate');
        header.put('failureSeverityCode','failureSeverityCode');
        header.put('dataToCalcSyscdCompcdFlcd','dataToCalcSyscdCompcdFlcd');
        header.put('claimCustomerName','claimCustomerName');
        header.put('claimCustomerAddress','claimCustomerAddress');
        header.put('deductibleAmount','deductibleAmount');
        header.put('laborHours','laborHours');
        header.put('travelLodgingAmount','travelLodgingAmount');
        header.put('claimSourceCode','claimSourceCode');
        header.put('paymentDate','paymentDate');
        header.put('dataToCalcPartNum','dataToCalcPartNum');
        header.put('taxAmount','taxAmount');
        header.put('markupAmount','markupAmount');
        header.put('beyondFactCharge','beyondFactCharge');
        header.put('netAmount','netAmount');
        header.put('engineCoverageGrpCode','engineCoverageGrpCode');
        header.put('engineUseCode','engineUseCode');
        header.put('serviceAreaCode','serviceAreaCode');
        header.put('cumminsAdminAmount','cumminsAdminAmount');
        header.put('claimRapidserveId','claimRapidserveId');
        header.put('travelLaborAmount','travelLaborAmount');
        header.put('travelToSiteAmount','travelToSiteAmount');
        header.put('undetailedPartsAmount','undetailedPartsAmount');
        header.put('dollarDifferAmount','dollarDifferAmount');
        header.put('creditStatement','creditStatement');
        header.put('claimStatusCode','claimStatusCode');
        header.put('dealerCode','dealerCode');
        header.put('equipManufac','equipManufac');
        header.put('equipModel','equipModel');
        header.put('equipConfig','equipConfig');
        header.put('accessCode','accessCode');
    
        //Failures        
        List<Map<String, String>> codes = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('dataToCalcSyscdCompcdFlcd','dataToCalcSyscdCompcdFlcd');
        failureData.put('netAmount','netAmount');
        codes.add(failureData);
        
        //Parts
        List<Map<String, String>> parts = new List<Map<String, String>> ();
        Map<String, String> partData = new Map<String,String>{};
        partData.put('distributorCode','distributorCode');
        partData.put('claimYear','claimYear');
        partData.put('claimNum','claimNum');
        partData.put('reinstatementCode','reinstatementCode');
        partData.put('engineSerialNum','engineSerialNum');
        partData.put('partNumType','partNumType');
        partData.put('partNum','partNum');
        partData.put('partDesc','partDesc');
        partData.put('partQty','partQty');
        partData.put('partAdjdPct','partAdjdPct');
        partData.put('partUnitPrice','partUnitPrice');
        partData.put('partExtdPrice','partExtdPrice');
        partData.put('taxStatusFlg','taxStatusFlg');
        partData.put('partStatusFlg','partStatusFlg');
        parts.add(partData); 
         
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        CSS_WS_J2A_ClaimReliability obj = CSS_WS_GetWebServiceData.getClaimReliability(header, codes, parts);
        // Verify mock response is not null
        //System.assertNotEquals(null,obj,'The callout returned a null response.');
        // Verify the received object contains fake values
        System.Debug (obj);
        //System.assertEquals(obj.Header.Status, 'Success');
        Test.stopTest();
    }
}