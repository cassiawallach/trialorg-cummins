@isTest
public class FSL_STC_Email_Forward_Controller_Test {
    public static testMethod void emailForward_test() { 
       Test.startTest();
        EmailMessage emailMessage = new EmailMessage(); 
        emailMessage.status = '0';
        emailMessage.fromName = 'Guidanz'; 
        emailMessage.subject = 'Communication Status Update'; 
        emailMessage.htmlBody = '<html><body><b>Hello</b></body></html>';  
        emailMessage.toAddress = 'satish.manchirala@gmail.com'; 
        insert emailMessage;
        
       
        FSL_STC_Email_Forward_Controller stc=new FSL_STC_Email_Forward_Controller();
        stc.stcId = emailMessage.Id;
        stc.getmessage();
        Test.stopTest();
    }
}