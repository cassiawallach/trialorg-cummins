public class CMI_CreateUsersHelper{

public Static void  CreateUsers(list<contact> lstContact,map<id,Boolean> isActiveAccMap,map<id,Account> tableidMap,Boolean isFromAccount,String ClassName){
    
       system.debug('create user helper is entered'); 
    try{   
        profile objProfile=[select id from profile where name='IAM_Site_Admin_Community' limit 1];
        profile objProfile1=[select id from profile where name='IAM User' limit 1];
        List<user> lstUsers=new List<user>();
        map<string,string> timeZone=new map<string,string>();
        Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        for( Schema.PicklistEntry f : ple)
        {
            timeZone.put(f.getLabel(), f.getValue());
            system.debug('f.getLabel()========='+f.getLabel() +'============f.getValue()======'+f.getValue());
                         
        }
         system.debug('timeZone======='+timeZone);    
        
        map<string,string> LocalMap=new map<string,string>();
        Schema.DescribeFieldResult LocalfieldResult = User.LocaleSidKey.getDescribe();
        List<Schema.PicklistEntry> pleLocal = LocalfieldResult.getPicklistValues(); 
        for( Schema.PicklistEntry f : pleLocal)
        {
            LocalMap.put(f.getLabel().replace(' (','('), f.getValue());
                         
        } 
                
        map<string,string> LocalLangMap=new map<string,string>();
        Schema.DescribeFieldResult LocalfieldResult1 = User.LanguageLocaleKey .getDescribe();
        List<Schema.PicklistEntry> pleLocalLang = LocalfieldResult1.getPicklistValues(); 
        for( Schema.PicklistEntry f : pleLocalLang)
        {
            LocalLangMap.put(f.getLabel(), f.getValue());
                         
        } 
        list<id> contid=new list<id>();
        set<Id> setAccountIds = new set<Id>(); 
        for(contact objCon:lstContact)
        {
            contid.add(objCon.id);
            if(objCon.AccountId !=null)
            {
                setAccountIds.add(objCon.AccountId);
            }
        } 
        system.debug('Contact ids in line 39'+contid);  
        map<id,id> useridmap=new map<id,id>();
        for(user u:[select contactId from user where contactId=:contid and profileId=:objProfile.id]){
        system.debug('u========='+u); 
            useridmap.put(u.contactId,u.contactId);
        } 
        system.debug('users mapes in line 44========='+useridmap);  
        list<contact> lstCont=new list<contact>();  
        system.debug('contact list in line  46======='+lstCont);    
        for(contact objCon:lstContact)
        {
             system.debug('objCon========'+objCon);
             system.debug('useridmap.get(objCon.id)========'+useridmap.get(objCon.id)); 
             system.debug('isActiveAccMap.get(id.valueof(objCon.AccountId))========'+isActiveAccMap.get(id.valueof(objCon.AccountId)));   
            if(isActiveAccMap!=null && objCon.AccountId!=null && isActiveAccMap.get(id.valueof(objCon.AccountId))&& (useridmap==null || useridmap.get(objCon.id)==null) ){
                lstCont.add(objCon);
                user u=new user();
                u.email=objCon.email;
                 system.debug('objCon========'+objCon.email);  
                  system.debug('system.label.css_org========'+system.label.css_org);  
                   system.debug('objCon.FirstName========'+objCon.FirstName);  
                    system.debug('objCon.LastName========'+objCon.LastName);
                      if(system.label.css_org!='.cso'){
                    u.Username=objCon.IAM_Cummins_login_ID__c+System.Label.css_org;
                }
               else{
                   u.Username=objCon.IAM_Cummins_login_ID__c;
               }
                u.firstName=objCon.FirstName;
                u.LastName=objCon.LastName;
                
                if(objCon.LastName.length()>=4){
                    u.alias=objCon.FirstName.substring(0,1)+''+objCon.LastName.substring(0,4);
                }else if(objCon.LastName.length()<=2&&objCon.FirstName.length()<=2){
                    u.alias=objCon.FirstName+''+objCon.LastName;
                }
                
                else{
                    u.alias=objCon.FirstName.substring(0,4-objCon.LastName.length())+''+objCon.LastName;
                }
                 system.debug('U.alias========'+U.alias);  
                system.debug('objProfile.id========'+objProfile.id);  
                 system.debug('U.alias========'+U.alias);  
                   system.debug('timeZone.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Timezone__c)========'+timeZone.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Timezone__c)); 
                     //system.debug('tableidMap.get(id.valueof(objCon.AccountId)).CMI_CId__c========'+tableidMap.get(id.valueof(objCon.AccountId)).CMI_Customer_SK__c); 
                       system.debug('tableidMap.get(id.valueof(objCon.AccountId)).Name========'+tableidMap.get(id.valueof(objCon.AccountId)).Name);
                       system.debug('LocalMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Locale__c)========'+LocalMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Locale__c));
                       system.debug('LocalLangMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Language__c)========'+LocalLangMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Language__c)); 
               
               
              if(objCon.CMI_Contact_Type__c=='Primary'){
               u.profileId=objProfile.id;
               }else{
               u.profileId=objProfile1.id;    
               }
               u.ContactId =objCon.id;
               u.CommunityNickname=objCon.CMI_TableauId__c;
              // u.TimeZoneSidKey=timeZone.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Timezone__c);
               u.CMI_Customer_List__c=tableidMap.get(id.valueof(objCon.AccountId)).CMI_CId__c;
               u.Customer_Name__c=tableidMap.get(id.valueof(objCon.AccountId)).Name;
               u.CompanyName=tableidMap.get(id.valueof(objCon.AccountId)).Name;
               u.EmailEncodingKey='ISO-8859-1';
               u.LocaleSidKey=LocalMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Locale__c);
               u.LanguageLocaleKey=LocalLangMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Language__c);
               u.TimeZoneSidKey=System.label.CMI_TimeZone; 
                lstUsers.add(u);
            
            }
        }
        System.debug('lstUsers===='+lstUsers);
        list<id> ids=new list<id>();
        string errormessage;
        if(!lstUsers.isempty()){
        //insert lstUsers;
        Database.SaveResult[] srList = Database.insert(lstUsers, false);
            for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        ids.add(sr.getId());
                    }
                    else
                    {
                     for(Database.Error err : sr.getErrors()) {

                        errormessage=err.getMessage();
                        System.debug('errormessages===='+errormessage);
                        break;
                        }
                    
                    }
            }
            
        }
        System.debug('Class name isssss'+ClassName);
         System.debug('ids===='+ids);
   if(!ids.isempty()&&Classname!='CMI_APIAccountCreation'){
       //Code to update the contact provisioning records with appropriate user ids.
       List<User> usr=[Select id,Name,contactid from user where id=:ids];
       set<id> ConIds=new set<id>();
       List<IAM_Contact_Provisioning__c> UserFeature=new List<IAM_Contact_Provisioning__c>();
       
       for(user u:usr){
           ConIds.add(u.contactId);
       }
       if(!usr.isEmpty()){
       List<Contact> uCon=[SELECT id,Name,IAM_Contact_Status__c,(select id,IAM_User__c FROM Contact_Provisionings__r ) from contact where id=:ConIds];
           if(!uCon.isEmpty()){
               for(User u:usr){
                   System.debug('Printng user'+u);
                   for(contact c: uCon){
                         c.IAM_Contact_Status__c='Active';
                       system.debug('Printing Contact'+c);
                       if(u.contactid==c.id){
                   for(IAM_Contact_Provisioning__c conProv:c.Contact_Provisionings__r){
                       System.debug('Printing User id'+u.id+u.Name);
                       conProv.IAM_User__c=u.id;
                       UserFeature.add(conProv);
                     }
                   }
                  }     
                }
               update uCon;
           }     
       }
       if(!UserFeature.isEmpty()){
       update UserFeature;
       }
       //End of code addition
            List<Contact> lstContactForUpdate = new List<Contact>();
            if(lstContact != null && lstContact.size() > 0)
            {
              if(ids != null && ids.size() > 0)
                {
                  if(ids.size() == lstContact.size())
                    {
                      for(Contact objCon : lstContact)
                      {
                        //objCon.Created_User_Id__c = true;
                        lstContactForUpdate.add(objCon);
                        if(objCon.AccountId !=  null )
                        {
                            setAccountIds.add(objCon.AccountId);
                        }
                      }                       
                    }
                }
            }
            
            if(lstContactForUpdate!= null && lstContactForUpdate.size() > 0)
            {
                if(ClassName!='CMI_ContactTrigger'){
                lstContactForUpdate[0].CMI_IsActive__c=true;
                update lstContactForUpdate;
                }
                List<Account> lstAccforUpdate= new List<Account>();
                if(setAccountIds != null && setAccountIds.size() > 0)
                {
                    list<Account> lstAccount = [Select Id , CMI_Account_Status__c from Account where Id In:setAccountIds];
                    for(Account objAccount : lstAccount)
                    {
                       // objAccount.CMI_Account_Status__c='Active';
               
                        lstAccforUpdate.add(objAccount);
                        
                    }
                        system.debug('updated account status'+lstAccforUpdate);
                    if(lstAccforUpdate != null && lstAccforUpdate.size() > 0)
                    {
                        update lstAccforUpdate;
                    }
                     system.debug('updated account status2'+lstAccforUpdate);
                }
            }
            
            doResetPassword(ids);
        
             if(lstContact[0].CMI_Contact_Type__c == 'Primary'){
                          //testing invite user from workflow
                                 //    sendmailinvite(lstContact[0].email,lstContact[0].AccountId,lstContact[0].Id); 
                                       }
           
            //sendmail(lstContact[0],tableidMap.get(id.valueof(lstContact[0].AccountId)));
        }else{
                if(errormessage!=null)
                sendmailToAdmin(lstCont,errormessage);
                system.debug('errormessage ====null');
        }
    } catch( Exception ee) { 
    system.debug('exception error===='+ee.getMessage());
    System.debug('string  track of the error is'+ee.getStackTraceString());
        sendmailToAdmin(lstContact,ee.getMessage());
        //lstContact[0].adderror('user not created because of the same username/'+ee.getMessage());
    }
    
}
//email for invite user 
public static void sendmailinvite(String email,String AccId,Id ConId){

    system.debug('entered email function'+email);    
    EmailTemplate template = [SELECT id FROM EmailTemplate WHERE name  ='CMI_Invite Page'];
    System.debug('printing template'+template);
    String[] toAddresses = new String[]{email};
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
    {
     if(owa.Address.contains('noreply')) 
      mail.setOrgWideEmailAddressId(owa.id); 
    }
    String fromAddress='noreply.identity@cummins.com';
    mail.setTargetObjectId(ConId);
    mail.setTreatTargetObjectAsRecipient(false); 
    mail.setTemplateId(template.id);
    mail.setToAddresses(toAddresses);
    mail.setWhatId(AccId);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}  
