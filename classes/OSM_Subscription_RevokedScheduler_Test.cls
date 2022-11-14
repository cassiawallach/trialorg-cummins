@IsTest 
public class OSM_Subscription_RevokedScheduler_Test {
        
    static testmethod void OSM_Subscription_RevokedScheduler(){
            try{
                Test.StartTest();
                OSM_Subscription_RevokedScheduler obj = new OSM_Subscription_RevokedScheduler();
                String sch = '0 0 23 * * ?';
                system.schedule('Test Territory Check', sch, obj ); 
                Test.stopTest(); 
            }catch(Exception ex){
                System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
            }
    }

}