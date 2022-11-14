/********************************************************************************************
Name: FSL_CL_getEPRFlag
Copyright Â© 2019  Cummins
=============================================================================================
=============================================================================================
Purpose:
---------------------------------------------------------------------------------------------
This class is used for EPR Flag Integration web service.
=============================================================================================
=============================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0     SRIPRADA SESHAM             11/18/2019    Initial Development for EPR Flag Integraion
********************************************************************************************/
public class FSL_CL_getEPRFlag {
    
    public static List<FSL_Parts__c> getPartsReturn(List<FSL_Parts__c> partsList) {
        System.debug('PARTLIST>>'+partsList);
        String endPointURL;
        Set<Id> partsId = new Set<Id>();
        Set<Id> partsId_N = new Set<Id>(); 
        WorkOrder wo = new WorkOrder();
        Account acc = new Account();
        
        FSL_IP_NamedCredentialWrapper reqWrap = null;
        FSL_getEPRReqWrapper partReqJSON = new FSL_getEPRReqWrapper();
        FSL_getEPRFlagResWrapper partResJSON = new FSL_getEPRFlagResWrapper();
        
        FSL_getEPRReqWrapper.Header headerObj = new FSL_getEPRReqWrapper.Header();
        FSL_getEPRReqWrapper.Sender senderObj = new FSL_getEPRReqWrapper.Sender();
        FSL_getEPRReqWrapper.Target targetObj = new FSL_getEPRReqWrapper.Target();
        FSL_getEPRReqWrapper.DataArea dataAreaObj = new FSL_getEPRReqWrapper.DataArea();
        FSL_getEPRReqWrapper.PARTS listPart = new FSL_getEPRReqWrapper.PARTS();
        
        for(FSL_Parts__c p:partsList) {
            if(p.Name != null || (p.Account_Code__c != null && p.Account_Code__c != '')) {
                partsId_N.add(p.Id);
            }
        }
        
        try {
            wo = [SELECT Id, Asset.Name, Failure_Date__c, ServiceTerritoryId, ServiceTerritory.Location_Code__c, 
                  Account.CSS_WS_Territory_Code__c, Asset.Engine_Family_Code__c, Account.FSL_ERP_Customer_Code__c
                  FROM WorkOrder WHERE Id =: partsList[0].Service_Order__c];
            System.debug('::: WorkOrder = '+wo);
            String position = wo.ServiceTerritory.Location_Code__c;
            String subString = position.substringBefore('-');
            String subString2 = position.substringAfter('-').substring(0,5);
            
            System.debug('::: position & subString = '+position+' * and * '+subString+' * and * '+subString2);
            
            acc = [Select id, name, CSS_WS_Territory_Code__c,FSL_ERP_Customer_Code__c from Account Where CSS_DistributorCode__c =: subString AND CSS_DBCode__c =: subString2 AND FSL_ERP_Customer_Code__c =: wo.Account.FSL_ERP_Customer_Code__c];
            System.debug('::: Account = '+acc);
            String accCode;
            if(acc.CSS_WS_Territory_Code__c != null){
                accCode = string.valueOf(acc.CSS_WS_Territory_Code__c);
            }else{
                accCode = '';
            }
            
        }
        catch(exception err) {
            Id woId = [SELECT Id, Name, Service_Order__c, Service_Order__r.ServiceTerritoryId,CSS_Solution_Component__r.Account_Code__c, 
                       GSQ_Service_Order__c,Fail_Code__c, CSS_Solution_Component__r.Account_Code__r.Name, 
                       Account_Code__c, GSQ_Service_Order__r.Asset.Engine_Family_Code__c, 
                       GSQ_Service_Order__r.Account.CSS_WS_Territory_Code__c, GSQ_Service_Order__r.Account.FSL_ERP_Customer_Code__c
                       FROM FSL_Parts__c WHERE Id =: partsList[0].Id].Service_Order__c;
            system.debug('WorkOrder ID:'+woId);
            wo = [SELECT Id, AssetId,AccountId,Asset.Name, Failure_Date__c,ServiceTerritoryId,Asset.Engine_Family_Code__c, Account.CSS_WS_Territory_Code__c FROM 
                  WorkOrder WHERE Id =: woId];
        }
        
        try {
            List<FSL_Parts__c> partsOptions = new List<FSL_Parts__c>();
            system.debug('DistiChanel : ' + '110' + ' ' +
                         'ESN : ' + wo.Asset.Name + ' ' +
                         'Failure Date : ' + wo.Failure_Date__c + ' ' +
                         'Product Family : ' + wo.Asset.Engine_Family_Code__c + ' ' +
                         'Territory Class : ' + string.valueOf(acc.CSS_WS_Territory_Code__c) + ' ' +
                         'Parts List : ' + partsList);
            if((wo.Asset.Name != null && wo.Asset.Name != '')) {
                //Added by Ramya - VGRS2-520  Name credentials for enhanced system performance for Get parts Return 
                String partsReturnNC = [Select DeveloperName,Endpoint FROM NamedCredential where DeveloperName = 'FSL_NC_Engine'].DeveloperName;
                // calling getAccessToken Service
               /* CG_OP_OAGWrapper accessTokenOPWrap;
                String accessToken;
                accessTokenOPWrap = CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns').AuthEnv__c,'CSS_SBL_GetPartReturns');
                accessToken = accessTokenOPWrap.accessToken;
               // String accessToken = FSL_WS_OAG.getAccessToken();
                
                if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken)) {
                    system.debug('Exception');
                }*/
                if(partsReturnNC == null || partsReturnNC == ''){
                    system.debug('Exception');
                }
                else {
                    senderObj.ServiceName = 'GetERPFlag';
                    senderObj.SenderID = 'CSS';
                    targetObj.TargetID = 'SIEBEL';
                    headerObj.Sender = senderObj;
                    headerObj.Target = targetObj;
                    partReqJSON.Header = headerObj;
                    dataAreaObj.PSN = wo.Asset.Name;
                    dataAreaObj.DISTICHANNEL = '110';
                    dataAreaObj.FAILDATE = String.valueof(wo.Failure_Date__c);
                    
                    dataAreaObj.PARTS = new List<FSL_getEPRReqWrapper.PARTS>();
                    system.debug('PartList:'+dataAreaObj.PARTS);
                    partReqJSON.DataArea = dataAreaObj;
                    
                    for(FSL_Parts__c parts : partsList) {
                        system.debug('parts.Fail_Code__c' + ' ' + parts.Fail_Code__c);
                        system.debug('parts.Account_Code__c' + ' ' + parts.Account_Code__c);
                        FSL_getEPRReqWrapper.parts partsObj = new FSL_getEPRReqWrapper.parts();
                        if(parts.Name != null) {
                            partsObj.PARTNUMBER = parts.Name;
                            if(parts.GSQ_Service_Order__r.Asset.Engine_Family_Code__c != null){
                                partsObj.PRODUCTFAMILY = parts.GSQ_Service_Order__r.Asset.Engine_Family_Code__c;}
                            else{
                                partsObj.PRODUCTFAMILY = '';
                            }
                            if(acc.CSS_WS_Territory_Code__c != null){
                                partsObj.TERRITORYCLASS = string.valueOf(acc.CSS_WS_Territory_Code__c);}
                            else{
                                partsObj.TERRITORYCLASS = '';
                            }
                            if(parts.Account_Code__c != null){
                                partsObj.ACCOUNTCODE = parts.Account_Code__c.RIGHT(2);}
                            else{
                                partsObj.ACCOUNTCODE = '';
                            }
                            system.debug('Account Code:'+partsObj.ACCOUNTCODE);
                            if(parts.Fail_Code__c !=null && parts.Fail_Code__c.trim() !='') {
                                list<string> lstFailCodes =  new list<string>();
                                lstFailCodes = parts.Fail_Code__c.split('-');
                                string newFailcode;
                                if(lstFailCodes.size()>0 && lstFailCodes[lstFailCodes.size()-1]!=null) {
                                    newFailcode = lstFailCodes[lstFailCodes.size()-1].LEFT(4);
                                }
                                
                                if(parts.Fail_Code__c != null){
                                    partsObj.FAILCODE = newFailcode;
                                }else{
                                    partsObj.FAILCODE = '';
                                }
                                system.debug('partsObj.FAILCODE' + ' ' + partsObj.FAILCODE);
                            }
                            partReqJSON.DataArea.PARTS.add(partsObj);
                            system.debug('Request:'+partReqJSON.DataArea.PARTS);
                        }
                    }
                    
                    // Prepare Request JSON
                    String partsReqJSONStr = JSON.serialize(partReqJSON);
                    System.debug('partsReqJSONStr>>>>>>>>>>:'+partReqJSON);
                    string endPoint;
                    Integer timeout;
                    String method;
                    reqWrap = new FSL_IP_NamedCredentialWrapper();
                    CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('CSS_SBL_GetPartReturns');
                   
                    if(conDetails<> null)
                    {
                        //if(conDetails.Method_Type__c == 'POST' || conDetails.Method_Type__c == 'PUT' ){
                            //reqWrap.jsonReqBody = reqWrapper.jsonReqBody;
                       // }
                        endPoint = conDetails.End_Point__c;
                        timeout = Integer.valueOf(conDetails.Timeout__c);
                        method = conDetails.Method_Type__c;
                        //commented below lines to use the mule version of calling mechanism -by vinod 8/31
                        /*HttpRequest req = new HttpRequest();
                        req.setEndpoint(endPoint);
                        req.setHeader('Content-Type', 'application/json');
                        req.setHeader('Authorization', 'Bearer '+accessToken);
                        req.setBody(partsReqJSONStr);
                        req.setTimeout(110000);
                        req.setMethod('POST');
                        Http http = new Http();*/
                        //changed method signature to make use of newer mule & return type. - mule4 changes 8/31 by vinod
                        CG_IP_OAGWrapper reqWrapper = FSLCumminsServiceUtility.createHttpRequest('CSS_SBL_GetPartReturns',endPoint, method, partsReqJSONStr, timeout);
						//Added by Ramya - VGRS2-520  Name credentials for enhanced system performance for Get parts Return 
                        if(reqWrapper.methodType == 'POST' || reqWrapper.methodType == 'PUT' ){
                            reqWrap.jsonReqBody = reqWrapper.jsonReqBody;
                        }
                        reqWrap.methodType = reqWrapper.methodType;
                        reqWrap.NamedCredential = 'FSL_NC_Engine';
                        reqWrap.Path = '/parts/return';
                        reqWrap.endPoint =[SELECT Endpoint FROM NamedCredential
                                           where DeveloperName=: reqWrap.NamedCredential 
                                           LIMIT 1].Endpoint+reqWrap.Path;
                        HttpResponse httpRes = new HttpResponse();
                        if(Test.isRunningTest()) {
                            String resBody = getFSLPartsResponse();
                            httpRes.setStatusCode(200);
                            httpRes.setBody(resBody);
                        } else {
                            //commented below lines to use the mule version of calling mechanism -by vinod 8/31
                            //httpRes = http.send(req);
                            ///CG_OP_OAGWrapper outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
							//Added by Ramya - VGRS2-520  Name credentials for enhanced system performance for Get parts Return 
                            CG_OP_OAGWrapper outputWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrap);
                            httpRes = outputWrapper.response;//Ends mule changes
                        }
                        system.debug('response>>'+httpres);
                        if(httpRes == null || httpRes.getStatusCode() != 200) {
                            system.debug('Exception:');
                        }
                        else {
                            System.debug('RESPONSE_BODY>>>:'+httpRes.getbody()+' httpRes getStatusCode is :: '+httpRes.getStatusCode()+' httpRes.toString>>>:'+httpRes.toString());
                            partResJSON =  (FSL_getEPRFlagResWrapper)JSON.deserializeStrict(httpRes.getBody(), FSL_getEPRFlagResWrapper.class);
                            System.debug('partResJSON>>>>>>>>>>>>>:'+partResJSON);
                            
                            if(partResJSON != null) {
                                if(partResJSON.DataArea!=null) {
                                    for(FSL_getEPRFlagResWrapper.DataArea a : partResJSON.DataArea) {
                                        FSL_Parts__c partsOpt = new FSL_Parts__c();
                                        for(FSL_Parts__c parts : partsList) {
                                            System.debug('::: Name and PARTNUMBER = '+parts.Name+' ** and ** '+a.PARTNUMBER+' and '+parts.Account_Code__c);
                                            if(parts.Name == a.PARTNUMBER && (parts.Account_Code__c != null && parts.Account_Code__c != '') ) {
                                                if(partsId != null && !partsId.contains(parts.Id)) {
                                                    partsOpt.EPR_Flag__c = a.EPRFLAG;
                                                    system.debug('EPR Flag:'+ partsOpt.EPR_Flag__c);
                                                    partsOpt.Return_Message__c = a.MESSAGE + '/r/n' + a.RETURNMESSAGE;
                                                    partsOpt.Id = parts.Id;
                                                    partsId.add(parts.Id);
                                                    partsOptions.add(partsOpt);
                                                    
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                    
                                    for(Id setId : partsId_N) {
                                        if(!partsId.contains(setId)) {
                                            FSL_Parts__c partsOptN = new FSL_Parts__c();
                                            partsOptN.EPR_Flag__c = 'N';
                                            partsOptN.Id = setId;
                                            partsOptions.add(partsOptN);
                                        }
                                    }
                                    system.debug('output -->' + partsOptions);
                                }
                            }
                        }
                    }
                }
            }
            return partsOptions;
        }
        catch(Exception ex) {
            System.debug('::: Exception = '+ex.getMessage()+'\n Error Stack = '+ex.getStackTraceString());
            System.debug('Entered in catch of getPartsReturn of FSL_CL_getEPRFlag >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is return null');
            return null;
        }
    }
    
    
    public static void getEPRFlagTriggerHelper(List<FSL_Parts__c> newList) {
        System.debug('::: FSL Parts = '+newList);
        // List<FSL_Parts__c> pt = new List<FSL_Parts__c>();
        Set<Id> partIds = new Set<Id>();
        for(FSL_Parts__c pt1: newList) {
            //  getPartsReturn(pt1);
            partIds.add(pt1.Id);
            system.debug('Part Id is:' + pt1.Id);
        }
        if(!partIds.isEmpty()) {
            getPartsReturnCall(partIds);
            system.debug('TestEPRFlag::'+partIds);
        }
    }
    
    @future (callout=true)
    public static void getPartsReturnCall(Set<Id> partIds) {
        List<FSL_Parts__c> lstParts = new List<FSL_Parts__c>();
        lstParts = [SELECT Id, Name,Service_Order__c, Account_Code__c, Fail_Code__c, GSQ_Service_Order__c,CSS_Solution_Component__r.Account_Code__r.Name,GSQ_Service_Order__r.Asset.Engine_Family_Code__c,GSQ_Service_Order__r.Account.CSS_WS_Territory_Code__c,GSQ_Service_Order__r.Account.FSL_ERP_Customer_Code__c FROM FSL_Parts__c WHERE Id =: partIds];
        
        if(lstParts.size() > 0) {
            List<FSL_Parts__c> outputParts = new List<FSL_Parts__c>();
            outputParts = getPartsReturn(lstParts);
            system.debug('Final FSL Parts to update####'+outputParts);
            if(outputParts.size() > 0) {
                update outputParts;
            }
        }
    }
    
    public static void getEPRFlagTriggerUpdate(List<FSL_Parts__c> newList) {
            system.debug('New list:' + newList[0].Id);
        // system.debug('New list:' + newList.Id);
        // List<FSL_Parts__c> pt = new List<FSL_Parts__c>();
        Set<Id> partIds = new Set<Id>();
        for(FSL_Parts__c pt1: newList) {
            // getPartsReturn(pt1);
            partIds.add(pt1.Id);
            system.debug('Part Id is:' + pt1.Id);
        }
        system.debug('future call in class'+System.isfuture());
        if(!partIds.isEmpty()) {
            getPartsReturnCallUpdate(partIds);
        }
    }
    
   
    public static void getPartsReturnCallUpdate(Set<Id> partIds) {
        List<FSL_Parts__c> lstParts = new List<FSL_Parts__c>();
        lstParts = [SELECT Id, Name,Service_Order__c, Account_Code__c, Fail_Code__c, GSQ_Service_Order__c,CSS_Solution_Component__r.Account_Code__r.Name,GSQ_Service_Order__r.Asset.Engine_Family_Code__c,GSQ_Service_Order__r.Account.CSS_WS_Territory_Code__c,GSQ_Service_Order__r.Account.FSL_ERP_Customer_Code__c FROM FSL_Parts__c WHERE Id =: partIds];
        if(lstParts.size() > 0) {
            List<FSL_Parts__c> outputParts = new List<FSL_Parts__c>();
            outputParts = getPartsReturn(lstParts);
            if(outputParts.size() > 0) {
                update outputParts;
            }
        }
    }
    
    public static String getFSLPartsResponse() {
        return '{'+
        '  \"DataArea\": ['+
        '    {'+
        '      \"LOCATION\": \"Receiving Location 35, 910 S Marr Road, Columbus, IN 47201\",'+
        '      \"MESSAGE\": \"**IMPORTANT**EPR**PART REQUEST - Review CUMMINS MATERIAL RETURN TICKET/s for specific part numbers to be returned**EPR Core Return**Go to QSOL/Warranty/Parts Return and refer to memo **\",'+
        '      \"ATTENTION\": \"Service Support Center\",'+
        '      \"RETURNMESSAGE\": \"**Enhanced Parts Return** EPR Memos located on QSOL, Warranty, Parts Return tab for details. Important: Always print and include a copy of the Parts Return Tag inside the box. Prepaid shipping label: UPS Visit  https://row.ups.com/Default.aspx?Company=cumminsssc (Company Alias=Cumminsssc Login ID=Service Provider Code Password=Ship123) or DHL 968695207 or FedEx 643285193\",'+
        '      \"EPRFLAG\": \"Y\",'+
        '      \"PARTNUMBER\": \"432879200\",'+
        '      \"COMPANY\": \"Cummins Inc.\"'+
        '    }'+
        '  ],'+
        '  \"Header\": {'+
        '    \"Status\": \"Success\",'+
        '    \"ReturnCodeDescription\": \"\"'+
        '  }'+
        '}';
    }
}