/**************************************************************************
Name:  IAM_GuiCreate_PartnerUser
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This schedulable class creates the new Partner Community user 
record and assigns it to the contact records.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -     Anupam Adhikari              24/01/2021        INITIAL DEVELOPMENT
1.1 -     Suresh Rathod                29/05/2022        Changed the code for IAM_Identity_Approver__c on User
*****************************************************************************/
global class IAM_GuiCreate_PartnerUser implements Schedulable{
    
    global void execute(SchedulableContext sc){
        List<Contact> conListPartner = new List<Contact>();
        Set<Id> conSetId = New Set<Id>();
        Map<Id, Id> mapContUserId = new Map<Id, Id>();
        Set<Id> userIdCusComm = new Set<Id>();
        Map<Id, List<String>> mapUserIdPsId = new Map<Id, List<String>>();
        List<User> newUserList = new List<User>();
        Set<Id> accIdSet = new Set<Id>();
        Map<Id, String> mapconIdRole = new Map<Id, String>();
        Map<Id, Id> mapConIdNewUser = new Map<Id, Id>();
        Map<Id, IAM_Contact_Provisioning__c> mapGuidanzConFeat = new Map<Id, IAM_Contact_Provisioning__c>();
        Map<Id, List<IAM_Contact_Provisioning__c>> mapOtherConFeat = new Map<Id, List<IAM_Contact_Provisioning__c>>();
        /*List<Contact> partnerConListFetch = [Select Id, Name, IAM_Partner_User_Record__c FROM Contact
WHERE IAM_Partner_User_Record__c = True AND IAM_Contact_Owner__c = Null];*/
        for(Contact con : [Select Id, Name, IAM_Partner_User_Record__c,IAM_Contact_Owner__c,FirstName,LastName,
                           Email,Username__c,Account.Name,
                           IAM_Ext_Legacy_Uid__c,IAM_is_Member_of__c,IAM_Work_Group_Id__c,
                           IAM_Product_Group_Access__c,Account.CMI_Account_Num__c,AccountId,
                           Phone,IAM_Qsolexpiration__c,IAM_swregexpire__c,
                           IAM_NpbuDiagExpire__c,Account.IAM_WWSPS_Regions__c,Account.Type,
                           Account.IAM_ABO_Code_Formula__c,IAM_Final_Approver__c,Account.IAM_Service_Provider_Code__c,
                           Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,CMI_Contact_Type__c,
                           Account.OwnerId,Account.Location__c,Account.BillingStreet,
                           Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,
                           Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,
                           IAM_Applications__c,IAM_Application_Roles__c,IAM_Legacy_User__c,
                           IAM_Internal__c, IAM_Contact_Status__c
                           FROM Contact WHERE IAM_Partner_User_Record__c = True AND IAM_Contact_Owner__c = Null]){
                               conSetId.add(con.Id);
                               accIdSet.add(con.AccountId);
                               conListPartner.add(con);
                           }
        system.debug('conSetId--->'+conSetId);
        system.debug('conSetId size--->'+conSetId.size());
        system.debug('accIdSet size--->'+accIdSet.size());
        system.debug('conListPartner--->'+conListPartner);
        if(conSetId.size() > 0){
            List<IAM_Contact_Provisioning__c> conProvList = [Select Id, IAM_Contact__c, IAM_User__c, IAM_Role__c,IAM_Application_Name__c
                                                             FROM IAM_Contact_Provisioning__c WHERE IAM_Contact__c IN: conSetId];
            for(IAM_Contact_Provisioning__c conProv : conProvList){
                userIdCusComm.add(conProv.IAM_User__c);
                if(!mapContUserId.containsKey(conProv.IAM_Contact__c)){
                    mapContUserId.put(conProv.IAM_Contact__c, conProv.IAM_User__c);
                }
                if(conProv.IAM_Application_Name__c == 'Guidanz'){
                    if(!mapGuidanzConFeat.containsKey(conProv.IAM_Contact__c)){
                        mapGuidanzConFeat.put(conProv.IAM_Contact__c, conProv);//map of Guidanz record where user is Customer Community User
                    }
                    if(!mapconIdRole.containsKey(conProv.IAM_Contact__c)){
                        mapconIdRole.put(conProv.IAM_Contact__c, conProv.IAM_Role__c);
                    }
                }else{
                    if(!mapOtherConFeat.containsKey(conProv.IAM_Contact__c)){
                        mapOtherConFeat.put(conProv.IAM_Contact__c, new List<IAM_Contact_Provisioning__c>{conProv});
                    }else{
                        mapOtherConFeat.get(conProv.IAM_Contact__c).add(conProv);
                    }
                }
            }
            system.debug('mapContUserId--->'+mapContUserId);
            system.debug('mapGuidanzConFeat--->'+mapGuidanzConFeat);
            system.debug('mapOtherConFeat--->'+mapOtherConFeat);
            system.debug('mapconIdRole--->'+mapconIdRole);
            mapUserIdPsId = fetchExistPSAssignment(userIdCusComm);
			newUserList = createUserForPartnerContact(conListPartner,accIdSet,mapconIdRole);
            if(newUserList.size() > 0){
                for(User recUser : newUserList){
                    if(!mapConIdNewUser.containsKey(recUser.ContactId)){
                        mapConIdNewUser.put(recUser.ContactId, recUser.Id);
                    }
                }
            }
            system.debug('mapConIdNewUser--->'+mapConIdNewUser);
            //assignOldPSNewUser(mapConIdNewUser,mapContUserId, userIdCusComm);
            if(!Test.isRunningTest()){
                //system.debug('inside if bIsActiveContact only---> IAM_GuiCreate_PartnerUser_Queueable class');
                ID jobID = System.enqueueJob(new IAM_GuiAssign_OldPSNewUser_Queueable(mapConIdNewUser,mapContUserId,mapUserIdPsId,mapGuidanzConFeat,mapOtherConFeat));
                System.debug('Printing Secondary JOB ID'+jobID);
            }
        }        
    }
    //this method will return the permission set assignment of old userId
    public static Map<Id, List<String>> fetchExistPSAssignment(Set<Id> userIdCusComm){
        List<PermissionSetAssignment> existingPSAssignmentList = new List<PermissionSetAssignment>();
        Map<Id, List<String>> mapUserIdPsId = new Map<Id, List<String>>();
        existingPSAssignmentList = [SELECT Id, PermissionSetId, AssigneeId FROM PermissionSetAssignment
                                    WHERE AssigneeId IN :userIdCusComm AND PermissionSet.IsOwnedByProfile = False];
        System.debug('#### existingPSAssignmentList - '+existingPSAssignmentList);
        if(existingPSAssignmentList.size() > 0){
            for(PermissionSetAssignment psa : existingPSAssignmentList){
                if(!mapUserIdPsId.containsKey(psa.AssigneeId)){
                    mapUserIdPsId.put(psa.AssigneeId, new List<String>{psa.PermissionSetId});
                }else{
                    mapUserIdPsId.get(psa.AssigneeId).add(psa.PermissionSetId);
                }
            }
        }
        System.debug('#### mapUserIdPsId - '+mapUserIdPsId);
        return mapUserIdPsId;       
    }
    
    public static List<User> createUserForPartnerContact(List<Contact> conListPartner,Set<Id> accIdSet,Map<Id, String> mapconIdRole){
        List<User> userCreateList = new List<User>();
        Set<Id> newUserIdSet = new Set<Id>();
        Map<Id, Id> mapConIdNewUser = new Map<Id, Id>();
        List<IAM_Application__c> accApp=new List<IAM_Application__c>();
        Map<Id,IAM_Application__c> appCumpasMap=new Map<Id,IAM_Application__c>();//MAp to store all the cumpas related records with Account id Key.
        List<User> newUserList = new List<User>();
        Map<Id, String> mapUserIdRole = new Map<Id, String>();
        Map<Id, String> mapUserIdAppRole = new Map<Id, String>();
        Map<Id, String> mapUserIdAppGrp = new Map<Id, String>();
        Map<String,User> usrForIdentity= new Map<String,User>();
        List<User> usrToIdentity=new List<User>();
        try{
            if(!accIdSet.isEmpty()){
                if(Limits.getQueries()<Limits.getLimitQueries()){
                    accApp=[select Id,IAM_Account_Name__c,IAM_Application_Name__c,
                            IAM_Qsolexpiration__c,
                            IAM_License_Type__c,
                            IAM_swregExpire__c,IAM_Cumpas_Modularity__c,
                            IAM_Cumpas_Dist_CS_Rep__c,
                            IAM_Cumpas_Distributor_Sales_Rep__c 
                            from IAM_Application__c where IAM_Account_Name__c=:accIdSet
                            AND IAM_Application_Name__c =: System.Label.IAM_AppName_Cumpas];
                  
                    
                  // Code for Identity Owner-@Suresh
                usrToIdentity=[select id,Contact.Username__c,username from user where contact.Accountid=:accIdSet and contact.CMI_Contact_Type__c='Primary'];
                if(!usrToIdentity.isEmpty()){
                    //then loopin through list to add them to mapping.
                    for(user un1: usrToIdentity){
                        usrForIdentity.put(un1.username,un1);
                    }
                }
                }
                if(!accApp.isEmpty()){
                    for(IAM_Application__c ap:accApp){
                        if(ap.IAM_Application_Name__c==System.Label.IAM_AppName_Cumpas){
                            appCumpasMap.put(ap.IAM_Account_Name__c,ap);  
                        }
                    }
                }
            }
            //Query to fetch Profile Id based on Role and assign to Profile field of user:            
            List<profile> evlProfiles = [select Id,name from profile where name like 'EVL_%'];
            Map<string,Id> evlProfMap = new Map<string,Id>();
            for(profile pf:evlProfiles){
                evlProfMap.put(pf.name,pf.Id);
            }

            //Map for Timezone Local and language.
            map<string,string> timeZone=new map<string,string>();
            Schema.DescribeFieldResult fieldResult = User.TimeZoneSidKey.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
            for( Schema.PicklistEntry f : ple)
            {
                timeZone.put(f.getLabel(), f.getValue());
                //system.debug('f.getLabel()========='+f.getLabel() +'============f.getValue()======'+f.getValue());
                            
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
            //End of Map
            
            for(Contact cont : conListPartner){
                if(mapconIdRole.containsKey(cont.Id) && mapconIdRole.get(cont.Id) != null){
                User u = new user();
                u.FirstName=cont.FirstName;
                u.LastName=cont.LastName;
                u.Email=cont.Email;
                u.UserPermissionsSFContentUser = True;
                if(cont.IAM_Contact_Status__c == 'Reclaim'){
                    String sUser = cont.Username__c.substringBefore('@');
                    u.Username=sUser+'@cmiuser.com';
                }else if(cont.IAM_Contact_Status__c == 'Active' && cont.IAM_Legacy_User__c == True){
                    String sUser = cont.Username__c.substringBefore('@');
                    u.Username=sUser+'@cmiuser.com';
                }else{
                    u.Username=cont.Username__c;
                }                   
                u.IAM_OAM_Federation_ID__c=cont.Username__c;
                u.IAM_UID__c=cont.IAM_Ext_Legacy_Uid__c != null ? cont.IAM_Ext_Legacy_Uid__c : cont.Username__c; 
                u.FederationIdentifier=cont.IAM_Ext_Legacy_Uid__c != null ? cont.IAM_Ext_Legacy_Uid__c : cont.Username__c;
                u.CompanyName=cont.Account.Name;
                u.EmailEncodingKey='UTF-8';
                //u.LocaleSidKey = mapCusCommUser.get(conId).LocaleSidKey;
                u.LocaleSidKey=LocalMap.get(cont.Account.CSS_Locale__c.replace(' (','('));
                if(u.LocaleSidKey==''||u.LocaleSidKey==null){
                    u.LocaleSidKey='en_US';
                }
                //u.LanguageLocaleKey=mapCusCommUser.get(conId).LanguageLocaleKey;
                u.LanguageLocaleKey=LocalLangMap.get(cont.Account.CSS_Language__c);
                if(u.LanguageLocaleKey==''||u.LanguageLocaleKey==null){
                    u.LanguageLocaleKey='en_US';
                }  
                //u.TimeZoneSidKey=mapCusCommUser.get(conId).TimeZoneSidKey;
                u.TimeZoneSidKey=timeZone.get(cont.Account.CSS_Timezone__c);
                if(u.TimeZonesidKey==''||u.TimeZonesidKey==null){
                    u.TimeZoneSidKey='America/New_York';
                }
                u.IAM_Random_Number__c='';
                u.ContactId=cont.Id;
                u.isActive=True;
                if(cont.LastName.length()>=4){
                    u.alias=cont.FirstName.substring(0,1)+''+cont.LastName.substring(0,4);
                }else if(cont.LastName.length()<=2&&cont.FirstName.length()<=2){
                    u.alias=cont.FirstName+''+cont.LastName;
                }
                else{
                    u.alias=cont.FirstName.substring(0,4-cont.LastName.length())+''+cont.LastName;
                }
                u.IAM_is_Member_of__c=(cont.IAM_is_Member_of__c!=null?cont.IAM_is_Member_of__c:'');
                u.IAM_WorkGroup_id__c=(cont.IAM_Work_Group_Id__c!=null?cont.IAM_Work_Group_Id__c:'');
                u.Product_Group_Access__c=(cont.IAM_Product_Group_Access__c!=null?cont.IAM_Product_Group_Access__c:'');
                u.IAM_Account_Number__c = cont.Account.CMI_Account_Num__c;
                u.IAM_Account__c = cont.AccountId;
                u.phone =(cont.Phone!=null?cont.Phone:'');
                //QSOL Expiration.
                u.IAM_Qsolexpiration__c=(cont.IAM_Qsolexpiration__c!=null?cont.IAM_Qsolexpiration__c:'');   
                //Swreg Field
                u.IAM_swregExpire__c=(cont.IAM_swregexpire__c!=null?cont.IAM_swregexpire__c:'');
                /* 12/03/2020 - Added NPBU Diagnostic Expration */
                u.IAM_NpbuDiagExpire__c=(cont.IAM_NpbuDiagExpire__c!=null?cont.IAM_NpbuDiagExpire__c:'');  
                u.IAM_WWSPS_Region__c=(cont.Account.IAM_WWSPS_Regions__c!=null?cont.Account.IAM_WWSPS_Regions__c:'');
                u.IAM_Type_of_Location__c=(cont.Account.Type!=null?cont.Account.Type:'');
                u.IAM_Abocode__c=(cont.Account.IAM_ABO_Code_Formula__c!=null?cont.Account.IAM_ABO_Code_Formula__c:'');
                //u.IAM_Applicationgroups__c=mapCusCommUser.get(conId).IAM_Random_Number__c;
                if(cont.IAM_Applications__c != '' && cont.IAM_Applications__c != null){
                    u.IAM_Applicationgroups__c = cont.IAM_Applications__c;
                }else{
                    u.IAM_Applicationgroups__c = '';
                }
                //u.IAM_Promotion__c=mapCusCommUser.get(conId).IAM_Promotion__c;
                //u.IAM_Application_Roles__c=mapCusCommUser.get(conId).IAM_Application_Roles__c;
                if(cont.IAM_Application_Roles__c != '' && cont.IAM_Application_Roles__c != null){
                    u.IAM_Application_Roles__c = cont.IAM_Application_Roles__c;
                }else{
                    u.IAM_Application_Roles__c = '';
                }
                if(mapconIdRole.get(cont.Id) == 'Advanced'){
                    system.debug('mapconIdRole.get(cont.Id)--->'+mapconIdRole.get(cont.Id));
                    system.debug('Inside advanced role if--->');
                    u.Profileid=evlProfMap.get(System.label.EVL_DealerAdvanced_Gui);
                }else if(mapconIdRole.get(cont.Id) == 'Technician'){
                    u.Profileid=evlProfMap.get(System.label.EVL_DealerTechnician_Gui);                       
                }else if(mapconIdRole.get(cont.Id) == 'Read Only'){              
                    u.Profileid=evlProfMap.get(System.label.EVL_DealerReadonly_Gui);
                }else if(mapconIdRole.get(cont.Id) == 'Technician;Advanced' || mapconIdRole.get(cont.Id) =='Advanced;Technician'){
                    u.Profileid=evlProfMap.get(System.label.EVL_DealerAdvanced_Gui);
                }else{
                    //default Profile to be assigned to complete the process. IF above method does not return any profile ID
                    u.Profileid=[select Id from Profile where name='IAM User'].Id;
                }
                if(portalRoleToAssign(mapconIdRole.get(cont.Id),cont.Account.Type) != null){
                    u.PortalRole=portalRoleToAssign(mapconIdRole.get(cont.Id),cont.Account.Type);
                }
                if(cont.IAM_Final_Approver__c != '' && cont.IAM_Final_Approver__c != null){
                    u.IAM_Final_Approver__c=cont.IAM_Final_Approver__c;
                }else{
                    u.IAM_Final_Approver__c='N';
                }
                if(cont.IAM_Internal__c==True){
                    u.IAM_UserDn__c='uid='+cont.Username__c+',ou=employee,ou=people,dc=cummins,dc=com';
                }else if(cont.IAM_Internal__c==False){
                    u.IAM_UserDn__c='uid='+cont.Username__c+',ou=external,ou=people,dc=cummins,dc=com';   
                }
                if(cont.Account.IAM_Service_Provider_Code__c != '' && cont.Account.IAM_Service_Provider_Code__c != null) {
                    u.IAM_Customercode__c=cont.Account.IAM_Service_Provider_Code__c;
                    if(cont.Account.Type=='Fleet' || cont.Account.Type=='CIHR'){
                        u.IAM_Fleetcode__c=cont.Account.IAM_Service_Provider_Code__c;
                    }                
                    u.IAM_SP_Code__c=cont.Account.IAM_Service_Provider_Code__c;
                }
                if(cont.Account.Type == 'Dealer Account'){
                    u.IAM_Dealercode__c=cont.Account.IAM_Service_Provider_Code__c != null ? cont.Account.IAM_Service_Provider_Code__c : '';
                }
                if((cont.Account.CSS_DBCode__c!=null&&cont.Account.CSS_DBCode__c!='')&&cont.Account.Type=='Distributor Branch Account'){
                    u.IAM_Distributorbranchcode__c=cont.Account.CSS_DBCode__c != null ? cont.Account.CSS_DBCode__c : '';
                }
                if(cont.Account.CSS_DistributorCode__c!=null&&cont.Account.CSS_DistributorCode__c!=''){
                    u.IAM_Distributorcode__c=cont.Account.CSS_DistributorCode__c != null ? cont.Account.CSS_DistributorCode__c : '';
                }
                if(cont.CMI_Contact_Type__c=='Primary'){
                    if(cont.Account.OwnerId!=System.Label.IAM_Cummins_Web_User_ID){
                        u.IAM_Identity_Approver__c=cont.Account.OwnerId; 
                    }                       
                }else if(cont.CMI_Contact_Type__c=='Secondary'){
                    /*if(Limits.getQueries()<Limits.getLimitQueries()) {
                        List<User> usr=[select Id from user where Contact.AccountId=:cont.AccountId and username=:cont.Username__c and Contact.CMI_Contact_Type__c='Primary'];
                        if(!usr.isEmpty()){
                            u.IAM_Identity_Approver__c=usr[0].Id;
                        }
                    }*/
                    if(!usrForIdentity.isEmpty()){
                            if(usrForIdentity.ContainsKey(cont.Username__c)){
                                u.IAM_Identity_Approver__c=usrForIdentity.get(cont.Username__c).id;
                            }
                        }
                }
                if(cont.Account.IAM_Service_Provider_Code__c != '' && cont.Account.IAM_Service_Provider_Code__c != null){
                    u.Work_Group_Name__c=cont.Account.IAM_Service_Provider_Code__c;
                }
                if(cont.Account.Location__c != '' && cont.Account.Location__c != null){
                    u.User_Location__c=cont.Account.Location__c;
                }
                if(cont.IAM_Work_Group_Id__c != '' && cont.IAM_Work_Group_Id__c != null) {
                    u.CSS_User_MultiLocValues__c=cont.IAM_Work_Group_Id__c.replace('|',';');// In this field users should have all Work group ids with ; seperated values.
                }
                u.Street=cont.Account.BillingStreet;
                u.City=cont.Account.BillingCity;
                u.Country=cont.Account.BillingCountry;
                u.postalCode=cont.Account.BillingPostalCode;
                if(appCumpasMap.ContainsKey(cont.AccountId)){
                    if(appCumpasMap.get(cont.AccountId).IAM_Cumpas_Modularity__c!=null && appCumpasMap.get(cont.AccountId).IAM_Cumpas_Modularity__c!=''){
                        u.IAM_Location_Modular_Access__c=appCumpasMap.get(cont.AccountId).IAM_Cumpas_Modularity__c;
                    }
                    if(appCumpasMap.get(cont.AccountId).IAM_Cumpas_Dist_CS_Rep__c!=null ){
                        u.IAM_Cumpas_Distributor_CSRep__c=appCumpasMap.get(cont.AccountId).IAM_Cumpas_Dist_CS_Rep__c;
                    }
                    if(appCumpasMap.get(cont.AccountId).IAM_Cumpas_Distributor_Sales_Rep__c!=null){
                        u.IAM_Cumpas_Distributor_Sales_Rep__c=appCumpasMap.get(cont.AccountId).IAM_Cumpas_Distributor_Sales_Rep__c;
                    }
                }
                userCreateList.add(u);
                system.debug('userCreateList--->'+userCreateList);
                }
            } 
            //List<Database.Error> errorListRec = new List<Database.Error>();
            system.debug('userCreateList size--->'+userCreateList.size());
            List<String> errorListRec = new List<String>();
            if(userCreateList.size() > 0){
                Database.SaveResult[] srList= Database.insert(userCreateList, false);
                for(Integer i = 0; i < srList.size(); i++){
                    if(srList.get(i).isSuccess()){
                      newUserIdSet.add(srList.get(i).Id);                        
                    }else if(!srList.get(i).isSuccess()){
                        for(Database.Error err : srList.get(i).getErrors()) {
                            String sErrorDesc = '';
                            sErrorDesc = err.getStatusCode() + ': ' + err.getMessage();
                            errorListRec.add(sErrorDesc);
                            //System.debug('The following error has occurred.');                    
                            //System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            //System.debug('User fields that affected this error: ' + err.getFields());
                        }
                    }
                }
                if(errorListRec.size() > 0){
                    if(!Test.isRunningTest()){
                        ID jobID = System.enqueueJob(new IAM_Guidanz_writeException_Queueable(mapUserIdRole, mapUserIdAppRole, mapUserIdAppGrp,errorListRec,False));
                        System.debug('Printing Secondary JOB ID'+jobID);
                    }
                }
            }
            if(newUserIdSet.size() > 0){
                newUserList = [Select Id, ContactId, Contact.Username__c, Contact.IAM_Legacy_User__c, 
                                          IAM_Application_Roles__c, IAM_Promotion__c, Contact.IAM_Person_Type__c,
                                          Contact.IAM_Contact_Status__c, Username, Contact.IAM_Contact_Owner__c
                                          FROM User WHERE Id IN : newUserIdSet];
            }
        }catch(exception e){
            System.debug('Printing exception'+e.getMessage());
            System.debug('Printing exception Stack Trace String'+e.getStackTraceString());
            IAM_ErrorHandling.IAMerrorCapture('', '', 
            e.getStackTraceString() + ' : ' + e.getMessage(),
            IAM_GuiCreate_PartnerUser.class.getName());
        }
        return newUserList;        
    }
    
    public static string portalRoleToAssign(String sRole, String sAccType){
        string sPortalRole = '';
        
        if(sAccType!='Distributor Account'||sAccType!='Distributor Branch Account'||sAccType!='Factory'){//for all other types of account types
           if(sRole=='Advanced'){
               //need to set role and  Profile
              sPortalRole='Executive';    
           }else if(sRole=='Technician'){
               //need to set role and Profile for Technician.
               sPortalRole='Worker';
           }else if(sRole == 'Technician;Advanced' || sRole =='Advanced;Technician'){
               sPortalRole='Executive';
           }else{
               sPortalRole='';
           }
        }else{
            sPortalRole='';
        }
       System.debug('Printing Portal Role'+sPortalRole);
        
        return sPortalRole;
    }

}