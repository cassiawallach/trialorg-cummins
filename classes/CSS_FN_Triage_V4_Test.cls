@isTest
public class CSS_FN_Triage_V4_Test {
    
    @istest static void createUpdateIAGuidanzJob() {
        //  test.setmock(HttpCalloutMock.class, new CSS_WPR_TG_GetAssesDataReqJSON2Mockup());
        FSL_CL_IA_CreateServiceRequestAPIReqJSON req = new FSL_CL_IA_CreateServiceRequestAPIReqJSON();
        FSL_CL_IA_CreateServiceRequestAPIResJSON res = new FSL_CL_IA_CreateServiceRequestAPIResJSON();
        CSS_FN_Triage_V4 fnt = new CSS_FN_Triage_V4();
        Test.startTest();
        fnt.createUpdateIAGuidanzJob();
        Test.stopTest();
    }
    
    @isTest static void createUpdateIAGuidanzJob1(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IACSSJobMockTest_V4());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V04/CSS/IACSSJobCreation/';  //Request URL
        req.httpMethod = 'POST';
        
        //Success
        String jSONRequestBody = '{"Header":{"serviceName":"IACSSJobCreation","serviceVersion":"4.0","toolID":"GUIDANZ","targetID":"CSS","senderId":"rf671"},"DataArea":{"userLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","iasNumber":"IAS-254","woNumber":"","username":"oh559","psn":"79838572","serviceModelName":"ISX15 CM2350 X101","make":"KENWORTH","access":"B","model":"T660","ecmCode":"","productType":"","psbuPlant":"","psbuModel":"","psbuSpec":"","ert":"15255","customerName":"IA Cummins Test","complaintText":"Oil Leak Testing","prodMileage":"","prodMileageUnit":"","prodHours":"","woEnabled":"","severity":"","languageKey":"","FAULTLIST":[{"fc":"3563","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3567","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"1683","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2375","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2374","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""}],"PrioritizedData":[{"prifc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"EGR Orifice Pressure Sensor","rc1Likelihood":"64%","rootCause2":"Engine Wiring Harness","rc2Likelihood":"15%","rootCause3":"Electrical Connector","rc3Likelihood":"15%","rootCause4":"","rc4Likelihood":"","lbrprob1":"78","lbrprob2":"11","lbrprob3":"0","lbrprob4":"11","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""}]},{"prifc":"3714","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"","rc1Likelihood":"","rootCause2":"","rc2Likelihood":"","rootCause3":"","rc3Likelihood":"","rootCause4":"","rc4Likelihood":"","lbrprob1":"","lbrprob2":"","lbrprob3":"","lbrprob4":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""}]}],"unPrioritizedData":[{"upfc":"1117","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","rc":"","ReasonCodeDescription":""}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_FN_Triage_V4 fnt = new CSS_FN_Triage_V4();
        fnt.createUpdateIAGuidanzJob();
        
        
        //Req blank
        jSONRequestBody = '';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        fnt = new CSS_FN_Triage_V4();
        fnt.createUpdateIAGuidanzJob();
        
