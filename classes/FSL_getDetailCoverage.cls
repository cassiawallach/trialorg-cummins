/*************************************************************************************
Name:FSL_getDetailCoverage
Copyright © 2019  Cummins
=======================================================================================
=======================================================================================
Purpose:                                                            
------- This class is used for updating Account Code based on Campagin number and to
Check Coverage based on System Code & Component Code 
=========================================================================================
=========================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   Sriprada Sesham    5/30/2019       INITIAL DEVELOPMENT      
2.0     karthik Gorantla  09/2/2020          Mule Api migration
3.0     Diksha Rajpurohit   7/12/2022       Migration to Named Credentials for getCoverage
****************************************************************************************/
public class FSL_getDetailCoverage {
    
    Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
    Static String executionLog = 'Log Start';
    
    @future (callout=true)
    public static void getSolutionCoverage(string solId) {
        system.debug(' Sol Id : '+solID);
        List<CSS_Solution_Component__c> listSolComp = new List<CSS_Solution_Component__c>();
        listSolComp = [SELECT Id, Component_Id__c, System_Code__c, Solutions__c, Solutions__r.FaultCode__r.Name, 
                       Parts_Warranty__c, CSS_CoverageType__c, FSL_Account_Code__c, Component_Code__c, AccountCode__c, 
                       FSL_Service_Job__c, FSL_Service_Job__r.ServiceTerritory.Location_Code__c, 
                       FSL_Service_Job__r.Application__c, FSL_Service_Job__r.Asset.Name,FSL_Service_Job__r.Asset.Recon_Engine_Flag__c,
                       FSL_Service_Job__r.Failure_Date__c, FSL_Service_Job__r.Mileage__c, 
                       FSL_Service_Job__r.Mileage_Measure__c, FSL_Service_Job__r.Warranty_Start_Date__c 
                       FROM CSS_Solution_Component__c WHERE Id =: solId];
        system.debug('listSolComp' + listSolComp);
        FSL_DetailCoverageReqWrapper reqObj = new FSL_DetailCoverageReqWrapper();
        list<FSL_DetailCoverageReqWrapper.Details> detailsList = new list<FSL_DetailCoverageReqWrapper.Details>();
        if(listSolComp.size() > 0) {
            string appVal = listSolComp[0].FSL_Service_Job__r.Application__c;
            string tCode = listSolComp[0].FSL_Service_Job__r.ServiceTerritory.Location_Code__c;
            DateTime wsd = listSolComp[0].FSL_Service_Job__r.Warranty_Start_Date__c;
            String wsDate = wsd <> null ? wsd.format('MM/dd/yyyy') : '';
            String Measure = listSolComp[0].FSL_Service_Job__r.Mileage_Measure__c;
            String MileageMeasure;
            DateTime fD = listSolComp[0].FSL_Service_Job__r.Failure_Date__c;
            String fDate;
            Boolean ReconFlag = listSolComp[0].FSL_Service_Job__r.Asset.Recon_Engine_Flag__c;
            system.debug('Asset RPWFlag:'+ReconFlag);
            String RPWFlag;
            if(fD != null) {
                fDate = fD.format('MM/dd/yyyy');
            }
            else {
                fDate = '';
            }
            if(Measure == 'KILOMETERS'){
                MileageMeasure = 'Kilometers';
            } else if(Measure == 'MILES'){
                MileageMeasure = 'Miles';
            }
            if(ReconFlag == true)
            {
                RPWFlag = 'Y';
            } 
            else{
                RPWFlag = 'N';
            }
            
            for(CSS_Solution_Component__c sols : listSolComp) {
                FSL_DetailCoverageReqWrapper.Details detailObj = new FSL_DetailCoverageReqWrapper.Details ();
                detailObj.ComponentCode = (sols.Component_Code__c != null)? sols.Component_Code__c :'';
                system.debug('System Code is:'+ detailObj.ComponentCode);
                detailObj.SystemCode = (sols.System_Code__c != null)? sols.System_Code__c :'';
                detailsList.add(detailObj);
            }
            reqObj.DataArea.Details = detailsList;
            reqObj.DataArea.WarrantyStartDate = (wsDate != null)? wsDate : '';
            reqObj.DataArea.FailureDate = fDate;
            reqObj.DataArea.FailurePoint = (listSolComp[0].FSL_Service_Job__r.Mileage__c != null)? string.valueOf(listSolComp[0].FSL_Service_Job__r.Mileage__c) : '';
            reqObj.DataArea.FailureMeasure = (listSolComp[0].FSL_Service_Job__r.Mileage_Measure__c != null)? MileageMeasure : '';
            reqObj.DataArea.Esn = (listSolComp[0].FSL_Service_Job__r.Asset.Name != null)? listSolComp[0].FSL_Service_Job__r.Asset.Name : '';
            // reqObj.DataArea.CampaignNumber = (listSolComp[0].Component_Id__c != null)? listSolComp[0].Component_Id__c : '';
            reqObj.DataArea.SPCode = (tCode != null)? tCode.substringAfter('-').substring(0,5) : '';
            reqObj.DataArea.EngineApplicationCode = (appVal != null)? appVal.substring(0,3) : '';
            reqObj.DataArea.RoadRelayWrntyFlg = 'N';
            reqObj.DataArea.ReconPartsWrntyFlg = RPWFlag;
            reqObj.DataArea.NewPartsWrntyFlg = 'N';
            reqObj.DataArea.AccountCode = (listSolComp[0].AccountCode__c != null)? listSolComp[0].AccountCode__c : '';
            // reqObj.DataArea.AccountCode = '';
            reqObj.DataArea.FaultCode = (listSolComp[0].Solutions__r.FaultCode__r.Name != null)? listSolComp[0].Solutions__r.FaultCode__r.Name : '';
            // reqObj.DataArea.CampaignNumber = (listSolComp[0].Component_Id__c != null)? listSolComp[0].Component_Id__c :'';
            FSL_DetailCoverageReqWrapper.Details detailObj = new FSL_DetailCoverageReqWrapper.Details();
            // system.debug('System Code is:'+detailObj.SystemCode);
            if(reqObj.DataArea.Details.size() > 0 && reqObj.DataArea.Details[0].SystemCode != '' && reqObj.DataArea.Details[0].ComponentCode != '')
            {
                reqObj.DataArea.CampaignNumber = '';
            }
            else
            {
                reqObj.DataArea.CampaignNumber = (listSolComp[0].Component_Id__c != null)? listSolComp[0].Component_Id__c : '';
            }
            string jsonRre = json.serialize(reqObj);
            // jsonRre = jsonRre.replaceAll('":null', '": ');
            string jsonRes = getCoverageConnection(jsonRre);
            system.debug('Response is:'+jsonRes);
            responseHandler(jsonRes,solId);
            /* CSS_Solution_Component__c obj = new CSS_Solution_Component__c();
obj.Id = 'a0r1D000000KOOQQA4';
obj.ODM_Status_Message__c = jsonRre;
update obj;*/
        }               
    }
    
