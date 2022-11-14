/**********************************************************************
Name: CSS_WPR_TG_GetAssessDataResJSON2Apex_V3
Copyright © 2017  Cummins
======================================================
======================================================
Purpose:    This is a Response JSON Wrapper class
            of GetAssessData Version3 of Rest Service2
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        11/15/2017       VERSION3 DEVELOPMENT                    
***********************************************************************/
global class CSS_WPR_TG_GetAssessDataResJSON2Apex_V3 {
      public Header Header;
      public DataArea DataArea;
    
      public class Header {
          public String ServiceName;
          public String ServiceVersion;
          public String Status;
          public String ReturnCodeDescription;
          public String TxnCodeDescription;
      }
      
      public class DataArea {
          public String PSN;
          public String algorithm;
          public String IASNumber;
          public String CSSEnabled;
          public List<PrioritizedData> prioritizedData;
          public List<UnPrioritizedData> unPrioritizedData;
      }
      
      public class PrioritizedData {
          public String prifc;
          //public String prifcdesc; //Commented as part of CR#1
          public List<Relfc> relfc;
      }
    
      public class UnPrioritizedData {
          public String upfc;
          //public String upfcdesc; //Commented as part of CR#1
          public String rc;
      }
    
      public class Relfc {
          public String rfc;
          //public String rfcdesc; //Commented as part of CR#1
      }
    
      public static CSS_WPR_TG_GetAssessDataResJSON2Apex_V3 parse(String json) {
          return (CSS_WPR_TG_GetAssessDataResJSON2Apex_V3) System.JSON.deserialize(json, CSS_WPR_TG_GetAssessDataResJSON2Apex_V3.class);
      }
}