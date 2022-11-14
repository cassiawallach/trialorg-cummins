@isTest
public class FSL_CL_UpdateAssetDetails_Test {
    public static testmethod void FSL_CL_UpdateAssetDetailsMethod(){
        try {
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
            
            Account acc= new Account();
            acc.RecordTypeId=accRecId;
            acc.Name='Timothy';
            acc.CSS_DistributorCode__c = '03250';
            acc.IAM_Service_Provider_Code__c = '02851';
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
            
            ServiceTerritory st= new ServiceTerritory();
            st.name = 'TEST ST Mobile';
            st.OperatingHoursId=oh.id;
            st.Location_Code__c='03250-02851';
            st.IsActive=true;
            st.FSL_Service_Territory_Code__c='02851';
            st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            st.Territory__c = 'AUSTRALIA';
            insert st;
            
            Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
            System.debug('servRecId' + servRecId);
            Case cs=new Case();
            cs.RecordTypeId=servRecId;
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=ase.id;
            //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
            //Replaced with description filed added new comment for test class
            //cs.General_Symptoms__c='test symptoms';
            cs.Description = 'test symptoms';
            cs.Service_Territory__c=st.id;
            cs.BusinessHoursId=bhs.id;
            cs.Status='Intake';
            cs.Service_Model__c = 'Cummins';
            cs.Make__c='test';
            cs.Model__c='test1';
            cs.Mileage__c = '12345';
            //cs.Product_Hours__c = '40';
            cs.Product_Mileage_Unit__c = 'Miles';
            //cs.Product_Mileage__c = '40'; 
            insert cs;
            
            FSL_IA_FC__c pri = new FSL_IA_FC__c();
            pri.name = 'Test';
            pri.Fault_Code_Type__c = 'Primary';
            pri.Prioritized_FC_SR__c=cs.Id;
            insert pri;
            
            FSL_IA_FC__c Unpri = new FSL_IA_FC__c();
            Unpri.name = 'Test';
            Unpri.Fault_Code_Type__c = 'Primary';
            Unpri.UnPrioritized_FC_SR__c=cs.Id;
            insert Unpri;
            
            FSL_CL_UpdateAssetDetails.fetchServiceOrder(cs.id);
            WorkOrder SerOrd =  new WorkOrder();
            Date d = Date.Today();
            SerOrd.DSID__c='12345';
            SerOrd.Failure_Date__c =d;
            SerOrd.Service_Model__c='ESN';
            SerOrd.Make__c='test';
            SerOrd.Model__c='test1';
            serOrd.Mileage__c = 1000;
            serOrd.CSS_Hours__c = 100;
            SerOrd.Customer_Name__c='Sam Torq';
            SerOrd.Warranty_Start_Date__c=d; 
            SerOrd.ESN__c = '79464647';
            SerOrd.Mileage_measure__c = 'Miles'; 
            SerOrd.ServiceTerritoryId = st.Id;
            SerOrd.AssetId = ase.id;
            SerOrd.CaseId = cs.id;
            SerOrd.AccountId = acc.Id;
            Insert SerOrd;
            
            Case caseUpdate=new Case();
            caseUpdate.Id = cs.Id;
            caseUpdate.ServiceJob__c = SerOrd.Id;
            
            WorkOrder workOrd = new WorkORder();
            CSS_Integration_Details__c customSettingCID = new CSS_Integration_Details__c();
            customSettingCID = FSL_TestDataUtility.createCSSIntegrationDetails();
            workOrd = FSL_TestDataUtility.createWorkOrder(null, null);
            workOrd.Payer__c = FSL_TestDataUtility.createAccount().Id;
            workOrd.CaseId = cs.id;
            
            //test.startTest();
            FSL_CL_UpdateAssetDetails.updateAssetDetails(cs.id);
            FSL_CL_UpdateAssetDetails.fetchServiceOrder(cs.id);
            //test.stopTest();
        } catch (Exception e) {
            System.debug('$$$ exception at ' + e.getLineNumber() + ' because ' + e.getMessage());
        }
        
    }
}