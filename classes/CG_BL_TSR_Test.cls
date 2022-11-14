@isTest
public class CG_BL_TSR_Test {
    
    
static TestMethod void TestBLTSR() {
        CG_BL_TSR CGTSR = new CG_BL_TSR();
        Test.startTest();
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'k100001', Email='standarduser10001@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='kal12',FirstName='kal', LanguageLocaleKey='en_US',Phone='8888888', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '562701-562551',UserRoleId = empRole.id);
      insert(u);
        
      System.runAs(u) {  
         
         CSS_Integration_Details__c condet = new CSS_Integration_Details__c();
 condet.Name = 'TSR';
 condet.AuthEnv__c = 'OAGDev';
 condet.ApplicationName__c = 'TSR';
 condet.Username__c = 'HfL6S926+ZPvI5xOyy4VEZnCNhVtWWFyWx8tnH9xgqE=';
 condet.End_Point__c = 'https://services-dev.cummins.com/css/technicianservicerequest';
 condet.Method_Type__c = 'POST';
 condet.Timeout__c = 2.0;
 insert condet;
         
          CSS_List_Of_Values__c CLV = new CSS_List_Of_Values__c();
        CLV.Name = 'Test'+math.random();
        CLV.Type__c = 'ComplaintCodes';
        CLV.Code__c = '121';
        CLV.Picklist_Values_1__c = 'AIR LEAK';
        insert(CLV);//Fuel - Oil - Coolant
                CSS_Job_Order__c JO = CSS_TestData.createJobOrder(false);
          JO.Complaint_Type_Desc__c = 'Fuel - Oil - Coolant';
          insert JO;
          CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =JO.Id; 
            //fauCodRef.Fault_Code__c=2182; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
          fauCodRef.FaultCodeR2__c='3539';
            fauCodRef.Status__c='A';
        insert fauCodRef;
        List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
        fauCodRefList.add(fauCodRef);
           CSS_SymptomQA__c symp = new CSS_SymptomQA__c();
        symp.name = 'smoke';
        symp.Caption__c = 'smoke';
        symp.Type__c = 'SearchString';
        symp.Job_Order__c = JO.id;
        insert symp;
          
          CSS_SymptomQA__c symp1 = new CSS_SymptomQA__c();
        symp1.name = 'smoke';
        symp1.Caption__c = 'smoke';
        symp1.Type__c = 'SearchString';
        symp1.Job_Order__c = JO.id;
          symp1.searchstring__c = symp.id;
        insert symp1;
          List<CSS_SymptomQA__c> Lstsymp = new List<CSS_SymptomQA__c>();
          Lstsymp.add(symp);
          Lstsymp.add(symp1);
          
          CSS_Solutions__c solRef =  CSS_TestData.createSolutions(false,JO.Id);
          solRef.FaultCode__c = fauCodRef.id;
          solRef.Symptom__c = symp.id;
          solRef.Diagnostic_Response__c = '';
          insert solRef;
                     String CategoryString  = '{"DataArea":{"Details":[{"Category":"Fuel - Oil - Coolant","Description":"Fuel - Oil - Coolant","BusinessUnit":"EBU","ComplaintCode":"106","ActiveFlag":"Y"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
           CSS_JobEventTemporary__c  jobEventRef = CSS_TestData.createJobEventTempObj(false);
                     jobEventRef.Attribute1__c ='CategoryComplaintCodes';
                     jobEventRef.Reason__c= CategoryString;
                     insert  jobEventRef;
        
          PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
          CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
          CG_BL_TSR.performTSRBusinessLogic();
        //CG_BL_TSR.insertException(OPWrap,JO.id);
          CG_BL_TSR.saveTSRResponse(OPWrap,JO.id,JO.id);
         CG_BL_TSR.deriveCustomerSupportLevel(true,fauCodRefList,Lstsymp);
        CG_BL_TSR.deriveComplaintCode(JO);
         CG_BL_TSR.deriveEscalationGroup(JO.Service_Model__c);
          
        Test.stopTest();
      }
    }
    
static testmethod void TestPerformTSRBuisness()
{
    
    List<CSS_Fault_Code__c> fauCodRefList = new List<CSS_Fault_Code__c>();
     CSS_SymptomQA__c symp = new CSS_SymptomQA__c();
    CSS_SymptomQA__c symp1 = new CSS_SymptomQA__c();
    List<CSS_SymptomQA__c> Lstsymp = new List<CSS_SymptomQA__c>();
     CG_OP_OAGWrapper OPWrap = new CG_OP_OAGWrapper();
    userrole usrrole = [select id from userrole where name = 'Factory' limit 1];
    profile p = [select id from profile where Name='System Administrator'];
    user u = new user(Alias = 'k100001', Email='standarduser10001@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='kal12',FirstName='kal', LanguageLocaleKey='en_US',Phone='8888888', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='kal11111@testorg.com', user_Location__c = '562701-562551',UserRoleId = usrRole.id);
    insert u;
    system.runAs(u)
    {
        
        
          CSS_List_Of_Values__c CLV = new CSS_List_Of_Values__c();
        CLV.Name = 'Test'+math.random();
        CLV.Type__c = 'ComplaintCodes';
        CLV.Code__c = '121';
        CLV.Picklist_Values_1__c = 'AIR LEAK';
        insert(CLV);
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.Customer_Name__c = 'Testing5';
            JO.Application__c = 'Recreational Vehicle';
            JO.Model__c = 'Test';
            JO.Make__c = 'CSSTest';
            JO.Notes__c = 'CAMPCOMMENTS';
            JO.Failure_Point__c = 122;
            JO.Failure_Point_Measure__c = 'Miles';
            JO.VIN__c = '12345677890';
            JO.Failure_Date__c = date.today() - 20;
            JO.Warranty_Start_Date__c = date.today() - 40;
            JO.Location_Certification__c = 'abc';
            JO.jobLocation__c = '562701-562551';
            JO.Before_In_Service__c = True;
            JO.Status__c = 'Repair Complete';
            JO.Unit_Number__c = 'test123';
           Jo.Assigned_To__c = u.id;
            Jo.esn__c = '73595986';
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
            JO.Service_Model__c = 'test';  
            JO.Qsol_Engine_Family_Code__c = 'famcode';
            JO.Equipment_ID__c='equipID';
			JO.Mileage__c = 21;
			JO.Mileage_Measure__c = 'Miles';
			jo.ApplicationCode__c = '122';
           JO.Complaint_Type_Desc__c = 'Fuel - Oil - Coolant';
                insert JO;
        system.debug('jobname:-'+jo.id);
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='562701';
        acc.CSS_DealerCode__c='562551';
        insert acc;
        system.debug('accounr'+acc);
    string location = [select id,location__c from account where id=:acc.id].location__c;

         CSS_Accreditation__c ac = new CSS_Accreditation__c();
        ac.name='Rtest';
        ac.Account__c = acc.id;
        ac.Service_Model_Name__c = jo.Service_Model__c;
        insert ac;
        system.debug('Accredition'+ac);
        
        CSS_AccredUser__c ac1 = new CSS_AccredUser__c();
      ac1.Accreditation__c = ac.id;
       ac1.User__c = u.id;
       ac1.Promotion_Id__c = 'A440844';
        insert ac1;
        system.debug('Accredition'+ac1);
        list<CSS_AccredUser__c> ac2 = new list<CSS_AccredUser__c>();
        ac2.add(ac1);
        system.debug('list of accred Used for this location:'+ac2);
        
        CSS_Fault_Code__c fauCodRef = new CSS_Fault_Code__c();
            fauCodRef.Job_Order__c =JO.Id; 
            //fauCodRef.Fault_Code__c=2182; 
            fauCodRef.Sequence__c=1;
            fauCodRef.Fault_Code_Type__c='BPD'; 
            fauCodRef.Primary_Fault_Code__c=3539; 
          fauCodRef.FaultCodeR2__c='3539';
            fauCodRef.Status__c='A';
        insert fauCodRef;
        fauCodRefList.add(fauCodRef);
         
        symp.name = 'smoke';
        symp.Caption__c = 'smoke';
        symp.Type__c = 'SearchString';
        symp.Job_Order__c = JO.id;
        insert symp;
          
          
        symp1.name = 'smoke';
        symp1.Caption__c = 'smoke';
        symp1.Type__c = 'SearchString';
        symp1.Job_Order__c = JO.id;
          symp1.searchstring__c = symp.id;
        insert symp1;
        Lstsymp.add(symp);
          Lstsymp.add(symp1);
         String CategoryString  = '{"DataArea":{"Details":[{"Category":"Fuel - Oil - Coolant","Description":"Fuel - Oil - Coolant","BusinessUnit":"EBU","ComplaintCode":"106","ActiveFlag":"Y"}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}';
           CSS_JobEventTemporary__c  jobEventRef = CSS_TestData.createJobEventTempObj(false);
                     jobEventRef.Attribute1__c ='CategoryComplaintCodes';
                     jobEventRef.Reason__c= CategoryString;
                     insert  jobEventRef;
        PageReference pref;
        pref = new pagereference('/'+jo.id);
        pref.getParameters().put('id',jo.Id);
        test.setCurrentPage(pref);
        CSS_Integration_Details__c condet = new CSS_Integration_Details__c();
 condet.Name = 'TSR';
 condet.AuthEnv__c = 'OAGDev';
 condet.ApplicationName__c = 'TSR';
 condet.Username__c = 'HfL6S926+ZPvI5xOyy4VEZnCNhVtWWFyWx8tnH9xgqE=';
 condet.End_Point__c = 'https://services-dev.cummins.com/css/technicianservicerequest';
 condet.Method_Type__c = 'POST';
 condet.Timeout__c = 2.0;
 insert condet;
      //  Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        Test.setMock(HttpCalloutMock.class, new CG_TSRMock_Test());
        datetime endDt = System.now();
        datetime startDt = System.now();
        Long totalTime = endDt.getTime() - startDt.getTime();
        Test.startTest();
         CG_BL_TSR CGTSR = new CG_BL_TSR();
        CG_BL_TSR.performTSRBusinessLogic();
        test.stopTest();
    }
    
    }
}