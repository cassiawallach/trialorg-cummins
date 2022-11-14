@isTest
public class CSS_SymptomFCSearch_Test {
    
    public static CSS_SymptomFCSearch ext;
    public static CSS_Job_Order__c JO;
    public static PageReference pref;
    public Boolean dsidUpdate = true;
    private static void init() {
        //CSS_Job_Order__c JO = new CSS_Job_Order__c();
        CSS_SymptomFCSearch symSearch = new CSS_SymptomFCSearch();
        symSearch.dsidIndi = 'test';
        symSearch.solSize = 12;
        symSearch.QuesResp = 'test';
        
        string searchText ='White Smoke';
        boolean display=true;
        boolean displaySoln=true;
        boolean displaySolnCaptionOnly =true;
        integer Cardinality =2;
        string QuestionId ='test345';
        
        //Integer SeqNum=1;
        String ansChoiceCaption ='asdasd';
        String ansId='213wdeda';
        String multiChoiceSelect='asd';
        string radioMapSelect='qwe';
        string radioSelect = 'asdsad';
        //string category = 'radio';
        string radioSelec = 'asdsad';
        string radioSel = 'asdsad';
        boolean fstcall = true;
        string sortsolutions ='test';
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi2@cummins.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi2@cummins.com', User_Location__c='123456',Work_Group_Name__c = 'ban',isActive = true);
        objUser1.User_Location__c ='Bronx';
        objUser1.Work_Group_Name__c = 'wg';
        insert objUser1;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        JO = NEW CSS_Job_Order__c();
        JO.Account__c = acc.Id;
        JO.Unit_Number__c = '12345';
        JO.Failure_Point__c = 1.5;
        JO.Failure_Point_Measure__c = 'qw';       
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.ESN__c = 'test1234';
        jo.DSID_WorkGroup__c = null;
        JO.DSID_Creation_Timestamp__c = system.now();
        JO.DSID_Status__c = 'open';
        JO.ESN_Locked__c = true;
        JO.ESN_Insite__c = '79464646';
        JO.Application_Desc__c = 'Application';
        JO.Application__c = 'test1234';
        JO.Failure_Point__c = 1234;
        JO.Failure_Point_Measure__c = 'test1234';
        JO.Make__c = 'BMC';
        JO.Equipment_ID__c = 'equip';
        JO.Model__c = 'MILITARY';
        //      JO.DSID__c = 'DSE222';
        JO.DSID__c = null;
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.AccessCode__c ='A';
        insert(JO);
        
        List<CSS_SymptomQA__c> lstSym = new List<CSS_SymptomQA__c>();
        List<CSS_SymptomQA__c> lstSymQA = new List<CSS_SymptomQA__c>();
        List<CSS_Solutions__c> lstSol = new List<CSS_Solutions__c>();
        List<CSS_SRT__c> lstSRT = new List<CSS_SRT__c>();
        List<CSS_SRT__c> lstSRTRep = new List<CSS_SRT__c>();
        List<CSS_Solution_Component__c> lssrtComp = new List<CSS_Solution_Component__c>();
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=JO.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =Jo.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        sym.Answers__c = 'FCCodeUI';
        sym.Caption__c = 'cap';
        sym.Sequence__c = 1.6;
        
        insert sym;
        
        lstSym.add(sym);
        
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        symQA.Job_Order__c=Jo.id;
        symQA.caption__c ='white smoke';
        symQA.Option1__c  ='12213';
        symQA.SearchString__c = sym.id;
        symQA.Option_type__c  ='qwewqe';
        symQA.Sequence__c =1;
        symQA.Type__c  ='QA';
        
        insert symQA;
        
        lstSymQA.add(symQA);
        
        CSS_SymptomQA__c symQA1=new CSS_SymptomQA__c();
        symQA1.Job_Order__c=Jo.id;
        symQA1.caption__c ='white smoke';
        symQA1.Option1__c  ='1222134213413';
        symQA1.SearchString__c = sym.id;
        symQA1.Option_type__c  ='wewqe';
        symQA1.Sequence__c =2;
        symQA1.Type__c  ='SearchString';
        
        insert symQA1;
        
        lstSymQA.add(symQA1);
        
        CSS_SymptomQA__c symQA2=new CSS_SymptomQA__c();
        symQA2.Job_Order__c=Jo.id;
        symQA2.caption__c ='white smoke';
        symQA2.Option1__c  ='1222134213413';
        symQA2.SearchString__c = sym.id;
        symQA2.Option_type__c  ='wewqe';
        symQA2.Sequence__c =3;
        symQA2.Type__c  ='QA';
        
        insert symQA2;
        
        lstSymQA.add(symQA2);
        
        CSS_SymptomQA__c symQA3=new CSS_SymptomQA__c();
        symQA3.Job_Order__c=Jo.id;
        symQA3.caption__c ='white smoke';
        symQA3.Option1__c  ='1222134213413';
        symQA3.SearchString__c = symQA2.id;
        symQA3.Option_type__c  ='wewqe';
        symQA3.Sequence__c =2;
        symQA3.Type__c  ='QA';
        
        insert symQA3;
        
        lstSymQA.add(symQA3);
        
        CSS_Solutions__c sol=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol.Case_Name__c='test';
        sol.Name = 'sol';
        sol.Rank__c = 0;
        // sol.Diagnostic_Response__c='test';
        sol.Diagnostic_Response__c = null;
        sol.Repair_Response__c='test';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=JO.id;
        insert sol;
        CSS_Solutions__c sol1=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol1.Case_Name__c='test';
        sol1.Name = 'sol';
        sol1.Rank__c = null;
        //sol1.Diagnostic_Response__c='test1';
        sol1.Diagnostic_Response__c = null;
        sol1.Repair_Response__c='test2';
        sol1.Symptom__c=symQA1.id;
        sol1.Service_Job__c=Jo.id;
        insert sol1;
        
        CSS_Solutions__c sol2=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol2.Case_Name__c='test';
        sol2.Name = 'sol';
        sol2.Rank__c = null;
        //sol1.Diagnostic_Response__c='test1';
        sol2.Diagnostic_Response__c = null;
        sol2.Repair_Response__c='test2';
        sol2.Symptom__c=symQA1.id;
        sol2.Service_Job__c=jo.id;
        insert sol2;
        
        lstSol.add(sol1);
        lstSol.add(sol);
        lstSol.add(sol2);
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=Jo.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c = 0.0;       
        srt.Access_Code_A__c =0.0;
        insert srt;
        
        CSS_SRT__c srt1=new CSS_SRT__c();
        srt1.Solution_Number__c=sol.id;
        srt1.Job_Order__c=Jo.id;
        srt1.Type__c = 'Diagnosis';
        srt1.SRT_Time__c = .20;
        srt1.Access_Code_A__c =200.0;
        insert srt1;
        
        lstSRT.add(srt);
        lstSRT.add(srt1);
        
        CSS_SRT__c srtRep =new CSS_SRT__c();
        srtRep.Solution_Number__c=sol.id;
        srtRep.Job_Order__c=Jo.id;
        srtRep.Type__c = 'Repair';
        srtRep.isPerformed__c=TRUE;
        srtRep.SRT_Time__c = 0.0;
        srtRep.Access_Code_A__c =0.0;
        insert srtRep;
        
        CSS_Solution_Component__c srtComp = new CSS_Solution_Component__c();
        srtComp.Solutions__c = sol.id;
        srtComp.Quantity__c = 1;
        srtComp.Action__c='asdsad';
        srtComp.Service_Job__c =jo.id;
        srtComp.Selected_Component__c = true;
        insert srtComp;
        lssrtComp.add(srtComp);
        
        CSS_SRT__c srtRep1 =new CSS_SRT__c();
        srtRep1.Solution_Number__c=sol.id;
        srtRep1.Job_Order__c=Jo.id;
        srtRep1.Type__c = 'Repair';
        srtRep1.SRT_Time__c = 2000.0;
        srtRep1.isPerformed__c=TRUE;
        srtRep1.Access_Code_A__c =200.0;
        srtRep1.Component_Id__c =srtComp.id;
        insert srtRep1;
        lstSRTRep.add(srtRep1);
        lstSRTRep.add(srtRep);
        
        
        CSS_SRT__c srtofComp =new CSS_SRT__c();
        srtofComp.Solution_Number__c=sol.id;
        srtofComp.Job_Order__c=Jo.id;
        srtofComp.Type__c = 'Repair';
        srtofComp.isPerformed__c=TRUE;
        srtofComp.SRT_Time__c = 2000.0;
        srtofComp.Access_Code_A__c =200.0;
        srtofComp.Response_Message__c='Test';
        srtofComp.Component_Id__c =srtComp.id;
        srtofComp.Solution_Number__c =sol.id;
        srtofComp.Job_Order__c = jo.id;
        
        
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Service_Job__c=Jo.id;
        parts.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts.Fail_Code__c = 'THAC';
        parts.selected_part__c = True;
        lstparts.add(parts);
        system.debug('parts.Fail_Code__c'+parts.Fail_Code__c);
        
        
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.selected_part__c = True;
        parts1.Service_Job__c=Jo.id;
        // parts1.Solutions__c = srtComp.Id;
        parts1.FailurepartId__c = srtComp.Id;
        parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts1.Fail_Code__c = 'THAS';
        lstparts.add(parts1);
        insert lstparts;
        
        CSS_accountLanguage__c aLang = new CSS_accountLanguage__c();
        aLang.name='en_US';
        aLang.CSS_EDSLanguage__c = 'en';
        aLang.CSS_userLanguage__c = 'English';
        aLang.CSS_QsolLanguage__c = 'en';
        insert aLang;
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',jo.Id);
        ApexPages.currentPage().getParameters().put('SeqNum',string.valueOf(symQA.Sequence__c));
        ApexPages.currentPage().getParameters().put('symId',jo.Id);
        ext = new CSS_SymptomFCSearch();
        
        CSS_SymptomFCSearch.symQAWrapper symwraper= new CSS_SymptomFCSearch.symQAWrapper();
        ext.totalSolution = 0;
        
        List<String> FcListFCSearch1 = new List<String>();         
        string Str ='[answersNext=(ansChoice:[ansCaption=No Fault Codes, ansID=1132#38782], ansChoice:[ansCaption=112, ansID=1132#25526], ansChoice:[ansCaption=124, ansID=1132#25549], ansChoice:[ansCaption=125, ansID=1132#41137], ansChoice:[ansCaption=155, ansID=1132#25607], ansChoice:[ansCaption=158, ansID=1132#25613], ansChoice:[ansCaption=162, ansID=1132#25619], ansChoice:[ansCaption=165, ansID=1132#25625], ansChoice:[ansCaption=237, ansID=1132#25735], ansChoice:[ansCaption=291, ansID=1132#25825], ...), cardinality=1, quesID=10#1494, question=Select the active fault code from the list below. If no fault codes are active, selectNo Fault Codes Present and click the NEXT button., solEDS=null, solRank=33]';
        FcListFCSearch1.add(Str);
        
        
        ext.descr = 'asdasdasd';
        ext.category = 'radio';
        List<SelectOption> options = new List<SelectOption>();
        List<SelectOption> optionstwo =new List<SelectOption>();
        List<SelectOption> optionsthree =new List<SelectOption>();
        List<SelectOption> optionsfour =new List<SelectOption>();
        Integer SeqNum = 1;    
        Integer SeqNum1 = 2;
        Integer SeqNum2 = 3;
        
        optionstwo.add(new SelectOption('Miles',system.Label.CSS_Miles));
        optionsthree.add(new SelectOption('Miles',system.Label.CSS_Miles));
        optionsfour.add(new SelectOption('Miles',system.Label.CSS_Miles));
        ext.SeqNum = SeqNum;
        ext.SeqNum = SeqNum1;
        ext.SeqNum = SeqNum2;
        ext.options2 = optionstwo;
        ext.options2 = optionsthree;
        ext.options2 = optionsfour;
        ext.display = true;
        ext.displaySoln =true;
        ext.displaySolnCaptionOnly =true;
        ext.Cardinality = 1;
        ext.QuestionId  ='2123123';
        ext.ansChoiceCaption ='qww2312';
        ext.ansId ='qww2312';
        ext.multiChoiceSelect  ='multiChoice';
        ext.radioMapSelect ='radioMap';
        ext.FCCodeUI ='FcodeUI';
        ext.solName ='SolName';
        ext.solTitle = 'Soltitle';
        ext.solRank = 1;
        ext.radioSelect ='asdsad';
        ext.displaySoln = false;
        ext.FCCodeUI = '1233';
        ext.GlobDisplayList = lstSymQA; 
        ext.symptomQAs =lstSymQA;
        ext.solName = 'Sol1';
        
    }
    private static void init1() {
        
        CSS_SymptomFCSearch symSearch = new CSS_SymptomFCSearch();
        symSearch.dsidIndi = 'test';
        symSearch.solSize = 12;
        symSearch.QuesResp = 'test';
        
        string searchText ='White Smoke';
        boolean display=true;
        boolean displaySoln=true;
        boolean displaySolnCaptionOnly =true;
        integer Cardinality =1;
        string QuestionId ='test345';
        
        //Integer SeqNum=1;
        String ansChoiceCaption ='asdasd';
        String ansId='213wdeda';
        String multiChoiceSelect='asd';
        string radioMapSelect='qwe';
        string radioSelect = null;
        string category = 'radio';
        string radioSelec = 'asdsad';
        string radioSel = null;
        boolean fstcall = false;
        string sortsolutions ='test';
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi2@cummins.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi2@cummins.com', User_Location__c='123456',Work_Group_Name__c = 'ban',isActive = true);
        objUser1.User_Location__c ='Bronx';
        objUser1.Work_Group_Name__c = 'wg';
        insert objUser1;
        
        JO = NEW CSS_Job_Order__c();
        JO.Unit_Number__c = '12345';
        JO.Failure_Point__c = 1.5;
        JO.Failure_Point_Measure__c = 'qw';       
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.ESN__c = 'test1234';
        jo.DSID_WorkGroup__c = '';
        JO.DSID_Creation_Timestamp__c = system.now();
        JO.DSID_Status__c = 'open';
        JO.ESN_Locked__c = true;
        JO.ESN_Insite__c = '79464646';
        JO.Application__c = 'test1234';
        JO.Failure_Point__c = 1234;
        JO.Failure_Point_Measure__c = 'test1234';
        JO.Make__c = 'BMC';
        JO.Equipment_ID__c = 'equip';
        JO.Model__c = 'MILITARY';
        JO.DSID__c = 'DSE222';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.AccessCode__c ='A';
        insert(JO);
        
        List<CSS_SymptomQA__c> lstSym = new List<CSS_SymptomQA__c>();
        List<CSS_SymptomQA__c> lstSymQA = new List<CSS_SymptomQA__c>();
        List<CSS_Solutions__c> lstSol = new List<CSS_Solutions__c>();
        List<CSS_SRT__c> lstSRT = new List<CSS_SRT__c>();
        List<CSS_SRT__c> lstSRTRep = new List<CSS_SRT__c>();
        List<CSS_Solution_Component__c> lssrtComp = new List<CSS_Solution_Component__c>();
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=JO.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =Jo.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        sym.Answers__c = 'FCCodeUI';
        sym.Caption__c = 'cap';
        sym.Sequence__c = 1.6;
        
        insert sym;
        
        lstSym.add(sym);
        
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        symQA.Job_Order__c=Jo.id;
        symQA.caption__c ='white smoke';
        symQA.Option1__c  ='12213';
        symQA.SearchString__c = sym.id;
        symQA.Option_type__c  ='qwewqe';
        symQA.Sequence__c =1;
        symQA.Type__c  ='QA';
        
        insert symQA;
        
        lstSymQA.add(symQA);
        
        CSS_SymptomQA__c symQA1=new CSS_SymptomQA__c();
        symQA1.Job_Order__c=Jo.id;
        symQA1.caption__c ='white smoke';
        symQA1.Option1__c  ='1222134213413';
        symQA1.SearchString__c = sym.id;
        symQA1.Option_type__c  ='wewqe';
        symQA1.Sequence__c =2;
        symQA1.Type__c  ='SearchString';
        
        insert symQA1;
        
        lstSymQA.add(symQA1);
        
        CSS_SymptomQA__c symQA2=new CSS_SymptomQA__c();
        symQA2.Job_Order__c=Jo.id;
        symQA2.caption__c ='white smoke';
        symQA2.Option1__c  ='1222134213413';
        symQA2.SearchString__c = sym.id;
        symQA2.Option_type__c  ='wewqe';
        symQA2.Sequence__c =3;
        symQA2.Type__c  ='QA';
        
        insert symQA2;
        
        lstSymQA.add(symQA2);
        
        CSS_SymptomQA__c symQA3=new CSS_SymptomQA__c();
        symQA3.Job_Order__c=Jo.id;
        symQA3.caption__c ='white smoke';
        symQA3.Option1__c  ='1222134213413';
        symQA3.SearchString__c = symQA2.id;
        symQA3.Option_type__c  ='wewqe';
        symQA3.Sequence__c =2;
        symQA3.Type__c  ='QA';
        
        insert symQA3;
        
        lstSymQA.add(symQA3);
        
        CSS_Solutions__c sol=new CSS_Solutions__c();
        
        sol.Case_Name__c='test';
        sol.Name = 'sol';
        sol.Rank__c = 0;
        
        sol.Diagnostic_Response__c = null;
        sol.Repair_Response__c='test';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=JO.id;
        insert sol;
        CSS_Solutions__c sol1=new CSS_Solutions__c();
        
        sol1.Case_Name__c='test';
        sol1.Name = 'sol';
        sol1.Rank__c = null;
        
        sol1.Diagnostic_Response__c = null;
        sol1.Repair_Response__c='test2';
        sol1.Symptom__c=symQA1.id;
        sol1.Service_Job__c=Jo.id;
        insert sol1;
        
        CSS_Solutions__c sol2=new CSS_Solutions__c();
        
        sol2.Case_Name__c='test';
        sol2.Name = 'sol';
        sol2.Rank__c = null;
        //sol1.Diagnostic_Response__c='test1';
        sol2.Diagnostic_Response__c = null;
        sol2.Repair_Response__c='test2';
        sol2.Symptom__c=symQA1.id;
        sol2.Service_Job__c=jo.id;
        insert sol2;
        
        lstSol.add(sol1);
        lstSol.add(sol);
        lstSol.add(sol2);
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=Jo.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c = 0.0;       
        srt.Access_Code_A__c =0.0;
        //insert srt;
        
        CSS_SRT__c srt1=new CSS_SRT__c();
        srt1.Solution_Number__c=sol.id;
        srt1.Job_Order__c=Jo.id;
        srt1.Type__c = 'Diagnosis';
        srt1.SRT_Time__c = .20;
        srt1.Access_Code_A__c =200.0;
        //insert srt1;
        
        lstSRT.add(srt);
        lstSRT.add(srt1);
        
        CSS_SRT__c srtRep =new CSS_SRT__c();
        srtRep.Solution_Number__c=sol.id;
        srtRep.Job_Order__c=Jo.id;
        srtRep.Type__c = 'Repair';
        srtRep.isPerformed__c=TRUE;
        srtRep.SRT_Time__c = 0.0;
        srtRep.Access_Code_A__c =0.0;
        //insert srtRep;
        
        CSS_Solution_Component__c srtComp = new CSS_Solution_Component__c();
        srtComp.Solutions__c = sol.id;
        srtComp.Quantity__c = 1;
        srtComp.Action__c='asdsad';
        srtComp.Service_Job__c =jo.id;
        srtComp.Selected_Component__c = true;
        insert srtComp;
        lssrtComp.add(srtComp);
        
        CSS_SRT__c srtRep1 =new CSS_SRT__c();
        srtRep1.Solution_Number__c=sol.id;
        srtRep1.Job_Order__c=Jo.id;
        srtRep1.Type__c = 'Repair';
        srtRep1.SRT_Time__c = 2000.0;
        srtRep1.isPerformed__c=TRUE;
        srtRep1.Access_Code_A__c =200.0;
        srtRep1.Component_Id__c =srtComp.id;
        //insert srtRep1;
        lstSRTRep.add(srtRep1);
        lstSRTRep.add(srtRep);
        
        
        CSS_SRT__c srtofComp =new CSS_SRT__c();
        srtofComp.Solution_Number__c=sol.id;
        srtofComp.Job_Order__c=Jo.id;
        srtofComp.Type__c = 'Repair';
        srtofComp.isPerformed__c=TRUE;
        srtofComp.SRT_Time__c = 2000.0;
        srtofComp.Access_Code_A__c =200.0;
        srtofComp.Response_Message__c='Test';
        srtofComp.Component_Id__c =srtComp.id;
        srtofComp.Solution_Number__c =sol.id;
        srtofComp.Job_Order__c = jo.id;
        
        
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Service_Job__c=Jo.id;
        parts.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts.Fail_Code__c = 'THAC';
        parts.selected_part__c = True;
        lstparts.add(parts);
        system.debug('parts.Fail_Code__c'+parts.Fail_Code__c);
        
        
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.selected_part__c = True;
        parts1.Service_Job__c=Jo.id;
        // parts1.Solutions__c = srtComp.Id;
        parts1.FailurepartId__c = srtComp.Id;
        parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts1.Fail_Code__c = 'THAS';
        lstparts.add(parts1);
        insert lstparts;
        
        
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);        
        pageRef.getParameters().put('id',jo.id);
        pageRef.getParameters().put('SeqNum',string.valueOf(symQA.Sequence__c));
        pageRef.getParameters().put('symId',jo.id);
        
        
        //ApexPages.StandardController con = new ApexPages.StandardController(JO);
        ext = new CSS_SymptomFCSearch();
        
