global class dbu_GoogleMerchantScheduler implements Schedulable {
    
     global void execute(SchedulableContext sc){
 
     dbu_GoogleMerchantController batchObj = new dbu_GoogleMerchantController();
     Database.executeBatch(batchObj);

     }

}