@isTest
public class CSS_JobReadOnlyCustomerController_Test {
     static testmethod void testdatamethod()
    {
    CSS_JobReadOnlyCustomerController contrl = new CSS_JobReadOnlyCustomerController();
        contrl.jobId = null;
        //DateTime dInputDate=Datetime.now();
        CSS_JobReadOnlyCustomerController.DT = Datetime.now();
        CSS_JobReadOnlyCustomerController.getDates();
        //contrl.pgeName = 'Test';
    }
}