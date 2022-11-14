public class FSL_4c_CompClass {
    
    Transient public list<css_jobHistory__c> FourCNotes;
    public List<CSS_SRT__c> nonSRTList{get;set;}
    
    public String notesdesc {
        get;
        set {
            notesdesc = value;
        }
    }
    public ID JobID {get;set{
        JobID=value; 
        system.debug('JobID>>>>'+JobID);
    }}
    
    public ID Wid;
    public Id fslWOId {get;set;}
    //Public string NotesNotEntered;
    Public Boolean CauseNotesFlag{get;set;}
    Public Boolean CorrectionNotesFlag{get;set;}
    Public Boolean CoverageNotesFlag{get;set;}
    public Boolean CompNotesFlag{get;set;}
    public Boolean nonSRTNotesFlag{get;set;}
    
    public FSL_4c_CompClass(){
        system.debug('fslWOId>>>'+fslWOId);
        Wid=ApexPages.CurrentPage().getParameters().get('id'); 
        system.debug('Wid--->'+Wid);
        if(Wid != null)
            if(Wid.getSobjectType().getDescribe().getName()=='WorkOrder'){
                fslWOId=wid;
            }
        notesdesc ='1';
        CauseNotesFlag=false;  
        CorrectionNotesFlag = false;
        CoverageNotesFlag = false;
        CompNotesFlag = false;
        nonSRTNotesFlag = false;
        getFourCNotes();
    }
    
    Transient public list<notesWrapper> lstComplaintNotes {get;set;}
    Transient public list<notesWrapper> lstCauseNotes {get;set;}
    
    Transient public list<notesWrapper> lstCorrectionNotes {get;set;}
    Transient public list<notesWrapper> lstCoverageNotes {get;set;}
    
    public class notesWrapper{
        public Id nId {get; set;}
        public string nUserProfile {get; set;}
        public string nLastModifiedDate {get; set;}
        public string nfirstname {get; set;}
        public string nNewValue {get; set;}
        public string nOldValue {get; set;}
        public string nObjectName {get; set;}
        public string nJobID {get; set;}
        public string nFieldName {get; set;}
        public string nLastname {get; set;}
        public string nCreatedId {get; set;}    
        
        public notesWrapper(css_jobHistory__c n){
            this.nId=n.id;
            
            //system.debug('Profile'+n.CreatedBy.Profile.Name);
            
            if(n.CreatedBy.Profile.Name.contains('Technician')){
                this.nUserProfile='Technician';
            }
            else if(n.CreatedBy.Profile.Name.contains('Advanced')){
                this.nUserProfile='Advanced';
            }
            else if(n.CreatedBy.Profile.Name.contains('Supervisor')){
                this.nUserProfile='Supervisor';
            }
            else{
                this.nUserProfile=n.CreatedBy.Profile.Name;
            }
            
            this.nLastModifiedDate= n.CreatedDate.format('dd MMM YYYY hh:mm a z');
            this.nfirstname=n.CreatedBy.firstname;
            this.nLastname=n.CreatedBy.lastname;
            this.nCreatedId=n.CreatedById;
            this.nNewValue=n.CSS_New_Value__c;
            this.nOldValue=n.css_Old_Value__c;
            this.nObjectName=n.css_Object_name__c;
            this.nFieldName=n.CSS_Field_Name__c;
            this.nJobID=n.css_Job_Id__c;
            this.nCreatedId=n.CreatedById;
        }
        /*public notesWrapper(WorkorderHistory n){
            this.nId=n.id;
            //system.debug('Profile'+n.CreatedBy.Profile.Name);
            if(n.CreatedBy.Profile.Name.contains('Technician')){
            	this.nUserProfile='Technician';
            }
            else if(n.CreatedBy.Profile.Name.contains('Advanced')){
            	this.nUserProfile='Advanced';
            }
            else if(n.CreatedBy.Profile.Name.contains('Supervisor')){
            	this.nUserProfile='Supervisor';
            }
            else{
            	this.nUserProfile=n.CreatedBy.Profile.Name;
            }
            
            this.nLastModifiedDate= n.CreatedDate.format('dd MMM YYYY hh:mm a z');
            this.nfirstname=n.CreatedBy.firstname;
            this.nLastname=n.CreatedBy.lastname;
            this.nCreatedId=n.CreatedById;
            this.nNewValue=String.valueOf(n.newValue);
            this.nOldValue=String.valueOf(n.OldValue);
            this.nObjectName='WorkOrder';
            this.nFieldName=n.field;
            this.nJobID=n.WorkOrderId;
            this.nCreatedId=n.CreatedById;
        } */
    }
    public List<SelectOption> getSortvalues() {
        List<SelectOption> SortList = new List<SelectOption>(); 
        
        SortList.add(new SelectOption('1',system.Label.css_Oldest_To_Newest));
        SortList.add(new SelectOption('2',system.Label.css_Newest_To_Oldest));
        
        return SortList;
    }
    
    public void getFourCNotes()
    {
        List<WorkorderHistory> fsl4cNotes=new List<WorkorderHistory>();
        try{
            system.debug('notesdesc---'+notesdesc);
            
            //if(Wid.getSobjectType().getDescribe().getName()=='CSS_Job_Order__c')
            {
                if(notesdesc=='1')    
                {
                    FourCNotes=[Select CreatedBy.UserRole.Name,CreatedBy.Profile.Name,CreatedBy.firstname,LastModifiedDate,CSS_New_Value__c,CSS_Field_Name__c ,
                                css_Object_name__c,Name,css_Old_Value__c,css_Job_Id__c,CreatedDate,CreatedBy.lastname, CreatedById 
                                from css_jobHistory__c 
                                where css_Job_Id__c =:wid and 
                                (css_field_name__c='EditComplaint__c' OR 
                                 css_field_name__c='EditCause__c' OR 
                                 css_field_name__c='EditCorrection__c' OR 
                                 css_field_name__c='EditCoverage__c') order by CreatedDate asc];
                    system.debug('FourCNotes--->'+FourCNotes);
                }
                
                else if(notesdesc=='2'){
                    FourCNotes=[Select CreatedBy.UserRole.Name,CreatedBy.Profile.Name,CreatedBy.firstname,LastModifiedDate,
                                CSS_New_Value__c,CSS_Field_Name__c ,css_Object_name__c,Name,css_Old_Value__c,
                                css_Job_Id__c,CreatedDate,CreatedBy.lastname, CreatedById 
                                from css_jobHistory__c 
                                where css_Job_Id__c =:wid and 
                                (css_field_name__c='EditComplaint__c' OR 
                                 css_field_name__c='EditCause__c' OR 
                                 css_field_name__c='EditCorrection__c' OR 
                                 css_field_name__c='EditCoverage__c') order by CreatedDate desc];
                    system.debug('FourCNotes--->'+FourCNotes);
                }
            }
            /*else if(Wid.getSobjectType().getDescribe().getName()=='WorkOrder')
            {
                fsl4cNotes = [Select CreatedBy.UserRole.Name,CreatedBy.Profile.Name,CreatedBy.firstname,
                NewValue, OldValue,Field,WorkOrderId,CreatedDate,CreatedBy.lastname, CreatedById
                from WorkorderHistory
                where id=:wid AND
                (Field='EditComplaint__c' OR 
                Field='EditCause__c' OR 
                Field='EditCorrection__c' OR 
                Field='EditCoverage__c') order by CreatedDate desc];
            }*/
            
            Transient List<notesWrapper> nl = new List<notesWrapper>();
            // if(Wid.getSobjectType().getDescribe().getName()=='CSS_Job_Order__c')
            for( css_jobHistory__c n: FourCNotes){
                nl.add(new notesWrapper(n));
            }
            /*else if(Wid.getSobjectType().getDescribe().getName()=='WorkOrder')
            {
                for(WorkorderHistory n: fsl4cNotes){
                    nl.add(new notesWrapper(n));
                }
            }*/
            
            if(nl != null){
                lstComplaintNotes = new List<notesWrapper>();
                lstCauseNotes = new List<notesWrapper>();
                lstCorrectionNotes = new List<notesWrapper>();
                lstCoverageNotes = new List<notesWrapper>();
                for(notesWrapper wn: nl){ 
                    system.debug('nl>>'+nl);
                    if(wn.nFieldName.equalsIgnoreCase('EditComplaint__c')){
                        lstComplaintNotes.add(wn);
                        system.debug('lstComplaintNotes>>>>>'+lstComplaintNotes);
                    }
                    
                    if(wn.nFieldName.equalsIgnoreCase('EditCause__c')){
                        lstCauseNotes.add(wn);
                        system.debug('lstCauseNotes>>>>>'+lstCauseNotes);
                    }
                    
                    if(wn.nFieldName.equalsIgnoreCase('EditCorrection__c')){
                        lstCorrectionNotes.add(wn);
                        system.debug('lstCorrectionNotes>>>>>'+lstCorrectionNotes);
                    }
                    
                    if(wn.nFieldName.equalsIgnoreCase('EditCoverage__c')){
                        lstCoverageNotes.add(wn);
                        system.debug('lstCoverageNotes>>>>>'+lstCoverageNotes);
                    }
                }
                
                if(lstComplaintNotes.size()==0){
                    CompNotesFlag = true;
                }
                if(lstCauseNotes.size()==0){
                    CauseNotesFlag = true;
                }
                if(lstCorrectionNotes.size()==0){
                    CorrectionNotesFlag = true;
                }
                if(lstCoverageNotes.size()==0){
                    CoverageNotesFlag = true;
                }
            }
            nonSRTList = new List<CSS_SRT__c>();
            for(CSS_SRT__c srt : [SELECT id,SRT_Notes__c FROM CSS_SRT__c WHERE Job_order__c=:Wid AND Type__c='99Time']){
                
                if(srt.SRT_Notes__c!=null && srt.SRT_Notes__c!= ''){ 
                    nonSRTList.add(srt);
                }    
            }
            if(nonSRTList.size()==0){
                nonSRTNotesFlag = true;
            }
            
        }catch(exception e){}
    }
}