//CST Create Service Trainign ID response parser.
// 

public class IAM_CST_Create_Res_Parser_New {

	public String error;
	public String error_description;
	public Integer totalSize;
	public String userMessage;
	public List<Records> records;

	public class Records {
		public String username;
		public Integer status;
		public String message;
		public String service_training_id;
	}

	
	public static IAM_CST_Create_Res_Parser_New parse(String json) {
		return (IAM_CST_Create_Res_Parser_New) System.JSON.deserialize(json, IAM_CST_Create_Res_Parser_New.class);
	}
}