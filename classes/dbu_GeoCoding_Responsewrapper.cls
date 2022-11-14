public class dbu_GeoCoding_Responsewrapper {

	public class Address_components {
		@AuraEnabled public String long_name;
		@AuraEnabled public String short_name;
		@AuraEnabled public List<String> types;
	}

	public class Geometry {
		@AuraEnabled public Bounds bounds;
		@AuraEnabled public ZipCodeData location;
		@AuraEnabled public String location_type;
		@AuraEnabled public Bounds viewport;
	}

	@AuraEnabled public List<Results> results;
	@AuraEnabled public String status;

	public class Results {
		@AuraEnabled public List<Address_components> address_components;
		@AuraEnabled public String formatted_address;
		@AuraEnabled public Geometry geometry;
		@AuraEnabled public String place_id;
		@AuraEnabled public List<String> types;
	}

	public class Bounds {
		@AuraEnabled public ZipCodeData northeast;
		@AuraEnabled public ZipCodeData southwest;
	}

	public class ZipCodeData {
		@AuraEnabled public Double lat;
		@AuraEnabled public Double lng;
	}

	
	public static dbu_GeoCoding_Responsewrapper parse(String json) {
		return (dbu_GeoCoding_Responsewrapper) System.JSON.deserialize(json, dbu_GeoCoding_Responsewrapper.class);
	}
}