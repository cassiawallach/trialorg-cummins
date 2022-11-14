@IsTest
private class CSS_getAllSRTResponseJ2A_Test {
static testMethod void testParse() 
{
string json = '{"status": "success"}';
CSS_getAllSRTResponseJ2A  obj = CSS_getAllSRTResponseJ2A.parse(Json);
        System.assert(obj != null);
}
}