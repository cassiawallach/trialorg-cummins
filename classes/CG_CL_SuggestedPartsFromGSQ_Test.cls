@isTest
public class CG_CL_SuggestedPartsFromGSQ_Test 
{
    public static testmethod void CG_CL_SuggestedPartsFromGSQ_method()
    {
        /*Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Dealer_Technician'];
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com', User_Location__c='123456');
        insert objUser1;
        string uid = UserInfo.getUserId();
        Id profileId=userinfo.getProfileId();
           // String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        //String userRole = CSS_ServiceJobControllerTechnician.getlstUserbyRole();
       // UserRole urRole = new UserRole();
        //urRole.name='Factory';
        //insert urRole;*/
        
    Id recordtyid=Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
    ID pgid1=ApexPages.CurrentPage().getParameters().put('id',Jo.id);
    CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.ID);
    sol.Diagnostic_Response__c='Most likely the solution';
        sol.Service_Job__c=pgid1;
        system.debug('sol.Service_Job__c......'+sol.Service_Job__c);
         //system.debug('sol.size().....'+sol.size());
       
       //sol.Service_Job__c=pgid1;
          List<CSS_Solutions__c> css=new  List<CSS_Solutions__c>();
    CSS_getPartsListSRTRequestJ2A abc=new CSS_getPartsListSRTRequestJ2A();
    css.add(sol);
       /* list<CSS_Solution_Component__c> lstSolComp1 = new list<CSS_Solution_Component__c>();
    CSS_Solution_Component__c solCom = CSS_TestData.createSRT(false,JO.ID,sol.id);
        solCom.Service_Job__c = JO.id;
        solCom.AccountCodeEdit__c = 'ACCount';
        solCom.CoveredOCAmount__c = '2';
        solCom.CoveredPartsQty__c = '2';
        solCom.name = 'solcomp';
            //insert solCom;
        lstSolComp1.add(solCom);
        upsert solCom;
        system.debug('solcomp'+solCom);*/
        css_claims__c cs = new css_claims__c();
        insert cs;
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
         //CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
         //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
         CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
       //AddsolComp.CSS_Claims__c = cs.id;
        AddsolComp.Service_Job__c = JO.id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.CoveredOCAmount__c = '100';
        //AddsolComp.Solutions__c = solAdd;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        //AddsolComp.
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
         AddsolComp.Charlength__c = true;
        insert AddsolComp;
        //Addsolcomp.Part_Assignment__c ='Primary';
        //AddsolComp.Fail_Code__c ='Test-FAilcode';
      //  AddsolComp.FailCode_Formula__c = 'Test-FailCode';   Field is not writeable
       
        CSS_Solution_Component__c solcomp =new CSS_Solution_Component__c();
         solcomp.CoveredPartsQty__c = '100';
         solcomp.Service_Job__c=JO.id;
         solcomp.AccountCode__c = '08';
         solcomp.CoveredOCAmount__c = '100';
        
