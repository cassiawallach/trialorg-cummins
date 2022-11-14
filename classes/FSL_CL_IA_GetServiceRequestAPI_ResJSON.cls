/**********************************************************************
Name: FSL_CL_IA_GetServiceRequestAPI_ResJSON
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose:    This class contains REST webservice Response JSON Wrapper logic
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rajashekar N      12/26/2019     INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSL_CL_IA_GetServiceRequestAPI_ResJSON {
    public Header Header;
    public DataArea DataArea;

    public class Header{
        public String serviceName;
        public String serviceVersion;
        public String status;
        public String returnCodeDescription;
        public String toolID;
        public String senderId;
    }
//added by Rajashekar N  
    public class DataArea{
        public List<IAAppointments> serviceRequests;
        public String woEnabled;
    }
    public class IAAppointments{
        public String customerName;
        public String contactFirstName;
        public String contactLastName;
        public String woNumber;
        public String psn;
        public String unitNumber;
        public String complaintText;
        public String availableForService;
    }
    public static FSL_CL_IA_GetServiceRequestAPI_ResJSON parse(String json) {
        return (FSL_CL_IA_GetServiceRequestAPI_ResJSON) System.JSON.deserialize(json, FSL_CL_IA_GetServiceRequestAPI_ResJSON.class);
    }
}