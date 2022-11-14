/*
Test CLass for Customer Complaint Controller - CG_CL_IntakeCC
*/
/**********************************************************************
Name:CG_CL_IntakeCustomer
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this Page Controller for Customer Chevron.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Rupesh Pande      02/19/2018      INITIAL DEVELOPMENT  
*****************Covering 80% till now.********************
***********************************************************************/
@isTest(seealldata = false)
private class CG_CL_IntakeCC_Test
{
    static cg_cl_intakecc cci;
    static CSS_Job_Order__c JO = new CSS_Job_Order__c();
    static id joid;
    @testsetup 
    static void createtestdata()
    {
	    //Create a job event temporary data
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
        id jobevid=jobevent.id;
        //Create a job order temporary data
        
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
        joid=jo.id;
    }
    
    static testmethod void saveIntakeccheck()
    {
        //Since jo is created in testsetup we can directly query
        jo=[select id,name,Category_Desc__c,Complaint_Type_Desc__c from CSS_Job_Order__c ];
        
		//update the url with the claims id genereated with test data
    	PageReference pg = Page.CG_IntakeCC;
    	Test.setCurrentPage(pg);    
    	apexpages.currentPage().getparameters().put('id',jo.id); 
    	//Check if the Intake CC URL is appeneded with ID
    	string stdclurl=apexpages.currentPage().geturl();    
    	system.debug('Modified test data with id url is...'+stdclurl);  
    	//Create an IntakeCC object
    	CG_cl_IntakeCC tobj=new CG_cl_IntakeCC();
        tobj.displayPopup = true;
        tobj.pgsave();
        id savedccid=tobj.saveCC(jo.id,'Draft');
        system.assertEquals('/apex/cg_intakecc?id='+savedccid, stdclurl);  
    }
    static testmethod void categoryIntakeccheck()
    {
        CG_CL_IntakeCC iCC = new CG_CL_IntakeCC();
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        iCC.setfilterCategory('TestCategory');
        iCC.setfilterCategory2('TestCategory');
        iCC.setfilterCategory3('TestCategory');
        iCC.setfilterCategory4('TestCategory');
        iCC.setfilterCategory5('TestCategory');
        string gfcc=iCC.getfilterCategory();
        //system.assertEquals(expected, actual)
        system.assertEquals('TestCategory', gfcc);
        
        iCC.setfilterCategory2('TestCategory');
        string gfcc2=iCC.getfilterCategory2();
        //system.assertEquals(expected, actual)
        system.assertEquals('TestCategory', gfcc2);
        
        iCC.setfilterCategory3('TestCategory');
        string gfcc3=iCC.getfilterCategory3();
        //system.assertEquals(expected, actual)
        system.assertEquals('TestCategory', gfcc3);
        
        iCC.setfilterCategory4('TestCategory');
        string gfcc4=iCC.getfilterCategory4();
        //system.assertEquals(expected, actual)
        system.assertEquals('TestCategory', gfcc4);
        
        iCC.setfilterCategory5('TestCategory');
        string gfcc5=iCC.getfilterCategory5();
        //system.assertEquals(expected, actual)
        system.assertEquals('TestCategory', gfcc5);
    }
    
    static testmethod void filtercomptypecheck()
    {
        CG_CL_IntakeCC iC = new CG_CL_IntakeCC();
        Cache.Session.put('UserERPSystem', 'BMS Legacy');
        iC.setfilterComplaintType('Testfctype');
        iC.setfilterComplaintType2('Testfctype');
        iC.setfilterComplaintType3('Testfctype');
        iC.setfilterComplaintType4('Testfctype');
        iC.setfilterComplaintType5('Testfctype');
        string gfcc=iC.getfilterComplaintType();
        //system.assertEquals(expected, actual)
        system.assertEquals('Testfctype', gfcc);
        
        iC.setfilterComplaintType2('Testfctype');
        string gfcc2=iC.getfilterComplaintType2();
        //system.assertEquals(expected, actual)
        system.assertEquals('Testfctype', gfcc2);
        
        iC.setfilterCategory3('Testfctype');
        string gfcc3=iC.getfilterComplaintType3();
        //system.assertEquals(expected, actual)
        system.assertEquals('Testfctype', gfcc3);
        
        iC.setfilterCategory4('Testfctype');
        string gfcc4=iC.getfilterComplaintType4();
        //system.assertEquals(expected, actual)
        system.assertEquals('Testfctype', gfcc4);
        
        iC.setfilterCategory5('Testfctype');
        string gfcc5=iC.getfilterComplaintType5();
        //system.assertEquals(expected, actual)
        system.assertEquals('Testfctype', gfcc5);
        
    }
    static testmethod void navigationmethodchecks()
    {
    //Since jo is created in testsetup we can directly query
    jo=[select id,name,Category_Desc__c,Complaint_Type_Desc__c from CSS_Job_Order__c ];
    PageReference pg = Page.CG_IntakeCC;
    Test.setCurrentPage(pg);    
    apexpages.currentPage().getparameters().put('id',jo.id); 
    cci=new cg_cl_intakecc();
    
	PageReference PGW1 = cci.nvIntakeCustomer();
    String curl1=pgw1.getUrl();
    //Assertion Failed: Expected: /apex/CG_IntakeCustomer?id=a093B0000027bmpQAA, Actual: /apex/CG_IntakeCustomer?id=
    system.assertequals(curl1,'/apex/CG_IntakeCustomer?id='+jo.id);  
       
    PageReference PGW2 = cci.nvIntakeUE();
    String curl2=pgw2.getUrl();
    system.assertequals(curl2,'/apex/CG_IntakeUE?id='+jo.id);
        
    PageReference PGW3 = cci.nvIntakeVH();
    String curl3=pgw3.getUrl();
    system.assertequals(curl3,'/apex/CG_IntakeVH?id='+jo.id);
        
    PageReference PGW4 = cci.nvIntakeWarranty();
    String curl4=pgw4.getUrl();
    system.assertequals(curl4,'/apex/CG_IntakeWarranty?id='+jo.id);
        
    PageReference PGW5 = cci.nvIntakeRJ();
    String curl5=pgw5.getUrl();
    system.assertequals(curl5,'/apex/CG_IntakeRJ?id='+jo.id);
    }
    
    Static testmethod void ResallMethTest() 
    {
    //Since jo is created in testsetup we can directly query
    jo=[select id,name,Category_Desc__c,Complaint_Type_Desc__c from CSS_Job_Order__c ];
    PageReference pg = Page.CG_IntakeCC;
    Test.setCurrentPage(pg);    
    apexpages.currentPage().getparameters().put('id',jo.id); 
    cci=new cg_cl_intakecc();
    cci.ChkFieldBlank();
    cci.closeSession();
    cci.Cancel();
    cci.getQSOLDocs();
    cci.redirectPopup();
    cci.pageAction();
    cci.getCategoryList();
	cci.getComplaintTypeList();
    cci.getComplaintTypeList2();
    cci.getComplaintTypeList3();
    cci.getComplaintTypeList4();
    cci.getComplaintTypeList5();
    }
    


}