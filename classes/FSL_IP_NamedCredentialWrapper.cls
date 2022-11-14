public class FSL_IP_NamedCredentialWrapper {

    public String jsonReqBody{get;set;}
    public String methodType {get;set;} // GET;POST etc
    public Integer timeOut {get;set;} 
    //public String serviceName {get;set;} //This should match with Name of Custom Setting
    public String NamedCredential;
    public String Path;
    public String Authinfo;
    public string endPoint {get;set;}
    public string WorkOrder;
    public string error;
    public FSL_IP_NamedCredentialWrapper()
    {
        
    }
}