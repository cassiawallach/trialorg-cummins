//Comment to detect coverage - Adam
@isTest
private class FSLServiceResourceSkillBatch_Test {
    public static String CRON_EXP = '0 0 0 15 3 ? 2099';
    @testSetup 
    static void makeData() {
        Skill skl = [SELECT Id, MasterLabel FROM Skill LIMIT 01];
        List<PermissionSetAssignment> perSetAssmntList = [SELECT Assignee.Name, AssigneeId 
                                                          FROM PermissionSetAssignment 
                                                          WHERE PermissionSet.Name = 'FSL_Resource_License' LIMIT 03];
        List<ServiceResource> serResList = new List<ServiceResource>();
        List<CSS_AccredUser__c> cssAccUsrList = new List<CSS_AccredUser__c>();
        for (PermissionSetAssignment perSetAssmnt : perSetAssmntList) {
            User usr = new User(Id = perSetAssmnt.AssigneeId);
            serResList.add(populateServiceResource(usr, FALSE));
            cssAccUsrList.add(populateCssAccredUsr(skl.MasterLabel, usr, FALSE));
        }
        if (!serResList.isEmpty()) {
            insert serResList;
            insert cssAccUsrList;
        }
    }
    static testMethod void testPositive() {
        List<ServiceResourceSkill> serResSkls = new List<ServiceResourceSkill>();
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new FSLServiceResourceSkillBatch_Schedule()); 
        serResSkls = fetchSerResSkls();
        System.assertEquals(0, serResSkls.size(), 'There should not be any Service Resource Skill');
        Test.stopTest();
    }
    static testMethod void testPositiveBatch() {
        List<ServiceResourceSkill> serResSkls = new List<ServiceResourceSkill>();
        Test.startTest();
        FSLServiceResourceSkillBatch bthObj = new FSLServiceResourceSkillBatch('');
        bthObj = new FSLServiceResourceSkillBatch();
        Database.executeBatch(bthObj, 200);
        Test.stopTest();
        serResSkls = fetchSerResSkls();
        System.assertEquals(03, serResSkls.size(), 'There should be 3 Service Resource Skills');    
    }
    static List<ServiceResourceSkill> fetchSerResSkls () {
        return [SELECT Id FROM ServiceResourceSkill];
    }
    public static ServiceResource populateServiceResource (User usr, Boolean isInsert) {
        ServiceResource serRes = new ServiceResource();
        serRes.Name = 'Test ServiceResource ' + Math.round(Math.random()*Math.pow(10, 3));
        serRes.RelatedRecordId = usr.Id;
        serRes.IsActive = TRUE;
        if (isInsert) {  
            insert serRes;    
        }
        return serRes;    
    } 
    public static CSS_AccredUser__c populateCssAccredUsr (String sklNm, User usr, Boolean isInsert) { 
        CSS_AccredUser__c cssAcc = new CSS_AccredUser__c();
        cssAcc.ServiceModelName__c = sklNm;
        cssAcc.User__c = usr.Id;
        if(isInsert) {
            insert cssAcc;
        }
        return cssAcc;    
    }  
}