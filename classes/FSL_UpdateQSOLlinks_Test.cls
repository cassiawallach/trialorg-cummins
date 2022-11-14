@isTest
public class FSL_UpdateQSOLlinks_Test {
    
    @testSetup static void dataSetup() 
    {
        // CT3-68-QSOL-Translations, Added by Sailaja Guntupalli
        CSS_accountLanguage__c acclang = new CSS_accountLanguage__C(); 
        acclang.Name = 'en_US';
        acclang.CSS_userLanguage__c = 'English';
        acclang.CSS_QsolLanguage__c = 'en';
        acclang.CSS_EDSLanguage__c = 'en';
        insert acclang;

        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getQSOLToken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_GetApiToken_QSOL';
		insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https//test.com/getProcedureLink';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'FSL_QSOL_ProcedureLink'; 
        insert conDetails1;
        
        CSS_Integration_Details__c conDetails2 = new CSS_Integration_Details__c();
        conDetails2.End_Point__c = 'https//test.com/getFCOverview';
        conDetails2.Passcode__c = 'Admin';
        conDetails2.Username__c = 'Admin';
        conDetails2.Name = 'FSL_QSOL_FCOverview'; 
        insert conDetails2;
        
        CSS_Integration_Details__c conDetails3 = new CSS_Integration_Details__c();
        conDetails3.End_Point__c = 'https//test.com/getServiceHistory';
        conDetails3.Passcode__c = 'Admin';
        conDetails3.Username__c = 'Admin';
        conDetails3.Name = 'FSL_MoveX_ServiceHistory'; 
        insert conDetails3;
        
        CSS_Integration_Details__c conDetails4 = new CSS_Integration_Details__c();
        conDetails4.End_Point__c = 'https//test.com/getRetrieveOptionList';
        conDetails4.Passcode__c = 'Admin';
        conDetails4.Username__c = 'Admin';
        conDetails4.Name = 'FSL_QSOL_RetrieveOptionList'; 
        insert conDetails4;
        
        CSS_Integration_Details__c conDetails5 = new CSS_Integration_Details__c();
        conDetails5.End_Point__c = 'https//test.com/Getwarrantydocs';
        conDetails5.Passcode__c = 'Admin';
        conDetails5.Username__c = 'Admin';
        conDetails5.Name = 'FSL_QSOL_Getwarrantydocs'; 
        insert conDetails5;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory serTer = new ServiceTerritory();
        serTer.Name = 'ST001 Mobile';
        serTer.OperatingHoursId = oh.Id;
        serTer.IsActive = true;
        serTer.Location_Code__c = '03520-04892';
        serTer.FSL_Service_Territory_Code__c = '04892';
        serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer.Territory__c = 'AUSTRALIA';
        insert serTer;
        
        workorder objwo = new workorder();
        objwo.Process_Step__c = 'Intake';
        objwo.Repair_Location__c = 'Mobile';
        objwo.EditComplaint__c = 'Testing';
        objwo.EditCause__c = 'Testing';
        objwo.EditCorrection__c = 'Testing';
        objwo.EditCoverage__c = 'Testing';
        objwo.ServiceTerritoryid = serTer.id;
        insert objwo;

    }
    @isTest static void testCallout()
    {
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_CL_QSOLIntegrations.getToken('FSL_GetApiToken_QSOL');
        Test.stopTest();
    }
    
    @isTest static void testCalloutForProcedureLink()
    {
        workorder objwo = [SELECT id FROM workorder LIMIT 1 ];
        List<CSS_Solution_Component__c> solcmps = new List<CSS_Solution_Component__c>();
        solcmps.add(new CSS_Solution_Component__c( Fault_Code__c = 'test123',FSL_Service_Job__c=objwo.id));
        insert solcmps;
        
        Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        Test.stopTest();

        FSL_UpdateQSOLlinks updater = new FSL_UpdateQSOLlinks(solcmps,objwo.id);
        System.enqueueJob(updater);
    }
  
   
}