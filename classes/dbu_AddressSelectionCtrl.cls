/**
* Name : dbu_AddressSelectionCtrl
* Description: This class will be used to provide the methods for callouts of Auto Address Completion
* @Date @Date 05/05/2022
*/

public without sharing class dbu_AddressSelectionCtrl {
    public dbu_AddressSelectionCtrl() {

    } 
    //Address Configurations
    public final static String GOOGLEAUTOCOMPLETEURL = 'GoogleAutoCompleteURL';
    public final static String GOOGLEADDRESSDETAILSFROMPLACEIDURL = 'GoogleAddressDetailsFromPlaceIdURL';
    public final static String GOOGLEADDRESSDETAILSFROMPLACEIDURLOLDAPI = 'GoogleAddressDetailsFromPlaceIdUrlOldAPI';
    public final static String GOOGLEAPIKEY = 'GoogleAPIKey';
    public final static String GOOGLEADDRESSFROMLATLANG = 'GoogleAddressFromLatLang';
    
    public final static String RESULT = 'result';
    public final static String ADDRESSCOMPONENTS = 'address_components';
    public final static String TYPES = 'types';
    public final static String ROUTE = 'route';
    public final static String LONGNAME = 'long_name';
    public final static String LOCALITY = 'locality';
    public final static String CITY = 'city';
    public final static String ADMINISTRATIVEAREALEVEL1 = 'administrative_area_level_1';
    public final static String ADMINISTRATIVEAREALEVEL2 = 'administrative_area_level_2';
    public final static String COUNTY = 'county';
    public final static String COUNTRY = 'country';
    public final static String POSTALCODE = 'postal_code';
    public final static String STATE = 'state';
    public final static String STREET = 'street';
    public final static String UTF8 = 'UTF-8';
    public final static String GETREQUEST = 'GET';
    public final static String NONE = 'None';
    public static Map<String,String> mapAddressConfigurations = getAddressConfigurations();
    public static String strAutoCompleteUrl = mapAddressConfigurations.get(GOOGLEAUTOCOMPLETEURL);
    public static String strAddressDetailsFromPlaceIdUrl = mapAddressConfigurations.get(GOOGLEADDRESSDETAILSFROMPLACEIDURL);
    public static String strAddressDetailsFromPlaceIdUrlOldAPI = mapAddressConfigurations.get(GOOGLEADDRESSDETAILSFROMPLACEIDURLOLDAPI);
    public static String strGoogleAPIKey = mapAddressConfigurations.get(GOOGLEAPIKEY);

    @AuraEnabled(cacheable=false)
    public static List<Account> findRecords(String searchKey, String objectName, String searchField){
        String sQuery = 'SELECT Id, Name FROM '+ objectName + ' WHERE '+searchField+' like \'%'+ searchKey +'%\' LIMIT 5';
        System.debug('### sQuery ###'+sQuery);
        return Database.query(sQuery);
    }

    /*
    * Name : getAddressDetailsFromPlaceId 
    * Description: This method will be used to get address (street,city,country,zipcode,geolocation) 
    *               using the Place Id generated during address Selection
    * @Date 05/05/2022
    */
    
    @AuraEnabled(cacheable=true)
    public static String getAddressDetailsFromPlaceId(String placeId, String selectedAddress){
        try{
            String strPlaceIdUrl = strAddressDetailsFromPlaceIdUrl+'?placeid='
                    + String.escapeSingleQuotes(placeId) 
                    + '&key='+strGoogleAPIKey;
            String strAddressResults = sendHTTPRequest(strPlaceIdUrl);
            Map<String, Object> mapAddressResults = (Map<String, Object>)JSON.deserializeUntyped(strAddressResults);
            if(mapAddressResults.get(RESULT)!= null && mapAddressResults.get(RESULT)!= ''){
                Map<String, Object> mapAddressComponents = (Map<String, Object>)mapAddressResults.get(RESULT);
                List<Object> lstAddressComponents = (List<Object>)mapAddressComponents.get(ADDRESSCOMPONENTS);
                Map<String,String> mapAddressValues = new Map<String,String>();
                if(lstAddressComponents.size() > 0){                   
                    return getAddressValuesMap(lstAddressComponents, strAddressResults, selectedAddress);
                }else{
                    return getAddressDetailsFromPlaceIdOldAPI(String.escapeSingleQuotes(selectedAddress));
                }
            }else{
                return null;
            }
        }catch(System.Exception e) {
            System.debug('### Exception Occurred in DLWC_AddressAutoSelectionCtrl.getAddressDetailsFromPlaceId ###'+e.getMessage());
            return null;
        }
    }

    /*
    * Name : getAddressDetailsFromPlaceIdOldAPI
    * Description: This method will be used to get address (street,city,country,zipcode,geolocation) 
    *               using the address generated during address Selection
    * @date 05/05/2022
    */
    
    @AuraEnabled(cacheable=true)
    public static String getAddressDetailsFromPlaceIdOldAPI(String selectedAddress){
        String strResponse = '';
        try{
            String strAddUrl = strAddressDetailsFromPlaceIdUrlOldAPI+'?address='
                    + EncodingUtil.urlEncode(String.escapeSingleQuotes(selectedAddress), UTF8)
                    + '&key='+strGoogleAPIKey;
            strResponse = sendHTTPRequest(strAddUrl);
            return strResponse;
        }catch(System.Exception e) {
            System.debug('### Exception Occurred in DLWC_AddressAutoSelectionCtrl.getAddressDetailsFromPlaceIdOldAPI ###'+e.getMessage());
            return strResponse;
        }
    }

    /*
    * Name : getAddressAutoComplete 
    * Description: This method will be used to get Search Results for auto Address text entered by user using GoogleMaps API
    * @Date 05/05/2022
    */
    @AuraEnabled(cacheable=false)
    public static String getAddressAutoComplete(String input, String countryCode) {
        String strResponse = '';
        System.debug('### input ###'+input);
        try{
            String strAutoComplete = strAutoCompleteUrl+'?input='
                + EncodingUtil.urlEncode(String.escapeSingleQuotes(input), UTF8)
                + '&key='+strGoogleAPIKey;
            if(countryCode != NONE){
                strAutoComplete = strAutoComplete + '&components='+string.escapeSingleQuotes(countryCode);
            }
            System.debug('### strAutoComplete ###'+strAutoComplete);
           strResponse = sendHTTPRequest(strAutoComplete);
            return strResponse;
            //return strAutoComplete;
        }catch(System.Exception e) {
            System.debug('### Exception Occurred in DLWC_AddressAutoSelectionCtrl.getAddressAutoComplete ###'+e.getMessage());
            return strResponse;
        }
    }
    
    /*
    * Name : getAddressConfigurations 
    * Description: This method will be used to get address related Configurations
    * @Date 05/05/2022
    */
    public static Map<String,String> getAddressConfigurations(){
        Map<String,String> mapAddressConfigurations = new Map<String,String>();
        try{
            String strGoogleAddressDetailsFromPlaceIdURL,strGoogleAPIKey,strGoogleAddressDetailsFromPlaceIdUrlOldAPI,strGoogleAutoCompleteURL;
            CSS_Integration_Details__c customDataDetails = CSS_Integration_Details__c.getValues('dbu_google_places');
            strGoogleAddressDetailsFromPlaceIdURL = !String.isBlank(customDataDetails.End_Point__c) ? customDataDetails.End_Point__c : 'https://maps.googleapis.com/maps/api/place/details/json' ;
            strGoogleAPIKey = !String.isBlank(customDataDetails.Key__c) ? customDataDetails.Key__c : 'AIzaSyB--yU7qdi26kYfozz5bK2-W9wlqUNWiTE' ;
            strGoogleAddressDetailsFromPlaceIdUrlOldAPI = !String.isBlank(customDataDetails.Logging__c) ? customDataDetails.Logging__c : 'https://maps.googleapis.com/maps/api/geocode/json' ;
            strGoogleAutoCompleteURL = !String.isBlank(customDataDetails.Resource__c) ? customDataDetails.Resource__c : 'https://maps.googleapis.com/maps/api/place/autocomplete/json' ;
                mapAddressConfigurations.put('GoogleAddressDetailsFromPlaceIdURL', strGoogleAddressDetailsFromPlaceIdURL);
                mapAddressConfigurations.put('GoogleAddressDetailsFromPlaceIdUrlOldAPI', strGoogleAddressDetailsFromPlaceIdUrlOldAPI);
                mapAddressConfigurations.put('GoogleAPIKey', strGoogleAPIKey);
                mapAddressConfigurations.put('GoogleAutoCompleteURL', strGoogleAutoCompleteURL);
          system.debug('mapAddressConfigurations'+mapAddressConfigurations);
            return mapAddressConfigurations;
        }catch(System.Exception e) {
            System.debug('### Exception Occurred in DLWC_AddressSelectionCtrl.getAddressConfigurations ###'+e.getMessage());
            return mapAddressConfigurations;
        }
    }
 
    /*
    * Name : sendHTTPRequest 
    * Description: This method will be used to provide the methods for callouts of Auto Address Completion
    * @Date 05/05/2022
    */
    public static String sendHTTPRequest(String url){
        HttpResponse response;
        HttpRequest req = new HttpRequest();

        req.setEndpoint(string.escapeSingleQuotes(url));
        req.setMethod(GETREQUEST);

        try {
            Http http = new Http();
            if(!Test.isRunningTest()){
                response = http.send(req);
            }else{
                response = new HttpResponse();
                response.setBody('{ "results" : [{ "geometry" : { "location" : {"lat" : 37.7787937,"lng" : -122.4216864} } }], "result" :  { "address_components" : [ { "long_name" : "404", "short_name" : "404", "types" : [ "street_number" ] }, { "long_name" : "Frankfort Avenue", "short_name" : "Frankfort Ave", "types" : [ "route" ] }, { "long_name" : "Butchertown", "short_name" : "Butchertown", "types" : [ "neighborhood", "political" ] }, { "long_name" : "Louisville", "short_name" : "Louisville", "types" : [ "locality", "political" ] }, { "long_name" : "Jefferson County", "short_name" : "Jefferson County", "types" : [ "administrative_area_level_2", "political" ] }, { "long_name" : "Kentucky", "short_name" : "KY", "types" : [ "administrative_area_level_1", "political" ] }, { "long_name" : "United States", "short_name" : "US", "types" : [ "country", "political" ] }, { "long_name" : "40206", "short_name" : "40206", "types" : [ "postal_code" ] } ], "formatted_address" : "404 Frankfort Ave, Louisville, KY 40206, USA", "geometry" : { "location" : { "lat" : 38.2644825, "lng" : -85.72534570000001 }, "location_type" : "RANGE_INTERPOLATED", "viewport" : { "northeast" : { "lat" : 38.2658314802915, "lng" : -85.72399671970851 }, "southwest" : { "lat" : 38.2631335197085, "lng" : -85.72669468029152 } } }, "partial_match" : true, "place_id" : "", "types" : [ "street_address" ] } , "status" : "OK" }');
            }
        }catch(System.Exception e) {
            System.debug('### Exception Occurred in DLWC_AddressAutoSelectionCtrl.sendHTTPRequest ###'+e.getMessage());
            return e.getMessage();
        }
        return response.getBody();
    }

    /*
    * Name : getAddressValuesMap 
    * Description: This method to get Address details in a Map
    * @Date 05/05/2022
    */
    public static String getAddressValuesMap(List<Object> lstAddComponents, String strAddResults, String strSelectedAddress){
        Map<String,String> mapAddValues = new Map<String,String>();
        for(Object adObj:lstAddComponents){
            Map<String,object> mapAdCompRecords = (Map<String, Object>)adObj;
            List<Object> lstTypes = (List<Object>)mapAdCompRecords.get(TYPES);
            if(lstTypes.contains(ROUTE)){
                mapAddValues.put(STREET,String.valueOf(mapAdCompRecords.get(LONGNAME)));
            }else if(lstTypes.contains(LOCALITY)){
                mapAddValues.put(CITY, String.valueOf(mapAdCompRecords.get(LONGNAME)));
            }else if(lstTypes.contains(ADMINISTRATIVEAREALEVEL1)){
                mapAddValues.put(STATE, String.valueOf(mapAdCompRecords.get(LONGNAME)));
            }else if(lstTypes.contains(ADMINISTRATIVEAREALEVEL2)){
                mapAddValues.put(COUNTY, String.valueOf(mapAdCompRecords.get(LONGNAME)));
            }else if(lstTypes.contains(COUNTRY)){
                mapAddValues.put(COUNTRY,String.valueOf(mapAdCompRecords.get(LONGNAME))); 
            }else if(lstTypes.contains(POSTALCODE)){
                mapAddValues.put(POSTALCODE, String.valueOf(mapAdCompRecords.get(LONGNAME)));
            }
        }
        if(mapAddValues.get(STREET)!= null 
            && mapAddValues.get(CITY)!= null
            && mapAddValues.get(STATE)!= null
            && mapAddValues.get(COUNTY)!= null
            && mapAddValues.get(COUNTRY)!= null
            && mapAddValues.get(POSTALCODE)!= null){
            return strAddResults;
        }else{
            return getAddressDetailsFromPlaceIdOldAPI(String.escapeSingleQuotes(strSelectedAddress));
        }
    }
}