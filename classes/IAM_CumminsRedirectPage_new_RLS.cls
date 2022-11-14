public class IAM_CumminsRedirectPage_new_RLS{ 
public user u{set;get;}
public String en{get;set;}
public String  resourceurl{get;set;}
public String  r{get;set;}
Public Map<String,String> pageParams{get;set;}
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
        String leftPart = lp.substringAfter('//');
        system.debug(leftPart);
        r = leftPart.substringBefore('/');
        String s1='%'+r+'%';
        if(s1!=null){
        List<App_Mapping__c> app = [select AppId__c,Name,CMI_Internal_URL__c,IAM_Request_Access_URL__c,IAM_OAM_Resource_URL_Redirection__c,IAM_App_Protected_By__c,IAM_OAM_Resource_URL__c,Internal_Employee_link__c,Internal_Redirect_URL2__c,Registration__c,forgot_password__c,internal_Employee_Redirection__c,IAM_Different_Request_Access_URL__c,Registration_Link__c,Back_page__c,contact_email__c,Footer_text__c from App_Mapping__c where IAM_OAM_Resource_URL__c Like:s1];
        system.debug(app);
        if(!app.isEmpty()){
        resourceurl=app[0].IAM_OAM_Resource_URL__c;
        }
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
        
    User currentloginUser = [Select id,Name,Contactid,Profile.Name,FederationIdentifier from user where id=:userinfo.getuserid()];
    //depending upon the Logged in user profile need to make changes to the below quieres.
    
    
    if(currentloginUser.Profile.Name!=System.Label.IAM_PWC_Profile_Name){
    //below code part should execute for only Community user profiles.  
    Contact con = [select id,IAM_Internal__c,IAM_Site_Admin__c,CMI_Contact_Type__c,Accountid from Contact where id=:currentloginUser.Contactid];   
    List<IAM_Contact_Provisioning__c> lstContactApps = [select id,IAM_Account_Application__c,IAM_Application_Name__c,IAM_Contact__c,IAM_Role__c,IAM_Status__c,IAM_User__c from IAM_Contact_Provisioning__c
                       where IAM_Contact__r.id =:con.id and IAM_Application_Name__c =:a[0].Name and IAM_Status__c='Active']; 
     system.debug('entering checks for auth'); 
     System.debug('Printing application'+a[0].CMI_External_Start_Url__c); 
    
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
            }
            else{
                pageRef =new pageReference(a[0].CMI_External_Start_Url__c);
                pageRef.setRedirect(true);
                pageRef.getParameters().put('lang',getLanguage());
                system.debug('=====Inside else part=====');
                if(a[0].Name=='DBU EFSR'||a[0].Name=='DBU-EFSR'){
                        
                       pageRef.getParameters().put('RelayState',IAM_Relay_Values.GetValueFromParam('finalRelayState'));
                      
                }
                System.debug('Printing final url'+pageRef);
                return pageRef;
            }
        }
        
        }
    //No Autorization for RLS
    /*  
    if(!lstContactApps.isEmpty()){  
    System.debug('Printing RElay state Value'+IAM_Relay_Values.GetValueFromParam('finalRelayState'));
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
                }
            }
            return pageRef;
        }
    } 
     
     }
    } */
    //Commenting above part because no authorization will be present 
    
     //If there are no applicatoins  in contact provisioning table setting redirect flag to true.
     setRedirect=True;
     if(setRedirect==true&&a[0].IAM_Request_Access__c==false){
         pageRef = Page.IAM_No_Authorization;
        pageRef.setRedirect(true);
          
          pageRef.getParameters().put('appid',a[0].id);
          pageRef.getParameters().put('lang',getLanguage());
          return pageRef;
    }   
     
    }else{
        
        List<App_Mapping__c> app=[select id,CMI_External_Start_Url__c from App_Mapping__c where id=:system.Label.IAM_Default_Appmap];
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

}