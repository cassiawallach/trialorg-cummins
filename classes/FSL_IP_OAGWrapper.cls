public class FSL_IP_OAGWrapper {
    public String jsonReqBody{get;set;}
    public String methodType {get;set;} // GET;POST etc
    public Integer timeOut {get;set;} 
    public String serviceName {get;set;} //This should match with Name of Custom Setting
    
    //Constructor
    public FSL_IP_OAGWrapper(){}
}