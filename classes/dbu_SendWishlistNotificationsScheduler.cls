global class dbu_SendWishlistNotificationsScheduler implements Schedulable
{
    global void execute(SchedulableContext sc)
    {       
        // We now call the batch class to be scheduled
        dbu_SendWishlistNotificationsBatch sendWishlistEmailNotification = new dbu_SendWishlistNotificationsBatch ();
       
        //Parameters of ExecuteBatch(context,BatchSize)
        database.executebatch(sendWishlistEmailNotification,50);
    }
   
}