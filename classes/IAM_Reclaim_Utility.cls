/************************************************************
Name:  IAM_Reclaim_Utility
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Test Class for Reclaim Process for Some Reclaim functions.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Golakram       09/02/2020        INITIAL DEVELOPMENT 
1.1 -    Karthik Golakaram      10/21/2020    Made Code changes to identify guidanz role
                                              only for technician and Advanced roles   
1.2 -    Karthik Golakaram      11/09/2020     Made changes for the profile assignment for warranty users.      
*****************************************************/

public class IAM_Reclaim_Utility {

    //Method to Update Reclaim Tracker.
   Public Static void UpdateNewUserName(String oldUsername,String newUSername){
       List<IAM_Reclaim_Tracker__c> reclaim=[SELECT name
                                                  , IAM_New_Username__c 
                                                    FROM IAM_Reclaim_Tracker__c
                                                    WHERE name=:oldUsername ORDER BY CreatedDate LIMIT 1];
           System.debug('Printing record that is getting updated'+reclaim);
           if(!reclaim.isEmpty()){
               reclaim[0].IAM_New_Username__c=newUSername;
               update reclaim;
           }
   }

   //Update reclaim tracker flags.
    Public Static Void UpdateReclaimTracker(String newUserName,Map<String,Boolean> valueToUpdate){
       System.debug('Printing the Reclaim Tracker Status'+newUsername+'value to be Updating'+valueToUpdate);
       List<IAM_Reclaim_Tracker__c> reclaimUsers = [Select name,Assign_Permission_set__c, Guidanz_User__c,Contact_update__c,IAM_New_Username__c,Create_User__c, LDAP_Create_User__c, LDAP_Group_Mapping__c, LDAP_Move_User__c, Promotion_Code__c from IAM_Reclaim_Tracker__c Where IAM_New_Username__c=:newUserName LIMIT 1];
           if(!reclaimUsers.isEmpty()){
               for(String sk:valueToUpdate.keySet()){
                   if(sk=='Is_Contact_Update'){
                       reclaimUsers[0].Contact_update__c=true;
                   }
                   else if(sk=='Promotion API'){
                       reclaimUsers[0].Promotion_Code__c=true;    
                   }
                   else if(sk=='Is_Assign_Permission_Set'){
                       reclaimUsers[0].Assign_Permission_set__c=true;
                   }
                   else if(sk=='Is_Guidanz_User_Update'){
                       reclaimUsers[0].Guidanz_User__c=true;
                   }
                   else if(sk=='Is_Create_User'){
                       reclaimUsers[0].Create_User__c=true;
                   }
                   else if(sk=='is_LDAP_Insert_Group_Addition_API'){
                       reclaimUsers[0].LDAP_Group_Mapping__c=true;
                   }
                   else if(sk=='is_LDAP_Insert_API'){
                       reclaimUsers[0].LDAP_Create_User__c=true;
                   }
               }
               Update reclaimUsers;
           }
   }

   //Method to identify user has access to cst application or not by passing application and traversing them.
   Public Static boolean isCSTUser(Contact cn,String applicationNameTocheck){
       Boolean isCST=false;
       String allApplicationGroups=allApplicationGroupsFromContact(cn);
       System.debug('Prinitng application Name to check'+applicationNameTocheck);
       System.debug('Printing all application Groups'+allApplicationGroups);
       if(!String.isEmpty(allApplicationGroups)){
           List<String> appGroupsFromContact=getUpperCaseGroupNames(allApplicationGroups);
           Map<String,IAM_Application_Groups__c> appGrps=getUpperCaseDNValuefromCustomSettings();
           System.debug('Printing app grps in user App Check'+appGroupsFromContact);
           for(String s:appGroupsFromContact){
               if(appGrps.containsKey(s)){
                   System.debug('Prinitng app is present'+appGrps.get(s).IAM_Application_Name__c);
                   if(appGrps.get(s).IAM_Application_Name__c==applicationNameTocheck){
                       isCST=True;
                   }
               }
           }
       }
       return isCST;
   }


