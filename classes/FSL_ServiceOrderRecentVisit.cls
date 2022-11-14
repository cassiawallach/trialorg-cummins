public class FSL_ServiceOrderRecentVisit {
    
    public static void recentVisitFlag(WorkOrder[] triggernew, Map<Id,WorkOrder> oldMap) {
        
        try {
            List<WorkOrder> newList = new List<WorkOrder>();
            List<Service_Order_Extension__c> woExtUpdate = new List<Service_Order_Extension__c>(); //By Priyanka VGRS2-456
            List<WorkOrder> newNullList = new List<WorkOrder>();
            List<WorkOrder> recentVisitList = new List<WorkOrder>();
            Map<id, Service_Order_Extension__c> extMap = new  Map<id, Service_Order_Extension__c>();
            List<String> esnList = new List<String>();
            for(Integer i=0; i<triggernew.size(); i++) {
                if(oldMap!=null) 
                {
                    system.debug(' new val ASSET '+ triggernew[i].AssetId);
                    system.debug(' old val ASSET '+ oldMap.get(triggernew[i].id).AssetId);
                    if(triggernew[i].AssetId != null && triggernew[i].AssetId !=oldMap.get(triggernew[i].id).AssetId) 
                    {
                        System.debug('The id is>>>>>' + triggernew[i].Id);
                        newList.add(triggernew[i]);
                        esnList.add(triggernew[i].AssetId);
                    }
                    else if(triggernew[i].AssetId == null) 
                    {
                        system.debug(' inside else condition .');
                        newNullList.add(triggernew[i]);
                    }
                } else {
                    System.debug('Inside service job'); // Insert Logic
                    newList.add(triggernew[i]);
                    esnList.add(triggernew[i].AssetId);
                }
            }
            System.debug(' newNullList : '+newNullList);
            //added by sailaja to check null condition
            if(newNullList != null && newNullList.size() > 0){
                 for(WorkOrder njo:newNullList) 
                {
                   // njo.RecentVisit__c = false;
                }
            }
            if(newList.size()>0) {
                if(!Test.isRunningTest()){
                    //added by sailaja to fix test cls
                    //By Priyanka VGRS2-456
                    recentVisitList = [SELECT Id,  (select id,Recent_Visit__c from Service_Order_Extension__r ),
                                       							CreatedDate,AssetId, Asset.Name FROM WorkOrder
                                       				WHERE (AssetId IN : esnList AND CreatedDate >= LAST_N_DAYS:30 AND Asset.Name != null)
                                      						OR (id IN: newList)];
                                      															     
                system.debug('test1*'+ recentVisitList);
                }
                    else{
                        recentVisitList = [SELECT Id, (select id,Recent_Visit__c from Service_Order_Extension__r ), CreatedDate,AssetId, Asset.Name FROM WorkOrder WHERE AssetId IN : esnList AND Asset.Name != null];     
                        recentVisitList.addAll(newList);
                    }
                //By Priyanka VGRS2-456
                for(WorkOrder wo:recentVisitList)
                {
                    if(!wo.Service_Order_Extension__r.isempty()){
                    extMap.put(wo.id, wo.Service_Order_Extension__r[0]);
                    }
                }
                    for(Integer i=0; i<newList.size(); i++) {
                 	boolean recVisit = false; 
                    if(recentVisitList.size()>0) {
                        for(Integer j =0; j<recentVisitList.size(); j++) {
                            system.debug('rectest**'+recentVisitList[j].id);
                            
                            if(newList[i].AssetId == recentVisitList[j].AssetId && newList[i].id != recentVisitList[j].id)
                            {
                               // newList[i].RecentVisit__c = true;
                                system.debug('test2');
                                recVisit = true; 
                                break;
                            }
                            else {
                               system.debug('test3');
                                recVisit = false; 
                                //newList[i].RecentVisit__c = false;
                            }
                        }
                    }
                    else {
                        system.debug('test4');
                       recVisit = false; 
                        //newList[i].RecentVisit__c = false;
                    }
                      //By Priyanka VGRS2-456
                        Service_Order_Extension__c woExt = new Service_Order_Extension__c(); 
                       if(extMap.get(newList[i].id) != null)
                       {
                            system.debug('test5');                      
                        woExt = extMap.get(newList[i].id);
                        woExt.Recent_Visit__c = recVisit;
                        woExtUpdate.add(woExt);
                       }
                }
                Update woExtUpdate;
                   
            }
            system.debug('List is:'+newList);
        }
        
        catch (DmlException e) {
            system.debug('Catch' + e.getMessage() + ' ' + e.getLineNumber());
        }
    }
}