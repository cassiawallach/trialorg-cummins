/*
 * Test Class for Apex Controller - FSL_ReceiveAdditionalSubTypeWrapper
 * Author - Piyush Rani 
 */ 
@isTest
public class FSL_ReceiveAdditionalSubTypeWrapper_Test {
    @isTest
    static void testParse() {
		String json = '{'+
		'   \"Header\":{'+
		'      \"Sender\":{'+
		'         \"ServiceName\":\"AdditionalSubTypes\",'+
		'         \"SenderID\":\"MOVEX\"'+
		'      },'+
		'      \"Target\":{'+
		'         \"TargetID\":\"Guidanz\"'+
		'      }'+
		'   },'+
		'   \"DataArea\":{'+
		'      \"CSSJobID\":\"00007778\",'+
		'      \"ERPWONumber\":\"12345\",'+
		'      \"PayerAccount\":\"\",'+
		'      \"AssignmentNumber\":\"\",'+
		'      \"PrimarySubType\":\"USN-F1-01\",'+
		'      \"ERPJobLineNumber\":\"\",'+
		'      \"Status\":\"\",'+
		'      \"AdditionalSubTypes\":['+
		'         {'+
		'            \"SubType\":\"USN-F1-02\",'+
		'            \"AssignmentNumber\":\"\",'+
		'            \"ERPJobLineNumber\":\"\",'+
		'            \"PayerAccount\":\"\",'+
		'            \"Status\":\"\"'+
		'         },'+
		'         {'+
		'            \"SubType\":\"USN-F1-03\",'+
		'            \"AssignmentNumber\":\"\",'+
		'            \"ERPJobLineNumber\":\"\",'+
		'            \"PayerAccount\":\"\",'+
		'            \"Status\":\"\"'+
		'         },'+
		'         {'+
		'            \"SubType\":\"USN-F1-04\",'+
		'            \"AssignmentNumber\":\"\",'+
		'            \"ERPJobLineNumber\":\"\",'+
		'            \"PayerAccount\":\"\",'+
		'            \"Status\":\"\"'+
		'         }'+
		'      ]'+
		'   }'+
		'}';
		FSL_ReceiveAdditionalSubTypeWrapper obj = FSL_ReceiveAdditionalSubTypeWrapper.parse(json);
		System.assert(obj != null);
	}
    /*
	@isTest
    static void testParse() {
		String requestJSON = '{'+
		'  \"Header\": {'+
		'    \"Sender\": {'+
		'      \"ServiceName\": \"AdditionalSubTypes\",'+
		'      \"SenderID\": \"MOVEX\"'+
		'    },'+
		'    \"Target\": {'+
		'      \"TargetID\": \"Guidanz\"'+
		'    }'+
		'  },'+
		'  \"DataArea\": {'+
		'    \"CSSJobID\": \"00007778\",'+
		'    \"ERPWONumber\": \"12345\",'+
		'    \"PrimarySubType\": \"USN-F1-01\",'+
		'    \"JobStatus\": \"Repair\",'+
		'    \"AdditionalSubTypes\": ['+
		'      {'+
		'        \"SubType\": \"USN-F1-02\",'+
		'        \"AssignmentNumber\": \"567\",'+
		'        \"ERPJobLineNumber\": \"5\"'+
		'      },'+
		'      {'+ 
		'        \"SubType\": \"USN-F1-03\",'+
		'        \"AssignmentNumber\": \"453\",'+
		'        \"ERPJobLineNumber\": \"9\"'+
		'      },'+
		'      {'+
		'        \"SubType\": \"USN-F1-04\",'+
		'        \"AssignmentNumber\": \"234\",'+
		'        \"ERPJobLineNumber\": \"8\"'+
		'      }'+
		'    ]'+
		'  }'+
		'}';
		FSL_ReceiveAdditionalSubTypeWrapper obj = FSL_ReceiveAdditionalSubTypeWrapper.parse(requestJSON);
		System.assert(obj != null);
	} */
}