/*************************************************************************************
Name:  IAM_ExistingLoSubInfo_Extension
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Queuable class - In case subscription renewal, update contact provisioning 
record with Role and End Date and Expiration Date In case subscription cancellation,
update contact provisioning record with status value Inactive
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar       09/23/2021      Assigned Value from Label to IAM_Subscription_Count__c
**************************************************************************************
**************************************************************************************/

public class IAM_ExistingLoSubInfo_Extension implements Queueable{
    /* In case subscription renewal, update contact provisioning record with Role and End Date and Expiration Date */
    /* In case subscription cancellation, update contact provisioning record with status value Inactive */
    Public List<id> accAccessIdList;
    Public String action;
    
    Public IAM_ExistingLoSubInfo_Extension(List<Id> accAccessIdList,String action){
        this.accAccessIdList=accAccessIdList;
        this.action=action;
    }
    
    public void execute(QueueableContext Context) {
        
        boolean toUpdateContact=false;
        List<IAM_Contact_Provisioning__c> conToUpdate=new List<IAM_Contact_Provisioning__c>();
        set<id> contactIdToUpdate= new Set<id>();
        List<IAM_Contact_Provisioning__c> updatedConProList = new List<IAM_Contact_Provisioning__c>();
        Map<id,IAM_Application__c> appMap= new Map<id,IAM_application__c>();
        List<IAM_Application__c> apps= getAccountProvisioning(accAccessIdList);
        if(!apps.isEmpty()&&apps!=null){
            for(IAM_Application__c ap: apps){
                if(!appMap.ContainsKey(ap.id)){
                    appMap.Put(ap.id,ap);
                }
            }
        }
        
        
        Map<Id, List<IAM_Contact_Provisioning__c>> conProMap = new Map<Id, List<IAM_Contact_Provisioning__c>>();
        if(!accAccessIdList.isEmpty()) {
            List<IAM_Contact_Provisioning__c> conProList = getContactProvisioning(accAccessIdList);
            if(conProList != null && !conProList.isEmpty()) {
                for(IAM_Contact_Provisioning__c conPro : conProList) {
                    if(conProMap.containsKey(conPro.IAM_Account_Application__r.Id)) {
                        conProMap.get(conPro.IAM_Account_Application__r.Id).add(conPro);
                    } else {
                        List<IAM_Contact_Provisioning__c> newList = new List<IAM_Contact_Provisioning__c>();
                        newList.add(conPro);
                        conProMap.put(conPro.IAM_Account_Application__r.Id, newList);
                    }
                }
            }
        }
        System.debug('#### conProMap - '+conProMap);
        //List<IAM_Contact_Provisioning__c> conProList = getContactProvisioning(accAccessFeatureIdList);
        List<IAM_Contact_Provisioning__c> conProList = new List<IAM_Contact_Provisioning__c>();
        for(Id accAccessId : accAccessIdList) {
            if(conProMap != null && !conProMap.isEmpty() && conProMap.containsKey(accAccessId)) {
                conProList.addAll(conProMap.get(accAccessId));
            }        
        }    
        if(conProList != null && !conProList.isEmpty() && appMap != null && !appMap.isEmpty()) {
            for(IAM_Contact_Provisioning__c obj : conProList) {
                if(action == Label.IAM_Action_Update) {
                    obj.IAM_End_Date__c = appMap.get(obj.IAM_Account_Application__r.Id).IAM_Subscription_End_Date__c;
                    if(appMap.get(obj.IAM_Account_Application__r.Id).IAM_Application_Name__c == Label.IAM_AppName_guidanzmobile){
                        obj.IAM_swregExpire__c = appMap.get(obj.IAM_Account_Application__r.Id).IAM_swregexpire__c;
                    }
                    if(appMap.get(obj.IAM_Account_Application__r.Id).IAM_Application_Name__c == Label.IAM_AppName_QSOL){
                        /* In case of renewal, role upgrade is possible in QSOL application only.*/
                        obj.IAM_Role__c = appMap.get(obj.IAM_Account_Application__r.Id).IAM_Role__c;
                        obj.IAM_Qsolexpiration__c = appMap.get(obj.IAM_Account_Application__r.Id).IAM_QsolExpiration__c;
                    } 
                   
                } else if(action == Label.IAM_Action_Cancel && appMap.get(obj.IAM_Account_Application__r.Id).IAM_Application_Name__c != Label.IAM_Cummins_Service_Training) {
                    obj.IAM_Status__c = Label.IAM_Status_Inactive;
                    obj.IAM_End_Date__c = Date.today();
                } else if(action == Label.IAM_Action_Cancel && appMap.get(obj.IAM_Account_Application__r.Id).IAM_Application_Name__c == Label.IAM_Cummins_Service_Training) {
                    obj.IAM_End_Date__c = Date.today();
                }
                updatedConProList.add(obj);
                 contactIdToUpdate.add(Obj.IAM_Contact__c); 
                    
            }
            
            if(!updatedConProList.isEmpty()){
                System.debug('Update Con Provisiongs future');
                update updatedConProList;
            }
        }
        
        
                    //this should happen only when user access features gets updated.
                    if(!accAccessIdList.isEmpty()){
                     if(!Test.isRunningTest()){
                        IAM_Utility.callLDAPUtilConUpdate(accAccessIdList);
                        }
                        //Process Contacts to get the exact values.
                        //IAM_Utility.updateContacts(contactIdToUpdate);
                        //IAM_Utility.updateUserAttribute(contactIdToUpdate);
                        
                        //Need to write a class for LDAP Util update
                    }
                
    }
    
    
    
    private static List<IAM_Contact_Provisioning__c> getContactProvisioning(List<Id> appId) {
        return [
            SELECT Id
            , IAM_Account_Application__r.Id
            , IAM_Status__c
            , IAM_Contact__r.Id
            FROM IAM_Contact_Provisioning__c
            WHERE IAM_Account_Application__r.Id IN :appId
            AND IAM_Status__c=:Label.IAM_Status_Active
        ];
    }
    
    private static List<IAM_Application__c> getAccountProvisioning(List<Id> appId) {
        return [
            SELECT Id
            , IAM_Application_Name__c
            , IAM_Status__c
            , IAM_Role__c
            , IAM_QsolExpiration__c
            , IAM_swregexpire__c
            , IAM_Subscription_End_Date__c
            , IAM_Subscription_Start_Date__c
            FROM IAM_Application__c
            WHERE id IN :appId
            AND IAM_Status__c=:Label.IAM_Status_Active
        ];
    }
    
    
    
}