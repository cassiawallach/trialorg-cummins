public class EVL_EmailPartsController {
    
    @AuraEnabled
    public static Boolean sendMailMethod(String mMail ,String mSubject ,String mbody,string recordId){
        try{
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>(); 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.addAll(mMail.split(','));
            mail.setToAddresses(sendTo);
            system.debug(sendTo);
            PageReference pdf =  new PageReference('/evolution/apex/EVL_ServiceOrderPartsPDFPage?id='+recordId);
            Blob b ;
            if(!test.isRunningTest()){
                b = pdf.getContent();
            }
            else{
                b=Blob.valueOf('test');
            }
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('Parts.pdf'); //set name of PDF
            efa.setBody(b); //attach the PDF
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            mail.setReplyTo('noreply@gmail.com');
            mail.setSenderDisplayName( Userinfo.getName());
            if(mSubject!=null){
                mail.setSubject(mSubject);    
            }
            if(mbody!=null){
                mail.setHtmlBody(mbody);
            }
            mails.add(mail);
            List<Messaging.SendEmailResult> emailMessagesResult=Messaging.sendEmail(mails);
            for(Messaging.SendEmailResult emailResult:emailMessagesResult){
                if(emailResult.isSuccess()){
                    return true;
                }
                else{
                    return false;
                }
            }
            return false;
        }catch(Exception e){
            system.debug('Error Occured'+e.getStackTraceString());
            return false;
        }
    }  
}