        //Invalid JSON
        jSONRequestBody = '{{"Header":{"serviceName":"IACSSJobCreation","serviceVersion":"4.0","toolID":"GUIDANZ","targetID":"CSS","senderId":"rf671"},"DataArea":{"userLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","iasNumber":"IAS-254","woNumber":"","username":"oh559","psn":"79838572","serviceModelName":"ISX15 CM2350 X101","make":"KENWORTH","access":"B","model":"T660","ecmCode":"","productType":"","psbuPlant":"","psbuModel":"","psbuSpec":"","ert":"15255","customerName":"IA Cummins Test","complaintText":"Oil Leak Testing","prodMileage":"","prodMileageUnit":"","prodHours":"","woEnabled":"","severity":"","languageKey":"","FAULTLIST":[{"fc":"3563","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3567","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"1683","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2375","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2374","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""}],"PrioritizedData":[{"prifc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"EGR Orifice Pressure Sensor","rc1Likelihood":"64%","rootCause2":"Engine Wiring Harness","rc2Likelihood":"15%","rootCause3":"Electrical Connector","rc3Likelihood":"15%","rootCause4":"","rc4Likelihood":"","lbrprob1":"78","lbrprob2":"11","lbrprob3":"0","lbrprob4":"11","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""}]},{"prifc":"3714","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"","rc1Likelihood":"","rootCause2":"","rc2Likelihood":"","rootCause3":"","rc3Likelihood":"","rootCause4":"","rc4Likelihood":"","lbrprob1":"","lbrprob2":"","lbrprob3":"","lbrprob4":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""}]}],"unPrioritizedData":[{"upfc":"1117","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","rc":"","ReasonCodeDescription":""}]}}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        fnt = new CSS_FN_Triage_V4();
        fnt.createUpdateIAGuidanzJob();
        
        //serviceName blank
        jSONRequestBody = '{"Header":{"serviceName":"","serviceVersion":"4.0","toolID":"GUIDANZ","targetID":"CSS","senderId":"rf671"},"DataArea":{"userLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","iasNumber":"IAS-254","woNumber":"","username":"oh559","psn":"79838572","serviceModelName":"ISX15 CM2350 X101","make":"KENWORTH","access":"B","model":"T660","ecmCode":"","productType":"","psbuPlant":"","psbuModel":"","psbuSpec":"","ert":"15255","customerName":"IA Cummins Test","complaintText":"Oil Leak Testing","prodMileage":"","prodMileageUnit":"","prodHours":"","woEnabled":"","severity":"","languageKey":"","FAULTLIST":[{"fc":"3563","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3567","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"1683","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2375","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2374","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""}],"PrioritizedData":[{"prifc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"EGR Orifice Pressure Sensor","rc1Likelihood":"64%","rootCause2":"Engine Wiring Harness","rc2Likelihood":"15%","rootCause3":"Electrical Connector","rc3Likelihood":"15%","rootCause4":"","rc4Likelihood":"","lbrprob1":"78","lbrprob2":"11","lbrprob3":"0","lbrprob4":"11","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""}]},{"prifc":"3714","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"","rc1Likelihood":"","rootCause2":"","rc2Likelihood":"","rootCause3":"","rc3Likelihood":"","rootCause4":"","rc4Likelihood":"","lbrprob1":"","lbrprob2":"","lbrprob3":"","lbrprob4":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""}]}],"unPrioritizedData":[{"upfc":"1117","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","rc":"","ReasonCodeDescription":""}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        fnt = new CSS_FN_Triage_V4();
        fnt.createUpdateIAGuidanzJob();
        
        //serviceName blank
        jSONRequestBody = '{"Header":{"serviceName":"Invalid","serviceVersion":"4.0","toolID":"GUIDANZ","targetID":"CSS","senderId":"rf671"},"DataArea":{"userLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","iasNumber":"IAS-254","woNumber":"","username":"oh559","psn":"79838572","serviceModelName":"ISX15 CM2350 X101","make":"KENWORTH","access":"B","model":"T660","ecmCode":"","productType":"","psbuPlant":"","psbuModel":"","psbuSpec":"","ert":"15255","customerName":"IA Cummins Test","complaintText":"Oil Leak Testing","prodMileage":"","prodMileageUnit":"","prodHours":"","woEnabled":"","severity":"","languageKey":"","FAULTLIST":[{"fc":"3563","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3567","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"1683","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2375","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2374","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""}],"PrioritizedData":[{"prifc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"EGR Orifice Pressure Sensor","rc1Likelihood":"64%","rootCause2":"Engine Wiring Harness","rc2Likelihood":"15%","rootCause3":"Electrical Connector","rc3Likelihood":"15%","rootCause4":"","rc4Likelihood":"","lbrprob1":"78","lbrprob2":"11","lbrprob3":"0","lbrprob4":"11","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""}]},{"prifc":"3714","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"","rc1Likelihood":"","rootCause2":"","rc2Likelihood":"","rootCause3":"","rc3Likelihood":"","rootCause4":"","rc4Likelihood":"","lbrprob1":"","lbrprob2":"","lbrprob3":"","lbrprob4":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""}]}],"unPrioritizedData":[{"upfc":"1117","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","rc":"","ReasonCodeDescription":""}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        fnt = new CSS_FN_Triage_V4();
        fnt.createUpdateIAGuidanzJob();
        
