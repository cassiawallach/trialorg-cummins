@isTest
public class FSL_CL_RecordChangeCapture_Test {
    
    public testMethod static void createData() {
        Account acc = new Account();
        acc.Name = 'East Bronx1'; 
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        insert acc;
        
        List<workorder> woInfo = new List<workorder>();
        workorder wo1 = new workorder();
        wo1.Account = acc;
        wo1.Process_Step__c = 'Intake';
        wo1.Repair_Location__c = 'Mobile';
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.sub_status__c = 'Troubleshooting Complete';
        insert wo1;
        
        CSS_Solution_Component__c objsolutioncomponent = new CSS_Solution_Component__c();
        objsolutioncomponent.FSL_Service_Order__c=wo1.id;
        objsolutioncomponent.Performed_Review__c=true;
        objsolutioncomponent.Performed__c=false;
        
        Test.StartTest();
        FSL_CL_RecordChangeCapture.getAvailableFAs(wo1.Id);
        FSL_CL_RecordChangeCapture.getReqToCompFAs(wo1.Id);
        Test.StopTest();
    }
}