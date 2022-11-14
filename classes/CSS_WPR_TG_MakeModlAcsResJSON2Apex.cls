/**********************************************************************
Name: CSS_WPR_TG_MakeModlAcsResJSON2Apex
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Response JSON Wrapper class
            of GetMakeModelAccessList Rest Service1
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/03/2016     INITIAL DEVELOPMENT                    

***********************************************************************/
global class CSS_WPR_TG_MakeModlAcsResJSON2Apex {
      public Header Header;
      public DataArea DataArea;
    
      public class Header {
          public String ServiceName;
          public String ServiceVersion;
          public String Status;
          public String ReturnCodeDescription;
      }
      
      public class DataArea {
          public String PSN;
          public String SERVICEMODELNAME;
          public String SELECTMAKE;
          public String SELECTMODEL;
          public String SELECTACCESS;
          public List<MAKEMODELACCESS> MAKEMODELACCESS;
      }
      
      public class MAKEMODELACCESS {
          public String MAKE;
          public String MODEL;
          public String ACCESS;
      }
    
      public static CSS_WPR_TG_MakeModlAcsResJSON2Apex parse(String json) {
          return (CSS_WPR_TG_MakeModlAcsResJSON2Apex) System.JSON.deserialize(json, CSS_WPR_TG_MakeModlAcsResJSON2Apex.class);
      }
}