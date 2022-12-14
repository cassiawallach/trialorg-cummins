//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//Kalpana:Story#105223

@IsTest
public class CSS_getPartReturnInputWrapper_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'\"Header\":'+
		'{'+
		'\"Sender\":'+
		'{'+
		'\"ServiceName\": \"GetERPFlag\",'+
		'\"SenderID\": \"CSS\"'+
		'},'+
		'\"Target\": { \"TargetID\": \"SIEBEL\" }'+
		'},'+
		'\"DataArea\":'+
		'{'+
		'\"PSN\": \"10000009\",'+
		'\"DISTICHANNEL\": \"\",'+
		'\"FAILDATE\":\"2016-12-20\",'+
		'\"PARTS\" : ['+
		'{'+
		'\"PARTNUMBER\": \"306354800\",'+
		'\"PRODUCTFAMILY\" : \"\",'+
		'\"TERRITORYCLASS\" : \"\",'+
		'\"ACCOUNTCODE\": \"A1\",'+
		'\"FAILCODE\": \"SWVH\"'+
		'},'+
		'{'+
		'\"PARTNUMBER\": \"405023600\",'+
		'\"PRODUCTFAMILY\" : \"\",'+
		'\"TERRITORYCLASS\" : \"401\",'+
		'\"ACCOUNTCODE\": \"12\",'+
		'\"FAILCODE\": \"\"'+
		'},'+
		'{'+
		'\"PARTNUMBER\": \"288202100\",'+
		'\"PRODUCTFAMILY\" : \"0L\",'+
		'\"TERRITORYCLASS\" : \"\",'+
		'\"ACCOUNTCODE\": \"36\",'+
		'\"FAILCODE\": \"OTHER\"'+
		'}'+
		']'+
		'}'+
		'}';
		CSS_getPartReturnInputWrapper obj = CSS_getPartReturnInputWrapper.parse(json);
		System.assert(obj != null);
	}
}