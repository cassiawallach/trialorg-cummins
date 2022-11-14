@isTest
private class CMI_CompanyInformation_Old_Test{
    static testMethod void myUnitTest(){
    updateUser();
    }

    Public static void company(id accountId,list<id> contactsId)
    {
     CMI_CompanyInformation_old.userUpdate(accountId,contactsId,'Activate');
    }
        @future
        Public static void updateUser()
        {
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
        c.Username__c='username@gmail.com';
        c.IAM_Contact_Status__c='Inactive';
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
       
     
     List<id> cid=new list<id>();
        cid.add(c.id);
         CMI_CompanyInformation_old o=new CMI_CompanyInformation_old();
    CMI_CompanyInformation_Old.CalloutResponseContents(a.id,'active','Activate');
    CMI_CompanyInformation_Old.TspValidation(a.id,'Activate');
    CMI_CompanyInformation_Old.TspValidation(a.id,'Send To PC');
    CMI_CompanyInformation_Old.MoritoriumValidation(a.id,'Send To PC');
    company(a.id,cid);
      
        } 
    }