@isTest
public class CG_CL_UpdateFailureODMStatus_Test {
static testMethod void TestMethod1()
    {
      test.startTest();
        list<id> idlist = new list<id>();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.Make__c = 'test1234';
        JO.Model__c = 'test1234';
        JO.DSID__c = 'test1234';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        JO.Failure_Date__c=date.today();
        JO.ESN__c = '79464646';
    
        insert(JO);
        
        css_claims__c claims= new css_claims__c();
        claims.Account__c = acc.id;
        insert claims;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Service_Job__c=JO.Id;
        solRef.Solution_title__c='TestData';
        insert solRef;
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,JO.Id,solRef.Id);
        solComRef.pay_code__c = 'A';
        solComRef.css_claims__c = claims.id;
        insert solComRef;
    	 idlist.add(solComRef.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.Service_Job__c = JO.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
      
        po.Account_Code__c ='A'; 
        po.Solutions__c=solRef.id;
        po.FailurepartId__c =solComRef.Id; 
        po.ODM_Status__c = '';
        po.CSS_Claims__c=claims.id;
        lstpo.add(po);
		 CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.Service_Job__c = JO.id;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
      
        po1.Account_Code__c ='A'; 
        po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =solComRef.Id; 
        po1.ODM_Status__c = '';
        po1.CSS_Claims__c=null;
        lstpo.add(po1);
        insert lstpo;
        
        /*CSS_SRT__c srt=new CSS_SRT__c();
        //srt.CSS_Claims__c=claims.id;
        srt.Job_Order__c=JO.id;
        srt.ODM_Status__c='';
        srt.Account_Code__c='71';
        
        insert srt;*/
        CSS_SRT__c srt1=new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.id;
        //srt.Job_Order__c=JO.id;
        srt1.ODM_Status__c='';
        srt1.Account_Code__c='70';
	insert srt1;        
        CG_CL_UpdateFailureODMStatus.updateODMStatusForFailures(idlist);
        test.stopTest();
       
        
}
    static testMethod void TestMethod2()
    {
      test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        list<id> idlist = new list<id>();
        CSS_Job_Order__c JO = NEW CSS_Job_Order__c();
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Account__c = acc.id;
        JO.Status__c = 'Repair Complete';
        JO.Make__c = 'test1234';
        JO.Model__c = 'test1234';
        JO.DSID__c = 'test1234';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        JO.Failure_Date__c=date.today();
        JO.ESN__c = '79464646';
    
        insert(JO);
        
        css_claims__c claims= new css_claims__c();
        insert claims;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Service_Job__c=JO.Id;
        solRef.Solution_title__c='TestData';
        insert solRef;
        CSS_Solution_Component__c solComRef = CSS_TestData.createSRT(false,JO.Id,solRef.Id);
    	 idlist.add(solComRef.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.Service_Job__c = JO.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
      
        po.Account_Code__c ='A'; 
        po.Solutions__c=solRef.id;
        po.FailurepartId__c =solComRef.Id; 
        po.ODM_Status__c = '';
        po.CSS_Claims__c=claims.id;
        lstpo.add(po);
		 CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.Service_Job__c = JO.id;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
      
        po1.Account_Code__c ='A'; 
        po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =solComRef.Id; 
        po1.ODM_Status__c = '';
        po1.CSS_Claims__c=null;
        lstpo.add(po1);
        insert lstpo;
        
       /* CSS_SRT__c srt=new CSS_SRT__c();
        srt.CSS_Claims__c=claims.id;
        srt.Job_Order__c=Null;
        srt.ODM_Status__c='';
        srt.Account_Code__c='61';*/
        
        CSS_SRT__c srt=new CSS_SRT__c();
        //srt.CSS_Claims__c=claims.id;
        srt.Job_Order__c=JO.id;
        srt.ODM_Status__c='';
        srt.Account_Code__c='71';
        
        insert srt;
        
       // insert srt;
        
        CG_CL_UpdateFailureODMStatus.updateODMStatusForFailures(idlist);
        test.stopTest();
       
        
}
  static testMethod void TestClaim()
    {
      test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
         CSS_Claims__c testclaimsRec = new CSS_Claims__c();
    CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
         	testclaimsRec.Customer_Name__c='TestCustomer';
         	testclaimsRec.Account__c = acc.id;
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
            testclaimsRec.CSS_Job__c=jo.Id;
      insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
      insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
		CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = testclaimsRec.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode35';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit35';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
            insert AddsolComp;
    	 idlist.add(AddsolComp.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='A'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
		 CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = testclaimsRec.id;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='A'; 
       // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id; 
        po1.ODM_Status__c = '';
        lstpo.add(po1);
       
        insert lstpo;
         CSS_SRT__c srt=new CSS_SRT__c();
        srt.CSS_Claims__c=testclaimsRec.id;
        srt.Job_Order__c=Null;
        srt.ODM_Status__c='';
        srt.Account_Code__c='61';
        
        insert srt;
        
        CG_CL_UpdateFailureODMStatus.updateODMStatusForFailures(idlist);
        test.stopTest();
       
        
}
    
       static testMethod void TestClaim1()
    {
      test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
         CSS_Claims__c testclaimsRec = new CSS_Claims__c();
    CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
         testclaimsRec.Customer_Name__c='TestCustomer';
        	testclaimsRec.Account__c = acc.id;
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
          
      insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
      insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
		CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = testclaimsRec.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode35';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit35';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
            insert AddsolComp;
    	 idlist.add(AddsolComp.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='A'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
		 CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = testclaimsRec.id;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='A'; 
       // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id; 
        po1.ODM_Status__c = '';
        lstpo.add(po1);
       
        insert lstpo;
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.CSS_Claims__c=testclaimsRec.id;
        srt.Job_Order__c=Null;
        srt.ODM_Status__c='';
        insert srt;
        
        CG_CL_UpdateFailureODMStatus.updateODMStatusForFailures(idlist);
        test.stopTest();
       
        
}

   static testMethod void TestClaim2()
    {
      test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
         CSS_Claims__c testclaimsRec = new CSS_Claims__c();
    CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
         testclaimsRec.Customer_Name__c='TestCustomer';
        	testclaimsRec.Account__c = acc.id;
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
          
      insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
      insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
		CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = null;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode35';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit35';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Service_Job__c=jo.id;
            insert AddsolComp;
    	 idlist.add(AddsolComp.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = null;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='A'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
		 CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = null;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='A'; 
       // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id; 
        po1.ODM_Status__c = '';
        lstpo.add(po1);
       
        insert lstpo;
        
        CSS_SRT__c srt=new CSS_SRT__c();
        srt.CSS_Claims__c=testclaimsRec.id;
        srt.Job_Order__c=Null;
        srt.ODM_Status__c='';
        insert srt;
        
        CG_CL_UpdateFailureODMStatus.updateODMStatusForFailures(idlist);
        test.stopTest();
       
        
}
    static testMethod void TestClaim3()
    {
      test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Account__c = acc.id;
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
         CSS_Claims__c testclaimsRec = new CSS_Claims__c();
    CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
         testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
          
      insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
      insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
		CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = null;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = '';
        AddsolComp.AccountCodeEdit__c = '';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        AddsolComp.Service_Job__c=jo.id;
            insert AddsolComp;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        AddsolComp1.CSS_Claims__c = testclaimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = '';
        AddsolComp1.AccountCodeEdit__c = '';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        AddsolComp1.Service_Job__c=null;
            insert AddsolComp1;
    	 idlist.add(AddsolComp1.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c =''; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
		 CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = null;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c =''; 
       // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id; 
        po1.ODM_Status__c = '';
        lstpo.add(po1);
       
        CSS_Parts_Options__c po2 =new CSS_Parts_Options__c();
        po2.Notes__c='123';
        po2.RecordTypeId = recTypeIdpart;
        po2.CSS_Claims__c = testclaimsRec.id;
        po.Service_Job__c=jo.Id;
        po2.OEM__c ='123';
        po2.Quantity__c =1;
        po2.Selected_part__c =true;
        po2.Part_Name__c ='123456';
        po2.Service_partnumber__c ='123';
        po2.Parts_Type__c ='Custom';
        po2.Account_Code__c =''; 
       // po1.Solutions__c=solRef.id;
        po2.FailurepartId__c =AddsolComp.Id; 
        po2.ODM_Status__c = '';
        lstpo.add(po2);
       
        insert lstpo;
        
        CSS_SRT__c srt=new CSS_SRT__c();
        //srt.CSS_Claims__c=testclaimsRec.id;
        srt.Job_Order__c=JO.id;
        srt.ODM_Status__c='';
        insert srt;
        
        CG_CL_UpdateFailureODMStatus.updateODMStatusForFailures(idlist);
        test.stopTest();
       
        
}
static testMethod void TestClaim5()
    {
      test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
         CSS_Claims__c testclaimsRec = new CSS_Claims__c();
    CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
         testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Account__c = acc.id;
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
            testclaimsRec.CSS_Job__c=jo.Id;
      insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
      insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
		CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = testclaimsRec.id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.pay_code__c ='A';
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode35';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit35';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
            insert AddsolComp;
    	 idlist.add(AddsolComp.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='A'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
		 CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = testclaimsRec.id;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='A'; 
       // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id; 
        po1.ODM_Status__c = '';
        lstpo.add(po1);
       
        insert lstpo;
         CSS_SRT__c srt=new CSS_SRT__c();
        srt.CSS_Claims__c=testclaimsRec.id;
        srt.Job_Order__c=Null;
        srt.ODM_Status__c='';
        srt.Account_Code__c='61';
        
        insert srt;

        
        
        CG_CL_UpdateFailureODMStatus.updateODMStatusForFailures(idlist);
        test.stopTest();
       
        
}
static testMethod void TestClaim6()
    {
      test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Account__c = acc.id;
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
         CSS_Claims__c testclaimsRec = new CSS_Claims__c();
    CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
         testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
            testclaimsRec.CSS_Job__c=jo.Id;
      insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
      insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
		CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = NULL;
        AddsolComp.Service_Job__c=jo.Id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.pay_code__c ='A';
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode35';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit35';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
            insert AddsolComp;
    	 idlist.add(AddsolComp.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='A'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
		 CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = testclaimsRec.id;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='A'; 
       // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id; 
        po1.ODM_Status__c = '';
        lstpo.add(po1);
       
        insert lstpo;
         CSS_SRT__c srt=new CSS_SRT__c();
        srt.CSS_Claims__c=NULL;
        srt.Job_Order__c=jo.Id;
        srt.ODM_Status__c='';
        srt.Account_Code__c='61';
        
        insert srt;

        
        
        CG_CL_UpdateFailureODMStatus.updateODMStatusForFailures(idlist);
        test.stopTest();
       
        
}
static testMethod void TestClaim8()
    {
      test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
         CSS_Claims__c testclaimsRec = new CSS_Claims__c();
    CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
         testclaimsRec.Customer_Name__c='TestCustomer';
        	testclaimsRec.Account__c = acc.id;
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
            testclaimsRec.CSS_Job__c=jo.Id;
      insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
      insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
		CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = testclaimsRec.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode35';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit35';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
            insert AddsolComp;
    	 idlist.add(AddsolComp.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        //po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='A'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
		 CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = testclaimsRec.id;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        //po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='A'; 
       // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id; 
        po1.ODM_Status__c = '';
        lstpo.add(po1);
       
        insert lstpo;
         CSS_SRT__c srt=new CSS_SRT__c();
        srt.CSS_Claims__c=testclaimsRec.id;
        srt.Job_Order__c=Null;
        srt.ODM_Status__c='';
        srt.Account_Code__c='61';
        
        insert srt;
        
        CG_CL_UpdateFailureODMStatus.updateODMStatusForFailures(idlist);
        test.stopTest();
       
        
}
static testMethod void TestClaim9()
    {
      test.startTest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;

        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='Gopal';
        insert jo;
        list<id> idlist = new list<id>();
         CSS_Claims__c testclaimsRec = new CSS_Claims__c();
    CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
         testclaimsRec.Customer_Name__c='TestCustomer';
        	testclaimsRec.Account__c = acc.id;
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Address__c = 'T';
            testclaimsRec.Customer_Contact_Phone__c = null;
            testclaimsRec.Email_Address__c = 'rp@sct.com';
            testclaimsRec.Status__c = 'Draft';
            testclaimsRec.TSR1__c = '1234';
            testclaimsRec.TSR2__c = '1234';
            testclaimsRec.TSR3__c = '1234';
            testclaimsRec.TSR4__c = '1234';
            testclaimsRec.TSR5__c = '1234';
            testclaimsRec.TSR6__c = '1234';
            testclaimsRec.TSR7__c = '1234';
            testclaimsRec.TSR8__c = '1234';
            testclaimsRec.TSR9__c = '1234';
            testclaimsRec.TSR10__c = '1234';
            testclaimsRec.Country__c = '1234';
            testclaimsRec.State__c = '1234';
            testclaimsRec.ZipCode__c = '12345-1234';
            testclaimsRec.CSS_Job__c=jo.Id;
      insert testclaimsRec;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.failure_Date__c = date.today() - 20;
        testpsnNewRec.css_claims__C = testclaimsRec.id;
      insert testpsnNewRec;
        CSS_Solutions__c solRef = new CSS_Solutions__c();
        solRef.Diagnostic_Response__c='Most likely the solution';
        solRef.Solution_title__c='TestData';
        solref.Service_Job__c=jo.Id;
        insert solRef;
        
		CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = testclaimsRec.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = solRef.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode35';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit35';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
            insert AddsolComp;
    	 idlist.add(AddsolComp.id);
        list<CSS_Parts_Options__c> lstpo =new list<CSS_Parts_Options__c>();
         Id recTypeIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        CSS_Parts_Options__c po =new CSS_Parts_Options__c();
        po.Notes__c='123';
        po.RecordTypeId = recTypeIdpart;
        po.CSS_Claims__c = testclaimsRec.id;
        po.OEM__c ='123';
        po.Quantity__c =1;
        po.Selected_part__c =true;
        po.Part_Name__c ='123';
        //po.Service_partnumber__c ='123';
        po.Parts_Type__c ='Custom';
        po.Account_Code__c ='61'; 
        //po.Solutions__c=solRef.id;
        po.FailurepartId__c =AddsolComp.Id; 
        po.ODM_Status__c = '';
        po.Service_Job__c=jo.Id;
        lstpo.add(po);
		 CSS_Parts_Options__c po1 =new CSS_Parts_Options__c();
        po1.Notes__c='123';
        po1.RecordTypeId = recTypeIdpart;
        po1.CSS_Claims__c = testclaimsRec.id;
        po1.OEM__c ='123';
        po1.Quantity__c =1;
        po1.Selected_part__c =true;
        po1.Part_Name__c ='123456';
        //po1.Service_partnumber__c ='123';
        po1.Parts_Type__c ='Custom';
        po1.Account_Code__c ='61'; 
       // po1.Solutions__c=solRef.id;
        po1.FailurepartId__c =AddsolComp.Id; 
        po1.ODM_Status__c = '';
        lstpo.add(po1);
       
        insert lstpo;
         CSS_SRT__c srt=new CSS_SRT__c();
        srt.CSS_Claims__c=testclaimsRec.id;
        srt.Job_Order__c=Null;
        srt.ODM_Status__c='';
        srt.Account_Code__c='61';
        
        insert srt;
        
        CG_CL_UpdateFailureODMStatus.updateODMStatusForFailures(idlist);
        test.stopTest();
       
        
}
    
}