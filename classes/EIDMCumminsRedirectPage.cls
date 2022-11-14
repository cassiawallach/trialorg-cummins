public class EIDMCumminsRedirectPage{ 
//public user u{set;get;}
//public id appId{set;get;}

    public PageReference Redirect(){
    
    user u=[select id,name,ProfileId from user where user.Id=:userinfo.getUserId()];
   
    Id appId = apexpages.currentpage().getparameters().get('appid');
    System.debug('appid is  in the page==='+appid);
        
    PageReference pageRef;
    
    if((u.profileId==system.label.RLS_WEB_Profile_Id)||(u.profileId==system.label.EIDM_Community_RLS_ProfileId)){
     pageRef =new pageReference(system.label.RLS_Redirect_URL);
    }
    else if(system.Label.RLS_AppID==appId)
    {
        pageRef =new pageReference(system.label.RLS_Redirect_URL);
    }
   /* else if(u.profileId==system.label.CS_WEB_Profile_Id)
    {
        pageRef =new pageReference(system.label.CS_Version2_URL);
    }
   else if(u.profileId==system.label.CS_Cal_Profile_Id)
    {
        pageRef =new pageReference(system.label.CMI_Callib_Redirect_URL);
    }*/
    else if(u.profileId==system.label.ABO_Web_Profile_Id)
    {
        pageRef =new pageReference(system.label.ABO_Web_Redirect_URL);
    }
     else if(system.Label.ABO_appID==appId)
    {
        pageRef =new pageReference(system.label.ABO_Web_Redirect_URL);
    }
    else if(u.profileId==System.label.ABO_Profile_ID)
    {
        pageRef =new pageReference(system.label.ABO_Web_Redirect_URL);
    }
    pageRef.setRedirect(true);
    return pageRef;
    }

}