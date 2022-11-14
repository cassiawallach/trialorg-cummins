@isTest
public class CSS_LaunchEDS_Controller_Repair_Test {
    
    static CSS_LaunchEDS_Controller_Repair ext;
    static CSS_Job_Order__c jobOrder;
    static PageReference pref;
    
    private static void init() {
        
        jobOrder = new CSS_Job_Order__c(Customer_Name__c='Test job order 1',DSID_UpdateTimestamp__c=System.now(),INSITE_UpdateTimeStamp__c=System.now());
        // cjo.DSID_UpdateTimestamp__c=System.now();
        //cjo.INSITE_UpdateTimeStamp__c=System.now();
        insert jobOrder;
        pref = new PageReference('/'+jobOrder.id);
        pref.getParameters().put('id',jobOrder.id);
        
        Test.setCurrentPage(pref);
        
        ApexPages.StandardController con = new ApexPages.StandardController(jobOrder);
        ext = new CSS_LaunchEDS_Controller_Repair(con);
        
    }
    @isTest  static void testcheck_dS_Status() {
        init();
        pref.getParameters().put('DSStatus','Closed');
        pref.getParameters().put('DSID','DSD19201');
        Test.startTest();
        ext.check_dS_Status();
        CSS_Job_Order__c ds = [Select id,DSID_Status__c,DSID_UpdateTimestamp__c from CSS_Job_Order__c where id=: jobOrder.id];
        //System.assertEquals(ds.DSID_Status__c,'Closed');
        //System.assertEquals(ds.DSID_UpdateTimestamp__c,System.now());
        Test.stopTest();        
    }
    
    @isTest  static void testgetID() {
        init();
        Test.startTest();
        //Test.setMock(WebServiceMock.class, new EDSwebcalloutMockImpl());
        pref = ext.getID();
        CSS_Job_Order__c ds = [Select id,DSID__c,DSID_Creation_Timestamp__c from CSS_Job_Order__c where id=: jobOrder.id];
        //System.assertEquals(ds.DSID__c,'DSBDT3829');
        //System.assertEquals(ds.DSID_Creation_Timestamp__c,System.now());
        //System.assertEquals(pref.getUrl(),'https://edstest.ptcmanaged.com/advisor-css/bookmark?DSID='+ds.DSID__c+'&DS=continue&crm_source=CSS&crm_callback_url=https://cummins--cssdev.cs50.my.salesforce.com/'+ds.Id+'&forcenewsession=false&state=dialog-start');
    }
    @isTest static void testgetRepairs(){
        init();
        pref=ext.getJobRepairs();
    }
    
    @isTest static void getdsidTimestamp(){
        init();
        //ext = new CSS_LaunchEDS_Controller();
        string dsidTime = ext.getDSIDStamp();
    }
    
    @isTest static void getEdsSolutions(){
        init();
        List<CSS_Solutions__c> lcs = ext.getsolutions();
    }
    
    @isTest static void getFaultCodes(){
        init();
        List<CSS_Fault_Code__c> faultCode = [select Primary_Fault_Code__c,Related_Fault_Code__c from CSS_Fault_Code__c where Sequence__c=:30 and Fault_Code_Type__c='APD-P' and Job_Order__c=:jobOrder.id  limit 5];
        string faultC = CSS_LaunchEDS_Controller.faultyCodeString(faultCode);
    }
    @isTest static void showPopUp(){
        init();
        ext.showPopup10();
        ext.closePopup10();
    }
}