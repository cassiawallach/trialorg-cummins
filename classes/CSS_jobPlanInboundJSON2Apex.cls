/**********************************************************************
Name: CSS_jobPlanInboundJSON2Apex
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Json2Apex Wrapper Class for the unit Inbound Response  
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE(dd/mm/yyyy)                DETAIL                                 
1.0    Rajesh Pasupuleti         06/09/2016                 INITIAL DEVELOPMENT                    

***********************************************************************/
public class CSS_jobPlanInboundJSON2Apex {

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
        public Sender Sender;
        public Target Target;
        public Location Location;
    }
    
    public class Sender{
        public String ServiceName;
        public string MessageID;
        public string SenderID;
    }

    public class Target{
        public string TargetID;
    }
    
    public Header Header;

    public class Location {
        public String LocationID;
    }
    
    public static CSS_jobPlanInboundJSON2Apex parse(String json) {
        return (CSS_jobPlanInboundJSON2Apex) System.JSON.deserialize(json, CSS_jobPlanInboundJSON2Apex.class);
    }
}