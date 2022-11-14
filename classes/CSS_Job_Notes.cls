public class CSS_Job_Notes {
    
    public List<CSS_Service_Notes_Log__c> extInt_notes {get;set;}
    public List<CSS_Service_Notes_Log__c> extTnD_notes {get;set;}
    public List<CSS_Service_Notes_Log__c> note_List;
    public String vPageName {get;set;}
    public String vUProfile {get;set;}
    public String vNotes {get;set;}
    public ID JobID {
        get;
        set {
            JobID = value;
            extInt_notes = [Select Id,Name,Note_Type__c, Actor__c, Notes__c, Job_Order__c, CreatedById, CreatedBy.Name, LastModifiedDate
                            from CSS_Service_Notes_Log__c where Job_Order__c= :JobID and Note_Type__c='Intake'];
            extTnD_notes = [Select Id,Name,Note_Type__c, Actor__c, Notes__c, Job_Order__c, CreatedById, CreatedBy.Name, LastModifiedDate
                            from CSS_Service_Notes_Log__c where Job_Order__c= :JobID and Note_Type__c='Triage' order by LastModifiedDate desc];
        }
    }
    
    public CSS_Job_Notes() { 

    }   

    public String FindNoteType()
    {
        string sNoteTp;
        
        if (vPageName == null || vPageName =='')
        {
            sNoteTp = 'Intake';
        } 
        else if (vPageName == 'Intake')
        {
            sNoteTp = 'Intake';
        }
        else if (vPageName == 'Triage')
        {
            sNoteTp = 'Triage';
        }
        else
        {
            sNoteTp = 'Intake';
        }
        return sNoteTp;
    }   
    // create a note based on the page that the component is called from
    public PageReference saveNotes() {
        Database.SaveResult note_result;
        
        CSS_Service_Notes_Log__c css_notes = new CSS_Service_Notes_Log__c();
        
        css_notes.Job_Order__c = this.JobID;
        css_notes.Note_Type__c = FindNoteType();
        css_notes.Actor__c = vUProfile;
        css_notes.Notes__c = vNotes;
        
        // insert the note
        note_result = Database.insert(css_notes);
        
        if (note_result == null || !note_result.isSuccess()) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Could not save Notes.'));            
        } 
        else
        {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Notes have been successfully saved.'));
            vNotes ='';
        }
        return null;
    }

}