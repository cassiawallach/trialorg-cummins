@isTest
public class FSL_CL_RetrieveOptionList_Test {
    
    @testSetup static void dataSetup() 
    {
        
        Id recTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Options').getRecordTypeId();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;       
        
        ServiceTerritory sT = new ServiceTerritory(); 
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = 'SC102';
        sT.FSL_Service_Territory_Code__c = '05351';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;           
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Type_PSN__c = 'Engines-79704393';
        insert asst;           
        
        WorkOrder wo    = new WorkOrder();
        wo.AccountId    = acc.Id;
        wo.AssetId      = asst.Id;
        wo.ServiceTerritoryId = sT.Id;
        wo.Status       = 'closed';
        wo.Category1__c = 'Leak';
        wo.Process_Step__c = 'Intake';
        //wo.Complaint_Type1__c = 'COOLANT LEAK EXTERNAL';        
        wo.Shop_Work_Order__c = 'test';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.createdDate=system.now().addDays(-29);         
        insert wo;
        
        CSS_Parts_Options__c cssOptions = new CSS_Parts_Options__c();
        cssOptions.RecordTypeId = recTypeId;
        cssOptions.Option_Number__c = '4352144';
        cssOptions.Repair_Group__c = '17.02';
        cssOptions.Part_Description__c = 'Upper Engine Gasket Set';
        cssOptions.Service_Order__c = wo.Id;
        cssOptions.Option_ESN__c = asst.name;		 
        insert cssOptions;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getQSOLToken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https//test.com/RetrieveOptionList';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'FSL_QSOL_RetrieveOptionList'; 
        insert conDetails1;
        
        CSS_Integration_Details__c conDetails2 = new CSS_Integration_Details__c();
        conDetails2.End_Point__c = 'https//test.com/Getwarrantydocs';
        conDetails2.Passcode__c = 'Admin';
        conDetails2.Username__c = 'Admin';
        conDetails2.Name = 'FSL_QSOL_Getwarrantydocs'; 
        insert conDetails2;
    }
    
    @isTest static void testCallout()
    {
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        // FSL_CL_QSOLIntegrations.getToken('FSL_GetApiToken_QSOL');
        FSL_CL_QSOLIntegrations.CallForOptionList('79788868');
        test.stopTest();
    }
    
    @isTest static void testCalloutForRetrieveOptionList()
    {
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        WorkOrder wo = [Select id,Asset.name from WorkOrder Limit 1];
        //FSL_CL_QSOLIntegrations.CallForOptionList('79788868');
        FSL_CL_RetrieveOptionList.WrapOptions ob;
        FSL_CL_RetrieveOptionList.insertOptions(wo.Asset.name, wo.Id);
        test.stopTest();
    }
}