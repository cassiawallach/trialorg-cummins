@isTest(seeAllData=True)
public class CSS_AccessCheckWBSrvcTest {
    /*public static void accessTokentest() {
        Test.setMock(HttpCalloutMock.class, new CSS_SRTAccessCheckTokenTest());
        CSS_SRTAccessWebService.receiveToken(); 
    }
    public static void accessSRTTest()
    {
        css_JobEventTemporary__c jobTemp = new css_JobEventTemporary__c();
            
    }*/ 
    
    public static testMethod void accessCheck(){
        // insert JobOrderId object
        css_job_order__c joborder = new css_job_order__c();
        //joborder.name = 'test';
        joborder.Equipment_ID__c = 'test';
        joborder.Qsol_Engine_Family_Code__c = '100';
        joborder.Service_Model__c = '100';
        insert joborder;
        system.debug('joborder=='+joborder);
        
        //insert CSS_Solutions__c
        CSS_Solutions__c css = new CSS_Solutions__c();
        css.service_job__c = joborder.id;
        css.name = 'test';
        insert css;
        //insert CSS_srt__c
        
        ApexPages.currentPage().getParameters().put('JobOrderId', joborder.id);
        ApexPages.currentPage().getParameters().put('solutionId', css.id);
        ApexPages.currentPage().getParameters().put('typ', 'rep');
        
        CSS_SRTAccessCheckListCL controller = new CSS_SRTAccessCheckListCL();
        controller.lstDisplaySRT[0].SRT_AccessiblityCheck__c = TRUE;
        controller.saveNClose();
        
        //insert CSS_JobEventTemporary__c    
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.JobOrder__c = joborder.id;
        jobevent.Attribute1__c = joborder.Qsol_Engine_Family_Code__c;
        jobevent.Attribute2__c = joborder.Equipment_ID__c;
        jobevent.Attribute3__c = 'test';
        jobevent.Service_Model_Name__c = joborder.Service_Model__c;
        jobevent.Source__c = 'SRT';
        jobevent.Type__c = 'Repair Access';// give type from parameters
        jobevent.ExpireDateTime__c = System.Now()+1000;
        insert jobevent;
        system.debug('jobevent==='+jobevent);        
        
        CSS_srt__c srt = new CSS_srt__c();
        srt.Solution_Number__c = css.id;
        srt.Job_order__c = joborder.id;
        srt.Type__c = 'Repair Access';
        srt.SRT_Details__c = 'test';
        srt.SRT_Title__c = 'MR';
        insert srt;
        
        // insert CSS_Integration_Details__c
        CSS_Integration_Details__c intdetails = new CSS_Integration_Details__c();
        intdetails.ApplicationName__c = '';
        intdetails.isactive__c = true;
        // insert intdetails ;
        // inset the above later now we use exsisting
    
    }
        
}