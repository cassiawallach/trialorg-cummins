/*
 * Block comments with details of changes
 */
public  virtual  class CG_CL_ClaimsVSDetails {
    public Id cId;
    public CG_CL_ClaimsVS controllerRef {get;set;}
     public String LineItemAC {get;set;}
     public String LineItemClaimId {get;set;}


    //Constructor.
    public CG_CL_ClaimsVSDetails() {
        try {
            system.debug('inside class...');
            cId = ApexPages.CurrentPage().getParameters().get('id');
            system.debug('cId...'+ cId);
            if(cId != null) {
                system.debug('inside class... controllerRef'+controllerRef);
            }
        } catch(Exception ex) {
            system.debug('in the exception of CG_CL_ClaimsVSDetails Line No:>>> '+ex.getLinenumber()+' Message: ' + ex.getmessage());
        }
    }

    //Assign primary Failure values to claimswrapper
    public string primaryFlagClaimID{get;set;}
    public string primaryFlagFailureID{get;set;}
    public void assignPrimaryFailureFlag(){
        system.debug('primaryFlagClaimID>>>'+primaryFlagClaimID);
        system.debug('primaryFlagFailureID>>>'+primaryFlagFailureID);
        for(CG_CL_ClaimsVS.claimWrapperClass clmWrap:controllerRef.lstclaimWrapper){
            if(clmWrap.claimid == primaryFlagClaimID){
                for(CG_CL_ClaimsVS.failureWrapperClass failWrap:clmWrap.failureWrapper){
                    if(failWrap.validationmessage == primaryFlagFailureID){
                        system.debug('in if before'+failWrap.PrimaryFailureFlag);
                        failWrap.PrimaryFailureFlag = true;
                        system.debug('in if after'+failWrap.PrimaryFailureFlag);
                    }else{
                        system.debug('in else before'+failWrap.PrimaryFailureFlag);
                        failWrap.PrimaryFailureFlag = false;
                        system.debug('in else after'+failWrap.PrimaryFailureFlag);
                    }
                }
            }
        }
        system.debug('controllerRef.lstclaimWrapper>>>'+controllerRef.lstclaimWrapper);
    }

    //Naviagation to Failures and Campaigns.
    public PageReference nvFC(){
        PageReference pageRef;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsFC'); 
        }else{
            pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); 
        }
        return pageRef;
    }

    //Naviagation to Multi psn.
    public PageReference nvMPSN(){
        PageReference pageRef;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_Claimsmultipsn'); 
        }else{
            pageRef = new pageReference('/apex/CG_Claimsmultipsn?id='+cId); 
        }
        return pageRef;
    }

    //Naviagation to Job Notes.
   
    public PageReference nvJobNotes(){
        PageReference pageRef;
       
        system.debug('LineItemClaimId ' + LineItemClaimId);
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes'); 
        }else{
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId+'&LineItemClaimId=' +LineItemClaimId); 
        }
        return pageRef;
    }
    //Naviagation to srt.
    public PageReference nvsrts(){
        PageReference pageRef;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsSRTs'); 
        }else{
            pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId); 
        }
        return pageRef;
    }

    //Naviagation to parts.
    public PageReference nvparts(){
        PageReference pageRef;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles'); 
        }else{
            pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId); 
        }
        return pageRef;
    }
}