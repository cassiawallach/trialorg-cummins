Public Class CSS_WS_J2A_ODM_PreSubmit{

    Public Response Response;

    Public Class Response{
        Public String DecisionID; 
        Public Claim claim;
    }
    
    Public Class Claim{
        Public String groupName;
        Public String historyClaimFlag; 
        Public String reconPartsWarrantyFlag;
        Public String failureDate; 
        Public String cmiEngineSerialNumber;
        Public String multiESNFlag;
        Public String claimSource;
        Public String totalClaimAmt;
        Public String roNumber; 
        Public String level; 
        Public String serviceModelName;
        Public String warrantyStartDate;
        Public String engineFamily;
        Public String failurePoint;
        Public String productApplicationCode;
        Public String status;
        Public String claimStatus;
        Public String failureMeasure;
        Public String cmiServiceProviderCode;
        Public String manualAdjudicationFlag;
        Public String bisFlag; 
        Public String claimNumber;
        Public String claimSubmittedDate;
        Public ServiceProvider serviceProvider;
        Public Engine engine; 
        Public List<Messages> messages;
        Public List<Failures> failures;
    }   
    
    Public Class ServiceProvider{
        Public String region;
        Public String channelOfDistribution;
        Public String regionCode; 
        Public String engineExpirationdate;
        Public String territory; 
        Public String outfileAllClaimsFlag; 
        Public String engineEffectiveDate;
        Public String claimAllowedDays;
    }
    
    Public Class Engine{
        Public String productApplicationDesp;
        Public String marineFlag; 
        Public String engineFamilyCode; 
        Public String warrantyIndicatorFlag;
        Public String buildDate;
        Public String etoConversionDate;
    }
    
    Public Class Messages{
        Public String description; 
        Public String code;
        Public String type;
    }
    
    Public Class Failures{
        Public String payCode; 
        Public String status;
        Public String totalLaborAmt; 
        Public String authorizationNumber; 
        Public String acctCodeInfo;
        Public String totalTowingAmt;
        Public String accountCode; 
        Public String failCode;
        Public String coverageType; 
        Public String failMode;
        Public String lineNumber;
        Public String totalSRTHours;
        Public String approvalCode;
        Public String chryslerFlag;
        Public String accountCodeType;
        Public String multiESNFlag; 
        Public String campaignId;
        Public Campaign campaign;
        Public String inShopCampaignFlag;
        Public List<SrtList> srtList; 
        Public List<Parts> parts;  
        Public List<Travels> travels; 
        Public List<OtherClaimables> otherClaimables;     
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
        Public String multiFlag;
        Public String expiryDateNA;
        Public String effectiveDate;
        Public String expiryDateIntl;
    }
    
    Public Class SrtList{
        Public String hours;
        Public String quantity;
        Public String lineNumber;
        Public String description;
        Public String offsiteCheck;
        Public String code;
        Public String srtAllowedFlag;
    }
    
    Public Class Parts{
        Public String partPrice;
        Public String lineNumber;
        Public String partId;
        Public String partAllowedFlag;
    }
    
    Public Class Travels{
        Public String mealsCharges;
        Public String towingCharges;
        Public String hours;
        Public String travelDistance;
        Public String lineNumber;
    }  
    
    Public Class OtherClaimables{
        Public String amount;
        Public String lineNumber;
        Public String details;
        Public String item;
    }
     
    Public Static CSS_WS_J2A_ODM_PreSubmit parse(String json){
        return (CSS_WS_J2A_ODM_PreSubmit) System.JSON.deserialize(json, CSS_WS_J2A_ODM_PreSubmit.class);
    }
}