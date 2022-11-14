public class FSL_ServiceContactController {

    @AuraEnabled
    //public static id fetchAccountId(String woId){
    public static list<id> fetchAccountId(String woId){
        try{
          // Id accountId = [SELECT Id,Payer__c FROM WorkOrder WHERE Id=:woId].Payer__c;
            //Added as pert of story CT4-107
         WorkOrder accountlist=[SELECT Id,Payer__c,accountId FROM WorkOrder WHERE Id=:woId limit 1];
            list<id> id1=new list<id>();
            id1.add(accountlist.payer__c);
            id1.add(accountlist.accountId);
           system.debug('*** accId '+accountlist);
             //system.debug('*** accId1 '+accountlist);
           return id1;
            //return accountId;
        }catch(Exception E){
            system.debug('work order is not associated with payer account');
            return null;
        }
        
    } 
    @InvocableMethod(label='deleteSerOrderContacts' description='Delete SerOrder Contact ' category='Account')
    public static void deleteNewServiceOrderContacts(List<Id> payerId){
        
        List<ServiceOrderContact__c> serOrdList = new List<ServiceOrderContact__c>();
        
        try{
            if(!payerId.isEmpty()){
                //serOrdList = [SELECT Id,Name FROM ServiceOrderContact__c WHERE Payer_Account__c IN: payerId];//Commenting out as this query is not being used
                
                if(!serOrdList.isEmpty()){
                  //  Delete serOrdList;
                }
            }
        }catch(Exception e){
            system.debug('** Exception occured while deleting the service order contacts'+e.getMessage());
        }
        
    }

    
}