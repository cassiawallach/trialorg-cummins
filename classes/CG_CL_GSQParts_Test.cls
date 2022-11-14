@isTest
public class CG_CL_GSQParts_Test {
    
    public static testmethod void CG_CL_GSQParts_Method(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Dealer Account';
        insert acc;
        
        List<CSS_Job_Order__c> lstjo = new List<CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.ESN__c = '79464646';
        jo.Account__c=acc.id;
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        insert jo;
        lstjo.add(jo);
        list<CSS_Claims__c> claimlst = new list<CSS_Claims__c>();
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Account__c = acc.id;
        claim.Email_Address__c = 'TestUser@cummins.com';
        claim.CSS_Job__c=jo.Id;
        claim.Country__c='CA';
        claim.State__c='US';
        insert claim;
       
        ApexPages.CurrentPage().getParameters().put('id',claim.Id);
        CSS_Claims__c claim1 = new CSS_Claims__c();
        claim1.Email_Address__c = 'TestUser@cummins.com';
        claim1.Account__c=acc.id;
        claim1.CSS_Job__c=jo.Id;
        claim1.Country__c='CA';
        claim1.State__c='US';
        insert claim1;
        claimlst.add(claim1);
        
        //ID pgId = ApexPages.CurrentPage().getParameters().put(JO.Id,'id');  
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;		
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        
        
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.Service_Job__c = Jo.id;
            solComp.CSS_Claims__c = claim.Id;
            solComp.Action__c = '';
            solComp.Type__c = 'Campaign';
            solComp.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp.CampaignPartsPercentage__c = '20';
            solcomp.Performed_Review__c = True;
            solcomp.Solutions__c = sol.Id;
            solcomp.Fail_Code_Editable__c='123';
            solcomp.AccountCode__c='SERVICE TOOL WARRANTY 52';
            solcomp.AccountCodeEdit__c='';
            solcomp.CoveredPartsQty__c='321';
            solcomp.System_Code__c = 'WE';
            solcomp.Component_Code__c = 'AC';
            //solcomp.Fail_Code__c='Intake Manifold Pressure/Temperature Sensor-WEAC';
            insert solComp;
            
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solComp1.Component_Id__c ='F0051001';
            solComp1.Service_Job__c = Jo.id;
            solComp1.CSS_Claims__c = claim.Id;
            solComp1.Action__c = '';
            solComp1.Type__c = 'Campaign';
            solComp1.Campaign_Description__c = 'Hey Hai Man Camp';
            solComp1.CampaignPartsPercentage__c = '20';
            solcomp1.Performed_Review__c = True;
            solcomp1.Solutions__c = sol.Id;
            solcomp1.Fail_Code_Editable__c='123';
            solcomp1.AccountCode__c='SERVICE TOOL WARRANTY 52';
            solcomp1.AccountCodeEdit__c='';
            solcomp1.CoveredPartsQty__c='321';
            solcomp1.System_Code__c = 'WE';
            solcomp1.Component_Code__c = 'AC';
            //solcomp.Fail_Code__c='Intake Manifold Pressure/Temperature Sensor-WEAC';
            insert solComp1;
            lstsolcomp.add(solComp);
            lstsolcomp.add(solComp1);
            
        CSS_SRT__c mySRT = new CSS_SRT__c();
            mySRT.Name = 'SRT000123';
            mySRT.SRT_Title__c = 'MY SRT';
            mySRT.CSS_Claims__c = claim1.Id;
            mySRT.Component_Id__c = solComp.Id;
            insert mySRT;
        
        CSS_Parts_Options__c partsOption1 = new CSS_Parts_Options__c();
            partsOption1.Amount__c=11;
            partsOption1.City__c='test';
            partsOption1.Comments__c='test';
            partsOption1.CSS_Claims__c = claim.Id;
            partsOption1.FailurepartId__c=solcomp.Id;
            insert partsOption1;
            
        CSS_Parts_Options__c partsOption2 = new CSS_Parts_Options__c();
            partsOption2.Amount__c=11;
            partsOption2.City__c='test';
            partsOption2.Comments__c='test';
            partsOption2.FailurepartId__c=solcomp.Id;
            partsOption2.CSS_Claims__c = claim.Id;
            insert partsOption2;
            
        CSS_Parts_Options__c partsOption3 = new CSS_Parts_Options__c();
            partsOption3.Amount__c=11;
            partsOption3.City__c='test';
            partsOption3.Comments__c='test';
            partsOption3.FailurepartId__c=solcomp.Id;
            partsOption3.CSS_Claims__c = claim1.Id;
            insert partsOption3;
        
        CSS_Parts_Options__c partsOption4 = new CSS_Parts_Options__c();
            partsOption4.Amount__c=11;
            partsOption4.City__c='test';
            partsOption4.Comments__c='test';
            partsOption4.CSS_Claims__c = claim1.Id;//12,partsOption1.Id,,true,,,'partDesc','accountCode','optionNumber',2,'partSize',,,,accCodes,'failCode',,');
            partsOption4.FailurepartId__c=solcomp.Id;
            partsOption4.selected_part__c=true;
            partsOption4.Replacement_Reason__c='replacementReason';
            partsOption4.Quantity__c=2;
            partsOption4.Notes__c='notes';
            partsOption4.ReturnToFactory__c='returnToFactory';
            partsOption4.Tracking_Number__c='TrackingNumber';
            //partsOption4.RID__c=RID;
            partsOption4.Covered__c=0.00;
            partsOption4.OEM__c='oem';
            partsOption4.Service_partnumber__c='servicePartNumber';
            // partsOption4.ReturnWaiver__c='return';
            insert partsOption4;
        
        List<CSS_JobEventTemporary__c> lstjobeventemp = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobeventemp = new CSS_JobEventTemporary__c();
            jobeventemp.Effect__c ='qwert';
            jobeventemp.Reason__c = 'falut code issue';
            jobeventemp.Fault_Code_Description__c = 'qwerty';
            jobeventemp.Active__c  = true;
            jobeventemp.Attribute2__c= 'abc';//prashanthi
            jobeventemp.Attribute3__c= 'abc1';//prashanthi
            jobeventemp.Attribute1__c= 'OTH';
            jobeventemp.Attribute5__c= 'abc1';
            jobeventemp.Attribute4__c= 'abc1';
            jobeventemp.Key__c='AccountCodes';
            insert jobeventemp;
            lstjobeventemp.add(jobeventemp);     
        
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
            //  parts.recordtypeId = 'recTypeIdpart';
            parts.Option_Number__c = 'O-111';
            parts.Service_Job__c = JO.Id;
            parts.selected_part__c = true;
            // parts.FailurepartId__c = csc.Id;
            parts.Parts_Type__c ='Custom';
            parts.Part_Name__c='test';
            parts.Service_partnumber__c='';
            parts.Quantity__c=1;
            parts.Covered__c=1.0;
            parts.CSS_Claims__c = claim.id;
            insert parts;
            
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
            //  parts.recordtypeId = 'recTypeIdpart';
            parts1.Option_Number__c = 'O-111';
            parts1.Service_Job__c = JO.Id;
            parts1.selected_part__c = true;
            // parts.FailurepartId__c = csc.Id;
            parts1.Parts_Type__c ='Custom';
            parts1.Part_Name__c='test';
            parts1.Service_partnumber__c='';
            parts1.Quantity__c=1;
            parts1.Covered__c=1.0;
            parts1.CSS_Claims__c = claim1.id;
            insert parts1;
     
        lstparts.add(parts);
        lstparts.add(parts1);
        lstparts.add(partsOption4);
        lstparts.add(partsOption1);
        lstparts.add(partsOption2);
        lstparts.add(partsOption3);
        
        css_header_nav__c cssHeaderObject = css_header_nav__c.getInstance();
        cssHeaderObject.RSWButtonEnable__c = true;
        insert cssHeaderObject;
        
        List<selectOption> accCodes = new List<selectOption>();
        List<CG_CL_GSQParts.srtPartWrapper> lstsrtpartwrap = new List<CG_CL_GSQParts.srtPartWrapper>();
        List<CG_CL_GSQParts.srtCompWrapper> lstsrtcompwrap = new List<CG_CL_GSQParts.srtCompWrapper>();
        
        CG_CL_GSQParts.srtsolWrapper srtsolwrap = new CG_CL_GSQParts.srtsolWrapper(sol.Id,'solName','solTitle',lstsrtcompwrap,12,11,sol.id,'parentSolname');
        
        CG_CL_GSQParts.srtCompWrapper srtcompwrap = new CG_CL_GSQParts.srtCompWrapper(solcomp.Id,'compname','solname','soltitle','failcode','failcodeedit','acc-code','acc-code edit',lstsrtpartwrap,1);
        lstsrtcompwrap.add(srtcompwrap);
        //srtPartWrapper(12, partsOption1.Id,solcomp.Id,true'1234','partName','partDesc','covered','accountCode','returnToFactory','returnWaiver','optionNumber',10,'partSize','replacementReason','notes','oem',accCodes,'failCode','rackingNumber','RID',true,true, true, Boolean isPartsCovLimitExceedPW,Decimal UnitPrice, Decimal TotalPrice, Boolean trackingNumberReq){
        CG_CL_GSQParts.srtPartWrapper srtpartwrap = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,true,'servicePartNumber','partName','partDesc','covered','accountCode','returnToFactory','returnWaiver','optionNumber',2,'partSize','replacementReason','notes','oem',accCodes,'failCode','TrackingNumber','RID',true,true,true,true,0.0,0.0,true,null,null);
        //CG_CL_GSQParts.srtPartWrapper srtpartwrap = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,true,'true','serpartnumb','part-name','partdesc','covered','acc-code','return to fac',12,'option-num','part-size','replacement reason','notes',accCodes,'failcode','abc','abc');
        
