public class FSL_DetailCoverageReqWrapper
{
    public Header Header;
	public DataArea DataArea;
	public class Sender
    {
		public String ServiceName;
		public String SenderID;
		public String MessageID;
        public Sender()
        {
            ServiceName = 'AccCoverage';
            SenderID = 'CSS';
            MessageID = string.valueOfGmt(system.now());
        }
	}

	public class Details
    {
		public String SystemCode;
		public String ComponentCode;
       /* public Details()
        {
            SystemCode= '';
            ComponentCode ='';
        }*/
	}

	public class DataArea {
		public String WarrantyStartDate;
		public String SPCode;
		public String RoadRelayWrntyFlg;
		public String ReconPartsWrntyFlg;
		public String NewPartsWrntyFlg;
		public String FaultCode;
		public String FailurePoint;
		public String FailureMeasure;
		public String FailureDate;
		public String Esn;
		public String EngineApplicationCode;
		public List<Details> Details;
		public String CampaignNumber;
		public String AccountCode;
	}

	public class Header 
    {
		public Sender Sender;
        public Header()
        {
            Sender = new Sender();
        }
	}
    public FSL_DetailCoverageReqWrapper()
    {
        Header = new Header();
        DataArea = new DataArea();
    }
	/*
	public static FSL_DetailCoverageReqWrapper parse(String json) {
		return (FSL_DetailCoverageReqWrapper) System.JSON.deserialize(json, FSL_DetailCoverageReqWrapper.class);
	}*/
}