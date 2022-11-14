/*********************************************************************************************************************************
Name: FSL_receiveSiteInfo
Copyright © 2019  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the integration api expose class for Site details from MOVEX,BMS and MOVEX-UK.
===================================================================================================================================
===================================================================================================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE                 DETAIL                                
1.0       Sriprada Sesham          02/16/2019           INITIAL DEVELOPMENT 
1.1       Sriprada Sesham           01/13/2020          Updated logic for BMS, MOVEX-UK
1.2       Sunitha Mattaparthi     12/02/2020            Added Custome Metadata Settings for EU
***********************************************************************************************************************************/

@RestResource(urlMapping='/site/*')
global class FSL_receiveSiteInfo {
    @HttpPost
    global static void doPostOperation()
    {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;      
        string str = FSL_receiveSiteInfo.handleSiteRequest(req);
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(str);
        // str = 'connected!';         
    }
    public static string strCntry{get;set;}
    public static string strCntryState{get;set;}
    
    public static string handleSiteRequest(RestRequest req)
    {    
        string msg;
        list<FSL_SiteDataWrapper.DataResponse> listResponses = new list<FSL_SiteDataWrapper.DataResponse>();
        
        string jSONRequestBody = req.requestBody.toString().trim();
        system.debug('JSON Request:'+jSONRequestBody);
        String senderID;
        try{ 
            FSL_SiteDataWrapper obj = new FSL_SiteDataWrapper();
            obj = (FSL_SiteDataWrapper) System.JSON.deserialize(jSONRequestBody, FSL_SiteDataWrapper.class); 
            senderID = obj.Header.Sender.SenderID;  
            system.debug('Sender ID:'+senderID);
            system.debug('Response:'+obj);
            listResponses = responseHandler(obj);
            system.debug('Response:'+listResponses);
            //msg = '{"ReturnCode":"200","ReturnCodeDescription":"Records processed successfully"}';
            msg =  '{"DataArea": '+json.serialize(listResponses)+',"Header":{"ReturnCodeDescription": "Record Processed Succesfully" ,"Status": "SUCCESS"}}';
            
        } 
        catch(Exception ex)
        {
            System.debug('Execption at line no :: '+ex.getLineNumber()+' Exception Message>>>is:  '+ex.getMessage());
            //msg = '{"ReturnCode":"401","ReturnCodeDescription":"'+ex.getMessage()+'"}'; 
            msg =  '{"DataArea": '+json.serialize(listResponses)+',"Header":{"ReturnCodeDescription": "'+ex.getMessage() +' At line: '+ex.getLineNumber()+',"Status": "error"}}';
        }
        //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.requestBody.toString(), listResponses[0].tostring(),NULL,NULL,'FSL_receiveSiteInfo',Null,'code','toolid','Guidanz',Null,'FSL_receiveSiteInfo')); 
        return msg;
    }
    
    //handler method for storing the site data
    public static list<FSL_SiteDataWrapper.DataResponse> responseHandler(FSL_SiteDataWrapper obj)
    {
        list<FSL_SiteDataWrapper.DataResponse> listResponses = new list<FSL_SiteDataWrapper.DataResponse>();
        
        if(obj != null && obj.DataArea.size()>0 )
        {
            list<Schema.Address> existingacclist = new list<Schema.Address>();
            list<Schema.Address> listUpdateSite = new list<Schema.Address>();
            map<string,Account> mapAccount = new map<string,Account>();
            map<string,string> mapSiteIdError = new map<string,string>();
            map<string,string> mapSiteIdCustomerCode = new map<string,string>();
            map<string,string> mapAccSiteId  = new map<string,string>();
            Map<string,FSL_SiteDataWrapper.DataAreaVal> accWrapperMap = new Map<string,FSL_SiteDataWrapper.DataAreaVal>();
            map<string,Schema.Address> mapCustomerCodeSiteId = new map<string,Schema.Address>();
            Map<string,string> mapAccID = new Map<string,string>();
            Map<string,string> NewMapAccID = new Map<string,string>();
            Map<string,string> stateMap = new Map<string,string>();
            Map<string,string> countryMap = new Map<string,string>();       
            
            Set<string> AccIds = new set<string>();
            Set<String> accSiteIds = new set<String>();
            
            integer blankSiteIdCount = 0;
            string siteCountry;
            string siteState;
            list<Account> parentacclist = new list<Account>();
            //map<string,IAM_CDH_Cross_references__c> mapSiteID = new map<string,IAM_CDH_Cross_references__c>();
            list<Schema.Address> acclist = new list<Schema.Address>();
            list<Schema.Location> loclist = new list<Schema.Location>();
            List<CSS_CountryStateValues__c> stateCountryValues = new List<CSS_CountryStateValues__c>();
             //CT3-245
            Map<String,String> mapCountryEU = new Map<String,String>(); 
           List<FSL_ERP_Country_Translation__mdt> lstCountryMapping=[SELECT MasterLabel,Country__c 
                                                       FROM FSL_ERP_Country_Translation__mdt];
            for(FSL_ERP_Country_Translation__mdt countryMapping:lstCountryMapping){
                mapCountryEU.put(countryMapping.MasterLabel,countryMapping.Country__c);
                
            }

            for(FSL_SiteDataWrapper.DataAreaVal  dtAr: obj.DataArea){
                if(String.isNotBlank(dtAr.SiteID) ) {
                    accWrapperMap.put(dtAr.SiteID , dtAr);
                }
                 if(string.isNotBlank(dtAr.CustomerCode))
                {
                    AccIds.add(dtAr.CustomerCode);  
                    system.debug('Customer Code:'+AccIds);
                }
            }
            
            parentacclist = [select id,name, FSL_Source_ERP__c,FSL_ERP_Customer_Code__c, (select id,name,FSL_Contact_Id__c, IAM_Contact_source__c from contacts) from Account where FSL_ERP_Customer_Code__c In: AccIds];
            stateCountryValues  = [select CountryCode__c,CountryName__c,StateCode__c,StateName__c from CSS_CountryStateValues__c];
            system.debug('Site List:'+parentacclist);
            for(CSS_CountryStateValues__c csValues : stateCountryValues){
                stateMap.put(csValues.CountryCode__c+' '+csValues.StateCode__c,csValues.StateName__c);
                countryMap.put(csValues.CountryCode__c, csValues.CountryName__c);
            }
            for(account acc : parentacclist)
            {
                mapAccount.put(acc.FSL_ERP_Customer_Code__c,acc);
                accSiteIds.add(acc.id);
                system.debug('acc Ids:'+accSiteIds);
                system.debug('MapAccount rec:'+mapAccount);
            }
            if(parentacclist.size()>0)
            {
                for(Schema.Address acnt : [SELECT Id, FSL_Site_ID__c, Status__c, FSL_Site_Name__c, Country, City, Street, State, FSL_Tax_District__c, 
                                    PostalCode, Parent.FSL_Distributor_Code__c, Parent.FSL_Contact_ID__c, 
                                    ParentId, Parent.Name, Parent.FSL_Branch_Code__c, Parent.FSL_Contact_Phone__c, Parent.FSL_Account__c,Parent.FSL_Account__r.FSL_ERP_Customer_Code__c,
                                    Latitude, Geolocation__Latitude__s, Longitude, Geolocation__Longitude__s 
                                    FROM Address WHERE Parent.FSL_Account__c =: accSiteIds  AND FSL_Site_ID__c =: accWrapperMap.keySet()])
                {
                    system.debug('Records:'+acnt.Parent.FSL_Account__c);
                    if(string.isNotBlank(string.valueOf(acnt.FSL_Site_ID__c)))
                    {
                        //mapSiteID.put(string.valueOf(acnt.FSL_MoveX_Site_Id__c),acnt); 
                        mapCustomerCodeSiteId.put(acnt.Parent.FSL_Account__r.FSL_ERP_Customer_Code__c+'#'+acnt.FSL_Site_ID__c,acnt);
                        existingacclist.add(acnt);
                        mapAccSiteId.put(acnt.Parent.FSL_Account__r.FSL_ERP_Customer_Code__c+'#'+acnt.FSL_Site_ID__c,acnt.FSL_Site_ID__c);
                        mapAccID.put(acnt.Id,acnt.Parent.FSL_Account__r.FSL_ERP_Customer_Code__c);
                        system.debug('Existing Site Records***:'+mapCustomerCodeSiteId);
                        system.debug('Existing Account with SiteID:'+mapAccSiteId);
                        system.debug('Existing Account IDs:'+mapAccID);
                    }
                    
                }                
            }
            
            for(integer i=0;i<obj.DataArea.size();i++)
            {
                if(string.isNotBlank(obj.DataArea[i].SiteID.trim()))
                {
                    
                 /*  if(obj.DataArea[i].Country == 'Great Britain'){
                        siteCountry = 'United Kingdom';
                        siteState = obj.DataArea[i].State;
                    }
                    else if(obj.DataArea[i].Country == 'Eire'){
                        siteCountry = 'Ireland';
                        siteState = obj.DataArea[i].State;
                        system.debug('Country:'+siteCountry);
                    } */             
                   
                    if(obj.Header.Sender.SenderID == 'BMS'){
                        if(obj.DataArea[i].Country != ''){
                            siteCountry = countryMap.get(obj.DataArea[i].Country);
                        }else{
                            siteCountry = '';
                            system.debug('Country:'+siteCountry);
                        }
                        if(obj.DataArea[i].State != '' && obj.DataArea[i].Country != ''){
                            siteState = stateMap.get(obj.DataArea[i].Country+' '+obj.DataArea[i].State);
                        }else{
                            siteState = '';
                            system.debug('State:'+siteState);
                        }
                        system.debug('Country:'+siteCountry);
                        system.debug('State:'+siteState);
                    }  
                    //{Eire=Ireland, Great Britain=United Kingdom}
                    else if(mapCountryEU.containsKey(obj.DataArea[i].Country)){
                        siteCountry=mapCountryEU.get(obj.DataArea[i].Country);
                        siteState = obj.DataArea[i].State;
                        system.debug('Country:'+siteCountry);
                        system.debug('siteState:'+siteState);
                    }
                    else if(mapCountryEU.containsKey(obj.DataArea[i].Country)){
                        siteCountry=mapCountryEU.get(obj.DataArea[i].Country);
                        siteState = obj.DataArea[i].State;
                        system.debug('Country:'+siteCountry);
                        system.debug('siteState:'+siteState);
                    }
                    else{
                        siteCountry = obj.DataArea[i].Country;
                        siteState = obj.DataArea[i].State;
                    }
                    
                    Schema.Address acc = new Schema.Address();
                    // Tax District added by Harsha
                    // acc.FSL_Tax_District__c      = obj.DataArea[i].TaxDistrict; //This is applicable only for Guidanz to BMS on creation of new Site -- Sriprada
                    // acc.Contact_Name__c         = obj.DataArea[i].ContactName;
                    //acc.FSL_Address_Line_2__c   = obj.DataArea[i].Address2;
                    //acc.FSL_Address_Line_3__c   = obj.DataArea[i].Address3;
                    // acc.SiteID__c               = Decimal.valueOf(obj.DataArea[i].SiteID);
                    // acc.FSL_ERP_Customer_Code__c = obj.DataArea[i].CustomerCode;
                    acc.FSL_Site_Name__c           = obj.DataArea[i].SiteName;
                    acc.Country                    = siteCountry;
                    acc.State                      = siteState;
                    acc.PostalCode                 = obj.DataArea[i].PostalCode;
                    //FBI-105 changes to update both Postal code1 & Postal code2 in Guidanz for US only
                    if(obj.Header.Sender.SenderID == 'BMS' && (siteCountry=='United States' || obj.DataArea[i].Country=='US') 
                       && obj.DataArea[i].PostalCodeSuffix !=null && obj.DataArea[i].PostalCodeSuffix.trim() !='' 
                       && obj.DataArea[i].PostalCodeSuffix.trim().length()==4){
                        acc.PostalCode             = obj.DataArea[i].PostalCode+'-'+obj.DataArea[i].PostalCodeSuffix;
                    }
                    acc.City                       = obj.DataArea[i].City;    
                    acc.Street                     = obj.DataArea[i].Address1 + ',' + obj.DataArea[i].Address2 + ',' + obj.DataArea[i].Address3;
                    acc.Latitude                   = !String.isEmpty(obj.DataArea[i].Latitude)?Double.valueOf(obj.DataArea[i].Latitude):null;
                    acc.Geolocation__Latitude__s   = !String.isEmpty(obj.DataArea[i].Latitude)?Double.valueOf(obj.DataArea[i].Latitude):null;
                    acc.Longitude                  = !String.isEmpty(obj.DataArea[i].Longitude)?Double.valueOf(obj.DataArea[i].Longitude):null;
                    acc.Geolocation__Longitude__s  = !String.isEmpty(obj.DataArea[i].Longitude)?Double.valueOf(obj.DataArea[i].Longitude):null;

                    Schema.Location loc = new Schema.Location();
                    loc.Name                       = obj.DataArea[i].SiteName;
                    loc.FSL_Distributor_Code__c    = obj.DataArea[i].DistributorCode;
                    loc.FSL_Branch_Code__c         = obj.DataArea[i].BranchCode;
                    loc.FSL_Contact_Phone__c       = obj.DataArea[i].ContactPhoneNo;
                    loc.FSL_Contact_ID__c          = obj.DataArea[i].ContactId.trim();
                                        
                    if(string.isBlank(obj.DataArea[i].CustomerCode))
                    {
                        mapSiteIdError.put(obj.DataArea[i].SiteID , 'Customer Code Cannot be Blank');
                        mapSiteIdCustomerCode.put(obj.DataArea[i].SiteID,' ');
                        
                    } else
                    {
                        mapSiteIdCustomerCode.put(obj.DataArea[i].SiteID,obj.DataArea[i].CustomerCode);
                        //mapCustomerCodeSiteId.put(acc.FSL_MoveX_Site_Id__c,acc);
                        system.debug('Site Customer Code:'+mapSiteIdCustomerCode);
                    }
                    if(!mapAccount.containsKey(obj.DataArea[i].CustomerCode)){
                        mapSiteIdError.put(obj.DataArea[i].SiteID , 'Customer is not available');
                        
                        system.debug('Error Site:'+mapSiteIdError);
                    } 
                    //else {
                        
                   // }
                    system.debug('Site Update:'+acc.id);
                    if(mapAccSiteId.containskey(obj.DataArea[i].CustomerCode+'#'+obj.DataArea[i].SiteID) && (obj.DataArea[i].EventFlag.toLowerCase() == 'add' || obj.DataArea[i].EventFlag.toLowerCase() == 'update')){
                        acc.id = mapCustomerCodeSiteId.get(obj.DataArea[i].CustomerCode+'#'+obj.DataArea[i].SiteID).Id;
                        acc.FSL_Site_ID__c = obj.DataArea[i].SiteID.trim();
                        loc.id = mapCustomerCodeSiteId.get(obj.DataArea[i].CustomerCode+'#'+obj.DataArea[i].SiteID).ParentId;
                        system.debug('Site AccId:'+acc.Parent.FSL_Account__c);
                        
                        system.debug('Existing Site Rec:'+mapAccSiteId);
                        acc.Status__c   = 'Active';
                        acclist.add(acc);
                        loclist.add(loc);
                       // mapAccID.put(acc.Id,acc.IAM_Account__r.FSL_ERP_Customer_Code__c);
                        system.debug('Existing Site Rec:'+acclist);
                    }
                    
                    system.debug('Request:'+acclist);
                    
                    if(obj.DataArea[i].EventFlag.toLowerCase() == 'delete')
                    {
                        // acc.id = mapCustomerCodeSiteId.get(obj.DataArea[i].CustomerCode+'#'+obj.DataArea[i].SiteID).Id;
                        Schema.Address accDel = new Schema.Address();
                        accDel = mapCustomerCodeSiteId.get(obj.DataArea[i].CustomerCode+'#'+obj.DataArea[i].SiteID);
                        system.debug('Inactive Site:'+accDel);
                        if(mapAccSiteId.containskey(obj.DataArea[i].CustomerCode+'#'+obj.DataArea[i].SiteID))
                        {
                            
                            accDel.Status__c = 'Inactive';
                            acclist.add(accDel);
                            loclist.add(loc);
                            //System.debug('acc final##= '+acc);
                        }else
                        {
                            mapSiteIdError.put(obj.DataArea[i].SiteID , 'No Record Found to delete Site with Id : '+obj.DataArea[i].SiteID);
                        }                  
                    }
                    
                }
                else
                {
                    //Count
                    blankSiteIdCount++;
                }
            }
            for(FSL_SiteDataWrapper.DataAreaVal  dtAr: obj.DataArea){
                if(!mapAccount.containsKey(dtAr.CustomerCode)){
                    mapSiteIdError.put(dtAr.SiteID , 'Customer is not available');
                    system.debug('Error Site:'+mapSiteIdError);
                } 
                if(string.isBlank(dtAr.CustomerCode))
                {
                    mapSiteIdError.put(dtAr.SiteID , 'Customer Code Cannot be Blank');
                    mapSiteIdCustomerCode.put(dtAr.SiteID,' ');
                    
                } else
                {
                    mapSiteIdCustomerCode.put(dtAr.SiteID,dtAr.CustomerCode);
                    system.debug('Site Customer Code:'+mapSiteIdCustomerCode);
                }
                if(mapAccount.containsKey(dtAr.CustomerCode) && !mapAccSiteId.containsKey(dtAr.CustomerCode+'#'+dtAr.SiteID) && !mapCustomerCodeSiteId.containskey(dtAr.SiteID+'#'+dtAr.CustomerCode)  && (dtAr.EventFlag.toLowerCase() == 'add' || dtAr.EventFlag.toLowerCase() == 'update')){ 
                    system.debug('NewSiteRecord***:'+dtAr.SiteID+'-'+dtAr.CustomerCode);
                    system.debug('NewMapValues:::'+mapAccSiteId);
                    Schema.Address siteObj = new Schema.Address();
                    
                    /*if(dtAr.Country == 'Great Britain'){
                        siteCountry = 'United Kingdom';
                        siteState = dtAr.State;
                    }
                    else if(dtAr.Country == 'Eire'){
                        siteCountry = 'Ireland';
                        siteState = dtAr.State;
                        system.debug('Country:'+siteCountry);
                    } */                    
                   if(obj.Header.Sender.SenderID == 'BMS'){
                        if(dtAr.Country != ''){
                            siteCountry = countryMap.get(dtAr.Country);
                            //FSL_utility.getCountryDesc(dtAr.Country);
                        }else{
                            siteCountry = '';
                            system.debug('Country:'+siteCountry);
                        }
                        if(dtAr.State != '' && dtAr.Country != ''){
                            siteState = stateMap.get(dtAr.Country+' '+dtAr.State);
                            //FSL_utility.getStateDesc(dtAr.Country,dtAr.State);
                        }else{
                            siteState = '';
                            system.debug('State:'+siteState);
                        }
                        system.debug('Country:'+siteCountry);
                        system.debug('State:'+siteState);
                    }  //CT3-245 {Eire=Ireland, Great Britain=United Kingdom}
                     else if(mapCountryEU.containsKey(dtAr.Country)){
                        siteCountry=mapCountryEU.get(dtAr.Country);
                        siteState = dtAr.State;
                    }
                    else if(mapCountryEU.containsKey(dtAr.Country)){
                        siteCountry=mapCountryEU.get(dtAr.Country);
                        siteState = dtAr.State;
                    }
                    else{
                        siteCountry = dtAr.Country;
                        siteState = dtAr.State;
                        
                    }
                   
                        siteObj.FSL_Site_Name__c            = dtAr.SiteName;
                        siteObj.Country                     = siteCountry;
                        siteObj.State                       = siteState;
                        siteObj.PostalCode                  = dtAr.PostalCode;
                    	//FBI-105 changes to update both Postal code1 & Postal code2 in Guidanz for US only
                    	if(obj.Header.Sender.SenderID == 'BMS' && (siteCountry=='United States' || dtAr.Country=='US') 
                           && dtAr.PostalCodeSuffix !=null && dtAr.PostalCodeSuffix.trim() !='' 
                           && dtAr.PostalCodeSuffix.trim().length()==4){
                            siteObj.PostalCode              = dtAr.PostalCode+'-'+dtAr.PostalCodeSuffix;
                        }
                        siteObj.City                        = dtAr.City;
                        siteObj.Street                      = dtAr.Address1 + ',' + dtAr.Address2 + ',' + dtAr.Address3;
                        siteObj.FSL_Site_ID__c              = dtAr.SiteID;
                        siteObj.Latitude                    = !String.isEmpty(dtAr.Latitude)?Double.valueOf(dtAr.Latitude):null;
                        siteObj.Geolocation__Latitude__s    = !String.isEmpty(dtAr.Latitude)?Double.valueOf(dtAr.Latitude):null;
                        siteObj.Longitude                   = !String.isEmpty(dtAr.Longitude)?Double.valueOf(dtAr.Longitude):null;
                        siteObj.Geolocation__Longitude__s   = !String.isEmpty(dtAr.Longitude)?Double.valueOf(dtAr.Longitude):null;
                     	siteObj.Account__c                  = mapAccount.get(dtAr.CustomerCode).Id;
                        acclist.add(siteObj);

                        // Tax District added by Harsha
                        // siteObj.FSL_Tax_District__c      = dtAr.TaxDistrict; //This is applicable only for Guidanz to BMS on creation of new Site -- Sriprada
                        // siteObj.Contact_Name__c         = obj.DataArea[i].ContactName;
                        //siteObj.FSL_Address_Line_2__c   = dtAr.Address2;
                        //siteObj.FSL_Address_Line_3__c   = dtAr.Address3;
                        // acc.FSL_ERP_Customer_Code__c = dtAr.CustomerCode;
                        
                        Schema.Location loc = new Schema.Location();
                        loc.Name                    = dtAr.SiteName;
                        loc.FSL_Account__c          = mapAccount.get(dtAr.CustomerCode).Id;
                        loc.FSL_Distributor_Code__c = dtAr.DistributorCode;
                        loc.FSL_Branch_Code__c      = dtAr.BranchCode;
                        loc.FSL_Contact_Phone__c    = dtAr.ContactPhoneNo;
                        loc.FSL_Contact_ID__c       = dtAr.ContactId.trim();
                        loclist.add(loc);
                        
                        NewMapAccID.put(loc.FSL_Account__c,dtAr.CustomerCode);
                        system.debug('SiteUpdatedRecord:::'+existingacclist);
                }
            }
            //  Database.SaveResult[] srList = Database.insert(acclist, false);
            
            // Database.SaveResult[] srListUpdate = Database.update(listUpdateSite, false);
            Database.UpsertResult[] upsertLocationResult = Database.upsert(loclist, false);
            Map<Integer,Schema.Address> addressindexMap = new Map<Integer,Schema.Address>(); 
            for(integer i = 0 ; i<loclist.size() ;i++) {
                Database.UpsertResult sr = upsertLocationResult[i];
                FSL_SiteDataWrapper.DataResponse resObj = new FSL_SiteDataWrapper.DataResponse();
                
                if( mapAccID.get(acclist[i].Id) != null){
                    resObj.CustomerCode = mapAccID.get(acclist[i].Id);
                } else{
                    resObj.CustomerCode = NewMapAccID.get(loclist[i].FSL_Account__c);
                }
                resObj.SiteID = String.valueof(acclist[i].FSL_Site_ID__c);
                
                if(sr.isSuccess()){
                    if(acclist[i].parentId == null && acclist[i].Id == null){
                        acclist[i].parentId = sr.getId();        
                    } 
                    addressindexMap.put(i,acclist[i]);  
                } else{
                    string errMsg = '';
                    for(Database.Error err : sr.getErrors()) 
                    {
                        errMsg += err.getMessage() +',';                             
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());                             
                        system.debug('ErrorMessage:'+errMsg);
                        
                    }
                    resObj.ReturnCodeDescription = errMsg;
                    resObj.Status = 'Error';     
                }
                listResponses.add(resObj);
            }
            Database.UpsertResult[] upsertResult = Database.upsert(addressindexMap.values(), false); 
            
            // Iterate through each returned result
            for(integer i : addressindexMap.keySet())
            {
                Database.UpsertResult sr = upsertResult[i];
                FSL_SiteDataWrapper.DataResponse resObj = listResponses[i];
                system.debug('Account List Size:'+acclist.size());
                
                system.debug('Site AccId:'+mapAccID);
                /*
                if( mapAccID.get(acclist[i].Id) != null){
                    resObj.CustomerCode = mapAccID.get(acclist[i].Id);
                    
                } else{
                    resObj.CustomerCode = NewMapAccID.get(loclist[i].FSL_Account__c);
                    
                }
                resObj.SiteID = String.valueof(acclist[i].FSL_Site_ID__c);
                */
                if(sr.isSuccess())
                {                        
                    resObj.ReturnCodeDescription = 'Record Processed Succesfully';
                    resObj.Status = 'SUCCESS';
                    
                }
                else
                {
                    string errMsg = '';
                    for(Database.Error err : sr.getErrors()) 
                    {
                        errMsg += err.getMessage() +',';                             
                        //System.debug(err.getStatusCode() + ': ' + err.getMessage());                             
                        system.debug('ErrorMessage:'+errMsg);
                        
                    }
                    resObj.ReturnCodeDescription = errMsg;
                    resObj.Status = 'Error';                                            
                }
                //listResponses.add(resObj);
                system.debug('Response:'+listResponses);
                
            }
            
            // For Custom Errors 
            for(string key : mapSiteIdError.keyset())
            {
                FSL_SiteDataWrapper.DataResponse resObj = new FSL_SiteDataWrapper.DataResponse();
                
                resObj.CustomerCode = mapSiteIdCustomerCode.get(Key);
                resObj.SiteID = key;
                resObj.ReturnCodeDescription = mapSiteIdError.get(key);
                resObj.Status = 'Error';                                            
                listResponses.add(resObj);
                system.debug('Response:'+listResponses);
            }
            for(integer i=0;i<blankSiteIdCount;i++)
            {
                FSL_SiteDataWrapper.DataResponse resObj = new FSL_SiteDataWrapper.DataResponse();
                
                resObj.CustomerCode = '';
                resObj.SiteID = '';
                resObj.ReturnCodeDescription = 'SiteId cannot be blank!';
                resObj.Status = 'Error';                                            
                listResponses.add(resObj);
            }
        } 
        
        return listResponses;
    }
}