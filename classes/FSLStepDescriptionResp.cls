public class FSLStepDescriptionResp {
    
    public dataarea dataarea;
    public header header;
    public class DataArea {
        public list <CaseResponse> CaseResponse;
    }
    public class CaseResponse {
        public string SRTAccessCode ;
        public string SRTGroupProcedure;
        public string SRTTime;
        public string SRTContent;
        public string SRTTitle;
    }
    public class Header {
        public string Status ;
        public string ReturnCodeDescription;
    }
    
    public static FSLStepDescriptionResp parse(String json){
        return (FSLStepDescriptionResp) System.JSON.deserialize(json, FSLStepDescriptionResp.class);
    }
}