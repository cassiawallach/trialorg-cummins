public with sharing class OSM_SW_AccountPermissionMatrix_Ctrl {
    public String jsonData {get; set;}
    public OSM_SW_AccountPermissionMatrix_Ctrl() {
        jsonData = '{}';
        try {
            OSM_SW_AccountPermMatrixHelper.UserPermissions permissions = new OSM_SW_AccountPermMatrixHelper.UserPermissions();
            if (UserInfo.getUserType() != 'Guest') {
                ccrz.cc_CallContext.initRemoteContext(new ccrz.cc_RemoteActionContext());
                Id accountId = ccrz.cc_CallContext.currAccountId;
                Boolean isOnBehalf = ccrz.cc_CallContext.isOnBehalf;
                Contact currContact = ccrz.cc_CallContext.currContact;
                Id effAccountId = ccrz.cc_CallContext.effAccountId;
                permissions = OSM_SW_AccountPermMatrixHelper.getAccountPermissions(accountId,isOnBehalf,currContact,effAccountId);
                if (permissions != null) {
                    jsonData = JSON.serialize(permissions);
                }
            }
        }
        catch (Exception e) {
            System.debug(System.LoggingLevel.ERROR, e.getMessage());
        }
    }
}