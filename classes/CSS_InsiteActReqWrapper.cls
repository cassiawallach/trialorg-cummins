public class CSS_InsiteActReqWrapper {
    public String actionType{set;get;}
    public ActionProperties dsProperties{set;get;}
    //public List<AccessSRTList> accessSRTList{set;get;}  
    public class ActionProperties {
        public List<Properties> properties{set;get;}
    }
    public class Properties{
        public String propertyName {set;get;}
        public String propertyValue {set;get;}            
    }
   /* public class AccessSRTList{
        public String id {set;get;}
        public String displayId {set;get;}
        public String caption {set;get;}
    }*/
    public static String parse(CSS_InsiteActReqWrapper obj) {
        return System.JSON.serialize(obj);
    }   
}