/**********************************************************************
Name: CSS_WPR_FCA_FaultDetailsReqJSON2Apex
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Request JSON Wrapper 
            class of FCA FaultDetails webservice
                                                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/29/2016     INITIAL DEVELOPMENT                    

***********************************************************************/
global class CSS_WPR_FCA_FaultDetailsReqJSON2Apex {
	
      public String serviceModelName;
      public List<String> faultList;

      /*
      public String serviceModelName;
      public FaultList faultList;
      
      public class FaultList {
          public List<String> fcs;
      }*/

    /*
      public String serviceModelName;
      public List<FaultList> faultList;
      
      public class FaultList {
          public String fc;
      } */
         
      public static CSS_WPR_FCA_FaultDetailsReqJSON2Apex parse(String json) {
          return (CSS_WPR_FCA_FaultDetailsReqJSON2Apex) System.JSON.deserialize(json, CSS_WPR_FCA_FaultDetailsReqJSON2Apex.class);
      }
}