@isTest
private class CMI_Customerpage_Test{

    static testMethod void myUnitTest() 
    {
    Account A=new Account();
    ApexPages.StandardController sc = new ApexPages.StandardController(A);
    CMI_Customerpage obj=new CMI_Customerpage (sc);
    PageReference pageRef = Page.CMI_CompanyReg;
    pageRef.getParameters().put('id', '001234567890123');
    Test.setCurrentPage(pageRef);
    Account acc=new Account();
    acc.CMI_Email_Flag__c=true;
    acc.CMI_Telematics_Service_Provider__c='Other TSP;DriverTech';
    obj.acc=acc;
    obj.send();
    obj.click();
    //obj.getURL();
    obj.reset();
    obj.TelematicsServiceOther();
    //obj.aes256('test');
    //EmailTemplate e=new EmailTemplate();
    //e.name='CMI_SupportSubmit';
    //e.body='test';
    //insert e;
   // obj.sendSupportemail();
    CMI_Customerpage.validateEmail('test@gmail.com,test1@gmail.com',false);

    }
    static testMethod void myUnitTest1() 
    {
    Account acc2=new Account();
    
        
    ApexPages.StandardController sc = new ApexPages.StandardController(acc2);
    CMI_Customerpage obj=new CMI_Customerpage (sc);
    PageReference pageRef = Page.CMI_CompanyReg;
    pageRef.getParameters().put('id', '001234567890123');
    Test.setCurrentPage(pageRef);
    account acc=new account();
    contact newCon=new contact();
        acc.name = 'tesat';
        acc.BillingCountryCode = 'US';
        acc.BillingStreet = 'test1'; 
        acc.BillingCity = 'test';
        acc.BillingStateCode = 'CA';
        acc.BillingPostalCode = '87652';
        newCon.FirstName = 'test1';
        newCon.LastName = 'Lname';
        newCon.Email = 'test@gmail.com';
        newCon.phone = '9876543210';
        acc.CMI_Telematics_Service_Provider__c ='other Tsp';
        acc.CMI_Other_TSP__c='test';
        acc.CMI_Cummins_Support_Email__c ='test@gmail.com';
        acc.CMI_Email_Flag__c=true;
        acc.CMI_Urgent_Fault_Notification_Email__c='test@gmail.com';
        acc.CMI_Stop_Now__c='Every 4 Hours';
        acc.CMI_Service_Now__c='Every 8 Hours';
        acc.CMI_Service_Soon__c='Every 8 Hours';
        acc.CMI_CId__c='testcid';
        //acc.CMI_Account_Status__c='Pending CDA';
        obj.acc=acc;
        obj.newCon=newCon;
        obj.send();
    obj.click();
    //obj.getURL();
    obj.reset();
    obj.TelematicsServiceOther();
    //obj.aes256('test');
    //EmailTemplate e=new EmailTemplate();
    //e.name='CMI_SupportSubmit';
    //e.body='test';
    //insert e;
   // obj.sendSupportemail();
   
    string errorempty = obj.errorempty;
    CMI_Customerpage.validateEmail('test@gmail.com,test1@gmail.com',false);
    
    account acc1=new account();
    contact newCon1=new contact();
        acc1.name = 'tesat';
        acc1.BillingCountryCode = 'US';
        acc1.BillingStreet = 'test1'; 
        acc1.BillingCity = 'test';
        acc1.BillingStateCode = 'CA';
        acc1.BillingPostalCode = '87652';
        newCon1.FirstName = 'test1';
        newCon1.LastName = 'Lname';
        newCon1.Email = 'test@gmail.com';
        newCon1.phone = '9876543210';
        acc1.CMI_Telematics_Service_Provider__c ='DriverTech';
        acc1.CMI_Other_TSP__c='test';
        acc1.CMI_Cummins_Support_Email__c ='test@gmail.com';
        acc1.CMI_Email_Flag__c=true;
        acc1.CMI_Urgent_Fault_Notification_Email__c='test@gmail.com';
        acc1.CMI_Stop_Now__c='Every 4 Hours';
        acc1.CMI_Service_Now__c='Every 8 Hours';
        acc1.CMI_Service_Soon__c='Every 8 Hours';
        acc1.CMI_CId__c='testcid';
        //acc1.CMI_Account_Status__c='Pending CDA';
        obj.acc=acc1;
        obj.newCon=newCon1;
        obj.send();
        CMI_Customerpage.validateEmail('test@gmail.com,test1@gmail.com',true);
}


    
   }