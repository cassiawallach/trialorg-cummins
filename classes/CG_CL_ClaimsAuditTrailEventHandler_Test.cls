@IsTest
public class CG_CL_ClaimsAuditTrailEventHandler_Test {
    static testmethod void testmethod1()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        //css_claims__c claimsobj=css_testdata.createclaims(true,null);
        CSS_Claims__c claim = new CSS_Claims__c();
        
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        claim.Catastrophic__c = true;
        insert claim;
        
        /*claimsobj.Status__c='Submitted';
update claimsobj;
claimsobj.Pending_Authorization__c='Authorization Required';
update claimsobj;
claimsobj.Actual_Technician_Time__c=2.0;
update claimsobj;*/
        lstclm.add(claim);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Claims__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Add';
        aud.Field_Name__c = 'Catastrophic__c';
        aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
        aud.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_Claims__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        //boolean.value(claimHistory.Audit_Message__c);
        //claimHistory.Audit_Message__c = s;
        insert cssJH;
        
        CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);
        claim.Catastrophic__c = null;
        CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);
        aud.Field_Name__c = 'Status__c';
        CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);
        aud.Dynamic_Message__c = false;
        CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);
        /* aud.Field_Name__c = null;
claimHistory.CSS_New_Value__c = null;
claim.Catastrophic__c = null;
CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);*/
        /*aud.Field_Name__c = null;
claim.Status__c=null;
CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);*/
        /*aud.Dynamic_Message__c = false;
CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);
aud.Field_Name__c = null;
claim.Catastrophic__c = null;
CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);*/
    }
    static testmethod void testmethod18()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        claim.Catastrophic__c = true;
        insert claim;
        lstclm.add(claim);
        List<CSS_Solution_Component__c> newList = new List<CSS_Solution_Component__c> ();
        CSS_Solution_Component__c sc = new CSS_Solution_Component__c();
        sc.Name = 'test';
        sc.CSS_Claims__c = claim.id;
        sc.Selected_Component__c=false;
        sc.Type__c = 'Diagnosis';
        insert sc;
        newList.add(sc);
        CSS_Solution_Component__c sc1 = new CSS_Solution_Component__c();
        sc1.Name = 'test1';
        sc1.CSS_Claims__c = claim.id;
        sc1.Selected_Component__c=true;
        sc1.Type__c = 'Diagnosis';
        insert sc1;
        newList.add(sc1);
        List<CSS_Solution_Component__c> newsList = new List<CSS_Solution_Component__c> ();
        CSS_Solution_Component__c scs = new CSS_Solution_Component__c();
        scs.id = newList[0].id;
        scs.Name = 'test1';
        scs.CSS_Claims__c = claim.id;
        scs.Selected_Component__c=false;
        scs.Type__c = 'Diagnosis';
        update scs;
        newsList.add(scs);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Solution_Component__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Edit Add Delete';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
        aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        CG_Claim_Audit_Log__c aud1 = new CG_Claim_Audit_Log__c();
        aud1.Object_Name__c = 'CSS_Solution_Component__c';
        aud1.Name = 'Claim Status Edit';
        aud1.Action_Type__c = 'Edit Add Delete';
        aud1.Field_Name__c = 'Selected_Component__c';
        aud1.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
        aud1.Dynamic_Message__c = true;
        insert aud1;
        sudlist.add(aud1);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_Claims__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = null;
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert claimHistory;
        lstcssJH.add(claimHistory);
        test.startTest();
        CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);
        claim.Catastrophic__c = null;
        CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);
        //aud.Field_Name__c = 'Status__c';
        CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);
        //aud.Dynamic_Message__c = false;
        CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(lstclm,sudlist);
        CG_CL_ClaimsAuditTrailEventHandler.onInsertFC(newList, sudlist);
        Map<id,CSS_Solution_Component__c> oldMap = new Map<id,CSS_Solution_Component__c> ();
        oldMap.put(newList[0].id,sc);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdateFC(newsList,oldMap,sudlist);
		CG_CL_ClaimsAuditTrailEventHandler.onDeleteFC(newsList, sudlist);
        test.stopTest();
    }
   
    static testmethod void testmethod3()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        //css_claims__c claimsobj=css_testdata.createclaims(true,null);
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        CSS_Claims__c claim1 = new CSS_Claims__c();
        claim1.Customer_Name__c='PrabhuTrucks';
        claim1.Customer_Code__c='123';
        claim1.Status__c='Draft';
        claim1.Actual_Technician_Time__c=1.2;
        insert claim1;
        lstclm.add(claim1);
        lstclm.add(claim);
        List<CSS_Claims__c> lstclms = new List<CSS_Claims__c>();
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.id = lstclm[0].id;
        claims.Customer_Name__c='PrabhuTrucks';
        claims.Customer_Code__c='123';
        claims.Status__c='Submitted';
        claims.Actual_Technician_Time__c=1.2;
        update claims;
        //claims.Status__c='Submitted';
        //update claims; 
        lstclms.add(claims);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Claims__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Field Edit';
        aud.Field_Name__c = 'Status__c';
        aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
        aud.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud;
        CG_Claim_Audit_Log__c aud1 = new CG_Claim_Audit_Log__c();
        aud1.Object_Name__c = 'CSS_Claims__c';
        aud1.Name = 'Claim Status Edit';
        aud1.Action_Type__c = 'Field Edit';
        aud1.Field_Name__c = 'Actual_Technician_Time__c';
        aud1.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
        aud1.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud1;
        sudlist.add(aud1);
        sudlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_Claims__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        Map<id,CSS_Claims__c> mapclm = new Map<id,CSS_Claims__c>();
        mapclm.put(lstclm[0].id,claim);
        mapclm.put(lstclm[0].id,claim1);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdateClaim(lstclms,mapclm,sudlist);
    }
    static testmethod void testmethod4()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        //css_claims__c claimsobj=css_testdata.createclaims(true,null);
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_Claims__c> lstclms = new List<CSS_Claims__c>();
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.id = lstclm[0].id;
        claims.Customer_Name__c='PrabhuTrucks';
        claims.Customer_Code__c='123';
        claims.Status__c='Submitted';
        claims.Actual_Technician_Time__c=1.2;
        update claims;
        //claims.Status__c='Submitted';
        //update claims; 
        lstclms.add(claims);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Claims__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Field Edit';
        aud.Field_Name__c = 'Actual_Technician_Time__c';//'Status__c';
        aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
        aud.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_Claims__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'Blank';//'Status__c';
        claimHistory.CSS_Old_Value__c='Blank';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        Map<id,CSS_Claims__c> mapclm = new Map<id,CSS_Claims__c>();
        mapclm.put(lstclm[0].id,claim);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdateClaim(lstclms,mapclm,sudlist);
        
    }
    static testmethod void testmethod5()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        //css_claims__c claimsobj=css_testdata.createclaims(true,null);
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_Claims__c> lstclms = new List<CSS_Claims__c>();
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.id = lstclm[0].id;
        claims.Customer_Name__c='PrabhuTrucks';
        claims.Customer_Code__c='123';
        claims.Status__c='';
        claims.Actual_Technician_Time__c=1.2;
        update claims;
        //claims.Status__c='Submitted';
        //update claims; 
        lstclms.add(claims);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Claims__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Field Edit';
        aud.Field_Name__c = 'Status__c';//'test';
        aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
        aud.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_Claims__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'Status__c';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        Map<id,CSS_Claims__c> mapclm = new Map<id,CSS_Claims__c>();
        mapclm.put(lstclm[0].id,claim);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdateClaim(lstclms,mapclm,sudlist);
    }
    static testmethod void testmethodinserpsn()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = '79464646';
        psnObj.Primary__c = false;
        psnObj.CSS_Claims__c = lstclm[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = null;//date.today() +6 ;
        psnObj.Before_In_Service__c=true;
        psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = '79464646';
        psnObj1.Primary__c = true;
        psnObj1.CSS_Claims__c = lstclm[0].id;
        psnObj1.Service_Model__c = 'ISBE CM800';
        psnObj1.Failure_Date__c = null;//date.today() +6 ;
        psnObj1.Before_In_Service__c=true;
        psnObj1.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj1);
        
        
        List<CG_Claim_Audit_Log__c>audlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_PSN__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Add';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Added additional PSN <b> newValue </b>';
        aud.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud;
        audlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        insert cssJH;
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = psnList[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
        claimHistory.CSS_Field_Name__c = audlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(audlist[0].Dynamic_Message__c);
        
        CG_CL_ClaimsAuditTrailEventHandler.onInsertPSN(psnList,audlist);
    }
    static testmethod void testmethodinserpsn1()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = '79464646';
        psnObj.Primary__c = false;
        psnObj.CSS_Claims__c = lstclm[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = null;//date.today() +6 ;
        psnObj.Before_In_Service__c=true;
        psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        
        
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>audlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_PSN__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Add';
        aud.Field_Name__c = 'PSN__c';
        aud.Message__c = 'Added additional PSN <b> newValue </b>';
        aud.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud;
        audlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = psnList[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
        claimHistory.CSS_Field_Name__c = audlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(audlist[0].Dynamic_Message__c);
        insert cssJH;
        CG_CL_ClaimsAuditTrailEventHandler.onInsertPSN(psnList,audlist);
    }
    static testmethod void testmethodinserpsn2()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = '79464646';
        psnObj.Primary__c = false;
        psnObj.CSS_Claims__c = lstclm[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = null;//date.today() +6 ;
        psnObj.Before_In_Service__c=true;
        psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        
        
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>audlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_PSN__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Add';
        aud.Field_Name__c = 'PSN__c';
        aud.Message__c = 'Added additional PSN <b> newValue </b>';
        aud.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud;
        audlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = psnList[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
        claimHistory.CSS_Field_Name__c = audlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(audlist[0].Dynamic_Message__c);
        insert cssJH;
        CG_CL_ClaimsAuditTrailEventHandler.onInsertPSN(psnList,audlist);
    }
    static testmethod void testmethodonUpdatePSNmethod()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        List<CSS_PSN__c> psnListmap = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = '79464646';
        psnObj.Primary__c = false;
        psnObj.CSS_Claims__c = lstclm[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = null;//date.today() +6 ;
        psnObj.Before_In_Service__c=true;
        psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = '79464647';
        psnObj1.id = psnList[0].id;
        update psnObj1;
        psnListmap.add(psnObj1);
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_PSN__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Field Edit';
        aud.Field_Name__c = 'PSN__c';
        aud.Message__c = 'Added additional PSN <b> newValue </b>';
        aud.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        CG_Claim_Audit_Log__c aud1 = new CG_Claim_Audit_Log__c();
        aud1.Object_Name__c = 'CSS_Claims__c';
        aud1.Name = 'Claim Status Edit';
        aud1.Action_Type__c = 'Field Edit';
        aud1.Field_Name__c = 'PSN__c';
        aud1.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
        aud1.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud1;
        sudlist.add(aud1);
        
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        Map<id,CSS_PSN__c> mapclm = new Map<id,CSS_PSN__c>();
        mapclm.put(psnListmap[0].id,psnObj1);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatePSN(psnList,mapclm,sudlist);
    }
    static testmethod void testmethodonUpdatePSNmethod1()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        List<CSS_PSN__c> psnListmap = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = '';
        psnObj.Primary__c = false;
        psnObj.CSS_Claims__c = lstclm[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = null;//date.today() +6 ;
        psnObj.Before_In_Service__c=true;
        psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = '79464647';
        psnObj1.id = psnList[0].id;
        update psnObj1;
        psnListmap.add(psnObj1);
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_PSN__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Field Edit';
        aud.Field_Name__c = 'Date';
        //aud.Field_Name__c = 'PSN__c';
        aud.Message__c = 'Added additional PSN <b> newValue </b>';
        aud.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        CG_Claim_Audit_Log__c aud1 = new CG_Claim_Audit_Log__c();
        aud1.Object_Name__c = 'CSS_PSN__c';
        aud1.Name = 'Claim Status Edit';
        aud1.Action_Type__c = 'Field Edit';
        //aud1.Field_Name__c = 'Date';
        aud.Field_Name__c = 'PSN__c';
        aud1.Message__c = 'Added additional PSN <b> newValue </b>';
        aud1.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud1;
        sudlist.add(aud1);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        Map<id,CSS_PSN__c> mapclm = new Map<id,CSS_PSN__c>();
        mapclm.put(psnListmap[0].id,psnObj1);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatePSN(psnList,mapclm,sudlist);
    }
    static testmethod void testmethodonUpdatePSNmethod11()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        List<CSS_PSN__c> psnListmap = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = '';
        psnObj.Primary__c = false;
        psnObj.CSS_Claims__c = lstclm[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = date.today() +6 ;
        psnObj.Before_In_Service__c=true;
        psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = '79464647';
        psnObj1.id = psnList[0].id;
        psnObj1.Failure_Date__c = date.today();
        update psnObj1;
        psnListmap.add(psnObj1);
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_PSN__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Field Edit';
        aud.Field_Name__c = 'Failure_Date__c';
        //aud.Field_Name__c = 'PSN__c';
        aud.Message__c = 'Added additional PSN <b> newValue </b>';
        aud.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        Map<id,CSS_PSN__c> mapclm = new Map<id,CSS_PSN__c>();
        mapclm.put(psnListmap[0].id,psnObj1);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatePSN(psnList,mapclm,sudlist);
    }
    static testmethod void onDeletePSN()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        List<CSS_PSN__c> psnListmap = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = '79464647';
        psnObj.Primary__c = false;
        psnObj.CSS_Claims__c = lstclm[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = null;//date.today() +6 ;
        psnObj.Before_In_Service__c=true;
        psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = '79464647';
        psnObj1.id = psnList[0].id;
        delete psnObj1;
        psnListmap.add(psnObj1);
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_PSN__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Delete';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Added additional PSN <b> newValue </b>';
        aud.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        Map<id,CSS_PSN__c> mapclm = new Map<id,CSS_PSN__c>();
        mapclm.put(psnListmap[0].id,psnObj1);
        CG_CL_ClaimsAuditTrailEventHandler.onDeletePSN(psnList,sudlist);
    }
    static testmethod void onDeletePSN1()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        List<CSS_PSN__c> psnListmap = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = '79464647';
        psnObj.Primary__c = false;
        psnObj.CSS_Claims__c = lstclm[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = null;//date.today() +6 ;
        psnObj.Before_In_Service__c=true;
        psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = '79464647';
        psnObj1.id = psnList[0].id;
        delete psnObj1;
        psnListmap.add(psnObj1);
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_PSN__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Delete';
        aud.Field_Name__c = 'PSN__c';
        aud.Message__c = 'Added additional PSN <b> newValue </b>';
        aud.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        Map<id,CSS_PSN__c> mapclm = new Map<id,CSS_PSN__c>();
        mapclm.put(psnListmap[0].id,psnObj1);
        CG_CL_ClaimsAuditTrailEventHandler.onDeletePSN(psnList,sudlist);
    }
    static testmethod void onDeletePSN2()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        List<CSS_PSN__c> psnListmap = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = '79464647';
        psnObj.Primary__c = true;
        psnObj.CSS_Claims__c = lstclm[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = null;//date.today() +6 ;
        psnObj.Before_In_Service__c=true;
        psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = '79464647';
        psnObj1.id = psnList[0].id;
        delete psnObj1;
        psnListmap.add(psnObj1);
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_PSN__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Delete';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Added additional PSN <b> newValue </b>';
        aud.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        Map<id,CSS_PSN__c> mapclm = new Map<id,CSS_PSN__c>();
        mapclm.put(psnListmap[0].id,psnObj1);
        CG_CL_ClaimsAuditTrailEventHandler.onDeletePSN(psnList,sudlist);
    }
    static testmethod void onDeletePSN3()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>();
        List<CSS_PSN__c> psnListmap = new List<CSS_PSN__c>();
        CSS_PSN__c psnObj = new CSS_PSN__c();
        psnObj.name = 'TestPSN';
        psnObj.PSN__c = '79464647';
        psnObj.Primary__c = false;
        psnObj.CSS_Claims__c = lstclm[0].id;
        psnObj.Service_Model__c = 'ISBE CM800';
        psnObj.Failure_Date__c = null;//date.today() +6 ;
        psnObj.Before_In_Service__c=true;
        psnObj.Warranty_Start_Date__c=date.today() -6 ;
        psnList.add(psnObj);
        insert psnList;
        CSS_PSN__c psnObj1 = new CSS_PSN__c();
        psnObj1.name = 'TestPSN';
        psnObj1.PSN__c = '79464647';
        psnObj1.id = psnList[0].id;
        delete psnObj1;
        psnListmap.add(psnObj1);
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_PSN__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Delete';
        aud.Field_Name__c = 'PSN__c';
        aud.Message__c = 'Added additional PSN <b> newValue </b>';
        aud.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_PSN__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        Map<id,CSS_PSN__c> mapclm = new Map<id,CSS_PSN__c>();
        mapclm.put(psnListmap[0].id,psnObj1);
        CG_CL_ClaimsAuditTrailEventHandler.onDeletePSN(psnList,sudlist);
    }
    
    static testmethod void onInsertSRTtest()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        //List<CSS_Solution_Component__c> newList = new List<CSS_Solution_Component__c> ();
        CSS_Solution_Component__c sc = new CSS_Solution_Component__c();
        sc.Name = 'test';
        //sc.CSS_Claims__c = claim.id;
        sc.Type__c = 'Diagnosis';
        insert sc;
        // newList.add(sc);
        CSS_Solution_Component__c sc1 = new CSS_Solution_Component__c();
        sc1.Name = 'test1';
        //sc1.CSS_Claims__c = claim.id;
        sc1.Type__c = 'Diagnosis';
        insert sc1;
        //newList.add(sc1);
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        claim.CSS_Job__c=JO.id;
        insert claim;
        lstclm.add(claim);
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        //claimsSub.Claim_Number__c= claimsObj.name;
        //claimsSub.CSS_Claims__c=lstclm[0].id;        
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.name = 'sub';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Submitted';
        //claimsSub1.Claim_Number__c= claimsObj.name;
        //claimsSub1.CSS_Claims__c=lstclm[0].id;        
        submID.add(claimsSub1);
        insert submID;
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Claim_Submission__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Edit Add';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Created Claim Submission.';
        aud.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud;
        CG_Claim_Audit_Log__c aud1 = new CG_Claim_Audit_Log__c();
        aud1.Object_Name__c = 'CSS_SRT__c';
        aud1.Name = 'Claim Status Edit';
        aud1.Action_Type__c = 'Edit Add';
        aud1.Field_Name__c = 'Name';
        aud1.Message__c = 'Created Claim Submission.';
        aud1.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud1;
        sudlist.add(aud1);
        sudlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = submID[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_Claim_Submission__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        List<CSS_SRT__c> newList = new List<CSS_SRT__c>();
        CSS_SRT__c newsList = new CSS_SRT__c();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
        srt.FailCode__c='THAC';
        srt.Type__c='Repair';
        srt.CSS_Claims__c=claim.Id;
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
        srt1.FailCode__c='THAC';
        srt1.Type__c='Repair';
        srt1.CSS_Claims__c=claim.Id;
        
        newList.add(srt1);
        newList.add(srt);
        newList.add(newsList);
        CG_CL_ClaimsAuditTrailEventHandler.onInsertSRT( newList,sudlist);
    }
    static testmethod void onUpdateSRTtest()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        //claimsSub.Claim_Number__c= claimsObj.name;
        claimsSub.CSS_Claims__c=lstclm[0].id;        
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.name = 'sub';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Submitted';
        //claimsSub1.Claim_Number__c= claimsObj.name;
        claimsSub1.CSS_Claims__c=lstclm[0].id;        
        submID.add(claimsSub1);
        insert submID;
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_SRT__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Edit';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Created Claim Submission.';
        //aud.Dynamic_Message__c = false;
        aud.Dynamic_Message__c = true;
        insert aud;
        CG_Claim_Audit_Log__c aud1 = new CG_Claim_Audit_Log__c();
        aud1.Object_Name__c = 'CSS_Claim_Submission__c';
        aud1.Name = 'Claim Status Edit';
        aud1.Action_Type__c = 'Edit';
        aud1.Field_Name__c = 'Name';
        aud1.Message__c = 'Created Claim Submission.';
        aud1.Dynamic_Message__c = false;
        //aud.Dynamic_Message__c = true;
        insert aud1;
        sudlist.add(aud);
        claimsAuditLst.add(aud);
        claimsAuditLst.add(aud1);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = submID[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_SRT__c';
        claimHistory.CSS_Field_Name__c = claimsAuditLst[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(claimsAuditLst[0].Dynamic_Message__c);
        insert claimHistory;
        
        List<CSS_SRT__c> newList = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.name='test';
        srt.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
        srt.FailCode__c='THAC';
        srt.Type__c='Repair';
        srt.CSS_Claims__c=claim.Id;
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt.name='test1';
        srt1.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
        srt1.FailCode__c='THAC';
        srt1.Type__c='Repair';
        srt1.CSS_Claims__c=claim.Id;
        // insert srt1;
        //  insert srt;
        newList.add(srt);
        newList.add(srt1);
        List<CSS_SRT__c> newsList = new List<CSS_SRT__c>();
        CSS_SRT__c srts = new CSS_SRT__c();
        srts.id = newList[0].id;
        //srts.
        // update srts;
        newsList.add(srts);
        Map<id,CSS_SRT__c> oldMap = new Map<id,CSS_SRT__c>();
        oldMap.put(newList[0].id,srts);
        system.debug('***oldMap***'+oldMap);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdateSRT(newList,oldMap,claimsAuditLst);
    }
    
    static testmethod void onDeleteSRTtest()
    {
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        //claimsSub.Claim_Number__c= claimsObj.name;
        claimsSub.CSS_Claims__c=lstclm[0].id;        
        submID.add(claimsSub);
        CSS_Claim_Submission__c claimsSub1 = new CSS_Claim_Submission__c();
        claimsSub1.Type__c = 'ytes';
        claimsSub1.name = 'sub';
        claimsSub1.Rejection_Reason__c='test';
        claimsSub1.Status__c= 'Submitted';
        //claimsSub1.Claim_Number__c= claimsObj.name;
        claimsSub1.CSS_Claims__c=lstclm[0].id;        
        submID.add(claimsSub1);
        insert submID;
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_SRT__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Add Delete';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Created Claim Submission.';
        aud.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = submID[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_Claim_Submission__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        insert cssJH;
        List<CSS_SRT__c> newList = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.name='test';
        srt.isPerformed__c=true;
        srt.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
        srt.FailCode__c='THAC';
        srt.Type__c='Repair';
        srt.CSS_Claims__c=claim.Id;
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.name='test1';
        srt1.isPerformed__c=true;
        srt1.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
        srt1.FailCode__c='THAC';
        srt1.Type__c='Repair';
        srt1.CSS_Claims__c=claim.Id;
        // insert srt1;
        // insert srt;
        newList.add(srt);
        newList.add(srt1);
        CG_CL_ClaimsAuditTrailEventHandler.onDeleteSRT( newList,sudlist);
    }
    static testmethod void onInsertPOCtest()
    {
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        List<CSS_Parts_Options__c> newList = new List<CSS_Parts_Options__c>();
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        CSS_Parts_Options__c prtopsn = new CSS_Parts_Options__c();
        prtopsn.Name = 'test';
        prtopsn.RecordTypeId=recTypeIdOC;
        prtopsn.CSS_Claims__c = claim.id;
        insert prtopsn;
        newList.add(prtopsn);
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Parts_Options__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Add Delete';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Created Claim Submission.';
        aud.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        CG_Claim_Audit_Log__c aud1 = new CG_Claim_Audit_Log__c();
        aud1.Object_Name__c = 'CSS_Parts_Options__c';
        aud1.Name = 'Claim Status Edit';
        aud1.Action_Type__c = 'Event Add Delete';
        aud1.Field_Name__c = 'N1ame';
        aud1.Message__c = 'Created Claim Submission.';
        aud1.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud1;
        sudlist.add(aud1);
        CG_CL_ClaimsAuditTrailEventHandler.onInsertPOC(newList, sudlist); 
    }
    static testmethod void onInsertPOCtest1()
    {
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        List<CSS_Parts_Options__c> newList = new List<CSS_Parts_Options__c>();
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        CSS_Parts_Options__c prtopsn = new CSS_Parts_Options__c();
        prtopsn.Name = 'test';
        prtopsn.RecordTypeId=recTypeIdOC;
        prtopsn.CSS_Claims__c = claim.id;
        insert prtopsn;
        newList.add(prtopsn);
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Parts_Options__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Add Delete';
        aud.Field_Name__c = 'Name1';
        aud.Message__c = 'Created Claim Submission.';
        aud.Dynamic_Message__c = true;
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        test.startTest();
        CG_CL_ClaimsAuditTrailEventHandler.onInsertPOC(newList, sudlist); 
        test.stopTest();
    }
    static testmethod void onUpdatePOCtest()
    {
        CSS_Claims__c claim = new CSS_Claims__c();
        CSS_job_order__c job = new css_job_order__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        List<CSS_Parts_Options__c> newList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtopsn = new CSS_Parts_Options__c();
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        
        prtopsn.Name = 'test';
        prtopsn.RecordTypeId=recTypeIdpart;
        prtopsn.selected_part__c = true;
        prtopsn.CSS_Claims__c = claim.id;
        prtopsn.Service_Job__c = job.id;
        insert prtopsn;
        newList.add(prtopsn);
        CSS_Parts_Options__c prtopsn1 = new CSS_Parts_Options__c();
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        prtopsn1.RecordTypeId=recTypeIdOC;
        prtopsn1.Name = 'te1st';
        prtopsn1.selected_part__c = false;
        prtopsn1.CSS_Claims__c = claim.id;
        insert prtopsn1;
        newList.add(prtopsn1);
        List<CSS_Parts_Options__c> newsList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtsopsn = new CSS_Parts_Options__c();
        prtsopsn.id = newList[0].id;
        prtsopsn.selected_part__c = false;
        prtsopsn.Name = 'test';
        update prtsopsn;
        newsList.add(prtsopsn);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Parts_Options__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Delete Edit';
        aud.Field_Name__c = 'selected_part__c';
        aud.Message__c = 'Created Claim Submission.';
        aud.Dynamic_Message__c = true;
        aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        Map<id,CSS_Parts_Options__c> oldMap = new Map<id,CSS_Parts_Options__c> ();
        oldMap.put(newsList[0].id,prtsopsn);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatePOC(newList,oldMap,sudlist);
    }
    static testmethod void onDeletePOCtest()
    {
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        List<CSS_Parts_Options__c> newList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtopsn = new CSS_Parts_Options__c();
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        prtopsn.Parts_Type__c = 'Custom';
        
        prtopsn.Name = 'test';
        prtopsn.RecordTypeId=recTypeIdpart;
        prtopsn.selected_part__c = true;
        prtopsn.CSS_Claims__c = claim.id;
        insert prtopsn;
        newList.add(prtopsn);
        CSS_Parts_Options__c prtopsn1 = new CSS_Parts_Options__c();
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        prtopsn1.Parts_Type__c = 'Custom';
        
        prtopsn1.Name = 'test';
        prtopsn1.RecordTypeId=recTypeIdpart1;
        prtopsn1.selected_part__c = true;
        prtopsn1.CSS_Claims__c = claim.id;
        insert prtopsn1;
        newList.add(prtopsn1);
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Parts_Options__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Delete Edit';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Created Claim Submission.';
        aud.Dynamic_Message__c = true;
        aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        CG_CL_ClaimsAuditTrailEventHandler.onDeletePOC(newList,sudlist);
    }
    static testmethod void onauditTrailtest(){
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        List<CSS_SymptomQA__c>newsymlist = new List<CSS_SymptomQA__c>();
        CSS_SymptomQA__c sym = new CSS_SymptomQA__c();
        sym.Name = '2636';
        sym.Job_Order__c = SerRec.id;
        insert sym;
        CSS_SymptomQA__c sym1 = new CSS_SymptomQA__c();
        sym1.Name = '559';
        sym1.Job_Order__c = SerRec.id;
        insert sym1;
        newsymlist.add(sym1);
        newsymlist.add(sym);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_SymptomQA__c';
        aud.Name = 'Symptom FaultCode search';
        aud.Action_Type__c = 'Event Add';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Searched Fault Code/Symptom: <b>samplecode</b>';
        aud.isServicejob__c = true;
       // aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = SerRec.Id;
        cssJH.CSS_Object_Name__c = 'CSS_SymptomQA__c';
        cssJH.CSS_Field_Name__c = 'Name';
        cssJH.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        //boolean.value(claimHistory.Audit_Message__c);
        //claimHistory.Audit_Message__c = s;
        insert cssJH;
        CG_CL_ClaimsAuditTrailEventHandler.onInsertSymtomQA(newsymlist,sudlist);
    }
    static testmethod void onauditTrailtestFaultcode(){
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        List<CSS_Fault_Code__c>newsymlist = new List<CSS_Fault_Code__c>();
        CSS_Fault_Code__c sym = new CSS_Fault_Code__c();
        sym.Name = '2636';
        sym.Job_Order__c = SerRec.id;
        insert sym;
        CSS_Fault_Code__c sym1 = new CSS_Fault_Code__c();
        sym1.Name = '559';
        sym1.Job_Order__c = SerRec.id;
        insert sym1;
        newsymlist.add(sym1);
        newsymlist.add(sym);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Fault_Code__c';
        aud.Name = 'Symptom FaultCode search';
        aud.Action_Type__c = 'Event Add';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Searched Fault Code/Symptom: <b>samplecode</b>';
        aud.isServicejob__c = true;
       // aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = SerRec.Id;
        cssJH.CSS_Object_Name__c = 'CSS_Fault_Code__c';
        cssJH.CSS_Field_Name__c = 'Name';
        cssJH.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        //boolean.value(claimHistory.Audit_Message__c);
        //claimHistory.Audit_Message__c = s;
        insert cssJH;
        CG_CL_ClaimsAuditTrailEventHandler.onInsertFaultcode(newsymlist,sudlist);
    }
    static testmethod void onauditTrailSRTinsert(){
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,SerRec.ID);
       /// sol.Diagnostic_Response__c = 'Most likely the solution.';
       // insert sol;
        List<CSS_SRT__c>lstsrt = new List<CSS_SRT__c>();
        CSS_SRT__c srts = new CSS_SRT__c();
        srts.Job_Order__c=SerRec.id;
        srts.SRT_AccessiblityCheck__c=true;
        srts.Solution_Number__c = sol.id;
        srts.SRT_ID__c = '903';
        srts.SRT_Quantity__c = 10;
        srts.Type__c = 'AccessSRT';
       // insert srts;
        //srts.SRT_Quantity__c = 20;
       // update srts;
        lstsrt.add(srts);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_SRT__c';
        aud.Name = 'Symptom FaultCode search';
        aud.Action_Type__c = 'Event Add';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Searched Fault Code/Symptom: <b>samplecode</b>';
        aud.isServicejob__c = true;
       // aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = SerRec.Id;
        cssJH.CSS_Object_Name__c = 'CSS_SRT__c';
        cssJH.CSS_Field_Name__c = 'Name';
        cssJH.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        //boolean.value(claimHistory.Audit_Message__c);
        //claimHistory.Audit_Message__c = s;
        insert cssJH;
        CG_CL_ClaimsAuditTrailEventHandler.onInsertaccessSRT(lstsrt);
        CG_CL_ClaimsAuditTrailEventHandler.onDeleteacessSRT(lstsrt);
        
    }
    static testmethod void onauditTrailSRTupdate(){
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,SerRec.ID);
       /// sol.Diagnostic_Response__c = 'Most likely the solution.';
       // insert sol;
       List<CSS_SRT__c>oldlstsrt = new List<CSS_SRT__c>();
        CSS_SRT__c srts1 = new CSS_SRT__c();
        srts1.Job_Order__c=SerRec.id;
        srts1.SRT_AccessiblityCheck__c=true;
        srts1.Solution_Number__c = sol.id;
        srts1.SRT_ID__c = '903';
        srts1.SRT_Quantity__c = 20;
        srts1.Type__c = 'AccessSRT';
        oldlstsrt.add(srts1);
         Map<id,CSS_SRT__c> oldMap = new Map<id,CSS_SRT__c>();
        oldMap.put(oldlstsrt[0].id,srts1);
        List<CSS_SRT__c>lstsrt = new List<CSS_SRT__c>();
        CSS_SRT__c srts = new CSS_SRT__c();
        srts.Job_Order__c=SerRec.id;
        srts.SRT_AccessiblityCheck__c=true;
        srts.Solution_Number__c = sol.id;
        srts.SRT_ID__c = '903';
        srts.SRT_Quantity__c = 10;
        srts.Type__c = 'AccessSRT';
       // insert srts;
        //srts.SRT_Quantity__c = 20;
       // update srts;
        lstsrt.add(srts);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_SRT__c';
        aud.Name = 'Symptom FaultCode search';
        aud.Action_Type__c = 'Event Add';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Searched Fault Code/Symptom: <b>samplecode</b>';
        aud.isServicejob__c = true;
       // aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = SerRec.Id;
        cssJH.CSS_Object_Name__c = 'CSS_SRT__c';
        cssJH.CSS_Field_Name__c = 'Name';
        cssJH.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        //boolean.value(claimHistory.Audit_Message__c);
        //claimHistory.Audit_Message__c = s;
        insert cssJH;
        CG_CL_ClaimsAuditTrailEventHandler.onUpdateaccessSRT(lstsrt,oldMap);
        
    }
    static testmethod void onupdatesolutionmethod(){
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,SerRec.ID);
        List<CSS_Solutions__c>oldlstsrt = new List<CSS_Solutions__c>();
        CSS_Solutions__c srts1 = new CSS_Solutions__c();
        srts1.Service_Job__c=SerRec.id;
        srts1.Diagnostic_Response__c='Most likely the solution';
      //  srts1.Solution_Number__c = sol.id;
       // srts1.SRT_ID__c = '903';
       // srts1.SRT_Quantity__c = 20;
       // srts1.Type__c = 'AccessSRT';
        oldlstsrt.add(srts1);
         Map<id,CSS_Solutions__c> oldMap = new Map<id,CSS_Solutions__c>();
        oldMap.put(oldlstsrt[0].id,srts1);
        List<CSS_Solutions__c>lstsrt = new List<CSS_Solutions__c>();
        CSS_Solutions__c srts = new CSS_Solutions__c();
        srts.Service_Job__c=SerRec.id;
        srts.Diagnostic_Response__c='Not the solution';
        srts.Rank__c = 1;
        srts.Solution_Title__c = 'Check for primary fault codes';
        srts.Name = 'S00000200';
       // srts.Diagnostic_notes__c = 'diagnotes';
        lstsrt.add(srts);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Solutions__c';
        aud.Name = 'Symptom FaultCode search';
        aud.Action_Type__c = 'Event Add';
        aud.Field_Name__c = 'Diagnostic_Response__c';
        //aud.Field_Name__c = 'Diagnostic_notes__c';
        
        aud.Message__c = 'Searched Fault Code/Symptom: <b>samplecode</b>';
        aud.isServicejob__c = true;
       // aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = SerRec.Id;
        cssJH.CSS_Object_Name__c = 'CSS_Solutions__c';
        cssJH.CSS_Field_Name__c = 'Name';
        cssJH.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        //boolean.value(claimHistory.Audit_Message__c);
        //claimHistory.Audit_Message__c = s;
        insert cssJH;
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);
        
        
    }
     static testmethod void onupdatesolutionmethod1(){
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,SerRec.ID);
        List<CSS_Solutions__c>oldlstsrt = new List<CSS_Solutions__c>();
        CSS_Solutions__c srts1 = new CSS_Solutions__c();
        srts1.Service_Job__c=SerRec.id;
        srts1.Diagnostic_Response__c='Most likely the solution';
      //  srts1.Solution_Number__c = sol.id;
       // srts1.SRT_ID__c = '903';
       // srts1.SRT_Quantity__c = 20;
       // srts1.Type__c = 'AccessSRT';
        oldlstsrt.add(srts1);
         Map<id,CSS_Solutions__c> oldMap = new Map<id,CSS_Solutions__c>();
        oldMap.put(oldlstsrt[0].id,srts1);
        List<CSS_Solutions__c>lstsrt = new List<CSS_Solutions__c>();
        CSS_Solutions__c srts = new CSS_Solutions__c();
        srts.Service_Job__c=SerRec.id;
       // srts.Diagnostic_Response__c='Not the solution';
        srts.Rank__c = 1;
        srts.Diagnostic_notes__c = 'diagnotes';
        srts.Solution_Title__c = 'Check for primary fault codes';
        srts.Name = 'S00000200';
        lstsrt.add(srts);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Solutions__c';
        aud.Name = 'Symptom FaultCode search';
        aud.Action_Type__c = 'Event Add';
        //aud.Field_Name__c = 'Diagnostic_Response__c';
        aud.Field_Name__c = 'Diagnostic_notes__c';
        
        aud.Message__c = 'Searched Fault Code';
        aud.isServicejob__c = true;
       // aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        //insert aud;
        sudlist.add(aud);
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = SerRec.Id;
        cssJH.CSS_Object_Name__c = 'CSS_Solutions__c';
        cssJH.CSS_Field_Name__c = 'Name';
        cssJH.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        //boolean.value(claimHistory.Audit_Message__c);
        //claimHistory.Audit_Message__c = s;
        insert cssJH;
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);
              srts1.Diagnostic_notes__c='Most likely the solution';
             oldlstsrt.add(srts1);
         //Map<id,CSS_Solutions__c> oldMap = new Map<id,CSS_Solutions__c>();
        oldMap.put(oldlstsrt[0].id,srts1);
             aud.Action_Type__c = 'Edit';
            sudlist.add(aud);
            CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);
         
          aud.Field_Name__c = 'Diagnostic_Response__c';
            sudlist.add(aud);
            CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);
         
         aud.Field_Name__c = 'Repair_Response__c';
            sudlist.add(aud);
            CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);
         
         aud.Field_Name__c = 'Repair_Notes__c';
            sudlist.add(aud);
            CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);
       
        
    }
    
    static testmethod void onPartsUpdateTest()
    {
        CSS_Claims__c claim = new CSS_Claims__c();
        CSS_job_order__c job =  CSS_TestData.createJobOrder(true);
        claim.Customer_Name__c='PrabhuTrucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Submitted';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        
       // List<CSS_Solutions__c>oldlstSol = new List<CSS_Solutions__c>();
        CSS_Solutions__c solution = new CSS_Solutions__c();
        solution.Service_Job__c=job.id;
        solution.Diagnostic_Response__c='Most likely the solution';
        solution.Rank__c = 1;
        insert solution;
     // oldlstSol.add(so1ution);
        
        List<CSS_Parts_Options__c> newList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtopsn = new CSS_Parts_Options__c();
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
        
        
        prtopsn.Name = 'test';
        prtopsn.RecordTypeId=recTypeIdpart;
        prtopsn.selected_part__c = true;
        prtopsn.CSS_Claims__c = claim.id;
        prtopsn.Service_Job__c = job.id;
        prtopsn.Solutions__c = solution.id;
        prtopsn.Quantity__c =5;
        prtopsn.Replacement_Reason__c = 'TestReason';
        insert prtopsn;
        newList.add(prtopsn);
        CSS_Parts_Options__c prtopsn1 = new CSS_Parts_Options__c();
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        prtopsn1.RecordTypeId=recTypeIdOC;
        prtopsn1.Name = 'te1st';
        prtopsn1.selected_part__c = false;
        prtopsn1.CSS_Claims__c = claim.id;
        insert prtopsn1;
        newList.add(prtopsn1);
        List<CSS_Parts_Options__c> oldMapnewsList = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtsopsn = new CSS_Parts_Options__c();
        prtsopsn.id = newList[0].id;
        prtsopsn.selected_part__c = false;
        prtsopsn.Name = 'test';
        prtsopsn.Quantity__c =2;
        prtsopsn.Replacement_Reason__c = 'old part TestReason';
        update prtsopsn;
        oldMapnewsList.add(prtsopsn);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Parts_Options__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Event Delete Edit';
        aud.Field_Name__c = 'selected_part__c';
        aud.Message__c = 'Created Claim Submission.';
        aud.Dynamic_Message__c = true;
        aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        
         CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = Job.Id;
        cssJH.CSS_Object_Name__c = 'CSS_Parts_Options__c';
        cssJH.CSS_Field_Name__c = 'Name';
        cssJH.CSS_New_Value__c = 'test';
        cssJH.Audit_Message__c = 'Parts changed the Audit tmessage';
       insert cssJH;
        
        Map<id,CSS_Parts_Options__c> oldMap = new Map<id,CSS_Parts_Options__c> ();
        oldMap.put(oldMapnewsList[0].id,prtsopsn);
        CG_CL_ClaimsAuditTrailEventHandler.onPartsUpdate(newList,oldMap,sudlist);
    }
    
    /* static testmethod void testmethod118()
     {
        CSS_job_order__c job =  CSS_TestData.createJobOrder(true);
        List<CSS_Claims__c> lstclm = new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Customer_Name__c='trucks';
        claim.Customer_Code__c='123';
        claim.Status__c='Draft';
        claim.Actual_Technician_Time__c=1.2;
        insert claim;
        lstclm.add(claim);
        
        CSS_Solutions__c solution = new CSS_Solutions__c();
        solution.Service_Job__c=job.id;
        solution.Diagnostic_Response__c='Most likely the solution';
        solution.Rank__c = 1;
        insert solution;
        
        
        List<CSS_Solution_Component__c> newList = new List<CSS_Solution_Component__c> ();
        CSS_Solution_Component__c sc = new CSS_Solution_Component__c();
        sc.Name = 'test';
        sc.CSS_Claims__c = claim.id;
        sc.Selected_Component__c=true;
        sc.Type__c = 'Diagnosis';
       // sc.Solutions__c = solution.id;
       // insert sc;
        newList.add(sc);
        
        List<CSS_Solution_Component__c> newsList = new List<CSS_Solution_Component__c> ();
        CSS_Solution_Component__c scs = new CSS_Solution_Component__c();
        scs.id = newsList[0].id;
        scs.Name = 'test1';
        scs.CSS_Claims__c = claim.id;
        scs.Selected_Component__c=false;
        scs.Type__c = 'Diagnosis';
       // scs.Solutions__c = solution.id;
       // update scs;
        newsList.add(scs);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Solution_Component__c';
        aud.Name = 'Claim Status Edit';
        aud.Action_Type__c = 'Edit Add Delete';
        aud.Field_Name__c = 'Name';
        aud.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
        aud.Dynamic_Message__c = true;
        insert aud;
        sudlist.add(aud);
        CG_Claim_Audit_Log__c aud1 = new CG_Claim_Audit_Log__c();
        aud1.Object_Name__c = 'CSS_Solution_Component__c';
        aud1.Name = 'Claim Status Edit';
        aud1.Action_Type__c = 'Edit Add Delete';
        aud1.Field_Name__c = 'Selected_Component__c';
        aud1.Message__c = 'Changed Status from <b> oldValue </b> to <b> newValue </b>';
        aud1.Dynamic_Message__c = true;
        insert aud1;
        sudlist.add(aud1);
        List<CSS_JobHistory__c> lstcssJH = new List<CSS_JobHistory__c>();
        CSS_JobHistory__c claimHistory = new CSS_JobHistory__c();
        claimHistory.CSS_Job_Id__c = lstclm[0].Id;
        claimHistory.CSS_Object_Name__c = 'CSS_Claims__c';
        claimHistory.CSS_Field_Name__c = sudlist[0].Field_Name__c;
        claimHistory.CSS_New_Value__c = null;
        claimHistory.Audit_Message__c = 'Parts changed the Audit tmessage';
        insert claimHistory;
        lstcssJH.add(claimHistory);
        
        test.startTest();
       
        Map<id,CSS_Solution_Component__c> oldMap = new Map<id,CSS_Solution_Component__c> ();
        oldMap.put(newList[0].id,sc);
         CG_CL_ClaimsAuditTrailEventHandler.onsolcompUpdateFC(newsList,oldMap,sudlist); 
        test.stopTest();
    }*/
        static testmethod void onupdatesolutionmethodrepairresponse(){
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,SerRec.ID);
        List<CSS_Solutions__c>oldlstsrt = new List<CSS_Solutions__c>();
        CSS_Solutions__c srts1 = new CSS_Solutions__c();
        srts1.Service_Job__c=SerRec.id;
        srts1.Diagnostic_Response__c='Most likely the solution';
        oldlstsrt.add(srts1);
        Map<id,CSS_Solutions__c> oldMap = new Map<id,CSS_Solutions__c>();
        oldMap.put(oldlstsrt[0].id,srts1);
        List<CSS_Solutions__c>lstsrt = new List<CSS_Solutions__c>();
        CSS_Solutions__c srts = new CSS_Solutions__c();
        srts.Service_Job__c=SerRec.id;
        srts.Diagnostic_Response__c='Not the solution';
        srts.Repair_Response__c = 'Repair successfully';
        srts.Rank__c = 1;
        srts.Diagnostic_notes__c = 'diagnotes';
        srts.Solution_Title__c = 'Check for primary fault codes';
        srts.Name = 'S00000200';
        lstsrt.add(srts);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Solutions__c';
        aud.Name = 'Symptom FaultCode search';
        aud.Action_Type__c = 'Event Add';
        //aud.Field_Name__c = 'Diagnostic_Response__c';
        aud.Field_Name__c = 'Repair_Response__c';
        
        aud.Message__c = '(rank)-id-title-selected <b>newValue</b>';
        aud.isServicejob__c = true;
       // aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        //insert aud;
        sudlist.add(aud);
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = SerRec.Id;
        cssJH.CSS_Object_Name__c = 'CSS_Solutions__c';
        cssJH.CSS_Field_Name__c = 'Repair_Response__c';
        cssJH.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        //boolean.value(claimHistory.Audit_Message__c);
        //claimHistory.Audit_Message__c = s;
        insert cssJH;
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);
        srts1.Repair_Response__c='Most likely the solution';
        oldlstsrt.add(srts1);
        oldMap.put(oldlstsrt[0].id,srts1);
        aud.Action_Type__c = 'Event Edit';
        aud.Field_Name__c = 'Repair_Response__c';
        aud.Message__c = '(rank)-SolutionID-Title-Changed from <b>DiagnosticResponseOld </b> to <b>DiagnosticResponseNew</b>';
        sudlist.add(aud);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);    
             
        
    }
    static testmethod void onupdatesolutionmethodrepairnotes(){
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,SerRec.ID);
        List<CSS_Solutions__c>oldlstsrt = new List<CSS_Solutions__c>();
        CSS_Solutions__c srts1 = new CSS_Solutions__c();
        srts1.Service_Job__c=SerRec.id;
        srts1.Diagnostic_Response__c='Most likely the solution';
        oldlstsrt.add(srts1);
        Map<id,CSS_Solutions__c> oldMap = new Map<id,CSS_Solutions__c>();
        oldMap.put(oldlstsrt[0].id,srts1);
        List<CSS_Solutions__c>lstsrt = new List<CSS_Solutions__c>();
        CSS_Solutions__c srts = new CSS_Solutions__c();
        srts.Service_Job__c=SerRec.id;
        srts.Diagnostic_Response__c='Not the solution';
        srts.Repair_Response__c = 'Repair successfully';
        srts.Rank__c = 1;
        srts.Diagnostic_notes__c = 'diagnotes';
        srts.Solution_Title__c = 'Check for primary fault codes';
        srts.Name = 'S00000200';
        srts.Repair_Notes__c='repair notes';
        lstsrt.add(srts);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Solutions__c';
        aud.Name = 'Symptom FaultCode search';
        aud.Action_Type__c = 'Event Add';
        //aud.Field_Name__c = 'Diagnostic_Response__c';
        aud.Field_Name__c = 'Repair_Notes__c';
        
        aud.Message__c = '(rank)-SolutionID-Title-<b>Comments</b> Added';
        aud.isServicejob__c = true;
       // aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        //insert aud;
        sudlist.add(aud);
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = SerRec.Id;
        cssJH.CSS_Object_Name__c = 'CSS_Solutions__c';
        cssJH.CSS_Field_Name__c = 'Repair_Notes__c';
        cssJH.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        //boolean.value(claimHistory.Audit_Message__c);
        //claimHistory.Audit_Message__c = s;
        insert cssJH;
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);
        srts1.Repair_Notes__c='Most likely the solution';
        oldlstsrt.add(srts1);
        oldMap.put(oldlstsrt[0].id,srts1);
        aud.Action_Type__c = 'Event Edit';
        aud.Field_Name__c = 'Repair_Notes__c';
        aud.Message__c = '(rank)-SolutionID-Title-<b>Comments</b> Updated';
        sudlist.add(aud);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);    
             
        
    }
        static testmethod void onupdatesolutionmethoddiagresponse(){
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,SerRec.ID);
        List<CSS_Solutions__c>oldlstsrt = new List<CSS_Solutions__c>();
        CSS_Solutions__c srts1 = new CSS_Solutions__c();
        srts1.Service_Job__c=SerRec.id;
       // srts1.Diagnostic_Response__c='Most likely the solution';
        oldlstsrt.add(srts1);
        Map<id,CSS_Solutions__c> oldMap = new Map<id,CSS_Solutions__c>();
        oldMap.put(oldlstsrt[0].id,srts1);
        List<CSS_Solutions__c>lstsrt = new List<CSS_Solutions__c>();
        CSS_Solutions__c srts = new CSS_Solutions__c();
        srts.Service_Job__c=SerRec.id;
        srts.Diagnostic_Response__c='Not the solution';
        srts.Repair_Response__c = 'Repair successfully';
        srts.Rank__c = 1;
        srts.Diagnostic_notes__c = 'diagnotes';
        srts.Solution_Title__c = 'Check for primary fault codes';
        srts.Name = 'S00000200';
        srts.Repair_Notes__c='repair notes';
        lstsrt.add(srts);
        List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Solutions__c';
        aud.Name = 'Symptom FaultCode search';
        aud.Action_Type__c = 'Event Add';
        aud.Field_Name__c = 'Diagnostic_Response__c';
       // aud.Field_Name__c = 'Repair_Notes__c';
        
        aud.Message__c = '(rank)-id-title-selected <b>newValue</b>';
        aud.isServicejob__c = true;
       // aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        //insert aud;
        sudlist.add(aud);
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = SerRec.Id;
        cssJH.CSS_Object_Name__c = 'CSS_Solutions__c';
        cssJH.CSS_Field_Name__c = 'Diagnostic_Response__c';
        cssJH.CSS_New_Value__c = 'test';
        string s = string.valueof(sudlist[0].Dynamic_Message__c);
        //boolean.value(claimHistory.Audit_Message__c);
        //claimHistory.Audit_Message__c = s;
        insert cssJH;
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);
        srts1.Diagnostic_Response__c='Most likely the solution';
        oldlstsrt.add(srts1);
        oldMap.put(oldlstsrt[0].id,srts1);
        aud.Action_Type__c = 'Event Edit';
        aud.Field_Name__c = 'Diagnostic_Response__c';
        aud.Message__c = '(rank)-SolutionID-Title-Changed from <b>DiagnosticResponseOld </b> to <b>DiagnosticResponseNew</b>';
        sudlist.add(aud);
        CG_CL_ClaimsAuditTrailEventHandler.onUpdatetsol(lstsrt,oldMap,sudlist);    
             
        
    }
    static testmethod void onsolcompUpdateFC(){
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
      
        
        CSS_Solutions__c srts = new CSS_Solutions__c();
        srts.Service_Job__c=SerRec.id;
        srts.Diagnostic_Response__c='Not the solution';
        srts.Repair_Response__c = 'Repair successfully';
        srts.Rank__c = 1;
        srts.Diagnostic_notes__c = 'diagnotes';
        srts.Solution_Title__c = 'Check for primary fault codes';
        srts.Name = 'S00000200';
        srts.Repair_Notes__c='repair notes';
        insert srts;
         List<CSS_Solution_Component__c>oldsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Service_Job__c=SerRec.id;
        solcomp.Selected_Component__c=true;
        solcomp.Solutions__c = srts.id;
        oldsolcomp.add(solcomp);
        Map<id,CSS_Solution_Component__c> oldMap = new Map<id,CSS_Solution_Component__c>();
        oldMap.put(oldsolcomp[0].id,solcomp);
        
        List<CSS_Solution_Component__c> newList = new List<CSS_Solution_Component__c> ();
        CSS_Solution_Component__c sc = new CSS_Solution_Component__c();
        sc.Name = 'test';
        sc.Service_Job__c = SerRec.id;
        sc.Selected_Component__c=true;
        sc.Type__c = 'Diagnosis';
        sc.Solutions__c=srts.id;
        insert sc;
        newList.add(sc);
        
        CSS_JobHistory__c cssJH = new CSS_JobHistory__c();
        cssJH.CSS_Job_Id__c = SerRec.Id;
        cssJH.CSS_Object_Name__c = 'CSS_Solution_Component__c';
        cssJH.CSS_Field_Name__c = 'Selected_Component__c';
        cssJH.CSS_New_Value__c = 'test';
       
        insert cssJH;
       List<CG_Claim_Audit_Log__c>sudlist = new List<CG_Claim_Audit_Log__c>();
        CG_Claim_Audit_Log__c aud = new CG_Claim_Audit_Log__c();
        aud.Object_Name__c = 'CSS_Solutions__c';
        aud.Name = 'Symptom FaultCode search';
        aud.Action_Type__c = 'Event Add';
        aud.Field_Name__c = 'Diagnostic_Response__c';
       // aud.Field_Name__c = 'Repair_Notes__c';
        
        aud.Message__c = '(rank)-id-title-selected <b>newValue</b>';
        aud.isServicejob__c = true;
       // aud.Edit_Message__c = 'Parts';
        //aud.Dynamic_Message__c = true;
        //insert aud;
        sudlist.add(aud);
       CG_CL_ClaimsAuditTrailEventHandler.onsolcompUpdateFC(newList,oldMap,sudlist);	
        
        
    }
    
    
}