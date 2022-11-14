@istest
global class CSS_FN_Siebel_PaidClaimmock implements httpcalloutmock{
    global httpresponse respond(httprequest req)
    {
        httpresponse res = new httpresponse();
        res.setStatus('success');
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('{ "DataArea": { "DetailSRTs": [ { "SRTHours": 0.4, "SRTQty": 1, "PercentageAdjustment": 100, "AdjustmentReason": "", "AccessCode": "R", "SRTCode": "00-901-00" }, { "SRTHours": 0.2, "SRTQty": 1, "PercentageAdjustment": 100, "AdjustmentReason": "", "AccessCode": "B", "SRTCode": "TS-051-01" } ], "DetailOtherClaimables": [ { "Item": "", "Description": "1", "ApprovedAmount": 2452, "AdjustmentReason": "" } ], "DetailParts": [ { "AdjustmentPartsPercent": 100, "PartQty": 1, "PartNumber": "408998500RX", "AdjustmentReason": "" } ], "DetailTravel": [ { "TravelType": "Non-Commercial", "AdjustmentReason": "", "Distance": 2452, "Hours": 2.3, "LodgingAmount": 345, "MealsAmount": 46, "TowingDetails": 234 } ] }, "Header": { "MessageIdentifier": "", "ReturnCode": "", "ReturnCodeDescription": "", "Status": "Success" } }');
        return res;
    }

}