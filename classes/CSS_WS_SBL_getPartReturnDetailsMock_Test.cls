@isTest
global class CSS_WS_SBL_getPartReturnDetailsMock_Test implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{'+
		'\"DataArea\": ['+
		'{'+
		'\"COMPANY\": \"Cummins Inc.\",'+
		'\"LOCATION\": \"Receiving Location 35, 910 S Marr Road, Columbus, IN 47201\",'+
		'\"MESSAGE\": \"****IMPORTANT**EPR**PART REQUEST - Review CUMMINS MATERIAL RETURN TICKET/s for specific part numbers to be returned **EPR Core Part***Goto QSOL Warranty Click on Request Core Return Process**\",'+
		'\"RETURNMESSAGE\": \"***Enhanced Parts Return Warning*** UPS: X283X8 FEDEX: 332426788 Important: Always include a copy of the closed claim fax and attach the material return ticket to the outside of the box. Paccar returns = CRA #/Eztrac #. Cummins returns = WebCumpas #.\",'+
		'\"EPRFLAG\": \"Y\",'+
		'\"PARTNUMBER\": \"306354800\",'+
		'\"ATTENTION\": \"Service Support Center\"'+
		'},'+
		'{'+
		'\"COMPANY\": \"Cummins Inc.\",'+
		'\"LOCATION\": \"Unit B Daventry Interchange, Sopwith Way, Drayton Fields Industrial Estate, Daventry, Northamptonshire, NN11 8PB, UK\",'+
		'\"MESSAGE\": \"****IMPORTANT**EPR**PART REQUEST - Review CUMMINS MATERIAL RETURN TICKET/s for specific part numbers to be returned**EPR Core Return***Goto QSOL Warranty Click on Request Core Return Process**\",'+
		'\"RETURNMESSAGE\": \"****Enhanced Parts Return Warning*** CLARKES (UK ONLY): DC10875 EUROPA: CUMMSSC001 For Returns outside Europe: DHL 957365001 Important: Always include a copy of the closed claim fax and attach the material return ticket to the outside of the box. Paccar returns = CRA #/Eztrac #. Cummins returns = WebCumpas #.\",'+
		'\"EPRFLAG\": \"Y\",'+
		'\"PARTNUMBER\": \"405023600\",'+
		'\"ATTENTION\": \"SSC EUROPE\"'+
		'},'+
		'{'+
		'\"COMPANY\": \"Cummins Inc.\",'+
		'\"LOCATION\": \"Unit B Daventry Interchange, Sopwith Way, Drayton Fields Industrial Estate, Daventry, Northamptonshire, NN11 8PB, UK\",'+
		'\"MESSAGE\": \"****IMPORTANT**EPR**PART REQUEST - Review CUMMINS MATERIAL RETURN TICKET/s for specific part numbers to be returned**EPR Core Return***Goto QSOL Warranty Click on Request Core Return Process**\",'+
		'\"RETURNMESSAGE\": \"****Enhanced Parts Return Warning*** CLARKES (UK ONLY): DC10875 EUROPA: CUMMSSC001 For Returns outside Europe: DHL 957365001 Important: Always include a copy of the closed claim fax and attach the material return ticket to the outside of the box. Paccar returns = CRA #/Eztrac #. Cummins returns = WebCumpas #.\",'+
		'\"EPRFLAG\": \"Y\",'+
		'\"PARTNUMBER\": \"288202100\",'+
		'\"ATTENTION\": \"SSC EUROPE\"'+
		'}'+
		'],'+
		'\"Header\": {'+
		'\"ReturnCodeDescription\": \"\",'+
		'\"Status\": \"Success\"'+
		'}'+
		'}');
        res.setStatusCode(200);
        return res;
    }
}