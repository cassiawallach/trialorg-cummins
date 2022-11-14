/**********************************************************************
Name:EVL_DealerRecordsQueueAccess
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
public class EVL_DealerRecordsQueueAccess implements Queueable {
    
    Id queueId;
    ///String strLocation;
    List<Group> grpInfo;
    List<Group> newList = new List<Group>();
    List<Id> lstQids = new List<Id>();
    
    public EVL_DealerRecordsQueueAccess(List<Group> grp){
        this.grpInfo = grp;
    }
    
    public void execute(QueueableContext context){
        
        for(Group grp: grpInfo){
            if(grp.Id != null){
                lstQids.add(grp.Id);
            }else{
               newList.add(grp);
            }            
        }
        system.debug('--newList--'+newList);
        if(!newList.isEmpty()){
            List<Database.Saveresult> results = Database.insert(newList, false);
            for (Database.SaveResult sr : results) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    lstQids.add(sr.getId());
                    //System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            	}
            }
            
        }
        List<String> supportObjects = new List<String>{'WorkOrder','Case','Work_Order_Technicians__c','CSS_Job_Order__c'};
        List<QueueSobject> lstQueueSobjects = new List<QueueSobject>();
        if(!lstQids.isEmpty()){
            for(Id queueId : lstQids){
                for(String supObj : supportObjects){
                    QueueSobject queObj = new QueueSobject();
                    queObj.QueueId = queueId;
                    queObj.SobjectType = supObj;
                    
                    lstQueueSobjects.add(queObj);
                }
            }
        }
        if(!lstQueueSobjects.isEmpty()){
            insert lstQueueSobjects;        
        }
    }
}