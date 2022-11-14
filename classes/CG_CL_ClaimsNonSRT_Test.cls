/***********************************************************************
History                                                            
-------                                                            
VERSION             AUTHOR                        DATE                  DETAIL   
1.0 -   		   Rupesh Pande      			07/13/2018           INITIAL DEVELOPMENT
2.0 -   		   Rupesh Pande      			9/17/2018            UPDATE 
3.0-			   Sneha						9/20/2018			 UPDATE	
***********************************************************************/
@isTest
public class CG_CL_ClaimsNonSRT_Test
{
    public static testmethod void Method1()
    {
        //Insert Account
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '19134';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '19134';
        insert acc;
        
        /*Creating Job*/
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        
        /*Creating Claim*/
        List <CSS_Claims__c> clmlst = new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Email_Address__c = 'rp@cummins.com';
        claim.CSS_Job__c=JO.Id;
        claim.Account__c = acc.id;
        claim.Country__c='CA';
        claim.State__c='US';
        claim.Location_Code__c='02466-19134';
        claim.ODM_Penalty__c  = '90';
        claim.Information_Only_Claim__c =false;
        insert claim;
        clmlst.add(claim);
        

        /*Creating Solutions*/
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.ID);
        
        
        //Creating solution component object with those fields that are required in query*/
        CSS_Solution_Component__c solcom = new CSS_Solution_Component__c();
        solcom.Solutions__c = sol.id;
        solcom.name = 'Aftertreatment Outlet Nox Sensor';
        solcom.AccountCode__c='67';
        solcom.AccountCodeEdit__c='Test';
        solcom.Selected_Component__c=true;
        solcom.CSS_Claims__c=claim.id;
        solcom.ODM_Penalty__c='100';
        solcom.Type__c=null;
        solcom.AccountCodeType__c = 'New Engine Warranty';
        solcom.System_Code__c = 'YN';
        solcom.Component_Code__c = 'EB';
        solcom.Selected_Component__c = true;
        solcom.CoveredLaborHrs__c = '90';
        insert solcom;
        
        
        CSS_Solution_Component__c solcom1 = [SELECT CSS_Account_Formula__c , AccountCodeType__c,AccountCodeEdit__c,AccountCode__c,Fail_Code__c,FailCode_Formula__c FROM CSS_Solution_Component__c where id =: solcom.id];
        system.debug(solcom1.CSS_Account_Formula__c);
        system.debug(solcom1.FailCode_Formula__c);
       
        
        List <css_srt__c> srtlst = new list <css_srt__c>();
        /*Creating SRT with required fields*/
        css_srt__c srt1 = new css_srt__c();
        srt1.CSS_Claims__c= claim.Id;
        srt1.Name='Srt';
        srt1.Type__c='Repair';
        srt1.isPerformed__c=true;
        srt1.Assignment__c='Primary';
        srt1.SRT_Notes__c = 'test';
        srt1.SRT_Time__c=1.0;
        srt1.Account_Code_Description__c='test';
        srt1.Type__c='99Time';
        srt1.Fail_Code_Description__c='Test';
        srt1.Claimed_Hours__c = 11.00;
        srt1.SRT_Warrantable__c = '10';
        srt1.Extended_Hours__c=10.0;
        srtlst.add(srt1);
        insert srtlst;
        
        list<CSS_JobEventTemporary__c> jobevtlist = new list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Key__c = 'AccountCodes';
        jobevnt.Attribute1__c = 'POL';
        jobevnt.Attribute2__c = 'New Engine Warranty';
        jobevnt.Attribute3__c = '67';
        jobevtlist.add(jobevnt);
        
         CSS_JobEventTemporary__c jobevnt1 = new CSS_JobEventTemporary__c();
        jobevnt1.Key__c = 'AccountCodes';
        jobevnt1.Attribute1__c = 'NPW';
        jobevnt1.Attribute2__c = 'New Engine Warranty';
        jobevnt1.Attribute3__c = '67';
        jobevtlist.add(jobevnt1);
        insert jobevtlist;  
        
        
        /*Routing the page to Claim id*/
        PageReference pg = Page.CG_ClaimsSRTs;
        Test.setCurrentPage(pg);
        ApexPages.CurrentPage().getParameters().put('id',claim.Id);
        
