@isTest
public class CSS_J2Adsidclose_EDS_Test {
    static testMethod void testParse() {
        String json = '{\"Status\": true}';
        CSS_J2Adsidclose_EDS obj = CSS_J2Adsidclose_EDS.parse(json);
        obj.status = 'true';
        System.assert(obj != null);
    }

}