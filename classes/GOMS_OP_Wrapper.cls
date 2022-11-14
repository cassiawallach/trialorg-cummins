public class GOMS_OP_Wrapper {
    public Header Header {get; set;}
    public String accessToken {get;set;}

    public String MessageIdentifier {get;set;}
    public String ReturnCode {get;set;}
    public String ReturnCodeDescription {get;set;}
    public String Status {get;set;}
    public String MessageType {get;set;}
    
    public HttpRequest Request {get;set;}
    public HttpResponse Response {get;set;}
    public Long totalAuthCallTime {get;set;} 
    public Long totalServiceCallTime {get;set;} 
    public String errorMessage {get;set;} 
    public Boolean exceptionFlag {get;set;}
    public string exceptionMessage {get; set;}
    
    public class Header {
        public string ReturnCodeDescription {get; set;}
        public string Status {get; set;}
    }
}