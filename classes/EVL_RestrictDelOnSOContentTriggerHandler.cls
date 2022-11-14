/**********************************************************************
Name: EVL_RestrictDelOnClSOContentTriggerHandle
======================================================
======================================================
Purpose:    Built for CT1-93                                                        
Restriction Content document from delete if service order is closed
======================================================a
======================================================a
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Sai Pisupati      02/18/2021      INITIAL DEVELOPMENT
***********************************************************************/
public class EVL_RestrictDelOnSOContentTriggerHandler {
    
    public static void restricContentOnClosedSOBeforeDelete(list<ContentDocument> oldContentDocument) {
        
        Schema.DescribeSObjectResult inv = WorkOrder.sObjectType.getDescribe();
        String invKeyPrefix = inv.getKeyPrefix();
        
        List<Id> contentDocId = new List<Id>();
        Map<Id, Id> contDocLinkedMap = new Map<Id, Id>();
        
        for(ContentDocument con : oldContentDocument) {
            System.debug('con is ++++' + con);
            System.debug('con.Id is ++++' + con.Id);
            contentDocId.add(con.Id);
        }
        
        for(ContentDocumentLink cdl : [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId IN : contentDocId]) {
            if(invKeyPrefix == String.valueOf(cdl.LinkedEntityId).left(3)){ //Sruthi - Moving this condition here to prevent addition of Content Document Linked to User ID
                contDocLinkedMap.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
                System.debug('map is ++++' + contDocLinkedMap);
            }
        }
        
        List<Id> lstWOId = new List<Id>();
        for(Id woId: contDocLinkedMap.values()) {
            //if(invKeyPrefix == String.valueOf(woId).left(3)) { Sruthi - Commenting this out because the condition is being checked above
                lstWOId.add(woId);
            //}
        }
        
        List<WorkOrder> lstWO = new List<WorkOrder>();
        lstWO = [SELECT EVL_Stage__c, Status, Type__c FROM WorkOrder WHERE Id IN :lstWOId];
        
        for(ContentDocument cdoc : oldContentDocument) {
            for(WorkOrder wo: lstWO) {
                if(wo.EVL_Stage__c == 'Closed' && wo.Type__c == 'Dealer' && !Test.isRunningTest()) {
                    cdoc.adderror('Changes cannot be made after a job is closed.');
                }
            }
        }
    }
}