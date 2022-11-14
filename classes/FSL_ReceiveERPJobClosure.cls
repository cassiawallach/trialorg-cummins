/*********************************************************************************************************************************
Name:FSL_ReceiveERPJobClosure
Copyright © 2019  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the integration api expose class for Customer details from MOVEX.
===================================================================================================================================
===================================================================================================================================
History                                                            
-------                                                            
VERSION                     AUTHOR                  DATE                            DETAIL                                
1.0 -                       PiyushR                 3/10/2020                       INITIAL DEVELOPMENT 
***********************************************************************************************************************************/

@RestResource(urlMapping='/erpjobclosure/*')
//https://cumminscss--gevldev.my.salesforce.com/services/apexrest/erpjobclosure
global class FSL_ReceiveERPJobClosure {
    @HttpPost
    global static void doPostOperation()
    {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;   
        system.debug(':::Request ***'+req);
        string str = FSL_ReceiveERPJobClosure.handleERPJobClosure(req);
        system.debug(':::STR***'+str);
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf((str));  
        system.debug(':::str***'+str); 
    }
    
    public static string handleERPJobClosure(RestRequest req)
    {
        String results;
        string jSONRequestBody = req.requestBody.toString().trim();
        System.debug('::: JSON RequestBody - '+jSONRequestBody);
        FSL_ERPJobClosureWrapper wrapperObj = new FSL_ERPJobClosureWrapper();
        List<WorkOrder> workOrderToUpdate = new List<WorkOrder>();
        try {
            wrapperObj = (FSL_ERPJobClosureWrapper) System.JSON.deserialize(jSONRequestBody, FSL_ERPJobClosureWrapper.class);
            
            System.debug('::: Deserialized Request - '+wrapperObj);
            Map<String, FSL_ERPJobClosureWrapper.DataArea> jobIdWrapperMap = new Map<String, FSL_ERPJobClosureWrapper.DataArea>();
            FSL_ERPJobClosureWrapper.DataArea dtAr =  wrapperObj.DataArea;
            FSL_ERPJobClosureWrapper.Header dtTarget =  wrapperObj.Header;
            
            System.debug('::: DataArea - '+dtAr.CSSJobId+' ** '+dtAr.Action);
            String WorkOrderId;
            String SourceType = System.Label.FSL_Source_Environment_Type;
            
            if(SourceType == 'GZEVLPRD' || Test.isRunningTest())  {
                WorkOrderId = dtAr.CSSJobId;
                system.debug('WoNumber:'+WorkOrderId);
            } else {
                String jobId = dtAr.CSSJobId; 
                WorkOrderId = jobId.substringAfter('-');
                system.debug('JobId:'+WorkOrderId);
                system.debug('RequestJobId:'+jobId);
            }
            if(dtAr.CSSJobId != null && (dtAr.Action == 'DELETE' || dtAr.Action == 'Close')){
                // String WorkOrderId = dtAr.CSSJobId; 
                for(WorkOrder wo : [SELECT Id, WorkOrderNumber, Status, Sub_Status__c, Process_Step__c, FSL_Resolution__c FROM WorkOrder WHERE WorkOrderNumber =:WorkOrderId]) {
                    if(wo != null && (dtAr.Action == 'DELETE' || dtAr.Action == 'Close')) { 
                        wo.Status = 'Closed';
                        wo.Sub_Status__c = 'Close';
                        wo.Process_Step__c = 'Close';
                        wo.RecordTypeId = Schema.getGlobalDescribe().get('WorkOrder').getDescribe().getRecordTypeInfosByName().get('Close').getRecordTypeId();
                        if(dtAr.Action == 'DELETE') {
                            wo.FSL_Resolution__c = 'Job Deleted via ERP'; 
                        } else if(dtAr.Action == 'Close') {
                            wo.FSL_Resolution__c = 'Job Closed via ERP'; 
                        }
                    }
                    System.debug('::: WorkOrder to Process - '+wo);
                    workOrderToUpdate.add(wo);
                }
            } 
            
        } catch(Exception ex) {
            System.debug('::: Execption at line no :: '+ex.getLineNumber()+' Exception Message>>>is:  '+ex.getMessage());
            System.debug('::: Execption Stack :: '+ex.getStackTraceString());
            results = '{"Header":{"Status": "ERROR", "ReturnCodeDescription":"' +  ex.getMessage() + '"}}';
        }
        if(workOrderToUpdate.size() > 0)  {
            Database.SaveResult[] saveResults = Database.update(workOrderToUpdate,false);
            if(saveResults[0].isSuccess()) {
                results = '{"Header":{"Status": "SUCCESS", "ReturnCodeDescription": "Job closed successfully" , "Location" : {"LocationID":"'+wrapperObj.Header.Location.LocationID+'"}}}'; 
            } else {
                results = '{"Header":{"Status": "ERROR", "ReturnCodeDescription":"' + saveResults[0].getErrors()[0].getMessage() + '"}}';
            }
        } else {
            results = '{"Header":{"Status": "ERROR", "ReturnCodeDescription": "No Record Found." }}';
        }
        System.debug('::: Response Result - '+results);
        return results;
    }
}