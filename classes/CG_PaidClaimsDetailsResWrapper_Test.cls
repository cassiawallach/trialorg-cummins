@isTest
public class CG_PaidClaimsDetailsResWrapper_Test {
	
	static testMethod void PaidClaimsDetailsResWrapper() {
		String json = '{'+
		'  \"DataArea\": {'+
		'    \"DetailSRTs\": ['+
		'      {'+
		'        \"SRTHours\": 0.4,'+
		'        \"SRTQty\": 1,'+
		'        \"PercentageAdjustment\": 100,'+
		'        \"AdjustmentReason\": \"\",'+
		'        \"AccessCode\": \"R\",'+
		'        \"SRTCode\": \"00-901-00\"'+
		'      },'+
		'{'+
		'        \"SRTHours\": 0.2,'+
		'        \"SRTQty\": 1,'+
		'        \"PercentageAdjustment\": 100,'+
		'        \"AdjustmentReason\": \"\",'+
		'        \"AccessCode\": \"B\",'+
		'        \"SRTCode\": \"TS-051-01\"'+
		'      }'+
		'    ],'+
		'    \"DetailOtherClaimables\": ['+
		'      {'+
		'        \"Item\": \"\",'+
		'        \"Description\": \"1\",'+
		'        \"ApprovedAmount\": 2452,'+
		'        \"AdjustmentReason\": \"\"'+
		'      }'+
		'    ],'+
		'    \"DetailParts\": ['+
		'      {'+
		'        \"AdjustmentPartsPercent\": 100,'+
		'        \"PartQty\": 1,'+
		'        \"PartNumber\": \"408998500RX\",'+
		'        \"AdjustmentReason\": \"\"'+
		'      }'+
		'    ],'+
		'    \"DetailTravel\": ['+
		'      {'+
		'        \"TravelType\": \"\",'+
		'        \"AdjustmentReason\": \"\",'+
		'        \"Distance\": 2452,'+
		'        \"Hours\": 2.3,'+
		'        \"LodgingAmount\": 345,'+
		'        \"MealsAmount\": 46,'+
		'        \"TowingDetails\": 234'+
		'      }'+
		'    ]'+
		'  },'+
		'  \"Header\": {'+
        '    \"MessageIdentifier\": \"\",'+
        '    \"ReturnCode\": \"\",'+
		'    \"ReturnCodeDescription\": \"\",'+
		'    \"Status\": \"Success\"'+
		'  }'+
		'}';
		CG_PaidClaimsDetailsResWrapper obj = CG_PaidClaimsDetailsResWrapper.parse(json);
		System.assert(obj != null);
	}
}