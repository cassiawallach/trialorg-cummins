global class CSS_DeleteInsiteImagesScheduler implements Schedulable{
    
	global void execute(SchedulableContext sc){
       String query = 'Select Id,Description,ParentId from Attachment where Description like \'CG_%.eif\'';
        if(query != null){
        	CSS_InsiteImagesDelBatch delBatch = new CSS_InsiteImagesDelBatch(query);
        	Id batchProcessId = Database.ExecuteBatch(delBatch);
        }
    }
    
}