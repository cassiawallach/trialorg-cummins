public class CSS_BMSCommentOutBoundRequestParser {

	public class Sender {
		public String ServiceName;
		public String SenderID;
	}

	public class Target {
		public String TargetID;
	}

	public class DataArea {
		public String CSSJobId;
		public String DistributorCode;
		public String BranchCode;
		public String BMSReferenceNumber;
		public String OrderSourceType;
		public String CommentType;
		public String ServiceComment;
		public String CreateUser;
		public String CreateDate;
		public String ChangeUser;
		public String ChangeDate;
	}

	public Header Header;
	public DataArea DataArea;

	public class Header {
		public Sender Sender;
		public Target Target;
		public Location Location;
	}

	public class Location {
		public String LocationID;
	}

	
	public static CSS_BMSCommentOutBoundRequestParser parse(String json) {
		return (CSS_BMSCommentOutBoundRequestParser) System.JSON.deserialize(json, CSS_BMSCommentOutBoundRequestParser.class);
	}
}