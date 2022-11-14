/**********************************************************************
Name:CG_ClaimSubmission_Resp
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Submit Claims Details to BMS - Response Wrapper class                                                        
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR          DATE                 DETAIL                                 
1.0 -    Moulika G      06/04/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/
public class CG_ClaimSubmission_Resp {

	public class DataArea {
		public String Status;
		public String ErrorMessage;
		public String ClaimNumber;
	}

	public class Header {
		public String ReturnCodeDescription;
		public String Status;
	}

	public DataArea DataArea;
	public Header Header;

	
	public static CG_ClaimSubmission_Resp parse(String json) {
		return (CG_ClaimSubmission_Resp) System.JSON.deserialize(json, CG_ClaimSubmission_Resp.class);
	}
}