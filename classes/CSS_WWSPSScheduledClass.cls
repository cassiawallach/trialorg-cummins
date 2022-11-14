global class CSS_WWSPSScheduledClass Implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        CSS_WWSPSCertificationInfo.processWWSPS();
        sendAdminmail();
    }
    public void sendAdminmail()
    {
        Messaging.SingleEmailMessage emailCSSWWSPS = new Messaging.SingleEmailMessage();
        string [] toaddress= New string[]{Label.css_admin_email};
        emailCSSWWSPS.setSubject('CSS WWSPS Execute Successful @ ' + String.valueOf(System.now()));
        String sMessageBody = 'Hello Admin, \n \n' + 'This is to inform you that the WWSPS Service was executed today at ';
        sMessageBody = sMessageBody + String.valueOf(System.now()) + '. \n \n' ;
        sMessageBody = sMessageBody + 'To find out if there was an error, please check the CSS Integration Error Object and the Apex Debug Logs ';
        sMessageBody = sMessageBody + 'for more information. \n \n';
        sMessageBody = sMessageBody + '*** This is a system generated message. Please do not reply to this mailbox ***';
        emailCSSWWSPS.setPlainTextBody(sMessageBody);
        emailCSSWWSPS.setToAddresses(toaddress);
        Messaging.sendEmail(New Messaging.SingleEmailMessage[]{emailCSSWWSPS});
    }
}