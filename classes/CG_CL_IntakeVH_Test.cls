@isTest(seealldata = false)
public class CG_CL_IntakeVH_Test {
    
    static testMethod void CG_CL_IntakeVH_Test_TestMethod1() {
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Rajasekhar';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RajTest';
        JO.Make__c = 'CSSTest';
        JO.Notes__c = 'CAMPCOMMENTS';
        JO.Failure_Point__c = 122;
        JO.Failure_Point_Measure__c = 'Miles';
        JO.VIN__c = '12345677890';
        JO.Failure_Date__c = date.today() - 20;
        JO.Warranty_Start_Date__c = date.today() - 365;
        JO.Location_Certification__c = 'abc';
        JO.jobLocation__c = 'abc';
        JO.Before_In_Service__c = True;
        JO.Status__c = 'Repair Complete';
        JO.Unit_Number__c = 'test123';
        Jo.Assigned_To__c = UserInfo.getUserId();
        Jo.esn__c = '79464646';
        JO.Unit_Type__c = 'type';
        Jo.Country__c = 'United States';
        Jo.CSS_State__c = 'Indiana';
        Jo.City__c = 'Columbus';
        Jo.Customer_Code__c = '23456';
        Jo.EditComplaint__c = 'complaint';
        Jo.EditCoverage__c = 'coverage';
        Jo.EditCause__c = 'cause';
        Jo.EditCorrection__c = 'correction';
        JO.chevron_page__c = 'prt';
        JO.CSS_Resolution__c = 'Test';
        JO.DSID__c = 'VFD23';
        JO.Service_Model__c ='smodel';
        jo.Sub_Type__c='test';
        jo.CSS_Job_Location_Code__c = 'sn12';
        JO.Shop_Work_Order__c = 'test';
        //jo.NorthAmericaRegion='false';
        insert JO;
        
        Account acc = new Account();
        acc.name='R1test';
        acc.CSS_DistributorCode__c='03520';
        acc.IAM_Service_Provider_Code__c='';
        acc.IAM_Service_Provider_Code__c = '';
        acc.IAM_Service_Provider_Code__c = '04892';
        acc.ERP_System__c = 'One BMS';
        acc.Region__c = 'North America';
        acc.Territory__c = 'test';
        acc.Type = 'Investor';
        //acc.Type='Dealer Account';
         acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '562551';
        //acc.IAM_Service_Provider_Code__c = '33333';

       
       // acc.Location__c = 'North America';
        insert acc;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = 'location');
        insert u;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('id',JO.id);
        
        CG_CL_IntakeVH ccivh = new CG_CL_IntakeVH();
        ccivh.Wid = ApexPages.currentPage().getParameters().put('id',JO.id);
        ccivh.ChkFieldBlank();
        ccivh.closeSession();
        ccivh.pageAction();
        ccivh.pgSave();
        ccivh.closeSession();
        ccivh.redirectPopup();
        ccivh.Cancel(); 
        ccivh.nvIntakeCustomer();
        ccivh.nvIntakeUE();
        ccivh.nvIntakeCC();
        ccivh.nvIntakeWarranty();
        ccivh.nvIntakeRJ();
        ccivh.NorthAmericaRegion=true;
    }
        
    static testMethod void CG_CL_IntakeVH_Test_TestMethod2() {
            
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.Customer_Name__c = 'Rajasekhar';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'RajTest';
            
            CG_CL_IntakeVH ccivh1 = new CG_CL_IntakeVH();
            ccivh1.nvIntakeWarranty();
            ccivh1.nvIntakeRJ();
            ccivh1.nvIntakeCC();
            ccivh1.nvIntakeUE();
            ccivh1.nvIntakeCustomer();
            ccivh1.Cancel();
        	ccivh1.pageAction();
            
    }
    
    static testMethod void CG_CL_IntakeVH_Test_TestMethod3() {
                
        Account acc = new Account();
        	acc.name='R1test';
        	acc.CSS_DistributorCode__c='03520';
        	acc.IAM_Service_Provider_Code__c='';
        	acc.IAM_Service_Provider_Code__c = '';
        	acc.IAM_Service_Provider_Code__c = '04892';
        	acc.ERP_System__c = 'One BMS';
        acc.Type='Dealer Account';
         acc.Region__c = 'US and Canada';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '562551';
        

       // acc.Location__c = 'North America';
        	insert acc;
        
         CSS_Job_Order__c JO = new CSS_Job_Order__c();
        	JO.Customer_Name__c = '';
        	JO.Shop_Work_Order__c = '';
        	JO.status__c = '';
        	JO.Application__c = 'Recreational Vehicle';
        	JO.Model__c = 'RajTest';
        
        JO.Account__c = acc.id;
        insert JO;
        
        CG_CL_IntakeVH ccivh2 = new CG_CL_IntakeVH();
        ccivh2.Cancel();
        ccivh2.ChkFieldBlank();
        ccivh2.closeSession();
        
        
    }
    
    static testMethod void CG_CL_IntakeVH_Test_TestMethod4() {
         
         Account acc = new Account();
        	acc.name='R1test';
        	acc.CSS_DistributorCode__c='03520';
        	acc.IAM_Service_Provider_Code__c='';
        	acc.IAM_Service_Provider_Code__c = '';
        	acc.IAM_Service_Provider_Code__c = '04892';
        	acc.ERP_System__c = 'One BMS';
       // acc.Location__c = 'North America';
        	insert acc;
        
         CSS_Job_Order__c JO = new CSS_Job_Order__c();
        	JO.Customer_Name__c = 'test';
        	JO.Application__c = 'Recreational Vehicle';
        	JO.Model__c = 'RajTest';
        	JO.Shop_Work_Order__c = 'test';
        	JO.status__c = 'Closed';
        	
        
        JO.Account__c = acc.id;
        insert JO;
         
        Test.startTest();
        CG_CL_IntakeVH ccivh = new CG_CL_IntakeVH();
        ccivh.ChkFieldBlank();
        ccivh.closeSession();
        Test.stopTest();
     }
}