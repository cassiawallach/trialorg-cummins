@RestResource(urlMapping='/InsiteData/V01/CSS/WO/TEST/*')
global with sharing class CSS_receiveINSITEData_TEST{
//Gyan - Have appended the name _TEST to this class to ensure testing in Prod for INSITE team.    
    @HttpPut
    global static string updateJobOrderData(){
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
            JSONResponseBody = '{ "Status":"SendDataReceiptAcknowledgement", "Error_Code":"' + mpParams.get('RESPCODE') + '", "Error_Description":"SendDataReceiptAcknowledgement for CJOD-' + mpParams.get('CJOD') + '", "TMS": ' + DateTime.now() + '}';
            insIntegrationError(JSONResponseBody);
            return null;
        }
        else
        {
            jSONRequestBody = req.requestBody.toString().trim(); 
            System.debug (jSONRequestBody);
            try{
            //Added 4-Nov-2015
            
            
            //CSS_INSITEJSON2Apex wo = (CSS_INSITEJSON2Apex)JSON.deserializeStrict(jSONRequestBody,CSS_INSITEJSON2Apex.class);
            CSS_JSON2Apex wo1 = (CSS_JSON2Apex)JSON.deserializeStrict(jSONRequestBody,CSS_JSON2Apex.class);
            
            
            //Fetch the Job Order from Salesforce based on the parameter passed on the URL
            list<CSS_Job_Order__c> lstJobOrder = [SELECT Id, Name, ESN__c, Status__c, Unit_Number__c From CSS_Job_Order__c WHERE Name =: wo1.CJOD];
            System.debug('lstJobOrder========>>>>>>'+lstJobOrder);
            
            if(!lstJobOrder.isEmpty()){
                if(lstJobOrder[0].Status__c == 'Closed'){
                    JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01002", "Error_Description":"CSS JOB Status Closed", "TMS": ' + DateTime.now() + '}';
                    insIntegrationError(JSONResponseBody);
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
                    lstJobOrder[0].ESN__c = wo1.ESN;
                    lstJobOrder[0].Unit_Number__c = wo1.UNT;
                    //lstJobOrder[0].Mileage__c = decimal.valueOf(wo.data.mileage);
                    
                    list<string> faultCodeAPD = new list<string>();
                    list<string> faultCodeAPD_P = new list<string>();
                    list<string> faultCodeAPD_R = new list<string>();
                    list<string> faultCodeBPD = new list<string>();
                    list<string> faultCodeUFD = new list<string>();
                    list<string> faultCodeUPA = new list<string>();
                    list<string> faultCodeUPI = new list<string>();
                    list<string> faultCodeUFD1 = new list<string>();           
                    list<string> faultCodeFD = new list<string>();
                    list<string> lstFaultCodeBPD = new list<string>();
                    list<string> lstFaultCodeUPA = new list<string>();
                    list<string> lstFaultCodeUPI = new list<string>();
                                     
                    for(integer i=0;i<wo1.faultCode.size();i++){                    
                        if(wo1.faultCode[i].FD.APD != null){
                            for(integer j=0;j<wo1.faultCode[i].FD.APD.size();j++){
                                faultCodeAPD_P.add(string.valueof(wo1.faultCode[i].FD.APD[j].P));                            
                            }                                                
                            /*
                            if(wo1.faultCode[i].FD.APD[i].P != null){
                                faultCodeAPD_P.add(string.valueOf(wo1.faultCode[i].FD.APD[i].P));                                 
                            }*/
                            
                            if(wo1.faultCode[i].FD.APD[i].R != null){
                                for(integer j=0;j<wo1.faultCode[i].FD.APD.size();j++){
                                    faultCodeAPD_R.add(string.valueOf(wo1.faultCode[i].FD.APD[j].R));                   
                                }                   
                            }
                        }
                        
                        if(wo1.faultCode[i].FD.BPD != null){
                            lstFaultCodeBPD.add(string.valueOf(wo1.faultCode[i].FD.BPD));
                        }
                        
                        if(wo1.faultCode[i].FD.UFD != null){
                            if(wo1.faultCode[i].FD.UFD.UPA != null){
                                lstFaultCodeUPA.add(string.valueOf(wo1.faultCode[i].FD.UFD.UPA));
                            }
                            
                            if(wo1.faultCode[i].FD.UFD.UPI != null){
                                lstFaultCodeUPI.add(string.valueOf(wo1.faultCode[i].FD.UFD.UPI));
                            }
                        }
                        //faultCodeUFD.add('UFD '+string.valueOf(wo1.faultCode[i].FD.UFD.UPA));
                        //system.debug('Value of UFDObj----->>>>'+wo1.faultCode[i].FD.UFD.UPA);
                        //system.debug('======>>>>>>>'+wo1.faultCode[i].FD.APD);
                    }
                    
                    system.debug('faultCodeFD*********'+faultCodeFD.size()+'>>>>>>>>>>>>'+faultCodeFD);
                                    
                    list<string> FD_APD_R = new list<string>();    
                                
                    for(integer i=0;i<faultCodeAPD_R.size();i++){
                        string s = faultCodeAPD_R[i].remove('(').removeEnd(')');
                        list<string> s1 = s.split(',');                    
                        FD_APD_R.addAll(s1);                    
                    }
                    for(integer i=0;i<lstFaultCodeBPD.size();i++){
                        string s = lstFaultCodeBPD[i].remove('(').removeEnd(')');
                        system.debug('-----Splitted BPD---->>>>>'+s);
                        list<string>s1 = s.split(',');
                        faultCodeBPD.addAll(s1);
                    }
                    
                     for(integer i=0;i<lstFaultCodeUPA.size();i++){
                        string s = lstFaultCodeUPA[i].remove('(').removeEnd(')');
                        system.debug('-----Splitted UPA---->>>>>'+s);
                        list<string>s1 = s.split(',');
                        faultCodeUPA.addAll(s1);
                    }                
                    
                    for(integer i=0;i<lstFaultCodeUPI.size();i++){
                        string s = lstFaultCodeUPI[i].remove('(').removeEnd(')');
                        system.debug('-----Splitted UPI---->>>>>'+s);
                        list<string>s1 = s.split(',');
                        faultCodeUPI.addAll(s1);
                    }
                    
                    system.debug('faultCodeAPD_P*********'+faultCodeAPD_P);
                    system.debug('faultCodeAPD_R*********'+faultCodeAPD_R);
                    
                    system.debug('List of APD codes=====>>>>>'+faultCodeAPD_P); 
                    system.debug('List of APD codes=====>>>>>'+faultCodeAPD_R);           
                    system.debug('List of BPD codes=====>>>>>'+faultCodeBPD);
                    system.debug('List of UFD codes=====>>>>>'+faultCodeUFD);
                    
                    Map<String,Id> APDFaultCodeMap_P = new Map<String,Id>();
                    if(!faultCodeAPD_P.isEmpty()){
                        list<CSS_Fault_Code_Master__c> APDFaultCode = getFaultCodes(faultCodeAPD_P);                
                        for(CSS_Fault_Code_Master__c f:APDFaultCode){
                            APDFaultCodeMap_P.put(f.Name,f.Id);
                        }
                    }
                    
                    Map<String,Id> APDFaultCodeMap_R = new Map<String,Id>();
                    if(!FD_APD_R.isEmpty()){
                        list<CSS_Fault_Code_Master__c> APDFaultCode = getFaultCodes(FD_APD_R);                
                        for(CSS_Fault_Code_Master__c f:APDFaultCode){
                            APDFaultCodeMap_R.put(f.Name,f.Id);
                        }
                    }                 
                    
                    
                    Map<String,Id> BPDFaultCodeMap = new Map<String,Id>();
                    if(!faultCodeBPD.isEmpty()){
                        list<CSS_Fault_Code_Master__c> BPDFaultCode = getFaultCodes(faultCodeBPD);                
                        if(BPDFaultCode != null)
                        for(CSS_Fault_Code_Master__c f:BPDFaultCode){
                            BPDFaultCodeMap.put(f.Name,f.Id);
                        }
                    }
                    
                    /*Map<String,Id> UFDFaultCodeMap = new Map<String,Id>();
                    if(!faultCodeUFD.isEmpty()){
                        list<CSS_Fault_Code_Master__c> UFDFaultCode = getFaultCodes(faultCodeUFD);                
                        for(CSS_Fault_Code_Master__c f:UFDFaultCode){
                            UFDFaultCodeMap.put(f.Name,f.Id);
                        }
                    }*/
                    
                    Map<String,Id> UPAFaultCodeMap = new Map<String,Id>();
                    if(!faultCodeUPA.isEmpty()){
                        list<CSS_Fault_Code_Master__c> UPAFaultCode = getFaultCodes(faultCodeUPA);                
                        for(CSS_Fault_Code_Master__c f:UPAFaultCode){
                            UPAFaultCodeMap.put(f.Name,f.Id);
                        }
                    }
                    
                    Map<String,Id> UPIFaultCodeMap = new Map<String,Id>();
                    if(!faultCodeUPI.isEmpty()){
                        list<CSS_Fault_Code_Master__c> UPIFaultCode = getFaultCodes(faultCodeUPI);                
                        for(CSS_Fault_Code_Master__c f:UPIFaultCode){
                            UPIFaultCodeMap.put(f.Name,f.Id);
                        }
                    }
                    
                    list<CSS_Fault_Code__c> insInAPDFaultCodes = new list<CSS_Fault_Code__c>();
                    for(integer i=0;i<faultCodeAPD_P.size();i++){
                        CSS_Fault_Code__c APDFaultCodeObj = new CSS_Fault_Code__c();
                        APDFaultCodeObj.Name = 'APD - P '+faultCodeAPD_P[i];//string.valueOf(wo1.faultCode[i].FD.APD[i].P);
                        APDFaultCodeObj.Job_Order__c = lstJobOrder[0].Id;
                        APDFaultCodeObj.Fault_Code__c = APDFaultCodeMap_P.get(faultCodeAPD_P[i]);
                        APDFaultCodeObj.Image_Name__c = wo1.FaultCode[0].IMGNM;
                        APDFaultCodeObj.Mod__c = wo1.FaultCode[0].Mod;
                        APDFaultCodeObj.PAT__c = wo1.FaultCode[0].PAT;
                        APDFaultCodeObj.Fault_Code_Type__c = 'APD-P';
                        APDFaultCodeObj.Sequence__c = maxFltSeq;
                        insInAPDFaultCodes.add(APDFaultCodeObj);
                    }
                    
                    for(integer i=0;i<FD_APD_R.size();i++){
                        CSS_Fault_Code__c APDFaultCodeObj = new CSS_Fault_Code__c();
                        APDFaultCodeObj.Name = 'APD - R ' + FD_APD_R[i];//string.valueOf(wo1.faultCode[i].FD.APD[i].R);
                        APDFaultCodeObj.Job_Order__c = lstJobOrder[0].Id;
                        APDFaultCodeObj.Fault_Code__c = APDFaultCodeMap_R.get(FD_APD_R[i]);
                        APDFaultCodeObj.Image_Name__c = wo1.FaultCode[0].IMGNM;
                        APDFaultCodeObj.Mod__c = wo1.FaultCode[0].Mod;
                        APDFaultCodeObj.PAT__c = wo1.FaultCode[0].PAT;
                        APDFaultCodeObj.Fault_Code_Type__c = 'APD-R';
                        APDFaultCodeObj.Sequence__c = maxFltSeq;
                        insInAPDFaultCodes.add(APDFaultCodeObj);
                    }
                    
                    
                    list<CSS_Fault_Code__c> insInBPDFaultCodes = new list<CSS_Fault_Code__c>();
                    for(integer i=0;i<faultCodeBPD.size();i++){
                        CSS_Fault_Code__c BPDFaultCodeObj = new CSS_Fault_Code__c();
                        BPDFaultCodeObj.Name = faultCodeBPD[i];
                        BPDFaultCodeObj.Job_Order__c = lstJobOrder[0].Id;
                        BPDFaultCodeObj.Fault_Code__c = BPDFaultCodeMap.get(faultCodeBPD[i]);
                        BPDFaultCodeObj.Image_Name__c = wo1.FaultCode[0].IMGNM;
                        BPDFaultCodeObj.Mod__c = wo1.FaultCode[0].Mod;
                        BPDFaultCodeObj.PAT__c = wo1.FaultCode[0].PAT;
                        BPDFaultCodeObj.Fault_Code_Type__c = 'BPD';
                        BPDFaultCodeObj.Sequence__c = maxFltSeq;
                        insInBPDFaultCodes.add(BPDFaultCodeObj);
                    }
                    
                    list<CSS_Fault_Code__c> insInUPAFaultCodes = new list<CSS_Fault_Code__c>();
                    for(integer i=0;i<faultCodeUPA.size();i++){
                        CSS_Fault_Code__c UFDFaultCodeObj = new CSS_Fault_Code__c();
                        UFDFaultCodeObj.Name = 'UFD - UPA '+faultCodeUPA[i];
                        UFDFaultCodeObj.Job_Order__c = lstJobOrder[0].Id;
                        UFDFaultCodeObj.Fault_Code__c = UPAFaultCodeMap.get(faultCodeUPA[i]);
                        UFDFaultCodeObj.Image_Name__c = wo1.FaultCode[0].IMGNM;
                        UFDFaultCodeObj.Mod__c = wo1.FaultCode[0].Mod;
                        UFDFaultCodeObj.PAT__c = wo1.FaultCode[0].PAT;
                        UFDFaultCodeObj.Fault_Code_Type__c = 'UPA';
                        UFDFaultCodeObj.Sequence__c = maxFltSeq;
                        insInUPAFaultCodes.add(UFDFaultCodeObj);
                    }
                    
                    list<CSS_Fault_Code__c> insInUPIFaultCodes = new list<CSS_Fault_Code__c>();
                    for(integer i=0;i<faultCodeUPI.size();i++){
                        CSS_Fault_Code__c UFDFaultCodeObj = new CSS_Fault_Code__c();
                        UFDFaultCodeObj.Name = 'UFD - UPI '+faultCodeUPI[i];
                        UFDFaultCodeObj.Job_Order__c = lstJobOrder[0].Id;
                        UFDFaultCodeObj.Fault_Code__c = UPIFaultCodeMap.get(faultCodeUPI[i]);
                        UFDFaultCodeObj.Image_Name__c = wo1.FaultCode[0].IMGNM;
                        UFDFaultCodeObj.Mod__c = wo1.FaultCode[0].Mod;
                        UFDFaultCodeObj.PAT__c = wo1.FaultCode[0].PAT;
                        UFDFaultCodeObj.Fault_Code_Type__c = 'UPI';
                        UFDFaultCodeObj.Sequence__c = maxFltSeq;
                        insInUPIFaultCodes.add(UFDFaultCodeObj);
                    }
                    
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
                                                   
                    JSONResponseBody = '{ "ver":"v01", "status":"ok", "TMS": ' + DateTime.now() + '}';
                }
                
            }
            else{
                JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01002", "Error_Description":"CSS JOB Not Found", "TMS": ' + DateTime.now() + '}';
                insIntegrationError(JSONResponseBody);
                
            }
            update lstJobOrder;
            }
            catch(Exception e){
                system.debug('Excepion======>>>>>'+e);
                system.debug('Excepion Line Number======>>>>>'+e.getLineNumber());
                if(e.getTypeName() == 'System.JSONException'){
                    JSONResponseBody = '{ "Status":"Error", "Error_Code":"CSS01001", "Error_Description":"Invalid JSON Schema", "TMS": ' + DateTime.now() + '}';
                    insIntegrationError(JSONResponseBody);
                }
                
            }
            
            return JSONResponseBody;
        }
    }
    
    
    //Fetch Active Codes
    global static list<CSS_Fault_Code_Master__c> getFaultCodes(list<string> faultCodes){
        system.debug('=====faultCodes====='+faultCodes);
        boolean flag = false;
        List<String> matchedCodes = new List<String>();
        set<String> unMatchedCodes = new set<String>();
        list<CSS_Fault_Code_Master__c> insLstFaultCodes = new list<CSS_Fault_Code_Master__c>();
        list<CSS_Fault_Code_Master__c> lstFaultCodes = [SELECT Id, Name FROM CSS_Fault_Code_Master__c WHERE Name IN: faultCodes ];
        system.debug('lstFaultCodes----->>>'+lstFaultCodes);
        list<CSS_Fault_Code_Master__c> finalCodes = new list<CSS_Fault_Code_Master__c>();
           for(integer i=0; i<faultCodes.size(); i++){  // 1,2,3,892,210
               for(integer j=0; j<lstFaultCodes.size();j++){   // 892,210
                  if(faultCodes[i].contains(lstFaultCodes[j].Name)){   
                        System.debug('===Matched==='+faultCodes[i]);
                        flag = true;
                    }
                }
                
                if(flag == true){
                    matchedCodes.add(faultCodes[i]);
                }else{
                    unMatchedCodes.add(faultCodes[i]);
                }
                
                flag = false;
            }
        system.debug('=====matchedCodes====='+matchedCodes);
        system.debug('=====unMatchedCodes====='+unMatchedCodes);
        if(!matchedCodes.isEmpty()){
            for(CSS_Fault_Code_Master__c f:[SELECT Id, Name FROM CSS_Fault_Code_Master__c WHERE Name IN: matchedCodes]){
                finalCodes.add(f);
            }
        }
        
        if(!unMatchedCodes.isEmpty()){
            for(String s:unMatchedCodes){
                CSS_Fault_Code_Master__c f = new CSS_Fault_Code_Master__c();
                f.Name = s;
                //f.Status__c = 'Active';
                insLstFaultCodes.add(f);
            }
        }
        
        if(!insLstFaultCodes.isEmpty()){
            insert insLstFaultCodes;
            finalCodes.addAll(insLstFaultCodes);
        }
        system.debug('======FinalCodes====>>>>>>>>'+finalCodes);
        return finalCodes;
    }
    
    
    
    global static void insIntegrationError(string errDesc){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Error_Description__c = errDesc;
        insert errObj;
    }
    
    
}