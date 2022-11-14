@isTest
public class FSL_QSOLController_Test {
    
    @isTest static void testCallout() {
        
        /* CSS_Integration_Details__c conDetails =new  CSS_Integration_Details__c();
        conDetails.Name ='FSL_QSOL_Getwarrantydocs';
        conDetails.End_Point__c ='https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?';
        conDetails.DocumentType__c='ALL';
        conDetails.Language__c ='en';  
        conDetails.BusinessUnit__c ='EBU';
        insert conDetails; */
        
        CSS_accountLanguage__c acclang = new CSS_accountLanguage__C(); 
        acclang.Name = 'en_US';
        acclang.CSS_userLanguage__c = 'English';
        acclang.CSS_QsolLanguage__c = 'en';
        acclang.CSS_EDSLanguage__c = 'en';
        insert acclang;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https//test.com/getQSOLToken';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails1;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'FSL_QSOL_Getwarrantydocs';
        conDetails.End_Point__c = 'https//test.com/Getwarrantydocs';
        conDetails.DocumentType__c='ALL';
        conDetails.Language__c ='en';
        conDetails.BusinessUnit__c ='EBU';
        //conDetails.Passcode__c = 'Admin';
        //conDetails.Username__c = 'Admin'; 
        insert conDetails;
        
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        //FSL_CL_QSOLIntegrations.getToken('FSL_GetApiToken_QSOL');
        List<FSL_QSOLResponsewrapper> fslQSOLResps = new list<FSL_QSOLResponsewrapper>();
        FSL_QSOLController.getTokenQSOL();
        FSL_QSOLController fa = new FSL_QSOLController();
        
        test.stopTest();
    }
    
    
    static testMethod void fsl_fieldactions_Test_Method1() {
        
        // Set mock callout class 
        
        Account acc = new Account();
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.8;
        insert acc;
        
        /* Notes note = new Notes();
        note.Body = 'Test1234';
        note.title = 'Title';
        //note.Createfirstname = 'Test.First'
        //note.CreatedBy.lastname ='Test.LastName';
        //note.CreatedDate = Date.today();
        insert note; */
        
        worktype  wType = new worktype();
        wType.EstimatedDuration = Decimal.valueOf('40.02');
        wType.Name = 'Test';
        insert wType;
        
        Asset  ast = new Asset();
        ast.Account = acc;
        ast.Service_Model__c = 'ISL9 CM2350 L101';
        ast.Unit_Number__c = '1234';
        ast.Make__c = 'KENWORTH';
        ast.Model__c = 'T800';
        ast.Name = '79963830';
        ast.Unit_Type__c = 'EQ8349';
        ast.VIN__c = '1NKDX4TX6JJ180253';
        ast.Type_PSN__c = 'Engines-79963830';
        ast.Application_Description__c = 'AUTOMOTIVE';
        ast.Application_Code__c = '130';
        ast.Engine_Family__c = '56';
        ast.Type__c = 'Engines';
        insert ast;
        
        OperatingHours oh = new OperatingHours();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory serTer1 = new ServiceTerritory();
        serTer1.Name = 'ST005 Mobile';
        serTer1.OperatingHoursId = oh.Id;
        serTer1.IsActive = true;
        serTer1.Location_Code__c = '03522-04893';
        serTer1.FSL_Service_Territory_Code__c = '04893';
        serTer1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer1.Territory__c = 'AUSTRALIA';
        insert serTer1; 
        
        ServiceTerritory serTer = new ServiceTerritory();
        serTer.Name = 'ST001 Mobile';
        serTer.OperatingHoursId = oh.Id;
        serTer.IsActive = true;
        serTer.Location_Code__c = '03520-04892';
        serTer.FSL_Service_Territory_Code__c = '04892';
        serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer.Territory__c = 'AUSTRALIA';
        insert serTer;
        
        Case  cs = new Case();
        cs.Status = 'Intake';
        //cs.Service_Territory__c = serTer.id;
        cs.AccountId = acc.id;
        cs.AssetId = ast.id;
        cs.Priority = 'Medium';
        
        insert cs; 
        
        List<workOrder> woInfo = new List<workOrder>();
        workOrder wo1 = new workOrder();
        wo1.Account = acc;
        wo1.Process_Step__c = 'Intake';
        wo1.Asset = ast;
        wo1.Repair_Location__c = 'Mobile';
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.ServiceTerritoryid = serTer.id;
        wo1.Case = cs;
        wo1.Asset =ast;
        woInfo.add(wo1);
        insert woInfo;
        
        CSS_Solution_Component__c solcomp =new  CSS_Solution_Component__c ();
        //solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.URL__c ='abc';
        solcomp.Component_Id__c = '1234';
        solcomp.Campaign_Description__c = 'abcxyz';
        solcomp.Performed__c =false;
        // solcomp.Performed_Review__c=True;
        solcomp.Reviewed__c=true;
        
        solcomp.Selected_Component__c=true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        
        solcomp.Type__c ='Campaign';
        solcomp.Status__c='Approved';
        solcomp.Complete_Indicator__c =true ;
        solcomp.Multiple_Times__c = true;
        solComp.FSL_Service_Job__c =woInfo[0].id;
        solComp.FSL_Service_Order__c =woInfo[0].id;
        insert solcomp;
        
        string  recordID = ApexPages.CurrentPage().getparameters().put('id',solcomp.id); 
        CSS_accountLanguage__c accLang = new CSS_accountLanguage__c();
        accLang.Name='en_US';
        accLang.CSS_EDSLanguage__c='English';
        accLang.CSS_QsolLanguage__c='English';
        accLang.CSS_userLanguage__c='en';
        insert accLang;
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com',User_Location__c = 'abc', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser1@testorg.com');
        
        
        
