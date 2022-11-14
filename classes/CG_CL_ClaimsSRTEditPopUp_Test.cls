@isTest
public class CG_CL_ClaimsSRTEditPopUp_Test 
{
    //Main Testmethod 
    public static TestMethod void M1() 
    {
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc; 
            
       List <CSS_Job_Order__c> lstjo3 = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo3 = new CSS_Job_Order__c();
        jo3.createdDate=dateTime.now();
        jo3.Account__c = acc.id;
        jo3.ESN__c = '79464646';
        jo3.Customer_Name__c='test';
        jo3.Shop_Work_Order__c='uiafh';
        jo3.Mileage__c=123;
        jo3.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo3.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo3.Status__c = 'closed';
        jo3.Service_Model__c = 'model';
        insert jo3;
        lstjo3.add(jo3);
        
        CSS_Claims__c cl3 = new CSS_Claims__c();
        cl3.CSS_Job__c=jo3.id;
        cl3.Account__c = acc.id;
        cl3.AccessCode__c = '123';
        cl3.Service_Model__c = '123';
        insert cl3;
        
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
         CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = jo3.id;
        AddsolComp.CSS_Claims__c = cl3.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='Repair';
        AddsolComp.System_Code__c = 'FH';
        AddsolComp.Component_Code__c =  'AS';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        //AddsolComp;
       solsComp.add(AddsolComp);
        insert solsComp;
        
        List<CSS_SRT__c> srt1=new List<CSS_SRT__c>();
        CSS_SRT__c SRT = new CSS_SRT__c();
        srt.Job_Order__c = lstjo3[0].id;
        srt.CSS_Claims__c = cl3.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Additional Diag';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901';
        srt.isPerformed__c = true;
        srt.ODM_Status__c = '';
        srt.Access_Code__c = 'A';
        srt.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        srt.FailCode__c ='FHAS';
        srt.name = 'TestClassName';
        srt.SRT_Category__c ='AdditionalDiag';
        
        CSS_SRT__c SRTobj = new CSS_SRT__c();
        SRTobj.Job_Order__c = lstjo3[0].id;
        SRTobj.CSS_Claims__c = cl3.id;
        SRTobj.SRT_AccessiblityCheck__c=True;
        SRTobj.Access_Code_A__c = 65;
        SRTobj.type__c = 'Additional Diag';
        SRTobj.Assignment__c = 'PRIMARY';
        SRTobj.srt_time__c = 1;
        SRTobj.SRT_ID__c = '00-901';
        SRTobj.isPerformed__c = true;
        SRTobj.ODM_Status__c = '';
        SRTobj.Access_Code__c = 'A';
        SRTobj.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        SRTobj.FailCode__c ='FHAS';
        
        SRTobj.SRT_Category__c ='AdditionalDiag';
        srt1.add(srt);
        srt1.add(SRTobj);
        insert srt1;
        
        List<SelectOption> options =  new List<SelectOption>();
        options.add(new SelectOption('Select One','Select One'));
        
      //List<CG_CL_ClaimsSRTEditPopUp.srtWrapperClass> lstSelectedSRTWrapper = new  List<CG_CL_ClaimsSRTEditPopUp.srtWrapperClass>();
      //CG_CL_ClaimsSRTEditPopUp.srtWrapperClass ss=new CG_CL_ClaimsSRTEditPopUp.srtWrapperClass(10,srt1[0].id, cl3.id,'00-901','test',1,null,options,options,'FHAS','CAP-Customized Assurance Plan DC','AdditionalDiag','test', 0.0 ,0.0, 0.0 ,0.0, 0.0, 0.0, 'B','AccessCode','solNumber', true, true,'srtWarrantable');
      //lstSelectedSRTWrapper.add(ss);
     
      PageReference pageRef = Page.CG_ClaimsSRTEditPopUp; 
      pageRef.getParameters().put('ClaimsId', String.valueOf(cl3.Id));
      pageRef.getParameters().put('type', 'AdditionalDiag');
      Test.setCurrentPage(pageRef);
        
        CG_CL_ClaimsSRTEditPopUp obj1=new CG_CL_ClaimsSRTEditPopUp();
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        obj1.saveSelectedSRTs();
        obj1.selectedAdmin = true;
        obj1.selectedPickVal = 'test';
        String selGroupCode = 'equal';
        String SRTGroupCode = 'equal';
        obj1.searchDiagValue = '9023';
        obj1.accordionType = 'AdditionalRep';
        obj1.seleFailCode = 'Test';
        obj1.selectedFailCode = 'THAC';
        obj1.selectedSRTId=10;
        
        obj1.loadSavedSRTs();
        obj1.selectedAccess=true;
        //obj1.lstSelectedSRTWrapper = lstSelectedSRTWrapper;
    	obj1.searchDiagSRTCodeAndDescription();  
        obj1.addSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.removingRow();
        obj1.onChangeofFailCode();
        obj1.checkDuplicateSRTs();
        options=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
   //     flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        acoptlist=obj1.getAccountCodeOptionList('test-0987'); 
        
        CG_CL_ClaimsSRTEditPopUp obj2=new CG_CL_ClaimsSRTEditPopUp();
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        obj2.saveSelectedSRTs();
        obj2.selectedAdmin = true;
        obj2.selectedPickVal = 'test';
        String selGroupCode1 = 'equal';
        String SRTGroupCode1 = 'equal';
        obj2.searchDiagValue = '9023';
        obj2.accordionType = 'Campaign';
        obj2.seleFailCode = 'Test';
        obj2.selectedFailCode = 'THAC';
        obj2.selectedSRTId=10;
        
        obj2.loadSavedSRTs();
        obj2.selectedAccess=true;
        //obj1.lstSelectedSRTWrapper = lstSelectedSRTWrapper;
    	obj2.searchDiagSRTCodeAndDescription();  
        obj2.addSelectedSRTs();
        obj2.saveAndCloseSelectedSRTs();
        obj2.removingRow();
        obj2.onChangeofFailCode();
        obj2.checkDuplicateSRTs();
        options=obj2.getGroupList();
        List<SelectOption> flcdrdn1=new List<SelectOption>();
    //    flcdrdn1=obj2.getfailcodeDropDown();
        List<SelectOption> acoptlist1=new List<SelectOption>();
        acoptlist1=obj2.getAccountCodeOptionList('test-0987');
        
        CG_CL_ClaimsSRTEditPopUp obj3=new CG_CL_ClaimsSRTEditPopUp();
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        obj3.saveSelectedSRTs();
        obj3.selectedAdmin = true;
        obj3.selectedPickVal = 'test';
        String selGroupCode12 = 'equal';
        String SRTGroupCode12 = 'equal';
        obj3.searchDiagValue = '9023';
        obj3.accordionType = 'AdditionalDiag';
        obj3.seleFailCode = 'Test';
        obj3.selectedFailCode = 'THAC';
        obj3.selectedSRTId=10;
        
        obj3.loadSavedSRTs();
        obj3.selectedAccess=true;
        //obj1.lstSelectedSRTWrapper = lstSelectedSRTWrapper;
    	obj3.searchDiagSRTCodeAndDescription();  
        obj3.addSelectedSRTs();
        obj3.saveAndCloseSelectedSRTs();
        obj3.removingRow();
        obj3.onChangeofFailCode();
        obj3.checkDuplicateSRTs();
        options=obj3.getGroupList();
        List<SelectOption> flcdrdn12=new List<SelectOption>();
    //    flcdrdn12=obj3.getfailcodeDropDown();
        List<SelectOption> acoptlist12=new List<SelectOption>();
        acoptlist12=obj3.getAccountCodeOptionList('test-0987');
              
            
    }
    