        //symQAWrapper()
        CSS_SymptomFCSearch.symQAWrapper symwraper= new CSS_SymptomFCSearch.symQAWrapper();
        ext.totalSolution = 0;
        
        List<String> FcListFCSearch1 = new List<String>();         
        string Str ='[answersNext=(ansChoice:[ansCaption=No Fault Codes, ansID=1132#38782], ansChoice:[ansCaption=112, ansID=1132#25526], ansChoice:[ansCaption=124, ansID=1132#25549], ansChoice:[ansCaption=125, ansID=1132#41137], ansChoice:[ansCaption=155, ansID=1132#25607], ansChoice:[ansCaption=158, ansID=1132#25613], ansChoice:[ansCaption=162, ansID=1132#25619], ansChoice:[ansCaption=165, ansID=1132#25625], ansChoice:[ansCaption=237, ansID=1132#25735], ansChoice:[ansCaption=291, ansID=1132#25825], ...), cardinality=1, quesID=10#1494, question=Select the active fault code from the list below. If no fault codes are active, selectNo Fault Codes Present and click the NEXT button., solEDS=null, solRank=33]';
        FcListFCSearch1.add(Str);
        
        
        ext.descr = 'asdasdasd';
        ext.category = 'radio';
        List<SelectOption> options = new List<SelectOption>();
        List<SelectOption> optionstwo =new List<SelectOption>();
        Integer SeqNum = 1;        
        
