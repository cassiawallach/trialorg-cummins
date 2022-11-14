global class OMS_SubmitOrder_Mock implements HttpCalloutMock
{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatus('OK');
        res.setStatusCode(200);
        
       
       // if(req.getMethod() == 'POST')
     //   {
            res.setBody('{"DataArea":{"P_FSD_OUT":{"REMIT_TO_STATE":"NY","REMIT_TO_POSTAL_CODE":"12205","REMIT_TO_NAME":"ALBANY NY BRANCH","BMS_PO_NUMBER":"S1V9010342","REMIT_TO_ADDRESS":"101 RAILROAD AVENUE","BRANCH_LOCATION":"V9","Attribute01":"","TOTAL_DISCOUNT":"","ORDER_SOURCE_TYPE":"OSM","INVOICE_TOTAL":"42.33","Attribute03":"","BMS_INVOICE_NUMBER":"443","Attribute02":"","INVOICE_DATE":"2019-02-18T00:00:00.000-06:00","CREATE_DATE":"2019-02-18T00:00:00.000-06:00","BMS_OE_REFERENCE":"335317","REMIT_TO_CITY":"ALBANY"},"P_DIST_CODE":"02850","P_CUSTOMER_CODE":"22925"},"Header":{"Status":"Success","Sender":{"ServiceName":"FSD SubmitOrder","SenderID":"Mrktplc"},"Target":{"TargetID":"ONEBMS"},"ReturnCodeDescription":"","Location":{"LocationID":"02850"}}}');
     //   }
          // Create a fake response
 
        return res;
    }
}