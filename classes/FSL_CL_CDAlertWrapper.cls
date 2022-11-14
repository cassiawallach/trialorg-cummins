public class FSL_CL_CDAlertWrapper {
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
    
    
    public static FSL_CL_CDAlertWrapper parse(String json) {
        return (FSL_CL_CDAlertWrapper) System.JSON.deserialize(json, FSL_CL_CDAlertWrapper.class);
    }
    
}