@istest
public class CG_CL_ClaimsJobNotesComp_test {
    
    static testmethod void testmethod1()
    {
       //css_job_order__c jo = CSS_TestData.createJobOrder(false);
       css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Test';
        jo.Customer_Code__c='1213';
        jo.ESN__c='87965437';
        jo.Non_SRT_Details__c='Testing';
        insert jo;
        
        css_claims__c claim = new css_claims__c();
        claim.CSS_Job__c=jo.id;
        claim.AccessCode__c='Test';
        claim.EditCause__c='Testing';
        claim.EditComplaint__c='Testing';
        claim.EditCorrection__c='Testing';
        claim.EditCoverage__c='Testing';
        claim.JobEditCause__c='Testing';
        claim.JobEditComplaint__c='Testing';
        claim.JobEditCorrection__c='Testing';
        claim.JobEditCoverage__c='Testing';
        insert claim;
        
        css_solutions__c sol = css_testdata.createSolutions(true,jo.id);
        // css_solution_component__c solcomp = css_testdata.createSRT(false, jo.Id, sol.id);
        // solcomp.CSS_Claims__c=claim.id;
        // solcomp.Quantity__c=1.2;
        // insert solcomp;
        
        list<CSS_Solution_Component__c> lstsolcomp = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.name = 'MOUL';
        insert solComp;
        lstsolcomp.add(solComp);
        
        css_claims__c claim1 = new css_claims__c();
        claim1.id = claim.id;
        claim1.EditCause__c='Testing';
        claim1.EditComplaint__c='Testing';
        claim1.EditCorrection__c='Testing';
        // claim1.updatecorrec= true;
        claim1.EditCoverage__c='Testing';
        claim1.JobEditCause__c='Testing';
        claim1.JobEditComplaint__c='Testing';
        claim1.JobEditCorrection__c='Testing';
        claim1.JobEditCoverage__c='Testing';
        claim1.css_job__c = null;
        update claim1;
        
        css_claims__c claim2 = new css_claims__c();
        claim2.id = claim.id;
        claim2.EditCause__c='';
        claim2.EditComplaint__c='';
        claim2.EditCorrection__c='';
        claim2.EditCoverage__c='';
        claim2.JobEditCause__c='';
        claim2.JobEditComplaint__c='';
        claim2.JobEditCorrection__c='';
        claim2.JobEditCoverage__c='';
        claim2.css_job__c = null;
        update claim1;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.Name='Test';
        testpsnNewRec.psn__c='79464646';
        testpsnNewRec.CSS_Claims__c=claim.id;
        testpsnNewRec.Primary__c=true;
        insert testpsnNewRec;
        
        pagereference ref = page.CG_ClaimsIntake;
        test.setCurrentPage(Ref);
        apexpages.currentPage().getparameters().put('id',claim.id);
        
        css_srt__c srt = css_testdata.createSRT(false,'99Time', sol.Id, jo.id);
        srt.CSS_Claims__c=claim.id;
        srt.Account_Code_Description__c='Testing Code';
        srt.Fail_Code_Description__c='Testing fail code';
        srt.SRT_Notes__c='Testing';
        // insert srt;
        
        String notesdesc;
        if(notesdesc == '1'){
            Note claimnotes = new Note();
            claimnotes.Title='TECHNICIANNOTES';
            claimnotes.Body='Testing';
            claimnotes.ParentId=claim.Id;
            insert claimnotes;
        }
        else if(notesdesc == '2'){
            Note claimnotes1 = new Note();
            claimnotes1.Title='TECHNICIANNOTES';
            claimnotes1.Body='Testing';
            claimnotes1.ParentId=claim.Id;
            insert claimnotes1;
        }
        
        //  list<Note> ClaimNotesList=new list<Note>();  
        note not1 = new note();
        not1.Body='Testing';
        not1.ParentId=claim.Id;
        not1.Title='Claims';
        insert not1;
        note not2 = new note();
        not2.Body='Testing';
        not2.ParentId=claim.Id;
        not2.Title='Claims';
        insert not2;
        note not3 = new note();
        not3.Body='Testing';
        not3.ParentId=claim.Id;
        not3.Title='Claims';
        insert not3;
        
        
        test.startTest();
        CG_CL_ClaimsJobNotesComp nwclaim = new CG_CL_ClaimsJobNotesComp();
        nwclaim.jobComplaintModifiedBy='Testing';
        nwclaim.jobCauseModifiedBy='testing';
        nwclaim.jobCoverageModifiedBy='testing';
        nwclaim.jobCorrectionModifiedBy='testing';
        nwclaim.NotesBody = 'NotesBody';
        nwclaim.URLAC = 'Testing';
        nwclaim.claimSubID = 'Data Test';
        nwclaim.sendNotesError = true;
        nwclaim.dealerCustomer = true;
        nwclaim.complaintcounter = 12;
        nwclaim.coveragecounter = 1;
        nwclaim.causecounter =1;
        nwclaim.correctioncounter=2;
        nwclaim.updatecorrec = true;
        nwclaim.EditCause = 'EditCause';
        nwclaim.EditComplaint = 'EditComplaint';
        nwclaim.EditCorrection = 'EditCorrection';
        nwclaim.EditCoverage = 'EditCoverage';
        //nwclaim.savecomplaint12();
        //nwclaim.saveSPResponse();
        nwclaim.saveComplaint();
        nwclaim.saveCorrection();
        nwclaim.saveCause();
        nwclaim.saveCoverage();
        nwclaim.pageReferenceMethod();
        //nwclaim.saveNotes();
        nwclaim.getSortvalues();
        nwclaim.notesdesc = '2';
        nwclaim.claimsNotesSOQL();
        nwclaim.cID=null;
        //nwclaim.saveNotes();
        nwclaim.ClaimsRec=null;
        nwclaim.saveCoverage();
        nwclaim.saveCause();
        nwclaim.saveCorrection();
        nwclaim.saveComplaint();
        nwclaim.mainSOQL();
        test.stopTest();
    }
    
