@isTest
public class CG_CL_TotalSRTHoursCalculation_Test {
    
   public  static testmethod void m1(){
        test.startTest();
        css_job_order__c jo1 = new css_job_order__c();
        jo1.Customer_Name__c='Gopal';
        jo1.Customer_Code__c='123';
        jo1.ESN__c='53426754';
        insert jo1;
        
        css_claims__c clams = new css_claims__c();
        clams.Customer_Name__c='Gopal';
        clams.Customer_Code__c='123';
        clams.ESN__c='53426754';
        clams.CSS_Job__c=jo1.Id;
        clams.Actual_Technician_Time__c=2.0;
        insert clams;
        
        css_psn__c psn1 = new css_psn__c();
        psn1.PSN__c='53426754';
        psn1.CSS_Claims__c=clams.Id;
        psn1.Warranty_Start_Date__c=system.today();
        psn1.Primary__c=true;
        insert psn1;
        
        list<CSS_SRT__c> srtlst = new list<CSS_SRT__c>();
        
        css_srt__c srt12 = new css_srt__c();
        srt12.CSS_Claims__c=clams.Id;
        srt12.Step_Id__c='1';
        srt12.Type__c='Diagnosis';
       	srt12.Extended_Hours__c=2.0;
       // insert srt12;
        srtlst.add(srt12);
          css_srt__c srt13 = new css_srt__c();
        srt13.CSS_Claims__c=clams.Id;
        srt13.Step_Id__c='1';
        srt13.Type__c='Repair';
       srt13.Extended_Hours__c=2.0;
        //insert srt13;
        srtlst.add(srt13);
         css_srt__c srt14 = new css_srt__c();
        srt14.CSS_Claims__c=clams.Id;
        srt14.Step_Id__c='1';
        srt14.Type__c='Overlap';
        srt14.Extended_Hours__c=2.0;
        //insert srt14;
        srtlst.add(srt14);
           css_srt__c srt15 = new css_srt__c();
        srt15.CSS_Claims__c=clams.Id;
        srt15.Step_Id__c='1';
        srt15.Type__c='Field Action';
        srt15.Extended_Hours__c=2.0;
        //insert srt15;
        srtlst.add(srt15);
        
        list<CSS_SRT__c> srtlst1 = new list<CSS_SRT__c>();
        
        css_srt__c srt1 = new css_srt__c();
        srt1.CSS_Claims__c=clams.Id;
        srt1.Step_Id__c='1';
        srt1.Type__c='Diagnosis';
       	srt1.Extended_Hours__c=0.6;
        //insert srt1;
        srtlst1.add(srt1);
       
        
        css_srt__c srt5 = new css_srt__c();
        srt5.CSS_Claims__c=clams.Id;
        srt5.Step_Id__c='1';
        srt5.Type__c='Field Action';
       srt5.Extended_Hours__c=0.6;
        //insert srt5;
       
        srtlst1.add(srt5);
        
	 CG_CL_TotalSRTHoursCalculation obj = new CG_CL_TotalSRTHoursCalculation();
      CG_CL_TotalSRTHoursCalculation.CalcualteExthrs(srtlst,srtlst1,jo1.id,clams.id);
        test.stopTest();
        
    }
    public static testmethod void m2(){
        css_job_order__c jo1 = new css_job_order__c();
        jo1.Customer_Name__c='Gopal';
        jo1.Customer_Code__c='123';
        jo1.ESN__c='53426754';
        insert jo1;
        
        css_claims__c clams = new css_claims__c();
        clams.Customer_Name__c='Gopal';
        clams.Customer_Code__c='123';
        clams.ESN__c='53426754';
        clams.CSS_Job__c=jo1.Id;
        clams.Actual_Technician_Time__c=2.0;
        insert clams;
        
        list<CSS_SRT__c> srtlst = new list<CSS_SRT__c>();
        list<CSS_SRT__c> srtlst1 = new list<CSS_SRT__c>();
        
        CG_CL_TotalSRTHoursCalculation.CalcualteExthrs(srtlst,srtlst1,jo1.id,clams.id);
    }

}