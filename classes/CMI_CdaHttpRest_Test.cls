@isTest
private class CMI_CdaHttpRest_Test{

    static testMethod void myUnitTest() 
    {
        Account a=new Account();
        Contact c=new Contact();
        a.name='name';
        a.CMI_CDA_Status__c='Sent to Customer';
        a.CMI_CId__c='8765';
        a.CMI_Cummins_Support_email__c='test@gmail.com';
        c.Email='test@gmail.com';
        insert a;
        
        
         IAM_Application__c appIAM= new IAM_Application__c();   
        appIAM.IAM_Account_Name__c = a.ID;
        appIAM.IAM_Application_Name__c = 'Connected Solutions';
        appIAM.IAM_Role__c='PrimaryContact';
        appIAM.IAM_Status__c='Active';
        appIAM.IAM_Subscription_Count__c= 10;
        appIAM.IAM_Provisioned_User_Count__c=5;
        appIAM.IAM_Subscription_End_Date__c= System.today() + 5;
        appIAM.IAM_Subscription_Name__c='TestSubscription1';
        appIAM.IAM_Free_Subscription__c= False;
        appIAM.IAM_Subscription_Start_Date__c=System.today();
        appIAM.recordtypeid=Schema.SObjectType.IAM_application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        insert appIAM;
        
        CMI_CdaHttpRest obj=new CMI_CdaHttpRest ();
        CMI_CdaHttpRest.send(appIAM.id,a.id,'Active');
        CMI_CdaHttpRest.cmiError('test','test','test');
        //CMI_CdaHttpRest.send(null,'Active');
    }
 }