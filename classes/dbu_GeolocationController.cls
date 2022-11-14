public without sharing class dbu_GeolocationController {
    
    @AuraEnabled(Cacheable = true)
    public static list<LocationSearch> retriveAccs(String strAccName,decimal lat,decimal lngtde) {
        system.debug('strAccName'+strAccName);
        system.debug('lat>>>' +lat);
        list<dbu_Store_Location__c> lstAccs =  new List<dbu_Store_Location__c>();
        Location customerLocation;
        Location storeLocation;
        decimal distanceBtwnStoreCust;
        decimal distanceCalculation;
        if(strAccName != '' && strAccName != null){
                    strAccName = '%' + strAccName + '%';
                        system.debug('entering into if method>>>' +strAccName);
            lstAccs = [SELECT Id, Name,dbu_Business_Hours__c,dbu_City__c,dbu_Country__c,
                       dbu_Geo_Location__c,dbu_Geo_Location__longitude__s,
                       dbu_Geo_Location__Latitude__s,dbu_Phone__c,dbu_StoreCode__c,
                       dbu_Street__c,dbu_State__c,dbu_State_Code__c,dbu_ZipCode__c,dbu_Timezone__c,dbu_OrdersFrom__c,dbu_BusinessDay__c
                       FROM dbu_Store_Location__c WHERE
                       (dbu_State__c LIKE :strAccName OR
                       dbu_State_Code__c LIKE :strAccName OR
                       Name LIKE :strAccName OR
                       dbu_Street__c LIKE :strAccName OR dbu_City__c LIKE :strAccName OR 
                       dbu_State__c LIKE :strAccName OR 
                       dbu_Country__c LIKE :strAccName OR
                       dbu_ZipCode__c LIKE :strAccName) AND
                       dbu_Location_Status__c != 'Blocked'];
        }else if(strAccName == ''){
            system.debug('entering into else method>>>');
            lstAccs = [SELECT Id, Name,dbu_Business_Hours__c,dbu_City__c,dbu_Country__c,
                    dbu_Geo_Location__c,dbu_Geo_Location__longitude__s,
                    dbu_Geo_Location__Latitude__s,dbu_Phone__c,dbu_StoreCode__c,
                    dbu_Street__c,dbu_ZipCode__c,dbu_State__c,dbu_State_Code__c,dbu_Timezone__c,dbu_OrdersFrom__c,dbu_BusinessDay__c
                    FROM dbu_Store_Location__c WHERE
                   	dbu_Location_Status__c != 'Blocked'];
            //WHERE DISTANCE(dbu_Geo_Location__c, GEOLOCATION(:latitude,:latitude), 'mi') < 20 
            //ORDER BY DISTANCE(dbu_Geo_Location__c, GEOLOCATION(:latitude,:latitude), 'mi')];
            system.debug('lstAccs list>>>' +lstAccs);
        }
                    system.debug('lstAccs list1111>>>' +lstAccs);

        if(lstAccs.isEmpty()) {
            throw new AuraHandledException('No Record Found..');
        }
        List<LocationSearch> locSearch = new List<LocationSearch>();
        locSearch = returnAccs(lstAccs,lat,lngtde);
        return locSearch ;
        
       /* for(dbu_Store_Location__c acc :lstAccs){
            
            String phneValue = acc.dbu_Phone__c;
            System.debug(acc);
            GeoLocationSearch geoInfoRec = new GeoLocationSearch();
            geoInfoRec.Street = acc.dbu_Street__c;
            geoInfoRec.PostalCode = acc.dbu_ZipCode__c;
            geoInfoRec.City = acc.dbu_City__c;
            geoInfoRec.State = acc.dbu_State__c;
            geoInfoRec.Country = acc.dbu_Country__c;
            LocationSearch locDetailRec = new LocationSearch();
            locDetailRec.icon = 'action:map'; 
            locDetailRec.title = acc.Name;
            locDetailRec.description = acc.Name;
            locDetailRec.location = geoInfoRec;
            locDetailRec.businessDay = acc.dbu_BusinessDay__c;
            locDetailRec.stateCode = acc.dbu_State_Code__c;
            if(acc.dbu_Business_Hours__c != null && acc.dbu_Timezone__c != null){
            locDetailRec.businessHrs = acc.dbu_Business_Hours__c +'  '+acc.dbu_Timezone__c;
            }
            locDetailRec.Phone = acc.dbu_Phone__c;
            locDetailRec.storeLocationCode = acc.dbu_StoreCode__c;

            if(acc.dbu_Geo_Location__longitude__s != null && acc.dbu_Geo_Location__Latitude__s != null){
                if(lat != null && lngtde != null){
                    customerLocation = Location.newInstance(lat,lngtde);
                    storeLocation = Location.newInstance(acc.dbu_Geo_Location__Latitude__s,acc.dbu_Geo_Location__longitude__s);
                    distanceCalculation = Location.getDistance(customerLocation, storeLocation, 'mi');
                    distanceBtwnStoreCust = distanceCalculation.setScale(2);
                    
                    
                    if(distanceBtwnStoreCust != null){
                        locDetailRec.distance = distanceBtwnStoreCust;
                        
                    }
                }
            }else{
                locDetailRec.distance = null;
            }
            locDetailRec.id = acc.Id;
            locSearch.add(locDetailRec);
        }*/
    }
    
     @AuraEnabled(Cacheable = true)
    public static list<LocationSearch> retriveAccsZipCode(String zipCode,decimal lat,decimal lngtde) {
        system.debug('lat>>>' +lat);
        system.debug('lngtde>>>' +lngtde);

        list<dbu_Store_Location__c> lstAccs =  new List<dbu_Store_Location__c>();
        Location customerLocation;
        Location storeLocation;
        decimal distanceBtwnStoreCust;
        decimal distanceCalculation;
            
            lstAccs = [SELECT Id, Name,dbu_Business_Hours__c,dbu_City__c,dbu_Country__c,
                    dbu_Geo_Location__c,dbu_Geo_Location__longitude__s,
                    dbu_Geo_Location__Latitude__s,dbu_Phone__c,dbu_StoreCode__c,
                    dbu_Street__c,dbu_ZipCode__c,dbu_State__c,dbu_State_Code__c,dbu_Timezone__c,dbu_OrdersFrom__c,dbu_BusinessDay__c
                    FROM dbu_Store_Location__c WHERE
                    dbu_Location_Status__c!= 'Blocked'];
            system.debug('lstAccs list>>>' +lstAccs);
        
                    system.debug('lstAccs list1111>>>' +lstAccs);

        if(lstAccs.isEmpty()) {
            throw new AuraHandledException('No Record Found..');
        }
        List<LocationSearch> locSearch = new List<LocationSearch>();
       	locSearch = returnAccs(lstAccs,lat,lngtde);
        return locSearch ;
    }
    
    public static list<LocationSearch> returnAccs(list<dbu_Store_Location__c> lstAccs, decimal lat, decimal lngtde){
        List<LocationSearch> locSearch = new List<LocationSearch>();
        Location customerLocation;
        Location storeLocation;
        decimal distanceBtwnStoreCust;
        decimal distanceCalculation;
        
        for(dbu_Store_Location__c acc :lstAccs){
            
            String phneValue = acc.dbu_Phone__c;
            System.debug(acc);
            GeoLocationSearch geoInfoRec = new GeoLocationSearch();
            geoInfoRec.Street = acc.dbu_Street__c;
            geoInfoRec.PostalCode = acc.dbu_ZipCode__c;
            geoInfoRec.City = acc.dbu_City__c;
            geoInfoRec.State = acc.dbu_State__c;
            geoInfoRec.Country = acc.dbu_Country__c;
            LocationSearch locDetailRec = new LocationSearch();
            locDetailRec.icon = 'action:map'; 
            locDetailRec.title = acc.Name;
            locDetailRec.description = acc.Name;
            locDetailRec.location = geoInfoRec;
            locDetailRec.businessDay = acc.dbu_BusinessDay__c;
            locDetailRec.stateCode = acc.dbu_State_Code__c;
            if(acc.dbu_Business_Hours__c != null && acc.dbu_Timezone__c != null){
            locDetailRec.businessHrs = acc.dbu_Business_Hours__c +'  '+acc.dbu_Timezone__c;
            locDetailRec.timeZone = acc.dbu_Timezone__c;
            }
            locDetailRec.zone = acc.dbu_OrdersFrom__c;
            locDetailRec.Phone = acc.dbu_Phone__c;
            locDetailRec.storeLocationCode = acc.dbu_StoreCode__c;

            if(acc.dbu_Geo_Location__longitude__s != null && acc.dbu_Geo_Location__Latitude__s != null){
                if(lat != null && lngtde != null){
                    customerLocation = Location.newInstance(lat,lngtde);
                    storeLocation = Location.newInstance(acc.dbu_Geo_Location__Latitude__s,acc.dbu_Geo_Location__longitude__s);
                    distanceCalculation = Location.getDistance(customerLocation, storeLocation, 'mi');
                    distanceBtwnStoreCust = distanceCalculation.setScale(2);
                    
                    System.debug('distanceBtwnStoreCust======'+distanceBtwnStoreCust);
                    if(distanceBtwnStoreCust != null){
                        locDetailRec.distance = distanceBtwnStoreCust;
                        
                    }
                }
            }else{
                locDetailRec.distance = null;
            }
            locDetailRec.id = acc.Id;
            locSearch.add(locDetailRec);
        }
        
        return locSearch ;
    }
    @AuraEnabled
    public static void updateOrder(String orderId , LocationSearch orderRecord) {
        System.debug('==orderRecord Data==='+orderRecord);
        System.debug('==orderRecord=='+orderRecord.id);
        List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
        String selectedAddress = orderRecord.description +','+ orderRecord.location.City +','+ orderRecord.location.Street +','+ orderRecord.location.State +','+ orderRecord.location.Country+','+ orderRecord.location.PostalCode; 
        String storeCode = orderRecord.storeLocationCode;
        for(ccrz__E_OrderItem__c orderItemObj : [SELECT Id,dbu_Dropoff_Location__c,dbu_StoreCode__c,ccrz__OrderItemStatus__c,ccrz__Order__c FROM ccrz__E_OrderItem__c WHERE ccrz__OrderItemStatus__c  =: null AND ccrz__Order__c =: orderId ]){
            orderItemObj.dbu_Dropoff_Location__c = selectedAddress;
            orderItemObj.dbu_StoreCode__c = storeCode;
            orderItemList.add(orderItemObj);
        }
        System.debug('orderItemList.size===='+orderItemList.size());
        if(orderItemList.size() > 0){
            update orderItemList;
            System.debug('Record updated');
        }
        /* ccrz__E_Order__c record = new ccrz__E_Order__c();
record.Id = orderId;
record.dbu_Dropoff_Location__c = selectedAddress;
if(record != null){
update record;
}*/   
    }
    
    @AuraEnabled
    public static void updateShipTo(Boolean isShipTo, String orderId ) {
        List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
        for(ccrz__E_OrderItem__c orderItemObj : [SELECT Id,dbu_Shipto__c,ccrz__OrderItemStatus__c,ccrz__Order__c FROM ccrz__E_OrderItem__c WHERE ccrz__OrderItemStatus__c  =: null AND ccrz__Order__c =: orderId ]){
            orderItemObj.dbu_Shipto__c = isShipTo;
            orderItemList.add(orderItemObj);
        }
        if(orderItemList.size() > 0){
            update orderItemList;
        }
        /*  ccrz__E_Order__c record = new ccrz__E_Order__c();
record.Id = orderId;
record.dbu_Shipto__c = isShipTo;
if(record != null){
update record;
}*/
    }
    @AuraEnabled 
    public static Boolean getShipTo(String orderId){
        List<ccrz__E_OrderItem__c> orderItemList = [SELECT Id,dbu_Shipto__c,ccrz__OrderItemStatus__c,ccrz__Order__c FROM ccrz__E_OrderItem__c WHERE ccrz__OrderItemStatus__c  =: null AND ccrz__Order__c =: orderId ];
        //   ccrz__E_Order__c order = [SELECT Id, dbu_Shipto__c FROM ccrz__E_Order__c WHERE Id =: orderId];
        return orderItemList[0].dbu_Shipto__c;
    }
    @AuraEnabled
    public static void updateShipToStoreAddress(String orderId,String newShipToAddress){
        List<ccrz__E_OrderItem__c> orderItemList = new List<ccrz__E_OrderItem__c>();
        for(ccrz__E_OrderItem__c orderItemObj : [SELECT Id,dbu_Ship_to_Address__c,ccrz__OrderItemStatus__c,ccrz__Order__c FROM ccrz__E_OrderItem__c WHERE ccrz__OrderItemStatus__c  =: null AND ccrz__Order__c =: orderId ]){
            orderItemObj.dbu_Ship_to_Address__c = newShipToAddress;
            orderItemList.add(orderItemObj);
        }
        if(orderItemList.size() > 0){
            update orderItemList;
        }
        
        /* ccrz__E_Order__c oderObject = new ccrz__E_Order__c();
oderObject.id = orderId;
oderObject.dbu_Ship_to_Address__c = newShipToAddress;
if(oderObject != null){
update oderObject;
}*/
    }
    @AuraEnabled 
    public static ShipToAddress getShipToStoreAddress(String orderId){
        //List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
        ccrz__E_Order__c oderObj = new ccrz__E_Order__c();
        ShipToAddress shipToAddress = new ShipToAddress();
        oderObj = [select id ,name, ccrz__ShipTo__r.ccrz__AddressFirstline__c , ccrz__ShipTo__r.ccrz__AddressSecondline__c,ccrz__ShipTo__r.ccrz__AddressThirdline__c,ccrz__ShipTo__r.ccrz__Country__c, ccrz__ShipTo__r.ccrz__City__c,ccrz__ShipTo__r.ccrz__State__c,ccrz__ShipTo__r.ccrz__PostalCode__c from ccrz__E_Order__c where id =: orderId];
        shipToAddress.firstAddress = oderObj.ccrz__ShipTo__r.ccrz__AddressFirstline__c;
        shipToAddress.secondAddress = oderObj.ccrz__ShipTo__r.ccrz__AddressSecondline__c;
        shipToAddress.thirdAddress = oderObj.ccrz__ShipTo__r.ccrz__AddressThirdline__c;
        shipToAddress.city = oderObj.ccrz__ShipTo__r.ccrz__City__c;
        shipToAddress.state = oderObj.ccrz__ShipTo__r.ccrz__State__c;
        shipToAddress.country = oderObj.ccrz__ShipTo__r.ccrz__Country__c;
        shipToAddress.postalCode = oderObj.ccrz__ShipTo__r.ccrz__PostalCode__c;
        return shipToAddress;
    }
    public class ShipToAddress{
        @AuraEnabled public String firstAddress;
        @AuraEnabled public String secondAddress;
        @AuraEnabled public String thirdAddress;
        @AuraEnabled public String city;
        @AuraEnabled public String state;
        @AuraEnabled public String country;
        @AuraEnabled public String postalCode;
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
        @AuraEnabled
        public string timeZone{get;set;}
        @AuraEnabled
        public string zone{get;set;}
    }
   
    public class GeoLocationSearch{
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
}