public with sharing class ApplicationLogHelper{
    public static void logException(String xactnType,String compType,String comp,String obj, String method, Exception ex){ 
        
        String errMsg = ex==null?'Error in -'+xactnType+'-'+compType+ '-'+comp : 'Error Details - '+ex.getLineNumber()+ex.getMessage()+ex.getStackTraceString(); 
        if(Test.isRunningTest()){
            nebula.Logger.error(errMsg);
            //createLog(new CUM_Logger__e());
            createLog(new nebula__LogEntryEvent__e());
        }else{
            nebula.Logger.error(errMsg, ex);        
        }
        nebula.Logger.info(errMsg);
        nebula.Logger.saveLog();
    }
    public static void logException(String module,String cls, String method, Exception ex){
        String errMsg = ex==null?'Error in -'+module+'-'+cls+ '-'+method :'Error '+ ex.getMessage()+ ' in -'+module+'-'+cls+ '-'+method;
        List<String> errList = new List<String> ();
        String errDetails = ex==null?'Error in -'+module+'-'+cls+ '-'+method :'Error Details - '+ex.getLineNumber()+ex.getMessage()+ex.getStackTraceString();
        System.Debug(errMsg+'\n'+errDetails);  
        if(Test.isRunningTest()){
            nebula.Logger.error(errMsg);
        }else{
            nebula.Logger.error(errMsg, ex);        
        }
        nebula.Logger.saveLog();
    }
    public static void logDMLException(String module,String cls, String method, Database.Error ex){
        
        String errMsg = ex==null?'Error in -'+module+'-'+cls+ '-'+method : 'Error '+ ex.getMessage()+ ' in -'+module+'-'+cls+ '-'+method;
        List<String> errList = new List<String> ();
        nebula.Logger.error(errMsg);
        nebula.Logger.saveLog();
    }
   /* public static  void createLog(CUM_Logger__e evt){
        Database.SaveResult pubResult = EventBus.publish(evt);
    }*/
     public static  void createLog(nebula__LogEntryEvent__e  evt){
        Database.SaveResult pubResult = EventBus.publish(evt);
        
    }
}