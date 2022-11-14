/**********************************************************************
Name:CG_CL_ClaimsWarranty
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
We are using this  Controller for  Claims Customer's Complaint Page.
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -      Prabhakar.R      1/22/2018           INITIAL DEVELOPMENT   
1.0 -      Surender M       02/12/2018          Added Constructor & Updated Navigations
***********************************************************************/
public class CG_CL_ClaimsCC{

    public CG_CL_ClaimsCC controllerRef{set;get;}
    public boolean iscustomer{get;set;}
    public Id cId{get;set;}
    public CSS_Claims__c claimsRec{set;get;}
    public CSS_PSN__c psnRec{set;get;}
    public Boolean psncheck {get;set;}
    public List<CSS_Solution_Component__c> solComps;
    public boolean checkAccountCode{get; set;}
    public CG_CL_ClaimsIntake mainContr{set; get;}
    public String filterCategory;
    public String filterCategory2;
    public String filterCategory3;
    public String filterCategory4;
    public String filterCategory5;

    public String filterComplaintType;
    public String filterComplaintType2;
    public String filterComplaintType3;
    public String filterComplaintType4;
    public String filterComplaintType5;
    public boolean isAutomatedDealer{get; set;}
    //Constructor.
    public CG_CL_ClaimsCC()
    {
        System.debug('IN CG_CL_ClaimsCC constructor...');
        try {
            psncheck = false;
            checkAccountCode=false;
            iscustomer=false;
            isAutomatedDealer = false;
            solComps = new List<CSS_Solution_Component__c>();
            controllerRef = this;
            cId=ApexPages.CurrentPage().getParameters().get('id');
            system.debug('MyClaimId**'+cId);
            UserRole urRole;
            //urRole = [Select name from UserRole where id=:UserInfo.getUserRoleId()];
            if(cId == null) {
                claimsRec = new CSS_Claims__c();  
                psnRec = new CSS_PSN__c();
            } else {    
                /*claimsRec =[Select Id,LastSavedDate__c,	Last_saved_by__c,Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c,ODM_Status__c,Status__c,Account__r.Type,Customer_Name__c,FieldActionWebServiceResult__c,Location__c,Dealer_Service_Job__r.Name,Location_Code__c,Information_Only_Claim__c,Multi_PSN_Claim__c,CSS_Job__c,CSS_Job__r.CreatedDate,CSS_Job__r.name,CSS_Job__r.General_Symptoms__c,CSS_Job__r.Preventive_Maintenance__c,CSS_Job__r.Expedited_Service__c,CSS_Job__r.Category__c,CSS_Job__r.Category2__c,CSS_Job__r.Category3__c,CSS_Job__r.Category4__c,CSS_Job__r.Category5__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Category2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Category4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type__c,CSS_Job__r.Complaint_Type2__c,CSS_Job__r.Complaint_Type3__c,CSS_Job__r.Complaint_Type4__c,CSS_Job__r.Complaint_Type5__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Shop_Work_Order__c,LastModifiedDate,Name,ESN__c, createdDate,Region__c,Territory__c,CoverageResponse__c,Claims_Additional_Comments__c,Claims_Category__c,Claims_Category_Desc__c,Claims_Category2__c,Claims_Category2_Desc__c,Claims_Category3__c,Claims_Category3_Desc__c,Claims_Category4__c,Claims_Category4_Desc__c,Claims_Category5__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,Claims_Complaint_Type5__c,Claims_Expedited_Service__c,Claims_General_Symptoms__c,Claims_Preventive_Maintenance__c,Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,
                            (Select Id,Name,PSN__c,ApplicationCode__c,Service_Model__c,Application__c,Before_In_Service__c,Make__c,Model__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSNs__r where Primary__c=true Limit 1) from CSS_Claims__c where id= :cId];
                            
                            system.debug('**claimsRec.Account__r.Type***'+claimsRec.Account__r.Type);
                            system.debug('**urRole.name***'+urRole.name);
                            system.debug('**claimsRec.Dealer_Service_Job__c***'+claimsRec.Dealer_Service_Job__c);
                
                            boolean DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type); 
                            
                            if((claimsRec.Dealer_Service_Job__c!=null || claimsRec.CSS_Job__c!=null) && DealerTypeFlag==true && urRole.name == 'Factory'){
                                isAutomatedDealer = true;
                                system.debug('**isAutomatedDealer***'+isAutomatedDealer);
                            } else{
                                system.debug('**isAutomatedDealer else ***'+isAutomatedDealer);
                                system.debug('claimsRec.Dealer_Service_Job__c'+claimsRec.Dealer_Service_Job__c);
                                system.debug('claimsRec.Account__r.Type'+claimsRec.Account__r.Type);
                                isAutomatedDealer = false;
                            }*/
  //****************************************************************Getting Multi-PSN chevron basend on condition from Solution component Object 154239 By RAJESH *****************************************************************************************************                
                /*solComps = [select Id, Claim_FailCode__c,Fail_Code__c,type__c,Selected_Component__c,AccountCode__c,CSS_Account_Formula__c
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
            }*/
//**************************************************************************END 154239 ************************************************************************************8                 

                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    psnRec = claimsRec.CSS_PSNs__r.get(0);
                }else
                    psnRec = new CSS_PSN__c(); 
                system.debug('claimsRec>>>>:'+claimsRec);
                system.debug('psnRec>>>>:'+psnRec);
                if (claimsRec.Claims_Category_Desc__c==null || claimsRec.Claims_Category_Desc__c=='--None--' || claimsRec.Claims_Category_Desc__c==''){
                    filterCategory = '--None--';}else{
                    filterCategory = claimsRec.Claims_Category_Desc__c;
                }
                if (claimsRec.Claims_Category2_Desc__c==null || claimsRec.Claims_Category2_Desc__c=='--None--' || claimsRec.Claims_Category2_Desc__c==''){
                    filterCategory2 = '--None--';}else{
                    filterCategory2 = claimsRec.Claims_Category2_Desc__c;
                }
                if (claimsRec.Claims_Category3_Desc__c==null || claimsRec.Claims_Category3_Desc__c=='--None--' || claimsRec.Claims_Category3_Desc__c==''){
                    filterCategory3 = '--None--';}else{
                    filterCategory3 = claimsRec.Claims_Category3_Desc__c;
                }
                if (claimsRec.Claims_Category4_Desc__c==null || claimsRec.Claims_Category4_Desc__c=='--None--' || claimsRec.Claims_Category4_Desc__c==''){
                    filterCategory4 = '--None--';}else{
                    filterCategory4 = claimsRec.Claims_Category4_Desc__c;
                }
                if (claimsRec.Claims_Category5_Desc__c==null || claimsRec.Claims_Category5_Desc__c=='--None--' || claimsRec.Claims_Category5_Desc__c==''){
                    filterCategory5 = '--None--';}else{
                    filterCategory5 = claimsRec.Claims_Category5_Desc__c;
                }

                if (claimsRec.Complaint_Type_Desc__c==null || claimsRec.Complaint_Type_Desc__c=='--None--' || claimsRec.Complaint_Type_Desc__c==''){
                    filterComplaintType = '--None--';}else{
                    filterComplaintType = claimsRec.Complaint_Type_Desc__c;
                }
                if (claimsRec.Complaint_Type2_Desc__c==null || claimsRec.Complaint_Type2_Desc__c=='--None--' || claimsRec.Complaint_Type2_Desc__c==''){
                    filterComplaintType2 = '--None--';}else{
                    filterComplaintType2 = claimsRec.Complaint_Type2_Desc__c;
                }
                if (claimsRec.Complaint_Type3_Desc__c==null || claimsRec.Complaint_Type3_Desc__c=='--None--' || claimsRec.Complaint_Type3_Desc__c==''){
                    filterComplaintType3 = '--None--';}else{
                    filterComplaintType3 = claimsRec.Complaint_Type3_Desc__c;
                }
                if (claimsRec.Complaint_Type4_Desc__c==null || claimsRec.Complaint_Type4_Desc__c=='--None--' || claimsRec.Complaint_Type4_Desc__c==''){
                    filterComplaintType4 = '--None--';}else{
                    filterComplaintType4 = claimsRec.Complaint_Type4_Desc__c;
                }
                if (claimsRec.Complaint_Type5_Desc__c==null || claimsRec.Complaint_Type5_Desc__c=='--None--' || claimsRec.Complaint_Type5_Desc__c==''){
                    filterComplaintType5 = '--None--';}else{
                    filterComplaintType5 = claimsRec.Complaint_Type5_Desc__c;
                }
            }
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_ClaimsCC constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_ClaimsCC constructor...');
    }

