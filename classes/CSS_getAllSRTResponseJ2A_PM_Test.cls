@IsTest
private class CSS_getAllSRTResponseJ2A_PM_Test {
static testMethod void testParse() 
{
string json = '{"status": "success"}';
CSS_getAllSRTsPM  obj = CSS_getAllSRTsPM.parse(Json);
        System.assert(obj != null);
}
}