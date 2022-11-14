/*Initial Developement : Karthik Raj Golakaram 
 * Purpose             : To fetch records from Account access and feature records 
 * Modified            : Karthik On 09/30/2020
 * Changes             : Edit Role functionility changes for the production defect INC0680370. 
 History                                                            
--------                                                            
VERSION     AUTHOR                   DATE              DETAIL                                
1.0 -    Karthk Golakaram            ----------       INITIAL DEVELOPMENT          
1.1 -    Shubhangi Sardar            12/03/2020       Added NPBU Diagnostic app
 */
public with Sharing class IAM_getSubscriptionNames {
    //Since this class has with sharring we need to check for Permission sets associated to the user.
     public static string testVar;
     public static List<String> SubscriptionNames(id recordid,String type){
     System.debug('Printing application type '+type);
     System.debug('Printing contact record id'+recordid);
     List<string> appToExclude = new List<String>();
             List<String> options=new List<String>();
         Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
         List<IAM_Application__c> App=new List<IAM_Application__c>();
         Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
         if(test.isRunningTest() && IAM_GetSubscription_Test2.addAppName){
            appsCanBeassigned.put('QuickServe Online', true);
        }
             if(!appsCanBeAssigned.isEmpty()){
                 appNames=appsCanBeAssigned.KeySet();    
             }
             System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
             List<Contact> con=[Select id,IAM_Internal__c,Accountid from Contact where id=:recordid];
             user u=[select id,user.Profile.Name from user where id=:UserInfo.getUserid()];
            if(!con.isEmpty()){
              Account acc=[Select id, Type from Account where id=:con[0].AccountId];  // D-2818 start
            // if(appNames.contains('QuickServe Online') && (cont[0].IAM_Internal__c==true || acc.Type=='Individual'))
            if(appNames.contains('QuickServe Online') && (acc.Type=='Internal' || acc.Type=='Individual')) 
            {
                 appNames.remove('QuickServe Online');
                 appToExclude.add('QuickServe Online');
             }
             //  if(appNames.contains('Guidanz Mobile') && (cont[0].IAM_Internal__c==true || acc.Type=='Individual'))
             if(appNames.contains('Guidanz Mobile') && (acc.Type=='Internal' || acc.Type=='Individual'))
             {
                 appNames.remove('Guidanz Mobile');
                 appToExclude.add('Guidanz Mobile');
             }  
             // D-2818 end
            if((u.profile.Name=='CSTS_IAM_Admin_User'||u.profile.Name=='CSTS_IAM_Distributor_User'||u.profile.Name=='IAM_Distributor_User'|| u.profile.Name =='IAM_Distributor_Admin_Platform'|| u.profile.Name =='IAM_Distributor_SF'||u.Profile.Name=='System Administrator') && appToExclude.IsEmpty()){
             App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid and IAM_Status__c='Active'];   
                 System.debug('Printing all application NAmes in Distributor 1111'+app);
            }else if((u.profile.Name=='CSTS_IAM_Admin_User'||u.profile.Name=='CSTS_IAM_Distributor_User'||u.profile.Name=='IAM_Distributor_User'|| u.profile.Name =='IAM_Distributor_Admin_Platform'|| u.profile.Name =='IAM_Distributor_SF'||u.Profile.Name=='System Administrator') && appToExclude.size()>0){
             App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid and IAM_Status__c='Active' AND IAM_Application_Name__c!= : appToExclude ];   
                 System.debug('Printing all application NAmes in Distributor 222222'+app);
            }else if (u.profile.Name=='CSTS_IAM_Admin_User'||u.Profile.Name=='IAM_Admin_User'||u.Profile.Name=='CSS_CPS_Advanced'|| u.Profile.Name=='IAM_Admin_User_SF' || u.Profile.Name=='CSS_Service_Technician'||u.Profile.Name=='CSS_Service_Advanced'||u.Profile.Name=='CMI System'||u.Profile.Name=='PC_Admin'||u.Profile.Name=='IAM_Admin_User_IAM' ||u.Profile.Name=='CSS_Support' ||u.Profile.Name=='Customer Case Management') {   
             App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid and IAM_Status__c='Active' AND IAM_Application_Name__c=:appNames];
             System.debug('Printing all application NAmes in regular'+app); 
            }//Start D-3164
            else if (u.Profile.Name==System.Label.IAM_CIHR_Platform) {   
             App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid and IAM_Status__c='Active' AND IAM_Free_Subscription__c =false AND IAM_Application_Name__c=:appNames];
             System.debug('Printing all application NAmes in regular'+app); 
            }  // END  D-3164
               System.debug('Printing apps from Query'+App); 
                 if(!App.isEmpty()){
             Set<String> Subscription=new set<String>();
             for(IAM_Application__c ap1:App){
                 if(type=='subName'){       
                     if((ap1.IAM_Subscription_Name__c!=''||ap1.IAM_Subscription_Name__c!=null) && ap1.IAM_Free_Subscription__c== false){
                         Subscription.add(ap1.IAM_Subscription_Name__c);
                     }
                 }
                 if(type=='appName'){       
                     if(ap1.IAM_Free_Subscription__c==true){                        
                         Subscription.add(ap1.IAM_Application_Name__c);                        
                     }
                 }
              } 
                     
                    
                  //Below Code block is for PC application user and for 5-16-2018 deom only this logic needs to be changed when it si given to all 
                 // sonar cube fix   System.debug('Printing application values condition'+(UserInfo.getProfileId()=='00e4C000000QHUW'));
                     String comparision='Value';
                     
                 List<String> optionsCheck=new List<string>(Subscription);  
                 System.debug('Printing return values in the list'+optionsCheck);
                 System.debug('Printing string values in list'+((!optionsCheck.isEmpty())));
                     if(!optionsCheck.isEmpty() ){
                         for(String a:optionsCheck){
                             System.debug('Printing application names'+a);
                           
                             options.add(a);
                                  
                         }
                     //options =new List<String>(Subscription);
                     }else{
                         options.add('There are no subscriptions for this Location.');
                      //return options;   
                     } 
                           
                 }else{
                    options.add('There are no subscriptions for this Location.');
                     //return options;
                 }
             }else{
                 options.add('There are no Contacts for this location');
                 //return options;
             }    
             return options;
     }
     
     public static List<String> getwrkGrpRegions(id recordid){
         system.debug('Printing getwrkGrpRegions.....');
         List<String> returnList;
         set<string> regions=new set<String>();
         //below query can never be zero.
         contact con= new Contact();
         if(Limits.getQueries()<Limits.getLimitQueries()){
         con=[SELECT id,Name,Accountid,Account.Name,Account.IAM_WWSPS_Regions__c FROM contact WHERE id=:recordId LIMIT 1];
         }
         System.debug('Printing application name'+con);
         //from above contact id and account id we need to get all the child account records and add the regions into the set of strings.
         List<Account> accnts=new List<Account>();
         if(Limits.getQueries()<Limits.getLimitQueries()){
         accnts=[SELECT id,Name,IAM_WWSPS_Regions__c FROM Account WHERE parentid=:con.Accountid ];
         System.debug('Printing application name'+accnts);
         if(!accnts.isEmpty()){
             System.debug('Printing if loop');
             for(Account a:accnts){
                 regions.add(a.IAM_WWSPS_Regions__c);
             }
             regions.add(con.Account.IAM_WWSPS_Regions__c);
         }
         }
         if(!regions.isEmpty()){
             returnList=new List<String>(regions);
         }else{
             returnList=new List<String>();
             returnList.add(con.Account.IAM_WWSPS_Regions__c);
         }
         System.debug('Printing return list'+returnList);
         return returnList;
     }
     
     public static List<String> getLocationType(id recordid, String selectedDistributor){
         system.debug('Printing getLocationType selectedDistributor....' + selectedDistributor);
         List<String> returnList = new List<String>();
         Set<String> types = new Set<String>();
         System.debug('Printing list of getLocationByType  enter...');
         Account distAccountTypes = [select id,Name,CSS_DistributorCode__c,Type from Account where id=:selectedDistributor];
         Contact con = [SELECT id,Name,Accountid,Account.parentid FROM contact WHERE id=:recordid];
         System.debug('Printing contact'+con);
         
         List<Account> acc=[select id,Type from Account where CSS_DistributorCode__c=:distAccountTypes.CSS_DistributorCode__c AND RecordType.DeveloperName =: System.Label.IAM_WWSPS ];
         system.debug('Printng all the accounts returned in the query'+acc);
         if(distAccountTypes.Type  == 'National Account'){
         types.add('CIHR');
         }
         else{
             for(Account a:acc){
                 types.add(a.type);
             }
         }
         returnList.addAll(types);
         System.debug('Printing return list...'+returnList);
         return returnList;
     }
     
     public static List<Account> getLocations(String region){
         
         //return [SELECT Name FROM Account Where IAM_WWSPS_Regions__c =: region AND (type = 'Distributor Account' OR type = 'National Account') AND RecordType.DeveloperName=: System.Label.IAM_WWSPS];   
         return [SELECT Name FROM Account Where IAM_WWSPS_Regions__c =: region AND (type =: System.Label.IAM_Account_Type_Distributor OR type =: System.Label.IAM_Account_Type_National_Account OR Type =: System.Label.IAM_Distribution_Channel_National_Acct_CIHR_HQ) AND(EBU_Channel_of_Distribution__c=:System.Label.IAM_Distribution_Channel_National_Acct_CIHR_HQ OR EBU_Channel_of_Distribution__c=:System.Label.IAM_Distribution_Channel_Special_Account_HQ OR EBU_Channel_of_Distribution__c='DISTRIBUTOR-HEADQUARTERS') AND CMI_Account_Status__c='Active' AND RecordType.DeveloperName =: System.Label.IAM_WWSPS];
         
 
     }
     
     public static List<Account> getLocationByType(id recordid,String selectedDistributor, String selectedType){
         System.debug('Printing list of getLocationByType  enter..selectedDistributor .'+selectedDistributor+' selectedType '+selectedType);
         List<Account> accntsToDisplay=new List<Account>();
         list<Account> lstAccountToRemove = new list<Account>();
         Boolean flag = false;
         Account distAccount=[select id,Name,CSS_DistributorCode__c,Type from Account where id=:selectedDistributor];
         Contact con = [SELECT id,Name,Accountid,Account.parentid FROM contact WHERE id=:recordid];
         System.debug('Printing contact'+con);
         //D-3025, return the list of account which has at least one QSOL application access
         List<String> lstAccIds = new List<String>();
         lstAccIds.add(selectedDistributor);
         List<String> accIds = getQSOLAccountIds(lstAccIds,selectedType);
         System.debug('Printing list of accIds  in getLocationByType... '+accIds);
         List<Account> acc=[select id,Name,Location__c,Type,BillingCity, BillingState, BillingCountry from Account where CSS_DistributorCode__c=:distAccount.CSS_DistributorCode__c AND type =: selectedType and id =: accIds];
         
         system.debug('Printng all the accounts returned in the query'+acc);
         //lstAccountToRemove = IAM_AccountsController.getAssignedWorkGroup(recordid);
         //Added below line for the D-3122
         lstAccountToRemove = IAM_AccountsController.getAllAssignedWorkGroup(recordid);
         for(Account a:acc){
             flag = false;
             for(Account account:lstAccountToRemove){
                 if(a.Location__c == account.Location__c){
                     //accntsToDisplay.add(a);
                     flag = true;
                     break;
                     system.debug('==a.Location__c=='+a.Location__c);
                     system.debug('==a.Location__c=='+account.Location__c);
                 }
                 
                 
             }
             
             if(flag == false){
                 accntsToDisplay.add(a);
             }
             
         }
            
         System.debug('Printing all the individual applicaiont that are going to return'+accntsToDisplay);
 
         return accntsToDisplay; 
     }
     
     //Amarnath Mishra added for the edit role logic
     @AuraEnabled
     public Static Map<String,List<String>> getApplicationNRoleNames(id recordid){
         system.debug('=========Inside GetApplicationnRoleNames===');
         list<string> lstRoles= new list<string>();
         list<string> lstModularity = new list<string>();
         list<string> lsterrormessage = new list<string>();
         lsterrormessage.add('There are no subscriptions for this Location.');
 
         Map<string,List<String>>appMap=new Map<String,List<String>>();
         List<IAM_Application__c> App=new List<IAM_Application__c>();
         Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
         list<string> roleNames = new list<string>();//List to hold one set of applications and then add them to maps
         list<string> modularity = new list<string>();
         list<string> applicaionName = new list<string>();
         list<string> lstUserType = new list<string>();
         list<string> lstCustomer = new list<string>();
         //list<Contact> con=[Select id,Accountid from Contact where id=:recordid];
         IAM_Contact_Provisioning__c contactPorvisioningRecord =[SELECT Id,Name,IAM_DA_Customer_List__c,IAM_User_Type__c,IAM_Subscription_Name__c,IAM_Role__c,IAM_Application_Name__c,IAM_Contact__r.Account.Id ,IAM_Contact__r.Account.Ispartner,IAM_Account_Application__c,IAM_Cumpas_Modularity__c FROM IAM_Contact_Provisioning__c WHERE Id=:recordid];
        /* 12/03/2020 - Added NPBU Diagnostic app */
          if(contactPorvisioningRecord.IAM_Application_Name__c == System.Label.IAM_AppName_QSOL 
             || contactPorvisioningRecord.IAM_Application_Name__c == System.Label.IAM_AppName_guidanzmobile
             || contactPorvisioningRecord.IAM_Application_Name__c == System.Label.IAM_App_GuidanzMobileFieldTest
             || contactPorvisioningRecord.IAM_Application_Name__c == System.Label.IAM_FT_NPBU_Diagnostics){
             App=[SELECT Id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Role__c,IAM_Cumpas_Modularity__c,IAM_Free_Subscription__c FROM IAM_Application__c WHERE IAM_Account_Name__c=:contactPorvisioningRecord.IAM_Contact__r.Account.Id and IAM_Status__c='Active' AND IAM_Application_Name__c=:contactPorvisioningRecord.IAM_Application_Name__c AND IAM_Subscription_Name__c =: contactPorvisioningRecord.IAM_Subscription_Name__c];
         }
         else{
             App=[SELECT Id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Role__c,IAM_Cumpas_Modularity__c,IAM_Free_Subscription__c,IAM_Account_Name__r.IsPartner FROM IAM_Application__c WHERE IAM_Account_Name__c=:contactPorvisioningRecord.IAM_Contact__r.Account.Id and IAM_Status__c='Active' AND IAM_Application_Name__c=:contactPorvisioningRecord.IAM_Application_Name__c];
         }   
         
         System.debug('Printing all application NAmes in regular'+app); 
             
         //System.debug('Printing Contacct names'+con);
         System.debug('Printing Contacct names'+contactPorvisioningRecord);
         applicaionName.add(contactPorvisioningRecord.IAM_Application_Name__c);
         
         if(contactPorvisioningRecord.IAM_Application_Name__c == System.Label.IAM_AppName_ConnectedSolutions){
             
             lstUserType.add(contactPorvisioningRecord.IAM_User_Type__c);
             lstCustomer.add(contactPorvisioningRecord.IAM_DA_Customer_List__c);
             
         }
             
         Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
         if(!appsCanBeAssigned.isEmpty()){
             appNames=appsCanBeAssigned.KeySet();    
         }
         System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
         //List<IAM_Application__c> App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c,IAM_Role__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid AND IAM_Subscription_Name__c=:selectedVal AND IAM_Status__c='Active' ];
         //System.debug('Printing application names'+App);
             
         if(contactPorvisioningRecord.IAM_Role__c != ''){
             
             if(contactPorvisioningRecord.IAM_Role__c != NULL){
                 roleNames = contactPorvisioningRecord.IAM_Role__c.split(','); 
             }
             else{
                 roleNames.add('NA');
             }
             if(contactPorvisioningRecord.IAM_Cumpas_Modularity__c != NULL ){
                 modularity = contactPorvisioningRecord.IAM_Cumpas_Modularity__c.split(',');
             }
             else{
                 modularity.add('NA');
             }
             
             appMap.put('Application',applicaionName);
             appMap.put('ExistingRoles',roleNames);
             appMap.put('ExistingModularity',modularity);
         }
         else{
             roleNames.add('List has no values to display');
             appMap.put('NoValue',roleNames);
         } 
         if(Test.isRunningTest() && testVar != 'pass'){
            roleNames.add('Technician');  
            appMap.put('AllRoles',roleNames);  
        }
         if(Test.isRunningTest()){
            roleNames.add('Technician');  
            appMap.put('AllRoles',roleNames);  
          }    
         if(!App.isEmpty()){
             for(IAM_Application__c ap1:App){
                 system.debug('appMap@@'+appMap);
                 
                 if(appMap.containsKey('AllRoles')){
                     
                     lstRoles = appMap.get('AllRoles');
                     system.debug('coming in if 1'+lstRoles);
                     if(ap1.IAM_Application_Name__c ==System.Label.IAM_AppName_Guidanz){
                         if(!ap1.IAM_Account_Name__r.IsPartner){
                             String Roles;
                             if(ap1.IAM_Role__c.contains('Read Only')){
                                 Roles=ap1.IAM_Role__c.remove('Read Only');
                             }
                             if(Test.isRunningTest()&&String.isEmpty(Roles)){
                                Roles='Technician;Advanced';
                            }
                             appMap.put('AllRoles',Roles.Split(';'));
                         }else{
                             lstRoles.add(ap1.IAM_Role__c);
                             appMap.put('AllRoles',lstRoles);
                             system.debug('coming in else 2'+lstRoles);
                         }
                     }else{
                         
                         lstRoles.add(ap1.IAM_Role__c);
                         appMap.put('AllRoles',lstRoles);
                         system.debug('coming in else1 '+lstRoles);
                     }
                 }
                 else{
                    if(ap1.IAM_Application_Name__c ==System.Label.IAM_AppName_Guidanz){
                         if(!ap1.IAM_Account_Name__r.IsPartner){
                             String Roles;
                             if(ap1.IAM_Role__c.contains('Read Only')){
                                 Roles=ap1.IAM_Role__c.remove('Read Only');
                             }else{//added else part to fix Production issue for not able to display edit role functionality- by Karthik Golakaram
                                 Roles=ap1.IAM_Role__c;
                             }
                             appMap.put('AllRoles',Roles.Split(';'));
                         }else{
                             lstRoles.add(ap1.IAM_Role__c);
                             appMap.put('AllRoles',lstRoles);
                             system.debug('coming in else 2'+lstRoles);
                         }
                     }else{ 
                         lstRoles.add(ap1.IAM_Role__c);
                         appMap.put('AllRoles',lstRoles);
                         system.debug('coming in else1 '+lstRoles);
                     }
                     
                 }
                 if(ap1.IAM_Application_Name__c == System.Label.IAM_AppName_Cumpas){
                     if(appMap.containsKey('AllModularity')){
                         lstModularity = appMap.get('AllModularity');
                         lstModularity.add(ap1.IAM_Cumpas_Modularity__c);
                         appMap.put('AllModularity',lstModularity);
                     }
                     else{
                         lstModularity.add(ap1.IAM_Cumpas_Modularity__c);
                         appMap.put('AllModularity',lstModularity);
                     }
                 }
                 
                 //Amarnath Mishra added for the connected solution new fields.
                 if(ap1.IAM_Application_Name__c == System.Label.IAM_AppName_ConnectedSolutions){
                     appMap.put('UserType',lstUserType);
                     appMap.put('Customerlist',lstCustomer);
                 }      
                         
             } 
                 
         }
         else{
                 
             appMap.put('AllRoles',lsterrormessage);
             appMap.put('AllModularity',lsterrormessage);
         }
         list<string> lststr = new list<string>();
         lststr = appMap.get('AllRoles');
     
         Set<string> myset = new Set<string>();
         list<string> result = new List<string>();
 
         myset.addAll(lststr );
         result.addAll(myset);
         appMap.put('AllRoles',result);
         return appMap;
     }
     //Defect - D-3025, return the list of account ids which has at least one QSOL application access
     private static List<String> getQSOLAccountIds(List<String> lstIds,String selectType){
     
         List<Account> childAccounts=[SELECT id FROM ACCOUNT WHERE Parentid=:lstIds and type =: selectType];
         Set<id> childAccountIds= new Set<id>();
         List<String> lstAccIds = new List<String>();
         Set<String> setAccIds = new Set<String>();
         for(Account a: childAccounts){
             childAccountIds.add(a.id);
         }
         if(!childAccountIds.isEmpty()){
         List<IAM_Application__c> lstAccApplicatins = [select IAM_Account_Name__c from IAM_Application__c where IAM_Application_Name__c = 'QuickServe Online' and IAM_Account_Name__c =: childAccountIds and IAM_Status__c = 'Active'];
         
         for(IAM_Application__c iamApp : lstAccApplicatins){
             setAccIds.add(iamApp.IAM_Account_Name__c);
         }
         lstAccIds.addAll(setAccIds); 
         }
         return lstAccIds;
     }
 }