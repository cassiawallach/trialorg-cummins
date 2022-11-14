global class CSS_GetJobInfoReqWrapper {
    
    public class DataArea {
    public String CSSJobID;
    public String ShopWO;   
  }

  public class Header {
    public String ServiceName;
    public String ServiceVersion;
    public String ToolID;
    public String SPCode;
    public String SenderID;
    public String TargetID;
  }

  public Header Header;
  public DataArea DataArea;

 

  public static CSS_GetJobInfoReqWrapper parse(String json) {
    return (CSS_GetJobInfoReqWrapper) System.JSON.deserialize(json, CSS_GetJobInfoReqWrapper.class);
  }
}