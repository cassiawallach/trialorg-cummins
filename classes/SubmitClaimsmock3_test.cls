@istest
Global class SubmitClaimsmock3_test implements httpcalloutmock {
    global httpresponse respond(httprequest req)
    {
        httpresponse res = new httpresponse();
        res.setHeader('content-type','application/json');
        res.setStatus('Error');
        res.setStatusCode(200);
        res.setBody('{'+
		''+
		'    \"DataArea\": {'+
		''+
		'        \"Status\": \"Error\",'+
		''+
		'        \"ErrorMessage\": \"\",'+
		''+
		'        \"ClaimNumber\": \"1-127827968\"'+
		''+
		'    },'+
		''+
		'    \"Header\": {'+
		''+
		'        \"ReturnCodeDescription\": \"\",'+
		''+
		'        \"Status\": \"Error\"'+
		''+
		'    }'+
		''+
		'}');
        return res;
    }

}