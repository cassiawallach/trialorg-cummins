@isTest
public class FSL_CL_FTRUtility_Test {

    @testSetup 
    static void setup() {

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
    }

    @isTest 
    public static void test_getSolutionsForFTR() {
        
        
        Workorder woIns = [Select id from Workorder LIMIT 1];

        woIns.Process_Step__c = 'Triage & Diagnosis';
        Test.startTest();
        update woIns;

        //
        String result = FSL_CL_LaunchInsite.getSolutionsForFTR(woIns.Id);
        Test.stopTest();
        System.assertEquals('success', result);
    }
    
    @isTest 
    public static void test_callGetOptionsAndOtherApis() {
        
        
        Workorder woIns = [Select id from Workorder LIMIT 1];

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_CL_MockTest());
        Test.startTest();
        FSL_CL_LaunchInsite.callGetOptionsAndOtherApis(woIns.Id);
        Test.stopTest();
        List<FSL_SRT__c> lspParts = [select id from FSL_SRT__c];
        System.assertEquals(true, lspParts.size()>0);
    }

    @isTest 
    public static void callGetPartsForFTRTest() {

        Workorder woIns = [Select id from Workorder LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        Test.startTest();
        FSL_CL_LaunchInsite.callGetPartsAndPartReturn(woIns.Id);
        Test.stopTest();

        List<FSL_Parts__c> partsList = [SELECT id, Solution__c, CSS_Solution_Component__c, Solution__r.FSL_Service_Job__c,
                                            CSS_Solution_Component__r.FSL_Service_Job__c, CSS_Solution_Component__r.Component_Id__c
                                        FROM FSL_Parts__c
                                        WHERE Select__c = true];

        System.assertNotEquals(null, partsList);
        System.assertEquals(2, partsList.size());
        System.assertEquals(woIns.id, partsList[0].Solution__r.FSL_Service_Job__c);
        System.assertEquals(woIns.id, partsList[0].CSS_Solution_Component__r.FSL_Service_Job__c);
        System.assertEquals('F19000170', partsList[0].CSS_Solution_Component__r.Component_Id__c);
    }
    
}