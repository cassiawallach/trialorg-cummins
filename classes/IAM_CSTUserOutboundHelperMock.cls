global class IAM_CSTUserOutboundHelperMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        IAM_CST_OUT_User_wrapper wraprecord = new IAM_CST_OUT_User_wrapper();
        
        IAM_CST_OUT_User_wrapper.records wrap= new IAM_CST_OUT_User_wrapper.records();
        
        wrap.STATUS_ID = 'test';   
        wrap.STATUS = 'test';
        wrap.JOBTITLE = 'testtestuser@testuser.com';                 
        wrap.CREATED_BY_ID = 'test i'+Math.Random();
        wrap.JOBCODE = 'test';
        wrap.CREATED_DATE = 'test';
        wrap.COMPANY_PHONE = 'test';
        wrap.LAST_MODIFIED_BY_ID = 'test';
        wrap.COMPANY_EMAIL = 'test';
        wrap.LAST_MODIFIED_DATE = 'test';
        wrap.LAST_NAME = 'test';
        wrap.SERVICE_PROVIDER_ID ='test';  
        wrap.MIDDLE_NAME = 'test';
        wrap.SERVICE_PROVIDER_NAME ='test';  
        wrap.FIRST_NAME = 'test';
        wrap.SERVICE_PROVIDER_CITY ='test';  
        wrap.SERVICE_TRAINING_ID  ='test';
        wrap.SERVICE_PROVIDER_STATE  ='test';
        wrap.LOGIN_ID  ='test';
        wrap.SERVICE_PROVIDER_COUNTRY  ='test'; 
        //wrap.Integerid  ='test';
        wrap.SERVICE_PROVIDER_POSTAL_CODE ='test';  
        wrap.previous_username  ='test';
        wrap.sfiam_id  ='test';
        wraprecord.records = wrap;
        wraprecord.totalSize=1;
        String JsonMsg=JSON.serialize(wraprecord );
        response.setBody(JsonMsg);
        response.setStatusCode(200);
        return response;
    }
}