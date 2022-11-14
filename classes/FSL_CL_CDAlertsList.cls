/***********************************************************************************************
Name:FSL_CL_CDAlertsList
Copyright © 2011  Cummins
=======================================================================================
=======================================================================================
Purpose:                                                            
This class is the custom controller class for the FSL_CDAlertsList component to display
the 30 day alerts received from Connected Diagnostics.                                                             
=======================================================================================
=======================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                   DETAIL                                 
1.0 -    PiyushR
*************************************************************************************************/

public class FSL_CL_CDAlertsList {
    Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
    Static String executionLog = 'Log Start';
    @AuraEnabled
    public static List<CDAlertWrapper> getConnectedDiagnostics(String wordOrderId) {
        DateTime startTime = System.Now();
        executionLog = FSL_ApplicationLogger.logStart('FSL_CL_CDAlertsList : getConnectedDiagnostics method ' + startTime, executionLog , isEligibleForAppLogging);
        executionLog = FSL_ApplicationLogger.logMessage('WorkOrder Id '+wordOrderId,executionLog,isEligibleForAppLogging);
        String URL;
        String sPassphrase;
        String ESN;
        String workOrderNumber;
        String MileageString; 
        String Measure;
        List<CDAlertWrapper> CDAlertList;
        try {
            WorkOrder workOrderRecord = [SELECT Id, WorkOrderNumber, Asset.Name, Mileage__c, Mileage_Measure__c FROM WorkOrder where id=: wordOrderId];
            ESN = workOrderRecord.Asset.Name;
            // ESN = '79874483';
            if(workOrderRecord.Asset.Name != null) {
                workOrderNumber = workOrderRecord.WorkOrderNumber;
                if(workOrderRecord.Mileage__c != null) {
                    MileageString = workOrderRecord.Mileage__c.toPlainString();
                } else {
                    MileageString = '-1';
                }
                
                if(workOrderRecord.Mileage_Measure__c != null) {
                    String mileageMeasure = workOrderRecord.Mileage_Measure__c;
                    if(mileageMeasure.equals('Kilometers')) {
                        Measure = 'KM';
                    } else if(mileageMeasure.equals('Hours')) {
                        Measure = 'HR';
                    } else {
                        Measure = 'MI';
                    }
                } else {
                    Measure = '';
                }
                
                if(Test.isRunningTest()) {
                    URL = 'www.yahoo.com';
                    sPassphrase = '1234';
                } else {
                    URL = CSS_getConnnectionDetails.getConnection('CDAlerts').End_Point__c;
                    sPassphrase = CSS_getConnnectionDetails.getConnection('CDAlerts').Passcode__c;
                }
                
                //create querystring to be sent in request URL
                String queryString = '?passphrase='+sPassphrase+'&esn='+ESN+'&dsid='+workOrderNumber+'&milehrs='+MileageString+'&uom='+Measure;
                System.debug('::: queryString = ' + queryString); 
                
                //Creating an HTTP request object
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(URL+queryString);
                
                //making a call to the Connected diagnostics web service
                Http http = new Http();
               	HTTPResponse res;
                
                //storing the JSON response
                String jSONRequestBody; 
                if(Test.isRunningTest()) {
                    jSONRequestBody = FSL_TestDataUtility.getCDAlertResponse();
					FSL_CL_CDAlertWrapper obj = FSL_CL_CDAlertWrapper.parse(jSONRequestBody);
                    System.assert(obj != null);
                } else {
                    res = http.send(req);
                    jSONRequestBody = res.getBody();
                    executionLog = FSL_ApplicationLogger.logMessage('JSON Request Body '+jSONRequestBody,executionLog,isEligibleForAppLogging);
                    FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),wordOrderId);
                }
                
                System.debug('::: JSON Body - '+jSONRequestBody);
                FSL_CL_CDAlertWrapper CDAlertWrap = (FSL_CL_CDAlertWrapper)JSON.deserialize(jSONRequestBody, FSL_CL_CDAlertWrapper.class); 
                CDAlertList = new List<CDAlertWrapper>();
                executionLog = FSL_ApplicationLogger.logMessage('Response Body '+CDAlertWrap,executionLog,isEligibleForAppLogging);
                FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),wordOrderId);
                
                for(FSL_CL_CDAlertWrapper.Distinct_Fault_Code_Info DistinctFC : CDAlertWrap.Distinct_Fault_Code_Info) {
                    CDAlertList.add(new CDAlertWrapper(DistinctFC.fault_Code, 
                                                       DistinctFC.fault_Code_Description, 
                                                       DistinctFC.latest_Occurrence_Date_Time,
                                                       DistinctFC.total_Occurrence_Count
                                                       ));
                }
                
                System.debug('::: FSL_CL_CDAlertWrapper = '+CDAlertWrap);
            }
            return CDAlertList;
            
        } catch(Exception ex){
            System.debug('::: Exception in getRequestAlerts - '+ex.getTypeName()+' and '+ex.getMessage()+' and '+ex.getStackTraceString());
            executionLog = FSL_ApplicationLogger.logMessage('Exception Reason '+ex.getMessage(),executionLog,isEligibleForAppLogging);
                FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),wordOrderId);
            return new List<CDAlertWrapper>();
        }
    }
    
    public class CDAlertWrapper {
        @AuraEnabled public String FaultCode{get;set;}
        @AuraEnabled public String FCDescription{get;set;}
        @AuraEnabled public String FCLODT{get;set;} //Fault Code Latest Occurrence Date Time
        @AuraEnabled public String TotalCount{get;set;}
        
        public CDAlertWrapper(String FaultCode, String FCDescription, String FCLODT, String TotalCount) {
            this.FaultCode = FaultCode;
           	this.FCDescription = FCDescription;
            this.FCLODT = FCLODT;
            this.TotalCount = TotalCount;
        }
    }
}