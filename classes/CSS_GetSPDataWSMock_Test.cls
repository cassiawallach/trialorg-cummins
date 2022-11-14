@istest
global class CSS_GetSPDataWSMock_Test implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"DataArea":{"Policy":"N","GroupName":"","RegionCode":"INTL","PromotionId":"Y","RepairLevel":"N","ViewDollarAmount":"N","PrimaryOEMName":"CUMMINS","AccountStatus":"Active","MaxClaimAmt":"999999","WWSPSSPFlag":"Y","CommunicationOccurrence":"","FreezeSubmitButton":"N","Territory":"CHINA","LTAFlag":"N","SPCountry":"China","CommunicationMethod":"","PACCAR":"N","State":"","BusinessUnit":"EBU","Region":"INTERNATIONAL","WarrantyFax":"0531-82266632","SCMDollarAmt":"0","WarrantyEmail":"","DistributorHQName":"CUMMINS (CHINA) INVESTMENT CO., LTD(04534)","SCMDeductiblePercentage":"0","ChannelCode":"110","DSID":"N","FieldServiceLaborRate":"18.96","TravelRate":"0.36","ClaimAllowedDays":"365","WarrantyCertificationEndDate":"2017-12-11 00:00:00.0","WarrantyTrainingCertification":"Y","NewOEM":"N","TerritoryCode":"570","PSBUProductCertification":"N","DTNAFlag":"N","ChannelOfDistribution":"110-DEALER","PrimaryOEMCode":"103","OutfileAllClaims":"N","DisableWebAccessFlag":"N","ProductCertification":"N","CutOffClaimAmt":"250","DistributorHQCode":"04534","WarrantyTrainingStatus":"G","CMISPExpirationDate":"2019-04-30 00:00:00.0","InShopLaborRate":"18.96","CostEffectiveExclusion":"N","PMUSplitPayment":"N","TechActualHoursRequired":"N","CampaignTRP":"Y"},"Header":{"Status":"Success"}}');
            //res.setStatusCode(200); 
        }
        return res;
    }
    
}