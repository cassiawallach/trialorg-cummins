public class IAM_UserCreation{

public Static void  CreateUsers(list<contact> lstContact,map<id,Boolean> isActiveAccMap,map<id,Account> tableidMap,Boolean isFromAccount,String ClassName){
    
        /*//ids for mapping users and permission sets
             set<id> manageuser ;
          set<id> manageSub ;
          set<id> manageboth;
          set<id> dummyset=new set<id>();
          id pMngUsr;
          id pMngSub;
          id pMngBoth;
          string username='';
          //end of ids    
       system.debug('CompanyReg_UserCreation is entered'); 
       System.debug('Class through which it got called'+ClassName);
       Map<String,IDM_Regions__c> mapreg = new Map<String,IDM_Regions__c>();
    try{ 
         //To get list of all regions 
         for(IDM_Regions__c idmreg : [select id,name,IDM_City__c,IDM_State__c,IDM_Location_Owner__c,SES_Country__c from IDM_Regions__c])
        {
        string s1= idmreg.IDM_City__c+idmreg.IDM_State__c+idmreg.SES_Country__c;
        System.debug('Key which we need to compare is '+s1);
        mapreg.put(s1,idmreg);
        if(idmreg.name=='HQ')
        {
            mapreg.put(idmreg.name,idmreg);
        }
        }
        
        
        
        profile objProfile=[select id from profile where name='SES_IDM_Admin_1' limit 1];
        profile objAdmin=[select id from profile where name='SES_IDM_Admin_1' limit 1];
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
          
        list<contact> lstCont=new list<contact>();  
        system.debug('contact list in line  46======='+lstCont);    
        for(contact objCon:lstContact)
        {
             system.debug('objCon========'+objCon);
              
             system.debug('isActiveAccMap.get(id.valueof(objCon.AccountId))========'+isActiveAccMap.get(id.valueof(objCon.AccountId)));   
            if(isActiveAccMap!=null && objCon.AccountId!=null && isActiveAccMap.get(id.valueof(objCon.AccountId)) ){
                lstCont.add(objCon);
                user u=new user();
                //query to assaign Identity approver ID for a user.
                  string ApproverKey=tableidMap.get(id.valueof(objCon.AccountId)).BillingCity+tableidMap.get(id.valueof(objCon.AccountId)).BillingState+tableidMap.get(id.valueof(objCon.AccountId)).BillingCountry;
                
                u.email=objCon.email;
                 system.debug('objCon========'+objCon.email);  
                  system.debug('system.label.IAM_org_label========'+system.label.IAM_org_label);  
                   system.debug('objCon.FirstName========'+objCon.FirstName);  
                    system.debug('objCon.LastName========'+objCon.LastName);
                    Boolean emails=validateEmail(objCon.IDM_Cummins_login_ID__c);
                    System.debug('Checking is email or not'+emails);
                    if(emails==true){
                    username=objCon.IDM_Cummins_login_ID__c;
                    }else{
                    username=objCon.IDM_Cummins_login_ID__c+'@cummins.com';
                    }
                      if(system.label.IAM_org_label!='.cso'){
                    u.Username=username+system.label.IAM_org_label;
                }
               else{
                   u.Username=username;
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
                     system.debug('tableidMap.get(id.valueof(objCon.AccountId)).CMI_Customer_SK__c========'+tableidMap.get(id.valueof(objCon.AccountId)).CMI_Customer_SK__c); 
                       system.debug('tableidMap.get(id.valueof(objCon.AccountId)).Name========'+tableidMap.get(id.valueof(objCon.AccountId)).Name);
                       system.debug('LocalMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Locale__c)========'+LocalMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Locale__c));
                       system.debug('LocalLangMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Language__c)========'+LocalLangMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Language__c)); 
               
               //Update for the assaignment for the user Profile while creating depending upon the Contact Type.
                 if(objCon.CMI_Contact_Type__c=='Primary'||objCon.IDM_Site_Admin__c==true){
                 u.profileId=objAdmin.id;
                 }else{
               u.profileId=objProfile.id;
               }
               u.ContactId =objCon.id;
               
               u.CommunityNickname=objCon.CMI_TableauId__c;
               u.Customer_SK__c=tableidMap.get(id.valueof(objCon.AccountId)).CMI_Customer_SK__c;
               u.CompanyName=tableidMap.get(id.valueof(objCon.AccountId)).Name;
               u.EmailEncodingKey='ISO-8859-1';
               u.LocaleSidKey=LocalMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Locale__c);
               u.LanguageLocaleKey=LocalLangMap.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Language__c);
              // u.TimeZoneSidKey=System.label.CMI_TimeZone; 
               u.TimeZoneSidKey=timeZone.get(tableidMap.get(id.valueof(objCon.AccountId)).CSS_Timezone__c);
               u.SES_Product_Certification__c=tableidMap.get(id.valueof(objCon.AccountId)).CSS_WS_Product_Certification__c;
               u.SES_SP_Code__c=tableidMap.get(id.valueof(objCon.AccountId)).IDM_Service_Provider_Code__c;
               u.Account_Number__c=tableidMap.get(id.valueof(objCon.AccountId)).IDM_Service_Provider_Code__c;
               u.Work_Group_Name__c=tableidMap.get(id.valueof(objCon.AccountId)).CMI_CId__c;
               u.SES_User_Type__c=objCon.CMI_Contact_Type__c;
                        //list<  CMI_Application__c> app1 = [select id, Application_Name__c,IDM_Role__c from CMI_Application__c where IDM_Contact__c =:objCon.id];
   //System.debug(objCon.SES_Applications__c +' app1  >>>>>>>>> '+app1 );
   // for(CMI_Application__c cn:app1 ){
         // u.Application_Name__c =objCon.SES_Applications__c;//+= cn.Application_Name__c+','+cn.IDM_Role__c+';';
                    
   // }//
    
    System.debug('>>>>>>>>> u '+u);
              // u.Application_Name__c = objCon.SES_Applications__c;
              // u.IDM_Role__c = objCon.SES_Role__c;
               
                if(mapreg.containskey(ApproverKey))
                    {  
                    System.debug('enetered string comparision loop===');
                     u.Identity_Approver__c= mapreg.get(ApproverKey).IDM_Location_Owner__c ;   
                    }
            
                    else
                        {
                       System.debug('Entered HQ loop');
                        u.Identity_Approver__c= mapreg.get('HQ').IDM_Location_Owner__c ;
                        }
               
                lstUsers.add(u);
            
            }
        }
        System.debug('lstUsers===='+lstUsers);
        list<id> ids=new list<id>();
        string errormessage;
        if(!lstUsers.isempty()){
        //insert lstUsers;
        Database.SaveResult[] srList = Database.insert(lstUsers, false);
        try{ 
    // list<  CMI_Application__c> app1 = [select id, Application_Name__c,IDM_Role__c from CMI_Application__c where IDM_Contact__c =:lstUsers[0].contactId];
   
       // for(CMI_Application__c cn:app1 ){
           //cn.IDM_User__c =lstUsers[0].id;
            
        //}
        
      //  upsert app1;
           }catch(Exception ex){}
             
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
                        
         CMI_CreateUsersHelper.doResetPassword(ids);
         
            //sendmail(lstContact[0],tableidMap.get(id.valueof(lstContact[0].AccountId)));
            
           //Code to implement assaigining permission set depending upon the site admin role.
           manageuser =new set<id>();
           manageSub =new set <id>();
           manageboth=new set <id>();
          List<user> usr=[Select id,Contact.id,username,Contact.IDM_Site_Admin__c,Contact.IDM_Admin_Role__c from user where id=:ids];
          for(user u:usr){
              if(u.Contact.IDM_Site_Admin__c==true){
                  if(u.Contact.IDM_Admin_Role__c=='Manage User Permissions'){
                      manageuser.add(u.id);
                  }else if(u.Contact.IDM_Admin_Role__c=='Manage Subscriptions'){
                      manageSub.add(u.id);
                  }else if(u.Contact.IDM_Admin_Role__c=='  Manage both User and subscriptions'){
                      manageboth.add(u.id);
                  }
              } 
          }
          
          //Permissions sets
           
          
           List<PermissionSet>pSet=[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet];
        System.debug('printing all permission sets'+pSet);
        if(!pSet.isEmpty()){
            for(PermissionSet p:pSet){
                if(p.Name=='INSITE_Supervisor'){
                    pMngUsr=p.id;
                }
                if(p.Name=='IDM_Manage_Subscriptions'){
                    pMngSub=p.id;
                }
                if(p.Name=='QSOL_Sales_Manager'){
                    pMngBoth=p.id;
                }
            }
        }
            if(pMngUsr!=null && (!manageuser.isEmpty())){
            IDM_appAssign.AssignPermissionSetToUsers(manageuser,dummyset,pMngUsr,'Insert');
            }
            if(pMngSub!=null && (!manageSub.isEmpty() )){
            IDM_appAssign.AssignPermissionSetToUsers(manageSub,dummyset,pMngSub,'Insert');
            }
            if(pMngBoth!=null && (!manageboth.isEmpty())){
            IDM_appAssign.AssignPermissionSetToUsers(manageboth,dummyset,pMngBoth,'Insert');
            }
            
        
            //Code ends for assaigning permissions set.
            
        }else{
                if(errormessage!=null)
               CMI_CreateUsersHelper.sendmailToAdmin(lstCont,errormessage);
                system.debug('errormessage ====null');
        }
    } catch( Exception ee) { 
    system.debug('exception error===='+ee.getMessage());
    System.debug('string  track of the error is'+ee.getStackTraceString());
        CMI_CreateUsersHelper.sendmailToAdmin(lstContact,ee.getMessage());
        //lstContact[0].adderror('user not created because of the same username/'+ee.getMessage());
    }*/
    
}
public static Boolean validateEmail(String email) {
    Boolean res = true;
        
    
    String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
    Pattern MyPattern = Pattern.compile(emailRegex);
    Matcher MyMatcher = MyPattern.matcher(email);

    if (!MyMatcher.matches()) 
        res = false;
    return res; 
    }
  
}