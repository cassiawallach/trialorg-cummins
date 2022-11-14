@IsTest
public class FSL_EmailMsgRecordDelete_UnSubs_Test{
   private static testMethod void runTest()
    {
    
       list<WorkOrder> wl = new list<WorkOrder>();
         WorkOrder wo = new WorkOrder();
            wo.Repair_Location__c='In Shop';
            wo.Available_for_Service__c=datetime.now()+3;
            wo.SelectedSolution__c='abc';
            wo.FSL_Additional_Email_Notifications__c='abc@gmail.com;qwe@yopmail.com;jkl@gmail.com';
        wl.add(wo);
        WorkOrder wo1 = new WorkOrder();
            wo1.Repair_Location__c='In Shop';
            wo1.Available_for_Service__c=datetime.now()+3;
            wo1.SelectedSolution__c='abc';
            wo1.FSL_Additional_Email_Notifications__c='abc@gmail.com;qwe@yopmail.com;jkl@gmail.com';
        wl.add(wo1);
        insert wl;
        
        list<case> cl=new list<case>();
        case cs=new case();
        cs.ServiceJob__c=wo.id;
        cs.FSL_Adhco_Email__c='abc@gmail.com';
        cl.add(cs);
        case cs1=new case();
        cs1.ServiceJob__c=wo.id;
        cs1.FSL_Adhco_Email__c='jkl@gmail.com';
        cl.add(cs1);
        insert cl;
        
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'test@abc.org';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        //email.ParentId = cs1.Id; 
        insert email;
        List<ID> EmailMsgID= new List<ID>();
        EmailMsgID.add(email.id);
         Test.startTest();
        FSL_EmailMsgRecordDelete_UnSubscribe.deleteUnSubscribeEmailMessageRecord(EmailMsgID);
         Test.stopTest();
    }
    
 }