public class CG_SBL_GetApplicationcodeResWrapper {

    public Header Header;
    public List<DataArea> DataArea;

    public class DataArea {
        public String MarketingApplicationCode;
        public String MarketingApplicationDescription;
        public String ProductApplicationCode;
        public String ProductApplicationDescription;
        public String ProductFamilyCode;
    }

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
        public String ReturnCode;
        public String MessageIdentifier;
        public String MessageType;
    }


    public static CG_SBL_GetApplicationcodeResWrapper parse(String json) {
        return (CG_SBL_GetApplicationcodeResWrapper) System.JSON.deserialize(json, CG_SBL_GetApplicationcodeResWrapper.class);
    }
}