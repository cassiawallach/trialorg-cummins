public class CSS_4c_CompClass {
     
       public Transient list<css_jobHistory__c> FourCNotes;
      public Transient List<CSS_SRT__c> nonSRTList{get;set;}

     public Transient String notesdesc {
        get;
        set {
            notesdesc = value;
        }
    }
    public Transient ID JobID {get;set{
        JobID=value; 
        system.debug('JobID>>>>'+JobID);
        }}
    
    public Transient ID Wid;
    //Public string NotesNotEntered;
    Public Transient Boolean CauseNotesFlag{get;set;}
    Public Transient Boolean CorrectionNotesFlag{get;set;}
    Public Transient Boolean CoverageNotesFlag{get;set;}
    public Transient Boolean CompNotesFlag{get;set;}
    public Transient Boolean nonSRTNotesFlag{get;set;}
    
    public CSS_4c_CompClass(){
    Wid=ApexPages.CurrentPage().getParameters().get('id'); 
        system.debug('Wid--->'+Wid);
        notesdesc ='1';
        CauseNotesFlag=false;  
        CorrectionNotesFlag = false;
        CoverageNotesFlag = false;
        CompNotesFlag = false;
        nonSRTNotesFlag = false;
        getFourCNotes();
    }
    
     public Transient list<notesWrapper> lstComplaintNotes {get;set;}
     public Transient list<notesWrapper> lstCauseNotes {get;set;}
     public Transient list<notesWrapper> lstCorrectionNotes {get;set;}
     public Transient list<notesWrapper> lstCoverageNotes {get;set;}
    
     public class notesWrapper{
         public Transient Id nId {get; set;}
         public Transient string nUserProfile {get; set;}
         public Transient string nLastModifiedDate {get; set;}
         public Transient string nfirstname {get; set;}
         public Transient string nNewValue {get; set;}
         public Transient string nOldValue {get; set;}
         public Transient string nObjectName {get; set;}
         public Transient string nJobID {get; set;}
         public Transient string nFieldName {get; set;}
         public Transient string nLastname {get; set;}
         public Transient string nCreatedId {get; set;}    
        
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
    }
        public List<SelectOption> getSortvalues() {
        List<SelectOption> SortList = new List<SelectOption>(); 
            
            SortList.add(new SelectOption('1',system.Label.css_Oldest_To_Newest));
            SortList.add(new SelectOption('2',system.Label.css_Newest_To_Oldest));
        
        return SortList;
    }
    
       public void getFourCNotes()
       {
       try{
        system.debug('notesdesc---'+notesdesc);
          
           if(notesdesc=='1')    
           {
                FourCNotes=[Select CreatedBy.UserRole.Name,CreatedBy.Profile.Name,CreatedBy.firstname,LastModifiedDate,CSS_New_Value__c,CSS_Field_Name__c ,css_Object_name__c,Name,css_Old_Value__c,css_Job_Id__c,CreatedDate,CreatedBy.lastname, CreatedById from css_jobHistory__c where css_Job_Id__c =:wid and (css_field_name__c='EditComplaint__c' OR css_field_name__c='EditCause__c' OR css_field_name__c='EditCorrection__c' OR css_field_name__c='EditCoverage__c') order by CreatedDate asc];  
                system.debug('FourCNotes--->'+FourCNotes); 
           }
          
          else if(notesdesc=='2'){
              FourCNotes=[Select CreatedBy.UserRole.Name,CreatedBy.Profile.Name,CreatedBy.firstname,LastModifiedDate,CSS_New_Value__c,CSS_Field_Name__c ,css_Object_name__c,Name,css_Old_Value__c,css_Job_Id__c,CreatedDate,CreatedBy.lastname, CreatedById from css_jobHistory__c where css_Job_Id__c =:wid and (css_field_name__c='EditComplaint__c' OR css_field_name__c='EditCause__c' OR css_field_name__c='EditCorrection__c' OR css_field_name__c='EditCoverage__c') order by CreatedDate desc];  
              system.debug('FourCNotes--->'+FourCNotes); 
           }
           
        Transient List<notesWrapper> nl = new List<notesWrapper>();
        for(css_jobHistory__c n: FourCNotes){
            nl.add(new notesWrapper(n));
        }
                 
        if(nl != null){
            lstComplaintNotes = new List<notesWrapper>();
            lstCauseNotes = new List<notesWrapper>();
            lstCorrectionNotes = new List<notesWrapper>();
            lstCoverageNotes = new List<notesWrapper>();
            for(notesWrapper wn: nl){ 

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