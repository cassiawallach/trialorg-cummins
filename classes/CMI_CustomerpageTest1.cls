@isTest
public with sharing class CMI_CustomerpageTest1 {
    static testMethod void simpleTests() {
        PageReference pageRef = Page.CMI_CompanyReg;
        Account a = new account();
        contact c = new contact();
        ApexPages.StandardController controller=new ApexPages.StandardController(a);
        CMI_Customerpage re=new CMI_Customerpage(controller);
        a.CMI_Urgent_Fault_Notification__c = 'Email';
        a.CMI_Other_Fault_Notifications__c = 'Email';
        a.name='';
        try{
            re.send();
            
        }catch (exception e){
            
        }
    }
    
    static testMethod void simpleTests2() {
        Account  a=new Account();
        Contact c= new Contact();
        PageReference pageRef = Page.CMI_CompanyReg;
        //Test.setCurrentPageReference(pageRef);
        apexPages.StandardController controller=new ApexPages.StandardController(a);
        CMI_Customerpage re=new CMI_Customerpage(controller);
        a.CMI_Urgent_Fault_Notification__c = 'Email';
        a.CMI_Other_Fault_Notifications__c = 'Email';
        a.name='';
        a.Name='Cummins';
        a.BillingStreet='303 washington street';
        a.BillingCity='Columbus';
        a.BillingPostalCode='47201';
        c.FirstName='Keerthy';
        c.LastName='Guru';
        c.Email='abc@gmail.com';
        c.phone='3198765489';  
        a.CMI_Cummins_Support_First_Name__c='Cummins';
        a.CMI_Cummins_Support_Last_Name__c='CS';
        a.CMI_Cummins_Support_Email__c='abc1@gmail.com';
        a.CMI_Telematics_Service_Provider__c='Other';
        a.CMI_Urgent_Fault_Notification__c  ='Email';  
        a.CMI_Other_Fault_Notifications__c='Email';
        //a.CMI_Urgent_Fault_Notification_Email__c='test@gmail.com';
        a.CMI_Other_Fault_Notifications_Email__c='test1@gmail.com';
        CMI_Customerpage re2=new CMI_Customerpage(controller);
        try{
            re2.send();
            
        }catch (exception e){
            
        }try{
            re.reset();
            
        }catch (exception e){
            
        }
        try{
            re.getURL();
            
        }catch (exception e){
            
        }
    }
}