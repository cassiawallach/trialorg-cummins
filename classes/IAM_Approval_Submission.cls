public class IAM_Approval_Submission {
    Public static void submitAndProcessApprovalRequest(contact c,id approverId) {
       
        System.debug('Enterded approval==='+approverid);
        System.debug('Enterded approval contact==='+c);
        
        Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(c.id);
        
        // Submit on behalf of a specific submitter
        System.debug('Printing submitter id'+c.CreatedByid);
        req1.setSubmitterId(c.CreatedByid); 
        
        // Submit the record to specific process and skip the criteria evaluation
        
        req1.setProcessDefinitionNameOrId(Label.IAM_Contact_Admin_Approval);
       
        //req1.setSkipEntryCriteria(true);
        req1.setNextApproverIds(new Id[] {approverId});
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        system.debug(result.getInstanceId()); 
      
       
        
       
        
    }
}