/**********************************************************************
Name: CSS_unitInboundJSON2Apex
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
1.1    Rajesh Pasupuleti         04/10/2016                 Added Sender part 

***********************************************************************/
public class CSS_unitInboundJSON2Apex {


    public class DataArea {
        public String UnitNumber;
        public String ESN;
        public String ServiceModelName; 
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
        public Location Location;
        public Sender Sender;
        public Target Target;
    }

    public Header Header;
    public DataArea DataArea;

    public class Target{
        public String LocationID;
         public String TargetID;
    }
    public class Location{
        public String LocationID;
        
    }
        public class Sender {
          public String ServiceName;
          public String SenderID;
          public String MessageID;
    }

    
    
    public static CSS_unitInboundJSON2Apex parse(String json) {
        return (CSS_unitInboundJSON2Apex) System.JSON.deserialize(json, CSS_unitInboundJSON2Apex.class);
    }

}