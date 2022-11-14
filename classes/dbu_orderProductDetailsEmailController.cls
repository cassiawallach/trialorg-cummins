Public without sharing Class dbu_orderProductDetailsEmailController{

    public Id orderId {get;set;}
     public Boolean isShipTo {get;set;}
    public Boolean isPickup {get;set;}
    public Boolean isTrue {get;set;}
   /* public List<orderWrapper> pickupAddWrapper {get;set;}
    public dbu_orderProductDetailsEmailController(){
        pickupAddWrapper = new List<orderWrapper>();
         
    }*/
    public List<orderItemWrapper> getOrderItems(){
        
        //List<orderItemWrapper> productWrapper = new List<orderItemWrapper>();
        List<ccrz__E_OrderItem__c> orderItems=[SELECT Id,dbu_isShipTo__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_storeLanguage__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_StoreCode__c,ccrz__Quantity__c,ccrz__Order__r.ccrz__OriginatedCart__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_Cart_StoreCountry__c,ccrz__Price__c,ccrz__ItemTotal__c,ccrz__Product__c,ccrz__Product__r.name,ccrz__Order__r.dbu_Store_Language__c 
                                               FROM ccrz__E_OrderItem__c 
                                               WHERE ccrz__Order__c = :orderId
                                               AND ccrz__OrderItemStatus__c = 'Shipped'
                                              ];
        
        return lineItemHandler(orderItems);
    }
    
    public List<orderItemWrapper> getOrderItemsPickup(){
        
        //List<orderItemWrapper> productWrapper = new List<orderItemWrapper>();
        List<ccrz__E_OrderItem__c> orderItems=[SELECT Id,dbu_isShipTo__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_storeLanguage__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_StoreCode__c,ccrz__Quantity__c,ccrz__Order__r.ccrz__OriginatedCart__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_Cart_StoreCountry__c,ccrz__Price__c,ccrz__ItemTotal__c,ccrz__Product__c,ccrz__Product__r.name,ccrz__Order__r.dbu_Store_Language__c 
                                               FROM ccrz__E_OrderItem__c 
                                               WHERE ccrz__Order__c = :orderId
                                               AND ccrz__OrderItemStatus__c = 'Available for Pickup'
                                              ];
        
        return lineItemHandler(orderItems);
    }
    
    public List<orderItemWrapper> getAllOrderItems(){
  
        List<ccrz__E_OrderItem__c> orderItems=[SELECT Id,dbu_isShipTo__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_storeLanguage__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_StoreCode__c,ccrz__Quantity__c,ccrz__Order__r.ccrz__OriginatedCart__c,ccrz__Order__r.ccrz__OriginatedCart__r.dbu_Cart_StoreCountry__c,ccrz__Price__c,ccrz__ItemTotal__c,ccrz__Product__c,ccrz__Product__r.name,ccrz__Order__r.dbu_Store_Language__c 
                                               FROM ccrz__E_OrderItem__c 
                                               WHERE ccrz__Order__c = :orderId
                                              ];
        
        return lineItemHandler(orderItems);
    }
    
    public TrackingNumberWrapper getTrackingNumber(){
        if(orderId != null){
            ccrz__E_Order__c order = [SELECT Id,dbu_BMS_Tracking_Number__c,dbu_Store_Language__c FROM ccrz__E_Order__c WHERE Id =: orderId];
            TrackingNumberWrapper trackNumberWrapper = new TrackingNumberWrapper();
            List<String> allTrackingNumber = order.dbu_BMS_Tracking_Number__c.split(',');
            trackNumberWrapper.trackingNumber = allTrackingNumber;
            if(order.dbu_Store_Language__c == 'US'){
                trackNumberWrapper.orderTrackingUrl = 'https://www.fedex.com/fedextrack/?trknbr=';
                trackNumberWrapper.trackYourOrderText = 'Track Your Order ';
                trackNumberWrapper.trackingText = 'Tracking #';
            }else if(order.dbu_Store_Language__c == 'EN' || order.dbu_Store_Language__c == 'FR'){
                trackNumberWrapper.orderTrackingUrl = 'https://www.purolator.com/en/shipping/tracker?pins=';
                if(order.dbu_Store_Language__c == 'EN'){
                    trackNumberWrapper.trackYourOrderText = 'Track Your Order ';
                    trackNumberWrapper.trackingText = 'Tracking #';
                }else if(order.dbu_Store_Language__c == 'FR'){
                    trackNumberWrapper.trackYourOrderText = 'Suivez votre commande ';
                    trackNumberWrapper.trackingText = 'Suivi #';
                }
            }
            return trackNumberWrapper;
        }
        else{
            return null;
        }
    }
    
    public List<orderItemWrapper> lineItemHandler(List<ccrz__E_OrderItem__c> orderItems){
         List<orderItemWrapper> productWrapper = new List<orderItemWrapper>();
        Set<Id> productIdSet= new Set<Id>();    
        for(ccrz__E_OrderItem__c orderItem: orderItems){
            productIdSet.add(orderItem.ccrz__Product__c);

        }

        Map<Id,String> productMediaURI = new Map<Id,String>();
        for(ccrz__E_ProductMedia__c media: [SELECT Id,ccrz__Product__c,ccrz__MediaType__c ,ccrz__URI__c from ccrz__E_ProductMedia__c WHERE ccrz__Product__c IN :productIdSet]){
            if(media.ccrz__MediaType__c =='Product Image')
            productMediaURI.put(media.ccrz__Product__c,media.ccrz__URI__c);
        }
        for(ccrz__E_OrderItem__c orderItem: orderItems){
            String productURL;
            String imageURI = productMediaURI.containsKey(orderItem.ccrz__Product__c)?productMediaURI.get(orderItem.ccrz__Product__c):'';
            // String productURL = System.Label.dbu_Community_Url+System.Label.dbu_communityName+'product?name='+EncodingUtil.urlEncode(orderItem.ccrz__Product__r.name, 'UTF-8')+'&pid='+orderItem.ccrz__Product__c+'&store='+orderItem.ccrz__Order__r.ccrz__OriginatedCart__r.dbu_Cart_StoreCountry__c;
            //String productURL = System.Label.dbu_Community_Url+System.Label.dbu_communityName+'product/'+orderItem.ccrz__Product__c+'/'+EncodingUtil.urlEncode(orderItem.ccrz__Product__r.name, 'UTF-8');
            if(orderItem.ccrz__Order__r.ccrz__OriginatedCart__r.dbu_storeLanguage__c == 'FR'){
                productURL = System.Label.dbu_FrenchDomainName+System.Label.dbu_communityName+'product/'+orderItem.ccrz__Product__c+'/'+EncodingUtil.urlEncode(orderItem.ccrz__Product__r.name, 'UTF-8');
            } else {
               productURL = System.Label.dbu_EnglishDomainName+System.Label.dbu_communityName+'product/'+orderItem.ccrz__Product__c+'/'+EncodingUtil.urlEncode(orderItem.ccrz__Product__r.name, 'UTF-8');
            }
            System.debug('productURL====== '+productURL );
            System.debug('isShip TO===='+orderItem.dbu_isShipTo__c);
            if(orderItem.dbu_isShipTo__c == true){
                this.isShipTo = true;
            }else{
                this.isPickup = true;
            }
            productWrapper.add(new orderItemWrapper(orderItem,imageURI,productURL));

        }
        return productWrapper;
        
    }
  /*  public List<orderWrapper> getPickUpAddress(){
        orderWrapper pickupAdd = new orderWrapper();
        List<ccrz__E_Order__c> listOrds = new List<ccrz__E_Order__c>();
        listOrds=[SELECT Id,Name,ccrz__OriginatedCart__r.dbu_StoreCode__c FROM ccrz__E_Order__c WHERE id=:orderId];
        List<dbu_Store_Location__c> storeLocation = new List<dbu_Store_Location__c>();
        if(listOrds.size()>0){
            storeLocation=[Select id,name,dbu_City__c,dbu_Country__c,dbu_State__c,dbu_StoreCode__c,dbu_Street__c,dbu_ZipCode__c from dbu_Store_Location__c where dbu_StoreCode__c=:listOrds[0].ccrz__OriginatedCart__r.dbu_StoreCode__c limit 1];
        }
        
        if(storeLocation.size()>0){
            pickupAdd.locationName = storeLocation[0].Name;
            pickupAdd.street =storeLocation[0].dbu_Street__c;
            pickupAdd.city =storeLocation[0].dbu_City__c;
            pickupAdd.state =storeLocation[0].dbu_State__c;
            pickupAdd.zipcode =storeLocation[0].dbu_ZipCode__c;
            pickupAdd.country =storeLocation[0].dbu_Country__c;
           pickupAddWrapper.add(pickupAdd); 
        }
        return pickupAddWrapper;  
    }*/
    public class orderItemWrapper{
        public ccrz__E_OrderItem__c oItem {set;get;}
        public String productImageURL {set;get;}
        public String productURL{get;set;}
        
        orderItemWrapper(ccrz__E_OrderItem__c ordItem, String mediaURI,String producturl1){
            oItem = ordItem;
            productImageURL = mediaURI;
            productURL = producturl1;
        }
        
    
    }
    
    public class TrackingNumberWrapper{
        public List<String> trackingNumber {set;get;}
        public String orderTrackingUrl {set;get;}
        public String trackYourOrderText {set;get;}
        public String trackingText {set;get;}
        
       /* trackingNumberWrapper(List<String> trackingNumber, String orderCountry){
            trackingNumber = trackingNumber;
            orderCountry = orderCountry;
        }*/
    }
    
   /* public class orderWrapper
    {
        public String locationName{get;set;}
        public String street{get;set;}
        public String city{get;set;}
        public String state{get;set;}
        public String zipcode{get;set;}
        public String country{get;set;}
        public orderWrapper(){} 
    }*/
}