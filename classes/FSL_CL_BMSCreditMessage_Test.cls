/*
 * Test Class for Apex Controller - FSL_CL_BMSCreditMessage
 * Author - Piyush Rani
 */ 
@isTest
public class FSL_CL_BMSCreditMessage_Test {
	@isTest
    private static void testPayerDetails() {
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account ';
        insert acc;
        
        Account payer = new Account();
        payer.Name = 'Payer Account';
        payer.PaymentType__c = 'Charge';
        payer.BMSAvailableCredit__c = 5000.0;
        payer.FSL_Amount_Due__c = 60000.0;
        payer.FSL_Credit_Limit__c = 80000.1;
        insert payer;
        
        Contact con=new Contact();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT= new ServiceTerritory();
        sT.name = 'TEST ST Mobile';
        sT.OperatingHoursId=oh.id;
        sT.Location_Code__c='03250-02851';
        sT.FSL_Service_Territory_Code__c = '02851';
        sT.IsActive=true;
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        insert sT;
        
        Asset ast = new Asset();
        ast.Name = '79464648';
        ast.Type_PSN__c = 'Engines-79464648';
        ast.Type__c = 'Engines';
        insert ast;
        
        List<WorkOrder> workOrdList = new List<WorkOrder>();
        WorkOrder SerRec =  new WorkOrder();
        Date d = Date.Today();
        SerRec.DSID__c='12345';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Service_Model__c='ESN';
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.Customer_Name__c='Sam Torq';
        SerRec.Warranty_Start_Date__c=d;
        SerRec.ESN__c = '';
        SerRec.Mileage__c = 12345;
        SerRec.Mileage_measure__c = 'Miles';
        SerRec.ServiceTerritoryId = sT.Id;
        SerRec.AssetId = ast.id;
        
        WorkOrder wo =  new WorkOrder();
        Date d1 = Date.Today();
        wo.DSID__c='23456';
        wo.Customer_Name__c='Test ABC';
        wo.Payer__c = payer.Id;
        wo.Failure_Date__c =d1;
        wo.Service_Model__c='ESN';
        wo.Make__c='Take';
        wo.Model__c='Ace';
        wo.Customer_Name__c='Sam Tiger';
        wo.Warranty_Start_Date__c=d;
        wo.ESN__c = '';
        wo.Mileage__c = 2345;
        wo.Mileage_measure__c = 'Miles';
        wo.ServiceTerritoryId = sT.Id;
        wo.AssetId = ast.id;
        
        workOrdList.add(SerRec);
        workOrdList.add(wo);
        
        insert workOrdList;
        
        FSL_CL_BMSCreditMessage.payerWrapper wrapper = FSL_CL_BMSCreditMessage.getPayerDetails(SerRec.Id);
        FSL_CL_BMSCreditMessage.payerWrapper wrapperDate = FSL_CL_BMSCreditMessage.getPayerDetails(wo.Id);
        
        Test.stopTest();
    }
}