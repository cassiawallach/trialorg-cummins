/*************************************************************************************
Name:  IAM_Reclaim_Queable_API_Class
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It is queueable class to call LDAP API from reclaim process flow 
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Karthik Raj Golakaram     09/02/2020        INITIAL DEVELOPMENT 
1.1      Karthik Raj Golakaram     12/09/2020     Made changes for Mule API conversion
1.2      Karthik Raj Golakaram     03/21/2021     Made changes for the Partner JIT class
1.3      Shubhangi Sardar          27/04/2021     LDAP Sync Issue Fix
**************************************************************************************
**************************************************************************************/

public class IAM_Reclaim_Queable_API_Class implements Queueable, Database.AllowsCallouts {
    private Boolean isDupContUser;
    private Contact cn;
    public Map<String,Boolean> reclaimTracker;
    public boolean fromJITClass;
    
    public IAM_Reclaim_Queable_API_Class(Contact cn, Boolean isDupContUser) {
        this.cn = cn;
        this.isDupContUser = isDupContUser;
        this.reclaimTracker = new Map<String,Boolean>();
        this.fromJITClass = false;
    }

    //Changes added by Karthik - 03/21/2021
    public IAM_Reclaim_Queable_API_Class(Contact cn){
        this.cn = cn;
        this.isDupContUser = false;
        this.reclaimTracker = new Map<String,Boolean>();
        this.fromJITClass = true;
    }
    //End of addition if changes - 03/21/2021

    public void execute(QueueableContext Context){
        try {            
            //Calling LDAP Services.
            if(isDupContUser) {
                System.debug('MoveUser Test');
                IAM_LDAP_Util_MoveUser_ApexCallout.LDAP_reclaim_moveuser(cn.Username__c, cn.email, 'other');
            } else {
                //code to make a call out for LDAP util to create user in External branch.
                reclaim_LDAP_API_calls(cn.username__c, cn.IAM_Ext_Legacy_UID__c, cn.email,cn.id,
                'insert', reclaimTracker);
            }
    
            /* Call update Contact Provisionings from Queable class to create/update Contact Provision */
            if(!fromJITClass){
                ID jobID = System.enqueueJob(new IAM_Reclaim_ConProv_Process_Queable(cn));
                System.debug('Printing Secondary JOB ID'+jobID); 
            } 
        } catch(Exception e) {
            System.debug('Printing Exception '+e);
            System.debug('Printing Exception stack Trace String'+e.getStackTraceString());
            String processedData = 'Method - execute, Contact Id - ' + cn.Id;
            IAM_ErrorHandling.IAMerrorCapture(processedData, Label.IAM_Reclaim_Flow + '-' + Label.IAM_Identity_LDAP, e.getStackTraceString() + ' - ' + e.getMessage(), IAM_Reclaim_Queable_API_Class.class.getName());
        }
    }