        //toolID blank
        jSONRequestBody = '{"Header":{"serviceName":"IACSSJobCreation","serviceVersion":"4.0","toolID":"","targetID":"CSS","senderId":"rf671"},"DataArea":{"userLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","iasNumber":"IAS-254","woNumber":"","username":"oh559","psn":"79838572","serviceModelName":"ISX15 CM2350 X101","make":"KENWORTH","access":"B","model":"T660","ecmCode":"","productType":"","psbuPlant":"","psbuModel":"","psbuSpec":"","ert":"15255","customerName":"IA Cummins Test","complaintText":"Oil Leak Testing","prodMileage":"","prodMileageUnit":"","prodHours":"","woEnabled":"","severity":"","languageKey":"","FAULTLIST":[{"fc":"3563","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3567","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"1683","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2375","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2374","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""}],"PrioritizedData":[{"prifc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"EGR Orifice Pressure Sensor","rc1Likelihood":"64%","rootCause2":"Engine Wiring Harness","rc2Likelihood":"15%","rootCause3":"Electrical Connector","rc3Likelihood":"15%","rootCause4":"","rc4Likelihood":"","lbrprob1":"78","lbrprob2":"11","lbrprob3":"0","lbrprob4":"11","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""}]},{"prifc":"3714","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"","rc1Likelihood":"","rootCause2":"","rc2Likelihood":"","rootCause3":"","rc3Likelihood":"","rootCause4":"","rc4Likelihood":"","lbrprob1":"","lbrprob2":"","lbrprob3":"","lbrprob4":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""}]}],"unPrioritizedData":[{"upfc":"1117","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","rc":"","ReasonCodeDescription":""}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        fnt = new CSS_FN_Triage_V4();
        fnt.createUpdateIAGuidanzJob();
        
        //IAS_Number Blank
        jSONRequestBody = '{"Header":{"serviceName":"IACSSJobCreation","serviceVersion":"4.0","toolID":"GUIDANZ","targetID":"CSS","senderId":"rf671"},"DataArea":{"userLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","iasNumber":"","woNumber":"","username":"oh559","psn":"79838572","serviceModelName":"ISX15 CM2350 X101","make":"KENWORTH","access":"B","model":"T660","ecmCode":"","productType":"","psbuPlant":"","psbuModel":"","psbuSpec":"","ert":"15255","customerName":"IA Cummins Test","complaintText":"Oil Leak Testing","prodMileage":"","prodMileageUnit":"","prodHours":"","woEnabled":"","severity":"","languageKey":"","FAULTLIST":[{"fc":"3563","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3567","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"1683","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2375","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2374","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""}],"PrioritizedData":[{"prifc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"EGR Orifice Pressure Sensor","rc1Likelihood":"64%","rootCause2":"Engine Wiring Harness","rc2Likelihood":"15%","rootCause3":"Electrical Connector","rc3Likelihood":"15%","rootCause4":"","rc4Likelihood":"","lbrprob1":"78","lbrprob2":"11","lbrprob3":"0","lbrprob4":"11","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""}]},{"prifc":"3714","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"","rc1Likelihood":"","rootCause2":"","rc2Likelihood":"","rootCause3":"","rc3Likelihood":"","rootCause4":"","rc4Likelihood":"","lbrprob1":"","lbrprob2":"","lbrprob3":"","lbrprob4":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""}]}],"unPrioritizedData":[{"upfc":"1117","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","rc":"","ReasonCodeDescription":""}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        fnt = new CSS_FN_Triage_V4();
        fnt.createUpdateIAGuidanzJob();
        
