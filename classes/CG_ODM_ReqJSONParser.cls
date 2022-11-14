public class CG_ODM_ReqJSONParser {

    public class AcctCodeInfo {
        public String accountCodeType;
        public String chryslerFlag;
        public String multiESNFlag;
        public String accountCodeWarrantyFlag;
    }

    public Header Header;
    public Request Request;

    public class SrtList {
        public String lineNumber;
        public String code;
        public String hours;
        public String offsiteCheck;
        public String description;
        public String quantity;
        public String srtAllowedFlag;
    }

    public class Request {
        public String DecisionID;
        public Claim claim;
    }

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class Target {
        public String TargetID;
    }

    public class ComplaintCode {
        public String code;
    }

    public class HeaderCampaign {
        public String campaignId;
        public String campaignType;
        public String expiryDateNA;
        public String expiryDateIntl;
        public String effectiveDate;
        public String status;
        public String completeIndicator;
        public String multiFlag;
        public String cmpEngineStatusCode;
    }

    public class Campaign {
        public String accountCode;
        public String campaignId;
        public String campaignType;
        public String completeIndicator;
        public String effectiveDate;
        public String engineComponentCode;
        public String expiryDateIntl;
        public String expiryDateNA;
        public String failMode;
        public String multiFlag;
        public String status;
        public String systemCode;
        public String cmpEngineStatusCode;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public class AdditionalESN {
        public String ESN;
    }

    public class Parts {
        public String lineNumber;
        public String partId;
        public String partPrice;
        public String partName;
        public String reconPartFlag;
        public String priceBook;
        public String exceptionPriceBook;
        public String channelCode;
        public String standardPriceBook;
        public String pricingRegion;
        public String partAllowedFlag;
        public String partReturnFlag;
        public String qtyApproved;
        public String adjPartPercentage;
    }

    public class ServiceProvider {
        public String channelOfDistribution;
        public String region;
        public String claimAllowedDays;
        public String territory;
        public String outfileAllClaimsFlag;
        public String regionCode;
        public String inactiveDate;
        public String status;
        public String groupName;
        public String channelDescription;
        public String paccarChecked;
        public String ltaChecked;
        public String engineEffectiveDate;
        public String engineExpirationdate;
        public String serviceModelName;
        public String oemCode;
        public String spState;
        public String spCountry;
        public String spServiceLevel;
        public String spWarrantyTrainingStatus;
        public String spCertificationEndDate;
        public String spSCMDollarAmt;
        public String spSCMDeductiblePct;
    }

    public class OtherClaimables {
        public String lineNumber;
        public String item;
        public String details;
        public String amount;
    }

    public class Travels {
        public String lineNumber;
        public String hours;
        public String mealsCharges;
        public String towingCharges;
        public String travelDistance;
    }

    public class Engine {
        public String billToCode;
        public String warrantyIndicatorFlag;
        public String marineFlag;
        public String buildDate;
        public String etoConversionDate;
        public String productApplicationDesp;
        public String oemCode;
        public String designPhaseCode;
        public String engineFamilyCode;
        public String serviceModel;
    }

    public class Failure {
        public String lineNumber;
        public String failCode;
        public String failMode;
        public String accountCode;
        public String payCode;
        public String status;
        public String authorizationNumber;
        public String approvalCode;
        public String campaignId;
        public String coverageType;
        public String totalLaborAmt;
        public String totalSRTHours;
        public String totalTowingAmt;
        public String accountCodeDesp;
        public String policyFlag;
        public String programID;
        public String overrideFlag;
        public String inShopCampaignFlag;
        public String travelCoveredFlag;
        public String GSQID;
        public AcctCodeInfo acctCodeInfo;
        public Campaign campaign;
    }

    public class Claim {
        public String claimNumber;
        public String claimStatus;
        public String claimSource;
        public String cmiServiceProviderCode;
        public String serviceModelName;
        public String cmiEngineSerialNumber;
        public String productApplicationCode;
        public String warrantyStartDate;
        public String failureDate;
        public String claimCreatedDate;
        public String claimSubmittedDate;
        public String claimReceivedDate;
        public Engine engine;
        public String engineFamily;
        public String failurePoint;
        public String bisFlag;
        public String multiESNFlag;
        public String failureMeasure;
        public String reconPartsWarrantyFlag;
        public String manualAdjudicationFlag;
        public String Status;
        public String roNumber;
        public String engineApplicationCode;
        public String serviceProviderName;
        public String distributorCode;
        public String totalClaimAmt;
        public String groupName;
        public String thresholdAmount;
        public String thresholdHrs;
        public String approverName;
        public String level;
        public String button;
        public String newPartsWarrantyFlag;
        public String possessionFlag;
        public String ecmCalibBefore;
        public String ecmCalibAfter;
        public String manufacturer;
        public String paccarFlag;
        public String paccarCertifiedLocationFlag;
        public String paccarPaymentRoutingFlag;
        public String countryCode;
        public String ownerName;
        public String penalty;
        public String certificationFlag;
        public String roadRelayWarrantyFlag;
        public String headerCampaignId;
        public String modelSeries;
        public String applicationName;
        public String claimSubSource;
        public HeaderCampaign HeaderCampaign;
        public List<AdditionalESN> AdditionalESN;
        public List<ComplaintCode> ComplaintCode;
        public ServiceProvider serviceProvider;
        public List<Failure> failure;
        public List<Parts> parts;
        public List<OtherClaimables> otherClaimables;
        public List<Travels> travels;
        public List<SrtList> srtList;
    }


    public static CG_ODM_ReqJSONParser parse(String json) {
        return (CG_ODM_ReqJSONParser) System.JSON.deserialize(json, CG_ODM_ReqJSONParser.class);
    }
}