/*************************************************************************************
Name:  IAM_LDAP_Util_ReqParser_moveuser_Reclaim
Copyright © 2019  Cummins
**************************************************************************************
Purpose: This class called from Reclaim, calls LDAP move user API to move user from 
one branch to other
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR             DATE               DETAIL                                
1.0      Nishant Verma        01/16/2020        INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar     27/04/2021        LDAP Sync Issue Fix
**************************************************************************************
**************************************************************************************/
public class IAM_LDAP_Util_ReqParser_moveuser_Reclaim {

    public List<Userinfo> Userinfo;
    public static String IAM_LDAP_moveuser_ReqBody_Reclaim(String username, String email, String branch) {
        String JSONString;
        try {
            Userinfo lstWrapper = new Userinfo(username, email, branch);
            System.debug('Printing request wrapper from Reclaim MoveUser LDAP Service' + lstWrapper);
            if(lstWrapper != null){
                JSONString = JSON.serialize(lstWrapper);
                System.debug('#### Reclaim MoveUser LDAP Service ' + JSONString);
            }
        } catch(Exception e) {
            System.debug('Printing Exception e'+e.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(JSONString, Label.IAM_Identity_LDAP, e.getStackTraceString() + ' - ' + e.getMessage(),IAM_LDAP_Util_ReqParser_moveuser_Reclaim.class.getName());
        }
        return JSONString;
    }
    
    /* Request Wrapper */
    public class Userinfo {
        public String uid;
        public String mail;
        public String branch;        
        public Userinfo(String username, String email, String branch) {
            System.debug('calling the userinfo');
            this.mail = email;
            this.branch = branch;
            this.uid = username;
        }
    }
}