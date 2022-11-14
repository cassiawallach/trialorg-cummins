/**********************************************************************
Name: CSS_WS_FCA
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This class contains webservices of FCA app
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        09/12/2016     INITIAL DEVELOPMENT                    
***********************************************************************/

global with sharing class CSS_WS_FCA {
    
    /*
    * This method is used for preparing request JSON for FCA service
    **/
    global static CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex prepareReqJSONForProitizedFCsServiceOfFCA(CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON, String token){
        System.debug('################# entered into prepareReqJSONForProitizedFCsServiceOfFCA method ###################');
        CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex fcaPriFCsReqJSON = null;
        try{
            fcaPriFCsReqJSON = new CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex();
            fcaPriFCsReqJSON.version = 1;
            fcaPriFCsReqJSON.toolId = 'CSS';
            fcaPriFCsReqJSON.token = token;
            fcaPriFCsReqJSON.esn = reqJSON.DataArea.PSN;
            fcaPriFCsReqJSON.currentRunTime = Integer.valueOf(reqJSON.DataArea.ERT);
            System.debug('reqJSON.Header>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+reqJSON.Header);
            System.debug('reqJSON.Header.ServiceVersion>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+reqJSON.Header.ServiceVersion);
            System.debug('reqJSON.Header.ToolID>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+reqJSON.Header.ToolID);
            System.debug('reqJSON.DataArea.PSN>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+reqJSON.DataArea.PSN);
            System.debug('reqJSON.reqJSON.DataArea.ERT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+reqJSON.DataArea.ERT);
            System.debug('token>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+token);
            
            fcaPriFCsReqJSON.faultList = new CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex.FaultList();
            fcaPriFCsReqJSON.faultList.items = new List<CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex.Items>(); 
            //loop list & assign here
            CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex.Items item = null;
            System.debug('reqJSON.DataArea>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+reqJSON.DataArea);
            for(CSS_WPR_TG_GetAssesDataReqJSON2Apex.FAULTLIST faultListObj :reqJSON.DataArea.faultList){
                item = new CSS_WPR_FCA_PrioritizedFCsReqJSON2Apex.Items();
                item.fc = faultListObj.fc;
                item.occurenceTime = faultListObj.occurenceTime;
                if(item.status != null && item.status != '')
                	item.status = faultListObj.status.toLowerCase();
                else
                    item.status = faultListObj.status;
                item.count = faultListObj.count;
                fcaPriFCsReqJSON.faultList.items.add(item);
            }
        }catch(Exception ex){
            System.debug('in catch of prepareReqJSONForProitizedFCsServiceOfFCA of CSS_WS_FCA >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{
            
        }
        return fcaPriFCsReqJSON;
    }
    
    /*
    * This method is used for preparing request JSON for Fault Details webservice
    **/
    global static CSS_WPR_FCA_FaultDetailsReqJSON2Apex prepareReqJSONForFaultDetailsServiceOfFCA(CSS_WPR_TG_GetAssesDataReqJSON2Apex reqJSON){
        CSS_WPR_FCA_FaultDetailsReqJSON2Apex fcaFaultDetailsReqJSON = null;
        List<String> fcsList = null;
        try{
            fcaFaultDetailsReqJSON = new CSS_WPR_FCA_FaultDetailsReqJSON2Apex();
            fcaFaultDetailsReqJSON.faultList = new List<String>();
            fcaFaultDetailsReqJSON.serviceModelName = reqJSON.DataArea.SERVICEMODELNAME;
            for(CSS_WPR_TG_GetAssesDataReqJSON2Apex.FAULTLIST faultObj :reqJSON.DataArea.faultList){
                fcaFaultDetailsReqJSON.faultList.add(faultObj.fc);
            }
        }catch(Exception ex){
            System.debug('in catch of prepareReqJSONForFaultDetailsServiceOfFCA of CSS_WS_FCA >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }finally{
            fcsList=null;
        }
        return fcaFaultDetailsReqJSON;
    }
    
    
    /*
    * This method is used for executing FCA service for Prioritized/Unprioritized Fault Codes
    **/
    global static HttpResponse executeProitizedFCsServiceOfFCA(String jSONReqBody, String endPointURL, String source){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into executeProitizedFCsServiceOfFCA webservice $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        //endPointURL = 'https://connectedsolutions-stg.cummins.com/fca/getFaultPrioritization/';
        //jSONReqBody = '{"version":1,"toolId":"toolId1234","token":"uPe4AzYnaWAPEXUbUMyLa%aSUhuBadaS","esn":"79470191","currentRunTime":1441238400,"faultList":{"items":[{"fc":"3682","occurenceTime":1441238400,"status":"active","count":2},{"fc":"39324","occurenceTime":1441238400,"status":"active","count":2},{"fc":"441","occurenceTime":1441238600,"status":"active","count":4},{"fc":"3932","occurenceTime":1441238600,"status":"active","count":4},{"fc":"596","occurenceTime":1541238600,"status":"inactive","count":1}]}}';
        HttpRequest httpReq = null;
        HttpResponse httpRes = null;
        try{
            System.debug('endPointURL>>>>>>>>>>>>>>>>>>>>>>>>>:'+endPointURL+' jSONReqBody>>>>>>>>>>>>>>>>>>>>>>>>>:'+jSONReqBody);
            //Token not needed here since it is in request parameters
            httpReq = new HttpRequest();
            httpReq.setHeader('Content-Type','application/json');
            httpReq.setMethod('POST');
            httpReq.setTimeout(120000);
            httpReq.setEndpoint(endPointURL);
            httpReq.setBody(jSONReqBody);
            httpRes = new Http().send(httpReq);
            system.debug('RESPONSE_BODY>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+httpRes.getbody()+' httpRes getStatusCode is :: '+httpRes.getStatusCode()+' RESPONSE_BODY>>>>>>>>>>>>>>>>>>>>>>:'+httpRes.toString());
        }catch(Exception ex){
            css_utility.LogOutIntError('REST Webservice Request', ex.getMessage()+':'+ex.getLineNumber(), 'FCA01-Exception occured while calling FCA FCs webservice', source);
            System.debug('in catch of executeProitizedFCsServiceOfFCA of CSS_WS_FCA >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        } finally {
        	httpReq=null;
        }
        return httpRes;
    }
    
    /*
    * This method is used for executing FCA service for Prioritized/Unprioritized Fault Codes
    **/
    global static HttpResponse executeRESTWebservice(String jSONReqBody, String endPointURL, String token, String methodType, String contentType, String source){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into executeRESTWebservice webservice $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        HttpRequest httpReq = null;
        HttpResponse httpRes = null;
        try{
            System.debug('endPointURL>>>>>>>>>>>>>>>>>>>>>>>>>:'+endPointURL+' jSONReqBody>>>>>>>>>>>>>>>>>>>>>>>>>:'+jSONReqBody);
            //Token not needed here since it is in request parameters or somewhere
            httpReq = new HttpRequest();
            httpReq.setHeader('Authorization', token);
            httpReq.setHeader('Content-Type', contentType);
            httpReq.setMethod(methodType);
            httpReq.setTimeout(120000);
            httpReq.setEndpoint(endPointURL);
            httpReq.setBody(jSONReqBody);
            httpRes = new Http().send(httpReq);
            system.debug('RESPONSE_BODY>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+httpRes.getbody()+' httpRes getStatusCode is :: '+httpRes.getStatusCode()+' httpRes.toString>>>>>>>>>>>>>>>>>>>>>>:'+httpRes.toString());
        }catch(Exception ex){
            css_utility.LogOutIntError('REST Webservice Request', ex.getMessage()+':'+ex.getLineNumber(), 'FCA02-Exception occured while calling webservice', source);
            System.debug('in catch of executeRESTWebservice of CSS_WS_FCA >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        } finally {
        	httpReq=null;
        }
        return httpRes;
    }
    
}