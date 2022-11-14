/**********************************************************************
Name: FSL_AddToGroup
Copyright Â© 2019  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
Trigger to add User as a Group Member whenever added a User Territory by Admin Portal User
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0         Harsha Ragam               11/22/2019    Initial Development
********************************************************************************************************************/
trigger FSL_AddToGroup on FSL__User_Territory__c (After Insert) {
    List<PermissionSetAssignment> pSetAssignmnets = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() AND PermissionSet.Name = 'FSL_Manage_Resources'];
    for (PermissionSetAssignment psa: pSetAssignmnets) {
        FSL_AddToGroupHandler.AddtoGroup(Trigger.newmap.keyset());
    }
}