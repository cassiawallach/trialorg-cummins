/* Expiring this class along with the process builder name -> IAM_Contact_Provisioning_Sepertion_Renewal which was calling this class
 * done by @souvik as this functionality will be executing from IAM_UserFeatureAndAccessTriggerHandler.updateConproActiveInactive method 
 * Changes done as per the requirement for Guidanz Automation Flow Optimization Date - 08/25/2022
 */

public without sharing class IAM_Contact_Provisioning_Renewal {
    
    //Added by Lavanya -- invocable method called from process builder to update the expiration date on contact provisioning record
    @InvocableMethod
    public static void updateQSOLExpFld(List<IAM_Contact_Provisioning__c> conPros) {
        /*
        try{
            system.debug('conPros '+conPros);
            List<IAM_Contact_Provisioning__c> conList = new List<IAM_Contact_Provisioning__c>();
            Set<Contact> contactList = new Set<Contact>();
            
            for(IAM_Contact_Provisioning__c conPro:conPros){
                system.debug('conPro.IAM_Qsolexpiration__c '+conPro.IAM_Qsolexpiration__c);
                system.debug('conPro.IAM_Contact__r.IAM_Qsolexpiration__c '+conPro.IAM_Contact__r.IAM_Qsolexpiration__c);
                if(conPro.IAM_Qsolexpiration__c != null 
                   &&  conPro.IAM_Contact__r.IAM_Qsolexpiration__c != conPro.IAM_Qsolexpiration__c 
                   && conPro.IAM_Contact__r.IAM_Contact_Status__c == 'Active'){
                       
                       IAM_Contact_Provisioning__c ICP = new IAM_Contact_Provisioning__c();
                       ICP.Id = conPro.Id;
                       ICP.IAM_Contact__r.IAM_Qsolexpiration__c = conPro.IAM_Qsolexpiration__c;
                       conList.add(ICP);
                       
                   }
                
                if(conPro.IAM_Status__c == 'Active' && conPro.IAM_Application_Name__c != null){
                    
                    IAM_Contact_Provisioning__c ICP = new IAM_Contact_Provisioning__c();
                    ICP.Id = conPro.Id;
                    ICP.IAM_Active_Contact_Provisioning__c = conPro.IAM_Contact__c;
                    ICP.IAM_Inactive_Contact_Provisioning__c = null;
                    conList.add(ICP);
                    
                }else if(conPro.IAM_Status__c != 'Active' && conPro.IAM_Application_Name__c != null){
                    
                    IAM_Contact_Provisioning__c ICP = new IAM_Contact_Provisioning__c();
                    ICP.Id = conPro.Id;
                    ICP.IAM_Active_Contact_Provisioning__c = null;
                    ICP.IAM_Inactive_Contact_Provisioning__c = conPro.IAM_Contact__c;
                    conList.add(ICP);
                }
            }
            system.debug('conList size--->'+conList);
            if(conList.size()>0){
                update conList;
            }
        }catch(exception e){
            system.debug(e);
        }
        */
    }
    
    
    
}