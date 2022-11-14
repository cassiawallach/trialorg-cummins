/***********************************************************************
History                                                            
-------                                                            
VERSION             AUTHOR                        DATE                  DETAIL                                 
1.0 -      Rupesh Pande      9/17/2018           INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class CG_CL_ClaimsMultiPSN_Test
{
    static testMethod void TM2()
    {
        
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        
        claimsList.add(claimsObj );
        insert claimsList;
       Map<Id, String> removeIdsMap = new Map<Id, String>();
        removeIdsMap.put(claimsObj.id,'abc');
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        //psnobj.Id=removeIdsMap.keySet();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
       // psnObj.id=removeIdsMap.getKey();
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj);
        
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = false;
        psnObj1.Service_Model__c = 'Test';
        psnObj1.Warranty_Start_Date__c = date.today();
        psnObj1.Mileage_Measure__c = 'MI';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        insert psnList;
        
        
        CSS_Job_Order__c sjob=CSS_TestData.createJobOrder(true);
        
        CSS_Solutions__c sols=CSS_TestData.createSolutions(true,sjob.id);
        list<css_solution_component__c> lst=new list<css_solution_component__c>();
        css_solution_component__c sc = CSS_TestData.createSRT(true,sjob.id,sols.id);
        sc.System_Code__c = 'EQ';
        sc.Type__c='Campaign';
        sc.CSS_Claims__c=claimsList[0].id;
        sc.Status__c='Approved';
        sc.Selected_Component__c=true;
         upsert sc;
        lst.add(sc);
     
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        
        CG_CL_ClaimsMultiPSN mpsnobj=new CG_CL_ClaimsMultiPSN();
        mpsnobj.errormsg = 'test';
       //mpsnobj.nvClaimsIntake();
        mpsnobj.nvClaimsWC();    
        mpsnobj.nvClaimsWC(); 
        mpsnobj.nvClaimsFC(); 
        mpsnobj.nvClaimsVH();     
        mpsnobj.nvClaimsCC(); 
        mpsnobj.nvClaimsPOC();     
        mpsnobj.nvClaimsSRTs();            
        mpsnobj.nvClaimsJobNotes();         
        mpsnobj.nvClaimsVS(); 
        mpsnobj.buildMPSNWrapper();
        mpsnobj.saveMPSNRecords();
        mpsnobj.updateSRTs();
        mpsnobj.resetMPSNRecords();      
        mpsnobj.removingRow();
        mpsnobj.selectedPSN='TestPSN123';
        mpsnobj.psnTabOff();
        mpsnobj.deleteMPSN();
         mpsnobj.selectedRowNo=0;
        mpsnobj.onChangeofWSD();
        test.stoptest();
    }
    
    static testMethod void TM3()
    {
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        //claimsObj.Account = ;
        claimsList.add(claimsObj );
        insert claimsList;
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Before_In_Service__c = true;
        psnList.add(psnObj);
        
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = false;
        psnObj1.Service_Model__c = 'Test';
        psnObj1.Warranty_Start_Date__c = date.today();
        psnObj1.Before_In_Service__c = true;
        psnObj1.Mileage_Measure__c = 'HR';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        insert psnList;
        
        CSS_Job_Order__c sjob=CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sols=CSS_TestData.createSolutions(true,sjob.id);
        css_solution_component__c sc = CSS_TestData.createSRT(false,sjob.id,sols.id);
         sc.System_Code__c = 'EQ';
        sc.Type__c='Campaign';
        sc.CSS_Claims__c=claimsList[0].id;
        sc.Status__c='Approved';
        sc.Selected_Component__c=true;
        insert sc;
        /*list<CSS_SRT__c> srt=new list<CSS_SRT__c>();
        CSS_SRT__c srtVar = new CSS_SRT__c();
        //srtVar.Solution_Number__c = sc.id;
        srtVar.Job_Order__c = sjob.id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        //srtVar.Type__c = typ;
        srtVar.isPerformed__c =True;
        srtVar.SRT_ID__c='00-901-00';
        srtVar.SRT_Warrantable__c='60';
        srtVar.CSS_Claims__c=claimsObj.id;
        upsert srtVar;
        srt.add(srtVar);*/
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        
        CG_CL_ClaimsMultiPSN mpsnobj=new CG_CL_ClaimsMultiPSN();
        // CG_CL_ClaimsMultiPSN.MultiPSNWrapper mpswrpr2=new CG_CL_ClaimsMultiPSN.MultiPSNWrapper(3,sjob.id,'','','',false,'','','','','',false,false,false,false,false,null,false);
        //list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper> wprlist=new  list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper>();   
        
        //wprlist.add(mpswrpr2);
        mpsnobj.errorMsg = 'true'; 
        mpsnobj.psnDetails2 = psnObj;
        mpsnobj.lstpsnDetails = psnList;
        mpsnobj.mPsnROFlag=true;
        //mpsnobj.nvClaimsIntake();
        //mpsnobj.nvClaimsWC();    
        mpsnobj.nvClaimsWC(); 
        mpsnobj.nvClaimsFC(); 
        mpsnobj.nvClaimsVH();     
        mpsnobj.nvClaimsCC(); 
        mpsnobj.nvClaimsPOC();     
        mpsnobj.nvClaimsSRTs();            
        mpsnobj.nvClaimsJobNotes();         
        mpsnobj.nvClaimsVS(); 
        mpsnobj.buildMPSNWrapper();
        mpsnobj.saveMPSNRecords();
        mpsnobj.updateSRTs();
        mpsnobj.resetMPSNRecords();      
        mpsnobj.removingRow();
        mpsnobj.selectedPSN = '79464645';
        mpsnobj.selectedRowNo = 1;
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());  
        mpsnobj.psnTabOff();
        mpsnobj.deleteMPSN();
        mpsnobj.selectedWSD = '10/05/2020';
        // mpsnobj.selectedWSD = string.valueof(system.today()+1);
        mpsnobj.onChangeofWSD();
        mpsnobj.pgSave();
        
        CSS_getEngineDataResponseJ2A enginereq = new CSS_getEngineDataResponseJ2A();        
        CSS_getEngineDataResponseJ2A.DataArea Req = new CSS_getEngineDataResponseJ2A.DataArea();
        
        Req.WarrantyStartDate = '2013-10-14T00:00:00.000-04:00';
        Req.vin = 'Test';
        //List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        enginereq.DataArea = Req;
        mpsnobj.updateWrapper(enginereq);
        mpsnobj.onChangeofWSD();
        mpsnObj.selectedMIKMHR='HR';
        mpsnobj.selectedRedioButton();    
        test.stoptest();
    }
    
    static testMethod void TM4()
    {    
        Account a= new Account();
           a.name='Rtest';
           a.CSS_DistributorCode__c='1111';
           a.IAM_Service_Provider_Code__c='2222';
           a.Type='Dealer Account';
         insert a;
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Account__c=a.id;
        //claimsObj.IsDealerCreatedClaim__c=true;
        claimsObj.Information_Only_Claim__c=true;
        claimsList.add(claimsObj );
        insert claimsList;
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Failure_Date__c = date.today();
        psnObj.Service_Model__c = 'Test';
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = false;
        psnObj1.Service_Model__c = 'Test';
        psnObj1.Warranty_Start_Date__c = date.today();
        psnObj1.Before_In_Service__c=true;
        
        psnObj1.Mileage_Measure__c = 'KM';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        insert psnList;
        CSS_Job_Order__c sjob=CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sols=CSS_TestData.createSolutions(true,sjob.id);
        List<CSS_Solution_Component__c> failuresList=new List<CSS_Solution_Component__c>();
        css_solution_component__c sc = CSS_TestData.createSRT(false,sjob.id,sols.id);
        sc.type__c = '';
        sc.System_Code__c = 'EQ';
        sc.CSS_Claims__c=claimsObj.id;
        sc.AccountCodeEdit__c='THAC';
        sc.Selected_Component__c = true;
       sc.type__C='test';
        insert sc;
        failuresList.add(sc);
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        
        CG_CL_ClaimsMultiPSN mpsnobj=new CG_CL_ClaimsMultiPSN();
        Set<String> errorMsgsSet=new Set<String>();
        errorMsgsSet.add('abc');
        errorMsgsSet.add('abc');
        errorMsgsSet.add('abc');
        CG_CL_ClaimsMultiPSN.MultiPSNWrapper mpswrpr2=new CG_CL_ClaimsMultiPSN.MultiPSNWrapper(0,claimsobj.id,'','','',false,'','','','','',false,false,false,false,false,null,false,false);
        /*CG_CL_ClaimsMultiPSN.MultiPSNWrapper mpswrpr4=new CG_CL_ClaimsMultiPSN.MultiPSNWrapper(5,claimsobj.id,'PSN','failurePoint','WSD',true,'VIN',
                               'calibrationBefore','revisionBefore','calibrationAfter','revisionAfter',
                               true, true,true,true,true,
                               errorMsgsSet,true,true);*/
        //CG_CL_ClaimsMultiPSN.MultiPSNWrapper mpswrpr3=CG_CL_ClaimsMultiPSN.MultiPSNWrapper(10,claimsobj.id,'794646464','failurePoint','WSD',true,'VIN','calibrationBefore','revisionBefore','calibrationAfter','revisionAfter',true, true,true,true,true,errorMsgsSet,true,true);
        list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper> wprlist=new  list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper>();   
        //wprlist.add(mpswrpr4);
        wprlist.add(mpswrpr2);
        mpsnobj.selectedRowNo = 0;
        mpsnobj.errorMsg='false';
        mpsnobj.psnDetails2 = psnObj;
        mpsnobj.lstpsnDetails = psnList;
        mpsnobj.warrStDtHidden = '';
        mpsnobj.errorMsg_test='test123';
        CG_PACCAR_Flag_SP_Info_Mapping__c pa=new CG_PACCAR_Flag_SP_Info_Mapping__c();
        mpsnobj.paccarCustomSettingValues=pa;
        //mpsnobj.selectedPSN = '79464645';
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());  
        mpsnobj.psnTabOff();
        CSS_getEngineDataResponseJ2A enginereq = new CSS_getEngineDataResponseJ2A();        
        CSS_getEngineDataResponseJ2A.DataArea Req = new CSS_getEngineDataResponseJ2A.DataArea();
        
        Req.WarrantyStartDate = '2013-10-14T00:00:00.000-04:00';
        Req.buildDate= '2013-10-14T00:00:00.000-04:00';
        mpsnobj.selectedWSD = '10/05/2020';
        //List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        enginereq.DataArea = Req;
        mpsnobj.updateWrapper(enginereq);
        
        mpsnobj.onChangeofWSD();
        mpsnObj.selectedBIS = true;
        mpsnobj.onChangeofBIS();
        mpsnobj.lstMPSNWrapper = wprlist;
        mpsnobj.saveMPSNRecords();
        mpsnobj.buildMPSNWrapper();
        mpsnObj.selectedMIKMHR='MI';
        mpsnobj.selectedRedioButton(); 
        mpsnobj.errormsg = null;
        mpsnobj.ErrorMessage=false;
        mpsnobj.failureerror=false;
        //mpsnobj.nvClaimsIntake();
        mpsnobj.nvClaimsWC();
        mpsnobj.nvClaimsVH();
        mpsnobj.nvClaimsCC();
        mpsnobj.nvClaimsFC();
        mpsnobj.nvClaimsPOC();
        mpsnobj.nvClaimsSRTs();
        mpsnobj.nvClaimsJobNotes();
        mpsnobj.nvClaimsVS();
        mpsnobj.pgSave_Old();
        test.stoptest();
    }
    static testMethod void TM412()
    {    
        Account a= new Account();
           a.name='Rtest';
           a.CSS_DistributorCode__c='1111';
           a.IAM_Service_Provider_Code__c='2222';
           a.Type='Dealer Account';
         insert a;
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.FieldActionWebServiceResult__c = 'Error';
        claimsobj.Account__c=a.id;
        //claimsObj.IsDealerCreatedClaim__c=true;
        claimsObj.Information_Only_Claim__c=true;
        claimsList.add(claimsObj );
        insert claimsList;
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Failure_Date__c = date.today();
        psnObj.Service_Model__c = 'Test';
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = false;
        psnObj1.Service_Model__c = 'Test';
        psnObj1.Warranty_Start_Date__c = date.today();
        psnObj1.Before_In_Service__c=true;
        
        psnObj1.Mileage_Measure__c = 'KM';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        insert psnList;
        CSS_Job_Order__c sjob=CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sols=CSS_TestData.createSolutions(true,sjob.id);
        List<CSS_Solution_Component__c> failuresList=new List<CSS_Solution_Component__c>();
        css_solution_component__c sc = CSS_TestData.createSRT(false,sjob.id,sols.id);
        sc.type__c = '';
        sc.System_Code__c = 'EQ';
        sc.CSS_Claims__c=claimsObj.id;
        sc.AccountCodeEdit__c='THAC';
        sc.Selected_Component__c = true;
       sc.type__C='test';
        insert sc;
        failuresList.add(sc);
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        
        CG_CL_ClaimsMultiPSN mpsnobj=new CG_CL_ClaimsMultiPSN();
        Set<String> errorMsgsSet=new Set<String>();
        errorMsgsSet.add('abc');
        errorMsgsSet.add('abc');
        errorMsgsSet.add('abc');
        //CG_CL_ClaimsMultiPSN.MultiPSNWrapper mpswrpr2=new CG_CL_ClaimsMultiPSN.MultiPSNWrapper(0,claimsobj.id,'','','',false,'','','','','',false,false,false,false,false,null,false,false);
        CG_CL_ClaimsMultiPSN.MultiPSNWrapper mpswrpr4=new CG_CL_ClaimsMultiPSN.MultiPSNWrapper(5,claimsobj.id,'PSN','failurePoint','WSD',false,'VIN',
                               'calibrationBefore','revisionBefore','calibrationAfter','revisionAfter',
                               false, false,false,false,false,
                               errorMsgsSet,false,false);
        //CG_CL_ClaimsMultiPSN.MultiPSNWrapper mpswrpr3=CG_CL_ClaimsMultiPSN.MultiPSNWrapper(10,claimsobj.id,'794646464','failurePoint','WSD',true,'VIN','calibrationBefore','revisionBefore','calibrationAfter','revisionAfter',true, true,true,true,true,errorMsgsSet,true,true);
        list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper> wprlist=new  list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper>();   
        wprlist.add(mpswrpr4);
        //wprlist.add(mpswrpr2);
        mpsnobj.selectedRowNo = 0;
        mpsnobj.errorMsg='false';
        mpsnobj.psnDetails2 = psnObj;
        mpsnobj.lstpsnDetails = psnList;
        mpsnobj.warrStDtHidden = '';
        mpsnobj.errorMsg_test='test123';
        CG_PACCAR_Flag_SP_Info_Mapping__c pa=new CG_PACCAR_Flag_SP_Info_Mapping__c();
        mpsnobj.paccarCustomSettingValues=pa;
        //mpsnobj.selectedPSN = '79464645';
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());  
        mpsnobj.psnTabOff();
        CSS_getEngineDataResponseJ2A enginereq = new CSS_getEngineDataResponseJ2A();        
        CSS_getEngineDataResponseJ2A.DataArea Req = new CSS_getEngineDataResponseJ2A.DataArea();
        
        Req.WarrantyStartDate = '2013-10-14T00:00:00.000-04:00';
        Req.buildDate= '2013-10-14T00:00:00.000-04:00';
        mpsnobj.selectedWSD = '10/05/2020';
        //List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        enginereq.DataArea = Req;
        mpsnobj.updateWrapper(enginereq);
        
        mpsnobj.onChangeofWSD();
        mpsnObj.selectedBIS = true;
        mpsnobj.onChangeofBIS();
        mpsnobj.lstMPSNWrapper = wprlist;
        mpsnobj.saveMPSNRecords();
        mpsnobj.buildMPSNWrapper();
        mpsnObj.selectedMIKMHR='MI';
        mpsnobj.selectedRedioButton(); 
        mpsnobj.errormsg = null;
        mpsnobj.ErrorMessage=false;
        mpsnobj.failureerror=false;
        //mpsnobj.nvClaimsIntake();
        mpsnobj.nvClaimsWC();
        mpsnobj.nvClaimsVH();
        mpsnobj.nvClaimsCC();
        mpsnobj.nvClaimsFC();
        mpsnobj.nvClaimsPOC();
        mpsnobj.nvClaimsSRTs();
        mpsnobj.nvClaimsJobNotes();
        mpsnobj.nvClaimsVS();
        mpsnobj.pgSave_Old();
        test.stoptest();
    }
    static testMethod void TM41()
    {
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        CSS_Job_Order__c sjob=CSS_TestData.createJobOrder(true);
        //sjob.Account__c = acc.id;

        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsObj.Customer_Name__c='TestCustomer';
        claimsObj.account__c = acc.id;
        claimsList.add(claimsObj );
        insert claimsList;
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Failure_Date__c = date.today();
        psnObj.Service_Model__c = 'Test';
        psnList.add(psnObj);
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = 'TestPSN123';
        psnObj1.Primary__c = false;
        psnObj1.Service_Model__c = 'Test';
        psnObj1.Warranty_Start_Date__c = date.today();
        psnObj1.Mileage_Measure__c = 'KM';
        psnObj1.CSS_Claims__c = claimsList[0].id;
        psnList.add(psnObj1);
        insert psnList;

        CSS_Solutions__c sols=CSS_TestData.createSolutions(true,sjob.id);
        css_solution_component__c sc = CSS_TestData.createSRT(false,sjob.id,sols.id);
        sc.type__c = '';
        sc.System_Code__c = 'EQ';
        insert sc;
        list<CSS_SRT__c> srt=new list<CSS_SRT__c>();
        CSS_SRT__c srtVar = new CSS_SRT__c();
        //srtVar.Solution_Number__c = sc.id;
        //srtVar.Job_Order__c = sjob.id;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = 'test';
        srtVar.isPerformed__c =True;
        srtVar.SRT_ID__c='00-901-00';
        srtVar.SRT_Warrantable__c='60';
        srtVar.CSS_Claims__c=claimsObj.id;
        insert srtVar;
        srt.add(srtVar);
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        
        CG_CL_ClaimsMultiPSN mpsnobj=new CG_CL_ClaimsMultiPSN();
        CG_CL_ClaimsMultiPSN.MultiPSNWrapper mpswrpr2=new CG_CL_ClaimsMultiPSN.MultiPSNWrapper(0,sjob.id,'','','',false,'','','','','',false,false,false,false,false,null,false,false);
        list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper> wprlist=new  list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper>();   
        
        wprlist.add(mpswrpr2);
        mpsnobj.selectedRowNo = 0;
                
        Test.setMock(HttpCalloutMock.class, new CSS_getEngineDataFrmSiebel_Test());  
      
        CSS_getEngineDataResponseJ2A enginereq = new CSS_getEngineDataResponseJ2A();        
        CSS_getEngineDataResponseJ2A.DataArea Req = new CSS_getEngineDataResponseJ2A.DataArea();
        
        Req.WarrantyStartDate = '2013-10-14T00:00:00.000-04:00';
        Req.buildDate= '2013-10-14T00:00:00.000-04:00';
        mpsnobj.selectedWSD = '10/05/2020';
        //List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        enginereq.DataArea = Req;
        mpsnobj.updateWrapper(enginereq);
        
       
        mpsnobj.lstMPSNWrapper = wprlist;
       mpsnobj.updateWrapperErrors(true,true,'test');
        mpsnobj.updateSRTs();
        test.stoptest();
    }
    static testMethod void TM5()
    {
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        
        claimsList.add(claimsObj );
        insert claimsList;
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = false;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Failure_Date__c = date.today();
        psnObj.Service_Model__c = 'Test';
        psnObj.Before_In_Service__c=true;
        
        psnList.add(psnObj);
        
        insert psnList;
        CSS_Job_Order__c sjob=CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sols=CSS_TestData.createSolutions(true,sjob.id);
        css_solution_component__c sc = CSS_TestData.createSRT(false,sjob.id,sols.id);
        sc.type__c = '';
        sc.AccountCode__C = 'Test';
        sc.System_Code__c = 'EQ';
        sc.selected_Component__C = true;
        sc.css_claims__c = claimsList[0].id;
        insert sc;
        
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        
        CG_CL_ClaimsMultiPSN mpsnobj=new CG_CL_ClaimsMultiPSN();
        CG_CL_ClaimsMultiPSN.MultiPSNWrapper mpswrpr2=new CG_CL_ClaimsMultiPSN.MultiPSNWrapper(0,sjob.id,'79464646','','',false,'','','','','',false,false,false,false,true,null,false,false);
        list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper> wprlist=new  list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper>();   
        
        wprlist.add(mpswrpr2);
        mpsnobj.selectedRowNo = 0;
        mpsnobj.selectedRemoveRow=10;
        mpsnobj.psnDetails2 = psnObj;
        mpsnobj.lstpsnDetails = psnList;
        mpsnobj.warrStDtHidden = '';
        
        
        mpsnobj.selectedWSD = '10/05/2020';
        //List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        mpsnobj.lstMPSNWrapper = wprlist;
        mpsnobj.mandatebool=true;
        Set<String> errorMsgsSet = new Set<String>();
        //mpsnobj.removingRow();
        mpsnobj.saveMPSNRecords();
        mpsnobj.pgSave_Old();
        mpsnobj.ValidationPSN();
        mpsnobj.AddRows();
        mpsnObj.selectedMIKMHR='KM';
        mpsnobj.selectedRedioButton(); 
        mpsnobj.getlistSelected();
        test.stoptest();
    }
     static testMethod void removingRow()
    {
        List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        
        claimsList.add(claimsObj );
        insert claimsList;
        
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = 'TestPSN123';
        psnObj.Primary__c = false;
        psnObj.CSS_Claims__c = claimsList[0].id;
        psnObj.Failure_Date__c = date.today();
        psnObj.Service_Model__c = 'Test';
        psnObj.Before_In_Service__c=true;
        
        psnList.add(psnObj);
        
        insert psnList;
        CSS_Job_Order__c sjob=CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sols=CSS_TestData.createSolutions(true,sjob.id);
        css_solution_component__c sc = CSS_TestData.createSRT(false,sjob.id,sols.id);
        sc.type__c = '';
        sc.AccountCode__C = 'Test';
        sc.System_Code__c = 'EQ';
        sc.selected_Component__C = true;
        sc.css_claims__c = claimsList[0].id;
        insert sc;
        
        
        ApexPages.currentPage().getParameters().put('id', claimsList[0].Id);
        Test.startTest();
        
        CG_CL_ClaimsMultiPSN mpsnobj=new CG_CL_ClaimsMultiPSN();
        CG_CL_ClaimsMultiPSN.MultiPSNWrapper mpswrpr2=new CG_CL_ClaimsMultiPSN.MultiPSNWrapper(10,sjob.id,'79464646','','',false,'','','','','',false,false,false,false,true,null,false,false);
        list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper> wprlist=new  list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper>();   
        
        wprlist.add(mpswrpr2);
        mpsnobj.selectedRowNo = 0;
        mpsnobj.selectedRemoveRow=10;
        mpsnobj.psnDetails2 = psnObj;
        mpsnobj.lstpsnDetails = psnList;
        mpsnobj.warrStDtHidden = '';
        
        
        mpsnobj.selectedWSD = '10/05/2020';
        //List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
        mpsnobj.lstMPSNWrapper = wprlist;
        mpsnobj.mandatebool=true;
        Set<String> errorMsgsSet = new Set<String>();
        mpsnobj.removingRow();
       /* mpsnobj.saveMPSNRecords();
        mpsnobj.pgSave_Old();
        mpsnobj.ValidationPSN();
        mpsnobj.AddRows();
        mpsnObj.selectedMIKMHR='KM';
        mpsnobj.selectedRedioButton(); 
        mpsnobj.getlistSelected();*/
        test.stoptest();
    }
    
    static testmethod void TestforNullValues(){
        
        string cId = ApexPages.CurrentPage().getParameters().get('id');
        PageReference pageRef = Page.CG_ClaimsJobNotes;
        Test.setCurrentPage(pageRef);
               
        test.startTest();
        CG_CL_ClaimsMultiPSN claims = new CG_CL_ClaimsMultiPSN();
        claims.errorMsg='';
        claims.failureerror=false;
        claims.buildMPSNWrapper();
        claims.nvClaimsIntake();
        claims.nvClaimsWC();
        claims.nvClaimsVH();
        claims.errorMsg='abc';
        claims.nvClaimsCC();
        claims.nvClaimsFC();
        claims.nvClaimsPOC();
        claims.nvClaimsSRTs();
        claims.nvClaimsJobNotes();
        claims.nvClaimsVS();
        claims.pgSave();
        claims.ErrorMessage=false;
        claims.errorMsg=null;
        claims.pgSave_Old();
        
        claims.deleteMPSN();
        claims.saveMPSNRecords();
        claims.updateSRTs();
        claims.resetMPSNRecords();
        claims.ValidationPSN();
        claims.AddRows();
        claims.removingRow();
        claims.psnTabOff();
        claims.setPACCAR_Flag('test');
        List<SelectOption> o = claims.getlistSelected();
        claims.selectedWSD='';
        CSS_Job_Order__c sjob=CSS_TestData.createJobOrder(true);
         CG_CL_ClaimsMultiPSN.MultiPSNWrapper mpswrpr2=new CG_CL_ClaimsMultiPSN.MultiPSNWrapper(0,sjob.id,'','','',false,'','','','','',false,false,false,false,false,null,false,false);
        list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper> wprlist=new  list<CG_CL_ClaimsMultiPSN.MultiPSNWrapper>();  
        claims.lstMPSNWrapper = wprlist;
        claims.selectedRowNo=0;
        claims.onChangeofWSD();
        test.stopTest();
    }
}