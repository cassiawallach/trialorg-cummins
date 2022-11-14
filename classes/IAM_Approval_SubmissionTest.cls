@isTest
private class IAM_Approval_SubmissionTest{

    @isTest
    static void testmethod1(){

        Account accSampleRecord = new Account(name='AccountTest1',
                                       CMI_Account_Status__c='Pending',
                                       CMI_CDA_Status__c='New Customer Request'                                                                          
                                       );
        
       insert accSampleRecord;
       Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
                      .get('IAM').getRecordTypeId();
       Contact contSampleRecord = new Contact(
            FirstName = 'Test',
            LastName ='User',
            Email = 'lstTest@test.com',
            AccountId = accSampleRecord.ID,
            IAM_Contact_Status__c = 'Active',
            CMI_Contact_Type__c = 'Primary',
            IAM_Cummins_login_ID__c = 'Amartest@abc.com',
            Phone = '9743800309',
            IAM_Internal__c = true,
            RecordTypeId = recordTypeId
        );
    
        insert contSampleRecord;
        
        Profile p = [SELECT id, Name FROM Profile where name = 'System Administrator' LIMIT 1];
                User u = new User(firstname= 'Test',
                          lastname='Data',
                          Alias='Tdxx',
                          email = 'Testdata0983@test.com',
                          username= 'Testdata0983@test.com', 
                          profileId= p.id, 
                          emailencodingkey='UTF-8',
                          languagelocalekey='en_US',
                          localesidkey='en_US',
                          timezonesidkey='America/Los_Angeles');
         insert u;  
         
         Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
         app.setObjectId(contSampleRecord.id);
         
         IAM_Approval_Submission approvalData = new  IAM_Approval_Submission();
         IAM_Approval_Submission.submitAndProcessApprovalRequest(contSampleRecord,u.id);
   }

}