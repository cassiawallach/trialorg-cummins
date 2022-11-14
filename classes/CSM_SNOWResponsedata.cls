public class CSM_SNOWResponsedata {

	public ResponseResult result;

	public class ResponseResult {
		public String IncidentNumber;
		public String Priority;
		public String Customer;
		public String CustomerWWID;
		public String ShortDescription;
		public String Category;
		public String SubCategory;
		public String ConfigurationItem;
		public String State;
		public String AssignmentGroup;
		public String AssignedTo;
		public String AssignedToWWID;
		public String IncidentSysID;
		public String Thirdparty;
		public String TicketNumber;
		public String TicketURL;
		public String URL;
	}
     public static CSM_SNOWResponsedata parse(String json){
		return (CSM_SNOWResponsedata)System.JSON.deserialize(json,CSM_SNOWResponsedata.class);}
    //this comments use for deployment purpose.//this comments use for deployment purpose.Apex class use for Production deployment only
}