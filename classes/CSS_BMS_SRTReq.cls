public class CSS_BMS_SRTReq {
    public Header Header{get;set;}
    public DataArea[] DataArea{get;set;}
    public class Header {
        public Sender Sender{get;set;}
        public Target Target{get;set;}
        public Location Location{get;set;}
    }
    public class Sender {
        public String ServiceName{get;set;}
        public String SenderID{get;set;} //CSS
    }
    public  class Target {
        public String TargetID{get;set;} //SRT
    }
    public class Location{
        public String LocationID{get;set;}
    }
    public class DataArea {
        public String CSSJobID{get;set;}  
        public String Location{get;set;}  
        public String OrderType{get;set;} 
        public String ShopWOnumber{get;set;}  
        public String Accesscode{get;set;}  
        public String Model{get;set;}  
        public String SRTgroupnum{get;set;}  
        public String Procedureno{get;set;} 
        public String Stepnumber{get;set;}   
        public String SRTquantity {get;set;}
        public String Bill {get;set;}
        public String SRTTime {get;set;} 
        //public Decimal SRTTime {get;set;} commented by Rajesh Narra on 6/12/2018 during SIT
        public String ServiceModelName {get;set;}
        public String Note {get;set;}
        public String WarrantyAllocation {get;set;}
        public String AccountCode {get; set;}
        public String ClaimType {get; set;}
        public String CreateUser {get; set;}
        public String ChangeUser {get; set;}
    }
    public static CSS_BMS_SRTReq parse(String json){
        return (CSS_BMS_SRTReq) System.JSON.deserialize(json, CSS_BMS_SRTReq.class);
    }
    public static String parse(CSS_BMS_SRTReq obj){
        return (String) JSON.serialize(obj);
    }    

}