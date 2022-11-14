@isTest
public class css_srtEditPopupController_Test{

    
    //Main Testmethod 
    public static TestMethod void M1(){
        
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
    //Test.starttest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        CSS_Job_Order__c JobId1=CSS_TestData.createJobOrder(false);
        jobId1.CSS_In_Shop_Labor_Rate__c ='10';
        jobId1.Account__c = acc.id;
        insert jobId1;
        
        id wid = apexpages.currentpage().getparameters().put('id' , jobId1.id);
     
        list<CSS_Job_Order__c> jolist=new list<CSS_Job_Order__c>();
        jolist.add(JobId1);
        
        system.debug('JOBS: '+jolist);
        
         
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Diagnostic_Response__c = 'Most likely the solution';
        sols.Service_Job__c=JobId1.id;
        
        insert sols;
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jolist[0].id,sols.id);
        
        list<CSS_Solution_Component__c> solcompList = new list<CSS_Solution_Component__c>();
       
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Service_Job__c = wid;
        solComp1.System_Code__c = 'TH';
        solComp1.Component_Code__c = 'AC';
        solComp1.Selected_Component__c = true;
        solComp1.Type__c = 'Test';
        solComp1.Root_Cause__c = true;
           // insert solComp1;
        //List<CSS_Solution_Component__c> record = [SELECT id,Service_Job__c,System_Code__c,Component_Code__c,Selected_Component__c,SysCodeAndCompCode__c FROM CSS_Solution_Component__c];
        //solComp1.SysCodeAndCompCode__c=System_Code__c + Component_Code__c;
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.Service_Job__c = wid;
        solComp2.System_Code__c = 'TH';
        solComp2.Component_Code__c = 'AC';
        solComp2.Selected_Component__c = true;
        solComp2.Type__c = 'Test';
        solComp2.Root_Cause__c = true;
         // insert solComp2;
        solcompList.add(solComp1);
        solcompList.add(solComp2);
        insert solcompList;
        //List<CSS_Solution_Component__c> solsComp= [SELECT Id, Root_Cause__c, Fail_Code__c, SysCodeAndCompCode__c, CSS_Account_Formula__c, Solutions__c, CoveredLaborHrs__c, CampaignLaborPercentage__c, Selected_Component__c,FailCode_Formula__c from CSS_Solution_Component__c where SysCodeAndCompCode__c!=null and Selected_Component__c= true and Type__c NOT IN ('TRP','ATC','Campaign') and Root_Cause__c = true]; //and Selected_Component__c= true];    
        //List<CSS_Solution_Component__c> solsComp = [SELECT id,Service_Job__c,System_Code__c,Component_Code__c,Selected_Component__c,SysCodeAndCompCode__c FROM CSS_Solution_Component__c LIMIT 10];
        //solcompList.addall(solsComp);			
        
        //Create SRT record
        CSS_SRT__c srtobj1=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj1.SRT_ID__c = '00-10S-00';
        srtobj1.Assignment__c = 'NOT CLAIMABLE';
        srtobj1.Component_Id__c = solComp1.id;
        srtobj1.FailCode__c='EUCN';
        srtobj1.SRT_Title__c = 'test';
        srtobj1.SRT_Quantity__c=1;
        srtobj1.SRT_Time__c = 2;
        srtobj1.Access_Code__c = 'ters';
        srtobj1.SRT_Warrantable__c = '2.3';
        srtobj1.Solution_Number__c = sols.id;
        srtobj1.Adjustment_Reason__c = 'test';
        srtobj1.Job_Order__c = JobId1.id;
        srtobj1.SRT_Select__c = true;
        srtobj1.isPerformed__c = true;
        srtobj1.srt_category__c = 'test';
        srtobj1.type__c = 'test';
        srtobj1.Extended_Hours__c = 1.2;
        srtobj1.SRT_Estimate__c = true;
        srtobj1.Component_Id__c = solcompList[0].Id;
            //srtobj1.IsDuplicateSRT__c ='true';
        
        CSS_SRT__c srtobj2=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj2.SRT_Category__c='AdditionalDiag';
        srtobj2.SRT_Type__c='Diagnosis';
        srtobj2.Assignment__c = 'test1';
        srtobj2.Job_Order__c = JobId1.id;
        srtobj2.Component_Id__c = solComp1.id;
        srtobj2.Solution_Number__c = sols.id;
        srtobj2.SRT_Quantity__c=2;
        srtobj2.FailCode__c='EUCN';
        srtobj2.Type__c='Daignosis';
        srtobj2.Account_Code__c='TEST';
        srtobj2.Component_Id__c = solcompList[0].Id;

        list<CSS_SRT__c> srtlist=new list<CSS_SRT__c>();
        srtlist.add(srtobj1);
        srtlist.add(srtobj2);
        insert srtlist;
        
        
        List<CSS_JobEventTemporary__c> jobEventLst= new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
         jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        //jobevent.Account_Code__c='Test';
        jobevent.key__c='AccountCodes';
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        insert jobevent;
        jobEventLst.add(jobevent);
        
        
        

