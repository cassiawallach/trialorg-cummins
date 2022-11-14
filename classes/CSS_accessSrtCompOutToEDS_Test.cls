@isTest
public class CSS_accessSrtCompOutToEDS_Test {
    public static testMethod void testSolutions() {
        CSS_Job_Order__c job1;
        CSS_Solutions__c solutions;
        List<CSS_Solutions__c> solList = new List<CSS_Solutions__c>();
        CSS_Solution_Component__c solComp;
        Set<ID> sol = new set<id>();
        job1 = new CSS_Job_Order__c(Customer_Name__c='varun',service_model__c='Test');
        solutions = new CSS_Solutions__c(Name='K21484443',Service_Job__c=job1.Id,Solution_Title__c='Test',Case_Name__c='K21484443');
        insert solutions;
        solComp = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F19000990',Solutions__c=solutions.Id,Service_Job__c=job1.id,Selected_Component__c=true); // updated component_id_c ='F19000990' for defect # 62135
        insert solComp;
        sol.add(solutions.id);
        solList.add(solutions);
        CSS_SRT__C repSRT = new CSS_SRT__C();
        repSRT.Name ='Test';
        //repSRT.Component_Id__c='F05000100';
        repSRT.SRT_Type__c='Diagnosis';
        repSRT.SRT_Title__c='Injector - Remove and Install, First, (Common Rail Fuel System)';
        repSRT.SRT_ID__c='asd';
        repSRT.SRT_Access_Code__c='asdf';
        repSRT.SRT_AccessiblityCheck__c = true;
        repSRT.Step_Description__c='hgfr';
        repSRT.SRT_Quantity__c=1;
        repSRT.isPerformed__c=True;
        repSRT.SRT_Time__c=1.1;
        repSRT.Job_Order__c = job1.id;
        repSRT.Solution_Number__c = solutions.id;
        insert repSRT;
        css_accessSrtCompOutTo_Eds eds = new css_accessSrtCompOutTo_Eds(sol,'DSBDT4760');
        eds.accessSRTs();
        eds.solComponents();
        eds.outOfOrder(solList);
        List<CSS_Fault_Code__c> fauCod = new List<CSS_Fault_Code__c>();
        CSS_Fault_Code__c fau = new CSS_Fault_Code__c();
        fau.name = '441';
        fau.Related_Fault_Code__c = '3385,2243';
        insert fau;
        fauCod.add(fau);
        eds.insiteFaultCodes(fauCod, 'dsid');
        string dummy = 'ABC';
        List<string> dummyList = new List<string>();
        dummyList.add(dummy);
        eds.srtIdDetails = dummyList;
    }
}