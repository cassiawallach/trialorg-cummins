/**********************************************************************
Name: FSL_CSSP_getServiceLocations
Copyright Â© 2021  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This class is used for getting the service locations for customer portal search
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
2.0         Jesse Allen             2/22/2022        FBI-222
********************************************************************************************************************/
public  without sharing class FSL_CSSP_getServiceLocations {
       
    @AuraEnabled(cacheable=true)
    public static  list<LocationSearch> getcurrentaddress(Decimal latitude ,Decimal longitude){
          Location customerLocation;
        Location storeLocation;
        decimal distanceBtwnStoreCust;
        decimal distanceCalculation;
        list<ServiceTerritory> getnearby = new list<ServiceTerritory>();
        List<LocationSearch> locSearch = new List<LocationSearch>();
        try {
            getnearby=[select Id, name, Country, City, State, Phone__c, postalcode, Street,Latitude,longitude
                       from ServiceTerritory where city!=null AND FSL_is_Visible_In_Service_Portal__c = true AND DISTANCE (address, GEOLOCATION(:latitude,:longitude), 'mi') < 250]; /*FBI-222 for changing distance to 250 from 700*/
            
            for(ServiceTerritory acc :getnearby){
                
                // String phneValue = acc.dbu_Phone__c;
                
                GeoLocationSearch geoInfoRec = new GeoLocationSearch();
                geoInfoRec.Street = acc.Street;
                geoInfoRec.PostalCode = acc.postalcode;
                geoInfoRec.City = acc.City;
                geoInfoRec.State = acc.State;
                geoInfoRec.Country = acc.Country;
                //geoInfoRec.Phone = acc.Phone__c;
                
                LocationSearch locDetailRec = new LocationSearch();
                locDetailRec.icon = 'action:map'; 
                locDetailRec.title = acc.Name;
                locDetailRec.description = acc.Name;
                locDetailRec.Phone = acc.Phone__c;
                locDetailRec.location = geoInfoRec;
                if(acc.Latitude != null && acc.longitude != null){
                    if(latitude != null && longitude != null){
                        System.Location loc1= System.Location.newInstance(latitude,longitude);
                        //loc1.newInstance(latitude, longitude);
                        
                        System.Location loc2 = System.Location.newInstance(acc.Latitude,acc.longitude);
                        //loc2.newInstance(acc.Latitude,acc.longitude);
                       
                        distanceCalculation = System.Location.getDistance(loc1, loc2, 'mi');
                        distanceBtwnStoreCust = distanceCalculation.setScale(2);
                        if(distanceBtwnStoreCust != null){
                            locDetailRec.distance = distanceBtwnStoreCust;
                            
                        }
                        //distanceBtwnStoreCust = dist.setScale(2);
                        /*customerLocation = Location.newInstance(lat,lngtde);
storeLocation = Location.newInstance(acc.Latitude,acc.longitude);
distanceCalculation = Location.getDistance(customerLocation, storeLocation, 'mi');
distanceBtwnStoreCust = distanceCalculation.setScale(2);
if(distanceBtwnStoreCust != null){
                            locDetailRec.distance = distanceBtwnStoreCust;
                            
                        }*/
                        
                        
                        
                    }
                }else{
                    locDetailRec.distance = null;
                }
                locDetailRec.id = acc.Id;
                locSearch.add(locDetailRec);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage()+''+e.getLineNumber());
        }
        return locSearch;
    }
    @AuraEnabled(cacheable=true)
   // public static list<LocationSearch> getLocPointes(string responselst){
        public static list<LocationSearch> getLocPointes(string postalCode,string City,string Country,string road,string state,string description){
       // Map<string,object> m = (Map<string,object>)JSON.deserializeUntyped(responselst);

       /* csp_locationJ2A j2a = new csp_locationJ2A();
        try {
        j2a=(csp_locationJ2A)json.deserialize(responselst,csp_locationJ2A.class);
        System.debug('j2a<><>'+j2a);
        System.debug('responselst<><>'+j2a.address.postcode);
            
        } catch (Exception e) {
            System.debug('error ' +e.getMessage());
            System.debug('error ' +e.getLineNumber());
            System.debug('error ' +e.getCause());
            
        }*/
        
        //System.debug('responselst<><>'+m.lon);
        
       /* HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','application/json');
        string access = 'pk.fd6cb9a3ba027394a5cb293681cc3182';
        string accesstoken = 'https://us1.locationiq.com/v1/reverse.php?key= '+ access + '&lat=' + latitude + '&lon='+longitude+'&format=json';
        req.setEndpoint(accesstoken);
        req.setBody(accesstoken);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if(res.getStatusCode() ==200){
            system.debug('res'+res.getBody());
        }
        GeoLocationSearch gg = new GeoLocationSearch();
        return new List<string>{'test'};*/
        list<LocationSearch> lstSearch = new list<LocationSearch>();
        GeoLocationSearch geoInfoRec = new GeoLocationSearch();
           
           // geoInfoRec.Street = j2a.display_name;
            geoInfoRec.PostalCode = postalCode;
            geoInfoRec.City = City;
            geoInfoRec.State = state;
            geoInfoRec.Country = country;
            LocationSearch locDetailRec = new LocationSearch();
            locDetailRec.icon = 'action:map'; 
            //locDetailRec.title = 'Theater';
            locDetailRec.description = description;
            locDetailRec.distance = null;
            locDetailRec.location = geoInfoRec;
            //locDetailRec.id = j2a;
            lstSearch.add(locDetailRec);
            system.debug('lstSearch <> '+lstSearch);
    return lstSearch;
        
               

    }
    
    public class LocationSearch{
        @AuraEnabled 
        public String icon{get;set;} 
        @AuraEnabled 
        public String title{get;set;} 
        @AuraEnabled
        public String description{get;set;} 
        @AuraEnabled 
        public GeoLocationSearch location{get;set;} 
        @AuraEnabled 
        public string Phone{get;set;} 
        @AuraEnabled 
        public string businessDay{get;set;}
        @AuraEnabled 
        public string businessHrs{get;set;} 
        @AuraEnabled 
        public Double distance{get;set;}
        @AuraEnabled
        public string id{get;set;}
        @AuraEnabled
        public string storeLocationCode{get;set;}
        @AuraEnabled
        public string stateCode{get;set;}
    }
    
    public class GeoLocationSearch{
        @AuraEnabled 
        public String Phone{get;set;}
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
    
    @AuraEnabled(cacheable=true)
    public static List<Location> getalllocations(Decimal lat,Decimal lon ) {
        
        User currentUser = [SELECT Id, Country
                                FROM User
                                WHERE
                            Id =:UserInfo.getUserId()];

        
      /*  List< ServiceTerritory> accs =  [select Id, name, Country, City, State, postalcode,Latitude,longitude, 
                                         Street from ServiceTerritory
                                         where Street!=NULL AND
                                         City!=NULL AND Country!=NULL AND  postalcode!=NULL AND
                                         State!=NULL] ;*/
                                         List< ServiceTerritory> accs =  [SELECT Id, name, Country, City, Phone__c, State, postalcode,Latitude,longitude, 
                                         Street FROM ServiceTerritory WHERE City!=null AND Latitude!=null AND longitude!=null
                                         AND Country =: currentUser.Country AND FSL_is_Visible_In_Service_Portal__c = true
                                         ];
        
        system.debug('accs' +accs);
        
        List<Location> loc = new List<Location>();
        for(ServiceTerritory acc :accs){
            System.debug(acc);
            GeoLocation geoInfo = new GeoLocation();
            geoInfo.Street = acc.Street;
            geoInfo.PostalCode = acc.postalcode;
            geoInfo.City = acc.City;
            geoInfo.State = acc.State;
            geoInfo.Country = acc.Country;
           // geoInfo.Phone = acc.Phone__c;
            Location locDetail = new Location();
            locDetail.icon = 'action:map'; 
            locDetail.title = acc.Name;
            locDetail.phone = acc.Phone__c;
            //locDetail.description = acc.Name;
            locDetail.location = geoInfo;
            locDetail.Id = acc.Id;
            
            loc.add(locDetail);
        }
        return loc ;
    }
    @AuraEnabled(cacheable=true)
    public static List<Location> getallContacts(string ConId) {  
        List<Location> loc = new List<Location>();
        try{
            List<Contact> con =  [select Id,Phone, Name,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalcode From Contact
            where MailingPostalcode!=null and Id=:ConId];   
            system.debug('<><>' +con);  
            system.debug('<><>ConId' +ConId);  

            for(Contact contID :con){
            System.debug(contID);
            GeoLocation geoInfo = new GeoLocation();
            geoInfo.Street = contID.MailingStreet;
            geoInfo.PostalCode = contID.MailingPostalcode;
            geoInfo.City = contID.MailingCity;
            geoInfo.State = contID.MailingState;
            geoInfo.Country = contID.MailingCountry;
            Location locDetail = new Location();
            locDetail.icon = 'action:map'; 
            locDetail.phone = contID.Phone;

            locDetail.title = contID.MailingStreet;
            //locDetail.description = acc.Name;
            locDetail.location = geoInfo;
            locDetail.Id = contID.Id; 
            locDetail.isLocationMatched = false;
            loc.add(locDetail);
}

        } 
        catch(Exception e){
            System.debug('e.message'+e.getLineNumber()+e.getCause()+e.getMessage());

        }
       
        return loc;
    }
    public class Location{
        @AuraEnabled 
        public String icon{get;set;} 
        @AuraEnabled 
        public String title{get;set;} 
        @AuraEnabled 
        public String Id{get;set;} 
        @AuraEnabled
        public String description{get;set;} 
        @AuraEnabled 
        public String phone{get;set;}
        @AuraEnabled 
        public GeoLocation location{get;set;}
        @AuraEnabled 
        public boolean isLocationMatched{get;set;} 
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
    @AuraEnabled 
    public static void updateServiceReq(string caseId,List<string> locValues){//string RecordTypeIdCase
        try{
            system.debug('entered into save');
            system.debug('entered into catch'+locValues);
            Case cs = [Select id,Location__c,RecordTypeId from Case where id=:caseId];
            //cs.Location__c = locValues[0] + ' ' + locValues[1] + ' '+ locValues[2] + ' '+ locValues[3] + ' '+ locValues[4];
            string locationVal = locValues[0] + ' ' + locValues[1] + ' '+ locValues[2] + ' '+ locValues[3] + ' '+ locValues[4];
            cs.Location__c  = locationVal.remove('null');
           // if(cs.RecordTypeId==''){
                //cs.RecordTypeId = RecordTypeIdCase;
           // }
            update cs;
            system.debug('entered into save'+cs);
            system.debug('entered into save'+cs.Location__c);

        }
        catch(exception e){
            system.debug('entered into catch');
            system.debug(e.getLineNumber()+e.getMessage()+e.getCause());

        }
      
        
    }
    
}