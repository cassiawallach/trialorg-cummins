/*
Class Name : FSL_CommunicationStatusHandler
Description: This class is used to get the total number of unread emails in Emails for Parent Service Request Table count.
Created By : Madhavi P
JIRA Story : CT4-177 
23-10-2020 - Madhavi P - Created this controller to get unread email communications count. 
*/
public class FSL_CommunicationStatusHandler {
    
    @AuraEnabled
    public static integer totalCommunications(String RecordID) {
        integer totalcommunications = 0 ;
        if(RecordID != null){
            List<EmailMessage> list_EmailMessage = [Select id, ParentId, Parent.ServiceJob__c from emailMessage where status = '0' and Parent.ServiceJob__c = :RecordID];
            if(list_EmailMessage.size() >= 0){
                totalcommunications = list_EmailMessage.size();
            }
        }
        
        Workorder wo = new Workorder();
        wo = [select Id, Total_Communication_Email__c from Workorder where Id =: RecordID];
        try{
            /*Adding IF condition to avoid Reload issue 4/1/2021*/
            if(totalcommunications >= 0 && wo.Total_Communication_Email__c != totalcommunications){
                wo.Total_Communication_Email__c = totalcommunications;
                update wo;
            }
        }
        catch (exception e){
            system.debug('Exception caused while updating WorkOrder :: '+e.getMessage());
        }
       return totalcommunications;
    }
}