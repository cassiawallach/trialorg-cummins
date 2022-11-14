Global class ABO_OTPGeneration
{
   
    public Contact c{get;set;}

    public String web_generateOTP(String conemail) {
    System.debug('::::generateOTP');
    
      String rand = string.valueof(Math.abs(Crypto.getRandomInteger()));
        String otp = rand.substring(0,6);
        
        /*This is for Email testing*/
     
    Contact c= [select email,id from contact where id=:System.Label.ABO_OTP_Dummy_contactID limit 1];
    c.phone=otp;
    update c;
    system.debug('printing contact details for otp'+c);
    EmailTemplate template = [SELECT id FROM EmailTemplate WHERE name  ='ABO_OTP'];
    String[] toAddresses=new String[] {conemail};
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
    {
     if(owa.Address.contains('noreply')) 
      mail.setOrgWideEmailAddressId(owa.id); 
    }
    String fromAddress='noreply.identity@cummins.com';
    mail.setTargetObjectId(c.Id);
    mail.setTreatTargetObjectAsRecipient(false); 
    mail.setTemplateId(template.id);
    mail.setToAddresses(toAddresses);
   // mail.setWhatId(otp);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    system.debug('####################################'+otp);
    
    return otp;
    
}  
}