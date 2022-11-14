@IsTest 
public class OSM_Subscription_ExpiredScheduler_Test {
        
    static testmethod void OSM_Subscription_ExpiredScheduler(){
            try{
                Test.StartTest();
                OSM_Subscription_ExpiredScheduler obj = new OSM_Subscription_ExpiredScheduler();
                String sch = '0 0 23 * * ?';
                system.schedule('Test Territory Check', sch, obj ); 
                Test.stopTest(); 
            }catch(Exception ex){
                System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
            }
    }

}