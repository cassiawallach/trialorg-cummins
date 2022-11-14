/*
 * Block comments with details of changes
 */
public class CG_CL_IntakeCCComp
{
    //public CG_CL_IntakeCC mainContr{set; get;}
    public CG_CL_IntakeRJ mainContr{get; set;}
    public Boolean Customer_Complaint2 {get;set;}
    public Boolean Customer_Complaint3 {get;set;}
    public Boolean Customer_Complaint4 {get;set;} 
    public Boolean Customer_Complaint5 {get;set;} 
    public String PageName {get;set;}
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
    public Id Wid;
    
    public CG_CL_IntakeCCComp()
    {
        System.debug('$$$$$$ in CG_CL_IntakeCCComp constructor $$$$$ mainContr>>:'+mainContr);
        //System.debug('$$$$$$$ in CG_CL_IntakeCCComp constructor...$$$$$$$$$$$$ mainContr.workJob>>>>:'+mainContr.workJob);
        try{
            mainContr= new CG_CL_IntakeRJ(); //Intialized the maincontroller on May 8 by Rajesh Narra as per defect 513
        Wid=ApexPages.CurrentPage().getParameters().get('id');
//flag values for complaint section in the intake page 
        Customer_Complaint2 = false;
        Customer_Complaint3 = false;
        Customer_Complaint4 = false;
        Customer_Complaint5 = false;
    
        if (Wid == null)
        {
            
        }else{
            System.debug('mainContr.workJob>>>>:'+mainContr.workJob);
     if (mainContr.workJob.Category_Desc__c==null || mainContr.workJob.Category_Desc__c=='----None----' || mainContr.workJob.Category_Desc__c==''){
                filterCategory = '----None----';}else{
                filterCategory = mainContr.workJob.Category_Desc__c;
            }
            if (mainContr.workJob.Category2_Desc__c==null || mainContr.workJob.Category2_Desc__c=='----None----' || mainContr.workJob.Category2_Desc__c==''){
                filterCategory2 = '----None----';}else{
                filterCategory2 = mainContr.workJob.Category2_Desc__c;
            }
            if (mainContr.workJob.Category3_Desc__c==null || mainContr.workJob.Category3_Desc__c=='----None----' || mainContr.workJob.Category3_Desc__c==''){
                filterCategory3 = '----None----';}else{
                filterCategory3 = mainContr.workJob.Category3_Desc__c;
            }
            if (mainContr.workJob.Category4_Desc__c==null || mainContr.workJob.Category4_Desc__c=='----None----' || mainContr.workJob.Category4_Desc__c==''){
                filterCategory4 = '----None----';}else{
                filterCategory4 = mainContr.workJob.Category4_Desc__c;
            }
            if (mainContr.workJob.Category5_Desc__c==null || mainContr.workJob.Category5_Desc__c=='----None----' || mainContr.workJob.Category5_Desc__c==''){
                filterCategory5 = '----None----';}else{
                filterCategory5 = mainContr.workJob.Category5_Desc__c;
            }

            if (mainContr.workJob.Complaint_Type_Desc__c==null || mainContr.workJob.Complaint_Type_Desc__c=='----None----' || mainContr.workJob.Complaint_Type_Desc__c==''){
                filterComplaintType = '----None----';}else{
                filterComplaintType = mainContr.workJob.Complaint_Type_Desc__c;
            }
            if (mainContr.workJob.Complaint_Type2_Desc__c==null || mainContr.workJob.Complaint_Type2_Desc__c=='----None----' || mainContr.workJob.Complaint_Type2_Desc__c==''){
                filterComplaintType2 = '----None----';}else{
                filterComplaintType2 = mainContr.workJob.Complaint_Type2_Desc__c;
            }
            if (mainContr.workJob.Complaint_Type3_Desc__c==null || mainContr.workJob.Complaint_Type3_Desc__c=='----None----' || mainContr.workJob.Complaint_Type3_Desc__c==''){
                filterComplaintType3 = '----None----';}else{
                filterComplaintType3 = mainContr.workJob.Complaint_Type3_Desc__c;
            }
            if (mainContr.workJob.Complaint_Type4_Desc__c==null || mainContr.workJob.Complaint_Type4_Desc__c=='----None----' || mainContr.workJob.Complaint_Type4_Desc__c==''){
                filterComplaintType4 = '----None----';}else{
                filterComplaintType4 = mainContr.workJob.Complaint_Type4_Desc__c;
            }
            if (mainContr.workJob.Complaint_Type5_Desc__c==null || mainContr.workJob.Complaint_Type5_Desc__c=='----None----' || mainContr.workJob.Complaint_Type5_Desc__c==''){
                filterComplaintType5 = '----None----';}else{
                filterComplaintType5 = mainContr.workJob.Complaint_Type5_Desc__c;
            }
        }
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCCComp constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
            
            
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
    
}