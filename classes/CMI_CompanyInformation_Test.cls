//Made changes for recent DA changes -05-07-2021
@isTest
private class CMI_CompanyInformation_Test{
    static testMethod void myUnitTest(){
   
          Account a=new account();
        a.name='test';
        a.CMI_Cummins_Support_Email__c='test@gmail.com';
        a.CMI_Email_Flag__c=true;
        a.CMI_Urgent_Fault_Notification_Email__c='Test@gmail.com';
        insert a;
    
        contact c=new contact();
        c.firstname='fn';
        c.lastname='ln';
        c.accountid=a.id;
        c.Username__c='testname@gmail.com';
        c.IAM_Contact_status__c='Inactive';
    //c.phone='8181818181';
    //c.email='test@gmail.com';
        c.CMI_Contact_Type__c='Primary';
        insert c;
    
        List<CMI_TSP__c> TSP=new List<CMI_TSP__c>();
        CMI_TSP__c  cm=new CMI_TSP__c ();
        cm.CMI_Account_Name__c=a.id;
        cm.CMI_TSP_Name__c='DriverTech';
        TSP.add(cm);
        insert TSP;
        
         List<CMI_TSP__c> TSP1=new List<CMI_TSP__c>();
        CMI_TSP__c  cm1=new CMI_TSP__c ();
        cm1.CMI_Account_Name__c=a.id;
        cm1.CMI_TSP_Name__c='Other TSP';
        cm1.CMI_Other_TSP_Name__c='Name of other TSP';
        TSP1.add(cm1);
       // insert TSP1;
       
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
     
     List<id> cid=new list<id>();
        cid.add(c.id);
         CMI_CompanyInformation o=new CMI_CompanyInformation();
    CMI_CompanyInformation.CalloutResponseContents(appIAM.id,a.id,'active','Activate');
    CMI_CompanyInformation.TspValidation(appIAM.id,a.id,'Activate');
    CMI_CompanyInformation.TspValidation(appIAM.id,a.id,'Send To PC');
    CMI_CompanyInformation.MoritoriumValidation(a.id,'Activate');
    //CMI_CompanyInformation.RecordValidation(appIAM.id,a.id,'Activate');
    //company(a.id,cid);
      
        } 
    }