        optionstwo.add(new SelectOption('Miles',system.Label.CSS_Miles));
        ext.SeqNum = SeqNum;
        ext.options2 = optionstwo;
        ext.display = true;
        ext.displaySoln =true;
        ext.displaySolnCaptionOnly =true;
        ext.Cardinality = 1;
        ext.QuestionId  ='2123123';
        ext.ansChoiceCaption ='qww2312';
        ext.ansId ='qww2312';
        ext.multiChoiceSelect  ='multiChoice';
        ext.radioMapSelect ='radioMap';
        ext.FCCodeUI ='FcodeUI';
        ext.solName ='SolName';
        ext.solTitle = 'Soltitle';
        ext.solRank = 1;
        ext.radioSelect = null;
        ext.displaySoln = false;
        ext.FCCodeUI = '1233';
        ext.multiSelectAnswers = new List<String>{'12321','2132132','12333','123444'};
            ext.GlobDisplayList = lstSymQA; 
        ext.symptomQAs =lstSymQA;
        ext.solName = 'Sol1';
        //ext.dsidUpdate = false;
        
        //ext.searchTS(); 
    }
    private static void init2() {
        //CSS_Job_Order__c JO = new CSS_Job_Order__c();
        CSS_SymptomFCSearch symSearch = new CSS_SymptomFCSearch();
        symSearch.dsidIndi = 'test';
        symSearch.solSize = 12;
        symSearch.QuesResp = 'test';
        
        string searchText ='White Smoke';
        boolean display=true;
        boolean displaySoln=true;
        boolean displaySolnCaptionOnly =true;
        integer Cardinality =1;
        string QuestionId ='test345';
        
        //Integer SeqNum=1;
        String ansChoiceCaption ='asdasd';
        String ansId='213wdeda';
        String multiChoiceSelect='asd';
        string radioMapSelect='qwe';
        string radioSelect = 'asdsad';
        //    string category = 'radio';
        string radioSelec = 'asdsad';
        string radioSel = 'asdsad';
        boolean fstcall = true;
        string sortsolutions ='test';
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi2@cummins.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi2@cummins.com', User_Location__c='123456',Work_Group_Name__c = 'ban',isActive = true);
        objUser1.User_Location__c ='Bronx';
        objUser1.Work_Group_Name__c = 'wg';
        insert objUser1;
        
        JO = NEW CSS_Job_Order__c();
        JO.Unit_Number__c = '12345';
        JO.Failure_Point__c = 1.5;
        JO.Failure_Point_Measure__c = 'qw';       
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.ESN__c = 'test1234';
        jo.DSID_WorkGroup__c = '';
        JO.DSID_Creation_Timestamp__c = system.now();
        JO.DSID_Status__c = 'open';
        JO.ESN_Locked__c = true;
        JO.ESN_Insite__c = '79464646';
        JO.Application__c = 'test1234';
        JO.Failure_Point__c = 1234;
        JO.Failure_Point_Measure__c = 'test1234';
        JO.Make__c = 'BMC';
        JO.Equipment_ID__c = 'equip';
        JO.Model__c = 'MILITARY';
        JO.DSID__c = 'DSE222';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.AccessCode__c ='A';
        insert(JO);
        
        List<CSS_SymptomQA__c> lstSym = new List<CSS_SymptomQA__c>();
        List<CSS_SymptomQA__c> lstSymQA = new List<CSS_SymptomQA__c>();
        List<CSS_Solutions__c> lstSol = new List<CSS_Solutions__c>();
        List<CSS_SRT__c> lstSRT = new List<CSS_SRT__c>();
        List<CSS_SRT__c> lstSRTRep = new List<CSS_SRT__c>();
        List<CSS_Solution_Component__c> lssrtComp = new List<CSS_Solution_Component__c>();
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=JO.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =Jo.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        sym.Answers__c = 'FCCodeUI';
        sym.Caption__c = 'cap';
        sym.Sequence__c = 1.6;
        
        insert sym;
        
        lstSym.add(sym);
        
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        symQA.Job_Order__c=Jo.id;
        symQA.caption__c ='white smoke';
        symQA.Option1__c  ='12213';
        symQA.SearchString__c = sym.id;
        symQA.Option_type__c  ='qwewqe';
        symQA.Sequence__c =1;
        symQA.Type__c  ='QA';
        
        insert symQA;
        
        lstSymQA.add(symQA);
        
        CSS_SymptomQA__c symQA1=new CSS_SymptomQA__c();
        symQA1.Job_Order__c=Jo.id;
        symQA1.caption__c ='white smoke';
        symQA1.Option1__c  ='1222134213413';
        symQA1.SearchString__c = sym.id;
        symQA1.Option_type__c  ='wewqe';
        symQA1.Sequence__c =2;
        symQA1.Type__c  ='SearchString';
        
        insert symQA1;
        
        lstSymQA.add(symQA1);
        
        CSS_SymptomQA__c symQA2=new CSS_SymptomQA__c();
        symQA2.Job_Order__c=Jo.id;
        symQA2.caption__c ='white smoke';
        symQA2.Option1__c  ='1222134213413';
        symQA2.SearchString__c = sym.id;
        symQA2.Option_type__c  ='wewqe';
        symQA2.Sequence__c =3;
        symQA2.Type__c  ='QA';
        
        insert symQA2;
        
        lstSymQA.add(symQA2);
        
        CSS_SymptomQA__c symQA3=new CSS_SymptomQA__c();
        symQA3.Job_Order__c=Jo.id;
        symQA3.caption__c ='white smoke';
        symQA3.Option1__c  ='1222134213413';
        symQA3.SearchString__c = symQA2.id;
        symQA3.Option_type__c  ='wewqe';
        symQA3.Sequence__c =2;
        symQA3.Type__c  ='QA';
        
        insert symQA3;
        
        lstSymQA.add(symQA3);
        
        CSS_Solutions__c sol=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol.Case_Name__c='test';
        sol.Name = 'sol';
        sol.Rank__c = 0;
        // sol.Diagnostic_Response__c='test';
        sol.Diagnostic_Response__c = null;
        sol.Repair_Response__c='test';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=JO.id;
        insert sol;
        CSS_Solutions__c sol1=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol1.Case_Name__c='test';
        sol1.Name = 'sol';
        sol1.Rank__c = null;
        //sol1.Diagnostic_Response__c='test1';
        sol1.Diagnostic_Response__c = null;
        sol1.Repair_Response__c='test2';
        sol1.Symptom__c=symQA1.id;
        sol1.Service_Job__c=Jo.id;
        insert sol1;
        
        CSS_Solutions__c sol2=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol2.Case_Name__c='test';
        sol2.Name = 'sol';
        sol2.Rank__c = null;
        //sol1.Diagnostic_Response__c='test1';
        sol2.Diagnostic_Response__c = null;
        sol2.Repair_Response__c='test2';
        sol2.Symptom__c=symQA1.id;
        sol2.Service_Job__c=jo.id;
        insert sol2;
        
        lstSol.add(sol1);
        lstSol.add(sol);
        lstSol.add(sol2);
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=Jo.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c = 0.0;       
        srt.Access_Code_A__c =0.0;
        //insert srt;
        
        CSS_SRT__c srt1=new CSS_SRT__c();
        srt1.Solution_Number__c=sol.id;
        srt1.Job_Order__c=Jo.id;
        srt1.Type__c = 'Diagnosis';
        srt1.SRT_Time__c = .20;
        srt1.Access_Code_A__c =200.0;
        //insert srt1;
        
        lstSRT.add(srt);
        lstSRT.add(srt1);
        
        CSS_SRT__c srtRep =new CSS_SRT__c();
        srtRep.Solution_Number__c=sol.id;
        srtRep.Job_Order__c=Jo.id;
        srtRep.Type__c = 'Repair';
        srtRep.isPerformed__c=TRUE;
        srtRep.SRT_Time__c = 0.0;
        srtRep.Access_Code_A__c =0.0;
        //insert srtRep;
        
        CSS_Solution_Component__c srtComp = new CSS_Solution_Component__c();
        srtComp.Solutions__c = sol.id;
        srtComp.Quantity__c = 1;
        srtComp.Action__c='asdsad';
        srtComp.Service_Job__c =jo.id;
        srtComp.Selected_Component__c = true;
        insert srtComp;
        lssrtComp.add(srtComp);
        
        CSS_SRT__c srtRep1 =new CSS_SRT__c();
        srtRep1.Solution_Number__c=sol.id;
        srtRep1.Job_Order__c=Jo.id;
        srtRep1.Type__c = 'Repair';
        srtRep1.SRT_Time__c = 2000.0;
        srtRep1.isPerformed__c=TRUE;
        srtRep1.Access_Code_A__c =200.0;
        srtRep1.Component_Id__c =srtComp.id;
        //insert srtRep1;
        lstSRTRep.add(srtRep1);
        lstSRTRep.add(srtRep);
        
        
        CSS_SRT__c srtofComp =new CSS_SRT__c();
        srtofComp.Solution_Number__c=sol.id;
        srtofComp.Job_Order__c=Jo.id;
        srtofComp.Type__c = 'Repair';
        srtofComp.isPerformed__c=TRUE;
        srtofComp.SRT_Time__c = 2000.0;
        srtofComp.Access_Code_A__c =200.0;
        srtofComp.Response_Message__c='Test';
        srtofComp.Component_Id__c =srtComp.id;
        srtofComp.Solution_Number__c =sol.id;
        srtofComp.Job_Order__c = jo.id;
        
        
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Service_Job__c=Jo.id;
        parts.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts.Fail_Code__c = 'THAC';
        parts.selected_part__c = True;
        lstparts.add(parts);
        system.debug('parts.Fail_Code__c'+parts.Fail_Code__c);
        
        
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.selected_part__c = True;
        parts1.Service_Job__c=Jo.id;
        // parts1.Solutions__c = srtComp.Id;
        parts1.FailurepartId__c = srtComp.Id;
        parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts1.Fail_Code__c = 'THAS';
        lstparts.add(parts1);
        insert lstparts;
        
        
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);        
        pageRef.getParameters().put('id',jo.id);
        pageRef.getParameters().put('SeqNum',string.valueOf(symQA.Sequence__c));
        pageRef.getParameters().put('symId',jo.id);
        
        
        //ApexPages.StandardController con = new ApexPages.StandardController(JO);
        ext = new CSS_SymptomFCSearch();
        
        //symQAWrapper()
        CSS_SymptomFCSearch.symQAWrapper symwraper= new CSS_SymptomFCSearch.symQAWrapper();
        ext.totalSolution = 0;
        
        List<String> FcListFCSearch1 = new List<String>();         
        string Str ='[answersNext=(ansChoice:[ansCaption=No Fault Codes, ansID=1132#38782], ansChoice:[ansCaption=112, ansID=1132#25526], ansChoice:[ansCaption=124, ansID=1132#25549], ansChoice:[ansCaption=125, ansID=1132#41137], ansChoice:[ansCaption=155, ansID=1132#25607], ansChoice:[ansCaption=158, ansID=1132#25613], ansChoice:[ansCaption=162, ansID=1132#25619], ansChoice:[ansCaption=165, ansID=1132#25625], ansChoice:[ansCaption=237, ansID=1132#25735], ansChoice:[ansCaption=291, ansID=1132#25825], ...), cardinality=1, quesID=10#1494, question=Select the active fault code from the list below. If no fault codes are active, selectNo Fault Codes Present and click the NEXT button., solEDS=null, solRank=33]';
        FcListFCSearch1.add(Str);
        
        
        ext.descr = 'asdasdasd';
        ext.category = 'radio';
        List<SelectOption> options = new List<SelectOption>();
        List<SelectOption> optionstwo =new List<SelectOption>();
        Integer SeqNum = 1;        
        
        optionstwo.add(new SelectOption('Miles',system.Label.CSS_Miles));
        ext.SeqNum = SeqNum;
        ext.options2 = optionstwo;
        ext.display = true;
        ext.displaySoln =true;
        ext.displaySolnCaptionOnly =true;
        ext.Cardinality = 1;
        ext.QuestionId  ='2123123';
        ext.ansChoiceCaption ='qww2312';
        ext.ansId ='qww2312';
        ext.multiChoiceSelect  ='multiChoice';
        ext.radioMapSelect ='radioMap';
        ext.FCCodeUI ='FcodeUI';
        ext.solName ='SolName';
        ext.solTitle = 'Soltitle';
        ext.solRank = 1;
        ext.radioSelect ='asdsad';
        ext.displaySoln = false;
        ext.FCCodeUI = '1233';
        ext.multiSelectAnswers = new List<String>{'12321','2132132','12333','123444'};
            ext.GlobDisplayList = lstSymQA; 
        ext.symptomQAs =lstSymQA;
        ext.solName = 'Sol1';
        //ext.dsidUpdate = false;
        
        //ext.searchTS(); 
    }
    Static testMethod void SymptomSearch(){
        init();
        JO.Application_Desc__c = 'test';
        JO.Make__c = 'test1';
        JO.Model__c = 'test2';
        update JO;
        Test.startTest();
        
        string searchText ='White Smoke';
        boolean display=true;
        boolean displaySoln=true;
        boolean displaySolnCaptionOnly=true;
        integer Cardinality =1;
        string QuestionId ='test345';
        Integer SeqNum = 1;
        
        List<CSS_EDSAuthentication.nextQues> FcLst = new List<CSS_EDSAuthentication.nextQues>();
        
        //Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomSearch_Test());
        
        // Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomSearch_Test());
        FcLst=CSS_EDSAuthentication.getSymptomSearch('freeText','esn1','application','unitNum',32.1,'measure','mak','mod','eqID','custName','servModel','shopWork','ds','lang','dsidIndi');
        ext.SymptomSearch('smoke');
        List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
        List<CSS_EDSAuthentication.ansChoice> answersNext = new List<CSS_EDSAuthentication.ansChoice>();
        CSS_EDSAuthentication.ansChoice anschoice = new CSS_EDSAuthentication.ansChoice('t','t1');
        CSS_EDSAuthentication.ansChoice anschoice2 = new CSS_EDSAuthentication.ansChoice('t','t2');
        answersNext.add(anschoice);
        answersNext.add(anschoice2); 
        List<CSS_EDSAuthentication.solutionEDS> solEDS = new  List<CSS_EDSAuthentication.solutionEDS>();
        CSS_EDSAuthentication.solutionEDS eds1 = new CSS_EDSAuthentication.solutionEDS('test','title',0);
        CSS_EDSAuthentication.solutionEDS eds2 = new CSS_EDSAuthentication.solutionEDS('test1','title1',2);
        solEDS.add(eds1);
        solEDS.add(eds2);     
        CSS_EDSAuthentication.nextQues q1 = new CSS_EDSAuthentication.nextQues( 'question', 'quesID',answersNext,0,solEDS,1,true,1,null,null,null,null,null);
        CSS_EDSAuthentication.nextQues q2 = new CSS_EDSAuthentication.nextQues( 'question', 'quesID',answersNext,0,solEDS,1,true,1,null,null,null,null,null);
        FcLstQ.add(q1);
        FcLstQ.add(q2);
        // ext.SymptomSearch('smoke');
        
        // insert(JO);
        Test.stopTest();
        
    }
    Static testMethod void searchTS1(){
        
        Test.startTest();
        init();
        JO.DSID__c = 'test';
        JO.ESN__c = null;
        JO.Customer_Name__c ='Cummins';
        update JO;
        
        string searchText ='White Smoke';
        boolean display=true;
        boolean displaySoln=true;
        boolean displaySolnCaptionOnly=true;
        integer Cardinality =1;
        string QuestionId ='test345';
        Integer SeqNum=1;
        string radioSelect = '213131';
        
        List<String> multiSel = new List<String> { 'one', 'two' };
            string ansRadio = '18313#8529';																			
        string ques ='10%2336366';
        ext.searchText = searchText;
        String  DSID = CSS_EDSAuthentication.getDSID(jo.ESN__c,jo.name,jo.Application_Desc__c,jo.Unit_Number__c,jo.Mileage__c,
                                                     jo.Mileage_Measure__c,jo.Make__c,jo.Model__c,jo.Equipment_ID__c,jo.Customer_Name__c,
                                                     jo.Service_Model__c,jo.Shop_Work_Order__c,jo.AccessCode__c);
        ext.searchTS();
        List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        FcLstQ= CSS_EDSAuthentication.getQues(null,ansRadio,ques,'DSBDT4780','en','O'); 
        
        List<CSS_EDSAuthentication.nextQues> FcLst = new List<CSS_EDSAuthentication.nextQues>();        
        //Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomSearch_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        ext.buildGlobalList(1,'test123213',null);
        ext.buildGlobalList(1,null,multiSel);
        ext.showSoln(FcLst);
        //ext.DSID=' TEst ID'; 
        //ext.dsidUpdate=true;
        //ext.showSoln(FcLst);
        
        //ext.SymptomSearch('smoke');
        
        CSS_SymptomFCSearch SymFC = new CSS_SymptomFCSearch();
        CSS_Job_Order__c Job = new CSS_Job_Order__c();
        Job = CSS_TestData.createJobOrder(false);
        system.debug('JobIdddddd**'+Job.id);
        List<CSS_SymptomQA__c> Strist= new List<CSS_SymptomQA__c>();
        //init();
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=Job.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =Job.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        
        insert sym;
        
        Strist.add(sym);
        
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        symQA.Job_Order__c=Job.id;
        symQA.caption__c ='white smoke';
        symQA.Option1__c  ='12213';
        symQA.SearchString__c = sym.id;
        symQA.Option_type__c  ='qwewqe';
        symQA.Sequence__c =1;
        symQA.Type__c  ='QA';
        
        insert symQA;
        
        Strist.add(symQA);
        
        system.debug('Strist****'+Strist);
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
        FcListFCSearch = CSS_EDSAuthentication.getFCSympSearch('123',null,null,null,0,'Miles',null,null,null,null,null,null,'DSBDT4780','en','O');
        SymFC.insertSearchStr(Strist);
        SymFC.symptomQAs = Strist;
        SymFc.searchTS();
        SymFc.searchText=null;
        SymFc.searchTS();
        SymFc.showSoln1(FcListFCSearch);
        Test.stopTest();
        
    }
    Static testMethod void searchTS(){
        Test.startTest();
        init();
        string searchText ='White Smoke';
        boolean display=true;
        boolean displaySoln=true;
        boolean displaySolnCaptionOnly=true;
        integer Cardinality =1;
        string QuestionId ='test345';
        Integer SeqNum=1;
       
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi2@cummins.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi2@cummins.com', User_Location__c='123456',Work_Group_Name__c = 'ban',isActive = true);
        Jo.DSID__c = 'error.invalid';//'DSE222';
        Jo.ESN__c = '2321321';
        Jo.Customer_Name__c ='Cummins';
        Jo.DSID_WorkGroup__c = null;
        update Jo;
        
        List<CSS_SymptomQA__c> Strist= new List<CSS_SymptomQA__c>();
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=Jo.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        insert sym;
        Strist.add(sym);
        
        string radioSelect = '213131';
        List<String> multiSel = new List<String> { 'one', 'two' };
            string ansRadio = '18313#8529';
        string ques ='10%2336366';
        ext.searchText = '123';
        ext.SymptomFCSearch('test');
        ext.searchTS();
        List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        FcLstQ= CSS_EDSAuthentication.getQues(null,ansRadio,ques,'DSBDT4780','en','O'); 
        
        
        
        List<CSS_EDSAuthentication.nextQues> FcLst = new List<CSS_EDSAuthentication.nextQues>();        
        //Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomSearch_Test());
        //Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        ext.buildGlobalList(1,'test123213',null);
        ext.buildGlobalList(1,null,multiSel);
        //  ext.buildLocalList(1,'test124',null);
        // ext.buildLocalList(1,null,multiSel);
        //ext.btnContd();
        //ext.showQuest(FcLstQ,0);
        //ext.showQuestSearchCall(FcLstQ,0);
        //ext.SymptomSearch('smoke');
        ext.searchText=null;
        ext.searchTS();
        Test.stopTest();
        
    }
    Static testMethod void buildLocalListMethod(){
        
        init();
        Test.startTest();
        List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
        List<CSS_EDSAuthentication.ansChoice> answersNext = new List<CSS_EDSAuthentication.ansChoice>();
        CSS_EDSAuthentication.ansChoice anschoice = new CSS_EDSAuthentication.ansChoice('t','t1');
        CSS_EDSAuthentication.ansChoice anschoice2 = new CSS_EDSAuthentication.ansChoice('t','t2');
        answersNext.add(anschoice);
        answersNext.add(anschoice2); 
        List<CSS_EDSAuthentication.solutionEDS> solEDS = new  List<CSS_EDSAuthentication.solutionEDS>();
        CSS_EDSAuthentication.solutionEDS eds1 = new CSS_EDSAuthentication.solutionEDS('test','title',0);
        CSS_EDSAuthentication.solutionEDS eds2 = new CSS_EDSAuthentication.solutionEDS('test1','title1',2);
        solEDS.add(eds1);
        solEDS.add(eds2);     
        CSS_EDSAuthentication.nextQues q1 = new CSS_EDSAuthentication.nextQues( 'question', 'quesID',answersNext,0,solEDS,1,true,1,null,null,null,null,null);
        CSS_EDSAuthentication.nextQues q2 = new CSS_EDSAuthentication.nextQues( 'question', 'quesID',answersNext,0,solEDS,1,true,1,null,null,null,null,null);
        FcLstQ.add(q1);
        FcLstQ.add(q2);
        List<String> multiSelectAnswer = new List<String>();
        string s1 ='Test';
        string s2 = 'Data';
        string s3 = 'Testing';
        multiSelectAnswer.add(s1);
        multiSelectAnswer.add(s2);
        multiSelectAnswer.add(s3);
        CSS_SymptomFCSearch obj = new CSS_SymptomFCSearch();
        obj.buildLocalList(10,'radioSelecIns',multiSelectAnswer,FcLstQ);
        Test.stopTest();
    }
    Static testMethod void testbuildLocalList1(){
        List<String> multiSel = new List<String> { 'one', 'two' ,'three','four'};
            init();
        Test.startTest();
        List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        //   ext.buildLocalList(1,null,multiSel);
    }
    Static testMethod void testbuildGlobList(){
        
        init();
        Test.startTest();
        ext.buildGlobalList(1,'test124',null);
    }
    Static testMethod void testbuildGlobList1(){
        List<String> multiSel = new List<String> { 'one', 'two' ,'three','four'};
            init();
        Test.startTest();
        ext.buildGlobalList(1,null,multiSel);
    }
    Static testMethod void testinsertLocalList(){
        List<CSS_SymptomQA__c> multiSel = new List<CSS_SymptomQA__c>();
        init();
        Test.startTest();
        ext.insertLocalList(multiSel);
    }
    Static testMethod void testinsertSearchStr(){
        CSS_SymptomFCSearch SymFC = new CSS_SymptomFCSearch();
        CSS_Job_Order__c Job = new CSS_Job_Order__c();
        Job = CSS_TestData.createJobOrder(false);
        system.debug('JobIdddddd**'+Job.id);
        List<CSS_SymptomQA__c> Strist= new List<CSS_SymptomQA__c>();
        //init();
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=Job.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =Job.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        
        insert sym;
        
        Strist.add(sym);
        
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        symQA.Job_Order__c=Job.id;
        symQA.caption__c ='white smoke';
        symQA.Option1__c  ='12213';
        symQA.SearchString__c = sym.id;
        symQA.Option_type__c  ='qwewqe';
        symQA.Sequence__c =1;
        symQA.Type__c  ='QA';
        
        insert symQA;
        
        Strist.add(symQA);
        
        system.debug('Strist****'+Strist);
        SymFC.insertSearchStr(Strist);
        
    }
    Static testMethod void testcancelBtn(){
        
        init();
        Test.startTest();
        ext.cancelBtn();
    }
    Static testMethod void testSymptomFCSearch(){
        init();
        Test.startTest();
        string searchText ='123';
        boolean display=true;
        boolean displaySoln=true;
        boolean displaySolnCaptionOnly=true;
        integer Cardinality =1;
        string QuestionId ='test345';
        Integer SeqNum=1;
        
       CSS_accountLanguage__c accntLang = new CSS_accountLanguage__c();
        accntLang.name = 'en';
        accntLang.CSS_QsolLanguage__c = 'en';
        accntLang.CSS_userLanguage__c = 'en';
        accntLang.CSS_EDSLanguage__c = 'en';
        insert(accntLang);
        
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
        
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomFCSearch_Test1());
       
        FcListFCSearch = CSS_EDSAuthentication.getFCSympSearch('123',Jo.ESN__c,Jo.Application__c,Jo.Unit_Number__c,Jo.Failure_Point__c,Jo.Failure_Point_Measure__c,
                                                               Jo.Make__c,Jo.Model__c,Jo.Equipment_ID__c,Jo.Customer_Name__c,Jo.Service_Model__c,Jo.Shop_Work_Order__c,'12213213','en','O');
        
        
        
        system.debug('MSNFcListFCSearch'+FcListFCSearch);
        //CSS_SymptomFCSearch sFC = new CSS_SymptomFCSearch();
        
        
        ext.aLang=accntLang;
        ext.SymptomFCSearch('123');
        ext.searchTS();
        ext.searchText=null;
        ext.searchTS();
        ext.SymptomFCSearch('test');
        // insert(JO);
        Test.stopTest();
        
    }
    Static testMethod void testSymptomFCSearch1(){
        init();
        Test.startTest();
        string searchText ='123';
        boolean display=true;
        boolean displaySoln=true;
        boolean displaySolnCaptionOnly=true;
        integer Cardinality =1;
        string QuestionId ='test345';
        Integer SeqNum=1;
        
        
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
        
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomFCSearch_Test());
        
        FcListFCSearch = CSS_EDSAuthentication.getFCSympSearch('123',Jo.ESN__c,Jo.Application__c,Jo.Unit_Number__c,Jo.Failure_Point__c,Jo.Failure_Point_Measure__c,
                                                               Jo.Make__c,Jo.Model__c,Jo.Equipment_ID__c,Jo.Customer_Name__c,Jo.Service_Model__c,Jo.Shop_Work_Order__c,'12213213','en','O');
        
        
        
        system.debug('MSNFcListFCSearch'+FcListFCSearch);
        //CSS_SymptomFCSearch sFC = new CSS_SymptomFCSearch();
        
        
        
        ext.SymptomFCSearch('123');
        ext.searchTS();
        ext.searchText=null;
        ext.searchTS();
        ext.SymptomFCSearch('test');
        // insert(JO);
        Test.stopTest();
        
    }
    Static testMethod void testgetQCall(){
        init();
        Test.startTest();
        
        
        List<String> multiSel = new List<String> { 'one', 'two' };
            
            List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        string ansRadio = '18313#8529';
        string ques ='10%2336366';
        //Jo.DSID__c = null;
        Jo.DSID__c = 'DS233';
        Jo.ESN__c = '2321321';
        Jo.Customer_Name__c ='Cummins';
        update Jo;
        
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        //CSS_SymptomFCSearch sFC = new CSS_SymptomFCSearch();
        ext.buildQuest(null,'12323','32432',true,'getQ');
        
        Test.setMock(HttpCalloutMock.class, new CSS_CreateDSID_Test());
        
        
        
    }
    Static testMethod void testgetNextQCall(){
        init();
        Test.startTest();
        
        
        List<String> multiSel = new List<String> { 'one', 'two' };
            
            List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        string ansRadio = '18313#8529';
        string ques ='10%2336366';
        
        Test.setMock(HttpCalloutMock.class, new CSS_GetNextQues_Test());
        //CSS_SymptomFCSearch sFC = new CSS_SymptomFCSearch();
        ext.NextbuildQuest(null,'12323','32432',true,'getNextQ');
        //ext.CallWS = true;
        
    }
    Static testMethod void testgetAllSolnCount(){
        Test.startTest();
        init();
        
        CSS_SymptomFCSearch exte = new CSS_SymptomFCSearch();
        exte.getAllSolnCount();
    }
    Static testMethod void testsearchTS(){
        
        init2();
        string ansRadio = '18313#8529';
        string ques ='10%2336366';
        Jo.DSID__c = '';
        Jo.ESN__c = null;
        Jo.DSID_WorkGroup__c = 'DSID1234';
        Jo.Customer_Name__c ='Cummins';
        update Jo;
        css_job_order__c jo1 = new css_job_order__c();
        jo1.AccessCode__c = 'test';
        jo1.ESN__c = null;
        insert jo1;
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
        FcListFCSearch = CSS_EDSAuthentication.getFCSympSearch('123',null,null,null,0,'Miles',null,null,null,null,null,null,'DSBDT4780','en','O');
        Test.startTest();
        ext.searchText='White Smoke';
        //ext.dsidUpdate = true;
        css_utility.getDSIDEditIndicator(userinfo.getUserId(),'dsi344', 'dsi344');
        ext.SymptomFCSearch('test');
        ext.searchTS();
        ext.myBase64String = 'Q1NTfDE0Nzg4MDk1NjAwMTc';
        ext.gettoken();
        ext.getService();
        ext.showSoln1(FcListFCSearch);
    }
    Static testMethod void testbuildGlobalList(){
        
        init();
        Test.startTest();
        ext.buildGlobalList(1,'test123213',null);
    }
    Static testMethod void testbuildGlobalList1(){
        List<String> multiSel = new List<String> { 'one', 'two' };
            init();
        Test.startTest();
        ext.buildGlobalList(1,null,multiSel);
    }
    Static testMethod void testshowSolutions(){
        
        init();
        Test.startTest();
        ext.showSolutions();
        //ext.getPartDetails();
        ext.getmultiSelectAnswers();
        ext.getGlobDisplayList();
        ext.getradioSelect();
        
        List<String> x= ext.getmultiSelectAnswers();
        ext.setmultiSelectAnswers(x);
        List<CSS_SymptomQA__c> g = ext.getGlobDisplayList();
        ext.setGlobDisplayList(g);
        string y= ext.getradioSelect();
        ext.setradioSelect(y);
    }
    Static testMethod void testshowSolutions1(){
        
        init();
        Test.startTest();
        ext.solutionsdesc = '2';
        ext.showSolutions();
        ext.sortsolutions = 'test';
        list<CSS_SymptomQA__c> jobs = new list<CSS_SymptomQA__c>();
        ext.jobsolutions = jobs;
    }
    Static testMethod void testVerSolDetails(){
        
        init();
        Test.startTest();
        ext.showSolutions();
        ext.getPartDetails();
        ext.getVerSolDetails();        
        ext.getRepairDetails();
        ext.getSolutions();
        ext.getAllSolDetails();
        ext.symCodeClick();
        //ext.navigateToRepair();        
        ext.getDiagSRTDetails();
        ext.getRepSRTDetails();
        Test.stopTest();
    }
    Static testMethod void testshowQuest(){
        init();
        Test.startTest();
        string radioSelect = '213131';
        integer Cardinality =1;
        List<String> multiSel = new List<String> { 'one', 'two' };
            string ansRadio = '18313#8529';
        string ques ='10%2336366';
        string category = 'checkbox';
        List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        FcLstQ= CSS_EDSAuthentication.getQues(null,ansRadio,ques,'DSBDT4780','en','O'); 
        System.debug('MSN'+FcLstQ);
        ext.buildGlobalList(1,'test123213',null);
        ext.buildGlobalList(1,null,multiSel);
        ext.buildLocalList(1,'null',multiSel,FcLstQ);
        //  ext.buildLocalList(1,'test124',null);
        // ext.buildLocalList(1,null,multiSel);
        //ext.btnContd();
        // ext.showQuest(FcLstQ,0);
        ext.showQuestSearchCall(FcLstQ,0);
    }
    Static testMethod void testshowQuestSearch(){
        
        
        init();
        
        Test.startTest();
        string radioSelect = '213131';
        boolean fstcall = true;
        List<String> multiSel = new List<String> { 'one', 'two' };
            string ansRadio = '18313#8529';
        string ques ='10%2336366';
        string category = 'checkbox';
        List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        FcLstQ= CSS_EDSAuthentication.getQues(null,ansRadio,ques,'DSBDT4780','en','O'); 
        System.debug('MSNHAHAHAH'+FcLstQ);
        ext.buildGlobalList(1,'test123213',null);
        ext.buildGlobalList(1,null,multiSel);
        //   ext.buildLocalList(1,'test124',null);
        //  ext.buildLocalList(1,null,multiSel);
        ext.SymptomFCSearch('test');
        ext.btnContd();
        //ext.showQuest(FcLstQ,0);
        ext.showQuestSearchCall(FcLstQ,0);
    }
    Static testMethod void testshowQuestMultiAns(){
        init2();
        Test.startTest();
        string radioSelect = '213131';
        boolean fstcall = true;
        List<String> multiSel = new List<String> { 'one', 'two' };
            string ansRadio = '18313#8529';
        string ques ='10%2336366';
        string category = 'checkbox';
        List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        FcLstQ= CSS_EDSAuthentication.getQues(null,ansRadio,ques,'DSBDT4780','en','O'); 
        System.debug('MSNHAHAHAH'+FcLstQ);
        ext.buildGlobalList(1,'test123213',null);
        ext.buildGlobalList(1,null,multiSel);
        //   ext.buildLocalList(1,'test124',null);
        ext.buildLocalList(1,'test',multiSel,FcLstQ);
        
        ext.btnContd();
        //ext.showQuest(FcLstQ,0);
        ext.showQuestSearchCall(FcLstQ,0);
    }
    Static testMethod void testbtnContd(){
        
        //private static void init() {
        //CSS_Job_Order__c JO = new CSS_Job_Order__c();
        CSS_SymptomFCSearch symSearch = new CSS_SymptomFCSearch();
        symSearch.dsidIndi = 'test';
        symSearch.solSize = 12;
        symSearch.QuesResp = 'test';
        
        string searchText ='White Smoke';
        boolean display=true;
        boolean displaySoln=true;
        boolean displaySolnCaptionOnly =true;
        integer Cardinality =2;
        string QuestionId ='test345';
        
        //Integer SeqNum=1;
        String ansChoiceCaption ='asdasd';
        String ansId='213wdeda';
        String multiChoiceSelect='asd';
        string radioMapSelect='qwe';
        string radioSelect = 'asdsad';
        //string category = 'radio';
        string radioSelec = 'asdsad';
        string radioSel = 'asdsad';
        boolean fstcall = true;
        string sortsolutions ='test';
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi2@cummins.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi2@cummins.com', User_Location__c='123456',Work_Group_Name__c = 'ban',isActive = true);
        objUser1.User_Location__c ='Bronx';
        objUser1.Work_Group_Name__c = 'wg';
        insert objUser1;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        JO = NEW CSS_Job_Order__c();
        JO.Account__c = acc.Id;
        JO.Unit_Number__c = '12345';
        JO.Failure_Point__c = 1.5;
        JO.Failure_Point_Measure__c = 'qw';       
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.ESN__c = 'test1234';
        jo.DSID_WorkGroup__c = '';
        JO.DSID_Creation_Timestamp__c = system.now();
        JO.DSID_Status__c = 'open';
        JO.ESN_Locked__c = true;
        JO.ESN_Insite__c = '79464646';
        JO.Application_Desc__c = 'Application';
        JO.Application__c = 'test1234';
        JO.Failure_Point__c = 1234;
        JO.Failure_Point_Measure__c = 'test1234';
        JO.Make__c = 'BMC';
        JO.Equipment_ID__c = 'equip';
        JO.Model__c = 'MILITARY';
        //      JO.DSID__c = 'DSE222';
        JO.DSID__c = null;
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.AccessCode__c ='A';
        insert(JO);
        
        List<CSS_SymptomQA__c> lstSym = new List<CSS_SymptomQA__c>();
        List<CSS_SymptomQA__c> lstSymQA = new List<CSS_SymptomQA__c>();
        List<CSS_Solutions__c> lstSol = new List<CSS_Solutions__c>();
        List<CSS_SRT__c> lstSRT = new List<CSS_SRT__c>();
        List<CSS_SRT__c> lstSRTRep = new List<CSS_SRT__c>();
        List<CSS_Solution_Component__c> lssrtComp = new List<CSS_Solution_Component__c>();
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=JO.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =Jo.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        sym.Answers__c = 'FCCodeUI';
        sym.Caption__c = 'cap';
        sym.Sequence__c = 1.6;
        
        insert sym;
        
        lstSym.add(sym);
        
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        symQA.Job_Order__c=Jo.id;
        symQA.caption__c ='white smoke';
        symQA.Option1__c  ='12213';
        symQA.SearchString__c = sym.id;
        symQA.Option_type__c  ='qwewqe';
        symQA.Sequence__c =1;
        symQA.Type__c  ='QA';
        
        insert symQA;
        
        lstSymQA.add(symQA);
        
        CSS_SymptomQA__c symQA1=new CSS_SymptomQA__c();
        symQA1.Job_Order__c=Jo.id;
        symQA1.caption__c ='white smoke';
        symQA1.Option1__c  ='1222134213413';
        symQA1.SearchString__c = sym.id;
        symQA1.Option_type__c  ='wewqe';
        symQA1.Sequence__c =2;
        symQA1.Type__c  ='SearchString';
        
        insert symQA1;
        
        lstSymQA.add(symQA1);
        
        CSS_SymptomQA__c symQA2=new CSS_SymptomQA__c();
        symQA2.Job_Order__c=Jo.id;
        symQA2.caption__c ='white smoke';
        symQA2.Option1__c  ='1222134213413';
        symQA2.SearchString__c = sym.id;
        symQA2.Option_type__c  ='wewqe';
        symQA2.Sequence__c =3;
        symQA2.Type__c  ='QA';
        
        insert symQA2;
        
        lstSymQA.add(symQA2);
        
        CSS_SymptomQA__c symQA3=new CSS_SymptomQA__c();
        symQA3.Job_Order__c=Jo.id;
        symQA3.caption__c ='white smoke';
        symQA3.Option1__c  ='1222134213413';
        symQA3.SearchString__c = symQA2.id;
        symQA3.Option_type__c  ='wewqe';
        symQA3.Sequence__c =2;
        symQA3.Type__c  ='QA';
        
        insert symQA3;
        
        lstSymQA.add(symQA3);
        
        CSS_Solutions__c sol=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol.Case_Name__c='test';
        sol.Name = 'sol';
        sol.Rank__c = 0;
        // sol.Diagnostic_Response__c='test';
        sol.Diagnostic_Response__c = null;
        sol.Repair_Response__c='test';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=JO.id;
        insert sol;
        CSS_Solutions__c sol1=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol1.Case_Name__c='test';
        sol1.Name = 'sol';
        sol1.Rank__c = null;
        //sol1.Diagnostic_Response__c='test1';
        sol1.Diagnostic_Response__c = null;
        sol1.Repair_Response__c='test2';
        sol1.Symptom__c=symQA1.id;
        sol1.Service_Job__c=Jo.id;
        insert sol1;
        
        CSS_Solutions__c sol2=new CSS_Solutions__c();
        //  sol.caseIndexInResultSet__c='test';
        sol2.Case_Name__c='test';
        sol2.Name = 'sol';
        sol2.Rank__c = null;
        //sol1.Diagnostic_Response__c='test1';
        sol2.Diagnostic_Response__c = null;
        sol2.Repair_Response__c='test2';
        sol2.Symptom__c=symQA1.id;
        sol2.Service_Job__c=jo.id;
        insert sol2;
        
        lstSol.add(sol1);
        lstSol.add(sol);
        lstSol.add(sol2);
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=Jo.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c = 0.0;       
        srt.Access_Code_A__c =0.0;
        insert srt;
        
        CSS_SRT__c srt1=new CSS_SRT__c();
        srt1.Solution_Number__c=sol.id;
        srt1.Job_Order__c=Jo.id;
        srt1.Type__c = 'Diagnosis';
        srt1.SRT_Time__c = .20;
        srt1.Access_Code_A__c =200.0;
        insert srt1;
        
        lstSRT.add(srt);
        lstSRT.add(srt1);
        
        CSS_SRT__c srtRep =new CSS_SRT__c();
        srtRep.Solution_Number__c=sol.id;
        srtRep.Job_Order__c=Jo.id;
        srtRep.Type__c = 'Repair';
        srtRep.isPerformed__c=TRUE;
        srtRep.SRT_Time__c = 0.0;
        srtRep.Access_Code_A__c =0.0;
        insert srtRep;
        
        CSS_Solution_Component__c srtComp = new CSS_Solution_Component__c();
        srtComp.Solutions__c = sol.id;
        srtComp.Quantity__c = 1;
        srtComp.Action__c='asdsad';
        srtComp.Service_Job__c =jo.id;
        srtComp.Selected_Component__c = true;
        insert srtComp;
        lssrtComp.add(srtComp);
        
        CSS_SRT__c srtRep1 =new CSS_SRT__c();
        srtRep1.Solution_Number__c=sol.id;
        srtRep1.Job_Order__c=Jo.id;
        srtRep1.Type__c = 'Repair';
        srtRep1.SRT_Time__c = 2000.0;
        srtRep1.isPerformed__c=TRUE;
        srtRep1.Access_Code_A__c =200.0;
        srtRep1.Component_Id__c =srtComp.id;
        insert srtRep1;
        lstSRTRep.add(srtRep1);
        lstSRTRep.add(srtRep);
        
        
        CSS_SRT__c srtofComp =new CSS_SRT__c();
        srtofComp.Solution_Number__c=sol.id;
        srtofComp.Job_Order__c=Jo.id;
        srtofComp.Type__c = 'Repair';
        srtofComp.isPerformed__c=TRUE;
        srtofComp.SRT_Time__c = 2000.0;
        srtofComp.Access_Code_A__c =200.0;
        srtofComp.Response_Message__c='Test';
        srtofComp.Component_Id__c =srtComp.id;
        srtofComp.Solution_Number__c =sol.id;
        srtofComp.Job_Order__c = jo.id;
        
        
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Service_Job__c=Jo.id;
        parts.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts.Fail_Code__c = 'THAC';
        parts.selected_part__c = True;
        lstparts.add(parts);
        system.debug('parts.Fail_Code__c'+parts.Fail_Code__c);
        
        
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.selected_part__c = True;
        parts1.Service_Job__c=Jo.id;
        // parts1.Solutions__c = srtComp.Id;
        parts1.FailurepartId__c = srtComp.Id;
        parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts1.Fail_Code__c = 'THAS';
        lstparts.add(parts1);
        insert lstparts;
        
        
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);        
        pageRef.getParameters().put('id',jo.id);
        pageRef.getParameters().put('SeqNum',string.valueOf(symQA.Sequence__c));
        pageRef.getParameters().put('symId',jo.id);
        
        
        //ApexPages.StandardController con = new ApexPages.StandardController(JO);
        ext = new CSS_SymptomFCSearch();
        
        //symQAWrapper()
        CSS_SymptomFCSearch.symQAWrapper symwraper= new CSS_SymptomFCSearch.symQAWrapper();
        ext.totalSolution = 0;
        
        List<String> FcListFCSearch1 = new List<String>();         
        string Str ='[answersNext=(ansChoice:[ansCaption=No Fault Codes, ansID=1132#38782], ansChoice:[ansCaption=112, ansID=1132#25526], ansChoice:[ansCaption=124, ansID=1132#25549], ansChoice:[ansCaption=125, ansID=1132#41137], ansChoice:[ansCaption=155, ansID=1132#25607], ansChoice:[ansCaption=158, ansID=1132#25613], ansChoice:[ansCaption=162, ansID=1132#25619], ansChoice:[ansCaption=165, ansID=1132#25625], ansChoice:[ansCaption=237, ansID=1132#25735], ansChoice:[ansCaption=291, ansID=1132#25825], ...), cardinality=1, quesID=10#1494, question=Select the active fault code from the list below. If no fault codes are active, selectNo Fault Codes Present and click the NEXT button., solEDS=null, solRank=33]';
        FcListFCSearch1.add(Str);
        
        
        ext.descr = 'asdasdasd';
        ext.category = 'radio';
        List<SelectOption> options = new List<SelectOption>();
        List<SelectOption> optionstwo =new List<SelectOption>();
        List<SelectOption> optionsthree =new List<SelectOption>();
        List<SelectOption> optionsfour =new List<SelectOption>();
        Integer SeqNum = 1;    
        Integer SeqNum1 = 2;
        Integer SeqNum2 = 3;
        
        optionstwo.add(new SelectOption('Miles',system.Label.CSS_Miles));
        optionsthree.add(new SelectOption('Miles',system.Label.CSS_Miles));
        optionsfour.add(new SelectOption('Miles',system.Label.CSS_Miles));
        ext.SeqNum = SeqNum;
        ext.SeqNum = SeqNum1;
        ext.SeqNum = SeqNum2;
        ext.options2 = optionstwo;
        ext.options2 = optionsthree;
        ext.options2 = optionsfour;
        ext.display = true;
        ext.displaySoln =true;
        ext.displaySolnCaptionOnly =true;
        ext.Cardinality = 1;
        ext.QuestionId  ='2123123';
        ext.ansChoiceCaption ='qww2312';
        ext.ansId ='qww2312';
        ext.multiChoiceSelect  ='multiChoice';
        ext.radioMapSelect ='radioMap';
        ext.FCCodeUI ='FcodeUI';
        ext.solName ='SolName';
        ext.solTitle = 'Soltitle';
        ext.solRank = 1;
        ext.radioSelect ='asdsad';
        ext.displaySoln = false;
        ext.FCCodeUI = '1233';
        //    ext.multiSelectAnswers = new List<String>{'12321','2132132','12333','123444'};
        ext.GlobDisplayList = lstSymQA; 
        ext.symptomQAs =lstSymQA;
        ext.solName = 'Sol1';
        //ext.dsidUpdate = false;
        
        //ext.searchTS(); 
        //}
        //init();
        Test.startTest();
        
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch2 = new List<CSS_EDSAuthentication.nextQues>();
        string radioSelect1 = '213131';
        string radioSel1 = 'null';
        
        //List<String> multiSel = new List<String> { 'one', 'two' };
        string category = 'checkbox';
        List<CSS_EDSAuthentication.solutionEDS> lstsolutionEDS = new  List<CSS_EDSAuthentication.solutionEDS>();
        CSS_EDSAuthentication.solutionEDS solutionEDS = new  CSS_EDSAuthentication.solutionEDS('test','test',1);
        
        lstsolutionEDS.add(solutionEDS);
        List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        //   CSS_EDSAuthentication.nextQues FcLstQq = new CSS_EDSAuthentication.nextQues('test','test',null,0,lstsolutionEDS,0,true,0);
        //  FcLstQq .solEDS=lstsolutionEDS;
        // FcLstQ .add(FcLstQq);
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        List<String> x= ext.getmultiSelectAnswers();
        ext.setmultiSelectAnswers(x);
        List<CSS_SymptomQA__c> g = ext.getGlobDisplayList();
        ext.setGlobDisplayList(g);
        string y= ext.getradioSelect();
        ext.setradioSelect(y);
        
        ext.buildGlobalList(0,'test123213',null);
        //ext.buildGlobalList(1,null,multiSel);
        // ext.buildLocalList(0,'test124',null);
        //ext.buildLocalList(1,null,multiSel);
        // ext.btnContd();
        ext.showSolutions();
        //ext.getPartDetails();
        //ext.showQuestSearchCall(FcLstQ,0);
        //ext.chkSolChoiceSearch(FcLstQ);
        //ext.chkSolChoice(FcLstQ);
        //ext.chkSolChoicePreviousCall(FcLstQ);
        //ext.chkSol(FcListFCSearch2);
        ext.getmultiSelectAnswers();
        ext.getGlobDisplayList();
        ext.getradioSelect();
        ext.SearchObjId=sym.id;
        ext.DSID='1234';
        ext.backflow();
        ext.edsErrorPopUp = true;
        ext.showEDSErrorPopUp();
        ext.closeEDSErrorPopUp();
        ext.getSortvalues();
        Test.stopTest();
        
    }
    Static testMethod void testgetPreviousQCall(){
        init();
        Test.startTest();
        
        List<String> multiSel = new List<String> { 'one', 'two' };
            
            List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        string ansRadio = '18313#8529';
        string ques ='10%2336366';
        
        Test.setMock(HttpCalloutMock.class, new CSS_GetPreviousQues_Test());
        //CSS_SymptomFCSearch sFC = new CSS_SymptomFCSearch();
        //ext.chkSolChoice(FcLstQ);
        ext.BuildPreviousQuest('12323',1);
        ext.DSID='1234';
        List<CSS_EDSAuthentication.nextQues> PreviousQuestLst1=new List<CSS_EDSAuthentication.nextQues>();
        //CSS_EDSAuthentication.nextQues next=new CSS_EDSAuthentication.nextQues();
        //PreviousQuestLst1.add(next);
        ext.PreviousQuestLst=PreviousQuestLst1;
        ext.backflow();
    }
    Static testMethod void testshowQuest1(){
        string radioSelect = '213131';
        init();
        Test.startTest();
        //string radioSelect = '213131';
        List<String> multiSel = new List<String> { 'one', 'two' };
            string ansRadio = '18313#8529';
        string ques ='10%2336366';
        //string radioSelecIns = 'AND';
        string category = 'radio';
        Map<String,String> optMapRadio = new Map<String,String>();
        optMapRadio.put('AND','Test');
        system.debug(optMapRadio + 'optMapRadio***');
        List<CSS_EDSAuthentication.nextQues> FcLstQ = new List<CSS_EDSAuthentication.nextQues>();
        Test.setMock(HttpCalloutMock.class, new CSS_GetQues_Test());
        FcLstQ= CSS_EDSAuthentication.getQues(null,ansRadio,ques,'DSBDT4780','en','O'); 
        System.debug('MSN'+FcLstQ);
        ext.buildGlobalList(1,'test123213',multiSel);
        ext.category = 'radio';
        ext.buildGlobalList(1,null,multiSel);
        ext.buildGlobalList(1,null,multiSel);
        ext.buildLocalList(1,'null',multiSel,FcLstQ);
        //  ext.buildLocalList(1,'test124',null);
        ext.optMapRadio = optMapRadio;
        ext.buildLocalList(1,'AND',multiSel,FcLstQ);
        
        ext.btnContd();
        // ext.showQuest(FcLstQ,0);
        ext.showQuestSearchCall(FcLstQ,0);
        
    }
    Static testMethod void testshowSoln1(){
        init();
        
        string searchText ='123';
        boolean display=true;
        boolean displaySoln=true;
        boolean displaySolnCaptionOnly=true;
        integer Cardinality =1;
        string QuestionId ='test345';
        string QuesResp = 'test13';
        Integer SeqNum=1;
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomFCSearch_Test());
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
        
        
        FcListFCSearch = CSS_EDSAuthentication.getFCSympSearch('123',null,null,null,0,'Miles',null,null,null,null,null,null,'DSBDT4780','en','O');  
        
        system.debug('MSNFcListFCSearch'+FcListFCSearch);
        //CSS_SymptomFCSearch sFC = new CSS_SymptomFCSearch();
        Test.startTest();
        CSS_SymptomFCSearch sfc=new CSS_SymptomFCSearch();
        //sfc.DSID='abcxyz';
        // sfc.dsidUpdate=true;
        ext.showSoln1(FcListFCSearch);
        //ext.showSoln(FcListFCSearch);
        //ext.searchTS();
        // insert(JO);
        Test.stopTest();
        
    }
    Static testMethod void solDisplay(){
        CSS_SymptomFCSearch.solDisplay  sold = new CSS_SymptomFCSearch.solDisplay ('1','Test');
        
    }
    Static testMethod void testchkSolSearchCall(){
        init();
        Test.startTest();
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
        
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomFCSearch_Test());
        FcListFCSearch =CSS_EDSAuthentication.getFCSympSearch('123',null,null,null,0,'Miles',null,null,null,null,null,null,'DSBDT4780','en','O');  
        
        
        system.debug('MSNFcListFCSearch'+FcListFCSearch);
        
        CSS_SymptomFCSearch symSearch = new CSS_SymptomFCSearch();
        symSearch.dsidIndi = 'test';
        symSearch.solSize = 12;
        symSearch.QuesResp = 'test';
        //symSearch.showQuest(FcListFCSearch, 0);
        ext.chkSolSearchCall(FcListFCSearch);
        Test.stopTest();
        
    }
    Static testMethod void testchkSolSearchCall1(){
        init();
        Test.startTest();
        string radioSelect1 = '213131';
        integer Cardinality1 =1;
        List<String> multiSel = new List<String> { 'one', 'two' };
            ext.category = 'checkbox'; 
        string ansRadio = '18313#8529';
        string ques ='10%2336366';
        string category = 'checkbox';
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
        List<CSS_EDSAuthentication.ansChoice> answersNext = new List<CSS_EDSAuthentication.ansChoice>();
        CSS_EDSAuthentication.ansChoice anschoice = new CSS_EDSAuthentication.ansChoice('t','t1');
        CSS_EDSAuthentication.ansChoice anschoice2 = new CSS_EDSAuthentication.ansChoice('t','t2');
        answersNext.add(anschoice);
        answersNext.add(anschoice2);  
        List<CSS_EDSAuthentication.solutionEDS> solEDS = new  List<CSS_EDSAuthentication.solutionEDS>();
        CSS_EDSAuthentication.solutionEDS eds1 = new CSS_EDSAuthentication.solutionEDS('test','title',0);
        CSS_EDSAuthentication.solutionEDS eds2 = new CSS_EDSAuthentication.solutionEDS('test1','title1',2);
        solEDS.add(eds1);
        solEDS.add(eds2);            
        CSS_EDSAuthentication.nextQues q1 = new CSS_EDSAuthentication.nextQues( 'question', 'quesID',answersNext,0,solEDS,1,true,1,null,null,null,null,null);
        CSS_EDSAuthentication.nextQues q2 = new CSS_EDSAuthentication.nextQues( 'question1', 'quesID1',answersNext,2,solEDS,1,true,1,null,null,null,null,null);
        FcListFCSearch.add(q1);
        FcListFCSearch.add(q2);
        
        // symSearch.dsidUpdate=true;
        //symSearch
        //ext.showQuest(FcListFCSearch, 0);
        ext.chkSolSearchCall(FcListFCSearch);
        ext.showSoln(FcListFCSearch);
        ext.showSoln1(FcListFCSearch);
        ext.chkSolChoiceSearch(FcListFCSearch);
        ext.chkSolChoice(FcListFCSearch);
        ext.SymptomFCSearch('smoke');
        //ext.SymptomSearch('smoke');
        ext.btnContd();
        //ext.searchText=sym.id;
        ext.DSID='1234';
        ext.backflow();
        ext.chkSol(FcListFCSearch);
        ext.chkSolChoiceSearch(FcListFCSearch);
        ext.chkSolChoice(FcListFCSearch);
        
        Test.stopTest();
        
    }
    Static testMethod void testchkSolSearchCalling1(){
        init1();
        Test.startTest();
        string radioSelect = '213131';
        integer Cardinality =1;
        List<String> multiSel = new List<String> { 'one', 'two' };
            string ansRadio = '18313#8529';
        string ques ='10%2336366';
        string category = 'checkbox';
        String  DSID = CSS_EDSAuthentication.getDSID(jo.ESN__c,jo.name,jo.Application_Desc__c,jo.Unit_Number__c,jo.Mileage__c,
                                                     jo.Mileage_Measure__c,jo.Make__c,jo.Model__c,jo.Equipment_ID__c,jo.Customer_Name__c,
                                                     jo.Service_Model__c,jo.Shop_Work_Order__c,jo.AccessCode__c);
        
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
        List<CSS_EDSAuthentication.ansChoice> answersNext = new List<CSS_EDSAuthentication.ansChoice>();
        CSS_EDSAuthentication.ansChoice anschoice = new CSS_EDSAuthentication.ansChoice('t','t1');
        CSS_EDSAuthentication.ansChoice anschoice2 = new CSS_EDSAuthentication.ansChoice('t','t2');
        answersNext.add(anschoice);
        answersNext.add(anschoice2);  
        List<CSS_EDSAuthentication.solutionEDS> solEDS = new  List<CSS_EDSAuthentication.solutionEDS>();
        CSS_EDSAuthentication.solutionEDS eds1 = new CSS_EDSAuthentication.solutionEDS('test','title',0);
        CSS_EDSAuthentication.solutionEDS eds2 = new CSS_EDSAuthentication.solutionEDS('test1','title1',2);
        solEDS.add(eds1);
        solEDS.add(eds2);            
        CSS_EDSAuthentication.nextQues q1 = new CSS_EDSAuthentication.nextQues( 'question', 'quesID',answersNext,0,solEDS,1,true,1,null,null,null,null,null);
        CSS_EDSAuthentication.nextQues q2 = new CSS_EDSAuthentication.nextQues( 'question1', 'quesID1',answersNext,2,solEDS,1,true,1,null,null,null,null,null);
        FcListFCSearch.add(q1);
        FcListFCSearch.add(q2);
        CSS_SymptomFCSearch symSearch = new CSS_SymptomFCSearch();
        symSearch.dsidIndi = 'test';
        symSearch.solSize = 12;
        symSearch.QuesResp = 'test';
        //  CSS_SymptomFCSearch.dsidUpdate=true;
        //symSearch
        //ext.showQuest(FcListFCSearch, 0);
        ext.chkSolSearchCall(FcListFCSearch);
        ext.showSoln(FcListFCSearch);
        ext.SymptomFCSearch('test');
        ext.searchTS();
        ext.showSoln1(FcListFCSearch);
        ext.chkSolChoiceSearch(FcListFCSearch);
        ext.chkSolChoice(FcListFCSearch);
        ext.SymptomFCSearch('smoke');
        //ext.SymptomSearch('smoke');
        ext.SymptomSearch('smoke');
        ext.btnContd();
        ext.chkSol(FcListFCSearch);
        ext.chkSolChoiceSearch(FcListFCSearch);
        ext.chkSolChoice(FcListFCSearch);
        Test.stopTest();
        
    }
    Static testMethod void testchkSolSearchCall2(){
        init();
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomFCSearch_Test());
        ext.SymptomFCSearch('str');
        List<CSS_EDSAuthentication.nextQues> FcListFCSearch = new List<CSS_EDSAuthentication.nextQues>();
        List<CSS_EDSAuthentication.ansChoice> answersNext = new List<CSS_EDSAuthentication.ansChoice>();
        CSS_EDSAuthentication.ansChoice anschoice = new CSS_EDSAuthentication.ansChoice('t','t1');
        CSS_EDSAuthentication.ansChoice anschoice2 = new CSS_EDSAuthentication.ansChoice('t','t2');
        answersNext.add(anschoice);
        answersNext.add(anschoice2);  
        List<CSS_EDSAuthentication.solutionEDS> solEDS = new  List<CSS_EDSAuthentication.solutionEDS>();
        CSS_EDSAuthentication.solutionEDS eds1 = new CSS_EDSAuthentication.solutionEDS('test','title',0);
        CSS_EDSAuthentication.solutionEDS eds2 = new CSS_EDSAuthentication.solutionEDS('test1','title1',2);
        solEDS.add(eds1);
        solEDS.add(eds2);            
        CSS_EDSAuthentication.nextQues q1 = new CSS_EDSAuthentication.nextQues( 'No Fault Codes Present', 'ques1ID',null,1,solEDS,1,true,1,null,null,null,null,null);
        CSS_EDSAuthentication.nextQues q2 = new CSS_EDSAuthentication.nextQues( 'question1', 'quesID1',null,2,solEDS,1,true,1,null,null,null,null,null);
        FcListFCSearch.add(q1);
        FcListFCSearch.add(q2);
        // FcListFCSearch  = ext.BuildPreviousQuest('12323',1);
        // = CSS_EDSAuthentication.getFCSympSearch( 'freeText','esn1', 'application','unitNum',1.3, 'measure',' mak',' mod', 'eqID','custName','servModel','shopWor', 'ds', 'lang','dsidIndi');
        CSS_SymptomFCSearch symSearch = new CSS_SymptomFCSearch();
        symSearch.dsidIndi = 'test';
        symSearch.solSize = 12;
        symSearch.QuesResp = 'test';
        String category = 'radio';
        //ext.chkSol (FcListFCSearch) ; 
        //ext.showQuest(FcListFCSearch, 0);
        ext.chkSolSearchCall(FcListFCSearch);
        ext.showSoln1(FcListFCSearch);
        ext.showQuestSearchCall(FcListFCSearch,0);
        ext.chkSolChoicePreviousCall(FcListFCSearch);
        Test.stopTest();
    }
    Static testMethod void testchkSol21(){
        init();
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSS_GetSymptomFCSearch_Test());
        ext.SymptomFCSearch('str');
        List<CSS_EDSAuthentication.nextQues> GlobQuestLst = new List<CSS_EDSAuthentication.nextQues>();
        List<CSS_EDSAuthentication.ansChoice> answersNext = new List<CSS_EDSAuthentication.ansChoice>();
        CSS_EDSAuthentication.ansChoice anschoice = new CSS_EDSAuthentication.ansChoice('t','t1');
        CSS_EDSAuthentication.ansChoice anschoice2 = new CSS_EDSAuthentication.ansChoice('t','t2');
        answersNext.add(anschoice);
        answersNext.add(anschoice2);  
        List<CSS_EDSAuthentication.solutionEDS> solEDS = new  List<CSS_EDSAuthentication.solutionEDS>();
        CSS_EDSAuthentication.solutionEDS eds1 = new CSS_EDSAuthentication.solutionEDS('test','title',0);
        CSS_EDSAuthentication.solutionEDS eds2 = new CSS_EDSAuthentication.solutionEDS('test1','title1',2);
        solEDS.add(eds1);
        solEDS.add(eds2);            
        CSS_EDSAuthentication.nextQues q1 = new CSS_EDSAuthentication.nextQues( 'No Fault Codes Present', 'ques1ID',null,1,solEDS,1,true,1,null,null,null,null,null);
        CSS_EDSAuthentication.nextQues q2 = new CSS_EDSAuthentication.nextQues( 'question1', 'quesID1',null,2,solEDS,1,true,1,null,null,null,null,null);
        GlobQuestLst.add(q1);
        GlobQuestLst.add(q2);
        // FcListFCSearch  = ext.BuildPreviousQuest('12323',1);
        // = CSS_EDSAuthentication.getFCSympSearch( 'freeText','esn1', 'application','unitNum',1.3, 'measure',' mak',' mod', 'eqID','custName','servModel','shopWor', 'ds', 'lang','dsidIndi');
        CSS_SymptomFCSearch symSearch = new CSS_SymptomFCSearch();
        symSearch.dsidIndi = 'test';
        symSearch.solSize = 12;
        symSearch.QuesResp = 'test';
        String category = 'radio';
        ext.chkSol (GlobQuestLst) ; 
        ext.showQuest(GlobQuestLst, 1);
        //ext.chkSolSearchCall(FcListFCSearch);
        //ext.showSoln1(FcListFCSearch);
        //ext.showQuestSearchCall(FcListFCSearch,0);
        
        Test.stopTest();
    }
    Static testMethod void testNew(){
        
        JO = NEW CSS_Job_Order__c();
        JO.Unit_Number__c = '12345';
        JO.Failure_Point__c = 1.5;
        JO.Failure_Point_Measure__c = 'qw';       
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.ESN__c = 'test1234';
        jo.DSID_WorkGroup__c = '';
        JO.DSID_Creation_Timestamp__c = system.now();
        JO.DSID_Status__c = 'open';
        JO.ESN_Locked__c = true;
        JO.ESN_Insite__c = '79464646';
        JO.Application__c = 'test1234';
        JO.Failure_Point__c = 1234;
        JO.Failure_Point_Measure__c = 'test1234';
        JO.Make__c = 'BMC';
        JO.Equipment_ID__c = 'equip';
        JO.Model__c = 'MILITARY';
        JO.DSID__c = 'DSE222';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.AccessCode__c ='A';
        insert(JO);
        
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Name = 'solcomp';
        solcomp.Service_Job__c=JO.id;
        solcomp.System_Code__c='TH';
        solcomp.Component_Code__c='AC';
        solcomp.Failure_Mode__c='BT';
        solcomp.AccountCode__c = 'SERVICE TOOL WARRANTY 52';//wil inturn be the account Formula
        solcomp.Type__c = null;
        solcomp.Selected_Component__c = true;
        solcomp.Customer_Take_Possession__c = 'yes';
        solcomp.Part_Warranty_Start_Date__c = system.today() - 30;
        solcomp.Failure_Date__c = system.today();
        solcomp.Failure_Point__c = 20;
        solcomp.Failure_Measure__c = 'Miles';
        insert solcomp;
        lstsolcomp.add(solcomp);
        
        //system.debug ('CSS_Account_Formula__c1--'+solcomp.CSS_Account_Formula__c);
        
        CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
        solcomp1.Name = 'solcomp1';
        solcomp1.Service_Job__c=JO.id;
        solcomp1.System_Code__c='TH';
        solcomp1.Component_Code__c='AS';
        solcomp1.Failure_Mode__c='BT';
        solcomp1.AccountCode__c = 'SERVICE TOOL WARRANTY 52';
        solcomp1.Type__c = null;
        solcomp1.Selected_Component__c = true;
        insert solcomp1;
        lstsolcomp.add(solcomp1); 
        
        //system.debug ('CSS_Account_Formula__c2--'+solcomp1.CSS_Account_Formula__c);
        
        //For fetchClaimRecords Coverage Limit code   
        CSS_Solution_Component__c solcomp2 = new CSS_Solution_Component__c();
        solcomp2.Name = 'solcomp2';
        //solcomp2.
        solcomp2.Service_Job__c=JO.id;
        solcomp2.System_Code__c='FH';
        solcomp2.Component_Code__c='AS';
        solcomp2.Failure_Mode__c='BT';
        solcomp2.AccountCode__c = 'SERVICE TOOL WARRANTY 52';
        solcomp2.Type__c = null;
        solcomp2.Selected_Component__c = true;
        solcomp2.Status__c='Approved';
        solcomp2.CoverageLimitExceedMsg_Status__c = 'ERROR';
        solcomp2.CoverageTravelBaseFareMsgTstatus__c = 'ERROR';
        solcomp2.AccountCode_Call_Status__c = 'Failure';
        solcomp2.CoverageLimitExceedMsgSRT_Status__c ='ERROR';
        
        insert solcomp2;
        lstsolcomp.add(solcomp2);
        
        
        
        //Part Option list
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Service_Job__c=JO.id;
        parts.FailurepartId__c = lstsolcomp[0].id;
        parts.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts.Fail_Code__c = 'THAC';
        parts.selected_part__c = True;
        lstparts.add(parts);
        system.debug('parts.Fail_Code__c'+parts.Fail_Code__c);
        
        
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts1.selected_part__c = True;
        parts1.FailurepartId__c = lstsolcomp[0].id;
        parts1.Service_Job__c=JO.id;
        parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
        parts1.Fail_Code__c = 'THAS';
        parts1.selected_part__c = True;
        lstparts.add(parts1);
        insert lstparts;
        system.debug('parts1.Fail_Code__c'+parts1.Fail_Code__c);
        
        
        Test.startTest();
        CSS_SymptomFCSearch ext = new CSS_SymptomFCSearch();
        ext.lstCompForSol = lstsolcomp;
        ext.showSolutions();
        ext.getPartDetails();
        Test.stopTest();
        
    }
    Static testMethod void catchMethod(){
        List<SelectOption> SortList =new List<SelectOption>();
        SortList.add(null);
        CSS_SymptomFCSearch fc1=new CSS_SymptomFCSearch();
        fc1.getSortvalues();
        fc1.getRepSRTDetails();
        fc1.NextbuildQuest(null,null,null,true,'getNextQ');
        fc1.chkSolChoiceSearch(null);
        List<CSS_SymptomQA__c> sym=null;
        fc1.insertLocalList(sym);
        fc1.buildLocalList(null,null,null,null);
        fc1.buildGlobalList(null,null,null);
        
    }
    
}