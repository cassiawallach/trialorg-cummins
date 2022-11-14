Public Class CSS_WS_CreateClaimSubmissionRequest{ 
    
    Public Static String createClaimSubmissionRequest(Map<String, String> header, List<String> complaints, List<String> promotionIds , List<Map<String, String>> multiESN, List<Map<String, String>> notes, List<Map<String, String>> failure, List<Map<String, String>> claimable, List<Map<String, String>> parts, List<Map<String, String>> srt, List<Map<String, String>> travel){//Method to create the JSON section for Claim Submission
        String json = '{'+
        '    \"Header\":{'+
        '        \"Sender\":{'+
        '            \"MessageID\": \"UniqueID\",'+
        '            \"ServiceName\": \"ClaimSubmission\",'+
        '            \"SenderID\": \"CSS\"'+
        '        },'+
        '        \"Target\":{'+
        '            \"TargetID\": \"CSSWarranty\"'+
        '        }'+
        '    },'+
        '    \"DataArea\":{'+
        '        \"ServiceProviderCode\": \"' + header.get('ServiceProviderCode') + '\",'+
        '        \"DistributorCode\": \"' + header.get('DistributorCode') + '\",'+
        '        \"EngineSerialNumber\": \"' + header.get('EngineSerialNumber') + '\",'+
        '        \"RONumber\": \"' + header.get('RONumber') + '\",'+
        '        \"WarrantyStartDate\": \"' + header.get('WarrantyStartDate') + '\",'+
        '        \"EngineApplicationCode\": \"' + header.get('EngineApplicationCode') + '\",'+
        '        \"Manufacturer\": \"' + header.get('Manufacturer') + '\",'+
        '        \"ModelSeries\": \"' + header.get('ModelSeries') + '\",'+
        '        \"FirstName\": \"' + header.get('FirstName') + '\",'+
        '        \"LastName\": \"' + header.get('LastName') + '\",'+
        '        \"BISFlag\": \"' + header.get('BISFlag') + '\",'+
        '        \"MultiESNFlg\": \"' + header.get('MultiESNFlg') + '\",'+
        '        \"CampaignNumber\": \"' + header.get('CampaignNumber') + '\",'+
        '        \"InfoOnlyFlag\": \"N\",'+
        '        \"NewPartsWarrantyFlg\": \"' + header.get('NewPartsWarrantyFlg') + '\",'+
        '        \"ReConPartsWarrantyFlg\": \"' + header.get('ReConPartsWarrantyFlg') + '\",'+
        '        \"RoadRelayWarrantyFlg\": \"' + header.get('RoadRelayWarrantyFlg') + '\",'+
        '        \"FailureDate\": \"' + header.get('FailureDate') + '\",'+
        '        \"FailurePoint\": \"' + header.get('FailurePoint') + '\",'+
        '        \"FailureMeasure\": \"' + CSS_WS_CreateODMRequest.getFailureMeasure(header.get('FailureMeasure')) + '\",'+
        '        \"MissionDisablingFlag\": \"' + header.get('MissionDisablingFlag') + '\",'+
        '        \"CatastrophicFlag\": \"' + header.get('CatastrophicFlag') + '\",'+
        '        \"RepairDescription\": \"' + header.get('RepairDescription') + '\",'+
        '        \"ReplacementPart\": \"' + header.get('ReplacementPart') + '\",'+
        '        \"SPCertifiedFlag\": \"N\",'+
        '        \"WarrantyTrainedFlag\": \"' + header.get('WarrantyTrainedFlag') + '\",'+
        '        \"CustomerPossession\": \"' + header.get('CustomerPossession') + '\",'+
        '        \"DISDNumber\": \"' + header.get('DISDNumber') + '\",'+
        '        \"CustomerName\": \"' + header.get('CustomerName') + '\",'+
        '        \"ECMCalibAfter\": \"' + header.get('ECMCalibAfter')+ '\",'+
        '        \"ReviewAfter\": \"' + header.get('ReviewAfter') + '\",'+
        '        \"ECMCalibBefore\": \"' + header.get('ECMCalibBefore') + '\",'+
        '        \"RevisionBefore\": \"' + header.get('RevisionBefore') + '\",'+
        '        \"Justification\": \"' + header.get('Justification') + '\",'+
        '        \"EngineVIN\": \"\",'+
        '        \"ESNCount\": \"' + header.get('ESNCount') + '\",'+
        '        \"TSRNumber\": \"' + header.get('TSRNumber') + '\",'+
        '        \"UnitNumber\": \"\",'+
        '        \"PaccarFlag\": \"N\",'+
        '        \"PenaltyFlag\": \"' + header.get('PenaltyFlag') + '\",'+
        '        \"SRTPenaltyPercentage\": \"' + header.get('SRTPenaltyPercentage') + '\",'+
        '        \"manualAdjudicationFlag\": \"' + header.get('manualAdjudicationFlag') + '\",'+
        '        \"DealerClaimNumber\": \"' + header.get('DealerClaimNumber')+ '\",'+
        '        \"ClaimSource\": \"MX\",'+
        '        \"ClaimFiledDate\": \"' + header.get('ClaimFiledDate') + '\",'+
        '        \"SPInShopLaborRate\": \"' + header.get('SPInShopLaborRate') + '\",'+
        '        \"SPLaborRate\": \"' + header.get('SPLaborRate') + '\",'+
        '        \"SPTravelRate\": \"' + header.get('SPTravelRate') + '\",'+
        '        \"Contact\": \"' + header.get('Contact') + '\",'+
        '        \"ListOfComplaintCodes\":{'+
        '            \"ComplaintCodes\":[';
        for(integer i=0; i < complaints.size(); i++){
            if(i > 0){
                json = json + ',';
            }
            json = json + '{\"ComplaintCode\": \"' + complaints[i] + '\"}';
        }
        json = json + ']' +
        '        },'+
        '        \"ListOfPromotionIds\":{' +
        '            \"PromotionIds\":[';
        for(integer i=0; i < promotionIds.size(); i++){
            if(i > 0){
                json = json + ',';
            }
            json = json + '{\"PromotionID\": \"' + promotionIds[i] + '\"}';
        }
        json =json + ']' +
        '},';
        if(multiESN.size() > 0){
            json = json +
            '        \"ListOfAdditionalESNs\": {'+
            '            \"AdditionalESNs\": [';
            for(integer i=0; i < multiESN.size(); i++){
                if(i > 0){
                    json = json + ',';
                }
                json = json + '{\"EngineSerialNumber\": \"' + multiESN[i].get('EngineSerialNumber') + '\",';
                json = json + '\"BISFlag\": \"' + multiESN[i].get('BISFlag') + '\",';
                json = json + '\"FailureDate\": \"' + multiESN[i].get('FailureDate') + '\",';
                json = json + '\"FailurePoint\": \"' + multiESN[i].get('FailurePoint') + '\",';
                json = json + '\"FailureMeasure\": \"' + CSS_WS_CreateODMRequest.getFailureMeasure(multiESN[i].get('FailureMeasure')) + '\",';
                json = json + '\"EngineVIN\": \"\",';
                json = json + '\"ECMCalibAfter\": \"' + multiESN[i].get('ECMCalibAfter') + '\",';
                json = json + '\"ReviewAfter\": \"' + multiESN[i].get('ReviewAfter') + '\",';
                json = json + '\"ECMCalibBefore\": \"' + multiESN[i].get('ECMCalibBefore') + '\",';
                json = json + '\"RevisionBefore\": \"' + multiESN[i].get('RevisionBefore') + '\",';
                json = json + '\"WarrantyStartDate\": \"' + multiESN[i].get('WarrantyStartDate') + '\"}';
            }
            json = json + ']' +
            '},';
        }
        json = json +
        '        \"ListOfNotes\": {'+
        '           \"Notes\": [';
        for(integer i=0 ; i < notes.size(); i++){
            if(i > 0){
                json = json + ',';
            }
            json = json + '{\"Note\": \"' + notes[i].get('Note') + '\",';
            json = json + '\"NoteType\": \"' + notes[i].get('NoteType') + '\"}';
        }
        json = json + ']' +
        '        },'+
        '        \"listOfFailureList\": {'+
        '            \"FailureList\": [';
        for(integer i=0 ; i < failure.size(); i++){
            if(i > 0){
                json = json + ',';
            }
            json = json + '{\"SystemCode\": \"' + failure[i].get('SystemCode') + '\",';
            json = json + '\"ComponentCode\": \"' + failure[i].get('ComponentCode') + '\",';
            json = json + '\"FailMode\": \"' + failure[i].get('FailMode') + '\",';
            json = json + '\"AccountCode\": \"' + failure[i].get('AccountCode') + '\",';
            json = json + '\"PayCode\": \"' + failure[i].get('PayCode') + '\",';
            json = json + '\"CertificateNumber\": \"' + failure[i].get('CertificateNumber') + '\",';
            json = json + '\"CampaignNumber\": \"' + failure[i].get('CampaignNumber') + '\",';
            json = json + '\"FaultCode\": \"\",';
            json = json + '\"WarrantyId\": \"' + failure[i].get('WarrantyId') + '\",';
            json = json + '\"ApproverCode\": \"' + failure[i].get('ApproverCode') + '\",';
            json = json + '\"CoverageType\": \"' + failure[i].get('CoverageType') + '\",';
            json = json + '\"CoveredLaborHours\": \"' + failure[i].get('CoveredLaborHours') + '\",';
            json = json + '\"CoveredMealsLodgingAmt\": \"' + failure[i].get('CoveredMealsLodgingAmt') + '\",';
            json = json + '\"CoveredOCAmount\": \"' + failure[i].get('CoveredOCAmount') + '\",';
            json = json + '\"CoveredPartsQuantity\": \"' + failure[i].get('CoveredPartsQuantity') + '\",';
            json = json + '\"CoveredTowingMiles\": \"' + failure[i].get('CoveredTowingMiles') + '\",';
            json = json + '\"CoveredTravelLabor\": \"' + failure[i].get('CoveredTravelLabor') + '\",';
            json = json + '\"CoveredTravelMiles\": \"' + failure[i].get('CoveredTravelMiles') + '\",';
            json = json + '\"DeductibleAmount\": \"' + failure[i].get('DeductibleAmount') + '\",';
            json = json + '\"AuthorizationNum\": \"' + failure[i].get('AuthorizationNum') + '\",';
            json = json + '\"CampaignLabourPrcnt\": \"' + failure[i].get('CampaignLabourPrcnt') + '\",';
            json = json + '\"CampaignOCPrcnt\": \"' + failure[i].get('CampaignOCPrcnt') + '\",';
            json = json + '\"CampaignPartsPrcnt\": \"' + failure[i].get('CampaignPartsPrcnt') + '\",';
            json = json + '\"CampaignTowingPrcnt\": \"' + failure[i].get('CampaignTowingPrcnt') + '\",';
            json = json + '\"CampaignTravelPrcnt\": \"' + failure[i].get('CampaignTravelPrcnt') + '\"';
            if(i == 0){//Only Sent Claimable, Parts, SRTs and Travel Information on Main Failure
                if(claimable.size() > 0){
                    json = json + '      ,\"listOfOtherClaimables\": {' +
                    '           \"OtherClaimables\": [';
                    for(integer j=0; j < claimable.size(); j++){
                        if(j > 0){
                            json = json + ',';
                        }
                        json = json + '{\"Item\": \"' + claimable[j].get('Item') + '\",';
                        json = json + '\"OtherClaimableDetails\": \"' + claimable[j].get('OtherClaimableDetails') + '\",';
                        json = json + '\"ClaimedReason\": \"' + claimable[j].get('ClaimedReason') + '\",';
                        json = json + '\"ClaimedAmount\": \"' + claimable[j].get('ClaimedAmount') + '\"}';
                    }
                    json = json + ']' +
                    '}';
                }
                if(parts.size() > 0){
                    json = json +'       ,\"listOfParts\": {'+
                    '           \"Parts\": [';
                    for(integer j=0; j < parts.size(); j++){
                        if(j > 0){
                            json = json + ',';
                        }
                        json = json + '{\"PartNumber\": \"' + parts[j].get('PartNumber') + '\",';
                        json = json + '\"QtyClaimed\": \"' + parts[j].get('QtyClaimed') + '\",';
                        json = json + '\"PartUnitPrice\": \"' + parts[j].get('PartUnitPrice') + '\",';
                        //json = json + '\"PartPercentage\": \"' + parts[j].get('PartPercentage') + '\",';
                        json = json + '\"PartPercentage\": \"100\",';
                        json = json + '\"PricebookName\": \"' + parts[j].get('PricebookName') + '\",';
                        json = json + '\"PartsReturnFlag\": \"' + parts[j].get('PartsReturnFlag') + '\",';
                        json = json + '\"RIDNumber\": \"' + parts[j].get('RIDNumber') + '\",';
                        json = json + '\"TrackingNumber\": \"' + parts[j].get('TrackingNumber') + '\",';
                        json = json + '\"WaiverProcess\": \"' + parts[j].get('WaiverProcess') + '\",';
                        json = json + '\"ReplacementReason\": \"' + parts[j].get('ReplacementReason') + '\"}';
                    }
                    json = json + ']' +
                    '       }';
                }
                if(srt.size() > 0){
                    json = json + '       ,\"listOfSRTs\": {'+
                    '           \"SRTs\": [';
                    for(integer j=0; j < srt.size(); j++){
                        if(j > 0){
                            json = json + ',';
                        }
                        json = json + '{\"SRTCode\": \"' + srt[j].get('SRTCode') + '\",';
                        json = json + '\"SRTAccessCode\": \"' + srt[j].get('SRTAccessCode') + '\",';
                        json = json + '\"Justification\": \"Mexico Claim\",';
                        json = json + '\"SRTHours\": \"' + srt[j].get('SRTHours') + '\",';
                        json = json + '\"SRTQty\": \"' + srt[j].get('SRTQty') + '\",';
                        json = json + '\"SRTPrcnt\": \"' + srt[j].get('SRTPrcnt') + '\",';
                        json = json + '\"OutOfChasis\": \"' + srt[j].get('OutOfChasis') + '\",';
                        json = json + '\"OverlapHrs\": \"' + srt[j].get('OverlapHrs') + '\",';
                        json = json + '\"Offiste\": \"' + srt[j].get('Offiste') + '\",';
                        json = json + '\"SRTType\": \"Custom\"}';
                    }
                    json = json + ']' +
                    '}';
                }
                if(travel.size() > 0){
                    json = json + '      ,\"listOfTravelDetails\": {'+
                    '           \"TravelDetails\": [';
                    for(integer j=0; j < travel.size(); j++){
                        if(j > 0){
                            json = json + ',';
                        }
                        json = json + '{\"TravelType\": \"' + travel[j].get('TravelType') + '\",';
                        json = json + '\"TravelMode\": \"' + travel[j].get('TravelMode') + '\",';
                        json = json + '\"OtherModeDetails\": \"' + travel[j].get('OtherModeDetails') + '\",';
                        json = json + '\"Hours\": \"' + travel[j].get('Hours') + '\",';
                        json = json + '\"Distance\": \"' + travel[j].get('Distance') + '\",';
                        json = json + '\"UOM\": \"Kilometers\",';
                        json = json + '\"MealsAmount\": \"' + travel[j].get('MealsAmount') + '\",';
                        json = json + '\"LodgingAmount\": \"\",';
                        json = json + '\"TowingAmount\": \"' + travel[j].get('TowingAmount') + '\"}';
                    }
                    json = json + ']' +
                    '}';
                }
            }
            json = json + '}';
        }
        json = json + ']' +
        '        }'+
        '    }'+         
        '}';
        return (json);
    }
}