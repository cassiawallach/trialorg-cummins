@isTest
Private class fsl_cssp_contactController_Test {
    
    static testMethod void contactControllerMehod1(){
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
        
        fsl_cssp_contactController.updateServiceReq(newCase.id);
        fsl_cssp_contactController.updateServiceReqContact(newCase.id,con);
        fsl_cssp_contactController.updateContactPhone(con.id,'9890890890');
        fsl_cssp_contactController.ServiceReqWrapper SRwrp = new fsl_cssp_contactController.ServiceReqWrapper();
        fsl_cssp_contactController.updateContact(newCase.id);
    }
}