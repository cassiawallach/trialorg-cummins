/**********************************************************************
Name: CSS_UnitOutboundJSON2Apex
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    Json2Apex Wrapper Class for the Unit outbound Response  
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE(dd/mm/yyyy)                DETAIL                                 
1.0    Anirudh Pesari         08/16/2017              INITIAL DEVELOPMENT                    

***********************************************************************/
public class CSS_UnitOutboundJSON2Apex {

    public class Sender {
        public String ServiceName;
        public String SenderID;
        public String MessageID;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String UnitDescription {get;set;}
        public String Model{get;set;}
        public String ContactName{get;set;}
        public String City{get;set;}
        public String FAInterfaced{get;set;}
        public String State{get;set;}
        public Integer ModelSeq{get;set;}
        public String ContactId{get;set;}
        public String AddressLine1{get;set;}
        public String OwnerName{get;set;}
        public String CustomerCode{get;set;}
        public String VIN{get;set;}
        public String ModelNumber{get;set;}
        public String UnitType{get;set;}
        public String UnitNumber{get;set;}
        public String Manufacturer{get;set;}
        public String Applicationcode{get;set;}
        public String EngineFamily{get;set;}
        public String ESN{get;set;}
        public String SalesSegment{get;set;}
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
        public Sender Sender;
        public Target Target;
        public Location Location;
    }

    public List<DataArea> DataArea {get;set;}
    public Header Header;

    public class Location {
        public String LocationID;
    }

    public static CSS_UnitOutboundJSON2Apex parse(String json) {
        return (CSS_UnitOutboundJSON2Apex) System.JSON.deserialize(json, CSS_UnitOutboundJSON2Apex.class);
    }

}