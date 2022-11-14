public class CSS_getPartsListBMSResponseJ2A {
    public cls_Header Header;
    public class cls_Header {
        public String Status;   //success
        public String ReturnCodeDescription;    //Parts Updated successfully
        public cls_Location Location;
    }
    public class cls_Location {
        public String LocationID;   //02400-02394
    }
    public static CSS_getPartsListBMSResponseJ2A  parse(String json){
        return (CSS_getPartsListBMSResponseJ2A ) System.JSON.deserialize(json, CSS_getPartsListBMSResponseJ2A .class);
    }


}