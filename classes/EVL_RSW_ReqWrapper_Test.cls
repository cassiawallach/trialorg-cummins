//Adding Comment for Deployment - Sriprada S
@IsTest
public class EVL_RSW_ReqWrapper_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"Header\": {'+
		'        \"Sender\": {'+
		'            \"SenderID\": \"CSS\" '+
		'        },'+
		'        \"Target\": {'+
		'            \"TargetID\": \"RSW\"'+
		'        }'+
		'    },'+
		'    \"DataArea\": {'+
		'        \"id\": \"2717453\",'+
		'        \"timestamp\": \"05/04/2020 13:47:04\",'+
		'        \"dsID\": \"DSBDW3524\",'+
		'        \"createDate\": \"04/28/2020 14:52:21\",'+
		'        \"workOrder\": \"\",'+
		'        \"esn\": \"79756226\",'+
		'        \"dsStatus\": \"Open\",'+
		'        \"dsClosureType\": \"\",'+
		'        \"nbSearches\": \"2\",'+
		'        \"accessSRTID\": \"\",'+
		'        \"faliurePoint\": \"386345\",'+
		'        \"faliureMeasure\": \"MI\",'+
		'        \"manufacturer\": \"INTERNATIONAL\",'+
		'        \"modelSeries\": \"TRANSTAR\",'+
		'        \"unitNumber\": \"2342324\",'+
		'        \"customerName\": \"AMERICAN ENG &amp;amp; TESTING\",'+
		'        \"application\": \"130\",'+
		'        \"faultCode\": \"559\",'+
		'        \"event\": ['+
		'            {'+
		'                \"solutionId\": \"S00001309\",'+
		'                \"solutionSeq\": \"1\",'+
		'                \"searchNumber\": \"2\",'+
		'                \"searchCompleted\": \"true\",'+
		'                \"verificationStatus\": \"Y\",'+
		'                \"repairStatus\": \"\",'+
		'                \"timestamp\": \"04/28/2020 14:53:18\",'+
		'                \"informationType\": \"\",'+
		'                \"componentID\": \"F453455\"'+
		'            },'+
		'            {'+
		'                \"solutionId\": \"S00001320\",'+
		'                \"solutionSeq\": \"2\",'+
		'                \"searchNumber\": \"2\",'+
		'                \"searchCompleted\": \"true\",'+
		'                \"verificationStatus\": \"Y\",'+
		'                \"repairStatus\": \"\",'+
		'                \"timestamp\": \"\",'+
		'                \"informationType\": \"\",'+
		'                \"componentID\": \"F453455, F564565\"'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
		EVL_RSW_ReqWrapper obj = EVL_RSW_ReqWrapper.parse(json);
        EVL_RSW_ReqWrapper.Header headerDetail = new EVL_RSW_ReqWrapper.Header();
        obj.setHeader(headerDetail);
        EVL_RSW_ReqWrapper.Header dtArHead =  obj.getHeader();
        
        EVL_RSW_ReqWrapper.DataArea DataAreaDetails = new EVL_RSW_ReqWrapper.DataArea();
        obj.setDataArea(DataAreaDetails);
        
        EVL_RSW_ReqWrapper.DataArea dtAr =  obj.getDataArea();
		System.assert(obj != null);
	}
}