global class OSM_ccLogicUserGetProfileDataCustom extends ccrz.ccLogicUserGetProfileData
{

    /**
     * @usage
     *   This extension is necessary for the my account page to work
     *    This method is used for associating any contact of your choosing to the current logged in user
     *   For this POC, we used a hard-coded  SFID for the contact.
     *   Ensure you update this section of the code as needed.
     *   Finally, ensure you configure this logic service class in CC Admin
     */
  global  override Map<String, Object> getContactData(Map<String, Object> inputData) 
{       
    try{
        Object contactId = null;
    
        if(ccrz.ccUtil.isKeyValued(inputData, ccrz.ccApiContact.ID)) 
        {
            contactId = inputData.get(ccrz.ccApiContact.ID);
            ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom getContactData 1' +contactId);
        } 
        else 
        {
            Map<String, Object> userData = (Map<String, Object>)inputData.get(ccrz.ccApiUser.USER_DATA_MAP);
            contactId = userData.get('contactId');
            ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom getContactData 2' +contactId);
        }
        
        if (null == contactId)
        {

            // Yubo doing Poc, please update below code incase needed
            ID currUserId = UserInfo.getUserId();
            String userType = OSM_SW_General_Util.getuserType(currUserId);
            // PageReference effcontact= ApexPages.currentPage();
            // ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom contactResult 0'+effcontact);\


            Id userId = UserInfo.getUserId();
            Boolean effectiveSelectEnabled = false;
            List<User> currUser = [SELECT Id, OSM_Storefront_User_Type__c FROM User WHERE id=:userId];
            if(!currUser.isEmpty()){
                if(!String.isBlank(currUser[0].OSM_Storefront_User_Type__c)){
                    effectiveAccount_enable_ProfileUserType__c featureSwitch =  effectiveAccount_enable_ProfileUserType__c.getInstance(String.valueOf(currUser[0].OSM_Storefront_User_Type__c));
                    if(featureSwitch != null)
                        effectiveSelectEnabled = featureSwitch.Enable_Effective_Account_Selection__c;
                }
            }
            if(effectiveSelectEnabled){
                List<Contact> currCont = new List<Contact>();
                currCont = [SELECT Id,OSM_Distributor_Admin_Last_Sel__c,sessionIdRecord__c from Contact WHERE IAM_Contact_Owner__c =:currUserId];
                if(!currCont.isEmpty() && String.isNotBlank(currCont[0].OSM_Distributor_Admin_Last_Sel__c) && Cache.Session.contains('accContactSelected')){
                    contactId = currCont[0].OSM_Distributor_Admin_Last_Sel__c;
                }else{
                    ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom getContactData 3 ' +currCont[0]);
                    if(currCont.size() > 0){
                    contactId = currCont[0].Id;
                    }
                }

                
                // contactId = effcontact.getValue();
            // } else if(Label.OSM_Distributor_Admin_UserType == userType){

            }


        }
        ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom contactResult 1');
        Map<String, Object> contactResult = ccrz.ccApiContact.fetch(new Map<String, Object> {
                ccrz.ccApi.API_VERSION => inputData.get(ccrz.ccApi.API_VERSION),
                ccrz.ccApiContact.ID => contactId,
                ccrz.ccApi.SIZING=>new Map<String, Object>{
                        ccrz.ccApiContact.ENTITYNAME=>new Map<String, Object>{
                                ccrz.ccApi.SZ_DATA=>ccrz.ccApi.SZ_L
                        }
                }
        });
        ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom contactResult '+contactResult);
        List<Map<String, Object>> contactList = (List<Map<String, Object>>) contactResult.get(ccrz.ccApiContact.CONTACTS);
     	ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom getContactData 5'+contactList);
        //ccrz.ccLog.log(LoggingLevel.DEBUG, 'Jamiu:inputData_contactList', contactList);
    
        if(ccrz.ccUtil.isNotEmpty(contactList)) 
        {
            inputData.put(ccrz.ccApiUser.USER_PROFILE_CONTACT, contactList.get(0));
        }
        
        inputData.put(ccrz.ccApi.MESSAGES, contactResult.get(ccrz.ccApi.MESSAGES));
        ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom getContactData 4');
        
    } catch(Exception e){
        System.debug('e line: '+e.getLineNumber()+' e cause: '+e.getCause());
        ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom Exception'+e.getLineNumber()+' e cause: '+e.getCause());
    }
    return inputData;
}
    
  /**
     * @usage
     *   This extension is necessary for the my account page to work
     *    This method is used for associating any account of your choosing to the current logged in user
     *   For this POC, we used a hard-coded  SFID for the account.
     *   Ensure you update this section of the code as needed.
     */  
    global  override Map<String, Object> getAccountData(Map<String, Object> inputData) 
    {
        Object accountId = null;
        ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom');
        if(ccrz.ccUtil.isKeyValued(inputData, ccrz.ccApiAccount.ID)) 
        {
            accountId = inputData.get(ccrz.ccApiAccount.ID);
            ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom getAccountData 1 : '+accountId);
        }
        else 
        {
            Map<String, Object> userData = (Map<String, Object>)inputData.get(ccrz.ccApiUser.USER_DATA_MAP);
            
            accountId = userData.get('accountId');
            ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom getAccountData 2 : '+accountId);
        }
        // POC - hardcoding for now
        if (null == accountId)
        {
            Id currUserId = UserInfo.getUserId();
            
            Boolean enableEffect = OSM_SW_General_Util.getEffEnabled();
            List<Contact> currCont = new List<Contact>();
            currCont = [SELECT Id,Account.ID,OSM_Distributor_Admin_Last_Sel_acc__c from Contact WHERE IAM_Contact_Owner__c =:currUserId];
            ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom getAccountData 3 ' +accountId);
            if(enableEffect){
                String sessionId=UserInfo.getSessionId();
                if(!currCont.isEmpty() && String.isNotBlank(currCont[0].OSM_Distributor_Admin_Last_Sel_acc__c) && Cache.Session.contains('accContactSelected')){
                    accountId = currCont[0].OSM_Distributor_Admin_Last_Sel_acc__c;
                }else{
                    ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom getAccountData 4 ' +currCont[0]);
                    if(currCont.size() > 0){
                    accountId = currCont[0].Account.ID;
                    }
                }

            }

           

            if(currCont.size() > 0){
              accountId = currCont[0].Account.ID; 
            }
            
            //            currCont = [SELECT Id, Account.ID from Contact WHERE IAM_Contact_Owner__c =:currUserId];
            
            
            //accountId = '0013C000008Mzbh';
        }
        Map<String, Object> accountResult = ccrz.ccApiAccount.fetch(new Map<String, Object> {
                ccrz.ccApi.API_VERSION => inputData.get(ccrz.ccApi.API_VERSION),
                ccrz.ccApiAccount.ID => accountId
        });
    
        List<Map<String, Object>> accountList = (List<Map<String, Object>>) accountResult.get(ccrz.ccAPIAccount.ACCOUNTS);
    
        if(ccrz.ccUtil.isNotEmpty(accountList)) 
        {
            inputData.put(ccrz.ccApiUser.USER_PROFILE_ACCOUNT, accountList.get(0));
        }
        inputData.put(ccrz.ccApi.MESSAGES, accountResult.get(ccrz.ccApi.MESSAGES));
        
        return inputData;
    }
    global virtual override Map<String, Object> decorateContactData(Map<String, Object> inputData) {
     
        // run the default implementation
        Map<String, Object> contact = (Map<String, Object>)inputData.get(ccrz.ccApiUser.USER_PROFILE_CONTACT);
        Map<String, Object> retdata = new Map<String, Object>();
        ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom decorateContactData ccrz.ccApiUser.USER_PROFILE_CONTACT ' +ccrz.ccApiUser.USER_PROFILE_CONTACT);
        ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom decorateContactData inputData ' +inputData);
        ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom decorateContactData ' +contact);
        retdata  = super.decorateContactData(inputData);
        ccrz.ccLog.log('OSM_ccLogicUserGetProfileDataCustom decorateContactData 2 ' +contact);
        // replace the information
        // Map<String, Object> contact = (Map<String, Object>)input.get(ccrz.ccApiUser.USER_PROFILE_CONTACT);
        // contact.put('firstName', contact.get('sfid'));
 
        return retdata;
    }    


}