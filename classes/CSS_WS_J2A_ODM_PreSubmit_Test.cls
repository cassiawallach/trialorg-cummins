@IsTest
Public Class CSS_WS_J2A_ODM_PreSubmit_Test{
    
    Static TestMethod Void testParse(){
        String json = '{' +
        '    \"Response\":{' +
        '        \"DecisionID\": \"\",' +
        '        \"claim\":{' +
        '            \"groupName\": \"\",' +
        '            \"historyClaimFlag\": \"N\",' +
        '            \"reconPartsWarrantyFlag\": \"N\",' +
        '            \"failureDate\": \"2016-01-01T00:00:00-06:00\",' +
        '            \"cmiEngineSerialNumber\": 75015214,' +
        '            \"multiESNFlag\": \"N\",' +
        '            \"claimSource\": \"MX\",' +
        '            \"totalClaimAmt\": \"\",' +
        '            \"messages\": [{' +
        '                \"description\": \"Invalid claim total. A claim must have at least one SRT, Part, or Other Claimable in order to be submitted\",' +
        '                \"code\": \"ODM-PS-ERR-107\",' +
        '                \"type\": \"ERROR\"' +
        '            }],' +
        '            \"roNumber\": 98765,' +
        '            \"level\": \"\",' +
        '            \"serviceModelName\": \"ISX12 CM2350 X102\",' +
        '            \"warrantyStartDate\": \"2012-05-04T00:00:00-05:00\",' +
        '            \"engineFamily\": \"0K\",' +
        '            \"serviceProvider\":{'  +
        '                \"region\": \"MEXICO\",' +
        '                \"channelOfDistribution\": \"DEALER\",' +
        '                \"regionCode\": \"MEXI\",' +
        '                \"engineExpirationdate\": \"\",' +
        '                \"territory\": \"MEXICO\",' +
        '                \"outfileAllClaimsFlag\": \"Y\",' +
        '                \"engineEffectiveDate\": \"\",' +
        '                \"claimAllowedDays\": 365' +
        '            },' +
        '            \"failures\":[{' +
        '                \"srtList\":[{' +
        '                    \"hours\": \"\",' +
        '                    \"srtAllowedFlag\": \"\",' +
        '                    \"quantity\": \"\"' +
        '                }],' +
        '                \"payCode\": \"R\",' +
        '                \"status\": \"Draft\",' +
        '                \"totalLaborAmt\": \"\",' +
        '                \"authorizationNumber\": 123,' +
        '                \"parts\":[{' +
        '                    \"partPrice\": \"\",' +
        '                    \"partAllowedFlag\": \"\"' +
        '                }],' +
        '                \"acctCodeInfo\": \"\",' +
        '                \"totalTowingAmt\": \"\",' +
        '                \"accountCode\": 67,' +
        '                \"travels\":[{' +
        '                    \"mealsCharges\": \"\",' +
        '                    \"towingCharges\": \"\",' +
        '                    \"hours\": \"\",' +
        '                    \"travelDistance\": \"\"' +
        '                }],' +
        '                \"failCode\": \"BKCA\",' +
        '                \"otherClaimables\":[{' +
        '                    \"amount\": \"\"' +
        '                }],' +
        '                \"coverageType\": \"NEW-New Engine Warranty\",' +
        '                \"failMode\": 21,' +
        '                \"lineNumber\": 1,' +
        '                \"totalSRTHours\": \"\",' +
        '                \"inShopCampaignFlag\": \"\",' +
        '                \"campaign\":{' +
        '                    \"accountCode\": \"\",' +
        '                    \"engineComponentCode\": \"\",' +
        '                    \"campaignId\": \"\",' +
        '                    \"completeIndicator\": \"\",' +
        '                    \"campaignType\": \"\",' +
        '                    \"status\": \"\",' +
        '                    \"systemCode\": \"\",' +
        '                    \"failMode\": \"\",' +
        '                    \"multiFlag\": \"\"' +
        '                }' +
        '            }],' +
        '            \"failurePoint\": 1000,' +
        '            \"engine\":{' +
        '                \"productApplicationDesp\": \"BUS\",' +
        '                \"marineFlag\": \"N\",' +
        '                \"engineFamilyCode\": \"0K\",' +
        '                \"warrantyIndicatorFlag\": \"Y\",' +
        '                \"buildDate\": \"2012-11-01T00:00:00-05:00\"' +
        '            },' +
        '            \"productApplicationCode\": \"BU\",' +
        '            \"status\": \"ERROR\",' +
        '            \"claimStatus\": \"Draft\",' +
        '            \"failureMeasure\": \"Kilometers\",' +
        '            \"cmiServiceProviderCode\": 54887,' +
        '            \"manualAdjudicationFlag\": \"\",' +
        '            \"bisFlag\": \"N\",' +
        '            \"claimNumber\": \"Draft\"' +
        '        }' +
        '    }' +
        '}';
        CSS_WS_J2A_ODM_PreSubmit obj = CSS_WS_J2A_ODM_PreSubmit.parse(json);
        System.assert(obj != null);
    }
}