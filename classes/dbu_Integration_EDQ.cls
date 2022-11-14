public with sharing class dbu_Integration_EDQ {
    private  static String ENP_POINT_URL;
    private static String METHOD_TYPE;
    private static String Content_Type;
    private static String RESOURCE;
    private static String CONSUMER_KEY;
    private static String CONSUMER_SECRET;
    private final static String REQUEST_BODY = 'grant_type=client_credentials&client_id={0}&client_secret={1}&resource={2}';
    
    
    private static String getAccessToken(){
        try{
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_EDQ_AccessToken');
            ENP_POINT_URL = conDetails.End_Point__c;
            CONSUMER_KEY = conDetails.Key__c;
            CONSUMER_SECRET = conDetails.Passcode__c;
            METHOD_TYPE = conDetails.Method_Type__c;
            CONTENT_TYPE = conDetails.grant_type__c;
            RESOURCE = conDetails.Resource__c;
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod(METHOD_TYPE);
            req.setBody(String.format(REQUEST_BODY ,new string[]{CONSUMER_KEY,CONSUMER_SECRET,
                RESOURCE}));
           
            Http http = new Http();
            HttpResponse res = http.send(req);
            system.debug('res ' + res.getBody());
            TokenResponse resp = (TokenResponse)JSON.deserialize(res.getbody(), TokenResponse.class);
            system.debug('name and acce token '+ resp.token_type +' '+ resp.access_token);
            return resp.access_token;
        }catch(CallOutException ce){
            throw ce;
        }       
    }   
    
    
    @AuraEnabled
    public static dbu_EdqResposeWrapper getAddressVerify(String addressLine1, String addressLine2,String cityId, String stateID, String countryId ,String psCode ){
        string mSec;
        try
        {
            //string data =  addressLine1 + addressLine2 + cityId + stateID + countryId + psCode;
            Sender sender = new Sender();
           // sender.ServiceName = 'AddressCleanse';
            //sender.SenderID = 'IAM';
            //sender.MessageID = '0016C00000AUbWtQAL';
            sender.ServiceName = '';
            sender.SenderID = '';
            sender.MessageID = '';
            
            Header header  =  new Header();
            header.Sender = sender;
            
            StreetAddress streetAddress = new StreetAddress();
            streetAddress.StreetAddressID = '';
            streetAddress.StateProvinceTypeind = '';
            streetAddress.AddressLine4txt = '';
            streetAddress.AddressLine3txt = '';
            streetAddress.AddressLine2txt = addressLine2;
            streetAddress.AddressLine1txt = addressLine1;
            
            Province province = new Province();
            province.ProvinceID = '';
            
            PostalCode postalCode = new PostalCode();
            postalCode.PostalCodeNum = psCode;
            
            GeographicalAreaSubtype geographicalAreaSubtype = new GeographicalAreaSubtype();
            geographicalAreaSubtype.DoubleDependantLocality = '';
            geographicalAreaSubtype.DependantLocality = '';
            
            County county = new County();
            county.CountyID = '';
            
            Country country = new Country();
            country.CountryID = countryId;
            
            City city = new City();
            city.CityID = cityId;
            
            AddressValidation addressValidation = new AddressValidation();
            addressValidation.MinimumVerificationMatchScore = '';
            addressValidation.MinimumVerificationLevel = '';
            addressValidation.AllowedVerificationResultCodes = '';
            
            GeographicalArea geographicalArea = new GeographicalArea();
            geographicalArea.StreetAddress = streetAddress;
            geographicalArea.StateId = stateID;
            geographicalArea.Province =  province;
            geographicalArea.PostalCode = postalCode;
            geographicalArea.GeographicalAreaSubtype = geographicalAreaSubtype;
            geographicalArea.County = County;
            geographicalArea.Country = country;
            geographicalArea.City = city;
            geographicalArea.AddressValidation = addressValidation;
            
            Location location = new Location();
            location.GeographicalArea = geographicalArea;
            
            AddressCleanse addressCleanse = new AddressCleanse();
            addressCleanse.Location = location;
            
            dbu_EdqRequestWrapper dbu_edqRequestWrapper = new dbu_EdqRequestWrapper();
            dbu_edqRequestWrapper.Header = header;
            dbu_edqRequestWrapper.AddressCleanse = addressCleanse; 
            
            dbu_EdqResposeWrapper resp = new  dbu_EdqResposeWrapper();
            String AccessToken = getAccessToken();
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('dbu_EDQ');
            ENP_POINT_URL = conDetails.End_Point__c;
            METHOD_TYPE = conDetails.Method_Type__c;
            Content_Type = conDetails.grant_type__c;
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type', Content_Type);
            req.setHeader('Authorization','Bearer ' + AccessToken);
            //req.setHeader('Authorization','eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IllNRUxIVDBndmIwbXhvU0RvWWZvbWpxZmpZVSIsImtpZCI6IllNRUxIVDBndmIwbXhvU0RvWWZvbWpxZmpZVSJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1kZXZuZi1hdy1leC5jdW1taW5zLmNvbS9kYnMtYXBpIiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvYjMxYTVkODYtNmRkYS00NDU3LTg1ZTUtYzU1YmJjMDc5MjNkLyIsImlhdCI6MTU4NDY1MjE4NCwibmJmIjoxNTg0NjUyMTg0LCJleHAiOjE1ODQ2NTYwODQsImFpbyI6IjQyTmdZUGpCUDYzcnp5ZHpOdlpOWHErZis2d3NCUUE9IiwiYXBwaWQiOiJmOTY1ODUyNi1lZTU5LTRlZWEtYTA2Mi0zZTNlZGE1M2QyYWIiLCJhcHBpZGFjciI6IjEiLCJpZHAiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9iMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QvIiwib2lkIjoiZTcxMDgzODAtZjY3NS00ODE0LWI2MmItZGVjMDA2N2M1YmE2Iiwic3ViIjoiZTcxMDgzODAtZjY3NS00ODE0LWI2MmItZGVjMDA2N2M1YmE2IiwidGlkIjoiYjMxYTVkODYtNmRkYS00NDU3LTg1ZTUtYzU1YmJjMDc5MjNkIiwidXRpIjoiU1N2d19YSHlERVdubXJPTUkyWV9BQSIsInZlciI6IjEuMCJ9.LdCokr9mIUQ3aXdzO4QOmQHagIVkK3MaoPRSsRvr7E0ZHugHsXIxBTNM6wkIWX1Igx0-gIAqcgdtMr-NY7wk5DEKZg-FnxGWPp3D-EthU86AqrBXwqIyjC162QlU-v2SGWDAOzxvVUE2ERYZI0uUTd4s5kCL2f7AY2dWyJB1kYk-HvSkaphTwh11Vnef8F2h66dPG-p-Y9aN3HnAkzKPdReCMenuoeDPbwEGVPOhJ-Ay1J7gk9zZHRwj9JxZdyvF-G2uOAApS--CMPRkd-PZve7oq6NwDTSq6d7dNstRuDTckFvoejE8bqe5GJgkZgn7Dk8GNuQqsPqJv_pOjWIxnA');
            req.setMethod(METHOD_TYPE);
            req.setTimeout(120000);
            req.setEndpoint(ENP_POINT_URL);
            
            req.setBody(JSON.serialize(dbu_edqRequestWrapper));
            Http http = new Http();
            Long reqTime = DateTime.now().getTime();
            HTTPResponse res = http.send(req);
            Long respTime = DateTime.now().getTime();
            long milliSeconds = respTime-reqTime ;
            mSec='***TIME::' +string.ValueOf(milliSeconds)+ ':: TIME***';
                if(res.getStatusCode() == 200)
                {
                    system.debug('res.getBody() ' + res.getBody());
                    resp = (dbu_EdqResposeWrapper)JSON.deserialize(res.getbody(), dbu_EdqResposeWrapper.class); 
                    dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec,JSON.serialize(dbu_edqRequestWrapper),res.getBody(),'EDQ Service','Success');
                    return resp;
                }
                else
                {
                    dbu_Integration_Error_Log.createErrorLog(res.getStatusCode(),mSec+res.getBody(),JSON.serialize(dbu_edqRequestWrapper),'','EDQ Service',res.getStatus());
                }
                return resp;
            
            }
            catch(CallOutException ce)
            {
                dbu_Integration_Error_Log.createErrorLog(null,mSec+ce.getMessage(),'','','EDQ Service','Exception');
                throw ce;
            }    
    }
    public class TokenResponse {       
        public String token_type;        
        public String expires_in;        
        public String ext_expires_in;   
        public String expires_on;
        public String not_before;
        public String resource;
        public String access_token;
    }   
        
    public class dbu_EdqRequestWrapper {
        public Header Header;
        public AddressCleanse AddressCleanse;
    }
    public class AddressValidation {
        public String MinimumVerificationMatchScore;
        public String MinimumVerificationLevel;
        public String AllowedVerificationResultCodes;
    }
    public class AddressCleanse {
        public Location Location;
    }
    public class PostalCode {
        public String PostalCodeNum;
    }
    public class City {
        public String CityID;
    }
    public class GeographicalAreaSubtype {
        public String DoubleDependantLocality;
        public String DependantLocality;
    }
    public class County {
        public String CountyID;
    }
    public class Province {
        public String ProvinceID;
    }
    public class Sender {
        public String ServiceName;
        public String SenderID;
        public String MessageID;
    }
    public class StreetAddress {
        public String StreetAddressID;
        public String StateProvinceTypeind;
        public String AddressLine4txt;
        public String AddressLine3txt;
        public String AddressLine2txt;
        public String AddressLine1txt;
    }
    public class Header {
        public Sender Sender;
    }
    public class Country {
        public String CountryID;
    }
    public class GeographicalArea {
        public StreetAddress StreetAddress;
        public String StateId;
        public Province Province;
        public PostalCode PostalCode;
        public GeographicalAreaSubtype GeographicalAreaSubtype;
        public County County;
        public Country Country;
        public City City;
        public AddressValidation AddressValidation;
    }
    public class Location {
        public GeographicalArea GeographicalArea;
    }
}