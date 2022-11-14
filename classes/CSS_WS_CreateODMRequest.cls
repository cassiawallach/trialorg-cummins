Public Class CSS_WS_CreateODMRequest{ 

    Public Static String createODMHeaderRequest(Map<String,String> header){//Method for creating the JSON Request, it just contains the Header section    
        String jsonRequest = createODMHeaderSection(header);
        String jsonEnd = createODMEndSection();
        jsonRequest = jsonRequest + jsonEnd;
        return jsonRequest;
    }
    
    Public Static String createODMFailureRequest(Map<String,String> header, List<Map<String,String>> failure){//Method for creating the JSON Request, it contains the Header and Failure sections     
        String jsonRequest = createODMHeaderSection(header);
        String jsonFailure = createODMFailureSection(failure);
        String jsonEnd = createODMEndSection();
        jsonRequest = jsonRequest + ',' + jsonFailure + jsonEnd;
        return jsonRequest;
    }

    Public Static String createODMPartsRequest(Map<String,String> header, List<Map<String,String>> failure, List<Map<String,String>> parts){//Method for creating the JSON Request, it contains the Header and Parts sections      
        String jsonRequest = createODMHeaderSection(header);
        String jsonFailure = createODMFailureSection(failure);
        String jsonParts = createODMPartsSection(parts);
        String jsonEnd = createODMEndSection();
        jsonRequest = jsonRequest + ',' + jsonFailure + ',' + jsonParts + jsonEnd;
        return jsonRequest;
    }
    
    Public Static String createODMTravelRequest(Map<String,String> header, List<Map<String,String>> failure, List<Map<String,String>> travel){//Method for creating the JSON Request, it contains the Header and Travels sections       
        String jsonRequest = createODMHeaderSection(header);
        String jsonFailure = createODMFailureSection(failure);
        String jsonTravel = createODMTravelSection(travel);
        String jsonEnd = createODMEndSection();
        jsonRequest = jsonRequest + ',' + jsonFailure + ',' + jsonTravel + jsonEnd;
        return jsonRequest;
    }
    
    Public Static String createODMClaimableRequest(Map<String,String> header, List<Map<String,String>> failure, List<Map<String,String>> claimable){//Method for creating the JSON Request, it contains the Header and Claimable sections
        String jsonRequest = createODMHeaderSection(header);
        String jsonFailure = createODMFailureSection(failure);
        String jsonClaimable = createODMClaimableSection(claimable);
        String jsonEnd = createODMEndSection();
        jsonRequest = jsonRequest + ',' + jsonFailure + ',' + jsonClaimable + jsonEnd;
        return jsonRequest;
    }
    
    Public Static String createODMSRTRequest(Map<String,String> header, List<Map<String,String>> failure, List<Map<String,String>> srt){//Method for creating the JSON Request, it contains the Header and SRT sections        
        String jsonRequest = createODMHeaderSection(header);
        String jsonFailure = createODMFailureSection(failure);
        String jsonSRT = createODMSRTSection(srt);
        String jsonEnd = createODMEndSection();
        jsonRequest = jsonRequest + ',' + jsonFailure + ',' + jsonSRT + jsonEnd;
        return jsonRequest;
    }
    
    Public Static String createODMCompleteRequest(Map<String,String> header, List<Map<String,String>> failure, List<Map<String,String>> parts, List<Map<String,String>> travel, List<Map<String,String>> claimable, List<Map<String,String>> srt){//Method for creating the JSON Request, it contains the All sections that are required for Pre-Submit operation
        String jsonRequest = createODMHeaderSection(header);
        String jsonFailure = createODMFailurePreSubmitSection(failure, parts, travel, claimable, srt);
        String jsonEnd = createODMEndSection();
        jsonRequest = jsonRequest + ',' + jsonFailure + jsonEnd;
        return jsonRequest;
    }
        
    Public Static String createODMHeaderSection(Map <String,String> header){//Method to create the JSON section for Header
        String json = '{' +
        '    \"Request\":{' +
        '        \"DecisionID\": \"SalesforceMX\",' +
        '        \"claim\":{' +
        '            \"claimSource\": \"MX\",' +
        '            \"claimSubSource\": \"\",' +
        '            \"claimStatus\": \"Draft\",' +   
        '            \"claimSubmittedDate\": \"\",' +
        '            \"claimCreatedDate\": \"' + CSS_WS_ControllerClaim.dateToString(System.Now(), 'MM/dd/YYYY') + '\",' +
        '            \"bisFlag\": \"' + header.get('bisFlag') + '\",' +
        '            \"claimNumber\": \"Draft\",' +
        '            \"IEEWflag\": \"\",' +
        '            \"IEEWadjudicationFlag\": \"\",' +
        '            \"cmiEngineSerialNumber\": \"' + header.get('cmiEngineSerialNumber') + '\",' +
        '            \"cmiServiceProviderCode\": \"' + header.get('cmiServiceProviderCode') + '\",' +
        '            \"engineFamily\": \"' + header.get('engineFamily') + '\",' +
        '            \"failureDate\": \"' + header.get('failureDate') + '\",' +
        '            \"failureMeasure\": \"' + getFailureMeasure(header.get('failureMeasure')) + '\",' +
        '            \"failurePoint\": \"' + header.get('failurePoint') + '\",' +
        '            \"manualAdjudicationFlag\": \"' + header.get('manualAdjudicationFlag') + '\",' +
        '            \"multiESNFlag\": \"' + header.get('multiESNFlag') + '\",' +
        '            \"productApplicationCode\": \"' + (header.get('productApplicationCode') != null ?header.get('productApplicationCode'):'' ) + '\",' +
        '            \"reconPartsWarrantyFlag\": \"' + header.get('reconPartsWarrantyFlag') + '\",' +
        '            \"newPartsWarrantyFlag\": \"' + header.get('newPartsWarrantyFlag') + '\",' +
        '            \"roNumber\": \"' + header.get('roNumber') + '\",' +
        '            \"serviceModelName\": \"' + header.get('serviceModelName') + '\",' +
        '            \"warrantyStartDate\": \"' + header.get('warrantyStartDate') + '\",' +
        '            \"totalClaimAmt\": \"' + ((header.get('totalClaimAmt') != null )?header.get('totalClaimAmt'):'') + '\",' +
        '            \"penalty\": \"0\",' +  
        '            \"engineApplicationCode\": \"' + header.get('engineApplicationCode') + '\",' +
        '            \"roadRelayWarrantyFlag\": \"' + (header.get('roadRelayWarrantyFlag') != null ?header.get('roadRelayWarrantyFlag'):'' ) + '\",' +
        '        \"serviceProvider\":{' +
        '            \"region\": \"' + header.get('region') + '\",' +
        '            \"channelOfDistribution\": \"' + header.get('channelOfDistribution') + '\",' +
        '            \"regionCode\": \"' + header.get('regionCode') + '\",' +
        '            \"territory\": \"' + header.get('territory') + '\",' +
        '            \"outfileAllClaimsFlag\": \"' + header.get('outfileAllClaimsFlag')+ '\",' +
        '            \"claimAllowedDays\": \"' + header.get('claimAllowedDays')+ '\"' +
        '        },' +
        '        \"engine\":{' +
        '            \"engineFamilyCode\": \"' + header.get('engineFamilyCode') + '\",' +
        '            \"marineFlag\": \"' + header.get('marineFlag') + '\",' +
        '            \"buildDate\": \"' + header.get('buildDate') + '\",' +
        '            \"etoConversionDate\": \"' + header.get('etoConversionDate') + '\",' +
        '            \"warrantyIndicatorFlag\": \"' + header.get('warrantyIndicatorFlag') + '\",' +
        '            \"productApplicationDesp\": \"' + header.get('productApplicationDesp')+ '\"' +
        '        }';
        return json;
    }
    
    Public Static String createODMFailureSection(List<Map<String,String>> failure){//Method to create the JSON section for Failure
        String json = '\"failure\":[';
        for(integer i=0; i < failure.size(); i++){
            if(i > 0){
                break;
                //json = json + ',';
            }
            json = json + '{\"campaignId\": \"' + failure[i].get('campaignId') + '\",';
            json = json + '\"payCode\": \"' + failure[i].get('payCode') + '\",';
            json = json + '\"inShopCampaignFlag\": \"' + failure[i].get('inShopCampaignFlag') + '\",';
            json = json + '\"totalLaborAmt\": \"' + failure[i].get('totalLaborAmt') + '\",';
            json = json + '\"status\": \"Draft\",';
            json = json + '\"authorizationNumber\": \"' + failure[i].get('authorizationNumber') + '\",';
            json = json + '\"approvalCode\": \"' + failure[i].get('approvalCode') + '\",';
            json = json + '\"totalTowingAmt\": \"' + failure[i].get('totalTowingAmt') + '\",';
            json = json + '\"accountCode\": \"' + failure[i].get('accountCode') + '\",';
            json = json + '\"failCode\": \"' + failure[i].get('failCode') + '\",';
            json = json + '\"coverageType\": \"' + failure[i].get('coverageType') + '\",';
            json = json + '\"failMode\": \"' + failure[i].get('failMode') + '\",';
            json = json + '\"claimESNreconFlag\": \"\",';
            json = json + '\"oldETOreconFlag\": \"\",';
            json = json + '\"lineNumber\": \"' + (i+1) + '\",';
            json = json + '\"acctCodeInfo\": {';
            json = json + '\"chryslerFlag\": \"\",';
            json = json + '\"accountCodeType\": \"' + failure[i].get('accountCodeType') + '\",';
            json = json + '\"multiESNFlag\": \"' + failure[i].get('multiESNFlag') + '\"},';
            json = json + '\"campaign\": {';
            json = json + '\"accountCode\": \"' + failure[i].get('accountCode') + '\",';
            json = json + '\"campaignId\":  \"' + failure[i].get('campaignId') + '\",';
            json = json + '\"campaignType\": \"\",';
            json = json + '\"expiryDateNA\": \"\",';
            json = json + '\"effectiveDate\": \"\",';
            json = json + '\"expiryDateIntl\": \"\"}}';
        }
        json = json + ']';
        return json;
    }
    
    Public Static String createODMFailurePreSubmitSection(List<Map<String,String>> failure, List<Map<String,String>> parts, List<Map<String,String>> travel, List<Map<String,String>> claimable, List<Map<String,String>> srt){//Method to create the JSON section for Failure Pre-Submit
        String json = '\"failures\":[';
        for(integer i=0; i < failure.size(); i++){
            if(i > 0){
                json = json + ',';
            }
            json = json + '{\"campaignId\": \"' + failure[i].get('campaignId') + '\",';
            json = json + '\"payCode\": \"' + failure[i].get('payCode') + '\",';
            json = json + '\"inShopCampaignFlag\": \"' + failure[i].get('inShopCampaignFlag') + '\",';
            json = json + '\"totalLaborAmt\": \"' + failure[i].get('totalLaborAmt') + '\",';
            json = json + '\"status\": \"Draft\",';
            json = json + '\"authorizationNumber\": \"' + failure[i].get('authorizationNumber') + '\",';
            json = json + '\"approvalCode\": \"' + failure[i].get('approvalCode') + '\",';
            json = json + '\"totalTowingAmt\": \"' + failure[i].get('totalTowingAmt') + '\",';
            json = json + '\"accountCode\": \"' + failure[i].get('accountCode') + '\",';
            json = json + '\"failCode\": \"' + failure[i].get('failCode') + '\",';
            json = json + '\"coverageType\": \"' + failure[i].get('coverageType') + '\",';
            json = json + '\"failMode\": \"' + failure[i].get('failMode') + '\",';
            json = json + '\"claimESNreconFlag\": \"\",';
            json = json + '\"oldETOreconFlag\": \"\",';
            json = json + '\"lineNumber\": \"' + (i+1) + '\",';
            json = json + '\"acctCodeInfo\": {';
            json = json + '\"chryslerFlag\": \"\",';
            json = json + '\"accountCodeType\": \"' + failure[i].get('accountCodeType') + '\",';
            json = json + '\"multiESNFlag\": \"' + failure[i].get('multiESNFlag') + '\"},';
            json = json + '\"campaign\": {';
            json = json + '\"accountCode\": \"' + failure[i].get('accountCode') + '\",';
            json = json + '\"campaignId\": \"\",';
            json = json + '\"campaignType\": \"\",';
            json = json + '\"status\": \"\",';
            json = json + '\"expiryDateNA\": \"\",';
            json = json + '\"effectiveDate\": \"\",';
            json = json + '\"expiryDateIntl\": \"\"}';
            if(i == 0){//Only Include Parts, Travel, Claimable, Srt on the first Failure
                if(parts.size() > 0){
                    json = json + ',' + createODMPartsSection(parts);
                }
                if(travel.size() > 0){
                    json = json + ',' + createODMTravelSection(travel);
                }
                if(claimable.size() > 0){
                    json = json + ',' + createODMClaimableSection(claimable);
                }
                if(srt.size() > 0){
                    json = json + ',' + createODMSRTSection(srt);
                }
            }
            json = json + '}';
        }
        json = json + ']';
        return (json);
    }
    
    Public Static String createODMPartsSection(List<Map<String,String>> parts){//Method to create the JSON section for Parts
        String json = '\"parts\":[';
        for(integer i=0; i < parts.size(); i++){
            if(i > 0){
                json = json + ',';
            }
            json = json + '{\"partPrice\": \"' + ( (parts[i].get('partPrice')!=null)? parts[i].get('partPrice') : '') + '\",';
            json = json + '\"partAllowedFlag\": \"\",';
            json = json + '\"lineNumber\": \"' + (i + 1) + '\",';
            json = json + '\"partId\": \"' + parts[i].get('partId') + '\",';
            json = json + '\"trackingNumber\": \"\",';
            json = json + '\"partsProductCode\": \"' + ((parts[i].get('partsProductCode') != null )?parts[i].get('partsProductCode'):'') + '\",';
            json = json + '\"qtyApproved\": \"0\"}';
        }
        json = json + ']';
        return json;
    }
    
    Public Static String createODMTravelSection(List<Map<String,String>> travel){//Method to create the JSON section for Travel
        String json = '\"travels\":[';
        for(integer i=0; i < travel.size(); i++){
            if(i > 0){
                json = json + ',';
            }
            json = json + '{\"mealsCharges\": \"' + travel[i].get('mealsCharges') + '\",';
            json = json + '\"towingCharges\": \"' + travel[i].get('towingCharges') + '\",';
            json = json + '\"hours\": \"' + travel[i].get('hours') + '\",';
            json = json + '\"lineNumber\": \"' + (i + 1) + '\",';
            json = json + '\"travelDistance\": \"' + travel[i].get('travelDistance') + '\"}';
        }
        json = json + ']';
        return (json);
    }
    
    Public Static String createODMClaimableSection(List<Map<String,String>> claimable){//Method to create the JSON section for Other Claimables
        String json = '\"otherClaimables\":[';
        for(integer i=0; i < claimable.size(); i++){
            if(i > 0){
                json = json + ',';
            }
            json = json + '{\"Amount\": \"' + claimable[i].get('Amount') + '\",';
            json = json + '\"details\": \"' + claimable[i].get('details') + '\",';
            json = json + '\"item\": \"' + claimable[i].get('item') + '\",';
            json = json + '\"lineNumber\": \"' + (i + 1) + '\"}';
        }
        json = json + ']';
        return json;
    }
    
    Public Static String createODMSRTSection(List<Map<String,String>> srt){//Method to create the JSON section for SRT
        String json = '\"srtList\":[';
        for(integer i=0; i < srt.size(); i++){
            if(i > 0){
                json = json + ',';
            }
            json = json + '{\"description\": \"' + srt[i].get('description') + '\",';
            json = json + '\"srtAllowedFlag\": \"\",';
            json = json + '\"hours\": \"' + srt[i].get('hours') + '\",';
            json = json + '\"offsiteCheck\": \"' + srt[i].get('offsiteCheck') + '\",';
            json = json + '\"lineNumber\": \"' + (i + 1) + '\",';
            json = json + '\"quantity\": \"' + srt[i].get('quantity') + '\",';
            json = json + '\"code\": \"' + srt[i].get('code') + '\"}';
        }
        json = json + ']';
        return json; 
    }
    
    Public Static String createODMEndSection(){//Method to create the end JSON section
        String json = '}' +
        '}' +
        '}';
        return json; 
    }
    
    Public Static String getFailureMeasure(string failureMeasure){
        if(failureMeasure == 'KM'){
            failureMeasure = 'Kilometers';
        } else if( failureMeasure == 'HR'){
            failureMeasure = 'Hours';                
        } else if( failureMeasure == 'Miles'){
            failureMeasure = 'Miles';
        } else{
            failureMeasure = '';
        }
        return failureMeasure;
    }
    
}