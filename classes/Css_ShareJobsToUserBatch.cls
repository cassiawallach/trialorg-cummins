global class Css_ShareJobsToUserBatch implements Database.Batchable<sObject> {
    global final String query;
    global Css_ShareJobsToUserBatch(String q){
        if(q != null){
        	query=q;
        }
    }

    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
       return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, List<User> userList){
       system.debug('userList***'+userList);
    map<string,list<CSS_Job_Order__c>> mapLocationToJobs = new map<string,list<CSS_Job_Order__c>>();
    //list for fetching all service jobs 
    List<CSS_Job_Order__c> jobOrderList = new List<CSS_Job_Order__c>();
    List<CSS_Job_Order__Share> jobShrList   = new List<CSS_Job_Order__Share>();
    jobOrderList = [Select Id,Creator_Location__c FROM CSS_Job_Order__c WHERE CreatedDate <= TODAY];   
    for(user usr : userList){
                if(usr.User_Location__c!=null){
                      system.debug('inside the user for loop >>>>'+ usr.User_Location__c );
                    Set<String> userLocationsSet = new Set<String>();
                    system.debug('Insert-After jobOrderList '+ jobOrderList);
                    for(CSS_Job_Order__c objJob : jobOrderList){
                        system.debug('inside the for job list >>>>>');
                        if(usr.user_location__c == objJob.Creator_Location__c){
                            CSS_Job_Order__Share jobShr = new CSS_Job_Order__Share();
                            jobShr.ParentId         = objJob.Id;
                            jobShr.UserOrGroupId    = usr.id;
                            jobShr.AccessLevel = 'Edit';
                            jobShr.RowCause = Schema.CSS_Job_Order__share.RowCause.CSS_Apex_AssignedTo_Sharing__c;
                            jobShrList.add(jobShr);
                        }
                    }
                    
                    if(jobShrList.size() > 0){
                        Database.SaveResult[] jobShareInsertResult = Database.insert(jobShrList,false);
                        system.debug('jobShrList id'+jobShrList);
                    }
                    
                }
             }
    }

   global void finish(Database.BatchableContext BC){
   }

}