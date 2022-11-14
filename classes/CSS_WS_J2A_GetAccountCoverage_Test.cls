@IsTest
public class CSS_WS_J2A_GetAccountCoverage_Test {
    
    static testMethod void testParse() {
        String json = '{  '+
        '   \"Header\":{  '+
        '       \"Status\": \"success\",'+
        '       \"ReturnCodeDescription\": \"Message if any..\"'+
        '   },'+
        '   \"DataArea\":{  '+
        '      \"AccountCode\":\"FILTER AUX\",'+
        '      \"AccountCodeType\":\"34.5\",'+
        '      \"Details\":[  '+
        '         {  '+
        '            \"CoveredTravelBaseFareAmt\": \"2022\",'+
        '            \"SystemCode\":\"IR\",'+
        '            \"ComponentCode\":\"TC\",'+
        '            \"AccountCode\":\"65\",'+
        '            \"AccountCodeType\":\"CMP-Campaign / Recalls\",'+
        '            \"PayCode\":\"R\",'+
        '            \"CertificateNumber\":\"89798798\",'+
        '            \"CoveredLaborHrs\":\"30\",'+
        '            \"CoveredMealsLodgingAmt\":\"20\",'+
        '            \"CoveredOCAmount\":\"200\",'+
        '            \"CoveredPartsQty\":\"10\",'+
        '            \"CoveredTowingMiles\":\"500\",'+
        '            \"CoveredTravelLabor\":\"40\",'+
        '            \"CoveredTravelMiles\":\"8\",'+
        '            \"DeductibleAmount\":\"500\",'+
        '            \"CampaignLaborPercentage\":\"100\",'+
        '            \"CampaignOCPercentage\":\"100\",'+
        '            \"CampaignPartsPercentage\":\"100\",'+
        '            \"CampaignTowingPercentage\":\"100\",'+
        '            \"CampaignTravelPercentage\":\"100\",'+
        '            \"Message\":\"Coverage Not Found/This ESN is ineligible for this Campaign\",'+
        '            \"Status\":\"Success/Error\",'+
        '            \"WarrantyId\":\"1-HJGT\"'+
        '         },'+
        '         {  '+
        '            \"CoveredTravelBaseFareAmt\": \"2022\",'+
        '            \"SystemCode\":\"IR\",'+
        '            \"ComponentCode\":\"TC\",'+
        '            \"AccountCode\":\"65\",'+
        '            \"AccountCodeType\":\"CMP-Campaign / Recalls\",'+
        '            \"PayCode\":\"R\",'+
        '            \"CertificateNumber\":\"89798798\",'+
        '            \"CoveredLaborHrs\":\"30\",'+
        '            \"CoveredMealsLodgingAmt\":\"20\",'+
        '            \"CoveredOCAmount\":\"200\",'+
        '            \"CoveredPartsQty\":\"10\",'+
        '            \"CoveredTowingMiles\":\"500\",'+
        '            \"CoveredTravelLabor\":\"40\",'+
        '            \"CoveredTravelMiles\":\"8\",'+
        '            \"DeductibleAmount\":\"500\",'+
        '            \"CampaignLaborPercentage\":\"100\",'+
        '            \"CampaignOCPercentage\":\"100\",'+
        '            \"CampaignPartsPercentage\":\"100\",'+
        '            \"CampaignTowingPercentage\":\"100\",'+
        '            \"CampaignTravelPercentage\":\"100\",'+
        '            \"Message\":\"Coverage Not Found/This ESN is ineligible for this Campaign\",'+
        '            \"Status\":\"Success/Error\",'+
        '            \"WarrantyId\":\"1-HJGT\"'+
        '         }'+
        '      ]'+
        '   }'+
        '}';
        
        CSS_WS_J2A_GetAccountCoverage obj = CSS_WS_J2A_GetAccountCoverage.parse(json);
        System.assert(obj != null);
    }
}