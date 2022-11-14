/**********************************************************************
Name: CSS_WPR_TG_IACSSJobCreationResJSON_V2
Copyright © 2017  Cummins
======================================================
======================================================
Purpose:    This is a Response JSON Wrapper class
            of CreateIACSSJob of Rest Service2
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        02/01/2017       VERSION1 DEVELOPMENT                    
***********************************************************************/
public class CSS_WPR_TG_IACSSJobCreationResJSON_V2 {

    public Header Header;
    public DataArea DataArea;

    public class DataArea {
        public String IASNumber;
        public String CSSJobNumber;
    }

    public class Header {
        public String Status;
        public String ServiceVersion;
        public String ServiceName;
        public String ReturnCodeDescription;
    }
    
    public static CSS_WPR_TG_IACSSJobCreationResJSON_V2 parse(String json) {
        return (CSS_WPR_TG_IACSSJobCreationResJSON_V2) System.JSON.deserialize(json, CSS_WPR_TG_IACSSJobCreationResJSON_V2.class);
    }
}