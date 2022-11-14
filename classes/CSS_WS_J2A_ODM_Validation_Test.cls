@IsTest
Public Class CSS_WS_J2A_ODM_Validation_Test{
    
    Static TestMethod Void testParse(){
        String json = '{' +
        '    \"Response\":{' +
        '        \"DecisionID\": \"string\",' +
        '        \"claim\":{' +
        '            \"groupName\": \"string\",' +
        '            \"historyClaimFlag\": \"string\",' +
        '            \"reconPartsWarrantyFlag\": \"string\",' +
        '            \"claimReceivedDate\": \"2006-08-19T13:27:14-04:00\",' +
        '            \"failureDate\": \"2009-05-16T08:42:28\",' +
        '            \"cmiEngineSerialNumber\": \"string\",' +
        '            \"multiESNFlag\": \"string\",' +
        '            \"level\": \"string\",' +
        '            \"button\": \"string\",' +
        '            \"approverName\": \"string\",' +
        '            \"parts\":{' +
        '                \"reconPartFlag\": \"string\",' +
        '                \"partName\": \"string\",' +
        '                \"partPrice\": 150,' +
        '                \"lineNumber\": \"string\",' +
        '                \"partId\": \"string\",' +
        '                \"channelCode\": \"string\",' +
        '                \"standardPriceBook\": \"string\",' +
        '                \"pricingRegion\": \"string\",' +
        '                \"exceptionPriceBook\": \"string\",' +
        '                \"partAllowedFlag\": \"string\",' +
        '                \"partReturnFlag\": \"string\",' +
        '                \"partsProductCode\": \"string\",' +
        '                \"priceBook\": \"string\"' +
        '            },' +
        '            \"claimSource\": \"string\",' +
        '            \"totalClaimAmt\": \"string\",' + 
        '            \"messages\":[{' +
        '                \"description\": \"Part # changed to universal PN\",' +
        '                \"code\": \"ODM-US-PA-WAR-402\",' +
        '                \"type\": \"WARNING\"' +
        '            },' +
        '            {' +
        '                \"description\": \"Part # changed to universal PN\",' +
        '                \"code\": \"ODM-US-PA-WAR-402\",' +
        '                \"type\": \"WARNING\"' +
        '            }],' +
        '            \"distributorCode\": \"string\",' +
        '            \"roNumber\": \"string\",' +
        '            \"serviceModelName\": \"string\",' +
        '            \"engineApplicationCode\": \"string\",' +
        '            \"warrantyStartDate\": \"2003-08-08T20:18:37-04:00\",' +
        '            \"serviceProvider\":{' +
        '                \"region\": \"string\",' +
        '                \"channelOfDistribution\": \"string\",' +
        '                \"regionCode\": \"string\",' +
        '                \"territory\": \"string\",' +
        '                \"status\": \"string\",' +
        '                \"inactiveDate\": \"2012-09-13T09:00:34-04:00\",' +
        '                \"outfileAllClaimsFlag\": \"string\",' +
        '                \"groupName\": \"string\",' +
        '                \"engineEffectiveDate\": \"string\",' +
        '                \"oemCode\": \"string\",' +
        '                \"paccarChecked\": \"string\",' +
        '                \"engineExpirationDate\": \"string\",' +
        '                \"serviceModelName\": \"string\",' +
        '                \"ltaChecked\": \"string\",' +
        '                \"channelDescription\": \"string\",' +
        '                \"claimAllowedDays\": 10' +
        '            },' +
        '            \"engineFamily\": \"string\",' +
        '            \"srtList\":{' +
        '                \"description\": \"string\",' +
        '                \"hours\": 150,' +
        '                \"offsiteCheck\": \"string\",' +
        '                \"lineNumber\": \"string\",' +
        '                \"quantity\": \"string\",' +
        '                \"code\": \"string\",' +
        '                \"srtAllowedFlag\": \"string\",' +
        '                \"penalty\": 3' +
        '            },' +
        '            \"failurePoint\": 10,' +
        '            \"ownerName\": \"string\",' +
        '            \"serviceProviderName\": \"string\",' +
        '            \"engine\":{' +
        '                \"productApplicationDesp\": \"string\",' +
        '                \"marineFlag\": \"string\",' +
        '                \"warrantyIndicatorFlag\": \"string\",' +
        '                \"buildDate\": \"2009-10-14T03:16:36\",' +
        '                \"billToCode\": \"string\",' +
        '                \"etoConversionDate\": \"2010-03-18T12:05:32\",' +
        '                \"serviceModel\": \"string\",' +
        '                \"designPhaseCode\": \"string\",' +
        '                \"engineFamilyCode\": \"string\",' +
        '                \"oemCode\": \"string\"' +
        '            },' +
        '            \"productApplicationCode\": \"string\",' +
        '            \"status\": \"string\",' +
        '            \"claimStatus\": \"string\",' +
        '            \"failureMeasure\": \"string\",' +
        '            \"claimSubmittedDate\": \"2014-09-18T19:18:33\",' +
        '            \"eto\":{' +
        '                \"status\": \"string\"' +
        '            },' +
        '            \"failure\":{' +
        '                \"campaignId\": \"string\",' +
        '                \"accountCodeDesp\": \"string\",' + 
        '                \"payCode\": \"string\",' +
        '                \"totalLaborAmt\": \"string\",' +
        '                \"status\": \"string\",' +
        '                \"authorizationNumber\": \"string\",' +
        '                \"approvalCode\": \"string\",' +
        '                \"acctCodeInfo\":{' +
        '                    \"chryslerFlag\": \"string\",' +
        '                    \"accountCodeType\": \"string\",' +
        '                    \"multiESNFlag\": \"string\"' +
        '                },' +
        '                \"totalTowingAmt\": \"string\",' +
        '                \"accountCode\": \"string\",' +
        '                \"failCode\": \"string\",' +
        '                \"coverageType\": \"string\",' +
        '                \"failMode\": \"string\",' +
        '                \"policyFlag\": \"string\",' +
        '                \"lineNumber\": \"string\",' +
        '                \"totalSRTHours\": \"string\",' +
        '                \"inShopCampaignFlag\": \"string\",' +
        '                \"campaign\":{' +
        '                    \"accountCode\": \"string\",' +
        '                    \"engineComponentCode\": \"string\",' +
        '                    \"campaignId\": \"string\",' +
        '                    \"completeIndicator\": \"string\",' +
        '                    \"campaignType\": \"string\",' +
        '                    \"status\": \"string\",' + 
        '                    \"systemCode\": \"string\",' +
        '                    \"failMode\": \"string\",' +
        '                    \"expiryDateNA\": \"2014-06-10T14:33:25-04:00\",' +
        '                    \"effectiveDate\": \"2018-12-28T14:51:14-05:00\",' +
        '                    \"multiFlag\": \"string\",' +
        '                    \"expiryDateIntl\": \"2017-11-01T04:15:53-04:00\"' +
        '                }' +
        '            },' +
        '            \"cmiServiceProviderCode\": \"string\",' +
        '            \"travels\":{' +
        '                \"mealsCharges\": 150,' +
        '                \"towingCharges\": 150,' +
        '                \"hours\": 150,' +
        '                \"lineNumber\": \"string\",' +
        '                \"travelDistance\": 150' +
        '            },' +
        '            \"otherClaimables\": {' +
        '                \"Amount\": \"string\",' +
        '                \"details\": \"string\",' +
        '                \"item\": \"string\",' +
        '                \"lineNumber\": \"string\"' +
        '            },' +
        '            \"manualAdjudicationFlag\": \"string\",' +
        '            \"claimCreatedDate\": \"2008-09-28T21:49:45\",' +
        '            \"bisFlag\": \"string\",' +
        '            \"claimNumber\": \"string\"' +
        '        }' +
        '    }' + 
        '}';
        CSS_WS_J2A_ODM_Validation obj = CSS_WS_J2A_ODM_Validation.parse(json);
        System.assert(obj != null);
    }
}