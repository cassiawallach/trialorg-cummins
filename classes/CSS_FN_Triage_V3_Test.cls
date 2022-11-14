@isTest
public class CSS_FN_Triage_V3_Test {
    @istest static void getPrioritizedFCResponseTest() {
      //  test.setmock(HttpCalloutMock.class, new CSS_WPR_TG_GetAssesDataReqJSON2Mockup());	
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3 res = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
        Test.startTest();
        res = fnt.getPrioritizedFCResponse(req);
        Test.stopTest();
        
    }
     @istest static void getLaborHrsDataResponseTest() {
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
                 CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3 res = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
        res = fnt.getLaborHrsDataResponse(req);
        
    }
            @istest static void getAssessDataResponseTest() {
            CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
            CSS_WPR_TG_FaultDetailsDataResJSON_V3 res = new CSS_WPR_TG_FaultDetailsDataResJSON_V3();
            CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
            res = fnt.getAssessDataResponse(req);
        
    }
            @istest static void createIACSSJobTest() {
            CSS_FN_Triage_V3.WrapperInput req = new CSS_FN_Triage_V3.WrapperInput();
            CSS_WPR_TG_IACSSJobCreationResJSON_V3 res = new CSS_WPR_TG_IACSSJobCreationResJSON_V3();
            CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
                String userIdAdvancedRole = 'test';
          //  res = fnt.createIACSSJob(req,userIdAdvancedRole);
        
    }
            @istest static void executeFCAandFaultDetailsServicesTest() {
            CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
            CSS_FN_Triage_V3.WrapperInput res = new CSS_FN_Triage_V3.WrapperInput();
            CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
            res = fnt.executeFCAandFaultDetailsServices(req);
        
    }    
            @istest static void executeFCAServicesTest() {
            CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
            CSS_FN_Triage_V3.WrapperInput res = new CSS_FN_Triage_V3.WrapperInput();
            CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
                Test.startTest();
        res = fnt.executeFCAServices(req);
        Test.stopTest();               
    }
        @istest static void getResponseOfFCAFaultDetailsServiceTest() {
            CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
            CSS_WPR_FCA_FaultDetailsResJSON2Apex res = new CSS_WPR_FCA_FaultDetailsResJSON2Apex();
            CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
                Test.startTest();
        res = fnt.getResponseOfFCAFaultDetailsService(req);
        Test.stopTest();               
    }
            @istest static void getPrioritizedFCSetTest() {
                CSS_WPR_FCA_PrioritizedFCsResJSON2Apex req = new CSS_WPR_FCA_PrioritizedFCsResJSON2Apex();
                Set<String> PriorFCset = new Set<String>();
                CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
                Test.startTest();
        PriorFCset = fnt.getPrioritizedFCSet(req);
        Test.stopTest();               
    }
            @istest static void prepareFaultDetailsMapTest() {
                CSS_WPR_FCA_FaultDetailsResJSON2Apex req = new CSS_WPR_FCA_FaultDetailsResJSON2Apex();
                Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap1 = new Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList>();
                Test.startTest();
                faultDetailsMap1 = CSS_FN_Triage_V3.prepareFaultDetailsMap(req);
                Test.stopTest();               
    }
    @istest static void getLaborHrsMapTest() {
        Set<String> setStr = new Set<String>{'abc','def'};
        Map<String, CSS_Make_Model_Access__c> laborHrsMap = new Map<String, CSS_Make_Model_Access__c>();           
            Test.startTest();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();        
        laborHrsMap = fnt.getLaborHrsMap(setStr,'smn','make','model','access');
        Test.stopTest();               
    }
            @istest static void getLaborHrsTest() {
         CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
                Map<String, String> laborHrsMap = new Map<String, String>{'a'=>'b','c'=>'d'};
            String laborHrs = '';
            Test.startTest();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();        
       // laborHrs = fnt.getLaborHrs(wrapInput,'faultcode1',laborHrsMap);
        Test.stopTest();               
    }
}