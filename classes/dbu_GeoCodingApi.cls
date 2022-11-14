public without sharing class dbu_GeoCodingApi {
    private static String ENP_POINT_URL;
    private static String METHOD_TYPE;
    private static String Access_Token;
    private static string EndPointFromCustomStng;
    private static String Zip_Code_Label;
    
    
    @AuraEnabled(Cacheable = true)
    public static dbu_GeoCoding_Responsewrapper getLocationFromZipCode(String zipCodeSearch){
        dbu_GeoCoding_Responsewrapper responseWrapper = new dbu_GeoCoding_Responsewrapper();

        try{
            if(zipCodeSearch != null){
                CSS_Integration_Details__c customDataDetails = CSS_Integration_Details__c.getValues('dbu_GeoCoding');
                EndPointFromCustomStng = customDataDetails.End_Point__c;
                Access_Token = customDataDetails.Key__c;
                METHOD_TYPE = customDataDetails.Method_Type__c;
                Zip_Code_Label = Label.dbu_GeoCoding_Zipcode;
                ENP_POINT_URL = EndPointFromCustomStng+''+Access_Token+''+Zip_Code_Label+''+zipCodeSearch;
                system.debug('ENP_POINT_URL' +ENP_POINT_URL);
                
                
                HttpRequest req = new HttpRequest();
                //ENP_POINT_URL = 'https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyB--yU7qdi26kYfozz5bK2-W9wlqUNWiTE&components=postal_code:500010';
                req.setEndpoint(ENP_POINT_URL);
                req.setMethod(METHOD_TYPE);            
                Http http = new Http();
                HttpResponse res = http.send(req);
                responseWrapper = (dbu_GeoCoding_Responsewrapper)JSON.deserialize(res.getbody(), dbu_GeoCoding_Responsewrapper.class); 
                system.debug('res ' + res.getBody());
                
                list<dbu_GeoCoding_Responsewrapper.results> resultval = new list<dbu_GeoCoding_Responsewrapper.results>();
                resultval = responseWrapper.results;
                double zipCodeLat = resultval[0].geometry.location.lat;
                system.debug('xxxxxxx>>>>>' +zipCodeLat);
                double zipCodeLng = resultval[0].geometry.location.lng;
                
            }
        }catch(CallOutException ce){
            system.debug('error in dbu_GeoCodingApi class' + ce.getMessage());
        } 
        return responseWrapper;
        
    }   
    
    
}