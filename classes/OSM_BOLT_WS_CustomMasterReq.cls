/*****************************************************************
Name:  OSM_BOLT_WS_CustomMasterReq
Copyright © 2018  Cummins
==================================================================
==================================================================
Purpose:                                                            
This is JSON to Apex wrapper class for input request that will be 
exposed to Rest webservice  class OSM_BOLT_WS_CustomMasterInbound                         
==================================================================
==================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S            05/04/2018     INITIAL DEVELOPMENT          

******************************************************************/

public class OSM_BOLT_WS_CustomMasterReq {

    public class Sender {
        public String ServiceName;
        public String SenderID;
    }

    public class ACCT_SITES_O_STG_ROW {
        public String ADDRESS_ACTION_TYPE;
        public String COUNTRY;
        public String ADDRESS1;
        public String ADDRESS2;
        public String ADDRESS3;
        public String ADDRESS4;
        public String ADDRESS_LINES_PHONETIC;
        public String CITY;
        public String STATE;
        public String POSTAL_CODE;
        public String PROVINCE;
        public String COUNTY;
        public String LOCATION_ATTRIBUTE1;
        public String LOCATION_ATTRIBUTE2;
        public String LOCATION_ATTRIBUTE3;
        public String LOCATION_ATTRIBUTE4;
        public String LOCATION_ATTRIBUTE5;
        public String LOCATION_ATTRIBUTE6;
        public String LOCATION_ATTRIBUTE7;
        public String LOCATION_ATTRIBUTE8;
        public String LOCATION_ATTRIBUTE9;
        public String LOCATION_ATTRIBUTE10;
        public String PARTY_SITE_REFERENCE;
        public String PARTY_SITE_STATUS;
        public String PARTY_SITE_NUMBER;
        public String BC_CODE;
        public String ENTITY_CODE;
        public String BOLT_OPERATING_UNIT;
        public String IDENTIFYING_ADDRESS_FLAG;
        public String ACCOUNT_SITE_ACTION_TYPE;
        public String ACC_SITE_REFERENCE;
        public String ACC_SITE_STATUS;
        public String SITE_USE_CODE;
        public String LOCATION;
        public String PRIMARY_FLAG;
        public String SITE_USE_STATUS;
        public String RECEIVABLE_ACCOUNT;
        public String SITE_USE_ATTRIBUTE1;
        public String SITE_USE_ATTRIBUTE2;
        public String SITE_USE_ATTRIBUTE3;
        public String SITE_USE_ATTRIBUTE4;
        public String SITE_USE_ATTRIBUTE5;
        public String SITE_USE_ATTRIBUTE6;
        public String SITE_USE_ATTRIBUTE7;
        public String SITE_USE_ATTRIBUTE8;
        public String SITE_USE_ATTRIBUTE9;
        public String SITE_USE_ATTRIBUTE10;
        public String GLOBAL_ATTRIBUTE_CATEGORY;
        public String GLOBAL_ATTRIBUTE1;
        public String GLOBAL_ATTRIBUTE2;
        public String GLOBAL_ATTRIBUTE3;
        public String GLOBAL_ATTRIBUTE4;
        public String GLOBAL_ATTRIBUTE5;
        public String GLOBAL_ATTRIBUTE6;
        public String GLOBAL_ATTRIBUTE7;
        public String GLOBAL_ATTRIBUTE8;
        public String GLOBAL_ATTRIBUTE9;
    }

    public class Target {
        public String TargetID;
    }

    public class CUST_ACCTS_O_STG_ROW {
        public String CUSTOMER_ACTION_TYPE;
        public String ACCOUNT_NUMBER;
        public String ALTERNATE_NAME;
        public String TAXPAYER_ID;
        public String ATTR_CONTEXT;
        public String ATTRIBUTE1;
        public String ATTRIBUTE2;
        public String ATTRIBUTE3;
        public String ATTRIBUTE4;
        public String ATTRIBUTE5;
        public String ATTRIBUTE6;
        public String ATTRIBUTE7;
        public String ATTRIBUTE9;
        public String ATTRIBUTE10;
        public String ATTRIBUTE11;
        public String STATUS;
        public String CUSTOMER_TYPE;
        public String CUSTOMER_CLASS_CODE;
        public String ACCOUNT_REFERENCE;
        public String PROFILE_CLASS;
        public String CREDIT_HOLD;
        public ACCT_SITES_O_STG ACCT_SITES_O_STG;
    }

    public class DataArea {
        public CUST_O_STG_ROW CUST_O_STG_ROW;
    }

    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public class CUST_O_STG_ROW {
        public String PARTY_TYPE;
        public String STATUS;
        public String PARTY_NUMBER;
        public String PARTY_NAME;
        public String ORIG_SYSTEM_REFERENCE;
        public String ATTR_CONTEXT;
        public String ATTRIBUTE1;
        public String ATTRIBUTE2;
        public String ATTRIBUTE3;
        public String ATTRIBUTE4;
        public String ATTRIBUTE5;
        public String ATTRIBUTE6;
        public String ATTRIBUTE7;
        public String ATTRIBUTE8;
        public String ATTRIBUTE9;
        public String ATTRIBUTE10;
        public CUST_ACCTS_O_STG CUST_ACCTS_O_STG;
    }

    public class ACCT_SITES_O_STG {
        public List<ACCT_SITES_O_STG_ROW> ACCT_SITES_O_STG_ROW;
    }

    public Header Header;
    public DataArea DataArea;

    public class CUST_ACCTS_O_STG {
        public CUST_ACCTS_O_STG_ROW CUST_ACCTS_O_STG_ROW;
    }

    
    public static OSM_BOLT_WS_CustomMasterReq parse(String json) {
        return (OSM_BOLT_WS_CustomMasterReq) System.JSON.deserialize(json, OSM_BOLT_WS_CustomMasterReq.class);
    }
}