         Test.startTest();
         CG_CL_ClaimsNonSRT claimsnonsrt = new CG_CL_ClaimsNonSRT();
         claimsnonsrt.counting = 10;
         claimsnonsrt.dealerLocation = true;
         claimsnonsrt.isFactory = false;
         //claimsnonsrt.coverageType='POL';
         claimsnonsrt.closePopup();
         claimsnonsrt.getConstructorLoaded();
         claimsnonsrt.saveNonSRTPopup(); 
         claimsnonsrt.resetNonSRTMethod();   
         claimsnonsrt.selectedRemoveRow=10;
         claimsnonsrt.removingNonSRTRow();
         claimsnonsrt.saveNonSRTMethod();
         claimsnonsrt.PName = 'ttst';
         
        /*Creating and initializing Wrapper objects*/
        CG_CL_ClaimsNonSRT.NonSRTWrapper wrpobj= new CG_CL_ClaimsNonSRT.NonSRTWrapper(10,'srtId','SRTCode','null','percentRequested','claimedhours','failCode','null','null',false,true);
        wrpobj.SRTTime='1.0';
        wrpobj.Notes='';
           
        claimsnonsrt.counting=10;
        claimsnonsrt.selCoveredVal='2';
        claimsnonsrt.SRTPercReqNonSRT();
        claimsnonsrt.saveNonSRTPopup();
        boolean isRemove = false;
        
        CSS_SRT__c lstRec =[select id,name,Type__c,SRT_Select__c,SRT_Warrantable__c from CSS_SRT__c limit 1];
        lstRec.SRT_Warrantable__c='12';
        update lstRec;
        
