/**********************************************************************
Name: FSL_WOCommentInboundJson2Apex 
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:    Wrapper Class to deserialize the response from
            FSL_WO_Comment_Inbound
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION         AUTHOR          DATE            DETAIL                                 
1.0             Harsha          19-Feb-2020     INITIAL DEVELOPMENT                    

***********************************************************************/
public class FSL_WOCommentInboundJson2Apex {

     public class Header {
        public String Status;
        public String ReturnCodeDescription;
        public Location Location;
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    //Anirudh Changes for Error Handling
    public String MessageIdentifier;
    public String ReturnCode;
    public String ReturnCodeDescription;
    public String Status;
    public String Message;

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

    public static FSL_WOCommentInboundJson2Apex parse(String json) {
        return (FSL_WOCommentInboundJson2Apex) System.JSON.deserialize(json, FSL_WOCommentInboundJson2Apex.class);
    }
}