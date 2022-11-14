public with sharing class IAM_ContactAppInfoController {
        
    @AuraEnabled
    public static String getContactAppInfo(id recordid) {
          String appName;
          if(recordid != null) {
          // Getting the Application name from url and use it in the forgot password page
          List<App_Mapping__c> appList = [SELECT Id, Name FROM App_Mapping__c where id = :recordid];
          appName = appList[0].Name;
          } else {
          appName = 'Online Login';
          }
          system.debug('appname-------'+appName);
        return appName;
    }
}