/************************************************************
Name:  OSM_OMS_WS_CreateOrderRes 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is request wrapper class. 

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Sharma            28/11/2018     INITIAL DEVELOPMENT          


*************************************************************/
public class OSM_OMS_WS_CreateOrderRes {
    public class Sender {
        public String ServiceName {get;set;} 
        public String SenderID {get;set;} 
    }
    
    public class Target {
        public String TargetID {get;set;} 
    }
    
    public class Header {
        public Sender Sender {get;set;} 
        public Target Target {get;set;} 
    }
    
    public class Error{
        public String ErrorDescription {get;set;} 
        public String ErrorCode {get;set;} 
    }
    
    public Header Header {get;set;} 
    public CreateOrderOutput CreateOrderOutput {get;set;} 
    public Error Error {get;set;} 
    
    public class CreateOrderOutput {
        public Integer OMSOrderID {get;set;} 
    }
    
    public static OSM_OMS_WS_CreateOrderRes  parse(String json) {
        return (OSM_OMS_WS_CreateOrderRes) System.JSON.deserialize(json, OSM_OMS_WS_CreateOrderRes.class);
    }
    
}