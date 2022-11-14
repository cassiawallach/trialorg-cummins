/**************************************************************************
Name:  IAM_AssignPermissionSetToUsersQueueable
Copyright © 2022  Cummins
=============================================================
=============================================================
Purpose:Queueable class for IAM_Assign_Application_Permissionset class

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -     Souvik Lahiri              24/08/2022        INITIAL DEVELOPMENT 
******************************************************************************/
public without sharing class IAM_AssignPermissionSetToUsersQueueable  implements Queueable{
    public List<IAM_AssignPermissionSetToUsersWrapper> lstAssignPermissionSetToUsersWrapper;    
    Integer startingIndex;    
    public IAM_AssignPermissionSetToUsersQueueable(List<IAM_AssignPermissionSetToUsersWrapper> lstAssignPermissionSetToUsersWrapper) {
        this.lstAssignPermissionSetToUsersWrapper = lstAssignPermissionSetToUsersWrapper;
        this.startingIndex = 0;
    }
    public void execute(QueueableContext context) {
        Set<Id> usersId;
        Id pid;
        String Action;
        List<IAM_AssignPermissionSetToUsersWrapper> lstPendingAssignPermissionSetToUsersWrapper = lstAssignPermissionSetToUsersWrapper;        
        IAM_AssignPermissionSetToUsersWrapper AssignPermissionSetToUsersWrapperToProcess = lstPendingAssignPermissionSetToUsersWrapper.remove(startingIndex);
        try {                        
            usersId = AssignPermissionSetToUsersWrapperToProcess.usersId;
            pid =   AssignPermissionSetToUsersWrapperToProcess.pid;
            Action =  AssignPermissionSetToUsersWrapperToProcess.Action;            
            String copareId = pid;
            System.debug('begin AssignPermissionSetToUsers.......'+usersId + 'pid... '+pid+' Action... ' + Action); 
            List<PermissionSetAssignment> lstPemisionIds = [select PermissionSet.id from PermissionSetAssignment where Assignee.Id =:usersId];
            System.debug('Permission set list lstPemisionIds.......'+lstPemisionIds);   
            Set<PermissionSetAssignment> setPemisionIds = new Set<PermissionSetAssignment>();
            if(!lstPemisionIds.isEmpty()){
                setPemisionIds.addAll(lstPemisionIds);
                lstPemisionIds.clear();
                lstPemisionIds.addAll(setPemisionIds);
            }
            System.debug('Permission set list remove dulicate lstPemisionIds.......'+lstPemisionIds);   
            if(Action=='Insert'){
                List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();                
                if(!usersId.isEmpty()){
                    for (User u : [Select Id, Name FROM User Where Id IN: usersId]){ // Add fields as per your requirement...
                        boolean isNewPerm = true;
                        for(PermissionSetAssignment permisionId : lstPemisionIds){
                            String perId = permisionId.PermissionSet.id;
                            if(!Test.isRunningTest()){
                                if(copareId.equalsIgnoreCase(perId)){
                                    isNewPerm = false;
                                    System.debug('Printing isNewPerm details .....'+isNewPerm);
                                }
                            }else{
                                isNewPerm=false;
                            }
                        }
                        if(isNewPerm){
                            permissionSetList.add(new PermissionSetAssignment (PermissionSetId = pid, AssigneeId = u.Id));
                        }
                    }                    
                    System.debug('Permission set list that is going to updated......'+permissionSetList);
                    Database.SaveResult[] saveResult=DataBase.Insert(permissionSetList,false); //Changing the Insert statement to DataBase.Insert
                } 
            }  
            //part where delete of permision sets need to written
            if(Action == 'Delete'){
                List <PermissionSetAssignment> ps=[SELECT Id from PermissionSetAssignment WHERE PermissionSetId = : pid AND AssigneeId = : usersId];
                system.debug('Printing User details and permissionsset assaignment that are going to get delete '+ps);
                Delete ps;
            }    
        } catch(Exception e) {
            System.debug('#### Exception Message - ' + e.getMessage());
            String processedData = 'User Ids - ' + usersId + ' Permission Set Id - ' + pid + ' Action - ' + Action;
            IAM_ErrorHandling.IAMerrorCapture(processedData, 'AssignPermissionSetToUsers', e.getStackTraceString() + ' - ' + e.getMessage(), IAM_Assign_Application_Permissionset.class.getName());
        }
        if(lstPendingAssignPermissionSetToUsersWrapper.size() > 0 && !Test.isRunningTest()){
            System.enqueueJob(new IAM_AssignPermissionSetToUsersQueueable(lstPendingAssignPermissionSetToUsersWrapper));
        }
    }
}