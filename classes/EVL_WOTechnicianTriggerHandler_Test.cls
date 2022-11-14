/********************************************************************************
Name: EVL_WOTechnicianTriggerHandler_Test
===============================================================================
===============================================================================
Purpose:Test class for EVL_WOTechnicianTriggerHandler                                                            
-------  
===============================================================================
===============================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 

*********************************************************************************/
//Adding comment for deploying changes - Sriprada S
@isTest
public class EVL_WOTechnicianTriggerHandler_Test {
    @isTest
    static  void TestSharingTechnician() 
    {
       Profile p = [SELECT Id FROM Profile WHERE Name='EVL_Dealer_Technician' Limit 1]; 
        
        User objUser1 = new User(
            Alias = 'cmi-u1', 
            Email='fsl-cmi9@cummins.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='fsl-cmi9@cummins.com',
            User_Location__c='123456');
        
        User objUser2 = new User(
            Alias = 'cmi-u1', 
            Email='fsl-cmi92@cummins.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='fsl-cmi92@cummins.com',
            User_Location__c='123456');
        
         User objUser3 = new User(
            Alias = 'cmi-u1', 
            Email='fsl-cmi93@cummins.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing',
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='fsl-cmi93@cummins.com',
            User_Location__c='123456');
        
       
        
        Account acc = new Account();
        acc.Name = 'East Bronx1'; 
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        acc.BillingPostalCode = '99999';
        insert acc;        
        
        Contact objContact = new Contact(
            LastName ='Setty',
            AccountId = acc.Id,
            CMI_Contact_Type__c = 'Secondary',
            IAM_Cummins_login_ID__c='Wenchin@truck.com',
            IAM_Contact_Status__c = 'Active',
            Email = 'Wenchin.setty@gmail.com',
            FirstName ='test',
            Username__c = 'test.multi@adv.com',
            Phone='000-000-0000');
        
        insert objContact; 
        
         Contact objContact2 = new Contact(
            LastName ='Setty',
            AccountId = acc.Id,
            CMI_Contact_Type__c = 'Secondary',
            IAM_Cummins_login_ID__c='Wenchin2@truck.com',
            IAM_Contact_Status__c = 'Active',
            Email = 'Wenchin.setty2@gmail.com',
            Username__c = 'test1.multi@adv.com',
            FirstName ='Wenchin',
            Phone='000-000-0000');
        
        insert objContact2;
 
         Contact objContact3 = new Contact(
            LastName ='Setty',
            AccountId = acc.Id,
            CMI_Contact_Type__c = 'Secondary',
            IAM_Cummins_login_ID__c='Wenchin3@truck.com',
            IAM_Contact_Status__c = 'Active',
            Email = 'Wenchin.setty3@gmail.com',
            Username__c = 'test2.multi@adv.com',
            FirstName ='Wenchin',
            Phone='000-000-0000');
        
        insert objContact3; 
        
      
        objUser1.ContactID = objContact.id;
        insert objUser1;
        
        objUser2.ContactID = objContact2.id;
        insert objUser2;
        
        objUser3.ContactID = objContact3.id;
        insert objUser3;
        
        
        WorkOrder wo = new WorkOrder();
        wo.ESN__c = '79586617';
        wo.Mileage__c = 12345;
        wo.Mileage_measure__c = 'Miles'; 
        insert wo;
        
        Case ca = new Case();
        ca.Description = '79586617';
        insert ca;
        
        Work_Order_Technicians__c newTech = new Work_Order_Technicians__c();
        newTech.Service_Order__c = wo.id; 
        newTech.User__c = objUser1.id;
        insert newTech;  
        
        Work_Order_Technicians__c newTech2 = new Work_Order_Technicians__c();
        newTech2.Service_Order__c = wo.id; 
        newTech2.User__c = objUser2.id;
        insert newTech2;
        
        Work_Order_Technicians__c newTech3 = new Work_Order_Technicians__c();
        newTech3.Service_Order__c = wo.id; 
        newTech3.User__c = objUser3.id;
        insert newTech3;
       
        DELETE newTech;
        
    }
}