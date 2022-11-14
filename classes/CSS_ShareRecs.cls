global without sharing class CSS_ShareRecs {

    global static List<CSS_Job_Order__share> css_relatedrec(List<CSS_Job_Order__c> lstSFDCIds) {
        List <CSS_Job_Order__share> lstShareRecs = [select parentid from CSS_Job_Order__share where RowCause='CSS_Apex_AssignedTo_Sharing__c' and userOrGroupId=:userInfo.getUserId() and parentid not in :lstSFDCIds];
        return lstShareRecs ;
    }

}