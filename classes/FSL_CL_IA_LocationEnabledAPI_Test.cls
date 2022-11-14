@isTest
public class FSL_CL_IA_LocationEnabledAPI_Test {
     //Rajashekar N ; 09/09/2020 ; CT2-146
    @isTest
    private static void testGetSuccessResponse() {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_LocationEnabledAPI_MockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/IALocationEnabled/';  //Request URL
        req.httpMethod = 'POST';
        
        //Success
        String jSONRequestBody = '{"Header":{"ServiceName":"IALocationEnabled","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"12/04/2019"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        Test.stopTest();
    }
    
    //Validations Response
    @isTest static void testGetVAlidationsResponse() {
        Test.startTest();
        // Set mock callout  class
        Test.setMock(HttpCalloutMock.class, new FSL_CL_IA_LocationEnabledAPI_MockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/IALocationEnabled/';  //Request URL
        req.httpMethod = 'POST';
        
        //Request Null Validation
        String jSONRequestBody = '';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //Request Header null Validation
        jSONRequestBody = '{}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //Invalid JSON Validation
        jSONRequestBody = '{{"Header":{"ServiceName":"IALocationEnabled","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"12/04/2019"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //Wrong ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"testforwrong","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"12/04/2019"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //ToolID Validation
        // {"Header":{"ServiceName":"IASerRequestCreation","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS","SenderId":"rf671"},"DataArea":{"UserLocation":"05340-05351","IASNumber":"+objCase.IAS_Number__c","WONumber":"","Username":"Rajashekar","PSN":"79788868","SERVICEMODELNAME":"ISB6.7 CM2350 B101","FaultType":"","ACCESS":"","MAKE":"AH&D","MODEL":"900","ECMCode":"","ProductType":"","PSBUPlant":"","PSBUModel":"","PSBUSpec":"","ERT":"","CustomerName":"Guidanz","ComplaintText":"We are testing","ProdMileage":"1000","ProdMileageUnit":"Miles","ProdHours":"200","WOEnabled":"","Severity":"","LanguageKey":"EN","FAULTLIST":[{"fc":"","SPN":"","FMI":"","PCode":"","occurenceTime":"","Status":"","count":"","LanguageKey":""}],"PrioritizedData":[{"prifc":"1118","SPN":"","FMI":"","PCode":"","PrimaryFaultCodeDescription":"","rootCause1":"black smoke","rc1Likelihood":"20","rootCause2":"fuel pump","rc2Likelihood":"45","rootCause3":"turbo charger","rc3Likelihood":"30","rootCause4":"exhaust leak","rc4Likelihood":"30","lbrprob1":"60","lbrprob2":"45","lbrprob3":"30","lbrprob4":"10","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"LEAK"},{"prifc":"1119","SPN":"","FMI":"","PCode":"","PrimaryFaultCodeDescription":"","rootCause1":"black smoke","rc1Likelihood":"20","rootCause2":"fuel pump","rc2Likelihood":"45","rootCause3":"turbo charger","rc3Likelihood":"30","rootCause4":"exhaust leak","rc4Likelihood":"30","lbrprob1":"60","lbrprob2":"45","lbrprob3":"30","lbrprob4":"10","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"smoke"}],"relfc":[{"rfc":"1118","SPN":"","FMI":"","PCode":"","RelatedFaultCodeDescription":"","DerateValue1":"","DerateValue2":"","DerateValue3":"","Severity":"","ShutdownDescription":"leak"}],"unPrioritizedData":[{"upfc":"1117","SPN":"","FMI":"","PCode":"","rc":"","ReasonCodeDescription":""}]}}
        jSONRequestBody = '{"Header":{"ServiceName":"IALocationEnabled","ServiceVersion":"1.0","ToolID":"","TargetID":"CSS"},"DataArea":{"UserLocation":"56153-39747","CurrentDate":"12/04/2019"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //CSSJobNumber Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IALocationEnabled","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":""}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        
        //Check for wOEnabled
        Account Acc = new Account();
        Acc.Name = 'IA Account';
        acc.CSS_DistributorCode__c = '05694';
        acc.FSL_ERP_Customer_Code__c = '09874';
        acc.IA_CSSEnabled__c = TRUE;
        insert acc;
        jSONRequestBody = '{"Header":{"ServiceName":"IALocationEnabled","ServiceVersion":"1.0","ToolID":"GUIDANZ","TargetID":"CSS"},"DataArea":{"UserLocation":"05694-09874"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FSL_CL_IA_LocationEnabledAPI.isIALocationEnabled();
        List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments> validateCreateServiceRequet = new List<FSL_CL_IA_GetServiceRequestAPI_ResJSON.IAAppointments>();
        Test.stopTest();
    }
}