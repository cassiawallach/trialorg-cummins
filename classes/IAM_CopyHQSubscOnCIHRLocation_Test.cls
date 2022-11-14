/*
*Created By : Sandeep
*
*
*
*/
@isTest
public class IAM_CopyHQSubscOnCIHRLocation_Test{
//@testSetup
    public static void createTestData(){
      
      account pacc=new account();
        pacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        pacc.name = 'parentAcc';
        pacc.Type = 'NATIONAL ACCT_CIHR - HQ';
        pacc.CMI_Account_Status__c = 'Active';
        pacc.IAM_Service_Provider_Code__c='pacc1';
        pacc.EBU_Channel_Of_Distribution__c=Label.IAM_Distribution_Channel_National_Acct_CIHR_HQ;
        pacc.PSBU_Channel_Of_Distribution__c=Label.IAM_Distribution_Channel_National_Acct_CIHR_HQ;
        insert pacc;
        
         account pacc2=new account();
        pacc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        pacc2.name = 'parentAcc2';
        pacc2.Type = 'NATIONAL ACCT_CIHR - HQ';
        pacc2.CMI_Account_Status__c = 'Active';
        pacc2.IAM_Service_Provider_Code__c='pacc2';
        pacc.EBU_Channel_Of_Distribution__c=Label.IAM_Distribution_Channel_National_Acct_CIHR_HQ;
        pacc.PSBU_Channel_Of_Distribution__c=Label.IAM_Distribution_Channel_National_Acct_CIHR_HQ;
        insert pacc2;
        
       
        account acc=new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc.name = 'CIHR Location-1';
        acc.parentId = pacc.Id;
        acc.CMI_Account_Status__c = 'Active';
        acc.CSS_DistributorCode__c='test';
        acc.Type='CIHR';
        acc.IAM_Service_Provider_Code__c='12CIHR';
        insert acc;
        
        account acc1=new account();
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc1.name = 'CIHR Location-2';
        acc1.parentId = pacc.Id;
        acc1.CMI_Account_Status__c = 'Active';
        acc1.CSS_DistributorCode__c='test1';
        acc1.Type='CIHR';
        acc1.IAM_Service_Provider_Code__c='11CIHR';
        insert acc1;
        
        
         account acc2=new account();
        acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        acc2.name = 'CIHR Location-3';
        acc2.parentId = pacc.Id;
        acc2.CMI_Account_Status__c = 'Active';
        acc2.CSS_DistributorCode__c='test1';
        acc2.Type='CIHR';
        acc2.IAM_Service_Provider_Code__c='13CIHR';
        insert acc2;
      
        
        IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = 'Guidanz';
        app4.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        app4.IAM_Role__c = 'Technician';
        app4.IAM_Status__c = 'Active';
        app4.IAM_Account_Name__c = pacc.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Subscription_Start_Date__c=System.today();
        app4.IAM_Subscription_End_Date__c= System.today() + 5;
        app4.IAM_Subscription_Count__c = 10;
        app4.IAM_Free_Subscription__c= true;
        app4.IAM_License_Type__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test';
        app4.IAM_Source__c = 'SwReg';
        
        insert app4;
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = 'QuickServe Online';
        app5.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app5.IAM_Role__c = 'QSOL CIHR';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c =pacc2.id;
        app5.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        app5.IAM_Subscription_Start_Date__c=System.today();
        app5.IAM_Subscription_End_Date__c= System.today() + 5;
        app5.IAM_Subscription_Count__c = 10;
        app5.IAM_Free_Subscription__c= False;
        app5.IAM_License_Type__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test';
        app5.IAM_Source__c='SwReg';
       
        insert app5;
        
        IAM_Application__c app6 = new IAM_Application__c();
        app6.IAM_Application_Name__c = 'QuickServe Online';
        app6.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        app6.IAM_Role__c = 'QSOL CIHR';
        app6.IAM_Status__c = 'Active';
        app6.IAM_Account_Name__c =acc2.id;
        app6.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        app6.IAM_Subscription_Start_Date__c=System.today();
        app6.IAM_Subscription_End_Date__c= System.today() + 5;
        app6.IAM_Subscription_Count__c = 10;
        app6.IAM_Free_Subscription__c= False;
        app6.IAM_License_Type__c = 'test';
        app6.IAM_Qsolexpiration__c = 'test';
        app6.IAM_Source__c='SwReg';
       
        insert app6;
        
    }
     static testMethod void testCopyHQLocationAppsOnCIHR() {
        Test.startTest();
        createTestData();
        List<Account> acnt= new List<Account>();
        Map<id,List<Account>> cihrMap= new Map<id,List<Account>>();
        Map<id,List<IAM_Application__c>> apps= new Map<id,List<IAM_Application__c>>();
        
        List<Account> parentAccounts= [Select id from Account where IAM_Service_Provider_code__c='pacc1' OR IAM_Service_Provider_Code__c='pacc2'];
        List<Account> CIHRAccounts=[Select id,parentid from Account where IAM_Service_Provider_code__c='11CIHR' OR IAM_Service_Provider_Code__c='12CIHR' OR IAM_Service_Provider_Code__c='13CIHR'];
        
        Account a=[Select id,Name,parentid from Account where IAM_service_Provider_Code__c='11CIHR'];
        a.Parentid=[select id from Account where IAM_Service_Provider_Code__c='pacc2'].id;
        acnt.add(a);
        
        Account a1=[Select id,Name,parentid,CMI_Account_Status__c from Account where IAM_service_Provider_Code__c='13CIHR'];
        a1.CMI_Account_Status__c='Cancelled';
        acnt.add(a1);
        
        Update acnt;
        
        for(Account ant:CIHRAccounts){
            if(cihrMap.ContainsKey(ant.parentid)){
                cihrMap.get(ant.PArentid).add(ant);
            }else{
                cihrMap.put(ant.Parentid, new Account[]{ant});
            }
            
        }
        
        
        
        
        List<IAM_Application__c> subs=[SELECT Id
                 , IAM_Account_Name__c
                 , IAM_Application_Name__c
                 , IAM_Subscription_Start_Date__c
                 , IAM_Subscription_End_Date__c
                 , IAM_Subscription_Count__c
                 , IAM_Role__c
                 , IAM_Qsolexpiration__c
                 , IAM_swregExpire__c
                 , IAM_Guidanz_Mobile_Roles__c
                 , IAM_Free_Subscription__c
                 , IAM_Status__c
                 , IAM_Subscription_Name__c
                 , IAM_License_Type__c
                 , IAM_Source__c
                 , RecordtypeId
              FROM IAM_Application__c
              WHERE IAM_Account_Name__r.IAM_Service_Provider_Code__c='pacc1' OR IAM_Account_Name__r.IAM_Service_Provider_Code__c='pacc2'];
              
        System.debug('Prinitng subscriptoin for PArent account 1'+subs);
        
        for(IAM_Application__c apnt:subs){
            if(apps.ContainsKey(apnt.IAM_Account_Name__c)){
                
            }else{
                apps.put(apnt.IAM_Account_Name__c,new IAM_Application__c[]{apnt});
            }
        
        }
        
         IAM_CopyHQSubsciptionsOnCIHRLocation objClass= new IAM_CopyHQSubsciptionsOnCIHRLocation();
         IAM_CopyHQSubsciptionsOnCIHRLocation.cloneHQAppSubsciptionstoCIHRLocation(cihrMap,apps,true);
              
         Test.StopTest();
      }
}