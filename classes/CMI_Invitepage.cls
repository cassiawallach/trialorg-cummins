global without sharing class CMI_Invitepage {
Apexpages.StandardController controller; 
//public String subject{get;set;}
//public Boolean refreshPage {get; set;}
//public String body{get;set;}
//public List <String> ToAddresses{get;set;}
Public Account acc{get;set;}
Public Contact c{get;set;}
public String userid{get;set;}
public String sEmailAddresses{get;set;}
global Id accid{get;set;}
public String currentRecordId {get;set;}
public String parameterValue {get;set;}
public CMI_Invitepage(ApexPages.StandardController controller) {
      //  refreshPage=false;
        this.acc= (Account )controller.getRecord(); 
       // String currentParam = ApexPages.currentPage().getparameters().get('ID'); 
       // Id accid= apexpages.currentpage().getparameters().get('Aid');
       //system.debug('url1'+accid);
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('aid');
        system.debug('Id'+currentRecordId  );
       acc = [select id,CMI_Cummins_Support_Email__c,CMI_Primary_Contact_Email__c,(SELECT Id, Name FROM Contacts),CMI_Inviteuser__c from Account where id =: currentRecordId ];
      c=[select id from contact where AccountId =: currentRecordId and CMI_Contact_Type__c='Primary'];
       system.debug(c);
    
        parameterValue = ApexPages.CurrentPage().getparameters().get('aid');
 //aId= ApexPages.CurrentPage().getParameters().get('id');
system.debug('Id'+acc);

    }
public PageReference reset() {
        acc=new Account();
        //contact=new Contact(); 
        PageReference pageRef = new PageReference(System.currentPageReference().getURL());
        pageRef.getParameters().put('aid',currentRecordId );
        pageRef.setRedirect(true);
        
        return pageRef;
    }
public PageReference sendemail() 
{
system.debug('Id'+c.id);
 
    String[] addr;
 
    EmailTemplate template = [SELECT id FROM EmailTemplate WHERE name = 'CMI_CreateAccount'];
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
    {
     if(owa.Address.contains('noreply')) 
      mail.setOrgWideEmailAddressId(owa.id); 
    }
    mail.setTargetObjectId(c.id);
    mail.setTemplateId(template.id);
    mail.setTreatTargetObjectAsRecipient(false); 
    mail.setWhatId(acc.id);
      String[] BCCAddresses =new List<String>();
    system.debug('BCCAddresses  '+BCCAddresses );
    BCCAddresses.add(system.label.CMI_BCCNotification_Email);
   String[] toaddr= sEmailAddresses.split(',');
  
      mail.setToAddresses(toaddr);
      system.debug('toaddr'+toaddr);
       mail.setCcAddresses(addr);
        mail.setBccAddresses(BCCAddresses);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
      
        return Page.cmi_inviteconfirm;
    }




}