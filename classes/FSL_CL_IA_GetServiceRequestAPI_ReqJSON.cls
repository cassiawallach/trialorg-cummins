/**********************************************************************
Name: FSL_CL_IA_GetServiceRequestAPI_ReqJSON
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains REST webservice Request JSON Wrapper
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rajashekar N      12/26/2019     INITIAL DEVELOPMENT                    
********************************************************************** */
public class FSL_CL_IA_GetServiceRequestAPI_ReqJSON {
	public Header Header;
	public DataArea DataArea;
   // added by Rajashekar N 
	public class DataArea {
		public String userLocation;
		public String currentDate;
		public String dateSpan;
	}
	public class Header {
		public String serviceName;
		public String serviceVersion;
		public String toolID;
		public String targetID;
		public String senderId;
	}
	public static FSL_CL_IA_GetServiceRequestAPI_ReqJSON parse(String json) {
		return (FSL_CL_IA_GetServiceRequestAPI_ReqJSON) System.JSON.deserialize(json, FSL_CL_IA_GetServiceRequestAPI_ReqJSON.class);
	}
}