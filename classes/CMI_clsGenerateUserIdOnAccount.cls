global class CMI_clsGenerateUserIdOnAccount
{

    webservice static string generateUserId(ID AccId,String ClassName)
    {
       List<Contact> lstContact = new List<Contact>();
       List<Account> lstAccount = new List<Account>();
       List<User> lstuser =new List<User>();
       map<id,Boolean> isActiveAccMap = new map<id,Boolean>();
       map<id,Account> tableidMap = new  map<id,Account>();
       string retStatus= '';
       Id IdContact ;
       //added by karthik
       String Name='';
       
       system.debug('AccId===='+AccId);
       
       try
       {
       //Added by karthik
         if((String.isEmpty(Name))&&ClassName=='CMI_APIAccountCreation')
       {
       Name='CMI_APIAccountCreation';
       }
       else{
       Name=ClassName;
       }
       System.debug('Name os the class in Generate userf id'+Name);
       //end 
       
         if(AccId != null)
          {
               
            // lstContact  = [Select Id,Name,FirstName,LastName,Email,Created_User_Id__c,Phone,CMI_Tableau_Id__c,Account.CSS_Timezone__c,
             //               Account.CMI_Customer_SK__c,Account.CSS_Locale__c,Account.CSS_Language__c,AccountId  from Contact where 
              //              AccountId=:AccId and Created_User_Id__c=FALSE and Email != null and  Name != null limit 1];
              
            lstContact  = [Select Id,Name,FirstName,LastName,Email,Phone,CMI_TableauId__c,CMI_Contact_Type__c,Account.CSS_Timezone__c,Account.CMI_CId__c,
                           Account.CMI_Customer_SK__c,Account.CSS_Locale__c,Account.CSS_Language__c,CMI_Dummy_Email__c,AccountId  from Contact where AccountId=:AccId and  Name != null and CMI_Dummy_Email__c=false];
             if(!lstContact.isEmpty())
             { 
             IdContact =lstContact[0].Id; 
             system.debug('List of contacts'+lstContact  );
             lstuser=[Select id, Email,IsActive  from User where Email =:lstContact[0].Email and IsActive= true and contact.Accountid=:lstContact[0].Accountid];          
             System.debug('Printing user details for the contaccts that are in lstcontacts'+lstuser);
                    if(lstContact[0].Email != null)
                    {
                        
                        if(!lstuser.isempty() && lstuser[0].isActive==true)
                        {
                          retStatus='User already been created with this email id.';
                        }
                        else
                        {
                            system.debug('lstContact===='+lstContact);              
                            lstAccount  = [Select id, Name ,CMI_CId__c, CSS_Timezone__c,CSS_Locale__c,CSS_Language__c,IsCustomerPortal,CMI_Customer_SK__c, CMI_Account_Status__c  from Account where Id=:AccId];
                            system.debug('lstAccount===='+lstAccount);              
                              if(lstAccount!= null && lstAccount.size() > 0)
                              {
                                for(Account objAcc : lstAccount)
                                {
                                 if(!isActiveAccMap.containsKey(objAcc.Id))
                                 {
                                    if(objAcc.CMI_Account_Status__c=='Active-Indemnified')
                                     {
                                       isActiveAccMap.put(objAcc.Id,true); 
                                     }
                                     else
                                     {
                                        isActiveAccMap.put(objAcc.Id,false); 
                                     }
                                    tableidMap.put(objAcc.Id,objAcc);
                                  }
                                }
                                 system.debug('isActiveAccMap===='+isActiveAccMap);
                                 system.debug('tableidMap===='+tableidMap);  
                                 if(isActiveAccMap.keySet().size() > 0 && tableidMap.keySet().size() > 0)
                                 {
                                 system.debug('printing user creation details'+lstContact);
                                     CMI_CreateUsersHelper.CreateUsers(lstContact,isActiveAccMap,tableidMap,false,Name);
                                     updateaccount(lstAccount[0].id);
                                   // String strResponse=CMI_CompanyInformation.CalloutResponseContents(accid,objAcc.CMI_Account_Status__c,'Send To PC');
                                     retStatus='User succesfully generated';
                                     
                                 }
                              }
                             
                        }
                    }   
                    else
                    {
                        retStatus='Contact email is null or empty. Please enter email Id.';
                    }   
                 }
                 else if(!lstContact.isEmpty() )
                 {
                    if(lstuser[0].isActive == false && lstContact[0].Email != null)
                    {
                        List<User> lstUserForUpdate = new List<User>();
                        List<User> lstuser1=[Select id, Email, IsActive, contactId  from User where Email =:lstContact[0].Email AND IsActive= false and contactId=:IdContact ];
                        
                        if(lstuser1 != null && lstuser.size() > 0)
                        {
                            
                           List<Id> lstIds = new List<Id>();
                            for(User ObjUser : lstuser1)
                            {
                                if(ObjUser.IsActive == false)
                                {
                                    ObjUser.IsActive = true; 
                                    lstUserForUpdate.add(ObjUser);
                                    lstIds.add(ObjUser.Id);
                                }
                            }
                            System.debug('Printing user ids thta needs password reset'+lstIds);
                            if(lstIds != null && lstIds.size() > 0)
                            {
                           
                               Update lstUserForUpdate;
                               CMI_CreateUsersHelper.doResetPassword(lstIds);
                               retStatus='User activated for already existing user.';
                                lstContact[0].CMI_IsActive__c=true;
                             /* if(lstContact[0].CMI_Contact_Type__c == 'Primary'){
                          
                                     sendmailinvite(lstContact[0].email,lstContact[0].AccountId,lstContact[0].Id); 
                                       }*/
          
                            }                           
                        }
                       else 
                       {
                          retStatus='User Id already generated for this contact.';
                       }
                    }
                 }
                else
                {
                retStatus='User cannot be generated for dummy email id';
                }
             }
             else
             {
                 retStatus='No valid contact found.';
             }
             
       }
       catch(Exception ex)
       {
           System.debug('Error ====='+ ex.getMessage());
           retStatus= 'User generation failed. Error :' + ex.getMessage();
       }
       
    
      return retStatus;
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

@future
public static void updateaccount(String aid)
{
Account a=[select id,CMI_Account_Status__c,CMI_Activated_By__c,CMI_Activation_Date__c from Account where id=:aid];
a.CMI_Account_Status__c = 'Active';
  if(a.CMI_Activated_By__c==null)
 {
  a.CMI_Activated_By__c=UserInfo.getName();
 }
               else if(a.CMI_Activation_Date__c==null)
                {
                a.CMI_Activation_Date__c=date.ValueOf(string.valueOfGmt(DateTime.now()));
                }
               
update a;
}
}