    public static TestMethod void M2() 
    {
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
    //Test.starttest();
        
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc; 
        
        CSS_Job_Order__c JobId1= new CSS_Job_Order__c();
        JobId1.Account__c=acc.id;
        CSS_Job_Order__c JobId2=CSS_TestData.createJobOrder(false);
        JobId2.Account__c=acc.id;
        list<CSS_Job_Order__c> jolist=new list<CSS_Job_Order__c>();
        jolist.add(JobId1);
        jolist.add(JobId2);
        insert jolist;
        system.debug('JOBS: '+jolist);
         
        
        CSS_Claims__c cl = new CSS_Claims__c();
        cl.CSS_Job__c=JobId1.id;
        cl.Account__c=acc.id;
        insert cl;
        
  //css_srtEditPopupController obj1=new css_srtEditPopupController();

         
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=JobId1.id;
        insert sols;
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jolist[1].id,sols.id);
        
       List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
         CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp.CSS_Claims__c = cl.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='Campaign';
        AddsolComp.System_Code__c = 'FH';
        AddsolComp.Component_Code__c =  'AS';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        //AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        //AddsolComp.Fail_Code__c = 'test';
        //insert AddsolComp;
       solsComp.add(AddsolComp);
        insert solsComp;
                 //Create SRT record
        CSS_SRT__c srtobj1=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj1.SRT_ID__c = '00-901-00';
        
        srtobj1.Assignment__c = 'test';
        srtobj1.Component_Id__c = AddsolComp.id;
        srtobj1.FailCode__c='Select One';
        srtobj1.SRT_Title__c = 'test';
        srtobj1.SRT_Quantity__c=1;
        srtobj1.SRT_Time__c = 2;
        srtobj1.Access_Code__c = 'ters';
        srtobj1.SRT_Warrantable__c = '2.3';
        srtobj1.Adjustment_Reason__c = 'test';
         srtobj1.CSS_Claims__c = cl.id;
        srtobj1.SRT_Select__c = true;
        srtobj1.isPerformed__c = true;
        srtobj1.srt_category__c = 'test';
        srtobj1.type__c = 'Field Action';
        srtobj1.SRT_Type__c = 'Campaign';
        srtobj1.Extended_Hours__c = 1.2;
        srtobj1.SRT_Estimate__c = true;
        upsert srtobj1;
        
        CSS_SRT__c srtobj11=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj11.SRT_ID__c = '00-10S-00';
        
        srtobj11.Assignment__c = 'test';
        srtobj11.Component_Id__c = AddsolComp.id;
        srtobj11.FailCode__c='Select One';
        srtobj11.SRT_Title__c = 'test';
        srtobj11.SRT_Quantity__c=1;
        srtobj11.SRT_Time__c = 2;
        srtobj11.Access_Code__c = 'ters';
        srtobj11.SRT_Warrantable__c = '2.3';
        srtobj11.Admi_Check__c=true;
        srtobj11.Adjustment_Reason__c = 'test';
         srtobj11.CSS_Claims__c = cl.id;
        srtobj11.SRT_Select__c = true;
        srtobj11.isPerformed__c = true;
        srtobj11.srt_category__c = 'test';
        srtobj11.type__c = 'Field Action';
        srtobj11.SRT_Type__c = 'Campaign';
        srtobj11.Extended_Hours__c = 1.2;
        srtobj11.SRT_Estimate__c = true;
        upsert srtobj11;
        
        CSS_SRT__c srtobj2=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj2.SRT_Category__c='Campaign';
        srtobj2.SRT_Type__c='Repair';
        srtobj2.Job_Order__c = JobId1.id;
        srtobj2.Component_Id__c = AddsolComp.id;
        srtobj2.SRT_Quantity__c=2;
        srtobj2.FailCode__c='EUCN';
        srtobj2.Account_Code__c='TEST';
        srtobj2.SRT_Select__c = true;
        srtobj2.SRT_ID__c = '00-901-00';
        upsert srtobj2;

        list<CSS_SRT__c> srtlist=new list<CSS_SRT__c>();
        srtlist.add(srtobj1);
        srtlist.add(srtobj2);
       // insert srtlist;
        PageReference pageRef = Page.css_srtEditPopup; 
  pageRef.getParameters().put('JOBId', String.valueOf(JobId1.id));
  Test.setCurrentPage(pageRef);
        Test.starttest();
        PageReference pref;
        pref = new PageReference('/'+JobId1.id);
        pref.getParameters().put('JobOrderId',JobId1.id);
        pref.getParameters().put('type','Campaign');
        Test.setCurrentPage(pref);
        
       CG_CL_ClaimsSRTEditPopUp obj1=new CG_CL_ClaimsSRTEditPopUp();
        List<SelectOption> sepoplist=new list<SelectOption>();
       //CG_CL_ClaimsSRTEditPopUp.srtWrapperClass obj2=new CG_CL_ClaimsSRTEditPopUp.srtWrapperClass(0,srtlist[0].id,cl.id,'Test','1',1,null,sepoplist,sepoplist,'Test','Test','Test','AdditionalDiag',0.0,0.0,0.0,0.0,0.0,0.0,'B',null,false);
		obj1.selectedAdmin = true;
        //obj1.selectedPickVal = '00 - Cylinder Block';
        obj1.selectedPickVal = 'All';
        obj1.isDealer = true;
        obj1.accordionType = 'AdditionalRep';
        obj1.selectedFailCode = 'THAC';
        obj1.loadSavedSRTs();
        obj1.coverageType='2014-05-08T00:00:00.000-05:00';
        obj1.selectedAccess=true;
    	obj1.searchDiagSRTCodeAndDescription();  
 		obj1.ValidateAdminSRT();
        obj1.lstFilteredSRT = srtlist;
        srtobj2.SRT_ID__c='00-401';
        obj1.ValidateAdminSRT();
        obj1.addSelectedSRTs();
        
        obj1.lstFilteredSRT=srtlist;
        obj1.ValidateAdminSRT();
        obj1.saveSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.removingRow();
        obj1.onChangeofFailCode();
        sepoplist=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
   //     flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        acoptlist=obj1.getAccountCodeOptionList('test-12834827');
      //  acoptlist=obj1.getAccountCodeDropDown1();
      // obj1.checkDuplicateSRTs();
      List<CSS_Solution_Component__c> solsComp1 = new List<CSS_Solution_Component__c>();
        
        for(integer i=0;i<10;i++){
              CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp1.CSS_Claims__c = cl.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.type__c='Campaign';
        AddsolComp1.System_Code__c = 'FH';
        AddsolComp1.Component_Code__c =  'AS';
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        //AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.AccountCodeType__c='ASAS';
        AddsolComp1.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
            solsComp1.add(AddsolComp1);
        }
       