   // Method to identify the profile that need to be updated.
   //check if application groups has guidanz application.
   Public static id profileToBeAssigned(Contact cn){
        id ProfileId;
       //Check if user is exsisting and profile Name starts with CSS_
       Boolean isCommunityPlusLicense=isGuidanzProfile(cn);
       // check if user has access to guidanz and what Role he has 
       Boolean isGuidanzUser=isCSTUser(cn,Label.IAM_AppName_Guidanz);
       Boolean isWarrantyUser=isCSTUser(cn,'Mexico Warranty');
       Boolean isMexicoWarranty=isWarrantyProfile(cn);
       System.debug('Printing type of guidan user'+isGuidanzUser);
       if(isGuidanzUser){
            //getting all the CSS profiles and putting them in a map.
            List<profile> cssprofiles = [select id,name from profile where name like 'CSS_%'];
            Map<string,id> cssprofmap = new Map<string,id>();
            for(profile pf:cssprofiles){
                cssprofmap.put(pf.name,pf.id);
            }
            String roleOfUser= roleOfGuidanzApplicaiton(cn,Label.IAM_AppName_Guidanz);
            if(roleOfUser=='Advanced'){
                ProfileId=cssprofmap.get(System.label.dealer_advanced); 
            }else if(roleOfUser=='Technician'){
                ProfileId=cssprofmap.get(System.label.dealer_technician);
            }
       }else if(!isGuidanzUser&&isWarrantyUser){
            if(!isMexicoWarranty){
                //then assign IAM_Community_User License or else regular flow.
                ProfileId=[select id from Profile where name='IAM_User_Community_License'].id; 
            }
       }else if(!isGuidanzUser&&!isWarrantyUser){
           if(isMexicoWarranty||isCommunityPlusLicense){
               //then assign IAM_Community_User License or else regular flow.
               ProfileId=[select id from Profile where name='IAM_User_Community_License'].id; 
           }else{
                //Set the profile depending upon the type of the contact.
                if(cn.CMI_Contact_Type__c=='Primary'){
                    ProfileId=[select id from Profile where name='IAM_Site_Admin_Community'].id;
                }else if(cn.CMI_Contact_Type__c=='Secondary'&&cn.IAM_Site_Admin__c==True){
                    ProfileId=[select id from Profile where name='IAM_Site_Admin_Community'].id;
                }else{
                    ProfileId=[select id from Profile where name='IAM User'].id;
                }
           }
       }
       System.debug('Printing Profile ID'+ProfileId);
       return ProfileId;
   }

   //Method to check the profile Name of the user.
   Public Static Boolean isGuidanzProfile(Contact cn){
       
        Boolean isCommunityPlusLicense=false;
        //Check if any user is present and then check profile name.
       List<User> userGuidanz= [Select id,username,Contactid,Profile.Name from User where (FederationIdentifier=:cn.Username__c OR IAM_UID__c=:cn.Username__c) and isActive=True];
       System.debug('User record'+userGuidanz);
       if(!userGuidanz.isEmpty()){
            if(userGuidanz[0].Profile.Name.ContainsIgnoreCase('CSS_')||userGuidanz[0].Profile.Name.ContainsIgnoreCase('IAM_User_Community_License')){
                isCommunityPlusLicense=True;
            }
       }
       System.debug('Printing User Profile is Guidanz or Not'+isCommunityPlusLicense);
       return isCommunityPlusLicense;
   }

