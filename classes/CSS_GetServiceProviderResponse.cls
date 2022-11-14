/*
* Block comments with details of changes
*/
public class CSS_GetServiceProviderResponse {
    
    public DataArea DataArea;
    public Header Header;
    public Details Details;
    
    public class DataArea {
        public String InShopLaborRate;
        public String FieldServiceLaborRate;
        public String Region;
        public String State;
        public String RegionCode;
        public String ChannelCode;
        public String TravelRate;
        public String Territory;
        public String ChannelOfDistribution;
        public String TerritoryCode;
        // new code added by karthik
        public String PrimaryOEMName;
        public String PrimaryOEMCode;
        public String ProductCertification;
        public String PSBUProductCertification;
        public String WarrantyTrainingCertification;
        public String RepairLevel;
        public String PromotionId;
        public String CostEffectiveExclusion;
        public String FreezeSubmitButton;
        public String DisableWebAccessFlag;
        public String Policy;
        public String CampaignTRP;
        public String OutfileAllClaims;
        public String PMUSplitPayment;
        public String DSID;
        public String DTNAFlag;
        public String PACCAR;
        public String NewOEM;
        public String ViewDollarAmount;
        public String TechActualHoursRequired;
        public String warrantyTrainingStatus;
        public String GroupName;
        public String AccountStatus;
        public String ClaimAllowedDays;
        public String WarrantyCertificationEndDate;
        public String BusinessUnit;
        public String CMISPExpirationDate;
        public String LTAFlag;
        public String WarrantyFax;
        public String WarrantyEmail;
        public String CommunicationMethod;
        public String CommunicationOccurrence;
        public String MaxClaimAmt;
        public String CutOffClaimAmt;
        public String SCMDeductiblePercentage;
        public String SCMDollarAmt;
       // Removed by karthik as per the requriment #House of cards.
       // public String ProductEffectiveDate;
       // public String ProductExpirationDate;
        public String DistributorHQCode;
        public String DistributorHQName;
        public String WWSPSSPFlag;
        public String SPCountry; 
        //public String Country;
        public List<Details> Details;
    } 
    
    public class Header {
        public String Status;
        public string MessageIdentifier;
        public string ReturnCode;
        public string ReturnCodeDescription;
        public string MessageType;
    }
    
    public class Details {
        public String PromotionID;
    }
    
    public static CSS_GetServiceProviderResponse parse(String json) {
        return (CSS_GetServiceProviderResponse) System.JSON.deserialize(json, CSS_GetServiceProviderResponse.class);
    }
}