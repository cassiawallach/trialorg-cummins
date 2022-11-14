@istest
class CSS_WS_CreateStmx_Test {

    static testmethod void test() {
    
    Account SPDLTest = new Account(
        IAM_Service_Provider_Code__c = '54919',
        CSS_DBCode__c = '40711',
        Type = 'Dealer Account',
        Name = 'DUMMY DEALER',
        CMI_Account_Status__c = 'Active',
        BillingCountry = 'Mexico',
        CSS_WS_Address_ID_Bill__c = 123
    );
    insert SPDLTest;
        
    Account SPDLTestPaccar = new Account(
        IAM_Service_Provider_Code__c = '54699',
        CSS_DBCode__c = '54699',
        Type = 'Dealer Account',
        Name = 'DUMMY DEALER',
        CMI_Account_Status__c = 'Active',
        BillingCountry = 'Mexico',
        CSS_WS_Address_ID_Bill__c = 123
    );
    insert SPDLTestPaccar;
    
    Account SPDRTest = new Account(
        IAM_Service_Provider_Code__c = '40711',
        CSS_DBCode__c = '40711',
        Type = 'Distributor Account',
        Name = 'DUMMY DISTRIBUTOR',
        CMI_Account_Status__c = 'Active',
        BillingCountry = 'Mexico',
        CSS_WS_Address_ID_Bill__c = 123
    );
    insert SPDRTest;
    
    CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
        CSS_WS_Claim_Status__c = 'Pending Planta Payment',
        CSS_WS_Service_Provider_Dealer__c = '54919',
        CSS_WS_Service_Provider_DR__c = '40711',
        CSS_WS_Total_Amount_Other_Claimables__c = 0,
        CSS_WS_Total_Amount_Part__c= 0,
        CSS_WS_Total_Amount_SRT__c= 0,
        CSS_WS_Total_Travel__c = 0,
        CSS_WS_Total_Amount_Travel__c= 0
    );
    insert claim;
    
    CSS_WS_Warranty__c claim2 = new CSS_WS_Warranty__c(
        CSS_WS_Claim_Status__c = 'Approved for Payment',
        CSS_WS_Service_Provider_Dealer__c = '54919',
        CSS_WS_Service_Provider_DR__c = '40711',
        CSS_WS_Total_Amount_Other_Claimables__c = 100,
        CSS_WS_Total_Amount_Part__c= 100,
        CSS_WS_Total_Amount_SRT__c= 100,
        CSS_WS_Total_Travel__c = 10,
        CSS_WS_Total_Amount_Travel__c= 100
    );
    insert claim2;
        
    CSS_WS_Warranty__c claim3 = new CSS_WS_Warranty__c(
        CSS_WS_Claim_Status__c = 'Approved for Payment',
        CSS_WS_Service_Provider_Dealer__c = '54919',
        CSS_WS_Service_Provider_DR__c = '40711',
        CSS_WS_Total_Amount_Other_Claimables__c = 100,
        CSS_WS_Total_Amount_Part__c= 100,
        CSS_WS_Total_Amount_SRT__c= 100,
        CSS_WS_Total_Amount_Travel__c= 90,
        CSS_WS_Total_Parts__c = 90,
        CSS_WS_Total_Labor__c = 90,
        CSS_WS_Total_Other__c = 90,
        CSS_WS_Total_Travel__c = 100
    );
    insert claim3;
        
    CSS_WS_Warranty__c claim4 = new CSS_WS_Warranty__c(
        CSS_WS_Claim_Status__c = 'Approved for Payment',
        CSS_WS_Service_Provider_Dealer__c = '54919',
        CSS_WS_Service_Provider_DR__c = '40711',
        CSS_WS_Total_Amount_Other_Claimables__c = 100,
        CSS_WS_Total_Amount_Part__c= 100,
        CSS_WS_Total_Amount_SRT__c= 100,
        CSS_WS_Total_Travel__c = 10,
        CSS_WS_Total_Amount_Travel__c= 100,
        CSS_WS_Total_Parts__c = 90,
        CSS_WS_Policy_Flag__c = 'Policy'
    );
    insert claim4;
        