        //PageReference pageRef = Page.css_srtEditPopup; 
  //pageRef.getParameters().put('JOBId', String.valueOf(JobId1.id));
  //Test.setCurrentPage(pageRef);
        Test.starttest();
        PageReference pref;
        pref = new PageReference('/'+JobId1.id);
        pref.getParameters().put('JobOrderId',JobId1.id);
        Test.setCurrentPage(pref);
        
css_srtEditPopupController obj1=new css_srtEditPopupController();
        CSS_SRT__c srtobj3=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj3.SRT_Category__c='AdditionalDiag';
        srtobj3.SRT_Type__c='Diagnosis';
        srtobj3.Assignment__c = 'test1';
        srtobj3.Job_Order__c = JobId1.id;
        srtobj3.Component_Id__c = solComp1.id;
        srtobj3.Solution_Number__c = sols.id;
        srtobj3.SRT_Quantity__c=2;
        srtobj3.FailCode__c='EUCN';
        srtobj3.Type__c='Daignosis';
        srtobj3.Account_Code__c='TEST';
        srtobj3.Assignment__c = 'NOT CLAIMABLE';
        srtobj3.Component_Id__c = solcompList[0].Id;
        srtlist.add(srtobj3);
        obj1.lstDisplaySRT = srtlist; 
        obj1.searchDiagSRTCodeAndDescription(); 
        String accordionType='AdditionalDiag';
        List<SelectOption> sepoplist=new list<SelectOption>();
       //public srtWrapperClass(Integer counting,Id id,Id jobId,String srtCode,String srtDesc,Integer quantity,String stepId,list<SelectOption> lstFailCodes,list<SelectOption> lstAccountCodes,String selectedFailCode,String selectedAccountCode,String srtType,String accordionType,String accessCode,Decimal accessCodeA,Decimal accessCodeB,Decimal accessCodeC,Decimal accessCodeD,Decimal accessCodeR,Decimal SRTTime,Boolean isPopupSRT){
        //ss_srtEditPopupController.srtWrapperClass obj2=new css_srtEditPopupController.srtWrapperClass(2,JobId1.id,JobId1.id,'srtCode','srtDesc',2,'stepId',sepoplist,sepAclist,'selectedFailCode','selectedAccountCode','srtType','accordionType','accessCode',1.0,1.0,1.0,1.0,1.0,1.0,true);
       obj1.selectedAdmin = true;
        //obj1.selectedPickVal = '00 - Cylinder Block';
        obj1.selectedPickVal = 'test';
        String selGroupCode = 'equal';
        String SRTGroupCode = 'equal';
        obj1.searchDiagValue = '00-10S-00';//
        obj1.accordionType = 'AdditionalDiag';
        obj1.selectedFailCode = 'THAC';
        obj1.loadSavedSRTs();
        //obj1.coverageType='2014-05-08T00:00:00.000-05:00';
        obj1.selectedAccess=true;
        obj1.searchDiagSRTCodeAndDescription(); 
        obj1.typ = 'AdditionalDiag';
        obj1.lstPrivateSRT=srtlist;
        obj1.addSelectedSRTs();
        obj1.lstFilteredSRT=srtlist;
        obj1.saveSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.GSQSRTMapPrepare();
        obj1.removingRow();
        obj1.onChangeofFailCode();
        sepoplist=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
        flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        acoptlist=obj1.getAccountCodeOptionList('test');
        acoptlist=obj1.getAccountCodeDropDown1();
        obj1.ValidateAdminSRT();
        Test.stopTest();
            
    } 
    
    public static TestMethod void Mm1(){
        
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
    //Test.starttest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        CSS_Job_Order__c JobId1=CSS_TestData.createJobOrder(false);
        jobId1.CSS_In_Shop_Labor_Rate__c ='10';
        jobId1.Account__c = acc.id;
        insert jobId1;
        id wid = apexpages.currentpage().getparameters().put('id' , jobId1.id);
     
        list<CSS_Job_Order__c> jolist=new list<CSS_Job_Order__c>();
        jolist.add(JobId1);
        
        system.debug('JOBS: '+jolist);
        
         
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Diagnostic_Response__c = 'Most likely the solution';
        sols.Service_Job__c=JobId1.id;
        insert sols;
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jolist[0].id,sols.id);
        
        list<CSS_Solution_Component__c> solcompList = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Service_Job__c = wid;
        solComp1.System_Code__c = 'TH';
        solComp1.Component_Code__c = 'AC';
        solComp1.Selected_Component__c = true;
        solComp1.Type__c = 'Test';
        solComp1.Root_Cause__c = true;
            //insert solComp1;
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.Service_Job__c = wid;
        solComp2.System_Code__c = 'TH';
        solComp2.Component_Code__c = 'AC';
        solComp2.Selected_Component__c = true;
        solComp2.Type__c = 'Test';
        solComp2.Root_Cause__c = true;
          //insert solComp2;
        solcompList.add(solComp1);
        solcompList.add(solComp2);
        insert solcompList;
        
        //Create SRT record
        CSS_SRT__c srtobj1=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
            srtobj1.SRT_ID__c = '123';
            srtobj1.Assignment__c = 'test1';//'NOT CLAIMABLE';
            srtobj1.Component_Id__c = solComp1.id;
            srtobj1.FailCode__c='EUCN';
            srtobj1.SRT_Title__c = 'test';
            srtobj1.SRT_Quantity__c=1;
            srtobj1.SRT_Time__c = 2;
            srtobj1.Access_Code__c = 'ters';
            srtobj1.SRT_Warrantable__c = '2.3';
            srtobj1.Solution_Number__c = sols.id;
            srtobj1.Adjustment_Reason__c = 'test';
            srtobj1.Job_Order__c = JobId1.id;
            srtobj1.SRT_Select__c = true;
            srtobj1.isPerformed__c = true;
            srtobj1.srt_category__c = 'test';
            srtobj1.type__c = 'test';
            srtobj1.Extended_Hours__c = 1.2;
            srtobj1.SRT_Estimate__c = true;

        
        CSS_SRT__c srtobj2=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
            srtobj2.SRT_Category__c='AdditionalDiag';
            srtobj2.SRT_Type__c='Diagnosis';
            srtobj2.Job_Order__c = JobId1.id;
            srtobj2.Component_Id__c = solComp1.id;
            srtobj2.Solution_Number__c = sols.id;
            srtobj2.SRT_Quantity__c=2;
            srtobj2.FailCode__c='EUCN';
            srtobj2.Account_Code__c='TEST';
        

        list<CSS_SRT__c> srtlist=new list<CSS_SRT__c>();
            srtlist.add(srtobj1);
            srtlist.add(srtobj2);
            insert srtlist;
        
        
        List<CSS_JobEventTemporary__c> jobEventLst= new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
         jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        //jobevent.Account_Code__c='Test';
        jobevent.key__c='AccountCodes';
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        insert jobevent;
        jobEventLst.add(jobevent);
        
        
        
        Test.starttest();
        PageReference pref;
        pref = new PageReference('/'+JobId1.id);
        pref.getParameters().put('JobOrderId',JobId1.id);
        Test.setCurrentPage(pref);
        
