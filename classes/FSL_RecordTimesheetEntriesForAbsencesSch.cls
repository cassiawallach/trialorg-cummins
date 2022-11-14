global class FSL_RecordTimesheetEntriesForAbsencesSch implements Schedulable {
    global void execute(SchedulableContext SC) { 
        FSL_RecordTimesheetEntriesForAbsences fslrt = new FSL_RecordTimesheetEntriesForAbsences(); 
         database.executebatch(fslrt);
    }
    
}