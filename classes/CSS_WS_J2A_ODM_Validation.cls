Public Class CSS_WS_J2A_ODM_Validation{

    Public Response Response;
    
    Public Class Response{
        Public String DecisionID;
        Public Claim claim;
    }
    
    Public Class Claim{
        Public String groupName;
        Public String historyClaimFlag;
        Public String reconPartsWarrantyFlag;
        Public String claimReceivedDate;
        Public String failureDate;
        Public String cmiEngineSerialNumber;
        Public String multiESNFlag;       
        Public String claimSource;
        Public String totalClaimAmt;  
        Public String distributorCode;
        Public String roNumber;
        Public String level;
        Public String serviceModelName;
        Public String engineApplicationCode;
        Public String warrantyStartDate;
        Public String approverName;
        Public String engineFamily;       
        Public String failurePoint;
        Public String ownerName;
        Public String serviceProviderName;       
        Public String productApplicationCode;
        Public String status;
        Public String claimStatus;
        Public String failureMeasure;
        Public String claimSubmittedDate;
        Public String cmiServiceProviderCode;
        Public String manualAdjudicationFlag;
        Public String bisFlag;
        Public String claimCreatedDate;
        Public String claimNumber;
        Public String penalty;
        Public String certificationFlag;
        Public String roadRelayWarrantyFlag;
        Public String button; 
        Public Engine engine;
        Public Eto eto;
        Public ServiceProvider serviceProvider;
        Public Failure failure;  
        Public SrtList srtList;
        Public Parts parts;
        Public Travels travels;
        Public OtherClaimables otherClaimables;        
        Public List<Messages> messages;
    }
    
    Public Class Engine{
        Public String serviceModel;
        Public String productApplicationDesp;
        Public String marineFlag;
        Public String designPhaseCode;
        Public String engineFamilyCode; 
        Public String warrantyIndicatorFlag;
        Public String buildDate;
        Public String billToCode;
        Public String etoConversionDate;
        Public String oemCode;  
    }
    
    Public Class Eto{
        Public String status;
    }

    Public Class ServiceProvider{
        Public String region;
        Public String groupName;       
        Public String regionCode;
        Public String territory;
        Public String status;
        Public String outfileAllClaimsFlag;       
        Public String engineEffectiveDate;
        Public String oemCode;
        Public String paccarChecked;
        Public String engineExpirationDate;
        Public String serviceModelName;
        Public String ltaChecked;
        Public String channelDescription;
        Public String inactiveDate;
        Public String claimAllowedDays;
        Public String channelOfDistribution;
    }

    Public Class Failure{
        Public String campaignId;
        Public String accountCodeDesp;
        Public String payCode;
        Public String totalLaborAmt;
        Public String status;
        Public String authorizationNumber;
        Public String approvalCode;
        Public String totalTowingAmt;
        Public String accountCode;
        Public String failCode;
        Public String coverageType;
        Public String failMode;
        Public String policyFlag;
        Public String lineNumber;
        Public String totalSRTHours;
        Public String inShopCampaignFlag;
        Public AcctCodeInfo acctCodeInfo;
        Public Campaign campaign;
    }

    Public Class SrtList{
        Public String description;
        Public String hours;
        Public String offsiteCheck;
        Public String lineNumber;
        Public String quantity;
        Public String code;
        Public String penalty;
        Public String srtAllowedFlag;
    }
    
    Public Class Parts{
        Public String reconPartFlag;
        Public String partName;
        Public String partPrice;
        Public String lineNumber;
        Public String partId;
        Public String priceBook;
        Public String channelCode;
        Public String standardPriceBook;
        Public String pricingRegion;
        Public String exceptionPriceBook;
        Public String partAllowedFlag;
        Public String partReturnFlag;
        Public String partsProductCode;
    }
    
    Public Class Travels{
        Public String mealsCharges;
        Public String towingCharges;
        Public String hours;
        Public String lineNumber;
        Public String travelDistance;
    }
    
    Public Class OtherClaimables{
        Public String amount;
        Public String details;
        Public String item;
        Public String lineNumber;
    }
    
    Public Class Messages{
        Public String description;
        Public String code;
        Public String type;
    }

    Public Class AcctCodeInfo{
        Public String chryslerFlag;
        Public String accountCodeType;
        Public String multiESNFlag;
    }
    
    Public Class Campaign{
        Public String accountCode;
        Public String engineComponentCode;
        Public String campaignId;
        Public String completeIndicator;
        Public String campaignType;
        Public String status;
        Public String systemCode;
        Public String failMode;
        Public String expiryDateNA;
        Public String effectiveDate;
        Public String multiFlag;
        Public String expiryDateIntl;
    }
    
    Public Static CSS_WS_J2A_ODM_Validation parse(String json){
        return (CSS_WS_J2A_ODM_Validation) System.JSON.deserialize(json, CSS_WS_J2A_ODM_Validation.class);
    }
}