         solcomp.AccountCodeType__c='NOW';
         solcomp.AccountCodeEdit__c = 'NOW 08';
         solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
         solcomp.CoveredOCAmount__c = '9999';
         solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
          solcomp.Failure_Mode__c='Wtest1';
          solcomp.Component_Code__c='AC';
            solcomp.System_Code__c='WE';
         insert solcomp;
        system.debug('AccFormula'+solcomp.CSS_Account_Formula__c+''+'FailCode_Formula__c'+solcomp.FailCode_Formula__c);
        //lstsolcomp.add(solcomp);
          CSS_Solution_Component__c solcomp1 = new CSS_Solution_Component__c();//CSS_TestData.createSRT(false,JO.Id,sol.Id);
         solcomp1.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
         solcomp1.CoveredPartsQty__c = '100';
        solcomp1.CoveredOCAmount__c = '100';
        solcomp1.Service_Job__c=JO.id;
         solcomp1.AccountCode__c  = '67';
         solcomp1.AccountCodeEdit__c='Customized Assurance Plan DC';
         solcomp1.AccountCodeType__c = 'NEW-New Engine Warranty';
         solcomp1.CoveredOCAmount__c = '9999999';
         solcomp1.Fail_Code_Editable__c = 'Electrical Connector-EUCN';
        solcomp1.Failure_Mode__c='Wtest2';
          solcomp1.Component_Code__c='AC';
            solcomp1.System_Code__c='TH';
         insert solcomp1;
        system.debug('solcomp1...'+solcomp1);
        system.debug('AccFormula'+solcomp1.CSS_Account_Formula__c+''+'FailCode_Formula__c'+solcomp1.FailCode_Formula__c);
         CSS_Solution_Component__c solcomp3 = new CSS_Solution_Component__c();
         solcomp3.AccountCodeEdit__c='Customized Assurance Plan DC';
         solcomp3.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
         solcomp3.CoveredPartsQty__c = '100';
         solcomp3.CoveredOCAmount__c = '100';
        solcomp3.Service_Job__c=JO.id;
         solcomp3.AccountCode__c     = '67';
         solcomp3.AccountCodeType__c = 'NEW-New Engine Warranty';
         solcomp3.CoveredOCAmount__c = '9999999';
         solcomp3.Service_Job__c=jo.Id;
         solcomp3.Solutions__c=sol.Id;
         insert solcomp3;
        system.debug('AccFormula'+solcomp3.CSS_Account_Formula__c+''+'FailCode_Formula__c'+solcomp3.FailCode_Formula__c);
        //lstsolcomp.add(solcomp3);
            CSS_Solution_Component__c solcomp4 = new CSS_Solution_Component__c();
         solcomp4.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp4.CoveredOCAmount__c = '100';
         solcomp4.Fail_Code_Editable__c='Intake Manifold Pressure/Temperature Sensor-EEBT';
         solcomp4.CoveredPartsQty__c = '1';
        solcomp4.Service_Job__c=JO.id;
         //solcomp4.AccountCode__c     = '70';
         //solcomp4.AccountCodeType__c = 'NEW-New Engine Warranty';
         solcomp4.CoveredOCAmount__c = '100';
         solcomp4.Service_Job__c=jo.Id;
         solcomp4.Solutions__c=sol.Id;
        //solcomp4.System_Code__c = 'TH';
        //solcomp4.Component_Code__c = 'AC';
          insert solcomp4;
        system.debug('AccFormula'+solcomp4.CSS_Account_Formula__c+''+'FailCode_Formula__c'+solcomp4.FailCode_Formula__c);
        List<css_solution_component__c> lstsolcomp11 = new List<css_solution_component__c>();
        lstsolcomp11 = [select id, AccountCodeEdit__c,CSS_Account_Formula__c,FailCode_Formula__c from css_solution_component__c where id=:solcomp4.id];
        system.debug('AccFormula11'+lstsolcomp11[0].CSS_Account_Formula__c+''+'FailCode_Formula__c11'+lstsolcomp11[0].FailCode_Formula__c);
        /*CSS_Solution_Component__c solcomp5 = new CSS_Solution_Component__c();
        AccountCode__c 
        AccountCodeType__c
        AccountCodeEdit__c
            System_Code__c
            Component_Code__c
            Failure_Mode__c*/
      
         lstsolcomp.add(solcomp);
         lstsolcomp.add(solcomp1);
         lstsolcomp.add(solcomp3);
        lstsolcomp.add(solcomp4);
        lstsolcomp.add(AddsolComp);
        System.debug('lstsolcomp...........'+ lstsolcomp);
        system.debug('lstsolcomp.size().....'+lstsolcomp.size());
        CG_CL_SuggestedPartsFromGSQ ss1 = new CG_CL_SuggestedPartsFromGSQ();
        ss1.SelectedPartID = 1;
        ss1.selectedPartRowCount = 1;
        
