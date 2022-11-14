public class CG_WPR_SBL_SPHeader {

    public Header Header;
    public DataArea DataArea;

    public class Header {
        public String Status;
        public String MessageIdentifier;
        public String ReturnCodeDescription;
        public String ReturnCode; //new field added
        public String MessageType; //new field added
    }

    public class DataArea {
        public List<HeaderInfo> HeaderInfo;
    }

    public class HeaderInfo {
        public String SpCode;
        public String SpRowId;
        public String SpName;
        public String ChannelOfDistribution;
        public String ChannelCode;
        public String RssRespBranchCode;
        public String RssRespBranchName;
        public String RespBranchCode;
        public String RespBranchName;
        public String SpBillToCode;
        public String SpBillToName;
        public String DistHqCode;
        public String DistHqName;
        public String SpFirstName;
        public String SpLastName;
        public String SpPhone;
        public String SpEmail;
        public String WwspsFlag;
        public String AccountStatus;
        public String BusinessUnit;
        public String SpRecertificationDate;
        public String SpCreatedDate;
        public String SpUpdatedDate;
        public String PromotionIdFlag;
        public String ProductCertificationFlag;
        public String CertificationEndDate;
        public String WarrantyTrainingStatus;
        public String Territory;
        public String WrntyTrainingCertification;
        public String Region;
        public String TerritoryCode;
        public String RegionCode;
        public String PrimaryOEMName;
        public String PrimaryOEMCode;
        public String PsbuProductCertification;
        public String RepairLevel;
        public String CostEffectiveExclusion;
        public String FreezeSubmitButton;
        public String DisableWebAccessFlag;
        public String Policy;
        public String CampaignTrp;
        public String OutfileAllClaims;
        public String PmuSplitPayment;
        public String DsId;
        public String DtnaFlag;
        public String Paccar;
        public String NewOEM;
        public String ViewDollarAmount;
        public String TechActualHoursRequired;
        public String GroupName;
        public String ClaimAllowedDays;
        public String CmiSpExpirationDat;
        public String LtaFlag;
        public String WarrantyFax;
        public String WarrantyEmail;
        public String CommunicationMethod;
        public String CommunicationOccurrence;
        public String MaxClaimAmt;
        public String CutOffClaimAmt;
        public String ScmDeductible;
        public String ScmDollarAmt;
        public String PhyAddress1;
        public String PhyAddress2;
        public String PhyAddress3;
        public String PhyAddress4;
        public String PhyCity;
        public String PhyState;
        public String PhyCountry;
        public String PhyZipPostalCode;
        public String MailAddress1;
        public String MailAddress2;
        public String MailAddress3;
        public String MailAddress4;
        public String MailCity;
        public String MailState;
        public String MailCountry;
        public String MailZipPostalCode;
    }

    public static CG_WPR_SBL_SPHeader parse(String json) {
        return (CG_WPR_SBL_SPHeader) System.JSON.deserialize(json, CG_WPR_SBL_SPHeader.class);
    }
}