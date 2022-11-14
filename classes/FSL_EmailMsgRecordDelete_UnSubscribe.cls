public class FSL_EmailMsgRecordDelete_UnSubscribe {
    
    @InvocableMethod(label='UnSubscribeEmailMessageRecordDelete' description='UnSubscribeEmailMessageRecordDelete' category='EmailMessage')
    public static void deleteUnSubscribeEmailMessageRecord(list<id> Emsgid){
    
       List<EmailMessage> ListEmailMsg = [SELECT Id,Subject,HtmlBody FROM EmailMessage WHERE Id IN:Emsgid AND Subject IN ('Unsubscribe request','Invoice Ready')];
                
            DELETE ListEmailMsg;
           
  }
}