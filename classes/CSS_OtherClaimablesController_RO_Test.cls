@isTest
public class CSS_OtherClaimablesController_RO_Test  
{
    @testsetup static void testdatamethod()
    {
        CSS_JobEventTemporary__c jobEvt = new CSS_JobEventTemporary__c();
        jobEvt.Key__c='OtherClaimables';
        jobevt.Reason__c='{ "DataArea": [ { "MiscName": "Misc Name", "MiscDescription": "", "Multiplier": 5723046, "FlatAmount": 3454, "Maximum": 24534, "AutoCharage": "Y", "CreditType": "BOX 129", "ChargeCategory": "TRVL", "NewWarrantyClass": "Misc Name (Warrantable)" } ], "Header": { "Status": "SUCCESS", "Sender": { "ServiceName": "getMISCChargeLOVs", "SenderID": "BMS" }, "Target": { "TargetID": "CSS" }, "Location": { "LocationID": "56270-56255" } } }';
        insert jobEvt;
        CSS_JobEventTemporary__c jobEvt1 = new CSS_JobEventTemporary__c();
        jobEvt1.Key__c='TTML';
        jobevt1.Reason__c='{ "DataArea": [ { "MiscName": "Misc Name", "MiscDescription": "", "Multiplier": 5723046, "FlatAmount": 3454, "Maximum": 24534, "AutoCharage": "Y", "CreditType": "BOX 129", "ChargeCategory": "TRVL", "NewWarrantyClass": "Misc Name (Warrantable)" } ], "Header": { "Status": "SUCCESS", "Sender": { "ServiceName": "getMISCChargeLOVs", "SenderID": "BMS" }, "Target": { "TargetID": "CSS" }, "Location": { "LocationID": "56270-56255" } } }';
        insert jobEvt1;
    }
    
    static testmethod void CSS_OtherClaimables_method1()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Dealer Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=true;
        insert du;
        insert acc;
        
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        //u.put('DefaultCurrencyIsoCode', 'USD');                 
        insert u;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        JO.CSS_Job_Location_Code__c='03742-03742';
        update JO;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c = true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
       
        
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp1.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp.Selected_Component__c=true;
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
      
        
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp.Selected_Component__c=true;
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        
        
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp.Selected_Component__c=true;
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        lstsolcomp.add(solcomp3);
        lstsolcomp.add(solcomp4);
        insert lstsolcomp;
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Type__c='Meals'; 
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Sell_Price__c = 98;
        partsoption.Exchange_Rate_Version__c = 2;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        selectedCustPartsList.add(partsoption);
        
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Unlisted';
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Type__c='Commercial-Travel'; 
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.css_estimate__c = true;
        partsoption1.selected_part__c = true;
        partsoption1.PartOC__c = 'OC';
        partsoption1.Exchange_Rate_Version__c = 2;
        partsoption1.Sell_Price__c = 97;
        partsoption1.Unit_Price__c = '200';
        partsoption1.Unit_Price_Local_Currency__c = 110;
        partsoption1.ExpenseTotal__c = 300;
        selectedCustPartsList.add(partsoption1);
        insert selectedCustPartsList;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        CSS_JobEventTemporary__c obj1 = new CSS_JobEventTemporary__c();
        obj1.key__c = 'AccountCodes';
        obj1.Attribute1__c = 'OTH';
        insert obj1;
        
        CSS_JobEventTemporary__c obj2 = new CSS_JobEventTemporary__c();
        obj2.key__c = 'AccountCodes';
        obj2.Attribute1__c = 'POL';
        insert obj2;
        
        List<CSS_Parts_Options__c> prtlst = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtobj = new CSS_Parts_Options__c();
        prtobj.css_estimate__c = true;
        prtobj.selected_part__c = true;
        prtobj.Type__c = 'commercial-travel';
        prtlst.add(prtobj);
        insert prtlst;
      
        List<SelectOption> listAccCode = new List<Selectoption>();
        listAccCode.add(new SelectOption('Customized Assurance Plan DC','Customized Assurance Plan DC1')) ;       
        
        test.startTest();
        List<css_otherclaimablesController_RO.ttmlWrapperClass> twarp1= new List<css_otherclaimablesController_RO.ttmlWrapperClass>();
        css_otherclaimablesController_RO.ttmlWrapperClass twrap=new css_otherclaimablesController_RO.ttmlWrapperClass(123,null,'String','String','4','6','7','8','String','String','String',true,true,true,true,true,null,'String',1.0,'5',2.0,'string',true,'6','2',true, null, true,'string');
        twarp1.add(twrap);
         
