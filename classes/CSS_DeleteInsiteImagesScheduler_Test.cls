@isTest 
public class CSS_DeleteInsiteImagesScheduler_Test {

    static TestMethod void testScheduler() {
        CSS_DeleteInsiteImagesScheduler insImage = new CSS_DeleteInsiteImagesScheduler();
        String runTime = '0 0 23 * * ?';
        
        Attachment att = new Attachment();
       
        

        Test.startTest();
        System.schedule('Test Schedule', runTime, insImage);
        Test.stopTest();
    }

}