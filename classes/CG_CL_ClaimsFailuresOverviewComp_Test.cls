/**********************************************************************
Name:CG_CL_ClaimsFailuresOverviewComp_Test
Copyright Â© 2018  Cummins
===============================================================
===============================================================
Purpose:                                                            
-------  
this is test class for CG_CL_ClaimsFailuresOverviewComp Controller.
===============================================================
===============================================================
History                                                            
-------                                                            
VERSION    AUTHOR                 DATE                DETAIL                                 
1.0 -      Arpita Sarangee      3/23/2018           INITIAL DEVELOPMENT                    
***********************************************************************/

@isTest
public class CG_CL_ClaimsFailuresOverviewComp_Test 
{
    public static Testmethod void Method1()
    { 
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced'];
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        
        
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        String grpName = 'CQ'+'-'+'56270-56255';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.Name = 'GetCampaign';
            conDetails.AuthEnv__c = 'OAGOAUTH';
            conDetails.ApplicationName__c = 'GetCampaign';
            conDetails.End_Point__c = 'Test';
            conDetails.Method_Type__c = 'POST';
            conDetails.Timeout__c = 2.0;
            insert conDetails;
            
            CSS_TestData.createAccountLanguage(true);
            CSS_Claims__c testclaimsRec1 = new CSS_Claims__c();
            //CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            testclaimsRec1.Customer_Name__c='TestCustomer';
            testclaimsRec1.Customer_Code__c = '1234';
            testclaimsRec1.Contact_Last_Name__c = 'T';
            testclaimsRec1.Address__c = 'T';
            testclaimsRec1.Customer_Contact_Phone__c = null;
            testclaimsRec1.Email_Address__c = 'rp@sct.com';
            testclaimsRec1.Status__c = 'Draft';
            testclaimsRec1.TSR1__c = '1234';
            testclaimsRec1.TSR2__c = '1234';
            testclaimsRec1.TSR3__c = '1234';
            testclaimsRec1.TSR4__c = '1234';
            testclaimsRec1.TSR5__c = '1234';
            testclaimsRec1.TSR6__c = '1234';
            testclaimsRec1.TSR7__c = '1234';
            testclaimsRec1.TSR8__c = '1234';
            testclaimsRec1.TSR9__c = '1234';
            testclaimsRec1.TSR10__c = '1234';
            testclaimsRec1.Country__c = '1234';
            testclaimsRec1.State__c = '1234';
            testclaimsRec1.ZipCode__c = '12345';
            testclaimsRec1.Location_Code__c='56270-56255';
            testclaimsRec1.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"5/26/2016","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"5/26/2019","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2019","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2017","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"}]}}}}';
            insert testclaimsRec1;
            
            CSS_Job_Order__c job= new CSS_Job_Order__c();
            job.Status__c = 'Intake';
            job.INSITE_UpdateTimeStamp__c =system.today();
            job.INSITE_ESN_Choice__c='Not Selected';
            job.Qsol_Engine_Family_Code__c = 'code';
            job.Warranty_Start_Date__c = date.today();
            job.CSS_Job_Location_Code__c = '56270-56255';
            job.ApplicationCode__c = 'code';
            job.DSID__c='2323';
            job.ESN__c ='21323';
            job.Application__c='asdd';
            job.Unit_Number__c='213';
            job.Failure_Point__c=213.00;
            job.Failure_Point_Measure__c='asd';
            job.Make__c='Make';
            job.ESN_Insite__c = 'insite';
            job.Model__c='Model';
            job.Equipment_ID__c='Equip';
            job.Customer_Name__c='Peterbuilt';
            job.Shop_Work_Order__c='213dssd';
            job.Service_Model__c='SMNNUM';
            job.DSID_Creation_Timestamp__c=system.today();
            job.DSID_Status__c='Stat';
            job.DSID_WorkGroup__c='Wrkgrp';
            job.Status__c = 'Triage & Diagnosis Complete' ;
            job.Previous_Status__c = 'Triage & Diagnosis' ;
            job.Failure_Date__c = date.today();
            insert job;
            
            CSS_Job_Order__c del = new CSS_Job_Order__c();
            del.ApplicationCode__c = 'test';
            insert del;
            
            
            
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            //CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            //testclaimsRec
            //testclaimsRec.
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.CSS_Job__c = job.id;
            testclaimsRec.Dealer_Service_Job__c = del.id;
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
            testclaimsRec.ZipCode__c = '12345';
            testclaimsRec.Location_Code__c='56270-56255';
            testclaimsRec.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"5/26/2016","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"5/26/2019","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2019","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2017","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"}]}}}}';
            insert testclaimsRec;
            list<CSS_PSN__c> psnlst = new list<CSS_PSN__c>();
            CSS_PSN__c psnobj = new CSS_PSN__c();
            psnobj.PSN__c='79464646';
            psnobj.CSS_Claims__c = testclaimsRec.id;
            psnobj.Service_Model__c='IX0768';
            psnobj.Qsol_Engine_Family_Code__c='Test';
            psnobj.ApplicationCode__c='630';
            insert psnobj;
            psnlst.add(psnobj);
            
            CSS_Fault_Code__c faulCodeRec = new CSS_Fault_Code__c(Name='3478',Related_Fault_Code__c='98734,95869',isPole__c = true);
            insert faulCodeRec;
            
            List<CSS_SymptomQA__c> symList=new List<CSS_SymptomQA__c>();
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym.Job_Order__c=job.id;
            sym.caption__c ='white smoke';
            sym.Option1__c  ='12213';
            sym.Job_Order__c  =job.id;
            sym.Option_type__c  ='qwewqe';
            sym.Guide_Question__c  ='Do you see smoke';
            sym.Type__c  ='SearchString';
            insert sym; 
            
            CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
            symQA.Job_Order__c=job.id;
            symQA.caption__c ='fault Code';
            symQA.Option1__c  ='12213';
            symQA.Job_Order__c  =job.id;
            symQA.SearchString__c  =sym.id;        
            symQA.Type__c  ='QA';
            insert symQA;
            
            symList.add(symQA);
            update symList;
            
            
            
            List<Css_Solutions__c> solList = new List<CSS_Solutions__C>();
            
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Name='test';
            sol.FaultCode__c = faulCodeRec.id;
            sol.Diagnostic_Response__c='test';
            sol.Repair_Response__c='test';
            sol.Symptom__c=sym.id;
            sol.Service_Job__c=job.id;
            //sol.FSL_service_job__c=job.id;
            sol.CSS_Nested_Solutions__c = sol.id;
            sol.rank__c=0;
            sol.Out_Of_Order__c = false;
            sol.Solution_Title__c = 'test';
            sol.Solution__c ='test';
            sol.Report_Comments__c ='qwewqewqewewqe';
            sol.Diagnostic_notes__c ='asdsadad';
            
            solList.add(sol);
            insert solList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            
            CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solcomp.System_Code__c = 'aka';
            solcomp.Component_Code__c = 'akaa';
            solComp.Component_Id__c ='F0051000';
            solComp.css_claims__c = testclaimsRec.id;
            solComp.Action__c = '';
            solcomp.Performed_Review__c = True;
            solcomp.Status__c='Approved';
            solcomp.Complete_Indicator__c=true; 
            solcomp.Multiple_Times__c=true;
            //solcomp.SysCodeAndCompCode__c='test12';
            solcomp.AccountCode__c = '';
            solcomp.Selected_Component__c = true;
            solcomp.Solutions__c = solList[0].Id;
            solcomp.AccountCode_Call_Status__c='Failure';
            solcomp.Failure_Date__c= System.today()+1;
            solcomp.CSS_Claims__c = testclaimsRec.Id;
            solcomp.Type__c = 'ATC';
            solCompList.add(solComp);
            
            CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solComp1.Component_Id__c ='F0051000';
            solComp1.css_claims__c = testclaimsRec.id;
            solComp1.Performed_Review__c = True;
            solComp1.Status__c='Approved';
            solComp1.Complete_Indicator__c=true; 
            solComp1.Multiple_Times__c=true;
            //solcomp.AccountCode__c = '67';
            // solcomp.AccountCode__c = '62';
            solcomp.Failure_Date__c=date.today();
            solcomp1.Selected_Component__c = true;
            solcomp1.Solutions__c = solList[0].Id;
            //solcomp1.SysCodeAndCompCode__c='test1';
            solcomp1.System_Code__c='BT';
            solcomp1.Component_Code__c='ER';
            solcomp1.CSS_Claims__c = testclaimsRec.Id;
            solCompList.add(solComp1);
            
            insert solCompList;
            
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            je1.Attribute1__c = 'POL';
            je1.Attribute2__c='z';
            je1.Attribute3__c='Transfer Switch failed to open/disconnect - Root Cause Not Known';
            je1.Attribute4__c='DSBDV5790';
            //je1.key__c = 'AccountCodes';
            //je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
            insert je1;
            
            
            CSS_JobEventTemporary__c je2 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute1__c = 'POL';
            je2.Attribute2__c='z';
            je2.Attribute3__c='Transfer Switch failed to open/disconnect - Root Cause Not Known';
            je2.Attribute4__c='DSBDV5790';
            je2.key__c = 'FailCodes';
            //je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
            insert je2;
            
            
            ApexPages.CurrentPage().getParameters().put('Id',testclaimsRec.id);
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            
            claimsFailObj.SelectComCode = 'SelectComCode';
            claimsFailObj.SelectSysCode = 'SelectSysCode';
            claimsFailObj.radioYes = 'radioYes';
            claimsFailObj.solCompListOne = true;
            claimsFailObj.Reason1 = 'Reason1';
            claimsFailObj.selectedSysCode='POL';
            // claimsFailObj.urRole=true;
            claimsFailObj.mil_measure='Test';
            claimsFailObj.Wid=testclaimsRec.Id;
            claimsFailObj.accCodeWS='Test';
            claimsFailObj.claimtype='test';
            claimsFailObj.FailureDtHidden='test';
            claimsFailObj.selectedCustFName = 'test';
            claimsFailObj.noPopup=true;
            claimsFailObj.showFailurePopup=true;
            claimsFailObj.warrStDtHidden='test';
            claimsfailobj.selectedCompCode='DSBDV5790';
            claimsfailobj.selectedFailMode='ST';
            Claimsfailobj.onChangeofAppCode();
            claimsFailObj.getAllFailuresData();
            claimsFailObj.retry();
            claimsFailObj.getGsqcustFailurenameslist();
            claimsFailObj.resetAllData();
            claimsFailObj.saveClaimFailOvervwData();
            CSS_Claims__c obj = new CSS_Claims__c();
            obj.CoverageResponse__c = 'TestingData';
            insert obj;
            CSS_Solution_Component__c compToUpdate = new CSS_Solution_Component__c();
            compToUpdate.CoveredLaborHrs__c = '99999';
            compToUpdate.CoveredMealsLodgingAmt__c = '1';
            compToUpdate.CoveredOCAmount__c = '1';
            compToUpdate.CoveredPartsQty__c = '1';
            compToUpdate.CoveredTowingMiles__c = '1';
            compToUpdate.AccountCode_Call_Status__c='Test';
            compToUpdate.CoveredTravelLabor__c = '1';
            compToUpdate.CoveredTravelMiles__c = '1';
            compToUpdate.CertificateNumber__c = '1';
            insert compToUpdate;
            claimsFailObj.compToUpdate = compToUpdate;
            string solid =string.valueOf(solComp.id);
            claimsFailobj.deleteCompId=solid;
            claimsFailobj.deleteSolRecordWOPSN();
            string solid1 =string.valueOf(solComp1.Id);
            //claimsFailobj.DeletePopupAC();
            claimsFailObj.accCodeSelected = '62';
            claimsFailObj.getfailurenames();
            claimsFailObj.getComponentCodes();
            claimsFailObj.accCodeSelected = 'Test 41';
            //claimsFailObj.selectedSysCode = '123';
            //claimsFailObj.selectedCompCode='234';
            claimsFailObj.selectedFailMode='789';
            claimsFailObj.selectedFaultCode='9-23';
            claimsFailObj.selectedFName = null;
            claimsFailObj.failureMeasure = 'Hours';
            CSS_Solution_Component__c compToUpdate1 = new CSS_Solution_Component__c();
            compToUpdate1.CoveredLaborHrs__c = '99999';
            compToUpdate1.CoveredMealsLodgingAmt__c = '1';
            compToUpdate1.CoveredOCAmount__c = '1';
            compToUpdate1.CoveredPartsQty__c = '1';
            compToUpdate1.CoveredTowingMiles__c = '1';
            compToUpdate1.AccountCode_Call_Status__c='Test';
            compToUpdate1.CoveredTravelLabor__c = '1';
            compToUpdate1.CoveredTravelMiles__c = '1';
            compToUpdate1.CertificateNumber__c = '1';
            insert compToUpdate1;
            claimsFailObj.compToUpdate = compToUpdate1;
            claimsFailobj.checkPartCoverage();
            claimsFailobj.claimTypeSelected = 'ASD';
            claimsFailObj.popUpSave();
            claimsFailObj.changeCustFailures();
            claimsFailObj.checkCompCode();
            claimsFailObj.checkFailMode();
            claimsFailObj.checkFaultCode();
            claimsFailObj.changeSystemcode();
            claimsFailObj.getSRTFailurenamesOnLoad();
            //claimsFailObj.isPolicyClaim =  true;
        }
        
    }
    
    public static testmethod void Method2()
    {
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        {  
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq; 
            CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
            cid.name = 'CSS_SBL_WarrantyDetailCoverage';
            cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
            cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
            insert cid;
            CSS_Job_Order__c job= new CSS_Job_Order__c();
            job.Status__c = 'Intake';
            job.INSITE_UpdateTimeStamp__c =system.today();
            job.INSITE_ESN_Choice__c='Not Selected';
            job.Qsol_Engine_Family_Code__c = 'code';
            job.Warranty_Start_Date__c = date.today();
            job.CSS_Job_Location_Code__c = '56270-56255';
            job.ApplicationCode__c = 'code';
            job.DSID__c='2323';
            job.ESN__c ='21323';
            job.Application__c='asdd';
            job.Unit_Number__c='213';
            job.Failure_Point__c=213.00;
            job.Failure_Point_Measure__c='asd';
            job.Make__c='Make';
            job.ESN_Insite__c = 'insite';
            job.Model__c='Model';
            job.Equipment_ID__c='Equip';
            job.Customer_Name__c='Peterbuilt';
            job.Shop_Work_Order__c='213dssd';
            job.Service_Model__c='SMNNUM';
            job.DSID_Creation_Timestamp__c=system.today();
            job.DSID_Status__c='Stat';
            job.DSID_WorkGroup__c='Wrkgrp';
            job.Status__c = 'Triage & Diagnosis Complete' ;
            job.Previous_Status__c = 'Triage & Diagnosis' ;
            job.Failure_Date__c = date.today();
            insert job;
            
            CSS_TestData.createAccountLanguage(true);
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            //CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            //testclaimsRec.ReconEngineFlag__c = 'y';
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Location_Code__c='12345-12345';
            testclaimsRec.CSS_Job__c = job.id;
            //testclaimsRec.Dealer_Service_Job__c = solComp1.id;
            insert testclaimsRec; 
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solComp1.Component_Id__c ='F0051000';
            solComp1.css_claims__c = testclaimsRec.id;
            solComp1.Performed_Review__c = True;
            solComp1.Status__c='Approved';
            solComp1.Complete_Indicator__c=true; 
            solComp1.Multiple_Times__c=true;
            solcomp1.AccountCode__c = '65';
            solcomp1.Selected_Component__c = true;
            solcomp1.CSS_Claims__c = testclaimsRec.Id;
            solcomp1.Failure_Point__c = 12;
            solcomp1.Failure_Measure__c = 'test';
            solcomp1.System_Code__c  ='TE';
            solcomp1.Component_Code__c ='ST';
            solCompList.add(solComp1);
            CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
            solComp2.Component_Id__c ='F0051000';
            solComp2.css_claims__c = testclaimsRec.id;
            solComp2.Performed_Review__c = True;
            solComp2.Status__c='Approved';
            solComp2.Complete_Indicator__c=true; 
            solComp2.Multiple_Times__c=true;
            solcomp2.AccountCode__c = '65';
            solcomp2.Selected_Component__c = true;
            solcomp2.CSS_Claims__c = testclaimsRec.Id;
            solcomp2.Failure_Point__c = 12;
            solcomp2.Failure_Measure__c = 'test';
            solcomp2.System_Code__c  ='TE';
            solcomp2.Component_Code__c ='ST';
            solcomp2.AccountCodeEdit__c='New Parts Warrenty 67';
            solCompList.add(solComp2);
            //insert solComp2;
            insert solCompList;
            css_solutions__c sol = new css_solutions__c();
            //sol.css_claims__c=testclaimsRec.Id;
            sol.Name='Testing';
            sol.service_job__c=job.id;
            //sol.FSL_Service_Job__c =job.id;
            insert sol;
            css_parts_options__c patop = new css_parts_options__c();
            patop.Parts_Type__c = 'Custom';
            //patop.RecordTypeId=recodid;
            patop.Fail_Code__c='TEST';
            patop.Solutions__c=sol.id;
            patop.CSS_Claims__c=testclaimsRec.Id;
            insert patop;
            list<css_srt__c> srtlist = new list<css_srt__c>();
            css_srt__c srt12 = new css_srt__c();
            srt12.CSS_Claims__c=testclaimsRec.Id;
            srt12.Step_Id__c='1';
            srt12.Account_Code__c='THAC';
            srt12.Type__c='Overlap';
            srt12.FailCode__c = 'TEST';
            srtlist.add(srt12);
            //insert srtlist;
            
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            je1.Attribute1__c = '65';
            je1.key__c = 'AccountCodes';
            je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
            insert je1;
            
            CSS_JobEventTemporary__c je2 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute1__c = 'ST';
            je2.Attribute4__c = 'TW';
            je2.Attribute1__c = 'EZ';
            je2.key__c = 'FailCodes';
            je2.Reason__c='test1';
            insert je2;
            
            CSS_JobEventTemporary__c je3 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute4__c = 'Crank';
            je2.key__c = 'FailModes';
            insert je3;
            
            ApexPages.CurrentPage().getParameters().put('Id',testclaimsRec.id);
            
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            claimsFailObj.selectedPayCode = 'A';
            claimsFailObj.selectedFName = 'Unlisted';
            //   claimsFailObj.selectedSyscode = 'TU';
            //   claimsFailObj.selectedCompCode = 'ST';
            claimsFailObj.selectedSyscode = 'TE';
            claimsFailObj.selectedCompCode = 'TE';
            claimsFailObj.selectedFailMode = 'TE';
            claimsFailObj.accCodeReturned = '';
            claimsFailObj.accCodeSelected = '';
            claimsFailObj.warrantyCompFailure = false;
            claimsFailObj.payCodeSelected = '';
            claimsFailObj.selectedFaultCode = 'w-p';
            claimsFailObj.isMultiPSNEnabled=true;
            string solid = string.valueOf(solCompList[0].id);
            claimsFailObj.deleteCompId=solid;
            list<string> lstpaycode = new list<string>();
            lstpaycode.add('A');
            lstpaycode.add('b');
            
            claimsFailObj.lstpaycode = lstpaycode;
            
            Set<String> failureNameList = new  Set<String>();
            failureNameList.add('Unlisted');
            failureNameList.add('Unlisted1');
            failureNameList.add('Unlisted2');
            
            test.startTest();
            //Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
            //claimsFailObj.getFailurenames();
            claimsFailObj.getComponentCodes();
            claimsFailObj.getSystemCodes();
            claimsFailObj.getFailModes();
            claimsFailObj.changeFailures();
            claimsFailObj.FailureDateHidden = 'test';
            claimsFailObj.failureDate1 = system.today();
            claimsFailobj.failureNameList = failureNameList;
            // claimsFailObj.getselectedSCodes();
            // claimsFailObj.changeSCodes();
            claimsFailObj.selectedSysCode = 'TEST';
            claimsFailObj.selectedCompCode = 'TEST';
            claimsFailObj.selectedFailMode = 'TEST';
            claimsFailObj.selectedFaultCode = 'w-f';
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            insert JO;
            ApexPages.currentPage().getParameters().put('id',JO.id);
            CSS_Claims__c claims = new CSS_Claims__c();
            claims.Status__c='Submitted';
            claims.ReconEngineFlag__c = null;
            claims.ESN__c='79462880';
            claims.Customer_Name__c='BRITESTONE COLONY';
            claims.Customer_Code__c='123';
            claims.Location_Code__c='12345-12345';
            claims.Multi_PSN_Claim__c=false; 
            insert claims;
            CSS_PSN__c psn = new CSS_PSN__c();
            psn.Name='73806085';
            psn.Unit_Number__c='123';
            psn.Application__c='AUTOMOTIVE';
            psn.Service_Model__c='ISB6.7 CM2350 B101';
            psn.Make__c='INTERNATIONAL';
            psn.Model__c='DURASTAR';
            psn.Mileage_Measure__c='Miles';
            psn.Unit_Type__c='CONVENTIONAL';
            psn.PSN__c='73806085';
            psn.ApplicationCode__c ='130';
            psn.CSS_Claims__c=claims.id;
            psn.Primary__c=true;
            insert psn;
            CSS_Solution_Component__c solComp3 = new CSS_Solution_Component__c();
            solComp3.Name = 'unlisted';
            solComp3.Component_Code__c = 'TEST';
            solComp3.System_Code__c = 'TEST';
            solComp3.Failure_Mode__c = 'TEST';
            solComp3.Failure_Measure__c = 'Testing';
            solcomp3.AccountCode__c='THAC';
            solComp3.Failure_Point__c = 5.5;
            insert solComp3;
            CSS_Solution_Component__c solComp41 = new CSS_Solution_Component__c();
            solComp41.AccountCodeEdit__c = 'Testing';
            insert solComp41;
            CSS_Solution_Component__c solComp4 = new CSS_Solution_Component__c();
            solComp4.Component_Code__c = 'TE';
            solComp4.Failure_Mode__c  = 'TE';
            solComp4.System_Code__c = 'TE';
            solcomp4.AccountCodeEdit__c='WEPQ';
            solComp4.name = 'Unlisted';
            insert solComp4;
            claimsFailObj.checkCoverage();
            claimsFailObj.getPayCodesonAccCodeChange();
            claimsFailObj.getPayCodesList('65');
            claimsFailObj.getPayCodes(lstpaycode);
            claimsFailObj.cancelPopup();
            claimsFailObj.closeDeletePopup();
            string solid1 = string.valueOf(solCompList[0].id);
            claimsFailObj.deleteCompId=solid1;
            claimsFailObj.deleteSolRecord();
            claimsFailObj.getAccCodeList();
            claimsFailObj.getPayCodes(null);
            test.stopTest();
        }
    }
    
    public static testmethod void Method3()
    {
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        {  
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq; 
            CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
            cid.name = 'CSS_SBL_WarrantyDetailCoverage';
            cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
            cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
            insert cid;
            
            CSS_TestData.createAccountLanguage(true);
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Location_Code__c='12345-12345';
            insert testclaimsRec;
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solComp1.Component_Id__c ='F0051000';
            solComp1.css_claims__c = testclaimsRec.id;
            solComp1.Performed_Review__c = True;
            solComp1.Status__c='Approved';
            solComp1.Complete_Indicator__c=true; 
            solComp1.Multiple_Times__c=true;
            solcomp1.AccountCode__c = '65';
            solcomp1.AccountCodeEdit__c = 'Test';
            solcomp1.Selected_Component__c = true;
            solcomp1.CSS_Claims__c = testclaimsRec.Id;
            solcomp1.Failure_Point__c = 12;
            solcomp1.Failure_Measure__c = 'test';
            solCompList.add(solComp1);
            insert solCompList;
            
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            je1.Attribute3__c = '65';
            je1.key__c = 'AccountCodes';
            je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
            insert je1;
            
            CSS_JobEventTemporary__c je2 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute1__c = 'ST';
            je2.Attribute4__c = 'TW';
            je2.Attribute1__c = 'EZ';
            je2.key__c = 'FailCodes';
            insert je2;
            
            CSS_JobEventTemporary__c je3 = CSS_TestData.createJobEventTempObj(false);
            je3.Attribute4__c = 'Crank';
            je3.key__c = 'FailModes';
            insert je3;
            
            ApexPages.CurrentPage().getParameters().put('Id',testclaimsRec.id);
            
            css_header_nav__c cssHeaderObject = css_header_nav__c.getInstance();
            cssHeaderObject.RSWButtonEnable__c = true;
            insert cssHeaderObject;
            
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            claimsFailObj.selectedPayCode = 'A';
            claimsFailObj.selectedFName = null;
            claimsFailObj.selectedSyscode = 'TU';
            claimsFailObj.selectedCompCode = 'ST';
            claimsFailObj.accCodeReturned = '';
            claimsFailObj.accCodeSelected = '';
            claimsFailObj.warrantyCompFailure = false;
            claimsFailObj.payCodeSelected = '';
            claimsFailObj.selectedFaultCode = 'w-p';
            claimsFailObj.isMultiPSNEnabled=true;
            string solid = string.valueOf(solCompList[0].id);
            claimsFailObj.deleteCompId=solid;
            list<string> lstpaycode = new list<string>();
            lstpaycode.add('A');
            lstpaycode.add('b');
            
            claimsFailObj.lstpaycode = lstpaycode;
            
            test.startTest();
            claimsFailObj.getComponentCodes();
            claimsFailObj.getSystemCodes();
            claimsFailObj.getFailModes();
            claimsFailObj.changeFailures();
            
            claimsFailObj.selectedSysCode = 'TEST';
            claimsFailObj.selectedCompCode = 'TEST';
            claimsFailObj.selectedFailMode = 'TEST';
            claimsFailObj.selectedFaultCode = 'w-f';
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            JO.ApplicationCode__c = 'test';
            insert JO;
            ApexPages.currentPage().getParameters().put('id',JO.id);
            CSS_Claims__c claims = new CSS_Claims__c();
            claims.CSS_Job__c = JO.id;
            claims.Status__c='Submitted';
            claims.ReconEngineFlag__c = null;
            claims.ESN__c='79462880';
            claims.Customer_Name__c='BRITESTONE COLONY';
            claims.Customer_Code__c='123';
            claims.Location_Code__c='12345-12345';
            claims.Multi_PSN_Claim__c=false; 
            insert claims;
            CSS_PSN__c psn = new CSS_PSN__c();
            psn.Name='73806085';
            psn.Unit_Number__c='123';
            psn.Application__c='AUTOMOTIVE';
            psn.Service_Model__c='ISB6.7 CM2350 B101';
            psn.Make__c='INTERNATIONAL';
            psn.Model__c='DURASTAR';
            psn.Mileage_Measure__c='Miles';
            psn.Unit_Type__c='CONVENTIONAL';
            psn.PSN__c='73806085';
            psn.ApplicationCode__c = null;
            psn.CSS_Claims__c=claims.id;
            psn.Primary__c=true;
            insert psn;
            CSS_Solution_Component__c solComp3 = new CSS_Solution_Component__c();
            solComp3.Name = 'unlisted';
            solComp3.Component_Code__c = 'TEST';
            solComp3.System_Code__c = 'TEST';
            solComp3.Failure_Mode__c = 'TEST';
            solComp3.Failure_Measure__c = 'Testing';
            solComp3.Failure_Point__c = 5.5;
            insert solComp3;
            CSS_Solution_Component__c solComp4 = new CSS_Solution_Component__c();
            solComp4.AccountCodeEdit__c = 'New Parts Warrenty 787';
            insert solComp4;
            claimsFailObj.checkCoverage();
            claimsFailObj.getPayCodesonAccCodeChange();
            claimsFailObj.getPayCodesList('65');
            claimsFailObj.getPayCodes(lstpaycode);
            claimsFailObj.cancelPopup();
            claimsFailObj.closeDeletePopup();
            claimsFailObj.popUpSave(); 
            string solid1 = string.valueOf(solCompList[0].id);
            claimsFailObj.deleteCompId=solid1;
            claimsFailObj.deleteSolRecord();
            claimsFailObj.getAccCodeList();
            test.stopTest();
            
            
        }
    }
    
    public static testmethod void Method4()
    {
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        {  
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq; 
            CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
            cid.name = 'CSS_SBL_WarrantyDetailCoverage';
            cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
            cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
            insert cid;
            
            CSS_TestData.createAccountLanguage(true);
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            //CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            //testclaimsRec.ReconEngineFlag__c = 'y';
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Location_Code__c='12345-12345';
            testclaimsRec.PACCAR_PW_AutoSelected__c = true;
            insert testclaimsRec;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solComp1.Component_Id__c ='F0051000';
            solComp1.AccountCodeEdit__c = 'test';
            solComp1.css_claims__c = testclaimsRec.id;
            solComp1.Performed_Review__c = True;
            solComp1.Status__c='Approved';
            solComp1.Complete_Indicator__c=true; 
            solComp1.Multiple_Times__c=true;
            solcomp1.AccountCode__c = '65';
            solcomp1.Selected_Component__c = true;
            solcomp1.CSS_Claims__c = testclaimsRec.Id;
            solcomp1.Failure_Point__c = 12;
            solcomp1.Failure_Measure__c = 'test';
            solCompList.add(solComp1);
            insert solCompList;
            
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            je1.Attribute1__c = '65';
            je1.key__c = 'AccountCodes';
            je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
            insert je1;
            
            CSS_JobEventTemporary__c je2 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute1__c = 'ST';
            je2.Attribute4__c = 'TW';
            je2.Attribute1__c = 'EZ';
            je2.key__c = 'FailCodes';
            insert je2;
            
            CSS_JobEventTemporary__c je3 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute4__c = 'Crank';
            je2.key__c = 'FailModes';
            insert je3;
            
            ApexPages.CurrentPage().getParameters().put('Id',testclaimsRec.id);
            
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            claimsFailObj.selectedPayCode = 'A';
            claimsFailObj.selectedFName = 'Unlisted';
            claimsFailObj.selectedSyscode = 'TU';
            claimsFailObj.selectedCompCode = 'ST';
            claimsFailObj.accCodeReturned = '';
            claimsFailObj.accCodeSelected = '';
            claimsFailObj.warrantyCompFailure = false;
            claimsFailObj.payCodeSelected = '';
            claimsFailObj.selectedFaultCode = 'w-p';
            claimsFailObj.isMultiPSNEnabled=true;
            string solid = string.valueOf(solCompList[0].id);
            claimsFailObj.deleteCompId=solid;
            list<string> lstpaycode = new list<string>();
            lstpaycode.add('A');
            lstpaycode.add('b');
            
            claimsFailObj.lstpaycode = lstpaycode;
            
            test.startTest();
            claimsFailObj.getComponentCodes();
            claimsFailObj.getSystemCodes();
            claimsFailObj.getFailModes();
            claimsFailObj.changeFailures();
            claimsFailObj.selectedSysCode = 'TEST';
            claimsFailObj.selectedCompCode = 'TEST';
            claimsFailObj.selectedFailMode = 'TEST';
            claimsFailObj.selectedFaultCode = 'w-f';
            CSS_Job_Order__c JO = new CSS_Job_Order__c();
            insert JO;
            
            List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>();
            CSS_Claims__c claims = new CSS_Claims__c();
            claims.Status__c='Submitted';
            claims.ReconEngineFlag__c = null;
            claims.ESN__c='79462880';
            claims.Customer_Name__c='BRITESTONE COLONY';
            claims.Customer_Code__c='123';
            claims.Location_Code__c='12345-12345';
            claims.Multi_PSN_Claim__c=false; 
            claimsList.add(claims);
            
            CSS_Claims__c claims1 = new CSS_Claims__c();
            claims1.Status__c='Submitted';
            claims1.ReconEngineFlag__c = null;
            claims1.ESN__c='79462880';
            claims1.Customer_Name__c='BRITESTONE COLONY';
            //claims1.CSS_Job__c = JO.id;
            claims1.Dealer_Service_Job__c = JO.id;
            claimsList.add(claims1);
            insert claimsList;
            
            CSS_PSN__c psn = new CSS_PSN__c();
            psn.Name='73806085';
            psn.Unit_Number__c='123';
            psn.Application__c='AUTOMOTIVE';
            psn.Service_Model__c='ISB6.7 CM2350 B101';
            psn.Make__c='INTERNATIONAL';
            psn.Model__c='DURASTAR';
            psn.Mileage_Measure__c='Miles';
            psn.Product_Hours__c = 20;
            psn.Unit_Type__c='CONVENTIONAL';
            psn.PSN__c='10000000';
            psn.ApplicationCode__c ='130';
            psn.CSS_Claims__c=testclaimsRec.id;
            psn.Primary__c=true;
            insert psn;
            CSS_Solution_Component__c solComp3 = new CSS_Solution_Component__c();
            solComp3.Name = 'unlisted';
            solComp3.Component_Code__c = 'TEST';
            solComp3.System_Code__c = 'TEST';
            solComp3.Failure_Mode__c = 'TEST';
            solComp3.Failure_Measure__c = 'Testing';
            solComp3.Failure_Point__c = 5.5;
            insert solComp3;
            CSS_Solution_Component__c solComp4 = new CSS_Solution_Component__c();
            solComp4.AccountCodeEdit__c = 'New Parts Warrenty 662';
            insert solComp4;
            claimsFailObj.checkCoverage();
            claimsFailObj.getPayCodesonAccCodeChange();
            claimsFailObj.getPayCodesList('65');
            claimsFailObj.getPayCodes(lstpaycode);
            claimsFailObj.cancelPopup();
            claimsFailObj.closeDeletePopup();
            string solid1 = string.valueOf(solCompList[0].id);
            claimsFailObj.deleteCompId=solid1;
            claimsFailObj.deleteSolRecord();
            claimsFailObj.getAccCodeList();
            test.stopTest();
            
            
        }
    }
    
    public static testmethod void Method5()
    {
        Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '12345-12345');
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        {  
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;  
            CSS_TestData.createAccountLanguage(true);
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Location_Code__c='12345-12345';
            testclaimsRec.Multi_PSN_Claim__c=true;
            testclaimsRec.Service_Model__c='test';
            insert testclaimsRec;
            
            testpsnNewRec.psn__c = '79464646';
            testpsnNewRec.Service_Model__c = 'ISX15 CM2250';
            testpsnNewRec.Qsol_Engine_Family_Code__c = '10';
            testpsnNewRec.css_Claims__C =  testclaimsRec.id; 
            testpsnNewRec.Before_In_Service__c=true;
            insert testpsnNewRec;
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solcomp1.name='unlisted';
            solcomp1.System_Code__c='TEST';
            solcomp1.Component_Code__c='TEST';
            solComp1.Component_Id__c ='F0051000';
            solComp1.css_claims__c = testclaimsRec.id;
            solComp1.Performed_Review__c = True;
            solComp1.Status__c='Approved';
            solComp1.Complete_Indicator__c=true; 
            solComp1.Multiple_Times__c=true;
            solcomp1.AccountCode__c = '65';
            solcomp1.Selected_Component__c = true;
            
            solcomp1.CSS_Claims__c = testclaimsRec.Id;
            solCompList.add(solComp1);
            
            insert solCompList;
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            
            je1.Attribute1__c = '67';
            
            je1.key__c = 'AccountCodes';
            
            je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
            
            insert je1;
            CSS_JobEventTemporary__c je2 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute1__c = 'ST';
            je2.Attribute4__c = 'TW';
            je2.key__c = 'FailCodes';
            insert je2;
            
            CSS_JobEventTemporary__c je3 = CSS_TestData.createJobEventTempObj(false);
            je3.Attribute1__c = 'EZ';
            je3.Attribute3__c = 'Crank';
            je3.key__c = 'FailModes';
            insert je3;
            
            ApexPages.CurrentPage().getParameters().put('Id',testclaimsRec.id);
            
            String json = '{'+
                '                \"DataArea\": ['+
                '                {'+
                '                                \"ComponentCode\": \"CG\",'+
                '                                \"FailureMode\": \"\",'+
                '                                \"FailureID\": \"F30000860\",'+
                '                                \"FailureName\": \"Accessory Plate Cover Gasket\",'+
                '                                \"SystemCode\": \"BG\"'+
                '                }],'+
                ''+
                '                \"Header\": {'+
                '                                \"ReturnCodeDescription\":\"Normal, Successful completion.\",'+
                '                                \"ReturnCode\": \"ORA-00000\",'+
                '                                \"MessageIdentifier\": \"S\"'+
                '                }'+
                '}';
            
            Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
            
            CSS_SRTComponentLookupResponseJ2A controller = CSS_SRTComponentLookupResponseJ2A.parse(json);
            
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            claimsFailObj.solCompListOne=false;
            claimsFailObj.selectedSysCode = 'WE';
            claimsFailObj.selectedPayCode = 'A';
            
            claimsFailObj.accCodeReturned = '';
            claimsFailObj.accCodeSelected = '';
            claimsFailObj.warrantyCompFailure = false;
            claimsFailObj.payCodeSelected = '';
            claimsFailObj.selectedFaultCode = '';
            claimsFailObj.selectedCustFName = 'test7';
            claimsFailObj.selectedFailMode='test'; 
            claimsFailObj.selectedFName = 'turbo';
            list<string> lstpaycode = new list<string>();
            lstpaycode.add('A');
            lstpaycode.add('b');
            claimsFailObj.lstpaycode = lstpaycode;
            
            claimsFailObj.changeFailures();
            string solid12=string.valueOf(solCompList[0].id);
            claimsFailObj.selectedCompId=solid12;
            CSS_Solutions__c sol1 = new CSS_Solutions__c();
            List<CSS_Solution_Component__c> solCompList1 = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
            solComp2.Id = sol1.id;
            solComp2.Component_Code__c = 'QP';
            solComp2.System_Code__c = 'WE';
            solCompList1.add(solComp2);
            insert solCompList1;
            claimsFailObj.changeCustFailures();
            claimsFailObj.selectedCompId = solid12;
            claimsFailObj.loadPopup();
            claimsFailObj.deletePSNRecord();
            claimsFailobj.DeletePopupAC();
            
        }
    }
    
    public static testmethod void Method6()
    {
        Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '12345-12345');
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        {  
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;  
            CSS_TestData.createAccountLanguage(true);
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Location_Code__c='12345-12345';
            testclaimsRec.Multi_PSN_Claim__c=true;
            insert testclaimsRec;
            testpsnNewRec.psn__c = '79464646';
            testpsnNewRec.Service_Model__c = 'ISX15 CM2250';
            testpsnNewRec.Qsol_Engine_Family_Code__c = '10';
            testpsnNewRec.css_Claims__C =  testclaimsRec.id;  
            testpsnNewRec.Before_In_Service__c=false;
            insert testpsnNewRec;
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solComp1.Component_Id__c ='F0051000';
            solComp1.css_claims__c = testclaimsRec.id;
            solComp1.Performed_Review__c = True;
            solComp1.Status__c='Approved';
            solComp1.Complete_Indicator__c=true; 
            solComp1.Multiple_Times__c=true;
            solcomp1.AccountCode__c = '65';
            solcomp1.Selected_Component__c = true;
            solcomp1.Failure_Mode__c = 'EZ';
            solcomp1.Fault_Code__c = 'test';
            solcomp1.CSS_Claims__c = testclaimsRec.Id;
            solCompList.add(solComp1);
            
            insert solCompList;
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            
            je1.Attribute1__c = '67';
            
            je1.key__c = 'AccountCodes';
            
            je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
            
            insert je1;
            CSS_JobEventTemporary__c je2 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute1__c = testpsnNewRec.Service_Model__c ;
            je2.Attribute2__c = testpsnNewRec.Qsol_Engine_Family_Code__c;
            je2.Key__c = 'GetFailureCodesSRT';
            insert je2;
            
            CSS_JobEventTemporary__c je3 = CSS_TestData.createJobEventTempObj(false);
            je3.Attribute1__c = 'EZ';
            je3.Attribute3__c = 'Crank';
            je3.key__c = 'FailModes';
            insert je3;
            
            CSS_JobEventTemporary__c je4 = CSS_TestData.createJobEventTempObj(false);
            je4.Attribute1__c = 'Es';
            je4.Attribute3__c = 'Crank1';
            je4.key__c = 'FailModes';
            insert je4;
            
            CSS_JobEventTemporary__c je5 = CSS_TestData.createJobEventTempObj(false);
            je5.Attribute1__c = 'test';
            je5.Attribute3__c = 'Crank1';
            je5.key__c = 'CDSFaultCodes';
            insert je5;
            
            CSS_FN_SRT SRTClass = new CSS_FN_SRT();
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
            csInt.name = 'SRT';
            csInt.ApplicationName__c='SRT';
            csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
            csInt.IsActive__c=true;
            csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
            csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
            csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
            insert csint;
            
            CSS_SRTComponentLookupResponseJ2A failureCodeDetails = SRTClass.getFailureCodesSRT('ISC8.3 CM2250','41','en');
            
            test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());  
            
            ApexPages.CurrentPage().getParameters().put('Id',testclaimsRec.id);
            
            String json = '{'+
                '                \"DataArea\": ['+
                '                {'+
                '                                \"ComponentCode\": \"CG\",'+
                '                                \"FailureMode\": \"\",'+
                '                                \"FailureID\": \"F30000860\",'+
                '                                \"FailureName\": \"Accessory Plate Cover Gasket\",'+
                '                                \"SystemCode\": \"BG\"'+
                '                }],'+
                ''+
                '                \"Header\": {'+
                '                                \"ReturnCodeDescription\":\"Normal, Successful completion.\",'+
                '                                \"ReturnCode\": \"ORA-00000\",'+
                '                                \"MessageIdentifier\": \"S\"'+
                '                }'+
                '}';
            
            Test.setMock(HttpCalloutMock.class, new CSS_FailureCompFN_SRT_Mock());
            
            CSS_SRTComponentLookupResponseJ2A controller = CSS_SRTComponentLookupResponseJ2A.parse(json);
            test.startTest();
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            claimsFailObj.selectedSysCode = 'WE';
            claimsFailObj.selectedPayCode = 'A';
            claimsFailObj.selectedFName = 'unlisted';
            claimsFailObj.accCodeReturned = '';
            claimsFailObj.accCodeSelected = '';
            claimsFailObj.warrantyCompFailure = false;
            claimsFailObj.payCodeSelected = '';
            claimsFailObj.selectedFaultCode = 'test';
            claimsFailObj.selectedFailMode='EZ';          
            list<string> lstpaycode = new list<string>();
            lstpaycode.add('A');
            lstpaycode.add('b');
            claimsFailObj.lstpaycode = lstpaycode;
            claimsFailObj.getFailurenames();
            
            claimsFailObj.changeFailures();
            string solid12=string.valueOf(solCompList[0].id);
            claimsFailObj.selectedCompId=solid12;
            CSS_Solutions__c sol1 = new CSS_Solutions__c();
            List<CSS_Solution_Component__c> solCompList1 = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
            solComp2.Id = sol1.id;
            solComp2.Component_Code__c = 'QP';
            solComp2.System_Code__c = 'WE';
            solCompList1.add(solComp2);
            insert solCompList1;
            
            claimsFailObj.loadPopup();
            claimsFailObj.deletePSNRecord();
            
            test.stopTest();
        }
    }
    
    public static testmethod void Method7()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '12345-12345');
        insert u;
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        {  
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            list<CSS_JobEventTemporary__c> jobjlist = new  list<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c jobj = new CSS_JobEventTemporary__c();
            jobj.Key__c='ApprovalAuthCode';
            jobj.Attribute4__c='DSBDV5790';
            jobj.Attribute5__c='y';
            jobjlist.add(jobj);
            CSS_JobEventTemporary__c jobj1 = new CSS_JobEventTemporary__c();
            jobj1.Key__c='CDSFaultCodes';
            jobj1.Attribute1__c='1121';
            jobj1.Attribute3__c='Transfer Switch failed to open/disconnect - Root Cause Not Known';
            jobjlist.add(jobj1);
            
            CSS_JobEventTemporary__c jobj2 = new CSS_JobEventTemporary__c();
            jobj2.Key__c='FailModes';
            jobj2.Attribute1__c='XO';
            jobj2.Attribute3__c='INSPECTION / NO PROBLEM FOUND';
            jobjlist.add(jobj2);
            insert jobjlist;
            
            //Creating claim record
            css_claims__c claims = css_testdata.createclaims(true,null);
            //Creating PSN record
            css_psn__c psn1=css_testdata.createpsn(true,claims.id);
            
            test.startTest();
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            claimsFailObj.warrantyDate=System.TODAY()+1;
            claimsFailObj.solCompListOne=false;//added to avoid null pointer exception
            claimsfailobj.ApprovalCode='DSBDV5790';
            claimsFailObj.onChangeofAppCode();
            claimsFailobj.getFailModes();
            claimsFailobj.onRadio();
            claimsFailobj.failureDate=system.today()+2;
            claimsFailobj.CompareDates();
            claimsFailobj.getPossession();
            claimsFailobj.getItems();
            claimsFailobj.setManager('Testing');
            claimsFailobj.onAddClick();
            claimsFailobj.compont.Failure_Date__c=null;
            claimsFailobj.failureDate1=system.today();
            claimsFailobj.CompareDates();
            claimsFailobj.failureDate=system.today().adddays(2);
            claimsFailobj.CompareDates();
            claimsFailobj.compont.Failure_Date__c=system.today();
            claimsFailobj.CompareDates();
            test.stopTest();
            
        }
    }
    
    public static testmethod void Method8()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '12345-12345');
        insert u;
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        {  
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            list<CSS_JobEventTemporary__c> jobjlist = new  list<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c jobj = new CSS_JobEventTemporary__c();
            jobj.Key__c='ApprovalAuthCode';
            jobj.Attribute4__c='DSBDV5790';
            jobj.Attribute5__c='z';
            jobjlist.add(jobj);
            CSS_JobEventTemporary__c jobj1 = new CSS_JobEventTemporary__c();
            jobj1.Key__c='CDSFaultCodes';
            jobj1.Attribute1__c='1121';
            jobj1.Attribute3__c='Transfer Switch failed to open/disconnect - Root Cause Not Known';
            jobjlist.add(jobj1);
            
            CSS_JobEventTemporary__c jobj2 = new CSS_JobEventTemporary__c();
            jobj2.Key__c='FailModes';
            jobj2.Attribute1__c='XO';
            jobj2.Attribute3__c='INSPECTION / NO PROBLEM FOUND';
            jobjlist.add(jobj2);
            insert jobjlist;
            
            //Creating claim record
            css_claims__c claims = css_testdata.createclaims(true,null);
            claims.Multi_PSN_Claim__c=true;
            update claims;
            //Creating PSN record
            css_psn__c psn1=css_testdata.createpsn(true,claims.id);
            psn1.Before_In_Service__c=true;
            update psn1;
            test.startTest();
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            claimsFailObj.solCompListOne=false;//added to avoid null pointer exception
            claimsfailobj.ApprovalCode='DSBDV5790';
            claimsFailObj.onChangeofAppCode();
            claimsFailobj.getFailModes();
            claimsFailobj.onRadio();
            claimsFailobj.CompareDates();
            claimsFailobj.getPossession();
            claimsFailobj.getItems();
            claimsFailobj.setManager('Testing');
            claimsFailobj.onAddClick();
            test.stopTest();
            
        }
    }
    
    public static testmethod void Method9()
    {
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new CSS_FailureCompFN_SRT_Mock());
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '12345-12345');
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        {  
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;  
            CSS_TestData.createAccountLanguage(true);
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Location_Code__c='12345-12345';
            insert testclaimsRec;
            
            testpsnNewRec.psn__c = '79464646';
            testpsnNewRec.Service_Model__c = 'ISX15 CM2250';
            testpsnNewRec.Qsol_Engine_Family_Code__c = '10';
            testpsnNewRec.css_Claims__C =  testclaimsRec.id;  
            insert testpsnNewRec;
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solComp1.Component_Id__c ='F0051000';
            solComp1.css_claims__c = testclaimsRec.id;
            solComp1.Performed_Review__c = True;
            solComp1.Status__c='Approved';
            solComp1.Complete_Indicator__c=true; 
            solComp1.Multiple_Times__c=true;
            solcomp1.AccountCode__c = '65';
            solcomp1.Selected_Component__c = true;
            solcomp1.CSS_Claims__c = testclaimsRec.Id;
            solCompList.add(solComp1);
            
            insert solCompList;
            
            ApexPages.CurrentPage().getParameters().put('Id',testclaimsRec.id);
            
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            claimsFailObj.selectedPayCode = 'A';
            claimsFailObj.selectedFName = 'unlisted';
            claimsFailObj.accCodeReturned = '';
            claimsFailObj.accCodeSelected = '';
            claimsFailObj.warrantyCompFailure = false;
            claimsFailObj.payCodeSelected = '';
            claimsFailObj.selectedFaultCode = '';
            claimsFailObj.getSRTFailurenamesOnLoad();
            
            list<string> lstpaycode = new list<string>();
            lstpaycode.add('A');
            lstpaycode.add('b');
            claimsFailObj.lstpaycode = lstpaycode;
            
            //Inserting JET records to test the else condition
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            je1.Attribute1__c = '67';
            je1.key__c = 'AccountCodes';
            je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
            insert je1;
            
            CSS_JobEventTemporary__c je2 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute1__c = 'ST';
            je2.Attribute4__c = 'TW';
            je2.key__c = 'FailCodes';
            insert je2;
            
            CSS_JobEventTemporary__c je3 = CSS_TestData.createJobEventTempObj(false);
            je3.Attribute1__c = 'EZ';
            je3.Attribute4__c = 'Crank';
            je3.key__c = 'FailModes';
            insert je3;
            
            CSS_JobEventTemporary__c je4 = CSS_TestData.createJobEventTempObj(false);
            je4.Attribute1__c = 'ISX15 CM2250';
            je4.Attribute4__c = '10';
            je4.Attribute3__c = 'ISX15 CM2250'+';;'+'10';
            je4.key__c = 'getFailureCodesSRT';
            je4.CreatedDate = date.today()-1;
            insert je4;
            
            
            claimsFailObj.getSRTFailurenamesOnLoad();
            Test.stopTest();
        }
    }
    
    public static Testmethod void Method10()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        
        
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        String grpName = 'CQ'+'-'+'56270-56255';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.Name = 'GetCampaign';
            conDetails.AuthEnv__c = 'OAGOAUTH';
            conDetails.ApplicationName__c = 'GetCampaign';
            conDetails.End_Point__c = 'Test';
            conDetails.Method_Type__c = 'POST';
            conDetails.Timeout__c = 2.0;
            insert conDetails;
            
            CSS_TestData.createAccountLanguage(true);
            
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            //CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
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
            testclaimsRec.ZipCode__c = '12345';
            testclaimsRec.Location_Code__c='56270-56255';
            testclaimsRec.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"5/26/2016","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"5/26/2019","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2019","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2017","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"}]}}}}';
            insert testclaimsRec;
            
            CSS_Job_Order__c job= new CSS_Job_Order__c();
            job.Status__c = 'Intake';
            job.INSITE_UpdateTimeStamp__c =system.today();
            job.INSITE_ESN_Choice__c='Not Selected';
            job.Qsol_Engine_Family_Code__c = 'code';
            job.Warranty_Start_Date__c = date.today();
            job.CSS_Job_Location_Code__c = '56270-56255';
            job.ApplicationCode__c = 'code';
            job.DSID__c='2323';
            job.ESN__c ='21323';
            job.Application__c='asdd';
            job.Unit_Number__c='213';
            job.Failure_Point__c=213.00;
            job.Failure_Point_Measure__c='asd';
            job.Make__c='Make';
            job.ESN_Insite__c = 'insite';
            job.Model__c='Model';
            job.Equipment_ID__c='Equip';
            job.Customer_Name__c='Peterbuilt';
            job.Shop_Work_Order__c='213dssd';
            job.Service_Model__c='SMNNUM';
            job.DSID_Creation_Timestamp__c=system.today();
            job.DSID_Status__c='Stat';
            job.DSID_WorkGroup__c='Wrkgrp';
            job.Status__c = 'Triage & Diagnosis Complete' ;
            job.Previous_Status__c = 'Triage & Diagnosis' ;
            job.Failure_Date__c = date.today();
            insert job;
            
            CSS_Fault_Code__c faulCodeRec = new CSS_Fault_Code__c(Name='3478',Related_Fault_Code__c='98734,95869',isPole__c = true);
            insert faulCodeRec;
            
            List<CSS_SymptomQA__c> symList=new List<CSS_SymptomQA__c>();
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym.Job_Order__c=job.id;
            sym.caption__c ='white smoke';
            sym.Option1__c  ='12213';
            sym.Job_Order__c  =job.id;
            sym.Option_type__c  ='qwewqe';
            sym.Guide_Question__c  ='Do you see smoke';
            sym.Type__c  ='SearchString';
            insert sym; 
            
            CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
            symQA.Job_Order__c=job.id;
            symQA.caption__c ='fault Code';
            symQA.Option1__c  ='12213';
            symQA.Job_Order__c  =job.id;
            symQA.SearchString__c  =sym.id;        
            symQA.Type__c  ='QA';
            insert symQA;
            symList.add(symQA);
            update symList;
            List<Css_Solutions__c> solList = new List<CSS_Solutions__C>();
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Name='test';
            sol.FaultCode__c = faulCodeRec.id;
            sol.Diagnostic_Response__c='test';
            sol.Repair_Response__c='test';
            sol.Symptom__c=sym.id;
            sol.Service_Job__c=job.id;
            //sol.FSL_service_job__c=job.id;
            sol.CSS_Nested_Solutions__c = sol.id;
            sol.rank__c=0;
            sol.Out_Of_Order__c = false;
            sol.Solution_Title__c = 'test';
            sol.Solution__c ='test';
            sol.Report_Comments__c ='qwewqewqewewqe';
            sol.Diagnostic_notes__c ='asdsadad';
            
            solList.add(sol);
            insert solList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            
            CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.css_claims__c = testclaimsRec.id;
            solComp.Action__c = '';
            solcomp.Performed_Review__c = True;
            solcomp.Status__c='Approved';
            solcomp.Complete_Indicator__c=true; 
            solcomp.Multiple_Times__c=true;
            solcomp.AccountCode__c = '65';
            solcomp.Selected_Component__c = true;
            solcomp.Solutions__c = solList[0].Id;
            solcomp.CSS_Claims__c = testclaimsRec.Id;
            solCompList.add(solComp);
            
            CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solComp1.Component_Id__c ='F0051000';
            solComp1.css_claims__c = testclaimsRec.id;
            solComp1.Performed_Review__c = True;
            solComp1.Status__c='Approved';
            solComp1.Complete_Indicator__c=true; 
            solComp1.Multiple_Times__c=true;
            solcomp.AccountCode__c = '62';
            solcomp.Failure_Date__c=date.today();
            solcomp1.Selected_Component__c = true;
            solcomp1.Solutions__c = solList[0].Id;
            solcomp1.CSS_Claims__c = testclaimsRec.Id;
            solCompList.add(solComp1);
            
            insert solCompList;
            
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            je1.Attribute1__c = '67';
            je1.key__c = 'AccountCodes';
            je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
            insert je1;
            
            ApexPages.CurrentPage().getParameters().put('Id',testclaimsRec.id);
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            claimsFailObj.selectedSysCode='BB';
            claimsFailObj.mil_measure='Test';
            claimsFailObj.accCodeWS='Test';
            claimsFailObj.claimtype='test';
            claimsFailObj.FailureDtHidden='test';
            claimsFailObj.coverageType = 'POL';
            claimsFailObj.coverageFound = 'false';
            claimsFailObj.noPopup=true;
            claimsFailObj.showFailurePopup=true;
            claimsFailObj.warrStDtHidden='test';
            claimsfailobj.selectedCompCode='TU';
            claimsfailobj.selectedFailMode='ST';
            Claimsfailobj.onChangeofAppCode();
            claimsFailObj.getAllFailuresData();
            claimsFailObj.resetAllData();
            claimsFailObj.saveClaimFailOvervwData();
            CSS_Claims__c obj = new CSS_Claims__c();
            obj.CoverageResponse__c = 'TestingData';
            insert obj;
            CSS_Solution_Component__c compToUpdate = new CSS_Solution_Component__c();
            compToUpdate.CoveredLaborHrs__c = '99999';
            compToUpdate.CoveredMealsLodgingAmt__c = '1';
            compToUpdate.CoveredOCAmount__c = '1';
            compToUpdate.CoveredPartsQty__c = '1';
            compToUpdate.CoveredTowingMiles__c = '1';
            compToUpdate.CoveredTravelLabor__c = '1';
            compToUpdate.CoveredTravelMiles__c = '1';
            compToUpdate.CertificateNumber__c = '1';
            insert compToUpdate;
            claimsFailObj.compToUpdate = compToUpdate;
            claimsFailObj.selectedFName = 'unlisted';
            claimsFailObj.failureDate = system.today();
            claimsFailObj.failureMeasure = 'Hours';
            claimsFailObj.selectedSysCode = '';
            claimsFailObj.accCodeSelected = '62';
            claimsFailobj.claimTypeSelected = 'ASD';
            claimsFailObj.popUpSave();
            
            
            
        }
        
    }
    
    public static Testmethod void Method11()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        
        String grpName = 'CQ'+'-'+'56270-56255';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.Name = 'GetCampaign';
            conDetails.AuthEnv__c = 'OAGOAUTH';
            conDetails.ApplicationName__c = 'GetCampaign';
            conDetails.End_Point__c = 'Test';
            conDetails.Method_Type__c = 'POST';
            conDetails.Timeout__c = 2.0;
            insert conDetails;
            CSS_TestData.createAccountLanguage(true);
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
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
            testclaimsRec.ZipCode__c = '12345';
            testclaimsRec.Location_Code__c='56270-56255';
            testclaimsRec.Multi_PSN_Claim__c=true;
            testclaimsRec.Information_Only_Claim__c=true;
            testclaimsRec.ReconEngineFlag__c='y';
            testclaimsRec.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"5/26/2016","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"5/26/2019","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2019","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2017","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"}]}}}}';
            insert testclaimsRec;
            
            css_psn__c psn1=css_testdata.createpsn(true,testclaimsRec.id);
            psn1.Before_In_Service__c=true;
            psn1.ApplicationCode__c = null;
            update psn1;
            CSS_Fault_Code__c faulCodeRec = new CSS_Fault_Code__c(Name='3478',Related_Fault_Code__c='98734,95869',isPole__c = true);
            insert faulCodeRec;
            
            List<CSS_SymptomQA__c> symList=new List<CSS_SymptomQA__c>();
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            //sym.Job_Order__c=job.id;
            sym.caption__c ='white smoke';
            sym.Option1__c  ='12213';
            //sym.Job_Order__c  =job.id;
            sym.Option_type__c  ='qwewqe';
            sym.Guide_Question__c  ='Do you see smoke';
            sym.Type__c  ='SearchString';
            insert sym; 
            
            CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
            //symQA.Job_Order__c=job.id;
            symQA.caption__c ='fault Code';
            symQA.Option1__c  ='12213';
            //symQA.Job_Order__c  =job.id;
            symQA.SearchString__c  =sym.id;        
            symQA.Type__c  ='QA';
            insert symQA;
            
            CSS_Job_Order__c del = new CSS_Job_Order__c();
            del.ApplicationCode__c = 'test';
            insert del;
            
            symList.add(symQA);
            update symList;
            List<Css_Solutions__c> solList = new List<CSS_Solutions__C>();
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Name='test';
            sol.FaultCode__c = faulCodeRec.id;
            sol.Diagnostic_Response__c='test';
            sol.Repair_Response__c='test';
            sol.Symptom__c=sym.id;
            //sol.Service_Job__c=job.id;
            sol.CSS_Nested_Solutions__c = sol.id;
            sol.rank__c=0;
            sol.Out_Of_Order__c = false;
            sol.Solution_Title__c = 'test';
            sol.Solution__c ='test';
            sol.Report_Comments__c ='qwewqewqewewqe';
            sol.Diagnostic_notes__c ='asdsadad';
            sol.Service_job__c=del.id;
            //sol.FSL_service_job__c=del.id;
            solList.add(sol);
            insert solList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            
            CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solComp.Component_Id__c ='F0051000';
            solComp.css_claims__c = testclaimsRec.id;
            solComp.Action__c = '';
            solcomp.Performed_Review__c = True;
            solcomp.Status__c='Approved';
            solcomp.Complete_Indicator__c=true; 
            solcomp.Multiple_Times__c=true;
            solcomp.AccountCode__c = '65';
            solcomp.Selected_Component__c = true;
            solcomp.Solutions__c = solList[0].Id;
            solcomp.CSS_Claims__c = testclaimsRec.Id;
            solcomp.Failure_Point__c=12;
            solcomp.Failure_Date__c=Date.TODAY();
            solcomp.Part_Warranty_Start_Date__c=System.TODAY()+2;
            solcomp.Customer_Take_Possession__c='Yes';
            solcomp.Failure_Measure__c = null;
            solCompList.add(solComp);
            
            CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solComp1.Component_Id__c ='F0051000';
            solComp1.css_claims__c = testclaimsRec.id;
            solComp1.Performed_Review__c = True;
            solComp1.Status__c='Approved';
            solComp1.Complete_Indicator__c=true; 
            solComp1.Multiple_Times__c=true;
            solcomp.AccountCode__c = '67';
            solcomp.Failure_Date__c=date.today();
            solcomp1.Selected_Component__c = true;
            solcomp1.Solutions__c = solList[0].Id;
            solcomp1.CSS_Claims__c = testclaimsRec.Id;
            solCompList.add(solComp1);
            
            insert solCompList;
            
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            je1.Attribute1__c = 'POL';
            je1.Attribute2__c='z';
            je1.Attribute3__c='Transfer Switch failed to open/disconnect - Root Cause Not Known';
            je1.Attribute4__c='DSBDV5790';
            je1.key__c = 'AccountCodes';
            insert je1;
            ApexPages.CurrentPage().getParameters().put('Id',testclaimsRec.id);
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            claimsFailObj.selectedSysCode='BB';
            claimsFailObj.mil_measure='Test';
            claimsFailObj.accCodeWS='Test';
            claimsFailObj.claimtype='test';
            claimsFailObj.FailureDtHidden='test';
            claimsFailObj.noPopup=true;
            claimsFailObj.showFailurePopup=true;
            claimsFailObj.warrStDtHidden='test';
            claimsfailobj.selectedCompCode='TU';
            claimsfailobj.selectedFailMode='ST';
            Claimsfailobj.onChangeofAppCode();
            claimsFailObj.getAllFailuresData();
            claimsFailObj.resetAllData();
            claimsFailObj.saveClaimFailOvervwData();
            CSS_Claims__c obj = new CSS_Claims__c();
            obj.CoverageResponse__c = 'TestingData';
            insert obj;
            CSS_Solution_Component__c compToUpdate = new CSS_Solution_Component__c();
            compToUpdate.CoveredLaborHrs__c = '999999';
            compToUpdate.CoveredMealsLodgingAmt__c = '1';
            compToUpdate.CoveredOCAmount__c = '1';
            compToUpdate.CoveredPartsQty__c = '1';
            compToUpdate.CoveredTowingMiles__c = '1';
            compToUpdate.CoveredTravelLabor__c = '1';
            compToUpdate.CoveredTravelMiles__c = '1';
            compToUpdate.CertificateNumber__c = '1';
            insert compToUpdate;
            claimsFailObj.compToUpdate = compToUpdate;
            claimsFailObj.failureMeasure = 'Hours';
            string solid =string.valueOf(solComp.id);
            claimsFailobj.deleteCompId=solid;
            claimsFailobj.deleteSolRecordWOPSN();
            string solid1 =string.valueOf(solComp1.Id);
            claimsFailobj.checkPartCoverage();
            claimsFailObj.getfailurenames();
            claimsFailObj.getComponentCodes();
            claimsFailObj.accCodeSelected = '70';
            claimsFailobj.claimTypeSelected = 'ASD';
            claimsFailObj.checkPartCoverage();
            claimsFailObj.popUpSave();
            
        }
        
    }
    
    public static testmethod void Method12()
    {
        Test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '12345-12345');
        insert u;
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        {  
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;  
            CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
            
            
            Date d = Date.Today();
            // System.debug('date');
            SerRec.DSID__c='12345';
            //SerRec.OwnerId = tq.Id;
            SerRec.DSID_Status__c='open';
            SerRec.ESN__c ='79464646';
            SerRec.CSS_Channel_Code__c ='7943';
            SerRec.Customer_Name__c='ABC';
            SerRec.Failure_Date__c =d;
            SerRec.Failure_Point__c=2.2;
            SerRec.Unit_Number__c='1234';
            SerRec.Territory_Class__c='test';
            SerRec.Qsol_Engine_Family_Code__c='1234';
            SerRec.Service_Model__c='ESN';
            SerRec.Service_Model_N__c = 445566;
            SerRec.Make__c='test';
            SerRec.Model__c='test1';
            SerRec.VIN__c='1XKAD49X6CJ305490';
            SerRec.Customer_Name__c='ABC';
            SerRec.Warranty_Start_Date__c=d;
            SerRec.Application_Desc__c='test1';
            SerRec.Failure_Point_Measure__c = 'MI'; 
            SerRec.Application__c='Automotive'; 
            SerRec.sub_Type__c='cedan';
            SerRec.INSITE_UpdateTimeStamp__c= system.today();
            SerRec.INSITE_ESN_Choice__c='Not Selected';
            SerRec.Shop_Work_Order__c='1234';
            SerRec.DSID_Creation_Timestamp__c=system.today();
            SerRec.DSID_WorkGroup__c='Wrkgrp';
            SerRec.Equipment_ID__c='Equip';
            SerRec.Status__c = 'Triage & Diagnosis/Repair' ;
            SerRec.Previous_Status__c = 'Triage & Diagnosis' ;
            SerRec.CSS_Job_Location_Code__c='56270-56255';
            SerRec.PSN_Not_Available__c = true;
            SerRec.Actual_Technician_Time__c=1.2;
            SerRec.CSS_Resolution__c='Customer Rejected';
            SerRec.ApplicationCode__c='test1';
            insert SerRec;
            CSS_TestData.createAccountLanguage(true);
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.CSS_Job__c=SerRec.id;
            testclaimsRec.Dealer_Service_Job__c=SerRec.id;
            testclaimsRec.Customer_Code__c = '1234';
            testclaimsRec.Contact_Last_Name__c = 'T';
            testclaimsRec.Location_Code__c='12345-12345';
            testclaimsRec.Multi_PSN_Claim__c=true;
            //testclaimsRec.Service_Model__c='test';
            insert testclaimsRec;
            testpsnNewRec.psn__c = '79464646';
            testpsnNewRec.Service_Model__c = 'BG';
            testpsnNewRec.Qsol_Engine_Family_Code__c = '10';
            testpsnNewRec.css_Claims__C =  testclaimsRec.id;  
            testpsnNewRec.Before_In_Service__c=false;
            insert testpsnNewRec;
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solComp1.Component_Id__c ='F0051000';
            solComp1.css_claims__c = testclaimsRec.id;
            solComp1.Performed_Review__c = True;
            solComp1.Status__c='Approved';
            solComp1.Complete_Indicator__c=true; 
            solComp1.Multiple_Times__c=true;
            solcomp1.AccountCode__c = '65';
            solcomp1.Selected_Component__c = true;
            solcomp1.Failure_Mode__c = 'EZ';
            solcomp1.Fault_Code__c = 'test';
            solcomp1.CSS_Claims__c = testclaimsRec.Id;
            solCompList.add(solComp1);
            
            insert solCompList;
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            
            je1.Attribute1__c = '67';
            
            je1.key__c = 'AccountCodes';
            
            je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
            
            insert je1;
            CSS_JobEventTemporary__c je2 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute1__c = testpsnNewRec.Service_Model__c ;
            je2.Attribute2__c = testpsnNewRec.Qsol_Engine_Family_Code__c;
            je2.Key__c = 'getFailureCodesSRT';
            insert je2;
            String json1 = '{'+
                '                \"DataArea\": ['+
                '                {'+
                '                                \"ComponentCode\": \"CG\",'+
                '                                \"FailureMode\": \"\",'+
                '                                \"FailureID\": \"F30000860\",'+
                '                                \"FailureName\": \"Accessory Plate Cover Gasket\",'+
                '                                \"SystemCode\": \"BG\"'+
                '                }],'+
                ''+
                '                \"Header\": {'+
                '                                \"ReturnCodeDescription\":\"Normal, Successful completion.\",'+
                '                                \"ReturnCode\": \"ORA-00000\",'+
                '                                \"MessageIdentifier\": \"S\"'+
                '                }'+
                '}';
            CSS_JobEventTemporary__c je21 = CSS_TestData.createJobEventTempObj(false);
            je21.Attribute1__c = testpsnNewRec.Service_Model__c ;
            je21.Attribute2__c = testpsnNewRec.Qsol_Engine_Family_Code__c;
            je21.Key__c = 'getFailureCodesSRT';
            je21.Attribute3__c = 'BG;;10';
            je21.Attribute4__c = 'CG';
            je21.Reason__c = json1;
            insert je21;
            
            CSS_JobEventTemporary__c je3 = CSS_TestData.createJobEventTempObj(false);
            je3.Attribute1__c = 'EZ';
            je3.Attribute3__c = 'Crank';
            je3.key__c = 'FailModes';
            insert je3;
            
            CSS_JobEventTemporary__c je4 = CSS_TestData.createJobEventTempObj(false);
            je4.Attribute1__c = 'BG';
            je4.Attribute4__c = 'Crank1';
            je4.key__c='FailCodes';
            je4.Attribute3__c = 'BG;;10';
            je4.Attribute4__c = 'CG';
            //je2.key__c = 'FailCodes';
            je4.Reason__c = json1;
            insert je4;
            
            CSS_JobEventTemporary__c je5 = CSS_TestData.createJobEventTempObj(false);
            je5.Attribute1__c = 'test';
            je5.Attribute3__c = 'Crank1';
            je5.key__c = 'CDSFaultCodes';
            insert je5;
            
            CSS_FN_SRT SRTClass = new CSS_FN_SRT();
            CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
            csInt.name = 'SRT';
            csInt.ApplicationName__c='SRT';
            csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
            csInt.IsActive__c=true;
            csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
            csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
            csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
            insert csint;
            
            CSS_SRTComponentLookupResponseJ2A failureCodeDetails = SRTClass.getFailureCodesSRT('ISC8.3 CM2250','41','en');
            
            test.setMock(HttpCalloutMock.class, new SRTMockHttpResponseGenerator());  
            
            ApexPages.CurrentPage().getParameters().put('Id',testclaimsRec.id);
            
            String json = '{'+
                '                \"DataArea\": ['+
                '                {'+
                '                                \"ComponentCode\": \"CG\",'+
                '                                \"FailureMode\": \"\",'+
                '                                \"FailureID\": \"F30000860\",'+
                '                                \"FailureName\": \"Accessory Plate Cover Gasket\",'+
                '                                \"SystemCode\": \"BG\"'+
                '                }],'+
                ''+
                '                \"Header\": {'+
                '                                \"ReturnCodeDescription\":\"Normal, Successful completion.\",'+
                '                                \"ReturnCode\": \"ORA-00000\",'+
                '                                \"MessageIdentifier\": \"S\"'+
                '                }'+
                '}';
            
            Test.setMock(HttpCalloutMock.class, new CSS_FailureCompFN_SRT_Mock());
            
            CSS_SRTComponentLookupResponseJ2A controller = CSS_SRTComponentLookupResponseJ2A.parse(json);
            test.startTest();
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            claimsFailObj.selectedSysCode = 'WE';
            claimsFailObj.selectedPayCode = 'A';
            claimsFailObj.selectedFName = 'unlisted';
            claimsFailObj.accCodeReturned = '';
            claimsFailObj.accCodeSelected = '';
            claimsFailObj.warrantyCompFailure = false;
            claimsFailObj.payCodeSelected = '';
            claimsFailObj.selectedFaultCode = 'test';
            claimsFailObj.selectedFailMode='EZ';          
            list<string> lstpaycode = new list<string>();
            lstpaycode.add('A');
            lstpaycode.add('b');
            claimsFailObj.lstpaycode = lstpaycode;
            claimsFailObj.getFailurenames();
            
            claimsFailObj.changeFailures();
            string solid12=string.valueOf(solCompList[0].id);
            claimsFailObj.selectedCompId=solid12;
            CSS_Solutions__c sol1 = new CSS_Solutions__c();
            List<CSS_Solution_Component__c> solCompList1 = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c solComp2 = new CSS_Solution_Component__c();
            solComp2.Id = sol1.id;
            solComp2.Component_Code__c = 'QP';
            solComp2.System_Code__c = 'WE';
            solCompList1.add(solComp2);
            insert solCompList1;
            
            claimsFailObj.loadPopup();
            claimsFailObj.deletePSNRecord();
            
            test.stopTest();
        }
    }
    
    public static Testmethod void Method13()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced'];
        User u = new User(Alias = 'standt', Email='standarduser4@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US',  ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTest1User4@testorg.com',User_Location__c = '56270-56255');
        insert u;
        
        
        Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        String grpName = 'CQ'+'-'+'56270-56255';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        account acc = new account();
        acc.Name = 'test';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '25270';
        acc.CMI_Account_Status__c = 'Active';
        acc.IAM_Service_Provider_Code__c = '25720';
        insert acc; 
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.Name = 'GetCampaign';
            conDetails.AuthEnv__c = 'OAGOAUTH';
            conDetails.ApplicationName__c = 'GetCampaign';
            conDetails.End_Point__c = 'Test';
            conDetails.Method_Type__c = 'POST';
            conDetails.Timeout__c = 2.0;
            insert conDetails;
            
            CSS_TestData.createAccountLanguage(true);
            CSS_Claims__c testclaimsRec1 = new CSS_Claims__c();
            //CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
            testclaimsRec1.Customer_Name__c='TestCustomer';
            testclaimsRec1.Customer_Code__c = '1234';
            testclaimsRec1.Contact_Last_Name__c = 'T';
            testclaimsRec1.Address__c = 'T';
            testclaimsRec1.Customer_Contact_Phone__c = null;
            testclaimsRec1.Email_Address__c = 'rp@sct.com';
            testclaimsRec1.Status__c = 'Draft';
            testclaimsRec1.TSR1__c = '1234';
            testclaimsRec1.TSR2__c = '1234';
            testclaimsRec1.TSR3__c = '1234';
            testclaimsRec1.TSR4__c = '1234';
            testclaimsRec1.TSR5__c = '1234';
            testclaimsRec1.TSR6__c = '1234';
            testclaimsRec1.TSR7__c = '1234';
            testclaimsRec1.TSR8__c = '1234';
            testclaimsRec1.TSR9__c = '1234';
            testclaimsRec1.TSR10__c = '1234';
            testclaimsRec1.Country__c = '1234';
            testclaimsRec1.State__c = '1234';
            testclaimsRec1.ZipCode__c = '12345';
            testclaimsRec1.Location_Code__c='56270-56255';
            testclaimsRec1.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"5/26/2016","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"5/26/2019","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2019","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2017","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"}]}}}}';
            insert testclaimsRec1;
            
            CSS_Job_Order__c job= new CSS_Job_Order__c();
            job.Status__c = 'Intake';
            job.INSITE_UpdateTimeStamp__c =system.today();
            job.INSITE_ESN_Choice__c='Not Selected';
            job.Qsol_Engine_Family_Code__c = 'code';
            job.Warranty_Start_Date__c = date.today();
            job.CSS_Job_Location_Code__c = '56270-56255';
            job.ApplicationCode__c = 'code';
            job.DSID__c='2323';
            job.ESN__c ='21323';
            job.Application__c='asdd';
            job.Unit_Number__c='213';
            job.Failure_Point__c=213.00;
            job.Failure_Point_Measure__c='asd';
            job.Make__c='Make';
            job.ESN_Insite__c = 'insite';
            job.Model__c='Model';
            job.Equipment_ID__c='Equip';
            job.Customer_Name__c='Peterbuilt';
            job.Shop_Work_Order__c='213dssd';
            job.Service_Model__c='SMNNUM';
            job.DSID_Creation_Timestamp__c=system.today();
            job.DSID_Status__c='Stat';
            job.DSID_WorkGroup__c='Wrkgrp';
            job.Status__c = 'Triage & Diagnosis Complete' ;
            job.Previous_Status__c = 'Triage & Diagnosis' ;
            job.Failure_Date__c = date.today();
            insert job;
            
            CSS_Job_Order__c del = new CSS_Job_Order__c();
            del.ApplicationCode__c = 'test';
            insert del;
            
            CSS_Claims__c testclaimsRec = new CSS_Claims__c();
            testclaimsRec.Customer_Name__c='TestCustomer';
            testclaimsRec.CSS_Job__c = job.id;
            testclaimsRec.Dealer_Service_Job__c = del.id;
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
            testclaimsRec.ZipCode__c = '12345';
            testclaimsRec.Location_Code__c='56270-56255';
            testclaimsRec.CoverageResponse__c = '{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"5/26/2016","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"5/26/2019","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2019","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2017","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"}]}}}}';
            insert testclaimsRec;
            list<CSS_PSN__c> psnlst = new list<CSS_PSN__c>();
            CSS_PSN__c psnobj = new CSS_PSN__c();
            psnobj.PSN__c='79464646';
            psnobj.CSS_Claims__c = testclaimsRec.id;
            psnobj.Service_Model__c='IX0768';
            psnobj.Qsol_Engine_Family_Code__c='Test';
            psnobj.ApplicationCode__c='130';
            insert psnobj;
            psnlst.add(psnobj);
            
            CSS_Fault_Code__c faulCodeRec = new CSS_Fault_Code__c(Name='3478',Related_Fault_Code__c='98734,95869',isPole__c = true);
            insert faulCodeRec;
            
            List<CSS_SymptomQA__c> symList=new List<CSS_SymptomQA__c>();
            CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
            sym.Job_Order__c=job.id;
            sym.caption__c ='white smoke';
            sym.Option1__c  ='12213';
            sym.Job_Order__c  =job.id;
            sym.Option_type__c  ='qwewqe';
            sym.Guide_Question__c  ='Do you see smoke';
            sym.Type__c  ='SearchString';
            insert sym; 
            
            CSS_SymptomQA__c symQA=new CSS_SymptomQA__c();
            symQA.Job_Order__c=job.id;
            symQA.caption__c ='fault Code';
            symQA.Option1__c  ='12213';
            symQA.Job_Order__c  =job.id;
            symQA.SearchString__c  =sym.id;        
            symQA.Type__c  ='QA';
            insert symQA;
            
            symList.add(symQA);
            update symList;
            
            
            
            List<Css_Solutions__c> solList = new List<CSS_Solutions__C>();
            
            CSS_Solutions__c sol=new CSS_Solutions__c();
            sol.Case_Name__c='test';
            sol.Name='test';
            sol.FaultCode__c = faulCodeRec.id;
            sol.Diagnostic_Response__c='test';
            sol.Repair_Response__c='test';
            sol.Symptom__c=sym.id;
            sol.Service_Job__c=job.id;
            //sol.FSL_service_job__c=job.id;
            sol.CSS_Nested_Solutions__c = sol.id;
            sol.rank__c=0;
            sol.Out_Of_Order__c = false;
            sol.Solution_Title__c = 'test';
            sol.Solution__c ='test';
            sol.Report_Comments__c ='qwewqewqewewqe';
            sol.Diagnostic_notes__c ='asdsadad';
            
            solList.add(sol);
            insert solList;
            
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            
            CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            solcomp.System_Code__c = 'aka';
            solcomp.Component_Code__c = 'akaa';
            solComp.Component_Id__c ='F0051000';
            solComp.css_claims__c = testclaimsRec.id;
            solComp.Action__c = '';
            solcomp.Performed_Review__c = True;
            solcomp.Status__c='Approved';
            solcomp.Complete_Indicator__c=true; 
            solcomp.Multiple_Times__c=true;
            //solcomp.SysCodeAndCompCode__c='test12';
            solcomp.AccountCode__c = '';
            solcomp.Selected_Component__c = true;
            solcomp.Solutions__c = solList[0].Id;
            solcomp.AccountCode_Call_Status__c='Failure';
            solcomp.Failure_Date__c= System.today()+1;
            solcomp.AccountCodeEdit__c = '62';
            solcomp.Customer_Take_Possession__c = 'No';
            solcomp.CSS_Claims__c = testclaimsRec.Id;
            solcomp.Type__c = 'ATC';
            solCompList.add(solComp);
            
            CSS_Solution_Component__c solComp1 = new CSS_Solution_Component__c();
            solComp1.Component_Id__c ='F0051000';
            solComp1.css_claims__c = testclaimsRec.id;
            solComp1.Performed_Review__c = True;
            solComp1.Status__c='Approved';
            solComp1.Complete_Indicator__c=true; 
            solComp1.Multiple_Times__c=true;
            //solcomp.AccountCode__c = '67';
            // solcomp.AccountCode__c = '62';
            solcomp.Failure_Date__c=date.today();
            solcomp1.Selected_Component__c = true;
            solcomp1.Solutions__c = solList[0].Id;
            //solcomp1.SysCodeAndCompCode__c='test1';
            solcomp1.System_Code__c='BT';
            solcomp1.Component_Code__c='ER';
            solcomp1.CSS_Claims__c = testclaimsRec.Id;
            solCompList.add(solComp1);
            
            insert solCompList;
            
            CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
            je1.Attribute1__c = 'POL';
            je1.Attribute2__c='z';
            je1.Attribute3__c='Transfer Switch failed to open/disconnect - Root Cause Not Known';
            je1.Attribute4__c='DSBDV5790';
            insert je1;
            
            
            CSS_JobEventTemporary__c je2 = CSS_TestData.createJobEventTempObj(false);
            je2.Attribute1__c = 'POL';
            je2.Attribute2__c='z';
            je2.Attribute3__c='Transfer Switch failed to open/disconnect - Root Cause Not Known';
            je2.Attribute4__c='DSBDV5790';
            je2.key__c = 'FailCodes';
            
            insert je2;
            
            
            ApexPages.CurrentPage().getParameters().put('Id',testclaimsRec.id);
            CG_CL_ClaimsFailuresOverviewCompNew claimsFailObj = new CG_CL_ClaimsFailuresOverviewCompNew();
            
            claimsFailObj.selectedSysCode='POL';
            claimsFailObj.mil_measure='Test';
            claimsFailObj.Wid=testclaimsRec.Id;
            claimsFailObj.accCodeWS='Test';
            claimsFailObj.claimtype='test';
            claimsFailObj.FailureDtHidden='test';
            claimsFailObj.selectedCustFName = 'test';
            claimsFailObj.noPopup=true;
            claimsFailObj.showFailurePopup=true;
            claimsFailObj.warrStDtHidden='test';
            claimsfailobj.selectedCompCode='DSBDV5790';
            claimsfailobj.selectedFailMode='ST';
            Claimsfailobj.onChangeofAppCode();
            claimsFailObj.getAllFailuresData();
            claimsFailObj.retry();
            claimsFailObj.getGsqcustFailurenameslist();
            claimsFailObj.resetAllData();
            claimsFailObj.saveClaimFailOvervwData();
            CSS_Claims__c obj = new CSS_Claims__c();
            obj.CoverageResponse__c = 'TestingData';
            insert obj;
            CSS_Solution_Component__c compToUpdate = new CSS_Solution_Component__c();
            compToUpdate.CoveredLaborHrs__c = '99999';
            compToUpdate.CoveredMealsLodgingAmt__c = '1';
            compToUpdate.CoveredOCAmount__c = '1';
            compToUpdate.CoveredPartsQty__c = '1';
            compToUpdate.CoveredTowingMiles__c = '1';
            compToUpdate.AccountCode_Call_Status__c='Test';
            compToUpdate.CoveredTravelLabor__c = '1';
            compToUpdate.CoveredTravelMiles__c = '1';
            compToUpdate.CertificateNumber__c = '1';
            insert compToUpdate;
            claimsFailObj.compToUpdate = compToUpdate;
            string solid =string.valueOf(solComp.id);
            claimsFailobj.deleteCompId=solid;
            claimsFailobj.deleteSolRecordWOPSN();
            string solid1 =string.valueOf(solComp1.Id);
            //claimsFailobj.DeletePopupAC();
            claimsFailObj.accCodeSelected = '70';
            claimsFailObj.getfailurenames();
            claimsFailObj.getComponentCodes();
            claimsFailObj.accCodeSelected = 'Test 41';
            //claimsFailObj.selectedSysCode = '123';
            //claimsFailObj.selectedCompCode='234';
            claimsFailObj.selectedFailMode='789';
            claimsFailObj.selectedFaultCode='9-23';
            claimsFailObj.selectedFName = 'unlisted';
            claimsFailObj.failureMeasure = 'Hours';
            CSS_Solution_Component__c compToUpdate1 = new CSS_Solution_Component__c();
            compToUpdate1.CoveredLaborHrs__c = '99999';
            compToUpdate1.CoveredMealsLodgingAmt__c = '1';
            compToUpdate1.CoveredOCAmount__c = '1';
            compToUpdate1.CoveredPartsQty__c = '1';
            compToUpdate1.CoveredTowingMiles__c = '1';
            compToUpdate1.AccountCode_Call_Status__c='Test';
            compToUpdate1.CoveredTravelLabor__c = '1';
            compToUpdate1.CoveredTravelMiles__c = '1';
            compToUpdate1.CertificateNumber__c = '1';
            insert compToUpdate1;
            claimsFailObj.compToUpdate = compToUpdate1;
            claimsFailobj.checkPartCoverage();
            claimsFailobj.claimTypeSelected = 'ASD';
            claimsFailObj.popUpSave();
            claimsFailObj.changeCustFailures();
            claimsFailObj.checkCompCode();
            claimsFailObj.checkFailMode();
            claimsFailObj.checkFaultCode();
            claimsFailObj.changeSystemcode();
            claimsFailObj.getSRTFailurenamesOnLoad();
            claimsFailObj.isDealer = true;
        }
    }
    
    public static testmethod void changefailmodemethod()
    {
        test.startTest();
        CG_CL_ClaimsFailuresOverviewCompNew obj = new CG_CL_ClaimsFailuresOverviewCompNew();
        obj.changefailmode();
        test.stopTest();
    }
    
    public static testmethod void changeSystemcodemethod()
    {
        test.startTest();
        CG_CL_ClaimsFailuresOverviewCompNew obj = new CG_CL_ClaimsFailuresOverviewCompNew();
        obj.selectedFName = 'unlisted';
        // obj.changeSystemcode();
        test.stopTest();
    }
    
    public static testmethod void changeComponentCodemethod()
    {
        test.startTest();
        CG_CL_ClaimsFailuresOverviewCompNew obj = new CG_CL_ClaimsFailuresOverviewCompNew();
        obj.selectedFName = 'unlisted';
        obj.changeComponentCode();
        test.stopTest();
    }
    
    public static testmethod void TestOnAddclick()
    {
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.ApplicationCode__c = 'test';
        insert JO;
        
        CSS_Claims__c claimsRec = new CSS_Claims__c();
        claimsRec.Customer_Name__c='TestCustomer';
        claimsRec.CSS_Job__c = JO.id;
        insert claimsRec;
        
        css_psn__c psnRec = new Css_psn__C();
        psnRec.Name='73806085';
        psnRec.PSN__c='73806085';
        psnRec.CSS_Claims__c=claimsRec.id;
        psnRec.Primary__c=true;
        insert psnRec;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = claimsRec.id;
        AddsolComp.Customer_Take_Possession__c = 'test';
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'test';
        AddsolComp.AccountCodeType__c = 'test';
        //AddsolComp.AccountCodeEdit__c = null;
        AddsolComp.Parts_Warranty__c= 'New Parts Warranty';
        Addsolcomp.Failure_Measure__c = 'test';
        Addsolcomp.Failure_Date__c = date.today();
        insert Addsolcomp;
        
        test.startTest();
        ApexPages.CurrentPage().getParameters().put('Id',claimsRec.id);
        CG_CL_ClaimsFailuresOverviewCompNew FailureOverview = new CG_CL_ClaimsFailuresOverviewCompNew();
        FailureOverview.compont = AddsolComp;
        FailureOverview.onAddClick();
        FailureOverview.checkPartCoverage();
        test.stopTest();
        
    }
    
    public static testmethod void TestOnpopUpSave1()
    {
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        insert JO;
        
        CSS_Claims__c claimsRec = new CSS_Claims__c();
        claimsRec.Customer_Name__c='TestCustomer';
        claimsRec.CSS_Job__c = JO.id;
        claimsRec.Location_Code__c = '03520-04892';
        insert claimsRec;
        
        css_psn__c psnRec = new Css_psn__C();
        psnRec.Name='73806085';
        psnRec.PSN__c='73806085';
        psnRec.ApplicationCode__c = '130';
        psnRec.CSS_Claims__c=claimsRec.id;
        psnRec.Primary__c=true;
        psnRec.Failure_Date__c = date.today();
        psnRec.Mileage__c = 5;
        psnRec.Mileage_Measure__c = 'Miles';
        psnRec.Product_Hours__c = 10;
        psnREc.Warranty_Start_Date__c = date.today() - 365;
        insert psnRec;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = claimsRec.id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'test';
        AddsolComp.AccountCodeType__c = 'test';
        AddsolComp.AccountCodeEdit__c = 'SERVICE TOOL WARRANTY 52';
        Addsolcomp.Failure_Measure__c = 'test';
        Addsolcomp.Failure_Date__c = date.today();
        insert Addsolcomp;
        
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        AddsolComp1.CSS_Claims__c = claimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.type__c='CAM';
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = 'test';
        AddsolComp1.AccountCodeType__c = 'test';
        AddsolComp1.AccountCodeEdit__c = 'SERVICE TOOL WARRANTY 52';
        Addsolcomp1.Failure_Measure__c = 'test';
        Addsolcomp1.Failure_Date__c = date.today();
        Addsolcomp1.Failure_Point__c = 1.00;
        Addsolcomp1.Part_Warranty_Start_Date__c = date.today()-365;
        insert Addsolcomp1;
        
        Map<String,String> failureNameWithFailureIdMap = new  Map<String,String>();
        failureNameWithFailureIdMap.put('Accessory Plate Cover Gasket','F0051000');
         
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        test.startTest();
        ApexPages.CurrentPage().getParameters().put('Id',claimsRec.id);
        CG_CL_ClaimsFailuresOverviewCompNew FailureOverview = new CG_CL_ClaimsFailuresOverviewCompNew();
        FailureOverview.selectedCompId = Addsolcomp.id;  
        FailureOverView.selectedFailureID = AddsolComp.Component_Id__c;
        FailureOVerview.failureNameWithFailureIdMap = failureNameWithFailureIdMap;
        FailureOVerview.selectedSysCode = 'TH';
        FailureOVerview.selectedCompCode = 'AC';
        FailureOverview.selectedFailMode = 'BT';
        FailureOverview.selectedFName = 'Turbocharger Actuator';
        FailureOverview.selectedFaultCode = '2636-VGT Actuator Driver Circuit - Abnormal Update Rate';
        FailureOverview.coverageType='TOI';
        FailureOverview.coverageFound='false';
        FailureOverview.accCodeReturned = 'Test';
        FailureOverview.compont = Addsolcomp1;
        FailureOverview.popUpSave();
        test.stopTest();
        
    }
    
     public static testmethod void TestOnpopUpSave1a()
    {
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        insert JO;
        
        CSS_Claims__c claimsRec = new CSS_Claims__c();
        claimsRec.Customer_Name__c='TestCustomer';
        claimsRec.CSS_Job__c = JO.id;
        claimsRec.account__c = acc.id;
        claimsRec.Location_Code__c = '03520-04892';
        insert claimsRec;
        
        css_psn__c psnRec = new Css_psn__C();
        psnRec.Name='73806085';
        psnRec.PSN__c='73806085';
        psnRec.ApplicationCode__c = '130';
        psnRec.CSS_Claims__c=claimsRec.id;
        psnRec.Primary__c=true;
        psnRec.Failure_Date__c = date.today();
        psnRec.Mileage__c = 5;
        psnRec.Mileage_Measure__c = 'Miles';
        psnRec.Product_Hours__c = 10;
        psnREc.Warranty_Start_Date__c = date.today() - 365;
        insert psnRec;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.CSS_Claims__c = claimsRec.id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'test';
        AddsolComp.AccountCodeType__c = 'test';
        AddsolComp.AccountCodeEdit__c = 'SERVICE TOOL WARRANTY 52';
        Addsolcomp.Failure_Measure__c = 'test';
        Addsolcomp.Failure_Date__c = date.today();
        insert Addsolcomp;
        
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        AddsolComp1.CSS_Claims__c = claimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.type__c='CAM';
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = 'test';
        AddsolComp1.AccountCodeType__c = 'test';
        AddsolComp1.AccountCodeEdit__c = 'SERVICE TOOL WARRANTY 52';
        Addsolcomp1.Failure_Measure__c = 'test';
        Addsolcomp1.Failure_Date__c = date.today();
        Addsolcomp1.Failure_Point__c = 1.00;
        Addsolcomp1.Part_Warranty_Start_Date__c = date.today()-365;
        insert Addsolcomp1;
        
        Map<String,String> failureNameWithFailureIdMap = new  Map<String,String>();
        failureNameWithFailureIdMap.put('Accessory Plate Cover Gasket','F0051000');
         
        CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
        cid.name = 'CSS_SBL_WarrantyDetailCoverage';
        cid.ApplicationName__c = 'CSS_SBL_WarrantyDetailCoverage';
        cid.End_Point__c = 'https://services-stg.cummins.com/csswarranty/accodecoverage';
        insert cid;
        
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        
        test.startTest();
        ApexPages.CurrentPage().getParameters().put('Id',claimsRec.id);
        CG_CL_ClaimsFailuresOverviewCompNew FailureOverview = new CG_CL_ClaimsFailuresOverviewCompNew();
        FailureOverview.selectedCompId = Addsolcomp.id;  
        FailureOverView.selectedFailureID = AddsolComp.Component_Id__c;
        FailureOVerview.failureNameWithFailureIdMap = failureNameWithFailureIdMap;
        FailureOVerview.selectedSysCode = 'TH';
        FailureOVerview.selectedCompCode = 'AC';
        FailureOverview.selectedFailMode = 'BT';
        FailureOverview.selectedFName = 'Turbocharger Actuator';
        FailureOverview.selectedFaultCode = '2636-VGT Actuator Driver Circuit - Abnormal Update Rate';
        FailureOverview.coverageType='TOI';
        FailureOverview.coverageFound='false';
        FailureOverview.accCodeReturned = Addsolcomp.AccountCodeEdit__c;
        FailureOVerview.chkClickonPartsCoverage = false;
        FailureOVerview.blankField= false;
        FailureOVerview.radioSelect= false;
        FailureOverview.compont = Addsolcomp;
        FailureOverview.popUpSave();
        test.stopTest();
        
    }
    
    public static testmethod void TestOnpopUpSave2()
    {
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        insert JO;
        
        CSS_Claims__c claimsRec = new CSS_Claims__c();
        claimsRec.Customer_Name__c='TestCustomer';
        claimsRec.CSS_Job__c = JO.id;
        insert claimsRec;
        
        css_psn__c psnRec = new Css_psn__C();
        psnRec.Name='73806085';
        psnRec.PSN__c='73806085';
        psnRec.ApplicationCode__c = '130';
        psnRec.CSS_Claims__c=claimsRec.id;
        psnRec.Primary__c=true;
        insert psnRec;
        
        test.startTest();
        ApexPages.CurrentPage().getParameters().put('Id',claimsRec.id);
        CG_CL_ClaimsFailuresOverviewCompNew FailureOverview = new CG_CL_ClaimsFailuresOverviewCompNew();
        FailureOverview.selectedFailModeValue = null;
        // FailureOverview.selectedSysCodeValue = null;
        FailureOverview.selectedFName = 'unlisted';
        FailureOverview.popUpSave();
        test.stopTest();
        
    }
    
    public static testmethod void TestOnpopUpSave3()
    {
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        insert JO;
        
        CSS_Claims__c claimsRec = new CSS_Claims__c();
        claimsRec.Customer_Name__c='TestCustomer';
        claimsRec.CSS_Job__c = JO.id;
        claimsRec.ReconEngineFlag__c ='N';
        claimsRec.CoverageResponse__c='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"5/26/2016","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"5/26/2019","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2019","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2017","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"}]}}}}';
        insert claimsRec;
        list<css_psn__c> psnReclist = new list<Css_psn__C>();
        css_psn__c psnRec = new Css_psn__C();
        psnRec.Name='73806085';
        psnRec.PSN__c='73806085';
        psnRec.CSS_Claims__c=claimsRec.id;
        psnRec.ApplicationCode__c='130';
        psnRec.Primary__c=true;
        psnReclist.add(psnRec);
        css_psn__c psnRec1 = new Css_psn__C();
        psnRec1.Name='73806085';
        psnRec1.PSN__c='73806085';
        psnRec1.CSS_Claims__c=claimsRec.id;
        psnRec1.ApplicationCode__c='210';
        psnRec1.Primary__c=true;
        psnReclist.add(psnRec1);
        insert psnReclist;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        AddsolComp1.name ='unlisted';
        //AddsolComp1.SysCodeAndCompCode__c='test123';
        AddsolComp1.Component_Code__c='test';
        AddsolComp1.System_Code__c='test';
        AddsolComp1.Failure_Mode__c='test';
        AddsolComp1.Customer_Take_Possession__c='No';
        AddsolComp1.CSS_Claims__c = claimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.type__c='CAM';
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = 'test';
        AddsolComp1.AccountCodeType__c = 'test';
        AddsolComp1.AccountCodeEdit__c = 'test';
        AddsolComp1.Parts_Warranty__c= 'New Parts Warranty';
        Addsolcomp1.Failure_Measure__c = 'test';
        Addsolcomp1.Failure_Date__c = date.today();
        Addsolcomp1.Failure_Point__c = 5;
        Addsolcomp1.AccountCodeEdit__c='New parts Warranty 65';
        Addsolcomp1.Part_Warranty_Start_Date__c = date.today()-365;
        insert Addsolcomp1;
        CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
        je1.Attribute1__c = 'te';
        je1.Attribute2__c='z';
        je1.Attribute3__c='Transfer Switch failed to open/disconnect - Root Cause Not Known';
        je1.Attribute4__c='te';
        je1.key__c = 'FailCodes';
        
        insert je1;
        test.startTest();
        ApexPages.CurrentPage().getParameters().put('Id',claimsRec.id);
        CG_CL_ClaimsFailuresOverviewCompNew FailureOverview = new CG_CL_ClaimsFailuresOverviewCompNew();
        FailureOverview.selectedFailModeValue = null;
        
        FailureOverview.selectedFName = 'unlisted';
        FailureOverview.selectedFNameValue = 'unsted';
        FailureOverview.selectedCustFName ='';
        FailureOverview.selectedSysCode ='te'; 
        FailureOverview.selectedCompCode ='te'; 
        FailureOverview.selectedFailMode ='test'; 
        FailureOverview.accCodeSelected ='test62'; 
        FailureOverview.selectedFaultCode ='te-st';
        FailureOverview.accCodeReturned ='test62';
        FailureOverview.coverageType ='POL';
        FailureOverview.coverageFound ='false';
        FailureOverview.popUpSave();
        FailureOverview.retry();
        // FailureOverview.acc
        FailureOverview.isDealer =true;  	
        FailureOverview.checkCoverage();
        
        
        test.stopTest();
        
    }
    
    public static testmethod void TestOnpopUpSave4()
    {
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.ApplicationCode__c = '130';
        insert JO;
        
        CSS_Claims__c claimsRec = new CSS_Claims__c();
        claimsRec.Customer_Name__c='TestCustomer';
        claimsRec.CSS_Job__c = JO.id;
        claimsRec.ReconEngineFlag__c ='Y';
        claimsRec.CoverageResponse__c='{"Header":{"Status":"Success","ReturnCodeDescription":""},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"Status":"Expired","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","WarrantyEndDate":"5/26/2016","CoverageType":"NEW-New Engine Warranty","ProcedureNumber":"111-503-065","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"6250","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"},{"CoverageHours":"6250","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"250000"}]}},{"Status":"Active","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/pubsys2/xml/en/procedures/111/111-503-057.html","WarrantyEndDate":"5/26/2019","CoverageType":"EMS-Emissions Warranty","ProcedureNumber":"","ListOfCoverageComponentList":{"CoverageComponentList":[{"CoverageHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"},{"CoverageHours":"3000","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","MegawattHours":"0","CoverageDefenitionType":"BASE","CoverageMinMonths":"0","CoverageMiles":"100000"}]}}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"Status":"Active","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"60","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"CRT","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2019","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"500000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"},{"Status":"Expired","WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","Months":"36","ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"CAPCoverageID":"DC1","ProgramID":"DC4","BeginMiles":"0","EndDate":"05/27/2017","StartDate":"05/27/2014","BeginHours":"0","EndMiles":"300000","CertificateNumber":"DC41000412","EndHours":"0","ProcedureNumber":"111-505-129"}]}}}}';
        insert claimsRec;
        list<css_psn__c> psnReclist = new list<Css_psn__C>();
        css_psn__c psnRec = new Css_psn__C();
        psnRec.Name='73806085';
        psnRec.PSN__c='10000000';
        psnRec.CSS_Claims__c=claimsRec.id;
        psnRec.ApplicationCode__c='130';
        psnRec.Primary__c=true;
        psnReclist.add(psnRec);
        css_psn__c psnRec1 = new Css_psn__C();
        psnRec1.Name='73806085';
        psnRec1.PSN__c='73806085';
        psnRec1.CSS_Claims__c=claimsRec.id;
        psnRec1.ApplicationCode__c='210';
        psnRec1.Primary__c=true;
        psnReclist.add(psnRec1);
        insert psnReclist;
        CSS_Solution_Component__c AddsolComp1 = new CSS_Solution_Component__c();
        AddsolComp1.Component_Id__c ='F0051000';
        AddsolComp1.name ='unlisted';
        //AddsolComp1.SysCodeAndCompCode__c='test123';
        AddsolComp1.Component_Code__c='test';
        AddsolComp1.System_Code__c='test';
        AddsolComp1.Failure_Mode__c='test';
        AddsolComp1.Customer_Take_Possession__c='No';
        AddsolComp1.CSS_Claims__c = claimsRec.id;
        AddsolComp1.Action__c = 'Repair';
        AddsolComp1.Quantity__c = 4;
        AddsolComp1.type__c='CAM';
        AddsolComp1.Selected_Component__c = True;
        AddsolComp1.AccountCode__c = 'test';
        AddsolComp1.AccountCodeType__c = 'test';
        AddsolComp1.AccountCodeEdit__c = 'test';
        AddsolComp1.Parts_Warranty__c= 'New Parts Warranty';
        Addsolcomp1.Failure_Measure__c = 'test';
        Addsolcomp1.Failure_Date__c = date.today();
        Addsolcomp1.Failure_Point__c = 5;
        Addsolcomp1.AccountCodeEdit__c='New parts Warranty 65';
        Addsolcomp1.Part_Warranty_Start_Date__c = date.today()-365;
        insert Addsolcomp1;
        CSS_JobEventTemporary__c je1 = CSS_TestData.createJobEventTempObj(false);
        je1.Attribute1__c = 'te';
        je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
        je1.Attribute2__c='z';
        je1.Attribute3__c='Transfer Switch failed to open/disconnect - Root Cause Not Known';
        je1.Attribute4__c='te';
        je1.key__c = 'FailCodes';
        //je1.Reason__c = '[{"PAYCODEDESCRIPTION":"International Dealer Over 120","PAYCODE":"C"},{"PAYCODEDESCRIPTION":"Dealer Net Plus Mkup","PAYCODE":"D"},{"PAYCODEDESCRIPTION":"Dealer Net No Markup","PAYCODE":"E"},{"PAYCODEDESCRIPTION":"Fleet Net No Markup","PAYCODE":"F"},{"PAYCODEDESCRIPTION":"Dealer Plus 10% Markup","PAYCODE":"G"},{"PAYCODEDESCRIPTION":"INTRNATL WARRANTY","PAYCODE":"I"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"J"},{"PAYCODEDESCRIPTION":"International Dealer Over 180","PAYCODE":"L"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"P"},{"PAYCODEDESCRIPTION":"Service Associate Plus Markup","PAYCODE":"Q"},{"PAYCODEDESCRIPTION":"International Dealer Net","PAYCODE":"R"},{"PAYCODEDESCRIPTION":"Intrnatl Dist Net No Mark Up","PAYCODE":"S"},{"PAYCODEDESCRIPTION":"Dist. Inrange","PAYCODE":"T"},{"PAYCODEDESCRIPTION":"Transit Authorities","PAYCODE":"U"},{"PAYCODEDESCRIPTION":"Distributor Net No Markup","PAYCODE":"W"},{"PAYCODEDESCRIPTION":"Distributor Net Plus Markup","PAYCODE":"X"}]';
        insert je1;
        test.startTest();
        ApexPages.CurrentPage().getParameters().put('Id',claimsRec.id);
        CG_CL_ClaimsFailuresOverviewCompNew FailureOverview = new CG_CL_ClaimsFailuresOverviewCompNew();
        FailureOverview.selectedFailModeValue = null;
        //  FailureOverview.selectedSysCodeValue = null;
        FailureOverview.selectedFName = 'unlisted';
        FailureOverview.selectedFNameValue = 'unsted';
        FailureOverview.selectedCustFName ='';
        FailureOverview.selectedSysCode ='te'; 
        FailureOverview.selectedCompCode ='te'; 
        FailureOverview.selectedFailMode ='test'; 
        FailureOverview.accCodeSelected ='test62'; 
        FailureOverview.selectedFaultCode ='te-st';
        FailureOverview.accCodeReturned ='test62';
        FailureOverview.coverageType ='POL';
        FailureOverview.coverageFound ='false';
        FailureOverview.popUpSave();
        FailureOverview.retry();
        // FailureOverview.acc
        FailureOverview.isDealer =true;  	
        FailureOverview.checkCoverage();
        
        
        test.stopTest();
        
    }
    
    
    public static testmethod void TestOnDeletePopupAC()
    {
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO.ApplicationCode__c = 'test';
        insert JO;
        
        CSS_Claims__c claimsRec = new CSS_Claims__c();
        claimsRec.Customer_Name__c='TestCustomer';
        claimsRec.CSS_Job__c = JO.id;
        claimsRec.Multi_PSN_Claim__c = true;
        insert claimsRec;
        
        css_psn__c psnRec = new Css_psn__C();
        psnRec.Name='73806085';
        psnRec.PSN__c='73806085';
        psnRec.CSS_Claims__c=claimsRec.id;
        psnRec.Primary__c=true;
        psnRec.Before_In_Service__c = true;
        insert psnRec;
        
        test.startTest();
        ApexPages.CurrentPage().getParameters().put('Id',claimsRec.id);
        CG_CL_ClaimsFailuresOverviewCompNew FailureOverview = new CG_CL_ClaimsFailuresOverviewCompNew();
        FailureOverview.accCodeSelected = 'QWEP';
        FailureOverview.oldAccountCode = 'THAC';
        FailureOverview.DeletePopupAC();
        test.stopTest();
        
    }
    
    public static testmethod void CallFaultcodeOnFocus()
    {
        
        list<CSS_JobEventTemporary__c> jobevtlist = new list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Key__c = 'CDSFaultCodes';
        jobevnt.Attribute1__c = 'POL';
        jobevnt.Attribute2__c = 'New Engine Warranty';
        jobevnt.Attribute3__c = '67';
        jobevtlist.add(jobevnt);
        
        CSS_JobEventTemporary__c jobevnt1 = new CSS_JobEventTemporary__c();
        jobevnt1.Key__c = 'FailModes';
        jobevnt1.Active__c = true;
        jobevnt1.Attribute1__c = 'POL';
        jobevnt1.Attribute2__c = 'New Engine Warranty';
        jobevnt1.Attribute3__c = '67';
        jobevtlist.add(jobevnt1);
        
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Key__c = 'FailCodes';
        jobevnt2.Active__c = true;
        jobevnt2.Attribute1__c = 'WE';
        jobevnt2.Attribute2__c = 'New Engine Warranty';
        jobevnt2.Attribute3__c = '67';
        jobevnt2.Attribute5__c = 't';
        jobevtlist.add(jobevnt2);
        insert jobevtlist;
        
        Map<string, string> systemCodeMap =  new Map<string, string>();
        systemCodeMap.put('TH','AC');
        
        
        test.startTest();
        CG_CL_ClaimsFailuresOverviewCompNew FC = new CG_CL_ClaimsFailuresOverviewCompNew();
        FC.systemCodeMap = systemCodeMap;
        FC.callFaultCodesOnFocus();
        FC.selectedFailMode = 'POL-67';
        FC.selectedSysCode = 'WEA';
        FC.SelectedFaultCode = 'POL-67';
        FC.checkFailMode();
        FC.changeSystemcode();
        FC.checkFaultCode();
        test.stopTest();
    }
    
    public static testmethod void CallFaultcodeOnBlur()
    {
        
        list<CSS_JobEventTemporary__c> jobevtlist = new list<CSS_JobEventTemporary__c>();
        CSS_JobEventTemporary__c jobevnt = new CSS_JobEventTemporary__c();
        jobevnt.Key__c = 'CDSFaultCodes';
        jobevnt.Attribute1__c = 'POL';
        jobevnt.Attribute2__c = 'New Engine Warranty';
        jobevnt.Attribute3__c = '67';
        jobevtlist.add(jobevnt);
        
        CSS_JobEventTemporary__c jobevnt1 = new CSS_JobEventTemporary__c();
        jobevnt1.Key__c = 'FailModes';
        jobevnt1.Active__c = true;
        jobevnt1.Attribute1__c = 'POL';
        jobevnt1.Attribute2__c = 'New Engine Warranty';
        jobevnt1.Attribute3__c = '67';
        jobevtlist.add(jobevnt1);
        
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Key__c = 'FailCodes';
        jobevnt2.Active__c = true;
        jobevnt2.Attribute1__c = 'WE';
        jobevnt2.Attribute2__c = 'New Engine Warranty';
        jobevnt2.Attribute3__c = '67';
        jobevnt2.Attribute5__c = 't';
        jobevtlist.add(jobevnt2);
        insert jobevtlist;
        
        Map<string, string> systemCodeMap =  new Map<string, string>();
        test.startTest();
        CG_CL_ClaimsFailuresOverviewCompNew FC = new CG_CL_ClaimsFailuresOverviewCompNew();
        FC.systemCodeMap = systemCodeMap;
        
        FC.selectedCustFName = 'User'; 
        FC.selectedFailMode = 'TestUser';
        
        FC.SelectedFaultCode = 'TestUser';
        FC.selectedCompCode = 'null';
        FC.checkFailMode();
        FC.checkFaultCode();
        FC.checkCompCode();
        
        test.stopTest();
    }
    
    public static testmethod void checkcoverage1()
    {
        
        
        CSS_Job_Order__c job= new CSS_Job_Order__c();
        job.Status__c = 'Intake';
        insert job;
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.CSS_Job__c = job.id;
        claim.Customer_Name__c = 'Oliver Trucking';
        claim.Shop_Work_Order__c='1234';
        insert claim;
        
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.css_claims__C = claim.id;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        insert testpsnNewRec;
        
        
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Name = 'solcomp';
        solcomp.CSS_Claims__c = claim.id;
        solcomp.System_Code__c='TH';
        solcomp.Component_Code__c='AC';
        solcomp.Failure_Mode__c='BT';
        solcomp.AccountCodeEdit__c = 'SERVICE TOOL WARRANTY 521';
        solcomp.Type__c = null;
        solcomp.Selected_Component__c = true;
        solcomp.Customer_Take_Possession__c = 'yes';
        solcomp.Part_Warranty_Start_Date__c = system.today() - 30;
        solcomp.Failure_Date__c = system.today();
        solcomp.Failure_Point__c = 20;
        solcomp.Failure_Measure__c = 'Miles';
        insert solcomp;
        
        
        test.startTest();
        CG_CL_ClaimsFailuresOverviewCompNew FC = new CG_CL_ClaimsFailuresOverviewCompNew();
        FC.Workjob= job;
        FC.compToUpdate = solcomp;
        system.debug('test11');
        FC.selectedSysCode = '';
        FC.selectedCompCode ='';
        FC.selectedFailMode = '';
        FC.selectedFaultCode ='';
        FC.componentId ='test';
        FC.OneaccCodeBool = 'true';
        FC.checkCoverage();
        FC.checkPartCoverage();
        test.stopTest();
    }
    
    public static testmethod void checkcoverage2()
    {
        
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02466';
        acc.IAM_Service_Provider_Code__c='19134';
        acc.Type='Dealer Account';
        acc.CMI_Account_Status__c = 'Active';
        insert acc;
        
        
        CSS_Job_Order__c job= new CSS_Job_Order__c();
        job.Status__c = 'Intake';
        insert job;
        
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.CSS_Job__c = job.id;
        claim.Customer_Name__c = 'Oliver Trucking';
        claim.Shop_Work_Order__c='1234';
        insert claim;
        
              
        /*
        CSS_Claims__c claim = new CSS_Claims__c();
        claim.CSS_Job__c = job.id;
        claim.Account__c = acc.id;
        claim.Customer_Name__c = 'Oliver Trucking';
        claim.Location_Code__c = '03742-03750';
        claim.Shop_Work_Order__c='1234';
        //claim.OwnerId = UserInfo.getUserId();
        insert claim;
        */
        
        CSS_PSN__c testpsnNewRec = new CSS_PSN__c();
        testpsnNewRec.css_claims__C = claim.id;
        testpsnNewRec.psn__c = '79464646';
        testpsnNewRec.Primary__C = true;
        testpsnNewRec.Failure_Date__c = system.today();
        testpsnNewREc.Product_Hours__c = 10;
        testpsnNewREc.ApplicationCode__c = '100';
        testpsnNewREc.Warranty_Start_Date__c = (system.today())-30;
        insert testpsnNewRec;
        
        
        CSS_Solution_Component__c solcomp = new CSS_Solution_Component__c();
        solcomp.Name = 'solcomp';
        solcomp.CSS_Claims__c = claim.id;
        solcomp.System_Code__c='TH';
        solcomp.Component_Code__c='AC';
        solcomp.Failure_Mode__c='BT';
        solcomp.AccountCodeEdit__c = 'SERVICE TOOL WARRANTY 521';
        solcomp.Type__c = null;
        solcomp.Selected_Component__c = true;
        solcomp.Customer_Take_Possession__c = 'yes';
        solcomp.Part_Warranty_Start_Date__c = system.today() - 30;
        solcomp.Failure_Date__c = system.today()+1;
        solcomp.Failure_Point__c = 20;
        solcomp.Failure_Measure__c = null;
        insert solcomp;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'OAGOAUTH';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'Test';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Reason__c = 'aka';
        jobevnt2.Key__c = 'FailCodes';
        jobevnt2.Attribute1__c = 'WE';
        jobevnt2.Attribute4__c = 'New Engine Warranty';
        jobevnt2.Attribute5__c = 't';
        jobevnt2.Attribute3__c = '67';
        jobevnt2.Attribute7__c = 'Unlisted';
        insert jobevnt2;
        
        ApexPages.CurrentPage().getParameters().put('Id',claim.id);
        
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class , new CSS_WS_SBL_GetWarrantyDetailCovrg_Test());
        CG_CL_ClaimsFailuresOverviewCompNew FC = new CG_CL_ClaimsFailuresOverviewCompNew();
        FC.compToUpdate = solcomp;
        system.debug('test12');
        FC.selectedSysCode = 'THE';
        FC.selectedCompCode ='ACE';
        FC.selectedFailMode = 'BTE';
        FC.selectedFaultCode ='2131-';
        FC.componentId ='test';
        FC.OneaccCodeBool = 'true';
        FC.checkCoverage();
        FC.checkPartCoverage();
        FC.accCodeSelected = '70';
        test.stopTest();
    }
    
    public static testmethod void CallFaultcodeOnFocus1()
    {
        
        Map<string, string> componentCodeMap =  new Map<string, string>();
        componentCodeMap.put('TH','AC');
        
        test.startTest();
        CG_CL_ClaimsFailuresOverviewCompNew FC = new CG_CL_ClaimsFailuresOverviewCompNew();
        FC.componentCodeMap = componentCodeMap;
        FC.selectedCustFName = null;
        FC.selectedCompCode = 'TH';
        FC.checkCompCode();
        
        test.stopTest();
        
        
    }
    
    public static testmethod void changeCustFailures1()
    {
        
        
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Key__c = 'FailCodes';
        jobevnt2.Attribute1__c = 'WE';
        jobevnt2.Attribute4__c = 'New Engine Warranty';
        jobevnt2.Attribute5__c = 't';
        jobevnt2.Attribute3__c = '67';
        jobevnt2.Attribute7__c = 'Unlisted';
        insert jobevnt2;
        
        map<string,string> custFailureNameList = new map<string,string>();
        custFailureNameList.put('Unlisted','Unlisted');
        //custFailureNameList.put(test123,'Unlisted');
        test.startTest();
        CG_CL_ClaimsFailuresOverviewCompNew FC = new CG_CL_ClaimsFailuresOverviewCompNew();
        FC.selectedCustFName = 'Unlisted';
        FC.custFailureNameList = custFailureNameList;
        FC.changeCustFailures();
        FC.selectedCustFName = null;
        custFailureNameList.put('test123','test123');
        FC.custFailureNameList = custFailureNameList;
        FC.changeCustFailures();
        test.stopTest();
        
    }
    
     public static testmethod void changeCustFailures2()
    {
        
        
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Key__c = 'FailCodes';
        jobevnt2.Attribute1__c = 'WE';
        jobevnt2.Attribute4__c = 'New Engine Warranty';
        jobevnt2.Attribute5__c = 't';
        jobevnt2.Attribute3__c = '67';
        jobevnt2.Attribute7__c = 'Unlisted';
        insert jobevnt2;
        
        map<string,string> custFailureNameList = new map<string,string>();
        //custFailureNameList.put('Unlisted','Unlisted');
        //custFailureNameList.put(test123,'Unlisted');
        test.startTest();
        CG_CL_ClaimsFailuresOverviewCompNew FC = new CG_CL_ClaimsFailuresOverviewCompNew();
        FC.selectedCustFName = 'Unlisted';
        FC.custFailureNameList = custFailureNameList;
        FC.changeCustFailures();
        FC.selectedCustFName = 'akanksha';
        custFailureNameList.put('test123','test123');
        FC.custFailureNameList = custFailureNameList;
        FC.changeCustFailures();
        FC.urRole = true;
        test.stopTest();
        
    }
    
    public static testmethod void getPayCodesonAccCodeChange1()
    {
        
        
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Key__c = 'AccountCodes';
        jobevnt2.Attribute3__c = '62';
        jobevnt2.Reason__c = 'Reason';
        insert jobevnt2;
        
        test.startTest();
        CG_CL_ClaimsFailuresOverviewCompNew FC = new CG_CL_ClaimsFailuresOverviewCompNew();
        Fc.accCodeSelected = 'NEW PARTS WARRANTY 62';
        FC.getPayCodesonAccCodeChange();
        test.stopTest();
        
    }
    
    public static testmethod void getPayCodesonAccCodeChange2()
    {
        
        CSS_JobEventTemporary__c jobevnt2 = new CSS_JobEventTemporary__c();
        jobevnt2.Key__c = 'AccountCodes';
        jobevnt2.Attribute3__c = '35';
        jobevnt2.Reason__c = 'Reason';
        insert jobevnt2;
        
        
        test.startTest();
        CG_CL_ClaimsFailuresOverviewCompNew FC = new CG_CL_ClaimsFailuresOverviewCompNew();
        Fc.accCodeSelected = 'NEW PARTS WARRANTY 35';
        FC.getPayCodesonAccCodeChange();
        test.stopTest();
        
    }
    
   
   
    
   
    
}