Public Class CSS_WS_DR_Rejection_Async{

    @future(callout = true)   
    Public Static Void rejectionReason(Id ClaimID){       
        
        CSS_WS_Warranty__c rejected_claim = [SELECT id, name, CSS_WS_DR_Rejection_Reason__c, CSS_WS_Claim_Status__c FROM CSS_WS_Warranty__c WHERE CSS_WS_Warranty__c.id =: ClaimID];            
        System.debug('Rejected Claim: ' + rejected_claim);
        
        try{                     
            List<ProcessInstance> process_list = [SELECT Id, (SELECT Comments FROM Steps WHERE StepStatus = 'Rejected' LIMIT 1) FROM ProcessInstance WHERE TargetObjectId =: rejected_claim.id LIMIT 1];
            system.debug('Approval Process: ' + process_list);
            
            // Update DR Rejection Reason
            if(process_list.size() > 0){
                if(process_list[0].Steps.size() > 0){
                    system.debug('Comments: ' + process_list[0].Steps[0].Comments);
                    rejected_claim.CSS_WS_DR_Rejection_Reason__c = process_list[0].Steps[0].Comments;
                }
            }
            // Update Claim Status
            if (rejected_claim.CSS_WS_Claim_Status__c == 'Getting DR Rejection Reason'){
                rejected_claim.CSS_WS_Claim_Status__c = 'Denied by DR';
            } else if (rejected_claim.CSS_WS_Claim_Status__c == 'Getting Paccar Rejection Reason'){
                rejected_claim.CSS_WS_Claim_Status__c = 'Denied by Paccar';
            }
            
            update rejected_claim;
        } catch(System.Exception e){
            rejected_claim.CSS_WS_Claim_Status__c = 'Error getting DR Rejection Reason';
            System.debug('Error Getting DR Rejection Reason: '+e.getMessage());
            update(rejected_claim);
        }
    }   
}