public static void sendmailToAdmin(list<contact> lstCon,string e){

    //user u=[select Email from user where Userrole.name='PC_Admin' limit 1];
    //user u=[select Email from user where Userrole.name='PC_Admin' limit 1];
    //string EmailId=system.label.CMI_Email_ID_USER;
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {system.label.CMI_Email_ID_USER}; 
    String[] ccAddresses = new String[] {System.label.CMI_Email_ID_USER1};
    //String[] ccAddresses = new String[] {'ml237@cummins.com'};
    mail.setToAddresses(toAddresses);
    mail.setCcAddresses(ccAddresses);

    mail.setSenderDisplayName('Salesforce Support');
    e=e.replace('<br>',' ');
    mail.setSubject('user not created');
    mail.setBccSender(false);
    mail.setUseSignature(false);
    //mail.setPlainTextBody('Your Case: ' + case.Id +' has been created.');

    mail.setHtmlBody('User Details:<br/><b> FirstName:</b>' + lstCon[0].FirstName +' <br/><b>LastName:</b>'+lstCon[0].LastName+' </b><br/><b>MailId:</b>'+lstCon[0].email+' <br/><b>UserName:</b>'+lstCon[0].email+
         '<br/><b>User Not Created because:</b>'+e+'<br/><br/><br/> Thanks,<br/> Salesforce');

    // Send the email you have created.
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}

