@isTest
public class FSL_J2AToken_SRT_Test {
    static testMethod void testParse() {
		String json = '{'+
		'   \"access_token\": \"ffYVjhpw7pEigWdjJWmZ9ACyNCySnQB3SbtPGk0H4vYkJ09Hwwzfrv\",'+
		'   \"token_type\": \"Bearer\",'+
		'   \"expires_in\": 1200,'+
		'   \"refresh_token\": \"bv51htbK5dvXze8MXzOxp575ZvrF7sXZ6HmApQDR6EH0hv\",'+
		'   \"scope\": \"CSSCloud\"'+
		'}';
		FSL_J2AToken_SRT obj = FSL_J2AToken_SRT.parse(json);
		System.assert(obj != null);
	}

}