    CSS_WS_Warranty__c claim5 = new CSS_WS_Warranty__c(
        CSS_WS_Claim_Status__c = 'Approved for Payment',
        CSS_WS_Service_Provider_Dealer__c = '54919',
        CSS_WS_Service_Provider_DR__c = '40711',
        CSS_WS_Total_Amount_Other_Claimables__c = 0,
        CSS_WS_Total_Amount_Part__c= 0,
        CSS_WS_Total_Amount_SRT__c= 0,
        CSS_WS_Total_Travel__c = 0,
        CSS_WS_Total_Amount_Travel__c= 0,
        CSS_WS_Total_Parts__c = 0,
        CSS_WS_Belongs_To__c = 'Paccar',
        CSS_WS_Policy_Flag__c = 'Policy'
    );
    insert claim5;
    
    CSS_WS_Warranty__c claim6 = new CSS_WS_Warranty__c(
        CSS_WS_Claim_Status__c = 'Approved for Payment',
        CSS_WS_Service_Provider_Dealer__c = '54919',
        CSS_WS_Service_Provider_DR__c = '40711',
        CSS_WS_Total_Amount_Other_Claimables__c = 0,
        CSS_WS_Total_Amount_Part__c= 0,
        CSS_WS_Total_Amount_SRT__c= 0,
        CSS_WS_Total_Travel__c = 0,
        CSS_WS_Total_Amount_Travel__c= 0,
        CSS_WS_Total_Parts__c = 0,
        CSS_WS_Account_Code__c = 'P101',
        CSS_WS_Travel_Paid_Before__c = true, 
        CSS_WS_Service_Order_Counter_Flag__c = 1,
        CSS_WS_Policy_Flag__c = 'Policy'
    );
    insert claim6;
    
    CSS_WS_Warranty__c claim7 = new CSS_WS_Warranty__c(
        CSS_WS_Claim_Status__c = 'Approved for Payment',
        CSS_WS_Service_Provider_Dealer_ToCharge__c = '54919',
        CSS_WS_Service_Provider_DR_ToCharge__c = '40711',
        CSS_WS_Total_Amount_Other_Claimables__c = 0,
        CSS_WS_Total_Amount_Part__c= 0,
        CSS_WS_Total_Amount_SRT__c= 0,
        CSS_WS_Total_Travel__c = 0,
        CSS_WS_Total_Amount_Travel__c= 0,
        CSS_WS_Total_Parts__c = 0,
        CSS_WS_Account_Code__c = 'P101',
        CSS_WS_Travel_Paid_Before__c = false, 
        CSS_WS_Service_Order_Counter_Flag__c = 2,
        CSS_WS_Policy_Flag__c = 'Policy'
    );
    insert claim7;
    
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
    
    //Below commented code is for Service Orders Testing
    /*CSS_WS_Rescue__c rescue = new CSS_WS_Rescue__c(
        CSS_WS_Service_Provider_DR__c = '54321'
    );
    insert rescue;
    
    CSS_WS_Service_Order__c ServiceOrders = new CSS_WS_Service_Order__c(
        Rescue_ID__c = rescue.Id, 
        Emite_la_Orden__c = '54321',
        CSS_WS_Estatus__c = 'Pending Payment',  
        Monto_Total_de_Reclamables__c = 200, 
        Monto_Total_de_Viajes__c = 200, 
        Monto_Total_SRT__c = 200, 
        Monto_Total_Partes__c = 200
    );
    insert ServiceOrders;*/
    
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
    // Schedule the test job
    
    String jobId = System.schedule(
        'CSS_WS_CreateStmx_Test',
        CSS_WS_CreateStmx.CRON_EXP,
        new CSS_WS_CreateStmx()
    );
    
    // Get the information from the CronTrigger API object
    CronTrigger ct = [
        SELECT Id, CronExpression, TimesTriggered,
        NextFireTime
        FROM CronTrigger WHERE id = :jobId
    ];
    
    // Verify the expressions are the same
    System.assertEquals(CSS_WS_CreateStmx.CRON_EXP, 
     ct.CronExpression);
    
    // Verify the job has not run
    System.assertEquals(0, ct.TimesTriggered);
    
    System.assertNotEquals('Pending CM',
        [SELECT id, CSS_WS_Claim_Status__c FROM CSS_WS_Warranty__c WHERE id =: claim.id].CSS_WS_Claim_Status__c );

    Test.stopTest();
    
    System.assertNotEquals('Pending CM',
        [SELECT id, CSS_WS_Claim_Status__c FROM CSS_WS_Warranty__c WHERE id =: claim.id].CSS_WS_Claim_Status__c );
   }
   
}