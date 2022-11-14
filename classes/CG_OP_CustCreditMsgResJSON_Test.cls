@IsTest
public class CG_OP_CustCreditMsgResJSON_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"Status\": \"SUCCESS\",'+
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
		'		\"CustomerNumber\": \"C100002045\",'+
		'		\"CreditMessageDetails\": ['+
		'			{'+
		'				\"CreditMessageCode\": \"23423\",'+
		'				\"CreditMessage\": \"Invoice credit message1\"'+
		'			},'+
		'			{'+
		'				\"CreditMessageCode\": \"23424\",'+
		'				\"CreditMessage\": \"Invoice credit message2\"'+
		'			},'+
		'			{'+
		'				\"CreditMessageCode\": \"23425\",'+
		'				\"CreditMessage\": \"Invoice credit message3\"'+
		'			}'+
		'		]'+
		'	}'+
		'}';
        
		CG_OP_CustCreditMsgResJSON obj = CG_OP_CustCreditMsgResJSON.parse(json);
		System.assert(obj != null);
	}
}