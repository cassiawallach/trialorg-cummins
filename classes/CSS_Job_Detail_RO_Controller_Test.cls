@isTest
public class CSS_Job_Detail_RO_Controller_Test {
	
    static testmethod void CSS_Job_Detail_RO_Controller_method(){
        test.startTest();
        CSS_Job_Order__c jo =  CSS_TestData.createJobOrder(false);
        
        jo.Actual_Technician_Time__c = 123;
        jo.Engine_Run_Time_Hours_Mileage_km_miles__c='test';
        jo.CSS_Feedback_Comments__c='test';
        jo.Complaint__c='test';
        insert jo;
        ApexPages.currentPage().getParameters().put('id', jo.Id);
        account acc =  CSS_TestData.createAccountObj(true);
        CSS_Job_Detail_RO_Controller joDetail = new CSS_Job_Detail_RO_Controller();
        joDetail.getDetails();
        test.stoptest();
    }
}