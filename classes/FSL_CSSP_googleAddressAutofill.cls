public without sharing class FSL_CSSP_googleAddressAutofill {
   //Method to get address details in the initial load
   @AuraEnabled
   public static case getAddressDetailsbyId(String id){
       case ad = new case();
       ad = [select Id, Location__c  from case where Id=: id];
       return ad;
   }
   public class GeoLocation{
    @AuraEnabled
    public String Street{get;set;}
    @AuraEnabled
    public String PostalCode{get;set;}
    @AuraEnabled
    public String City{get;set;}
    @AuraEnabled
    public String State{get;set;}
    @AuraEnabled
    public String Country{get;set;}
     }
     //Method to save address details on click on Save button
    @AuraEnabled
    public static String saveAddressDetailsbyId(String id, String addDetails){
        system.debug('saveAddressDetailsbyId method');
        case obj = [select Id,Location__c from case where Id=:id];
        obj.Location__c=addDetails;
       // obj.Location__c = addDetails.city__c;
       // obj.State__c = addDetails.State__c;
       // obj.Country__c = addDetails.Country__c;
       // obj.PostalCode__c = addDetails.PostalCode__c;
       // obj.Street__c = addDetails.Street__c;
        update obj;
        return 'Success';
    }
     //Method to call google API and fetch the address recommendations 
     @AuraEnabled
     public static String getAddressSet(String SearchText){
         String APIKey = 'AIzaSyAlFs7jBea1Z1EDHnwHpzdYp39c6gGAS-U';//AIzaSyBIwzALxUPNbatRBj3Xi1Uhp0fFzwWNBkE
         String result = null;
         system.debug('SearchText is ' + SearchText);
         try{
             if(SearchText != null){
                 String APIUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=' + SearchText.replace(' ', '%20') + '&key=' + APIKey; 
                 system.debug('APIUrl is ' + APIUrl);
                 HttpRequest req = new HttpRequest();
                 req.setMethod('GET');
                 req.setEndpoint(APIURL);
                 Http http = new Http();
                 HttpResponse res = http.send(req);
                 Integer statusCode = res.getStatusCode();
                 system.debug('statusCode is ' + statusCode);
                 if(statusCode == 200){
                     system.debug('API invoked successfully');
                     result = res.getBody();
                     system.debug('API invoked successfully' + result);
                 }
             }
         }
         catch(exception e){
             //Handling exception
             system.debug(e.getMessage());
         }
         return result;
     }
     
     //Method to call google API and fetch the address details by addressID 
     @AuraEnabled
     public static String getAddressDetailsByPlaceId(String PlaceID){
         String APIKey = 'AIzaSyAlFs7jBea1Z1EDHnwHpzdYp39c6gGAS-U';
         String result = null;
         system.debug('SearchText is ' + PlaceID);
         try{
             if(PlaceID != null){
                 String APIUrl = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=' + PlaceId.replace(' ', '%20') + '&key=' + APIKey; 
                 system.debug('APIUrl is ' + APIUrl);
                 HttpRequest req = new HttpRequest();
                 req.setMethod('GET');
                 req.setEndpoint(APIURL);
                 Http http = new Http();
                 HttpResponse res = http.send(req);
                 Integer statusCode = res.getStatusCode();
                 system.debug('statusCode is ' + statusCode);
                 if(statusCode == 200){
                     system.debug('API invoked successfully');
                     result = res.getBody();
                     system.debug('API invoked successfully' + result);
                 }
             }
         }
         catch(exception e){
             //Handling exception
             system.debug(e.getMessage());
         }
         return result;
     }
}