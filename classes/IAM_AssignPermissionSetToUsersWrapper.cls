/**************************************************************************
Name:  IAM_AssignPermissionSetToUsersWrapper
Copyright © 2022  Cummins
=============================================================
=============================================================
Purpose:Wrapper class for IAM_Assign_Application_Permissionset class

=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -     Souvik Lahiri              24/08/2022        INITIAL DEVELOPMENT 
******************************************************************************/

public class IAM_AssignPermissionSetToUsersWrapper {
    public Set<Id> usersId;
    public id pid;
    public String Action;
    public IAM_AssignPermissionSetToUsersWrapper(Set<Id> usersId,id pid,String Action){
        this.usersId = usersId;
        this.pid = pid;
        this.Action = Action;  
    }
}