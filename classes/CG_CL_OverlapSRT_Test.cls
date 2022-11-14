@istest
public class CG_CL_OverlapSRT_Test {
    
    static testmethod void testmethod1(){
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Account__c = acc.id;
        jo.Customer_Name__c='';
        jo.Customer_Code__c='123';
        jo.ESN__c='65464353';
        insert jo;
        
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Account__c = acc.id;
        claims.Customer_Name__c='';
        claims.Customer_Code__c='123';
        claims.CSS_Job__c=jo.Id;
        insert claims;
        
        CSS_SRT__c srt = new CSS_SRT__c ();
        srt.SRT_ID__c='';
        srt.Overlap_Hours__c=1.0;
        srt.OverrideReason__c = 'test';
        srt.Override__c=true;
        srt.Adjusted_Overlap_Hours__c=0.3;
        srt.Account_Code__c='CMP – Field Actions 65';
        srt.Type__c='Overlap';
        srt.CSS_Claims__c=claims.id;
        insert srt;
        
        apexpages.currentPage().getparameters().put('id',claims.Id);
        
        test.startTest();
        
        CG_CL_OverlapSRT Overlap = new CG_CL_OverlapSRT();
        //  Overlap.createOverlapMap();
        PageReference pg = Page.CG_ClaimsSRTs;
        Test.setCurrentPage(pg);      
        overlap.selectedAcCode = 'Customer Billable';
        // String tempAccountCode;
        // tempAccountCode='test';
        //overlap.accountCodeWithOverlapMap = overlap.tempAccountCode;
        overlap.overlapsrtinvoke();
        overlap.enableHrsReason();
        overlap.totalOverlapHours();
        overlap.loadOverlapSRTs();
        //Overlap.createOverlapMap();
        string SRT_OverrideReason = 'test';
        boolean overlapSRTExist = false;
        boolean adjHrsFlg = false;
        Boolean notesFlg = false;
        Boolean overrideReasonFlg = false;
        
        
        // CG_CL_OverlapSRT.overLapSrtSubWrapper wrap = new CG_CL_OverlapSRT.overLapSrtSubWrapper('test',0.2,true,'Srt adj','srt over',claims.id,true,1);
        string SRT_Code;
        string accountCode;
        overlap.savOverlapSRT();
        test.stopTest();
    }
    
