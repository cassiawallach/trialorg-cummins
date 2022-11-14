// Adding Comment for Deployment --- Sriprada S
@isTest
public class FSL_CL_QSOLIntegrations_Test {
    
    @testSetup static void dataSetup() {
        
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
        conDetails1.AuthEnv__c='MuleAuthDEV';
        conDetails1.IsActive__c=true;
        conDetails1.Method_Type__c='Get';
        conDetails1.Timeout__c=12000;
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
        conDetails3.AuthEnv__c='MuleAuthDEV';
        conDetails3.IsActive__c=true;
        conDetails3.Method_Type__c='Get';
        conDetails3.Timeout__c=12000;
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
    }
    
    @isTest static void testCallout() {
        
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_CL_QSOLIntegrations.getToken('FSL_GetApiToken_QSOL');
        test.stopTest();
    }
    
    @isTest static void testCalloutForProcedureLink() {
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_CL_QSOLIntegrations.CallForProcedureLink('123','6548','ur','doc','en');
        test.stopTest();
    }
    
    @isTest static void testCalloutForFCOverview() {
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_FCOverview_Wrapper obj = FSL_CL_QSOLIntegrations.getOverViewCall('45648','Ds45','en');
        FSL_FCOverview_Wrapper dt = new FSL_FCOverview_Wrapper();
        test.stopTest();
    }
    
    @isTest static void testCalloutForServiceHistory() {
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_CL_ServiceHistoryWrapper obj = FSL_CL_QSOLIntegrations.getServiceHistory('test','854-658','600');
        FSL_CL_ServiceHistoryWrapper.DataAreaVal dt = new FSL_CL_ServiceHistoryWrapper.DataAreaVal();
        test.stopTest();
    }
    
    @isTest static void testCalloutForRetrieveOptionList() {
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_CL_QSOLIntegrations.CallForOptionList('79788868');
        test.stopTest();
    }
}