/**********************************************************************
Name: FSL_CL_IA_CreateServiceRequestAPIReqJSON
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose:    This class is to wrapp the request and deserialize the request
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rajashekar N      12/13/2019     INITIAL DEVELOPMENT              
1.1     Lochana Rajput    05/26/2022     SG-1: Added FTR attributes
***********************************************************************/
public class FSL_CL_IA_CreateServiceRequestAPIReqJSON {
    
    public Header Header;
    public DataArea DataArea;
    
    public class DataArea {
        //1.1 started
        public Boolean ABRFlag;
        public String transactionID;
        //1.1 Ended

        public String userLocation;
        public String iasNumber;
        public String woNumber;
        public String username;
        public String psn;
        public String serviceModelName;
        public String make;
        public String access;
        public String model;
        public String ecmCode;
        public String productType;
        public String psbuPlant;
        public String psbuModel;
        public String psbuSpec;
        public String ert;
        public String customerName;
        public String complaintText;
        public String prodMileage;
        public String prodMileageUnit;
        public String prodHours;
        public String woEnabled;
        public String severity;
        public String languageKey;
        public List<FAULTLIST> FAULTLIST;
        public List<PrioritizedData> PrioritizedData;
        public List<unPrioritizedData> unPrioritizedData;
    }
    
    public class Header {
        public String serviceName;
        public String serviceVersion;
        public String toolID;
        public String targetID;
        public String senderId;
    }
    public class FAULTLIST {
        public String fc;
        public String spn;
        public String fmi;
        public String pCode;
        public String occurenceTime;
        public String status;
        public String count;
        public String languageKey;
    }
    
    public class PrioritizedData {
        public String prifc;
        public String spn;
        public String fmi;
        public String pCode;
        public String occurenceTime;
        public String status;
        public String count;
        public String primaryFaultCodeDescription;
        public String rootCause1;
        public String rc1Likelihood;
        public String rootCause2;
        public String rc2Likelihood;
        public String rootCause3;
        public String rc3Likelihood;
        public String rootCause4;
        public String rc4Likelihood;
        public String derateValue1;
        public String derateValue2;
        public String derateValue3;
        public String severity;
        public String shutdownDescription;
        public List<Relfc> relfc;
        public Lhrprob lhrprob;
    }
    
    public class Lhrprob {
		public String lbrprob2;
		public String lbrprob1;
		public String lbrprob4;
		public String lbrprob3;
	}
    
    public class UnPrioritizedData {
        public String upfc;
        public String spn;
        public String fmi;
        public String pCode;
        public String occurenceTime;
        public String status;
        public String count;
        public String rc;
        public String ReasonCodeDescription;
    }
    
    public class Relfc {
        public String rfc;
        public String spn;
        public String fmi;
        public String pCode;
        public String occurenceTime;
        public String status;
        public String count;
        public String relatedFaultCodeDescription;
        public String derateValue1;
        public String derateValue2;
        public String derateValue3;
        public String severity;
        public String shutdownDescription;
    }
    
    public static FSL_CL_IA_CreateServiceRequestAPIReqJSON parse(String json) {
        return (FSL_CL_IA_CreateServiceRequestAPIReqJSON) System.JSON.deserialize(json, FSL_CL_IA_CreateServiceRequestAPIReqJSON.class);
    }
}