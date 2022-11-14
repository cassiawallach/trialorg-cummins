/**********************************************************************
Name: FSLServiceResourceSkillBatch
Copyright Â© 2020  Cummins
=======================================================================
Purpose:                                                            
-------  
This Batch process is used to automate the update of 
ServiceResourceSkill from CSS_AccredUser__C object 
=======================================================================
History                                                            
-------                                                            
VERSION        AUTHOR                     DATE                                   
1.0            Mani Kumari                02/28/2020                        
***********************************************************************/
global class FSLServiceResourceSkillBatch implements Database.Batchable<sObject>, Database.Stateful {
    //Changed to private as part of Salesforce Health Assesment: NIN-489
    private String qry = '';
    //End Change
    public FSLServiceResourceSkillBatch () {
        qry = fetchBaseQuery(); 
    }
    //Created to pass the dynamic query in case of any future changes
    public FSLServiceResourceSkillBatch (String qry) {   
        this.qry = qry;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        // collect the batches of records or objects to be passed to execute
        return Database.getQueryLocator(qry);
    }
    global void execute(Database.BatchableContext info, List<CSS_AccredUser__c> cssAccUsrList){ 
        Set<String> skillNameSet = new Set<String>();
        Set<String> usrIdSet = new Set<String>();
        Map<String, ServiceResourceSkill> mSerResSkill = new Map<String, ServiceResourceSkill>();
        Map<String, Skill> mSkill = new Map<String, Skill>();
        Map<String, ServiceResource> mSerRes = new Map<String, ServiceResource>();
        // process each batch of records
        for (CSS_AccredUser__c cssAccUsr : cssAccUsrList) {
            skillNameSet.add(cssAccUsr.ServiceModelName__c);
            usrIdSet.add(cssAccUsr.User__c);
        }
        for (Skill skilRec : [SELECT Id, MasterLabel FROM Skill WHERE MasterLabel IN: skillNameSet]) {        
            mSkill.put(skilRec.MasterLabel, skilRec);
        }        
        for (ServiceResource serRes : [SELECT Id, RelatedRecordId FROM ServiceResource WHERE RelatedRecordId IN: usrIdSet]) {
            mSerRes.put(serRes.RelatedRecordId, serRes);
        }
        for (ServiceResourceSkill serResSkl : [SELECT Id, ServiceResourceId, ServiceResource.RelatedRecordId
                                               , SkillId, Skill.MasterLabel FROM ServiceResourceSkill 
                                               WHERE Skill.MasterLabel IN:skillNameSet AND ServiceResource.RelatedRecordId IN:usrIdSet]) {
                                                   //Fetching skills of the service resource to form a map with key(UserId_SkillName) => Service resource skill
                                                   mSerResSkill.put(fetchSerResSklKey(serResSkl.ServiceResource.RelatedRecordId, serResSkl.Skill.MasterLabel), serResSkl);
                                               }
        for (CSS_AccredUser__c cssAccUsr : cssAccUsrList) {
            //forming a key with userId, skill Name
            String mSerResSkillKey = fetchSerResSklKey(cssAccUsr.User__c, cssAccUsr.ServiceModelName__c); 
            //Checking if we have an existing Service resource skill
            if(!mSerResSkill.containsKey(mSerResSkillKey) 
               && mSerRes.containsKey(cssAccUsr.User__c) // Checking if Service resource exist or not for the user
               && mSkill.containsKey(cssAccUsr.ServiceModelName__c)) { //Checking if we have skill exists in the system
                   //Not having service skill in the system & having service resource and skill
                   ServiceResourceSkill serResSkl = new ServiceResourceSkill();
                   serResSkl.ServiceResourceId = mSerRes.get(cssAccUsr.User__c).Id;
                   serResSkl.SkillId = mSkill.get(cssAccUsr.ServiceModelName__c).Id;
                   serResSkl.EffectiveStartDate = System.today();
                   mSerResSkill.put(mSerResSkillKey, serResSkl);
               }   
        }
        if (!mSerResSkill.isEmpty()) {
            List<ServiceResourceSkill> serResSklList = mSerResSkill.values();
            List<Database.UpsertResult> upsrtRslts = Database.upsert(serResSklList, FALSE);
            for (Database.UpsertResult upsrtRslt : upsrtRslts) { 
            }  
        }   
    }    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
    }  
    public String fetchBaseQuery () {
        String qry = 'SELECT Id, ServiceModelName__c, User__c FROM CSS_AccredUser__c '
            +' WHERE LastModifiedDate >= YESTERDAY ';
        return qry;
    }
    public String fetchSerResSklKey (String usrId, String sklNm) {
        return usrId + '_' + sklNm;   
    }
}