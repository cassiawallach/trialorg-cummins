/**********************************************************************
Name:CG_CL_ClaimsCC_Test
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
this is test class for CG_CL_ClaimsCC Controller.
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR                 DATE                DETAIL                                 
1.0 -      Prabhakar      1/29/2018           INITIAL DEVELOPMENT  
2.0        Arpita         2/14/2018           Added a new method to cover code having claims id
2.1         XYZ				NA					Checking GIT lab
2.2			ABC				NA					Checking Parallel Dev
2.3			Bharat		10/23/2018				Change on Same Line
***********************************************************************/

@isTest
public class CG_CL_ClaimsCC_Test {
    public static Testmethod void CG_CL_ClaimsCC_Method(){
        
        CG_CL_ClaimsIntake intake = new CG_CL_ClaimsIntake();
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.FieldActionWebServiceResult__c='Error';
        claimsObj.Claims_Category_Desc__c='test';
       // claimsObj.CSS_PSNs__r = null;
        insert claimsObj;
        intake.claimsRec.Claims_Category_Desc__c=claimsObj.Claims_Category_Desc__c;
        claimsList.add(claimsObj );
                List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.Failure_Date__c = date.today();
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        insert psnList;
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        CG_CL_ClaimsCC claims = new CG_CL_ClaimsCC();
        claims.claimsRec = claimsList[0];
        claims.psnRec = psnList[0];
        claims.nvClaimsIntake();
        claims.nvClaimsFC();
        claims.nvClaimsWC();
        claims.nvClaimsVS();
        claims.nvClaimsVH();
        claims.nvClaimsSRTs();
        claims.nvClaimsPOC();
        claims.nvClaimsJobNotes();
        claims.nvClaimsCC();
        claims.ChkFieldBlank();
        claims.isAutomatedDealer = true;
        Test.stopTest();
    }
    
