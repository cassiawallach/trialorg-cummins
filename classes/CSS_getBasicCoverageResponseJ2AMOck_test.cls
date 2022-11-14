@istest
Global class CSS_getBasicCoverageResponseJ2AMOck_test implements httpcalloutmock {
    global httpresponse respond(httprequest req)
    {
        httpresponse res = new httpresponse();
        res.setHeader('content-type','application/json');
        res.setStatus('Success');
        res.setStatusCode(200);
       /*res.setBody( '{'+
		'   \"Header\":    {'+
		'      \"ReturnCodeDescription\": \"\",'+
		'      \"Status\": \"Success\"'+
		'   },'+
		'   \"BasicCoverageResponseHeader\": {\"Response\":    {'+
		'      \"ListOfCoverageDetails\": {\"CoverageDetails\":       [	'+
		'                  {'+
		'            \"ListOfCoverageComponentList\": {\"CoverageComponentList\":             ['+
		'                              {'+
		'                  \"MegawattHours\": \"1000\",'+
		'                  \"CoverageMaxMonths\": \"30\",'+
		'                  \"CoverageComponentTypeCode\": \"EMISSIONS-CA\",'+
		'                  \"CoverageMinMonths\": \"20\",'+
		'                  \"CoverageHours\": \"100\",'+
		'                  \"CoverageDefenitionType\": \"BASE\",'+
		'                  \"CoverageMiles\": \"10\"'+
		'               },'+
		'                              {'+
		'                  \"MegawattHours\": \"123\",'+
		'                  \"CoverageMaxMonths\": \"234\",'+
		'                  \"CoverageComponentTypeCode\": \"BELTS/HOSES\",'+
		'                  \"CoverageMinMonths\": \"56\",'+
		'                  \"CoverageHours\": \"123\",'+
		'                  \"CoverageDefenitionType\": \"BASE\",'+
		'                  \"CoverageMiles\": \"123\"'+
		'               }'+
		'            ]},'+
		'            \"WarrantyManualURL\": \"www.test.com/ems\",'+
		'            \"CoverageType\": \"EMS-Emissions Warranty\",'+
		'            \"ListOfCoverageDedutibles\": {\"CoverageDedutibles\": []},'+
		'            \"ProcedureNumber\": \"ProcEMS\"'+
		'         },'+
		'                  {'+
		'            \"ListOfCoverageComponentList\": {\"CoverageComponentList\":             ['+
		'                              {'+
		'                  \"MegawattHours\": \"0\",'+
		'                  \"CoverageMaxMonths\": \"120\",'+
		'                  \"CoverageComponentTypeCode\": \"EMISSIONS-CA\",'+
		'                  \"CoverageMinMonths\": \"0\",'+
		'                  \"CoverageHours\": \"100000\",'+
		'                  \"CoverageDefenitionType\": \"BASE\",'+
		'                  \"CoverageMiles\": \"100000\"'+
		'               },'+
		'                              {'+
		'                  \"MegawattHours\": \"0\",'+
		'                  \"CoverageMaxMonths\": \"60\",'+
		'                  \"CoverageComponentTypeCode\": \"EMISSIONS\",'+
		'                  \"CoverageMinMonths\": \"0\",'+
		'                  \"CoverageHours\": \"0\",'+
		'                  \"CoverageDefenitionType\": \"BASE\",'+
		'                  \"CoverageMiles\": \"100000\"'+
		'               }'+
		'            ]},'+
		'            \"WarrantyManualURL\": \"\",'+
		'            \"CoverageType\": \"NEW-New Engine Warranty\",'+
		'            \"ListOfCoverageDedutibles\": {\"CoverageDedutibles\": []},'+
		'            \"ProcedureNumber\": \"\"'+
		'         }'+
		'      ]},'+
		'      \"ListOfExtendedCoverageDetails\": {\"ExtendedCoverageDetails\":       ['+
		'                  {'+
		'            \"ListOfExtCoverageDedutibles\": {\"ExtendedCoverageDedutibles\": []},'+
		'            \"WarrantyManualURL\": \"\",'+
		'            \"BeginMiles\": \"0\",'+
		'            \"EndMiles\": \"500000\",'+
		'            \"ProcedureNumber\": \"\",'+
		'            \"CertificateNumber\": \"TP41000811\",'+
		'            \"ProgramID\": \"TP4\",'+
		'            \"BeginHours\": \"0\",'+
		'            \"EndHours\": \"0\",'+
		'            \"EndDate\": \"09/21/2015\",'+
		'            \"StartDate\": \"09/21/2010\",'+
		'            \"Months\": \"60\",'+
		'            \"CAPCoverageID\": \"CRT\"'+
		'         },'+
		'                  {'+
		'            \"ListOfExtCoverageDedutibles\": {\"ExtendedCoverageDedutibles\": []},'+
		'            \"WarrantyManualURL\": \"\",'+
		'            \"BeginMiles\": \"0\",'+
		'            \"EndMiles\": \"300000\",'+
		'            \"ProcedureNumber\": \"\",'+
		'            \"CertificateNumber\": \"TP41000811\",'+
		'            \"ProgramID\": \"TP4\",'+
		'            \"BeginHours\": \"0\",'+
		'            \"EndHours\": \"0\",'+
		'            \"EndDate\": \"09/21/2013\",'+
		'            \"StartDate\": \"09/21/2010\",'+
		'            \"Months\": \"36\",'+
		'            \"CAPCoverageID\": \"APT\"'+
		'         }'+
		'      ]}'+
		'   }}'+
		'}');*/
       res.setBody('{ "DataArea": [ { "COMPANY": "Cummins Inc.", "LOCATION": "Receiving Location 35, 910 S Marr Road, Columbus, IN 47201", "MESSAGE": "****IMPORTANT**EPR**PART REQUEST - Review CUMMINS MATERIAL RETURN TICKET/s for specific part numbers to be returned **EPR Core Part***Goto QSOL Warranty Click on Request Core Return Process**", "RETURNMESSAGE": "***Enhanced Parts Return Warning*** UPS: X283X8 FEDEX: 332426788 Important: Always include a copy of the closed claim fax and attach the material return ticket to the outside of the box. Paccar returns = CRA #/Eztrac #. Cummins returns = WebCumpas #.", "EPRFLAG": "Y", "PARTNUMBER": "306354800", "ATTENTION": "Service Support Center" }, { "COMPANY": "Cummins Inc.", "LOCATION": "Unit B Daventry Interchange, Sopwith Way, Drayton Fields Industrial Estate, Daventry, Northamptonshire, NN11 8PB, UK", "MESSAGE": "****IMPORTANT**EPR**PART REQUEST - Review CUMMINS MATERIAL RETURN TICKET/s for specific part numbers to be returned**EPR Core Return***Goto QSOL Warranty Click on Request Core Return Process**", "RETURNMESSAGE": "****Enhanced Parts Return Warning*** CLARKES (UK ONLY): DC10875 EUROPA: CUMMSSC001 For Returns outside Europe: DHL 957365001 Important: Always include a copy of the closed claim fax and attach the material return ticket to the outside of the box. Paccar returns = CRA #/Eztrac #. Cummins returns = WebCumpas #.", "EPRFLAG": "Y", "PARTNUMBER": "405023600", "ATTENTION": "SSC EUROPE" }, { "COMPANY": "Cummins Inc.", "LOCATION": "Unit B Daventry Interchange, Sopwith Way, Drayton Fields Industrial Estate, Daventry, Northamptonshire, NN11 8PB, UK", "MESSAGE": "****IMPORTANT**EPR**PART REQUEST - Review CUMMINS MATERIAL RETURN TICKET/s for specific part numbers to be returned**EPR Core Return***Goto QSOL Warranty Click on Request Core Return Process**", "RETURNMESSAGE": "****Enhanced Parts Return Warning*** CLARKES (UK ONLY): DC10875 EUROPA: CUMMSSC001 For Returns outside Europe: DHL 957365001 Important: Always include a copy of the closed claim fax and attach the material return ticket to the outside of the box. Paccar returns = CRA #/Eztrac #. Cummins returns = WebCumpas #.", "EPRFLAG": "Y", "PARTNUMBER": "288202100", "ATTENTION": "SSC EUROPE" } ], "Header": { "ReturnCodeDescription": "", "Status": "Success" } }');
       
        return res;
    }

}