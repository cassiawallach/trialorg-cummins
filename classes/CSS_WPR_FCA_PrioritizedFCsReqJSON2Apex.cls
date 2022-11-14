/**********************************************************************
Name: CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Request JSON Wrapper 
            class of FCA Prioritized/UnPrioritized FCs
            service
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/29/2016     INITIAL DEVELOPMENT                    

***********************************************************************/
global class CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex {
      
      public Integer version;
      public String toolId;
      public String token;
      public String esn;
      public Integer currentRunTime;
      public FaultList faultList;

      public class FaultList {
          public List<Items> items;
      }
     
      public class Items {
          public String fc;
          public Integer occurenceTime;
          public String status;
          public Integer count;
      }
    
      public static CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex parse(String json) {
          return (CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex) System.JSON.deserialize(json, CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex.class);
      }
}