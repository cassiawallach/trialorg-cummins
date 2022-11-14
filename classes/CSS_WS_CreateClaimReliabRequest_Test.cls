@isTest
Private Class CSS_WS_CreateClaimReliabRequest_Test{

    Public Static TestMethod Void testcreateClaimReliabRequest(){//Test for the creation of JSON Request for HEADER
        //List of incoming parameters for Request Creation
        Map<String, String> header = new Map<String,String>{};
        header.put('operationCode','operationCode');
        header.put('distributorCode','distributorCode');
        header.put('claimNum','claimNum');
        header.put('claimYear','claimYear');
        header.put('reinstatementCode','reinstatementCode');
        header.put('engineSerialNum','engineSerialNum');
        header.put('programPaymentCode','programPaymentCode');
        header.put('programAccountCode','programAccountCode');
        header.put('authorizationNum','authorizationNum');
        header.put('claimDate','claimDate');
        header.put('materialsAmount','materialsAmount');
        header.put('repairLaborAmount','repairLaborAmount');
        header.put('otherExpenseAmount','otherExpenseAmount');
        header.put('engineMiles','engineMiles');
        header.put('engineKm','engineKm');
        header.put('engineHours','engineHours');
        header.put('failureDate','failureDate');
        header.put('failureSeverityCode','failureSeverityCode');
        header.put('dataToCalcSyscdCompcdFlcd','dataToCalcSyscdCompcdFlcd');
        header.put('claimCustomerName','claimCustomerName');
        header.put('claimCustomerAddress','claimCustomerAddress');
        header.put('deductibleAmount','deductibleAmount');
        header.put('laborHours','laborHours');
        header.put('travelLodgingAmount','travelLodgingAmount');
        header.put('claimSourceCode','claimSourceCode');
        header.put('paymentDate','paymentDate');
        header.put('dataToCalcPartNum','dataToCalcPartNum');
        header.put('taxAmount','taxAmount');
        header.put('markupAmount','markupAmount');
        header.put('beyondFactCharge','beyondFactCharge');
        header.put('netAmount','netAmount');
        header.put('engineCoverageGrpCode','engineCoverageGrpCode');
        header.put('engineUseCode','engineUseCode');
        header.put('serviceAreaCode','serviceAreaCode');
        header.put('cumminsAdminAmount','cumminsAdminAmount');
        header.put('claimRapidserveId','claimRapidserveId');
        header.put('travelLaborAmount','travelLaborAmount');
        header.put('travelToSiteAmount','travelToSiteAmount');
        header.put('undetailedPartsAmount','undetailedPartsAmount');
        header.put('dollarDifferAmount','dollarDifferAmount');
        header.put('creditStatement','creditStatement');
        header.put('claimStatusCode','claimStatusCode');
        header.put('dealerCode','dealerCode');
        header.put('equipManufac','equipManufac');
        header.put('equipModel','equipModel');
        header.put('equipConfig','equipConfig');
        header.put('accessCode','accessCode');
    
        //Failures        
        List<Map<String, String>> codes = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('dataToCalcSyscdCompcdFlcd','dataToCalcSyscdCompcdFlcd');
        failureData.put('netAmount','netAmount');
        codes.add(failureData);
        
        //Parts
        List<Map<String, String>> parts = new List<Map<String, String>> ();
        Map<String, String> partData = new Map<String,String>{};
        partData.put('distributorCode','distributorCode');
        partData.put('claimYear','claimYear');
        partData.put('claimNum','claimNum');
        partData.put('reinstatementCode','reinstatementCode');
        partData.put('engineSerialNum','engineSerialNum');
        partData.put('partNumType','partNumType');
        partData.put('partNum','partNum');
        partData.put('partDesc','partDesc');
        partData.put('partQty','partQty');
        partData.put('partAdjdPct','partAdjdPct');
        partData.put('partUnitPrice','partUnitPrice');
        partData.put('partExtdPrice','partExtdPrice');
        partData.put('taxStatusFlg','taxStatusFlg');
        partData.put('partStatusFlg','partStatusFlg');
        parts.add(partData); 
        
        String JSONRequest = CSS_WS_CreateClaimReliabRequest.createClaimReliabRequest (header, codes, parts);
        System.debug (JSONRequest);
        System.assertNotEquals(null,JSONRequest,'The created JSON is null');//Verify the created JSON is not null
    }
    
}