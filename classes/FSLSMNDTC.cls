/**********************************************************************
Name: FSLSMNDTC
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the message displayed - 
troubleshooting availablity based on SMN.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      10/14/2019      INITIAL DEVELOPMENT   
1.1 - Charan Teja       10/13/2021      ROAD-20 user story changes
***********************************************************************/
public class FSLSMNDTC {
    
    @AuraEnabled
    public static  Boolean  checkforSMNDTC (String woId) {
        
        WorkOrder wo = [SELECT AssetId, Asset.Service_Model__c, Asset.Engine_Manufacturer__c, FSL_SMN__c FROM WorkOrder WHERE Id = :woId];//Charan: Added smn,engine manfacturer fields for ROAD-20 story
        List <FSL_SMN_DTC__c> FSMN = [SELECT Id FROM FSL_SMN_DTC__c WHERE Name = :wo.Asset.Service_Model__c AND Status__c = 'Active' AND (CDSID__c != null OR CDSID__c != '') LIMIT 1];
        
        if(wo.AssetId == null) {
            return true;
        }
        else {                                                     //Charan:Added for ROAD-20 Story
            if(wo.Asset.Engine_Manufacturer__c == 'Cummins') {
                if(wo.FSL_SMN__c == null) {   
                    return true;
                }
                else if(FSMN != null && FSMN.size() == 1) {
                    return false;
                }
                else {
                    return true;
                }
            } else {
                return false;
            }
            
            
        }
   
    } 
    
    /** @AuraEnabled
public static string getservicemodel(string woId) {
return [SELECT Asset.Service_Model__c FROM Workorder WHERE Id = :woId].Asset.Service_Model__c;
}

@AuraEnabled
public static string getpsn(string woId) {
return [SELECT Asset.Name FROM WorkOrder WHERE Id = :woId].Asset.Name;
} **/
}