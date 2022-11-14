public class CG_OP_CampaignsResJSON {

    public DataArea DataArea;
    public Header Header;

    public class Details {
        public String CampaignDesc;
        public String CampaignEndDate;
        public String CampaignStartDate;
        public List<SrtList> SrtList;
        public String FailCode;
        public String FailMode;
        public String InShopSrtLimitFlag;
        public String Status;
        public String MultipleTimes;
        public String BusinessUnit;
        public String CampaignType;
        public String CompleteIndicator;
        public List<PartList> PartList;
        public String CampaignNumber;
    }

    public class DataArea {
        public List<Details> Details;
    }


    public class Header {
        public String Status;
        public String ReturnCodeDescription;
        public String MessageIdentifier;//Added For Mule Integration
        public String ReturnCode;//Added For Mule Integration
        public String MessageType;//Added For Mule Integration
    }

    public class SrtList {
        public String SrtCode;
        public String SrtDescription;
    }

    public class PartList {
        public Integer PartQuantity;
        public String PartNumber;
        public String PartDescription;
    }


    public static CG_OP_CampaignsResJSON parse(String json) {
        return (CG_OP_CampaignsResJSON) System.JSON.deserialize(json, CG_OP_CampaignsResJSON.class);
    }
}