@isTest
public class FSL_ServiceRequestsController_Test {
    //Surender - FBI-69 - 11/06/21 - comment for test class execution
    static testMethod void ServiceRequestsControllerMehod1(){
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
        asst.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        asst.Safety_Requirement__c=True;
        asst.Type__c='Engines';
        asst.Type_PSN__c='Engines-79644334';
        asst.Application_Code__c='234';
        asst.Individual__c = '';
        insert asst;
        
        Case newCase = new Case();
        newCase.Subject = 'Unittest';
        newCase.Status = 'New';
        newCase.AssetId = asst.id;
        newCase.Unit_Number__c = '001';
        newCase.Description = 'Test';
        newCase.Location__c = 'HYD';
        // newCase.AccountId = Acc.id;
        // newCase.ContactId = con.id;
        insert newCase; 
        
        Case testCase = [select Subject, Status from Case where Subject = 'Unittest']; 
        System.assertEquals(testCase.Subject, 'Unittest');
        
        
        FSL_ServiceRequestsController.getServiceRequests();
        FSL_ServiceRequestsController.ServiceRequestWrapperInput SRwrp = new FSL_ServiceRequestsController.ServiceRequestWrapperInput();
        FSL_ServiceRequestsController.ServiceRequestWrapperResponse SREwrp = new FSL_ServiceRequestsController.ServiceRequestWrapperResponse();
        
    }
    //--changes start- for copy all attachment from parent to child- 18-11-2021--CCM Development team----//
    static testMethod void FSL_ChildSRDataCloningTest(){
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account1 ';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve1';
        con.LastName='Johnson1';
        con.Phone='9895634563';
        con.Email='av4561@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        Id CCMRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CCM').getRecordTypeId();
        Blob ContentDocbody=Blob.valueOf('Unit Test Creation of ContentDoc'); 
        ContentVersion contentVer = new ContentVersion(
            Title='TestTitle', 
            PathOnClient ='test.jpg',
            VersionData = ContentDocbody,
            origin = 'H'
        );
        insert contentVer;
        
        ContentVersion ContentVer1 = [SELECT Id, Title, ContentDocumentId 
                                      FROM ContentVersion WHERE Id = :contentVer.Id LIMIT 1];
        
        Case childCase = new Case();
        childCase.SuppliedEmail='test@gmail.com';
        childCase.Subject = 'ParentCase';
        childCase.Description='Test';
        childCase.Origin='Test';
        childCase.RecordTypeId=CCMRecordTypeID;
        childCase.Status = 'New';
        childCase.Unit_Number__c = '001';
        insert childCase;
        
        list<EmailMessage> list_EmailMessages = new List<EmailMessage>();
        
        EmailMessage emailMessage = new EmailMessage(); 
        emailMessage.status = '0';
        emailMessage.fromName = 'Guidanz'; 
        emailMessage.ParentId=childCase.Id;
        emailMessage.RelatedToId = childCase.Id; 
        emailMessage.subject = 'Communication Status Update'; 
        emailMessage.htmlBody = '<html><body><b>Hello</b></body></html>';  
        String[] toIds = new String[]{ childCase.Id };  
            emailMessage.toIds = toIds; 
        emailMessage.toAddress = con.Email; 
        list_EmailMessages.add(emailMessage);
        insert list_EmailMessages;
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = childCase.id;
        contentlink.contentdocumentid = ContentVer1.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        
        Case newCase = new Case();
        newCase.SuppliedEmail='test@gmail.com';
        newCase.Subject = 'ParentCase';
        newCase.Description='Test';
        newCase.Origin='Test';
        newCase.RecordTypeId=CCMRecordTypeID;
        newCase.Status = 'New';
        newCase.Related_Ticket__c=childCase.Id;
        newCase.Unit_Number__c = '001';
        insert newCase;
        
        //FSL_ChildServiceRequestDataCloning.copyFilesToChildCase();
    }
    //changes end
}