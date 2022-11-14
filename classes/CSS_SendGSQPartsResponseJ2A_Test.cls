@IsTest
public class CSS_SendGSQPartsResponseJ2A_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        ' \"Header\": {'+
        '  \"Status\": \"success\",'+
        '  \"ReturnCodeDescription\": \"Parts Updated successfully\",'+
        '  \"Location\": { \"LocationID\": \"02400-02394\" }'+
        ' }'+
        '}';
        CSS_SendGSQPartsResponseJ2A obj = CSS_SendGSQPartsResponseJ2A.parse(json);
        System.assert(obj != null);
    }
}