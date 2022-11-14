//Test class for EVL_WorkOrderTechnicianHandler
// deploying for cvrg
@isTest
public class EVL_WorkOrderTechnician_Test 
{
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
        
         Account acc = new Account();
            acc.Name = 'East Bronx1'; 
            acc.CMI_Account_Status__c = 'Active';
            acc.PaymentType__c = 'Cash';
            acc.FSL_ERP_Customer_Code__c = '48923';
            acc.FSL_Credit_Limit__c = 78888.5;
            insert acc;        
        
        Contact objContact = new Contact(
            LastName ='Setty',
            AccountId = acc.Id,
            CMI_Contact_Type__c = 'Secondary',
            IAM_Cummins_login_ID__c='Wenchin@truck.com',
            IAM_Contact_Status__c = 'Active',
            Email = 'Wenchin.setty@gmail.com',
            FirstName ='Wenchin',
            Phone='000-000-0000');
        
            insert objContact;  
        
         objUser1.ContactID = objContact.id;
        
        insert objUser1;
        
       
        
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
        insert newTech;   
        
        system.debug( '$$$$$$$$$$$$$$$$$ case id ' + ca.id);
        system.debug(wo.id + ' workorder id $$$$$$$$$$$$$$$$$');
        system.debug(objUser1.id + ' User id $$$$$$$$$$$$$$');
        
        EVL_WorkOrderTechnicianHandler.WorkOrderTechnicianShare(wo.Id, objUser1.id,  ca.id);
            
            
            // Database.SaveResult CASEsr = Database.insert(caShare,true);
            // Database.SaveResult WOsr = Database.insert(woShare,true);   
            // Database.SaveResult WOsr = (Database.SaveResult)JSON.deserialize('{"success":true,"id":"0013000000abcde"}', Database.SaveResult.class);
            
        //update wo;
        
    }
    
}