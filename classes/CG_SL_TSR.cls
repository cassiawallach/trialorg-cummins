public class CG_SL_TSR {
    
    public static CG_OP_OAGWrapper TSRWebservice(User currentuser,CSS_Job_Order__c ServiceJob,List<CSS_Fault_Code__c> faultCodes,List<CSS_SymptomQA__c> SymptomSrch,String TechId,String CustomerSupportLevel,String ComplaintCode,String EscalationGroup){
        
         CG_IP_OAGWrapper reqWrapper = null;
         CG_OP_OAGWrapper returnWrapper;
        try{ 
        //Prepare Request Wrapper
        CG_TSRReqJSONParser reqJson = CG_SL_TSRParser.prepareReqWrapper(currentuser,ServiceJob,faultCodes,SymptomSrch,TechId,CustomerSupportLevel,ComplaintCode,EscalationGroup);    
        
        reqWrapper = new CG_IP_OAGWrapper();
        reqWrapper.jsonReqBody = string.valueOf(reqJson);
        
        
        //This is the service name to pull the data from Custom Setting-CSS_Integration_Details__c
        //CSS_Integration_Details__c contains the endpoint and authentication details
        //reqWrapper.serviceName = 'CG_GetAccessChecklistSRT';
        //reqWrapper.methodType = 'POST';
        //reqWrapper.serviceName = 'TSR';
        
        system.debug('Anirudh reqJson>>>>>>>>>>>'+reqJson);
        //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
        if(reqJson != null)
        returnWrapper = CG_WS_OAG.calloutTSRService(reqJson);
        
        return returnWrapper;
        }catch(exception e){
            system.debug('Entered into catch block of TSRWebservice method in CG_SL_TSR class' + e.getMessage() + ' ' + e.getLineNumber());
              returnWrapper.exceptionFlag=true;
              returnWrapper.errorMessage = e.getMessage();
              return returnWrapper;

        }
    }

}