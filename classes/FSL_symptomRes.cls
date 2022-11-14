public class FSL_symptomRes {
	
    public String TransactionID;
	public String ToolID;
	public String JobNumber;
	public String WorkgroupID;
	public String UserID;
	public String LowLevelSymptom;
	public Integer SolutionCount;
	public List<Solutions> Solutions;

	public class Solutions {
		public String SolutionID;
		public String SolutionTitle;
		public Integer SolutionPosition;
		public Double SolutionPriority;
		public String LanguageKey;
		public Integer LinkedSolutionCount;
		public List<LinkedSolutions> LinkedSolutions;
	}
    public class LinkedSolutions {
         public String SolutionID;
		public String SolutionTitle;
		public Double SolutionPosition;
		public Double SolutionPriority;
		public String LanguageKey;
	}
	public static FSL_symptomRes parse(String json) {
		return (FSL_symptomRes) System.JSON.deserialize(json, FSL_symptomRes.class);
	}
}