css_srtEditPopupController obj1=new css_srtEditPopupController();
        String accordionType='AdditionalDiag';
        List<SelectOption> sepoplist=new list<SelectOption>();
       //public srtWrapperClass(Integer counting,Id id,Id jobId,String srtCode,String srtDesc,Integer quantity,String stepId,list<SelectOption> lstFailCodes,list<SelectOption> lstAccountCodes,String selectedFailCode,String selectedAccountCode,String srtType,String accordionType,String accessCode,Decimal accessCodeA,Decimal accessCodeB,Decimal accessCodeC,Decimal accessCodeD,Decimal accessCodeR,Decimal SRTTime,Boolean isPopupSRT){
        //ss_srtEditPopupController.srtWrapperClass obj2=new css_srtEditPopupController.srtWrapperClass(2,JobId1.id,JobId1.id,'srtCode','srtDesc',2,'stepId',sepoplist,sepAclist,'selectedFailCode','selectedAccountCode','srtType','accordionType','accessCode',1.0,1.0,1.0,1.0,1.0,1.0,true);
       obj1.selectedAdmin = true;
        //obj1.selectedPickVal = '00 - Cylinder Block';
        obj1.selectedPickVal = 'test';
        String selGroupCode = 'equal';
        String SRTGroupCode = 'equal';
        obj1.searchDiagValue = '9023';
        obj1.accordionType = 'TRP';
        obj1.selectedFailCode = 'THAC';
        obj1.loadSavedSRTs();
        //obj1.coverageType='2014-05-08T00:00:00.000-05:00';
        obj1.selectedAccess=true;
        obj1.searchDiagSRTCodeAndDescription(); 
        obj1.typ = 'AdditionalDiag';
        obj1.lstPrivateSRT=srtlist;
        obj1.addSelectedSRTs();
        obj1.lstFilteredSRT=srtlist;
        obj1.saveSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.GSQSRTMapPrepare();
        obj1.removingRow();
        obj1.onChangeofFailCode();
        sepoplist=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
        flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        acoptlist=obj1.getAccountCodeOptionList('test');
        acoptlist=obj1.getAccountCodeDropDown1();
        obj1.ValidateAdminSRT();
        Test.stopTest();
            
    }
  
   public static TestMethod void MM2(){
        
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
    //Test.starttest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        CSS_Job_Order__c JobId1=CSS_TestData.createJobOrder(false);
        jobId1.CSS_In_Shop_Labor_Rate__c ='10';
        jobId1.Account__c = acc.id;
        insert jobId1;
        
        id wid = apexpages.currentpage().getparameters().put('id' , jobId1.id);
     
        list<CSS_Job_Order__c> jolist=new list<CSS_Job_Order__c>();
        jolist.add(JobId1);
        
        system.debug('JOBS: '+jolist);
        
         
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Diagnostic_Response__c = 'Most likely the solution';
        sols.Service_Job__c=JobId1.id;
        insert sols;
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jolist[0].id,sols.id);
        
        list<CSS_Solution_Component__c> solcompList = new list<CSS_Solution_Component__c>();
       
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Service_Job__c = wid;
        solComp1.System_Code__c = 'TH';
        solComp1.Component_Code__c = 'AC';
        solComp1.Selected_Component__c = true;
        solComp1.Type__c = 'Test';
        solComp1.Root_Cause__c = true;
            //insert solComp1;
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.Service_Job__c = wid;
        solComp2.System_Code__c = 'TH';
        solComp2.Component_Code__c = 'AC';
        solComp2.Selected_Component__c = true;
        solComp2.Type__c = 'Test';
        solComp2.Root_Cause__c = true;
          //insert solComp2;
        
        solcompList.add(solComp1);
        solcompList.add(solComp2);
       insert solcompList;
       
        
        //Create SRT record
        CSS_SRT__c srtobj1=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
            srtobj1.SRT_ID__c = '00-901';
            srtobj1.Assignment__c = 'NOT CLAIMABLE';
            srtobj1.Component_Id__c = solComp1.id;
            srtobj1.FailCode__c='EUCN';
            srtobj1.SRT_Title__c = 'test';
            srtobj1.SRT_Quantity__c=1;
            srtobj1.SRT_Time__c = 2;
            srtobj1.Access_Code__c = 'ters';
            srtobj1.SRT_Warrantable__c = '2.3';
            srtobj1.Solution_Number__c = sols.id;
            srtobj1.Adjustment_Reason__c = 'test';
            srtobj1.Job_Order__c = JobId1.id;
            srtobj1.SRT_Select__c = true;
            srtobj1.isPerformed__c = true;
            srtobj1.srt_category__c = 'test';
            srtobj1.type__c = 'test';
            srtobj1.Extended_Hours__c = 1.2;
            srtobj1.SRT_Estimate__c = true;

        
        CSS_SRT__c srtobj2=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
            srtobj2.SRT_Category__c='AdditionalDiag';
            srtobj2.SRT_Type__c='Diagnosis';
            srtobj2.Job_Order__c = JobId1.id;
            srtobj2.Component_Id__c = solComp1.id;
            srtobj2.Solution_Number__c = sols.id;
            srtobj2.SRT_Quantity__c=2;
            srtobj2.FailCode__c='EUCN';
            srtobj2.Account_Code__c='TEST';
        

        list<CSS_SRT__c> srtlist=new list<CSS_SRT__c>();
            srtlist.add(srtobj1);
            srtlist.add(srtobj2);
            insert srtlist;
        
        
        List<CSS_JobEventTemporary__c> jobEventLst= new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
         jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        //jobevent.Account_Code__c='Test';
        jobevent.key__c='AccountCodes';
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        insert jobevent;
        jobEventLst.add(jobevent);
        
        
        


        Test.starttest();
        PageReference pref;
        pref = new PageReference('/'+JobId1.id);
        pref.getParameters().put('JobOrderId',JobId1.id);
        Test.setCurrentPage(pref);
        
