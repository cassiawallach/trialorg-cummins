@istest
public class OSM_DA_GenericFunctionsUtility_Test {

    static testmethod void testData()
    {
        //Account
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
        testAccount.CMI_CId__c = '390';
        testAccount.IAM_Primary_Market_Segment__c = 'Light Truck';
        insert testAccount;
        system.debug('testAccount'+testAccount);
        
        OSM_DA_GenericFunctionsUtility.getSegmentSku('1234567','390');
        
        OSM_DA_GenericFunctionsUtility.DAProdCountInfo dapro = new OSM_DA_GenericFunctionsUtility.DAProdCountInfo();
        dapro.availableCnt = 2;
        dapro.currentCnt = 3;
        dapro.defaultDAProdPartNo = '12345';
        dapro.segmentDAProdPartNo = '123456';
        dapro.daMessage = 'Success';
        dapro.segmentMainProductPartNo = '67890';
        dapro.isNotAvailabelorAPIFailed = true;
        dapro.failedMsg = 'Failure';    
        
        List<String> stringList = new List<String>();
        Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo> mapdapro = new Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo>();
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        //parentpro.Is_DA_Default_Prod__c  = true;
        parentpro.Group_Name__c = 'DA';
        parentpro.ccrz__StartDate__c = system.today().adddays(2);
        parentpro.ccrz__EndDate__c = system.today().adddays(-2);
        parentpro.ccrz__Storefront__c = 'SoftwareStore';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        parentpro.Package__c  = 'Base';
        insert parentpro;
        System.debug('---CC Parent Product---'+parentpro);
        stringList.add(parentpro.ccrz__SKU__c );
        mapdapro.put(parentpro.ccrz__SKU__c,dapro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        //pro.Is_DA_Default_Prod__c  = true;        
        pro.ccrz__StartDate__c = system.today().adddays(2);
        pro.ccrz__EndDate__c = system.today().adddays(-2);
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.ccrz__Storefront__c = 'SoftwareStore';      
        pro.Product_Class_Code__c = 'SW-Web Access';
        pro.Package__c  = 'Base';
        insert pro;
        System.debug('---CC Product---'+pro);
        stringList.add(pro.ccrz__SKU__c );
        stringList.add(pro.ccrz__SKU__c );
        mapdapro.put(pro.ccrz__SKU__c,dapro);
        
        
        OSM_DA_GenericFunctionsUtility.fetchDefaultDAProductPartNumber(stringList);
        OSM_DA_GenericFunctionsUtility.fetchOSMProdPartNoForDefaultSku(stringList,'OHT');
        OSM_DA_GenericFunctionsUtility.fetchOSMParentProdAndCount(mapdapro,'OHT');
    }
    
    static testmethod void testData2()
    {
        //Account
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
        testAccount.CMI_CId__c = '390';
        testAccount.IAM_Primary_Market_Segment__c = 'Bus';
        insert testAccount;
        system.debug('testAccount'+testAccount);
        
        OSM_DA_GenericFunctionsUtility.getSegmentSku('1234567','390');
        
        OSM_DA_GenericFunctionsUtility.DAProdCountInfo dapro = new OSM_DA_GenericFunctionsUtility.DAProdCountInfo();
        dapro.availableCnt = 2;
        dapro.currentCnt = 3;
        dapro.defaultDAProdPartNo = '12345';
        dapro.segmentDAProdPartNo = '123456';
        dapro.daMessage = 'Success';
        dapro.segmentMainProductPartNo = '67890';
        dapro.isNotAvailabelorAPIFailed = true;
        dapro.failedMsg = 'Failure';    
        
        List<String> stringList = new List<String>();
        Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo> mapdapro = new Map<String,OSM_DA_GenericFunctionsUtility.DAProdCountInfo>();
        
        //CC Product        
        ccrz__E_Product__c parentpro = new ccrz__E_Product__c();
        parentpro.Name = 'CA Base-DEF';
        parentpro.ccrz__SKU__c = '5678901-DEF';
        parentpro.ccrz__Quantityperunit__c = 1;
        //parentpro.Is_DA_Default_Prod__c  = true;
        parentpro.Group_Name__c = 'DA';
        parentpro.ccrz__StartDate__c = system.today().adddays(2);
        parentpro.ccrz__EndDate__c = system.today().adddays(-2);
        parentpro.ccrz__Storefront__c = 'SoftwareStore';
        parentpro.Product_Class_Code__c = 'SW-Web Access';
        parentpro.Package__c  = 'Base';
        insert parentpro;
        System.debug('---CC Parent Product---'+parentpro);
        stringList.add(parentpro.ccrz__SKU__c );
        mapdapro.put(parentpro.ccrz__SKU__c,dapro);
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        //pro.Is_DA_Default_Prod__c  = true;        
        pro.ccrz__StartDate__c = system.today().adddays(2);
        pro.ccrz__EndDate__c = system.today().adddays(-2);
        pro.Group_Name__c = 'DA';
        pro.ccrz__ParentProduct__c = parentpro.id;
        pro.ccrz__Storefront__c = 'SoftwareStore';      
        pro.Product_Class_Code__c = 'SW-Web Access';
        pro.Package__c  = 'Base';
        insert pro;
        System.debug('---CC Product---'+pro);
        stringList.add(pro.ccrz__SKU__c );
        stringList.add(pro.ccrz__SKU__c );
        mapdapro.put(pro.ccrz__SKU__c,dapro);
        
        
        OSM_DA_GenericFunctionsUtility.fetchDefaultDAProductPartNumber(stringList);
        OSM_DA_GenericFunctionsUtility.fetchOSMProdPartNoForDefaultSku(stringList,'DEF');
        OSM_DA_GenericFunctionsUtility.fetchOSMParentProdAndCount(mapdapro,'DEF');
    }
}