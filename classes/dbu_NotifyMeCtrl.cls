public without sharing class dbu_NotifyMeCtrl {
    @AuraEnabled
    public static boolean RecordNotifyMeData(string urlParam, string storeCountry, string StoreLanguage,string emailaddress){
        System.debug('url>>>>>>>>>>>>>>>>> '+urlParam);
		Boolean ProductAddedToNotifyMe = false;
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);        

        
        if(TEST.isRunningTest()){
            countryCurrencyMap.put('US', 'USD');
        }
        string CurrentCountryISOCode =  (string)countryCurrencyMap.get(storeCountry);
        system.debug('CurrentCountryISOCode > ' + CurrentCountryISOCode);        
        
        try{
            //check for the product id in side the URLPARAM
            if(String.isNotBlank(urlParam)){
                //ApexPages.PageReference ref = new ApexPages.PageReference(urlParam);
                //Map<String, String> params = ref.getParameters();     
                list<string> urlsplited =  new list<string>();
                urlsplited = urlParam.split('/');
                if(urlsplited.size() > 0){
                    if(urlsplited[6] != null && urlsplited[6] != ''){
                    string CurrentProduct = urlsplited[6];
                    system.debug('CurrentProduct > ' + CurrentProduct);
                                        
                    //get the product details
                    list<ccrz__E_Product__c> lstproduct = new list<ccrz__E_Product__c>();
                    lstproduct = [select id, 
                                  (select ccrz__Price__c from ccrz__E_PriceListItems__r where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c =: CurrentCountryISOCode),
                                  (select ccrz__URI__c from ccrz__E_ProductMedias__r where ccrz__URI__c != null and ccrz__MediaType__c = 'Product Image' LIMIT 1)
                                  from ccrz__E_Product__c 
                                  where id =: CurrentProduct 
                                  and ccrz__Storefront__c ='CSSNAStore' and Group_Name__c = 'Ecom'];		

                    if(lstproduct.size()>0){
						user CurrentUser;                        
                        if(userinfo.getUserType() != 'Guest'){
                         	//get loggedin user contact
                            CurrentUser = [select id,contactid from user where id =: userinfo.getUserId()];                           
                        }
                                               
                        //check if emailId already exists in dbu_emailer records.
                        list<dbu_Emailer__c> dbuEmailerRecordforCurrentEmailId = new list<dbu_Emailer__c>(); 
                        if(userinfo.getUserType() == 'Guest'){
                            dbuEmailerRecordforCurrentEmailId = [select id,
                                                                 dbu_Contact_Email__c,
                                                                 dbu_Store_Language__c,
                                                                 dbu_Store_Country__c,
                                                                 dbu_Email_for_NotifyMe__c 
                                                                 from dbu_Emailer__c 
                                                                 where dbu_Contact_Email__c =: emailaddress 
                                                                 and dbu_Email_for_NotifyMe__c = true 
                                                                 and dbu_Store_Language__c =: StoreLanguage 
                                                                 and dbu_Store_Country__c =: storeCountry 
                                                                 and dbu_Email_Contact__c = null 
                                                                 Limit 1 ];
                        }else{                                                        
                            dbuEmailerRecordforCurrentEmailId = [select id,
                                                                 dbu_Contact_Email__c,
                                                                 dbu_Store_Language__c,
                                                                 dbu_Store_Country__c,
                                                                 dbu_Email_for_NotifyMe__c 
                                                                 from dbu_Emailer__c 
                                                                 where dbu_Contact_Email__c =: emailaddress 
                                                                 and dbu_Email_for_NotifyMe__c = true 
                                                                 and dbu_Store_Language__c =: StoreLanguage 
                                                                 and dbu_Store_Country__c =: storeCountry 
                                                                 and dbu_Email_Contact__c =: CurrentUser.contactid 
                                                                 Limit 1];                            
                        }

                        string currenctEmailerRecord;
                        if(dbuEmailerRecordforCurrentEmailId.size() > 0){
                            //Email Record Exists
                            system.debug('Email Record Exists');
                            currenctEmailerRecord = (string)dbuEmailerRecordforCurrentEmailId[0].id;                            
                        }else{
                           	//Email Record dont exist, create new
                           	list<dbu_Emailer__c> currenctEmailRecordlist = new list<dbu_Emailer__c>();
                            dbu_Emailer__c currenctEmailRecord = new dbu_Emailer__c();
                            currenctEmailRecord.dbu_Store_Language__c = StoreLanguage;
                            currenctEmailRecord.dbu_Store_Country__c = storeCountry;
                            currenctEmailRecord.dbu_Email_for_NotifyMe__c = true;
                            currenctEmailRecord.dbu_Contact_Email__c = emailaddress;                                                        
                            currenctEmailRecord.CurrencyIsoCode = CurrentCountryISOCode;
                            //If Logged in user user                                                        
                            if(userinfo.getUserType() != 'Guest'){
                                currenctEmailRecord.dbu_Email_Contact__c = CurrentUser.contactid;        
                            }
                            currenctEmailRecordlist.add(currenctEmailRecord);
                            
                            //Insert new Dbu_Emailer record
                            Database.SaveResult[] srList = Database.insert(currenctEmailRecordlist, true);
                            
                            //Interating over results to get id
                            for (Database.SaveResult sr : srList) {
                                if (sr.isSuccess()) {
                                    // Operation was successful, so get the ID of the record that was processed
                                    System.debug('Successfully inserted dbu_emailer record . dbu_emailer ID: ' + sr.getId());
                                    currenctEmailerRecord = sr.getId();
                                }
                                else {
                                    // Operation failed, so get all errors                
                                    for(Database.Error err : sr.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('dbu_emailer fields that affected this error: ' + err.getFields());
                                    }
                                }
                            }                                                        
                        }
                        
                        //Create a dbu_EmailContent record
                        list<dbu_Email_Content__c> currentEmailContentlist = new list<dbu_Email_Content__c>();
                        dbu_Email_Content__c currentEmailContent = new dbu_Email_Content__c();
						currentEmailContent.dbu_Emailer__c = currenctEmailerRecord;
                        currentEmailContent.CC_Product_Name__c = lstproduct[0].id;
                        if((lstproduct[0].ccrz__E_PriceListItems__r).size() > 0){
                            currentEmailContent.dbu_Product_Price__c = lstproduct[0].ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                        }
                        if((lstproduct[0].ccrz__E_ProductMedias__r).size() > 0){
                        	currentEmailContent.dbu_Product_URI__c = lstproduct[0].ccrz__E_ProductMedias__r[0].ccrz__URI__c;    
                        }                                                 
                        currentEmailContent.dbu_Product_Inventory_Status__c = false;
                        currentEmailContent.dbu_NotifyMe_Email_Sending_Initiated__c = false;
                        currentEmailContent.dbu_NotifyMe_Email_Sent__c = false;
                        currentEmailContent.CurrencyIsoCode = CurrentCountryISOCode;
                        currentEmailContent.dbu_Emailer_Email_Address__c = emailaddress;
                        currentEmailContentlist.add(currentEmailContent);
                        
                        //Insert new Dbu Email Content record
                        Database.SaveResult[] srList2 = Database.insert(currentEmailContentlist, true);                        
                        //Interating over results to get id
                        for (Database.SaveResult sr : srList2) {
                            if (sr.isSuccess()) {
                                // Operation was successful, so get the ID of the record that was processed
                                System.debug('Successfully inserted Dbu Email Content record . Dbu Email Content ID: ' + sr.getId());
                                ProductAddedToNotifyMe = true;
                            }
                            else {
                                // Operation failed, so get all errors                
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('The following error has occurred.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Dbu Email Content fields that affected this error: ' + err.getFields());
                                }
                            }
                        }                        
                        
                        
                    }                             
                    }
                }
                
            }
        }catch(exception e){
            system.debug('ERROR CAUSE > ' + e.getCause());
            system.debug('ERROR MESSAGE > ' + e.getMessage());
			system.debug('ERROR LINENUMBER > ' + e.getLineNumber());                         
			system.debug('ERROR STACKTRACE > '+  e.getStackTraceString());
            system.debug('ERROR TYPE > ' + e.getTypeName());
        }
        
        return ProductAddedToNotifyMe;
    }
    
    public static void ProceedToSendNotifyMeEmail(list<dbu_Email_Content__c> emailContentList){
        
        //list to update
        list<dbu_Email_Content__c> EmailContentListToUpdate = new list<dbu_Email_Content__c>();
        
        //Segregate Products with respect to Country code and Language
        system.debug('emailContentList > '+ emailContentList);
        
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);    
        
        if(Test.isRunningTest()){
            countryCurrencyMap.put('US','USD');
        }
        
        set<string> ProductIdset = new set<string>();
        for(dbu_Email_Content__c eachRec : emailContentList){
            ProductIdset.add(eachRec.CC_Product_Name__c);
        }
        
        //Handling Product Inventory
        Map<string,Map<string,double>> CurrencyISObyProductInventoryMapping = new Map<string,Map<string,double>>();
        
        for(string currencycodestring: countryCurrencyMap.values()){
            system.debug('currencycodestring  > ' + currencycodestring);
            CurrencyISObyProductInventoryMapping.put(currencycodestring, new Map<string,double>{});            
        }
        
        
        Map<string,Map<string,double>> ProductInventoryMappingOnCurrency = new Map<string,Map<string,double>>();

        //-------> CHECK FOR INVENTORY
        list<AggregateResult> productInventory = new list<AggregateResult>();
        productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, 
                            ccrz__ProductItem__c PRODUCTID, 
                            CurrencyIsoCode CURRENCYCODE 
                            from ccrz__E_ProductInventoryItem__c 
                            where ccrz__ProductItem__c IN : ProductIdset 
                            and CurrencyIsoCode IN : countryCurrencyMap.values() 
                            GROUP BY ccrz__ProductItem__c,CurrencyIsoCode];
        system.debug(productInventory);         
        
        //-------> STORE INVENTORY FOR PRODUCTS
        if(productInventory.size() > 0){
            for(AggregateResult pi : productInventory){
                string pi_currencycode = (string)pi.get('CURRENCYCODE');
                if(pi.get('PRODUCTID') != null && pi.get('TOTALQUANTITY') != null){
                    Map<string,double> current_currencycode_productinventory = (Map<string,double>)CurrencyISObyProductInventoryMapping.get(pi_currencycode);
                    system.debug('PRODUCTID > ' + (string)pi.get('PRODUCTID') + ' TOTAL QUANTITY > ' +  (double)pi.get('TOTALQUANTITY'));
                    
                    current_currencycode_productinventory.put((string)pi.get('PRODUCTID') , (double)pi.get('TOTALQUANTITY'));                
                    //CurrencyISObyProductInventoryMapping
                    CurrencyISObyProductInventoryMapping.put(pi_currencycode, current_currencycode_productinventory);        	                    
                }
            }
        }
        
        system.debug('CurrencyISObyProductInventoryMapping > ' + CurrencyISObyProductInventoryMapping);   
        
        
        for(dbu_Email_Content__c each : emailContentList){
            if(each.dbu_Emailer__r.dbu_Contact_Email__c != null && each.CC_Product_Name__c != null){
            	if(each.dbu_Emailer__r.dbu_Store_Language__c != null && each.dbu_Emailer__r.dbu_Store_Country__c != null ){
                    double quantity = 0;
                    if((double)((Map<string,double>)CurrencyISObyProductInventoryMapping.get(each.CurrencyIsoCode)).get((string)each.CC_Product_Name__c) != null){
                        quantity = (double)((Map<string,double>)CurrencyISObyProductInventoryMapping.get(each.CurrencyIsoCode)).get((string)each.CC_Product_Name__c);
                        if(quantity > 0){
                            each.dbu_Product_Inventory_Status__c = true;
                            each.dbu_NotifyMe_Email_Sending_Initiated__c = true;
                            EmailContentListToUpdate.add(each);
                        }
                    }
                 	  
                }
            }
            
        }
        
        system.debug('EmailContentListToUpdate > ' + EmailContentListToUpdate);
        system.Debug('EmailContentListToUpdate size > ' + EmailContentListToUpdate.size());
        
        database.SaveResult[] dbu_email_Contents_Updates = Database.update(EmailContentListToUpdate, false);

        for (Database.SaveResult sr : dbu_email_Contents_Updates) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted dbuEmailer. dbuEmailer ID: ' + sr.getId());
                //dbu_Email_Content_InsertedIDs.add((string)sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('dbuEmailer fields that affected this error: ' + err.getFields());
                }
            }
        }         
        
            
        }
        
        
        
        
        
    
}