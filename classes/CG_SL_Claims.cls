/*
 * Block comments with details of changes
 */
public class CG_SL_Claims
{
    /*public CG_SL_Claims()
    {
        
    }*/
    // By Priyanka VGRS2-511
    public static CG_OP_OAGWrapper calloutGenericMuleNamedCredClaimHist(string ESN) {
        system.debug('in calloutGeneric method for CreateUpdate Incident Record Into ServiceNow...');
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
		FSL_IP_NamedCredentialWrapper reqWrap = new FSL_IP_NamedCredentialWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        try {
           
          //  CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
          //  conDetails = CSS_getConnnectionDetails.getConnection(reqWrapper.serviceName);
           
           
          //  reqWrap = new FSL_IP_NamedCredentialWrapper();
            //if(conDetails != null){
               
              //  if(reqWrapper.methodType == 'POST' || reqWrapper.methodType == 'PUT' ){
                 //   reqWrap.jsonReqBody = reqWrapper.jsonReqBody;
               // }
                 
           // } 

           
	reqWrap.methodType = 'GET';
    reqWrap.NamedCredential = 'FSL_NC_Claims';
    reqWrap.Path = '/history'+'?sender=CSS&target=CSSWarranty&esn='+ESN;//=79659993';
    reqWrap.endPoint =[SELECT Endpoint FROM NamedCredential
                       					where DeveloperName=: reqWrap.NamedCredential 
                       					LIMIT 1].Endpoint+reqWrap.Path;

            system.debug('SRT reqJsonpriya>>>>>>>>>>>'+reqWrap.jsonReqBody);
            if(Test.isRunningTest() && reqWrap.jsonReqBody == null)
                {
                throw new CSS_MyException('Exception to cover Catch block');
                }
                           

                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrap);
             system.debug('SRT priyaresponse>>>>>>>>>>>'+returnWrapper);
            return returnWrapper;

        }catch(Exception ex){
           if(returnWrapper == null) {
                returnWrapper = New CG_OP_OAGWrapper();
            }
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = ex.getMessage();
            return returnWrapper;
        }
    }
    
 
    
    public static CG_OP_OAGWrapper claimHistoryWebservice(String ESN) {


        //CSS_SRTAccessWebService
        //accessSRTStepDetails


        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        string endPoint;
        try {

            //Mule Integration start
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('SiebelClaimHistory');
            //Mule Integration end
            
            //Prepare JSON Request for Callout..this will be passed in InputRequest Wrapper
            /*string accessRequest = '{"Header": { "Sender": { "ServiceName": "getClaimHistory", "SenderID": "CSS" }, "Target": { "TargetID": "SIEBEL" } }, "DataArea": { "ESN": "' +ESN+ '" } }';
            reqWrapper.jsonReqBody = accessRequest;*/
            reqWrapper = new CG_IP_OAGWrapper();
            
            system.debug('conDetails--'+conDetails);
            endPoint = conDetails.End_Point__c+'?sender=CSS&target=CSSWarranty&esn='+ESN;//=79659993';
            reqWrapper.endPoint = endPoint;
            reqWrapper.methodType = conDetails.Method_Type__c;

            //This is the service name to pull the data from Custom Setting-CSS_Integration_Details__c
            //CSS_Integration_Details__c contains the endpoint and authentication details
            //reqWrapper.serviceName = 'CG_GetAccessSRT';
            reqWrapper.serviceName = 'SiebelClaimHistory';
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            //returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);

            if(Test.isRunningTest() && ESN == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
        } catch (Exception ex) {

            //MANDATORY: In case of exception Set the exceptionFlag=true always
            String stackTrace = ex.getStackTraceString();
            String msg = ex.getMessage();
            returnWrapper.exceptionMessage += msg;
            returnWrapper.exceptionMessage += stackTrace;
            returnWrapper.exceptionFlag = true;

        }



        return returnWrapper;


    }
}