/**********************************************************************
Name: CSS_WPR_FCA_FaultDetailsResJSON2Apex
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Response JSON Wrapper 
            class of FCA FaultDetails webservice
                                                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/29/2016     INITIAL DEVELOPMENT                    
2.0     Vignesh S/Gyan P  11/02/2016     ADDED MODEL FOR EXCEPTION LIST AND REASONCODE  
***********************************************************************/
global class CSS_WPR_FCA_FaultDetailsResJSON2Apex {
      
      public List<FaultDetailsList> faultDetailsList;
      public List<ExceptionList> exceptionList;
      public String reasonCode;
      public class FaultDetailsList {
          public String faultCode;
          public String rootCause1;
          public String likelihood1;
          public String rootCause2;
          public String likelihood2;
          public String rootCause3;
          public String likelihood3;
          public String rootCause4;
          public String likelihood4;
          public String faultCodeDescription;
      }
      public class ExceptionList {
          public String faultCode;
          public String reasonCode;
      }         
      public static CSS_WPR_FCA_FaultDetailsResJSON2Apex parse(String json) {
          return (CSS_WPR_FCA_FaultDetailsResJSON2Apex) System.JSON.deserialize(json, CSS_WPR_FCA_FaultDetailsResJSON2Apex.class);
      }
}