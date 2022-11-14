@isTest
public class CSS_ComponentRequestWrapper_Test {
 @isTest static void testCSS_ComponentRequestWrapper(){        
       List<CSS_SRT__c> srtList = new List<CSS_SRT__c>(); 
        CSS_Job_Order__c cjb = new CSS_Job_Order__c();
        cjb.Customer_Name__c = 'Test SRT';
        cjb.DSID__c = 'DSBDT4760';
        insert cjb;
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.name = 'K81572426';
        sol.Solution_Title__c ='Engine control module (ECM) Calibration Revision History check';
        insert sol;
        List<CSS_Solution_Component__c> lstSolComp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Solutions__c = sol.id;
        solComp.Service_Job__c = cjb.id;
        solComp.name = 'ABC';
        insert solComp;
        CSS_Solutions__c sol1 = new CSS_Solutions__c();
        sol1.name = 'K81572426';
        sol1.Solution_Title__c ='Engine control module (ECM) Calibration Revision History check';
        insert sol1;
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.Solutions__c = sol1.id;
        solComp1.Service_Job__c = cjb.id;
        solComp1.name = 'ABC';
        insert solComp1;     
        lstSolComp.add(solComp);
        lstSolComp.add(solComp1);
        CSS_ComponentRequestWrapper compRe = new CSS_ComponentRequestWrapper(lstSolComp,cjb.DSID__c);  
    }
}