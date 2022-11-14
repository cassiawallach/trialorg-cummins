@istest
public class FSl_MaintaincePlanCont_Test {
    @isTest public static void setup(){
      
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        ServiceTerritory serTer1 = new ServiceTerritory();
        serTer1.Name = 'ST005 In Shop';
        serTer1.OperatingHoursId = oh.Id;
        serTer1.IsActive = true;
        serTer1.Location_Code__c = '03522-04893-78908767';
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
        
        WorkType pmWorkType = new WorkType();
        pmWorkType.name='PM';
        pmWorkType.EstimatedDuration=4;
        insert pmWorkType;
        MaintenancePlan objMP1 = new MaintenancePlan();
        objMP1.StartDate= system.today();
        objMP1.EndDate=system.today()+365;
        objMP1.Frequency=1;
        objMP1.FrequencyType ='Months';
        objMP1.NextSuggestedMaintenanceDate = system.today();
        objMP1.GenerationTimeframe=2;
        objMP1.WorkTypeId = pmWorkType.id;
        objMP1.Service_Territory__c = serTer1.id;
        insert objMP1;
        MaintenancePlan objMP = new MaintenancePlan();
        objMP.StartDate= system.today();
        objMP.EndDate=system.today()+365;
        objMP.Frequency=1;
        objMP.FrequencyType ='Months';
        objMP.NextSuggestedMaintenanceDate = system.today();
        objMP.GenerationTimeframe=2;
        objMP.WorkTypeId = pmWorkType.id;
        objMP.Service_Territory__c = serTer.id;
        insert objMP;
        Account acc = new Account();
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        insert acc;
        
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
        FSL_SubType__c st = new FSL_SubType__c();
        st.name = 'abc';
        st.Branch_Code__c = 1090;
        st.Status__c = 'Active';
        insert st;
        MaintenanceAsset MA = new MaintenanceAsset();
        MA.MaintenancePlanId = objMP.Id;
        MA.AssetId =ast.Id;
        MA.WorkTypeId=pmWorkType.Id;
        ma.Sub_Type__c = st.id;
        ma.Branch_Code__c = 1090;
        
        insert MA;
         
      
        FSl_MaintaincePlanCont.getBranchCode(objMP.id);
        FSl_MaintaincePlanCont.getBranchCode(objMP1.id);
        FSl_MaintaincePlanCont.getBranchCode('objMP1.id');
        
       
        }}