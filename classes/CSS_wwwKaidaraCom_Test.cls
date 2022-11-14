@isTest
public class CSS_wwwKaidaraCom_Test {
    static testMethod void test(){
        // wwwKaidaraCom wkc = new wwwKaidaraCom();
        // KaidaraServiceImplPort ksip = new wkc.KaidaraServiceImplPort().createDiagnosticSession('session','title','workorder','model','serialNumber');
        //wkc.createDiagnosticSessionResponse();
        //wkc.KaidaraServiceImplPort().createDiagnosticSession('session','title','workorder','model','serialNumber');
        new wwwKaidaraCom.createDiagnosticSessionResponse();
        new wwwKaidaraCom.getWorkgroup();
        new wwwKaidaraCom.viewDiagnosticSessionResponse();
        new wwwKaidaraCom.exitDiagnosticSessionResponse();
        new wwwKaidaraCom.switchAndFireTransitionResponse();
        new wwwKaidaraCom.viewDiagnosticSession();
        new wwwKaidaraCom.closeResponse();
        new wwwKaidaraCom.closeDiagnosticSession();
        new wwwKaidaraCom.getKBStructureResponse();
        new wwwKaidaraCom.switchStateResponse();
        new wwwKaidaraCom.loginWithToken();
        new wwwKaidaraCom.switchChunkIndex();
        new wwwKaidaraCom.setQuery();
        new wwwKaidaraCom.getDiagnosticSessionSolutionsFilterResponse();
        new wwwKaidaraCom.getDiagnosticSessionSolutions();
        new wwwKaidaraCom.loginResponse();
        new wwwKaidaraCom.setDiagnosticSessionPropertyResponse();
        new wwwKaidaraCom.getDiagnosticSessionSolutionsFilter();
        new wwwKaidaraCom.startFeature();
        new wwwKaidaraCom.openResponse();
        new wwwKaidaraCom.getKBStructure();
        new wwwKaidaraCom.switchChunkIndexResponse();
        new wwwKaidaraCom.sendCaseMailResponse();
        new wwwKaidaraCom.setDiagnosticSessionProperty();
        new wwwKaidaraCom.getDiagnosticSessionResponse();
        new wwwKaidaraCom.searchDiagnosticSession();
        new wwwKaidaraCom.setLocale();
        new wwwKaidaraCom.getValueDomainResponse();
        new wwwKaidaraCom.sendCaseMail();
        new wwwKaidaraCom.searchDiagnosticSessionResponse();
        new wwwKaidaraCom.loginWithTokenResponse();
        new wwwKaidaraCom.continueDiagnosticSession();
        new wwwKaidaraCom.login();
        new wwwKaidaraCom.startFeatureResponse();
        new wwwKaidaraCom.getLocaleResponse();
        new wwwKaidaraCom.createDiagnosticSession();
        new wwwKaidaraCom.fireTransition();
        new wwwKaidaraCom.getValueDomain();
        new wwwKaidaraCom.fireTransitionResponse();
        new wwwKaidaraCom.closeDiagnosticSessionResponse();
        new wwwKaidaraCom.sendFeedbackResponse();
        new wwwKaidaraCom.getWorkgroupResponse();
        new wwwKaidaraCom.close();
        new wwwKaidaraCom.getDiagnosticSessionSolutionsResponse();
        new wwwKaidaraCom.setLocaleResponse();
        new wwwKaidaraCom.Exception_x();
        new wwwKaidaraCom.sendFeedback();
        new wwwKaidaraCom.continueDiagnosticSessionResponse();
        new wwwKaidaraCom.getDiagnosticSession();
        new wwwKaidaraCom.setQueryResponse();
        new wwwKaidaraCom.exitDiagnosticSession();
        new wwwKaidaraCom.switchAndFireTransition();
        new wwwKaidaraCom.getLocale();
        new wwwKaidaraCom.open();
        new wwwKaidaraCom.switchState();
        //new  wwwKaidaraCom.KaidaraServiceImplPort().createDiagnosticSession('session','title','workorder','model','serialNumber');
        
    }
    
