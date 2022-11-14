/**********************************************************************
Name: CSS_BMSQTAcceptInboundJSON2APEX 
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Wrapper class for "CSS_BMSQTAcceptanceInboundService" 
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0    Ekta Deswal         06/09/2016     INITIAL DEVELOPMENT                    

***********************************************************************/

public class CSS_BMSQTAcceptInboundJSON2APEX {

    public class DataArea {
        public String WOReferenceNumber;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
        public Location Location;
    }

    public Header Header;
    public DataArea DataArea;

    public class Location {
        public String LocationID;
    }

    
    public static CSS_BMSQTAcceptInboundJSON2APEX  parse(String json) {
        return (CSS_BMSQTAcceptInboundJSON2APEX ) System.JSON.deserialize(json, CSS_BMSQTAcceptInboundJSON2APEX.class);
    }
}