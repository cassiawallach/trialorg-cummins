@isTest
global class CG_CL_GetPartsDataMock implements HttpCalloutMock {
     
    global HTTPResponse respond(HTTPRequest req)  
        {
                   
            HttpResponse res= new HttpResponse();
             String json=		'{'+
		'	"DataArea": {'+
		      ' " SupersededPartNumber": "1-127827968",'+
              '  " PartNumberLong": "1-127827968",'+
               '  " PartDescription": "1-127827968",'+
                 ' " PartInService": "1-127827968",'+
                   ' " KitPartFlag": "1-127827968"'+
     '	},'+
		   '	"Header": {'+
		       '	 "ReturnCodeDescription": "",'+
		       '	 "Status": "Success"'+
		'	}	'+
		'}';
             res.setStatus('Success');
            res.setStatusCode(200);
            res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setBody(json);
           return res;
    }
}