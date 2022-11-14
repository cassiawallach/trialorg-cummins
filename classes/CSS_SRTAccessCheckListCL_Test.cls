@istest
public class CSS_SRTAccessCheckListCL_Test {
   /* static testmethod void test1()
    {
        CSS_SRTAccessCheckListCL clnew = new CSS_SRTAccessCheckListCL();
        clnew.lstSRT = null;
        clnew.saveNClose();
        clnew.Cancel();
        //clnew.checkDuplicateSRTs();
        clnew.srtError('testing');
    }
     */   

    static testmethod void saveNCloseMethod(){
                   Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;

        test.startTest();
        List<CSS_Job_Order__c> lstorder = new List<CSS_Job_Order__c>();
         css_job_order__c joorder = CSS_TestData.createJobOrder(false);
        joorder.Equipment_ID__c='EQ5437';
        joorder.Account__c=acc.Id;
        joorder.Service_Model__c='ISX15 CM2350 X101';
        joorder.Qsol_Engine_Family_Code__c='10';
        joorder.Status__c='Intake Complete';
        joorder.Accesscode__c='A';
        insert joorder;
        lstorder.add(joorder);
            css_solutions__c sol = CSS_TestData.createSolutions(true, joorder.Id);
            CSS_Solution_Component__c solcomp = css_testdata.createSRT(true,joorder.Id, sol.id);
            CSS_SRT__c srt = css_testdata.createSRT(false, 'Field Action', sol.id, joorder.id);
                    srt.SRT_AccessiblityCheck__c=true;
                    srt.Access_Code_A__c =65;
                    srt.SRT_Access_Code__c='A';
                    srt.name = 'Test'+Math.random();
                    srt.Type__c ='Field Action';
                    srt.srt_category__c='Campaign';
                    srt.component_id__c = null;
                    srt.isPopupSRT__c = true;
                    srt.CSS_Claims__c=null;
                    srt.SRT_ID__c='19-052-00';
                      srt.step_id__c='119986';
                    srt.isPerformed__c =True;
                    srt.SRT_Details__c='Testdetails';
        insert srt;
        CSS_SRT__c srtDel = new CSS_SRT__c();
        srtDel.Id=srt.id;
        list<CSS_SRT__c> srtlistR = new list<CSS_SRT__c>();
        list<CSS_SRT__c> srtlistD = new list<CSS_SRT__c>();
        srtlistR.add(srt);
            CSS_SRTAccessCheckListCL clnew = new CSS_SRTAccessCheckListCL();
        clnew.lstJob=lstorder;
        clnew.NoRecordsfound = true;
        clnew.lstDisplaySRT = srtlistR;
        //delete srtDel;
        //srtlistD.add(srtDel);
        clnew.lstSRT = srtlistD;
        system.debug('**lstSRT**'+clnew.lstSRT);
        clnew.saveNClose();
        clnew.searchAccChklistSRTCodeAndDescription();
        clnew.getErrorDetails();
        test.stopTest();
    }
  
