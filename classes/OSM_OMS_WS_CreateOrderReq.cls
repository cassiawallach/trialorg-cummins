/************************************************************
Name:  OSM_OMS_WS_CreateOrderReq
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
public class OSM_OMS_WS_CreateOrderReq {

    public class LicenseInfo {
        public String AdminId {get;set;} 
        public String LicenseName {get;set;} 
        public LicAttributes LicAttributes {get;set;} 
        public LicPolicy LicPolicy {get;set;} 
        public String TotalCopies {get;set;} 
        public String CountsPerCopy {get;set;} 
        public String Duration {get;set;} 
        public String StartDate {get;set;} 
        }
        
        public class Products {
        public String Product {get;set;}
        }
        
        public class Message {
        public String MessageID {get;set;} 
        public String Timestamp {get;set;} 
        }
        
        public class CreateOrderInput {
        public String ToolName {get;set;} 
        public String RequesterId {get;set;} 
        public LicenseInfoList LicenseInfoList {get;set;} 
        }
        
        public class LicAttributes {
        public Features Features {get;set;} 
        public FeatureGroups FeatureGroups {get;set;} 
        public Products Products {get;set;} 
        public List<ProductGroups> ProductGroups {get;set;} 
        }
        
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
        public Message Message {get;set;} 
        }
        
        public class FeatureGroups {
        public String FeatureGroup {get;set;} 
        }
        
        public Header Header {get;set;}
        public CreateOrderInput CreateOrderInput {get;set;} 
        
        
        public class Features {
        public String Feature {get;set;} 
        }
        
        public class ProductGroups {
        public List<String> ProductGroup {get;set;} 
        }
        
        public class LicenseInfoList {
        public List<LicenseInfo> LicenseInfo {get;set;} 
        }
        
        public class LicPolicy {
        public String NumberOfRehosts {get;set;} 
        public String NumberOfRepairs {get;set;} 
        public String NumberOfReinstalls {get;set;} 
        public String RevalidationPeriod {get;set;} 
        }
        
       public static OSM_OMS_WS_CreateOrderReq parse(String json) {
        return (OSM_OMS_WS_CreateOrderReq) System.JSON.deserialize(json, OSM_OMS_WS_CreateOrderReq.class);
    }

}