@isTest
public class FSL_TSB_Integration_Test {
    
    static testMethod void testCallout() {
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account';
        insert acc;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT = new ServiceTerritory(); 
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '05340-05351';
        sT.FSL_Service_Territory_Code__c = '05351';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        Insert sT;
        
        Asset ast=new Asset();
        
        ast.Name='79788868';
        ast.Warranty_Start_Date__c=date.today();
        ast.Make__c = 'AUTOCAR';
        ast.Type_PSN__c='Engines-79788868';
        ast.Service_Model__c = 'ISL G CM2180';
        ast.VIN__c = '5VCACLLE0CH213818';
        insert ast;
        
        WorkOrder wo    = new WorkOrder();
        wo.AccountId    = acc.Id;
        wo.AssetId      = ast.Id;
        wo.ServiceTerritoryId = sT.Id;
        wo.Status       = 'closed';
        wo.Category1__c = 'Leak';
        wo.Process_Step__c = 'Intake';
        //wo.Complaint_Type1__c = 'COOLANT LEAK EXTERNAL';        
        wo.Shop_Work_Order__c = 'test';
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.createdDate=system.now().addDays(-29);
        insert wo;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getQSOLToken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails; 
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        //https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?
        //'https//test.com/Getwarrantydocs'; 
        conDetails1.End_Point__c = 'https//test.com/Getwarrantydocs';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'FSL_QSOL_Getwarrantydocs';
        insert conDetails1;
        
        //  Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        Test.setMock(HttpCalloutMock.class, new FSLFaultCodeMock());
        
        test.startTest();
           FSL_TSB_Integration.TSBFromQSOL(wo.id); 
        test.stopTest();
    }
}