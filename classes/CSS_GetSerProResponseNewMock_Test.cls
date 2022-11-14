@isTest
global class CSS_GetSerProResponseNewMock_Test implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        {
            string dt = string.valueOf(date.today());
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"DataArea":{"InShopLaborRate": "19.06","FieldServiceLaborRate": "19.06","Region": "INTERNATIONAL","State":"State","RegionCode":"RegionCode","ChannelCode": "110","TravelRate": "0.37","Territory": "CHINA","ChannelOfDistribution": "110-DEALER","TerritoryCode": "TerritoryCode","PrimaryOEMName": "PrimaryOEMName","PrimaryOEMCode": "PrimaryOEMCode","ProductCertification": "ProductCertification","WarrantyTrainingCertification": "WarrantyTrainingCertification","RepairLevel": "RepairLevel","PromotionId": "PromotionId","CostEffectiveExclusion": "CostEffectiveExclusion","FreezeSubmitButton": "FreezeSubmitButton","DisableWebAccessFlag": "DisableWebAccessFlag","Policy": "Policy","CampaignTRP": "CampaignTRP","OutfileAllClaims": "110-OutfileAllClaims","PMUSplitPayment": "110-PMUSplitPayment","DSID": "110-DSID","DTNAFlag": "110-DTNAFlag","PACCAR": "110-PACCAR","NewOEM": "110-NewOEM","ViewDollarAmount": "110-ViewDollarAmount","TechActualHoursRequired": "110-TechActualHoursRequired","warrantyTrainingStatus": "110-warrantyTrainingStatus","GroupName": "110-GroupName","AccountStatus": "110-AccountStatus","ClaimAllowedDays": "110-ClaimAllowedDays","WarrantyCertificationEndDate": "110-WarrantyCertificationEndDate","BusinessUnit": "110-BusinessUnit","CMISPExpirationDate": "110-CMISPExpirationDate","LTAFlag": "110-LTAFlag","WarrantyFax": "110-WarrantyFax","WarrantyEmail": "110-WarrantyEmail","CommunicationMethod": "110-CommunicationMethod","CommunicationOccurrence": "110-CommunicationOccurrence","MaxClaimAmt": "110-MaxClaimAmt","CutOffClaimAmt": "110-CutOffClaimAmt","SCMDeductiblePercentage": "110-SCMDeductiblePercentage","SCMDollarAmt": "110-SCMDollarAmt","DistributorHQCode": "110-DistributorHQCode","DistributorHQName": "110-DistributorHQName","WWSPSSPFlag": "110-WWSPSSPFlag","SPCountry": "110-SPCountry","Details":{"PromotionID":"PromotionID"}},"Header":{"Status":"Success"},"Details":{"PromotionID":"PromotionID"}}');
        }
        return res;        
    }
}