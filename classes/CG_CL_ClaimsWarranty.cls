/**********************************************************************
Name:CG_CL_ClaimsWarranty
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
We are using this Page Controller for Warranty Claims Chevron.
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -      Arpita Sarangee   1/22/2018           INITIAL DEVELOPMENT  
1.1        Anvesh Reddy      1/22/2018           Added Naviagtions to other chevrons
1.2        Surender M        02/19/2018          Implementing Warranty Coverage functionality
***********************************************************************/
public class CG_CL_ClaimsWarranty{
    
    public CG_CL_ClaimsWarranty controllerRef{get;set;}
    public Id cId{get;set;}
    public CSS_Claims__c claimsRec{set;get;}
    public CSS_PSN__c psnRec{set;get;}
    public Boolean psncheck {get;set;}
    public List<CSS_Solution_Component__c> solComps;
    public boolean checkAccountCode{get; set;}
    public boolean psnnoapplicable{get; set;}
    public CG_CL_ClaimsWarrantyComp compCont = new CG_CL_ClaimsWarrantyComp();
    //public String mil_measure{set;get;} //need to delete this
    
    //Constructor.
    public CG_CL_ClaimsWarranty()
    {
        psncheck = false;
        checkAccountCode=false;
        solComps = new List<CSS_Solution_Component__c>();
        System.debug('IN CG_CL_ClaimsWarranty constructor...');
        try {
            controllerRef = this;
            cId=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('MyClaimId**'+cId);
            if(cId == null) {
                claimsRec = new CSS_Claims__c();
                psnRec = new CSS_PSN__c();
            } 
            else 
            {  
               
                
                claimsRec =[Select Id,LastSavedDate__c,IsCopyclaim__c,isAutomatedCopyClaim__c,Last_saved_by__c,Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c, ODM_Status__c , FieldActionWebServiceResult__c,Customer_Name__c, warrantyIndicatorFlag__c,SP_REGION__c,SP_TERRITORY__c,Location__c,Location_Code__c,Dealer_Service_Job__r.Name,Pending_Authorization__c,Information_Only_Claim__c,Multi_PSN_Claim__c,CSS_Job__c,CSS_Job__r.name,CSS_Job__r.createddate,Shop_Work_Order__c,CreatedDate,LastModifiedDate,Name,Region__c,Territory__c,CoverageResponse__c,Status__c,
                            (
                             Select Id,Name,PSN__c,ApplicationCode__c,Service_Model__c,Application__c,Make__c,Model__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,
                             Warranty_Start_Date__c,Product_Hours__c,Before_In_Service__c,CoverageFlag__c, CSS_Claims__c,ProductAppcodeErrorflag__c from CSS_PSNs__r where Primary__c=true Limit 1
                            ) 
                            from CSS_Claims__c where id= :cId];
                
                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    psnRec = claimsRec.CSS_PSNs__r.get(0);
                }else
                    psnRec = new CSS_PSN__c(); 
                    system.debug('claimsRec.warrantyIndicatorFlag__c'+claimsRec.warrantyIndicatorFlag__c);
                    //gssc-311
                    if(claimsRec.warrantyIndicatorFlag__c!=null && claimsRec.warrantyIndicatorFlag__c=='N' &&claimsRec.warrantyIndicatorFlag__c!=''){
                        psnnoapplicable =true;
                    }
                    else{
                        psnnoapplicable = false;
                    }
                    //end
                //mil_measure = psnRec.Mileage_Measure__c;  //need to delete this
                system.debug('claimsRec>>>>:'+claimsRec);
                system.debug('claimsRec.Region'+claimsRec.Region__c);
                system.debug('claimsRec.Territory'+claimsRec.Territory__c);
                system.debug('claimsRec.Region'+claimsRec.SP_REGION__c);
                system.debug('claimsRec.Territory'+claimsRec.SP_TERRITORY__c);
                system.debug('psnRec>>>>:'+psnRec);
            }
        }
        catch(Exception e)  
        {
            system.debug('EXCEPTION of CG_CL_ClaimsWarranty constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_ClaimsWarranty constructor...');
//Code to populate Region and territory
        Account RegionTerritory = css_utility.getRegionTerritory((claimsRec ==null ? '': claimsRec.Location_Code__c));
        //System.debug('REGION-R'+RegionTerritory.Region__c);
        //System.debug('REGION-T'+RegionTerritory.Territory__c);
  //****************************************************************Getting Multi-PSN chevron basend on condition from Solution component Object 154239 By RAJESH *****************************************************************************************************                
                if(!Test.isRunningTest()){
                solComps = [select Id, Claim_FailCode__c,Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Account_Formula__c
                            from CSS_Solution_Component__c
                            //where CSS_Claims__c =:claimsRec.id  AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC') AND Selected_Component__c = true) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
        where CSS_Claims__c =:claimsRec.id AND Selected_Component__c = true AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC')) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
                }
                else{
                    solComps = [select Id, Claim_FailCode__c,Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Account_Formula__c
                            from CSS_Solution_Component__c
                            //where CSS_Claims__c =:claimsRec.id  AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC') AND Selected_Component__c = true) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
        where CSS_Claims__c =:claimsRec.id AND Selected_Component__c = true AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC')) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved')) limit 500];
                
                    
                }
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

        }

    
   //Naviagation to Warranty Coverage.
   public PageReference nvClaimsIntake(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        saveClaim();
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsIntake'); 
        }else{
            /*CSS_Claims__c claimsNewRec = new CSS_Claims__c();
            claimsNewRec.id=cid;
            claimsNewRec.Region__C = claimsRec.Region__c;
            claimsNewRec.Territory__c = claimsRec.Territory__c;
            update claimsNewRec;*/
            
            pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);
        }
        return pageRef;
    }
   
   //Naviagation to View History.
    public PageReference nvClaimsVH(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        saveClaim();
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVH'); 
        }else{
            
            pageRef = new pageReference('/apex/CG_ClaimsVH?id='+cId); 
        }
        return pageRef;
    }
    
    //Naviagation to Customer Complaint.
    public PageReference nvClaimsCC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        
        saveClaim();
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsCC'); 
        }else{
            
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                //pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId); Commented to fix defect 190456.
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); 
            }
            //pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); 
        }
        return pageRef;
    }
    
    //Naviagation to Failures and Campaigns.
    public PageReference nvClaimsFC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        
        saveClaim();
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsFC'); 
        }else{
             if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                //pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId); Commented to fix defect 190456.
                return null;
             }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); 
            }
           // pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); 
        }
        return pageRef;
    }
      //Added below Method as per Silicon Valley sprint #154239 -By RAJESH 20th Aug 2018
        public PageReference nvClaimsPSN(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        
        saveClaim();
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsMultiPSN'); 
        }else{
             if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                //pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); Commented to fix defect 190456.
                return null;
             }
            else{
            pageRef = new pageReference('/apex/CG_ClaimsMultiPSN?id='+cId); }
           // pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); 
        }
        return pageRef;
    }
     public void nvClaimsMulti_PSN()
    {
        
    }
    //End
    //Naviagation to Parts and Other Claimbles.
    public PageReference nvClaimsPOC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        saveClaim();
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles'); 
        }else{
             if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                //pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId); Commented to fix defect 190456.
                return null;
             }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId); 
            }
            //pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId); 
        }
        return pageRef;
    }
    
    //Naviagation to SRTs.
    public PageReference nvClaimsSRTs(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        
        saveClaim();
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsSRTs'); 
        }else{
            if(claimsRec.Status__c == 'Submitted' || claimsRec.Pending_Authorization__c =='Not Authorized'){
                //pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId); Commented to fix defect 190456.
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId); 
            }
           // pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId); 
        }
        return pageRef;
    }
    
    //Naviagation to Job Notes.
    public PageReference nvClaimsJobNotes(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        saveClaim();
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes'); 
        }else{
            
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId);
        }
        return pageRef;
    }
    
    //Naviagation to Verify and Submit
    public PageReference nvClaimsVS(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');
        saveClaim();
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVS'); 
        }else{
            
            pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); 
        }
        return pageRef;
    }
    
    //Bottom save button
    public PageReference pgSave()
    {
        PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl());
        saveClaim();
        ReturnPage.setRedirect(true);
        return ReturnPage;
    }
    
    public void saveClaim(){
        String dealer = css_utility.getOrgType(userInfo.getUserID());
        compCont.coverageFlag = true;
        
        // calling FieldAction WebService in case of failure response on chevron navigation
        if(claimsRec.FieldActionWebServiceResult__c == 'Error'){
            string FailureDateString;
            if(psnRec.Failure_Date__c != null){
                FailureDateString = DateTime.newInstance(psnRec.Failure_Date__c.year(),psnRec.Failure_Date__c.month(),psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
            }
            claimsRec.FieldActionWebServiceResult__c = CG_BL_Campaigns.callGetCampaignsWebServiceforClaimsOnChevronChangeClaim(psnRec.PSN__c, FailureDateString, claimsRec.Region__c,'', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', psnRec.CSS_Claims__c);
       }
        
        if(dealer == 'DLR')
        {
           Account RegionTerritory = css_utility.getRegionTerritory((claimsRec ==null ? '': claimsRec.Location_Code__c));
           if(RegionTerritory != null)
           {
            claimsRec.Region__c = RegionTerritory.Region__c;
            claimsRec.Territory__c = RegionTerritory.Territory__c;
            system.debug('Region&Territory--'+claimsRec.Region__c+' '+claimsRec.Territory__c);
            //Region=RegionTerritory.Region__c;
            //Territory=RegionTerritory.Territory__c;
            compCont.coverageSearch();
            }
        }
        if(claimsRec != null)
        update claimsRec;
    }
}