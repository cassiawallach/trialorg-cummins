/**********************************************************************
Name: CSS_WPR_TG_MakeModlAcsReqJSON2Apex
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Request JSON Wrapper class
            of GetMakeModelAccessList Rest Service1
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/03/2016     INITIAL DEVELOPMENT                    

***********************************************************************/
global class CSS_WPR_TG_MakeModlAcsReqJSON2Apex {
      public Header Header;
      public DataArea DataArea;
    
      public class DataArea {
          public String PSN;
      }
    
      public class Header {
          public String ServiceName;
          public String ServiceVersion;
          public String ToolID;
          public String SenderID;
          public String TargetID;
      }

      public static CSS_WPR_TG_MakeModlAcsReqJSON2Apex parse(String json) {
          return (CSS_WPR_TG_MakeModlAcsReqJSON2Apex) System.JSON.deserialize(json, CSS_WPR_TG_MakeModlAcsReqJSON2Apex.class);
      }
}