public class dbu_NotifyMeEmail_Ctrl {

    public Id dbuEmailContentId {get;set;}
    
    public dbu_NotifyMeEmail_Ctrl(){

    }    
    
    
    public list<emailResponseWrapper> getEachProduct(){
        
        list<emailResponseWrapper> EmailResponseWraplist = new list<emailResponseWrapper>(); 
        list<dbu_Email_Content__c> currentEmailContent = new list<dbu_Email_Content__c>();
        
        currentEmailContent = [Select id, 
                               CC_Product_Name__c, 
                               dbu_NotifyMe_Email_Sending_Initiated__c, 
                               dbu_NotifyMe_Email_Sent__c, 
                               dbu_Product_Inventory_Status__c, 
                               dbu_Product_Name__c, 
                               dbu_Product_Price__c, 
                               dbu_Product_URI__c, 
                               dbu_Emailer__r.dbu_Store_Country__c, 
                               dbu_Emailer__r.dbu_Store_Language__c, 
                               dbu_Emailer__r.dbu_Email_for_NotifyMe__c, 
                               dbu_Emailer__r.dbu_Email_Contact__c, 
                               dbu_Emailer__r.dbu_Contact_Name__c, 
                               dbu_Emailer__r.dbu_Contact_Email__c,
                               CurrencyIsoCode  
                               from dbu_Email_Content__c where id =: dbuEmailContentId]; 
        
        List<String> productIds = new List<String>();
        for(dbu_Email_Content__c eachcontect : currentEmailContent){
            productIds.add(eachcontect.CC_Product_Name__c);//@Vishnu
        }
        Map<String,List<ccrz__E_PriceListItem__c>> productPriceItemMap = new Map<String,List<ccrz__E_PriceListItem__c>>();
        if(productIds.size() > 0){
            for(ccrz__E_PriceListItem__c priceItem : [select id,ccrz__Price__c,ccrz__Product__c,ccrz__Pricelist__r.ccrz__CurrencyISOCode__c FROM ccrz__E_PriceListItem__c WHERE ccrz__Product__c IN :productIds]){
                
                if(!productPriceItemMap.containsKey(priceItem.ccrz__Product__c)) {
                    productPriceItemMap.put((String)priceItem.ccrz__Product__c,new List<ccrz__E_PriceListItem__c>{priceItem});
                } else {
                     List<ccrz__E_PriceListItem__c> exRecs = productPriceItemMap.get((String)priceItem.ccrz__Product__c);
                     exRecs.add(priceItem);
                     productPriceItemMap.put((String)priceItem.ccrz__Product__c,exRecs);
                }
            }
        }
        if(currentEmailContent.size() > 0){
            for(dbu_Email_Content__c eachcontect : currentEmailContent){
                string CurrentProductPrice = '0';
                Decimal price = 0;
                for(ccrz__E_PriceListItem__c priceRec : productPriceItemMap.get(eachcontect.CC_Product_Name__c)){
                    if(eachcontect.CurrencyIsoCode == priceRec.ccrz__Pricelist__r.ccrz__CurrencyISOCode__c){
                        price = priceRec.ccrz__Price__c;
                    }
                }
                if(price > 0){
                    CurrentProductPrice = string.valueof(price);
                }else{
                    if(eachcontect.CurrencyIsoCode == 'USD'){
                        CurrentProductPrice = 'Price Not Available';
                    }else if(eachcontect.CurrencyIsoCode == 'CAD'){
                        if(eachcontect.dbu_Emailer__r.dbu_Store_Language__c != null){
                            if(eachcontect.dbu_Emailer__r.dbu_Store_Language__c == 'FR'){
                               CurrentProductPrice = 'Prix non disponible'; 
                            }else if(eachcontect.dbu_Emailer__r.dbu_Store_Language__c == 'EN'){
                                CurrentProductPrice = 'Price Not Available';
                            }
                            
                        }else{
                            CurrentProductPrice = 'Price Not Available';
                        }
                        
                    }
                }
                
                string CurrentProductURI; 
                if(eachcontect.dbu_Product_URI__c != null){
                    CurrentProductURI = eachcontect.dbu_Product_URI__c;
                }
                
                string CurrentCurrencyCode;
                if(eachcontect.CurrencyIsoCode != null){
                    CurrentCurrencyCode = eachcontect.CurrencyIsoCode;
                }
                
                string CurrentProductName;
                if(eachcontect.dbu_Product_Name__c != null){
                    CurrentProductName = eachcontect.dbu_Product_Name__c; 
                }
                
                String CurrentProductID;
                if(eachcontect.CC_Product_Name__c != null){
                    CurrentProductID = (string)eachcontect.CC_Product_Name__c;
                } 
                
                EmailResponseWraplist.add(new emailResponseWrapper(CurrentProductID,CurrentProductPrice,CurrentProductName,CurrentProductURI,CurrentCurrencyCode));                                                
                
            }	            
        }
        
        system.debug('EmailResponseWraplist > ' + EmailResponseWraplist);
        system.debug('EmailResponseWraplist.size() > ' + EmailResponseWraplist.size());              
		return EmailResponseWraplist;
        
    }
    
    
    
    public class emailResponseWrapper{
        public string ProductID {set;get;}
        public string Productprice {set;get;}
        public string ProductName {set;get;}
        public string ProductMediaURI {set;get;}
        public string CurrencyCode {set;get;}
    
        emailResponseWrapper(string wrapProductID, string wrapProductprice, string wrapProductName, string wrapProductMediaURI, string wrapCurrencyCode){
            ProductID 				= 	wrapProductID;
            Productprice 			= 	wrapProductprice;
            ProductName 			= 	wrapProductName;
            ProductMediaURI 		= 	wrapProductMediaURI;            
            CurrencyCode 			= 	wrapCurrencyCode;   
        }
    }    
    
    
}