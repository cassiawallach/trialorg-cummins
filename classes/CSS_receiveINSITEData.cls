/**********************************************************************
Name:CSS_receiveINSITEData
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
Received Fault Codes and Engine Confirmation messages from INSITE in JSON format                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                 
1.0 - Gyan Pany   11/9/2015 1:16 PM     INITIAL DEVELOPMENT                     
2.0 - Gyan Pany   2/9/2016 12:25 PM     UDAC WIRE FRAME CHANGES                 
3.0 - Anirudh     2/11/2016             Coding Standards
4.0 - Satish      4/13/2016   			Added fixes for Defect#54800
***********************************************************************/


@RestResource(urlMapping='/InsiteData/V01/CSS/WO/*')
global with sharing class CSS_receiveINSITEData{
    
    @HttpPut
    global static void updateJobOrderData(){
        string JSONResponseBody;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        string requestUriVal = req.requestUri;
        string woVal = requestUriVal.remove('/InsiteData/V01/CSS/WO/');
        string jSONRequestBody ;
        Map<String, String> mpParams = new Map<String, String>(req.params);
        
        System.debug ('Gyan:-' + mpParams.get('ACTION'));
        if (mpParams.get('ACTION') == 'SendDataReceiptAcknowledgement')
        {
            JSONResponseBody = '{ "Status":"SendDataReceiptAcknowledgement", "Error_Code":"' + mpParams.get('RESPCODE') + '", "Error_Description":"SendDataReceiptAcknowledgement for CJOD-' + mpParams.get('CJOD') + '", "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
            insIntegrationError(JSONResponseBody, 'Acknowledgement Message from INSITE.','Acknowledgement Message');
            //return null;
        }
        else
        {
            jSONRequestBody = req.requestBody.toString().trim(); 
            ///System.debug (jSONRequestBody);
            try
            {
                System.Debug('Gyan === Before JSON Serialize');
                CSS_JSON2Apex wo1 = (CSS_JSON2Apex)JSON.deserializeStrict(jSONRequestBody,CSS_JSON2Apex.class);
                System.Debug('Gyan === After JSON Serialize');
                System.debug (wo1);
                
                //Fetch the Job Order from Salesforce based on the parameter passed on the URL
                list<CSS_Job_Order__c> lstJobOrder = [SELECT Id, Name, ESN__c, ESN_Insite__c, INSITE_UpdateTimeStamp__c, Status__c, Unit_Number__c From CSS_Job_Order__c WHERE Name =: wo1.CJOD];
                System.debug('lstJobOrder========>>>>>>'+lstJobOrder);
                
                if(!lstJobOrder.isEmpty())
                {
                    if(lstJobOrder[0].Status__c == 'Closed'){
                        JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01002", "Error_Description":"CSS JOB Status Closed", "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
                        insIntegrationError(JSONResponseBody, 'Closed Job Order. Notify as per Business Functionality.', jSONRequestBody);
                    }
                    else
                    {
                        AggregateResult[] groupedResults = [SELECT max(Sequence__c) maxSeq FROM CSS_Fault_Code__c where Job_Order__c = :lstJobOrder[0].Id ]; 
                        integer maxFltSeq = integer.valueOf(groupedResults[0].get('maxSeq'));  
                        if (maxFltSeq == null)
                        {
                            maxFltSeq = 1;
                        }
                        else
                        {
                            maxFltSeq = maxFltSeq+1;
                        }
                        System.debug(maxFltSeq);
                        lstJobOrder[0].ESN_Insite__c = wo1.ESN;
                        lstJobOrder[0].INSITE_UpdateTimeStamp__c = DateTime.now();
                        //Commented as per Defect#54800 
                        //lstJobOrder[0].Unit_Number__c = wo1.UNT;
                       if (wo1.ERT != null)
                        {
                            lstJobOrder[0].Engine_Run_Time_Hours_Mileage_km_miles__c = wo1.ERT;
                        }
                        if (wo1.ETD != null)
                        {
                            lstJobOrder[0].Engine_Total_Distance__c = decimal.valueOf(wo1.ETD);
                        }
                        lstJobOrder[0].Tool_Instance__c = wo1.TI;
                        //lstJobOrder[0].Mileage__c = decimal.valueOf(wo.data.mileage);
                        
                        list<string> faultCodeAPD = new list<string>();
                        list<string> faultCodeUFD1 = new list<string>();           
                        list<string> faultCodeFD = new list<string>();
                        
                        String strRelated;
                        //adding code to create ECM as per new data model
                        List<CSS_ECM__c> emcList = new List<CSS_ECM__c>();
                        for(integer i=0;i<wo1.FaultCode.size();i++){
                            CSS_ECM__c ecm = new CSS_ECM__c();
                            ecm.Job_Order__c = lstJobOrder[0].Id;
                            ecm.Name = 'Mod '+wo1.FaultCode[i].Mod +' '+wo1.CUSTNAME;
                            ecm.Customer_Name__c = wo1.CUSTNAME;
                            ecm.Customer_Unit_Number__c = wo1.UNT;
                            ecm.ESN__c = wo1.ESN;
                            if (wo1.ERT != null)
                            {
                                ecm.ERT__c = wo1.ERT;
                            }
                            if (wo1.ETD != null)
                            {
                                ecm.ETD__c = decimal.valueOf(wo1.ETD);
                            }                         
                            ecm.ECM_Image_Name__c = wo1.FaultCode[i].IMGNM;
                            ecm.Sequence__c = maxFltSeq;
                            emcList.add(ecm);
                        }
                        if(emcList.size()>0)
                            insert emcList;
                        Map<String,Id> mapECMVal = new Map<String,Id>();
                        for(CSS_ECM__c ecm:emcList)
                            mapECMVal.put(ecm.Name, ecm.Id);
                        
                        system.debug ('wo1.faultCode.size() :' + wo1.faultCode.size());  
                        Integer OrderSeq = 0;                                     
                        for(integer i=0;i<wo1.faultCode.size();i++)
                        {  
                            String ecmKey = 'Mod '+wo1.FaultCode[i].Mod +' '+wo1.CUSTNAME;
                            list<string> faultCodeBPD = new list<string>();
                            list<string> faultCodeUFD = new list<string>();
                            list<string> faultCodeUPA = new list<string>();
                            list<string> faultCodeUPI = new list<string>();
                            list<string> lstFaultCodeBPD = new list<string>();
                            list<string> lstFaultCodeUPA = new list<string>();
                            list<string> lstFaultCodeUPI = new list<string>();  
                            list<CSS_Fault_Code__c> insInAPDFaultCodes = new list<CSS_Fault_Code__c>(); 
                            
                            if(wo1.faultCode[i].FD.APD != null){
                                system.debug ('wo1.faultCode[i].FD.APD.size() ++===' + wo1.faultCode[i].FD.APD.size());
                                Map<String, String> mpAPD_P= new Map<String, String>();
                                Map<String, String> mpAPD_R= new Map<String, String>();
                                list<string> faultCodeAPD_P = new list<string>();
                                list<string> faultCodeAPD_R = new list<string>();
                                // 1st - Get all APD Fault Coulds into a List for finding Related Codes
                                for(integer j=0;j<wo1.faultCode[i].FD.APD.size();j++){
                                    ///system.debug ('wo1.faultCode[i].FD.APD[j].P ++===' + wo1.faultCode[i].FD.APD[j].P);
                                    ///system.debug ('wo1.faultCode[i].FD.APD[j].R.size() ++===' + wo1.faultCode[i].FD.APD[j].R.size());
                                    strRelated='';
                                    for(integer k=0;k<wo1.faultCode[i].FD.APD[j].R.size();k++)
                                    {
                                        if (strRelated =='')
                                        {
                                            strRelated = wo1.faultCode[i].FD.APD[j].R[k];
                                        }
                                        else
                                        {
                                            strRelated = strRelated + ',' + wo1.faultCode[i].FD.APD[j].R[k];
                                        }
                                        faultCodeAPD_R.add(string.valueof(wo1.faultCode[i].FD.APD[j].R[k]));
                                        mpAPD_R.put(string.valueof(wo1.faultCode[i].FD.APD[j].R[k]), string.valueof(wo1.faultCode[i].FD.APD[j].P));
                                    }
                                    faultCodeAPD_P.add(string.valueof(wo1.faultCode[i].FD.APD[j].P));
                                    mpAPD_P.put(string.valueof(wo1.faultCode[i].FD.APD[j].P), strRelated);
                                }             
                                
                                if (!faultCodeAPD_P.isEmpty())
                                {
                                    for(integer l=0;l<faultCodeAPD_P.size();l++)
                                    {
                                        if (!(faultCodeAPD_P[l] ==null) && !(faultCodeAPD_P[l] ==''))
                                        {
                                            CSS_Fault_Code__c APDFaultCodeObj = new CSS_Fault_Code__c();
                                            APDFaultCodeObj.Name = /*'APD - P '*/+ faultCodeAPD_P[l];
                                            APDFaultCodeObj.Job_Order__c = lstJobOrder[0].Id;
                                            APDFaultCodeObj.ECM__c = mapECMVal.get(ecmKey);
                                            APDFaultCodeObj.Primary_Fault_Code__c = integer.valueof(faultCodeAPD_P[l]) ;
                                            APDFaultCodeObj.Related_Fault_Code__c = mpAPD_P.get(faultCodeAPD_P[l]) ;
                                            APDFaultCodeObj.Image_Name__c = wo1.FaultCode[i].IMGNM;
                                            APDFaultCodeObj.Mod__c = wo1.FaultCode[i].Mod;
                                            APDFaultCodeObj.PAT__c = wo1.FaultCode[i].PAT;
                                            APDFaultCodeObj.Fault_Code_Type__c = 'APD-P';
                                            APDFaultCodeObj.FaultCodeR2__c = faultCodeAPD_P[l];
                                            APDFaultCodeObj.Sequence__c = maxFltSeq;
                                            APDFaultCodeObj.Order__c = OrderSeq;
                                            OrderSeq++;                                                                  
                                            insInAPDFaultCodes.add(APDFaultCodeObj);
                                        }
                                    }
                                }
                                ///system.debug ('Values in insInAPDFaultCodes after Primary +++===' + insInAPDFaultCodes);
                                // Second - Add all the APD Related Fault Codes with other attributes
                                if (!faultCodeAPD_R.isEmpty())
                                {
                                    for(integer m=0;m<faultCodeAPD_R.size();m++)
                                    {
                                        string sRelFC = faultCodeAPD_R[m].remove('(').removeEnd(')');
                                        if (!(sRelFC ==null) && !(sRelFC ==''))
                                        {
                                            CSS_Fault_Code__c APDFaultCodeObj = new CSS_Fault_Code__c();
                                            APDFaultCodeObj.Name = /*'APD - R '*/+ sRelFC ;
                                            APDFaultCodeObj.Job_Order__c = lstJobOrder[0].Id;
                                            APDFaultCodeObj.Primary_Fault_Code__c = integer.valueof(mpAPD_R.get(sRelFC)) ;
                                            APDFaultCodeObj.ECM__c = mapECMVal.get(ecmKey);
                                            APDFaultCodeObj.Image_Name__c = wo1.FaultCode[i].IMGNM;
                                            APDFaultCodeObj.Mod__c = wo1.FaultCode[i].Mod;
                                            APDFaultCodeObj.PAT__c = wo1.FaultCode[i].PAT;
                                            APDFaultCodeObj.FaultCodeR2__c = sRelFC;
                                            APDFaultCodeObj.Fault_Code_Type__c = 'APD-R';
                                            APDFaultCodeObj.Sequence__c = maxFltSeq;
                                            APDFaultCodeObj.Order__c = OrderSeq;
                                            OrderSeq++;                                             
                                            insInAPDFaultCodes.add(APDFaultCodeObj);
                                        }
                                    }
                                }
                                mpAPD_P.clear();
                                mpAPD_R.clear();
                                faultCodeAPD_R.clear();
                                faultCodeAPD_P.clear();
                            }
                            // 3rd - Get all BPD Fault Codes and prepare List for Creation
                            if(wo1.faultCode[i].FD.BPD != null){
                                lstFaultCodeBPD.add(string.valueOf(wo1.faultCode[i].FD.BPD));
                            }
                            for(integer n=0;n<lstFaultCodeBPD.size();n++){
                                string s = lstFaultCodeBPD[n].remove('(').removeEnd(')');
                                ///system.debug('-----Splitted BPD---->>>>>'+s);
                                list<string>s1 = s.split(',');
                                faultCodeBPD.addAll(s1);
                            }
                            list<CSS_Fault_Code__c> insInBPDFaultCodes = new list<CSS_Fault_Code__c>();
                            for(integer o=0;o<faultCodeBPD.size();o++){
                                CSS_Fault_Code__c BPDFaultCodeObj = new CSS_Fault_Code__c();
                                BPDFaultCodeObj.Name = /*'BPD '*/ + faultCodeBPD[o];
                                BPDFaultCodeObj.Job_Order__c = lstJobOrder[0].Id;
                                BPDFaultCodeObj.ECM__c = mapECMVal.get(ecmKey);
                                BPDFaultCodeObj.Image_Name__c = wo1.FaultCode[i].IMGNM;
                                BPDFaultCodeObj.Mod__c = wo1.FaultCode[i].Mod;
                                BPDFaultCodeObj.PAT__c = wo1.FaultCode[i].PAT;
                                BPDFaultCodeObj.Fault_Code_Type__c = 'BPD';
                                BPDFaultCodeObj.FaultCodeR2__c = faultCodeBPD[o];
                                BPDFaultCodeObj.Sequence__c = maxFltSeq;
                                BPDFaultCodeObj.Order__c = OrderSeq;
                                OrderSeq++;                                     
                                insInBPDFaultCodes.add(BPDFaultCodeObj);
                            }
                            system.debug('wo1.faultCode[i].FD.UFD: '+wo1.faultCode[i].FD.UFD);
                            //4th - Get all UFD - UPA Codes and prepare List for Creation
                            if(wo1.faultCode[i].FD.UFD != null){
                                if(wo1.faultCode[i].FD.UFD.UPA != null){
                                    for(integer p=0;p<wo1.faultCode[i].FD.UFD.UPA.size();p++){
                                        faultCodeUPA.add(wo1.faultCode[i].FD.UFD.UPA[p]);
                                    }                                    
                                }
                                
                                if(wo1.faultCode[i].FD.UFD.UPI != null){
                                    for(integer r=0;r<wo1.faultCode[i].FD.UFD.UPI.size();r++){
                                        faultCodeUPI.add(wo1.faultCode[i].FD.UFD.UPI[r]);
                                    }                                    
                                }
                            }                            
                            list<CSS_Fault_Code__c> insInUPAFaultCodes = new list<CSS_Fault_Code__c>();
                            for(integer q=0;q<faultCodeUPA.size();q++){
                                CSS_Fault_Code__c UFDFaultCodeObj = new CSS_Fault_Code__c();
                                UFDFaultCodeObj.Name = /*'UFD - UPA '*/+faultCodeUPA[q];
                                UFDFaultCodeObj.Job_Order__c = lstJobOrder[0].Id;
                                UFDFaultCodeObj.ECM__c = mapECMVal.get(ecmKey);
                                UFDFaultCodeObj.Image_Name__c = wo1.FaultCode[0].IMGNM;
                                UFDFaultCodeObj.Mod__c = wo1.FaultCode[i].Mod;
                                UFDFaultCodeObj.PAT__c = wo1.FaultCode[i].PAT;
                                UFDFaultCodeObj.Fault_Code_Type__c = 'UPA';
                                UFDFaultCodeObj.FaultCodeR2__c = faultCodeUPA[q];
                                UFDFaultCodeObj.Sequence__c = maxFltSeq;
                                UFDFaultCodeObj.Order__c = OrderSeq;
                                OrderSeq++;                                  
                                insInUPAFaultCodes.add(UFDFaultCodeObj);
                            }

                            list<CSS_Fault_Code__c> insInUPIFaultCodes = new list<CSS_Fault_Code__c>();
                            for(integer t=0;t<faultCodeUPI.size();t++){
                                CSS_Fault_Code__c UFDFaultCodeObj = new CSS_Fault_Code__c();
                                UFDFaultCodeObj.Name = /*'UFD - UPI '*/+faultCodeUPI[t];
                                UFDFaultCodeObj.Job_Order__c = lstJobOrder[0].Id;
                                UFDFaultCodeObj.ECM__c = mapECMVal.get(ecmKey);
                                UFDFaultCodeObj.Image_Name__c = wo1.FaultCode[0].IMGNM;
                                UFDFaultCodeObj.Mod__c = wo1.FaultCode[i].Mod;
                                UFDFaultCodeObj.PAT__c = wo1.FaultCode[i].PAT;
                                UFDFaultCodeObj.Fault_Code_Type__c = 'UPI';
                                UFDFaultCodeObj.FaultCodeR2__c = faultCodeUPI[t];
                                UFDFaultCodeObj.Sequence__c = maxFltSeq;
                                UFDFaultCodeObj.Order__c = OrderSeq;
                                OrderSeq++;                                  
                                insInUPIFaultCodes.add(UFDFaultCodeObj);
                            }
                            // 6th - Insert the Fault Codes
                            if(insInAPDFaultCodes.size()>0){
                                insert insInAPDFaultCodes;
                            }
                            
                            if(insInBPDFaultCodes.size()>0){
                                insert insInBPDFaultCodes;
                            }
                            
                            if(insInUPAFaultCodes.size()>0){
                                insert insInUPAFaultCodes;
                            }
                            
                            if(insInUPIFaultCodes.size()>0){
                                insert insInUPIFaultCodes;
                            }
                        } 
                        JSONResponseBody = '{ "Status":"OK", "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
                    }
                }
                else
                {
                    JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01002", "Error_Description":"CSS JOB Not Found", "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
                    insIntegrationError(JSONResponseBody, 'Job Order Not Found. Notify INSITE.', jSONRequestBody);
                }
                update lstJobOrder;
            }
            catch(Exception e)
            {
                system.debug('Excepion======>>>>>'+e);
                system.debug('Excepion Line Number======>>>>>'+e.getLineNumber());
                
                if(e.getTypeName() == 'System.JSONException'){
                    JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01001", "Error_Description":"Invalid JSON Schema", "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
                    insIntegrationError(JSONResponseBody, 'Invalid JSON. Notify INSITE.',jSONRequestBody);
                }
                else if(e.getTypeName() == 'System.TypeException'){
                    JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01001", "Error_Description":"Invalid JSON Schema", "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
                    insIntegrationError(JSONResponseBody, 'DataType Mismatch. Notify INSITE.',jSONRequestBody);
                }
                
                else
                {
                    JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01000", "Error_Description":"CSS Internal Error", "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
                    insIntegrationError(JSONResponseBody, 'CSS Error:' + e.getMessage(),jSONRequestBody);
                }
                
            }
            
            //return JSON.deserialize(JSONResponseBody);
            res.responseBody = Blob.valueOf(JSONResponseBody);
        }
    }            
    
    global static void insIntegrationError(string errDesc, string sysError, string reqMsg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Error_Description__c = sysError + ' *** External Message ** ' + errDesc;
        errObj.Source__c = 'INSITE';
        errObj.Processed_Data__c = reqMsg;
        insert errObj;
    }
    
}