@isTest
private class FSL_CL_ServiceRequestTriggerHelper_Test {   
    @testSetup   
    public static void createData () {
        try {
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
            
            Account acc= new Account();
            acc.RecordTypeId=accRecId;
            acc.Name='Timothy';
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId=conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.Phone='1234567890';
            con.AccountId=acc.id;
            insert con;
            
            Asset ase= new Asset();
            ase.name='79788861';
            ase.AccountId=acc.Id;
            ase.Safety_Requirement__c=True;
            ase.Type__c='Engines';
            ase.Type_PSN__c='Engines-79788861';
            ase.Application_Code__c='234';
            insert ase;
            
            OperatingHours oh=new OperatingHours();
            oh.name ='test operating hours';
            insert oh;
            
          /*  ServiceTerritory st= new ServiceTerritory();
            st.name = 'TEST ST Mobile';
            st.OperatingHoursId=oh.id;
            st.Location_Code__c='03250-02851';
            st.IsActive=true;
            st.FSL_Service_Territory_Code__c='02851';
            st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            st.Territory__c = 'AUSTRALIA';
            insert st; */
            
            Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
            System.debug('servRecId' + servRecId);
            Case cs=new Case();
            cs.RecordTypeId=servRecId;
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=ase.id;
            cs.General_Symptoms__c='test symptoms';
          //  cs.Service_Territory__c=st.id;
            cs.BusinessHoursId=bhs.id;
            cs.Status='Intake';
            cs.Service_Model__c= 'Cummins';
            cs.Make__c='test';
            cs.Model__c='test1';
           // cs.Mileage__c = '12345';
            cs.Product_Hours__c = 40;
            cs.Product_Mileage_Unit__c = 'Miles';
            cs.Product_Mileage__c = 40;
            cs.IAS_Number__c = 'BC-9999';
            cs.IsIAWOSubmitCalled__c = TRUE;
            cs.Comments='test';
            insert cs;   
            
            update cs;
        } catch (Exception e) {
            System.debug('$$$ exception at ' + e.getLineNumber() + ' because ' + e.getMessage());
        }
    }
    
    static testMethod void testChangeInRecodWithIntakeStatus () {     
        RecursiveTriggerHandler recHandler = new RecursiveTriggerHandler();
        Case serreq = [SELECT Id FROM Case LIMIT 01];       
        serreq.Mileage__c = '123456';        
        Database.SaveResult savRslt = Database.update(serreq, false);       
        //System.assert(!savRslt.isSuccess());         
    }    
}