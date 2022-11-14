@istest
public class CG_CL_UpdatePartReturnFlagJobs_Test 
{
  
    CG_CL_UpdatePartReturnToCenterFlagJobs updjobs = new CG_CL_UpdatePartReturnToCenterFlagJobs();
    
    static testmethod void M1()
    {
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466'; 
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        //SRT LIST
        List<CSS_SRT__c> srtlist = new List<CSS_SRT__c>();
        
        //Create Job
        CSS_Job_Order__c testjob=CSS_TestData.createJobOrder(false);
        testjob.Account__c=acc.id;
        insert testjob;
        String stestjobid=String.valueOf(testjob.id);
       
        //Create Sol Data
        CSS_Solutions__c sol=CSS_TestData.createSolutions(true,testjob.id);
        
        //Create Sol Comp Data       
        CSS_Solution_Component__c solcom1= CSS_TestData.createSRT(false,null,sol.id);

        CSS_Solution_Component__c solcom2= CSS_TestData.createSRT(false,null,sol.id);  

        list<CSS_Solution_Component__c> solcomplist=new list<CSS_Solution_Component__c>();
        solcomplist.add(solcom1);
        solcomplist.add(solcom2);
        insert solcomplist;
        
        //Create Parts options list
        CSS_Parts_Options__c parts1= CSS_TestData.createParts(false,testjob.id,solcomplist[0].id,sol.id);
        parts1.ReturnToFactory__c = 'Y';
        parts1.ReturnWaiver__c=false;
        parts1.Service_Job__c=testjob.id;
        parts1.Fail_Code__c='ABBC-ASD';
        parts1.Account_Code__c='CAMPAIGN 65';
        CSS_Parts_Options__c parts2= CSS_TestData.createParts(false,testjob.id,solcomplist[1].id,sol.id);
        parts2.ReturnWaiver__c=true;
        parts2.ReturnToFactory__c = 'Y';
        parts2.Service_Job__c=testjob.id;
        parts2.Fail_Code__c='ABC-ASD';
        parts2.Account_Code__c='CHINA JV POLICY JV';
        list<CSS_Parts_Options__c> polist=new list<CSS_Parts_Options__c>();
        polist.add(parts1);
        polist.add(parts2);
        insert polist;
        
        //Create SRT Object (RTF=Y AND EXCEPTION)
        CSS_SRT__c SrtRec1=CSS_TestData.createSRT_New(false,'string typ',sol.Id,testjob.Id,null);
        SrtRec1.SRT_ID__c = '00-10S-00';
        SrtRec1.Type__c = 'Admins';
        SrtRec1.CSS_Claims__c=null;
        SrtRec1.Job_Order__c=testjob.id;
        insert SrtRec1;
        
        CSS_SRT__c SrtRec2=CSS_TestData.createSRT_New(false,'string typ',sol.Id,testjob.Id,null);
        SrtRec2.SRT_Category__c = 'AdditionalDiag';
        SrtRec2.SRT_ID__c = '00-10S-00';
        SrtRec2.Type__c = 'Admins';
        SrtRec2.Job_Order__c=testjob.id;
        insert SrtRec2;

        CSS_SRT__c SrtRec3=CSS_TestData.createSRT_New(false,'string typ',sol.Id,testjob.Id,null);
        SrtRec3.SRT_Category__c = 'AdditionalDiag';
        SrtRec3.Type__c = 'Admins';
        SrtRec3.SRT_ID__c = '00-10S-00';
        SrtRec3.Job_Order__c=testjob.id;
        insert SrtRec3;
        
        CSS_SRT__c SrtRec4=CSS_TestData.createSRT_New(false,'string typ',sol.Id,testjob.Id,null);
        SrtRec4.SRT_ID__c = '00-10S-00';
        SrtRec4.Type__c = 'Admins';
        SrtRec4.CSS_Claims__c=null;
        SrtRec4.Job_Order__c=testjob.id;
        insert SrtRec4;
       
        //Create SRT List
        srtlist.add(SrtRec1); 
        srtlist.add(SrtRec2);
        srtlist.add(SrtRec3);
        srtlist.add(SrtRec4);
        
        //Dummy string
        list<String> stringList1 = new list<String>();
        string s='Y;;'+'true;;'+stestjobid+';;True';
        stringList1.add(s);
        system.debug('The Dummy string is'+stringList1);
         
        //Call the method to verify
        srtlist = CSS_WS_SRT.getAllClaimsDigRepSRTs(testjob.id,'Admin');
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
    CG_CL_UpdatePartReturnToCenterFlagJobs.CreateAdminSRTforJobs(stringList1);
        
        //Call the method to verify 
        list<String> stringList2 = new list<String>();
        string s1='N;;'+'false;;'+stestjobid+';;True';
        stringList2.add(s1);
        system.debug('The Dummy string is'+stringList2);
       
    //Call the method to verify
        srtlist = CSS_WS_SRT.getAllClaimsDigRepSRTs(testjob.id,'Admin');
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
    CG_CL_UpdatePartReturnToCenterFlagJobs.CreateAdminSRTforJobs(stringList1);
    }    
    static testmethod void M2()
        
