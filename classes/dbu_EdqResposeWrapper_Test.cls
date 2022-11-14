@isTest
public class dbu_EdqResposeWrapper_Test {

    @isTest
    public static void testEDQResponse(){
        
        // AddressValidation object
        dbu_EdqResposeWrapper.AddressValidation addressValidation = new dbu_EdqResposeWrapper.AddressValidation();
        addressValidation.VerificationDescription = 'Verified; 4 - Premise; Identified and parsed; Primary postal code verified, secondary added or changed; Score 80';
        addressValidation.VerificationCode = 'V44-I44-P7-080';
        addressValidation.VerifiedFlag = 'X';
        addressValidation.GeoAccuracyCodeDescription = 'Unable to geocode; 0 - None';
        addressValidation.GeoAccuracyCode = 'U0';
        addressValidation.GeoDistance = '';
        
        
        // ResponseNotifications object
        dbu_EdqResposeWrapper.ResponseNotifications responseNotifications = new  dbu_EdqResposeWrapper.ResponseNotifications();
        responseNotifications.Status = 'Success';
        responseNotifications.ReturnCodeDescription = '';
        
        // Locator object
        dbu_EdqResposeWrapper.Locator locator = new  dbu_EdqResposeWrapper.Locator();
        locator.LongitudeMeas = '';
        locator.LatitudeMeas = '';
        
        // StreetAddress object
        dbu_EdqResposeWrapper.StreetAddress streetAddress = new dbu_EdqResposeWrapper.StreetAddress();
        streetAddress.FullAddress = '400 BROWN ST|COLUMBUS IN 47201-6707';
        streetAddress.AddressLine1txt = '400 BROWN ST';
        streetAddress.AddressLine4txt = '';
        streetAddress.StreetAddressID = '';
        streetAddress.AddressLine2txt = '';
        streetAddress.AddressLine3txt = '';
        streetAddress.StateProvinceTypeind = '';
        //streetAddress.AddressType = '';
        
        // AddressError Object
        dbu_EdqResposeWrapper.AddressError addressError = new dbu_EdqResposeWrapper.AddressError();
        addressError.ErrorDescription = '';
        addressError.ErrorFlag = 'N';
        
        // Country Object
        dbu_EdqResposeWrapper.Country country = new dbu_EdqResposeWrapper.Country();
        country.CountryID = 'UNITED STATES';
        country.CountryName = 'UNITED STATES';
        
        // PostalCode Object
        dbu_EdqResposeWrapper.PostalCode postalCode = new dbu_EdqResposeWrapper.PostalCode();
        postalCode.PostalCodeNum = '47201';
        
        // County Object
        dbu_EdqResposeWrapper.County  county = new   dbu_EdqResposeWrapper.County();
        county.CountyID = '';
        
        // City Object
        dbu_EdqResposeWrapper.City city = new dbu_EdqResposeWrapper.City();
        city.TerritoryID = 'IN'; 
        city.CityID = 'SCOTTSDALE';
        
        // CountryGroup Object
        dbu_EdqResposeWrapper.CountryGroup countryGroup = new dbu_EdqResposeWrapper.CountryGroup();
        countryGroup.CountryGroupID = 'EUROPE';
        countryGroup.SubRegion = '';
        
        // GeographicalArea Object
        dbu_EdqResposeWrapper.GeographicalArea geographicalArea = new dbu_EdqResposeWrapper.GeographicalArea();
        geographicalArea.GeographicalAreaName = '';
        geographicalArea.StreetAddress = streetAddress;
        geographicalArea.AddressValidation = addressValidation;
        geographicalArea.AddressError = addressError;
        geographicalArea.GeographicalAreaSubName = '';
        geographicalArea.Country = country;
        geographicalArea.PostalCode = postalCode;
        geographicalArea.City = city;
        geographicalArea.County = county;
        geographicalArea.CountryGroup = countryGroup;
        
        // Location Object
        dbu_EdqResposeWrapper.Location location = new dbu_EdqResposeWrapper.Location();
        location.Locator = locator;
        location.GeographicalArea = geographicalArea;
        
        List<dbu_EdqResposeWrapper.Location> lstLocation = new List<dbu_EdqResposeWrapper.Location>();
        lstLocation.add(location);
        
        // AddressCleanse Object
        dbu_EdqResposeWrapper.AddressCleanse addressCleanse = new dbu_EdqResposeWrapper.AddressCleanse();
        addressCleanse.ResponseNotifications = responseNotifications;
        addressCleanse.Location = lstLocation;
        
        
        dbu_EdqResposeWrapper.Sender sender = new dbu_EdqResposeWrapper.Sender();
        sender.SenderID = '';
        sender.MessageID = '';
        
        dbu_EdqResposeWrapper.Header  header = new dbu_EdqResposeWrapper.Header();
        header.Sender = sender;
        //creating response object
        dbu_EdqResposeWrapper edqResposeWrapper = new dbu_EdqResposeWrapper();
        edqResposeWrapper.Header = header;
        edqResposeWrapper.AddressCleanse = addressCleanse;
        string json = JSON.serialize(edqResposeWrapper);
        
        Test.startTest();
        dbu_EdqResposeWrapper.parse(json);
        Test.stopTest();
    }
}