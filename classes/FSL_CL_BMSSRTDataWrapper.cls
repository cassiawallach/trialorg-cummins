/***********************************************************************************************
Name:FSL_CL_BMSSRTDataWrapper
==============================================================================================
==============================================================================================
Purpose:                                                            
-------  
This class is to send SRTData request to BMS
==============================================================================================
==============================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE                                   
1.0         PiyushR                    08/11/2020                         
************************************************************************************************/ 
public class FSL_CL_BMSSRTDataWrapper {
    public Header Header;
    public DataArea DataArea;
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }
    
    public class Target {
        public String TargetID;
    }
    
    public class Location {
        public String LocationID;
    }
    
    public class DataArea {
        public String GuidanzJobID;
        public String ShopWONumber;
        public String Make;
        public String Model;
        public String EngineFamilyCode;
        public List<SRTs> SRTs;
    }
    public class Header {
        public Sender Sender;
        public Target Target;
        public Location Location;
    }
    
    public class SRTs {
        public String AccessCode;
        public String SRTgroupnum;
        public String Procedureno;
        public String Stepnumber;
        public String SRTTime;
        public String ActualSRTTime;
        public String SRTquantity;
    }
    
    
    public static FSL_CL_BMSSRTDataWrapper parse(String json) {
        return (FSL_CL_BMSSRTDataWrapper) System.JSON.deserialize(json, FSL_CL_BMSSRTDataWrapper.class);
    }
}