@isTest
public class CSS_FN_Triage_V2_Test {
    @istest static void getPrioritizedFCResponseTest() {
      //  test.setmock(HttpCalloutMock.class, new CSS_WPR_TG_GetAssesDataReqJSON2Mockup());	
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2();
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2 res = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2();
        CSS_FN_Triage_V2 fnt = new CSS_FN_Triage_V2();
        Test.startTest();
        res = fnt.getPrioritizedFCResponse(req);
        Test.stopTest();
        
    }
     @istest static void getLaborHrsDataResponseTest() {
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2();
                 CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2 res = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2();
        CSS_FN_Triage_V2 fnt = new CSS_FN_Triage_V2();
        res = fnt.getLaborHrsDataResponse(req);
        
    }
            @istest static void getAssessDataResponseTest() {
            CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2();
            CSS_WPR_TG_FaultDetailsDataResJSON_V2 res = new CSS_WPR_TG_FaultDetailsDataResJSON_V2();
            CSS_FN_Triage_V2 fnt = new CSS_FN_Triage_V2();
            res = fnt.getAssessDataResponse(req);
        
    }
            @istest static void createIACSSJobTest() {
            CSS_FN_Triage_V2.WrapperInput req = new CSS_FN_Triage_V2.WrapperInput();
            CSS_WPR_TG_IACSSJobCreationResJSON_V2 res = new CSS_WPR_TG_IACSSJobCreationResJSON_V2();
            CSS_FN_Triage_V2 fnt = new CSS_FN_Triage_V2();
            res = fnt.createIACSSJob(req);
        
    }
            @istest static void executeFCAandFaultDetailsServicesTest() {
            CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2();
            CSS_FN_Triage_V2.WrapperInput res = new CSS_FN_Triage_V2.WrapperInput();
            CSS_FN_Triage_V2 fnt = new CSS_FN_Triage_V2();
            res = fnt.executeFCAandFaultDetailsServices(req);
        
    }    
            @istest static void executeFCAServicesTest() {
            CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2();
            CSS_FN_Triage_V2.WrapperInput res = new CSS_FN_Triage_V2.WrapperInput();
            CSS_FN_Triage_V2 fnt = new CSS_FN_Triage_V2();
                Test.startTest();
        res = fnt.executeFCAServices(req);
        Test.stopTest();               
    }
        @istest static void getResponseOfFCAFaultDetailsServiceTest() {
            CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2();
            CSS_WPR_FCA_FaultDetailsResJSON2Apex res = new CSS_WPR_FCA_FaultDetailsResJSON2Apex();
            CSS_FN_Triage_V2 fnt = new CSS_FN_Triage_V2();
                Test.startTest();
        res = fnt.getResponseOfFCAFaultDetailsService(req);
        Test.stopTest();               
    }
            @istest static void getPrioritizedFCSetTest() {
                CSS_WPR_FCA_PrioritizedFCsResJSON2Apex req = new CSS_WPR_FCA_PrioritizedFCsResJSON2Apex();
                Set<String> PriorFCset = new Set<String>();
                CSS_FN_Triage_V2 fnt = new CSS_FN_Triage_V2();
                Test.startTest();
        PriorFCset = fnt.getPrioritizedFCSet(req);
        Test.stopTest();               
    }
            @istest static void prepareFaultDetailsMapTest() {
                CSS_WPR_FCA_FaultDetailsResJSON2Apex req = new CSS_WPR_FCA_FaultDetailsResJSON2Apex();
                Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap1 = new Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList>();
                Test.startTest();
                faultDetailsMap1 = CSS_FN_Triage_V2.prepareFaultDetailsMap(req);
                Test.stopTest();               
    }
    @istest static void getLaborHrsMapTest() {
        Set<String> setStr = new Set<String>{'abc','def'};
        Map<String, String> laborHrsMap = new Map<String, String>();           
            Test.startTest();
        CSS_FN_Triage_V2 fnt = new CSS_FN_Triage_V2();        
        laborHrsMap = fnt.getLaborHrsMap(setStr,'smn','make','model','access');
        Test.stopTest();               
    }
            @istest static void getLaborHrsTest() {
         CSS_FN_Triage_V2.WrapperInput wrapInput = new CSS_FN_Triage_V2.WrapperInput();
                Map<String, String> laborHrsMap = new Map<String, String>{'a'=>'b','c'=>'d'};
            String laborHrs = '';
            Test.startTest();
        CSS_FN_Triage_V2 fnt = new CSS_FN_Triage_V2();        
        laborHrs = fnt.getLaborHrs(wrapInput,'faultcode1',laborHrsMap);
        Test.stopTest();               
    }
    @istest static void testmethodcreateIACSSJob()
    {
      Profile p=[SELECT Id, Name FROM Profile where name='System Administrator' limit 1];
        userrole ur = new userrole(Name='ADVANCED-CUMMINS CENTRAL-LAKE');
        insert ur;
        user u = new user(UserName='Test1234@cummins.com',IsActive=true,Alias='Test1234',lastname='Test1234',email='Test@cummins.com',profileid=p.id,UserRoleId=ur.id,EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US',TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US');
        insert u;
        system.assert(u!=null);
        user u1 = [SELECT Id, Username, IsActive,LastName, Alias,Email, UserRoleId, LocaleSidKey, TimeZoneSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey FROM User limit 1];
        
        string sh = string.valueOf(u1.id);
        system.runAs(u)
        {
            
            CSS_DataExchange_Parent__c DEParent =new CSS_DataExchange_Parent__c();
            DEParent.PSN__c='79464646';
            DEParent.Customer_Company_Name__c='Test';
            DEParent.Complaint_Text__c='Testing complaint';
            DEParent.User_Location_filtered__c='04321-04321';
            DEParent.Request_JSON__c='Testing';
            DEParent.Response_JSON__c='Testing';
            Insert DEParent;
             CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        inte.Name = 'MachineDataCloud';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'MachineDataCloud';
        inte.End_Point__c = 'MachineDataCloud.com';
        inte.IsActive__c = true;
        insert inte;
            list<CSS_DataExchange_Parent__c> listDEparentlist= new  list<CSS_DataExchange_Parent__c>();
            listDEparentlist.add(DEParent);
            system.assert(DEParent!=null);
            test.startTest();
            CSS_FN_Triage_V2.createIACSSJob(DEParent,sh);
            css_fn_triage_v2.storeIASRecordsInMDC(listDEparentlist);
           // CSS_FN_Triage_V2.createIACSSJob(null,sh);
            test.stopTest();
        }
        
    }
}