css_srtEditPopupController obj1=new css_srtEditPopupController();
       String accordionType='AdditionalDiag';
        List<SelectOption> sepoplist=new list<SelectOption>();
       //public srtWrapperClass(Integer counting,Id id,Id jobId,String srtCode,String srtDesc,Integer quantity,String stepId,list<SelectOption> lstFailCodes,list<SelectOption> lstAccountCodes,String selectedFailCode,String selectedAccountCode,String srtType,String accordionType,String accessCode,Decimal accessCodeA,Decimal accessCodeB,Decimal accessCodeC,Decimal accessCodeD,Decimal accessCodeR,Decimal SRTTime,Boolean isPopupSRT){
        //ss_srtEditPopupController.srtWrapperClass obj2=new css_srtEditPopupController.srtWrapperClass(2,JobId1.id,JobId1.id,'srtCode','srtDesc',2,'stepId',sepoplist,sepAclist,'selectedFailCode','selectedAccountCode','srtType','accordionType','accessCode',1.0,1.0,1.0,1.0,1.0,1.0,true);
       obj1.selectedAdmin = true;
        //obj1.selectedPickVal = '00 - Cylinder Block';
        obj1.selectedPickVal = 'test';
        String selGroupCode = 'equal';
        String SRTGroupCode = 'equal';
        obj1.searchDiagValue = '9023';
        obj1.accordionType = 'ATC';
        obj1.selectedFailCode = 'THAC';
        obj1.loadSavedSRTs();
        //obj1.coverageType='2014-05-08T00:00:00.000-05:00';
        obj1.selectedAccess=true;
        obj1.searchDiagSRTCodeAndDescription(); 
        obj1.typ = 'AdditionalDiag';
        obj1.lstPrivateSRT=srtlist;
        obj1.addSelectedSRTs();
        obj1.lstFilteredSRT=srtlist;
        obj1.saveSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.GSQSRTMapPrepare();
        obj1.removingRow();
        obj1.onChangeofFailCode();
        sepoplist=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
        flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        acoptlist=obj1.getAccountCodeOptionList('test');
        acoptlist=obj1.getAccountCodeDropDown1();
        obj1.ValidateAdminSRT();
        Test.stopTest();
            
    } 
     
    public static TestMethod void M2(){
        
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
    //Test.starttest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        CSS_Job_Order__c JobId1=CSS_TestData.createJobOrder(false);
        JobId1.Account__c = acc.id;
        insert JobId1;
        
        id wid = apexpages.currentpage().getparameters().put('id' , jobId1.id);
        
        CSS_Job_Order__c JobId2=CSS_TestData.createJobOrder(false);
        list<CSS_Job_Order__c> jolist=new list<CSS_Job_Order__c>();
        jolist.add(JobId1);
        jolist.add(JobId2);
       
        system.debug('JOBS: '+jolist);
        
  //css_srtEditPopupController obj1=new css_srtEditPopupController();

         
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=JobId1.id;
        insert sols;
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jolist[1].id,sols.id);
        list<CSS_Solution_Component__c> solcompList = new list<CSS_Solution_Component__c>();
       
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Service_Job__c = wid;
        solComp1.System_Code__c = 'TH';
        solComp1.Component_Code__c = 'AC';
        solComp1.Selected_Component__c = true;
        solComp1.Type__c = 'Test';
        solComp1.Root_Cause__c = true;
            //insert solComp1;
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.Service_Job__c = wid;
        solComp2.System_Code__c = 'TH';
        solComp2.Component_Code__c = 'AC';
        solComp2.Selected_Component__c = true;
        solComp2.Type__c = 'Test';
        solComp2.Root_Cause__c = true;
          //insert solComp2;
		  
        solcompList.add(solComp1);
        solcompList.add(solComp2);
        insert solcompList;
        
      
        
        //Create SRT record
        CSS_SRT__c srtobj1=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj1.SRT_ID__c = '00-902';
        srtobj1.Assignment__c = 'test';
        srtobj1.Component_Id__c = solComp1.id;
        srtobj1.FailCode__c='Select One';
        srtobj1.SRT_Title__c = 'test';
        srtobj1.SRT_Quantity__c=1;
        srtobj1.SRT_Time__c = 2;
        srtobj1.Access_Code__c = 'ters';
        srtobj1.SRT_Warrantable__c = '2.3';
        srtobj1.Adjustment_Reason__c = 'test';
        srtobj1.Job_Order__c = JobId1.id;
        srtobj1.SRT_Select__c = true;
        srtobj1.isPerformed__c = true;
        srtobj1.srt_category__c = 'test';
        srtobj1.type__c = 'test';
        srtobj1.Extended_Hours__c = 1.2;
        srtobj1.SRT_Estimate__c = true;

        
        CSS_SRT__c srtobj2=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj2.SRT_Category__c='AdditionalRep';
        srtobj2.SRT_Type__c='Repair';
        srtobj2.Job_Order__c = JobId1.id;
        srtobj2.Component_Id__c = solComp1.id;
        srtobj2.SRT_Quantity__c=2;
        srtobj2.FailCode__c='EUCN';
        srtobj2.Account_Code__c='TEST';
        srtobj2.SRT_Select__c = true;
        
        CSS_SRT__c srt1= new CSS_SRT__c();
            srt1.SRT_Category__c='AdditionalRep';
            srt1.SRT_Type__c='Repair';
            srt1.Job_Order__c = JobId1.id;
            srt1.Component_Id__c = solComp1.id;
            srt1.Solution_Number__c = sols.id;
            srt1.SRT_Quantity__c=2;
            srt1.FailCode__c='EUCN';
            srt1.Account_Code__c='TEST';
            srt1.srt_select__c = true;
            srt1.SRT_Title__c = 'TITLE';
            

        list<CSS_SRT__c> srtlist=new list<CSS_SRT__c>();
        srtlist.add(srtobj1);
        srtlist.add(srtobj2);
        srtList.add(srt1);
        insert srtlist;
        
        
        List<CSS_JobEventTemporary__c> jobEventLst= new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
         jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        //jobevent.Account_Code__c='Test';
        jobevent.key__c='AccountCodes';
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        insert jobevent;
        jobEventLst.add(jobevent);
        
        
        Test.starttest();
        PageReference pref;
        pref = new PageReference('/'+JobId1.id);
        pref.getParameters().put('JobOrderId',JobId1.id);
        Test.setCurrentPage(pref);
        

        List<SelectOption> sepoplist=new list<SelectOption>();
        list<css_srtEditPopupController.srtWrapperClass> listwrap=new list<css_srtEditPopupController.srtWrapperClass>();
     //   css_srtEditPopupController.srtWrapperClass srtwrap=new css_srtEditPopupController.srtWrapperClass(2,JobId2.id,JobId2.id,'00-724','srtDes',2,'stepId',sepoplist,sepoplist,'selectedFailCode','selectedAccountCode','srtType','accordionType','accessCode',0.01,0.02,0.03,0.04,0.05,0.10,true,true, true,'12');//(2,JobId2.id,JobId2.id,'srtCode','srtDesc',2,'stepId',sepoplist,sepoplist,'selectedFailCode','selectedAccountCode','srtType','accordionType','test',1.0,1.0,1.0,1.0,1.0,1.0,false);
  //      css_srtEditPopupController.srtWrapperClass srtwrap=new css_srtEditPopupController.srtWrapperClass(2,JobId2.id,JobId2.id,srt1.id,'TITLE',3,'stepId',null,sepoplist,'selectedFailCode','selectedAccountCode','srtType','accordionType','AccCode','A','B','C','D','E',2.1,true,true,true,2,true);
        
  //      listwrap.add(srtwrap);
        css_srtEditPopupController obj1=new css_srtEditPopupController();
        String accordionType='AdditionalDiag';
        obj1.selectedAdmin = true;
        //obj1.selectedPickVal = '00 - Cylinder Block';
        obj1.selectedPickVal = 'All';
        //obj1.searchDiagValue = '902';
        obj1.accordionType = 'AdditionalRep';
        obj1.selectedFailCode = 'THAC';
        obj1.loadSavedSRTs();
        //obj1.coverageType='2014-05-08T00:00:00.000-05:00';
        obj1.selectedAccess=true;
        obj1.searchDiagSRTCodeAndDescription();  
        obj1.typ = 'AdditionalRep';
        obj1.lstFilteredSRT = srtlist;
        obj1.lstSolCompTest.addAll(solcompList);
        obj1.addSelectedSRTs();
        obj1.accordionType = 'test';
        obj1.addSelectedSRTs();
        obj1.lstFilteredSRT=srtlist;
        obj1.saveSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.removingRow();
        obj1.onChangeofFailCode();
        sepoplist=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
        flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        acoptlist=obj1.getAccountCodeOptionList('test');
        acoptlist=obj1.getAccountCodeDropDown1();
        Test.stopTest();
            
    } 
    
    public static TestMethod void M21(){
        
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
    //Test.starttest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        CSS_Job_Order__c JobId1=CSS_TestData.createJobOrder(false);
        JobId1.Account__c = acc.id;
        insert JobId1;
        
        id wid = apexpages.currentpage().getparameters().put('id' , jobId1.id);
        
        CSS_Job_Order__c JobId2=CSS_TestData.createJobOrder(false);
        list<CSS_Job_Order__c> jolist=new list<CSS_Job_Order__c>();
        jolist.add(JobId1);
        jolist.add(JobId2);
       
        system.debug('JOBS: '+jolist);
        
  //css_srtEditPopupController obj1=new css_srtEditPopupController();

         
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=JobId1.id;
        insert sols;
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jolist[1].id,sols.id);
        
        
        list<CSS_Solution_Component__c> solcompList = new list<CSS_Solution_Component__c>();
       
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Service_Job__c = wid;
        solComp1.System_Code__c = 'TH';
        solComp1.Component_Code__c = 'AC';
        solComp1.Selected_Component__c = true;
        solComp1.Type__c = 'Test';
        solComp1.Root_Cause__c = true;
            //insert solComp1;
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.Service_Job__c = wid;
        solComp2.System_Code__c = 'TH';
        solComp2.Component_Code__c = 'AC';
        solComp2.Selected_Component__c = true;
        solComp2.Type__c = 'Test';
        solComp2.Root_Cause__c = true;
          //insert solComp2;
		  
        solcompList.add(solComp1);
        solcompList.add(solComp2);
       insert solcompList;
        
        //Create SRT record
        CSS_SRT__c srtobj1=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj1.SRT_ID__c = '00-902';
        srtobj1.Assignment__c = 'test';
        srtobj1.Component_Id__c = solComp1.id;
        srtobj1.FailCode__c='Select One';
        srtobj1.SRT_Title__c = 'test';
        srtobj1.SRT_Quantity__c=1;
        srtobj1.SRT_Time__c = 2;
        srtobj1.Access_Code__c = 'ters';
        srtobj1.SRT_Warrantable__c = '2.3';
        srtobj1.Adjustment_Reason__c = 'test';
        srtobj1.Job_Order__c = JobId1.id;
        srtobj1.SRT_Select__c = true;
        srtobj1.isPerformed__c = true;
        srtobj1.srt_category__c = 'test';
        srtobj1.type__c = 'test';
        srtobj1.Extended_Hours__c = 1.2;
        srtobj1.SRT_Estimate__c = true;

        
        CSS_SRT__c srtobj2=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj2.SRT_Category__c='AdditionalRep';
        srtobj2.SRT_Type__c='Repair';
        srtobj2.Job_Order__c = JobId1.id;
        srtobj2.Component_Id__c = solComp1.id;
        srtobj2.SRT_Quantity__c=2;
        srtobj2.FailCode__c='EUC-NA';
        srtobj2.Account_Code__c='TEST';
        srtobj2.SRT_Select__c = true;
        
        CSS_SRT__c srt1= new CSS_SRT__c();
            srt1.SRT_Category__c='AdditionalRep';
            srt1.SRT_Type__c='Repair';
            srt1.Job_Order__c = JobId1.id;
            srt1.Component_Id__c = solComp1.id;
            srt1.Solution_Number__c = sols.id;
            srt1.SRT_Quantity__c=2;
            srt1.FailCode__c='EUC-NA';
            srt1.Account_Code__c='TEST';
            srt1.srt_select__c = true;
            

        list<CSS_SRT__c> srtlist=new list<CSS_SRT__c>();
        srtlist.add(srtobj1);
        srtlist.add(srtobj2);
        srtList.add(srt1);
        insert srtlist;
        
        
        List<CSS_JobEventTemporary__c> jobEventLst= new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
         jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        //jobevent.Account_Code__c='Test';
        jobevent.key__c='AccountCodes';
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        insert jobevent;
        jobEventLst.add(jobevent);
       
        Test.starttest();
        PageReference pref;
        pref = new PageReference('/'+JobId1.id);
        pref.getParameters().put('JobOrderId',JobId1.id);
        Test.setCurrentPage(pref);
        
