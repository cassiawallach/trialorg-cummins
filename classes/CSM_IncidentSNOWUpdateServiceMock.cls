@IsTest
global class CSM_IncidentSNOWUpdateServiceMock implements HttpCalloutMock {
    global static string responseType;
    global  CSM_IncidentSNOWUpdateServiceMock(string type){
        responseType=type;
    }
    global  static HttpResponse respond(HTTPRequest request) {
        String response = '{'+
            '  \"result\": {'+
            '    \"IncidentNumber\": \"INC3558822\",'+
            '    \"Priority\": \"3\",'+
            '    \"Customer\": \"Email User\",'+
            '    \"CustomerWWID\": \"email.user\",'+
            '    \"ShortDescription\": \"Qapla. Dah tlhingan hol mu ghom a dalegh\",'+
            '    \"Category\": \"Application\",'+
            '    \"SubCategory\": \"Repair/Fix\",'+
            '    \"ConfigurationItem\": \"P360-Enterprise Product Data Hub\",'+
            '    \"State\": \"Closed\",'+
            '    \"AssignmentGroup\": \"Common Services - Data Services - MDM Application Support\",'+
            '    \"AssignedTo\": \"Kowsalya R\",'+
            '    \"AssignedToWWID\": \"sy674\",'+
            '    \"IncidentSysID\": \"7816687f1b41c550f1d9ed77624bcba3\",'+
            '    \"Thirdparty\": \"\",'+
            '    \"TicketNumber\": \"\",'+
            '    \"TicketURL\": \"\",'+
            '    \"URL\": \"https://cumminsdev.service-now.com/incident.do?sys_id=7816687f1b41c550f1d9ed77624bcba3\"'+
            '  }'+
            '}';
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(responseType=='Success'){
            res.setBody(response);
            res.setStatusCode(200);
        }
        else if(responseType =='failure'){
            res.setBody(response);
            res.setStatusCode(400);   
        }
        else {
            res.setBody(null);
            res.setStatusCode(501);   
        }
        return res;
    }
   
    //this comments use for deployment. Set Missing component 
}