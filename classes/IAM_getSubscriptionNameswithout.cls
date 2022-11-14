/** Purpose  : To check app access for different profiles
 History                                                            
-------                                                            
VERSION     AUTHOR                   DATE              DETAIL                                
1.0 -    Karthk Golakaram            ----------       INITIAL DEVELOPMENT          
1.1 -    Shubhangi Sardar            12/03/2020       Added NPBU Diagnostic app
 */

public without sharing class IAM_getSubscriptionNameswithout {
   //Karthik changes start for 97 UAT issue 
   //We have to run the code in without sharing mode as the users will have no access to the application records.
    public static List<String> SubscriptionNames(id recordid,String type){
        System.debug('Printing application type '+type);
        List<String> options=new List<String>();
        List<Contact> con=[Select id,Accountid,IAM_Internal__c from Contact where id=:recordid];
        System.debug('Printing contcct details'+con);
        List<IAM_Application__c> App=new List<IAM_Application__c>(); // D-2818
        if(con.size()>0){
            Account acc=[Select id, Type from Account where id=:con[0].AccountId]; // D-2818 start
             if(con[0].IAM_Internal__c==true || acc.Type=='Individual')
              {
               App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid and IAM_Status__c='Active' and IAM_Application_Name__c NOT IN ('QuickServe Online','Guidanz Mobile')];
              }
            // D-2818 end
             else{ 
              App=[select id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Free_Subscription__c from IAM_Application__c where IAM_Account_Name__c=:con[0].Accountid and IAM_Status__c='Active'];
            }
         System.debug('Printing application names'+app);   
         if(App.size()>0){
                Set<String> Subscription=new set<String>();
                for(IAM_Application__c ap1:App){
                    if(type=='subName'){       
                        if(String.isNotBlank(ap1.IAM_Subscription_Name__c) && ap1.IAM_Free_Subscription__c == false){
                                Subscription.add(ap1.IAM_Subscription_Name__c);
                        }
                    }
                    if(type=='appName' && ap1.IAM_Free_Subscription__c==true){ 
                        Subscription.add(ap1.IAM_Application_Name__c);
                    }
                } 
          
                //Below Code block is for PC application user and for 5-16-2018 deom only this logic needs to be changed when it si given to all 
              // sonar cube fix  System.debug('Printing application values condition'+(UserInfo.getProfileId()=='00e4C000000QHUW'));
                String comparision='Value';
                List<String> optionsCheck=new List<string>(Subscription);  
                System.debug('Printing return values in the list'+optionsCheck);
                System.debug('Printing string values in list'+((!optionsCheck.isEmpty())));
                if(optionsCheck.size()>0){
                    for(String a:optionsCheck){
                        System.debug('Printing application names'+a);
                        options.add(a);
                    }
                }else{
                    options.add('There are no subscriptions for this Location.');
                } 
            }else{
                options.add('There are no subscriptions for this Location.');
                //return options;
            }
        }else{
        options.add('There are no Contacts for this location');
        }    
        return options;
    }
    
    public static List<String> getwrkGrpRegions(id recordid){
        system.debug('Printing getwrkGrpRegions.....');
        List<String> returnList;
        set<string> regions=new set<String>();
        //below query can never be zero.
        contact con=[SELECT id,Name,Accountid,Account.Name,Account.IAM_WWSPS_Regions__c FROM contact WHERE id=:recordId LIMIT 1];
        System.debug('Printing application name'+con);
        //from above contact id and account id we need to get all the child account records and add the regions into the set of strings.
        List<Account> accnts=[SELECT id,Name,IAM_WWSPS_Regions__c FROM Account WHERE parentid=:con.Accountid LIMIT 100];
        System.debug('Printing application name'+accnts);
        if(accnts.size()>0){
        System.debug('Printing if loop');
        for(Account a:accnts){
        regions.add(a.IAM_WWSPS_Regions__c);
        }
        regions.add(con.Account.IAM_WWSPS_Regions__c);
        }

        if(regions.size()>0){
        returnList=new List<String>(regions);
        }else{
        returnList=new List<String>();
        returnList.add(con.Account.IAM_WWSPS_Regions__c);
        }
        System.debug('Printing return list'+returnList);
        return returnList;
    }
    
    public static List<String> getLocationType(String region){
        system.debug('Printing getLocationType region....' + region);
        List<String> returnList;
        set<string> types = new set<String>();

        //fetching the location type based on the region
        List<Account> accnts=[SELECT id,type FROM Account WHERE IAM_WWSPS_Regions__c =: region LIMIT 100];
        System.debug('Printing location name'+accnts);
        if(!accnts.isEmpty()){
            System.debug('Printing if loop');
            for(Account a : accnts){
                types.add(a.type);
            }
        }

        returnList = new List<String>(types);
        System.debug('Printing return list...'+returnList);
        return returnList;
    }
    
    public static List<Account> getLocations(String locType){
        List<Account> allacounts= new List<Account>();
        if(Limits.getQueries()<Limits.getLimitQueries()){
             allacounts=[SELECT Name FROM Account Where Type =: locType];
        }
        
        return allacounts;
    }
    
    public static List<Account> getLocationByType(id recordid,String selectedDistributor){
        System.debug('Printing list of getLocationByType  enter...');
        List<Account> accntsToDisplay=new List<Account>();
        set<id> childId;
        Account distAccount=[select id,Name,CSS_DistributorCode__c,Type from Account where id=:selectedDistributor];
        Contact con = new Contact();
        if(Limits.getQueries()<Limits.getLimitQueries()){
        con = [SELECT id,Name,Accountid,Account.parentid FROM contact WHERE id=:recordid];
        }
        System.debug('Printing contact'+con);
        List<Account> acc = new List<Account>();
        
        if(Limits.getQueries()<Limits.getLimitQueries()){
        acc=[select id,Name,Location__c,Type from Account where CSS_DistributorCode__c=:distAccount.CSS_DistributorCode__c and type =: distAccount.Type Limit 1000];
        System.debug('Printing all the accoutns in that region'+acc);
        system.debug('Printng all the accounts returned in the query'+acc);
        if(acc.size()>0){
            //calling Another Function to see if there are any child records
            for(Account a:acc){
                childId=new Set<Id>();//variable to capture child reecord ids from above wuery inorder to check for any branch records.
                if(a.id != con.accountid && a.id != con.Account.parentid){
                    System.debug('See if loop');
                    accntsToDisplay.add(a);
                    childId.add(a.id);
                }
            }
            //below query will give accounts at next branch children     
            List<Account> acn=[SELECT id,Name,Location__c,Type FROM Account WHERE parentid=:childId];
            if(acn.size()>0){
                for(Account an:acn){
                    accntsToDisplay.add(an);  
                }
            }  
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
        lsterrormessage.add('There are no subscript ions for this Location.');
        Map<string,List<String>>appMap=new Map<String,List<String>>();
        List<IAM_Application__c> App=new List<IAM_Application__c>();
        Set<String> appNames=new Set<String>();//Set to store the application names that we get in the map.
        list<string> roleNames = new list<string>();//List to hold one set of applications and then add them to maps
        list<string> modularity = new list<string>();
        list<string> applicaionName = new list<string>();
        list<string> lstUserType = new list<string>();
        list<string> lstCustomer = new list<string>();
        
        IAM_Contact_Provisioning__c contactPorvisioningRecord =[SELECT Id,Name,IAM_DA_Customer_List__c,IAM_User_Type__c,IAM_Role__c,IAM_Application_Name__c,IAM_Contact__r.Account.Id ,IAM_Account_Application__c,IAM_Cumpas_Modularity__c,IAM_Subscription_Name__c FROM IAM_Contact_Provisioning__c WHERE Id=:recordid];
        
        //App=[SELECT Id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Role__c,IAM_Cumpas_Modularity__c,IAM_Free_Subscription__c FROM IAM_Application__c WHERE IAM_Account_Name__c=:contactPorvisioningRecord.IAM_Contact__r.Account.Id and IAM_Status__c='Active' AND IAM_Application_Name__c=:contactPorvisioningRecord.IAM_Application_Name__c];
        //Amar added filter based upon subscription name for Guidanz Mobile and Qsol application
        /* 12/03/2020 - Added NPBU Diagnostic app */
         if(contactPorvisioningRecord.IAM_Application_Name__c == System.Label.IAM_AppName_QSOL 
            || contactPorvisioningRecord.IAM_Application_Name__c == System.Label.IAM_AppName_guidanzmobile
            || contactPorvisioningRecord.IAM_Application_Name__c == System.Label.IAM_App_GuidanzMobileFieldTest
            || contactPorvisioningRecord.IAM_Application_Name__c == Label.IAM_FT_NPBU_Diagnostics){
            App=[SELECT Id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Role__c,IAM_Cumpas_Modularity__c,IAM_Free_Subscription__c FROM IAM_Application__c WHERE IAM_Account_Name__c=:contactPorvisioningRecord.IAM_Contact__r.Account.Id and IAM_Status__c='Active' AND IAM_Application_Name__c=:contactPorvisioningRecord.IAM_Application_Name__c AND IAM_Subscription_Name__c =: contactPorvisioningRecord.IAM_Subscription_Name__c];
        }
        else{
            App=[SELECT Id,IAM_Subscription_Name__c,IAM_Application_Name__c,IAM_Role__c,IAM_Cumpas_Modularity__c,IAM_Free_Subscription__c FROM IAM_Application__c WHERE IAM_Account_Name__c=:contactPorvisioningRecord.IAM_Contact__r.Account.Id and IAM_Status__c='Active' AND IAM_Application_Name__c=:contactPorvisioningRecord.IAM_Application_Name__c];
        }
        System.debug('Printing all application NAmes in regular'+app); 
        System.debug('Printing Contacct names'+contactPorvisioningRecord);
        applicaionName.add(contactPorvisioningRecord.IAM_Application_Name__c);
        if(contactPorvisioningRecord.IAM_Application_Name__c == System.Label.IAM_AppName_ConnectedSolutions){
            
            lstUserType.add(contactPorvisioningRecord.IAM_User_Type__c);
            lstCustomer.add(contactPorvisioningRecord.IAM_DA_Customer_List__c);
            
        }
        
        Map<String,Boolean> appsCanBeassigned=IAM_Trigger_Check.checkApplicationAccess(UserInfo.getUserId());
        if(appsCanBeAssigned.size()>0){
            appNames=appsCanBeAssigned.KeySet();    
        }
        System.debug('Printing applicaion Names from app Mapping Trigger check'+appNames);
       
        if(String.isNotBlank(contactPorvisioningRecord.IAM_Role__c)){
            roleNames = contactPorvisioningRecord.IAM_Role__c.split(',');

            if(String.isNotBlank(contactPorvisioningRecord.IAM_Cumpas_Modularity__c)){
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
            appMap.put('ExistingRoles',roleNames);
        } 
        if(App.size()>0){
            for(IAM_Application__c ap1:App){
                
                if(appMap.containsKey('AllRoles')){
                    lstRoles = appMap.get('AllRoles');
                    lstRoles.add(ap1.IAM_Role__c);
                    appMap.put('AllRoles',lstRoles);
                }
                else{
                    lstRoles.add(ap1.IAM_Role__c);
                    appMap.put('AllRoles',lstRoles);
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
}