css_srtEditPopupController obj1=new css_srtEditPopupController();
         String accordionType='AdditionalDiag';
        List<SelectOption> sepoplist=new list<SelectOption>();
        //css_srtEditPopupController.srtWrapperClass obj2=new css_srtEditPopupController.srtWrapperClass(2,JobId2.id,JobId2.id,'srtCode','srtDesc',2,'stepId',sepoplist,sepoplist,'selectedFailCode','selectedAccountCode','srtType','accordionType','test',1.0,1.0,1.0,1.0,1.0,1.0,false);
obj1.selectedAdmin = true;
        //obj1.selectedPickVal = '00 - Cylinder Block';
        obj1.selectedPickVal = 'All';
        //obj1.searchDiagValue = '902';
        obj1.accordionType = 'AdditionalRep';
        obj1.selectedFailCode = 'THACK';
        obj1.loadSavedSRTs();
        //obj1.coverageType='2014-05-08T00:00:00.000-05:00';
        obj1.selectedAccess=true;
        obj1.searchDiagSRTCodeAndDescription();  
        obj1.typ = 'AdditionalRep';
        obj1.lstFilteredSRT = srtlist;
        obj1.addSelectedSRTs();
        obj1.lstFilteredSRT=srtlist;
        obj1.saveSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.removingRow();
        obj1.onChangeofFailCode();
        sepoplist=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
        flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        acoptlist=obj1.getAccountCodeOptionList('test');
        acoptlist=obj1.getAccountCodeDropDown1();
        Test.stopTest();
            
    } 
    
    public static TestMethod void M3(){
        
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
    //Test.starttest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JobId1=CSS_TestData.createJobOrder(false);
        JobId1.Account__c = acc.id;
        insert JobId1;
        
        id wid = apexpages.currentpage().getparameters().put('id' , jobId1.id);
        
        CSS_Job_Order__c JobId2=CSS_TestData.createJobOrder(false);
        list<CSS_Job_Order__c> jolist=new list<CSS_Job_Order__c>();
        jolist.add(JobId1);
        jolist.add(JobId2);
       
        system.debug('JOBS: '+jolist);
        
  //css_srtEditPopupController obj1=new css_srtEditPopupController();

         
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=JobId1.id;
        insert sols;
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jolist[1].id,sols.id);
        
        list<CSS_Solution_Component__c> solcompList = new list<CSS_Solution_Component__c>();
       
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Service_Job__c = wid;
        solComp1.System_Code__c = 'TH';
        solComp1.Component_Code__c = 'AC';
        solComp1.Selected_Component__c = true;
        solComp1.Type__c = 'Test';
        solComp1.Root_Cause__c = true;
            //insert solComp1;
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.Service_Job__c = wid;
        solComp2.System_Code__c = 'TH';
        solComp2.Component_Code__c = 'AC';
        solComp2.Selected_Component__c = true;
        solComp2.Type__c = 'Test';
        solComp2.Root_Cause__c = true;
          //insert solComp2;
		  
        solcompList.add(solComp1);
        solcompList.add(solComp2);
       insert solcompList;
        
        //Create SRT record
        CSS_SRT__c srtobj1=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj1.SRT_ID__c = '00-10S-00';
        srtobj1.Assignment__c = 'test';
        srtobj1.Component_Id__c = solComp1.id;
        srtobj1.FailCode__c='Select One';
        srtobj1.SRT_Title__c = '00-10S-00';
        srtobj1.SRT_Quantity__c=1;
        srtobj1.SRT_Time__c = 2;
        srtobj1.Access_Code__c = 'ters';
        srtobj1.SRT_Warrantable__c = '2.3';
        srtobj1.Adjustment_Reason__c = 'test';
        srtobj1.Job_Order__c = JobId1.id;
        srtobj1.SRT_Select__c = true;
        srtobj1.isPerformed__c = true;
        srtobj1.srt_category__c = 'test';
        srtobj1.type__c = 'test';
        srtobj1.Extended_Hours__c = 1.2;
        srtobj1.SRT_Estimate__c = true;

        
        CSS_SRT__c srtobj2=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj2.SRT_Category__c='Campaign';
        srtobj2.SRT_Type__c='Campaign';
        srtobj2.Job_Order__c = JobId1.id;
        srtobj2.Component_Id__c = solComp1.id;
        srtobj2.SRT_Quantity__c=2;
        srtobj2.FailCode__c='EUCN';
        srtobj2.Account_Code__c='TEST';
        

        list<CSS_SRT__c> srtlist=new list<CSS_SRT__c>();
        srtlist.add(srtobj1);
        srtlist.add(srtobj2);
        insert srtlist;
        
        
        List<CSS_JobEventTemporary__c> jobEventLst= new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
         jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        //jobevent.Account_Code__c='Test';
        //jobevent.key__c='79464646'+':'+cl.id;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        insert jobevent;
        jobEventLst.add(jobevent);
        
        
        

        Test.starttest();
        PageReference pref;
        pref = new PageReference('/'+JobId1.id);
        pref.getParameters().put('JobOrderId',JobId1.id);
        Test.setCurrentPage(pref);
        
