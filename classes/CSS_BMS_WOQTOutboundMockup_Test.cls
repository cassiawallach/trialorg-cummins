@isTest
global class CSS_BMS_WOQTOutboundMockup_Test implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            //res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "Header": { "Status": "success", "ReturnCodeDescription": "message_ifany", "Location": { "LocationID": "02400-02394" } }, "DataArea": { "CSSjobID": "CSS-00001234", "Companycode": "AB23456", "DivisionCode": "", "LocationCode": "12345-23456", "CustomerNumber": "", "TransactionType": "1XFFERR2344REWS", "OrderReference": "KENWORTH", "ItemGrossSell": 0, "ItemWarranty": 0, "ItemBillable": 0, "LaborGrossSell": 0, "LaborWarranty": 0, "LaborBillable": 0, "MiscGrossSell": 0, "MiscWarranty": 0, "MiscBillable": 0, "Taxes": 0, "QuoteTotal": 0, "Diagnosticcharges": 0, "GrandTotal": 0 } }');
        }
        return res;
        
    }
}