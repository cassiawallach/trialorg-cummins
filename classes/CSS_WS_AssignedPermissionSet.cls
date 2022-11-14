Global class CSS_WS_AssignedPermissionSet{

    WebService static boolean PermissionSetName(String permission_set_name){
        List<PermissionSetAssignment> permission_set_list = new List<PermissionSetAssignment>();
        permission_set_list = [SELECT Id, PermissionSet.Name FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId() AND PermissionSet.Name =: permission_set_name];
        if(permission_set_list.size() > 0){
            return true;
        } else {
            return false;
        }
    }

}