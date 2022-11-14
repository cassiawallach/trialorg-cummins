@isTest
public class CSS_WPR_JobPlanOverview_Test {
    static testMethod void testMethodPlan(){
       
        CSS_WPR_JobPlanOverview wpr = new CSS_WPR_JobPlanOverview();
        wpr.Name = 'ABC';
        List<string> relatedName = new List<string>();
        string relName = 'BCD';
        relatedName.add(relName);
        string relName2 = 'PQRST';
        relatedName.add(relName);
        wpr.relatedName = relatedName;
        wpr.diagTime = 'ABC';
        wpr.repTime = 'bcd';
        wpr.failcode = '123';
        wpr.allCompCountForFC = 12;
        wpr.partsList = relatedName;
        
        //List<solWrapper> solwrap1 = new List<solWrapper>();        
        CSS_WPR_JobPlanOverview.solWrapper solwrap1 = new CSS_WPR_JobPlanOverview.solWrapper();
            solwrap1.solNumber = '4455';
            solwrap1.solTitle = 'title11';
            solwrap1.solResponse = 'response1';
        solwrap1.outOfOrder = true;
        solwrap1.allCompCountForSol = 23;
                
        
         CSS_WPR_JobPlanOverview.solCompWrapper solwrap2 = new CSS_WPR_JobPlanOverview.solCompWrapper();
            solwrap2.compName = '4455';
            solwrap2.failcodelist = 'title11';
            solwrap2.failcodeEditable = 'response1';
        solwrap2.selectedcomp = true;
        Solwrap2.failmodedesc = '123';
                
    }
}