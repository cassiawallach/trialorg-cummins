public class CSS_OverlapSRTReq{
    public Header Header;
    public DataArea DataArea;
    public class Header {
        public Sender Sender;
        public Target Target;
    }
    public class Sender {
        public String ServiceName;  //GetOverlapSRT
        public String SenderID; //CSS
    }
    public  class Target {
        public String TargetID; //SRT
    }
    public class DataArea {
        public String JobID;    // Sai: 06/01 Changed the jobid to jobID. //CSS-000001234 
        public String ClaimID;  //C100002045
        public String Languagecode; //en
        public String DTTimestamp;  //DD-MMM-YY HH:MI:SS AM
        public String EffectiveDTTime;  //DD-MMM-YY HH:MI:SS AM
        public String ProcessOption; //Mutual
        public Steps[] Steps;
    }
    public class Steps {
        public Integer StepId;  //1234
        public Integer Qty; //2
        public String AccessCode;   //R
    }
    public static CSS_OverlapSRTReq parse(String json){
        return (CSS_OverlapSRTReq) System.JSON.deserialize(json, CSS_OverlapSRTReq.class);
    }


}