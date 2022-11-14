@isTest
public class FSL_OpenRecommendationsHandler_Test {
    
    @testSetup static void setup() {
        Account acc = new Account();
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        insert acc;
        
        worktype  wType = new worktype();
        wType.EstimatedDuration = Decimal.valueOf('40.02');
        wType.Name = 'PM';
        
        insert wType;
        
        Asset  ast = new Asset();
        ast.Account = acc;
        ast.Service_Model__c = 'ISL9 CM2350 L101';
        ast.Unit_Number__c = '1234';
        ast.Make__c = 'KENWORTH';
        ast.Model__c = 'T800';
        ast.Name = '79963830';
        ast.Unit_Type__c = 'EQ8349';
        ast.VIN__c = '1NKDX4TX6JJ180253';
        ast.Type_PSN__c = 'Engines-79963830';
        ast.Application_Description__c = 'AUTOMOTIVE';
        ast.Application_Code__c = '130';
        ast.Engine_Family__c    ='56'; 
        ast.Type__c = 'Engines';
        insert ast;
        
        Asset  ast1 = new Asset();
        ast1.Account = acc;
        ast1.Service_Model__c = 'ISL9 CM2350 L101';
        ast1.Unit_Number__c = '1234';
        ast1.Make__c = 'KENWORTH';
        ast1.Model__c = 'T800';
        ast1.Name = '79963831';
        ast1.Unit_Type__c = 'EQ8349';
        ast1.VIN__c = '1NKDX4TX6JJ180253';
        ast1.Type_PSN__c = 'Engines-79963831';
        ast1.Application_Description__c = 'AUTOMOTIVE';
        ast1.Application_Code__c = '130';
        ast1.Engine_Family__c    ='56'; 
        ast1.Type__c = 'Engines';
        insert ast1;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory serTer1 = new ServiceTerritory();
        serTer1.Name = 'ST005 In Shop';
        serTer1.OperatingHoursId = oh.Id;
        serTer1.IsActive = true;
        serTer1.Location_Code__c = '03522-04893';
        serTer1.FSL_Service_Territory_Code__c = '04893';
        serTer1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer1.Territory__c = 'AUSTRALIA';
        insert serTer1; 
        
        ServiceTerritory serTer = new ServiceTerritory();
        serTer.Name = 'ST001 Mobile';
        serTer.OperatingHoursId = oh.Id;
        serTer.IsActive = true;
        serTer.Location_Code__c = '03520-04892';
        serTer.FSL_Service_Territory_Code__c = '04892';
        serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer.Territory__c = 'AUSTRALIA';
        insert serTer;
        
        Case  cs = new Case();
        cs.Status = 'Intake';
        //cs.Service_Territory__c = serTer.id;
        cs.AccountId = acc.id;
        cs.AssetId = ast.id;
        cs.Priority = 'Medium';
        
        insert cs; 
        
        List<workorder> woInfo = new List<workorder>();
        workorder wo1 = new workorder();
        wo1.Account = acc;
        wo1.Process_Step__c = 'Intake';
        wo1.Asset = ast;
        wo1.Repair_Location__c = 'In Shop';
        wo1.EditComplaint__c = 'TestingOPENRECOM';
        wo1.EditCause__c = 'TestingOPENRECOM';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.ServiceTerritoryid = serTer.id;
        wo1.WorkTypeId=wType.Id;
        //wo1.Case = cs.id;
        wo1.sub_status__c = 'Troubleshooting Complete';
        //wo1.FSL_Additional_Email_Notifications__c='test@test.com';
        
        woInfo.add(wo1);
        
        insert woInfo;
        
        FSL_Recommendation__c  objRec = new FSL_Recommendation__c();
        objRec.Service_Order__c = woInfo[0].id;
        objRec.Status__c = 'In Progress';
        objRec.recordtypeid = Schema.SObjectType.FSL_Recommendation__c.getRecordTypeInfosByDeveloperName().get('In_Progress_Recommendation').getRecordTypeId();
        objRec.Asset__c=ast.Id;
        insert objRec;
    }
    
    Public static testMethod  void openRec(){
        workorder w0=[Select id,Repair_Location__c from workorder where Repair_Location__c='In Shop'];
        FSL_OpenRecommendationsHandler.getRecommendationsCount(w0.Id);
        
    }
}