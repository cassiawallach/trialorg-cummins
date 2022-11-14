/********************************************************************************
Name:FSL_CreateCustomer
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  This is the class for Customer Inbound integrtion
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR             DATE               DETAIL                                
v1.0 -   Sriprada Sesham    06/12/2019       INITIAL DEVELOPMENT  
v1.1 -   Sriprada Sesham    07/01/2019       Customer Inbound Integration
v1.2 -   Mani Kumari    02/12/2020     Updated to include TargetID from User
v1.3 -   Harsha Ragam       02/26/2020       Added PrimaryMarketSegment from Account
v1.4 -   Sriprada Sesham    03/02/2020       Updated logic w.r.to MOVEX-UK and BMS ERPs
v1.5 -    Harsha Ragam      09/08/2020      Mule Api Changes for BMS 
v1.6 -    Sunitha M         12/07/2020      Added Custom Metadata Mapping for MOVEX-190&MOVEX-UK
v1.7 -   Harini S           11/06/2021      Updated postal code splitting for BMS ERP.
v1.8     Dinesh Yadav       01/19/2022      Added 'MOVEX-CSP', 'MOVEX-CDK' ERPs to process Cash Customer Payload.
v1.9 -	Rajender Mittapalli	05/31/2022		Migrated token system to named credentials
*********************************************************************************/

public class FSL_CreateCustomer {
    
    public static String Sender = 'CSS';
    public static String TargetERP;
    
