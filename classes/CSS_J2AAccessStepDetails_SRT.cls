public class CSS_J2AAccessStepDetails_SRT {

  public class DataArea {
    public List<CaseResponse> CaseResponse;
    public String ResponseMessage;
  }

  public class CaseResponse {
    public String SRTTitle;
    public String SRTContent;
    public Double SRTTime;
    public String SRTAccessCode;
    public String SRTGroupProcedure;
  }

  public class Header {
    public String ReturnCodeDescription;
    public String Status;
  }

  public DataArea DataArea;
  public Header Header;

  
  public static CSS_J2AAccessStepDetails_SRT parse(String json) {
    return (CSS_J2AAccessStepDetails_SRT) System.JSON.deserialize(json, CSS_J2AAccessStepDetails_SRT.class);
  }
}