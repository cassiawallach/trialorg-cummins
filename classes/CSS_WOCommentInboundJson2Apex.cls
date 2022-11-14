/**********************************************************************
Name: CSS_WOCommentInboundJson2Apex 
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Wrapper Class to deserialize the response from
            BMS_WOCommentInbound
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION         AUTHOR          DATE            DETAIL                                 
1.0         Nisha Mendiratta    05/09/2016      INITIAL DEVELOPMENT                    

***********************************************************************/

public class CSS_WOCommentInboundJson2Apex {
    public class Header {
        public String Status;
        public String ReturnCodeDescription;
        public Location Location;
        public Sender Sender;
        public Target Target;
    }

    public Header Header;

    public class Location {
        public String LocationID;
    }
    
    public class Sender {
        public String ServiceName;
        public String SenderID;
        public String MessageID;
    }
    
    public class Target {
        public String TargetID;
    }

    public static CSS_WOCommentInboundJson2Apex parse(String json) {
        return (CSS_WOCommentInboundJson2Apex) System.JSON.deserialize(json, CSS_WOCommentInboundJson2Apex.class);
    }

}