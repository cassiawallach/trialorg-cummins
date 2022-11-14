public class OSM_SignatureMismatchException extends Exception {

   
        
    public OSM_SignatureMismatchException(String exceptionMsg, Boolean exceptionFlag )
    {
        this.exceptionFlag = exceptionFlag;
        this.exceptionMessage = exceptionMsg;
    }
    
    public boolean exceptionFlag{get;set;}
    public String exceptionMessage{get;set;}
    
    

    
    
}