        ss1.servicePartNumber = 'one';
        List<SelectOption> accCodes1 = new List<SelectOption>();
        accCodes1.add(new SelectOption('01', 'Jan'));
        accCodes1.add(new SelectOption('02', 'Feb'));
        //srtParts.srtpartsErrorMsg = 'Bad request';
        ss1.accCodes = accCodes1;
        ss1.accountCodelistN('ReCon Policy','9','wer');
        
       CSS_Claims__c claim = new CSS_Claims__c();
       claim.Email_Address__c = 'Pashanthi.G@cummins.com';
        claim.CSS_Job__c=jo.Id;
        claim.Country__c='CA';
        claim.State__c='US';
        insert claim;
    CSS_Parts_Options__c partsOption1 = new CSS_Parts_Options__c();
                partsOption1.Amount__c=11;
                partsOption1.City__c='test';
                partsOption1.Comments__c='test';
               // partsOption1.CSS_Claims__c = claim.Id;
                partsOption1.Solutions__c = sol.id;
                partsOption1.Service_Job__c=JO.id;
                partsOption1.FailurepartId__c = solcomp4.id;
                partsOption1.Part_Assignment__c='Primary';
                //insert partsOption1;
     List<CSS_JobEventTemporary__c> lstjobeventemp = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobeventemp = new CSS_JobEventTemporary__c();
        jobeventemp.Effect__c ='qwert';
        jobeventemp.Reason__c = 'falut code issue';
        jobeventemp.Fault_Code_Description__c = 'qwerty';
        jobeventemp.Active__c  = true;
       jobeventemp.Attribute1__c='OTH';
       jobeventemp.Attribute2__c='test';
         jobeventemp.Attribute3__c='test1';
         jobeventemp.Attribute5__c='test2';
          jobeventemp.Key__c = 'AccountCodes';
        insert jobeventemp;
        CSS_JobEventTemporary__c jobeventemp1 = new CSS_JobEventTemporary__c();
        jobeventemp1.Effect__c ='qwert';
        jobeventemp1.Reason__c = 'falut code issue';
        jobeventemp1.Fault_Code_Description__c = 'qwerty';
        jobeventemp1.Active__c  = true;
       jobeventemp1.Attribute1__c='POL';
        insert jobeventemp1;
        
        lstjobeventemp.add(jobeventemp);
         lstjobeventemp.add(jobeventemp1);
        System.debug('lstjobeventemp'+lstjobeventemp.size());
         ID pageId = ApexPages.CurrentPage().getParameters().get('id');
    ID pgId = ApexPages.CurrentPage().getParameters().put(JO.Id,'id');
    
    list<CSS_Parts_Options__c> pOptions = new list<CSS_Parts_Options__c>();
    CSS_Parts_Options__c partop = new CSS_Parts_Options__c();
     partop.RecordTypeId=recordtyid;
        partop.Quantity__c=2.0;
        partop.Solutions__c = sol.Id;
       // partop.Service_partnumber__c='540571400';
        partop.Service_partnumber__c='2';
        partop.Part_Name__c='KIT,SERVICE';
        partop.Sell_Price__c=1.0;
        partop.Replacement_Reason__c='';
        partop.Notes__c='';
        partop.OEM__c='';
        partop.selected_part__c=true;
        partop.ReturnToFactory__c='';
        partop.Covered__c=2.0;
        partop.Fail_Code__c='';
        partop.Account_Code__c='';
    partop.Amount__c=11;
    partop.City__c='test';
    partop.Comments__c='test';
    partop.RecordTypeId=recordtyid;
    partop.Service_Job__c= pageId;
    pOptions.add(partop);
        pOptions.add(partsOption1);
    insert pOptions;
        
          PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        
        