        upsert solsComp1;
        obj1.addSelectedSRTs();
        Test.stopTest();
            
    }
    
    public static TestMethod void M3() 
    {
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        
    //Test.starttest();
       Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc; 
        
        CSS_Job_Order__c JobId1=CSS_TestData.createJobOrder(false);
        JobId1.Account__c=acc.id;
        CSS_Job_Order__c JobId2=CSS_TestData.createJobOrder(false);
        JobId2.Account__c=acc.id;
        list<CSS_Job_Order__c> jolist=new list<CSS_Job_Order__c>();
        jolist.add(JobId1);
        jolist.add(JobId2);
        insert jolist;
        system.debug('JOBS: '+jolist);
                
        CSS_Claims__c cl = new CSS_Claims__c();
        cl.CSS_Job__c=JobId2.id;
        cl.Account__c=acc.id;
        insert cl;
        
  //css_srtEditPopupController obj1=new css_srtEditPopupController();

         
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=JobId1.id;
        insert sols;
         
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jolist[1].id,sols.id);
        
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
         CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp.CSS_Claims__c = cl.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='Campaign';
        AddsolComp.System_Code__c = 'FH';
        AddsolComp.Component_Code__c =  'AS';
        //AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        //insert AddsolComp;
       solsComp.add(AddsolComp);
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp1.CSS_Claims__c = cl.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.type__c='Campaign';
        AddsolComp1.System_Code__c = 'FH';
        AddsolComp1.Component_Code__c =  'AS';
        //AddsolComp.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp1.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.AccountCodeType__c='ASAS';
        AddsolComp1.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        //insert AddsolComp;
       solsComp.add(AddsolComp1);
        //insert solsComp;
        
        insert solsComp;
        //Create SRT record
        CSS_SRT__c srtobj1=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj1.SRT_ID__c = '90234';
        srtobj1.Assignment__c = 'test';
        srtobj1.Component_Id__c = AddsolComp.id;
        srtobj1.FailCode__c='Select One';
        srtobj1.SRT_Title__c = '90234';
        srtobj1.SRT_Quantity__c=1;
        srtobj1.SRT_Time__c = 2;
        srtobj1.Access_Code__c = 'ters';
        srtobj1.SRT_Warrantable__c = '2.3';
        srtobj1.Adjustment_Reason__c = 'test';
        srtobj1.Job_Order__c = JobId1.id;
        srtobj1.SRT_Select__c = true;
        srtobj1.isPerformed__c = true;
        srtobj1.srt_category__c = 'test';
        srtobj1.type__c = 'test';
        srtobj1.Extended_Hours__c = 1.2;
        srtobj1.SRT_Estimate__c = true;

        
        CSS_SRT__c srtobj2=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj2.SRT_Category__c='AdditionalRep';
        srtobj2.SRT_Type__c='Repair';
         srtobj2.CSS_Claims__c = cl.id;
        srtobj2.Component_Id__c = AddsolComp.id;
        srtobj2.SRT_Quantity__c=2;
        srtobj2.FailCode__c='EUCN';
        srtobj2.Account_Code__c='TEST';
        

        list<CSS_SRT__c> srtlist=new list<CSS_SRT__c>();
        srtlist.add(srtobj1);
        srtlist.add(srtobj2);
        insert srtlist;
        
        
       
        /*PageReference pageRef = Page.css_srtEditPopup; 
  pageRef.getParameters().put('JOBId', String.valueOf(JobId1.id));
  Test.setCurrentPage(pageRef);*/
        Test.starttest();
        PageReference pref;
        pref = new PageReference('/'+JobId1.id);
        pref.getParameters().put('JobOrderId',JobId1.id);
        Test.setCurrentPage(pref);
        
        CG_CL_ClaimsSRTEditPopUp obj1=new CG_CL_ClaimsSRTEditPopUp();
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        List<SelectOption> sepoplist=new list<SelectOption>();
        //CG_CL_ClaimsSRTEditPopUp.srtWrapperClass obj2=new CG_CL_ClaimsSRTEditPopUp.srtWrapperClass(0,srtlist[0].id,cl.id,'Test','1',1,null,sepoplist,sepoplist,'Test','Test','Test','AdditionalDiag',0.0,0.0,0.0,0.0,0.0,0.0,'B',null,false);
        obj1.selectedAdmin = true;
        //obj1.selectedPickVal = '00 - Cylinder Block';
        obj1.selectedPickVal = 'All';
        obj1.searchDiagValue = '90234';
        obj1.accordionType = 'AdditionalRep';
        //obj1.selectedFailCode = 'THAC';
        obj1.selectedFailCode = 'Select One';
        //obj1.selectedAccountCode = 'Select One';
        obj1.loadSavedSRTs();
        //obj1.coverageType='2014-05-08T00:00:00.000-05:00';
        obj1.selectedAccess=true;
        obj1.lstDisplaySRT = srtlist;
        obj1.searchDiagSRTCodeAndDescription();  
        
        //obj1.lstPrivateSRT=srtlist;
        
        
        obj1.addSelectedSRTs();
        obj1.selectedSRTId=1;
        obj1.lstFilteredSRT=srtlist;
        obj1.saveSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.removingRow(); 
        obj1.onChangeofFailCode();
        sepoplist=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
    //    flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        acoptlist=obj1.getAccountCodeOptionList('WE-PQ');
        //acoptlist=obj1.getAccountCodeDropDown1();
        Test.stopTest();
            
    }
    static testmethod void CG_CL_ClaimsSRTEditPopUp_Test4()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc; 
        
        List <CSS_Job_Order__c> lstjo3 = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo3 = new CSS_Job_Order__c();
        jo3.createdDate=dateTime.now();
        jo3.Account__c = acc.id;
        jo3.ESN__c = '79464646';
        jo3.Customer_Name__c='test';
        jo3.Shop_Work_Order__c='uiafh';
        jo3.Mileage__c=123;
        jo3.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo3.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo3.Status__c = 'closed';
        jo3.Service_Model__c = 'model';
        insert jo3;
        lstjo3.add(jo3);
        
        CSS_Claims__c cl3 = new CSS_Claims__c();
        cl3.CSS_Job__c=jo3.id;
        cl3.Account__c = acc.id;
        cl3.AccessCode__c = '1';
        cl3.Service_Model__c = '123';
        insert cl3;
        
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
         CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp.CSS_Claims__c = cl3.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='Repair';
        AddsolComp.System_Code__c = 'FH';
        AddsolComp.Component_Code__c =  'AS';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        //insert AddsolComp;
       solsComp.add(AddsolComp);
        insert solsComp;
        
        List<CSS_SRT__c> srt1=new List<CSS_SRT__c>();
        CSS_SRT__c SRT = new CSS_SRT__c();
        srt.Job_Order__c = lstjo3[0].id;
        srt.CSS_Claims__c = cl3.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
     //   srt.type__c = 'Additional Diag';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901';
        srt.isPerformed__c = true;
        srt.ODM_Status__c = '';
        srt.Access_Code__c = 'A';
        srt.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        srt.FailCode__c ='FHAS';
        srt.name = 'TestClassName';
        srt.SRT_Category__c ='AdditionalDiag';
        srt.type__c = 'Field Action';
        
        CSS_SRT__c SRTobj = new CSS_SRT__c();
        SRTobj.Job_Order__c = lstjo3[0].id;
        SRTobj.CSS_Claims__c = cl3.id;
        SRTobj.SRT_AccessiblityCheck__c=True;
        SRTobj.Access_Code_A__c = 65;
     //   SRTobj.type__c = 'Additional Diag';
        SRTobj.Assignment__c = 'PRIMARY';
        SRTobj.srt_time__c = 1;
        SRTobj.SRT_ID__c = '00-901';
        SRTobj.isPerformed__c = true;
        SRTobj.ODM_Status__c = '';
        SRTobj.Access_Code__c = 'A';
        SRTobj.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        SRTobj.FailCode__c ='FHAS';
        SRTobj.SRT_Category__c ='AdditionalRep';
        SRTobj.type__c = 'Field Action';
        srt1.add(srt);
        srt1.add(SRTobj);
        insert srt1;
        
        List<SelectOption> options =  new List<SelectOption>();
        options.add(new SelectOption('Select One','Select One'));
       
       //CG_CL_ClaimsSRTEditPopUp.srtWrapperClass ss=new CG_CL_ClaimsSRTEditPopUp.srtWrapperClass(0,srt1[0].id,cl3.id,'Test','1',1,null,options,options,'Test','FHAS','CAP-Customized Assurance Plan DC','AdditionalDiag',0.0,0.0,0.0,0.0,0.0,0.0,'B',null,false);
        PageReference pageRef = Page.CG_ClaimsSRTEditPopUp; 
      pageRef.getParameters().put('ClaimsId', String.valueOf(cl3.Id));
      pageRef.getParameters().put('type', 'AdditionalRep');
      
      Test.setCurrentPage(pageRef);

         
        CG_CL_ClaimsSRTEditPopUp p3 = new CG_CL_ClaimsSRTEditPopUp();
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        p3.saveSelectedSRTs();
        p3.checkDuplicateSRTs();
       
        //p3.ValidateAdminSRT();
    }
    static testmethod void CG_CL_ClaimsSRTEditPopUp_Test5()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc; 
        
        List <CSS_Job_Order__c> lstjo3 = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo3 = new CSS_Job_Order__c();
        jo3.createdDate=dateTime.now();
        jo3.ESN__c = '79464646';
        jo3.Account__c = acc.id;
        jo3.Customer_Name__c='test';
        jo3.Shop_Work_Order__c='uiafh';
        jo3.Mileage__c=123;
        jo3.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo3.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo3.Status__c = 'closed';
        jo3.Service_Model__c = 'model';
        insert jo3;
        lstjo3.add(jo3);
        
        CSS_Claims__c cl3 = new CSS_Claims__c();
        cl3.CSS_Job__c=jo3.id;
        cl3.Account__c = acc.id;
        insert cl3;
        
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
         CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp.CSS_Claims__c = cl3.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='Campaign';
        AddsolComp.System_Code__c = 'FH';
        AddsolComp.Component_Code__c =  'AS';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        //AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        //AddsolComp.Fail_Code__c = 'test';
        //insert AddsolComp;
       solsComp.add(AddsolComp);
        insert solsComp;
        
        List<CSS_SRT__c> srt1=new List<CSS_SRT__c>();
        CSS_SRT__c SRT = new CSS_SRT__c();
        srt.Job_Order__c = lstjo3[0].id;
        srt.CSS_Claims__c = cl3.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Field Action';
        srt.Assignment__c = 'NOT CLAIMABLE';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.isPerformed__c = true;
        srt.ODM_Status__c = '';
        srt.Access_Code__c = 'A';
        srt.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        srt.FailCode__c ='FHAS';
        
        //srt.SRT_Category__c ='AdditionalDiag';
        srt1.add(srt);
        insert srt1;
        
        List<SelectOption> options =  new List<SelectOption>();
        options.add(new SelectOption('Select One','Select One'));
       
       //CG_CL_ClaimsSRTEditPopUp.srtWrapperClass ss=new CG_CL_ClaimsSRTEditPopUp.srtWrapperClass(0,srt1[0].id,cl3.id,'Test','1',1,null,options,options,'Test','FHAS','CAP-Customized Assurance Plan DC','Campaign',0.0,0.0,0.0,0.0,0.0,0.0,'B',null,false);
        
        PageReference pageRef = Page.CG_ClaimsSRTEditPopUp; 
      pageRef.getParameters().put('ClaimsId', String.valueOf(cl3.Id));
      pageRef.getParameters().put('type', 'Campaign');
      pageRef.getParameters().put('type', 'AdditionalDiag');
      Test.setCurrentPage(pageRef);
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        CG_CL_ClaimsSRTEditPopUp p3 = new CG_CL_ClaimsSRTEditPopUp();
        p3.isAutomatedClaim = true;
        p3.loadSavedSRTs();
        p3.saveSelectedSRTs();
        p3.addSelectedSRTs();
        
        p3.accordionType='TRP';
        
       test.stopTest();
    }
    static testmethod void CG_CL_ClaimsSRTEditPopUp_Test6()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc; 
        
        List <CSS_Job_Order__c> lstjo3 = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo3 = new CSS_Job_Order__c();
        jo3.createdDate=dateTime.now();
        jo3.ESN__c = '79464646';
        jo3.Account__c = acc.id;
        jo3.Customer_Name__c='test';
        jo3.Shop_Work_Order__c='uiafh';
        jo3.Mileage__c=123;
        jo3.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo3.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo3.Status__c = 'closed';
        jo3.Service_Model__c = 'model';
        insert jo3;
        lstjo3.add(jo3);
        
        CSS_Claims__c cl3 = new CSS_Claims__c();
        cl3.CSS_Job__c=jo3.id;
        cl3.Account__c = acc.id;
        insert cl3;
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=lstjo3[0].id;
        sols.Diagnostic_Response__c='Most likely the solution';
        insert sols;
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
         CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp.CSS_Claims__c = cl3.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp.Quantity__c = 4;
        AddsolComp.Solutions__c=sols.id;
        AddsolComp.type__c='test';
        AddsolComp.System_Code__c = 'FH';
        AddsolComp.Component_Code__c =  'AS';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        //AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        AddsolComp1.CSS_Claims__c = cl3.id;
        AddsolComp1.Action__c = 'Repair';
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.Solutions__c=sols.id;
        AddsolComp1.type__c='test';
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.AccountCodeType__c='ASAS';
        AddsolComp1.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        //AddsolComp.Fail_Code__c = 'test';
        //insert AddsolComp;
       solsComp.add(AddsolComp);
       solsComp.add(AddsolComp1);
        insert solsComp;
        
        List<CSS_SRT__c> srt1=new List<CSS_SRT__c>();
        CSS_SRT__c SRT = new CSS_SRT__c();
        srt.Job_Order__c = lstjo3[0].id;
        srt.Component_Id__c =AddsolComp.id;
        srt.CSS_Claims__c = null;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Field Action';
        srt.Assignment__c = 'NOT CLAIMABLE';
        srt.Solution_Number__c=sols.id;
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.isPerformed__c = true;
        srt.ODM_Status__c = '';
        srt.Access_Code__c = 'A';
        srt.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        srt.FailCode__c ='FHAS';
        CSS_SRT__c SRT12 = new CSS_SRT__c();
        srt12.Job_Order__c = lstjo3[0].id;
        srt12.CSS_Claims__c = null;
        srt12.SRT_AccessiblityCheck__c=True;
        srt12.Access_Code_A__c = 65;
        srt12.name = 'TestClassName';
        srt12.type__c = 'Diagnosis';
        srt12.Assignment__c = 'CLAIMABLE';
        srt12.srt_time__c = 1;
        srt12.Component_Id__c =AddsolComp1.id;
        srt12.Solution_Number__c=sols.id;
        srt12.SRT_ID__c = '00-901-10';
        srt12.isPerformed__c = true;
        srt12.ODM_Status__c = '';
        srt12.Access_Code__c = 'A';
        srt12.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        srt12.FailCode__c ='FHAS';
        srt12.srt_type__c = 'Campaign';
        //srt.SRT_Category__c ='AdditionalDiag';
        srt1.add(srt12);
        srt1.add(srt);
        insert srt1;
        
        List<SelectOption> options =  new List<SelectOption>();
        options.add(new SelectOption('Select One','Select One'));
       
       //CG_CL_ClaimsSRTEditPopUp.srtWrapperClass ss=new CG_CL_ClaimsSRTEditPopUp.srtWrapperClass(0,srt1[0].id,cl3.id,'Test','1',1,null,options,options,'Test','FHAS','CAP-Customized Assurance Plan DC','Campaign',0.0,0.0,0.0,0.0,0.0,0.0,'B',null,false);
        
        PageReference pageRef = Page.CG_ClaimsSRTEditPopUp; 
      pageRef.getParameters().put('ClaimsId', String.valueOf(cl3.Id));
      pageRef.getParameters().put('type', 'Campaign');
      pageRef.getParameters().put('type', 'ATC');
      Test.setCurrentPage(pageRef);
