@isTest
public class CSS_quickServeCumminsCom_Test {
 static testMethod void test(){
        new CSS_quickserveCumminsComWebservices.getEngineDataplateResponse_element();
        new CSS_quickserveCumminsComWebservices.ModelName();
        new CSS_quickserveCumminsComWebservices.getOptionsRequest_element();
        new CSS_quickserveCumminsComWebservices.Options();
        new CSS_quickserveCumminsComWebservices.getOptionsResponse_element();
        new CSS_quickserveCumminsComWebservices.ArrayOfOptions();
        new CSS_quickserveCumminsComWebservices.WarrantyDoc();
        new CSS_quickserveCumminsComWebservices.ArrayOfTsbdocument();
        new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
        new CSS_quickserveCumminsComWebservices.getTsbsForFaultCodeRequest_element();
        new CSS_quickserveCumminsComWebservices.getFaultCodeOverviewRequest_element();
        new CSS_quickserveCumminsComWebservices.getWarrantyDocsResponse_element();
        new CSS_quickserveCumminsComWebservices.getEngineDataplateRequest_element();
        new CSS_quickserveCumminsComWebservices.getTsbsForFaultCodeResponse_element();
        new CSS_quickserveCumminsComWebservices.getWarrantyDocsRequest_element();
        new CSS_quickserveCumminsComWebservices.TsbDocument();
        new CSS_quickserveCumminsComWebservices.linkMgmtRequest_element();
        new CSS_quickserveCumminsComWebservices.linkMgmtResponse_element();
        new CSS_quickserveCumminsComWebservices.getFaultCodeOverviewResponse_element();
        new CSS_quickserveCumminsComWebservices.FaultCodeInfo();
    }
    public class WebServiceMockImpl implements WebServiceMock{
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof CSS_quickserveCumminsComWebservices.getWarrantyDocsRequest_element){
                response.put('response_x', new CSS_quickserveCumminsComWebservices.getWarrantyDocsResponse_element());
            }
            if(request instanceof CSS_quickserveCumminsComWebservices.getFaultCodeOverviewRequest_element){
                response.put('response_x', new CSS_quickserveCumminsComWebservices.getFaultCodeOverviewResponse_element());
            }
            if(request instanceof CSS_quickserveCumminsComWebservices.getTsbsForFaultCodeRequest_element){
                response.put('response_x', new CSS_quickserveCumminsComWebservices.getTsbsForFaultCodeResponse_element());
            }
            if(request instanceof CSS_quickserveCumminsComWebservices.getEngineDataplateRequest_element){
                response.put('response_x', new CSS_quickserveCumminsComWebservices.getEngineDataplateResponse_element());
            }
            if(request instanceof CSS_quickserveCumminsComWebservices.linkMgmtRequest_element){
                response.put('response_x', new CSS_quickserveCumminsComWebservices.linkMgmtResponse_element());
            }
        }  
    }
    
    @isTest
    public static void testMethod1(){
        Test.setMock(WebServiceMock.class, new CSS_GetWarrantyDocs_Test());
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wkc = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
       wkc.getWarrantyDocs(null,null,null,null);
    }
    @isTest
    public static void testMethod2(){
        Test.setMock(WebServiceMock.class, new CSS_GetFaultCodeOverview_Test());
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wkc = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
        wkc.getFaultCodeOverview(null,null,null);
    }
    @isTest
    public static void testMethod3(){
        Test.setMock(WebServiceMock.class, new CSS_GetEngineDataPlate_Test());
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wkc = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
        wkc.getEngineDataplate(null,null);
    }
    @isTest
    public static void testMethod4(){
        Test.setMock(WebServiceMock.class, new CSS_LinkMgmt_Test());
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wkc = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
        wkc.linkMgmt(null,null,null,null,null);
    }
     @isTest
    public static void testMethod5(){
        Test.setMock(WebServiceMock.class, new CSS_GetTsbForFaultCode_Test());
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wkc = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
        wkc.getTsbsForFaultCode(null,null,null,null);
    }
    
     @isTest
    public static void testMethod6(){
        Test.setMock(WebServiceMock.class, new CSS_GetQSOLOptions_Test ());
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wkc = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
        wkc.getOptions(null,null);
    }
}