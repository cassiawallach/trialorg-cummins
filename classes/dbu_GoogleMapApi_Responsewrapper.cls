public class dbu_GoogleMapApi_Responsewrapper {
    public dbu_GoogleMapApi_Responsewrapper(){
        
    }    
    public class Address_components {
        @AuraEnabled public String long_name;
        @AuraEnabled public String short_name;
        @AuraEnabled public List<String> types;
    }
    
    public class Geometry {
        @AuraEnabled public Location location;
        @AuraEnabled public String location_type;
        @AuraEnabled public Viewport viewport;
    }
    
    @AuraEnabled public List<Results> results;
    public class Results {
        @AuraEnabled public List<Address_components> address_components;
        @AuraEnabled public String formatted_address;
        @AuraEnabled public Geometry geometry;
        @AuraEnabled public String place_id;
        @AuraEnabled public List<String> types;
    }
    
    public class Viewport {
        @AuraEnabled public Location northeast;
        @AuraEnabled public Location southwest;
    }
    
    public class Location {
        @AuraEnabled public Double lat;
        @AuraEnabled public Double lng;
    }
    
    
    public static dbu_GoogleMapApi_Responsewrapper parse(String json) {
        return (dbu_GoogleMapApi_Responsewrapper) System.JSON.deserialize(json, dbu_GoogleMapApi_Responsewrapper.class);
    }
}