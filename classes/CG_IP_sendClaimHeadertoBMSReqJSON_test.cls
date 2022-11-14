@IsTest
public class CG_IP_sendClaimHeadertoBMSReqJSON_test {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"Header\": {'+
		'    \"Target\": {'+
		'      \"TargetID\": \"BMS\"'+
		'    },'+
		'    \"Sender\": {'+
		'      \"ServiceName\": \"sendWCHeader\",'+
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
		'    \"ClaimDetails\": ['+
		'      {'+
		'        \"ClaimType\": \"FACTORY\",'+
		'        \"AccountCode\": \"67\",'+
		'        \"PayCode\": \"I\",'+
		'        \"ESN\": \"987987\",'+
		'        \"Certificate\": \"Y\",'+
		'        \"AuthorizationNumber\": \"9786876\",'+
		'        \"FailureDate\": \"\",'+
		'        \"WarrantyStarDate\": \"\",'+
		'        \"MissionDisabling\": \"A\",'+
		'        \"SMN\": \"ISX 234 GH\",'+
		'        \"Make\": \"VOLVO\",'+
		'        \"Model\": \"VNL SERIES\",'+
		'        \"EquipmentConfiguration\": \"32\",'+
		'        \"ApplicationCode\": \"130\",'+
		'        \"Distance\": 8767,'+
		'        \"DistanceType\": \"MILES\",'+
		'        \"Hours\": 8.3,'+
		'        \"ApprovalCode\": \"A12\",'+
		'        \"DistributorAuthorization\": \"WWID\",'+
		'        \"DeductibleApply\": \"Y\",'+
		'        \"TravelAllowed\": \"Y\",'+
		'        \"TowingAllowed\": \"Y\",'+
		'        \"TravelHoursAllowed\": 69,'+
		'        \"CreateUser\": \"WWID\",'+
		'        \"ChangeUser\": \"WWID\"'+
		'      },'+
		'      {'+
		'        \"ClaimType\": \"FACTORY\",'+
		'        \"AccountCode\": \"62\",'+
		'        \"PayCode\": \"I\",'+
		'        \"ESN\": \"987987\",'+
		'        \"Certificate\": \"Y\",'+
		'        \"AuthorizationNumber\": \"9786876\",'+
		'        \"FailureDate\": \"\",'+
		'        \"WarrantyStarDate\": \"\",'+
		'        \"MissionDisabling\": \"A\",'+
		'        \"SMN\": \"ISX 234 GH\",'+
		'        \"Make\": \"VOLVO\",'+
		'        \"Model\": \"VNL SERIES\",'+
		'        \"EquipmentConfiguration\": \"32\",'+
		'        \"ApplicationCode\": \"130\",'+
		'        \"Distance\": 8767,'+
		'        \"DistanceType\": \"MILES\",'+
		'        \"Hours\": 8.3,'+
		'        \"ApprovalCode\": \"A12\",'+
		'        \"DistributorAuthorization\": \"WWID\",'+
		'        \"DeductibleApply\": \"Y\",'+
		'        \"TravelAllowed\": \"Y\",'+
		'        \"TowingAllowed\": \"Y\",'+
		'        \"TravelHoursAllowed\": 69,'+
		'        \"CreateUser\": \"WWID\",'+
		'        \"ChangeUser\": \"WWID\"'+
		'      }'+
		'    ]'+
		'  }'+
		'}';
		CG_IP_sendClaimHeadertoBMSReqJSON obj = CG_IP_sendClaimHeadertoBMSReqJSON.parse(json);
		System.assert(obj != null);
	}
}