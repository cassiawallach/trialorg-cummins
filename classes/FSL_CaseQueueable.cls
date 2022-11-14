public class FSL_CaseQueueable implements Queueable {
    public Case caseRec ; 
    public FSL_CaseQueueable( Case caseParam){
        this.caseRec = caseParam;  
    }
    public void execute(QueueableContext context) {
       update caseRec ;
         caseRec.Bypass_Validation_Rule__c =false;
       update caseRec;
    }
}