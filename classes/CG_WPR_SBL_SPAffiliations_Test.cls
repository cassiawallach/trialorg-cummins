@IsTest
public class CG_WPR_SBL_SPAffiliations_Test {
	
	static testMethod void testParse() {
	/*String json = '{'+
        '  \"Header\": {'+
		'    \"Status\": \"Status\",'+
		'    \"MessageIdentifier\": \"MessageIdentifier\",'+
		'    \"ReturnCodeDescription\": \"ReturnCodeDescription\"'+
		'  }'+
		'  \"DataArea\": ['+
		'    {'+
		'      \"Affiliation\": \"Affiliation\",'+
		'      \"Primary\": \"Primary\",'+
		'      \"LastUpdatedBy\": \"LastUpdatedBy\",'+
		'      \"LastUpdatedDate\": \"LastUpdatedDate\",'+
		'      \"AffiliationRowId\": \"AffiliationRowId\",'+
		'      \"SpCode\": \"SpCode\",'+
        '      \"SpRowId\": \"SpRowId\"'+
		'    },'+
		'    {'+
		'      \"Affiliation\": \"Affiliation\",'+
		'      \"Primary\": \"Primary\",'+
		'      \"LastUpdatedBy\": \"LastUpdatedBy\",'+
		'      \"LastUpdatedDate\": \"LastUpdatedDate\",'+
		'      \"AffiliationRowId\": \"AffiliationRowId\",'+
		'      \"SpCode\": \"SpCode\",'+
        '      \"SpRowId\": \"SpRowId\"'+
		'    }'+
		'  ]'+
		'}';*/ 
 string json='{ "Header": { "Status": "SUCCESS", "MessageIdentifier": "9cf45690-9331-11e9-a754-022059974d50", "ReturnCodeDescription": "Records Processed Successfully" },"DataArea": { "TechnicianInfo": [ { "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" },{ "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" },{ "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" },{ "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" }, { "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" }, { "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" }, { "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" },{ "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" },{ "Affiliation": "Affiliation", "Primary": "Primary", "LastUpdatedBy": "LastUpdatedBy", "LastUpdatedDate": "LastUpdatedDate", "AffiliationRowId": "AffiliationRowId", "SpCode": "SpCode" ,"SpRowId":"SpRowId" } ] } }';
	 CG_WPR_SBL_SPAffiliations obj = CG_WPR_SBL_SPAffiliations.parse(json);
	     System.assert(obj != null);
	}
}