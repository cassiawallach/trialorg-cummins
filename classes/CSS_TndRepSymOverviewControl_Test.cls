@isTest 
public class CSS_TndRepSymOverviewControl_Test {
    
   public static testMethod void CSS_TndRepSymOverviewControl_Test_Method1(){
        Test.startTest();
                   Account ac = new Account();
            ac.name='Kenworth Sales Co';
            ac.CSS_DistributorCode__c='02466';
            ac.IAM_Service_Provider_Code__c='19134';
            ac.Type='Dealer Account';
            ac.CMI_Account_Status__c = 'Active';
            insert ac;

        //Service job object
        CSS_Job_Order__c job= new CSS_Job_Order__c();
       job.Account__c=ac.Id;
        job.esn__c='12345';
       
        job.INSITE_UpdateTimeStamp__c =system.today();
        job.INSITE_ESN_Choice__c='Not Selected';
        job.DSID__c='2323';
        job.ESN__c ='21323';
        job.Application__c='asdd';
        job.Unit_Number__c='213';
        job.Failure_Point__c=213.00;
        job.Failure_Point_Measure__c='asd';
        job.Make__c='Make';
        job.Model__c='Model';
        job.Equipment_ID__c='Equip';
        job.Customer_Name__c='Peterbuilt';
        job.Shop_Work_Order__c='213dssd';
        job.Service_Model__c='SMNNUM';
        job.DSID_Creation_Timestamp__c=system.today();
        job.DSID_Status__c='Stat';
        job.DSID_WorkGroup__c='Wrkgrp';
        insert job;
         
        //Symptom QA object
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        sym.Job_Order__c=job.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =job.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='Do you see smoke';
        sym.Type__c  ='SearchString';
        insert sym; 
        
        //Symptom QA object
        CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
        sym.Job_Order__c=job.id;
        sym.caption__c ='fault Code';
        sym.Option1__c  ='12213';
        sym.Job_Order__c  =job.id;
        sym.SearchString__c  =sym.id;        
        sym.Type__c  ='QA';
        insert symQA;
        

        //Solution object
        CSS_Solutions__c sol=new CSS_Solutions__c();
        sol.Case_Name__c='test';
        sol.Diagnostic_Response__c='test';
        sol.Repair_Response__c='test';
        sol.Symptom__c=sym.id;
        sol.Service_Job__c=job.id;
        insert sol;
        
        //Solution component object
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Solutions__c=sol.id;
        csc.Service_Job__c=job.id;
        csc.Selected_Component__c = true;
        insert csc;
        
        //SRT object
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol.id;
        srt.Job_Order__c=job.id;
        srt.Type__c = 'Diagnosis';
        srt.Component_Id__c = csc.id;
        srt.SRT_Time__c=0.6;
        srt.isPerformed__c = true;
        //srt.Diagnosis_Time__c=0.6;
        insert srt;
        
        CSS_SRT__c srt1=new CSS_SRT__c();
        srt1.Solution_Number__c=sol.id;
        srt1.Job_Order__c=job.id;
        srt1.Type__c = 'Diagnosis';
        srt1.SRT_Time__c=2.0;
        srt1.Component_Id__c = csc.id;
        srt1.isPerformed__c = true;
        //srt.Diagnosis_Time__c=0.6;
        insert srt1;
        
        CSS_SRT__c srtRep=new CSS_SRT__c();
        srtRep.Solution_Number__c=sol.id;
        srtRep.Job_Order__c=job.id;
        srtRep.Type__c = 'Repair';
        srtRep.isPerformed__c = true;
        srtRep.SRT_Time__c=0.6;
        srtRep.Component_Id__c = csc.id;
        insert srtRep;
        
        CSS_SRT__c srtRep1=new CSS_SRT__c();
        srtRep1.Solution_Number__c=sol.id;
        srtRep1.Job_Order__c=job.id;
        srtRep1.Type__c = 'Repair';
        srtRep1.Component_Id__c = csc.id;
        srtRep1.isPerformed__c = true;
        srtRep1.SRT_Time__c=3.0;
        insert srtRep1;
        
        List<CSS_SymptomQA__c> symList=new List<CSS_SymptomQA__c>();
        List<CSS_SymptomQA__c> symList1=new List<CSS_SymptomQA__c>();
        List<CSS_Solutions__c> solList=new List<CSS_Solutions__c>();
        List<CSS_Solution_Component__c> solComps  = new List<CSS_Solution_Component__c>();
        List<CSS_SRT__c> srts = new List<CSS_SRT__c>();
        List<CSS_SRT__c> srtsRep = new List<CSS_SRT__c>();
        
        symList.add(symQA);
        solList.add(sol);
        solComps.add(csc);
		srts.add(srt);
        srts.add(srt1);
        srtsRep.add(srtRep);
        srtsRep.add(srtRep1);
        
        
         List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
                solcomp.Name = 'solcomp';
                solcomp.Service_Job__c=job.id;
                solcomp.System_Code__c='TH';
                solcomp.Component_Code__c='AC';
                solcomp.Failure_Mode__c='BT';
                solcomp.AccountCode__c = 'SERVICE TOOL WARRANTY 52';//wil inturn be the account Formula
                solcomp.Type__c = null;
                solcomp.Selected_Component__c = true;
                solcomp.Customer_Take_Possession__c = 'yes';
                solcomp.Part_Warranty_Start_Date__c = system.today() - 30;
                solcomp.Failure_Date__c = system.today();
                solcomp.Failure_Point__c = 20;
                solcomp.Failure_Measure__c = 'Miles';
                insert solcomp;
                lstsolcomp.add(solcomp);
                
                //system.debug ('CSS_Account_Formula__c1--'+solcomp.CSS_Account_Formula__c);
                
            CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();
                solcomp1.Name = 'solcomp1';
                solcomp1.Service_Job__c=job.id;
                solcomp1.System_Code__c='TH';
                solcomp1.Component_Code__c='AS';
                solcomp1.Failure_Mode__c='BT';
                solcomp1.AccountCode__c = 'SERVICE TOOL WARRANTY 52';
                solcomp1.Type__c = null;
                solcomp1.Selected_Component__c = true;
                insert solcomp1;
                lstsolcomp.add(solcomp1); 
               
                //system.debug ('CSS_Account_Formula__c2--'+solcomp1.CSS_Account_Formula__c);
                
             //For fetchClaimRecords Coverage Limit code   
             CSS_Solution_Component__c solcomp2 = new CSS_Solution_Component__c();
                solcomp2.Name = 'solcomp2';
                solcomp2.Service_Job__c=job.id;
                solcomp2.System_Code__c='FH';
                solcomp2.Component_Code__c='AS';
                solcomp2.Failure_Mode__c='BT';
                solcomp2.AccountCode__c = 'SERVICE TOOL WARRANTY 52';
                solcomp2.Type__c = null;
                solcomp2.Selected_Component__c = true;
                solcomp2.Status__c='Approved';
                solcomp2.CoverageLimitExceedMsg_Status__c = 'ERROR';
                solcomp2.CoverageTravelBaseFareMsgTstatus__c = 'ERROR';
                solcomp2.AccountCode_Call_Status__c = 'Failure';
                solcomp2.CoverageLimitExceedMsgSRT_Status__c ='ERROR';
                insert solcomp2;
                lstsolcomp.add(solcomp2);
                
                    
            
           //Part Option list
            List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
            CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
                parts.Service_Job__c=job.id;
                parts.FailurepartId__c = solcomp.id;
                parts.Account_Code__c='SERVICE TOOL WARRANTY 52';
                parts.Fail_Code__c = 'THAC';
                parts.selected_part__c = True;
                lstparts.add(parts);
                system.debug('parts.Fail_Code__c'+parts.Fail_Code__c);
            
            
            CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
                parts1.selected_part__c = True;
                parts1.FailurepartId__c = solcomp.id;
                parts1.Service_Job__c=job.id;
                parts1.Account_Code__c='SERVICE TOOL WARRANTY 52';
                parts1.Fail_Code__c = 'THAS';
                lstparts.add(parts1);
                insert lstparts;
                system.debug('parts1.Fail_Code__c'+parts1.Fail_Code__c);
                
                
        
        
        
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id',job.id);    
        pageRef.getParameters().put('symid',symQA.id); 
        
        CSS_TndRepSymOverviewControl  tndSym ;
        tndSym =new CSS_TndRepSymOverviewControl(); 
        tndSym.lstCompForSol = lstsolcomp;
        
        
            tndSym.getAllSolnCount();             
            tndSym.showSolutions();
            tndSym.getAllSolDetails();
            tndSym.getVerSolDetails();
            tndSym.getDiagSRTDetails();
            tndSym.getRepSRTDetails();
       		tndSym.getRepairDetails();
       		tndSym.getSolutions();
       		tndSym.getPartDetails();
          
         Test.stopTest();
        
    }

}