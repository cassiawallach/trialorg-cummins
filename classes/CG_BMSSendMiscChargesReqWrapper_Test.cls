@IsTest
public class CG_BMSSendMiscChargesReqWrapper_Test {
	
	static testMethod void CG_BMSSendMiscChargesReqWrapper() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Target\": {'+
		'      \"TargetID\": \"BMS\"'+
		'    },'+
		'    \"Sender\": {'+
		'      \"ServiceName\": \"sendMiscCharges\",'+
		'      \"SenderID\": \"CSS\"'+
		'    },'+
		'    \"Location\": {'+
		'      \"LocationID\": \"56270-56255\"'+
		'    }'+
		'  },'+
		'  \"DataArea\": {'+
		'    \"CSSJobID\": \"CSS-00044023\",'+
		'    \"DistributorCode\": \"56270\",'+
		'    \"BranchCode\": \"56275\",'+
		'    \"CustomerCode\": \"WOQT\",'+
		'    \"OrderType\": \"WOQT\",'+
		'    \"BMSReferenceNumber\": \"\",'+
		'    \"MiscDetails\": ['+
		'  {'+
		'        \"ClaimType\": \"Factoty\",'+
		'        \"MiscName\": \"RLC DISCOUNT\",'+
		'        \"Quantity\": 2,'+
		'        \"Amount\": 234,'+
		'        \"MiscOC\": \"Y\",'+
		'        \"CreateUser\": \"WWID\",'+
		'        \"ChangeUser\": \"WWID\"'+
		'      },'+
		'      {'+
		'        \"ClaimType\": \"Factoty\",'+
		'        \"MiscName\": \"RLC DISCOUNT\",'+
		'        \"Quantity\": 2,'+
		'        \"Amount\": 234,'+
		'        \"MiscOC\": \"Y\",'+
		'        \"CreateUser\": \"WWID\",'+
		'        \"ChangeUser\": \"WWID\"'+
		'      }'+
		'    ]'+
		'  }'+
		'}';
		CG_BMSSendMiscChargesReqWrapper obj = CG_BMSSendMiscChargesReqWrapper.parse(json);
		System.assert(obj != null);
	}
}