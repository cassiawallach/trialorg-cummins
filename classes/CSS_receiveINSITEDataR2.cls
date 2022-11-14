/*********************************************************************************
Name:CSS_receiveINSITEDataR2
Copyright © 2011  Cummins
=================================================================================
=================================================================================
Purpose:                                                            
Received Fault Codes and Engine Confirmation messages from INSITE in JSON format                                                             
=================================================================================
=================================================================================
History                                                             
-------                                                             
VERSION  AUTHOR            DATE                 DETAIL                                 
1.0 - Gyan Pany          11/09/2015        INITIAL DEVELOPMENT                     
2.0 - Gyan Pany          02/09/2016        UDAC WIRE FRAME CHANGES                 
3.0 - Anirudh            02/11/2016        Coding Standards
4.0 - Anirudh            03/10/2016        Modified code to receive 
                                           additional data from Insite
4.5-  Anirudh & Gyan     07/25/2016        Check to verify Environment & 
                                           Added Location Field
5.0   Vignesh            09/18/2017        Added code to handle OFFLINE
                                           Jobs from INSTE
6.0   PiyushR            03/18/2019        Added code to handle fault codes for 
                                           FSL Service Order from INSITE  
7.0   Anirudh            04/01/2020        Removed Error Codes 1002 and 1003 as part
                                           of GSSC-663 and changed response to Success 
                                           as requested by Insite Team.
8.0   Charan Teja        04/14/2021        Added for test class coverage
9.0   Ronnie Mishra      07/19/2022        Code added for Service Order Extension 
                                           object updation when ABR Flag is true. Code 
                                           optimized to remove Apex timeout issue.
10.0  Ronnie Mishra      07/19/2022        isFTR check added for disabling/enabling FTR feature
**********************************************************************************/
@RestResource(urlMapping='/InsiteData/V02/CSS/WO/*') 
global with sharing class CSS_receiveINSITEDataR2{
    Static string JSONResponseBody; 
    Static string wsESN;
    Static CSS_JSON2APEXINSITER2 wo1;  
    Static string jSONRequestBody;
    Static Boolean isFTR;
    //SG-2 Code Starts, Ronnie Mishra, 07/19/2022
    public class CSS_AbrTransactionIdWrapper {
        public String TransactionID; 
        public Boolean ABRFlag; 
    } 
    //SG-2 Code Ends, Ronnie Mishra, 07/19/2022
    @HttpPut
    global static void updateJobOrderData(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        //SG-2 Code starts, Ronnie Mishra, 07/19/2022
        CSS_AbrTransactionIdWrapper abrTransObj = new CSS_AbrTransactionIdWrapper();
        //SG-2 Code Ends, Ronnie Mishra, 07/19/2022
        //SG-104, Code Start, Ronnie Mishra, 08/17/2022
        List<FSL_Switch__c> lstFeatureMatrix = [SELECT Id, Name, IsActive__c FROM FSL_Switch__c WHERE Name = 'Enable_FTR_Switch' LIMIT 1];  
        if(lstFeatureMatrix.size() > 0 && lstFeatureMatrix[0].IsActive__c == true) {
            isFTR = true;
        }      
        else {
            isFTR = false;
        }
        //SG-104, Code End, Ronnie Mishra, 08/17/2022

        res.addHeader('Content-Type', 'application/json');
        string requestUriVal = req.requestUri;
        string woVal = requestUriVal.remove('/InsiteData/V02/CSS/WO/');       
        Map<String, String> mpParams = new Map<String, String>(req.params);
        if (mpParams.get('ACTION') == 'SendDataReceiptAcknowledgement')
        {
            JSONResponseBody = '{ "Status":"SendDataReceiptAcknowledgement", "Error_Code":"' + mpParams.get('RESPCODE') + '", "Error_Description":"SendDataReceiptAcknowledgement for CJOD-' + mpParams.get('CJOD') + '", "TMS": "' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z"}';
            insIntegrationError(JSONResponseBody, 'Acknowledgement Message from INSITE.','Acknowledgement Message');
        }
        else
        {
            jSONRequestBody = req.requestBody.toString().trim(); 
            try
            {
                wo1 = (CSS_JSON2APEXINSITER2)JSON.deserializeStrict(jSONRequestBody,CSS_JSON2APEXINSITER2.class);
                //Fetch the Job Order from Salesforce based on the parameter passed on the URL
                list<CSS_Job_Order__c> lstJobOrder = [SELECT Id, Name, ESN__c, ESN_Insite__c, ESN_Locked__c, Insite_ESN2__c, INSITE_UpdateTimeStamp__c, Status__c, Unit_Number__c 
                                                      FROM CSS_Job_Order__c WHERE Name =: wo1.CJOD];              
                //Added CaseId to query as part of SG-2, Ronnie Mishra, 07/19/2022
                list<WorkOrder> lstServiceOrder = [SELECT Id, WorkOrderNumber, ESN__c, ESN_Insite__c, ESN_Locked__c, Insite_ESN2__c, INSITE_UpdateTimeStamp__c, Status, Fault_codes_Symptoms_Searched__c, 
                                                   CaseId, (SELECT id, FSL_ABRFlag__c, FSL_TransactionID__c, Service_Order_Id__c FROM Service_Order_Extension__r) FROM WorkOrder WHERE WorkOrderNumber =:wo1.CJOD];
        
        /* Removed as part of new changes CLS and FSL */
                if(!lstJobOrder.isEmpty())
                {
                    abrTransObj = jobOrder(lstJobOrder[0],wo1,null);                    
                }
                else if(!lstServiceOrder.isEmpty()){
                    abrTransObj = jobOrder(null,wo1,lstServiceOrder[0]);
                   //Ct1-532 
                    if(lstServiceOrder[0].id!=null){
                        List<Case> caseRecodList=[Select id,status from case where ServiceJob__c=:lstServiceOrder[0].id];
                        if(!caseRecodList.isEmpty()){
                            Case caseRecord =new Case();
                            caseRecord.id=caseRecodList[0].id;
                            caseRecord.Bypass_Validation_Rule__c =true;
                            caseRecord.Status='Triage & Diagnosis';
                            //SG-2 Code starts, Ronnie Mishra, 07/19/2022
                            //SG-104, isFTR check added, Ronnie Mishra, 08/17/2022
                            if(abrTransObj.ABRFlag != null && isFTR == true) {
                                caseRecord.FSL_ABRFlag__c = abrTransObj.ABRFlag;
                                caseRecord.FSL_TransactionID__c = abrTransObj.TransactionID;
                            }
                            //SG-2 Code Ends, Ronnie Mishra, 07/19/2022
                            update caseRecord;
                            caseRecord.Bypass_Validation_Rule__c =false;
                            update caseRecord;
                        }
                    }
                }
        /* Removed as part of new changes CLS and FSL */
                else
                {
                    if(wo1.CJOD.contains(wo1.TI)){
                        JSONResponseBody = '{ "Status":"OK", "TMS": "' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z", "TempJobId":"'+wo1.CJOD+'"}';
                    }
                    else{
                        JSONResponseBody = '{ "Status":"OK", "TMS": "' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z"}';//GSSC-663
                       // JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01002", "Error_Description":"CSS JOB Not Found", "TMS": "' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z"}';//Commented by Anirudh as part of GSSC-663
                        // JSONResponseBody = '{ "Status":"Error", "Error_Code":"FORBIDDEN", "Error_Description":"You do not have access to the Apex class named: CSS_receiveINSITEDataR2", "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
                    }
                    insIntegrationError(JSONResponseBody, 'Job Order Not Found. Notify INSITE.', jSONRequestBody);
                }

            }
            catch(Exception e)
            {
                if(e.getTypeName() == 'System.JSONException'){
                     JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01001", "Error_Description":"Invalid JSON Schema"'+e+', "TMS": "' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z"}';
                    //JSONResponseBody = '{ "Status":"Error", "Error_Code":"FORBIDDEN", "Error_Description":"You do not have access to the Apex class named: CSS_receiveINSITEDataR2"'+e+', "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
                    insIntegrationError(JSONResponseBody, 'Invalid JSON. Notify INSITE.',jSONRequestBody);
                }
                else if(e.getTypeName() == 'System.TypeException'){
                    JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01001", "Error_Description":"Invalid JSON Schema"'+e+', "TMS": "' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z"}';
                    //JSONResponseBody = '{ "Status":"Error", "Error_Code":"FORBIDDEN", "Error_Description":"You do not have access to the Apex class named: CSS_receiveINSITEDataR2"'+e+', "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
                    insIntegrationError(JSONResponseBody, 'DataType Mismatch. Notify INSITE.',jSONRequestBody);
                }

                else
                {
                    JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01000", "Error_Description":"You do not have access to the Apex class named: CSS_receiveINSITEDataR2"'+e+', "TMS": "' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z"}';
                    //JSONResponseBody = '{ "Status":"Error", "Error_Code":"FORBIDDEN", "Error_Description":"You do not have access to the Apex class named: CSS_receiveINSITEDataR2"'+e+', "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
                    insIntegrationError(JSONResponseBody, 'CSS Error:' + e.getMessage()+e.getLineNumber(),jSONRequestBody);
                }

            }
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
    
    public static CSS_AbrTransactionIdWrapper jobOrder(CSS_Job_Order__c lstJobOrder ,CSS_JSON2APEXINSITER2 wo1 ,WorkOrder serviceOrder ){
        //SG-2 Code Starts, Ronnie Mishra, 07/19/2022
        Service_Order_Extension__c servOrdExtObj = new Service_Order_Extension__c();
        CSS_AbrTransactionIdWrapper abrTransObj = new CSS_AbrTransactionIdWrapper();
        //SG-2 Code Ends, Ronnie Mishra, 07/19/2022
        if( (lstJobOrder!=null && lstJobOrder.Status__c == 'Closed') || (serviceOrder!=null && serviceOrder.Status == 'Closed')){
            JSONResponseBody = '{ "Status":"OK", "TMS": "' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z"}';//GSSC-663
            //JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01002", "Error_Description":"CSS JOB Status Closed", "TMS": "' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z"}';//Commented by Anirudh as part of GSSC-663
            // JSONResponseBody = '{ "Status":"Error", "Error_Code":"FORBIDDEN", "Error_Description":"You do not have access to the Apex class named: CSS_receiveINSITEDataR2", "TMS": ' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z}';
            insIntegrationError(JSONResponseBody, 'Closed Job Order. Notify as per Business Functionality.', jSONRequestBody);
        }
        else
        {
            integer maxFltSeq;
            string strFaultCodeNames = '';
            if( lstJobOrder != null){
                AggregateResult[] groupedResults = [SELECT max(Sequence__c) maxSeq FROM CSS_Fault_Code__c where Job_Order__c = :lstJobOrder.Id ]; 
                maxFltSeq = integer.valueOf(groupedResults[0].get('maxSeq')); 
            }
            else if(serviceOrder != null){ 
                AggregateResult[] groupedResults = [SELECT max(Sequence__c) maxSeq FROM CSS_Fault_Code__c where Service_Order__c = :serviceOrder.Id ]; 
                maxFltSeq = integer.valueOf(groupedResults[0].get('maxSeq')); 
            }           
            if (maxFltSeq == null)
            {
                maxFltSeq = 1;
            }
            else
            {
                maxFltSeq = maxFltSeq+1;
            }
            // lstJobOrder.ESN_Insite__c = wo1.ESN;
            if(lstJobOrder!=null){
                lstJobOrder.INSITE_UpdateTimeStamp__c = DateTime.now();
                lstJobOrder.Tool_Instance__c = wo1.TI;
            }
      /* ----FSL CODE  */
            if(serviceOrder!=null){
                serviceOrder.INSITE_UpdateTimeStamp__c = DateTime.now();
                serviceOrder.Tool_Instance__c = wo1.TI;
            }
      /* ----FSL CODE  */
            //lstJobOrder.Mileage__c = decimal.valueOf(wo.data.mileage);

            list<string> faultCodeAPD = new list<string>();
            list<string> faultCodeUFD1 = new list<string>();           
            list<string> faultCodeFD = new list<string>();

            String strRelated;
            List<CSS_ECM__c> emcList = new List<CSS_ECM__c>();
            Map<String, SObjectField> fields = Schema.getGlobalDescribe().get('CSS_ECM__c').getDescribe().fields.getMap();                        
            Map<Integer,String> mapSDPCustSet = new Map<Integer,String>();
            for (CSS_JOB_SDP_MAP__c sdpVal : CSS_JOB_SDP_MAP__c.getAll().values()){
                mapSDPCustSet.put(Integer.valueOf(sdpVal.Serial_Number__c),sdpVal.Field_API_Name__c);
            }                    
            Integer OrderSeq = 0;                        
            for(integer i=0;i<wo1.module.size();i++){
                //Code Start SG-2, Ronnie Mishra, 07/19/2022
                if(wo1.module[i].ABRFlag == true) {
                    //SG-104, isFTR check added, Ronnie Mishra, 08/17/2022
                    if(serviceOrder != null && isFTR == true) {
                        if(serviceOrder.Service_Order_Extension__r.size() > 0) {
                            servOrdExtObj = serviceOrder.Service_Order_Extension__r[0];
                            servOrdExtObj.Id = serviceOrder.Service_Order_Extension__r[0].Id;
                            servOrdExtObj.FSL_ABRFlag__c = wo1.module[i].ABRFlag;
                            servOrdExtObj.FSL_TransactionID__c = wo1.module[i].transactionID;   
                        }
                        abrTransObj.TransactionID = wo1.module[i].transactionID;
                        abrTransObj.ABRFlag = wo1.module[i].ABRFlag; 
                    }
                }
                //Code End SG-2, Ronnie Mishra, 07/19/2022
                CSS_ECM__c ecm = new CSS_ECM__c();
                if(lstJobOrder!=null){
                    ecm.Job_Order__c = lstJobOrder.Id;
                }
                if(serviceOrder!=null){
                    ecm.Work_Order__c = serviceOrder.id;
                }
                
                ecm.Name = 'mod '+wo1.module[i].mod +' '+wo1.module[i].header.CUSTNAME;
                ecm.ecm_number__c = integer.valueof(wo1.module[i].mod);
                ecm.Customer_Name__c = wo1.module[i].header.CUSTNAME;
                ecm.Customer_Unit_Number__c = wo1.module[i].header.UNT;
                ecm.CORE__c = wo1.module[i].header.CORE;
                ecm.ESN__c = wo1.module[i].header.ESN;
                wsESN = wo1.module[i].header.ESN;
                if(wo1.module[i].header.ERT != null)
                    ecm.ERT__c = wo1.module[i].header.ERT;
                if(wo1.module[i].header.ETD != null)
                    ecm.ETD__c = Decimal.valueOf(wo1.module[i].header.ETD);
                ecm.KOT__c = wo1.module[i].header.KOT;
                ecm.ECM_Image_Name__c = wo1.module[i].header.IMGNM;
                if(lstJobOrder!=null){
                    lstJobOrder.Insite_CustomerName__c = wo1.module[i].header.CUSTNAME;
                    lstJobOrder.Insite_Unit_Number__c = wo1.module[i].header.UNT;
                    lstJobOrder.Insite_Core__c = wo1.module[i].header.CORE;
                    if(lstJobOrder.ESN_Insite__c==null || lstJobOrder.ESN_Insite__c==''){
                        lstJobOrder.ESN_Insite__c = wo1.module[i].header.ESN;
                    }
                    if(lstJobOrder.ESN__c==null || lstJobOrder.ESN__c==''){
                        lstJobOrder.ESN__c = wo1.module[i].header.ESN ;  
                    }
                    if(wo1.module[i].header.ERT != null)
                        lstJobOrder.Engine_Run_Time_Hours_Mileage_km_miles__c = wo1.module[i].header.ERT;
                    if(wo1.module[i].header.ETD != null)
                        lstJobOrder.Engine_Total_Distance__c = Decimal.valueOf(wo1.module[i].header.ETD);
                    lstJobOrder.Insite_KOT__c = wo1.module[i].header.KOT;
                    lstJobOrder.INSITE_Work_Order_Image_Name__c = wo1.module[i].header.IMGNM;
                }   
                if(serviceOrder!=null){
                    serviceOrder.Insite_CustomerName__c = wo1.module[i].header.CUSTNAME;
                    serviceOrder.Insite_Unit_Number__c = wo1.module[i].header.UNT;
                    serviceOrder.Insite_Core__c = wo1.module[i].header.CORE;
                    if(serviceOrder.ESN_Insite__c==null || serviceOrder.ESN_Insite__c==''){
                        serviceOrder.ESN_Insite__c = wo1.module[i].header.ESN;
                    }
                    if(serviceOrder.ESN__c==null || serviceOrder.ESN__c==''){
                        serviceOrder.ESN__c = wo1.module[i].header.ESN ;  
                    }
                    if(wo1.module[i].header.ERT != null)
                        serviceOrder.Engine_Run_Time_Hours_Mileage_km_miles__c = wo1.module[i].header.ERT;
                    if(wo1.module[i].header.ETD != null)
                        serviceOrder.Engine_Total_Distance__c = Decimal.valueOf(wo1.module[i].header.ETD);
                    serviceOrder.Insite_KOT__c = wo1.module[i].header.KOT;
                    serviceOrder.INSITE_Work_Order_Image_Name__c = wo1.module[i].header.IMGNM;  
                }
                ecm.Sequence__c = maxFltSeq;
                ecm.Type__c = 'ECM';
                if(wo1.module[i].SDP.size()>0){
                    for(Integer j=0;j<wo1.module[i].SDP.size();j++){
                        if(wo1.module[i].SDP[j].field != null){
                            Integer key = Integer.valueOf(wo1.module[i].SDP[j].field);
                            if(mapSDPCustSet.containsKey(key)){
                                String fieldAPIName = mapSDPCustSet.get(key);
                                Schema.DisplayType fielddataType = fields.get(fieldAPIName).getDescribe().getType();
                                if(fielddataType == Schema.DisplayType.DOUBLE)  {                                              
                                    if(wo1.module[i].SDP[j].value != null)
                                        ecm.put(fieldAPIName,Decimal.valueOf(wo1.module[i].SDP[j].value));
                                }
                                else
                                    ecm.put(fieldAPIName,wo1.module[i].SDP[j].value); 


                            }
                        }
                    }
                }
                emcList.add(ecm);
            }           
            //SG-2 code starts, Ronnie Mishra, 07/19/2022
            if(servOrdExtObj.FSL_ABRFlag__c == true && isFTR) {
                update servOrdExtObj; 
            }
            //SG-2 code ends, Ronnie Mishra, 07/19/2022
            if(emcList.size()>0)
                insert emcList;
            Map<String,Id> mapECMVal = new Map<String,Id>();
            for(CSS_ECM__c ecm:emcList)
                mapECMVal.put(ecm.Name, ecm.Id);                
            for(integer i=0;i<wo1.module.size();i++)
            {  
                String ecmKey = 'mod '+wo1.module[i].mod +' '+wo1.module[i].header.CUSTNAME;                            
                Map<String,String> mapFDMeta = new Map<String,String>();
                for(Integer j=0;j< wo1.module[i].FDMeta.size();j++){
                    if(wo1.module[i].FDMeta[j].FC != null)
                        mapFDMeta.put(wo1.module[i].FDMeta[j].FC.trim(),wo1.module[i].FDMeta[j].count +';'+ wo1.module[i].FDMeta[j].status);
                }                       
                list<string> faultCodeBPD = new list<string>();
                list<string> faultCodeUFD = new list<string>();
                list<string> faultCodeUPA = new list<string>();
                list<string> faultCodeUPI = new list<string>();
                list<string> lstFaultCodeBPD = new list<string>();
                list<string> lstFaultCodeUPA = new list<string>();
                list<string> lstFaultCodeUPI = new list<string>(); 
                CSS_Fault_Code__c BlankFaultCode = new CSS_Fault_Code__c();
                list<CSS_Fault_Code__c> insInAPDFaultCodes = new list<CSS_Fault_Code__c>(); 
                //SG-2
                List<CSS_Fault_Code__c> listOfFaultCodes = new List<CSS_Fault_Code__c>();
                if(wo1.module[i].FD.APD != null){
                    Map<String, String> mpAPD_P= new Map<String, String>();
                    Map<String, String> mpAPD_R= new Map<String, String>();
                    list<string> faultCodeAPD_P = new list<string>();
                    list<string> faultCodeAPD_R = new list<string>();
                    // 1st - Get all APD Fault Coulds into a List for finding Related Codes
                    for(integer j=0;j<wo1.module[i].FD.APD.size();j++){
                        strRelated='';
                        for(integer k=0;k<wo1.module[i].FD.APD[j].R.size();k++)
                        {
                            if (strRelated =='')
                            {
                                strRelated = wo1.module[i].FD.APD[j].R[k];
                            }
                            else
                            {
                                strRelated = strRelated + ', ' + wo1.module[i].FD.APD[j].R[k];
                            }
                            faultCodeAPD_R.add(string.valueof(wo1.module[i].FD.APD[j].R[k]));
                            mpAPD_R.put(string.valueof(wo1.module[i].FD.APD[j].R[k]), string.valueof(wo1.module[i].FD.APD[j].P));
                        }
                        faultCodeAPD_P.add(string.valueof(wo1.module[i].FD.APD[j].P));
                        mpAPD_P.put(string.valueof(wo1.module[i].FD.APD[j].P), strRelated);
                    } 
                    // 2nd - Set All (Primary & Related) APD Fault Codes in List for for Creation                                    
                    if (!faultCodeAPD_P.isEmpty())
                    {
                        for(integer l=0;l<faultCodeAPD_P.size();l++)
                        {
                            if (!(faultCodeAPD_P[l] ==null) && !(faultCodeAPD_P[l] ==''))
                            {
                                CSS_Fault_Code__c APDFaultCodeObj = new CSS_Fault_Code__c();
                                APDFaultCodeObj.Name = /*'APD - P '*/+ faultCodeAPD_P[l];
                                APDFaultCodeObj.ECM__c = mapECMVal.get(ecmKey);
                                if(mapFDMeta.containsKey(faultCodeAPD_P[l].trim())){
                                    List<String> strList = mapFDMeta.get(faultCodeAPD_P[l].trim()).split(';');
                                    APDFaultCodeObj.Count__c = Decimal.valueOf(strList[0]);
                                    APDFaultCodeObj.Status__c = strList[1];
                                }
                                if(lstJobOrder != null){
                                    APDFaultCodeObj.Job_Order__c = lstJobOrder.Id;
                                }
                                if(serviceOrder!=null){
                                    APDFaultCodeObj.Service_Order__c = serviceOrder.id;
                                }                       
                                
                                //APDFaultCodeObj.Fault_Code__c = APDFaultCodeMap_P.get(faultCodeAPD_P[l]);
                                APDFaultCodeObj.Primary_Fault_Code__c = integer.valueof(faultCodeAPD_P[l]) ;
                                APDFaultCodeObj.Related_Fault_Code__c = mpAPD_P.get(faultCodeAPD_P[l]) ;
                                //APDFaultCodeObj.Image_Name__c = wo1.FaultCode[i].IMGNM;
                                APDFaultCodeObj.Mod__c = wo1.module[i].mod;
                                APDFaultCodeObj.PAT__c = wo1.module[i].PAT;
                                APDFaultCodeObj.Fault_Code_Type__c = 'APD-P';
                                APDFaultCodeObj.FaultCodeR2__c = faultCodeAPD_P[l];
                                APDFaultCodeObj.Sequence__c = maxFltSeq;
                                APDFaultCodeObj.Order__c = OrderSeq;
                                OrderSeq++;
                                //insInAPDFaultCodes.add(APDFaultCodeObj);
                                listOfFaultCodes.add(APDFaultCodeObj);
                                //CT3-269, Dinesh Yadav
                                if(string.isBlank(strFaultCodeNames))
                                    strFaultCodeNames = APDFaultCodeObj.Name;
                                else if(strFaultCodeNames.contains(APDFaultCodeObj.Name) == false)
                                    strFaultCodeNames = strFaultCodeNames +','+APDFaultCodeObj.Name;
                            }
                        }
                    }
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
                                //APDFaultCodeObj.Job_Order__c = lstJobOrder.Id;
                                if(lstJobOrder != null){
                                    APDFaultCodeObj.Job_Order__c = lstJobOrder.Id;
                                }
                                if(serviceOrder!=null){
                                    APDFaultCodeObj.Service_Order__c = serviceOrder.id;
                                }
                                APDFaultCodeObj.ECM__c = mapECMVal.get(ecmKey);
                                if(mapFDMeta.containsKey(faultCodeAPD_R[m].trim())){
                                    List<String> strList = mapFDMeta.get(faultCodeAPD_R[m].trim()).split(';');
                                    APDFaultCodeObj.Count__c = Decimal.valueOf(strList[0]);
                                    APDFaultCodeObj.Status__c = strList[1];
                                }                                            
                                APDFaultCodeObj.Primary_Fault_Code__c = integer.valueof(mpAPD_R.get(sRelFC)) ;
                                //APDFaultCodeObj.Fault_Code__c = APDFaultCodeMap_R.get(sRelFC);
                                //APDFaultCodeObj.Image_Name__c = wo1.FaultCode[i].IMGNM;
                                APDFaultCodeObj.Mod__c = wo1.module[i].mod;
                                APDFaultCodeObj.PAT__c = wo1.module[i].PAT;
                                APDFaultCodeObj.Fault_Code_Type__c = 'APD-R';
                                APDFaultCodeObj.FaultCodeR2__c = sRelFC;
                                APDFaultCodeObj.Sequence__c = maxFltSeq;
                                APDFaultCodeObj.Order__c = OrderSeq;
                                OrderSeq++;                                                 
                                //insInAPDFaultCodes.add(APDFaultCodeObj);
                                listOfFaultCodes.add(APDFaultCodeObj);
                                
                                //CT3-269, Dinesh Yadav
                                if(string.isBlank(strFaultCodeNames))
                                    strFaultCodeNames = APDFaultCodeObj.Name;
                                else if(strFaultCodeNames.contains(APDFaultCodeObj.Name) == false)
                                    strFaultCodeNames = strFaultCodeNames +','+APDFaultCodeObj.Name;
                            }
                        }
                    }
                    mpAPD_P.clear();
                    mpAPD_R.clear();
                    faultCodeAPD_R.clear();
                    faultCodeAPD_P.clear();
                }
                // 3rd - Get all BPD Fault Codes and prepare List for Creation
                //if(wo1.module[i].FD.BPD != null){
                // lstFaultCodeBPD.add(string.valueOf(wo1.module[i].FD.BPD));
                // }
                if(wo1.module[i].FD.BPD != null){
                    for(integer n=0;n<wo1.module[i].FD.BPD.size();n++){
                        //string s = a.remove('(').removeEnd(')');
                        //list<string>s1 = s.split(',');
                        faultCodeBPD.add(string.valueOf(wo1.module[i].FD.BPD[n]));
                    }
                }
                list<CSS_Fault_Code__c> insInBPDFaultCodes = new list<CSS_Fault_Code__c>();
                for(integer o=0;o<faultCodeBPD.size();o++){
                    CSS_Fault_Code__c BPDFaultCodeObj = new CSS_Fault_Code__c();
                    BPDFaultCodeObj.Name = /*'BPD '*/ + faultCodeBPD[o];
                    BPDFaultCodeObj.ECM__c = mapECMVal.get(ecmKey);
                    //BPDFaultCodeObj.Job_Order__c = lstJobOrder.Id;
                    if(lstJobOrder != null){
                        BPDFaultCodeObj.Job_Order__c = lstJobOrder.Id;
                    }
                    if(serviceOrder!=null){
                        BPDFaultCodeObj.Service_Order__c = serviceOrder.id;
                    }
                    if(mapFDMeta.containsKey(faultCodeBPD[o].trim())){
                        List<String> strList = mapFDMeta.get(faultCodeBPD[o].trim()).split(';');
                        BPDFaultCodeObj.Count__c = Decimal.valueOf(strList[0]);
                        BPDFaultCodeObj.Status__c = strList[1];
                    }                                  
                    //BPDFaultCodeObj.Fault_Code__c = BPDFaultCodeMap.get(faultCodeBPD[o]);
                    //BPDFaultCodeObj.Image_Name__c = wo1.FaultCode[i].IMGNM;
                    BPDFaultCodeObj.Mod__c = wo1.module[i].mod;
                    BPDFaultCodeObj.PAT__c = wo1.module[i].PAT;
                    BPDFaultCodeObj.Fault_Code_Type__c = 'BPD'; 
                    BPDFaultCodeObj.FaultCodeR2__c = faultCodeBPD[o];
                    BPDFaultCodeObj.Sequence__c = maxFltSeq;
                    BPDFaultCodeObj.Order__c = OrderSeq;
                    OrderSeq++;                                                      
                    //insInBPDFaultCodes.add(BPDFaultCodeObj);
                    listOfFaultCodes.add(BPDFaultCodeObj);
                    
                    //CT3-269, Dinesh Yadav
                    if(string.isBlank(strFaultCodeNames))
                        strFaultCodeNames = BPDFaultCodeObj.Name;
                    else if(strFaultCodeNames.contains(BPDFaultCodeObj.Name) == false)
                        strFaultCodeNames = strFaultCodeNames +','+BPDFaultCodeObj.Name;
                }

                //4th - Get all UFD - UPA Codes and prepare List for Creation
                if(wo1.module[i].FD.UFD != null){
                    if(wo1.module[i].FD.UFD.UPA != null){
                        for(integer p=0;p<wo1.module[i].FD.UFD.UPA.size();p++){
                            faultCodeUPA.add(wo1.module[i].FD.UFD.UPA[p]);
                        }                                    
                    }                                    
                    if(wo1.module[i].FD.UFD.UPI != null){
                        for(integer r=0;r<wo1.module[i].FD.UFD.UPI.size();r++){
                            faultCodeUPI.add(wo1.module[i].FD.UFD.UPI[r]);
                        }                                    
                    }
                }

                list<CSS_Fault_Code__c> insInUPAFaultCodes = new list<CSS_Fault_Code__c>();
                for(integer q=0;q<faultCodeUPA.size();q++){
                    CSS_Fault_Code__c UFDFaultCodeObj = new CSS_Fault_Code__c();
                    UFDFaultCodeObj.Name = /*'UFD - UPA '*/+faultCodeUPA[q];
                    UFDFaultCodeObj.ECM__c = mapECMVal.get(ecmKey);
                    // UFDFaultCodeObj.Job_Order__c = lstJobOrder.Id;
                    if(lstJobOrder != null){
                        UFDFaultCodeObj.Job_Order__c = lstJobOrder.Id;
                    }
                    if(serviceOrder!=null){
                        UFDFaultCodeObj.Service_Order__c = serviceOrder.id;
                    }
                    if(mapFDMeta.containsKey(faultCodeUPA[q].trim())){
                        List<String> strList = mapFDMeta.get(faultCodeUPA[q].trim()).split(';');
                        UFDFaultCodeObj.Count__c = Decimal.valueOf(strList[0]);
                        UFDFaultCodeObj.Status__c = strList[1];
                    }                                     
                    //UFDFaultCodeObj.Fault_Code__c = UPAFaultCodeMap.get(faultCodeUPA[q]);
                    //UFDFaultCodeObj.Image_Name__c = wo1.FaultCode[0].IMGNM;
                    UFDFaultCodeObj.Mod__c = wo1.module[i].mod;
                    UFDFaultCodeObj.PAT__c = wo1.module[i].PAT;
                    UFDFaultCodeObj.Fault_Code_Type__c = 'UPA';
                    UFDFaultCodeObj.FaultCodeR2__c = faultCodeUPA[q];
                    UFDFaultCodeObj.Sequence__c = maxFltSeq;       
                    UFDFaultCodeObj.Order__c = OrderSeq;
                    OrderSeq++;                                        
                    //insInUPAFaultCodes.add(UFDFaultCodeObj);
                    listOfFaultCodes.add(UFDFaultCodeObj);
                    
                    //CT3-269, Dinesh Yadav
                    if(string.isBlank(strFaultCodeNames))
                        strFaultCodeNames = UFDFaultCodeObj.Name;
                    else if(strFaultCodeNames.contains(UFDFaultCodeObj.Name) == false)
                        strFaultCodeNames = strFaultCodeNames +','+UFDFaultCodeObj.Name;
                }
                //5th - Get all UFD - UPA Codes and prepare List for Creation
                list<CSS_Fault_Code__c> insInUPIFaultCodes = new list<CSS_Fault_Code__c>();
                for(integer t=0;t<faultCodeUPI.size();t++){
                    CSS_Fault_Code__c UFDFaultCodeObj = new CSS_Fault_Code__c();
                    UFDFaultCodeObj.Name = /*'UFD - UPI '*/+faultCodeUPI[t];
                    UFDFaultCodeObj.ECM__c = mapECMVal.get(ecmKey);
                    //UFDFaultCodeObj.Job_Order__c = lstJobOrder.Id;
                    if(lstJobOrder != null){
                        UFDFaultCodeObj.Job_Order__c = lstJobOrder.Id;
                    }
                    if(serviceOrder!=null){
                        UFDFaultCodeObj.Service_Order__c = serviceOrder.id;
                    }
                    if(mapFDMeta.containsKey(faultCodeUPI[t].trim())){
                        List<String> strList = mapFDMeta.get(faultCodeUPI[t].trim()).split(';');
                        UFDFaultCodeObj.Count__c = Decimal.valueOf(strList[0]);
                        UFDFaultCodeObj.Status__c = strList[1];
                    }                                 
                    //UFDFaultCodeObj.Fault_Code__c = UPIFaultCodeMap.get(faultCodeUPI[t]);
                    //UFDFaultCodeObj.Image_Name__c = wo1.FaultCode[0].IMGNM;
                    UFDFaultCodeObj.Mod__c = wo1.module[i].mod;
                    UFDFaultCodeObj.PAT__c = wo1.module[i].PAT;
                    UFDFaultCodeObj.Fault_Code_Type__c = 'UPI';
                    UFDFaultCodeObj.FaultCodeR2__c = faultCodeUPI[t];
                    UFDFaultCodeObj.Sequence__c = maxFltSeq;
                    UFDFaultCodeObj.Order__c = OrderSeq;
                    OrderSeq++;                                                           
                    //insInUPIFaultCodes.add(UFDFaultCodeObj);
                    listOfFaultCodes.add(UFDFaultCodeObj);
                    
                    //CT3-269, Dinesh Yadav
                    if(string.isBlank(strFaultCodeNames))
                        strFaultCodeNames = UFDFaultCodeObj.Name;
                    else if(strFaultCodeNames.contains(UFDFaultCodeObj.Name) == false)
                        strFaultCodeNames = strFaultCodeNames +','+UFDFaultCodeObj.Name;
                }
                if(wo1.module[i].FD.APD == null && wo1.module[i].FD.BPD == null && (wo1.module[i].FD.UFD == null || (wo1.module[i].FD.UFD.UPA == null && wo1.module[i].FD.UFD.UPI == null)) ){
                    //list<CSS_Fault_Code__c> insInBPDFaultCodes = new list<CSS_Fault_Code__c>();
                    // for(integer o=0;o<faultCodeBPD.size();o++){

                    BlankFaultCode.Name = 'Blank '  ;
                    BlankFaultCode.ECM__c = mapECMVal.get(ecmKey);
                    //BlankFaultCode.Job_Order__c = lstJobOrder.Id;//Commented by sravanthi
                    if(lstJobOrder != null){
                        BlankFaultCode.Job_Order__c = lstJobOrder.Id;
                    }
                    if(serviceOrder!=null){
                        BlankFaultCode.Service_Order__c = serviceOrder.id;
                    }
                    BlankFaultCode.Mod__c = wo1.module[i].mod;
                    BlankFaultCode.PAT__c = wo1.module[i].PAT;
                    BlankFaultCode.Fault_Code_Type__c = 'Blank';
                    BlankFaultCode.FaultCodeR2__c = 'Blank';
                    BlankFaultCode.Sequence__c = maxFltSeq;
                    BlankFaultCode.Order__c = OrderSeq;
                    OrderSeq++;       
                    listOfFaultCodes.add(BlankFaultCode);                                               
                    //insInBPDFaultCodes.add(BPDFaultCodeObj);
                }
                
                //CT3-269, Dinesh Yadav
                if(serviceOrder !=null){
                    if(serviceOrder.Fault_codes_Symptoms_Searched__c != null){
                        if(string.isNotBlank(strFaultCodeNames)){
                            String[] arrTest = strFaultCodeNames.split(',');
                            for(string strFCName : arrTest){
                                if(serviceOrder.Fault_codes_Symptoms_Searched__c.contains(strFCName)==false){
                                    serviceOrder.Fault_codes_Symptoms_Searched__c = serviceOrder.Fault_codes_Symptoms_Searched__c +','+strFCName;
                                }
                            }
                        }
                    }
                    else
                        serviceOrder.Fault_codes_Symptoms_Searched__c = strFaultCodeNames;
                }
                
                //serviceOrder.FSL_ABRFlag__c = wo1.ABRFlag != null?wo1.ABRFlag:false;
                //serviceOrder.FSL_TransactionID__c  =  wo1.TransactionID;
                // 6th - Insert the Fault Codes
                // For the First Time 
                if( (lstJobOrder != null && lstJobOrder.ESN_Locked__c == false) || (serviceOrder !=null && serviceOrder.ESN_Locked__c == false) ){
                    /*if(insInAPDFaultCodes.size()>0){
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
                    if(BlankFaultCode!=null){
                        insert BlankFaultCode;
                    }*/
                    if(listOfFaultCodes.size() > 0) {
                        insert listOfFaultCodes;
                    }
                    if(lstJobOrder != null){
                        update lstJobOrder;
                    }
                    if(serviceOrder !=null){
                        update serviceOrder;
                    }
                }
                // if CSS Insite ESN Matches WS Insite ESN
                else if( (lstJobOrder != null && lstJobOrder.ESN_Insite__c!=null && lstJobOrder.ESN_Locked__c == true && lstJobOrder.ESN_Insite__c ==wsESN) ||
                         (serviceOrder !=null && serviceOrder.ESN_Insite__c!=null && serviceOrder.ESN_Locked__c == true && serviceOrder.ESN_Insite__c ==wsESN)){
                    /*if(insInAPDFaultCodes.size()>0){
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
                    if(BlankFaultCode!=null){
                        insert BlankFaultCode;
                    }*/                    
                    if(listOfFaultCodes.size() > 0) {
                        insert listOfFaultCodes;
                    }
                    if(lstJobOrder != null){
                        update lstJobOrder;
                    }
                    if(serviceOrder !=null){
                        update serviceOrder;
                    }
                }
                //if CSS Insite ESN Doesn't Matches Insite ESN
                else if( (lstJobOrder != null && lstJobOrder.ESN_Insite__c!=null && lstJobOrder.ESN_Locked__c == true && lstJobOrder.ESN_Insite__c !=wsESN )
                            || (serviceOrder != null && serviceOrder.ESN_Insite__c!=null && serviceOrder.ESN_Locked__c == true && serviceOrder.ESN_Insite__c !=wsESN)){
                    if(lstJobOrder != null){
                        CSS_Job_Order__c cjo = new CSS_Job_Order__c();
                        cjo.id = lstJobOrder.Id;
                        cjo.Insite_ESN2__c = wsESN;
                        cjo.Insite_ESN2_Select__c = true;
                        update cjo;
                        //update lstJobOrder;
                    }
                    if(serviceOrder != null){
                        workorder wo = new workorder();
                        wo.id = serviceOrder.Id;
                        wo.Insite_ESN2__c = wsESN;
                        wo.Insite_ESN2_Select__c = true;
                        update wo;
                    }
                }
            }
            
            JSONResponseBody = '{ "Status":"OK", "TMS": "' + DateTime.now().format('yyyy-MM-dd', 'GMT')+ 'T' + DateTime.now().format('hh:mm:ss.SSS', 'GMT') + 'Z"}';
        }
        return abrTransObj;
    }
}