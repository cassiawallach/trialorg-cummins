global class IAM_ContactsUpdateBatch implements Database.Batchable < sObject > {

    // use a property
    global final List<Id> lstContactId;

    global IAM_ContactsUpdateBatch(List<Id> lstContactId) {
        // expose property to batch methods
        this.lstContactId = lstContactId;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('@@@@@contact Ids passed@@@@@@@@' +lstContactId);
        String queryContact = 'select id,name,IAM_Contact_Status__c,IAM_Reason__c from contact where id in : lstContactId AND IAM_Reason__c = NULL';
        system.debug('contact Query is******' +queryContact);
        return Database.getQueryLocator(queryContact);
    }

    global void execute(Database.BatchableContext BC, List <Contact> conList) {
         List<Contact> UpdateConlst = new List<Contact>();
         Set<id> UpdateCon= new set<id>();
         for(contact con : conList) {
          if(con.IAM_Contact_Status__c != 'Inactive') {
           con.IAM_Contact_Status__c = 'Inactive';
           con.IAM_Reason__c = 'System inactivated user due to inactivity';
           UpdateConlst.add(con);
           updatecon.add(con.id);
          
          }
        }
        if(!UpdateConlst.isEmpty()) {
         update UpdateConlst;
         if(!Test.isRunningTest()){
                IAM_contactHelperClass.Accountchange(UpdateCon);
            }
      }
    }

    global void finish(Database.BatchableContext BC) {}
}