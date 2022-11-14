/**********************************************************************************************************
Name:FSL_CL_SiteCreateUpdate
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  This is the handler class for Site Create and
Update
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   Sriprada Sesham  05/23/2019       INITIAL DEVELOPMENT
1.1 -  Mani Kumari       02/12/2020       Updated Integration to include TergetID from UserAdded Tax_District__c, CreateUser, ChangeUser
1.2    Sriprada Sesham   02/24/2020       Updated logic for sending code values for country and state for BMSand Country mapping for UK
1.3    Vinod Yelala      09/22/2020       added null checks by vinod yelala 9.22.2020
1.4    Sunitha M         12/02/2020       Added Custome Metadata Settings for EU
1.5     Raghav           17/02/2021       //CT2-416 : Repair_Site_Name__c replaced by Repair_Site_Address__c
                                          //CT2-416 : IAM_CDH_Cross_references__c is replaced by Address
1.6		Harini			11/30/2021		 Added postal code suffix in JSON and split postal code as part of FBI-104
1.7   Shirisha Pedditi  06/06/2022       Added Named Credentials: ROAD 376
********************************************************************************************************************/

public class FSL_CL_SiteCreateUpdate {
    
    public static Id Workorder;
    public static String Sender = 'CSS';
    public static String TargetERP;
    public static string strCntry{get;set;}
    public static string strCntryState{get;set;}
    public static CallOutResponseWrap checkSiteId(string workOrderID,string custCode,string contactId) {
        system.debug('Values:' +workOrderID+' '+custCode);
        DateTime startTime = System.Now();
        Workorder = workOrderID;
        CallOutResponseWrap retObj = new CallOutResponseWrap();
        string jsonReq = '';
        list<workOrder> listWo = new list<Workorder>();
        //CT2-416 : Repair_Site_Name__c is replaced by Repair_Site_Address__c
        listWo = [SELECT Id, WorkOrderNumber, Repair_Location__c, ServiceTerritory.Location_Code__c, ContactId, Repair_Site_Address__c, Repair_Site_Address__r.FSL_Site_Name__c, 
                  Repair_Site_Address__r.Street, Repair_Site_Address__r.City, Repair_Site_Address__r.Country, Repair_Site_Address__r.Geolocation__Latitude__s, Repair_Site_Address__r.Geolocation__Longitude__s, 
                  Contact.FSL_Contact_Id__c, Repair_Site_Address__r.PostalCode, Repair_Site_Address__r.State, Repair_Site_Address__r.FSL_Site_ID__c, Repair_Site_Address__r.FSL_Tax_District__c, 
                  Account.CSS_DistributorCode__c, Account.CSS_DBCode__c, Account.FSL_ERP_Customer_Code__c, Repair_Site_Address__r.CreatedById, Repair_Site_Address__r.LastModifiedById 
                  FROM WorkOrder WHERE Id =: workOrderID];
        User usr = new User();
        usr = [SELECT Id, ERP__c ,Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        String TargetERP;
        TargetERP = (String)usr.ERP__c;
        //CT3-245
         Map<String,String> mapCountryEU = new Map<String,String>(); 
        List<FSL_ERP_Country_Translation__mdt> lstCountryMapping=[SELECT MasterLabel, Country__c 
                                                                  FROM FSL_ERP_Country_Translation__mdt];
        for(FSL_ERP_Country_Translation__mdt countryMapping:lstCountryMapping) {
            mapCountryEU.put(countryMapping.Country__c,countryMapping.MasterLabel);
        }
        system.debug('TargetID:' + TargetERP);
        system.debug('Repair_Site_Address__c:' + listWo);
        system.debug('Test:' + listWo[0].Repair_Site_Address__r.CreatedById); 
        User usr1 = new User();
        User usr2 = new User();
            usr1 = [SELECT Id, ERP__c ,Name FROM User WHERE Id =:listWo[0].Repair_Site_Address__r.CreatedById  LIMIT 1];
            usr2 = [SELECT Id, ERP__c ,Name FROM User WHERE Id =:listWo[0].Repair_Site_Address__r.LastModifiedById  LIMIT 1];
        String CreateUser = usr1.Name;
        system.debug('CreateUser:' + CreateUser);
        String ChangeUser = usr2.Name;
        system.debug('CreateUser:' + ChangeUser);
        String siteCountry;
        String siteState = listWo[0].Repair_Site_Address__r.State;
        
        if(TargetERP == 'BMS') {
            //added null checks by vinod yelala 9.22.2020
            if(String.isNotBlank(listWo[0].Repair_Site_Address__r.Country)) strCntry = FSL_utility.getCountryCode(listWo[0].Repair_Site_Address__r.Country);
            System.debug('strCntry: '+strCntry);
            //added null checks by vinod yelala 9.22.2020
            if(String.isNotBlank(listWo[0].Repair_Site_Address__r.Country) && String.isNotBlank(listWo[0].Repair_Site_Address__r.State))
                strCntryState = FSL_utility.getStateCode(listWo[0].Repair_Site_Address__r.Country, listWo[0].Repair_Site_Address__r.State);
            System.debug('strCntryState: '+strCntryState);
        } //CT3-245 // {Ireland=Eire, United Kingdom=Great Britain}  
        else if(mapCountryEU.containsKey(listWo[0].Repair_Site_Address__r.Country)) {
            siteCountry=mapCountryEU.get(listWo[0].Repair_Site_Address__r.Country);
        } 
        else {
            siteCountry = listWo[0].Repair_Site_Address__r.Country;
            strCntryState = listWo[0].Repair_Site_Address__r.State;
        }
        if(listWo.size() > 0)
        {
            String position = listWo[0].ServiceTerritory.Location_Code__c;
            String subString = position.substringBefore('-');
            String subString2 = position.substringAfter('-').substring(0,5);
            String woNumber;
            String SourceType= System.Label.FSL_Source_Environment_Type;
            if(SourceType == 'GZEVLPRD') {
                woNumber = listWo[0].WorkOrderNumber;
            } else {
                woNumber = SourceType.right(3)+'-'+listWo[0].WorkOrderNumber;
            }
            if(TargetERP == 'BMS') {
                position = subString + '-' + subString2;
                siteCountry = strCntry;
                siteState = strCntryState;
                system.debug('CountryCode:'+strCntry);
                system.debug('StateCode:'+strCntryState);
                system.debug('LocationId:'+subString + '-' + subString2);
            }
            
            if(listWo[0].Repair_Location__c == 'Mobile' && listWo[0].Repair_Site_Address__c != null)	// CT2-416 : Repair_Site_Name__c is replaced by Repair_Site_Address__c
            {
                // jsonReq = '{"Header":{"Sender":{"ServiceName":"CreateUpdateSite","SenderID":"CSS"},"Target":{"TargetID":"MOVEX"},"Location":{"LocationID":"'+listWo[0].ServiceTerritory.Location_Code__c+'"}},"DataArea":{"DistributorCode":"'+subString+'","BranchCode":"'+subString2+'","SiteName":"'+listWo[0].Repair_Site_Name__r.Name+'","JobContactPhone":"","CustomerCode":"'+listWo[0].Account.FSL_ERP_Customer_Code__c+'","ContactID":"'+listWo[0].Repair_Site_Name__r.MoveX_ContactId__c+'","Latitude":"","Longitude":"",CSSJobID":"'+listWo[0].WorkOrderNumber+'"}}';
                // jsonReq = '{"Header":{"Sender":{"ServiceName":"CreateUpdateSite","SenderID":"CSS"},"Target":{"TargetID":"MOVEX"},"Location":{"LocationID":"03520-04892"}},"DataArea":{"DistributorCode":"03520","BranchCode":"04892","SiteName":"","SiteID":"","CustomerCode":"160354","Longitude":"","Latitude":"","Address1":"Columbus1","Address2":"Columbus2","Address3":"Columbus3","City":"Columbus","State":"IN","PostalCode":"47201","Country":"USA","ContactID":"","RepairLocation":"Mobile","CSSJobID":"CSS0002345"}}';
                String[] streetAddr;
                String streetLine1 = '',streetLine2 = '',streetLine3 = '';
                
                if(!String.isEmpty(listWo[0].Repair_Site_Address__r.Street)){
                	streetAddr = listWo[0].Repair_Site_Address__r.Street.split(',',3);
                    if(streetAddr != null){
                        if(streetAddr.size()>0) streetLine1 = streetAddr[0];
                        if(streetAddr.size()>1) streetLine2 = streetAddr[1];
                        if(streetAddr.size()>2) streetLine3 = streetAddr[2];
                    }
                }
                String postalcode1='';
                String postalcode2='';
                if(listWo[0].Repair_Site_Address__r.PostalCode !=null && listWo[0].Repair_Site_Address__r.PostalCode.contains('-') &&
                  (siteCountry =='United States' || siteCountry =='US') && TargetERP == 'BMS'){
                    //Added postal code suffix in JSON and split postal code by Harini as part of FBI-104  
                    postalcode1 = listWo[0].Repair_Site_Address__r.PostalCode.split('-')[0];
                    postalcode2 = listWo[0].Repair_Site_Address__r.PostalCode.split('-')[1];
                }else{
                    postalcode1 = listWo[0].Repair_Site_Address__r.PostalCode;
                    
                }
                jsonReq = '{"Header":{"Sender":{"ServiceName":"CreateUpdateSite","SenderID":"CSS"},"Target":{"TargetID":"'+TargetERP+'"},"Location":{"LocationID":"'+position+'"}},"DataArea":{"DistributorCode":"'+subString+'","BranchCode":"'+subString2+'","SiteName":"'+listWo[0].Repair_Site_Address__r.FSL_Site_Name__c+'","SiteID":"'+listWo[0].Repair_Site_Address__r.FSL_Site_ID__c+'","CustomerCode":"'+custCode+'","Longitude":"'+listWo[0].Repair_Site_Address__r.Geolocation__Longitude__s+'","Latitude":"'+listWo[0].Repair_Site_Address__r.Geolocation__Latitude__s+'","Address1":"'+streetLine1+'","Address2":"'+streetLine2+'","Address3":"'+streetLine3+'","City":"'+listWo[0].Repair_Site_Address__r.City+'","State":"'+siteState+'","PostalCode":"'+postalcode1 +'","PostalCodeSuffix":"'+postalcode2+'","Country":"'+siteCountry+'","ContactID":"'+contactId+'","RepairLocation":"Mobile","CSSJobID":"'+woNumber+'","TaxDistrict":"'+listWo[0].Repair_Site_Address__r.FSL_Tax_District__c+'","CreateUser":"'+CreateUser+'","ChangeUser":"'+ChangeUser+'"}}';
                jsonReq = jsonReq.replaceAll('"null"', '""');
                
                retObj = updateSiteId(jsonReq);
                system.debug('Request is for site integration:'+ jsonReq);
            }
            if(retObj.siteObj !=null && retObj.siteObj.FSL_Site_ID__c != null){
                retObj.siteObj.Id = listWo[0].Repair_Site_Address__c;    //CT2-416 : Repair_Site_Name__c is replaced by Repair_Site_Address__c                
            }
            // User story ROAD-229 Integration logging
            
            if(retObj!= null && (retObj.status == 'ERROR' || retObj.status == 'FAIL') && !Test.isRunningTest()) {
                system.debug('in FSL_CL_SiteCreateUpdate integration block retObj:'+retObj);
                FSL_ApplicationLogger.insertFSLIntegrationErrorLog(jsonReq,String.valueOf(retObj),'CreateUpdateSite','Error',String.valueOf(TargetERP),'toolId','CSS');
                system.debug('logged integration error:');
            }
        }
        return retObj;
    } 
    
    /*public static CallOutResponseWrap updateSiteId_Existing(string jsonReq, string token)
    {
        CallOutResponseWrap retWrap = new CallOutResponseWrap();
        system.debug('jsonReq : '+jsonReq);
        string endPoint;
        HttpRequest req = new HttpRequest();
        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('FSL_SiteInfo');
        System.debug('conDetails'+conDetails);
        endPoint = conDetails.End_Point__c;
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', 'Bearer '+token);
        req.setBody(jsonReq);
        req.setTimeout(110000);
        req.setMethod('PUT');
        
        Http http = new Http();  
        HttpResponse httpRes = http.send(req);
        
        system.debug('response body : '+httpRes.getBody());
        string siteid = '';
        string response = httpRes.getBody();
        string returnval;
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
                    // System.debug('recordId = '+token);
                }
            }
        }
        if(response.contains('"SiteID":'))
        {          
            JSONParser parser = JSON.createParser(response);  
            while (parser.nextToken() != null)
            {        
                if(parser.getText() == 'SiteID') 
                {               
                    parser.nextToken(); 
                    siteid = (parser.getText());
                    // System.debug('recordId = '+token);
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
                    // System.debug('recordId = '+token);
                }
            }
        }
        IAM_CDH_Cross_references__c st = new IAM_CDH_Cross_references__c();
        system.debug('** dec val'+siteid);
        st.FSL_MoveX_Site_Id__c = string.isNotBlank(siteid) ? siteid.trim() : null;
        system.debug('siteid '+ siteid);
        retWrap.siteObj = st;
        DateTime startTime = System.Now();
        // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(), httpres.getBody(), Null, Null, 'SiteCreateUpdate', httpRes.getStatus(), '', 'Guidanz',Sender, Workorder, TargetERP));
        return retWrap; 
        // if(string.isNotBlank(sSiteid) && string.isNotBlank(siteid))
{
//system.debug('siteid '+ siteid);
//IAM_CDH_Cross_references__c st = new IAM_CDH_Cross_references__c();
//st.id= sSiteid;
//st.SiteID__c = Decimal.valueOf(siteid);
//update st;
//} 
    }*/
    public static CallOutResponseWrap updateSiteId(string jsonReq) {
        CallOutResponseWrap retWrap = new CallOutResponseWrap();
        system.debug('jsonReq : '+jsonReq);
        string endPoint;
        //Added by Shirisha ROAD-376
        FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();
			reqWrapper.jsonReqBody=jsonReq;
        system.debug('json req after serial//////'+reqWrapper.jsonReqBody);
			reqWrapper.methodType = 'POST';
	    	reqWrapper.NamedCredential = 'FSL_NC_Customers';
	    	reqWrapper.Path = '/site';
            reqWrapper.WorkOrder=Workorder;
	    	reqWrapper.endPoint = [SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint;
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        system.debug('ReqWrapper is :'+reqWrapper);
            returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrapper);
        system.debug('ReturnWrapper is : '+returnWrapper);
        string response;
        if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null){
        system.debug('response body : '+returnWrapper.response.getBody());
            response = returnWrapper.response.getBody();
        }
        string siteid = '';
        //string response = httpRes.getBody();
        
        string returnval;
        if(Test.isRunningTest()){
            response='{"DataArea":{"SiteID":2,"CustomerCode":"4K1SERV","CSSJobID":""},"Header":{"Sender":{"ServiceName":"CreateUpdateSite","SenderID":"CSS","MessageID":"17b46d80-b846-44b9-9518-e74ecb851de1"},"Status":"ERROR","Target":{"TargetID":"MOVEX"},"ReturnCodeDescription":"Site id does not exist","Location":{"LocationID":"05115-05115-M"}}}';
        }
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
                    // System.debug('recordId = '+token);
                }
            }
        } 
        if(response.contains('"SiteID":'))
        {          
            JSONParser parser = JSON.createParser(response);  
            while (parser.nextToken() != null)
            {        
                if(parser.getText() == 'SiteID') 
                {               
                    parser.nextToken(); 
                    siteid = (parser.getText());
                    // System.debug('recordId = '+token);
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
                    // System.debug('recordId = '+token);
                }
            }
        }
        system.Debug('returnwrapper.eception flag is :  '+returnWrapper.exceptionFlag);
        system.debug('retWrap.status is :'+retWrap.status);
        system.debug('retWrap.msg is :'+retWrap.msg);
        //Phoen-142: Send To Assign Issues Fix
        if(returnWrapper.exceptionFlag == true){
            if(string.isBlank(retWrap.status)){
                retWrap.status ='FAIL';
            }
            if(string.isBlank(retWrap.msg)){
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null)
                {
                    if(parser.getText() == 'message')
                    {
                        parser.nextToken();
                        retWrap.msg = 'OSB_380000';
                        retWrap.msg = retWrap.msg + (parser.getText());
                    }
                }
            }
        }
        //CT2-416 : IAM_CDH_Cross_references__c is replaced by Address && FSL_MoveX_Site_Id__c replaced by FSL_Site_ID__c
        Schema.Address addr = new Schema.Address();
        system.debug('** dec val' + siteid);
         addr.FSL_Site_ID__c = string.isNotBlank(siteid) ? siteid.trim() : null;
        system.debug('siteid '+ siteid);
        retWrap.siteObj = addr;
        DateTime startTime = System.Now();
        system.debug('Ret wrap is : '+retWrap);
        // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(), httpres.getBody(), Null, Null, 'SiteCreateUpdate', httpRes.getStatus(), '', 'Guidanz',Sender, Workorder, TargetERP));
        return retWrap; 
        /* if(string.isNotBlank(sSiteid) && string.isNotBlank(siteid)) {
            system.debug('siteid '+ siteid);
            IAM_CDH_Cross_references__c st = new IAM_CDH_Cross_references__c();
            st.id= sSiteid;
            st.SiteID__c = Decimal.valueOf(siteid);
            update st;
		} */
    }
    
    public class CallOutResponseWrap {
        Public Schema.Address siteObj; //CT2-416 : IAM_CDH_Cross_references__c is replaced by Address
        Public string status;
        Public string msg;
    }
}