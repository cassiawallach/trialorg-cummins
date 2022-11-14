@IsTest
public class CG_IP_CustCreditMsgReqJSON_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"GetCustomerCreditMessage\",'+
		'			\"SenderID\": \"CSS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"BMS\"'+
		'		},'+
		'		\"Location\": {'+
		'			\"LocationID\": \"02400-02394\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"CustomerNumber\": \"C100002045\"'+
		'	}'+
		'}';
        
		CG_IP_CustCreditMsgReqJSON obj = CG_IP_CustCreditMsgReqJSON.parse(json);
		System.assert(obj != null);
	}
}