public static void sendmails(string accId,string contactId,String emails,String templateid,Boolean IsActivate){
    
    EmailTemplate template = [SELECT id FROM EmailTemplate WHERE name  =: templateid];
    //string emails = accObj.CMI_Cummins_Support_Email__c; 
    String Addresses = emails;
    List<String> toAddresses;
    System.debug('toAddress==='+Addresses);
    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'noreply.identity@cummins.com'];
    Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
    for(OrgWideEmailAddress owa : [select id, Address, DisplayName from OrgWideEmailAddress]) 
    {
     if(owa.Address.contains('noreply')) 
      mail1.setOrgWideEmailAddressId(owa.id); 
    }
    if(Addresses!=null)
    {
    System.debug('to====');
    toAddresses=new List<string>();
    toAddresses = emails.split(',');
    system.debug('toaddress==='+toAddresses);
    mail1.setToAddresses(toAddresses);

    }
    else
    {
     String[] semail= new List<String>();
     semail.add(system.label.CMI_CC_Email);
     toAddresses = semail;
     system.debug('toAddresses '+toAddresses );
    }
    String fromAddress='noreply.identity@cummins.com';
   // system.debug('BCC Address=='+BCCAddresses);
  //  mail.setSenderDisplayName(fromAddress);
    system.debug('IsActivate=='+IsActivate);
    mail1.setTargetObjectId(contactId);
    mail1.setTreatTargetObjectAsRecipient(false); 
    mail1.setTemplateId(template.id);
    if(IsActivate == true)
    {
        String[] BCCAddresses =new List<String>();
        BCCAddresses.add(system.label.CMI_BCCNotification_Email);
        mail1.setBccAddresses(BCCAddresses);
        mail1.setToAddresses(toAddresses);
    }
    else
    {
        mail1.setToAddresses(toAddresses);
    }   
    
   
    mail1.setWhatId(accId);
    system.debug('mail sent to reps'+mail1);
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail1 });
}

@future 
    public static Void doResetPassword(list<id> userIds) {
    String result ;
    system.debug('users ids'+userIds);
    try {
        for(string userid:userids){
        system.resetpassword(userId,true);
           
        }
   } catch (Exception ce) {
      //ce.printStackTrace();
   }
   
}
}