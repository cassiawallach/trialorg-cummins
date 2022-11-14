/**********************************************************************
Name:CG_CL_ClaimsVSDetails_Test
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
this is test class for CG_CL_ClaimsVSDetails Controller.
===============================================================
************************************************************/
@isTest
public class CG_CL_ClaimsVSDetails_Test {
    public static Testmethod void CG_CL_ClaimsVH_Method(){
        test.startTest();
        CSS_Claims__c testclaimsRec = new CSS_Claims__c();
		CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
   			testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
			insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
			insert testpsnNewRec;
   
     //   CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.ESN__c = '79464646';
        JO.Mileage_Measure__c='19';
        JO.Failure_Date__c=system.today();
        JO.Qsol_Engine_Family_Code__c='IN';
        JO.Service_Model__c='Fire truck';
        insert JO; 
        
        PageReference pageRef = Page.CG_ClaimsVS;
        pageRef.getParameters().put('id',testclaimsRec.id);
        Test.setCurrentPage(pageRef); 
		CG_CL_ClaimsVS claims= new CG_CL_ClaimsVS();
        CG_CL_ClaimsVSDetails claimsvh = new CG_CL_ClaimsVSDetails();
        
        List<CG_CL_ClaimsVS.claimWrapperClass> lstclaimWrapper =  new List<CG_CL_ClaimsVS.claimWrapperClass>();
        CG_CL_ClaimsVS.claimWrapperClass claimwrap = new CG_CL_ClaimsVS.claimWrapperClass();
        claimwrap.BMSReferenceNumber='null';
        claimwrap.claimid = testclaimsRec.id;
		claimwrap.BranchCode='53426'; 
		claimwrap.CSSJobID=JO.id; 
		claimwrap.CampaignNumber='null'; 
		claimwrap.CatastrophicFlag='N'; 
		claimwrap.ClaimDate='2017-10-09 17:00:00'; 
		claimwrap.ClaimFiledDate='05/28/2019'; 
		claimwrap.ClaimSource='Guidanz';
        lstclaimWrapper.add(claimwrap); 
        claims.lstclaimWrapper = lstclaimWrapper;
    //    system.debug('clmWrap***' + lstclaimWrapper);
        
        List<Cg_Cl_Claimsvs.failureWrapperClass> lstfailurewrap = new List<Cg_Cl_Claimsvs.failureWrapperClass>();
            Cg_Cl_Claimsvs.failureWrapperClass failwrap = new Cg_Cl_Claimsvs.failureWrapperClass('','','','','','','','','','','','','','','','','','','','','','','','','','','','','',null,'',null);
            failwrap.FailureOrder='';
            failwrap.FailLocation = 'test';
            failwrap.CustomerPossession ='Yes';
            failwrap.PartsWarrantyStartDate = 'test';
            failwrap.FailureDate = 'test';
            failwrap.FailurePoint = '30';
            failwrap.FailureMeasure = 'Miles';
            failwrap.FailureOrder='';
            lstfailurewrap.add(failwrap);
        
		claimsvh.controllerRef=claims;
        claimsvh.nvFC();
        claimsvh.nvMPSN();
        claimsvh.nvJobNotes();
        claimsvh.nvsrts();
        claimsvh.nvparts();
		claimsvh.assignPrimaryFailureFlag();   
        test.stopTest();
    }
    public static Testmethod void TestData1()
    {
        
        PageReference pageRef = Page.CG_ClaimsFC;
   		Test.setCurrentPage(pageRef); 
		CG_CL_ClaimsVS claims= new CG_CL_ClaimsVS();
        CG_CL_ClaimsVSDetails claimsvh1 = new CG_CL_ClaimsVSDetails();
		claimsvh1.controllerRef=claims;
        claimsvh1.nvFC();
        claimsvh1.nvMPSN();
        claimsvh1.nvJobNotes();
        claimsvh1.nvsrts();
        claimsvh1.nvparts();
        
    }
    
}