@IsTest
Private Class CSS_WS_DR_Rejection_Async_Test{

    Public Static TestMethod Void testfutureMethod1(){
       
       Profile profile2 =[SELECT Id, usertype FROM Profile where name='System Administrator' Limit 1];
        User userApproval = new User(
            Username = System.now().millisecond() + 'testApproval@test.com',
            ProfileId = profile2.Id,
            Alias = 'test4',
            Email = 'test4@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            IsActive = true,
            LanguageLocaleKey = 'en_US');
        insert userApproval;
       
       Profile profile1 =[SELECT Id, usertype FROM Profile where name='System Administrator' Limit 1];
        User users = new User(
            Username = System.now().millisecond() + 'test4@test.com',
            ProfileId = profile1.Id,
            Alias = 'test3',
            Email = 'test3@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            IsActive = true,
            LanguageLocaleKey = 'en_US',
            Community_Approver__c = userApproval.Id);
        insert users;
       
        System.runAs(users){
            CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
                CSS_WS_DR_Rejection_Reason__c = '',
                CSS_WS_Claim_Status__c = 'Getting DR Rejection Reason');
            insert claim;
        
            // Create an approval request for the claim
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(claim.id);
            
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(users.id);
            
            // Submit the record to specific process and skip the criteria evaluation
            req1.setProcessDefinitionNameOrId('CSS_WS_Warranty_Approval_Process');
            req1.setSkipEntryCriteria(true);
            
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);        
            
            // Reject the submitted request
            // First, get the ID of the newly created item
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
            
            // Instantiate the new ProcessWorkitemRequest object and populate it
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Rejecting request.');
            req2.setAction('Reject');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            
            // Use the ID from the newly created item to specify the item to be worked
            req2.setWorkitemId(newWorkItemIds.get(0));
            
            // Submit the request for approval
            Approval.ProcessResult result2 =  Approval.process(req2);
              
            Test.startTest();
            CSS_WS_DR_Rejection_Async.rejectionReason(claim.Id);
            Test.stopTest();
        }
    }
    
    Public Static TestMethod Void testfutureMethod2(){
       
        CSS_WS_Warranty__c claim = new CSS_WS_Warranty__c(
            CSS_WS_DR_Rejection_Reason__c = '',
            CSS_WS_Claim_Status__c = 'Getting Paccar Rejection Reason');
        insert claim;
          
        Test.startTest();
        CSS_WS_DR_Rejection_Async.rejectionReason(claim.Id);
        Test.stopTest();
        
    }
}