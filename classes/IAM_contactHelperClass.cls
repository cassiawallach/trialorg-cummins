/************************************************************************
Purpose:                                                            
below class is mainly used for contact and user record updates depending upon actions performed                     
=============================================================
History                                                            
-------                                                            
VERSION     AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Golakram         16/04/2020       INITIAL DEVELOPMENT       
1.1 -    Chetan	Gaikwad        	  06/01/2020       Code fix - Profile update for Marketplace application
1.2 -    Shubhangi Sardar         12/03/2020       Added NPBU Diagnostic Expration
1.3 -    Karthik Golakaram        01/25/2021       Profile Correction for Market place - INC1022619
1.4 -    Karthik Raj Golakaram    05/13/2021       Added changes for Guidanz Dealer Evolutoin.
1.5 -    Suresh Rathod Nanavath   16/02/2022       Code fix-CHG0094522 - Customer code/Dealer code not updated on user
1.6 -    Suresh Rathod Nanavath   27/02/2022       Added condition to skip profile update for marketplace if user has Customer
												   Community Plus or Partner Community License
1.7 -    Suresh Rathod Nanavath   07/03/2022       Added logic to assign existing permission set before and after profile update for a user
1.8 -    Suresh Rathod Nanavath   25/03/2022       Added code to skip Nickname update,skip username update for legacy users,
                                                   commented out feature license update code for Guidanz
1.9 -    Kamini KM                02/08/2022       CHG0109043 updating IAM_Dealercode__c field on user record for customer type account                                                  
************************************************************************************/
public class IAM_contactHelperClass {
    public static boolean isFirstTimeUserAccessandFeatureTrigger = true;
    public static boolean isFirstTimeApplicationReject = true;
    public static boolean isFirstTime = true;
    public static boolean isRejectReasonFirstTime = true;
    public static boolean  isRejectcommentFirstTime = true;
    public static boolean isCalledEDQGL = false;
    public static boolean isCalledGL = false;
    public static boolean isUpdateUserdetails = true;
    public static boolean isUserUpdateFirstTime = true;
    public static boolean isAccountChanged = false;
    public  static Map<id,IAM_Contact_Provisioning__c> mapConProvCSS= new Map<id,IAM_Contact_Provisioning__c>();//Store Guidanz Contacts
    public  static Map<id,IAM_Contact_Provisioning__c> mapConProv= new Map<id,IAM_Contact_Provisioning__c>();//Store Rest of the contacts and Con Provisionings
    public static map<id,List<IAM_Contact_Provisioning__c>> mapConAppQSOL=new map<id,List<IAM_Contact_Provisioning__c>>();//Map to store a list of QSOL contact access features with contact id a Key.
    public static map<id,List<IAM_Contact_Provisioning__c>> mapConAppGM= new map<id,List<IAM_Contact_Provisioning__c>>();// Map to store a list of Guidanz Mobile App of Contact Access features and contact id as Key.