    static testmethod void testmethod2()
    {
        CG_CL_ClaimsJobNotesComp nwclaim = new CG_CL_ClaimsJobNotesComp();
        nwclaim.jobComplaintModifiedBy='Testing';
        nwclaim.jobCauseModifiedBy='testing';
        nwclaim.jobCoverageModifiedBy='testing';
        nwclaim.jobCorrectionModifiedBy='testing';
        nwclaim.jobComplaintModifiedDate='21-06-2018 10:33:28';
        nwclaim.jobCauseModifiedDate='21-06-2018 10:33:28';
        nwclaim.jobCoverageModifiedDate='21-06-2018 10:33:28';
        nwclaim.jobCorrectionModifiedDate='21-06-2018 10:33:28';
        nwclaim.pageReferenceMethod();
    }
    
    public static testmethod void testmethod3()
    {
        
        css_claims__c claim = new css_claims__c();
        claim.CSS_Job__r = null;
        claim.EditCorrection__c= null;
        //claim.Claims_General_Symptoms__c = 'Air Leak';
        claim.EditCause__c='Testing';
        claim.EditComplaint__c='Testing';
        claim.EditCoverage__c='Testing';
        claim.JobComplaintLastModified__c = '';
        claim.JobCauseLastModified__c = 'Cause';
        claim.JobCoverageLastModified__c = 'Coverage';
        claim.JobCorrectionLastModified__c = 'Correction';
        insert claim;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.CSS_Claims__c=claim.id;
        testpsnNewRec.psn__c='79464646';
        testpsnNewRec.Primary__c=true;
        insert testpsnNewRec;
        
        list<CSS_Solution_Component__c> solCompList = new list<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solcomp1.Name = 'Turbocharger Actuator';
        solcomp1.Quantity__c = 1;
        solcomp1.CSS_Claims__c = claim.id;
        solcomp1.Selected_Component__c = true;
        solcomp1.type__c= '';
        solCompList.add(solComp1);
        
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solcomp2.Name = 'A0020';
        solcomp2.Quantity__c = 1;
        solcomp2.CSS_Claims__c = claim.id;
        solcomp2.Selected_Component__c = true;
        solcomp2.type__c= '';
        solCompList.add(solComp2);
        insert solcompList;
        
        list<CSS_Parts_Options__c> poList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c = claim.id;
        po.FailurepartId__c =solcomp1.Id; 
        po.Name = 'Turbocharger Actuator Kit';
        poList.add(po);
        insert poList;
        
        pagereference ref = page.CG_ClaimsIntake;
        test.setCurrentPage(Ref);
        apexpages.currentPage().getparameters().put('id',claim.id);
        
        test.startTest();
        CG_CL_ClaimsJobNotesComp Jobnotes = new CG_CL_ClaimsJobNotesComp();
        test.stoptest();
    }
    
