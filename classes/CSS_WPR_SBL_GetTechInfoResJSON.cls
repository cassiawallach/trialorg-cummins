//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class CSS_WPR_SBL_GetTechInfoResJSON {

    public List<DataArea> DataArea;
    public Header Header;

    public class DataArea {
        public String SP_CODE;
        public String SPPROFILESTATUS;
        public List<TECH_CERTIFICATION> TECH_CERTIFICATION;
    }

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
        public String ReturnCode;
        public String MessageIdentifier;
    }

    public class SMNDETAILS {
        public String SMN;
    }

    public class TECH_CERTIFICATION {
        public String TechFName;
        public String TechLName;
        public String TechPromoID;
        public String TechLogin;
        public List<SMNDETAILS> SMNDETAILS;
    }


    public static CSS_WPR_SBL_GetTechInfoResJSON parse(String json) {
        return (CSS_WPR_SBL_GetTechInfoResJSON) System.JSON.deserialize(json, CSS_WPR_SBL_GetTechInfoResJSON.class);
    }


	/*    
    public List<DataArea> DataArea;
    public Header Header;

    public class DataArea {
        public String PROMOTION_ID_FLAG;
        public List<SP_CERTIFICATION> SP_CERTIFICATION;
        public String SP_CODE;
        public String PRODUCT_CERTIFICATION_FLAG;
        public String CERTIFICATIONENDDATE;
        public String WARRANTYTRAININGSTATUS;
        public String TERRITORY;
        public String WRNTY_TRAINING_CERTIFICATION;
        public String REGION;
        public String SPPROFILESTATUS;
        public list<TECH_CERTIFICATION> TECH_CERTIFICATION;
    }

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
        public String ReturnCode;
        public String MessageIdentifier;
    }

    public class SP_CERTIFICATION {
        public String SMN;
        public String OEM_NAME;
        public String START_DATE;
        public String END_DATE;
    }

    public class SMNDETAILS {
        public String SMN;
        public String QUAL_PASS_DT;
    }

    public class TECH_CERTIFICATION {
        public list<SMNDETAILS> SMNDETAILS;
        public String TechFName;
        public string TechPromoID;
        public string TechLogin;
        public String TechLName;
    }


    public static CSS_WPR_SBL_GetTechInfoResJSON parse(String json) {
        return (CSS_WPR_SBL_GetTechInfoResJSON) System.JSON.deserialize(json, CSS_WPR_SBL_GetTechInfoResJSON.class);
    } */


}