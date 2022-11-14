@istest
private class CG_TSREscalate_Test {
    static TestMethod void testEscalateAction() {
        CG_TSREscalate CGTSR = new CG_TSREscalate();
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(true);
        Test.startTest();
         PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
       CGTSR.sJobId = Jo.id;
        CGTSR.JobNum = JO.Name;
        CGTSR.TSRAction();
        CG_TSREscalate.EscalateAction();
        
        Test.stopTest();
    }
}