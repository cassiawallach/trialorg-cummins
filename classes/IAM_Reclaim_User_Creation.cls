/************************************************************
Name:  IAM_Reclaim_User_Creation
Copyright © 2020  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Class for Reclaim Process.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Golakaram       09/02/2020        INITIAL DEVELOPMENT   
1.1 -    Karthik Golakaram       11/09/2020    Made changes to check the profile value is null or not.
1.2      Shubhangi Sardar        12/03/2020    Added NPBU Diagnostic Expration  
1.3 -    Karthik Raj Golakaram   04/15/2021    Added one line to populate IAM_OAM_Federation_ID__c field .  
*****************************************************/

public class IAM_Reclaim_User_Creation {
    //Method to Update contact. and also to identify if tha contact is a guidanz user or not.
    public static String IAM_Reclaim_Contact_Update(List<Contact> objCon,String Username, String email, boolean isDupContUser,String randStr) {
        Boolean isGuidanzUser=false;
        Contact gzCon;
        String returnVariable ='';
        try{

            List<User> userGuidanz= [Select id,username,Contactid,Profile.Name from User where (FederationIdentifier=:objCon[0].Username__c OR IAM_UID__c=:objCon[0].Username__c) and isActive=True];
            System.debug('User record'+userGuidanz);
            if(!userGuidanz.isEmpty()){
                contact GuidanzContact=IAM_Reclaim_Utility.contactAttributes(userGuidanz[0].Contactid);
                isGuidanzUser=True;
             //Update Exsistign User
             updateORCreateUser(objCon[0],isGuidanzUser,userGuidanz[0].Contactid,userGuidanz[0].id,Username,email,isDupContUser,randStr);
            }else{
                //Create a new User
                id guidanzid;
                id guidanzContact;
                updateORCreateUser(objCon[0],isGuidanzUser,guidanzContact,guidanzid,Username,email,isDupContUser,randStr);
            }
            returnVariable='OK';
        }catch(exception e){
                System.debug('Printing exception'+e);
                System.debug('Prinitng Stack Trace String'+e.getStackTraceString());
                //Code write to error Object and Reclaim tracker status.
                returnVariable='Some Unexpected has happened.Please contact System Administrator.';
                String processedData = 'Method - IAM_Reclaim_Contact_Update, Contact Id - '
                + objCon[0].Id + ', New Username User Choose - ' + username;
                IAM_ErrorHandling.IAMerrorCapture(processedData, Label.IAM_Reclaim_Flow, 
                e.getStackTraceString() + ' - ' + e.getMessage(),
                IAM_Reclaim_User_Creation.class.getName());
        }  
        return returnVariable; 
    }


