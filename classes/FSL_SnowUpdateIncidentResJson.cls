/*
 * Block comments with details of changes
 */
public class FSL_SnowUpdateIncidentResJson
{
    public Result result;

	public class Result {
		public String Message;
		public String IncidentNumber;
		public String URL;
	}

	
	public static FSL_SnowUpdateIncidentResJson parse(String json) {
		return (FSL_SnowUpdateIncidentResJson) System.JSON.deserialize(json, FSL_SnowUpdateIncidentResJson.class);
	}
	
   //this comments use for Deployment Purpose Set missing comp
}