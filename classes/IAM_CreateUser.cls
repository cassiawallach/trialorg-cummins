/************************************************************
Name:  IAM_CreateUser
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_CreateUser class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Keerthy GuruMurthy      23/04/2018        INITIAL DEVELOPMENT  
1.1 -    Nishant Verma           11/13/2020         MAde changes for fluid Watch.
1.2 -    Chetan Gaikwad          09/12/2020        OSMchanges for PC user
1.3 -    Karthik Raj Golakaram   01/18/2021        MAde Cahnges for Shop Cummins Online Store
1.4 -    Karthik Raj Golakaram    03/25/2021        Made Changes for OSM Bulk User API.
1.5 -    Karthik Raj Golakaram   04/15/2021     Added one line of Code to populate IAM_OAM_Federation_ID__c feid. 
1.6 -    Chetan Gaikwad          04/29/2021        Mae changes for site amdin portal
1.7 -    Suresh Rathod           25/03/2022        Updated New logic for NickName to avoid duplicates
1.8 -    Chetan Gaikwad          26/07/2022        SOQL query optimization
*****************************************************/


/********************************************************************************
***********************************************************************************/
Public without sharing class IAM_CreateUser Implements Queueable{ 
    public static  string Bmsinstance;
    Public static string Customernumber;
    Public static string ProfileID; 
    Public List<Contact> userToCreateConList;
    Public Map<id,id> surviourToVictimConIdMap;

    Public IAM_CreateUser(List<Contact> userToCreateConList){
        this.userToCreateConList=userToCreateConList;
    }

    Public void execute(QueueableContext context){
        String returnValue=CreateUser(userToCreateConList);
        System.debug('Printing the return value from Create user class'+returnValue);
    }

    Public Static String CreateUser(List<Contact> objConlist){
        //this query is to know which Business user got logged innto application.So that the user creation process can be customized.
        String returnValue='';
        String osmStoreFront=System.LAbel.IAM_OSM_ContPro_Default_Roles;
        List<User> userToInsert =new List<User>();
        map<id,user> conUserMap=new Map<id,User>();//map to store users that are already Present and are active
        map<id,Contact> conMap=new MAp<id,Contact>();//Map to store Contacts that do not have any users
        map<id,User> conUserIncMap=new Map<id,User>();//Map to store User which are inactive             
        set<id> conids=new Set<id>();//ids to store the contact ids
        set<id> accids=new set<id>();//set to store Account ids;
        Map<id,IAM_Contact_Provisioning__c> mapConProv= new Map<id,IAM_Contact_Provisioning__c>();//map to store contacct provisioning for a particular contact.
        List<IAM_Application__c> accApp=new List<IAM_Application__c>();//List for getting all the Account Access feature for all Account ids Associated with Contacts
        map<id,IAM_Application__c> appCumpasMap=new Map<id,IAM_Application__c>();//MAp to store all the cumpas related records with Account id Key.    
        map<id,IAM_Application__c> appqsolMap=new Map<id,IAM_Application__c>();//MAp to store all the QSOL related records with Account id Key.       
        map<id,IAM_Application__c> appguidanmobilezMap=new Map<id,IAM_Application__c>();//MAp to store all the Guidanzrelated records with Account id Key. 
        map<id,List<IAM_Contact_Provisioning__c>> mapConAppQSOL=new map<id,List<IAM_Contact_Provisioning__c>>();//Map to store a list of QSOL contact access features with contact id a Key.
        map<id,List<IAM_Contact_Provisioning__c>> mapConAppGM= new map<id,List<IAM_Contact_Provisioning__c>>();// Map to store a list of Guidanz Mobile App of Contact Access features and contact id as Key.
        map<id,IAM_Contact_Provisioning__c> mapRSW=new map<id,IAM_Contact_Provisioning__c>();//map to store Rsw Record.
        Map<Id,IAM_Contact_Provisioning__c> mapShopOnline= new Map<id,IAM_Contact_Provisioning__c>(); //Map To Store Shop Online Records. -----Added By Karthik 01/18/2021
        List<User> usrToIdentity=new List<User>();
        Map<String,User> usrForIdentity= new Map<String,User>();
        map<id,string> OSMmapofConIdandroles = new map<id,string>();  //Nishant D-3249/3250 Code is for OSM user creation 
        String osmRole;  //Nishant D-3249/3250 Code is for OSM user creation 
        Map<String,boolean> mapOfInternalUsr = new Map<String,boolean>();
        List<String> lstNickName= new List<String>();
        Boolean externaluser;

        //Added By Karthik 01/18/2021
        Map<String,Profile> profileIds=new Map<String,Profile>();
        List<Profile> allProfiles=[Select id,Name From Profile LIMIT 100];
        for(Profile ps:allProfiles){
           ProfileIds.put(ps.Name,ps);
        }
        System.debug('Printing all profiles'+ProfileIds);

        List<IAM_Application_Groups__c> lstAppGroup = IAM_Application_Groups__c.getall().values();//getting all the custom settings.
        Map<String, IAM_Application_Groups__c> mapApplicationGroups = new Map<String, IAM_Application_Groups__c>();//mapp to store application groups that we have from Custom settings
        for(IAM_Application_Groups__c appGrp : lstAppGroup){
        
            mapApplicationGroups.put(appGrp.IAM_Application_Name__c+appGrp.IAM_Role_Name__c, appGrp);
        }
        //End of Addition By Karthik 01/18/2021

        //maps for local,language and time zones
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
        
        
        try{
            //SOQL query code optimization - Chetan Gaikwad
            profile pSiteAdmin;
            profile pSiteUser;
            profile distAdminUser;
            profile adminUser;
            
            List<Profile> adminProfileList = [select id, Name from Profile where name IN('IAM_Site_Admin_Community','IAM User','IAM_Distributor_Admin_Platform','IAM_Admin_User')];
            for(Profile p:adminProfileList){
                if(p.Name == 'IAM_Site_Admin_Community'){
                    pSiteAdmin = p;
                }
                if(p.Name == 'IAM User'){
                    pSiteUser = p;
                }
                if(p.Name == 'IAM_Distributor_Admin_Platform'){
                    distAdminUser = p;
                }
                if(p.Name == 'IAM_Admin_User'){
                    adminUser = p;
                }
            }
            //SOQL query code optimization - Chetan Gaikwad
            
            for(contact c:objConlist){
                conids.add(c.id);
                accids.add(c.Accountid);
            }
            // This query itrrates in the below logic previously it is coming from calling class -- changes by chetan gaikwad 09/12/2020-------
            List<Contact> objCon = [select id,firstname,lastname,email,phone,IAM_AppId__c,Account.OwnerId,Account.CMI_Account_Num__c,IAM_Internal__c,Accountid,Account.Name,CMI_Contact_Type__c,Account.Type,
                        Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c,
                        Account.CSS_DBCode__c,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,
                        IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,
                        Account.BillingState,MailingState,Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.IAM_Movex_Customer_Code__c,
                        Account.IAM_WWSPS_Regions__c,IAM_contact_check__c,IAM_Contact_status__c,IAM_swregexpire__c,IAM_Legacy_User__c,IAM_Site_Admin__c,Language_Preferences__c,Recordtype.name
                        from Contact WHERE Id IN :conids];
                        // This query itrrates in the below logic previously it is coming from calling class -- changes by chetan gaikwad 09/12/2020-------
            if(!accids.isEmpty()){
                usrToIdentity=[select id,Contact.Username__c,username from user where contact.Accountid=:accids and contact.CMI_Contact_Type__c='Primary'];
                if(!usrToIdentity.isEmpty()){
                    //then loopin through list to add them to mapping.
                    for(user un1: usrToIdentity){
                        usrForIdentity.put(un1.username,un1);
                    }
                }
            }
            System.debug('Printing identity approvers'+usrForIdentity);
            
            //getting all the Account access features into list and add them to map
            if(!accids.isEmpty()){
                if(Limits.getQueries()<Limits.getLimitQueries()){
                accApp=[select id,IAM_Account_Name__c,IAM_Application_Name__c,
                        IAM_Qsolexpiration__c,
                        IAM_License_Type__c,
                        IAM_swregExpire__c,IAM_Cumpas_Modularity__c,
                        IAM_Cumpas_Dist_CS_Rep__c,
                        IAM_Cumpas_Distributor_Sales_Rep__c 
                        from IAM_Application__c where IAM_Account_Name__c=:accids];
                }
                if(!accApp.isEmpty()){
                    for(IAM_Application__c ap:accApp){
                        if(ap.IAM_Application_Name__c==System.Label.IAM_AppName_Cumpas){
                            appCumpasMap.put(ap.IAM_Account_Name__c,ap);  
                        }
                        if(ap.IAM_Application_Name__c==System.Label.IAM_AppName_QSOL){
                            appqsolMap.put(ap.IAM_Account_Name__c,ap);  
                        }
                        if(ap.IAM_Application_Name__c==System.Label.IAM_AppName_guidanzmobile){
                            appguidanmobilezMap.put(ap.IAM_Account_Name__c,ap);  
                        }
                    }
                }
            }
            
            if(!conids.isEmpty()){
                
                List<IAM_Contact_Provisioning__c> conProv=new List<IAM_Contact_Provisioning__c>();
                
                if(Limits.getQueries()<Limits.getLimitQueries()){
                    conProv=[select id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c,IAM_Contact__c,IAM_Qsolexpiration__c,IAM_swregExpire__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:conids and IAM_Status__c='Active'];
                }
                System.debug('Printing conProvisionings'+conProv);
                if(!conProv.isEmpty()){
                    
                    for(Contact con:objCon){//looping through all the contacts to check if there are any contact provisionings associated to the user
                        
                        List<IAM_Contact_Provisioning__c> AppQSOL= new List<IAM_Contact_Provisioning__c>();//this list will store all contact provisionings for a single Contact.
                        List<IAM_Contact_Provisioning__c> AppGM= new List<IAM_Contact_Provisioning__c>();//List to Sotr Guidanz Mobile applications.
                        
                        for(IAM_Contact_Provisioning__c conP:conProv){//looping through conprov to map all the conProvisionings.
                            if(con.id==conP.IAM_Contact__c){
                                if(conP.IAM_Application_Name__c==System.Label.IAM_OSM_App_Name){   //Nishant D-3249/3250 Code is for OSM user creation 
                                    OSMmapofConIdandroles.put(conP.IAM_Contact__c, conP.IAM_Role__c);
                                    osmRole= conP.IAM_Role__c;
                                }
                                if(conP.IAM_Application_Name__c==System.Label.IAM_AppName_Guidanz){
                                    mapConProv.put(con.id,conP);//Adding applicaiton to the value and contacct id as Key.
                                }
                                //adding condition to add list of records of QSOL
                                if(conP.IAM_Application_Name__c==System.Label.IAM_AppName_QSOL){
                                    AppQSOL.add(conP);
                                }
                                //End of addition
                                
                                //adding Guidanz Mobile contact provisionings into a list
                                if(conP.IAM_Application_Name__c==System.Label.IAM_AppName_guidanzmobile){
                                    AppGM.add(conP);
                                }
                                //End of addition 
                                
                                //code Addition by Karthik - 01-18-2021
                                if(conP.IAM_Application_Name__c==System.Label.IAM_AppName_Shop_Online){
                                    mapShopOnline.put(conP.IAM_Contact__c,conP);
                                }
                                //end of Code Addition- 01-18-2021
                            }
                        }
                        
                        //Adding list ot map after looping through all the contact access and features.
                        if(!AppQSOL.isEmpty()){
                            if(!mapConAppQSOL.ContainsKey(con.id)){
                                mapConAppQSOL.put(con.id,AppQSOL);
                            }
                        }
                        if(!AppGM.isEmpty()){
                            if(!mapConAppGM.ContainsKey(con.id)){
                                mapConAppGM.put(con.id,AppGM);
                            }   
                        }
                    }
                    
                    System.debug('Printing contact provisioning map of QSOL which are active'+mapConAppQSOL);
                    System.debug('Printing contact provisioning map of QSOL which are active'+mapConAppGM);
                    System.debug('Printing contact and OSM role assign in contact provisioning'+OSMmapofConIdandroles);
                }
                
                
                System.debug('Printing all map values in the map ConProv'+mapConProv);
                //End of looping through and checking if guidanz is Present
                
                List <User> usr= new List<User>();
                if(Limits.getQueries()<Limits.getLimitQueries()){
                    usr=[select id,username,isActive,Contactid from user where Contactid=:conids];
                    System.debug('Printing all the users in the list'+usr);
                } 
                //Above one gives list of users who has users for the particular contact id
                //Now loopin through all the users to differentiate which contact has user and which do not have 
                
                System.debug('Printing contact to be insert'+objCon);
                
                for(contact c:objCon){
                    if(!usr.isEmpty()){
                        for(user ur:usr){
                            if(ur.Contactid==c.id&&ur.isActive==True){
                                conUserMap.put(c.id,ur);
                            }else if(ur.Contactid==c.id&&ur.isActive!=True){
                                conUserIncMap.put(c.id,ur);
                            }else{
                                conMap.put(c.id,c);
                            }
                        }  
                    } 
                    conMap.put(c.id,c);
                    
                }
                
            }
            
            //Printing all the maps respectiviley
            
            System.debug('Printng user and contact map with user Active and who needs only update'+conUserMap);
            System.debug('Printng user and contact map with user is inActive and who needs only update an isactive true'+conUserIncMap);
            System.debug('Printng user and contact map with no user Active and who needs creation of a user'+conMap);
            
            if(!conUserMap.isEmpty()){
                System.debug('Printing users who needs just update of the User records'+conUserMap);
                set<id> cUpdateIds= new Set<id>();
                for(User cnn:conUserMap.Values()){
                    cUpdateIds.add(cnn.Contactid);
                }
                if(!cUpdateIds.isEmpty()){
                    System.debug('calling Update Function');
                    Map<id,String> wwids=new Map<id,String>();
                    // IAM_contactHelperClass.updateUserdetails(cUpdateIds,false,wwids);
                }
            }
            
            //Below whole logic is for insertion of User
            if(!conMAp.isEmpty()){
                
                for(Contact cn:conMAp.Values()){
                    
                    User u=new User();
                    IAM_Contact_Provisioning__c appGuidanz;
                    Profile pCSS=new Profile(); 
                    id roleCSS;
                    String portalRole='';
                    
                    
                    //getting all the CSS profiles and putting them in a map.
                    if(!mapConProv.isEmpty()){
                        System.debug('Printng mapConprov not empty');
                        if(mapConProv.containsKey(cn.id)){//checking if contact has any Guidanz applications in it
                            System.debug('Printng mapConprovContains Key'); 
                            List<profile> cssprofiles= new List<Profile>();
                            if(Limits.getQueries()<Limits.getLimitQueries()){
                                cssprofiles = [select id,name from profile where name like 'CSS_%'];
                            }
                            Map<string,id> cssprofmap = new Map<string,id>();
                            for(profile pf:cssprofiles){
                                cssprofmap.put(pf.name,pf.id);
                            } 
                            appGuidanz=mapConProv.get(cn.id);
                            system.debug('cn.Account.Type@@@@'+cn.Account.Type);
                            if((cn.Account.Type!='Distributor Account'||cn.Account.Type!='Distributor Branch Account'||cn.Account.Type!='Factory')&&!cn.IAM_Internal__c){//for all other types of account types
                                if(appGuidanz.IAM_Role__c=='Advanced'){
                                    //need to set role and Profile
                                    portalRole='Executive';
                                    pCSS.id=cssprofmap.get(System.label.dealer_advanced); 
                                    
                                }else if(appGuidanz.IAM_Role__c=='Technician'){
                                    //need to set role and Profile for Technician.
                                    portalRole='Worker';
                                    pCSS.id=cssprofmap.get(System.label.dealer_technician);
                                }
                                //Adding changes for the profile addition if both roles are present
                                else if(appGuidanz.IAM_Role__c.Contains('Advanced')){
                                    portalRole='Executive';
                                  pCSS.id=cssprofmap.get(System.label.dealer_advanced);  
                              }
                            }
                            
                        } 
                    }
                    
                    System.debug('Printing role and Profile that are going to get assaigned='+'portlaRole=='+portalRole+'pCSS.id=='+pCSS.id+'userRole===='+roleCSS);
                    //looping through all the contacts and contact provisioning 
                    
                    u.firstName=cn.FirstName;
                    u.LastName=cn.LastName;
                    u.email=cn.email;
                    u.CompanyName=cn.Account.Name;
                    u.CMI_Customer_List__c = cn.Account.CMI_Account_Num__c;
                    // u.EmailEncodingKey=cn.Account.CSS_EmailEncoding__c; // restricted picklist value
                    u.EmailEncodingKey='UTF-8';
                    u.LocaleSidKey=LocalMap.get(cn.Account.CSS_Locale__c);
                    if(String.isBlank(u.LocaleSidKey)) {
                        u.LocaleSidKey='en_US';
                    }
                    u.LanguageLocaleKey=LocalLangMap.get(cn.Account.CSS_Language__c);
                    if(String.isBlank(u.LanguageLocaleKey)) {
                        u.LanguageLocaleKey='en_US';
                    }

                    /* Guidanz Service Portal - Change Language Preference */
                    if(cn.Language_Preferences__c=='English'){
                        u.LanguageLocaleKey='en_US';
                    }else if(cn.Language_Preferences__c=='French Canadian'){
                        u.LanguageLocaleKey='fr_CA';
                    } else if(cn.Language_Preferences__c=='French') {
                        u.LanguageLocaleKey='fr';
                    } else if(cn.Language_Preferences__c=='Spanish') {
                        u.LanguageLocaleKey='es';
                    } else if(cn.Language_Preferences__c=='German') {
                        u.LanguageLocaleKey='de';
                    } else if(cn.Language_Preferences__c=='Turkish') {
                        u.LanguageLocaleKey='tr';
                    } else {
                        u.LanguageLocaleKey='en_US';
                    }

                    u.TimeZoneSidKey=timeZone.get(cn.Account.CSS_Timezone__c);
                    System.debug('timezone from account .... '+ timeZone.get(cn.Account.CSS_Timezone__c));
                    if(String.isBlank(u.TimeZoneSidKey)){
                        u.TimeZoneSidKey='America/New_York';
                    }
                    
                    //Profile Assaignment begin.
                    //Below assaigned profile is common profile for all external users and on insertion of user Proper permission sets need to be added.
                    //if contact has access to guidanz profile irrespective of contact type we need to assign guidanz profile and Role to the user.
                    if(mapConProv.containsKey(cn.id) && !cn.IAM_Internal__c){
                        System.debug('This specifies that the contact has access to guidanz applicaiton and he needs to get'+pCSS.id);
                        u.Profileid=pCSS.id;
                        
                        if((cn.Account.Type!='Distributor Account'||cn.Account.Type!='Distributor Branch Account'||cn.Account.Type!='Factory')&&!cn.IAM_Internal__c){//for all other types of account types
                            u.PortalRole =portalRole;
                            System.debug('Printing portal user role'+portalRole);
                        }
                    }else{
                        //System.debug('Printing System Admin and site admin value'+cn.IAM_Site_Admin__c+' Site Admin value'+cn.IAM_Site_Admin_Role__c);
                        if(cn.CMI_Contact_Type__c=='Primary'){
                            //Nishant D-3249/3250 Code is for OSM user creation  
                            if(!OSMmapofConIdandroles.isEmpty() && OSMmapofConIdandroles.containsKey(cn.id)){
                                List<String> assignedroles=OSMmapofConIdandroles.get(cn.id).split(';');
                                System.debug('assignedroles@@@@'+assignedroles);
                                if(assignedroles.contains('Distributor Admin')){
                                    System.debug('Came in distributor admin');
                                    u.Profileid=distAdminUser.id;
                                }
                                else if(assignedroles.contains(osmStoreFront)){
                                    System.debug('Came in Site admin');
                                    u.Profileid=pSiteAdmin.id;
                                }
                                else if(assignedroles.contains('OSM Sales Admin')||assignedroles.contains('OSM Sales User')||assignedroles.contains('OSM Support Admin')||assignedroles.contains('OSM Business Admin')){
                                    System.debug('Came in  admin user');
                                    u.Profileid=adminUser.id;
                                }
                                
                            }else{
                                u.Profileid=pSiteAdmin.id;
                            }
                        }else if(cn.CMI_Contact_Type__c=='Secondary' && !OSMmapofConIdandroles.isEmpty() && OSMmapofConIdandroles.containsKey(cn.id)){
                        System.debug('came secondary and site admin is true');
                        //Nishant D-3249/3250 Code is for OSM user creation 
                   
                            List<String> assignedroles=OSMmapofConIdandroles.get(cn.id).split(';');
                            System.debug('assignedroles@@@@'+assignedroles);
                            if(assignedroles.contains('Distributor Admin')){
                                System.debug('Came in distributor admin');
                                u.Profileid=distAdminUser.id;
                            }
                            else if(assignedroles.contains(osmStoreFront)){
                                System.debug('Came in Site admin');
                                u.Profileid=pSiteAdmin.id;
                            }
                            else if(assignedroles.contains('OSM Sales Admin')||assignedroles.contains('OSM Sales User')||assignedroles.contains('OSM Support Admin')||assignedroles.contains('OSM Business Admin')){
                                System.debug('Came in  admin user');
                                u.Profileid=adminUser.id;
                            }
                
                    }else if(!mapShopOnline.isEmpty()){
                        // Profile Need to be assigned is DBU_IAM_Site_Admin_Community.
                        System.debug('Printing Profile Assignment after shopOnline');
                        if(mapShopOnline.ContainsKey(cn.id)){
                            System.debug('Printing Profile Assignment after shopOnline'+profileIds.get(mapApplicationGroups.get(mapShopOnline.get(cn.id).IAM_Application_Name__c+mapShopOnline.get(cn.id).IAM_Role__c).IAM_Profile_Name_To_Be_Assigned__c).id);  
                            u.Profileid=profileIds.get(mapApplicationGroups.get(mapShopOnline.get(cn.id).IAM_Application_Name__c+mapShopOnline.get(cn.id).IAM_Role__c).IAM_Profile_Name_To_Be_Assigned__c).id;    
                        }
                    }else if(cn.CMI_Contact_Type__c=='Secondary' && cn.IAM_Site_Admin__c==false){
                            u.Profileid=pSiteUser.id;
                        }
                        //code start - for siteadmin profile assignment for secondary site admin - Chetan G 23/04
                        else if(cn.CMI_Contact_Type__c=='Secondary' && cn.IAM_Site_Admin__c==true){
                            u.profileid=pSiteAdmin.id;
                        }
                        //code end - for siteadmin profile assignment for secondary site admin - Chetan G 23/04
                    }
                    //End of Profile Assignment. 
                    
                    /* if(system.label.css_org!='.cso')  {
u.Username=cn.Username__c+System.label.css_org; //commented due to not syncing user name and Username__c
u.IAM_UID__c=cn.Username__c+System.label.css_org;
}
else{
//u.Username=cn.Username__c; //commented 
u.IAM_UID__c=cn.Username__c;
}*/
                    
                    //Commenting the above lines to check make sure we are in code sync wit UAT and not appending sandbox name.-Karthik G
                    if(((Cn.IAM_Internal__C && cn.IAM_Legacy_User__c)||cn.IAM_Legacy_User__c)||cn.RecordType.Name=='Product_Connectivity'){
                        if(!cn.IAM_Legacy_User__c){
                            u.Username=cn.Username__c+'@cummins.com.cso';
                        }else if(!Cn.IAM_Internal__C && cn.IAM_Legacy_User__c){
                            u.Username=cn.Username__c+'@cmiuser.com';
                        }else{
                            u.Username=cn.Username__c;
                        }
                        mapOfInternalUsr.put(u.Username,true); 
                    }else{
                        u.Username=cn.Username__c; //added for syncing user name and Username__c
                        mapOfInternalUsr.put(u.Username,false);
                    }
                    system.debug('mapOfInternalUsr@@@@'+mapOfInternalUsr);
                    u.IAM_UID__c=cn.Username__c;
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
                    //Changes for Guidanz Nickname
                    
                    //fix - defect - D-2824 
                    //String NickName=NickName(cn.id);
                    u.IAM_OAM_Federation_ID__c=u.Username;
                    String NickName=NickName(cn);
                    System.debug('setting NickName ....  ' + NickName);
                    System.debug('list' + lstNickName);
                    System.debug('list' + lstNickName.size());
                    while(lstNickName.contains(NickName))
                    {
                        NickName= NickName(cn);
                        System.debug('inside duplicate nickname'+NickName);
                    }
                    System.debug('after setting final NickName ....  ' + NickName);
                    if(!String.isEmpty(NickName)){
                        u.CommunityNickName=NickName;
                        lstNickName.add(NickName);
                    }
                    
                    //needs to update user record with all the application specified required values
                    if(!cn.IAM_Internal__c){
                        u.ContactId =cn.id;
                    }
                    u.isActive=true;
                    //-------start------- HighRadius Changes Nishant Verma 18/08/2020----------------------------
                    if(Bmsinstance != null && Customernumber != null ){
                        u.IAM_HR_BMS_Instance_Name__c = Bmsinstance;
                        u.IAM_HR_Customer_Number__c = Customernumber;
                        if(cn.Language_Preferences__c=='English'){
                            u.IAM_HR_Language__c='en_US';
                        }else if(cn.Language_Preferences__c=='Canadian French'){
                            u.IAM_HR_Language__c='fr_CA';
                        } 
                    }
                    //-------END------- HighRadius Changes Nishant Verma 18/08/2020----------------------------
                    
                    //IAM fields
                    if(cn.IAM_Final_Approver__c != '' && cn.IAM_Final_Approver__c != null)
                        u.IAM_Final_Approver__c=cn.IAM_Final_Approver__c;
                    if(cn.Account.IAM_ABO_Code_Formula__c!= '' && cn.Account.IAM_ABO_Code_Formula__c != null)
                        u.IAM_Abocode__c=cn.Account.IAM_ABO_Code_Formula__c;
                    if(cn.IAM_Applications__c != '' && cn.IAM_Applications__c != null) 
                        u.IAM_Applicationgroups__c=cn.IAM_Applications__c;
                    
                    
                    //Population of Code at user level 
                    if(cn.Account.IAM_Service_Provider_Code__c != '' && cn.Account.IAM_Service_Provider_Code__c != null) {
                        u.IAM_Customercode__c=cn.Account.IAM_Service_Provider_Code__c;
                        if(cn.Account.Type=='Fleet'||cn.Account.Type=='CIHR'){
                            u.IAM_Fleetcode__c=cn.Account.IAM_Service_Provider_Code__c;
                            u.Fleet_Code__c=cn.Account.IAM_Service_Provider_Code__c;
                        }                
                        u.IAM_SP_Code__c=cn.Account.IAM_Service_Provider_Code__c;
                    } 
                    
                    if(cn.Account.Type=='Dealer Account'){
                        u.IAM_Dealercode__c=cn.Account.IAM_Service_Provider_Code__c;
                        u.Department=cn.Account.IAM_Service_Provider_Code__c;
                    }
                    //  if((cn.Account.CSS_DBCode__c!=null||cn.Account.CSS_DBCode__c!='')&&cn.Account.Type=='Distributor Branch Account'){ sonarcube fix
                    if((cn.Account.CSS_DBCode__c!=null && cn.Account.CSS_DBCode__c!='')&&cn.Account.Type=='Distributor Branch Account'){
                        u.IAM_Distributorbranchcode__c=cn.Account.CSS_DBCode__c;
                    }
                    //   if(cn.Account.CSS_DistributorCode__c!=null||cn.Account.CSS_DistributorCode__c!=''){ sonarcube fix
                    if(cn.Account.CSS_DistributorCode__c!=null && cn.Account.CSS_DistributorCode__c!=''){
                        u.IAM_Distributorcode__c=cn.Account.CSS_DistributorCode__c;
                        u.Division=cn.Account.CSS_DistributorCode__c;
                    }
                    //end of Code update
                    
                    u.IAM_Final_Approver__c='N';//Setting this value to default no because all external users should be set to N.Unless individual is getting registered.
                    
                    if(cn.CMI_Contact_Type__c=='Primary'){
                        //since it is a Primary Contact either Distributor Account Owner or Distributor Primary contact should be the Approver.
                        if(cn.Account.OwnerId!=System.Label.IAM_Cummins_Web_User_ID)
                            u.IAM_Identity_Approver__c=cn.Account.OwnerId;
                        //u.IAM_Identity_Approver__c=[select id from user where contact.Accountid=:cn.Account.parentid and username=:cn.Username__c and contact.CMI_Contact_Type__c='Primary'].id;//this should basically give the primary contact user id of that parent location
                    }else if(cn.CMI_Contact_Type__c=='Secondary'){
                        
                        
                        if(!usrForIdentity.isEmpty()){
                            if(usrForIdentity.ContainsKey(cn.Username__c)){
                                u.IAM_Identity_Approver__c=usrForIdentity.get(cn.Username__c).id;
                            }
                        }
                        //u.IAM_Identity_Approver__c=[select id from user where contact.Accountid=:cn.Accountid and username=:cn.Username__c and contact.CMI_Contact_Type__c='Primary'].id;//this should basically give the primary contact user id of that current location 
                    } //commented due to list has no rows exception
                    
                    if(cn.IAM_is_Member_of__c != '' && cn.IAM_is_Member_of__c != null)
                        u.IAM_is_Member_of__c=cn.IAM_is_Member_of__c;
                    if(cn.IAM_Work_Group_Id__c!= '' && cn.IAM_Work_Group_Id__c != null) 
                        u.IAM_WorkGroup_id__c=cn.IAM_Work_Group_Id__c;
                    /* if(cn.IAM_Qsolexpiration__c!= '' && cn.IAM_Qsolexpiration__c != null)  
u.IAM_Qsolexpiration__c=cn.IAM_Qsolexpiration__c;
if(cn.IAM_Qsolview__c!= '' && cn.IAM_Qsolview__c != null) 
u.IAM_Qsolview__c=cn.IAM_Qsolview__c;*/
                    if(cn.IAM_Product_Group_Access__c!= '' && cn.IAM_Product_Group_Access__c != null) 
                        u.Product_Group_Access__c=cn.IAM_Product_Group_Access__c;
                    // added more fields
                    if(cn.Account.CMI_Account_Num__c != null)
                        u.IAM_Account_Number__c = cn.Account.CMI_Account_Num__c;
                    u.IAM_Account__c = cn.Accountid;
                    if(cn.phone != null && cn.phone != '')
                        u.phone = cn.phone;
                    //end of IAM fields
                    
                    //Assaigning Guidanz fields on user creation.these can be there for each user and the same fields needs to be update on user record when a user is assaigned a record
                    if(cn.Account.IAM_Service_Provider_Code__c != '' && cn.Account.IAM_Service_Provider_Code__c != null)
                        u.Work_Group_Name__c=cn.Account.IAM_Service_Provider_Code__c; //basically cutomer code of the Account
                    if(cn.Account.Location__c != '' && cn.Account.Location__c != null)  
                        u.User_Location__c=cn.Account.Location__c;  //feild on Account Location__C
                    u.UserGroup__c='EDS_USER';  //CAn be hard coded to EDS User
                    
                    if(cn.IAM_Work_Group_Id__c != '' && cn.IAM_Work_Group_Id__c != null) {
                        /* List<String> s=cn.IAM_Work_Group_Id__c.split(';');
List<String> ad=new List<String>();
for(String sts:s){
if(sts.Contains('-P')){
ad.add(sts.remove('-P'));
}       
if(sts.Contains('-S')){
ad.add(sts.remove('-S'));
}
}
System.debug('Printing the complete List'+ad);          
string wrkgrpID = string.join(ad,';');*/
                        u.CSS_User_MultiLocValues__c=cn.IAM_Work_Group_Id__c.replace('|',';');// In this field users should have all Work group ids with ; seperated values.
                        //End of Guidanz Fields
                    } 
                    //Address fields need to be populated on the user record from Account
                    if(cn.IAM_Internal__c==True){
                        u.IAM_UserDn__c='uid='+cn.Username__c+',ou=employee,ou=people,dc=cummins,dc=com';     
                    }else if(cn.IAM_Internal__c==False){
                        u.IAM_UserDn__c='uid='+cn.Username__c+',ou=external,ou=people,dc=cummins,dc=com';   
                    }
                    u.FederationIdentifier=cn.Username__c;
                    u.Street=cn.Account.BillingStreet;
                    u.City=cn.Account.BillingCity;
                    u.State = cn.Account.BillingState;
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
                        if(appCumpasMap.get(cn.Accountid).IAM_Cumpas_Dist_CS_Rep__c!=null ){
                            u.IAM_Cumpas_Distributor_CSRep__c=appCumpasMap.get(cn.Accountid).IAM_Cumpas_Dist_CS_Rep__c;
                        }
                        if(appCumpasMap.get(cn.Accountid).IAM_Cumpas_Distributor_Sales_Rep__c!=null){
                            u.IAM_Cumpas_Distributor_Sales_Rep__c=appCumpasMap.get(cn.Accountid).IAM_Cumpas_Distributor_Sales_Rep__c;
                        }
                    }
                    
                    
                    //fields for QSOL expiration and Guidanz Mobile
                    
                    if(mapConAppQSOL.ContainsKey(cn.id)){
                        if(!(mapConAppQSOL.get(cn.id)).isEmpty()){
                            System.debug('Printing QSOL app feature'+(mapConAppQSOL.get(cn.id)).size());
                            System.debug('Printing QSOL app condition'+((mapConAppQSOL.get(cn.id)).size()>1));
                            if((mapConAppQSOL.get(cn.id)).size()>1){
                                String finalQSOLExp='';
                                for(IAM_Contact_Provisioning__c icon: mapConAppQSOL.get(cn.id)){
                                    System.debug('Printing QSOL'+ icon.IAM_Qsolexpiration__c);
                                    finalQSOLExp+=icon.IAM_Qsolexpiration__c+'|';
                                }
                                System.debug('Printing final String'+finalQSOLExp); 
                                if(!String.isBlank(finalQSOLExp)){    
                                    u.IAM_Qsolexpiration__c=finalQSOLExp.removeEnd('|');
                                }
                            }else if((mapConAppQSOL.get(cn.id)).size()==1){
                                System.debug('Printing size =1 QSOL Expiration');
                                if(mapConAppQSOL.get(cn.id)[0].IAM_Qsolexpiration__c!=''&& mapConAppQSOL.get(cn.id)[0].IAM_Qsolexpiration__c!=null){
                                    u.IAM_Qsolexpiration__c=mapConAppQSOL.get(cn.id)[0].IAM_Qsolexpiration__c;
                                }
                            }
                        }   
                    }else{
                        //This condition is to update QSOL expiration field to empty on the user record when there are no records.
                        u.IAM_Qsolexpiration__c='';
                    } 
                    
                    
                    
                    //Fields for Guidanz mobile Sreg
                    if(mapConAppGM.ContainsKey(cn.id)){
                        if(!(mapConAppGM.get(cn.id)).isEmpty()){
                            if((mapConAppGM.get(cn.id)).size()>1){
                                String finalSWreg='';
                                for(IAM_Contact_Provisioning__c icon: mapConAppGM.get(cn.id)){
                                    finalSWreg+=icon.IAM_swregExpire__c+'|';
                                } 
                                if(!String.isBlank(finalSWreg)){    
                                    u.IAM_swregExpire__c=finalSWreg.removeEnd('|');
                                }
                                System.debug('Printing swreg'+ u.IAM_swregExpire__c);
                            }else if((mapConAppGM.get(cn.id)).size()==1){
                                System.debug('Printing size =1 QSOL Expiration');
                                if(mapConAppGM.get(cn.id)[0].IAM_swregExpire__c!=null){
                                    u.IAM_swregExpire__c=mapConAppGM.get(cn.id)[0].IAM_swregExpire__c;
                                }
                            }
                        }   
                    }else{
                        u.IAM_swregExpire__c='';
                        
                    } 
                    
                    /*if(appqsolMap.ContainsKey(cn.Accountid)){
if(appqsolMap.get(cn.Accountid).IAM_Qsolexpiration__c!=null && appqsolMap.get(cn.Accountid).IAM_Qsolexpiration__c!=''){
u.IAM_Qsolexpiration__c=appqsolMap.get(cn.Accountid).IAM_Qsolexpiration__c;
}
if(appqsolMap.get(cn.Accountid).IAM_License_Type__c!=null && appqsolMap.get(cn.Accountid).IAM_License_Type__c!=''){
u.IAM_License_Type__c=appqsolMap.get(cn.Accountid).IAM_License_Type__c;
}

}
if(appguidanmobilezMap.ContainsKey(cn.Accountid)){
if(appguidanmobilezMap.get(cn.Accountid).IAM_swregExpire__c!=null && appguidanmobilezMap.get(cn.Accountid).IAM_swregExpire__c!=''){
u.IAM_swregExpire__c=appguidanmobilezMap.get(cn.Accountid).IAM_swregExpire__c;
}
}*/
                    
                    
                    if(cn.Account.IAM_WWSPS_Regions__c!=null&&cn.Account.IAM_WWSPS_Regions__c!=''){
                        u.IAM_WWSPS_Region__c=cn.Account.IAM_WWSPS_Regions__c;
                    }
                    if(cn.Account.Type!=null && cn.Account.Type!='' ){    
                        u.IAM_Type_of_Location__c=cn.Account.Type;
                    }
                    //u.TimeZoneSidKey='America/New_York';
                    //end of DBU related fields
                    //Start D-3224
                    if(cn.Account.Type!=null && cn.Account.Type!='' && cn.Account.Type=='Internal'){
                        u.IAM_SP_Code__c='';
                        u.IAM_Distributorbranchcode__c='';
                        u.IAM_Distributorcode__c='';
                        u.IAM_WorkGroup_id__c='';
                    }
                    //END D-3224 
                    userToInsert.add(u); 
                }
                System.debug('before insert userToInsert.....  '+userToInsert);
                if(!userToInsert.isEmpty()){
                    
                    Database.SaveResult[] srList = Database.insert(userToInsert, false);
                    // Iterate through each returned result
                    for(Database.SaveResult sr:srList){
                        if(sr.isSuccess()){//only look at failures, or NOT Successes
                            returnValue='OK';  
                        }else{
                            for(Database.Error err : sr.getErrors()){              
                                system.debug('error in user creation is:' +err.getMessage()); 
                                returnValue=err.getMessage();                      
                            }
                        }
                    }
                    List <id> uids=new List<id>();
                    List<id> OSMUIds = new List<id>(); // D-3249/3250
                    Map<Id,String> mapUidsRoles =new Map<Id,String>(); // D-3249/3250
                    Map<String,Id> rolepsIdSMap=new Map<String,Id>();// D-3249/3250
                    /*List <string> uname=new List<string>(); // uat#458 start
for(user uInsertUN: userToInsert){
uname.add(uInsertUN.username);
}
for(user uInsert: [select id from user where username =: uname]){
uids.add(uInsert.id);
} */  
                    for(user uInsert: userToInsert){
                        system.debug('mapOfInternalUsr@@@@'+mapOfInternalUsr);
                        if(!mapOfInternalUsr.get(uInsert.Username)){
                            system.debug('coming in if$$$$$');
                            uids.add(uInsert.id);
                        }else{
                            system.debug('coming in else$$$$$');
                            OSMUIds.add(uInsert.id);
                        }
                    }                              
                    // uat#458 end
                    System.debug('@@@'+uids+'---##'+userToInsert);
                    System.debug('Prinitng is future'+System.isFuture());
                    if(!System.isFuture()){
                        CMI_CreateUsersHelper.doResetPassword(uids); 
                    }else if(System.isFuture()){
                        for(id pids:uids){
                            System.resetpassword(pids,true);
                        }
                    }
                    // Below code is use assign permission set OSM Internal and legacy user D-3249/3250
                    if(!OSMUIds.isEmpty()){
                        for(Id objuId: OSMUIds){
                            mapUidsRoles.put(objuId,osmRole);
                        }
                        if(osmRole ==osmStoreFront || osmRole =='Distributor Admin'){
                            system.debug('@@@@@@'+IAM_PermissionSet_Assignment__c.getValues(osmRole).IAM_Permission_Set_Name__c);
                            string PsNAme=IAM_PermissionSet_Assignment__c.getValues(osmRole).IAM_Permission_Set_Name__c;
                            PermissionSet PS =[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Name =:PsNAme];//:IAM_PermissionSet_Assignment__c.getValues(Role).Permission_Set_Name__c LIMIT 1];
                            System.debug('Printing Permission set id'+PS);
                            rolepsIdSMap.put(osmRole,ps.id);
                            if(!System.isFuture() && System.IsBatch() == false){
                                //need to call the future method to assaign permission sets to the 
                                System.debug('begin AssignPermissionSetToUsers.......'+mapUidsRoles + 'pSMAp... '+rolePsIdsMap); 
                                //IAM_Assign_Application_Permissionset.AssignPermissionSetToUsersOSM(mapUidsRoles,rolepsIdSMap,'Insert');                    
                                ID jobID = System.enqueueJob(new IAM_AssignApplication_PS_Extension(mapUidsRoles,rolepsIdSMap,'Insert'));
                                System.debug('jobID'+jobID);
                            }
                        }else{
                            if(!System.isFuture() && System.IsBatch() == false){
                                Map<string,IAM_PermissionSet_Assignment__c> cSetting =IAM_PermissionSet_Assignment__c.getall();
                                for(PermissionSet PS :[SELECT Id,Label,Name,NamespacePrefix,ProfileId FROM PermissionSet where Label =:cSetting.keySet()]){
                                    if(PS.label !=osmStoreFront && PS.Label !='Distributor Admin'){
                                        rolepsIdSMap.put(cSetting.get(PS.label).Name,ps.id);
                                    }
                                }
                            }
                            System.debug('begin AssignPermissionSetToUsers.......'+mapUidsRoles + 'pSMAp... '+rolePsIdsMap); 
                            //IAM_Assign_Application_Permissionset.AssignPermissionSetToUsersOSM(mapUidsRoles,rolepsIdSMap,'Insert');
                            if(mapShopOnline.isEmpty()){
                            ID jobID = System.enqueueJob(new IAM_AssignApplication_PS_Extension(mapUidsRoles,rolepsIdSMap,'Insert'));
                            System.debug('jobID'+jobID);
                            }
                        }
                    }
                }
            }
            
            System.debug('Printing return value===='+returnValue);
            if(returnValue==''){
                //Please dont change the below default value
                returnValue='OK';
            }
        }catch(exception e){
            
            System.debug('Printng Exception '+e.getMessage());
            System.debug('Printing stack trace String'+e.getStackTraceString());
            System.debug('Printing stack trace String for create user'+e.getLineNumber());
            //Need to write logic fro Exception Handling
            returnValue=e.getMessage();
        }
        
        return returnValue;
    }
    
    Public Static String CreateUserFromActivate(List<Contact> objCon)  {
        
        List<User> userToInsert =new List<User>();
        List <User> usr = new List<User>();
        List <Contact> usrContacts = new List<Contact>();
        set<id> conids=new Set<id>();
        try{ 
            
            profile objProfile = [select id from Profile where name='IAM_Site_Admin_Community'];
            for(contact cnt:objCon){
                conids.add(cnt.id);
                usrContacts.add(cnt);
            }
            if(!conids.isEmpty()) {
                usr=[select id,username,isActive from user where Contactid=:conids];
                System.debug('Printing all the users in the list'+usr);     
            }
            if(usr.isEmpty() && usr.size() == 0) {
                for(Contact cn : usrContacts ) {
                    user userCreate = new user();
                    userCreate.firstName=cn.FirstName;
                    userCreate.LastName=cn.LastName;
                    userCreate.email=cn.email;
                    if (system.label.IAM_org_label != '.cso') {
                        userCreate.Username = cn.email + system.label.IAM_org_label;
                    } else {
                        userCreate.Username = cn.email;
                    } 
                    if (cn.LastName.length() >= 4) {
                        userCreate.alias = cn.FirstName.substring(0, 1) + '' + cn.LastName.substring(0, 4);
                    } else if (cn.LastName.length() <= 2 && cn.FirstName.length() <= 2) {
                        userCreate.alias = cn.FirstName + '' + cn.LastName;
                    } else {
                        userCreate.alias = cn.FirstName.substring(0, 4 - cn.LastName.length()) + '' + cn.LastName;
                    }
                    userCreate.profileId = objProfile.id;
                    userCreate.ContactId = cn.id;
                    userCreate.CompanyName=cn.Account.Name;
                    userCreate.isActive=true;
                    userCreate.IAM_Account_Number__c = cn.Account.CMI_Account_Num__c;
                    userCreate.EmailEncodingKey='UTF-8';
                    userCreate.LocaleSidKey='en_US';
                    userCreate.LanguageLocaleKey='en_US';
                    userCreate.TimeZoneSidKey='America/New_York';
                    userToInsert.add(userCreate);
                }
            }
            System.debug('before insert userToInsert....2222.  '+userToInsert);
            if(!userToInsert.isEmpty()) {
                Database.SaveResult[] srList = Database.insert(userToInsert, false); 
                List <id> uids=new List<id>();
                for(user uInsert: userToInsert){
                    uids.add(uInsert.id);
                }
                System.debug('Prinitng is future'+System.isFuture());
                if(!System.isFuture()){
                    CMI_CreateUsersHelper.doResetPassword(uids); 
                }else if(System.isFuture()){
                    for(id pids:uids){
                        System.resetpassword(pids,true);
                    }
                }          
            }   
        }
        catch(exception ex){}
        
        
        return null;
    }
    
    
    
    //Method to set the nickname for an user.
    //In below method there will always be a contact Id.
    //fix - defect - D-2824 - replaced parameter from id to object
    //Public Static String NickName(id conId){
    Public Static String NickName(Contact cn){
        //Changes for Guidanz Nickname
        //fix - defect - D-2824 - replaced parameter from id to object as getting too many SOQL 101 error
        //Contact cn=[select id,FirstName,LastName,email,Username__c,IAM_Site_Admin__c from Contact where id=:conId];
      /*String NickName='';
        Integer MaxLength=40;
        String toBeAdded='';
        Integer sanboxLength=System.Label.css_org.length();
        String conName=cn.FirstName+'.'+cn.LastName;
        String labelCon=conName+System.Label.css_org;
        if(!String.isEmpty(conName)&&conName.Length()<40){
            Integer remainingLength=MaxLength-conName.length()-sanboxLength-4;
            if(remainingLength>0){
                System.debug('Printing remaining lenght'+remainingLength);
                if(cn.Username__c != null){
                    system.debug('===Insdie Username__c===');
                    if(cn.Username__c.length()>remainingLength){
                        toBeAdded=cn.Username__c.substring(0,remainingLength);//In Reclaim and in user create usernmae should the calue to Update.
                    }else{
                        toBeAdded=cn.Username__c;
                    }
                }
                
                
                if(!String.isEmpty(toBeAdded)){ 
                    
                    NickName=conName+'.<'+toBeAdded+'>.'+System.Label.css_org;
                }else{
                    if(labelCon.length()>40){
                        NickName=labelCon.SubString(0,MaxLength);
                    }else{
                        NickName=labelCon;
                    }
                }
            }else{
                if(labelCon.length()>40){
                    NickName=labelCon.SubString(0,MaxLength);
                }else{
                    NickName=labelCon;
                }
            }
        }else{
            if(labelCon.length()>40){
                NickName=labelCon.SubString(0,MaxLength);
            }else{
                NickName=labelCon;
            }
        }
        //needs to update user record with all the application specified required values
        return NickName;   */
        // NickName logic to make it unique
        String currentDateTime= String.valueOf(DateTime.now().formatGMT('yyyy-MM-dd HH:mm:ss'));
		String randomNumber = String.valueOf(Math.Round(Math.Random() *99)).leftPad(3,'0');
		//System.debug('aa'+currentDateTime.replaceAll('[-:]', '').replaceAll(' ',''));
		String uniqueNumber=currentDateTime.replaceAll('[-:]', '').replaceAll(' ','')+randomNumber;
        String NickName='';
        String conName=cn.FirstName+'.'+cn.LastName;
        Integer lenConName=conName.Length();
        if(!String.isEmpty(conName)&&conName.Length()<23)
            NickName= conName+uniqueNumber;
        else 
            NickName= conName.substring(0,23)+uniqueNumber;
            
        return NickName;
                    
    }
    
}