    @future
    public static void updateUserdetails(set<id> setConIds,boolean isReclaim,map<id,String> oldWWIDS) {

    System.debug('Value of reclaim from the trigger'+isReclaim);
    System.debug('Contact ids prined in trigger'+setConids);
    Set<id> gspCid=new set<id>();//set to store Contact ids for guidanz application Present and Profile same
    Set<id> gsNpCid=new set<id>();//set to store Contact ids for Guidanz application but not profile.

    Set<id> gnpCid=new Set<id>();//Set to store Contact ids no guidanz application Present and Profile name same.
    Set<id> gnnpCid=new Set<id>();//Set id to store Contact ids no Guidanz application and no same/CSS profile 
    Set<id> userGuidanzRemoval=new Set<id>();//Set to store User Ids to deactivate user record and create new user record.

    List<Contact> objCon=[select id,Account.Type,IAM_Contact_Status__c from Contact where id=:setConIds ];
    /*Before updating the user records Since we are provisioning for Guidanz application we need to check and everytime
    if contact has access to guidanz application and then check the profile of the user.

    if contact has access to guidanz application and already user is present then along with all the attributes 
    we need to update profile and role of the user.

    if user does not have access to guidanz application and user is present. 
    */

    //Code to  check if Guidanz application is present or not for a contact//
    List<IAM_Contact_Provisioning__c> conProv=[select id,IAM_Application_Name__c,IAM_Role__c,IAM_Status__c,IAM_Contact__c,IAM_swregExpire__c,IAM_Qsolexpiration__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:setConIds and IAM_Status__c='Active'];
                System.debug('Printing conProvisionings'+conProv);
                if(!conProv.isEmpty()){
                    
                    for(Contact con:objCon){//looping through all the contacts to check if there are any contact provisionings associated to the user
                        List<IAM_Contact_Provisioning__c> AppQSOL= new List<IAM_Contact_Provisioning__c>();//this list will store all contact provisionings for a single Contact.
                       List<IAM_Contact_Provisioning__c> AppGM= new List<IAM_Contact_Provisioning__c>();//List to Store Guidanz Mobile applications.
                       
                       
                        for(IAM_Contact_Provisioning__c conP:conProv){//looping through conprov to map all the conProvisionings.
                            if(con.id==conP.IAM_Contact__c){
                                if(conP.IAM_Application_Name__c==System.Label.IAM_AppName_Guidanz){
                                    mapConProvCSS.put(con.id,conP);//Adding applicaiton with app name Guidanz to the value and contact id as Key.
                                }
                                
                                //adding condition to add list of records of QSOL
                                if(conP.IAM_Application_Name__c==System.Label.IAM_AppName_QSOL){
                                    AppQSOL.add(conP);
                                }
                                //End of addition
                                
                                //adding Guidanz Mobile contact provisionings into a list
                                if(conP.IAM_Application_Name__c==System.Label.IAM_AppName_guidanzmobile||conP.IAM_Application_Name__c==Label.IAM_App_GuidanzMobileFieldTest){
                                    AppGM.add(conP);
                                }
                                //End of addition 
                                
                                //Commenting below pecise of code since I did not find this variable any where else in the code.
                                /*else{
                                    mapConProv.put(con.id,conP);
                                }*/
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
                    System.debug('Printing contact provisioning map of GM which are active'+mapConAppGM);
                }
                
      //map mapConProv consists of all the guidanz applications contacts with Contact id as key.           
    //End of code section


    //Section to check if Contacts has users and their respective Profiles
     
     List<User> usr=[select id,Profile.Name,Contactid,Profileid from User where Contactid=:setConIds];
     System.debug('Printing all the users'+usr);
     
         for(User u:usr){
             if(mapConProvCSS.ContainsKey(u.ContactId)){//If contact id is present in the map means contact has access to guidanz
                 if(u.Profileid==System.label.IAM_CSS_Dealer_Advanced_Profile_ID||u.Profileid==System.label.IAM_CSS_Dealer_Technician_Profile_ID){//Checking for the profile id to add into the set
                    gspCid.add(u.Contactid); 
                 }else{
                     gsNpCid.add(u.Contactid);
                 }
             }else{//contacts with no guidanz access should enter into this loop
                 if(u.Profileid==System.label.IAM_CSS_Dealer_Advanced_Profile_ID||u.Profileid==System.label.IAM_CSS_Dealer_Technician_Profile_ID){//Checking for the profile id to add into the set
                    gnpCid.add(u.Contactid); 
                    userGuidanzRemoval.add(u.id);
                 }else{
                     gnNpCid.add(u.Contactid);
                 }
             }
         
         }
         
         //Printing all contact ids respectivly
         System.debug('Contact ids with Guidanz application and CSS profile only user attributes need to update'+gspCid);
         System.debug('Contact ids with Guidanz application and not CSS profile only user attributes need to update along with Profile'+gsNpCid);
         System.debug('Contact ids with No Guidanz application and CSS profile. New user Should be created'+gnpCid);
         System.debug('Contact ids with No Guidanz application and No CSS profile only user attributes need to update'+gnNpCid);
         
         //calling respective Methods to update the user attributes respectively.
         if(!gspCid.isEmpty()){
             System.debug('guidanz application access and same profile only user attributes need to update need to update Profile also when change in Role happens');
            userAttributeUpdate(True,gspCid,isReclaim,oldWWIDS); 
         }
         
         if(!gsNpCid.isEmpty()){
             System.debug('Guidanz application and not CSS profile only user attributes need to update along with Profile');
              try {
                 userAttributeUpdate(True,gsNpCid,isReclaim,oldWWIDS); 
              }catch(exception ex) { 
                 system.debug('exception is'+ex.getmessage());
              }
         }
         
         if(!gnpCid.isEmpty()){
             System.debug('No Guidanz application Access but user has profile of Guidanz, Need to create a new User');
            // List<Contact> con=[select id,FirstName,LastName,Email,IAM_Contact_Status__c,Username__c,CMI_Contact_Type__c,Account.Ownerid,Account.Recordtype.Name,Accountid,Account.Name,Account.CMI_Account_Status__c,Account.CSS_Language__c,Account.CMI_CDA_Status__c,Account.CMI_CId__c,Account.CSS_EmailEncoding__c,Account.CSS_Timezone__c,Account.CSS_Locale__c,Account.Type,(select id,IAM_Application_Name__c,IAM_DA_Customer_List__c,IAM_RLS_Customer_Number__c, IAM_RLS_Group_Admin_Email__c,IAM_Role__c,IAM_Status__c,IAM_Active_Contact_Provisioning__c from Contact_Provisionings__r)  from contact where id=:gnpCid];
             //IAM_CreateUser.CreateUser(con);
             userAttributeUpdate(True,gnpCid,isReclaim,oldWWIDS); 
             
         }
         
         if(!gnNpCid.isEmpty()){
             System.debug('No guidanz application access and no CSS profile just plain update');
             try {
                userAttributeUpdate(false,gnNpCid,isReclaim,oldWWIDS);
              }catch(exception ex) { 
                 system.debug('exception is'+ex.getmessage());
              }
         }

    }


    @future(callout=true)
    public static void revokeOauthTokens(set<id> setUsersId) {

    List<OauthToken> lstOauthToken = new List<OauthToken> ();
    lstOauthToken = [Select id, user.name, accesstoken,DeleteToken From OauthToken Where userid IN :setUsersId];
      
      for(OauthToken oAuthTkn : lstOauthToken) { 
        // https://cumminscss--eidmdev.cs61.my.salesforce.com  
        //String urlRevoke = 'https://test.salesforce.com/services/oauth2/revoke?token=';
        String urlRevoke = system.label.IAM_Oauth_Instance;
        String tokenEncode = EncodingUtil.URLENCODE(oAuthTkn.DeleteToken,'UTF-8');
        urlRevoke += tokenEncode;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(urlRevoke);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setMethod('GET');
       
        Http http = new Http();                
        HttpResponse res = new Http().send(req);
        if(res.getStatusCode() == 302) {
         req.setEndpoint(res.getHeader('Location'));
         res = new Http().send(req);
         system.debug('CR=response= '+res);
        }    

     } //End Revoke OAuth code 
    }

     // Changes done for the Internal Den value updation for the Internal users/contacts
     public static void updateApplicationContact(List<IAM_Contact_Provisioning__c> lstContProv){
        
        List<contact> lstContactUpdate = new List<contact>();
        Set<id> contId = new Set<id>();
        set<id> setUserId = new set<id>();
        
        Map<String, List<IAM_Contact_Provisioning__c>> mapICP = new Map<String, List<IAM_Contact_Provisioning__c>>();
        List<IAM_Application_Groups__c> lstAppGroup = IAM_Application_Groups__c.getall().values();//getting all the custom settings.
        Map<String, IAM_Application_Groups__c> mapAppGroup = new Map<String, IAM_Application_Groups__c>();//mapp to store application groups that we have from Custom settings
        boolean hasActiveContactProsioningRecords = false;
     
        List<IAM_Contact_Provisioning__c> allConProv=new List<IAM_Contact_Provisioning__c>();
        for(IAM_Application_Groups__c appGrp : lstAppGroup){
        
            mapAppGroup.put(appGrp.IAM_Application_Name__c+appGrp.IAM_Role_Name__c, appGrp);
        }
        
        for(IAM_Contact_Provisioning__c ICV : lstContProv){//looping through contact Provisionings to get key value and applicatoin 
            contId.add(ICV.IAM_Contact__c);
             //   if(ICV.IAM_User__c!=null||ICV.IAM_User__c!='') SonarCube fix, added line below
             system.debug('Printing user id on the Contact Provisionings Object'+ICV.IAM_User__c);
            if(ICV.IAM_User__c!=null)
                setUserId.add(ICV.IAM_User__c);
              //Why do we need this loop?- Azaz
        }
        system.debug('updateApplicationContact  contId***  ' + contId);
        
        if(!contId.isEmpty()){
            //This query will give all the active contact Provisionings for all the Contacts 
            //allConProv=[select id,IAM_Status__c,IAM_Qsolexpiration__c,IAM_Application_Name__c,IAM_Role__c,IAM_Contact__c,IAM_User__c,IAM_Cumpas_Modularity__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:contId AND IAM_Status__c =: System.Label.IAM_Active];
             allConProv=[select id,IAM_Status__c,IAM_Qsolexpiration__c,IAM_swregexpire__c,IAM_Application_Name__c,IAM_Role__c,IAM_Contact__c,IAM_User__c,IAM_Cumpas_Modularity__c,IAM_Promotion__c, IAM_Subscription_Name__c, IAM_Remaining_Units__c, IAM_Remaining_Count_Formatted__c,IAM_NpbuDiagExpire__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:contId];
        }
        
        if(!allConProv.isEmpty()){
            for(IAM_Contact_Provisioning__c c:allConProv){
                if(mapICP.containsKey(c.IAM_Contact__c)){
                    system.debug('Mapping adding');
                    mapICP.get(c.IAM_Contact__c).add(c);
                }else{
                    List<IAM_Contact_Provisioning__c> lstIAMContPro = new List<IAM_Contact_Provisioning__c>();
                    lstIAMContPro.add(c);
                    mapICP.put(c.IAM_Contact__c, lstIAMContPro);//inserting all the contact provisionings for that contact in the map with contact Id as key.
                }
            }
            
        }
        
        Map<id,user> mapUser = new Map<id,user>([select id, isActive from user where id in: setUserId]);
        system.debug('updateApplicationContact  contId1234***  ' + contId);
        /* 12/03/2020 - Added NPBU Diagnostic Expration */
        List<contact> lstContact = [select id,IAM_Applications__c,IAM_Qsolexpiration__c,IAM_NpbuDiagExpire__c,IAM_Application_Roles__c,IAM_Internal__c,Iam_Legacy_user__c,IAM_Promotion__c from contact where id =: contId];
        system.debug('mapAppGroup***  ' + mapAppGroup);//map for storing all the custom settings with key as appName+role
        system.debug('lstContProv***  ' + lstContProv);
        system.debug('lstContact***  ' + lstContact);
        system.debug('mapICP***  ' + mapICP);//map for all the contact provisionings that contact has access to with contact id as key
        system.debug('mapUser***  ' + mapUser);
        
        
        for(Contact con : lstContact){
       
            String roles='';        
            String DNValues='' ;
            list<string> lstDNValuesToRemove = new list<string>();
            list<string> lstrolesToRemove = new list<string>();
            string qsolExpiration='';
            string qsolExpirationUpdated='';
            string swregexpire = '';
            List<String> paidCountList = new List<String>();
            List<String> freeCountList = new List<String>();
            String npbuDiagExpire = '';
              
            if(!mapICP.isEmpty()){
                for(IAM_Contact_Provisioning__c contPro : mapICP.get(con.id)){
                    if(contPro.IAM_Status__c=='Active'){
                        String[] tmpString = contPro.IAM_Role__c.split(';');
                        
                        hasActiveContactProsioningRecords = true;
                        
                        System.debug('Printng string list'+tmpString);
                        for(String role : tmpString){
                            IAM_Application_Groups__c appGrp = null;
                             
                            system.debug('App name+role' +contPro.IAM_Application_Name__c+role);
                            System.debug('Checking id mapAppGroup contains the key with app name and Role'+mapAppGroup.containsKey(contPro.IAM_Application_Name__c+role));
                            if(mapAppGroup.containsKey(contPro.IAM_Application_Name__c+role)){
                                System.debug('Checking id mapAppGroup contains the key with app name and Role'+mapAppGroup.containsKey(contPro.IAM_Application_Name__c+role));
                                appGrp = mapAppGroup.get(contPro.IAM_Application_Name__c+role);
                                
                                System.debug('Printing app group from custom settings appGrp'+appGrp);
                                //System.debug('Checking user condition si true'+(contPro.IAM_User__c != null && mapUser.get(contPro.IAM_User__c).isActive));
                                 system.debug('===DNValues.contains(appGrp.IAM_DN_value__c)==='+DNValues.contains(appGrp.IAM_DN_value__c));
                                //Now need to differentiate between Internal and exyernal user to Update the Contact
                                //Check is internal flag to differentiate between internal and External user.
                                system.debug('=====DNValues before if condition==='+DNValues);
                               if(!DNValues.contains(appGrp.IAM_DN_value__c)) 
                               {    system.debug('====Inside if DNValues===='+DNValues);
                                    if(!con.IAM_Internal__c){
                                        system.debug('====Inside if Qsol check 02====');
                                        //if(contPro.IAM_User__c != null && null != mapUser.get(contPro.IAM_User__c) && mapUser.get(contPro.IAM_User__c).isActive){
                                          if((contPro.IAM_User__c != null && null != mapUser.get(contPro.IAM_User__c) && mapUser.get(contPro.IAM_User__c).isActive) || con.Iam_Legacy_user__c == true|| con.Iam_Legacy_user__c == false ){
                                            system.debug('====Inside if Qsol check 03====');
                                            System.debug('Printin app group values'+appGrp.IAM_DN_value__c);
                                            if(!String.isBlank(appGrp.IAM_DN_value__c)){
                                                system.debug('====Inside if Qsol check 04====');
                                                //DNValues+= appGrp.IAM_DN_value__c+'|';
                                                system.debug('====appGrp.IAM_DN_value__c='+appGrp.IAM_DN_value__c);
                                                DNValues = DNValues +'|'+appGrp.IAM_DN_value__c;
                                                system.debug('===DNValues=03==='+DNValues);
                                            }
                                                
                                            if(!String.isBlank(appGrp.IAM_Role_Name__c))
                                                roles = roles + ','+appGrp.IAM_Role_Name__c;
                                        }
                                    }else if(con.IAM_Internal__c){
                                        system.debug('====Inside if Qsol check 05====');
                                        if(!String.isBlank(appGrp.IAM_DN_value__c))
                                        {   system.debug('====Inside if Qsol check 06====');
                                            if(DNValues.endsWith(','))
                                            {   system.debug('====Inside if Qsol check 07====');
                                                DNValues = DNValues +'|'+appGrp.IAM_DN_value__c;
                                                system.debug('===DNValues=04==='+DNValues);
                                            }
                                            else
                                            {   system.debug('====Inside if Qsol check 08====');
                                                DNValues = DNValues +'|'+appGrp.IAM_DN_value__c;
                                                system.debug('===DNValues=05==='+DNValues);
                                            }
                                        }
                                             
                                        if(!String.isBlank(appGrp.IAM_Role_Name__c))
                                        {   system.debug('====Inside if Qsol check 09====');
                                            if(roles.endsWith(','))
                                            {   system.debug('====Inside if Qsol check 10====');
                                                roles = roles + ','+appGrp.IAM_Role_Name__c;
                                            }
                                            else
                                            {   system.debug('====Inside if Qsol check 11====');
                                                roles = roles + ','+appGrp.IAM_Role_Name__c;
                                            }
                                        }
                                            
                                    }
                               }
                               else if(!roles.contains(appGrp.IAM_Role_Name__c)){
                                     roles = roles + ','+appGrp.IAM_Role_Name__c;
                                     system.debug('==Inside else part of DN values contains==');
                               }
                               
                                //Amarnath added this for the Qsolexpiration logic
                                if(contPro.IAM_Application_Name__c == System.Label.IAM_AppName_QSOL){
                                    system.debug('====Inside qsolExpiration check===01');
                                    system.debug('=qsolExpiration==='+qsolExpiration);
                                    system.debug('===qsolExpiration.contains(contPro.IAM_Qsolexpiration__c)=='+qsolExpiration.contains(contPro.IAM_Qsolexpiration__c));
                                    system.debug('====contPro.IAM_Qsolexpiration__c=check===01.1==='+contPro.IAM_Qsolexpiration__c);
                                    if(String.isNotEmpty(contPro.IAM_Qsolexpiration__c)){
                                        system.debug('====Inside qsolExpiration check===02');
                                        qsolExpiration = qsolExpiration +'|'+contPro.IAM_Qsolexpiration__c;
                                    }
                                     
                                }
                                
                                if((contPro.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_Guidanz_Mobile_App_Name)
                                   || contPro.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_App_GuidanzMobileFieldTest))) {
                                    if(String.isNotBlank(contPro.IAM_swregexpire__c)) {
                                        system.debug('===Inside swregexpire on contact===');
                                        swregexpire =   swregexpire + '|' + contPro.IAM_swregexpire__c;
                                    }
                                    /*if(String.isNotBlank(contPro.IAM_Remaining_Count_Formatted__c)) {
                                        getPaidAndFreeCount(contPro.IAM_Subscription_Name__c,
                                        contPro.IAM_Remaining_Count_Formatted__c, paidCountList, freeCountList);
                                    }*/
                                }
                            }
                            
                        }
                        //here we will see application name if the contact provisioning and Update is member of accordingly
                        if(contPro.IAM_Application_Name__c == System.Label.IAM_AppName_Cumpas){
                            con.IAM_is_Member_of__c = contPro.IAM_Cumpas_Modularity__c;
                        }
                        if(contPro.IAM_Application_Name__c==System.Label.IAM_Cummins_Service_Training){
                            if(!String.isBlank(contPro.IAM_Promotion__c)){
                                System.debug('Assigning Promotion Id');
                                con.IAM_Promotion__c=contPro.IAM_Promotion__c;
                            }
                        } 
                        
                        if((contPro.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_Guidanz_Mobile_App_Name)
                            || contPro.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_App_GuidanzMobileFieldTest))
                            && contPro.IAM_Role__c.containsIgnoreCase('Units')
                            && String.isNotBlank(contPro.IAM_Remaining_Count_Formatted__c)) {
                            
                            getPaidAndFreeCount(contPro.IAM_Subscription_Name__c,
                            contPro.IAM_Remaining_Count_Formatted__c, paidCountList, freeCountList);
                            
                        }
                        /* 12/03/2020 - Added NPBU Diagnostic Expration */
                        if(contPro.IAM_Application_Name__c.equalsIgnoreCase(Label.IAM_FT_NPBU_Diagnostics)) {
                            if(String.isNotBlank(contPro.IAM_NpbuDiagExpire__c)) {
                                system.debug('===Inside IAM_NpbuDiagExpire__c on contact===');
                                npbuDiagExpire =   npbuDiagExpire + '|' + contPro.IAM_NpbuDiagExpire__c;
                            }                            
                        }
                    }else if(contPro.IAM_Status__c != 'Active' && contPro.IAM_Application_Name__c == System.Label.IAM_AppName_Cumpas){
                        con.IAM_is_Member_of__c = '';
                    } 
                    
                    else if(contPro.IAM_Status__c != 'Active'){ //Harshini
                        String[] tmpString = contPro.IAM_Role__c.split(';');
                                             
                        System.debug('Printng string list'+tmpString);
                        for(String role : tmpString){
                            IAM_Application_Groups__c appGrp = null;
                             
                            system.debug('App name+role' +contPro.IAM_Application_Name__c+role);
                            System.debug('Checking id mapAppGroup contains the key with app name and Role'+mapAppGroup.containsKey(contPro.IAM_Application_Name__c+role));
                            if(mapAppGroup.containsKey(contPro.IAM_Application_Name__c+role)){
                                System.debug('Checking id mapAppGroup contains the key with app name and Role'+mapAppGroup.containsKey(contPro.IAM_Application_Name__c+role));
                                
                                appGrp = mapAppGroup.get(contPro.IAM_Application_Name__c+role);
                                System.debug('Printing app group from custom settings appGrp'+appGrp);
                                lstDNValuesToRemove.add(appGrp.IAM_DN_value__c);
                                lstrolesToRemove.add(appGrp.IAM_Role_Name__c);
                                                                
                            }
                             
                        }
                        if(contPro.IAM_Application_Name__c == System.Label.IAM_Guidanz_Mobile_App_Name){
                            system.debug('===Inside swregexpire nullify on contact===');
                            //swregexpire = '';
                        }
                        if(contPro.IAM_Application_Name__c==System.Label.IAM_Cummins_Service_Training){
                            //con.IAM_Promotion__c='';// If needed we can just un comment this 
                        }
                        
                    }
                    
                }
                
                
                system.debug('====Added the new roles and Den value=='); 
                con.IAM_Application_Roles__c =  roles.removeEnd(',').removeStart(',');
                con.IAM_Applications__c =   DNValues.removeEnd('|').removeStart('|');
                con.IAM_Deactivation_Mail_Sent__c = false;
                //Amar added for the location change email send logic
                con.Location_Change__c = false;
                  
                if(String.isNotBlank(swregexpire)){
                    con.IAM_swregexpire__c = swregexpire.removeEnd('|').removeStart('|'); 
                }
                else{
                    con.IAM_swregexpire__c = '';
                }
                 
                if(!String.isBlank(qsolExpiration)){
                    con.IAM_Qsolexpiration__c = qsolExpiration.removeEnd('|').removeStart('|');   
                }
                else{
                    con.IAM_Qsolexpiration__c = '';
                }
                if(!paidCountList.isEmpty()) {
                    con.IAM_Remaining_Paid_Count__c = String.join(paidCountList, '|');
                }
                if(!freeCountList.isEmpty()) {
                    con.IAM_Remaining_Free_Count__c = String.join(freeCountList, '|');
                }
                /* 12/03/2020 - Added NPBU Diagnostic Expration */
                if(String.isNotBlank(npbuDiagExpire)) {
                    con.IAM_NpbuDiagExpire__c = npbuDiagExpire.removeEnd('|').removeStart('|');
                } else {
                    con.IAM_NpbuDiagExpire__c = '';
                }
                 
                system.debug('roles finally.... '+con.IAM_Application_Roles__c);
                system.debug('DNValues finally.... '+con.IAM_Applications__c);
                 
                 if(hasActiveContactProsioningRecords == false){
                    
                    con.IAM_Application_Roles__c = '';
                    con.IAM_is_Member_of__c = '';
                    con.IAM_swregexpire__c = '';
                    con.IAM_Applications__c ='';
                    con.IAM_Qsolexpiration__c ='';
                    con.IAM_Qsolview__c = '';
                    /* 12/03/2020 - Added NPBU Diagnostic Expration */
                    con.IAM_NpbuDiagExpire__c = '';
                } 
            }else{
                //this else loop is to update the application groups value with null Value is no active application Provisioning is present.
                
                con.IAM_Application_Roles__c = '';
                con.IAM_is_Member_of__c = '';
                //Amarnath Mishra added these values
                con.IAM_swregexpire__c = '';
                con.IAM_Applications__c ='';
                con.IAM_Qsolexpiration__c ='';
                con.IAM_Qsolview__c = '';
                /* 12/03/2020 - Added NPBU Diagnostic Expration */
                con.IAM_NpbuDiagExpire__c = '';
                system.debug('user access status before update  '+con.IAM_Applications__c);      
            } 
            lstContactUpdate.add(con);
        }
        system.debug('lstContactUpdate***  ' + lstContactUpdate);
        if(lstContactUpdate.size() >0 && !lstContactUpdate.isEmpty()){
            Update lstContactUpdate;
        }

    }


    @future
     public static void AccountChange(Set<Id> conIds){
        
        System.debug('executed becacuse of the before update and change in the account name '+conIds); 
        /* Set<id> conIds= new Set<id>();
         for(contact c:con){
             conIds.add(c.id);
         }*/
         List<IAM_Contact_Provisioning__c> conProvUpdate = new List<IAM_Contact_Provisioning__c> ();
         if(!conIds.isEmpty()){
             List<IAM_Contact_Provisioning__c> conProv=[select id,IAM_Status__c,IAM_Contact__r.Account.Type,IAM_Contact__r.Account.Parent.CMI_CId__c  from IAM_Contact_Provisioning__c where IAM_Contact__c=:conIds];
             System.debug('Printing all the applications for the contact'+conProv);
             for(IAM_Contact_Provisioning__c cn:conProv){
                 cn.IAM_Status__c='Inactive';
                 cn.Location_Change__c=true;
                 cn.IAM_Reject_Reason__c='No Longer at Location'; //Added for D-3101
                 conProvUpdate.add(cn);
             }
             if(!conProvUpdate.isEmpty()) {
               Update conProvUpdate;
             }
             
             
         } 
      } 
         
        
        //Below method will take Boolean and set of Contact IDs as parameters and Update user attributes respectively 
        //Boolean Parameter is mainly used to update the Profile of user if he has guidanz applicatin
    Public Static Void userAttributeUpdate(boolean perform,set<id> setConIds,boolean isReclaim,Map<id,String> oldWWIDS){
                    System.debug('begins userAttributeUpdate  perform '+perform+' setConIds.. '+ setConIds+'  isReclaim... '+isReclaim + ' .oldWWIDS.. '+oldWWIDS);
                      List<User> userListUpdate = new List<User>();
                      /* 12/03/2020 - Added NPBU Diagnostic Expration */
    List<User> userList =  [Select id,UserPermissionsSFContentUser,Contact.IAM_Legacy_User__c,Contact.IAM_Site_Admin__c,Contact.IAM_Site_Admin_Role__c,Contact.IAM_Ext_Legacy_Uid__c,isActive,Name,Email,Phone,profile.Name,profile.UserLicense.Name,FederationIdentifier,IAM_Promotion__c,IAM_Application_Roles__c,Contact.IAM_Promotion__c,ContactId,contact.email,Contact.FirstName, 
                           Contact.LastName,contact.phone,Contact.Account.CMI_Account_Num__c,Contact.IAM_Contact_Status__c,Contact.IAM_Internal__c,
                           Contact.Account.IAM_Service_Provider_Code__c,Contact.Account.Name, Contact.Account.CSS_DistributorCode__c,
                           Contact.Account.CSS_DBCode__c,Contact.Username__c,Contact.Account.CSS_DealerCode__c,Contact.Account.CMI_CId__c,contact.IAM_Applications__c,
                           contact.IAM_Final_Approver__c,Contact.Account.Type,Contact.Account.parent.type,Contact.Account.IAM_ABO_Code_Formula__c,
                           Contact.IAM_is_Member_of__c,contact.IAM_Work_Group_Id__c,Contact.IAM_Product_Group_Access__c,Contact.Accountid,contact.IAM_Application_Roles__c,
                           Contact.Account.BillingStreet,Contact.Account.BillingCity,Contact.Account.BillingCountry,Contact.Account.BillingPostalCode,contact.IAM_Qsolview__c,IAM_Applicationgroups__c,Contact.Location_Change__c,
                           contact.Account.IAM_Movex_Customer_Code__c,Contact.Account.IAM_WWSPS_Regions__c,Contact.Account.Location__c,Contact.Account.IsPartner,Contact.Account.IsCustomerPortal,IAM_License_Type__c,IAM_swregExpire__c,IAM_NpbuDiagExpire__c, Contact.IAM_NpbuDiagExpire__c, IAM_Qsolexpiration__c,Contact.CMI_Contact_Type__c from User where Contactid IN :setConIds];
    
        List<PermissionSet> permissionSetList = [
            SELECT Id
                , Label
                , Name
            FROM PermissionSet
            WHERE Label = :Label.IAM_GuidanzPSet_EVLDealerAdv
            OR Label = :Label.IAM_GuidanzPSet_EVLDealerTechnician
        ];
        System.debug('Printing permision set id'+permissionSetList);
        Map<String, Id> permissionSetMap = new Map<String, Id>();
        if(!permissionSetList.isEmpty()) {
            for(PermissionSet p : permissionSetList) {
                permissionSetMap.put(p.Label, p.Id);
            }
        }
        System.debug('##### permissionSetMap - '+ permissionSetMap);
        Id pid;
        User userObj;
    List<IAM_Application__c> accApp=new List<IAM_Application__c>();
    Map<id,IAM_Application__c> appCumpasMap=new Map<id,IAM_Application__c>();
    Map<id,IAM_Application__c> appQSOLMap=new Map<id,IAM_Application__c>();
    Map<id,IAM_Application__c> appguidanzmobileMap=new Map<id,IAM_Application__c>();
    set<id> accids=new set<id>();
    Map<id,Contact> CumpasDistSR= new Map<id,Contact>();//Map to store all the Cumpas distributors.
    Map<id,Contact> CumpasDistCSRep=new Map<id,Contact>();//Map to store CS reps.
    Set<id> cDistSR=new Set<id>();
    Set<id> cDistCS=new Set<id>();
    Set<id> setContUserId = new Set<id>();
    Map<id,list<IAM_Contact_Provisioning__c>> mapConatactIdlstContactProvisions= new Map<id,list<IAM_Contact_Provisioning__c>>(); // for connected solution field udpate on user
    list<IAM_Contact_Provisioning__c> lstContactProvisioning = new list<IAM_Contact_Provisioning__c>(); //for connected solution field udpate on user
    //Code Addition By Karthik - 01/21/2021
    Map<id,IAM_Contact_Provisioning__c> conAppMarketPlace= new Map<id,IAM_Contact_Provisioning__c>();
    // End of Code Addition By Karthik - 01/21/2021

    Boolean isProfileChange = false; // Variable to determine if profile/license changed due to guidanz/marketplace access-@Suresh- 23/02/2022
    List<PermissionSetAssignment> guidanzPSAssignmentList = new List<PermissionSetAssignment>();
    //Amarnath Mishra added for the connected solution field update on user object
    for(Contact contact :[SELECT id,Name,Iam_contact_status__c,IAM_Reject_Reason__c,(SELECT Id,Name,IAM_status__C,IAM_DA_Calibaration_Role__c,IAM_User_Type__c,IAM_DA_Customer_List__c,IAM_Role__c,IAM_Application_Name__c,IAM_Contact__r.Account.Parent.Type,IAM_Contact__r.Account.Parent.CMI_CId__c FROM Contact_Provisionings__r WHERE IAM_Status__c = 'Active') FROM contact where id IN :setConIds]){
        lstContactProvisioning = contact.Contact_Provisionings__r;
        mapConatactIdlstContactProvisions.put(contact.id,lstContactProvisioning);
    }
    
    for(User u: userList){
        accids.add(u.contact.Accountid);
        //fix - defect - D-2824 - replaced parameter from contact id to contact object in NickName method
        setContUserId.add(u.contactid);

        //Code added by Karthik - 01-21-2021
        if(mapConatactIdlstContactProvisions.ContainsKey(u.Contact.id)){
            for(IAM_Contact_Provisioning__c mpp: mapConatactIdlstContactProvisions.get(u.Contact.id)){
                if(mpp.IAM_Application_Name__c==System.Label.IAM_OSM_App_Name){
                    System.debug('Prinitng market place Contact Provisioning Record');
                    conAppMarketPlace.put(u.Contact.id,mpp);
                }
            }
        }
        //Code Addition End by Karthik - 01-21-2021
    }
    //fix - defect - D-2824 - replaced parameter from contact id to contact object in NickName method
    Map<id, Contact> mapcontUser = new Map<id, Contact>([select id,FirstName,LastName,email,Username__c,IAM_Site_Admin__c from Contact where id=:setContUserId]);
    if(!userList.isEmpty()){
           accApp=[select id,IAM_Account_Name__c,IAM_Qsolexpiration__c,IAM_swregExpire__c,IAM_License_Type__c,IAM_Application_Name__c,IAM_Cumpas_Modularity__c,IAM_Cumpas_Dist_CS_Rep__c,IAM_Cumpas_Distributor_Sales_Rep__c from IAM_Application__c where IAM_Account_Name__c=:accids];
              if(!accApp.isEmpty()){
                  for(IAM_Application__c ap:accApp){
                      if(ap.IAM_Application_Name__c==System.Label.IAM_AppName_Cumpas){
                        appCumpasMap.put(ap.IAM_Account_Name__c,ap);
                        if(ap.IAM_Cumpas_Distributor_Sales_Rep__c!=null){
                            cDistSR.add(ap.IAM_Cumpas_Distributor_Sales_Rep__c);
                        }
                        if(ap.IAM_Cumpas_Dist_CS_Rep__c!=null){
                            cDistCS.add(ap.IAM_Cumpas_Dist_CS_Rep__c);
                        }  
                      }
                      if(ap.IAM_Application_NAme__c==System.Label.IAM_AppName_QSOL){
                      appQSOLMap.put(ap.IAM_Account_Name__c,ap);
                      }
                    if(ap.IAM_Application_NAme__c==System.Label.IAM_AppName_Guidanz){
                      appguidanzmobileMap.put(ap.IAM_Account_Name__c,ap);
                      }
                    }
                }
    }


     if(!cDistSR.isEmpty()){
        List<Contact> conDSR=[select id,Username__c from Contact where id=:cDistSR];
        if(!conDSR.isEmpty()){
            for(Contact cDSR:conDSR){
                CumpasDistSR.put(cDSR.id,cDSR);
            }
        }
    }

    if(!cDistCS.isEmpty()){
        List<Contact> conDistCS=[select id,Username__c from Contact where id=:cDistCS];
        if(!conDistCS.isEmpty()){
            for(Contact cDS:conDistCS){
                CumpasDistCSRep.put(cDS.id,cDS);
            }
        }
    }
    
    System.debug('Printing Cumpas Account Access Feature'+appCumpasMap);
    System.debug('Printing QSOL Account Access Feature'+appQSOLMap);    
    System.debug('Printing Guidanz Account Access Feature'+appguidanzmobileMap);                            
    for(User usr : userList) {
    //Updating User
    if(usr.isActive==false&&usr.Contact.IAM_Contact_Status__c=='Active'){
        usr.isActive=True;
    }else if(usr.Contact.IAM_Contact_Status__c=='Inactive'){
        usr.isActive=false;
    }
    IAM_Contact_Provisioning__c appGuidanz=new IAM_Contact_Provisioning__c();
    Profile pCSS=new Profile(); 
    id roleCSS;
    String portalRole='';
    system.debug('***User Update****');
    /* 12/03/2020 - Added NPBU Diagnostic Expration */
    usr.IAM_NpbuDiagExpire__c = usr.Contact.IAM_NpbuDiagExpire__c;
    usr.email = usr.Contact.email;
    // usr.username=usr.Contact.Username__c;
    usr.firstName = usr.Contact.FirstName;
    usr.LastName = usr.Contact.LastName;
    //Setting Guidanz Nick Name
    //fix - defect - D-2824 - replaced parameter from contact id to contact object in NickName method
    //String NickName=IAM_CreateUser.NickName(usr.contactid);
    System.debug('printing value of mapcontUser...  ' + mapcontUser);
    if(mapContUser.ContainsKey(usr.Contactid)){
        String NickName=IAM_CreateUser.NickName(mapcontUser.get(usr.contactid));
        if(!String.isEmpty(NickName)&& (usr.CommunityNickName==''||usr.CommunityNickName==null)){  //CHG0083323- To avoid updating nickname when its already present
            usr.CommunityNickName=NickName;
        }
    }
    //End of Guidanz NickName changes
    if(usr.contact.phone != Null) {
     usr.phone = usr.contact.phone;
    }
     if(usr.Contact.IAM_Internal__c==True){
            usr.IAM_UserDn__c='uid='+usr.Contact.Username__c+',ou=employee,ou=people,dc=cummins,dc=com';
        }else if(usr.Contact.IAM_Internal__c==False){
            usr.IAM_UserDn__c='uid='+usr.Contact.Username__c+',ou=external,ou=people,dc=cummins,dc=com';
    }
     //Start-CHG0083323-Username to be in email format break fix -@Suresh - To validate username in email format
     String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,10}$';     
     Pattern MyPattern = Pattern.compile(emailRegex);    
     Matcher MyMatcher = MyPattern.matcher(usr.Contact.Username__c);
     Boolean isUserNameValid=  MyMatcher.matches();
     //End- CHG0083323-Username to be in email format break fix-@Suresh - To validate username in email format

     if (system.label.IAM_org_label != '.cso') {
     System.debug('Prirnitng !cso'+usr.FederationIdentifier);
     if(usr.Contact.IAM_Legacy_User__c== false || (usr.Contact.IAM_Legacy_User__c== true&&isUserNameValid))  // CHG0083323-Username to be in email format break fix -@Suresh
      usr.Username = usr.Contact.Username__c;
         
      if(isReclaim&&usr.profile.Name.ContainsIgnoreCase('CSS_')){
      usr.IAM_UID__c=usr.FederationIdentifier;
      }else{
        if(!String.isEmpty(usr.Contact.IAM_Ext_Legacy_Uid__c)){
        usr.IAM_UID__c=usr.Contact.IAM_Ext_Legacy_Uid__c;
        }else{
        usr.IAM_UID__c=usr.Contact.Username__c ;   
        }
      }
     } else {
        if(usr.Contact.IAM_Legacy_User__c== false || (usr.Contact.IAM_Legacy_User__c== true&&isUserNameValid))  // CHG0083323-Username to be in email format break fix -@Suresh
        usr.Username = usr.Contact.Username__c;
      if(isReclaim&&usr.profile.Name.ContainsIgnoreCase('CSS_')){
      usr.IAM_UID__c=usr.FederationIdentifier;
      }else{
        if(!String.isEmpty(usr.Contact.IAM_Ext_Legacy_Uid__c)){
        usr.IAM_UID__c=usr.Contact.IAM_Ext_Legacy_Uid__c;
        }else{
        usr.IAM_UID__c=usr.Contact.Username__c ;   
        }   
      }
     }
     if (usr.Contact.LastName.length() >= 4) {
        Usr.alias = usr.Contact.FirstName.substring(0, 1) + '' + usr.Contact.LastName.substring(0, 4);
     } else if (usr.Contact.LastName.length() <= 2 && usr.Contact.FirstName.length() <= 2) {
        Usr.alias = usr.Contact.FirstName + '' + usr.Contact.LastName;
     } else {
        Usr.alias = usr.Contact.FirstName.substring(0, 4 - usr.Contact.LastName.length()) + '' + usr.Contact.LastName;
     }
     
     if(usr.Contact.Account.id != NULL) {
           usr.CompanyName = usr.Contact.Account.name;
      }
      if(usr.Contact.IAM_Promotion__c!=Null){
          usr.IAM_Promotion__c=usr.Contact.IAM_Promotion__c;
      }
      
     if(usr.Contact.Account.CMI_Account_Num__c != Null)
        usr.IAM_Account_Number__c  = usr.Contact.Account.CMI_Account_Num__c;
     if(usr.Contact.Account.IAM_Service_Provider_Code__c != Null)
        usr.IAM_SP_Code__c = usr.Contact.Account.IAM_Service_Provider_Code__c;
      
      //********** new fields ***************/
      usr.CompanyName = usr.Contact.Account.Name;
        if(usr.Contact.Account.Type == 'Distributor Account') {
         if(usr.Contact.Account.CSS_DistributorCode__c != NULL)
           usr.Division = usr.Contact.Account.CSS_DistributorCode__c;
        }
        else if(usr.Contact.Account.Type == 'Distributor Branch Account') {
          if(usr.Contact.Account.CSS_DistributorCode__c != NULL)
             usr.Division = usr.Account.CSS_DistributorCode__c;
           if(usr.Contact.Account.CSS_DBCode__c != NULL)
             usr.Department = usr.Account.CSS_DBCode__c;
        }
        
        else if(usr.Contact.Account.Type == 'Dealer Account') {
         if(usr.Contact.Account.parent.Type == 'Distributor Account') {
           if(usr.Contact.Account.CSS_DistributorCode__c != NULL)
             usr.Division = usr.Contact.Account.CSS_DistributorCode__c;
           if(usr.Contact.Account.CSS_DealerCode__c != NULL)
             usr.Department = usr.Contact.Account.CSS_DealerCode__c;
          }
         else if(usr.Contact.Account.parent.Type == 'Dealer Account') {
           if(usr.Contact.Account.CSS_DBCode__c != NULL)
              usr.Division = usr.Contact.Account.CSS_DBCode__c;
            if(usr.Contact.Account.CSS_DealerCode__c != NULL)
              usr.Department = usr.Contact.Account.CSS_DealerCode__c;
         }
        }
        else {
          if(usr.Contact.Account.IAM_Service_Provider_Code__c != NULL)
             usr.Department = usr.Contact.Account.IAM_Service_Provider_Code__c;
        } 
        if(usr.contact.Account.CSS_DistributorCode__c != NULL)              
           usr.IAM_Distributorcode__c = usr.Contact.Account.CSS_DistributorCode__c;
        if(usr.Contact.Account.CSS_DBCode__c != NULL)
           usr.IAM_Distributorbranchcode__c = usr.Contact.Account.CSS_DBCode__c;
        if(usr.Contact.Account.CSS_DealerCode__c != NULL)   
           usr.IAM_Dealercode__c = usr.Contact.Account.CSS_DealerCode__c;
          //Start-CHG0094522 - Customer code/Dealer code not updated on user record-@Suresh
        //- Added for updating dealer code with customer code when Account Type is dealer accounts as dealer code is must for dealer accounts-@Suresh
        else
        { 
          usr.IAM_Dealercode__c='';
          //Start-CHG0109043 - Dealer code not updated for customer type account on user record-@Kamini
          if(usr.Contact.Account.Type == 'Dealer Account' || usr.Contact.Account.Type == 'Customer')
          //End-CHG0109043 - Dealer code not updated for customer type account on user record-@Kamini
              usr.IAM_Dealercode__c=usr.Contact.Account.IAM_Service_Provider_Code__c;
        }
        usr.IAM_Customercode__c = usr.Contact.Account.IAM_Service_Provider_Code__c; 
        //End-CHG0094522 - Customer code/Dealer code not updated on user record-@Suresh
       
        if(usr.Contact.Account.IAM_Service_Provider_Code__c != NULL) {
            if(usr.Contact.Account.parent.Type == 'Fleet' || usr.Contact.Account.Type=='Fleet'){ //Added Fleet Account Type in the condition -CHG0094522 - Customer code/Dealer code not updated on user record-@Suresh
                usr.IAM_Fleetcode__c = usr.Contact.Account.IAM_Service_Provider_Code__c;
                usr.Fleet_Code__c=usr.Contact.Account.IAM_Service_Provider_Code__c;
            }
           usr.IAM_SP_Code__c = usr.Contact.Account.IAM_Service_Provider_Code__c;
        }
        if(usr.Contact.Account.IAM_ABO_Code_Formula__c != NULL) {
           usr.IAM_Abocode__c = usr.Contact.Account.IAM_ABO_Code_Formula__c; //IAM_Service_Provider_Code__c
         }
                          
        if(usr.Contact.Account.CMI_CId__c != NULL) 
           usr.IAM_Account_Number__c = usr.Contact.Account.CMI_CId__c;
         // SES_Customercode__c =
         //Identity_Approver__c =
         // SES_Sn__c = contact.
         System.debug('updating user application group .......... ' + usr.contact.IAM_Applications__c);
         if(usr.contact.IAM_Applications__c != NULL)
          {
            usr.IAM_Applicationgroups__c= usr.contact.IAM_Applications__c;
          }
          else if(usr.contact.IAM_Applications__c == ''|| usr.contact.IAM_Applications__c == null)
           usr.IAM_Applicationgroups__c= '';
         System.debug('updating user application role .......... ' + usr.contact.IAM_Application_Roles__c);
         if(usr.contact.IAM_Application_Roles__c != NULL)
          {
            usr.IAM_Application_Roles__c= usr.contact.IAM_Application_Roles__c;
          }
          else if(usr.contact.IAM_Application_Roles__c==''||usr.contact.IAM_Application_Roles__c == null)
           usr.IAM_Application_Roles__c= '';
         
         /*if(usr.contact.IAM_Qsolexpiration__c != NULL)           
            usr.IAM_Qsolexpiration__c = usr.contact.IAM_Qsolexpiration__c;
         if(usr.contact.IAM_swregexpire__c != NULL)        
            usr.IAM_swregexpire__c = usr.contact.IAM_swregexpire__c;
         */
         if(usr.contact.IAM_Qsolview__c != NULL) 
            usr.IAM_Qsolview__c = usr.contact.IAM_Qsolview__c;
         if(usr.contact.IAM_Final_Approver__c != NULL) 
            usr.IAM_Final_Approver__c = usr.contact.IAM_Final_Approver__c;
            
            
            //below boolean condition can be executed all the time ie is when user is assigned a guidanz applicaiton and user is 
            //removed from Guidanz application. 
            
            List<profile> cssprofiles = [select id,name from profile where name like 'CSS_%' OR name like 'EVL_%'];
                      Map<string,id> cssprofmap = new Map<string,id>();
                        for(profile pf:cssprofiles){
                            cssprofmap.put(pf.name,pf.id);
                        } 
            if(perform){
            
                if(mapConProvCSS.ContainsKey(usr.Contactid)){
                   
                        appGuidanz=mapConProvCSS.get(usr.Contactid);
                        System.debug('Printing guidanz application'+appGuidanz); 
                       //Now setting ProfileCSS value depending upon the role and Account 
                        if(usr.Contact.Account.Type!='Distributor Account'||usr.Contact.Account.Type!='Distributor Branch Account'||usr.Contact.Account.Type!='Factory'){//for all other types of account types
                           System.debug('entering profile selection'+appGuidanz.IAM_Role__c);
                           //fix - azaz - if user have both role then Advance has higher priority 
                           if(appGuidanz.IAM_Role__c=='Technician;Advanced' || appGuidanz.IAM_Role__c=='Advanced;Technician'){
                               portalRole='Executive';
                               if(!usr.contact.Account.IsPartner){
                                    pCSS.id=cssprofmap.get(System.label.dealer_advanced);
                                }else{
                                    pCSS.id=cssprofmap.get('EVL_Dealer_Advanced');
                                }
                                if(permissionSetMap.containsKey(Label.IAM_GuidanzPSet_EVLDealerAdv)) {
                                    pid = permissionSetMap.get(Label.IAM_GuidanzPSet_EVLDealerAdv);
                                }
                           }else if(appGuidanz.IAM_Role__c=='Advanced'){
                                //need to set role and Profile
                               portalRole='Executive';
                                if(!usr.contact.Account.IsPartner){
                                    pCSS.id=cssprofmap.get(System.label.dealer_advanced);
                                }else{
                                    pCSS.id=cssprofmap.get('EVL_Dealer_Advanced');
                                }
                                if(permissionSetMap.containsKey(Label.IAM_GuidanzPSet_EVLDealerAdv)) {
                                    pid = permissionSetMap.get(Label.IAM_GuidanzPSet_EVLDealerAdv);
                                }
                            }else if(appGuidanz.IAM_Role__c=='Technician'){
                                //need to set role and Profile for Technician.
                                portalRole='Worker';
                                if(!usr.contact.Account.IsPartner){
                                    pCSS.id=cssprofmap.get(System.label.dealer_technician);
                                }else{
                                    pCSS.id=cssprofmap.get('EVL_Dealer_Technician');
                                } 
                                if(permissionSetMap.containsKey(Label.IAM_GuidanzPSet_EVLDealerTechnician)) {
                                    pid = permissionSetMap.get(Label.IAM_GuidanzPSet_EVLDealerTechnician);
                                }
                            }else if(appGuidanz.IAM_Role__c=='Read Only'){
                                portalRole='Worker';
                                if(!usr.contact.Account.IsPartner){
                                    pCSS.id=cssprofmap.get('CSS Read Only');
                                }else{
                                    pCSS.id=cssprofmap.get('EVL_Dealer_Readonly');
                                } 
                            }
                            //Guidanz Evolution Changes 
                            //@Suresh- Comment out below lines as per CHG0093354
                            //usr.UserPermissionsKnowledgeUser=True;
                            //usr.UserPermissionsOfflineUser=True;
                            usr.UserPermissionsSFContentUser=True;
                            //end of Guidanz Evolution Changes
                        }
                        System.debug('Printing Profile that need to be aasigned'+pCSS.id);
                       //Assaigning new profile to the User record 
                       usr.Profileid=pCSS.id; 
                       usr.PortalRole =portalRole;
                       isProfileChange=true;          // Code Addition for CHG0093354 -@Suresh -24/02/2022
                }else{
                    //User was removed from Guiandz access and hi profile need to be updated
                    //Since we cannot degrade user license from Community plus to External Identity. we compare the exssiiting profile and update the user profile accordingly.
                    if(usr.UserPermissionsSFContentUser==True)
                    usr.UserPermissionsSFContentUser=false;    
                    if(usr.Profile.id==cssprofmap.get(System.label.dealer_technician)||usr.Profile.id==cssprofmap.get(System.label.dealer_advanced)){
                        System.debug('Printing Profile that need to be aasigned if already assinged guidanz.......');
                        usr.Profileid=System.Label.IAM_User_Community_ProfileID;
                        }else {
                         //Start - Updating the Profile on Edit User,based on Site Admin check
                         /* fix - azaz- redundant code so commented out.
                            profile pSiteAdmin=[select id from Profile where name='IAM_Site_Admin_Community'];
                            profile pSiteUser= [select id from Profile where name='IAM User'];
                            if(usr.Contact.CMI_Contact_Type__c=='Secondary' && usr.Contact.IAM_Site_Admin__c==True){
                                    System.debug('came secondary and site admin is true'+pSiteAdmin);
                                    usr.Profileid=pSiteAdmin.id;
                            }
                            if(usr.Contact.CMI_Contact_Type__c=='Secondary' && usr.Contact.IAM_Site_Admin__c==False){
                                    System.debug('came secondary and site admin is False'+pSiteUser);
                                     usr.Profileid=pSiteUser.id;
                            }*/
                            //End - Updating the Profile on Edit User,based on Site Admin check
                        }   
                
                }
                   
            }else{ 
              if(!conAppMarketPlace.isEmpty()){
                system.debug('Marketplace App user:'+conAppMarketPlace.containsKey(usr.Contact.id));
                if(usr.Profile.Name != 'IAM_Site_Admin_Community' && conAppMarketPlace.containsKey(usr.Contact.id) && !usr.Profile.name.startsWithIgnoreCase('CSS')&& !usr.Profile.name.startsWithIgnoreCase('DBU') && usr.Profile.UserLicense.Name !='Customer Community Plus' &&usr.Profile.UserLicense.Name !='Partner Community'){
                   system.debug('User profile update to Site Admin');
                   profile pSiteAdmin=[select id from Profile where name='IAM_Site_Admin_Community'];
                   usr.Profileid=pSiteAdmin.id;
                   isProfileChange=true;          // Code Addition for CHG0093354 -@Suresh -24/02/2022
               }  
              }  
    }
                //Addition if new fields.
                if(usr.contact.IAM_is_Member_of__c != '' || usr.Contact.IAM_is_Member_of__c != null)
                usr.IAM_is_Member_of__c=usr.Contact.IAM_is_Member_of__c;
                if(usr.Contact.IAM_Work_Group_Id__c!= '' && usr.Contact.IAM_Work_Group_Id__c != null) 
                 usr.IAM_WorkGroup_id__c=usr.Contact.IAM_Work_Group_Id__c;
                if(usr.Contact.IAM_Product_Group_Access__c!= '' && usr.Contact.IAM_Product_Group_Access__c != null) 
                  usr.Product_Group_Access__c=usr.Contact.IAM_Product_Group_Access__c;
                // added more fields
                usr.IAM_Account__c = usr.Contact.Accountid;
                if(usr.Contact.phone != null && usr.Contact.phone != '')
                usr.phone = usr.Contact.phone;
                //end of IAM fields
                
                //Assigning Guidanz fields on user creation.these can be there for each user and the same fields needs to be update on user record when a user is assaigned a record
               if(usr.Contact.Account.IAM_Service_Provider_Code__c != '' && usr.Contact.Account.IAM_Service_Provider_Code__c != null)
                 usr.Work_Group_Name__c=usr.Contact.Account.IAM_Service_Provider_Code__c; //basically cutomer code of the Account
               if(usr.Contact.Account.Location__c != '' && usr.Contact.Account.Location__c != null)  
                usr.User_Location__c=usr.Contact.Account.Location__c;  //feild on Account Location__C
                usr.UserGroup__c='EDS_USER';  //CAn be hard coded to EDS User
                
                if(usr.Contact.IAM_Work_Group_Id__c != '' && usr.Contact.IAM_Work_Group_Id__c != null) {
               
               /* List<String> s=usr.Contact.IAM_Work_Group_Id__c.split(';');
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
                string wrkgrpID = string.join(ad,';');
                usr.CSS_User_MultiLocValues__c=wrkgrpID;// In this field users should have all Work group ids with ; seperated values.*/
                 usr.CSS_User_MultiLocValues__c=usr.Contact.IAM_Work_Group_Id__c.replace('|', ';');
                //End of Guidanz Fields
              } 
                //Address fields need to be populated on the user record from Account
                usr.Street=usr.Contact.Account.BillingStreet;
                usr.City=usr.Contact.Account.BillingCity;
                usr.Country=usr.Contact.Account.BillingCountry;
                usr.postalCode=usr.Contact.Account.BillingPostalCode;
                //DBU related fields
                if(usr.Contact.Account.IAM_Movex_Customer_Code__c!=null && usr.Contact.Account.IAM_Movex_Customer_Code__c!=''){
                    usr.IAM_Movex_Customer_Code__c=usr.Contact.Account.IAM_Movex_Customer_Code__c;
                }
                if(appCumpasMap.ContainsKey(usr.Contact.Accountid)){
                    if(appCumpasMap.get(usr.Contact.Accountid).IAM_Cumpas_Modularity__c!=null && appCumpasMap.get(usr.Contact.Accountid).IAM_Cumpas_Modularity__c!=''){
                        usr.IAM_Location_Modular_Access__c=appCumpasMap.get(usr.Contact.Accountid).IAM_Cumpas_Modularity__c;
                    }
                     if(appCumpasMap.get(usr.Contact.Accountid).IAM_Cumpas_Dist_CS_Rep__c!=null){
                        if(CumpasDistCSRep.containsKey(appCumpasMap.get(usr.Contact.Accountid).IAM_Cumpas_Dist_CS_Rep__c)){
                        System.debug('Printing cs rep');
                            usr.IAM_Cumpas_Distributor_CSRep__c=CumpasDistCSRep.get(appCumpasMap.get(usr.Contact.Accountid).IAM_Cumpas_Dist_CS_Rep__c).Username__c;
                        }
                    }
                    if(appCumpasMap.get(usr.Contact.Accountid).IAM_Cumpas_Distributor_Sales_Rep__c!=null ){
                        if(CumpasDistSR.ContainsKey(appCumpasMap.get(usr.Contact.Accountid).IAM_Cumpas_Distributor_Sales_Rep__c)){
                            System.debug('Printing Sales rep');
                            usr.IAM_Cumpas_Distributor_Sales_Rep__c=CumpasDistSR.get(appCumpasMap.get(usr.Contact.Accountid).IAM_Cumpas_Distributor_Sales_Rep__c).Username__c;
                        }
                    }
                }
                
                
                if(appQSOLMap.ContainsKey(usr.Contact.Accountid)){
                System.debug('Printing QSOL applicaiton name'+appQSOLMap.ContainsKey(usr.Contact.Accountid));
                System.debug('Printing QSOL expiration value'+appQSOLMap.get(usr.Contact.Accountid).IAM_Qsolexpiration__c);
                System.debug('Printing QSOL expiration'+usr.IAM_Qsolexpiration__c);
                    /*if(appQSOLMap.get(usr.Contact.Accountid).IAM_Qsolexpiration__c!=null && appQSOLMap.get(usr.Contact.Accountid).IAM_Qsolexpiration__c!=''){
                        usr.IAM_Qsolexpiration__c=appQSOLMap.get(usr.Contact.Accountid).IAM_Qsolexpiration__c;
                    }*/
                     if(appQSOLMap.get(usr.Contact.Accountid).IAM_License_Type__c!=null && appQSOLMap.get(usr.Contact.Accountid).IAM_License_Type__c!=''){
                        usr.IAM_License_Type__c=appQSOLMap.get(usr.Contact.Accountid).IAM_License_Type__c;
                    }
                }
                 //fields for QSOL expiration and Guidanz Mobile
                
                if(mapConAppQSOL.ContainsKey(usr.Contact.id)){
                    if(!(mapConAppQSOL.get(usr.Contact.id)).isEmpty()){
                    System.debug('Printing QSOL app feature'+(mapConAppQSOL.get(usr.Contact.id)).size());
                    System.debug('Printing QSOL app condition'+((mapConAppQSOL.get(usr.Contact.id)).size()>1));
                        if((mapConAppQSOL.get(usr.Contact.id)).size()>1){
                            String finalQSOLExp='';
                            for(IAM_Contact_Provisioning__c icon: mapConAppQSOL.get(usr.Contact.id)){
                            System.debug('Printing QSOL'+ icon.IAM_Qsolexpiration__c);
                                finalQSOLExp+=icon.IAM_Qsolexpiration__c+'|';
                            }
                            System.debug('Printing final String'+finalQSOLExp); 
                            if(!String.isBlank(finalQSOLExp)){    
                                usr.IAM_Qsolexpiration__c=finalQSOLExp.removeEnd('|');
                            }
                        }else if((mapConAppQSOL.get(usr.Contact.id)).size()==1){
                        System.debug('Printing size =1 QSOL Expiration');
                            if(mapConAppQSOL.get(usr.Contact.id)[0].IAM_Qsolexpiration__c!=''&& mapConAppQSOL.get(usr.Contact.id)[0].IAM_Qsolexpiration__c!=null){
                                usr.IAM_Qsolexpiration__c=mapConAppQSOL.get(usr.Contact.id)[0].IAM_Qsolexpiration__c;
                            }
                        }
                    }   
                }else{
                    //This condition is to update QSOL expiration field to empty on the user record when there are no records.
                        usr.IAM_Qsolexpiration__c='';
                        usr.IAM_Qsolview__c = '';
                    } 
                
                
                
                //Fields for Guidanz mobile Sreg
                 if(mapConAppGM.ContainsKey(usr.Contact.id)){
                    if(!(mapConAppGM.get(usr.Contact.id)).isEmpty()){
                        if((mapConAppGM.get(usr.Contact.id)).size()>1){
                            String finalSWreg='';
                            for(IAM_Contact_Provisioning__c icon: mapConAppGM.get(usr.Contact.id)){
                                if(!String.isBlank(icon.IAM_swregExpire__c)){
                                    finalSWreg+=icon.IAM_swregExpire__c+'|';
                                }
                                System.debug('Printing size =1 swreg Expiration'+finalSWreg);
                            } 
                            if(!String.isBlank(finalSWreg)){    
                                usr.IAM_swregExpire__c=finalSWreg.removeEnd('|');
                            }
                            else{
                                usr.IAM_swregExpire__c='';
                            }
                        }else if((mapConAppGM.get(usr.Contact.id)).size()==1){
                            
                            if(mapConAppGM.get(usr.Contact.id)[0].IAM_swregExpire__c!=''&& mapConAppGM.get(usr.Contact.id)[0].IAM_swregExpire__c!=null){
                                usr.IAM_swregExpire__c=mapConAppGM.get(usr.Contact.id)[0].IAM_swregExpire__c;
                            }
                            else{
                                usr.IAM_swregExpire__c='';
                            }
                        }
                    }   
                }else{
                        usr.IAM_swregExpire__c='';
                        //usr.IAM_Qsolexpiration__c = '';
                        //usr.IAM_Qsolview__c = '';
                        system.debug('====wre are upating the IAM_swregExpire__c=====');
                    
                    } 
                
               
               /* if(appguidanzmobileMap.ContainsKey(usr.Contact.Accountid)){
                    if(appguidanzmobileMap.get(usr.Contact.Accountid).IAM_swregExpire__c!=null && appguidanzmobileMap.get(usr.Contact.Accountid).IAM_swregExpire__c!=''){
                        usr.IAM_swregExpire__c=appguidanzmobileMap.get(usr.Contact.Accountid).IAM_swregExpire__c;
                    }
                  }*/
                
                
                if(usr.Contact.Account.IAM_WWSPS_Regions__c!=null&&usr.Contact.Account.IAM_WWSPS_Regions__c!=''){
                    usr.IAM_WWSPS_Region__c=usr.Contact.Account.IAM_WWSPS_Regions__c;
                }
                if(usr.Contact.Account.Type!=null && usr.Contact.Account.Type!='' ){    
                    usr.IAM_Type_of_Location__c=usr.Contact.Account.Type;
                 }
          //Start D-3224    
                    if(usr.Contact.Account.Type!=null && usr.Contact.Account.Type!='' && usr.Contact.Account.Type=='Internal'){
                    usr.IAM_SP_Code__c='';
                    usr.IAM_Distributorbranchcode__c='';
                    usr.IAM_Distributorcode__c='';
                    usr.IAM_WorkGroup_id__c='';
                    }
//End D-3224           
                //end of DBU related fields
                //Start - Updating the Profile on Edit User,based on Site Admin check
                /* fix - azaz- redundant code so commented out.
                profile pSiteAdmin=[select id from Profile where name='IAM_Site_Admin_Community'];
                profile pSiteUser= [select id from Profile where name='IAM User'];
                if(usr.Contact.CMI_Contact_Type__c=='Secondary' && usr.Contact.IAM_Site_Admin__c==True){
                        System.debug('came secondary and site admin is true'+pSiteAdmin);
                         usr.Profileid=pSiteAdmin.id;
                }
                if(usr.Contact.CMI_Contact_Type__c=='Secondary' && usr.Contact.IAM_Site_Admin__c==False){
                        System.debug('came secondary and site admin is False'+pSiteUser);
                         usr.Profileid=pSiteUser.id;
                }*/
                //End - Updating the Profile on Edit User,based on Site Admin check
                //end of addition
                
                //Amarnath Mishra added logic for the swregexpire synch 
                if(usr.Contact.Location_Change__c == true ){
                    
                    usr.IAM_Applicationgroups__c = '';
                    usr.IAM_Application_Roles__c = '';
                    usr.IAM_swregexpire__c = '';
                    usr.IAM_Qsolexpiration__c = '';
                    usr.IAM_Qsolview__c = '';
                    /* 12/03/2020 - Added NPBU Diagnostic Expration */
                    usr.IAM_NpbuDiagExpire__c = '';
                }  
                
         //Amarnath added for the field update of connected solution on the user object
            Boolean hasconnectedSolutionApplication = false;
            if(!mapConatactIdlstContactProvisions.isEmpty()){
                if(mapConatactIdlstContactProvisions.ContainsKey(usr.Contactid)){
                    for(IAM_Contact_Provisioning__c contactpro:mapConatactIdlstContactProvisions.get(usr.Contactid)){
                        if(contactpro.IAM_Application_Name__c == System.Label.IAM_AppName_ConnectedSolutions){
                            hasconnectedSolutionApplication = true;
                            //Added this as part of DA Enhancement - Assign parent level Account# to user as the customer list value for DA locations.
                            if(string.isNotBlank(contactpro.IAM_DA_Customer_List__c) && contactpro.IAM_Contact__r.Account.Parent.Type == 'NATIONAL ACCT_CIHR - HQ'){
                                System.debug('***Adding account parent CID ***');
                                 usr.CMI_Customer_List__c = contactpro.IAM_Contact__r.Account.Parent.CMI_CId__c;
                             }   
                            if(string.isNotBlank(contactpro.IAM_DA_Customer_List__c)){
                                usr.CMI_Customer_List__c = contactpro.IAM_DA_Customer_List__c;
                            }
                            if(string.isNotBlank(contactpro.IAM_Role__c)){
                                usr.CMI_Calibration_Role__c = contactpro.IAM_Role__c;
                            }
                            if(string.isNotBlank(contactpro.IAM_User_Type__c)){
                                usr.IAM_User_Type__c = contactpro.IAM_User_Type__c;
                            }
                            
                        }
                    }
                }
            }
            
            if(!hasconnectedSolutionApplication){
                usr.CMI_Customer_List__c = '';
                usr.CMI_Calibration_Role__c='';
                usr.IAM_User_Type__c = '';
            }
      
    userListUpdate.add(usr);
    userObj = usr;
    // To store Guidanz permission set for multiple users 
   if(pid!=null)
   guidanzPSAssignmentList.add(new PermissionSetAssignment(PermissionSetId = pid, AssigneeId = userObj.Id));
    }
    System.debug('userListUpdate..........1234  '+userListUpdate);
        try{
            // Start - Code Addition for CHG0093354 -@Suresh -24/02/2022- below code is to retrieve existing permission set
            List<PermissionSetAssignment> psAssignmentList = new List<PermissionSetAssignment>();
            System.debug('#### isProfileChange - '+isProfileChange);
            if(isProfileChange == true)
            {
                System.debug('#### Inside If  - Existing PS');
                List<PermissionSetAssignment> existingPSAssignmentList = [
                SELECT Id
                     , PermissionSetId
                     , AssigneeId
                  FROM PermissionSetAssignment
                 WHERE AssigneeId IN :userListUpdate
            ];
            System.debug('#### existingPSAssignmentList - '+existingPSAssignmentList);
                
            if(!existingPSAssignmentList.isEmpty()) {
                List<PermissionSetAssignment> oldPSAList = new List<PermissionSetAssignment>();
                for(PermissionSetAssignment psa : existingPSAssignmentList) {
                    psa.Id = null;
                    oldPSAList.add(psa);
                }
                psAssignmentList.addAll(oldPSAList);
                System.debug('#### existingPSAssignmentList without Ids - '+oldPSAList);
                System.debug('#### Old & New Permission Set To Assign - '+ psAssignmentList);
            }
            }
          // End - Code Addition for CHG0093354 -@Suresh -24/02/2022
    if(userListUpdate.size() >0 && !userListUpdate.isEmpty()&&!Test.isRunningTest()) {
    update userListUpdate;
    if(isProfileChange == true && userObj != null) {
        //PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = pid, AssigneeId = userObj.Id);          
        //Database.SaveResult[] saveResult = Database.insert(new List<PermissionSetAssignment> {psa},false);
        //if(pid!=null)
        //psAssignmentList.add(new PermissionSetAssignment(PermissionSetId = pid, AssigneeId = userObj.Id));
        if(!guidanzPSAssignmentList.isEmpty())
          psAssignmentList.addAll(guidanzPSAssignmentList);
        Database.SaveResult[] saveResult = Database.insert(psAssignmentList,false);
        System.debug('#### saveResult - '+ saveResult);
    }
    }
        }catch(Exception e){
            String processedData = 'Users To Update - ' + userListUpdate;
            ID jobID = System.enqueueJob(new IAM_ErrorHandling_Queueable(processedData,'Identity - User Update',
            e.getStackTraceString() + ' - ' + e.getMessage(), IAM_contactHelperClass.class.getName(),userObj.Contact.Username__c));
            System.debug('Printing Job ID IAM_ErrorHandling_Queueable'+jobID);
            System.debug('Printing exception'+e);
            System.debug('Printing Stack Trace String'+e.getStackTraceString());
        }
    System.debug('mapConProvCSS..............   '+mapConProvCSS);
       }
        
    //logic to update Account and Contact provisioning status to Active if contact become active 
    public static void updateAppContactProStatus(List<Contact> lstCont){
        List<IAM_Contact_Provisioning__c> lstContProv = [select id, IAM_Status__c, IAM_Account_Application__c from IAM_Contact_Provisioning__c where IAM_Contact__c in: lstCont];
        Set<id> setContProvId = new Set<id> ();
        List<id> lstContProvId = new List<id>();
        List<IAM_Application__c> lstAccProv = null;
        List<IAM_Contact_Provisioning__c> lstUpdateContProv = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Application__c> lstUpdateAccProv = new List<IAM_Application__c>();

        if(null != lstContProv && lstContProv.size() > 0){
            for(IAM_Contact_Provisioning__c contProv : lstContProv){
                contProv.IAM_Status__c = System.Label.IAM_Status_Active;
                lstUpdateContProv.add(contProv);
                setContProvId.add(contProv.IAM_Account_Application__c);
            }
            lstContProvId.addAll(setContProvId);
            System.debug('lstContProvId.. '+lstContProvId);
            lstAccProv = [select id,IAM_Status__c from IAM_Application__c where id in: lstContProvId];
            System.debug('lstAccProv .. '+lstAccProv );
            for(IAM_Application__c AccProv : lstAccProv){
                AccProv.IAM_Status__c = System.Label.IAM_Status_Active;
                lstUpdateAccProv.add(AccProv);
            }
            
            try{
            if(lstUpdateContProv.size() > 0)
                update lstUpdateContProv;
                
            if(lstUpdateAccProv.size() > 0)
                update lstUpdateAccProv;    
            }Catch(Exception ex){
            }
        }
    }  

    //logic to update contact/user if contact is created with Active status
    public static void updateContact_User(List<Contact> lstCont){
        System.debug('Printing updateContact_User...  lstCont... '+lstCont);
        List<user> lstUser = [select id,isActive,contactid from user where contactid in: lstCont];
        Map<id,User> mapUser = new Map<id,User>();
        List<user> updateUser = new List<user>();
        List<Contact> lstCreateUser = new List<Contact> ();
        
        for(User usr : lstUser){
            if(!mapUser.ContainsKey(usr.contactid))
                mapUser.put(usr.contactid,usr);
        }
        System.debug('Printing updateContact_User...  mapUser... '+mapUser);
        for(Contact con : lstCont){
            if(con.IAM_Contact_Status__c == 'Active'){
                
                if(mapUser.ContainsKey(con.id)){
                    if(mapUser.get(con.id).isActive == False){
                        //then simply update the user record to true
                        mapUser.get(con.id).isActive = True;
                        updateUser.add(mapUser.get(con.id));
                    }
                }else{
                    //Need to create user.
                    lstCreateUser.add(con);
                }               
            }
        }
        
        System.debug('Printing return lstCreateUser... '+ lstCreateUser);
        if(lstCreateUser.size() > 0){
             String Value=IAM_CreateUser.CreateUser(lstCreateUser);
             System.debug('Printing return value for create user ...lstCreateUser... '+ Value);
        }
        System.debug('Printing return updateUser... '+ updateUser);
        if(updateUser.size() > 0){
            try{
                Database.SaveResult[] lstSR = Database.update(updateUser, false);
                // Iterate through the Save Results 
                for(Database.SaveResult sr : lstSR){
                    // fetch all success DML id's in this set
                    if(sr.isSuccess()){
                        IAM_AccountsController.setpass(sr.getId());
                    }
                }
                
            }catch(exception e){
                System.debug('error while resetting password.... ' + e.getMessage());
            }    
        }
    }

    //logic to get contact fields which is needed for user creation.
    public static List<Contact> getContactForUser(set<id> conIds){
        return [select id,firstname,lastname,email,phone,IAM_Site_Admin__c,IAM_Site_Admin_Role__c,Account.CMI_Account_Num__c,IAM_Internal__c, Accountid,Account.Name,CMI_Contact_Type__c,
                   Username__c,IAM_Final_Approver__c,Account.IAM_ABO_Code_Formula__c,IAM_Applications__c,Account.IAM_Service_Provider_Code__c,
                   Account.CSS_DBCode__c,Account.Ownerid,Account.CSS_DistributorCode__c,Account.parentid,IAM_is_Member_of__c,IAM_Work_Group_Id__c,IAM_Qsolexpiration__c,
                   IAM_Qsolview__c,IAM_Product_Group_Access__c,Account.Location__c,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,
                   Account.BillingPostalCode,Account.CSS_Locale__c,Account.CSS_Language__c,Account.CSS_Timezone__c,Account.Type,Account.IAM_Movex_Customer_Code__c,
                   Account.IAM_WWSPS_Regions__c,IAM_Contact_Status__c,IAM_Legacy_User__c  from Contact where id in :conIds];
    }

     //This method udpate Account physical address from EDQ and call GL service and update parent account,distributor code and wwsps region..
    @future(callout=true)
    public static void AccountEDQGLUpdate(Set<Id> conIds){
        isCalledEDQGL = true;
        System.debug('AccountEDQGLUpdate ... begins.... '+conIds); 
        List<Account> lstAcc = [select id,parentid,BillingStreet,BillingCity,BillingPostalCode,CMI_Address2__c,BillingCountryCode,BillingStateCode,BillingCountry,Name   from Account 
                                     where id in: conIds];
        List<Account> lstUpdateAcc = new List<Account>();
        System.debug('AccountEDQGLUpdate ... .... lstAcc... '+lstAcc);
        for(Account acc : lstAcc){
            IAM_EDQ_LocationResParser EDQinfo = IAM_EDQ_AddressCleanse.EDQAddress(acc);
            System.debug('AccountEDQGLUpdate ... .... EDQinfo... '+EDQinfo);
            if(EDQinfo!=null){
                 for(IAM_EDQ_LocationResParser.Location loc : EDQinfo.AddressCleanse.Location){
                        //Account acc = new Account();
                        acc.BillingStreet = loc.GeographicalArea.StreetAddress.AddressLine1txt;
                        acc.CMI_Address2__c = loc.GeographicalArea.StreetAddress.AddressLine2txt;
                        acc.BillingCity = loc.GeographicalArea.City.CityID;
                        acc.BillingCountryCode = loc.GeographicalArea.Country.CountryName;
                        acc.BillingStateCode = loc.GeographicalArea.City.TerritoryID;
                        acc.BillingPostalCode = loc.GeographicalArea.PostalCode.PostalCodeNum;
                        
                 }
                 System.debug('AccountEDQGLUpdate ..after EDQ. .... acc... '+acc); 
                 lstUpdateAcc.add(acc);
            }
        
        
            /*if(acc.BillingStreet != null && acc.BillingCity != null && 
                             acc.BillingCountryCode != null && acc.BillingPostalCode != null){
                IAM_GL_webservice.makeCallout(acc.BillingStreet,acc.BillingCity,acc.BillingCountryCode,acc.BillingPostalCode );
                System.debug('acc.ParentId after EDQGL call.....IAM_GL_webservice.parentDistributorId... '+ IAM_GL_webservice.parentDistributorId);
                if(IAM_GL_webservice.parentDistributorId != null){
                    acc.ParentId = IAM_GL_webservice.parentDistributorId;
                    System.debug('acc.ParentId after EDQGL call........ '+ acc.ParentId);
                    List<Account> AccInfo = [select id,name,CSS_DistributorCode__c,CSS_DBCode__c,CSS_DealerCode__c,IAM_ABO_Code_Formula__c,IAM_WWSPS_Regions__c from Account where id=:IAM_GL_webservice.parentDistributorId];
                    if(!AccInfo.isEmpty()){
                        acc.CSS_DistributorCode__c=AccInfo[0].CSS_DistributorCode__c!=null?AccInfo[0].CSS_DistributorCode__c:''; 
                        acc.CSS_DBCode__c=AccInfo[0].CSS_DBCode__c!=null?AccInfo[0].CSS_DBCode__c:'';
                        acc.IAM_WWSPS_Regions__c=AccInfo[0].IAM_WWSPS_Regions__c!=null?AccInfo[0].IAM_WWSPS_Regions__c:'';
                        
                    }
                    //getParentPrimaryUser(IAM_GL_webservice.parentDistributorId);
                    //System.debug('GL acc AccownerId........ '+AccownerId);
                    //if(AccownerId != null) {
                    //acc.ownerId = AccownerId;
                    //}
                    System.debug('acc record after EDQGL call........ '+acc);
                    lstUpdateAcc.add(acc);
                    
                }
                          
            }*/
        }
        
        if(lstUpdateAcc.size() > 0){
            try{
                update lstUpdateAcc;
                isCalledGL = false;
            }Catch(Exception ex){
                System.debug('Exception during populating EDQGL values on account .... ' + ex.getMessage());
            }
        }
        
        
    }

     //This method udpate Account parent account, distributor code and wwsps region from  GL service ..
    @future(callout=true)
    public static void AccountGLUpdate(Set<Id> conIds){
        isCalledGL = true;
        System.debug('AccountGLUpdate ... begins.... '+conIds); 
        List<Account> lstAcc = [select id,parentid,BillingStreet,BillingCity,BillingPostalCode,CMI_Address2__c,BillingCountryCode,BillingStateCode,BillingCountry from Account 
                                     where id in: conIds];
        List<Account> lstUpdateAcc = new List<Account>();
        System.debug('Account GLUpdate ... .... lstAcc... '+ lstAcc);
        for(Account acc : lstAcc){
            if(acc.BillingStreet != null && acc.BillingCity != null && 
                             acc.BillingCountryCode != null && acc.BillingPostalCode != null ){
                IAM_GL_webservice.makeCallout(acc.BillingStreet,acc.BillingCity,acc.BillingCountryCode,acc.BillingPostalCode);
                if(IAM_GL_webservice.parentDistributorId != null){
                    acc.ParentId = IAM_GL_webservice.parentDistributorId;
                    System.debug('acc.ParentId after GL call........ '+ acc.ParentId);
                    List<Account> AccInfo = [select id,name,CSS_DistributorCode__c,CSS_DBCode__c,CSS_DealerCode__c,IAM_ABO_Code_Formula__c,IAM_WWSPS_Regions__c from Account where id=:IAM_GL_webservice.parentDistributorId];
                    if(!AccInfo.isEmpty()){
                        acc.CSS_DistributorCode__c=AccInfo[0].CSS_DistributorCode__c!=null?AccInfo[0].CSS_DistributorCode__c:''; 
                        acc.CSS_DBCode__c=AccInfo[0].CSS_DBCode__c!=null?AccInfo[0].CSS_DBCode__c:'';
                        acc.IAM_WWSPS_Regions__c=AccInfo[0].IAM_WWSPS_Regions__c!=null?AccInfo[0].IAM_WWSPS_Regions__c:'';
                        
                    }
                    //getParentPrimaryUser(IAM_GL_webservice.parentDistributorId);
                    //System.debug('GL acc AccownerId........ '+AccownerId);
                    //if(AccownerId != null) {
                    //acc.ownerId = AccownerId;
                    //}
                    System.debug('acc record after GL call........ '+acc);
                    lstUpdateAcc.add(acc);
                    
                }
                          
            }
        }
        if(lstUpdateAcc.size() > 0){
            try{
                update lstUpdateAcc;
            }Catch(Exception ex){
                System.debug('Exception during populating GL values on account .... ' + ex.getMessage());
            }
        }
        
        
    }


    //This method will get Record type id based on record type name and object name.
    public static Id getRecordtypeId(String RecTypeName, String objName){
        List<RecordType> lstRecType = [Select Id, Name, sobjecttype from RecordType where name =: RecTypeName and sobjecttype =: objName];
        if(lstRecType.size() > 0)
            return lstRecType[0].id;
        else
            return null;
    }  

    //This method will update reject reason pick list value on Account/Contact provision and contact record. 
    public static void updateRejectReason(Id recordId, String rejectReason, String rejectComments){
        System.debug('updateRejectReason begin ....recordId....  '+recordId);
        try{
            final string OBJ_CONTACT = 'Contact';
            final string OBJ_CONTACTPROV = 'IAM_Contact_Provisioning__c';
            final string OBJ_ACCOUNTPROV = 'IAM_Application__c';
            String objName = IAM_AccountsController.getName(recordId);
            list<IAM_Application__c> lstAccountApp = new list<IAM_Application__c>();
            list<IAM_Contact_Provisioning__c> lstContactApp = new list<IAM_Contact_Provisioning__c>();
            list<Contact> lstContact = new list<Contact>();
            if(objName == OBJ_ACCOUNTPROV){
                lstAccountApp = [select id, IAM_Reject_Reason__c,IAM_Reason__c from IAM_Application__c where id =: recordId];
                lstAccountApp[0].IAM_Reject_Reason__c = rejectReason;
                lstAccountApp[0].IAM_Reason__c = rejectComments;
                lstContactApp = [select id, IAM_Reject_Reason__c,IAM_Reason__c  from IAM_Contact_Provisioning__c where IAM_Account_Application__c =: lstAccountApp];
                lstContactApp[0].IAM_Reject_Reason__c = rejectReason;
                lstContactApp[0].IAM_Reason__c = rejectComments;
            }else if(objName == OBJ_CONTACTPROV){
                lstContactApp = [select id, IAM_Reject_Reason__c, IAM_Reason__c from IAM_Contact_Provisioning__c where id =: recordId];
                lstContactApp[0].IAM_Reject_Reason__c = rejectReason;
                lstContactApp[0].IAM_Reason__c = rejectComments;
            }else if(objName == OBJ_CONTACT){
                system.debug('====Inside contact object=======');
                lstContact = getConProvRecord(recordId);
                lstContact[0].IAM_Reject_Reason__c = rejectReason;
                lstContact[0].IAM_Reason__c = rejectComments;
                lstContact[0].IAM_Deactivation_Mail_Sent__c = true;
                system.debug('=====before if contact provisioning======'+lstContact[0].Contact_Provisionings__r);
                if(!lstContact[0].Contact_Provisionings__r.isEmpty()){
                    system.debug('=====inside contact provisioning======'+lstContact[0].Contact_Provisionings__r);
                    for(IAM_Contact_Provisioning__c conPro : lstContact[0].Contact_Provisionings__r){
                        conPro.IAM_Reject_Reason__c = rejectReason;
                        conPro.IAM_Reason__c = rejectComments;
                        conPro.IAM_Status__c = System.Label.IAM_Inactive_Label;
                        if(conPro.IAM_Contact_Status__c == System.Label.IAM_Rejected_Label)
                            System.debug('need to decide the status');
                        //Amar commented
                        //lstContactApp.add(conPro);
                        system.debug('=====inside loop=======');
                    }
                        
                    
                }
            }
            
            
            if(!lstAccountApp.isEmpty()){
                update lstAccountApp;
                system.debug('=Inside Account provisioning====');
            }    
            if(!lstContact.isEmpty() ){
                update lstContact;
                
                update lstContact[0].Contact_Provisionings__r;
               
                system.debug('===Inside contact update==');
            }
            if(!lstContactApp.isEmpty() ){
                //Amarnath Mishra added for the two mail issue on deactivation of contact
                //Contact contact = [SELECT Id,Name,IAM_Deactivation_Mail_Sent__c  FROM Contact WHERE Id=: lstContactApp[0].IAM_Contact__c];
                //contact.IAM_Deactivation_Mail_Sent__c = false;
                //update contact;
                
                //Amar commented
                update lstContactApp;
                system.debug('======Inside contact provisioning======');
            }
            
            
            
            System.debug('updateRejectReason end ....lstAccountApp....  '+lstAccountApp);
            System.debug('updateRejectReason end ....lstContactApp....  '+lstContactApp);
            System.debug('updateRejectReason end ....lstContact....  '+lstContact);
        }catch(Exception ex){
            System.debug('Exception during .. updateRejectReason() method ========    ' + ex.getMessage());
            System.debug('Exception line number '+ex.getLineNumber());
            try{
                IAM_ErrorHandling.IAMerrorCapture(null, 'IAM_contactHelperClass.updateRejectReason', ex.getMessage());
            }catch(Exception exp){
                System.debug('Exception during inserting record on IAM_ErrorHandling ========    ' + exp.getMessage());
            }
        }
    }  

    //This method will get the contact provision record
    public static List<Contact> getConProvRecord(Id recordId){
        return [select id, IAM_Reject_Reason__c,IAM_Reason__c,(select id, IAM_Reject_Reason__c,IAM_Contact_Status__c,IAM_Reason__c from Contact_Provisionings__r) from Contact where id =: recordId];

    }
    
    
    //Method to update User record if there is a Account Change.
    @future
    Public Static Void ChangeUserProfile(Set<id> ConId){
        List<User> usr= [select id,Profile.id from user where Contactid=:ConId];
         List<profile> cssprofiles = [select id,name from profile where name like 'CSS_%'];
                      Map<string,id> cssprofmap = new Map<string,id>();
                        for(profile pf:cssprofiles){
                            cssprofmap.put(pf.name,pf.id);
                        } 
            //Basically you will get only one user.
            System.debug('Printing user profile'+Profile.id);
        if(!usr.isEmpty()){
            //Checking profile of the user.
            for(user u:usr){
             if(u.Profile.id==cssprofmap.get(System.label.dealer_technician)||u.Profile.id==cssprofmap.get(System.label.dealer_advanced)){
                        System.debug('Printing Profile that need to be aasigned if already assinged guidanz.......');
                        u.Profile.id=System.Label.IAM_User_Community_ProfileID;
             }
            }
            Update usr; 
        }
        
    }

    /* Method to populate Remaining Paid Count & Remaining Free Count */
    public static void getPaidAndFreeCount(String subName, String count, 
    List<String> mergedCountPaid, List<String> mergedCountFree) {
        if(subName.equalsIgnoreCase(Label.IAM_GuidanzMobileFleetCount)
        || subName.equalsIgnoreCase(Label.IAM_GuidanzMobileZapitCount)
        || subName.equalsIgnoreCase(Label.IAM_GuidanzMobileZapitOEMCount)) {
            mergedCountPaid.add(count);
        }
        if(subName.equalsIgnoreCase(Label.IAM_FieldTestFleetCountGM)
        || subName.equalsIgnoreCase(Label.IAM_FieldTestZapitCountGM)
        || subName.equalsIgnoreCase(Label.IAM_FieldTestZapitOEMCountGM)) {
            mergedCountFree.add(count);
        }
    }
}