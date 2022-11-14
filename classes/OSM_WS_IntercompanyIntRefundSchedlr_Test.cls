@IsTest 
public class OSM_WS_IntercompanyIntRefundSchedlr_Test {
        
    static testmethod void IntercompanyIntRefundScheduler_Test(){
            try{
                Test.StartTest();
                OSM_WS_IntercompanyIntRefundScheduler obj = new OSM_WS_IntercompanyIntRefundScheduler();
                String sch = '0 0 23 * * ?';
                system.schedule('Test Territory Check', sch, obj ); 
                Test.stopTest(); 
            }catch(Exception ex){
                System.debug(ex.getMessage()+'\t'+ex.getLineNumber());
            }
    }

}