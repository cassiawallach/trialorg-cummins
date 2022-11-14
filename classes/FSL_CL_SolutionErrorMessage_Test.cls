@isTest
public class FSL_CL_SolutionErrorMessage_Test {
    @isTest
    public static void solErr(){
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId = accRecId;
        acc.Name='Timothy';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79788861';
        ase.Application_Code__c='234';
        insert ase;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c = '02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
        
        ServiceTerritory st1= new ServiceTerritory();
        st1.name = 'TEST ST1 Mobile';
        st1.OperatingHoursId=oh.id;
        st1.IsActive=true;
        st1.Location_Code__c='05550-03941';
        st1.FSL_Service_Territory_Code__c = '03941';
        st1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st1.Territory__c = 'AUSTRALIA';
        insert st1;
        
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Available_for_Service__c=datetime.now()+3;
        wo.SelectedSolution__c='abc';
        // wo.FaultCodeId__c='1167';
        wo.Process_Step__c = 'Repair';
        wo.RecordTypeId 	= recdtypeId;
        //wo.Repair_Solution__c  = sol.Id;
        // wo.Branch_Code__c=5123;
        insert wo;
        
        FSL_CL_SolutionErrorMessage.displayerrormessage(wo.id);
    }
}