//
// CST location REsponse PArser Test class
//

@IsTest
public class IAM_CST_Loc_Change_Res_Parser_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '    \"error\": \"success\",'+
        '    \"error_description\": \"user location updated\",'+
        '    \"totalSize\": 1,'+
        '    \"userMessage\": \"user location updated\",'+
        '    \"records\": ['+
        '        {'+
        '            \"username\": \"usernamereclaim3@cmiuser.com\",'+
        '            \"status\": 1,'+
        '            \"message\": \"User moved\"'+
        '        }'+
        '    ]'+
        '}';
        IAM_CST_Loc_Change_Res_Parser obj = IAM_CST_Loc_Change_Res_Parser.parse(json);
        System.assert(obj != null);
    }
}