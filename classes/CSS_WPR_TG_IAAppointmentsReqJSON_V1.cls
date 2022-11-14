/**********************************************************************
Name: CSS_WPR_TG_IAAppointmentsReqJSON_V1
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is a Request JSON Wrapper class of IA Appointments
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        11/28/2017       VERSION3 DEVELOPMENT                    
***********************************************************************/
public class CSS_WPR_TG_IAAppointmentsReqJSON_V1 {

    public Header Header;
	public DataArea DataArea;
    
	public class DataArea {
		public String UserLocation;
		public String CurrentDate;
	}

	public class Header {
		public String ServiceName;
		public String ServiceVersion;
		public String ToolID;
		public String SenderID;
		public String TargetID;
	}
	
	public static CSS_WPR_TG_IAAppointmentsReqJSON_V1 parse(String json) {
		return (CSS_WPR_TG_IAAppointmentsReqJSON_V1) System.JSON.deserialize(json, CSS_WPR_TG_IAAppointmentsReqJSON_V1.class);
	}
}