   //Method to check the profile Name of the user is Warranty.
   Public Static Boolean isWarrantyProfile(Contact cn){
       
    Boolean isWarrantyProfile=false;
    //Check if any user is present and then check profile name.
   List<User> userWarranty= [Select id,username,Contactid,Profile.Name from User where (FederationIdentifier=:cn.Username__c OR IAM_UID__c=:cn.Username__c) and isActive=True];
   System.debug('User record'+userWarranty);
   if(!userWarranty.isEmpty()){
        if(userWarranty[0].Profile.Name.ContainsIgnoreCase('CSS_')||userWarranty[0].Profile.Name.ContainsIgnoreCase('IAM_User_Community_License')){
            isWarrantyProfile=True;
        }
   }
   System.debug('Printing User Profile is Guidanz or Not'+isWarrantyProfile);
   return isWarrantyProfile;
}

   //method for role to be assigned if it is a guidanz User
   Public Static String roleToBeAssigned(Contact cn){
       String portalRole='';
       String roleFromAppGrps=roleOfGuidanzApplicaiton(cn,Label.IAM_AppName_Guidanz);
       if(cn.Account.Type!='Distributor Account'||cn.Account.Type!='Distributor Branch Account'||cn.Account.Type!='Factory'){//for all other types of account types
           if(roleFromAppGrps=='Advanced'){
               //need to set role and Profile
              portalRole='Executive';    
           }else if(roleFromAppGrps=='Technician'){
               //need to set role and Profile for Technician.
               portalRole='Worker';
           }
       }
       System.debug('Printing Portal Role'+portalRole);
       return portalRole;
   }

   //method to process application groups for guidanz application
   //As of now Guidanz application has only 2 roles Advanced and Technician.
   //New need to check if only those values are present or not. 
   Public Static String roleOfGuidanzApplicaiton(Contact cn,String applicationNameForRole){
       String roleToReturn='';
       string allApplicationGroups=allApplicationGroupsFromContact(cn);
       if(!String.isEmpty(allApplicationGroups)){
           List<String> appGroupsFromContact=getUpperCaseGroupNames(allApplicationGroups);
           Map<String,IAM_Application_Groups__c> appGrps=getUpperCaseDNValuefromCustomSettings();
           for(String s:appGroupsFromContact){
               if(appGrps.containsKey(s)){
                   System.debug('Prinitng app is present'+appGrps.get(s).IAM_Application_Name__c);
                   if(appGrps.get(s).IAM_Application_Name__c==applicationNameForRole){
                       if(appGrps.get(s).IAM_Role_Name__c=='Advanced'||appGrps.get(s).IAM_Role_Name__c=='Technician'){
                            roleToReturn=appGrps.get(s).IAM_Role_Name__c;
                       }
                   }
               }
           }
       }  
      return roleToReturn;
   }


   Public Static String applicationRoles(Contact cn){
       String applicationRolesToReturn='';
       String allAppRoles='';
       string allApplicationGroups=allApplicationGroupsFromContact(cn);
       System.debug('Application Groups from Contact'+allApplicationGroups);
       if(!String.isEmpty(allApplicationGroups)){
           List<String> appGroupsFromContact=getUpperCaseGroupNames(allApplicationGroups);
           Map<String,IAM_Application_Groups__c> appGrps=getUpperCaseDNValuefromCustomSettings();
           for(String s:appGroupsFromContact){
               if(appGrps.containsKey(s)){
                   System.debug('Prinitng app is present'+appGrps.get(s).IAM_Application_Name__c);
                   applicationRolesToReturn+=appGrps.get(s).IAM_Role_Name__c+',';
               }
           }
       }
       if(!String.isEmpty(applicationRolesToReturn)){
           allAppRoles=applicationRolesToReturn.removeEnd(',');
       }
       System.debug('Printing application Roles to return'+allAppRoles);
       return  allAppRoles;
   }
   
