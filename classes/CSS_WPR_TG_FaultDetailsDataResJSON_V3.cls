/**********************************************************************
Name: CSS_WPR_TG_FaultDetailsDataResJSON_V3
Copyright © 2017  Cummins
======================================================
======================================================
Purpose:    This is a FaultDetails Data Response JSON Wrapper 
            class of GetAssessData Rest Service2
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
3.0     Surender M        11/10/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CSS_WPR_TG_FaultDetailsDataResJSON_V3 {
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
          //public String prifcdesc;  //Commented as part of CR#1
          public String rootCause1;
          public String rc1Likelihood;
          public String rootCause2;
          public String rc2Likelihood;
          public String rootCause3;
          public String rc3Likelihood;
          public String rootCause4;
          public String rc4Likelihood;
          //public String lhrs; //removed this field in V3
          public List<Relfc> relfc;
          public Lhrprob lhrprob;
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
    
      public class Lhrprob {
		public String lbrprob1;
		public String lbrprob2;
		public String lbrprob3;
		public String lbrprob4;
	  }
    
      public static CSS_WPR_TG_FaultDetailsDataResJSON_V3 parse(String json) {
          return (CSS_WPR_TG_FaultDetailsDataResJSON_V3) System.JSON.deserialize(json, CSS_WPR_TG_FaultDetailsDataResJSON_V3.class);
      }
}