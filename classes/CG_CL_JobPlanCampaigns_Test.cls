/**********************************************************************
Name:CG_CL_JobPlanCampaigns_Test
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR                    DATE                DETAIL                                 
1.0     - Rajesh Pasupuleti         03/08/2018          INITIAL DEVELOPMENT 
***********************************************************************/
@isTest
public class CG_CL_JobPlanCampaigns_Test {
    public static testMethod void CG_CL_JobPlanCampaigns_Method(){
        test.startTest();
         Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Account__c=acc.id;
        JO.Customer_Name__c = 'pasupuleti';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'test';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.DSID__c = 'VFD23';
        insert JO;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Service_Job__c = Jo.id;
        solComp.Action__c = '';
        solComp.Type__c = 'Campaign';
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Status__c='Approved';
        solcomp.Complete_Indicator__c=true; 
        solcomp.Multiple_Times__c=true;
        insert solComp;
        
        CSS_Solution_Component__c solComptrp = new CSS_Solution_Component__c();
        solComptrp.Component_Id__c ='F0051000';
        solComptrp.Service_Job__c = Jo.id;
        solComptrp.Type__c = 'TRP';
        solComptrp.Campaign_Description__c = 'Hey Hai Man TRP';
        solComptrp.CampaignPartsPercentage__c = '10';
        solcomptrp.Performed_Review__c = True;
        solcomptrp.Status__c='Approved';
        solcomptrp.Complete_Indicator__c=true; 
        solcomptrp.Multiple_Times__c=true;
        insert solComptrp;
        
        CSS_Solution_Component__c solCompatc = new CSS_Solution_Component__c();
        solCompatc.Component_Id__c ='F0051000';
        solCompatc.Service_Job__c = Jo.id;
        solCompatc.Type__c = 'ATC';
        solCompatc.Campaign_Description__c = 'Hey Hai Man ATC';
        solCompatc.CampaignPartsPercentage__c = '10';
        solcompatc.Performed_Review__c = True;
        solcompatc.Status__c='Approved';
        solcompatc.Complete_Indicator__c=true; 
        solcompatc.Multiple_Times__c=true;
        insert solCompatc;
        system.debug('Solution Component:'+solCompatc);
        
        CSS_SRT__C srt = new CSS_SRT__C();
        srt.Access_Code_A__c=4;
        srt.SRT_ID__c = 'test';
        srt.Extended_Hours__c = 12323;
        srt.SRT_Estimate__c = true;
        srt.Adjustment_Reason__c = 'test';
        srt.SRT_Warrantable__c = '12';
        //srt.Repair_Access_Calculated__c = 123546;
        srt.Account_Code__c = 'test';
        srt.FailCode__c = 'test';
        srt.SRT_Time__c = 124235;
        srt.Step_Id__c = 'test';
        //srt.Diagnosis_Time__c = 15376537;
        //srt.Additional_SRT_Calculated__c = 122343;
        //srt.Repair_Time__c = 47768587;
        //srt.Diag_Access_Time__c = 343434;
        srt.SRT_AccessiblityCheck__c = true;
        srt.Type__c = 'test';
        srt.SRT_Type__c = 'test';
       // srt.SRT_Quantity__c = 3453678934;
        srt.isPerformed__c = true;
        srt.SRT_Title__c = 'test';
        srt.SRT_Notes__c = 'this i sthe test class';
        srt.SRT_Status_Message__c = 'This is the test class';
        //srt.SRT_Warrantable__c = 'test';
        srt.SRT_Order__c = 454747676;
        //srt.Job_Engine_Access_Code__c = 'test';
        srt.Access_Code_C__c = 123;
        //srt.Access_Code_Saved__c = 'test';
        srt.SRT_Category__c = 'Campaign';
        
        srt.Job_Order__c=Jo.id;
        srt.SRT_Time__c=2.0;
        srt.Type__c='campaign';
        srt.SRT_Select__c=true;
        srt.SRT_Warrantable__c='12';
        srt.Component_Id__c=solComp.id;
        srt.isPerformed__c = true;
        
        insert srt;
        string percentageCov1 = '100';
        List<CSS_SRT__c> srtlst = new List<CSS_SRT__c>();
        CSS_SRT__C srt1 = new CSS_SRT__C();
        srt1.Access_Code_A__c=3;
        //srt1.Job_Order__c=Jo.id;
        srt1.SRT_Time__c=2.0;
        srt1.Type__c='campaign';
        srt1.SRT_Select__c=true;
        srt1.SRT_Warrantable__c='12';
        srt1.Component_Id__c=solCompatc.id;
        insert srt1;
        srtlst.add(srt1);
        CSS_SRT__C srt2 = new CSS_SRT__C();
        srt2.Access_Code_A__c=2;
       // srt2.Job_Order__c=Jo.id;
        srt2.SRT_Time__c=2.0;
        srt2.Type__c='campaign';
        srt2.SRT_Select__c=true;
        srt2.SRT_Warrantable__c='12';
        srt2.Job_Order__c = solCompatc.Service_Job__c;
        srt2.Component_Id__c=solCompatc.id;
        insert srt2;
        
         CSS_SRT__C srt5 = new CSS_SRT__C();
        srt5.Access_Code_A__c=3;
        srt5.Job_Order__c=Jo.id;
        srt5.SRT_Time__c=2.0;
        srt5.srt_category__c='campaign';
        srt5.isPopupSRT__c=true;
        srt5.Solution_Number__c=null;
        srt5.Component_Id__c=null;
        srt5.isPerformed__c=true;
        insert srt5;
        
        
       CSS_srt__C srt6 = new CSS_srt__C();
        srt6.Access_Code_A__c=4;
        srt6.srt_ID__c = 'test';
        srt6.Extended_Hours__c = 12323;
        srt6.srt_Estimate__c = true;
        srt6.Adjustment_Reason__c = 'test';
        srt6.SRT_Warrantable__c = '12';
        //srt6.Repair_Access_Calculated__c = 123546;
        srt6.Account_Code__c = 'test';
        srt6.FailCode__c = 'test';
        srt6.srt_Time__c = 124235;
        srt6.Step_Id__c = 'test';
        //srt6.Diagnosis_Time__c = 15376537;
        //srt6.Additional_srt6_Calculated__c = 122343;
        //srt6.Repair_Time__c = 47768587;
        //srt6.Diag_Access_Time__c = 343434;
        srt6.srt_AccessiblityCheck__c = true;
        srt6.Type__c = 'test';
        srt6.srt_Type__c = 'test';
       // srt6.srt6_Quantity__c = 3453678934;
        srt6.isPerformed__c = true;
        srt6.srt_Title__c = 'test';
        srt6.srt_Notes__c = 'this i sthe test class';
        srt6.srt_Status_Message__c = 'This is the test class';
        srt6.srt_Warrantable__c = 'test';
        srt6.srt_Order__c = 454747676;
        //srt6.Job_Engine_Access_Code__c = 'test';
        srt6.Access_Code_C__c = 123;
        //srt6.Access_Code_Saved__c = 'test';
        srt6.srt_Category__c = 'TRP';
        
        srt6.Job_Order__c=Jo.id;
        srt6.srt_Time__c=2.0;
        srt6.Type__c='Field Action Access';
        srt6.srt_Select__c=true;
        srt6.SRT_Warrantable__c='12';
        srt6.Component_Id__c=solComptrp.id;
        srt6.isPerformed__c = true;
        
        insert srt6;
        
        CSS_SRT__C srtv = new CSS_SRT__C();
        srtv.Access_Code_A__c=3;
        srtv.Job_Order__c=Jo.id;
        srtv.SRT_Time__c=2.0;
        srtv.srt_category__c='TRP';
        srtv.isPopupSRT__c=true;
        srtv.Solution_Number__c=null;
        srtv.Component_Id__c=null;
        srtv.isPerformed__c=true;
        insert srtv;
        
        CSS_SRT__C srte = new CSS_SRT__C();
        srte.Access_Code_A__c=3;
        srte.Job_Order__c=Jo.id;
        srte.SRT_Time__c=2.0;
        srte.srt_category__c='ATC';
        srte.isPopupSRT__c=true;
        srte.Solution_Number__c=null;
        srte.Component_Id__c=null;
        srte.isPerformed__c=true;
        insert srte;
        
        CSS_SRT__C srt9 = new CSS_SRT__C();
        //srt.Job_Order__c=4;
        srt.Job_Order__c=Jo.id;
        srt.Solution_Number__c=null;
        //srt.component_id__c=null;
        srt.isPopupSRT__c=true;
        srt.SRT_Warrantable__c='12';
        srt.Component_Id__c=solComptrp.id;
        srt.isPerformed__c = true;
        
        insert srt9;
        list<selectoption> option = new list<selectoption>();
        option.add(new selectOption(('----Select One----'),('----Select One----')));
        option.add(new selectOption(('Not Justified Per Failure Code'),('Not Justified Per Failure Code')));
        option.add(new selectOption(('Partial Re-Assembly'),('Partial Re-Assembly')));
        option.add(new selectOption(('Penalty'),('Penalty')));
        option.add(new selectOption(('Travel SRT’s Incorrectly Used'),('Travel SRT’s Incorrectly Used')));
        //return option;
        list<CG_CL_JobPlanCampaigns.srtWrapper> pwlist=new list<CG_CL_JobPlanCampaigns.srtWrapper>();
                                                                                          
        CG_CL_JobPlanCampaigns.srtWrapper srtwrap = new  CG_CL_JobPlanCampaigns.srtWrapper(srt1.id,'SRTCode','SRTDescription',123.1,'ACCESSSRTTime',1.2,'AccessCode','SRTHours','AdjustmentReason',true,true,2,'100','type','20.0','jobAccessCode','A','B','C','D','R',true,true,'test','test1','test2',true);
        pwlist.add(srtwrap);
        string fan;
        integer srtcount;
        
        
        List<CG_CL_JobPlanCampaigns.TRPsrtWrapper> lsttrpsrtwra = new List<CG_CL_JobPlanCampaigns.TRPsrtWrapper>();
        CG_CL_JobPlanCampaigns.TRPsrtWrapper trpsrtwra = new CG_CL_JobPlanCampaigns.TRPsrtWrapper(srt1.id,'SRTCode','SRTDescription',2,'ACCESSSRTTime',2,'AccessCode','SRTHours','AdjustmentReason',true,true,2,'23','campaign','3','jobAccessCode','A','B','C','D','R',true,true,'test','test1','test2',true);    
        lsttrpsrtwra.add(trpsrtwra);
        
        CG_CL_JobPlanCampaigns.TRPCompWrapper trpWrap = new CG_CL_JobPlanCampaigns.TRPCompWrapper(solComptrp.id,'test',lsttrpsrtwra,2);
      
        
        List<CG_CL_JobPlanCampaigns.ATCsrtWrapper> lstatcsrtwra = new List<CG_CL_JobPlanCampaigns.ATCsrtWrapper>();
        CG_CL_JobPlanCampaigns.ATCsrtWrapper atcsrtwra = new CG_CL_JobPlanCampaigns.ATCsrtWrapper(srt2.id,'SRTCode','SRTDescription',2,'ACCESSSRTTime',2,'AccessCode','SRTHours','AdjustmentReason',true,true,2,'23','campaign','3','jobAccessCode','A','B','C','D','R',true,true,'test','test1','test2',true);    
        lstatcsrtwra.add(atcsrtwra);
        
        
        CG_CL_JobPlanCampaigns.ATCCompWrapper atcwrap = new CG_CL_JobPlanCampaigns.ATCCompWrapper(solComptrp.id,'test',lstatcsrtwra,2);
        
        CG_CL_JobPlanCampaigns.srtWrapper Dh = new CG_CL_JobPlanCampaigns.srtWrapper(srt.Id,'RTCode','SRTDescription',2.0,'ACCESSSRTTime',2.0,'AccessCode','SRTHours','AdjustmentReason',true,true,2,'23','SRT','10.0','jobAccessCode','A','B','C','D','R',true,true,'test','test1','test2',true);
        pwlist.add(Dh);
        List<CG_CL_JobPlanCampaigns.CompWrapper> lstcompwrap = new List<CG_CL_JobPlanCampaigns.CompWrapper>();
        CG_CL_JobPlanCampaigns.CompWrapper comwra = new CG_CL_JobPlanCampaigns.CompWrapper(solComptrp.id,fan,pwlist,2);
        lstcompwrap.add(comwra);
        system.debug('lstcompwrap--->'+lstcompwrap);
        ApexPages.currentPage().getParameters().put('id',JO.id);
        
        
        CG_CL_JobPlanCampaigns campaign = new CG_CL_JobPlanCampaigns();
        campaign.checkBoxSelected=true;
        campaign.addlistcompwrapper = lstcompwrap;
        campaign.additionalSRTList = srtlst;
        campaign.getAllCampSrtsData();
        campaign.getAllTRPSrtsData();
        campaign.getAllATCSrtsData();
        campaign.saveALLSRTData();
        campaign.getAdjustmentReason();
        campaign.ResetALLSRTData();
        campaign.getCampaignSRTTime();
        campaign.getTRPSRTTime();
        campaign.getATCSRTTime();
        campaign.NotesPopupOkTRP();
        campaign.callAccessStepDetailsATC();
        campaign.callAccessStepDetailsCampaigns();
        test.stopTest();
    }
    public static testMethod void CG_CL_JobPlanCampaigns_Method1(){
         Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
       CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        jo.Account__c=acc.id;
        update jo;
        List<CSS_SRT__c> srtlst = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        //srt.Job_Order__c=4;
        srt.Job_Order__c=jo.id;
        srt.Solution_Number__c=null;
        srt.component_id__c=null;
        srt.isPopupSRT__c=true;
        srt.SRT_Warrantable__c='12';
        //srt.Component_Id__c=solCompatc.id;
        //srt.isPerformed__c = true;
        
        insert srt;
        srtlst.add(srt);
        CG_CL_JobPlanCampaigns jobplanCamp = new CG_CL_JobPlanCampaigns();
        jobplanCamp.additionalSRTList = srtlst;
        jobplanCamp.getAllATCSrtsData();
        jobplanCamp.getAllCampSrtsData();
        jobplanCamp.getAllTRPSrtsData();
    }
    public static testMethod void CG_CL_JobPlanCampaigns_Method12(){
         Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Other';
        insert acc;
       CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        jo.Account__c=acc.id;
        update jo;
        List<CSS_SRT__c> srtlst = new List<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c();
        //srt.Job_Order__c=4;
        srt.Job_Order__c=jo.id;
        srt.srt_category__c = 'TRP';
        srt.Solution_Number__c=null;
        srt.component_id__c=null;
        srt.isPopupSRT__c=true;
        srt.SRT_Warrantable__c='12';
        //srt.Component_Id__c=solCompatc.id;
        //srt.isPerformed__c = true;
        
        insert srt;
        srtlst.add(srt);
        CG_CL_JobPlanCampaigns jobplanCamp = new CG_CL_JobPlanCampaigns();
        jobplanCamp.additionalSRTList = srtlst;
        jobplanCamp.getAllATCSrtsData();
        jobplanCamp.getAllCampSrtsData();
        jobplanCamp.getAllTRPSrtsData();
    }
}