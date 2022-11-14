@isTest
public class CG_CL_UpdateallChildEntityODMStatus_Test {
static testMethod void TestMethod1()
    {
      
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        list<id> idlist = new list<id>();
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.Account__c = acc.id;
        JO.Make__c = 'test1234';
        JO.Model__c = 'test1234';
        JO.DSID__c = 'test1234';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        JO.Failure_Date__c=date.today();
        JO.ESN__c = '79464646';
    
        insert(JO);
        idlist.add(JO.id);
        
        css_claims__c claims1 = new css_claims__c();
        claims1.Account__c = acc.id;
        insert claims1;
        
        List<CSS_Solutions__c> solu = new List<CSS_Solutions__c>();
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Service_Job__c=JO.Id;
        solRef.Solution_title__c='TestData';
        //solRef.Account_Code__c ='A';
        insert solRef;
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(true,JO.Id,solRef.Id);
       map<id,list<CSS_Parts_Options__c>> mapSolCompToParts=new map<id,list<CSS_Parts_Options__c>>();
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'BMS Parts');
         CSS_Parts_Options__c po =new CSS_Parts_Options__c();
      po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.Service_Job__c = JO.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Service_Job__c = JO.id;
        po.Account_Code__c ='A'; 
        po.Solutions__c=solRef.id;
        po.FailurepartId__c =solComRef.Id; 
        po.ODM_Status__c = '';
        po.CSS_Claims__c=claims1.Id;
        insert po;
         lstpo.add(po);
       
        CSS_SRT__c SRT = new CSS_SRT__c();
					srt.Job_Order__c = JO.id;
                    srt.SRT_AccessiblityCheck__c=True;
                    srt.Access_Code_A__c = 65;
                    srt.name = 'TestClassName';
					srt.type__c = 'Admin';
           			srt.Assignment__c = 'PRIMARY';
           			srt.srt_time__c = 1;
           			srt.SRT_ID__c = '00-901-10';
		           	srt.isPerformed__c = true;
        srt.CSS_Claims__c=claims1.Id;
        insert srt;
        
