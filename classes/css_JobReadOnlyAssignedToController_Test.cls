@isTest()
public class css_JobReadOnlyAssignedToController_Test {
    public static TestMethod void css_JobReadOnlyAssignedToController_Method(){
        Test.startTest();
        CSS_Job_Order__c job= CSS_TestData.createJobOrder(true);
            css_JobReadOnlyAssignedToController classRef = new css_JobReadOnlyAssignedToController();
            classRef.jobId=job.id;
            classRef.Locationcod='02466-19134';
            classRef.certifiedSelected  =true;
            classRef.certifiedSelected1 =true;
            classRef.certifiedSelected2 =true;
            classRef.certifiedSelected3 =true;
            classRef.certifiedSelected4 =true;
            classRef.certifiedSelected5 =true;
            classRef.certifiedSelected6 =true;
            classRef.certifiedSelected7 =true;
            classRef.certifiedSelected8 =true;
            classRef.certifiedSelected9 =true;
            classRef.getLocaCode();
            system.assertNotEquals(classRef, null);
        Test.stopTest();
    }
}