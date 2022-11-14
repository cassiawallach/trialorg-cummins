@isTest
private class CSS_WS_CreateODMRequest_Test {

    // Test for the creation of JSON Request for HEADER
    @isTest static void testcreateODMHeaderRequest() {
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        header.put('engineApplicationCode','engineApplicationCode');
        
        //Test the JSON's creation
        String JSONRequest = CSS_WS_CreateODMRequest.createODMHeaderRequest (header);
        
        system.debug (JSONRequest);
        
        // Verify the created JSON is not null
        System.assertNotEquals(null,JSONRequest,'The created JSON is null.');
    }
    
    // Test for the creation of JSON Request for FAILURE
    @isTest static void testcreateODMFailureRequest() {
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        header.put('engineApplicationCode','engineApplicationCode');
        
        //FAILURE       
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode');   
        failureData.put('inShopCampaignFlag','inShopCampaignFlag');
        failure.add(failureData);
        
        //Test the JSON's creation
        String JSONRequest = CSS_WS_CreateODMRequest.createODMFailureRequest (header, failure);
        
        system.debug (JSONRequest);
        
        // Verify the created JSON is not null
        System.assertNotEquals(null,JSONRequest,'The created JSON is null.');
    }
    
    // Test for the creation of JSON Request for PARTS
    @isTest static void testcreateODMPartsRequest() {
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        header.put('engineApplicationCode','engineApplicationCode');
        
        //FAILURE      
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode');   
        failureData.put('inShopCampaignFlag','inShopCampaignFlag');
        failure.add(failureData);
        
        //PARTS
        List<Map<String, String>> parts = new List<Map<String, String>> ();
        Map<String, String> partData = new Map<String,String>{};
        partData.put('partPrice','partPrice');
        partData.put('partId','partId');
        partData.put('partsProductCode','partsProductCode');
        parts.add(partData); 
                
        //Test the JSON's creation
        String JSONRequest = CSS_WS_CreateODMRequest.createODMPartsRequest (header, failure, parts);
        
        system.debug (JSONRequest);
        
        // Verify the created JSON is not null
        System.assertNotEquals(null,JSONRequest,'The created JSON is null.');
    }
    
    // Test for the creation of JSON Request for TRAVEL
    @isTest static void testcreateODMTravelRequest() {
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        header.put('engineApplicationCode','engineApplicationCode');
        
        //FAILURE      
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode');  
        failureData.put('inShopCampaignFlag','inShopCampaignFlag'); 
        failure.add(failureData);
        
        //TRAVEL
        List<Map<String, String>> travel = new List<Map<String, String>> ();
        Map<String, String> travelData = new Map<String,String>{};
        travelData.put('mealsCharges','mealsCharges');
        travelData.put('towingCharges','towingCharges');
        travelData.put('hours','hours');
        travelData.put('travelDistance','travelDistance');        
        travel.add(travelData);
        
        //Test the JSON's creation
        String JSONRequest = CSS_WS_CreateODMRequest.createODMTravelRequest (header, failure, travel);
        
        system.debug (JSONRequest);
        
        // Verify the created JSON is not null
        System.assertNotEquals(null,JSONRequest,'The created JSON is null.');
    }
    
    // Test for the creation of JSON Request for OTHER CLAIMABLES
    @isTest static void testcreateODMClaimableRequest() {
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        header.put('engineApplicationCode','engineApplicationCode');
        
        //FAILURE      
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode'); 
        failureData.put('inShopCampaignFlag','inShopCampaignFlag');  
        failure.add(failureData);
        
        //CLAIMABLE 
        List<Map<String, String>> claimable = new List<Map<String, String>> ();
        Map<String, String> ocData = new Map<String,String>{};
        ocData.put('Amount','Amount');
        ocData.put('details','details');
        ocData.put('item','item');
        claimable.add(ocData); 
        
        //Test the JSON's creation
        String JSONRequest = CSS_WS_CreateODMRequest.createODMClaimableRequest (header, failure, claimable);
        
        system.debug (JSONRequest);
        
        // Verify the created JSON is not null
        System.assertNotEquals(null,JSONRequest,'The created JSON is null.');
    }
    
    // Test for the creation of JSON Request for SRT
    @isTest static void testcreateODMSRTRequest() {
         //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        header.put('engineApplicationCode','engineApplicationCode');
        
        //FAILURE      
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode');   
        failureData.put('inShopCampaignFlag','inShopCampaignFlag');
        failure.add(failureData);
        
        //SRT
        List<Map<String, String>> srt= new List<Map<String, String>> ();
        Map<String, String> srtData = new Map<String,String>{};
        srtData.put('description','description');
        srtData.put('hours','hours');
        srtData.put('offsiteCheck','offsiteCheck');
        srtData.put('quantity','quantity');
        srtData.put('code','code');
        srt.add(srtData);
                
        //Test the JSON's creation
        String JSONRequest = CSS_WS_CreateODMRequest.createODMSRTRequest (header, failure, srt);
        
        system.debug (JSONRequest);
        
        // Verify the created JSON is not null
        System.assertNotEquals(null,JSONRequest,'The created JSON is null.');
    }
    