css_srtEditPopupController obj1=new css_srtEditPopupController();
        String accordionType='AdditionalDiag';
        List<SelectOption> sepoplist=new list<SelectOption>();
        //css_srtEditPopupController.srtWrapperClass obj2=new css_srtEditPopupController.srtWrapperClass(2,JobId2.id,JobId2.id,'srtCode','srtDesc',2,'stepId',sepoplist,sepoplist,'selectedFailCode','selectedAccountCode','srtType','accordionType','accesscode',1.0,1.0,1.0,1.0,1.0,1.0,true);
        obj1.selectedAdmin = true;
        //obj1.selectedPickVal = '00 - Cylinder Block';
        obj1.selectedPickVal = 'All';
        obj1.searchDiagValue = '00-10S-00';//
        obj1.accordionType = 'Campaign';
        obj1.Typ= 'Campaign';
        obj1.selectedFailCode = 'THAC';
        obj1.loadSavedSRTs();
        //obj1.coverageType='2014-05-08T00:00:00.000-05:00';
        obj1.selectedAccess=true;
    obj1.searchDiagSRTCodeAndDescription();  
        
        obj1.lstPrivateSRT=srtlist;
        
        
        obj1.addSelectedSRTs();
        obj1.lstFilteredSRT=srtlist;
        obj1.saveSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.removingRow();
        obj1.onChangeofFailCode();
        sepoplist=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
        flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        Map<String,Set<String>> failAccountCodeMap = new Map<String,Set<String>>();
        failAccountCodeMap.put('test', new Set<String>{'Personal',
                                         'Non_Personal'});
        obj1.failAccountCodeMap=failAccountCodeMap;
        acoptlist=obj1.getAccountCodeOptionList('test');
         obj1.failAccountCodeMap=failAccountCodeMap;
        obj1.seleFailCode='test';
        acoptlist=obj1.getAccountCodeDropDown1();
        Test.stopTest();
            
    } 
    
   public static testmethod void TestcheckDuplicateSRTs(){
       Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JobId1=CSS_TestData.createJobOrder(true);
        JobId1.Account__c = acc.id;
        update JobId1;
        
       CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=JobId1.id;
        sols.Diagnostic_Response__c = 'Most likely the solution';
        insert sols;
        
       CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F19000990',Type__c = 'Campaign',Solutions__c=sols.Id,Service_Job__c=jobid1.id,System_Code__c ='TH',Component_Code__c='AC',Selected_Component__c=true,AccountCode__c='Test');
        insert solComp1;
        
       list<CSS_SRT__c> SRTList = new  list<CSS_SRT__c>();
       CSS_SRT__c srt1= new CSS_SRT__c();
            srt1.SRT_Category__c='AdditionalRep';
            srt1.SRT_Type__c='Repair';
            srt1.Job_Order__c = JobId1.id;
            srt1.Component_Id__c = solComp1.id;
            srt1.Solution_Number__c = sols.id;
            srt1.SRT_Quantity__c=2;
            srt1.FailCode__c='EUCN';
            srt1.Account_Code__c='TEST';
            srt1.srt_select__c = true;
            SRTList.add(srt1);
            insert SRTList;
            
        list<CSS_SRT__c> lstSRTDupCheck = new list<CSS_SRT__c>();
        
        CSS_SRT__c srt2= new CSS_SRT__c();
            srt2.Job_Order__c = JobId1.id;
            srt2.Component_Id__c = solComp1.id;
            srt2.SRT_ID__c = '00-901-00';
            srt2.Solution_Number__c = sols.id;
            srt2.Type__c = 'Diagnosis';
            srt2.srt_select__c = true;
            lstSRTDupCheck.add(srt2);
            insert lstSRTDupCheck;
            
             set<string> SRTIDs = new set<string>();
             SRTIDs.add('00-901-00');
        
        
        test.starttest();
        css_srtEditPopupController SEPC = new css_srtEditPopupController();
        SEPC.lstFilteredSRT = SRTList;
        //SEPC.SRTIDs = SRTIDs;
        SEPC.checkDuplicateSRTs();
        test.stoptest();
     } 
      
    
   /*  static TestMethod void M2(){
      
     List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo = CSS_TestData.createJobOrder(false);
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        insert jo;
        lstjo.add(jo);
        
         CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=Jo.id;
        insert sols;
        
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F19000990',Type__c = null,Solutions__c=sols.Id,Service_Job__c=jo.id,System_Code__c ='TH',Component_Code__c='AC',Selected_Component__c=true,AccountCode__c='Test');
        insert solComp1;
        
        List<CSS_SRT__c> srt1=new List<CSS_SRT__c>();
         CSS_SRT__c SRT = new CSS_SRT__c();
 srt.SRT_ID__c = '123';
        srt.Assignment__c = 'test';
        srt.Component_Id__c = solComp1.id;
        srt.FailCode__c= null;
        srt.SRT_Title__c = 'test';
        srt.SRT_Quantity__c=1;
        srt.SRT_Time__c = 2;
        srt.Access_Code__c = 'ters';
        srt.SRT_Hours_Percentage__c = 2.3;
        srt.Adjustment_Reason__c = 'test';
        srt.Job_Order__c = Jo.id;
        srt.SRT_Select__c = true;
        srt.isPerformed__c = true;
        srt.srt_category__c = 'test';
        srt.type__c = 'test';
        srt.Extended_Hours__c = 1.2;
        srt.SRT_Estimate__c = true;
        //srt.SRT_Category__c ='AdditionalDiag';
        srt1.add(srt);
        insert srt1;
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jo.id,sols.id);
        
        
        css_srtEditPopupController obj2=new css_srtEditPopupController();
        List<SelectOption> sepoplist=new list<SelectOption>();
        css_srtEditPopupController.srtWrapperClass obj3=new css_srtEditPopupController.srtWrapperClass(2,Jo.id,Jo.id,'srtCode','srtDesc',2,'stepId',sepoplist,sepoplist,'selectedFailCode','selectedAccountCode','srtType','accordionType',1.0,1.0,1.0,1.0,1.0,1.0);
obj3.srtType='Campaign';
        obj2.addSelectedSRTs();
        obj2.saveSelectedSRTs();
        obj2.saveAndCloseSelectedSRTs();
        obj2.removingRow();
        obj2.searchDiagSRTCodeAndDescription();
        obj2.onChangeofFailCode();
        sepoplist=obj2.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
        flcdrdn=obj2.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        acoptlist=obj2.getAccountCodeOptionList('test');
        acoptlist=obj2.getAccountCodeDropDown1();
        
        
    }   */
