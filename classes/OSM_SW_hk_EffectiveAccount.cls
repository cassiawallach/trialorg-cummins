global with sharing class OSM_SW_hk_EffectiveAccount extends ccrz.cc_hk_EffectiveAccount {
    global virtual override Map<String,Object> fetchAccounts(Map<String,Object> inputData) {
        String accountID = (String) inputData.get(PARAM_ACCOUNT_ID);

        ccrz.ccLog.log('FIL_FGP_hk_EffectiveAccount: EN: fetchAccounts inputData--->' + inputData);

        ccrz.cclog.log('FIL_FGP_hk_EffectiveAccount ccrz.cc_CallContext.currUserId: EN: ');

        // Jan 29, updated by Yubo for SSOEM update, we will start to use 
        try {
            String distributorProfilename = Label.DistributorAdminProfileName;
            ccrz.ccLog.log('OSM_SW_hk_EffectiveAccount: EN: filterAccounts distributorProfilename' + distributorProfilename);
            Id profileId = UserInfo.getProfileId();
            Id userId = ccrz.cc_CallContext.currUserId;
            Boolean effectiveSelectEnabled = false;
            String profileName =[Select Id, Name from Profile where Id=:profileId].Name;
            ccrz.ccLog.log('OSM_SW_hk_EffectiveAccount: EN: filterAccounts profileName' + profileName);
            List<User> currUser = [SELECT Id, OSM_Storefront_User_Type__c FROM User WHERE id=:userId];
            String userType = '';
            if(!currUser.isEmpty()){
                if(!String.isBlank(currUser[0].OSM_Storefront_User_Type__c)){
                    effectiveAccount_enable_ProfileUserType__c featureSwitch =  effectiveAccount_enable_ProfileUserType__c.getInstance(String.valueOf(currUser[0].OSM_Storefront_User_Type__c));

                    effectiveSelectEnabled = featureSwitch.Enable_Effective_Account_Selection__c;
                    userType = featureSwitch.Name;
                }
            }
           ccrz.ccLog.log(LoggingLevel.DEBUG,'effectiveSelectEnabled  ' + effectiveSelectEnabled + '   ::'+userType);
           ccrz.ccLog.log('OSM_SW_hk_EffectiveAccount: EN: filterAccounts accountID' + accountID);
            
            if(effectiveSelectEnabled){
                List<Account> accountList;
                //if(profileName == distributorProfilename){
                ccrz.ccLog.log('OSM_SW_hk_EffectiveAccount: EN: accContactSelected  ' + Cache.Session.contains('accContactSelected'));
                if(accountID != ccrz.cc_CallContext.effAccountId && !Cache.Session.contains('accContactSelected')){
                    ccrz.ccLog.log('OSM_SW_hk_EffectiveAccount: EN: accContactSelected 1');
                    ccrz.cc_CallContext.effAccountId = accountID;
                }
                      system.debug('userType'+userType);
                if(userType == 'Distributor Admin'){
                    
                    Account currAcc = OSM_SW_AccountDao.getDistributorAdminAccountRelateData(accountID); 
                    if(currAcc.Type == 'Distributor Branch Account'){
                        accountList = OSM_SW_AccountDao.getDistributorAccountsHierarchy(currAcc.Parent.ParentId);
                    }else{
                        accountList = OSM_SW_AccountDao.getDistributorAccountsHierarchy(currAcc.ParentId);
                    }

                    ccrz.ccLog.log('OSM_SW_hk_EffectiveAccount: EN: filterAccounts accountList 1' + accountList);
               }

                else{
                    accountList = OSM_SW_AccountDao.getAccountsHierarchy(accountID);
                    ccrz.ccLog.log('OSM_SW_hk_EffectiveAccount: EN: filterAccounts accountList 2' + accountList);
                }
                List<ccrz.cc_bean_EffectiveAccount> effAcctBeans = new List<ccrz.cc_bean_EffectiveAccount>();
                
                map<string,account> accountmap = new map<string,account>();
                list<account> sortedaccounts =new list<account>();
                for(Account acc:accountList)accountmap.put(acc.name,acc);
                list<string> sortvalues = new list<string>(accountmap.keyset());
                sortvalues.sort();
                for(string str :sortvalues){
                    if(accountmap.containskey(str)){
                       sortedaccounts.add(accountmap.get(str));   
                    }
                }
                Set<Id> accountSet = new Set<Id>();
                for (Account acct: sortedaccounts) {
                    accountSet.add(acct.Id);
                    ccrz.cc_bean_EffectiveAccount acctBean = new ccrz.cc_bean_EffectiveAccount(acct);
                    // change to acctBean extrinsic Map<String, String>
                    acctBean.accountType=acct.accountNumber;////Rupesh Added
                    Map<String, String> externalData = new Map<String,String>();
                    externalData.put('LocationCode', acct.IAM_Service_Provider_Code__c);
                    //externalData.put('DistributorType', acct.Type);
                    externalData.put('DistributorType', 'Distributor Branch Account');
                    if(accountID == acct.Id){
                        externalData.put('DistributorType','Distributor Account');
                    }
                    
                    acctBean.extrinsic = externalData;
                        
                    effAcctBeans.add(acctBean);
                    
                    // ccrz.ccLog.log('ACNO: OSM_SW_hk_EffectiveAccount: EN: filterAccounts acctBean ' + acct.name);
                    // ccrz.ccLog.log('OSM_SW_hk_EffectiveAccount: EN: filterAccounts acctBean' + acctBean);
                }
                ccrz.ccLog.log('OSM_SW_hk_EffectiveAccount: EN: filterAccounts accountList size' + accountList.size());
                ccrz.ccLog.log('OSM_SW_hk_EffectiveAccount: EN: filterAccounts effAcctBeans size' + effAcctBeans.size());
                inputData.put(PARAM_EFFACCOUNT_LIST, effAcctBeans);
                return inputData;
        

            }
        
             else{
                // if(accountList.isEmpty()){
                    ccrz.ccLog.log('ACNO: OSM_SW_hk_EffectiveAccount: EN: filterAccounts acctBean Land in else statement');
                    system.debug('inputData------------'+inputData);
                    Map<String,Object> ori_returnMap = super.fetchAccounts(inputData);
                 
                 system.debug('ori_returnMap'+ori_returnMap);
                    Set<String> accKey = ori_returnMap.keySet();
                    List<ccrz.cc_bean_EffectiveAccount> effectAccts = new List<ccrz.cc_bean_EffectiveAccount>();
                    Set<String> accIds = new Set<String>();
                    accIds.add(String.valueOf(inputData.get('AccountID')));

                    List<Account> effacctList = OSM_SW_AccountDao.getAListOfAccount(accIds);
                    for(Account effacct :effacctList){
                        ccrz.cc_bean_EffectiveAccount newacctBean = new ccrz.cc_bean_EffectiveAccount(effacct);
                        effectAccts.add(newacctBean);
                    }
                    ccrz.ccLog.log('ACNO: OSM_SW_hk_EffectiveAccount: EN: filterAccounts acctBean effectAccts size'+effectAccts.size());
                    ori_returnMap.put('EffectiveAccounts',effectAccts);

                    return ori_returnMap;

                // }

            }


        }catch (Exception ex) {

            ccrz.ccLog.log('FIL_FGP_hk_EffectiveAccount: ERR: filterAccounts Message--->' + ex.getMessage());
            ccrz.ccLog.log('FIL_FGP_hk_EffectiveAccount: ERR: filterAccounts Line Number--->' + ex.getLineNumber());
            ccrz.ccLog.log('FIL_FGP_hk_EffectiveAccount: ERR: filterAccounts Cause--->' + ex.getCause());
            
            system.debug('Eroor'+ex.getMessage());
            system.debug('Eroor'+ex.getLineNumber());
            system.debug('Eroor'+ex.getCause());
        }

        ccrz.ccLog.log('FIL_FGP_hk_EffectiveAccount: effectiveAccount' + ccrz.cc_CallContext.currAccountId+'  <==>'
                                             +ccrz.cc_CallContext.effAccountId);
        return inputData;
    }

}