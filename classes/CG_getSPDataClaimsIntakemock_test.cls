@istest
Global class CG_getSPDataClaimsIntakemock_test implements httpcalloutmock{
    global httpresponse respond(httprequest req) 
    {
        httpresponse res = new httpresponse();
        res.setHeader('content-type','application/json');
        res.setStatus('Success');
        res.setStatusCode(200);
        string json = '{ "DataArea":    { "DistributorHQCode": "04534", "PromotionId": "N", "DSID": "N", "CommunicationMethod": "", "TravelRate": "0.4", "CutOffClaimAmt": "250", "Territory": "CHINA", "SCMDeductiblePercentage": "0", "TerritoryCode": "570", "NewOEM": "N", "DisableWebAccessFlag": "N", "WWSPSSPFlag": "Y", "AccountStatus": "Active", "FieldServiceLaborRate": "20.68", "Region": "INTERNATIONAL", "WarrantyFax": "0531-82266632", "BusinessUnit": "EBU", "LTAFlag": "N", "WarrantyTrainingCertification": "Y", "PrimaryOEMCode": "103", "OutfileAllClaims": "N", "FreezeSubmitButton": "N", "CMISPExpirationDate": "2018-03-09 00:00:00.0", "CostEffectiveExclusion": "N", "GroupName": "", "ChannelCode": "110", "PSBUProductCertification": "N", "DTNAFlag": "N", "WarrantyEmail": "", "CampaignTRP": "N", "RepairLevel": "N", "ViewDollarAmount": "N", "DistributorHQName": "CUMMINS (CHINA) INVESTMENT CO., LTD(04534)", "WarrantyCertificationEndDate": "2017-12-11 00:00:00.0", "InShopLaborRate": "20.68", "TechActualHoursRequired": "N", "Policy": "N", "PMUSplitPayment": "N", "WarrantyTrainingStatus": "G", "ProductCertification": "Y", "PrimaryOEMName": "CUMMINS", "ChannelOfDistribution": "110-DEALER", "PACCAR": "N", "SCMDollarAmt": "0", "MaxClaimAmt": "999999", "CommunicationOccurrence": "", "ClaimAllowedDays": "365" }, "Header": {"Status": "Success"} }';
        res.setBody(json);
        return res;
    }

}