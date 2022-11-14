@IsTest
public class CG_SendFailurecodestoBMSWrapper_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Target\": {'+
		'      \"TargetID\": \"BMS\"'+
		'    },'+
		'    \"Sender\": {'+
		'      \"ServiceName\": \"sendFailureCodes\",'+
		'      \"SenderID\": \"CSS\"'+
		'    },'+
		'    \"Location\": {'+
		'      \"LocationID\": \"56270-56255\"'+
		'    }'+
		'  },'+
		'  \"DataArea\": {'+
		'    \"CSSJobID\": \"\",'+
		'    \"DistributorCode\": \"\",'+
		'    \"BranchCode\": \"\",'+
		'    \"CustomerCode\": \"\",'+
		'    \"OrderType\": \"\",'+
		'    \"BMSReferenceNumber\": \"\",'+
		'    \"FailuresList\": ['+
		'      {'+
		'        \"ProductGroup\": \"HH\",'+
		'        \"GroupNumber\": \"00\",'+
		'        \"SystemCode\": \"\",'+
		'        \"ComponentCode\": \"\",'+
		'        \"FailureMode\": \"\",'+
		'        \"FailLocation\": \"\",'+
		'        \"ClaimType\": \"\",'+
		'        \"CreateUser\": \"\",'+
		'        \"ChangeUser\": \"\"'+
		'      },'+
		'      {'+
		'        \"ProductGroup\": \"HH\",'+
		'        \"GroupNumber\": \"00\",'+
		'        \"SystemCode\": \"\",'+
		'        \"ComponentCode\": \"\",'+
		'        \"FailureMode\": \"\",'+
		'        \"FailLocation\": \"\",'+
		'        \"ClaimType\": \"\",'+
		'        \"CreateUser\": \"\",'+
		'        \"ChangeUser\": \"\"'+
		'      }'+
		'    ]'+
		'  }'+
		'}';
		CG_SendFailurecodestoBMSWrapper obj = CG_SendFailurecodestoBMSWrapper.parse(json);
		System.assert(obj != null);
	}
    static testMethod void testParseOutPut() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Target\": {'+
		'      \"TargetID\": \"BMS\"'+
		'    },'+
		'    \"Sender\": {'+
		'      \"ServiceName\": \"sendFailureCodes\",'+
		'      \"SenderID\": \"CSS\"'+
		'    },'+
		'    \"Location\": {'+
		'      \"LocationID\": \"56270-56255\"'+
		'    },'+
        '     \"ReturnCodeDescription\" : \"test Desc\" ,' +
        '     \"status\" : \"SUCCESS\" ' +
		'  }'+
	    '}';
		CG_SendFailurecodestoBMSOutPutWrapper obj = CG_SendFailurecodestoBMSOutPutWrapper.parse(json);
		System.assert(obj != null);
	}
}