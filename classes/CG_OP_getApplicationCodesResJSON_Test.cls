@isTest
public class CG_OP_getApplicationCodesResJSON_Test {

	static testMethod void testParse() {
	String json=		'{'+
		'	"DataArea": [{'+
		'		"MarketingApplicationCode": "",'+
		'		"MarketingApplicationDescription": "",'+
		'		"ProductApplicationCode": "",'+
		'		"ProductApplicationDescription": "",'+
		'		"ProductFamilyCode": ""'+
		'	}],'+
		'	"Header": {'+
		'		"ReturnCodeDescription": "",'+
		'		"Status": "Success",'+
		'		"ReturnCode": "",'+
		'		"MessageIdentifier": ""'+
		'	}'+
		'}';
		CG_OP_getApplicationCodesResJSON obj = CG_OP_getApplicationCodesResJSON.parse(json);
		System.assert(obj != null);
	}	
}