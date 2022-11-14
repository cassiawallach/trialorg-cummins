/*
* Block comments with details of changes
*/
public class CSS_JSON2APEXSIEBELPAYMENTDETAILS
{
    public class Sender
    {
        public string ServiceName;
        public string SenderID;
    }
    
    public class Target
    {
        public string TargetID ;
        public string SourceEnvironment;
        
    }
    public Header Header;
    public list<DataArea> DataArea;
    public class Header
    {
        public Sender Sender;
        public Target Target;
    }
    
    public class DataArea
    {
        public string SiebelClaimNumber ;
        public string IMSClaimNumber ;
        public string PayCode ;
        public string ClaimStatus ;
        public string RejectionReason ;
        public string Type ;
        public string StatementNumber ;
        public string CreditDate ;
        public string CreditNumber;
        public String Parts ;
        public String Labor;
        public String Travel;
        public String Other ;
        public String Tax ;
        public String PMU ;
        public String BFC ;
        public String Deductible ;
        public String TotalPaid ;
    }
    public static CSS_JSON2APEXSIEBELPAYMENTDETAILS parse(String json) {
        return (CSS_JSON2APEXSIEBELPAYMENTDETAILS) System.JSON.deserialize(json, CSS_JSON2APEXSIEBELPAYMENTDETAILS.class);
    }
}