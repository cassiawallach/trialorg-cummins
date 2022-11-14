/*
Class Name : FSL_OpenRecommendationsHandler
Description: This class is to get the number of open recomendations present on the Asset.
Created By : Karthik Pedditi		CT2-698			07/23/2021 
*/
public class FSL_OpenRecommendationsHandler {
    @AuraEnabled
    public static integer getRecommendationsCount(String scId){
        Integer numRecords=0;
        
        WorkOrder woRec=[SELECT Id,AssetId FROM WORKORDER WHERE Id=:scId];
        List<FSL_Recommendation__c> recList=new  List<FSL_Recommendation__c>();
        if(woRec.AssetId!=null){
            //recList=[SELECT Id,Status__c FROM FSL_Recommendation__c WHERE  (Status__c!='Rejected' AND Status__c!='Accept' AND Status__c!='Complete') AND Asset__c=:woRec.AssetId]; //old query
            recList=[SELECT Id,Status__c FROM FSL_Recommendation__c WHERE  (Status__c !='Rejected' AND Status__c !='QUOTE REJECTED' AND Status__c !='Accept' AND Status__c !='QUOTE ACCEPTED' AND Status__c !='Complete') AND Asset__c=:woRec.AssetId];
        }
        numRecords=recList.size();
        return numRecords;
    }
}