   //Method to return all application groups that are present in Custom settings to 
   // User object
   Public Static String allApplicationGroups(Contact cn){
      String applicationRolesToReturn='';
      String allAppRoles='';
      string allApplicationGroups=allApplicationGroupsFromContact(cn);
      System.debug('Application Groups from Contact'+allApplicationGroups);
       if(!String.isEmpty(allApplicationGroups)){
           List<String> appGroupsFromContact=getUpperCaseGroupNames(allApplicationGroups);
           Map<String,IAM_Application_Groups__c> appGrps=getUpperCaseDNValuefromCustomSettings();
           for(String s:appGroupsFromContact){
               if(appGrps.containsKey(s)){
                   System.debug('Prinitng app is present'+appGrps.get(s).IAM_Application_Name__c);
                   applicationRolesToReturn+=appGrps.get(s).IAM_DN_value__c+'|';
               }
           }
       }
       if(!String.isEmpty(applicationRolesToReturn)){
           allAppRoles=applicationRolesToReturn.removeEnd('|');
       }
        System.debug('Printing application Roles to return'+allAppRoles);
       return  allAppRoles;
   }

   //this method will return all the applications  and theor respective roles.
   //for QSOl logic should be bit different.
   Public Static Map<String,String> allAppsAndRoles(Contact cn){
       Map<String,String> appsAndRoles= new Map<String,String>();
       string allApplicationGroups=allApplicationGroupsFromContact(cn);
       System.debug('Printing all application groups from Contact'+allApplicationGroups);
       if(!String.isEmpty(allApplicationGroups)){
           List<String> appGroupsFromContact=getUpperCaseGroupNames(allApplicationGroups);
           Map<String,IAM_Application_Groups__c> appGrps=getUpperCaseDNValuefromCustomSettings();
           for(String s:appGroupsFromContact){
               if(appGrps.containsKey(s)){
                  if(appGrps.get(s).IAM_Application_Name__c!=Label.IAM_AppName_QSOL&&appGrps.get(s).IAM_Application_Name__c!=Label.IAM_Guidanz_Mobile_App_Name){ 
                       if(!appsAndRoles.ContainsKey(appGrps.get(s).IAM_Application_Name__c)){
                           appsAndRoles.put(appGrps.get(s).IAM_Application_Name__c,appGrps.get(s).IAM_Role_Name__c);
                       }else{
                           

                          }
                   }else{
                       //QSOL Application and Guidanz Mobile application 
                       //Considering there will be only one group associated to user.
                       if(appGrps.get(s).IAM_Application_Name__c==Label.IAM_AppName_QSOL){
                           //it is for QSOL
                           if(appGrps.get(s).IAM_Role_Name__c.containsIgnoreCase('CPG')){
                               if(!appsAndRoles.ContainsKey(Label.IAM_QuickServe_Online_CPG_SubName)){
                                   appsAndRoles.put(Label.IAM_QuickServe_Online_CPG_SubName,appGrps.get(s).IAM_Role_Name__c);
                               } 
                           }else{
                               if(!appsAndRoles.ContainsKey(Label.IAM_QuickServe_Online_EBU_SubName)){
                                   appsAndRoles.put(Label.IAM_QuickServe_Online_EBU_SubName,appGrps.get(s).IAM_Role_Name__c);
                               }
                           }
                       }else if(appGrps.get(s).IAM_Application_Name__c==Label.IAM_Guidanz_Mobile_App_Name){
                           //for Guidanz Mobile
                           if(appGrps.get(s).IAM_Role_Name__c.containsIgnoreCase('Immediate Assessment')){
                               if(!appsAndRoles.ContainsKey(Label.IAM_GM_IA_Subscription_Name)){
                                   appsAndRoles.put(Label.IAM_GM_IA_Subscription_Name,appGrps.get(s).IAM_Role_Name__c);
                               } 
                           }
                           if(appGrps.get(s).IAM_Role_Name__c.containsIgnoreCase('Campaign')){
                               if(!appsAndRoles.ContainsKey(Label.IAM_GM_CMP_Subscription_Name)){
                                   appsAndRoles.put(Label.IAM_GM_CMP_Subscription_Name,appGrps.get(s).IAM_Role_Name__c);
                               } 
                           }
                           if(appGrps.get(s).IAM_Role_Name__c.containsIgnoreCase('Service')){
                               if(!appsAndRoles.ContainsKey(Label.IAM_GM_SRV_Subscription_Name)){
                                   appsAndRoles.put(Label.IAM_GM_SRV_Subscription_Name,appGrps.get(s).IAM_Role_Name__c);
                               } 
                           }
                       }
                   }
               }
           }
       }
       System.debug('Printing applications and their roles'+appsAndRoles);
       return appsAndRoles;
   }

