@istest
Global class CG_SL_BMSMock_Test implements httpcalloutmock
{
Global boolean Value;
global CG_SL_BMSMock_Test(boolean value)
{
this.Value = value;
}
  global HTTPResponse respond(HTTPRequest req) 
      {
      httpresponse hresp = new httpresponse();
  if(this.value)
      {
  hresp.setHeader('Content-Type', 'application/json');
  hresp.setStatusCode(200);
  hresp.setStatus('success');
 /*  String json = '{ '+
        '\"Header\": { '+
            '  \"Status\": \"success\", '+
                    '  \"Sender\": { '+
                    '\"ServiceName\": \"GetUnitInfo\",'+
                    '\"SenderID\": \"CSS\"'+
                    '},'+
                    ' \"Target\": {'+
                    '\"TargetID\": \"BMS"'+
                    '},'+
            '  \"Location\": { '+
            '   \"LocationID\": \"02400-02394\" '+
            '  } '+
            '}, '+
            '\"DataArea\": [{ '+
        '  \"CustomerCode\" : \"A1234567\", '+
        '  \"CustomerName\": \"Test1\", '+
        '  \"LocationAddressline1\": \"\", '+
        '  \"LocationAddressline2\": \"\", '+
        '  \"LocationAddressline3\": \"\", '+
        '  \"PhoneNumber\": \"\", '+
        '  \"AreaCode\": \"\", '+
        '  \"ESN\": \"79834545\", '+
        '  \"UnitNumber\": \"12345\", '+
        '  \"Manufacturer\": \"KENWORTH\", '+
        '  \"Applicationcode\": \"565656-565656\", '+
        '  \"ModelSeq\": \"0\", '+
        '  \"City\": \"\", '+
        '  \"PaymentType\": \"\", '+
        '  \"State\": \"AB\", '+
        '  \"Country\": \"CA\", '+
        '  \"Postalcode1\": \"\", '+
        '  \"Postalcode2\": \"\" '+
        '}] '+
        '}';*/
  //hresp.setBody('{"DataArea": [{   "CustomerCode" : "A1234567",  "UnitNumber": "12345",   "UnitDescription": "",  "UnitType": "",   "Model": "",  "VIN": "",   "Manufacturer": "KENWORTH",  "SalesSegment": "",  "ModelNumber": "",  "ModelSeq": 0,   "ESN": "79834545",  "EngineFamily": "",  "Applicationcode": "565656-565656" }] ');
  String json = '{ '+
        '\"Header\": { '+
        '  \"Status\": \"success\", '+
        '  \"ReturnCodeDescription\": \"message_ifany\", '+
        '  \"Location\": { \"LocationID\": \"02400-02394\" } '+
        '}, '+
        '\"DataArea\": { '+
        '  \"CustomerCode\": \"1234567\", '+
        '  \"OpenChargeFlag\": \"\" '+
        '} '+
        '}';
  hresp.setBody(json);
  system.debug('response body'+hresp.getbody());
  }
  else
  {
  hresp.setStatusCode(200);
  CG_OP_OAGWrapper OAGResp = new CG_OP_OAGWrapper();
  OAGResp.exceptionFlag=true;
  OAGResp.errorMessage = 'json.parseexception:Object must be seperate using comma at line1 column356';  
  system.debug('errormessage'+OAGResp.errorMessage);
  }
  return  hresp;
  }
}