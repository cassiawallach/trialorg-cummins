global with sharing class OSM_SW_ccServiceContact extends ccrz.ccServiceContact
{
    /* comment out this code trying to fix the login issue on 14 oct.
    // CHANGE for DISTRIBUTOR_ADMIN_License Issue
    global virtual override Map<String, Object> getFilterMap(Map<String, Object> inputData)
    {        
        Map<String, Object> filterMap = super.getFilterMap(inputData);
        Cookie effcontact = ApexPages.currentPage().getCookies().get('effcontact');

        ccrz.ccLog.log('OSM_SW_ccServiceContact effcontact' +effcontact);
        ccrz.ccLog.log('OSM_SW_ccServiceContact effcontact ' +effcontact.getValue());

        ID currUserId = UserInfo.getUserId();
        String userType = OSM_SW_General_Util.getuserType(currUserId);
        ccrz.ccLog.log('OSM_SW_ccServiceContact currUserId' +currUserId);
        System.debug('OSM_SW_ccServiceContact currUserId ' +currUserId);
        // that means he is PLatform and not doing CSR flow
        ccrz.ccLog.log('OSM_SW_ccServiceContact userType' +userType);
        System.debug('OSM_SW_ccServiceContact userType ' +userType);
        if(null == ccrz.cc_CallContext.currUser.ContactId && Label.OSM_Distributor_Admin_UserType == userType )
        {   Contact con;
            // first check on cookie contact , then check IAM_Contact_Owner__C
            List<Contact> cons = [Select ID, IAM_Contact_Owner__c from Contact where IAM_Contact_Owner__c =:currUserId LIMIT 1];     
            ccrz.ccLog.log('OSM_SW_ccServiceContact cons' +cons); 
            System.debug('OSM_SW_ccServiceContact cons' +cons);
            if(!cons.isEmpty()){
                con =  cons[0];
            }
           
            
            // This map will be empty for users with platform licenses
            if (filterMap.isEmpty())
            {
                  String filterCriteria = 'id = \'' +  con.id + '\'';
                
                  filterMap.put(ccrz.CCAPIContact.ID, filterCriteria);
            }
        }
        
        return filterMap;  
    }*/
    
    
    // added code from dev to SIT to fix login issue  on 14 oct
    // CHANGE for DISTRIBUTOR_ADMIN_License Issue
    global virtual override Map<String, Object> getFilterMap(Map<String, Object> inputData)
    {        
        Map<String, Object> filterMap = super.getFilterMap(inputData);
        
        ID currUserId = UserInfo.getUserId();
        //ccrz.ccLog.log('OSM_SW_ccServiceContact effcontact ContactId' +ccrz.cc_CallContext.currUser.ContactId);
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
        
        if(effectiveSelectEnabled)
        {            
            Contact con = [Select ID, IAM_Contact_Owner__c,OSM_Distributor_Admin_Last_Sel__c,OSM_Distributor_Admin_Last_Sel_acc__c from Contact where IAM_Contact_Owner__c =:currUserId LIMIT 1];
            // Cookie effcontact = ApexPages.currentPage().getCookies().get('effcontact');
            String sessionId=UserInfo.getSessionId();
            ccrz.ccLog.log('OSM_SW_ccServiceContact effcontact in if now' +Cache.Session.get('accContactSelected'));
            // ccrz.ccLog.log('OSM_SW_ccServiceContact effcontact' +effcontact);
            if(con != null && String.isNotBlank(con.OSM_Distributor_Admin_Last_Sel__c) && Cache.Session.contains('accContactSelected')){
                
                String conCookieCriteria = 'id =\''+ con.OSM_Distributor_Admin_Last_Sel__c +'\'';
                // String accCookieCriteria = 'id =\''+ con.OSM_Distributor_Admin_Last_Sel_acc__c +'\'';
                filterMap.put(ccrz.CCAPIContact.ID, conCookieCriteria );
                
            } else if(filterMap.isEmpty()){
                ccrz.ccLog.log('OSM_SW_ccServiceContact con.id ' +con.id);
                String filterCriteria = 'id = \'' +  con.id + '\'';
                filterMap.put(ccrz.CCAPIContact.ID, filterCriteria);
            }

            // This map will be empty for users with platform licenses
            // if (filterMap.isEmpty())
            // {

            // }
        }
        
        return filterMap;  
    }
}