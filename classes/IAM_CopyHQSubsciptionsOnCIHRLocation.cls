/* It checks if created location is a CIHR or Locations parent account is National Account CIHR HQ or Special Account HQ location and its parent location is HQ location. If yes,
*  it populates account subscription (QSOL, CSS, CST and EDS) from HQ (parent) location to newly created CIHR location. */

public class IAM_CopyHQSubsciptionsOnCIHRLocation {
    
    /* Copy HQ Location's Applications on CIHR Locations */
    public static void copyHQLocationAppsOnCIHR(List<Account> accList, Boolean isInsert, 
                                                Map<Id, Account> accOldMap, Map<Id, Account> accNewMap) {
        try {
            
            Map<id,Account> parentAccounts=getParentAccounts(accList);
            
            Map<Id, List<Account>> CIHRLocationMap = new Map<Id, List<Account>>();
            if(isInsert) {
                for(Account acc : accList) {
                    /* If new CIHR location or account whose parent is type National Account CIHR HQ and Special Account HQ is added then copy parent's account subsciption to CIHR location 
                     * if parent location is of type HQ */
                     System.debug('Printing acc.PArent.Type'+acc.Parentid);
                    if(acc.ParentId != null ){
                    System.debug('Printing acc.PArent.Type'+parentAccounts.get(acc.ParentId).Type);
                        if(parentAccounts.get(acc.ParentId).Type == Label.IAM_Distribution_Channel_National_Acct_CIHR_HQ||parentAccounts.get(acc.ParentId).Type==Label.IAM_Distribution_Channel_Special_Account_HQ) {
                            System.debug('Prinitng inside Condition'+acc);
                            addInCIHRLocationMap(CIHRLocationMap, acc);
                        }
                    }
                }                                                
            } else {
                Set<Id> deactivatedAccIdSet = new Set<Id>();
                for(Account acc : accList) {
                    System.debug('#### old val '+accNewMap.get(acc.Id).ParentId);
                    System.debug('#### old val '+accOldMap.get(acc.Id).ParentId);
                    if(acc.Type == Label.IAM_Account_Type_CIHR) {
                        /* If CIHR location is moved from one location to other HQ location then deactivate existing
                         * subscriptions and add copy subscriptions from HQ location to CIHR location */
                        if(acc.ParentId != null && accNewMap.get(acc.Id).ParentId != accOldMap.get(acc.Id).ParentId) {
                            addInCIHRLocationMap(CIHRLocationMap, acc);
                        }
                        
                        /* If CIHR location status is changed to either Inactive, Cancelled or Expired then inactivate 
                         * the status of existing account subscription and change end date to today */
                        if(accNewMap.get(acc.Id).CMI_Account_Status__c != accOldMap.get(acc.Id).CMI_Account_Status__c
                           && (acc.CMI_Account_Status__c == Label.IAM_Status_Inactive 
                           || acc.CMI_Account_Status__c == Label.IAM_Status_Cancelled
                           || acc.CMI_Account_Status__c == Label.IAM_Expired)) {
                            deactivatedAccIdSet.add(acc.Id);                                                
                        }
                    }
                }
                if(!deactivatedAccIdSet.isEmpty()) {
                    deactivateExistingCIHRAppSubscription(deactivatedAccIdSet, true);
                }
            }        
            System.debug('#### CIHRLocationMap ');
            if(!CIHRLocationMap.isEmpty()) {
            System.debug('Printing CIHR location'+CIHRLocationMap);
                checkIfParentIsHQLocation(CIHRLocationMap, isInsert);
            }
        } catch(Exception e) {
            /* TO DO - Need to handle exception here */
            System.debug('### Exception Message - '+e.getMessage());
        }
    }
    
    /* Create a map parent account Id vs child Account */
    private static void addInCIHRLocationMap(Map<Id, List<Account>> CIHRLocationMap, Account acc) {
        if(CIHRLocationMap.containsKey(acc.ParentId)) {
            CIHRLocationMap.get(acc.ParentId).add(acc);
        } else {
            CIHRLocationMap.put(acc.ParentId, new Account[]{acc});
        }
    }
    
