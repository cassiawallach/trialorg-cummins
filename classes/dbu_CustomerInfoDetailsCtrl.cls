public Without Sharing class dbu_CustomerInfoDetailsCtrl {
	@AuraEnabled(cacheable=true)
    public static Contact fetchCustomerInfoDetails(String recId) {
        system.debug('recId' +recId);
        id contLOggedInusrId = null;
        List<User> contactUsrID = new List<User>(); 
        contactUsrID = [Select id,ContactID FROM User WHERE id = :recId]; 
        system.debug('contLOggedInusrId' +contactUsrID);
            for(User usr: contactUsrID){
                contLOggedInusrId = usr.ContactID;
            }
        return  [SELECT Id,dbu_Company_Name__c,FirstName,LastName,Email,Phone FROM Contact where Id =:contLOggedInusrId ];
        //return  [SELECT Id,dbu_Company_Name__c,FirstName,LastName,Email,Phone FROM Contact limit 1]; // For Testing Purpose.
    }

    @AuraEnabled(cacheable=true)
    public static List<User> fetchUserInfoDetails(String recId) {
        List<User> userList = new List<User>();  
        userList = [SELECT Id,ContactId,Contact.dbu_Company_Name__c,Contact.FirstName,Contact.LastName,Contact.Email,Contact.Phone, contact.account.FSL_ERP_Customer_Code__c, contact.account.Customer_BMS_number__c, contact.account.FSL_BMS_Instance__c FROM User where Id =:recId ];
        system.debug('userList' +userList);
        return  userList;
    }


    @AuraEnabled 
    public static void updateContactRecord(String recordForUpdate){ 
        Contact contact = (Contact)JSON.deserialize(recordForUpdate,Contact.class);
        system.debug('recordForUpdate>>>>> ' +recordForUpdate);
        List<Contact> contactList = new List<Contact>();
        if(contact.id !=null)
        {
            contactList.add(contact);
            update contactList; 
            dbu_ByPassTriggerForContactUpdate__c.getInstance().dbu_trCMI_ContactTrigger__c = false; 
        } 
        /*
         	contactList.add(contact);
        	update contactList;
         */ 
		
    }
}