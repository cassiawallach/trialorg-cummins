public class CG_CL_claimsSRT 
{
    
    public ID cId{get;set;}
    
    public CSS_Claims__c claimsRec{get;set;}
    public CG_CL_ClaimsIntake mainContr{get;set;}
    public String pageRef{get;set;}
    public boolean isClaimEnabled {get;set;}
    public CG_CL_claimsSRT()
    {
        cId = ApexPages.CurrentPage().getParameters().get('id');
        
        if(cId != null)
        {
            claimsRec = [Select id,PACCAR_Flag__c,CSS_Job__c,Dealer_Service_Job__c,PACCAR_Auth_Required__c,Parts_Warranty_Claim_Only__c,Status__c,Actual_Technician_Time__c,Pending_Authorization__c  FROM CSS_Claims__c WHERE Id = :cId LIMIT 1];
        }
        system.debug('Claims Record ---->>' + claimsRec);
        isClaimEnabled = css_utility.getclaimsapprove(UserInfo.getUserId());
    }
    
    public PageReference save()
    {
        PageReference page;
        try{
            if(claimsRec != null){
                claimsRec.Actual_Technician_Time__c = mainContr.claimsRec.Actual_Technician_Time__c;
                update claimsRec;
            }
        }catch(Exception e) { 
            system.debug(e.getMessage());
        }
        if(cId != null)
        {
            //PageReference page = new Pagereference('/apex/CG_ClaimsSRTs?id='+claimsRec.Id);
            page = new Pagereference(pageRef);
        }else{
            page = new Pagereference('/apex/CG_ClaimsSRTs');
        }
        
        page.setRedirect(true);
        return page;
        
    }
    
}