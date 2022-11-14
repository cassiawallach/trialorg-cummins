/******************************************************************************************************
Name : FSL_serviceReqShare
Description : Service Request object Trigger for record sharing

Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                   02/26/2020            MALLIKA SUBHASHINI                   Trigger created          
*********************************************************************************************************/
public class FSL_serviceReqShare {
    
    // @InvocableMethod
    public static void serviceReqRecShare(list<case> caseList) {
        set<Id> caseId = new set<Id>();
        Map<Id, String> terrName = new Map<Id, String>();
        Map<String, Id> grpMap = new Map<String, Id>();
        List<CaseShare> csShareList = new List<CaseShare>();
        set<String> serTer = new  set<String>();
        Id recdtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Reported_Problem').getRecordTypeId();
        system.debug('caselist####' + caseList);
        for(case cs:caseList) {
            if (cs.RecordTypeId != recdtypeId) {
                caseId.add(cs.Id);
            }
        }
        list<case> clist =[select Id, Service_Territory__r.Name, RecordTypeId FROM Case WHERE Id IN: caseId];
        
        for(case cs:clist) {
            if (cs.RecordTypeId != recdtypeId) {
                terrName.put(cs.Id, cs.Service_Territory__r.Name);
            }
        }
        
        system.debug('**terrName**' + terrName);
        list<Group> grp = [SELECT Id, Name FROM Group WHERE Name IN: terrName.values()];
        system.debug('>>>group name<<<' + grp);
        for(Group gp:grp) {
            grpMap.put(gp.name, gp.id);
        }
        
        if(grp.size() > 0) {
            for(case c:caseList) {
                if (c.RecordTypeId != recdtypeId)  {
                    // Create a new caseShare object for each case where serviceterritoryId field is not NULL.
                    CaseShare csShare = new CaseShare();
                    // Give Read write access to that UserOrGroupId for this particular case record.
                    csShare.CaseAccessLevel = 'edit';
                    // Assign case Id of case record.
                    csShare.CaseId = c.Id;
                    // system.debug('');
                    // Assign UserOrGroupId id to grant read write access to this particular case record.
                    csShare.UserOrGroupId = grpMap.get(terrName.get(c.Id));
                    csShareList.add(csShare);
                }
            }
        }
        
        if(csShareList != null && csShareList.size() != 0) {
            try {
                system.debug('***csShareList**' + csShareList);
                insert csShareList;
            } catch( Exception e) {
                system.debug('Error::::::' + e.getMessage());
            }
        }
    }
}