/**********************************************************************
Name:EVL_QueueObjectAssignemnt
Copyright © 2022  Cummins
======================================================
======================================================
Purpose:                                                            
------- This class is used for assigning Queue Objects
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   Ramya Sanikommu    06/09/2022       INITIAL DEVELOPMENT(VGRS2-503)
***********************************************************************/
public class EVL_QueueObjectAssignemnt {
    @InvocableMethod (label = 'Queue Objects assignment' description = 'Create object access records')
    public static void getQueueObjecs(List<List<String>> ids) {
        Map<String,Group> locMap = new Map<String,Group>();
        List<String> lstLocs = Ids[0];
        Set<String> lstQueues = new Set<String>();
         List<Group> lstValidatedQueues = new List<Group>();
        for(String loc : lstLocs){
            string location  = 'JQ-'+ loc;
            lstQueues.add(location);
        }
        system.debug('----lstQueues-----'+lstQueues);
        for(Group grp : [select Id,Name,DeveloperName from Group where Name IN : lstQueues]){
            locMap.put(grp.Name,grp);
        }
        system.debug('----locMap---'+locMap);
        for(String que : lstQueues){
            if(!locMap.containsKey(que)){
                Group gr = new Group(Name=que, Type='Queue');                
            	lstValidatedQueues.add(gr);
            } else{
                lstValidatedQueues.add(locMap.get(que));
            }
        }
        system.debug('---lstValidatedQueues-----'+lstValidatedQueues);
        
        if(!lstValidatedQueues.isEmpty()){
            ID JobID = System.enqueueJob(new EVL_DealerRecordsQueueAccess(lstValidatedQueues));
        }
      	
    }
    
}