   Public Static String allApplicationGroupsFromContact(Contact cn){
       String allApplicationGroups='';
       System.debug('Printing application groups on Contact '+cn.IAM_Applications__c+cn.IAM_is_Member_of__c+'Contact id'+cn.id);
       if(!String.isEmpty(cn.IAM_Applications__c)&&!String.isEmpty(cn.IAM_is_Member_of__c)){
           allApplicationGroups=cn.IAM_Applications__c+'|'+cn.IAM_is_Member_of__c;
       }else if(!String.isEmpty(cn.IAM_Applications__c)){
           allApplicationGroups=cn.IAM_Applications__c;
       }else if(!String.isEmpty(cn.IAM_is_Member_of__c)){
           allApplicationGroups=cn.IAM_is_Member_of__c;
       } 
       return allApplicationGroups;
   }

   Public Static List<String> getUpperCaseGroupNames(String applicationGroups){
       List<String> dn=new List<String>();
       List<String> appgrps=applicationGroups.Split('\\|');
       for(String s:appgrps){
           dn.add(s.toUpperCase(s));
       }
       return dn;
   }

   Public Static Map<String,IAM_Application_Groups__c> getUpperCaseDNValuefromCustomSettings(){
       List<String> dn=new List<String>();
       Map<String,IAM_Application_Groups__c> dnMap= new Map<String,IAM_Application_Groups__c>();
       List<IAM_Application_Groups__c> lstAppGroup = IAM_Application_Groups__c.getall().values();
       for(IAM_Application_Groups__c app:lstAppGroup){
           dnMap.put(app.IAM_DN_value__c.toUpperCase(),app);
       }
       return dnMap;
   } 

  /* Public Static Map<String,IAM_Contact_Provisioning__c> getDNvaluesForExsistingUserAccessAndFeatures(Contact cn){
       Map<String,IAM_Contact_Provisioning__c> dnValues=new Map<String,IAM_Application__c>();
       List<IAM_Contact_Provisioning__c> activeConProv=getUserAccessAndFeaturesForContact(cn);
       dnValues=dnValuesConversion(activeConProv);
       reuturn dnValues;
   } 

   //Method to get DN values from Exsisting Account access and Features.
   Public Static Map<String,IAM_Application__c> dnValuesForAccountAccessAndFeatures(Contact cn){
       Map<String,IAM_Applicaion__c> dnValuesMap=new Set<String>();
       List<IAM_Application__c> activeProv=getAccountApplications(cn);
       dnValuesMap=dnValuesConversion(activeProv);
       reuturn dnValuesMap;
   }

   //Method to get the DN values by passing Contact features or Account access and Features.
   Public Static Map<String,sObject> dnValuesConversion(List<sObject> slist){
       Map<String,sObject> dnValuesObject=new Map<String,sObject>();
       Map<String,IAM_Application_Groups__c> appGrps= new Map<String,IAM_Application_Groups__c>();
       List<IAM_Application_Groups__c> lstAppGroup = IAM_Application_Groups__c.getall().values();
       Map<String,String> appRoles= new Map<string,string>();
       Map<String,sObject> appObject= new Map<String,sObject>();
       for(IAM_Application_Groups__c ap:lstAppGroup){
           if(!appGrps.ContainsKey(ap.IAM_Application_Name__c+ap.IAM_Role_Name__c)){
               appGrps.put(ap.IAM_Application_Name__c+ap.IAM_Role_Name__c,ap);
           }
       }
       if(!slist.isEmpty()){
           for(sObject cp: slist){
               List<String> roles= cp.IAM_Roles__c.Split(';');
               System.debug('Roles for an application'+roles);
               if(roles.size()==1){
                   if(!appRoles.containsKey(cp.IAM_Application_Name__c+cp.IAM_Role__c)){
                       appRoles.put(cp.IAM_Application_Name__c+cp.IAM_Role__c,appGrps.get(cp.IAM_Application_Name__c+cp.IAM_Role__c).IAM_DN_value__c);
                       appObject.put(cp.IAM_Application_Name__c+cp.IAM_Role__c,cp);
                   }
               }else if(roles.size()>1){
                   for(String a:roles){
                       if(!appRoles.containsKey(cp.IAM_Application_Name__c+a)){
                           appRoles.put(cp.IAM_Application_Name__c+a,appGrps.get(cp.IAM_Application_Name__c+a).IAM_DN_value__c);
                           appObject.put(cp.IAM_Application_Name__c+a,cp);
                       }
                   }
               }    
           }
       }

       if(!appRoles.isEmpty()&&!appObject.isEmpty()){
           for(String key:approles.keySet()){
               if(!dnValuesObject.containsKey(key)&&!appObject.ContainsKey(key)){
                   dnValuesObject.put(approles.get(key).toUpperCase(),appObject.get(key));
               }
           }
       }
       return dnValuesObject;
   }*/