    public class WebServiceMockImpl implements WebServiceMock{
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof wwwKaidaraCom.createDiagnosticSession){
                response.put('response_x', new wwwKaidaraCom.createDiagnosticSessionResponse());
            }
            else if(request instanceof wwwKaidaraCom.loginWithToken){
                response.put('response_x', new wwwKaidaraCom.loginWithTokenResponse());
            }
            else if(request instanceof wwwKaidaraCom.getDiagnosticSessionSolutions){
                response.put('response_x', new wwwKaidaraCom.getDiagnosticSessionSolutionsResponse());    
            }
            else if(request instanceof wwwKaidaraCom.open){
                response.put('response_x', new wwwKaidaraCom.openResponse());    
            }
            else if(request instanceof wwwKaidaraCom.getLocale){
                response.put('response_x', new wwwKaidaraCom.getLocaleResponse());    
            }
            else if(request instanceof wwwKaidaraCom.searchDiagnosticSession){
                response.put('response_x', new wwwKaidaraCom.searchDiagnosticSessionResponse());    
            }
            else if(request instanceof wwwKaidaraCom.login){
                response.put('response_x', new wwwKaidaraCom.loginResponse());    
            }
            else if(request instanceof wwwKaidaraCom.fireTransition){
                response.put('response_x', new wwwKaidaraCom.fireTransitionResponse());    
            }
            else if(request instanceof wwwKaidaraCom.setQuery){
                response.put('response_x', new wwwKaidaraCom.setQueryResponse());    
            }
            else if(request instanceof wwwKaidaraCom.getDiagnosticSessionSolutionsFilter){
                response.put('response_x', new wwwKaidaraCom.getDiagnosticSessionSolutionsFilterResponse());    
            }
            else if(request instanceof wwwKaidaraCom.close){
                response.put('response_x', new wwwKaidaraCom.closeResponse());    
            }
            else if(request instanceof wwwKaidaraCom.sendCaseMail){
                response.put('response_x', new wwwKaidaraCom.sendCaseMailResponse());    
            }
            else if(request instanceof wwwKaidaraCom.closeDiagnosticSession){
                response.put('response_x', new wwwKaidaraCom.closeDiagnosticSessionResponse());    
            }
            else if(request instanceof wwwKaidaraCom.exitDiagnosticSession){
                response.put('response_x', new wwwKaidaraCom.exitDiagnosticSessionResponse());    
            }
            else if(request instanceof wwwKaidaraCom.setLocale){
                response.put('response_x', new wwwKaidaraCom.setLocaleResponse());    
            }
            else if(request instanceof wwwKaidaraCom.sendFeedback){
                response.put('response_x', new wwwKaidaraCom.sendFeedbackResponse());    
            }
            else if(request instanceof wwwKaidaraCom.setDiagnosticSessionProperty){
                response.put('response_x', new wwwKaidaraCom.setDiagnosticSessionPropertyResponse());    
            }
            else if(request instanceof wwwKaidaraCom.getValueDomain){
                response.put('response_x', new wwwKaidaraCom.getValueDomainResponse());    
            }
            else if(request instanceof wwwKaidaraCom.getWorkgroup){
                response.put('response_x', new wwwKaidaraCom.getWorkgroupResponse());    
            }
            else if(request instanceof wwwKaidaraCom.getDiagnosticSession){
                response.put('response_x', new wwwKaidaraCom.getDiagnosticSessionResponse());    
            }
            else if(request instanceof wwwKaidaraCom.switchChunkIndex){
                response.put('response_x', new wwwKaidaraCom.switchChunkIndexResponse());    
            }
            else if(request instanceof wwwKaidaraCom.continueDiagnosticSession){
                response.put('response_x', new wwwKaidaraCom.continueDiagnosticSessionResponse());    
            }
            else if(request instanceof wwwKaidaraCom.viewDiagnosticSession){
                response.put('response_x', new wwwKaidaraCom.viewDiagnosticSessionResponse());    
            }
            else if(request instanceof wwwKaidaraCom.switchAndFireTransition){
                response.put('response_x', new wwwKaidaraCom.switchAndFireTransitionResponse());    
            }
            else if(request instanceof wwwKaidaraCom.switchState){
                response.put('response_x', new wwwKaidaraCom.switchStateResponse());    
            }
            else if(request instanceof wwwKaidaraCom.startFeature){
                response.put('response_x', new wwwKaidaraCom.startFeatureResponse());    
            }
            else if(request instanceof wwwKaidaraCom.getKBStructure){
                response.put('response_x', new wwwKaidaraCom.getKBStructureResponse());    
            }
        }
    }
    @isTest
    public static void testMethod1(){
        Test.setMock(WebServiceMock.class, new CSS_EDSwebcalloutMockImpl_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.createDiagnosticSession(null,null,null,null,null);
    }
    @isTest
    public static void testMethod2(){
        Test.setMock(WebServiceMock.class, new CSS_SOAPEDS_login_MockImpl_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.loginWithToken(null,null);
    }
    @isTest
    public static void testMethod3(){
        Test.setMock(WebServiceMock.class, new CSS_SOAPEDS_SOLUTIONS_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.getDiagnosticSessionSolutions(null,null);
    }
    @isTest
    public static void testMethod4(){
        Test.setMock(WebServiceMock.class, new CSS_FireTransition_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.open(null,null,null);
    }
    @isTest
    public static void testMethod5(){
        Test.setMock(WebServiceMock.class, new CSS_GetLocale_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.getLocale(null);
    }
    @isTest
    public static void testMethod6(){
        Test.setMock(WebServiceMock.class, new CSS_ResultDiag_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.searchDiagnosticSession(null,null,null,null,null,null);
    }
    @isTest
    public static void testMethod7(){
        Test.setMock(WebServiceMock.class, new CSS_KaidaraSession_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.login(null);
    }
    @isTest
    public static void testMethod8(){
        Test.setMock(WebServiceMock.class, new CSS_Feature_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort(); 
        wkc.fireTransition(null,null,null);
    }
    @isTest
    public static void testMethod9(){
        Test.setMock(WebServiceMock.class, new CSS_SetQuery_WebService());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.setQuery(null,null);
    }
    @isTest
    public static void testMethod10(){
        Test.setMock(WebServiceMock.class, new CSS_SolutionsFilter_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.getDiagnosticSessionSolutionsFilter(null,null,null);
    }
    @isTest
    public static void testMethod11(){
        Test.setMock(WebServiceMock.class, new CSS_Close_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.close(null);
    }
    @isTest
    public static void testMethod12(){
        Test.setMock(WebServiceMock.class, new CSS_SendCaseMail_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.sendCaseMail(null,null);
    }
    @isTest
    public static void testMethod13(){
        Test.setMock(WebServiceMock.class, new CSS_CloseDiagSession_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.closediagnosticsession(null,null);
    }
    @isTest
    public static void testMethod14(){
        Test.setMock(WebServiceMock.class, new CSS_ExitDiagSession_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.exitdiagnosticsession(null,null);
    }
    @isTest
    public static void testMethod15(){
        Test.setMock(WebServiceMock.class, new CSS_SetLocale_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.setLocale(null,null);
    }
    @isTest
    public static void testMethod16(){
        Test.setMock(WebServiceMock.class, new CSS_SendFeedback_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.sendFeedback(null,null);
    }
    @isTest
    public static void testMethod17(){
        Test.setMock(WebServiceMock.class, new CSS_DProperty_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.setDiagnosticSessionProperty(null,null,null,null);
    }
    @isTest
    public static void testMethod18(){
        Test.setMock(WebServiceMock.class, new CSS_ValueDomain_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.getValueDomain(null,null);
    }
    @isTest
    public static void testMethod19(){
        Test.setMock(WebServiceMock.class, new CSS_GetWorkGroup_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.getWorkGroup(null);
    }
    @isTest
    public static void testMethod20(){
        Test.setMock(WebServiceMock.class, new CSS_GetDiagnosticSession_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.getDiagnosticSession(null,null);
    }
    @isTest
    public static void testMethod21(){
        Test.setMock(WebServiceMock.class, new CSS_Switch_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.switchChunkIndex(null,null);
    }
    @isTest
    public static void testMethod22(){
        Test.setMock(WebServiceMock.class, new CSS_ContinueDiag_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.continueDiagnosticSession(null,null);
    }
    @isTest
    public static void testMethod23(){
        Test.setMock(WebServiceMock.class, new CSS_ViewDiagSession_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.viewDiagnosticSession(null,null);
    }
    @isTest
    public static void testMethod24(){
        Test.setMock(WebServiceMock.class, new CSS_SwitchNFire_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.switchAndFireTransition(null,null,null,null);
    }
    @isTest
    public static void testMethod25(){
        Test.setMock(WebServiceMock.class, new CSS_SwitchState_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.switchState(null,null);
    }
    @isTest
    public static void testMethod26(){
        Test.setMock(WebServiceMock.class, new CSS_StartFeature_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.startFeature(null,null,null);
    }
    @isTest
    public static void testMethod27(){
        Test.setMock(WebServiceMock.class, new CSS_GetKbStructure_WebService_Test());
        wwwKaidaraCom.KaidaraServiceImplPort wkc = new wwwKaidaraCom.KaidaraServiceImplPort();
        wkc.getKBStructure(null);
    }
}