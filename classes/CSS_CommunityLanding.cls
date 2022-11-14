/**********************************************************************
Name:CSS_CommunityLanding
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
To display the default landing page when logging in as
community users
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 - Satish           02/17/2016      INITIAL DEVELOPMENT           
2.0 - Anirudh          02/17/2016      Coding Standards 
3.0 - Vignesh          03/02/2017      Added code for the profile CSS_Dealer_Data_ExChange_Admin
***********************************************************************/

public class CSS_CommunityLanding {
    public CSS_CommunityLanding(){}    
    public PageReference redirect() {
        // Query the profile ids
        // Return the appropriate landing page
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        PageReference pageRef;
        
        if (profileName.toUpperCase().contains('TECHNICIAN')) {
            pageRef = new pageReference('/apex/CSS_ST_HOME');
            
        } /*else if (profileName.toUpperCase().contains('SUPERVISOR')) {
            pageRef = new pageReference('/apex/CSS_SS_HOME');
            
        } */else if (profileName.toUpperCase().contains('ADVANCED') || profileName.toUpperCase().contains('DATA_EXCHANGE_ADMIN')) { //85634 - Added for the profile CSS_Dealer_Data_ExChange_Admin
            pageRef = new pageReference('/apex/CSS_SS_HOME');
            
        } /*else if (profileName.toUpperCase().contains('WRITER')) {
            pageRef = new pageReference('/apex/CSS_SW_HOME');
            
        }*/
        return pageRef;
    }
}