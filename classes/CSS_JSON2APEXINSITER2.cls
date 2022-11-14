/**********************************************************************
Name:CSS_JSON2APEXINSITER2
Copyright © 2011  Cummins
=======================================================================
=======================================================================
Purpose:                                                            
JSON Parser wrapper class for INSITE JSON                                                           
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR          DATE              DETAIL                               
1.0 -   Gyan Pany      11/6/2015        INITIAL DEVELOPMENT                   
2.0 -   Gyan Pany      2/9/2016         UDAC WIRE FRAME CHANGES              
3.0 -   Anirudh        2/11/2016        Coding Standards
4.0 -   Anirudh        3/10/2016        Modified the code as per new JSON
5.0 -   Ronnie Mishra  07/21/2022       Modified FDCountFDMeta as part of 
                                        SG-2 to add Boolean flag ABRFaultFlag
***********************************************************************/

public class CSS_JSON2APEXINSITER2 {
    
    public String CJOD;
    public String CJOD_Flag; 
    public String TI;
    public String TMS;
    public String TransactionID;
    public Boolean ABRFlag;
    public String LOCATION_ID; // Sai:0928: Added as part of 64449.
    public List<Module> Module;
    
    public class Module{
        public String mod;
        public Header header;
        public List<SDP> SDP;   
        public FD FD;
        public List<FDCountFDMeta> FDMeta;
        public String PAT;
        public Boolean ABRFlag;
        public String transactionID;
    }
    public class Header{
        public String CUSTNAME;
        public String UNT;
        public String CORE;
        public String ESN;
        public String ERT;
        public String ETD;        
        public String KOT;     
        public String IMGNM;
        public String IMGCSV; // Rajesh Narra: Added the JSON Key as part of the story number 177364.          
    }
    public class SDP{
        public String field;
        public String value;
    }    
    public class FD {
        public List<APD> APD;
        public List<string> BPD;
        public UFD UFD;        
    }  
    public class APD {
        public String P;
        public List<String> R;
    }        
    public class UFD {
        public List<string> UPA;
        public List<String> UPI;
    } 
    public class FDCountFDMeta{
        Boolean ABRFaultFlag;
        public String FC; 
        public String count;
        public String status;
    }                
    
    
    public static CSS_JSON2APEXINSITER2 parse(String json) {
        return (CSS_JSON2APEXINSITER2) System.JSON.deserialize(json, CSS_JSON2APEXINSITER2.class);
    }
}