@istest
public class CG_ODM_ResJSONParser_Test {
static testmethod void testmethod1()
{
    //string json ='{ "Header": { "Target": { "TargetID": "TargetID" }, "Sender": { "SenderID": "oh559", "ServiceName": "ServiceName" } }, "Response": { "claim": { "Engine": { "billToCode": "oh559", "warrantyIndicatorFlag": "oh559", "marineFlag": "oh559", "buildDate": "oh559", "productApplicationDesp": "oh559", "oemCode": "oh559", "designPhaseCode": "oh559", "engineFamilyCode": "oh559", "serviceModel": "oh559", "etoConversionDate": "oh559" }, "messages": [ { "description": "oh559", "code": "oh559", "type": "oh559" } ], "ServiceProvider": { "channelOfDistribution": "oh559", "region": "oh559", "claimAllowedDays": "oh559", "territory": "oh559", "outfileAllClaimsFlag": "oh559", "regionCode": "oh559", "inactiveDate": "oh559", "status": "oh559", "groupName": "oh559", "channelDescription": "oh559", "paccarChecked": "oh559", "ltaChecked": "oh559", "engineEffectiveDate": "oh559", "engineExpirationdate": "oh559", "serviceModelName": "oh559", "oemCode": "oh559", "spState": "oh559", "spCountry": "oh559", "spServiceLevel": "oh559", "spWarrantyTrainingStatus": "oh559", "spCertificationEndDate": "oh559", "spSCMDollarAmt": "oh559", "spSCMDeductiblePct": "oh559" }, "AdditionalESN": [ { "ESN": "oh559" } ], "ComplaintCode": { "code": "oh559" }, "Parts": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "oh559", "partId": "oh559", "partPrice": "oh559", "partName": "oh559", "reconPartFlag": "oh559", "priceBook": "oh559", "exceptionPriceBook": "oh559", "channelCode": "oh559", "standardPriceBook": "oh559", "pricingRegion": "oh559", "partAllowedFlag": "oh559", "partReturnFlag": "oh559", "qtyApproved": "oh559", "adjPartPercentage": "oh559" } ], "Failure": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "acctCodeInfo": { "accountCodeType": "oh559", "chryslerFlag": "oh559", "multiESNFlag": "oh559", "accountCodeWarrantyFlag": "oh559" }, "campaign": { "accountCode": "oh559", "campaignId": "oh559", "campaignType": "oh559", "completeIndicator": "oh559", "effectiveDate": "oh559", "engineComponentCode": "oh559", "expiryDateIntl": "oh559", "expiryDateNA": "oh559", "failMode": "oh559", "multiFlag": "oh559", "status": "oh559", "systemCode": "oh559", "cmpEngineStatusCode": "oh559" }, "lineNumber": "oh559", "failCode": "oh559", "failMode": "oh559", "accountCode": "oh559", "payCode": "oh559", "status": "oh559", "authorizationNumber": "oh559", "approvalCode": "oh559", "campaignId": "oh559", "coverageType": "oh559", "totalLaborAmt": "oh559", "totalSRTHours": "oh559", "totalTowingAmt": "oh559", "accountCodeDesp": "oh559", "policyFlag": "oh559", "programID": "oh559", "overrideFlag": "oh559", "inShopCampaignFlag": "oh559", "travelCoveredFlag": "oh559", "GSQID": "oh559" } ], "Otherables": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "oh559", "Item": "oh559", "details": "oh559", "amount": "oh559" } ], "Travels": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "oh559", "hours": "oh559", "mealsCharges": "oh559", "towingCharges": "oh559", "travelDistance": "oh559" } ], "SrtList": [ { "lineNumber": "oh559", "code": "oh559", "hours": "oh559", "offsiteCheck": "oh559", "description": "oh559", "quantity": "oh559", "srtAllowedFlag": "oh559" } ], "Number": "oh559", "Status": "oh559", "Source": "oh559", "cmiServiceProviderCode": "oh559", "serviceModelName": "oh559", "cmiEngineSerialNumber": "oh559", "productApplicationCode": "oh559", "warrantyStartDate": "oh559", "failureDate": "oh559", "CreatedDate": "oh559", "SubmittedDate": "oh559", "ReceivedDate": "oh559", "engineFamily": "oh559", "failurePoint": "oh559", "bisFlag": "oh559", "multiESNFlag": "oh559", "failureMeasure": "oh559", "reconPartsWarrantyFlag": "oh559", "manualAdjudicationFlag": "oh559", "roNumber": "oh559", "engineApplicationCode": "oh559", "serviceProviderName": "oh559", "distributorCode": "oh559", "totalAmt": "oh559", "groupName": "oh559", "thresholdAmount": "oh559", "thresholdHrs": "oh559", "approverName": "oh559", "level": "oh559", "button": "oh559", "newPartsWarrantyFlag": "oh559", "possessionFlag": "oh559", "ecmCalibBefore": "oh559", "ecmCalibAfter": "oh559", "manufacturer": "oh559", "paccarFlag": "oh559", "paccarCertifiedLocationFlag": "oh559", "paccarPaymentRoutingFlag": "oh559", "countryCode": "oh559", "ownerName": "oh559", "penalty": "oh559", "certificationFlag": "oh559", "roadRelayWarrantyFlag": "oh559", "headerCampaignId": "oh559", "modelSeries": "oh559", "applicationName": "oh559", "SubSource": "oh559" }, "DecisionID": "DecisionID" } }';
//string json = '{ "Header": { "Target": { "TargetID": "TargetID" }, "Sender": { "SenderID": "oh559", "ServiceName": "ServiceName" } }, "Response": { "claim": { "Engine": { "billToCode": "oh559", "warrantyIndicatorFlag": "oh559", "marineFlag": "oh559", "buildDate": "oh559", "productApplicationDesp": "oh559", "oemCode": "oh559", "designPhaseCode": "oh559", "engineFamilyCode": "oh559", "serviceModel": "oh559", "etoConversionDate": "oh559" }, "messages": [ { "description": "oh559", "code": "oh559", "type": "oh559" } ], "ServiceProvider": { "channelOfDistribution": "oh559", "region": "oh559", "claimAllowedDays": "oh559", "territory": "oh559", "outfileAllClaimsFlag": "oh559", "regionCode": "oh559", "inactiveDate": "oh559", "status": "oh559", "groupName": "oh559", "channelDescription": "oh559", "paccarChecked": "oh559", "ltaChecked": "oh559", "engineEffectiveDate": "oh559", "engineExpirationdate": "oh559", "serviceModelName": "oh559", "oemCode": "oh559", "spState": "oh559", "spCountry": "oh559", "spServiceLevel": "oh559", "spWarrantyTrainingStatus": "oh559", "spCertificationEndDate": "oh559", "spSCMDollarAmt": "oh559", "spSCMDeductiblePct": "oh559" }, "AdditionalESN": [ { "ESN": "oh559" } ], "ComplaintCode": { "code": "oh559" }, "Parts": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "oh559", "partId": "oh559", "partPrice": "oh559", "partName": "oh559", "reconPartFlag": "oh559", "priceBook": "oh559", "exceptionPriceBook": "oh559", "channelCode": "oh559", "standardPriceBook": "oh559", "pricingRegion": "oh559", "partAllowedFlag": "oh559", "partReturnFlag": "oh559", "qtyApproved": "oh559", "adjPartPercentage": "oh559" } ], "Failure": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "acctCodeInfo": { "accountCodeType": "oh559", "chryslerFlag": "oh559", "multiESNFlag": "oh559", "accountCodeWarrantyFlag": "oh559" }, "campaign": { "accountCode": "oh559", "campaignId": "oh559", "campaignType": "oh559", "completeIndicator": "oh559", "effectiveDate": "oh559", "engineComponentCode": "oh559", "expiryDateIntl": "oh559", "expiryDateNA": "oh559", "failMode": "oh559", "multiFlag": "oh559", "status": "oh559", "systemCode": "oh559", "cmpEngineStatusCode": "oh559" }, "lineNumber": "oh559", "failCode": "oh559", "failMode": "oh559", "accountCode": "oh559", "payCode": "oh559", "status": "oh559", "authorizationNumber": "oh559", "approvalCode": "oh559", "campaignId": "oh559", "coverageType": "oh559", "totalLaborAmt": "oh559", "totalSRTHours": "oh559", "totalTowingAmt": "oh559", "accountCodeDesp": "oh559", "policyFlag": "oh559", "programID": "oh559", "overrideFlag": "oh559", "inShopCampaignFlag": "oh559", "travelCoveredFlag": "oh559", "GSQID": "oh559" } ], "Otherables": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "oh559", "Item": "oh559", "details": "oh559", "amount": "oh559" } ], "Travels": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "oh559", "hours": "oh559", "mealsCharges": "oh559", "towingCharges": "oh559", "travelDistance": "oh559" } ], "SrtList": [ { "lineNumber": "oh559", "code": "oh559", "hours": "oh559", "offsiteCheck": "oh559", "description": "oh559", "quantity": "oh559", "srtAllowedFlag": "oh559" } ], "Number": "oh559", "Status": "oh559", "Source": "oh559", "cmiServiceProviderCode": "oh559", "serviceModelName": "oh559", "cmiEngineSerialNumber": "oh559", "productApplicationCode": "oh559", "warrantyStartDate": "oh559", "failureDate": "oh559", "CreatedDate": "oh559", "SubmittedDate": "oh559", "ReceivedDate": "oh559", "engineFamily": "oh559", "failurePoint": "oh559", "bisFlag": "oh559", "multiESNFlag": "oh559", "failureMeasure": "oh559", "reconPartsWarrantyFlag": "oh559", "manualAdjudicationFlag": "oh559", "roNumber": "oh559", "engineApplicationCode": "oh559", "serviceProviderName": "oh559", "distributorCode": "oh559", "totalAmt": "oh559", "groupName": "oh559", "thresholdAmount": "oh559", "thresholdHrs": "oh559", "approverName": "oh559", "level": "oh559", "button": "oh559", "newPartsWarrantyFlag": "oh559", "possessionFlag": "oh559", "ecmCalibBefore": "oh559", "ecmCalibAfter": "oh559", "manufacturer": "oh559", "paccarFlag": "oh559", "paccarCertifiedLocationFlag": "oh559", "paccarPaymentRoutingFlag": "oh559", "countryCode": "oh559", "ownerName": "oh559", "penalty": "oh559", "certificationFlag": "oh559", "roadRelayWarrantyFlag": "oh559", "headerCampaignId": "oh559", "modelSeries": "oh559", "applicationName": "oh559", "SubSource": "oh559" }, "DecisionID": "DecisionID" } }';
   //string json = '{ "Header": { "Target": { "TargetID": "TargetID" }, "Sender": { "SenderID": "oh559", "ServiceName": "ServiceName" } }, "Response": { "claim": { "Engine": { "billToCode": "oh559", "warrantyIndicatorFlag": "oh559", "marineFlag": "oh559", "buildDate": "oh559", "productApplicationDesp": "oh559", "oemCode": "oh559", "designPhaseCode": "oh559", "engineFamilyCode": "oh559", "serviceModel": "oh559", "etoConversionDate": "oh559" }, "messages": [ { "description": "oh559", "code": "oh559", "type": "oh559" } ], "ServiceProvider": { "channelOfDistribution": "oh559", "region": "oh559", "claimAllowedDays": "oh559", "territory": "oh559", "outfileAllClaimsFlag": "oh559", "regionCode": "oh559", "inactiveDate": "oh559", "status": "oh559", "groupName": "oh559", "channelDescription": "oh559", "paccarChecked": "oh559", "ltaChecked": "oh559", "engineEffectiveDate": "oh559", "engineExpirationdate": "oh559", "serviceModelName": "oh559", "oemCode": "oh559", "spState": "oh559", "spCountry": "oh559", "spServiceLevel": "oh559", "spWarrantyTrainingStatus": "oh559", "spCertificationEndDate": "oh559", "spSCMDollarAmt": "oh559", "spSCMDeductiblePct": "oh559" }, "AdditionalESN": [ { "ESN": "oh559" } ], "ComplaintCode": { "code": "oh559" }, "Parts": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "oh559", "partId": "oh559", "partPrice": "oh559", "partName": "oh559", "reconPartFlag": "oh559", "priceBook": "oh559", "exceptionPriceBook": "oh559", "channelCode": "oh559", "standardPriceBook": "oh559", "pricingRegion": "oh559", "partAllowedFlag": "oh559", "partReturnFlag": "oh559", "qtyApproved": "oh559", "adjPartPercentage": "oh559" } ], "Failure": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "acctCodeInfo": { "accountCodeType": "oh559", "chryslerFlag": "oh559", "multiESNFlag": "oh559", "accountCodeWarrantyFlag": "oh559" }, "campaign": { "accountCode": "oh559", "campaignId": "oh559", "campaignType": "oh559", "completeIndicator": "oh559", "effectiveDate": "oh559", "engineComponentCode": "oh559", "expiryDateIntl": "oh559", "expiryDateNA": "oh559", "failMode": "oh559", "multiFlag": "oh559", "status": "oh559", "systemCode": "oh559", "cmpEngineStatusCode": "oh559" }, "lineNumber": "oh559", "failCode": "oh559", "failMode": "oh559", "accountCode": "oh559", "payCode": "oh559", "status": "oh559", "authorizationNumber": "oh559", "approvalCode": "oh559", "campaignId": "oh559", "coverageType": "oh559", "totalLaborAmt": "oh559", "totalSRTHours": "oh559", "totalTowingAmt": "oh559", "accountCodeDesp": "oh559", "policyFlag": "oh559", "programID": "oh559", "overrideFlag": "oh559", "inShopCampaignFlag": "oh559", "travelCoveredFlag": "oh559", "GSQID": "oh559" } ], "Otherables": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "oh559", "Item": "oh559", "details": "oh559", "amount": "oh559" } ], "Travels": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "oh559", "hours": "oh559", "mealsCharges": "oh559", "towingCharges": "oh559", "travelDistance": "oh559" } ], "SrtList": [ { "lineNumber": "oh559", "code": "oh559", "hours": "oh559", "offsiteCheck": "oh559", "description": "oh559", "quantity": "oh559", "srtAllowedFlag": "oh559" } ], "Number": "oh559", "Status": "oh559", "Source": "oh559", "cmiServiceProviderCode": "oh559", "serviceModelName": "oh559", "cmiEngineSerialNumber": "oh559", "productApplicationCode": "oh559", "warrantyStartDate": "oh559", "failureDate": "oh559", "CreatedDate": "oh559", "SubmittedDate": "oh559", "ReceivedDate": "oh559", "engineFamily": "oh559", "failurePoint": "oh559", "bisFlag": "oh559", "multiESNFlag": "oh559", "failureMeasure": "oh559", "reconPartsWarrantyFlag": "oh559", "manualAdjudicationFlag": "oh559", "roNumber": "oh559", "engineApplicationCode": "oh559", "serviceProviderName": "oh559", "distributorCode": "oh559", "totalAmt": "oh559", "groupName": "oh559", "thresholdAmount": "oh559", "thresholdHrs": "oh559", "approverName": "oh559", "level": "oh559", "button": "oh559", "newPartsWarrantyFlag": "oh559", "possessionFlag": "oh559", "ecmCalibBefore": "oh559", "ecmCalibAfter": "oh559", "manufacturer": "oh559", "paccarFlag": "oh559", "paccarCertifiedLocationFlag": "oh559", "paccarPaymentRoutingFlag": "oh559", "countryCode": "oh559", "ownerName": "oh559", "penalty": "oh559", "certificationFlag": "oh559", "roadRelayWarrantyFlag": "oh559", "headerCampaignId": "oh559", "modelSeries": "oh559", "applicationName": "oh559", "SubSource": "oh559" }, "DecisionID": "DecisionID" } }';
    //string json = '{ "Header": { "Target": { "TargetID": "TargetID" }, "Sender": { "SenderID": "oh559", "ServiceName": "ServiceName" } }, "Response": { "claim": { "Engine": { "billToCode": "oh559", "warrantyIndicatorFlag": "oh559", "marineFlag": "oh559", "buildDate": "oh559", "productApplicationDesp": "oh559", "oemCode": "oh559", "designPhaseCode": "oh559", "engineFamilyCode": "oh559", "serviceModel": "oh559", "etoConversionDate": "oh559" }, "messages": [ { "messageID":"sfdsfsd","description": "oh559", "code": "oh559", "type": "oh559" } ], "ServiceProvider": { "channelOfDistribution": "oh559", "region": "oh559", "claimAllowedDays": "oh559", "territory": "oh559", "outfileAllClaimsFlag": "oh559", "regionCode": "oh559", "inactiveDate": "oh559", "status": "oh559", "groupName": "oh559", "channelDescription": "oh559", "paccarChecked": "oh559", "ltaChecked": "oh559", "engineEffectiveDate": "oh559", "engineExpirationdate": "oh559", "serviceModelName": "oh559", "oemCode": "oh559", "spState": "oh559", "spCountry": "oh559", "spServiceLevel": "oh559", "spWarrantyTrainingStatus": "oh559", "spCertificationEndDate": "oh559", "spSCMDollarAmt": "oh559", "spSCMDeductiblePct": "oh559" }, "AdditionalESN": [ { "ESN": "oh559" } ], "ComplaintCode": { "code": "oh559" }, "Parts": [ { "messages": [{ "partSRTCode":"sfdsfsd","description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "oh559", "partId": "oh559", "partPrice": "oh559", "partName": "oh559", "reconPartFlag": "oh559", "priceBook": "oh559", "exceptionPriceBook": "oh559", "channelCode": "oh559", "standardPriceBook": "oh559", "pricingRegion": "oh559", "partAllowedFlag": "oh559", "partReturnFlag": "oh559", "qtyApproved": "oh559", "adjPartPercentage": "oh559", "MCEPSelectionFlag": "N", "NXpartId": "", "NXpartPrice": "", "NXpriceBookName": "", "RXpartId": "", "RXpartPrice": "", "RXpriceBookName": "" } ], "Failure": [ { "messages": [{ "partSRTCode":"sfdsfsd","description": "oh559", "code": "oh559", "type": "oh559" }], "acctCodeInfo": { "accountCodeType": "oh559", "chryslerFlag": "oh559", "multiESNFlag": "oh559", "accountCodeWarrantyFlag": "oh559" }, "campaign": { "accountCode": "oh559", "campaignId": "oh559", "campaignType": "oh559", "completeIndicator": "oh559", "effectiveDate": "oh559", "engineComponentCode": "oh559", "expiryDateIntl": "oh559", "expiryDateNA": "oh559", "failMode": "oh559", "multiFlag": "oh559", "status": "oh559", "systemCode": "oh559", "cmpEngineStatusCode": "oh559" }, "lineNumber": "oh559", "failCode": "oh559", "failMode": "oh559", "accountCode": "oh559", "payCode": "oh559", "status": "oh559", "authorizationNumber": "oh559", "approvalCode": "oh559", "campaignId": "oh559", "coverageType": "oh559", "totalLaborAmt": "oh559", "totalSRTHours": "oh559", "totalTowingAmt": "oh559", "accountCodeDesp": "oh559", "policyFlag": "oh559", "programID": "oh559", "overrideFlag": "oh559", "inShopCampaignFlag": "oh559", "travelCoveredFlag": "oh559", "GSQID": "oh559" } ], "OtherClaimables": [ { "messages": { "partSRTCode":"sfdsfsd","description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "oh559", "Item": "oh559", "details": "oh559", "amount": "oh559" } ], "Travels": [ { "messages": [{ "partSRTCode":"sfdsfsd","description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "oh559", "hours": "oh559", "mealsCharges": "oh559", "towingCharges": "oh559", "travelDistance": "oh559" } ], "SrtList": [ {"messages": [{ "partSRTCode":"sfdsfsd","description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "oh559", "code": "oh559", "hours": "oh559", "offsiteCheck": "oh559", "description": "oh559", "quantity": "oh559", "srtAllowedFlag": "oh559" } ], "claimNumber": "oh559", "claimStatus": "oh559", "claimSource": "oh559", "cmiServiceProviderCode": "oh559", "serviceModelName": "oh559", "cmiEngineSerialNumber": "oh559", "productApplicationCode": "oh559", "warrantyStartDate": "oh559", "failureDate": "oh559", "claimCreatedDate": "oh559", "claimSubmittedDate": "oh559", "claimReceivedDate": "oh559", "engineFamily": "oh559", "failurePoint": "oh559", "bisFlag": "oh559", "multiESNFlag": "oh559", "failureMeasure": "oh559", "reconPartsWarrantyFlag": "oh559", "manualAdjudicationFlag": "oh559","Status":"safaaf", "roNumber": "oh559", "engineApplicationCode": "oh559", "serviceProviderName": "oh559", "distributorCode": "oh559", "totalClaimAmt": "oh559", "groupName": "oh559", "thresholdAmount": "oh559", "thresholdHrs": "oh559", "approverName": "oh559", "level": "oh559", "button": "oh559", "newPartsWarrantyFlag": "oh559", "possessionFlag": "oh559", "ecmCalibBefore": "oh559", "ecmCalibAfter": "oh559", "manufacturer": "oh559", "paccarFlag": "oh559", "paccarCertifiedLocationFlag": "oh559", "paccarPaymentRoutingFlag": "oh559", "countryCode": "oh559", "HeaderCampaign": "oh559", "penalty": "oh559", "certificationFlag": "oh559", "roadRelayWarrantyFlag": "oh559", "headerCampaignId": "oh559", "modelSeries": "oh559", "applicationName": "oh559", "claimSubSource": "oh559", "MCEPFlag": "Y" }, "DecisionID": "DecisionID" } }';
    CG_ODM_ResJSONParser.messages msgs = new CG_ODM_ResJSONParser.messages();
    msgs.messageID = 'uagsh';
    msgs.description = 'sadfasafs';
    msgs.code='dhdhdf';
    msgs.type ='iuhj'; 
    
    
    CG_ODM_ResJSONParser.message msg = new CG_ODM_ResJSONParser.message();
    msg.partSRTCode = 'uagsh';
    msg.description = 'sadfasafs';
    msg.code='dhdhdf';
    msg.type ='iuhj'; 
    String json=		'{"Header": {'+
		'        "Target": {'+
		'            "TargetID": "TargetID"'+
		'        },'+
		'        "Sender": {'+
		'            "SenderID": "oh559",'+
		'            "ServiceName": "ServiceName"'+
		'        }'+
		'    },'+
		'    "Response": {'+
		'        "claim": {'+
		'            "Engine": {'+
		'                "billToCode": "oh559",'+
		'                "warrantyIndicatorFlag": "oh559",'+
		'                "marineFlag": "oh559",'+
		'                "buildDate": "oh559",'+
		'                "productApplicationDesp": "oh559",'+
		'                "oemCode": "oh559",'+
		'                "designPhaseCode": "oh559",'+
		'                "engineFamilyCode": "oh559",'+
		'                "serviceModel": "oh559",'+
		'                "etoConversionDate": "oh559"'+
		'            },'+
		'            "CG_ODM_ResJSONParser.messages": [{'+
		'				"messageID":"sfdsfsd",'+
		'                "description": "oh559",'+
		'                "code": "oh559",'+
		'                "type": "oh559"'+
		'            }],'+
		'            "ServiceProvider": {'+
		'                "channelOfDistribution": "oh559",'+
		'                "region": "oh559",'+
		'                "claimAllowedDays": "oh559",'+
		'                "territory": "oh559",'+
		'                "outfileAllClaimsFlag": "oh559",'+
		'                "regionCode": "oh559",'+
		'                "inactiveDate": "oh559",'+
		'                "status": "oh559",'+
		'                "groupName": "oh559",'+
		'                "channelDescription": "oh559",'+
		'                "paccarChecked": "oh559",'+
		'                "ltaChecked": "oh559",'+
		'                "engineEffectiveDate": "oh559",'+
		'                "engineExpirationdate": "oh559",'+
		'                "serviceModelName": "oh559",'+
		'                "oemCode": "oh559",'+
		'                "spState": "oh559",'+
		'                "spCountry": "oh559",'+
		'                "spServiceLevel": "oh559",'+
		'                "spWarrantyTrainingStatus": "oh559",'+
		'                "spCertificationEndDate": "oh559",'+
		'                "spSCMDollarAmt": "oh559",'+
		'                "spSCMDeductiblePct": "oh559"'+
		'            },'+
		'            "AdditionalESN": [{'+
		'                "ESN": "oh559"'+
		'            }],'+
		'            "ComplaintCode": {'+
		'                "code": "oh559"'+
		'            },'+
		'            "Parts": [{'+
		'                "CG_ODM_ResJSONParser.messages": [{'+
		'					"partSRTCode":"sfdsfsd",'+
		'                    "description": "oh559",'+
		'                    "code": "oh559",'+
		'                    "type": "oh559"'+
		'                }],'+
		'                "lineNumber": "oh559",'+
		'                "partId": "oh559",'+
		'                "partPrice": "oh559",'+
		'                "partName": "oh559",'+
		'                "reconPartFlag": "oh559",'+
		'                "priceBook": "oh559",'+
		'                "exceptionPriceBook": "oh559",'+
		'                "channelCode": "oh559",'+
		'                "standardPriceBook": "oh559",'+
		'                "pricingRegion": "oh559",'+
		'                "partAllowedFlag": "oh559",'+
		'                "partReturnFlag": "oh559",'+
		'                "qtyApproved": "oh559",'+
		'                "adjPartPercentage": "oh559",'+
		'                "MCEPSelectionFlag": "N",'+
		'                "NXpartId": "",'+
		'                "NXpartPrice": "",'+
		'                "NXpriceBookName": "",'+
		'                "RXpartId": "",'+
		'                "RXpartPrice": "",'+
		'                "RXpriceBookName": ""'+
		'            }],'+
		'            "Failure": [{'+
		'                "CG_ODM_ResJSONParser.messages": [{'+
		'					"partSRTCode":"sfdsfsd",'+
		'                    "description": "oh559",'+
		'                    "code": "oh559",'+
		'                    "type": "oh559"'+
		'                }],'+
		'                "acctCodeInfo": {'+
		'                    "accountCodeType": "oh559",'+
		'                    "chryslerFlag": "oh559",'+
		'                    "multiESNFlag": "oh559",'+
		'                    "accountCodeWarrantyFlag": "oh559"'+
		'                },'+
		'                "campaign": {'+
		'                    "accountCode": "oh559",'+
		'                    "campaignId": "oh559",'+
		'                    "campaignType": "oh559",'+
		'                    "completeIndicator": "oh559",'+
		'                    "effectiveDate": "oh559",'+
		'                    "engineComponentCode": "oh559",'+
		'                    "expiryDateIntl": "oh559",'+
		'                    "expiryDateNA": "oh559",'+
		'                    "failMode": "oh559",'+
		'                    "multiFlag": "oh559",'+
		'                    "status": "oh559",'+
		'                    "systemCode": "oh559",'+
		'                    "cmpEngineStatusCode": "oh559"'+
		'                },'+
		'                "lineNumber": "oh559",'+
		'                "failCode": "oh559",'+
		'                "failMode": "oh559",'+
		'                "accountCode": "oh559",'+
		'                "payCode": "oh559",'+
		'                "status": "oh559",'+
		'                "authorizationNumber": "oh559",'+
		'                "approvalCode": "oh559",'+
		'                "campaignId": "oh559",'+
		'                "coverageType": "oh559",'+
		'                "totalLaborAmt": "oh559",'+
		'                "totalSRTHours": "oh559",'+
		'                "totalTowingAmt": "oh559",'+
		'                "accountCodeDesp": "oh559",'+
		'                "policyFlag": "oh559",'+
		'                "programID": "oh559",'+
		'                "overrideFlag": "oh559",'+
		'                "inShopCampaignFlag": "oh559",'+
		'                "travelCoveredFlag": "oh559",'+
		'                "GSQID": "oh559"'+
		'            }],'+
		'            "OtherClaimables": [{'+
		'                "CG_ODM_ResJSONParser.messages": {'+
		'					"partSRTCode":"sfdsfsd",'+
		'                    "description": "oh559",'+
		'                    "code": "oh559",'+
		'                    "type": "oh559"'+
		'                },'+
		'                "lineNumber": "oh559",'+
		'                "Item": "oh559",'+
		'                "details": "oh559",'+
		'                "amount": "oh559"'+
		'            }],'+
		'            "Travels": [{'+
		'                "CG_ODM_ResJSONParser.messages": [{'+
		'					"partSRTCode":"sfdsfsd",'+
		'                    "description": "oh559",'+
		'                    "code": "oh559",'+
		'                    "type": "oh559"'+
		'                }],'+
		'                "lineNumber": "oh559",'+
		'                "hours": "oh559",'+
		'                "mealsCharges": "oh559",'+
		'                "towingCharges": "oh559",'+
		'                "travelDistance": "oh559"'+
		'            }],'+
		'            "SrtList": [{'+
		'				"CG_ODM_ResJSONParser.messages": [{'+
		'					"partSRTCode":"sfdsfsd",'+
		'                    "description": "oh559",'+
		'                    "code": "oh559",'+
		'                    "type": "oh559"'+
		'                }],'+
		'                "lineNumber": "oh559",'+
		'                "code": "oh559",'+
		'                "hours": "oh559",'+
		'                "offsiteCheck": "oh559",'+
		'                "description": "oh559",'+
		'                "quantity": "oh559",'+
		'                "srtAllowedFlag": "oh559"'+
		'            }],'+
		'            "claimNumber": "oh559",'+
		'            "claimStatus": "oh559",'+
		'            "claimSource": "oh559",'+
		'            "cmiServiceProviderCode": "oh559",'+
		'            "serviceModelName": "oh559",'+
		'            "cmiEngineSerialNumber": "oh559",'+
		'            "productApplicationCode": "oh559",'+
		'            "warrantyStartDate": "oh559",'+
		'            "failureDate": "oh559",'+
		'            "claimCreatedDate": "oh559",'+
		'            "claimSubmittedDate": "oh559",'+
		'            "claimReceivedDate": "oh559",'+
		'            "engineFamily": "oh559",'+
		'            "failurePoint": "oh559",'+
		'            "bisFlag": "oh559",'+
		'            "multiESNFlag": "oh559",'+
		'            "failureMeasure": "oh559",'+
		'            "reconPartsWarrantyFlag": "oh559",'+
		'            "manualAdjudicationFlag": "oh559",'+
		'			"Status":"safaaf",'+
		'            "roNumber": "oh559",'+
		'            "engineApplicationCode": "oh559",'+
		'            "serviceProviderName": "oh559",'+
		'            "distributorCode": "oh559",'+
		'            "totalClaimAmt": "oh559",'+
		'            "groupName": "oh559",'+
		'            "thresholdAmount": "oh559",'+
		'            "thresholdHrs": "oh559",'+
		'            "approverName": "oh559",'+
		'            "level": "oh559",'+
		'            "button": "oh559",'+
		'            "newPartsWarrantyFlag": "oh559",'+
		'            "possessionFlag": "oh559",'+
		'            "ecmCalibBefore": "oh559",'+
		'            "ecmCalibAfter": "oh559",'+
		'            "manufacturer": "oh559",'+
		'            "paccarFlag": "oh559",'+
		'            "paccarCertifiedLocationFlag": "oh559",'+
		'            "paccarPaymentRoutingFlag": "oh559",'+
		'            "countryCode": "oh559",'+
		'            "HeaderCampaign": "oh559",'+
		'            "penalty": "oh559",'+
		'            "certificationFlag": "oh559",'+
		'            "roadRelayWarrantyFlag": "oh559",'+
		'            "headerCampaignId": "oh559",'+
		'            "modelSeries": "oh559",'+
		'            "applicationName": "oh559",'+
		'            "claimSubSource": "oh559",'+
		'            "MCEPFlag": "Y"'+
		'        },'+
		'        "DecisionID": "DecisionID"'+
		'    }'+
		'}';

    CG_ODM_ResJSONParser resp = CG_ODM_ResJSONParser.parse(json);
    
    
    
}
}