@isTest
public class FSL_CSSP_equipmentController_Test {
    
    static testMethod void TestMethod1(){
        Profile pf=[SELECT id,name FROM Profile WHERE name='FSL_Guidanz_Customer_Community_User'];
        User us = [SELECT Id, Name, contactId, contact.AccountId,ProfileId FROM user WHERE ProfileId =:pf.id and IsActive=true limit 1];
        
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='9895634567';
        con.Email='av456@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Unit_Number__c = 'unitnumber';
        asst.AccountId=acc.Id;
        asst.Make__c = 'make';
        asst.Model__c = 'model';
        asst.Service_Model__c = 'enginegeneratormodel';
        asst.Registration__c='licenseNumber';
        //ase.ContactId=con.Id;
        asst.Safety_Requirement__c=True;
        asst.Type__c='Engines';
        asst.Type_PSN__c='Engines-79644334';
        asst.Application_Code__c='234';
        asst.Individual__c = '';
        insert asst;
        
        Id CaseRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
        Case newCase = new Case();
        newCase.Subject = 'Unittest';
        newCase.Status = 'New';
        newCase.AssetId = asst.id;
        newCase.Unit_Number__c = '001';
        newCase.Description = 'Test';
        newCase.Location__c = 'HYD';
        // newCase.AccountId = Acc.id;
        // newCase.ContactId = con.id;
        newCase.RecordTypeId = CaseRecId;
        insert newCase;
        
        Case testCase = [select AssetId, Subject, Status from Case where Subject = 'Unittest']; 
        System.assertEquals(testCase.Subject, 'Unittest');
        //S code
        Case testCase1 = New Case(AssetId = testCase.AssetId, Subject = testCase.Subject, Status = testCase.Status);
        System.debug(testCase1);
        Case testCase2 = New Case(AssetId = null, Subject = testCase.Subject, Status = testCase.Status);
        System.debug(testCase2);
        //S code
        Profile p = [SELECT Id FROM Profile WHERE Name='FSL_Guidanz_Customer_Community_User']; 
        User u = new User(Alias = 'test', Email='standarduser@testorg.com.gdnz', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.gdnz',
                          State = 'Nevada', City = 'Naperville', Country = 'United States', 
                          street = '2526 looking', PostalCode = '12345',contactId=con.id);
        
        Insert u;
        Test.startTest();
             FSL_CSSP_equipmentController.getAssetslist(acc.Id);
             FSL_CSSP_equipmentController.saveCase(testCase1);
        	 // S code
			 FSL_CSSP_equipmentController.saveCase(testCase2);
             // S code
             FSL_CSSP_equipmentController.getAssetslists();
             FSL_CSSP_equipmentController.getContactId();
             FSL_CSSP_equipmentController.getAssetsRecord(asst.id);
             FSL_CSSP_equipmentController.saveAssetRecord('make','model','assetnumber','enginegeneratormodel','unitnumber','licenseNumber');
             FSL_CSSP_equipmentController.currentuser(u.id);
        Test.stopTest();   
    }
    static testMethod void TestMethod2(){
        Profile pf=[SELECT id,name FROM Profile WHERE name='FSL_Guidanz_Customer_Community_User'];
        User us = [SELECT Id, Name, contactId, contact.AccountId,ProfileId FROM user WHERE ProfileId =:pf.id and IsActive=true limit 1];
        
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='9895634567';
        con.Email='av456@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        Asset asst = new Asset();
        asst.Name = '79704393';
        asst.Unit_Number__c = 'unitnumber';
        asst.AccountId=acc.Id;
        asst.Make__c = '';
        asst.Model__c = '';
        asst.Service_Model__c = 'enginegeneratormodel';
        asst.Registration__c='licenseNumber';
        //ase.ContactId=con.Id;
        asst.Safety_Requirement__c=True;
        asst.Type__c='Engines';
        asst.Type_PSN__c='Engines-79644334';
        asst.Application_Code__c='234';
        asst.Individual__c = '';
        insert asst;
        
       
       
       // Id CaseRecId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
       RecordType caserecordTypeId = [SELECT Id, Name FROM RecordType WHERE Name='IA Request'];
        Case newCase1 = new Case();
        newCase1.Subject = 'Unittest1';
        newCase1.Status = 'New';
        newCase1.AssetId = null;
        newCase1.Make__c='';
            newCase1.Model__c='';
            newCase1.AssetId=null;
        newCase1.Unit_Number__c = '001';
        newCase1.Description = 'Test';
        newCase1.Location__c = 'HYD';
        // newCase.AccountId = Acc.id;
        // newCase.ContactId = con.id;
        newCase1.RecordTypeId = caserecordTypeId.id;
        insert newCase1; 

        Case testCase1 = [select Subject, Status from Case where Subject = 'Unittest1']; 
        System.assertEquals(testCase1.Subject, 'Unittest1');
        
        Test.startTest();
             
             FSL_CSSP_equipmentController.saveCase(testCase1);
             
        Test.stopTest();   
    }
}