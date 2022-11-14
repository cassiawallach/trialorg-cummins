@isTest
public class IAM_CDO_OutboundReqParser_Test{
    @testSetup
    public static void setup() { 
        
        Account a= new Account();
        a.Name='Identity Individual Users';
        a.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        a.phone = '6884382997';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        a.IAM_Service_Provider_Code__c = '54699';
        a.CSS_DBCode__c = 'tesC';
        a.CSS_DistributorCode__c = 'tesD'; 
        a.CSS_Locale__c  = 'English(United States)';
        a.CSS_Language__c  = 'English(United States)'; 
        a.CSS_Timezone__c  = '(GMT+00:00) Greenwich Mean Time (GMT)';
        a.CSS_DealerCode__c = 'testD';
        a.IAM_Movex_Customer_Code__c = 'testMov';
        a.IAM_WWSPS_Regions__c = 'US and Canada';
        insert a;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'test1';
        Con.Accountid=a.id;
        Con.LastName = 'test852';
        con.Username__c='testCDO@eiam.com';
        Con.Email = 'test000@eiam.com';
        Con.IAM_Contact_Status__c = 'Active';
        Con.phone = '8989898989';  
        insert Con;
        
        IAM_Application__c accAccess=new IAM_Application__c();
        accAccess.IAM_Account_Name__c=a.Id;
        accAccess.IAM_Application_Name__c='Connected Solutions';
        accAccess.IAM_Role__c='AccountManager';
        accAccess.IAM_Free_Subscription__c=true;
        insert accAccess;
        
      //IAM_Contact_Provisioning__c
        IAM_Contact_Provisioning__c userAccess=new IAM_Contact_Provisioning__c();
        userAccess.IAM_Application_Name__c='Connected Solutions';
        userAccess.IAM_Role__c='AccountManager';
        userAccess.IAM_Contact__c=con.id;
        userAccess.IAM_Status__c='Active';
        userAccess.IAM_From_CDO__c=false;
        userAccess.IAM_DA_Customer_List__c='78789';
        userAccess.IAM_Account_Application__c=accAccess.id;
        userAccess.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        insert userAccess;
    }
    
    Public Static testMethod void testCDO_ReqParser(){
        
        Contact c=[select id from Contact where Username__c='testCDO@eiam.com']; 
        IAM_Contact_Provisioning__c user = [SELECT Id FROM IAM_Contact_Provisioning__c WHERE IAM_Status__c='Active' and IAM_Application_Name__c='Connected Solutions' and IAM_Contact__c=:c.id LIMIT 1];
        IAM_CDO_OutBoundReqParser.IAM_CDO_ReqParserClass(user.id,'create');
    }
}