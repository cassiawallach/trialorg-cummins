@istest
public class CG_CL_ClaimsViewPaymentDetails_Test {
    static testmethod void test(){
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        list<css_claims__c> claimslist = new list<css_claims__c>();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='TestCustomer';
        claims.Customer_Code__c = '1234';
        claims.Contact_Last_Name__c = 'T';
        claims.Address__c = 'T';
        claims.Customer_Contact_Phone__c = null;
        claims.Email_Address__c = 'RdB@nomail.com';
        claims.Status__c = 'Draft';
        claims.Account__c=acc.Id;
        insert claims;
        
        
        
        claimslist.add(claims);
        
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        insert psn1;
        
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Name='Testing';
        
        insert claimsum;
        
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        po.Service_partnumber__c='123';
        insert po;
        
        
        CSS_SRT__c srt = new CSS_SRT__c();
        srt.Account_Code__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
        srt.FailCode__c='THAC';
        srt.Type__c='99time';
        srt.CSS_Claims__c=claims.Id;
        srt.Extended_Hours__c = 20;
        //srt.Job_Order__c = JO.id;
        srt.isPerformed__c = true;
        srt.Account_Code_Description__c = 'wenchin';
        
        insert srt;
        
        
        
        
        apexpages.currentPage().getparameters().put('id',claimsum.Id);
        
        Note not1 = new note();
        not1.ParentId=claimsum.Id;
        not1.Title='TECHNICIANNOTES';
        not1.Body='SBL928734;;2010-03-19 16:18:59;;2010-03-19 16:18:59;;Parts have been removed;;test;;test1;;test2';
        insert not1;
        Test.setMock(HttpCalloutMock.class, new CSS_mockGetClaimDetailsResponse_Teest());
        test.startTest();
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        obj.claimsRecMPSN=claimslist;
        obj.fetchClaimSubmissionRecords();
        obj.Callgetpaidclaimdetails();
        obj.LocationCode='test';
        obj.WarrantyStartDate='test'; 
        obj.FailureDate='test';
        obj.SiebelMake = 'SiebelMake';
        obj.SiebelModel = 'SiebelModel';
        obj.VIN = 'VIN';
        obj.unitNumber = 'unitNumber';
        obj.Mileage = 'Mileage';
        obj.productHours = 'productHours';
        obj.failureMeasure = 'failureMeasure';
        obj.MileageValue  = 'Miles';
        obj.productHoursValue = 'Hours';
        obj.generatePDF();
        obj.getChooserender();
        // obj.AdjustedAmount();
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper inner1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper();
        inner1.AdjustedHours = 2.0;
        CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper inner2 = new CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper();
        inner2.Note='note';
        inner2.NoteType='noteType';
        
        Date daVa= System.Today()+30;
        inner2.CreatedDate=string.valueOf(daVa);
        inner1.AdjustmentReason='test';
        inner1.AccessCode= 'test';
        inner1.ClaimedQuantity='test';
        //   inner1.claimDetailSRTswrapper();
        obj.CallGetClaimDetails();
        test.stopTest();
        
    }
    
    
    
    static testmethod void test1(){
        
        
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='TestCustomer';
        claims.Customer_Code__c = '1234';
        claims.Contact_Last_Name__c = 'T';
        claims.Address__c = 'T';
        claims.Customer_Contact_Phone__c = null;
        claims.Email_Address__c = 'RdB@nomail.com';
        claims.Status__c = 'Draft';
        claims.Account__c=acc.Id;
        insert claims;
        
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        insert psn1;
        
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Name='Testing';        
        claimsum.Account_Code__c='CAMPAIGN 65';
        claimsum.Parts__c=12.88;
        insert claimsum;
        
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        po.Service_partnumber__c='408998500RX';
        po.ExpenseTotal__c=123;
        insert po;
        list<CSS_SRT__c> lstsrt = new list<CSS_SRT__c>();
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.Id;
        srt1.Job_Order__c=null;
        srt1.Account_Code__c='Testing';
        lstsrt.add(srt1);
        insert lstsrt;
        
        apexpages.currentPage().getparameters().put('id',claimsum.Id);
        CSS_Integration_Details__c cid = new CSS_Integration_Details__c();
        cid.ApplicationName__c = 'CG_SBL_Getpaidclaimdetails';
        cid.Name='CG_SBL_Getpaidclaimdetails';
        cid.End_Point__c='https://services-dev.cummins.com/csswarranty/getPaidClaimsDetails/';
        cid.IsActive__c = true;
        cid.Key__c='lPSg6wv735E70O4ZV1fd0snAHUrWlfERplf9u0TR8Wg';
        cid.Passcode__c='ETNhGSqffElTsCL26DLrEAtSi+Py79h6+/xK1Zm7SIQ';
        cid.Username__c='Cibp902/PZ1TbGx7UUqHn9R1FRrOJEElHxA8g8+V8jw';
        cid.Timeout__c=1;
        cid.Method_Type__c='post';
        cid.Logging__c='Testing';
        insert cid;
        
        Map<string, list<CSS_SRT__c>> SRTAccountCodeMap = new Map<string, list<CSS_SRT__c>>();
        SRTAccountCodeMap.put('AND',lstsrt);
        
        test.startTest();
        test.setMock(httpcalloutmock.class,new CSS_FN_Siebel_PaidClaimmock());
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        obj.cStatus='Draft';
        obj.SRTAccountCodeMap = SRTAccountCodeMap;
        
        obj.csId=claims.id;
        obj.fetchClaimSubmissionRecords();
        // obj.Callgetpaidclaimdetails();
        obj.LocationCode='test';
        obj.WarrantyStartDate='test'; 
        obj.FailureDate='test';
        obj.generatePDF();
        obj.getChooserender();
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper inner1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper();
        CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper inner2 = new CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper();
        inner2.Note='note';
        inner2.NoteType='noteType';
        // inner2.SiebelMake='test';
        Date d= System.Today();
        inner2.CreatedDate=string.valueOf(d);
        inner1.AdjustmentReason='test';
        inner1.AccessCode= 'test';
        inner1.ClaimedQuantity='test';
        // inner1.claimDetailSRTswrapper();
        test.stopTest();
        
    }
    