        List< CG_CL_ClaimsNonSRT.NonSRTWrapper> lstnonsrt = new  List<CG_CL_ClaimsNonSRT.NonSRTWrapper>();
        CG_CL_ClaimsNonSRT.NonSRTWrapper nonsrtwrap = new CG_CL_ClaimsNonSRT.NonSRTWrapper(1,'srtId','SRTCode','null','percentRequested','claimedhours','failCode','accountCode','null',false,true);
        nonsrtwrap.isRemove=true;
        lstnonsrt.add(nonsrtwrap);
        claimsnonsrt.counting=1;
        claimsnonsrt.selCoveredVal='2';
        claimsnonsrt.SRTPercReqNonSRT();
        claimsnonsrt.saveNonSRTPopup();
        Test.stopTest();
    }
    
    public static testmethod void Method2()
    {
        
        Test.startTest();
        
        CG_CL_ClaimsNonSRT claimsnonsrt = new CG_CL_ClaimsNonSRT();
        List< CG_CL_ClaimsNonSRT.NonSRTWrapper> lstnonsrt = new  List<CG_CL_ClaimsNonSRT.NonSRTWrapper>();
        CG_CL_ClaimsNonSRT.NonSRTWrapper nonsrtwrap = new CG_CL_ClaimsNonSRT.NonSRTWrapper(1,'srtId','SRTCode','SRTTime','percentRequested','claimedhours','failCode','accountCode','Notes',true,true);
        CG_CL_ClaimsNonSRT.NonSRTWrapper nonsrtwrap1 = new CG_CL_ClaimsNonSRT.NonSRTWrapper(1,'srtId','SRTCode','SRTTime','percentRequested','claimedhours','failCode','accountCode','Notes',false,false);      
        CG_CL_ClaimsNonSRT.NonSRTWrapper nonsrtwrap2 = new CG_CL_ClaimsNonSRT.NonSRTWrapper(1,'srtId','SRTCode','SRTTime','percentRequested','claimedhours','failCode','accountCode','Notes',false,false);
        lstnonsrt.add(nonsrtwrap);
        lstnonsrt.add(nonsrtwrap1);
        lstnonsrt.add(nonsrtwrap2);
        claimsnonsrt.counting=1;
        claimsnonsrt.SRTPercReqNonSRT();
        claimsnonsrt.getConstructorLoaded();
        Test.stopTest();
        
    }
    
    public static testmethod void Method3()
    {
        //Insert Account
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.IAM_Service_Provider_Code__c = '19134';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '19134';
        insert acc;
        
        List <CSS_Claims__c> clmlst = new List<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Email_Address__c = 'rp@cummins.com';
        claim.Account__c = acc.id;
        claim.Country__c='CA';
        claim.State__c='US';
        claim.Location_Code__c='02466-19134';
        claim.ODM_Penalty__c  = '90';
        clmlst.add(claim);
        insert clmlst;
        
        
        CSS_Solution_Component__c solcom = new CSS_Solution_Component__c();
        solcom.name = 'Aftertreatment Outlet Nox Sensor';
        solcom.AccountCode__c='67';
        solcom.AccountCodeEdit__c='Test';
        solcom.Selected_Component__c=true;
        solcom.CSS_Claims__c=claim.id;
        solcom.ODM_Penalty__c='100';
        solcom.Type__c=null;
        solcom.AccountCodeType__c = 'New Engine Warranty';
        solcom.System_Code__c = 'YN';
        solcom.Component_Code__c = 'EB';
        solcom.Selected_Component__c = true;
        solcom.CoveredLaborHrs__c = '90';
        insert solcom;
        
        
        CSS_Solution_Component__c solcom1 = [SELECT CSS_Account_Formula__c , AccountCodeType__c,AccountCodeEdit__c,AccountCode__c,Fail_Code__c,FailCode_Formula__c FROM CSS_Solution_Component__c where id =: solcom.id];
        system.debug(solcom1.CSS_Account_Formula__c);
        system.debug(solcom1.FailCode_Formula__c);
       
        
        List <css_srt__c> srtlst = new list <css_srt__c>();
        css_srt__c srt1 = new css_srt__c();
        srt1.CSS_Claims__c= claim.Id;
        srt1.Name='Srt';
        srt1.Type__c='Repair';
        srt1.isPerformed__c=true;
        srt1.Assignment__c='Primary';
        srt1.SRT_Notes__c = 'test';
        srt1.SRT_Time__c=1.0;
        srt1.Account_Code_Description__c='test';
        srt1.Type__c='99Time';
        srt1.Fail_Code_Description__c='Test';
        srt1.Claimed_Hours__c = 11.00;
        srt1.SRT_Warrantable__c = '10';
        srtlst.add(srt1);
        insert srtlst;
        
        list<CSS_JobEventTemporary__c> jobevtlist = new list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Key__c = 'AccountCodes';
        jobevnt.Attribute1__c = 'POL';
        jobevnt.Attribute2__c = 'New Engine Warranty';
        jobevnt.Attribute3__c = '67';
        jobevtlist.add(jobevnt);
        insert jobevtlist;  
        
        CSS_JobEventTemporary__c jET= [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes'];
        system.debug('jET'+jET);
       
        PageReference pg = Page.CG_ClaimsSRTs;
        Test.setCurrentPage(pg);
        ApexPages.CurrentPage().getParameters().put('id',claim.Id);
        
        List< CG_CL_ClaimsNonSRT.NonSRTWrapper> lstnonsrt = new  List<CG_CL_ClaimsNonSRT.NonSRTWrapper>();
        CG_CL_ClaimsNonSRT.NonSRTWrapper nonsrtwrap = new CG_CL_ClaimsNonSRT.NonSRTWrapper(10,'srtId','SRTCode','null','percentRequested','claimedhours','failCode','','null',false,true);
        lstnonsrt.add(nonsrtwrap);
        
         Test.startTest();
         CG_CL_ClaimsNonSRT claimsnonsrt = new CG_CL_ClaimsNonSRT();
         claimsnonsrt.claimsRecList = clmlst;
         claimsnonsrt.counting=10;
         claimsnonsrt.selCoveredVal='2';
         claimsnonsrt.NonSRTWrapperList = lstnonsrt;
         claimsnonsrt.existingNonSRTList = srtlst;
         system.debug('test1');
         claimsnonsrt.SRTPercReqNonSRT();
         claimsnonsrt.getEditNonSRTValues();
         Test.stopTest();
    
}
    
}