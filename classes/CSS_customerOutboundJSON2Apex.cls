public class CSS_customerOutboundJSON2Apex {

	public class DataArea {
		public String CustomerName{get;set;}
		public String CustomerCode{get;set;}
		public String LocationAddressline1{get;set;}
		public String LocationAddressline2{get;set;}
		public String LocationAddressline3{get;set;}
        public String PhoneNumber{get;set;}
        public String AreaCode{get;set;}
		public String City{get;set;}
        public String PaymentType{get;set;}
		public String State{get;set;}
		public String Country{get;set;}
		public String Postalcode1{get;set;}
		public String Postalcode2{get;set;}
        public String CreditLimit;
        public String QuoteCustomer;
        public String RequirePO;
        public String AmountDue;
        public String AvailableCredit;
        
            //public String Customercode;        
            public String UnitNumber;        
            public String UnitDescription;        
            public String Model;
            public String VIN;
            public String Make;
            //public String Application;
            public String ServiceModelName; 
            public String ESN;        
            public String EngineFamily;        
            public String ApplicationCode; 
	}

	public class Header {
        public String ReturnCodeDescription;
		public String Status;
		public Sender Sender;
        public Target Target;
		public Location Location;
	}

    public class Sender{
        public String ServiceName;
        public String SenderID;
    }
    
    public class Target{
        public String TargetID;
    }
    
    
    
	public Header Header;
    public List<DataArea> DataArea{get;set;}

	public class Location {
		public String LocationID;
	}

	
	public static CSS_customerOutboundJSON2Apex parse(String json) {
		return (CSS_customerOutboundJSON2Apex) System.JSON.deserialize(json, CSS_customerOutboundJSON2Apex.class);
	}
}