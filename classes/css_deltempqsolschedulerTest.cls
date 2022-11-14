@isTest
private class css_deltempqsolschedulerTest {
    static testmethod void  testschedule() {
        CSS_JobEventTemporary__c jobEvent = new CSS_JobEventTemporary__c();
        jobEvent.Name = 'QSOL';
        jobEvent.Source__c = 'QSOL';
        jobEvent.JobOrder__c = 'testJO';
        jobEvent.Key__c = '12345';
        jobEvent.Attribute1__c = 'TSB';
        jobEvent.Attribute2__c = 'TSB';
        jobEvent.Attribute3__c = 'en';
        jobEvent.Attribute7__c = 'TSB150158';
        jobEvent.Attribute8__c = 'Bosch® Aftertreatment Diesel Exhaust Fluid (DEF) Dosing Pump with Unidentified Fluid at Seams';
        jobEvent.Attribute9__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2015/tsb150158.html';
        insert jobEvent;
        Test.StartTest();
        css_deltempqsolscheduler sh1 = new css_deltempqsolscheduler();      
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        Test.stopTest();
    }
}