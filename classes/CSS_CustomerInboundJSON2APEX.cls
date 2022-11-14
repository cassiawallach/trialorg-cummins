/**********************************************************************
Name: CSS_CustomerInboundJSON2APEX
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Wrapper class for "CSS_CustomerInboundService"
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0    Ekta Deswal         06/09/2016     INITIAL DEVELOPMENT                    

***********************************************************************/


public class CSS_CustomerInboundJSON2APEX {

    public class DataArea {
        public String CustomerCode;
        public String OpenChargeFlag;
        public String CSSJobID;//GSSC-664
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
		public Sender Sender;
		public Target Target;
        public Location Location;
    }
	
	public class Sender{
		public string ServiceName;
		public string MessageID;
		public string SenderID;
	}
    
    public class Target{
		public string TargetID;
	}
    
    public class Location {
        public String LocationID;
    }


    public Header Header;
    public DataArea DataArea;


    
    public static CSS_CustomerInboundJSON2APEX parse(String json) {
        return (CSS_CustomerInboundJSON2APEX) System.JSON.deserialize(json, CSS_CustomerInboundJSON2APEX.class);
    }
}