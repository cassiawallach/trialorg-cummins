/*
 * Block comments with details of changes
 */
public class FSL_ServiceNowCreateNewResJSON
{
    public Result result;
	public class Result {
		public String Message;
		public String IncidentNumber;
		public String Priority;
		public String IncidentSysID;
		public String Thirdparty;
		public String TicketNumber;
		public String TicketURL;
		public String URL;
	}

	
	public static FSL_ServiceNowCreateNewResJSON parse(String json) {
		return (FSL_ServiceNowCreateNewResJSON) System.JSON.deserialize(json, FSL_ServiceNowCreateNewResJSON.class);
	}

   //this comments use for Deployment Purpose Set missing comp
}