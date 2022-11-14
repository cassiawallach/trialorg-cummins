/**********************************************************************
Name: CSS_WPR_TG_IAAppointmentsResJSON_V1
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is a Response JSON Wrapper class of IA Appointments
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        11/28/2017       VERSION3 DEVELOPMENT                    
***********************************************************************/
public class CSS_WPR_TG_IAAppointmentsResJSON_V1 {

	public Header Header;
	public DataArea DataArea;

	public class DataArea {
		public String CSSEnabled;
		public List<IAAppointments> IAAppointments;
	}

	public class Header {
		public String Status;
		public String ServiceVersion;
		public String ServiceName;
		public String ReturnCodeDescription;
	}

	public class IAAppointments {
		public String CustomerName;
		public String ContactFirstName;
		public String ContactLastName;
		public String CSSJobNumber;
		public String UnitNumber;
		public String ComplaintText;
		public String AvailableForService;
	}

	
	public static CSS_WPR_TG_IAAppointmentsResJSON_V1 parse(String json) {
		return (CSS_WPR_TG_IAAppointmentsResJSON_V1) System.JSON.deserialize(json, CSS_WPR_TG_IAAppointmentsResJSON_V1.class);
	}
}