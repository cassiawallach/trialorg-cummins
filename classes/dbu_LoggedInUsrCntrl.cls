public class dbu_LoggedInUsrCntrl {
    @AuraEnabled
    public static List<dbu_ccAddressWrapper> fetchCCAddressShippingAndBilling(){
        system.debug('coming to this method fetchCCAddressShippingAndBilling>>>');
        id contLOggedInusrId = null;
        List<User> contactUsrID = new List<User>();
        List<String> shippingAddressList = new List<String>();
        List<dbu_ccAddressWrapper> ccAddressWrapperList = new List<dbu_ccAddressWrapper>();
        List<dbu_ShippingCCAddressWrapper> shippingWrapperList = new List<dbu_ShippingCCAddressWrapper>();
        List<dbu_billingCCAddressWrapper> billingWrapperList = new List<dbu_billingCCAddressWrapper>();
        
        
        Id loggedInUserID = UserInfo.getUserId();
        contactUsrID = [Select id,ContactID FROM User
                        WHERE id = :loggedInUserID];
        system.debug('contLOggedInusrId' +contactUsrID);
        for(User usr: contactUsrID){
            contLOggedInusrId = usr.ContactID;
        }
        
        List<ccrz__E_ContactAddr__c>contactAddressData = new List<ccrz__E_ContactAddr__c>();
        system.debug('userID' +loggedInUserID);
        Set<String> addressIdList = new Set<String>();
        
        if(loggedInUserID != null){
            
            contactAddressData = [SELECT Id,Name,dbu_Contact__c,ccrz__ShippingComments__c,dbu_Default_Address__c,ccrz__FirstName__c,ccrz__LastName__c,
                                  ccrz__Email__c,ccrz__HomePhone__c,ccrz__AddressFirstline__c,ccrz__AddressSecondline__c,ccrz__City__c,
                                  ccrz__State__c,ccrz__Country__c,ccrz__PostalCode__c,ccrz__CompanyName__c	
                                  FROM ccrz__E_ContactAddr__c where dbu_Contact__c =:contLOggedInusrId
                                  AND dbu_Contact__c <> null];
            system.debug('contactAddressData' +contactAddressData);
           // if(contactAddressData != null && contactAddressData.size()>0 ){
                system.debug('coming after if');
                dbu_ccAddressWrapper wrapperList = new dbu_ccAddressWrapper();
                                system.debug('coming after wrapper');

                for(ccrz__E_ContactAddr__c conAddRec:contactAddressData){
                    if(conAddRec.ccrz__ShippingComments__c == 'Shipping Comments'){
                        dbu_ShippingCCAddressWrapper shippingData = new dbu_ShippingCCAddressWrapper();
                        shippingData.firstName = conAddRec.ccrz__FirstName__c;
                        shippingData.lastName = conAddRec.ccrz__LastName__c;
                        shippingData.dbuDefaultAddress = conAddRec.dbu_Default_Address__c;
                        shippingData.addressFirstline = conAddRec.ccrz__AddressFirstline__c;
                        shippingData.addressSecondline=conAddRec.ccrz__AddressSecondline__c;
                        shippingData.city=conAddRec.ccrz__City__c;
                        shippingData.state=conAddRec.ccrz__State__c;
                        shippingData.postalCode=conAddRec.ccrz__PostalCode__c;
                        shippingData.country=conAddRec.ccrz__Country__c;
                        shippingData.shippingComments = conAddRec.ccrz__ShippingComments__c;
                        shippingData.sfid =conAddRec.Id;
                        shippingData.companyName = conAddRec.ccrz__CompanyName__c;
                        shippingData.email=conAddRec.ccrz__Email__c;
                        shippingData.homePhone=conAddRec.ccrz__HomePhone__c;

                        shippingWrapperList.add(shippingData);
                    }
                    if(conAddRec.ccrz__ShippingComments__c == 'Billing Comments'){
                        dbu_billingCCAddressWrapper billingData = new dbu_billingCCAddressWrapper();
                        billingData.firstName = conAddRec.ccrz__FirstName__c;
                        billingData.lastName = conAddRec.ccrz__LastName__c;
                        billingData.dbuDefaultAddress = conAddRec.dbu_Default_Address__c;
                        billingData.addressFirstline = conAddRec.ccrz__AddressFirstline__c;
                        billingData.addressSecondline=conAddRec.ccrz__AddressSecondline__c;
                        billingData.city=conAddRec.ccrz__City__c;
                        billingData.state=conAddRec.ccrz__State__c;
                        billingData.postalCode=conAddRec.ccrz__PostalCode__c;
                        billingData.country=conAddRec.ccrz__Country__c;
                        billingData.billingComments = conAddRec.ccrz__ShippingComments__c;
                        billingData.sfid =conAddRec.Id;
                        billingData.companyName = conAddRec.ccrz__CompanyName__c;
                        billingData.email=conAddRec.ccrz__Email__c;
                        billingData.homePhone=conAddRec.ccrz__HomePhone__c;

                        billingWrapperList.add(billingData);
                    }
                    
                }
                wrapperList.shippingWrapper=shippingWrapperList;
                wrapperList.billingWrapper=billingWrapperList;
                ccAddressWrapperList.add(wrapperList);
                system.debug('shippingAddressList>>' +shippingAddressList);                
            }
        //}
        return ccAddressWrapperList;
        
    }
   
    @AuraEnabled
    
     
    public static List<Map<String, Object>> fetchCCAddressShipping(){
        system.debug('coming to this method>>>');
        
        Id loggedInUserID = UserInfo.getUserId();
        List<ccrz__E_ContactAddr__c>contactAddressData = new List<ccrz__E_ContactAddr__c>();
        system.debug('userID' +loggedInUserID);
        Set<String> addressIdList = new Set<String>();
        List<String> shippingAddressList = new List<String>();
        Id contLOggedInusrId;
        List<User> contactUsrID = new List<User>();
        contactUsrID = [Select id,ContactID FROM User
                             WHERE id = :loggedInUserID];
        system.debug('contLOggedInusrId' +contactUsrID);
            for(User usr: contactUsrID){
                contLOggedInusrId = usr.ContactID;
            }
        
        if(loggedInUserID != null){
            contactAddressData = [SELECT id,Name,dbu_Contact__c,ccrz__ShippingComments__c,dbu_Default_Address__c,ccrz__FirstName__c,ccrz__LastName__c,
                                  ccrz__Email__c,ccrz__HomePhone__c,ccrz__AddressFirstline__c,ccrz__AddressSecondline__c,ccrz__City__c,
                                  ccrz__State__c,ccrz__Country__c,ccrz__PostalCode__c,ccrz__CompanyName__c	
                                  FROM ccrz__E_ContactAddr__c where dbu_Contact__c =:contLOggedInusrId
                                  AND dbu_Contact__c <> null];
            system.debug('contactAddressData' +contactAddressData);
            for(ccrz__E_ContactAddr__c conAddRec: contactAddressData){
                system.debug('conAddRec.dbu_Default_Address__c' +conAddRec.dbu_Default_Address__c);
                if(conAddRec.ccrz__ShippingComments__c == 'Shipping Comments'){
                    //shipping = conAddRec.ccrz__ShippingComments__c.substring(0, conAddRec.ccrz__ShippingComments__c.indexOf('Comments'));
                    //shipping = conAddRec.ccrz__ShippingComments__c;
                    addressIdList.add(conAddRec.ID);
                    if(conAddRec.dbu_Default_Address__c == true){
                        system.debug('entering the default true loop>>' +conAddRec.dbu_Default_Address__c);
                        shippingAddressList.add(conAddRec.ccrz__FirstName__c);
                        shippingAddressList.add(conAddRec.ccrz__LastName__c);
                        //shippingAddressList.add(conAddRec.ccrz__Email__c);
                        //shippingAddressList.add(conAddRec.ccrz__HomePhone__c);
                        // shippingAddressList.add(conAddRec.ccrz__AddressFirstline__c);
                        // shippingAddressList.add(conAddRec.ccrz__AddressSecondline__c);
                        // shippingAddressList.add(conAddRec.ccrz__City__c);
                        // shippingAddressList.add(conAddRec.ccrz__State__c);
                        // shippingAddressList.add(conAddRec.ccrz__PostalCode__c);
                        // shippingAddressList.add(conAddRec.ccrz__Country__c);
                    }
                }
                
            }
            if(shippingAddressList != null){
                system.debug('shippingAddressList>>' +shippingAddressList);
                //shippingAddressData(shippingAddressList);
            }
        }
        
        List<Map<String, Object>> outputAddressList = new List<Map<String, Object>>{};
            Map<String, Object> inputData = new Map<String, Object>{
                ccrz.ccAPIAddress.ADDRESSIDLIST => addressIdList,
                    ccrz.ccAPI.API_VERSION => 9
                    };
                        try {
                            Map<String, Object> outputData = ccrz.ccAPIAddress.fetch(inputData);
                            if (outputData.get(ccrz.ccAPIAddress.ADDRESSLIST) != null) {
                                // The cast to List<Map<String, Object>> is necessary...
                                outputAddressList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPIAddress.ADDRESSLIST);
                                system.debug('outputAddressList' +outputAddressList);
                                
                                // The cast, again, is necessary...
                                String sfid = (String) outputAddressList[0].get('sfid');
                                system.debug('sfid>> ' + sfid);
                                String firstName = (String) outputAddressList[0].get('firstName');
                                Boolean dbuDefaultAddress = (boolean) outputAddressList[0].get('dbuDefaultAddress');
                                system.debug('dbuDefaultAddress>> ' + dbuDefaultAddress);
                            }
                        } catch (Exception e) {
                            // Error handling...
                            system.debug(e);
                        }
        system.debug('return' +outputAddressList);
        return outputAddressList;
    }
    
    @AuraEnabled
    public static List<Map<String, Object>> fetchCCAddressBilling(){
        system.debug('coming to this billing method>>>');
        Id loggedInUserID = UserInfo.getUserId();
        List<ccrz__E_ContactAddr__c>contactAddressData = new List<ccrz__E_ContactAddr__c>();
        system.debug('userID' +loggedInUserID);
        Set<String> addressIdList = new Set<String>();
        List<String> billingAddressList = new List<String>();
        Id contLOggedInusrId;
        List<User> contactUsrID = new List<User>();
        contactUsrID = [Select id,ContactID FROM User
                             WHERE id = :loggedInUserID];
        system.debug('contLOggedInusrId' +contactUsrID);
            for(User usr: contactUsrID){
                contLOggedInusrId = usr.ContactID;
            }
        
        if(loggedInUserID != null){
            contactAddressData = [SELECT id,Name,dbu_Contact__c,ccrz__ShippingComments__c,dbu_Default_Address__c,ccrz__FirstName__c,ccrz__LastName__c,
                                  ccrz__Email__c,ccrz__HomePhone__c,ccrz__AddressFirstline__c,ccrz__AddressSecondline__c,ccrz__City__c,
                                  ccrz__State__c,ccrz__Country__c,ccrz__PostalCode__c,ccrz__CompanyName__c
                                  FROM ccrz__E_ContactAddr__c where dbu_Contact__c =:contLOggedInusrId
                                  AND dbu_Contact__c <> null];
            for(ccrz__E_ContactAddr__c conAddRec: contactAddressData){
                if(conAddRec.ccrz__ShippingComments__c == 'Billing Comments'){
                    addressIdList.add(conAddRec.ID);
                    if(conAddRec.dbu_Default_Address__c == true){
                        system.debug('entering the default true loop>>' +conAddRec.dbu_Default_Address__c);
                        billingAddressList.add(conAddRec.ccrz__FirstName__c);
                        billingAddressList.add(conAddRec.ccrz__LastName__c);
                        billingAddressList.add(conAddRec.ccrz__Email__c);
                        billingAddressList.add(conAddRec.ccrz__HomePhone__c);
                        billingAddressList.add(conAddRec.ccrz__AddressFirstline__c);
                        billingAddressList.add(conAddRec.ccrz__AddressSecondline__c);
                        billingAddressList.add(conAddRec.ccrz__City__c);
                        billingAddressList.add(conAddRec.ccrz__State__c);
                        billingAddressList.add(conAddRec.ccrz__PostalCode__c);
                        billingAddressList.add(conAddRec.ccrz__Country__c);
                    }
                }
                
            }
            if(billingAddressList != null){
                // billingAddressData(billingAddressList);
            }
        }
        
        List<Map<String, Object>> outputBillingAddressList = new List<Map<String, Object>>{};
            Map<String, Object> inputData = new Map<String, Object>{
                ccrz.ccAPIAddress.ADDRESSIDLIST => addressIdList,
                    ccrz.ccAPI.API_VERSION => 9
                    };
                        try {
                            Map<String, Object> outputData = ccrz.ccAPIAddress.fetch(inputData);
                            if (outputData.get(ccrz.ccAPIAddress.ADDRESSLIST) != null) {
                                // The cast to List<Map<String, Object>> is necessary...
                                outputBillingAddressList = (List<Map<String, Object>>) outputData.get(ccrz.ccAPIAddress.ADDRESSLIST);
                                system.debug('outputAddressList' +outputBillingAddressList);
                                
                                // The cast, again, is necessary...
                                String firstName = (String) outputBillingAddressList[0].get('firstName');
                                String Contact = (String) outputBillingAddressList[0].get('dbuContact');
                                system.debug('Contact>> ' + Contact);
                            }
                        } catch (Exception e) {
                            // Error handling...
                            system.debug(e);
                        }
        system.debug('return' +outputBillingAddressList);
        return outputBillingAddressList;
    }
    @AuraEnabled(cacheable=true)
    public static List<ccrz__E_ContactAddr__c> shippingAddressData(){
        Id loggedInUserID = UserInfo.getUserId();  
        List<ccrz__E_ContactAddr__c>contactAddressData = new List<ccrz__E_ContactAddr__c>();
        List<ccrz__E_ContactAddr__c>shippingAddressData = new List<ccrz__E_ContactAddr__c>();
        Id contLOggedInusrId;
        List<User> contactUsrID = new List<User>();
        contactUsrID = [Select id,ContactID FROM User
                             WHERE id = :loggedInUserID];
        system.debug('contLOggedInusrId' +contactUsrID);
            for(User usr: contactUsrID){
                contLOggedInusrId = usr.ContactID;
            }
        if(loggedInUserID != null){
            contactAddressData = [SELECT id,Name,dbu_Contact__c,ccrz__ShippingComments__c,dbu_Default_Address__c,ccrz__FirstName__c,ccrz__LastName__c,
                                  ccrz__Email__c,ccrz__HomePhone__c,ccrz__AddressFirstline__c,ccrz__AddressSecondline__c,ccrz__City__c,
                                  ccrz__State__c,ccrz__Country__c,ccrz__PostalCode__c,ccrz__CompanyName__c
                                  FROM ccrz__E_ContactAddr__c where dbu_Contact__c =:contLOggedInusrId
                                  AND dbu_Contact__c <> null AND dbu_Default_Address__c = true];
            system.debug('contactAddressData' +contactAddressData);
            if(contactAddressData.size()>0){
                for(ccrz__E_ContactAddr__c shippingConAdd :contactAddressData ){
                    if(shippingConAdd.ccrz__ShippingComments__c == 'Shipping Comments'){
                        shippingAddressData.add(shippingConAdd);
                        system.debug('shippingAddressData' +shippingAddressData);
                    }
                }
            }
        }
        system.debug('shippingAddressData' +shippingAddressData);
        
        return shippingAddressData;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<ccrz__E_ContactAddr__c> billingAddressData(List<String> billingData){
       Id loggedInUserID = UserInfo.getUserId();  
        List<ccrz__E_ContactAddr__c>contactAddressData = new List<ccrz__E_ContactAddr__c>();
        List<ccrz__E_ContactAddr__c>billingAddressData = new List<ccrz__E_ContactAddr__c>();
        Id contLOggedInusrId;
        List<User> contactUsrID = new List<User>();
        contactUsrID = [Select id,ContactID FROM User
                             WHERE id = :loggedInUserID];
        system.debug('contLOggedInusrId' +contactUsrID);
            for(User usr: contactUsrID){
                contLOggedInusrId = usr.ContactID;
            }
        if(loggedInUserID != null){
            contactAddressData = [SELECT id,Name,dbu_Contact__c,ccrz__ShippingComments__c,dbu_Default_Address__c,ccrz__FirstName__c,ccrz__LastName__c,
                                  ccrz__Email__c,ccrz__HomePhone__c,ccrz__AddressFirstline__c,ccrz__AddressSecondline__c,ccrz__City__c,
                                  ccrz__State__c,ccrz__Country__c,ccrz__PostalCode__c,ccrz__CompanyName__c
                                  FROM ccrz__E_ContactAddr__c where dbu_Contact__c =:contLOggedInusrId
                                  AND dbu_Contact__c <> null AND dbu_Default_Address__c = true];
            system.debug('contactAddressData' +contactAddressData);
            if(contactAddressData.size()>0){
                for(ccrz__E_ContactAddr__c billingConAdd :contactAddressData ){
                    if(billingConAdd.ccrz__ShippingComments__c == 'Billing Comments'){
                        billingAddressData.add(billingConAdd);
                        system.debug('shippingAddressData' +billingAddressData);
                    }
                }
            }
        }
        system.debug('shippingAddressData' +billingAddressData);
        
        return billingAddressData;
    }
    
    @Auraenabled(Cacheable = true)
    public static ID getContactIDFrLoginUsr(){
        String contLoggedInusrId ;
        List<User> contactUsrID = new List<User>();
        
        Id loggedInUserID = UserInfo.getUserId();
        if(loggedInUserID != null){
        contactUsrID = [Select id,ContactID FROM User
                             WHERE id = :loggedInUserID];
        
            system.debug('userID' +loggedInUserID);
            system.debug('conta' +contactUsrID);
            for(User usr :contactUsrID){
                system.debug('data' +usr.ContactID);
                contLoggedInusrId = String.valueof(usr.ContactID);
                system.debug('contLOggedInusrId' +contLoggedInusrId);
            }
        }
        return contLoggedInusrId;
    }
    
    
}