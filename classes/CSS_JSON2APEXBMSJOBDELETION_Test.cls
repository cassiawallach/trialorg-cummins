@IsTest
public class CSS_JSON2APEXBMSJOBDELETION_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"sendBMSJobDeletion\",'+
		'			\"SenderID\": \"BMS\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"CSS\"'+
		'		},'+
		'		\"Location\": {'+
		'			\"LocationID\": \"02400-02394\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"CSSJobId\": \"CSS-00001234\",'+
		'		\"DistributorCode\": \"02400\",'+
		'		\"BranchCode\": \"02394\",'+
		'		\"CustomerCode\": \"C100002045\",'+
		'		\"OrderType\": \"WO/WOQT\",'+
		'		\"BMSReferenceNumber\": \"98687687\",'+
		'		\"Action\": \"DELETE\",'+
		'		\"Reason\": \"Job deleted in BMS.\"'+
		'	}'+
		'}';
		CSS_JSON2APEXBMSJOBDELETION obj = CSS_JSON2APEXBMSJOBDELETION.parse(json);
		System.assert(obj != null);
	}
}