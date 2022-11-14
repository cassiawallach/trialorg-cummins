@isTest
public class CSS_DsidClose_Test {
    public static testMethod void testJobOrderData(){
        
        
        Test.startTest();
        CSS_Job_Order__c  servjob = new CSS_Job_Order__c ();
        //servjob.id = 'a093B000000xyjzQAA';
        servjob.CSS_Resolution__c = 'Solved';
        servjob.CSS_Feedback_Comments__c = 'Santosh';
        servjob.DSID__c = 'DBDT6931';
        insert servjob;
        
        CSS_CampTsbTrp__c camps = new CSS_CampTsbTrp__c(); 
        camps.Job_Order__c = servjob.id;
        camps.type__c = 'CAM';
        camps.performed_review__c = true;
        camps.performed__c = true;
        insert camps;
        user x = new user();
        x.Work_Group_Name__c = 'ORLANDO';
        
        ApexPages.CurrentPage().getParameters().put('Id',servjob.id);
        css_dsidclose controller = new css_dsidclose();
        
        Test.setMock(HttpCalloutMock.class, new CSS_GetdsidDetails_Test());
        controller.Wid = servjob.id;
        CSS_J2Adsidclose_EDS z = new CSS_J2Adsidclose_EDS();
        
        
        controller.solDetFailed = false;
        controller.campids = 'C1960';
        controller.solErrorMsg = 'invalid';
        
        controller.Closedsid(servjob.CSS_Resolution__c,servjob.CSS_Feedback_Comments__c,servjob.DSID__c);
        
        
        Test.stopTest();
        
        
        
        
        
        
        
    }
}