        test.startTest();
        CG_CL_UpdateallChildEntityODMStatus.updateODMStatusForChildEntity(idlist);
        test.stopTest();
       
        
}
    static testMethod void TestMethod2()
    {
        test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>(); 
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.Make__c = 'test1234';
        JO.Model__c = 'test1234';
        JO.DSID__c = 'test1234';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        JO.Failure_Date__c=date.today();
        JO.ESN__c = '79464646';
    
        insert(JO);
        
    list<id> idlist = new list<id>();
         CSS_Claims__c  autoclaimsRec= new CSS_Claims__c();
        autoclaimsRec.CSS_Job__c=JO.id;
        autoclaimsRec.Account__c = acc.id;
        insert autoclaimsRec;
        
        CSS_Claims__c  ManclaimsRec= new CSS_Claims__c();
        insert ManclaimsRec;
        CSS_SRT__c SRT1 = new CSS_SRT__c();
                    srt1.css_claims__c = autoclaimsRec.id;
                    srt1.SRT_AccessiblityCheck__c=True;
                    srt1.Access_Code_A__c = 65;
                    srt1.name = 'TestClassName';
					srt1.type__c = 'Admin';
           			srt1.Assignment__c = 'PRIMARY';
           			srt1.srt_time__c = 1;
           			srt1.SRT_ID__c = '00-902-10';
					srt1.isPerformed__c = true;
        srt1.Account_Code__c = 'A';
           insert srt1;
        
    idlist.add(autoclaimsRec.id);
        idlist.add(ManclaimsRec.id);
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,JO.Id,null);
        solComRef.css_claims__c = autoclaimsrec.id;
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'BMS Parts');
        CSS_Parts_Options__c autoclaimPO =new CSS_Parts_Options__c();
        autoclaimPO.Notes__c='123';
        autoclaimPO.RecordTypeId = recTypeIdpart;
        autoclaimPO.Service_Job__c = JO.id;
        autoclaimPO.OEM__c ='123';
        autoclaimPO.Quantity__c =1;
        autoclaimPO.Selected_part__c =true;
        autoclaimPO.Part_Name__c ='123';
        autoclaimPO.Service_partnumber__c ='123';
        autoclaimPO.Parts_Type__c ='Custom';
        autoclaimPO.css_claims__c = autoclaimsRec.id;
        autoclaimPO.Account_Code__c ='A'; 
        autoclaimPO.ODM_Status__c = '';
        lstpo.add(autoclaimPO);
        //insert lstpo;
        CSS_Parts_Options__c autoclaimPO1 =new CSS_Parts_Options__c();
        autoclaimPO1.Notes__c='123';
        autoclaimPO1.RecordTypeId = recTypeIdpart;
        autoclaimPO1.Service_Job__c = JO.id;
        autoclaimPO1.OEM__c ='123';
        autoclaimPO1.Quantity__c =1;
        autoclaimPO1.Selected_part__c =true;
        autoclaimPO1.Part_Name__c ='123';
        autoclaimPO1.Service_partnumber__c ='123';
        autoclaimPO1.Parts_Type__c ='Custom';
        autoclaimPO1.css_claims__c = autoclaimsRec.id;
        autoclaimPO1.Account_Code__c ='A'; 
        autoclaimPO1.ODM_Status__c = '';
        lstpo.add(autoclaimPO1);
        
        CSS_Parts_Options__c manclaimPO =new CSS_Parts_Options__c();
        manclaimPO.Notes__c='123';
        manclaimPO.RecordTypeId = recTypeIdpart;
        manclaimPO.css_claims__c = ManClaimsRec.id;
        manclaimPO.OEM__c ='123';
        manclaimPO.Quantity__c =1;
        manclaimPO.Selected_part__c =true;
        manclaimPO.Part_Name__c ='123';
        manclaimPO.Service_partnumber__c ='123';
        manclaimPO.Parts_Type__c ='Custom';
        //manclaimPO.Service_Job__c = JO.id;
        manclaimPO.Account_Code__c ='B'; 
        manclaimPO.ODM_Status__c = '';
        lstpo.add(manclaimPO);
        insert lstpo;
        POAccountCodeMap.put('123+A',lstpo);
     CG_CL_UpdateallChildEntityODMStatus.updateODMStatusForChildEntity(idlist);
        test.stopTest();
}
     static testMethod void TestMethodManClaim()
    {
        test.startTest();
        //Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap = new Map<string, list<CSS_Parts_Options__c>>(); 
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.Make__c = 'test1234';
        JO.Model__c = 'test1234';
        JO.DSID__c = 'test1234';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        JO.Failure_Date__c=date.today();
        JO.ESN__c = '79464646';
    
        insert(JO);
        
    list<id> idlist = new list<id>();
            
        CSS_Claims__c  ManclaimsRec= new CSS_Claims__c();
        ManclaimsRec.Account__c = acc.id;
        insert ManclaimsRec;
    //idlist.add(autoclaimsRec.id);
        idlist.add(ManclaimsRec.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'OtherClaimables');
   CSS_Parts_Options__c autoclaimPO1 =new CSS_Parts_Options__c();
        autoclaimPO1.Notes__c='123';
        autoclaimPO1.RecordTypeId = recTypeIdpart;
        autoclaimPO1.Service_Job__c = JO.id;
        autoclaimPO1.CSS_Claims__c=ManclaimsRec.Id;
        autoclaimPO1.OEM__c ='123';
        autoclaimPO1.Quantity__c =1;
        autoclaimPO1.Selected_part__c =true;
        autoclaimPO1.Part_Name__c ='123';
        autoclaimPO1.Service_partnumber__c ='123';
        autoclaimPO1.Parts_Type__c ='Custom';
        //autoclaimPO1.css_claims__c = autoclaimsRec.id;
        autoclaimPO1.Account_Code__c =''; 
        autoclaimPO1.ODM_Status__c = '';
        lstpo.add(autoclaimPO1);
        
        CSS_Parts_Options__c manclaimPO =new CSS_Parts_Options__c();
        manclaimPO.Notes__c='123';
        manclaimPO.RecordTypeId = recTypeIdpart;
        manclaimPO.css_claims__c = ManClaimsRec.id;
        manclaimPO.OEM__c ='123';
        manclaimPO.Quantity__c =1;
        manclaimPO.Selected_part__c =true;
        manclaimPO.Part_Name__c ='123';
        manclaimPO.Service_partnumber__c ='123';
        manclaimPO.Parts_Type__c ='Custom';
        //manclaimPO.Service_Job__c = JO.id;
        manclaimPO.Account_Code__c ='B'; 
        manclaimPO.ODM_Status__c = '';
        manclaimPO.selected_part__c = true;
        lstpo.add(manclaimPO);
        
        insert lstpo;
        
        //POAccountCodeMap.put('123+A',lstpo);
     CG_CL_UpdatePartsOptionsODMStatus.updatePartsODMStatus(idlist);
        test.stopTest();
}
    static testmethod void testUpdateallChildEntityODMStatus()
    {
        user u = CSS_TestData.createTestUser(false);
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Claims__c  ManclaimsRec= new CSS_Claims__c();
        ManclaimsRec.Account__c = acc.id;
        insert ManclaimsRec;
        
        css_job_order__c jo = new css_job_order__c();
        JO.Customer_Code__c='123';
        JO.Account__c = acc.id;
        jo.Customer_Name__c='Gopal';
        jo.ESN__c='58765476';
        jo.ODM_Status__c='';
        jo.ODM_Status_Message__c='';
        jo.ODM_Pre_submit_Status__c='';
        insert jo;
        
        css_job_order__c jo1 = new css_job_order__c();
        JO1.Account__c = acc.id;
        JO1.Customer_Code__c='1234';
        jo1.Customer_Name__c='Gopal12';
        jo1.ESN__c='58765476';
        jo1.ODM_Status__c='';
        jo1.ODM_Status_Message__c='';
        jo1.ODM_Pre_submit_Status__c='';
        insert jo1;
        
       css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.id;
        sol.Name='Testing';
       insert sol;
        css_solution_Component__c solcomp = new css_solution_Component__c();
        solcomp.Solutions__c=sol.Id;
        solcomp.Service_Job__c=jo.Id;
        solcomp.Name='Testing';
        solcomp.ODM_Status__c='';
        solcomp.CSS_Claims__c=ManclaimsRec.Id;
        insert solcomp;
        
         Id recTypeIdpart =Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
         CSS_Parts_Options__c autoclaimPO1 =new CSS_Parts_Options__c();
        autoclaimPO1.RecordTypeId = recTypeIdpart;
        autoclaimPO1.Service_Job__c = JO.id;
        autoclaimPO1.ODM_Status__c = '';     
        autoclaimPO1.FailurepartId__c=solcomp.Id;
        autoclaimpo1.Solutions__c=sol.Id;
        autoclaimpo1.CSS_Claims__c=ManclaimsRec.id;
        insert autoclaimPO1;
     
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Job_Order__c=jo.Id;
        srt.ODM_Status__c='';
        srt.CSS_Claims__c=ManclaimsRec.Id;
        insert srt;
        
        list<css_job_order__c> jolist=[Select id,ODM_Status__c,ODM_Status_Message__c,ODM_Pre_submit_Status__c from css_job_order__c];
     list<id> idlist = new list<id>();
        for(css_job_order__c jo2:jolist)
        {
        idlist.add(jo2.Id);
        }
        list<id> claims1 = new list<id>();
        claims1.add(ManclaimsRec.Id);
        test.startTest();
        CG_CL_UpdateallChildEntityODMStatus.updateODMStatusForChildEntity(idlist);
         CG_CL_UpdateallChildEntityODMStatus.updateODMStatusForChildEntity(claims1);
        test.stopTest();
    }
     static testmethod void testUpdateallChildEntityODMStatus2()
    {
        user u = CSS_TestData.createTestUser(false);
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
         CSS_Claims__c  ManclaimsRec= new CSS_Claims__c();
         ManclaimsRec.Information_Only_Claim__c=true;
         ManclaimsRec.Account__c =acc.id;
        insert ManclaimsRec;
        
        css_job_order__c jo = new css_job_order__c();
        JO.Customer_Code__c='123';
        JO.Account__c = acc.id;
        jo.Customer_Name__c='Gopal';
        jo.ESN__c='58765476';
        jo.ODM_Status__c='';
        jo.ODM_Status_Message__c='';
        jo.ODM_Pre_submit_Status__c='';
        insert jo;
        
         css_job_order__c jo1 = new css_job_order__c();
        JO1.Customer_Code__c='1234';
        JO1.Account__c = acc.id;
        jo1.Customer_Name__c='Gopal12';
        jo1.ESN__c='58765476';
        jo1.ODM_Status__c='';
        jo1.ODM_Status_Message__c='';
        jo1.ODM_Pre_submit_Status__c='';
        insert jo1;
        
       css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.id;
        sol.Name='Testing';
       insert sol;
        
        css_solution_Component__c solcomp = new css_solution_Component__c();
        solcomp.Solutions__c=sol.Id;
        solcomp.Service_Job__c=jo.Id;
        solcomp.Name='Testing';
        solcomp.ODM_Status__c='';
        solcomp.CSS_Claims__c=ManclaimsRec.Id;
        solcomp.pay_code__c='A';
        insert solcomp;
        
         Id recTypeIdpart =Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
         CSS_Parts_Options__c autoclaimPO1 =new CSS_Parts_Options__c();
        autoclaimPO1.RecordTypeId = recTypeIdpart;
        autoclaimPO1.Service_Job__c = JO.id;
        autoclaimPO1.ODM_Status__c = '';     
        autoclaimPO1.FailurepartId__c=solcomp.Id;
        autoclaimpo1.Solutions__c=sol.Id;
        autoclaimpo1.CSS_Claims__c=ManclaimsRec.id;
        insert autoclaimPO1;
     
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Job_Order__c=jo.Id;
        srt.ODM_Status__c='';
        srt.CSS_Claims__c=ManclaimsRec.Id;
        
        srt.Account_Code__c = '61';
        insert srt;
        
        list<css_job_order__c> jolist=[Select id,ODM_Status__c,ODM_Status_Message__c,ODM_Pre_submit_Status__c from css_job_order__c];
     list<id> idlist = new list<id>();
        for(css_job_order__c jo2:jolist)
        {
        idlist.add(jo2.Id);
        }
        list<id> claims1 = new list<id>();
        claims1.add(ManclaimsRec.Id);
        test.startTest();
        CG_CL_UpdateallChildEntityODMStatus.updateODMStatusForChildEntity(idlist);
         CG_CL_UpdateallChildEntityODMStatus.updateODMStatusForChildEntity(claims1);
        test.stopTest();
    }
     static testmethod void testUpdateallChildEntityODMStatus3()
    {
        user u = CSS_TestData.createTestUser(false);
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
         CSS_Claims__c  ManclaimsRec= new CSS_Claims__c();
        ManclaimsRec.Account__c = acc.id;
         ManclaimsRec.Information_Only_Claim__c=true;
        insert ManclaimsRec;
        
        css_job_order__c jo = new css_job_order__c();
        JO.Customer_Code__c='123';
        JO.Account__c = acc.id;
        jo.Customer_Name__c='Gopal';
        jo.ESN__c='58765476';
        jo.ODM_Status__c='';
        jo.ODM_Status_Message__c='';
        jo.ODM_Pre_submit_Status__c='';
        insert jo;
         css_job_order__c jo1 = new css_job_order__c();
        JO1.Customer_Code__c='1234';
        JO1.Account__c = acc.id;
        jo1.Customer_Name__c='Gopal12';
        jo1.ESN__c='58765476';
        jo1.ODM_Status__c='';
        jo1.ODM_Status_Message__c='';
        jo1.ODM_Pre_submit_Status__c='';
        insert jo1;
        
       css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.id;
        sol.Name='Testing';
       insert sol;
        css_solution_Component__c solcomp = new css_solution_Component__c();
        solcomp.Solutions__c=sol.Id;
        solcomp.Service_Job__c=jo.Id;
        solcomp.Name='Testing';
        solcomp.ODM_Status__c='';
        solcomp.CSS_Claims__c=ManclaimsRec.Id;
        solcomp.pay_code__c='A';
        insert solcomp;
        
         Id recTypeIdpart =Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
         CSS_Parts_Options__c autoclaimPO1 =new CSS_Parts_Options__c();
        autoclaimPO1.RecordTypeId = recTypeIdpart;
        autoclaimPO1.Service_Job__c = JO.id;
        autoclaimPO1.ODM_Status__c = '';     
        autoclaimPO1.FailurepartId__c=solcomp.Id;
        autoclaimpo1.Solutions__c=sol.Id;
        autoclaimpo1.Parts_Type__c='Custom';
        autoclaimpo1.selected_part__c=TRUE;
        autoclaimpo1.CSS_Claims__c=ManclaimsRec.id;
        insert autoclaimPO1;
     
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Job_Order__c=jo.Id;
        srt.ODM_Status__c='';
        srt.CSS_Claims__c=ManclaimsRec.Id;
        srt.Account_Code__c = '61';
        insert srt;
        
        list<css_job_order__c> jolist=[Select id,ODM_Status__c,ODM_Status_Message__c,ODM_Pre_submit_Status__c from css_job_order__c];
     list<id> idlist = new list<id>();
        for(css_job_order__c jo2:jolist)
        {
        idlist.add(jo2.Id);
        }
        list<id> claims1 = new list<id>();
        claims1.add(ManclaimsRec.Id);
        test.startTest();
        CG_CL_UpdateallChildEntityODMStatus.updateODMStatusForChildEntity(idlist);
         CG_CL_UpdateallChildEntityODMStatus.updateODMStatusForChildEntity(claims1);
        test.stopTest();
    }
    static testmethod void testmethod4()
    {
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        Id recTypeIdpart =Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        css_claims__c claims2 = new css_claims__c();
        claims2.Customer_Code__c='123';
        claims2.Customer_Name__c='Gopal';
         claims2.ODM_Status__c='';
        claims2.ODM_Pre_submit_Status__c='';
        claims2.ODM_Status_Message__c='';
        insert claims2;
         css_claims__c claims3 = new css_claims__c();
        claims3.Customer_Code__c='1234';
        claims3.Customer_Name__c='Gopal1';
        claims3.ODM_Status__c='';
         claims3.ODM_Pre_submit_Status__c='';
        claims3.ODM_Status_Message__c='';
        insert claims3;
        list<id> id1 = new list<id>();
        id1.add(claims3.id);
        id1.add(claims2.Id);
        
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        insert sol;
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims2.Id;
        solcomp.Service_Job__c=jo.id;
        solcomp.Name='Testing';
        solcomp.Solutions__c=sol.Id;
        solcomp.ODM_Status__c='';
        insert solcomp;
         
        CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
        partop.Service_Job__c=jo.Id;
        partop.CSS_Claims__c=claims2.Id;
        partop.FailurepartId__c=solcomp.Id;
        partop.ODM_Status__c='';
        partop.RecordTypeId=recTypeIdpart;
        partop.Parts_Type__c='Custom';
        insert partop;
        
        test.startTest();
        CG_CL_UpdateallChildEntityODMStatus.updateODMStatusForChildEntity(id1);
        test.stopTest();
    }
   static testmethod void testmethod5()
    {
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        Id recTypeIdpart =Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        css_claims__c claims2 = new css_claims__c();
        claims2.Customer_Code__c='123';
        claims2.Customer_Name__c='Gopal';
         claims2.ODM_Status__c='';
        claims2.ODM_Pre_submit_Status__c='';
        claims2.ODM_Status_Message__c='';
        insert claims2;
         css_claims__c claims3 = new css_claims__c();
        claims3.Customer_Code__c='1234';
        claims3.Customer_Name__c='Gopal1';
        claims3.ODM_Status__c='';
         claims3.ODM_Pre_submit_Status__c='';
        claims3.ODM_Status_Message__c='';
        insert claims3;
        list<id> id1 = new list<id>();
        id1.add(claims3.id);
        id1.add(claims2.Id);
        
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        insert sol;
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims2.Id;
        solcomp.Service_Job__c=jo.id;
        solcomp.Name='Testing';
        solcomp.Solutions__c=sol.Id;
        solcomp.ODM_Status__c='';
        insert solcomp;
         
        CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
        partop.Service_Job__c=jo.Id;
        partop.CSS_Claims__c=claims2.Id;
        partop.FailurepartId__c=solcomp.Id;
        partop.ODM_Status__c='';
        partop.RecordTypeId=recTypeIdpart;
        partop.Parts_Type__c='Custom';
        partop.Account_Code__c='61';
        insert partop;
        
        test.startTest();
        CG_CL_UpdateallChildEntityODMStatus.updateODMStatusForChildEntity(id1);
        test.stopTest();
    }
}