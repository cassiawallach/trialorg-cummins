@isTest
public class CG_BL_ANVL_Test {
    public static testmethod void CG_BL_ANVL_Method(){
            Account accRec = new Account();
                    //accRec.Type='Dealer Account';
                    accRec.CG_ANVL_Enabled__c=true;
                    accRec.name='CumminsNpower';
                    accRec.Type = 'Customer';
                    accRec.IAM_Service_Provider_Code__c = '52650';
                    accRec.CMI_Account_Status__c = 'Active';
                    accRec.IAM_Service_Provider_Code__c = '52650';
                    accRec.CSS_DistributorCode__c = '52650';
                    accRec.IAM_Service_Provider_Code__c = '52650';
                    
                    
            insert accRec;
            CSS_Job_Order__c jobRec = CSS_TestData.createJobOrder(false);
                    jobRec.Account__c=accRec.Id;
            insert jobRec;
            CSS_Job_Order__c cssJO = [SELECT Id, Name, Shop_Work_Order__c,Account__r.CG_ANVL_Enabled__c,Assigned_to__r.FederationIdentifier,
                     Category_Desc__c,Complaint_Type_Desc__c, ESN__c,Service_Model__c,Account__r.IAM_Service_Provider_Code__c,ApplicationCode__c, 
                     Application_Desc__c, Repair_Location__c,Customer_Name__c,Customer_Code__c, Assigned_to__c, Additional_Tech1__c,
                     Additional_Tech1__r.FederationIdentifier, Additional_Tech2__c,Additional_Tech2__r.FederationIdentifier, 
                     Additional_Tech3__c,Additional_Tech3__r.FederationIdentifier, Additional_Tech4__c,Additional_Tech4__r.FederationIdentifier,
                     Additional_Tech5__c,Additional_Tech5__r.FederationIdentifier, Additional_Tech6__c,Additional_Tech6__r.FederationIdentifier, 
                     Additional_Tech7__c,Additional_Tech7__r.FederationIdentifier, Additional_Tech8__c,Additional_Tech8__r.FederationIdentifier, 
                     Additional_Tech9__c,Additional_Tech9__r.FederationIdentifier, CreatedDate,Account__r.Name,LastModifiedDate 
                     FROM CSS_Job_Order__c WHERE Id=:jobRec.id];
        CG_OP_OAGWrapper CGTSR = new CG_OP_OAGWrapper();
        CGTSR.accessToken = '';
        CGTSR.response = null;
        CGTSR.request = null;
       	CGTSR.requestBody = '';
        CGTSR.methodNameSLLayer = '';
        CGTSR.totalAuthCallTime = 1L;
        CGTSR.totalServiceCallTime = 1L;
        CGTSR.methodStarted = '';
		CGTSR.serviceName = 'Test'      ;
        CGTSR.endPoint = '';
        CGTSR.exceptionFlag = false;
        CGTSR.errorMessage = '';
        CGTSR.exceptionMessage = '';
        CGTSR.appName = '';
        CSS_Integration_Error__c intDetails = new CSS_Integration_Error__c();        
        intDetails.Auth_Call_Time__c = (CGTSR.totalAuthCallTime != null ? CGTSR.totalAuthCallTime : 0);
        intDetails.Error_Description__c = 'Engine not connected to Telematics';
        intDetails.Processed_Data__c = '{"Request":{"DecisionID":"GUIDANZ","claim":{"warrantyStartDate":"05/27/2014","travels":[],"totalClaimAmt":"1.00","thresholdHrs":"","thresholdAmount":"","Status":"","srtList":[],"serviceProviderName":"","serviceProvider":{"territory":"100","status":"Active","spWarrantyTrainingStatus":"G","spState":"UT","spServiceLevel":"","spSCMDollarAmt":"0","spSCMDeductiblePct":"0","spCountry":"USA","spCertificationEndDate":"12/04/2019","serviceModelName":"ISX15 CM2350 X101","regionCode":"USCA","region":"NORTH AMERICA","paccarChecked":"N","outfileAllClaimsFlag":"N","oemCode":"232","ltaChecked":"Y","inactiveDate":"","groupName":"UT","engineExpirationdate":"","engineEffectiveDate":"","claimAllowedDays":"365","channelOfDistribution":"110","channelDescription":""},"serviceModelName":"ISX15 CM2350 X101","roNumber":"789345","roadRelayWarrantyFlag":"N","reconPartsWarrantyFlag":"N","productApplicationCode":"BB","possessionFlag":"","penalty":"","parts":[],"paccarPaymentRoutingFlag":"","paccarFlag":"","paccarCertifiedLocationFlag":"","ownerName":"","otherClaimables":[],"newPartsWarrantyFlag":"N","multiESNFlag":"N","modelSeries":"579","manufacturer":"PETERBILT","manualAdjudicationFlag":"","level":"0","headerCampaignId":"","HeaderCampaign":{"status":"","multiFlag":"","expiryDateNA":"","expiryDateIntl":"","effectiveDate":"","completeIndicator":"","cmpEngineStatusCode":"","campaignType":"","campaignId":""},"groupName":"","failurePoint":"0","failureMeasure":"Miles","failureDate":"11/16/2018","failure":[{"travelCoveredFlag":"","totalTowingAmt":"","totalSRTHours":"","totalLaborAmt":"","status":"Draft","programID":"","policyFlag":"","payCode":"E","overrideFlag":"N","lineNumber":"a0r29000001HzNkAAK","inShopCampaignFlag":"","GSQID":"","failMode":"77","failCode":"LNDS","coverageType":"CAP","campaignId":"F07000030","campaign":{"systemCode":"","status":"","multiFlag":"","failMode":"","expiryDateNA":"","expiryDateIntl":"","engineComponentCode":"","effectiveDate":"","completeIndicator":"","cmpEngineStatusCode":"","campaignType":"","campaignId":"","accountCode":""},"authorizationNumber":"","approvalCode":"","acctCodeInfo":{"multiESNFlag":"","chryslerFlag":"N","accountCodeWarrantyFlag":"","accountCodeType":"CAP"},"accountCodeDesp":"","accountCode":"P2"}],"engineFamily":"ISX/SIGNATURE(APEX)","engineApplicationCode":"130","engine":{"warrantyIndicatorFlag":"Y","serviceModel":"ISX15 CM2350 X101","productApplicationDesp":"BB","oemCode":"01608","marineFlag":"A","etoConversionDate":"","engineFamilyCode":"10","designPhaseCode":"61","buildDate":"02/17/2014","billToCode":"01608"},"ecmCalibBefore":"","ecmCalibAfter":"","distributorCode":"2881","countryCode":"","ComplaintCode":[],"cmiServiceProviderCode":"19134","cmiEngineSerialNumber":"79720629","claimSubSource":"","claimSubmittedDate":"","claimStatus":"In Review","claimSource":"Guidanz","claimReceivedDate":"","claimNumber":"C0000003018","claimCreatedDate":"11/16/2018","certificationFlag":"","button":"","bisFlag":"N","approverName":"","applicationName":"Guidanz","AdditionalESN":[]}},"Header":{"Target":{"TargetID":"ODM"},"Sender":{"ServiceName":"ODMFailureValidation","SenderID":"CSS"}}}';
        intDetails.Response_Body__c = '{"Header":{"Sender":{"ServiceName":"ODMFailureValidation","SenderID":"CSS"},"Target":{"TargetID":"ODM"}},"Response":{"DecisionID":"2018-11-16T04:36:52.197-05:00","claim":{"thresholdAmount":"","cmiEngineSerialNumber":79720629,"claimSource":"Guidanz","paccarCertifiedLocationFlag":"","paccarPaymentRoutingFlag":"","newPartsWarrantyFlag":"N","paccarFlag":"","level":0,"button":"","roadRelayWarrantyFlag":"N","penalty":0,"serviceProvider":{"region":"NORTH AMERICA","regionCode":"USCA","groupName":"UT","territory":100,"status":"Active","outfileAllClaimsFlag":"N","engineEffectiveDate":"","spState":"UT","oemCode":232,"channelOfDistribution":110,"spSCMDeductiblePct":0,"spSCMDollarAmt":0,"spCountry":"USA","engineExpirationdate":"","paccarChecked":"","spCertificationEndDate":"2019-12-04T00:00:00-06:00","serviceModelName":"ISX15 CM2350 X101","ltaChecked":"Y","channelDescription":"","spServiceLevel":"","spWarrantyTrainingStatus":"G","inactiveDate":"","claimAllowedDays":365},"serviceProviderName":"","ownerName":"","thresholdHrs":"","status":"SUCCESS","productApplicationCode":"BB","engine":{"serviceModel":"ISX15 CM2350 X101","productApplicationDesp":"BB","marineFlag":"A","designPhaseCode":61,"engineFamilyCode":10,"warrantyIndicatorFlag":"Y","buildDate":"2014-02-17T00:00:00-06:00","billToCode":"01608","etoConversionDate":"","oemCode":"01608"},"countryCode":"","claimSubmittedDate":"","ecmCalibBefore":0,"failure":[{"GSQID":"","accountCodeDesp":"","payCode":"E","status":"Draft","totalLaborAmt":"","authorizationNumber":"","approvalCode":"","acctCodeInfo":{"chryslerFlag":"N","accountCodeType":"CAP","multiESNFlag":"","accountCodeWarrantyFlag":""},"overrideFlag":"N","totalTowingAmt":"","programID":"","accountCode":"P2","failCode":"LNDS","coverageType":"CAP","failMode":77,"lineNumber":"a0r29000001HzNkAAK","policyFlag":"","totalSRTHours":"","campaign":{"campaignId":"","engineComponentCode":"","completeIndicator":"","cmpEngineStatusCode":"","campaignType":"","status":"","systemCode":"","expiryDateNA":"","expiryDateIntl":"","accountCode":"","failMode":"","effectiveDate":"","multiFlag":""},"travelCoveredFlag":""}],"manualAdjudicationFlag":"","manufacturer":"PETERBILT","claimCreatedDate":"2018-11-16T00:00:00-06:00","claimNumber":"C0000003018","claimSubSource":"","groupName":"","reconPartsWarrantyFlag":"N","historyClaimFlag":"N","claimReceivedDate":"","failureDate":"2018-11-16T00:00:00-06:00","multiESNFlag":"N","totalClaimAmt":1,"distributorCode":2881,"roNumber":789345,"serviceModelName":"ISX15 CM2350 X101","modelSeries":579,"engineApplicationCode":130,"warrantyStartDate":"2014-05-27T00:00:00-05:00","approverName":"","engineFamily":"ISX/SIGNATURE(APEX)","certificationFlag":"","failurePoint":0,"applicationName":"Guidanz","claimStatus":"In Review","failureMeasure":"Miles","cmiServiceProviderCode":19134,"ecmCalibAfter":0,"bisFlag":"N","possessionFlag":""}}}';
        intDetails.Service_Call_Time__c = (CGTSR.totalServiceCallTime != null ? CGTSR.totalServiceCallTime : 0);
        intDetails.Service_Job_Number__c = jobRec.Id;
        intDetails.Service_Name__c = 'ANVLService';
        intDetails.Source__c = 'ANVL';
        insert intDetails;
        CSS_Integration_Details__c interRec = new CSS_Integration_Details__c();
        interRec.Logging__c='BOTH';
        interRec.Name='CG_ANVLService';
        insert interRec;
        Test.startTest();
                 CG_BL_ANVL.ANVL_RequestResponse(cssJO.id);
                 CG_BL_ANVL.saveANVLResponse(CGTSR,jobRec.id);
                 CG_BL_ANVL.insertIntegrationDetails(CGTSR, jobRec.id);
        Test.stopTest();
    }
}