    public static string getCoverageConnection(string jsonReq) {
        FSL_IP_NamedCredentialWrapper requestWrapper = new FSL_IP_NamedCredentialWrapper();
        requestWrapper.NamedCredential = 'FSL_NC_Warranty';
        requestWrapper.Path = '/v1/coverage/account';
        requestWrapper.jsonReqBody = jsonReq;
        requestWrapper.methodType = 'POST';
        
        CG_OP_OAGWrapper responseWrapper = FSL_WS_Mule.calloutNamedCredentials(requestWrapper);
        if(responseWrapper.exceptionFlag){
            System.debug('Inside FSL_getDetailCoverage, request failed with endpoint :: '+ responseWrapper.endPoint);
            System.debug('Inside FSL_getDetailCoverage, request failed with exception :: '+ responseWrapper.exceptionMessage);
            throw new CalloutException(responseWrapper.exceptionMessage);
        }
        HttpResponse httpRes = responseWrapper.response;
        string response = httpRes.getBody();
        system.debug('response body: ' + httpRes.getBody());
        return response;
    }
    
    public static void responseHandler(String resBody,string solID) {
        list<FSL_Account_Code__c> listAccCode = new list<FSL_Account_Code__c>();
        FSL_DetailCoverageResWrapper obj = (FSL_DetailCoverageResWrapper)JSON.deserializeStrict(resBody,FSL_DetailCoverageResWrapper.class);
        
        if(obj != null && obj.Header.Status == 'Success' && obj.DataArea != null && obj.DataArea.Details.size()>0 && string.isNotBlank(solID))
        {
            string accountCode = '%'+obj.DataArea.AccountCode ;
            listAccCode= [select id,Account_Code_Description__c,Coverage_Type__c,Name from FSL_Account_Code__c where name like: accountCode];
            // system.debug('Account Code is:' + listAccCode.Name);
            CSS_Solution_Component__c sc        =   new CSS_Solution_Component__c();
            sc.id                               =   solID;
            sc.DeductibleAmount__c              =   obj.DataArea.Details[0].DeductibleAmount;
            sc.CampaignTravelPercentage__c      =   obj.DataArea.Details[0].CampaignTravelPercentage;
            // sc.Status__c                        =   obj.DataArea.Details[0].Status;
            sc.CampaignPartsPercentage__c       =   obj.DataArea.Details[0].CampaignPartsPercentage;
            sc.Component_Code__c                =   obj.DataArea.Details[0].ComponentCode;
            sc.System_Code__c                   =   obj.DataArea.Details[0].SystemCode;
            sc.CampaignLaborPercentage__c       =   obj.DataArea.Details[0].CampaignLaborPercentage;
            sc.CoveredTowingMiles__c            =   obj.DataArea.Details[0].CoveredTowingMiles;
            sc.CoveredTravelMiles__c            =   obj.DataArea.Details[0].CoveredTravelMiles;
            sc.WarrantyId__c                    =   obj.DataArea.Details[0].WarrantyId;
            sc.CoveredMealsLodgingAmt__c        =   obj.DataArea.Details[0].CoveredMealsLodgingAmt;
            sc.CoveredLaborHrs__c               =   obj.DataArea.Details[0].CoveredLaborHrs;
            sc.CampaignOCPercentage__c          =   obj.DataArea.Details[0].CampaignOCPercentage;
            sc.CoveredTravelLabor__c            =   obj.DataArea.Details[0].CoveredTravelLabor;
            sc.CampaignTowingPercentage__c      =   obj.DataArea.Details[0].CampaignTowingPercentage;
            sc.CertificateNumber__c             =   obj.DataArea.Details[0].CertificateNumber;
            sc.CoveredOCAmount__c               =   obj.DataArea.Details[0].CoveredOCAmount;
            sc.CoveredPartsQty__c               =   obj.DataArea.Details[0].CoveredPartsQty;
            sc.CoveredTravelBaseFareAmt__c      =   obj.DataArea.Details[0].CoveredTravelBaseFareAmt;
            sc.AccountCodeType__c               =   obj.DataArea.AccountCodeType;
            // sc.AccountCode__c                   =   obj.DataArea.AccountCode ;
            
            if(listAccCode.size()>0)
            {
                sc.Account_Code__c =listAccCode[0].Id;
            }
            system.debug('Account Code:'+sc.Account_Code__c);
            if(sc.Account_Code__c != null) {
                sc.FSL_Account_Code__c = listAccCode[0].name;
                sc.CSS_CoverageType__c = listAccCode[0].Coverage_Type__c;
            }
            // listAccCode[0].name = obj.DataArea.AccountCode;
            update sc; // Update instance
            system.debug('Account code is:'+obj.DataArea.AccountCode);
        }
    }
    
