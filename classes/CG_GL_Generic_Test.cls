@IsTest(seealldata = false)
public class CG_GL_Generic_Test{
 
public static testmethod void TestData(){
    CSS_Job_Order__c Jo = CSS_TestData.createJobOrder(false);
    Jo.BMSStatus__c = 'WC1';
    
    insert Jo;
    List<CSS_Solutions__c> lstsolRef = new List<CSS_Solutions__c>();
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Service_Job__c=JO.Id;
        solRef.Solution_title__c='TestData';
        insert solRef; 
        lstsolRef.add(solRef);
    CSS_Make_Model_Access__c MakeList = new CSS_Make_Model_Access__c();
        CSS_Make_Model_Access__c mk = new CSS_Make_Model_Access__c();
     //   mk.Name = '100-EQ6423-32-E';       
        mk.Access__c = 'D';
        mk.Make__c = 'DRESSER';
        mk.Model__c = '100';
        insert mk;
    CG_GL_Generic genT = new CG_GL_Generic();
    genT.tndverification();
    PageReference p=Page.CSS_JobInvoice; 
        Test.setCurrentPage(p);  
        ApexPages.currentPage().getParameters().put('id',jo.Id); 
        CG_CL_Invoice J1= new CG_CL_Invoice();
    J1.workJob=Jo;
        J1.workjob.Make__c='Miles';
        J1.workjob.Make__c='';
        J1.workjob.Model__c='Miles';
        J1.workjob.Model__c='';
     
        J1.css_redirect();  

  }
       static testMethod void CG_GL_Generic_Test_Method()
    {
         
        Test.startTest();    
        
        css_job_order__c JO = CSS_TestData.createJobOrder(true);
        List<CSS_Solutions__c> lstsolRef = new List<CSS_Solutions__c>();
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Service_Job__c=JO.Id;
        solRef.Solution_title__c='TestData';
        insert solRef; 
        lstsolRef.add(solRef);
        system.debug('lstsolRef---->'+lstsolRef);
        system.debug('solRef---->'+solRef);
        CG_GL_Generic J3 = new CG_GL_Generic();
        J3.CG_GL_Generic();
        J3.tndverification();
         CG_CL_Invoice J2= new CG_CL_Invoice ();
        J2.workJob =JO;
       // J3.mil_measure='Miles';
      //  J3.fail_measure='Miles';
      //  J3.css_redirect();  
        Test.stopTest();
    }

}