    public String getfilterCategory() 
    {
        System.debug('********getfilterCategory'+filterCategory );
        return filterCategory;
    }
    public void setfilterCategory(String mfilterCategory) 
    {
        this.filterCategory = mfilterCategory; 
        System.debug('********setfilterCategory'+mfilterCategory);
    }
    public String getfilterCategory2() 
    {
        System.debug('********getfilterCategory2'+filterCategory2 );
        return filterCategory2;
    }
    public void setfilterCategory2(String mfilterCategory2) 
    {
        this.filterCategory2 = mfilterCategory2; 
        System.debug('********setfilterCategory2'+mfilterCategory2);
    }
    public String getfilterCategory3() 
    {
        System.debug('********getfilterCategory3'+filterCategory3);
        return filterCategory3;
    }
    public void setfilterCategory3(String mfilterCategory3) 
    {
        this.filterCategory3 = mfilterCategory3; 
        System.debug('********setfilterCategory3'+mfilterCategory3);
    }
    public String getfilterCategory4() 
    {
        System.debug('********getfilterCategory4'+filterCategory4 );
        return filterCategory4;
    }
    public void setfilterCategory4(String mfilterCategory4) 
    {
        this.filterCategory4 = mfilterCategory4; 
        System.debug('********setfilterCategory4'+mfilterCategory4);
    }
    public String getfilterCategory5() 
    {
        System.debug('********getfilterCategory5'+filterCategory5 );
        return filterCategory5;
    }
    public void setfilterCategory5(String mfilterCategory5) 
    {
        this.filterCategory5 = mfilterCategory5; 
        System.debug('********setfilterCategory5'+mfilterCategory5);
    }

