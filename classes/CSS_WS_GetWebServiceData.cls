Public Class CSS_WS_GetWebServiceData {
  
    //WS for getting Account Coverage 
    Public Static CSS_WS_J2A_GetAccountCoverage getAccountCoverage(List<String> data, List<String> details){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetAccountCoverage m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxAccCov');
            jsonRequest = '{' +
                '\"Header\":{' +
                '    \"Sender\":{' +
                '        \"MessageID\": \"UniqueID\",' +
                '        \"ServiceName\": \"getAccountCoverage\",' +
                '        \"SenderID\": \"SF\"' +
                '    }' +
                '},' +
                '\"DataArea\":{' +
                '    \"Esn\": \"' + data[0] + '\",' +
                '    \"SPCode\": \"' + data[1] + '\",' +
                '    \"FailureDate\": \"' + data[2] + '\",' +
                '    \"FailurePoint\": \"' + data[3] + '\",' +
                '    \"FailureMeasure\": \"' + CSS_WS_CreateODMRequest.getFailureMeasure(data[4]) + '\",' +
                '    \"EngineApplicationCode\": \"' + data[5] + '\",' +
                '    \"FaultCode\": \"' + data[6] + '\",' +
                '    \"WarrantyStartDate\": \"' + data[7] + '\",' +
                '    \"CampaignNumber\": \"' + data[8] + '\",' +
                '    \"NewPartsWrntyFlg\": \"' + data[9] + '\",' +
                '    \"ReconPartsWrntyFlg\": \"' + data[10] + '\",' +
                '    \"RoadRelayWrntyFlg\": \"' + data[11] + '\",' +
                '    \"AccountCode\": \"' + data[12] + '\",' +
                '    \"Details\": ['; 
            for(integer i=0; i<details.size(); i++){
                if(i > 0){
                    jsonRequest = jsonRequest + ',';
                }
                string[] details_split = details[i].split(','); 
                jsonRequest = jsonRequest + '{\"SystemCode\":"' + details_split[0] + '",';
                jsonRequest = jsonRequest + '\"ComponentCode\":"' + details_split[1] + '"}';
            }
            jsonRequest = jsonRequest + ']' + '  }' + '}';
            
            WSObj.setRequestData(jsonRequest, 'MxAccCov');
            wsResponse = WSObj.makeRequest();
            System.debug('getAccountCoverage JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_GetAccountCoverage)JSON.deserialize(wsResponse, CSS_WS_J2A_GetAccountCoverage.Class);
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
  
    //WS for getting Engine Data
    Public Static CSS_WS_J2A_GetEngineData getEngineData(String esn){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetEngineData m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxEngData');
            jsonRequest = '?sender=SFMX&target=CSSWarranty&esn=' + esn;
            
            WSObj.setRequestData(jsonRequest, 'MxEngData');
            wsResponse = WSObj.makeRequest();
            System.debug('getEngineData JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_GetEngineData)JSON.deserialize(wsResponse, CSS_WS_J2A_GetEngineData.Class);
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for getting Campaign Data
    Public Static CSS_WS_J2A_GetCampaignData getCampaignData(List<String> data){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetCampaignData m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxCampData');
            jsonRequest = '/' + data[0] + '/campaigns?sender=SFMX&target=CSSWarranty&failureDate=' + data[1];
            
            WSObj.setRequestData(jsonRequest, 'MxCampData');
            wsResponse = WSObj.makeRequest();            
            System.debug('getCampaignData JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_GetCampaignData)JSON.deserialize(wsResponse, CSS_WS_J2A_GetCampaignData.Class); 
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for validating Multiple ESN
    Public Static CSS_WS_J2A_ValidateMultiESN validateMultiESN(String campaignNumber, List<String> details){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_ValidateMultiESN m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxMultiESN');
            jsonRequest = '{' +
                '\"Header\":{' +
                '    \"Sender\":{' +
                '        \"MessageID\": \"UniqueID\",' +
                '        \"ServiceName\": \"validateMultiESN\",' +
                '        \"SenderID\": \"SF\"' +
                '    }' +
                '},' +
                '\"DataArea\":{' +
                '    \"CampaignNumber\": \"' + campaignNumber + '\",' +
                '    \"Details\":['; 
            for(integer i=0; i<details.size(); i++){
                if(i > 0){
                    jsonRequest = jsonRequest + ',';
                }
                String[] details_split = details[i].split(','); 
                jsonRequest = jsonRequest + '{\"Esn\":"' + details_split[0] + '",';
                jsonRequest = jsonRequest + '\"FailureDate\":"' + details_split[1] + '"}';
            }
            jsonRequest = jsonRequest + ']' + '}' + '}';
            
            WSObj.setRequestData(jsonRequest, 'MxMultiESN');
            wsResponse = WSObj.makeRequest();
            System.debug('validateMultiESN JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_ValidateMultiESN)JSON.deserialize(wsResponse, CSS_WS_J2A_ValidateMultiESN.Class); 
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for getting SP Data
    Public Static CSS_WS_J2A_GetSPData getSPData(List<String> data){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetSPData m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxSPData');
            jsonRequest = '?sender=SFMX&target=CSSWarranty&spCode=' + data[0] + '&failureDate=' + data[2] + '&serviceModelName=' + data[1];
            
            WSObj.setRequestData(jsonRequest, 'MxSPData');
            wsResponse = WSObj.makeRequest();
            System.debug('getSPData JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_GetSPData)JSON.deserialize(wsResponse, CSS_WS_J2A_GetSPData.Class); 
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for getting SRT Data
    Public Static CSS_WS_J2A_GetSRTData getSRTData(List<String> data){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetSRTData m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxSRTData');
            jsonRequest = '?sender=SFMX&target=CSSWarranty&engineFamilyCode=' + data[1] + '&serviceModelName=' + data[0] + '&accessCode=' + data[2];

            WSObj.setRequestData(jsonRequest, 'MxSRTData');
            wsResponse = WSObj.makeRequest();
            System.debug('getSRTData JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_GetSRTData)JSON.deserialize(wsResponse, CSS_WS_J2A_GetSRTData.Class); 
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for getting SRT Overlap2
    Public Static CSS_WS_J2A_GetSRTOverlap2 getSRTOverlap2(String claim_number, List<Map<String, String>> details){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetSRTOverlap2 m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxSRTOver2');
            jsonRequest = '{'+
                '  \"Header\": {'+
                '    \"Sender\": {'+
                '      \"SenderID\": \"CSS\",'+
                '      \"ServiceName\": \"GetSRTOverlap\"'+
                '    },'+
                '    \"Target\": {'+
                '      \"TargetID\": \"\"'+
                '    }'+
                '  },'+
                '  \"DataArea\": {'+
                '    \"ClaimID\": \"' + claim_number + '\",'+
                '    \"LanguageCode\": \"n\",'+
                '    \"Steps\":['; 
            for(integer i=0; i<details.size(); i++){
                if(i > 0){
                    jsonRequest = jsonRequest + ',';
                }
                jsonRequest = jsonRequest + '{\"StepId\":"' + details[i].get('StepId') + '",';
                jsonRequest = jsonRequest + '\"AccessCode\":"' + details[i].get('AccessCode') + '",';
                jsonRequest = jsonRequest + '\"Qty\":"' + details[i].get('Qty') + '"}';
            }
            jsonRequest = jsonRequest + ']' + '}' + '}';
            
            WSObj.setRequestData(jsonRequest, 'MxSRTOver2');
            wsResponse = WSObj.makeRequest();
            System.debug('getSRTOverlap2 JSON Response: ' + wsResponse); 
            m = (CSS_WS_J2A_GetSRTOverlap2)JSON.deserialize(wsResponse, CSS_WS_J2A_GetSRTOverlap2.Class); 
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for getting SRT Overlap
    Public Static CSS_WS_J2A_GetSRTOverlap getSRTOverlap(List<Map<String, String>> details){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetSRTOverlap m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxSRTOver');
            jsonRequest = '{' +
                '\"Header\":{' +
                '    \"Sender\":{' +
                '        \"MessageID\": \"UniqueID\",' +
                '        \"ServiceName\": \"getSRTOverlap\",' +
                '        \"SenderID\": \"SF\"' +
                '    }' +
                '},' +
                '\"DataArea\":{' +
                '    \"Details\":['; 
            for(integer i=0; i<details.size(); i++){
                if(i > 0){
                    jsonRequest = jsonRequest + ',';
                }
                jsonRequest = jsonRequest + '{\"EngineFamilyCode\":"' + details[i].get('EngineFamilyCode') + '",';
                jsonRequest = jsonRequest + '\"SrtAccessCode\":"' + details[i].get('SrtAccessCode') + '",';
                jsonRequest = jsonRequest + '\"SrtCode\":"' + details[i].get('SrtCode') + '",';
                jsonRequest = jsonRequest + '\"SrtHours\":"' + details[i].get('SrtHours') + '",';
                jsonRequest = jsonRequest + '\"SrtQty\":"' + details[i].get('SrtQty') + '"}';
            }
            jsonRequest = jsonRequest + ']' + '}' + '}';
            
            WSObj.setRequestData(jsonRequest, 'MxSRTOver');
            wsResponse = WSObj.makeRequest();
            System.debug('getSRTOverlap JSON Response: ' + wsResponse); 
            m = (CSS_WS_J2A_GetSRTOverlap)JSON.deserialize(wsResponse, CSS_WS_J2A_GetSRTOverlap.Class); 
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for getting Parts Data
    Public Static CSS_WS_J2A_GetPartsData getPartsData(String partNumberShort){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetPartsData m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxPrtsData');
            jsonRequest = '?sender=SFMX&target=CSSWarranty&partNumberShort=' + partNumberShort;

            WSObj.setRequestData(jsonRequest, 'MxPrtsData');
            wsResponse = WSObj.makeRequest();
            System.debug('getPartsData JSON Response: ' + wsResponse); 
            m = (CSS_WS_J2A_GetPartsData)JSON.deserialize(wsResponse, CSS_WS_J2A_GetPartsData.Class); 
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for creating Statements for MX
    Public Static CSS_WS_J2A_CreateStatementMX createStatementMX(Map<String, String> header, List<Map<String, String>> details){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_CreateStatementMX m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxCreatStm');
            jsonRequest = '{' +
                '\"Header\":{' +
                '    \"Sender\":{' +
                '        \"MessageID\":\"UniqueID\",' +
                '        \"ServiceName\":\"createStatementMX\",' +
                '        \"SenderID\":\"SF\"' +
                '    }' +
                '},' +
                '\"DataArea\":{' +
                '    \"InterfaceLineContext\": \"SERVICE\",' +
                '    \"InterfaceLineAttribute1\": \"' + header.get('InterfaceLineAttribute1') + '\",' +
                '    \"InterfaceLineAttribute2\": \"RMA SO Servicios\",' +
                '    \"InterfaceLineAttribute3\": \"0\",' +
                '    \"InterfaceLineAttribute4\": \"0\",' +
                '    \"InterfaceLineAttribute5\": \"1\",' +
                '    \"InterfaceLineAttribute6\": \"0\",' +
                '    \"AccountClass\": \"REV\",' +
                '    \"Amount\": ' + header.get('Amount') + ',' +
                '    \"Percent\": 100,' +
                '    \"CodeCombinationId\": 1950,' +
                '    \"OrgId\": 236,' +
                '    \"Details\":[';
                for(integer i=0; i<details.size(); i++){
                    if(i > 0){
                        jsonRequest = jsonRequest + ',';
                    }
                    jsonRequest = jsonRequest + '{\"TermName\":\"\",';
                    jsonRequest = jsonRequest + '\"TermId\":\"\",';
                    jsonRequest = jsonRequest + '\"LineNumber\":\"' + details[i].get('LineNumber') + '\",';
                    jsonRequest = jsonRequest + '\"InterfaceLineContext\":\"SERVICE\",';
                    jsonRequest = jsonRequest + '\"SalesOrder\":\"' + details[i].get('SalesOrder') + '\",';
                    jsonRequest = jsonRequest + '\"InterfaceLineAttribute1\":\"' + header.get('InterfaceLineAttribute1') + '\",';
                    jsonRequest = jsonRequest + '\"InterfaceLineAttribute2\":\"RMA SO Servicios\",';
                    jsonRequest = jsonRequest + '\"InterfaceLineAttribute3\":\"0\",';
                    jsonRequest = jsonRequest + '\"InterfaceLineAttribute4\":\"0\",';
                    jsonRequest = jsonRequest + '\"InterfaceLineAttribute5\":\"1\",';
                    jsonRequest = jsonRequest + '\"InterfaceLineAttribute6\":\"' + details[i].get('InterfaceLineAttribute6') + '\",';
                    jsonRequest = jsonRequest + '\"InventoryItemId\":\"' + details[i].get('InventoryItemId') + '\",';
                    jsonRequest = jsonRequest + '\"UomCode\":\"EA\",';
                    jsonRequest = jsonRequest + '\"BatchSourceName\":\"' +  details[i].get('BatchSourceName') + '\",';
                    jsonRequest = jsonRequest + '\"AttributeCategory\":\"Descripcion\",';
                    jsonRequest = jsonRequest + '\"Attribute1\":\"' +  details[i].get('Attribute1') + '\",';
                    jsonRequest = jsonRequest + '\"SetOfBooksId\":1002,';
                    jsonRequest = jsonRequest + '\"LineType\":\"LINE\",';
                    jsonRequest = jsonRequest + '\"Description\":\"' +  details[i].get('Description') + '\",';
                    jsonRequest = jsonRequest + '\"CurrencyCode\":\"USD\",';
                    jsonRequest = jsonRequest + '\"Amount\":' + details[i].get('Amount') + ',';
                    jsonRequest = jsonRequest + '\"CustTrxTypeId\":' +  details[i].get('CustTrxTypeId') + ',';
                    jsonRequest = jsonRequest + '\"OrigSystemBillCustomerId\":' + details[i].get('OrigSystemBillCustomerId') + ',';
                    jsonRequest = jsonRequest + '\"OrigSystemBillAddressId\":' + details[i].get('OrigSystemBillAddressId') + ',';
                    jsonRequest = jsonRequest + '\"OrigSystemShipCustomerId\":' + details[i].get('OrigSystemShipCustomerId') + ',';
                    jsonRequest = jsonRequest + '\"OrigSystemShipAddressId\":' + details[i].get('OrigSystemShipAddressId') + ',';
                    jsonRequest = jsonRequest + '\"ConversionType\":\"User\",';
                    jsonRequest = jsonRequest + '\"Quantity\":' + details[i].get('Quantity') + ',';
                    jsonRequest = jsonRequest + '\"UnitSellingPrice\":' + details[i].get('UnitSellingPrice') + ',';
                    jsonRequest = jsonRequest + '\"Comments\":\"' +  details[i].get('Comments') + '\",';
                    jsonRequest = jsonRequest + '\"TaxCode\":\"IVA 16%\",';
                    //jsonRequest = jsonRequest + '\"PrimarySalesrepId\":100000045,';
                    jsonRequest = jsonRequest + '\"OrgId\":236,';
                    //jsonRequest = jsonRequest + '\"OrigSystemSoldCustomerId\":54432,'; 
                    jsonRequest = jsonRequest + '\"OrigSystemSoldCustomerId\":' + details[i].get('OrigSystemSoldCustomerId') + ',';
                    jsonRequest = jsonRequest + '\"WarehouseId\":239,';
                    jsonRequest = jsonRequest + '\"TranslatedDescription\":\"' + details[i].get('TranslatedDescription') + '\"}';
                }
            jsonRequest = jsonRequest + ']' + '}' + '}';
            
            WSObj.setRequestData(jsonRequest, 'MxCreatStm');
            wsResponse = WSObj.makeRequest();
            System.debug('createStatementMX JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_CreateStatementMX)JSON.deserialize(wsResponse, CSS_WS_J2A_CreateStatementMX.Class); 
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }   
    
    //WS for getting Currency Exchange
    Public Static CSS_WS_J2A_GetCurrencyExchange getCurrencyExchange(List<String> data){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetCurrencyExchange m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('getCurrencyExchange');
            jsonRequest = '{' +
                '\"Header\":{' +
                '    \"Sender\":{' +
                '        \"MessageID\":\"UniqueID\",' +
                '        \"ServiceName\":\"CurrExchange\",' +
                '        \"SenderID\":\"SF\"' +
                '    },' +
                '    \"Target\":{  ' +
                '        \"TargetID\":\"CSSWarranty\"' +
                '    }' +
                '},' +
                '\"DataArea\":{' +
                '    \"ConversionType\": \"' + data[0] + '\",' +
                '    \"ConversionDate\": \"' + data[1] + '\",' +
                '    \"FromCurrency\": \"' + data[2] + '\",' +
                '    \"ToCurrency\": \"' + data[3] + '\"' +
                '}' + '}';
                
            WSObj.setRequestData(jsonRequest, 'getCurrencyExchange');
            wsResponse = WSObj.makeRequest();
            System.debug('getCurrencyExchange JSON Response: ' + wsResponse); 
            m = (CSS_WS_J2A_GetCurrencyExchange)JSON.deserialize(wsResponse, CSS_WS_J2A_GetCurrencyExchange.Class); 
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
            
    //WS for ODM validation - Header 
    Public Static CSS_WS_J2A_ODM_Validation getODMValidationHeader(Map<String, String> header){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_ODM_Validation m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxHeadVal');
            jsonRequest = CSS_WS_CreateODMRequest.createODMHeaderRequest(header);
            
            WSObj.setRequestData(jsonRequest, 'MxHeadVal');
            wsResponse = WSObj.makeRequest();
            System.debug('getODMValidationHeader JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_ODM_Validation)JSON.deserialize(wsResponse, CSS_WS_J2A_ODM_Validation.Class);
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for ODM validation - Failure 
    Public Static CSS_WS_J2A_ODM_Validation getODMValidationFailure(Map<String, String> header, List<Map<String, String>> failure){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_ODM_Validation m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxFailVal');
            jsonRequest = CSS_WS_CreateODMRequest.createODMFailureRequest(header, failure);
            
            WSObj.setRequestData(jsonRequest, 'MxFailVal');
            wsResponse = WSObj.makeRequest();
            System.debug('getODMValidationFailure JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_ODM_Validation)JSON.deserialize(wsResponse, CSS_WS_J2A_ODM_Validation.Class);
        } catch(exception e) {
            System.debug('Error: ****' + e.getMessage());
        }
        return m;  
    }
    
    //WS for ODM validation - Parts
    Public Static CSS_WS_J2A_ODM_Validation getODMValidationParts(Map<String, String> header, List<Map<String, String>> failure, List<Map<String, String>> parts){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_ODM_Validation m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxPrtsVal');
            jsonRequest = CSS_WS_CreateODMRequest.createODMPartsRequest(header, failure, parts);
            
            WSObj.setRequestData(jsonRequest, 'MxPrtsVal');
            wsResponse = WSObj.makeRequest();
            System.debug('getODMValidationParts JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_ODM_Validation)JSON.deserialize(wsResponse, CSS_WS_J2A_ODM_Validation.Class);
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for ODM validation - Travel 
    Public Static CSS_WS_J2A_ODM_Validation getODMValidationTravel(Map<String, String> header, List<Map<String, String>> failure, List<Map<String, String>> travel){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_ODM_Validation m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxTraVal');
            jsonRequest = CSS_WS_CreateODMRequest.createODMTravelRequest(header, failure, travel);
            
            WSObj.setRequestData(jsonRequest, 'MxTraVal');
            wsResponse = WSObj.makeRequest();
            System.debug('getODMValidationTravel JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_ODM_Validation)JSON.deserialize(wsResponse, CSS_WS_J2A_ODM_Validation.Class);
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for ODM validation - Other Claimables 
    Public Static CSS_WS_J2A_ODM_Validation getODMValidationClaimable(Map<String, String> header, List<Map<String, String>> failure, List<Map<String, String>> claimable){
        String wsResponse = '';
        String jsonRequest = '';
        CSS_WS_J2A_ODM_Validation m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxOCVal');
            jsonRequest = CSS_WS_CreateODMRequest.createODMClaimableRequest(header, failure, claimable);
            
            WSObj.setRequestData(jsonRequest, 'MxOCVal');
            wsResponse = WSObj.makeRequest();
            System.debug('getODMValidationClaimable JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_ODM_Validation)JSON.deserialize(wsResponse, CSS_WS_J2A_ODM_Validation.Class);
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for ODM validation - SRT
    Public Static CSS_WS_J2A_ODM_Validation getODMValidationSRT(Map<String, String> header, List<Map<String, String>> failure, List<Map<String, String>> srt){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_ODM_Validation m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxSRTVal');
            jsonRequest = CSS_WS_CreateODMRequest.createODMSRTRequest(header, failure, srt);
            
            WSObj.setRequestData(jsonRequest, 'MxSRTVal');
            wsResponse = WSObj.makeRequest();
            System.debug('getODMValidationSRT JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_ODM_Validation)JSON.deserialize(wsResponse, CSS_WS_J2A_ODM_Validation.Class);
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for ODM validation - PreSubmit
    Public Static CSS_WS_J2A_ODM_PreSubmit getODMValidationPreSubmit(Map<String, String> header, List<Map<String, String>> failure, List<Map<String, String>> parts, List<Map<String, String>> travel, List<Map<String, String>> claimable, List<Map<String, String>> srt){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_ODM_PreSubmit m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxPreSub');
            jsonRequest = CSS_WS_CreateODMRequest.createODMCompleteRequest(header, failure, parts, travel, claimable, srt);
            
            WSObj.setRequestData(jsonRequest, 'MxPreSub');
            wsResponse = WSObj.makeRequest();
            System.debug('getODMValidationPreSubmit JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_ODM_PreSubmit)JSON.deserialize(wsResponse, CSS_WS_J2A_ODM_PreSubmit.Class);
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for Claim Submission
    Public Static CSS_WS_J2A_ClaimSubmission getClaimSubmission(Map<String, String> header, List<String> complaints, List<String> promotionIds , List<Map<String, String>> multiESN, List<Map<String, String>> notes, List<Map<String, String>> failure, List<Map<String, String>> claimable, List<Map<String, String>> parts, List<Map<String, String>> srt, List<Map<String, String>> travel){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_ClaimSubmission m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxClaimSub');
            jsonRequest = CSS_WS_CreateClaimSubmissionRequest.createClaimSubmissionRequest(header, complaints, promotionIds, multiESN, notes, failure, claimable, parts, srt, travel);
            
            WSObj.setRequestData(jsonRequest, 'MxClaimSub');
            wsResponse = WSObj.makeRequest();
            System.debug('getClaimSubmission JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_ClaimSubmission)JSON.deserialize(wsResponse, CSS_WS_J2A_ClaimSubmission.Class);
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for getting Part Price data
    Public Static CSS_WS_J2A_GetPartPrice getPartPrice(Map<String, String> partData){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetPartPrice m;
        try{
            //CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxPartPric');
            jsonRequest = '{' +
                '\"Header\": {' +
                '    \"Sender\":{' +
                '        \"MessageID\": \"UniqueID\",' +
                '        \"ServiceName\": \"getPartPrice\",' +
                '        \"SenderID\": \"SF\"' +
                '    }' +
                '},' +
                '\"DataArea\": {' +
                '    \"PartNumber\": \"' + partData.get('PartNumber') + '\"' + 
                '}' + '}';
                
            /*WSObj.setRequestData(jsonRequest, 'MxPartPric');
            wsResponse = WSObj.makeRequest();*/
            wsResponse = '{' +
                '\"DataArea\":{' +
                '    \"PartPrice\":\"10.0\"' +
                '},' +
                '\"Header\":{' +
                '    \"Status\":\"Success\"' +
                '}' + '}'; 
                
            System.debug('getPartPrice JSON Request: ' + jsonRequest);
            System.debug('getPartPrice JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_GetPartPrice)JSON.deserialize(wsResponse, CSS_WS_J2A_GetPartPrice.Class);
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for getting CSS Details Data
    Public Static CSS_WS_J2A_GetCSSDetails getCSSDetails(Map<String, String> DATA){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetCSSDetails m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxCssDet');
            jsonRequest = '?sender=SFMX&target=CSSWarranty&claimNumber=' + DATA.get('ClaimNumber') + '&imsClaimNumber=' + DATA.get('IMSClaimNumber');  
              
            WSObj.setRequestData(jsonRequest, 'MxCssDet');
            wsResponse = WSObj.makeRequest();       
            System.debug ('Get_CSS_Details WS JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_GetCSSDetails)JSON.deserialize(wsResponse,CSS_WS_J2A_GetCSSDetails.class); 
        } catch(exception e){
            System.debug('Error: '+e.getMessage());
        }
        return m;  
    }
    
    //WS for getting GSQ Failure Data
    Public Static CSS_WS_J2A_GetGSQFailure getGSQFailure(Map<String, String> DATA){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetGSQFailure m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxGsqFai');
            jsonRequest = '?sender=SFMX&target=SRT&engineFamilyCode=' + DATA.get('EngineFamilyCode') + '&serviceModelName=' + DATA.get('ServiceModelName') + '&languageCode=' + DATA.get('LanguageCode');
              
            WSObj.setRequestData(jsonRequest, 'MxGsqFai');
            wsResponse = WSObj.makeRequest();       
            System.debug ('Get_GSQ_Failure WS JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_GetGSQFailure)JSON.deserialize(wsResponse,CSS_WS_J2A_GetGSQFailure.class); 
        } catch(exception e){
            System.debug('Error: '+e.getMessage());
        }
        return m;  
    }
    
    //WS for getting GSQ SRT Data
    Public Static CSS_WS_J2A_GetGSQSRT getGSQSRT(Map<String, String> DATA){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetGSQSRT m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxGsqSrt');
            jsonRequest = '{'+
              '   \"Header\": {'+
              '       \"Target\":{'+
              '           \"TargetID\": \"SRT\"'+
              '       },'+
              '       \"Sender\":{'+
              '           \"ServiceName\": \"GetStandardRepairTime\",'+
              '           \"SenderID\": \"SF\",'+
              '           \"MessageID\": \"abc\"'+
              '       }'+
              '   },'+
              '   \"DataArea\": {'+
              '       \"EngineFamilyCode\": \"' + DATA.get('EngineFamilyCode') + '\",'+
              '       \"SRTType\": \"' + DATA.get('SRTType') + '\",'+
              '       \"EquipmentID\": \"' + DATA.get('EquipmentID') + '\",'+
              '       \"FailureID\": \"' + DATA.get('FailureID') + '\",'+
              '       \"ServiceModelName\": \"' + DATA.get('ServiceModelName') + '\",'+
              '       \"CSSJobId\": \"' + DATA.get('CSSJobId') + '\",'+
              '       \"Timestamp\": \"' + DATA.get('Timestamp') + '\",'+
              '       \"EffectiveDateTime\": \"' + DATA.get('EffectiveDateTime') + '\"'+
              '   }'+
              '}';   
              
            WSObj.setRequestData(jsonRequest, 'MxGsqSrt');
            wsResponse = WSObj.makeRequest();       
            System.debug ('Get_GSQ_SRT WS JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_GetGSQSRT)JSON.deserialize(wsResponse,CSS_WS_J2A_GetGSQSRT.class); 
        } catch(exception e){
            System.debug('Error: '+e.getMessage());
        }
        return m;  
    }
    
    //WS for getting Service Model Data
    Public Static CSS_WS_J2A_GetServiceModel getServiceModel(Map<String, String> DATA){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetServiceModel m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxServMod');
            jsonRequest = '?sender=SFMX&target=SRT&LastRunDate=' + DATA.get('LastRunDate') + '&LangCode=' + DATA.get('LangCode');
              
            WSObj.setRequestData(jsonRequest, 'MxServMod');
            wsResponse = WSObj.makeRequest();      
            System.debug ('Get_Service_Model WS JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_GetServiceModel)JSON.deserialize(wsResponse,CSS_WS_J2A_GetServiceModel.class); 
        } catch(exception e){
            System.debug('Error: '+e.getMessage());
        }
        return m;  
    }
    
    //WS for getting Part Return Flag
    Public Static CSS_WS_J2A_GetPartReturn getPartReturn(Map<String, String> header, List<Map<String, String>> details){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetPartReturn m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxPartRet');
            jsonRequest = '{'+
                '  \"Header\": {'+
                '    \"Sender\": {'+
                '      \"SenderID\": \"CSS\",'+
                '      \"ServiceName\": \"GetERPFlag\"'+
                '    },'+
                '    \"Target\": {'+
                '      \"TargetID\": \"SIEBEL\"'+
                '    }'+
                '  },'+
                '  \"DataArea\": {'+
                '    \"PSN\": \"' + header.get('PSN') + '\",'+
                '    \"FAILDATE\": \"' + header.get('FAILDATE') + '\",'+
                '    \"DISTICHANNEL\": \"' + header.get('DISTICHANNEL') + '\",'+                
                '    \"PARTS\":['; 
            for(integer i=0; i<details.size(); i++){
                if(i > 0){
                    jsonRequest = jsonRequest + ',';
                }
                jsonRequest = jsonRequest + '{\"TERRITORYCLASS\":"' + details[i].get('TERRITORYCLASS') + '",';
                jsonRequest = jsonRequest + '\"PRODUCTFAMILY\":"' + details[i].get('PRODUCTFAMILY') + '",';
                jsonRequest = jsonRequest + '\"PARTNUMBER\":"' + details[i].get('PARTNUMBER') + '",';
                jsonRequest = jsonRequest + '\"FAILCODE\":"' + details[i].get('FAILCODE') + '",';
                jsonRequest = jsonRequest + '\"ACCOUNTCODE\":"' + details[i].get('ACCOUNTCODE') + '"}';
            }
            jsonRequest = jsonRequest + ']' + '}' + '}';
            
            WSObj.setRequestData(jsonRequest, 'MxPartRet');
            wsResponse = WSObj.makeRequest();
            System.debug('getPartReturn JSON Response: ' + wsResponse); 
            m = (CSS_WS_J2A_GetPartReturn)JSON.deserialize(wsResponse, CSS_WS_J2A_GetPartReturn.Class); 
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for getting Fail Codes
    Public Static CSS_WS_J2A_GetFailCodes getFailCodes(String LAST_PROCESSED_DATE){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_GetFailCodes m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxFailCod');
            jsonRequest = '?sender=SFMX&target=CSSWarranty&lastProcessedDate=' + LAST_PROCESSED_DATE;             

            WSObj.setRequestData(jsonRequest, 'MxFailCod');
            wsResponse = WSObj.makeRequest();
            System.debug('getFailCodes JSON Response: ' + wsResponse); 
            m = (CSS_WS_J2A_GetFailCodes)JSON.deserialize(wsResponse, CSS_WS_J2A_GetFailCodes.Class); 
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
    //WS for Claim Reliability
    Public Static CSS_WS_J2A_ClaimReliability getClaimReliability(Map<String, String> header, List<Map<String, String>> codes, List<Map<String, String>> parts){
        String wsResponse;
        String jsonRequest;
        CSS_WS_J2A_ClaimReliability m;
        try{
            CSS_WS_Webservices WSObj = new CSS_WS_Webservices('MxClaimRel');
            jsonRequest = CSS_WS_CreateClaimReliabRequest.createClaimReliabRequest(header, codes, parts);
            
            WSObj.setRequestData(jsonRequest, 'MxClaimRel');
            wsResponse = WSObj.makeRequest();
            System.debug('getClaimReliability JSON Response: ' + wsResponse);
            m = (CSS_WS_J2A_ClaimReliability)JSON.deserialize(wsResponse, CSS_WS_J2A_ClaimReliability.Class);
        } catch(exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        return m;  
    }
    
}