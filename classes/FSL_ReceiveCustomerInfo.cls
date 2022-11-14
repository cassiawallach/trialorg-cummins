/*********************************************************************************************************************************
Name:FSL_ReceiveCustomerInfo
Copyright © 2019  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:
This is the integration api expose class for Customer details from MOVEX.
===================================================================================================================================
===================================================================================================================================
History
-------
VERSION     AUTHOR                  DATE                                DETAIL
1.0 -       PiyushR                 02/10/2019                          INITIAL DEVELOPMENT
1.1         Sriprada Sesham         01/13/2020                          Updated logic for BMS, MOVEX-UK
1.2         Sunitha Mattaparthi     11/30/2020                          Added Custom Metadata Settings for EU 
1.3         Surender Madipeddi      11/12/2021                          Added US Postal Code2 logic for BMS
******************************************************************************************************************************************/

@RestResource(urlMapping='/CustomerData/*')
global class FSL_ReceiveCustomerInfo {
    
    @HttpPost
    global static void doPostOperation() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;   
        system.debug(':::Request ***'+req);
        string str = FSL_ReceiveCustomerInfo.handleCustomerRequest(req);
        system.debug(':::STR***'+str);
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(str);  
        system.debug(':::str***'+str);    
    }
    
    
   @HttpPatch
    global static ResponseDataAreaWrapper doPatchOperation() {
       RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;   
        system.debug(':::Request ***'+req);
        ResponseDataAreaWrapper rw = new ResponseDataAreaWrapper();
        rw  = FSL_ReceiveCustomerInfo.handleUpdateCustomerRequest(req);
        /*system.debug(':::STR***'+str);
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(str);  
        system.debug(':::str***'+str);*/ 
       
       return rw;  
    }
    
    public static string handleCustomerRequest(RestRequest req) {
        String results = '{"DataArea": [';
        system.debug('req***'+req);
        List<account> accForInsert = new List<account>(); 
        List<account> accForUpdate = new List<account>();
        Map<string,FSL_CustomerInfoWrapper.DataArea> accNULLWrapperMap = new Map<string,FSL_CustomerInfoWrapper.DataArea>();
        Integer nullCounter = 0;
        Integer blankStatusCounter = 0;
        List<Account> accListForDML;
        string jSONRequestBody = req.requestBody.toString().trim();
        string senderID;
        
        try { 
            FSL_CustomerInfoWrapper obj = new FSL_CustomerInfoWrapper();
            obj = (FSL_CustomerInfoWrapper) System.JSON.deserialize(jSONRequestBody, FSL_CustomerInfoWrapper.class); 
            senderID = obj.Header.Sender.SenderID.toUpperCase();
            system.debug('Sender ID:'+senderID);
            system.debug(':: Deserialized Obj*** - '+obj);
            system.debug('Request:'+jSONRequestBody);
            Map<string,FSL_CustomerInfoWrapper.DataArea> accUpdateWrap = new Map<string,FSL_CustomerInfoWrapper.DataArea>();
            Map<string,FSL_CustomerInfoWrapper.DataArea> accWrapperMap = new Map<string,FSL_CustomerInfoWrapper.DataArea>();
            Map<String, Account> codeCustomerMap = new Map<String, Account>();
            Map<string,string> stateMap = new Map<string,string>();
            Map<string,string> countryMap = new Map<string,string>();
               //CT3-245
            Map<String,String> mapCountryEU = new Map<String,String>(); 
            List<FSL_ERP_Country_Translation__mdt> lstCountryMapping=[SELECT MasterLabel,Country__c 
                                                                      FROM FSL_ERP_Country_Translation__mdt];
            for(FSL_ERP_Country_Translation__mdt countryMapping:lstCountryMapping){
                mapCountryEU.put(countryMapping.MasterLabel,countryMapping.Country__c);
                
            } 

            Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
            Id GuidanzCashRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Guidanz_Cash').getRecordTypeId();
            
            List<FSL_Communication_Language__mdt> custLangList = [SELECT Id,Language_Code__c,Language__c FROM FSL_Communication_Language__mdt];
            Map<String,String> langPrefMap = new Map<String,String>();
            if(!custLangList.isEmpty()){
                for(FSL_Communication_Language__mdt custData : custLangList){
                    langPrefMap.put(custData.Language_Code__c,custData.Language__c );
                }
            }
            
            String custCountry;
            String custState;
            system.debug('obj.DataArea***'+obj.DataArea);
            List<CSS_CountryStateValues__c> stateCountryValues = new List<CSS_CountryStateValues__c>();

            for(FSL_CustomerInfoWrapper.DataArea  dtAr: obj.DataArea) {
                system.debug('dtAr.EventFlag**'+dtAr.EventFlag);
                System.debug('::: dtAr.CustomerCode *** '+dtAr.CustomerCode+' & dtAr.ERP_Status - '+dtAr.ERP_Status);
                if(String.isNotBlank(dtAr.CustomerCode) && String.isNotBlank(dtAr.ERP_Status)) {
                    accWrapperMap.put(dtAr.CustomerCode , dtAr);
                } else if(String.isBlank(dtAr.CustomerCode)){
                    nullCounter+=1;
                } else if(String.isBlank(dtAr.ERP_Status)) {
                    blankStatusCounter+=1;
                }
            }
            stateCountryValues  = [select CountryCode__c,CountryName__c,StateCode__c,StateName__c from CSS_CountryStateValues__c];

            for(CSS_CountryStateValues__c csValues : stateCountryValues){
                stateMap.put(csValues.CountryCode__c+' '+csValues.StateCode__c,csValues.StateName__c);
                countryMap.put(csValues.CountryCode__c, csValues.CountryName__c);
            }
            System.debug('::: accWrapperMap - '+accWrapperMap);
            System.debug('::: nullCounter = '+nullCounter+' and blankStatusCounter = '+blankStatusCounter);
            accListForDML = new List<Account>();
            System.debug('::: Accounts - '+[SELECT Id, FSL_ERP_Customer_Code__c FROM Account WHERE FSL_ERP_Customer_Code__c =: accWrapperMap.keySet()]);
            for(Account acnt : [SELECT Id, FSL_ERP_Customer_Code__c, FSL_Source_ERP__c , National_Account__c , National_Account_Message__c
                                FROM Account WHERE FSL_ERP_Customer_Code__c =: accWrapperMap.keySet()
                                AND(RecordTypeId=:recTypeId OR RecordTypeId=:GuidanzCashRecTypeId)
                               ]) 
            {
                System.debug('::: Acc Record - '+acnt);
                FSL_CustomerInfoWrapper.DataArea dtAr = accWrapperMap.get(acnt.FSL_ERP_Customer_Code__c);
                
                System.debug('::: dtAr - '+dtAr);
                System.debug('::: dtAr ERP_Status - '+dtAr.ERP_Status);
                if(dtAr != null){
                    
                   /* if(dtAr.Country == 'Great Britain') {
                        custCountry = 'United Kingdom';
                        custState = dtAr.State;
                    } else if(dtAr.Country == 'Eire') {
                        custCountry = 'Ireland';
                        custState = dtAr.State;
                    }*/
                    //CT3-245
                    //{Eire=Ireland, Great Britain=United Kingdom}                 
                    
                    if(senderID == 'BMS') {
                        custCountry =  countryMap.get(dtAr.Country);
                        //FSL_utility.getCountryDesc(dtAr.Country);
                        custState =   stateMap.get(dtAr.Country+' '+dtAr.State);
                        //FSL_utility.getStateDesc(dtAr.Country,dtAr.State);
                        system.debug('Country:'+custCountry);
                        system.debug('State:'+custState);
                    }
                    else if(mapCountryEU.containsKey(dtAr.Country)){
                        custCountry=mapCountryEU.get(dtAr.Country);
                        custState = dtAr.State;
                        system.debug('country::'+ custCountry );
                        system.debug('state::'+custState);
                    }                    
                    else {
                        custCountry = dtAr.Country;
                        custState = dtAr.State;
                        system.debug('Country:'+custCountry);
                        system.debug('State:'+custState);
                    }
                    
                    Account acc = new Account();
                    if(dtAr.ERP_Status.equalsIgnoreCase('Active')) {
                        System.debug('::: Active ERP_Status');
                        acc.Id = acnt.Id;
                        // Tax District Added By Harsha
                        // acc.FSL_Tax_District__c = dtAr.TaxDistrict;//This is applicable only for Guidanz to BMS -- Sriprada
                        acc.FSL_ERP_Customer_Code__c = dtAr.CustomerCode;
                        acc.BillingStreet = dtAr.LocationAddressline1 +','+dtAr.LocationAddressline2 +','+dtAr.LocationAddressline3 +','+dtAr.LocationAddressline4;
                        acc.BillingCity = dtAr.City;
                        acc.BillingState = custState;
                        acc.BillingCountry = custCountry;
                        acc.BillingPostalCode = dtAr.Postalcode1;
                        //FBI-85 changes to update both Postal code1 & Postal code2 in Guidanz for US only
                        if(senderID == 'BMS' && (custCountry=='United States' || dtAr.Country=='US') 
                           && dtAr.Postalcode2 !=null && dtAr.Postalcode2.trim() !='' && dtAr.Postalcode2.trim().length() ==4){
                            acc.BillingPostalCode = dtAr.Postalcode1+'-'+dtAr.Postalcode2;
                        }
                        acc.Name = dtAr.CustomerName;
                        acc.Phone = dtAr.AreaCode + dtAr.PhoneNumber;
                        acc.PaymentType__c = dtAr.PaymentType;
                        if(senderID == 'BMS'){
                            acc.Is_Internal_Account__c = Boolean.valueof(dtAr.InternalCustomer);
                            acc.Language_Preference__c = langPrefMap.get(dtAr.LanguagePreference);
                            acc.National_Account__c = dtAr.NationalAccount;//CT4-198
                            acc.National_Account_Message__c= dtAr.NationalAccountMessage;//CT4-198
                    	}
                        acc.FSL_Payer_Code__c = (dtAr.PayerDetails).size() > 0 ? dtAr.PayerDetails[0].PayerAccountCode:null;
                        acc.FSL_Payer_Name__c = (dtAr.PayerDetails).size() > 0 ? dtAr.PayerDetails[0].PayerContactName:null;
                        acc.CMI_Account_Status__c = dtAr.ERP_Status;
                        acc.BMSAvailableCredit__c = (dtAr.AvailableCredit != '' && dtAr.AvailableCredit != null) ? decimal.valueOf(dtAr.AvailableCredit) : null;
                        acc.FSL_Amount_Due__c = (dtAr.AmountDue != '' && dtAr.AmountDue != null) ? decimal.valueOf(dtAr.AmountDue) : null;
                        acc.FSL_Credit_Limit__c = (dtAr.CreditLimit != '' && dtAr.CreditLimit != null) ? decimal.valueOf(dtAr.CreditLimit) : null;
                        if(dtAr.Type == '' || dtAr.Type == 'Credit') {
                            acc.RecordTypeId = recTypeId;
                            acc.Type = 'Credit Customer';
                        } else if(dtAr.Type == 'Cash') {
                            acc.RecordTypeId = GuidanzCashRecTypeId;
                            acc.Type = 'Cash Customer';
                        } else {
                            acc.RecordTypeId = recTypeId;
                            acc.Type = 'Credit Customer';
                        }
                        acc.FSL_Source_ERP__c = senderID;
                        if(string.isNotBlank(dtAr.PrimaryMarketSegment)) {
                            acc.FSL_Primary_Market_Segment__c  = dtAr.PrimaryMarketSegment;
                        } 
                        accListForDML.add(acc);
                        codeCustomerMap.put(dtAr.CustomerCode, acc);
                        system.debug('Account List:'+accListForDML);
                    } 
                    else if(dtAr.ERP_Status.equalsIgnoreCase('Inactive')) {
                        acc.id = acnt.id;
                        acc.FSL_ERP_Customer_Code__c = dtAr.CustomerCode;
                        acc.BillingStreet = dtAr.LocationAddressline1 +','+dtAr.LocationAddressline2 +','+dtAr.LocationAddressline3 +','+dtAr.LocationAddressline4;
                        acc.BillingCity = dtAr.City;
                        // Tax District Added By Harsha
                        // acc.FSL_Tax_District__c = dtAr.TaxDistrict; // This is applicable only for Guidanz to BMS -- Sriprada
                        acc.BillingState = custState;
                        acc.BillingCountry = custCountry;
                        acc.BillingPostalCode = dtAr.Postalcode1;
                        //FBI-85 changes to update both Postal code1 & Postal code2 in Guidanz for US only
                        if(senderID == 'BMS' && (custCountry=='United States' || dtAr.Country=='US') 
                           && dtAr.Postalcode2 !=null && dtAr.Postalcode2.trim() !='' && dtAr.Postalcode2.trim().length() ==4){
                            acc.BillingPostalCode = dtAr.Postalcode1+'-'+dtAr.Postalcode2;
                        }
                        acc.Name = dtAr.CustomerName;
                        acc.Phone = dtAr.AreaCode + dtAr.PhoneNumber;
                        acc.PaymentType__c = dtAr.PaymentType;
                        if(senderID == 'BMS'){
                            acc.Is_Internal_Account__c = Boolean.valueof(dtAr.InternalCustomer);
                            acc.Language_Preference__c = langPrefMap.get(dtAr.LanguagePreference);
                            acc.National_Account__c = dtAr.NationalAccount;//CT4-198
                            acc.National_Account_Message__c= dtAr.NationalAccountMessage;//CT4-198
                    	}
                        acc.FSL_Payer_Code__c = (dtAr.PayerDetails).size() >0 ? dtAr.PayerDetails[0].PayerAccountCode:null;
                        acc.FSL_Payer_Name__c = (dtAr.PayerDetails).size() >0 ? dtAr.PayerDetails[0].PayerContactName:null;
                        acc.CMI_Account_Status__c = dtAr.ERP_Status;
                        acc.BMSAvailableCredit__c = (dtAr.AvailableCredit != '' && dtAr.AvailableCredit != null) ? decimal.valueOf(dtAr.AvailableCredit) : null;
                        acc.FSL_Amount_Due__c = (dtAr.AmountDue != '' && dtAr.AmountDue != null) ? decimal.valueOf(dtAr.AmountDue) : null;
                        acc.FSL_Credit_Limit__c = (dtAr.CreditLimit != '' && dtAr.CreditLimit != null) ? decimal.valueOf(dtAr.CreditLimit) : null;
                        if(dtAr.Type == '' || dtAr.Type == 'Credit') {
                            acc.RecordTypeId = recTypeId;
                            acc.Type = 'Credit Customer';
                        } else if(dtAr.Type == 'Cash') {
                            acc.RecordTypeId = GuidanzCashRecTypeId;
                            acc.Type = 'Cash Customer';
                        } else {
                            acc.RecordTypeId = recTypeId;
                            acc.Type = 'Credit Customer';
                        }
                        acc.FSL_Source_ERP__c = senderID;
                        if(string.isNotBlank(dtAr.PrimaryMarketSegment)) {
                            acc.FSL_Primary_Market_Segment__c  = dtAr.PrimaryMarketSegment;
                        } 
                        accListForDML.add(acc);
                        codeCustomerMap.put(dtAr.CustomerCode, acc);
                        system.debug('Account List:'+accListForDML);
                    }
                }
            }
            System.debug('::: codeCustomerMap - '+codeCustomerMap);
            
            for(FSL_CustomerInfoWrapper.DataArea  dtAr: obj.DataArea) {
                system.debug('::: dtAr.EventFlag**CustomerCode'+dtAr.EventFlag+'**'+dtAr.CustomerCode+' Customer Code Contains = '+codeCustomerMap.containsKey(dtAr.CustomerCode) );
                if(!codeCustomerMap.containsKey(dtAr.CustomerCode) && String.isNotBlank(dtAr.CustomerCode) && String.isNotBlank(dtAr.ERP_Status)){ 
                    
                  Account acc = new Account();
                    
                   /* if(senderID == 'MOVEX-UK'||senderID=='MOVEX-190') {                     
                      /* if(dtAr.Country == 'Great Britain') {
                            custCountry = 'United Kingdom';
                            custState = dtAr.State;
                        } else if(dtAr.Country == 'Eire') {
                            custCountry = 'Ireland';
                            custState = dtAr.State;
                        }
                    }*/
                    //CT3-245({Eire=Ireland, Great Britain=United Kingdom})
                    
                     if(senderID == 'BMS') {
                        custCountry =  countryMap.get(dtAr.Country);
                        //FSL_utility.getCountryDesc(dtAr.Country);
                        custState =   stateMap.get(dtAr.Country+' '+dtAr.State);
                        //FSL_utility.getStateDesc(dtAr.Country,dtAr.State);
                        system.debug('Country:'+custCountry);
                        system.debug('State:'+custState);
                    } 
                    else if(mapCountryEU.containsKey(dtAr.Country)){
                        custCountry=mapCountryEU.get(dtAr.Country);
                        custState = dtAr.State;
                        system.debug('country1::'+custCountry);
                        system.debug('state1::'+custState);
                    }             
                    else {
                        custCountry = dtAr.Country;
                        custState = dtAr.State;
                        system.debug('Country:'+custCountry);
                        system.debug('State:'+custState);
                    }
                    
                    acc.FSL_ERP_Customer_Code__c = dtAr.CustomerCode;
                    acc.BillingStreet = dtAr.LocationAddressline1 +','+dtAr.LocationAddressline2 +','+dtAr.LocationAddressline3 +','+dtAr.LocationAddressline4 ;
                    acc.BillingCity = dtAr.City;
                    acc.BillingState = custState;
                    // Tax District Added By Harsha
                    //  acc.FSL_Tax_District__c = dtAr.TaxDistrict;//This is applicable only for Guidanz to BMS -- Sriprada
                    acc.BillingCountry = custCountry;
                    acc.Name = dtAr.CustomerName;
                    acc.Phone = dtAr.AreaCode + dtAr.PhoneNumber;
                    acc.BillingPostalCode = dtAr.Postalcode1;
                    //FBI-85 changes to update both Postal code1 & Postal code2 in Guidanz for US only
                    if(senderID == 'BMS' && (custCountry=='United States' || dtAr.Country=='US') 
                       && dtAr.Postalcode2 !=null && dtAr.Postalcode2.trim() !='' && dtAr.Postalcode2.trim().length() ==4){
                           acc.BillingPostalCode = dtAr.Postalcode1+'-'+dtAr.Postalcode2;
                    }
                    acc.PaymentType__c = dtAr.PaymentType;
                    if(senderID == 'BMS'){
                        acc.Is_Internal_Account__c = Boolean.valueof(dtAr.InternalCustomer);
                        acc.Language_Preference__c = langPrefMap.get(dtAr.LanguagePreference);
                        acc.National_Account__c = dtAr.NationalAccount;//CT4-198
                        acc.National_Account_Message__c= dtAr.NationalAccountMessage;//CT4-198
                    }
                    acc.BMSAvailableCredit__c = (dtAr.AvailableCredit != '' && dtAr.AvailableCredit != null) ? decimal.valueOf(dtAr.AvailableCredit) : null;
                    acc.FSL_Amount_Due__c = (dtAr.AmountDue != '' && dtAr.AmountDue != null) ? decimal.valueOf(dtAr.AmountDue) : null;
                    acc.FSL_Credit_Limit__c = (dtAr.CreditLimit != '' && dtAr.CreditLimit != null) ? decimal.valueOf(dtAr.CreditLimit) : null;
                    acc.FSL_Payer_Code__c = (dtAr.PayerDetails).size() > 0 ? dtAr.PayerDetails[0].PayerAccountCode : null;
                    acc.FSL_Payer_Name__c = (dtAr.PayerDetails).size() > 0 ? dtAr.PayerDetails[0].PayerContactName : null;
                    acc.CMI_Account_Status__c = dtAr.ERP_Status;
                    
                    if(string.isNotBlank(dtAr.PrimaryMarketSegment)) {
                        acc.FSL_Primary_Market_Segment__c = dtAr.PrimaryMarketSegment;
                    } 
                    if(dtAr.Type == '' || dtAr.Type == 'Credit') {
                        acc.RecordTypeId = recTypeId;
                        acc.Type = 'Credit Customer';
                    } else if(dtAr.Type == 'Cash') {
                        acc.RecordTypeId = GuidanzCashRecTypeId;
                        acc.Type = 'Cash Customer';
                    } else {
                        acc.RecordTypeId = recTypeId;
                        acc.Type = 'Credit Customer';
                    }
                    acc.FSL_Source_ERP__c = senderID;
                    accListForDML.add(acc);
                } 
            }
            
            System.debug('::: accListForDML - '+accListForDML);
            
            if(!accListForDML.isEmpty()) {
                Database.UpsertResult[] srList = Database.upsert(accListForDML, false);
                for(Integer i=0;i<srList.size();i++){
                    System.debug('::: srList index - '+srList.get(i));
                    if(srList.get(i).isSuccess()) {
                        System.debug('::: srList Success - '+srList.get(i));
                        results += '{"CustomerCode" :"'+ accListForDML.get(i).FSL_ERP_Customer_Code__c ;        
                        results +='","ReturnCodeDescription": "Record Processed Successfully",';
                        results +='"Status": "SUCCESS"},';
                        
                    } else {
                        System.debug('::: srList Failure - '+srList.get(i));
                        String errmsg ;
                        for(Database.Error err : srList.get(i).getErrors()) {
                            errmsg+= err.getMessage();    
                        }
                        results += '{"CustomerCode" :"'+ accListForDML.get(i).FSL_ERP_Customer_Code__c;         
                        results +='","ReturnCodeDescription": "'+errmsg+'",';
                        //results +='"Status": "Error"},';
                        results +='"Status": "Error",';
                        results += '"List" : "'+accListForDML+'"}';
                    }
                }
            }
        } catch(Exception ex) {
            System.debug('::: Execption at line no :: '+ex.getLineNumber()+' Exception Message>>>is:  '+ex.getMessage());
            System.debug('::: Execption Stack :: '+ex.getStackTraceString());
        }
        
        /*if(accListForDML.isEmpty() || nullCounter > 0 || blankStatusCounter>0) {
            //System.debug('::: Last if - '+accNULLWrapperMap.size()+' and Details'+accNULLWrapperMap);
            for(Integer i=0; i<nullCounter; i++) {
                results += '{"CustomerCode" :"'+'Customer Code cannot be blank';              
                results +='","ReturnCodeDescription": "Record not processed",'; 
                results +='"Status": "Error"},';
            }
            for(Integer i=0; i<blankStatusCounter; i++) {
                results += '{"ERP_Status" :"'+'ERP Status cannot be blank';          
                results +='","ReturnCodeDescription": "Record not processed",';
                results +='"Status": "Error"},';
            }
        }*/
        results = results.removeEnd(',');
        results += '],';
        results += '"Header":{"ReturnCodeDescription": "Record Processed Succesfully" ,"Status": "SUCCESS"}}';
        return results;
    }
    
    
    public static ResponseDataAreaWrapper handleUpdateCustomerRequest(RestRequest req) {
        String results = '{"DataArea": [';
        system.debug('req***'+req);
        List<account> accForUpdate = new List<account>();
        Map<string,FSL_CustomerInfoWrapper.DataArea> accNULLWrapperMap = new Map<string,FSL_CustomerInfoWrapper.DataArea>();
        Integer nullCounter = 0;
        Integer blankStatusCounter = 0;
        string jSONRequestBody = req.requestBody.toString().trim();
        string senderID;
        
        ResponseDataAreaWrapper rw = new ResponseDataAreaWrapper();
        List<ResponseDataHeader> ResponseDataHeaderList = new List<ResponseDataHeader>();
        ResponseDataHeader rh = new ResponseDataHeader();
        
        try { 
            FSL_CustomerInfoWrapper obj = new FSL_CustomerInfoWrapper();
            obj = (FSL_CustomerInfoWrapper) System.JSON.deserialize(jSONRequestBody, FSL_CustomerInfoWrapper.class); 
            senderID = obj.Header.Sender.SenderID.toUpperCase();
            system.debug('Sender ID:'+senderID);
            system.debug(':: Deserialized Obj*** - '+obj);
            system.debug('Request:'+jSONRequestBody);
            Map<string,FSL_CustomerInfoWrapper.DataArea> accUpdateWrap = new Map<string,FSL_CustomerInfoWrapper.DataArea>();
            Map<string,FSL_CustomerInfoWrapper.DataArea> accWrapperMap = new Map<string,FSL_CustomerInfoWrapper.DataArea>();
            Map<String, Account> codeCustomerMap = new Map<String, Account>();
            Map<string,string> stateMap = new Map<string,string>();
            Map<string,string> countryMap = new Map<string,string>(); 
            

            
            List<FSL_Communication_Language__mdt> custLangList = [SELECT Id,Language_Code__c,Language__c FROM FSL_Communication_Language__mdt];
            Map<String,String> langPrefMap = new Map<String,String>();
            if(!custLangList.isEmpty()){
                for(FSL_Communication_Language__mdt custData : custLangList){
                    langPrefMap.put(custData.Language_Code__c,custData.Language__c );
                }
            }
            

            for(FSL_CustomerInfoWrapper.DataArea  dtAr: obj.DataArea) {
                system.debug('dtAr.EventFlag**'+dtAr.EventFlag);
                System.debug('::: dtAr.CustomerCode *** '+dtAr.CustomerCode);
                if(String.isNotBlank(dtAr.CustomerCode)) {
                    accWrapperMap.put(dtAr.CustomerCode , dtAr);
                }
            }


            System.debug('::: accWrapperMap - '+accWrapperMap);


            System.debug('::: Accounts - '+[SELECT Id, FSL_ERP_Customer_Code__c FROM Account WHERE FSL_ERP_Customer_Code__c =: accWrapperMap.keySet()]);
            
            for(Account acnt : [SELECT Id, FSL_ERP_Customer_Code__c, FSL_Source_ERP__c, Language_Preference__c , National_Account__c , National_Account_Message__c
                                FROM Account WHERE FSL_ERP_Customer_Code__c =: accWrapperMap.keySet()]) 
            {
                System.debug('::: Acc Record - '+acnt);
                FSL_CustomerInfoWrapper.DataArea dtAr = accWrapperMap.get(acnt.FSL_ERP_Customer_Code__c);
                
                System.debug('::: dtAr - '+dtAr);
                System.debug('::: dtAr ERP_Status - '+dtAr.ERP_Status);
                
                if(dtAr != null) {
                    
                  if(senderID == 'BMS') {
                      
                        Account acc = new Account();
                        System.debug('::: Active ERP_Status');
                        acc.Id = acnt.Id;
                        acc.Language_Preference__c = langPrefMap.get(dtAr.LanguagePreference); 
                        acc.National_Account__c = dtAr.NationalAccount;//CT4-198
                        acc.National_Account_Message__c= dtAr.NationalAccountMessage; //CT4-198                      
                        accForUpdate.add(acc);
                        
                    }
                }
            }
            
            System.debug('::: accForUpdate- '+accForUpdate);
            

            
            rw.Status = 'SUCCESS';
            
            if(!accForUpdate.isEmpty()) {
                Database.UpsertResult[] srList = Database.upsert(accForUpdate, false);
                for(Integer i=0;i<srList.size();i++){
                    System.debug('::: srList index - '+srList.get(i));
                    if(srList.get(i).isSuccess()) {
                    
                        System.debug('::: srList Success - '+srList.get(i));
                        results += '{"CustomerCode" :"'+ accForUpdate.get(i).FSL_ERP_Customer_Code__c ;        
                        results +='","ReturnCodeDescription": "Record Processed Successfully",';
                        results +='"Status": "SUCCESS"},';

                        //rh.AccountID = accForUpdate.get(i).Id;   
                        rh.ReturnCodeDescription = 'Record Processed Succesfully';
                        
                        ResponseDataHeaderList.add(rh);
                         
                        rw.Header = ResponseDataHeaderList;
                        
                        

                        //pass this over REST as response
                        System.debug('rw as wrapper :'+ rw); 
                                    
                    } else {
                        System.debug('::: srList Failure - '+srList.get(i));
                        String errmsg ;
                        for(Database.Error err : srList.get(i).getErrors()) {
                            errmsg+= err.getMessage();    
                        }
                        results += '{"CustomerCode" :"'+ accForUpdate.get(i).FSL_ERP_Customer_Code__c;         
                        results +='","ReturnCodeDescription": "'+errmsg+'",';
                     
                        results +='"Status": "Error",';
                        results += '"List" : "'+accForUpdate+'"}';
                        
                        //rh.AccountID = accForUpdate.get(i).Id;   
                        rh.ReturnCodeDescription = 'Account is not available or Failed with error';
                        
                        ResponseDataHeaderList.add(rh);
                         
                        rw.Header = ResponseDataHeaderList;

                        //pass this over REST as response
                        System.debug('rw as wrapper :'+ rw); 
                    }
                }
            }
        } catch(Exception ex) {
            System.debug('::: Execption at line no :: '+ex.getLineNumber()+' Exception Message>>>is:  '+ex.getMessage());
            System.debug('::: Execption Stack :: '+ex.getStackTraceString());
        }
        
        results = results.removeEnd(',');
        results += '],';
        //results += '"Header":{"ReturnCodeDescription": "Record Processed Succesfully" ,"Status": "SUCCESS"}}';
        return rw;

    }
    
    
    //Response Wrapper    
    global class ResponseDataAreaWrapper {
        String Status;
        List<ResponseDataHeader> Header;
        public void ResponseDataAreaWrapper() {}
    }
    global class ResponseDataHeader {
        //String AccountID;
        String ReturnCodeDescription;
        public void ResponseDataHeader() {}
    } 
      
}