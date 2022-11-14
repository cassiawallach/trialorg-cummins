/*
Test CLass for Customer Complaint component Controller - CG_CL_IntakeCCComp
*/
@isTest
public class CG_CL_IntakeCCComp_Test{
    
    Static testmethod void CG_CL_IntakeCCComp_TestMethod1() {
        // Update the test class     
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
        JO.Category_Desc__c = null;
        JO.Category2__c= null;
        JO.Category3_Desc__c=null;
        JO.Category4_Desc__c=null;
        Jo.Category5_Desc__c=null;
        
        
        JO.Complaint_Type_Desc__c = null;
        Jo.Complaint_Type2_Desc__c = null;
        JO.Complaint_Type3_Desc__c = '----None----';
        JO.Complaint_Type4_Desc__c = '----None----';
        JO.Complaint_Type5_Desc__c = '----None----';
               
        insert JO;
        System.debug('jo........'+JO);
        
        Note note = new Note();
        note.Title = 'CAMPCOMMENTS';
        note.ParentId = JO.Id;  
        note.Body = 'Bold';
        insert note;
        
        
        
        list < CSS_CampTsbTrp__c > solutionList = new list < CSS_CampTsbTrp__c > ();
        CSS_Solutions__c cssSol;
        
        
        CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                         Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = JO.Id,
                                                         Performed_Review__c = false, Reviewed__c = false, esn__c = '79464646');
        solutionList.add(solRec);
        
        CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB14013368', URL__c = 'https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                          Type__c = 'TRP', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, Job_Order__c = JO.Id,
                                                          Performed_Review__c = true, Reviewed__c = false, esn__c = '79464646');
        solutionList.add(solRec2);
        
        CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB1401689', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c = 'TSB', Doc_Title__c = 'xyzk', Cu_Language__c = 'xc', Performed__c = true, Job_Order__c = JO.Id,
                                                          Performed_Review__c = false, Reviewed__c = false, esn__c = '79464646');
        solutionList.add(solRec1);
        
        insert solutionList;
      
      //Record for Country State Values
        CSS_CountryStateValues__c countryState = new CSS_CountryStateValues__c();
        countryState.Name = 'USIN';
        countryState.CountryCode__c = 'United States';
        countryState.CountryName__c = 'US';
        countryState.StateCode__c = 'Indiana';
        countryState.StateName__c = 'IN';
        insert countryState;
        
        // PageReference pref;
       // pref = new PageReference('/'+JO.id);
       // pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
       // Test.setCurrentPage(pref);
        
         
         //CG_CL_IntakeUE cciue = new CG_CL_IntakeUE();
        
        
               
       // ApexPages.currentPage().getParameters().put('id',JO.id);
       // 
       list <CSS_CampTsbTrp__c> solutionList1 = new list < CSS_CampTsbTrp__c > ();
        CSS_CampTsbTrp__c solRec23 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB140168', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                         Type__c = 'CAM', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false,
                                                         Performed_Review__c = false, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList1.add(solRec23);
        CSS_CampTsbTrp__c solRec24 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB14013368', URL__c = 'https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                          Type__c = 'TRP', Doc_Title__c = 'xyz', Cu_Language__c = 'xc', Performed__c = false, 
                                                          Performed_Review__c = true, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList1.add(solRec24);
        CSS_CampTsbTrp__c solRec11 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB1401689', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c = 'TSB', Doc_Title__c = 'xyzk', Cu_Language__c = 'xc', Performed__c = true, 
                                                          Performed_Review__c = false, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList1.add(solRec11);
        CSS_CampTsbTrp__c solRec7 = new CSS_CampTsbTrp__c(Doc_Num__c = 'TSB1401689', URL__c = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c = 'ATC', Doc_Title__c = 'xyzk', Cu_Language__c = 'xc', Performed__c = true, 
                                                          Performed_Review__c = false, Reviewed__c = false, esn__c = jo.ESN__c,Job_Order__c=JO.id);
        solutionList1.add(solRec7);
        
        insert solutionList1;
        
        CSS_Solution_Component__c sl = new CSS_Solution_Component__c();
        sl.Service_Job__c =jo.id;
        sl.Type__c = 'TRP';
        sl.Status__c = 'Approved';
        sl.Complete_Indicator__c = true;
        sl.Multiple_Times__c = true;
        insert sl;
             
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id',JO.id);
        String json = '{'+    
'  \"Header\": {'+
'    \"ReturnCodeDescription\": \"test\",'+
'    \"Status\": \"completed\"'+
'      },'+
'\"DataArea\": {'+
'\"Details\": ['+
'{'+
'\"ComplaintCode\": \"1117\",'+
'\"Description\": \"21319736\",'+

        '\"BusinessUnit\": \"inactive\",'+
'\"Category\": \"aaa\"'+
'},'+
'{'+
'\"ComplaintCode\": \"1117\",'+
'\"Description\": \"21319736\",'+
'\"BusinessUnit\": \"inactive\",'+
        
'\"Category\"    : \"1\"'+
'},'+
        '{'+
'\"ComplaintCode\": \"1117\",'+
'\"Description\": \"21319736\",'+

        '\"BusinessUnit\": \"inactive\",'+
'\"Category\"    : \"1\"'+
'},'+
        '{'+
'\"ComplaintCode\": \"1117\",'+
'\"Description\": \"21319736\",'+

        '\"BusinessUnit\": \"inactive\",'+
'\"Category\"    : \"1\"'+
'}'+
            
']'+
        '}'+
'}';
        
CSS_WPR_SBL_CatComplaintsListResJSON obj = CSS_WPR_SBL_CatComplaintsListResJSON.parse(json);
        
        string PageName ='IntakeUE';
        CG_CL_IntakeCCComp iCC = new CG_CL_IntakeCCComp();
        CG_CL_IntakeRJ rj = new CG_CL_IntakeRJ();
        //rj.mainSOQLs();
        rj.workjob = JO;
        System.debug('rj.workjob..'+rj.workjob);
        icc.mainContr = rj;
        icc.PageName = 'IntakeUE';
        PageReference pageRef = Page.CG_ClaimsIntake;
        Test.setCurrentPage(pageRef);
        Cache.Session.put('UserERPSystem', 'BMS Legacy');  
        //iCC.filterCategory = ;
        iCC.setfilterCategory('aaa');
        iCC.getfilterCategory();
         iCC.setfilterCategory2('TestCategory2'); 
        iCC.getfilterCategory2();
         iCC.setfilterCategory3('TestCategory3');   
        iCC.getfilterCategory3();
        iCC.setfilterCategory4('TestCategory4');
        iCC.getfilterCategory4();
        iCC.setfilterCategory5('TestCategory5');
        iCC.getfilterCategory5();
         iCC.setfilterComplaintType('TestComplaintType1');
        iCC.getfilterComplaintType();
        iCC.setfilterComplaintType2('TestComplaintType2');
        iCC.getfilterComplaintType2();
       iCC.setfilterComplaintType3('TestComplaintType3');
        iCC.getfilterComplaintType3();
        iCC.setfilterComplaintType4('TestComplaintType4');
        iCC.getfilterComplaintType4();
        iCC.setfilterComplaintType5('TestComplaintType5');
        iCC.getfilterComplaintType5();
        iCC.getCategoryList();
        iCC.getComplaintTypeList();
        iCC.getComplaintTypeList2();
        iCC.getComplaintTypeList3();
        iCC.getComplaintTypeList4();
        iCC.getComplaintTypeList5();
        //iCC.getCategoryList();
   
        
        Test.stopTest();
        
    }
   

}