    static testmethod void testmethod2(){
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Account__c = acc.id;
        jo.Customer_Name__c='';
        jo.Customer_Code__c='123';
        jo.ESN__c='65464353';
        insert jo;
        
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Account__c = acc.id;
        claims.Customer_Name__c='';
        claims.Customer_Code__c='123';
        claims.CSS_Job__c=jo.Id;
        insert claims;
        list<CSS_SRT__c> lst1 = new list<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c ();
        srt.SRT_ID__c='10-123';
        srt.Overlap_Hours__c=1.0;
        srt.Override__c=false;
        srt.Adjusted_Overlap_Hours__c=0.3;
        srt.Type__c='Overlap';
        srt.CSS_Claims__c=claims.id;
        srt.Account_Code__c='Customer Billable';
        insert srt;
        lst1.add(srt); 
        
        CSS_SRT__c srt1 = new CSS_SRT__c ();
        srt1.SRT_ID__c='10-123';
        srt1.Overlap_Hours__c=1.0;
        srt1.Override__c=false;
        srt1.Adjusted_Overlap_Hours__c=0.3;
        srt1.Type__c='Overlap';
        srt1.CSS_Claims__c=claims.id;
        srt1.Account_Code__c='Customer Billable';
        insert srt1;
        lst1.add(srt1); 
        CSS_SRT__c srt2 = new CSS_SRT__c ();
        srt2.SRT_ID__c='10-123';
        srt2.Overlap_Hours__c=1.0;
        srt2.Override__c=true;
        srt2.Adjusted_Overlap_Hours__c=0.3;
        srt2.Type__c='Overlap';
        srt2.CSS_Claims__c=claims.id;
        srt2.Account_Code__c='Customer Billable';
        insert srt2;
        lst1.add(srt2); 
        
        CSS_SRT__c srt11 = new CSS_SRT__c ();
        srt11.SRT_ID__c='10-123';
        srt11.Overlap_Hours__c=1.0;
        srt11.Override__c=true;
        srt11.Adjusted_Overlap_Hours__c=0.3;
        srt11.Type__c='Overlap';
        srt11.CSS_Claims__c=claims.id;
        srt11.Account_Code__c='Customer Billable';
        insert srt11;
        lst1.add(srt11); 
        apexpages.currentPage().getparameters().put('id',claims.Id);
        
        // test.startTest();
        
        CG_CL_OverlapSRT Overlap = new CG_CL_OverlapSRT();
        string temacccode = 'Customer Billable';
        
        Map<String,List<CG_CL_OverlapSRT.overLapSrtWrapper>> accountCodeWithOverlapMap = new Map<String,List<CG_CL_OverlapSRT.overLapSrtWrapper>>();
        
        list<CG_CL_OverlapSRT.overLapSrtWrapper> wraplist1 = new list<CG_CL_OverlapSRT.overLapSrtWrapper>(); 
        // CG_CL_OverlapSRT.overLapSrtWrapper wrap2 = new CG_CL_OverlapSRT.overLapSrtWrapper(lst1.SRT_ID__c,temacccode,wrap);
        
        list<CG_CL_OverlapSRT.overLapSrtSubWrapper> wraplist = new list<CG_CL_OverlapSRT.overLapSrtSubWrapper>();
        CG_CL_OverlapSRT.overLapSrtSubWrapper wrap = new CG_CL_OverlapSRT.overLapSrtSubWrapper('overlapWithSRT', 2.0, true, 'SRT_AdjOverlapHrs', 'SRT_OverrideReason',claims.id, true,'overrideReason', true, true, true, 1,'OverlapsrtDescription','OverlapstepID') ;
        CG_CL_OverlapSRT.overLapSrtSubWrapper wrap1 = new CG_CL_OverlapSRT.overLapSrtSubWrapper('overlapWithSRT', 2.0, true, null, null,claims.id, true,'overrideReason', true, true, true, 1,'OverlapsrtDescription','OverlapstepID') ;
        wraplist.add(wrap);
        wraplist.add(wrap1);
        CG_CL_OverlapSRT.overLapSrtWrapper wrap2 = new CG_CL_OverlapSRT.overLapSrtWrapper(lst1[0].SRT_ID__c,temacccode,wraplist,'srtDescription','stepID');
        
        wraplist1.add(wrap2);
        accountCodeWithOverlapMap.put(temacccode, wraplist1);
        // test.stopTest();
        
        PageReference pg = Page.CG_ClaimsSRTs;
        Test.setCurrentPage(pg);      
        overlap.selectedAcCode = 'Customer Billable';
        overlap.selectedSRT = '10-123';
        overlap.getOverrideReasonList();
        overlap.overlapsrtinvoke();
        
        overlap.enableHrsReason();
        overlap.savOverlapSRT();
        overlap.totalOverlapHours();
        overlap.loadOverlapSRTs();
        overlap.isOverride=true;
        overlap.enableHrsReason();
        list<CG_CL_OverlapSRT.overLapSrtSubWrapper> wraplist10 = new list<CG_CL_OverlapSRT.overLapSrtSubWrapper>();
        CG_CL_OverlapSRT.overLapSrtSubWrapper wrap11 = new CG_CL_OverlapSRT.overLapSrtSubWrapper('overlapWithSRT', 2.0, true, null, null,claims.id, true,'overrideReason', true, true, true, 1,'OverlapsrtDescription','OverlapstepID') ;
        
        wraplist10.add(wrap11);
        CG_CL_OverlapSRT.overLapSrtWrapper wrap22 = new CG_CL_OverlapSRT.overLapSrtWrapper(lst1[0].SRT_ID__c,temacccode,wraplist10,'srtDescription','stepID');
        list<CG_CL_OverlapSRT.overLapSrtWrapper> wraplist11 = new list<CG_CL_OverlapSRT.overLapSrtWrapper>(); 
        wraplist11.add(wrap22);
        accountCodeWithOverlapMap.put(temacccode, wraplist11);
        overlap.savOverlapSRT();
        // Overlap.createOverlapMap();
        //overlap.accountCodeWithOverlapMap = 
        
    }
    