    public static Testmethod void CG_CL_ClaimsCC_Method1(){
        Test.startTest();
        CG_CL_ClaimsIntake intake = new CG_CL_ClaimsIntake();
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.FieldActionWebServiceResult__c='Error';
        claimsObj.Claims_Category_Desc__c='test';
        
        insert claimsObj;
        intake.claimsRec.Claims_Category_Desc__c=claimsObj.Claims_Category_Desc__c;
        claimsList.add(claimsObj );
      
     string jsonResponse1='{"DataArea":{"Details":[{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LOSS - OVERFLOW","BusinessUnit":"EBU","ComplaintCode":"106","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"117","ActiveFlag":"Y"},{"Category":"Leak","Description":"EXHAUST LEAK","BusinessUnit":"EBU","ComplaintCode":"118","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SHUTS DOWN OR STALLS","BusinessUnit":"EBU","ComplaintCode":"205","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE SURGES","BusinessUnit":"EBU","ComplaintCode":"212","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"LOW POWER","BusinessUnit":"EBU","ComplaintCode":"213","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"VIBRATION","BusinessUnit":"EBU","ComplaintCode":"401","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"INOPERATIVE COMPONENT","BusinessUnit":"EBU","ComplaintCode":"404","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE RUNS ROUGH","BusinessUnit":"EBU","ComplaintCode":"215","ActiveFlag":"Y"},{"Category":"Leak","Description":"DEF LEAK","BusinessUnit":"EBU","ComplaintCode":"609","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"115","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK INTERNAL - IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"116","ActiveFlag":"Y"},{"Category":"Leak","Description":"COMPRESSION LEAK","BusinessUnit":"EBU","ComplaintCode":"120","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - RED","BusinessUnit":"EBU","ComplaintCode":"202","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE WILL NOT SHUT DOWN","BusinessUnit":"EBU","ComplaintCode":"211","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"CRUISE CONTROL","BusinessUnit":"EBU","ComplaintCode":"503","ActiveFlag":"Y"},{"Category":"Other","Description":"INSPECTION","BusinessUnit":"EBU","ComplaintCode":"603","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN AIR SYSTEM","BusinessUnit":"EBU","ComplaintCode":"121","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO NOISE","BusinessUnit":"EBU","ComplaintCode":"123","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL OUT EXHAUST","BusinessUnit":"EBU","ComplaintCode":"124","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"TURBO BLOWING OIL IN INTAKE","BusinessUnit":"EBU","ComplaintCode":"125","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"CHECK ENGINE LIGHT - YELLOW","BusinessUnit":"EBU","ComplaintCode":"201","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT REACH RPM","BusinessUnit":"EBU","ComplaintCode":"206","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED HIGH","BusinessUnit":"EBU","ComplaintCode":"208","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"POOR THROTTLE RESPONSE","BusinessUnit":"EBU","ComplaintCode":"214","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HIGH BLOW-BY","BusinessUnit":"EBU","ComplaintCode":"408","ActiveFlag":"Y"},{"Category":"Other","Description":"REBUILD","BusinessUnit":"EBU","ComplaintCode":"602","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT COMPLETE","BusinessUnit":"EBU","ComplaintCode":"606","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"101","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT BUILD AIR OR BUILDS SLOWLY","BusinessUnit":"EBU","ComplaintCode":"122","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ROUGH IDLE","BusinessUnit":"EBU","ComplaintCode":"209","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLACK SMOKE","BusinessUnit":"EBU","ComplaintCode":"302","ActiveFlag":"Y"},{"Category":"Other","Description":"VOLTAGE (GENSET)","BusinessUnit":"EBU","ComplaintCode":"505","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"STARTER MOTOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"508","ActiveFlag":"Y"},{"Category":"Other","Description":"CAMPAIGN / TRP","BusinessUnit":"EBU","ComplaintCode":"601","ActiveFlag":"Y"},{"Category":"Other","Description":"FAILED EMISSION TEST","BusinessUnit":"EBU","ComplaintCode":"604","ActiveFlag":"Y"},{"Category":"Other","Description":"MAINTENANCE","BusinessUnit":"EBU","ComplaintCode":"605","ActiveFlag":"Y"},{"Category":"Other","Description":"TELEMATICS","BusinessUnit":"EBU","ComplaintCode":"990","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"HARD START","BusinessUnit":"EBU","ComplaintCode":"203","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"204","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE MISFIRE","BusinessUnit":"EBU","ComplaintCode":"210","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ENGINE BRAKE MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"406","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BLOWING DIPSTCK OUT","BusinessUnit":"EBU","ComplaintCode":"407","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - NOT IN OIL","BusinessUnit":"EBU","ComplaintCode":"102","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"107","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"109","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE HIGH","BusinessUnit":"EBU","ComplaintCode":"112","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL CONSUMPTION EXCESSIVE","BusinessUnit":"EBU","ComplaintCode":"113","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"IDLE SPEED LOW","BusinessUnit":"EBU","ComplaintCode":"207","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WHITE SMOKE","BusinessUnit":"EBU","ComplaintCode":"301","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"NOISE IN ENGINE","BusinessUnit":"EBU","ComplaintCode":"402","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"WILL NOT CARRY LOAD (GENSET)","BusinessUnit":"EBU","ComplaintCode":"504","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN TOO FREQUENT","BusinessUnit":"EBU","ComplaintCode":"608","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT LEAK INTERNAL - IN OIL","BusinessUnit":"EBU","ComplaintCode":"103","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL IN COOLANT","BusinessUnit":"EBU","ComplaintCode":"108","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"FUEL LEAK EXTERNAL","BusinessUnit":"EBU","ComplaintCode":"114","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"BLUE SMOKE","BusinessUnit":"EBU","ComplaintCode":"303","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"ENGINE OVERSPEED","BusinessUnit":"EBU","ComplaintCode":"409","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BELT PROBLEM","BusinessUnit":"EBU","ComplaintCode":"410","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"ALTERNATOR MALFUNCTIONING","BusinessUnit":"EBU","ComplaintCode":"507","ActiveFlag":"Y"},{"Category":"Other","Description":"OTHER - SEE TEXT FOR DESCRIPTION","BusinessUnit":"EBU","ComplaintCode":"999","ActiveFlag":"Y"},{"Category":"Symptom / Performance","Description":"REGEN WILL NOT START","BusinessUnit":"EBU","ComplaintCode":"607","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE LOW","BusinessUnit":"EBU","ComplaintCode":"104","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"COOLANT TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"105","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL TEMPERATURE HIGH","BusinessUnit":"EBU","ComplaintCode":"110","ActiveFlag":"Y"},{"Category":"Fuel - Oil - Coolant","Description":"OIL PRESSURE LOW","BusinessUnit":"EBU","ComplaintCode":"111","ActiveFlag":"Y"},{"Category":"Leak","Description":"AIR LEAK","BusinessUnit":"EBU","ComplaintCode":"119","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"NOISY COMPONENT","BusinessUnit":"EBU","ComplaintCode":"403","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"LOOSE OR BROKEN MOUNTING HARDWARE","BusinessUnit":"EBU","ComplaintCode":"405","ActiveFlag":"Y"},{"Category":"Component/Part Specific Issue","Description":"BREAKER TRIPPING","BusinessUnit":"EBU","ComplaintCode":"506","ActiveFlag":"Y"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
        CSS_JobEventTemporary__c jj = new CSS_JobEventTemporary__c();
        jj.Reason__c = jsonResponse1;
        jj.Attribute1__c = 'CategoryComplaintCodes';
        insert jj;
        
        system.debug('jj>>>'+jj);
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.Failure_Date__c = date.today();
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        insert psnList;
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        CG_CL_ClaimsCC claims = new CG_CL_ClaimsCC();
        claims.claimsRec = claimsList[0];
        claims.psnRec = psnList[0];
        claims.mainContr=intake;
        claims.setfilterCategory('Testss');
        claims.getfilterCategory();
        
        claims.setfilterCategory2('Test2');
        claims.getfilterCategory2();
        claims.setfilterCategory3('Test3');
        claims.getfilterCategory3();
        claims.setfilterCategory4('Test4');
        claims.getfilterCategory4();
        claims.setfilterCategory5('Test5');
        claims.getfilterCategory5();
        claims.setfilterComplaintType('Test');
        claims.getfilterComplaintType();
        claims.setfilterComplaintType2('Test');
        claims.getfilterComplaintType2();
        claims.setfilterComplaintType3('Test');
        claims.getfilterComplaintType3();
        claims.setfilterComplaintType4('Test');
        claims.getfilterComplaintType4();
        claims.setfilterComplaintType5('Test');
        claims.getfilterComplaintType5();
        claims.getCategoryList();
        claims.isAutomatedDealer = false;
        claims.getComplaintTypeList();
        claims.getComplaintTypeList2();
        claims.getComplaintTypeList3();
        claims.getComplaintTypeList4();
        claims.getComplaintTypeList5();
        claims.nvClaimsPSN();
        claims.nvClaimsIntake();
        claims.nvClaimsFC();
        claims.nvClaimsWC();
        claims.nvClaimsVS();
        claims.nvClaimsVH();
        claims.nvClaimsSRTs();
        claims.nvClaimsPOC();
        claims.nvClaimsJobNotes();
        claims.nvClaimsCC();
        claims.ChkFieldBlank();
        
        Test.stopTest();
    }
    
