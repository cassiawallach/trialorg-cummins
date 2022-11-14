public with sharing class EIDMCumminsRedirectPage_mobile {

    public PageReference Redirect(){
    
    user u=[select id,name,LocaleSidKey,LanguageLocaleKey,CMI_Calibration_Role__c,ProfileId from user where user.Id=:userinfo.getUserId()];
    id appid=apexpages.currentpage().getparameters().get('appid');
    //string currentlang=apexpages.currentpage().getparameters().get('language');
    string currentlang = ApexPages.CurrentPage().getparameters().get('language').left(5);
    string l=currentlang.left(2);
    system.debug('newcurrentlang:'+ l);
    PageReference pageRef;
    if(appid!=null){
     system.debug('appid:'+ appid);
     pageRef =new pageReference(system.label.CS_Mobile_URL);
     if(currentlang!=null)
              {
              if(l=='en')
              {
              u.LocaleSidKey='en_US';
              u.LanguageLocaleKey='en_US';
              }
              else if(l=='es')
              {
              u.LocaleSidKey=l;
              u.LanguageLocaleKey=l;
              }
              system.debug('newcurrentlang:'+ l);
             system.debug('currentlang:'+ currentlang); 
            
              update u;
             }
              else
              {
              u.LocaleSidKey='en_US';
              u.LanguageLocaleKey='en_US';
              system.debug('user details:'+u); 
              update u;
              }
            system.debug('currentlang for user:'+currentlang); 
       
   }
    pageRef.setRedirect(true);
    return pageRef;
    }


}