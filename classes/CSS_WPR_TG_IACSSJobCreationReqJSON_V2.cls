/**********************************************************************
Name: CSS_WPR_TG_IACSSJobCreationReqJSON_V2
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is a Request JSON Wrapper class of Triage/Assess 
            of Rest Service2 for creating CSS Job using IA record
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        02/01/2017       VERSION1 DEVELOPMENT                    
***********************************************************************/
public class CSS_WPR_TG_IACSSJobCreationReqJSON_V2 {
    
    public Header Header;
    public DataArea DataArea;

    public class DataArea {
        public String IASNumber;
    }

    public class Header {
        public String ServiceName;
        public String ServiceVersion;
        public String ToolID;
        public String SenderID;
        public String TargetID;
    }
    
    public static CSS_WPR_TG_IACSSJobCreationReqJSON_V2 parse(String json) {
        return (CSS_WPR_TG_IACSSJobCreationReqJSON_V2) System.JSON.deserialize(json, CSS_WPR_TG_IACSSJobCreationReqJSON_V2.class);
    }
}