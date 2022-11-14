/**********************************************************************
Name:CSS_receiveBMSDelectionData
Copyright © 2011  Cummins
=======================================================================
=======================================================================
Purpose:  
BMS job Deletion #133130                                                        
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                 DETAIL                                 
1.0 - Karthik Gorantla      03/19/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/

@RestResource(urlMapping='/BMS/V01/CSS/BMSJobDeleteInGuidanz/*')

global with sharing class CSS_receiveBMSDelectionData {
    @HttpPut
    global static void updateJobOrderData(){
        string JSONResponseBody;
        string wsESN;
        string ServiceJobLocation;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        string jSONRequestBody ;
       // Map<String, String> mpParams = new Map<String, String>(req.params);
            jSONRequestBody = req.requestBody.toString().trim(); 
            try
            {
                CSS_JSON2APEXBMSJOBDELETION wo1 = (CSS_JSON2APEXBMSJOBDELETION)JSON.deserializeStrict(jSONRequestBody,CSS_JSON2APEXBMSJOBDELETION.class);
                System.debug('========> Response' +wo1);
                System.debug('========> Response CSSJobID' +wo1.DataArea.CSSJobId);
                //Fetch the Job Order from Salesforce based on the parameter passed on the URL
                list<CSS_Job_Order__c> lstJobOrder = [SELECT Id, Name, CSS_Job_Location_Code__c, Status__c, Unit_Number__c From CSS_Job_Order__c WHERE Name =: wo1.DataArea.CSSJobId];
               System.debug('=====> List Of Order'+lstJobOrder);
                ServiceJobLocation = lstJobOrder[0].CSS_Job_Location_Code__c;
                if(!lstJobOrder.isEmpty())
                {
                           System.debug('=====> ServiceJobLocation' +ServiceJobLocation);            
                    if(lstJobOrder[0].Status__c == 'Closed' || lstJobOrder[0].Status__c == 'Canceled'){
                        JSONResponseBody = '{ "Header": {"Status":"Internal Error", "ReturnCodeDescription":"CSS JOB Status Closed OR Cancelled","Location": {"LocationID":'+ServiceJobLocation+'}}}';
                        //insIntegrationError(JSONResponseBody, 'Closed Job Order. Notify as per Business Functionality.', jSONRequestBody);
                    }
                    else
                    {
                         
                        if(wo1.DataArea.Action =='DELETE'){
                            lstJobOrder[0].Status__c ='Canceled';
                            JSONResponseBody = '{ "Header": {"Status":"SUCCESS", "ReturnCodeDescription":"Job Cancelled Successfully","Location": {"LocationID":'+ServiceJobLocation+'}}}';
                          System.debug('===>JSONResponseBody 36' +JSONResponseBody);
                        }
                        update lstJobOrder;
                        System.debug('===>JSONResponseBody39' +JSONResponseBody);
                    }
                }
            }
                catch(Exception e)
                {
                   /*  System.debug('===>JSONResponseBody 45' +JSONResponseBody);
                    if(e.getTypeName() == 'System.JSONException'){
                        JSONResponseBody = '{ "Header": {"Status":"Internal Error", "ReturnCodeDescription":"Invalid JSON Schema"'+e+',"Location": {"LocationID": '+ServiceJobLocation+'}}}';
                       // insIntegrationError(JSONResponseBody, 'Invalid JSON. Notify INSITE.',jSONRequestBody);
                    }
                    else if(e.getTypeName() == 'System.TypeException'){
                        JSONResponseBody = '{ "Header": {"Status":"Internal Error", "ReturnCodeDescription":"Invalid JSON Schema"'+e+',"Location": {"LocationID": '+ServiceJobLocation+'}}}';
                        //insIntegrationError(JSONResponseBody, 'DataType Mismatch. Notify INSITE.',jSONRequestBody);
                    }
                    
                    else
                    {*/
                        JSONResponseBody = '{ "Header": {"Status":"Internal Error", "ReturnCodeDescription":"Internal Error Occurred","Location": {"LocationID":'+ServiceJobLocation+'}}}';
                     System.debug('===>karthik   63' +e.getmessage());
                    
                        // insIntegrationError(JSONResponseBody, 'CSS Error:' + e.getMessage(),jSONRequestBody);
                   // }
                    
                }
               System.debug('===>JSONResponseBody 63' +JSONResponseBody);
                res.responseBody = Blob.valueOf(JSONResponseBody);
            }
        } 

   /* global static void insIntegrationError(string errDesc, string sysError, string reqMsg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Error_Description__c = sysError + ' *** External Message ** ' + errDesc;
        errObj.Source__c = 'BMS Delete';
        errObj.Processed_Data__c = reqMsg;
        insert errObj;
    }*/