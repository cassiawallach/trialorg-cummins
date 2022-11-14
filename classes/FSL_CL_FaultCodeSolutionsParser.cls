public class FSL_CL_FaultCodeSolutionsParser {
    
    public class FaultCodeList {
        public Integer FaultCode;
        public Integer SPN;
        public Integer FMI;
        public String PCode;
        public Integer SolutionCount;
        public List<Solutions> Solutions;
    }
    
    public class LinkedSolutions {
        public String SolutionID;
        public String SolutionTitle;
        public Double SolutionPosition;
        public Double SolutionPriority;
        public String LanguageKey;
        public List<Components> Components;
    }
    
    public class Solutions_Z {
        public List<LinkedSolutions> LinkedSolutions;
    }
    
    public String TransactionID;
    public String ToolID;
    public String JobNumber;
    public String WorkgroupID;
    public String UserID;
    public List<FaultCodeList> FaultCodeList;
    
    public class Solutions {
        public String SolutionID;
        public String SolutionTitle;
        public Integer SolutionPosition;
        public Double SolutionPriority;
        public String LanguageKey;
        public Integer LinkedSolutionCount;
        public List<LinkedSolutions> LinkedSolutions;
        public List<Components> Components;
    }

    public class Components {
        public String ComponentName;
        public String FailureID;
    }
    
    public class LinkedSolutions_Z {
        public String SolutionID;
        public String SolutionTitle;
        public Double SolutionPosition;
        public Integer SolutionPriority;
        public String LanguageKey;
    }
    
    public static FSL_CL_FaultCodeSolutionsParser parse(String json) {
        return (FSL_CL_FaultCodeSolutionsParser) System.JSON.deserialize(json, FSL_CL_FaultCodeSolutionsParser.class);
    }
}