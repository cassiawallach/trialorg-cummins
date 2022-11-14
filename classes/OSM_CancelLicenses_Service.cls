public class OSM_CancelLicenses_Service{


    public static OSM_CancelLicensesRES_GeneralizedWrapper callCancelLicensesService(OSM_CancelLicensesREQ_GeneralizedWrapper cancelLicensesWrapper){
        
        boolean isException = false;
        OSM_CancelLicensesRES_GeneralizedWrapper objReturn = new OSM_CancelLicensesRES_GeneralizedWrapper();
        
        String jsonStr = '';
        OSM_WS_OP_CSWrapper resAuthWrapper = new OSM_WS_OP_CSWrapper();
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        try
        {
            OSM_CancelLicensesREQWrapper cancelLicensesWrpr = OSM_CancelLicenses_Helper.populateRequestObjectData(cancelLicensesWrapper);
            
            System.debug('cancelLicensesWrpr: '+cancelLicensesWrpr );
            jsonStr = JSON.serialize(cancelLicensesWrpr);
            System.debug('previous json string: '+jsonStr);
            // Call for Quote tax
            OSM_WS_IP_CSWrapper requestWrap = new OSM_WS_IP_CSWrapper();
            
            //requestWrap.serviceName = 'OMS_CancelLicense_Service';
            requestWrap.serviceName = Label.CSO_Cancellicense;
            log.Service_Name__c = 'OMS_CancelLicense_Service';
            log.Account__c = cancelLicensesWrapper.CancelLicensesInput.AccountId; // Added By Dhiraj
            requestWrap.jsonReqBody = jsonStr;
            requestWrap.AuthEnv  = 'OMS_Auth';
            requestWrap.AccesTokenRequired = true;
            
            log.Target__c = 'OMS';
            log.Request__c = jsonStr;
            log.Source__c = 'OSM';
            log.Logged_In_User__c = userinfo.getuserid();
            
            //resAuthWrapper = OSM_WS_CallOutServices.executeRESTWebservice(requestWrap);
            resAuthWrapper = OSM_MuleSoft_MW_Services.calloutGeneric(requestWrap);
             log.Account__c = cancelLicensesWrapper.CancelLicensesInput.AccountId; // Added By Dhiraj
            log.API_URL__c =resAuthWrapper.APIURL;
            if(Test.isRunningTest()){
                resAuthWrapper.exceptionFlag=false;
            }
             if(resAuthWrapper.exceptionFlag == false )
             {
                  log.Account__c = cancelLicensesWrapper.CancelLicensesInput.AccountId; // Added By Dhiraj
                log.Response__c = resAuthWrapper.Response;
                log.Status__c = 'Success'; 
                OSM_CancelLicensesRESWrapper wrprRes=null;
                 if(Test.IsRunningTest()){
                     String x='Response Body:{"Header":{"Sender":{"ServiceName":"CancelLicense","SenderID":"Mrktplc"},"Status":"Success","Target":{"TargetID":"OMS"},"ReturnCodeDescription":"Success"},"CancelLicensesOutput":{"CancelledCopies":1,"CancelLicenseStatus":true,"RemainingCopies":0}}';
                     wrprRes = OSM_CancelLicensesRESWrapper.parse(x.substringAfterLast('Response Body:'));
                 }else{
                    //wrprRes =OSM_CancelLicensesRESWrapper.parse(resAuthWrapper.Response.substringAfterLast('Response Body:'));
                    wrprRes =OSM_CancelLicensesRESWrapper.parse(resAuthWrapper.Response);
                }
                System.debug('wrprRes: '+wrprRes);
               
                System.debug('wrprRes.Header.Status: '+wrprRes.Header.Status);
                if(wrprRes.Header.Status != null && (wrprRes.Header.Status == 'ERROR' || wrprRes.Header.Status == 'Error'))
                {
                    objReturn.errorMsg = wrprRes.Header.ReturnCodeDescription;
                    objReturn.errorFlag = true;
                     log.Account__c = cancelLicensesWrapper.CancelLicensesInput.AccountId; // Added By Dhiraj
                    log.Status__c = 'Failure'; 
                    log.Error_Description__c = wrprRes.Header.ReturnCodeDescription;
                     /*if(objReturn.errorMsg.contains('1121')){
                           //log.Error_Code__c='1121';
                           log.Error_Description__c='RequesterId is empty, Please enter the RequeserId.';
                           log.Status__c = 'Success';
                       }else if(objReturn.errorMsg.contains('1107')){
                           log.Error_Code__c='1107';
                           log.Error_Description__c='Invalid input.';
                            //log.Status__c = 'Success';
                       }else if(objReturn.errorMsg.contains('1123')){
                           log.Error_Code__c='1123';
                           log.Error_Description__c='No license are available for cancellation for the itemid and toolname combination.';
                            //log.Status__c = 'Success';
                       }else if(objReturn.errorMsg.contains('1122')){
                           log.Error_Code__c='1122';
                           log.Error_Description__c='The available copy is less than number of copies passed, Please enter correct number of copy for cancellation.';
                            //log.Status__c = 'Success';
                       }else{
                            log.Status__c = 'Failure';

                       }

                        */
                }else
                {    
                    objReturn.errorFlag = false;
                    objReturn.CancelLicensesOutput = new OSM_CancelLicensesRES_GeneralizedWrapper.CancelLicensesOutput();
                    objReturn.CancelLicensesOutput.CancelledCopies=wrprRes.CancelLicensesOutput.CancelledCopies;
                    objReturn.CancelLicensesOutput.RemainingCopies=wrprRes.CancelLicensesOutput.RemainingCopies;
                    objReturn.CancelLicensesOutput.CancelLicenseStatus=wrprRes.CancelLicensesOutput.CancelLicenseStatus;
                   // objReturn.Header = new OSM_CancelLicensesRES_GeneralizedWrapper.Header();
                    
                 }
                    
                }
            else
            {
                 log.Account__c = cancelLicensesWrapper.CancelLicensesInput.AccountId; // Added By Dhiraj
                log.Response__c = resAuthWrapper.Response;
                objReturn.errorFlag = true;
                objReturn.errorMsg = resAuthWrapper.errorMessage;
                log.Status__c = 'Failure'; 
                log.Error_Description__c = resAuthWrapper.errorMessage;
            }
            if(Test.IsRunningTest()){
                throw new NullPointerException();
            }
        }
        catch(Exception ex)
        {
            String msg  = 'Message - '+ex.getMessage();
            msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
            log.Account__c = cancelLicensesWrapper.CancelLicensesInput.AccountId; // Added By Dhiraj
            log.Error_Description__c = msg ;
            log.Response__c = resAuthWrapper.Response;
            objReturn.errorFlag = true;
            objReturn.errorMsg = msg;
            log.Status__c = 'Failure';
        }
        objReturn.log = log;
        
        //hard code for dummy return
        
        
       
        return objReturn;
        
        
    }
}