test.startTest();
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        CG_CL_ClaimsSRTEditPopUp p3 = new CG_CL_ClaimsSRTEditPopUp();
        p3.saveSelectedSRTs();
        p3.addSelectedSRTs();
        p3.accordionType='TRP';
        p3.checkDuplicateSRTs();
        test.stopTest();
    }
    static testmethod void CG_CL_ClaimsSRTEditPopUp_Test7()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc; 
        
        List <CSS_Job_Order__c> lstjo3 = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo3 = new CSS_Job_Order__c();
        jo3.createdDate=dateTime.now();
        jo3.ESN__c = '79464646';
        jo3.Account__c = acc.id;
        jo3.Customer_Name__c='test';
        jo3.Shop_Work_Order__c='uiafh';
        jo3.Mileage__c=123;
        jo3.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo3.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo3.Status__c = 'closed';
        jo3.Service_Model__c = 'model';
        insert jo3;
        lstjo3.add(jo3);
        
        CSS_Claims__c cl3 = new CSS_Claims__c();
        cl3.CSS_Job__c=jo3.id;
        cl3.Account__c = acc.id;
        insert cl3;
        
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
         CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp.CSS_Claims__c = cl3.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='Campaign';
        AddsolComp.System_Code__c = 'FHXX';
        AddsolComp.Component_Code__c =  'XX';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        //AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp1.CSS_Claims__c = cl3.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.type__c='Campaign';
        
        
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        //AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.AccountCodeType__c='ASAS';
        AddsolComp1.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        //AddsolComp.Fail_Code__c = 'test';
        //insert AddsolComp;
       solsComp.add(AddsolComp);
        solsComp.add(AddsolComp1);
        insert solsComp;
        
        List<CSS_SRT__c> srt1=new List<CSS_SRT__c>();
        CSS_SRT__c SRT = new CSS_SRT__c();
        srt.Job_Order__c = lstjo3[0].id;
        srt.CSS_Claims__c = cl3.id;
        srt.Component_Id__c =AddsolComp.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Diagnosis';
        srt.Assignment__c = 'NOT CLAIMABLE';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901-10';
        srt.isPerformed__c = true;
        srt.ODM_Status__c = '';
        srt.Access_Code__c = 'A';
        srt.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        srt.FailCode__c ='FHAS1';
        CSS_SRT__c SRT12 = new CSS_SRT__c();
        srt12.Job_Order__c = lstjo3[0].id;
        srt12.CSS_Claims__c = null;
        srt12.SRT_AccessiblityCheck__c=True;
         srt12.Component_Id__c =AddsolComp.id;
        srt12.Access_Code_A__c = 65;
        srt12.name = 'TestClassName';
        srt12.type__c = 'Diagnosis';
        srt12.Assignment__c = 'CLAIMABLE';
        srt12.srt_time__c = 1;
        srt12.SRT_ID__c = '00-901-10';
        srt12.isPerformed__c = true;
        srt12.ODM_Status__c = '';
        srt12.Access_Code__c = 'A';
        srt12.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        srt12.FailCode__c ='FHAS1';
        srt12.srt_type__c = 'Campaign';
        //srt.SRT_Category__c ='AdditionalDiag';
        srt1.add(srt12);
        srt1.add(srt);
        insert srt1;
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=lstjo3[0].id;
        sols.Diagnostic_Response__c='Most likely the solution';
        insert sols;
        List<SelectOption> options =  new List<SelectOption>();
        options.add(new SelectOption('Select One','Select One'));
       test.startTest();
       //CG_CL_ClaimsSRTEditPopUp.srtWrapperClass ss=new CG_CL_ClaimsSRTEditPopUp.srtWrapperClass(0,srt1[0].id,cl3.id,'Test','1',1,null,options,options,'Test','FHAS','CAP-Customized Assurance Plan DC','Campaign',0.0,0.0,0.0,0.0,0.0,0.0,'B',null,false);
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        PageReference pageRef = Page.CG_ClaimsSRTEditPopUp; 
      pageRef.getParameters().put('ClaimsId', String.valueOf(cl3.Id));
      pageRef.getParameters().put('type', 'Campaign');
      pageRef.getParameters().put('type', 'AdditionalRep');
      Test.setCurrentPage(pageRef);

        CG_CL_ClaimsSRTEditPopUp p3 = new CG_CL_ClaimsSRTEditPopUp();
        p3.saveSelectedSRTs();
        p3.addSelectedSRTs();
        //p3.checkDuplicateSRTs();
        p3.isAutomatedClaim = true;
        p3.loadSavedSRTs();
        test.stopTest();
    }
    
    static testmethod void checkDuplicateSRTsTest(){
        
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc; 
        
        CSS_Job_Order__c JobId1=CSS_TestData.createJobOrder(true);
        JobId1.Account__c = acc.id;
        
        css_claims__c claim = new css_claims__c();
        claim.CSS_Job__c = JobId1.id;
        claim.Account__c = acc.id;
        insert claim;
        
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=JobId1.id;
        sols.Diagnostic_Response__c = 'Most likely the solution';
        insert sols;
         
           
       CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F19000990',Type__c = 'Campaign',Solutions__c=sols.Id,Service_Job__c=jobid1.id,System_Code__c ='TH',Component_Code__c='AC',Selected_Component__c=true,AccountCode__c='Test');
       insert solComp1;
        List <CSS_Job_Order__c> lstjo3 = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo3 = new CSS_Job_Order__c();
        jo3.createdDate=dateTime.now();
        jo3.ESN__c = '79464646';
        jo3.Account__c = acc.id;
        jo3.Customer_Name__c='test';
        jo3.Shop_Work_Order__c='uiafh';
        jo3.Mileage__c=123;
        jo3.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo3.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo3.Status__c = 'closed';
        jo3.Service_Model__c = 'model';
        insert jo3;
        lstjo3.add(jo3);
        CSS_Claims__c cl3 = new CSS_Claims__c();
        cl3.CSS_Job__c=jo3.id;
        cl3.Account__c = acc.id;
        insert cl3;
       
        List<CSS_SRT__c> srt1=new List<CSS_SRT__c>();
        CSS_SRT__c SRT = new CSS_SRT__c();
        srt.Job_Order__c = lstjo3[0].id;
        srt.CSS_Claims__c = cl3.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Additional Diag';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901';
        srt.isPerformed__c = true;
        srt.ODM_Status__c = '';
        srt.Access_Code__c = 'A';
        srt.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        srt.FailCode__c ='FHAS';
        srt.name = 'TestClassName';
        srt.SRT_Category__c ='AdditionalDiag';
        
        CSS_SRT__c SRTobj = new CSS_SRT__c();
        SRTobj.Job_Order__c = lstjo3[0].id;
        SRTobj.CSS_Claims__c = cl3.id;
        SRTobj.SRT_AccessiblityCheck__c=True;
        SRTobj.Access_Code_A__c = 65;
        SRTobj.type__c = 'Additional Diag';
        SRTobj.Assignment__c = 'PRIMARY';
        SRTobj.srt_time__c = 1;
        SRTobj.SRT_ID__c = '00-901';
        SRTobj.isPerformed__c = true;
        SRTobj.ODM_Status__c = '';
        SRTobj.Access_Code__c = 'A';
        SRTobj.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        SRTobj.FailCode__c ='FHAS';
        
        SRTobj.SRT_Category__c ='AdditionalDiag';
        srt1.add(srt);
        srt1.add(SRTobj);
        insert srt1;
            
            Set<String> SRTIDs = new Set<String>();
            SRTIDs.add('00-901-00');
        
        List<SelectOption> options =  new List<SelectOption>();
        options.add(new SelectOption('Select One','Select One'));
            test.starttest();
        List<CG_CL_ClaimsSRTEditPopUp.srtWrapperClass> sst=new List<CG_CL_ClaimsSRTEditPopUp.srtWrapperClass>();
       //CG_CL_ClaimsSRTEditPopUp.srtWrapperClass ss=new CG_CL_ClaimsSRTEditPopUp.srtWrapperClass(0,srt1[0].id,cl3.id,'Test','1',1,null,options,options,'Test','FHAS','CAP-Customized Assurance Plan DC','Campaign',0.0,0.0,0.0,0.0,0.0,0.0,'B',null,false);
        //sst.add(ss);  
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
      PageReference pageRef = Page.CG_ClaimsSRTEditPopUp; 
      pageRef.getParameters().put('ClaimsId', String.valueOf(claim.Id));
      pageRef.getParameters().put('type', 'AdditionalRep');
      pageRef.getParameters().put('type', 'TRP');
      Test.setCurrentPage(pageRef); 
        CG_CL_ClaimsSRTEditPopUp cl = new CG_CL_ClaimsSRTEditPopUp();
        cl.lstFilteredSRT = srt1;
        cl.lstSelectedSRTWrapper=sst;
        cl.SRTID = SRTIDs;
        cl.checkDuplicateSRTs();
        cl.isAutomatedClaim = true;
        cl.loadSavedSRTs();
        test.stoptest();
    }
    static testmethod void checkDuplicateSRTsTest1(){
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc; 
        
        CSS_Job_Order__c JobId1=CSS_TestData.createJobOrder(true);
        JobId1.Account__c = acc.id;
        
        css_claims__c claim = new css_claims__c();
        claim.CSS_Job__c = JobId1.id;
        claim.Account__c = acc.id;
        insert claim;
        
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=JobId1.id;
        sols.Diagnostic_Response__c = 'Most likely the solution';
        insert sols;
         
           
       CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c(Name='Test',Component_Id__c='F19000990',Type__c = 'Campaign',Solutions__c=sols.Id,Service_Job__c=jobid1.id,System_Code__c ='TH',Component_Code__c='AC',Selected_Component__c=true,AccountCode__c='Test');
       insert solComp1;
        List <CSS_Job_Order__c> lstjo3 = new List <CSS_Job_Order__c>();
        CSS_Job_Order__c jo3 = new CSS_Job_Order__c();
        jo3.createdDate=dateTime.now();
        jo3.ESN__c = '79464646';
        jo3.Account__c = acc.id;
        jo3.Customer_Name__c='test';
        jo3.Shop_Work_Order__c='uiafh';
        jo3.Mileage__c=123;
        jo3.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo3.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo3.Status__c = 'closed';
        jo3.Service_Model__c = 'model';
        insert jo3;
        lstjo3.add(jo3);
        CSS_Claims__c cl3 = new CSS_Claims__c();
        cl3.CSS_Job__c=jo3.id;
        cl3.Account__c = acc.id;
        insert cl3;
       
        List<CSS_SRT__c> srt1=new List<CSS_SRT__c>();
        CSS_SRT__c SRT = new CSS_SRT__c();
        srt.Job_Order__c = lstjo3[0].id;
        srt.CSS_Claims__c = cl3.id;
        srt.SRT_AccessiblityCheck__c=True;
        srt.Access_Code_A__c = 65;
        srt.name = 'TestClassName';
        srt.type__c = 'Additional Diag';
        srt.Assignment__c = 'PRIMARY';
        srt.srt_time__c = 1;
        srt.SRT_ID__c = '00-901';
        srt.isPerformed__c = true;
        srt.ODM_Status__c = '';
        srt.Access_Code__c = 'A';
        srt.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        srt.FailCode__c ='FHAS';
        srt.name = 'TestClassName';
        srt.SRT_Category__c ='AdditionalDiag';
        
        CSS_SRT__c SRTobj = new CSS_SRT__c();
        SRTobj.Job_Order__c = lstjo3[0].id;
        SRTobj.CSS_Claims__c = cl3.id;
        SRTobj.SRT_AccessiblityCheck__c=True;
        SRTobj.Access_Code_A__c = 65;
        SRTobj.type__c = 'Additional Diag';
        SRTobj.Assignment__c = 'PRIMARY';
        SRTobj.srt_time__c = 1;
        SRTobj.SRT_ID__c = '00-901';
        SRTobj.isPerformed__c = true;
        SRTobj.ODM_Status__c = '';
        SRTobj.Access_Code__c = 'A';
        SRTobj.Account_Code__c = 'CAP-Customized Assurance Plan DC';
        SRTobj.FailCode__c ='FHAS';
        
        SRTobj.SRT_Category__c ='AdditionalDiag';
        srt1.add(srt);
        srt1.add(SRTobj);
        insert srt1;
            
            Set<String> SRTIDs = new Set<String>();
            SRTIDs.add('00-901-00');
        
        List<SelectOption> options =  new List<SelectOption>();
        options.add(new SelectOption('Select One','Select One'));
            test.starttest();
        List<CG_CL_ClaimsSRTEditPopUp.srtWrapperClass> sst=new List<CG_CL_ClaimsSRTEditPopUp.srtWrapperClass>();
       //CG_CL_ClaimsSRTEditPopUp.srtWrapperClass ss=new CG_CL_ClaimsSRTEditPopUp.srtWrapperClass(0,srt1[0].id,cl3.id,'Test','1',1,null,options,options,'Test','FHAS','CAP-Customized Assurance Plan DC','Campaign',0.0,0.0,0.0,0.0,0.0,0.0,'B',null,false);
       //sst.add(ss);  
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
      PageReference pageRef = Page.CG_ClaimsSRTEditPopUp; 
      pageRef.getParameters().put('ClaimsId', String.valueOf(claim.Id));
      pageRef.getParameters().put('type', 'AdditionalRep');
      pageRef.getParameters().put('type', 'TRP');
      Test.setCurrentPage(pageRef); 
        CG_CL_ClaimsSRTEditPopUp cl = new CG_CL_ClaimsSRTEditPopUp();
        cl.lstFilteredSRT = srt1;
        //cl.lstSelectedSRTWrapper=sst;
        cl.SRTID = SRTIDs;
        cl.checkDuplicateSRTs();
        cl.isAutomatedClaim = true;
        cl.loadSavedSRTs();
        test.stoptest();
    }
    public static TestMethod void M21() 
    {
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
    //Test.starttest();
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc; 
        
        CSS_Job_Order__c JobId1= new CSS_Job_Order__c();
        JobId1.Account__c=acc.id;
        CSS_Job_Order__c JobId2=CSS_TestData.createJobOrder(false);
        JobId2.Account__c=acc.id;
        list<CSS_Job_Order__c> jolist=new list<CSS_Job_Order__c>();
        jolist.add(JobId1);
        jolist.add(JobId2);
        insert jolist;
        system.debug('JOBS: '+jolist);
         
        CSS_Claims__c cl = new CSS_Claims__c();
        cl.CSS_Job__c=JobId1.id;
        cl.Account__c=acc.id;
        insert cl;
        
  //css_srtEditPopupController obj1=new css_srtEditPopupController();

         
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=JobId1.id;
        insert sols;
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jolist[1].id,sols.id);
        
       List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
         CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp.CSS_Claims__c = cl.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='Campaign';
        AddsolComp.System_Code__c = 'FH';
        AddsolComp.Component_Code__c =  'AS';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        //AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        //AddsolComp.Fail_Code__c = 'test';
        //insert AddsolComp;
       solsComp.add(AddsolComp);
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        //AddsolComp1.Service_Job__c = jo.id;
        AddsolComp1.CSS_Claims__c = cl.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp1.Solutions__c = srt1;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.type__c='Campaign';
        AddsolComp1.System_Code__c = 'FH';
        AddsolComp1.Component_Code__c =  'AS';
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        //AddsolComp1.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.AccountCodeType__c='ASAS';
        AddsolComp1.Fail_Code_Editable__c='CAM-campaign-test1';
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
        //AddsolComp1.Fail_Code__c = 'test';
        //insert AddsolComp1;
       solsComp.add(AddsolComp1);
        insert solsComp;
                 //Create SRT record
        CSS_SRT__c srtobj1=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj1.SRT_ID__c = '00-00-401';
        srtobj1.IsPopUpSRT__c=false;
        srtobj1.Assignment__c = 'test';
        srtobj1.Component_Id__c = AddsolComp.id;
        srtobj1.FailCode__c='Select One';
        srtobj1.SRT_Title__c = 'test';
        srtobj1.SRT_Quantity__c=1;
        srtobj1.SRT_Time__c = 2;
        srtobj1.Access_Code__c = 'ters';
        srtobj1.SRT_Warrantable__c = '2.3';
        srtobj1.Adjustment_Reason__c = 'test';
         srtobj1.CSS_Claims__c = cl.id;
        srtobj1.SRT_Select__c = true;
        srtobj1.isPerformed__c = true;
        srtobj1.srt_category__c = 'test';
        srtobj1.type__c = 'Field Action';
        srtobj1.SRT_Type__c = 'Campaign';
        srtobj1.Extended_Hours__c = 1.2;
        srtobj1.SRT_Estimate__c = true;
        srtobj1.SRT_Category__c ='AdditionalDiag';
        //upsert srtobj1;
        
        CSS_SRT__c srtobj2=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj2.SRT_Category__c='Campaign';
        srtobj2.SRT_Type__c='Repair';
        srtobj2.Job_Order__c = JobId1.id;
        srtobj2.Component_Id__c = AddsolComp.id;
        srtobj2.SRT_Quantity__c=2;
        srtobj2.FailCode__c='EUCN';
        srtobj2.Account_Code__c='TEST';
        srtobj2.SRT_Select__c = true;
        srtobj2.SRT_ID__c = '00-901-00';
        srtobj2.IsPopUpSRT__c=true;
        srtobj2.SRT_Category__c ='AdditionalDiag';
        //upsert srtobj2;
        CSS_SRT__c srtobj3=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj3.SRT_Category__c='Campaign';
        srtobj3.SRT_Type__c='Repair';
        srtobj3.Job_Order__c = JobId1.id;
        srtobj3.Component_Id__c = AddsolComp.id;
        srtobj3.SRT_Quantity__c=2;
        srtobj3.FailCode__c='EUCN';
        srtobj3.Account_Code__c='TEST';
        srtobj3.SRT_Select__c = true;
        srtobj3.SRT_ID__c = '00-00-401';
        srtobj3.IsPopUpSRT__c=false;
        srtobj3.SRT_Category__c ='AdditionalDiag';
        CSS_SRT__c srtobj4=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj4.SRT_Category__c='Campaign';
        srtobj4.SRT_Type__c='Repair';
        srtobj4.Job_Order__c = JobId1.id;
        srtobj4.Component_Id__c = AddsolComp.id;
        srtobj4.SRT_Quantity__c=2;
        srtobj4.FailCode__c='EUCN';
        srtobj4.Account_Code__c='TEST';
        srtobj4.SRT_Select__c = true;
        srtobj4.SRT_ID__c = '00-00-724';
		 srtobj4.Assignment__c='test1';
        srtobj4.IsPopUpSRT__c=false;
        srtobj4.SRT_Category__c ='AdditionalDiag';
        CSS_SRT__c srtobj5=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj5.SRT_Category__c='Campaign';
        srtobj5.SRT_Type__c='Repair';
        srtobj5.Job_Order__c = JobId1.id;
        srtobj5.Component_Id__c = AddsolComp.id;
        srtobj5.SRT_Quantity__c=2;
        srtobj5.FailCode__c='EUCN';
        srtobj5.Account_Code__c='TEST';
        srtobj5.SRT_Select__c = true;
        srtobj5.SRT_ID__c = '00-00-111';
		 srtobj5.Assignment__c='test1';
        srtobj5.IsPopUpSRT__c=true;
    //    srtobj5.SRT_Category__c ='AdditionalDiag';
        list<CSS_SRT__c> srtlist=new list<CSS_SRT__c>();
        srtlist.add(srtobj1);
        srtlist.add(srtobj2);
        srtlist.add(srtobj3);
        srtlist.add(srtobj4);
         srtlist.add(srtobj5);
        insert srtlist;
        /*PageReference pageRef = Page.css_srtEditPopup; 
  pageRef.getParameters().put('JOBId', String.valueOf(JobId1.id));
  Test.setCurrentPage(pageRef);*/
        Test.starttest();
        PageReference pref;
        pref = new PageReference('/'+JobId1.id);
        pref.getParameters().put('JobOrderId',JobId1.id);
        pref.getParameters().put('type','Campaign');
        Test.setCurrentPage(pref);
        
       CG_CL_ClaimsSRTEditPopUp obj1=new CG_CL_ClaimsSRTEditPopUp();
        List<SelectOption> sepoplist=new list<SelectOption>();
       //CG_CL_ClaimsSRTEditPopUp.srtWrapperClass obj2=new CG_CL_ClaimsSRTEditPopUp.srtWrapperClass(0,srtlist[0].id,cl.id,'Test','1',1,null,sepoplist,sepoplist,'Test','Test','Test','AdditionalDiag',0.0,0.0,0.0,0.0,0.0,0.0,'B',null,false);
		obj1.selectedAdmin = true;
        //obj1.selectedPickVal = '00 - Cylinder Block';
        obj1.selectedPickVal = 'All';
        //obj1.searchDiagValue = '902';
     //   obj1.accordionType = 'AdditionalRep';
     obj1.accordionType = 'test1';
        obj1.selectedFailCode = 'THAC';
        obj1.loadSavedSRTs();
        //obj1.coverageType='2014-05-08T00:00:00.000-05:00';
        obj1.selectedAccess=true;
    	obj1.searchDiagSRTCodeAndDescription();  
 		obj1.ValidateAdminSRT();
        obj1.lstFilteredSRT = srtlist;
        //srtobj2.SRT_ID__c='00-401';
        obj1.ValidateAdminSRT();
        obj1.addSelectedSRTs();
        
        obj1.lstFilteredSRT=srtlist;
        obj1.ValidateAdminSRT();
        obj1.saveSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.removingRow();
        obj1.onChangeofFailCode();
        sepoplist=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
   //     flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        acoptlist=obj1.getAccountCodeOptionList('test-test1');
      //  acoptlist=obj1.getAccountCodeDropDown1();
      // obj1.checkDuplicateSRTs();
      List<CSS_Solution_Component__c> solsComp1 = new List<CSS_Solution_Component__c>();
        
        for(integer i=0;i<10;i++){
              CSS_Solution_Component__c AddsolComp11 = new CSS_Solution_Component__c();
        AddsolComp11.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp11.CSS_Claims__c = cl.id;
        AddsolComp11.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp11.Quantity__c = 4;
        AddsolComp11.type__c='Campaign';
        AddsolComp11.System_Code__c = 'FH';
        AddsolComp11.Component_Code__c =  'AS';
        AddsolComp11.Selected_Component__c = True;
        AddsolComp11.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        //AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp11.CoveredPartsQty__c = null;
        AddsolComp11.AccountCodeType__c='ASAS';
        AddsolComp11.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp11.Charlength__c = true;
        AddsolComp11.Name = 'Test'+Math.random();
            solsComp1.add(AddsolComp11);
        }
       
        upsert solsComp1;
        //obj1.addSelectedSRTs();
        Test.stopTest();
            
    }
    public static TestMethod void M22() 
    {
        Test.setMock(HttpCalloutMock.class, new css_getAllClaimsDigRepSRTs());
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
    //Test.starttest();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc; 
       
        CSS_Job_Order__c JobId1= new CSS_Job_Order__c();
        JobId1.Account__c=acc.id;
        CSS_Job_Order__c JobId2=CSS_TestData.createJobOrder(false);
        JobId2.Account__c=acc.id;
        list<CSS_Job_Order__c> jolist=new list<CSS_Job_Order__c>();
        jolist.add(JobId1);
        jolist.add(JobId2);
        insert jolist;
        system.debug('JOBS: '+jolist);
         
        CSS_Claims__c cl = new CSS_Claims__c();
        cl.Account__c=acc.id;
        cl.CSS_Job__c=JobId1.id;
        insert cl;
        
  //css_srtEditPopupController obj1=new css_srtEditPopupController();

         
        CSS_Solutions__c sols=new CSS_Solutions__c();
        sols.name='TEST';
        sols.Service_Job__c=JobId1.id;
        insert sols;
        
        //Create Solution Component
        CSS_TestData.createSRT(true,jolist[1].id,sols.id);
        
       List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
         CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp.CSS_Claims__c = cl.id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='Campaign';
        AddsolComp.System_Code__c = 'FH';
        AddsolComp.Component_Code__c =  'AS';
        //AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        //AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        //AddsolComp.Fail_Code__c = 'test';
        //insert AddsolComp;
       solsComp.add(AddsolComp);
        insert solsComp;
                 //Create SRT record
        CSS_SRT__c srtobj1=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj1.SRT_ID__c = '00-00-904';
        srtobj1.IsPopUpSRT__c=false;
        srtobj1.Assignment__c = 'NOT CLAIMABLE';
        srtobj1.Component_Id__c = AddsolComp.id;
        srtobj1.FailCode__c='Select One';
        srtobj1.SRT_Title__c = 'test';
        srtobj1.SRT_Quantity__c=1;
        srtobj1.SRT_Time__c = 2;
        srtobj1.Access_Code__c = 'ters';
        srtobj1.SRT_Warrantable__c = '2.3';
        srtobj1.Adjustment_Reason__c = 'test';
         srtobj1.CSS_Claims__c = cl.id;
        srtobj1.SRT_Select__c = true;
        srtobj1.isPerformed__c = true;
        srtobj1.srt_category__c = 'test';
        srtobj1.type__c = 'Field Action';
        srtobj1.SRT_Type__c = 'Campaign';
        srtobj1.Extended_Hours__c = 1.2;
        srtobj1.SRT_Estimate__c = true;
        //upsert srtobj1;
        
        CSS_SRT__c srtobj2=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj2.SRT_Category__c='Campaign';
        srtobj2.SRT_Type__c='Repair';
        srtobj2.Job_Order__c = JobId1.id;
        srtobj2.Component_Id__c = AddsolComp.id;
        srtobj2.SRT_Quantity__c=2;
        srtobj2.FailCode__c='EUCN';
        srtobj2.Account_Code__c='TEST';
        srtobj2.SRT_Select__c = true;
        srtobj2.SRT_ID__c = '00-00-401';
        srtobj2.IsPopUpSRT__c=true;
         CSS_SRT__c srtobj21=CSS_TestData.createSRT(false,'abc',sols.id,JobId1.id);
        srtobj21.SRT_Category__c='Campaign';
        srtobj21.SRT_Type__c='Access';
        srtobj21.Job_Order__c = JobId1.id;
        srtobj21.Component_Id__c = AddsolComp.id;
        srtobj21.SRT_Quantity__c=2;
        srtobj21.FailCode__c='EUCN';
        srtobj21.Account_Code__c='TEST';
        srtobj21.SRT_Select__c = true;
        srtobj21.SRT_ID__c = '00-00-901';
        srtobj21.IsPopUpSRT__c=false;
        //upsert srtobj2;

        list<CSS_SRT__c> srtlist=new list<CSS_SRT__c>();
        srtlist.add(srtobj1);
        srtlist.add(srtobj2);
        srtlist.add(srtobj21);
        insert srtlist;
        /*PageReference pageRef = Page.css_srtEditPopup; 
  pageRef.getParameters().put('JOBId', String.valueOf(JobId1.id));
  Test.setCurrentPage(pageRef);*/
        Test.starttest();
        PageReference pref;
        pref = new PageReference('/'+JobId1.id);
        pref.getParameters().put('JobOrderId',JobId1.id);
        pref.getParameters().put('type','Campaign');
        Test.setCurrentPage(pref);
        
       CG_CL_ClaimsSRTEditPopUp obj1=new CG_CL_ClaimsSRTEditPopUp();
        List<SelectOption> sepoplist=new list<SelectOption>();
       //CG_CL_ClaimsSRTEditPopUp.srtWrapperClass obj2=new CG_CL_ClaimsSRTEditPopUp.srtWrapperClass(0,srtlist[0].id,cl.id,'Test','1',1,null,sepoplist,sepoplist,'Test','Test','Test','AdditionalDiag',0.0,0.0,0.0,0.0,0.0,0.0,'B',null,false);
		obj1.selectedAdmin = true;
        //obj1.selectedPickVal = '00 - Cylinder Block';
        obj1.selectedPickVal = 'All';
        //obj1.searchDiagValue = '902';
        obj1.accordionType = 'AdditionalRep';
        obj1.selectedFailCode = 'THAC';
        obj1.loadSavedSRTs();
        //obj1.coverageType='2014-05-08T00:00:00.000-05:00';
        obj1.selectedAccess=true;
        obj1.selectedPickVal='All';
        obj1.searchDiagValue='00-901';
        obj1.lstDisplaySRT = srtlist;
    	obj1.searchDiagSRTCodeAndDescription();  
 		obj1.ValidateAdminSRT();
        obj1.lstFilteredSRT = srtlist;
        //srtobj2.SRT_ID__c='00-401';
        obj1.ValidateAdminSRT();
        obj1.addSelectedSRTs();
        
        obj1.lstFilteredSRT=srtlist;
        obj1.ValidateAdminSRT();
        obj1.saveSelectedSRTs();
        obj1.saveAndCloseSelectedSRTs();
        obj1.removingRow();
        obj1.onChangeofFailCode();
        sepoplist=obj1.getGroupList();
        List<SelectOption> flcdrdn=new List<SelectOption>();
     //   flcdrdn=obj1.getfailcodeDropDown();
        List<SelectOption> acoptlist=new List<SelectOption>();
        List<string> sortable = new  List<string>();
        sortable.add('test1');
        sortable.add('test2');
        sortable.add('test3');
        acoptlist=obj1.getAccountCodeOptionList('test-test123');
      //  acoptlist=obj1.getAccountCodeDropDown1();
      // obj1.checkDuplicateSRTs();
      List<CSS_Solution_Component__c> solsComp1 = new List<CSS_Solution_Component__c>();
        
        for(integer i=0;i<10;i++){
              CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        //AddsolComp.Service_Job__c = jo.id;
        AddsolComp1.CSS_Claims__c = cl.id;
        AddsolComp1.Action__c = 'Repair';
        //AddsolComp.Solutions__c = srt1;
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.type__c='Campaign';
        AddsolComp1.System_Code__c = 'FH';
        AddsolComp1.Component_Code__c =  'AS';
        //AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = 'CAP-Customized Assurance Plan DC';
        //AddsolComp.AccountCodeEdit__c = 'CAP-Customized Assurance Plan DC';
        AddsolComp1.CoveredPartsQty__c = null;
        AddsolComp1.AccountCodeType__c='ASAS';
        AddsolComp1.Fail_Code_Editable__c='CAM-campaign';
        AddsolComp1.Charlength__c = true;
        AddsolComp1.Name = 'Test'+Math.random();
            solsComp1.add(AddsolComp1);
        }
       
        upsert solsComp1;
        obj1.addSelectedSRTs();
        Test.stopTest();
            
    }
    
   
}