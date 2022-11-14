/**********************************************************************
Name: dbu_Integration_Parts_Request
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:    REST API Service to import bulk data from Parts.Cummins.Com 
                                                          
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE(dd/mm/yyyy)                DETAIL                                 
1.0    Rajnish Kumar         11/08/2020                 INITIAL DEVELOPMENT                    

***********************************************************************/
global with sharing class dbu_Integration_Parts_Request {

        public dbu_Integration_Parts_Request(){}
        
        public Double Price;
        public String PricingTiers;
        //public String PriceList;//Mandatory Will be determined based on location
        
        public Boolean COOLERPAKFLAG;
        public Boolean DRYICEFLAG;
        public Boolean SERVICEFLAG;
        public Boolean HAZARDOUSFLAG;
        public Boolean SHIPSEPARATELY;
        public Boolean SHIPPEDINDIVIDUALLY;
        public Boolean GroundFlag;
        public Boolean HazardousOutside48Flag;
        public Boolean OvernightFlag;
        public Boolean ReviewFlag;
        public Boolean TAXABLE;
        public Boolean ISIAMPROVISIONINGREQUIRED;
        public Boolean AvailableToPickUpFlag;
        public Boolean AvailableToShipFlag;
        public Boolean NonReturnableFlag;
        public Boolean IsCoreItem;
        public Double LeadTime;
        public Double DRYICEWEIGHT;
        public Double SEQUENCE;
        public Double PRODUCTWEIGHT;
        public Double SHIPPINGWEIGHT;
        public Double Quantityperunit;
        public String EndDate;//Default to 12/31/2099
        public String StartDate;
        public String LONGDESCRT;
        public String LONGDESC;
        public String PRODUCTTYPE;//picklist
        public String SKU;
        public String MARKET_SEGMENT;//picklist
        public String NAME;
        public String PRODUCT_VERSION;
        public String STAND_ALONE_PRODUCT;//picklist
        public String ALTERNATENAME;
        public String SHORTDESCRT;
        public String SHORTDESC;
        public String TAXRATEID;//128 char limit
        public String UNITOFMEASURE;//picklist
        public String ProductStatus;//picklist
        public String AvailabilityMessageRT;
        public String ProductCode;
        public String ProductComment;
        public String AdditionalInformation;
        public String SpecValueUOM;
        public String SpecValueCapacity;
        public String SpecValueDimensionLength;
        public String SpecValueDimensionHeight;
        public String SpecValueDimensionWidth;
        public String SpecValueDimensionWeight;
        public String ShipmentDimensionLength;
        public String ShipmentDimensionHeight;
        public String ShipmentDimensionWidth;
        public String ShipmentDimensionWeight;
        public String BMSInstance;
        public String DistributorCode;
        public String FullPartNumber;
        
        public List<dbu_Integration_Parts_ProductImages> Images;
        public List<dbu_Integration_Parts_Specs> Specs;
        public List<String> SupersedeProduct;
        public List<String> ReconEquivalentPartNumber;
        public List<String> ProductGrouping;

        //String Control__Module;//?
        //String Document__Type;//?
        //String Language;//?
        //String Product__Model;//?
        //String Engine__Series;//?
}