    /* Call LDAP API to create new user (after reclaim) in LDAP */
    public static void reclaim_LDAP_API_calls(String username, String LegacyId, String email, Id conids,
    String action, Map<String,boolean> reclaimTracker){
        
        System.debug('Printing Contact ids in Reclaim '+conids);
        /* Call request parser class to get the request */
        String JSONString = IAM_LDAP_Util_ReqParser_Reclaim.IAM_LDAP_Util_ReqBody_Reclaim(username,
        LegacyId, email, conids);
        System.debug('Printing request Body' + JSONString);
        string errorDescription='';
        HttpResponse res;
        CSS_Integration_Details__c iamLDAP = new CSS_Integration_Details__c();
        String accessToken;
        if(Test.isRunningTest()) {
            accessToken = 'lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz';
            System.debug('#### In Test.isRunningTest - accessToken - '+accessToken);
        } else {
            /* Added by Karthik -12-09-200 for Mule  */
            accessToken=IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_Mule_oAuth');
        }        
        if(action == 'Insert'){
            iamLDAP = IAM_getConnnectionDetails.getConnection('IAM_LDAP_Create_Mule');
        }else if(action == 'Update'){
            iamLDAP = IAM_getConnnectionDetails.getConnection('IAM_LDAP_Update_Mule');
        }
    
        if(String.isNotBlank(JSONString)){
            Map<String, String> headerMap = new Map<String, String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization','Bearer '+accessToken);
            headerMap.put('resource',iamLDAP.Resource__c);

            /* Get Response */
            if(!Test.isRunningTest()) {
                res = IAM_HTTP_Callout.sendHTTPRequest(iamLDAP.Method_Type__c,
                iamLDAP.End_Point__c, headerMap, JSONString);
            } else {
                HttpResponse responseTest = new HttpResponse();
                responseTest.setStatusCode(200);
                responseTest.setBody(Label.IAM_LDAP_Success_Messgae);
                res = responseTest;
            }
            if(res != null && res.getStatusCode() == 200) {
                if(String.isNotBlank(res.getBody()) 
                && res.getBody().containsIgnoreCase(Label.IAM_LDAP_Success_Messgae)){
                    System.debug('Printing response condition is true' + res.getBody());
                    reclaimTracker.put('is_LDAP_Insert_API', true);
                    reclaim_GroupMapping_API(conids, reclaimTracker);
                } else {
                    IAM_ErrorHandling.IAMerrorCapture(JSONString, Label.IAM_Reclaim_Flow + '-' + Label.IAM_Identity_LDAP, 'LDAP Create User API - ' + res.getBody(), IAM_Reclaim_Queable_API_Class.class.getName());                    
                }
            } else if(res != null && res.getStatusCode() != 200 ){                
                IAM_ErrorHandling.IAMerrorCapture(JSONString, Label.IAM_Reclaim_Flow + '-' + Label.IAM_Identity_LDAP, 'LDAP Create User API - ' + res.getBody(), IAM_Reclaim_Queable_API_Class.class.getName());
            }
        }
    }
   
