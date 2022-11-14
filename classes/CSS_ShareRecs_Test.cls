@IsTest
private class CSS_ShareRecs_Test {
    
    static TestMethod void testforSahreRecs(){
        
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        system.debug('output for Parent'+SerRec);
        
        list<CSS_Job_Order__c> JobId = [select id from CSS_Job_Order__c where Customer_Name__c='ABC'];

        
        CSS_Job_Order__Share ShaObj = new CSS_Job_Order__Share();
         
                ShaObj.RowCause = 'CSS_Apex_AssignedTo_Sharing__c';
                ShaObj.userOrGroupId = userInfo.getUserId();
                ShaObj.ParentId=JobId[0].id;
        		ShaObj.AccessLevel='Edit';
                      Insert ShaObj;
                      system.debug('output for child'+ShaObj);
        CSS_ShareRecs.css_relatedrec(JobId);
        system.assertEquals(ShaObj.ParentId, JobId[0].id);
        
        
    } 
}