    public static string checkCoverage(CSS_Solution_Component__c solCmp) {
        system.debug('Sol Cmp:'+solcmp);
        String msg;
        List<FSL_Account_Code__c> listAccCode = new List<FSL_Account_Code__c>();
        List<WorkOrder> listSOs = new List<WorkOrder>();
        FSL_DetailCoverageReqWrapper reqObj = new FSL_DetailCoverageReqWrapper();
        List<FSL_DetailCoverageReqWrapper.Details> detailsList = new List<FSL_DetailCoverageReqWrapper.Details>();
        
        if(solCmp != null) {
            String appVal = solCmp.FSL_Service_Job__r.Application__c;
            String tCode = solCmp.FSL_Service_Job__r.ServiceTerritory.Location_Code__c;
            String accCode = '';
            // if(String.isNotBlank(solCmp.Account_Code__c)) {
            String Measure = solCmp.FSL_Service_Job__r.Mileage_Measure__c;
            String MileageMeasure;
            if(Measure == 'KILOMETERS'){
                MileageMeasure = 'Kilometers';
            } else if(Measure == 'MILES'){
                MileageMeasure = 'Miles';
            }
            listAccCode = [SELECT Id, Name FROM FSL_Account_Code__c WHERE name =: solCmp.FSL_Account_Code__c];
            listSOs = [SELECT Id, WorkOrderNumber, Asset.Name, Asset.Recon_Engine_Flag__c FROM WorkOrder WHERE Id =: solCmp.FSL_Service_Job__c];
            if(listAccCode.size() > 0) {
                accCode = listAccCode[0].Name;
                accCode = accCode.right(2);
                system.debug('accCode :'+accCode);
            } 
            // }
            
            FSL_DetailCoverageReqWrapper.Details detailObj = new FSL_DetailCoverageReqWrapper.Details();
            // DateTime partsWSD = solCmp.Part_Warranty_Start_Date__c;
            // String wsDate = partsWSD.format('MM/dd/yyyy');
            
            detailObj.ComponentCode = (solCmp.Component_Code__c != null) ? solCmp.Component_Code__c : '';
            system.debug('System Code is:'+ detailObj.ComponentCode);
            detailObj.SystemCode = (solCmp.System_Code__c != null) ? solCmp.System_Code__c : '';
            detailsList.add(detailObj);
            reqObj.DataArea.Details = detailsList;
            reqObj.DataArea.FailureMeasure = (solCmp.FSL_Service_Job__r.Mileage_Measure__c != null) ? MileageMeasure : '';
            // reqObj.DataArea.FailureMeasure = (solCmp.FSL_Service_Job__r.Mileage_Measure__c != null) ? solCmp.FSL_Service_Job__r.Mileage_Measure__c : '';
            reqObj.DataArea.Esn = (solCmp.FSL_Service_Job__r.Asset.Name != null) ? solCmp.FSL_Service_Job__r.Asset.Name : '';
            // reqObj.DataArea.CampaignNumber = (solCmp.Component_Id__c != null) ? solCmp.Component_Id__c : '';
            reqObj.DataArea.SPCode = (tCode != null) ? tCode.substringAfter('-').substring(0,5) : '';
            reqObj.DataArea.EngineApplicationCode = (appVal != null) ? appVal.substring(0,3) : '';
            Boolean ReconFlag = listSOs[0].Asset.Recon_Engine_Flag__c;
            system.debug('RPWFlagInAsset:'+ReconFlag);
            system.debug('Asset Name:'+solCmp.FSL_Service_Job__r.Asset.Name);
            
            String RPWFlag;
            if(ReconFlag == true){
                RPWFlag = 'Y';
                system.debug('RPWFlagInAsset:'+RPWFlag);
            } else{
                RPWFlag = 'N';
            }
            Datetime warrantyDate = solCmp.FSL_Service_Job__r.Warranty_Start_Date__c;
            String dateOutput;
            if(warrantyDate != null){
                dateOutput = warrantyDate.format('MM/dd/yyyy');
            } else{
                dateOutput = '';
            }
            
            Datetime warrantyDate1 = solCmp.Part_Warranty_Start_Date__c;
            String dateOutput1;
            if(warrantyDate1 != null){
                dateOutput1 = warrantyDate1.format('MM/dd/yyyy');
                system.debug('WSD:'+ dateOutput1);
            }else{
                dateOutput1 = '';
            }
            
            DateTime failD = solCmp.Failure_Date__c;
            String failDate;
            if(failD != null) {
                failDate = failD.format('MM/dd/yyyy');
            }
            else {
                failDate = '';
            }
            
            DateTime fDt = solCmp.FSL_Service_Job__r.Failure_Date__c;
            String failDt;
            if(fDt != null) {
                failDt = fDt.format('MM/dd/yyyy');
            }
            else {
                failDt = '';
            }
            if(accCode.contains('62') || accCode.contains('35')) {
                reqObj.DataArea.NewPartsWrntyFlg = 'Y';
                reqObj.DataArea.ReconPartsWrntyFlg = 'N';
                reqObj.DataArea.WarrantyStartDate = dateOutput1;
                //  reqObj.DataArea.WarrantyStartDate = (solCmp.Part_Warranty_Start_Date__c != null) ? string.valueOf(solCmp.Part_Warranty_Start_Date__c.format()) : '';
                reqObj.DataArea.FailureDate = failDate;
                reqObj.DataArea.FailurePoint = (solCmp.Failure_Point__c != null) ? string.valueOf(solCmp.Failure_Point__c) : '';
            }
            else if(accCode.contains('41') || accCode.contains('97')) {
                reqObj.DataArea.ReconPartsWrntyFlg = 'Y';
                reqObj.DataArea.NewPartsWrntyFlg = 'N';
                reqObj.DataArea.WarrantyStartDate = dateOutput1;
                // reqObj.DataArea.WarrantyStartDate = (solCmp.Part_Warranty_Start_Date__c != null)? string.valueOf(solCmp.Part_Warranty_Start_Date__c.format()) : '';
                reqObj.DataArea.FailureDate = failDate;
                reqObj.DataArea.FailurePoint = (solCmp.Failure_Point__c != null) ? string.valueOf(solCmp.Failure_Point__c) : '';
            }
            else {
                reqObj.DataArea.NewPartsWrntyFlg = 'N';
                reqObj.DataArea.ReconPartsWrntyFlg = RPWFlag;
                system.debug('RPWFlag:'+RPWFlag);
                reqObj.DataArea.WarrantyStartDate = (solCmp.FSL_Service_Job__r.Warranty_Start_Date__c != null) ? dateOutput : '';
                // reqObj.DataArea.WarrantyStartDate = (solCmp.FSL_Service_Job__r.Warranty_Start_Date__c != null) ? string.valueOf(solCmp.FSL_Service_Job__r.Warranty_Start_Date__c.format()) : '';
                reqObj.DataArea.FailureDate = failDt;
                reqObj.DataArea.FailurePoint = (solCmp.FSL_Service_Job__r.Mileage__c != null) ? string.valueOf(solCmp.FSL_Service_Job__r.Mileage__c):'';
            }
            reqObj.DataArea.RoadRelayWrntyFlg = 'N';
            // reqObj.DataArea.AccountCode = (solCmp.AccountCode__c != null) ? solCmp.AccountCode__c : '';
            reqObj.DataArea.AccountCode = accCode;
            reqObj.DataArea.FaultCode = (solCmp.Solutions__r.FaultCode__r.Name != null)? solCmp.Solutions__r.FaultCode__r.Name :'';
            
            // reqObj.DataArea.CampaignNumber = (solCmp.Component_Id__c != null)? solCmp.Component_Id__c :'';
            // FSL_DetailCoverageReqWrapper.Details detailObj = new FSL_DetailCoverageReqWrapper.Details ();
            
            // system.debug('System Code is:'+detailObj.SystemCode);
            
            if(reqObj.DataArea.Details.size() > 0 && reqObj.DataArea.Details[0].SystemCode != '' && reqObj.DataArea.Details[0].ComponentCode != '' )
            {
                reqObj.DataArea.CampaignNumber ='';
                // reqObj.DataArea.CampaignNumber = (solCmp.Component_Id__c != null)? solCmp.Component_Id__c :'';
            }
            else
            {
                // reqObj.DataArea.CampaignNumber ='';
                reqObj.DataArea.CampaignNumber = (solCmp.Component_Id__c != null)? solCmp.Component_Id__c :'';
            }
            
            string jsonRre = json.serialize(reqObj);
            // jsonRre = jsonRre.replaceAll('":null', '": ');
            string jsonRes = getCoverageConnection(jsonRre);
            // responseHandler(jsonRes,solCmp.Id);
            FSL_DetailCoverageResWrapper obj = (FSL_DetailCoverageResWrapper)JSON.deserializeStrict(jsonRes,FSL_DetailCoverageResWrapper.class);
            system.debug('wrapper obj####'+obj);
			
			//CT3-481, Dinesh Yadav
            Boolean chkRes = false;
			if(obj.Header != null && obj.Header.Status =='Error'){
				msg = obj.Header.ReturnCodeDescription;
				chkRes = true;
			}
			
            if(obj.DataArea != null){
                if(obj.DataArea.Details != null && obj.DataArea.Details.size() > 0){
                    string accountCode = '%'+ obj.DataArea.Details[0].AccountCode;          
                    if(obj.DataArea.Details[0].AccountCode != ''){
                        listAccCode= [select id,Account_Code_Description__c,Coverage_Type__c,Name from FSL_Account_Code__c where Name like: accountCode];
                        system.debug('ResAccountCode:'+listAccCode);       
                    }
                    
                    if(listAccCode.size() > 0){
                        solCmp.FSL_Account_Code__c = listAccCode[0].name;
                        system.debug('Message:'+listAccCode[0].name);
                    }
                }
            }
            
            // if(obj.DataArea.Details[0].AccountCode == null || obj.DataArea.Details[0].AccountCode == ''){
              //  msg = '';}
             //else {
            //msg = solCmp.FSL_Account_Code__c;
            // }
			//ct3-481
			if(chkRes == false){
				msg = solCmp.FSL_Account_Code__c;
			}
            system.debug('Message:'+msg);
        }
        return msg;
    }
}