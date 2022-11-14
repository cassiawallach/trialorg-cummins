/*
 Akanksha Patkar
 */
@isTest
public class css_accessSrtCompOutTo_Eds_Test {
    
  public static Testmethod void css_accessSrtCompOutTo_Method1()
    {
	             
        CSS_Job_Order__c jo =  CSS_TestData.createJobOrder(true);
        list<CSS_SOLUTIONS__c> lstsol = new list<CSS_SOLUTIONS__c>();
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,jo.Id);
        lstsol.add(sol);
        list<CSS_Fault_Code__c> lstfc = new list<CSS_Fault_Code__c>();
           CSS_Fault_Code__c fc = new CSS_Fault_Code__c();
        //fc.DSID__c = 'akanksha';
        fc.Job_Order__c = jo.id;
        insert fc;
        lstfc.add(fc);
        CSS_SRT__c  accsrt = CSS_TestData.createSRT(true ,'test',sol.Id,jo.id);
        set<Id> solutionIds = new set<Id>();
          css_accessSrtCompOutTo_Eds acccomp = new css_accessSrtCompOutTo_Eds(solutionIds,'DSID');
           acccomp.accessSRTs();
           acccomp.solComponents();
           acccomp.outOfOrder(lstsol);
           acccomp.insiteFaultCodes(lstfc,'DSID');
        List<string> lststr = new list<string>();
        acccomp.srtIdDetails = lststr;
     }
}