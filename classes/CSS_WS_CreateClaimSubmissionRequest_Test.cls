@isTest
Private Class CSS_WS_CreateClaimSubmissionRequest_Test{

    Public Static TestMethod Void testcreateClaimSubmissionRequest(){//Test for the creation of JSON Request for HEADER
        //List of incoming parameters for Request Creation
        Map<String, String> header = new Map<String,String>{};
        header.put('ServiceProviderCode','ServiceProviderCode');
        header.put('DistributorCode','DistributorCode');
        header.put('EngineSerialNumber','EngineSerialNumber');
        header.put('RONumber','RONumber');
        header.put('WarrantyStartDate','WarrantyStartDate');
        header.put('EngineApplicationCode','EngineApplicationCode');
        header.put('Manufacturer','Manufacturer');
        header.put('ModelSeries','ModelSeries');
        header.put('FirstName','');
        header.put('LastName','');
        header.put('BISFlag','BISFlag');
        header.put('MultiESNFlg','MultiESNFlg');
        header.put('CampaignNumber','CampaignNumber');
        header.put('NewPartsWarrantyFlg','NewPartsWarrantyFlg');
        header.put('ReConPartsWarrantyFlg','ReConPartsWarrantyFlg');
        header.put('RoadRelayWarrantyFlg','RoadRelayWarrantyFlg');
        header.put('FailureDate','FailureDate');
        header.put('FailurePoint','FailurePoint');
        header.put('FailureMeasure','FailureMeasure');
        header.put('MissionDisablingFlag','MissionDisablingFlag');
        header.put('CatastrophicFlag','CatastrophicFlag');
        header.put('CatastrophicFlag','CatastrophicFlag');
        header.put('ReplacementPart','ReplacementPart');
        header.put('WarrantyTrainedFlag','WarrantyTrainedFlag');
        header.put('DISDNumber','DISDNumber');
        header.put('CustomerName','CustomerName');
        header.put('ECMCalibAfter','ECMCalibAfter');
        header.put('ReviewAfter','ReviewAfter');
        header.put('ECMCalibBefore','ECMCalibBefore');
        header.put('RevisionBefore','RevisionBefore');
        header.put('Justification','Justification');
        header.put('ESNCount','ESNCount');
        header.put('TSRNumber','TSRNumber');
        header.put('PenaltyFlag','PenaltyFlag');
        header.put('SRTPenaltyPercentage','SRTPenaltyPercentage');
        header.put('DealerClaimNumber','DealerClaimNumber');
        header.put('manualAdjudicationFlag','');
        header.put('ClaimFiledDate','ClaimFiledDate');
        header.put('SPInShopLaborRate','SPInShopLaborRate');
        header.put('SPLaborRate','SPLaborRate');
        header.put('SPTravelRate','SPTravelRate');
        header.put('Contact','Contact');
        
        //Complaits
        List<String> complaints = new String[]{};
        complaints.add('ComplaintCode1'); //ComplaintCode
        complaints.add('ComplaintCode2');
        complaints.add('ComplaintCode3');
        List<String> promotionIds = new String[]{};
        promotionIds.add('PromotionID'); //PromotionID
                
        //MultiESN
        List<Map<String, String>> multiESN = new List<Map<String, String>> ();
        Map<String, String> esnData = new Map<String,String>{};
        esnData.put('EngineSerialNumber','EngineSerialNumber');
        esnData.put('BISFlag','BISFlag');
        esnData.put('FailureDate','FailureDate');
        esnData.put('FailurePoint','FailurePoint');
        esnData.put('FailureMeasure','FailureMeasure');
        esnData.put('ECMCalibAfter','ECMCalibAfter');
        esnData.put('ReviewAfter','ReviewAfter');
        esnData.put('ECMCalibBefore','ECMCalibBefore');
        esnData.put('RevisionBefore','RevisionBefore');
        esnData.put('WarrantyStartDate','WarrantyStartDate');
        multiESN.add(esnData);  
               
        //Notes
        //List<String> notes = new List<String> ();
        //notes.add('Note');    //Note
        List<Map<String, String>> notes = new List<Map<String, String>> ();
        Map<String, String> notesNarrative = new Map<String,String>{};
        notesNarrative.put('Note','Note');
        notesNarrative.put('NoteType','Narrative');
        notes.add(notesNarrative);
        Map<String, String> notesEPR = new Map<String,String>{};
        notesEPR.put('Note','Note');
        notesEPR.put('NoteType','Parts Return');
        notes.add(notesEPR);
    
        //Failures        
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('SystemCode','SystemCode');
        failureData.put('ComponentCode','ComponentCode');
        failureData.put('FailMode','FailMode');
        failureData.put('AccountCode','AccountCode');
        failureData.put('PayCode','PayCode');
        failureData.put('CertificateNumber','CertificateNumber');
        failureData.put('CampaignNumber','CampaignNumber');
        failureData.put('WarrantyId','WarrantyId');
        failureData.put('ApproverCode','ApproverCode');
        failureData.put('CoverageType','CoverageType');
        failureData.put('CoveredLaborHours','CoveredLaborHours');
        failureData.put('CoveredMealsLodgingAmt','CoveredLaborHours');
        failureData.put('CoveredOCAmount','CoveredLaborHours');   
        failureData.put('CoveredPartsQuantity','CoveredLaborHours');
        failureData.put('CoveredTowingMiles','CoveredTowingMiles');
        failureData.put('CoveredTravelLabor','CoveredTravelLabor');
        failureData.put('CoveredTravelMiles','CoveredTravelMiles');
        failureData.put('DeductibleAmount','DeductibleAmount');
        failureData.put('AuthorizationNum','AuthorizationNum');
        failureData.put('CampaignLabourPrcnt','CampaignLabourPrcnt');
        failureData.put('CampaignOCPrcnt','CampaignOCPrcnt');
        failureData.put('CampaignPartsPrcnt','CampaignPartsPrcnt');
        failureData.put('CampaignTowingPrcnt','CampaignTowingPrcnt');
        failureData.put('CampaignTravelPrcnt','CampaignTravelPrcnt');
        failure.add(failureData);
        
        //Claimables 
        List<Map<String, String>> claimable = new List<Map<String, String>> ();
        Map<String, String> ocData = new Map<String,String>{};
        ocData.put('Item','Item');
        ocData.put('OtherClaimableDetails','OtherClaimableDetails');
        ocData.put('ClaimedReason','ClaimedReason');
        ocData.put('ClaimedAmount','ClaimedAmount');
        ocData.put('ClaimedAmount','ClaimedAmount');
        claimable.add(ocData); 
        
        //Parts
        List<Map<String, String>> parts = new List<Map<String, String>> ();
        Map<String, String> partData = new Map<String,String>{};
        partData.put('PartNumber','PartNumber');
        partData.put('QtyClaimed','QtyClaimed');
        partData.put('PartUnitPrice','PartUnitPrice');
        partData.put('PartPercentage','PartPercentage');
        partData.put('ReplacementReason','ReplacementReason');
        partData.put('PartsReturnFlag','PartsReturnFlag');
        partData.put('RIDNumber','RIDNumber');
        partData.put('TrackingNumber','TrackingNumber');
        partData.put('WaiverProcess','WaiverProcess');
        parts.add(partData); 
    
        //SRT  
        List<Map<String, String>> srt= new List<Map<String, String>> ();
        Map<String, String> srtData = new Map<String,String>{};
        srtData.put('SRTCode','SRTCode');
        srtData.put('SRTAccessCode','SRTAccessCode');
        srtData.put('SRTHours','SRTHours');
        srtData.put('SRTQty','SRTQty');
        srtData.put('SRTPrcnt','SRTPrcnt');
        srtData.put('OutOfChasis','OutOfChasis');
        srtData.put('OverlapHrs','OverlapHrs');
        srtData.put('Offiste','Offiste');
        srt.add(srtData);
        
        //Travel
        List<Map<String, String>> travel= new List<Map<String, String>> ();
        Map<String, String> travelData = new Map<String,String>{};
        travelData.put('TravelType','TravelType');
        travelData.put('TravelMode','TravelMode');
        travelData.put('OtherModeDetails','OtherModeDetails');
        travelData.put('BaseFare','BaseFare');
        travelData.put('Hours','Hours');
        travelData.put('Distance','Distance');
        travelData.put('MealsAmount','MealsAmount');
        travelData.put('TowingAmount','TowingAmount');
        travelData.put('TravelType','TravelType');
        travel.add(travelData);
        
        String JSONRequest = CSS_WS_CreateClaimSubmissionRequest.createClaimSubmissionRequest (header, complaints, promotionIds, multiESN, notes, failure, claimable, parts, srt, travel);
        System.debug (JSONRequest);
        System.assertNotEquals(null,JSONRequest,'The created JSON is null');//Verify the created JSON is not null
    }
}