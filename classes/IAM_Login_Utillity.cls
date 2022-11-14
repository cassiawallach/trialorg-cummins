/************************************************************
Name:  IAM_Login_Utillity
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Controller class for Cummins_Login Visual force page.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION   AUTHOR                   DATE              DETAIL                                
1.0 -   Keerthy Gurumurthy      23/04/2018        INITIAL DEVELOPMENT  
1.1 -   Shubhangi Sardar        23/04/2019     Added code for guest user redirection
                                               to request access page.
1.2 -   Karthik Golakaram       10/23/2020    Added Variables for display purpose
                                              depending upon application name
1.3 -   Karthik Golakaram       03/21/2021    Made changes for Federation with Partner Companies
*****************************************************/
/********************************************************************************
***********************************************************************************/
global without Sharing  class IAM_Login_Utillity{

    //Method to get a app mapping when all page parameters are passed.
    Public Static App_Mapping__c getAppMapping(Map<String,String> paramValues){
        App_Mapping__c appMapping=new App_Mapping__c();
        List<App_Mapping__c> a=new List<App_Mapping__c>();
        String inbetweenId='';
        String enURL='';
        String currentRecordId='';
        String resourceurl='';
        String spInitiatedAppId='';
            
        try{    
             //Instance Specific code for capturing appid
            String applicationid=ApexPages.currentPage().getParameters().get('appid');
            System.debug('Printing application Id'+applicationId);
            //end of app specific code in constructor.
            
            string stURL=IAM_Relay_Values.GetValueFromParam('startURL');
            System.debug('Printing String start url'+stURL);
            
            if(!String.isEmpty(stURL)){
                System.debug('Printing app ID '+stURL.substringAfter('appid='));
                System.debug('Printing regular application in between name'+stURL.substringBetween('appid=','&bmctx'));
                
                if(!String.isEmpty(stURL.substringBetween('appid=','&bmctx'))){
                    inbetweenId=stURL.substringBetween('appid=','&bmctx'); 
                }else if(!String.isEmpty(stURL.substringAfter('appid='))){
                    inbetweenId=stURL.substringAfter('appid=').left(15);
                }           
                System.debug('Printing application inbetween String'+inbetweenId);
                //assigning resource url from decoded url
                enURL=stURL.substringAfterLast('resource_url=');
                
                System.debug('Printing application resurl'+enURL);
                System.debug('Printing String url in between for idp initiated flow'+stUrl.substringBetween('app=','&RelayState'));
                    
                if(!String.isEmpty(stUrl.substringBetween('app=','&RelayState'))){
                    String spURL=stUrl.substringBetween('app=','&RelayState');
                    System.debug('Printing application idp'+spURL);
                    spInitiatedAppId=spURL.right(15);
                    
                }  
                
                System.debug('PRinting ap Initited URL'+spInitiatedAppId); 
            }else if(!String.isEmpty(IAM_Relay_Values.GetValueFromParam('resource_url'))){
                //resource url will be fetched as page parameters 
                enURL=IAM_Relay_Values.GetValueFromParam('resource_url');
                System.debug('Printing resource URL to be reditected to in regular sso case'+enURL);
            }
                
                if(enURL!=null)
                {
                    String l= EncodingUtil.urlEncode(enURL,'UTF-8');
                    system.debug('l value---' + l);
                    
                    String lp2= EncodingUtil.urlDecode(l,'UTF-8');
                    system.debug('lp2 value---' + lp2);
                    
                    String lp1= EncodingUtil.urlDecode(lp2,'UTF-8');
                    system.debug('lp1 value---' + lp1);
                    
                    String lp= EncodingUtil.urlDecode(lp1,'UTF-8');
                    system.debug('lp value---' + lp);
                    
                    String leftPart = lp.substringAfter('//');
                    system.debug(leftPart);
                    String  r = leftPart.substringBefore('/');
                    System.debug('Printing r value='+r);
                    String s1='';
                    if(!String.isBlank(r)){
                    s1 = '%' + r + '%';
                    }
                    System.debug('Printing S1'+s1);
                    if (r!=''&&s1!=''&& s1!='%%' ) {
                        a = [select id,AppId__c,IAM_Logout_URL__c,IAM_RelayState__c,IAM_Default_Text__c,IAM_Is_Federated__c,IAM_Partner_SSO_Unique_Text__c,IAM_Default_Value__c,IAM_SSO_Configuration_ID__c,IAM_Community_Domain_For_IAM_APP__c,IAM_Request_Access_URL__c,IAM_Different_Request_Access_URL__c, Name,OTP_Required__c,CMI_External_Start_Url__c, CMI_Internal_URL__c, IAM_App_Protected_By__c, IAM_OAM_Resource_URL__c, Internal_Employee_link__c, Internal_Redirect_URL2__c, Registration__c, forgot_password__c, internal_Employee_Redirection__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where IAM_OAM_Resource_URL__c Like: s1];
                        system.debug(a);
                        resourceurl = a[0].IAM_OAM_Resource_URL__c;
                        system.debug(resourceurl);
                    }
                }
                
                //Code specific for SP initiated flow.
                if(!String.isEmpty(spInitiatedAppId)){
                     a = [select id,AppId__c,IAM_Logout_URL__c,IAM_RelayState__c,IAM_Default_Text__c,IAM_Is_Federated__c,IAM_Partner_SSO_Unique_Text__c,IAM_SSO_Configuration_ID__c,IAM_Community_Domain_For_IAM_APP__c,IAM_Default_Value__c,IAM_Request_Access_URL__c,IAM_Different_Request_Access_URL__c, Name,OTP_Required__c,CMI_External_Start_Url__c, CMI_Internal_URL__c, IAM_App_Protected_By__c, IAM_OAM_Resource_URL__c, Internal_Employee_link__c, Internal_Redirect_URL2__c, Registration__c, forgot_password__c, internal_Employee_Redirection__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where IAM_Connected_App_ID__c=:spInitiatedAppId];
                        system.debug('Line number 79'+a);
                    
                }
           
            if(!String.isEmpty(applicationId)){
                currentRecordId=applicationId;//These lines are written mainly for EIDMTST Instance specific 
            }else if(!string.isEmpty(inbetweenId)){
                currentRecordId =inbetweenId;
            } else if(!a.isEmpty()&&!String.isEmpty(spInitiatedAppId)){
                currentRecordId =a[0].id;
            }
                
            System.debug('Printing current record id'+currentRecordId);
            system.debug('Printing resource URL'+resourceurl);
                
            if (!String.isEmpty(resourceurl)) {
                appMapping = [select AppId__c, IAM_Default_Text__c,IAM_RelayState__c,IAM_Is_Federated__c,IAM_Partner_SSO_Unique_Text__c,IAM_SSO_Configuration_ID__c,IAM_Community_Domain_For_IAM_APP__c,IAM_Default_Value__c,Name,OTP_Required__c,IAM_Request_Access_URL__c,IAM_Different_Request_Access_URL__c,IAM_Authroization_Required__c,Internal_Redirect_URL__c,IAM_Request_Access__c,IAM_OAM_Resource_URL_Redirection__c,IAM_Logout_URL__c, CMI_Internal_URL__c,CMI_External_Start_Url__c, IAM_OAM_Resource_URL__c, Internal_Employee_link__c, Internal_Redirect_URL2__c, Registration__c, forgot_password__c, internal_Employee_Redirection__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where IAM_OAM_Resource_URL__c =: resourceurl];
                system.debug('Id' + appMapping);
            } else if (!String.isEmpty(currentRecordId)) {
                    appMapping = [select AppId__c, IAM_Default_Text__c,IAM_RelayState__c,IAM_Is_Federated__c,IAM_Partner_SSO_Unique_Text__c,IAM_SSO_Configuration_ID__c,IAM_Community_Domain_For_IAM_APP__c,IAM_Default_Value__c,Name,OTP_Required__c,IAM_Request_Access_URL__c,IAM_Different_Request_Access_URL__c,IAM_Authroization_Required__c,IAM_Request_Access__c,Internal_Redirect_URL__c,IAM_OAM_Resource_URL_Redirection__c,IAM_Logout_URL__c, CMI_Internal_URL__c,CMI_External_Start_Url__c, IAM_OAM_Resource_URL__c, Internal_Employee_link__c, Internal_Redirect_URL2__c, Registration__c, forgot_password__c, internal_Employee_Redirection__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where id =: currentRecordId];
                    system.debug('App Mapping' + appMapping);
            }else {
                //default case where we get the app mapping for default record value.
                appMapping = [select AppId__c, IAM_Default_Text__c,IAM_RelayState__c,IAM_Is_Federated__c,IAM_Partner_SSO_Unique_Text__c,IAM_SSO_Configuration_ID__c,IAM_Community_Domain_For_IAM_APP__c,IAM_Default_Value__c,Name,OTP_Required__c,IAM_Request_Access_URL__c,IAM_Different_Request_Access_URL__c,IAM_Logout_URL__c,IAM_Request_Access__c,IAM_Authroization_Required__c,Internal_Redirect_URL__c,IAM_OAM_Resource_URL_Redirection__c, CMI_Internal_URL__c,CMI_External_Start_Url__c, IAM_OAM_Resource_URL__c, Internal_Employee_link__c, Internal_Redirect_URL2__c, Registration__c, forgot_password__c, internal_Employee_Redirection__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where id =: System.Label.IAM_Default_Appmap];
                    system.debug('App Mapping' + appMapping);
            }
        }catch(exception ex){
                system.debug('Printing exception in app mapping fetching'+ex);
                system.debug('Printing exception in app mapp fecting lin wise'+ex.getStackTraceString());
        }
     //return the equivalent app mapping record   
    return appMapping;
}   
    
    //Method to get the resource URL
    Public Static String getResourceURL(Map<String,String> paramValues){
 
        App_Mapping__c appMapping=new App_Mapping__c();
        String inbetweenId='';
        String enURL='';
        String returnUrl='';
            
        try{    
             //Instance Specific code for capturing appid
            String applicationid=ApexPages.currentPage().getParameters().get('appid');
            System.debug('Printing application Id'+applicationId);
            //end of app specific code in constructor.
            
            string stURL=IAM_Relay_Values.GetValueFromParam('startURL');
            System.debug('Printing String start url'+stURL);
            if(!String.isEmpty(stURL)){
  
                System.debug('Printing app ID '+stURL.substringAfter('appid='));
                System.debug('Printing regular application in between name'+stURL.substringBetween('appid=','&bmctx'));
                
                if(!String.isEmpty(stURL.substringBetween('appid=','&bmctx'))){
                    inbetweenId=stURL.substringBetween('appid=','&bmctx'); 
                }else if(!String.isEmpty(stURL.substringAfter('appid='))){
                    inbetweenId=stURL.substringAfter('appid=');
                }           
                System.debug('Printing application inbetween String'+inbetweenId);
                
                enURL=stURL.substringAfterLast('resource_url=');
                
                System.debug('Printing application resurl'+enURL);      
            }else if(!String.isEmpty(IAM_Relay_Values.GetValueFromParam('resource_url'))){
                enURL=IAM_Relay_Values.GetValueFromParam('resource_url');
                System.debug('Printing resource URL to be reditected to in regular sso case'+enURL);
            }
            
            if(enURL!=null)
                {
                    String l= EncodingUtil.urlEncode(enURL,'UTF-8');
                    system.debug('l value---' + l);
                    
                    String lp2= EncodingUtil.urlDecode(l,'UTF-8');
                    system.debug('lp2 value---' + lp2);
                    
                    String lp1= EncodingUtil.urlDecode(lp2,'UTF-8');
                    system.debug('lp1 value---' + lp1);
                    
                    String lp= EncodingUtil.urlDecode(lp1,'UTF-8');
                    system.debug('lp value---' + lp);
                    returnUrl=lp;
                }
            System.debug('Printing return URL'+returnUrl);
        }catch(exception ex){
            System.debug('Printing exception ex'+ex);
           
        }
    //return the decoded resource url
    return  returnUrl;
    }
    
     Public Static String getOAMerrorcodes(Map<String,String> paramValues){  
      App_Mapping__c appMapping=new App_Mapping__c();
        String inbetweenId='';
        String errorcode='';
        String returnUrl='';
            
        try{    
            
            string stURL=IAM_Relay_Values.GetValueFromParam('startURL');
            System.debug('Printing String start url'+stURL);
            if(!String.isEmpty(stURL)){
  
                String l= EncodingUtil.urlEncode(stURL,'UTF-8');
                    system.debug('l value---' + l);
                    
                    String lp2= EncodingUtil.urlDecode(l,'UTF-8');
                    system.debug('lp2 value---' + lp2);
                    
                    String lp= EncodingUtil.urlDecode(lp2,'UTF-8');
                    system.debug('lp value---' + lp);
                    //returnUrl=lp;
                    
                    errorcode=lp.substringBetween('p_error_codes_list=','&locale');
                    returnUrl=errorcode;
                }
            System.debug('Printing return URL'+returnUrl);
        }catch(exception ex){
            System.debug('Printing exception ex'+ex);
        }
    //return the decoded resource url
    return  returnUrl;
     }     
}