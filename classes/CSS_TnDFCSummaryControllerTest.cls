@isTest(SeeAllData=True)
public class CSS_TnDFCSummaryControllerTest {
    public static CSS_Fault_Code__c createFaultCode(CSS_Job_Order__c job, String fcCode,Integer seq,String mod,String fcType,String relFC){
        CSS_Fault_Code__c fc = new CSS_Fault_Code__c(FaultCodeR2__c = fcCode,Related_Fault_Code__c = relFC);
        fc.Name = fcCode;
        fc.Job_Order__c = job.Id;
        fc.Sequence__c = seq;
        fc.Fault_Code_Type__c = fcType;
        fc.Mod__c = mod;
        fc.isPole__c = false;
        insert fc;
        return fc;
    }
    public static CSS_Solutions__c createSolutionDets(CSS_Job_Order__c job,CSS_Fault_Code__c fc, String title,String csName){
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.FaultCode__c = fc.Id;
        sol.Service_Job__c = job.Id;
        sol.Diagnostic_Response__c='Most likely the solution';
        sol.Name = csName;
        sol.Case_Name__c = csName;
        sol.Solution_Title__c = title;
        insert sol;
        return sol;
    }
    
    public static CSS_SymptomQA__c createSolutionDets1(CSS_Job_Order__c job,CSS_Fault_Code__c fc, String title,String csName){
        CSS_SymptomQA__c sol1 = new CSS_SymptomQA__c();
        sol1.Type__c='SearchString';
        sol1.Job_Order__c = job.Id;
        sol1.Name = csName;
        sol1.Number_of_Solutions__c = '7';
        sol1.isPole__c = true;
        insert sol1;
        return sol1;
    }
    public static testMethod void testJobOrderData(){
        /*CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
        jobOrder.Status__c = 'Created/Not Assigned';
        insert jobOrder;*/
        account acc = new account();
            acc.Name = 'test';
            acc.Type = 'Customer';
            acc.CSS_DistributorCode__c = '25270';
            acc.CMI_Account_Status__c = 'Active';
            acc.IAM_Service_Provider_Code__c = '25720';
            insert acc;

        CSS_Job_Order__c jobOrder = CSS_TestData.createJobOrder(True);
        jobOrder.Account__c=acc.id;
        update jobOrder;
        CSS_SymptomQA__c sym = new CSS_SymptomQA__c();
        sym.Name = 'symptom';
        sym.Job_Order__c = jobOrder.id;
        insert sym;
      
        
        CSS_Fault_Code__c fc1 = createFaultCode(jobOrder,'441',1,'0','APD-P','234,546');
        CSS_Solutions__c sol1 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol2 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solutions__c sol3 = createSolutionDets(jobOrder,fc1,'Sample Title','Sample Case Name');
        CSS_Solution_Component__c csc=new CSS_Solution_Component__c();
        csc.Action__c='test';
        csc.Component_Id__c = '123';
        csc.Name = 'solcompn';
        csc.Solutions__c=sol1.id;
        csc.Service_Job__c=jobOrder.id;
        csc.Quantity__c = 2.5;
        csc.Selected_Component__c = true;
        insert csc;
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.Solution_Number__c=sol1.id;
        srt.Job_Order__c=jobOrder.id;
        srt.Type__c = 'Diagnosis';
        srt.SRT_Time__c=0.6;
        insert srt;
        
        CSS_SRT__c srt2=new CSS_SRT__c();
        srt2.Solution_Number__c=sol1.id;
        srt2.Job_Order__c=jobOrder.id;
        srt2.Type__c = 'Repair';
        srt2.SRT_Time__c=60.0;
        srt2.isPerformed__c=true;
        insert srt2;        
        
        CSS_SRT__c srt3=new CSS_SRT__c();
        srt3.Solution_Number__c=sol2.id;
        srt3.Job_Order__c=jobOrder.id;
        srt3.Type__c = 'Repair';
        srt3.SRT_Time__c=60.0;
        insert srt3;   
        
          // CSS_Solutions__c sol = new CSS_Solutions__c();
        //sol.Diagnostic_Response__c=
        CSS_Fault_Code__c fc2 = createFaultCode(jobOrder,'221',2,'0','APD-R',null);
        CSS_Fault_Code__c fc3 = createFaultCode(jobOrder,'223',3,'0','BPD','121,131');
        CSS_TnDFCSummaryController controller = new CSS_TnDFCSummaryController();
        controller.Ins_JobId = jobOrder.id;
        controller.viewMode = 'shortView';
        controller.getFCCodes();
        system.debug('sol1: '+sol1);
        controller.getAllSolDetails();
        controller.showpanel = true;
        controller.getDiagSRTDetails();
        controller.getRepairDetails();
        controller.getRepSRTDetails();
        controller.getVerSolDetails();
        controller.getAllVerSolDetails();
        controller.getViewAllVerSolDetails();
        controller.returnToFCView();
        controller.getAllSolnCount();
        controller.navigateToRepair();
        controller.getVerSolDetailsV1();
        controller.getAllVerSolDetailsV1();
        controller.getDiagSRTDetailsV1();
        controller.getRepSRTDetailsV1();
        controller.getRepairDetailsV1();
        controller.getSolutionsV1();
        controller.getPartDetails();
        
     //   controller.getAllVerSolDetailsV1();
    }
    static testMethod void MyWrapperTestMethod() {

        CSS_TnDFCSummaryController.symQAWrapper oWrapper = new CSS_TnDFCSummaryController.symQAWrapper ();

        
    }
}