    public String getfilterComplaintType() 
    {
        System.debug('********getfilterComplaintType'+filterComplaintType);
        return filterComplaintType;

    }
    public void setfilterComplaintType(String mfilterComplaintType) 
    {
        this.filterComplaintType = mfilterComplaintType; 
        System.debug('********setfilterComplaintType'+mfilterComplaintType);
    }
    public String getfilterComplaintType2() 
    {
        System.debug('********getfilterComplaintType2'+filterComplaintType2);
        return filterComplaintType2;

    }
    public void setfilterComplaintType2(String mfilterComplaintType2) 
    {
        this.filterComplaintType2 = mfilterComplaintType2; 
        System.debug('********setfilterComplaintType2'+mfilterComplaintType2);
    }
    public String getfilterComplaintType3() 
    {
        System.debug('********getfilterComplaintType3'+filterComplaintType3);
        return filterComplaintType3;

    }
    public void setfilterComplaintType3(String mfilterComplaintType3) 
    {
        this.filterComplaintType3 = mfilterComplaintType3; 
        System.debug('********setfilterComplaintType3'+mfilterComplaintType3);
    }
    public String getfilterComplaintType4() 
    {
        System.debug('********getfilterComplaintType4'+filterComplaintType4);
        return filterComplaintType4;

    }
    public void setfilterComplaintType4(String mfilterComplaintType4) 
    {
        this.filterComplaintType4 = mfilterComplaintType4; 
        System.debug('********setfilterComplaintType4'+mfilterComplaintType4);
    }
    public String getfilterComplaintType5() 
    {
        System.debug('********getfilterComplaintType5'+filterComplaintType5);
        return filterComplaintType5;

    }
    public void setfilterComplaintType5(String mfilterComplaintType5) 
    {
        this.filterComplaintType5 = mfilterComplaintType5; 
        System.debug('********setfilterComplaintType5'+mfilterComplaintType5);
    }

