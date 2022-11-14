/**********************************************************************
Name: FSL_SRTEditPopupController
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                              
-------  
Changed this class to call GetAllSRTs class and store the values in the FSL Add SRT (Temporary object) 
on click of Go in the all SRTS Popup(Ex: Add Daignostic etc...) inthe Job plan SRT section.
======================================================
======================================================
History                                               
-------                                                            
VERSION  AUTHOR                     DATE             Detail                      
2.0     Ravikanth Macherla         12/16/2019         Pilot + 
***********************************************************************/
public class FSL_SRTEditPopupController {
    @AuraEnabled
    public static List<String> getSRTGroupDesc(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = FSL_SRT__c.SRT_Group_Desc__c.getDescribe();
        List<Schema.PicklistEntry> pickList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pickList) {
            options.add(p.getLabel());
        }
        return options;
    }
    
    @AuraEnabled
    public static List<FSL_SRT__c> fetchSRTCodes(String workOrderId, String srtType) {
        String typeSRT;
        String typeSRTAccess;
        if(srtType == 'Diagnostic') {
            typeSRT = 'Diagnosis';
            typeSRTAccess = 'Diag Access';
        } else if(srtType == 'Repair'){
            typeSRT = 'Repair';
            typeSRTAccess = 'Repair Access';
        } else if(srtType == 'Field Actions') {
            typeSRT = 'Field Action';
            typeSRTAccess = 'Field Action Access';
        } else {
            typeSRT = null;
        }
        System.debug('::: SRT Code Fetch Called = '+workOrderId+' and '+srtType);
        List<FSL_SRT__c> SRTList = new List<FSL_SRT__c>();
        SRTList = [Select Id, Name FROM FSL_SRT__c where Service_Order__c=:workOrderId AND (Type__c=:typeSRT OR Type__c=:typeSRTAccess)];
        return SRTList;
    }
    
    //Code Starts here added by Ravikanth to call GETALLSRTINTEGRSTION
    @AuraEnabled
    public static List<FSL_Add_SRT__c> getSRTSearchResultInsert(String config, String pCode, String pGroup, String WORecordId) {
        list<FSL_Add_SRT__c> lstsrts = new list<FSL_Add_SRT__c>();
        boolean doQuery = false;
        String SearchQueryString ;
        ConfigWrapper configWrap = (ConfigWrapper)JSON.deserialize(config, ConfigWrapper.class);
        String pGroupCode='%';
        String strPcode ='%';
        List<String> configList = new List<String>();
        for(Config c : configWrap.Config) {
            if(c.isChecked){
                configList.add(c.type);
            }
        }
        System.debug(':::WORecordId = '+WORecordId);
        if(!String.isEmpty(pGroup)) {
            pGroupCode = pGroup.left(2)+'%';
        }
        if(!String.isEmpty(pCode)){
            strPcode = pCode+'%';
        }
        
        try {
            WorkOrder wo=[SELECT asset.Equipment_Id__c, asset.Engine_Family_Code__c, asset.Service_Model__c FROM workorder WHERE id=: WORecordId];
            lstsrts =[SELECT name,SRT_Type__c,Equipment_Id__c,StepId__c,SRT_DESCRIPTION__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c FROM FSL_Add_SRT__c WHERE Equipment_Id__c = :wo.asset.Equipment_Id__c AND Service_Model__c=:wo.asset.Service_Model__c AND Engine_Family_Code__c =:wo.asset.Engine_Family_Code__c];
            
            FSLSRTIntegrationWrappers.SRTLookupDataAreaList fsrts = runSRTLookupInterface(wo);
            
            if(lstsrts.isEmpty()){  
                system.debug('insideifff--->');
                
                
                for(FSLSRTIntegrationWrappers.SRTLookupDataArea da : fsrts.DataArea) {
                    
                    FSL_Add_SRT__c objsrt = new FSL_Add_SRT__c();
                    objsrt.Name = da.SRTNumber;
                    objsrt.SRT_Type__c = da.SRTType;
                    objsrt.SRT_DESCRIPTION__c = da.SRTTitle ;
                    objsrt.Equipment_Id__c = wo.asset.Equipment_Id__c;
                    objsrt.Service_Model__c=wo.asset.Service_Model__c;
                    objsrt.StepId__c=da.StepID;
                    objsrt.Engine_Family_Code__c =wo.asset.Engine_Family_Code__c;
                    if(da.ATime !=null){
                        objsrt.Access_Code_A__c = Decimal.valueOf(da.ATime);
                    }
                    if(da.BTime !=null){
                        objsrt.Access_Code_B__c = Decimal.valueOf(da.BTime);
                    }
                    if(da.CTime !=null){
                        objsrt.Access_Code_C__c =Decimal.valueOf( da.CTime);
                    }
                    if(da.DTime !=null){
                        objsrt.Access_Code_D__c =Decimal.valueOf( da.DTime);
                    }
                    if(da.RTime !=null){
                        objsrt.Access_Code_R__c =Decimal.valueOf( da.RTime);
                    }
                    lstsrts.add(objsrt);
                }
                database.insert(lstsrts,false);
                //  insert lstsrts;
                system.debug('lstsrts--->'+lstsrts);
            }
           // else{  //Charan--Removed else condition for Phoen-220 bug 
                if(lstsrts.size()>0){
                    system.debug('check--->'+lstsrts.size());
                    lstsrts.clear();
                    lstsrts =[SELECT Name,SRT_Type__c,Equipment_Id__c,StepId__c,SRT_DESCRIPTION__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c, Access_Code_R__c 
                              FROM FSL_Add_SRT__c 
                              WHERE Equipment_Id__c = :wo.asset.Equipment_Id__c 
                              AND Service_Model__c=:wo.asset.Service_Model__c 
                              AND Engine_Family_Code__c =:wo.asset.Engine_Family_Code__c 
                              AND SRT_Type__c IN : configList 
                              AND Name LIKE :pGroupCode 
                              AND (Name LIKE :strPcode 
                                   OR SRT_DESCRIPTION__c LIKE :'%'+strPcode+'%')];
                }
            //}
        }
        catch(exception e){
            system.debug('exception reason'+e); 
        } 
        return lstsrts ;
    }
    
    public static FSLSRTIntegrationWrappers.SRTLookupDataAreaList runSRTLookupInterface(WorkOrder wo )
    {
        string endPoint;
        Integer timeout;
        String method;
        CSS_Integration_Details__c csi;
        if(CSS_Integration_Details__c.getall().containsKey('CG_GETAllSRT'))
            csi=CSS_Integration_Details__c.getInstance('CG_GETAllSRT');
        if(csi != null)
        {
            if(!Test.isRunningTest()) {
                endPoint=csi.End_Point__c;
                timeout = Integer.valueOf(csi.Timeout__c);
                method = csi.Method_Type__c;
             }
            else{
                endPoint = 'https://services-test.cummins.com/css/srtlookup';
                timeout =0;
                method='put';
            }
            //commented below line to use the mule version of calling mechanism -by vinod 8/31
            /*String authType='BEARER';
            String token = 'Bearer '+FSL_WS_OAG.getAccessToken();
            String method=csi.Method_Type__c;
            List<String> contentHdrs=new List<String>{'Content-Type','application/json'};*/
            String reqBody;
            FSLSRTIntegrationWrappers fsrt=new FSLSRTIntegrationWrappers();
            FSLSRTIntegrationWrappers.RequestHeader reqHdr = new FSLSRTIntegrationWrappers.RequestHeader();
            reqHdr.Sender.ServiceName = 'GetAllSRT';
            reqHdr.Sender.SenderID='CSS';
            reqHdr.Target.TargetID='SRT';
            FSLSRTIntegrationWrappers.DataArea da = new FSLSRTIntegrationWrappers.DataArea();
            datetime currentDate = System.now();
            string currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00'; 
            da.EffectiveDTTime=currDate;
            da.Languagecode='en';
            da.EngineFamilyCode=wo.asset.Engine_Family_Code__c;
            da.ServiceModelName=wo.asset.Service_Model__c;
            da.EquipmentID=wo.asset.Equipment_Id__c;
            da.SRTType='';
            
            fsrt.DataArea = da;
            fsrt.Header= reqHdr;
            system.debug('::: PR FSRT = '+fsrt);
            //commented below line to use the mule version of calling mechanism -by vinod 8/31
            /*Integer timeout;
            if(csi.Timeout__c != null && csi.Timeout__c > 0)
                timeout = Integer.valueOf(csi.Timeout__c);
            else 
                timeout=12000;
            system.debug('::: JSON.serialize(fsrt) = '+JSON.serialize(fsrt));
            HttpRequest httpReq = FSLCumminsServiceUtility.createHttpRequest(endPoint, authType, token, method, contentHdrs, JSON.serialize(fsrt), timeout);
            system.debug('httpReq ::'+httpReq);
            HttpResponse resp = FSLCumminsServiceUtility.sendHttpRequest(httpReq);*/
            //changed method signature to make use of newer mule & return type.
            CG_IP_OAGWrapper reqWrapper = FSLCumminsServiceUtility.createHttpRequest('CG_GETAllSRT',endPoint, method, JSON.serialize(fsrt), timeout);
            CG_OP_OAGWrapper outputWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            HttpResponse resp = outputWrapper.response;//Ends mule changes
            system.debug('RESPONSEEEE '+resp);
            //system.debug('::: PR RESP = '+resp.getBody());
            if(resp != null && resp.getStatusCode() == 200 && String.isNotBlank(resp.getBody()))
            {               
                FSLSRTIntegrationWrappers.SRTLookupDataAreaList fsrtResp=
                    (FSLSRTIntegrationWrappers.SRTLookupDataAreaList)JSON.deserialize(resp.getBody(), FSLSRTIntegrationWrappers.SRTLookupDataAreaList.Class);
                system.debug('::: PR FSRTRESP = '+fsrtResp);
                return fsrtResp;
            } else{
                if(Test.isRunningTest())
                {
                    //String fsrtsBody = '{   "Header":{     "Status":"SUCCESS",     "ReturnCode":"",     "ReturnCodeDescription":"",     "MessageIdentifier":"debc5930-3a95-4420-bb8c-2695f4398614",     "MessageType":"S"   },   "DataArea":{"Languagecode":"EN","EngineFamilyCode":"10","ServiceModelName":"test","SRTType":"REP"} }';
                    string fsrtsbody = '{   "Header":{     "ReturnCode":"ORA-00000",     "ReturnCodeDescription":"Normal, Successful completion.",     "MessageIdentifier":"S"   },   "DataArea":[     {       "SRTFamily":"",       "ComponentType":"",       "BTime":0,       "SRTNumber":"00-00C-00",       "CTime":0,       "PrivateFlag":"N",       "Regions":"",       "SRTTitle":"Ancillary OEM Components (Freightliner M2)",       "SRTCategory":"",       "StepID":138558,       "RTime":1.4,       "ATime":0,       "SRTType":"Admin",       "DTime":1.4,       "ECMFlag":"N",       "FlexSRT":"N"     },     {       "SRTFamily":"",       "ComponentType":"",       "BTime":0,       "SRTNumber":"00-724-00",       "CTime":0,       "PrivateFlag":"N",       "Regions":"",       "SRTTitle":"INSITE - Use During Troubleshooting",       "SRTCategory":"General, Miscellaneous",       "StepID":47415,       "RTime":1.2,       "ATime":0,       "SRTType":"Admin",       "DTime":1.2,       "ECMFlag":"N",       "FlexSRT":"N"     },     {       "SRTFamily":"",       "ComponentType":"",       "BTime":0,       "SRTNumber":"00-801-00",       "CTime":0,       "PrivateFlag":"N",       "Regions":"",       "SRTTitle":"Engine - Maintenance Daily Check",       "SRTCategory":"Service, Maintenance, Contract Repair",       "StepID":19492,       "RTime":0,       "ATime":0,       "SRTType":"Admin",       "DTime":0.2,       "ECMFlag":"N",       "FlexSRT":"N"     }   ] }';
                        FSLSRTIntegrationWrappers.SRTLookupDataAreaList fsrtResp=
                        (FSLSRTIntegrationWrappers.SRTLookupDataAreaList)JSON.deserialize(fsrtsBody, FSLSRTIntegrationWrappers.SRTLookupDataAreaList.Class);
                    return fsrtResp;
                }
                else 
                return null;
            }
        }
        else 
            return null;
    } //Ravikanth Code Ends here
    // Added by mallika  
    @AuraEnabled
    public static void saveSRT(String SRTAdd,Id serviceOrderId,String srtType) {
        system.debug('Testing###'+SRTAdd+ 'Testing 111####'+serviceOrderId +'Type'+srtType);
        List<FSL_SRT__c> fslSRT = new List<FSL_SRT__c>();
        List<Id> fslSrtIds = new List<Id>();
        List<FSL_Add_SRT__c> addFslSRT =   (List<FSL_Add_SRT__c>)System.JSON.deserialize(SRTAdd, List<FSL_Add_SRT__c>.class);
        Id fslSRTRecordTypeId = Schema.SObjectType.FSL_SRT__c.getRecordTypeInfosByName().get('FSL SRT').getRecordTypeId();        
        Id faSRTRecordTypeId = Schema.SObjectType.FSL_SRT__c.getRecordTypeInfosByName().get('FA SRT').getRecordTypeId(); 
        //Added by Ravikanth
        WorkOrder wo = [SELECT Id, Asset.Make__c, Asset.Model__c, Asset.Equipment_Id__c, Asset.Engine_Family_Code__c, Asset.Engine_Family__c, Asset.Service_Model__c, WorkOrderNumber,Type__c FROM WorkOrder WHERE Id=:serviceOrderId];
        List<CSS_Make_Model_Access__c> cssMakeModelAccs;
        CSS_Make_Model_Access__c cssMakeModelAcc ;
        cssMakeModelAccs= [SELECT Id, Access__c FROM CSS_Make_Model_Access__c 
                           WHERE Make__c =: wo.Asset.Make__c 
                           AND Model__c =: wo.Asset.Model__c 
                           AND EngineFamilyCode__c =: wo.Asset.Engine_Family_Code__c LIMIT 1];
        if(cssMakeModelAccs != null && cssMakeModelAccs.size() == 1) {
            cssMakeModelAcc = cssMakeModelAccs[0];
        }//Ravikanth end here
        
        for(FSL_Add_SRT__c addSrtRec:addFslSRT) {
            
            //Ravikanth Code start here
            Decimal srtTm;
            String srtAccessCode;
            Boolean booleanR = FALSE;
            if(cssMakeModelAcc!=null && cssMakeModelAcc.Access__c == 'A' && addSrtRec.Access_Code_A__c != null) {
                srtTm = addSrtRec.Access_Code_A__c;
            }
            else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'B' && addSrtRec.Access_Code_B__c != null) {
                srtTm = addSrtRec.Access_Code_B__c;
            }
            else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'C' && addSrtRec.Access_Code_C__c != null ) {
                srtTm = addSrtRec.Access_Code_C__c;
            }
            else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'D' && addSrtRec.Access_Code_D__c != null) {
                srtTm = addSrtRec.Access_Code_D__c;
            }
            else if(cssMakeModelAcc != null && cssMakeModelAcc.Access__c == 'R' && addSrtRec.Access_Code_R__c != null) {
                srtTm = addSrtRec.Access_Code_R__c;
                booleanR = TRUE;
            }
            
            if(srtTm == null || srtTm == 0.0) {
                srtAccessCode = 'R';
                srtTm = addSrtRec.Access_Code_R__c;
                booleanR = TRUE;
            }
            else if(cssMakeModelAcc != null) {
                srtAccessCode = cssMakeModelAcc.Access__c;
            }
            //Ravikanth code end here
            
            system.debug('AccesscodeR'+addSrtRec.Access_Code_R__c);
            FSL_SRT__c srtRec = new FSL_SRT__c();
            if(addSrtRec.SRT_Type__c == 'Access') {
                srtRec.Name = addSrtRec.Name;
                if(srtType == 'Diagnosis') {
                    srtRec.Type__c = 'Diag Access';
                }
                else if(srtType == 'Repair') {
                    srtRec.Type__c = 'Repair Access';
                }
                else if(srtType == 'Field Action') {
                    srtRec.Type__c = 'Field Action Access';
                }
                srtRec.Service_Order__c = serviceOrderId;
                if(srtType == 'Field Action') {
                    srtRec.RecordTypeId = faSRTRecordTypeId;
                }
                else {
                    srtRec.RecordTypeId = fslSRTRecordTypeId;
                }
                          
                srtRec.SRT_Title__c = addSrtRec.SRT_DESCRIPTION__c;
                srtRec.Access_Code_A__c = addSrtRec.Access_Code_A__c ;
                srtRec.Access_Code_B__c = addSrtRec.Access_Code_B__c;
                srtRec.Access_Code_C__c = addSrtRec.Access_Code_C__c;
                srtRec.Access_Code_D__c = addSrtRec.Access_Code_D__c;
                srtRec.Access_Code_R__c = addSrtRec.Access_Code_R__c;
                srtRec.Use_R_Time__c = booleanR;
                srtRec.SRT_Time__c = srtTm;
                srtRec.SRT_Access_Code__c = srtAccessCode;
                srtRec.Step_Id__c = addSrtRec.StepId__c;
                srtRec.SRT_Select__c = TRUE;
                fslSRT.add(srtRec);
            }
            else {
                srtRec.Name = addSrtRec.Name;
                srtRec.Type__c = srtType;
                srtRec.SRT_Title__c = addSrtRec.SRT_DESCRIPTION__c;
                srtRec.Service_Order__c = serviceOrderId;
                if(srtType == 'Field Action') {
                    srtRec.RecordTypeId = faSRTRecordTypeId;
                }
                else {
                    srtRec.RecordTypeId = fslSRTRecordTypeId;
                }
                //Added by Piyush as part defect #633 to handle Repair SRTs for Dealer jobs
                 if( wo.Type__c=='Dealer' && srtType == 'Repair'){
                  //  srtRec.Job_Plan_Repair_SRTs__c=serviceOrderId;
                    srtRec.Repair_SRTs__c=serviceOrderId;
                }
                srtRec.Access_Code_A__c = addSrtRec.Access_Code_A__c ;
                srtRec.Access_Code_B__c = addSrtRec.Access_Code_B__c;
                srtRec.Access_Code_C__c = addSrtRec.Access_Code_C__c;
                srtRec.Access_Code_D__c = addSrtRec.Access_Code_D__c;
                srtRec.Access_Code_R__c = addSrtRec.Access_Code_R__c;
                srtRec.Use_R_Time__c = booleanR;
                srtRec.SRT_Time__c = srtTm;
                srtRec.SRT_Access_Code__c = srtAccessCode;
                srtRec.Step_Id__c =addSrtRec.StepId__c;
                srtRec.SRT_Select__c = TRUE;
                fslSRT.add(srtRec);
            }
        }
        Insert fslSRT;
        for(FSL_SRT__c srtRec:fslSRT) {
            fslSrtIds.add(srtRec.Id);
        }
        system.debug('FSL SRTs to Insert'+fslSrtIds);
        FSLSRTIntegrationHelperCls.getSRTDescriptionsInvocable(fslSrtIds);
        List<WorkOrder> word = new List<WorkOrder>();
        List<WorkOrder> wod = [select Id,Status,Sub_Status__c,EVL_Stage__c 
                                 from WorkOrder
                                 where id=:serviceOrderId and Type__c = 'Dealer'];
            system.debug('Workorder'+wo);
        for(WorkOrder wos :wod){
            wos.Status = 'Job Plan';
            wos.EVL_Stage__c = 'Job Plan';
            word.add(wos);
        }
        update word;
    }
    
    // Method to identify the duplicate SRTs - Added as part of NIN-7
    @AuraEnabled
    public static List<FSL_SRT__c> findDuplicateSRT(string srtCodes, string soId){
        //List<string> lstDupSRTs = new List<string>();
        List<FSL_SRT__c> lstDupSRTs = new List<FSL_SRT__c>();
        try{
            Boolean dupSRT = false;
            string[] strCodes = srtCodes.split(',');
            system.debug('strCodes--'+strCodes);
            List<String> lstSRTCodes1 = new List<String>();
            for(string ss : strCodes){
                system.debug('dupSrtcode--'+ss);
                lstSRTCodes1.add(ss.replace('[', ''));
            }
            system.debug('lstSRTCodes1--'+lstSRTCodes1);
            
            /*srtWrapper configWrap = (srtWrapper)JSON.deserialize(srtCodes, srtWrapper.class);
            
            List<String> lstSRTCodes = new List<String>();
            for(SRT c : configWrap.SRT) {
                lstSRTCodes.add(c.Name);
            }*/
            
            Set<string> setSRTCodesIgnore = new Set<string>{'19-361-00', '19-360-00', '19-052-00', '19-710-00', '00-140-00', '19-053-00', '17-004-00', '19-0FZ-00', '19-0FV-00', '19-0FY-00', '99-901-00', '99-902-00', '99-903-00', '17-902-00', '17-901-00'};
                
                List<FSL_SRT__c> lstSRTs = new List<FSL_SRT__c>();
            lstSRTs = [Select Id, Name from FSL_SRT__c where Service_Order__c =: soId];
            system.debug('lstSRTs--'+lstSRTs);
            
            if(lstSRTs != null && lstSRTs.size() > 0){
                for(string sc : lstSRTCodes1){
                    system.debug('Selected SRT--'+sc.substring(1,10));
                    if(!setSRTCodesIgnore.contains(sc.substring(1,10))){
                        for(FSL_SRT__c srtSaved : lstSRTs){
                            FSL_SRT__c srtRec = new FSL_SRT__c();
                            //if(sc.left(6) == srtSaved.Name.left(6)){
                            if(sc.substring(1,7) == srtSaved.Name.left(6)){
                                lstDupSRTs.add(srtSaved);
                                dupSRT = true;
                            }
                        }
                    }
                }
            }
            
            system.debug('dupSRT value-->'+lstDupSRTs);
        }
        catch(exception ex){
            system.debug('Exception in findDuplicateSRT--'+ex.getMessage()+' '+ex.getLineNumber());
        }
        
        return lstDupSRTs;
    }

    
    public class ConfigWrapper {
        @AuraEnabled public Config[] Config;
    }
    
    public class Config {
        @AuraEnabled public String type;
        @AuraEnabled public boolean isChecked;
    }
    
    /*public class srtWrapper {
        @AuraEnabled public SRT[] SRT;
    }
    
    public class SRT {
        @AuraEnabled public String Name;
    }*/
}