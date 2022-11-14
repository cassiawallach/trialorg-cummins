/**********************************************************************
Name:EVLSearchfaultcodesController
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class written for to get the fault codes, SPN/FMI and P code values to be populated when you search on the UI.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         2/14/2019                         
**********************************************************************-*/
public class EVLSearchfaultcodesController {
    
    @AuraEnabled
    public static list<sobject> getfaultcodes(string searchPcode , string searchSPN ,string strfaultcodes) {
        
        String searchKey = searchPcode+ '%';
        String searchSPNcode = searchSPN+ '%';
        String strfaultcode = strfaultcodes+ '%';
        list<FSL_SMN_DTC__c> lstSMNDTC = new list<FSL_SMN_DTC__c>();
        list<FSL_SMN_DTC__c> lstSMN = new list<FSL_SMN_DTC__c>();
        
        // Three search string parameters passing from the jshelper and based on search string value returning the FSL SMN DTC records
        string strquery = 'select Id ,Name from FSL_SMN_DTC__c' ;
        if(searchPcode != null && searchPcode !='') {
            strquery+= '  where FaultTypePcode__c LIKE :searchKey';
        }
        else if(searchSPN != null && searchSPN != '') {
            //if(strquery.containsIgnoreCase())
                //strquery+= ' FaultTypeSPNFMI__c LIKE :searchSPNcode';
            //else
            //strquery+=' where FaultTypeSPNFMI__c LIKE :searchSPNcode';
        } 
        else if(strfaultcode!=null && strfaultcode!='') {
            //if(strquery.containsIgnoreCase())
            //strquery+= ' FaultTypeFC__c LIKE :strfaultcode';
            //else
            //strquery+=' where FaultTypeFC__c LIKE :strfaultcode';
        }
        system.debug(strquery);
        lstSMN = database.query(strquery);
        
        if(lstSMN !=null && lstSMN.size()>0) {
            for (FSL_SMN_DTC__c objFC: lstSMN ) {
                lstSMNDTC.add(objFC);
            }
        }
        return lstSMNDTC ;
    }
    
    // Added by Vinod to display the symptom records based on the symptom category.
    
    @AuraEnabled
    public static list<sobject> getsearchresults(string searchPcode ) {
        system.debug('kkkkk--->'+searchPcode);
        String searchKey = searchPcode+ '%';
        
        list<FSL_SMN_DTC__c>  lstSMNDTC = new list<FSL_SMN_DTC__c>();
        list<FSL_SMN_DTC__c>  lstSMN = new list<FSL_SMN_DTC__c>();
        // list<FSL_Pcode__c> lstFSLcode = new list<FSL_Pcode__c>();
        // list<FSL_Pcode__c> lstFSLfcode = [select Id ,Name from FSL_Pcode__c where Name LIKE: searchKey limit 1];
        list<FSL_SMN_DTC__c> lstFSLfcode = [select Id ,Name from FSL_SMN_DTC__c limit 1];
        system.debug('test'+lstFSLfcode );
        return lstSMNDTC ;
    }

    //Sruthi - To hide or show sections based on Control User
	@AuraEnabled
    public static Boolean fetchTakeControl(string strjobId){
        
        return FSL_CL_LaunchInsite.fetchTakeControl(strjobId);
    }
    
    @AuraEnabled
    public static list<sobject> getsearchspnresults(string searchSPNcode) {
        system.debug('kkkkk--->'+searchSPNcode);
        String searchKey = searchSPNcode+ '%';
        list<FSL_SPN_FMI__c> lstFSLcode = new list<FSL_SPN_FMI__c>();
        // list<FSL_SPN_FMI__c> lstFSLfcode = [select Id ,Name from FSL_SPN_FMI__c where Name LIKE: searchKey limit 1];
        list<FSL_SMN_DTC__c> lstFSLfcode = [select Id ,Name from FSL_SMN_DTC__c limit 1];
        system.debug('test'+lstFSLfcode );
        /* for (FSL_Fault_Code__c objFC: lstFSLcode ) {
lstFSLcode.add(objFC);
}*/
        return lstFSLfcode;
    }
    