    CSS_WPR_SBL_CatComplaintsListResJSON  resCatCompJSON;
    public List<SelectOption> getCategoryList() {
        List<SelectOption> lstCategory; 
        Set<SelectOption> setCategory;
        try {

            CSS_JobEventTemporary__c[] Categories;

            Categories = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'CategoryComplaintCodes'];
            system.debug('Categories>>>'+Categories);
            string jsonResponse = Categories[0].Reason__c;

            //jsonResponse='{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
            resCatCompJSON = (CSS_WPR_SBL_CatComplaintsListResJSON )JSON.deserialize(jsonResponse ,CSS_WPR_SBL_CatComplaintsListResJSON .class);

            lstCategory = new List<SelectOption>();
            setCategory= new Set<SelectOption>();
            lstCategory.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y'){

                        //lstCategory.add(new SelectOption(det.Category,det.Category));
                        setCategory.add(new SelectOption(det.Category,det.Category));

                    }
                }
                lstCategory.addAll(setCategory);
            }

            system.debug('lstCategory>>>'+lstCategory);

            //lstCategory.sort();
        }
        catch(exception e)
        {}
        return lstCategory;
    }


    public List<SelectOption> getComplaintTypeList() {
        List<SelectOption> lstComplaint; 
        try {
            filterCategory=mainContr.ClaimsRec.Claims_Category_Desc__c;
            system.debug('filterCategory>>>'+filterCategory);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);

            lstComplaint = new List<SelectOption>();
            lstComplaint.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory){
                        lstComplaint.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }

            system.debug('lstComplaint>>>'+lstComplaint);

            lstComplaint.sort();
        }
        catch(exception e)
        {}
        return lstComplaint;
    }

    //Method to get Complaint Type2 values from siebel web service
    public List<SelectOption> getComplaintTypeList2() {
        List<SelectOption> lstComplaint2; 
        try {
            filterCategory2=mainContr.ClaimsRec.Claims_Category2_Desc__c;
            system.debug('filterCategory2>>>'+filterCategory2);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);

            lstComplaint2 = new List<SelectOption>();
            lstComplaint2.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory2){
                        lstComplaint2.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }

            system.debug('lstComplaint2>>>'+lstComplaint2);

            lstComplaint2.sort();
        }
        catch(exception e)
        {}
        return lstComplaint2;
    }

    //Method to get Complaint Type3 values from siebel web service
    public List<SelectOption> getComplaintTypeList3() {
        List<SelectOption> lstComplaint3; 
        try {
            filterCategory3=mainContr.ClaimsRec.Claims_Category3_Desc__c;
            system.debug('filterCategory3>>>'+filterCategory3);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);

            lstComplaint3 = new List<SelectOption>();
            lstComplaint3.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory3){
                        lstComplaint3.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }

            system.debug('lstComplaint3>>>'+lstComplaint3);

            lstComplaint3.sort();
        }
        catch(exception e)
        {}
        return lstComplaint3;
    }

    //Method to get Complaint Type4 values from siebel web service
    public List<SelectOption> getComplaintTypeList4() {
        List<SelectOption> lstComplaint4; 
        try {
            filterCategory4=mainContr.ClaimsRec.Claims_Category4_Desc__c;
            system.debug('filterCategory4>>>'+filterCategory4);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);

            lstComplaint4 = new List<SelectOption>();
            lstComplaint4.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory4){
                        lstComplaint4.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }

            system.debug('lstComplaint4>>>'+lstComplaint4);

            lstComplaint4.sort();
        }
        catch(exception e)
        {}
        return lstComplaint4;
    }

    //Method to get Complaint Type5 values from siebel web service
    public List<SelectOption> getComplaintTypeList5() {
        List<SelectOption> lstComplaint5; 
        try {
            filterCategory5=mainContr.ClaimsRec.Claims_Category5_Desc__c;
            system.debug('filterCategory5>>>'+filterCategory5);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);

            lstComplaint5 = new List<SelectOption>();
            lstComplaint5.add(new SelectOption('','----None----'));

            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory5){
                        lstComplaint5.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }

            system.debug('lstComplaint5>>>'+lstComplaint5);

            lstComplaint5.sort();
        }
        catch(exception e)
        {}
        return lstComplaint5;
    }

    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsIntake(){
        PageReference pageRef;
        cId = saveCC(cId, 'Draft');
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsIntake'); 
        }else{
            
            pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); 
        }
        return pageRef;
    }

    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsWC(){
        PageReference pageRef;
        cId = saveCC(cId, 'Draft');
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsWarranty'); 
        }else{
            
            pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId); 
        }
        return pageRef;
    }

    //Naviagation to View History.
    public PageReference nvClaimsVH(){
        PageReference pageRef;
        cId = saveCC(cId, 'Draft');
        
        
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
        cId = saveCC(cId, 'Draft');
        
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsCC'); 
        }else{
            
            pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); 
        }
        return pageRef;
    }

    //Naviagation to Failures and Campaigns.
    public PageReference nvClaimsFC(){
        PageReference pageRef;
        cId = saveCC(cId, 'Draft');
        
        
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsFC'); 
        }else{
            
            pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId); 
        }
        return pageRef;
    }