    public static testmethod void testmethod4()
    {
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='1213';
        jo.ESN__c='79464646';
        insert jo;
        
        css_claims__c claim = new css_claims__c();
        claim.CSS_Job__c = jo.id;
        claim.EditCorrection__c= 'Testing';
        claim.EditCause__c='Testing';
        claim.EditComplaint__c='Testing';
        claim.EditCoverage__c='Testing';
        claim.JobComplaintLastModified__c = '';
        insert claim;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.CSS_Claims__c=claim.id;
        testpsnNewRec.psn__c='79464646';
        testpsnNewRec.Primary__c=true;
        insert testpsnNewRec;
        
        
        pagereference ref = page.CG_ClaimsIntake;
        test.setCurrentPage(Ref);
        apexpages.currentPage().getparameters().put('id',claim.id);
        
        test.startTest();
        CG_CL_ClaimsJobNotesComp Jobnotes = new CG_CL_ClaimsJobNotesComp();
        test.stoptest();
    }
    
    public static testmethod void testmethod5()
    {
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='1213';
        jo.ESN__c='79464646';
        insert jo;
        
        css_claims__c claim = new css_claims__c();
        claim.CSS_Job__c = jo.id;
        claim.EditCorrection__c= 'Testing';
        claim.EditCause__c='Testing';
        claim.EditComplaint__c='Testing';
        claim.EditCoverage__c='Testing';
        claim.JobCauseLastModified__c = '21-01-2019 10:33:28';
        insert claim;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.CSS_Claims__c=claim.id;
        testpsnNewRec.psn__c='79464646';
        testpsnNewRec.Primary__c=true;
        insert testpsnNewRec;
        
        
        pagereference ref = page.CG_ClaimsIntake;
        test.setCurrentPage(Ref);
        apexpages.currentPage().getparameters().put('id',claim.id);
        
        test.startTest();
        CG_CL_ClaimsJobNotesComp Jobnotes = new CG_CL_ClaimsJobNotesComp();
        test.stoptest();
    }
    
    public static testmethod void testmethod6()
    {
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='TestUser';
        jo.Customer_Code__c='1213';
        jo.ESN__c='79464646';
        insert jo;
        
        css_claims__c claim = new css_claims__c();
        claim.CSS_Job__c = jo.id;
        claim.EditCorrection__c= 'Testing';
        claim.EditCause__c='Testing';
        claim.EditComplaint__c='Testing';
        claim.EditCoverage__c='Testing';
        claim.JobCoverageLastModified__c = '21-01-2019 10:33:28';
        insert claim;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.CSS_Claims__c=claim.id;
        testpsnNewRec.psn__c='79464646';
        testpsnNewRec.Primary__c=true;
        insert testpsnNewRec;
        
        
        pagereference ref = page.CG_ClaimsIntake;
        test.setCurrentPage(Ref);
        apexpages.currentPage().getparameters().put('id',claim.id);
        
        test.startTest();
        CG_CL_ClaimsJobNotesComp Jobnotes = new CG_CL_ClaimsJobNotesComp();
        test.stoptest();
    }
    
    public static testmethod void testmethod7()
    {
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='1213';
        jo.ESN__c='79464646';
        insert jo;
        
        css_claims__c claim = new css_claims__c();
        claim.CSS_Job__c = jo.id;
        claim.EditCorrection__c= 'Testing';
        claim.EditCause__c='Testing';
        claim.EditComplaint__c='Testing';
        claim.EditCoverage__c='Testing';
        claim.JobCorrectionLastModified__c = '21-01-2019 10:33:28';
        insert claim;
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.CSS_Claims__c=claim.id;
        testpsnNewRec.psn__c='79464646';
        testpsnNewRec.Primary__c=true;
        insert testpsnNewRec;
        
        
        pagereference ref = page.CG_ClaimsIntake;
        test.setCurrentPage(Ref);
        apexpages.currentPage().getparameters().put('id',claim.id);
        
        test.startTest();
        CG_CL_ClaimsJobNotesComp Jobnotes = new CG_CL_ClaimsJobNotesComp();
        test.stoptest();
    }
    
    public static testmethod void fetchClaimRecordsMethod(){
        
        
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.Region__c = 'US and Canada';
        acc.type = 'Dealer account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Claim_Submitted__c = date.today();
        claimsobj.Rejection_Comments__c = 'rejected';
        claimsobj.Payment_Details__c = 'der';
        claimsobj.Customer_Name__c = 'name';
        claimsobj.Shop_Work_Order__c = 'wo';
        claimsobj.Location__c = 'code';
        claimsobj.Status__c = 'Submitted';
        claimsobj.Account__c = acc.id;
        claimsobj.Location_Code__c = '56270-56255';
        claimsobj.Pending_Authorization__c = 'Authorization Required';
        claimsobj.Location__c = '562';
        insert claimsobj;
        
        List<CSS_Claim_Submission__c> claimsubLst = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.CSS_Claims__c = claimsobj.Id; 
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'submitted';
        claimsubLst.add(claimsSub);
        insert claimsubLst;
       
       /*List<Note> notesList = new List<Note>();
        Note nt = new Note();
        nt.ParentId = claimsSub.Id;
        nt.title = 'SP Update';
        nt.Body = 'TestData;;';
        notesList.add(nt);
        insert notesList;*/
        
   /*List<String> stgData = new List<String>();
      String s1 = 'TestData';
      String s2 = s1;
      String s3 = 'TestData';
      String s4 = s3;
      String s5 = 'TestData';
      String s6 = s5;
      String s7 = 'TestData';
      String s8 = s7;
      stgData.add(s2);
      stgData.add(s4);
      stgData.add(s6);
      stgData.add(s8);*/
      
        apexpages.currentPage().getparameters().put('id',claimsobj.id);
        system.debug('sublst'+claimsubLst);
        test.startTest();
        
        CG_CL_ClaimsJobNotesComp Jobnotes = new CG_CL_ClaimsJobNotesComp();
        Jobnotes.fetchClaimRecords();
        test.stoptest();
        
    }
    
