//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

@IsTest
public class CG_WPR_SBL_SPCertification_Test {
	
	static testMethod void testParseMethod() {
		String json = '{'+
		'    \"Header\": {'+
		'        \"Status\": \"SUCCESS\",'+
		'        \"MessageIdentifier\": \"025ae330-9348-11e9-a754-022059974d50\",'+
		'        \"ReturnCodeDescription\": \"Records Processed Successfully\"'+
		'    },'+
		'    \"DataArea\": {'+
		'        \"CertificationInfo\": ['+
		'            {'+
		'                \"SpCode\": \"26838\",'+
		'                \"SpRowId\": \"1-KX1-1541\",'+
		'                \"Smn\": \"6C8.3\",'+
		'                \"SpCertRowId\": \"1-E084-234\",'+
		'                \"OemCode\": \"212\",'+
		'                \"OemName\": \"HYUNDAI\",'+
		'                \"StartDate\": \"2018-10-11T00:00:00\",'+
		'                \"EndDate\": \"2999-12-31T00:00:00\",'+
		'                \"ServiceLevel\": \"FULL SERVICE\"'+
		'            },'+
		'            {'+
		'                \"SpCode\": \"26797\",'+
		'                \"SpRowId\": \"1-KX1-1537\",'+
		'                \"Smn\": \"6C8.3\",'+
		'                \"SpCertRowId\": \"1-E084-45\",'+
		'                \"OemCode\": \"212\",'+
		'                \"OemName\": \"HYUNDAI\",'+
		'                \"StartDate\": \"2018-10-11T00:00:00\",'+
		'                \"EndDate\": \"2999-12-31T00:00:00\",'+
		'                \"ServiceLevel\": \"REPAIR\"'+
		'            }'+
        '        ]'+
		'    }'+
		'}';
		CG_WPR_SBL_SPCertification obj = CG_WPR_SBL_SPCertification.parse(json);
		System.assert(obj != null);
	}
}