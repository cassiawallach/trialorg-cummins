// Test class for CST Create response parser.
//

@IsTest
public class IAM_CST_Create_Res_Parser_New_Test {
	
	static testMethod void testParse() {
		String json = '{\"error\":\"success\",\"error_description\":\"user created\",\"totalSize\":1,\"userMessage\":\"user created\",\"records\":[{\"username\":\"usernamereclaim3@cmiuser.com\",\"status\":1,\"message\":\"User Added\",\"service_training_id\":\"1164296\"}]}';
		IAM_CST_Create_Res_Parser_New obj = IAM_CST_Create_Res_Parser_New.parse(json);
		System.assert(obj != null);
	}
}