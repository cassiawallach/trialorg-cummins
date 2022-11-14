@isTest(SeeAllData = false)
public class CSS_Job_Notes_test{
    
    static testmethod void testmethod1(){
    CSS_Job_Notes job  = new CSS_Job_Notes();
  
   
         CSS_Job_Order__c SerRec1 = CSS_TestData.createJobOrder(True); 
    List<CSS_Service_Notes_Log__c> IntNotes;
     List<CSS_Service_Notes_Log__c> Tndnotes;
    IntNotes= new List<CSS_Service_Notes_Log__c>();  
    Tndnotes= new List<CSS_Service_Notes_Log__c>(); 
         CSS_Service_Notes_Log__c obj = new CSS_Service_Notes_Log__c();
            obj.Name='abc';
            obj.Note_Type__c = 'Intake';
            obj.Actor__c='sss';
            obj.Notes__c='ffff';
            obj.Job_Order__c=SerRec1.id;
            obj.LastModifiedDate=system.NOW();  
       
    IntNotes= new List<CSS_Service_Notes_Log__c>();  
    Tndnotes= new List<CSS_Service_Notes_Log__c>(); 
        DateTime myDateTime = DateTime.now();
         CSS_Service_Notes_Log__c obj1 = new CSS_Service_Notes_Log__c();
            obj1.Name='abc';
            obj1.Note_Type__c = 'Intake';
            obj1.Actor__c='sss';
            obj1.Notes__c='ffff';
            obj1.Job_Order__c=SerRec1.id;
            obj1.CreatedDate = myDateTime.addDays(-2);	
            obj1.LastModifiedDate=Date.Today();
           
                insert obj1;
     system.debug('obj>>>>>'+obj);
         IntNotes.add(obj1);
        
         
        CSS_Service_Notes_Log__c obj3 = new CSS_Service_Notes_Log__c();
            obj3.Name='abc';
            obj3.Note_Type__c = 'Triage';
            obj3.Actor__c='sss';
            obj3.Notes__c='ffff';
            obj3.Job_Order__c=SerRec1.ID;
            obj3.CreatedDate = myDateTime.addDays(-2);
            obj3.LastModifiedDate=date.today();
                 insert obj3;
       Tndnotes.add(obj3);
         job.JobID = SerRec1.Id;
         job.extInt_notes = IntNotes;
         job.extTnD_notes = Tndnotes;
    
    }
    static testmethod void FindNoteTypeIntaketest(){
       CSS_Job_Notes obj1 = new CSS_Job_Notes();
       obj1.vPageName = 'Intake';
       obj1.FindNoteType();
       }
    static testmethod void FindNoteTypetest(){
       CSS_Job_Notes obj1 = new CSS_Job_Notes();
       obj1.vPageName = '';
       obj1.FindNoteType();
       }
    static testmethod void FindNoteTypeTriagetest(){
       CSS_Job_Notes obj1 = new CSS_Job_Notes();
       obj1.vPageName = 'Triage';
       obj1.FindNoteType();
       }
 
    static testmethod void saveNotestest(){
        CSS_Job_Notes obj2 = new CSS_Job_Notes();
        obj2.saveNotes();
    }
}