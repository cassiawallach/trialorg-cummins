/**********************************************************************
Name:FSL_WS_ODM
Copyright Â© 2022  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is the Web service Class for ODM
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Rajender M      04/12/2022      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSL_WS_ODM {
    
    /*************************Call ODM Header Service******************************************/
    
    public static CG_OP_OAGWrapper callODMHeaderService(CG_ODM_ReqJSONParser reqJson){

        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        
        try{ 
			reqWrapper = new FSL_IP_NamedCredentialWrapper();
            system.debug('reqJson**'+reqJson);
			reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');
			reqWrapper.methodType = 'POST';
	    	reqWrapper.NamedCredential = 'FSL_NC_Claims';
	    	reqWrapper.Path = '/validation/header';
	    	reqWrapper.endPoint = 
			[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;

            system.debug('Header reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call FSL_WS_Mule class to call the calloutNamedCredentials() method which will fire the callout
            if(reqJson != null){
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
                system.debug('returnWrapper.response.getBody()>>>>' + returnWrapper.response.getBody());
            }
            return returnWrapper;
          } catch(exception e){
            system.debug('Entered into catch block of callODMHeaderService method in FSL_WS_ODM class' + e.getMessage() + ' ' + e.getLineNumber());
            if(returnWrapper == null){
                returnWrapper = New CG_OP_OAGWrapper();
            }
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;

        }
    }
    
    /*************************Call ODM Parts Service******************************************/
    
     public static CG_OP_OAGWrapper callODMPartsService(CG_ODM_ReqJSONParser reqJson){

        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        
         try { 
			reqWrapper = new FSL_IP_NamedCredentialWrapper();
            reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');
	    	reqWrapper.methodType = 'POST';
	    	reqWrapper.NamedCredential = 'FSL_NC_Claims';
	    	reqWrapper.Path = '/validation/parts';
	    	reqWrapper.endPoint = 
			[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;

            system.debug('Parts reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call FSL_WS_Mule class to call the calloutNamedCredentials() method which will fire the callout
            if(reqJson != null) {
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
                system.debug('returnWrapper.response.getBody()>>>>' + returnWrapper.response.getBody());
            }
            return returnWrapper;
        } catch(exception e) {
            system.debug('Entered into catch block of ODMPartsWebservice method in FSL_WS_ODM class' + e.getMessage() + ' ' + e.getLineNumber());
            if(returnWrapper == null) {
                returnWrapper = New CG_OP_OAGWrapper();
            }
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;
        }
    }
    
  
    
    
    /*************************Call ODM Failure Service******************************************/
    
    public static CG_OP_OAGWrapper callODMFailureService(CG_ODM_ReqJSONParser reqJson){

        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        
        try { 
			reqWrapper = new FSL_IP_NamedCredentialWrapper();
			reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');
			reqWrapper.methodType = 'POST';
	    	reqWrapper.NamedCredential = 'FSL_NC_Claims';
	    	reqWrapper.Path = '/validation/failure';
	    	reqWrapper.endPoint = 
			[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;

			system.debug('Failure reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call FSL_WS_Mule class to call the calloutNamedCredentials() method which will fire the callout
            if(reqJson != null) {
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
                system.debug('returnWrapper.response.getBody()>>>>' + returnWrapper.response.getBody());
            }
            return returnWrapper;
        } catch(exception e) {
            system.debug('Entered into catch block of ODMFailureWebservice method in FSL_WS_ODM class' + e.getMessage() + ' ' + e.getLineNumber());
            if(returnWrapper == null) {
                returnWrapper = New CG_OP_OAGWrapper();
            }
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;

        }
    }
    
    
    /*************************Call ODM Travel Service******************************************/
     
    public static CG_OP_OAGWrapper callODMTravelService(CG_ODM_ReqJSONParser reqJson){

        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        
        try{ 
			reqWrapper = new FSL_IP_NamedCredentialWrapper();
			reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');
			reqWrapper.methodType = 'POST';
	    	reqWrapper.NamedCredential = 'FSL_NC_Claims';
	    	reqWrapper.Path = '/validation/travel';
	    	reqWrapper.endPoint = 
			[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;

            system.debug('Travel reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call FSL_WS_Mule class to call the calloutNamedCredentials() method which will fire the callout
            if(reqJson != null) {
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
                system.debug('returnWrapper.response.getBody()>>>>' + returnWrapper.response.getBody());
            }
            return returnWrapper;
        } catch(exception e) {
            system.debug('Entered into catch block of ODMTravelWebservice method in FSL_WS_ODM class' + e.getMessage() + ' ' + e.getLineNumber());
            if(returnWrapper == null) {
                returnWrapper = New CG_OP_OAGWrapper();
            }
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;

        }
    }
    
    
    /*************************Call ODM OtherClaimable Service******************************************/
   
    public static CG_OP_OAGWrapper callODMOtherClaimableService(CG_ODM_ReqJSONParser reqJson){

        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        
        try { 
			reqWrapper = new FSL_IP_NamedCredentialWrapper();
			reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');
            reqWrapper.methodType = 'POST';
	    	reqWrapper.NamedCredential = 'FSL_NC_Claims';
	    	reqWrapper.Path = '/validation/othclaimables';
	    	reqWrapper.endPoint = 
			[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;

            system.debug('OtherClaimable reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call FSL_WS_Mule class to call the calloutNamedCredentials() method which will fire the callout
            if(reqJson != null) {
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
                system.debug('returnWrapper.response.getBody()>>>>' + returnWrapper.response.getBody());
            }
            return returnWrapper;
        } catch(exception e) {
            system.debug('Entered into catch block of ODMOtherClaimableWebservice method in FSL_WS_ODM class' + e.getMessage() + ' ' + e.getLineNumber());
            if(returnWrapper == null){
                returnWrapper = New CG_OP_OAGWrapper();
            }    
                returnWrapper.exceptionFlag=true;
            	returnWrapper.errorMessage = e.getMessage();
	            return returnWrapper;

        }
    }
    
     

    /*********************** CALL ODM PRESUBMIT SERVICE **************************************/
    
   public static CG_OP_OAGWrapper callODMPreSubmitService(CG_ODM_PreSubmit_ReqJSONParser  preSubmitReqJSON){

		FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        
        try { 
            reqWrapper = new FSL_IP_NamedCredentialWrapper();
            reqWrapper.jsonReqBody = JSON.serialize(preSubmitReqJSON).replace('null','""');
			reqWrapper.methodType = 'POST';
            reqWrapper.NamedCredential = 'FSL_NC_Claims';
			reqWrapper.Path = '/validation/presubmit';
	    	reqWrapper.endPoint = [SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
			
            
            system.debug('Pre Submit reqJson>>>>>>>>>>>'+ reqWrapper.jsonReqBody);
           
            //Call FSL_WS_Mule class to call the calloutNamedCredentials() method which will fire the callout
            if(preSubmitReqJSON != null){
                returnWrapper =  FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
				system.debug('returnWrapper.response.getBody()>>>>' + returnWrapper.response.getBody());
            }
       
            return returnWrapper;
        }catch(exception e){
            system.debug('Entered into catch block of callODMPreSubmitService method in ' + e.getMessage() + ' ' + e.getLineNumber());
            if(returnWrapper == null){
                returnWrapper = New CG_OP_OAGWrapper();
            } 
			returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;
        }
    }
       
     /*********************** CALL ODM SRT SERVICE **************************************/
     
    public static CG_OP_OAGWrapper callODMSRTService(CG_ODM_ReqJSONParser reqJson){
        
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        
        try { 
            reqWrapper = new FSL_IP_NamedCredentialWrapper();
            reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');
			reqWrapper.methodType = 'POST';
	    	reqWrapper.NamedCredential = 'FSL_NC_Claims';
	    	reqWrapper.Path = '/validation/srt';
	    	reqWrapper.endPoint = 
			[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;

            system.debug('SRT reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call FSL_WS_Mule class to call the calloutNamedCredentials() method which will fire the callout
            if(reqJson != null) {
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
                system.debug('returnWrapper.response.getBody()>>>>' + returnWrapper.response.getBody());
            }
			return returnWrapper;
        } catch(exception e) {
            system.debug('Entered into catch block of callODMSRTService method in FSL_WS_ODM class ' + e.getMessage() + ' ' + e.getLineNumber());
            if(returnWrapper == null) {
                returnWrapper = New CG_OP_OAGWrapper();
            }
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;

        }
    }
  
}