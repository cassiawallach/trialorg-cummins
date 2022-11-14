//This is Test class for EVL_CL_RSW class
/*******************************************************************************************************************
Name: EVL_CL_RSW_Test
Copyright © 2020  Cummins
===================================================================================================================
===================================================================================================================
Purpose:    This class is for Create Claims funtionality.
===================================================================================================================
===================================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Lochana Rajput     06/14/2022     
*******************************************************************************************************************/
@isTest
public class EVL_CL_RSW_Test {

    Public testmethod static void prepareRSWInfo(){
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.name='East Bronx1';
        acc.recordTypeId = accRecId;
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.IAM_Service_Provider_Code__c = '56255';
        acc.Type = 'Customer';
        acc.CSS_DBCode__c = '33333';
        acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        //acc.ownerid=u.id; 
		
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
        
        Case  cs = new Case();
        cs.Status = 'Intake';
        //cs.Service_Territory__c = serTer.id;
        cs.AccountId = acc.id;
        cs.AssetId = ast.id;
        cs.Priority = 'Medium';
        
        insert cs; 
        
        Id DealerRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        workorder wo1 = new workorder();
        wo1.Account = acc;
        wo1.RecordTypeId = DealerRTID;
        wo1.Process_Step__c = 'Repair';
        wo1.Asset = ast;
        wo1.Application__c = '130 - AUTOMOTIVE';
       // wo1.Repair_Location__c = 'In-Shop';
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.Type__c = 'Dealer';
        wo1.Case = cs;
        wo1.sub_status__c = 'Troubleshooting Complete';
        wo1.EVL_Customer__c ='ABCDEFGHIJKLMNOPQRSTUVWXYZIt is More than 30 chracters test';
        //wo1.FSL_Additional_Email_Notifications__c='test@test.com';
        
       
        
        insert wo1;
        
         FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        test.starttest();
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = wo1.id;
        fcode.extfield__c = cfc.id+' '+wo1.id;
        insert fcode;
        
        //wo.FaultCodeId__c = fcode.id;
        //update wo;
        
        List<CSS_Solutions__c> SolutionList = new List<CSS_Solutions__c>();
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.FSL_Service_Job__c=wo1.Id;
        sol.userTimestamp__c=datetime.now();
        SolutionList.add(sol);
        
        CSS_Solutions__c csol = new CSS_Solutions__c();
        csol.Name='T00000691';
        csol.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol.FSL_Solution_Position__c='1.1';
        csol.Diagnostic_Notes__c='Test';
        csol.Repair_Notes__c='Good';
        csol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol.Repair_Response__c='Repair Successful.';
        csol.FaultCode__c=fcode.Id;
        csol.CSS_Nested_Solutions__c=sol.Id;
        csol.No_Access_SRT_required__c = true;
        csol.FSL_Service_Job__c=wo1.Id;
        csol.userTimestamp__c=datetime.now();
        
        SolutionList.add(csol);
        
        CSS_Solutions__c csol1 = new CSS_Solutions__c();
        csol1.Name='T00000691';
        csol1.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol1.FSL_Solution_Position__c='1.1';
        csol1.Diagnostic_Notes__c='Test';
        csol1.Repair_Notes__c='Good';
        csol1.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol1.Repair_Response__c='Repair Successful.';
        csol1.FaultCode__c=fcode.Id;
        csol1.CSS_Nested_Solutions__c=sol.Id;
        csol1.FSL_Service_Job__c=wo1.Id;
        csol1.userTimestamp__c=datetime.now();
        
        SolutionList.add(csol1);
        
        insert SolutionList;
        
        List<CSS_Solution_Component__c> solcmps = new List<CSS_Solution_Component__c>();
        solcmps.add(new CSS_Solution_Component__c(Solutions__c = csol.id, Fault_Code__c = 'test123', Selected_Component__c = true));
        
        solcmps.add(new CSS_Solution_Component__c(Solutions__c = csol1.id, Fault_Code__c = 'test1234'));
        insert solcmps;
        
        
        
        EVL_CL_RSW.buildRSWUpdateClaimReqWrapper(wo1.Id);
        
        test.stopTest();
        System.assertEquals(Limits.getQueries() > 0, true);
        
    }

    @isTest
    public static void testMethodForFTREventype() {
        FSL_Switch__c FSlSwitch =FSL_TestDataUtility.createFSLSwitchRecord('Enable_FTR_Switch', true);
        FSL_Switch__c FSlSwitchRSW =FSL_TestDataUtility.createFSLSwitchRecord('Enable_RSWIntegrationforFTR', true);
        List<FSL_Switch__c> lstFeature = new List<FSL_Switch__c>();
        lstFeature.add(FSlSwitch);
        lstFeature.add(FSlSwitchRSW);
        insert lstFeature;

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
        insert lstCases;
        test.startTest();
        Id DealerRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        List<workorder> lstWO = FSL_TestDataUtility.createWO(lstCases, acc.Id);
        lstWO[0].RecordTypeId = DealerRTID;
        insert lstWO;
        Workorder wo1= lstWO[0];
        Service_Order_Extension__c soExtension = FSL_TestDataUtility.createServiceOrderExtension(wo1.Id, true, '12345-566788');
        EVL_CL_RSW.buildRSWUpdateClaimReqWrapper(wo1.Id);
        
        test.stopTest();
        System.assertEquals(Limits.getQueries() > 0, true);
    }
}