/************************************************************
Name:  IAM_RequestAccessController
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
To identify the application name from the url and redirect user to the respective idp initiated flow.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Keerthy Gurumurthy     23/04/2018       INITIAL DEVELOPMENT  
1.1 -    Karthik Golakaram      9/28/2020       Removed PWC User extra Validation
1.2 -    Karthik Golakaram      10/16/2020      Added UID in the URL Request access
*****************************************************/
/********************************************************************************
***********************************************************************************/
public class IAM_CumminsRedirectPage_new{ 
    public user u{set;get;}
    public String en{get;set;}
    public String  resourceurl{get;set;}
    public String  r{get;set;}
    Public Map<String,String> pageParams{get;set;}
    public String Skuid{get;set;}
    public String Skuurl{get;set;}
    public String Skuurl_new{get;set;}
    Public String exact_resourceURL{get;set;}
    public PageReference Redirect(){
        
        pageParams= ApexPages.CurrentPage().getparameters();
        System.debug('Printing page Parameters'+pageParams);
        
        user u=[select id,name,ProfileId,username,Profile.Name from user where user.Id=:userinfo.getUserId()];
        PageReference pageRef;
        List<App_Mapping__c> a = new List<App_Mapping__c>();
        Boolean setRedirect=false;//Redirect variable to send to request access page     
        String appId = apexpages.currentpage().getparameters().get('appid');
        String en= apexpages.currentpage().getparameters().get('resource_url');
        
        System.debug('Printing en String value'+en);
        System.debug('Printing app id '+appId);
        if(en!=null){
            String lp= EncodingUtil.urlDecode(en,'UTF-8');
            system.debug('lp'+lp);
            exact_resourceURL=lp;
            String leftPart = lp.substringAfter('//');
            system.debug(leftPart);
            r = leftPart.substringBefore('/');
            String s1='%'+r+'%';
            if(s1!=null){
                List<App_Mapping__c> app = [select AppId__c,Name,CMI_Internal_URL__c,IAM_Request_Access_URL__c,IAM_OAM_Resource_URL_Redirection__c,IAM_App_Protected_By__c,IAM_OAM_Resource_URL__c,Internal_Employee_link__c,Internal_Redirect_URL2__c,Registration__c,forgot_password__c,internal_Employee_Redirection__c,IAM_Different_Request_Access_URL__c,Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where IAM_OAM_Resource_URL__c Like:s1];
                system.debug(app);
                resourceurl=app[0].IAM_OAM_Resource_URL__c;
                system.debug(resourceurl);
            }
        }
        
        //Commenting below lines for QSOL PWC account testing
        if(!String.isEmpty(appid) || !String.isEmpty(resourceurl) ){
            
            System.debug('Printing appid is not empty'+appid);
            //List<App_Mapping__c>a=[select id,CMI_External_Start_Url__c from App_Mapping__c where id=:appid];
            if(appid!=null)
            {
                a = [select AppId__c,IAM_Authroization_Required__c,Name,Login_Url__c,CMI_Internal_URL__c,IAM_Request_Access_URL__c,Internal_Employee_link__c,Internal_Redirect_URL2__c,Registration__c,forgot_password__c,internal_Employee_Redirection__c,IAM_Request_Access__c, 
                     Registration_Link__c,CMI_External_Start_Url__c,IAM_Different_Request_Access_URL__c,IAM_OAM_Resource_URL_Redirection__c,IAM_Paid_Subscription__c from App_Mapping__c where id=: appid];
                System.debug('appid is  in the page==='+appid);
            }
            else if(resourceurl!=null)
            {
                system.debug('entered resource url check');
                a = [select AppId__c,Name,CMI_Internal_URL__c,IAM_Different_Request_Access_URL__c,IAM_Request_Access_URL__c,IAM_OAM_Resource_URL_Redirection__c,CMI_External_Start_Url__c,IAM_Authroization_Required__c,IAM_OAM_Resource_URL__c,Internal_Employee_link__c,Internal_Redirect_URL2__c,Registration__c,forgot_password__c,internal_Employee_Redirection__c,IAM_Request_Access__c,Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where IAM_OAM_Resource_URL__c=: resourceurl];
                system.debug('Id'+a);
            }
            
            User currentloginUser = [Select id,Name,Contactid,Profile.Name,FederationIdentifier,IAM_Lightning_Redirection_Required__c,Username from user where id=:userinfo.getuserid()];
            //depending upon the Logged in user profile need to make changes to the below quieres.
            
            
            if(currentloginUser.Profile.Name!=System.Label.IAM_PWC_Profile_Name&&currentloginUser.Contactid!=null){
                //below code part should execute for only Community user profiles.  
                Contact con = [select id,IAM_Internal__c,IAM_Site_Admin__c,CMI_Contact_Type__c,Accountid from Contact where id=:currentloginUser.Contactid];   
                List<IAM_Contact_Provisioning__c> lstContactApps = [select id,IAM_Account_Application__c,IAM_Application_Name__c,IAM_Contact__c,IAM_Role__c,IAM_Status__c,IAM_User__c from IAM_Contact_Provisioning__c
                                                                    where IAM_Contact__r.id =:con.id and IAM_Application_Name__c =:a[0].Name and IAM_Status__c='Active']; 
                system.debug('entering checks for auth'); 
                System.debug('Printing application'+a[0].CMI_External_Start_Url__c); 
                
                
                //Non OSM application.  
                if(a[0].CMI_External_Start_Url__c != null && a[0].IAM_Authroization_Required__c==false)
                {
                    system.debug('External url'+a[0].CMI_External_Start_Url__c);
                    //Amarnath Mishra changes 03/03/2019 issue
                    
                    System.debug('===Contact type==='+con.CMI_Contact_Type__c); 
                    System.debug('===Application name===='+a[0].Name);
                    if((con.IAM_Site_Admin__c == false) && (a[0].Name == 'Identity and Access Management'  &&  con.CMI_Contact_Type__c != 'Primary'))
                    {
                        //Redirect user to the no Authorization page.
                        pageRef =new pageReference('/apex/IAM_No_Authorization');
                        pageRef.setRedirect(true);
                        pageRef.getParameters().put('lang',getLanguage());
                        system.debug('=====Inside if part=====');
                        return pageRef;
                    } else if(lstContactApps.isEmpty() && a[0].IAM_Request_Access__c==true) {                        
                        if(a[0].IAM_Different_Request_Access_URL__c){
                            pageRef= new PageReference(a[0].IAM_Request_Access_URL__c);
                        }else{      
                            pageRef = Page.IAM_Request_Access;
                        }
                        pageRef.setRedirect(true);
                        pageRef.getParameters().put('appid',a[0].id);
                        pageRef.getParameters().put('lang',getLanguage());
                        pageRef.getParameters().put('uid',currentloginUser.Username);
                        return pageRef;
                    } else {
                        pageRef =new pageReference(a[0].CMI_External_Start_Url__c);
                        pageRef.setRedirect(true);
                        pageRef.getParameters().put('lang',getLanguage());
                        system.debug('=====Inside else part=====');
                        if(!String.isBlank(IAM_Relay_Values.GetValueFromParam('RelayState'))){
                            pageRef.getParameters().put('RelayState',IAM_Relay_Values.GetValueFromParam('RelayState'));   
                        }
                        if(a[0].Name=='DBU EFSR'||a[0].Name=='DBU-EFSR'){
                            //pageRef.getParameters().put('RelayState','/services/oauth2/authorize');
                            //pageRef.getParameters().put('RelayState','/setup/secur/RemoteAccessAuthorizationPage.apexp');
                            pageRef.getParameters().put('RelayState',IAM_Relay_Values.GetValueFromParam('finalRelayState'));
                            //pageRef.getParameters().put('display',IAM_Relay_Values.GetValueFromParam('display'));
                            //pageRef.getParameters().put('source',IAM_Relay_Values.GetValueFromParam('source'));
                            //pageRef.getParameters().put('SAMLRequest',IAM_Relay_Values.GetValueFromParam('SAMLRequest'));
                            
                            //pageRef.getParameters().put('SigAlg',IAM_Relay_Values.GetValueFromParam('SigAlg'));
                            
                            //pageRef.getParameters().put('Signature',IAM_Relay_Values.GetValueFromParam('Signature'));
                            
                            //pageRef.getParameters().put('appid',IAM_Relay_Values.GetValueFromParam('appid'));
                            
                        }
                        System.debug('Printing final url'+pageRef);
                        return pageRef;
                    }
                }
                
                if(!lstContactApps.isEmpty()){  
                    System.debug('Printing RElay state Value'+IAM_Relay_Values.GetValueFromParam('finalRelayState'));
                    System.debug('Printing Exact Resource URL'+exact_resourceURL);
                    for(IAM_Contact_Provisioning__c ConApp :lstContactApps) {
                        if(conApp.IAM_Application_Name__c == a[0].Name && a[0].IAM_Authroization_Required__c==true) {
                            
                            if(a[0].CMI_External_Start_Url__c != null)
                            {
                                system.debug('External url'+a[0].CMI_External_Start_Url__c);
                                pageRef =new pageReference(a[0].CMI_External_Start_Url__c);
                                pageRef.setRedirect(true);
                                pageRef.getParameters().put('lang',getLanguage());
                                if(a[0].IAM_OAM_Resource_URL_Redirection__c){
                                    
                                   if(!String.isEmpty(IAM_Relay_Values.GetValueFromParam('finalRelayState'))){
                                        pageRef.getParameters().put('RelayState',IAM_Relay_Values.GetValueFromParam('finalRelayState'));
                                    }else if(!String.isEmpty(en)){
                                        pageRef.getParameters().put('RelayState',exact_resourceURL);
                                    }
                                }
                                System.debug('Printing PAge reference'+pageRef);
                                return pageRef;
                            }
                        } 
                        
                    }
                } 
                
                //closing here for seperating it from OSM
                
                //If there are no applicatoins  in contact provisioning table setting redirect flag to true.
                setRedirect=True;
                if(setRedirect==true&&a[0].IAM_Request_Access__c==true){
                    if(a[0].IAM_Different_Request_Access_URL__c){
                        pageRef= new PageReference(a[0].IAM_Request_Access_URL__c);
                    }else{      
                        pageRef = Page.IAM_Request_Access;
                    }
                    pageRef.setRedirect(true);
                    /*if(appid!=null)
pageRef.getParameters().put('appid',a[0].id);
else if(resourceurl!=null)
pageRef.getParameters().put('resourceurl',a[0].id);*/
                    pageRef.getParameters().put('appid',a[0].id);
                    pageRef.getParameters().put('lang',getLanguage());
                    pageRef.getParameters().put('uid',currentloginUser.Username);
                    return pageRef;
                }else if(setRedirect==true&&a[0].IAM_Request_Access__c==false){
                    pageRef = Page.IAM_No_Authorization;
                    pageRef.setRedirect(true);
                    
                    pageRef.getParameters().put('appid',a[0].id);
                    pageRef.getParameters().put('lang',getLanguage());
                    return pageRef;
                }
            }else if(currentloginUser.Profile.Name!=System.Label.IAM_PWC_Profile_Name){
                //for Internal users.
                if(a[0].Name=='Marketplace'){
                    system.debug('entering redirection for OSM');
                    Skuurl_new=ApexPages.CurrentPage().getparameters().get('returl');
                    Map<String,String> paramMap  = ApexPages.CurrentPage().getparameters();
                    
                    for(String key : paramMap.keyset()){
                        String paramVal = paramMap.get(key);
                        System.debug('===key=='+key);
                        System.debug('===paramVal=='+paramVal);
                        if(key=='returl')
                            continue;
                        if(key=='sku'){ 
                            skuid = paramVal;
                        }
                        else{
                            Skuurl = Skuurl + '&' + key + '=' + paramVal;
                        } 
                    }
                    System.debug('===Skuurl_new=='+Skuurl_new);
                    System.debug('===Params got from OSM=='+skuurl);
                    System.debug('skuid  in the page==='+skuid);
                    System.debug('skuurl is  in the page==='+skuurl);
                    String s;
                    if(skuurl!=null){
                        System.debug('skuurl'+ skuurl);
                        if(skuid!=null){
                            s=getSegmentSku(skuid);
                            System.debug('new skuid'+s);
                            String finalUrl =Skuurl_new +  skuurl + '&sku='+s;
                            pageRef =new pageReference(finalUrl );
                        }
                        else{
                            if(Skuurl_new.indexOf('?')==-1){
                                Skuurl_new = Skuurl_new + '?';
                            }
                            String finalUrl =Skuurl_new +  skuurl;
                            
                            pageRef =new pageReference(finalUrl);
                        }
                    }
                    else{
                        System.debug('redirecting based on the appid');
                        pageRef =new pageReference(Skuurl_new);
                    }    
                }else {
                    //for rest of applications
                    pageRef=new PageReference(a[0].CMI_External_Start_Url__c);
                    pageRef.setRedirect(true);
                    return pageRef;
                }   
            }else if(currentloginUser.Profile.Name==System.Label.IAM_PWC_Profile_Name){
                
                //Removing the extra validation because of the parts application and also PWC accounts are not associated to Contacts.
                //and mainly their access depends upon the application groups and the permission sets on user record.
               /* Set<String> appNames=new set<String>();
                List<Contact> Con=[Select id,Name,Email,Username__c from Contact where Username__c=:currentloginUser.FederationIdentifier];
                if(!Con.isEmpty()){
                    List<IAM_Contact_Provisioning__c> conProv=[Select id,IAM_Application_Name__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:con[0].id];
                    if(!conProv.isEmpty()){
                        for(IAM_Contact_Provisioning__c c:conProv){
                            appNames.add(c.IAM_Application_Name__c);
                        }
                        System.debug('Printing application Names'+appNames);
                        System.debug('Printing name form app Mapping');
                        if(appNames.contains(a[0].Name)){
                            //Now set page reference to respective application URL. Since these will come from f5 url hope there will be no extra attributes.
                            //for this login to work there should be local storage set for iamdev community url while logging through PWC login page.
                            pageRef=new PageReference(a[0].CMI_External_Start_Url__c);
                            pageRef.setRedirect(true);
                            return pageRef;
                        }else{
                            System.debug('PRinting No application Access');
                            pageRef= new PageReference('/IAM_No_Authorization?appid='+a[0].id);
                            pageRef.setRedirect(true);
                            return pageRef;
                        }
                    }
                    
                }else{
                    System.debug('Priting no application Acces line 124');
                    pageRef= new PageReference('/IAM_No_Authorization?appid='+a[0].id);
                    pageRef.setRedirect(true);
                    return pageRef;
                }*/


                pageRef=new PageReference(a[0].CMI_External_Start_Url__c);
                pageRef.setRedirect(true);
                return pageRef;
            }else if(a[0].Name=='Identity and Access Management'&&currentloginUser.IAM_Lightning_Redirection_Required__c==true){
                //redirect them to the lightning portal
                System.debug('PRinting No application Access');
                pageRef= new PageReference(System.Label.IAM_Lightning_Redirection);
                pageRef.setRedirect(true);
                return pageRef;
                
            }   
            else{
                //Changes for Parts.Cummins.com - Cumpas 2.0 Integration (passing additional parameters sent from parts cummins to cumpas cummins)
		      Map<String,String> paramMaps  = ApexPages.CurrentPage().getparameters();
                        String relayStat;
                    	for(String key : paramMaps.keyset()){
                        	String paramVal = paramMaps.get(key);
                        	System.debug('===key=='+key);
                        	System.debug('===paramVal=='+paramVal);
                        	if(key=='returl')
                            	 continue;
                        	else{
                            	 relayStat= relayStat + '&' + key + '=' + paramVal;
                        	} 
                    	}
            }     
            
        }else{
            
            List<App_Mapping__c> app;
            if(!Test.isRunningTest()){
            	app=[select id,CMI_External_Start_Url__c from App_Mapping__c where id=:system.Label.IAM_Default_Appmap];
            } else {
                app=[select id,CMI_External_Start_Url__c from App_Mapping__c];
            }
            system.debug('External url'+app[0].CMI_External_Start_Url__c);
            pageRef =new pageReference(app[0].CMI_External_Start_Url__c+'?appid='+system.Label.IAM_Default_Appmap);
            pageRef.setRedirect(true);
            pageRef.getParameters().put('lang',getLanguage());
            return pageRef;
        }
        //pageRef.setRedirect(true);
        //return pageRef;
        return null;
    }
    
    public String getLanguage(){
        String langValue = ApexPages.currentPage().getParameters().get('lang');
        System.debug('langValue.....  '+langValue);
        return langValue;
    }
    
    public static String getSegmentSku(String sku){
        system.debug('entering segment meth'+sku);
        List<User> us = [Select Id,contactid,contact.Accountid, contact.Account.OSM_Market_Segment_Code__c from User where Id =: UserInfo.getUserId()];
        if(us.size()>0){
            System.debug('======User Data 1==='+us[0].contactid);
            System.debug('======User Data 3==='+us[0].contact.Accountid);
            System.debug('======User Data 2==='+us[0].contact.Account.OSM_Market_Segment_Code__c);
            sku = sku.substringBeforeLast('-');
            system.debug('new sku from method Before  --> '+sku);
            sku = us[0].contact.Account.OSM_Market_Segment_Code__c != null ? sku+'-'+us[0].contact.Account.OSM_Market_Segment_Code__c:'';
            system.debug('new sku from method 2 --> '+sku);
            return sku;
        }
        system.debug('new sku from method'+sku);
        return sku;
    }
    
}