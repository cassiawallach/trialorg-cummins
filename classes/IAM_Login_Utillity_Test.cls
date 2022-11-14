@isTest
public class IAM_Login_Utillity_Test{

  @Istest
    static void test1()
    {      
App_Mapping__c app=new App_Mapping__c();
        app.name='Market Place';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_App_Protected_By__c = 'SM';
        app.IAM_Default_Role__c = 'OSM Fleet Admin';
        insert app;             
   
        Map<String,String> ss=new Map<String,String>();
        ss.put('a','b');
   
        ApexPages.currentPage().getParameters().put('resource_url','appid=abcdefgh&bmctx');
        App_Mapping__c apm3=IAM_Login_Utillity.getAppMapping(ss);
        String str5=IAM_Login_Utillity.getResourceURL(ss);
        String str6=IAM_Login_Utillity.getOAMerrorcodes(ss);
        
        ApexPages.currentPage().getParameters().put('appid', app.id);
        ApexPages.currentPage().getParameters().put('startURL','appid=abcdefgh&bmctx');
        
        App_Mapping__c apm=IAM_Login_Utillity.getAppMapping(ss);
        String str=IAM_Login_Utillity.getResourceURL(ss);
        String str2=IAM_Login_Utillity.getOAMerrorcodes(ss);
        
        ApexPages.currentPage().getParameters().put('startURL','appid=abcdefghx');
        App_Mapping__c apm2=IAM_Login_Utillity.getAppMapping(ss);
        String str3=IAM_Login_Utillity.getResourceURL(ss);
        String str4=IAM_Login_Utillity.getOAMerrorcodes(ss);
        
        
        ApexPages.currentPage().getParameters().put('startURL','app=fgfghgfhg&RelayState');
        App_Mapping__c apm4=IAM_Login_Utillity.getAppMapping(ss);
        String str7=IAM_Login_Utillity.getResourceURL(ss);
        String str8=IAM_Login_Utillity.getOAMerrorcodes(ss);
        }

}