   //Method to get all the Contact access and features for a contact.
   Public Static List<IAM_Contact_Provisioning__c> getUserAccessAndFeaturesForContact(Contact cn){

       List<IAM_Contact_Provisioning__c> exsistingConProv=[SELECT id
                                                                  , IAM_Application_Name__c
                                                                  , IAM_Role__c
                                                                  , IAM_Cumpas_Modularity__c
                                                                  , IAM_Qsolexpiration__c
                                                                  , IAM_swregExpire__c
                                                                  , IAM_Subscription_Name__c
                                                                  , IAM_Status__c
                                                                  , IAM_userId__c
                                                                  , IAM_User__c
                                                                   FROM IAM_Contact_Provisioning__c 
                                                                   WHERE IAM_Contact__c=:Cn.id
                                                                   AND IAM_Status__c='Active'];
       return exsistingConProv;
    }

   //Methos to return apps present at location level.
    Public static List<IAM_Application__c> getAccountApplications(Contact cn){
        List<IAM_Application__c> iamApp=[SELECT id
                                               , IAM_Application_Name__c
                                               , IAM_Role__c
                                               , IAM_Subscription_Name__C
                                               , IAM_Subscription_End_Date__c
                                               , IAM_Free_Subscription__c
                                               , IAM_Qsolexpiration__c
                                               , IAM_Source__c
                                               , IAM_Subscription_Start_Date__c
                                               , IAM_Status__c
                                               , IAM_swregExpire__c
                                               FROM IAM_Application__c
                                               WHERE IAM_Account_Name__c=:cn.Accountid
                                               AND IAM_Status__c='Active'];
       return iamApp;
    }

   //method to get all the contact level attributes needed for User creation in Reclaimprocess.
   Public Static Contact contactAttributes(id conid){
       Contact conAttributes=[select id,firstname,lastname,email,phone,Account.OwnerId,Account.CMI_Account_Num__c,IAM_Internal__c,Accountid,Account.Name,CMI_Contact_Type__c,Account.Type,   
       Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c, 
       Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,   
       IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,   
       Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.IAM_Movex_Customer_Code__c, 
       Account.IAM_WWSPS_Regions__c,IAM_contact_check__c,IAM_Contact_status__c,IAM_swregexpire__c,IAM_Legacy_User__c,IAM_Ext_Legacy_Uid__c,IAM_Site_Admin__c  from Contact where id =:conid];
       return conAttributes;
   }
}