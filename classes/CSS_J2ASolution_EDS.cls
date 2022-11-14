global class CSS_J2ASolution_EDS {
    
    
    public class Components {
        public String failureId{get;set;}
        public String value{get;set;}
    }
    public List<String> messageArg{get;set;}
    public String key{get;set;}
    public String message{get;set;}
    public String solutionNumber{get;set;}
    public String solutionTitle{get;set;}
    public String coreIssue{get;set;}
    public String modificationDate{get;set;}
    public String status{get;set;}
    public String verification{get;set;}
    public String resolution{get;set;}
    //Added validation tab
    public string validation{get;set;}
    public Boolean poleLogicSolution{get;set;}
    public List<Components> components{get;set;}
    public List<verCompoundSolutions> verCompoundSolutions{get;set;}
    public List<RepCompoundSolutions> repCompoundSolutions{get;set;}
    
    public class verCompoundSolutions {
        public String solutionNumber{get;set;}
        public String solutionTitle{get;set;}
        public String coreIssue{get;set;}
        public String modificationDate{get;set;}
        public String status{get;set;}
        public String verification{get;set;}
        public String resolution{get;set;}
        public Boolean poleLogicSolution{get;set;}
        //Added validation tab
        public string validation{get;set;}
        public List<Components> components{get;set;}
    }
    public class RepCompoundSolutions {
        public String solutionNumber{get;set;}
        public String solutionTitle{get;set;}
        public String coreIssue{get;set;}
        public String modificationDate{get;set;}
        public String status{get;set;}
        public String verification{get;set;}
        public String resolution{get;set;}
        //Added validation tab
        public string validation{get;set;}
        public Boolean poleLogicSolution{get;set;}
        public List<Components> components{get;set;}
        //Defect 63412
        public List<verCompoundSolutions> verCompoundSolutions{get;set;}
    }
    
    public static CSS_J2ASolution_EDS parse(String json) {
        return (CSS_J2ASolution_EDS) System.JSON.deserialize(json, CSS_J2ASolution_EDS.class);
    }
}