    static testmethod void  overlap1(){
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Customer_Name__c='';
        claims.Customer_Code__c='123';
        //claims.CSS_Job__c=jo.Id;
        insert claims;
        list<CG_CL_OverlapSRT.overLapSrtSubWrapper> listwrap=new list<CG_CL_OverlapSRT.overLapSrtSubWrapper>();
        CG_CL_OverlapSRT.overLapSrtSubWrapper wrap =new CG_CL_OverlapSRT.overLapSrtSubWrapper('overlapWithSRT',2.0,true,'SRT_AdjOverlapHrs','SRT_OverrideReason',claims.id,true,'overrideReason',true,true,true,10,'OverlapsrtDescription','OverlapstepID');
        CG_CL_OverlapSRT.overLapSrtSubWrapper wrap1 = new CG_CL_OverlapSRT.overLapSrtSubWrapper('overlapWithSRT',2.0,true,'SRT_AdjOverlapHrs','SRT_OverrideReason',claims.id,true,'overrideReason',true,true,true,1,'OverlapsrtDescription','OverlapstepID') ; 
        listwrap.add(wrap);
        listwrap.add(wrap1);
        system.debug('listwrap**'+listwrap.size());
        list<CG_CL_OverlapSRT.overLapSrtWrapper> listsrt=new list<CG_CL_OverlapSRT.overLapSrtWrapper>();
        CG_CL_OverlapSRT.overLapSrtWrapper srtw=new CG_CL_OverlapSRT.overLapSrtWrapper('SRT_Code','',listwrap,'srtDescription','stepID');
        CG_CL_OverlapSRT.overLapSrtWrapper srtw1=new CG_CL_OverlapSRT.overLapSrtWrapper('SRT_Code','accCode',listwrap,'srtDescription','stepID');
        listsrt.add(srtw);
        listsrt.add(srtw1);
        system.debug('listsrt**'+listsrt.size());
        CG_CL_OverlapSRT overlap = new CG_CL_OverlapSRT();
        overlap.lstOverlapSRTWrapper=listsrt;
        overlap.isOverride=true;
        overlap.enableHrsReason();
        //overlap.savOverlapSRT();
        overlap.loadOverlapSRTs();
        overlap.lstOverlapSRTWrapper=listsrt;
        overlap.createOverlapMap(); 
        //overlap.savOverlapSRT();
    } 
    
    static testmethod void  overlap2(){
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.Account__c = acc.id;
        jo.Customer_Name__c='';
        jo.Customer_Code__c='123';
        jo.ESN__c='65464353';
        insert jo;
        
        CSS_Claims__c claims = new CSS_Claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='';
        claims.Customer_Code__c='123';
        claims.CSS_Job__c=jo.Id;
        insert claims;
        list<CSS_SRT__c> lst1 = new list<CSS_SRT__c>();
        CSS_SRT__c srt = new CSS_SRT__c ();
        srt.SRT_ID__c='10-123';
        srt.Overlap_Hours__c=1.0;
        srt.Override__c=false;
        srt.Adjusted_Overlap_Hours__c=0.3;
        srt.Type__c='Overlap';
        srt.CSS_Claims__c=claims.id;
        srt.Account_Code__c='Customer Billable';
        insert srt;
        lst1.add(srt);
        
        CG_CL_OverlapSRT Overlap = new CG_CL_OverlapSRT();
        string temacccode = 'Customer Billable';
        
        Map<String,List<CG_CL_OverlapSRT.overLapSrtWrapper>> accountCodeWithOverlapMap = new Map<String,List<CG_CL_OverlapSRT.overLapSrtWrapper>>();
        
        list<CG_CL_OverlapSRT.overLapSrtWrapper> wraplist1 = new list<CG_CL_OverlapSRT.overLapSrtWrapper>(); 
        // CG_CL_OverlapSRT.overLapSrtWrapper wrap2 = new CG_CL_OverlapSRT.overLapSrtWrapper(lst1.SRT_ID__c,temacccode,wrap);
        
        list<CG_CL_OverlapSRT.overLapSrtSubWrapper> wraplist = new list<CG_CL_OverlapSRT.overLapSrtSubWrapper>();
        CG_CL_OverlapSRT.overLapSrtSubWrapper wrap = new CG_CL_OverlapSRT.overLapSrtSubWrapper('overlapWithSRT', 2.0, true, 'xyz', 'SRT_OverrideReason',claims.id, true,'overrideReason', true, true, true, 1,'OverlapsrtDescription','OverlapstepID') ;
        wraplist.add(wrap);
        CG_CL_OverlapSRT.overLapSrtWrapper wrap2 = new CG_CL_OverlapSRT.overLapSrtWrapper(lst1[0].SRT_ID__c,temacccode,wraplist,'srtDescription','stepID');
        
        wraplist1.add(wrap2);
        accountCodeWithOverlapMap.put(temacccode, wraplist1);
        Overlap.isOverride=true;
        Overlap.enableHrsReason();
        Overlap.loadOverlapSRTs();
        Overlap.createOverlapMap();
        // overlap.savOverlapSRT();
    }
    
}