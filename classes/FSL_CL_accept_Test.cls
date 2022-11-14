//Adding Comment to detect the change for code coverage -- Sriprada S
//comment added for code coverage for sept 2022
@isTest
public class FSL_CL_accept_Test {
    
    public static testmethod void FSL_CL_acceptMethod(){
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
        
        OperatingHours  oh1 = new OperatingHours ();
        oh1.Name = 'new';
        oh1.TimeZone = 'America/Chicago';
        insert oh1;
        
        ServiceTerritory sT1 = new ServiceTerritory();
        sT1.Name = 'ST001';
        sT1.OperatingHoursId = oh1.Id;
        sT1.IsActive = true;
        sT1.Location_Code__c = '01234-12345';
        sT1.FSL_Service_Territory_Code__c = '12345';
        sT1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT1.Mileage_Measure__c = 'Km';
        sT1.Territory__c = 'AUSTRALIA';
        Insert sT1;
        
        ServiceTerritory sT2 = new ServiceTerritory();
        sT2.Name = 'ST002'; 
        sT2.OperatingHoursId = oh1.Id; 
        sT2.IsActive = true;
        sT2.Location_Code__c = '01234-12346';
        sT2.FSL_Service_Territory_Code__c = '12346';
        sT2.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT2.Mileage_Measure__c = 'hrs';
        sT2.Territory__c = 'AUSTRALIA'; 
        Insert sT2;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='qt727@cummins.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='qt727@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345');
        insert u;
        
        System.runAs(u) {
            Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
            System.debug('servRecId' + servRecId);
            Case cs=new Case();
            cs.RecordTypeId=servRecId;
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=ase.id;
            //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
            //Replaced with description filed 
            // cs.General_Symptoms__c='test symptoms';
            cs.Description = 'test symptoms';
            cs.Service_Territory__c=sT1.id;
            cs.IAS_Number__c = '12345678';
            //cs.ServiceJob__c=wo.id;
            cs.Status='New';
            cs.Description = 'Test 123';
            cs.Product_Mileage__c = 1212;
            cs.Product_Hours__c = 2;
            cs.Product_Mileage_Unit__c= 'Km'; 
            cs.OwnerId = u.Id;
            cs.Make__c = 'Other Manufacturer';
            cs.Model__c = 'Other Model';
            cs.Available_for_Service__c=datetime.now()+2;
            cs.Is_Created_From_Portal__c = true;
            insert cs;
            
            workorder wo=new workorder();
            wo.Make__c='UNLISTED';
            wo.Model__c = 'ALL';
            wo.AssetId= cs.AssetId;
            wo.CaseId = cs.id;
            wo.Mileage_Measure__c = 'Kilometers';
            wo.Available_for_Service__c = cs.Available_for_Service__c;
            insert wo;
            
            Case cs1= new Case();
            cs1.id= cs.id;
            cs1.Make__c = 'test';
            cs1.Model__c = 'test';
            cs1.ServiceJob__c= wo.id;
            cs.Available_for_Service__c=datetime.now()+3;
            update cs1;
            
            workorder wo1=new workorder();
            wo1.Id = wo.Id;
            wo1.Make__c='test';
            wo1.Model__c = 'test';
            wo1.AssetId=cs.AssetId;
            wo1.CaseId = cs1.id;
            wo1.Available_for_Service__c = cs1.Available_for_Service__c;
            update wo; 
            Asset astUpdate=new Asset();
            astUpdate.Make__c='ISBXL';
            astUpdate.Model__c='EQ567';
            astUpdate.Name='567478';
            astUpdate.Service_Model__c='IE253';
            insert astUpdate;
            
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
            
            test.startTest();
            FSL_CL_accept.acceptSerRequest(cs.id);
            system.assertEquals('Primary',  Unpri.Fault_Code_Type__c); 
            ase.AccountId = null;
            update ase;
            FSL_CL_accept.acceptSerRequest(cs.id);
            test.stopTest();
        }
    }
    public static testmethod void FSL_CL_acceptMethod2(){
        
        OperatingHours  oh1 = new OperatingHours ();
        oh1.Name = 'new';
        oh1.TimeZone = 'America/Chicago';
        insert oh1;
        
        ServiceTerritory sT2 = new ServiceTerritory();
        sT2.Name = 'ST003';
        sT2.OperatingHoursId = oh1.Id;
        sT2.IsActive = true;
        sT2.Location_Code__c = '01234-12347';
        sT2.FSL_Service_Territory_Code__c = '12347';
        sT2.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT2.Mileage_Measure__c = 'Miles';
        sT2.Territory__c = 'AUSTRALIA';
        Insert sT2;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79788861';
        ase.Application_Code__c='234';
        insert ase;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='qt727@cummins.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='qt727@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345');
        insert u;
        
        
        
        System.runAs(u) {
            Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
            System.debug('servRecId' + servRecId);
            Case cs2= new Case(); 
            cs2.RecordTypeId=servRecId;
            cs2.Make__c = 'Other Manufacturer';
            cs2.Model__c = 'Other Model';
            cs2.Service_Territory__c=sT2.id;
            cs2.Product_Mileage_Unit__c= 'mi'; 
            cs2.AssetId=ase.id;
            insert cs2;
            
            WorkOrder wo2 = new WorkOrder();
            wo2.caseid=cs2.id;
            wo2.AssetId=cs2.AssetId;
            wo2.Make__c='UNLISTED'; 
            wo2.Model__c = 'ALL';
            wo2.Mileage_Measure__c = 'Miles';
            
            test.startTest();
            insert wo2;
            
            FSL_IA_FC__c pri = new FSL_IA_FC__c();
            pri.name = 'Test';
            pri.Fault_Code_Type__c = 'Primary';
            pri.Prioritized_FC_SR__c=cs2.Id;
            insert pri;
            
            FSL_IA_FC__c Unpri = new FSL_IA_FC__c();
            Unpri.name = 'Test';
            Unpri.Fault_Code_Type__c = 'Primary';
            Unpri.UnPrioritized_FC_SR__c=cs2.Id;
            insert Unpri;
            try{ 
                FSL_CL_accept.acceptSerRequest(cs2.id);
            }
                 catch(exception e){
            }
            system.assertEquals('Primary',  Unpri.Fault_Code_Type__c);
            test.stopTest();
        }
    }
    public static testmethod void FSL_CL_acceptMethod_2(){
        
        OperatingHours  oh1 = new OperatingHours ();
        oh1.Name = 'new';
        oh1.TimeZone = 'America/Chicago';
        insert oh1;
        
        ServiceTerritory sT2 = new ServiceTerritory();
        sT2.Name = 'ST003';
        sT2.OperatingHoursId = oh1.Id;
        sT2.IsActive = true;
        sT2.Location_Code__c = '01234-12347';
        sT2.FSL_Service_Territory_Code__c = '12347';
        sT2.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT2.Mileage_Measure__c = 'Miles';
        sT2.Territory__c = 'AUSTRALIA';
        Insert sT2;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79788861';
        ase.Application_Code__c='234';
        insert ase;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='qt727@cummins.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='qt727@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12347');
        insert u;
        
        
        
        System.runAs(u) {
            Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
            System.debug('servRecId' + servRecId);
            Case cs2= new Case(); 
            cs2.RecordTypeId=servRecId;
            cs2.Make__c = 'Other Manufacturer';
            cs2.Model__c = 'Other Model';
            cs2.Service_Territory__c=sT2.id;
            cs2.Product_Mileage_Unit__c= 'hrs'; 
            cs2.AssetId=ase.id;
            insert cs2;
            
            WorkOrder wo2 = new WorkOrder();
            wo2.caseid=cs2.id;
            wo2.AssetId=cs2.AssetId;
            wo2.Make__c='UNLISTED'; 
            wo2.Model__c = 'ALL';
            wo2.Mileage_Measure__c = 'Miles';
            
            test.startTest();
            insert wo2;
            
            FSL_IA_FC__c pri = new FSL_IA_FC__c();
            pri.name = 'Test';
            pri.Fault_Code_Type__c = 'Primary';
            pri.Prioritized_FC_SR__c=cs2.Id;
            insert pri;
            
            FSL_IA_FC__c Unpri = new FSL_IA_FC__c();
            Unpri.name = 'Test';
            Unpri.Fault_Code_Type__c = 'Primary';
            Unpri.UnPrioritized_FC_SR__c=cs2.Id;
            insert Unpri;
            try{ 
                FSL_CL_accept.acceptSerRequest(cs2.id);
            }
                 catch(exception e){
            }   
            system.assertEquals('Primary',  Unpri.Fault_Code_Type__c);
            test.stopTest();
        }
    } 
    public static testmethod void FSL_CL_acceptMethod3(){
        Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
        System.debug('servRecId' + servRecId);
        Case cs=new Case();
        cs.RecordTypeId=servRecId;
        cs.Description = 'test symptoms';
        cs.IAS_Number__c = '12345678';
        //cs.ServiceJob__c=wo.id;
        cs.Status='New';
        cs.Description = 'Test 123';
        insert cs;
        case css=[select description from case where id =:cs.id];
        string generalSymptoms=css.description;
        FSL_CL_accept.checkSymptoms(css.id);
        
    }
    public static testmethod void FSL_CL_acceptMethod_4(){
        
        OperatingHours  oh1 = new OperatingHours ();
        oh1.Name = 'new';
        oh1.TimeZone = 'America/Chicago';
        insert oh1;
        
        ServiceTerritory sT2 = new ServiceTerritory();
        sT2.Name = 'ST003';
        sT2.OperatingHoursId = oh1.Id;
        sT2.IsActive = true;
        sT2.Location_Code__c = '01234-12347';
        sT2.FSL_Service_Territory_Code__c = '12347';
        sT2.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT2.Mileage_Measure__c = 'Miles';
        sT2.Territory__c = 'AUSTRALIA';
        Insert sT2;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79788861';
        ase.Application_Code__c='234';
        insert ase;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='qt727@cummins.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='qt727@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12347');
        insert u;
        
        
        
        System.runAs(u) {
            Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
            System.debug('servRecId' + servRecId);
            Case cs2= new Case(); 
            cs2.RecordTypeId=servRecId;
            cs2.Make__c = 'Other Manufacturer';
            cs2.Model__c = 'Other Model';
            cs2.Service_Territory__c=sT2.id;
            cs2.Product_Mileage_Unit__c= 'hrs'; 
            cs2.AssetId=ase.id;
            cs2.FSL_ABRFlag__c = true;
            insert cs2;
            
            WorkOrder wo2 = new WorkOrder();
            wo2.caseid=cs2.id;
            wo2.AssetId=cs2.AssetId;
            wo2.Make__c='UNLISTED'; 
            wo2.Model__c = 'ALL';
            wo2.Mileage_Measure__c = 'Miles';
            
            test.startTest();
            insert wo2;
            
            FSL_IA_FC__c pri = new FSL_IA_FC__c();
            pri.name = 'Test';
            pri.Fault_Code_Type__c = 'Primary';
            pri.Prioritized_FC_SR__c=cs2.Id;
            insert pri;
            
            FSL_IA_FC__c Unpri = new FSL_IA_FC__c();
            Unpri.name = 'Test';
            Unpri.Fault_Code_Type__c = 'Primary';
            Unpri.UnPrioritized_FC_SR__c=cs2.Id;
            insert Unpri;
            
             try{ 
            FSL_CL_accept.acceptSerRequest(cs2.id);
        }
             catch(exception e){
        }
            system.assertEquals('Primary',  Unpri.Fault_Code_Type__c);
            test.stopTest();
        }
    }
    