    static testmethod void test111(){
        
        
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='TestCustomer';
        claims.Customer_Code__c = '1234';
        claims.Contact_Last_Name__c = 'T';
        claims.Address__c = 'T';
        claims.Customer_Contact_Phone__c = null;
        claims.Email_Address__c = 'RdB@nomail.com';
        claims.Status__c = 'Draft';
        claims.Account__c=acc.Id;
        insert claims;
        
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        insert psn1;
        
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Name='Testing';
        
        insert claimsum;
        
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        po.Service_partnumber__c='123';
        insert po;
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.Id;
        srt1.Job_Order__c=null;
        srt1.Account_Code__c='Testing';
        insert srt1;
        
        apexpages.currentPage().getparameters().put('id',claimsum.Id);
        
        Note not1 = new note();
        not1.ParentId=claimsum.Id;
        not1.Title='TECHNICIANNOTES';
        not1.Body='SBL928734;;2010-03-19 16:18:59;;2010-03-19 16:18:59;;Parts have been removed;;test;;test1;;test2';
        insert not1;
        Test.setMock(HttpCalloutMock.class, new CSS_mockGetClaimDetailsResponse_Teest());
        test.startTest();
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        
        obj.fetchClaimSubmissionRecords();
        obj.Callgetpaidclaimdetails();
        obj.LocationCode='test';
        obj.WarrantyStartDate='test'; 
        obj.FailureDate='test';
        obj.generatePDF();
        obj.getChooserender();
        // obj.AdjustedAmount();
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper inner1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper();
        inner1.AdjustedHours = 2.0;
        CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper inner2 = new CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper();
        inner2.Note='note';
        inner2.NoteType='noteType';
        
        Date daVa= System.Today()+30;
        inner2.CreatedDate=string.valueOf(daVa);
        inner1.AdjustmentReason='test';
        inner1.AccessCode= 'test';
        inner1.ClaimedQuantity='test';
        //   inner1.claimDetailSRTswrapper();
        test.stopTest();
        
    }
    
    static testmethod void test112(){
        
        
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='TestCustomer';
        claims.Customer_Code__c = '1234';
        claims.Contact_Last_Name__c = 'T';
        claims.Address__c = 'T';
        claims.Customer_Contact_Phone__c = null;
        claims.Email_Address__c = 'RdB@nomail.com';
        claims.Status__c = 'Draft';
        claims.Account__c=acc.Id;
        insert claims; 
        
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        insert psn1;
        
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Name='Testing';
        claimsum.Account_Code__c='Testing';
        insert claimsum;
        
        
        
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        po.Service_partnumber__c='123';
        insert po;
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.Id;
        srt1.Job_Order__c=null;
        srt1.Account_Code__c='Testing';
        insert srt1;
        
        apexpages.currentPage().getparameters().put('id',claimsum.Id);
        
        Note not1 = new note();
        not1.ParentId=claimsum.Id;
        not1.Title='TECHNICIANNOTES';
        not1.Body='SBL928734;;2010-03-19 16:18:59;;2010-03-19 16:18:59;;Parts have been removed;;test;;test1;;test2';
        insert not1;
        
        //List<CSS_Integration_Details__c> cid1 = new List<CSS_Integration_Details__c>();
        CSS_Integration_Details__c cid = new CSS_Integration_Details__c();
        cid.ApplicationName__c = 'CG_SBL_Getpaidclaimdetails';
        cid.Name='CG_SBL_Getpaidclaimdetails';
        cid.End_Point__c='https://services-dev.cummins.com/csswarranty/getPaidClaimsDetails/';
        cid.IsActive__c = true;
        cid.Key__c='lPSg6wv735E70O4ZV1fd0snAHUrWlfERplf9u0TR8Wg';
        cid.Passcode__c='ETNhGSqffElTsCL26DLrEAtSi+Py79h6+/xK1Zm7SIQ';
        cid.Username__c='Cibp902/PZ1TbGx7UUqHn9R1FRrOJEElHxA8g8+V8jw';
        cid.Timeout__c=1;
        cid.Method_Type__c='post';
        cid.Logging__c='Testing';
        insert cid;
        
        
        test.startTest();
        test.setMock(httpcalloutmock.class,new CSS_FN_Siebel_PaidClaimmock());
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        
        obj.fetchClaimSubmissionRecords();
        //obj.Callgetpaidclaimdetails();
        obj.LocationCode='test';
        obj.WarrantyStartDate='test'; 
        obj.FailureDate='test';
        obj.generatePDF();
        obj.getChooserender();
        // obj.AdjustedAmount();
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper inner1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper();
        inner1.AdjustedHours = 2.0;
        CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper inner2 = new CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper();
        inner2.Note='note';
        inner2.NoteType='noteType';
        Date daVa= System.Today()+30;
        inner2.CreatedDate=string.valueOf(daVa);
        inner1.AdjustmentReason='test';
        inner1.AccessCode= 'test';
        inner1.ClaimedQuantity='test';
        test.stopTest();
        
    }
    
