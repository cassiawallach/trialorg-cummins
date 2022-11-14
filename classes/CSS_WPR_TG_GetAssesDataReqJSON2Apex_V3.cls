/**********************************************************************
Name: CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is a Request JSON Wrapper class of Version3 Triage/Assess of
            Rest Service2 for LaborHour with Components Data
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        11/15/2017       VERSION3 DEVELOPMENT                    
***********************************************************************/
global class CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 {
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
          public String UserLocation;
          public String CustomerName;
          public String ComplaintText;
          public String IASNumber;
          public List<FAULTLIST> faultList;
      }
      
      public class FAULTLIST {
          public String fc;
          public Integer occurenceTime;
          public String status;
          public Integer count;
      }
    
      public static CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 parse(String json) {
          return (CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3) System.JSON.deserialize(json, CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.class);
      }
}