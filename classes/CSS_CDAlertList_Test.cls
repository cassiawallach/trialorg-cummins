@IsTest(seealldata = false)
public class CSS_CDAlertList_Test{
/*----------------------------------------------------------------------
Author: Roopa Gadipudi
Description: 
    This is test class for the CSS_CDAlertsList component to display
    the 30 dat alerts received from Connected Diagnostics.
Input: 
     CSS Job Id
Output: 
    The 30 days alerts is retrived from the database using CSS_ConnectedDiagnostics__c custom object

Methods:
    1. getAlerts(): This function retrives the 30 day alerts from Connected diagnostics
    2. AlertSearch():  This function is used to get the alerts from Connected Diagnostics too.
-----------------------------------------------------------------------*/
    static{
        
         CSS_Integration_Details__c intdetails = new CSS_Integration_Details__c();
        intdetails.Name='CDDashbrd';
        intdetails.passcode__c = 'fgud0c8Vq/MWigAptLPvm0CD0EexI87U/Xcop25CqxnQuu6ShOT0u+fKEZZ/B0Ab';
        intdetails.Key__c='P0GZQg+MSAXpqM+w+wwVOpZr9An7DZJclYF+yh05YscFVfVbVtZ27IPhN0PsBWZh';
        intdetails.End_Point__c='https://connectedsolutions-stg.cummins.com/Services/getServiceEventDashboard1.do';
        intdetails.ApplicationName__c='CDDashbrd';
        intdetails.IsActive__c=true;        
        intdetails.Username__c='b7RKJlXE+GjVvBAdrKk1dlsqBV65ltTqWzNyDtdy8eI=';
        insert intdetails;
        
    }
    static testMethod void CSS_CDAlertList_Test_Method1()
    {
    // Add test data for creating service job record
        Test.startTest();   
       
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
                JO.Customer_Name__c = 'RoopaTnD';
               // JO.Model__c = 'RoopaTestTnD';
           //     JO.Service_Model_N__c = 20;
        //        JO.Shop_s_Work_Order__c = 140;
                JO.Status__c = 'Repair Complete';
                JO.Unit_Number__c = 'test1234';
                JO.ESN__C='1234';
                Jo.Assigned_To__c = UserInfo.getUserId();
            insert(JO);
            
          ApexPages.currentPage().getParameters().put('id',jo.Id);  
            // Add test data for  getting the Alerts
            CSS_CDAlertList alist= new CSS_CDAlertList();
            alist.setJobID(jo.id);
            alist.getJobID();
            alist.getAlerts();
            alist.AlertSearch();
        
            alist.sJobESN=JO.ESN__c;
            alist.jID=JO.ID;
            //alist.getDashboardURL();
       
        Test.stopTest();

    }
}