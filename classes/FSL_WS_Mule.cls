/**********************************************************************
Name:FSL_WS_Mule
Copyright Â© 2022  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is the Web service Class for Mule Services using Named Credentials
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Rama Patchigolla    05/04/2022      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSL_WS_Mule {

public static CG_OP_OAGWrapper calloutNamedCredentials(FSL_IP_NamedCredentialWrapper reqWrapper) {
        system.debug('In calloutNamedCredentials method');
    	String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
    
    	//Setting default Authorization
    	reqWrapper.Authinfo = reqWrapper.Authinfo != null? reqWrapper.Authinfo:'FSL_Authdetails';
    	system.debug('AuthInfo>>>' +reqWrapper.Authinfo);
    	
    	CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();	
        try {    
				//Metadata which stores Authorization Client Id and Client Secret for Webservice
    			FSL_Authentication_Details__mdt authDetails = FSL_Authentication_Details__mdt.getInstance(reqWrapper.Authinfo);
	    		String Username = authDetails != null? authDetails.Username__c: '';
        		String Passcode = authDetails != null? authDetails.Password__c: '';
        
    			//Getting endpoint for a specific webservice
    			reqWrapper.endPoint = [SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;        
    	    	
            	system.debug('NamedCredential>>>>:'+reqWrapper.NamedCredential);
            	system.debug('EndPoint Url>>>>:'+reqWrapper.endPoint);
            
                HttpRequest req = new HttpRequest();
	            req.setEndpoint('callout:'+reqWrapper.NamedCredential+reqWrapper.Path);
	            req.setHeader('client-id', Username); //Header param stores Client Id for MW //271bf3f9be404e4b9a3a85559a2cecb3
	            req.setHeader('client-secret', Passcode); //new header param stores Client Secret for MW//74A587c3C7Ff45A38B87A6C49ec29299
                req.setHeader('Content-Type', 'application/json');
            
            	//Setting default method as POST
            	if(reqWrapper.methodType == null)
                    reqWrapper.methodType = 'POST';
                
            	req.setMethod(reqWrapper.methodType);   
           		req.setTimeout(120000);
            
                //Below code added by case management development team for Update Service now Incident details-- Start Here--//
                if(reqWrapper.methodType == 'POST' || reqWrapper.methodType == 'PUT' ){
                    req.setBody(reqWrapper.jsonReqBody);
                }
                //--- End here------//
            
            system.debug('Request Wrapper>>>>:'+req);
            system.debug('client-id>>>>:'+Username);
            system.debug('client-secret>>>>'+Passcode);
            system.debug('JSON Request Body>>>>:'+req.getBody());
            
            Http http = new Http();
            startDt = System.now();
            HttpResponse httpRes = new HttpResponse();
			
		    httpres = http.send(req);
            System.debug('HttpRes>>>>:'+httpRes+'  HttpRes.getBody:'+httpRes.getBody());
            
            //Handling Success Status
    		if (httpRes.getStatusCode() == 200 || httpRes.getStatusCode() == 201 ) {//ADDED 201 by CSM Team
                System.debug('########### successfully executed ################');
                endDt = System.now();
                Long totalTime = endDt.getTime() - startDt.getTime();
                returnWrapper.totalServiceCallTime = totalTime;
                returnWrapper.request = req;           
                returnWrapper.response = httpRes;
                system.debug('InsideREsponse***'+returnWrapper.response);                
            }
        	else{//Handling Status other than 200/201
                system.debug('Recieved MW Error>>>>'+httpRes.getStatusCode());
                returnWrapper.response = httpRes;//Added this line by CSM Team
                returnWrapper.exceptionFlag = true;
                String body = httpRes.getBody();
                Integer statusCode = httpRes.getStatusCode();
                String msg = statusCode + '---' + body;

                returnWrapper.exceptionMessage = msg;
                returnWrapper.endPoint = reqWrapper.endPoint+reqWrapper.Path;
            }
            //Integartion errror logging for status other than 200/201
            if(returnWrapper!= null  && (returnWrapper.exceptionFlag == true) && !Test.isRunningTest()){ 
                FSL_ApplicationLogger.insertFSLIntegrationErrorLog(reqWrapper.jsonReqBody,String.valueOf(returnWrapper),reqWrapper.endpoint,'Error','Mule','toolId','CSS');
                System.debug('Logged error in FSL_ApplicationLogger'); 
            }
            return returnWrapper;

        }catch(Exception ex){
            //MANDATORY: In case of exception Set the exceptionFlag=true always
            System.debug('===Exception whie making callout getStackTraceString===:' + ex.getStackTraceString());
            system.debug('EXCEPTION of FSL_WS_MULE - calloutNamedCredentials Method ErrorMessage>>>>:'+ex.getMessage() + ' LineNumber>>:' + ex.getLineNumber() + ' Rootcause>>:' +ex.getCause());
            String stackTrace = ex.getStackTraceString();
            String msg = ex.getMessage();
            returnWrapper.exceptionMessage += msg;
            returnWrapper.exceptionMessage += stackTrace;
            returnWrapper.exceptionFlag = true;
            return returnWrapper;
        }
    }
    
}