    Public Static String updateORCreateUser(Contact cn,Boolean isGuidanzUser,id guidanzContactId,id gnzUserId,String Username, String email, boolean isDupContUser,String randStr){
        String returnVariable='';
        try{
            map<id,IAM_Application__c> appCumpasMap=new Map<id,IAM_Application__c>();// Map To Store Cumpas app Mappings.
            Map<String,IAM_Application_Groups__c> mapPaidAppGrp = new Map<String,IAM_Application_Groups__c>();
            Map<String,IAM_Application__c>  mapExsitingApp = new Map<String,IAM_Application__c>(); 
            Map<String,IAM_Application__c> mapExtAppPaid=new Map<String,IAM_Application__c>();
            Map<String,Boolean> reclaimTracker = new Map<String,Boolean>();
            String promotionCode='';
            List<IAM_Application__c> accApp=[select id,IAM_Account_Name__c,IAM_Free_Subscription__c,IAM_Application_Name__c,IAM_Role__c,IAM_Qsolexpiration__c,IAM_License_Type__c,IAM_swregExpire__c,IAM_Cumpas_Modularity__c,IAM_Cumpas_Dist_CS_Rep__c,IAM_Cumpas_Distributor_Sales_Rep__c from IAM_Application__c where IAM_Account_Name__c=:cn.Accountid];
            if(!accApp.isEmpty()){
                for(IAM_Application__c ap:accApp){
                    mapExsitingApp.put(ap.IAM_Application_Name__c,ap);
                    if(ap.IAM_Application_Name__c==System.Label.IAM_AppName_Cumpas){
                        appCumpasMap.put(ap.IAM_Account_Name__c,ap);  
                    }
                    if(!ap.IAM_Free_Subscription__c){
                        mapExtAppPaid.put(ap.IAM_Application_Name__c+ap.IAM_Role__c,ap);// this map will store the app and role as a key for identifying paid applications.
                    }
                }
            }
            

            //Map for Timezone Local and language.
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
            //End of Map

            User u;
            if(isGuidanzUser){
                u=new User(id=gnzUserId);
            }else{
                u=new User();
            }

            u.FirstName=cn.FirstName;
            u.LastName=cn.LastName;
            u.email=email;//email from reclaim page;
            u.username=username;//new Username from reclaim page;
            u.IAM_OAM_Federation_ID__c=u.username;// this will be sent to OAM for federation authentication purpose
            /*if(label.css_org=='.cso'){
                u.username=username;//new Username from reclaim page;
            }else{
                u.username=username+Label.css_org;
            }*/
            u.IAM_UID__c=(cn.IAM_Ext_Legacy_Uid__c!=null?cn.IAM_Ext_Legacy_Uid__c:username);
            u.FederationIdentifier=(cn.IAM_Ext_Legacy_Uid__c!=null?cn.IAM_Ext_Legacy_Uid__c:username);
            u.CompanyName=cn.Account.Name;
            u.EmailEncodingKey='UTF-8';
            u.LocaleSidKey=LocalMap.get(cn.Account.CSS_Locale__c.replace(' (','('));
            if(u.LocaleSidKey==''||u.LocaleSidKey==null){
                u.LocaleSidKey='en_US';
            }
            u.LanguageLocaleKey=LocalLangMap.get(cn.Account.CSS_Language__c);
            if(u.LanguageLocaleKey==''||u.LanguageLocaleKey==null){
                u.LanguageLocaleKey='en_US';
            }  
            u.TimeZoneSidKey=timeZone.get(cn.Account.CSS_Timezone__c);
            if(u.TimeZonesidKey==''||u.TimeZonesidKey==null){
            u.TimeZoneSidKey='America/New_York';
            }
            u.IAM_Random_Number__c=RandStr;
            if(isGuidanzUser){
                u.ContactId=guidanzContactId;
            }else{
                u.ContactId =cn.id;
            }
            u.isActive=true;
            if(cn.LastName.length()>=4){
                u.alias=cn.FirstName.substring(0,1)+''+cn.LastName.substring(0,4);
                //u.CommunityNickname=objCon.FirstName.substring(0,1)+''+objCon.LastName.substring(0,4);
            }else if(cn.LastName.length()<=2&&cn.FirstName.length()<=2){
                u.alias=cn.FirstName+''+cn.LastName;
                //u.CommunityNickname=
            }
            else{
                u.alias=cn.FirstName.substring(0,4-cn.LastName.length())+''+cn.LastName;
                //u.CommunityNickname=
            }
            //IAM fields

            u.IAM_is_Member_of__c=(cn.IAM_is_Member_of__c!=null?cn.IAM_is_Member_of__c:'');
            u.IAM_WorkGroup_id__c=(cn.IAM_Work_Group_Id__c!=null?cn.IAM_Work_Group_Id__c:'');
            u.Product_Group_Access__c=(cn.IAM_Product_Group_Access__c!=null?cn.IAM_Product_Group_Access__c:'');
            u.IAM_Account_Number__c = cn.Account.CMI_Account_Num__c;
            u.IAM_Account__c = cn.Accountid;
            u.phone =(cn.phone!=null?cn.Phone:'');
            //QSOL Expiration.
            u.IAM_Qsolexpiration__c=(cn.IAM_Qsolexpiration__c!=null?cn.IAM_Qsolexpiration__c:'');   
            //Swreg Field
            u.IAM_swregExpire__c=(cn.IAM_swregexpire__c!=null?cn.IAM_swregexpire__c:'');
            /* 12/03/2020 - Added NPBU Diagnostic Expration */
            u.IAM_NpbuDiagExpire__c=(cn.IAM_NpbuDiagExpire__c!=null?cn.IAM_NpbuDiagExpire__c:'');  
            u.IAM_WWSPS_Region__c=(cn.Account.IAM_WWSPS_Regions__c!=null?cn.Account.IAM_WWSPS_Regions__c:'');
            u.IAM_Type_of_Location__c=(cn.Account.Type!=null?cn.Account.Type:'');
            u.IAM_Abocode__c=(cn.Account.IAM_ABO_Code_Formula__c!=null?cn.Account.IAM_ABO_Code_Formula__c:'');
            //u.IAM_Applicationgroups__c=(cn.IAM_Applications__c!=null?cn.IAM_Applications__c:'');
            u.IAM_Applicationgroups__c=IAM_Reclaim_Utility.allApplicationGroups(cn);// We need to call Utility class.
            if(IAM_Reclaim_Utility.isCSTUser(cn,Label.IAM_Cummins_Service_Training)){
                promotionCode=IAM_CSTUserOutboundHelper_Reclaim.CstOutboundCall(cn.firstname,cn.lastname,email,cn.Phone,cn.Account.IAM_service_Provider_Code__c,cn.id,cn.Username__c,username);
                System.debug('Printing Promotion Code'+promotionCode);
                if(promotionCode!='error'){
                    u.IAM_Promotion__c=promotionCode;
					reclaimTracker.put('Promotion API',True);
                }
            }
            u.IAM_Application_Roles__c=IAM_Reclaim_Utility.applicationRoles(cn);// We need to call Utility class.
            System.debug('Printing Profile ID to be assigned'+IAM_Reclaim_Utility.profileToBeAssigned(cn));
            if(IAM_Reclaim_Utility.profileToBeAssigned(cn)!=null){
                u.Profileid=IAM_Reclaim_Utility.profileToBeAssigned(cn);
            }else if(IAM_Reclaim_Utility.profileToBeAssigned(cn)==null&&!isGuidanzUser){
                //default Profile to be assigned to complete reclaim process. IF above method does not return any profile ID
                u.Profileid=[select id from Profile where name='IAM User'].id;
            }
            if(IAM_Reclaim_Utility.isCSTUser(cn,Label.IAM_AppName_Guidanz)&&!IAM_Reclaim_Utility.isGuidanzProfile(cn)){
                u.PortalRole=IAM_Reclaim_Utility.roleToBeAssigned(cn);
            }
            if(cn.IAM_Final_Approver__c != '' && cn.IAM_Final_Approver__c != null){
                u.IAM_Final_Approver__c=cn.IAM_Final_Approver__c;
            }else{
                u.IAM_Final_Approver__c='N';
            }
            if(cn.IAM_Internal__c==True){
                u.IAM_UserDn__c='uid='+cn.Username__c+',ou=employee,ou=people,dc=cummins,dc=com';
            }else if(cn.IAM_Internal__c==False){
                u.IAM_UserDn__c='uid='+cn.Username__c+',ou=external,ou=people,dc=cummins,dc=com';   
            }

            if(cn.Account.IAM_Service_Provider_Code__c != '' && cn.Account.IAM_Service_Provider_Code__c != null) {
                u.IAM_Customercode__c=cn.Account.IAM_Service_Provider_Code__c;
                if(cn.Account.Type=='Fleet'||cn.Account.Type=='CIHR'){
                u.IAM_Fleetcode__c=cn.Account.IAM_Service_Provider_Code__c;
                }                
                u.IAM_SP_Code__c=cn.Account.IAM_Service_Provider_Code__c;
            } 
            
            if(cn.Account.Type=='Dealer Account'){
                u.IAM_Dealercode__c=cn.Account.IAM_Service_Provider_Code__c;
            }
            if((cn.Account.CSS_DBCode__c!=null&&cn.Account.CSS_DBCode__c!='')&&cn.Account.Type=='Distributor Branch Account'){
                u.IAM_Distributorbranchcode__c=cn.Account.CSS_DBCode__c;
            }
            if(cn.Account.CSS_DistributorCode__c!=null&&cn.Account.CSS_DistributorCode__c!=''){
                u.IAM_Distributorcode__c=cn.Account.CSS_DistributorCode__c;
            }
                
            if(cn.CMI_Contact_Type__c=='Primary'){
                //since it is a Primary Contact either Distributor Account Owner or Distributor Primary contact should be the Approver.
                if(cn.Account.OwnerId!=System.Label.IAM_Cummins_Web_User_ID)
                    u.IAM_Identity_Approver__c=cn.Account.OwnerId;
                    //u.IAM_Identity_Approver__c=[select id from user where contact.Accountid=:cn.Account.parentid and username=:cn.Username__c and contact.CMI_Contact_Type__c='Primary'].id;//this should basically give the primary contact user id of that parent location
            }else if(cn.CMI_Contact_Type__c=='Secondary'){
                List<User> usr=[select id from user where contact.Accountid=:cn.Accountid and username=:cn.Username__c and contact.CMI_Contact_Type__c='Primary'];
                if(!usr.isEmpty()){
                    u.IAM_Identity_Approver__c=usr[0].id;
                }
                //u.IAM_Identity_Approver__c=[select id from user where contact.Accountid=:cn.Accountid and username=:cn.Username__c and contact.CMI_Contact_Type__c='Primary'].id;//this should basically give the primary contact user id of that current location 
            } //commented 
                
            
            //end of IAM fields
                
            //Assaigning Guidanz fields on user creation.these can be there for each user and the same fields needs to be update on user record when a user is assaigned a record
            if(cn.Account.IAM_Service_Provider_Code__c != '' && cn.Account.IAM_Service_Provider_Code__c != null)
                u.Work_Group_Name__c=cn.Account.IAM_Service_Provider_Code__c; //basically cutomer code of the Account
            if(cn.Account.Location__c != '' && cn.Account.Location__c != null)  
                u.User_Location__c=cn.Account.Location__c;  //feild on Account Location__C
            u.UserGroup__c='EDS_USER';  //CAn be hard coded to EDS User
            if(cn.IAM_Work_Group_Id__c != '' && cn.IAM_Work_Group_Id__c != null) {
                u.CSS_User_MultiLocValues__c=cn.IAM_Work_Group_Id__c.replace('|',';');// In this field users should have all Work group ids with ; seperated values.
                //End of Guidanz Fields
            } 
            
            //Address fields need to be populated on the user record from Account
            u.Street=cn.Account.BillingStreet;
            u.City=cn.Account.BillingCity;
            u.Country=cn.Account.BillingCountry;
            u.postalCode=cn.Account.BillingPostalCode;
            
            //DBU related fields
            if(cn.Account.IAM_Movex_Customer_Code__c!=null && cn.Account.IAM_Movex_Customer_Code__c!=''){
                u.IAM_Movex_Customer_Code__c=cn.Account.IAM_Movex_Customer_Code__c;
            }
            if(appCumpasMap.ContainsKey(cn.Accountid)){
                if(appCumpasMap.get(cn.Accountid).IAM_Cumpas_Modularity__c!=null && appCumpasMap.get(cn.Accountid).IAM_Cumpas_Modularity__c!=''){
                    u.IAM_Location_Modular_Access__c=appCumpasMap.get(cn.Accountid).IAM_Cumpas_Modularity__c;
                }
                if(appCumpasMap.get(cn.Accountid).IAM_Cumpas_Dist_CS_Rep__c!=null && appCumpasMap.get(cn.Accountid).IAM_Cumpas_Dist_CS_Rep__c!=''){
                    u.IAM_Cumpas_Distributor_CSRep__c=appCumpasMap.get(cn.Accountid).IAM_Cumpas_Dist_CS_Rep__c;
                }
                if(appCumpasMap.get(cn.Accountid).IAM_Cumpas_Distributor_Sales_Rep__c!=null && appCumpasMap.get(cn.Accountid).IAM_Cumpas_Distributor_Sales_Rep__c!=null){
                    u.IAM_Cumpas_Distributor_Sales_Rep__c=appCumpasMap.get(cn.Accountid).IAM_Cumpas_Distributor_Sales_Rep__c;
                }
            }

            //depending upon the guidanz usr flag we will insert or Update user and the do set password accordingly.
            if(isGuidanzUser){
                Update u;
                reclaimTracker.put('Is_Guidanz_User_Update',True);
            }else{
                insert u;
                reclaimTracker.put('Is_Create_User',True);  
            }
            
            //since password reset is common we will do for all the users.
            setPassword(u.id);

            List<IAM_Application_Groups__c> lstAppGroups = IAM_Application_Groups__c.getall().values();//getting all the custom settings
            for(IAM_Application_Groups__c appGrp : lstAppGroups){
                mapPaidAppGrp.put(appGrp.IAM_Application_Name__c, appGrp);
            }
            //Create/Assign Permission sets for the User that just reclaimed.
            /*Map<String,String> allAppsAndRoles = IAM_Reclaim_Utility.allAppsAndRoles(cn);
            if(!allAppsAndRoles.isEmpty()){
                //Set<String> applicationNames= allAppsAndRoles.keySet();
                Set<String> applicationNames= new Set<String>();
                for(String a:allAppsAndRoles.keySet()){
                    if(a.ContainsIgnoreCase('Guidanz Mobile')){
                        applicationNames.add('Guidanz Mobile');
                    }else if(a.ContainsIgnoreCase('QuickServe Online')){
                        applicationNames.add('QuickServe Online');
                    }else{
                        applicationNames.add(a);
                    }
                }
                if(!applicationNames.isEmpty()){
                    Map<String,id> pids=new Map<string,id>();//Store app name as key and corresponding permission set id as Key.to call future method.
                    //Code for Permission set assignment.
                    List<PermissionSet>pSet=[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Label=:applicationNames];
                    System.debug('Printing permision set id'+pSet);
                    if(!pSet.isEmpty()){
                        for(PermissionSet p:pSet){
                            pids.put(p.Label,p.Id);
                        } 
                        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
                        for(String sn : applicationNames){
                            if(pids.ContainsKey(sn)&&pids.get(sn)!=null){
                                System.debug('Printing application Name'+sn+'Printing Permission set id'+pids.get(sn));
                                PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = pids.get(sn), AssigneeId = u.Id);
                                //fix - defect - D-2767 - add a  permission set if account provisioning record is exist for paid application, for free application add permission set based on appliction group on contact.
                                if(mapExsitingApp.containsKey(sn) && !mapPaidAppGrp.get(sn).IAM_Free_application__c || mapPaidAppGrp.get(sn).IAM_Free_application__c)
                                {
                                    permissionSetList.add(psa);
                                } 
                            }
                        }
                        if(!permissionSetList.isEmpty()){ 
                        //insert permissionSetList;changed to data base insert method to avoid if duplicate permission sets are present.
                        Database.SaveResult[] sr= Database.insert(permissionSetList,false);
                        System.debug('Printing Permission set result'+sr);
                        reclaimTracker.put('Is_Assign_Permission_Set',True);
                        }  
                    }
                }
            }*/
            if(isGuidanzUser){
                reclaimTracker.put('Is_Guidanz_User_Update',true);
            }
            ID jobID = System.enqueueJob(new IAM_Reclaim_Contact_Update_Queueable(u,guidanzContactId,cn,Username,email,isGuidanzUser,reclaimTracker,isDupContUser));
            System.debug('Printing Secondary JOB ID'+jobID);
            returnVariable='Ok';
        }catch(Exception e){
            System.debug('Printing Exception '+e);
            System.debug('Printing Exception Stack Trace string'+e.getStackTraceString());
            returnVariable='Something went wrong.Please contact System administrator';
            
            String processedData = 'Method - updateORCreateUser, Contact Id - '
            + cn.Id + ', New Username User Choose - ' + username;
            IAM_ErrorHandling.IAMerrorCapture(processedData, Label.IAM_Reclaim_Flow, 
            e.getStackTraceString() + ' - ' + e.getMessage(),
            IAM_Reclaim_User_Creation.class.getName());
        }   
        return returnvariable;
    } 

    @future
    Private Static void setPassword(id userId){
       System.resetPasswordWithEmailTemplate(userId,true,'IAM_SetPassword_Reclaim_Flow');
    }
}