    public static CallOutResponseWrap checkCustomerCode(string workOrderID) {
        Account acc = new Account();
        Asset ast = new Asset();
        string jsonReq = '';
        // string jsonReq1 = '';
        string status = 'Account updated';        
        DateTime startTime = System.Now();
        CallOutResponseWrap retWrap = new CallOutResponseWrap();
        
        list<workOrder> listWo = new list<Workorder>();
        listWo = [SELECT Id, WorkOrderNumber, Customer_Name__c,Account.Name,Account.FSL_ERP_Customer_Code__c, Account.FSL_Payer_Code__c, Asset.Name, Service_Model__c, Customer_City__c, 
                  Asset.Cash_Customer_Flag__c, Customer_Postal_Code__c, Customer_Address_Line1__c, Customer_Address_Line2__c, Customer_Address_Line3__c, 
                  Customer_Country__c, Account.BillingStreet, Account.BillingState, Account.BillingCity,  Account.BillingCountry,Account.BillingPostalCode, Account.Phone, Asset.Individual__c, Customer_State__c, 
                  Account.BillingStateCode,ServiceTerritory.Location_Code__c, ContactId, Contact.Name, Contact.Phone, Contact.FSL_Contact_Id__c, Cash_Customer_Contact_Phone__c,
                  Account.FSL_Primary_Market_Segment__c,Cash_Customer_Contact_Name__c, Account.CSS_DistributorCode__c, Account.CSS_DBCode__c, Payer__r.FSL_ERP_Customer_Code__c,Account.BillingCountryCode,Payer__r.BillingCountryCode,
                  Payer__c,Payer__r.Name, Payer__r.BillingStreet, Payer__r.BillingState, Payer__r.BillingCity,  Payer__r.BillingCountry, Payer__r.BillingPostalCode, Payer__r.Phone, Payer__r.BillingStateCode, Payer__r.FSL_Primary_Market_Segment__c
                  FROM WorkOrder WHERE id =:workOrderID];
        User usr = new User();
        usr = [SELECT Id, ERP__c  
               FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];
        TargetERP = (String)usr.ERP__c;
        system.debug('TargetID:' + TargetERP);
        //CT3-245
        Map<String,String> mapCountryEU = new Map<String,String>(); 
        List<FSL_ERP_Country_Translation__mdt> lstCountryMapping=[SELECT MasterLabel,Country__c 
                                                                  FROM FSL_ERP_Country_Translation__mdt];
        for(FSL_ERP_Country_Translation__mdt countryMapping:lstCountryMapping){
            mapCountryEU.put(countryMapping.Country__c,countryMapping.MasterLabel);
            
        }
        if(listWo.size() > 0)
        {
            String position = listWo[0].ServiceTerritory.Location_Code__c;
            String subString = position.substringBefore('-');
            String subString2 = position.substringAfter('-').substring(0,5);
            String asst;
            String PrimaryMarketSegment;
            String accCountry = (listWo[0].Account.BillingCountry != null) ? listWo[0].Account.BillingCountry : '';
            String accState = (listWo[0].Account.BillingState != null) ? listWo[0].Account.BillingState : '';
            String accAddress = (listWo[0].Account.BillingStreet != null) ? listWo[0].Account.BillingStreet.replace('\r\n', ', ') : '';
            String phn = listWo[0].Account.Phone;
            String arCode = '';
            String accPhone = '';
            String woNumber;
            String SourceType = System.Label.FSL_Source_Environment_Type;
            if(SourceType == 'GZEVLPRD') {
                woNumber = listWo[0].WorkOrderNumber;
            } else {
                woNumber = SourceType.right(3)+'-'+listWo[0].WorkOrderNumber;
            }
            System.debug('$$$ Acc Phone' + phn);
            if(TargetERP == 'BMS') {
                position = subString + '-' + subString2;
                accCountry = (listWo[0].Account.BillingCountryCode != null) ? listWo[0].Account.BillingCountryCode : '';
                accState = (listWo[0].Account.BillingStateCode != null) ? listWo[0].Account.BillingStateCode : '';
                if(phn != null) {
                    if(phn.length() <= 3) {
                        arCode = phn.substring(0, 3);
                        accPhone = '';
                    }
                    else if(phn.length() > 3 && phn.length() < 10) {
                        arCode = phn.substring(0, 3);
                        accPhone = phn.substring(3, phn.length());
                    }
                    else {
                        arCode = phn.substring(0, 3);
                        accPhone = phn.substring(3, 10);
                    }
                }
                system.debug('LocationID:'+position);
            }
            else {
                accPhone = listWo[0].Account.Phone;
            }
            
            asst = listWo[0].AssetId != null ? listWo[0].Asset.Name : '';
            
            PrimaryMarketSegment = (listWo[0].Account.FSL_Primary_Market_Segment__c != null) 
                ?
                listWo[0].Account.FSL_Primary_Market_Segment__c
                :
            '';
            /*
if(listWo[0].Account.FSL_Primary_Market_Segment__c != null) {
PrimaryMarketSegment = listWo[0].Account.FSL_Primary_Market_Segment__c;
} else {
PrimaryMarketSegment = '';
}
*/
            /*  
if(listWo[0].Account.BillingCountry == 'United Kingdom'){
accCountry = 'Great Britain';

} else if(listWo[0].Account.BillingCountry == 'Ireland'){
accCountry = 'Eire';
}*/
            //{Ireland=Eire, Marshall Islands=Marshall Isles, Moldavia=Moldova, Suriname=Surinam, United Arab Emirates=UAE, United Kingdom=Great Britain}
            if(mapCountryEU.containsKey(listWo[0].Account.BillingCountry)){
                accCountry=mapCountryEU.get(listWo[0].Account.BillingCountry);
                system.debug('accCountry::'+accCountry);
                
                
            }
            
            if(listWo[0].Account.FSL_ERP_Customer_Code__c != null  && (TargetERP == 'MOVEX' || TargetERP == 'MOVEX-CDK' || TargetERP == 'MOVEX-CSP')) {
                // jsonReq = '{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Target":{"TargetID":"MOVEX"},"Location":{"LocationID":"56270-56255"}},"DataArea":{"CustomerName":"MyTestCSS Customer","CustomerAddressline1":"Columbus1","CustomerAddressline2":"Columbus2","CustomerAddressline3":"Columbus3","AreaCode":"812","Phone":"2342344","City":"Columbus","State":"IN","PostalCode":"Anirudh","PostalCodeSuffix":"","CustomerContact":"Test1 Test2","BranchCode":"56270","CountryCode":"CA","Language":"en","Application":"AUTO","CSSJobID":"CSS-00047595","ESN":"","ServiceModelName":""}}';
                jsonReq = '{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"'+Sender+'"},"Target":{"TargetID":"'+TargetERP+'"},"Location":{"LocationID":"'+position+'"}},"DataArea":{"CustomerName":"'+listWo[0].Customer_Name__c+'","CustomerAddressline1":"'+listWo[0].Customer_Address_Line1__c+'","CustomerAddressline2":"'+listWo[0].Customer_Address_Line2__c+'","CustomerAddressline3":"'+listWo[0].Customer_Address_Line3__c +'","AreaCode":"'+listWo[0].Customer_Postal_Code__c+'","Phone":"'+listWo[0].Cash_Customer_Contact_Phone__c+'","City":"'+listWo[0].Customer_City__c+'","State":"'+listWo[0].Customer_State__c+'","PostalCode":"'+listWo[0].Customer_Postal_Code__c+'","PostalCodeSuffix":"","CustomerContact":"'+listWo[0].Cash_Customer_Contact_Name__c+'","BranchCode":"'+subString2+'","CountryCode":"'+listWo[0].Customer_Country__c+'","Language":"en","Application":"AUTO","CSSJobID":"'+woNumber+'","ESN":"'+listWo[0].asset.name+'","ServiceModelName":"'+listWo[0].Service_Model__c+'","IndividualItemNumber":"'+listWo[0].Asset.Individual__c+'","PrimarySegment":""}}';
                // jsonReq = jsonReq.replaceAll('"null"','""');
                // status = updateCustomer(jsonReq,FSL_WS_OAG.getAccessToken(),workOrderID);
                jsonReq = jsonReq.replaceAll('"null"','""');
                system.debug('Request:'+jsonReq);
                retWrap = updateCustomer(jsonReq,workOrderID);
                system.debug('Status:'+status);
                if(retWrap != null  && (retWrap.status == 'ERROR' || retWrap.status == 'FAIL') && !Test.isRunningTest()) {
                    System.debug('entered into FSL_CreateCustomer  error and printing response:'+retWrap); 
                    FSL_ApplicationLogger.insertFSLIntegrationErrorLog(jsonReq,String.valueOf(retWrap),'CreateCustomer','Error',String.valueOf(TargetERP),'toolId','CSS');
                    System.debug('logged FSL_CreateCustomer err'); 
                }
            }
            //Added MOVEX-CSP and MOVEX-CDK to null condition for ROAD-228
            if((listWo[0].AccountId != null ) && (TargetERP != 'MOVEX' && TargetERP != 'MOVEX-CDK' && TargetERP != 'MOVEX-CSP')) {
                // Added By Harini - FBI -77 , Splitting postal code from Guidanz to BMS.
                String postalcode1='';
                String postalcode2='';
                if(listWo[0].Account.BillingPostalCode !=null && listWo[0].Account.BillingPostalCode.contains('-') &&
                   (listWo[0].Account.BillingCountry =='United States' || listWo[0].Account.BillingCountry =='US')){
                       postalcode1 = listWo[0].Account.BillingPostalCode.split('-')[0];
                       postalcode2 = listWo[0].Account.BillingPostalCode.split('-')[1];
                   }else{
                       postalcode1 = listWo[0].Account.BillingPostalCode;
                   }
                jsonReq = '{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"'+Sender+'"},"Target":{"TargetID":"'+TargetERP+'"},"Location":{"LocationID":"'+position+'"}},"DataArea":{"CustomerName":"'+listWo[0].Account.Name+'","CustomerAddressline1":"'+accAddress+'","CustomerAddressline2":"","CustomerAddressline3":"","AreaCode":"'+arCode+'","Phone":"'+accPhone+'","City":"'+listWo[0].Account.BillingCity+'","State":"'+accState+'","PostalCode":"'+postalcode1+'","PostalCodeSuffix":"'+postalcode2+'","CustomerContact":"'+listWo[0].Contact.Name+'","BranchCode":"'+subString2+'","CountryCode":"'+accCountry+'","Language":"en","Application":"AUTO","CSSJobID":"'+woNumber+'","ESN":"'+asst+'","ServiceModelName":"'+listWo[0].Service_Model__c+'","IndividualItemNumber":"'+listWo[0].Asset.Individual__c+'","PrimarySegment":"'+PrimaryMarketSegment.subStringBefore(' ')+'"}}';
                //End of FBI-77
                system.debug('Account Code:'+listWo[0].Account.FSL_ERP_Customer_Code__c);
                system.debug('Account Name:'+listWo[0].Account.Name+' '+subString2);
                jsonReq = jsonReq.replaceAll('"null"','""');
                system.debug('Request:'+jsonReq);
                retWrap = updateAccountCode(jsonReq,workOrderID);
                //status = updateCustomer(jsonReq,FSL_WS_OAG.getAccessToken(),workOrderID);
                if(retWrap != null  &&  string.isNotBlank(retWrap.accObj.FSL_ERP_Customer_Code__c))
                {
                    retWrap.accObj.Id = listWo[0].AccountId;
                }
                system.debug('retWrap FSL_CreateCustomer updateAccountCode:'+retWrap);
                if(retWrap != null  && (retWrap.status == 'ERROR' || retWrap.status == 'FAIL') && !Test.isRunningTest()) {
                    System.debug('entered into FSL_CreateCustomer updateAccountCode  error and printing response:'+retWrap); 
                    FSL_ApplicationLogger.insertFSLIntegrationErrorLog(jsonReq,String.valueOf(retWrap),'CreateCustomer','Error',String.valueOf(TargetERP),'toolId','CSS');
                    System.debug('logged FSL_CreateCustomer err'); 
                }
            }
        }
        
        return retWrap;
        
    }
    //Road-378 Start - Rajender modified token system to NC
    public static CallOutResponseWrap updateCustomer(string jsonReq,string workOrderID) {
        CallOutResponseWrap retWrap = new CallOutResponseWrap();
        system.debug('jsonReq : ' + jsonReq);
        string endPoint;
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper = null;
        try {
            reqWrapper= new FSL_IP_NamedCredentialWrapper();
            reqWrapper.jsonReqBody = jsonReq.replace('null','""');
            reqWrapper.methodType = 'POST';
            reqWrapper.NamedCredential = 'FSL_NC_Customers';
            reqWrapper.Path = '/customer';
            reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
            
            if(Test.isRunningTest() && jsonReq == null)
            {
                throw new CSS_MyException('Exception to cover Catch block'); 
            }
            if(jsonReq != null){
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper); 
            }
            
            string accid = '';
            string response = returnWrapper.response.getBody();
            string returnval;
            system.debug('response>>>>> '+response);
            if(response.contains('"Status":'))
            {
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null)
                {
                    if(parser.getText() == 'Status')
                    {
                        parser.nextToken();
                        retWrap.status = (parser.getText());
                        returnval = (parser.getText());
                    }
                }
            }
            system.debug('returnval>>>> '+returnval);
            if(response.contains('"CustomerCode":'))
            {
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null)
                {
                    if(parser.getText() == 'CustomerCode')
                    {
                        parser.nextToken();
                        accid = (parser.getText());
                    }
                }
            }
            if(response.contains('"ReturnCodeDescription":') && returnval == 'ERROR')
            {
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null)
                {
                    if(parser.getText() == 'ReturnCodeDescription')
                    {
                        parser.nextToken();
                        returnval = (parser.getText());
                        retWrap.msg = (parser.getText());
                    }
                }
            }
            DateTime startTime = System.Now();
            system.debug('retWrap>>>>> '+retWrap);
            return retWrap;
        } catch (Exception e) {
            system.debug('Entered into catch block of updateCustomer method in FSL_CreateCustomer class' + e.getMessage() + ' ' + e.getLineNumber());
            if(returnWrapper == null) {
                returnWrapper = new CG_OP_OAGWrapper();
            }
            return retWrap;
        }
    }
    
    public static CallOutResponseWrap updateAccountCode(string jsonReq,string workOrderID)
    {
        CallOutResponseWrap retWrap = new CallOutResponseWrap();
        system.debug('jsonReq : '+jsonReq);
        string endPoint;
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper = null;
        try {
            reqWrapper= new FSL_IP_NamedCredentialWrapper();
            reqWrapper.jsonReqBody = jsonReq.replace('null','""');
            reqWrapper.methodType = 'POST';
            reqWrapper.NamedCredential = 'FSL_NC_Customers';
            reqWrapper.Path = '/customer';
            reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
            
            if(Test.isRunningTest() && jsonReq == null)
            {
                throw new CSS_MyException('Exception to cover Catch block'); 
            }
            if(jsonReq != null){
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper); 
            }
            
            string accCode = '';
            string response = returnWrapper.response.getBody();
            string returnval;
            system.debug('response>>>>> '+response);
            if(response.contains('"Status":'))
            {
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null)
                {
                    if(parser.getText() == 'Status')
                    {
                        parser.nextToken();
                        retWrap.status = (parser.getText());
                        returnval = (parser.getText());
                    }
                }
            }
            system.debug('returnval>>>> '+returnval);
            if(response.contains('"CustomerCode":'))
            {
                JSONParser parser = JSON.createParser(response);
                
                while (parser.nextToken() != null)
                {
                    if(parser.getText() == 'CustomerCode')
                    {
                        parser.nextToken();
                        accCode = (parser.getText());
                    }
                } 
            }
            if(response.contains('"ReturnCodeDescription":') && (returnval == 'ERROR' || returnval == 'FAIL'))
            {
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null)
                {
                    if(parser.getText() == 'ReturnCodeDescription')
                    {
                        parser.nextToken();
                        retWrap.msg = (parser.getText());
                    }
                }
            }
            Account acc = new Account ();
            acc.FSL_ERP_Customer_Code__c = accCode;
            
            retWrap.accObj = acc;
            system.debug('retWrap>>>>> '+retWrap);
            return retWrap;
        } catch (Exception e) {
            system.debug('Entered into catch block of updateAccountCode method in FSL_CreateCustomer class' + e.getMessage() + ' ' + e.getLineNumber());
            if(returnWrapper == null) {
                returnWrapper = new CG_OP_OAGWrapper();
            }
            return retWrap;
        }
    }
    //Road-378 End - Rajender modified token system to NC
    public static CallOutResponseWrap checkPayerCode(string workOrderID) {
        Account acc = new Account();
        Asset ast = new Asset();
        string jsonReq = '';
        // string jsonReq1 = '';
        string status = 'Account updated';        
        DateTime startTime = System.Now();
        CallOutResponseWrap retWrap1 = new CallOutResponseWrap();
        
        list<workOrder> listWo = new list<Workorder>();
        listWo = [SELECT Id, WorkOrderNumber, Customer_Name__c,Account.Name,Account.FSL_ERP_Customer_Code__c, Account.FSL_Payer_Code__c, Asset.Name, Service_Model__c, Customer_City__c, 
                  Asset.Cash_Customer_Flag__c, Customer_Postal_Code__c, Customer_Address_Line1__c, Customer_Address_Line2__c, Customer_Address_Line3__c, 
                  Customer_Country__c, Account.BillingStreet, Account.BillingState, Account.BillingCity,  Account.BillingCountry,Account.BillingPostalCode, Account.Phone, Asset.Individual__c, Customer_State__c, 
                  Account.BillingStateCode,ServiceTerritory.Location_Code__c, ContactId, Contact.Name, Contact.Phone, Contact.FSL_Contact_Id__c, Cash_Customer_Contact_Phone__c,
                  Account.FSL_Primary_Market_Segment__c,Cash_Customer_Contact_Name__c, Account.CSS_DistributorCode__c, Account.CSS_DBCode__c, Payer__r.FSL_ERP_Customer_Code__c,Account.BillingCountryCode,Payer__r.BillingCountryCode,
                  Payer__c,Payer__r.Name, Payer__r.BillingStreet, Payer__r.BillingState, Payer__r.BillingCity,  Payer__r.BillingCountry, Payer__r.BillingPostalCode, Payer__r.Phone, Payer__r.BillingStateCode, Payer__r.FSL_Primary_Market_Segment__c
                  FROM WorkOrder WHERE id =:workOrderID];
        system.debug('listWo>>>>> '+listWo);
        User usr = new User();
        usr = [SELECT Id, ERP__c  
               FROM User 
               WHERE Id =: UserInfo.getUserId() LIMIT 1];
        TargetERP = (String)usr.ERP__c;
        system.debug('TargetID:' + TargetERP);
        //CT3-245
        Map<String,String> mapCountryEU = new Map<String,String>(); 
        List<FSL_ERP_Country_Translation__mdt> lstCountryMapping=[SELECT MasterLabel,Country__c 
                                                                  FROM FSL_ERP_Country_Translation__mdt];
        for(FSL_ERP_Country_Translation__mdt countryMapping:lstCountryMapping){
            mapCountryEU.put(countryMapping.Country__c,countryMapping.MasterLabel);
            
        }
        
        if(listWo.size() > 0)
        {
            String position = listWo[0].ServiceTerritory.Location_Code__c;
            String subString = position.substringBefore('-');
            String subString2 = position.substringAfter('-').substring(0,5);
            String asst;
            string subPrimaryMarketSegment;
            String payerCountry = (listWo[0].Payer__r.BillingCountry != null) ? listWo[0].Payer__r.BillingCountry : '';
            String payerState = (listWo[0].Payer__r.BillingState != null) ? listWo[0].Payer__r.BillingState : '';
            String payerAddress = (listWo[0].Payer__r.BillingStreet != null) ? listWo[0].Payer__r.BillingStreet.replace('\r\n', ', ') : '';
            String phn = listWo[0].Payer__r.Phone;
            String arCode = '';
            String accPhn = '';
            String woNumber;
            String SourceType= System.Label.FSL_Source_Environment_Type;
            if(SourceType == 'GZEVLPRD') {
                woNumber = listWo[0].WorkOrderNumber;
            } else {
                woNumber = SourceType.right(3)+'-'+listWo[0].WorkOrderNumber;
            }
            system.debug('TargetERP>>>>> '+TargetERP);
            if(TargetERP == 'BMS') {
                position = subString + '-' + subString2;
                payerCountry = (listWo[0].Payer__r.BillingCountryCode != null) ? listWo[0].Payer__r.BillingCountryCode : '';
                payerState = (listWo[0].Payer__r.BillingStateCode != null) ? listWo[0].Payer__r.BillingStateCode : '';
                if(phn != null) {
                    if(phn.length() <= 3) {
                        arCode = phn.substring(0, 3);
                        accPhn = '';
                    }
                    else if(phn.length() > 3 && phn.length() < 10) {
                        arCode = phn.substring(0, 3);
                        accPhn = phn.substring(3, phn.length());
                    }
                    else {
                        arCode = phn.substring(0, 3);
                        accPhn = phn.substring(3, 10);
                    }
                }
                system.debug('LocationID:'+position);
            }
            else {
                accPhn = listWo[0].Payer__r.Phone;
            }
            
            if(listWo[0].AssetId != null) {
                asst = listWo[0].Asset.Name;
            } else {
                asst = '';
            }
            
            if(listWo[0].Payer__r.FSL_Primary_Market_Segment__c != null){
                subPrimaryMarketSegment = listWo[0].Payer__r.FSL_Primary_Market_Segment__c;
            } else {
                subPrimaryMarketSegment = '';
            }
            //{Ireland=Eire, Marshall Islands=Marshall Isles, Moldavia=Moldova, Suriname=Surinam, United Arab Emirates=UAE, United Kingdom=Great Britain}           
            /* if(listWo[0].Payer__r.BillingCountry == 'United Kingdom'){
payerCountry = 'Great Britain';

} else if(listWo[0].Payer__r.BillingCountry == 'Ireland'){
payerCountry = 'Eire';
}*/
            //CT3-245 ({Ireland=Eire, United Kingdom=Great Britain})
            if(mapCountryEU.containsKey(listWo[0].Payer__r.BillingCountry)){
                payerCountry=mapCountryEU.get(listWo[0].Payer__r.BillingCountry);
                
            }
            system.debug('Testing####### '+listWo[0].Payer__c+' '+TargetERP+' '+listWo[0].AccountId);
            try {
                if((listWo[0].Payer__c != null ) && TargetERP != 'MOVEX' && (listWo[0].AccountId != listWo[0].Payer__c)) {
                    jsonReq = '{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"'+Sender+'"},"Target":{"TargetID":"'+TargetERP+'"},"Location":{"LocationID":"'+position+'"}},"DataArea":{"CustomerName":"'+listWo[0].Payer__r.Name+'","CustomerAddressline1":"'+payerAddress+'","CustomerAddressline2":"","CustomerAddressline3":"","AreaCode":"'+arCode+'","Phone":"'+accPhn+'","City":"'+listWo[0].Payer__r.BillingCity+'","State":"'+payerState+'","PostalCode":"'+listWo[0].Payer__r.BillingPostalCode+'","PostalCodeSuffix":"","CustomerContact":"'+listWo[0].Contact.Name+'","BranchCode":"'+subString2+'","CountryCode":"'+payerCountry+'","Language":"en","Application":"AUTO","CSSJobID":"'+woNumber+'","ESN":"'+asst+'","ServiceModelName":"'+listWo[0].Service_Model__c+'","IndividualItemNumber":"'+listWo[0].Asset.Individual__c+'","PrimarySegment":"'+subPrimaryMarketSegment.subStringBefore(' ')+'"}}';
                    system.debug('Account Code:'+listWo[0].Payer__r.FSL_ERP_Customer_Code__c);
                    system.debug('Account Name:'+listWo[0].Payer__r.Name+' '+subString2);
                    jsonReq = jsonReq.replaceAll('"null"','""');
                    system.debug('Request:'+jsonReq);
                    retWrap1 = updatePayerCode(jsonReq,workOrderID);
                    //status = updateCustomer(jsonReq,FSL_WS_OAG.getAccessToken(),workOrderID);
                    if(retWrap1 != null  &&  string.isNotBlank(retWrap1.accObj.FSL_ERP_Customer_Code__c))
                    {
                        retWrap1.accObj.Id = listWo[0].Payer__c;
                    }
                    if(retWrap1 != null  && retWrap1.status == 'ERROR' || retWrap1.status == 'FAIL') {
                        System.debug('entered into FSL_CreateCustomer  error and printing response:'+retWrap1); 
                        FSL_ApplicationLogger.insertFSLIntegrationErrorLog(jsonReq,String.valueOf(retWrap1),'CreateCustomer','Error',String.valueOf(TargetERP),'toolId','CSS');
                        System.debug('logged FSL_CreateCustomer err'); 
                    }
                }
            } catch (Exception e) {
                System.debug('$$$ Exception details ' + e.getMessage() + ' at ' + e.getLineNumber());
            }
        }
        return retWrap1;
    }
    //Road-378 Start - Rajender modified token system to NC
    public static CallOutResponseWrap updatePayerCode(string jsonReq,string workOrderID)
    {
        CallOutResponseWrap retWrap1 = new CallOutResponseWrap();
        system.debug('jsonReq : '+jsonReq);
        string endPoint;
        FSL_IP_NamedCredentialWrapper reqWrapper = null;
        CG_OP_OAGWrapper returnWrapper = null;
        try {
            reqWrapper= new FSL_IP_NamedCredentialWrapper();
            reqWrapper.jsonReqBody = jsonReq.replace('null','""');
            reqWrapper.methodType = 'POST';
            reqWrapper.NamedCredential = 'FSL_NC_Customers';
            reqWrapper.Path = '/customer';
            reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
            
            if(Test.isRunningTest() && jsonReq == null)
            {
                throw new CSS_MyException('Exception to cover Catch block'); 
            }
            if(jsonReq != null){
                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper); 
            }
            
            string accCode = '';
            string response = returnWrapper.response.getBody();
            string returnval;
            system.debug('response>>>>> '+response);
            if(response.contains('"Status":'))
            {
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null)
                {
                    if(parser.getText() == 'Status')
                    {
                        parser.nextToken();
                        retWrap1.status = (parser.getText());
                        returnval = (parser.getText());
                    }
                }
            }
            system.debug('returnval>>>> '+returnval);
            if(response.contains('"CustomerCode":'))
            {
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null)
                {
                    if(parser.getText() == 'CustomerCode')
                    {
                        parser.nextToken();
                        accCode = (parser.getText());
                    }
                } 
            }
            if(response.contains('"ReturnCodeDescription":') && (returnval == 'ERROR' || returnval == 'FAIL'))
            {
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null)
                {
                    if(parser.getText() == 'ReturnCodeDescription')
                    {
                        parser.nextToken();
                        retWrap1.msg = (parser.getText());
                    }
                }
            }
            Account acc = new Account ();
            acc.FSL_ERP_Customer_Code__c = accCode;
            
            retWrap1.accObj = acc;
            system.debug('retWrap1>>>>> '+retWrap1);
            return retWrap1;
        } catch (Exception e) {
            system.debug('Entered into catch block of updatePayerCode method in FSL_CreateCustomer class' + e.getMessage() + ' ' + e.getLineNumber());
            if(returnWrapper == null) {
                returnWrapper = new CG_OP_OAGWrapper();
            }
            return retWrap1;
        }
    }
    //Road-378 End - Rajender modified token system to NC
    public class CallOutResponseWrap {
        Public Account accObj;
        Public string status;
        Public string msg;
        Public string CustomerCode;
    }
    
}