/**********************************************************************
Name:FSL_CL_RetrieveOptionList
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
------- This class is used for inserting the options
based on ESN
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   SRIPRADA SESHAM    4/29/2019       INITIAL DEVELOPMENT   
2.0     SAKTHIRAJ          7/25/2022       Added method for insert options without future to call it as synchronous for FTR Automation                 
***********************************************************************/

public class FSL_CL_RetrieveOptionList 
{   
    //Ravikanth Added Two lines for Application Log 
    Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
    Static String executionLog = 'Log Start';
    public class WrapOptions	 
    {
        // public list<DataAreaVal> DataArea {get;set;}
        // public class DataAreaVal {
        public string repairGroup;
        public string optionNumber;
        public string optionDescription;
    } //public string jobNumber;
    
    // public class WrapOptions{
    // DataArea = new list<DataAreaVal>();}
    // public class DataAreaVal(){}
    
    // 2.0
    public static void insertOptionsSync(String assetNo, Id serviceOrderId) {  
        GetOptionsAndInsert(assetNo, serviceOrderId);
    }

    @future(callout=true)
    public static void insertOptions(String assetNo, Id serviceOrderId) {  
        GetOptionsAndInsert(assetNo, serviceOrderId);
    }

    // 2.0 Created as a separate method and moved the logic from insertOptionsSync to call it from sync and async methods
    public static void GetOptionsAndInsert(String assetNo, Id serviceOrderId)  {   
        //Ravikanth added till 41 for application log
        DateTime startTime = System.Now();
        ExecutionLog = FSL_ApplicationLogger.logStart('FSL_CL_RetrieveOptionList : insertOptions method ' + startTime, executionLog , isEligibleForAppLogging);
        ExecutionLog = FSL_ApplicationLogger.logMessage('serviceOrder Id '+serviceOrderId,executionLog,isEligibleForAppLogging);

        list<CSS_Parts_Options__c> listCSSOptions = new list<CSS_Parts_Options__c>();
		list<CSS_Parts_Options__c> existingCSSOptions = new list<CSS_Parts_Options__c>();
        string resBody = FSL_CL_QSOLIntegrations.CallForOptionList(assetNo);
        //Ravikanth added Execution log for Application Log
        executionLog = FSL_ApplicationLogger.logMessage('response Body ' +resBody,executionLog, isEligibleForAppLogging);

        Id recTypeId = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Options').getRecordTypeId();
        List<Object> results;
		List<string> setOptionsNumber 	  = new List<string>();
		List<string> setRepairGroup 	  = new List<string>();
        List<string> setOptionDescription = new List<string>();
        // WorkOrder wo = [SELECT Id, WorkOrderNumber, Asset.Name FROM WorkOrder WHERE id=:serviceOrderId];
        List<Asset> lstAsset = new List<Asset>();
        lstAsset = [SELECT Id, Name FROM Asset WHERE name =:assetNo];
        try 
        {
            results = (List<Object>) JSON.deserializeUntyped(resBody);
			for (Object obj: results) 
            {
                WrapOptions optionItem = new WrapOptions ();
                optionItem = (WrapOptions)JSON.deserializeStrict(JSON.serialize(obj),WrapOptions.class); // Parsing values into a Wrap Obj
                setOptionsNumber.add(optionItem.optionNumber.substringBefore('-')); // Returns the Option Number without version
                If (optionItem.repairGroup != Null ||optionItem.repairGroup != ''){
                   setRepairGroup.add(optionItem.repairGroup);  
                }
               
                setOptionDescription.add(optionItem.optionDescription);
			}
            CSS_Parts_Options__c cssOptions = new CSS_Parts_Options__c();
            	cssOptions.RecordTypeId = recTypeId;
             	cssOptions.Option_Number__c = json.serialize(setOptionsNumber);
                cssOptions.Repair_Group__c = json.serialize(setRepairGroup);
                cssOptions.Part_Description__c = json.serialize(setOptionDescription);
				cssOptions.Service_Order__c = serviceOrderId;
            	cssOptions.Option_ESN__c = assetNo;
            	listCSSOptions.add(cssOptions);
            
            if(listCSSOptions.size()>0)
            {
                insert listCSSOptions;
                System.debug('listCSSOptions ' +listCSSOptions);
                //Ravikanth added Execution log for application log object
                ExecutionLog = FSL_ApplicationLogger.logMessage('list CSS Options ' +listCSSOptions,executionLog, isEligibleForAppLogging);
                FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),serviceOrderId);

            }
            // }
        }
        catch(Exception e) 
        {
            System.debug('An exception occurred: ' + e.getMessage());
            ExecutionLog = FSL_ApplicationLogger.logErrorMessage('An exception occurred '+System.Now(),executionLog,isEligibleForAppLogging);

        }
    }
}