    static testmethod void test12()
    {
                   Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;

        css_job_order__c joorder = CSS_TestData.createJobOrder(false);
        joorder.Account__c=acc.Id;
        joorder.Equipment_ID__c='EQ2564';
        joorder.Service_Model__c='test123';
        joorder.Qsol_Engine_Family_Code__c='Test123';
        insert joorder;
        
        system.debug('***joorder***'+joorder);
        css_solutions__c sol = CSS_TestData.createSolutions(true, joorder.Id);
        system.debug('***sol***'+sol);
        CSS_Solution_Component__c solcomp = css_testdata.createSRT(true,joorder.Id, sol.id);
        CSS_SRT__c srt = css_testdata.createSRT(true, 'Field Action', sol.Id, joorder.id);
        srt.SRT_Details__c='test';
        update srt;
        CSS_SRT__c srt1 = css_testdata.createSRT(true, 'Field Action', sol.Id, joorder.id);
        srt1.SRT_Details__c='test1';
        update srt1;
        list<CSS_SRT__c> srtlist = new list<CSS_SRT__c>();
        list<CSS_SRT__c> srtlist1 = new list<CSS_SRT__c>();
        srtlist.add(srt);
         srtlist1.add(srt1);
        pagereference ref = page.CSS_SRTAccessCheckList;
        ApexPages.CurrentPage().getParameters().put('JobOrderId',+joorder.id);
        ApexPages.CurrentPage().getParameters().put('solutionId',+sol.id);
        ApexPages.CurrentPage().getParameters().put('componentId',+solcomp.id);
        ApexPages.CurrentPage().getParameters().put('typ','camp');
        ApexPages.CurrentPage().getParameters().put('pgName','rj');
        test.startTest();
        CSS_SRTAccessCheckListCL clnew = new CSS_SRTAccessCheckListCL();
        Boolean blnFound;
        clnew.saveNClose();
        clnew.Cancel();
        blnFound=true;
        //clnew.checkDuplicateSRTs();
        
        
        clnew.srtError('testing');
        
        clnew.lstDisplaySRT = srtlist;
        clnew.lstSRT=srtlist;
        clnew.saveNClose();
        clnew.srtError('testing');
        
          clnew.lstDisplaySRT = srtlist;
        clnew.lstSRT=srtlist1;

        clnew.saveNClose();
        test.stopTest();
        
    }
    static testmethod void test13()
    {
                   Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;

        css_job_order__c joorder = CSS_TestData.createJobOrder(false);
        joorder.Equipment_ID__c='EQ6558';
        joorder.Account__c=acc.Id;
        joorder.Service_Model__c='test123';
        joorder.Qsol_Engine_Family_Code__c='Test123';
        insert joorder;
        css_solutions__c sol = CSS_TestData.createSolutions(true, joorder.Id);
        CSS_Solution_Component__c solcomp = css_testdata.createSRT(true,joorder.Id, sol.id);
        CSS_SRT__c srt = css_testdata.createSRT(true, 'Field Action', sol.Id, joorder.id);
        list<CSS_SRT__c> srtlist = new list<CSS_SRT__c>();
        srtlist.add(srt);
        pagereference ref = page.CSS_SRTAccessCheckList;
        ApexPages.CurrentPage().getParameters().put('JobOrderId',+joorder.id);
        ApexPages.CurrentPage().getParameters().put('solutionId',+sol.id);
        ApexPages.CurrentPage().getParameters().put('componentId',+solcomp.id);
        ApexPages.CurrentPage().getParameters().put('typ','rep');
        ApexPages.CurrentPage().getParameters().put('pgName','rj');
        test.startTest();
         Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        CSS_SRTAccessCheckListCL clnew = new CSS_SRTAccessCheckListCL();
        clnew.saveNClose();
        clnew.Cancel();
        //clnew.checkDuplicateSRTs();
        clnew.srtError('testing');
        
        clnew.lstDisplaySRT = srtlist;
        clnew.lstSRT=srtlist;
        clnew.saveNClose();
        clnew.srtError('testing');
        test.stopTest();
        
    }
    static testmethod void checkDuplicateSRTsMethod(){
                   Account acc = new Account();
            acc.name='Kenworth Sales Co';
            acc.CSS_DistributorCode__c='02466';
            acc.IAM_Service_Provider_Code__c='19134';
            acc.Type='Dealer Account';
            acc.CMI_Account_Status__c = 'Active';
            insert acc;

        Test.startTest();
        css_job_order__c joorder = CSS_TestData.createJobOrder(false);
        joorder.Equipment_ID__c='test123';
        joorder.Account__c=acc.Id;
        joorder.Service_Model__c='test123';
        joorder.Qsol_Engine_Family_Code__c='Test123';
        insert joorder;
        pagereference ref = page.CSS_SRTAccessCheckList;
        id wid = ApexPages.CurrentPage().getParameters().put('JobOrderId',+joorder.id);
        List<CSS_SRT__c> srtlst = new List<CSS_SRT__c>();
        
        CSS_SRT__c obj = new CSS_SRT__c();
        obj.CSS_Claims__c = null;
        obj.SRT_ID__c ='FC-003-00';
        obj.Job_Order__c = wid;
        obj.Solution_Number__c = null;
        obj.component_id__c = null;
        obj.isPopupSRT__c = true;
        obj.srt_category__c = 'Campaign';
        insert obj;
        srtlst.add(obj);
        
        CSS_SRT__c obj1 = new CSS_SRT__c();
        obj1.CSS_Claims__c = null;
        obj1.SRT_ID__c ='FC-003-00';
        obj1.Job_Order__c = wid;
        obj1.Solution_Number__c = null;
        obj1.component_id__c = null;
        obj1.isPopupSRT__c = true;
        obj1.srt_category__c = 'Campaign';
        insert obj1;
        srtlst.add(obj1);
        
        CSS_SRT__c obj2 = new CSS_SRT__c();
        obj2.CSS_Claims__c = null;
        obj2.SRT_ID__c ='99-9099';
        obj2.Job_Order__c = wid;
        obj2.Solution_Number__c = null;
        obj2.component_id__c = null;
        obj2.isPopupSRT__c = true;
        obj2.srt_category__c = 'Campaign';
        insert obj2;
        srtlst.add(obj2);
        css_solutions__c sol = CSS_TestData.createSolutions(true, joorder.Id);
        CSS_Solution_Component__c solcomp = css_testdata.createSRT(true,joorder.Id, sol.id);
        
       //CSS_SRT__c srt = new CSS_SRT__c();
       CSS_SRT__c srt = css_testdata.createSRT(false, 'Field Action', sol.id, joorder.id);
        //srt.srt_category__c='AdditionalDiag';
        //srt.Job_Order__c = joorder.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'Test'+Math.random();
        srt.Type__c ='Field Action';
        srt.srt_category__c='Campaign';
        srt.component_id__c = null;
        srt.isPopupSRT__c = true;
        srt.CSS_Claims__c=null;
        srt.SRT_ID__c='00-724-00';
        srt.isPerformed__c =True;
        insert srt;
               CSS_SRT__c srt1 = new CSS_SRT__c();        
        srt1.Job_Order__c = joorder.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'Test'+Math.random();
        srt1.Type__c ='Field Action';
        srt1.srt_category__c='Campaign';
        srt1.component_id__c = null;
        srt1.isPopupSRT__c = true;
        srt1.CSS_Claims__c=null;
        srt1.SRT_ID__c='19-400';
        srt1.isPerformed__c =True;
        insert srt1;
        system.debug('**srt**'+srt);
        list<CSS_SRT__c> srtlistR = new list<CSS_SRT__c>();
        srtlistR.add(srt);
        srtlistR.add(srt1);
        CSS_SRTAccessCheckListCL clnew = new CSS_SRTAccessCheckListCL();
        system.debug('**srtlistR**'+srtlistR+'**srtlistR size**'+srtlistR.size());
        //clnew.lstDisplaySRT = srtlistR;
        system.debug('**clnew.lstDisplaySRT**'+clnew.lstDisplaySRT);
        List<String> excludeSRTsDuplicateCheckList = new List<String>();
        String ESRTDCLValues ='12-112,12-212';
        excludeSRTsDuplicateCheckList = ESRTDCLValues.split(',');
        clnew.checkDuplicateSRTs();
        Test.stopTest();
    }
  
}