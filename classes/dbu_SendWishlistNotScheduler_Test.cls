@isTest
public class dbu_SendWishlistNotScheduler_Test {
    
    @isTest static void executeTest(){
        
        SchedulableContext sc = null;
        dbu_SendWishlistNotificationsScheduler tsc = new dbu_SendWishlistNotificationsScheduler();
        tsc.execute(sc);
         
    }  
    
}