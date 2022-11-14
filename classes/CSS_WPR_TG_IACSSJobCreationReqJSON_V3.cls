/**********************************************************************
Name: CSS_WPR_TG_IACSSJobCreationReqJSON_V3
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is a Request JSON Wrapper class of Triage/Assess 
            of Rest Service2 for creating/updateing CSS Job using IA record
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        11/15/2017       VERSION3 DEVELOPMENT                    
***********************************************************************/
public class CSS_WPR_TG_IACSSJobCreationReqJSON_V3 {
    
    public Header Header;
    public DataArea DataArea;

    public class DataArea {
        public String IASNumber;
        public String CSSJobNumber;
    }

    public class Header {
        public String ServiceName;
        public String ServiceVersion;
        public String ToolID;
        public String SenderID;
        public String TargetID;
    }
    
    public static CSS_WPR_TG_IACSSJobCreationReqJSON_V3 parse(String json) {
        return (CSS_WPR_TG_IACSSJobCreationReqJSON_V3) System.JSON.deserialize(json, CSS_WPR_TG_IACSSJobCreationReqJSON_V3.class);
    }
}