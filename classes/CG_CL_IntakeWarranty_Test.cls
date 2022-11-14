/*
Test CLass for Customer Complaint Controller - CG_CL_IntakeWarranty
*/
@isTest(seealldata = false)
public class CG_CL_IntakeWarranty_Test{
    
    Static testmethod void CG_CL_IntakeWarranty_TestMethod1() {
        
        Test.startTest();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj'; 
        jobevent.attribute1__c = 'CategoryComplaintCodes';
        insert jobevent;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
                    
        JO.Customer_Name__c = 'Test Customer';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'ModelTest';
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
        JO.Status__c = 'Intake';
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
               
        insert JO;
        
        ApexPages.currentPage().getParameters().put('id',JO.id);
        string PageName ='intakeWarranty';
        CG_CL_IntakeWarranty intakeWar = new CG_CL_IntakeWarranty();
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        intakeWar.datebyLocaleValue = 'Testing';
        CSS_accountLanguage__c nu = new CSS_accountLanguage__c();
        intakewar.accountlang = nu;
        intakeWar.pageAction(); 
        intakeWar.pgSave();
        intakeWar.nvIntakeCustomer();
        intakeWar.nvIntakeUE();
        intakeWar.nvIntakeVH();
        intakeWar.nvIntakeCustomer();
        intakeWar.nvIntakeRJ();
        intakeWar.nvIntakeCC();
        intakeWar.redirectPopup();
        intakeWar.Redirect();
        intakeWar.Cancel();        
        intakeWar.closeSession();
        
        Test.stopTest();
        
    }
    
    Static testmethod void CG_CL_IntakeWarranty_TestMethod2() {
        
        Test.startTest();
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = '{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj'; 
        jobevent.attribute1__c = 'CategoryComplaintCodes';
        insert jobevent;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
                    
        JO.Customer_Name__c = 'Test Customer';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'ModelTest';
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
        JO.Status__c = 'Intake';
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
               
        insert JO;
        
        //ApexPages.currentPage().getParameters().put('id',JO.id);
        string PageName ='intakeWarranty';
        CG_CL_IntakeWarranty intakeWar = new CG_CL_IntakeWarranty();
        Cache.Session.put('UserERPSystem', '');
        
       // intakeWar.Wid=null;
        intakeWar.pageAction(); 
        intakeWar.pgSave();
        intakeWar.nvIntakeCustomer();
        intakeWar.nvIntakeUE();
        intakeWar.nvIntakeVH();
        intakeWar.nvIntakeCustomer();
        intakeWar.nvIntakeRJ();
        intakeWar.nvIntakeCC();
        intakeWar.redirectPopup();
        intakeWar.Redirect();
        intakeWar.Cancel();        
        intakeWar.closeSession();
        
        Test.stopTest();
        
    }
 static testmethod void testsaveIntakeWarrantymethod()
 {
     CG_CL_IntakeWarranty saveIntake = new CG_CL_IntakeWarranty();
     css_job_order__c SaveInkJo = new css_job_order__c();
     SaveInkJo.Customer_Name__c='Gopal';
     SaveInkJo.Customer_Code__c='123';
     SaveInkJo.ESN__c='59845870';
     SaveInkJo.Shop_Work_Order__c = '1234';
     SaveInkJo.Status__c='Intake';
     insert SaveInkJo;
     css_job_order__c job1 = [select id,Customer_Name__c,Customer_Code__c,ESN__c,Shop_Work_Order__c,Status__c from css_job_order__c limit 1 ];
     saveIntake.workJob=Job1;
     apexpages.currentPage().getparameters().put('id',Job1.Id);
     Cache.Session.put('UserERPSystem', 'BMS Legacy');
     SaveIntake.pgSave();
     SaveIntake.Cancel();
     
     
 }
     static testmethod void testsaveIntakeWarrantymethod1()
 {
     CSS_Job_Order__c JO = new CSS_Job_Order__c();
                   
        JO.Customer_Name__c = 'Test Customer';
        JO.Application__c = 'Recreational Vehicle';
        JO.Model__c = 'ModelTest';
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
        JO.Status__c = 'Intake';
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
        jo.CSS_Channel_Code__c='Testing';
               
        insert JO;
        
        ApexPages.currentPage().getParameters().put('id',JO.id);
    
    CG_CL_IntakeWarranty SaveIntake = new CG_CL_IntakeWarranty();
     Cache.Session.put('UserERPSystem', 'BMS Legacy');
     SaveIntake.pgSave();
     saveIntake.closeSession();
     SaveIntake.Cancel();
  
     
     
 }
    static testmethod void testsaveIntakeWarrantymethod2()
 {
     CG_CL_IntakeWarranty saveIntake = new CG_CL_IntakeWarranty();
     css_job_order__c SaveInkJo = new css_job_order__c();
     SaveInkJo.Customer_Name__c='Gopal';
     SaveInkJo.Customer_Code__c='123';
     SaveInkJo.ESN__c='59845870';
     SaveInkJo.Shop_Work_Order__c = '1234';
     SaveInkJo.Status__c='Intake';
     insert SaveInkJo;
     css_job_order__c job1 = [select id,Customer_Name__c,Customer_Code__c,ESN__c,Shop_Work_Order__c,Status__c from css_job_order__c limit 1 ];
     saveIntake.workJob=Job1;
     apexpages.currentPage().getparameters().put('id',Job1.Id);
    // Cache.Session.put('UserERPSystem', 'BMS Legacy');
     SaveIntake.pageAction();
     
     
 }
}