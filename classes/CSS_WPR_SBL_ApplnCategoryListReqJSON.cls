/**********************************************************************
Name: CSS_WPR_SBL_ApplnCategoryListReqJSON
Copyright © 2017  Cummins
======================================================
======================================================
Purpose:    This is a Application or Category/Complaint
Request JSON Wrapper class of SIEBEL Service
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        04/10/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_WPR_SBL_ApplnCategoryListReqJSON {

    public Header Header;
    
    public class Header {
    	public Sender Sender;
    }

    public class Sender {
        public String SenderID;
        public String ServiceName;
        public String MessageID;
        public String CreationDateTime;
    }

    public static CSS_WPR_SBL_ApplnCategoryListReqJSON parse(String json) {
        return (CSS_WPR_SBL_ApplnCategoryListReqJSON) System.JSON.deserialize(json, CSS_WPR_SBL_ApplnCategoryListReqJSON.class);
    }
}