    {
        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466'; 
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;//SRT LIST
        List<CSS_SRT__c> srtlist = new List<CSS_SRT__c>();
        
        //Create Job
        CSS_Job_Order__c testjob=CSS_TestData.createJobOrder(false);
        testjob.Account__c=acc.id;
        insert testjob;
        String stestjobid=String.valueOf(testjob.id);
       
        //Create Sol Data
        CSS_Solutions__c sol=CSS_TestData.createSolutions(true,testjob.id);
        
        list<CSS_Solution_Component__c> solcomplist=new list<CSS_Solution_Component__c>();
        
        //Create Sol Comp Data       
        CSS_Solution_Component__c solcom1= CSS_TestData.createSRT(false,null,sol.id);
		solcom1.Type__c='CAM';
        solcom1.CampaignLaborPercentage__c = '9000099';
        solcom1.AccountCodeEdit__c = 'AccountEdit';
        solcom1.Fail_Code_Editable__c = 'FailEdit';
        //insert solcom1;
        CSS_Solution_Component__c solcom2= CSS_TestData.createSRT(false,null,sol.id);  
          solcom1.Type__c='CAM';
        solcom1.CampaignLaborPercentage__c = '900009';
        solcom1.AccountCodeEdit__c = 'Account';
        solcom1.Fail_Code_Editable__c = 'Fail';

        solcomplist.add(solcom1);
        solcomplist.add(solcom2);
        insert solcomplist;
        
        //Create Parts options list
        CSS_Parts_Options__c parts1= CSS_TestData.createParts(false,testjob.id,solcomplist[0].id,sol.id);
        parts1.ReturnToFactory__c = 'Y';
        parts1.ReturnWaiver__c=false;
        parts1.Service_Job__c=testjob.id;
        parts1.Fail_Code__c='ABBC-ASD';
        parts1.Account_Code__c='CAMPAIGN 65';
        CSS_Parts_Options__c parts2= CSS_TestData.createParts(false,testjob.id,solcomplist[1].id,sol.id);
        parts2.ReturnWaiver__c=true;
        parts2.ReturnToFactory__c = 'Y';
        parts2.Service_Job__c=testjob.id;
        parts2.Fail_Code__c='ABC-ASD';
        parts2.Account_Code__c='CHINA JV POLICY JV';
        list<CSS_Parts_Options__c> polist=new list<CSS_Parts_Options__c>();
        polist.add(parts1);
        polist.add(parts2);
        insert polist;
        
        //Create SRT Object (RTF=Y AND EXCEPTION)
        CSS_SRT__c SrtRec1=CSS_TestData.createSRT_New(false,'string typ',sol.Id,testjob.Id,null);
        SrtRec1.SRT_ID__c = '00-10S-00';
        SrtRec1.Type__c = 'Admins';
        SrtRec1.CSS_Claims__c=null;
        SrtRec1.Job_Order__c=testjob.id;
        insert SrtRec1;
        
        CSS_SRT__c SrtRec2=CSS_TestData.createSRT_New(false,'string typ',sol.Id,testjob.Id,null);
        SrtRec2.SRT_Category__c = 'AdditionalDiag';
        SrtRec2.SRT_ID__c = '00-10S-00';
        SrtRec2.Type__c = 'Admins';
        SrtRec2.Job_Order__c=testjob.id;
        insert SrtRec2;

        CSS_SRT__c SrtRec3=CSS_TestData.createSRT_New(false,'string typ',sol.Id,testjob.Id,null);
        SrtRec3.SRT_Category__c = 'AdditionalDiag';
        SrtRec3.Type__c = 'Admins';
        SrtRec3.SRT_ID__c = '00-10S-00';
        SrtRec3.Job_Order__c=testjob.id;
        insert SrtRec3;
        
        CSS_SRT__c SrtRec4=CSS_TestData.createSRT_New(false,'string typ',sol.Id,testjob.Id,null);
        SrtRec4.SRT_ID__c = '00-10S-00';
        SrtRec4.Type__c = 'Admins';
        SrtRec4.CSS_Claims__c=null;
        SrtRec4.Job_Order__c=testjob.id;
        insert SrtRec4;
       
        //Create SRT List
        srtlist.add(SrtRec1); 
        srtlist.add(SrtRec2);
        srtlist.add(SrtRec3);
        srtlist.add(SrtRec4);
        
        //Dummy string
        list<String> stringList1 = new list<String>();
        string s='N;;'+'true;;'+stestjobid+';;True';
        stringList1.add(s);
        system.debug('The Dummy string is'+stringList1);
         
        //Call the method to verify
        srtlist = CSS_WS_SRT.getAllClaimsDigRepSRTs(testjob.id,'Admin');
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        CG_CL_UpdatePartReturnToCenterFlagJobs.CreateAdminSRTforJobs(stringList1);
        delete polist;
        CG_CL_UpdatePartReturnToCenterFlagJobs.CreateAdminSRTforJobs(stringList1);
        CG_CL_UpdatePartReturnToCenterFlagJobs.callAdminSRT(testjob.id,'Admin','ABC-ASD','CHINA JV POLICY JV','test',solcom1.id);
        
        
    }
 }