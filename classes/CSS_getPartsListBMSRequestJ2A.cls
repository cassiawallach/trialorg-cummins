public class CSS_getPartsListBMSRequestJ2A {
    public cls_Header Header;
    public cls_DataArea DataArea;
    public class cls_Header {
        public cls_Sender Sender;
        public cls_Target Target;
        public cls_Location Location;
    }
    public class cls_Sender {
        public String ServiceName;  //SendGSQParts
        public String SenderID; //CSS
    }
    public class cls_Target {
        public String TargetID; //BMS
    }
    public class cls_Location {
        public String LocationID;   //02400-02394
    }
    public class cls_DataArea {
        public String CSSJobID; //C00012345
        public String DistributorCode;  //02400
        public String DistributorBranchCode;    //02394
        public String OrderType;    //WOQT
        public String BMSQuoteID;   //123456
        public cls_PartDetails[] PartDetails;
    }
    public  class cls_PartDetails {
        public String ProductCodeOEM;   //CECO
        public String PartNumberService;    //431894700
        public Integer Quantity;    //4
        public Integer AllocationWarranty;
        public String AccountCode;
        public String ClaimType;
        public String CreateUser;
        public String ChangeUser;
        public Integer PartsPricing;
    }
    public static CSS_getPartsListBMSRequestJ2A  parse(String json){
        return (CSS_getPartsListBMSRequestJ2A ) System.JSON.deserialize(json, CSS_getPartsListBMSRequestJ2A .class);
    }
}