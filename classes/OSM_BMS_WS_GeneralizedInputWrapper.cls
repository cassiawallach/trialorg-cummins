/************************************************************
Name:  OSM_BMS_WS_GeneralizedInputWrapper
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is the wrapper class for dynamic binding.

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sangeeta            23/10/2018     INITIAL DEVELOPMENT          


*************************************************************/

public class OSM_BMS_WS_GeneralizedInputWrapper{
    public Header Header{get;set;}
    public DataArea DataArea{get;set;}
    
    public class DataArea{
    public String CustomerName;
    public String CustomerCode;
    public String DealerCode;
	public String AcctId;//Added by Dhiraj
    }
    public class Location {
        public String LocationID;
    }
    public class Header {
        public Sender Sender;
        public Target Target;
        public Location Location;
    }
    public class Sender {
        public String ServiceName;
        public String SenderID;
    }
      public class Target {
        public String TargetID;
    }


}