    /* Call LDAP API - To add User in LDAP Application Group */
    public static void reclaim_GroupMapping_API(Id conId, Map<String,Boolean> reclaimTracker) {

        CSS_Integration_Details__c iamLDAPgroup = IAM_getConnnectionDetails.getConnection(
        'IAM_LDAP_Group_Addition_Mule');
        Map<String,IAM_Application_Groups__c> appGroupMap = new Map<String,IAM_Application_Groups__c>();
        /* getting all the groups frpm Application Group custom settings */
        List<IAM_Application_Groups__c> appGroupList = IAM_Application_Groups__c.getall().values();
        for(IAM_Application_Groups__c appGrp : appGroupList){
            appGroupMap.put(appGrp.IAM_DN_value__c.toUpperCase(), appGrp);
        }        
        String JSON_String = '';
        String errorDescription='';
        String accessToken='';
        if(!Test.isRunningTest()) {
            /* Get Mule Access Token */
            accessToken = IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_Mule_oAuth');
        } else {
            accessToken = 'lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz';
        }
     
        List<Contact> conList = getContactList(conId);           
        UserPayload uinfo = new UserPayload(conList, appGroupMap);
        if(uinfo != null){
            JSON_String = JSON.serialize(uinfo);
            System.debug('Printing serialized string sumit' + JSON_String);
        }
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type','application/json');
        headerMap.put('Authorization','Bearer '+accessToken);
        headerMap.put('resource',iamLDAPgroup.Resource__c);

        HttpResponse res;
        /* Get Response */
        if(!Test.isRunningTest()) {
            res = IAM_HTTP_Callout.sendHTTPRequest(iamLDAPgroup.Method_Type__c,
            iamLDAPgroup.End_Point__c, headerMap, JSON_String);
        } else {
            HttpResponse responseTest = new HttpResponse();
            responseTest.setStatusCode(200);
            responseTest.setBody(Label.IAM_LDAP_Success_Messgae);
            res = responseTest;
        }
        
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
                IAM_ErrorHandling.IAMerrorCapture(JSON_String, Label.IAM_Reclaim_Flow + '-' + Label.IAM_Identity_LDAP, 'LDAP Group API - ' + res.getBody(), IAM_Reclaim_Queable_API_Class.class.getName());
            }
        } else if(res != null && res.getStatusCode() != 200 ) {
            JSONParser parser = JSON.createParser(res.getBody());
            System.debug('response===='+res.getBody());
            while(parser.nextToken() != null) {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME 
                && parser.getText() == 'errorDescription') {
                    parser.nextToken();
                    errorDescription += parser.getText()+',\n';
                    System.debug('error Description==='+errorDescription);
                }                          
            }
            IAM_Reclaim_Utility.UpdateReclaimTracker(conList[0].Username__c,reclaimTracker);
            
            IAM_ErrorHandling.IAMerrorCapture(JSON_String, Label.IAM_Reclaim_Flow + '-' + Label.IAM_Identity_LDAP, 'LDAP Group API - ' + errorDescription + ' - ' + res.getBody(), IAM_Reclaim_Queable_API_Class.class.getName());
        }

        if(String.isBlank(errorDescription)){
            reclaimTracker.put('is_LDAP_Insert_Group_Addition_API',True);
            IAM_Reclaim_Utility.UpdateReclaimTracker(conList[0].Username__c,reclaimTracker);
        }
    }

    /* Request Wrapper List - LDAP Add User in Group API */
    public class UserPayload {
        public List<UserInfo> Userinfo{set;get;}
        public UserPayload(List<Contact> Con, Map<String,IAM_Application_Groups__c> appGrps) {
            Userinfo = new List<Userinfo>();
            Contact cn = Con[0];
            System.debug('Printing application Groups before call'+cn.IAM_Applications__c);
            /* In Reclaim mode we need to add is member of fields also in the payload. */
            String allAppGroups = '';
            if(String.isNotBlank(cn.IAM_Applications__c) && String.isNotBlank(cn.IAM_is_Member_of__c)) {
                allAppGroups = cn.IAM_Applications__c + '|' + cn.IAM_is_member_of__c;
            } else if(String.isNotBlank(cn.IAM_Applications__c)) {
                allAppGroups = cn.IAM_Applications__c;
            } else if(String.isNotBlank(cn.IAM_is_Member_of__c)) {
                allAppGroups = cn.IAM_is_Member_of__c;
            }            
            /* Splitting application groups */
            System.debug('Printing application groups'+allAppGroups);
            if(String.isNotBlank(allAppGroups)) {
                List<String> applicationGrp=allAppGroups.split('\\|');
                System.debug('Priting application groups'+applicationGrp);
                for(String sn : applicationGrp) {
                    this.Userinfo.add(new Userinfo(cn, sn, appGrps));
                }
            }
        }
    }

    /* Request Wrapper Object - LDAP Add User in Group API */
    public class Userinfo {
        public string uid {set;get;}
        public string applicationGroups {set;get;}
        public string grouptype {set;get;}
        public string workgroupId {set;get;}
        public string usertype {set;get;}
        public string branch {set;get;}        
        
        public Userinfo(Contact c, String sn, Map<String,IAM_Application_Groups__c> appMap) {
            System.debug('calling the userinfo');
            this.uid = c.username__c;
            this.usertype = Label.IAM_Value_External;
            this.branch = Label.IAM_Value_External; 
            System.debug('Printing contact application Groups'+sn);
            this.applicationGroups = sn;
            if(String.isNotBlank(c.IAM_Work_Group_Id__c)) {
                this.workgroupId = c.IAM_Work_Group_Id__c;
            } else {
                this.workgroupId = '';
            }
            if(!appMap.isEmpty() && appMap.ContainsKey(sn.ToUpperCase())) {  
                String groupTypeStr = appMap.get(sn.ToUpperCase()).IAM_Group_Type__c;            
                this.grouptype = groupTypeStr.toLowerCase();           
            }   
        }
    }

    /* Return list of Contacts */
    public static List<Contact> getContactList(Id contactId) {
        return [
            SELECT Id
                 , Username__c
                 , IAM_Applications__c
                 , IAM_Work_Group_Id__c
                 , IAM_Contact_Status__c
                 , IAM_Internal__c
                 , IAM_Legacy_User__c
                 , IAM_is_Member_of__c
              FROM Contact
             WHERE Id = :contactId
        ]; 
    }
}