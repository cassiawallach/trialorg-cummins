trigger FSL_EmailMessageTrigger on EmailMessage (after insert,after update,after delete) {
   
    Set<Id> investorIds = new Set<Id>();
    List<WorkOrder> investorsToUpdate = new List<WorkOrder>();
   
    if (!Trigger.isDelete) {
        for (EmailMessage p : Trigger.new) {
            if(p.RelatedToId != null){
            	investorIds.add(p.RelatedToId);
            }
        }
    }
   
    if (Trigger.isUpdate || Trigger.isDelete) {
        system.debug('Inside Update ');
        for (EmailMessage p : Trigger.old) {
            if(p.RelatedToId != null){
            	investorIds.add(p.RelatedToId);
            }
        }
    }
    
    system.debug('investorIds--'+investorIds);
    Map<Id, Integer> mapmap = new Map<id, Integer>();
   // list<Workorder> finallist = new list<workorder>();
    if(investorIds != null && !investorIds.isEmpty()){
        for(aggregateresult agr : [select RelatedToId, count(id) total from EmailMessage where RelatedToId in :investorIds and status = '0'  group by RelatedToId]){
           
           /*  Workorder wo = new Workorder ();
            wo.CaseId = (ID) agr.get('RelatedToId') ;
            wo.Total_Communication_Email__c = (integer) agr.get('total');
            finallist.add(wo);*/
           
           
           if(!mapmap.containsKey((ID) agr.get('RelatedToId'))){
                mapmap.put((ID) agr.get('RelatedToId'), (integer) agr.get('total'));
            }
            else {
                mapmap.put((ID) agr.get('RelatedToId'), 1);
             }
           
        }
        system.debug('mapmap === '+mapmap);
       
        Map<id, EmailMessage> mapcount = new Map<Id, EmailMessage>([Select id from EmailMessage where RelatedToId IN :investorIds]);
        // get a map of the accounts with the number of items
        LIst<workorder> wlist = new List<workorder>([select id, Total_Communication_Email__c, CaseID from WorkOrder where CaseId IN :investorIds]);
        LIst<workorder> finallist = new List<workorder>();
        for(workorder wr : wlist){
            if( mapmap.containskey(wr.caseId)){
                wr.Total_Communication_Email__c = (Integer) mapmap.get(wr.caseId);
                finallist.add(wr);
            }
        }
        if (finallist.size() > 0){
            update finallist;
        }
    }
}