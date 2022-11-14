/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CMI_SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}

    global PageReference forwardToCustomAuthPage() {
    Id Accid;
    System.debug('Please show debug<>>>>>'+username);
    if(username!=null&&username!=''){
    System.debug('Inside loop<>>>>>'+username);
     //User s=[SELECT ContactId, AccountId FROM User WHERE Username =: username ];
     //User s=[SELECT ContactId, AccountId FROM User WHERE contact.Username__c =:username];
     Contact s= [SELECT Id, AccountId FROM Contact WHERE contact.Username__c =:username];
     Accid=s.AccountId;
     }
     //system.debug('page submit '+Accid);
     system.debug('account id===='+Accid);
        //String startUrl = System.currentPageReference().getParameters().get('Aid');
        //String startUrl = 'https://www.google.com';
        pageReference invite=Site.login(username, password,'/CMI_userreg?aid='+Accid);
        system.debug('came to page'+invite);
       // invite.getParameters().put('aid','0014B00000AbESg');
        return invite;
        
    }
    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, startUrl);
    }
    
   
    
}