    // Test for the creation of complete JSON Request 
    @isTest static void testcreateODMCompleteRequest() {
        
        //HEADER
        Map<String, String> header = new Map<String,String>{};
        header.put('bisFlag','bisFlag');
        header.put('cmiEngineSerialNumber','cmiEngineSerialNumber');
        header.put('cmiServiceProviderCode','cmiServiceProviderCode');
        header.put('engineFamily','engineFamily');
        header.put('failureDate','failureDate');
        header.put('failureMeasure','failureMeasure');
        header.put('failurePoint','failurePoint');
        header.put('manualAdjudicationFlag','manualAdjudicationFlag');
        header.put('multiESNFlag','multiESNFlag');
        header.put('productApplicationCode','productApplicationCode');
        header.put('roNumber','roNumber');
        header.put('serviceModelName','serviceModelName');
        header.put('warrantyStartDate','warrantyStartDate');
        header.put('region','region');
        header.put('channelOfDistribution','channelOfDistribution');
        header.put('regionCode','regionCode');
        header.put('territory','territory');
        header.put('outfileAllClaimsFlag','outfileAllClaimsFlag');
        header.put('claimAllowedDays','claimAllowedDays');
        header.put('engineFamilyCode','engineFamilyCode');
        header.put('marineFlag','marineFlag');
        header.put('buildDate','buildDate');
        header.put('etoConversionDate','etoConversionDate');
        header.put('warrantyIndicatorFlag','warrantyIndicatorFlag');
        header.put('productApplicationDesp','productApplicationDesp');
        header.put('engineApplicationCode','engineApplicationCode');
        
        //FAILURE      
        List<Map<String, String>> failure = new List<Map<String, String>> ();
        Map<String, String> failureData = new Map<String,String>{};
        failureData.put('campaignId','campaignId');
        failureData.put('payCode','payCode');
        failureData.put('totalLaborAmt','totalLaborAmt');
        failureData.put('status','status');
        failureData.put('authorizationNumber','authorizationNumber');
        failureData.put('approvalCode','approvalCode');
        failureData.put('totalTowingAmt','totalTowingAmt');
        failureData.put('accountCode','accountCode');
        failureData.put('failCode','failCode');
        failureData.put('coverageType','coverageType');
        failureData.put('failMode','failMode');
        failureData.put('accountCodeType','accountCodeType');
        failureData.put('multiESNFlag','multiESNFlag');
        failureData.put('accountCode','accountCode');
        failureData.put('inShopCampaignFlag','inShopCampaignFlag');   
        failure.add(failureData);
        
        //PARTS
        List<Map<String, String>> parts = new List<Map<String, String>> ();
        Map<String, String> partData = new Map<String,String>{};
        partData.put('partPrice','partPrice');
        partData.put('partId','partId');
        parts.add(partData); 
        
        //TRAVEL
        List<Map<String, String>> travel = new List<Map<String, String>> ();
        Map<String, String> travelData = new Map<String,String>{};
        travelData.put('mealsCharges','mealsCharges');
        travelData.put('towingCharges','towingCharges');
        travelData.put('hours','hours');
        travelData.put('travelDistance','travelDistance');        
        travel.add(travelData);
        
        //CLAIMABLE 
        List<Map<String, String>> claimable = new List<Map<String, String>> ();
        Map<String, String> ocData = new Map<String,String>{};
        ocData.put('Amount','Amount');
        ocData.put('details','details');
        ocData.put('item','item');
        claimable.add(ocData); 
        
        //SRT
        List<Map<String, String>> srt= new List<Map<String, String>> ();
        Map<String, String> srtData = new Map<String,String>{};
        srtData.put('description','description');
        srtData.put('hours','hours');
        srtData.put('offsiteCheck','offsiteCheck');
        srtData.put('quantity','quantity');
        srtData.put('code','code');
        srt.add(srtData);
        
        //Test the JSON's creation
        String JSONRequest = CSS_WS_CreateODMRequest.createODMCompleteRequest (header, failure, parts, travel, claimable, srt);
        
        system.debug (JSONRequest);
        
        // Verify the created JSON is not null
        System.assertNotEquals(null,JSONRequest,'The created JSON is null.');
    }
    
}