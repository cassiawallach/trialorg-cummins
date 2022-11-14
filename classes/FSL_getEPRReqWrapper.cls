public class FSL_getEPRReqWrapper {
   public class Sender {
		public String ServiceName;
		public String SenderID;
       
        public Sender()
        {
            ServiceName = 'GetERPFlag';
            SenderID = 'CSS';
           
        }
	}

	public class Target {
		public String TargetID;
        public Target()
        {
            TargetID = 'GetERPFlag';   
           
        }
	}

	public class DataArea {
        public List<PARTS> PARTS;
		public String PSN;
		public String FAILDATE;
		public String DISTICHANNEL;
	}

	public Header Header;
	public DataArea DataArea;

	public class Header {
		public Target Target;
		public Sender Sender;
        public Header()
        {
            Sender = new Sender();
            Target = new Target();
        }
	}

	public class PARTS {
		public String TERRITORYCLASS;
		public String PRODUCTFAMILY;
		public String PARTNUMBER;
		public String FAILCODE;
		public String ACCOUNTCODE;
	}
    
    public FSL_getEPRReqWrapper()
    {
        Header = new Header();
        DataArea = new DataArea();
    }

}