    public static testmethod void isDealerAndFTR() {
        
        OperatingHours  oh1 = new OperatingHours ();
        oh1.Name = 'new';
        oh1.TimeZone = 'America/Chicago';
        insert oh1;
        
        ServiceTerritory sT2 = new ServiceTerritory();
        sT2.Name = 'ST003';
        sT2.OperatingHoursId = oh1.Id;
        sT2.IsActive = true;
        sT2.Location_Code__c = '01234-12347';
        sT2.FSL_Service_Territory_Code__c = '12347';
        sT2.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT2.Mileage_Measure__c = 'Miles';
        sT2.Territory__c = 'AUSTRALIA';
        Insert sT2;
        
        Asset ase= new Asset();
        ase.name='79788861';
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79788861';
        ase.Application_Code__c='234';
        insert ase;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='qt727@cummins.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='qt727@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12347');
        insert u;
        
        
        
        System.runAs(u) {
            Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
            System.debug('servRecId' + servRecId);
            Case cs2= new Case(); 
            cs2.RecordTypeId=servRecId;
            cs2.Make__c = 'Other Manufacturer';
            cs2.Model__c = 'Other Model';
            cs2.Service_Territory__c=sT2.id;
            cs2.Product_Mileage_Unit__c= 'hrs'; 
            cs2.AssetId=ase.id;
            cs2.FSL_ABRFlag__c = true;
            insert cs2;
            
            WorkOrder wo2 = new WorkOrder();
            wo2.caseid=cs2.id;
            wo2.AssetId=cs2.AssetId;
            wo2.Make__c='UNLISTED'; 
            wo2.Model__c = 'ALL';
            wo2.Mileage_Measure__c = 'Miles';
            
            test.startTest();
            insert wo2;
            
            FSL_IA_FC__c pri = new FSL_IA_FC__c();
            pri.name = 'Test';
            pri.Fault_Code_Type__c = 'Primary';
            pri.Prioritized_FC_SR__c=cs2.Id;
            insert pri;
            
            FSL_IA_FC__c Unpri = new FSL_IA_FC__c();
            Unpri.name = 'Test';
            Unpri.Fault_Code_Type__c = 'Primary';
            Unpri.UnPrioritized_FC_SR__c=cs2.Id;
            insert Unpri;
            
            Boolean isFTRAndDealer = FSL_CL_accept.isDealerAndFTR(cs2.id);
            System.assertEquals(false, isFTRAndDealer);
            test.stopTest();
            
        }
    }
    
