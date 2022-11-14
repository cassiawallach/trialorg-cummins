public with sharing class dbu_Wishlist_Email_Notification_Ctrl{

	public Id dbuEmailerId {get;set;}
    public string ContactName {get; set;}
        
    public dbu_Wishlist_Email_Notification_Ctrl(){

    }
    
    public list<emailResponseWrapper> getEachProduct(){
       
       list<emailResponseWrapper> EmailResponseWraplist = new list<emailResponseWrapper>(); 
       list<dbu_Emailer__c> Current_dbu_Emailer_Record = new list<dbu_Emailer__c>();
       Current_dbu_Emailer_Record  = [select ID, 
                                      dbu_Contact_Name__c,
                                      dbu_Wishlist_Language__c,
                                      (select id, CurrencyIsoCode, dbu_Product_Name__c, CC_Product_Name__c, dbu_Product_URI__c, dbu_Product_Price__c  from dbu_Email_Content__r) 
                                      from dbu_Emailer__c 
                                      where id =: dbuEmailerId];
       
        set<string> ContactNameset = new set<string>();
        
        if(Current_dbu_Emailer_Record.size() > 0){
            for(dbu_Emailer__c eachEmailer : Current_dbu_Emailer_Record){
                system.debug('eachEmailer > ' + eachEmailer);
                ContactNameset.add((string)eachEmailer.dbu_Contact_Name__c);
                if((eachEmailer.dbu_Email_Content__r).size() > 0){
                    
                    //Defining emailResponseWrapper
                    //emailResponseWrapper eachEmailResponseWrapper = new emailResponseWrapper();
                    for(dbu_Email_Content__c eachMetadata : eachEmailer.dbu_Email_Content__r){
                        
                        //Product Name 
                        string CurrentProductName;
                        if(eachMetadata.dbu_Product_Name__c != null){
                            CurrentProductName = eachMetadata.dbu_Product_Name__c;
                        }
                        
                        
                        //Product Price 
                        double CurrentProductPrice;
                        if(eachMetadata.dbu_Product_Price__c != null){
                            CurrentProductPrice = (double)eachMetadata.dbu_Product_Price__c;
                        }              
                        
                        //Product ID 
                        String CurrentProductID;
                        if(eachMetadata.CC_Product_Name__c != null){                        
                            CurrentProductID = (string)eachMetadata.CC_Product_Name__c;
                        }           
                        
                        //Product URI
                        string CurrentProductURI;
                        if(eachMetadata.dbu_Product_URI__c != null){
                            CurrentProductURI = eachMetadata.dbu_Product_URI__c;
                        }                    
                        
                        string CurrentCurrencyCode;
                        CurrentCurrencyCode = (string)eachMetadata.CurrencyIsoCode ;                        
                        EmailResponseWraplist.add(new emailResponseWrapper(CurrentProductID,CurrentProductPrice,CurrentProductName,CurrentProductURI,CurrentCurrencyCode));                                                
                        
                    }
                    
                }
            }
        }
        
        system.debug('EmailResponseWraplist > ' + EmailResponseWraplist);
        system.debug('EmailResponseWraplist.size() > ' + EmailResponseWraplist.size());        
			
        return EmailResponseWraplist;                                          
                   
    }
    
    public class emailResponseWrapper{
        public string ProductID {set;get;}
        public double Productprice {set;get;}
        public string ProductName {set;get;}
        public string ProductMediaURI {set;get;}
        public string CurrencyCode {set;get;}
    
        emailResponseWrapper(string wrapProductID, double wrapProductprice, string wrapProductName, string wrapProductMediaURI, string wrapCurrencyCode){
            ProductID 				= 	wrapProductID;
            Productprice 			= 	wrapProductprice;
            ProductName 			= 	wrapProductName;
            ProductMediaURI 		= 	wrapProductMediaURI;            
            CurrencyCode 			= 	wrapCurrencyCode;   
        }
    }
    
    
}