/**********************************************************************
Name:CG_SL_ANVL
Copyright © 2011  Cummins
======================================================================
======================================================================
Purpose:                                                            
This class is used to call ANVL system using the prepared request JSON 
through parser.
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                           
1.0 - Anirudh Reddy    11/28/2018       Initial Development
***********************************************************************/
public class CG_SL_ANVL {
    
    public static CG_OP_OAGWrapper ANVLWebservice(CSS_Job_Order__c ServiceJob){
        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        try{ 
            //Prepare Request Wrapper
            CG_ANVL_ReqWrapper reqJson = CG_SL_ANVLParser.prepareReqWrapper(ServiceJob);    
            
            reqWrapper = new CG_IP_OAGWrapper();
            if(reqJson != null){
                reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');
            }else{
                returnWrapper.exceptionFlag = true;
                returnWrapper.exceptionMessage = 'Mandatory values-technician information is not present.Hence not calling the service.';
                return returnWrapper;
            }
            //This is the service name to pull the data from Custom Setting-CSS_Integration_Details__c
            //CSS_Integration_Details__c contains the endpoint and authentication details
            reqWrapper.serviceName = 'CG_ANVLService';
            reqWrapper.methodType = 'POST';
            
            system.debug('Anirudh ANVL reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            if(reqJson != null)
                returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
            return returnWrapper;
        }catch(exception e){
            system.debug('Entered into catch block of ANVLWebservice in CG_SL_ANVL class>>>>>>>>>>>>>>>>>>>>>>>'+e.getLineNumber() + ' ' + e.getMessage());
            returnWrapper.exceptionFlag = true;
            returnWrapper.exceptionMessage = e.getMessage();
            return returnWrapper;
        }
    }
}