        List<selectOption> accCodes = new List<selectOption>();
        List<CG_CL_SuggestedPartsFromGSQ.srtPartWrapper> lstsrtpartwrap = new List<CG_CL_SuggestedPartsFromGSQ.srtPartWrapper>();
        List<CG_CL_SuggestedPartsFromGSQ.srtCompWrapper> lstsrtcompwrap = new List<CG_CL_SuggestedPartsFromGSQ.srtCompWrapper>();
        List<CG_CL_SuggestedPartsFromGSQ.srtsolWrapper> lstsrtsompwrap = new List<CG_CL_SuggestedPartsFromGSQ.srtsolWrapper>();
        CG_CL_SuggestedPartsFromGSQ.srtsolWrapper srtsolwrap = new CG_CL_SuggestedPartsFromGSQ.srtsolWrapper(sol.Id,'solName','solTitle',lstsrtcompwrap,1,11,sol.id,'parentSolname');
        lstsrtsompwrap.add(srtsolwrap);
        CG_CL_SuggestedPartsFromGSQ.srtCompWrapper srtcompwrap = new CG_CL_SuggestedPartsFromGSQ.srtCompWrapper(solcomp.Id,'compname','solname','soltitle','failcode','failcodeedit','acc-code','acc-code edit',lstsrtpartwrap,1);
        lstsrtcompwrap.add(srtcompwrap);
        system.debug('lstsrtcompwrap.....'+lstsrtcompwrap);
        
        CG_CL_SuggestedPartsFromGSQ.srtPartWrapper srtpartwrap = new CG_CL_SuggestedPartsFromGSQ.srtPartWrapper(1,partop.Id,solcomp.Id,true,true,'1','part-name','partdesc','2','acc-code','return to fac','option-num',1,'part-size','replacement reason','notes','oem',accCodes,'failcode');
    lstsrtpartwrap.add(srtpartwrap);
        
        css_repair_job  cssRep = new css_repair_job();
        CG_CL_SuggestedPartsFromGSQ GSQparts = new CG_CL_SuggestedPartsFromGSQ(cssRep);
        //CG_CL_SuggestedPartsFromGSQ aa = new CG_CL_SuggestedPartsFromGSQ();
        GSQparts.pgId = JO.id;
        GSQparts.SelectedAccountCode = 'Customized Assurance Plan DC';
        GSQparts.SelectedFailCode = 'THAC';
        GSQparts.compSolId=sol.id;
        GSQparts.serviceJob=JO;
        GSQparts.solutiondetails=css; 
        GSQparts.lstsrtPartWrapper=lstsrtpartwrap;
        GSQparts.listsrtCompWrapper=lstsrtcompwrap;
        GSQparts.listsrtsolWrapper=lstsrtsompwrap;
        GSQparts.listsrtsolWrapperDisp=lstsrtsompwrap;
        GSQparts.srtpartsErrorMsg='Test';
        GSQparts.displayPopup2=True;
        GSQparts.srtpb=True;
        map<Id,string> ss=new map<Id,string>();
        ss.put(null,'test');
        List<string> sss=new List<string>();
        sss.add('test');
        GSQparts.recTypeIdpart=null;
        GSQparts.failidmap=ss;
        GSQparts.solutionmap=ss;
        GSQparts.failids=sss;
        GSQparts.chkReqField=True;
        GSQparts.compSolId=null;
        GSQparts.partsList=pOptions;
        GSQparts.getAccountCodes();
        //GSQparts.accountCodelistN('cc','dd','ss');
        GSQparts.getAccountCodes();
        GSQparts.saveParts();
        GSQparts.getreplacementReasonOptions();
        //GSQparts.SelectedAccountCode = 'ALTER';
        GSQparts.SelectedPartID = 1;
        GSQparts.selectedPartRowCount = 1;
        GSQparts.servicePartNumber = 'one';
        GSQparts.SelectedAccountCode =lstsolcomp11[0].AccountCodeEdit__c;
         GSQparts.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        GSQparts.onChangeofAccountCode();
        GSQparts.getPartsList();
        GSQparts.SelectedAccountCode = 'Select One';
        GSQparts.servicePartNumber = '1';
           // GSQparts.selectedPartRowCount = 1;
        GSQparts.onChangeofAccountCode();
        //CG_CL_SuggestedPartsFromGSQ cpp = new CG_CL_SuggestedPartsFromGSQ();     
    }

}