/*
Class Name : 
Description: This class is referred from fsl_CommRegionTogglesLWC LWC component to update Custom metadata records from FSA app.
Created By : Madhavi P
JIRA Story : CT4-190
23-10-2020 - Madhavi P - Created this class for setting Communation toggles at regional ERP level
*/
public with sharing class FSL_Comm_RegionToggles_Controller implements Metadata.DeployCallback {
    
    @AuraEnabled(cacheable=true)
    public static list<FSL_Communication_RegionToggles__mdt> getallMetadata() {
        return [SELECT Id,DeveloperName, Label, Authorized_Work_Started__c,Equipment_Available__c,ERP__c,Invoice_Ready__c,Service_Work_Completed__c,Troubleshooting_Started__c,
                Service_Work_Proceeding__c,Equipment_Ready_For_Pick_Up__c FROM FSL_Communication_RegionToggles__mdt ];
    }
    
        
    @AuraEnabled(cacheable=true)
    public static Comm_ReginToggles_wrapper getRegion(String developerName) {
        system.debug('===developerName=== '+developerName);
        Comm_ReginToggles_wrapper wrap = new Comm_ReginToggles_wrapper();
        List<Account> AccList = [SELECT Id,Name,FSL_Source_ERP__c,Authorize_Work_Started__c,Equipment_Available__c,Invoice_Ready__c,Service_Work_Completed__c,Troubleshooting_Started__c
                                 FROM Account
                                 Where FSL_Source_ERP__c  =:developerName
                                 LIMIT 10000];
        
        FSL_Communication_RegionToggles__mdt mtadata =   [SELECT Id,DeveloperName, Label, Authorized_Work_Started__c,Equipment_Available__c,
                                                          ERP__c,Invoice_Ready__c,Service_Work_Completed__c,Troubleshooting_Started__c,Service_Work_Proceeding__c,Equipment_Ready_For_Pick_Up__c,
                                                          Email_Frequency__c, Text_Frequency__c FROM FSL_Communication_RegionToggles__mdt WHERE ERP__c = :developerName limit 1];
        wrap.mtadata = mtadata;
        wrap.accounts = AccList;
        return wrap;
    }
    
    public static list<String> finalnames = new list<String>();
    @AuraEnabled(cacheable=true)
    public static list<string> getallMetadatapicklist() {
        for(FSL_Communication_RegionToggles__mdt mtadata: [SELECT Id,DeveloperName, Label, Authorized_Work_Started__c,Equipment_Available__c,ERP__c,Invoice_Ready__c,Service_Work_Completed__c,Troubleshooting_Started__c,
                                                           Service_Work_Proceeding__c,Equipment_Ready_For_Pick_Up__c FROM FSL_Communication_RegionToggles__mdt]){
                                                               finalnames.add(mtadata.ERP__c) ;  
                                                           }
        return finalnames;
    }
    
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug(' success : '+ result);
        } else {
            System.debug(' fail : '+ result);
        }
    }
    @AuraEnabled(cacheable=true)
    public static Id createUpdateMetadata(String fullName, String label, List<Map<String, String>> fieldWithValuesMap){
        Id jobId;
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        system.debug('fullName --  '+fullName+ '  label== '+label);
        system.debug('fieldWithValuesMap --  '+fieldWithValuesMap);
        customMetadata.fullName = fullName;
        customMetadata.label = label;
        Map<String, boolean> Map_fieldwithValues  = new Map<String, boolean>();
        
        
        for(Map<String, String> sd : fieldWithValuesMap){
            if(sd.get('name')=='Email_Frequency__c' || sd.get('name')=='Text_Frequency__c'){
                Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
                customField.field = sd.get('name');
                customField.value = sd.get('value');  
                customMetadata.values.add(customField);
            }
            else{
                Map_fieldwithValues.put(sd.get('name'), Boolean.valueOf(sd.get('value')));
            }
        }
        system.debug('Map_fieldwithValues== '+Map_fieldwithValues);
        
        for(String key : Map_fieldwithValues.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
            customField.value = Map_fieldwithValues.get(key);  
            customMetadata.values.add(customField);
        }
        system.debug('===customMetadata==='+customMetadata);
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(customMetadata);
        if (!Test.isRunningTest()) {
            jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
        }
        return jobId;
    }
    @AuraEnabled(cacheable=true)
    public static Comm_metaData_wrapper getRegionTogglesMetaData(){
        Comm_metaData_wrapper wrap = new Comm_metaData_wrapper();
        wrap.Email_Frequency = getPickListValuesIntoList('Email_Frequency');
        wrap.Text_Frequency = getPickListValuesIntoList('Text_Frequency');
        system.debug('==wrap=='+wrap);
        return wrap;
    }
        
    public static List<String> getPickListValuesIntoList(String fieldName){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult;
        if(fieldName == 'Email_Frequency'){
            fieldResult = FSL_Communication_RegionToggles__mdt.Email_Frequency__c.getDescribe();
        }else if(fieldName == 'Text_Frequency'){
            fieldResult = FSL_Communication_RegionToggles__mdt.Text_Frequency__c.getDescribe();
        }
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        } 
        system.debug('==pickListValuesList=='+pickListValuesList);
        return pickListValuesList;
    }
    public class Comm_metaData_wrapper{
        
        @AuraEnabled
        public List<String> Email_Frequency{get;set;}
        @AuraEnabled
        public List<String> Text_Frequency{get;set;}
    }
    public class Comm_ReginToggles_wrapper{
        @AuraEnabled
        public FSL_Communication_RegionToggles__mdt mtadata{get;set;}
        @AuraEnabled
        public List<Account> accounts{get;set;}
    }
}