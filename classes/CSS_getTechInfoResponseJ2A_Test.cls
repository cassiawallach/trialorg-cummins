@IsTest
public class CSS_getTechInfoResponseJ2A_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        ' \"Header\": {'+
        '  \"MessageIdentifier\": \"Identifier from MW\",'+
        '  \"ReturnCode\": \"<MessageCode from Siebel>\",'+
        '  \"ReturnCodeDescription\": \"<Message from Siebel>\",'+
        '  \"Status\": \"Success\"'+
        '},'+
        ' \"DataArea\": {'+
        '     \"SPCode\": \"23430\",'+
        '     \"TechDetails\": ['+
        '        {'+
        '           \"PromotionId\": \"2123\",'+
        '           \"FirstName\": \"John\",'+
        '           \"LastName\": \"Smith\",'+
        '           \"QualProgID\": \"123\",'+
        '           \"PassedDate\": \"12/23/2014\"'+
        '        },'+
        '        {'+
        '           \"PromotionId\": \"2124\",'+
        '           \"FirstName\": \"John\",'+
        '           \"LastName\": \"Cena\",'+
        '           \"QualProgID\": \"124\",'+
        '           \"PassedDate\": \"12/20/2015\"'+
        '        }'+
        ''+
        '      ]'+
        ' }'+
        '}';
        CSS_getTechInfoResponseJ2A obj = CSS_getTechInfoResponseJ2A.parse(json);
        System.assert(obj != null);
    }
}