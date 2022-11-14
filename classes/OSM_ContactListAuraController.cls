public with sharing class OSM_ContactListAuraController {
    @AuraEnabled
    public static List<Contact> getPermContacts(Id accountId){
        List<Contact> contacts = [SELECT Id, Name,MailingAddress,IAM_Contact_Owner__c FROM Contact WHERE AccountId =:accountId];
        List<Id> relContactIds = new List<id>();
        List<Id> relUserIds = new List<id>();
        List<Contact> finalReturnContact = new List<Contact>();
        Map<String,Contact> contIdToContactMap= new Map<String,Contact>();
        for(Contact a: contacts){
            relContactIds.add(a.Id);
            contIdToContactMap.put(a.Id,a);
            
        }

        List<User> currAccUsers = [SELECT id,ContactId FROM User Where ContactId IN: relContactIds];
        Map<String,String> userIdToContactIdMapping = new Map<String,String>();
        for(User u: currAccUsers){
            relUserIds.add(u.id);
            userIdToContactIdMapping.put(u.id,u.ContactId);    
        }
        // System.debug(currAccUsers);
        List<PermissionSetAssignment> osmFleetAdminUsers = [SELECT AssigneeId FROM PermissionSetAssignment WHERE (PermissionSet.Name = 'OSM_Storefront_Admin' OR  PermissionSet.Name = 'OSM_Fleet_Admin') AND AssigneeId IN:relUserIds];
        for(PermissionSetAssignment pa:osmFleetAdminUsers){
            finalReturnContact.add(contIdToContactMap.get(String.valueOf(userIdToContactIdMapping.get(String.valueOf(pa.AssigneeId)))));
        }
        
        return finalReturnContact;
    }

}