///
// v1.0    Bharat Reddy        10/10/2018
//
public class CG_ANVL_ReqWrapper {
    public String transactionId;    //123-abc
    public List<cls_workOrders> workOrders;
    public class cls_workOrders {
        public String id;   //Work Order Number
        public String description;  //Category and Complaint Value
        public String serial;   //Product Serial Number
        public String model;    //Service Model Name
        public String category; //Application Value
        public String type; //Mobile or In-Shop
        public String location;
        public cls_customer customer;
        public List<String> assigned;
        public String createdAt;    //2018-05-10T10:25:22.210Z
        public String updatedAt;    //2018-05-10T10:25:22.210Z
    }
    public class cls_customer {
        public String name; //Customer Name
        public String id;   //Customer Code
    }
    /* public class cls_assigned {
        public String WWID; //W
    } */
      public static CG_ANVL_ReqWrapper parse(String json) {
        return (CG_ANVL_ReqWrapper) System.JSON.deserialize(json, CG_ANVL_ReqWrapper.class);
    }
}