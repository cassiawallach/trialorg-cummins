/**********************************************************************
Name: CSS_FN_SIEBEL
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is used for Business Logics of SIEBEL functionality to 
handle reusable code modules such as Create/Update/View/Delete/etc operations
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        04/10/2017     INITIAL DEVELOPMENT & Implementation of GetTechInfo/GetSPInfo/ApplicationOrCategoryComplaint services 
1.1     Vignesh S         08/24/2017     Added AccountCode Service method
1.2     Arpita Sarangee   05/12/2017     Added code as part of development for User story 115653
***********************************************************************
***********************************************************************/
public class CSS_FN_SIEBEL {

    public static void storeApplicationOrCategoryComplaintList(String serviceName){
        CG_OP_OAGWrapper outputWrapper;
        System.debug('################# entered into storeApplicationOrCategoryComplaintList method ###################'); 
        String senderID;
        String messageID;
        String endPointURL;
        String remoteConName;
        try{
            //calling getAccessToken Service
            //String accessToken = CSS_WS_OAG.getAccessToken();
            //Commented for dynamic Authentication and added below lines
           //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_ApplicationCodes').AuthEnv__c);
           //commented above line for Mule and access token will generate based on CSS_SBL_ApplicationCodes/CSS_SBL_CategoryComplaintCodes
            if(serviceName == 'GetApplicationList')
                remoteConName = 'CSS_SBL_ApplicationCodes';
            else
                remoteConName = 'CSS_SBL_CategoryComplaintCodes';
                system.debug('remoteConName<><>'+remoteConName);
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection(remoteConName).AuthEnv__c,remoteConName);//Added  OAG to Mule 19/05/2020
           // CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken('MuleAuth',remoteConName);
            String accesstoken = accessTokenOPWrap.accessToken;
            system.debug('serviceName>>'+serviceName);
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                css_utility.LogOutIntError('CSS_FN_SIEBEL-'+serviceName, 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                return;
            }

            //current date
            Datetime currentDate = System.now();
            String currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00';
            senderID = 'CSS';
            //serviceName = 'GetComplaintsList';
            messageID = '1';

            //Prepare Request JSON
            CSS_WPR_SBL_ApplnCategoryListReqJSON appliCatComplaintReqJSON = CSS_WS_SBL.prepareReqJSONForApplCategoryList(senderID, serviceName, messageID, currDate);
            String appliCatComplaintJSONReqBody = JSON.serialize(appliCatComplaintReqJSON);
            System.debug('appliCatComplaintJSONReqBody>>>>>>>>>>>>>>>>>>>>:'+appliCatComplaintJSONReqBody);

            //calling Applition/CategoryComplaint webservice
          /*  if(serviceName == 'GetApplicationList')
                remoteConName = 'CSS_SBL_ApplicationCodes';
            else
                remoteConName = 'CSS_SBL_CategoryComplaintCodes'; //serviceName=GetComplaintsList*/
            endPointURL = CSS_getConnnectionDetails.getConnection(remoteConName).End_Point__c;
            endPointURL = endPointURL+'?sender=CSS&target=CSSWarranty';
            system.debug('endPointURL<>'+endPointURL);
           // HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(appliCatComplaintJSONReqBody, endPointURL, accessToken);
            
            
            //below code for Mule
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.endPoint = endPointURL;
            reqWrapper.serviceName = remoteConName;
            reqWrapper.methodType = CSS_getConnnectionDetails.getConnection(remoteConName).Method_Type__c;
            outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            HttpResponse httpRes = outputWrapper.response;
            system.debug('reqWrapper.methodType>>'+reqWrapper.methodType);
            system.debug('testing purpose: Are we getting Response from CSS_WS_OAG Class>>>'+httpres);
            //
            if(httpRes == null || httpRes.getStatusCode() != 200){
                css_utility.LogOutIntError('CSS_FN_SIEBEL-'+serviceName, 'CategoryComplaintList HttpResponse is null', 'CategoryComplaintList Webservice Execution failed', 'SBL');
                return;
            }
            System.debug('RESPONSE_BODY>>>:'+httpRes.getbody()+' httpRes getStatusCode is :: '+httpRes.getStatusCode()+' httpRes.toString>>>:'+httpRes.toString());
            //diagSRTResWC = (CSS_J2ADiagnostic_SRT)JSON.deserializeStrict(httpRes.getBody(), CSS_J2ADiagnostic_SRT.class);
            //below logic of save response data & weekly basis date override logic
            insertResponse(httpRes.getBody(), serviceName);
        }catch(Exception ex){
            System.debug('in catch of '+serviceName+ 'of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_SIEBEL-'+serviceName, 'HttpResponse is null', 'Webservice Execution failed', 'SBL');
        }finally{
            endPointURL=null;remoteConName=null;
        }
    }

    public static void insertResponse(String responseBody, String serviceName){
        System.debug('################# entered into insertResponse method ###################');
        List<CSS_JobEventTemporary__c> jobEventList;
        CSS_JobEventTemporary__c jobEventObj;
        String eventType;
        //try{
        if(serviceName == 'GetApplicationList')
            eventType = 'ApplicationCodes';
        //Added for Account Codes start
        else if(serviceName == 'GetAccountCodes')
            eventType = 'AccountCodes';
        //Added for Account Codes end
        //Added for Fail Modes start
        else if(serviceName == 'getFailModes')
            eventType = 'FailModes';
        //Added for Fail Modes end
        //Added for Fail Codes start
        else if(serviceName == 'getFailCodes')
            eventType = 'FailCodes';
        //Added for Account Codes start
        else if(serviceName == 'GetApprovalAuthCodes')
            eventType = 'ApprovalAuthCode';
        //Added for Fail Codes end
        else if(ServiceName == 'getMarketingApplicationCodes')
            eventType = 'MarketingApplicationCodes';
        else
            eventType = 'CategoryComplaintCodes';

        system.debug('serviceName-->'+serviceName);
        system.debug('responseBody-->'+responseBody);

        if(eventType == 'AccountCodes'){
            CSS_JobEventTemporary__c dateProcessRec = new CSS_JobEventTemporary__c();
            try{
                dateProcessRec = [SELECT Id, Attribute1__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes_LastProcessed' limit 1];
                system.debug('dateProcessRec-->'+dateProcessRec);
                dateProcessRec.Attribute1__c = string.valueof(date.today());
                update dateProcessRec;
            }
            catch(Exception ex){
                dateProcessRec.Attribute1__c = string.valueof(system.now());
                dateProcessRec.Key__c = 'AccountCodes_LastProcessed';
                insert dateProcessRec;
            }     
            system.debug('dateprocessRec >>'+dateProcessRec.Attribute1__c);
            system.debug('AccountCodes before deserializeStrict responseBody-->'+responseBody);
            CSS_SiebelAccountCodeResponseJ2A accountCodeResponse;
            accountCodeResponse = (CSS_SiebelAccountCodeResponseJ2A)JSON.deserialize(responseBody, CSS_SiebelAccountCodeResponseJ2A.class);
            system.debug('after deserializeStrict accountCodeResponse-->'+accountCodeResponse);

            Map<String,CSS_JobEventTemporary__c> mapJobEventTemp = new map<String,CSS_JobEventTemporary__c>();
            List<CSS_JobEventTemporary__c> queryJobEventTemp = new List<CSS_JobEventTemporary__c>();
            queryJobEventTemp = [select Attribute1__c,Attribute2__c,Attribute3__c,Attribute4__c,Active__c,Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes'];

            if(accountCodeResponse.DataArea !=null)
                for(CSS_SiebelAccountCodeResponseJ2A.DataArea a : accountCodeResponse.DataArea){
                    CSS_JobEventTemporary__c jobEventTemp = new CSS_JobEventTemporary__c();

                    jobEventTemp.Attribute1__c = a.COVERAGETYPE;
                    jobEventTemp.Attribute2__c = a.DESCRIPTION;
                    jobEventTemp.Attribute3__c = a.ACCOUNTCODE;

                    //New Fields as part of #127007
                    jobEventTemp.Attribute5__c = a.EDSFLAG;
                    jobEventTemp.Attribute6__c = a.BUSINESSUNIT;
                    jobEventTemp.Attribute7__c = a.MULTIPSN;
                    jobEventTemp.Attribute8__c = a.WARRANTY;
                    jobEventTemp.Attribute9__c = a.CHRYSLERFLAG;

                    //jobEventTemp.Attribute5__c = 'Region';//Need to modify
                    jobEventTemp.Attribute4__c = a.COVERAGETYPE + '-' + a.DESCRIPTION + '-' + a.ACCOUNTCODE;
                    jobEventTemp.Active__c = true;
                    jobEventTemp.Key__c = eventType;
                    jobEventTemp.Reason__c = JSON.serialize(a.PAYCODES);
                    mapJobEventTemp.put(jobEventTemp.Attribute4__c.toUpperCase(),jobEventTemp);

                }

            for(CSS_JobEventTemporary__c J:queryJobEventTemp){
                CSS_JobEventTemporary__c jobEventAccCodes = new  CSS_JobEventTemporary__c();
                String tempAttribute4;
                if(J.Attribute4__c != null && J.Attribute4__c != '')
                    tempAttribute4 = J.Attribute4__c.toUpperCase();
                else
                    tempAttribute4 = '';
                if(mapJobEventTemp.containsKey(tempAttribute4)){
                    jobEventAccCodes = mapJobEventTemp.get(tempAttribute4);
                    jobEventAccCodes.Id = J.Id;
                    jobEventAccCodes.Active__c = true;
                    //Active Acc Codes
                    mapJobEventTemp.put(tempAttribute4,jobEventAccCodes);
                }else{
                    jobEventAccCodes.Id = J.Id;
                    jobEventAccCodes.Active__c = false;
                    //Inactive Acc codes
                    mapJobEventTemp.put(tempAttribute4,jobEventAccCodes);
                }
            }
            if(mapJobEventTemp.size() > 0){
                system.debug('List size in If is'+mapJobEventTemp.size());
                system.debug('mapJobEventTemp--->'+mapJobEventTemp);
                upsert mapJobEventTemp.values();
            }
        }

        else if(eventtype=='FailModes'){
            List<CSS_SBL_getFailModesResponseWrapper.Details> listDetails = new List<CSS_SBL_getFailModesResponseWrapper.Details>(); 

            CSS_SBL_getFailModesResponseWrapper FailModeResponse;
            FailModeResponse = (CSS_SBL_getFailModesResponseWrapper)JSON.deserializeStrict(responseBody, CSS_SBL_getFailModesResponseWrapper.class);
            system.debug('FailModesResponse-->'+FailModeResponse.DataArea.Details);
            listDetails = FailModeResponse.DataArea.Details; 

            Map<String,CSS_JobEventTemporary__c> mapJobEventTemp1 = new map<String,CSS_JobEventTemporary__c>();
            List<CSS_JobEventTemporary__c> queryJobEventTemp = new List<CSS_JobEventTemporary__c>();
            queryJobEventTemp = [select Attribute1__c,Name,Attribute3__c,Attribute4__c,Active__c,Key__c,Attribute13__c from CSS_JobEventTemporary__c where Key__c=:eventType];
            for(CSS_SBL_getFailModesResponseWrapper.Details a : listDetails){
                CSS_JobEventTemporary__c jobEventTemp = new CSS_JobEventTemporary__c();
                jobEventTemp.Attribute1__c = a.FailModeCode;
                jobEventTemp.Attribute3__c = a.Description;
                jobEventTemp.Attribute4__c = a.BusinessUnit;
                if(a.Active == 'Y')
                    jobEventTemp.Active__c = true;
                else
                    jobEventTemp.Active__c = false;
                jobEventTemp.Key__c = eventType;
                jobEventTemp.Attribute13__c = date.valueof(a.LastUpdated);
                jobEventTemp.Name = eventType;
                mapJobEventTemp1.put(jobEventTemp.Attribute1__c,jobEventTemp);
                system.debug('FailModesResponse-->123');
            }
            for(CSS_JobEventTemporary__c J:queryJobEventTemp){
                CSS_JobEventTemporary__c jobEventFailmodes= new  CSS_JobEventTemporary__c(); 
                if(mapJobEventTemp1.containsKey(J.Attribute1__c)){
                    jobEventFailmodes = mapJobEventTemp1.get(J.Attribute1__c);
                    jobEventFailmodes.Id = J.Id;
                    mapJobEventTemp1.put(J.Attribute1__c,jobEventFailmodes);
                    system.debug('FailModesResponse-->1234');
                }
            }
            system.debug('FailModesResponse-->1235==>');
            list<CSS_JobEventTemporary__c> jobeventTemp = [SELECT Id, Name, Key__c, Attribute1__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'FailModeProcessedDate' LIMIT 1];
            system.debug('FailModesResponse-->1235');
            if(jobeventTemp.size()==0){
                system.debug('FailModesResponse-->1236');
                CSS_JobEventTemporary__c jobeventT = new CSS_JobEventTemporary__c();
                jobeventT.Attribute1__c = string.valueOf(Date.Today());
                jobeventT.Key__c ='FailModeProcessedDate';
                mapJobEventTemp1.put(jobeventT.Attribute1__c, jobeventT);
            }
            else{
                jobeventTemp[0].Attribute1__c = string.valueOf(Date.Today());
                mapJobEventTemp1.put(jobeventTemp[0].Attribute1__c, jobeventTemp[0]);
            }

            if(mapJobEventTemp1.size() > 0){
                system.debug('List size in If is'+mapJobEventTemp1.size());
                system.debug('mapJobEventTemp--->'+mapJobEventTemp1);
                upsert mapJobEventTemp1.values();
            } 

        }
        //Codes
        else if(eventtype=='FailCodes'){
            CSS_SiebelFailCodeResponseJ2A.Details lstDetailswrap = new CSS_SiebelFailCodeResponseJ2A.Details();
            CSS_SiebelFailCodeResponseJ2A failCodeResponse;
            List<CSS_SiebelFailCodeResponseJ2A.Details> listDetails = new List<CSS_SiebelFailCodeResponseJ2A.Details>();
            failCodeResponse = (CSS_SiebelFailCodeResponseJ2A)JSON.deserializeStrict(responseBody, CSS_SiebelFailCodeResponseJ2A.class);
            system.debug('FailModesResponse-->'+failCodeResponse.DataArea.Details);
            listDetails = failCodeResponse.DataArea.Details;

            Map<String,CSS_JobEventTemporary__c> mapJobEventTemp1 = new map<String,CSS_JobEventTemporary__c>();
            List<CSS_JobEventTemporary__c> queryJobEventTemp = new List<CSS_JobEventTemporary__c>();
            queryJobEventTemp = [select Id, Name,Active__c,Key__c, Attribute1__c, Attribute3__c, Attribute4__c, Attribute5__c, Attribute6__c, Attribute7__c
                                 , Attribute8__c, Attribute9__c, Attribute10__c from CSS_JobEventTemporary__c where Key__c=:eventType];

            for(CSS_SiebelFailCodeResponseJ2A.Details a : listDetails){
                CSS_JobEventTemporary__c jobEventTemp = new CSS_JobEventTemporary__c();
                string uniqueKey = a.SystemCode + ':' + a.SystemName + ':' + a.ComponentCode + ':' + a.ComponentName;
                jobEventTemp.Attribute1__c = a.SystemCode;
                jobEventTemp.Attribute3__c = a.SystemName;
                jobEventTemp.Attribute4__c = a.ComponentCode;
                jobEventTemp.Attribute5__c = a.ComponentName;
                jobEventTemp.Attribute6__c = a.ServiceGroupCode;
                jobEventTemp.Attribute7__c = a.FailureName;
                jobEventTemp.Attribute8__c = a.BusinesUnit;
                jobEventTemp.Attribute9__c = a.Created;
                jobEventTemp.Attribute10__c = a.UpdatedDate;
                jobEventTemp.Active__c = true;
                jobEventTemp.Key__c = eventType;
                jobEventTemp.Name = eventType;
                system.debug('uniqueKey   >>>> ' + uniqueKey);
                mapJobEventTemp1.put(uniqueKey,jobEventTemp);
            }

            for(CSS_JobEventTemporary__c J:queryJobEventTemp){
                CSS_JobEventTemporary__c jobEventFailCodes= new  CSS_JobEventTemporary__c(); 
                string uniqueKey = J.Attribute1__c + ':' + J.Attribute3__c + ':' + J.Attribute4__c + ':' + J.Attribute5__c;
                if(mapJobEventTemp1.containsKey(uniqueKey)){
                    jobEventFailCodes = mapJobEventTemp1.get(uniqueKey);
                    jobEventFailCodes.Id = J.Id;
                    jobEventFailCodes.Active__c = true;
                    //Active FailCodes
                    mapJobEventTemp1.put(uniqueKey,jobEventFailCodes);
                }else{
                    jobEventFailCodes.Id = J.Id;
                    jobEventFailCodes.Active__c = false;
                    //Inactive FailCodes
                    mapJobEventTemp1.put(uniqueKey,jobEventFailCodes);
                }
            }

            List<CSS_JobEventTemporary__c> jobeventTemp = [SELECT Id, Name, Key__c, Attribute1__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'FailCodeProcessedDate' LIMIT 1];
            if(jobeventTemp != null && jobeventTemp.size() > 0) {
                jobeventTemp[0].Attribute1__c = string.valueOf(Date.Today());
                mapJobEventTemp1.put(jobeventTemp[0].Attribute1__c, jobeventTemp[0]);
            } else {
                CSS_JobEventTemporary__c jet = new CSS_JobEventTemporary__c();
                jet.Attribute1__c = string.valueOf(Date.Today());
                jet.Key__c = 'FailCodeProcessedDate';
                mapJobEventTemp1.put(jet.Attribute1__c, jet);
            }

            if(mapJobEventTemp1.size() > 0){
                system.debug('List size in If is'+mapJobEventTemp1.size());
                system.debug('mapJobEventTemp--->'+mapJobEventTemp1);
                upsert mapJobEventTemp1.values();
            }


        } 
        else if(eventType == 'ApprovalAuthCode'){
            CSS_JobEventTemporary__c dateProcessRec = new CSS_JobEventTemporary__c();
            try{
                dateProcessRec = [SELECT Id, Attribute1__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'ApprovalAuthCode_LastProcessed' limit 1];
                system.debug('dateProcessRec-->'+dateProcessRec);
                dateProcessRec.Attribute1__c = string.valueof(date.today());
                update dateProcessRec;
            }
            catch(Exception ex){
                dateProcessRec.Attribute1__c = string.valueof(system.now());
                dateProcessRec.Key__c = 'ApprovalAuthCode_LastProcessed';
                insert dateProcessRec;
            }     
            system.debug('dateprocessRec >>'+dateProcessRec.Attribute1__c);
            system.debug('Approval Auth Codes before deserializeStrict responseBody-->'+responseBody);
            CG_SiebelApprovalAuthCodeResponseJ2A approvalAuthCodeResponse;
            approvalAuthCodeResponse = (CG_SiebelApprovalAuthCodeResponseJ2A)JSON.deserialize(responseBody, CG_SiebelApprovalAuthCodeResponseJ2A.class);
            Map<String,CSS_JobEventTemporary__c> mapJobEventTemp = new map<String,CSS_JobEventTemporary__c>();
            List<CSS_JobEventTemporary__c> queryJobEventTemp = new List<CSS_JobEventTemporary__c>();
            queryJobEventTemp = [select Attribute1__c,Attribute2__c,Attribute3__c,Attribute4__c,Active__c,Key__c from CSS_JobEventTemporary__c where Key__c = 'ApprovalAuthCode'];

            if(approvalAuthCodeResponse.DataArea !=null)
                for(CG_SiebelApprovalAuthCodeResponseJ2A.DataArea a : approvalAuthCodeResponse.DataArea){
                    CSS_JobEventTemporary__c jobEventTemp = new CSS_JobEventTemporary__c();

                    jobEventTemp.Attribute1__c = a.WWID;
                    jobEventTemp.Attribute2__c = a.FirstName;
                    jobEventTemp.Attribute3__c = a.LastName;
                    jobEventTemp.Attribute4__c = a.ApprovalCode;
                    jobEventTemp.Attribute5__c = a.ApprovalCodeActiveFlag;

                    jobEventTemp.Active__c = true;
                    jobEventTemp.Key__c = eventType;
                    jobEventTemp.Reason__c = JSON.serialize(a.AuthCode);
                    mapJobEventTemp.put(jobEventTemp.Attribute1__c.toUpperCase(),jobEventTemp);

                }

            for(CSS_JobEventTemporary__c J:queryJobEventTemp){
                CSS_JobEventTemporary__c jobEventAppCodes = new  CSS_JobEventTemporary__c();
                String tempAttribute1;
                if(J.Attribute1__c != null && J.Attribute1__c != '')
                    tempAttribute1 = J.Attribute1__c.toUpperCase();
                else
                    tempAttribute1 = '';
                if(mapJobEventTemp.containsKey(tempAttribute1)){
                    jobEventAppCodes = mapJobEventTemp.get(tempAttribute1);
                    jobEventAppCodes.Id = J.Id;
                    jobEventAppCodes.Active__c = true;
                    //Active Acc Codes
                    mapJobEventTemp.put(tempAttribute1,jobEventAppCodes);
                }else{
                    jobEventAppCodes.Id = J.Id;
                    jobEventAppCodes.Active__c = false;
                    //Inactive Acc codes
                    mapJobEventTemp.put(tempAttribute1,jobEventAppCodes);
                }
            }
            if(mapJobEventTemp.size() > 0){
                system.debug('List size in If is'+mapJobEventTemp.size());
                system.debug('mapJobEventTemp--->'+mapJobEventTemp);
                upsert mapJobEventTemp.values();
            }
        }


        else if(eventType == 'MarketingApplicationCodes'){
            CSS_JobEventTemporary__c dateProcessRecAppCode = new CSS_JobEventTemporary__c();
            try{
                dateProcessRecAppCode = [SELECT Id, Attribute1__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'ApplicationCodes_LastProcessed' limit 1];
                system.debug('dateProcessRecAppCode-->'+dateProcessRecAppCode);
                dateProcessRecAppCode.Attribute1__c = string.valueof(date.today());
                update dateProcessRecAppCode;
            }
            catch(Exception ex){
                dateProcessRecAppCode.Attribute1__c = string.valueof(system.now());
                dateProcessRecAppCode.Key__c = 'ApplicationCodes_LastProcessed';
                insert dateProcessRecAppCode;
            }     
            system.debug('dateProcessRecAppCode >>'+dateProcessRecAppCode.Attribute1__c);
            system.debug('ApplicationCodes before deserializeStrict responseBody-->'+responseBody);
            CG_SBL_GetApplicationcodeResWrapper applicationCodeResponse;
            applicationCodeResponse = (CG_SBL_GetApplicationcodeResWrapper)JSON.deserialize(responseBody, CG_SBL_GetApplicationcodeResWrapper.class);
            system.debug('after deserializeStrict applicationCodeResponse-->'+applicationCodeResponse);

            Map<String,CSS_JobEventTemporary__c> mapJobEventTempAppCode = new map<String,CSS_JobEventTemporary__c>();
            List<CSS_JobEventTemporary__c> queryJobEventTempAppCode = new List<CSS_JobEventTemporary__c>();
            queryJobEventTempAppCode = [select Attribute1__c,Attribute2__c,Attribute3__c,Attribute5__c,Attribute6__c,Active__c,Key__c from CSS_JobEventTemporary__c where Key__c = :eventType];

            if(applicationCodeResponse.DataArea !=null){
                integer i = 0;
                for(CG_SBL_GetApplicationcodeResWrapper.DataArea AC : applicationCodeResponse.DataArea){
                    i++;
                    system.debug('count-->'+i);
                    String UniqueApplicationCode = AC.MarketingApplicationCode + ':' + AC.ProductApplicationCode + ':' + AC.MarketingApplicationDescription;
                    CSS_JobEventTemporary__c jobEventTempAC = new CSS_JobEventTemporary__c();

                    jobEventTempAC.Attribute1__c = AC.MarketingApplicationCode;
                    jobEventTempAC.Attribute2__c = AC.ProductApplicationCode;
                    jobEventTempAC.Attribute3__c = AC.MarketingApplicationDescription;
                    jobEventTempAC.Attribute5__c = AC.ProductApplicationDescription;
                    jobEventTempAC.Attribute6__c = AC.ProductFamilyCode;
                    jobEventTempAC.Active__c = true;
                    jobEventTempAC.Key__c = eventType;
                    mapJobEventTempAppCode.put(UniqueApplicationCode,jobEventTempAC);
 system.debug('jobEventTempAC----->>'+jobEventTempAC);
                }
            }
             system.debug('mapJobEventTempAppCode Size----->>'+mapJobEventTempAppCode.size());
             system.debug('mapJobEventTempAppCode----->>'+mapJobEventTempAppCode);
             system.debug('mapJobEventTempAppCode----->>'+mapJobEventTempAppCode.keyset());
            for(CSS_JobEventTemporary__c J:queryJobEventTempAppCode){
                system.debug('JJ hmmmm JJJ ' + J);
                CSS_JobEventTemporary__c jobEventAppCodes= new  CSS_JobEventTemporary__c(); 
                string UniqueApplicationCode1 = J.Attribute1__c + ':' + J.Attribute2__c + ':' + J.Attribute3__c ;
                system.debug('JJ hmmmm JJJ ' + UniqueApplicationCode1);
                if(mapJobEventTempAppCode.containsKey(UniqueApplicationCode1)){
                    jobEventAppCodes = mapJobEventTempAppCode.get(UniqueApplicationCode1);
                    system.debug('JJ JJ jobEventAppCodes ' + jobEventAppCodes);
                    jobEventAppCodes.Id = J.Id;
                    jobEventAppCodes.Active__c = true;
                    system.debug('Unique key if-->'+UniqueApplicationCode1);
                    system.debug('Unique key if-->'+jobEventAppCodes);
                    //Active FailCodes
                    mapJobEventTempAppCode.put(UniqueApplicationCode1,jobEventAppCodes);
                }else{
                   jobEventAppCodes.Id = J.Id;
                   jobEventAppCodes.Active__c = false;
                    //Inactive FailCodes
                    mapJobEventTempAppCode.put(UniqueApplicationCode1,jobEventAppCodes);
                     system.debug('Unique key else-->'+UniqueApplicationCode1);
                    system.debug('Unique key else-->'+jobEventAppCodes);
                }
            }
            if(mapJobEventTempAppCode.size() > 0){
                integer j=0;
                for(String st : mapJobEventTempAppCode.keyset()){
                    j++;
                    system.debug('inside map loop-->'+j+' --> '+st);
                }
                system.debug('List size in If is'+mapJobEventTempAppCode.size());
                system.debug('mapJobEventTempAppCode--->'+mapJobEventTempAppCode);
                upsert mapJobEventTempAppCode.values();
                system.debug('mapJobEventTempAppCode--->'+mapJobEventTempAppCode);
            }
        }

        else {
            jobEventList = new List<CSS_JobEventTemporary__c>([Select Id, Name from CSS_JobEventTemporary__c where Name=:eventType limit 1]);
            if(jobEventList.size()>0){
                jobEventObj = jobEventList.get(0);
                jobEventObj.Reason__c = responseBody;
                jobEventObj.Attribute13__c = Date.today();
                update jobEventObj;
            }else{
                jobEventObj = new CSS_JobEventTemporary__c();
                jobEventObj.Reason__c = responseBody;
                jobEventObj.Attribute13__c = Date.today();
                jobEventObj.Attribute1__c = eventType;  
                jobEventObj.Name = eventType;
                //jobEventObj.Key__c = Date.today();
                insert jobEventObj;
            }
        }
        System.debug('Response is inserted/updated successfully...');
        /*}catch(Exception ex){
System.debug('in catch of insertResponse of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
css_utility.LogOutIntError('CSS_FN_SIEBEL-insertResponse', 'CSS_JobEventTemporary__c insertion failed', 'CSS_JobEventTemporary__c insertion failed', 'SBL');
}finally{
jobEventList=null;
}*/
    }

    public static CSS_Solution_Component__c getWarrantyDetailCoverage(string PSN, string spCode, date failureDate, string failurePoint, string failureMeasure, string engAppCode, date warrStartDt, string sysCode, string compCode, string faultCode, string accCode, ID compID, Boolean compParentChkbox, string campaignNum, string partsWarrantyFlg, string calledFrom, string reconFlag, boolean Isclaim, String Name){
        System.debug('################# entered into getWarrantyDetailCoverage method ###################');
        system.debug('accCode--'+accCode);

        String endPointURL;
        CG_IP_OAGWrapper reqWrapper;
        CG_OP_OAGWrapper outputWrapper;

        CSS_WPR_SBL_GetWarrantyReqJSON warrantyReqJSON = new CSS_WPR_SBL_GetWarrantyReqJSON();
        CSS_WPR_SBL_GetWarrantyResJSON warrantyResJSON = new CSS_WPR_SBL_GetWarrantyResJSON();

        CSS_WPR_SBL_GetWarrantyReqJSON.Header headerObj = new CSS_WPR_SBL_GetWarrantyReqJSON.Header();
        CSS_WPR_SBL_GetWarrantyReqJSON.Sender senderObj = new CSS_WPR_SBL_GetWarrantyReqJSON.Sender();
        CSS_WPR_SBL_GetWarrantyReqJSON.DataArea dataAreaObj = new CSS_WPR_SBL_GetWarrantyReqJSON.DataArea();
        CSS_WPR_SBL_GetWarrantyReqJSON.Details lstDetailswrap = new CSS_WPR_SBL_GetWarrantyReqJSON.Details();

        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        system.debug('compID-->'+compID);
        try{
            //calling getAccessToken Service
            //String accessToken = CSS_WS_OAG.getAccessToken();
            //Commented for dynamic Authentication and added below lines
            //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_WarrantyDetailCoverage').AuthEnv__c);
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_WarrantyDetailCoverage').AuthEnv__c,'CSS_SBL_WarrantyDetailCoverage');
                    String accesstoken = accessTokenOPWrap.accessToken;
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken) ){
                //css_utility.LogOutIntError('CSS_FN_SIEBEL-'+serviceName, 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                //return null;
            }
            senderObj.MessageID = 'UniqueID';
            senderObj.ServiceName = 'AccCoverage';
            senderObj.SenderID = 'CSS';

            headerObj.Sender =  senderObj;
            warrantyReqJSON.Header = headerObj;

            dataAreaObj.Esn = PSN;
            if(spCode != null && spCode != '')
                dataAreaObj.spcode = (spCode).right(5);
            else
                dataAreaObj.spcode = '';
            Date dtFailure = failureDate;
            if(dtFailure != null){
                //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                string failureDt = DateTime.newInstance(dtFailure.year(),dtFailure.month(),dtFailure.day()).format('MM/d/yyyy');
                dataAreaObj.FailureDate = failureDt;
            }
            else
                dataAreaObj.FailureDate = '';
            if(failurePoint != null && failurePoint != '')
                dataAreaObj.FailurePoint = string.valueof(failurePoint);
            else
                dataAreaObj.FailurePoint = '';
            dataAreaObj.FailureMeasure = failureMeasure;
            dataAreaObj.EngineApplicationCode = engAppCode;

            dataAreaObj.FaultCode = ''; //this field is blank as of now & it is for future usage
            Date dtWarrantyStart = warrStartDt;
            if(dtWarrantyStart != null){
                 //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
                string warrantyStartDate = DateTime.newInstance(dtWarrantyStart.year(),dtWarrantyStart.month(),dtWarrantyStart.day()).format('MM/d/yyyy');
                dataAreaObj.WarrantyStartDate = warrantyStartDate;
            }
            else
                dataAreaObj.WarrantyStartDate = '';
            if(campaignNum == null){
                campaignNum = '';
            }
            dataAreaObj.CampaignNumber = campaignNum; //this field is blank as of now & it is for future usage

            system.debug('campaignNum--'+campaignNum);

            if(partsWarrantyFlg == 'New Parts Warranty'){
                dataAreaObj.NewPartsWrntyFlg = 'Y';
                dataAreaObj.ReconPartsWrntyFlg = 'N';
            }
            else{
                if(partsWarrantyFlg == 'Recon Parts Warranty'){
                    dataAreaObj.ReconPartsWrntyFlg = 'Y';
                    dataAreaObj.NewPartsWrntyFlg = 'N';
                }
                else{
                    dataAreaObj.ReconPartsWrntyFlg = 'N';
                    dataAreaObj.NewPartsWrntyFlg = 'N';
                }
            }
            //Pass RRW Flag as Y when Account code is Service Tool Warranty
            if(accCode !=null  && accCode.contains('52')){
                dataAreaObj.RoadRelayWrntyFlg = 'Y';
            }
            else{
                dataAreaObj.RoadRelayWrntyFlg = 'N';
            }

            //dataAreaObj.RoadRelayWrntyFlg = 'N';
            system.debug('RoadRelayWrntyFlg--'+dataAreaObj.RoadRelayWrntyFlg);

            // Satish defect# 119170
            if (faultCode == null)
                faultCode = '';

            dataAreaObj.FaultCode = faultCode;
            system.debug('accCodekarrhik'+accCode); 
            system.debug('reconFlag--'+reconFlag);
            system.debug('accCode-'+accCode);
            // stroy no 182152 Zootopia,recon Engine and no FA + Karthik G Added as part of 190587.
            if(!isclaim) {
                if(reconFlag == 'Y' && campaignNum == '' && (accCode==null || accCode=='')){ //Added accCode==null condition for the defect#191665 
                    dataAreaObj.AccountCode = '98';
                }
                else if(accCode != null && campaignNum == ''){
                    dataAreaObj.AccountCode = accCode;
                }
                else{
                    dataAreaObj.AccountCode = '';
                }
            } else {
                if(reconFlag == 'Y' && campaignNum == '' && (accCode==null || accCode=='')){ //Added accCode==null condition for the defect#191665
                    dataAreaObj.AccountCode = '98';
                }
                else if(accCode != null && campaignNum == ''){
                    dataAreaObj.AccountCode = accCode;
                }

                else{
                    dataAreaObj.AccountCode = '';
                }
            }
            system.debug('accCode2--'+dataAreaObj.AccountCode);

            dataAreaObj.Details = new List<CSS_WPR_SBL_GetWarrantyReqJSON.Details>();
            warrantyReqJSON.DataArea =  dataAreaObj;

            lstDetailswrap.SystemCode = sysCode;
            lstDetailswrap.ComponentCode = compCode;
            warrantyReqJSON.DataArea.Details.add(lstDetailswrap);
            system.debug('compID-->'+compID);
            //Prepare Request JSON
            String warrantyReqJSONStr = JSON.serialize(warrantyReqJSON);
            System.debug('warrantyReqJSONStr>>>>>>>>>>>>>>>>>>>>:'+warrantyReqJSONStr);
            
            CSS_Integration_Details__c connection = new CSS_Integration_Details__c ();
            if(connection != null && !Test.isRunningTest()){
                connection = CSS_getConnnectionDetails.getConnection('CSS_SBL_WarrantyDetailCoverage');
                endPointURL = connection.End_Point__c;                
            }
            else{
                endPointURL = 'https://services-dev.cummins.com/csswarranty/accodecoverage'; 
            }
            
            //endPointURL = CSS_getConnnectionDetails.getConnection('CSS_SBL_WarrantyDetailCoverage').End_Point__c;
            //endPointURL = 'Hello';
             HttpResponse httpRes;
             string jsonRespBody;
            //
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_WarrantyDetailCoverage');
            reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.jsonReqBody = warrantyReqJSONStr;
            reqWrapper.serviceName = conDetails.ApplicationName__c;
            reqWrapper.methodType = conDetails.Method_Type__c;
            reqWrapper.endPoint = conDetails.End_Point__c;
           // outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
           // HttpResponse httpRes = outputWrapper.response;

            
            
            //
            try{
               // httpRes = CSS_WS_OAG.executeRESTWebservice(warrantyReqJSONStr, endPointURL, accessToken);
               if(!Test.isRunningTest()){
                   outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                   httpRes = outputWrapper.response;
               }
               else{
                   jsonRespBody = '{'+
'  "Header":{'+
'    "Status":"Success",'+
'    "ReturnCodeDescription":""'+
'  },'+
'  "DataArea":{'+
'    "Details":['+
'      {'+
'        "DeductibleAmount":0,'+
'        "CampaignTravelPercentage":100,'+
'        "Status":"Success",'+
'        "CampaignPartsPercentage":100,'+
'        "Message":"",'+
'        "ComponentCode":"SS",'+
'        "SystemCode":"WU",'+
'        "CampaignLaborPercentage":100,'+
'        "CoveredTowingMiles":0,'+
'        "CoveredTravelMiles":0,'+
'        "WarrantyId":"",'+
'        "CoveredMealsLodgingAmt":0,'+
'        "CoveredLaborHrs":0,'+
'        "CampaignOCPercentage":100,'+
'        "CoveredTravelLabor":0,'+
'        "CampaignTowingPercentage":0,'+
'        "PayCode":"X",'+
'        "AccountCodeType":"CMP Field Actions",'+
'        "CoveredPartsQty":0,'+
'        "CoveredTravelBaseFareAmt":"0",'+
'        "AccountCode":"65",'+
'        "CertificateNumber":"",'+
'        "CoveredOCAmount":0'+
'      }'+
'    ],'+
'    "AccountCodeType":"Field Actions",'+
'    "AccountCode":"65"'+
'  }'+
'}';
                   httpRes = new HttpResponse();
                   httpRes.setHeader('Content-Type', 'application/json');
                   httpRes.setBody(jsonRespBody);
                   httpRes.setStatusCode(200);
               }
                system.debug('outputWrapper--'+outputWrapper);
                system.debug('test class1'+httpRes);
            }
            catch(Exception e){
                system.debug('Inside Catch--'+e.getMessage()+' '+e.getLineNumber());
                solComp.AccountCode__c='';
                solComp.AccountCodeType__c='';
                solComp.Id = compID;
                //if(!(calledFrom.contains('Claims'))){
                solComp.Selected_Component__c = compParentChkbox;
                //}
                solComp.AccountCode_Call_Status__c = 'Failure';  

                CSS_Integration_Error__c errorObjLog = new  CSS_Integration_Error__c();
                system.debug('errorObjLog');
                errorObjLog.Processed_Data__c =  warrantyReqJSONStr;
                errorObjLog.Response_Body__c =   httpRes.getBody(); //(httpRes.getBody() != null && httpRes.getBody() != '')?httpRes.getBody():'The Response body is Null, Check with Middleware team'; 
                errorObjLog.Source__c= 'Siebel';
                errorObjLog.Service_Name__c = 'getWarrantyDetailCoverage';
                errorObjLog.Service_Job_Number__c= Name;
                insert errorObjLog;
                system.debug('errorObjLog'+errorObjLog);
                //return null;
                return solComp;
            }
            system.debug('compID-->'+compID);
            if(httpRes == null || httpRes.getStatusCode() != 200){
                solComp.AccountCode__c='';
                solComp.AccountCodeType__c='';
                solComp.Id = compID;
                //if(!(calledFrom.contains('Claims'))){
                solComp.Selected_Component__c = compParentChkbox;
                //}
                solComp.AccountCode_Call_Status__c = 'Failure';  
                CSS_Integration_Error__c errorObjLog1 = new  CSS_Integration_Error__c();
                system.debug('errorObjLog');
                errorObjLog1.Processed_Data__c =  warrantyReqJSONStr;
                errorObjLog1.Response_Body__c =   httpRes.getBody(); //(httpRes.getBody() != null && httpRes.getBody() != '')?httpRes.getBody():'The Response body is Null, Check with Middleware team'; 
                errorObjLog1.Source__c= 'Siebel';
                errorObjLog1.Service_Name__c = 'getWarrantyDetailCoverage';
                errorObjLog1.Service_Job_Number__c= Name;
                insert errorObjLog1;
                //css_utility.LogOutIntError('CSS_FN_SIEBEL-WarrantyDetailCoverage', 'WarrantyDetailCoverage HttpResponse is null', 'WarrantyDetailCoverage Webservice Execution failed', 'SBL');
                //return null;
                return solComp;
            }
            system.debug('httpRes '+httpRes );
            //System.debug('RESPONSE_BODY>>>:'+httpRes.getbody()+' httpRes getStatusCode is :: '+httpRes.getStatusCode()+' httpRes.toString>>>:'+httpRes.toString());
            //system.debug('Body'+httpRes.getBody());
            if(httpRes != null){
                system.debug('Inside IF');
                system.debug('httpRes '+httpRes.getBody());
                
                warrantyResJSON =  (CSS_WPR_SBL_GetWarrantyResJSON)JSON.deserializeStrict(httpRes.getBody(), CSS_WPR_SBL_GetWarrantyResJSON.class);
            }
            System.debug('warrantyResJSON>>>>>>>>>>>>>>>>>>>>:'+warrantyResJSON);

            //below logic on response data 
            system.debug('warrantyResJSON--'+warrantyResJSON.DataArea);
            Map<string,string> mapAccCode = new Map<string,string>();

            if(warrantyResJSON.DataArea!=null){
                system.debug('compID-->'+compID);

                /*if(calledFrom=='First Call'){
                    solComp.AccountCode__c=warrantyResJSON.DataArea.AccountCode;
                    solComp.AccountCodeType__c=warrantyResJSON.DataArea.AccountCodeType;
                    system.debug('Inside1***'+solComp.AccountCode__c);}
                if(calledFrom=='Second Call'){
                    solComp.AccountCode__c = '';
                    solComp.AccountCodeType__c = '';
                    solComp.AccountCodeEdit__c=warrantyResJSON.DataArea.AccountCodeType+' '+warrantyResJSON.DataArea.AccountCode;

                    system.debug('Inside2***'+solComp.AccountCodeEdit__c);
                }*/

                system.debug('mapAccCode--'+mapAccCode);

                if(mapAccCode != null && !mapAccCode.isEmpty()){
                    system.debug('mapAccCode not null--'+mapAccCode);
                    if(warrantyResJSON.DataArea.AccountCode != null && warrantyResJSON.DataArea.AccountCode != ''){
                        solComp.AccountCodeEdit__c = mapAccCode.get(warrantyResJSON.DataArea.AccountCode) + ' ' + warrantyResJSON.DataArea.AccountCode;
                        solComp.AccountCode__c = warrantyResJSON.DataArea.AccountCode;
                        solComp.AccountCodeType__c = mapAccCode.get(warrantyResJSON.DataArea.AccountCode);
                    }
                }
                else{
                    mapAccCode = getAccountCodeType();
                    system.debug('mapAccCode null--'+mapAccCode);
                    system.debug('warrantyResJSON.DataArea.AccountCode--'+warrantyResJSON.DataArea.AccountCode);
                    if(warrantyResJSON.DataArea.AccountCode != null && warrantyResJSON.DataArea.AccountCode != ''){
                        solComp.AccountCodeEdit__c = mapAccCode.get(warrantyResJSON.DataArea.AccountCode) + ' ' + warrantyResJSON.DataArea.AccountCode;
                        solComp.AccountCode__c = warrantyResJSON.DataArea.AccountCode;
                        solComp.AccountCodeType__c = mapAccCode.get(warrantyResJSON.DataArea.AccountCode);
                    }
                }

                system.debug('DataAreaDetails1'+warrantyResJSON.DataArea.Details);
                if(!Test.isRunningTest()){
                    solComp.Id = compID;                
                    //if(!(calledFrom.contains('Claims'))){

                    solComp.Selected_Component__c = compParentChkbox;
                    solComp.GetAccountCodeServiceRun__c = true;
                    //}
                    solComp.AccountCode_Call_Status__c = 'Success';
                }
                system.debug('DataAreaDetails'+warrantyResJSON.DataArea.Details);
                for(CSS_WPR_SBL_GetWarrantyResJSON.Details det : warrantyResJSON.DataArea.Details){
                    solComp.CoveredLaborHrs__c=det.CoveredLaborHrs;
                    solComp.CoveredMealsLodgingAmt__c=det.CoveredMealsLodgingAmt;
                    solComp.CoveredOCAmount__c=det.CoveredOCAmount;
                    solComp.CoveredPartsQty__c=det.CoveredPartsQty;
                    solComp.CoveredTowingMiles__c=det.CoveredTowingMiles;
                    solComp.CoveredTravelLabor__c=det.CoveredTravelLabor;
                    solComp.CoveredTravelMiles__c=det.CoveredTravelMiles;   
                    solComp.CampaignPartsPercentage__c=det.CampaignPartsPercentage; //Kalpana: Added as per story# 118800
                    solComp.CoveredTravelBaseFareAmt__c=det.CoveredTravelBaseFareAmt; 
                    //solComp.pay_code__c=det.PayCode; // Kalpana Added as per Story#115014

                    if(det.PayCode !=null && det.PayCode.trim() !='' ){
                        solComp.Pay_Code__c = det.PayCode;
                    }else if(det.PayCode==''){
                        string userType = css_Utility.getOrgType(userinfo.getUserId());
                        if(userType!=null && userType!= '' && userType == 'DLR') {
                            solComp.Pay_Code__c = 'D';
                        }
                    }

                    solComp.WarrantyId__c = det.WarrantyId;
                    solComp.CampaignLaborPercentage__c = det.CampaignLaborPercentage;
                    solComp.CampaignOCPercentage__c = det.CampaignOCPercentage;
                    solComp.CampaignPartsPercentage__c = det.CampaignPartsPercentage;
                    solComp.CampaignTowingPercentage__c = det.CampaignTowingPercentage;
                    solComp.CampaignTravelPercentage__c = det.CampaignTravelPercentage;
                    solComp.DeductibleAmount__c = det.DeductibleAmount;
                    solComp.CertificateNumber__c = det.CertificateNumber;//This one we are going to pass the CAP Claims
                    break;
                }               
            }            
            else{
                system.debug('***insidewarrantyjsonelse****');
                solComp.AccountCode__c='';
                solComp.AccountCodeType__c='';
                solComp.Id = compID;
                //if(!(calledFrom.contains('Claims'))){
                solComp.Selected_Component__c = compParentChkbox;
                //}
                if(httpRes.getStatusCode() != 200){
                    solComp.AccountCode_Call_Status__c = 'Failure';
                    CSS_Integration_Error__c errorObjLog2 = new  CSS_Integration_Error__c();
                    system.debug('errorObjLog2');
                    errorObjLog2.Processed_Data__c =  warrantyReqJSONStr;
                    errorObjLog2.Response_Body__c =   httpRes.getBody(); //(httpRes.getBody() != null && httpRes.getBody() != '')?httpRes.getBody():'The Response body is Null, Check with Middleware team'; 
                    errorObjLog2.Source__c= 'Siebel';
                    errorObjLog2.Service_Name__c = 'getWarrantyDetailCoverage';
                    errorObjLog2.Service_Job_Number__c= Name;
                    //errorObjLog2.Service_Call_Time__c = integer.valueof(system.today());
                    //errorObjLog.Login User Name =
                    insert errorObjLog2;
                }
                else
                    solComp.AccountCode_Call_Status__c = 'Success';        
            }
            system.debug('going to return solcomp'+solComp);
            return solComp;

        }
        catch(Exception ex){
            System.debug('in catch of getWarrantyDetailCoverage of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            //css_utility.LogOutIntError('CSS_FN_SIEBEL-WarrantyDetailCoverage', 'HttpResponse is null', 'Webservice Execution failed', 'SBL'); 
        }
        return null;
    }

    public static Map<string,string> getAccountCodeType(){
        List<CSS_JobEventTemporary__c> jobeventTemp = [SELECT Id, Name, Key__c, Attribute1__c, Attribute2__c, Attribute3__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes'];    

        Map<string,string> mapAccountCodes = new Map<string,string>();

        for(CSS_JobEventTemporary__c joTemp : jobeventTemp){
            if(jobeventTemp != null && jobeventTemp.size() > 0){
                mapAccountCodes.put(joTemp.Attribute3__c,joTemp.Attribute2__c);
            }
        }

        system.debug('mapAccountCodes inside method--'+mapAccountCodes);
        return mapAccountCodes;
    }

    @InvocableMethod(label='fetchSPDataClaims' description='make callout to fetch Service Provider details.') 
    public static void fetchSPDataClaims(List<String> spCode_SMName_FDate){
        List<String> spCode_SMName_FDate_Lst = new List<String>();
        List<String> spCode_Lst = new List<String>();
        spCode_SMName_FDate_Lst = spCode_SMName_FDate[0].split(';;');
        spCode_Lst = spCode_SMName_FDate_Lst[0].split('-');
        //Id ServiceJobID = spCode_SMName_FDate_Lst[3];
        Date FailureDate = date.valueOf(spCode_SMName_FDate_Lst[2]);
        string FailureDateString = DateTime.newInstance(FailureDate.year(),FailureDate.month(),FailureDate.day()).format('dd-MMM-YY'); 
        getServiceProviderDataClaims(spCode_Lst[1], spCode_SMName_FDate_Lst[1], FailureDateString, spCode_SMName_FDate_Lst[3]);
    }    



    /**
* Method to get service provider data from siebel
* 
*/
    @future(callout=true)
    public static void getServiceProviderData(string SPCode,string ServiceModelName,string FailureDate, string jobId){
        CSS_GetServiceProviderResponse serviceProviderResponse = new CSS_GetServiceProviderResponse();
        try{
            CSS_GetServiceProviderResponse rep = getServiceProviderDataWrapper(SPCode,ServiceModelName,FailureDate,jobId);
            system.debug('deserialized Response --->'+rep);
            CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
            if(!Test.isRunningTest()){
                jobOrder.id = jobId; } 

            jobOrder.CSS_Channel_Code__c = rep.DataArea.ChannelCode;
            jobOrder.CSS_Channel_Of_Distribution__c = rep.DataArea.ChannelOfDistribution;
            jobOrder.CSS_Travel_Rate__c = rep.DataArea.TravelRate;
            jobOrder.CSS_In_Shop_Labor_Rate__c = rep.DataArea.InShopLaborRate;
            jobOrder.CSS_Field_Service_Labor_Rate__c = rep.DataArea.FieldServiceLaborRate;
            jobOrder.Territory_Class__c = rep.DataArea.TerritoryCode;
            jobOrder.Territory_Class_Name__c = rep.DataArea.Territory;
            system.debug('jobOrder>>>>>>>>>> ' + jobOrder);
            update jobOrder;
            //return spResponse;
        }
        catch(Exception ex){
            System.debug('in catch of getServiceProviderData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

        //return null;
    }

    //Method to get service provider data for claims from siebel
    public static string getServiceProviderDataClaims(string SPCode,string ServiceModelName,string FailureDate, string claimsId){
        CSS_GetServiceProviderResponse serviceProviderResponse = new CSS_GetServiceProviderResponse();
        try{
            //if(claimsId == null){
                CG_CL_ClaimsTriggerHandler.flag=true;
                CSS_GetServiceProviderResponse rep = getServiceProviderDataWrapper(SPCode,ServiceModelName,FailureDate,claimsId);
                system.debug('deserialized Response --->'+rep);
                system.debug('channelofdist Response --->'+rep.DataArea.ChannelOfDistribution);
                system.debug('territorycode Response --->'+rep.DataArea.TerritoryCode);
                system.debug('territory Response --->'+rep.DataArea.Territory);

                String channelCode = rep.DataArea.ChannelCode;
                String channelOFDist = rep.DataArea.ChannelOfDistribution;
                String terClass = rep.DataArea.TerritoryCode;
                String terClassName = rep.DataArea.Territory;
                String promoId = rep.DataArea.PromotionId;
                //Kalpana: Added the below 3 lines of code to map the values
                String TravelRate = rep.DataArea.TravelRate;
                String InShopLaborRate = rep.DataArea.InShopLaborRate;
                String FieldServiceLaborRate = rep.DataArea.FieldServiceLaborRate;
                String paccarFlag = rep.DataArea.PACCAR;
                String regionValue = rep.DataArea.Region;
                String territoryValue = rep.DataArea.Territory;
                String claimAllowedDaysValue = rep.DataArea.ClaimAllowedDays;
                //String finalRetStr = channelCode +'_'+channelOFDist+'_'+terClass+'_'+terClassName+'_'+promoId;
                String finalRetStr = channelCode +'_'+channelOFDist+'_'+terClass+'_'+terClassName+'_'+promoId+'_'+TravelRate+'_'+InShopLaborRate+'_'+FieldServiceLaborRate+'_'+paccarFlag+'_'+regionValue+'_'+territoryValue+'_'+claimAllowedDaysValue+'_'+rep.DataArea.ProductCertification;
                system.debug('finalRetStr>>>>>>>> ' + finalRetStr);

                return finalRetStr;
            //}
            /*else{
                system.debug('***inside else-getserviceproviderdataclaims');
                CG_CL_ClaimsTriggerHandler.flag=true;
                CSS_GetServiceProviderResponse rep = getServiceProviderDataWrapper(SPCode,ServiceModelName,FailureDate,claimsId);
                system.debug('deserialized Response --->'+rep);
                system.debug('channelofdist Response --->'+rep.DataArea.ChannelOfDistribution);
                system.debug('territorycode Response --->'+rep.DataArea.TerritoryCode);
                system.debug('territory Response --->'+rep.DataArea.Territory);

                CSS_Claims__c claimsObj = new CSS_Claims__c();
                claimsObj.id = claimsId;
                claimsObj.CSS_Channel_Code__c = rep.DataArea.ChannelCode;
                claimsObj.CSS_Channel_Of_Distribution__c = rep.DataArea.ChannelOfDistribution;
                claimsObj.Territory_Class__c = rep.DataArea.TerritoryCode;
                claimsObj.Territory_Class_Name__c = rep.DataArea.Territory;
                claimsObj.SP_PromotionId__c = rep.DataArea.PromotionId;
                claimsObj.CSS_Travel_Rate__c = rep.DataArea.TravelRate; //Kalpana: Added the below 3 lines of code to map the values
                claimsObj.SP_INSHOP_LABOR_RATE__c = rep.DataArea.InShopLaborRate;
                claimsObj.SP_FIELD_SERVICE_LABOR_RATE__c = rep.DataArea.FieldServiceLaborRate;
                claimsObj.Product_Certification__c = rep.DataArea.ProductCertification;
                claimsObj.SP_ProductCertification__c = rep.DataArea.ProductCertification;
                claimsObj.SP_PACCAR__c = rep.DataArea.PACCAR;
                claimsObj.Region__c = rep.DataArea.Region;
                claimsObj.Territory__c = rep.DataArea.Territory;
                claimsObj.SP_CLAIM_ALLOWED_DAYS__c = rep.DataArea.ClaimAllowedDays;
                system.debug('jobOrder>>>>>>>>>> ' + claimsObj);
                //update claimsObj;
                system.debug('jobOrder1>>>>>>>>>> ' + claimsObj);
                return null;
            }*/

        }
        catch(Exception ex){
            System.debug('in catch of getServiceProviderDataClaims of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            return null;
        }        
    }

    public CSS_Job_Order__c getServiceProviderDataIntake(CSS_Job_Order__c jobOrder, string SPCode,string ServiceModelName,Date FailureDate, string jobId){
        CSS_GetServiceProviderResponse serviceProviderResponse = new CSS_GetServiceProviderResponse();
        CG_OP_OAGWrapper outputWrapper;
        try{
            Datetime startDt;
            Datetime endDt;
            Long totalTime;
            Datetime AuthStartTime;
            Datetime AuthEndtime;
            Long AuthTotalTime;
            if(FailureDate == null)
                FailureDate = Date.Today();
            string FailureDateString = DateTime.newInstance(FailureDate.year(),FailureDate.month(),FailureDate.day()).format('dd-MMM-YY');
            //calling getAccessToken Service
            AuthStartTime = System.now();
            //String accessToken = CSS_WS_OAG.getAccessToken();
            //Commented for dynamic Authentication and added below lines
            // CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').AuthEnv__c);
             CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').AuthEnv__c,'CSS_SPDataLookup');//Added By Prabhakar OAG to Mule 19/05/2020
            String accesstoken = accessTokenOPWrap.accessToken;
            AuthEndtime = System.now();
            AuthTotalTime = AuthStartTime.getTime() - AuthEndtime.getTime();
            List<String> spCode_Lst = new List<String>();
            spCode_Lst = SPCode.split('-');

            SPCode = spCode_Lst[1];
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                css_utility.LogOutIntError('CSS_FN_SIEBEL-getServiceProviderData', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                //return null;
            }
            /***** Preparing the Request Wrapper Class for getServiceProviderData****/
            CSS_GetServiceProviderRequest requestWrap = prepareReqJSONForGetSrvcProvider(SPCode,'',FailureDateString);
            String serviceProviderJSONReqBody = JSON.serialize(requestWrap);
            system.debug('jsonreq Spdata req ---->'+serviceProviderJSONReqBody);
            //calling getServiceProviderData webservice
            String endPointURL = CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').End_Point__c;
            //
            endPointURL = endPointURL+'?sender=CSS&target=CSSWarranty&spCode='+SPCode+'&failureDate='+FailureDateString+'&serviceModelName='+ServiceModelName;//Changed failuredate
            system.debug('*****endPointURL***'+endPointURL);
            //Added for Mule
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup');
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.endPoint = endPointURL.Trim();
            reqWrapper.serviceName = conDetails.ApplicationName__c;
            reqWrapper.methodType = conDetails.Method_Type__c;
            HttpResponse httpRes;
            if(!Test.isRunningTest()){
                outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                system.debug('outputWrapper>>>'+outputWrapper);
                system.debug('outputWrapper.response>>>'+outputWrapper.response);
                httpRes = outputWrapper.response;
            }
            else{
                string jsonRespBody;
                
                jsonRespBody = '{'+
'  "Header":{'+
'    "Status":"SUCCESS",'+
'    "ReturnCode":"",'+
'    "ReturnCodeDescription":"",'+
'    "MessageIdentifier":"debc5930-3a95-4420-bb8c-2695f4398614",'+
'    "MessageType":"S"'+
'  },'+
'  "DataArea":{'+
'    "Policy":"N",'+
'    "GroupName":"",'+
'    "RegionCode":"USCA",'+
'    "PromotionId":"Y",'+
'    "RepairLevel":"N",'+
'    "ViewDollarAmount":"N",'+
'    "PrimaryOEMName":"",'+
'    "AccountStatus":"Active",'+
'    "MaxClaimAmt":"999999",'+
'    "WWSPSSPFlag":"Y",'+
'    "CommunicationOccurrence":"",'+
'    "FreezeSubmitButton":"N",'+
'    "Territory":"UNITED STATES",'+
'    "LTAFlag":"",'+
'    "SPCountry":"USA",'+
'    "CommunicationMethod":"",'+
'    "PACCAR":"N",'+
'    "State":"GA",'+
'    "BusinessUnit":"EBU",'+
'    "Region":"NORTH AMERICA",'+
'    "WarrantyFax":"(770) 431-9692",'+
'    "SCMDollarAmt":"",'+
'    "WarrantyEmail":"robertss1@rushenterprises.com",'+
'    "DistributorHQName":"CSSNA - SOUTH REGION",'+
'    "SCMDeductiblePercentage":"",'+
'    "ChannelCode":"110",'+
'    "DSID":"N",'+
'    "FieldServiceLaborRate":"176",'+
'    "TravelRate":"1.21",'+
'    "ClaimAllowedDays":"365",'+
'    "WarrantyCertificationEndDate":"2019-10-24 00:00:00.0",'+
'    "WarrantyTrainingCertification":"Y",'+
'    "NewOEM":"N",'+
'    "TerritoryCode":"100",'+
'    "PSBUProductCertification":"N",'+
'    "DTNAFlag":"N",'+
'    "ChannelOfDistribution":"110-DEALER",'+
'    "PrimaryOEMCode":"",'+
'    "OutfileAllClaims":"N",'+
'    "DisableWebAccessFlag":"N",'+
'    "ProductCertification":"Y",'+
'    "CutOffClaimAmt":"250",'+
'    "DistributorHQCode":"02930",'+
'    "WarrantyTrainingStatus":"G",'+
'    "CMISPExpirationDate":"2021-03-08 00:00:00.0",'+
'    "InShopLaborRate":"176",'+
'    "CostEffectiveExclusion":"N",'+
'    "PMUSplitPayment":"Y",'+
'    "TechActualHoursRequired":"N",'+
'    "CampaignTRP":"Y"'+
'  }'+
'}';
           httpRes = new HttpResponse();
           httpRes.setHeader('Content-Type', 'application/json');
           httpRes.setBody(jsonRespBody);
           httpRes.setStatusCode(200);
                   
            }
            system.debug('httpRes spdata >>>>>>'+httpRes);
            //
            startDt = System.now();
            //commented below line for Mule
           // HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(serviceProviderJSONReqBody, endPointURL, accessToken);
            endDt = System.now();
            totalTime = endDt.getTime() - startDt.getTime();

            
            CSS_GetServiceProviderResponse rep;
            list<CSS_Integration_Error__c> lstIntErrDetails = new list<CSS_Integration_Error__c>();
            if(httpRes == null || httpRes.getStatusCode() != 200){
                //css_utility.LogOutIntError('CSS_FN_SIEBEL-getServiceProviderData', 'CSS_SPDataLookup HttpResponse is null', 'CSS_SPDataLookup Webservice Execution failed', 'SBL');
                CSS_Integration_Error__c interrDetails = new CSS_Integration_Error__c();

                interrDetails.Auth_Call_Time__c     = AuthTotalTime;
                interrDetails.Processed_Data__c    =  serviceProviderJSONReqBody;
                interrDetails.Response_Body__c     = (httpRes != null ? httpRes.getBody() : '');
                interrDetails.Service_Call_Time__c = totalTime;
                interrDetails.Service_Job_Number__c = jobOrder.Name;
                interrDetails.Service_Name__c = 'getServiceProviderData';
                interrDetails.Source__c = 'Siebel';
                lstIntErrDetails.add(interrDetails);

                if(lstIntErrDetails.size()!=null){
                    system.debug('**insert a record into CSS_Integration_Error__c object with lstIntErrDetails **' + lstIntErrDetails);
                    insert lstIntErrDetails;
                }
                jobOrder.SPDataWebserviceResult__c='Error';
                //return null;
            }
            else{
                rep =  (CSS_GetServiceProviderResponse)JSON.deserializeStrict(httpRes.getBody(), CSS_GetServiceProviderResponse.class);
            }
            //system.debug('deserialized Response --->'+rep);
            //CSS_Job_Order__c jobOrder = new CSS_Job_Order__c();
            //jobOrder.id = jobId;
            if(rep!=null && rep.DataArea != null) {
                jobOrder.CSS_Channel_Code__c = rep.DataArea.ChannelCode;
                jobOrder.CSS_Channel_Of_Distribution__c = rep.DataArea.ChannelOfDistribution;
                jobOrder.CSS_Travel_Rate__c = rep.DataArea.TravelRate;
                jobOrder.CSS_In_Shop_Labor_Rate__c = rep.DataArea.InShopLaborRate;
                jobOrder.CSS_Field_Service_Labor_Rate__c = rep.DataArea.FieldServiceLaborRate;
                jobOrder.Territory_Class__c = rep.DataArea.TerritoryCode;
                jobOrder.Territory_Class_Name__c = rep.DataArea.Territory;
                jobOrder.SP_TerritoryCode__c = rep.DataArea.TerritoryCode;
                jobOrder.Sp_TERRITORY__c = rep.DataArea.Territory;
                jobOrder.SP_AccountStatus__c = rep.DataArea.AccountStatus;
                jobOrder.SP_BusinessUnit__c = rep.DataArea.BusinessUnit;
                jobOrder.SP_CampaignTRP__c = rep.DataArea.CampaignTRP;
                jobOrder.SP_ClaimAllowedDays__c = rep.DataArea.ClaimAllowedDays;
                jobOrder.SP_CMISPExpirationDate__c = rep.DataArea.CMISPExpirationDate;
                jobOrder.SP_CommunicationMethod__c = rep.DataArea.CommunicationMethod;
                jobOrder.SP_CommunicationOccurrence__c = rep.DataArea.CommunicationOccurrence;
                jobOrder.SP_CostEffectiveExclusion__c = rep.DataArea.CostEffectiveExclusion;
                jobOrder.SP_CutOffClaimAmt__c = rep.DataArea.CutOffClaimAmt;
                jobOrder.SP_DisableWebAccessFlag__c = rep.DataArea.DisableWebAccessFlag;
                jobOrder.SP_DistributorHQCode__c = rep.DataArea.DistributorHQCode;
                jobOrder.SP_DistributorHQName__c = rep.DataArea.DistributorHQName;
                jobOrder.SP_DSID__c = rep.DataArea.DSID;
                jobOrder.SP_DTNAFlag__c = rep.DataArea.DTNAFlag;
                jobOrder.SP_FreezeSubmitButton__c = rep.DataArea.FreezeSubmitButton;
                jobOrder.SP_GroupName__c = rep.DataArea.GroupName;
                jobOrder.SP_LTAFlag__c = rep.DataArea.LTAFlag;
                jobOrder.SP_MaxClaimAmt__c = rep.DataArea.MaxClaimAmt;
                jobOrder.SP_NewOEM__c = rep.DataArea.NewOEM;
                jobOrder.SP_OutfileAllClaims__c = rep.DataArea.OutfileAllClaims;
                jobOrder.SP_PACCAR__c = rep.DataArea.PACCAR;
                jobOrder.SP_PMUSplitPayment__c = rep.DataArea.PMUSplitPayment;
                jobOrder.SP_Policy__c = rep.DataArea.Policy;
                jobOrder.SP_PrimaryOEMCode__c = rep.DataArea.PrimaryOEMCode;
                jobOrder.SP_PrimaryOEMName__c = rep.DataArea.PrimaryOEMName;
                jobOrder.SP_ProductCertification__c = rep.DataArea.ProductCertification;
                jobOrder.SP_PromotionId__c = rep.DataArea.PromotionId;
                jobOrder.SP_PSBUProductCertification__c = rep.DataArea.PSBUProductCertification;
                jobOrder.SP_Region__c = rep.DataArea.Region;
                jobOrder.SP_RegionCode__c = rep.DataArea.RegionCode;
                jobOrder.SP_RepairLevel__c = rep.DataArea.RepairLevel;
                jobOrder.SP_SCMDeductiblePercentage__c = rep.DataArea.SCMDeductiblePercentage;
                jobOrder.SP_SCMDollarAmt__c = rep.DataArea.SCMDollarAmt;
                jobOrder.SP_State__c = rep.DataArea.State;
                jobOrder.SP_TechActualHoursRequired__c = rep.DataArea.TechActualHoursRequired;
                jobOrder.SP_ViewDollarAmount__c = rep.DataArea.ViewDollarAmount;
                jobOrder.SP_WarrantyCertificationEndDate__c = rep.DataArea.WarrantyCertificationEndDate;
                if(rep.DataArea.WarrantyEmail != null && rep.DataArea.WarrantyEmail != '') {
                    if(rep.DataArea.WarrantyEmail.length() > 250) 
                        jobOrder.SP_WarrantyEmail__c = rep.DataArea.WarrantyEmail.LEFT(250);
                    else
                        jobOrder.SP_WarrantyEmail__c = rep.DataArea.WarrantyEmail;
                } else {
                    jobOrder.SP_WarrantyEmail__c = '';
                }
                //jobOrder.SP_WarrantyEmail__c = rep.DataArea.WarrantyEmail;
                jobOrder.SP_WarrantyFax__c = rep.DataArea.WarrantyFax;
                jobOrder.SP_WarrantyTrainingCertification__c = rep.DataArea.WarrantyTrainingCertification;
                jobOrder.SP_WarrantyTrainingStatus__c = rep.DataArea.warrantyTrainingStatus;
                jobOrder.SP_WWSPSSPFlag__c = rep.DataArea.WWSPSSPFlag;
                jobOrder.SP_Country__c = rep.DataArea.SPCountry;
                jobOrder.SPDataWebserviceResult__c='Success';

            }
            system.debug('***jobOrder***'+jobOrder);
            return jobOrder;
        }
        catch(Exception ex){
            System.debug('in catch of getServiceProviderData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_SIEBEL-getServiceProviderData', 'CSS_SPDataLookup HttpResponse is null', 'CSS_SPDataLookup Webservice Execution failed', 'SBL');
            return null;  
        }

        //return null;
    }



    //Method to get service provider data res wrapper from siebel
    public static CSS_GetServiceProviderResponse getServiceProviderDataWrapper(string SPCode,string ServiceModelName,string FailureDate,String jobClaimNo){
        CSS_GetServiceProviderResponse serviceProviderResponse;
        CG_OP_OAGWrapper outputWrapper;
        try{
            Datetime startDt;
            Datetime endDt;
            Long totalTime;
            Datetime AuthStartTime;
            Datetime AuthEndtime;
            Long AuthTotalTime;
            //calling getAccessToken Service
            AuthStartTime = System.now();
            //String accessToken = CSS_WS_OAG.getAccessToken();
            //Commented for dynamic Authentication and added below lines
            // CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').AuthEnv__c);
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').AuthEnv__c,'CSS_SPDataLookup');//Added By Prabhakar OAG to Mule 19/05/2020
             String accesstoken = accessTokenOPWrap.accessToken;
            AuthEndtime = System.now();
            AuthTotalTime = AuthStartTime.getTime() - AuthEndtime.getTime();
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
               || String.isEmpty(accessToken) ){
                css_utility.LogOutIntError('CSS_FN_SIEBEL-getServiceProviderDataWrapper', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                return null;
            }
            /***** Preparing the Request Wrapper Class for getServiceProviderData****/
            CSS_GetServiceProviderRequest requestWrap = prepareReqJSONForGetSrvcProvider(SPCode,ServiceModelName,FailureDate);
            String serviceProviderJSONReqBody = JSON.serialize(requestWrap);
            system.debug('jsonreq Spdata req ---->'+serviceProviderJSONReqBody);
            //calling getServiceProviderData webservice
            String endPointURL = CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup').End_Point__c;
            //String methodType = 
            //Added appending end point URL By Prabhakar
            //endPointURL = endPointURL+'?sender='+'CSS'+'&target='+'CSSWarranty'+'&spCode='+SPCode+'&failureDate='+FailureDate+'&serviceModelName='+ServiceModelName;
           // endPointURL = endPointURL+'?sender=CSS&target=CSSWarranty&spCode='+SPCode+'&failureDate='+FailureDate+'&serviceModelName=ISXCM871E';
            endPointURL = endPointURL+'?sender=CSS&target=CSSWarranty&spCode='+SPCode+'&failureDate='+FailureDate+'&serviceModelName='+ServiceModelName;
          // endPointURL = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi-services/serviceprovider?sender=CSS&target=CSSWarranty&spCode=54906&failureDate=27-Nov-19&serviceModelName=ISX CM871 E';
            system.debug('*****endPointURL***'+endPointURL);
            startDt = System.now();
            //Added for Mule
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SPDataLookup');
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            endPointURL = endPointURL.replace(' ','%20'); 
            reqWrapper.endPoint = endPointURL;
            reqWrapper.serviceName = conDetails.ApplicationName__c;
            reqWrapper.methodType = conDetails.Method_Type__c;
            //
            outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            system.debug('outputWrapper>>>'+outputWrapper);
            system.debug('outputWrapper.response>>>'+outputWrapper.response);
           // HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(serviceProviderJSONReqBody, endPointURL, accessToken);
           HttpResponse httpRes = outputWrapper.response;
            endDt = System.now();
            totalTime = endDt.getTime() - startDt.getTime();
            system.debug('httpRes spdata >>>>>>'+httpRes);
            list<CSS_Integration_Error__c> lstIntErrDetails = new list<CSS_Integration_Error__c>();
            if(httpRes == null || httpRes.getStatusCode() != 200){
                CSS_Integration_Error__c interrDetails = new CSS_Integration_Error__c();

                interrDetails.Auth_Call_Time__c     = AuthTotalTime;
                interrDetails.Processed_Data__c    =  serviceProviderJSONReqBody;
                interrDetails.Response_Body__c     = (httpRes != null ? httpRes.getBody() : '');
                interrDetails.Service_Call_Time__c = totalTime;
                interrDetails.Service_Job_Number__c = jobClaimNo;
                interrDetails.Service_Name__c = 'getServiceProviderData';
                interrDetails.Source__c = 'Siebel';
                lstIntErrDetails.add(interrDetails);

                if(lstIntErrDetails.size()!=null){
                    system.debug('**insert a record into CSS_Integration_Error__c object with lstIntErrDetails **' + lstIntErrDetails);
                    insert lstIntErrDetails;
                }
                //css_utility.LogOutIntError('CSS_FN_SIEBEL-getServiceProviderDataWrapper', 'CSS_SPDataLookup HttpResponse is null', 'CSS_SPDataLookup Webservice Execution failed', 'SBL');
                return null;
            }
            serviceProviderResponse =  (CSS_GetServiceProviderResponse)JSON.deserializeStrict(httpRes.getBody(), CSS_GetServiceProviderResponse.class);


            system.debug('serviceProviderResponse Response --->'+serviceProviderResponse);
        }
        catch(Exception ex){
            System.debug('in catch of getServiceProviderDataWrapper of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_SIEBEL-getServiceProviderDataWrapper', 'CSS_SPDataLookup HttpResponse is null', 'CSS_SPDataLookup Webservice Execution failed', 'SBL');
        }
        return serviceProviderResponse;
    }

    /**
* Method to get service provider data from siebel
* 
*/
    /*
public static CSS_GetServiceProviderResponse getServiceProviderData(string SPCode,string ServiceModelName,string FailureDate){
CSS_GetServiceProviderResponse serviceProviderResponse = new CSS_GetServiceProviderResponse();
try{
//calling getAccessToken Service
String accessToken = CSS_WS_OAG.getAccessToken();
system.debug('Access Token --->'+accessToken);
if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) 
|| String.isEmpty(accessToken) ){
css_utility.LogOutIntError('CSS_FN_SIEBEL-getServiceProviderData', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
return null;
}

CSS_GetServiceProviderRequest requestWrap = prepareReqJSONForGetSrvcProvider(SPCode,ServiceModelName,FailureDate);
String serviceProviderJSONReqBody = JSON.serialize(requestWrap);
system.debug('jsonreq Spdata req ---->'+serviceProviderJSONReqBody);
//calling getServiceProviderData webservice
String endPointURL = CSS_getConnnectionDetails.getConnection('SPDataLookup').End_Point__c;
HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(serviceProviderJSONReqBody, endPointURL, accessToken);
system.debug('httpRes spdata >>>>>>'+httpRes);
if(httpRes == null || httpRes.getStatusCode() != 200){
css_utility.LogOutIntError('CSS_FN_SIEBEL-getServiceProviderData', 'SPDataLookup HttpResponse is null', 'SPDataLookup Webservice Execution failed', 'SBL');
return null;
}

CSS_GetServiceProviderResponse spResponse =  (CSS_GetServiceProviderResponse)JSON.deserializeStrict(httpRes.getBody(), CSS_GetServiceProviderResponse.class);
system.debug('deserialized Response --->'+spResponse);
return spResponse;
}
catch(Exception ex){
System.debug('in catch of getServiceProviderData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
}

return null;
}
*/

    /**
* This is used for Preparing Request JSON of GetServiceProvider webservice
* 
*/
    public static CSS_GetServiceProviderRequest prepareReqJSONForGetSrvcProvider(string SPCode,string ServiceModelName,string FailureDate){
        CSS_GetServiceProviderRequest serviceProviderReq = new CSS_GetServiceProviderRequest();
        CSS_GetServiceProviderRequest.DataArea da = new CSS_GetServiceProviderRequest.DataArea();
        CSS_GetServiceProviderRequest.Sender sender = new CSS_GetServiceProviderRequest.Sender();
        CSS_GetServiceProviderRequest.Header header = new CSS_GetServiceProviderRequest.Header();

        try{

            //setting sender details 

            sender.MessageID = 'UniqueID';
            sender.ServiceName='SPDataLookup';
            sender.SenderID = 'CSS';

            //setting Data Area details
            da.SPCode =SPCode;
            da.ServiceModelName = '';//ServiceModelName;
            da.FailureDate = FailureDate;

            //setting Header Data
            header.Sender = sender;
            header.Target = 'CSSWarranty';

            //setting the request data
            serviceProviderReq.DataArea = da;
            serviceProviderReq.Header = header;
        }
        catch(Exception e){
            system.debug('inside Prepare req for get ServiceProvider CatchBlock Exception msg :'+e.getMessage()+'line no :--'+e.getLineNumber());
        }

        return serviceProviderReq;
    }

    public CSS_SiebelAccountCodeResponseJ2A accountCodeRes;
    //public CSS_SiebelAccountCodeResponseJ2A getAccountCodes()
    public static void getAccountCodes()
    {
        try
        {
            //String accessToken = CSS_WS_OAG.getAccessToken();
            //Commented for dynamic Authentication and added below lines
                    CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_AccountCodes').AuthEnv__c);
                    String accesstoken = accessTokenOPWrap.accessToken;
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken))
            {
                css_utility.LogOutIntError('CSS_FN_Siebel-GetAccountCodesService', 'OAG Token Service failed', 'OAG Token is null', 'OAGOAuth');
                //return null;
            }
            String lastProDate;
            try{
                lastProDate = [SELECT Attribute1__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes_LastProcessed' limit 1].Attribute1__c;
            }
            catch (exception ex){
                lastProDate = '2000-01-01';
            }
            //lastProDate = '2000-01-01'; //temporarily added to load

            String reqBody = '{"Header": {"Sender": {"ServiceName": "GetAccountCodes","SenderID": "CSS"},"Target": {"TargetID": "SIEBEL"}},"DataArea": {"LAST_PROCESSED_DATE": "'+lastProDate+'"}}';
            String endPointURL;
            CSS_Integration_Details__c connection = new CSS_Integration_Details__c ();
            connection = CSS_getConnnectionDetails.getConnection('CSS_SBL_AccountCodes');
            if(connection != null) 
            {
                endPointURL = connection.End_Point__c;                
            }
            HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(reqBody, endPointURL, accessToken);
            system.debug('httpRes>>>>>>'+httpRes);
            if(httpRes == null || httpRes.getStatusCode() != 200)
            {
                css_utility.LogOutIntError('CSS_FN_Siebel-GetAccountCodesService', 'Siebel GetAccountCodes HttpResponse is null', 'Siebel GetAccountCodes Webservice Execution failed', 'Siebel');
                //return null;
            }else if(httpRes.getBody().contains('OSB Service Callout action received SOAP Fault response') )
            {
                System.debug('Incorrect json format-- STATUS:'+httpRes.getStatus()+'STATUS_CODE:'+httpRes.getStatusCode());
                css_utility.LogOutIntError('CSS_FN_Siebel-GetAccountCodesService', 'Siebel GetAccountCodes HttpResponse is null', 'OSB Service Callout action received SOAP Fault response', 'Siebel');
                //return null;
            }
            //accountCodeRes = (CSS_SiebelAccountCodeResponseJ2A)JSON.deserializeStrict(httpRes.getBody(), CSS_SiebelAccountCodeResponseJ2A.class);
            //return accountCodeRes;   
            //below logic of save response data & weekly basis
            if(httpRes.getStatusCode() == 200){
                insertResponse(httpRes.getBody(), 'GetAccountCodes');
            }
        }
        catch(exception ex)
        {
            system.debug('Exception in getAccountCodes method-->'+ex.getmessage());
            //return null;
        }
    }

    public static List<CSS_Parts_Options__c> getPartsReturn(List<CSS_Parts_Options__c> partsList){
        System.debug('################# entered into getPartsReturn method ###################');
        System.debug('PARTLIST>>'+partsList);
        CG_IP_OAGWrapper reqWrapper;
        CG_OP_OAGWrapper outputWrapper;
        String endPointURL;
        Set<Id> partsId = new Set<Id>();
        Set<Id> partsId_N = new Set<Id>();
        CSS_Job_Order__c serJob = new CSS_Job_Order__c();

        CSS_getPartReturnInputWrapper partReqJSON = new CSS_getPartReturnInputWrapper();
        CSS_getPartReturnOutputWrapper partResJSON = new CSS_getPartReturnOutputWrapper();

        CSS_getPartReturnInputWrapper.Header headerObj = new CSS_getPartReturnInputWrapper.Header();
        CSS_getPartReturnInputWrapper.Sender senderObj = new CSS_getPartReturnInputWrapper.Sender();
        CSS_getPartReturnInputWrapper.Target targetObj = new CSS_getPartReturnInputWrapper.Target();
        CSS_getPartReturnInputWrapper.DataArea dataAreaObj = new CSS_getPartReturnInputWrapper.DataArea();
        CSS_getPartReturnInputWrapper.PARTS listPart = new CSS_getPartReturnInputWrapper.PARTS();

        for(CSS_Parts_Options__c p:partsList){
            if(p.Service_partnumber__c != null && (p.Account_Code__c != null && p.Account_Code__c != '' && p.Account_Code__c != 'Select One'))
                partsId_N.add(p.Id);
        }
        try{

            serJob = [SELECT Id, ESN__c, CSS_Channel_Code__c, Failure_Date__c, Territory_Class__c, Qsol_Engine_Family_Code__c FROM 
                      CSS_Job_Order__c WHERE Id =: partsList[0].Service_Job__c];

        }
        catch(exception err){
            if(partsList!=null && partsList.size()>0){
            Id serJobId = [SELECT Id, Service_Job__c FROM CSS_Parts_Options__c WHERE Id =: partsList[0].Id].Service_Job__c;
            serJob = [SELECT Id, ESN__c, CSS_Channel_Code__c, Failure_Date__c, Territory_Class__c, Qsol_Engine_Family_Code__c FROM 
                      CSS_Job_Order__c WHERE Id =: serJobId];
            }
        }
        try{
            List<CSS_Parts_Options__c> cssPartsOptions = new List<CSS_Parts_Options__c>();
            system.debug('DistiChanel : ' + serJob.CSS_Channel_Code__c + ' ' +
                         'ESN : ' + serJob.ESN__c + ' ' +
                         'Failure Date : ' + serJob.Failure_Date__c + ' ' +
                         'Product Family : ' + serJob.Qsol_Engine_Family_Code__c + ' ' +
                         'Territory Class : ' + serJob.Territory_Class__c + ' ' +
                         'Parts List : ' + partsList);
            if((serJob.CSS_Channel_Code__c != null && serJob.CSS_Channel_Code__c != '') &&
               (serJob.ESN__c != null && serJob.ESN__c != '') &&
               (serJob.Failure_Date__c != null && serJob.Failure_Date__c != null) &&
               (serJob.Qsol_Engine_Family_Code__c != null && serJob.Qsol_Engine_Family_Code__c != null) &&
               (serJob.Territory_Class__c != null && serJob.Territory_Class__c != null)              ){
                //calling getAccessToken Service
                //String accessToken = CSS_WS_OAG.getAccessToken();
                //Commented for dynamic Authentication and added below lines
                    //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns').AuthEnv__c);
                    //Added for Mule
                    CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns').AuthEnv__c,'CSS_SBL_GetPartReturns');
                    String accesstoken = accessTokenOPWrap.accessToken;
                if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken)){
                    css_utility.LogOutIntError('CSS_FN_SIEBEL-getPartsReturn', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                }
                else{
                    senderObj.ServiceName = 'GetERPFlag';
                    senderObj.SenderID = 'CSS';
                    targetObj.TargetID = 'SIEBEL';
                    headerObj.Sender = senderObj;
                    headerObj.Target = targetObj;
                    partReqJSON.Header = headerObj;
                    dataAreaObj.PSN = serJob.ESN__c;
                    dataAreaObj.DISTICHANNEL = serJob.CSS_Channel_Code__c;                
                    dataAreaObj.FAILDATE = String.valueof(serJob.Failure_Date__c);

                    dataAreaObj.PARTS = new List<CSS_getPartReturnInputWrapper.PARTS>();
                    partReqJSON.DataArea = dataAreaObj;

                    for(CSS_Parts_Options__c parts : partsList){

                        system.debug('parts.Fail_Code__c' + ' ' + parts.Fail_Code__c);
                        system.debug('parts.Account_Code__c' + ' ' + parts.Account_Code__c);
                        CSS_getPartReturnInputWrapper.parts partsObj = new CSS_getPartReturnInputWrapper.parts();
                        if(parts.Service_partnumber__c != null && 
                           (parts.Account_Code__c != null && parts.Account_Code__c != '' && parts.Account_Code__c != 'Select One')){
                            partsObj.PARTNUMBER = parts.Service_partnumber__c;
                            partsObj.PRODUCTFAMILY = serJob.Qsol_Engine_Family_Code__c;
                            partsObj.TERRITORYCLASS = serJob.Territory_Class__c;
                            partsObj.ACCOUNTCODE = parts.Account_Code__c.RIGHT(2);
                            if(parts.Fail_Code__c !=null && parts.Fail_Code__c.trim() !='' && parts.Fail_Code__c !='Select One'){
                                list<string> lstFailCodes =  new list<string>();
                                lstFailCodes = parts.Fail_Code__c.split('-');
                                string newFailcode;
                                if(lstFailCodes.size()>0 && lstFailCodes[lstFailCodes.size()-1]!=null){
                                    newFailcode = lstFailCodes[lstFailCodes.size()-1].LEFT(4);
                                }
                                partsObj.FAILCODE = newFailcode;
                                system.debug('partsObj.FAILCODE' + ' ' + partsObj.FAILCODE);
                            }
                            partReqJSON.DataArea.PARTS.add(partsObj);
                        }
                    }

                    //Prepare Request JSON
                    String partsReqJSONStr = JSON.serialize(partReqJSON);
                    System.debug('partsReqJSONStr>>>>>>>>>>>>>>>>>>>>:'+partReqJSON);
                    System.debug('partsReqJSONStr6>>>>>>>>>>>>>>>>>>>>:'+partsReqJSONStr);

                    endPointURL = CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns').End_Point__c;
                    //commented for Mule
                   // HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(partsReqJSONStr, endPointURL, accessToken);
                     //
                    CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                    conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns');
                    reqWrapper = new CG_IP_OAGWrapper();
                    reqWrapper.jsonReqBody = partsReqJSONStr;
                    reqWrapper.serviceName = conDetails.ApplicationName__c;
                    reqWrapper.methodType = conDetails.Method_Type__c;
                    reqWrapper.endPoint = conDetails.End_Point__c;
                    HttpResponse httpRes;
                    if(!Test.isRunningTest()){
                        outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                        httpRes = outputWrapper.response;
                    }
                    else{
                        string jsonRespBody = '{'+
'  "Header": {'+
'    "MessageIdentifier": "22870770-5421-11ea-a2e1-144f8ad8b783",'+
'    "ReturnCode": 200,'+
'    "ReturnCodeDescription": "",'+
'    "Status": "SUCCESS",'+
'    "MessageType": "S"'+
'  },'+
'  "DataArea": ['+
'    {'+
'      "LOCATION": "",'+
'      "MESSAGE": "",'+
'      "ATTENTION": "",'+
'      "RETURNMESSAGE": "",'+
'      "EPRFLAG": "N",'+
'      "PARTNUMBER": "",'+
'      "COMPANY": ""'+
'    }'+
'  ]'+
'}';

                   httpRes = new HttpResponse();
                   httpRes.setHeader('Content-Type', 'application/json');
                   httpRes.setBody(jsonRespBody);
                   httpRes.setStatusCode(200);
                   
                    }
                    
                    //
                    system.debug('response>>'+httpres);
                    if(httpRes == null || httpRes.getStatusCode() != 200){
                        css_utility.LogOutIntError('CSS_FN_SIEBEL-PartsReturn', 'PartsReturn HttpResponse is null', 'PartsReturn Webservice Execution failed', 'SBL');
                    }
                    else{
                        System.debug('RESPONSE_BODY>>>:'+httpRes.getbody()+' httpRes getStatusCode is :: '+httpRes.getStatusCode()+' httpRes.toString>>>:'+httpRes.toString());
                        partResJSON =  (CSS_getPartReturnOutputWrapper)JSON.deserializeStrict(httpRes.getBody(), CSS_getPartReturnOutputWrapper.class);
                        System.debug('partResJSON>>>>>>>>>>>>>>>>>>>>:'+partResJSON);

                        if(partResJSON != null){                
                            if(partResJSON.DataArea!=null){
                                for(CSS_getPartReturnOutputWrapper.DataArea a : partResJSON.DataArea){
                                    CSS_Parts_Options__c partsOpt = new CSS_Parts_Options__c();
                                    for(CSS_Parts_Options__c parts : partsList){
                                        if(parts.Service_partnumber__c == a.PARTNUMBER && (parts.Account_Code__c != null && parts.Account_Code__c != '' && parts.Account_Code__c != 'Select One') ){                            
                                            if(partsId != null && !partsId.contains(parts.Id)){
                                                partsOpt.ReturnToFactory__c = a.EPRFLAG;
                                                partsOpt.Return_Instructions__c = a.RETURNMESSAGE;
                                                partsOpt.Shipping_Address__c = a.LOCATION;
                                                partsOpt.Service_partnumber__c = a.PARTNUMBER;
                                                partsOpt.Id = parts.Id;
                                                partsId.add(parts.Id);
                                                cssPartsOptions.add(partsOpt);
                                                break;
                                            }
                                        }
                                    }
                                }

                                for(Id setId : partsId_N){
                                    if(!partsId.contains(setId)){
                                        CSS_Parts_Options__c partsOptN = new CSS_Parts_Options__c();
                                        partsOptN.ReturnToFactory__c = 'N';
                                        partsOptN.Id = setId;
                                        cssPartsOptions.add(partsOptN);
                                    }
                                }
                                system.debug('output -->'+cssPartsOptions);
                            }
                        }
                    }
                }
            }
            return cssPartsOptions;
        }
        catch(Exception ex){
            System.debug('in catch of getPartsReturn of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_SIEBEL-PartsReturn', 'HttpResponse is null', 'Webservice Execution failed', 'SBL');
            return null;
        }
    }

    public static List<CSS_Parts_Options__c> getPartsReturnClaims(List<CSS_Parts_Options__c> partsList){
        System.debug('################# entered into getPartsReturnClaims method ###################');
        System.debug('PARTLIST>>'+partsList);
        String endPointURL;
        CG_IP_OAGWrapper reqWrapper;
        CG_OP_OAGWrapper outputWrapper;
        Set<Id> partsId = new Set<Id>();
        Set<Id> partsId_N = new Set<Id>();
        CSS_Claims__c claimsObj = new CSS_Claims__c();
        CSS_Job_Order__c serJob = new CSS_Job_Order__c();        
        CSS_PSN__c psnObj = new CSS_PSN__c();

        CSS_getPartReturnInputWrapper partReqJSON = new CSS_getPartReturnInputWrapper();
        CSS_getPartReturnOutputWrapper partResJSON = new CSS_getPartReturnOutputWrapper();

        CSS_getPartReturnInputWrapper.Header headerObj = new CSS_getPartReturnInputWrapper.Header();
        CSS_getPartReturnInputWrapper.Sender senderObj = new CSS_getPartReturnInputWrapper.Sender();
        CSS_getPartReturnInputWrapper.Target targetObj = new CSS_getPartReturnInputWrapper.Target();
        CSS_getPartReturnInputWrapper.DataArea dataAreaObj = new CSS_getPartReturnInputWrapper.DataArea();
        CSS_getPartReturnInputWrapper.PARTS listPart = new CSS_getPartReturnInputWrapper.PARTS();

        for(CSS_Parts_Options__c p:partsList){
            if(p.Service_partnumber__c != null && (p.Account_Code__c != null && p.Account_Code__c != '' && p.Account_Code__c != 'Select One'))
                partsId_N.add(p.Id);
        }
        try{
            claimsObj = [SELECT Id, CSS_Job__c, CSS_Channel_Code__c, ESN__c, Location_Code__c, CSS_Channel_Of_Distribution__c,Territory_Class_Name__c,Territory_Class__c,Territory__c FROM CSS_Claims__c WHERE Id =: partsList[0].CSS_Claims__c];
            system.debug('*****claimsObj*****'+claimsObj);
            if(claimsObj!=null && claimsObj.CSS_Job__c != null){
                serJob = [SELECT Id, ESN__c, CSS_Channel_Code__c, Failure_Date__c, Territory_Class__c, Qsol_Engine_Family_Code__c FROM 
                          CSS_Job_Order__c WHERE Id =: claimsObj.CSS_Job__c];
                system.debug('*****serJob'+serJob);
            }
        }
        catch(exception err){
            System.debug('first in catch of fn_siebel_getpartsreturnclaims>>>>>>>>>>>>>>>is :: '+err.getLineNumber()+' Exception Message>>>is:'+err.getMessage());
        }
        try{
            List<CSS_Parts_Options__c> cssPartsOptions = new List<CSS_Parts_Options__c>();


            //Below code is for automated claims
            if(claimsObj.CSS_Job__c != null){ 
                system.debug('****insideautomatedclaims');
                system.debug('***servicejob***');
                system.debug('DistiChanel : ' + serJob.CSS_Channel_Code__c + ' ' +
                             'ESN : ' + serJob.ESN__c + ' ' +
                             'Failure Date : ' + serJob.Failure_Date__c + ' ' +
                             'Product Family : ' + serJob.Qsol_Engine_Family_Code__c + ' ' +
                             'Territory Class : ' + serJob.Territory_Class__c + ' ' +
                             'Parts List : ' + partsList);
                if((serJob.CSS_Channel_Code__c != null && serJob.CSS_Channel_Code__c != '') &&
                   (serJob.ESN__c != null && serJob.ESN__c != '') &&
                   (serJob.Failure_Date__c != null && serJob.Failure_Date__c != null) &&
                   (serJob.Qsol_Engine_Family_Code__c != null && serJob.Qsol_Engine_Family_Code__c != null) &&
                   (serJob.Territory_Class__c != null && serJob.Territory_Class__c != null)              ){
                    //calling getAccessToken Service
                    //String accessToken = CSS_WS_OAG.getAccessToken();
                    //Commented for dynamic Authentication and added below lines
                   // CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns').AuthEnv__c);
                    CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns').AuthEnv__c,'CSS_SBL_GetPartReturns');
                    String accesstoken = accessTokenOPWrap.accessToken;
                    
                    if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken)){
                        css_utility.LogOutIntError('CSS_FN_SIEBEL-getPartsReturn', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                    }
                    else{
                        senderObj.ServiceName = 'GetERPFlag';
                        senderObj.SenderID = 'CSS';
                        targetObj.TargetID = 'SIEBEL';
                        headerObj.Sender = senderObj;
                        headerObj.Target = targetObj;
                        partReqJSON.Header = headerObj;
                        dataAreaObj.PSN = serJob.ESN__c;
                        dataAreaObj.DISTICHANNEL = serJob.CSS_Channel_Code__c;                
                        dataAreaObj.FAILDATE = String.valueof(serJob.Failure_Date__c);

                        dataAreaObj.PARTS = new List<CSS_getPartReturnInputWrapper.PARTS>();
                        partReqJSON.DataArea = dataAreaObj;

                        for(CSS_Parts_Options__c parts : partsList){
                            CSS_getPartReturnInputWrapper.parts partsObj = new CSS_getPartReturnInputWrapper.parts();
                            if(parts.Service_partnumber__c != null && 
                               (parts.Account_Code__c != null && parts.Account_Code__c != '' && parts.Account_Code__c != 'Select One')){
                                partsObj.PARTNUMBER = parts.Service_partnumber__c;
                                partsObj.PRODUCTFAMILY = serJob.Qsol_Engine_Family_Code__c;
                                partsObj.TERRITORYCLASS = serJob.Territory_Class__c;
                                partsObj.ACCOUNTCODE = parts.Account_Code__c.RIGHT(2);
                                if(parts.Fail_Code__c !=null && parts.Fail_Code__c.trim() !='' && parts.Fail_Code__c !='Select One')
                                    partsObj.FAILCODE = parts.Fail_Code__c.LEFT(4);
                                // partsObj.FAILCODE = parts.Fail_Code__c;
                                partReqJSON.DataArea.PARTS.add(partsObj);
                            }
                        }

                        //Prepare Request JSON
                        String partsReqJSONStr = JSON.serialize(partReqJSON);
                        System.debug('partsReqJSONStr>>>>>>>>>>>>>>>>>>>>:'+partReqJSON);

                        endPointURL = CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns').End_Point__c;
                      //  HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(partsReqJSONStr, endPointURL, accessToken);//commented for mule
                        //
                         //
                CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns');
                reqWrapper = new CG_IP_OAGWrapper();
                reqWrapper.jsonReqBody = partsReqJSONStr;
                reqWrapper.serviceName = conDetails.ApplicationName__c;
                reqWrapper.methodType = conDetails.Method_Type__c;
                reqWrapper.endPoint = conDetails.End_Point__c;
                 System.debug('reqWrapper>>>>>>>>>>>>>>>>>>>>:'+reqWrapper);
                HttpResponse httpRes;
                if(!Test.isRunningTest()){
                    outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                    httpRes = outputWrapper.response;
                }
                else{
                        string jsonRespBody = '{'+
'  "Header": {'+
'    "MessageIdentifier": "22870770-5421-11ea-a2e1-144f8ad8b783",'+
'    "ReturnCode": 200,'+
'    "ReturnCodeDescription": "",'+
'    "Status": "SUCCESS",'+
'    "MessageType": "S"'+
'  },'+
'  "DataArea": ['+
'    {'+
'      "LOCATION": "",'+
'      "MESSAGE": "",'+
'      "ATTENTION": "",'+
'      "RETURNMESSAGE": "",'+
'      "EPRFLAG": "N",'+
'      "PARTNUMBER": "",'+
'      "COMPANY": ""'+
'    }'+
'  ]'+
'}';

                   httpRes = new HttpResponse();
                   httpRes.setHeader('Content-Type', 'application/json');
                   httpRes.setBody(jsonRespBody);
                   httpRes.setStatusCode(200);
                   
                    }
                
                //
                        
                        //
                        system.debug('response>>'+httpres);
                        if(httpRes == null || httpRes.getStatusCode() != 200){
                            css_utility.LogOutIntError('CSS_FN_SIEBEL-PartsReturn', 'PartsReturn HttpResponse is null', 'PartsReturn Webservice Execution failed', 'SBL');
                        }
                        else{
                            System.debug('RESPONSE_BODY>>>:'+httpRes.getbody()+' httpRes getStatusCode is :: '+httpRes.getStatusCode()+' httpRes.toString>>>:'+httpRes.toString());
                            partResJSON =  (CSS_getPartReturnOutputWrapper)JSON.deserializeStrict(httpRes.getBody(), CSS_getPartReturnOutputWrapper.class);
                            System.debug('partResJSON>>>>>>>>>>>>>>>>>>>>:'+partResJSON);

                            if(partResJSON != null){                
                                if(partResJSON.DataArea!=null){
                                    for(CSS_getPartReturnOutputWrapper.DataArea a : partResJSON.DataArea){
                                        CSS_Parts_Options__c partsOpt = new CSS_Parts_Options__c();
                                        for(CSS_Parts_Options__c parts : partsList){
                                            if(parts.Service_partnumber__c == a.PARTNUMBER && (parts.Account_Code__c != null && parts.Account_Code__c != '' && parts.Account_Code__c != 'Select One') ){                            
                                                if(partsId != null && !partsId.contains(parts.Id)){
                                                    partsOpt.ReturnToFactory__c = a.EPRFLAG;
                                                    partsOpt.Id = parts.Id;
                                                    partsOpt.Return_Instructions__c = a.RETURNMESSAGE;
                                                    partsOpt.Shipping_Address__c = a.LOCATION;
                                                    partsId.add(parts.Id);
                                                    cssPartsOptions.add(partsOpt);
                                                    break;
                                                }
                                            }
                                        }
                                    }

                                    for(Id setId : partsId_N){
                                        if(!partsId.contains(setId)){
                                            CSS_Parts_Options__c partsOptN = new CSS_Parts_Options__c();
                                            partsOptN.ReturnToFactory__c = 'N';
                                            partsOptN.Id = setId;
                                            cssPartsOptions.add(partsOptN);
                                        }
                                    }
                                    system.debug('output -->'+cssPartsOptions);
                                }
                            }
                        }
                    }
                }
            }
            //Below code is for manual claims    
            else{

                psnObj = [Select id, PSN__c, Failure_Date__c, Qsol_Engine_Family_Code__c from CSS_PSN__c where Primary__c = true and CSS_Claims__c =: claimsObj.Id];
                system.debug('******psnObj***'+psnObj);
                system.debug('DistiChanel : ' + claimsObj.CSS_Channel_Code__c + ' ' +
                             'ESN : ' + psnObj.PSN__c + ' ' +
                             'Failure Date : ' + psnObj.Failure_Date__c + ' ' +
                             'Product Family : ' + psnObj.Qsol_Engine_Family_Code__c + ' ' +
                             'Territory Class : ' + claimsObj.Territory_Class__c + ' ' +
                             'Parts List : ' + partsList);
                system.debug('****insidemanualclaims');
                if((claimsObj.CSS_Channel_Code__c != null && claimsObj.CSS_Channel_Code__c != '') &&
                   (psnObj.PSN__c  != null && psnObj.PSN__c != '') &&
                   (psnObj.Failure_Date__c != null && psnObj.Failure_Date__c != null) &&
                   (psnObj.Qsol_Engine_Family_Code__c != null && psnObj.Qsol_Engine_Family_Code__c != null) &&
                   (claimsObj.Territory_Class__c != null && claimsObj.Territory_Class__c != null)              ){
                    //calling getAccessToken Service
                    //String accessToken = CSS_WS_OAG.getAccessToken();
                    //Commented for dynamic Authentication and added below lines
                   // CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns').AuthEnv__c);
                   CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns').AuthEnv__c,'CSS_SBL_GetPartReturns');
                    String accesstoken = accessTokenOPWrap.accessToken;
                    if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken)){
                        css_utility.LogOutIntError('CSS_FN_SIEBEL-getPartsReturn', 'OAG Token service failed', 'OAG Token IS NULL', 'OAGOAuth');
                    }
                    else{
                        senderObj.ServiceName = 'GetERPFlag';
                        senderObj.SenderID = 'CSS';
                        targetObj.TargetID = 'SIEBEL';
                        headerObj.Sender = senderObj;
                        headerObj.Target = targetObj;
                        partReqJSON.Header = headerObj;
                        dataAreaObj.PSN = psnObj.PSN__c;
                        dataAreaObj.DISTICHANNEL = claimsObj.CSS_Channel_Code__c;                
                        dataAreaObj.FAILDATE = String.valueof(psnObj.Failure_Date__c);

                        dataAreaObj.PARTS = new List<CSS_getPartReturnInputWrapper.PARTS>();
                        partReqJSON.DataArea = dataAreaObj;

                        for(CSS_Parts_Options__c parts : partsList){
                            CSS_getPartReturnInputWrapper.parts partsObj = new CSS_getPartReturnInputWrapper.parts();
                            if(parts.Service_partnumber__c != null && 
                               (parts.Account_Code__c != null && parts.Account_Code__c != '' && parts.Account_Code__c != 'Select One')){
                                partsObj.PARTNUMBER = parts.Service_partnumber__c;
                                partsObj.PRODUCTFAMILY = psnObj.Qsol_Engine_Family_Code__c;
                                partsObj.TERRITORYCLASS = claimsObj.Territory_Class__c;
                                partsObj.ACCOUNTCODE = parts.Account_Code__c.RIGHT(2);
                                if(parts.Fail_Code__c !=null && parts.Fail_Code__c.trim() !='' && parts.Fail_Code__c !='Select One'){
                                    list<string> lstFailCodes =  new list<string>();
                                    lstFailCodes = parts.Fail_Code__c.split('-');
                                    string newFailcode;
                                    if(lstFailCodes.size()>0 && lstFailCodes[lstFailCodes.size()-1]!=null){
                                        newFailcode = lstFailCodes[lstFailCodes.size()-1].LEFT(4);
                                    }
                                    partsObj.FAILCODE = newFailcode;
                                    system.debug('partsObj.FAILCODE' + ' ' + partsObj.FAILCODE);
                                }
                                partReqJSON.DataArea.PARTS.add(partsObj);
                            }
                        }

                        //Prepare Request JSON
                        String partsReqJSONStr = JSON.serialize(partReqJSON);
                        System.debug('partsReqJSONStr>>>>>>>>>>>>>>>>>>>>:'+partReqJSON);

                        endPointURL = CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns').End_Point__c;
                       // HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(partsReqJSONStr, endPointURL, accessToken);
                        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                        conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartReturns');
                        reqWrapper = new CG_IP_OAGWrapper();
                        reqWrapper.jsonReqBody = partsReqJSONStr;
                        reqWrapper.serviceName = conDetails.ApplicationName__c;
                        reqWrapper.methodType = conDetails.Method_Type__c;
                        reqWrapper.endPoint = conDetails.End_Point__c;
                        outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                        HttpResponse httpRes = outputWrapper.response;
                    
                    //
                        system.debug('response>>'+httpres);
                        if(httpRes == null || httpRes.getStatusCode() != 200){
                            css_utility.LogOutIntError('CSS_FN_SIEBEL-PartsReturn', 'PartsReturn HttpResponse is null', 'PartsReturn Webservice Execution failed', 'SBL');
                        }
                        else{
                            System.debug('RESPONSE_BODY>>>:'+httpRes.getbody()+' httpRes getStatusCode is :: '+httpRes.getStatusCode()+' httpRes.toString>>>:'+httpRes.toString());
                            partResJSON =  (CSS_getPartReturnOutputWrapper)JSON.deserializeStrict(httpRes.getBody(), CSS_getPartReturnOutputWrapper.class);
                            System.debug('partResJSON>>>>>>>>>>>>>>>>>>>>:'+partResJSON);

                            if(partResJSON != null){                
                                if(partResJSON.DataArea!=null){
                                    for(CSS_getPartReturnOutputWrapper.DataArea a : partResJSON.DataArea){
                                        CSS_Parts_Options__c partsOpt = new CSS_Parts_Options__c();
                                        for(CSS_Parts_Options__c parts : partsList){
                                            if(parts.Service_partnumber__c == a.PARTNUMBER && (parts.Account_Code__c != null && parts.Account_Code__c != '' && parts.Account_Code__c != 'Select One') ){                            
                                                if(partsId != null && !partsId.contains(parts.Id)){
                                                    partsOpt.ReturnToFactory__c = a.EPRFLAG;
                                                    partsOpt.Id = parts.Id;
                                                    partsOpt.Return_Instructions__c = a.RETURNMESSAGE;
                                                    partsOpt.Shipping_Address__c = a.LOCATION;
                                                    partsId.add(parts.Id);
                                                    cssPartsOptions.add(partsOpt);
                                                    break;
                                                }
                                            }
                                        }
                                    }

                                    for(Id setId : partsId_N){
                                        if(!partsId.contains(setId)){
                                            CSS_Parts_Options__c partsOptN = new CSS_Parts_Options__c();
                                            partsOptN.ReturnToFactory__c = 'N';
                                            partsOptN.Id = setId;
                                            cssPartsOptions.add(partsOptN);
                                        }
                                    }
                                    system.debug('output -->'+cssPartsOptions);
                                }
                            }
                        }
                    }
                }  else { system.debug(' No Proper Data');}   
            }
            return cssPartsOptions;
        }
        catch(Exception ex){
            System.debug('in catch of getPartsReturnClaims of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_SIEBEL-PartsReturn', 'HttpResponse is null', 'Webservice Execution failed', 'SBL');
            return null;
        }
    }

    //Method to get the Fail Code data from Seibel
    //Author - Krishnamoorthi
    //Date - 1/24/2018

    public static void getFailCodes() {
        CG_OP_OAGWrapper outputWrapper;
        //CSS_SiebelFailCodeResponseJ2A failCodeWrapper = new CSS_SiebelFailCodeResponseJ2A();
        try {
            date processedDate;

            List<CSS_JobEventTemporary__c> jobeventTemp = [SELECT Id, Name, Key__c, Attribute1__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'FailCodeProcessedDate' LIMIT 1];
            if(jobeventTemp != null && jobeventTemp.size() > 0) {
                if(jobeventTemp[0].Attribute1__c != null)
                    processedDate = date.valueof(jobeventTemp[0].Attribute1__c);
                else
                    processedDate = Date.Today();
            } else
                processedDate = Date.Today();
            system.debug(processedDate);
            string processedDateString = DateTime.newInstance(processedDate.year(),processedDate.month(),processedDate.day()).format('YYYY-MM-dd');//2018-01-14
            system.debug(processedDateString);
            //Mule Integration start
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_FailCodes');
            //Mule Integration end
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            //String reqBody = '{"Header": {"Sender": {"ServiceName": "GetFailCodes","SenderID": "CSS"},"Target": {"TargetID": "CSSWarranty"}},"DataArea": {"LAST_PROCESSED_DATE": "' + processedDateString + '"}}';//pass date and format.
            //String reqBody;
            String endPoint = conDetails.End_Point__c+'?sender=CSS&target=CSSWarranty&lastProcessedDate='+processedDateString;//2019-01-19
            //System.debug('requeststring ******* '+ reqBody);
            reqWrapper.endPoint = endPoint;
            reqWrapper.methodType = conDetails.Method_Type__c;
            //reqWrapper.jsonReqBody = reqBody;
            reqWrapper.serviceName = 'CSS_SBL_FailCodes';
            //outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper); //Commented as part of Mule Integration
            outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            System.debug('outputWrapper ******* '+ outputWrapper.response.getBody());
            //failCodeWrapper = (CSS_SiebelFailCodeResponseJ2A)JSON.deserialize(outputWrapper.response.getBody(),CSS_SiebelFailCodeResponseJ2A.class);
            //system.debug('failCodeWrapper >>> '+failCodeWrapper);

            if(outputWrapper != null && outputWrapper.response != null && outputWrapper.response.getBody() != null){
                insertResponse(outputWrapper.response.getBody(), 'getFailCodes');
            }

        } catch(exception e){
            system.debug('Entered into catch of getFailCodes Method in CSS_FN_SIEBEL>>>'+e.getMessage() +e.getLineNumber());
        }
    }
    
    public static void insertAccountPayCodes(){
        CG_OP_OAGWrapper outputWrapper;
        //CSS_SiebelFailCodeResponseJ2A failCodeWrapper = new CSS_SiebelFailCodeResponseJ2A();
        try {
            date processedDate;

            List<CSS_JobEventTemporary__c> jobeventTemp = [SELECT Id, Name, Key__c, Attribute1__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes_LastProcessed' LIMIT 1];
            if(jobeventTemp != null && jobeventTemp.size() > 0) {
                if(jobeventTemp[0].Attribute1__c != null)
                    processedDate = date.valueof(jobeventTemp[0].Attribute1__c);
                else
                    processedDate = Date.Today();
            } else
                processedDate = Date.Today();
            system.debug(processedDate);
            string processedDateString = DateTime.newInstance(processedDate.year(),processedDate.month(),processedDate.day()).format('YYYY-MM-dd');//2018-01-14
            system.debug(processedDateString); 
            //Mule Integration start
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_AccountcodePaycodes');
            //Mule Integration end
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            //String reqBody = '{"Header": {"Sender": {"ServiceName": "GetFailCodes","SenderID": "CSS"},"Target": {"TargetID": "CSSWarranty"}},"DataArea": {"LAST_PROCESSED_DATE": "' + processedDateString + '"}}';//pass date and format.
            //String reqBody;
            String endPoint = conDetails.End_Point__c+'?sender=CSS&target=CSSWarranty&lastProcessedDate=2020-03-27';//2019-01-19
            //System.debug('requeststring ******* '+ reqBody);
            reqWrapper.endPoint = endPoint;
            reqWrapper.methodType = conDetails.Method_Type__c;
            //reqWrapper.jsonReqBody = reqBody;
            reqWrapper.serviceName = 'CSS_SBL_AccountcodePaycodes';
            //outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper); //Commented as part of Mule Integration
            outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            System.debug('outputWrapper ******* '+ outputWrapper.response.getBody());
            //failCodeWrapper = (CSS_SiebelFailCodeResponseJ2A)JSON.deserialize(outputWrapper.response.getBody(),CSS_SiebelFailCodeResponseJ2A.class);
            //system.debug('failCodeWrapper >>> '+failCodeWrapper);

            if(outputWrapper != null && outputWrapper.response != null && outputWrapper.response.getBody() != null){
                insertResponse(outputWrapper.response.getBody(), 'GetAccountCodes');
            }

        } catch(exception e){
            system.debug('Entered into catch of getGetAccountCodespaycodes Method in CSS_FN_SIEBEL>>>'+e.getMessage() +e.getLineNumber());
        }
    }

    public static void getCSSDetails(string ClaimNumber) {
        CG_OP_OAGWrapper outputWrapper;
        CG_PaidClaimsDetailsResWrapper paidClaimsWrapper = new CG_PaidClaimsDetailsResWrapper();
        try {
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            
            //Mule Integration start
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_CSSDetails');
            //Mule Integration end
            
            //String reqBody = '{"Header": {"Sender": {"MessageID": "UniqueID","ServiceName": "getPaidClaimsDetails","SenderID": "CSS"}},"DataArea": {"IMSClaimNumber": "","ClaimNumber": "'+ ClaimNumber + '"}}';//pass the Claim number.
            
            String endPoint = conDetails.End_Point__c+'?sender=CSS&target=CSSWarranty&claimNumber='+ ClaimNumber +'&imsClaimNumber='; //&claimNumber=13465195&imsClaimNumber=
            reqWrapper.endPoint = endPoint;
            reqWrapper.methodType = conDetails.Method_Type__c;
            //System.debug('reqBody ******* '+ reqBody);
            //reqWrapper.jsonReqBody = reqBody;
            reqWrapper.serviceName = 'CSS_SBL_CSSDetails';
            //outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
            outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            if(outputWrapper != null && outputWrapper.response != null && outputWrapper.response.getBody() != null){
                System.debug('outputWrapper.response.getBody() ******* '+ outputWrapper.response.getBody());
            }

        } catch(exception e){
            system.debug('Entered into catch of getFailCodes Method in CSS_FN_SIEBEL>>>'+e.getMessage() +e.getLineNumber());
        }
    }

    public static void getPaymentDetails(List<CSS_Claim_Submission__c> siebelClaimNumber) {
        CG_OP_OAGWrapper outputWrapper;
        String claimNumID = '[';
        system.debug('siebelClaimNumber' + ' ' + siebelClaimNumber);
        for(CSS_Claim_Submission__c pd : siebelClaimNumber) {
            //claimNumID.add(pd.Claim_Number__c); 
            if(claimNumID == '[')
                claimNumID = claimNumID+'"'+pd.Claim_Number__c+'"';
            else
                claimNumID = claimNumID+',"'+pd.Claim_Number__c+'"';
            system.debug('claimNumID' + ' ' + claimNumID);
        }
        claimNumID = claimNumID + ']';
        try {
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            String GetPaymentDetailsReqBody = '{ "Header": { "Target" : { "TargetID":"SIEBEL"},"Sender":{"ServiceName": "getPaymentDetails","SenderID": "CSS"}},"DataArea": {"ClaimList" : { "ClaimNumber" :  ' + claimNumID + '  }}}';//pass the Claim number.
            System.debug('GetPaymentDetails reqBody ***'+ ' ' + GetPaymentDetailsReqBody);
            reqWrapper.jsonReqBody = GetPaymentDetailsReqBody;
            reqWrapper.serviceName = 'CG_SBL_ClaimPaymentStatus';
            outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
            //  String OAGWrapResp = '{ \"Header\": { \"ReturnCodeDescription\": \"<Message from Siebel>\", \"Status\": \"Success\", \"ReturnCode\": \"<MessageCode from Siebel>\", \"MessageIdentifier\": \"<Identifier from MW>\" }, \"DataArea\": [ { \"SiebelClaimNumber\": \"C0000190118\", \"IMSClaimNumber\": \"56270\", \"PayCode\": \"I\", \"ClaimStatus\": \"56275\", \"RejectionReason\": \"56275\", \"Type\": \"WO\", \"StatementNumber\": \"TEST\", \"CreditDate\": \"2010-03-19\", \"CreditNumber\": \"TEST\", \"Parts\": 56270, \"Labor\": 56275, \"Travel\": 56275, \"Other\": 987, \"Tax\": 987, \"PMU\": 56275, \"BFC\": 56275, \"Deductible\": 979, \"TotalPaid\": 955 }, { \"SiebelClaimNumber\": \"C0000190119\", \"IMSClaimNumber\": \"56270\", \"PayCode\": \"I\", \"ClaimStatus\": \"56275\", \"RejectionReason\": \"56275\", \"Type\": \"WO\", \"StatementNumber\": \"TEST\", \"CreditDate\": \"2010-03-19\", \"CreditNumber\": \"TEST\", \"Parts\": 56270, \"Labor\": 56275, \"Travel\": 56275, \"Other\": 987, \"Tax\": 987, \"PMU\": 56275, \"BFC\": 56275, \"Deductible\": 979, \"TotalPaid\": 955 } ] }';
            //  system.debug('Response of GetPaymentDetails' + ' ' + OAGWrapResp);
            String OAGWrapResp = outputWrapper.response.getbody();
            system.debug('OAGWrapResp' + ' ' + OAGWrapResp);
            CG_SiebelGetPaymentDetailsRespWrapper PaymentDetailsRespWrapper = new CG_SiebelGetPaymentDetailsRespWrapper();
            PaymentDetailsRespWrapper = (CG_SiebelGetPaymentDetailsRespWrapper)JSON.deserializeStrict(OAGWrapResp, CG_SiebelGetPaymentDetailsRespWrapper.class);
            system.debug('Response of GetPaymentDetails ' + ' ' + PaymentDetailsRespWrapper);
        } catch(exception e){
            system.debug('Entered into catch of getPaymentDetails Method in CSS_FN_SIEBEL>>>'+e.getMessage() +e.getLineNumber());
        }
    }





    public static void insertFailCodeResponse(String responseBody) {
        System.debug('################# entered into insertFailCodeResponse method ###################');

        try {
            system.debug('responseBody-->'+responseBody);
            CSS_SiebelFailCodeResponseJ2A failCodeResponse;
            failCodeResponse = (CSS_SiebelFailCodeResponseJ2A)JSON.deserializeStrict(responseBody, CSS_SiebelFailCodeResponseJ2A.class);
            system.debug('failCodeResponse-->'+failCodeResponse);
            System.debug('Response is inserted/updated successfully...');
        } catch(Exception ex) {
            System.debug('in catch of insertFailCodeResponse of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_SIEBEL-insertFailCodeResponse', 'CSS_JobEventTemporary__c insertion failed', 'CSS_JobEventTemporary__c insertion failed', 'SBL');
        }
    }

    //Method to get the data from Seibel
    //Author - karthik gorantla
    //Date - 1/22/2018
    public static void getFailModes()
    {
        CG_OP_OAGWrapper outputWrapper;
        try        
        {
            date processedDate; 
            List<CSS_JobEventTemporary__c> jobeventTemp = [SELECT Id, Name, Key__c, Attribute1__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'FailModeProcessedDate' LIMIT 1];
            System.debug('jobeventTemp ******* '+jobeventTemp);
            if(jobeventTemp != null && jobeventTemp.size() >0){
                if(jobeventTemp[0].Attribute1__c != null)
                    processedDate = date.valueof(jobeventTemp[0].Attribute1__c);
                else
                    processedDate = Date.Today();
            }
            else
                processedDate = Date.Today();

            system.debug('processedDate======>'+processedDate);
            string processedDateString = DateTime.newInstance(processedDate.year(),processedDate.month(),processedDate.day()).format('YYYY-MM-DD');//2018-01-14
            //Mule Integration start
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_FailModes');
            //Mule Integration end
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            //String reqBody = '{"Header": {"Sender": {"ServiceName": "getFailModes","SenderID": "CSS"},"Target": {"TargetID": "SIEBEL"}},"DataArea": {"LAST_PROCESSED_DATE": "' + processedDateString + '"}}';
            //System.debug('requeststring ******* '+ reqBody);
            //reqWrapper.jsonReqBody = reqBody;
            String endPoint = conDetails.End_Point__c;
            reqWrapper.endPoint = endPoint;
            reqWrapper.methodType = conDetails.Method_Type__c;
            reqWrapper.serviceName = 'CSS_SBL_FailModes';
            outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            //outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
            system.debug('======>'+outputWrapper);
            /// CSS_SBL_FailModes' has to insert in Custom settings

            if(outputWrapper != null && outputWrapper.response != null && outputWrapper.response.getBody() != null){
                // string tempResponse = '{\r\n\t\"Header\": {\r\n\t\t\"MessageIdentifier\": \"Identifier from MW\",\r\n\t\t\"ReturnCode\": \"<MessageCode from Siebel>\",\r\n\t\t\"ReturnCodeDescription\": \"<Message from Siebel>\",\r\n\t\t\"Status\": \"Success\"\r\n\t},\r\n\t\"DataArea\": [{\r\n\t\t\t\"FailModeCode\": \"BR1-BROKEN\",\r\n\t\t\t\"Description\": \"Broken Filter shell1\",\r\n\t\t\t\"Active\": \"Y\",\r\n\t\t\t\"Created\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"LastUpdated\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"BusinessUnit\": \"EBU\"\r\n\t\t},\r\n\t\t{\r\n\t\t\t\"FailModeCode\": \"BR2-BROKEN\",\r\n\t\t\t\"Description\": \"Broken Filter shell2\",\r\n\t\t\t\"Active\": \"Y\",\r\n\t\t\t\"Created\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"LastUpdated\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"BusinessUnit\": \"EBU\"\r\n\t\t},\r\n\t\t{\r\n\t\t\t\"FailModeCode\": \"BR3-BROKEN\",\r\n\t\t\t\"Description\": \"Broken Filter shell3\",\r\n\t\t\t\"Active\": \"Y\",\r\n\t\t\t\"Created\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"LastUpdated\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"BusinessUnit\": \"EBU\"\r\n\t\t},\r\n\t\t{\r\n\t\t\t\"FailModeCode\": \"BR4-BROKEN\",\r\n\t\t\t\"Description\": \"Broken Filter shell4\",\r\n\t\t\t\"Active\": \"N\",\r\n\t\t\t\"Created\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"LastUpdated\": \"2010-03-19T16:18:59.000-05:00\",\r\n\t\t\t\"BusinessUnit\": \"EBU\"\r\n\t\t}\r\n\t]\r\n}';
                //insertResponse(tempResponse, 'getFailModes');
                insertResponse(outputWrapper.response.getBody(), 'getFailModes');
                system.debug('======>outputWrapper.response.getBody'+outputWrapper.response.getBody());
            }

        } catch(exception e){
            system.debug('Entered into catch of getFailCodes Method in CSS_FN_SIEBEL>>>'+e.getMessage() +e.getLineNumber());
        }
    }



    public static void getTechInfoData(){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getTechInfoData method of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_SBL_GetTechInfoResJSON techInfoResJSON;
        CG_OP_OAGWrapper resWrapper;
        try{
            //Step1: retrieve request values from JobEventTemporary record
            //CSS_JobEventTemporary__c jobEventTempRecord = getJobEventRecord();
            CSS_JobEventTemporary__c jobEventTempRecord = getJobEventRecord('GetTechInfo');
            String lastProcessedDate;
            String spCodeStr;
            if(jobEventTempRecord != null && jobEventTempRecord.Id !=null){
                lastProcessedDate = jobEventTempRecord.Attribute1__c;
                spCodeStr =  jobEventTempRecord.Reason__c;
            }else
                lastProcessedDate = System.now().format('YYYY-MM-dd');
            //lastProcessedDate = '2017-04-11';
            System.debug('lastProcessedDate>>>>:'+lastProcessedDate);

            //Step2: Prepare Request JSON & execute GetTechInfo service
            //resWrapper = CG_SL_SIEBEL.callGetTechInfo(lastProcessedDate, spCodeStr);
            if(resWrapper == null){
                System.debug('########## Returning from here after execution fails ###############');   
            }
            system.debug('resWrapper>>>:'+resWrapper);
            system.debug('ResBody>>>:'+resWrapper.response.getBody());
            //System.debug('#####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());
            //String hardcodedRes = '{"DataArea":[{"PROMOTION_ID_FLAG":"Y","SP_CERTIFICATION":[{"SMN":"","OEM_NAME":"","START_DATE":"","END_DATE":""},{"SMN":"480 C-E","OEM_NAME":"CUMMINS MERCRUISER DIESEL","START_DATE":"2012-06-06T00:00:00.000-05:00","END_DATE":"2999-12-31T00:00:00.000-06:00"},{"SMN":"480 C-E","OEM_NAME":"CUMMINS","START_DATE":"2017-03-13T00:00:00.000-05:00","END_DATE":"2999-12-31T00:00:00.000-06:00"},{"SMN":"ZEUS 3500","OEM_NAME":"CUMMINS MERCRUISER DIESEL","START_DATE":"2012-06-06T00:00:00.000-05:00","END_DATE":"2999-12-31T00:00:00.000-06:00"}],"SP_CODE":"02004","PRODUCT_CERTIFICATION_FLAG":"Y","CERTIFICATIONENDDATE":"2016-04-20T00:00:00.000-05:00","WARRANTYTRAININGSTATUS":"Green","TERRITORY":"UNITED STATES","WRNTY_TRAINING_CERTIFICATION":"Y","REGION":"NORTH AMERICA","SPPROFILESTATUS":"Active","TECH_CERTIFICATION":[{"SMNDETAILS":[{"SMN":"","QUAL_PASS_DT":""}],"TechFName":"","TechPromoID":"","TechLogin":"","TechLName":""},{"SMNDETAILS":[{"SMN":"M11 CELECT","QUAL_PASS_DT":""}],"TechFName":"Enrique","TechPromoID":"1024109","TechLogin":"ki110","TechLName":"Varela"},{"SMNDETAILS":[{"SMN":"4B3.9","QUAL_PASS_DT":""}],"TechFName":"James","TechPromoID":"1030031","TechLogin":"ld093","TechLName":"Schwarzenbach"}]},{"PROMOTION_ID_FLAG":"N","SP_CERTIFICATION":[{"SMN":"","OEM_NAME":"","START_DATE":"","END_DATE":""}],"SP_CODE":"03526","PRODUCT_CERTIFICATION_FLAG":"N","CERTIFICATIONENDDATE":"2016-04-20T00:00:00.000-05:00","WARRANTYTRAININGSTATUS":"Green","TERRITORY":"UNITED STATES","WRNTY_TRAINING_CERTIFICATION":"N","REGION":"NORTH AMERICA","SPPROFILESTATUS":"Active","TECH_CERTIFICATION":[{"SMNDETAILS":[{"SMN":"4B3.9","QUAL_PASS_DT":""}],"TechFName":"Josh","TechPromoID":"1011202","TechLogin":"kt403","TechLName":"Hammitt"},{"SMNDETAILS":[{"SMN":"","QUAL_PASS_DT":""}],"TechFName":"Patti","TechPromoID":"B966208","TechLogin":"b966208","TechLName":"LaPaglia"}]}],"Header":{"ReturnCodeDescription":"","Status":"Success","ReturnCode":"","MessageIdentifier":"2018-01-14"}}';
            //String hardcodedRes = '{"DataArea":[{"PROMOTION_ID_FLAG":"Y","SP_CERTIFICATION":[{"SMN":"","OEM_NAME":"","START_DATE":"","END_DATE":""},{"SMN":"480 C-E","OEM_NAME":"CUMMINS MERCRUISER DIESEL","START_DATE":"2012-06-06T00:00:00.000-05:00","END_DATE":"2999-12-31T00:00:00.000-06:00"},{"SMN":"480 C-E","OEM_NAME":"CUMMINS","START_DATE":"2017-03-13T00:00:00.000-05:00","END_DATE":"2999-12-31T00:00:00.000-06:00"},{"SMN":"ZEUS 3500","OEM_NAME":"CUMMINS MERCRUISER DIESEL","START_DATE":"2012-06-06T00:00:00.000-05:00","END_DATE":"2999-12-31T00:00:00.000-06:00"},{"SMN":"ISC CM554","OEM_NAME":"CUMMINS","START_DATE":"2007-04-09T00:00:00.000-05:00","END_DATE":"2999-12-31T00:00:00.000-06:00"}],"SP_CODE":"02004","PRODUCT_CERTIFICATION_FLAG":"Y","CERTIFICATIONENDDATE":"2016-04-20T00:00:00.000-05:00","WARRANTYTRAININGSTATUS":"Green","TERRITORY":"UNITED STATES","WRNTY_TRAINING_CERTIFICATION":"Y","REGION":"NORTH AMERICA","SPPROFILESTATUS":"Active","TECH_CERTIFICATION":[{"SMNDETAILS":[{"SMN":"","QUAL_PASS_DT":""}],"TechFName":"","TechPromoID":"","TechLogin":"","TechLName":""},{"SMNDETAILS":[{"SMN":"M11 CELECT","QUAL_PASS_DT":""}],"TechFName":"Enrique","TechPromoID":"1024109","TechLogin":"ki110","TechLName":"Varela"},{"SMNDETAILS":[{"SMN":"4B3.9","QUAL_PASS_DT":""}],"TechFName":"James","TechPromoID":"1030031","TechLogin":"ld093","TechLName":"Schwarzenbach"},{"SMNDETAILS":[{"SMN":"ISC CM554","QUAL_PASS_DT":""}],"TechFName":"Jordan","TechPromoID":"B971189","TechLogin":"ib459","TechLName":"Guck"},{"SMNDETAILS":[{"SMN":"ISC CM554","QUAL_PASS_DT":""}],"TechFName":"Delane","TechPromoID":"A661340","TechLogin":"gq742","TechLName":"Schmidt"}]},{"PROMOTION_ID_FLAG":"N","SP_CERTIFICATION":[{"SMN":"","OEM_NAME":"","START_DATE":"","END_DATE":""}],"SP_CODE":"03526","PRODUCT_CERTIFICATION_FLAG":"N","CERTIFICATIONENDDATE":"2016-04-20T00:00:00.000-05:00","WARRANTYTRAININGSTATUS":"Green","TERRITORY":"UNITED STATES","WRNTY_TRAINING_CERTIFICATION":"N","REGION":"NORTH AMERICA","SPPROFILESTATUS":"Active","TECH_CERTIFICATION":[{"SMNDETAILS":[{"SMN":"4B3.9","QUAL_PASS_DT":""}],"TechFName":"Josh","TechPromoID":"1011202","TechLogin":"kt403","TechLName":"Hammitt"},{"SMNDETAILS":[{"SMN":"","QUAL_PASS_DT":""}],"TechFName":"Patti","TechPromoID":"B966208","TechLogin":"b966208","TechLName":"LaPaglia"}]}],"Header":{"ReturnCodeDescription":"","Status":"Success","ReturnCode":"","MessageIdentifier":"2018-01-14"}}';
            //techInfoResJSON = (CSS_WPR_SBL_GetTechInfoResJSON)JSON.deserializeStrict(hardcodedRes, CSS_WPR_SBL_GetTechInfoResJSON.class);
            techInfoResJSON = (CSS_WPR_SBL_GetTechInfoResJSON)JSON.deserializeStrict(resWrapper.response.getBody(), CSS_WPR_SBL_GetTechInfoResJSON.class);
            system.debug('techInfoResJSON>>>:'+techInfoResJSON);

            //Step3: insert GetTechInfo data
            if(techInfoResJSON ==null || techInfoResJSON.DataArea ==null || techInfoResJSON.DataArea.size()<=0)
                return;
            else
                insertTechInfoData(techInfoResJSON);

            //Step4: updating lastProcessedDate on lstJobEventTemp record
            if(jobEventTempRecord != null && jobEventTempRecord.Id != null){
                system.debug('stamping current processed date value -->');
                jobEventTempRecord.Attribute1__c = System.now().format('YYYY-MM-dd');
                update jobEventTempRecord;
            }
            system.debug('$$$$$ GetTechInfo process completed successfully $$$$$$$');
        }catch(Exception ex){
            System.debug('in catch of getTechInfoData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }




    /**
* Method is used to map the GetTechInfo webservice response and insert the data in respective object 
* 
*/
    public static void insertTechInfoData(CSS_WPR_SBL_GetTechInfoResJSON techInfoResJSON){
        //set to store all spcode from the response
        set<string> setSpCodes = new set<string>();
        //set to store the formated spcodes for the query 
        set<string> setFormatedSpCodes = new set<string>();
        //list to store all accounts matching the creiteria with spcode
        list<Account> lstAccount = new list<Account>();
        //map to store the spcode as key and  accountid as value 
        map<string,id> mapSpCodeAccountId = new map<string,id>();
        //map to store spcode to data Area of response 
        map<string,CSS_WPR_SBL_GetTechInfoResJSON.DataArea> mapSpCodesDataArea = new map<string,CSS_WPR_SBL_GetTechInfoResJSON.DataArea>();
        //set to store all SMN which came in response
        set<string> setAllSMN = new set<string>();

        set<string> setConcatenatedKey = new set<string>();

        //set to store al account ids queried based on spcode 
        set<Id> setAccountIds = new set<Id>();


        list<CSS_Accreditation__c> lstToUpdateAccreditation  = new list<CSS_Accreditation__c>();
        //map to stroe <SMN, coresponding existing CSS_Accreditation__c records >
        map<string,CSS_Accreditation__c> mapSMNtoAccreditation = new map<string,CSS_Accreditation__c>();

        //list to store all existing CSS_AccredUser__c
        list<CSS_AccredUser__c> lstToUpdateAccredUser = new list<CSS_AccredUser__c>();
        //populating the set with all spcode from response 
        for(CSS_WPR_SBL_GetTechInfoResJSON.DataArea da : techInfoResJSON.DataArea){
            //building set of all spcode to fetch all accounts based on it 
            setSpCodes.add(string.valueOf(da.SP_CODE));
            //building map for sp code as a key and all values for the data area to be used to map account data
            mapSpCodesDataArea.put(string.valueOf(da.SP_CODE),da);
            system.debug('size of Tech cert list-->'+da.TECH_CERTIFICATION.size());

            //building set of smns from tech certification
            for(CSS_WPR_SBL_GetTechInfoResJSON.TECH_CERTIFICATION techcert : da.TECH_CERTIFICATION){
                if(string.isNotBlank(techcert.SMNDETAILS[0].SMN)){
                    setAllSMN.add(da.SP_CODE+techcert.SMNDETAILS[0].SMN); 
                    system.debug('My map value---------------'+mapSpCodesDataArea);
                }

                if(string.isNotBlank(techcert.SMNDETAILS[0].SMN) && string.isNotBlank(techcert.TechLogin)){
                    setConcatenatedKey.add(da.SP_CODE+techcert.SMNDETAILS[0].SMN+techcert.TechLogin);
                }
            }
            system.debug('size of set of smn+spcodes'+setAllSMN.size());
        }

        if(setSpCodes != null && setSpCodes.size() > 0){
            //preparing set for the query to use like operator 
            for(string s : setSpCodes){
                setFormatedSpCodes.add('%'+s);  
            }
        }

        if(setFormatedSpCodes != null && setFormatedSpCodes.size() > 0){
            //query all accounts matching spcodes with the last five digit of the location code 
            lstAccount = [SELECT Id,Product_Certification__c,WR_WWSPS_Cert_Date__c,Territory__c,Warranty_Training_Certification__c,
                          Region__c,WWSPS_Profile_Status__c,Promotion_Id_Flag__c,Location__c
                          FROM Account
                          WHERE  Location__c 
                          LIKE : setFormatedSpCodes ];
        }
        System.debug('lstAccount size>>>>>>>:'+lstAccount.size()+' setFormatedSpCodes>>>:'+setFormatedSpCodes);
        if(lstAccount == null || lstAccount.size() <= 0){
            System.debug('$$$$$$$$$$$$$ No Accounts found to update & returning from here $$$$$$$$$$$$$$$$$$');
            return;
        }

        //Step1: Updating Accounts
        //mapping of the account fields with respective response field data 
        for(Account acc:lstAccount){
            setAccountIds.add(acc.id);
        }//end of for loop 


        if((setAccountIds != null && setAccountIds.size() > 0) && 
           (setAllSMN != null && setAllSMN.size() > 0)){
            lstToUpdateAccreditation = [SELECT id,Account__c,Service_Model_Name__c,StartDate__c, EndDate__c,QUAL_PROG_ID__c,Certification_Status__c,Location_SMN_Key__c
                                        FROM CSS_Accreditation__c
                                        WHERE Location_SMN_Key__c IN : setAllSMN]; //why setAllSMN??? instead of SP_CERTIFICATION level only
        }
        System.debug('lstToUpdateAccreditation size>>>>>>>>>>>:'+lstToUpdateAccreditation.size() + ' setAllSMN size>>:'+setAllSMN.size()+' setAllSMN>>:'+setAllSMN);

        //building map for smn and CSS_Accreditation__c existing records to update 
        for(CSS_Accreditation__c existingAcr: lstToUpdateAccreditation){
            mapSMNtoAccreditation.put(existingAcr.Location_SMN_Key__c,existingAcr);
        }


        CSS_Accreditation__c accred;
        //Step3: Updating CSS_AccredUser__c
        //query to get existing css_Accreduser
        if(setConcatenatedKey != null && setConcatenatedKey.size() > 0){
            lstToUpdateAccredUser = [SELECT id,First_Name__c,Last_Name__c,Promotion_Id__c,Accreditation__c,
                                     User_Login_ID__c,Passed_Date_SBL__c,ServiceModelName__c,GetTechInfo_Concatenated_key__c
                                     FROM CSS_AccredUser__c
                                     WHERE GetTechInfo_Concatenated_key__c IN : setConcatenatedKey];
        }
        //map to stroe concatenated key and accred user  
        map<string,CSS_AccredUser__c> mapConcatenatedKeyToExistingAccrdUser = new map<string,CSS_AccredUser__c>();
        map<string,CSS_AccredUser__c> mapNewSMNtoAccredUser = new map<string,CSS_AccredUser__c>();
        for(CSS_AccredUser__c accredUser : lstToUpdateAccredUser){
            mapConcatenatedKeyToExistingAccrdUser.put(accredUser.GetTechInfo_Concatenated_key__c,accredUser);
        }
        //map to store <smn,CSS_Accreditation__c.Id>
        //map<string,id> mapSMNtoNewAccreditation = new map<string,Id>();
        //if(lstAccreditation != null && lstAccreditation.size()> 0){
        if(techInfoResJSON.DataArea != null && techInfoResJSON.DataArea.size()> 0){
            try{
                system.debug('mapConcatenatedKeyToExistingAccrdUser>>>:'+mapConcatenatedKeyToExistingAccrdUser);
                //mapping to insert CSS_AccredUser__c records for the spcodes SP_CERTIFICATION records
                for(CSS_WPR_SBL_GetTechInfoResJSON.DataArea da : techInfoResJSON.DataArea){
                    for(CSS_WPR_SBL_GetTechInfoResJSON.TECH_CERTIFICATION techcert : da.TECH_CERTIFICATION){
                        if(da.SP_CODE != null && string.isNotBlank(da.SP_CODE) && techcert.SMNDETAILS[0].SMN != null && string.isNotBlank(techcert.SMNDETAILS[0].SMN)){
                            System.debug('in da.TECH_CERTIFICATION da.SP_CODE>>>:'+da.SP_CODE+' techcert.SMNDETAILS[0].SMN>>>:'+techcert.SMNDETAILS[0].SMN);
                            //mapping existing records for update
                            if((mapConcatenatedKeyToExistingAccrdUser != null && mapConcatenatedKeyToExistingAccrdUser.size() >0) &&
                               (mapConcatenatedKeyToExistingAccrdUser.containsKey(da.SP_CODE+techcert.SMNDETAILS[0].SMN + techcert.TechLogin))){
                                //mapConcatenatedKeyToExistingAccrdUser.get(da.SP_CODE + techcert.SMNDETAILS[0].SMN + techcert.TechLogin).Passed_Date_SBL__c = techcert.SMNDETAILS[0].QUAL_PASS_DT != null && techcert.SMNDETAILS[0].QUAL_PASS_DT != '' ? formatedDate(techcert.SMNDETAILS[0].QUAL_PASS_DT) : null; //date.valueOf( techcert.SMNDETAILS[0].QUAL_PASS_DT) : null;
                                mapConcatenatedKeyToExistingAccrdUser.get(da.SP_CODE + techcert.SMNDETAILS[0].SMN + techcert.TechLogin).First_Name__c = techcert.TechFName;
                                mapConcatenatedKeyToExistingAccrdUser.get(da.SP_CODE + techcert.SMNDETAILS[0].SMN + techcert.TechLogin).Last_Name__c = techcert.TechLName;
                                mapConcatenatedKeyToExistingAccrdUser.get(da.SP_CODE + techcert.SMNDETAILS[0].SMN + techcert.TechLogin).Promotion_Id__c = techcert.TechPromoID;
                                mapConcatenatedKeyToExistingAccrdUser.get(da.SP_CODE + techcert.SMNDETAILS[0].SMN + techcert.TechLogin).User_Login_ID__c = techcert.TechLogin;
                                mapConcatenatedKeyToExistingAccrdUser.get(da.SP_CODE + techcert.SMNDETAILS[0].SMN + techcert.TechLogin).ServiceModelName__c = techcert.SMNDETAILS[0].SMN;
                                system.debug('lstAccreduser update loop SMN-->'+mapConcatenatedKeyToExistingAccrdUser.get(da.SP_CODE + techcert.SMNDETAILS[0].SMN + techcert.TechLogin));
                                //lstAccreduser.add(mapConcatenatedKeyToExistingAccrdUser.get(da.SP_CODE + techcert.SMNDETAILS[0].SMN + techcert.TechLogin));
                                //system.debug('lstAccreduser update loop SMN-->'+techcert.SMNDETAILS[0].SMN+' da.SP_CODE>>>:'+da.SP_CODE);
                            }
                            //mapping the new record fields to insert 
                            else{
                                System.debug('in else da.TECH_CERTIFICATION da.SP_CODE>>>>:'+da.SP_CODE+' techcert.SMNDETAILS[0].SMN>>>:'+techcert.SMNDETAILS[0].SMN);
                                CSS_AccredUser__c accUsr = new CSS_AccredUser__c();
                                //accUsr.Passed_Date_SBL__c = techcert.SMNDETAILS[0].QUAL_PASS_DT != null && techcert.SMNDETAILS[0].QUAL_PASS_DT != '' ? formatedDate(techcert.SMNDETAILS[0].QUAL_PASS_DT) : null; //date.valueOf( techcert.SMNDETAILS[0].QUAL_PASS_DT) : null;
                                accUsr.First_Name__c = techcert.TechFName;
                                accUsr.Last_Name__c = techcert.TechLName;
                                accUsr.Promotion_Id__c = techcert.TechPromoID;
                                accUsr.User_Login_ID__c = techcert.TechLogin;
                                accUsr.ServiceModelName__c = techcert.SMNDETAILS[0].SMN;

                                if((mapSMNtoAccreditation !=null && mapSMNtoAccreditation.size() >0) &&
                                   (mapSMNtoAccreditation.containsKey(da.SP_CODE+techcert.SMNDETAILS[0].SMN))){
                                    accUsr.Accreditation__c = mapSMNtoAccreditation.get(da.SP_CODE+techcert.SMNDETAILS[0].SMN).Id;
                                    system.debug('lstAccreduser insert loop SMN-->'+techcert.SMNDETAILS[0].SMN+' da.SP_CODE>>>:'+da.SP_CODE);
                                    //if(accUsr != null && accUsr.Accreditation__c != null){
                                    //mapConcatenatedKeyToExistingAccrdUser.put(da.SP_CODE + techcert.SMNDETAILS[0].SMN + techcert.TechLogin, accUsr);
                                    //}
                                }

                                mapConcatenatedKeyToExistingAccrdUser.put(da.SP_CODE + techcert.SMNDETAILS[0].SMN + techcert.TechLogin, accUsr);

                            }
                        }
                    }//end of tech certification loop 

                }//end of dataArea outer loop

                if(mapConcatenatedKeyToExistingAccrdUser != null && mapConcatenatedKeyToExistingAccrdUser.size() > 0){
                    try{
                        upsert mapConcatenatedKeyToExistingAccrdUser.values();
                    }
                    catch(Exception e){
                        system.debug('in Upsert of mapConcatenatedKeyToExistingAccrdUser Error occured at line>>:'+e.getLineNumber()+' Error Message>>>:'+e.getMessage());
                    }
                }

                /* //updating New SMNs which are not available at SP_CODE level to CSS_Accreditation__c/AccredUser
                if(mapNewSMNtoAccreditation != null && mapNewSMNtoAccreditation.size() > 0){
                    try{
                        upsert mapNewSMNtoAccreditation.values();
                        for(String accredUserKey :mapNewSMNtoAccredUser.keySet()){
                            mapNewSMNtoAccredUser.get(accredUserKey).Accreditation__c = mapNewSMNtoAccreditation.get(accredUserKey.split('-')[0]).Id;
                        }
                        //add above inserted Accreditation ids to AccredUser
                        upsert mapNewSMNtoAccredUser.values();
                    }
                    catch(Exception e){
                        system.debug('in Upsert of mapNewSMNtoAccreditation Error occured at line>>:'+e.getLineNumber()+' Error Message>>>:'+e.getMessage());
                    }
                }*/

            }catch(Exception e){
                system.debug('Error occured at line>>:'+e.getLineNumber()+' Error Message>>>:'+e.getMessage());
            }
        }

    }


    /**
* This is used for getting CSS_JobEventTemporary__c record for GetTechInfo/GetSPInfo
* 
*/
    public static CSS_JobEventTemporary__c getJobEventRecord(String serviceName){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getJobEventRecord webservice of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<CSS_JobEventTemporary__c> lstJobEventTemp;
        CSS_JobEventTemporary__c jobEvent;
        //string spCodeStr; 
        try{
            //String serviceName = 'GetTechInfo';
            lstJobEventTemp = [SELECT Id, Reason__c, Attribute1__c FROM CSS_JobEventTemporary__c WHERE Name =:serviceName limit 1];
            system.debug('lstJobEventTemp List-->'+lstJobEventTemp);
            if(lstJobEventTemp == null || lstJobEventTemp.size() <= 0){
                jobEvent = new CSS_JobEventTemporary__c();
                jobEvent.name = serviceName;
                jobEvent.Attribute1__c = System.now().format('YYYY-MM-dd');
                system.debug('inside insert jobevent');
                insert jobEvent;
                system.debug('jobEvent id-->'+jobEvent.id);
            }else if(lstJobEventTemp != null && lstJobEventTemp.size() > 0){
                jobEvent =  lstJobEventTemp[0];
                system.debug('jobEvent-->'+jobEvent);
            }

        }catch(Exception ex){
            System.debug('in catch of prepareReqJSONForTechInfo of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return jobEvent;
    }

    //Method to split the string spcode and send it as list for ws call
    public static list<string> getSpCodelist(string spCodeStr){
        list<string> lstpart = new list<string>();
        if(string.isNotBlank(spCodeStr)){
            lstpart = spCodeStr.split(',');
        }
        return lstpart;
    }

    //method to format the date 
    public static date formatedDate(string sdate){
        list<string> lstpart = new list<string>();
        date dt;
        if(string.isNotBlank(sdate)){
            lstpart = sdate.split('T');
        }
        if(lstpart != null && lstpart.size() > 0) {
            dt= date.valueof(lstPart[0]);
        }
        return dt;
    }


    public static void getSPInfoData(){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getSPInfoData method of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CG_OP_GetSPInfoResJSON spInfoResJSON;
        CG_OP_OAGWrapper resWrapper;
        String lastProcessedDate;
        String spCodeStr;
        try{
            //Step1: retrieve request values from JobEventTemporary record
            CSS_JobEventTemporary__c jobEventTempRecord = getJobEventRecord('GetSPInfo');
            if(jobEventTempRecord != null && jobEventTempRecord.Id !=null){
                lastProcessedDate = jobEventTempRecord.Attribute1__c;
                spCodeStr =  jobEventTempRecord.Reason__c;
            }else
                lastProcessedDate = System.now().format('YYYY-MM-dd');
            //lastProcessedDate = '2018-07-24'; //To Get Test Data
            //lastProcessedDate = '2018-09-07'; //To Get Test Data
            //lastProcessedDate = '2018-10-03'; //To Get Test Data
            //spCodeStr = '04892'; //To Get Test Data
            //spCodeStr = '04892,19134,33508,13437'; //To Get Test Data
            System.debug('lastProcessedDate>>>>:'+lastProcessedDate+' spCodeStr>>>>:'+spCodeStr);

            //Step2: Prepare Request JSON & execute GetSPInfo service
            //resWrapper = CG_SL_SIEBEL.callGetSPInfo(lastProcessedDate, spCodeStr);
            if(resWrapper == null){
                System.debug('########## Returning from here after execution fails ###############'); 
            }
            System.debug('resWrapper>>>:'+resWrapper+' #####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());
            //String hardcodedRes = '{"DataArea":[{"ACCOUNT_STATUS":"Active","PRODUCT_CERTIFICATION_FLAG":"N","SP_NAME":"R & L CARRIERS, INC.","SP_PHONE":"","UPDATED_DATE":"2018-04-05 13:29:43.0","SP_BILL_TO_NAME":"EAST - NEW HUDSON","RSS_RESP_BRANCH_NAME":"R & L CARRIERS, INC.","CREATED_DATE":"2016-11-17 16:07:20.0","PROMOTION_ID_FLAG":"N","BUSINESS_UNIT":"EBU","WWSPS_FLAG":"Y","REGION":"NORTH AMERICA","DIST_HQ_CODE":"02850","SP_CHANNEL_OF_DISTRIBUTION":"150-NATIONAL ACCT AUTOMOTIVE","SP_CERTIFICATION":[{"SMN":"6C8.3","START_DATE":"2006-12-07 00:00:00.0","OEM_NAME":"INDEPENDENT","PRODUCT_DETAILS":[{"PRODUCT_RANGE":"Mid-Range","PRODUCT_TYPE":"Electronics","MARKET_APPLICATION":"AUTOMOTIVE"}],"END_DATE":"2999-12-31 00:00:00.0","SERVICE_LEVEL":"FULL SERVICE"},{"SMN":"NH/NT 855","START_DATE":"2006-12-07 00:00:00.0","OEM_NAME":"INDEPENDENT","PRODUCT_DETAILS":[{"PRODUCT_RANGE":"Heavy Duty","PRODUCT_TYPE":"Mechanical","MARKET_APPLICATION":"AUTOMOTIVE"}],"END_DATE":"2999-12-31 00:00:00.0","SERVICE_LEVEL":"FULL SERVICE"}],"WARRANTY_TRAINING_STATUS":"Y","SP_CODE":30423,"RESP_BRANCH_NAME":"EAST - CINCINNATI","RESP_BRANCH_CODE":"02374","SP_RECERTIFICATION_DATE":"2017-12-06 00:00:00.0","SP_LAST_NAME":"Huffman","TERRITORY":"UNITED STATES","SP_FIRST_NAME":"Shayne","SP_EMAIL":"","RSS_RESP_BRANCH_CODE":"04438","DIST_HQ_NAME":"EAST - NEW HUDSON","CERTIFICATION_END_DATE":"2016-04-20 00:00:00.0","WRNTY_TRAINING_CERTIFICATION":"N","SP_BILL_TO_CODE":"02850"},{"ACCOUNT_STATUS":"Active","PRODUCT_CERTIFICATION_FLAG":"N","SP_NAME":"????RETIFICA RONDONOPOLIS","SP_PHONE":"","UPDATED_DATE":"2018-04-06 19:51:24.0","SP_BILL_TO_NAME":"CUMMINS VENDAS E SERVI€OS DE MOTORES E GERADORES LTDA.","RSS_RESP_BRANCH_NAME":"CUMMINS VENDAS E SERVI€OS DE MOTORES E GERADORES LTDA.","CREATED_DATE":"2017-07-18 14:04:20.0","PROMOTION_ID_FLAG":"N","BUSINESS_UNIT":"EBU","WWSPS_FLAG":"Y","REGION":"INTERNATIONAL","DIST_HQ_CODE":57235,"SP_CHANNEL_OF_DISTRIBUTION":"110-DEALER","SP_CERTIFICATION":[{"SMN":"ISBE CM800","START_DATE":"2017-08-01 00:00:00.0","OEM_NAME":"CUMMINS","PRODUCT_DETAILS":[{"PRODUCT_RANGE":"Mid-Range","PRODUCT_TYPE":"Electronics","MARKET_APPLICATION":"AUTOMOTIVE"}],"END_DATE":"2018-06-09 00:00:00.0","SERVICE_LEVEL":"FULL SERVICE"}],"WARRANTY_TRAINING_STATUS":"","SP_CODE":84565,"RESP_BRANCH_NAME":"CUMMINS VENDAS E SERVI€OS DE MOTORES E GERADORES LTDA.","RESP_BRANCH_CODE":57324,"SP_RECERTIFICATION_DATE":"2018-06-13 00:00:00.0","SP_LAST_NAME":"","TERRITORY":"BRAZIL","SP_FIRST_NAME":"","SP_EMAIL":"","RSS_RESP_BRANCH_CODE":57324,"DIST_HQ_NAME":"CUMMINS VENDAS E SERVI€OS DE MOTORES E GERADORES LTDA.","CERTIFICATION_END_DATE":"","WRNTY_TRAINING_CERTIFICATION":"N","SP_BILL_TO_CODE":57235}],"Header":{"Status":"SUCCESS","MessageIdentifier":"2018-04-03"}}';
            //spInfoResJSON = (CG_OP_GetSPInfoResJSON)JSON.deserializeStrict(hardcodedRes, CG_OP_GetSPInfoResJSON.class);
            spInfoResJSON = (CG_OP_GetSPInfoResJSON)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_GetSPInfoResJSON.class);
            system.debug('spInfoResJSON>>>:'+spInfoResJSON);

            //Step3: insert GetTechInfo data
            if(spInfoResJSON ==null || spInfoResJSON.DataArea ==null || spInfoResJSON.DataArea.size()<=0) 
                return;
            else
                insertSPInfoData(spInfoResJSON);

            //Step4: updating lastProcessedDate on lstJobEventTemp record
            if(jobEventTempRecord != null && jobEventTempRecord.Id != null){
                system.debug('stamping current processed date value -->');
                jobEventTempRecord.Attribute1__c = System.now().format('YYYY-MM-dd');
                update jobEventTempRecord;
            }
            system.debug('$$$$$ getSPInfoData process completed successfully $$$$$$$');
        }catch(Exception ex){
            System.debug('in catch of getSPInfoData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }




    public static void insertSPInfoData(CG_OP_GetSPInfoResJSON spInfoResJSON){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into insertSPInfoData webservice of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<Account> accountList;
        set<String> hqCodes;
        set<string> setAllSMN = new set<string>();
        map<string,id> mapSpCodeAccountId = new map<string,id>();
        try{
            if(spInfoResJSON ==null || spInfoResJSON.DataArea ==null || spInfoResJSON.DataArea.size()<=0)
                return;

            hqCodes = new set<String>();
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
            Map<String,CG_OP_GetSPInfoResJSON.DataArea> mapSpCodesDataArea = new Map<String,CG_OP_GetSPInfoResJSON.DataArea>();
            List<CSS_OEM_AFFILIATIONS__c> oemLstToInsert = new List<CSS_OEM_AFFILIATIONS__c>();
            for(CG_OP_GetSPInfoResJSON.DataArea da : spInfoResJSON.DataArea){
                //building set of all spcode to fetch all accounts based on it 
                setSpCodes.add(String.valueOf(da.SP_CODE));
                mapSpCodesDataArea.put(String.valueOf(da.SP_CODE),da);
                if(da.DIST_HQ_CODE !=null && da.DIST_HQ_CODE.trim() !='')
                    hqCodes.add('%'+da.DIST_HQ_CODE);
                for(CG_OP_GetSPInfoResJSON.SP_CERTIFICATION spcert :da.SP_CERTIFICATION){
                    if(string.isNotBlank(spcert.SMN)){
                        setAllSMN.add(da.SP_CODE+spcert.SMN);
                    }
                }                
            }
            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add('%'+s);
                }
            }
            List<Account> accountHQList = new List<Account>([select Id, Location__c from Account where Location__c LIKE :hqCodes ]);
            Map<String, Id> hqAccountIds = new Map<String, Id>();
            Set<Id> accountIdSet = new Set<Id>();
            for(Account acc : accountHQList){
                hqAccountIds.put(acc.Location__c.right(5), acc.Id);                
            }
            List<CSS_OEM_AFFILIATIONS__c> oemLstToDel = new List<CSS_OEM_AFFILIATIONS__c>();            
            accountList = new List<Account>([select Id, Name, Location__c, DIST_HQ_CODE__c from Account where Location__c LIKE :setFormatedSpCodes ]); //need to query all fields ???
            System.debug('accountList>>>:'+accountList);
            CG_OP_GetSPInfoResJSON.DataArea daTemp;
            if(accountList == null || accountList.size()<=0){
                System.debug('accountList size>>>:'+accountList.size());
                return;
            }

            for(Account acc : accountList){
                daTemp = mapSpCodesDataArea.get(acc.Location__c.right(5));
                acc.DIST_HQ_CODE__c = daTemp.DIST_HQ_CODE;
                acc.CHANNEL_OF_DISTRIBUTION__c = daTemp.SP_CHANNEL_OF_DISTRIBUTION;
                acc.CHANNEL_CODE__c = daTemp.SP_CHANNEL_CODE;
                acc.RSS_RESP_BRANCH_CODE__c = daTemp.RSS_RESP_BRANCH_CODE;
                acc.RSS_RESP_BRANCH_NAME__c = daTemp.RSS_RESP_BRANCH_NAME;
                acc.RESP_BRANCH_CODE__c = daTemp.RESP_BRANCH_CODE;
                acc.RESP_BRANCH_NAME__c = daTemp.RESP_BRANCH_NAME;
                acc.BILL_TO_CODE__c = daTemp.SP_BILL_TO_CODE;
                acc.BILL_TO_NAME__c = daTemp.SP_BILL_TO_NAME;
                acc.DIST_HQ_NAME__c = daTemp.DIST_HQ_NAME;
                acc.Primary_Contact_FIRST_NAME__c = daTemp.SP_FIRST_NAME;
                acc.Primary_Contact_LAST_NAME__c = daTemp.SP_LAST_NAME;
                acc.Primary_Contact_PHONE__c = daTemp.SP_PHONE;
                acc.Primary_Contact_EMAIL__c = daTemp.SP_EMAIL;
                //acc.WWSPS_FLAG__c = daTemp.WWSPS_FLAG;
                acc.ACCOUNT_STATUS__c = daTemp.ACCOUNT_STATUS;
                acc.BUSINESS_UNIT__c = daTemp.BUSINESS_UNIT;
                acc.WWSPS_FLAG__c = daTemp.WWSPS_FLAG != null && daTemp.WWSPS_FLAG.trim() != ''  && daTemp.WWSPS_FLAG.trim() =='Y' ? true : false;
                acc.Promotion_Id_Flag__c = daTemp.PROMOTION_ID_FLAG != null && daTemp.PROMOTION_ID_FLAG.trim() != ''  && daTemp.PROMOTION_ID_FLAG.trim() =='Y' ? true : false;
                acc.Product_Certification__c = daTemp.PRODUCT_CERTIFICATION_FLAG != null && daTemp.PRODUCT_CERTIFICATION_FLAG.trim() != ''  && daTemp.PRODUCT_CERTIFICATION_FLAG.trim()=='Y' ? true : false;
                acc.Warranty_Training_Status__c = daTemp.Warranty_Training_Status;
                acc.Warranty_Training_Certification__c = daTemp.WRNTY_TRAINING_CERTIFICATION != null && daTemp.WRNTY_TRAINING_CERTIFICATION.trim() != ''  && daTemp.WRNTY_TRAINING_CERTIFICATION.trim()=='Y' ? true : false;
                acc.Territory__c = daTemp.TERRITORY;
                acc.Region__c = daTemp.REGION;
                acc.SPCOUNTRY__c = daTemp.SPCOUNTRY;
                acc.isCampTrp__c = daTemp.CAMPAIGN_TRP;//added for Kung-Fu Panda Story
                try{
                    acc.RECERTIFICATION_DATE__c = daTemp.SP_RECERTIFICATION_DATE != null && daTemp.SP_RECERTIFICATION_DATE.trim() != '' ? formatedDate(daTemp.SP_RECERTIFICATION_DATE) : null;
                }catch(Exception ex){
                    System.debug('in catch of RECERTIFICATION_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
                try{
                    acc.Primary_Contact_CREATED_DATE__c = daTemp.CREATED_DATE != null && daTemp.CREATED_DATE.trim() != '' ? formatedDate(daTemp.CREATED_DATE) : null;
                }catch(Exception ex){
                    System.debug('in catch of CREATED_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
                try{
                    acc.Primary_Contact_UPDATED_DATE__c = daTemp.UPDATED_DATE != null && daTemp.UPDATED_DATE.trim() != '' ? formatedDate(daTemp.UPDATED_DATE) : null;
                }catch(Exception ex){
                    System.debug('in catch of UPDATED_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
                try{
                    acc.CERTIFICATION_END_DATE__c = daTemp.CERTIFICATION_END_DATE != null && daTemp.CERTIFICATION_END_DATE.trim() != '' ? formatedDate(daTemp.CERTIFICATION_END_DATE) : null;
                }catch(Exception ex){
                    System.debug('in catch of CERTIFICATION_END_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
                if(daTemp.DIST_HQ_CODE != acc.Location__c.right(5)){
                    acc.Account__c = hqAccountIds.get(daTemp.DIST_HQ_CODE);  //assigning Account lookup based on DIST_HQ_CODE__c
                }
                if(daTemp.OEM_AFFILIATIONS != null) 
                    for(CG_OP_GetSPInfoResJSON.OEM_AFFILIATIONS oemAff : daTemp.OEM_AFFILIATIONS){
                        CSS_OEM_AFFILIATIONS__c oemRec = new CSS_OEM_AFFILIATIONS__c();
                        oemRec.LAST_UPDATED_DATE__c= oemAff.LAST_UPDATED_DATE;
                        oemRec.LAST_UPDATED_BY__c= oemAff.LAST_UPDATED_BY;
                        oemRec.SP_NAME__c= oemAff.SP_NAME;
                        oemRec.AFFILIATION__c= oemAff.AFFILIATION;
                        oemRec.PRIMARY__c= oemAff.PRIMARY;
                        oemRec.SP_CODE__c= oemAff.SP_CODE;
                        oemRec.Name= oemAff.AFFILIATION;
                        oemRec.Account__c = acc.Id;
                        oemLstToInsert.add(oemRec);
                    }
                mapSpCodeAccountId.put(acc.Location__c.right(5), acc.id);  //adding account Ids based SP_CODE
                accountIdSet.add(acc.id);
            }
            oemLstToDel = [SELECT Id FROM CSS_OEM_AFFILIATIONS__c WHERE Account__c=:accountIdSet]; 
            update accountList;
            if(oemLstToDel != null && oemLstToDel.size() > 0)
                delete oemLstToDel;
            if(oemLstToInsert != null && oemLstToInsert.size() > 0){
                insert oemLstToInsert;
            }
            System.debug('setAllSMN.size>>>:'+setAllSMN.size()+' mapSpCodeAccountId.size>>>:'+mapSpCodeAccountId.size());
            if(setAllSMN != null && setAllSMN.size() > 0 && mapSpCodeAccountId !=null && mapSpCodeAccountId.size()>0)
                updateAccreditationData(spInfoResJSON, setAllSMN, mapSpCodeAccountId);

        }catch(Exception ex){
            System.debug('in catch of insertSPInfoData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }

    }


    public static void updateAccreditationData(CG_OP_GetSPInfoResJSON spInfoResJSON, set<string> setAllSMN, map<string,id> mapSpCodeAccountId){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into updateAccreditationData method of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        list<CSS_Accreditation__c> lstToUpdateAccreditation  = new list<CSS_Accreditation__c>();
        map<string,CSS_Accreditation__c> mapSMNtoAccreditation = new map<string,CSS_Accreditation__c>();
        try{
            //Step2: Updating CSS_Accreditation__c
            //query to get all the CSS_Accreditation__c records whose accountIds and smn are present in the set with all accred users
            if(setAllSMN != null && setAllSMN.size() > 0 ){
                lstToUpdateAccreditation = [SELECT Id,Account__c,Service_Model_Name__c,StartDate__c,EndDate__c,SERVICE_LEVEL__c,Product_Details__c,Location_SMN_Key__c
                                            FROM CSS_Accreditation__c WHERE Location_SMN_Key__c IN : setAllSMN];
            }
            System.debug('lstToUpdateAccreditation size>>>>>>>>>>>:'+lstToUpdateAccreditation.size() + ' setAllSMN size>>:'+setAllSMN.size()+' setAllSMN>>:'+setAllSMN);

            //building map for smn and CSS_Accreditation__c existing records to update 
            for(CSS_Accreditation__c existingAcr: lstToUpdateAccreditation){
                mapSMNtoAccreditation.put(existingAcr.Location_SMN_Key__c, existingAcr);
            }

            CSS_Accreditation__c accred;
            //mapping to insert CSS_Accreditation__c records for the spcodes SP_CERTIFICATION records mapSMNtoAccreditation
            for(CG_OP_GetSPInfoResJSON.DataArea da : spInfoResJSON.DataArea){
                system.debug('accreditation loop spcode --->'+da.SP_CODE);
                for(CG_OP_GetSPInfoResJSON.SP_CERTIFICATION spcert : da.SP_CERTIFICATION){
                    if(spcert.SMN != null && spcert.SMN != ''){
                        //System.debug('mapSMNtoAccreditation size>>>>:'+mapSMNtoAccreditation.size()+' da.SP_CODE+spcert.SMN>>>:'+da.SP_CODE+spcert.SMN+' mapSMNtoAccreditation>>>>:'+mapSMNtoAccreditation);
                        //compare the SMN from Response to check whether it is already exist in CSS app
                        if((mapSMNtoAccreditation != null && mapSMNtoAccreditation.size() > 0) && (mapSMNtoAccreditation.containsKey(da.SP_CODE+spcert.SMN)) ){
                            //system.debug('mapSMNtoAccreditation update loop -->'+spcert.SMN+' da.SP_CODE>>>:'+da.SP_CODE);
                            //map the values from response to the existing CSS_Accreditation__c
                            mapSMNtoAccreditation.get(da.SP_CODE+spcert.SMN).OEM_Name__c = spcert.OEM_NAME;
                            mapSMNtoAccreditation.get(da.SP_CODE+spcert.SMN).OEM_Code__c = spcert.OEM_CODE;
                            mapSMNtoAccreditation.get(da.SP_CODE+spcert.SMN).SERVICE_LEVEL__c = spcert.SERVICE_LEVEL;

                            try{
                                mapSMNtoAccreditation.get(da.SP_CODE+spcert.SMN).StartDate__c = spcert.START_DATE != null && spcert.START_DATE.trim() != '' ? formatedDate(spcert.START_DATE) : null;
                            }catch(Exception ex){
                                System.debug('in catch of spcert.START_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                            }
                            try{
                                mapSMNtoAccreditation.get(da.SP_CODE+spcert.SMN).EndDate__c = spcert.END_DATE != null && spcert.END_DATE.trim() != '' ? formatedDate(spcert.END_DATE) : null;
                            }catch(Exception ex){
                                System.debug('in catch of spcert.END_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                            }

                            //Product Details logic here
                            if(spcert.Product_Details != null){
                                try{
                                    mapSMNtoAccreditation.get(da.SP_CODE+spcert.SMN).Product_Details__c = JSON.serialize(spcert.Product_Details);
                                }catch(Exception ex){
                                    System.debug('in catch of Product_Details of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                                }
                            }


                        }else{
                            //system.debug('mapSMNtoAccreditation insert loop -->'+spcert.SMN+' da.SP_CODE>>>:'+da.SP_CODE);
                            //records which are new in response 
                            //creating new records 
                            accred = new CSS_Accreditation__c();
                            accred.isSMNAccountLevel__c = true;
                            accred.Service_Model_Name__c = spcert.SMN;
                            accred.OEM_Name__c = spcert.OEM_NAME;
                            accred.OEM_Code__c = spcert.OEM_CODE;
                            accred.SERVICE_LEVEL__c = spcert.SERVICE_LEVEL;
                            try{
                                accred.StartDate__c = spcert.START_DATE != null && spcert.START_DATE.trim() != '' ? formatedDate(spcert.START_DATE) : null;
                            }catch(Exception ex){
                                System.debug('in catch of spcert.START_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                            }
                            try{
                                accred.EndDate__c = spcert.END_DATE != null && spcert.END_DATE.trim() != '' ? formatedDate(spcert.END_DATE) : null;
                            }catch(Exception ex){
                                System.debug('in catch of spcert.END_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                            }

                            //Product Details logic here
                            if(spcert.Product_Details != null){
                                try{
                                    accred.Product_Details__c = JSON.serialize(spcert.Product_Details);
                                }catch(Exception ex){
                                    System.debug('in catch of Product_Details of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                                }
                            }
                            if(mapSpCodeAccountId != null && mapSpCodeAccountId.size()>0){
                                accred.Account__c = mapSpCodeAccountId.get(da.SP_CODE);
                            }
                            mapSMNtoAccreditation.put(da.SP_CODE+spcert.SMN, accred);

                        }
                    }
                }
            }

            if(mapSMNtoAccreditation != null && mapSMNtoAccreditation.size()> 0){
                try{
                    System.debug('before upsert mapSMNtoAccreditation>>>:'+mapSMNtoAccreditation);
                    upsert mapSMNtoAccreditation.values();
                    System.debug('after upsert mapSMNtoAccreditation>>>:'+mapSMNtoAccreditation);
                }catch(Exception ex){
                    System.debug('in catch of mapSMNtoAccreditation upsert of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
            }


        }catch(Exception ex){
            System.debug('in catch of updateAccreditationData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
    }


    // ########## New SPTechInfo Services Code Start ###########
    /**
    * This method is used for SP Header incremental data to upsert in Account object
    *
    */
    public static void getSPHeaderData(){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getSPHeaderData method of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CG_WPR_SBL_SPHeader spHeaderResJSON;
        CG_OP_OAGWrapper resWrapper;
        String lastProcessedDate;
        try{
            //Step1: retrieve request values from JobEventTemporary record
            CSS_JobEventTemporary__c jobEventTempRecord = getJobEventRecord('GetSPHeader');
            if(jobEventTempRecord != null && jobEventTempRecord.Id !=null){
                lastProcessedDate = jobEventTempRecord.Attribute1__c;
            }else
                lastProcessedDate = System.now().format('YYYY-MM-dd');
            //lastProcessedDate = '2018-07-24'; //To Get Test Data
            System.debug('lastProcessedDate>>>>:'+lastProcessedDate);

            //Step2: Prepare Request JSON & execute GetSPInfo service
            resWrapper = CG_SL_SIEBEL.callGetInfoService(lastProcessedDate, 'GetSPHeader');
            if(resWrapper == null){
                System.debug('########## Returning from here after execution fails ###############'); 
            }
            System.debug('resWrapper>>>:'+resWrapper+' #####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());
            //String hardcodedRes = '{"DataArea":[{"SP_CODE":"02004","SP_ROW_ID":"120000234","SP_NAME":"Cummins Central","SP_CHANNEL_OF_DISTRIBUTION":"","SP_CHANNEL_CODE":"","RSS_RESP_BRANCH_CODE":"57324","RSS_RESP_BRANCH_NAME":"CUMMINS VENDAS E SERVI€OS DE MOTORES EGERADORES LTDA","RESP_BRANCH_CODE":"","RESP_BRANCH_NAME":"","SP_BILL_TO_CODE":"","SP_BILL_TO_NAME":"","DIST_HQ_CODE":"","DIST_HQ_NAME":"","SP_FIRST_NAME":"","SP_LAST_NAME":"","SP_PHONE":"","SP_EMAIL":"","WWSPS_FLAG":"Y","ACCOUNT_STATUS":"","BUSINESS_UNIT":"","SP_RECERTIFICATION_DATE":"","CREATED_DATE":"","UPDATED_DATE":"","PROMOTION_ID_FLAG":"N","PRODUCT_CERTIFICATION_FLAG":"","CERTIFICATION_END_DATE":"","WARRANTY_TRAINING_STATUS":"","TERRITORY":"","SPCOUNTRY":"USA","WRNTY_TRAINING_CERTIFICATION":"Y","REGION":"","TERRITORY_CODE":"","REGION_CODE":"","STATE":"","PRIMARY_OEM_NAME":"","PRIMARY_OEM_CODE":"","PSBU_PRODUCT_CERTIFICATION":"","REPAIR_LEVEL":"","PROMOTION_ID":"","COST_EFFECTIVE_EXCLUSION":"","FREEZE_SUBMIT_BUTTON":"","DISABLE_WEB_ACCESS_FLAG":"","POLICY ":"","CAMPAIGN_TRP":"","OUTFILE_ALL_CLAIMS":"","PMU_SPLIT_PAYMENT":"","DSID":"","DTNA_FLAG":"","PACCAR":"","NEW_OEM":"","VIEW_DOLLAR_AMOUNT":"","TECH_ACTUAL_HOURS_REQUIRED":"","GROUP_NAME":"","CLAIM_ALLOWED_DAYS":"","CMI_SP_EXPIRATION_DATE":"","LTA_FLAG":"","WARRANTY_FAX":"","WARRANTY_EMAIL":"","COMMUNICATION_METHOD":"","COMMUNICATION_OCCURRENCE":"","MAX_CLAIM_AMT":"","CUT_OFF_CLAIM_AMT":"","SCM_DEDUCTIBLE_PERCENTAGE":"","SCM_DOLLAR_AMT":"","PHY_Address_1":"","PHY_Address_2":"","PHY_Address_3":"","PHY_Address_4":"","PHY_CITY":"","PHY_STATE":"","PHY_COUNTRY":"","PHY_ZIP_POSTAL_CODE":"","MAIL_Address_1":"","MAIL_Address_2":"","MAIL_Address_3":"","MAIL_Address_4":"","MAIL_CITY":"","MAIL_STATE":"","MAIL_COUNTRY":"","MAIL_ZIP_POSTAL_CODE":""},{"SP_CODE":"02005","SP_ROW_ID":"120000235","SP_NAME":"Cummins West","SP_CHANNEL_OF_DISTRIBUTION":"","SP_CHANNEL_CODE":"","RSS_RESP_BRANCH_CODE":"57324","RSS_RESP_BRANCH_NAME":"CUMMINS VENDAS E SERVI€OS DE MOTORES E GERADORES LTDA","RESP_BRANCH_CODE":"","RESP_BRANCH_NAME":"","SP_BILL_TO_CODE":"","SP_BILL_TO_NAME":"","DIST_HQ_CODE":"","DIST_HQ_NAME":"","SP_FIRST_NAME":"","SP_LAST_NAME":"","SP_PHONE":"","SP_EMAIL":"","WWSPS_FLAG":"Y","ACCOUNT_STATUS":"","BUSINESS_UNIT":"","SP_RECERTIFICATION_DATE":"","CREATED_DATE":"","UPDATED_DATE":"","PROMOTION_ID_FLAG":"N","PRODUCT_CERTIFICATION_FLAG":"","CERTIFICATION END DATE":"","WARRANTY_TRAINING_STATUS":"","TERRITORY":"","SPCOUNTRY":"USA","WRNTY_TRAINING_CERTIFICATION":"Y","REGION":"","TERRITORY_CODE":"","REGION_CODE":"","STATE":"","PRIMARY_OEM_NAME":"","PRIMARY_OEM_CODE":"","PSBU_PRODUCT_CERTIFICATION":"","REPAIR_LEVEL":"","PROMOTION_ID":"","COST_EFFECTIVE_EXCLUSION":"","FREEZE_SUBMIT_BUTTON":"","DISABLE_WEB_ACCESS_FLAG":"","POLICY ":"","CAMPAIGN_TRP":"","OUTFILE_ALL_CLAIMS":"","PMU_SPLIT_PAYMENT":"","DSID":"","DTNA_FLAG":"","PACCAR":"","NEW_OEM":"","VIEW_DOLLAR_AMOUNT":"","TECH_ACTUAL_HOURS_REQUIRED":"","GROUP_NAME":"","CLAIM_ALLOWED_DAYS":"","CMI_SP_EXPIRATION_DATE":"","LTA_FLAG":"","WARRANTY_FAX":"","WARRANTY_EMAIL":"","COMMUNICATION_METHOD":"","COMMUNICATION_OCCURRENCE":"","MAX_CLAIM_AMT":"","CUT_OFF_CLAIM_AMT":"","SCM_DEDUCTIBLE_PERCENTAGE":"","SCM_DOLLAR_AMT":"","PHY_Address_1":"","PHY_Address_2":"","PHY_Address_3":"","PHY_Address_4":"","PHY_CITY":"","PHY_STATE":"","PHY_COUNTRY":"","PHY_ZIP_POSTAL_CODE":"","MAIL_Address_1":"","MAIL_Address_2":"","MAIL_Address_3":"","MAIL_Address_4":"","MAIL_CITY":"","MAIL_STATE":"","MAIL_COUNTRY":"","MAIL_ZIP_POSTAL_CODE":""}],"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"}}';
            //spInfoResJSON = (CG_OP_GetSPInfoResJSON)JSON.deserializeStrict(hardcodedRes, CG_OP_GetSPInfoResJSON.class);
            spHeaderResJSON = (CG_WPR_SBL_SPHeader)JSON.deserializeStrict(resWrapper.response.getBody(), CG_WPR_SBL_SPHeader.class);
            system.debug('spHeaderResJSON>>>:'+spHeaderResJSON);
            Boolean successFlag = false;
            //Step3: insert GetTechInfo data
            if(spHeaderResJSON ==null) 
                successFlag = false;
            else
               successFlag = insertSPHeaderData(spHeaderResJSON);

            //Step4: updating lastProcessedDate on lstJobEventTemp record
            if(successFlag && jobEventTempRecord != null && jobEventTempRecord.Id != null){
                system.debug('stamping current processed date value -->');
                jobEventTempRecord.Attribute1__c = System.now().format('YYYY-MM-dd');
                update jobEventTempRecord;
            }
            system.debug('$$$$$ getSPHeaderData process completed successfully $$$$$$$');
        }catch(Exception ex){
            System.debug('in catch of getSPHeaderData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(ex.getStackTraceString(), 'CSS_FN_Siebel-getSPHeaderData', ex.getLineNumber()+'-'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_Siebel-getSPHeaderData', ex.getLineNumber()+'-'+ex.getMessage(), ex.getLineNumber()+'-'+ex.getMessage(), 'Siebel');
        }
    }


    public static Boolean insertSPHeaderData(CG_WPR_SBL_SPHeader spHeaderResJSON){
        Boolean successFlag = false;
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into insertSPHeaderData webservice of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<Account> accountList;
        set<String> hqCodes;
        set<string> setAllSMN = new set<string>();
        //map<string,id> mapSpCodeAccountId = new map<string,id>();
        try{
            if(spHeaderResJSON.DataArea.HeaderInfo ==null || spHeaderResJSON.DataArea.HeaderInfo.size()<=0)
                return true;

            hqCodes = new set<String>();
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
            Map<String,CG_WPR_SBL_SPHeader.HeaderInfo> mapSpCodesDataArea = new Map<String,CG_WPR_SBL_SPHeader.HeaderInfo>();
            for(CG_WPR_SBL_SPHeader.HeaderInfo da : spHeaderResJSON.DataArea.HeaderInfo){
                //building set of all spcode to fetch all accounts based on it 
                if(da.SpCode !=null && da.SpCode.trim() !=''){
                setSpCodes.add(String.valueOf(da.SpCode));
                mapSpCodesDataArea.put(String.valueOf(da.SpCode),da);
                }
                if(da.DistHqCode !=null && da.DistHqCode.trim() !='')
                    hqCodes.add('%'+da.DistHqCode);
            }

            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add('%'+s);
                }
            }

            List<Account> accountHQList = new List<Account>([select Id,IAM_Service_Provider_Code__c,Location__c,CSS_DistributorCode__c  from Account where IAM_Service_Provider_Code__c LIKE :hqCodes ]);
            Map<String, Id> hqAccountIds = new Map<String, Id>();
            Set<Id> accountIdSet = new Set<Id>();
            if(accountHQList !=null && accountHQList.size()>0){
                for(Account acc : accountHQList){
                    hqAccountIds.put(acc.IAM_Service_Provider_Code__c, acc.Id);
                    //hqAccountIds.put(acc.Location__c.right(5), acc.Id);
                }
            }

            //Below code is not needed
            /* //accountList = new List<Account>([select Id, Name, Location__c, DIST_HQ_CODE__c from Account where Location__c LIKE :setFormatedSpCodes ]); //need to query all fields ???
            System.debug('accountList>>>:'+accountList);
            if(accountList == null || accountList.size()<=0){
                System.debug('accountList size>>>:'+accountList.size());
                //return false;
            } */
            
            //New Code for Upsert
            accountList = new List<Account>();
            Account acc;
            for(CG_WPR_SBL_SPHeader.HeaderInfo daTemp : spHeaderResJSON.DataArea.HeaderInfo){
                if(daTemp.WwspsFlag=='Y'){
                    //daTemp = mapSpCodesDataArea.get(acc.Location__c.right(5));
                    acc = new Account();
                    //update Record Type as WWSPS
                    acc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
                    acc.Name = daTemp.SpName;
                    //acc.SPName__c = daTemp.SpName; //delete this field SPName__c
                    acc.IAM_Service_Provider_Code__c = daTemp.SpCode; //Last 5 didit Location Code
                    acc.CSS_DBCode__c = daTemp.RespBranchCode; //First 5 digit Location Code
                    acc.CSS_DistributorCode__c = daTemp.DistHqCode;
                    acc.SP_ROW_ID__c = daTemp.SpRowId;
                    //acc.RESP_BRANCH_CODE__c = daTemp.RespBranchCode; //delete this field RESP_BRANCH_CODE__c
                    acc.RSS_RESP_BRANCH_CODE__c = daTemp.RssRespBranchCode;
                    acc.DIST_HQ_CODE__c = daTemp.DistHqCode;
                    acc.CHANNEL_OF_DISTRIBUTION__c = daTemp.ChannelOfDistribution;
                    acc.CHANNEL_CODE__c = daTemp.ChannelCode;
                    acc.RSS_RESP_BRANCH_NAME__c = daTemp.RssRespBranchName;
                    acc.RESP_BRANCH_NAME__c = daTemp.RespBranchName;
                    acc.BILL_TO_CODE__c = daTemp.SpBillToCode;
                    acc.BILL_TO_NAME__c = daTemp.SpBillToName;
                    acc.DIST_HQ_NAME__c = daTemp.DistHqName;
                    acc.Primary_Contact_FIRST_NAME__c = daTemp.SpFirstName;
                    acc.Primary_Contact_LAST_NAME__c = daTemp.SpLastName;
                  //  acc.Primary_Contact_PHONE__c = daTemp.SpPhone; //commented by Roopa Gadipudi Dated 03.27.2020
                    acc.Primary_Contact_EMAIL__c = daTemp.SpEmail;
                    acc.WWSPS_FLAG__c = daTemp.WwspsFlag != null && daTemp.WwspsFlag.trim() != '' && daTemp.WwspsFlag.trim() == 'Y' ? true : false;
                    //acc.ACCOUNT_STATUS__c = daTemp.AccountStatus; //delete this field ACCOUNT_STATUS__c
                    acc.CMI_Account_Status__c = daTemp.AccountStatus;
                    acc.BUSINESS_UNIT__c = daTemp.BusinessUnit;
                    //added by venkat start
                    acc.Territory_Code__c = (daTemp.TerritoryCode != null && daTemp.TerritoryCode != '') ? Integer.valueOf(daTemp.TerritoryCode) : 0;
                    acc.Region_Code__c = daTemp.RegionCode;
                    acc.Primary_OEM_Name__c = daTemp.PrimaryOEMName;
                    acc.Primary_OEM_Code__c = daTemp.PrimaryOEMCode;
                    acc.PSBU_Product_Certification__c = daTemp.PsbuProductCertification != null && daTemp.PsbuProductCertification.trim() != '' && daTemp.PsbuProductCertification.trim() == 'Y' ? true : false; //daTemp.PsbuProductCertification;
                    acc.Repair_Level__c = daTemp.RepairLevel != null && daTemp.RepairLevel.trim() != '' && daTemp.RepairLevel.trim() == 'Y' ? true : false; //daTemp.RepairLevel;
                    acc.Cost_Effective_Exclusion__c = daTemp.CostEffectiveExclusion != null && daTemp.CostEffectiveExclusion.trim() != '' && daTemp.CostEffectiveExclusion.trim() == 'Y' ? true : false; 
                    acc.Freeze_Submit_Button__c = daTemp.FreezeSubmitButton != null && daTemp.FreezeSubmitButton.trim() != '' && daTemp.FreezeSubmitButton.trim() == 'Y' ? true : false; 
                    acc.Disable_Web_Access_Flag__c = daTemp.DisableWebAccessFlag != null && daTemp.DisableWebAccessFlag.trim() != '' && daTemp.DisableWebAccessFlag.trim() == 'Y' ? true : false; 
                    acc.Policy__c = daTemp.Policy != null && daTemp.Policy.trim() != '' && daTemp.Policy.trim() == 'Y' ? true : false; 
                    acc.Outfile_All_Claims__c = daTemp.OutfileAllClaims != null && daTemp.OutfileAllClaims.trim() != '' && daTemp.OutfileAllClaims.trim() == 'Y' ? true : false; 
                    acc.PMU_Split_Payment__c = daTemp.PmuSplitPayment != null && daTemp.PmuSplitPayment.trim() != '' && daTemp.PmuSplitPayment.trim() == 'Y' ? true : false; 
                    acc.DSID__c = daTemp.DsId != null && daTemp.DsId.trim() != '' && daTemp.DsId.trim() == 'Y' ? true : false; // we have 2 DSID Fields, pls check on this.
                    acc.DTNA__c = daTemp.DtnaFlag != null && daTemp.DtnaFlag.trim() != '' && daTemp.DtnaFlag.trim() == 'Y' ? true : false; 
                    acc.Paccar__c = daTemp.Paccar != null && daTemp.Paccar.trim() != '' && daTemp.Paccar.trim() == 'Y' ? true : false; 
                    acc.New_OEM__c = daTemp.NewOEM != null && daTemp.NewOEM.trim() != '' && daTemp.NewOEM.trim() == 'Y' ? true : false; 
                    acc.View_Dollar_Amount__c = daTemp.ViewDollarAmount != null && daTemp.ViewDollarAmount.trim() != '' && daTemp.ViewDollarAmount.trim() == 'Y' ? true : false; 
                    acc.Tech_Actual_Hours_Required__c = daTemp.TechActualHoursRequired != null && daTemp.TechActualHoursRequired.trim() != '' && daTemp.TechActualHoursRequired.trim() == 'Y' ? true : false; 
                    acc.Group_Name__c = daTemp.GroupName;
                    acc.Claim_Allowed_Days__c = (daTemp.ClaimAllowedDays != null && daTemp.ClaimAllowedDays != '') ? Integer.valueOf(daTemp.ClaimAllowedDays) : 0;
                    acc.CMI_SP_Expiration_Date__c = daTemp.CmiSpExpirationDat != null && daTemp.CmiSpExpirationDat.trim() != '' ? formatedDate(daTemp.CmiSpExpirationDat) : null; 
                    acc.LTA_Flag__c = daTemp.LtaFlag != null && daTemp.LtaFlag.trim() != ''  && daTemp.LtaFlag.trim() =='Y' ? true : false;
                    acc.Warranty_Fax__c = daTemp.WarrantyFax;
                    acc.Warranty_Email__c = daTemp.WarrantyEmail;
                    acc.Communication_Method__c = daTemp.CommunicationMethod;
                    acc.Communication_Occurrence__c = daTemp.CommunicationOccurrence;
                    acc.Max_Claim_Amt__c = daTemp.MaxClaimAmt != null && daTemp.MaxClaimAmt.trim() != '' ? decimal.valueof(daTemp.MaxClaimAmt): 0.0;
                    acc.Cut_Off_Claim_Amt__c = daTemp.CutOffClaimAmt != null && daTemp.CutOffClaimAmt.trim() != '' ? decimal.valueof(daTemp.CutOffClaimAmt): 0.0;
                    acc.SCM_Deductible__c = daTemp.ScmDeductible != null && daTemp.ScmDeductible.trim() != '' ? decimal.valueof(daTemp.ScmDeductible): 0.0;
                    acc.SCM_Dollar_Amt__c = daTemp.ScmDollarAmt != null && daTemp.ScmDollarAmt.trim() != '' ? decimal.valueof(daTemp.ScmDollarAmt): 0.0;
                    //added by venkat end

                    acc.Promotion_Id_Flag__c = daTemp.PromotionIdFlag != null && daTemp.PromotionIdFlag.trim() != ''  && daTemp.PromotionIdFlag.trim() =='Y' ? true : false;
                    acc.Product_Certification__c = daTemp.ProductCertificationFlag != null && daTemp.ProductCertificationFlag.trim() != ''  && daTemp.ProductCertificationFlag.trim()=='Y' ? true : false;
                    acc.Warranty_Training_Status__c = daTemp.WarrantyTrainingStatus;
                    acc.Warranty_Training_Certification__c = daTemp.WrntyTrainingCertification != null && daTemp.WrntyTrainingCertification.trim() != ''  && daTemp.WrntyTrainingCertification.trim()=='Y' ? true : false;
                    acc.Territory__c = daTemp.Territory;
                    acc.Region__c = daTemp.Region;
                    acc.isCampTrp__c = daTemp.CampaignTrp;
                    //acc.SPCOUNTRY__c = daTemp.PhyCountry; //delete this field SPCOUNTRY__c
                    
                    //Mapping Physical Address Fields
                   /* if(daTemp.PhyAddress1 != null && daTemp.PhyAddress1.trim() != '')
                        acc.BillingStreet = daTemp.PhyAddress1; */   //commented by Roopa Gadipudi Dated 03.27.2020
                  /*  if(daTemp.PhyAddress2 != null && daTemp.PhyAddress2.trim() != ''){
                        if(acc.BillingStreet != null && acc.BillingStreet.trim() != '')
                            acc.BillingStreet = acc.BillingStreet+','+daTemp.PhyAddress2;
                        else
                            acc.BillingStreet = daTemp.PhyAddress2;
                    } */         //commented by Roopa Gadipudi Dated 03.27.2020
                   /* if(daTemp.PhyAddress3 != null && daTemp.PhyAddress3.trim() != ''){
                        if(acc.BillingStreet != null && acc.BillingStreet.trim() != '')
                            acc.BillingStreet = acc.BillingStreet+','+daTemp.PhyAddress3;
                        else
                            acc.BillingStreet = daTemp.PhyAddress3;
                    } */   //commented by Roopa Gadipudi Dated 03.27.2020
                   /* if(daTemp.PhyAddress4 != null && daTemp.PhyAddress4.trim() != ''){
                        if(acc.BillingStreet != null && acc.BillingStreet.trim() != '')
                            acc.BillingStreet = acc.BillingStreet+','+daTemp.PhyAddress4;
                        else
                            acc.BillingStreet = daTemp.PhyAddress4;
                    } */  //commented by Roopa Gadipudi Dated 03.27.2020
                   // acc.BillingCity = daTemp.PhyCity; //commented by Roopa Gadipudi Dated 03.27.2020
                  //  acc.BillingStateCode = daTemp.PhyState; //State Code assigning //commented by Roopa Gadipudi Dated 03.27.2020
                    //acc.BillingState = daTemp.PhyState;
                    //acc.BillingCountry = daTemp.PhyCountry; //Mapped BillingCountryCode instead of it
                  /*  if(daTemp.PhyCountry !=null && (daTemp.PhyCountry=='USA' || daTemp.PhyCountry=='United States'))
                    acc.BillingCountryCode = 'US'; //Country Code
                    else
                    acc.BillingCountryCode = daTemp.PhyCountry; //Country Code */ //commented by Roopa Gadipudi Dated 03.27.2020
                   // acc.BillingPostalCode  = daTemp.PhyZipPostalCode; //commented by Roopa Gadipudi Dated 03.27.2020
                    
                    //Mapping Mailing Address Fields
                    if(daTemp.MailAddress1 != null && daTemp.MailAddress1.trim() != '')
                        acc.ShippingStreet = daTemp.MailAddress1;
                    if(daTemp.MailAddress2 != null && daTemp.MailAddress2.trim() != ''){
                        if(acc.ShippingStreet != null && acc.ShippingStreet.trim() != '')
                            acc.ShippingStreet = acc.ShippingStreet+','+daTemp.MailAddress2;
                        else
                            acc.ShippingStreet = daTemp.MailAddress2;
                    }
                    if(daTemp.MailAddress3 != null && daTemp.MailAddress3.trim() != ''){
                        if(acc.ShippingStreet != null && acc.ShippingStreet.trim() != '')
                            acc.ShippingStreet = acc.ShippingStreet+','+daTemp.MailAddress3;
                        else
                            acc.ShippingStreet = daTemp.MailAddress3;
                    }
                    if(daTemp.MailAddress4 != null && daTemp.MailAddress4.trim() != ''){
                        if(acc.ShippingStreet != null && acc.ShippingStreet.trim() != '')
                            acc.ShippingStreet = acc.ShippingStreet+','+daTemp.MailAddress4;
                        else
                            acc.ShippingStreet = daTemp.MailAddress4;
                    }
                    acc.ShippingCity = daTemp.MailCity;
                    acc.ShippingStateCode = daTemp.MailState; //State Code assigning
                    //acc.ShippingState = daTemp.MailState;
                    //acc.ShippingCountry = daTemp.MailCountry; //Mapped ShippingCountryCode instead of it
                    if(daTemp.MailCountry !=null && (daTemp.MailCountry == 'USA' || daTemp.MailCountry == 'United States'))
                        acc.ShippingCountryCode = 'US'; //Country Code
                    else
                    acc.ShippingCountryCode = daTemp.MailCountry; //Country Code
                    acc.ShippingPostalCode  = daTemp.MailZipPostalCode;
                    try{
                        acc.CERTIFICATION_END_DATE__c = daTemp.CertificationEndDate != null && daTemp.CertificationEndDate.trim() != '' ? formatedDate(daTemp.CertificationEndDate) : null;
                    }catch(Exception ex){
                        System.debug('in catch of CERTIFICATION_END_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                    }
                    try{
                        acc.RECERTIFICATION_DATE__c = daTemp.SpRecertificationDate != null && daTemp.SpRecertificationDate.trim() != '' ? formatedDate(daTemp.SpRecertificationDate) : null;
                    }catch(Exception ex){
                        System.debug('in catch of RECERTIFICATION_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                    }
                    try{
                        acc.WWSPS_Account_Created_Date__c = daTemp.SpCreatedDate != null && daTemp.SpCreatedDate.trim() != '' ? formatedDate(daTemp.SpCreatedDate) : null;
                    }catch(Exception ex){
                        System.debug('in catch of SpCreatedDate convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                    }
                    /* //not needed below 2 fields mapping
                    try{
                        acc.Primary_Contact_CREATED_DATE__c = daTemp.SpCreatedDate != null && daTemp.SpCreatedDate.trim() != '' ? formatedDate(daTemp.SpCreatedDate) : null;
                    }catch(Exception ex){
                        System.debug('in catch of CREATED_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                    }
                    try{ 
                        acc.Primary_Contact_UPDATED_DATE__c = daTemp.SpUpdatedDate != null && daTemp.SpUpdatedDate.trim() != '' ? formatedDate(daTemp.SpUpdatedDate) : null;
                    }catch(Exception ex){
                        System.debug('in catch of UPDATED_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                    }*/
                    
                    //if DistHqCode != IAM_Service_Provider_Code__c --> Parent.IAM_Service_Provider_Code__c = DistHqCode, else ignore 
                    if(daTemp.DistHqCode !=null && daTemp.DistHqCode.trim() !='' && daTemp.DistHqCode != daTemp.SpCode && hqAccountIds.containsKey(daTemp.DistHqCode)){
                        acc.ParentId = hqAccountIds.get(daTemp.DistHqCode); //assigning ParentId Account lookup based on DIST_HQ_CODE__c
                        //acc.Account__c = hqAccountIds.get(daTemp.DistHqCode);  //assigning Account lookup based on DIST_HQ_CODE__c
                    }
                    //mapSpCodeAccountId.put(acc.Location__c.right(5), acc.id);  //adding account Ids based SP_CODE
                    accountIdSet.add(acc.id);
                    
                    accountList.add(acc);
                }
            }
            System.debug('before upsert accountList.size()>>>:'+accountList.size());
            if(accountList !=null && accountList.size()>0){
                //List<Database.upsertResult> results = Database.upsert(accountList, Account.IAM_Service_Provider_Code__c,false); 
                upsert accountList IAM_Service_Provider_Code__c;  //upsert
            }
            successFlag = true;
            System.debug('after upsert accountList.size()>>>:'+accountList.size());
            System.debug('$$$$$$$$$$$ Process completed Successfully $$$$$$$$$$$$');
            System.debug('$$$$$$$$$$$ Returning Successfully $$$$$$$$$$$$');
            System.debug('$$$$$$$$$$$ Returning Successfully $$$$$$$$$$$$');

        }catch(Exception ex){
            System.debug('in catch of insertSPHeaderData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(ex.getStackTraceString(), 'CSS_FN_Siebel-insertSPHeaderData', ex.getLineNumber()+'-'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_Siebel-insertSPHeaderData', ex.getLineNumber()+'-'+ex.getMessage(), ex.getLineNumber()+'-'+ex.getMessage(), 'Siebel');
        }
        return successFlag;
    }

    /* Code to get SPInfo Certification Data from siebel System */
    public static void getSPCertificationData(){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getSPCertificationData method of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CG_WPR_SBL_SPCertification spCertificationResJSON;
        CG_OP_OAGWrapper resWrapper;
        String lastProcessedDate;
        try{
            //Step1: retrieve request values from JobEventTemporary record
            CSS_JobEventTemporary__c jobEventTempRecord = getJobEventRecord('GetSPCertification');
            if(jobEventTempRecord != null && jobEventTempRecord.Id !=null){
                lastProcessedDate = jobEventTempRecord.Attribute1__c;
            }else
                lastProcessedDate = System.now().format('YYYY-MM-dd');
            //lastProcessedDate = '2018-07-24'; //To Get Test Data
            System.debug('lastProcessedDate>>>>:'+lastProcessedDate);

            //Step2: Prepare Request JSON & execute GetSPInfo service
            resWrapper = CG_SL_SIEBEL.callGetInfoService(lastProcessedDate, 'GetSPCertification');
            if(resWrapper == null){
                System.debug('########## Returning from here after execution fails ###############'); 
            }
            System.debug('resWrapper>>>:'+resWrapper+' #####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());
            //String hardcodedRes = '{"DataArea":[{"SP_CODE":"02004","SP_ROW_ID":"120000234","SP_NAME":"Cummins Central","SP_CHANNEL_OF_DISTRIBUTION":"","SP_CHANNEL_CODE":"","RSS_RESP_BRANCH_CODE":"57324","RSS_RESP_BRANCH_NAME":"CUMMINS VENDAS E SERVI€OS DE MOTORES EGERADORES LTDA","RESP_BRANCH_CODE":"","RESP_BRANCH_NAME":"","SP_BILL_TO_CODE":"","SP_BILL_TO_NAME":"","DIST_HQ_CODE":"","DIST_HQ_NAME":"","SP_FIRST_NAME":"","SP_LAST_NAME":"","SP_PHONE":"","SP_EMAIL":"","WWSPS_FLAG":"Y","ACCOUNT_STATUS":"","BUSINESS_UNIT":"","SP_RECERTIFICATION_DATE":"","CREATED_DATE":"","UPDATED_DATE":"","PROMOTION_ID_FLAG":"N","PRODUCT_CERTIFICATION_FLAG":"","CERTIFICATION_END_DATE":"","WARRANTY_TRAINING_STATUS":"","TERRITORY":"","SPCOUNTRY":"USA","WRNTY_TRAINING_CERTIFICATION":"Y","REGION":"","TERRITORY_CODE":"","REGION_CODE":"","STATE":"","PRIMARY_OEM_NAME":"","PRIMARY_OEM_CODE":"","PSBU_PRODUCT_CERTIFICATION":"","REPAIR_LEVEL":"","PROMOTION_ID":"","COST_EFFECTIVE_EXCLUSION":"","FREEZE_SUBMIT_BUTTON":"","DISABLE_WEB_ACCESS_FLAG":"","POLICY ":"","CAMPAIGN_TRP":"","OUTFILE_ALL_CLAIMS":"","PMU_SPLIT_PAYMENT":"","DSID":"","DTNA_FLAG":"","PACCAR":"","NEW_OEM":"","VIEW_DOLLAR_AMOUNT":"","TECH_ACTUAL_HOURS_REQUIRED":"","GROUP_NAME":"","CLAIM_ALLOWED_DAYS":"","CMI_SP_EXPIRATION_DATE":"","LTA_FLAG":"","WARRANTY_FAX":"","WARRANTY_EMAIL":"","COMMUNICATION_METHOD":"","COMMUNICATION_OCCURRENCE":"","MAX_CLAIM_AMT":"","CUT_OFF_CLAIM_AMT":"","SCM_DEDUCTIBLE_PERCENTAGE":"","SCM_DOLLAR_AMT":"","PHY_Address_1":"","PHY_Address_2":"","PHY_Address_3":"","PHY_Address_4":"","PHY_CITY":"","PHY_STATE":"","PHY_COUNTRY":"","PHY_ZIP_POSTAL_CODE":"","MAIL_Address_1":"","MAIL_Address_2":"","MAIL_Address_3":"","MAIL_Address_4":"","MAIL_CITY":"","MAIL_STATE":"","MAIL_COUNTRY":"","MAIL_ZIP_POSTAL_CODE":""},{"SP_CODE":"02005","SP_ROW_ID":"120000235","SP_NAME":"Cummins West","SP_CHANNEL_OF_DISTRIBUTION":"","SP_CHANNEL_CODE":"","RSS_RESP_BRANCH_CODE":"57324","RSS_RESP_BRANCH_NAME":"CUMMINS VENDAS E SERVI€OS DE MOTORES E GERADORES LTDA","RESP_BRANCH_CODE":"","RESP_BRANCH_NAME":"","SP_BILL_TO_CODE":"","SP_BILL_TO_NAME":"","DIST_HQ_CODE":"","DIST_HQ_NAME":"","SP_FIRST_NAME":"","SP_LAST_NAME":"","SP_PHONE":"","SP_EMAIL":"","WWSPS_FLAG":"Y","ACCOUNT_STATUS":"","BUSINESS_UNIT":"","SP_RECERTIFICATION_DATE":"","CREATED_DATE":"","UPDATED_DATE":"","PROMOTION_ID_FLAG":"N","PRODUCT_CERTIFICATION_FLAG":"","CERTIFICATION END DATE":"","WARRANTY_TRAINING_STATUS":"","TERRITORY":"","SPCOUNTRY":"USA","WRNTY_TRAINING_CERTIFICATION":"Y","REGION":"","TERRITORY_CODE":"","REGION_CODE":"","STATE":"","PRIMARY_OEM_NAME":"","PRIMARY_OEM_CODE":"","PSBU_PRODUCT_CERTIFICATION":"","REPAIR_LEVEL":"","PROMOTION_ID":"","COST_EFFECTIVE_EXCLUSION":"","FREEZE_SUBMIT_BUTTON":"","DISABLE_WEB_ACCESS_FLAG":"","POLICY ":"","CAMPAIGN_TRP":"","OUTFILE_ALL_CLAIMS":"","PMU_SPLIT_PAYMENT":"","DSID":"","DTNA_FLAG":"","PACCAR":"","NEW_OEM":"","VIEW_DOLLAR_AMOUNT":"","TECH_ACTUAL_HOURS_REQUIRED":"","GROUP_NAME":"","CLAIM_ALLOWED_DAYS":"","CMI_SP_EXPIRATION_DATE":"","LTA_FLAG":"","WARRANTY_FAX":"","WARRANTY_EMAIL":"","COMMUNICATION_METHOD":"","COMMUNICATION_OCCURRENCE":"","MAX_CLAIM_AMT":"","CUT_OFF_CLAIM_AMT":"","SCM_DEDUCTIBLE_PERCENTAGE":"","SCM_DOLLAR_AMT":"","PHY_Address_1":"","PHY_Address_2":"","PHY_Address_3":"","PHY_Address_4":"","PHY_CITY":"","PHY_STATE":"","PHY_COUNTRY":"","PHY_ZIP_POSTAL_CODE":"","MAIL_Address_1":"","MAIL_Address_2":"","MAIL_Address_3":"","MAIL_Address_4":"","MAIL_CITY":"","MAIL_STATE":"","MAIL_COUNTRY":"","MAIL_ZIP_POSTAL_CODE":""}],"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"}}';
            //spInfoResJSON = (CG_OP_GetSPInfoResJSON)JSON.deserializeStrict(hardcodedRes, CG_OP_GetSPInfoResJSON.class);
            spCertificationResJSON = (CG_WPR_SBL_SPCertification)JSON.deserializeStrict(resWrapper.response.getBody(), CG_WPR_SBL_SPCertification.class);
            system.debug('spCertificationResJSON>>>:'+spCertificationResJSON);
            Boolean successFlag = false;
            //Step3: insert GetTechInfo data
            if(spCertificationResJSON ==null) 
                successFlag = false;
            else
                successFlag = insertSPCertificationData(spCertificationResJSON);

            //Step4: updating lastProcessedDate on lstJobEventTemp record
            if(successFlag && jobEventTempRecord != null && jobEventTempRecord.Id != null){
                system.debug('stamping current processed date value -->');
                jobEventTempRecord.Attribute1__c = System.now().format('YYYY-MM-dd');
                update jobEventTempRecord;
            }
            system.debug('$$$$$ getSPCertificationData process completed successfully $$$$$$$');
        }catch(Exception ex){
            System.debug('in catch of getSPCertificationData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(ex.getStackTraceString(), 'CSS_FN_Siebel-getSPCertificationData', ex.getLineNumber()+'-'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_Siebel-getSPCertificationData', ex.getLineNumber()+'-'+ex.getMessage(), ex.getLineNumber()+'-'+ex.getMessage(), 'Siebel');
        }
    }
    public static Boolean insertSPCertificationData(CG_WPR_SBL_SPCertification spCertificationResJSON){
        Boolean successFlag = false;
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into insertSPCertificationData webservice of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        List<Account> accountList;
        map<string,id> mapSpCodeAccountId = new map<string,id>();
        try{
            if(spCertificationResJSON.DataArea.CertificationInfo ==null || spCertificationResJSON.DataArea.CertificationInfo.size()<=0)
                return true;
            
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
            //Get Account Ids to have master detail relation ship account to Accreditation__c
            for(CG_WPR_SBL_SPCertification.CertificationInfo da : spCertificationResJSON.DataArea.CertificationInfo)
                setSpCodes.add(String.valueOf(da.SpCode)); //building set of all spcode to fetch all accounts based on it 
            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add('%'+s);
                }
            }
            accountList = new List<Account>([select Id, Name, Location__c, DIST_HQ_CODE__c, SP_ROW_ID__c from Account where Location__c LIKE :setFormatedSpCodes ]); //need to query all fields ???
            System.debug('accountList>>>:'+accountList);

           if(accountList != null && accountList.size()>0){
            for(Account acc:accountList)
                mapSpCodeAccountId.put(acc.Location__c.right(5), acc.id);
                //mapSpCodeAccountId.put(acc.SP_ROW_ID__c, acc.id); //SP_ROW_ID__c should be in Map
           }

            List<CSS_Accreditation__c> accredLstToInsert = new List<CSS_Accreditation__c>();
            CSS_Accreditation__c accred;
            for(CG_WPR_SBL_SPCertification.CertificationInfo da : spCertificationResJSON.DataArea.CertificationInfo){
                accred = new CSS_Accreditation__c();
                accred.SpCode__c = da.SpCode;
                accred.SpRowId__c = da.SpRowId;
                accred.isSMNAccountLevel__c = true; //why this is true always?
                accred.Service_Model_Name__c = da.Smn;
                accred.OEM_Name__c = da.OemName;
                accred.OEM_Code__c = da.OemCode;
                accred.SERVICE_LEVEL__c = da.ServiceLevel;
                if(da.SpCode != null && da.SpCode.trim() != '' && mapSpCodeAccountId.containskey(da.SpCode))
                    accred.Account__c = mapSpCodeAccountId.get(da.SpCode); // Kalpana: Should we do this? or mapping Account__c to da.Sprowid will do? Ans: Current statement is correct
                accred.CERT_ROW_ID__c = da.SpCertRowId;
                try{
                    accred.StartDate__c = da.StartDate != null && da.StartDate.trim() != '' ? formatedDate(da.StartDate) : null;
                }catch(Exception ex){
                    System.debug('in catch of spcert.START_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
                try{
                    accred.EndDate__c = da.EndDate != null && da.EndDate.trim() != '' ? formatedDate(da.EndDate) : null;
                }catch(Exception ex){
                    System.debug('in catch of spcert.END_DATE convertion of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
                }
                accredLstToInsert.add(accred);
            }
            if(accredLstToInsert != null && accredLstToInsert.size()>0)
                upsert accredLstToInsert CERT_ROW_ID__c;
                successFlag = true;
        }catch(Exception ex){
            System.debug('in catch of updateAccreditationData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        IAM_ErrorHandling.IAMerrorCapture(ex.getStackTraceString(), 'CSS_FN_Siebel-updateAccreditationData', ex.getLineNumber()+'-'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_Siebel-updateAccreditationData', ex.getLineNumber()+'-'+ex.getMessage(), ex.getLineNumber()+'-'+ex.getMessage(), 'Siebel');
        }
         return successFlag;
    }
    public static void getSPAffiliationData(){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getSPAffiliationData method of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CG_WPR_SBL_SPAffiliations spAffiliationResJSON;
        CG_OP_OAGWrapper resWrapper;
        String lastProcessedDate;
        try{
            //Step1: retrieve request values from JobEventTemporary record
            CSS_JobEventTemporary__c jobEventTempRecord = getJobEventRecord('GetSPAffiliation');
            if(jobEventTempRecord != null && jobEventTempRecord.Id !=null){
                lastProcessedDate = jobEventTempRecord.Attribute1__c;
            }else
                lastProcessedDate = System.now().format('YYYY-MM-dd');
            //lastProcessedDate = '2018-07-24'; //To Get Test Data
            System.debug('lastProcessedDate>>>>:'+lastProcessedDate);

            //Step2: Prepare Request JSON & execute GetSPInfo service
            resWrapper = CG_SL_SIEBEL.callGetInfoService(lastProcessedDate, 'GetSPAffiliation');
            if(resWrapper == null){
                System.debug('########## Returning from here after execution fails ###############'); 
            }
            System.debug('resWrapper>>>:'+resWrapper+' #####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());
            //String hardcodedRes = '{"DataArea":[{"SP_CODE":"02004","SP_ROW_ID":"120000234","SP_NAME":"Cummins Central","SP_CHANNEL_OF_DISTRIBUTION":"","SP_CHANNEL_CODE":"","RSS_RESP_BRANCH_CODE":"57324","RSS_RESP_BRANCH_NAME":"CUMMINS VENDAS E SERVI€OS DE MOTORES EGERADORES LTDA","RESP_BRANCH_CODE":"","RESP_BRANCH_NAME":"","SP_BILL_TO_CODE":"","SP_BILL_TO_NAME":"","DIST_HQ_CODE":"","DIST_HQ_NAME":"","SP_FIRST_NAME":"","SP_LAST_NAME":"","SP_PHONE":"","SP_EMAIL":"","WWSPS_FLAG":"Y","ACCOUNT_STATUS":"","BUSINESS_UNIT":"","SP_RECERTIFICATION_DATE":"","CREATED_DATE":"","UPDATED_DATE":"","PROMOTION_ID_FLAG":"N","PRODUCT_CERTIFICATION_FLAG":"","CERTIFICATION_END_DATE":"","WARRANTY_TRAINING_STATUS":"","TERRITORY":"","SPCOUNTRY":"USA","WRNTY_TRAINING_CERTIFICATION":"Y","REGION":"","TERRITORY_CODE":"","REGION_CODE":"","STATE":"","PRIMARY_OEM_NAME":"","PRIMARY_OEM_CODE":"","PSBU_PRODUCT_CERTIFICATION":"","REPAIR_LEVEL":"","PROMOTION_ID":"","COST_EFFECTIVE_EXCLUSION":"","FREEZE_SUBMIT_BUTTON":"","DISABLE_WEB_ACCESS_FLAG":"","POLICY ":"","CAMPAIGN_TRP":"","OUTFILE_ALL_CLAIMS":"","PMU_SPLIT_PAYMENT":"","DSID":"","DTNA_FLAG":"","PACCAR":"","NEW_OEM":"","VIEW_DOLLAR_AMOUNT":"","TECH_ACTUAL_HOURS_REQUIRED":"","GROUP_NAME":"","CLAIM_ALLOWED_DAYS":"","CMI_SP_EXPIRATION_DATE":"","LTA_FLAG":"","WARRANTY_FAX":"","WARRANTY_EMAIL":"","COMMUNICATION_METHOD":"","COMMUNICATION_OCCURRENCE":"","MAX_CLAIM_AMT":"","CUT_OFF_CLAIM_AMT":"","SCM_DEDUCTIBLE_PERCENTAGE":"","SCM_DOLLAR_AMT":"","PHY_Address_1":"","PHY_Address_2":"","PHY_Address_3":"","PHY_Address_4":"","PHY_CITY":"","PHY_STATE":"","PHY_COUNTRY":"","PHY_ZIP_POSTAL_CODE":"","MAIL_Address_1":"","MAIL_Address_2":"","MAIL_Address_3":"","MAIL_Address_4":"","MAIL_CITY":"","MAIL_STATE":"","MAIL_COUNTRY":"","MAIL_ZIP_POSTAL_CODE":""},{"SP_CODE":"02005","SP_ROW_ID":"120000235","SP_NAME":"Cummins West","SP_CHANNEL_OF_DISTRIBUTION":"","SP_CHANNEL_CODE":"","RSS_RESP_BRANCH_CODE":"57324","RSS_RESP_BRANCH_NAME":"CUMMINS VENDAS E SERVI€OS DE MOTORES E GERADORES LTDA","RESP_BRANCH_CODE":"","RESP_BRANCH_NAME":"","SP_BILL_TO_CODE":"","SP_BILL_TO_NAME":"","DIST_HQ_CODE":"","DIST_HQ_NAME":"","SP_FIRST_NAME":"","SP_LAST_NAME":"","SP_PHONE":"","SP_EMAIL":"","WWSPS_FLAG":"Y","ACCOUNT_STATUS":"","BUSINESS_UNIT":"","SP_RECERTIFICATION_DATE":"","CREATED_DATE":"","UPDATED_DATE":"","PROMOTION_ID_FLAG":"N","PRODUCT_CERTIFICATION_FLAG":"","CERTIFICATION END DATE":"","WARRANTY_TRAINING_STATUS":"","TERRITORY":"","SPCOUNTRY":"USA","WRNTY_TRAINING_CERTIFICATION":"Y","REGION":"","TERRITORY_CODE":"","REGION_CODE":"","STATE":"","PRIMARY_OEM_NAME":"","PRIMARY_OEM_CODE":"","PSBU_PRODUCT_CERTIFICATION":"","REPAIR_LEVEL":"","PROMOTION_ID":"","COST_EFFECTIVE_EXCLUSION":"","FREEZE_SUBMIT_BUTTON":"","DISABLE_WEB_ACCESS_FLAG":"","POLICY ":"","CAMPAIGN_TRP":"","OUTFILE_ALL_CLAIMS":"","PMU_SPLIT_PAYMENT":"","DSID":"","DTNA_FLAG":"","PACCAR":"","NEW_OEM":"","VIEW_DOLLAR_AMOUNT":"","TECH_ACTUAL_HOURS_REQUIRED":"","GROUP_NAME":"","CLAIM_ALLOWED_DAYS":"","CMI_SP_EXPIRATION_DATE":"","LTA_FLAG":"","WARRANTY_FAX":"","WARRANTY_EMAIL":"","COMMUNICATION_METHOD":"","COMMUNICATION_OCCURRENCE":"","MAX_CLAIM_AMT":"","CUT_OFF_CLAIM_AMT":"","SCM_DEDUCTIBLE_PERCENTAGE":"","SCM_DOLLAR_AMT":"","PHY_Address_1":"","PHY_Address_2":"","PHY_Address_3":"","PHY_Address_4":"","PHY_CITY":"","PHY_STATE":"","PHY_COUNTRY":"","PHY_ZIP_POSTAL_CODE":"","MAIL_Address_1":"","MAIL_Address_2":"","MAIL_Address_3":"","MAIL_Address_4":"","MAIL_CITY":"","MAIL_STATE":"","MAIL_COUNTRY":"","MAIL_ZIP_POSTAL_CODE":""}],"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"}}';
            //spInfoResJSON = (CG_OP_GetSPInfoResJSON)JSON.deserializeStrict(hardcodedRes, CG_OP_GetSPInfoResJSON.class);
            spAffiliationResJSON = (CG_WPR_SBL_SPAffiliations)JSON.deserializeStrict(resWrapper.response.getBody(), CG_WPR_SBL_SPAffiliations.class);
            system.debug('spAffiliationResJSON>>>:'+spAffiliationResJSON);
            Boolean successFlag = false;
            //Step3: insert GetTechInfo data
            if(spAffiliationResJSON ==null) 
                successFlag = false;
            else
                successFlag = insertSPAffiliationData(spAffiliationResJSON);

            //Step4: updating lastProcessedDate on lstJobEventTemp record
            if(successFlag && jobEventTempRecord != null && jobEventTempRecord.Id != null){
                system.debug('stamping current processed date value -->');
                jobEventTempRecord.Attribute1__c = System.now().format('YYYY-MM-dd');
                update jobEventTempRecord;
            }
            system.debug('$$$$$ getSPAffiliationData process completed successfully $$$$$$$');
        }catch(Exception ex){
            System.debug('in catch of getSPAffiliationData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(ex.getStackTraceString(), 'CSS_FN_Siebel-getSPAffiliationData', ex.getLineNumber()+'-'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_Siebel-getSPAffiliationData', ex.getLineNumber()+'-'+ex.getMessage(), ex.getLineNumber()+'-'+ex.getMessage(), 'Siebel');
        }
    }
    public static Boolean insertSPAffiliationData(CG_WPR_SBL_SPAffiliations spAffiliationResJSON){
        Boolean successFlag = false;
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into insertSPAffiliationData webservice of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        //list to store all accounts matching the creiteria with spcode
        list<Account> lstAccount = new list<Account>();
        //set to store al account ids queried based on spcode 
        set<Id> setAccountIds = new set<Id>();
        try{
            if(spAffiliationResJSON.DataArea.AffiliationInfo ==null || spAffiliationResJSON.DataArea.AffiliationInfo.size()<=0) 
                return true;
            
            //Prepare Account look up map
            map<string,id> mapSpCodeAccountId = new map<string,id>();
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
            for(CG_WPR_SBL_SPAffiliations.AffiliationInfo da :spAffiliationResJSON.DataArea.AffiliationInfo){
                setSpCodes.add(String.valueOf(da.SpCode)); //building set of all spcode to fetch all accounts based on it 
            }
            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add('%'+s);
                }
            }
            List<Account> accountList = new List<Account>([select Id, Name, Location__c, DIST_HQ_CODE__c, SP_ROW_ID__c from Account where Location__c LIKE :setFormatedSpCodes ]); //need to query all fields ???
            System.debug('accountList>>>:'+accountList);
            if(accountList != null && accountList.size()>0){
                for(Account acc:accountList)
                    mapSpCodeAccountId.put(acc.Location__c.right(5), acc.id);
                    //mapSpCodeAccountId.put(acc.SP_ROW_ID__c, acc.id); //SP_ROW_ID__c should be in Map
            }

            List<CSS_OEM_AFFILIATIONS__c> oemLstToInsert = new List<CSS_OEM_AFFILIATIONS__c>();
            for(CG_WPR_SBL_SPAffiliations.AffiliationInfo daTemp :spAffiliationResJSON.DataArea.AffiliationInfo){
                setSpCodes.add(string.valueOf(daTemp.SpCode));
                if(daTemp.Affiliation != null) {
                    CSS_OEM_AFFILIATIONS__c oemRec = new CSS_OEM_AFFILIATIONS__c();
                    oemRec.LAST_UPDATED_DATE__c= daTemp.LastUpdatedDate;
                    oemRec.LAST_UPDATED_BY__c= daTemp.LastUpdatedBy;
                    //oemRec.SP_NAME__c= daTemp.SP_NAME;
                    oemRec.AFFILIATION__c= daTemp.Affiliation;
                    oemRec.PRIMARY__c= daTemp.Primary;
                    oemRec.SP_CODE__c= daTemp.SpCode;
                    oemRec.SpRowId__c = daTemp.SpRowId;
                    oemRec.Name= daTemp.Affiliation; 
                    oemRec.AFFILIATION_ROW_ID__c = daTemp.AffiliationRowId; //unique id or External ID for the object.
                    if(daTemp.SpCode != null && daTemp.SpCode.trim() != '' && mapSpCodeAccountId.containskey(daTemp.SpCode))
                        oemRec.Account__c = mapSpCodeAccountId.get(daTemp.SpCode); //Map Account Id as lookup Id
                    oemLstToInsert.add(oemRec);
                }
            }
            //preparing set for the query to use like operator 
            if(setSpCodes != null && setSpCodes.size() > 0){
                for(string s : setSpCodes){
                    setFormatedSpCodes.add('%'+s);  
                }
            }
            if(setFormatedSpCodes != null && setFormatedSpCodes.size() > 0){
                //query all accounts matching spcodes with the last five digit of the location code 
                lstAccount = [SELECT Id,Product_Certification__c,WR_WWSPS_Cert_Date__c,Territory__c,Warranty_Training_Certification__c,
                              Region__c,WWSPS_Profile_Status__c,Promotion_Id_Flag__c,Location__c
                              FROM Account
                              WHERE  Location__c 
                              LIKE : setFormatedSpCodes ];
            }
            System.debug('lstAccount size>>>>>>>:'+lstAccount.size()+' setFormatedSpCodes>>>:'+setFormatedSpCodes);
            if(lstAccount == null || lstAccount.size() <= 0){
                System.debug('$$$$$$$$$$$$$ No Accounts found to update & returning from here $$$$$$$$$$$$$$$$$$');
                return false;
            }
            for(Account acc:lstAccount){
                setAccountIds.add(acc.id);
            }
            List<CSS_OEM_AFFILIATIONS__c> oemLstToDel = [SELECT Id FROM CSS_OEM_AFFILIATIONS__c WHERE Account__c=:setAccountIds]; 
            // update accountList;
            /*if(oemLstToDel != null && oemLstToDel.size() > 0)
                delete oemLstToDel; */ //Not needed this since doing upsert & get incremental data
            if(oemLstToInsert != null && oemLstToInsert.size() > 0){
                upsert oemLstToInsert AFFILIATION_ROW_ID__c ; // if this works, then we dont need the code to delete existing list(oemLstToDel).
            }
            successFlag = true;

        }catch(Exception ex){
            System.debug('in catch of insertSPAffiliationData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
IAM_ErrorHandling.IAMerrorCapture(ex.getStackTraceString(), 'CSS_FN_Siebel-insertSPAffiliationData', ex.getLineNumber()+'-'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_Siebel-insertSPAffiliationData', ex.getLineNumber()+'-'+ex.getMessage(), ex.getLineNumber()+'-'+ex.getMessage(), 'Siebel');
        }
        return successFlag;
    }
    // ########## New SPTechInfo Services Code End ###########

    /*Start: Code for TechnicianInfo  callout*/
    public static void GetSPTechnicianData(){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into GetSPTechnicianData method of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CG_WPR_SBL_SPTechnicianInfo spHeaderResJSON;
        CG_OP_OAGWrapper resWrapper;
        String lastProcessedDate;
        try{
            //Step1: retrieve request values from JobEventTemporary record
            CSS_JobEventTemporary__c jobEventTempRecord = getJobEventRecord('GetSPTechInfo');
            if(jobEventTempRecord != null && jobEventTempRecord.Id !=null){
                lastProcessedDate = jobEventTempRecord.Attribute1__c;
            }else
                lastProcessedDate = System.now().format('YYYY-MM-dd');

            System.debug('lastProcessedDate>>>>:'+lastProcessedDate);

            //Step2: Prepare Request JSON & execute GetSPInfo service
            resWrapper = CG_SL_SIEBEL.callGetInfoService(lastProcessedDate, 'GetSPTechInfo');

            if(resWrapper == null){
                System.debug('########## Returning from here after execution fails ###############'); 
            }
            System.debug('resWrapper>>>:'+resWrapper+' #####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());

            spHeaderResJSON = (CG_WPR_SBL_SPTechnicianInfo)JSON.deserializeStrict(resWrapper.response.getBody(), CG_WPR_SBL_SPTechnicianInfo.class);
            system.debug('spHeaderResJSON>>>:'+spHeaderResJSON);
            Boolean successFlag = false;
            //Step3: insert GetTechInfo data
            if(spHeaderResJSON ==null) 
                successFlag = false;
            else
                successFlag = insertSPTechnicianData(spHeaderResJSON);

            //Step4: updating lastProcessedDate on lstJobEventTemp record
            if(successFlag && jobEventTempRecord != null && jobEventTempRecord.Id != null){
                system.debug('stamping current processed date value -->');
                jobEventTempRecord.Attribute1__c = System.now().format('YYYY-MM-dd');
                update jobEventTempRecord;
            }
            system.debug('$$$$$ GetSPTechnician process completed successfully $$$$$$$');
        }catch(Exception ex){
            System.debug('in catch of GetSPTechnician of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(ex.getStackTraceString(), 'CSS_FN_Siebel-GetSPTechnician', ex.getLineNumber()+'-'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_Siebel-GetSPTechnician', ex.getLineNumber()+'-'+ex.getMessage(), ex.getLineNumber()+'-'+ex.getMessage(), 'Siebel');
        }
    }

    public static Boolean insertSPTechnicianData(CG_WPR_SBL_SPTechnicianInfo SPTechnicianInfoRes){
        Boolean successFlag = false;
        set<string> settechrowid= new set<string>(); //Used to query the Accred User
        list<CSS_AccredUser__c> lstAccredUser= new list<CSS_AccredUser__c>(); //Holds the record of accred User
        map<string,CSS_AccredUser__c> mapaccrduserwithtechrow= new map<string,CSS_AccredUser__c>(); //Map of Tech_RowId with Accred User
        try{
            if(SPTechnicianInfoRes.DataArea.TechnicianInfo ==null || SPTechnicianInfoRes.DataArea.TechnicianInfo.size()<=0) 
                return true;
            
            //Prepare Account look up map
            map<string,id> mapSpCodeAccountId = new map<string,id>();
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
            for(CG_WPR_SBL_SPTechnicianInfo.TechnicianInfo da:SPTechnicianInfoRes.dataarea.TechnicianInfo){
                if(!string.isblank(da.TechRowId))
                    settechrowid.add(da.TechRowId);
                setSpCodes.add(String.valueOf(da.SpCode)); //building set of all spcode to fetch all accounts based on it 
            }
            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add('%'+s);
                }
            }
            List<Account> accountList = new List<Account>([select Id, Name, Location__c, DIST_HQ_CODE__c, SP_ROW_ID__c from Account where Location__c LIKE :setFormatedSpCodes ]); //need to query all fields ???
            System.debug('accountList>>>:'+accountList);
            if(accountList != null && accountList.size()>0){
                for(Account acc:accountList)
                    mapSpCodeAccountId.put(acc.Location__c.right(5), acc.id);
                    //mapSpCodeAccountId.put(acc.SP_ROW_ID__c, acc.id); //SP_ROW_ID__c should be in Map
            }
            lstAccredUser=[SELECT id,First_Name__c,Last_Name__c,Promotion_Id__c,Accreditation__c,
                           User_Login_ID__c,Passed_Date_SBL__c,ServiceModelName__c,TECH_ROW_ID__c,SMN_ROW_ID__c,CERT_PERCENTAGE__c
                           FROM CSS_AccredUser__c
                           WHERE TECH_ROW_ID__c IN : settechrowid ];
            if(lstAccredUser.size()>0){
                for(CSS_AccredUser__c acrdusr:lstAccredUser){
                    for(CG_WPR_SBL_SPTechnicianInfo.TechnicianInfo da:SPTechnicianInfoRes.dataarea.TechnicianInfo){
                        if(acrdusr.TECH_ROW_ID__c == da.TechRowId){
                            acrdusr.First_Name__c = da.FstName;
                            acrdusr.Last_Name__c = da.LastName;
                            acrdusr.Promotion_Id__c = da.PromotionId;
                            if(da.Sprowid != null && da.Sprowid.trim() != '' && mapSpCodeAccountId.containskey(da.Sprowid))
                                acrdusr.account__c = mapSpCodeAccountId.get(da.SpCode); //Map Account Id as lookup Id 
                        }
                    }
                }
                update lstAccredUser;
                successFlag = true;
            }
        }catch(Exception ex){
            System.debug('in catch of insertSPTechnicianData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        IAM_ErrorHandling.IAMerrorCapture(ex.getStackTraceString(), 'CSS_FN_Siebel-insertSPTechnicianData', ex.getLineNumber()+'-'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_Siebel-insertSPTechnicianData', ex.getLineNumber()+'-'+ex.getMessage(), ex.getLineNumber()+'-'+ex.getMessage(), 'Siebel');
        }
        return successFlag;
    }


    public static void GetSPTechnicianSMNData(){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into GetSPTechnicianSMNData method of CSS_FN_SIEBEL $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CG_WPR_SBL_SPTechnicianSMN spHeaderResJSON;
        CG_OP_OAGWrapper resWrapper;
        String lastProcessedDate;
        try{
            //Step1: retrieve request values from JobEventTemporary record
            CSS_JobEventTemporary__c jobEventTempRecord = getJobEventRecord('GetSPTechSMN');
            if(jobEventTempRecord != null && jobEventTempRecord.Id !=null){
                lastProcessedDate = jobEventTempRecord.Attribute1__c;
            }else
                lastProcessedDate = System.now().format('YYYY-MM-dd');

            System.debug('lastProcessedDate>>>>:'+lastProcessedDate);

            //Step2: Prepare Request JSON & execute GetSPInfo service

            resWrapper = CG_SL_SIEBEL.callGetInfoService(lastProcessedDate, 'GetSPTechSMN');

            if(resWrapper == null){
                System.debug('########## Returning from here after execution fails ###############'); 
            }
            System.debug('after returning resWrapper>>>:'+resWrapper+' #####httpRes:'+resWrapper.response+'######httpRes.getBody:'+resWrapper.response.getBody());
            //System.debug('resWrapper>>>:'+resWrapper);

            // spHeaderResJSON = (CG_WPR_SBL_SPTechnicianSMN)JSON.deserializeStrict(resWrapper.response.getBody(),CG_WPR_SBL_SPTechnicianSMN.class);
            spHeaderResJSON=CG_WPR_SBL_SPTechnicianSMN.parse(resWrapper.response.getBody());
            system.debug('spHeaderResJSON>>>:'+spHeaderResJSON);

            //Step3: insert GetTechInfo data
            Boolean successFlag = false;
            if(spHeaderResJSON ==null) 
                successFlag = false;
            else
                successFlag = insertSPTechnicianSMNData(spHeaderResJSON);

            //Step4: updating lastProcessedDate on lstJobEventTemp record
            if(successFlag && jobEventTempRecord != null && jobEventTempRecord.Id != null){
                system.debug('stamping current processed date value -->');
                jobEventTempRecord.Attribute1__c = System.now().format('YYYY-MM-dd');
                update jobEventTempRecord;
            }
            system.debug('$$$$$ GetSPTechnicianSMNData process completed successfully $$$$$$$');
        }catch(Exception ex){
            System.debug('in catch of GetSPTechnicianSMNData of CSS_FN_SIEBEL >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(ex.getStackTraceString(), 'CSS_FN_Siebel-GetSPTechnicianSMNData', ex.getLineNumber()+'-'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_Siebel-GetSPTechnicianSMNData', ex.getLineNumber()+'-'+ex.getMessage(), ex.getLineNumber()+'-'+ex.getMessage(), 'Siebel');
        }
    }
    public static Boolean insertSPTechnicianSMNData(CG_WPR_SBL_SPTechnicianSMN SPTechnicianSMNRes){
        Boolean successFlag = false;
        try{
            if(SPTechnicianSMNRes.DataArea.TechServiceModelInfo==null || SPTechnicianSMNRes.DataArea.TechServiceModelInfo.size()<=0)
return true;                
            
            //Prepare Account look up map
            map<string,id> mapSpCodeAccountId = new map<string,id>();
            set<String> setSpCodes = new set<String>();
            set<String> setFormatedSpCodes = new set<String>();
            for(CG_WPR_SBL_SPTechnicianSMN.TechServiceModelInfo daObj : SPTechnicianSMNRes.DataArea.TechServiceModelInfo){
                setSpCodes.add(String.valueOf(daObj.SpCode)); //building set of all spcode to fetch all accounts based on it 
            }
            if(setSpCodes != null && setSpCodes.size() > 0){
                //preparing set for the query to use like operator 
                for(String s : setSpCodes){
                    setFormatedSpCodes.add('%'+s);
                }
            }
            List<Account> accountList = new List<Account>([select Id, Name, Location__c, DIST_HQ_CODE__c, SP_ROW_ID__c from Account where Location__c LIKE :setFormatedSpCodes ]); //need to query all fields ???
            System.debug('accountList>>>:'+accountList);
            if(accountList != null && accountList.size()>0){
                for(Account acc:accountList)
                    mapSpCodeAccountId.put(acc.Location__c.right(5), acc.id);
                    //mapSpCodeAccountId.put(acc.SP_ROW_ID__c, acc.id); //SP_ROW_ID__c should be in Map
            }

            list<CSS_AccredUser__c> lstToUpsertAccredUser = new list<CSS_AccredUser__c>(); //Holds the list of Exsisting Accrediation user record.
            CSS_AccredUser__c accUsr;
            for(CG_WPR_SBL_SPTechnicianSMN.TechServiceModelInfo da:SPTechnicianSMNRes.DataArea.TechServiceModelInfo){
                accUsr = new CSS_AccredUser__c();
                accUsr.SpCode__c = da.SpCode;
                accUsr.SP_ROW_ID__c = da.SpRowId;
                accUsr.TECH_ROW_ID__c = da.TechRowId;
                accUsr.ServiceModelName__c = da.ServiceModelName;
                accUsr.SMN_ROW_ID__c = da.SmnRowId;
                if(da.CertPercentage !=null)
                accUsr.CERT_PERCENTAGE__c = (da.CertPercentage != null && da.CertPercentage != '') ? decimal.valueOf(da.CertPercentage) : 0;
                //accUsr.Accreditation__c = mapSMNtoAccreditation.get(da.SpCode+da.ServiceModelName).Id; Not Required .. making it lookup relationship from Master-DEtail. Only relation will be SMN
                if(da.Sprowid != null && da.Sprowid.trim() != '' && mapSpCodeAccountId.containskey(da.Sprowid))
                    accUsr.account__c = mapSpCodeAccountId.get(da.SpCode); //da.Sprowid; //This should be Account lookup Id
                accUsr.UniqueKey__c = da.SpRowId+da.SmnRowId+da.TechRowId;
                lstToUpsertAccredUser.add(accUsr);         
            }
            if(lstToUpsertAccredUser != null && lstToUpsertAccredUser.size()>0)
                upsert lstToUpsertAccredUser UniqueKey__c;
            successFlag = true;
        }catch(Exception ex){
            System.debug('in catch of insertSPTechnicianSMNData of CSS_FN_SIEBEL getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        IAM_ErrorHandling.IAMerrorCapture(ex.getStackTraceString(), 'CSS_FN_Siebel-insertSPTechnicianSMNData', ex.getLineNumber()+'-'+ex.getMessage());
            css_utility.LogOutIntError('CSS_FN_Siebel-insertSPTechnicianSMNData', ex.getLineNumber()+'-'+ex.getMessage(), ex.getLineNumber()+'-'+ex.getMessage(), 'Siebel');
        }
        return successFlag;
    }


    /*End*/

    //// By Priyanka VGRS2-512
    public static CG_OP_OAGWrapper calloutGenericMuleNamedCredGetMarketingAppCode() {
        system.debug('in calloutGeneric method for CreateUpdate Incident Record Into ServiceNow...');
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        FSL_IP_NamedCredentialWrapper reqWrap = new FSL_IP_NamedCredentialWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        try {
           
          

           
    reqWrap.methodType = 'GET';
    reqWrap.NamedCredential = 'FSL_NC_Engine';
    reqWrap.Path = '/productappcode?sender=CSS&target=CSSWarranty&lastProcessedDate=2020-02-21';
    reqWrap.endPoint =[SELECT Endpoint FROM NamedCredential
                                        where DeveloperName=: reqWrap.NamedCredential 
                                        LIMIT 1].Endpoint+reqWrap.Path;

            system.debug('SRT reqJsonpriya>>>>>>>>>>>'+reqWrap.jsonReqBody);
            if(Test.isRunningTest() && reqWrap.jsonReqBody == null)
                {
                throw new CSS_MyException('Exception to cover Catch block');
                }
                           

                returnWrapper = FSL_WS_Mule.calloutNamedCredentials(reqWrap);
             system.debug('SRT priyaresponse>>>>>>>>>>>'+returnWrapper);
            return returnWrapper;

        }catch(Exception ex){
           if(returnWrapper == null) {
                returnWrapper = New CG_OP_OAGWrapper();
            }
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = ex.getMessage();
            return returnWrapper;
        }
    }
    
 

    // Added by Abhishek
    public static void getApplicationCodesData(){
        try
        {   
            String lastProcessedDate;
            //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken('OAGOAuth'); //Commented for dynamic Authentication and added below line
            /*CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('getMarketingApplicationCodes').AuthEnv__c); 
            
            //In case of no access token
            if(accessTokenOPWrap!=null && accessTokenOPWrap.exceptionFlag==true)
            {
                css_utility.LogOutIntError('CSS_FN_Siebel-getMarketingApplicationCodesService', 'OAG Token Service failed', 'OAG Token is null', 'OAGOAuth');
                //return null;
            }
            String accessToken = accessTokenOPWrap.accessToken;
            System.debug('accessToken>>>>:'+accessToken);*/


            try{
                lastProcessedDate = [SELECT Attribute1__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'ApplicationCodes_LastProcessed' limit 1].Attribute1__c;
                system.debug('lastProcessedDate'+lastProcessedDate);
            }catch(exception e){
                lastProcessedDate = System.now().format('YYYY-MM-dd');
                system.debug('error message'+e.getMessage());
            }   

            System.debug('lastProcessedDate>>>>:'+lastProcessedDate);
            
        
            //Mule Integration start
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('getMarketingApplicationCodes');
            //Mule Integration end

            //String reqBody = '{"Header": {"Sender": {"ServiceName": "getMarketingApplicationCodes","SenderID": "CSS"},"Target": {"TargetID": "SIEBEL"}},"DataArea": {"LAST_PROCESSED_DATE": "'+lastProcessedDate+'"}}';
            String endPointURL;
            //CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); 
            //conDetails = CSS_Integration_Details__c.getValues('getMarketingApplicationCodes');
            if(conDetails != null && conDetails.IsActive__c == true) 
            {
               ///productappcode?sender=CSS&target=CSSWarranty&lastProcessedDate=2020-02-21'
                endPointURL = conDetails.End_Point__c+'?sender=CSS&target=CSSWarranty&lastProcessedDate=2020-02-21';//+lastProcessedDate;               
            }
            System.debug('endPointURL>>>>:'+endPointURL);
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            CG_OP_OAGWrapper outputWrapper = new CG_OP_OAGWrapper();
            reqWrapper.endPoint = endPointURL;
            reqWrapper.methodType = conDetails.Method_Type__c;
            //reqWrapper.jsonReqBody = reqBody;
            reqWrapper.serviceName = 'getMarketingApplicationCodes';
           // outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
           // BY Priyanka for VGRS-512
           outputWrapper = calloutGenericMuleNamedCredGetMarketingAppCode();
            
            //HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(reqBody, endPointURL, accessToken);
            HttpResponse httpRes = outputWrapper.response;
            system.debug('httpRes>>>>>>'+httpRes);
            if(httpRes == null || httpRes.getStatusCode() != 200)
            {
                css_utility.LogOutIntError('CSS_FN_Siebel-getMarketingApplicationCodeService', 'Siebel getMarketingApplicationCodes HttpResponse is null', 'Siebel getMarketingApplicationCodes Webservice Execution failed', 'Siebel');
                //return null;
            }else if(httpRes.getBody().contains('OSB Service Callout action received SOAP Fault response') )
            {
                System.debug('Incorrect json format-- STATUS:'+httpRes.getStatus()+'STATUS_CODE:'+httpRes.getStatusCode());
                css_utility.LogOutIntError('CSS_FN_Siebel-getMarketingApplicationCodes', 'Siebel getMarketingApplicationCodes HttpResponse is null', 'OSB Service Callout action received SOAP Fault response', 'Siebel');
                //return null;
            }
            //accountCodeRes = (CSS_SiebelAccountCodeResponseJ2A)JSON.deserializeStrict(httpRes.getBody(), CSS_SiebelAccountCodeResponseJ2A.class);
            //return accountCodeRes;   
            //below logic of save response data & weekly basis

            if(httpRes.getStatusCode() == 200){
                system.debug('httpRes.getBody()>>>>>>'+httpRes.getBody());
                insertResponse(httpRes.getBody(), 'getMarketingApplicationCodes');
            }
        }
        catch(exception e)
        {
            system.debug('Exception in getMarketingApplicationCodes method-->'+ e.getmessage() + '-----' + '<<>>>>' +  e.getLineNumber());
            //return null;
        }

    }

    //End by Abhishek


    public static void getApprovalAuthCode()
    {
        try
        {
            //Prepare Request Wrapper
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            
            CG_OP_OAGWrapper outputWrapper = new CG_OP_OAGWrapper();
            //Mule Integration start
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_ApprovalAuthCode');
            //Mule Integration end
            
           // String accessToken = CSS_WS_OAG.getAccessToken(); //Commented for dynamic Authentication and added below lines
            //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_ApprovalAuthCode').AuthEnv__c); 
            //String accessToken = accessTokenOPWrap.accessToken;
            /*if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken))
            {
                css_utility.LogOutIntError('CSS_FN_Siebel-GetApprovalAuthCodeService', 'OAG Token Service failed', 'OAG Token is null', 'OAGOAuth');
                //return null;
            }*/
            String lastProDate;
            try{
                lastProDate = [SELECT Attribute1__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'ApprovalAuthCode_LastProcessed' limit 1].Attribute1__c;
            }
            catch (exception ex){
                lastProDate = '2000-01-01';
            }
            //lastProDate = '2000-01-01'; //temporarily added to load

            //String reqBody = '{"Header": {"Sender": {"ServiceName": "getApprovalAuthCode","SenderID": "CSS"},"Target": {"TargetID": "SIEBEL"}},"DataArea": {"LAST_PROCESSED_DATE": "'+lastProDate+'"}}';
            String endPointURL;
            CSS_Integration_Details__c connection = new CSS_Integration_Details__c ();
            connection = CSS_getConnnectionDetails.getConnection('CSS_SBL_ApprovalAuthCode');
            if(connection != null){
                //endPointURL = connection.End_Point__c;
                endPointURL = connection.End_Point__c+'?sender=CSS&target=CSSWarranty&lastProcessedDate='+lastProDate;//'"2020-03-27';
            }
            //system.debug('reqBody--:>'+reqBody);
            
            reqWrapper.endPoint = endPointURL;
            reqWrapper.methodType = conDetails.Method_Type__c;
            //System.debug('reqBody ******* '+ reqBody);
            //reqWrapper.jsonReqBody = reqBody;
            reqWrapper.serviceName = 'CSS_SBL_ApprovalAuthCode';
            //outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
            outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            
            //HttpResponse httpRes = CSS_WS_OAG.executeRESTWebservice(reqBody, endPointURL, accessToken);
            HttpResponse httpRes = outputWrapper.response;
            system.debug('httpRes>>>>>>'+httpRes);
            if(httpRes == null || httpRes.getStatusCode() != 200)
            {
                css_utility.LogOutIntError('CSS_FN_Siebel-GetApprovalAuthCodeService', 'Siebel GetApprovalAuthCodes HttpResponse is null', 'Siebel GetApprovalAuthCodes Webservice Execution failed', 'Siebel');
                //return null;
            }else if(httpRes.getBody().contains('OSB Service Callout action received SOAP Fault response') )
            {
                System.debug('Incorrect json format-- STATUS:'+httpRes.getStatus()+'STATUS_CODE:'+httpRes.getStatusCode());
                css_utility.LogOutIntError('CSS_FN_Siebel-GetApprovalAuthCodes', 'Siebel GetApprovalAuthCodes HttpResponse is null', 'OSB Service Callout action received SOAP Fault response', 'Siebel');
                //return null;
            }
            //accountCodeRes = (CSS_SiebelAccountCodeResponseJ2A)JSON.deserializeStrict(httpRes.getBody(), CSS_SiebelAccountCodeResponseJ2A.class);
            //return accountCodeRes;   
            //below logic of save response data & weekly basis
            if(httpRes.getStatusCode() == 200){
                insertResponse(httpRes.getBody(), 'GetApprovalAuthCodes');
            }
        }
        catch(exception ex)
        {
            system.debug('Exception in GetApprovalAuthCodes method-->'+ex.getmessage()+' '+ex.getLineNumber());
            //return null;
        }
    }
    
    public static HttpResponse httpResTest = new HttpResponse();
    //Method to send Claims Details to SIEBEL
    public static void submitClaims(List<CSS_Claim_Submission__c> lstSubmissionClaim){
        system.debug('inside submitClaims');
        
        //Prepare Request Wrapper
        CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
        
        CG_OP_OAGWrapper outputWrapper = new CG_OP_OAGWrapper();
        
        //Mule Integration start
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_SubmitClaims');
        //Mule Integration end
            
        CG_ClaimSubmission_Resp claimsInboundRes;
        list<CSS_Claims__c> ClaimsProcessedList = new list<CSS_Claims__c>();
        set<Id> ClaimIdSet = new set<Id>();
        List<CSS_Claim_Submission__c> lstsRecord = new List<CSS_Claim_Submission__c>();
        list<CSS_JobHistory__c> jobHistoryToInsertList = new list<CSS_JobHistory__c>();
        List< CSS_Integration_Error__c> lsterror = new  List< CSS_Integration_Error__c>();
        String message;
        String endPointURL;
        HttpResponse httpRes;
        //getting Access Token 
        // String accessToken = CSS_WS_OAG.getAccessToken(); //Commented for dynamic Authentication and added below lines
        //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_SubmitClaims').AuthEnv__c); 
        CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_SubmitClaims').AuthEnv__c, 'CSS_SBL_SubmitClaims'); 
        String accessToken = accessTokenOPWrap.accessToken;
        
        if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken))
        {
            system.debug('inside accessToken');
            css_utility.LogOutIntError('CSS_FN_Siebel- Submit Claims to Siebel', 'OAG Token Service failed', 'OAG Token is null', 'SIEBELLOGIN');
            //return null;
        }
        try
        {
            CSS_Integration_Details__c connection = new CSS_Integration_Details__c ();
            connection = CSS_getConnnectionDetails.getConnection('CSS_SBL_SubmitClaims');
            if(connection != null && !Test.isRunningTest()){
                endPointURL = connection.End_Point__c;                
            }
            else{
                endPointURL = 'https://services-dev.cummins.com/csswarranty/claimsubmission/'; 
            }
            if(lstSubmissionClaim.size()>0){
                for(CSS_Claim_Submission__c c: lstSubmissionClaim){
                    system.debug('lstSubmissionClaim'+c.id);
                    if(c.Siebel_Claim_JSON__c != null & c.Siebel_Claim_JSON__c != '') {
                        CSS_Integration_Error__c errObjLog = new CSS_Integration_Error__c();
                        errObjLog.Error_Description__c = 'Claim '+ c.Individual_Claim_Id__c +' - SUBMITTING ';
                        errObjLog.Source__c = 'Submit Claims to Siebel - START';
                        errObjLog.Processed_Data__c = c.Siebel_Claim_JSON__c;
                        lsterror.add(errObjLog);
                        
                        reqWrapper.endPoint = endPointURL;
                        reqWrapper.methodType = conDetails.Method_Type__c;
                        //System.debug('reqBody ******* '+ reqBody);
                        reqWrapper.jsonReqBody = c.Siebel_Claim_JSON__c;
                        reqWrapper.serviceName = 'CSS_SBL_SubmitClaims';
                        
                        if(!Test.isRunningTest()){
                            outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                            //httpRes = CSS_WS_OAG.executeRESTWebservice(c.Siebel_Claim_JSON__c, endPointURL, accessToken);
                            httpRes = outputWrapper.response;
                        }
                        else{
                            httpRes = httpResTest;
                           /*string jsonRespBody = '{'+
'  "Header":{'+
'    "Status":"Success",'+
'    "ReturnCodeDescription":""'+
'  },'+
'  "DataArea":{'+
'    "Status":"Success",'+
'    "ClaimNumber":"1-3635823017",'+
'    "ErrorMessage":""'+
'  }'+
'}';
                        httpRes = new HttpResponse();
                       httpRes.setHeader('Content-Type', 'application/json');
                       httpRes.setBody(jsonRespBody);
                       httpRes.setStatusCode(200);*/
                        }
                        system.debug('httpRes--'+httpRes);
                    }
                    system.debug('httpRes>>>>>>'+httpRes);
                    if(httpRes == null || httpRes.getStatusCode() != 200)
                    {
                        // css_utility.LogOutIntError('CSS_FN_Siebel-Submit Claims to Siebel', 'Submit Claims to Siebel HttpResponse is null', 'Submit Claims to Siebel Webservice Execution failed', 'Siebel');
                        System.debug('inside REST response is :: '+httpRes);
                        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
                        //errObj.Error_Description__c = 'Submit Claims to Siebel HttpResponse is null' + ' *** External Message ** ' + 'Submit Claims to Siebel Webservice Execution failed';
                        errObj.Error_Description__c = 'Claim '+ c.Individual_Claim_Id__c +' was returned with Error status from Siebel';
                        //errObj.Source__c = 'Siebel'; Rajesh Narra has modified the source value to Submit Claims to Siebel to uniquely track the failed claims that are submitted to Siebel
                        errObj.Source__c = 'Submit Claims to Siebel';
                        errObj.Processed_Data__c = 'CSS_FN_Siebel-Submit Claims to Siebel';
                        errObj.Response_Body__c = (httpRes.getBody() != null && httpRes.getBody() != '')?httpRes.getBody():'The Response body is Null, Check with Middleware team';
                        lsterror.add(errObj);
                        System.debug('REST response lsterror :: '+lsterror);
                        CSS_JobHistory__c jobHist = new CSS_JobHistory__c();
                        jobHist.CSS_Field_Name__c = 'Claim '+c.CSS_Claims__r.name+' failed for adjudication at '+system.now();
                        jobHist.CSS_Job_Id__c = c.Id;
                        jobHist.CSS_Object_Name__c = 'CSS_Claim__c';
                        jobHistoryToInsertList.add(jobHist);
                        //CSS_Claim_Submission__c csub = new CSS_Claim_Submission__c();
                        //csub.id=c.id;
                        c.Status__c='In Process';//csub.Status__c='In Process';
                        c.Siebel_Status__c = 'Error';//csub.Siebel_Status__c = 'Error';
                        c.Batch_Processed_Date__c=System.Now();
                        lstsRecord.add(c);
                        ClaimIdSet.add(c.CSS_Claims__c);
                        //return null;
                    }else if(httpRes.getBody().contains('OSB Service Callout action received SOAP Fault response') )
                    {
                        System.debug('Incorrect json format-- STATUS:'+httpRes.getStatus()+'STATUS_CODE:'+httpRes.getStatusCode());
                        // css_utility.LogOutIntError('CSS_FN_Siebel-GetApprovalAuthCodes', 'Submit Claims to Siebel HttpResponse is null', 'OSB Service Callout action received SOAP Fault response', 'Siebel');
                        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
                        //errObj.Error_Description__c = 'Submit Claims to Siebel HttpResponse is null' + ' *** External Message ** ' + 'OSB Service Callout action received SOAP Fault response';
                        errObj.Error_Description__c = 'Claim '+ c.Individual_Claim_Id__c +' was returned with Error status from Siebel';
                        //errObj.Source__c = 'Siebel'; Rajesh Narra has modified the source value to Submit Claims to Siebel to uniquely track the failed claims that are submitted to Siebel
                        errObj.Source__c = 'Submit Claims to Siebel';
                        errObj.Processed_Data__c = 'CSS_FN_Siebel-Submit Claims to Siebel';
                        errObj.Response_Body__c = (httpRes.getBody() != null && httpRes.getBody() != '')?httpRes.getBody():'The Response body is Null, Check with Middleware team';
                        lsterror.add(errObj);
                        CSS_JobHistory__c jobHist = new CSS_JobHistory__c();
                        jobHist.CSS_Field_Name__c = 'Claim '+c.CSS_Claims__r.name+' was retuned with Error status from Siebel.';
                        jobHist.CSS_Job_Id__c = c.Id;
                        jobHist.CSS_Object_Name__c = 'CSS_Claim__c';
                        jobHistoryToInsertList.add(jobHist);
                        //CSS_Claim_Submission__c csub = new CSS_Claim_Submission__c();
                        //csub.id=c.id;
                        c.Status__c='In Process';//csub.Status__c='In Process';
                        c.Siebel_Status__c = 'Error';//csub.Siebel_Status__c = 'Error';
                        c.Batch_Processed_Date__c=System.Now();
                        lstsRecord.add(c);
                        ClaimIdSet.add(c.CSS_Claims__c);
                        //return null;
                    }

                    //string req = '{\"Header\": {\"Target\": {\"TargetID\": \"BMS\"},\"Sender\": {\"ServiceName\": \"sendPDFGenerationReq\",\"SenderID\": \"CSS\"},\"Location\": {\"LocationID\": \"03520-02331\"}},\"DataArea\":{\"CSSJobID\": \"CSS-00176434\",\"DistributorCode\": \"03520\",\"BranchCode\": \"02331\",\"CustomerCode\": \"WOQT\",\"OrderType\": \"WOQT\",\"BMSReferenceNumber\": \"283122\",\"CustomerPO\":\"\",\"Action\": \"QUOTE REQUEST\",\"SecurityCode\":\"\",\"InvoiceUser\":\"\"}}';
                    //system.debug('Request--'+req);
                    //de-serializing the response and mapping it to wrapper class
                    else if(httpRes != null && httpRes.getStatusCode() == 200){

                        claimsInboundRes = (CG_ClaimSubmission_Resp )JSON.deserialize(httpRes.getBody(),CG_ClaimSubmission_Resp.class);
                        System.debug('Status Code >>> :: '+httpRes.getStatusCode());
                        System.debug('REST response is :: '+httpRes);
                        system.debug('Response Body >>>'+httpRes.getbody());
                        //CSS_Claim_Submission__c csub = new CSS_Claim_Submission__c();
                        //csub.id=c.id;
                        if(httpRes.getbody() != null && httpRes.getbody() != ''){
                            //if(claimsInboundRes.Header.Status == 'Success'){                                                           
                            if(claimsInboundRes.Header.Status == 'Success'){
                                if(c.CSS_Claims__r.Information_Only_Claim__c == true){ 
                                    c.Status__c='Information Only';
                                }
                                else{
                                    c.Status__c='In Review';
                                }

                                if(claimsInboundRes.DataArea.ClaimNumber != null){
                                    c.Siebel_Claim_Number__c=claimsInboundRes.DataArea.ClaimNumber;//+system.now(); 
                                    if(c.BMS_Claim_ReqJSON__c != null && c.BMS_Claim_ReqJSON__c != '') // Added by Rajesh Narra on 7-05-2018 during SIT
                                        c.BMS_Claim_ReqJSON__c = c.BMS_Claim_ReqJSON__c.replace('SIEBEL CLAIM NUMBER TBU', claimsInboundRes.DataArea.ClaimNumber);
                                }
                                c.Siebel_Status__c = 'Success';
                            }
                            else{
                                CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
                                //errObj.Error_Description__c = 'Submit Claims to Siebel HttpResponse is null' + ' *** External Message ** ' + 'OSB Service Callout action received SOAP Fault response';
                                errObj.Error_Description__c = 'Claim '+ c.Individual_Claim_Id__c +' was returned with Error status from Siebel';
                                //errObj.Source__c = 'Siebel'; Rajesh Narra has modified the source value to Submit Claims to Siebel to uniquely track the failed claims that are submitted to Siebel
                                errObj.Source__c = 'Submit Claims to Siebel';
                                errObj.Processed_Data__c = 'CSS_FN_Siebel-Submit Claims to Siebel';
                                errObj.Response_Body__c = (httpRes.getBody() != null && httpRes.getBody() != '')?httpRes.getBody():'The Response body is Null, Check with Middleware team';
                                lsterror.add(errObj);
                                CSS_JobHistory__c jobHist = new CSS_JobHistory__c();
                                jobHist.CSS_Field_Name__c = 'Claim '+c.CSS_Claims__r.name+' was retuned with Error status from Siebel.';
                                jobHist.CSS_Job_Id__c = c.Id;
                                jobHist.CSS_Object_Name__c = 'CSS_Claim__c';
                                jobHistoryToInsertList.add(jobHist);
                                c.Status__c='In Process';
                                c.Siebel_Status__c = 'Error';
                            }
                            c.Batch_Processed_Date__c=System.Now();
                            lstsRecord.add(c);
                            ClaimIdSet.add(c.CSS_Claims__c);
                        }
                    }
                }
            }

            if(lsterror.size()>0){
                insert lsterror;
            }


            if(lstsRecord.size()>0){
                update lstsRecord;

            }
            if(jobHistoryToInsertList != null && !jobHistoryToInsertList.isEmpty()){
                CSS_utility.createJobhistory(jobHistoryToInsertList);
            }

            if(ClaimIdSet != null && ClaimIdSet.size() > 0) {
                for(Id claimsId : ClaimIdSet) {
                    CSS_Claims__c claim = new CSS_Claims__c();
                    claim.Id = claimsId;
                    claim.isSiebelProcessed__c = true;
                    ClaimsProcessedList.add(claim);
                }
            }

            if(ClaimsProcessedList != null && ClaimsProcessedList.size()>0){
                update ClaimsProcessedList;
            }
        }
        catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();

                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- TIMED OUT - Send Claims to Siebel', 'RESPONSE IS NULL'+httpRes.getStatusCode(), 'Submit Claims to Siebel');

                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- Send Claims to Siebel', httpRes==null?'RESPONSE IS NULL':httpRes.getBody(), 'Submit Claims to Siebel');
                }
                
                if(lsterror.size()>0){
                    insert lsterror;
                }
            }
        }
        //return claimsInboundRes;
    }

    public static CG_PaidClaimsDetailsResWrapper paidclaimdetails(CG_PaidClaimsDetailsReqWrapper paidclaimdetailsReq){
        CG_PaidClaimsDetailsResWrapper paidclaimdetailsRes;
        String message;
        String endPointURL;
        HttpResponse res1;
        //getting Access Token 
                // String accessToken = CSS_WS_OAG.getAccessToken(); //Commented for dynamic Authentication and added below lines
            //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CG_SBL_Getpaidclaimdetails').AuthEnv__c); 
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CG_SBL_Getpaidclaimdetails').AuthEnv__c, 'CG_SBL_Getpaidclaimdetails'); 
            String accessToken = accessTokenOPWrap.accessToken;
        //system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+accessToken);
        system.debug('SBL$$$$$$$$@@@@@@@@@@:::'+paidclaimdetailsReq);
        system.debug('IMSClaimnumber--'+paidclaimdetailsReq.DataArea.IMSClaimNumber);
        system.debug('ClaimNumber--'+paidclaimdetailsReq.DataArea.ClaimNumber);
        try
        {
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();

            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken))
            {
                system.debug('inside accessToken');
                //css_utility.LogOutIntError('CSS_FN_Siebel- paidclaimdetails', 'OAG Token Service failed', 'OAG Token is null', 'OAGOAuth');
                //return null;
            }
            CSS_Integration_Details__c connection = new CSS_Integration_Details__c ();
            connection = CSS_getConnnectionDetails.getConnection('CG_SBL_Getpaidclaimdetails');
            System.debug('connection.Method_Type__c='+connection.Method_Type__c);
            System.debug('connection======'+connection);
            if(connection != null && !Test.isRunningTest()){
                //endPointURL = connection.End_Point__c;
                endPointURL = connection.End_Point__c+'?sender=CSS&target=CSSWarranty&claimNumber='+paidclaimdetailsReq.DataArea.ClaimNumber+'&imsClaimNumber='+paidclaimdetailsReq.DataArea.IMSClaimNumber;                
            }
            else{
                endPointURL = 'https://services-dev.cummins.com/csswarranty/claimdetails/'; 
            }
            
            system.debug('endPointURL--'+endPointURL);
            req1.setHeader('Authorization','Bearer '+accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setHeader('client-id', connection.Username__c);
            req1.setHeader('client-secret', connection.Passcode__c);
            req1.setMethod(connection.Method_Type__c);
            //req1.setTimeout(Integer.valueof(connection.Timeout__c));
            req1.setTimeout(120000);
            req1.setEndpoint(endPointURL);

            String reqWrpperInput = JSON.serialize(paidclaimdetailsReq);
            //req1.setBody(reqWrpperInput);              
            System.debug('req1.getBody======'+req1.getBody());
            String jsonResponseBody;
            res1 = h1.send(req1);
            jsonResponseBody=res1.getBody();
            system.debug('jsonResponseBody--'+jsonResponseBody);
            //jsonResponseBody='{ "DataArea": { "DetailSRTs": [ { "SRTHours": 0.4, "SRTQty": 1, "PercentageAdjustment": 100, "AdjustmentReason": "", "AccessCode": "R", "SRTCode": "00-901-00", "PenaltyAppliedFlag": "Y" }, { "SRTHours": 0.2, "SRTQty": 1, "PercentageAdjustment": 100, "AdjustmentReason": "", "AccessCode": "B", "SRTCode": "TS-051-01", "PenaltyAppliedFlag": "Y" } ], "DetailOtherClaimables": [ { "Item": "", "Description": "1", "ApprovedAmount": 2452, "AdjustmentReason": "" } ], "DetailParts": [ { "AdjustmentPartsPercent": 100, "PartQty": 1, "PartNumber": "408998500RX", "AdjustmentReason": "" } ], "DetailTravel": [ { "TravelType": "Meals", "AdjustmentReason": "", "Distance": 2452, "Hours": 2.3, "LodgingAmount": 345, "MealsAmount": 46, "TowingDetails": 234, "PenaltyAppliedFlag": "Y" } ] }, "Header": { "MessageIdentifier": "", "ReturnCode": "", "ReturnCodeDescription": "", "Status": "Success" } }';

            paidclaimdetailsRes = (CG_PaidClaimsDetailsResWrapper )JSON.deserialize(jsonResponseBody,CG_PaidClaimsDetailsResWrapper.class);
            System.debug('Status Code >>> :: '+res1.getStatusCode());
            System.debug('REST response is :: '+res1);
            system.debug('Response Body >>>'+res1.getbody());
            system.debug('Response Wrapper -->'+paidclaimdetailsRes);
        }
        catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();

                /*if(message.contains('timed out')){
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- paidclaimdetails', 'RESPONSE IS NULL', 'BMS');
}
else{
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- paidclaimdetails', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
}*/
            }
        }
        return paidclaimdetailsRes;
    }


    //Method to Send Notes Details to Siebel -- Rajasekhar H for I-Survived 147239
    
    
    public static CG_SendNotesSiebelResponseWrapper sendnotesdetails(String claimSubId, List<Note> notesList){
        //public static CG_SendNotesSiebelResponseWrapper sendnotesdetails(){
        CG_SendNotesSiebelOutboundRequestWrapper sendnotesdetailsReq = new CG_SendNotesSiebelOutboundRequestWrapper();
        CG_SendNotesSiebelOutboundRequestWrapper.Header headerObj = new CG_SendNotesSiebelOutboundRequestWrapper.Header();
        CG_SendNotesSiebelOutboundRequestWrapper.Sender senderObj = new CG_SendNotesSiebelOutboundRequestWrapper.Sender();
        CG_SendNotesSiebelOutboundRequestWrapper.Target targetObj = new CG_SendNotesSiebelOutboundRequestWrapper.Target();
        CG_SendNotesSiebelOutboundRequestWrapper.DataArea dataAreaObj = new CG_SendNotesSiebelOutboundRequestWrapper.DataArea();
        CG_SendNotesSiebelOutboundRequestWrapper.NoteDetails ntdetObj = new CG_SendNotesSiebelOutboundRequestWrapper.NoteDetails();
        CG_SendNotesSiebelResponseWrapper sendnotesdetailsRes;
        CSS_Claim_Submission__c cs;
        String message;
        String endPointURL;
        HttpResponse res1;
        CG_OP_OAGWrapper outputWrapper = new CG_OP_OAGWrapper();
        
        //getting Access Token 
              // String accessToken = CSS_WS_OAG.getAccessToken(); //Commented for dynamic Authentication and added below lines
        //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CG_SBL_SendNotesDetails').AuthEnv__c); 
        CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CG_SBL_SendNotesDetails').AuthEnv__c, 'CG_SBL_SendNotesDetails'); 
        String accessToken = accessTokenOPWrap.accessToken;
        system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+accessToken);
        system.debug('SBL$$$$$$$$@@@@@@@@@@:::'+sendnotesdetailsReq);
        try
        {
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();

            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken))
            {
                system.debug('inside accessToken');
                css_utility.LogOutIntError('CSS_FN_Siebel- sendnotesdetails', 'OAG Token Service failed', 'OAG Token is null', 'OAGOAuth');
                //return null;
            }
            
            cs = [select Id,Name,Individual_Claim_Id__c,Siebel_Claim_Number__c from CSS_Claim_Submission__c where Individual_Claim_Id__c =: claimSubID limit 1];
            
            system.debug('***cs***'+cs);
            senderObj.ServiceName = 'sendNotes';
            senderObj.SenderID = 'SIEBEL';
            
            targetObj.TargetID ='CSS';
            
            headerObj.Sender =  senderObj;
            headerObj.Target =  targetObj;
            
            dataAreaObj.NoteDetails = new List<CG_SendNotesSiebelOutboundRequestWrapper.NoteDetails>();
            if(notesList!= null && notesList.size()>0){
                for(Note noteObj : notesList){
                    ntdetObj.Note = noteObj.Body;
                    ntdetObj.ExtNoteId = 'GUIDANZ ID';
                    ntdetObj.NoteType = noteObj.Title;
                    dataAreaObj.NoteDetails.add(ntdetObj);
                }
            }
            
            dataAreaObj.SiebelClaimNumber = cs.Siebel_Claim_Number__c;
            dataAreaObj.ReqOperation = 'Create';
            
            
            sendnotesdetailsReq.Header =  headerObj;
            sendnotesdetailsReq.DataArea =  dataAreaObj;
            
            CSS_Integration_Details__c connection = new CSS_Integration_Details__c ();
            connection = CSS_getConnnectionDetails.getConnection('CG_SBL_SendNotesDetails');
            system.debug('After getConnection'+connection);
            if(connection != null && !Test.isRunningTest()){
                endPointURL = connection.End_Point__c;                
            }
            else{
                endPointURL = 'https://services-dev.cummins.com/csswarranty/csssendnotes/'; 
            }

            //req1.setHeader('Authorization','Bearer '+accessToken);
            //req1.setHeader('Content-Type','application/json');
            //req1.setMethod('POST');
            //req1.setTimeout(120000);
            //req1.setEndpoint(endPointURL);
            
            system.debug('sendnotesdetailsReq**'+sendnotesdetailsReq);
            String reqWrpperInput = JSON.serialize(sendnotesdetailsReq);
            system.debug('reqWrpperInput**'+reqWrpperInput);
            //Request to test Mule Integration start
            /*String reqWrpperInput = '{'+
'  "Header": {'+
'    "Target": {'+
'      "TargetID": "CSS"'+
'    },'+
'    "Sender": {'+
'      "ServiceName": "sendNotes",'+
'      "SenderID": "SIEBEL"'+
'    }'+
'  },'+
'  "DataArea": {'+
'    "SiebelClaimNumber": "044023",'+
'    "ReqOperation": "Create",'+
'    "NoteDetails": ['+
'      {'+
'        "ExtNoteId": "a093B000001xDHzQAM",'+
'        "Note": "Cause Notes",'+
'        "NoteType": "Cause"'+
'      },'+
'      {'+
'        "ExtNoteId": "a093B000001JCu6QAG",'+
'        "Note": "Correction Notes",'+
'        "NoteType": "Correction"'+
'      }'+
'    ]'+
'  }'+
'}'+
'';*/
//Request to test Mule Integration end
            //req1.setBody(reqWrpperInput);              
            System.debug('req1.getBody======'+req1.getBody());
            String jsonResponseBody;
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.endPoint = endPointURL;
            reqWrapper.methodType = connection.Method_Type__c;
            reqWrapper.jsonReqBody = reqWrpperInput;
            reqWrapper.serviceName = 'CG_SBL_SendNotesDetails';
            outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            //res1 = h1.send(req1);
            res1 = outputWrapper.response;
            if(res1.getbody() != null && res1.getbody() != ''){
                jsonResponseBody=res1.getBody();
                sendnotesdetailsRes = (CG_SendNotesSiebelResponseWrapper )JSON.deserialize(jsonResponseBody,CG_SendNotesSiebelResponseWrapper.class);
                System.debug('Status Code >>> :: '+res1.getStatusCode());
                System.debug('REST response is :: '+res1);
                system.debug('Response Body >>>'+res1.getbody());
            }
            else{
                CSS_Integration_Error__c errorObjLog1 = new  CSS_Integration_Error__c();
                system.debug('errorObjLog');
                string jsonString = JSON.serialize(notesList);
                errorObjLog1.Processed_Data__c =  jsonString;
                errorObjLog1.Response_Body__c =   res1.getBody();
                errorObjLog1.Source__c= 'Siebel';
                errorObjLog1.Service_Name__c = 'sendNotes';
                errorObjLog1.Service_Job_Number__c= claimSubId;
                insert errorObjLog1;
            }
        }
        catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();

                /*if(message.contains('timed out')){
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- paidclaimdetails', 'RESPONSE IS NULL', 'BMS');
}
else{
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- paidclaimdetails', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
}*/
            }
        }
        return sendnotesdetailsRes;
    }
    

    public static CSS_GetClaimDetailsResponse getClaimDetails(String SiebelClaimNumber) 
    {

        CG_OP_OAGWrapper outputWrapper;
        CSS_GetClaimDetailsRequest ClaimDetailsReq = new CSS_GetClaimDetailsRequest(); //Wrapper
        CSS_GetClaimDetailsResponse ClaimDetailsRes = new CSS_GetClaimDetailsResponse();

        try {

            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();

            String reqBody =  '{"Header": {"Target": {"TargetID": "SIEBEL"},"Sender": {"ServiceName": "getClaimDetails","SenderID": "CSS"}},"DataArea": {"SiebelClaimNumber":"'+ SiebelClaimNumber +'"}}';  

            System.debug('reqBody ******* '+ reqBody);
            reqWrapper.jsonReqBody = reqBody;

            reqWrapper.serviceName = 'CSS_SBL_GetClaimDetails';  //get End point urls

            outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);

            /*      if(outputWrapper!=null && outputWrapper.response.getbody()!=null && outputWrapper.response.getbody()!='')
            {
                CSS_GetClaimDetailsResponse response = (CSS_GetClaimDetailsResponse) System.JSON.deserialize(outputWrapper.response.getBody(), CSS_GetClaimDetailsResponse.class);
                System.debug('outputWrapper.response.getBody() ******* '+ outputWrapper.response.getBody());
            } */

            if(outputWrapper != null && outputWrapper.exceptionFlag != null && outputWrapper.exceptionFlag == true){
                System.debug('Exception of getClaimDetails service is ******* '+ outputWrapper.exceptionMessage);
                outputWrapper = null;

            }

            if(outputWrapper != null && outputWrapper.response != null && outputWrapper.response.getBody() != null)
            {
                ClaimDetailsRes = (CSS_GetClaimDetailsResponse) System.JSON.deserialize(outputWrapper.response.getBody(), CSS_GetClaimDetailsResponse.class);

                System.debug('outputWrapper.response.getBody() ******* '+ outputWrapper.response.getBody());
                System.debug('outputWrapper.response.getBody() ******* '+ ClaimDetailsRes);
            }

        } 
        catch(exception e)
        {
            outputWrapper = null;
            system.debug('Entered into catch of getClaimDetails Method in CSS_FN_SIEBEL>>>'+e.getMessage() +e.getLineNumber());
        }
        return ClaimDetailsRes;
        //return outputWrapper;
    } 


    public static CG_OP_OAGWrapper getpartsdata(string PartNumberShort) 
    {

        CG_OP_OAGWrapper outputWrapper;
        CG_GetPartsdatareqWrapper paidClaimsWrapper = new CG_GetPartsdatareqWrapper();
        try {

            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            
            //Mule Integration start
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_GetPartsData');
            //Mule Integration end

            /*String reqBody =  '{"Header":{"Sender":{ "MessageID":"UniqueID","ServiceName": "getpartsdata","SenderID":"CSS" }},"DataArea":{"PartNumberShort": "'+ PartNumberShort +'"}}';

            System.debug('reqBody ******* '+ reqBody);
            reqWrapper.jsonReqBody = reqBody;*/
            
            String endPoint = conDetails.End_Point__c+'?sender=CSS&target=CSSWarranty&partNumberShort='+PartNumberShort;//3899283';
            reqWrapper.endPoint = endPoint;
            reqWrapper.methodType = conDetails.Method_Type__c;
            reqWrapper.serviceName = 'CSS_SBL_GetPartsData';
            
           //outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
            outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            //outputWrapper = null; //If you un-comment Service will fail  
            if(outputWrapper != null && outputWrapper.exceptionFlag != null && outputWrapper.exceptionFlag == true){
                System.debug('Exception of getpartsdata service is ******* '+ outputWrapper.exceptionMessage);
                outputWrapper = null;

            }

            if(outputWrapper != null && outputWrapper.response != null && outputWrapper.response.getBody() != null)
            {
                System.debug('outputWrapper.response.getBody() ******* '+ outputWrapper.response.getBody());
            }

        } 
        catch(exception e)
        {
            outputWrapper = null;
            system.debug('Entered into catch of getpartdata Method in CSS_FN_SIEBEL>>>'+e.getMessage() +e.getLineNumber());
        }
        return outputWrapper;
    }

    //Below code is added for getting claimsdetail from siebel Story#161007

    public static CSS_GetClaimDetailsResponse CallGetClaimDetails(string ClaimNumber) {

        //Intialization of req and response wrapper class.
        CSS_GetClaimDetailsResponse cresWrap = new CSS_GetClaimDetailsResponse();

        /*CSS_GetClaimDetailsRequest  csubmitReq =new CSS_GetClaimDetailsRequest ();

        CSS_GetClaimDetailsRequest.Header cheaderobj = new  CSS_GetClaimDetailsRequest.Header();
        CSS_GetClaimDetailsRequest.Sender cSenderobj = new  CSS_GetClaimDetailsRequest.Sender();
        CSS_GetClaimDetailsRequest.Target  cTargetobj = new  CSS_GetClaimDetailsRequest.Target ();

        cSenderobj.ServiceName='CSS_SBL_GetClaimDetails';
        cSenderobj.SenderID='CSS';
        cTargetobj.TargetID='SIEBEL';
        cheaderobj.Sender=cSenderobj;
        cheaderobj.Target=cTargetobj;
        //Forming request dataarea with input claim number
        CSS_GetClaimDetailsRequest.DataArea  cDataAreaobj  = new  CSS_GetClaimDetailsRequest.DataArea ();

        cDataAreaobj.SiebelClaimNumber=ClaimNumber;
        CSS_GetClaimDetailsResponse.DataArea  cresDataAreaobj = new CSS_GetClaimDetailsResponse.DataArea();

        csubmitReq.Header =cHeaderobj;
        csubmitReq.DataArea =cDataAreaobj;*/
        String message;
        String endPointURL;
        
        //Prepare Request Wrapper
        CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
        CG_OP_OAGWrapper outputWrapper = new CG_OP_OAGWrapper();
        
        //Mule Integration start
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails = CSS_getConnnectionDetails.getConnection('CSS_SBL_GetClaimDetails');
        //Mule Integration end

        //  HttpResponse res1;
        //getting Access Token 
        String accessToken;
        //String accessToken = CSS_WS_OAG.getAccessToken(); //Commented for dynamic Authentication and added below lines
        //CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_OAG.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_GetClaimDetails').AuthEnv__c);
        CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('CSS_SBL_GetClaimDetails').AuthEnv__c, 'CSS_SBL_GetClaimDetails');
        accessToken = accessTokenOPWrap.accessToken;
        system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+accessToken);
        //system.debug('SBL$$$$$$$$@@@@@@@@@@:::'+csubmitReq);
        try
        {
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            HttpResponse res1 = new HttpResponse();
            if(accessToken == null || accessToken.trim() == '' || String.isBlank(accessToken) || String.isEmpty(accessToken))
            {
                system.debug('inside accessToken');
            }
            CSS_Integration_Details__c connection = new CSS_Integration_Details__c ();
            connection = CSS_getConnnectionDetails.getConnection('CSS_SBL_GetClaimDetails');
            if(connection != null && !Test.isRunningTest()){
                endPointURL = connection.End_Point__c;                
            }
            else{
                endPointURL = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/claims?sender=CSS&target=CSSWarranty&siebelClaimNumber=1-1011307897'; 
            }

            req1.setHeader('Authorization','Bearer '+accessToken);
            req1.setHeader('Content-Type','application/json');
            req1.setMethod(connection.Method_Type__c);
            //req1.setMethod('POST');
            // req1.setTimeout(Integer.valueof(connection.Timeout__c));
            req1.setTimeout(120000);
            req1.setEndpoint(endPointURL);

            //String reqWrpperInput = JSON.serialize(csubmitReq);

            //req1.setBody(reqWrpperInput);   

            System.debug('req1.getBody======'+req1.getBody());

            String jsonResponseBody;
            
            String endPoint = conDetails.End_Point__c+'?sender=CSS&target=CSSWarranty&siebelClaimNumber='+ClaimNumber;//1-1011307897';
            reqWrapper.endPoint = endPoint;
            reqWrapper.methodType = conDetails.Method_Type__c;
            //System.debug('reqBody ******* '+ reqBody);
            //reqWrapper.jsonReqBody = reqBody;
            reqWrapper.serviceName = 'CSS_SBL_GetClaimDetails';
            //outputWrapper = CG_WS_OAG.calloutGeneric(reqWrapper);
            if(!Test.isRunningTest()) {
                outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                 res1 = outputWrapper.response;
                //Anirudh hardcode the value to mock the service and implement story...needs to be removed once webservice is delivered
                jsonResponseBody=res1.getBody();
            }
            else{
                jsonResponseBody = '{'+
' "Header":{'+
'    "Status":"Success",'+
'   "ReturnCode":"",'+
'    "ReturnCodeDescription":"SUCCESS",'+
'    "MessageIdentifier":"1-1011307897"'+
'  },'+
'  "DataArea":['+
'    {'+
'      "DistributorCode":"04405",'+
'      "ECMRevBfr":"",'+
'      "FailureList":['+
'        {'+
'          "FaultCode":"",'+
'          "FailMode":"BR",'+
'          "Failurename":"FUEL INJECTOR",'+
'          "PayCode":"X",'+
'          "CampaignNumber":"",'+
'          "SystemCode":"FI",'+
'          "ComponentCode":"AS",'+
'          "AccountCode":98'+
'        },'+
'        {'+
'          "FaultCode":"",'+
'          "OtherClaimablesList":['+
'            {'+
'              "Item":"UNLISTED 2 (ADD DESCRIPTION)",'+
'              "ClaimedAmount":12,'+
'              "AdjustmentReason":"",'+
'              "ItemDescription":"ANTIFREEZE, GREEN 3.78LTR",'+
'              "AdjustedAmount":12'+
'            }'+
'          ],'+
'          "FailMode":"BR",'+
'          "Failurename":"Air Compressor Air Line O-Ring Seal",'+
'          "PayCode":"X",'+
'          "CampaignNumber":"",'+
'          "SRTList":['+
'            {'+
'              "SRTCode":"22-502-00",'+
'              "ClaimedPercent":100,'+
'              "ClaimedHours":0.8,'+
'              "AdjustedPercent":100,'+
'              "AdjustedQty":2,'+
'              "AdjustedHours":0.8,'+
'              "SRTHours":0.4,'+
'              "AdjustmentReason":"",'+
'              "SRTDescription":"Fastener, Fitting or Stud, Broken or Seized - Drill Out and Repair Hole Threads, Each",'+
'              "ClaimedQty":2,'+
'              "PenaltyAppliedFlag":"N"'+
'            }'+
'         ],'+
'          "TravelList":['+
'            {'+
'              "TravelType":"Lodging",'+
'              "ClaimedDistance":"100",'+
'              "ClaimedHours":"0.8",'+
'              "ClaimedAmount":"100",'+
'              "AdjustedDistance":"2",'+
'              "AdjustedHours":"0.8",'+
'              "AdjustedAmount":"0.4",'+
'              "LodgingAmount":"12",'+
'              "MealsAmount":"2",'+
'              "TowingAmount":"0.4",'+
'              "LaborAmount":"23",'+
'              "TravelAmount":"2",'+
'              "TotalTravel":"2",'+
'              "BaseFare":"2",'+
'              "AdjustedBaseFare":2,'+
'              "AdjustedMeals":2,'+
'              "AdjustedTowing":2,'+
'              "AdjustedLodging":2,'+
'              "PenaltyAppliedFlag":"2",'+
'              "AdjustedPercent":"2",'+
'              "AdjustmentReason":"N"'+
'            }'+
'         ],'+
'          "SystemCode":"QI",'+
'          "ComponentCode":"OR",'+
'          "AccountCode":98,'+
'          "PartsList":['+
'            {'+
'              "PartNumber":287228800,'+
'              "TrackingNumber":"",'+
'              "AdjustedQty":1,'+
'              "PartDescription":"CNR,SPL 287228800",'+
'              "AdjustmentReason":"",'+
'              "RID":"",'+
'              "ClaimedQty":1'+
'            }'+
'          ]'+
'        }'+
'      ],'+
'      "ClaimSource":"BMS",'+
'      "ComplaintCodes":['+
'        {'+
'          "ComplaintCode":999,'+
'          "ComplaintText":"OTHER - SEE TEXT FOR DESCRIPTION"'+
'        }'+
'      ],'+
'      "ECMRevAfter":"",'+
'      "DISDNumber":"",'+
'      "ServiceProviderCode":"04405",'+
'      "Manufacturer":"NEW FLYER",'+
'      "BISFlag":"N",'+
'      "ClaimFiledDate":"05/31/2018 00:00:00",'+
'      "ModelSeries":"D40LF",'+
'      "FailurePoint":26051,'+
'      "CustomerName":"LONDON TRANSIT",'+
'      "Notes":['+
'        {'+
'          "NoteType":"Narrative",'+
'          "Note":"COMPLAINT: TECHNICIAN PROM ID LIST:IV835 A702678",'+
'          "CreatedDate":"05/31/2018"'+
'        },'+
'        {'+
'          "NoteType":"Narrative",'+
'          "Note":"SRO: 99-999 - 2.0 HR TO RE AND RE LARGE REAR BRACKET SUPPORTING THE CHARGER PIPES",'+
'          "CreatedDate":"05/31/2018"'+
'        }'+
'      ],'+
'      "FailureDate":"05/14/2018",'+
'      "EngineVIN":"2FYD4FV168C033588",'+
'      "DistributorName":"EASTERN CANADA - MISSISSAUGA",'+
'      "PSN":60338553,'+
'      "TSRNumber":"",'+
'      "Contact":"JOHN POLICELLI",'+
'      "ECMCalibAfter":"",'+
'      "WorkOrderNumber":87058,'+
'      "UnitNumber":"",'+
'      "ECMCalibBefore":"",'+
'      "FailureMeasure":"Kilometers",'+
'      "WarrantyStartDate":"12/08/2017 00:00:00",'+
'      "EngineApplicationCode":210,'+
'      "DealerClaimNumber":"04405-201801326"'+
'    }'+
'  ]'+
'}';
            }
            
            //callout for siebel claimsdetail
            //res1 = h1.send(req1);
           
            system.debug('jsonResponseBody' + ' ' + jsonResponseBody);
            //jsonResponseBody = '{"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"},"DataArea":[{"ServiceProviderCode":"34234","DistributorCode":"42333","DistributorName":"Cummins Distributor Name","PSN":"2342335","WorkOrderNumber":"ABC45233","WarrantyStartDate":"2012-06-06","EngineApplicationCode":"130","Manufacturer":"KENWORTH","ModelSeries":"T300","Contact":"FirstName LastName","BISFlag":"N","FailureDate":"2012-06-06","FailurePoint":2323,"FailureMeasure":"Miles","DISDNumber":"23423","CustomerName":"ABZ Tavels","EngineVIN":"234msdflo303jfp3ed","TSRNumber":"234434","UnitNumber":"D234","DealerClaimNumber":"C453453245","ClaimSource":"MX","ClaimFiledDate":"2017-06-06","ECMCalibAfter":"23423","ECMCalibBefore":"234234","ECMRevBfr":"34234","ECMRevAfter":"23423","FailureList":[{"SystemCode":"BS","ComponentCode":"HS","FailMode":"BR","Failurename":"Turbo Charger","CampaignNumber":"C24523","FaultCode":"125","AccountCode":"67","PayCode":"I","PartsList":[{"PartNumber":"345345","PartDescription":"PartName1","ClaimedQty":"2","AdjustedQty":"1","TrackingNumber":"23456232346","RID":"34234","AdjustmentReason":"Quantity used as not covered"},{"PartNumber":"77886","PartDescription":"PartName2","ClaimedQty":"1","AdjustedQty":"1","TrackingNumber":"3245345345","RID":"34534","AdjustmentReason":"Reason Description"}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":"","AdjustedAmount":"","AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":"","AdjustedAmount":"","AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":"","ClaimedQty":"","ClaimedPercent":"","ClaimedHours":"","AdjustedQty":"","AdjustedPercent":"","AdjustedHours":"","AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":"","ClaimedQty":"","ClaimedPercent":"","ClaimedHours":"","AdjustedQty":"","AdjustedPercent":"","AdjustedHours":"","AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":"","ClaimedHours":"","ClaimedAmount":"","AdjustedDistance":"","AdjustedHours":"","AdjustedAmount":"","LodgingAmount":"","MealsAmount":"","TowingAmount":"","LaborAmount":"","TravelAmount":"","TotalTravel":"","BaseFare":"","AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":""},{"TravelType":"","ClaimedDistance":"","ClaimedHours":"","ClaimedAmount":"","AdjustedDistance":"","AdjustedHours":"","AdjustedAmount":"","LodgingAmount":"","MealsAmount":"","TowingAmount":"","LaborAmount":"","TravelAmount":"","TotalTravel":"","BaseFare":"","AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":""}]},{"SystemCode":"CR","ComponentCode":"JH","FailMode":"UH","Failurename":"Aftermarket assembly","CampaignNumber":"C86666","FaultCode":"563","AccountCode":"51","PayCode":"D","PartsList":[{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""},{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":"","AdjustedAmount":"","AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":"","AdjustedAmount":"","AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":"","ClaimedQty":"","ClaimedPercent":"","ClaimedHours":"","AdjustedQty":"","AdjustedPercent":"","AdjustedHours":"","AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":"","ClaimedQty":"","ClaimedPercent":"","ClaimedHours":"","AdjustedQty":"","AdjustedPercent":"","AdjustedHours":"","AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":"","ClaimedHours":"","ClaimedAmount":"","AdjustedDistance":"","AdjustedHours":"","AdjustedAmount":"","LodgingAmount":"","MealsAmount":"","TowingAmount":"","LaborAmount":"","TravelAmount":"","TotalTravel":"","BaseFare":"","AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":""},{"TravelType":"","ClaimedDistance":"","ClaimedHours":"","ClaimedAmount":"","AdjustedDistance":"","AdjustedHours":"","AdjustedAmount":"","LodgingAmount":"","MealsAmount":"","TowingAmount":"","LaborAmount":"","TravelAmount":"","TotalTravel":"","BaseFare":"","AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":""}]}],"AdditionalESNs":[{"PSN":"","WarrantyStartDate":"","BISFlag":"","FailurePoint":"","FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""},{"PSN":"","WarrantyStartDate":"","BISFlag":"","FailurePoint":"","FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""}],"Notes":[{"Note":"","NoteType":"","CreatedDate":""},{"Note":"","NoteType":"","CreatedDate":""}],"ComplaintCodes":[{"ComplaintCode":"","ComplaintText":""},{"ComplaintCode":"","ComplaintText":""}]}]}';
            //            jsonResponseBody = '{"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"},"DataArea":[{"ServiceProviderCode":"34234","DistributorCode":"42333","DistributorName":"Cummins Distributor Name","PSN":"2342335","WorkOrderNumber":"ABC45233","WarrantyStartDate":"2012-06-06","EngineApplicationCode":"130","Manufacturer":"KENWORTH","ModelSeries":"T300","Contact":"FirstName LastName","BISFlag":"N","FailureDate":"2012-06-06","FailurePoint":2323,"FailureMeasure":"Miles","DISDNumber":"23423","CustomerName":"ABZ Tavels","EngineVIN":"234msdflo303jfp3ed","TSRNumber":"234434","UnitNumber":"D234","DealerClaimNumber":"C453453245","ClaimSource":"MX","ClaimFiledDate":"2017-06-06","ECMCalibAfter":"23423","ECMCalibBefore":"234234","ECMRevBfr":"34234","ECMRevAfter":"23423","FailureList":[{"SystemCode":"BS","ComponentCode":"HS","FailMode":"BR","Failurename":"Turbo Charger","CampaignNumber":"C24523","FaultCode":"125","AccountCode":"67","PayCode":"I","PartsList":[{"PartNumber":"345345","PartDescription":"PartName1","ClaimedQty":"2","AdjustedQty":"1","TrackingNumber":"23456232346","RID":"34234","AdjustmentReason":"Quantity used as not covered"},{"PartNumber":"77886","PartDescription":"PartName2","ClaimedQty":"1","AdjustedQty":"1","TrackingNumber":"3245345345","RID":"34534","AdjustmentReason":"Reason Description"}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":"","ClaimedHours":"","ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":"","AdjustedAmount":"","LodgingAmount":"","MealsAmount":"","TowingAmount":"","LaborAmount":"","TravelAmount":"","TotalTravel":"","BaseFare":"","AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":"","ClaimedHours":"","ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":"","AdjustedAmount":"","LodgingAmount":"","MealsAmount":"","TowingAmount":"","LaborAmount":"","TravelAmount":"","TotalTravel":"","BaseFare":"","AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]},{"SystemCode":"CR","ComponentCode":"JH","FailMode":"UH","Failurename":"Aftermarket assembly","CampaignNumber":"C86666","FaultCode":"563","AccountCode":"51","PayCode":"D","PartsList":[{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""},{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":"","ClaimedHours":"","ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":"","AdjustedAmount":"","LodgingAmount":"","MealsAmount":"","TowingAmount":"","LaborAmount":"","TravelAmount":"","TotalTravel":"","BaseFare":"","AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":"","ClaimedHours":"","ClaimedAmount":"","AdjustedDistance":"","AdjustedHours":"","AdjustedAmount":"","LodgingAmount":"","MealsAmount":"","TowingAmount":"","LaborAmount":"","TravelAmount":"","TotalTravel":"","BaseFare":"","AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]}],"AdditionalESNs":[{"PSN":"","WarrantyStartDate":"","BISFlag":"","FailurePoint":"","FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""},{"PSN":"","WarrantyStartDate":"","BISFlag":"","FailurePoint":"","FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""}],"Notes":[{"Note":"","NoteType":"","CreatedDate":""},{"Note":"","NoteType":"","CreatedDate":""}],"ComplaintCodes":[{"ComplaintCode":"","ComplaintText":""},{"ComplaintCode":"","ComplaintText":""}]}]}';
            //jsonResponseBody = '{"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"},"DataArea":[{"ServiceProviderCode":"34234","DistributorCode":"42333","DistributorName":"Cummins Distributor Name","PSN":"2342335","WorkOrderNumber":"ABC45233","WarrantyStartDate":"2012-06-06","EngineApplicationCode":"130","Manufacturer":"KENWORTH","ModelSeries":"T300","Contact":"FirstName LastName","BISFlag":"N","FailureDate":"2012-06-06","FailurePoint":2323,"FailureMeasure":"Miles","DISDNumber":"23423","CustomerName":"ABZ Tavels","EngineVIN":"234msdflo303jfp3ed","TSRNumber":"234434","UnitNumber":"D234","DealerClaimNumber":"C453453245","ClaimSource":"MX","ClaimFiledDate":"2017-06-06","ECMCalibAfter":"23423","ECMCalibBefore":"234234","ECMRevBfr":"34234","ECMRevAfter":"23423","FailureList":[{"SystemCode":"BS","ComponentCode":"HS","FailMode":"BR","Failurename":"Turbo Charger","CampaignNumber":"C24523","FaultCode":"125","AccountCode":"67","PayCode":"I","PartsList":[{"PartNumber":"345345","PartDescription":"PartName1","ClaimedQty":"2","AdjustedQty":"1","TrackingNumber":"23456232346","RID":"34234","AdjustmentReason":"Quantity used as not covered"},{"PartNumber":"77886","PartDescription":"PartName2","ClaimedQty":"1","AdjustedQty":"1","TrackingNumber":"3245345345","RID":"34534","AdjustmentReason":"Reason Description"}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]},{"SystemCode":"CR","ComponentCode":"JH","FailMode":"UH","Failurename":"Aftermarket assembly","CampaignNumber":"C86666","FaultCode":"563","AccountCode":"51","PayCode":"D","PartsList":[{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""},{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]}],"AdditionalESNs":[{"PSN":"","WarrantyStartDate":"","BISFlag":"","FailurePoint":"","FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""},{"PSN":"","WarrantyStartDate":"","BISFlag":"","FailurePoint":"","FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""}],"Notes":[{"Note":"","NoteType":"","CreatedDate":""},{"Note":"","NoteType":"","CreatedDate":""}],"ComplaintCodes":[{"ComplaintCode":"","ComplaintText":""},{"ComplaintCode":"","ComplaintText":""}]}]}';
            //jsonResponseBody = '{"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"},"DataArea":[{"ServiceProviderCode":"34234","DistributorCode":"42333","DistributorName":"Cummins Distributor Name","PSN":"2342335","WorkOrderNumber":"ABC45233","WarrantyStartDate":"2012-06-06","EngineApplicationCode":"130","Manufacturer":"KENWORTH","ModelSeries":"T300","Contact":"FirstName LastName","BISFlag":"N","FailureDate":"2012-06-06","FailurePoint":2323,"FailureMeasure":"Miles","DISDNumber":"23423","CustomerName":"ABZ Tavels","EngineVIN":"234msdflo303jfp3ed","TSRNumber":"234434","UnitNumber":"D234","DealerClaimNumber":"C453453245","ClaimSource":"MX","ClaimFiledDate":"2017-06-06","ECMCalibAfter":"23423","ECMCalibBefore":"234234","ECMRevBfr":"34234","ECMRevAfter":"23423","FailureList":[{"SystemCode":"BS","ComponentCode":"HS","FailMode":"BR","Failurename":"Turbo Charger","CampaignNumber":"C24523","FaultCode":"125","AccountCode":"67","PayCode":"I","PartsList":[{"PartNumber":"345345","PartDescription":"PartName1","ClaimedQty":"2","AdjustedQty":"1","TrackingNumber":"23456232346","RID":"34234","AdjustmentReason":"Quantity used as not covered"},{"PartNumber":"77886","PartDescription":"PartName2","ClaimedQty":"1","AdjustedQty":"1","TrackingNumber":"3245345345","RID":"34534","AdjustmentReason":"Reason Description"}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]},{"SystemCode":"CR","ComponentCode":"JH","FailMode":"UH","Failurename":"Aftermarket assembly","CampaignNumber":"C86666","FaultCode":"563","AccountCode":"51","PayCode":"D","PartsList":[{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""},{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]}],"AdditionalESNs":[{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""},{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""}],"Notes":[{"Note":"","NoteType":"","CreatedDate":"2012-06-06"},{"Note":"","NoteType":"","CreatedDate":"2012-06-06"}],"ComplaintCodes":[{"ComplaintCode":"","ComplaintText":""},{"ComplaintCode":"","ComplaintText":""}]}]}';

            //  jsonResponseBody = '{"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"},"DataArea":[{"ServiceProviderCode":"12345","DistributorCode":"12345","DistributorName":"Cummins Distributor Name","PSN":"2342335","WorkOrderNumber":"ABC45233","WarrantyStartDate":"2012-06-06","EngineApplicationCode":"130","Manufacturer":"KENWORTH","ModelSeries":"T300","Contact":"FirstName LastName","BISFlag":"N","FailureDate":"2012-06-06","FailurePoint":2323,"FailureMeasure":"Miles","DISDNumber":"23423","CustomerName":"ABZ Tavels","EngineVIN":"234msdflo303jfp3ed","TSRNumber":"234434","UnitNumber":"D234","DealerClaimNumber":"C453453245","ClaimSource":"MX","ClaimFiledDate":"2017-06-06","ECMCalibAfter":"23423","ECMCalibBefore":"234234","ECMRevBfr":"34234","ECMRevAfter":"23423","FailureList":[{"SystemCode":"BS","ComponentCode":"HS","FailMode":"BR","Failurename":"Turbo Charger","CampaignNumber":"C24523","FaultCode":"125","AccountCode":"67","PayCode":"I","PartsList":[{"PartNumber":"345345","PartDescription":"PartName1","ClaimedQty":"2","AdjustedQty":"1","TrackingNumber":"23456232346","RID":"34234","AdjustmentReason":"Quantity used as not covered"},{"PartNumber":"77886","PartDescription":"PartName2","ClaimedQty":"1","AdjustedQty":"1","TrackingNumber":"3245345345","RID":"34534","AdjustmentReason":"Reason Description"}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]},{"SystemCode":"CR","ComponentCode":"JH","FailMode":"UH","Failurename":"Aftermarket assembly","CampaignNumber":"C86666","FaultCode":"563","AccountCode":"51","PayCode":"D","PartsList":[{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""},{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]}],"AdditionalESNs":[{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""},{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""}],"Notes":[{"Note":"TestComplaint","NoteType":"Complaint","CreatedDate":"2012-06-06"},{"Note":"TestCause","NoteType":"Cause","CreatedDate":"2012-06-06"}],"ComplaintCodes":[{"ComplaintCode":"","ComplaintText":""},{"ComplaintCode":"","ComplaintText":""}]}]}';

            //jsonResponseBody = '{"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"},"DataArea":[{"ServiceProviderCode":"12345","DistributorCode":"12345","DistributorName":"Cummins Distributor Name","PSN":"79464646","WorkOrderNumber":"123","WarrantyStartDate":"2012-06-06","EngineApplicationCode":"130","Manufacturer":"KENWORTH","ModelSeries":"T300","Contact":"FirstName LastName","BISFlag":"N","FailureDate":"2012-06-06","FailurePoint":2323,"FailureMeasure":"Miles","DISDNumber":"23423","CustomerName":"ABZ Tavels","EngineVIN":"234msdflo303jfp3ed","TSRNumber":"234434","UnitNumber":"D234","DealerClaimNumber":"C453453245","ClaimSource":"MX","ClaimFiledDate":"2017-06-06","ECMCalibAfter":"23423","ECMCalibBefore":"234234","ECMRevBfr":"34234","ECMRevAfter":"23423","FailureList":[{"SystemCode":"BS","ComponentCode":"HS","FailMode":"BR","Failurename":"Turbo Charger","CampaignNumber":"C24523","FaultCode":"125","AccountCode":"67","PayCode":"I","PartsList":[{"PartNumber":"345345","PartDescription":"PartName1","ClaimedQty":"2","AdjustedQty":"1","TrackingNumber":"23456232346","RID":"34234","AdjustmentReason":"Quantity used as not covered"},{"PartNumber":"77886","PartDescription":"PartName2","ClaimedQty":"1","AdjustedQty":"1","TrackingNumber":"3245345345","RID":"34534","AdjustmentReason":"Reason Description"}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]},{"SystemCode":"CR","ComponentCode":"JH","FailMode":"UH","Failurename":"Aftermarket assembly","CampaignNumber":"C86666","FaultCode":"563","AccountCode":"51","PayCode":"D","PartsList":[{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""},{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]}],"AdditionalESNs":[{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""},{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""}],"Notes":[{"Note":"TestComplaint","NoteType":"Complaint","CreatedDate":"2012-06-06"},{"Note":"TestCause","NoteType":"Cause","CreatedDate":"2012-06-06"}],"ComplaintCodes":[{"ComplaintCode":"Compression leak","ComplaintText":"Compression Leak"},{"ComplaintCode":"","ComplaintText":""}]}]}';
            //jsonResponseBody = '{"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"},"DataArea":[{"ServiceProviderCode":"33508","DistributorCode":"02400","DistributorName":"Cummins Distributor Name","PSN":"79865402","WorkOrderNumber":"ABC45233","WarrantyStartDate":"2012-06-06","EngineApplicationCode":"130","Manufacturer":"KENWORTH","ModelSeries":"T300","Contact":"FirstName LastName","BISFlag":"N","FailureDate":"2012-06-06","FailurePoint":2323,"FailureMeasure":"Miles","DISDNumber":"23423","CustomerName":"ABZ Tavels","EngineVIN":"234msdflo303jfp3ed","TSRNumber":"234434","UnitNumber":"D234","DealerClaimNumber":"C453453245","ClaimSource":"MX","ClaimFiledDate":"2017-06-06","ECMCalibAfter":"23423","ECMCalibBefore":"234234","ECMRevBfr":"34234","ECMRevAfter":"23423","FailureList":[{"SystemCode":"BS","ComponentCode":"HS","FailMode":"BR","Failurename":"Turbo Charger","CampaignNumber":"C24523","FaultCode":"125","AccountCode":"67","PayCode":"I","PartsList":[{"PartNumber":"345345","PartDescription":"PartName1","ClaimedQty":"2","AdjustedQty":"1","TrackingNumber":"23456232346","RID":"34234","AdjustmentReason":"Quantity used as not covered"},{"PartNumber":"77886","PartDescription":"PartName2","ClaimedQty":"1","AdjustedQty":"1","TrackingNumber":"3245345345","RID":"34534","AdjustmentReason":"Reason Description"}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]},{"SystemCode":"CR","ComponentCode":"JH","FailMode":"UH","Failurename":"Aftermarket assembly","CampaignNumber":"C86666","FaultCode":"563","AccountCode":"51","PayCode":"D","PartsList":[{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""},{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]}],"AdditionalESNs":[{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""},{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""}],"Notes":[{"Note":"TestComplaint","NoteType":"Complaint","CreatedDate":"2012-06-06"},{"Note":"TestComplaint1","NoteType":"Complaint","CreatedDate":"2012-06-06"},{"Note":"TestCause","NoteType":"Cause","CreatedDate":"2012-06-06"},{"Note":"TestCause1","NoteType":"Cause","CreatedDate":"2012-06-06"}],"ComplaintCodes":[{"ComplaintCode":"117","ComplaintText":"Testing Complaint1"},{"ComplaintCode":"106","ComplaintText":"Testing complaint2"},{"ComplaintCode":"213","ComplaintText":"Testing complaint3"},{"ComplaintCode":"401","ComplaintText":"Testing complaint4"},{"ComplaintCode":"212","ComplaintText":"Testing complaint5"}]}]}';
            //jsonResponseBody = '{"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"},"DataArea":[{"ServiceProviderCode":"33508","DistributorCode":"02400","DistributorName":"Cummins Distributor Name","PSN":"79865402","WorkOrderNumber":"ABC45233","WarrantyStartDate":"2012-06-06","EngineApplicationCode":"130","Manufacturer":"KENWORTH","ModelSeries":"T300","Contact":"FirstName LastName","BISFlag":"N","FailureDate":"2012-06-06","FailurePoint":2323,"FailureMeasure":"Miles","DISDNumber":"23423","CustomerName":"ABZ Tavels","EngineVIN":"234msdflo303jfp3ed","TSRNumber":"234434","UnitNumber":"D234","DealerClaimNumber":"C453453245","ClaimSource":"MX","ClaimFiledDate":"2017-06-06","ECMCalibAfter":"23423","ECMCalibBefore":"234234","ECMRevBfr":"34234","ECMRevAfter":"23423","FailureList":[{"SystemCode":"BS","ComponentCode":"HS","FailMode":"BR","Failurename":"Turbo Charger","CampaignNumber":"C24523","FaultCode":"125","AccountCode":"67","PayCode":"I","PartsList":[{"PartNumber":"345345","PartDescription":"PartName1","ClaimedQty":"2","AdjustedQty":"1","TrackingNumber":"23456232346","RID":"34234","AdjustmentReason":"Quantity used as not covered"},{"PartNumber":"77886","PartDescription":"PartName2","ClaimedQty":"1","AdjustedQty":"1","TrackingNumber":"3245345345","RID":"34534","AdjustmentReason":"Reason Description"}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]},{"SystemCode":"CR","ComponentCode":"JH","FailMode":"UH","Failurename":"Aftermarket assembly","CampaignNumber":"C86666","FaultCode":"563","AccountCode":"51","PayCode":"D","PartsList":[{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""},{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]}],"AdditionalESNs":[{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""},{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""}],"Notes":[{"Note":"TestComplaint","NoteType":"Complaint","CreatedDate":"2012-06-06"},{"Note":"TestComplaint1","NoteType":"Complaint","CreatedDate":"2012-06-06"},{"Note":"TestCause","NoteType":"Cause","CreatedDate":"2012-06-06"},{"Note":"TestCause1","NoteType":"Cause","CreatedDate":"2012-06-06"}],"ComplaintCodes":[{"ComplaintCode":"117","ComplaintText":"Testing Complaint1"}]}]}';
            // jsonResponseBody = '{"Header":{"ReturnCodeDescription":"<Message from Siebel>","Status":"Success","ReturnCode":"<MessageCode from Siebel>","MessageIdentifier":"<Identifier from MW>"},"DataArea":[{"ServiceProviderCode":"34234","DistributorCode":"42333","DistributorName":"Cummins Distributor Name","PSN":"2342335","WorkOrderNumber":"ABC45233","WarrantyStartDate":"2012-06-06","EngineApplicationCode":"130","Manufacturer":"KENWORTH","ModelSeries":"T300","Contact":"FirstName LastName","BISFlag":"N","FailureDate":"2012-06-06","FailurePoint":2323,"FailureMeasure":"Miles","DISDNumber":"23423","CustomerName":"ABZ Tavels","EngineVIN":"234msdflo303jfp3ed","TSRNumber":"234434","UnitNumber":"D234","DealerClaimNumber":"C453453245","ClaimSource":"MX","ClaimFiledDate":"2017-06-06","ECMCalibAfter":"23423","ECMCalibBefore":"234234","ECMRevBfr":"34234","ECMRevAfter":"23423","FailureList":[{"SystemCode":"BS","ComponentCode":"HS","FailMode":"BR","Failurename":"Turbo Charger","CampaignNumber":"C24523","FaultCode":"125","AccountCode":"67","PayCode":"I","PartsList":[{"PartNumber":"345345","PartDescription":"PartName1","ClaimedQty":"2","AdjustedQty":"1","TrackingNumber":"23456232346","RID":"34234","AdjustmentReason":"Quantity used as not covered"},{"PartNumber":"77886","PartDescription":"PartName2","ClaimedQty":"1","AdjustedQty":"1","TrackingNumber":"3245345345","RID":"34534","AdjustmentReason":"Reason Description"}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]},{"SystemCode":"CR","ComponentCode":"JH","FailMode":"UH","Failurename":"Aftermarket assembly","CampaignNumber":"C86666","FaultCode":"563","AccountCode":"51","PayCode":"D","PartsList":[{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""},{"PartNumber":"","PartDescription":"","ClaimedQty":"","AdjustedQty":"","TrackingNumber":"","RID":"","AdjustmentReason":""}],"OtherClaimablesList":[{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""},{"Item":"","ItemDescription":"","ClaimedAmount":1,"AdjustedAmount":2,"AdjustmentReason":""}],"SRTList":[{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""},{"SRTCode":"","SRTDescription":"","SRTHours":1,"ClaimedQty":1,"ClaimedPercent":1,"ClaimedHours":1,"AdjustedQty":1,"AdjustedPercent":1,"AdjustedHours":1,"AdjustmentReason":"","PenaltyAppliedFlag":""}],"TravelList":[{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1},{"TravelType":"","ClaimedDistance":1,"ClaimedHours":1,"ClaimedAmount":1,"AdjustedDistance":2,"AdjustedHours":1,"AdjustedAmount":1,"LodgingAmount":1,"MealsAmount":1,"TowingAmount":1,"LaborAmount":1,"TravelAmount":1,"TotalTravel":1,"BaseFare":1,"AdjustmentReason":"","PenaltyAppliedFlag":"","AdjustedPercent":1}]}],"AdditionalESNs":[{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""},{"PSN":"","WarrantyStartDate":"2012-06-06","BISFlag":"","FailurePoint":12,"FailureMeasure":"","VIN":"","ECMCalibAfter":"","ECMCalibBefore":"","ECMRevBfr":"","ECMRevAfter":""}],"Notes":[{"Note":"TestComplaint","NoteType":"Complaint","CreatedDate":"2012-06-06 00:00:00"},{"Note":"TestComplaint1","NoteType":"Complaint","CreatedDate":"2012-06-07 00:00:00"},{"Note":"TestCause","NoteType":"Cause","CreatedDate":"2012-06-10 00:00:00"},{"Note":"TestCause1","NoteType":"Cause","CreatedDate":"2012-06-09 00:00:00"}],"ComplaintCodes":[{"ComplaintCode":"","ComplaintText":""},{"ComplaintCode":"","ComplaintText":""}]}]}';
            //  jsonResponseBody = '{"Header": {"ReturnCodeDescription": "<Message from Siebel>","Status": "Success","ReturnCode": "<MessageCode from Siebel>","MessageIdentifier": "<Identifier from MW>" },"DataArea": ["Notes": [{"Note": "TestComplaint","NoteType": "Complaint","CreatedDate": "2012-06-06"},{"Note": "TestComplaint1","NoteType":"Complaint","CreatedDate":"2012-06-07"},{"Note": "TestCause","NoteType": "Cause","CreatedDate": "2013-06-10"},{"Note": "TestCorrection1","NoteType": "Correction","CreatedDate": "2014-06-09"},{"Note": "TestComplaint","NoteType": "Reject Reason","CreatedDate": "2015-06-06"},{"Note": "TestComplaint1","NoteType": "Narratives","CreatedDate": "2016-06-07"},{"Note": "NarrativesTest","NoteType": "Narratives","CreatedDate": "2017-06-10"},{"Note": "RejectTest reason","NoteType": "Cause","CreatedDate": "2018-06-09"}]}}';
            cresWrap = (CSS_GetClaimDetailsResponse )JSON.deserialize(jsonResponseBody,CSS_GetClaimDetailsResponse.class);

            system.debug('cresWrap >>>' + '     ' + cresWrap);

        }
        catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getMessage*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                cresWrap = null;
            }
        }
        return cresWrap;
    }
}