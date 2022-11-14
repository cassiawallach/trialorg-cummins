/**********************************************************************
Name:CG_CL_ClaimsSRTs
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
We are using this Page Controller for Warranty Claims SRTs Chevron.
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -      Abhishek Rajput   1/22/2018           INITIAL DEVELOPMENT  
1.1        Anvesh Reddy      1/22/2018           Added Naviagtions to other chevrons
1.1 -      Surender M        02/12/2018          Added Constructor, Updated Navigations, Overlap/Mutual SRTs & Extended Hours logic
***********************************************************************/
public class CG_CL_ClaimsSRTs{
    
    public CG_CL_ClaimsSRTs controllerRef{get;set;}
    public Id cId{get;set;}
    public boolean mileageProdHrsError{get;set;}
    //public CSS_Claims__c claimsTotalSRTHrs {get;set;}Commented as part of defect
    public CSS_Claims__c claimsTotalSRT;
    public decimal claimsTotalSRTHrs {get;set;}
    public CSS_Claims__c claimsRec{set;get;}
    public CSS_PSN__c psnRec{set;get;}
    public String techtime{set;get;}
    public decimal TotalSRTHrs {get; set;}
    CSS_OverlapSRTReq overlapSRTREq;
    public CSS_Claims__c claimsOverlap{get; set;}
    public map<string,CSS_SRT__c> mapStepIdtoSrt;
    public boolean showErrorPopup{get;set;}
    public String pageName;
    public boolean isClaimEnabled {get;set;}
    public Boolean psncheck {get;set;}
    public List<CSS_Solution_Component__c> solComps;
    public boolean checkAccountCode{get; set;}
    public transient List<CSS_Solution_Component__c> compList = new List<CSS_Solution_Component__c>();
    public Boolean dealerLocation{get; set;}
    List<String> dupSRTMsg = new List<String>();
    public static list<CG_ODM_ResJSONParser.message> ODMSRTChevronDisplayMsgs{get;set;}
    public String fieldActionStatus;
    public List<CSS_JobEventTemporary__c> jobEventTemp;
    //Constructor.
    public CG_CL_ClaimsSRTs()
    {
        System.debug('IN CG_CL_ClaimsSRTs constructor...');
        try {
            psncheck = false;
            checkAccountCode=false;
            controllerRef = this;
            cId=ApexPages.CurrentPage().getParameters().get('id');
            solComps = new List<CSS_Solution_Component__c>();
            isClaimEnabled = css_utility.getclaimsapprove(UserInfo.getUserId());
            system.debug('MyClaimId**'+cId);
            if(cId == null) {
                claimsRec = new CSS_Claims__c();  
                psnRec = new CSS_PSN__c();
            } else {    
                claimsRec =[Select Id,LastSavedDate__c,IsCopyclaim__c,isAutomatedCopyClaim__c,Last_saved_by__c,Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c, ODM_Status__c, Status__c,IsDealerCreatedClaim__c,FieldActionWebServiceResult__c,Dealer_Service_Job__c,DuplicateSRTDetails__c,Catastrophic__c,Customer_Name__c,Account__r.RSS_RESP_BRANCH_CODE__c,Dealer_Service_Job__r.Name,Actual_Technician_Time__c,Information_Only_Claim__c,ProductApplicationCode__c,Account__c, Location__c,
                            Multi_PSN_Claim__c,Mutual_Exclusive_Message__c,SRT_Olap_Reason_Msg__c,SP_WarrantyCertificationEndDate__c, SP_PrimaryOEMCode__c,Location_Code__c,CSS_Job__c,CSS_Job__r.name,CSS_Job__r.CreatedDate,Shop_Work_Order__c,LastModifiedDate,
                            Name, ESN__c, createdDate,Region__c,Territory__c,CoverageResponse__c,ODM_Penalty__c,TotalSRTExtendedHours__c,DupAccessCodePercentReqMsg__c,
                            (Select Id,License_Plate_State__c,ApplicationCode__c,Name,PSN__c,Service_Model__c,Application__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,Before_In_Service__c,Make__c,Model__c,
                             Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c,Equipment_ID__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                            from CSS_Claims__c where id= :cId];
                
                //****************************************************************Getting Multi-PSN chevron basend on condition from Solution component Object 154239 By RAJESH *****************************************************************************************************                
                
                compList = [select id,Type__c,Status__c,AccountCode__c, fail_code__c,FailCode_Formula__c,Covered_Labor__c,ODM_Penalty__c,CSS_Account_Formula__c,CoveredLaborHrs__c,CampaignLaborPercentage__c,Component_Id__c,Service_Job__c,Selected_Component__c from css_solution_component__C where css_claims__c = :cId];
                
                //solComps = [select Id, Claim_FailCode__c,Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Account_Formula__c
                            //from CSS_Solution_Component__c
                            //where CSS_Claims__c =:claimsRec.id  AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC') AND Selected_Component__c = true) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
                            //where CSS_Claims__c =:claimsRec.id AND Selected_Component__c = true AND ((Type__c NOT IN ('TSB','TRP','Campaign','ATC')) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved'))]; 
                for(css_solution_component__c SC: compList){
                    if(SC.Selected_Component__c == true && ((SC.Type__c != 'TSB' && SC.Type__c != 'TRP' && SC.Type__c != 'Campaign' && SC.Type__c != 'ATC') || ((SC.Type__c == 'Campaign' || SC.Type__c == 'ATC') && SC.Status__c=='Approved'))){
                        system.debug('insideIf%%%');
                        if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
                            checkAccountCode=true;
                        }
                    }
                }
                system.debug('****checkAccountCode***'+checkAccountCode);
                system.debug('****claimsRec.catastrophic__c***'+claimsRec.catastrophic__c);
                system.debug('solComps.size()****8'+compList);
                if(claimsRec!=null && claimsRec.id!=null && checkAccountCode==true){
                    if(claimsRec.Multi_PSN_Claim__c== true)
                    {
                        psncheck = true;
                    }else{
                        psncheck = false;
                    }
                }
                //**************************************************************************END 154239 ************************************************************************************8                 
                
                if(claimsRec.Actual_Technician_Time__c != null)
                    techtime = string.valueOf(claimsRec.Actual_Technician_Time__c);
                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    psnRec = claimsRec.CSS_PSNs__r.get(0);
                }else
                    psnRec = new CSS_PSN__c(); 
                system.debug('claimsRec>>>>:'+claimsRec);
                system.debug('psnRec>>>>:'+psnRec);
                system.debug('techtime ' + techtime + '---- ' + claimsRec.Actual_Technician_Time__c);
                system.debug('TotalSRTExtendedHours__c  --> ' +claimsRec.TotalSRTExtendedHours__c);
                // below code for checking dealer location from utility class as per story #179802 Alladin  sprint,-By RAJESH 05 Apr 2019
                if(cId!=null && claimsRec!=null){
                    string claimLocation=claimsRec.Location_Code__c;
                    system.debug('claimLocation****:'+claimLocation);
                    if(claimLocation!=null){
                        String locationcode = css_Utility.dealerUserLocation(claimLocation);
                        if(locationcode!=null && locationcode!='' ){
                            if(locationcode=='true')
                                dealerLocation=true;
                            else
                                dealerLocation=false;
                        }
                    }
                }
                //End
                
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c IN ('POL','NPW','RPW')];
                system.debug('jobEventTemp****'+jobEventTemp);
            }
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsSRTs constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_ClaimsSRTs constructor...');
    }
    
    
    
    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsIntake(){
        PageReference pageRef;
        pageName='CG_ClaimsIntake';
        system.debug('Cid>>:'+cId);
        //cId = saveClaim(cId, 'Draft');
        
        //showErrorPopup=true;
        if(cId==null){
            system.debug('22 Cid>>:'+cId);
            pageRef = new pageReference('/apex/CG_ClaimsIntake'); 
        }
        else{
            if(getOlapReasonMsgFlag() || (claimsRec.DupAccessCodePercentReqMsg__c !=null && claimsRec.DupAccessCodePercentReqMsg__c.trim() !='') )
                return null;
            system.debug('Before calling ODM Cid>>:'+cId);
            //Method to call ODM webservice validation service
            // showErrorPopup = CG_BL_ODM.callODMSRTServices('Claim',cId);
            
            //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
            /****************************************************************************************************************************/
            //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
            Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
            
            List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
            
            if(orgtype==true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
            {
                system.debug('Information_Only_Claim__c is******' +claimsRec.Information_Only_Claim__c);
                system.debug('claimsRec.CSS_Job__c is****' + claimsRec.CSS_Job__c);
                IF(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null) )
                {
                    showErrorPopup = false;
                }
                else//Else go ahead and do ODM validation
                {
                    showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                    ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
                }       
            }
            else////Distributor eligible for automated and manual claim
            {
                showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
            }
            /***********************************************************************************************************************************************************/
            system.debug('After calling ODM showErrorPopup>>:'+showErrorPopup);
            if(showErrorPopup==true)
            {
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); 
            }
            if(fieldActionsLst != null && fieldActionsLst.size() > 0){
                insert fieldActionsLst;
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        return pageRef;
    }
    
    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsWC(){
        PageReference pageRef;
        pageName='CG_ClaimsWarranty';
        //cId = saveClaim(cId, 'Draft');
        
        //showErrorPopup=true;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsWarranty'); 
        }else{
            if(getOlapReasonMsgFlag() || (claimsRec.DupAccessCodePercentReqMsg__c !=null && claimsRec.DupAccessCodePercentReqMsg__c.trim() !='') )
                return null;
            //Method to call ODM webservice validation service
            // showErrorPopup = CG_BL_ODM.callODMSRTServices('Claim',cId);
            //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
            /****************************************************************************************************************************/
          //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
            Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
            
            List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
            
            if(orgtype==true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
            {
                IF(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null) )
                {
                    showErrorPopup = false;
                }
                else//Else go ahead and do ODM validation
                {
                    showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                    ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
                }       
            }
            else////Distributor eligible for automated and manual claim
            {
                showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
            }
            /***********************************************************************************************************************************************************/
            if(showErrorPopup==true)
            {
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId); 
            }
            if(fieldActionsLst != null && fieldActionsLst.size() > 0){
                insert fieldActionsLst;
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        return pageRef;
    }
    
    //Naviagation to View History.
    public PageReference nvClaimsVH(){
        PageReference pageRef;
        pageName='CG_ClaimsVH';
        //cId = saveClaim(cId, 'Draft');
        
        //showErrorPopup=true;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVH'); 
        }else{
            if(getOlapReasonMsgFlag() || (claimsRec.DupAccessCodePercentReqMsg__c !=null && claimsRec.DupAccessCodePercentReqMsg__c.trim() !='') )
                return null;
            //Method to call ODM webservice validation service
            // showErrorPopup = CG_BL_ODM.callODMSRTServices('Claim',cId);
            //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
            /****************************************************************************************************************************/
           //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
            Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
            List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
            
            if(orgtype==true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
            {
                IF(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null) )
                {
                    showErrorPopup = false;
                }
                else//Else go ahead and do ODM validation
                {
                    showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                    ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
                }       
            }
            else////Distributor eligible for automated and manual claim
            {
                showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
            }
            /***********************************************************************************************************************************************************/
            
            if(showErrorPopup==true)
            {
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsVH?id='+cId); 
            }
            if(fieldActionsLst != null && fieldActionsLst.size() > 0){
                insert fieldActionsLst;
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        return pageRef;
    }
    
    //Naviagation to Customer Complaint.
    public PageReference nvClaimsCC(){
        PageReference pageRef;
        pageName='CG_ClaimsCC';
        //cId = saveClaim(cId, 'Draft');
        
        
        //showErrorPopup=true;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsCC'); 
        }else{
            if(getOlapReasonMsgFlag() || (claimsRec.DupAccessCodePercentReqMsg__c !=null && claimsRec.DupAccessCodePercentReqMsg__c.trim() !='') )
                return null;
            //Method to call ODM webservice validation service
            // showErrorPopup = CG_BL_ODM.callODMSRTServices('Claim',cId);
            //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
            /****************************************************************************************************************************/
            //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
            Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
            
            List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
            
            if(orgtype==true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
            {
                IF(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null) )
                {
                    showErrorPopup = false;
                }
                else//Else go ahead and do ODM validation
                {
                    showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                    ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
                }       
            }
            else////Distributor eligible for automated and manual claim
            {
                showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
            }
            /***********************************************************************************************************************************************************/
            if(showErrorPopup==true)
            {
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); 
            }
            if(fieldActionsLst != null && fieldActionsLst.size() > 0){
                insert fieldActionsLst;
            }   
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        return pageRef;
    }
    
    //Naviagation to Failures and Campaigns.
    public PageReference nvClaimsFC(){
        PageReference pageRef;
        pageName='CG_ClaimsFC';
        //cId = saveClaim(cId, 'Draft');
        
        //showErrorPopup=true;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsFC'); 
        }else{
            if(getOlapReasonMsgFlag() || (claimsRec.DupAccessCodePercentReqMsg__c !=null && claimsRec.DupAccessCodePercentReqMsg__c.trim() !='') )
                return null;
            //Method to call ODM webservice validation service
            // showErrorPopup = CG_BL_ODM.callODMSRTServices('Claim',cId);
            //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
            Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
            
            List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
            
            if(orgtype==true)
            {
                IF(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null) )
                {
                    showErrorPopup = false;
                }
                else
                {
                    showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                    ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
                }       
            }
            else{
                //Distributor logic written in CG_BL_ODM class.
                showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
            }
            
            if(showErrorPopup==true)
            {
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); 
            }
            if(fieldActionsLst != null && fieldActionsLst.size() > 0){
                insert fieldActionsLst;
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        return pageRef;
    }
    //Added below Method as per Silicon Valley sprint #154239 -By RAJESH 20th Aug 2018 
    public PageReference nvClaimsPSN(){
        PageReference pageRef; 
        pageName='CG_ClaimsMultiPSN';
        if(cId==null){            
            pageRef = new pageReference('/apex/CG_ClaimsMultiPSN'); 
        }else{
            if(getOlapReasonMsgFlag() || (claimsRec.DupAccessCodePercentReqMsg__c !=null && claimsRec.DupAccessCodePercentReqMsg__c.trim() !='') )
                return null;
            //Method to call ODM webservice validation service
            // showErrorPopup = CG_BL_ODM.callODMSRTServices('Claim',cId);
            //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
            /****************************************************************************************************************************/
            //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
            Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
            List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
            
            if(orgtype==true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
            {
                IF(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null) )
                {
                    showErrorPopup = false;
                }
                else//Else go ahead and do ODM validation
                {
                    showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                    ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
                }       
            }
            else////Distributor eligible for automated and manual claim
            {
                showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
            }
            /***********************************************************************************************************************************************************/
            if(showErrorPopup==true)
            {
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsMultiPSN?id='+cId); 
            }
            if(fieldActionsLst != null && fieldActionsLst.size() > 0){
                insert fieldActionsLst;
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        return pageRef;        
    }
    
    //Naviagation to Parts and Other Claimbles.
    public PageReference nvClaimsPOC(){
        PageReference pageRef;
        pageName='CG_ClaimsPartsandOtherClaimbles';
        //cId = saveClaim(cId, 'Draft');
        
        //showErrorPopup=true;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles'); 
        }else{
            if(getOlapReasonMsgFlag() || (claimsRec.DupAccessCodePercentReqMsg__c !=null && claimsRec.DupAccessCodePercentReqMsg__c.trim() !='') )
                return null;
            //Method to call ODM webservice validation service
            // showErrorPopup = CG_BL_ODM.callODMSRTServices('Claim',cId);
            //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
            /****************************************************************************************************************************/
            //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
            Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
            
            List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
            
            if(orgtype==true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
            {
                IF(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null) )
                {
                    showErrorPopup = false;
                }
                else//Else go ahead and do ODM validation
                {
                    showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                    ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
                }       
            }
            else////Distributor eligible for automated and manual claim
            {
                showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
            }
            /***********************************************************************************************************************************************************/
            System.debug('showErrorPopup$$$$$$$$$$'+showErrorPopup);
            if(showErrorPopup==true)
            {
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId); 
            }
            if(fieldActionsLst != null && fieldActionsLst.size() > 0){
                insert fieldActionsLst;
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        return pageRef;
    }
    
    //Naviagation to SRTs.
    public PageReference nvClaimsSRTs(){
        PageReference pageRef;
        pageName='CG_ClaimsSRTs';
        //cId = saveClaim(cId, 'Draft');
        
        //showErrorPopup=true;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsSRTs'); 
        }else{
            if(getOlapReasonMsgFlag() || (claimsRec.DupAccessCodePercentReqMsg__c !=null && claimsRec.DupAccessCodePercentReqMsg__c.trim() !='') )
                return null;
            //Method to call ODM webservice validation service
            // showErrorPopup = CG_BL_ODM.callODMSRTServices('Claim',cId);
            //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
            /****************************************************************************************************************************/
            //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
            Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
            
            List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
            
            if(orgtype==true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
            {
                IF(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null) )
                {
                    showErrorPopup = false;
                }
                else//Else go ahead and do ODM validation
                {
                    showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                    ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
                }       
            }
            else////Distributor eligible for automated and manual claim
            {
                showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
            }
            /***********************************************************************************************************************************************************/
            if(showErrorPopup==true)
            {
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId); 
            }
            if(fieldActionsLst != null && fieldActionsLst.size() > 0){
                insert fieldActionsLst;
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
       // update claimsRec;
        return pageRef;
    }
    
    //Naviagation to Job Notes.
    public PageReference nvClaimsJobNotes(){
        system.debug('nvClaimsJobNotes');
        PageReference pageRef;
        pageName='CG_ClaimsJobNotes';
        //cId = saveClaim(cId, 'Draft');
        
        //showErrorPopup=true;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes'); 
        }else{
            if(getOlapReasonMsgFlag() || (claimsRec.DupAccessCodePercentReqMsg__c !=null && claimsRec.DupAccessCodePercentReqMsg__c.trim() !='') )
                return null;
            //Method to call ODM webservice validation service
            // showErrorPopup = CG_BL_ODM.callODMSRTServices('Claim',cId);
            //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
            /****************************************************************************************************************************/
            //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
            Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
            List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
            
            if(orgtype==true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
            {
                IF(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null) )
                {
                    showErrorPopup = false;
                }
                else//Else go ahead and do ODM validation
                {
                    showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                    ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
                }       
            }
            else////Distributor eligible for automated and manual claim
            {
                showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
            }
            /***********************************************************************************************************************************************************/
            if(showErrorPopup==true)
            {
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId); 
            }
            if(fieldActionsLst != null && fieldActionsLst.size() > 0){
                insert fieldActionsLst;
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        return pageRef;
    }
    
    //Naviagation to Verify and Submit
    public PageReference nvClaimsVS(){
        PageReference pageRef;
        pageName='CG_ClaimsVS';
        //cId = saveClaim(cId, 'Draft');
        
        //showErrorPopup=true;
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVS'); 
        }else{
            if(getOlapReasonMsgFlag() || (claimsRec.DupAccessCodePercentReqMsg__c !=null && claimsRec.DupAccessCodePercentReqMsg__c.trim() !='') )
                return null;
            //Method to call ODM webservice validation service
            // showErrorPopup = CG_BL_ODM.callODMSRTServices('Claim',cId);
            //155918:when the Info Only check box is selected then run only the required ODM services to submit the claim to Siebel’(func)/
            /****************************************************************************************************************************/
            //String orgtype=css_utility.getOrgType(userinfo.getUserId());//TO find the distributor of dealer from profile//Commented by Anirudh to get the Account's type and not logged in user's type
            Boolean orgtype = claimsRec.IsDealerCreatedClaim__c;
            List<CSS_Solution_Component__c> fieldActionsLst = CampaignsWSCall(); // CampaignsWSCall call out in case of service failure
            if(orgtype==true)//Dealers will not be eligible for information only automated claims, so check for manual claim only
            {
                IF(claimsRec.Information_Only_Claim__c!=null && claimsRec.Information_Only_Claim__c==true && (claimsRec.CSS_Job__c==null) )
                {
                    showErrorPopup = false;
                }
                else//Else go ahead and do ODM validation
                {
                    showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                    ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
                }       
            }
            else////Distributor eligible for automated and manual claim
            {
                showErrorPopup =  CG_BL_ODM.callODMSRTServices('Claim',cId);
                ODMSRTChevronDisplayMsgs = CG_BL_ODM.returnODMSRTMessages();
            }
            /***********************************************************************************************************************************************************/
            
            if(showErrorPopup==true)
            {
                return null;
            }
            else{
                pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); 
            }
            if(fieldActionsLst != null && fieldActionsLst.size() > 0){
                insert fieldActionsLst;
            }
        }
        //Commented the below update as it is not used and its overwriting ODM status update at claims level in CG_BL_ODM class
        //update claimsRec;
        return pageRef;
    }
    
    public List<CSS_Solution_Component__c> CampaignsWSCall(){
        // calling FieldAction WebService in case of failure response on chevron navigation
        try{
            system.debug('CampaignsWSCall >>' + claimsRec.FieldActionWebServiceResult__c);
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            if(claimsRec.FieldActionWebServiceResult__c == 'Error'){
                string FailureDateString;
                if(psnRec.Failure_Date__c != null){
                    FailureDateString = DateTime.newInstance(psnRec.Failure_Date__c.year(),psnRec.Failure_Date__c.month(),psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                }
                HttpResponse httpRes;
                httpRes = CG_BL_Campaigns.callGetCampaignsWSforClaimsRetrigger(psnRec.PSN__c, FailureDateString, claimsRec.Region__c,'', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', psnRec.CSS_Claims__c);
                system.debug('****httpRes****'+httpRes);
                
                if(httpRes == null || httpRes.getStatusCode() != 200){
                    fieldActionStatus = 'Error';
                }
                else if(httpRes != null && httpRes.getStatusCode() == 200){
                    fieldActionStatus = 'Success';
                    CG_OP_CampaignsResJSON outputRes = new CG_OP_CampaignsResJSON();
                    if(!Test.isRunningTest()){
                        system.debug('****httpRes****getBody'+httpRes.getBody());
                        outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(httpRes.getBody(), CG_OP_CampaignsResJSON.class);
                        system.debug('outputRes**'+outputRes);
                            }
                    else{
                        //String sampleOutput = '{ '+ '\"DataArea\": { '+ '\"InShopLaborRate\": \"19.06\", '+ '\"FieldServiceLaborRate\": \"19.06\", '+ '\"Region\": \"INTERNATIONAL\", '+ '\"ChannelCode\": \"110\", '+ '\"TravelRate\": \"0.37\", '+ '\"Territory\": \"CHINA\", '+ '\"ChannelOfDistribution\": \"110-DEALER\" '+ '}, '+ '\"Header\": {\"Status\": \"Success\"} '+ '}';
                         String sampleOutput = '{ "DataArea": { "Details": [ { "CampaignDesc": "TRP FOR MCRS FUEL PUMP FAILURES TO INSTALL EPLV SYSTEM ON ENGINES", "CampaignEndDate": "2017-12-31", "CampaignStartDate": "2016-08-23", "SrtList": [ { "SrtCode": "00-901-00", "SrtDescription": "Administrative Time - Open and Close Repair Order (Shop Repairs)" } ], "FailCode": "WFHA", "FailMode": "SR", "InShopSrtLimitFlag": "N", "Status": "Approved", "MultipleTimes": "N", "BusinessUnit": "CMI", "CampaignType": "TRP", "CompleteIndicator": "N", "PartList": [ { "PartQuantity": 1, "PartNumber": 540571400, "PartDescription": "KIT,SERVICE" } ], "CampaignNumber": "1820" } ] }, "Header": { "ReturnCodeDescription": "ReturnCodeDescription", "Status": "Success" } }';
                        outputRes = (CG_OP_CampaignsResJSON)JSON.deserializeStrict(sampleOutput, CG_OP_CampaignsResJSON.class);
                    }

                    list<CG_BL_Campaigns.CampaignsWrapper> CampaignsWrapperList = new list<CG_BL_Campaigns.CampaignsWrapper>();
                    
                    if(outputRes.DataArea != null){
                        system.debug('outputRes.DataArea ' + outputRes.DataArea);
                        List<CSS_Parts_Options__c> partsOptionList;
                        Id recTypeId = [SELECT Id FROM RecordType WHERE Name =: 'Parts'].Id;
                        Map<String,List<CSS_Parts_Options__c>> wsDataMap = new Map<String,List<CSS_Parts_Options__c>>();
                        
                        system.debug('claimsRec'+claimsRec);
                        
                        for(CG_OP_CampaignsResJSON.Details det : outputRes.DataArea.Details){
                            system.debug('det.Status ' + det.Status);
                            //Here check Siebel Campaigns are meeting required criteria
                            if(det.Status != 'Approved' || (det.CompleteIndicator =='Y' && det.MultipleTimes=='N') )
                                continue;
                            if(det.Status == 'Approved' ){
                                CSS_Solution_Component__c campaignComp = new CSS_Solution_Component__c();
                                if(det.InShopSrtLimitFlag == 'Y'){
                                    campaignComp.In_Shop_SRT_Limit_Flag__c = true;
                                }
                                else{
                                    campaignComp.In_Shop_SRT_Limit_Flag__c = false;
                                }
                                campaignComp.Campaign_Description__c = det.CampaignDesc; 
                                if(det.CampaignEndDate != null && det.CampaignEndDate != ''){
                                    campaignComp.Campaign_End_Date__c = date.valueof(det.CampaignEndDate);
                                }
                                if(det.CampaignStartDate != null && det.CampaignStartDate != ''){
                                    campaignComp.Campaign_Start_Date__c = date.valueof(det.CampaignStartDate);
                                }
                                if(det.CampaignNumber != null){
                                    campaignComp.Component_Id__c = string.valueof(det.CampaignNumber);
                                }
                                campaignComp.Failure_Mode__c = det.FailMode;
                                if(det.FailCode != null && det.FailCode != ''){
                                    campaignComp.System_Code__c = (det.FailCode).substring(0,2);
                                    campaignComp.Component_Code__c = (det.FailCode).substring(2);
                                }
                                campaignComp.Status__c = det.Status;
                                if(det.MultipleTimes == 'Y'){
                                    campaignComp.Multiple_Times__c = true;
                                }
                                else{
                                    campaignComp.Multiple_Times__c = false;
                                }
                                campaignComp.Business_Unit__c = det.BusinessUnit;
                                campaignComp.Type__c = det.CampaignType;
                                campaignComp.Name = det.CampaignType+' '+det.CampaignNumber;
                                campaignComp.Status__c = det.Status;
                                if(det.CompleteIndicator == 'Y'){
                                    campaignComp.Complete_Indicator__c = true;
                                }
                                else{
                                    campaignComp.Complete_Indicator__c = false;
                                }
                                campaignComp.css_claims__c = cId; 
                                
                                //calling detail coverage as per story 184437 to check coverage before fieldaction insert
                                
                                CSS_Solution_Component__c comp = new CSS_Solution_Component__c();
                                comp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,String.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,campaignComp.System_Code__c,campaignComp.Component_Code__c,'','',null,false,campaignComp.Component_Id__c,'','Second Call', claimsRec.ReconEngineFlag__c,false,claimsRec.Name);
                                if(comp != null){  
                                    System.debug('comp****' + comp);
                                    system.debug('comp.AccountCode__c'+comp.AccountCode__c);
                                    if(comp.AccountCode__c!=null && comp.AccountCode__c!=''){
                                        solCompList.add(campaignComp);
                                        system.debug('campaignComp ' + campaignComp);
                                    }
                                }
                            }
                        }
                        
                        //Delete old saved solution comp & parts data for the job
                        /*List<CSS_Solution_Component__c> solCompListTemp = new List<CSS_Solution_Component__c>([Select Id from CSS_Solution_Component__c where css_claims__c=:cId and Type__c in ('CAMPAIGN','TRP','ATC')]);                

if(solCompListTemp !=null && solCompListTemp.size()>0){
List<CSS_Parts_Options__c> partsListTemp = new List<CSS_Parts_Options__c>([Select Id, Name from CSS_Parts_Options__c where CSS_Claims__c=:cId and RecordTypeId=:recTypeId and FailurepartId__c in :solCompListTemp]);                     
System.debug('partsListTemp>>>:'+partsListTemp);
if(partsListTemp !=null && partsListTemp.size() > 0)
delete partsListTemp; 
List<CSS_SRT__c> srtsListTemp = new List<CSS_SRT__c>([Select Id from CSS_SRT__c where CSS_Claims__c =: cId and (Type__c = 'Field Action' OR Type__c = 'Field Action Access')]);
if(srtsListTemp != null && srtsListTemp.size() > 0)
delete srtsListTemp; 
delete solCompListTemp;
}*/
                        
                        if(solCompList !=null && solCompList.size() > 0){
                            for(CSS_Solution_Component__c sc : solCompList) {
                                CampaignsWrapperList.add(new CG_BL_Campaigns.CampaignsWrapper(cId,sc.System_Code__c,sc.Component_Code__c,sc.Id,sc.Component_Id__c,sc.Selected_Component__c));     
                            }
                        }
                        system.debug('solCompList'+solCompList.size());
                        system.debug('solCompList-->'+solCompList);
                        
                        system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );
                        system.debug('START QUEUEABLE SOLUTION COMPONENT');
                        system.debug('Claims**CampaignsWrapperList ' + CampaignsWrapperList);
                        ID jobIDs = System.enqueueJob(new CG_ClaimsQueueable(CampaignsWrapperList));
                        System.debug('END QUEUEABLE SOLUTION COMPONENT');
                        system.debug(' Limits.getQueueableJobs()  >>> ' +  Limits.getQueueableJobs() );
                        
                    }      
                }
                
            }
            
            
            return solCompList;
        }
        catch(Exception ex){
            system.debug('Exception in CampaignsWSCall method  ex.getMessages()' + ex.getmessage() + 'ex.getLineNumber ' + ex.getLineNumber() );
            return null;
        }
        
    }
    
    //Bottom save button 
    /*public PageReference pgSave()
{
system.debug('****insidepgSave****');
showErrorPopup = true;
if(showErrorPopup == false){
PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl());
ReturnPage.setRedirect(true);
return ReturnPage;
}
else
return null;
}*/
    
    public PageReference resolveErrorNow()
    {
        PageReference pageRef;
        showErrorPopup = false;
        pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference continueNext()
    {
        PageReference pageRef;
        if(pageName != '' && pageName !=null){
            if(cId==null){
                pageRef = new pageReference('/apex/'+pageName); 
            }else{
                pageRef = new pageReference('/apex/'+pageName+'?id='+cId); 
            }
            return pageRef;
        }
        else
            return null;
    }
    
    
    
    public void populateMap(CSS_Claims__c claimRecord){
        mapStepIdtoSrt = new map<string,CSS_SRT__c>();
        system.debug('serviceJob.CSS_SRTS__r-->'+claimRecord.CSS_SRTS__r);
        for(CSS_SRT__c srt : claimRecord.CSS_SRTS__r){
            mapStepIdtoSrt.put(srt.Step_Id__c, srt);
        }
        
    }
    
    //Tech Save button
    public pagereference saveTechTime() {
        try {
            PageReference pageRef;
            String sDestURL = ApexPages.currentPage().getUrl().substring(0,ApexPages.currentPage().getUrl().indexOf('?',0)+1);
            if(cId != null){
                claimsRec.Actual_Technician_Time__c = (techtime != null && techtime != '') ? Decimal.valueOf(techtime) : null;
                update claimsRec;
                pageRef = new PageReference(sDestURL+'id='+cId); 
            } else {
                pageRef = new PageReference(sDestURL); 
            }
            system.debug('sDestURL' + sDestURL);
            pageRef.setRedirect(true);
            return pageRef;
        } catch(Exception ex) {
            System.debug('in catch of saveTechTime>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return null;
    }
    
    
    //New Code
    List<CSS_SRT__c> lstSRTinsert = new List<CSS_SRT__c>();
    Map<String, Map<String,List<CSS_SRT__c>>> acCodeSRTCountListMap = new Map<String, Map<String,List<CSS_SRT__c>>>();
    Map<String,List<CSS_SRT__c>> srtCountListMap = new Map<String,List<CSS_SRT__c>>();
    Map<String,List<CSS_SRT__c>> accountCodeWithSRTMap = new Map<String,List<CSS_SRT__c>>();
    //Map<String, Map<String,Integer>> acCodeSRTCountMap = new Map<String, Map<String,Integer>>();
    //Map<String,Integer> srtCountMap = new Map<String,Integer>();
    List<CSS_SRT__c> srtList = new List<CSS_SRT__c>();
    Set<String> overlapSRTIdsSet = new Set<String>();
    //Set<String> queriedSRTIds = new Set<String>();
    
    public void claimsSRTAction(){
        List<CSS_SRT__c> selectedSRTList;
        List<CSS_SRT__c> deleteOverlapSRTList;
        try{
            
            selectedSRTList = new List<CSS_SRT__c>();
            deleteOverlapSRTList = new List<CSS_SRT__c>();
            //This query is modified to fecth ALL SRTs as below && below query data is passed to other methods to reduce queries & 
            //please don't change it & don't manipulate this query
            srtList = new List<CSS_SRT__c>([Select Id,Step_Id__c,SRT_ID__c,SRT_Title__c,FailCode__c,Account_Code__c,Account_Code_Description__c,AccountCode_Formula__c,SRT_Notes__c,SRT_Quantity__c,SRT_Warrantable__c,Access_Code__c,Access_Code_Saved__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,
                                            SRT_Category__c,isPopupSRT__c,Diag_Access_Time__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Access_Calculated__c, Extended_Hours__c, SRT_Time__c, 
                                            Calculated_Claimed_Hours__c, SRT_Time_Formula__c,Override__c,OverrideReason__c,Override_Reason__c,Overlap__c, Overlap_Step_Id__c,Adjusted_Overlap_Hours__c, Overlap_SRT_Number__c,
                                            Solution_Number__c, Solution_Number__r.Diagnostic_Response__c,Component_Id__c,Assignment__c,Component_Id__r.Type__c,
                                            Component_Id__r.Performed_Review__c,Component_Id__r.Status__c,Component_Id__r.Complete_Indicator__c,Component_Id__r.Multiple_Times__c,
                                            isUserEntered__c,Type__c, SRT_Type__c, isPerformed__c, SRT_AccessiblityCheck__c, Flex_Flag__c, CSS_Claims__r.AccessCode__c, CSS_Claims__r.Name, Job_Order__c,Job_Order__r.AccessCode__c, Job_Order__r.Name from css_srt__c where CSS_Claims__c =: cId and SRT_ID__c !=null and SRT_ID__c !='0' ]);
            system.debug('claimsSRTAction loading***srtList size:'+srtList.size());
            system.debug('claimsSRTAction srtList**'+srtList);
            system.debug('claimsRec.TotalSRTExtendedHours__c;****'+claimsRec.TotalSRTExtendedHours__c);
            
            //147392 - map SRT with Account Code START & Data Lists Preparation
            List<CSS_SRT__c> tempList = new List<CSS_SRT__c>();
            for(CSS_SRT__c srtToOvLp : srtList){
                //Blank out all existing flags
                if(srtToOvLp.Type__c != 'Overlap'){
                    srtToOvLp.Access_Code_Flag__c = false;
                    srtToOvLp.SRT_Warrantable_Flag__c = false;
                    tempList.add(srtToOvLp);
                }
                
                //Preparation of Overlap existing records list
                if(srtToOvLp.Type__c == 'Overlap'){
                    deleteOverlapSRTList.add(srtToOvLp);
                }
                
                //Preparation of selected records list for Mutual Exclusive Service
                if(srtToOvLp.SRT_AccessiblityCheck__c == true || srtToOvLp.isPerformed__c == true) {
                	selectedSRTList.add(srtToOvLp);
                }
                
                //Below code for preparation of Overlap Map with individual account code
                //Only for Selected SRTs & No Flex SRTs
                if(srtToOvLp.Flex_Flag__c != true && (srtToOvLp.SRT_AccessiblityCheck__c == true || srtToOvLp.isPerformed__c == true)){
                    
                    String tempAccCode = '';
                    if(srtToOvLp.Account_Code__c == null || srtToOvLp.Account_Code__c == 'Select One'){
                        tempAccCode = 'Customer Billable';
                    }
                    else
                        tempAccCode = srtToOvLp.Account_Code__c;
                    
                    //Step1: Preparing acCodeSRTCountListMap -- SRT List with SRTId based and then SRTs with AccountCode based Map
                    if(acCodeSRTCountListMap.containskey(tempAccCode)){
                        Map<String,List<CSS_SRT__c>> srtCountListMap = acCodeSRTCountListMap.get(tempAccCode);
                        if(srtCountListMap.containskey(srtToOvLp.Step_Id__c)){
                            //acCodeSRTCountListMap.get(srtToOvLp.SRT_ID__c).add(srtToOvLp);
                            List<CSS_SRT__c> tSRTList = srtCountListMap.get(srtToOvLp.Step_Id__c);
                            tSRTList.add(srtToOvLp);
                            srtCountListMap.put(srtToOvLp.Step_Id__c, tSRTList);
                            acCodeSRTCountListMap.put(tempAccCode, srtCountListMap);
                        }else{
                            //srtCountListMap = new Map<String,List<CSS_SRT__c>>();
                            srtCountListMap.put(srtToOvLp.Step_Id__c, new List<CSS_srt__c>{srtToOvLp});
                            acCodeSRTCountListMap.put(tempAccCode, srtCountListMap);
                        }
                    }else{
                        srtCountListMap = new Map<String,List<CSS_SRT__c>>();
                        srtCountListMap.put(srtToOvLp.Step_Id__c, new List<CSS_srt__c>{srtToOvLp});
                        acCodeSRTCountListMap.put(tempAccCode, srtCountListMap);
                    }
                    //queriedSRTIds.add(tempAccCode+'-'+srtToOvLp.Step_Id__c);
                    
                    //Step2: Preparing accountCodeWithSRTMap 
                    if(!accountCodeWithSRTMap.containskey(tempAccCode)){
                        accountCodeWithSRTMap.put(tempAccCode,new List<CSS_srt__c>{srtToOvLp});
                    }
                    else{
                        accountCodeWithSRTMap.get(tempAccCode).add(srtToOvLp);
                    }
                }
            }
            //147392 - map SRT with Account Code END
            system.debug('selectedSRTList>>>:'+selectedSRTList.size());
            system.debug('deleteOverlapSRTList>>>:'+deleteOverlapSRTList.size());
            
            //story - 166107
            set<Id> FAIdSet = new set<Id>();
            //commneted below query and added in contructor to reduce query for 101 SOQL issue
            //compList = [SELECT Id, Component_Id__c,FailCode_Formula__c,CSS_Account_Formula__c, Type__c, CampaignLaborPercentage__c FROM CSS_Solution_Component__c WHERE (Type__c = 'ATC' OR Type__c = 'Campaign' OR Type__c = 'TRP') AND Service_Job__c=null and  CSS_Claims__c =:cId and Selected_Component__c = : true];
            system.debug('claimsSRTAction compList:'+compList);
            
            for(CSS_Solution_Component__c solcomp : compList){ 
                if((solcomp.Type__c == 'ATC' || solcomp.Type__c == 'Campaign' || solcomp.Type__c == 'TRP') && solcomp.Service_Job__c==null && solcomp.Selected_Component__c == true){
                    FAIdSet.add(solcomp.Id);
                }
            }
                
            
            //Field Action SRT callout
            /*List<CSS_SRT__c> srtsListTemp = new List<CSS_SRT__c>([Select Id from CSS_SRT__c where Component_Id__c IN : FAIdSet AND Job_Order__c = null and  CSS_Claims__c =:cId and (Type__c = 'Field Action' OR Type__c = 'Field Action Access')]);          
system.debug('claimsSRTAction srtsListTemp:'+srtsListTemp);
if(srtsListTemp != null && srtsListTemp.size()==0)
CG_BL_Campaigns.callFieldActionSRTClaims(compList,cId);*/
            
            //Overlap & Mutual services execution in below method
            //147392 - Send SRT for OverLap Check 
            claimsRec.Overlap_Service_Failure_Msg__c = ''; //Blank out Error Message in the beginning & update it if it gets msg from service
            claimsRec.Mutual_Exclusive_Message__c = ''; //Blank out Error Message in the beginning & update it if it gets msg from service
            claimsRec.DupAccessCodePercentReqMsg__c = ''; //Blank out Error Message in the beginning & update it if it gets msg from service
            createOverlapSRT(accountCodeWithSRTMap,selectedSRTList,deleteOverlapSRTList);    
            
            //Do ALL DMLs here after ALL webservices execution completed
            try{
                system.debug('tempList**'+tempList);
                //Blank out all existing flags
                update tempList; 
                tempList = null;
                
                //Updating Quantity & %Requested for SRTs 00-901,00-902-00,00-904-00
                if(claimsRec !=null && claimsRec.id !=null && claimsRec.Multi_PSN_Claim__c)
                    updateSRTs();
            }catch(Exception ex){
                System.debug('in catch of srtListToFCACUpd update of CSS_JobPlanSRTController>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            }
            system.debug('*****Before method claimsRec.TotalSRTExtendedHours__c;****'+claimsRec.TotalSRTExtendedHours__c);
            //update %Req with Penalty if applicable,else populates %Req based on Coverage
            updateSRTPercReq(srtList);
            system.debug('****kalAfterUpdatePenalty**'+srtList);
            
            //calculate ExtendedHours logic should be called here after calling Overlaps
            //calculateExtendedHours(srtList); //This method is now being called at the end updateSRTPercReq
            system.debug('*****after method claimsRec.TotalSRTExtendedHours__c;****'+claimsRec.TotalSRTExtendedHours__c);
            
            //Check Duplicate SRTs story 148920
           // checkDuplicateSRTs();//Commented as part of defect fix GSSC 509 and moved the same inside updateSRTPercReq method
            //system.debug('****kal**'+srtList);
            //Duplicate Access Code & %Requested logic here
            //The below method should run after all SRTs are inserted/updated to find duplicates
            //buildDuplicateAccessCodesLogic(srtList);//Commented as part of defect fix GSSC 509 and moved the same inside updateSRTPercReq method
            //system.debug('****kalAfter**'+srtList);
            
            
            // below code for calling  covLimitValidationSRT Method as per story #179802 Aladdin sprint,-By RAJESH 02 Apr 2019 
            if(((claimsRec.CSS_Job__c != null || claimsRec.Dealer_Service_Job__c != null) && dealerLocation==true ) || (claimsRec.CSS_Job__c == null || claimsRec.Dealer_Service_Job__c == null)){
                CG_CL_CoverageLimitExceedValidation callingSRTClaimedHour= new CG_CL_CoverageLimitExceedValidation();
                system.debug('****class called above method****');
                callingSRTClaimedHour.covLimitValidationSRT(null,cId);
                system.debug('****called above method****');
                callingSRTClaimedHour.covLimitfailcodeValidation (null,cId);
            }
            // End code for calling  covLimitValidationSRT Method as per story #179802 Aladdin sprint,-By RAJESH 02 Apr 2019*/
            /*claimsTotalSRT = new CSS_Claims__c();
claimsTotalSRT =[select id,TotalSRTExtendedHours__c from CSS_Claims__c where id= :cId];
claimsTotalSRTHrs=claimsTotalSRT.TotalSRTExtendedHours__c;
system.debug('******claimsTotalSRTHrs'+claimsTotalSRTHrs);*/
            system.debug('******Kalpana TotalSRTHrs'+claimsRec.TotalSRTExtendedHours__c);
            //Finally update Claim with SRT errorMsgs or with any other updates finally here in a single shot.
            if(claimsRec !=null)
                update claimsRec;
            //below code is for SRT Totals Defect Kalpana
            List<CSS_SRT__c> lstSRTclaim = new List<CSS_SRT__c>();
            List<CSS_SRT__C> SRTHrsExtendedClaims;
            if(cId!=null){
                SRTHrsExtendedClaims = new List<CSS_SRT__c>([Select id, Extended_Hours__c,SRT_AccessiblityCheck__c,type__c,Job_Order__c, Solution_Number__c ,SRT_Category__c,isPerformed__c,Flex_Flag__c,SRT_Time__c
                                                             from CSS_SRT__c where CSS_Claims__c =: cId AND
                                                             (((isPerformed__c=true OR SRT_AccessiblityCheck__c=true) AND Type__c NOT IN ('Campaign','ATC','TRP','Overlap','Field Action')) 
                                                              OR ( isPerformed__c=true AND Component_Id__r.Selected_Component__c=true AND Component_Id__r.Type__c IN ('Campaign','ATC','TRP')))]);
                system.debug('Trigger Query Initail SRTHrsExtendedClaims>>' + SRTHrsExtendedClaims);
            }
            
            if(SRTHrsExtendedClaims!=null){ // && SRTHrsExtendedClaims.size() > 0
                lstSRTclaim.addAll(SRTHrsExtendedClaims);
            }
            //system.debug('**lstSRTclaim size**'+lstSRTclaim.size());
            if(lstSRTclaim != null) // && lstSRTclaim.size()>0
                CG_CL_TotalSRTHoursCalculation.CalcualteExthrs(null, lstSRTclaim, null, cId);
            claimsTotalSRT = new CSS_Claims__c();
            claimsTotalSRT =[select id,TotalSRTExtendedHours__c from CSS_Claims__c where id= :cId];
            claimsTotalSRTHrs=claimsTotalSRT.TotalSRTExtendedHours__c;
            system.debug('******claimsTotalSRTHrs'+claimsTotalSRTHrs);   
            
            
        }catch(Exception ex){
            System.debug('in catch of jobPlanSRTAction of CSS_JobPlanSRTController>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
    //147392 -  function to create Overlap records
    //List<CSS_SRT__c> deleteOverlapSRTList = new List<CSS_SRT__c>();
    Map<String,Decimal> olapAdjHrsMap = new Map<String,Decimal>();
    Map<String,String> olapReasonMap = new Map<String,String>();
    Map<String,String> olapReasonPickMap = new Map<String,String>();
    Boolean isOverlapServiceFailed = false;
    public void createOverlapSRT(Map<String,List<CSS_SRT__c>> accountCodeWithSRTMap, List<CSS_SRT__c> selectedSRTList, List<CSS_SRT__c> deleteOverlapSRTList){
        try{
            //Preparing Delete SRT List
            //List<CSS_SRT__c> deleteOverlapSRTList = new List<CSS_SRT__c>([SELECT Id, Account_Code__c, SRT_ID__c, Step_Id__c, Overlap_Step_Id__c, Override__c, Adjusted_Overlap_Hours__c, Overlap_SRT_Number__c,OverrideReason__c,Override_Reason__c FROM CSS_SRT__c WHERE Type__c = 'Overlap' and CSS_Claims__c =: cId and Account_Code__c !=null]);                
            System.debug('existing deleteOverlapSRTList>>:'+deleteOverlapSRTList.size());
            if(deleteOverlapSRTList.size()>0){
                for(CSS_SRT__c olsrt : deleteOverlapSRTList){
                    //also check here Unselected SRTs/Quantity changed SRTs/Deleted SRTs
                    if(olsrt.Override__c){
                        System.debug('olsrt.Account_Code__c>>:'+olsrt.Account_Code__c+'olsrt.Step_Id__c>>:'+olsrt.Step_Id__c+'olsrt.Overlap_Step_Id__c>>:'+olsrt.Overlap_Step_Id__c);
                        olapAdjHrsMap.put(olsrt.Account_Code__c+'-'+olsrt.Step_Id__c+'-'+olsrt.Overlap_Step_Id__c, olsrt.Adjusted_Overlap_Hours__c);
                        olapReasonMap.put(olsrt.Account_Code__c+'-'+olsrt.Step_Id__c+'-'+olsrt.Overlap_Step_Id__c, olsrt.OverrideReason__c);
                        olapReasonPickMap.put(olsrt.Account_Code__c+'-'+olsrt.Step_Id__c+'-'+olsrt.Overlap_Step_Id__c, olsrt.Override_Reason__c);
                    }
                    //if(olsrt.Account_Code__c!=null && !queriedSRTIds.contains(olsrt.Account_Code__c+'-'+olsrt.Step_Id__c)){
                    //deleteOverlapSRTList.add(olsrt);
                    //}
                }
            }
            
            lstSRTinsert = new List<CSS_SRT__c>();
            if(accountCodeWithSRTMap.size()>0){
                for(String accountCode : accountCodeWithSRTMap.keySet()){
                    System.debug('in overlap call accountCode>>:'+accountCode);
                    if(accountCodeWithSRTMap.get(accountCode).size()>0){
                        List<CSS_SRT__c> lstSRTinsertTemp = overlapSRTCallout(accountCode,accountCodeWithSRTMap.get(accountCode)); 
                        system.debug('accountCode>>:'+accountCode+' lstSRTinsertTemp size>>:'+lstSRTinsertTemp.size()+' isOverlapServiceFailed>:'+isOverlapServiceFailed);
                        if(isOverlapServiceFailed){
                            claimsRec.Overlap_Service_Failure_Msg__c = Label.CG_Unable_to_retrieve_Overlap_SRT_Information_Please_contact_support_by_LiveChat;
                            return; //Return here bcz of service failure & shouldn't delete user entered Adjusted Olap Hours of existing Overlap records
                        }
                        if(lstSRTinsertTemp.size() > 0){
                            lstSRTinsert.addAll(lstSRTinsertTemp);
                            system.debug('lstSRTinsert size>>:'+lstSRTinsert.size());
                        }
                    }   
                }
            }
            if(!isOverlapServiceFailed){
                claimsRec.Overlap_Service_Failure_Msg__c = ''; //Blank out Olap error when it is success
            }
            system.debug('lstSRTinsert--'+lstSRTinsert);
            
            //Mutual Overlap service execution
            if(selectedSRTList.size()>0 && !isOverlapServiceFailed)
                mutualOverlapSRTCallout(selectedSRTList);
            
            //Deleting Overlap existing records
            if(deleteOverlapSRTList.size() > 0)
                delete deleteOverlapSRTList;
            if(lstSRTinsert.size() > 0){
                insert lstSRTinsert;
            }
            system.debug('after insert -->'+lstSRTinsert.size());
            
        }catch(Exception ex){
            System.debug('in catch of createOverlapSRT of CSS_JobPlanSRTController>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
    //147392 -  function to make callout for Overlap
    public List<CSS_SRT__c> overlapSRTCallout(String accCode,List<CSS_SRT__c> srtList){
        system.debug('in overlapSRTCallout method...');
        List<CSS_SRT__c> lstSRTins = new List<CSS_SRT__c>();
        try{
            //System.debug('accCode>>:'+accCode+'srtList>:'+srtList);
            if(srtList ==null){
                return lstSRTins;
            }else{
                System.debug('accCode>>:'+accCode+'srtList size>:'+srtList.size());
            }
            
            CSS_OverlapSRTReq overlapSRTREq = new CSS_OverlapSRTReq();
            List<CSS_SRT__c> overlapSRT = new List<CSS_SRT__c>();
            //system.debug('jobID.Id'+workJob.Id);
            
            User u = css_utility.getUserAttributes(userinfo.getUserId()); 
            string lang = u.LanguageLocaleKey;
            datetime systemDate = System.now();
            string sysdt = systemDate.format('YYYY-MM-dd') +'T00:00:00';        
            
            //Create the JSON request
            CSS_OverlapSRTReq.Header headerDeatail = new CSS_OverlapSRTReq.Header();
            CSS_OverlapSRTReq.Sender sendeDetail = new CSS_OverlapSRTReq.Sender();
            sendeDetail.ServiceName = 'GetOverlapSRT';
            sendeDetail.SenderID = 'CSS-Service';
            headerDeatail.Sender = sendeDetail;
            
            CSS_OverlapSRTReq.Target  targetDetail = new CSS_OverlapSRTReq.Target();
            targetDetail.TargetID = 'SRT';
            headerDeatail.Target = targetDetail;
            
            list<CSS_OverlapSRTReq.Steps> stepsrt1 = new list<CSS_OverlapSRTReq.Steps>();
            //loop through SRT List to send it for overlap check
            if(srtList != null && !srtList.isEmpty()){
                Set<String> stepIdsSet = new Set<String>();
                for(CSS_SRT__c srtrc: srtList){
                    if(srtrc.Step_Id__c !=null && srtrc.Step_Id__c !='0' && (srtrc.SRT_AccessiblityCheck__c == true || srtrc.isPerformed__c == true) ){
                        System.debug('srtrc.Step_Id__c>>:'+srtrc.Step_Id__c+' stepIdsSet>>:'+stepIdsSet);
                        if(!stepIdsSet.contains(srtrc.Step_Id__c)){
                            CSS_OverlapSRTReq.Steps stepsrt = new CSS_OverlapSRTReq.Steps();
                            if(srtrc.Step_Id__c != '0'){
                                stepsrt.StepId = integer.valueof(srtrc.Step_Id__c);
                                //system.debug('checking step id'+stepsrt.StepId );
                                
                                if(srtrc.SRT_Quantity__c != null){ 
                                    stepsrt.Qty = srtrc.SRT_Quantity__c.intvalue();
                                }
                                //system.debug('Quantity'+stepsrt.Qty);
                                if(srtrc.Access_Code__c != null){
                                    stepsrt.AccessCode = srtrc.Access_Code__c;
                                }else{
                                    stepsrt.AccessCode = srtrc.CSS_Claims__r.AccessCode__c; // if srt record's access code is blank, then taking Access code from job level.
                                }
                                stepsrt1.add(stepsrt);
                                stepIdsSet.add(srtrc.Step_Id__c);
                            }
                        }else{
                            //System.debug('else srtrc.Step_Id__c>>:'+srtrc.Step_Id__c);
                            for(CSS_OverlapSRTReq.Steps stepsObj :stepsrt1){
                                if(stepsObj.StepId == Integer.valueof(srtrc.Step_Id__c)){
                                    //System.debug('else stepsObj>>:'+stepsObj);
                                    stepsObj.Qty = stepsObj.Qty + (srtrc.SRT_Quantity__c !=null? srtrc.SRT_Quantity__c.intvalue():0);
                                }
                            }
                        }
                    }
                }    
                system.debug('List size'+stepsrt1.size());  
            }
            
            CSS_OverlapSRTReq.DataArea dtarea = new CSS_OverlapSRTReq.DataArea();
            dtarea.JobID = srtList.size()>0?srtList[0].Job_Order__r.Name:''; //Sai:103959 8/3 : Changed the serviceJob.id to serviceJob.Name to hold the CSS Job number.
            if(dtarea.JobID == null)
                dtarea.JobID = '';
            dtarea.ClaimID = srtList.size()>0?srtList[0].CSS_Claims__r.Name:'';
            dtarea.Languagecode = lang;
            dtarea.DTTimestamp = sysdt;
            dtarea.EffectiveDTTime = sysdt;
            dtarea.ProcessOption = 'OVERLAP'; //MUT_EX/OVERLAP
            dtarea.Steps = stepsrt1;
            overlapSRTREq.DataArea = dtarea;
            overlapSRTREq.Header = headerDeatail;
            system.debug('***overlapSRTREq--->'+overlapSRTREq);
            
            if(!srtList.isEmpty()){
                //Callout for overlap
                CSS_OverlapSRTResponse overlapresponse = CSS_WS_SRT.getOverlapSRTRecords(overlapSRTREq);
                //sampleHardCodedRes = '{"DataArea":{"MutualExMessage":"","TotalOverlapHours":2.6,"Steps":[{"Qty":1,"OverlapTime":[{"SRTNumber":"","OverlapHrs":0}],"SRTHours":1,"SRTAdjustedHours":1,"StepId":119986,"AccessCode":"B"},{"Qty":1,"OverlapTime":[{"SRTNumber":"11-036-00","OverlapHrs":0.4}],"SRTHours":0.5,"SRTAdjustedHours":0.1,"StepId":119989,"AccessCode":"B"},{"Qty":1,"OverlapTime":[{"SRTNumber":"","OverlapHrs":0}],"SRTHours":0,"SRTAdjustedHours":0,"StepId":84694,"AccessCode":"B"},{"Qty":1,"OverlapTime":[{"SRTNumber":"","OverlapHrs":0}],"SRTHours":0,"SRTAdjustedHours":0,"StepId":84695,"AccessCode":"B"},{"Qty":1,"OverlapTime":[{"SRTNumber":"","OverlapHrs":0}],"SRTHours":0.4,"SRTAdjustedHours":0.4,"StepId":120876,"AccessCode":"B"},{"Qty":1,"OverlapTime":[{"SRTNumber":"","OverlapHrs":0}],"SRTHours":0.7,"SRTAdjustedHours":0.7,"StepId":109746,"AccessCode":"B"}],"TotalAdjustedHours":2.2,"OverlapSRTTime":[{"SRTNumber":"11-036-00","OverlapHrs":0.4,"SRTTitle":"Aftertreatment Diesel Oxidation Catalyst - Remove and Install","OverlapStepId":119986,"OverlapSRTNumber":"11-037-00","StepId":119989,"OverlapSRTTitle":"Aftertreatment Diesel Particulate Filter - Remove and Install"}]},"Header":{"ReturnCodeDescription":"Normal, Successful completion.","ReturnCode":"ORA-00000","MessageIdentifier":"S"}}';
                system.debug('overlapresponse-->'+overlapresponse);
                if(overlapresponse ==null || overlapresponse.DataArea ==null || overlapresponse.Header==null 
                   || String.isBlank(overlapresponse.Header.MessageType) || overlapresponse.Header.MessageType=='E'){
                       isOverlapServiceFailed = true;
                       system.debug('overlap service failed isOverlapServiceFailed-->'+isOverlapServiceFailed);
                       return lstSRTins;
                   }
                //if response is not null then create Overlap Records based on response
                system.debug('***overlapresponse.DataArea--->'+overlapresponse.DataArea+'overlapresponse.DataArea.OverlapSRTTime'+overlapresponse.DataArea.OverlapSRTTime);
                if(overlapresponse !=null && overlapresponse.DataArea !=null && overlapresponse.DataArea.OverlapSRTTime !=null && overlapresponse.DataArea.OverlapSRTTime.size()>0){
                    for(CSS_OverlapSRTResponse.OverlapSRTTime srtTime : overlapresponse.DataArea.OverlapSRTTime){
                        system.debug('srtTime.SRTNumber-->:'+srtTime.SRTNumber+' srtTime.OverlapSRTNumber>>>:'+srtTime.OverlapSRTNumber+' accCode>>>:'+accCode);
                        //check if exist accountcode and srt id combination record exist or not.
                        //checking already Overlap SRT is saved earleir or not 
                        //and if not saved, inserting as new records anf if already saved, ignoring latest records
                        //if(overlapSRTIds != null && !overlapSRTIds.contains(accCode+'-'+srtTime.StepId)){
                        //create OverLap Record
                        CSS_SRT__c tempSRT = new CSS_SRT__c();
                        tempSRT.SRT_ID__c = srtTime.SRTNumber;
                        tempSRT.Overlap_SRT_Number__c = srtTime.OverlapSRTNumber;
                        tempSRT.Name = srtTime.SRTNumber;
                        tempSRT.Overlap_Hours__c = srtTime.OverlapHrs;
                        tempSRT.SRT_Title__c = srtTime.SRTTitle;
                        tempSRT.Overlap_Step_Id__c = String.valueof(srtTime.OverlapStepId);    
                        tempSRT.Step_Id__c = String.valueof(srtTime.StepId);
                        tempSRT.Overlap_SRT_Title__c = srtTime.OverlapSRTTitle;
                        System.debug('existing olapAdjHrsMap>>:'+olapAdjHrsMap+' olapAdjHrsMap.containsKey>>:'+olapAdjHrsMap.containsKey(accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId));
                        if(olapAdjHrsMap != null && olapAdjHrsMap.containsKey(accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId)){
                            //if(olapAdjHrsMap.get(accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId) <= srtTime.OverlapHrs){
                            tempSRT.Adjusted_Overlap_Hours__c = olapAdjHrsMap.get(accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId);
                            tempSRT.OverrideReason__c = olapReasonMap.get(accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId);
                            tempSRT.Override_Reason__c = olapReasonPickMap.get(accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId);
                            tempSRT.Override__c= true;
                            //system.debug('contains Key-->'+accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId);
                            system.debug('contains Key-->'+accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId+' Adjusted_Overlap_Hours__c>>:'+tempSRT.Adjusted_Overlap_Hours__c+' OverrideReason__c>>>:'+tempSRT.OverrideReason__c);
                            //}
                        }else{
                            system.debug('not contains Key-->'+accCode+'-'+srtTime.StepId+'-'+srtTime.OverlapStepId);
                        }
                        tempSRT.Type__c = 'Overlap';
                        tempSRT.Account_Code__c = accCode;
                        tempSRT.CSS_Claims__c = cId;
                        lstSRTins.add(tempSRT);
                        //}else{
                        //if already same Overlap exist with same accountCode, then update it
                    }
                }
            }
        } catch(exception e){
            system.debug('Entered into overlapSRTCallout method of CSS_JobPlanSRTController class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());
        }
        system.debug('lstSRTins--'+lstSRTins);
        return lstSRTins;
    }
    
    //function to update %Req with Penalty if applicable,else populates %Req based on Coverage
    public void updateSRTPercReq(List<Css_Srt__c> srtList){
        //Story 155910
        System.debug('in updateSRTPercReq srtListSize=======>'+srtList.size());
        //Added below query here, as I was getting error that the record is deleted, while updating SRTs.
        srtList = new List<CSS_SRT__c>([Select Id,Step_Id__c,SRT_ID__c,SRT_Title__c,FailCode__c,Account_Code__c,Account_Code_Description__c,AccountCode_Formula__c,SRT_Notes__c,SRT_Quantity__c,SRT_Warrantable__c,Access_Code__c,Access_Code_Saved__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,
                                        SRT_Category__c,isPopupSRT__c,Diag_Access_Time__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Access_Calculated__c, Extended_Hours__c, SRT_Time__c, 
                                        Calculated_Claimed_Hours__c, SRT_Time_Formula__c,Override__c,OverrideReason__c,Override_Reason__c,Overlap__c, Overlap_Step_Id__c,Adjusted_Overlap_Hours__c, Overlap_SRT_Number__c,
                                        Solution_Number__c, Solution_Number__r.Diagnostic_Response__c,Component_Id__c,Assignment__c,Component_Id__r.Type__c,
                                        Component_Id__r.Performed_Review__c,Component_Id__r.Status__c,Component_Id__r.Complete_Indicator__c,Component_Id__r.Multiple_Times__c,Component_Id__r.CoveredLaborHrs__c,
                                        isUserEntered__c,Type__c, SRT_Type__c, isPerformed__c, SRT_AccessiblityCheck__c, CSS_Claims__r.AccessCode__c, CSS_Claims__r.Name, Job_Order__c,Job_Order__r.AccessCode__c, Job_Order__r.Name from css_srt__c where CSS_Claims__c =: cId and SRT_ID__c !=null and SRT_ID__c !='0' ]);
        System.debug('srtList2=======>'+srtList.size()); //why the above query used here since already have srtList as param???
        if(claimsRec !=null && claimsRec.id !=null && claimsRec.Information_Only_Claim__c==false){
            //Commented below query and added it in constructor to reduce 1 query
            //List<CSS_JobEventTemporary__c> jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c = 'POL'];
            Set<String> accSet = new Set<String>();
            List<css_Srt__c> srtpercentReqList = new List<css_Srt__c>();
            for(CSS_JobEventTemporary__c JET: jobEventTemp){
                if(JET.Attribute1__c == 'POL'){
                    accSet.add(JET.Attribute2__c+' '+JET.Attribute3__c);
                }
            }
            system.debug('accSet**'+accSet);
            //Story 180325
            //Commented below query to reduce 1 query
            //List<CSS_JobEventTemporary__c> jobEventTempPW = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' and Attribute1__c IN ('NPW','RPW')];
            Set<String> accSetPW = new Set<String>();
            Map<string,string> pwPenaltyMap = new Map<string,string>();
            Map<string,string> pwPenaltyAccCodeMap = new Map<string,string>();
            Map<string,string> solCompCoverageMap = new Map<string,string>();
            Map<string,string> solCompCoverageMapforFA = new Map<string,string>();
            Map<string,string> solCompAccCodeCoverageMap = new Map<string,string>();
            Map<string,string> solCompAccCodeCoverageMapforFA = new Map<string,string>();
            Map<string,string> solCompCoverageMapForPOL = new Map<string,string>();
            string failurePenalty;
            //if(jobEventTempPW != null && jobEventTempPW.size()>0){
            if(jobEventTemp != null && jobEventTemp.size()>0){
                //for(CSS_JobEventTemporary__c JET: jobEventTempPW){
                for(CSS_JobEventTemporary__c JET: jobEventTemp){
                    if(JET.Attribute1__c == 'NPW' || JET.Attribute1__c == 'RPW'){
                        accSetPW.add(JET.Attribute2__c+' '+JET.Attribute3__c);
                    }
                }
            }
            system.debug('accSetPW**'+accSetPW);
            //commneted below query and added in contructor to reduce query for 101 SOQL issue
            //List<CSS_Solution_Component__c> solCompList = [select id,Type__c,fail_code__c,FailCode_Formula__c,Covered_Labor__c,ODM_Penalty__c,CSS_Account_Formula__c,CoveredLaborHrs__c,CampaignLaborPercentage__c from css_solution_component__C where css_claims__c = :cId];
            for(CSS_Solution_Component__c sc:compList){
                if(sc.type__c == 'Campaign' || sc.type__c == 'TRP' || sc.type__c == 'ATC')
                {
                    solCompCoverageMapforFA.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.CampaignLaborPercentage__c);
                    solCompAccCodeCoverageMapforFA.put(sc.CSS_Account_Formula__c,sc.CampaignLaborPercentage__c);
                }else{
                    solCompCoverageMap.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.CoveredLaborHrs__c);
                    solCompAccCodeCoverageMap.put(sc.CSS_Account_Formula__c,sc.CoveredLaborHrs__c);
                    solCompCoverageMapForPOL.put(sc.fail_code__c+sc.CSS_Account_Formula__c,sc.Covered_Labor__c);
                }
                if(sc.ODM_Penalty__c != null && sc.ODM_Penalty__c != '' && integer.valueof(sc.ODM_Penalty__c) > 0 && (sc.CSS_Account_Formula__c != null && sc.CSS_Account_Formula__c != '') && accSetPW.contains(sc.CSS_Account_Formula__c.trim())){
                    pwPenaltyMap.put(sc.fail_code__c.trim()+sc.CSS_Account_Formula__c.trim(),sc.ODM_Penalty__c);
                    pwPenaltyAccCodeMap.put(sc.CSS_Account_Formula__c.trim(),sc.ODM_Penalty__c);
                }
            }
            system.debug('pwPenaltyMap**'+pwPenaltyMap);
            system.debug('solCompCoverageMap**'+solCompCoverageMap);
            system.debug('solCompCoverageMapforFA**'+solCompCoverageMapforFA);
            string[] fcSplit;
            string failcode;
            if(srtList != null && !srtList.isEmpty()){
                for(css_srt__c srt:srtList){
                    if(srt.Type__c == '99Time')
                        srt.Account_Code__c = srt.Account_Code_Description__c;
                    system.debug('AccountCode**'+srt.Account_Code__c);
                    system.debug('srtID**'+srt.SRT_ID__c);
                    system.debug('srt.Component_Id__r'+srt.Component_Id__r);
                    system.debug('srt.Component_Id__r.CoveredLaborHrs__c'+srt.Component_Id__r.CoveredLaborHrs__c);
                    if(srt.failcode__c != null && srt.failcode__c != '' && srt.failcode__c.contains('-')){
                        fcSplit = srt.failcode__c.split('-'); //srt.failcode__c.RIGHT(4);
                        system.debug('fcSplit**'+fcSplit);
                        if(fcSplit != null && fcSplit.size()>0)
                            failcode = fcSplit[1];//why updating existing SRT failcode with split value???
                    }
                    else
                        failcode = srt.failcode__c;
                    
                    if(pwPenaltyMap != null && pwPenaltyMap.size() > 0 && (failcode != null && failcode != '') && pwPenaltyMap.get(failcode.trim()+srt.Account_Code__c.trim()) != null && pwPenaltyMap.get(failcode.trim()+srt.Account_Code__c.trim()) != '' && (srt.Account_Code__c != null && srt.Account_Code__c != '') && accSetPW.contains(srt.Account_Code__c.trim())){    
                        system.debug('Inside If1**');
                        if(failcode != null && failcode != '')
                            failurePenalty = pwPenaltyMap.get(failcode.trim()+srt.Account_Code__c.trim());
                        else
                            failurePenalty = pwPenaltyAccCodeMap.get(srt.Account_Code__c.trim());
                        system.debug('pwPenaltyMap11**'+pwPenaltyMap);
                        system.debug('failurePenalty**'+failurePenalty);
                        system.debug('srt.SRT_Warrantable__c**'+srt.SRT_Warrantable__c);
                        if(failurePenalty != null && failurePenalty != '' && (((srt.SRT_Warrantable__c != null && srt.SRT_Warrantable__c != '') && integer.valueof(srt.SRT_Warrantable__c)>=integer.valueof(failurePenalty)) || (srt.SRT_Warrantable__c == null || srt.SRT_Warrantable__c == '' || srt.SRT_Warrantable__c == '0'))){
                            srt.SRT_Warrantable__c = failurePenalty;
                            system.debug('InsideFailurePenalty**');
                        }
                    }
                    else if(claimsRec.ODM_Penalty__c != null && claimsRec.ODM_Penalty__c != '' && integer.valueof(claimsRec.ODM_Penalty__c) > 0 && srt.Account_Code__c != null && srt.Account_Code__c != '' && !accSetPW.contains(srt.Account_Code__c.trim()) && !accSet.contains(srt.Account_Code__c.trim())){
                        if(srt.Account_Code__c != null && srt.Account_Code__c != '' && accSet.contains(srt.Account_Code__c.trim())){
                            system.debug('Inside If2**');
                            if(srt.SRT_Warrantable__c != null && srt.SRT_Warrantable__c != '' && integer.valueof(srt.SRT_Warrantable__c)>=100){
                                srt.SRT_Warrantable__c = string.valueof(100);
                            }
                        }
                        else{ 
                            system.debug('Inside ELSE**'+srt.SRT_Warrantable__c);
                            system.debug('Inside ELSE1**'+srt.isUserEntered__c);
                            if(srt.Account_Code__c == null || srt.Account_Code__c == ''){
                                srt.SRT_Warrantable__c = '0';
                            }
                            else{
                                system.debug('Inside ELSE2**'+srt.Type__c+':'+srt.isPerformed__c);
                                if(srt.isUserEntered__c == false){
                                    srt.SRT_Warrantable__c = claimsRec.ODM_Penalty__c;
                                }
                                else if(srt.isUserEntered__c == true){
                                    if((srt.SRT_Warrantable__c == null || srt.SRT_Warrantable__c == '' || srt.SRT_Warrantable__c == '0') || (srt.SRT_Warrantable__c != null && srt.SRT_Warrantable__c != '' && integer.valueof(srt.SRT_Warrantable__c)>integer.valueof(claimsRec.ODM_Penalty__c))){
                                        system.debug('InsideAccCode**'+srt.Account_Code__c+''+'SRT_ID__c**'+srt.SRT_ID__c);
                                        
                                        srt.SRT_Warrantable__c = claimsRec.ODM_Penalty__c;
                                        srt.isUserEntered__c = false;
                                    }
                                }
                            }
                        }
                    }
                    else if((srt.Account_Code__c != null && srt.Account_Code__c != '') && ((solCompCoverageMap != null && solCompCoverageMap.size()>0) || (solCompCoverageMapforFA != null && solCompCoverageMapforFA.size()>0)) && !accSet.contains(srt.Account_Code__c.trim())){        
                        system.debug('Inside If**'+solCompCoverageMap.get(failcode+srt.Account_Code__c));
                        system.debug('kalpanasrtwarrantable**'+srt.SRT_Warrantable__c);
                        if(srt.FailCode__c != null && srt.FailCode__c != null){
                            if((solCompCoverageMap.get(failcode+srt.Account_Code__c)!= null && solCompCoverageMap.get(failcode+srt.Account_Code__c) != '' && integer.valueof(solCompCoverageMap.get(failcode+srt.Account_Code__c))>0) || (solCompCoverageMapforFA.get(failcode+srt.Account_Code__c) != null && solCompCoverageMapforFA.get(failcode+srt.Account_Code__c) != '' && integer.valueof(solCompCoverageMapforFA.get(failcode+srt.Account_Code__c))>0)){
                                // if(srt.isUserEntered__c == false){
                                if(srt.isUserEntered__c == false && srt.type__c != 'Admin' && claimsRec.Multi_PSN_Claim__c != true){
                                    system.debug('isnideUserEntered**'+srt.isUserEntered__c);
                                    srt.SRT_Warrantable__c = '100';
                                    //srtpercentReqList.add(srt);
                                }
                            }
                            else{ //if(integer.valueof( loop else
                                system.debug('Inside If Else**');
                                srt.SRT_Warrantable__c = '0';
                                //srtpercentReqList.add(srt);
                            }
                        }
                        else // Else for...if(srt.FailCode__c != null && srt.FailCode__c != null)
                        {
                            if((solCompAccCodeCoverageMap.get(srt.Account_Code__c)!= null && solCompAccCodeCoverageMap.get(srt.Account_Code__c) != '' && integer.valueof(solCompAccCodeCoverageMap.get(srt.Account_Code__c))>0) || (solCompAccCodeCoverageMapforFA.get(srt.Account_Code__c) != null && solCompAccCodeCoverageMapforFA.get(srt.Account_Code__c) != '' && integer.valueof(solCompAccCodeCoverageMapforFA.get(srt.Account_Code__c))>0)){
                                //if(srt.isUserEntered__c == false){
                                if(srt.isUserEntered__c == false && srt.type__c != 'Admin' && claimsRec.Multi_PSN_Claim__c != true){
                                    system.debug('isnideUserEntered**'+srt.isUserEntered__c);
                                    srt.SRT_Warrantable__c = '100';
                                    //srtpercentReqList.add(srt);
                                }
                            }
                            else{ //if(integer.valueof( loop else
                                srt.SRT_Warrantable__c = '0';
                                //srtpercentReqList.add(srt);
                            }
                        }
                    }
                    else if((srt.Account_Code__c != null && srt.Account_Code__c != '') && !accSet.contains(srt.Account_Code__c.trim())){
                        
                        srt.SRT_Warrantable__c = '0';
                        //srtpercentReqList.add(srt);
                    }
                    // karthik G added as part of GSSC -57
                    else if((srt.Account_Code__c != null && srt.Account_Code__c != '') && accSet.contains(srt.Account_Code__c.trim())){
                        system.debug('karthikelseif');
                        if(solCompCoverageMapForPOL != null){
                            String covLaborPOL = solCompCoverageMapForPOL.get(srt.failcode__c + srt.Account_Code__c);
                            if(covLaborPOL != null){
                               if(srt.isUserEntered__c == false)
                                	srt.SRT_Warrantable__c = solCompCoverageMapForPOL.get(srt.failcode__c + srt.Account_Code__c);
                            }else{
                                srt.SRT_Warrantable__c = '100';
                            }
                        }else{
                            srt.SRT_Warrantable__c = '0';
                        }
                    }
                    system.debug('srt.SRT_Warrantable__c'+srt.SRT_Warrantable__c);
                }
                system.debug('****InsidekalBeforeUpdatePenalty**'+srtList);
                if(srtList != null && !srtList.isEmpty()){
                    update srtList;
                    calculateExtendedHours(srtList);
                }
                system.debug('****InsidekalAfterUpdatePenalty**'+srtList);
                //Check Duplicate SRTs story 148920
                checkDuplicateSRTs();//Added as part of defect fix GSSC 509
                //Duplicate Access Code & %Requested logic here
                //The below method should run after all SRTs are inserted/updated to find duplicates
                buildDuplicateAccessCodesLogic(srtList);//Added as part of defect fix GSSC 509
            }  
        }
    }
    //function to calculate Extended Hours
    Map<id,CSS_SRT__c> srtListToUpd = new Map<id,CSS_SRT__c>();
    public void calculateExtendedHours(List<CSS_SRT__c> srtList){
        System.debug('=======> in calculateExtendedHours'+cId);
        try{
            /*srtList = new List<CSS_SRT__c>([Select id,Step_Id__c,SRT_ID__c,SRT_Title__c,OverrideReason__c,Override__c,Overlap__c,SRT_Notes__c,SRT_Quantity__c
,SRT_Warrantable__c,Diag_Access_Time__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Access_Calculated__c,SRT_Category__c, Extended_Hours__c, SRT_Time__c, 
Calculated_Claimed_Hours__c, SRT_Hours_Percentage__c,SRT_Time_Formula__c,Account_Code_Description__c,isUserEntered__c,
Job_Order__c, Type__c, FailCode__c, isPerformed__c, SRT_AccessiblityCheck__c, Account_Code__c, CSS_Claims__r.AccessCode__c, CSS_Claims__r.Name from css_srt__c where CSS_Claims__c =:cId and SRT_ID__c !=null and SRT_ID__c !='0' ]); */ //use global query here
            System.debug('srtListSize=======>'+srtList.size());
            System.debug('srtList=======>'+srtList);
            if(srtList ==null){
                return;
            }
            
            //The Below code is for summing Overlap hours for each SRT based on AccountCode
            List<CSS_SRT__c> overlapSrtList = new List<CSS_SRT__c>();
            Map<String, Decimal> overlapSRTHoursSum = new Map<String, Decimal>();
            overlapSrtList = new List<CSS_SRT__c>([SELECT Id, SRT_ID__c, Step_Id__c, Account_Code__c, SRT_Category__c, Extended_Hours__c, SRT_Time__c, SRT_Quantity__c, Calculated_Claimed_Hours__c, Type__c, SRT_Warrantable__c FROM CSS_SRT__c WHERE Type__c = 'Overlap' AND CSS_Claims__c =: cId]);
            System.debug('overlapSrtList size=======>'+overlapSrtList.size());
            if(overlapSrtList != null && overlapSrtList.size() > 0){
                overlapSRTIdsSet = new Set<String>();
                for(CSS_SRT__c olapSrt : overlapSrtList){
                    overlapSRTIdsSet.add(olapSrt.Account_Code__c+'-'+olapSrt.Step_Id__c);
                    //Here need to add AccountCode basis logic
                    if(overlapSRTHoursSum.containsKey(olapSrt.Account_Code__c+'-'+olapSrt.Step_Id__c)){
                        Decimal existingHrs = overlapSRTHoursSum.get(olapSrt.Account_Code__c+'-'+olapSrt.Step_Id__c);
                        existingHrs = existingHrs + olapSrt.Calculated_Claimed_Hours__c;
                        overlapSRTHoursSum.put(olapSrt.Account_Code__c+'-'+olapSrt.Step_Id__c, existingHrs);
                        System.debug('olapSrt.SRT_ID>>:'+olapSrt.SRT_ID__c+' existingHrs=======>'+existingHrs);
                    }else{
                        overlapSRTHoursSum.put(olapSrt.Account_Code__c+'-'+olapSrt.Step_Id__c, olapSrt.Calculated_Claimed_Hours__c);
                        System.debug('olapSrt.SRT_ID>>:'+olapSrt.SRT_ID__c+' olapSrt.Calculated_Claimed_Hours=======>'+olapSrt.Calculated_Claimed_Hours__c);
                    }
                    System.debug('overlapSRTHoursSum =======>'+overlapSRTHoursSum);
                }
            }
            
            
            String tempAccCode = '';
            for(CSS_SRT__c srt : srtList){
                if(overlapSrtList != null && overlapSrtList.size() > 0){
                    System.debug('Inside Overlap block... srt.SRT_ID>>:'+srt.SRT_ID__c);
                    if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One'){
                        tempAccCode = 'Customer Billable';
                    }
                    else
                        tempAccCode = srt.Account_Code__c;
                    
                    if(overlapSRTIdsSet.contains(tempAccCode+'-'+srt.Step_Id__c)){
                        System.debug('contains... srt.SRT_ID>>:'+srt.SRT_ID__c);
                        Map<String,List<CSS_SRT__c>> srtCountListMap = acCodeSRTCountListMap.get(tempAccCode);
                        if(srtCountListMap.get(srt.Step_Id__c).size()>1){
                            // if(srtCountListMap.containsKey(srt.SRT_ID__c) && srtCountListMap.get(srt.SRT_ID__c).size()>1){
                            System.debug('contains >1... srt.SRT_ID>>:'+srt.SRT_ID__c);
                            Decimal srtTotalQuantity = 0;
                            for(CSS_SRT__c tmpSRT :srtCountListMap.get(srt.Step_Id__c)){
                                //srtTotalQuantity++;
                                srtTotalQuantity = srtTotalQuantity + tmpSRT.SRT_Quantity__c;
                            }
                            System.debug('srtTotalQuantity>>:'+srtTotalQuantity);
                            getExtendedHours(srt, true, overlapSRTHoursSum.get(tempAccCode+'-'+srt.Step_Id__c), srtTotalQuantity);
                            
                            /*List<CSS_SRT__c> tempSrtList = srtCountListMap.get(srt.Step_Id__c);
Decimal olapHrs = overlapSRTHoursSum.get(tempAccCode+'-'+srt.Step_Id__c);
if(olapHrs>0){
Decimal dividedHrs = olapHrs/tempSrtList.size();
getExtendedHours(srt, true, dividedHrs);
}*/
                        }else{
                            System.debug('not contains... srt.SRT_ID>>:'+srt.SRT_ID__c+' overlapSRTHoursSum.srt.SRT_ID__c>>:'+overlapSRTHoursSum.get(tempAccCode+'-'+srt.Step_Id__c));
                            getExtendedHours(srt, false, overlapSRTHoursSum.get(tempAccCode+'-'+srt.Step_Id__c), srt.SRT_Quantity__c);
                        }
                    }else{
                        getExtendedHours(srt, false, 0, srt.SRT_Quantity__c);
                    }
                }else{
                    //if no overlaps
                    getExtendedHours(srt, false, 0, srt.SRT_Quantity__c);
                }
            }
            
            system.debug('output size-->'+srtListToUpd.size());
            if(srtListToUpd != null && srtListToUpd.size() > 0){
                system.debug('output-->'+srtListToUpd);
                update srtListToUpd.values();
            }
            
            //claimsTotalSRT = new CSS_Claims__c();
            //claimsTotalSRT =[select id,TotalSRTExtendedHours__c from CSS_Claims__c where id= :cId];
            //system.debug('claimsTotalSRT ------> ' + claimsTotalSRT);
        }
        catch (exception exc)
        {
            system.debug('catch exception in calculateExtendedHours JobplansrtController class at line number '+exc.getLineNumber()+' with error message '+exc.getMessage());
        }   
        
        //claimsTotalSRTHrs=claimsTotalSRT.TotalSRTExtendedHours__c;
        //system.debug('******claimsTotalSRTHrs'+claimsTotalSRTHrs);
    }
    
    public void getExtendedHours(CSS_SRT__c srt, Boolean isDuplicate, Decimal olapHrs, Decimal srtTotalQuantity){
        try{
            system.debug('Inside getExtendedHours method... ');
            CSS_SRT__c tempSRT = new CSS_SRT__c();
            system.debug('srt.Type__c--'+srt.Type__c+' olapHrs>>:'+olapHrs+' srt.Account_Code>>>:'+srt.Account_Code__c);
            system.debug('getExtendedHours SRTId: '+srt.SRT_ID__c+' SRT_Quantity__c:'+srt.SRT_Quantity__c+' SRT_Warrantable__c>:'+srt.SRT_Warrantable__c+' srt.SRT_Time_Formula__c>>:'+srt.SRT_Time_Formula__c+' srt.SRT_Time__c>>:'+srt.SRT_Time__c+' srt.Type__c--'+srt.Type__c+' olapHrs>>:'+olapHrs);
            //To handle 0 quantity
            if(srtTotalQuantity <=0 || srt.SRT_Quantity__c <=0){
                tempSRT.Id = srt.Id;
                tempSRT.Extended_Hours__c = 0.0;
                srtListToUpd.put(tempSRT.Id,tempSRT);
                return;
            }
            //end
            
            if(srt.Type__c == 'Repair' || srt.Type__c == 'Repair Access' || srt.SRT_Category__c == 'AdditionalRep' || srt.SRT_Category__c == 'AdditionalDiag' || 
               srt.Type__c == 'Diagnosis' || srt.Type__c == 'Diag Access' || srt.Type__c == '99Time' || srt.SRT_Category__c == 'Campaign' || srt.SRT_Category__c == 'TRP'|| srt.SRT_Category__c == 'ATC'  ){ //Repair SRT
                   tempSRT.Id = srt.Id;
                   try{
                       //if(srt.Type__c == 'Diagnosis' || srt.Type__c == 'Diag Access'){
                       if(srt.Type__c == 'Diag Access' && srt.SRT_AccessiblityCheck__c == true){
                           if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                               tempSRT.Extended_Hours__c = (( (srt.Diag_Access_Time__c!=null?srt.Diag_Access_Time__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                           //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs);
                           else
                               tempSRT.Extended_Hours__c = ( ((srt.Diag_Access_Time__c!=null?srt.Diag_Access_Time__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                           //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                       }
                       else if(srt.Type__c == 'Repair Access' && srt.SRT_AccessiblityCheck__c == true){
                           system.debug('Repair Access getExtendedHours SRTId: '+srt.SRT_ID__c+' SRT_Quantity__c:'+srt.SRT_Quantity__c+' SRT_Warrantable__c>:'+srt.SRT_Warrantable__c+' srt.SRT_Time__c>>:'+srt.SRT_Time__c+' srt.Type__c--'+srt.Type__c+' olapHrs>>:'+olapHrs+' SRT_Time_Formula__c>>:'+srt.SRT_Time_Formula__c);
                           system.debug('SRT Time*Quantity-->'+((srt.Repair_Access_Calculated__c!=null?srt.Repair_Access_Calculated__c:0) * srt.SRT_Quantity__c));
                           system.debug('srtTotalQuantity-->'+srtTotalQuantity);
                           system.debug('SRT OlapHrs*Quantity-->'+((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                           system.debug('SRT Warrantable %-->'+double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                           if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                               tempSRT.Extended_Hours__c = (( (srt.Repair_Access_Calculated__c!=null?srt.Repair_Access_Calculated__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                           //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs);
                           else
                               tempSRT.Extended_Hours__c = ( ((srt.Repair_Access_Calculated__c!=null?srt.Repair_Access_Calculated__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                           //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                       }
                       else if(srt.Type__c == 'Diagnosis' && srt.isPerformed__c == true){
                           if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                               tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                           //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs);
                           else
                               tempSRT.Extended_Hours__c = ( ((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                           //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                       }
                       else if(srt.Type__c == 'Access' && srt.SRT_AccessiblityCheck__c == true){
                           system.debug('Access getExtendedHours SRTId: '+srt.SRT_ID__c+' SRT_Quantity__c:'+srt.SRT_Quantity__c+' SRT_Warrantable__c>:'+srt.SRT_Warrantable__c+' srt.SRT_Time__c>>:'+srt.SRT_Time__c+' srt.Type__c--'+srt.Type__c+' olapHrs>>:'+olapHrs+' SRT_Time_Formula__c>>:'+srt.SRT_Time_Formula__c);
                           system.debug('SRT Time*Quantity-->'+((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c));
                           system.debug('srtTotalQuantity-->'+srtTotalQuantity);
                           system.debug('SRT OlapHrs*Quantity-->'+((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                           system.debug('SRT Warrantable %-->'+double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                           if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                               tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                           //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs);
                           else
                               tempSRT.Extended_Hours__c = ( ((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                           //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                       }
                       else if(srt.Type__c == '99Time'){
                           system.debug('in 99Time ');
                           if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                               tempSRT.Extended_Hours__c = (( (srt.SRT_Time__c!=null?srt.SRT_Time__c:0) * srt.SRT_Quantity__c) - 0);
                           else
                               tempSRT.Extended_Hours__c = (( (srt.SRT_Time__c!=null?srt.SRT_Time__c:0) * srt.SRT_Quantity__c) - 0) * (double.valueof(srt.SRT_Warrantable__c)/100);
                       }
                       else{
                           if(srt.isPerformed__c == true){
                               system.debug('Repair getExtendedHours SRTId: '+srt.SRT_ID__c+' SRT_Quantity__c:'+srt.SRT_Quantity__c+' SRT_Warrantable__c>:'+srt.SRT_Warrantable__c+' srt.SRT_Time__c>>:'+srt.SRT_Time__c+' srt.Type__c--'+srt.Type__c+' olapHrs>>:'+olapHrs+' SRT_Time_Formula__c>>:'+srt.SRT_Time_Formula__c);
                               system.debug('SRT Time*Quantity-->'+((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c));
                               system.debug('srtTotalQuantity-->'+srtTotalQuantity);
                               system.debug('SRT OlapHrs*Quantity-->'+((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                               system.debug('SRT Warrantable %-->'+double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                               if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                                   tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c));
                               //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs);
                               else
                                   tempSRT.Extended_Hours__c = ( ((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                               //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Warrantable__c!=null?srt.SRT_Warrantable__c:'100')/100);
                               
                           }
                       }
                       system.debug('before roundUp -- tempSRT.Extended_Hours__c-->'+tempSRT.Extended_Hours__c);
                       Decimal toround = tempSRT.Extended_Hours__c; //3.14159265
                       tempSRT.Extended_Hours__c = css_utility.getCustomRoundValue(toround);
                       srtListToUpd.put(tempSRT.Id,tempSRT);
                   }
                   catch(exception ex){
                       system.debug('else Inside Catch--'+ex.getMessage()+' '+ex.getLineNumber());
                       //to skip only this record if value is null
                   }
               }
            else if((srt.Type__c == 'Field Action' && srt.isPerformed__c == true)|| (srt.Type__c == 'Field Action Access' && srt.SRT_AccessiblityCheck__c == true)){ //ATC Campaign TRP
                tempSRT.Id = srt.Id;
                system.debug('Field Actions srt.Type__c-->'+srt.Type__c);
                try{
                    //tempSRT.Extended_Hours__c = ((srt.SRT_Time__c * srt.SRT_Quantity__c) - 0) * (double.valueof(srt.SRT_Hours_Percentage__c)/100);
                    if(srt.Account_Code__c == null || srt.Account_Code__c == 'Select One' || srt.Account_Code__c.trim() == '')
                        tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) );
                    //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs);
                    //tempSRT.Extended_Hours__c = (( (srt.SRT_Time__c!=null?srt.SRT_Time__c:0) * srt.SRT_Quantity__c) - olapHrs);
                    else
                        tempSRT.Extended_Hours__c = ( ((srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - ((olapHrs/srtTotalQuantity) * srt.SRT_Quantity__c) ) * (double.valueof(srt.SRT_Warrantable__c)/100);
                    //tempSRT.Extended_Hours__c = (( (srt.SRT_Time_Formula__c!=null?srt.SRT_Time_Formula__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Hours_Percentage__c)/100);
                    //tempSRT.Extended_Hours__c = (( (srt.SRT_Time__c!=null?srt.SRT_Time__c:0) * srt.SRT_Quantity__c) - olapHrs) * (double.valueof(srt.SRT_Hours_Percentage__c)/100);
                    
                    Decimal toround = tempSRT.Extended_Hours__c; //3.14159265
                    tempSRT.Extended_Hours__c = css_utility.getCustomRoundValue(toround);
                    srtListToUpd.put(tempSRT.Id,tempSRT);
                    system.debug('Field Actions Ext Hrs:'+tempSRT.Extended_Hours__c+' SRT_ID__c:'+srt.SRT_ID__c+' SRT_Time__c:'+ srt.SRT_Time__c+' SRT_Quantity__c:'+srt.SRT_Quantity__c+' SRT_Hours_Percentage__c:'+srt.SRT_Warrantable__c);
                }
                catch(exception ex){
                    system.debug('22 Inside Catch--'+ex.getMessage()+' '+ex.getLineNumber());
                    //to skip only this record if value is null
                }
            }
        }catch (exception exc){
            system.debug('catch exception in getExtendedHours from JobplansrtController class at line number '+exc.getLineNumber()+' with error message '+exc.getMessage());
        }     
    }
    
    //153527 -  function to make callout for Mutual Overlap
    public void mutualOverlapSRTCallout(List<CSS_SRT__c> selectedSRTList){
        system.debug('in mutualOverlapSRTCallout method...');
        try{
            /*List<CSS_SRT__c> selectedSRTList = new List<CSS_SRT__c>([Select id,Step_Id__c,SRT_ID__c,SRT_Title__c,OverrideReason__c,Override__c,Overlap__c,SRT_Notes__c,SRT_Quantity__c
,SRT_Warrantable__c,Diag_Access_Time__c,Diagnosis_Time__c,Additional_SRT_Calculated__c,Repair_Access_Calculated__c,SRT_Category__c, Extended_Hours__c, SRT_Time__c, 
Calculated_Claimed_Hours__c, SRT_Hours_Percentage__c,SRT_Time_Formula__c,
Job_Order__c, Type__c, FailCode__c, isPerformed__c, SRT_AccessiblityCheck__c, Account_Code__c, CSS_Claims__r.AccessCode__c, CSS_Claims__r.Name, Job_Order__r.AccessCode__c, Job_Order__r.Name from css_srt__c 
where CSS_Claims__c =:cId and SRT_ID__c !=null and SRT_ID__c !='0' and (SRT_AccessiblityCheck__c = true or isPerformed__c = true) ]); */ //use global query here
            //System.debug('selectedSRTList=======>'+selectedSRTList);
            if(selectedSRTList ==null || selectedSRTList.size()<=0){
                return;
            }
            
            system.debug('Claims cId>>:'+cId);
            CSS_OverlapSRTReq overlapSRTREq = new CSS_OverlapSRTReq();
            User u = css_utility.getUserAttributes(userinfo.getUserId()); 
            string lang = u.LanguageLocaleKey;
            datetime systemDate = System.now();
            string sysdt = systemDate.format('YYYY-MM-dd') +'T00:00:00';        
            
            //Create the JSON request
            CSS_OverlapSRTReq.Header headerDeatail = new CSS_OverlapSRTReq.Header();
            CSS_OverlapSRTReq.Sender sendeDetail = new CSS_OverlapSRTReq.Sender();
            sendeDetail.ServiceName = 'GetOverlapSRT';
            sendeDetail.SenderID = 'CSS-Service';
            headerDeatail.Sender = sendeDetail;
            
            CSS_OverlapSRTReq.Target  targetDetail = new CSS_OverlapSRTReq.Target();
            targetDetail.TargetID = 'SRT';
            headerDeatail.Target = targetDetail;
            
            list<CSS_OverlapSRTReq.Steps> stepsrt1 = new list<CSS_OverlapSRTReq.Steps>();
            //loop through SRT List to send it for overlap check
            if(selectedSRTList != null && !selectedSRTList.isEmpty()){
                Set<String> stepIdsSet = new Set<String>();
                for(CSS_SRT__c srtrc: selectedSRTList){
                    if(srtrc.Step_Id__c !=null && srtrc.Step_Id__c !='0' ){
                        System.debug('srtrc.Step_Id__c>>:'+srtrc.Step_Id__c+' stepIdsSet>>:'+stepIdsSet);
                        if(!stepIdsSet.contains(srtrc.Step_Id__c)){
                            CSS_OverlapSRTReq.Steps stepsrt = new CSS_OverlapSRTReq.Steps();
                            if(srtrc.Step_Id__c != '0'){
                                stepsrt.StepId = integer.valueof(srtrc.Step_Id__c);
                                //system.debug('checking step id'+stepsrt.StepId );
                                
                                if(srtrc.SRT_Quantity__c != null){ 
                                    stepsrt.Qty = srtrc.SRT_Quantity__c.intvalue();
                                }
                                //system.debug('Quantity'+stepsrt.Qty);
                                if(srtrc.Access_Code__c != null){
                                    stepsrt.AccessCode = srtrc.Access_Code__c;
                                }
                                else{
                                    stepsrt.AccessCode = srtrc.CSS_Claims__r.AccessCode__c; 
                                }
                                stepsrt1.add(stepsrt);
                                stepIdsSet.add(srtrc.Step_Id__c);
                            }
                        }else{
                            //System.debug('else srtrc.Step_Id__c>>:'+srtrc.Step_Id__c);
                            for(CSS_OverlapSRTReq.Steps stepsObj :stepsrt1){
                                if(stepsObj.StepId == Integer.valueof(srtrc.Step_Id__c)){
                                    //System.debug('else stepsObj>>:'+stepsObj);
                                    stepsObj.Qty = stepsObj.Qty + (srtrc.SRT_Quantity__c.intvalue());
                                }
                            }
                        }
                    }
                }    
                system.debug('List size'+stepsrt1.size());  
            }
            
            CSS_OverlapSRTReq.DataArea dtarea = new CSS_OverlapSRTReq.DataArea();
            dtarea.JobID = selectedSRTList.size()>0?selectedSRTList[0].Job_Order__r.Name:'';
            dtarea.ClaimID = selectedSRTList.size()>0?selectedSRTList[0].CSS_Claims__r.Name:'';
            dtarea.Languagecode = lang;
            dtarea.DTTimestamp = sysdt;
            dtarea.EffectiveDTTime = sysdt;
            dtarea.ProcessOption = 'MUT_EX'; //MUT_EX/OVERLAP
            dtarea.Steps = stepsrt1;
            overlapSRTREq.DataArea = dtarea;
            overlapSRTREq.Header = headerDeatail;
            system.debug('***overlapSRTREq--->'+overlapSRTREq);
            
            if(!selectedSRTList.isEmpty()){
                //Callout for Mutual overlap
                CSS_OverlapSRTResponse overlapresponse = CSS_WS_SRT.getOverlapSRTRecords(overlapSRTREq);
                system.debug('overlapresponse-->'+overlapresponse);
                if(overlapresponse ==null || overlapresponse.DataArea ==null || overlapresponse.Header==null 
                   || String.isBlank(overlapresponse.Header.MessageType) || overlapresponse.Header.MessageType=='E'){
                       isOverlapServiceFailed = true;
                       system.debug('Mutual overlap service failed isOverlapServiceFailed-->'+isOverlapServiceFailed);
                       return;
                   }
                //if response is not null then create Overlap Records based on response
                if(overlapresponse !=null && overlapresponse.DataArea !=null && overlapresponse.DataArea.MutualExMessage !=null && overlapresponse.DataArea.MutualExMessage.trim() !=''){
                    claimsRec.Mutual_Exclusive_Message__c = overlapresponse.DataArea.MutualExMessage;
                }  
            }
        } catch(exception e){
            system.debug('Entered into overlapSRTCallout method of CSS_JobPlanSRTController class>>>>>>'+e.getmessage() + ' ' + e.getLineNumber());
        }
        
    }
    
    //Updating Quantity & %Requested for SRTs 00-901,00-902-00,00-904-00
    public void updateSRTs(){
        try{
            List<CSS_SRT__c> srtList = new List<CSS_SRT__c>([Select Id,Step_Id__c,SRT_ID__c,Type__c,SRT_Warrantable__c,SRT_Title__c,SRT_Quantity__c,CSS_Claims__c,CSS_Claims__r.Total_PSN_Count__c                                        
                                                             from CSS_SRT__c where CSS_Claims__c =:cId and (SRT_ID__c='00-901-00' or SRT_ID__c='00-902-00' or SRT_ID__c='00-904-00')]);
            system.debug('00-901,00-902-00,00-904-00 srtList size:'+srtList.size());
            system.debug('SRTList before Update**'+srtList);
            if(srtList ==null || srtList.size()<=0)
                return;
            for(CSS_SRT__c srtObj: srtList){
                srtObj.SRT_Quantity__c = srtObj.CSS_Claims__r.Total_PSN_Count__c; //Commented below condition, as per story 155910 and added new condition.
                // if(srtObj.SRT_Warrantable__c !=null && srtObj.SRT_Warrantable__c.trim() !='' && Integer.valueOf(srtObj.SRT_Warrantable__c) >50)
                if(claimsRec.Information_Only_Claim__c==true || (claimsRec.Information_Only_Claim__c==false && (claimsRec.ODM_Penalty__c=='' || claimsRec.ODM_Penalty__c == null || claimsRec.ODM_Penalty__c == '0')) && srtObj.SRT_Warrantable__c !=null && srtObj.SRT_Warrantable__c.trim() !='' && Integer.valueOf(srtObj.SRT_Warrantable__c) >50)
                    srtObj.SRT_Warrantable__c = '50';
                //if(srtObj.SRT_Hours_Percentage__c !=null && srtObj.SRT_Hours_Percentage__c >50)
                //srtObj.SRT_Hours_Percentage__c = 50;
            }
            update srtList;
            
        }catch(Exception ex) 
        {
            System.debug('second in catch of updateSRTs of MultiPSN>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
    //getting OlapReasonMsgFlag
    public Boolean getOlapReasonMsgFlag(){
        Boolean olapReasonMsgflag = false;
        try{
            if(cId !=null){
                String olapMsg = [Select Id,SRT_Olap_Reason_Msg__c from CSS_Claims__c where id= :cId].SRT_Olap_Reason_Msg__c;
                if(olapMsg !=null && olapMsg.trim() !='')
                    olapReasonMsgflag = true;
            }
        }catch(Exception ex){
            System.debug('second in catch of getOlapReasonMsgFlag of CG_CL_ClaimsSRTs>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        system.debug('olapReasonMsgflag>>:'+olapReasonMsgflag);
        return olapReasonMsgflag;
    }
    
    //Logic for adding SRTduplicate check story 148920
    public void checkDuplicateSRTs(){
        Map<String,List<CSS_SRT__c>> dupSRTMap = new Map<String,List<CSS_SRT__c>>();
        list<CSS_srt__c> lstSRTDupCheck = new list<CSS_srt__c>();
        String ESRTDCLValues = Label.CG_ExcludeSRTsDuplicateCheck;
        List<String> excludeSRTsDuplicateCheckList = new List<String>();
        if(ESRTDCLValues != null && ESRTDCLValues != '') {
            excludeSRTsDuplicateCheckList = ESRTDCLValues.split(',');
        }
        lstSRTDupCheck=[select name,SRT_ID__c,Job_Order__r.Name,id,step_id__c,Component_Id__c ,Type__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c from CSS_SRT__c where SRT_ID__c != '' and SRT_ID__c != '0' and css_claims__c =: cId AND (((solution_number__c != null and solution_number__r.Diagnostic_Response__c!=null and (Type__c IN ('Diagnosis','Access','Diag Access') and (srt_category__c = null or srt_category__c = '')))or(srt_category__c!= null and srt_category__c = 'AdditionalDiag') or (solution_number__c=null and ((Type__c IN ('Repair','Repair Access','Access') and srt_category__c = null and  Assignment__c = 'Diagnostic')))) or ((Assignment__c IN ('Primary', 'Progressive Damage','Alternative') OR Assignment__c = Null) and (((solution_number__r.Diagnostic_Response__c!=null and solution_number__r.Diagnostic_Response__c = 'Most likely the solution') and (Type__c != null and Type__c != '' and Type__c IN ('Repair','Repair Access','Access') and srt_category__c = null)) or (srt_category__c!= null and srt_category__c = 'AdditionalRep') or (solution_number__c=null and ((Type__c IN ('Repair' ,'Repair Access') and srt_category__c = null and (Assignment__c!='Diagnostics' or Assignment__c!='DIAGNOSTIC')))))) or ((Assignment__c != 'NOT CLAIMABLE' and ((Type__c != null and Type__c != '' and Type__c = 'Field Action' and (srt_category__c = null or srt_category__c = '') and srt_type__c IN ('Campaign','TRP','ATC')) or (Type__c != null and Type__c != '' and Type__c = 'Field Action Access' and Component_Id__r.type__c IN ('Campaign','TRP','ATC')) or (srt_category__c!= null and srt_category__c!= '' and srt_category__c IN ('Campaign','TRP','ATC'))))))];
        
        system.debug('****lstSRTDupCheck****'+lstSRTDupCheck.size());
        List<CSS_SRT__c> tempList;
        for(CSS_SRT__c srtObj: lstSRTDupCheck){
            if(dupSRTMap.containsKey(srtObj.SRT_ID__c.LEFT(6))){
                tempList = dupSRTMap.get(srtObj.SRT_ID__c.LEFT(6));
                system.debug('tempList'+tempList);
                tempList.add(srtObj);
                system.debug('tempList'+tempList);
                dupSRTMap.put(srtObj.SRT_ID__c.LEFT(6), tempList);
            }
            else{
                tempList = new List<CSS_SRT__c>();
                tempList.add(srtObj);
                dupSRTMap.put(srtObj.SRT_ID__c.LEFT(6), tempList);
                //System.debug('olapSrt.SRT_ID>>:'+olapSrt.SRT_ID__c+' olapSrt.Calculated_Claimed_Hours=======>'+olapSrt.Calculated_Claimed_Hours__c);
            }
        }
        tempList = new List<CSS_SRT__c>();
        system.debug('****dupSRTMap****'+dupSRTMap.size()+'*****'+dupSRTMap);
        system.debug('****keysetsize****'+dupSRTMap.keySet().size());
        for(String srtKey: dupSRTMap.keySet()){
            tempList = dupSRTMap.get(srtKey);
            system.debug('****srtKey****'+srtKey+'*****'+tempList.size());
            Boolean isSelected;
            String srtID;
            if(tempList.size()<=1)
                continue;
            Integer count=0;
            for(CSS_SRT__c srtObj: tempList){
                if((srtObj.SRT_AccessiblityCheck__c == true || srtObj.isPerformed__c == true) && excludeSRTsDuplicateCheckList!=null && !(excludeSRTsDuplicateCheckList.contains(srtObj.SRT_ID__c.LEFT(6)))){
                    srtID=srtKey;
                    //isSelected=true;
                    count=count+1;
                    system.debug('***insideif1111***');
                    
                }
                else{
                    system.debug('***insideelse2222**');
                    isSelected=false;
                    //break;
                }
            }
            system.debug('***count**'+count);
            if(count>1){
                isSelected=true;
            }
            if(!dupSRTMsg.contains(srtKey) && isSelected==true){
                dupSRTMsg.add(srtKey);
            }
            
        }
        system.debug('*****dupSRTMsg****'+dupSRTMsg);
        if(dupSRTMsg != null && dupSRTMsg.size()>0){
            string tempStr;
            for(string s: dupSRTMsg){
                if(tempStr==null)
                    tempStr=s;
                else
                    tempStr=tempStr+', '+s;
            }
            claimsRec.DuplicateSRTDetails__c=tempStr;
        }
        else
            claimsRec.DuplicateSRTDetails__c='';
    }
    
    //Building logic for duplicate SRTs based on SRT Code/Account Code with AccessCode/%Requested
    public void buildDuplicateAccessCodesLogic(List<CSS_SRT__c> srtList){
        //List<CSS_SRT__c> srtList;
        List<CSS_SRT__c> dupCheckList;
        try{
            /*srtList = new List<CSS_SRT__c>([Select Id,Step_Id__c,SRT_ID__c,Access_Code__c,Access_Code_Saved__c,Access_Code_Flag__c,SRT_Warrantable_Flag__c,SRT_Warrantable__c,SRT_Hours_Percentage__c,
Job_Order__c, Type__c, SRT_Type__c, AccountCode_Formula__c,Account_Code__c, FailCode__c, isPerformed__c, SRT_AccessiblityCheck__c, Job_Order__r.AccessCode__c,
Solution_Number__c, Solution_Number__r.Diagnostic_Response__c,Component_Id__c,Assignment__c,Component_Id__r.Type__c,
Component_Id__r.Performed_Review__c,Component_Id__r.Status__c,Component_Id__r.Complete_Indicator__c,
Component_Id__r.Multiple_Times__c,isPopupSRT__c,srt_category__c 
from css_srt__c where CSS_Claims__c =:cId and SRT_ID__c !=null and SRT_ID__c !='0' 
and type__c !='Overlap']); */
            system.debug('buildDuplicateAccessCodesLogic loading... ***srtList size:'+srtList.size());
            if(srtList != null && srtList.size()>0){
                dupCheckList = new List<CSS_SRT__c>();
                for(CSS_SRT__c srt: srtList){
                    /*if(srt.SRT_ID__c=='99-902-00'){
System.debug('xx Intial SRT_ID__c>:'+srt.SRT_ID__c+' Step_Id__c>:'+srt.Step_Id__c+' Type>:'+srt.Type__c+' Access_Code_Saved__c>:'+srt.Access_Code_Saved__c+' Id>:'+srt.Id+' AccountCode_Formula__c>:'+srt.AccountCode_Formula__c+' SRT_AccessiblityCheck__c>:'+srt.SRT_AccessiblityCheck__c+' isPerformed__c>:'+srt.isPerformed__c+' Assignment__c>:'+srt.Assignment__c);
}*/
                    
                    if(srt.AccountCode_Formula__c ==null || srt.AccountCode_Formula__c.trim()=='' || srt.AccountCode_Formula__c.trim()=='Select One' 
                       || srt.type__c =='Overlap' || srt.SRT_ID__c ==null || srt.SRT_ID__c =='0'
                       || (srt.SRT_AccessiblityCheck__c==false && srt.isPerformed__c==false) ){
                           //system.debug('returning srt... srt.AccountCode_Formula__c:'+srt.AccountCode_Formula__c+' srt.SRT_ID__c>:'+srt.SRT_ID__c);
                           continue;
                       }
                    //system.debug('after... srtObj.AccountCode_Formula__c:'+srtObj.AccountCode_Formula__c+' srtObj.SRT_ID__c>:'+srtObj.SRT_ID__c+' srtObj.Step_Id__c>:'+srtObj.Step_Id__c);
                    
                    //Preparing SRTs list to do logic
                    //Below is for Diag
                    if(srt.solution_number__c != null && srt.solution_number__r.Diagnostic_Response__c!=null 
                       && (srt.Type__c != null && srt.Type__c != '' && (srt.Type__c.equalsIgnoreCase('Diagnosis') || srt.Type__c.equalsIgnoreCase('Diag Access')) 
                           && (srt.srt_category__c == null || srt.srt_category__c == ''))){
                               dupCheckList.add(srt);
                               System.debug('in Diag condition'+srt);
                           }else if(srt.solution_number__c==null && ((srt.Type__c.equalsIgnoreCase('Repair') || srt.Type__c.equalsIgnoreCase('Repair Access')) 
                                                                     && srt.srt_category__c == null &&  srt.Assignment__c.equalsIgnoreCase('Diagnostic'))){
                                                                         dupCheckList.add(srt);
                                                                         System.debug('in Repair condition'+srt);
                                                                     }else if((srt.srt_category__c != null && srt.srt_category__c != '' && (srt.srt_category__c.equalsIgnoreCase('AdditionalDiag') || srt.srt_category__c.equalsIgnoreCase('AdditionalRep') 
                                                                                                                                            || srt.srt_category__c.equalsIgnoreCase('Campaign') || srt.srt_category__c.equalsIgnoreCase('TRP') || srt.srt_category__c.equalsIgnoreCase('ATC')) )){ 
                                                                                                                                                dupCheckList.add(srt);
                                                                                                                                                System.debug('in Campaign 1st condition'+srt);
                                                                                                                                                //Below is for Repair
                                                                                                                                            }else if( ((srt.Assignment__c ==null || (srt.Assignment__c !=null && srt.Assignment__c.equalsIgnoreCase('Primary') || srt.Assignment__c.equalsIgnoreCase('Progressive Damage') || srt.Assignment__c.equalsIgnoreCase('Alternative')))) 
                                                                                                                                                     && srt.solution_number__r.Diagnostic_Response__c !=null && srt.solution_number__r.Diagnostic_Response__c == 'Most likely the solution' 
                                                                                                                                                     && (srt.Type__c != null && srt.Type__c != '' && (srt.Type__c.equalsIgnoreCase('Repair') || srt.Type__c.equalsIgnoreCase('Repair Access')) && srt.srt_category__c == null) ){
                                                                                                                                                         dupCheckList.add(srt);
                                                                                                                                                         System.debug('in Repair 2nd condition'+srt);
                                                                                                                                                     }else if( ((srt.Assignment__c ==null || (srt.Assignment__c !=null && srt.Assignment__c.equalsIgnoreCase('Primary') || srt.Assignment__c.equalsIgnoreCase('Progressive Damage') || srt.Assignment__c.equalsIgnoreCase('Alternative')))) 
                                                                                                                                                              && srt.solution_number__c==null && ((srt.Type__c.equalsIgnoreCase('Repair') || srt.Type__c.equalsIgnoreCase('Repair Access')) 
                                                                                                                                                                                                  && srt.srt_category__c == null && (srt.Assignment__c!='Diagnostics' || srt.Assignment__c!='DIAGNOSTIC'))){
                                                                                                                                                                                                      dupCheckList.add(srt);
                                                                                                                                                                                                      System.debug('in Repair 3rd condition'+srt);
                                                                                                                                                                                                      //}
                                                                                                                                                                                                      //Below is for Field Actions
                                                                                                                                                                                                  }else if( (srt.Assignment__c != 'NOT CLAIMABLE' && srt.Type__c != null && srt.Type__c != '') 
                                                                                                                                                                                                           && (srt.Type__c.equalsIgnoreCase('Field Action') && (srt.srt_type__c == 'Campaign' || srt.srt_type__c == 'TRP' || srt.srt_type__c == 'ATC')) 
                                                                                                                                                                                                           || (srt.Type__c.equalsIgnoreCase('Field Action Access') && (srt.Component_Id__r.type__c == 'Campaign' || srt.Component_Id__r.type__c == 'TRP' || srt.Component_Id__r.type__c == 'ATC')) ){
                                                                                                                                                                                                               dupCheckList.add(srt);
                                                                                                                                                                                                               System.debug('in Campaign 2nd condition'+srt);
                                                                                                                                                                                                               //}
                                                                                                                                                                                                           }else {
                                                                                                                                                                                                               System.debug('in else condition'+srt);
                                                                                                                                                                                                           }
                }
                
            }
            srtList = null;
            system.debug('buildDuplicateAccessCodesLogic loading... ***dupCheckList size:'+dupCheckList.size());
            
            String errorMsgs = '';
            if(dupCheckList != null && dupCheckList.size()>0){
                errorMsgs = CG_UtilityForSRT.buildDuplicateAccessCodesLogic(dupCheckList,false,true);
            }
            system.debug('errorMsgs>>>:'+errorMsgs);
            
            //update Claim with SRT errorMsgs
            if(claimsRec !=null){
                claimsRec.DupAccessCodePercentReqMsg__c = errorMsgs;
                update claimsRec;
            }
            
        }catch (exception ex){
            system.debug('catch exception in buildDuplicateAccessCodesLogic from CG_CL_ClaimsSRTs class at line number>:'+ex.getLineNumber()+' with error message '+ex.getMessage());
        } 
    }
    
    
}