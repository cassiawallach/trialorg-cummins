/**********************************************************************
Name:CSS_J2AAccess_SRT
Copyright © 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
This Wrapper Class saves the response from CSS_SRTAccessWebService 
===============================================================
===============================================================
                 
***********************************************************************/



public class CSS_J2AAccess_SRT {

	/*public class DataArea {
		public List<CaseResponse> CaseResponse;
		public String ResponseMessage;
	}

	public class CaseResponse {
		public String SRTTitle;
		public String SRTDetails;
		public Integer SRTID;
	}

	public class Header {
		public String ReturnCodeDescription;
		public String Status;
	}

	public DataArea DataArea;
	public Header Header;

	
	public static CSS_J2AAccess_SRT parse(String json) {
		return (CSS_J2AAccess_SRT) System.JSON.deserialize(json, CSS_J2AAccess_SRT.class);
	}*/
    
	public class DataArea {
		public List<CaseResponse> CaseResponse;
		public String ResponseMessage;
	}

	public class CaseResponse {
		public String SRTTitle;
		public String SRTDetails;
		public Integer SRTID;
		public String ECMFlag;
		public String PrivateFlag;
		public String Regions;
	}

	public class Header {
		public String ReturnCodeDescription;
		public String Status;
	}

	public DataArea DataArea;
	public Header Header;

	
	public static CSS_J2AAccess_SRT parse(String json) {
		return (CSS_J2AAccess_SRT) System.JSON.deserialize(json, CSS_J2AAccess_SRT.class);
	}
}