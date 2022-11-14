@isTest
public class CG_TSRResJSONParser_Test {
    static testMethod void testParse(){
        string json = '{"DataArea":{"ActivityDescription":"","ErrorMessage":"Success","ActivityOwner":"Brent A Engel","ActivityID":"1-HIKHTI9","TSRNumber":"1-38128114549","ActivityType":"Escalation","ActivitySubject":"","ErrorCode":"","CSSJobID":"CSS-00070849"},"Header":{"ReturnCodeDescription":"Success","Status":"SUCCESS","ReturnCode":"","MessageIdentifier":"CSS-00070849"}}';

        CG_TSRResJSONParser.parse(json);
    }
}