trigger FSL_ServiceReportTrigger on ServiceReport (before delete) {
   
    //get prefix of WO  record.
    Schema.DescribeSObjectResult inv = WorkOrder.sObjectType.getDescribe();
    String invKeyPrefix = inv.getKeyPrefix();
   
    List<Id> woId = new List<Id>();
   
    if(trigger.IsDelete){
  for(ServiceReport sr : Trigger.Old){
  if(sr.ParentId != null && invKeyPrefix == String.valueOf(sr.ParentId).left(3))
   woId.add(sr.ParentId);
  }
   Map<id, workorder> womap= new Map<id, workorder>([Select id , status from workorder where id in: woId]);
       
       
        for(ServiceReport sr : Trigger.Old){
            if(sr.parentid != null && womap != null && womap.Containskey(sr.parentid) && womap.get(sr.parentid).status=='closed' ){
             sr.adderror('Changes cannot be made after a job is closed');
            }
           
        }
    }
}