public static TestMethod void M121(){
        
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
    //Test.starttest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        CSS_Job_Order__c JobId1=CSS_TestData.createJobOrder(false);
        jobId1.CSS_In_Shop_Labor_Rate__c ='10';
        jobId1.Account__c = acc.id;
        insert jobId1;
        
        id wid = apexpages.currentpage().getparameters().put('id' , jobId1.id);
        
        list<CSS_Job_Order__c> jolist=new list<CSS_Job_Order__c>();
        jolist.add(JobId1);
        
        system.debug('JOBS: '+jolist);
        
         
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Diagnostic_Response__c = 'Most likely the solution';
        sols.Service_Job__c=JobId1.id;
        
        insert sols;
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jolist[0].id,sols.id);
        
        list<CSS_Solution_Component__c> solcompList = new list<CSS_Solution_Component__c>();
       
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Service_Job__c = JobId1.id;
        solComp1.System_Code__c = 'TH';
        solComp1.Component_Code__c = 'AC';
        solComp1.Selected_Component__c = true;
        solComp1.Type__c = 'test';
        solComp1.Root_Cause__c = true;
        solComp1.Performed_Review__c=true;
    	solComp1.AccountCode__c='12234';
    	solComp1.AccountCodeType__c='Test';
    	solComp1.AccountCodeEdit__c='Test';
            //insert solComp1;
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.Service_Job__c = JobId1.id;
        solComp2.System_Code__c = 'TH';
        solComp2.Component_Code__c = 'AC';
        solComp2.Selected_Component__c = true;
        solComp2.Type__c = 'test';
        solComp2.Root_Cause__c = true;
        solComp2.Performed_Review__c=true;
        solComp2.AccountCode__c='12234';
    	solComp2.AccountCodeType__c='Test';
    	solComp2.AccountCodeEdit__c='Test';
          //insert solComp2;
		  
        solcompList.add(solComp1);
        solcompList.add(solComp2);
        insert solcompList;
        
        //Create SRT record
        list<CSS_SRT__c> srtlist=new list<CSS_SRT__c>();
        CSS_SRT__c srtobj1=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
            srtobj1.SRT_ID__c = '00-00-724';
            srtobj1.Assignment__c = 'Primary';//'NOT CLAIMABLE';
            srtobj1.Component_Id__c = solComp1.id;
            srtobj1.FailCode__c='EUCN';
            srtobj1.SRT_Title__c = 'test';
            srtobj1.SRT_Quantity__c=1;
            srtobj1.SRT_Time__c = 2;
            srtobj1.Access_Code__c = 'ters';
            srtobj1.SRT_Warrantable__c = '2.3';
            srtobj1.Solution_Number__c = sols.id;
            srtobj1.Adjustment_Reason__c = 'test';
            srtobj1.Job_Order__c = JobId1.id;
            srtobj1.SRT_Select__c = true;
            srtobj1.isPerformed__c = true;
            srtobj1.srt_category__c = 'test';
            srtobj1.type__c = 'Diagnosis';
            srtobj1.Extended_Hours__c = 1.2;
            srtobj1.SRT_Estimate__c = true;
           srtobj1.CSS_Claims__c=null;
           
            //srtobj1.IsDuplicateSRT__c ='true';
            srtList.add(srtobj1);
        
        CSS_SRT__c srtobj2=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
            srtobj2.SRT_ID__c = '00-901';
            srtobj2.IsPopUpSRT__c=false;
            srtobj2.SRT_Category__c='AdditionalDiag';
            srtobj2.SRT_Type__c='Diagnosis';
            srtobj2.Job_Order__c = JobId1.id;
            srtobj2.Component_Id__c = solComp1.id;
            srtobj2.Solution_Number__c = sols.id;
            srtobj2.SRT_Quantity__c=2;
            srtobj2.FailCode__c='EUCN';
            srtobj2.Account_Code__c='TEST';
        
            srtlist.add(srtobj2);
           CSS_SRT__c srtobj3=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
            srtobj3.SRT_ID__c = '00-00-724';
            srtobj3.Assignment__c = 'Primary';//'NOT CLAIMABLE';
            srtobj3.Component_Id__c = solComp1.id;
            srtobj3.FailCode__c='EUCN';
            srtobj3.SRT_Title__c = 'test';
            srtobj3.SRT_Quantity__c=1;
            srtobj3.SRT_Time__c = 2;
            srtobj3.Access_Code__c = 'ters';
            srtobj3.SRT_Warrantable__c = '2.3';
            srtobj3.Solution_Number__c = sols.id;
            srtobj3.Adjustment_Reason__c = 'test';
            srtobj3.Job_Order__c = JobId1.id;
            srtobj3.SRT_Select__c = true;
            srtobj3.isPerformed__c = true;
            srtobj3.srt_category__c = 'test';
            srtobj3.type__c = 'Diagnosis';
            srtobj3.Extended_Hours__c = 1.2;
            srtobj3.SRT_Estimate__c = true;
           srtobj3.CSS_Claims__c=null;
           srtobj3.IsPopUpSRT__c=true;
            //srtobj3.IsDuplicateSRT__c ='true';
            srtList.add(srtobj3);
            insert srtlist;
        
        
        List<CSS_JobEventTemporary__c> jobEventLst= new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
         jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        //jobevent.Account_Code__c='Test';
        jobevent.key__c='AccountCodes';
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        insert jobevent;
        jobEventLst.add(jobevent);
        
        
        

        /*PageReference pageRef = Page.css_srtEditPopup; 
  pageRef.getParameters().put('JOBId', String.valueOf(JobId1.id));
  Test.setCurrentPage(pageRef);*/
        Test.starttest();
        PageReference pref;
        pref = new PageReference('/'+JobId1.id);
        pref.getParameters().put('JobOrderId',JobId1.id);
        Test.setCurrentPage(pref);
        
