/**********************************************************************
Name: CSS_WPR_FCA_PrioritizedFCsResJSON2Apex
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Response JSON Wrapper 
            class of FCA Prioritized/UnPrioritized FCs
            service
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/28/2016     INITIAL DEVELOPMENT                    

***********************************************************************/
global class CSS_WPR_FCA_PrioritizedFCsResJSON2Apex {
      
      public String version;
      public String transactionId;
      public String algorithm;
      public List<PrioritizedData> PrioritizedData;
      public List<UnPrioritizedData> UnPrioritizedData;
    
      public class PrioritizedData {
          public String pri;
          public List<String> rel;
      }
    
      public class UnPrioritizedData {
          public String fc;
          public String rc;
      }
    
      public static CSS_WPR_FCA_PrioritizedFCsResJSON2Apex parse(String json) {
          return (CSS_WPR_FCA_PrioritizedFCsResJSON2Apex) System.JSON.deserialize(json, CSS_WPR_FCA_PrioritizedFCsResJSON2Apex.class);
      }
}