/*****************************************************************************
Name:CG_CL_Standard_Header2                                                   
Copyright Â© 2018  Cummins                                                   
==============================================================================

Purpose: We are using this Page Controller for CSS_Standard_Header2          
To check claim enable is true for user to display the claims Tab.    
-------                                                                      
==============================================================================
History                                                                      
-------                                                                      
VERSION  AUTHOR                          DATE                DETAIL                                
1.0 -    Miruthula Kanagaraj          5/17/2018          INITIAL DEVELOPMENT 

*******************************************************************************/


public class CG_CL_Standard_Header2 {
    
    public boolean displayLink {get;set;}
    public User usr{get;set;}
    public Boolean Profilecheck { get; set; }
    
    public CG_CL_Standard_Header2(){
        // Added Profile check by Priyanka for Ct1-641
        String profileId = UserInfo.getProfileId();
        Profile profile = [SELECT Id, Name FROM Profile WHERE Id =:profileId];
        system.debug('profile>>>>>>>>>>'+profile.Name);
        if(profile.Name == 'EVL_Dealer_Advanced' || profile.Name == 'EVL_Dealer_Technician' || profile.Name == 'EVL_Dealer_Readonly'){
            Profilecheck = true;
        }
        else{
            Profilecheck = false;
        }
        usr = [select id,name,DefaultCurrencyIsoCode,isClaimReadOnly__c from user where id=:userinfo.getUserId() Limit 1];
        displayLink = css_utility.getclaimsapprove(UserInfo.getUserId());
        /*if(css_utility.getclaimsapprove(UserInfo.getUserId()))
        {
            displayLink = true;
            
        }
        
        if(css_utility.getOrgType(UserInfo.getUserId()) == 'DLR' && css_utility.getclaimsapprove(UserInfo.getUserId()))
        {
            displayLink = true;
        }*/
    }
    public PageReference redirectAction(){
        PageReference pageRef;
        system.debug('usr-->'+usr);
        try{
        if(usr.isClaimReadOnly__c==true){
        pageRef = new pageReference('/apex/CG_MyClaims'); 
        pageRef.setRedirect(true);
        
      }else{
          pageRef = new pageReference('/apex/CG_CreateClaims'); 
          pageRef.setRedirect(true);
          
      }
        }
        catch (exception e){
            system.debug('e.errormessage'+e.getmessage());
        }
         return pageRef;
  }
    
   public PageReference redirectglobal(){
     PageReference pageRef = new pageReference('/apex/CSS_globalSearch?srch='+Apexpages.currentPage().getParameters().get('srctxt')+'&sFilter='+Apexpages.currentPage().getParameters().get('secvalue'));
     pageRef.setRedirect(true);
     return pageRef;
  }

}