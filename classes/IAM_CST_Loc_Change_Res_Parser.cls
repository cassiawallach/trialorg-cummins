//
// CST Location change response parser class.
//

public class IAM_CST_Loc_Change_Res_Parser {

	public String error;
	public String error_description;
	public Integer totalSize;
	public String userMessage;
	public List<Records> records;

	public class Records {
		public String username;
		public Integer status;
		public String message;
	}

	
	public static IAM_CST_Loc_Change_Res_Parser parse(String json) {
		return (IAM_CST_Loc_Change_Res_Parser) System.JSON.deserialize(json, IAM_CST_Loc_Change_Res_Parser.class);
	}
}