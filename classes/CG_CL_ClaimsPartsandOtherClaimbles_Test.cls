@isTest
public class CG_CL_ClaimsPartsandOtherClaimbles_Test {
     public static testMethod void CG_CL_ClaimsPartsandOtherClaimbles_TestMethod2(){
        Test.startTest();
        css_claims__c claimas = new css_claims__c();
        claimas.Customer_Name__c='Sai';
        claimas.Customer_Code__c='123';
        insert claimas;
        //CSS_PSNs__r psn = new CSS_PSNs__r();
        //psn.Calibration_After__c='test';
        // apexpages.currentPage().getparameters().put('id',claimas.id);
         CG_CL_ClaimsPartsandOtherClaimbles claimsWar = new CG_CL_ClaimsPartsandOtherClaimbles();
     }
    public static testMethod void CG_CL_ClaimsPartsandOtherClaimbles_TestMethod1(){
        
        Map<decimal,decimal> expTotalTempMap = new Map<decimal,decimal>();
        expTotalTempMap.put(10.8,10.5);
        system.debug(expTotalTempMap + 'expTotalTempMap1');
        Test.startTest();
        css_claims__c claimas = new css_claims__c();
        claimas.Customer_Name__c='Sai';
        claimas.Customer_Code__c='123';
         claimas.FieldActionWebServiceResult__c='Error';
        insert claimas;
        css_parts_options__c patop1 = new css_parts_options__c();
        patop1.Parts_Type__c = 'Custom';
      //  patop1.RecordTypeId=partsrecodid;
        patop1.selected_part__c = true;
        patop1.Part_Assignment__c = 'Primary';
       patop1.ExpenseTotal__c=23;
        patop1.Covered__c=23;
        patop1.Quantity__c=23;
       patop1.CSS_Claims__c=claimas.Id;
        insert patop1;
        //CSS_PSNs__r psn = new CSS_PSNs__r();
        //psn.Calibration_After__c='test';
         apexpages.currentPage().getparameters().put('id',claimas.id);
        CG_CL_ClaimsPartsandOtherClaimbles claimsWar = new CG_CL_ClaimsPartsandOtherClaimbles();
        List<CSS_Parts_Options__c> GSQ_URP_Partslst = new List<CSS_Parts_Options__c>();
        id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id partsrecodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();    
        css_parts_options__c patop = new css_parts_options__c();
        patop.Parts_Type__c = 'Custom';
        patop.RecordTypeId=partsrecodid;
        patop.selected_part__c = true;
        patop.Part_Assignment__c = 'Primary';
       // patop.Service_Job__c=jo.id;
        patop.ExpenseTotal__c=23;
        patop.Covered__c=23;
        patop.Quantity__c=23;
       // patop.Solutions__c=sol.id;
        patop.CSS_Claims__c=claimas.Id;
        insert patop;
        GSQ_URP_Partslst.add(patop);
        system.debug('@@@@GSQ_URP_Partslst'+GSQ_URP_Partslst);
          //claimsWar.nvClaimsIO();
          claimsWar.expTotalTempMap = expTotalTempMap;
        claimsWar.nvClaimsIntake();
        claimsWar.nvClaimsWC();
        claimsWar.nvClaimsVH();
        claimsWar.nvClaimsCC();
        claimsWar.nvClaimsFC();
        claimsWar.nvClaimsPOC();
        claimsWar.nvClaimsSRTs();
        claimsWar.nvClaimsVS();
        claimsWar.nvClaimsJobNotes();
        claimsWar.USDTotal();
        claimsWar.saveClaimExpenseTotal();
        claimsWar.saveOtherClaimablesTotal();
        claimsWar.saveOtherClaimablesTotal1();
        claimsWar.resolveErrorNow();
        //claimsWar.savePartsTotal();
        claimsWar.pageName='test';
        claimsWar.totalUSd1=22.22;
        claimsWar.temptotalurp=32.22;
        claimsWar.partsUSD=11.11;
        claimsWar.savePartsTotal();
        PageReference pageRef = Page.CG_ClaimsPartsandOtherClaimbles;
        Test.setCurrentPage(pageRef); 
        String id = ApexPages.currentPage().getParameters().get('id');
        claimsWar.pgSave();
        claimsWar.continueNext();
        claimsWar.pageReferenceMethod();
        Test.stopTest();
        
    }
    static testmethod void testmethod2()
    {
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='56749876';
        insert jo;
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='123';
        claims.ESN__c='56749876';
        claims.CSS_Job__c=jo.id;
        insert claims;
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        sol.Name='Testing';
        insert sol;
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
        solcomp.AccountCodeEdit__c='Testing';
        solcomp.Fail_Code_Editable__c='Testing Failcode';
        solcomp.Type__c='ATC';
        solcomp.Pay_Code__c='A';
        insert solcomp;
        id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id partsrecodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();    
        css_parts_options__c patop = new css_parts_options__c();
        patop.Parts_Type__c = 'Custom';
        patop.RecordTypeId=recodid;
        patop.Part_Assignment__c = 'Primary';
        patop.Service_Job__c=jo.id;
        patop.ExpenseTotal__c=23;
        patop.Covered__c=23;
        patop.Quantity__c=23;
        patop.Solutions__c=sol.id;
        patop.CSS_Claims__c=claims.Id;
        insert patop;
        css_parts_options__c patop1 = new css_parts_options__c();
        patop1.Parts_Type__c = 'Custom';
        patop1.RecordTypeId=partsrecodid;
        patop1.Service_Job__c=jo.id;
        patop1.Solutions__c=sol.id;
        patop1.CSS_Claims__c=claims.Id;
        patop1.Part_Assignment__c = 'Primary';
        patop1.FailurepartId__c=solcomp.id;
        patop1.Fail_Code__c='';
        patop1.ReturnToFactory__c='';
        patop1.selected_part__c = true;
        insert patop1;
        apexpages.currentPage().getparameters().put('id',claims.id);
        test.startTest();
        CG_CL_ClaimsPartsandOtherClaimbles cla = new CG_CL_ClaimsPartsandOtherClaimbles();
        cla.saveGSQPartsTotal();
        cla.saveOtherClaimablesTotal1();
        cla.partsOtherClaimPageAction();
        cla.nvClaimsWC();
        cla.nvClaimsVH();
        cla.nvClaimsCC();
        cla.nvClaimsFC();
        cla.nvClaimsPSN();
        cla.nvClaimsVS();
        cla.nvClaimsJobNotes();
        cla.nvClaimsSRTs();
        cla.nvClaimsPOC();
        test.stopTest();
        
    }
    static testmethod void testmethod21()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='562701';
        acc.IAM_Service_Provider_Code__c='562551';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        acc.Type = 'Dealer';
        insert acc;
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='56749876';
        insert jo;
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='123';
        claims.ESN__c='56749876';
        claims.CSS_Job__c=jo.id;
        claims.account__c = acc.id;
        insert claims;
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        sol.Name='Testing';
        insert sol;
        css_parts_options__c patop22 = new css_parts_options__c();
        patop22.Parts_Type__c = 'Custom';
        patop22.Service_Job__c=jo.id;
        patop22.ExpenseTotal__c=23;
        patop22.Part_Assignment__c = 'Primary';
        patop22.Covered__c=23;
        patop22.Quantity__c=23;
        patop22.Solutions__c=sol.id;
        patop22.CSS_Claims__c=claims.Id;
        insert patop22;
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.CampaignPartsPercentage__c='4';
        solcomp.Solutions__c=sol.Id;
        solcomp.AccountCodeEdit__c='Testing';
        solcomp.Fail_Code_Editable__c='Testing Failcode';
        solcomp.Type__c='ATC';
        solcomp.Pay_Code__c='B';
        insert solcomp;
        id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id partsrecodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();    
        css_parts_options__c patop = new css_parts_options__c();
        patop.Parts_Type__c = 'Custom';
        patop.RecordTypeId=recodid;
        patop.Service_Job__c=jo.id;
        patop.ExpenseTotal__c=23;
        patop.Part_Assignment__c = 'Primary';
        patop.Covered__c=23;
        patop.Quantity__c=23;
        patop.Solutions__c=sol.id;
        patop.CSS_Claims__c=claims.Id;
        insert patop;
        css_parts_options__c patop1 = new css_parts_options__c();
        patop1.Parts_Type__c = 'Custom';
        patop1.RecordTypeId=partsrecodid;
        patop1.Service_Job__c=jo.id;
        patop1.Solutions__c=sol.id;
        patop1.CSS_Claims__c=claims.Id;
        patop1.Part_Assignment__c = 'Primary';
        patop1.FailurepartId__c=solcomp.id;
        patop1.Fail_Code__c='Select One';
        patop1.Account_Code__c='Select One';
        patop1.ReturnToFactory__c='';
        patop1.selected_part__c = true;
        insert patop1;
        apexpages.currentPage().getparameters().put('id',claims.id);
        test.startTest();
        CG_CL_ClaimsPartsandOtherClaimbles cla = new CG_CL_ClaimsPartsandOtherClaimbles();
        cla.saveOtherClaimablesTotal1();
        cla.partsOtherClaimPageAction();
        cla.nvClaimsWC();
        cla.nvClaimsVH();
        cla.nvClaimsCC();
        cla.nvClaimsFC();
        cla.nvClaimsPSN();
        cla.nvClaimsVS();
        cla.nvClaimsJobNotes();
        cla.nvClaimsSRTs();
        cla.nvClaimsPOC();
        test.stopTest();
        
    }
    static testmethod void testmethod3()
    {
        system.runas(new User(Id=UserInfo.getUserId()))
        {
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='56749876';
        insert jo;
         css_header_nav__c ch = new css_header_nav__c(SetupOwnerId = UserInfo.getUserId(), Name = 'Ritesh');
            ch.RSWButtonEnable__c = true;
            insert ch;
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='123';
        claims.ESN__c='56749876';
        claims.CSS_Job__c=jo.id;
        claims.FieldActionWebServiceResult__c='Eror';
        insert claims;
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        sol.Name='Testing';
        insert sol;
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
        solcomp.Pay_Code__c='A';
        solcomp.AccountCodeEdit__c='Testing';
        solcomp.Selected_Component__c = true;
        solcomp.Type__c = 'Campaign';
        solcomp.Status__c='Approved';
        solcomp.Fail_Code_Editable__c='Testing Failcode';
        insert solcomp;
        id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
            
        css_parts_options__c patop = new css_parts_options__c();
        patop.Parts_Type__c = 'Custom';
        patop.RecordTypeId=recodid;
        patop.Service_Job__c=jo.id;
        patop.Solutions__c=sol.id;
        patop.CSS_Claims__c=claims.Id;
        patop.type__c='Non Commercial-Travel';
        insert patop;
        
        apexpages.currentPage().getparameters().put('id',claims.id);
        test.startTest();
        CG_CL_ClaimsPartsandOtherClaimbles cla = new CG_CL_ClaimsPartsandOtherClaimbles();
        cla.saveOtherClaimablesTotal1();
        cla.nvClaimsIntake();
        test.stopTest();
        
        }}
    static testmethod void testmethod31()
    {
        User u1 = CSS_utility.getUserAttributes(UserInfo.getUserId());
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='56749876';
        insert jo;
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='123';
        claims.ESN__c='56749876';
        claims.Dealer_Service_Job__c=jo.id;
        claims.Multi_PSN_Claim__c=true;
        claims.Information_Only_Claim__c=true;
        //claims.CSS_Job__c=jo.id;
        insert claims;
        CSS_PSN__c psn = new CSS_PSN__c();
        psn.Name='73806085';
        psn.Unit_Number__c='123';
        psn.Application__c='AUTOMOTIVE';
        psn.Service_Model__c='ISB6.7 CM2350 B101';
        psn.Make__c='INTERNATIONAL';
        psn.Model__c='DURASTAR';
        psn.Mileage_Measure__c='Miles';
        psn.Unit_Type__c='CONVENTIONAL';
        psn.PSN__c='73806085';
        psn.ApplicationCode__c ='130';
        psn.CSS_Claims__c=claims.id;
        psn.Primary__c=true;
        PSN.Before_In_Service__c=FALSE;
        insert PSN;
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        sol.Name='Testing';
        insert sol;
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.Service_Job__c=jo.Id;
        solcomp.Pay_Code__c='B';
        solcomp.Solutions__c=sol.Id;
        solcomp.AccountCodeEdit__c='Testing';
        solcomp.Selected_Component__c = true;
        solcomp.Type__c = 'Campaign';
        solcomp.Status__c='Approved';
        solcomp.Fail_Code_Editable__c='Testing Failcode';
        insert solcomp;
        id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
            
        
        css_parts_options__c patop1 = new css_parts_options__c();
        patop1.Parts_Type__c = 'Custom';
        patop1.RecordTypeId=recodid;
        patop1.Service_Job__c=jo.id;
        patop1.Solutions__c=sol.id;
        patop1.CSS_Claims__c=claims.Id;
        patop1.type__c='Commercial-Travel';
        insert patop1;
        
        apexpages.currentPage().getparameters().put('id',claims.id);
        test.startTest();
        CG_CL_ClaimsPartsandOtherClaimbles cla = new CG_CL_ClaimsPartsandOtherClaimbles();
        Set<String> errMsgLst1=new Set<String>();
        errMsgLst1.add('abc');
        errMsgLst1.add('abcd');
        errMsgLst1.add('abcde');
        cla.errMsgLst=errMsgLst1;
        List<String> errMsgLstNew1=new List<String>();
        errMsgLstNew1.add('abc');
        errMsgLstNew1.add('abcd');
        errMsgLstNew1.add('abcde');
        cla.saveOtherClaimablesTotal1();
        cla.nvClaimsIntake();
        test.stopTest();
        
    }
    static testmethod void testmethod32()
    {
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='56749876';
        insert jo;
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='123';
        claims.ESN__c='56749876';
        claims.CSS_Job__c=jo.id;
         claims.FieldActionWebServiceResult__c='Error';
        insert claims;
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        sol.Name='Testing';
        insert sol;
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
        solcomp.Pay_Code__c='A';
        solcomp.AccountCodeEdit__c='Testing';
        solcomp.Selected_Component__c = False;
        solcomp.Type__c = 'Campaign';
        solcomp.Status__c='Approved';
        solcomp.Fail_Code_Editable__c='Testing Failcode';
        insert solcomp;
        id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
            
       
        css_parts_options__c patop2 = new css_parts_options__c();
     //   patop2.Parts_Type__c = 'Custom';
        patop2.RecordTypeId=recodid;
        patop2.Service_Job__c=jo.id;
        patop2.Solutions__c=sol.id;
        patop2.CSS_Claims__c=claims.Id;
        patop2.type__c='Towing';
        patop2.selected_part__c = false;
        insert patop2;
        
        
        apexpages.currentPage().getparameters().put('id',claims.id);
        test.startTest();
        CG_CL_ClaimsPartsandOtherClaimbles cla = new CG_CL_ClaimsPartsandOtherClaimbles();
        Set<String> errMsgLst1=new Set<String>();
        errMsgLst1.add('abc');
        errMsgLst1.add('abcd');
        errMsgLst1.add('abcde');
        cla.errMsgLst=errMsgLst1;
        List<String> errMsgLstNew1=new List<String>();
        errMsgLstNew1.add('abc');
        errMsgLstNew1.add('abcd');
        errMsgLstNew1.add('abcde');
        cla.saveOtherClaimablesTotal1();
        cla.nvClaimsIntake();
        test.stopTest();
        
    }
    static testmethod void testmethod32A()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='562701';
        acc.IAM_Service_Provider_Code__c='562551';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        acc.Type = 'Dealer';
        insert acc;
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='56749876';
        insert jo;
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='123';
        claims.ESN__c='56749876';
        claims.CSS_Job__c=jo.id;
         claims.FieldActionWebServiceResult__c='Error';
         claims.account__c= acc.id;
        insert claims;
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        sol.Name='Testing';
        insert sol;
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
        solcomp.Pay_Code__c='A';
        solcomp.AccountCodeEdit__c='Testing';
        solcomp.Selected_Component__c = False;
        solcomp.Type__c = 'Campaign';
        solcomp.Status__c='Approved';
        solcomp.Fail_Code_Editable__c='Testing Failcode';
        insert solcomp;
        id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
            
       
        css_parts_options__c patop2 = new css_parts_options__c();
     //   patop2.Parts_Type__c = 'Custom';
        patop2.RecordTypeId=recodid;
        patop2.Service_Job__c=jo.id;
        patop2.Solutions__c=sol.id;
        patop2.CSS_Claims__c=claims.Id;
        patop2.type__c='Towing';
        patop2.selected_part__c = false;
        insert patop2;
        
        
        apexpages.currentPage().getparameters().put('id',claims.id);
        test.startTest();
        CG_CL_ClaimsPartsandOtherClaimbles cla = new CG_CL_ClaimsPartsandOtherClaimbles();
        Set<String> errMsgLst1=new Set<String>();
        errMsgLst1.add('abc');
        errMsgLst1.add('abcd');
        errMsgLst1.add('abcde');
        cla.errMsgLst=errMsgLst1;
        List<String> errMsgLstNew1=new List<String>();
        errMsgLstNew1.add('abc');
        errMsgLstNew1.add('abcd');
        errMsgLstNew1.add('abcde');
        cla.saveOtherClaimablesTotal1();
        cla.nvClaimsIntake();
        test.stopTest();
        
    }
    static testmethod void testmethod33()
    {
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='56749876';
        insert jo;
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='123';
        claims.ESN__c='56749876';
        claims.CSS_Job__c=jo.id;
         claims.FieldActionWebServiceResult__c='Error';
        insert claims;
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        sol.Name='Testing';
        insert sol;
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
        solcomp.Pay_Code__c='A';
        solcomp.AccountCodeEdit__c='Testing';
        solcomp.Selected_Component__c = true;
        solcomp.Type__c = 'Campaign';
        solcomp.Status__c='Approved';
        solcomp.Fail_Code_Editable__c='Testing Failcode';
        insert solcomp;
        id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
            
       
        css_parts_options__c patop3 = new css_parts_options__c();
        patop3.Parts_Type__c = 'Custom';
        patop3.RecordTypeId=recodid;
        patop3.Service_Job__c=jo.id;
        patop3.Solutions__c=sol.id;
        patop3.CSS_Claims__c=claims.Id;
        patop3.type__c='Meals';
        insert patop3;
        
        apexpages.currentPage().getparameters().put('id',claims.id);
        test.startTest();
        CG_CL_ClaimsPartsandOtherClaimbles cla = new CG_CL_ClaimsPartsandOtherClaimbles();
        Set<String> errMsgLst1=new Set<String>();
        errMsgLst1.add('abc');
        errMsgLst1.add('abcd');
        errMsgLst1.add('abcde');
        cla.errMsgLst=errMsgLst1;
        List<String> errMsgLstNew1=new List<String>();
        errMsgLstNew1.add('abc');
        errMsgLstNew1.add('abcd');
        errMsgLstNew1.add('abcde');
        cla.errMsgLstNew=errMsgLstNew1;
        cla.saveOtherClaimablesTotal1();
        cla.nvClaimsIntake();
        test.stopTest();
        
    }
    static testmethod void testmethod34()
    {
         Map<decimal,decimal> expTotalTempMap = new Map<decimal,decimal>();
        expTotalTempMap.put(10.8,10.5);
        system.debug(expTotalTempMap + 'expTotalTempMap2**');
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Gopal';
        jo.Customer_Code__c='123';
        jo.ESN__c='56749876';
        insert jo;
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Customer_Name__c='Gopal';
        claims.Customer_Code__c='123';
        claims.ESN__c='56749876';
        claims.CSS_Job__c=jo.id;
        claims.FieldActionWebServiceResult__c='Error';
        insert claims;
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        sol.Name='Testing';
        insert sol;
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
        solcomp.Pay_Code__c='A';
        solcomp.AccountCodeEdit__c='Testing';
        solcomp.Selected_Component__c = true;
        solcomp.Type__c = 'Campaign';
        solcomp.Status__c='Approved';
        solcomp.Fail_Code_Editable__c='Testing Failcode';
        insert solcomp;
        id recodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
            
       
        css_parts_options__c patop4 = new css_parts_options__c();
        patop4.Parts_Type__c = 'Custom';
        patop4.RecordTypeId=recodid;
        patop4.Service_Job__c=jo.id;
        patop4.Solutions__c=sol.id;
        patop4.CSS_Claims__c=claims.Id;
        patop4.type__c='Lodging';
        patop4.Quantity__c = 100;
        insert patop4;
         id partsrecodid = schema.SObjectType.css_parts_options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();    
       
        css_parts_options__c patop41 = new css_parts_options__c();
        patop41.Parts_Type__c = 'Custom';
        patop41.RecordTypeId=partsrecodid;
       // patop41.Service_Job__c=jo.id;
        //patop41.Solutions__c=sol.id;
        patop41.CSS_Claims__c=claims.Id;
        patop41.Part_Assignment__c='Primary';
        patop41.selected_part__c = true;
        insert patop41;
        apexpages.currentPage().getparameters().put('id',claims.id);
        test.startTest();
        CG_CL_ClaimsPartsandOtherClaimbles cla = new CG_CL_ClaimsPartsandOtherClaimbles();
        cla.expTotalTempMap = expTotalTempMap;
        Set<String> errMsgLst1=new Set<String>();
        errMsgLst1.add('abc');
        errMsgLst1.add('abcd');
        errMsgLst1.add('abcde');
        cla.errMsgLst=errMsgLst1;
        List<String> errMsgLstNew1=new List<String>();
        errMsgLstNew1.add('abc');
        errMsgLstNew1.add('abcd');
        errMsgLstNew1.add('abcde');
        cla.saveOtherClaimablesTotal1();
        cla.nvClaimsIntake();
        cla.savePartsTotal();
        test.stopTest();
        
    }
}