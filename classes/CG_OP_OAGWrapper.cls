/*
 * Block comments with details of changes
 //Vamsi - 03/17 - test comments
 */
public class CG_OP_OAGWrapper
{

    public String accessToken {get;set;}
    public HttpResponse response{get;set;}
    public HttpRequest request {get;set;}
    public errorResponse errorResponse; //added
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

    public CG_OP_OAGWrapper()
    {
        exceptionFlag=false;  
        exceptionMessage = '';
        totalAuthCallTime=0;
        totalServiceCallTime=0;
    }
    //code added for error msg 14/04/2022---- CSM Dev Team 
    public class errorResponse{
        public string messageIdentifier;
        public Integer returnCode;
        public string returnCodeDescription;
        public string status;
        public string message;
        public string messageType;
        
    }
    //this comments use for Deployment purpose for missing  component Set
}