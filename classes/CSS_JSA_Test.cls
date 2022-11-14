@isTest
public class CSS_JSA_Test {
    static testMethod void CSS_JSA_Test() {
        
        //Add test data. 
        Test.startTest();             
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'RoopaTnD';
            JO.Model__c = 'RoopaTestTnD';
            JO.Service_Model_N__c = 20;
            //JO.Shop_s_Work_Order__c = 140;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'test1234';
            Jo.Assigned_To__c = UserInfo.getUserId();
            Jo.Application__c = 'Fire Truck';
            Jo.Additional_Tech1__c = UserInfo.getUserId();
            Jo.Additional_Tech2__c = UserInfo.getUserId();
            insert(JO);
        
        	CSS_JobForms__c jb = new CSS_JobForms__c();
        	jb.Name = 'test';
        	jb.Service_Job__c = Jo.id;
            jb.JSA_Clone__c = 'test';
        	insert jb;
        	
        	CSS_JobForm_Detail__c jfd = new CSS_JobForm_Detail__c();
        	jfd.CSS_JobForms__c = jb.id;
        	jfd.JSA_WorkPractice_CriticalBehaviour__c = 'Eyes on Path';
        	jfd.JSA_Ergonomics_CriticalBehaviour__c = 'Knee';
        	jfd.JSA_Tools_CriticalBehaviour__c = 'Tools/Equip. Use';
            jfd.JSA_PPE_CriticalBehaviour__c = 'Fall Protection';
            jfd.JSA_WrkProcedures_CriticalBehaviour__c = 'Hot Work';
            jfd.JSA_CNG_CriticalBehaviour__c = 'Training';
            
        	insert jfd;
        
        Test.stopTest();
        
        PageReference pageRef = Page.CSS_JSAForm;
        pageRef.getParameters().put('id', jo.id);
        pageRef.getParameters().put('jformId', jb.id);
        //ApexPages.currentPage().getParameters().put('id', jo.id);
        Test.setCurrentPage(pageRef);
        Css_JSA c = new Css_JSA();
        c.showPopup();
        c.closePopup();
        c.formSave();
        c.cloneForm();
        
        c.getriskvaluue();
        c.getclosedctrl();
        
        c.lstwrapWorkPracticeValues = null;  
    	c.lstwrapErgonomicsValues = null;   
        c.lstwrapToolsValues = null; 
    	c.lstwrapPPEValues = null;   
    	c.lstWorkProceduresValues = null;  
    	c.lstwrapCNGValues = null; 
        
        c.getWorkPracticeValuess();
        c.getErgonomics();
        c.getTools();
        c.getPPE();
        c.getWorkProcedures();
        c.getCNG();
        c.Save = 'eee';

    }
}