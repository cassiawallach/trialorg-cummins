/**********************************************************************
Name: FSL_CumminsUtilities
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This component is used accross all the classes.
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSL_CumminsUtilities {
    
    public static String queryStringFromFieldSet(String objName, String fieldSetName) {
        
        if(!String.isBlank(objName) && !String.isBlank(fieldSetName)) {
            String queryStr = '';
            Boolean firstLiteral = true;
            for(Schema.FieldSetMember fs : readFieldSet(objName, fieldSetName)) {
                if(firstLiteral) {
                    queryStr += fs.fieldPath;
                    firstLiteral = false;
                }
                else {
                    queryStr += ',' + fs.fieldPath;
                }
            }
            return queryStr;
        }
        else {
            return '';
        }
    }
    //returns the list of field APIs
    public static List<String> getFieldAPIsList(String objName, String fieldSetName) {
        
        if(!String.isBlank(objName) && !String.isBlank(fieldSetName)) {
            List<String> fieldAPIs = new List<String>();
            for(Schema.FieldSetMember fs : readFieldSet(objName, fieldSetName)) {
                fieldAPIs.add(fs.fieldPath);
            }
            return fieldAPIs;
        }
        else {
            return new List<String>();
        }
    }
    
    
    //returns the list of field APIs with Labels as value
    public static Map<String, String> getFieldAPIsMap(String objName, String fieldSetName) {
        
        if(!String.isBlank(objName) && !String.isBlank(fieldSetName)) {
            Map<String, String> fieldAPIs = new Map<String, String>();
            for(Schema.FieldSetMember fs : readFieldSet(objName, fieldSetName)) {
                fieldAPIs.put(fs.fieldPath, fs.Label);
            }
            return fieldAPIs;
        }
        else {
            return new Map<String, String>();
        }
    }
    
    public static List<Schema.FieldSetMember> readFieldSet(String ObjectName, String fieldSetName) {
        
        Schema.SObjectType sObjType = Schema.getGlobalDescribe().get(ObjectName);
        Schema.DescribeSObjectResult  sObjResults = sObjType.getDescribe();
        Schema.FieldSet fieldSetObj = sObjResults.FieldSets.getMap().get(fieldSetName);
        return fieldSetObj.getFields();
    }
    
    /*
    * @Author  :   Rajashekar Nallapati
    * @Date    :   07/01/2019
    * @Method  :   auditTrailInsert
    * @Arguemnts:  EventId - Custom Metadata(Audit Trail Event) event Id
    *              String serviceOrderId, String Description, String SymptomOrFaultCode, String Rank, String ServiceResponse
    * @Purpose :   To insert AuditTrail Records
    */
    public static void auditTrailInsert(String eventID, String serviceOrderId, String Description,String SymptomOrFaultCode,String Rank, String ServiceResponse) {
        
        List<Audit_Trail_Event__mdt> objAuditTrailEvent = getEventRecord(eventID);
        system.debug('objAuditTrailEvent'+objAuditTrailEvent);
        FSL_Audit_Trail__c objAuditTrail = new FSL_Audit_Trail__c();
        if (objAuditTrailEvent.size() > 0) {
            objAuditTrail.Event__c = objAuditTrailEvent[0].Event_Type__c;
            objAuditTrail.FSL_Diagnostic_Audit__c = objAuditTrailEvent[0].Diagnostic_Audit_Trail__c;
            if(Description=='') {
                objAuditTrail.FSL_Description__c =  objAuditTrailEvent[0].Event_Description__c;
            }
            else {
                objAuditTrail.FSL_Description__c =Description;
            }
            objAuditTrail.Rank__c = Rank;
            objAuditTrail.Service_Order__c = serviceOrderId;
            objAuditTrail.Solution_Response__c = ServiceResponse;
            objAuditTrail.Symptom__c = SymptomOrFaultCode;
            insert objAuditTrail;
            system.debug('insert---->'+objAuditTrail);
        }
    }
    
    
    
    //returns an instance of fsl audit trail record
    public static FSL_Audit_Trail__c getAuditTrailRecord(String eventID, String serviceOrderId, String Description,String SymptomOrFaultCode,String Rank, String ServiceResponse, String Failures) {
        
        List<Audit_Trail_Event__mdt> objAuditTrailEvent = getEventRecord(eventID);
        system.debug('objAuditTrailEvent'+objAuditTrailEvent);
        FSL_Audit_Trail__c objAuditTrail = new FSL_Audit_Trail__c();
        if (objAuditTrailEvent.size() > 0) {
            objAuditTrail.Event__c = objAuditTrailEvent[0].Event_Type__c;
            objAuditTrail.FSL_Diagnostic_Audit__c = objAuditTrailEvent[0].Diagnostic_Audit_Trail__c;
            if(Description=='') {
                objAuditTrail.FSL_Description__c =  objAuditTrailEvent[0].Event_Description__c;
            }
            else {
                objAuditTrail.FSL_Description__c =Description;
            }
            objAuditTrail.Rank__c = Rank;
            objAuditTrail.Service_Order__c = serviceOrderId;
            objAuditTrail.Solution_Response__c = ServiceResponse;
            objAuditTrail.Symptom__c = SymptomOrFaultCode;
            objAuditTrail.Failure_Name__c = Failures;
            
            system.debug('insert---->'+objAuditTrail);
        }
        return objAuditTrail;
    }
    
    /*
    * @Author  :   Rajashekar Nallapati
    * @Date    :   07/01/2019
    * @Method  :   getEventRecord
    * @Arguemnts:  EventId - Custom Metadata(Audit Trail Event) event Id
    * @Purpose :   To fetch AuditTrail Custom Metadata type Records
    */
    public static List<Audit_Trail_Event__mdt> getEventRecord(String eventID) {
        
        List<Audit_Trail_Event__mdt> objAuditTrailEvent = [SELECT MasterLabel,DeveloperName,Event_Type__c,Event_Description__c,Object_Name__c,Diagnostic_Audit_Trail__c
                                                           FROM Audit_Trail_Event__mdt 
                                                           WHERE MasterLabel=:eventID LIMIT 1];
        return objAuditTrailEvent;
    }
    
    /*
    * @Author  :   Rajashekar Nallapati
    * @Date    :   07/19/2019
    * @Method  :   getStageValues
    * @Arguemnts:  
    * @Purpose :   
    */
    public static List<String> getStageValues(String loggedInProfileName) {
        String profileName = '%'+loggedInProfileName+'%';
          list<PathSetting__mdt>  strIsActiveFor = [SELECT MasterLabel,isActive_For__c
                                                 FROM PathSetting__mdt 
                                                 WHERE isActive_For__c LIKE : profileName ];
        System.debug(strIsActiveFor);
        List<String> stageValues = new List<String>();
        for(PathSetting__mdt objPathSetting : strIsActiveFor) {
            stageValues.add(objPathSetting.MasterLabel);
        }
        System.debug('check--.'+stageValues);
        return stageValues;
    }
    
    /*
    * @Author  :   Ravikanth 
    * @Date    :   07/31/2020
    * @Method  :   getStageValuesforRecordtype
    * @Arguemnts:  
    * @Purpose :   return list of pathsettings records based on status field values 
    */
     public static List<String> getStageValuesforRecordtype(String loggedInProfileName,string stageName,string Type) {
        
        String profileName = '%'+loggedInProfileName+'%';
        String strStage = '%'+stageName+ '%';
        List<PathSetting__mdt> strIsActiveFor = [SELECT MasterLabel,isActive_For__c
                                                 FROM PathSetting__mdt 
                                                 WHERE isActive_For__c LIKE : profileName AND Recordtype_Visible__c LIKE : strStage ];
       
        
        
        System.debug(strIsActiveFor);
        List<String> stageValues = new List<String>();
        for(PathSetting__mdt objPathSetting : strIsActiveFor) {
            stageValues.add(objPathSetting.MasterLabel);
        }
        System.debug('check--.'+stageValues);
        return stageValues;
    }
}