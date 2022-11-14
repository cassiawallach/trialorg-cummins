/**********************************************************************
Name: FSL_AddToGroup
Copyright Â© 2019  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
Trigger Handler to add User as a Group Member whenever added a User Territory by Admin Portal User
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0         Harsha Ragam			   11/22/2019    Initial Development
********************************************************************************************************************/
public class FSL_AddToGroupHandler {
    
    @future(callout = true)
    public static void AddtoGroup(Set<Id> userTIds) {
        FSL__User_Territory__c userT = [SELECT Id, FSL__User__r.Id, FSL__Territory_Name__c FROM FSL__User_Territory__c WHERE Id IN: userTIds LIMIT 1];
        system.debug('userT++++' + userT);
        Group g = [SELECT Id, Name FROM Group WHERE Name =: userT.FSL__Territory_Name__c LIMIT 1];
        system.debug('g++++' + g);
        list<GroupMember> listGroupMember = new list<GroupMember>();
        groupmember gm = new groupmember();
        gm.GroupId = g.Id;
        gm.UserOrGroupId = userT.FSL__User__r.Id;
        listgroupmember.add(gm);
        insert listGroupMember;
    }
}