/**********************************************************************
Name: CG_OP_GetSPInfoResJSON
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This is a SPInfo response wrapper
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Surender M       04/04/2018     INITIAL DEVELOPMENT                    
***********************************************************************/
public class CG_OP_GetSPInfoResJSON {

    public Header Header;
    public List<DataArea> DataArea;

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
        public String ReturnCode;
        public String MessageIdentifier;
    }

    public class DataArea {
        public String SP_CODE;
        public String SP_NAME;
        public String SP_CHANNEL_OF_DISTRIBUTION;
        public String SP_CHANNEL_CODE;
        public String RSS_RESP_BRANCH_CODE;
        public String RSS_RESP_BRANCH_NAME;
        public String RESP_BRANCH_CODE;
        public String RESP_BRANCH_NAME;
        public String SP_BILL_TO_CODE;
        public String SP_BILL_TO_NAME;
        public String DIST_HQ_CODE;
        public String DIST_HQ_NAME;
        public String SP_FIRST_NAME;
        public String SP_LAST_NAME;
        public String SP_PHONE;
        public String SP_EMAIL;
        public String WWSPS_FLAG;
        public String ACCOUNT_STATUS;
        public String BUSINESS_UNIT;
        public String SP_RECERTIFICATION_DATE;
        public String CREATED_DATE;
        public String UPDATED_DATE;
        public String PROMOTION_ID_FLAG;
        public String PRODUCT_CERTIFICATION_FLAG;
        public String CERTIFICATION_END_DATE;
        public String WARRANTY_TRAINING_STATUS;
        public String TERRITORY;
        public String WRNTY_TRAINING_CERTIFICATION;
        public String REGION;
        public String SPCOUNTRY;
        public String CLAIM_ALLOWED_DAYS; //new field 
        public String TERRITORY_CODE; //new field  
        public String REPAIR_LEVEL; //new field
        public String CMI_SP_EXPIRATION_DATE; //new field 
        public String VIEW_DOLLAR_AMOUNT; //new field 
        public String DTNA_FLAG; //new field 
        public String CUT_OFF_CLAIM_AMT; //new field
        public String LTA_FLAG; //new field
        public String CAMPAIGN_TRP; //new field
        public String NEW_OEM; //new field
        public String COST_EFFECTIVE_EXCLUSION; //new field
        public String WARRANTY_FAX; //new field
        public String COMMUNICATION_OCCURRENCE; //new field
        public String PRIMARY_OEM_CODE; //new field
        public String POLICY; //new field
        public String PACCAR; //new field
        public String WARRANTY_EMAIL; //new field
        public String PMU_SPLIT_PAYMENT; //new field
        public String STATE; //new field
        public String SCM_DOLLAR_AMT; //new field
        public String DSID; //new field
        public String PRIMARY_OEM_NAME; //new field
        public String COMMUNICATION_METHOD; //new field
        public String SCM_DEDUCTIBLE; //new field
        public String REGION_CODE;
        //public String PRIMARY_OEM_CODE;
        public String PSBU_PRODUCT_CERTIFICATION;
        //public String COST_EFFECTIVE_EXCLUSION;
        public String FREEZE_SUBMIT_BUTTON;
        public String DISABLE_WEB_ACCESS_FLAG;
        //public String CAMPAIGN_TRP;
        public String OUTFILE_ALL_CLAIMS;
        //public String PMU_SPLIT_PAYMENT;
        public String TECH_ACTUAL_HOURS_REQUIRED;
        public String GROUP_NAME;
        //public String WARRANTY_FAX;
        //public String WARRANTY_EMAIL;
        public String MAX_CLAIM_AMT;
        //public String CUT_OFF_CLAIM_AMT;
        public String SCM_DEDUCTIBLE_PERCENTAGE;
        
        
        
        
        public List<SP_CERTIFICATION> SP_CERTIFICATION;
        public List<OEM_AFFILIATIONS> OEM_AFFILIATIONS;

    }

    public class SP_CERTIFICATION {
        public String SMN;
        public String OEM_NAME;
        public String OEM_CODE;
        public String START_DATE;
        public String END_DATE;
        public String SERVICE_LEVEL;
        public List<PRODUCT_DETAILS> PRODUCT_DETAILS;
    }

    public class PRODUCT_DETAILS {
        public String PRODUCT_RANGE;
        public String MARKET_APPLICATION;
        public String PRODUCT_TYPE;
    }

    public class OEM_AFFILIATIONS {
        public String AFFILIATIONS;
        public String PRIMARY;
        public String LAST_UPDATED_BY;
        public String LAST_UPDATED_DATE;
        public String SP_NAME; //new field
        public String SP_CODE; //new field
        public String AFFILIATION; //new field
    }

    public static CG_OP_GetSPInfoResJSON parse(String json) {
        return (CG_OP_GetSPInfoResJSON) System.JSON.deserialize(json, CG_OP_GetSPInfoResJSON.class);
    }
}