    /* Check if parent is HQ Location. If yes get all its subscriptions and create a map (acc vs its subscription list) */
    private static void checkIfParentIsHQLocation(Map<Id, List<Account>> CIHRLocationMap, Boolean isInsert) {
        List<IAM_Application__c> hqLocationAppList;
        Map<Id, List<IAM_Application__c>> hqLocationAppMap;
        Map<Id, Account> HQLOcationMap = getHQLocations(CIHRLocationMap.keySet());
        System.debug('Printing hqlocation Map'+HQLocationMap);
        if(HQLOcationMap != null && !HQLOcationMap.isEmpty()) {
            hqLocationAppList = getHQLocationAppSubscriptions(HQLOcationMap.keySet());
        }        
        if(hqLocationAppList != null && !hqLocationAppList.isEmpty()) {
            hqLocationAppMap = new Map<Id, List<IAM_Application__c>>();
            for(IAM_Application__c app : hqLocationAppList) {
                if(hqLocationAppMap.containsKey(app.IAM_Account_Name__c)) {
                    hqLocationAppMap.get(app.IAM_Account_Name__c).add(app);
                } else {
                    hqLocationAppMap.put(app.IAM_Account_Name__c, new IAM_Application__c[]{app});
                }
            }
        }
        if(hqLocationAppMap != null && !hqLocationAppMap.isEmpty()) {
            cloneHQAppSubsciptionstoCIHRLocation(CIHRLocationMap, hqLocationAppMap, isInsert);
        }
    }
    
    /* Clone App Subscriptions of HQ Location and create it on CIHR location */
    @TestVisible
    private static void cloneHQAppSubsciptionstoCIHRLocation(Map<Id, List<Account>> CIHRLocationMap,
        Map<Id, List<IAM_Application__c>> hqLocationAppMap, Boolean isInsert) {
        List<IAM_Application__c> appList = new List<IAM_Application__c>();
        List<Account> accList = new List<Account>();
        for(Id hqLocation : hqLocationAppMap.keySet()){
            if(CIHRLocationMap.containsKey(hqLocation)) {
                /* If CIHR location is moved from one location to another HQ location then 
                 * deactivate its existing app subscription */
                if(!isInsert) {
                    accList.addAll(CIHRLocationMap.get(hqLocation));
                }
                for(Account acc : CIHRLocationMap.get(hqLocation)) {                    
                    for(IAM_Application__c app : hqLocationAppMap.get(hqLocation)) {
                        /* clone() - all optional parameters are set to false by default because there is no need 
                         * to clone Id, Reference, Timestamp and Autonumber fields*/
                        System.debug('#### original app - '+app);
                        /*IAM_Application__c clonedApp = app.clone(false, true, false, false);
                        clonedApp.IAM_Account_Name__c = acc.Id;*/
                        IAM_Application__c clonedApp = cloneAccountSubscription(app, acc);
                        System.debug('#### Cloned app - '+clonedApp);
                        appList.add(clonedApp);
                    }
                }
            }        
        }
        if(!accList.isEmpty()) {
            Set<Id> idSet = new Set<Id>();
            for(Account acc : accList) {
                idSet.add(acc.Id);
            }
            deactivateExistingCIHRAppSubscription(idSet, false);
        }
        if(!appList.isEmpty()) {
            insert appList;    
        }
    }
    
    /* If CIHR location is updated to new HQ location then deactivate the existing subscriptions of CIHR location */
    private static void deactivateExistingCIHRAppSubscription(Set<Id> idSet, Boolean isEndDateToday) {
        List<IAM_Application__c> deactivationAppList = getCIHRLocationAppSubscriptions(idSet);
        if(!deactivationAppList.isEmpty()) {
            for(IAM_Application__c app : deactivationAppList) {
                app.IAM_Status__c = Label.IAM_Inactive_Label;
                if(isEndDateToday) {
                    app.IAM_Subscription_End_Date__c = Date.Today();
                }
            }
            update deactivationAppList;
        }
    }
    
    private static IAM_Application__c cloneAccountSubscription(IAM_Application__c originalApp, Account acc) {
        IAM_Application__c clonedApp = new IAM_Application__c();
        clonedApp.IAM_Account_Name__c = acc.Id;
        clonedApp.IAM_Application_Name__c = originalApp.IAM_Application_Name__c;
        clonedApp.IAM_Free_Subscription__c = originalApp.IAM_Free_Subscription__c;
        clonedApp.IAM_Subscription_Start_Date__c = originalApp.IAM_Subscription_Start_Date__c;
        clonedApp.IAM_Subscription_End_Date__c = originalApp.IAM_Subscription_End_Date__c;
        clonedApp.IAM_Subscription_Count__c = originalApp.IAM_Subscription_Count__c;
        clonedApp.IAM_Role__c = originalApp.IAM_Role__c;
        if(originalApp.IAM_Application_Name__c == Label.IAM_AppName_QSOL) {
            clonedApp.IAM_Qsolexpiration__c = originalApp.IAM_Qsolexpiration__c;
        }
        if(originalApp.IAM_Application_Name__c == Label.IAM_AppName_guidanzmobile) {
        	clonedApp.IAM_swregExpire__c = originalApp.IAM_swregExpire__c;
            clonedApp.IAM_Guidanz_Mobile_Roles__c = originalApp.IAM_Guidanz_Mobile_Roles__c;
        }
        clonedApp.IAM_Status__c = originalApp.IAM_Status__c;
        clonedApp.IAM_Subscription_Name__c = originalApp.IAM_Subscription_Name__c;
        clonedApp.IAM_License_Type__c = originalApp.IAM_License_Type__c;
        clonedApp.IAM_Source__c = originalApp.IAM_Source__c;
        clonedApp.RecordtypeId = originalApp.RecordtypeId;
        return clonedApp;
    }
    
