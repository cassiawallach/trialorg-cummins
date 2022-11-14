@isTest
public class FSL_CL_IA_GetServiceRequestAPI_Test {
     //Rajashekar N ; 09/09/2020 ; CT2-146 
    @isTest
    public static void getServiceRequestTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_GetServiceRequestAPI_MoTest());
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        
        
        request.addHeader('Content-Type', 'application/json');
        request.requestURI = '/services/apexrest/GetServiceRequestAPI/';  //Request URL
        request.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"GetServiceRequestAPI","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"01/09/2020","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For  null jSONRequestBody
        jSONRequestBody = '';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();       
        
        //For null Header
        jSONRequestBody = '{}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For ServiceName blank in FSL_CL_IAUtility
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"1.0","ToolID":"","TargetID":"CSS"},"DataArea":{"UserLocation":"","CurrentDate":"","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For wrong ServiceName in FSL_CL_IAUtility
        jSONRequestBody = '{"Header":{"ServiceName":"testWrongServiceName","ServiceVersion":"1.0","ToolID":"","TargetID":"CSS"},"DataArea":{"UserLocation":"","CurrentDate":"","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For ToolID blank in FSL_CL_IAUtility
        jSONRequestBody = '{"Header":{"ServiceName":"GetServiceRequestAPI","ServiceVersion":"1.0","ToolID":"","TargetID":"CSS"},"DataArea":{"UserLocation":"","CurrentDate":"","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For UserLocation blank in FSL_CL_IAUtility
        jSONRequestBody = '{"Header":{"ServiceName":"GetServiceRequestAPI","ServiceVersion":"1.0","ToolID":"Guidanz","TargetID":"CSS"},"DataArea":{"UserLocation":"","CurrentDate":"","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        
        //For CurrentDate blank in FSL_CL_IAUtility
        jSONRequestBody = '{"Header":{"ServiceName":"GetServiceRequestAPI","ServiceVersion":"1.0","ToolID":"Guidanz","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"","Datespan":"4"}}';
        request.requestBody = Blob.valueOf(jSONRequestBody);
        RestContext.request = request;
        RestContext.response = response;
        FSL_CL_IA_GetServiceRequestAPI.getIAServiceRequest();
        FSL_CL_IAUtility.WrapperInput wrapinput = new FSL_CL_IAUtility.WrapperInput();
        wrapinput.Status = 'Test';
        wrapinput.serviceName = 'Test';
        wrapinput.serviceVersion = 'Test';
        wrapinput.returnCodeDescription = 'Test';
        wrapinput.wOEnabled = 'Test';
        wrapinput.IASNumber = 'Test';
        wrapinput.toolID = 'Test';
        wrapinput.senderId = 'Test';
        wrapinput.serviceRequestNumber = 'Test';
        String userIdAdvancedRole = 'test';
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea da = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea();
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.Header   hd = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.Header();
        hd.returnCodeDescription = 'Test';
        hd.senderId = 'Test';
        hd.serviceName = 'Test';
        hd.serviceVersion = 'Test';
        hd.status = 'Test';
        hd.toolID = 'Test';
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea dd = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.DataArea();
        FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments iaap = new FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments();
        List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> validateCreateServiceRequet = new List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments>();
        
        // List <IAAppointments> iaap = new <IAAppointments>();
        // List<IAAppointments> iaaps = new List<IAAppointments>();
        // IAAppointments iaap = new IAAppointments();
        iaap.availableForService = 'test';
        iaap.complaintText = 'Test';
        iaap.contactFirstName = 'Test';
        iaap.contactLastName = 'Test';
        iaap.customerName = 'Test';
        iaap.psn = '79788868';
        iaap.unitNumber = '110';
        dd.woEnabled = 'Test';
        iaap.woNumber = '00000001';
        List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> imps = new List <FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments>();
        Test.stopTest();
    }
}