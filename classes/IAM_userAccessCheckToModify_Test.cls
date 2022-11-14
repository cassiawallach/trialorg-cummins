@isTest(SeeAllData=True)
public class IAM_userAccessCheckToModify_Test{
  
   public static void createTestData(){
   
   /*UserRole r = new UserRole();
         r.Name = 'DFSE_CUMMINS_EAST';
         r.DeveloperName = 'DFSE_CUMMINS_EAST2';
         insert r;*/
         
         Account countryParent = new Account();
         countryParent.Name='Cummins - United States- Test';
         CountryPArent.Type='Internal';
         CountryParent.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('CMI').getRecordTypeId();
         
         insert CountryPArent;
         
   
        Account parentAcc = new Account();
        parentAcc.Name = 'CSSNA - East Region';
        parentAcc.IAM_Service_Provider_Code__c='123455';
        parentAcc.Type = 'Distributor Account';
        parentAcc.Parentid=CountryParent.id;
        parentAcc.EBU_Channel_of_Distribution__c='DISTRIBUTOR-HEADQUARTERS';
        parentAcc.PSBU_Channel_of_Distribution__c='DISTRIBUTOR-HEADQUARTERS';
        parentAcc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
        insert parentAcc;
   
        Account accRecord = new Account();
        accRecord.Name = 'Test Company';
        accRecord.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();  
        accRecord.phone = '6884382997';
        accRecord.parentID = parentAcc.Id;
        accRecord.Type = 'Dealer Account';
        parentAcc.EBU_Channel_of_Distribution__c='DEALER';
        parentAcc.PSBU_Channel_of_Distribution__c='DEALER';
        //accRecord.CMI_Primary_Contact__c = conPar.Id;
        //accRecord.IAM_Service_Provider_Code__c = '54699';
        accRecord.CSS_DBCode__c = 'tesC';
        accRecord.CSS_DistributorCode__c = 'tesD';
        //accRecord.Location__c = 'testLoca';
        accRecord.CSS_DealerCode__c = 'testDea';
        accRecord.EBU_Channel_of_Distribution__c='CIHR';
        accRecord.BillingStreet = 'street';
        accRecord.BillingCity = 'Telangana';
        accRecord.BillingCountry = 'India';
        accRecord.BillingPostalCode = '234567';
        accRecord.IAM_Movex_Customer_Code__c = 'testMov';
        accRecord.IAM_WWSPS_Regions__c = 'US and Canada';
        insert accRecord ;
        
        
        
        
        //Contact
        Contact conNew = new Contact();
        conNew.accountID = accRecord.id;  
        conNew.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();       
        conNew.Email= 'useraccess@test.com'; 
        conNew.FirstName = 'Send';
        conNew.LastName = 'Send LDAP'; 
        //conNew.IAM_Contact_Status__c = 'Active';        
        conNew.USername__c =  'useraccess@test.com';        
        conNew.phone = '8989898989';  
        conNew.IAM_Final_Approver__c = 'N';
        conNew.IAM_Qsolexpiration__c = 'testABC';
        conNew.IAM_swregexpire__c ='testCon';
        conNew.IAM_Internal__c = true;
        conNew.IAM_Applications__c = 'CSS_DN_Advanced';
        conNew.CMI_Contact_Type__c = 'Primary';
        conNew.IAM_is_Member_of__c = 'testMemeber';
        conNew.Username__c =  'useraccess@test.com';
        insert conNew;
        
        
        
         IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = 'Guidanz';
        app4.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        app4.IAM_Role__c = 'Technician';
        app4.IAM_Status__c = 'Active';
        app4.IAM_Account_Name__c = accRecord.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Subscription_Start_Date__c=System.today();
        app4.IAM_Subscription_End_Date__c= System.today() + 5;
        app4.IAM_Subscription_Count__c = 10;
        app4.IAM_Free_Subscription__c= true;
        app4.IAM_License_Type__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test';
        app4.IAM_Source__c = 'SwReg';
        
        insert app4;
        
       
        
  }
  
  static testMethod void testUserAccessCheck() {
        
        
        User usr = [Select id,Name From User WHERE UserRole.DeveloperName = 'DFSE_CSSNA_East_Region' LIMIT 1];
        
        System.runas(usr){
        Test.startTest();
        createTestData();
        
        IAM_userAccessCheckToModify.getHQUserRoles();
         
        
        Test.stopTest();
        }
    }   
    
     
  
}