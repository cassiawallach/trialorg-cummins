public without sharing class dbu_GoogleMapApi {
    
    private static String ENP_POINT_URL;
    private static String METHOD_TYPE;
    private static String Access_Token;
    private static string EndPointFromCustomLabel;
    
    
    @AuraEnabled
    public static String getPostalCode(Decimal lat, Decimal lng){
        String postalCode;
        String latLong = lat+','+lng;
        dbu_GoogleMapApi_Responsewrapper responseWrapper = new dbu_GoogleMapApi_Responsewrapper();
        try{
            CSS_Integration_Details__c customDataDetails = CSS_Integration_Details__c.getValues('dbu_GeoCoding');
            EndPointFromCustomLabel = Label.dbu_GoogleMapApiKey;
            Access_Token = customDataDetails.Key__c;
            METHOD_TYPE = customDataDetails.Method_Type__c;
            ENP_POINT_URL = EndPointFromCustomLabel+''+latLong+'&key='+Access_Token;
            system.debug('ENP_POINT_URL' +ENP_POINT_URL);
            HttpRequest req = new HttpRequest();
            // req.setEndpoint('https://maps.googleapis.com/maps/api/geocode/json?latlng=45.015,-93.340&key=AIzaSyB--yU7qdi26kYfozz5bK2-W9wlqUNWiTE');
            // req.setMethod('GET');    
            req.setEndpoint(ENP_POINT_URL);
            req.setMethod(METHOD_TYPE);       
            Http http = new Http(); 
            HttpResponse res = http.send(req);
            responseWrapper = (dbu_GoogleMapApi_Responsewrapper)JSON.deserialize(res.getbody(), dbu_GoogleMapApi_Responsewrapper.class); 
            System.debug('zip code===='+responseWrapper.results[0].address_components);
            for(Integer i=0; i<responseWrapper.results[0].address_components.size(); i++){
                System.debug('In Loop===='+responseWrapper.results[0].address_components[i].types[0]);
                
                if(responseWrapper.results[0].address_components[i].types[0] == 'postal_code'){
                    System.debug('Postal Code===='+responseWrapper.results[0].address_components[i].long_name);
                    postalCode = responseWrapper.results[0].address_components[i].long_name;
                    break;
                }
                
            }
        }catch(CallOutException ce){
            system.debug('error in dbu_GeoCodingApi class' + ce.getMessage());
        } 
       return postalCode;
    //  return '48834';
        
    }
    
}