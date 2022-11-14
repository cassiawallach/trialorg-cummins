public class OSM_WS_SubmitOrderInfo_RESONSE {
    public class Sender {
        public String messageID;
        public String serviceName;
        public String senderId;
    }

    public class Target {
        public String targetId;
    }

    public class DataArea {
        public P_FSD_OUT headerList;
        public String distributorCode;
        public String customerCode;
    }

    public DataArea dataArea;
    public Header header;

    public class P_FSD_OUT {
        public String remitToName;
        public String purchaseOrderNumber;        
        public String branchLocation;        
        public String totalDiscount;
        public String orderSourceType;
        public String invoiceTotal;        
        public String invoiceNumber;        
        public String invoiceDate;
        public String createDate;
        public String orderReferenceNumber;
        public String remitToAddress;
        public String remitToCity;
        public String remitToState;
        public String PdfRemittoAddress;
        public String remitToPostalCode;
        public String attribute01;
        public String attribute02;
        public String attribute03;
    }

    public class Header {
        public String status;
        public Sender sender;
        public Target target;
        public String returnCodeDescription;
        public Location location;
    }

    public class Location {
        public String locationId;
    }    
    public static OSM_WS_SubmitOrderInfo_RESONSE parse(String json) {
        return (OSM_WS_SubmitOrderInfo_RESONSE) System.JSON.deserialize(json, OSM_WS_SubmitOrderInfo_RESONSE.class);
    }
}