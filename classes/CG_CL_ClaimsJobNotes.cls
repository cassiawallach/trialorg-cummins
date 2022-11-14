/**********************************************************************
Name:CG_CL_ClaimsJobNotes
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
We are using this Page Controller for Warranty Claims Job Notes Chevron.
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -      Surender M        02/12/2018          Added Constructor & Updated Navigations
***********************************************************************/
public class CG_CL_ClaimsJobNotes
{
    public CG_CL_ClaimsJobNotes controllerRef{set;get;}
    public String editCorrection{get;set;}
    public Id cId{get;set;}
    public CSS_Claims__c claimsRec{set;get;}
    public CSS_PSN__c psnRec{set;get;}
    public Boolean psncheck {get;set;}
    public Boolean checkAccountCode {get;set;}
    public List<CSS_Solution_Component__c> solComps;
    public List<CSS_Solution_Component__c> solCompsNew;
    //Constructor.
    public CG_CL_ClaimsJobNotes()
    {
        System.debug('IN CG_CL_ClaimsJobNotes constructor...');
        try {
            psncheck = false;
            checkAccountCode=false;
            solComps = new List<CSS_Solution_Component__c>();
            controllerRef = this;
            cId=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('MyClaimId**'+cId);

            if(cId == null) {
                claimsRec = new CSS_Claims__c();  
                psnRec = new CSS_PSN__c();
            } else {    
                claimsRec =[Select Id,LastSavedDate__c,IsCopyclaim__c,isAutomatedCopyClaim__c,Last_saved_by__c,Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c,ODM_Status__c,Customer_Name__c,EditCorrection__c,Dealer_Service_Job__r.Name,Location__c,FieldActionWebServiceResult__c,Pending_Authorization__c,Information_Only_Claim__c,Multi_PSN_Claim__c,Location_Code__c,CSS_Job__c,CSS_Job__r.CreatedDate, CSS_Job__r.name,Shop_Work_Order__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,CoverageResponse__c, Status__c,
                            (Select Id,Name,PSN__c,Service_Model__c,Application__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,
                             Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, Before_In_Service__c, Make__c, Model__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                            from CSS_Claims__c where id= :cId];
                //****************************************************************Getting Multi-PSN chevron basend on condition from Solution component Object 154239 By RAJESH *****************************************************************************************************                
                solComps = [select Id, Claim_FailCode__c,Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Account_Formula__c
                            from CSS_Solution_Component__c
                            //where CSS_Claims__c =:claimsRec.id  AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC') AND Selected_Component__c = true) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
                            where CSS_Claims__c =:claimsRec.id AND Selected_Component__c = true AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC')) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
                for(css_solution_component__c SC: solComps){
                    if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                        checkAccountCode=true;
                    }
                }
                system.debug('solComps.size()****8'+solComps);
                if(claimsRec!=null && claimsRec.id!=null && checkAccountCode==true){
                    if(claimsRec.Multi_PSN_Claim__c== true)
                    {
                        psncheck = true;
                    }else{
                        psncheck = false;
                    }
                }
                //**************************************************************************END 154239 ************************************************************************************8                 

                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    psnRec = claimsRec.CSS_PSNs__r.get(0);
                }else
                    psnRec = new CSS_PSN__c(); 
                
                
            }
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsJobNotes constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_ClaimsJobNotes constructor...');
    }
    //Commented as part of the defect GSSC-423
    public void clmJobNotesAction(){
        
         
               
    }

    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsIntake(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsIntake'); 
        }else{

            pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); 
        }
        CampaignsWSCall();
        return pageRef;
    }

    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsWC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
      if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsWarranty'); 
        }else{

            pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId); 
        }
        CampaignsWSCall();
        return pageRef;
    }

    //Naviagation to View History.
    public PageReference nvClaimsVH(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
       if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVH'); 
        }else{

            pageRef = new pageReference('/apex/CG_ClaimsVH?id='+cId); 
        }
        CampaignsWSCall();
        return pageRef;
    }

    //Naviagation to Customer Complaint.
    public PageReference nvClaimsCC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsCC'); 
        }else{
            //Kalpana Defect 154159 fix. Added below if condition
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId); }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); }
        }
        CampaignsWSCall();
        return pageRef;
    }

    //Naviagation to Failures and Campaigns.
    public PageReference nvClaimsFC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsFC'); 
        }else{
            //Kalpana Defect 154159 fix. Added below if condition
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId); }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId);}
        }
        CampaignsWSCall();
        return pageRef;
    }
    //Added below Method as per Silicon Valley sprint #154239 -By RAJESH 20th Aug 2018 
    public PageReference nvClaimsPSN(){
        PageReference pageRef;     
        if(cId==null){            
            pageRef = new pageReference('/apex/CG_ClaimsMultiPSN'); 
        }else{
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){ 
                pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId); }
            else{                
                pageRef = new pageReference('/apex/CG_ClaimsMultiPSN?id='+cId); }
        }
        CampaignsWSCall();
        return pageRef;
    }

    //Naviagation to Parts and Other Claimbles.
    public PageReference nvClaimsPOC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
         if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles'); 
        }else{
            //Kalpana Defect 154159 fix. Added below if condition
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId); }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId); }
        }
        CampaignsWSCall();
        return pageRef;
    }

    //Naviagation to SRTs.
    public PageReference nvClaimsSRTs(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
         if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsSRTs'); 
        }else{
            //Kalpana Defect 154159 fix. Added below if condition
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId); }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId); }
        }
        CampaignsWSCall();
        return pageRef;
    }

    //Naviagation to Job Notes.
    public PageReference nvClaimsJobNotes(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
         if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes'); 
        }else{

            pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId);
        }
        CampaignsWSCall();
        return pageRef;
    }

    //Naviagation to Verify and Submit
    public PageReference nvClaimsVS(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
         if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVS'); 
        }else{

            pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); 
        }
        CampaignsWSCall();
        return pageRef;
    }
    
    public void CampaignsWSCall(){
        // calling FieldAction WebService in case of failure response on chevron navigation
        if(claimsRec.FieldActionWebServiceResult__c == 'Error'){
            string FailureDateString;
            if(psnRec.Failure_Date__c != null){
                FailureDateString = DateTime.newInstance(psnRec.Failure_Date__c.year(),psnRec.Failure_Date__c.month(),psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
            }
            claimsRec.FieldActionWebServiceResult__c = CG_BL_Campaigns.callGetCampaignsWebServiceforClaimsOnChevronChangeClaim(psnRec.PSN__c, FailureDateString, claimsRec.Region__c,'', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', psnRec.CSS_Claims__c);
    		claimsRec.Id = cId;
    		if(claimsRec.Id != null){
    		    update claimsRec; 
    		}
       }
    }


    //Bottom save button 
    /*public PageReference pgSave()
    {
        PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl());
        ReturnPage.setRedirect(true);
        return ReturnPage;
    }*/

    /*public void saveClaim(Id claimId){
        CSS_Claims__c claimNewRec = new CSS_Claims__c();
        claimNewRec.Id = claimId;
        claimNewRec.EditCorrection__c = editCorrection;
        update claimNewRec;        
    }*/
}