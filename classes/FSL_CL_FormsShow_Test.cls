/*
 * Test Class for Apex Controller - FSL_CL_FormsShow
 * Author - Piyush Rani
 */ 
@isTest
public class FSL_CL_FormsShow_Test {
    @isTest static void testController(){
        WorkOrder wo = FSL_TestDataUtility.createWorkOrder(null, null);
        PageReference pageRef = Page.FSL_FormsShowPage;
        Test.setCurrentPage(pageRef);
        FSL_CL_FormsShow controller = new FSL_CL_FormsShow();
        controller.jobid = wo.Id;
        ApexPages.currentPage().getParameters().put('ID', wo.Id);
        
        String nextPage = controller.navigateSames().getUrl();
        
        System.assertEquals('/apex/FSL_FormsShowPage?id='+wo.Id, nextPage); 


    }
}