@isTest
private class CG_SPAffiliationsScheduler_Test {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void test() {
        Test.startTest();
        CG_SPAffiliationsScheduler.getSPAffiliationData();
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new CG_SPAffiliationsScheduler());
        Test.stopTest();
    }
}