    static testmethod void test2(){
        test.startTest();
        
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Name__c='TestCustomer';
        claims.Customer_Code__c = '1234';
        claims.Contact_Last_Name__c = 'T';
        claims.Address__c = 'T';
        claims.Customer_Contact_Phone__c = null;
        claims.Email_Address__c = 'RdB@nomail.com';
        claims.Status__c = 'Draft';
        claims.Account__c=acc.Id;
        claims.Multi_PSN_Claim__c=true;
        claims.SiebelClaimNumber__c = '123';
        claims.EditCorrection__c='test';
        insert claims;
        system.debug('Test class claims'+claims);
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Before_In_Service__c = true;
        psn1.Mileage_Measure__c = 'MI';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        insert psn1;
        CSS_PSN__c  psn2 = new CSS_PSN__c();
        psn2.Name='56785364';
        psn2.Before_In_Service__c = true;
        psn2.Mileage_Measure__c = 'MI';
        psn2.Warranty_Start_Date__c=system.today();
        psn2.CSS_Claims__c=claims.Id;
        psn2.Primary__c=true;
        insert psn2;
        system.debug('Test class claims'+psn1);
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Credit_Date__c = system.today();
        claimsum.Name='Testing';
        insert claimsum;
        
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        po.ExpenseTotal__c=123;
        insert po;
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.Id;
        srt1.Job_Order__c=null;
        srt1.Account_Code__c='Testing';
        insert srt1;
        
        apexpages.currentPage().getparameters().put('id',claimsum.Id);
        
        Currency_Conversion__c testdata = new Currency_Conversion__c();
        testdata.Bolt_To_Currency__c='USDA';
        testdata.Bolt_Conversion_Rate__c = 2.0;
        testdata.Bolt_Version__c=1.5;
        insert testdata;
        system.debug('**testdata**'+testdata);
        
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        obj.cStatus='Draft';
        obj.csId=claims.id;
        obj.fetchClaimSubmissionRecords();
        integer i=0;
        CG_CL_ClaimsViewPaymentDetails.MultiPSNWrapper multipsn = new CG_CL_ClaimsViewPaymentDetails.MultiPSNWrapper();
        integer j=i++;
        multipsn.counting=j; 
        multipsn.ids=psn1.Id; 
        multipsn.PSN='79464646';
        multipsn.failurePoint='fb'; 
        multipsn.WSD='date'; 
        multipsn.BIS=false;
        multipsn.VIN='vin';
        multipsn.calibrationBefore='cb'; 
        multipsn.revisionBefore='rb';
        multipsn.calibrationAfter='ca'; 
        multipsn.revisionAfter='ra';
        obj.Callgetpaidclaimdetails();
        obj.LocationCode='test';
        obj.WarrantyStartDate='test'; 
        obj.FailureDate='test';
        obj.generatePDF();
        obj.getChooserender();
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper inner1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper();
        CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper inner2 = new CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper();
        inner2.Note='note';
        inner2.NoteType='noteType';
        Date d= System.Today();
        inner2.CreatedDate=string.valueOf(d);
        inner1.AdjustmentReason='test';
        inner1.AccessCode= 'test';
        inner1.ClaimedQuantity='test';
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper inner4 = new   CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper();
        inner4.TravelType='Commercial';
        obj.fetchClaimSubmissionRecords(); 
        test.stopTest();
        
    }
    static testmethod void test211(){
        test.startTest();
        
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Code__c='1234';
        claims.Customer_Name__c='RAJESH';
        claims.ESN__c='56785364';
        claims.Account__c=acc.Id;
        //claims.Location_Code__c ='22720';
        claims.status__c = 'Draft';
        claims.Multi_PSN_Claim__c=true;
        claims.SiebelClaimNumber__c = '123';
        insert claims;
        system.debug('Test class claims'+claims);
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Before_In_Service__c = true;
        psn1.Mileage_Measure__c = 'MI';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        insert psn1;
        CSS_PSN__c  psn2 = new CSS_PSN__c();
        psn2.Name='56785364';
        psn2.Before_In_Service__c = true;
        psn2.Mileage_Measure__c = 'MI';
        psn2.Warranty_Start_Date__c=system.today();
        psn2.CSS_Claims__c=claims.Id;
        psn2.Primary__c=true;
        insert psn2;
        system.debug('Test class claims'+psn1);
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Credit_Date__c = system.today();
        claimsum.Name='Testing';
        insert claimsum;
        
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        po.ExpenseTotal__c=123;
        insert po;
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.Id;
        srt1.Job_Order__c=null;
        srt1.Account_Code__c='Testing';
        insert srt1;
        
        apexpages.currentPage().getparameters().put('id',claimsum.Id);
        
        
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        obj.cStatus='Draft';
        obj.csId=claims.id;
        obj.fetchClaimSubmissionRecords();
        integer i=0;
        CG_CL_ClaimsViewPaymentDetails.MultiPSNWrapper multipsn = new CG_CL_ClaimsViewPaymentDetails.MultiPSNWrapper();
        integer j=i++;
        multipsn.counting=j; 
        multipsn.ids=psn1.Id; 
        multipsn.PSN='79464646';
        multipsn.failurePoint='fb'; 
        multipsn.WSD='date'; 
        multipsn.BIS=false;
        multipsn.VIN='vin';
        multipsn.calibrationBefore='cb'; 
        multipsn.revisionBefore='rb';
        multipsn.calibrationAfter='ca'; 
        multipsn.revisionAfter='ra';
        obj.Callgetpaidclaimdetails();
        obj.LocationCode='test';
        obj.WarrantyStartDate='test'; 
        obj.FailureDate='test';
        obj.generatePDF();
        obj.getChooserender();
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper inner1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper();
        CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper inner2 = new CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper();
        inner2.Note='note';
        inner2.NoteType='noteType';
        Date d= System.Today();
        inner2.CreatedDate=string.valueOf(d);
        inner1.AdjustmentReason='test';
        inner1.AccessCode= 'test';
        inner1.ClaimedQuantity='test';
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper inner4 = new   CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper();
        inner4.TravelType='Meals';
        //inner4.ClaimedMileage=5;
        // CG_CL_ClaimsViewPaymentDetails.Callgetpaidclaimdetails();
        obj.fetchClaimSubmissionRecords(); 
        test.stopTest();
        
    }
    static testmethod void test3(){
        test.startTest();
        
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        
        css_claims__c claims = new css_claims__c();
        claims.Customer_Code__c='1234';
        claims.Customer_Name__c='RAJESH1';
        claims.ESN__c='56785364';
        claims.Multi_PSN_Claim__c=true;
        claims.Account__c=acc.Id;
        insert claims;
        
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        psn1.Mileage_Measure__c='MI';
        psn1.Revision_Before__c='cc';
        psn1.Revision_After__c='cc';
        psn1.Primary__c=true;
        psn1.Before_In_Service__c=true;
        psn1.Calibration_After__c='cc';
        psn1.Calibration_Before__c='cc';
        insert psn1;
        
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Name='Testing';
        insert claimsum;
        
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        insert po;
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.Id;
        srt1.Job_Order__c=null;
        srt1.Account_Code__c='Testing';
        insert srt1;
        
        // apexpages.currentPage().getparameters().put('id',claimsum.Id);
        
        
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        //  obj.fetchClaimSubmissionRecords();
        obj.Callgetpaidclaimdetails();
        obj.LocationCode='test';
        obj.WarrantyStartDate='test'; 
        obj.FailureDate='test';
        obj.generatePDF();
        obj.getChooserender();
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper inner1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper();
        CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper inner6 = new CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper();
        inner6.Note='note';
        inner6.NoteType='noteType';
        Date d= System.Today();
        inner6.CreatedDate=string.valueOf(d);
        inner1.AdjustmentReason='test';
        inner1.AccessCode= 'test';
        inner1.ClaimedQuantity='test';
        inner1.SRTHours=2.0;
        inner1.SRTQty=1;
        inner1.SRTCode='Testing';
        inner1.Hours='Testing';
        inner1.ClaimedQuantity='Testing';
        inner1.Claimedper='Testing';
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailOtherClaimableswrapper inner2 = new  CG_CL_ClaimsViewPaymentDetails.claimDetailOtherClaimableswrapper();
        inner2.AdjustmentReason='Testing';
        inner2.ApprovedAmount='Approved';
        inner2.ClaimedItemAmount='Testing';
        inner2.Description='Testing';
        inner2.Item='Testing';
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailPartswrapper inner3= new CG_CL_ClaimsViewPaymentDetails.claimDetailPartswrapper();
        inner3.AdjustmentPartsPercent='Percent';
        inner3.AdjustmentReason='Testing';
        inner3.ClaimedQuantity='Testing';
        inner3.EPRTracking='Testing';
        inner3.PartDescription='Testing';
        inner3.PartDescription='Testing';
        inner3.PartNumber='Testing';
        inner3.PartQty='Parts';
        inner3.ReturnID='Testing';
        inner3.ClaimedPercentage = 'Claimed';
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper inner4 = new   CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper();
        inner4.AdjustmentReason='Testing';
        inner4.ClaimedAmount=13;
        inner4.ClaimedHours=2.0;
        inner4.ClaimedMileage=1;
        inner4.Distance='4';
        inner4.Hours='2.0';
        inner4.LodgingAmount='3';
        inner4.MealsAmount='2';
        inner4.TowingDetails='2';
        inner4.AdjustedAmount='test';
        inner4.TravelType='lodging';
        inner4.ClaimedMileage=5;
        //inner4.failureMeasure='test';
        
        CG_CL_ClaimsViewPaymentDetails.ClaimsubmissionNotes inner5 = new CG_CL_ClaimsViewPaymentDetails.ClaimsubmissionNotes();
        inner5.Notes='Testing';
        inner5.AdjudicatorName = 'Adjucator';
        CSS_PSN__c  psn11 = new CSS_PSN__c();
        psn11.Name='56785364';
        psn11.Warranty_Start_Date__c=system.today();
        psn11.CSS_Claims__c=claims.Id;
        psn11.Primary__c=true;
        psn11.Mileage_Measure__c='MI';
        psn11.Revision_Before__c='cc';
        psn11.Revision_After__c='cc';
        psn11.Primary__c=true;
        psn11.Before_In_Service__c=true;
        psn11.Calibration_After__c='cc';
        psn11.Calibration_Before__c='cc';
        insert psn11;
        integer i=0;
        CG_CL_ClaimsViewPaymentDetails.MultiPSNWrapper multipsn = new CG_CL_ClaimsViewPaymentDetails.MultiPSNWrapper();
        integer j=i++;
        multipsn.counting=j; 
        multipsn.ids=psn11.Id; 
        multipsn.PSN='79464646';
        multipsn.failurePoint='fb'; 
        multipsn.WSD='date'; 
        multipsn.BIS=false;
        multipsn.VIN='vin';
        multipsn.calibrationBefore='cb'; 
        multipsn.revisionBefore='rb';
        multipsn.calibrationAfter='ca'; 
        multipsn.revisionAfter='ra';          
        
        
        test.stopTest(); 
    }
    static testmethod void test7(){
        test.startTest();
        
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Code__c='1234';
        claims.Customer_Name__c='Gopal';
        claims.ESN__c='56785364';
        claims.status__c = 'Draft';
        claims.Multi_PSN_Claim__c=true;
        claims.Account__c=acc.Id;
        insert claims;
        
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        insert psn1;
        
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Name='Testing';
        
        insert claimsum;
        
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        insert po;
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.Id;
        srt1.Job_Order__c=null;
        srt1.Account_Code__c='Testing';
        insert srt1;
        
        PageReference pref;
        pref = new PageReference('/'+claimsum.Id);
        pref.getParameters().put('id',claimsum.Id);
        pref.getParameters().put('Status','Draft');
        Test.setCurrentPage(pref);
        Note not1 = new note();
        not1.ParentId=claimsum.Id;
        not1.Title='TECHNICIANNOTES';
        not1.Body='Testing';
        insert not1;
        
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        
        test.stopTest();
        
    }
    static testmethod void test6(){
        test.startTest();
        
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        
        css_claims__c claims = new css_claims__c();
        claims.Customer_Code__c='1234';
        claims.Customer_Name__c='Gopal';
        claims.ESN__c='56785364';
        claims.Account__c=acc.Id;
        claims.status__c = 'Draft';
        claims.Multi_PSN_Claim__c=true;
        //claims.EditCorrection__c='test';
        insert claims;
        
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        insert psn1;
        
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Name='Testing';
        
        insert claimsum;
        List<CSS_Parts_Options__c> prtsLst = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        po.Service_partnumber__c='408998500RX';
        insert po;
        CSS_Parts_Options__c po1 = new CSS_Parts_Options__c();
        po1.CSS_Claims__c=claims.Id;
        po1.Service_Job__c=null;
        po1.RecordTypeId=recordtyid;
        po1.Account_Code__c='Testing';
        po1.Service_partnumber__c='408998500RX';
        insert po1;
        prtsLst.add(po);
        prtsLst.add(po1);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.Id;
        srt1.Job_Order__c=null;
        srt1.Account_Code__c='Testing';
        insert srt1;
        
        Date d = date.today();
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.selected_component__C = true;
        solcomp.css_claims__C = claims.id;
        solcomp.type__C = 'Test';
        solcomp.CSS_CoverageType__c = 'NPW';
        solcomp.Part_Warranty_Start_Date__c = d;
        solcomp.Failure_Date__c = d;
        solcomp.Failure_Point__c = 10.00;
        solcomp.Failure_Measure__c = 'Kilometers';
        insert solcomp;
        
        apexpages.currentPage().getparameters().put('id',claimsum.Id);
        
        Note not1 = new note();
        not1.ParentId=claimsum.Id;
        not1.Title='TECHNICIANNOTES';
        not1.Body='Testing';
        insert not1;
        
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        obj.cStatus='Draft';
        obj.MileageValue  = 'Miles';
        obj.productHoursValue = 'Hours';
        obj.csId=claims.id;
        obj.fetchClaimSubmissionRecords();
        obj.Callgetpaidclaimdetails();
        obj.CallGetClaimDetails();
        obj.CreditDateValue='test3';
        //  obj.claimsRecMPSN();
        obj.LocationCode='test';
        obj.WarrantyStartDate='test'; 
        obj.FailureDate='test';
        obj.generatePDF();
        obj.getChooserender();
        obj.CallGetClaimDetails();
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper inner1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper();
        CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper inner2 = new CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper();
        inner2.Note='note';
        inner2.NoteType='noteType';
        Date daVa= System.Today()+30;
        inner2.CreatedDate=string.valueOf(daVa);
        inner1.AdjustmentReason='test';
        inner1.AccessCode= 'test';
        inner1.ClaimedQuantity='test';
        //   inner1.claimDetailSRTswrapper();
        test.stopTest();
        
    }
    static testmethod void test10(){
        test.startTest();
        
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Code__c='1234';
        claims.Customer_Name__c='Gopal';
        claims.EditCorrection__c = 'aka';
        claims.Account__c=acc.Id;
        claims.ESN__c='56785364';
        claims.status__c = 'Draft';
        claims.Multi_PSN_Claim__c=true;
        //claims.EditCorrection__c='test';
        insert claims;
        
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        insert psn1;
        
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Name='Testing';
        
        insert claimsum;
        
        List<CSS_Parts_Options__c> prtLst = new List<CSS_Parts_Options__c>();
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        po.Service_partnumber__c='408998500RX';
        insert po;
        CSS_Parts_Options__c po1 = new CSS_Parts_Options__c();
        po1.CSS_Claims__c=claims.Id;
        po1.Service_Job__c=null;
        po1.RecordTypeId=recordtyid;
        po1.Account_Code__c='Testing';
        po1.Service_partnumber__c='408998500RX';
        insert po1;
        prtLst.add(po);
        prtLst.add(po1);
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.Id;
        srt1.Job_Order__c=null;
        srt1.Account_Code__c='Testing';
        insert srt1;
        
        Date d = date.today();
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.selected_component__C = true;
        solcomp.css_claims__C = claims.id;
        solcomp.type__C = 'Test';
        solcomp.CSS_CoverageType__c = 'NPW';
        solcomp.Part_Warranty_Start_Date__c = d;
        solcomp.Failure_Date__c = d;
        solcomp.Failure_Point__c = 10.00;
        solcomp.Failure_Measure__c = 'Kilometers';
        insert solcomp;
        
        apexpages.currentPage().getparameters().put('id',claimsum.Id);
        
        Note not1 = new note();
        not1.ParentId=claimsum.Id;
        not1.Title='TECHNICIANNOTES';
        not1.Body='Testing';
        insert not1;
        
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        obj.cStatus='Draft';
        obj.MileageValue  = 'Miles';
        obj.productHoursValue = 'Hours';
        obj.csId=claims.id;
        obj.fetchClaimSubmissionRecords();
        obj.Callgetpaidclaimdetails();
        obj.CallGetClaimDetails();
        obj.CreditDateValue='test3';
        //  obj.claimsRecMPSN();
        obj.LocationCode='test';
        obj.WarrantyStartDate='test'; 
        obj.FailureDate='test';
        obj.generatePDF();
        obj.getChooserender();
        obj.CallGetClaimDetails();
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper inner1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper();
        CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper inner2 = new CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper();
        inner2.Note='note';
        inner2.NoteType='noteType';
        Date daVa= System.Today()+30;
        inner2.CreatedDate=string.valueOf(daVa);
        inner1.AdjustmentReason='test';
        inner1.AccessCode= 'test';
        inner1.ClaimedQuantity='test';
        //   inner1.claimDetailSRTswrapper();
        test.stopTest();
        
    }
    static testmethod void test21(){
        test.startTest();
        
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Code__c='1234';
        claims.Customer_Name__c='RAJESH';
        claims.Account__c=acc.Id;
        claims.ESN__c='56785364';
        //claims.Location_Code__c ='22720';
        claims.status__c = 'Draft';
        claims.Multi_PSN_Claim__c=true;
        insert claims;
        system.debug('Test class claims'+claims);
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Before_In_Service__c = true;
        psn1.Mileage_Measure__c = 'MI';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        insert psn1;
        CSS_PSN__c  psn2 = new CSS_PSN__c();
        psn2.Name='56785364';
        psn2.Before_In_Service__c = true;
        psn2.Mileage_Measure__c = 'MI';
        psn2.Warranty_Start_Date__c=system.today();
        psn2.CSS_Claims__c=claims.Id;
        psn2.Primary__c=true;
        insert psn2;
        system.debug('Test class claims'+psn1);
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Credit_Date__c = system.today();
        claimsum.Name='Testing';
        insert claimsum;
        
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        po.ExpenseTotal__c=123;
        insert po;
        
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.Id;
        srt1.Job_Order__c=null;
        srt1.Account_Code__c='Testing';
        insert srt1;
        
        apexpages.currentPage().getparameters().put('id',claimsum.Id);
        
        
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        obj.cStatus='Draft';
        obj.csId=claims.id;
        obj.fetchClaimSubmissionRecords();
        integer i=0;
        CG_CL_ClaimsViewPaymentDetails.MultiPSNWrapper multipsn = new CG_CL_ClaimsViewPaymentDetails.MultiPSNWrapper();
        integer j=i++;
        multipsn.counting=j; 
        multipsn.ids=psn1.Id; 
        multipsn.PSN='79464646';
        multipsn.failurePoint='fb'; 
        multipsn.WSD='date'; 
        multipsn.BIS=false;
        multipsn.VIN='vin';
        multipsn.calibrationBefore='cb'; 
        multipsn.revisionBefore='rb';
        multipsn.calibrationAfter='ca'; 
        multipsn.revisionAfter='ra';
        obj.Callgetpaidclaimdetails();
        obj.LocationCode='test';
        obj.WarrantyStartDate='test'; 
        obj.FailureDate='test';
        obj.generatePDF();
        obj.getChooserender();
        obj.CallGetClaimDetails();
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper inner1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper();
        CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper inner2 = new CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper();
        inner2.Note='note';
        inner2.NoteType='noteType';
        Date d= System.Today();
        inner2.CreatedDate=string.valueOf(d);
        inner1.AdjustmentReason='test';
        inner1.AccessCode= 'test';
        inner1.ClaimedQuantity='test';
        CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper inner4 = new   CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper();
        inner4.AdjustmentReason='Testing';
        inner4.ClaimedAmount=13;
        inner4.ClaimedHours=2.0;
        inner4.ClaimedMileage=1;
        inner4.Distance='4';
        inner4.Hours='2.0';
        inner4.LodgingAmount='3';
        inner4.MealsAmount='2';
        inner4.TowingDetails='2';
        inner4.AdjustedAmount='test';
        inner4.TravelType='lodging';
        inner4.ClaimedMileage=5;
        // CG_CL_ClaimsViewPaymentDetails.Callgetpaidclaimdetails();
        
        test.stopTest();
        
    }
    static testmethod void test61(){
        
        
        id recordtyid=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('Parts').getRecordTypeId();
        id recordtyid1=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('OtherClaimables').getRecordTypeId();
        id recordtyid2=schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('TTML').getRecordTypeId();
        
        Account acc = new Account();
        acc.name='Kenworth Sales Co';
        acc.CSS_DistributorCode__c='02650';
        acc.IAM_Service_Provider_Code__c='97895';
        acc.type='Dealer Account';
        insert acc;
        css_claims__c claims = new css_claims__c();
        claims.Customer_Code__c='1234';
        claims.Customer_Name__c='Gopal';
        claims.ESN__c='56785364';
        claims.EditCorrection__c = 'akanksha';
        claims.Account__c=acc.Id;
        claims.status__c = 'Draft';
        claims.Multi_PSN_Claim__c=true;
        claims.EditCorrection__c='test';
        insert claims;
        
        CSS_PSN__c  psn1 = new CSS_PSN__c();
        psn1.Name='56785364';
        psn1.Warranty_Start_Date__c=system.today();
        psn1.CSS_Claims__c=claims.Id;
        psn1.Primary__c=true;
        insert psn1;
        
        CSS_Claim_Submission__c claimsum = new CSS_Claim_Submission__c();
        claimsum.CSS_Claims__c=claims.Id;
        claimsum.Name='Testing';
        claimsum.Account_Code__c='Emission warrnty 70';
        claimsum.Account_Code__c='test1';
        claimsum.Credit_Date__c=system.today();
        insert claimsum;
        list<CSS_Parts_Options__c> polist = new list<CSS_Parts_Options__c>();
        CSS_Parts_Options__c po = new CSS_Parts_Options__c();
        po.CSS_Claims__c=claims.Id;
        po.Service_Job__c=null;
        po.RecordTypeId=recordtyid;
        po.Account_Code__c='Testing';
        po.Service_partnumber__c='408998500RX';
        po.ExpenseTotal__c=10;
        po.Mileage__c=10;
        po.HoursTravelled__c=10;
        insert po;
        polist.add(po);
        CSS_Parts_Options__c po1 = new CSS_Parts_Options__c();
        po1.CSS_Claims__c=claims.Id;
        po1.Service_Job__c=null;
        po1.RecordTypeId=recordtyid1;
        po1.Account_Code__c='Testing';
        po1.Service_partnumber__c='408998500RX';
        po1.ExpenseTotal__c=10;
        po1.Mileage__c=10;
        po1.HoursTravelled__c=10;
        insert po1;
        polist.add(po1);
        CSS_Parts_Options__c po2 = new CSS_Parts_Options__c();
        po2.CSS_Claims__c=claims.Id;
        po2.Service_Job__c=null;
        po2.RecordTypeId=recordtyid2;
        po2.Account_Code__c='Testing';
        po2.ExpenseTotal__c=10;
        po2.Mileage__c=10;
        po2.HoursTravelled__c=10;
        insert po2;
        polist.add(po2);
        CSS_SRT__c srt1 = new CSS_SRT__c();
        srt1.CSS_Claims__c=claims.Id;
        srt1.Job_Order__c=null;
        srt1.Account_Code__c='Testing';
        insert srt1;
        
        Date d = date.today();
        css_solution_component__c solcomp = new css_solution_component__c();
        solcomp.selected_component__C = true;
        solcomp.css_claims__C = claims.id;
        solcomp.type__C = 'Test';
        solcomp.CSS_CoverageType__c = 'NPW';
        solcomp.Part_Warranty_Start_Date__c = d;
        solcomp.Failure_Date__c = d;
        solcomp.Failure_Point__c = 10.00;
        solcomp.Failure_Measure__c = 'Kilometers';
        insert solcomp;
        
        apexpages.currentPage().getparameters().put('id',claimsum.Id);
        
        Note not1 = new note();
        not1.ParentId=claimsum.Id;
        not1.Title='TECHNICIANNOTES';
        not1.Body='Testing';
        insert not1;
        
        
        CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper inner1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailSRTswrapper();
        CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper inner2 = new CG_CL_ClaimsViewPaymentDetails.claimDetailExternalNotesWrapper();
        inner2.Note='note';
        inner2.NoteType='noteType';
        Date daVa= System.Today()+30;
        inner2.CreatedDate=string.valueOf(daVa);
        inner1.AdjustmentReason='test';
        inner1.AccessCode= 'test';
        inner1.ClaimedQuantity='test';
        //inner1.claimDetailSRTswrapper();
        //Test.setMock(HttpCalloutMock.class, new CSS_mockGetClaimDetailsResponse_Teest());
        CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper ttml1 = new CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper();
        ttml1.TravelType='Meals';
        CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper ttml4 = new CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper();
        ttml4.TravelType='Towing';
        CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper ttml2 = new CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper();
        ttml2.TravelType='Lodging';
        ttml2.ClaimedMileage=10;
        CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper ttml3 = new CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper();
        ttml3.TravelType='Commercial';
        ttml3.ClaimedMileage=100;
        test.startTest();
        CG_CL_ClaimsViewPaymentDetails obj = new CG_CL_ClaimsViewPaymentDetails();
        obj.cStatus='Draft';
        obj.csId=claims.id;
        CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper cdt=new CG_CL_ClaimsViewPaymentDetails.claimDetailTravelwrapper();
        cdt.AdjustedBaseFare=100;
            cdt.AdjustedMeals=20;
            cdt.AdjustedTowing=30;
            cdt.AdjustedLodging=40;
        cdt.ClaimedLodgingMealsAmount=100.0;
         cdt.TotalTravel='100';
          cdt.BaseFare='100';
        cdt.TravelAdjustedPercentage='100';
        obj.MileageValue  = 'Miles';
        obj.productHoursValue = 'Hours';
        obj.fetchClaimSubmissionRecords();
        Map<string, list<CSS_Parts_Options__c>> POAccountCodeMap1 = new Map<string, list<CSS_Parts_Options__c>>();
        POAccountCodeMap1.put('test1',polist);
        obj.Callgetpaidclaimdetails();
        obj.CallGetClaimDetails();
        obj.CreditDateValue='test3';
        //obj.POAccountCodeMap1 = POAccountCodeMap1;
        //  obj.claimsRecMPSN();
        obj.LocationCode='test';
        obj.WarrantyStartDate='test'; 
        obj.FailureDate='test';
        obj.generatePDF();
        obj.getChooserender();
        obj.CallGetClaimDetails();
        test.stopTest();
        
    }
    
}