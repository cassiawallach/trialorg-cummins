/**********************************************************************
Name: CG_SL_SIEBEL
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This class is used as a controller for Service layer 
by passing required parameters
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        01/26/2018     INITIAL DEVELOPMENT & Implementation of GetTechInfo/GetSPInfo services                
***********************************************************************/
public class CG_SL_SIEBEL {

    // Added by Abhishek
    public static CG_OP_OAGWrapper callgetMarketingApplicationCodes(String lastProcessedDate){
        CG_OP_OAGWrapper resWrapper;
        try{
            resWrapper = callGetInfoService(lastProcessedDate, 'getMarketingApplicationCodes');
        }catch(exception e){
            system.debug('Entered into catch block of callgetMarketingApplicationCodes method in CG_SL_SIEBEL class:'+e.getMessage()+' Line No:'+e.getLineNumber());
        }
        return resWrapper;
    }
    //End by ABhishek

    public static CG_OP_OAGWrapper callGetInfoService(String lastProcessedDate, String serviceName){
        CG_IP_OAGWrapper reqWrapper;
        CG_OP_OAGWrapper resWrapper;
        CG_WPR_SBL_GetInfoReqJSON reqJson;
        CG_OP_getApplicationCodesReqJSON reqJson1;
        try{
            reqWrapper = new CG_IP_OAGWrapper();
            //Prepare Request Wrapper
            if(serviceName =='GetSPHeader' || serviceName =='GetSPCertification' || serviceName =='GetSPAffiliation' 
               || serviceName =='GetSPTechInfo' || serviceName =='GetSPTechSMN'){
                reqJson = prepareReqJSONForInfoService(lastProcessedDate, serviceName);
                reqWrapper.jsonReqBody = JSON.serialize(reqJson);
            }else{
                reqJson1 = prepareReqJSONForMarkappcodes(lastProcessedDate, serviceName);
                reqWrapper.jsonReqBody = JSON.serialize(reqJson1);
            }
            System.debug('reqWrapper.jsonReqBody>>>>>:'+reqWrapper.jsonReqBody+' serviceName>>>:'+serviceName);
            reqWrapper.methodType = 'POST';
            reqWrapper.serviceName = serviceName;
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            if(reqWrapper.jsonReqBody != null ){
                if(reqWrapper.serviceName =='GetSPHeader' || reqWrapper.serviceName =='GetSPCertification' || reqWrapper.serviceName =='GetSPAffiliation' 
                   || reqWrapper.serviceName =='GetSPTechInfo' || reqWrapper.serviceName =='GetSPTechSMN')
                    resWrapper = CG_WS_Mule.calloutGeneric(reqWrapper);
                else
                    resWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
                System.debug('resWrapper.response>>>>>>>>>>>>>>>>>>>>:'+resWrapper.response);
            }
        }catch(exception e){
            system.debug('Entered into catch block of callGetInfoService method in CG_SL_SIEBEL class:'+e.getMessage()+' Line No:'+e.getLineNumber());
            resWrapper.exceptionFlag=true;
            resWrapper.errorMessage = e.getMessage();
            return resWrapper;
        }
        return resWrapper;
    }