        lstsrtpartwrap.add(srtpartwrap);
        // CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(12,partsOption1.Id,solcomp.Id,true,'servicePartNumber','partName','partDesc','covered','accountCode','returnToFactory','returnWaiver','optionNumber',2,'partSize','replacementReason','notes','oem',accCodes,'failCode','TrackingNumber','RID');
        
        
        CG_CL_GSQParts GSQparts = new CG_CL_GSQParts();
           //CG_CL_GSQParts.lstSolComp1 = lstsolcomp;
            GSQparts.compSolId = claim.id;
            GSQparts.errorMsg = 'test';
            GSQparts.isDealer=true;
            GSQparts.unitPriceField = true;
            GSQparts.isReturnwaiver = true;
            GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim.id);
            GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim1.id);
            GSQparts.getAccountCodes();
            GSQparts.getfailcodeDropDown();
            GSQparts.saveParts();
            GSQparts.getreplacementReasonOptions();
            GSQparts.onChangeofAccountCode();
            GSQparts.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-WEAC';
            GSQparts.onChangeofFailCode();
            GSQparts.getPartsList();
            GSQparts.SPCheckboxChecked();
            List<selectOption> lstopt = GSQparts.accountCodelistN('abc3');
            List<SelectOption> gettrackingno= GSQparts.gettrackingNumber2();
            GSQparts.enableTrackingNumber1();
        //GSQparts.getTrackingNumber();
        //GSQparts.enableTrackingNumber();
        
    }
    
    public static testmethod void CG_CL_GSQParts_Method12(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Dealer Account';
        insert acc;
        
        List<CSS_Job_Order__c> lstjo = new List<CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.Account__c=acc.id;
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        insert jo;
        lstjo.add(jo);
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Email_Address__c = 'TestUser@cummins.com';
        claim.CSS_Job__c=jo.Id;
        claim.Account__c = acc.id;
        claim.Country__c='CA';
        claim.Location_Code__c = '03520-04892';
        claim.State__c='US';
        insert claim;
        
        ApexPages.CurrentPage().getParameters().put('id',claim.Id);
        CSS_Claims__c claim1 = new CSS_Claims__c();
        claim1.Email_Address__c = 'TestUser@cummins.com';
        claim1.CSS_Job__c=jo.Id;
        //claim1.Account__c=acc.id;
        claim1.Account__c=acc.id;
        claim1.Country__c='CA';
        claim1.State__c='US';
        insert claim1;
        //For country code description
        
        
        //ID pgId = ApexPages.CurrentPage().getParameters().put(JO.Id,'id');  
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;		
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        solComp.Covered_Parts__c = 'ak';
        solComp.Service_Job__c = Jo.id;
        solComp.CSS_Claims__c = claim.Id;
        solComp.Action__c = '';
        
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Solutions__c = sol.Id;
        // solcomp.CSS_Account_Formula__c = '123';
        solcomp.Fail_Code_Editable__c='1123';
        //solcomp.AccountCode__c='testing';
        solcomp.AccountCodeEdit__c='321';
        //solcomp.CoveredPartsQty__c='100';
        
        
        // solcomp.Fail_Code__c='testing';
        // 
        
        insert solComp;
        lstsolcomp.add(solComp);
        
        CSS_SRT__c mySRT = new CSS_SRT__c();
        mySRT.Name = 'SRT000123';
        mySRT.SRT_Title__c = 'MY SRT';
        mySRT.CSS_Claims__c = claim1.Id;
        mySRT.Component_Id__c = solComp.Id;
        
        insert mySRT;
        List <CSS_Parts_Options__c> lstpartopt = new List <CSS_Parts_Options__c>();
        CSS_Parts_Options__c partsOption1 = new CSS_Parts_Options__c();
        partsOption1.Amount__c=11;
        partsOption1.City__c='test';
        partsOption1.Comments__c='test';
        partsOption1.Covered__c = 12;
        partsOption1.CSS_Claims__c = claim.Id;
        partsOption1.Fail_Code__c ='Select One';
        partsOption1.Account_Code__c = acc.id;
        partsOption1.FailurepartId__c=solcomp.Id;
        partsoption1.Part_Assignment__c = 'Primary';
        insert partsOption1;
        lstpartopt.add(partsOption1);
        CSS_Parts_Options__c partsOption2 = new CSS_Parts_Options__c();
        partsOption2.Amount__c=11;
        partsOption2.City__c='test';
        partsOption2.Comments__c='test';
        partsOption2.FailurepartId__c=solcomp.Id;
        partsoption2.Part_Assignment__c = 'Primary';
        partsOption2.CSS_Claims__c = claim.Id;
        insert partsOption2;
        lstpartopt.add(partsOption2);
        CSS_Parts_Options__c partsOption3 = new CSS_Parts_Options__c();
        partsOption3.Amount__c=11;
        partsOption3.City__c='test';
        partsOption3.Comments__c='test';
        partsOption3.FailurepartId__c=solcomp.Id;
        partsoption3.Part_Assignment__c = 'Primary';
        partsOption3.CSS_Claims__c = claim1.Id;
        insert partsOption3;
        CSS_Parts_Options__c partsOption4 = new CSS_Parts_Options__c();
        partsOption4.Amount__c=11;
        partsOption4.City__c='test';
        partsOption4.Comments__c='test';
        partsOption4.CSS_Claims__c = claim1.Id;//12,partsOption1.Id,,true,,,'partDesc','accountCode','optionNumber',2,'partSize',,,,accCodes,'failCode',,');
        partsOption4.FailurepartId__c=solcomp.Id;
        partsOption4.selected_part__c=true;
        partsOption4.Replacement_Reason__c='replacementReason';
        partsOption4.Quantity__c=2;
        partsOption4.Notes__c='notes';
        partsOption4.ReturnToFactory__c='returnToFactory';
        partsOption4.Tracking_Number__c='TrackingNumber';
        //partsOption4.RID__c=RID;
        partsOption4.Covered__c=0.00;
        partsOption4.OEM__c='oem';
        partsoption4.Part_Assignment__c = 'Primary';
        partsOption4.Service_partnumber__c='servicePartNumber';
        partsOption4.CoverageLimitExceedMsg__c='ERROR';
        partsOption4.Parts_Type__c='ABC';
        partsOption4.selected_part__c=true;
        
        // partsOption4.ReturnWaiver__c='return';
        insert partsOption4;
        
        List<CSS_JobEventTemporary__c> lstjobeventemp = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobeventemp = new CSS_JobEventTemporary__c();
        jobeventemp.Effect__c ='qwert';
        jobeventemp.Reason__c = 'falut code issue';
        jobeventemp.Fault_Code_Description__c = 'qwerty';
        jobeventemp.Active__c  = true;
        jobeventemp.Attribute2__c= 'abc';//prashanthi
        jobeventemp.Attribute3__c= 'abc1';//prashanthi
        jobeventemp.Attribute1__c= 'OTH';
        jobeventemp.Attribute5__c= 'abc1';
        jobeventemp.Attribute4__c= 'abc1';
        jobeventemp.Key__c='AccountCodes';
        insert jobeventemp;
        lstjobeventemp.add(jobeventemp);    
        
        string coverageType = jobeventemp.Attribute1__c;
        RecordType rtp = [SELECT id,Name 
                              FROM RecordType 
                              WHERE name='Parts'];
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = rtp.id;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = JO.Id;
        parts.selected_part__c = true;
        // parts.FailurepartId__c = sol.Id;
        parts.Parts_Type__c ='Custom';
        parts.Part_Name__c='test';
        parts.Service_partnumber__c='';
        parts.Quantity__c=1;
        parts.Covered__c=1.0;
        parts.CSS_Claims__c = claim.id;
        insert parts;
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts.recordtypeId = rtp.id;
        parts1.Option_Number__c = 'O-111';
        parts1.Service_Job__c = JO.Id;
        parts1.selected_part__c = true;
        // parts.FailurepartId__c = csc.Id;
        parts1.Parts_Type__c ='Custom';
        parts1.Part_Name__c='test';
        parts1.Service_partnumber__c='';
        parts1.Quantity__c=1;
        parts1.Covered__c=1.0;
        parts1.Fail_Code__c='Select One';
        parts1.Account_Code__c='Select One';
        parts1.CSS_Claims__c = claim1.id;
        parts1.CoverageLimitExceedMsg__c='ERROR';
        parts1.Parts_Type__c='ABC';
        parts1.selected_part__c=true;
        insert parts1;
        lstparts.add(parts);
        lstparts.add(parts1);
        lstparts.add(partsOption4);
        lstparts.add(partsOption1);
        lstparts.add(partsOption2);
        lstparts.add(partsOption3);
        
          List<selectOption> accCodes = new List<selectOption>();
        List<CG_CL_GSQParts.srtPartWrapper> lstsrtpartwrap = new List<CG_CL_GSQParts.srtPartWrapper>();
        // List<CG_CL_GSQParts.srtCompWrapper> lstsrtcompwrap = new List<CG_CL_GSQParts.srtCompWrapper>();
        
        // CG_CL_GSQParts.srtsolWrapper srtsolwrap = new CG_CL_GSQParts.srtsolWrapper(sol.Id,'solName','solTitle',lstsrtcompwrap,12,11,sol.id,'parentSolname');
        
        // CG_CL_GSQParts.srtCompWrapper srtcompwrap = new CG_CL_GSQParts.srtCompWrapper(solcomp.Id,'compname','solname','soltitle','failcode','failcodeedit','acc-code','acc-code edit',lstsrtpartwrap,1);
        // lstsrtcompwrap.add(srtcompwrap);
         //CG_CL_GSQParts.srtPartWrapper srtpartwrap = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,true,'1','partName','partDesc','covered','accountCode','Y','true','optionNumber',2,'partSize','replacementReason','notes','oem',accCodes,'failCode','Select One','RID',true,true,true,true,0.0,0.0,true);
        CG_CL_GSQParts.srtPartWrapper srtpartwrap1 = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,false,'1','partName','partDesc','covered','accountCode','Y','true','optionNumber',2,'partSize',null,'notes','oem',accCodes,'Select One','Select One','RID',false,false,false,false,0.0,0.0,false,null,null);
        // 
         //lstsrtpartwrap.add(srtpartwrap);
        lstsrtpartwrap.add(srtpartwrap1);
        // CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(12,partsOption1.Id,solcomp.Id,true,'servicePartNumber','partName','partDesc','covered','accountCode','returnToFactory','returnWaiver','optionNumber',2,'partSize','replacementReason','notes','oem',accCodes,'failCode','TrackingNumber','RID');
        
        
        CG_CL_GSQParts GSQparts = new CG_CL_GSQParts();
        //CG_CL_GSQParts.lstSolComp1 = lstsolcomp;
        GSQparts.compSolId = claim.id;
        GSQparts.errorMsg = 'test';
        GSQparts.isDealer=false;
        GSQparts.unitPriceField = true;
        GSQparts.isReturnwaiver = true;
        GSQparts.SelectedAccountCode='321';
        GSQparts.SelectedFailCode='1123';
        // GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim.id);
        //GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim1.id);
        GSQparts.getAccountCodes();
        GSQparts.getfailcodeDropDown();
        GSQparts.saveParts();
        GSQparts.getreplacementReasonOptions();
        GSQparts.onChangeofAccountCode();
        // GSQparts.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-WEAC';
        GSQparts.onChangeofFailCode();
        GSQparts.getPartsList();
        List<selectOption> lstopt = GSQparts.accountCodelistN('abc3');
        List<SelectOption> gettrackingno= GSQparts.gettrackingNumber2();
        GSQparts.enableTrackingNumber1();
        //GSQparts.getTrackingNumber();
        //GSQparts.enableTrackingNumber();
        
        
        
    }
    public static testmethod void CG_CL_GSQParts_Method122(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Dealer Account';
        insert acc;
        
        List<CSS_Job_Order__c> lstjo = new List<CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.Account__c=acc.id;
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        insert jo;
        lstjo.add(jo);
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Email_Address__c = 'TestUser@cummins.com';
        claim.CSS_Job__c=jo.Id;
        claim.Account__c = acc.id;
        claim.Country__c='CA';
        claim.Location_Code__c = '03520-04892';
        claim.State__c='US';
        insert claim;
        
        ApexPages.CurrentPage().getParameters().put('id',claim.Id);
        CSS_Claims__c claim1 = new CSS_Claims__c();
        claim1.Email_Address__c = 'TestUser@cummins.com';
        claim1.CSS_Job__c=jo.Id;
        //claim1.Account__c=acc.id;
        claim1.Account__c=acc.id;
        claim1.Country__c='CA';
        claim1.State__c='US';
        insert claim1;
        //For country code description
        
        
        //ID pgId = ApexPages.CurrentPage().getParameters().put(JO.Id,'id');  
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;		
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        //solComp.Covered_Parts__c = 'aka';
        solComp.Service_Job__c = Jo.id;
        solComp.CSS_Claims__c = claim.Id;
        solComp.Action__c = '';
        
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Solutions__c = sol.Id;
        // solcomp.CSS_Account_Formula__c = '123';
        solcomp.Fail_Code_Editable__c='1123';
        //solcomp.AccountCode__c='testing';
        solcomp.AccountCodeEdit__c='321';
        //solcomp.CoveredPartsQty__c='100';
        
        
        // solcomp.Fail_Code__c='testing';
        // 
        
        insert solComp;
        lstsolcomp.add(solComp);
        
        CSS_SRT__c mySRT = new CSS_SRT__c();
        mySRT.Name = 'SRT000123';
        mySRT.SRT_Title__c = 'MY SRT';
        mySRT.CSS_Claims__c = claim1.Id;
        mySRT.Component_Id__c = solComp.Id;
        
        insert mySRT;
        
        CSS_Parts_Options__c partsOption1 = new CSS_Parts_Options__c();
        partsOption1.Amount__c=11;
        partsOption1.City__c='test';
        partsOption1.Comments__c='test';
        //partsOption1.Covered__c=12;
        partsOption1.CSS_Claims__c = claim.Id;
        partsOption1.Fail_Code__c ='Fuel Connector-FLFC';
        partsOption1.Account_Code__c = acc.id;
        partsOption1.FailurepartId__c=solcomp.Id;
        partsoption1.Part_Assignment__c = 'Primary';
        insert partsOption1;
        CSS_Parts_Options__c partsOption2 = new CSS_Parts_Options__c();
        partsOption2.Amount__c=11;
        partsOption2.City__c='test';
        partsOption2.Fail_Code__c = 'Select One';
        partsOption2.Comments__c='test';
        partsOption2.FailurepartId__c=solcomp.Id;
        partsoption2.Part_Assignment__c = 'Primary';
        partsOption2.CSS_Claims__c = claim.Id;
        insert partsOption2;
        CSS_Parts_Options__c partsOption3 = new CSS_Parts_Options__c();
        partsOption3.Amount__c=11;
        partsOption3.City__c='test';
        partsOption3.Comments__c='test';
        partsOption3.FailurepartId__c=solcomp.Id;
        partsoption3.Part_Assignment__c = 'Primary';
        partsOption3.CSS_Claims__c = claim1.Id;
        insert partsOption3;
        CSS_Parts_Options__c partsOption4 = new CSS_Parts_Options__c();
        partsOption4.Amount__c=11;
        partsOption4.City__c='test';
        partsOption4.Comments__c='test';
        partsOption4.CSS_Claims__c = claim1.Id;//12,partsOption1.Id,,true,,,'partDesc','accountCode','optionNumber',2,'partSize',,,,accCodes,'failCode',,');
        partsOption4.FailurepartId__c=solcomp.Id;
        partsOption4.selected_part__c=true;
        partsOption4.Replacement_Reason__c='replacementReason';
        partsOption4.Quantity__c=2;
        partsOption4.Notes__c='notes';
        partsOption4.ReturnToFactory__c='returnToFactory';
        partsOption4.Tracking_Number__c='TrackingNumber';
        //partsOption4.RID__c=RID;
        partsOption4.Covered__c=0.00;
        partsOption4.OEM__c='oem';
        partsoption4.Part_Assignment__c = 'Primary';
        partsOption4.Service_partnumber__c='servicePartNumber';
        partsOption4.CoverageLimitExceedMsg__c='ERROR';
        partsOption4.Parts_Type__c='ABC';
        partsOption4.selected_part__c=true;
        
        // partsOption4.ReturnWaiver__c='return';
        insert partsOption4;
        
        List<CSS_JobEventTemporary__c> lstjobeventemp = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobeventemp = new CSS_JobEventTemporary__c();
        jobeventemp.Effect__c ='qwert';
        jobeventemp.Reason__c = 'falut code issue';
        jobeventemp.Fault_Code_Description__c = 'qwerty';
        jobeventemp.Active__c  = true;
        jobeventemp.Attribute2__c= 'abc';//prashanthi
        jobeventemp.Attribute3__c= 'abc1';//prashanthi
        jobeventemp.Attribute1__c= 'OTH';
        jobeventemp.Attribute5__c= 'abc1';
        jobeventemp.Attribute4__c= 'abc1';
        jobeventemp.Key__c='AccountCodes';
        insert jobeventemp;
        lstjobeventemp.add(jobeventemp);    
        
        string coverageType = jobeventemp.Attribute1__c;
        RecordType rtp = [SELECT id,Name 
                              FROM RecordType 
                              WHERE name='Parts'];
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = rtp.id;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = JO.Id;
        parts.selected_part__c = true;
        // parts.FailurepartId__c = sol.Id;
        parts.Parts_Type__c ='Custom';
        parts.Part_Name__c='test';
        parts.Service_partnumber__c='';
        parts.Quantity__c=1;
        parts.Covered__c=1.0;
        parts.CSS_Claims__c = claim.id;
        insert parts;
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts.recordtypeId = rtp.id;
        parts1.Option_Number__c = 'O-111';
        parts1.Service_Job__c = JO.Id;
        parts1.selected_part__c = true;
        // parts.FailurepartId__c = csc.Id;
        parts1.Parts_Type__c ='Custom';
        parts1.Part_Name__c='test';
        parts1.Service_partnumber__c='';
        parts1.Quantity__c=1;
        parts1.Covered__c=1.0;
        parts1.Fail_Code__c='Select One';
        parts1.Account_Code__c='Select One';
        parts1.CSS_Claims__c = claim1.id;
        parts1.CoverageLimitExceedMsg__c='ERROR';
        parts1.Parts_Type__c='ABC';
        parts1.selected_part__c=true;
        insert parts1;
        lstparts.add(parts);
        lstparts.add(parts1);
        lstparts.add(partsOption4);
        lstparts.add(partsOption1);
        lstparts.add(partsOption2);
        lstparts.add(partsOption3);
        
          List<selectOption> accCodes = new List<selectOption>();
        List<CG_CL_GSQParts.srtPartWrapper> lstsrtpartwrap = new List<CG_CL_GSQParts.srtPartWrapper>();
        // List<CG_CL_GSQParts.srtCompWrapper> lstsrtcompwrap = new List<CG_CL_GSQParts.srtCompWrapper>();
        
        // CG_CL_GSQParts.srtsolWrapper srtsolwrap = new CG_CL_GSQParts.srtsolWrapper(sol.Id,'solName','solTitle',lstsrtcompwrap,12,11,sol.id,'parentSolname');
        
        // CG_CL_GSQParts.srtCompWrapper srtcompwrap = new CG_CL_GSQParts.srtCompWrapper(solcomp.Id,'compname','solname','soltitle','failcode','failcodeedit','acc-code','acc-code edit',lstsrtpartwrap,1);
        // lstsrtcompwrap.add(srtcompwrap);
         //CG_CL_GSQParts.srtPartWrapper srtpartwrap = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,true,'1','partName','partDesc','covered','accountCode','Y','true','optionNumber',2,'partSize','replacementReason','notes','oem',accCodes,'failCode','Select One','RID',true,true,true,true,0.0,0.0,true);
        CG_CL_GSQParts.srtPartWrapper srtpartwrap1 = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,false,'1','partName','partDesc','covered','accountCode','Y','true','optionNumber',2,'partSize',null,'notes','oem',accCodes,'Select One','Select One','RID',false,false,false,false,0.0,0.0,false,null,null);
        // 
         //lstsrtpartwrap.add(srtpartwrap);
        lstsrtpartwrap.add(srtpartwrap1);
        // CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(12,partsOption1.Id,solcomp.Id,true,'servicePartNumber','partName','partDesc','covered','accountCode','returnToFactory','returnWaiver','optionNumber',2,'partSize','replacementReason','notes','oem',accCodes,'failCode','TrackingNumber','RID');
        
        
        CG_CL_GSQParts GSQparts = new CG_CL_GSQParts();
        //CG_CL_GSQParts.lstSolComp1 = lstsolcomp;
        GSQparts.compSolId = claim.id;
        GSQparts.errorMsg = 'test';
        GSQparts.isDealer=true;
        GSQparts.unitPriceField = true;
        GSQparts.isReturnwaiver = true;
        GSQparts.SelectedAccountCode='321';
        GSQparts.SelectedFailCode='1123';
        // GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim.id);
        //GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim1.id);
        GSQparts.getAccountCodes();
        GSQparts.getfailcodeDropDown();
        GSQparts.saveParts();
        GSQparts.getreplacementReasonOptions();
        GSQparts.onChangeofAccountCode();
        // GSQparts.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-WEAC';
        GSQparts.onChangeofFailCode();
        GSQparts.getPartsList();
        List<selectOption> lstopt = GSQparts.accountCodelistN('abc3');
        List<SelectOption> gettrackingno= GSQparts.gettrackingNumber2();
        GSQparts.enableTrackingNumber1();
        GSQparts.coverageType = 'OTH';
        //GSQparts.getTrackingNumber();
        //GSQparts.enableTrackingNumber();
        
        
        
    }
    public static testmethod void CG_CL_GSQParts_Method1222(){
        Account acc = new Account();
        acc.Name = 'test';
        acc.Type = 'Dealer Account';
        insert acc;
        
        List<CSS_Job_Order__c> lstjo = new List<CSS_Job_Order__c>();
        CSS_Job_Order__c jo = new CSS_Job_Order__c();
        jo.createdDate=dateTime.now();
        jo.Account__c=acc.id;
        jo.ESN__c = '79464646';
        jo.Customer_Name__c='test';
        jo.Shop_Work_Order__c='uiafh';
        jo.Mileage__c=123;
        jo.Complaint_Type_Desc__c = 'CRUISE CONTROL';
        jo.Category_Desc__c = 'Fuel - Oil - Coolant';
        jo.Status__c = 'closed';
        jo.Service_Model__c = 'model';
        insert jo;
        lstjo.add(jo);
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Email_Address__c = 'TestUser@cummins.com';
        //claim.CSS_Job__c=jo.Id;
        claim.Account__c = acc.id;
        claim.Country__c='CA';
        claim.Location_Code__c = '03520-04892';
        claim.State__c='US';
        insert claim;
        
        ApexPages.CurrentPage().getParameters().put('id',claim.Id);
        CSS_Claims__c claim1 = new CSS_Claims__c();
        claim1.Email_Address__c = 'TestUser@cummins.com';
        claim1.CSS_Job__c=jo.Id;
        //claim1.Account__c=acc.id;
        claim1.Account__c=acc.id;
        claim1.Country__c='CA';
        claim1.State__c='US';
        insert claim1;
        //For country code description
        
        
        //ID pgId = ApexPages.CurrentPage().getParameters().put(JO.Id,'id');  
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Service_Job__c = JO.ID;		
        sol.Case_Name__c = 'ABC';
        sol.Solution_Title__c='CDE';
        sol.Name='ABC';
        sol.Diagnostic_Response__c ='Most likely the solution';
        sol.Repair_Response__c = 'Most likely';
        insert sol;
        List<CSS_Solution_Component__c> lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        solComp.Component_Id__c ='F0051000';
        //solComp.Covered_Parts__c = 'aka';
        solComp.Service_Job__c = Jo.id;
        solComp.CSS_Claims__c = claim.Id;
        solComp.Action__c = '';
        
        solComp.Campaign_Description__c = 'Hey Hai Man Camp';
        solComp.CampaignPartsPercentage__c = '20';
        solcomp.Performed_Review__c = True;
        solcomp.Solutions__c = sol.Id;
        // solcomp.CSS_Account_Formula__c = '123';
        solcomp.Fail_Code_Editable__c='1123';
        //solcomp.AccountCode__c='testing';
        solcomp.AccountCodeEdit__c='321';
        //solcomp.CoveredPartsQty__c='100';
        
        
        // solcomp.Fail_Code__c='testing';
        // 
        
        insert solComp;
        lstsolcomp.add(solComp);
        
        CSS_SRT__c mySRT = new CSS_SRT__c();
        mySRT.Name = 'SRT000123';
        mySRT.SRT_Title__c = 'MY SRT';
        mySRT.CSS_Claims__c = claim1.Id;
        mySRT.Component_Id__c = solComp.Id;
        
        insert mySRT;
        
        CSS_Parts_Options__c partsOption1 = new CSS_Parts_Options__c();
        partsOption1.Amount__c=11;
        partsOption1.City__c='test';
        partsOption1.Comments__c='test';
        //partsOption1.Covered__c=12;
        partsOption1.CSS_Claims__c = claim.Id;
        partsOption1.Fail_Code__c ='Fuel Connector-FLFC';
        partsOption1.Account_Code__c = acc.id;
        partsOption1.FailurepartId__c=solcomp.Id;
        partsoption1.Part_Assignment__c = 'Primary';
        insert partsOption1;
        CSS_Parts_Options__c partsOption2 = new CSS_Parts_Options__c();
        partsOption2.Amount__c=11;
        partsOption2.City__c='test';
        partsOption2.Fail_Code__c = 'Select One';
        partsOption2.Comments__c='test';
        partsOption2.FailurepartId__c=solcomp.Id;
        partsoption2.Part_Assignment__c = 'Primary';
        partsOption2.CSS_Claims__c = claim.Id;
        insert partsOption2;
        CSS_Parts_Options__c partsOption3 = new CSS_Parts_Options__c();
        partsOption3.Amount__c=11;
        partsOption3.City__c='test';
        partsOption3.Comments__c='test';
        partsOption3.FailurepartId__c=solcomp.Id;
        partsoption3.Part_Assignment__c = 'Primary';
        partsOption3.CSS_Claims__c = claim1.Id;
        insert partsOption3;
        CSS_Parts_Options__c partsOption4 = new CSS_Parts_Options__c();
        partsOption4.Amount__c=11;
        partsOption4.City__c='test';
        partsOption4.Comments__c='test';
        partsOption4.CSS_Claims__c = claim1.Id;//12,partsOption1.Id,,true,,,'partDesc','accountCode','optionNumber',2,'partSize',,,,accCodes,'failCode',,');
        partsOption4.FailurepartId__c=solcomp.Id;
        partsOption4.selected_part__c=true;
        partsOption4.Replacement_Reason__c='replacementReason';
        partsOption4.Quantity__c=2;
        partsOption4.Notes__c='notes';
        partsOption4.ReturnToFactory__c='returnToFactory';
        partsOption4.Tracking_Number__c='TrackingNumber';
        //partsOption4.RID__c=RID;
        partsOption4.Covered__c=0.00;
        partsOption4.OEM__c='oem';
        partsoption4.Part_Assignment__c = 'Primary';
        partsOption4.Service_partnumber__c='servicePartNumber';
        partsOption4.CoverageLimitExceedMsg__c='ERROR';
        partsOption4.Parts_Type__c='ABC';
        partsOption4.selected_part__c=true;
        
        // partsOption4.ReturnWaiver__c='return';
        insert partsOption4;
        
        List<CSS_JobEventTemporary__c> lstjobeventemp = new List<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobeventemp = new CSS_JobEventTemporary__c();
        jobeventemp.Effect__c ='qwert';
        jobeventemp.Reason__c = 'falut code issue';
        jobeventemp.Fault_Code_Description__c = 'qwerty';
        jobeventemp.Active__c  = true;
        jobeventemp.Attribute2__c= 'abc';//prashanthi
        jobeventemp.Attribute3__c= 'abc1';//prashanthi
        jobeventemp.Attribute1__c= 'OTH';
        jobeventemp.Attribute5__c= 'abc1';
        jobeventemp.Attribute4__c= 'abc1';
        jobeventemp.Key__c='AccountCodes';
        insert jobeventemp;
        lstjobeventemp.add(jobeventemp);    
        
        string coverageType = jobeventemp.Attribute1__c;
        RecordType rtp = [SELECT id,Name 
                              FROM RecordType 
                              WHERE name='Parts'];
        List<CSS_Parts_Options__c> lstparts = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.recordtypeId = rtp.id;
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = JO.Id;
        parts.selected_part__c = true;
        // parts.FailurepartId__c = sol.Id;
        parts.Parts_Type__c ='Custom';
        parts.Part_Name__c='test';
        parts.Service_partnumber__c='';
        parts.Quantity__c=1;
        parts.Covered__c=1.0;
        parts.CSS_Claims__c = claim.id;
        insert parts;
        CSS_Parts_Options__c parts1 = new CSS_Parts_Options__c();
        parts.recordtypeId = rtp.id;
        parts1.Option_Number__c = 'O-111';
        parts1.Service_Job__c = JO.Id;
        parts1.selected_part__c = true;
        // parts.FailurepartId__c = csc.Id;
        parts1.Parts_Type__c ='Custom';
        parts1.Part_Name__c='test';
        parts1.Service_partnumber__c='';
        parts1.Quantity__c=1;
        parts1.Covered__c=1.0;
        parts1.Fail_Code__c='Select One';
        parts1.Account_Code__c='Select One';
        parts1.CSS_Claims__c = claim1.id;
        parts1.CoverageLimitExceedMsg__c='ERROR';
        parts1.Parts_Type__c='ABC';
        parts1.selected_part__c=true;
        insert parts1;
        lstparts.add(parts);
        lstparts.add(parts1);
        lstparts.add(partsOption4);
        lstparts.add(partsOption1);
        lstparts.add(partsOption2);
        lstparts.add(partsOption3);
        
          List<selectOption> accCodes = new List<selectOption>();
        List<CG_CL_GSQParts.srtPartWrapper> lstsrtpartwrap = new List<CG_CL_GSQParts.srtPartWrapper>();
        // List<CG_CL_GSQParts.srtCompWrapper> lstsrtcompwrap = new List<CG_CL_GSQParts.srtCompWrapper>();
        
        // CG_CL_GSQParts.srtsolWrapper srtsolwrap = new CG_CL_GSQParts.srtsolWrapper(sol.Id,'solName','solTitle',lstsrtcompwrap,12,11,sol.id,'parentSolname');
        
        // CG_CL_GSQParts.srtCompWrapper srtcompwrap = new CG_CL_GSQParts.srtCompWrapper(solcomp.Id,'compname','solname','soltitle','failcode','failcodeedit','acc-code','acc-code edit',lstsrtpartwrap,1);
        // lstsrtcompwrap.add(srtcompwrap);
         //CG_CL_GSQParts.srtPartWrapper srtpartwrap = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,true,'1','partName','partDesc','covered','accountCode','Y','true','optionNumber',2,'partSize','replacementReason','notes','oem',accCodes,'failCode','Select One','RID',true,true,true,true,0.0,0.0,true);
        CG_CL_GSQParts.srtPartWrapper srtpartwrap1 = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,true,'1','partName','partDesc','covered','accountCode','Y','true','optionNumber',2,'partSize',null,'notes','oem',accCodes,'Select one','Select','RID',false,false,false,false,0.0,0.0,false,null,null);
        // 
         //lstsrtpartwrap.add(srtpartwrap);
        lstsrtpartwrap.add(srtpartwrap1);
        // CSS_Parts_Options__c partComp = new CSS_Parts_Options__c(12,partsOption1.Id,solcomp.Id,true,'servicePartNumber','partName','partDesc','covered','accountCode','returnToFactory','returnWaiver','optionNumber',2,'partSize','replacementReason','notes','oem',accCodes,'failCode','TrackingNumber','RID');
        
        
        CG_CL_GSQParts GSQparts = new CG_CL_GSQParts();
        //CG_CL_GSQParts.lstSolComp1 = lstsolcomp;
        GSQparts.compSolId = claim.id;
        GSQparts.errorMsg = 'test';
        GSQparts.isDealer=false;
        GSQparts.unitPriceField = true;
        GSQparts.isReturnwaiver = true;
        GSQparts.SelectedAccountCode='321';
        GSQparts.SelectedFailCode='1123';
        // GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim.id);
        //GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim1.id);
        GSQparts.getAccountCodes();
        GSQparts.getfailcodeDropDown();
        GSQparts.saveParts();
        GSQparts.getreplacementReasonOptions();
        GSQparts.onChangeofAccountCode();
        // GSQparts.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-WEAC';
        GSQparts.onChangeofFailCode();
        GSQparts.getPartsList();
        List<selectOption> lstopt = GSQparts.accountCodelistN('abc3');
        List<SelectOption> gettrackingno= GSQparts.gettrackingNumber2();
        GSQparts.enableTrackingNumber1();
        GSQparts.coverageType = 'OTH';
        //GSQparts.getTrackingNumber();
        //GSQparts.enableTrackingNumber();
        
        
        
    }

    
    public static testmethod void CG_CL_GSQParts_method1(){
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
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Email_Address__c = 'TestUser@cummins.com';
        claim.CSS_Job__c=jo.Id;
        claim.Country__c='CA';
        claim.State__c='US';
        insert claim;
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
        AddsolComp.CoveredPartsQty__c = '0';
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
        //ss1.SelectedPartID = 1;
       // ss1.selectedPartRowCount = 1;
        
        ss1.servicePartNumber = 'one';
        List<SelectOption> accCodes1 = new List<SelectOption>();
        accCodes1.add(new SelectOption('01', 'Jan'));
        accCodes1.add(new SelectOption('02', 'Feb'));
        //srtParts.srtpartsErrorMsg = 'Bad request';
        ss1.accCodes = accCodes1;
        ss1.accountCodelistN('ReCon Policy','9','wer');
        
        CSS_Claims__c claim12 = new CSS_Claims__c();
        claim12.Email_Address__c = 'TestUser@cummins.com';
        claim12.CSS_Job__c=jo.Id;
        claim12.Country__c='CA';
        claim12.State__c='US';
        insert claim12;
        CSS_Solution_Component__c solcomp12 = new CSS_Solution_Component__c();//CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp12.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp12.CoveredPartsQty__c = '100';
        solcomp12.CoveredOCAmount__c = '100';
        solcomp12.Service_Job__c=JO.id;
        solcomp12.AccountCode__c  = '67';
        solcomp12.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp12.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp12.CoveredOCAmount__c = '9999999';
        solcomp12.Fail_Code_Editable__c = 'Electrical Connector-THAC';
        solcomp12.Failure_Mode__c='Wtest2';
        solcomp12.Component_Code__c='AC';
        solcomp12.System_Code__c='TH';
        solcomp12.CSS_Claims__c=claim12.Id;
        insert solcomp12;
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
        //jobeventemp.Account_Code__c='emission';
        jobeventemp.Key__c = 'AccountCodes';
        insert jobeventemp;
        system.debug('jobeventemp'+jobeventemp);
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
        partop.CoverageLimitExceedMsg__c='ERROR';
        partop.Parts_Type__c='ABC';
        partop.selected_part__c=true;
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
        List<CG_CL_GSQParts.srtPartWrapper> lstsrtpartwrap = new List<CG_CL_GSQParts.srtPartWrapper>();
        List<CG_CL_GSQParts.srtCompWrapper> lstsrtcompwrap = new List<CG_CL_GSQParts.srtCompWrapper>();
        List<CG_CL_GSQParts.srtsolWrapper> lstsrtsompwrap = new List<CG_CL_GSQParts.srtsolWrapper>();
        CG_CL_GSQParts.srtsolWrapper srtsolwrap = new CG_CL_GSQParts.srtsolWrapper(sol.Id,'solName','solTitle',lstsrtcompwrap,1,11,sol.id,'parentSolname');
        lstsrtsompwrap.add(srtsolwrap);
        CG_CL_GSQParts.srtCompWrapper srtcompwrap = new CG_CL_GSQParts.srtCompWrapper(solcomp.Id,'compname','solname','soltitle','failcode','failcodeedit','acc-code','acc-code edit',lstsrtpartwrap,1);
        lstsrtcompwrap.add(srtcompwrap);
        system.debug('lstsrtcompwrap.....'+lstsrtcompwrap);
        CG_CL_GSQParts.srtPartWrapper srtpartwrap = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,true,'1','partName','partDesc','covered','accountCode','Y','true','optionNumber',2,'partSize','replacementReason','notes','oem',accCodes,'failCode','Select One','RID',true,true,true,true,0.0,0.0,true,null,null);
         CG_CL_GSQParts.srtPartWrapper srtpartwrap1 = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,true,'1','partName','partDesc','covered','accountCode','Y','false','optionNumber',2,'partSize',null,'notes','oem',accCodes,'Select One','Select One','RID',true,true,true,true,0.0,0.0,true,null,null);
        // CG_CL_GSQParts.srtPartWrapper srtpartwrap = new CG_CL_GSQParts.srtPartWrapper(1,partop.Id,solcomp.Id,true,true,'1','part-name','partdesc','2','acc-code','return to fac','option-num',1,'part-size','replacement reason','notes','oem',accCodes,'failcode');
        lstsrtpartwrap.add(srtpartwrap);
         lstsrtpartwrap.add(srtpartwrap1);
        css_repair_job  cssRep = new css_repair_job();
        PageReference pref1;
        pref1 = new PageReference('/'+JO.id);
        pref1.getParameters().put('id',claim12.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref1);
        CG_CL_GSQParts GSQparts = new CG_CL_GSQParts();
        //CG_CL_SuggestedPartsFromGSQ aa = new CG_CL_SuggestedPartsFromGSQ();
        GSQparts.saveParts();
        GSQparts.SelectedAccountCode = 'Customized Assurance Plan DC';
        GSQparts.SelectedFailCode = 'THAC';
        GSQparts.compSolId=sol.id;
        // GSQparts.serviceJob=JO;
        GSQparts.solutiondetails=css; 
        GSQparts.lstsrtPartWrapper=lstsrtpartwrap;
        GSQparts.listsrtCompWrapper=lstsrtcompwrap;
        GSQparts.listsrtsolWrapper=lstsrtsompwrap;
        GSQparts.listsrtsolWrapperDisp=lstsrtsompwrap;
        // GSQparts.srtpartsErrorMsg='Test';
        // GSQparts.displayPopup2=True;
        GSQparts.srtpb=True;
        map<Id,string> ss=new map<Id,string>();
        ss.put(null,'test');
        List<string> sss=new List<string>();
        sss.add('test');
        GSQparts.recTypeIdpart=null;
        GSQparts.failidmap=ss;
        GSQparts.solutionmap=ss;
        // GSQparts.failids=sss;
        GSQparts.chkReqField=True;
        GSQparts.compSolId=null;
        // GSQparts.partsList=pOptions;
        /*GSQparts.getAccountCodes();
//GSQparts.accountCodelistN('cc','dd','ss');
GSQparts.getAccountCodes();
GSQparts.saveParts();
GSQparts.getreplacementReasonOptions();*/
        //GSQparts.SelectedAccountCode = 'ALTER';
        GSQparts.SelectedPartID = 1;
        GSQparts.selectedPartRowCount = 12;
        GSQparts.servicePartNumber = '1';
        GSQparts.SelectedAccountCode =lstsolcomp11[0].AccountCodeEdit__c;
        GSQparts.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        //GSQparts.onChangeofAccountCode();
		GSQparts.getPartsList();
        GSQparts.SelectedAccountCode = 'Select One';
        GSQparts.servicePartNumber = '1';
        GSQparts.selectedPartRowCount = 12;
        GSQparts.onChangeofAccountCode();
        
        //CG_CL_GSQParts.lstSolComp1 = lstsolcomp;
        GSQparts.compSolId = claim.id;
        GSQparts.errorMsg = 'test';
        GSQparts.unitPriceField = true;
        GSQparts.isReturnwaiver = true;
        GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim.id);
        // GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim1.id);
        GSQparts.getAccountCodes();
        GSQparts.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-THAC';
        GSQparts.onChangeofFailCode();
        GSQparts.saveParts();
        GSQparts.getreplacementReasonOptions();
        GSQparts.onChangeofAccountCode();
        GSQparts.getPartsList();
        List<selectOption> lstopt = GSQparts.accountCodelistN('abc3');
        List<SelectOption> gettrackingno= GSQparts.gettrackingNumber2();
        GSQparts.enableTrackingNumber1();
        
    }
    
    public static testmethod void CG_CL_GSQParts_method13(){
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
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Email_Address__c = 'TestUser@cummins.com';
        //  claim.CSS_Job__c=jo.Id;
        claim.Country__c='CA';
        claim.State__c='US';
        insert claim;
        ID pgid1=ApexPages.CurrentPage().getParameters().put('id',claim.id);
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
        AddsolComp.CoveredPartsQty__c = '0';
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
        
        
        CSS_Claims__c claim12 = new CSS_Claims__c();
        claim12.Email_Address__c = 'TestUser@cummins.com';
        claim12.CSS_Job__c=jo.Id;
        claim12.Country__c='CA';
        claim12.State__c='US';
        insert claim12;
        CSS_Solution_Component__c solcomp12 = new CSS_Solution_Component__c();//CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp12.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp12.CoveredPartsQty__c = '100';
        solcomp12.CoveredOCAmount__c = '100';
        solcomp12.Service_Job__c=JO.id;
        solcomp12.AccountCode__c  = '67';
        solcomp12.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp12.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp12.CoveredOCAmount__c = '9999999';
        solcomp12.Fail_Code_Editable__c = 'Electrical Connector-THAC';
        solcomp12.Failure_Mode__c='Wtest2';
        solcomp12.Component_Code__c='AC';
        solcomp12.System_Code__c='TH';
        solcomp12.CSS_Claims__c=claim12.Id;
        insert solcomp12;
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
        //  ID pageId = ApexPages.CurrentPage().getParameters().get('id');
        //ID pgId = ApexPages.CurrentPage().getParameters().put(JO.Id,'id');
        
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
        partop.CoverageLimitExceedMsg__c='ERROR';
        partop.Parts_Type__c='ABC';
        partop.selected_part__c=true;
        partop.Amount__c=11;
        partop.City__c='test';
        partop.Comments__c='test';
        partop.RecordTypeId=recordtyid;
        
        pOptions.add(partop);
        pOptions.add(partsOption1);
        insert pOptions;
        
        PageReference pref;
        pref = new PageReference('/'+JO.id);
        pref.getParameters().put('id',JO.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref);
        
        
        List<selectOption> accCodes = new List<selectOption>();
        List<CG_CL_GSQParts.srtPartWrapper> lstsrtpartwrap = new List<CG_CL_GSQParts.srtPartWrapper>();
        List<CG_CL_GSQParts.srtCompWrapper> lstsrtcompwrap = new List<CG_CL_GSQParts.srtCompWrapper>();
        List<CG_CL_GSQParts.srtsolWrapper> lstsrtsompwrap = new List<CG_CL_GSQParts.srtsolWrapper>();
        CG_CL_GSQParts.srtsolWrapper srtsolwrap = new CG_CL_GSQParts.srtsolWrapper(sol.Id,'solName','solTitle',lstsrtcompwrap,1,11,sol.id,'parentSolname');
        lstsrtsompwrap.add(srtsolwrap);
        CG_CL_GSQParts.srtCompWrapper srtcompwrap = new CG_CL_GSQParts.srtCompWrapper(solcomp.Id,'compname','solname','soltitle','failcode','failcodeedit','acc-code','acc-code edit',lstsrtpartwrap,1);
        lstsrtcompwrap.add(srtcompwrap);
        system.debug('lstsrtcompwrap.....'+lstsrtcompwrap);
        CG_CL_GSQParts.srtPartWrapper srtpartwrap = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,true,'1','partName','partDesc','covered','accountCode','returnToFactory','true','optionNumber',2,'partSize','replacementReason','notes','oem',accCodes,'failCode','Select One','RID',true,true,true,true,0.0,0.0,true,null,null);
        // CG_CL_GSQParts.srtPartWrapper srtpartwrap = new CG_CL_GSQParts.srtPartWrapper(1,partop.Id,solcomp.Id,true,true,'1','part-name','partdesc','2','acc-code','return to fac','option-num',1,'part-size','replacement reason','notes','oem',accCodes,'failcode');
        lstsrtpartwrap.add(srtpartwrap);
        
        css_repair_job  cssRep = new css_repair_job(); 
        PageReference pref1;
        pref1 = new PageReference('/'+JO.id);
        pref1.getParameters().put('id',claim12.id);
        //pref.getParameters().put('partsUr','Parts');
        Test.setCurrentPage(pref1);
        CG_CL_GSQParts GSQparts = new CG_CL_GSQParts();
        //CG_CL_SuggestedPartsFromGSQ aa = new CG_CL_SuggestedPartsFromGSQ();
        GSQparts.pgId = JO.id;
        GSQparts.SelectedAccountCode = 'Customized Assurance Plan DC';
        GSQparts.SelectedFailCode = 'THAC';
        GSQparts.compSolId=sol.id;
        // GSQparts.serviceJob=JO;
        GSQparts.solutiondetails=css; 
        GSQparts.lstsrtPartWrapper=lstsrtpartwrap;
        GSQparts.listsrtCompWrapper=lstsrtcompwrap;
        GSQparts.listsrtsolWrapper=lstsrtsompwrap;
        GSQparts.listsrtsolWrapperDisp=lstsrtsompwrap;
        // GSQparts.srtpartsErrorMsg='Test';
        // GSQparts.displayPopup2=True;
        GSQparts.srtpb=True;
        map<Id,string> ss=new map<Id,string>();
        ss.put(null,'test');
        List<string> sss=new List<string>();
        sss.add('test');
        GSQparts.recTypeIdpart=null;
        GSQparts.failidmap=ss;
        GSQparts.solutionmap=ss;
        // GSQparts.failids=sss;
        GSQparts.chkReqField=True;
        GSQparts.compSolId=null;
        // GSQparts.partsList=pOptions;
        /*GSQparts.getAccountCodes();
//GSQparts.accountCodelistN('cc','dd','ss');
GSQparts.getAccountCodes();
GSQparts.saveParts();
GSQparts.getreplacementReasonOptions();*/
        //GSQparts.SelectedAccountCode = 'ALTER';
        GSQparts.SelectedPartID = 1;
        GSQparts.selectedPartRowCount = 12;
        GSQparts.servicePartNumber = '1';
        GSQparts.SelectedAccountCode =lstsolcomp11[0].AccountCodeEdit__c;
        GSQparts.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        //GSQparts.onChangeofAccountCode();
	    GSQparts.getPartsList();
        GSQparts.SelectedAccountCode = 'Select One';
        GSQparts.servicePartNumber = '1';
        GSQparts.selectedPartRowCount = 12;
        GSQparts.onChangeofAccountCode();
        
        //CG_CL_GSQParts.lstSolComp1 = lstsolcomp;
        GSQparts.compSolId = claim.id;
        GSQparts.errorMsg = 'test';
        GSQparts.unitPriceField = true;
        GSQparts.isReturnwaiver = true;
        GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim.id);
        // GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim1.id);
        GSQparts.getAccountCodes();
        GSQparts.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-THAC';
        GSQparts.onChangeofFailCode();
        GSQparts.saveParts();
        GSQparts.getreplacementReasonOptions();
        GSQparts.onChangeofAccountCode();
        GSQparts.getPartsList();
        List<selectOption> lstopt = GSQparts.accountCodelistN('abc3');
        List<SelectOption> gettrackingno= GSQparts.gettrackingNumber2();
        GSQparts.enableTrackingNumber1();
        
        
    }
    
    public static testmethod void CG_CL_GSQParts_method14(){
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
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.Email_Address__c = 'TestUser@cummins.com';
        //  claim.CSS_Job__c=jo.Id;
        claim.Country__c='CA';
        claim.State__c='US';
        insert claim;
        ID pgid1=ApexPages.CurrentPage().getParameters().put('id',claim.id);
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
        AddsolComp.type__c='Campaign';
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
        solcomp.CSS_Claims__c=claim.Id;
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
        solcomp1.CSS_Claims__c=claim.Id;
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
        solcomp3.CSS_Claims__c=claim.Id;
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
        solcomp4.CSS_Claims__c=claim.Id;
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
        
        
        CSS_Claims__c claim12 = new CSS_Claims__c();
        claim12.Email_Address__c = 'TestUser@cummins.com';
        claim12.CSS_Job__c=jo.Id;
        claim12.Country__c='CA';
        claim12.State__c='US';
        insert claim12;
        CSS_Solution_Component__c solcomp12 = new CSS_Solution_Component__c();//CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp12.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp12.CoveredPartsQty__c = '100';
        solcomp12.CoveredOCAmount__c = '100';
        solcomp12.Service_Job__c=JO.id;
        solcomp12.AccountCode__c  = '67';
        solcomp12.AccountCodeEdit__c='Customized Assurance Plan DC';
        solcomp12.AccountCodeType__c = 'NEW-New Engine Warranty';
        solcomp12.CoveredOCAmount__c = '9999999';
        solcomp12.Fail_Code_Editable__c = 'Electrical Connector-THAC';
        solcomp12.Failure_Mode__c='Wtest2';
        solcomp12.Component_Code__c='AC';
        solcomp12.System_Code__c='TH';
        solcomp12.CSS_Claims__c=claim12.Id;
        insert solcomp12;
        CSS_Parts_Options__c partsOption1 = new CSS_Parts_Options__c();
        partsOption1.Amount__c=11;
        partsOption1.City__c='test';
        partsOption1.Comments__c='test';
        partsOption1.CoverageLimitExceedMsg_Status__c = 'ERROR';
        partsOption1.selected_part__c = true;
        partsOption1.Parts_Type__c = 'aka';
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
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Parts');
         RecordType rtp = [SELECT id,Name 
                              FROM RecordType 
                              WHERE name='Parts']; 
        
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
        //partop.RecordTypeId=recTypeIdpart;
        partop.CoverageLimitExceedMsg_Status__c = 'ERROR';
        partop.selected_part__c = true;
        partop.Parts_Type__c = 'aka';
        
        pOptions.add(partop);
        pOptions.add(partsOption1);
        insert pOptions;
        CSS_Parts_Options__c partop1 = new CSS_Parts_Options__c();
        //partop1.RecordTypeId=recordtyid;
        partop1.Quantity__c=2.0;
        partop1.Solutions__c = sol.Id;
        // partop.Service_partnumber__c='540571400';
        partop1.Service_partnumber__c='2';
        partop1.Part_Name__c='KIT,SERVICE';
        partop1.Sell_Price__c=1.0;
        partop1.Replacement_Reason__c='';
        partop1.Notes__c='';
        partop1.OEM__c='';
        partop1.selected_part__c=true;
        partop1.ReturnToFactory__c='';
        partop1.Covered__c=2.0;
        partop1.Fail_Code__c='';
        partop1.Account_Code__c='';
        partop1.Amount__c=11;
        partop1.City__c='test';
        partop1.Comments__c='test';
        partop1.RecordTypeId=rtp.id;
        partop1.CoverageLimitExceedMsg_Status__c = 'ERROR';
        partop1.selected_part__c = true;
        partop1.Parts_Type__c = 'aka';
        insert partop1;
        
        
        
        List<selectOption> accCodes = new List<selectOption>();
        List<CG_CL_GSQParts.srtPartWrapper> lstsrtpartwrap = new List<CG_CL_GSQParts.srtPartWrapper>();
        List<CG_CL_GSQParts.srtCompWrapper> lstsrtcompwrap = new List<CG_CL_GSQParts.srtCompWrapper>();
        List<CG_CL_GSQParts.srtsolWrapper> lstsrtsompwrap = new List<CG_CL_GSQParts.srtsolWrapper>();
        CG_CL_GSQParts.srtsolWrapper srtsolwrap = new CG_CL_GSQParts.srtsolWrapper(sol.Id,'solName','solTitle',lstsrtcompwrap,1,11,sol.id,'parentSolname');
        lstsrtsompwrap.add(srtsolwrap);
        CG_CL_GSQParts.srtCompWrapper srtcompwrap = new CG_CL_GSQParts.srtCompWrapper(solcomp.Id,'compname','solname','soltitle','failcode','failcodeedit','acc-code','acc-code edit',lstsrtpartwrap,1);
        lstsrtcompwrap.add(srtcompwrap);
        system.debug('lstsrtcompwrap.....'+lstsrtcompwrap);
        CG_CL_GSQParts.srtPartWrapper srtpartwrap = new CG_CL_GSQParts.srtPartWrapper(12,partsOption1.Id,solcomp.Id,true,'1','partName','partDesc','covered','accountCode','returnToFactory','true','optionNumber',2,'partSize','replacementReason','notes','oem',accCodes,'failCode','Select One','RID',true,true,true,true,0.0,0.0,true,null,null);
        // CG_CL_GSQParts.srtPartWrapper srtpartwrap = new CG_CL_GSQParts.srtPartWrapper(1,partop.Id,solcomp.Id,true,true,'1','part-name','partdesc','2','acc-code','return to fac','option-num',1,'part-size','replacement reason','notes','oem',accCodes,'failcode');
        lstsrtpartwrap.add(srtpartwrap);
        
        
        CG_CL_GSQParts GSQparts = new CG_CL_GSQParts();
        //CG_CL_SuggestedPartsFromGSQ aa = new CG_CL_SuggestedPartsFromGSQ();
        GSQparts.pgId = JO.id;
        GSQparts.SelectedAccountCode = 'Customized Assurance Plan DC';
        GSQparts.SelectedFailCode = 'THAC';
        GSQparts.compSolId=sol.id;
        // GSQparts.serviceJob=JO;
        GSQparts.solutiondetails=css; 
        GSQparts.lstsrtPartWrapper=lstsrtpartwrap;
        GSQparts.listsrtCompWrapper=lstsrtcompwrap;
        GSQparts.listsrtsolWrapper=lstsrtsompwrap;
        GSQparts.listsrtsolWrapperDisp=lstsrtsompwrap;
        // GSQparts.srtpartsErrorMsg='Test';
        // GSQparts.displayPopup2=True;
        GSQparts.srtpb=True;
        map<Id,string> ss=new map<Id,string>();
        ss.put(null,'test');
        List<string> sss=new List<string>();
        sss.add('test');
        GSQparts.recTypeIdpart=null;
        GSQparts.failidmap=ss;
        GSQparts.solutionmap=ss;
        // GSQparts.failids=sss;
        GSQparts.chkReqField=True;
        GSQparts.compSolId=null;
        // GSQparts.partsList=pOptions;
        /*GSQparts.getAccountCodes();
//GSQparts.accountCodelistN('cc','dd','ss');
GSQparts.getAccountCodes();
GSQparts.saveParts();
GSQparts.getreplacementReasonOptions();*/
        //GSQparts.SelectedAccountCode = 'ALTER';
        GSQparts.SelectedPartID = 1;
        GSQparts.selectedPartRowCount = 12;
        GSQparts.servicePartNumber = '1';
        GSQparts.SelectedAccountCode =lstsolcomp11[0].AccountCodeEdit__c;
        GSQparts.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        //GSQparts.onChangeofAccountCode();
        GSQparts.onChangeofFailCode();
 		GSQparts.getPartsList();
        GSQparts.SelectedAccountCode = 'Select One';
        GSQparts.servicePartNumber = '1';
        GSQparts.selectedPartRowCount = 12;
        GSQparts.onChangeofAccountCode();
        
        //CG_CL_GSQParts.lstSolComp1 = lstsolcomp;
        GSQparts.compSolId = claim.id;
        GSQparts.errorMsg = 'test';
        GSQparts.unitPriceField = true;
        GSQparts.isReturnwaiver = true;
        GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim.id);
        // GSQparts.pgId = ApexPages.CurrentPage().getParameters().put('id',claim1.id);
        GSQparts.getAccountCodes();
        GSQparts.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-THAC';
        GSQparts.onChangeofFailCode();
        GSQparts.saveParts();
        GSQparts.getreplacementReasonOptions();
        GSQparts.onChangeofAccountCode();
        GSQparts.getPartsList();
        GSQparts.failAccCodeErrorMessage= false;
        
        //List<selectOption> lstopt = GSQparts.accountCodelistN('abc3','abc4', 'abc5');
        List<SelectOption> gettrackingno= GSQparts.gettrackingNumber2();
        GSQparts.enableTrackingNumber1();
        GSQparts.isDealer = true;
        GSQparts.coverageType = 'OTH';
        
        
    }
    
}