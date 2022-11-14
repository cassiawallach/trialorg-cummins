public class CSS_OverlapSRTResponse{

    public Header Header;
    public DataArea DataArea;

    public class Header {
        //public String Status;	//Success
        public String ReturnCodeDescription;	//Service successful
        //public String MessageCode;	//From SRT
        //public String MessageType;	//From SRT
        //public String Message;	 //From SRT  
        public String ReturnCode; //
        public String MessageIdentifier;
        public String MessageType;
    }
    public class DataArea {
        public Double TotalOverlapHours;	//5.5
        public Double TotalAdjustedHours;	//0.5
        public String MutualExMessage; //Mutual
        public List<MutualExecutiveSRTList> MutualExecutiveSRTList; //Mutual
        public Steps[] Steps;
        public OverlapSRTTime[] OverlapSRTTime;
    }
    public class Steps {
        public Integer StepId;	//1234
        public String AccessCode;	//R
        public Integer Qty;	//2
        public Double SRTHours;	//2.5
        public Double SRTAdjustedHours;	//0.5
        public OverlapTime[] OverlapTime;
    }
    public class OverlapTime {
        public String SRTNumber;	//11-111-11
        public Double OverlapHrs;	//1.5
    }
    public class OverlapSRTTime {
        public String SRTNumber;
        public Double OverlapHrs;
        public String SRTTitle;
        public Integer OverlapStepId;
        public String OverlapSRTNumber;
        public Integer StepId;
        public String OverlapSRTTitle;
    }
    
    //Mutual
    public class MutualExecutiveSRTList {
		public String SRTNumber;
		public Integer StepID;
		public String ExMessage;
	}
    
    public static CSS_OverlapSRTResponse parse(String json){
        return (CSS_OverlapSRTResponse) System.JSON.deserialize(json, CSS_OverlapSRTResponse.class);
    }


}