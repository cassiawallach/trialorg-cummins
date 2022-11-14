/*
* CT3-198: This class used for Send Job technician information to ANVL. 
* @Author: Dinesh Yadav, Created Date: 26 Nov 2020.
*/ 
public class FSL_ANVL_ReqWrapper {
    public cls_Header Header;
    public cls_DataArea DataArea;
    public class cls_Header {
        public cls_Sender Sender;
        public cls_Target Target;
    }
    public class cls_Sender {
        public String SenderID; //CSS
    }
    public class cls_Target {
        public String TargetID; //BMS
    }
    
    public class cls_DataArea {
        public String transactionId;  //123-abc
        public List<cls_workOrders> workOrders;
    }
    
    public class cls_workOrders{
        public String id;  //Work Order Number
        public String description;  //Category and Complaint Value
        public String serial;  //Product Serial Number
        public String model;  //Service Model Name
        public String category;  //Application Value
        public String type;  //Mobile or In-Shop
        public String location;
        public cls_customer customer;
        public List<String> assigned;
        public String createdAt;  //2018-05-10T10:25:22.210Z
        public String updatedAt;  //2018-05-10T10:25:22.210Z
    }
    public class cls_customer {
        public String name;  //Customer Name
        public String id;  //Customer Code
    }
    
    public static FSL_ANVL_ReqWrapper parse(String json){
        return (FSL_ANVL_ReqWrapper) System.JSON.deserialize(json, FSL_ANVL_ReqWrapper.class);
    }
}