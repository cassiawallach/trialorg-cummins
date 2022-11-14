@isTest
public class CSS_TestData_Test {
    
    public static testMethod void testData(){
        Account a = new Account();
        a.name='Kenworth Sales Co';
        a.CSS_DistributorCode__c='02466';
        a.IAM_Service_Provider_Code__c='19134';
        a.Type='Dealer Account';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        
        //Test Data
        
        CSS_Job_Order__c JO1 = new CSS_Job_Order__c();
        JO1.Account__c=a.Id;
        JO1.Customer_Name__c = 'CumminsTnD';
        JO1.Equipment_ID__c = 'EQ7667';
        JO1.Qsol_Engine_Family_Code__c ='56';
        JO1.AccessCode__c = 'A';
        insert JO1;
        
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = JO1.ID;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        solAdd.Name='Additional SRTS';
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Repair_Response__c = 'Most likely ';
        insert solAdd;
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = JO1.ID;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = solAdd.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        //AddsolComp.
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        //Addsolcomp.Part_Assignment__c ='Primary';
        //AddsolComp.Fail_Code__c ='Test-FAilcode';
        //  AddsolComp.FailCode_Formula__c = 'Test-FailCode';   Field is not writeable
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        insert AddsolComp;
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c =JO1.ID;
        parts.selected_part__c = true;
        parts.FailurepartId__c = AddsolComp.id;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=solAdd.id;
        //records added for TTMl records
        parts.Type__c='Commercial-Travel';
        parts.ExpenseTotal__c=100;
        // parts.recordtype.name='TTML';
        insert parts;
        
        CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(true);
        CSS_accountLanguage__c aL = CSS_TestData.createAccountLanguage(true);
        CSS_accountLanguage__c accLan = new CSS_accountLanguage__c();
        accLan.Name='en_US';
        accLan.CSS_EDSLanguage__c='English';
        accLan.CSS_QsolLanguage__c='English';
        accLan.CSS_userLanguage__c='English';
        insert accLan;
        
        CSS_CampTsbTrp__c ctt = CSS_TestData.createCampTsbTrp(true,'1234',JO1.ID);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO1.ID);
        CSS_SRT__c srt = CSS_TestData.createSRT(true,'Diagnosis',solAdd.id , JO1.ID);
        CSS_Solution_Component__c solCom = CSS_TestData.createSRT(true,JO1.ID , solAdd.id);
        CSS_Quote__c quo = CSS_TestData.createquoteObj(true);
        CSS_TestData.createIntegrationDetails(true);
        Account Acc = CSS_TestData.createAccountObj(true);
        CSS_TestData.createTestUser(true);
        CSS_TestData.createJobEventTempObj(true);
        CSS_TestData.createAccreditationtesObj(true, acc.id);
        case cs = CSS_TestData.createCase(true,'Feedback');
        CSS_TestData.createDataExchangeParentRecords(true);
        CSS_Parts_Options__c poc=CSS_TestData.createParts(true,JO1.ID,AddsolComp.id,solAdd.id);
        //CSS_UserLocation__c uLoc = CSS_TestData.createUserLocation();
        Account acc1 = new Account();
        acc1.name='Rtest';
        acc1.CSS_DistributorCode__c='562701';
        acc1.IAM_Service_Provider_Code__c='562551';
        acc1.Type='Dealer Account';
        acc1.IAM_Service_Provider_Code__c='33333';
        acc1.IAM_Service_Provider_Code__c = '562551';
        //acc1.IAM_Service_Provider_Code__c = '56270';
        acc1.CMI_Account_Status__c = 'Active';
        //acc1.Region__c = 'US and Canada';
        insert acc1;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com', User_Location__c='123456');
        
        // insert objUser1;
        
        CSS_UserLocation__c uLocation = new CSS_UserLocation__c(AccountId__c=acc1.id,isActive__c=true,isPrimary__c=true,UserId__c=objUser1.Id,Location_code__c='56270-56270');
        insert uLocation;
        CSS_Job_Order__c c = new CSS_Job_Order__c();
        CSS_TestData.createTechnicians(SerRec.id);
        // CSS_TestData.createUserLocation();
        decimal d =  CSS_TestData.createTTMLRecords();
    }
    
    
    static testmethod void testcreateclaimsmethod()
    {
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        CSS_claims__c claims = CSS_TestData.createclaims(true,jo.id);
        system.assert(claims!=null);
        CSS_claims__c claims2 = CSS_TestData.createclaims(true,null);
    }
    
    static testmethod void testcreateclaimsubmethod()
    {
        
        CSS_claims__c claims = CSS_TestData.createclaims(true,null);
        CSS_Claim_Submission__c claimsub = CSS_TestData.createclaimsub(true,claims.id);
        system.assert(claimsub!=null);
        system.assertequals(claims.id,claimsub.CSS_Claims__c);
        
    }
    
    static testmethod void testcreatePartsnew()
    {
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(true);
        CSS_claims__c claims = CSS_TestData.createclaims(true,jo.id);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,jo.id);
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(true,jo.id,sol.id);
        CSS_Parts_Options__c partop = CSS_TestData.createParts_new(true,jo.id,solcomp.id,sol.id,claims.id);
        
        system.assert(partop!=null);
        
    }
    
    static testmethod void testcreatesrtnew()
    {
         Account a = new Account();
        a.name='Kenworth Sales Co';
        a.CSS_DistributorCode__c='02466';
        a.IAM_Service_Provider_Code__c='19134';
        a.Type='Dealer Account';
        a.CMI_Account_Status__c = 'Active';
        insert a;
        CSS_Job_Order__c jo = CSS_TestData.createJobOrder(false);
        jo.Account__c=a.id;
        CSS_claims__c claims = CSS_TestData.createclaims(false,jo.id);
        CSS_Solutions__c sol = CSS_TestData.createSolutions(false,jo.id);
        CSS_SRT__c srt= CSS_TestData.createSRT_New(false,'Diagnosis',sol.id,jo.id,claims.id);
        system.assert(srt!=null);
        
    }
    
    static testmethod void testcreatepsnmethod()
    {
        CSS_claims__c claims = CSS_TestData.createclaims(true,null);
        CSS_PSN__c psn=CSS_TestData.createpsn(true,claims.id);
        system.assert(psn!=null);
    }
}