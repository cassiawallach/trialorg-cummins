/*************************************************************************************
Name:  IAM_RC_UserGroupMapping
Copyright © 2019  Cummins
**************************************************************************************
Purpose: This class is used to add user to LDAP groups 2. It is outbound API 
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Keerthy Gutumurthy        11/16/2018        INITIAL DEVELOPMENT
1.1      Karthik Raj Golakaram     11/16/2020        Made Changes for Mule API 
1.2      Shubhangi Sardar          27/04/2021        LDAP Sync Issue Fix
**************************************************************************************
**************************************************************************************/
public without sharing class IAM_RC_UserGroupMapping {
    
    @future(callout=true)
    public static void basicAuthCallout(Set<Id> cpId, Map<Id,String> contAppAdd, Boolean isFromUpdate) {
        String JSON_String = '';
        String errorDescription = '';
        String accessToken = '';
        CSS_Integration_Details__c iamLDAPgroup = IAM_getConnnectionDetails.getConnection('IAM_LDAP_Group_Addition_Mule');
        if(!Test.IsRunningtest()) {
            /* Mule Access Token */
            accessToken = IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_Mule_oAuth');
        }
        List<String> appList = new List<String>();
        appList = Label.IAM_LDAP_Group_App_Name.split(';');
        List<IAM_Contact_Provisioning__c> contactProvisioningList = getConProList(cpId, appList); 
        System.debug('Print:: '+contactProvisioningList);
        if(contactProvisioningList == null || contactProvisioningList.isEmpty()) {
            return;
        }
        UserPayload uinfo = new UserPayload(contactProvisioningList, contAppAdd, isFromUpdate);
        System.debug('Printing request wrapper :: '+ uinfo);        
        try{
            if(uinfo != null) {
                JSON_String = JSON.serialize(uinfo);
                System.debug('Printing serialized string sumit'+JSON_String);
            }
            
            Map<String, String> headerMap = new Map<String, String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization','Bearer '+accessToken);
            headerMap.put('resource',iamLDAPgroup.Resource__c);

            /* Get Response */
            HttpResponse res = IAM_HTTP_Callout.sendHTTPRequest(iamLDAPgroup.Method_Type__c,
            iamLDAPgroup.End_Point__c, headerMap, JSON_String);

            
            if(res != null && res.getStatusCode() == 200){
                String response = res.getBody();
                Boolean errorInResopnse = false;
                if(String.isNotBlank(response)) {
                    List<String> msgList = Label.IAM_LDAP_Messages.split(',');
                    List<IAM_LDAP_Util_Wrapper> ldapResponse = (List<IAM_LDAP_Util_Wrapper>)JSON.deserialize(
                        response, List<IAM_LDAP_Util_Wrapper>.class);
                    System.debug('ldapResponse@@'+ldapResponse); 
                    for(IAM_LDAP_Util_Wrapper objwrapper : ldapResponse){
                        if(!msgList.contains(objwrapper.status)){
                            errorInResopnse = true;
                            break;
                        }
                    }
                }
                if(errorInResopnse){
                    IAM_ErrorHandling.IAMerrorCapture(JSON_String, Label.IAM_Identity_LDAP,
                    res.getBody(), IAM_RC_UserGroupMapping.class.getName());
                }
            } else if(res != null && res.getStatusCode() != 200) {
                IAM_ErrorHandling.IAMerrorCapture(JSON_String, Label.IAM_Identity_LDAP,
                res.getBody(), IAM_RC_UserGroupMapping.class.getName());
            }
        } catch(Exception e){
            System.debug('ERROR Message:-->:'+ e.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(JSON_String, Label.IAM_Identity_LDAP,
            e.getStackTraceString() + ' - ' + e.getMessage(), IAM_RC_UserGroupMapping.class.getName());
        }
    }
    
    /* Request Wrapper */
    public class UserPayload {
        public List<UserApp> Userinfo {set; get;}
        public UserPayload(List<IAM_Contact_Provisioning__c> contactProvisioningList,
        Map<id,String> appAddRoles, Boolean fromUpdateTrigger) {
            /* Get IAM_Application_Groups__c Custom Setting Values */
            List<IAM_Application_Groups__c> iamAppGroup = IAM_Application_Groups__c.getall().values();
            Map<String,IAM_Application_Groups__c> mapIamAppGrp = new Map<String,IAM_Application_Groups__c>();
            for(IAM_Application_Groups__c iamAppGrp : iamAppGroup){
                mapIamAppGrp.put(iamAppGrp.IAM_Application_Name__c + iamAppGrp.IAM_Role_Name__c,iamAppGrp);
            }
            Map<String, List<IAM_Contact_Provisioning__c>> conMap =
                new Map<String, List<IAM_Contact_Provisioning__c>>();
            /* Create Map of Contact Vs its all Contact Provisioning */
            for(IAM_Contact_Provisioning__c icp : contactProvisioningList) {
                if(conMap.containsKey(icp.IAM_Contact__r.Username__c)) {
                    conMap.get(icp.IAM_Contact__r.Username__c).add(icp);
                } else {
                    conMap.put(icp.IAM_Contact__r.Username__c, 
                    new List<IAM_Contact_Provisioning__c> {icp});
                }
            }
            
            Userinfo = new List<UserApp>();
            for(String username : conMap.keySet()) {
                List<IAM_Contact_Provisioning__c> conProList = conMap.get(username);
                
                Map<String,Set<String>> roleMap = new Map<String,Set<String>> ();
                for(IAM_Contact_Provisioning__c conPro : conProList) {
                    Set<String> roleSet = new Set<String>();
                    List<String> delimitedRoleList = new List<String> ();
                    if(!fromUpdateTrigger){
                        /* Here roles will be from IAM_Role__c field. */
                        delimitedRoleList = conPro.IAM_Role__c.split(';');
                    } else {
                        /* Here the roles will be from the map which we will get from trigger. */
                        if(!appAddRoles.isEmpty() && appAddRoles.containsKey(conPro.Id)){
                            delimitedRoleList = appAddRoles.get(conPro.Id).split(';');                        
                        }
                    }                
                    System.debug('Printing values in the delimited List'+delimitedRoleList);                
                    roleSet.addAll(delimitedRoleList);
                    if(roleMap.containsKey(conPro.IAM_Application_Name__c)) {
                        roleMap.get(conPro.IAM_Application_Name__c).addAll(roleSet);
                    } else {
                        roleMap.put(conPro.IAM_Application_Name__c, roleSet);
                    }
                }
                Map<String, String> groupTypeMap = new Map<String, String>();
                for(String appName : roleMap.keySet()) {
                    for(String roleName : roleMap.get(appName)) {
                        /*if(mapIamAppGrp.containsKey(appName + roleName)) {
                            uinfo.grouptype = mapIamAppGrp.get(appName + roleName).IAM_Group_Type__c;
                            if(String.isBlank(uinfo.applicationGroups)) {
                                uinfo.applicationGroups = mapIamAppGrp.get(appName + roleName).IAM_DN_value__c;
                            } else {
                                uinfo.applicationGroups = uinfo.applicationGroups + '||' 
                                + mapIamAppGrp.get(appName + roleName).IAM_DN_value__c;
                            }
                        }*/
                        
                        if(mapIamAppGrp.containsKey(appName + roleName)) {
                            String groupType = mapIamAppGrp.get(appName + roleName).IAM_Group_Type__c;
                            groupType = groupType.toLowerCase();
                            String applicationGroup = mapIamAppGrp.get(appName + roleName).IAM_DN_value__c;
                            if(groupTypeMap.containsKey(groupType)) {
                                String allAppGroup = groupTypeMap.get(groupType) + '||' + applicationGroup;
                                groupTypeMap.put(groupType, allAppGroup);
                            } else {
                                groupTypeMap.put(groupType, applicationGroup);
                            }
                        }
                    }
                }
                for(String groupType : groupTypeMap.keySet()) {
                    IAM_Contact_Provisioning__c icp = conProList[0];
                    UserApp uinfo = new UserApp();
                    uinfo.uid = username;
                    uinfo.branch = IAM_Utility.getBranchName(icp.IAM_Contact__r.IAM_DN_Value__c);
                    uinfo.usertype = IAM_Utility.getUserType(icp);
                    uinfo.workgroupId = getWorkgroupId(icp);
                    uinfo.grouptype = groupType;
                    uinfo.applicationGroups = groupTypeMap.get(groupType);
                    Userinfo.add(uinfo);
                }
            }            
        }      
    }

    /* Interanl Wrapper Class */
    public class UserApp{
        public String uid;
        public String applicationGroups;
        public String grouptype;
        public String workgroupId;
        public String branch;
        public String usertype;
    }

    /* Return List of IAM_Contact_Provisioning__c for given Ids */
    public static List<IAM_Contact_Provisioning__c> getConProList(Set<Id> conProIdSet,
    List<String> appList) {
        return [
            SELECT Id
                 , IAM_Contact__r.Username__c
                 , IAM_Contact__r.IAM_Contact_Status__c
                 , IAM_Contact__r.IAM_Internal__c
                 , IAM_Contact__r.IAM_Legacy_User__c
                 , IAM_Contact__r.IAM_Applications__c
                 , IAM_Contact__r.IAM_Work_Group_Id__c
                 , IAM_Contact__r.IAM_DN_Value__c
                 , IAM_Application_Name__c
                 , IAM_Role__c 
              FROM IAM_Contact_Provisioning__c 
             WHERE Id IN :conProIdSet
               AND IAM_Application_Name__c IN :appList
          ORDER BY IAM_Contact__r.Username__c
        ]; 
    }

    /* Return Workgroup Id of a user */
    public static String getWorkgroupId(IAM_Contact_Provisioning__c icp) {
        if(String.isNotBlank(icp.IAM_Contact__r.IAM_Work_Group_Id__c)) {
            return icp.IAM_Contact__r.IAM_Work_Group_Id__c;
        } else {
            return '';
        }
    }
}