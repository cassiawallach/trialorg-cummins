@istest
Global class CSS_FN_BMS_Mock implements httpcalloutmock {
   global httpresponse respond(httprequest req) 
   {
       httpresponse res = new httpresponse();
       res.setStatus('success');
       res.setHeader('Content-Type', 'application/json');
       res.setStatusCode(200);
       String json = '{'+
		'                \"DataArea\": ['+
		'                {'+
		'                                \"UnitDescription\": \"UnitDescription\",'+
		'                                \"Model\": \"Model\",'+
		'                                \"ContactName\": \"5723046\",'+
		'                                \"City\": \"CA\",'+
		'                                \"FAInterfaced\": \"BRITESTONECOLONY\",'+
		'                                \"State\": \"CARBON\",'+
		'                                \"ModelSeq\": \"1324\",'+
		'                                \"ContactId\": \"CARBONCOLONY\",'+
		'                                \"AddressLine1\": \"CARBONCOLONY\",'+
		'                                \"OwnerName\": \"403\",'+
		'                                \"CustomerCode\": \"CASH\",'+
		'                                \"VIN\": \"AB\",'+
		'                                \"ModelNumber\": \"ModelNumber\",'+
		'                                \"UnitType\": \"UnitType\",'+
		'                                \"UnitNumber\": \"2786789\",'+
		'                                \"Manufacturer\": \"Manufacturer\",'+
		'                                \"Applicationcode\": \"813\",'+
		'                                \"EngineFamily\": \"EngineFamily\",'+
		'                                \"ESN\": \"123456\",'+
		'                                \"SalesSegment\": \"SalesSegment\"'+
		
		'                }],'+
		''+
		'                \"Header\": {'+
		'                                \"ReturnCodeDescription\":\"retTest\",'+
		'                                \"Status\": \"SUCCESS\",'+
		'                                \"Sender\": {'+
		'                                                \"ServiceName\": \"GetCustomer\",'+
		'                                                \"MessageID\":\"1234\", '+
		'                                                \"SenderID\": \"BMS\"'+
		'                                },'+
		'                                \"Target\": {'+
		'                                                \"TargetID\": \"CSS\"'+
		'                                },'+
		'                                \"Location\": {'+
		'                                                \"LocationID\": \"56270-56255\"'+
		'                                }'+
		'                }'+
		'}';
		res.setbody(json);
       return res;
   }

}