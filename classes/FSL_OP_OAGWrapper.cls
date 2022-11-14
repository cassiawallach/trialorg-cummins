public class FSL_OP_OAGWrapper {
    public String accessToken {get;set;}
    public HttpResponse response{get;set;}
    public HttpRequest request {get;set;}
    
    public String appName;
    public String endPoint;
    public String serviceName;
    public String methodStarted;
    
    public String methodNameSLLayer;
    public String requestBody;
    
    public Long totalAuthCallTime {get;set;}
    public Long totalServiceCallTime {get;set;}
    
    public boolean exceptionFlag{get;set;}
    public String errorMessage{get;set;}
    public String exceptionMessage{get;set;}
    
    public String bmsStatus{get;set;}
    
    public FSL_OP_OAGWrapper() {
        exceptionFlag=false;  
        exceptionMessage = '';
        totalAuthCallTime=0;
        totalServiceCallTime=0;
    }
}