/**********************************************************************
Name:CG_CL_ClaimsOtherClaimbles_Test
Copyright © 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
Test classes for Claims - Other Claimables
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE                DETAIL                                 
1.0 -                            
***********************************************************************/


@isTest
public class CG_CL_ClaimsOtherClaimbles_Test {
    
    public static testmethod void CallAllMethods(){
         
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        css_claims__c claims = new css_claims__c();
        claims.CSS_Job__c = jo.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        claims.Account__c=acc.id;
        insert claims;
        
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        insert sol;
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.Service_Job__c=jo.Id;
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.AccountCode__c='';
        solcomp.AccountCodeEdit__c = 'test';
        solcomp.Solutions__c=sol.id;
        solcomp.Selected_Component__c=true;
        solcomp.Fail_Code_Editable__c='Testing';
        insert solcomp;
        
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        
        
        CSS_Parts_Options__c  partop = new CSS_Parts_Options__c ();
        partop.CSS_Claims__c=claims.Id;
        partop.Type__c='Parts';
        partop.Service_Job__c=jo.Id;
        partop.RecordTypeId=recordtypeid;
        partop.selected_part__c=true;
        partop.Quantity__c=.0;
        partop.isManual__c=true;
        partop.Account_Code__c='Testing';
        partop.Part_Description__c='Testing';
        partop.Item__c='Belt';
        partop.Amount__c= 0.0;
        partop.Covered__c=00;
        partop.Fail_Code__c='Testing';
        partop.Currency_Type__c='USD';
        partop.Exchange_Rate_Version__c=23;
        partop.Exchange_Rate__c=1;
        partop.Unit_Price__c='50';
        partop.Amount_Local_Currency__c=50;
         partop.Sell_Price__c=50;
        partop.ExpenseTotal__c = 60;
        insert partop;
        
        CSS_Parts_Options__c  partop1 = new CSS_Parts_Options__c ();
        partop1.CSS_Claims__c=claims.Id;
        partop1.Type__c='Parts';
        partop1.Service_Job__c=jo.Id;
        partop1.RecordTypeId=recordtypeid;
        partop1.selected_part__c=true;
        partop1.Quantity__c=2.0;
        partop1.isManual__c=true;
        partop1.Account_Code__c='Testing';
        partop1.Part_Description__c='Testing';
        partop1.Item__c='Belt';
        partop1.Amount__c=100.0;
        partop1.Covered__c=100;
        partop1.Fail_Code__c='Testing';
        partop1.Currency_Type__c='USD';
        partop1.Exchange_Rate_Version__c=23;
        partop1.Exchange_Rate__c=1;
        partop1.Unit_Price__c='50';
        partop1.Amount_Local_Currency__c=50;
         partop1.Sell_Price__c=50;
        partop1.ExpenseTotal__c = 60;
        insert partop1;
        
        CSS_Parts_Options__c  partop2 = new CSS_Parts_Options__c ();
        partop2.CSS_Claims__c=claims.Id;
        partop2.Type__c='Parts';
        partop2.Service_Job__c=jo.Id;
        partop2.RecordTypeId=recordtypeid;
        partop2.selected_part__c=true;
        partop2.Quantity__c=2.0;
        partop2.isManual__c=true;
        partop2.Account_Code__c='Testing';
        partop2.Part_Description__c='Testing';
        partop2.Item__c='Belt';
        partop2.Amount__c=200.0;
        partop2.Covered__c=200;
        partop2.Fail_Code__c='Testing';
        partop2.Currency_Type__c='USD';
        partop2.Exchange_Rate_Version__c=23;
        partop2.Exchange_Rate__c=1;
        partop2.Unit_Price__c='50';
        partop2.Amount_Local_Currency__c=50;
         partop2.Sell_Price__c=50;
        partop2.ExpenseTotal__c = 60;
        insert partop2;
        
        CSS_Parts_Options__c  partop3 = new CSS_Parts_Options__c ();
        partop3.CSS_Claims__c=claims.Id;
        partop3.Type__c='Parts';
        partop3.Service_Job__c=jo.Id;
        partop3.RecordTypeId=recordtypeid;
        partop3.selected_part__c=true;
        partop3.Quantity__c=3.0;
        partop3.isManual__c=true;
        partop3.Account_Code__c='Testing';
        partop3.Part_Description__c='Testing';
        partop3.Item__c='Belt';
        partop3.Amount__c=300.0;
        partop3.Covered__c=300;
        partop3.Fail_Code__c='Testing';
        partop3.Currency_Type__c='USD';
        partop3.Exchange_Rate_Version__c=23;
        partop3.Exchange_Rate__c=1;
        partop3.Unit_Price__c='50';
        partop3.Amount_Local_Currency__c=50;
         partop3.Sell_Price__c=50;
        partop3.ExpenseTotal__c = 60;
        insert partop3;
        
        CSS_Parts_Options__c  partop4 = new CSS_Parts_Options__c ();
        partop4.CSS_Claims__c=claims.Id;
        partop4.Type__c='Parts';
        partop4.Service_Job__c=jo.Id;
        partop4.RecordTypeId=recordtypeid;
        partop4.selected_part__c=true;
        partop4.Quantity__c=4.0;
        partop4.isManual__c=true;
        partop4.Account_Code__c='Testing';
        partop4.Part_Description__c='Testing';
        partop4.Item__c='Belt';
        partop4.Amount__c=400.0;
        partop4.Covered__c=400;
        partop4.Fail_Code__c='Testing';
        partop4.Currency_Type__c='USD';
        partop4.Exchange_Rate_Version__c=23;
        partop4.Exchange_Rate__c=1;
        partop4.Unit_Price__c='50';
        partop4.Amount_Local_Currency__c=50;
         partop4.Sell_Price__c=50;
        partop4.ExpenseTotal__c = 60;
        insert partop4;
        
        CSS_Parts_Options__c  partop5 = new CSS_Parts_Options__c ();
        partop5.CSS_Claims__c=claims.Id;
        partop5.Type__c='Non Commercial-Travel';
        partop5.Service_Job__c=jo.Id;
        partop5.RecordTypeId=recordtypeid;
        partop5.selected_part__c=true;
        partop5.Quantity__c=5.0;
        partop5.isManual__c=true;
        partop5.Account_Code__c='Testing';
        partop5.Part_Description__c='Testing';
        partop5.Item__c='Belt';
        partop5.Amount__c=500.0;
        partop5.Covered__c=500;
        partop5.Fail_Code__c='Testing';
        partop5.Currency_Type__c='USD';
        partop5.Exchange_Rate_Version__c=23;
        partop5.Exchange_Rate__c=1;
        partop5.Unit_Price__c='50';
        partop5.Amount_Local_Currency__c=50;
         partop5.Sell_Price__c=50;
      partop5.ExpenseTotal__c = 60;
        insert partop5;
        
        CSS_Parts_Options__c  partop6 = new CSS_Parts_Options__c ();
        partop6.CSS_Claims__c=claims.Id;
        partop6.Type__c='Parts';
        partop6.Service_Job__c=jo.Id;
        partop6.RecordTypeId=recordtypeid1;
        partop6.selected_part__c=true;
        partop6.Quantity__c=6.0;
        partop6.isManual__c=true;
        partop6.Account_Code__c='Testing';
        partop6.Part_Description__c='Testing';
        partop6.Item__c='Belt';
        partop6.Amount__c=600.0;
        partop6.Covered__c=600;
        partop6.Fail_Code__c='Testing';
        partop6.Currency_Type__c='USD';
        partop6.Exchange_Rate_Version__c=23;
        partop6.Exchange_Rate__c=1;
        partop6.Unit_Price__c='50';
        partop6.Amount_Local_Currency__c=50;
         partop6.Sell_Price__c=50;
        partop6.ExpenseTotal__c = 60;
        insert partop6;
        Currency_Conversion__c ccc = new Currency_Conversion__c();
        ccc.Bolt_Conversion_Rate__c = 23.8;
        ccc.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
        ccc.Bolt_Version__c = partop.Exchange_Rate_Version__c;
        insert ccc;
        css_header_nav__c head = new css_header_nav__c();
        head.Name = 'test';
        head.RSWButtonEnable__c = true;
        insert head;
        
        list<CSS_JobEventTemporary__c> JETList = new  list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c JET1 = new CSS_JobEventTemporary__c();
        JET1.Attribute1__c = 'POL';
        JET1.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET1.Attribute3__c = 'ZK';
        JET1.key__c = 'AccountCodes';
        JETList.add(JET1);
        insert JETList;
        CSS_JobEventTemporary__c JET2= new CSS_JobEventTemporary__c();
        JET2.Attribute1__c = 'POL';
        JET2.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET2.Attribute3__c = 'ZK';
        JET2.key__c = 'AccountCodes';
        insert JET2;
        List<SelectOption> listoption = new List<SelectOption>();
        listoption.add(new SelectOption('Select One','Select One'));
            //setpartWrapper.add(new claimablesWrapperClass(customPartlstUI.size()+i,null,partsoption.Item__c,partsoption.Part_Description__c,String.valueof(partsoption.Quantity__c),partsoption.amount__c,String.valueof(partsoption.Covered__c),partsoption.Fail_Code__c,partsoption.Account_Code__c,options,options,partsoption.isManual__c,partsoption.Previous_Item__c,partsoption.Unit_Price__c == null ? null : decimal.valueOf(partsoption.Unit_Price__c),false,false,false, null, null, null, null));
                       
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> wrapList = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(2,claims.id, 'Unlisted','N/A','0',100000.0,'coveredPercent','failCode','accountCode', listoption,listoption, true,'previousItem', 0.36, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord2 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Select one','N/A','Quantity',0.23,'coveredPercent','failCode','accountCode', listoption,listoption, true,'previousItem', 0.36, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord3 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Unlisted','N/A','0',0.23,'coveredPercent','failCode','Select One', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord4 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Select one','N/A','',0,'','Select One','Select One', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord5 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Select one','N/A','',null,'',null,null, listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        wrapList.add(wrapRecord1);
        wrapList.add(wrapRecord2);
        wrapList.add(wrapRecord3);
        wrapList.add(wrapRecord4);
        wrapList.add(wrapRecord5);
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();  
        
          //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord4 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(2,claims.id,'technician','unlisted','1',null,null,null,null, null,null,null, null, true, true,true,true,true, null,false,false, null, false, true, false, false, null); 
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(2,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord3 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'test1','Non Commercial-Travel','Meals','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        ttmlWrapList.add(ttmlWrapRecord3);
        // ttmlWrapList.add(ttmlWrapRecord4);
        Map<Id, String> removeIdsMap = new Map<Id, String>();
        removeIdsMap.put(claims.id,'testing');
        
        pagereference ref = new pagereference('/apex/CG_Claimscc');
        test.setCurrentPage(Ref);
        apexpages.currentPage().getparameters().put('id',claims.Id);
        
        CG_CL_ClaimsOtherClaimbles cg=new CG_CL_ClaimsOtherClaimbles();
        list<string> lstAccountCodes = new list<string>();
        lstAccountCodes.add('abc');
        lstAccountCodes.add('def');
        cg.getOCData();
        cg.lstAccountCodes=lstAccountCodes;
        cg.accCodes = listoption;
        cg.claimsObj = claims;
        cg.workJob = jo;
        cg.jobEventTemp = JETList;
        cg.errorDisplay = true;
        cg.towErrorOutputMsg = true;
        cg.dealer = 'test';
        cg.listpartWrapper = wrapList;
        cg.listTTMLWrapper = ttmlWrapList;
        //cg.setduplicatecheck=true;
        cg.saveOtherClaimablesPopup();
        cg.getfailCodeValues();
        cg.saveTTMLPopup();
        cg.closePopup();
        cg.displayPopUp();
        cg.deleteParts();
        cg.AddRow();
        cg.assignedParts = 2;
        cg.removingRow();
        cg.getItems();
        cg.SelectedPartID = 2;
        cg.onChangeofItem();
        cg.selectedRemoveRow = 1;
        cg.deleteTTMLParts();
        cg.saveOtherClaimables();
        cg.removingTTMLRow();
        cg.addTTMLRow();
        cg.selectedRecordRowID=2;	//5
        cg.setAccountCode_Covered();
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList1 = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        //List<SelectOption> failCodeList1= new List<SelectOption>();                                              
        //List<SelectOption> AccCodeList1= new List<SelectOption>();  
           //ttmlWrapperClass(Integer counting,Id ids,String technician,'Meals',String days,String quantity,String unitPrice,String mileage,String hoursTraveled, String expenseTotal,'Select One',String accountCode, String notes, Boolean showDays, Boolean showMileageHT,boolean showUP,boolean showMileage,Boolean accCoverage, List<SelectOption> failCodelst,boolean isManual,Boolean towErrorMsg, List<SelectOption> accCodelst, Boolean mandateaccountcode, boolean isExpenseTotal, boolean isTTMLPartsCovLimitExceed, Boolean isTTMLFailcodeCovLimitExceed, Boolean isTTMLMlsLodPartsCovLimitExceed) {
          CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord4 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(2,claims.id,'technician','Meals','1','2.0','5','123','123', null,'Select One',null, null, true, true,true,true,true, null,false,false, null, false, true, false, false, true); 
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord11 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(2,claims.id,'TestUser','Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord21 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord31 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'test1','Lodging','Meals','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList1.add(ttmlWrapRecord11);
        ttmlWrapList1.add(ttmlWrapRecord21);
        ttmlWrapList1.add(ttmlWrapRecord31);
        ttmlWrapList1.add(ttmlWrapRecord4);
        css_claims__c claims1 = new css_claims__c();
        claims1.CSS_Job__c = jo.id;
        claims1.Customer_Name__c='TestUser';
        claims1.Customer_Code__c='123';
        claims1.ESN__c='56475674';
        claims1.Account__c=acc.id;
        insert claims1;
        cg.fetchAccCodeValues('Meals','ZCK POLICY CLAIMS ZK');
        cg.typeListChangeNewttmlacc();
        css_claims__c claims2 = new css_claims__c();
        claims2.CSS_Job__c = null;
        claims2.Customer_Name__c='TestUser';
        claims2.Customer_Code__c='123';
        claims2.ESN__c='56475674';
        claims2.Account__c=acc.id;
        insert claims2;
        cg.fetchAccCodeValues('Commercial-Travel','ZCK POLICY CLAIMS ZK');
         cg.typeListChangeNewttmlacc();
       cg.fetchAccCodeValues('Non Commercial-Travel','ZCK POLICY CLAIMS ZK'); 
        cg.typeListChangeNewttmlacc();
        cg.fetchAccCodeValues('Towing','ZCK POLICY CLAIMS ZK'); 
        cg.typeListChangeNewttmlacc();
    }   
   
    public static testmethod void TestonchangeofItem1(){
        
        //Check IF condition-->counting == SelectedPartID 
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
       // acc.IAM_Service_Provider_Code__c = '56271';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123456';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_PSN__c psn = new CSS_PSN__c();
        psn.CSS_Claims__c =claims.Id;
        psn.psn__c = '79812345';
        psn.Primary__C = true;
        insert psn;
        
        List<SelectOption> listoption = new List<SelectOption>();
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> wrapList = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id,'Select',null,'',0,'','','', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord2 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id,'Select',null,'',0,'','','', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        wrapList.add(wrapRecord1);
        wrapList.add(wrapRecord2);
        
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        
        Test.startTest(); 
        
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listpartWrapper=wrapList;
        obj.selecteditem = 'Unlisted';
        obj.SelectedPartID = 0;
        obj.saveOtherClaimablesPopup();
        obj.getItems();
        obj.onChangeofItem();
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
    }
    public static testmethod void TestonchangeofItem11(){
        
        //Check IF condition-->counting == SelectedPartID 
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
       // acc.IAM_Service_Provider_Code__c = '56271';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123456';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_PSN__c psn = new CSS_PSN__c();
        psn.CSS_Claims__c =claims.Id;
        psn.psn__c = '79812345';
        psn.Primary__C = true;
        insert psn;
        
        List<SelectOption> listoption = new List<SelectOption>();
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> wrapList = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id,'listed',null,'0',100000.0,'coveredPercent','failCode','accountCode', listoption,listoption, true,'previousItem', 0.36, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord2 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id,'Unlisted',null,'1234',100000.0,'coveredPercent','failCode','accountCode', listoption,listoption, true,'previousItem', 0.36, true, true, true,null,null,null,null);
        wrapList.add(wrapRecord1);
        wrapList.add(wrapRecord2);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord3 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id,'Select One',null,'',0,'','Select One','Select One', listoption,listoption, true,'previousItem', 0.36, true, true, true,null,null,null,null);
        wrapList.add(wrapRecord3);
        
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        
        Test.startTest(); 
        
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        //obj.listpartWrapper=wrapList;
        obj.selecteditem = 'Unlisted';
        obj.SelectedPartID = 0;
        obj.saveOtherClaimablesPopup();
        
        Test.stopTest();
    }
    public static testmethod void TestonchangeofItem2(){
        
        //Check Esle condition--> Unitprice==0 (Currently not working) 
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56272';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123456';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_PSN__c psn = new CSS_PSN__c();
        psn.CSS_Claims__c =claims.Id;
        psn.psn__c = '79812345';
        psn.Primary__C = true;
        insert psn;
        
        List<SelectOption> listoption = new List<SelectOption>();
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> otherlist = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(2,claims.id, 'Unlisted','N/A','0',100000.0,'coveredPercent','failCode','accountCode', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        //CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass otherwrap = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(0,claims.id,'belt', 'SCREW,HEX FLANGE HEAD CAP', '1', 10.1,'100', 'YNEB', '2013 AFT COV A3',  true, 'test', 0.0);
        otherlist.add(wrapRecord1);
        
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        
        Test.startTest(); 
        
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.selecteditem = 'Unlisted';
        obj.SelectedPartID = 1;
        obj.onChangeofItem();
        obj.getItems();
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
    } 
    
    public static testmethod void TestonChangeofFailCode1(){
        
        //Check if condition for onchangeOffailcode --> SelectedFailcode != Select One
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
       // acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
       // acc.IAM_Service_Provider_Code__c = '56272';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.css_job__c=jo.Id;
        claims.Account__c=acc.id;
        insert claims;
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c =claims.Id;
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        solComp1.CoveredOCAmount__c='76';
        solComp1.CoveredPartsQty__c='2';
        solComp1.System_Code__c='TH';
        solComp1.Component_Code__c='AC';
        solComp1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        solCompList.add(solComp1);
        
        
        CSS_Solution_Component__c soCom1 = new CSS_Solution_Component__c();
        soCom1.CSS_Claims__c =claims.Id;
        soCom1.AccountCodeEdit__c='SERVICE TOOL WARRANTY';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        soCom1.CoveredOCAmount__c='80';
        soCom1.CoveredPartsQty__c='';
        socom1.System_Code__c='TH';
        socom1.Component_Code__c = 'AC';
        soCom1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        solCompList.add(soCom1);
        insert solCompList;
        
        
        List<CSS_Parts_Options__c> ltp = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.FailurepartId__c = solcomp1.id;
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Fail_Code__c = 'Turbocharger-THAC';
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        ltp.add(parobj);
        
        CSS_Parts_Options__c  parobj1 = new CSS_Parts_Options__c ();
        parobj1.FailurepartId__c = solcomp1.id;
        parobj1.Type__c='Non Commercial-Travel';
        parobj1.CSS_Claims__c = claims.id;
        parobj1.selected_part__c=true;
        parobj1.Quantity__c=2.0;
        parobj1.Fail_Code__c = 'Turbocharger-THAC';
        parobj1.Unit_Price__c = '56';
        parobj1.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj1;
        ltp.add(parobj1);
        
        
        list<CSS_JobEventTemporary__c> JETList = new  list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c JET1 = new CSS_JobEventTemporary__c();
        JET1.Attribute1__c = 'POL';
        JET1.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET1.Attribute3__c = 'ZK';
        JET1.key__c = 'AccountCodes';
        JETList.add(JET1);
        insert JETList;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.SelectedFailCode = 'Turbocharger-THAC';
        obj.SelectedAccountCode = 'Select One';
        obj.SelectedPartID = 1;
        obj.selectedRecordRowID = 1;
        obj.onChangeofFailCode();
        obj.saveOtherClaimablesPopup();
        obj.populateOCFailCodenAccountCode('Commercial-Travel');
        obj.fetchAccCodeValues('Commercial-Travel','Turbocharger-THAC');
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
    }
    public static testmethod void TestOngetExpenseTotal111(){
        
        //Get Expense Total:type--> towing
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56224';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Towing';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=1.0;
        parobj.Unit_Price__c = '10000';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Towing','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Meals','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord3 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord4 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Lodging','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord3);
        ttmlWrapList.add(ttmlWrapRecord4);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord5 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord5);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.listTTMLWrapper3 = ttmlWrapList;
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
        
    }
    public static testmethod void TestOngetExpenseTotal1111(){
        
        //Get Expense Total:type--> towing
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='test';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56224';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Towing';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=1.0;
        parobj.Unit_Price__c = '10000';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Towing','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Meals','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord3 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord4 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Lodging','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord3);
        ttmlWrapList.add(ttmlWrapRecord4);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord5 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord5);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.listTTMLWrapper3 = ttmlWrapList;
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
        
    }
    public static testmethod void TestonChangeofFailCode2(){
        
        //Check Esle condition for onchangeOffailcode--> SelectedFailcode = 'Select One'
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
       // acc.IAM_Service_Provider_Code__c = '56273';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.css_job__c=jo.Id;
        claims.Account__c=acc.id;
        insert claims;
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c =claims.Id;
        solComp1.AccountCodeType__c='';
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.CoveredOCAmount__c='76';
        solComp1.CoveredPartsQty__c='2';
        solComp1.System_Code__c='WE';
        solComp1.Component_Code__c='QP';
        solComp1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        solCompList.add(solComp1);
        insert solCompList;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.FailurepartId__c = solcomp1.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.SelectedFailCode = 'Select One';
        obj.SelectedAccountCode = 'Select One';
        obj.SelectedPartID = 1;
        obj.selectedRecordRowID = 1;
        obj.onChangeofFailCode();
        //obj.saveOtherClaimablesPopup();
        obj.populateOCFailCodenAccountCode('TOWING');
        obj.fetchAccCodeValues('Non-Commercial-Travel','Turbocharger-THAC');
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
        
    }
   
    public static testmethod void TestonChangeofAccountCode1(){
        
        //onchangeOfAccountcode--->SelectedAccountcode != Select One
        //Check the nested if condition 
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
       // acc.IAM_Service_Provider_Code__c = '56273';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.css_job__c=jo.Id;
        insert claims;
        
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c = claims.Id;
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        solComp1.CoveredPartsQty__c= '100';
        solComp1.CoveredOCAmount__c='9999999';
        solComp1.System_Code__c='TH';
        solComp1.Component_Code__c='AC';
        solcomp1.Failure_Mode__c = 'BT';
        solComp1.CampaignOCPercentage__c = '0';
        solComp1.Selected_Component__c=true;
        solComp1.Type__c = '';
        solCompList.add(solComp1);
        insert solCompList;
        system.debug('solCompListAC'+solCompList);
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.FailurepartId__c = solcomp1.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        List<CSS_JobEventTemporary__c> JETList = new  list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c JET1 = new CSS_JobEventTemporary__c();
        JET1.Attribute1__c = 'POL';
        JET1.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET1.Attribute3__c = 'ZK';
        JET1.key__c = 'AccountCodes';
        JETList.add(JET1);
        insert JETList;
        system.debug('JETListAC'+JETList);
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.SelectedFailCode = 'Turbocharger-THAC';
        obj.SelectedAccountCode = 'ZCK POLICY CLAIMS ZK';
        obj.SelectedPartID = 1;
        obj.selectedRecordRowID = 1;
        obj.onChangeofAccountCode();
        obj.getAccountCodeDropDown('Turbocharger-THAC');
        obj.fetchAccCodeValues('Towing','Turbocharger-THAC');
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
        
    } 
    
    public static testmethod void TestonChangeofAccountCode2(){
        
        //onchangeOfAccountcode--->SelectedAccountcode != Select One & solcomp = 0
        //Check the else condition 
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56271';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.Account__c=acc.id;
        claims.css_job__c=jo.Id;
        insert claims;
        
        
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        

        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.SelectedFailCode = 'Turbocharger-THAC';
        obj.SelectedAccountCode = 'ZCK POLICY CLAIMS ZK';
        obj.SelectedPartID = 1;
        obj.selectedRecordRowID = 1;
        obj.onChangeofAccountCode();
        obj.getAccountCodeDropDown('Turbocharger-THAC');
        obj.fetchAccCodeValues('Lodging','Turbocharger-THAC');
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
        
    } 
    
    public static testmethod void TestonChangeofAccountCode3(){
        
      //onchangeOfAccountcode--->SelectedAccountcode = Select One
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56220';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.css_job__c=jo.Id;
        insert claims;
        
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.SelectedFailCode = 'Turbocharger-THAC';
        obj.SelectedAccountCode = 'Select One';
        obj.SelectedPartID = 1;
        obj.selectedRecordRowID = 1;
        obj.onChangeofAccountCode();
        obj.getAccountCodeDropDown('Turbocharger-THAC');
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
        
    } 
    
    public static testmethod void TestOngetTechnicians(){
        
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56279';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.css_job__c= jo.id;
        claims.Assigned_to__c=userinfo.getUserId();
        claims.Additional_Tech1__c=userinfo.getUserId();
        claims.Additional_Tech2__c=userinfo.getUserId();
        claims.Additional_Tech3__c=userinfo.getUserId();
        claims.Additional_Tech4__c=userinfo.getUserId();
        claims.Additional_Tech5__c=userinfo.getUserId();
        claims.Additional_Tech6__c=userinfo.getUserId();
        claims.Additional_Tech7__c=userinfo.getUserId();
        claims.Additional_Tech8__c=userinfo.getUserId();
        claims.Additional_Tech9__c=userinfo.getUserId();
        insert claims;

        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.getTechnicians();
        obj.fetchAccCodeValues('Towing','WEPQ');
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
        
    } 
    
    public static testmethod void TestOngetExpenseTotal1(){
        
        //Get Expense Total:type--> towing
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56224';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Towing';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=1.0;
        parobj.Unit_Price__c = '10000';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Towing','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Meals','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord3 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(2,claims.id,'TestUser','Towing','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord4 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(3,claims.id,'TestUser','Lodging','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord3);
        ttmlWrapList.add(ttmlWrapRecord4);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.listTTMLWrapper3 = ttmlWrapList;
        system.assertEquals(0,ttmlWrapRecord1.counting, 'SelectedPartID!=counting');
        system.assertEquals('Towing',ttmlWrapRecord1.type, 'Check type');
        obj.getExpenseTotal();
        Test.stopTest();
        
    }
    
    public static testmethod void TestOngetExpenseTotal2(){
        
        //Get Expense Total-type-Commercial travel
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56223';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id, 'TestUser', 'Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id, 'TestUser', 'Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        css_header_nav__c hv = new css_header_nav__c();
        hv.RSWButtonEnable__c = true;
        insert hv;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.getExpenseTotal();
        obj.DealerTypeFlag=false;
        obj.getExpenseTotal();
        Test.stopTest();
        
    }
    public static testmethod void TestOngetExpenseTotal21(){
        
        //Get Expense Total-type-Commercial travel
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56223';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id, 'TestUser', 'Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id, 'TestUser', 'Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.getExpenseTotal();
        obj.DealerTypeFlag=false;
        obj.getExpenseTotal();
        Test.stopTest();
        
    }
    public static testmethod void TestOngetExpenseTotal211(){
        
        //Get Expense Total-type-Commercial travel
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56223';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        //claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id, 'TestUser', 'Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id, 'TestUser', 'Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.getExpenseTotal();
        obj.DealerTypeFlag=false;
        obj.getExpenseTotal();
        Test.stopTest();
        
    }
    public static testmethod void TestOngetExpenseTotal3(){
        
        //Get Expense Total-type-Elsepart(Non commercial);
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56222';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id, 'TestUser', 'Non Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id, 'TestUser', 'Non Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        css_header_nav__c hv = new css_header_nav__c();
        hv.RSWButtonEnable__c = true;
        insert hv;
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.getExpenseTotal();
         obj.DealerTypeFlag=false;
        obj.getExpenseTotal();
        Test.stopTest();
        
    }
    public static testmethod void TestOngetExpenseTotal33(){
        
        //Get Expense Total-type-Elsepart(Non commercial);
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56222';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id, 'TestUser', 'Non Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id, 'TestUser', 'Non Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        css_header_nav__c hv = new css_header_nav__c();
        hv.RSWButtonEnable__c = true;
        insert hv;
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.getExpenseTotal();
         obj.DealerTypeFlag=null;
        obj.getExpenseTotal();
        Test.stopTest();
        
    }
    public static testmethod void TestOngetExpenseTotal31(){
        
        //Get Expense Total-type-Elsepart(Non commercial);
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56222';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '100';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id, 'TestUser', 'Non Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id, 'TestUser', 'Non Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
       
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.getExpenseTotal();
         obj.DealerTypeFlag=false;
        obj.getExpenseTotal();
        Test.stopTest();
        
    }
    public static testmethod void TestOngetExpenseTotal311(){
        
        //Get Expense Total-type-Elsepart(Non commercial);
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56222';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '100';
        claims.SP_INSHOP_LABOR_RATE__c = '100';
        //claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id, 'TestUser', 'Non Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id, 'TestUser', 'Non Commercial-Travel', '1','1.5','10.0', '20', '5', '', 'WEQP', 'ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
       
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.getExpenseTotal();
         obj.DealerTypeFlag=false;
        obj.getExpenseTotal();
        Test.stopTest();
        
    }
    public static testmethod void TestOntypeListChangeManualClaim1(){
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56226';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = null;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c =claims.Id;
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        solComp1.CoveredOCAmount__c='76';
        solComp1.CoveredPartsQty__c='2';
        solComp1.System_Code__c='WE';
        solComp1.Component_Code__c='QP';
        solComp1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        solCompList.add(solComp1);
        
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.CSS_Claims__c =claims.Id;
        solComp2.AccountCodeEdit__c='New Engine Warranty 67';
        solComp2.AccountCodeType__c='';
        solComp2.AccountCode__c = '';
        solComp2.CoveredOCAmount__c='76';
        solComp2.CoveredPartsQty__c='2';
        solComp2.System_Code__c='WE';
        solComp2.Component_Code__c = 'QP';
        solComp2.Selected_Component__c = true;
        solComp2.Fault_Code__c = 'Turbo charger';
        solComp2.Fail_Code_Editable__c = '';
        solCompList.add(solComp2);
        insert solCompList;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.SelectedPartID = 0;
        obj.SelectedType = 'Select One';
        obj.getTTMLtype();
        obj.typeListChange();
        Test.stopTest();
    }
    public static testmethod void TestOntypeListChangeManualClaim11(){
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56226';
        acc.CMI_Account_Status__c = 'Active';
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c =claims.Id;
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        solComp1.CoveredOCAmount__c='76';
        solComp1.CoveredPartsQty__c='2';
        solComp1.System_Code__c='WE';
        solComp1.Component_Code__c='QP';
        solComp1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        solCompList.add(solComp1);
        
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.CSS_Claims__c =claims.Id;
        solComp2.AccountCodeEdit__c='New Engine Warranty 67';
        solComp2.AccountCodeType__c='';
        solComp2.AccountCode__c = '';
        solComp2.CoveredOCAmount__c='76';
        solComp2.CoveredPartsQty__c='2';
        solComp2.System_Code__c='WE';
        solComp2.Component_Code__c = 'QP';
        solComp2.Selected_Component__c = true;
        solComp2.Fault_Code__c = 'Turbo charger';
        solComp2.Fail_Code_Editable__c = '';
        solCompList.add(solComp2);
        insert solCompList;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.SelectedPartID = 0;
        obj.SelectedType = 'Select One';
        obj.DealerTypeFlag= true;
        obj.getTTMLtype();
        obj.typeListChange();
        obj.DealerTypeFlag= false;
        obj.getTTMLtype();
        obj.typeListChange();
        Test.stopTest();
    }
    public static testmethod void TestOntypeListChangeManualClaim111(){
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56226';
        acc.CMI_Account_Status__c = 'Active';
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = jo.id;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c =claims.Id;
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        solComp1.CoveredOCAmount__c='76';
        solComp1.CoveredTravelBaseFareAmt__c='76';
        solComp1.CoveredTravelLabor__c='76';
        solComp1.CoveredPartsQty__c='2';
        solComp1.System_Code__c='WE';
        solComp1.Component_Code__c='QP';
        solComp1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        solCompList.add(solComp1);
        
       /* CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.CSS_Claims__c =claims.Id;
        solComp2.AccountCodeEdit__c='New Engine Warranty 67';
        solComp2.AccountCodeType__c='';
        solComp2.AccountCode__c = '';
        solComp2.CoveredOCAmount__c='76';
        solComp2.CoveredPartsQty__c='2';
        solComp2.System_Code__c='WE';
        solComp2.Component_Code__c = 'QP';
        solComp2.Selected_Component__c = true;
        solComp2.Fault_Code__c = 'Turbo charger';
        solComp2.Fail_Code_Editable__c = '';
        solCompList.add(solComp2);*/
        insert solCompList;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        css_header_nav__c head = new css_header_nav__c();
        head.Name = 'test';
        head.RSWButtonEnable__c = true;
        insert head;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.SelectedPartID = 0;
        obj.CID = claims.Id;
        obj.SelectedType = 'Select One';
        obj.DealerTypeFlag= true;
        obj.getTTMLtype();
        obj.typeListChange();
        obj.DealerTypeFlag= false;
        obj.getTTMLtype();
        obj.typeListChange();
        Test.stopTest();
    }
    public static testmethod void TestOntypeListChangeManualClaim2(){
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56230';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = null;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        //  List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c =claims.Id;
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        solComp1.CoveredOCAmount__c='76';
        solComp1.CoveredPartsQty__c='2';
        solComp1.System_Code__c='WE';
        solComp1.Component_Code__c='QP';
        solComp1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        // solCompList.add(solComp1);
        
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.CSS_Claims__c =claims.Id;
        solComp2.AccountCodeEdit__c='New Engine Warranty 67';
        solComp2.AccountCodeType__c='';
        solComp2.AccountCode__c = '';
        solComp2.CoveredOCAmount__c='76';
        solComp2.CoveredPartsQty__c='2';
        solComp2.System_Code__c='WE';
        solComp2.Component_Code__c = 'QP';
        solComp2.Selected_Component__c = true;
        solComp2.Fault_Code__c = 'Turbo charger';
        solComp2.Fail_Code_Editable__c = '';
        //   solCompList.add(solComp2);
        //   insert solCompList;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.getTTMLtype();
        obj.typeListChange();
        Test.stopTest();
    }
    
    public static testmethod void TestOntypeListChangeManualClaim3(){
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56232';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.CSS_Travel_Rate__c = '10';
        claims.SP_INSHOP_LABOR_RATE__c = '1';
        claims.css_job__c = null;
        insert claims;
        
        CSS_Parts_Options__c  parobj = new CSS_Parts_Options__c ();
        parobj.Type__c='Non Commercial-Travel';
        parobj.CSS_Claims__c = claims.id;
        parobj.selected_part__c=true;
        parobj.Quantity__c=2.0;
        parobj.Unit_Price__c = '56';
        parobj.Amount__c = decimal.valueOf(parobj.Unit_Price__c)*(parobj.Quantity__c);
        insert parobj;
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c =claims.Id;
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        solComp1.CoveredOCAmount__c='76';
        solComp1.CoveredPartsQty__c='2';
        solComp1.System_Code__c='WE';
        solComp1.Component_Code__c='QP';
        solComp1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        solCompList.add(solComp1);
        
        CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
        solComp2.CSS_Claims__c =claims.Id;
        solComp2.AccountCodeEdit__c='New Engine Warranty 67';
        solComp2.AccountCodeType__c='';
        solComp2.AccountCode__c = '';
        solComp2.CoveredOCAmount__c='76';
        solComp2.CoveredPartsQty__c='2';
        solComp2.System_Code__c='WE';
        solComp2.Component_Code__c = 'QP';
        solComp2.Selected_Component__c = true;
        solComp2.Fault_Code__c = 'Turbo charger';
        solComp2.Fail_Code_Editable__c = '';
        solCompList.add(solComp2);
        insert solCompList;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        Id recTypeIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType,'TTML'); 
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listTTMLWrapper = ttmlWrapList;
        obj.SelectedPartID = 0;
        obj.getTTMLtype();
        obj.typeListChange();
        Test.stopTest();
    }
    
    public static testmethod void TestOngetAccCodesonChngofFailCode1(){
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56233';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.css_job__c = null;
        insert claims;
        
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>(); 
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.AccountCode__c='Testing';
        solcomp.Selected_Component__c=true;
        solcomp.Fail_Code_Editable__c='Testing';
        solcomp.Type__c = 'Testing';
        solcomp.AccountCodeType__c ='Testing1';
        solCompList.add(solcomp);
        
        css_solution_component__c solcomp1 = new css_solution_component__c();
        solcomp1.CSS_Claims__c=claims.Id;
        solcomp1.AccountCode__c='Testing1';
        solcomp1.AccountCodeType__c ='Testing1';
        solcomp1.Selected_Component__c=true;
        solcomp1.Fail_Code_Editable__c='Testing';
        solcomp1.Type__c = 'Testing';
        solCompList.add(solcomp1);
        insert solCompList;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','1.5','10.0','20','5', '','WEQP','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        system.debug('ttmlWrapList'+ttmlWrapList);
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.SelectedFailCode ='Testing';
        //  obj.SelectedPartID = 0;
        obj.listTTMLWrapper = ttmlWrapList;
        obj.getAccCodesonChngofFailCode();
        Test.stopTest();
    }
    
    public static testmethod void TestOngetAccCodesonChngofFailCode2(){
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
       // acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56234';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.Account__c=acc.id;
        claims.css_job__c = null;
        insert claims;
        
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>(); 
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.AccountCode__c='Select One';
        solcomp.Selected_Component__c=true;
        solcomp.Fail_Code_Editable__c='Testing';
        solcomp.Type__c = 'Testing';
        solCompList.add(solcomp);
        
        css_solution_component__c solcomp1 = new css_solution_component__c();
        solcomp1.CSS_Claims__c=claims.Id;
        solcomp1.AccountCode__c='Select One';
        solcomp1.Selected_Component__c=true;
        solcomp1.Fail_Code_Editable__c='Testing';
        solcomp1.Type__c = 'Testing';
        solCompList.add(solcomp1);
        insert solCompList;
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Commercial-Travel','1','1.5','10.0','20','5', '','Select One','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','1.5','10.0','20','5', '','Select One','ZCK POLICY CLAIMS ZK','notes',true,true,true,true,true,failCodeList,true,true,AccCodeList,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(0,claims.id,'TestUser','Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        //obj.SelectedFailCode = 'Select One';
        obj.SelectedFailCode = 'Turbocharger-THAC';
        obj.SelectedPartID = 0;
        obj.listTTMLWrapper = ttmlWrapList;
        obj.getAccCodesonChngofFailCode();
        Test.stopTest();
    }
    
    public static testmethod void Testonfetchfailcodes1(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56235';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.css_job__c = jo.id;
        insert claims;
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c =claims.Id;
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        solComp1.CoveredOCAmount__c='76';
        solComp1.CoveredPartsQty__c='2';
        solComp1.System_Code__c='WE';
        solComp1.Component_Code__c='QP';
        solComp1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        solcomp1.Type__c = 'Campaign';
        solcomp1.CSS_CoverageType__c = 'OTH';
        solCompList.add(solComp1);
        insert solCompList;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchfailCodeValuesNew('Commercial-Travel');
        Test.stopTest();
        
    }
    
    public static testmethod void Testonfetchfailcodes2(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56235';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.Account__c=acc.id;
        claims.css_job__c = jo.id;
        insert claims;
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c =claims.Id;
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        solComp1.CoveredOCAmount__c='76';
        solComp1.CoveredPartsQty__c='2';
        solComp1.System_Code__c='WE';
        solComp1.Component_Code__c='QP';
        solComp1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        solcomp1.Type__c = 'Campaign';
        solcomp1.CSS_CoverageType__c = null;
        solcomp1.CampaignTravelPercentage__c = '100';
        solCompList.add(solComp1);
        insert solCompList;
        
        
        CSS_JobEventTemporary__c JET1 = new CSS_JobEventTemporary__c();
        JET1.Attribute1__c = 'POL';
        JET1.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET1.Attribute3__c = 'ZK';
        JET1.key__c = 'AccountCodes';
        insert JET1;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchfailCodeValuesNew('Commercial-Travel');
        Test.stopTest();
    }
    
    public static testmethod void Testonfetchfailcodes3(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
       // acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56236';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.css_job__c = jo.id;
        insert claims;
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c =claims.Id;
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        solComp1.CoveredOCAmount__c='76';
        solComp1.CoveredPartsQty__c='2';
        solComp1.System_Code__c='WE';
        solComp1.Component_Code__c='QP';
        solComp1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        solcomp1.Type__c = 'Campaign';
        solcomp1.CSS_CoverageType__c = '';
        solcomp1.CoveredTravelBaseFareAmt__c = '100';
        solcomp1.CampaignTravelPercentage__c = '100';
        solCompList.add(solComp1);
        insert solCompList;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchfailCodeValuesNew('Commercial-Travel');
        Test.stopTest();
        
    }
    
    public static testmethod void Testonfetchfailcodes4(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
       // acc.IAM_Service_Provider_Code__c = '56237';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.css_job__c = jo.id;
        insert claims;
        
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
        solComp1.CSS_Claims__c =claims.Id;
        solComp1.AccountCodeEdit__c='ZCK POLICY CLAIMS ZK';
        solComp1.AccountCodeType__c='';
        solComp1.AccountCode__c = '';
        solComp1.CoveredOCAmount__c='76';
        solComp1.CoveredPartsQty__c='2';
        solComp1.System_Code__c='WE';
        solComp1.Component_Code__c='QP';
        solComp1.Selected_Component__c=true;
        solComp1.Fail_Code_Editable__c = '';
        solcomp1.Type__c = 'Campaign';
        solcomp1.CSS_CoverageType__c = '';
        solcomp1.CampaignTowingPercentage__c = '100';
        solCompList.add(solComp1);
        insert solCompList;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchfailCodeValuesNew('Towing');
        Test.stopTest();
        
    }
    
    public static testmethod void Testonfetchfailcodes5(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56238';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.css_job__c = jo.id;
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
        solcomp.CoveredTravelBaseFareAmt__c = '100';
        solcomp.CoveredTravelLabor__c = '100';
        insert solcomp;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchfailCodeValuesNew('Commercial-Travel');
        Test.stopTest();
        
    }
    
    public static testmethod void Testonfetchfailcodes6(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56241';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.css_job__c = jo.id;
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
        solcomp.CoveredTravelMiles__c = '100';
        solcomp.CoveredTravelLabor__c = '100';
        insert solcomp;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchfailCodeValuesNew('Non Commercial-Travel');
        Test.stopTest();
        
    }
    
    public static testmethod void Testonfetchfailcodes7(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56242';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.css_job__c = jo.id;
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
        solcomp.Type__c = 'Towing';
        solcomp.CoveredTowingMiles__c = '100';
        insert solcomp;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchfailCodeValuesNew('Towing');
        Test.stopTest();
        
    }
    
    public static testmethod void Testonfetchfailcodes8(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Name__c='Oliver Trucking';
        jo.Customer_Code__c='123';
        jo.ESN__c='79812345';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56243';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123';
        claims.css_job__c = jo.id;
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
        solcomp.Type__c = 'Meals';
        solcomp.CoveredMealsLodgingAmt__c = '100';
        insert solcomp;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchfailCodeValuesNew('Meals');
        Test.stopTest();
        
    }
    
    public static testmethod void TestOnfetchAccountCodeValue1(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
       // acc.IAM_Service_Provider_Code__c = '56244';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
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
        solcomp.CSS_CoverageType__c = 'OTH';
        insert solcomp;
        
        CSS_JobEventTemporary__c JET1 = new CSS_JobEventTemporary__c();
        JET1.Attribute1__c = 'POL';
        JET1.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET1.Attribute3__c = 'ZK';
        JET1.key__c = 'AccountCodes';
        insert JET1;
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchAccCodeValues('Commercial-Travel','Testing');
        Test.stopTest();
    }
    
    public static testmethod void TestOnfetchAccountCodeValue2(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
       // acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56245';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
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
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchAccCodeValues('Commercial-Travel','Testing');
        Test.stopTest();
    }
    
    public static testmethod void TestOnfetchAccountCodeValue3(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
       // acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56246';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
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
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchAccCodeValues('Non Commercial-Travel','Testing');
        Test.stopTest();
    }
    
    public static testmethod void TestOnfetchAccountCodeValue4(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56247';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
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
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchAccCodeValues('Towing','Testing');
        Test.stopTest();
    }
    
    public static testmethod void TestOnfetchAccountCodeValue5(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56248';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
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
        solcomp.Type__c = 'Meals';
        solcomp.CampaignTravelPercentage__c = '100';
        solcomp.CSS_CoverageType__c = '';
        solcomp.CoveredMealsLodgingAmt__c='10';
        insert solcomp;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchAccCodeValues('Meals','Testing');
        Test.stopTest();
    }
    
    public static testmethod void TestOnfetchAccountCodeValue6(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56249';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
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
        solcomp.Type__c = 'Campaign';
        solcomp.CampaignTravelPercentage__c = '100';
        insert solcomp;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchAccCodeValues('Commercial-Travel','Testing');
        Test.stopTest();
    }
    
    public static testmethod void TestOnfetchAccountCodeValue7(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56251';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
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
        solcomp.Type__c = 'Campaign';
        solcomp.CampaignTowingPercentage__c = '100';
        insert solcomp;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchAccCodeValues('Towing','Testing');
        Test.stopTest();
    }
    
    public static testmethod void TestOnfetchAccountCodeValue8(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56252';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
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
        solcomp.AccountCodeEdit__c = 'testing';
        solcomp.AccountCode__c=null;
        solcomp.Solutions__c=sol.id;
        solcomp.Selected_Component__c=true;
        solcomp.Fail_Code_Editable__c='Testing';
        solcomp.CSS_CoverageType__c = null;
        insert solcomp;
        
        list<CSS_JobEventTemporary__c> JETList = new  list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c JET1 = new CSS_JobEventTemporary__c();
        JET1.Attribute1__c = 'POL';
        JET1.key__c = 'AccountCodes';
        JETList.add(JET1);
        insert JETList;
        
        Test.startTest(); 
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.fetchAccCodeValues('Testing','Testing');
        Test.stopTest();
    }
    
    public static testmethod void TestOnsaveOtherClaimablesPopup2(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56252';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        insert claims;
        
        List<SelectOption> listoption = new List<SelectOption>();
        
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> wrapList = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Unlisted','N/A','quantity',0.23,'coveredPercent','failCode','Select One', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord2 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Select One','PartDescription','quantity',0.23,'coveredPercent','failCode','Select One', listoption, listoption,true,'previousItem', 0, true, true, true,null,null,null,null);
        wrapList.add(wrapRecord1);
        wrapList.add(wrapRecord2);
        //  CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(0,claims.id,'belt', 'SCREW,HEX FLANGE HEAD CAP', '1', 10.1,'100', 'YNEB', '2013 AFT COV A3',  true, 'test', 10.1);
        //  CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord2 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(1,claims.id,'belt', 'SCREW,HEX FLANGE HEAD CAP', '1', 10.1,'100', 'YNEB', null,  true, 'test', 10.1);
        
        //  wrapList.add(wrapRecord2);
        
        Test.startTest(); 
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listpartWrapper=wrapList;
        obj.saveOtherClaimablesPopup();
        Test.stopTest();
        
    }
    
    public static testmethod void TestOnsaveOtherClaimablesPopup4(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56253';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        insert claims;
        
        List<SelectOption> listoption = new List<SelectOption>();
        
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> wrapList = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Unlisted','N/A','quantity',0.23,'coveredPercent','failCode','Select One', listoption,listoption,true,'previousItem', 0, true, true, true,null,null,null,null);
        wrapList.add(wrapRecord1);
        
        
        //  CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(0,claims.id,'belt', 'SCREW,HEX FLANGE HEAD CAP', '1', 10.1,'100', 'YNEB', '2013 AFT COV A3',  true, 'test', 10.1);
        //  CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord2 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(1,claims.id,'belt', 'SCREW,HEX FLANGE HEAD CAP', '1', 10.1,'100', 'YNEB', null,  true, 'test', 10.1);
        
        //  wrapList.add(wrapRecord2);
        
        Test.startTest(); 
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listpartWrapper=wrapList;
        obj.saveOtherClaimablesPopup();
        Test.stopTest();
        
    }
    
    public static testmethod void TestOnsaveOtherClaimablesPopup3(){
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56255';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Account__c=acc.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        insert claims;
        List<SelectOption> listoption = new List<SelectOption>();
        
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> wrapList = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Unlisted','N/A','quantity',0.23,'coveredPercent','failCode','Select One', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord2 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Select One','PartDescription','quantity',0.23,'coveredPercent','failCode','Select One', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        wrapList.add(wrapRecord1);
        wrapList.add(wrapRecord2);
        //   CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(0,claims.id,'Unlisted', 'N/A', '1', 10.1,'100', 'YNEB', '2013 AFT COV A3',  true, 'test', 10.1);
        //   CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord2 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(0,claims.id,'Unlisted', 'N/A', '1', 10.1,'100', 'YNEB', '2013 AFT COV A3',  true, 'test', 10.1);
        // wrapList.add(wrapRecord2);
        
        
        
        Test.startTest(); 
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listpartWrapper=wrapList;
        obj.saveOtherClaimablesPopup();
        Test.stopTest();
        
    }
    
    public static testmethod void TestOngetAllTTMLPartsData1(){
        
        //GetAllTTMLParts--> Type__c = Meals
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56256';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
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
        insert solcomp;
        
        
        
        list<CSS_Parts_Options__c> POList = new list<CSS_Parts_Options__c>();
        
        CSS_Parts_Options__c  partop = new CSS_Parts_Options__c ();
        partop.CSS_Claims__c=claims.Id;
        partop.Type__c='Meals';
        partop.Service_Job__c=jo.Id;
        partop.selected_part__c=true;
        partop.RecordTypeId = recordtypeid;
        partop.Quantity__c=.0;
        partop.isManual__c=true;
        partop.Account_Code__c='Testing';
        partop.Part_Description__c='Testing';
        partop.Item__c='test';
        partop.Amount__c= 0.0;
        partop.Covered__c=0;
        partop.Fail_Code__c='Testing';
        partop.Currency_Type__c='USD';
        partop.Exchange_Rate_Version__c=23;
        partop.Exchange_Rate__c=1;
        partop.Unit_Price__c='50';
         partop.Sell_Price__c=50;
        partop.Amount_Local_Currency__c=50;
        partop.ExpenseTotal__c = 60;
        POList.add(partop);
        insert POList;
        
         Currency_Conversion__c ccc = new Currency_Conversion__c();
        ccc.Bolt_Conversion_Rate__c = 23.8;
        ccc.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
        ccc.Bolt_Version__c = partop.Exchange_Rate_Version__c;
        insert ccc;
        
        Test.startTest(); 
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.ttmlPartlstUI = POList;
        obj.getAllTTMLPartsData();
        Test.stopTest();
    }
    
    public static testmethod void TestOngetAllTTMLPartsData2(){
        
        //GetAllTTMLParts--> Type__c = Commercial-Travel
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56257';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
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
        insert solcomp;
        
        
        
        list<CSS_Parts_Options__c> POList = new list<CSS_Parts_Options__c>();
        
        CSS_Parts_Options__c  partop = new CSS_Parts_Options__c ();
        partop.CSS_Claims__c=claims.Id;
        partop.Type__c='Commercial-Travel';
        partop.Service_Job__c=jo.Id;
        partop.selected_part__c=true;
        partop.RecordTypeId = recordtypeid;
        partop.Quantity__c=.0;
        partop.isManual__c=true;
        partop.Account_Code__c='Testing';
        partop.Part_Description__c='Testing';
        partop.Item__c='test';
        partop.Amount__c= 0.0;
        partop.Covered__c=0;
        partop.Fail_Code__c='Testing';
        partop.Currency_Type__c='USD';
        partop.Exchange_Rate_Version__c=23;
        partop.Exchange_Rate__c=1;
        partop.Unit_Price__c='50';
        partop.Amount_Local_Currency__c=50;
         partop.Sell_Price__c=50;
        partop.ExpenseTotal__c = 60;
        POList.add(partop);
        
        insert POList;
        
         Currency_Conversion__c ccc = new Currency_Conversion__c();
        ccc.Bolt_Conversion_Rate__c = 23.8;
        ccc.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
        ccc.Bolt_Version__c = partop.Exchange_Rate_Version__c;
        insert ccc;
        
        Test.startTest(); 
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.ttmlPartlstUI = POList;
        obj.getAllTTMLPartsData();
        Test.stopTest();
    }
    
    public static testmethod void TestOngetAllTTMLPartsData3(){
        
        //GetAllTTMLParts--> Type__c = Non Commercial-Travel
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56258';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;        
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
        insert solcomp;
        
        
        
        list<CSS_Parts_Options__c> POList = new list<CSS_Parts_Options__c>();
        
        CSS_Parts_Options__c  partop = new CSS_Parts_Options__c ();
        partop.CSS_Claims__c=claims.Id;
        partop.Type__c='Non Commercial-Travel';
        partop.Service_Job__c=jo.Id;
        partop.selected_part__c=true;
        partop.RecordTypeId = recordtypeid;
        partop.Quantity__c=.0;
        partop.isManual__c=true;
        partop.Account_Code__c='Testing';
        partop.Part_Description__c='Testing';
        partop.Item__c='test';
        partop.Amount__c= 0.0;
        partop.Covered__c=0;
        partop.Fail_Code__c='Testing';
        partop.Currency_Type__c='USD';
        partop.Exchange_Rate_Version__c=23;
        partop.Exchange_Rate__c=1;
        partop.Unit_Price__c='50';
        partop.Amount_Local_Currency__c=50;
         partop.Sell_Price__c=50;
        partop.ExpenseTotal__c = 60;
        POList.add(partop);
        insert POList;
         Currency_Conversion__c ccc = new Currency_Conversion__c();
        ccc.Bolt_Conversion_Rate__c = 23.8;
        ccc.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
        ccc.Bolt_Version__c = partop.Exchange_Rate_Version__c;
        insert ccc;
        Test.startTest(); 
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.ttmlPartlstUI = POList;
        obj.getAllTTMLPartsData();
        Test.stopTest();
    }
    
    public static testmethod void TestOngetallCustomPartsData1()
    {
        
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56259';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='TestUser';
        claims.Account__c=acc.id;
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        claims.css_job__c = jo.id;
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
        insert solcomp;
        
        
        list<CSS_Parts_Options__c> POList = new list<CSS_Parts_Options__c>();
        
        CSS_Parts_Options__c  partop = new CSS_Parts_Options__c ();
        partop.CSS_Claims__c=claims.Id;
        partop.Type__c='';
        partop.Service_Job__c=jo.Id;
        partop.selected_part__c=true;
        partop.RecordTypeId = recordtypeid;
        partop.Quantity__c=.0;
        partop.isManual__c=true;
        partop.Account_Code__c='Testing';
        partop.Part_Description__c='Testing';
        partop.Item__c='belt';
        partop.Amount__c= 0.0;
        partop.Covered__c=0;
        partop.Fail_Code__c='Testing';
        partop.Currency_Type__c='USD';
        partop.Exchange_Rate_Version__c=23;
        partop.Exchange_Rate__c=1;
        partop.Unit_Price__c='50';
        partop.Amount_Local_Currency__c=50;
         partop.Sell_Price__c=50;
        partop.ExpenseTotal__c = 60;
        POList.add(partop);
        insert POList;
        Currency_Conversion__c ccc = new Currency_Conversion__c();
        ccc.Bolt_Conversion_Rate__c = 23.8;
        ccc.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
        ccc.Bolt_Version__c = partop.Exchange_Rate_Version__c;
        insert ccc;
        Test.startTest(); 
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.customPartlstUI = POList;
        obj.getallCustomPartsData(false);
        Test.stopTest();
    }
    
     static testmethod void TestMethod20()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        update JO;
        
        css_claims__c claims = new css_claims__c();
        claims.CSS_Job__c = jo.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.CSS_Claims__c = claims.Id;
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
        solcomp1.CSS_Claims__c = claims.Id;
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
        pref = new PageReference('/'+claims.id);
        pref.getParameters().put('id',claims.id);
        Test.setCurrentPage(pref);
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord1);

        
        test.startTest();
        
        CG_CL_ClaimsOtherClaimbles otherclaim = new CG_CL_ClaimsOtherClaimbles();
        string accountcode = otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode = otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid = otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 = otherclaim.assignedParts = 1;
        otherclaim.SelectedItem = 'TOWING';
        otherclaim.getfailcodeDropDownBasedOnItem('TOWING',1);
        otherclaim.fetchfailCodeValuesNew('TOWING');
        otherclaim.fetchAccCodeValues('TOWING','Intake Manifold Pressure/Temperature Sensor-EEBT');
        otherclaim.listTTMLWrapper = ttmlWrapList;
        otherclaim.populateTTMLFailCodenAccountCode();
        
        CG_CL_ClaimsOtherClaimbles otherclaim1 = new CG_CL_ClaimsOtherClaimbles();
        string accountcode1 = otherclaim1.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode1 =  otherclaim1.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid2 = otherclaim1.SelectedPartID = 1;
        Integer selctedpartid3 = otherclaim1.assignedParts = 1;
        otherclaim1.SelectedItem = 'COMMERCIAL TRAVEL';
        otherclaim1.getfailcodeDropDownBasedOnItem('COMMERCIAL TRAVEL',1);
        otherclaim1.fetchfailCodeValuesNew('COMMERCIAL TRAVEL');
        otherclaim1.fetchAccCodeValues('COMMERCIAL TRAVEL','Intake Manifold Pressure/Temperature Sensor-EEBT');
        otherclaim1.listTTMLWrapper = ttmlWrapList;
        otherclaim1.populateTTMLFailCodenAccountCode();
        
        
        CG_CL_ClaimsOtherClaimbles otherclaim2 = new CG_CL_ClaimsOtherClaimbles();
        string accountcode2 = otherclaim2.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode2 = otherclaim2.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid55= otherclaim2.SelectedPartID = 1;
        otherclaim2.SelectedItem = 'MISC';
        otherclaim2.getfailcodeDropDownBasedOnItem('MISC',1);
        otherclaim2.fetchfailCodeValuesNew('MISC');
        otherclaim2.fetchAccCodeValues('MISC','Intake Manifold Pressure/Temperature Sensor-EEBT');
        otherclaim2.listTTMLWrapper = ttmlWrapList;
        otherclaim2.populateTTMLFailCodenAccountCode();
        test.stopTest();
        
    }
    
    static testmethod void TestMethod21()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        update JO;
        
        css_claims__c claims = new css_claims__c();
        claims.CSS_Job__c = jo.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.CSS_Claims__c = claims.Id;
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
        solcomp1.CSS_Claims__c = claims.Id;
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
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord1);

        
        PageReference pref;
        pref = new PageReference('/'+claims.id);
        pref.getParameters().put('id',claims.id);
        Test.setCurrentPage(pref);
        
        test.startTest();
        
        CG_CL_ClaimsOtherClaimbles otherclaim = new CG_CL_ClaimsOtherClaimbles();
        string accountcode = otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode = otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid = otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 = otherclaim.assignedParts = 1;
        otherclaim.SelectedItem = 'TOWING';
        otherclaim.getfailcodeDropDownBasedOnItem('TOWING',1);
        otherclaim.fetchfailCodeValuesNew('TOWING');
        otherclaim.fetchAccCodeValues('TOWING','Intake Manifold Pressure/Temperature Sensor-EEBT');
        otherclaim.listTTMLWrapper = ttmlWrapList;
        otherclaim.populateTTMLFailCodenAccountCode();
        
        CG_CL_ClaimsOtherClaimbles otherclaim1 = new CG_CL_ClaimsOtherClaimbles();
        string accountcode1 = otherclaim1.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode1 =  otherclaim1.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid2 = otherclaim1.SelectedPartID = 1;
        Integer selctedpartid3 = otherclaim1.assignedParts = 1;
        otherclaim1.SelectedItem = 'COMMERCIAL TRAVEL';
        otherclaim1.getfailcodeDropDownBasedOnItem('COMMERCIAL TRAVEL',1);
        otherclaim1.fetchfailCodeValuesNew('COMMERCIAL TRAVEL');
        otherclaim1.fetchAccCodeValues('COMMERCIAL TRAVEL','Intake Manifold Pressure/Temperature Sensor-EEBT');
        otherclaim1.listTTMLWrapper = ttmlWrapList;
        otherclaim1.populateTTMLFailCodenAccountCode();
        
        
         CG_CL_ClaimsOtherClaimbles otherclaim2 = new CG_CL_ClaimsOtherClaimbles();
        string accountcode6 = otherclaim2.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode7 = otherclaim2.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid11 = otherclaim2.SelectedPartID = 1;
        otherclaim2.SelectedItem = 'MISC';
        otherclaim2.getfailcodeDropDownBasedOnItem('MISC',1);
        otherclaim2.fetchfailCodeValuesNew('MISC');
        otherclaim2.fetchAccCodeValues('MISC','Intake Manifold Pressure/Temperature Sensor-EEBT');
        otherclaim2.listTTMLWrapper = ttmlWrapList;
        otherclaim2.populateTTMLFailCodenAccountCode();
        
        test.stopTest();
        
    }
    
    static testmethod void TM1()
    {
        
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        insert acc;
        
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        claims.Account__c=acc.id;
        insert claims;
        
         css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.AccountCode__c='';
        solcomp.AccountCodeEdit__c = 'test';
        solcomp.Selected_Component__c=true;
        solcomp.Fail_Code_Editable__c='Testing';
        insert solcomp;
        
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        
        
        CSS_Parts_Options__c  partop = new CSS_Parts_Options__c ();
        partop.CSS_Claims__c=claims.Id;
        partop.Type__c='Parts';
        partop.RecordTypeId=recordtypeid;
        partop.selected_part__c=true;
        partop.Quantity__c=.0;
        partop.isManual__c=true;
        partop.Account_Code__c='Testing';
        partop.Part_Description__c='Testing';
        partop.Item__c='Belt';
        partop.Amount__c= 0.0;
        partop.Covered__c=00;
        partop.Fail_Code__c='Testing';
        partop.Currency_Type__c='USD';
        partop.Exchange_Rate_Version__c=23;
        partop.Exchange_Rate__c=1;
        partop.Unit_Price__c='50';
        partop.Amount_Local_Currency__c=50;
        partop.Sell_Price__c=50;
        partop.ExpenseTotal__c = 60;
        insert partop;
        
        
        List<SelectOption> listoption = new List<SelectOption>();
        listoption.add(new SelectOption('Select One','Select One'));
        
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> wrapList = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(2,claims.id, 'Unlisted','N/A','0',100000.0,'coveredPercent','failCode','accountCode', listoption,listoption, true,'previousItem', 0.36, true, true, true,null,null,null,null);
        wrapList.add(wrapREcord1); 
           
        PageReference pref;
        pref = new PageReference('/'+claims.id);
        pref.getParameters().put('id',claims.id);
        Test.setCurrentPage(pref);
         
         Test.startTest();
         CG_CL_ClaimsOtherClaimbles cg = new CG_CL_ClaimsOtherClaimbles();
         cg.listpartWrapper = wrapList;
         cg.listpartWrapper2 = wrapList;
         cg.assignedParts = 2;
         cg.removingRow();
         Test.stopTest();
         
        
    }
    
    public static testmethod void TestonchangeofItem3()
    {
        
       
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123456';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_PSN__c psn = new CSS_PSN__c();
        psn.CSS_Claims__c =claims.Id;
        psn.psn__c = '79812345';
        psn.Primary__C = true;
        insert psn;
        
        List<SelectOption> listoption = new List<SelectOption>();
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> otherlist = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(2,claims.id, 'Unlisted','N/A','0',100000.0,'coveredPercent','failCode','accountCode', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        otherlist.add(wrapRecord1);
        
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        
        Test.startTest(); 
        
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listpartWrapper = otherlist;
        obj.selecteditem = 'Misc';
        obj.SelectedPartID = 2;
        obj.onChangeofItem();
        Test.stopTest();
    } 
    
    static testmethod void TestMethod22()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        update JO;
        
        css_claims__c claims = new css_claims__c();
        claims.CSS_Job__c = jo.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.CSS_Claims__c = claims.Id;
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
        pref = new PageReference('/'+claims.id);
        pref.getParameters().put('id',claims.id);
        Test.setCurrentPage(pref);
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord1);

        
        test.startTest();
        
        CG_CL_ClaimsOtherClaimbles otherclaim = new CG_CL_ClaimsOtherClaimbles();
        string accountcode = otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode = otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid = otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 = otherclaim.assignedParts = 1;
        otherclaim.SelectedItem = 'TOWING';
        otherclaim.listTTMLWrapper = ttmlWrapList;
        otherclaim.populateTTMLFailCodenAccountCode();
        
        CG_CL_ClaimsOtherClaimbles otherclaim1 = new CG_CL_ClaimsOtherClaimbles();
        string accountcode1 = otherclaim1.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode1 =  otherclaim1.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid2 = otherclaim1.SelectedPartID = 1;
        Integer selctedpartid3 = otherclaim1.assignedParts = 1;
        otherclaim1.listTTMLWrapper = ttmlWrapList;
        otherclaim1.populateTTMLFailCodenAccountCode();
        
        
        CG_CL_ClaimsOtherClaimbles otherclaim2 = new CG_CL_ClaimsOtherClaimbles();
        string accountcode2 = otherclaim2.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode2 = otherclaim2.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid55= otherclaim2.SelectedPartID = 1;
        otherclaim2.SelectedItem = 'MISC';
        otherclaim2.populateTTMLFailCodenAccountCode();
        test.stopTest();
        
    }
    
    static testmethod void TestMethod23()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        update JO;
        
        css_claims__c claims = new css_claims__c();
        claims.CSS_Job__c = jo.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.CSS_Claims__c = claims.Id;
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
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord1);

        
        PageReference pref;
        pref = new PageReference('/'+claims.id);
        pref.getParameters().put('id',claims.id);
        Test.setCurrentPage(pref);
        
        test.startTest();
        
        CG_CL_ClaimsOtherClaimbles otherclaim = new CG_CL_ClaimsOtherClaimbles();
        string accountcode = otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode = otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid = otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 = otherclaim.assignedParts = 1;
        otherclaim.SelectedItem = 'TOWING';
        otherclaim.listTTMLWrapper = ttmlWrapList;
        otherclaim.populateTTMLFailCodenAccountCode();
        
        CG_CL_ClaimsOtherClaimbles otherclaim1 = new CG_CL_ClaimsOtherClaimbles();
        string accountcode1 = otherclaim1.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode1 =  otherclaim1.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid2 = otherclaim1.SelectedPartID = 1;
        Integer selctedpartid3 = otherclaim1.assignedParts = 1;
        otherclaim1.SelectedItem = 'COMMERCIAL TRAVEL';
        otherclaim1.listTTMLWrapper = ttmlWrapList;
        otherclaim1.populateTTMLFailCodenAccountCode();
        
        
         CG_CL_ClaimsOtherClaimbles otherclaim2 = new CG_CL_ClaimsOtherClaimbles();
        string accountcode6 = otherclaim2.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode7 = otherclaim2.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid11 = otherclaim2.SelectedPartID = 1;
        otherclaim2.SelectedItem = 'MISC';
        otherclaim2.listTTMLWrapper = ttmlWrapList;
        otherclaim2.populateTTMLFailCodenAccountCode();
        
        test.stopTest();
        
    }
    
    public static testmethod void CG_CL_ClaimsOtherClaimbles1_1(){
    	CG_CL_ClaimsOtherClaimbles cg=new CG_CL_ClaimsOtherClaimbles();
        cg.errTTML = null;
        cg.getallCustomPartsData(true);
    }
    
    public static testmethod void CG_CL_ClaimsOtherClaimbles1_2(){
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        update JO;
        
        css_claims__c claims = new css_claims__c();
        claims.CSS_Job__c = jo.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.CSS_Claims__c = claims.Id;
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
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord1);

        
        PageReference pref;
        pref = new PageReference('/'+claims.id);
        pref.getParameters().put('id',claims.id);
        Test.setCurrentPage(pref);
        
        test.startTest();
        
        CG_CL_ClaimsOtherClaimbles otherclaim = new CG_CL_ClaimsOtherClaimbles();
        Map<Id, string> removeMap = new Map<Id, String>();
        removeMap.put(partsoption.Id, 'krishna');
        otherclaim.removeIdsMap = removeMap;
        otherclaim.saveOtherClaimablesPopup();
        
    }
    
    public static testmethod void CG_CL_ClaimsOtherClaimbles1_3(){
         
        css_job_order__c jo = new css_job_order__c();
        jo.Customer_Code__c='123';
        jo.Customer_Name__c='TestUser';
        insert jo;
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56270';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56270';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        css_claims__c claims = new css_claims__c();
        claims.CSS_Job__c = jo.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        claims.Account__c=acc.id;
        insert claims;
        
        css_solutions__c sol = new css_solutions__c();
        sol.Service_Job__c=jo.Id;
        insert sol;
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.Service_Job__c=jo.Id;
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.AccountCode__c='';
        solcomp.AccountCodeEdit__c = 'test';
        solcomp.Solutions__c=sol.id;
        solcomp.Selected_Component__c=true;
        solcomp.Fail_Code_Editable__c='Testing';
        insert solcomp;
        
        id recordtypeid = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtypeid1 = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        
        
        CSS_Parts_Options__c  partop = new CSS_Parts_Options__c ();
        partop.CSS_Claims__c=claims.Id;
        partop.Type__c='Parts';
        partop.Service_Job__c=jo.Id;
        partop.RecordTypeId=recordtypeid;
        partop.selected_part__c=true;
        partop.Quantity__c=.0;
        partop.isManual__c=true;
        partop.Account_Code__c='Testing';
        partop.Part_Description__c='Testing';
        partop.Item__c='Belt';
        partop.Amount__c= 0.0;
        partop.Covered__c=00;
        partop.Fail_Code__c='Testing';
        partop.Currency_Type__c='USD';
        partop.Exchange_Rate_Version__c=23;
        partop.Exchange_Rate__c=1;
        partop.Unit_Price__c='50';
        partop.Amount_Local_Currency__c=50;
         partop.Sell_Price__c=50;
        partop.ExpenseTotal__c = 60;
        insert partop;
        
        CSS_Parts_Options__c  partop1 = new CSS_Parts_Options__c ();
        partop1.CSS_Claims__c=claims.Id;
        partop1.Type__c='Parts';
        partop1.Service_Job__c=jo.Id;
        partop1.RecordTypeId=recordtypeid;
        partop1.selected_part__c=true;
        partop1.Quantity__c=2.0;
        partop1.isManual__c=true;
        partop1.Account_Code__c='Testing';
        partop1.Part_Description__c='Testing';
        partop1.Item__c='Belt';
        partop1.Amount__c=100.0;
        partop1.Covered__c=100;
        partop1.Fail_Code__c='Testing';
        partop1.Currency_Type__c='USD';
        partop1.Exchange_Rate_Version__c=23;
        partop1.Exchange_Rate__c=1;
        partop1.Unit_Price__c='50';
        partop1.Amount_Local_Currency__c=50;
         partop1.Sell_Price__c=50;
        partop1.ExpenseTotal__c = 60;
        insert partop1;
        
        CSS_Parts_Options__c  partop2 = new CSS_Parts_Options__c ();
        partop2.CSS_Claims__c=claims.Id;
        partop2.Type__c='Parts';
        partop2.Service_Job__c=jo.Id;
        partop2.RecordTypeId=recordtypeid;
        partop2.selected_part__c=true;
        partop2.Quantity__c=2.0;
        partop2.isManual__c=true;
        partop2.Account_Code__c='Testing';
        partop2.Part_Description__c='Testing';
        partop2.Item__c='Belt';
        partop2.Amount__c=200.0;
        partop2.Covered__c=200;
        partop2.Fail_Code__c='Testing';
        partop2.Currency_Type__c='USD';
        partop2.Exchange_Rate_Version__c=23;
        partop2.Exchange_Rate__c=1;
        partop2.Unit_Price__c='50';
        partop2.Amount_Local_Currency__c=50;
         partop2.Sell_Price__c=50;
        partop2.ExpenseTotal__c = 60;
        insert partop2;
        
        CSS_Parts_Options__c  partop3 = new CSS_Parts_Options__c ();
        partop3.CSS_Claims__c=claims.Id;
        partop3.Type__c='Parts';
        partop3.Service_Job__c=jo.Id;
        partop3.RecordTypeId=recordtypeid;
        partop3.selected_part__c=true;
        partop3.Quantity__c=3.0;
        partop3.isManual__c=true;
        partop3.Account_Code__c='Testing';
        partop3.Part_Description__c='Testing';
        partop3.Item__c='Belt';
        partop3.Amount__c=300.0;
        partop3.Covered__c=300;
        partop3.Fail_Code__c='Testing';
        partop3.Currency_Type__c='USD';
        partop3.Exchange_Rate_Version__c=23;
        partop3.Exchange_Rate__c=1;
        partop3.Unit_Price__c='50';
        partop3.Amount_Local_Currency__c=50;
         partop3.Sell_Price__c=50;
        partop3.ExpenseTotal__c = 60;
        insert partop3;
        
        CSS_Parts_Options__c  partop4 = new CSS_Parts_Options__c ();
        partop4.CSS_Claims__c=claims.Id;
        partop4.Type__c='Parts';
        partop4.Service_Job__c=jo.Id;
        partop4.RecordTypeId=recordtypeid;
        partop4.selected_part__c=true;
        partop4.Quantity__c=4.0;
        partop4.isManual__c=true;
        partop4.Account_Code__c='Testing';
        partop4.Part_Description__c='Testing';
        partop4.Item__c='Belt';
        partop4.Amount__c=400.0;
        partop4.Covered__c=400;
        partop4.Fail_Code__c='Testing';
        partop4.Currency_Type__c='USD';
        partop4.Exchange_Rate_Version__c=23;
        partop4.Exchange_Rate__c=1;
        partop4.Unit_Price__c='50';
        partop4.Amount_Local_Currency__c=50;
         partop4.Sell_Price__c=50;
        partop4.ExpenseTotal__c = 60;
        insert partop4;
        
        CSS_Parts_Options__c  partop5 = new CSS_Parts_Options__c ();
        partop5.CSS_Claims__c=claims.Id;
        partop5.Type__c='Non Commercial-Travel';
        partop5.Service_Job__c=jo.Id;
        partop5.RecordTypeId=recordtypeid;
        partop5.selected_part__c=true;
        partop5.Quantity__c=5.0;
        partop5.isManual__c=true;
        partop5.Account_Code__c='Testing';
        partop5.Part_Description__c='Testing';
        partop5.Item__c='Belt';
        partop5.Amount__c=500.0;
        partop5.Covered__c=500;
        partop5.Fail_Code__c='Testing';
        partop5.Currency_Type__c='USD';
        partop5.Exchange_Rate_Version__c=23;
        partop5.Exchange_Rate__c=1;
        partop5.Unit_Price__c='50';
        partop5.Amount_Local_Currency__c=50;
         partop5.Sell_Price__c=50;
      partop5.ExpenseTotal__c = 60;
        insert partop5;
        
        CSS_Parts_Options__c  partop6 = new CSS_Parts_Options__c ();
        partop6.CSS_Claims__c=claims.Id;
        partop6.Type__c='Parts';
        partop6.Service_Job__c=jo.Id;
        partop6.RecordTypeId=recordtypeid1;
        partop6.selected_part__c=true;
        partop6.Quantity__c=6.0;
        partop6.isManual__c=true;
        partop6.Account_Code__c='Testing';
        partop6.Part_Description__c='Testing';
        partop6.Item__c='Belt';
        partop6.Amount__c=600.0;
        partop6.Covered__c=600;
        partop6.Fail_Code__c='Testing';
        partop6.Currency_Type__c='USD';
        partop6.Exchange_Rate_Version__c=23;
        partop6.Exchange_Rate__c=1;
        partop6.Unit_Price__c='50';
        partop6.Amount_Local_Currency__c=50;
         partop6.Sell_Price__c=50;
        partop6.ExpenseTotal__c = 60;
        insert partop6;
        Currency_Conversion__c ccc = new Currency_Conversion__c();
        ccc.Bolt_Conversion_Rate__c = 23.8;
        ccc.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
        ccc.Bolt_Version__c = partop.Exchange_Rate_Version__c;
        insert ccc;
        css_header_nav__c head = new css_header_nav__c();
        head.Name = 'test';
        head.RSWButtonEnable__c = true;
        insert head;
        
        list<CSS_JobEventTemporary__c> JETList = new  list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c JET1 = new CSS_JobEventTemporary__c();
        JET1.Attribute1__c = 'POL';
        JET1.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET1.Attribute3__c = 'ZK';
        JET1.key__c = 'AccountCodes';
        JETList.add(JET1);
        insert JETList;
        CSS_JobEventTemporary__c JET2= new CSS_JobEventTemporary__c();
        JET2.Attribute1__c = 'POL';
        JET2.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET2.Attribute3__c = 'ZK';
        JET2.key__c = 'AccountCodes';
        insert JET2;
        List<SelectOption> listoption = new List<SelectOption>();
        listoption.add(new SelectOption('Select One','Select One'));
            //setpartWrapper.add(new claimablesWrapperClass(customPartlstUI.size()+i,null,partsoption.Item__c,partsoption.Part_Description__c,String.valueof(partsoption.Quantity__c),partsoption.amount__c,String.valueof(partsoption.Covered__c),partsoption.Fail_Code__c,partsoption.Account_Code__c,options,options,partsoption.isManual__c,partsoption.Previous_Item__c,partsoption.Unit_Price__c == null ? null : decimal.valueOf(partsoption.Unit_Price__c),false,false,false, null, null, null, null));
                       
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> wrapList = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(2,claims.id, 'Unlisted','N/A','0',50.0,'coveredPercent','failCode','accountCode', listoption,listoption, true,'previousItem', 0.36, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord2 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Select one','N/A','Quantity',0.23,'coveredPercent','failCode','accountCode', listoption,listoption, true,'previousItem', 0.36, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord3 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Unlisted','N/A','0',0.23,'coveredPercent','failCode','Select One', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord4 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Select one','N/A','',0,'','Select One','Select One', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord5 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id, 'Select one','N/A','',null,'',null,null, listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        wrapList.add(wrapRecord1);
        wrapList.add(wrapRecord2);
        wrapList.add(wrapRecord3);
        wrapList.add(wrapRecord4);
        wrapList.add(wrapRecord5);
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();  
        
          //CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord4 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(2,claims.id,'technician','unlisted','1',null,null,null,null, null,null,null, null, true, true,true,true,true, null,false,false, null, false, true, false, false, null); 
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(2,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord2 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord3 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'test1','Non Commercial-Travel','Meals','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord40 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'','','Meals','10.0','','','','','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord1);
        ttmlWrapList.add(ttmlWrapRecord2);
        ttmlWrapList.add(ttmlWrapRecord3);
        ttmlWrapList.add(ttmlWrapRecord40);
        // ttmlWrapList.add(ttmlWrapRecord4);
        Map<Id, String> removeIdsMap = new Map<Id, String>();
        removeIdsMap.put(claims.id,'testing');
        
        pagereference ref = new pagereference('/apex/CG_Claimscc');
        test.setCurrentPage(Ref);
        apexpages.currentPage().getparameters().put('id',claims.Id);
        
        CG_CL_ClaimsOtherClaimbles cg=new CG_CL_ClaimsOtherClaimbles();
        list<string> lstAccountCodes = new list<string>();
        lstAccountCodes.add('abc');
        lstAccountCodes.add('def');
        cg.getOCData();
        cg.lstAccountCodes=lstAccountCodes;
        cg.accCodes = listoption;
        cg.claimsObj = claims;
        cg.workJob = jo;
        cg.jobEventTemp = JETList;
        cg.errorDisplay = true;
        cg.towErrorOutputMsg = true;
        cg.dealer = 'test';
        cg.listpartWrapper = wrapList;
        cg.listTTMLWrapper = ttmlWrapList;
        //cg.setduplicatecheck=true;
        cg.saveOtherClaimablesPopup();
        cg.getfailCodeValues();
        cg.saveTTMLPopup();
        cg.closePopup();
        cg.displayPopUp();
        cg.deleteParts();
        cg.AddRow();
        cg.assignedParts = 2;
        cg.removingRow();
        cg.getItems();
        cg.SelectedPartID = 2;
        cg.onChangeofItem();
        cg.selectedRemoveRow = 1;
        cg.deleteTTMLParts();
        cg.saveOtherClaimables();
        cg.removingTTMLRow();
        cg.addTTMLRow();
        cg.selectedRecordRowID=5;
        cg.setAccountCode_Covered();
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList1 = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        //List<SelectOption> failCodeList1= new List<SelectOption>();                                              
        //List<SelectOption> AccCodeList1= new List<SelectOption>();  
           //ttmlWrapperClass(Integer counting,Id ids,String technician,'Meals',String days,String quantity,String unitPrice,String mileage,String hoursTraveled, String expenseTotal,'Select One',String accountCode, String notes, Boolean showDays, Boolean showMileageHT,boolean showUP,boolean showMileage,Boolean accCoverage, List<SelectOption> failCodelst,boolean isManual,Boolean towErrorMsg, List<SelectOption> accCodelst, Boolean mandateaccountcode, boolean isExpenseTotal, boolean isTTMLPartsCovLimitExceed, Boolean isTTMLFailcodeCovLimitExceed, Boolean isTTMLMlsLodPartsCovLimitExceed) {
          CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord4 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(2,claims.id,'technician','Meals','1','2.0','5','123','123', null,'Select One',null, null, true, true,true,true,true, null,false,false, null, false, true, false, false, true); 
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord11 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(2,claims.id,'TestUser','Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord21 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Non Commercial-Travel','1','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord31 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'test1','Lodging','Meals','10.0','20','5','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList1.add(ttmlWrapRecord11);
        ttmlWrapList1.add(ttmlWrapRecord21);
        ttmlWrapList1.add(ttmlWrapRecord31);
        ttmlWrapList1.add(ttmlWrapRecord4);
        css_claims__c claims1 = new css_claims__c();
        claims1.CSS_Job__c = jo.id;
        claims1.Customer_Name__c='TestUser';
        claims1.Customer_Code__c='123';
        claims1.ESN__c='56475674';
        claims1.Account__c=acc.id;
        insert claims1;
        cg.fetchAccCodeValues('Meals','ZCK POLICY CLAIMS ZK');
        cg.typeListChangeNewttmlacc();
        css_claims__c claims2 = new css_claims__c();
        claims2.CSS_Job__c = null;
        claims2.Customer_Name__c='TestUser';
        claims2.Customer_Code__c='123';
        claims2.ESN__c='56475674';
        claims2.Account__c=acc.id;
        insert claims2;
        cg.fetchAccCodeValues('Commercial-Travel','ZCK POLICY CLAIMS ZK');
         cg.typeListChangeNewttmlacc();
       cg.fetchAccCodeValues('Non Commercial-Travel','ZCK POLICY CLAIMS ZK'); 
        cg.typeListChangeNewttmlacc();
        cg.fetchAccCodeValues('Towing','ZCK POLICY CLAIMS ZK'); 
        cg.typeListChangeNewttmlacc();
    }   
   
    public static testmethod void CG_CL_ClaimsOtherClaimbles1_4(){
        
        //Check IF condition-->counting == SelectedPartID 
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
       // acc.IAM_Service_Provider_Code__c = '56271';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123456';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_PSN__c psn = new CSS_PSN__c();
        psn.CSS_Claims__c =claims.Id;
        psn.psn__c = '79812345';
        psn.Primary__C = true;
        insert psn;
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.AccountCode__c='';
        solcomp.AccountCodeEdit__c = 'test';
        //solcomp.Solutions__c=sol.id;
        solcomp.Selected_Component__c=true;
        solcomp.Fail_Code_Editable__c='Testing';
        insert solcomp;
        
        List<SelectOption> listoption = new List<SelectOption>();
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> wrapList = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id,'Belt',null,'',0,'','','', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord2 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id,'Select',null,'',0,'','','', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        wrapList.add(wrapRecord1);
        wrapList.add(wrapRecord2);
        
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        
        Test.startTest(); 
        
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.listpartWrapper=wrapList;
        obj.selecteditem = 'Unlisted';
        obj.SelectedPartID = 0;
        obj.saveOtherClaimablesPopup();
        obj.getItems();
        obj.onChangeofItem();
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
    }
    
    public static testmethod void CG_CL_ClaimsOtherClaimbles1_5(){
        
        //Check IF condition-->counting == SelectedPartID 
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
       // acc.IAM_Service_Provider_Code__c = '56271';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123456';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_PSN__c psn = new CSS_PSN__c();
        psn.CSS_Claims__c =claims.Id;
        psn.psn__c = '79812345';
        psn.Primary__C = true;
        insert psn;
        
        Currency_Conversion__c ccc = new Currency_Conversion__c();
        ccc.Bolt_Conversion_Rate__c = 23.8;
        ccc.Bolt_To_Currency__c = userinfo.getDefaultCurrency();
        ccc.Bolt_Version__c = 23;
        insert ccc;
        
        List<Currency_Conversion__c> lstCurrencyDetails = new List<Currency_Conversion__c>();
        lstCurrencyDetails.add(ccc);
        
        List<SelectOption> listoption = new List<SelectOption>();
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> wrapList = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id,'Belt',null,'34',0,'','','', listoption,listoption, true,'previousItem', 0, true, true, true,125.0,null,null,null);
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord2 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(12,claims.id,'Select',null,'',0,'','','', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        wrapList.add(wrapRecord1);
        wrapList.add(wrapRecord2);
        
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        
        Test.startTest(); 
        
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.lstCurrencyDetails = lstCurrencyDetails;
        obj.listpartWrapper=wrapList;
        obj.selecteditem = 'Unlisted';
        obj.SelectedPartID = 0;
        obj.saveOtherClaimablesPopup();
        obj.getItems();
        obj.onChangeofItem();
        obj.typeListChangeNewttmlacc();
        Test.stopTest();
    }
    
    public static testmethod void CG_CL_ClaimsOtherClaimbles1_6(){
        
        //Check Esle condition--> Unitprice==0 (Currently not working) 
         Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        //acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '56271';
        //acc.Type = 'Customer';
        //acc.IAM_Service_Provider_Code__c = '56272';
        acc.CMI_Account_Status__c = 'Active';
        
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='Oliver Trucking';
        claims.Customer_Code__c='123456';
        claims.Account__c=acc.id;
        insert claims;
        
        CSS_PSN__c psn = new CSS_PSN__c();
        psn.CSS_Claims__c =claims.Id;
        psn.psn__c = '79812345';
        psn.Primary__C = true;
        insert psn;
        
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.CSS_Claims__c=claims.Id;
        solcomp.Name = 'Turbo Charger';
        solcomp.AccountCode__c='';
        solcomp.AccountCodeEdit__c = 'test';
        //solcomp.Solutions__c=sol.id;
        solcomp.Selected_Component__c=true;
        solcomp.System_Code__c ='TH';
        solcomp.Component_Code__c ='AC';
        insert solcomp;
        
        List<SelectOption> listoption = new List<SelectOption>();
        list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass> otherlist = new list<CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass>();
        CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass wrapRecord1 = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(2,claims.id, 'COMMERCIAL TRAVEL','N/A','0',100000.0,'coveredPercent','failCode','accountCode', listoption,listoption, true,'previousItem', 0, true, true, true,null,null,null,null);
        //CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass otherwrap = new CG_CL_ClaimsOtherClaimbles.claimablesWrapperClass(0,claims.id,'belt', 'SCREW,HEX FLANGE HEAD CAP', '1', 10.1,'100', 'YNEB', '2013 AFT COV A3',  true, 'test', 0.0);
        otherlist.add(wrapRecord1);
        
        PageReference pageRef = new PageReference('/apex/CG_ClaimsPartsandOtherClaimbles?');
        Test.setCurrentPage(pageRef);
        ApexPages.CurrentPage().getParameters().put('id',claims.Id);
        
        Test.startTest(); 
        
        CG_CL_ClaimsOtherClaimbles obj = new CG_CL_ClaimsOtherClaimbles();
        obj.selecteditem = 'Unlisted';
        obj.SelectedPartID = 1;
        obj.onChangeofItem();
        obj.getItems();
        obj.typeListChangeNewttmlacc();
        obj.selectedFailCode = 'Turbo Charger-THACAC';
        obj.onChangeofFailCode();
        obj.onChangeofAccountCode();
        Map<String, Set<String>> failAccountCodeMap = new Map<String, Set<String>>();
        Set<string> acCodeSet = new Set<string>();
        acCodeSet.add(solcomp.AccountCodeEdit__c);
        failAccountCodeMap.put(solcomp.SysCodeAndCompCode__c, acCodeSet);
        obj.failAccountCodeMap = failAccountCodeMap;
        obj.getAccountCodeDropDown(obj.selectedFailCode);
        
        Test.stopTest();
    } 
    
    static testmethod void CG_CL_ClaimsOtherClaimbles1_7()
    {
        Account acc = new Account();
        acc.name='Rtest';
        acc.CSS_DistributorCode__c='03742';
        acc.ERP_System__c='One BMS';
        insert acc;
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        update JO;
        
        css_claims__c claims = new css_claims__c();
        claims.CSS_Job__c = jo.id;
        claims.Customer_Name__c='TestUser';
        claims.Customer_Code__c='123';
        claims.ESN__c='56475674';
        claims.Account__c=acc.id;
        insert claims;
        
        list<CSS_JobEventTemporary__c> JETList = new  list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c JET1 = new CSS_JobEventTemporary__c();
        JET1.Attribute1__c = 'POL';
        JET1.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET1.Attribute3__c = 'ZK';
        JET1.key__c = 'AccountCodes';
        JETList.add(JET1);
        //insert JETList;
        /*CSS_JobEventTemporary__c JET2= new CSS_JobEventTemporary__c();
        JET2.Attribute1__c = 'POL';
        JET2.Attribute2__c = 'ZCK POLICY CLAIMS';
        JET2.Attribute3__c = 'ZK';
        JET2.key__c = 'AccountCodes';
        JETList.add(JET1);*/
        insert JETList;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.CSS_Claims__c = claims.Id;
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
        solcomp1.CSS_Claims__c = claims.Id;
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
        pref = new PageReference('/'+claims.id);
        pref.getParameters().put('id',claims.id);
        Test.setCurrentPage(pref);
        
        list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass> ttmlWrapList = new list<CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass>();
        List<SelectOption> failCodeList= new List<SelectOption>();                                              
        List<SelectOption> AccCodeList= new List<SelectOption>();                                                    
        CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass ttmlWrapRecord1 = new  CG_CL_ClaimsOtherClaimbles.ttmlWrapperClass(1,claims.id,'TestUser','Commercial-Travel','1','10.0','20322','544242423','123','123','WEQP','ZCK POLICY CLAIMS ZK', 'notes', true, true,true,true,true,failCodeList,true,true,AccCodeList, true,true,true,true,true);
        ttmlWrapList.add(ttmlWrapRecord1);

        
        test.startTest();
        
        CG_CL_ClaimsOtherClaimbles otherclaim = new CG_CL_ClaimsOtherClaimbles();
        string accountcode = otherclaim.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode = otherclaim.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid = otherclaim.SelectedPartID = 1;
        Integer selctedpartid1 = otherclaim.assignedParts = 1;
        otherclaim.SelectedItem = 'TOWING';
        otherclaim.getfailcodeDropDownBasedOnItem('TOWING',1);
        otherclaim.fetchfailCodeValuesNew('TOWING');
        otherclaim.fetchAccCodeValues('TOWING','Intake Manifold Pressure/Temperature Sensor-EEBT');
        otherclaim.listTTMLWrapper = ttmlWrapList;
        otherclaim.populateTTMLFailCodenAccountCode();
        
        CG_CL_ClaimsOtherClaimbles otherclaim1 = new CG_CL_ClaimsOtherClaimbles();
        string accountcode1 = otherclaim1.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode1 =  otherclaim1.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid2 = otherclaim1.SelectedPartID = 1;
        Integer selctedpartid3 = otherclaim1.assignedParts = 1;
        otherclaim1.SelectedItem = 'COMMERCIAL TRAVEL';
        otherclaim1.getfailcodeDropDownBasedOnItem('COMMERCIAL TRAVEL',1);
        otherclaim1.fetchfailCodeValuesNew('COMMERCIAL TRAVEL');
        otherclaim1.fetchAccCodeValues('COMMERCIAL TRAVEL','Intake Manifold Pressure/Temperature Sensor-EEBT');
        otherclaim1.listTTMLWrapper = ttmlWrapList;
        otherclaim1.populateTTMLFailCodenAccountCode();
        
        
        CG_CL_ClaimsOtherClaimbles otherclaim2 = new CG_CL_ClaimsOtherClaimbles();
        string accountcode2 = otherclaim2.SelectedAccountCode = 'Customized Assurance Plan DC';
        string failcode2 = otherclaim2.SelectedFailCode = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        Integer selctedpartid55= otherclaim2.SelectedPartID = 1;
        otherclaim2.SelectedItem = 'MISC';
        otherclaim2.getfailcodeDropDownBasedOnItem('MISC',1);
        otherclaim2.fetchfailCodeValuesNew('MISC');
        otherclaim2.fetchAccCodeValues('MISC','Intake Manifold Pressure/Temperature Sensor-EEBT');
        otherclaim2.listTTMLWrapper = ttmlWrapList;
        otherclaim2.populateTTMLFailCodenAccountCode();
        
        Map<Id, String> removeIdsMap = new Map<Id, String>();
        removeIdsMap.put(partsoption.Id, 'Krishna');
        otherclaim2.removeIdsMap = removeIdsMap;
        otherclaim2.deleteTTMLParts();
        
        test.stopTest();
        
    }
    
}