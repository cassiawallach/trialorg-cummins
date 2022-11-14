@istest
public class CSS_GetTechInfoScheduler_test {
    
    static testmethod void testForTechInfoScheduler(){
       
       CSS_GetTechInfoScheduler nw = new CSS_GetTechInfoScheduler();
       string cronExp ='0 0 23 * * ?';
        
       test.startTest();
       system.schedule('Test Schdule', cronExp, nw);
       test.stopTest();
   }
}