//Added for CodeCoverage
@isTest
public class FSL_GETCampaignServices_Test {
    
    @testSetup static void dataSetup() {
        
        // CT3-68-QSOL-Translations,Added by Sailaja Guntupalli  
        CSS_accountLanguage__c acclang = new CSS_accountLanguage__C(); 
        acclang.Name = 'en_US';
        acclang.CSS_userLanguage__c = 'English';
        acclang.CSS_QsolLanguage__c = 'en';
        acclang.CSS_EDSLanguage__c = 'en';
        insert acclang;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/Getwarrantydocs';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_QSOL_Getwarrantydocs'; 
        insert conDetails;    
    }
    
    static testMethod void testAccessToken() {
        
        test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_WS_OAG.getAccessToken();
    }
    
    static testMethod void testCDSToken() {
        
        CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
        conDetail.Name = 'GetSymptomsTest';
        conDetail.Username__c = '562e164f-f255-4eff-9c29-3ceed139c0dd';
        conDetail.Passcode__c = 'nFdnKFgXVjKg5JZTOmA2zzCaSUgh0FZi6GXvJBYFV4M=';
        conDetail.End_Point__c = 'https://cdsdomain-dev.cummins.com/api/v1/GetToken';
        conDetail.Key__c = '562e164f-f255-4eff-9c29-3ceed139c0dd';
        insert conDetail;
        
        test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        HttpRequest req = new HttpRequest();
        List<CSS_Integration_Details__c> conDetails = new List<CSS_Integration_Details__c>();
        FSL_WS_OAG.getAccessTokenCDS('GetSymptomsTest');
    }
    
    static testMethod void testCDSToken1() {
        
        CSS_Integration_Details__c conDetail1 = new CSS_Integration_Details__c();
        conDetail1.Name = 'GetSymptomsTesting';
        conDetail1.Username__c = '562e164f-f255-4eff-9c29-3ceed139c0dd';
        conDetail1.Passcode__c = 'nFdnKFgXVjKg5JZTOmA2zzCaSUgh0FZi6GXvJBYFV4M=';
        conDetail1.End_Point__c = 'https://cdsdomain-dev.cummins.com/api/v1/GetToken';
        conDetail1.Key__c = '562e164f-f255-4eff-9c29-3ceed139c0dd';
        insert conDetail1; 
        
        FSL_WS_OAG.getAccessTokenCDS('GetSymptomsTesting');
    }
    
    public static testMethod void testgetToken() {
        FSL_GETCampaignServices.doCallout = false;
        // Test.setMock(HttpCalloutMock.class, new FSLFaultCodeTokenMock());
        
        workorder objwor = new workorder();
        objwor.ServiceTerritoryId = FSL_TestDataUtility.createServiceTerritory().Id;
        insert objwor;
        Account acc = new Account();
        acc.Name = 'East Bronx1'; 
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        insert acc;
        
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
        ast.Engine_Family__c    ='56'; 
        ast.Type__c = 'Engines';
        insert ast;
        
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
        
        Test.startTest();
        workorder wo1 = new workorder();
        wo1.Account = acc;
        wo1.Process_Step__c = 'Intake';
        wo1.Asset = ast;
        wo1.Repair_Location__c = 'Mobile';
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.ServiceTerritoryid = serTer.id;
        //wo1.Case = cs;
        wo1.sub_status__c = 'Troubleshooting Complete';
        insert wo1;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        List<CSS_Solution_Component__c> lstCSS = new List<CSS_Solution_Component__c>();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.FSL_Service_Job__c = objwor.Id;
        AddsolComp.FSL_Service_Order__c  = objwor.Id;
        AddsolComp.Action__c = 'Repair';
        //AddsolComp.Solutions__c = Solution.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        //AddsolComp.
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        //Addsolcomp.Part_Assignment__c ='Primary';
        //AddsolComp.Fail_Code__c ='Test-FAilcode';
        //  AddsolComp.FailCode_Formula__c = 'Test-FailCode';   Field is not writeable
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        //AddsolComp.Activity__c = 'Test'+Math.random();
        AddsolComp.Performed_Review__c  = false;
        
        lstCSS.add(AddsolComp);
        // insert lstCSS;
        //Test.startTest();
        try{
            FSL_GETCampaignServices.storeApplicationOrCategoryComplaintList(objwor.Id);
            FSL_GETCampaignServices.getFieldActions('79950304', 'AUSTRALIA/ NewZEALAND', 'AUSTRALIA', '14 Jul 20');
            FSL_GETCampaignServices.getQsolLinks('79950304', lstCSS);
            FSL_GETCampaignServices.displayFA(lstCSS,objwor.Id);
        }
        catch(exception e){
            
        }
        //system.assert(objwor.Id,)
        Test.stopTest();
    }
      
    public static testMethod void testGetResponseForFSLCampaignService() {
        Test.setMock(HttpCalloutMock.class, new FSL_GETCampaignServices_TestMock());
        Test.startTest();
        CG_OP_OAGWrapper responseWrapper = FSL_GETCampaignServices.getResponseForFSLCampaignService('dummypath');
        FSL_GETCampaignServiceswrapper outputRes = (FSL_GETCampaignServiceswrapper) JSON.deserializeStrict(responseWrapper.response.getBody(), FSL_GETCampaignServiceswrapper.class);
        system.assert(outputRes!=null);
        Test.stopTest();
    }
}