    public static testmethod void saveSPResponseMethod(){
         
       //Account obj
        Account acc = new Account();
        acc.name='562';
        acc.CSS_DistributorCode__c='56270';
        acc.IAM_Service_Provider_Code__c='56270';
        acc.Enable_Claims__c = true;
        acc.Region__c = 'US and Canada';
        acc.type = 'Dealer account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        //Claims obj
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        claimsobj.Claim_Submitted__c = date.today();
        claimsobj.Rejection_Comments__c = 'rejected';
        claimsobj.Payment_Details__c = 'der';
        claimsobj.Customer_Name__c = 'name';
        claimsobj.Shop_Work_Order__c = 'wo';
        claimsobj.Location__c = 'code';
        claimsobj.Status__c = 'Submitted';
        claimsobj.Account__c = acc.id;
        claimsobj.Location_Code__c = '56270-56255';
        claimsobj.Pending_Authorization__c = 'Authorization Required';
        claimsobj.Location__c = '562';
        insert claimsobj;
        
        //ClaimSubmission obj
        List<CSS_Claim_Submission__c> clmsub = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c cs = new CSS_Claim_Submission__c();
        cs.Account_Code__c = 'NEW PARTS WARRANTY 62';
        cs.Individual_Claim_Id__c = 'C0000182919-01';
        cs.Status__c = 'In Review';
        cs.isPendingResponse__c = false;
        insert cs;
        clmsub.add(cs);
        system.debug('clmsub<><>'+clmsub);
        
        //NotesList obj
        List<Note> notesList = new List<Note>();
        Note nt = new Note();
        nt.ParentId = cs.Id;
        nt.title = 'SP Update';
        nt.Body = 'TestData;;';
        notesList.add(nt);
        insert notesList;
        
        //ClaimNotes Wrapper
        List<CG_CL_ClaimsJobNotesComp.ClaimNotes> ntlst = new List<CG_CL_ClaimsJobNotesComp.ClaimNotes>();
        CG_CL_ClaimsJobNotesComp.ClaimNotes clnwrap = new CG_CL_ClaimsJobNotesComp.ClaimNotes();   
        clnwrap.lastSaveDate = 'lastSaveDate';  
        clnwrap.noteBody = 'noteBody'; 
        clnwrap.noteTitle = 'noteTitle';
        ntlst.add(clnwrap); 
        
        List<CG_CL_ClaimsJobNotesComp.claimWrapperClass> ntlst1 = new List<CG_CL_ClaimsJobNotesComp.claimWrapperClass>();
        CG_CL_ClaimsJobNotesComp.claimWrapperClass obj = new CG_CL_ClaimsJobNotesComp.claimWrapperClass();
        obj.accountcode = cs.Account_Code__c;
        obj.claimid = 'C0000182919-01';
        obj.claimStatus = cs.Status__c;
        obj.claimSubNotes = ntlst;
        obj.SPResponse = 'success';
        obj.pendingSPResponse = true;
        ntlst1.add(obj);
        
        List<String> stgData = new List<String>();
        String s1 = 'TestData';
        String s2 = s1;
        String s3 = 'TestData';
        String s4 = s3;
        String s5 = 'TestData';
        String s6 = s5;
        String s7 = 'TestData';
        String s8 = s7;
        stgData.add(s2);
        stgData.add(s4);
        stgData.add(s6);
        stgData.add(s8);
        
        test.startTest();  
        CG_CL_ClaimsJobNotesComp Jobnotes = new CG_CL_ClaimsJobNotesComp();
        Jobnotes.claimSubID = 'C0000182919-01';
        Jobnotes.lstclaimWrapper = ntlst1;
        Jobnotes.saveSPResponse();
        test.stoptest();
    
    }
    
}