        Test.stopTest();
    }
    
    //JobNumber & IAS_Number valus as Inputs
    @isTest static void createUpdateIAGuidanzJob2(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IACSSJobMockTest_V4());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V04/CSS/IACSSJobCreation/';  //Request URL
        req.httpMethod = 'POST';
        
        //JobNumber & IAS_Number
        String jSONRequestBody = '{"Header":{"serviceName":"IACSSJobCreation","serviceVersion":"4.0","toolID":"GUIDANZ","targetID":"CSS","senderId":"rf671"},"DataArea":{"userLocation":"03520-04892-P","iasNumber":"IAS-254","woNumber":"CSS-00631658","username":"oh559","psn":"79838572","serviceModelName":"ISX15 CM2350 X101","make":"KENWORTH","access":"B","model":"T660","ecmCode":"","productType":"","psbuPlant":"","psbuModel":"","psbuSpec":"","ert":"15255","customerName":"IA Cummins Test","complaintText":"Oil Leak Testing","prodMileage":"","prodMileageUnit":"","prodHours":"","woEnabled":"","severity":"","languageKey":"","FAULTLIST":[{"fc":"3563","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3567","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"1683","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2375","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2374","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""}],"PrioritizedData":[{"prifc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"EGR Orifice Pressure Sensor","rc1Likelihood":"64%","rootCause2":"Engine Wiring Harness","rc2Likelihood":"15%","rootCause3":"Electrical Connector","rc3Likelihood":"15%","rootCause4":"","rc4Likelihood":"","lbrprob1":"78","lbrprob2":"11","lbrprob3":"0","lbrprob4":"11","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""}]},{"prifc":"3714","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"","rc1Likelihood":"","rootCause2":"","rc2Likelihood":"","rootCause3":"","rc3Likelihood":"","rootCause4":"","rc4Likelihood":"","lbrprob1":"","lbrprob2":"","lbrprob3":"","lbrprob4":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""}]}],"unPrioritizedData":[{"upfc":"1117","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","rc":"","ReasonCodeDescription":""}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_FN_Triage_V4 fnt = new CSS_FN_Triage_V4();
        fnt.createUpdateIAGuidanzJob();
        
        Test.stopTest();
    }
    
    //To cover updateIACSSJob method
    @isTest static void createUpdateIAGuidanzJob3(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IACSSJobMockTest_V4());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V04/CSS/IACSSJobCreation/';  //Request URL
        req.httpMethod = 'POST';
        
        //Success
        String jSONRequestBody = '{"Header":{"serviceName":"IACSSJobCreation","serviceVersion":"4.0","toolID":"GUIDANZ","targetID":"CSS","senderId":"rf671"},"DataArea":{"userLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","iasNumber":"IAS-254","woNumber":"","username":"oh559","psn":"79838572","serviceModelName":"ISX15 CM2350 X101","make":"KENWORTH","access":"B","model":"T660","ecmCode":"","productType":"","psbuPlant":"","psbuModel":"","psbuSpec":"","ert":"15255","customerName":"IA Cummins Test","complaintText":"Oil Leak Testing","prodMileage":"","prodMileageUnit":"","prodHours":"","woEnabled":"","severity":"","languageKey":"","FAULTLIST":[{"fc":"3563","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3567","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"1683","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2375","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2374","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""}],"PrioritizedData":[{"prifc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"EGR Orifice Pressure Sensor","rc1Likelihood":"64%","rootCause2":"Engine Wiring Harness","rc2Likelihood":"15%","rootCause3":"Electrical Connector","rc3Likelihood":"15%","rootCause4":"","rc4Likelihood":"","lbrprob1":"78","lbrprob2":"11","lbrprob3":"0","lbrprob4":"11","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""}]},{"prifc":"3714","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"","rc1Likelihood":"","rootCause2":"","rc2Likelihood":"","rootCause3":"","rc3Likelihood":"","rootCause4":"","rc4Likelihood":"","lbrprob1":"","lbrprob2":"","lbrprob3":"","lbrprob4":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""}]}],"unPrioritizedData":[{"upfc":"1117","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","rc":"","ReasonCodeDescription":""}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        
        //Job Data
        css_job_order__c jobObj = new css_job_order__c();
        jobObj.ESN_IA__c = '79797979';
        jobObj.Customer_Name__c = 'Test';
        jobObj.General_Symptoms__c = 'Test2';
        jobObj.CSS_Job_Location_Code__c = '03520-04892'; //User Location filtered
        jobObj.Request_JSON__c = '';
        jobObj.Response_JSON__c = '';
        //add user_location here
        /*accountList = new List<Account>([Select Id, Name from Account where Location__c=:deObj.User_Location_filtered__c limit 1]);
        if(accountList.size()>0)
            jobObj.JobLocation__c = (accountList.get(0)).Name;*/
        //jobObj.JobLocation__c = [Select Id, Name from Account where Location__c=:deObj.User_Location_filtered__c].Name;
        jobObj.Status__c = 'Intake';
        //jobObj.OwnerId = userIdAdvancedRole;
        //jobObj.CreatedById = userIdAdvancedRole;
        //jobObj.LastModifiedById = userIdAdvancedRole;
        insert jobObj;
        
        CSS_DataExchange_Parent__c dataExchangeObj = new CSS_DataExchange_Parent__c();
        dataExchangeObj.recordTypeId = [Select Id, Name from RecordType where Name = 'IA-Inbox' limit 1].Id;
        dataExchangeObj.Version__c = 'v04';
        dataExchangeObj.CSS_Job_Number__c = null;
        dataExchangeObj.IAS_Number__c = 'IAS-254';
        dataExchangeObj.CSS_Enabled__c = 'Y';
        dataExchangeObj.ServiceName__c = 'IACSSJobCreation';
        dataExchangeObj.ServiceVersion__c = '4.0';
        dataExchangeObj.ToolID__c = 'Guidanz';
        dataExchangeObj.SenderID__c = 'oh559';
        dataExchangeObj.TargetID__c = 'CSS';
        dataExchangeObj.PSN__c = '79797979';
        dataExchangeObj.SERVICEMODELNAME__c = '';
        dataExchangeObj.ERT__c = '';
        dataExchangeObj.MAKE__c = '';
        dataExchangeObj.MODEL__c = '';
        dataExchangeObj.ACCESS__c = '';
        dataExchangeObj.Created_By__c = '';
        dataExchangeObj.Updated_By__c = '';
        dataExchangeObj.User_Location__c = '03520-04892';
        dataExchangeObj.User_Location_filtered__c = '03520-04892';
        insert dataExchangeObj;
        
        dataExchangeObj = [Select Id, Name, IAS_Number__c, SenderID__c, Version__c, CSS_Job_Number__c, CSS_Enabled__c, PSN__c, SERVICEMODELNAME__c, ERT__c, MAKE__c, MODEL__c, ACCESS__c, User_Location__c, 
        User_Location_filtered__c, Customer_Company_Name__c, Complaint_Text__c, Request_JSON__c, Response_JSON__c from CSS_DataExchange_Parent__c where Id=:dataExchangeObj.Id];
            
        //CSS_FN_Triage_V4 fnt = new CSS_FN_Triage_V4();
        CSS_FN_Triage_V4.updateIACSSJob(dataExchangeObj,'',jobObj);
        Test.stopTest();
    }
    
    //JobNumber value & Insert IAS_Number
    @isTest static void createUpdateIAGuidanzJob4(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IACSSJobMockTest_V4());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V04/CSS/IACSSJobCreation/';  //Request URL
        req.httpMethod = 'POST';
        
        //Data
        CSS_DataExchange_Parent__c dataExchangeObj = new CSS_DataExchange_Parent__c();
        dataExchangeObj.recordTypeId = [Select Id, Name from RecordType where Name = 'IA-Inbox' limit 1].Id;
        dataExchangeObj.Version__c = 'v04';
        dataExchangeObj.CSS_Job_Number__c = null;
        dataExchangeObj.IAS_Number__c = 'IAS-254';
        dataExchangeObj.CSS_Enabled__c = 'Y';
        dataExchangeObj.ServiceName__c = 'IACSSJobCreation';
        dataExchangeObj.ServiceVersion__c = '4.0';
        dataExchangeObj.ToolID__c = 'Guidanz';
        dataExchangeObj.SenderID__c = 'oh559';
        dataExchangeObj.TargetID__c = 'CSS';
        dataExchangeObj.PSN__c = '79797979';
        dataExchangeObj.SERVICEMODELNAME__c = '';
        dataExchangeObj.ERT__c = '';
        dataExchangeObj.MAKE__c = '';
        dataExchangeObj.MODEL__c = '';
        dataExchangeObj.ACCESS__c = '';
        dataExchangeObj.Created_By__c = '';
        dataExchangeObj.Updated_By__c = '';
        dataExchangeObj.User_Location__c = '03520-04892';
        dataExchangeObj.User_Location_filtered__c = '03520-04892';
        insert dataExchangeObj;
        
        //JobNumber & IAS_Number
        String jSONRequestBody = '{"Header":{"serviceName":"IACSSJobCreation","serviceVersion":"4.0","toolID":"GUIDANZ","targetID":"CSS","senderId":"rf671"},"DataArea":{"userLocation":"03520-04892-P","iasNumber":"IAS-254","woNumber":"CSS-00631658","username":"oh559","psn":"79838572","serviceModelName":"ISX15 CM2350 X101","make":"KENWORTH","access":"B","model":"T660","ecmCode":"","productType":"","psbuPlant":"","psbuModel":"","psbuSpec":"","ert":"15255","customerName":"IA Cummins Test","complaintText":"Oil Leak Testing","prodMileage":"","prodMileageUnit":"","prodHours":"","woEnabled":"","severity":"","languageKey":"","FAULTLIST":[{"fc":"3563","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3567","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"1683","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2375","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2374","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""}],"PrioritizedData":[{"prifc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"EGR Orifice Pressure Sensor","rc1Likelihood":"64%","rootCause2":"Engine Wiring Harness","rc2Likelihood":"15%","rootCause3":"Electrical Connector","rc3Likelihood":"15%","rootCause4":"","rc4Likelihood":"","lbrprob1":"78","lbrprob2":"11","lbrprob3":"0","lbrprob4":"11","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""}]},{"prifc":"3714","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"","rc1Likelihood":"","rootCause2":"","rc2Likelihood":"","rootCause3":"","rc3Likelihood":"","rootCause4":"","rc4Likelihood":"","lbrprob1":"","lbrprob2":"","lbrprob3":"","lbrprob4":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""}]}],"unPrioritizedData":[{"upfc":"1117","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","rc":"","ReasonCodeDescription":""}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        
        CSS_FN_Triage_V4 fnt = new CSS_FN_Triage_V4();
        fnt.createUpdateIAGuidanzJob();
        
        Test.stopTest();
    }
    
    //Job Insert & IAS_Number Insert
    @isTest static void createUpdateIAGuidanzJob5(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IACSSJobMockTest_V4());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V04/CSS/IACSSJobCreation/';  //Request URL
        req.httpMethod = 'POST';
        
        //Data
        CSS_DataExchange_Parent__c dataExchangeObj = new CSS_DataExchange_Parent__c();
        dataExchangeObj.recordTypeId = [Select Id, Name from RecordType where Name = 'IA-Inbox' limit 1].Id;
        dataExchangeObj.Version__c = 'v04';
        dataExchangeObj.CSS_Job_Number__c = null;
        dataExchangeObj.IAS_Number__c = 'IAS-254';
        dataExchangeObj.CSS_Enabled__c = 'Y';
        dataExchangeObj.ServiceName__c = 'IACSSJobCreation';
        dataExchangeObj.ServiceVersion__c = '4.0';
        dataExchangeObj.ToolID__c = 'Guidanz';
        dataExchangeObj.SenderID__c = 'oh559';
        dataExchangeObj.TargetID__c = 'CSS';
        dataExchangeObj.PSN__c = '79797979';
        dataExchangeObj.SERVICEMODELNAME__c = '';
        dataExchangeObj.ERT__c = '';
        dataExchangeObj.MAKE__c = '';
        dataExchangeObj.MODEL__c = '';
        dataExchangeObj.ACCESS__c = '';
        dataExchangeObj.Created_By__c = '';
        dataExchangeObj.Updated_By__c = '';
        dataExchangeObj.User_Location__c = '03520-04892';
        dataExchangeObj.User_Location_filtered__c = '03520-04892';
        insert dataExchangeObj;
        
        //Job Data
        css_job_order__c jobObj = new css_job_order__c();
        jobObj.ESN_IA__c = '79797979';
        jobObj.Customer_Name__c = 'Test';
        jobObj.General_Symptoms__c = 'Test2';
        jobObj.CSS_Job_Location_Code__c = '03520-04892'; //User Location filtered
        jobObj.Request_JSON__c = '';
        jobObj.Response_JSON__c = '';
        jobObj.Status__c = 'Appointment';
        insert jobObj;
        
        //JobNumber & IAS_Number
        String jSONRequestBody = '{"Header":{"serviceName":"IACSSJobCreation","serviceVersion":"4.0","toolID":"GUIDANZ","targetID":"CSS","senderId":"rf671"},"DataArea":{"userLocation":"03520-04892-P","iasNumber":"IAS-254","woNumber":"CSS-00631658","username":"oh559","psn":"79838572","serviceModelName":"ISX15 CM2350 X101","make":"KENWORTH","access":"B","model":"T660","ecmCode":"","productType":"","psbuPlant":"","psbuModel":"","psbuSpec":"","ert":"15255","customerName":"IA Cummins Test","complaintText":"Oil Leak Testing","prodMileage":"","prodMileageUnit":"","prodHours":"","woEnabled":"","severity":"","languageKey":"","FAULTLIST":[{"fc":"3563","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3567","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"1683","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2375","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""},{"fc":"2374","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","languageKey":""}],"PrioritizedData":[{"prifc":"3137","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"EGR Orifice Pressure Sensor","rc1Likelihood":"64%","rootCause2":"Engine Wiring Harness","rc2Likelihood":"15%","rootCause3":"Electrical Connector","rc3Likelihood":"15%","rootCause4":"","rc4Likelihood":"","lbrprob1":"78","lbrprob2":"11","lbrprob3":"0","lbrprob4":"11","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","occurenceTime":"15255","status":"active","count":"1","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":""}]},{"prifc":"3714","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","primaryFaultCodeDescription":"","rootCause1":"","rc1Likelihood":"","rootCause2":"","rc2Likelihood":"","rootCause3":"","rc3Likelihood":"","rootCause4":"","rc4Likelihood":"","lbrprob1":"","lbrprob2":"","lbrprob3":"","lbrprob4":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","shutdownDescription":"","relfc":[{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""},{"rfc":"3574","spn":"","fmi":"","pCode":"","relatedFaultCodeDescription":"","derateValue1":"","derateValue2":"","derateValue3":"","severity":"","occurenceTime":"","status":"","count":"","shutdownDescription":""}]}],"unPrioritizedData":[{"upfc":"1117","spn":"","fmi":"","pCode":"","occurenceTime":"","status":"","count":"","rc":"","ReasonCodeDescription":""}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        
        CSS_FN_Triage_V4 fnt = new CSS_FN_Triage_V4();
        fnt.createUpdateIAGuidanzJob();
        
        Test.stopTest();
    }
    
    @istest static void getIAAppointments() {
        CSS_FN_Triage_V4 fnt = new CSS_FN_Triage_V4();
        Test.startTest();
        fnt.getIAAppointments();
        Test.stopTest();
    }
    
    @isTest static void getIAAppointment2(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IAAppointments_V2MockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V02/CSS/IAAppointments/';  //Request URL
        req.httpMethod = 'POST';
        
        //Success
        String jSONRequestBody = '{"Header":{"ServiceName":"IAAppointments","ServiceVersion":"2.0","ToolID":"GUIDANZ","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"UserLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","CurrentDate":"12/24/2017","dateSpan":"3"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        
        CSS_FN_Triage_V4 fnt = new CSS_FN_Triage_V4();
        fnt.getIAAppointments();
        Test.stopTest();
    }
    
    @isTest static void getIAAppointment3(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IAAppointments_V2MockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V02/CSS/IAAppointments/';  //Request URL
        req.httpMethod = 'POST';
        
        //Success
        String jSONRequestBody = '{"Header":{"ServiceName":"IAAppointments","ServiceVersion":"2.0","ToolID":"GUIDANZ","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"UserLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","CurrentDate":"12/24/2017","dateSpan":"3"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        
        /*Profile p = [SELECT Id FROM Profile WHERE Name like '%Advanced%' limit 1];  //Name='CSS_Dealer_Advanced' 
        
        User u = new User(Alias = 'kal2', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal10@testorg.com', user_Location__c = '03520-04892',isActive = true);
        insert u;*/
        
        /*User userObj = new User(); //Select Id, FederationIdentifier from User where FederationIdentifier=:inputUserId and isActive=true and Profile.Name like '%Advanced%'
        userObj.FederationIdentifier = 'oh559';
        userObj.isActive = true;
        userObj.Profile.Name = 'Advanced_User';
        insert userObj;*/
        
        //Job Data
        css_job_order__c jobObj = new css_job_order__c();
        jobObj.ESN_IA__c = '79797979';
        jobObj.Date_in_Shop__c = Date.parse('03/02/2020');
        jobObj.Customer_Name__c = 'Test';
        jobObj.General_Symptoms__c = 'Test2';
        jobObj.CSS_Job_Location_Code__c = '03520-04892'; //User Location filtered
        jobObj.Request_JSON__c = '';
        jobObj.Response_JSON__c = '';
        jobObj.Status__c = 'Appointment';
        insert jobObj;
        
        
        CSS_FN_Triage_V4 fnt = new CSS_FN_Triage_V4();
        CSS_FN_Triage_V4.WrapperInput wrapperObj = new CSS_FN_Triage_V4.WrapperInput();
        wrapperObj.UserLocation = '03520-04892';
        wrapperObj.CurrentDate = '03/02/2020';
        wrapperObj.dateSpan = '3';
        fnt.getIAAppointments(wrapperObj);
        Test.stopTest();
    }
    
    
        
    
    /*@istest static void createUpdateIAGuidanzJob2() {
        //RestRequest req = RestContext.request;
        //String jsonReqbody = '';
        //req.requestBody = Blob.valueOf(String);
        FSL_CL_IA_CreateServiceRequestAPIReqJSON req = new FSL_CL_IA_CreateServiceRequestAPIReqJSON();
        FSL_CL_IA_CreateServiceRequestAPIResJSON res = new FSL_CL_IA_CreateServiceRequestAPIResJSON();
        CSS_FN_Triage_V4 fnt = new CSS_FN_Triage_V4();
        Test.startTest();
        fnt.createUpdateIAGuidanzJob();
        Test.stopTest();
    }*/
    
    
}