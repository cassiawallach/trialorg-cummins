//
// CST USer Status Response Parser class
//

public class IAM_CST_User_Status_Res_Parser {

	public class Records {
		public String username;
		public Integer status;
		public String message;
	}

	public String error;
	public String error_description;
	public Integer totalSize;
	public String userMessage;
	public List<Records> records;

	
	public static IAM_CST_User_Status_Res_Parser parse(String json) {
		return (IAM_CST_User_Status_Res_Parser) System.JSON.deserialize(json, IAM_CST_User_Status_Res_Parser.class);
	}
}