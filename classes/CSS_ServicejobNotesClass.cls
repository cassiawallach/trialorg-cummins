/**********************************************************************
Name:css_ServiceJobNotesClass
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
1.0 - Santhosh         12/9/2015      INITIAL DEVELOPMENT                    
***********************************************************************/

public class CSS_ServicejobNotesClass{

    //Method to create Notes on Sevice Job creation.
    public static void createNotes(list<CSS_Job_Order__c> newList){
        list<Note> noteList = new list<Note>();
        for(CSS_Job_Order__c jobOrder : newList){
            Note jobNote = new Note();
            jobNote.Title = 'Bold';
            jobNote.ParentId = jobOrder.Id;
            noteList.add(jobNote);
        }//end of For
        
        if(noteList != null && !noteList.isEmpty()){
            insert noteList;
        }
    }
    
    //method to update notes when status of Service Jobs updates.
    public static void updateNotes(list<CSS_Job_Order__c> newList,map<Id,CSS_Job_Order__c> oldMap){
        //set variable for Service Job Ids whose stutus is updated.
        set<Id> jobIds = new set<id>();
        
        for(CSS_Job_Order__c jobOrder : newList){
            if(jobOrder.Status__c != null){
                if(jobOrder.Status__c != oldMap.get(jobOrder.Id).Status__c){
                    jobIds.add(jobOrder.Id);
                }
            }
        }//end of for.
        
        //list for Notes to update
        list<Note> noteList = new list<Note>();
        //retrieve Notes based on Service Jobs.
        if(jobIds != null && !jobIds.isEmpty()){
            noteList = [Select Id,Body from Note where ParentId IN :jobIds AND title='Bold'];
        }
        
        if(noteList != null && !noteList.isEmpty()){
            for(Note serviceJobNote : noteList){
                serviceJobNote.body = null;
            }
            update noteList;
        }
    }
    
}