@IsTest
public class CSS_WPR_SBL_GetWarrantyResJSON_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '    \"DataArea\": {'+
        '        \"Details\": ['+
        '            {'+
        '                \"CoveredTravelBaseFareAmt\": \"0\",'+
        '                \"CoveredOCAmount\": \"9999999\",'+
        '                \"CoveredLaborHrs\": \"9999999\",'+
        '                \"CoveredTowingMiles\": \"0\",'+
        '                \"Message\": \"\",'+
        '                \"CampaignLaborPercentage\": \"0\",'+
        '                \"CoveredTravelLabor\": \"0\",'+
        '                \"CertificateNumber\": \"DC11002334-DC1\",'+
        '                \"CampaignTowingPercentage\": \"0\",'+
        '                \"SystemCode\": \"BK\",'+
        '                \"AccountCodeType\": \"CAP-Customized Assurance Plan\",'+
        '                \"CoveredPartsQty\": \"9999999\",'+
        '                \"Status\": \"Success\",'+
        '                \"CampaignOCPercentage\": \"0\",'+
        '                \"DeductibleAmount\": \"0\",'+
        '                \"ComponentCode\": \"CA\",'+
        '                \"PayCode\": \"R\",'+
        '                \"AccountCode\": \"DC\",'+
        '                \"CampaignPartsPercentage\": \"0\",'+
        '                \"CoveredMealsLodgingAmt\": \"0\",'+
        '                \"WarrantyId\": \"1-608-1068\",'+
        '                \"CoveredTravelMiles\": \"0\",'+
        '                \"CampaignTravelPercentage\": \"0\"'+
        '            }'+
        '        ],'+
        '        \"AccountCode\": \"DC\",'+
        '        \"AccountCodeType\": \"CAP-Customized Assurance Plan\"'+
        '    },'+
        '    \"Header\": {'+
        '        \"ReturnCodeDescription\": \"\",'+
        '        \"Status\": \"Success\"'+
        '    }'+
        '}';
        
        CSS_WPR_SBL_GetWarrantyResJSON obj = CSS_WPR_SBL_GetWarrantyResJSON.parse(json);
        System.assert(obj != null);
    }
}