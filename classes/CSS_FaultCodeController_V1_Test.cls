@isTest
public class CSS_FaultCodeController_V1_Test {
    static testMethod void test(){
       // boolean isPrioritized;
       
        CSS_Job_Order__c cjo = new CSS_Job_Order__c();
        cjo.Customer_Name__c = 'varun';
        cjo.DSID_UpdateTimestamp__c=System.now();
        cjo.INSITE_UpdateTimeStamp__c=System.now();
        insert cjo;		
        CSS_Fault_Code_Master__c fcmaster = new CSS_Fault_Code_Master__c();
        //fcmaster.Circuit_Description__c = 'test';
        fcmaster.Fault_Code_Description__c ='Ttest1';
        insert fcmaster;
        List<CSS_Fault_Code__c> lstfault = new List<CSS_Fault_Code__c>();
        CSS_Fault_Code__c fau = new CSS_Fault_Code__c();
        fau.Job_Order__c = cjo.id;
        fau.Sequence__c=30;
        fau.Primary_Fault_Code__c =145;
        fau.Related_Fault_Code__c='150,151,152';
        fau.Fault_Code_Type__c='APD';
        fau.Fault_Code__c = fcmaster.Id;
		lstfault.add(fau);
        insert lstfault;
        CSS_FaultcodeController_V1 fc = new CSS_FaultcodeController_V1();
        fc.setJobID(cjo.Id);
        fc.getJobID();
        fc.isPrioritized=false;
        CSS_Solutions__c so = new CSS_Solutions__c();
        so.name = 'Repair not performed';
        so.Service_Job__c = cjo.id;
        insert so;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        Test.startTest();
        CSS_Fault_Code__c[] faults = fc.getfaultCodes();
        CSS_Solutions__c[] solutions = fc.getsolutions();
        datetime insiteTime = fc.getInsiteTimeStamp();
        AggregateResult repair = fc.getRepair();
        datetime dsidTime = fc.getDSIDTimeStamp();
        string dsidstamp = fc.getDSIDStamp();
        fau.Job_Order__c=cjo.id;
        fau.Fault_Code_Type__c.startsWith('APD');
        string insiteTimestamp=fc.getInsiteTimeStr();
        // System.assertEquals(fc.isPrioritized, true);
        fau.Fault_Code_Type__c.startsWith('bpd');
        update fau;
        string insiteTimestam=fc.getInsiteTimeStr();
         
    }
}