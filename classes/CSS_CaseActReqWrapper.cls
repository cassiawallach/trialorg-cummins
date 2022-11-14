public class CSS_CaseActReqWrapper {
    public String actionType{set;get;}
    public CaseProperties caseProperties{set;get;}
    public class CaseProperties{
        public String caseName {set;get;}
        public decimal caseIndexInResultSet {set;get;}
    }
    public static String parse(CSS_CaseActReqWrapper obj) {
        return System.JSON.serialize(obj);
    }   
}