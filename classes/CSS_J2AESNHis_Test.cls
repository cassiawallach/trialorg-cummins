@isTest
public class CSS_J2AESNHis_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"pagination\": {'+
		'    \"currentPage\": 1,'+
		'    \"numberPerPage\": 506,'+
		'    \"numberOfPages\": 1,'+
		'    \"totalNumberOfRecord\": 3'+
		'  },'+
		'  \"diagnosticSession\": ['+
		'    {'+
		'      \"id\": \"DSBDT4665\",'+
		'      \"creationDate\": \"26-FEB-2016 10:41 EST\",'+
		'      \"owner\": \"POINTE CLAIRE-CUMMINS EASTERN CANADA LP-56330\",'+
		'      \"title\": \"Tester\",'+
		'      \"model\": \"ISB6.7 CM2350 B101\",'+
		'      \"status\": \"Open\",'+
		'      \"serialNumber\": \"73676187\",'+
		'      \"additionalProp\": {'+
		'        \"application\": \"Automotive (other than C series) [130]\",'+
		'        \"failureType\": \"MI\",'+
		'        \"REPEAT_FLAG\": \"true\"'+
		'      }'+
		'    },'+
		'    {'+
		'      \"id\": \"DSBDT4252\",'+
		'      \"creationDate\": \"21-JAN-2016 14:18 EST\",'+
		'      \"owner\": \"nh877\",'+
		'      \"title\": \"Trucking\",'+
		'      \"model\": \"ISB6.7 CM2350 B101\",'+
		'      \"status\": \"Open\",'+
		'      \"serialNumber\": \"73676187\",'+
		'      \"additionalProp\": {'+
		'        \"application\": \"Automotive (other than C series) [130]\",'+
		'        \"failureType\": \"MI\"'+
		'      }'+
		'    },'+
		'    {'+
		'      \"id\": \"DSBDT4230\",'+
		'      \"creationDate\": \"15-JAN-2016 10:44 EST\",'+
		'      \"owner\": \"nh877\",'+
		'      \"title\": \"Ondie&#039;s Test with Team\",'+
		'      \"model\": \"ISB6.7 CM2350 B101\",'+
		'      \"status\": \"Open\",'+
		'      \"serialNumber\": \"73676187\",'+
		'      \"additionalProp\": {'+
		'        \"application\": \"Automotive (other than C series) [130]\",'+
		'        \"failureType\": \"MI\"'+
		'      }'+
		'    }'+
		'  ]'+
		'}';
		CSS_J2AESNHistory obj = CSS_J2AESNHistory.parse(json);
		System.assert(obj != null);
	}
}