css_srtEditPopupController obj1=new css_srtEditPopupController();
           
        List<SelectOption> sepoplist=new list<SelectOption>();
    //       list<css_srtEditPopupController.srtWrapperClass> listwrap=new list<css_srtEditPopupController.srtWrapperClass>();
    //    css_srtEditPopupController.srtWrapperClass srtwrap=new css_srtEditPopupController.srtWrapperClass(2,JobId1.id,JobId1.id,'00-724','srtDes',2,'stepId',sepoplist,sepoplist,'selectedFailCode','selectedAccountCode','srtType','accordionType','accessCode',0.01,0.02,0.03,0.04,0.05,0.10,true,true, true,'12');//(2,JobId2.id,JobId2.id,'srtCode','srtDesc',2,'stepId',sepoplist,sepoplist,'selectedFailCode','selectedAccountCode','srtType','accordionType','test',1.0,1.0,1.0,1.0,1.0,1.0,false);
   //     listwrap.add(srtwrap);
       //public srtWrapperClass(Integer counting,Id id,Id jobId,String srtCode,String srtDesc,Integer quantity,String stepId,list<SelectOption> lstFailCodes,list<SelectOption> lstAccountCodes,String selectedFailCode,String selectedAccountCode,String srtType,String accordionType,String accessCode,Decimal accessCodeA,Decimal accessCodeB,Decimal accessCodeC,Decimal accessCodeD,Decimal accessCodeR,Decimal SRTTime,Boolean isPopupSRT){
        //ss_srtEditPopupController.srtWrapperClass obj2=new css_srtEditPopupController.srtWrapperClass(2,JobId1.id,JobId1.id,'srtCode','srtDesc',2,'stepId',sepoplist,sepAclist,'selectedFailCode','selectedAccountCode','srtType','accordionType','accessCode',1.0,1.0,1.0,1.0,1.0,1.0,true);
       obj1.selectedAdmin = true;
        //obj1.selectedPickVal = '00 - Cylinder Block';
        obj1.selectedPickVal = 'test';
        String selGroupCode = 'equal';
        String SRTGroupCode = 'equal';
        obj1.searchDiagValue = '9023';
        obj1.accordionType = 'AdditionalDiag';
        obj1.selectedFailCode = 'THAC';
        obj1.loadSavedSRTs();
        //obj1.coverageType='TRP';
        obj1.selectedAccess=true;
    obj1.searchDiagSRTCodeAndDescription(); 
    //obj1.typ = 'AdditionalDiag';
        obj1.lstPrivateSRT=srtlist;
        obj1.addSelectedSRTs();
        obj1.lstFilteredSRT=srtlist;
        obj1.saveSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.GSQSRTMapPrepare();
        obj1.removingRow();
        obj1.onChangeofFailCode();
        sepoplist=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
        String accordionType='AdditionalDiag';  
           obj1.accordionType  = accordionType;
        flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        acoptlist=obj1.getAccountCodeOptionList('test');
        acoptlist=obj1.getAccountCodeDropDown1();
        obj1.ValidateAdminSRT();
        obj1.getErrorDetails();
        obj1.SelectedSRTAdminVal();
        Test.stopTest();
           
            
    }
    
}