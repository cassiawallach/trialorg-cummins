@IsTest
public class CG_WPR_SBL_SPTechnicianInfo_Test {
	
	static testMethod void testParse() {
	/*	String json = '{'+
		'  \"DataArea\": ['+
		'    {'+
		'      \"SP_CODE\": \"02004\",'+
		'      \"SP_ROW_ID\": \"120000234\",'+
		'      \"First_Name\": \"\",'+
		'      \"Last_Name\": \"\",'+
		'      \"Promotion_ID\": \"\",'+
		'      \"TECH_ROW_ID\": \"150000432\"'+
		'    },'+
		'    {'+
		'      \"SP_CODE\": \"02004\",'+
		'      \"SP_ROW_ID\": \"120000234\",'+
		'      \"First_Name\": \"\",'+
		'      \"Last_Name\": \"\",'+
		'      \"Promotion_ID\": \"\",'+
		'      \"TECH_ROW_ID\": \"150000433\"'+
		'    }'+
		'  ],'+
		'  \"Header\": {'+
		'    \"ReturnCodeDescription\": \"<Message from Siebel>\",'+
		'    \"Status\": \"Success\",'+
		'    \"ReturnCode\": \"<MessageCode from Siebel>\",'+
		'    \"MessageIdentifier\": \"<Identifier from MW>\"'+
		'  }'+
		'}';*/
        string json='{ "Header": { "Status": "SUCCESS", "MessageIdentifier": "9cf45690-9331-11e9-a754-022059974d50", "ReturnCodeDescription": "Records Processed Successfully" }, "DataArea": { "TechnicianInfo": [ { "PromotionId": "1044847", "FstName": "William", "LastName": "Denham", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-MEN-5522" }, { "PromotionId": "1044839", "FstName": "Jason", "LastName": "Jones", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-30ON-332" }, { "PromotionId": "A380825", "FstName": "David", "LastName": "Dillon", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-MET-2764" }, { "PromotionId": "1072782", "FstName": "Gary", "LastName": "Fultz", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-A5U0-4552" }, { "PromotionId": "1011165", "FstName": "Beth", "LastName": "Adkins", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-A5TX-4693" }, { "PromotionId": "1044838", "FstName": "James", "LastName": "Crosier", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-A5TL-6734" }, { "PromotionId": "1044845", "FstName": "Steve", "LastName": "Boucher", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-MEQ-4317" }, { "PromotionId": "1045525", "FstName": "Steve", "LastName": "Adcock", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-A5U0-5895" }, { "PromotionId": "B952795", "FstName": "Dirk", "LastName": "Abeln", "SpCode": "20957", "SpRowId": "1-KWZ-567", "TechRowId": "1-MEH-929" } ] } }';
		CG_WPR_SBL_SPTechnicianInfo obj = CG_WPR_SBL_SPTechnicianInfo.parse(json);
		System.assert(obj != null);
	}
}