    public static Testmethod void getPreventiveMaintenanceMethod(){
                CG_CL_ClaimsIntake intake = new CG_CL_ClaimsIntake();
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.FieldActionWebServiceResult__c='Error';
        claimsObj.Claims_Category_Desc__c='test';
        
        insert claimsObj;
        intake.claimsRec.Claims_Category_Desc__c=claimsObj.Claims_Category_Desc__c;
        claimsList.add(claimsObj );
                List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.Failure_Date__c = date.today();
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        insert psnList;
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        CG_CL_ClaimsCC claims = new CG_CL_ClaimsCC();
        claims.claimsRec = claimsList[0];
        claims.psnRec = psnList[0];
        claims.getPreventiveMaintenance();
        Test.stopTest();
    }
    public static Testmethod void getExpeditedServiceMethod(){
                CG_CL_ClaimsIntake intake = new CG_CL_ClaimsIntake();
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.FieldActionWebServiceResult__c='Error';
        claimsObj.Claims_Category_Desc__c='test';
        
        insert claimsObj;
        intake.claimsRec.Claims_Category_Desc__c=claimsObj.Claims_Category_Desc__c;
        claimsList.add(claimsObj );
                List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.Failure_Date__c = date.today();
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        insert psnList;
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        CG_CL_ClaimsCC claims = new CG_CL_ClaimsCC();
        claims.claimsRec = claimsList[0];
        claims.psnRec = psnList[0];
        claims.getExpeditedService();
        Test.stopTest();
    }
    
}