//Added below Method as per Silicon Valley sprint #154239 -By RAJESH 20th Aug 2018
    public PageReference nvClaimsPSN(){
        PageReference pageRef;
        cId = saveCC(cId, 'Draft');
        
        
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsMultiPSN'); 
        }else{
            
            pageRef = new pageReference('/apex/CG_ClaimsMultiPSN?id='+cId); 
        }
        return pageRef;
    }
    //End
    //Naviagation to Parts and Other Claimbles.
    public PageReference nvClaimsPOC(){
        PageReference pageRef;
        cId = saveCC(cId, 'Draft');
        
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles'); 
        }else{
            
            pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId);
        }
        return pageRef;
    }

    //Naviagation to SRTs.
    public PageReference nvClaimsSRTs(){
        PageReference pageRef;
        cId = saveCC(cId, 'Draft');
        
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsSRTs'); 
        }else{
            
            pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId);
        }
        return pageRef;
    }

    //Naviagation to Job Notes.
    public PageReference nvClaimsJobNotes(){
        PageReference pageRef;
        cId = saveCC(cId, 'Draft');
        
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
        cId = saveCC(cId, 'Draft');
        
        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVS'); 
        }else{
            
            pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId); 
        }
        return pageRef;
    }

    //Bottom save button 
    /*public PageReference pgSave(){

        system.debug('IN CG_CL_IntakeCC-pgSave method...');
        system.debug('controllerRef ' + controllerRef);
        // system.debug('workJob ' + workJob);
        //system.debug('userERPSystem ' + userERPSystem);
        try 
        {
            if (ChkFieldBlank() =='BLANK') 
            {
                return null;
            } else 
            {
                Id sClaimId = saveCC(cId,'Draft');
                system.debug('sClaimId..... ' + sClaimId);
                PageReference pageRef = new pageReference('/apex/CG_ClaimsCC?id='+sClaimId); 
                pageRef.setRedirect(true);
                System.debug('OUT CG_CL_IntakeCC-pgSave method...');            
                return pageRef;
            }
            return null;            
        } 
        catch(exception e) 
        {
            system.debug('EXCEPTION of CG_CL_IntakeCC pgSave method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }
    }*/

    public id saveCC(id inpClaimId, String status){
        Id ClaimId;
        iscustomer = false;
        CSS_Claims__c cId = new CSS_Claims__c();
        try{
            
            //Rajasekhar added Validations for Category and Complaint//
            
            cId.User_Landed_CC__c = true;
             //End of Validations   

            system.debug('**Enter into CC class with in SaveCC method***');
            system.debug('**filterCategory***' + filterCategory);
            system.debug('**claimsRec.Claims_Category_Desc__c***' + claimsRec.Claims_Category_Desc__c );
            system.debug('**claimsRec.Claims_Category__c***' + claimsRec.Claims_Category__c );
            system.debug('**mainContr.claimsRec.Claims_Category_Desc__c***' + mainContr.claimsRec.Claims_Category_Desc__c );
            system.debug('**mainContr.claimsRec.Claims_Category__c***' + mainContr.claimsRec.Claims_Category__c );
            cId.Claims_Category_Desc__c = filterCategory;
            cId.Claims_Category2_Desc__c = filterCategory2;
            cId.Claims_Category3_Desc__c = filterCategory3;
            cId.Claims_Category4_Desc__c = filterCategory4;
            cId.Claims_Category5_Desc__c = filterCategory5;
            cId.Complaint_Type_Desc__c = filterComplaintType;
            cId.Complaint_Type2_Desc__c = filterComplaintType2;
            cId.Complaint_Type3_Desc__c = filterComplaintType3;
            cId.Complaint_Type4_Desc__c = filterComplaintType4;
            cId.Complaint_Type5_Desc__c = filterComplaintType5;
            cId.Claims_Preventive_Maintenance__c = claimsRec.Claims_Preventive_Maintenance__c;
            cId.Claims_Expedited_Service__c = claimsRec.Claims_Expedited_Service__c;
            cId.Claims_General_Symptoms__c = claimsRec.Claims_General_Symptoms__c;
            cId.Claims_Additional_Comments__c = claimsRec.Claims_Additional_Comments__c;
            cId.Status__c = status;
            
            system.debug('claimsRec.FieldActionWebServiceResult__c***' + claimsRec.FieldActionWebServiceResult__c );
            
            // calling FieldAction WebService in case of failure response on chevron navigation
            if(claimsRec.FieldActionWebServiceResult__c == 'Error'){
                string FailureDateString;
                if(psnRec.Failure_Date__c != null){
                    FailureDateString = DateTime.newInstance(psnRec.Failure_Date__c.year(),psnRec.Failure_Date__c.month(),psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                }
                cId.FieldActionWebServiceResult__c = CG_BL_Campaigns.callGetCampaignsWebServiceforClaimsOnChevronChangeClaim(psnRec.PSN__c, FailureDateString, claimsRec.Region__c,'', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', psnRec.CSS_Claims__c);
            }
        }

        catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeUE pgSave method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }
        cId.Id = inpClaimId;
        system.debug('Upserting Claim-->'+cId);
        upsert cId;
        system.debug('Upserting Claim-->'+cId);
        ClaimId = cId.id;    
        return ClaimId;

    } 



    public string ChkFieldBlank()
    {
        try{
            //Modified as per story# 64030
            if ( (claimsRec.Claims_General_Symptoms__c == null || claimsRec.Claims_General_Symptoms__c == '') && (claimsRec.Claims_Category__c == null || claimsRec.Claims_Category__c == '') && (claimsRec.Claims_Complaint_Type__c == null || claimsRec.Claims_Complaint_Type__c == '') )
            {
                System.Debug('in BLANK==============');
                return 'BLANK'; 
            }
            else
            {
                System.Debug('in FILLED==============');
                return 'FILLED';
            }
        } catch(exception e) {
            system.debug('EXCEPTION of CG_CL_IntakeUE ChkFieldBlank method >>> '+e.getMessage() + e.getLineNumber());
            return null;
        }
        //add all fields check for null with OR condition
    }
    
    public List<SelectOption> getPreventiveMaintenance() { 
        Schema.DescribeFieldResult fieldResult = CSS_Claims__c.Claims_Preventive_Maintenance__c.getDescribe();
        List<Schema.PicklistEntry> lstPrevMaintenance = fieldResult.getPicklistValues();
        System.debug('Picklist::'+ lstPrevMaintenance);

        List<SelectOption> lstPrevMaintenance1=new List<SelectOption>();
        for( Schema.PicklistEntry entry : lstPrevMaintenance){
            lstPrevMaintenance1.add(new SelectOption(entry.getValue(),entry.getLabel()));
        }
        system.debug('LstAppValues1---->'+lstPrevMaintenance1); 
        return lstPrevMaintenance1;

    }
    
    public List<SelectOption> getExpeditedService() { 
        Schema.DescribeFieldResult fieldResult = CSS_Claims__c.Claims_Expedited_Service__c.getDescribe();
        List<Schema.PicklistEntry> lstExpeService = fieldResult.getPicklistValues();
        System.debug('Picklist::'+ lstExpeService);

        List<SelectOption> lstExpeService1=new List<SelectOption>();
        for( Schema.PicklistEntry entry : lstExpeService){
            lstExpeService1.add(new SelectOption(entry.getValue(),entry.getLabel()));
        }
        system.debug('LstAppValues1---->'+lstExpeService1); 
        return lstExpeService1;

    }
}