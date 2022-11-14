//
// CST User Response Parser Test
//

@IsTest
public class IAM_CST_User_Status_Res_Parser_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '    \"error\": \"success\",'+
        '    \"error_description\": \"user status updated\",'+
        '    \"totalSize\": 1,'+
        '    \"userMessage\": \"user status updated\",'+
        '    \"records\": ['+
        '        {'+
        '            \"username\": \"usernamereclaim2@cmiuser.com\",'+
        '            \"status\": 0,'+
        '            \"message\": \"Invalid arguments\"'+
        '        }'+
        '    ]'+
        '}';
        IAM_CST_User_Status_Res_Parser obj = IAM_CST_User_Status_Res_Parser.parse(json);
        System.assert(obj != null);
    }
}