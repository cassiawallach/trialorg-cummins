global class CSS_scheduledShareJobsToUserBatch implements Schedulable {
   global void execute(SchedulableContext sc) {
       String query = 'Select Id,User_Location__c FROM User WHERE CreatedDate =  YESTERDAY';
      Css_ShareJobsToUserBatch b = new Css_ShareJobsToUserBatch(query); 
      database.executebatch(b);
   }
}