/**********************************************************************
Name:CSS_BMSSendJobPlan
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Get SRT from BMS(Job Plan) #133132                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -    Vignesh S      04/02/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/

@RestResource(urlMapping='/BMS/V01/CSS/BMSSendJobPlanToGuidanz/*')

global with sharing class CSS_BMSSendJobPlan {
    @HttpPut
    global static void insertBMS_SRT_Data(){
        String JSONResponseBody;
        String wsESN;
        String ServiceJobLocation = '';
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<CSS_SRT__c> lstSRTinsert = new List<CSS_SRT__c>();
        res.addHeader('Content-Type', 'application/json');
        String jsonRequestBody ;
        jSONRequestBody = req.requestBody.toString().trim(); 
        try
        {
            system.debug('**jSONRequestBody**'+jSONRequestBody);
            CSS_BMSSendJobPlan_Req_Json sendJobPlanReq = (CSS_BMSSendJobPlan_Req_Json)JSON.deserializeStrict(jsonRequestBody, CSS_BMSSendJobPlan_Req_Json.class);
            System.debug('===> Request' + sendJobPlanReq);
            System.debug('===>Job Name: ' + sendJobPlanReq.DataArea.CSSjobID);
            //Fetch the Job Order from Salesforce based on the parameter passed on the URL
            CSS_Job_Order__c serJob = [SELECT Id, Name, CSS_Job_Location_Code__c, Status__c, Unit_Number__c From CSS_Job_Order__c WHERE Name =: sendJobPlanReq.DataArea.CSSjobID];
            System.debug('===> Service Job' + serJob);
            ServiceJobLocation = serJob.CSS_Job_Location_Code__c;
            if(serJob != null){
                System.debug('====> ServiceJobLocation' +ServiceJobLocation);

                for(CSS_BMSSendJobPlan_Req_Json.SRTDetail dArea : sendJobPlanReq.DataArea.SRTDetails){
                    CSS_SRT__c srtRec = new CSS_SRT__c();
                    srtRec.Job_Order__c = serJob.Id;
                    srtRec.SRT_ID__c = dArea.SRTGroup +'-'+dArea.Procedure+'-'+dArea.Step;
                    srtRec.SRT_Quantity__c = dArea.Quantity;
                    srtRec.SRT_Time__c = dArea.SRTHour;
                    srtRec.Actual_Hour__c = dArea.ActualHour;
                    srtRec.Billed_Hour__c = dArea.BilledHour;
                    srtRec.Bill__c = dArea.Bill;
                    srtRec.Troubleshoot__c = dArea.Troubleshoot;
                    srtRec.Flexible__c  = dArea.Flexible;
                    srtRec.Private_Work__c = dArea.PrivateWork;
                    srtRec.Service_Model_Name__c = dArea.ServiceModelName;
                    srtRec.SRT_Title__c = dArea.Title;
                    srtRec.SRT_Order__c = dArea.SortOrder;
                    srtRec.SRT_Access_Code__c = dArea.Access;
                    srtRec.Access_Code__c = dArea.Access;
                    srtRec.Warranty_Allocation__c = dArea.WarrantyAllocation;
                    srtRec.Adjustment_Reason__c = dArea.AdjustmentReason;
                    srtRec.Account_Code__c = dArea.AccountCode;
                    srtRec.Claim_Type__c = dArea.ClaimType;
                    srtRec.Create_Date__c = dArea.CreateDate;
                    srtRec.Create_User__c = dArea.CreateUser;
                    srtRec.Change_Date__c = dArea.ChangeDate;
                    srtRec.Change_User__c = dArea.ChangeUser;
                    srtRec.Type__c = 'BMS SRT';
                    lstSRTinsert.add(srtRec);
                }
                if(lstSRTinsert.size() > 0){
                    try{
                        insert lstSRTinsert;
                        String tempSRTID = '';
                        for(CSS_SRT__c errorSRT : lstSRTinsert){
                            if(tempSRTID == '')
                                tempSRTID = tempSRTID + errorSRT.SRT_ID__c;
                            else
                                tempSRTID = tempSRTID + ',' + errorSRT.SRT_ID__c;
                        }
                        JSONResponseBody = '{ "Header": {"Status":"SUCCESS", "ReturnCodeDescription":"SUCCESS:'+tempSRTID+' - updated successfully in Guidanz.","Location": {"LocationID": "'+ServiceJobLocation+'"}}}';
                    }
                    catch(exception err){
                        String tempSRTID = '';
                        for(CSS_SRT__c errorSRT : lstSRTinsert){
                            if(tempSRTID == '')
                                tempSRTID = tempSRTID + errorSRT.SRT_ID__c;
                            else
                                tempSRTID = tempSRTID + ',' + errorSRT.SRT_ID__c;
                        }
                        JSONResponseBody = '{ "Header": {"Status":"SUCCESS", "ReturnCodeDescription":"ERROR:'+tempSRTID+' - Failed to update in Guidanz.","Location": {"LocationID": "'+ServiceJobLocation+'"}}}';
                    }
                }
                System.debug('===>JSONResponseBody 36' + JSONResponseBody);
            }
        }
        catch(Exception e){
            if(e.getTypeName() == 'System.JSONException'){
                system.debug('exception-->'+e.getMessage()+'line number'+e.getLineNumber());
                JSONResponseBody = '{ "Header": {"Status":"Error", "ReturnCodeDescription":"Invalid JSON Schema","Location": {"LocationID": "'+ServiceJobLocation+'"}}}';
                insIntegrationError(JSONResponseBody, 'Invalid JSON. Notify INSITE.',jsonRequestBody);
            }
            else
            {
                JSONResponseBody = '{ "Header": {"Status":"Error", "ReturnCodeDescription":"Internal Error Occurred","Location": {"LocationID": "'+ServiceJobLocation+'"}}}';                
                insIntegrationError(JSONResponseBody, 'CSS Error:' + e.getMessage(),jsonRequestBody);
            }
            System.debug('In Catch block with the message '+e.getmessage()+' and in the line '+e.getLineNumber());
        }
        System.debug('===>JSONResponseBody 63' +JSONResponseBody);
        res.responseBody = Blob.valueOf(JSONResponseBody);
    }


    global static void insIntegrationError(string errDesc, string sysError, string reqMsg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Error_Description__c = sysError + ' *** External Message ** ' + errDesc;
        errObj.Source__c = 'BMS JobPlan to Guidanz';
        errObj.Processed_Data__c = reqMsg;
        insert errObj;
    }
}