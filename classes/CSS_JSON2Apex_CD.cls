/**********************************************************************
Name:CSS_JSON2Apex_CD
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE                    DETAIL                       
1.0 - Shruti Umamaheshwaran     1/25/2016                 INITIAL DEVELOPMENT             
2.0 - Gyan Pany                 2/9/2016                  UDAC WIRE FRAME CHANGES        
3.0 - Anirudh                   2/11/2016                 Coding Standards
***********************************************************************/

public class CSS_JSON2Apex_CD {
    
    public String response_Version;
    public String engine_Serial_Number;
    public String total_Distinct_Faults;
    public List<Distinct_Fault_Code_Info> distinct_Fault_Code_Info;
    
    public class Distinct_Fault_Code_Info {
        public String fault_Code;
        public String fault_Code_Description;
        public String latest_Occurrence_Date_Time;
        public String total_Occurrence_Count;
    }
    
    
    public static CSS_JSON2Apex_CD parse(String json) {
        return (CSS_JSON2Apex_CD) System.JSON.deserialize(json, CSS_JSON2Apex_CD.class);
    }
}