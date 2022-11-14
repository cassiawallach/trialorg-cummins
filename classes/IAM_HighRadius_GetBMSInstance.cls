/*Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_HighRadius_GetBMSInstance class. 
BMS Instance for HighRadius.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Nishant Verma          10/10/2020       INITIAL DEVELOPMENT       
*****************************************************/
/********************************************************************************
***********************************************************************************/
public class IAM_HighRadius_GetBMSInstance {
    
    public static IAM_HighRadius_Parser.BMSresponseToSF getBMSInstance(String customerNumber, String InvoiceNumber) {                                            
        HTTPResponse res;
		IAM_HighRadius_Parser.BMSresponseToSF objBMStoSF = new IAM_HighRadius_Parser.BMSresponseToSF();
        IAM_HighRadius_Parser.Response_BMSInstance obj = new IAM_HighRadius_Parser.Response_BMSInstance();
        try {
            String accessToken;
            //String body;
            if(Test.isRunningTest()) {
                //accessToken = 'lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz';
            } else {
                accessToken = IAM_HighRadius_GetAuthToken.getAccessToken('IAM_HighRadius_Auth');
            }
            /* Get update user service (Integration) details */
            system.debug('accessToken'+accessToken);
            CSS_Integration_Details__c serviceDetails = new CSS_Integration_Details__c();
            serviceDetails = IAM_HighRadius_ConnectionDetails.getConnection('IAM_HighRadius_BMSInstance');
            System.debug('#### connection details '+serviceDetails);
            string endpoint; 
            endpoint= serviceDetails.End_Point__c+'invoice='+InvoiceNumber+'&customerCode='+customerNumber;
            System.debug('#### endpoint'+endpoint);
            HttpRequest req = new httpRequest();
            req.SetMethod('GET'); 
            req.setEndpoint(endpoint);
            req.setHeader('client-id', serviceDetails.Passcode__c);
            req.setHeader('client-secret', serviceDetails.Key__c);
            req.setHeader('Authorization','Bearer '+accessToken); 
            req.setTimeout(12000);
            System.debug('#### httpRequest '+req.toString());
            /* Send Request */
            res = new HTTP().send(req);
            System.debug('### response body - '+res.getBody());            
            String responseBody= res.getBody(); 
            obj = IAM_HighRadius_Parser.getResponse_BMSInstance(responseBody);            
            System.debug('### Response obj - '+obj);
            if(obj.Status == 'SUCCESS') {
                System.debug('### Response obj msg - '+obj.Message);
                objBMStoSF.BMSinstance=obj.instance;
				objBMStoSF.erpCustomerCode=obj.erpCustomerCode;
            } else {
                System.debug('### Response obj msg - '+obj.Message);
                IAM_ErrorHandling.IAMerrorCapture(
                    res.getbody(), 'IAM_HighRadius_GetBMSInstance getBMSInstance method', obj.Message);
                	objBMStoSF.BmsInstance='Error';
            }
        } catch(Exception e) {
            System.debug('#### Exception '+ e.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(
                'IAM_HighRadius Error', 'IAM_HighRadius_GetBMSInstance getBMSInstance method', e.getMessage());
            	objBMStoSF.BmsInstance='Error';
        } 
        system.debug('objBMStoSF@@@'+objBMStoSF);
       return objBMStoSF;
    }
	
    
}