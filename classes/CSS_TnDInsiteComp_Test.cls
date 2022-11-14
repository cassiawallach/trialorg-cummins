@IsTest(seealldata = true)
public class CSS_TnDInsiteComp_Test{

    static testMethod void CSS_TnDInsiteComp_Method1()
    {
    // Add test data for creating service job record
        Test.startTest();             
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
                JO.Customer_Name__c = 'RoopaTnD';
                JO.Model__c = 'RoopaTestTnD';
                JO.Service_Model_N__c = 20;
             //   JO.Shop_s_Work_Order__c = 140;
                JO.Status__c = 'Repair Complete';
                JO.Unit_Number__c = 'test1234';
                Jo.Assigned_To__c = UserInfo.getUserId();
            insert(JO);
            
            PageReference pageRef = Page.TIMBASURVEYS__SurveyCollectDataJs;
            Test.setCurrentPage(pageRef);
            CSS_TnDInsiteComp Insite= new CSS_TnDInsiteComp();
                insite.Ins_JobId=jo.id;
                insite.showINncPopup();
                insite.showINPopup();
                insite.pgChInsiteESN();
                insite.pgChJoESN();
                insite.pgCancelClose();
                insite.pgFCRefresh();
                insite.showINPopup();
                insite.getFaultCodes();
                insite.getUnprioritizedFaultCodes();
                insite.closeINncPopup();
        Test.stopTest();

    }
}