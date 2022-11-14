/*
 * Schedule class to implement batch class for deletion  of all the application subscriptions in Contact Provisioning and Account Provisioning table 
 */
global class IAM_Remove_Subscritions_Schedule implements Schedulable {
    global void execute(SchedulableContext sc){ 
        Id batchProcessId = Database.ExecuteBatch(new IAM_Remove_Subscritions(), 1);
        Id userBatchProcessId = Database.executeBatch(new IAM_Remove_Subscriptions_User(), 1);         
    }    
}