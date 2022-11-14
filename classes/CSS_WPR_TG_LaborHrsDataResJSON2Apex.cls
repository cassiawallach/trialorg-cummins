/**********************************************************************
Name: CSS_WPR_TG_LaborHrsDataResJSON2Apex
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Labor Hours Response JSON Wrapper 
            class of GetAssessData Rest Service2
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/27/2016     INITIAL DEVELOPMENT                    

***********************************************************************/
global class CSS_WPR_TG_LaborHrsDataResJSON2Apex {
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
          public String algorithm;
          public List<PrioritizedData> prioritizedData;
          public List<UnPrioritizedData> unPrioritizedData;
      }
      
      public class PrioritizedData {
          public String prifc;
          //public String prifcdesc;   //Commented as part of CR#1
          public String lhrs;
          public List<Relfc> relfc;
      }
    
      public class UnPrioritizedData {
          public String upfc;
          //public String upfcdesc;    //Commented as part of CR#1
          public String rc;
      }
    
      public class Relfc {
          public String rfc;
          //public String rfcdesc;     //Commented as part of CR#1
      }
    
      public static CSS_WPR_TG_LaborHrsDataResJSON2Apex parse(String json) {
          return (CSS_WPR_TG_LaborHrsDataResJSON2Apex) System.JSON.deserialize(json, CSS_WPR_TG_LaborHrsDataResJSON2Apex.class);
      }
}