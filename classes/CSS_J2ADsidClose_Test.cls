@IsTest
private class CSS_J2ADsidClose_Test {
    static testMethod void testParse() 
    {
        string json = '{"status": "success"}';
        
        CSS_J2Adsidclose_EDS  obj = CSS_J2Adsidclose_EDS.parse(Json);
        obj.status = 'success';
        System.assert(obj != null);
    }
}