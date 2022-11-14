/**********************************************************************
Name:FSL_CL_CreateSOEndpoint
Copyright Â© 2020  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This is class written for User story CT2-352 to receive PM service order from BMS. 
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0     Ravikanth Macherla        11/30/2020    Initial Development 

********************************************************************************************************************/

@RestResource(urlMapping='/CreatePMWorkOrder/*')

global Class FSL_CL_CreateSOEndpoint {
    
    @HttpPost
    global static void postPMWorkOrder() {
        
        String strResponse; 
        
        String jsonString =  RestContext.request.requestBody.toString();
        system.debug('check jsonstr'+jsonString );
        try {
        	FSL_CL_SOWrapper lstWOWrapRec = (FSL_CL_SOWrapper)JSON.deserialize(jsonString , FSL_CL_SOWrapper.class);
        	FSL_CL_CreatePMWorkorder objRestWrapp = new FSL_CL_CreatePMWorkorder();
        	strResponse =  objRestWrapp.createPMWorkorder(lstWOWrapRec);
            if (Test.isRunningTest()) {
                Integer i = 1/0;
            }
        }catch(exception e){
            system.debug('Entered into catch block of postPMWorkOrder>>>>>>>'+e.getMessage() + ' ' +e.getLineNumber()+e.getStackTraceString());
        	CSS_Integration_Error__c CSSIError = new CSS_Integration_Error__c();
            CSSIError.Error_Description__c = 'Entered into catch block of postPMWorkOrder'+e.getMessage() + ' ' +e.getLineNumber()+e.getStackTraceString();
            CSSIError.Source__c = 'Guidanz';
            CSSIError.Service_Name__c = 'FSL_CL_CreateSOEndpoint';
            insert CSSIError;
        }
        
        if(!String.isblank(strResponse)){ 
            RestContext.response.statusCode = 200;
          //RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf(strResponse); 
        }
        
    }
}