@isTest
public class FSL_TSBHyperlinkcontrollers_Test {
    
    public static testmethod void launchinsitetest(){
        List<FSL_QSOLResponsewrapper> fslQSOLResps = new list<FSL_QSOLResponsewrapper>();
        String strrte;
        
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest()); 
        Test.setMock(HttpCalloutMock.class, new FSLHyperLinkMock());
        workorder objwo = new workorder ();
        objwo.ServiceTerritoryId = FSL_TestDataUtility.createServiceTerritory().Id;
        insert objwo ;
        
        CSS_Job_Order__c  servjob = new CSS_Job_Order__c ();
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
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getToken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails;
         
        test.starttest();
        FSL_TSBHyperlinkcontrollers.getAccountRecords(2,objwo.id);
        FSL_TSBHyperlinkcontrollers.loadAccountRecords(2,2,objwo.id);
        FSL_TSBHyperlinkcontrollers.TSBviewed(objwo.id);
        test.stoptest();
    }
}