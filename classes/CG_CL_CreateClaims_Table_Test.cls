@isTest
public class CG_CL_CreateClaims_Table_Test
{
    public static list<CSS_UserLocation__c> ulist=new list<CSS_UserLocation__c>() ;
    public static List<CSS_Claims__c> clmslist=new list<CSS_Claims__c>();
    public static List<CSS_Job_Order__c> sjlist=new list<CSS_Job_Order__c>();
    public static List<CSS_Job_Order__c> sjnrcclist=new list<CSS_Job_Order__c>();
    public static List<CSS_Job_Order__c> sjfnlist=new list<CSS_Job_Order__c>();
    
    public static String ServiceJobList='testsjoblist';
    public static String whrcl='';
    
    public static List<SelectOption> options=new list<selectoption>();
    static CG_BL_Claims cbclmobj = new CG_BL_Claims();
    
    public static css_job_order__c workJob =new css_job_order__c ();
    public static CSS_Claims__c newClaim =new CSS_Claims__c();
    public static CSS_PSN__c psnDetails = new CSS_PSN__c();
    public static CG_CL_CreateClaims_Table cct=new CG_CL_CreateClaims_Table();
    //public static CG_CL_CreateClaims_Table.ServiceJobWrap wrp=new CG_CL_CreateClaims_Table.ServiceJobWrap();
    public static string selectedLocation;
    public static String whClause;
    public static CG_BL_Claims cbc=new CG_BL_Claims();
    @testsetup
    static void createtestdata()
    {
        
        String ServiceJobList ='Testjob';
        
        //String defaultLoc='-All-';
        
        whClause='null';
        //selectedLocation ='-All-';
        
        //workJob.Repair_Location__c='Test';
        workJob.CSS_Job_Location_Code__c='23456';
        workJob.jobLocation__c='87654-56789';
        workJob.Customer_Name__c='Test';
        workJob.Customer_Code__c='Test';
        workJob.First_Name__c='Test';
        workJob.BMS_Last_Name__c='Test';
        workJob.Phone_Number__c='Test';
        workJob.Email_Address__c='Test@test.com';
        workJob.Address__c='Test';
        workJob.ZipCode__c='94356';
        
        workJob.ESN__c='Test';
        workJob.Unit_Number__c='Test';
        workJob.Application__c='Test';
        workJob.Service_Model__c='Test';
        workJob.Make__c='Test';
        workJob.Model__c='Test';
        workJob.Unit_Type__c='Test';
        workJob.VIN__c='1234';
        workJob.Warranty_Start_Date__c=Date.today();
        workJob.Before_In_Service__c=true;
        workJob.Failure_Date__c=Date.today();
        workJob.Mileage__c=23.0;
        workJob.CSS_Hours__c=10;
        workjob.Sub_Status__c='Ready for Claim Creation';
        insert workjob;
        //For lst job covering
        
        
    }
    static testMethod void testmethod1()
    {
        test.startTest();
        insert workjob;
        cct.selectedjob = workjob.id;//THIS IS THE MOST IMPORTANT LINE SUCH AS WE ARE PASSING THIS FROM PAGE.
        PageReference pgt=cct.CreateNeGclaim();
        string furl=pgt.getUrl();
        string curl='/apex/CG_ClaimsIntake?id='+cct.newClaim.id;//THIS IS ALSO IMPORTANT AS CLAIM IS CREATED AFTER FUNCTION CALL
        system.debug('curl url is...'+furl);   
        system.assertEquals(curl, furl);
        system.debug('furl url is...'+furl);   
        test.stopTest();
    }
    static testMethod void testmethod2()
    {
        test.startTest();
        list<selectoption> slist=new list<selectoption>();
        CG_CL_CreateClaims_Table cct=new CG_CL_CreateClaims_Table();
        cct.selectedLocation= 'test';
        cct.ServiceJobList = 'test';
        //cct.setComplaint=false;
        slist=cct.getLocationsName();
        string reccount=CG_CL_CreateClaims_Table.getSOQLRecCount();
        List<CSS_Claims__c> clmlist=new list<CSS_Claims__c>();
        CSS_Claims__c clmsobj = new  CSS_Claims__c ();
        CSS_JobHistory__c jobhist = new CSS_JobHistory__c();
        jobhist.CSS_Field_Name__c  ='EditComplaint__c';
        
        jobhist.CSS_Job_Id__c = 'test';
        //jobhist.IsDeleted = true;
        jobhist.Name ='test';
        //jobhist.LastModifiedDate = Date.today();
        insert jobhist;
        boolean setComplaint = false;
        test.stoptest();
    }
    static testMethod void testmethod3()
    {
        /*The RemoteAction annotation provides support for Apex methods used in Visualforce to be called via JavaScript.This process is often referred to as JavaScript remoting.*/
        /*Testing the funciton annoted with @remoteaction*/
        test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8',FirstName='uesr1', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        //selectedLocation ='-All-';
        whClause=' ESN__c!=null ';
        //Location Constrints
        CSS_UserLocation__c cul=new CSS_UserLocation__c();
        cul.isActive__c=true;
        cul.isPrimary__c=true;
        cul.UserId__c = userinfo.getUserId();
        account act=new account();
        act.name='Delexcel';
        act.IAM_Service_Provider_Code__c='56789';
        act.CSS_DistributorCode__c='87654';
        insert act;
        cul.AccountId__c=act.id;
        insert cul;
        //Location Constrints
        //Call the function with orignal location 
        CSS_Job_Order__c jobobj = new CSS_Job_Order__c();
        jobobj = css_TestData.createJobOrder(false);
        jobobj.Status__c = 'Review';
        jobobj.Sub_Status__c='Ready for claim creation';
        jobobj.AccessCode__c='tar';
        jobobj.Warranty_Coverage_Flag__c=true;
        jobobj.ESN__c='45656678';
        jobobj.Claim_ID__c=null;
        jobobj.JobLocation__c='Cummins Western Canada Edmont';
        insert jobobj;
        whClause = '';    
        List<CSS_Job_Order__c> lstJob = new List<CSS_Job_Order__c>();
        lstJob = [select id from CSS_Job_Order__c];
        CG_CL_CreateClaims_Table.lstjob = lstJob;
        CG_CL_CreateClaims_Table.getlstServiceJob('Cummins Western Canada Edmonton-56255');
        // CG_CL_CreateClaims_Table.CustomSearchJobs(selectedLocation, whClause);   
        
        //Change the location
        selectedLocation ='87654-56789';    
        CG_CL_CreateClaims_Table.CustomSearchJobs(selectedLocation, whClause);  
        List<CSS_Job_Order__c> joblist= new list<CSS_Job_Order__c>();
        
        // jobobj.JobStatus__c='test';
        // jobobj.Creator_Location__c='test';
        // jobobj.Add_Tech1__c='tim';
        //jobobj.Add_Tech2__c='tst';
        //jobobj.Add_Tech3__c='test';
        //jobobj.Add_Tech4__c='';
        //jobobj.Add_Tech5__c='';
        //jobobj.Add_Tech6__c='';
        //jobobj.Add_Tech7__c='';
        //jobobj.Additional_Tech4__c='';
        
        test.stopTest();
    }
    static testMethod void testmethod4()
    {
        test.startTest();
        CG_CL_CreateClaims_Table.ServiceJobWrap wrp=new CG_CL_CreateClaims_Table.ServiceJobWrap();
        wrp.showBold=true;
        //public string id;
        wrp.name='Test';
        wrp.Customer_Name='Test';
        // Location story start
        wrp.Job_Location='Test';
        // Location story start
        wrp.Assigned_To='Test';
        wrp.Assigned='Test';
        
        wrp.Assigned_To1='Test';
        wrp.AssignedTech1='Test';
        
        wrp.Assigned_To2='Test';
        
        wrp.Assigned_To3='Test';
        wrp.AssignedTech3='Test';
        
        wrp.Assigned_To4='Test';
        wrp.AssignedTech4='Test';
        wrp.Assigned_To5='Test';
        wrp.AssignedTech5='Test';
        wrp.Assigned_To6='Test';
        wrp.AssignedTech6='Test';
        wrp.Assigned_To7='Test';
        wrp.AssignedTech7='Test';
        wrp.Assigned_To8='Test';
        wrp.AssignedTech8='Test';
        wrp.Assigned_To9='Test';
        wrp.AssignedTech9='Test';
        //end
        wrp.DSID='Test';   
        wrp.Date_In='Test';
        wrp.Date_In_sort='Test';
        wrp.Created_Time_Zone='Test';
        wrp.Created_Time_sort='Test';
        wrp.Status='Test';
        wrp.Sub_Status='Test';
        wrp.LastUpdateSubStatus='Test';
        wrp.Service_Model='Test';
        wrp.RecentVisit=true;
        wrp.Repeat_Visit=true;
        wrp.LastSaved='Test';
        wrp.LastSaved_sort='Test';
        
        wrp.Unit_Number='Test';
        wrp.Shop_s_Work_Order='Test'; 
        wrp.dField='Test';
        wrp.jobStatus='Test';
        wrp.jobLocation='Test';
        wrp.Job_LocationCode='Test';
        test.stoptest();
    }
    
}