@istest
private class CG_GetSPInfoScheduler_Test {
static testmethod void test1()
{
    test.startTest();
    CG_GetSPInfoScheduler sp = new CG_GetSPInfoScheduler();
    string sch='0 1 0 * * ?';
    system.schedule('TestingSchduleclass', sch, sp);
    test.stopTest();
}
}