        CSS_Solution_Component__c  obj =[select id from CSS_Solution_Component__c  where id=:solcomp.id];
        FSL_QSOLController fsl = new FSL_QSOLController();
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        // fsl.componentid = solcomp.Id ;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.name= 'FSL_QSOL_Getwarrantydocs';
        conDetails1.End_Point__c= 'https://test.Com/getWarrantyDetailCoverage';
        conDetails1.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
        conDetails1.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
        conDetails1.IsActive__c = true;
        conDetails1.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
        
        insert conDetails1; 
        
        
        
        
        CSS_CampTsbTrp__c ct = new CSS_CampTsbTrp__c();
        ct.name = 'CAM';
        ct.name = 'TRP';
        ct.name = 'TSB';
        list<CSS_CampTsbTrp__c> solutionList = new list<CSS_CampTsbTrp__c>();
        CSS_CampTsbTrp__c solRec = new CSS_CampTsbTrp__c( Doc_Num__c='TSB140168',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                         Type__c='CAM',Doc_Title__c='xyz' ,Performed__c= false,Cu_Language__c = 'Hindi',
                                                         Performed_Review__c= false,Reviewed__c= false , esn__c = '73695829',FSL_ServiceJob__c = wo1.Id);
        solutionList.add(solRec);
        CSS_CampTsbTrp__c solRec2 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB14013368',URL__c='https://qsolpilot.cummins.com/qs9/pubsys2/xml/en/tsb/2014/tsb140168.html',
                                                          Type__c='TRP',Doc_Title__c='xyz' ,Performed__c= false,
                                                          Performed_Review__c= true,Reviewed__c= false , esn__c = '1234',FSL_ServiceJob__c = wo1.Id);
        solutionList.add(solRec2); 
        CSS_CampTsbTrp__c solRec1 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB1401689',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c='TSB',Doc_Title__c='xyzk' ,Performed__c= true,
                                                          Performed_Review__c= false,Reviewed__c= false , esn__c = '1234',FSL_ServiceJob__c =wo1.Id);
        solutionList.add(solRec1);
        CSS_CampTsbTrp__c solRec3 = new CSS_CampTsbTrp__c( Doc_Num__c='TSB1401689',URL__c='https://qsolpilot.cummins.com/qs3/pubsys2/xml/en1/tsb/2014/tsb140168.html',
                                                          Type__c='ATC',Doc_Title__c='xyzk' ,Performed__c= true,
                                                          Performed_Review__c= false,Reviewed__c= false , esn__c = '1234',FSL_ServiceJob__c =wo1.id);
        solutionList.add(solRec3);
        insert solutionList;
        
        Test.setMock(HttpCalloutMock.class, new FSL_getDetailCoverage_TestMock());
        CSS_Integration_Details__c conDetails11 = new CSS_Integration_Details__c();
        conDetails11.name= 'FSL_GetApiToken_QSOL';
        conDetails11.End_Point__c= 'https://qs-stg.cummins.com/integrationservices/token/generate';
        conDetails11.Username__c= 'GUIDANZ_WEB';
        conDetails11.Passcode__c= 'XDL7bkPZ7mB!gvKhf@QCR9z!CCxwr?z5zQA-8^Q4-Lk+gLhL^9GAtaP52QqA';
        conDetails11.IsActive__c = true;
        conDetails11.Key__c ='ir1HyKjzKa7VMazv2CPVpVnYCa6nZgieqQkguTTNQjQ=';
        conDetails11.Method_Type__c = 'POST';
        insert conDetails11;  
        
        //try{
        test.starttest();
        fsl.CSSSolutionsFromQSOL();
        FSL_QSOLController.viewcampaigns(wo1.Id);
        test.stoptest();
        // }
        // catch(exception e){}
    }
}