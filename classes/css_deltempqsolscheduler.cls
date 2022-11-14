global class css_deltempqsolscheduler implements Schedulable {
    global void execute(SchedulableContext sc){
       String query = 'select id from CSS_JobEventTemporary__c where CreatedDate < Last_N_Days:2 and Name = \'QSOL\'';
        if(query != null){
        css_qsoldelbatch delBatch = new css_qsoldelbatch(query);
        Id BatchProcessId = Database.ExecuteBatch(delBatch);
        }
    }
    

}