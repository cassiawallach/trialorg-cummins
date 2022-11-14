/**********************************************************************
Name:CSS_NotesCaptureClass
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Satish          5/18/2016      INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_NotesCaptureClass {
    
   
       public transient list<Note> JobNotesList;
    public boolean notesDescFlag=true;
     public String notesdesc {
        get;
        set {
            notesdesc = value;
        }
    }
    public ID JobID {get;set{
        JobID=value;
        
        system.debug('=======JobID '+JobID);
        
        //VS:Comment
        getNotes();
    }}
    
    public ID vsJobID {get;set{
        vsJobID=value;
        
        system.debug('=======vsJobID '+vsJobID);
        
        //VS:Comment
        //getNotes123();
    }}
    
    public CSS_NotesCaptureClass(){
        
        notesdesc ='1';
    }
   //74193 Start 
    
        public List<SelectOption> getSortvalues() {
        List<SelectOption> SortList = new List<SelectOption>(); 
            
        
            SortList.add(new SelectOption('1',system.Label.css_Oldest_To_Newest));
            SortList.add(new SelectOption('2',system.Label.css_Newest_To_Oldest));
            
        return SortList;
    }
    //74193 End 
    
    public string NotesType {get;set;}
    public string NotesBody {get;set;}
    public Id nUserId=userInfo.getUserId();
   
       public transient list<notesWrapper> SWriterNotes {get;set;}
       public transient list<notesWrapper> TechNotes {get;set;}
       public transient list<notesWrapper> SupNotes {get;set;}
       public transient list<notesWrapper> ExtJournalNotes {get;set;}
       public transient list<notesWrapper> PartsProfNotes {get;set;}
    
       public transient list<notesWrapper> SWLastNotes {get;set;}
       public transient list<notesWrapper> TCLastNotes {get;set;}
       public transient list<notesWrapper> SULastNotes {get;set;}
       public transient list<notesWrapper> EXLastNotes {get;set;}
       public transient list<notesWrapper> PPLastNotes {get;set;}
   
       public string SWLNBody {get;set;}
       public string TCLNBody {get;set;}
       public string SULNBody {get;set;}
       public string EXLNBody {get;set;}
       public string PPLNBody {get;set;}
    
     public class notesWrapper{
        public Id nId {get; set;}
        public string nBody {get; set;}
        public string nTitle {get; set;}
        public string nfrstName {get; set;}
        public string nlastName {get; set;}
        public string nLastModified {get; set;}
        public string nCreatedId {get; set;}    
        
        public notesWrapper(Note n){
            this.nId=n.id;
            this.nBody=string.valueof(n.body);
            this.nTitle=n.Title;
            this.nfrstName=n.CreatedBy.firstname;
            this.nlastName=n.CreatedBy.lastname;
            //this.nLastModified= css_utility.getFormattedDate(n.LastModifiedDate);
          //  this.nLastModified= n.LastModifiedDate.format('dd MMM YYYY hh:mm a z');
              this.nLastModified= n.CreatedDate.format('dd MMM YYYY hh:mm a z'); // Defect fix 71460
            this.nCreatedId=n.CreatedById;
        } 
    }
 
   public void getNotes()
   {
       System.debug(Logginglevel.ERROR,'=========Inside getNotes 123456============');
       try{
        system.debug('notesdesc---'+notesdesc);
        notesDescFlag = false;
          
          
            if(notesdesc=='1')    
           {
                JobNotesList=[Select Id,Body,title,CreatedBy.firstname, CreatedDate, CreatedBy.lastname, LastModifiedDate, CreatedById from Note where parentid= :JobID order by CreatedDate asc  LIMIT 1000]; 
                 System.debug('=====JobNotesList====='+JobNotesList);
                for(Note nt : JobNotesList)
                {
                      System.debug('=====Note====='+nt);
                }
                
                /*Note nt = new Note(Id='0023B000001HBLBQA4');
                nt.Body='0053B0000013SpcQAE,0053B0000013XrOQAU,0053B000000kFeTQAU,0053B0000013SqGQAU,0053B0000013kjrQAA,0053B000000IUOKQA4,0053B000000VUhhQAG';
                nt.Title = 'Bold'; 
                nt.CreatedById='0053B000000IURxQAO';
                nt.CreatedDate=System.now();
                nt.LastModifiedDate = System.now();
                */
           }
          
          else if(notesdesc=='2'){
              JobNotesList=[Select Id,Body,title,CreatedBy.firstname, CreatedDate, CreatedBy.lastname, LastModifiedDate, CreatedById from Note where parentid= :JobID order by CreatedDate desc LIMIT 1000]; 
              system.debug('JobNotesList--->'+JobNotesList); 
           }
           
        List<notesWrapper> nl = new List<notesWrapper>();
        for(Note n: JobNotesList){
            nl.add(new notesWrapper(n));
        }
                 
        if(nl != null){
            SWriterNotes = new List<notesWrapper>();
            for(notesWrapper wn: nl){

                if(wn.nTitle.equalsIgnoreCase('WRITERNOTES')){
                SWriterNotes.add(wn);
                }   
            }
            
            SWLastNotes = new List<notesWrapper>();
            for(notesWrapper swlnDt: SWriterNotes)
           {
               if (swlnDt.nCreatedId==nUserId)
               {
                   SWLastNotes.add(swlnDt);
               }
           }
            if(SWLastNotes.size()>0){
               //SWLNBody= SWLastNotes[0].nbody;
            }
              //System.Debug('SWLNBody'+SWLNBody);            

            TechNotes = new List<notesWrapper>();
            for(notesWrapper tn: nl){
                if(tn.nTitle.equalsIgnoreCase('TECHNICIANNOTES')){
                TechNotes.add(tn);
                }        
            }
            
           TCLastNotes = new List<notesWrapper>();
            for(notesWrapper tclnDt: TechNotes)
           {
               if (tclnDt.nCreatedId==nUserId)
               {
                   TCLastNotes.add(tclnDt);
               }
           }
            
            if(TCLastNotes.size()>0){
               //TCLNBody= TCLastNotes[0].nbody;
            }
              //System.Debug('TCLNBody'+TCLNBody);            

            
            SupNotes = new List<notesWrapper>();
            for(notesWrapper sn: nl){
                if(sn.nTitle.equalsIgnoreCase('SUPERVISORNOTES')){
                SupNotes.add(sn);
                }        
            }     

            SULastNotes = new List<notesWrapper>();
            for(notesWrapper sulnDt: SupNotes)
           {
               if (sulnDt.nCreatedId==nUserId)
               {
                   SULastNotes.add(sulnDt);
               }
           }
            if(SULastNotes.size()>0){
               //SULNBody= SULastNotes[0].nbody;
            }
              //System.Debug('SULNBody'+SULNBody);            

            
            ExtJournalNotes = new List<notesWrapper>();
            for(notesWrapper jn: nl){
                if(jn.nTitle.equalsIgnoreCase('JOURNALNOTES')){
                ExtJournalNotes.add(jn);
                } 
            }
       
            EXLastNotes = new List<notesWrapper>();
            for(notesWrapper exlnDt: ExtJournalNotes)
           {
               if (exlnDt.nCreatedId==nUserId)
               {
                   EXLastNotes.add(exlnDt);
               }
           }
            if(EXLastNotes.size()>0){
               //EXLNBody= EXLastNotes[0].nbody;
            }
              //System.Debug('EXLNBody'+EXLNBody);            
    //  <!-- 95973-->
          PartsProfNotes = new List<notesWrapper>();
            for(notesWrapper pp: nl){
                if(pp.nTitle.equalsIgnoreCase('PARTSPROFESSIONAL')){
                PartsProfNotes.add(pp);
                } 
            }
       
            PPLastNotes  = new List<notesWrapper>();
            for(notesWrapper pplnDt: PartsProfNotes)
           {
               if (pplnDt.nCreatedId==nUserId)
               {
                   PPLastNotes.add(pplnDt);
               }
           }  
            
        }
       }catch(exception e){} 
  }
    public void cancelPopup(){
        NotesBody = '';
    }
    
    public void saveNotes(){
      
        try{
        system.debug('NotesType '+NotesType);
            system.debug('NotesBody '+NotesBody);
        
        //system.debug('SaveNotes');
        Note nt = new Note();
        nt.Title = NotesType;
        nt.ParentId = JobID;
        nt.Body = NotesBody;
		NotesBody = '';
        insert nt;
       }catch(exception e){
        system.debug('Exception in Save'+e.getMessage()+' '+e.getLineNumber());
        }
        }
}