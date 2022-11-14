/*************************************************************************************
Name:  IAM_WWSPS_Location_Parser
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Parsing the JSON from WWSPS API
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Shubhnagi Sardar          12/16/2020        INITIAL DEVELOPMENT 
1.1      Brant Logan               03/20/2021        Made changes for capturing extra attributes.
1.2      Ravi Sakali               06/18/2021        Added new attributes
**************************************************************************************
**************************************************************************************/
public class IAM_WWSPS_Location_Parser {

    public LocationInfo locationInfo;

    public class LocationInfo {
        public String SPcode;
        public String ServiceProviderName;
        public String PhysicalAddress;
        public String City;
        public String State;
        public String Country;
        public String COD;
        public String ISOcode;
        public String ResposibleBranchCode;
        public String AccountSource;
        public String OwnershipName;
        public String Buss_entity_name;
        public String Action;
        public String Phone;
        public String DistributorCode;
        public String DistributorRegion;
        public String ZipCode;
        public String CustomerNumber;
        public String CustomerName;
        //Changes to code: adding 3 new fields. Logan Brandt, 2/3/2021 
        public String DTNA;
        public String serviceLevel;
        public String engineRangeDesc;
        //End of code changes, 2/3/2021
        //Changes to code: adding 2 new fields. Ravi, 06/14/2021
        public String AlternatePartnerId;
        public String ResponsibleRegionCode;
        //End of code changes, 06/14/2021
    }
    
    public static IAM_WWSPS_Location_Parser parse(String json) {
        System.debug('#### JSON - '+ json);
        return (IAM_WWSPS_Location_Parser) System.JSON.deserialize(json, IAM_WWSPS_Location_Parser.class);
    }
}