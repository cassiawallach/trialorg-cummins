/************************************************************
Name:  IAM_RC_UserGroupMapping_GM
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Apex class for IAM Project to Add users from LDAP groups for Guidanz Mobile                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Keerthy Gurumurthy        11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     12/09/2020     Adding changes for the Mule Conversions      
*****************************************************/
/********************************************************************************
***********************************************************************************/
public  class IAM_RC_UserGroupMapping_GM{
    
    public Static String URL = system.label.IAM_LDAP+'/ldaputil/usergroupmapping';
   
    @future(callout=true)
    public static void basicAuthCallout_GM(Set<Id> cpId,String BranchName,String UserType,Boolean forExtBrach,Boolean forOtherBranch){
        String JSON_String = '';
        String errorDescription='';
        String accessToken;
        HttpResponse res;
        //String accessToken=IAM_OAG_LDAP_Authentication.getToken();//Access token from IAM authentication class.
        CSS_Integration_Details__c iamLDAPgroup = IAM_getConnnectionDetails.getConnection('IAM_LDAP_Group_Addition_Mule');
        if(!Test.isRunningTest()){
            //accessToken=IAM_OAG_getoAuthToken.getAccessToken('IAM_LDAP_oAuth');
            accessToken=IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_Mule_oAuth');
        }
        //String accessToken=IAM_OAG_getoAuthToken.getAccessToken('IAM_LDAP_oAuth');
    
        List<IAM_Contact_Provisioning__c> contactProvisioningList = [SELECT IAM_Contact__r.Username__c,IAM_Contact__r.IAM_Ext_Legacy_Uid__c,IAM_Contact__r.IAM_Contact_Status__c,IAM_Contact__r.IAM_Internal__c,IAM_Contact__r.IAM_Legacy_User__c, IAM_Contact__r.IAM_Applications__c,IAM_Contact__r.IAM_Work_Group_Id__c,IAM_Application_Name__c, IAM_Role__c 
                                                                     FROM IAM_Contact_Provisioning__c 
                                                                     WHERE id IN :cpId ORDER BY IAM_Contact__r.Username__c]; 
        System.debug('Print:: '+contactProvisioningList);   
        UserPayload uinfo = new UserPayload(contactProvisioningList,BranchName,UserType,forExtBrach,forOtherBranch);
        System.debug('Printing request wrapper :: '+ uinfo);
        if(uinfo!=null){
            JSON_String = JSON.serialize(uinfo);
            System.debug('Printing serialized string sumit'+JSON_String);
        }
        
        
         try{
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(iamLDAPgroup.End_Point__c);
            req.setMethod(iamLDAPgroup.Method_Type__c);
            req.setHeader('Content-Type','application/json');
            req.setBody(JSON_String);
            System.debug(req.getBody());
            req.setHeader('Authorization','Bearer '+accessToken);
            System.debug(req.getEndpoint()); 
            req.setHeader('resourse',iamLDAPgroup.Resource__c);
            
            Http http = new Http();
            if(!Test.isRunningTest()){
                res = http.send(req);
            }else{
                HttpResponse testResponse= new HttpResponse();
                testResponse.setStatusCode(200);
                testResponse.setBody('[{"uid":"ldaptestuser@gmail.com.iamosmdev","status":"User has been successfully removed from LDAP group.","reason":""}]');
                 res=testResponse;   
           
            }
            
              System.debug('response===='+res.getBody());
                System.debug('response===='+res.getStatusCode());
              if(res.getStatusCode() == 200){
                        String response = res.getBody();
                        boolean errorInResopnse=false;
                        List<String> msgList = system.label.IAM_LDAP_Messages.split(',');
                        List<IAM_LDAP_Util_Wrapper> ldapResponse = (List<IAM_LDAP_Util_Wrapper>)System.JSON.deserialize(response, List<IAM_LDAP_Util_Wrapper>.class);
                        system.debug('ldapResponse@@'+ldapResponse); 
                        for(IAM_LDAP_Util_Wrapper objwrapper:ldapResponse){
                            if(!msgList.contains(objwrapper.status)){
                                errorInResopnse= true;
                            }
                        }
                        if(errorInResopnse){
                            IAM_ErrorHandling.IAMerrorCapture(JSON_String+errorDescription,'IDENTITY-LDAP', res.getBody());
                        }
                    }
             else if(res!=null && res.getStatusCode() != 200 ){
                JSONParser parser = JSON.createParser(res.getBody());
                System.debug('response===='+res.getBody());
                while(parser.nextToken() != null){
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'errorDescription')
                    {
                        parser.nextToken();
                        errorDescription += parser.getText()+',\n';
                        System.debug('error Description==='+errorDescription);
                    }                          
                }
                
                //   cmiError(res.getStatus(),'LDAP',JSON_String + errorDescription); 
            }
        } catch(exception e){
            //cmiError(e.getMessage(),'LDAP',JSONString);
            System.debug('ERROR Message:-->:'+ e);
            System.debug('Stack Trace String'+e.getStackTraceString());
            //  return e.getMessage();
        }
    }
    
    
    
    
    public class UserPayload{
        public List<UserApp> Userinfo{set;get;}
            public UserPayload(List<IAM_Contact_Provisioning__c> contProvisioninglst,String BranchName,String UserType,Boolean forExtBrach,Boolean forOtherBranch){
            String dc1='cummins';
            String dc2='com';
            List<IAM_Application_Groups__c> iamAppGroup = IAM_Application_Groups__c.getall().values();
            Map<String,IAM_Application_Groups__c> mapIamAppGrp = new Map<String,IAM_Application_Groups__c>();
            for(IAM_Application_Groups__c iamAppGrp : iamAppGroup){
                if(!mapIamAppGrp.containsKey(iamAppGrp.IAM_DN_value__c))
                        mapIamAppGrp.put(iamAppGrp.IAM_Application_Name__c+iamAppGrp.IAM_Role_Name__c, iamAppGrp);
            }
            System.debug('mapIamAppGrp....  '+  mapIamAppGrp);
            Userinfo = new List<UserApp>();
            UserApp uinfo = new UserApp();
            Set<String> setRole = new Set<String>();
            Map<String,Set<String>> mapRole = new Map<String,Set<String>> ();
            for(IAM_Contact_Provisioning__c icp: contProvisioninglst){
                
                List<String> lstDelmitedStr = new List<String> ();
                if(!String.isBlank(icp.IAM_Role__c)){
                lstDelmitedStr = icp.IAM_Role__c.split(';');
                }
                
                
                System.debug('Printing values in the delimited List'+lstDelmitedStr);
                
                setRole.addAll(lstDelmitedStr);
                if(!mapRole.containsKey(icp.IAM_Application_Name__c))
                    mapRole.put(icp.IAM_Application_Name__c,setRole);
                System.debug('mapRole....  '+  mapRole);
                if(uinfo.uid != icp.IAM_Contact__r.Username__c){    
                    System.debug('uinfo.uid is :::' + uinfo.uid);
                    if(uinfo.uid !=null && uinfo.uid != ''){
                        Userinfo.add(uinfo);
                        uinfo = new UserApp();
                    }
                    if(forExtBrach){
                        uinfo.uid = icp.IAM_Contact__r.Username__c;
                    }
                    if(forOtherBranch){
                        uinfo.uid = icp.IAM_Contact__r.IAM_Ext_Legacy_Uid__c;
                    }
                    uinfo.usertype=UserType;
                    uinfo.branch=BranchName;
                     
                   
                    if(String.isNotBlank(icp.IAM_Contact__r.IAM_Work_Group_Id__c))
                        uinfo.workgroupId = icp.IAM_Contact__r.IAM_Work_Group_Id__c;
                    else
                        uinfo.workgroupId = '';
                    for(String strRole : mapRole.get(icp.IAM_Application_Name__c)){
                        if(mapIamAppGrp.containsKey(icp.IAM_Application_Name__c+strRole)){
                            //System.debug('uinfo.applicationGroups begin:::' + uinfo.applicationGroups);
                            //System.debug('uinfo.applicationGroups :::' + mapIamAppGrp.get(icp.IAM_Application_Name__c+strRole).IAM_DN_value__c);
                            uinfo.grouptype = mapIamAppGrp.get(icp.IAM_Application_Name__c+strRole).IAM_Group_Type__c;
                            if(uinfo.applicationGroups == null){
                                uinfo.applicationGroups = mapIamAppGrp.get(icp.IAM_Application_Name__c+strRole).IAM_DN_value__c;
                                //System.debug('uinfo.applicationGroups if:::' + uinfo.applicationGroups);
                            }else{
                                uinfo.applicationGroups = uinfo.applicationGroups +'||'+mapIamAppGrp.get(icp.IAM_Application_Name__c+strRole).IAM_DN_value__c;
                                //System.debug('uinfo.applicationGroups else:::' + uinfo.applicationGroups);
                            }   
                        } 
                        //System.debug('uinfo.applicationGroups 1111:::' + uinfo.applicationGroups);
                    }
                }else{
                     for(String strRole : mapRole.get(icp.IAM_Application_Name__c)){
                        if(mapIamAppGrp.containsKey(icp.IAM_Application_Name__c+strRole)){
                            uinfo.applicationGroups = uinfo.applicationGroups +'||'+mapIamAppGrp.get(icp.IAM_Application_Name__c+strRole).IAM_DN_value__c;
                        }     
                     }
                }
            }

            if(uinfo != null){
                if(uinfo.uid !=null && uinfo.uid != ''){
                    Userinfo.add(uinfo);
                    uinfo = new UserApp();
                }
            }
        }      
    }
    
    public class UserApp{
        public string uid;
        public string applicationGroups;
        public string grouptype;
        public string workgroupId;
        public string branch;
        public string usertype;
    }
    
}