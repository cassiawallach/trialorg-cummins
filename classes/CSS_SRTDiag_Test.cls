/*
 * Block comments with details of changes
 */
 
@isTest
public class CSS_SRTDiag_Test
{
   public static  testMethod void method1(){
       
       //creation of test data
       CSS_Job_Order__c workJob1 =  CSS_TestData.createJobOrder(true);
       system.debug('*****workJob1***'+workJob1.Id);
       test.startTest();
           ApexPages.CurrentPage().getParameters().put('id',workJob1.Id);
            CSS_SRTDiag srtDiag = new CSS_SRTDiag();
                srtDiag.isClaimEnabled=false;
                srtDiag.pgeName='TnDRJ';
                srtDiag.isError=false;
       			srtDiag.technician='test';
       //PageReference pageRef = Page.CSS_JobRepairRj;
       
        PageReference pageRef = new PageReference('/apex/CSS_JobTnDRJ');
       system.debug('*****workJob1***Before'+workJob1.Id);
         //   ApexPages.CurrentPage().getParameters().put('id',workJob1.Id);
       system.debug('*****workJob1***After'+workJob1.Id);
			Test.setCurrentPage(pageRef);
                srtDiag.techSave();
       		
       test.stopTest();
   }
}