@IsTest
public class CG_ClaimsInbound_Resp_Test 
{
    static testMethod void testParse() {
	    String json=		'{'+
		'	"DataArea": {'+
		'		"BMSClaimNumber": "1-127827968"'+
		'	},'+
		'	"Header": {'+
		'		"ReturnCodeDescription": "",'+
		'		"Status": "Success",'+
		'		 "Sender": '+
		'			{'+
		'			 "ServiceName": "",'+
		'			  "MessageID": "",'+
		'			  "SenderID": ""'+
		'			},'+
		'		"Target": '+
		'			{'+
		'			 "TargetID": ""'+
		'			},'+
		'		"Location": '+
		'			{'+
		'			 "LocationID": ""'+
		'			}'+
		'	}	'+
		'}';
		CG_ClaimsInbound_Resp obj = CG_ClaimsInbound_Resp.parse(json);
		System.assert(obj != null);
	}
}