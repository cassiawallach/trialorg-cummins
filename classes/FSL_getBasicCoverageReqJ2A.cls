/**********************************************************************
Name: FSL_getBasicCoverageReqJ2A
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      01/20/2020          INITIAL DEVELOPMENT                    
***********************************************************************/

public class FSL_getBasicCoverageReqJ2A {
    
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }
    
    public class Target {
        public String TargetID;
    }
    
    public class DataArea {
        public String ESN;
        public String EngineApplicationCode;
        public String Region;
        public String Territory;
        public String WarrantyStartDate;
        public String PartsWarranty;
        public string JobId;
        public string FailurePoint;     
        public string FailureUnit;      
        public string ReconFlag; 
        public String FailureDate;     //CT3-497, Dinesh Yadav     
    }
    
    public class Header {
        public Sender Sender;
        public Target Target;
    }
    
    public Header Header;
    public DataArea DataArea;
    
    public static FSL_getBasicCoverageReqJ2A parse(String json) {
        return (FSL_getBasicCoverageReqJ2A) System.JSON.deserialize(json, FSL_getBasicCoverageReqJ2A.class);
    }
}