    /*
   * This is used for Preparing Request JSON for 5 services of GetTechInfo/GetSPInfo
   */
    public static CG_WPR_SBL_GetInfoReqJSON prepareReqJSONForInfoService(String lastProcessedDate, String serviceName){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareReqJSONForInfoService webservice of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CG_WPR_SBL_GetInfoReqJSON reqJSON = null;
        CG_WPR_SBL_GetInfoReqJSON.Header headerObj = null;
        CG_WPR_SBL_GetInfoReqJSON.Sender senderObj = null;
        CG_WPR_SBL_GetInfoReqJSON.Target targetObj = null;
        CG_WPR_SBL_GetInfoReqJSON.DataArea dataAreaObj = null;
        try{

            //Prepare Request JSON
            reqJSON = new CG_WPR_SBL_GetInfoReqJSON();
            headerObj = new CG_WPR_SBL_GetInfoReqJSON.Header();
            senderObj = new CG_WPR_SBL_GetInfoReqJSON.Sender();
            targetObj = new CG_WPR_SBL_GetInfoReqJSON.Target();
            dataAreaObj = new CG_WPR_SBL_GetInfoReqJSON.DataArea();

            senderObj.SenderID = 'CSS';
            senderObj.ServiceName = serviceName; //'GetTechInfo' (or) 'GetSPInfo'
            targetObj.TargetID = 'SIEBEL';
            dataAreaObj.LastProcessedDate = lastProcessedDate;
            //dataAreaObj.LastProcessedDate = '2018-01-14';
            //dataAreaObj.SP_CODE = string.isNotBlank(spCodeStr) ? getSpCodelist(spCodeStr) : null;    
            headerObj.Sender =  senderObj;
            headerObj.Target =  targetObj;
            reqJSON.Header = headerObj;
            reqJSON.DataArea = dataAreaObj;

        }catch(Exception ex){
            System.debug('in catch of prepareReqJSONForInfoService of CG_SL_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return reqJSON;
    }

    // Added by Abhishek
    public static CG_OP_getApplicationCodesReqJSON prepareReqJSONForMarkappcodes(String lastProcessedDate, String serviceName){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareReqJSONForInfoService webservice of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CG_OP_getApplicationCodesReqJSON reqJSON = null;
        CG_OP_getApplicationCodesReqJSON.Header headerObj = null;
        CG_OP_getApplicationCodesReqJSON.Sender senderObj = null;
        CG_OP_getApplicationCodesReqJSON.Target targetObj = null;
        CG_OP_getApplicationCodesReqJSON.DataArea dataAreaObj = null;
        try{

            //Prepare Request JSON
            reqJSON = new CG_OP_getApplicationCodesReqJSON();
            headerObj = new CG_OP_getApplicationCodesReqJSON.Header();
            senderObj = new CG_OP_getApplicationCodesReqJSON.Sender();
            targetObj = new CG_OP_getApplicationCodesReqJSON.Target();
            dataAreaObj = new CG_OP_getApplicationCodesReqJSON.DataArea();

            senderObj.SenderID = 'CSS';
            senderObj.ServiceName = serviceName;
            targetObj.TargetID = 'SIEBEL';
            dataAreaObj.LAST_PROCESSED_DATE = lastProcessedDate;
            //dataAreaObj.LAST_PROCESSED_DATE = '2018-01-14';

            headerObj.Sender =  senderObj;
            headerObj.Target =  targetObj;
            reqJSON.Header = headerObj;
            reqJSON.DataArea = dataAreaObj;

        }catch(Exception ex){
            System.debug('in catch of prepareReqJSONForInfoService of CG_SL_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return reqJSON;
    }
    // End by Abhishek

    /*public static CG_OP_OAGWrapper callGetTechInfo(String lastProcessedDate, String spCodeStr){
        CG_OP_OAGWrapper resWrapper;
        try{
        resWrapper = callGetInfoService(lastProcessedDate, spCodeStr, 'GetTechInfo');
        }catch(exception e){
            system.debug('Entered into catch block of callGetTechInfo method in CG_SL_SIEBEL class:'+e.getMessage()+' Line No:'+e.getLineNumber());
        }
        return resWrapper;
    }

    public static CG_OP_OAGWrapper callGetSPInfo(String lastProcessedDate, String spCodeStr){
        CG_OP_OAGWrapper resWrapper;
        try{
        resWrapper = callGetInfoService(lastProcessedDate, spCodeStr, 'GetSPInfo');
        }catch(exception e){
            system.debug('Entered into catch block of callGetSPInfo method in CG_SL_SIEBEL class:'+e.getMessage()+' Line No:'+e.getLineNumber());
        }
        return resWrapper;
    }*/


    //Method to split the string spcode and send it as list for ws call
    /*public static list<string> getSpCodelist(string spCodeStr){
        list<string> lstpart = new list<string>();
        if(string.isNotBlank(spCodeStr)){
            lstpart = spCodeStr.split(',');
        }
        return lstpart;
    }*/

}