    //Added by Sriprada to flip the record type 
    @AuraEnabled
    public static void changeRecord(string workId)
    {
        system.debug(Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D'));
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionT_D').getRecordTypeId();
        WorkOrder wo = new WorkOrder();
        wo.Id        = workId;
        wo.RecordTypeId = recdtypeId;
        if(string.isNotBlank(workId) && string.isNotBlank(recdtypeId))
        {
            update wo;   
        }        
    } // 
    
    @AuraEnabled
    public static List<String>  getSymptos(String keyWord)
    {
        list<String> symptomCodes = new List<String>();
        if(String.isNotBlank(keyWord))
        {
            for(FSL_Symptom__c fs : [select Symptom__c from FSL_Symptom__c where Symptom_Category__c=:keyWord.trim()])
            {
                if(symptomCodes == null)
                    symptomCodes = new List<String>();
                symptomCodes.add(fs.Symptom__c);
            }
        }
        if(symptomCodes.size() == 0)
            symptomCodes.add('');
        return symptomCodes;
    }
    
    @AuraEnabled
    public static Map<String, List<String>> getSymptomsCategories() {
        system.debug('enterdinto getsysmscat');
        Map<String, List<String>> symptCatsMap = new Map<String, List<String>>();
        Set<String> sympKeys = new Set<String>();
        List<String> SympCatList;
        //By Priyanka for VGRS2-250 filtering based on Status field
        for(FSL_Symptom__c fs : [SELECT Symptom__c, Symptom_Category__c,Business_Unit__c FROM FSL_Symptom__c 
                                 WHERE Symptom_Category__c != null AND Symptom_Category__c != '' AND Business_Unit__c='Engine' AND Status__c = 'Active'
                                 ORDER BY Symptom_Category__c, Symptom__c])
        {
            if(symptCatsMap == null)
                symptCatsMap = new Map<String, List<String>>();
            if(symptCatsMap.containsKey(fs.Symptom_Category__c))
                symptCatsMap.get(fs.Symptom_Category__c).add(fs.Symptom__c);
            else
                symptCatsMap.put(fs.Symptom_Category__c, new List<String>{fs.Symptom__c});
        }
        system.debug('symptCatsMapkkkkkkk'+symptCatsMap);
        return symptCatsMap;
        
    }
    
    @AuraEnabled
    public static wrapperReturn showHidesearchstring(string strservicejobid ) {
        system.debug('str--->'+strservicejobid);
        wrapperReturn wrapret = new wrapperReturn();
        FSL_SMN_DTC__c objsmn = new FSL_SMN_DTC__c();
        workorder objWO = new workorder();
        if(strservicejobid != null) {
            objWO = [SELECT Id, Asset.Service_Model__c, User__r.Id from WorkOrder WHERE Id =:strservicejobid];
        }
        if(objWO.User__r.Id != null ){
            wrapret.strusr = objWO.User__r.Id; // Added Ravi to hide/show look up fields based on user look up value
        }
        else{
            wrapret.strusr = '';
        }
        system.debug('objWO.Asset.Service_Model__c'+objWO.Asset);
        system.debug('objWO.Asset.objWO'+objWO);
        system.debug('objWO.Asset.Service_Model__c'+objWO.Asset.Service_Model__c);
        if(objWO!=null && objWO.Asset != null && objWO.Asset.Service_Model__c!=null && objWO.Asset.Service_Model__c!='') {
            try {
                objsmn = [select id,FaultTypeFC__c,FaultTypePCode__c,FaultTypeSPNFMI__c from FSL_SMN_DTC__c where Name =:objWO.Asset.Service_Model__c limit 1];
                if(objsmn != null ) {
                    if(objsmn.FaultTypeFC__c =='Yes') {
                        wrapret.FaultTypeFC = True;
                    }
                    else if(objsmn.FaultTypeSPNFMI__c =='Yes') {
                        wrapret.FaultTypeSPNFMI = True;
                    }
                    else if(objsmn.FaultTypePCode__c =='Yes') {
                        wrapret.FaultTypePCode = True;
                    }
                } 
            }
            catch(exception e){
                system.debug('exception reason--'+e);
            }
        }
        system.debug('wrapret'+wrapret);
        return wrapret ;
    }
    
    // Added Ravi kanth
    @AuraEnabled
    public static WorkOrder hidetakecontrol(string strjobId) {
        system.debug('Test'+strjobId);
        WorkOrder objord = [select id, WorkOrderNumber,contact.name,Asset.Name,ESN_Insite__c from WorkOrder where id=:strjobId limit 1] ;
       // if(objord.User__c !=null) {
           objord.User__c = userinfo.getUserId();
        objord.Status = 'Triage & Diagnosis';//Added by Anirudh for dealer poc.
       // }
        try{
            update objord ; 
        } catch(Exception ex)
        {
            throw new AuraHandledException(ex.getMessage());
        }
        return objord ;
    }
    
    @AuraEnabled
    public static String echo(String message) {
        return message;
    }
    
    public class wrapperReturn {
        
        @auraEnabled
        public Boolean FaultTypeFC;
        @auraEnabled
        public Boolean FaultTypePCode ;
        @auraEnabled
        public Boolean FaultTypeSPNFMI ;
        @auraEnabled
        public string strusr ;
        @auraEnabled
        public FSL_SMN_DTC__c objFSLDTC ;
    }
    
    @AuraEnabled
    public static String getWorkOrderRecordType(String workOrderId){
        System.debug('******* WorkOrderId******'+workOrderId);
        WorkOrder order = [SELECT Id, WorkOrderNumber,RecordType.Name
                           FROM
                           WorkOrder
                           WHERE Id= : workOrderId limit 1];
        return order.RecordType.Name;
    }
    
    /*
* Author - Piyush 
* Method used to Capture the Fault Code Search Audit Trail
*/ 
    //[faultCode=a4g1D00000031VSQAY, pCode=, spnfmiCode=, symptom=Cooling Symptom, symtpomCategory=Crankcase Symptom]
    @AuraEnabled
    public static void captureSearchFaultCode(String workOrderId, String config) {
        
        try {
            SearchWrapper searchParams = (SearchWrapper) JSON.deserializeStrict(config, SearchWrapper.class);
            system.debug('***************** searchParams ***********'+ searchParams);
            String codeValue;
            String solutionCount;
            Boolean isFaultCode = false;
            Boolean isSymptom = false;
            
            
            
            if(String.isNotEmpty(searchParams.faultCode)) {
                codeValue = [Select Name From FSL_Fault_Code__c where Id=:searchParams.faultCode].Name;
                solutionCount =		[SELECT Id,Name,Number_of_Solutions__c 
                                     FROM CSS_Fault_Code__c 
                                     WHERE Name=:codeValue AND Service_Order__c=:workOrderId].Number_of_Solutions__c;
                isFaultCode = true;
            } else if(String.isNotEmpty(searchParams.pCode)) {
                codeValue = [Select Name From FSL_PCode__c where Id =: searchParams.pCode].Name;
            } else if(String.isNotEmpty(searchParams.spnfmiCode)) {
                codeValue = [Select Name From FSL_SPN_FMI__c  where Id =: searchParams.spnfmiCode].Name;
            } else if(String.isNotEmpty(searchParams.symptom) || String.isNotEmpty(searchParams.symtpomCategory)) {
                String symtpomValue  = 'Symtpom Category :' + searchParams.symtpomCategory +'; Symtpom : '+searchParams.symptom;
                FSL_CumminsUtilities.auditTrailInsert('Event-03', workOrderId ,'Searched for Fault Codes/Symptoms', symtpomValue, '','');
                
                solutionCount =		[SELECT Id,Name,Number_of_Solutions__c 
                                     FROM CSS_Fault_Code__c 
                                     WHERE Name=: searchParams.symptom AND Service_Order__c=:workOrderId].Number_of_Solutions__c;
                isSymptom = true;
            }
            
            if(codeValue != null) {
                FSL_CumminsUtilities.auditTrailInsert('Event-03', workOrderId ,'Searched for Fault Codes/Symptoms', codeValue, '','');
            }
            System.debug('solutionCount : '+ solutionCount);
            
            if(solutionCount != null && codeValue != null && isFaultCode == true) {
                FSL_CumminsUtilities.auditTrailInsert('Event-21', workOrderId ,'FC '+ codeValue + ' has ' + solutionCount +' Solutions' , codeValue, '','');
            } else if(solutionCount != null && isSymptom == true) {
                FSL_CumminsUtilities.auditTrailInsert('Event-21', workOrderId ,'Symptom '+'\''+ searchParams.symptom +'\''+ ' has ' + solutionCount +' Solutions' ,searchParams.symptom, '','');
            }
            
            
        } catch(Exception ex) {
            System.debug('::: Exception in captureSearchFaultCode - '+ex.getMessage()+' and '+ex.getStackTraceString());
        }
    }
    
    // Added by shirisha 08/03/2022 ROAD-527
    @AuraEnabled
    public static Boolean fetchFTRFlag(Id woId){
        try{
            Service_Order_Extension__c soExtensionObj = [SELECT Id, FSL_ABRFlag__c, Service_Order_Id__c FROM Service_Order_Extension__c WHERE Service_Order_Id__c =: woId LIMIT 1];
            Boolean flag = soExtensionObj.FSL_ABRFlag__c;
            if(flag != null){
                return flag;
            }
            else {
                return false;
            }
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public class SearchWrapper {
        @AuraEnabled public String pCode {get;set;}
        @AuraEnabled public String faultCode {get;set;}
        @AuraEnabled public String spnfmiCode {get;set;}
        @AuraEnabled public String symtpomCategory {get;set;}
        @AuraEnabled public String symptom {get;set;}
    }
}