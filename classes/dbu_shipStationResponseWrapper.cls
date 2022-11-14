public class dbu_shipStationResponseWrapper {
    
   		@AuraEnabled public Integer shipmentId;
		@AuraEnabled public String orderId;
		@AuraEnabled public String orderKey;
		@AuraEnabled public String userId;
		@AuraEnabled public String customerEmail;
		@AuraEnabled public String orderNumber;
		@AuraEnabled public String createDate;
		@AuraEnabled public String shipDate;
		@AuraEnabled public Double shipmentCost;
		@AuraEnabled public Double insuranceCost;
		@AuraEnabled public String trackingNumber;
		@AuraEnabled public Boolean isReturnLabel;
		@AuraEnabled public String batchNumber;
		@AuraEnabled public String carrierCode;
		@AuraEnabled public String serviceCode;
		@AuraEnabled public String packageCode;
		@AuraEnabled public String confirmation;
		@AuraEnabled public String warehouseId;
		@AuraEnabled public Boolean voided;
		@AuraEnabled public String voidDate;
		@AuraEnabled public Boolean marketplaceNotified;
		@AuraEnabled public String notifyErrorMessage;
		@AuraEnabled public ShipTo shipTo;
		@AuraEnabled public Weight weight;
		@AuraEnabled public Dimensions dimensions;
		@AuraEnabled public String insuranceOptions;
		@AuraEnabled public String advancedOptions;
		@AuraEnabled public String shipmentItems;
		@AuraEnabled public String labelData;
		@AuraEnabled public String formData;

	public class Dimensions {
		@AuraEnabled public String units;
		@AuraEnabled public Double length;
		@AuraEnabled public Double width;
		@AuraEnabled public Double height;
	}
	public class ShipTo {
		@AuraEnabled public String name;
		@AuraEnabled public String company;
		@AuraEnabled public String street1;
		@AuraEnabled public String street2;
		@AuraEnabled public String street3;
		@AuraEnabled public String city;
		@AuraEnabled public String state;
		@AuraEnabled public String postalCode;
		@AuraEnabled public String country;
		@AuraEnabled public String phone;
		@AuraEnabled public Boolean residential;
		@AuraEnabled public String addressVerified;
	}
	public class Weight {
		@AuraEnabled public Double value;
		@AuraEnabled public String units;
		@AuraEnabled public Integer WeightUnits;
	}
    public static dbu_shipStationResponseWrapper parse(String json) {
        return (dbu_shipStationResponseWrapper) System.JSON.deserialize(json, dbu_shipStationResponseWrapper.class);
    }
}