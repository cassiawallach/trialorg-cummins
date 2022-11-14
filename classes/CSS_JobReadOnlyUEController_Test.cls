@isTest
public class CSS_JobReadOnlyUEController_Test {
     static testmethod void testdatamethod()
    {
    CSS_JobReadOnlyUEController contrl = new CSS_JobReadOnlyUEController();
        contrl.jobId = null;
        //DateTime dInputDate=Datetime.now();
        contrl.dt_WarrantyDt = Datetime.now();
        contrl.WarrantyStart = Datetime.now();
        contrl.dt_FailureDt = Datetime.now();
        contrl.getWarrantyDate();
        contrl.getFailureDt();
        contrl.getItems();
    }
}