        list<CSS_OtherClaimablesController_RO.claimablesWrapperClass>  listparts = new  list<CSS_OtherClaimablesController_RO.claimablesWrapperClass> ();
        for(integer i=0;i<10;i++)
            listparts.add(new CSS_OtherClaimablesController_RO.claimablesWrapperClass(12+i,sol.id,'DCA','DCA','75',9999.99,'88','DCA','DCA','PartOC',76.21,'145',345.45,true,45.21,listAccCode,listAccCode,true,true,null,null,100.4,88.8) ) ;
        
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        otherclaim.listpartWrapper =listparts;
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=true;
        otherclaim.SelectedItem='Misc Name';
        otherclaim.getOCData();
        //otherclaim.getAllTTMLPartsData();
        //otherclaim.getfailcodeDropDown();
        //otherclaim.getTechnicians();
        //otherclaim.typeListChange();
        otherclaim.selectedRemoveRow=1;
        otherclaim.SelectedItem='Misc Name';
        //otherclaim.AddRow();
        //otherclaim.closePopUp();
       // otherclaim.displayPopUp();
        //otherclaim.deleteParts();
        //otherclaim.removingRow();
        //otherclaim.saveOtherClaimables();
        //otherclaim.removingTTMLRow();
        //otherclaim.saveTTMLParts();
        //otherclaim.addTTMLRow();
        otherclaim.JobId = JO.id;
        otherclaim.displayPopup2 = true;
        otherclaim.totalamount=999990.99;
        //otherclaim.onChangeofEstimate();
        //otherclaim.SendOtherClaimablestoERP();
        //otherclaim.getTTMLType();
        Set<Boolean> obj = new Set<Boolean>();
        boolean setTtmlReqErrMsg = true;
        obj.add(setTtmlReqErrMsg);
        //otherclaim.saveTTMLPopup();
        //otherclaim.typeListChange();
        otherclaim.listTTMLWrapper=twarp1;
        otherclaim.getAccCodesonChngofFailCode();
       // otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
       // otherclaim.populateAmountValue();
       // otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        //otherclaim.getfailCodeValues();
       // otherclaim.typeListChangeforDealer();
       // otherclaim.typeListChangeNewttmlacc();
        otherclaim.isOneBMS=true;
        otherclaim.mapTTMLItemWarnty=null;
       // otherclaim.getTTMLType();
        otherclaim.isOneBMS=null;
       // otherclaim.getTTMLType();
        otherclaim.twoerrormsg=false;
        otherclaim.SelectedQty='';
        otherclaim.selectedType='';
        otherclaim.workJob= new css_job_order__c();
        otherclaim.lstAccountCodes= new list<string>();
        otherclaim.accCodes=new list<selectoption>();
        otherclaim.jobEventTemp= new list<CSS_JobEventTemporary__c>();
        otherclaim.dealer=null;
        otherclaim.redirectToWarranty();
        //otherclaim.saveTTMLParts();
        //otherclaim.listpartWrapper=twarp1;
        //otherclaim.populateAmountValue(); 
        //otherclaim.listTTMLWrapper=null;
        //otherclaim.removingTTMLRow();
        test.stopTest();
    }
    
    /*static testmethod void CSS_OtherClaimables_method2()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_JobEventTemporary__c joevt2=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='TTML' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        JO.Additional_Tech1__c=u.id;
        JO.Additional_Tech2__c=u.id;
        JO.Additional_Tech3__c=u.id;
        JO.Additional_Tech4__c=u.id;
        JO.Additional_Tech5__c=u.id;
        JO.Additional_Tech6__c=u.id;
        JO.Additional_Tech7__c=u.id;
        update JO;
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c=true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.CSS_CoverageType__c = 'Test';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp.Selected_Component__c=true;
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.CSS_CoverageType__c = 'Sample';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp.Selected_Component__c=true;
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.CSS_CoverageType__c = 'Sample';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp.Selected_Component__c=true;
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Type__c='Meals'; 
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Sell_Price__c = 99;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Type__c='Commercial-Travel'; 
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c = 96;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        List<CSS_Parts_Options__c> prtlst1 = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtobj1 = new CSS_Parts_Options__c();
        prtobj1.css_estimate__c = false;
        prtobj1.selected_part__c = true;
        prtobj1.Type__c = 'commercial-travel';
        insert prtobj1;
        prtlst1.add(prtobj1);
        
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        
        otherclaim.typeListChangeforDealer();
        
        
        List<CSS_Parts_Options__c> prtlst2 = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtobj2 = new CSS_Parts_Options__c();
        prtobj2.css_estimate__c = true;
        prtobj2.selected_part__c = true;
        prtobj2.Type__c = 'Non Commercial-Travel';
        insert prtobj2;
        prtlst1.add(prtobj2);
        CSS_OtherClaimablesController_RO otherclaim1 = new CSS_OtherClaimablesController_RO();
        otherclaim1.typeListChangeforDealer();
        List<CSS_Parts_Options__c> prtlst3 = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtobj3 = new CSS_Parts_Options__c();
        prtobj3.css_estimate__c = false;
        prtobj3.selected_part__c = true;
        prtobj3.Type__c = 'Meals';
        insert prtobj3;
        prtlst1.add(prtobj3);
        CSS_OtherClaimablesController_RO otherclaim2 = new CSS_OtherClaimablesController_RO();
        otherclaim2.typeListChangeforDealer();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.SelectedItem='Misc Name';
        otherclaim.getTechnicians();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeNewttmlacc();
        
        
        otherclaim.getOCData();
        otherclaim.SendOtherClaimablestoERP();
        
        
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
   //     otherclaim.getTTMLType();
        
        
     //   otherclaim.saveTTMLPopup();
     //   otherclaim.typeListChange();
    //    otherclaim.getAccCodesonChngofFailCode();
    //    otherclaim.deleteTTMLParts();
   //     otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
    //    otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
    //    otherclaim.typeListChangeNewttmlacc();
        test.stopTest();
        
        
    }
    
    static testmethod void CSS_OtherClaimables_method3()
    {
        
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Type__c='Towing'; 
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Sell_Price__c = 95;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        selectedCustPartsList.add(partsoption);
        
        
        
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=true;
        partsoption1.selected_part__c=true;
        partsoption1.Type__c='Lodging';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c =  94;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=true;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.getOCData();
        otherclaim.SendOtherClaimablestoERP();
        
        
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        //   otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        test.stopTest();
    }
    
    static testmethod void CSS_OtherClaimables_method4()
    {
        test.startTest();
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp1.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        //List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=true;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.selectedRemoveRow=0;
        otherclaim.getOCData();
        otherclaim.removingTTMLRow();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        if(joevt1!=null)
            otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        otherclaim.onChangeofFailCode();
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        //   otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        test.stopTest();
        
    }
    
    static testmethod void CSS_OtherClaimables_method5()
    {
        
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        //solcomp.Fail_Code__c = 'areirn-test-failcode';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp1.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp1.Service_Job__c = jo.id;
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        //List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Css_Estimate__c=false;
        partsoption.selected_part__c=true;
        partsoption.Type__c='Lodging';  
        partsoption.Days__c=1.0;
        partsoption.Amount__c = 122222;
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Sell_Price__c = 93;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        //selectedCustPartsList.add(partsoption);
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=true;
        partsoption1.selected_part__c=true;
        partsoption1.Type__c='Lodging';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c = 92;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=true;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.getOCData();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        otherclaim.getAccountCodeDropDown('areirn-test-failcode');
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        //   otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        test.stoptest();
    }
    
    static testmethod void CSS_OtherClaimables_method6()
    {
        
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp1.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        //List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Css_Estimate__c=false;
        partsoption.selected_part__c=true;
        partsoption.Type__c='Lodging';  
        partsoption.Days__c=1.0;
        partsoption.Sell_Price__c = 91;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        //selectedCustPartsList.add(partsoption);
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=false;
        partsoption1.selected_part__c=true;
        partsoption1.Type__c='Lodging';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c = 93;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=true;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.selectedRemoveRow=1;
        otherclaim.twoerrormsg=true;
        otherclaim.errorDisplay1=true;
        otherclaim.selectedType='Unlisted';
        otherclaim.getOCData();
        otherclaim.removingTTMLRow();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        //    otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        test.stopTest();
        
    }
    
    static testmethod void CSS_OtherClaimables_method7()
    {
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        list<CSS_Parts_Options__c> lstprt = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Css_Estimate__c=false;
        partsoption.selected_part__c=true;
        partsoption.Type__c='Lodging';  
        partsoption.Days__c=1.0;
        partsoption.Sell_Price__c = 90;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        lstprt.add(partsoption);
        insert lstprt;
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        otherclaim.redirectToWarranty();
        
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        //  otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        
        test.stopTest();
    }
   
    static testmethod void CSS_OtherClaimables_method8()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Dealer Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=true;
        insert du;
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        JO.CSS_Job_Location_Code__c='03742-03742';
        update JO;
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c = true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp1.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp.Selected_Component__c=true;
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp.Selected_Component__c=true;
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp.Selected_Component__c=true;
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Type__c='Commercial-Travel'; 
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Sell_Price__c = 87;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        selectedCustPartsList.add(partsoption);
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Unlisted';
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Type__c='Non Commercial-Travel'; 
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.css_estimate__c = false;
        partsoption1.selected_part__c = true;
        partsoption1.PartOC__c = 'OC';
        partsoption1.Sell_Price__c = 86;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        CSS_Parts_Options__c partsoption2 = new CSS_Parts_Options__c();
        partsoption2.quantity__c = 100;
        partsoption2.RecordTypeId = recTypeIdpart1;
        partsoption2.Item__c = 'Unlisted';
        partsoption2.Covered__c = 100;
        partsoption2.Amount__c = 122;
        partsoption2.Type__c='Meals'; 
        partsoption2.Fail_Code__c = 'test';
        partsoption2.Account_Code__c = 'test';
        partsoption2.Part_Description__c = 'test-PD';
        partsoption2.Service_Job__c = JO.id;
        partsoption2.css_estimate__c = false;
        partsoption2.selected_part__c = true;
        partsoption2.PartOC__c = 'OC';
        partsoption2.Sell_Price__c = 85;
        partsoption2.Unit_Price__c = '199';
        partsoption2.Unit_Price_Local_Currency__c = 120;
        partsoption2.ExpenseTotal__c = 300;
        partsoption2.Exchange_Rate_Version__c = 2;
        insert partsoption2;
        
        CSS_Parts_Options__c partsoption3 = new CSS_Parts_Options__c();
        partsoption3.quantity__c = 100;
        partsoption3.RecordTypeId = recTypeIdpart1;
        partsoption3.Item__c = 'Unlisted';
        partsoption3.Covered__c = 100;
        partsoption3.Amount__c = 122;
        partsoption3.Type__c='Lodging'; 
        partsoption3.Fail_Code__c = 'test';
        partsoption3.Account_Code__c = 'test';
        partsoption3.Part_Description__c = 'test-PD';
        partsoption3.Service_Job__c = JO.id;
        partsoption3.css_estimate__c = false;
        partsoption3.selected_part__c = true;
        partsoption3.PartOC__c = 'OC';
        partsoption3.Sell_Price__c = 84;
        partsoption3.Unit_Price__c = '199';
        partsoption3.Unit_Price_Local_Currency__c = 120;
        partsoption3.ExpenseTotal__c = 300;
        partsoption3.Exchange_Rate_Version__c = 2;
        insert partsoption3;
        
        CSS_Parts_Options__c partsoption4 = new CSS_Parts_Options__c();
        partsoption4.quantity__c = 100;
        partsoption4.RecordTypeId = recTypeIdpart1;
        partsoption4.Item__c = 'Unlisted';
        partsoption4.Covered__c = 100;
        partsoption4.Amount__c = 122;
        partsoption4.Type__c='Lodging'; 
        partsoption4.Fail_Code__c = 'test';
        partsoption4.Account_Code__c = 'test';
        partsoption4.Part_Description__c = 'test-PD';
        partsoption4.Service_Job__c = JO.id;
        partsoption4.css_estimate__c = false;
        partsoption4.selected_part__c = true;
        partsoption4.PartOC__c = 'OC';
        partsoption4.Sell_Price__c = 83;
        partsoption4.Unit_Price__c = '199';
        partsoption4.Unit_Price_Local_Currency__c = 120;
        partsoption4.ExpenseTotal__c = 300;
        partsoption4.Exchange_Rate_Version__c = 2;
        insert partsoption4;
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        CSS_JobEventTemporary__c obj1 = new CSS_JobEventTemporary__c();
        obj1.key__c = 'AccountCodes';
        insert obj1;
        List<CSS_Parts_Options__c> prtlst = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtobj = new CSS_Parts_Options__c();
        prtobj.css_estimate__c = true;
        prtobj.selected_part__c = true;
        prtobj.Type__c = 'Towing';
        
        insert prtobj;
        prtlst.add(prtobj);
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        //otherclaim.DealerUser=true;
        
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=true;
        otherclaim.SelectedItem='Misc Name';
        otherclaim.getOCData();
        otherclaim.getAllTTMLPartsData();
        otherclaim.getfailcodeDropDown();
        
  //      otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        otherclaim.selectedRemoveRow=1;
        otherclaim.SelectedItem='Misc Name';
        
        List<SelectOption> listAccCode = new List<Selectoption>();
        listAccCode.add(new SelectOption('Customized Assurance Plan DC','Customized Assurance Plan DC1')) ;       
        
        test.startTest();
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        //   otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        otherclaim.JobId = JO.id;
        otherclaim.displayPopup2 = true;
        //CSS_OtherClaimablesController_RO.claimablesWrapperClass claimobj = new CSS_OtherClaimablesController_RO.claimablesWrapperClass(1234,sol.Id,'Clamp','N/A','Quantity',1234.00,'coveredPercent','Select One','Select One','PartOC',1234.00,'QuantityOrdered',1234.00,true,1234.00,listAccCode);
        //List<CSS_OtherClaimablesController_RO.claimablesWrapperClass> wprList = new List<CSS_OtherClaimablesController_RO.claimablesWrapperClass>();
        //wprList.add(claimobj);
        //otherclaim.saveOtherClaimablesPopup();
   //     otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        Set<Boolean> obj = new Set<Boolean>();
        boolean setTtmlReqErrMsg = true;
        obj.add(setTtmlReqErrMsg);
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        test.stopTest();
    }
    
    static testmethod void CSS_OtherClaimables_method9()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Dealer Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=true;
        insert du;
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Type__c='Towing'; 
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Sell_Price__c = 82;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        selectedCustPartsList.add(partsoption);
        
        
        
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 1000000;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=true;
        partsoption1.selected_part__c=true;
        partsoption1.Type__c='Lodging';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c = 81;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        CSS_Parts_Options__c partsoption2 = new CSS_Parts_Options__c();
        partsoption2.quantity__c = 100;
        partsoption2.RecordTypeId = recTypeIdpart1;
        partsoption2.Item__c = 'Select One';
        partsoption2.Css_Estimate__c=true;
        partsoption2.selected_part__c=true;
        partsoption2.Type__c='Non Commercial-Travel';  
        partsoption2.Days__c=1.0;
        partsoption2.Covered__c = 100;
        partsoption2.Amount__c = 122;
        partsoption2.Fail_Code__c = 'test';
        partsoption2.Account_Code__c = 'test';
        partsoption2.Part_Description__c = 'test-PD';
        partsoption2.Service_Job__c = JO.id;
        partsoption2.Sell_Price__c = 80;
        partsoption2.Unit_Price__c = '199';
        partsoption2.Unit_Price_Local_Currency__c = 120;
        partsoption2.ExpenseTotal__c = 300;
        partsoption2.Exchange_Rate_Version__c = 2;
        insert partsoption2;
        
        CSS_Parts_Options__c partsoption3 = new CSS_Parts_Options__c();
        partsoption3.quantity__c = 100;
        partsoption3.RecordTypeId = recTypeIdpart1;
        partsoption3.Item__c = 'Select One';
        partsoption3.Css_Estimate__c=true;
        partsoption3.selected_part__c=true;
        partsoption3.Type__c='Commercial-Travel';  
        partsoption3.Days__c=1.0;
        partsoption3.Covered__c = 100;
        partsoption3.Amount__c = 1220000;
        partsoption3.Fail_Code__c = 'test';
        partsoption3.Account_Code__c = 'test';
        partsoption3.Part_Description__c = 'test-PD';
        partsoption3.Service_Job__c = JO.id;
        partsoption3.Sell_Price__c = 79;
        partsoption3.Unit_Price__c = '199';
        partsoption3.Unit_Price_Local_Currency__c = 120;
        partsoption3.ExpenseTotal__c = 300;
        partsoption3.Exchange_Rate_Version__c = 2;
        insert partsoption3;
        
        
        
        
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=true;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.getOCData();
        otherclaim.SendOtherClaimablestoERP();
        
        
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        //    otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        test.stopTest();
    }
    
   
    
    static testmethod void CSS_OtherClaimables_method11()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Dealer Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=true;
        insert du;
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables'];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp1.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        //List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Css_Estimate__c=false;
        partsoption.selected_part__c=true;
        partsoption.Type__c='Non Commercial-Travel';  
        partsoption.Days__c=1.0;
        partsoption.Amount__c = 122222;
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Sell_Price__c = 76;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        //selectedCustPartsList.add(partsoption);
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=false;
        partsoption1.selected_part__c=false;
        partsoption1.Type__c='Lodging';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 1228888;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c = 75;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        CSS_Parts_Options__c partsoption2 = new CSS_Parts_Options__c();
        partsoption2.quantity__c = 100;
        partsoption2.RecordTypeId = recTypeIdpart1;
        partsoption2.Item__c = 'Select One';
        partsoption2.Css_Estimate__c=false;
        partsoption2.selected_part__c=false;
        partsoption2.Type__c='Commercial-Travel';  
        partsoption2.Days__c=1.0;
        partsoption2.Covered__c = 100;
        partsoption2.Amount__c = 1228888;
        partsoption2.Fail_Code__c = 'test';
        partsoption2.Account_Code__c = 'test';
        partsoption2.Part_Description__c = 'test-PD';
        partsoption2.Service_Job__c = JO.id;
        partsoption2.Sell_Price__c = 74;
        partsoption2.Unit_Price__c = '199';
        partsoption2.Unit_Price_Local_Currency__c = 120;
        partsoption2.ExpenseTotal__c = 300;
        partsoption2.Exchange_Rate_Version__c = 2;
        insert partsoption2;
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=false;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.getOCData();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        otherclaim.getAccountCodeDropDown('areirn-test-failcode');
        otherclaim.getAccountCodeDropDown('areirn-test');
        otherclaim.getAccountCodeDropDown('areirn-test-areirn-test');
        otherclaim.failAccountCodeMap= new Map<string, set<String>>{'test1' => new set<string>{'test12','test13'},'test2' => new set<string>{'test22','test23'}};
            otherclaim.getAccountCodeDropDown('test1');
        otherclaim.failAccountCodeMap= new Map<string, set<String>>{'test1' => new set<string>(),'test2' => new set<string>{'test22','test23'}};
            otherclaim.getAccountCodeDropDown('test1');
        list<CSS_Parts_Options__c> parts = new list<CSS_Parts_Options__c>();
        for(integer i=0;i<10;i++)
            parts.add(new CSS_Parts_Options__c(quantity__c = 100,Item__c = 'Select One',Covered__c = 100,RecordTypeId = recTypeIdpart,Amount__c = 122,Fail_Code__c = 'test',Account_Code__c = 'test',Part_Description__c = 'test-PD',Service_Job__c = JO.id,Css_Estimate__c=false,selected_part__c=true,Type__c='Select One',Days__c=1.0));
        insert parts;
        otherclaim.SelectedPart=parts[0].Id;
        otherclaim.otherClaimPartList=parts;
        otherclaim.selectedEstimate=true;
        otherclaim.onChangeofEstimate(); 
        List<SelectOption> listAccCode = new List<Selectoption>();
        listAccCode.add(new SelectOption('Customized Assurance Plan DC','Customized Assurance Plan DC1')) ; 
        
        list<CSS_OtherClaimablesController_RO.claimablesWrapperClass>  listparts = new  list<CSS_OtherClaimablesController_RO.claimablesWrapperClass> ();
        for(integer i=0;i<10;i++)
            listparts.add(new CSS_OtherClaimablesController_RO.claimablesWrapperClass(12+i,sol.id,'DCA','DCA','75',9999.99,'88','DCA','DCA','PartOC',76.21,'145',345.45,true,45.21,listAccCode,listAccCode,true,true,null,null,100.4,88.8) ) ;
        otherclaim.listpartWrapper =listparts;
        for(CSS_OtherClaimablesController_RO.claimablesWrapperClass count: listparts){
            otherclaim.selectedRecordRowID=count.counting;
            otherclaim.populateAmountValue();
            count.accountCode ='Select One';
            otherclaim.populateAmountValue();
            count.coveredPercent='0';
            otherclaim.populateAmountValue();
            
            
        }
        listparts[0].item='Unlisted';
        otherclaim.saveOtherClaimablesPopup();
        listparts[0].item='Unlisted';
        listparts[0].PartDescription='N/A';
        otherclaim.saveOtherClaimablesPopup();
        listparts[1].item='';
        otherclaim.saveOtherClaimablesPopup();
        listparts[0].item='Select one';
        listparts[1].item='Unlisted';
        listparts[1].PartDescription='';
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.listpartWrapper.clear();
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.mpItemNewWarranty= new map<string,string>{'Test'=>'Unlisted (Warrantable)','Test1'=>'Unlisted'};
        otherclaim.SelectedItem='Test';
        otherclaim.SelectedPartID=3;
        otherclaim.onChangeofItem();
        otherclaim.SelectedPartID=0;
        otherclaim.onChangeofItem();
        
        
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        otherclaim.selectedFailCode='test-test';
        otherclaim.onChangeofFailCode();
        otherclaim.selectedFailCode='test';
        otherclaim.onChangeofFailCode();
        otherclaim.onChangeofFailCode();
        otherclaim.selectedFailCode='test-test-test';
        otherclaim.onChangeofFailCode();
        otherclaim.selectedFailCode='test-test-test-test';
        otherclaim.onChangeofFailCode();
        otherclaim.selectedFailCode='Select One';
        otherclaim.onChangeofFailCode();
        otherclaim.SelectedAccountCode='Select One';
        otherclaim.onChangeofAccountCode();
        otherclaim.removeIdsMap=null;
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.deleteTTMLParts();
        otherclaim.deleteParts();
        otherclaim.listpartWrapper=null;
        otherclaim.listTTMLWrapper=null;
        otherclaim.AddRow();
        otherclaim.removingRow();
        otherclaim.addTTMLRow();
        otherclaim.removingTTMLRow();
        otherclaim.SelectedItem=null;
        otherclaim.typeListChangeNewttmlacc();
        otherclaim.typeListChange();
        otherclaim.SelectedPartID=null;
        otherclaim.typeListChangeforDealer();
        
        test.stoptest();
    }
    
    static testmethod void CSS_OtherClaimables_method12()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Dealer Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=false;
        insert du;
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        
        
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp1.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        //insert lstsolcomp;
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        //List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Css_Estimate__c=false;
        partsoption.selected_part__c=true;
        partsoption.Type__c='Select One';  
        partsoption.Days__c=1.0;
        partsoption.Sell_Price__c = 73;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        //selectedCustPartsList.add(partsoption);
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=false;
        partsoption1.selected_part__c=true;
        partsoption1.Type__c='Towing';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 12234522;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c = 72;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=false;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.selectedRemoveRow=1;
        otherclaim.twoerrormsg=true;
        otherclaim.errorDisplay1=false;
        otherclaim.selectedType='Unlisted';
   //     otherclaim.getOCData();
        otherclaim.removingTTMLRow();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        otherclaim.saveTTMLPopup();
        
   //     otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        
        otherclaim.typeListChange();
   //     otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
    //    otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
    //    otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        test.stopTest();
        
    }
    
    static testmethod void CSS_OtherClaimables_method13()
    {
        
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.css_estimate__c=true;
        partsoption.Amount__c = 122;
        partsoption.Type__c='Towing'; 
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Sell_Price__c = 69;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        selectedCustPartsList.add(partsoption);
        
        
        
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=false;
        partsoption1.selected_part__c=true;
        partsoption1.Type__c='Lodging';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c = 68;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=true;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.getOCData();
        otherclaim.SendOtherClaimablestoERP();
        
        
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        //    otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        test.stopTest();
    }
    
    static testmethod void CSS_OtherClaimables_method14()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Dealer Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=false;
        insert du;
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        
        
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Css_Estimate__c=false;
        partsoption.selected_part__c=true;
        partsoption.Type__c='Select One';  
        partsoption.Days__c=1.0;
        partsoption.Sell_Price__c = 66;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=true;
        partsoption1.selected_part__c=true;
        partsoption1.Type__c='Towing';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 12234522;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c = 65;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=false;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.selectedRemoveRow=1;
        otherclaim.twoerrormsg=true;
        otherclaim.errorDisplay1=false;
        otherclaim.selectedType='Unlisted';
        otherclaim.getOCData();
        otherclaim.removingTTMLRow();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        otherclaim.saveTTMLPopup();
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        test.stopTest();
        
    } 
    
    static testmethod void CSS_OtherClaimables_method15()
    {
        //public List<ttmlWrapperClass> listTTMLWrapper {get; set;}	
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(123,null,'String','String','String','String','String','String','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'String','string',true, null, true,'string');
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Dealer Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=false;
        insert du;
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        
        
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.css_coveragetype__c='OTH';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Css_Estimate__c=false;
        partsoption.selected_part__c=true;
        partsoption.Type__c='Select One';  
        partsoption.Days__c=1.0;
        partsoption.Sell_Price__c = 64;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=true;
        partsoption1.selected_part__c=true;
        partsoption1.Type__c='Towing';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 12234522;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c = 63;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=false;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.selectedRemoveRow=1;
        otherclaim.twoerrormsg=true;
        otherclaim.errorDisplay1=false;
        otherclaim.selectedType='Unlisted';
        otherclaim.getOCData();
        otherclaim.removingTTMLRow();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        otherclaim.saveTTMLPopup();
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        
        test.stopTest();
    }
    
    static testmethod void CSS_OtherClaimables_method16()
    {
        //public List<ttmlWrapperClass> listTTMLWrapper {get; set;}	
        List<CSS_OtherClaimablesController_RO.ttmlWrapperClass> twarp1= new List<CSS_OtherClaimablesController_RO.ttmlWrapperClass>();
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(123,null,'String','String','4','6','7','8','String','String','String',true,true,true,true,true,null,'String',1.0,'5',2.0,'string',true,'6','2',true, null, true,'string');
        twarp1.add(twrap);
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Dealer Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=false;
        insert du;
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        
        
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.css_coveragetype__c='OTH';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Css_Estimate__c=false;
        partsoption.selected_part__c=true;
        partsoption.Type__c='Select One';  
        partsoption.Days__c=1.0;
        partsoption.Sell_Price__c = 62;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=true;
        partsoption1.selected_part__c=true;
        partsoption1.Type__c='Towing';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 12234522;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c = 61;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=false;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.selectedRemoveRow=1;
        otherclaim.twoerrormsg=true;
        otherclaim.errorDisplay1=false;
        otherclaim.selectedType='Unlisted';
        otherclaim.getOCData();
        otherclaim.removingTTMLRow();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.listTTMLWrapper=twarp1;
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        otherclaim.saveTTMLPopup();
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        
        test.stopTest();
    }
    
    static testmethod void CSS_OtherClaimables_method17()
    {
        test.startTest();
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp1.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        
        CSS_Parts_Options__c po=css_testdata.createParts(false,jo.id,solcomp.id,null);
        po.Quantity__c=22.9;
        insert po;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        //List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=true;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.selectedRemoveRow=0;
    //   otherclaim.getOCData();
        otherclaim.removingTTMLRow();
        otherclaim.SendOtherClaimablestoERP();
        
    //    otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        
        
        if(joevt1!=null)
            otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
     //   otherclaim.getTTMLType();
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
  //      otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
    //    otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
    //    otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        test.stopTest();
        
    }
     
    static testmethod void CSS_OtherClaimables_method18()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Dealer Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=true;
        insert du;
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        
        
        
        
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        List<CSS_Parts_Options__c> prtlst1 = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtobj1 = new CSS_Parts_Options__c();
        prtobj1.css_estimate__c = false;
        prtobj1.selected_part__c = true;
        prtobj1.Type__c = 'commercial-travel';
        insert prtobj1;
        prtlst1.add(prtobj1);
        otherclaim.typeListChangeforDealer();
        List<CSS_Parts_Options__c> prtlst2 = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtobj2 = new CSS_Parts_Options__c();
        prtobj2.css_estimate__c = false;
        prtobj2.selected_part__c = true;
        prtobj2.Type__c = 'Non Commercial-Travel';
        insert prtobj2;
        prtlst1.add(prtobj2);
        CSS_OtherClaimablesController_RO otherclaim1 = new CSS_OtherClaimablesController_RO();
        otherclaim1.typeListChangeforDealer();
        List<CSS_Parts_Options__c> prtlst3 = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtobj3 = new CSS_Parts_Options__c();
        prtobj3.css_estimate__c = false;
        prtobj3.selected_part__c = true;
        prtobj3.Type__c = 'Meals';
        insert prtobj3;
        prtlst1.add(prtobj3);
        CSS_OtherClaimablesController_RO otherclaim2 = new CSS_OtherClaimablesController_RO();
        otherclaim2.typeListChangeforDealer();
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        // otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        
        otherclaim.redirectToWarranty();
        
        test.stopTest();
    }
    
    static testmethod void CSS_OtherClaimables_method19()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Dealer Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=true;
        insert du;
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        Id wid = apexpages.currentPage().getparameters().put('id',JO.Id); 
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solobj = new CSS_Solution_Component__c();
        solobj.Service_Job__c = wid;
        solobj.Selected_Component__c = true;
        //solobj.Fail_Code__c  = 'Testing';
        solobj.Fail_Code_Editable__c ='Testing';
        solobj.AccountCode__c= 'Testing';
        solobj.AccountCodeType__c = 'Test';
        solobj.AccountCodeEdit__c = 'Data';
        solobj.CSS_CoverageType__c = 'Testing';
        solobj.Type__c = 'Commercial-Travel';
        solobj.CoveredTravelBaseFareAmt__c = '1000';
        solobj.CoveredTravelLabor__c = '1000';
        insert solobj;
        solsComp.add(solobj);
        system.debug('list data'+solsComp);
        
        //Rupesh
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        //CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp1.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        //List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Css_Estimate__c=false;
        partsoption.selected_part__c=true;
        partsoption.Type__c='Lodging';  
        partsoption.Days__c=1.0;
        partsoption.Sell_Price__c = 89;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        //selectedCustPartsList.add(partsoption);
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=false;
        partsoption1.selected_part__c=true;
        partsoption1.Type__c='Commercial-Travel';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.css_estimate__c=false;
        partsoption1.selected_part__c=true;
        partsoption1.Sell_Price__c = 88;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=true;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.selectedRemoveRow=1;
        otherclaim.twoerrormsg=true;
        otherclaim.errorDisplay1=true;
        otherclaim.selectedType='Unlisted';
        
        test.startTest();
        otherclaim.fetchfailCodeValuesNew('Commercial-Travel');
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        //   otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();        
        test.stopTest();
    }
    
    static testmethod void Dealer_fetchfailCodeValuesNewmethod()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Dealer Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=false;
        insert du;
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        Id wid = apexpages.currentPage().getparameters().put('id',JO.Id); 
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solobj = new CSS_Solution_Component__c();
        solobj.Service_Job__c = wid;
        solobj.Selected_Component__c = true;
        //solobj.Fail_Code__c  = 'Testing';
        solobj.Fail_Code_Editable__c ='Testing';
        solobj.AccountCode__c= 'Testing';
        solobj.AccountCodeType__c = 'Test';
        solobj.AccountCodeEdit__c = 'Data';
        solobj.CSS_CoverageType__c = 'Testing';
        solobj.Type__c = 'Commercial-Travel';
        solobj.CoveredTravelBaseFareAmt__c = '1000';
        solobj.CoveredTravelLabor__c = '1000';
        insert solobj;
        solsComp.add(solobj);
        system.debug('list data'+solsComp);
        
        //Rupesh
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        //CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        //solcomp1.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        //List<CSS_Parts_Options__c> selectedCustPartsList = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Css_Estimate__c=false;
        partsoption.selected_part__c=true;
        partsoption.Type__c='Lodging';  
        partsoption.Days__c=1.0;
        partsoption.Sell_Price__c = 78;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        //selectedCustPartsList.add(partsoption);
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Css_Estimate__c=false;
        partsoption1.selected_part__c=true;
        partsoption1.Type__c='Commercial-Travel';  
        partsoption1.Days__c=1.0;
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.css_estimate__c=false;
        partsoption1.selected_part__c=true;
        partsoption1.Sell_Price__c = 77;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.selectedEstimate=true;
        otherclaim.SelectedItem='Unlisted';
        otherclaim.selectedRemoveRow=1;
        otherclaim.twoerrormsg=true;
        otherclaim.errorDisplay1=true;
        otherclaim.selectedType='Unlisted';
        
        test.startTest();
        otherclaim.fetchfailCodeValuesNew('Commercial-Travel');
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        otherclaim.removingRow();
        //      otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();        
        test.stopTest();
        
        
    }*/
    
    /*static testmethod void Dstr_redirectToWarrantymethod()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.type='Distributor Account';
        acc.CSS_DistributorCode__c='03742';
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=false;
        insert du;
        
        insert acc;
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        otherclaim.redirectToWarranty();
        
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        
        otherclaim.onChangeofAccountCode();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(true);
        otherclaim.AddRow();
        otherclaim.saveTTMLPopup();
        
        otherclaim.removingRow();
        //    otherclaim.saveOtherClaimables();
        otherclaim.removingTTMLRow();
        otherclaim.saveTTMLParts();
        otherclaim.addTTMLRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        
        test.stopTest();
    }*/
    
    /*static testmethod void ExceptionCover_method()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        
        
        acc.type='Dealer Account';
        
        insert acc;
        
        css_header_nav__c du=new css_header_nav__c();
        du.RSWButtonEnable__c=true;
        insert du;
        
        
        
        string location = [select id,location__c from account where id=:acc.id].location__c;
        system.debug('location***'+location);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser4@testorg.com',User_Location__c = '03742-03742');
        insert u;
        
        CSS_UserLocation__c userLocation = new CSS_UserLocation__c (AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=u.Id,Location_code__c='03742-03742');
        insert userLocation;
        
        CSS_JobEventTemporary__c jetmp=css_testdata.createJobEventTempObj(true);
        
        CSS_JobEventTemporary__c joevt1=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='OtherClaimables' limit 1];
        CSS_JobEventTemporary__c joevt2=[select id,Key__c,Reason__c from CSS_JobEventTemporary__c where Key__c='TTML' limit 1];
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        //jo.id=null;
        JO.Account__c=acc.id;
        JO.Additional_Tech1__c=u.id;
        JO.Additional_Tech2__c=u.id;
        JO.Additional_Tech3__c=u.id;
        JO.Additional_Tech4__c=u.id;
        JO.Additional_Tech5__c=u.id;
        JO.Additional_Tech6__c=u.id;
        JO.Additional_Tech7__c=u.id;
        update JO;
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c=false;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        insert solcomp;
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = '67';
        solcomp.Selected_Component__c=false;
        solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        insert solcomp1;
        CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
        solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp3.CoveredPartsQty__c = '100';
        solcomp3.AccountCode__c     = '67';
        solcomp.Selected_Component__c=false;
        solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp3.CoveredOCAmount__c = '9999999';
        solcomp3.Service_Job__c=jo.Id;
        solcomp3.Solutions__c=sol.Id;
        solcomp3.CampaignOCPercentage__c='78';
        insert solcomp3;
        CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
        solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp4.CoveredPartsQty__c = '1';
        solcomp4.AccountCode__c     = '67';
        solcomp.Selected_Component__c=false;
        solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp4.CampaignOCPercentage__c='78';
        solcomp4.CoveredOCAmount__c = '100';
        solcomp4.Service_Job__c=jo.Id;
        solcomp4.Solutions__c=sol.Id;
        insert solcomp4;
        lstsolcomp.add(solcomp);
        lstsolcomp.add(solcomp1);
        
        
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Type__c='Meals'; 
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Sell_Price__c = 71;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;
        
        CSS_Parts_Options__c partsoption1 = new CSS_Parts_Options__c();
        partsoption1.quantity__c = 100;
        partsoption1.RecordTypeId = recTypeIdpart1;
        partsoption1.Item__c = 'Select One';
        partsoption1.Covered__c = 100;
        partsoption1.Amount__c = 122;
        partsoption1.Type__c='Commercial-Travel'; 
        partsoption1.Fail_Code__c = 'test';
        partsoption1.Account_Code__c = 'test';
        partsoption1.Part_Description__c = 'test-PD';
        partsoption1.Service_Job__c = JO.id;
        partsoption1.Sell_Price__c = 70;
        partsoption1.Unit_Price__c = '199';
        partsoption1.Unit_Price_Local_Currency__c = 120;
        partsoption1.ExpenseTotal__c = 300;
        partsoption1.Exchange_Rate_Version__c = 2;
        insert partsoption1;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        List<CSS_Parts_Options__c> prtlst1 = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtobj1 = new CSS_Parts_Options__c();
        prtobj1.css_estimate__c = false;
        prtobj1.selected_part__c = true;
        prtobj1.Type__c = 'commercial-travel';
        insert prtobj1;
        prtlst1.add(prtobj1);
        //insert prtlst1;
        
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        
        otherclaim.typeListChangeforDealer();
        
        
        List<CSS_Parts_Options__c> prtlst2 = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtobj2 = new CSS_Parts_Options__c();
        prtobj2.css_estimate__c = false;
        prtobj2.selected_part__c = true;
        prtobj2.Type__c = 'Non Commercial-Travel';
        insert prtobj2;
        prtlst1.add(prtobj2);
        
        CSS_OtherClaimablesController_RO otherclaim1 = new CSS_OtherClaimablesController_RO();
        
        otherclaim1.typeListChangeforDealer();
        
        List<CSS_Parts_Options__c> prtlst3 = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c prtobj3 = new CSS_Parts_Options__c();
        prtobj3.css_estimate__c = false;
        prtobj3.selected_part__c = true;
        prtobj3.Type__c = 'Meals';
        insert prtobj3;
        prtlst1.add(prtobj3);
        
        CSS_OtherClaimablesController_RO otherclaim2 = new CSS_OtherClaimablesController_RO();
        
        otherclaim2.typeListChangeforDealer();
        
        string accountcode =  otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode =   otherclaim.SelectedFailCode = 'Select One';
        Integer selctedpartid =   otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 =   otherclaim.assignedParts = 1;
        otherclaim.SelectedItem='Misc Name';
        otherclaim.getTechnicians();
        
        otherclaim.saveOtherClaimablesPopup();
        otherclaim.onChangeofItem();
        otherclaim.onChangeofEstimate();
        otherclaim.SendOtherClaimablestoERP();
        otherclaim.getTTMLType();
        
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeforDealer();
        otherclaim.typeListChangeNewttmlacc();
        
        otherclaim.getOCData();
        otherclaim.SendOtherClaimablestoERP();
        
        
        otherclaim.getOCData();
        otherclaim.getfailcodeDropDown();
        otherclaim.getTechnicians();
        otherclaim.typeListChange();
        
        otherclaim.getallCustomPartsData(false);
        otherclaim.AddRow();
        otherclaim.closePopUp();
        otherclaim.displayPopUp();
        otherclaim.deleteParts();
        
        //     otherclaim.saveOtherClaimables();
        
        otherclaim.saveTTMLPopup();
        otherclaim.typeListChange();
        otherclaim.getAccCodesonChngofFailCode();
        otherclaim.deleteTTMLParts();
        otherclaim.calculateExpTotal();
        otherclaim.populateAmountValue();
        otherclaim.getDLRTTMLType();
        otherclaim.getExpenseTotal();
        otherclaim.getfailCodeValues();
        otherclaim.typeListChangeNewttmlacc();
        
        otherclaim.saveTTMLParts();
        
        test.stopTest();
        
        
    }
    
    static testmethod void TestOnfetchAccountCodeValue1()
    {
        
       
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        
        css_job_order__c jo = new css_job_order__c();
        jo.Account__c = acc.id;
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        
        
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        insert sol;
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.Service_Job__c=jo.Id;
        solcomp.AccountCode__c='';
        solcomp.AccountCodeEdit__c = 'testing';
        solcomp.Solutions__c=sol.id;
        solcomp.Selected_Component__c=true;
        solcomp.Fail_Code_Editable__c='Testing';
        solcomp.CSS_CoverageType__c = 'OTH';
        insert solcomp;
        
        CSS_JobEventTemporary__c JET1 = new CSS_JobEventTemporary__c();
        JET1.Attribute1__c = 'POL';
        JET1.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET1.Attribute3__c = 'ZK';
        JET1.key__c = 'AccountCodes';
        insert JET1;
        
        Test.startTest();
        
        ApexPages.CurrentPage().getParameters().put('id',jo.Id);
        
        CSS_OtherClaimablesController_RO obj = new CSS_OtherClaimablesController_RO();
        obj.fetchAccCodeValues('Commercial-Travel','Testing');
        Test.stopTest();
    }
    
    static testmethod void TestOnfetchAccountCodeValue2()
    {
        
       
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
         css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        jo.Account__c = acc.id;
        insert jo;
        
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        insert claims;
        
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        insert sol;
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.Service_Job__c=jo.Id;
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.AccountCode__c='Testing';
        solcomp.Solutions__c=sol.id;
        solcomp.Selected_Component__c=true;
        solcomp.Fail_Code_Editable__c='Testing';
        solcomp.Type__c = 'Commercial-Travel';
        solcomp.CampaignTravelPercentage__c = '100';
        solcomp.CSS_CoverageType__c = '';
        solcomp.CoveredTravelLabor__c='10';
        solcomp.CoveredTravelBaseFareAmt__c = '10';
        insert solcomp;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',jo.Id);
        CSS_OtherClaimablesController_RO obj = new CSS_OtherClaimablesController_RO();
        obj.fetchAccCodeValues('Commercial-Travel','Testing');
        Test.stopTest();
    }
    
    static testmethod void TestOnfetchAccountCodeValue3()
    {
        
        
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        jo.Account__c = acc.id;
        insert jo;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        insert claims;
        
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        insert sol;
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.Service_Job__c=jo.Id;
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.AccountCode__c='Testing';
        solcomp.Solutions__c=sol.id;
        solcomp.Selected_Component__c=true;
        solcomp.Fail_Code_Editable__c='Testing';
        solcomp.Type__c = 'Non Commercial-Travel';
        solcomp.CampaignTravelPercentage__c = '100';
        solcomp.CSS_CoverageType__c = '';
        solcomp.CoveredTravelLabor__c='10';
        solcomp.CoveredTravelMiles__c = '10';
        insert solcomp;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',jo.Id);
        CSS_OtherClaimablesController_RO obj = new CSS_OtherClaimablesController_RO();
        obj.fetchAccCodeValues('Non Commercial-Travel','Testing');
        Test.stopTest();
    }
    
    static testmethod void TestOnfetchAccountCodeValue4()
    {
        
        
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        jo.Account__c = acc.id;
        insert jo;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='TestUser';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        insert claims;
        
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        insert sol;
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.Service_Job__c=jo.Id;
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.AccountCode__c='';
        solcomp.AccountCodeEdit__c = 'testing';
        solcomp.Solutions__c=sol.id;
        solcomp.Selected_Component__c=true;
        solcomp.Fail_Code_Editable__c='Testing';
        solcomp.Type__c = 'Towing';
        solcomp.CampaignTravelPercentage__c = '100';
        solcomp.CSS_CoverageType__c = '';
        solcomp.CoveredTowingMiles__c='10';
        insert solcomp;
        
        CSS_JobEventTemporary__c JET1 = new CSS_JobEventTemporary__c();
        JET1.Attribute1__c = 'POL';
        JET1.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET1.Attribute3__c = 'ZK';
        JET1.key__c = 'AccountCodes';
        insert JET1;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',jo.Id);
        CSS_OtherClaimablesController_RO obj = new CSS_OtherClaimablesController_RO();
        obj.fetchAccCodeValues('Towing','Testing');
        Test.stopTest();
     }
    
    static testmethod void CSS_OtherClaimables_method20()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        update JO;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.Type__c = null;
        solcomp.CoveredTowingMiles__c = '10';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c=true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp.CSS_CoverageType__c = 'RRW';
        solcomp.CoveredTravelBaseFareAmt__c = '10';
        solcomp.CoveredTravelLabor__c = '10';
        lstsolcomp.add(solcomp);
        
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp1.Type__c = null;
        solcomp1.CoveredTowingMiles__c = '10';
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = 'DC';
        solcomp1.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp1.Selected_Component__c=true;
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp1.CSS_CoverageType__c = 'POL';
        solcomp1.CoveredTravelBaseFareAmt__c = '10';
        solcomp1.CoveredTravelLabor__c = '10';
        lstsolcomp.add(solcomp1);
        
        insert lstsolcomp;
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Type__c='Meals'; 
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Sell_Price__c = 99;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;

        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        test.startTest();
        
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode = otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode = otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid = otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 = otherclaim.assignedParts = 1;
        otherclaim.SelectedItem = 'TOWING';
        otherclaim.getfailcodeDropDownBasedOnItem('TOWING',1);
        otherclaim.fetchfailCodeValuesNew('TOWING');
        otherclaim.fetchAccCodeValues('TOWING','Intake Manifold Pressure/Temperature Sensor-EEBT');
        
        CSS_OtherClaimablesController_RO otherclaim1 = new CSS_OtherClaimablesController_RO();
        string accountcode1 = otherclaim1.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode1 =  otherclaim1.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid2 = otherclaim1.SelectedPartID = 1;
        Integer selctedpartid3 = otherclaim1.assignedParts = 1;
        otherclaim1.SelectedItem = 'COMMERCIAL TRAVEL';
        otherclaim1.getfailcodeDropDownBasedOnItem('COMMERCIAL TRAVEL',1);
        otherclaim1.fetchfailCodeValuesNew('COMMERCIAL TRAVEL');
        otherclaim1.fetchAccCodeValues('COMMERCIAL TRAVEL','Intake Manifold Pressure/Temperature Sensor-EEBT');
        test.stopTest();
        
    }
    
    static testmethod void CSS_OtherClaimables_method21()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        update JO;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.Type__c = 'TRP';
        solcomp.CampaignTravelPercentage__c = '10';
        solcomp.CampaignTowingPercentage__c ='10';
        solcomp.Performed_review__c=true;
        solcomp.CoveredTowingMiles__c = '10';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c=true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp.CSS_CoverageType__c = 'RRW';
        solcomp.CoveredTravelBaseFareAmt__c = '10';
        solcomp.CoveredTravelLabor__c = '10';
        lstsolcomp.add(solcomp);
        
        CSS_Solution_Component__c solcomp1 = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp1.Type__c = 'TRP';
        solcomp1.Performed_review__c=true;
        solcomp1.CampaignTravelPercentage__c = '10';
       solcomp1.CampaignTowingPercentage__c ='10';
        solcomp1.CoveredTowingMiles__c = '10';
        solcomp1.CoveredPartsQty__c = '100';
        solcomp1.AccountCode__c     = 'DC';
        solcomp1.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp1.Selected_Component__c=true;
        solcomp1.CoveredOCAmount__c = '9999999';
        solcomp1.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp1.CSS_CoverageType__c = 'POL';
        solcomp1.CoveredTravelBaseFareAmt__c = '10';
        solcomp1.CoveredTravelLabor__c = '10';
        lstsolcomp.add(solcomp1);
        
        insert lstsolcomp;
        
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        Id recTypeIdpart1 = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        
        CSS_Parts_Options__c partsoption = new CSS_Parts_Options__c();
        partsoption.quantity__c = 100;
        partsoption.Item__c = 'Select One';
        partsoption.Covered__c = 100;
        partsoption.RecordTypeId = recTypeIdpart;
        partsoption.Amount__c = 122;
        partsoption.Fail_Code__c = 'test';
        partsoption.Type__c='Meals'; 
        partsoption.Account_Code__c = 'test';
        partsoption.Part_Description__c = 'test-PD';
        partsoption.Service_Job__c = JO.id;
        partsoption.Sell_Price__c = 99;
        partsoption.Unit_Price__c = '199';
        partsoption.Unit_Price_Local_Currency__c = 120;
        partsoption.ExpenseTotal__c = 300;
        partsoption.Exchange_Rate_Version__c = 2;
        insert partsoption;

        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        test.startTest();
        
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        string accountcode = otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode = otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid = otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 = otherclaim.assignedParts = 1;
        otherclaim.SelectedItem = 'TOWING';
        otherclaim.getfailcodeDropDownBasedOnItem('TOWING',1);
        otherclaim.fetchfailCodeValuesNew('TOWING');
        otherclaim.fetchAccCodeValues('TOWING','Intake Manifold Pressure/Temperature Sensor-EEBT');
        
        CSS_OtherClaimablesController_RO otherclaim1 = new CSS_OtherClaimablesController_RO();
        string accountcode1 = otherclaim1.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode1 =  otherclaim1.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid2 = otherclaim1.SelectedPartID = 1;
        Integer selctedpartid3 = otherclaim1.assignedParts = 1;
        otherclaim1.SelectedItem = 'COMMERCIAL TRAVEL';
        otherclaim1.getfailcodeDropDownBasedOnItem('COMMERCIAL TRAVEL',1);
        otherclaim1.fetchfailCodeValuesNew('COMMERCIAL TRAVEL');
        otherclaim1.fetchAccCodeValues('COMMERCIAL TRAVEL','Intake Manifold Pressure/Temperature Sensor-EEBT');
        test.stopTest();
        
    }*/
    
    static testmethod void ExpTotalTestMEthod1()
    {
        
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        Jo.CSS_Travel_Rate__c = '10';
        update JO;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        List<CSS_OtherClaimablesController_RO.ttmlWrapperClass> listTTMLWrapper = new  List<CSS_OtherClaimablesController_RO.ttmlWrapperClass>();
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap1=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Meals','String','String','String','String','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','10',true, null, true,'string');
        listTTMLWrapper.add(twrap1);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap2=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Meals','String','String','String','String','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','99999',true, null, true,'string');
        listTTMLWrapper.add(twrap2);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap3=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Lodging','String','String','String','String','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','10',true, null, true,'string');
        listTTMLWrapper.add(twrap3);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap4=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Lodging','String','String','String','String','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','99999',true, null, true,'string');
        listTTMLWrapper.add(twrap4);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap5=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Towing','String','String','String','String','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','10',true, null, true,'string');
        listTTMLWrapper.add(twrap5);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap6=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Towing','String','String','String','String','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','99999',true, null, true,'string');
        listTTMLWrapper.add(twrap6);
        
        /*CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap7=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Commercial-Travel','String','String','String','String','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','10',true, null, true,'string');
        listTTMLWrapper.add(twrap7);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap8=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Commercial-Travel','String','String','String','String','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','1000000',true, null, true,'string');
        listTTMLWrapper.add(twrap8);*/
        
        
        
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        otherclaim.listTTMLWrapper = listTTMLWrapper;
        otherclaim.SelectedPartID = 1;
        otherclaim.calculateExpTotal();
        otherclaim.getExpenseTotal();
        test.stopTest();
        
        
    }
    
    static testmethod void ExpTotalTestMEthod2()
    {
        
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        Jo.CSS_Travel_Rate__c = '10';
        update JO;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        Test.setCurrentPage(pref);
        
        List<CSS_OtherClaimablesController_RO.ttmlWrapperClass> listTTMLWrapper = new  List<CSS_OtherClaimablesController_RO.ttmlWrapperClass>();
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap1=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Meals','String','String','String','10','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','10',true, null, true,'string');
        listTTMLWrapper.add(twrap1);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap2=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Meals','String','String','String','100000','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','99999',true, null, true,'string');
        listTTMLWrapper.add(twrap2);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap3=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Lodging','String','String','String','10','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','10',true, null, true,'string');
        listTTMLWrapper.add(twrap3);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap4=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Lodging','String','String','String','100000','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','99999',true, null, true,'string');
        listTTMLWrapper.add(twrap4);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap5=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Towing','String','String','String','10','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','10',true, null, true,'string');
        listTTMLWrapper.add(twrap5);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap6=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Towing','String','String','String','100000','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','99999',true, null, true,'string');
        listTTMLWrapper.add(twrap6);
        
        /*CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap7=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Commercial-Travel','String','String','10','String','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','10',true, null, true,'string');
        listTTMLWrapper.add(twrap7);
        
        CSS_OtherClaimablesController_RO.ttmlWrapperClass twrap8=new CSS_OtherClaimablesController_RO.ttmlWrapperClass(1,null,'String','Commercial-Travel','String','String','100000','String','String','String','String',true,true,true,true,true,null,'String',1.0,'String',2.0,'string',true,'10','1000000',true, null, true,'string');
        listTTMLWrapper.add(twrap8);*/
        
        
        test.startTest();
        CSS_OtherClaimablesController_RO otherclaim = new CSS_OtherClaimablesController_RO();
        otherclaim.listTTMLWrapper = listTTMLWrapper;
        otherclaim.SelectedPartID = 2;
        otherclaim.calculateExpTotal();
        otherclaim.getExpenseTotal();
        test.stopTest();
        
        
    }
    
    
}