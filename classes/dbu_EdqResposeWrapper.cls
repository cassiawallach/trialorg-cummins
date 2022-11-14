public class dbu_EdqResposeWrapper {

	public class AddressValidation {
        
		@AuraEnabled public String VerificationDescription;
		@AuraEnabled public String VerificationCode;
		@AuraEnabled public String VerifiedFlag;
		@AuraEnabled public String GeoAccuracyCodeDescription;
		@AuraEnabled public String GeoAccuracyCode;
		@AuraEnabled public String GeoDistance;
	}

	public class AddressCleanse {
		@AuraEnabled public ResponseNotifications ResponseNotifications;
		@AuraEnabled public List<Location> Location;
	}

	public class AddressError {
		@AuraEnabled public String ErrorDescription;
		@AuraEnabled public String ErrorFlag;
	}

	public class PostalCode {
		@AuraEnabled public String PostalCodeNum;
	}

	public class City {
		@AuraEnabled public String TerritoryID;
		@AuraEnabled public String CityID;
	}

	public class County {
		@AuraEnabled public String CountyID;
	}

	@AuraEnabled public Header Header;
	@AuraEnabled public AddressCleanse AddressCleanse;

	public class CountryGroup {
		@AuraEnabled public String CountryGroupID;
		@AuraEnabled public String SubRegion;
	}

	public class Sender {
		@AuraEnabled public String SenderID;
		@AuraEnabled public String MessageID;
	}

	public class Locator {
		@AuraEnabled public String LongitudeMeas;
		@AuraEnabled public String LatitudeMeas;
	}

	public class StreetAddress {
		@AuraEnabled public String FullAddress;
		@AuraEnabled public String AddressLine1txt ;
		@AuraEnabled public String AddressLine4txt;
		@AuraEnabled public String StreetAddressID;
		@AuraEnabled public String AddressLine2txt;
		@AuraEnabled public String AddressLine3txt;
		@AuraEnabled public String StateProvinceTypeind;
		@AuraEnabled public String AddressType;
	}

	public class Header {
		@AuraEnabled public Sender Sender;
	}

	public class ResponseNotifications {
		@AuraEnabled public String Status;
		@AuraEnabled public String ReturnCodeDescription;
	}

	public class Country {
		@AuraEnabled public String CountryID;
		@AuraEnabled public String CountryName;
	}

	public class GeographicalArea {
		@AuraEnabled public String GeographicalAreaName;
		@AuraEnabled public StreetAddress StreetAddress;
		@AuraEnabled public AddressValidation AddressValidation;
		@AuraEnabled public AddressError AddressError;
		@AuraEnabled public String GeographicalAreaSubName;
		@AuraEnabled public Country Country;
		@AuraEnabled public PostalCode PostalCode;
		@AuraEnabled public City City;
		@AuraEnabled public County County;
		@AuraEnabled public CountryGroup CountryGroup;
	}

	public class Location {
		@AuraEnabled public Locator Locator;
		@AuraEnabled public GeographicalArea GeographicalArea;
	}

	
	public static dbu_EdqResposeWrapper parse(String json) {
		return (dbu_EdqResposeWrapper) System.JSON.deserialize(json, dbu_EdqResposeWrapper.class);
	}
}

/*public class dbu_EdqResposeWrapper {

	public class AddressValidation {
        
		 public String VerificationDescription;
		 public String VerificationCode;
		 public String VerifiedFlag;
		 public String GeoAccuracyCodeDescription;
		 public String GeoAccuracyCode;
		 public String GeoDistance;
	}

	public class AddressCleanse {
		 public ResponseNotifications ResponseNotifications;
		 public List<Location> Location;
	}

	public class AddressError {
		 public String ErrorDescription;
		 public String ErrorFlag;
	}

	public class PostalCode {
		 public String PostalCodeNum;
	}

	public class City {
		 public String TerritoryID;
		 public String CityID;
	}

	public class County {
		 public String CountyID;
	}

	 public Header Header;
	 public AddressCleanse AddressCleanse;

	public class CountryGroup {
		 public String CountryGroupID;
		 public String SubRegion;
	}

	public class Sender {
		 public String SenderID;
		 public String MessageID;
	}

	public class Locator {
		 public String LongitudeMeas;
		 public String LatitudeMeas;
	}

	public class StreetAddress {
		 public String FullAddress;
		 public String AddressLine1txt;
		 public String AddressLine4txt;
		 public String StreetAddressID;
		 public String AddressLine2txt;
		 public String AddressLine3txt;
		 public String StateProvinceTypeind;
		 public String AddressType;
	}

	public class Header {
		 public Sender Sender;
	}

	public class ResponseNotifications {
		public String Status;
		 public String ReturnCodeDescription;
	}

	public class Country {
		 public String CountryID;
		 public String CountryName;
	}

	public class GeographicalArea {
		 public String GeographicalAreaName;
		 public StreetAddress StreetAddress;
		 public AddressValidation AddressValidation;
		 public AddressError AddressError;
		public String GeographicalAreaSubName;
		 public Country Country;
		 public PostalCode PostalCode;
		 public City City;
		 public County County;
		 public CountryGroup CountryGroup;
	}

	public class Location {
		 public Locator Locator;
		 public GeographicalArea GeographicalArea;
	}

	
	public static dbu_EdqResposeWrapper parse(String json) {
		return (dbu_EdqResposeWrapper) System.JSON.deserialize(json, dbu_EdqResposeWrapper.class);
	}
}*/