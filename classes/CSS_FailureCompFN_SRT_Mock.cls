@istest
Global class CSS_FailureCompFN_SRT_Mock implements httpcalloutmock {
   global httpresponse respond(httprequest req) 
   {
       httpresponse res = new httpresponse();
       res.setStatus('success');
       res.setHeader('Content-Type', 'application/json');
       res.setStatusCode(200);
       String json = '{'+
    '                \"DataArea\": ['+
    '                {'+
    '                                \"ComponentCode\": \"CG\",'+
    '                                \"FailureMode\": \"\",'+
    '                                \"FailureID\": \"F30000860\",'+
    '                                \"FailureName\": \"Accessory Plate Cover Gasket\",'+
    '                                \"SystemCode\": \"BG\"'+
    '                }],'+
    ''+
    '                \"Header\": {'+
    '                                \"ReturnCodeDescription\":\"Normal, Successful completion.\",'+
    '                                \"ReturnCode\": \"ORA-00000\",'+
    '                                \"MessageIdentifier\": \"S\"'+
    '                }'+
    '}';
                  
        res.setbody(json);
       return res;
   }

}