    /* Return List of HQ Location */
    private static Map<Id, Account> getHQLocations(Set<Id> accIdSet) {
        Return new Map<ID, Account>([
            SELECT Id
              FROM Account
             WHERE Id IN : accIdSet
               AND CMI_Account_Status__c = :Label.IAM_Status_Active
               AND (EBU_Channel_Of_Distribution__c = :Label.IAM_Distribution_Channel_National_Acct_CIHR_HQ
                OR EBU_Channel_Of_Distribution__c = :Label.IAM_Distribution_Channel_Special_Account_HQ
                OR PSBU_Channel_Of_Distribution__c = :Label.IAM_Distribution_Channel_National_Acct_CIHR_HQ
                OR PSBU_Channel_Of_Distribution__c = :Label.IAM_Distribution_Channel_Special_Account_HQ)
        ]);
    }
    
    /* Return list of IAM_Application__c of (Account Subscriptions) of HQ locations */
    private static List<IAM_Application__c> getHQLocationAppSubscriptions(Set<Id> HQLocationIdSet) {
        return [
            SELECT Id
                 , IAM_Account_Name__c
                 , IAM_Application_Name__c
                 , IAM_Subscription_Start_Date__c
                 , IAM_Subscription_End_Date__c
                 , IAM_Subscription_Count__c
                 , IAM_Role__c
                 , IAM_Qsolexpiration__c
            	 , IAM_swregExpire__c
            	 , IAM_Guidanz_Mobile_Roles__c
                 , IAM_Free_Subscription__c
                 , IAM_Status__c
                 , IAM_Subscription_Name__c
                 , IAM_License_Type__c
                 , IAM_Source__c
                 , RecordtypeId
              FROM IAM_Application__c
             WHERE IAM_Account_Name__c IN :HQLocationIdSet
               AND IAM_Source__c = 'SwReg'
               AND IAM_Status__c = :Label.IAM_Status_Active
               AND ( IAM_Application_Name__c = :Label.IAM_AppName_QSOL
                OR IAM_Application_Name__c = :Label.IAM_AppName_EDS
                OR IAM_Application_Name__c = :Label.IAM_Cummins_Service_Training
                OR IAM_Application_Name__c = :Label.IAM_AppName_Guidanz
                OR IAM_Application_Name__c = :Label.IAM_AppName_guidanzmobile)            
        ];
    }
    
    /* Return list of IAM_Application__c of (Account Subscriptions) of CIHR locations */
    private static List<IAM_Application__c> getCIHRLocationAppSubscriptions(Set<Id> CIHRLocationIdSet) {
        return [
            SELECT Id
                 , IAM_Account_Name__c
                 , IAM_Status__c
              FROM IAM_Application__c
             WHERE IAM_Account_Name__c IN :CIHRLocationIdSet
               AND IAM_Status__c = :Label.IAM_Status_Active
               AND ( IAM_Application_Name__c = :Label.IAM_AppName_QSOL
                OR IAM_Application_Name__c = :Label.IAM_AppName_EDS
                OR IAM_Application_Name__c = :Label.IAM_Cummins_Service_Training
                OR IAM_Application_Name__c = :Label.IAM_AppName_Guidanz
                OR IAM_Application_Name__c = :Label.IAM_AppName_guidanzmobile)            
        ];
    }
    
    //get parent account to Identify the names
    Private Static Map<id,Account> getParentAccounts(List<Account> acnts){
        Map<id,Account> parentAccounts=new Map<id,Account>();
        Set<id> accids=new Set<id>();
        
        for(Account a:acnts){
           accids.add(a.Parentid); 
        }
        
        if(!accids.isEmpty()){
            List<Account> parents=[SELECT Id, Name, Type FROM Account WHERE Id=:accids];
            if(!parents.isEmpty()){
                for(Account ap:parents){
                    ParentAccounts.put(ap.id,ap);
                }
            }
        } 
        System.debug('Printing parent accounts'+ParentAccounts);
        return parentAccounts;
    }
}