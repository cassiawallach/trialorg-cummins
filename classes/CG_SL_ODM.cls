public class CG_SL_ODM {
    
    /*************************Call ODM Header Service******************************************/
    
    public static CG_OP_OAGWrapper callODMHeaderService(CG_ODM_ReqJSONParser reqJson){

        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        try{ 

            reqWrapper = new CG_IP_OAGWrapper();
            system.debug('reqJson**'+reqJson);

            reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');
			 //This is the service name to pull the data from Custom Setting-CSS_Integration_Details__c
            //CSS_Integration_Details__c contains the endpoint and authentication details
            //Below code added as part of Mule Integration
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CG_ODMHeaderValidation');
            String endPoint = conDetails.End_Point__c;
            reqWrapper.serviceName = 'CG_ODMHeaderValidation';
            //reqWrapper.methodType = 'POST';Commented as part of Mule Integration
            reqWrapper.methodType = conDetails.Method_Type__c;//Added as part of Mule Integration
            reqWrapper.endPoint = endPoint;
            if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            system.debug('Anirudh reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            if(reqJson != null){
                //returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);Commented by Arpita as part of Mule Integration
                returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            }
            return returnWrapper;
        }catch(exception e){
            system.debug('Entered into catch block of callODMWebservice method in CG_SL_ODM class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;

        }
    }
    
    /*************************Call ODM Parts Service******************************************/
    
    public static CG_OP_OAGWrapper callODMPartsService(CG_ODM_ReqJSONParser reqJson){

        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        try{ 

            reqWrapper = new CG_IP_OAGWrapper();

            reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');


            //This is the service name to pull the data from Custom Setting-CSS_Integration_Details__c
            //CSS_Integration_Details__c contains the endpoint and authentication details
            //Below code added as part of Mule Integration
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CG_ODMPartsService');
            String endPoint = conDetails.End_Point__c;
            reqWrapper.serviceName = 'CG_ODMPartsService';
            //reqWrapper.methodType = 'POST';Commented as part of Mule Integration
            reqWrapper.methodType = conDetails.Method_Type__c;//Added as part of Mule Integration
            reqWrapper.endPoint = endPoint;

            system.debug('Anirudh reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            if(reqJson != null){
                //returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);Commented by Arpita as part of Mule Integration
                returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            }
            return returnWrapper;
        }catch(exception e){
            system.debug('Entered into catch block of ODMPartsWebservice method in CG_SL_ODM class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;

        }
    }
    
    /*************************Call ODM Failure Service******************************************/
    
    public static CG_OP_OAGWrapper callODMFailureService(CG_ODM_ReqJSONParser reqJson){

        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        try{ 

            reqWrapper = new CG_IP_OAGWrapper();

            reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');


            //This is the service name to pull the data from Custom Setting-CSS_Integration_Details__c
            //CSS_Integration_Details__c contains the endpoint and authentication details
            //Below code added as part of Mule Integration
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CG_FailureValidation');
            String endPoint = conDetails.End_Point__c;
            reqWrapper.serviceName = 'CG_FailureValidation';
            //reqWrapper.methodType = 'POST';Commented as part of Mule Integration
            reqWrapper.methodType = conDetails.Method_Type__c;//Added as part of Mule Integration
            reqWrapper.endPoint = endPoint;

            system.debug('Anirudh Failure reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            if(reqJson != null){
                //returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);Commented by Arpita as part of Mule Integration
                returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            }
            return returnWrapper;
        }catch(exception e){
            system.debug('Entered into catch block of ODMFailureWebservice method in CG_SL_ODM class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;

        }
    }
    
    
    /*************************Call ODM Travel Service******************************************/
    
    public static CG_OP_OAGWrapper callODMTravelService(CG_ODM_ReqJSONParser reqJson){

        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        try{ 

            reqWrapper = new CG_IP_OAGWrapper();

            reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');


            //This is the service name to pull the data from Custom Setting-CSS_Integration_Details__c
            //CSS_Integration_Details__c contains the endpoint and authentication details
            //Below code added as part of Mule Integration
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CG_ODMTravelService');
            String endPoint = conDetails.End_Point__c;
            reqWrapper.serviceName = 'CG_ODMTravelService';
            //reqWrapper.methodType = 'POST';Commented as part of Mule Integration
            reqWrapper.methodType = conDetails.Method_Type__c;//Added as part of Mule Integration
            reqWrapper.endPoint = endPoint;

            system.debug('Anirudh Travel reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            if(reqJson != null){
                //returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper); Commented by Arpita as part of Mule Integration
                returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            }

            return returnWrapper;
        }catch(exception e){
            system.debug('Entered into catch block of ODMTravelWebservice method in CG_SL_ODM class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;

        }
    }
    
    
    /*************************Call ODM OtherClaimable Service******************************************/
    
    public static CG_OP_OAGWrapper callODMOtherClaimableService(CG_ODM_ReqJSONParser reqJson){

        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        try{ 

            reqWrapper = new CG_IP_OAGWrapper();

            reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');


            //This is the service name to pull the data from Custom Setting-CSS_Integration_Details__c
            //CSS_Integration_Details__c contains the endpoint and authentication details
            //Below code added as part of Mule Integration
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CG_OtherClaimablesValidation');
            String endPoint = conDetails.End_Point__c;
            reqWrapper.serviceName = 'CG_OtherClaimablesValidation';
            //reqWrapper.methodType = 'POST';Commented as part of Mule Integration
            reqWrapper.methodType = conDetails.Method_Type__c;//Added as part of Mule Integration
            reqWrapper.endPoint = endPoint;

            system.debug('Anirudh OtherClaimable reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            if(reqJson != null){
                //returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);Commented by Arpita as part of Mule Integration
                returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            }
            return returnWrapper;
        }catch(exception e){
            system.debug('Entered into catch block of ODMOtherClaimableWebservice method in CG_SL_ODM class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;

        }
    }
    

    /*********************** CALL ODM PRESUBMIT SERVICE **************************************/
    
    public static CG_OP_OAGWrapper callODMPreSubmitService(CG_ODM_PreSubmit_ReqJSONParser  preSubmitReqJSON){

        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        
        try { 
            reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.jsonReqBody = JSON.serialize(preSubmitReqJSON).replace('null','""');

            //This is the service name to pull the data from Custom Setting-CSS_Integration_Details__c
            //CSS_Integration_Details__c contains the endpoint and authentication details
            //Below code added as part of Mule Integration
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('ODMPreSubmitValidation');
            String endPoint = conDetails.End_Point__c;
            reqWrapper.serviceName = 'ODMPreSubmitValidation';//UPDATE
            //reqWrapper.methodType = 'POST';Commented as part of Mule Integration
            reqWrapper.methodType = conDetails.Method_Type__c;//Added as part of Mule Integration
            reqWrapper.endPoint = endPoint;

            system.debug('Pre Submit reqJson>>>>>>>>>>>'+preSubmitReqJSON);
            if(Test.isRunningTest() && preSubmitReqJSON == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            if(preSubmitReqJSON != null){
                //returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);Commented by Arpita as part of Mule Integration
                returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            }
            return returnWrapper;
        }catch(exception e){
            system.debug('Entered into catch block of callODMPreSubmitService method in ' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;
        }
    }
    
     /*********************** CALL ODM SRT SERVICE **************************************/
     
    public static CG_OP_OAGWrapper callODMSRTService(CG_ODM_ReqJSONParser reqJson){
        CG_IP_OAGWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper;
        try{ 
            reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.jsonReqBody = JSON.serialize(reqJson).replace('null','""');
system.debug('reqJson>>>>>>>>>>>'+reqWrapper.jsonReqBody);
            //This is the service name to pull the data from Custom Setting-CSS_Integration_Details__c
            //CSS_Integration_Details__c contains the endpoint and authentication details
            //Below code added as part of Mule Integration
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CG_ODMSRTService');
            String endPoint = conDetails.End_Point__c;
            reqWrapper.serviceName = 'CG_ODMSRTService';
            //reqWrapper.methodType = 'POST';Commented as part of Mule Integration
            reqWrapper.methodType = conDetails.Method_Type__c;//Added as part of Mule Integration
            reqWrapper.endPoint = endPoint;
             if(Test.isRunningTest() && reqJson == null)
			{
				throw new CSS_MyException('Exception to cover Catch block'); 
			}
            //Call CG_WS_OAG class to call the calloutGeneric() method which will fire the callout
            if(reqJson != null){
                //returnWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);Commented by Arpita as part of Mule Integration
                returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            }
                return returnWrapper;
        }catch(exception e){
            system.debug('Entered into catch block of TSRWebservice method in CG_SL_TSR class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;

        }
    }
    
    
}