public class CSS_jobClosure {
   
    public ID Wid;
    public css_job_order__c workJob{get;set;}
    public Boolean displayPopup {get;set;}
    public boolean showResolution{get;set;}
    public boolean showResolutionWithRepair{get;set;}
    public boolean showRepairs{get;set;}
    public list<CSS_Solutions__c> solutions {get;set;}
    public List<CSS_Solutions__c> responseValues{get;set;}
    public Boolean nocamptsbtrps{get;set;}
    public List<selectOption> responseOptions{get;set;}
    public List<selectOption> resolutionOptions{get;set;}
    
    public ID JobID {get;
        set{
            JobID=value;
        }
    }
    public void showPopup() {
        displayPopup = true;
    }
    public CSS_jobClosure(){
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        showResolutionWithRepair = FALSE;
        showResolution = FALSE;
        showRepairs = FALSE;
        if(Wid != null){
            
            resolutionOptions = new list<SelectOption>();
            List<Schema.PicklistEntry> ple = CSS_Job_Order__c.CSS_Resolution__c.getDescribe().getPicklistValues();
            if(ple != null && !ple.isEmpty()){
                for(Schema.PicklistEntry f : ple){
                    resolutionOptions.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }     
            responseValues = new list<CSS_Solutions__c>();
            responseOptions = new List<selectOption>();
            List<Schema.PicklistEntry> pickVal = CSS_Solutions__c.Repair_response__c.getDescribe().getPicklistValues();
            if(pickVal != null && !pickVal.isEmpty()){
                for(Schema.PicklistEntry values : pickVal){
                    responseOptions.add(new SelectOption(values.getLabel(), values.getValue()));
                }
            } 
         
            workJob=[Select Id,Name, CSS_Feedback_Comments__c,css_resolution__c,customer_name__c,
                    (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,
                     Solution_Title__c ,Solution__c
                     FROM CSS_Solutions__r where Solution__c != null),
                    (Select id, name , performed__c, performed_review__c, Reviewed__c 
                     from CSS_CampTsbTrp__r 
                     where( job_order__C=:Wid and( performed_review__c=True and performed__c=False)))                    
                    from CSS_Job_Order__c where id= :Wid];
            
            if(workJob != null){
               if(workJob.CSS_CampTsbTrp__r == null || workJob.CSS_CampTsbTrp__r.isEmpty()) 
                { nocamptsbtrps=false;
                if(workJob.CSS_Solutions__r == null || workJob.CSS_Solutions__r.isEmpty()){
                    showResolution = TRUE;
                    showRepairs = FALSE;
                }else{
                    list<CSS_Solutions__c> repairSolutions = new list<CSS_Solutions__c>();
                    for(CSS_Solutions__c soluRec : workJob.CSS_Solutions__r){
                        if(soluRec.Solution__c.equalsIgnoreCase('Solution1')){
                            repairSolutions.add(soluRec);
                        }
                    }System.debug('repairSolutions'+repairSolutions);
                    if(repairSolutions.isEmpty()){
                        showResolution = TRUE;
                        showRepairs = FALSE;
                    }else{
                        list<CSS_Solutions__c> noRepairList = new list<CSS_Solutions__c>();
                        list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
                        for(CSS_Solutions__c solRec:repairSolutions){
                          if(solRec.Repair_Response__c == null){
                              noRepairList.add(solRec);
                              responseValues.add(solRec);
                          } else if(solRec.Repair_Response__c.contains('Successful')){
                               postRepairList.add(solRec);
                            }
                        }
                        
                        if(!noRepairList.isEmpty()){                          
                            showResolution = FALSE;
                            showRepairs = TRUE;                                                     
                        }
                        
                        if(noRepairList.isEmpty() && postRepairList.isEmpty()){
                            showResolution = TRUE;
                            showRepairs = FALSE;
                        }                        
                       
                    }
                } }   
                else{
                    nocamptsbtrps= true;
                    }            
            }
        }
    }
     
    public PageReference pgSaveFinish()
    {
        PageReference pageRef;
        if(showRepairs){
            list<CSS_Solutions__c> negatRepairs = new list<CSS_Solutions__c>();
            if(!responseValues.isEmpty()){
                for(CSS_Solutions__c solRec : responseValues){
                    if(solRec.Repair_Response__c != null && !solRec.Repair_Response__c.contains('Successful')){
                        negatRepairs.add(solRec);
                    }
                }//end of For
                if(!negatRepairs.isEmpty() && !responseValues.isEmpty() && negatRepairs.size() == responseValues.size()){
                    showResolutionWithRepair = TRUE;
                }else{
                    showResolutionWithRepair = FALSE;
                    workJob.Status__c='Closed';
                    update workJob;
                    if(!responseValues.isEmpty()){
                        update responseValues;
                    }
                    pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
                    pageRef.setRedirect(true);                    
                }
            }
        }//end of If repairs
        
        if(showResolutionWithRepair || showResolution){
            if(workJob.CSS_Resolution__c != null){                
                workJob.Status__c='Closed';
                update workJob;
                if(!responseValues.isEmpty()){
                    update responseValues;
                } 
                pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
                pageRef.setRedirect(true);
            }
        }    
        
        System.Debug('record updated====='+workJob);            
        
        return pageRef;
    } 
    

}