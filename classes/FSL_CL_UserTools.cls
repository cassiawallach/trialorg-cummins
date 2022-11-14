public class FSL_CL_UserTools {
    
    //start: updated by Trupthi, NIN-47 Date:2/21/2022 - 
     @AuraEnabled
    public static String getSessionPSN()
    {        
        User usr = [SELECT Id, UserRole.name, Profile.name FROM user WHERE id=:userInfo.getUserId() LIMIT 1];
        string psnValuetop;

            if (usr.Profile.name == 'EVL_Dealer_Advanced'|| usr.Profile.name == 'EVL_Dealer_Technician'||usr.UserRole.name == 'Factory') 
            {     
                 psnValuetop = (string) Cache.Session.get('local.CSSPartition.SessionSoPSN');   
            }  
        return psnValuetop;
    }
    //updated by Trupthi, NIN-47 Date:2/21/2022 -END 

}