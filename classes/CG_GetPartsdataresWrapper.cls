public class CG_GetPartsdataresWrapper {
    public class Header{
			public String MessageIdentifier{get;set;}
            public String ReturnCode{get;set;}
            public String ReturnCodeDescription{get;set;}
            public String Status{get;set;}
            public string MessageType {get;set;}
			
		}
		public Header header;
		public DataArea dataarea;
		public class DataArea{
			public string SupersededPartNumber{get;set;}
			public string PartNumberLong{get;set;}
			public string PartDescription{get;set;}
			public string PartInService{get;set;}
			public string KitPartFlag{get;set;}
			
		}
	public static CG_GetPartsdataresWrapper parse(String json) {
	return (CG_GetPartsdataresWrapper) System.JSON.deserialize(json, CG_GetPartsdataresWrapper.class);
	}

}