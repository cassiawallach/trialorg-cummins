public class CSS_J2AESNHistory {

	public class Pagination {
		public Integer currentPage;
		public Integer numberPerPage;
		public Integer numberOfPages;
		public Integer totalNumberOfRecord;
	}

	public Pagination pagination;
	public List<DiagnosticSession> diagnosticSession;

	public class DiagnosticSession {
		public String id;
		public String creationDate;
		public String owner;
		public String title;
		public String model;
		public String status;
		public String serialNumber;
		public AdditionalProp additionalProp;
		public String ticket;
	}

	public class AdditionalProp_Z {
		public String application;
		public String failureType;
	}

	public class AdditionalProp {
		public String application;
		public String INITIAL_PROBLEM;
		public String failureType;
        public String REPEAT_FLAG;
        public String failurePoint;
        public String unitNumber;
	}

	
	public static CSS_J2AESNHistory parse(String json) {
		return (CSS_J2AESNHistory) System.JSON.deserialize(json, CSS_J2AESNHistory.class);
	}
}