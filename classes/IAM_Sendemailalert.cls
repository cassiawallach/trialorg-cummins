public with sharing class IAM_Sendemailalert {
public static void sendemail(Id conId,Id accId) {
system.debug('Id@@@'+conId);
     List<Contact> lstContOwner1;
     Account DistributorAcc = [Select id,Name,parent.id from Account where id=:accId AND parent.id != null];
     lstContOwner1 = [select id, accountid, Username__c,Email from contact where AccountId =:DistributorAcc.parent.id and CMI_Contact_Type__c =: 'Primary'];
     system.debug('Distributor******'+DistributorAcc);
     system.debug('Contact******'+lstContOwner1);
     
    String[] addr;
    String sEmailAddresses = String.valueOf(lstContOwner1[0].email);
    EmailTemplate template = [SELECT id FROM EmailTemplate WHERE name = 'IAM Distributor Email'];
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
    {
     if(owa.Address.contains('noreply')) 
      mail.setOrgWideEmailAddressId(owa.id); 
    }
    String[] toaddr = sEmailAddresses.split(',');
    mail.setTargetObjectId(conId);
    mail.setTemplateId(template.id);
    mail.setTreatTargetObjectAsRecipient(false); 
    mail.setWhatId(accId);
     mail.setToAddresses(toaddr);    
     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      
       // return Page.cmi_inviteconfirm;
    }
    
    
     public static void updateDistributorInfo(Id accId) {
      
     List<Contact> lstContOwner1;
     Account DistributorAcc = [Select id,Name,parent.id from Account where id=:accId AND parent.id != null];
     if(DistributorAcc != null) {
         lstContOwner1 = [select id, accountid, Username__c,Email from contact where AccountId =:DistributorAcc.parent.id and CMI_Contact_Type__c =: 'Primary'];
     }
     //system.debug('Distributor******'+DistributorAcc);
     system.debug('Contact******'+lstContOwner1);
      if(lstContOwner1.size() > 0 ){
                List<User> lstUser1 = null;
                if(system.label.IAM_org_label!='.cso')
                    lstUser1 = [select id from user where username =: lstContOwner1[0].Username__c + System.label.IAM_org_label];
                else    
                    lstUser1 = [select id from user where username =: lstContOwner1[0].Username__c];
                    
                if(null != lstUser1 && lstUser1.size() > 0) {
                  system.debug('lstUser1****'+lstUser1[0]);
                  DistributorAcc.ownerId = lstUser1[0].id;
                  DistributorAcc.IAM_Distributor_Access__c = true;
                  update DistributorAcc;
                  system.debug('DistributorAcc*Update-------'+DistributorAcc);
                  
                }
      }
          
    }
  }