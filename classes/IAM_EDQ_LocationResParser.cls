public class IAM_EDQ_LocationResParser {

    public class AddressValidation {
        public String VerificationCode;
        public String VerifiedFlag;
        public String GeoAccuracyCode;
        public String GeoAccuracyCodeDescription;
        public String GeoDistance;
        public String VerificationDescription;
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
        public String CityID;
        public String TerritoryID;
    }

    public class County {
        public String CountyID;
    }

    public class CountryGroup {
        public String CountryGroupID;
        public String SubRegion;
    }

    public AddressCleanse AddressCleanse;

    public class StreetAddress {
        public String AddressLine2txt;
        public String StreetAddressID;
        public String AddressLine1txt;
        public String AddressLine4txt;
        public String AddressLine3txt;
        public String StateProvinceTypeind;
        public String FullAddress;
        public String AddressType;
    }

    public class Locator {
        public String LatitudeMeas;
        public String LongitudeMeas;
    }

    public class ResponseNotifications {
        public String ReturnCodeDescription;
        public String Status;
    }

    public class Country {
        public String CountryName;
        public String CountryID;
        public String CountryNameDescription;
    }

    public class GeographicalArea {
        public String GeographicalAreaSubName;
        public AddressError AddressError;
        public String GeographicalAreaName;
        public PostalCode PostalCode;
        public County County;
        public CountryGroup CountryGroup;
        public Country Country;
        public AddressValidation AddressValidation;
        public StreetAddress StreetAddress;
        public City City;
    }

    public class Location {
        public GeographicalArea GeographicalArea;
        public Locator Locator;
    }

    
    public static IAM_EDQ_LocationResParser parse(String json) {
        return (IAM_EDQ_LocationResParser) System.JSON.deserialize(json, IAM_EDQ_LocationResParser.class);
    }
}