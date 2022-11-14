Public Class CSS_WS_CreateClaimReliabRequest{ 
    
    Public Static String createClaimReliabRequest(Map<String, String> header, List<Map<String, String>> codes, List<Map<String, String>> parts){//Method to create the JSON section for Claim Reliability
        String json = '{'+
        '    \"claims\":[{'+
        '        \"operationCode\": \"' + header.get('operationCode') + '\",'+
        '        \"distributorCode\": \"' + header.get('distributorCode') + '\",'+
        '        \"claimNum\": \"' + header.get('claimNum') + '\",'+
        '        \"claimYear\": \"' + header.get('claimYear') + '\",'+
        '        \"reinstatementCode\": \"' + header.get('reinstatementCode') + '\",'+
        '        \"engineSerialNum\": \"' + header.get('engineSerialNum') + '\",'+
        '        \"programPaymentCode\": \"' + header.get('programPaymentCode') + '\",'+
        '        \"programAccountCode\": \"' + header.get('programAccountCode') + '\",'+
        '        \"authorizationNum\": \"' + header.get('authorizationNum') + '\",'+
        '        \"claimDate\": \"' + header.get('claimDate') + '\",'+
        '        \"materialsAmount\": \"' + header.get('materialsAmount') + '\",'+
        '        \"repairLaborAmount\": \"' + header.get('repairLaborAmount') + '\",'+
        '        \"otherExpenseAmount\": \"' + header.get('otherExpenseAmount') + '\",'+
        '        \"engineMiles\": \"' + header.get('engineMiles') + '\",'+
        '        \"engineKm\": \"' + header.get('engineKm') + '\",'+
        '        \"engineHours\": \"' + header.get('engineHours') + '\",'+
        '        \"failureDate\": \"' + header.get('failureDate') + '\",'+
        '        \"failureSeverityCode\": \"' + header.get('failureSeverityCode') + '\",'+
        '        \"dataToCalcSyscdCompcdFlcd\": \"' + header.get('dataToCalcSyscdCompcdFlcd') + '\",'+
        '        \"claimCustomerName\": \"' + header.get('claimCustomerName') + '\",'+
        '        \"claimCustomerAddress\": \"' + header.get('claimCustomerAddress') + '\",'+
        '        \"deductibleAmount\": \"' + header.get('deductibleAmount') + '\",'+
        '        \"laborHours\": \"' + header.get('laborHours') + '\",'+
        '        \"travelLodgingAmount\": \"' + header.get('travelLodgingAmount') + '\",'+
        '        \"claimSourceCode\": \"' + header.get('claimSourceCode') + '\",'+
        '        \"paymentDate\": \"' + header.get('paymentDate') + '\",'+
        '        \"dataToCalcPartNum\": \"' + header.get('dataToCalcPartNum')+ '\",'+
        '        \"taxAmount\": \"' + header.get('taxAmount') + '\",'+
        '        \"markupAmount\": \"' + header.get('markupAmount') + '\",'+
        '        \"beyondFactCharge\": \"' + header.get('beyondFactCharge') + '\",'+
        '        \"netAmount\": \"' + header.get('netAmount') + '\",'+
        '        \"engineCoverageGrpCode\": \"' + header.get('engineCoverageGrpCode') + '\",'+
        '        \"engineUseCode\": \"' + header.get('engineUseCode') + '\",'+
        '        \"serviceAreaCode\": \"' + header.get('serviceAreaCode') + '\",'+
        '        \"cumminsAdminAmount\": \"' + header.get('cumminsAdminAmount') + '\",'+
        '        \"claimRapidserveId\": \"' + header.get('claimRapidserveId') + '\",'+
        '        \"travelLaborAmount\": \"' + header.get('travelLaborAmount')+ '\",'+
        '        \"travelToSiteAmount\": \"' + header.get('travelToSiteAmount') + '\",'+
        '        \"undetailedPartsAmount\": \"' + header.get('undetailedPartsAmount') + '\",'+
        '        \"dollarDifferAmount\": \"' + header.get('dollarDifferAmount') + '\",'+
        '        \"creditStatement\": \"' + header.get('creditStatement') + '\",'+
        '        \"claimStatusCode\": \"' + header.get('claimStatusCode') + '\",'+
        '        \"dealerCode\": \"' + header.get('dealerCode') + '\",'+
        '        \"equipManufac\": \"' + header.get('equipManufac') + '\",'+
        '        \"equipModel\": \"' + header.get('equipModel') + '\",'+
        '        \"equipConfig\": \"' + header.get('equipConfig') + '\",'+
        '        \"accessCode\": \"' + header.get('accessCode') + '\",';
        json = json +
        '        \"codes\": [';
        if(codes.size() > 0){
            
            for(integer i=0; i < codes.size(); i++){
                if(i > 0){
                    json = json + ',';
                }
                json = json + '{\"dataToCalcSyscdCompcdFlcd\": \"' + codes[i].get('dataToCalcSyscdCompcdFlcd') + '\",';
                json = json + '\"netAmount\": \"' + codes[i].get('netAmount') + '\"}';
            }
                        
        }
        json = json + '],';
        json = json +
        '        \"parts\": [';
        if(parts.size() > 0){
        
            for(integer i=0; i < parts.size(); i++){
                if(i > 0){
                    json = json + ',';
                }
                json = json + '{\"distributorCode\": \"' + parts[i].get('distributorCode') + '\",';
                json = json + '\"claimYear\": \"' + parts[i].get('claimYear') + '\",';
                json = json + '\"claimNum\": \"' + parts[i].get('claimNum') + '\",';
                json = json + '\"reinstatementCode\": \"' + parts[i].get('reinstatementCode') + '\",';
                json = json + '\"engineSerialNum\": \"' + parts[i].get('engineSerialNum') + '\",';
                json = json + '\"partNumType\": \"' + parts[i].get('partNumType') + '\",';
                json = json + '\"partNum\": \"' + parts[i].get('partNum') + '\",';
                json = json + '\"partDesc\": \"' + parts[i].get('partDesc') + '\",';
                json = json + '\"partQty\": \"' + parts[i].get('partQty') + '\",';
                json = json + '\"partAdjdPct\": \"' + parts[i].get('partAdjdPct') + '\",';
                json = json + '\"partUnitPrice\": \"' + parts[i].get('partUnitPrice') + '\",';
                json = json + '\"partExtdPrice\": \"' + parts[i].get('partExtdPrice') + '\",';
                json = json + '\"taxStatusFlg\": \"' + parts[i].get('taxStatusFlg') + '\",';
                json = json + '\"partStatusFlg\": \"' + parts[i].get('partStatusFlg') + '\"}';
            }  
                      
        }
        json = json + ']';

        json = json + '}' +
        '    ]'+         
        '}';
        return (json);
    }
    
}