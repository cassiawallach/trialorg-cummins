@IsTest
public class IAM_EDQ_LocationResParser_Test {
    
    static testMethod void testParse() {
        String json = '{\"AddressCleanse\":{\"ResponseNotifications\":{\"ReturnCodeDescription\":\"\",\"Status\":\"Success\"},\"Location\":[{\"GeographicalArea\":{\"GeographicalAreaSubName\":\"\",\"AddressError\":{\"ErrorDescription\":\"City is Blank ,Country Code is blank \",\"ErrorFlag\":\"Y\"},\"GeographicalAreaName\":\"\",\"PostalCode\":{\"PostalCodeNum\":\"\"},\"County\":{\"CountyID\":\"\"},\"CountryGroup\":{\"CountryGroupID\":\"\",\"SubRegion\":\"\"},\"Country\":{\"CountryName\":\"\",\"CountryID\":\"\"},\"AddressValidation\":{\"VerificationCode\":\"U00-I00-P0-100\",\"VerifiedFlag\":\"X\",\"GeoAccuracyCode\":\"U0\",\"GeoAccuracyCodeDescription\":\"Unable to geocode; 0 - None\",\"GeoDistance\":\"\",\"VerificationDescription\":\"Unverified; 0 - None; Identified and parsed; Primary postal code empty; Score 100\"},\"StreetAddress\":{\"AddressLine2txt\":\"NULL\",\"StreetAddressID\":\"\",\"AddressLine1txt\":\"NULL\",\"AddressLine4txt\":\"US\",\"AddressLine3txt\":\"NULL\",\"StateProvinceTypeind\":\"\",\"FullAddress\":\"NULL|NULL|NULL|US\"},\"City\":{\"CityID\":\"\",\"TerritoryID\":\"\"}},\"Locator\":{\"LatitudeMeas\":\"\",\"LongitudeMeas\":\"\"}}]}}';
        IAM_EDQ_LocationResParser obj = IAM_EDQ_LocationResParser.parse(json);
        System.assert(obj != null);
    }
}