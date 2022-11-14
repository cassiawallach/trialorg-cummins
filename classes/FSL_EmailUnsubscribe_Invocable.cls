public class FSL_EmailUnsubscribe_Invocable {
    
    @InvocableMethod(label='UnSubscribeEmailCommunication' description='unsubscribe email' category='WorkOrder')
    public static void updateContactRecords(list<string> emailAdd){
        
        system.debug('Email Address' + emailAdd + 'Update Contact');
        
        List<Contact> lc = new List <contact>();
        try{        
            for (Contact c : [SELECT Id, Name, Email,Email_Notification_Frequency__c
                              FROM Contact
                              WHERE Email = :emailAdd
                              AND Email_Notification_Frequency__c in('Real-Time','Nightly')
                             ]) {
                                  
                                  // Add all the matching contacts into the list.   
                                  //c.hasOptedOutOfEmail = true;
                                  if(c!=null){
                                  System.debug('Inside If');
                                      c.Email_Notification_Frequency__c='Never/Unsubscribed';
                                      lc.add(c);
                                  }
                                  
                              }
            
            update lc;
            System.debug('Payer_Contact__r.Email_Notification_Frequency__c' + lc);
        }
        catch (System.QueryException e) {
            System.debug('Contact Query Issue: ' + e);
        }   
      
                                  }

}