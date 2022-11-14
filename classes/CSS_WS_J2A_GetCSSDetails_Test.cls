@IsTest
public class CSS_WS_J2A_GetCSSDetails_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"Header\": {'+
        '    \"Status\": \"Success\",'+
        '    \"ReturnCodeDescription\": \"Message if any..\"'+
        '  },'+
        '  \"DataArea\": {'+
        '    \"DetailParts\": ['+
        '      {'+
        '        \"PartNumber\": \"10909\",'+
        '        \"PartQty\": \"1\",'+
        '        \"AdjustmentReason\": \"AdjustmentReason\",'+
        '        \"AdjustmentPartsPercent\": \"PartAdjustmentPartsPercent\"'+
        '      },'+
        '      {'+
        '        \"PartNumber\": \"10990\",'+
        '        \"PartQty\": \"1\",'+
        '        \"AdjustmentReason\": \"AdjustmentReason\",'+
        '        \"AdjustmentPartsPercent\": \"PartAdjustmentPartsPercent\"'+
        '      }'+
        '    ],'+
        '    \"DetailSRTs\": ['+
        '      {'+
        '        \"SRTCode\": \"10\",'+
        '        \"SRTHours\": \"10\",'+
        '        \"SRTQty\": \"10\",'+
        '        \"AccessCode\": \"A\",'+
        '        \"PercentageAdjustment\": \"100\",'+
        '        \"AdjustmentReason\": \"SRTAdjustmentReason\"'+
        '      },'+
        '      {'+
        '        \"SRTCode\": \"11\",'+
        '        \"SRTHours\": \"11\",'+
        '        \"SRTQty\": \"11\",'+
        '        \"AccessCode\": \"B\",'+
        '        \"PercentageAdjustment\": \"100\",'+
        '        \"AdjustmentReason\": \"SRTAdjustmentReason\"'+
        '      }'+
        '    ],'+
        '    \"DetailOtherClaimables\": ['+
        '      {'+
        '        \"Description\": \"Description1\",'+
        '        \"ApprovedAmount\": \"11\",'+
        '        \"AdjustmentReason\": \"OCAdjustmentReason\"'+
        '      },'+
        '      {'+
        '        \"Description\": \"Description2\",'+
        '        \"ApprovedAmount\": \"12\",'+
        '        \"AdjustmentReason\": \"OCAdjustmentReason\"'+
        '      }'+
        '    ],'+
        '    \"DetailTravels\": ['+
        '      {'+
        '        \"AdjustmentReason\": \"TravelAdjustmentReason1\",'+
        '        \"TravelType\": \"Non-commercial\"'+
        '      }'+
        '    ]'+
        '  }'+
        '}';
        CSS_WS_J2A_GetCSSDetails obj = CSS_WS_J2A_GetCSSDetails.parse(json);
        System.assert(obj != null);
    }
}