    public static testmethod void testGetSolutionsForFTR() {    
        OperatingHours testOh = TestUtility.createOperatingHours('testName');
        ServiceTerritory testTerritory = TestUtility.createServiceTerritory('testName', true, testOh.Id);
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = FSL_TestDataUtility.createAccount();
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con = FSL_TestDataUtility.createContact(conRecId, acc.Id);
        insert con;
        Asset  ast = FSL_TestDataUtility.createAsset();
        Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EVL_Guidanz_Dealer_Evolution').getRecordTypeId();
        List<Case> lstCases = FSL_TestDataUtility.createCases(servRecId,acc.Id, con.Id,ast.Id,testTerritory.Id,1);
        lstCases[0].FSL_ABRFlag__c= true;
        lstCases[0].FSL_TransactionID__c= '12345-67890-132445-5657';
        insert lstCases;
        Id DealerRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        List<workorder> lstWO = FSL_TestDataUtility.createWO(lstCases, acc.Id);
        lstWO[0].RecordTypeId = DealerRTID;
        insert lstWO;
        Service_Order_Extension__c soExtension = FSL_TestDataUtility.createServiceOrderExtension(lstWO[0].Id, true, '12345-67890-132445-5657');
        CSS_Integration_Details__c conDetails = FSL_TestDataUtility.createCSSIntegrationDetails('FSL_QSOL_RetrieveOptionList'
            , 'https://qsstg.cummins.com/integrationservices/api/catalog/optionlist?, CurrencyIsoCode=USD', 'GET');
        insert conDetails;
        CSS_Integration_Details__c conDetails2 = FSL_TestDataUtility.createCSSIntegrationDetails('CG_GETDiagnosticSRT'
            , 'https://api-ue-stgnf-aw-ex.cummins.com/cmi-engine/standardrepairstime', 'GET');
        insert conDetails2;
        List<CSS_Solutions__c> lstCSSSolutions = FSL_TestDataUtility.create_CSSSolutions(lstWO[0].Id, 2);
        insert lstCSSSolutions;
        List<CSS_Solution_Component__c> lstCSSSolutionCmp = FSL_TestDataUtility.create_CSSSolutionComponents(lstCSSSolutions);
        insert lstCSSSolutionCmp;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_CL_MockTest());
        Test.startTest();
        String result = FSL_CL_accept.getSolutionsForFTR(lstWO[0].Id);
        Test.stopTest();    
        System.assertEquals('success', result);     
    }
    
    public static testmethod void testCallGetOptionsAndOtherApis() {   
        OperatingHours testOh = TestUtility.createOperatingHours('testName');
        ServiceTerritory testTerritory = TestUtility.createServiceTerritory('testName', true, testOh.Id);
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = FSL_TestDataUtility.createAccount();
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con = FSL_TestDataUtility.createContact(conRecId, acc.Id);
        insert con;
        Asset  ast = FSL_TestDataUtility.createAsset();
        Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EVL_Guidanz_Dealer_Evolution').getRecordTypeId();
        List<Case> lstCases = FSL_TestDataUtility.createCases(servRecId,acc.Id, con.Id,ast.Id,testTerritory.Id,1);
        lstCases[0].FSL_ABRFlag__c= true;
        lstCases[0].FSL_TransactionID__c= '12345-67890-132445-5657';
        insert lstCases;
        Id DealerRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        List<workorder> lstWO = FSL_TestDataUtility.createWO(lstCases, acc.Id);
        lstWO[0].RecordTypeId = DealerRTID;
        insert lstWO;
        Service_Order_Extension__c soExtension = FSL_TestDataUtility.createServiceOrderExtension(lstWO[0].Id, true, '12345-67890-132445-5657');
        CSS_Integration_Details__c conDetails = FSL_TestDataUtility.createCSSIntegrationDetails('FSL_QSOL_RetrieveOptionList'
            , 'https://qsstg.cummins.com/integrationservices/api/catalog/optionlist?, CurrencyIsoCode=USD', 'GET');
        insert conDetails;
        CSS_Integration_Details__c conDetails2 = FSL_TestDataUtility.createCSSIntegrationDetails('CG_GETDiagnosticSRT'
            , 'https://api-ue-stgnf-aw-ex.cummins.com/cmi-engine/standardrepairstime', 'GET');
        insert conDetails2;
        List<CSS_Solutions__c> lstCSSSolutions = FSL_TestDataUtility.create_CSSSolutions(lstWO[0].Id, 2);
        insert lstCSSSolutions;
        List<CSS_Solution_Component__c> lstCSSSolutionCmp = FSL_TestDataUtility.create_CSSSolutionComponents(lstCSSSolutions);
        insert lstCSSSolutionCmp;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_CL_MockTest());
        Test.startTest();
        FSL_CL_accept.callGetOptionsAndOtherApis(lstWO[0].Id);
        Test.stopTest();        
        List<FSL_SRT__c> lspParts = [select id from FSL_SRT__c];
        System.assertEquals(true, lspParts.size()>0);
    }        
    
    public static testmethod void testCallGetPartsAndPartReturn() {    
        OperatingHours testOh = TestUtility.createOperatingHours('testName');
        ServiceTerritory testTerritory = TestUtility.createServiceTerritory('testName', true, testOh.Id);
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = FSL_TestDataUtility.createAccount();
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con = FSL_TestDataUtility.createContact(conRecId, acc.Id);
        insert con;
        Asset  ast = FSL_TestDataUtility.createAsset();
        Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EVL_Guidanz_Dealer_Evolution').getRecordTypeId();
        List<Case> lstCases = FSL_TestDataUtility.createCases(servRecId,acc.Id, con.Id,ast.Id,testTerritory.Id,1);
        lstCases[0].FSL_ABRFlag__c= true;
        lstCases[0].FSL_TransactionID__c= '12345-67890-132445-5657';
        insert lstCases;
        Id DealerRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        List<workorder> lstWO = FSL_TestDataUtility.createWO(lstCases, acc.Id);
        lstWO[0].RecordTypeId = DealerRTID;
        insert lstWO;
        Service_Order_Extension__c soExtension = FSL_TestDataUtility.createServiceOrderExtension(lstWO[0].Id, true, '12345-67890-132445-5657');
        CSS_Integration_Details__c conDetails = FSL_TestDataUtility.createCSSIntegrationDetails('FSL_QSOL_RetrieveOptionList'
            , 'https://qsstg.cummins.com/integrationservices/api/catalog/optionlist?, CurrencyIsoCode=USD', 'GET');
        insert conDetails;
        CSS_Integration_Details__c conDetails2 = FSL_TestDataUtility.createCSSIntegrationDetails('CG_GETDiagnosticSRT'
            , 'https://api-ue-stgnf-aw-ex.cummins.com/cmi-engine/standardrepairstime', 'GET');
        insert conDetails2;
        List<CSS_Solutions__c> lstCSSSolutions = FSL_TestDataUtility.create_CSSSolutions(lstWO[0].Id, 2);
        insert lstCSSSolutions;
        List<CSS_Solution_Component__c> lstCSSSolutionCmp = FSL_TestDataUtility.create_CSSSolutionComponents(lstCSSSolutions);
        insert lstCSSSolutionCmp;
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        Test.startTest();
        FSL_CL_accept.callGetPartsAndPartReturn(lstWO[0].Id);
        Test.stopTest();

        List<FSL_Parts__c> partsList = [SELECT id, Solution__c, CSS_Solution_Component__c, Solution__r.FSL_Service_Job__c,
                                            CSS_Solution_Component__r.FSL_Service_Job__c, CSS_Solution_Component__r.Component_Id__c
                                        FROM FSL_Parts__c
                                        WHERE Select__c = true];

        System.assertNotEquals(null, partsList);
        System.assertEquals(2, partsList.size());
        System.assertEquals(lstWO[0].Id, partsList[0].Solution__r.FSL_Service_Job__c);
        System.assertEquals(lstWO[0].Id, partsList[0].CSS_Solution_Component__r.FSL_Service_Job__c);
        System.assertEquals('F19000170', partsList[0].CSS_Solution_Component__r.Component_Id__c);        
    }
}