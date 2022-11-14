@istest
global class CG_CL_ClaimsSRTDiagController_Test 
{
    static testmethod void method1(){
        Account acc = new Account();
        acc.Name = 'test'; 
        acc.Type = 'Other';
        insert acc;
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Account__c=acc.id;
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        insert jo;
        lstjo.add(jo);
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
        c1.Account__c=acc.id;
        c1.CSS_Job__c=jo.id;
        c1.SP_INSHOP_LABOR_RATE__c='78787878';
        c1.Catastrophic__c= true;
        insert c1;
        css_psn__c psn = new css_psn__c();
        psn.Equipment_ID__c='88923898923';
        psn.CSS_Claims__c=c1.id;
        insert psn;
        clist.add(c1);
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        List<String> additionalSRTList = new List<String>();
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Account__c=acc.id;
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        claim.SP_INSHOP_LABOR_RATE__c='787878';
        insert claim;
        css_psn__c ps = new css_psn__c();
        ps.CSS_Claims__c=claim.id;
        ps.Equipment_ID__c='6665';
        insert ps;
        cc.add(claim);
        
        //insert cc;
        
        CSS_Solutions__c sss=new CSS_Solutions__c();
        sss.name='Test';
        sss.Diagnostic_Response__c='Not the solution';
        sss.Solution_Title__c='test';
        sss.service_job__c=JO.id;
        //sss.FSL_service_job__c=JO.id;
        insert sss;
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.Job_Order__c=JO.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.css_claims__c=cc[0].id;
        srt.Type__c='Diagnosis';
        srt.srt_category__c='AdditionalDiag';
        // srt.solution_number__c=sss.id;
        srt.srt_category__c=null;
        //  srt.solution_number__c=sss.id;
        srt.SRT_Category__c='Campaign'; 
        srt.FailCode__c='test';
        srt.SRT_Warrantable__c='test';
        //srt.Symptom_Name__c='test2';
        additionalSRTList1.add(srt);
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Admin';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.css_claims__c=cc[0].id;
        srt1.srt_category__c='AdditionalDiag';
        srt1.SRT_ID__c = '00-901-10';
        srt1.isPerformed__c = true;
        srt1.Type__c='Diag Access';
        //srt1.srt_category__c=null;
        srt1.solution_number__c=sss.id;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'Select One';
        srt1.FailCode__c = 'Select One';
        srt1.SRT_Quantity__c=8;
        srt1.Flex_Flag__c=true;
        additionalSRTList1.add(srt1);
        CSS_SRT__c srt12 = new CSS_SRT__c();
        srt12.Job_Order__c = JO.id;
        srt12.SRT_AccessiblityCheck__c=True;
        srt12.Access_Code_A__c = 65;
        srt12.name = 'TestClassName';
        srt12.type__c = 'Admin';
        srt12.Assignment__c = 'PRIMARY';
        srt12.srt_time__c = 1;
        srt12.css_claims__c=cc[0].id;
        //srt12.srt_category__c='AdditionalDiag';
        srt12.SRT_ID__c = '00-901-10';
        srt12.isPerformed__c = true;
        srt12.Type__c='Diag Access';
        //srt1.srt_category__c=null;
        srt12.solution_number__c=sss.id;
        srt12.ODM_Status__c = '';
        srt12.Access_Code__c = 'A';
        srt12.Account_Code__c = 'Select One';
        srt12.FailCode__c = 'Select One';
        srt12.SRT_Quantity__c=8;
        srt12.Flex_Flag__c=true;
        additionalSRTList1.add(srt12);
        CSS_SRT__c srt11 = new CSS_SRT__c();
        srt11.Job_Order__c = JO.id;
        srt11.SRT_AccessiblityCheck__c=True;
        srt11.Access_Code_A__c = 65;
        srt11.name = 'TestClassName1';
        srt11.type__c = 'Admin';
        srt11.Assignment__c = 'Diagnostic';
        srt11.srt_time__c = 1;
        srt11.css_claims__c=cc[0].id;
        //srt11.srt_category__c='AdditionalDiag';
        srt11.SRT_ID__c = '00-901-10';
        srt11.isPerformed__c = true;
        srt11.Type__c='Repair Access';
        //srt1.srt_category__c=null;
        //srt11.solution_number__c=sss.id;
        srt11.ODM_Status__c = '';
        srt11.Access_Code__c = 'A';
        srt11.Account_Code__c = 'Select One';
        srt11.FailCode__c = 'Select One';
        srt11.SRT_Quantity__c=8;
        srt11.Flex_Flag__c=true;
        additionalSRTList1.add(srt11);
        insert additionalSRTList1;
        List<CSS_JobEventTemporary__c>  jtlist= new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c Tempkal = new CSS_JobEventTemporary__c();
        Tempkal.Attribute1__c = 'POL';
        Tempkal.Attribute2__c = 'New Engine Warranty';
        Tempkal.Attribute3__c = '67';
        Tempkal.Key__c = 'AccountCodes';
        Insert Tempkal;
        jtlist.add(Tempkal);
        List<String> sid=new List<String>();
        for(CSS_SRT__c ss:additionalSRTList1){
            sid.add(ss.id);
        }
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',cc[0].id);
        //CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srt1);
        //sortwrap.compareTo(sortwrap);
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        
        //system.debug('List'+p.SRTList);
        
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        ss.add(srtdata);
        p.diagListWrap=ss;
        p.CID=cc[0].id;
        cmp.solTitle='';
        cmp.solNum='1234';
        cmp.srtCheckBox=True;
        cmp.accessSrtCheckBox=True;
        cmp.sId= srt1.id;
        
        cmp.failcode=srt1.FailCode__c;
        
        cmp.srtType='test';
        cmp.fautCodeName='test';
        cmp.symptomName='test';
        cmp.AccessCodeSaved='test';
        cmp.SRTAccessCode='test';
        
        cmp.AccessCode='test';
        cmp.accountcode='test';
        cmp.srtID='test';
        cmp.srtDescription='test';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=null;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        //insert cmp;
        
        //p.getDiagAccessTime();
        p.saveDiagData();
        //p.createOverlapSRT(sid);
        p.changeDownOrder();
        p.changeUpOrder();
        p.overlapSRT=additionalSRTList1;
        p.calculateExtendedHours();
        p.selSRTID = 'test';
        p.selCoveredVal = '200';
        p.SRTPercReq();
        p.PenaltyExists= true;
         p.overlapSRT.clear();
        p.calculateExtendedHours();
        Test.stopTest();
        
        
    }
    
    static testmethod void method2(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Account__c=acc.id;
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
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
        c1.Account__c=acc.id;
        c1.CSS_Job__c=jo.id;
        insert c1;
        clist.add(c1);
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        List<String> additionalSRTList = new List<String>();
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Account__c=acc.id;
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        cc.add(claim);
        insert cc;
        
        CSS_Solutions__c sss=new CSS_Solutions__c();
        sss.name='Test';
        sss.Diagnostic_Response__c='Not the solution';
        sss.service_job__c=jo.id;
        //sss.FSL_service_job__c=JO.id;
        insert sss;
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.Job_Order__c=JO.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.css_claims__c=cc[0].id;
        srt.Type__c='Diagnosis';
        srt.srt_category__c='AdditionalDiag';
        srt.solution_number__c=null;
        /*srt.srt_category__c=null;
srt.solution_number__c=sss.id;
srt.SRT_Category__c='Campaign'; */  
        additionalSRTList1.add(srt);
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Solution_Number__c = sol.id;
        srt2.Job_Order__c=JO.id;
        srt2.SRT_Title__c='test';
        srt2.SRT_Quantity__c=123;
        srt2.SRT_Time__c=123;
        srt2.SRT_Access_Code__c='test';
        srt2.css_claims__c=cc[0].id;
        srt2.Type__c='Field Action';
        srt2.srt_category__c='AdditionqalDiag';
        srt2.solution_number__c=null;
        /*srt2.srt_category__c=null;
srt2.solution_number__c=sss.id;
srt2.SRT_Category__c='Campaign';  */ 
        additionalSRTList1.add(srt2);
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Admin';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.css_claims__c=cc[0].id;
        //srt1.srt_category__c='AdditionalDiag';
        srt1.SRT_ID__c = '00-901-10';
        srt1.isPerformed__c = true;
        srt1.Type__c='Diagnosis';
        srt1.srt_category__c='AdditionalDiag';
        srt1.solution_number__c=sss.id;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'Select One';
        additionalSRTList1.add(srt1);
        CSS_SRT__c srt11 = new CSS_SRT__c();
        srt11.Job_Order__c = JO.id;
        srt11.SRT_AccessiblityCheck__c=True;
        srt11.Access_Code_A__c = 65;
        srt11.name = 'TestClassName';
        srt11.type__c = 'Admin';
        srt11.Assignment__c = 'PRIMARY';
        srt11.srt_time__c = 1;
        srt11.css_claims__c=cc[0].id;
        //srt1.srt_category__c='AdditionalDiag';
        srt11.SRT_ID__c = '00-901-10';
        srt11.isPerformed__c = true;
        srt11.Type__c='Field Action';
        srt11.srt_category__c='AdditionalDiag';
        srt11.solution_number__c=sss.id;
        srt11.ODM_Status__c = '';
        srt11.Access_Code__c = 'A';
        srt11.Account_Code__c = 'Select One';
        additionalSRTList1.add(srt11);
        insert additionalSRTList1;
        
        List<String> sid=new List<String>();
        for(CSS_SRT__c ss:additionalSRTList1){
            sid.add(ss.id);
        }
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',cc[0].id);
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        ss.add(srtdata);
        p.diagListWrap=ss;
        p.CID=cc[0].id;
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=True;
        cmp.accessSrtCheckBox=True;
        cmp.sId=srt1.id;
        
        cmp.failcode='';
        cmp.srtType='';
        cmp.fautCodeName='';
        cmp.symptomName='';
        cmp.AccessCodeSaved='';
        cmp.SRTAccessCode='';
        
        cmp.AccessCode='';
        cmp.accountcode='';
        cmp.srtID='';
        cmp.srtDescription='';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=null;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        
        //p.getDiagAccessTime();
        p.saveDiagData();
        //p.createOverlapSRT(sid);
        p.changeDownOrder();
        p.changeUpOrder();
        p.overlapSRT=additionalSRTList1;
        p.calculateExtendedHours();
        
        Test.stopTest();
        
    }
    
    static testmethod void method3(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Account__c=acc.id;
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
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
        c1.CSS_Job__c=jo.id;
        c1.Account__c=acc.id;
        insert c1;
        clist.add(c1);
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        List<String> additionalSRTList = new List<String>();
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Account__c=acc.id;
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.CSS_Job__c=jo.id;
        claim.Actual_Technician_Time__c=1.2;
        cc.add(claim);
        insert cc;
        
        CSS_Solutions__c sss=new CSS_Solutions__c();
        sss.name='Test';
        sss.Solution_Title__c='CDE';
        
        sss.Diagnostic_Response__c='Not the solution';
        sss.service_job__c=jo.id;
        //sss.FSL_service_job__c=JO.id;
        insert sss;
        list<CSS_Solution_Component__c> sollist = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        solcomp.AccountCodeEdit__c='TH';
        solcomp.AccountCodeType__c='test';
        solcomp.Fail_Code_Editable__c='test';
        solcomp.System_Code__c='TH';
        solcomp.Component_Code__c='AC';
        solcomp.Failure_Mode__c='IN';
        
        
        insert solcomp;
        sollist.add(solcomp);
        
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.Step_Id__c = '123';
        srt.Job_Order__c=JO.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.css_claims__c=cc[0].id;
        srt.Type__c='Diagnosis';
        srt.isPerformed__c=true;
        srt.solution_number__c=sss.id;
        srt.FailCode__c='text';
        srt.solution_number__c=sss.id;
        srt.SRT_Category__c=null;   
        additionalSRTList1.add(srt);
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Access';//'Admin';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.css_claims__c=cc[0].id;
        //srt1.srt_category__c='AdditionalDiag';
        srt1.SRT_ID__c = '00-901-10';
        srt1.isPerformed__c = true;
        srt1.Type__c='Diag Access';
        srt1.FailCode__c='test';
        srt1.srt_category__c=null;
        srt1.solution_number__c=sss.id;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'test';
        additionalSRTList1.add(srt1);
        /* CSS_SRT__c srt3 = new CSS_SRT__c();
srt3.Type__c='Repair';
srt3.Assignment__c='Diagnostic';
srt3.srt_category__c=null;
srt3.Solution_Number__c=null;
additionalSRTList1.add(srt3);*/
        insert additionalSRTList1;
        
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',cc[0].id);
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        ss.add(srtdata);
        p.diagListWrap=ss;
        p.CID=cc[0].id;
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=true;
        cmp.accessSrtCheckBox=True;
        cmp.sId=null;
        
        cmp.failcode='';
        cmp.srtType='';
        cmp.fautCodeName='';
        cmp.symptomName='';
        cmp.AccessCodeSaved='';
        cmp.SRTAccessCode='';
        
        cmp.AccessCode='';
        cmp.accountcode='';
        cmp.srtID='';
        cmp.srtDescription='';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=10;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        cmp.srtAccessTime = 2;
        
        //p.getDiagAccessTime();
        p.saveDiagData();
        //p.createOverlapSRT(sid);
        p.changeDownOrder();
        p.changeUpOrder();
        p.calculateExtendedHours();
        
        p.overlapSRTCallout('acc',additionalSRTList1);
        p.getdiagnosisTime();
        Test.stopTest();
        
        
    }
    
    static testmethod void method4(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Account__c=acc.id;
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
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
        c1.Account__c=acc.id;
        c1.CSS_Job__c=jo.id;
        insert c1;
        clist.add(c1);
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        List<String> additionalSRTList = new List<String>();
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Account__c=acc.id;
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        cc.add(claim);
        insert cc;
        
        CSS_Solutions__c sss=new CSS_Solutions__c();
        sss.name='Test';
        sss.service_job__c=jo.id;
        //sss.FSL_service_job__c=JO.id;
        sss.Diagnostic_Response__c='Not the solution';
        insert sss;
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.Job_Order__c=JO.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.css_claims__c=cc[0].id;
        srt.Type__c='Diagnosis';
        srt.srt_category__c='AdditionalDiag';
        srt.solution_number__c=sss.id;
        srt.srt_category__c=null;
        srt.solution_number__c=sss.id;
        srt.SRT_Category__c='Campaign';   
        additionalSRTList1.add(srt);
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Admin';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.css_claims__c=cc[0].id;
        //srt1.srt_category__c='AdditionalDiag';
        srt1.SRT_ID__c = '00-901-10';
        srt1.isPerformed__c = true;
        srt1.Type__c='Diag Access';
        srt1.srt_category__c=null;
        srt1.solution_number__c=sss.id;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'Select One';
        additionalSRTList1.add(srt1);
        insert additionalSRTList1;
        List<CSS_srt__c> additionalsrt2List1 = new List<CSS_srt__c>();
        CSS_srt__c srt2 = new CSS_srt__c();
        srt2.Solution_Number__c = sol.id;
        srt2.Job_Order__c=JO.id;
        srt2.srt_Title__c='test';
        srt2.srt_Quantity__c=123;
        srt2.srt_Time__c=123;
        srt2.srt_Access_Code__c='test';
        srt2.css_claims__c=cc[0].id;
        srt2.Type__c='Overlap';
        srt2.srt_category__c='AdditionalDiag';
        srt2.solution_number__c=sss.id;
        srt2.srt_category__c=null;
        srt2.solution_number__c=sss.id;
        srt2.srt_Category__c='Campaign';   
        additionalsrt2List1.add(srt2);
        CSS_srt__c srt21 = new CSS_srt__c();
        srt21.Job_Order__c = JO.id;
        srt21.srt_AccessiblityCheck__c=True;
        srt21.Access_Code_A__c = 65;
        srt21.name = 'TestClassName';
        srt21.type__c = 'Admin';
        srt21.Assignment__c = 'PRIMARY';
        srt21.srt_time__c = 1;
        srt21.css_claims__c=cc[0].id;
        //srt21.srt2_category__c='AdditionalDiag';
        srt21.srt_ID__c = '00-901-10';
        srt21.isPerformed__c = true;
        srt21.Type__c='Diag Access';
        srt21.srt_category__c=null;
        srt21.solution_number__c=sss.id;
        srt21.ODM_Status__c = '';
        srt21.Access_Code__c = 'A';
        srt21.Account_Code__c = 'Select One';
        additionalsrt2List1.add(srt21);
        insert additionalsrt2List1;
        List<String> sid=new List<String>();
        for(CSS_SRT__c ss:additionalSRTList1){
            sid.add(ss.id);
        }
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',cc[0].id);
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        ss.add(srtdata);
        p.diagListWrap=ss;
        p.CID=cc[0].id;
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=false;
        cmp.accessSrtCheckBox=True;
        cmp.sId=null;
        
        cmp.failcode='';
        cmp.srtType='';
        cmp.fautCodeName='';
        cmp.symptomName='';
        cmp.AccessCodeSaved='';
        cmp.SRTAccessCode='';
        
        cmp.AccessCode='';
        cmp.accountcode='';
        cmp.srtID='';
        cmp.srtDescription='';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=null;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        
        //p.getDiagAccessTime();
        p.saveDiagData();
        // p.createOverlapSRT(sid);
        p.changeDownOrder();
        p.changeUpOrder();
        p.calculateExtendedHours();
        
        p.getdiagnosisTime();
        Test.stopTest();
        
        
    }
    
    static testmethod void method5(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Account__c=acc.id;
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
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
        c1.Account__c=acc.id;
        c1.CSS_Job__c=jo.id;
        insert c1;
        clist.add(c1);
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        List<String> additionalSRTList = new List<String>();
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Account__c=acc.id;
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        cc.add(claim);
        insert cc;
        
        CSS_Solutions__c sss=new CSS_Solutions__c();
        sss.name='Test';
        sss.service_job__c=jo.id;
        //sss.FSL_service_job__c=JO.id;
        sss.Diagnostic_Response__c='Not the solution';
        insert sss;
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.css_claims__c=cc[0].id;
        srt.Type__c='Repair';
        srt.srt_category__c='AdditionalDiag';
        srt.solution_number__c=sss.id;
        srt.srt_category__c=null;
        srt.solution_number__c=sss.id;
        srt.SRT_Category__c='Campaign';   
        additionalSRTList1.add(srt);
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Admin';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.css_claims__c=cc[0].id;
        //srt1.srt_category__c='AdditionalDiag';
        srt1.SRT_ID__c = '00-901-10';
        srt1.isPerformed__c = true;
        srt1.Type__c='Field Action';
        srt1.srt_category__c=null;
        srt1.solution_number__c=sss.id;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'Select One';
        additionalSRTList1.add(srt1);
        insert additionalSRTList1;
        List<CSS_srt__c> additionalsrt2List1 = new List<CSS_srt__c>();
        CSS_srt__c srt2 = new CSS_srt__c();
        srt2.Solution_Number__c = sol.id;
        srt2.srt_Title__c='test';
        srt2.srt_Quantity__c=123;
        srt2.srt_Time__c=123;
        srt2.srt_Access_Code__c='test';
        srt2.css_claims__c=cc[0].id;
        srt2.Type__c='Field Action Access';
        srt2.srt_category__c='AdditionalRep';
        srt2.solution_number__c=sss.id;
        srt2.srt_category__c=null;
        srt2.solution_number__c=sss.id;
        srt2.srt_Category__c='Campaign';   
        additionalsrt2List1.add(srt2);
        CSS_srt__c srt21 = new CSS_srt__c();
        srt21.Job_Order__c = JO.id;
        srt21.srt_AccessiblityCheck__c=True;
        srt21.Access_Code_A__c = 65;
        srt21.name = 'TestClassName';
        srt21.type__c = 'Admin';
        srt21.Assignment__c = 'PRIMARY';
        srt21.srt_time__c = 1;
        srt21.css_claims__c=cc[0].id;
        //srt21.srt2_category__c='AdditionalDiag';
        srt21.srt_ID__c = '00-901-10';
        srt21.isPerformed__c = true;
        srt21.Type__c='Repair Access';
        srt21.srt_category__c=null;
        srt21.solution_number__c=sss.id;
        srt21.ODM_Status__c = '';
        srt21.Access_Code__c = 'A';
        srt21.Account_Code__c = 'Select One';
        additionalsrt2List1.add(srt21);
        insert additionalsrt2List1;
        List<String> sid=new List<String>();
        for(CSS_SRT__c ss:additionalSRTList1){
            sid.add(ss.id);
        }
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',cc[0].id);
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        ss.add(srtdata);
        p.diagListWrap=ss;
        p.CID=cc[0].id;
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=false;
        cmp.accessSrtCheckBox=True;
        cmp.sId=null;
        
        cmp.failcode='test';
        cmp.srtType='test';
        cmp.fautCodeName='test';
        cmp.symptomName='test';
        cmp.AccessCodeSaved='test';
        cmp.SRTAccessCode='test';
        
        cmp.AccessCode='';
        cmp.accountcode='';
        cmp.srtID='';
        cmp.srtDescription='';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=null;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        
        //p.getDiagAccessTime();
        p.saveDiagData();
        //p.createOverlapSRT(sid);
        p.changeDownOrder();
        p.changeUpOrder();
        p.calculateExtendedHours();
        //  List<CSS_DARSRT.sortWrapper> lstwrapSort = new List<CSS_DARSRT.sortWrapper>();
        //CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srt21);
        // lstwrapSort.add(sortwrap);
        // sortwrap.compareTo(sortwrap);
        
        p.getdiagnosisTime();
        Test.stopTest();
        
        
    }
    
    static testmethod void method6(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Account__c=acc.id;
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        cc.add(claim);
        insert cc;
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        
        insert solcomp;
        
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test'; 
        srt.SRT_Category__c='TRP';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Field Action Access';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='TRP';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        srt.SRT_AccessiblityCheck__c=true;
        insert srt;  
        
        ApexPages.currentPage().getParameters().put('id',cc[0].id);
        Test.startTest();
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        ss.add(srtdata);
        p.diagListWrap=ss;
        p.CID=cc[0].id;
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=false;
        cmp.accessSrtCheckBox=True;
        cmp.sId=null;
        
        cmp.failcode='test';
        cmp.srtType='test';
        cmp.fautCodeName='test';
        cmp.symptomName='test';
        cmp.AccessCodeSaved='test';
        cmp.SRTAccessCode='test';
        
        cmp.AccessCode='';
        cmp.accountcode='';
        cmp.srtID='';
        cmp.srtDescription='';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=null;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        
        List<CSS_DARSRT.sortWrapper> lstwrapSort = new List<CSS_DARSRT.sortWrapper>();
        CSS_DARSRT.sortWrapper sortwrap = new CSS_DARSRT.sortWrapper(srt);
        lstwrapSort.add(sortwrap);
        sortwrap.compareTo(sortwrap);
        Test.stopTest();
        
    }
    
    static testmethod void method3null()
    {
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Account__c=acc.id;
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
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
        c1.Account__c=acc.id;
        c1.CSS_Job__c=jo.id;
        c1.ODM_Penalty__c = '50';
        insert c1;
        clist.add(c1);
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        List<String> additionalSRTList = new List<String>();
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Account__c=acc.id;
        claim.Customer_Name__c='Gopal';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        cc.add(claim);
        insert cc;
        
        CSS_Solutions__c sss=new CSS_Solutions__c();
        sss.name='Test';
        sss.Solution_Title__c='CDE';
        sss.service_job__c=jo.id;
        //sss.FSL_service_job__c=JO.id;
        sss.Diagnostic_Response__c='Not the solution';
        insert sss;
        
        list<CSS_Solution_Component__c> sollist = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        solcomp.AccountCodeEdit__c='TH';
        solcomp.AccountCodeType__c='test';
        solcomp.Fail_Code_Editable__c='test';
        solcomp.System_Code__c='TH';
        solcomp.Component_Code__c='AC';
        solcomp.Failure_Mode__c='IN';
        insert solcomp;
        sollist.add(solcomp);
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.Job_Order__c=JO.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.Access_Code__c = null;
        //srt.Job_Engine_Access_Code__c = 'test';
        srt.SRT_Access_Code__c='R';
        srt.css_claims__c=cc[0].id;
        srt.Type__c='Overlap';
        srt.FailCode__c ='Select One';
        srt.srt_category__c='AdditionalDiag';
        srt.solution_number__c=sss.id;
        srt.srt_category__c=null;
        srt.solution_number__c=sss.id;
        srt.SRT_Category__c='Campaign';
        srt.Account_code__C = '';
        additionalSRTList1.add(srt);
        
        insert additionalSRTList1;
        List<String> sid=new List<String>();
        for(CSS_SRT__c ss:additionalSRTList1){
            sid.add(ss.id);
        }
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',cc[0].id);
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        
        p.CID=cc[0].id;
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=false;
        cmp.accessSrtCheckBox=True;
        cmp.sId=null;
        
        //cmp.failcode='test';
        cmp.srtType='test';
        cmp.fautCodeName='test';
        cmp.symptomName='test';
        cmp.AccessCodeSaved='test';
        cmp.SRTAccessCode='test';
        
        cmp.AccessCode='';
        cmp.accountcode='';
        cmp.srtID='';
        cmp.srtDescription='';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=null;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        p.diagListWrap=ss;
        p.CID=cc[0].id;
        p.selSRTID = 'test';
        p.selCoveredVal = '20';
        p.SRTPercReq();
        Test.stopTest();
        
        
    }
    static testmethod void method7(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Account__c=acc.id;
        claim.Customer_Name__c='Gopal';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        cc.add(claim);
        insert cc;
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'ATC';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        insert solComp;
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Repair';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='Repair Access';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        srt.isPerformed__c = true;
        srt.Assignment__c='Diagnostics';
        srt.srt_category__c='AdditionalDiag';
        insert srt;    
        additionalSRTList.add(srt);
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        test.startTest();
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        ss.add(srtdata);
        p.diagListWrap=ss;
        p.CID=cc[0].id;
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=false;
        cmp.accessSrtCheckBox=True;
        cmp.sId=null;
        
        cmp.failcode='test';
        cmp.srtType='test';
        cmp.fautCodeName='test';
        cmp.symptomName='test';
        cmp.AccessCodeSaved='test';
        cmp.SRTAccessCode='test';
        
        cmp.AccessCode='';
        cmp.accountcode='';
        cmp.srtID='';
        cmp.srtDescription='';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=null;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        
        test.stopTest();
    }
    static testmethod void method8(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Account__c=acc.id;
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        cc.add(claim);
        insert cc;
        
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'ATC';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        insert solComp;
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c =null;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='';
        srt.CSS_Claims__c=claim.id;
        srt.Type__c='Repair';
        srt.Component_Id__c=solcomp.Id;
        srt.srt_type__c='Repair Access';
        srt.FailCode__c='';
        srt.Access_Code__c='';
        srt.Extended_Hours__c=4;
        srt.SRT_Select__c=true;
        srt.isPerformed__c = true;
        srt.Assignment__c='Diagnostics';
        srt.srt_category__c=null;
        insert srt;    
        additionalSRTList.add(srt);
        
        test.startTest();
        //exPages.currentPage().getParameters().put('id', claim.Id);
        ApexPages.currentPage().getParameters().put('id',cc[0].id);
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        srtdata.compareTo(srtdata);
        p.diagListWrap=ss;
        p.CID=cc[0].id;
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=false;
        cmp.accessSrtCheckBox=True;
        cmp.sId=null;
        
        cmp.failcode='';
        cmp.srtType='';
        cmp.fautCodeName='';
        cmp.symptomName='';
        cmp.AccessCodeSaved='';
        cmp.SRTAccessCode='';
        
        cmp.AccessCode='';
        cmp.accountcode='';
        cmp.srtID='';
        cmp.srtDescription='';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=null;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        
        
        Test.stopTest();
        
    }
    static testmethod void method9(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.Account__c=acc.id;
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        insert jo;
        
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = jo.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Account__c=acc.id;
        claim.Customer_Name__c='Gopal';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        cc.add(claim);
        insert cc;
        
        CSS_Solutions__c sss=new CSS_Solutions__c();
        sss.name='Test';
        sss.service_job__c=jo.id;
        //sss.FSL_service_job__c=JO.id;
        sss.Diagnostic_Response__c='Not the solution';
        insert sss;
        
        
        CSS_SRT__c srt = new CSS_SRT__c();
        //srt.Job_Order__c = JO.id;
        srt.Solution_Number__c = sol.id;
        srt.Type__c = 'Repair Access';
        srt.srt_category__c = null;
        srt.Assignment__c = 'Diagnostic';
        srt.solution_number__c=sss.id;
        srt.css_claims__c=claim.id;
        insert srt;
        
        Test.startTest();
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        ss.add(srtdata);
        p.diagListWrap=ss;
        p.selAccCode='Test';
        p.CID=cc[0].id;
        //cmp.sId=srt.id;
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=True;
        cmp.accessSrtCheckBox=True;
        cmp.sId=srt.id;
        
        cmp.failcode='';
        cmp.srtType='';
        cmp.fautCodeName='';
        cmp.symptomName='';
        cmp.AccessCodeSaved='';
        cmp.SRTAccessCode='';
        
        cmp.AccessCode='';
        cmp.accountcode='';
        cmp.srtID='';
        cmp.srtDescription='';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=null;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        Test.stopTest();
        
    }
    static testmethod void method10(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Account__c=acc.id;
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
        
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = jo.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Account__c=acc.id;
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        cc.add(claim);
        insert cc;
        
        CSS_Solutions__c sss=new CSS_Solutions__c();
        sss.name='Test';
        sss.service_job__c=jo.id;
        //sss.FSL_service_job__c=JO.id;
        sss.Diagnostic_Response__c='Not the solution';
        insert sss;
        
        
        CSS_SRT__c srt = new CSS_SRT__c();
        //srt.Job_Order__c = JO.id;
        srt.Solution_Number__c = null;
        srt.Type__c = 'Repair Access';
        srt.srt_category__c = null;
        srt.Assignment__c = 'Diagnostic';
        //srt.solution_number__c=sss.id;
        srt.css_claims__c=claim.id;
        insert srt;
        
        Test.startTest();
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        ss.add(srtdata);
        p.diagListWrap=ss;
        p.selAccCode='Test';
        p.CID=cc[0].id;
        //cmp.sId=srt.id;
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=True;
        cmp.accessSrtCheckBox=True;
        cmp.sId=srt.id;
        
        cmp.failcode='';
        cmp.srtType='';
        cmp.fautCodeName='';
        cmp.symptomName='';
        cmp.AccessCodeSaved='';
        cmp.SRTAccessCode='';
        
        cmp.AccessCode='';
        cmp.accountcode='';
        cmp.srtID='';
        cmp.srtDescription='';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=null;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        Test.stopTest();
        
    }
    static testmethod void method31(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Account__c=acc.id;
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
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
        c1.CSS_Job__c=jo.id;
        c1.Account__c=acc.id;
        insert c1;
        clist.add(c1);
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        upsert sol;
        
        List<String> additionalSRTList = new List<String>();
        
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Account__c=acc.id;
        claim.Customer_Name__c='Gopal';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.CSS_Job__c=jo.id;
        claim.Actual_Technician_Time__c=1.2;
        claim.ODM_Penalty__c='100';
        claim.Information_Only_Claim__c=false;
        
        cc.add(claim);
        insert cc;
        
        CSS_Solutions__c sss=new CSS_Solutions__c();
        sss.name='Test';
        sss.Solution_Title__c='CDE';
        sss.service_job__c=jo.id;
        //sss.FSL_service_job__c=JO.id;
        sss.Diagnostic_Response__c='Not the solution';
        insert sss;
        list<CSS_Solution_Component__c> sollist = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        solcomp.Performed_Review__c=true;
        solcomp.Status__c='approved';
        solcomp.Complete_Indicator__c=false;
        solcomp.Multiple_Times__c=true;
        solcomp.CSS_Claims__c=claim.id;
        solcomp.Solutions__c=Sol.Id;
        solcomp.AccountCodeEdit__c='TH';
        solcomp.AccountCodeType__c='test';
        solcomp.Fail_Code_Editable__c='test';
        solcomp.System_Code__c='TH';
        solcomp.Component_Code__c='AC';
        solcomp.Failure_Mode__c='IN';
        
        
        insert solcomp;
        sollist.add(solcomp);
        
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.Job_Order__c=jO.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='';
        // srt.Job_Engine_Access_Code__c='';
        srt.css_claims__c=cc[0].id;
        srt.Type__c='Diagnosis';
        srt.isPerformed__c=true;
        srt.srt_category__c=null;//'AdditionalDiag';
        srt.solution_number__c=null;//sss.id;
        srt.srt_category__c=null;
        srt.FailCode__c='';
        srt.solution_number__c=sss.id;
        srt.Account_Code__c='test';
        //srt.SRT_Category__c='Campaign';   
        additionalSRTList1.add(srt);
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Repair Access';//'Admin';
        srt1.Assignment__c = 'Diagnostic';
        srt1.srt_time__c = 1;
        srt1.css_claims__c=cc[0].id;
        //srt1.srt_category__c='AdditionalDiag';
        srt1.SRT_ID__c = '00-901-10';
        srt1.isPerformed__c = true;
        //srt1.Type__c='Diag Access';
        srt1.FailCode__c='test';
        srt1.srt_category__c=null;
        srt1.solution_number__c=null;//sss.id;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'Select One';
        additionalSRTList1.add(srt1);
        CSS_SRT__c srt3 = new CSS_SRT__c();
        srt3.Type__c='Repair';
        srt3.Job_Order__c=JO.id;
        srt3.Assignment__c='Diagnostic';
        srt3.srt_category__c=null;
        srt3.Solution_Number__c=null;
        additionalSRTList1.add(srt3);
        insert additionalSRTList1;
        List<String> sid=new List<String>();
        for(CSS_SRT__c ss:additionalSRTList1){
            sid.add(ss.id);
        }
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',cc[0].id);
        CG_CL_ClaimsSRTDiagController p = new CG_CL_ClaimsSRTDiagController();
        CG_CL_ClaimsSRTDiagController.srtWrapper cmp =new  CG_CL_ClaimsSRTDiagController.srtWrapper();
        CG_CL_ClaimsSRTDiagController.sortWrapper srtdata=new CG_CL_ClaimsSRTDiagController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTDiagController.sortWrapper> ss=new List<CG_CL_ClaimsSRTDiagController.sortWrapper>();
        ss.add(srtdata);
        ss.add(srtdata);
        p.diagListWrap=ss;
        p.CID=cc[0].id;
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=true;
        cmp.accessSrtCheckBox=True;
        cmp.sId=null;
        
        cmp.failcode='';
        cmp.srtType='';
        cmp.fautCodeName='';
        cmp.symptomName='';
        cmp.AccessCodeSaved='';
        cmp.SRTAccessCode='';
        
        cmp.AccessCode='';
        cmp.accountcode='';
        cmp.srtID='';
        cmp.srtDescription='';
        cmp.quantity=null;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        cmp.accessCodeFlag=true;
        cmp.percentReqFlag=true;
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=10;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null;
        cmp.Failure='';
        cmp.srtAccessTime = 2;
        cmp.stepId='77sa8ss88';
        
        //p.getDiagAccessTime();
        p.saveDiagData();
        //p.createOverlapSRT(sid);
        p.changeDownOrder();
        p.changeUpOrder();
        p.calculateExtendedHours();
        p.callClaimsAccessStepDetailsDiag();
        p.ClaimsDiagNotesPopupOk(); 
        p.getdiagnosisTime();
        Test.stopTest();
        
        
    }
    
    
}