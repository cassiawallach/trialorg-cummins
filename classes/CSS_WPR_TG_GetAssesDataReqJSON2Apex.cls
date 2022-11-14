/**********************************************************************
Name: CSS_WPR_TG_GetAssesDataReqJSON2Apex
Copyright © 2016  Cummins
=======================================================================
=======================================================================
Purpose:    This is a Request JSON Wrapper class of Triage/Assess of
            Rest Service2 for LaborHour with Components Data
                                                          
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/04/2016     INITIAL DEVELOPMENT                    

***********************************************************************/
global class CSS_WPR_TG_GetAssesDataReqJSON2Apex {
      public Header Header;
      public DataArea DataArea;
    
      public class Header {
          public String ServiceName;
          public String ServiceVersion;
          public String ToolID;
          public String SenderID;
          public String TargetID;
      }
      
      public class DataArea {
          public String PSN;
          public String SERVICEMODELNAME;
          public String ERT;
          public String MAKE;
          public String MODEL;
          public String ACCESS;
          public List<FAULTLIST> faultList;
      }
      
      public class FAULTLIST {
          public String fc;
          public Integer occurenceTime;
          public String status;
          public Integer count;
      }
    
      public static CSS_WPR_TG_GetAssesDataReqJSON2Apex parse(String json) {
          return (CSS_WPR_TG_GetAssesDataReqJSON2Apex) System.JSON.deserialize(json, CSS_WPR_TG_GetAssesDataReqJSON2Apex.class);
      }
}