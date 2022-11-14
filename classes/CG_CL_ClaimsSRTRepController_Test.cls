@istest
public class CG_CL_ClaimsSRTRepController_Test 
{          
    public static testmethod void CG_CL_ClaimsSRTRepController_method(){
        
        CSS_JobEventTemporary__c Tempkal = new CSS_JobEventTemporary__c();
        Tempkal.Attribute1__c = 'POL';
        Tempkal.Attribute2__c = 'New Engine Warranty';
        Tempkal.Attribute3__c = '67';
        Tempkal.Key__c = 'AccountCodes';
        Insert Tempkal;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.ODM_Penalty__c = '50';
        claim.AccessCode__c='test';
        claim.Account__c=acc.Id;
        claim.Assigned_To__c = null;
        insert claim;
        CSS_PSN__c objPsn = new CSS_PSN__c();
        objPsn.Equipment_ID__c = 'cdrtfvbgyunhjmik';
        objPsn.CSS_Claims__c = claim.id;
        insert objPsn;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        solComp.System_Code__c ='TH';
        solComp.Component_Code__c = 'AC';
        solComp.AccountCodeEdit__c ='New Parts Warranty 62';
        insert solComp;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_ID__c = '100';
        srt.Type__c = 'Repair';
        srt.SRT_Category__c = null;
        srt.isPerformed__c = true;
        srt.Extended_Hours__c = 12.00;
        srt.Component_Id__c = null;
        srt.CSS_Claims__c = claim.id;
        insert srt;    
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Solution_Number__c = sol.id;
        srt1.SRT_Title__c='test';
        srt1.SRT_Quantity__c=123;
        srt1.SRT_Time__c=123;
        srt1.SRT_Access_Code__c='test';
        srt1.SRT_ID__c = '100';
        srt1.Type__c = 'Repair Access';
        srt1.Extended_Hours__c = 12.00;
        srt1.SRT_Category__c = 'AdditionalRep';
        srt1.isPerformed__c = true;
        srt1.Component_Id__c = null;
        srt1.CSS_Claims__c = claim.id;
        insert srt1;
        
        additionalSRTList.add(srt);
        additionalSRTList.add(srt1);
        //additionalSRTList.add(srt2);
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        Test.startTest();
        CG_CL_ClaimsSRTRepController obj = new CG_CL_ClaimsSRTRepController();
        obj.totalDecimalTimeRep = 123.0;
        obj.totalDecimalTimeAccRep = 234.99;
        obj.isCatastrophic = true;
        obj.isAutomatedClaim = true;
        obj.checklaborrate = true;
        obj.selSRTID = 'selSRTID';
        obj.selCoveredVal = 'selCoveredVal';
        obj.PenaltyExists = true;
        obj.isDiagRepSRTCovered = true;
        obj.CID = claim.id;
        obj.calculateExtendedHours();
        Test.stopTest();
    }
    public static testmethod void CG_CL_ClaimsSRTRepController_method1(){
        
        CSS_JobEventTemporary__c Tempkal = new CSS_JobEventTemporary__c();
        Tempkal.Attribute1__c = 'POL';
        Tempkal.Attribute2__c = 'New Engine Warranty';
        Tempkal.Attribute3__c = '67';
        Tempkal.Key__c = 'AccountCodes';
        Insert Tempkal;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.ODM_Penalty__c = '50';
        claim.AccessCode__c='test';
        claim.Account__c=acc.Id;
        claim.Assigned_To__c = null;
        insert claim;
        CSS_PSN__c objPsn = new CSS_PSN__c();
        objPsn.Equipment_ID__c = 'cdrtfvbgyunhjmik';
        objPsn.CSS_Claims__c = claim.id;
        insert objPsn;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        solComp.System_Code__c ='TH';
        solComp.Component_Code__c = 'AC';
        solComp.AccountCodeEdit__c ='New Parts Warranty 62';
        solComp.CSS_Claims__c = claim.id;
     //   solComp.Fail_Code__c = 'TestData';
        solComp.AccountCode__c = 'Troy';
        solComp.AccountCodeType__c = 'data';
        solComp.AccountCodeEdit__c = 'Type3';
        solComp.System_Code__c = 'Star';
        solComp.Failure_Mode__c = 'Wars';
        solComp.Component_Code__c = 'Avengers';
        insert solComp;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        
        insert sol;
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = null;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_ID__c = '100';
       srt.Type__c = 'Repair Access';
      
        srt.SRT_Category__c = null;
        srt.isPerformed__c = true;
        srt.Extended_Hours__c = 12.00;
        srt.Component_Id__c = solComp.id;
        srt.CSS_Claims__c = claim.id;
        srt.SRT_AccessiblityCheck__c = true;
        insert srt;    
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Solution_Number__c = sol.id;
        srt1.SRT_Title__c='test';
        srt1.SRT_Quantity__c=123;
        srt1.SRT_Time__c=123;
        srt1.SRT_Access_Code__c='test';
        srt1.SRT_ID__c = '100';
        srt1.Type__c = 'Repair Access';
        srt1.Extended_Hours__c = 12.00;
        srt1.SRT_Category__c = null;
        srt1.isPerformed__c = true;
        srt1.Component_Id__c = solComp.id;
        srt1.CSS_Claims__c = claim.id;
        srt1.SRT_AccessiblityCheck__c = true;
        insert srt1;
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Solution_Number__c = sol.id;
        srt2.SRT_Title__c='test';
        srt2.SRT_Quantity__c=123;
        srt2.SRT_Time__c=123;
        srt2.SRT_Access_Code__c='test';
        srt2.SRT_ID__c = '100';
        srt2.Type__c = 'Access';
        srt2.Extended_Hours__c = 12.00;
        srt2.SRT_Category__c = null;
        srt2.isPerformed__c = true;
        srt2.Component_Id__c = solComp.id;
        srt2.CSS_Claims__c = claim.id;
        insert srt2;
        
        additionalSRTList.add(srt);
        additionalSRTList.add(srt1);
        additionalSRTList.add(srt2);
        
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        Test.startTest();
        CG_CL_ClaimsSRTRepController obj = new CG_CL_ClaimsSRTRepController();
        obj.totalDecimalTimeRep = 123.0;
        obj.totalDecimalTimeAccRep = 234.99;
        obj.isCatastrophic = true;
        obj.isAutomatedClaim = true;
        obj.checklaborrate = true;
        obj.selSRTID = 'selSRTID';
        obj.selCoveredVal = 'selCoveredVal';
        obj.PenaltyExists = true;
        obj.isDiagRepSRTCovered = true;
        obj.CID = claim.id;
        Test.stopTest();
    }
     public static testmethod void CG_CL_ClaimsSRTRepController_method2(){
        
        CSS_JobEventTemporary__c Tempkal = new CSS_JobEventTemporary__c();
        Tempkal.Attribute1__c = 'NPW';
        Tempkal.Attribute2__c = 'New Engine Warranty';
        Tempkal.Attribute3__c = '67';
        Tempkal.Key__c = 'AccountCodes';
        Insert Tempkal;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.ODM_Penalty__c = '50';
        claim.AccessCode__c='test';
        claim.Account__c=acc.Id;
        claim.Assigned_To__c = null;
        claim.CSS_Job__c = JO.id;
        insert claim;
        CSS_PSN__c objPsn = new CSS_PSN__c();
        objPsn.Equipment_ID__c = 'cdrtfvbgyunhjmik';
        objPsn.CSS_Claims__c = claim.id;
        insert objPsn;
        
        List<CSS_Solution_Component__c> solComplist = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        solComp.System_Code__c ='TH';
        solComp.Component_Code__c = 'AC';
        solComp.AccountCodeEdit__c ='New Parts Warranty 62';
        
        solComplist.add(solComp);
        insert solComplist;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = null;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_ID__c = '100';
        srt.Type__c = 'Repair';
        srt.SRT_Category__c = null;
        srt.isPerformed__c = true;
        srt.Extended_Hours__c = 12.00;
        srt.Component_Id__c = solComp.id;
        srt.CSS_Claims__c = claim.id;
        srt.SRT_AccessiblityCheck__c = true;
        insert srt;    
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Solution_Number__c = sol.id;
        srt1.SRT_Title__c='test';
        srt1.SRT_Quantity__c=123;
        srt1.SRT_Time__c=123;
        srt1.SRT_Access_Code__c='test';
        srt1.SRT_ID__c = '100';
        srt1.Type__c = 'Repair';
        srt1.Extended_Hours__c = 12.00;
        srt1.SRT_Category__c = null;
        srt1.isPerformed__c = true;
        srt1.Component_Id__c = solComp.id;
        srt1.CSS_Claims__c = claim.id;
        srt1.SRT_AccessiblityCheck__c = true;
        insert srt1;
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Solution_Number__c = sol.id;
        srt2.SRT_Title__c='test';
        srt2.SRT_Quantity__c=123;
        srt2.SRT_Time__c=123;
        srt2.SRT_Access_Code__c='test';
        srt2.SRT_ID__c = '100';
        srt2.Type__c = 'Repair';
        srt2.Extended_Hours__c = 12.00;
        srt2.SRT_Category__c = null;
        srt2.isPerformed__c = true;
        srt2.Component_Id__c = solComp.id;
        srt2.CSS_Claims__c = claim.id;
        srt2.SRT_AccessiblityCheck__c = true;
        insert srt2;
        
        additionalSRTList.add(srt);
        additionalSRTList.add(srt1);
        additionalSRTList.add(srt2);
        
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        Test.startTest();
        CG_CL_ClaimsSRTRepController obj = new CG_CL_ClaimsSRTRepController();
        obj.totalDecimalTimeRep = 123.0;
        obj.totalDecimalTimeAccRep = 234.99;
        obj.isCatastrophic = true;
        obj.isAutomatedClaim = true;
        obj.checklaborrate = true;
        obj.selSRTID = 'selSRTID';
        obj.selCoveredVal = 'selCoveredVal';
        obj.PenaltyExists = true;
        obj.isDiagRepSRTCovered = true;
        obj.CID = claim.id;
        Test.stopTest();
    }
    public static testmethod void SRTPercReqRepMethod(){
        Test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        jo.Customer_Name__c = 'CumminsTnD';
        jo.Equipment_ID__c = 'EQ7667';
        jo.Qsol_Engine_Family_Code__c ='56';
        jo.AccessCode__c = 'A';
        jo.Account__c = acc.id;
        insert jo;
        lstjo.add(jo);
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
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
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.Type__c= '';
        additionalSRTList1.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Repair';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.SRT_ID__c = '100';
        srt1.isPerformed__c = true;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'Select One';
        additionalSRTList1.add(srt1);
        
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Job_Order__c = JO.id;
        srt2.SRT_AccessiblityCheck__c=True;
        srt2.Access_Code_A__c = 65;
        srt2.name = 'TestClassName';
        srt2.type__c = 'Repair';
        srt2.Assignment__c = 'PRIMARY';
        srt2.srt_time__c = 1;
        srt2.SRT_ID__c = '100';
        srt2.isPerformed__c = true;
        srt2.ODM_Status__c = '';
        srt2.Access_Code__c = 'A';
        srt2.Account_Code__c = '';
        srt2.SRT_Category__c='';
        additionalSRTList1.add(srt2);
        insert additionalSRTList1;
        
        List<String> sid=new List<String>();
        for(CSS_SRT__c ss:additionalSRTList1){
            sid.add(ss.id);
        }
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        claim.Account__c = acc.id;
        cc.add(claim);
        insert cc;
        
        apexpages.currentPage().getparameters().put('id',Claim.id); 
        id cid=apexpages.currentPage().getparameters().get('id');
        system.assert(cid!=null);
        CG_CL_ClaimsSRTRepController p = new CG_CL_ClaimsSRTRepController();
        CG_CL_ClaimsSRTRepController.srtWrapper cmp =new  CG_CL_ClaimsSRTRepController.srtWrapper();
        List<CG_CL_ClaimsSRTRepController.srtWrapper> lstcmp = new List<CG_CL_ClaimsSRTRepController.srtWrapper>();
        
        CG_CL_ClaimsSRTRepController.sortWrapper srtdata=new CG_CL_ClaimsSRTRepController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTRepController.sortWrapper> ss=new List<CG_CL_ClaimsSRTRepController.sortWrapper>();
        ss.add(srtdata);
        p.repListWrap=ss;
        srtdata.compareTo(srtdata);
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=True;
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
        p.CID=cc[0].id;
        lstcmp.add(cmp);
        //p.selSRTID = '100';
        p.SRTPercReqRep();
        Test.stopTest();
    }
    public static testmethod void getRepairTimeMethod(){
        Test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        jo.Customer_Name__c = 'CumminsTnD';
        jo.Equipment_ID__c = 'EQ7667';
        jo.Qsol_Engine_Family_Code__c ='56';
        jo.AccessCode__c = 'A';
        jo.Account__c = acc.id;
        insert jo;
        lstjo.add(jo);
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
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
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.Type__c= '';
        additionalSRTList1.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Repair';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.SRT_ID__c = '00-901-10';
        srt1.isPerformed__c = true;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'Select One';
        additionalSRTList1.add(srt1);
        
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Job_Order__c = JO.id;
        srt2.SRT_AccessiblityCheck__c=True;
        srt2.Access_Code_A__c = 65;
        srt2.name = 'TestClassName';
        srt2.type__c = 'Repair';
        srt2.Assignment__c = 'PRIMARY';
        srt2.srt_time__c = 1;
        srt2.SRT_ID__c = '00-901-10';
        srt2.isPerformed__c = true;
        srt2.ODM_Status__c = '';
        srt2.Access_Code__c = 'A';
        srt2.Account_Code__c = '';
        srt2.SRT_Category__c='';
        additionalSRTList1.add(srt2);
        insert additionalSRTList1;
        
        List<String> sid=new List<String>();
        for(CSS_SRT__c ss:additionalSRTList1){
            sid.add(ss.id);
        }
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        claim.Account__c = acc.id;
        cc.add(claim);
        insert cc;
        
        apexpages.currentPage().getparameters().put('id',Claim.id); 
        id cid=apexpages.currentPage().getparameters().get('id');
        system.assert(cid!=null);
        CG_CL_ClaimsSRTRepController p = new CG_CL_ClaimsSRTRepController();
        CG_CL_ClaimsSRTRepController.srtWrapper cmp =new  CG_CL_ClaimsSRTRepController.srtWrapper();
        List<CG_CL_ClaimsSRTRepController.srtWrapper> lstcmp = new List<CG_CL_ClaimsSRTRepController.srtWrapper>();
        
        CG_CL_ClaimsSRTRepController.sortWrapper srtdata=new CG_CL_ClaimsSRTRepController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTRepController.sortWrapper> ss=new List<CG_CL_ClaimsSRTRepController.sortWrapper>();
        ss.add(srtdata);
        p.repListWrap=ss;
        srtdata.compareTo(srtdata);
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=True;
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
        p.CID=cc[0].id;
        lstcmp.add(cmp);
        p.getRepairTime();
        Test.stopTest();
    }
    public static testmethod void overlapSRTCalloutMethod(){
        CSS_JobEventTemporary__c Tempkal = new CSS_JobEventTemporary__c();
        Tempkal.Attribute1__c = 'POL';
        Tempkal.Attribute2__c = 'New Engine Warranty';
        Tempkal.Attribute3__c = '67';
        Tempkal.Key__c = 'AccountCodes';
        Insert Tempkal;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        CSS_Claims__c claim = new CSS_Claims__C();
        claim.ODM_Penalty__c = '50';
        claim.AccessCode__c='test';
        claim.Account__c=acc.Id;
        claim.Assigned_To__c = null;
        insert claim;
        CSS_PSN__c objPsn = new CSS_PSN__c();
        objPsn.Equipment_ID__c = 'cdrtfvbgyunhjmik';
        objPsn.CSS_Claims__c = claim.id;
        insert objPsn;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Type__c = 'TRP';
        solComp.Campaign_Description__c='test';
        solComp.System_Code__c ='TH';
        solComp.Component_Code__c = 'AC';
        solComp.AccountCodeEdit__c ='New Parts Warranty 62';
        insert solComp;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_ID__c = '100';
     //   srt.Type__c = 'Repair';
     srt.Type__c = 'Access';
     srt.SRT_AccessiblityCheck__c = true;
        srt.SRT_Category__c = null;
        srt.isPerformed__c = true;
        srt.Extended_Hours__c = 12.00;
        srt.Component_Id__c = solComp.id;
        srt.CSS_Claims__c = claim.id;
        //srt.Step_Id__c = 'Test';
        srt.Access_Code_A__c =0;
        srt.Access_Code_B__c = 0;
        srt.Access_Code_C__c = 0;
        srt.Access_Code_D__c = 0;
        srt.Access_Code_R__c = 2;
        srt.FailCode__c = 'TestData';
        insert srt;    
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Solution_Number__c = sol.id;
        srt1.SRT_Title__c='test';
        srt1.SRT_Quantity__c=123;
        srt1.SRT_Time__c=123;
        srt1.SRT_Access_Code__c='test';
        srt1.SRT_ID__c = '100';
        srt1.Type__c = 'Access';
        srt1.Extended_Hours__c = 12.00;
        srt1.SRT_Category__c = 'AdditionalRep';
        srt1.isPerformed__c = true;
        srt1.Component_Id__c = solComp.id;
        srt1.CSS_Claims__c = claim.id;
        srt1.SRT_AccessiblityCheck__c = true;
        //srt1.Step_Id__c = 'Test';
        srt1.Access_Code_A__c =0;
        srt1.Access_Code_B__c = 0;
        srt1.Access_Code_C__c = 0;
        srt1.Access_Code_D__c = 0;
        srt1.Access_Code_R__c = 2;
        srt1.FailCode__c = 'TestData';
        insert srt1;
        additionalSRTList.add(srt);
        additionalSRTList.add(srt1);
        ApexPages.currentPage().getParameters().put('id', claim.Id);
        
       
        
        Test.startTest();
        CG_CL_ClaimsSRTRepController obj = new CG_CL_ClaimsSRTRepController();
         Set<String> overlapSRTIds = new Set<String>();
        overlapSRTIds.add('element');
        
        obj.overlapSRTCallout('accCode',additionalSRTList);
        Test.stopTest();
    }
    public static testmethod void calculateExtendedHoursMethod(){
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        jo.Customer_Name__c = 'CumminsTnD';
        jo.Equipment_ID__c = 'EQ7667';
        jo.Qsol_Engine_Family_Code__c ='56';
        jo.AccessCode__c = 'A';
        jo.Account__c = acc.id;
        insert jo;
        lstjo.add(jo);
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
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
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.Type__c= '';
        additionalSRTList1.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Repair';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.SRT_ID__c = '00-901-10';
        srt1.isPerformed__c = true;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'Select One';
        additionalSRTList1.add(srt1);
        
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Job_Order__c = JO.id;
        srt2.SRT_AccessiblityCheck__c=True;
        srt2.Access_Code_A__c = 65;
        srt2.name = 'TestClassName';
        srt2.type__c = 'Repair';
        srt2.Assignment__c = 'PRIMARY';
        srt2.srt_time__c = 1;
        srt2.SRT_ID__c = '00-901-10';
        srt2.isPerformed__c = true;
        srt2.ODM_Status__c = '';
        srt2.Access_Code__c = 'A';
        srt2.Account_Code__c = '';
        srt2.SRT_Category__c='';
        additionalSRTList1.add(srt2);
        
        insert additionalSRTList1;
        Test.startTest();
        CG_CL_ClaimsSRTRepController p = new CG_CL_ClaimsSRTRepController();
        p.calculateExtendedHours();
        Test.stopTest();
    }
    public static testmethod void changeUpOrderMethod(){
        Test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        jo.Customer_Name__c = 'CumminsTnD';
        jo.Equipment_ID__c = 'EQ7667';
        jo.Qsol_Engine_Family_Code__c ='56';
        jo.AccessCode__c = 'A';
        jo.Account__c = acc.id;
        insert jo;
        lstjo.add(jo);
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
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
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.Type__c= '';
        additionalSRTList1.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Repair';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.SRT_ID__c = '00-901-10';
        srt1.isPerformed__c = true;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'Select One';
        additionalSRTList1.add(srt1);
        
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Job_Order__c = JO.id;
        srt2.SRT_AccessiblityCheck__c=True;
        srt2.Access_Code_A__c = 65;
        srt2.name = 'TestClassName';
        srt2.type__c = 'Repair';
        srt2.Assignment__c = 'PRIMARY';
        srt2.srt_time__c = 1;
        srt2.SRT_ID__c = '00-901-10';
        srt2.isPerformed__c = true;
        srt2.ODM_Status__c = '';
        srt2.Access_Code__c = 'A';
        srt2.Account_Code__c = '';
        srt2.SRT_Category__c='';
        additionalSRTList1.add(srt2);
        insert additionalSRTList1;
        
        List<String> sid=new List<String>();
        for(CSS_SRT__c ss:additionalSRTList1){
            sid.add(ss.id);
        }
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        claim.Account__c = acc.id;
        cc.add(claim);
        insert cc;
        
        apexpages.currentPage().getparameters().put('id',Claim.id); 
        id cid=apexpages.currentPage().getparameters().get('id');
        system.assert(cid!=null);
        CG_CL_ClaimsSRTRepController p = new CG_CL_ClaimsSRTRepController();
        CG_CL_ClaimsSRTRepController.srtWrapper cmp =new  CG_CL_ClaimsSRTRepController.srtWrapper();
        List<CG_CL_ClaimsSRTRepController.srtWrapper> lstcmp = new List<CG_CL_ClaimsSRTRepController.srtWrapper>();
        
        CG_CL_ClaimsSRTRepController.sortWrapper srtdata=new CG_CL_ClaimsSRTRepController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTRepController.sortWrapper> ss=new List<CG_CL_ClaimsSRTRepController.sortWrapper>();
        ss.add(srtdata);
        p.repListWrap=ss;
        srtdata.compareTo(srtdata);
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=True;
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
        p.CID=cc[0].id;
        lstcmp.add(cmp);
        p.changeUpOrder();
        Test.stopTest();
    }
    public static testmethod void changeDownOrderMethod(){
        Test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        jo.Customer_Name__c = 'CumminsTnD';
        jo.Equipment_ID__c = 'EQ7667';
        jo.Qsol_Engine_Family_Code__c ='56';
        jo.AccessCode__c = 'A';
        jo.Account__c = acc.id;
        insert jo;
        lstjo.add(jo);
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
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
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.Type__c= '';
        additionalSRTList1.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Repair';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.SRT_ID__c = '00-901-10';
        srt1.isPerformed__c = true;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'Select One';
        additionalSRTList1.add(srt1);
        
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Job_Order__c = JO.id;
        srt2.SRT_AccessiblityCheck__c=True;
        srt2.Access_Code_A__c = 65;
        srt2.name = 'TestClassName';
        srt2.type__c = 'Repair';
        srt2.Assignment__c = 'PRIMARY';
        srt2.srt_time__c = 1;
        srt2.SRT_ID__c = '00-901-10';
        srt2.isPerformed__c = true;
        srt2.ODM_Status__c = '';
        srt2.Access_Code__c = 'A';
        srt2.Account_Code__c = '';
        srt2.SRT_Category__c='';
        additionalSRTList1.add(srt2);
        insert additionalSRTList1;
        
        List<String> sid=new List<String>();
        for(CSS_SRT__c ss:additionalSRTList1){
            sid.add(ss.id);
        }
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        claim.Account__c = acc.id;
        cc.add(claim);
        insert cc;
        
        apexpages.currentPage().getparameters().put('id',Claim.id); 
        id cid=apexpages.currentPage().getparameters().get('id');
        system.assert(cid!=null);
        CG_CL_ClaimsSRTRepController p = new CG_CL_ClaimsSRTRepController();
        CG_CL_ClaimsSRTRepController.srtWrapper cmp =new  CG_CL_ClaimsSRTRepController.srtWrapper();
        List<CG_CL_ClaimsSRTRepController.srtWrapper> lstcmp = new List<CG_CL_ClaimsSRTRepController.srtWrapper>();
        
        CG_CL_ClaimsSRTRepController.sortWrapper srtdata=new CG_CL_ClaimsSRTRepController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTRepController.sortWrapper> ss=new List<CG_CL_ClaimsSRTRepController.sortWrapper>();
        ss.add(srtdata);
        p.repListWrap=ss;
        srtdata.compareTo(srtdata);
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=True;
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
        p.CID=cc[0].id;
        lstcmp.add(cmp);
        p.changeDownOrder();
        Test.stopTest();
    }
    public static testmethod void callClaimsAccessStepDetailsRepairMethod(){
        Test.startTest();
        CG_CL_ClaimsSRTRepController obj = new CG_CL_ClaimsSRTRepController();
        obj.callClaimsAccessStepDetailsRepair();
        Test.stopTest();
    }
    public static testmethod void ClaimsRepairNotesPopupOkMethod(){
        Test.startTest();
        CG_CL_ClaimsSRTRepController obj = new CG_CL_ClaimsSRTRepController();
        obj.ClaimsRepairNotesPopupOk();
        Test.stopTest();
    }
    public static testmethod void saveRepDataMethod(){
        Test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        List <CSS_Job_Order__c> lstjo = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        jo.Customer_Name__c = 'CumminsTnD';
        jo.Equipment_ID__c = 'EQ7667';
        jo.Qsol_Engine_Family_Code__c ='56';
        jo.AccessCode__c = 'A';
        jo.Account__c = acc.id;
        insert jo;
        lstjo.add(jo);
        
        list<CSS_Claims__c> clist = new list<CSS_Claims__c>();
        CSS_Claims__c c1 = new CSS_Claims__c();
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
        
        List<CSS_SRT__c> additionalSRTList1 = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Solution_Number__c = sol.id;
        srt.SRT_Title__c='test';
        srt.SRT_Quantity__c=123;
        srt.SRT_Time__c=123;
        srt.SRT_Access_Code__c='test';
        srt.SRT_Category__c='Campaign';
        srt.Type__c= 'Admin';
        srt.isPerformed__c = false;
        additionalSRTList1.add(srt);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Job_Order__c = JO.id;
        srt1.SRT_AccessiblityCheck__c=True;
        srt1.Access_Code_A__c = 65;
        srt1.name = 'TestClassName';
        srt1.type__c = 'Repair';
        srt1.Assignment__c = 'PRIMARY';
        srt1.srt_time__c = 1;
        srt1.SRT_ID__c = '00-901-10';
        srt1.isPerformed__c = false;
        srt1.ODM_Status__c = '';
        srt1.Access_Code__c = 'A';
        srt1.Account_Code__c = 'Not 2';
        srt1.FailCode__c = 'Select One';
       additionalSRTList1.add(srt1);
        
        CSS_SRT__c srt2 = new CSS_SRT__c();
        srt2.Job_Order__c = JO.id;
        srt2.SRT_AccessiblityCheck__c=True;
        srt2.Access_Code_A__c = 65;
        srt2.name = 'TestClassName';
        srt2.type__c = 'Repair';
        srt2.Assignment__c = 'PRIMARY';
        srt2.srt_time__c = 1;
        srt2.SRT_ID__c = '00-901-10';
        srt2.isPerformed__c = false;
        srt2.ODM_Status__c = '';
        srt2.Access_Code__c = 'A';
        srt2.Account_Code__c = '';
        srt2.SRT_Category__c='';
        srt2.FailCode__c = 'Select One';
        additionalSRTList1.add(srt2);
        insert additionalSRTList1;
        
        List<String> sid=new List<String>();
        for(CSS_SRT__c ss:additionalSRTList1){
            sid.add(ss.id);
        }
        List<CSS_Claims__c> cc=new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='Gopal';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        claim.Account__c = acc.id;
        cc.add(claim);
        insert cc;
        
        apexpages.currentPage().getparameters().put('id',Claim.id); 
        id cid=apexpages.currentPage().getparameters().get('id');
        system.assert(cid!=null);
        CG_CL_ClaimsSRTRepController p = new CG_CL_ClaimsSRTRepController();
        CG_CL_ClaimsSRTRepController.srtWrapper cmp =new  CG_CL_ClaimsSRTRepController.srtWrapper();
        List<CG_CL_ClaimsSRTRepController.srtWrapper> lstcmp = new List<CG_CL_ClaimsSRTRepController.srtWrapper>();
        
        CG_CL_ClaimsSRTRepController.sortWrapper srtdata=new CG_CL_ClaimsSRTRepController.sortWrapper(cmp);
        List<CG_CL_ClaimsSRTRepController.sortWrapper> ss=new List<CG_CL_ClaimsSRTRepController.sortWrapper>();
        ss.add(srtdata);
        p.repListWrap=ss;
        srtdata.compareTo(srtdata);
        cmp.solTitle='Test';
        cmp.solNum='1234';
        cmp.srtCheckBox=True;
        cmp.accessSrtCheckBox=True;
        cmp.sId=null;
        
        cmp.failcode='';
        cmp.srtType='';
        cmp.fautCodeName='';
        cmp.symptomName='';
        cmp.AccessCodeSaved='';
        cmp.SRTAccessCode='';
        
        
        cmp.AccessCode='testData';
        cmp.accountcode='';
        cmp.srtID= '00-901-10';
        
        cmp.srtDescription='';
        cmp.quantity=10;
        
        cmp.srtTime=null;
        cmp.srtAccessTime=null;
        cmp.srtWarrantable='';
        cmp.selectedRecord=true;
        cmp.accTime='';
        
        cmp.accTimeDec=null;
        cmp.ClaimedHrs=null;
        cmp.IsPopUpSRT=True;
        cmp.sortOrder=null; 
        p.CID=cc[0].id;
        lstcmp.add(cmp);
        p.saveRepData();
        Test.stopTest();
    }
    
}