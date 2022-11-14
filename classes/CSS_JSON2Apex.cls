/**********************************************************************
Name:CSS_JSON2Apex
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
JSON Parser wrapper class for INSITE JSON                                                           
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR          DATE              DETAIL                               
1.0 -   Gyan Pany      11/6/2015        INITIAL DEVELOPMENT                   
2.0 -   Gyan Pany      2/9/2016         UDAC WIRE FRAME CHANGES              
3.0 -   Anirudh        2/11/2016        Coding Standards
***********************************************************************/

public class CSS_JSON2Apex {
    
    public class FaultCode {
        public FD FD;
        public String IMGNM;
        public String Mod;
        public String PAT;
    }
    
    public class UFD {
        public List<string> UPA;
        public List<String> UPI;
    }
    
    public String CUSTNAME;
    public String CJOD;
    public String TI;
    public String UNT;
    public String ESN;
    public String ERT;
    public String ETD;
    public String TMS;
    public List<FaultCode> FaultCode;
    
    public class APD {
        public String P;
        public List<String> R;
    }
    
    
    public class FD {
        public List<APD> APD;
        public List<string> BPD;
        public UFD UFD;
    }
    
    
    public static CSS_JSON2Apex parse(String json) {
        return (CSS_JSON2Apex) System.JSON.deserialize(json, CSS_JSON2Apex.class);
    }
}