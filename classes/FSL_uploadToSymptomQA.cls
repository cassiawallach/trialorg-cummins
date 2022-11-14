public class FSL_uploadToSymptomQA {
    
   public class LinkedSolutions {
       public String SolutionID;
		public String SolutionTitle;
		public Double SolutionPosition;
		public Double SolutionPriority;
		public String LanguageKey;
   }

	public class Solutions {
		public String SolutionID;
		public String SolutionTitle;
		public Integer SolutionPosition;
		public Double SolutionPriority;
		public String LanguageKey;
		public Integer LinkedSolutionCount;
		public List<LinkedSolutions> LinkedSolutions;
	}

	 public class LinkedSolutions_Z {
		public String SolutionID;
		public String SolutionTitle;
		public Double SolutionPosition;
		public Integer SolutionPriority;
		public String LanguageKey;
	} 

	public String TransactionID;
	public String ToolID;
	public String JobNumber;
	public String WorkgroupID;
	public String UserID;
	public List<FaultCodeList> FaultCodeList;

	public class FaultCodeList {
		public Integer FaultCode;
		public String PCode;
		public Integer SolutionCount;
		public List<Solutions> Solutions;
	}

	
	public static FSL_uploadToSymptomQA parse(String json) {
		return (FSL_uploadToSymptomQA) System.JSON.deserialize(json, FSL_uploadToSymptomQA.class);
	}
}