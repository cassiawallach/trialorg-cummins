/**********************************************************************
Name:CG_CL_ClaimsFailuresOverviewCompNew
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This controller contains the logic for displaying failure details in Failure Overview section of
Failures and Campaigns under Warranty Claim.
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR                    DATE                DETAIL                                 
1.0     - Arpita Sarangee         03/20/2018          INITIAL DEVELOPMENT 
2.0     - Rajesh Pasupuleti       05/29/2018          Added onChangeofAppCode Method as per Simpsons story #128755
***********************************************************************/
public class CG_CL_ClaimsFailuresOverviewCompNew{ 
    
    //Variable declaration
    public Id Wid {get;set;}
    public boolean errornotcovfound{get;set;}
    public String Possession{get;set;}
    public string componentId{get;set;}
    public Set<Id> sjobIds {get;set;} 
    public list<failureClaimsWrapper> listfailClaimspWrapper {get;set;}
    public List<CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails> listcertificatedetails{get;set;}
    public CSS_getBasicCoverageResponseJ2A basicCoverageDetails{get;set;}
    public string mil_measure{get;set;}
    public List<CSS_Solution_Component__c> dispFailuresList;
    public List<CSS_SymptomQA__c> sympQAList;
    public list<string> lstpaycode {get;set;}
    public string selectedPayCode {get;set;}
    public List<SelectOption> lstPaycodeValues;
    public List<String> LstAccCodes = new List<string>();
    //public Map<string,String> mapAccCode = new Map<string,String>();
    public Map<string,String> mapAccCode; //Kalpana
    public Map<string,List<String>> fcSympMap = new Map<string,List<String>>();
    public String Reason1;
    public Boolean isDealer {get;set;}
    //Story 115015
    public string selectedFNameValue{get;set;}
    public string selectedFailModeValue {get;set;}
    public string selectedFaultCodeValue {get;set;}
    public string selectedFName{get;set;}//Faiulre Names
    public string selectedSysCode {get;set;}//System Codes
    public string selectedFailureID {get;set;}//Failure Ids
    public string selectedCompCode {get;set;}//Com Codes
    public string accCodeReturned {get;set;}
    public string accCodeSelected {get;set;}
    public List<SelectOption> lstPCvalues{get;set;}
    public string coverageFound {get;set;}
    public boolean pleaseselacc{get;set;}
    public string coverageType{get;set;}
    public string selectedFailMode {get;set;}
    public Boolean warrantyCompFailure {get;set;}
    //public Boolean warrantyFailure{get;set;}
    public List<SelectOption> accCodes{get;set;}
    public string payCodeSelected {get;set;}//Pay Codes
    public string selectedFaultCode {get;set;}//Claim Types
    public string AuthorizationNumber{get;set;}
    public String Coveredpartspercentage{get;set;}
    public String CoverageLaborpercentage{get;set;}
    public string ApprovalCode{get;set;}
    public boolean showDisabledAC {get;set;}
    public Boolean warrantyDetError{get;set;}//Added for Inside Out Sprint
    public CSS_Claims__c claimsRec{get;set;}
    public CSS_PSN__c psnRec{get;set;}
    public Set<String> failureNameList{get;set;}//faliureNameList
    public transient Map<String,String> custFailureNameSysCodeMap{get;set;}
    public transient Map<String,String> custFailureNameCompCodeMap{get;set;}//Anirudh Changes to transient
    //public Set<String> componentCodeList{get;set;} 
    //public Set<String> systemCodeList{get;set;}
    public Map<string, string> componentCodeMap{get;set;}//Anirudh Changes
    public transient Map<string, string> faultCodeMap{get;set;}
    public Map<string,string> custFailureNameList {get;set;}//Anirudh Changes - Custom failure name
    public Map<string, string> systemCodeMap{get;set;}
    public Set<String> faultCodeList{get;set;}
    public Set<String> failemodeList{get;set;}
    public Map<String,String> failureNameWithSystemCodeMap{get;set;}//Anirudh Changes
    public Map<String,String> failureNameWithFailureIdMap{get;set;}//Anirudh Changes
    public Map<String,String> failureNameWithCompCodeMap{get;set;}//Anirudh Changes
    //public  Map<String,String> sysCodeCustFailureNameMap{get;set;}
    public string selectedCompId{get;set;}
    public string deleteCompId{get;set;}
    public String accCodeWS {get;set;}
    public CSS_Solution_Component__c compont {get;set;}
    public CSS_Solution_Component__c clonecompont ;
    public string partsWarranty{get;set;}
    public String custSelect{get;set;}
    public string datebyLocaleValue {get;set;}
    public css_job_order__c workJob {get;set;}
    public string failureMeasure{get;set;}
    public string warrStDtHidden{get;set;}
    public string selectedCustFName {get;set;}
    public string selectedCustFNameValue {get;set;}
    public String partCoverageFound {get;set;}
    public CSS_Solution_Component__c compToUpdate {get;set;}
    public List<CSS_Solution_Component__c> solCompCampATC = new List<CSS_Solution_Component__c>();
    public List<CSS_Solution_Component__c> solCompCampATC1 = new List<CSS_Solution_Component__c>();
    public string claimtype{get;set;}
    public List<SelectOption> claimTypes{get;set;}
    public string claimTypeSelected{get;set;}
    public boolean noclvalueborder{get;set;}
    public boolean errormsgfailpoint{get;set;}
    public boolean checkPartsWarrStartDt{get;set;}
    public Date warrantyDate{get;set;}
    public string FailureDtHidden{get;set;}
    public Boolean addFailureLink{get;set;}
    public Boolean addCampLink {get;set;}
    public Boolean noPopup {get;set;}
    public Boolean radioSelect{get;set;}
    public Boolean solCompListOne;
    public string radioYes;
    //Fail code- EQ/WEQ
    public Boolean Bool {get;set;}
    public Boolean showFailurePopup{get;set;}
    public string oldAccountCode{get; set;}
    public Boolean isMultiPSNEnabled {get;set;}
    public boolean ShowCoverageCheck{get;set;}
    public Boolean stopFailureSave{get;set;}
    public Boolean chkClickonPartsCoverage{get;set;}
    public String SelectSysCode;
    public String SelectComCode;
    UserRole userRoleName {get;set;} 
    public boolean urRole {get; set;}
    public boolean dealerLocation {get; set;}
    //public string FCError {get;set;}
    public Boolean FCErrorval {get;set;}
    public string solCompExistsFlag{get;set;}
    public Boolean blankField{get;set;}
    public String OneaccCodeBool{get;set;}
    public Boolean isMultiPSNErrorExist{get;set;}
    public Boolean disableparts{get;set;}
    public Boolean invalidFailure{get;set;}
    public Boolean invalidCustFailure{get;set;}
    public Boolean invalidSysCode{get;set;}
    public Boolean invalidCompCode{get;set;}
    public Boolean invalidFailMode{get;set;}
    public Boolean invalidFaultCode{get;set;}
    public boolean DealerTypeFlag {get;set;}
    public boolean accountcodeeditonfm{get;set;}// GSSC-290
    public String failmodeloadval{get;set;}// GSSC-290
    public boolean checkCoverageonfm{get;set;}// GSSC-290
    public boolean failureinfochange{get;set;} // GSSC-290
    public boolean oldOTCValue{get;set;} //GSSC-298
    public string oldFailCode{get;set;} //GSSC-298
    public string oldAccCode{get;set;} //GSSC-298
    
    //function to fetch the failure name, system code and component code from GetFailureCodeSRT webservice
    //public Set<String> SRTFailurenames() { 
    
    //Added method for validated against the list of Approval Code which are received from Siebel by -RAJESH 29th May 
    public Boolean invalidAppCode{get;set;}
    
    public transient Set<String> failModeSet{get;set;}//Anirudh Changes
    
    public void onChangeofAppCode(){
        //  system.debug('**ApprovalCode**'+ApprovalCode);
        invalidAppCode = false;
        if(ApprovalCode != null && ApprovalCode != ''){
            string validappCode;
            try{
                validappCode = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute4__c,Attribute5__c, Reason__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'ApprovalAuthCode' AND Attribute4__c=:ApprovalCode limit 1].Attribute5__c ;
            }
            catch(exception Err){
            }
            if(validappCode == 'Y'){
                invalidAppCode = false;
            }
            else{ 
                invalidAppCode=true;
            }
        }
    }
    
    
    public void updateSRTFailNames(){ 
        if(jobEventTempRecSRTFailCodes != null){
            insert jobEventTempRecSRTFailCodes;
        }
    }
    
    public void callFaultCodesOnFocus(){
        try{
            system.debug('Entered into  callFaultCodesOnFocus>>>');
            //Story 188014 code changes start
            List<CSS_SMN_FaultCode__c> tempList = [select FC_Desc__c from CSS_SMN_FaultCode__c where SMN__c=: psnRec.Service_Model__c];
            faultCodeMap = new Map<String,String>();
            for(CSS_SMN_FaultCode__c lst : tempList){
                //string temp;
                //temp = lst.Attribute1__c + '-' + lst.Attribute3__c.replace('\'','');
                faultCodeMap.put(lst.FC_Desc__c,lst.FC_Desc__c);
            }
            //Story 188014 code changes end
            tempList = null;
            system.debug('After Map'+faultCodeMap);
        }catch(exception e){
            system.debug('Entered into catch block of callFaultCodesOnFocus>>>'+e.getLineNumber()+'>>>'+e.getMessage());
        }
    }
    
    public CSS_JobEventTemporary__c jobEventTempRecSRTFailCodes;
    public void getSRTFailurenamesOnLoad() { 
        if(wid!=null){
            
            Map<String, CSS_JobEventTemporary__c> mapJET = new Map<String,CSS_JobEventTemporary__c>();
//Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020            
            for(CSS_JobEventTemporary__c lstjet : [select Attribute1__c,Attribute3__c,Attribute2__c,Attribute4__c,Attribute5__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Active__c=true]){
                string temp = lstjet.Attribute1__c+lstjet.Attribute4__c;
                if(!mapJET.containsKey(temp)){
                    mapJET.put(temp,lstjet);
                }
                
            }
            system.debug('failureNameList'+failureNameList);
            system.debug('claimsRec.CSS_PSNs__r.size'+claimsRec.CSS_PSNs__r.size());
            //system.debug('claimsRec.CSS_PSNs__r[0].Service_Model__c'+claimsRec.CSS_PSNs__r[0].Service_Model__c);
            
            if(failureNameList.size()==0 && claimsRec.CSS_PSNs__r != null && claimsRec.CSS_PSNs__r.size() > 0 && claimsRec.CSS_PSNs__r[0].Service_Model__c!=null && claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c!=null){
                system.debug('failureNameList'+failureNameList);
                system.debug('claimsRec.CSS_PSNs__r.size'+claimsRec.CSS_PSNs__r.size());
                system.debug('claimsRec.CSS_PSNs__r[0].Service_Model__c'+claimsRec.CSS_PSNs__r[0].Service_Model__c);
                CSS_SRTComponentLookupResponseJ2A failureCodeDetails;
                try{
                    CSS_JobEventTemporary__c[] jobEventTemp;
                    String smn_engFamCode = claimsRec.CSS_PSNs__r[0].Service_Model__c + ';;' + claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c;
                    try{
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Reason__c, Key__c FROM CSS_JobEventTemporary__c WHERE Attribute3__c =: smn_engFamCode  AND Key__c = 'getFailureCodesSRT' AND CreatedDate = LAST_N_DAYS:7 LIMIT 1];
                    }
                    catch(exception Err){
                    }
                    
                    system.debug('job even temp'+jobEventTemp.size());
                    
                    if(jobEventTemp.size()==0){
                        
                        CSS_FN_SRT controller = new CSS_FN_SRT();
                        
                        
                        //call the SRT webservice based on Service Modal and Engine Code   
                        failureCodeDetails = controller.getFailureCodesSRT(claimsRec.CSS_PSNs__r[0].Service_Model__c,claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c, 'en');
                        system.debug('failureCodeDetails>>>'+failureCodeDetails);
                        //Insert FaliureCode Details to Job Event Temp Object : Kalpana
                        String output = JSON.serialize(failureCodeDetails);
                        jobEventTempRecSRTFailCodes = new CSS_JobEventTemporary__c();
                        jobEventTempRecSRTFailCodes.Attribute1__c = claimsRec.CSS_PSNs__r[0].Service_Model__c;
                        jobEventTempRecSRTFailCodes.Attribute2__c = claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c;
                        jobEventTempRecSRTFailCodes.Attribute3__c = claimsRec.CSS_PSNs__r[0].Service_Model__c + ';;' + claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c; 
                        jobEventTempRecSRTFailCodes.Reason__c = output;
                        jobEventTempRecSRTFailCodes.Key__c = 'GetFailureCodesSRT';
                        //insert jobEventTempRec;
                        //put all the failureName , SystemCode and Component code in a List
                        for(CSS_SRTComponentLookupResponseJ2A.DataArea data: failureCodeDetails.DataArea){
                            
                            string temp1 = data.SystemCode+data.ComponentCode;
                            if(mapJET!= null){
                                CSS_JobEventTemporary__c jobEveRec = new CSS_JobEventTemporary__c();
                                jobEveRec = mapJET.get(temp1);
                                if(jobEveRec != null && jobEveRec.Attribute4__c==data.ComponentCode && jobEveRec.Attribute1__c==data.SystemCode){
                                    String CombinationValu=string.valueof(data.ComponentCode+'-'+jobEveRec.Attribute5__c);
                                    failureNameWithCompCodeMap.put(data.FailureName,CombinationValu);
                                    String CombinationValu1=string.valueof(data.SystemCode+'-'+jobEveRec.Attribute3__c);
                                    failureNameWithSystemCodeMap.put(data.FailureName,CombinationValu1); 
                                }
                                
                            }
                            
                            failureNameList.add(data.FailureName);
                            failureNameWithFailureIdMap.put(data.FailureName,data.FailureID);
                            
                            if(failureNameWithCompCodeMap.get(data.FailureName)==null || failureNameWithCompCodeMap.get(data.FailureName)=='')
                                failureNameWithCompCodeMap.put(data.FailureName,data.ComponentCode);
                            if(failureNameWithSystemCodeMap.get(data.FailureName)==null || failureNameWithSystemCodeMap.get(data.FailureName)=='')
                                failureNameWithSystemCodeMap.put(data.FailureName,data.SystemCode);
                        } 
                    }
                    else {
                        
                        
                        if(jobEventTemp[0].Reason__c != null){
                            failureCodeDetails = (CSS_SRTComponentLookupResponseJ2A)JSON.deserializeStrict(jobEventTemp[0].Reason__c, CSS_SRTComponentLookupResponseJ2A.class);
                        }
                        systemCodeMap = new Map<string, string>();
                        if(failureCodeDetails !=null && failureCodeDetails.DataArea !=null){
                            for(CSS_SRTComponentLookupResponseJ2A.DataArea det: failureCodeDetails.DataArea){
                                String strFN=det.FailureName;
                                String strCC=det.ComponentCode;
                                String strSC=det.SystemCode;
                                if(!failureNameList.contains(strFN)){
                                    failureNameList.add(det.FailureName);                                            
                                    // systemCodeMap.put(det.SystemCode, det.SystemCode);  
                                    failureNameWithFailureIdMap.put(det.FailureName,det.FailureID);
                                    string temp1 = det.SystemCode+det.ComponentCode;
                                    if(mapJET!= null){
                                        CSS_JobEventTemporary__c jobEveRec = new CSS_JobEventTemporary__c();
                                        jobEveRec = mapJET.get(temp1);
                                        system.debug('Anirudh Entered if>>>>');
                                        if(jobEveRec != null && jobEveRec.Attribute4__c==det.ComponentCode && jobEveRec.Attribute1__c==det.SystemCode){
                                            system.debug('Anirudh Entered second if>>>>');
                                            String CombinationValu=string.valueof(strCC+'-'+jobEveRec.Attribute5__c);
                                            failureNameWithCompCodeMap.put(strFN,CombinationValu);
                                            String CombinationValu1=string.valueof(strSC+'-'+jobEveRec.Attribute3__c);
                                            failureNameWithSystemCodeMap.put(strFN,CombinationValu1); 
                                        }
                                        
                                    }
                                    if(failureNameWithCompCodeMap.get(strFN)==null || failureNameWithCompCodeMap.get(strFN)=='')
                                        failureNameWithCompCodeMap.put(strFN,strCC);
                                    if(failureNameWithSystemCodeMap.get(strFN)==null || failureNameWithSystemCodeMap.get(strFN)=='')
                                        failureNameWithSystemCodeMap.put(strFN,strsC);
                                }
                            }
                        }
                        
                    }
                    failureNameList.add('Unlisted');
                    system.debug('failureNameList>>>'+failureNameList);
                }
                catch(Exception e){
                    System.debug('Exception Calling getFailureCodesSRT :' + e.getLineNumber() + ' '+ e.getMessage());
                }
                
            }
        }
    }
    
    public string testing{get;set;}
    public void checkCompCode(){
        system.debug('componentCodeMap---'+componentCodeMap);
        system.debug('testing---'+testing);
        accCodeSelected = '';
        payCodeSelected = '';
             //Start code As per Task #191282,-By RAJESH 23rd Aug 2019    
        coverageFound='false';
        pleaseselacc = false;
        errornotcovfound=false;
          failureinfochange = true; //GSSC-290 karthik G added 
   //End As per Task #191282,-By RAJESH 23rd Aug 2019
        if(componentCodeMap!=null && componentCodeMap.size()>0){
            if((selectedCustFName==null || selectedCustFName=='') && selectedCompCode!='' && selectedCompCode != null){
                if(componentCodeMap.containskey(selectedCompCode)){
                    invalidCompCode = false;
                }else{
                    invalidCompCode = true;
                }
            }else{
                invalidCompCode = false;
            }
        }
        showDisabledAC = false;
    }
    public void checkFailMode(){
        for(CSS_JobEventTemporary__c jobTemp:[select Attribute1__C,Attribute3__c,Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailModes' and Active__c= true]){
            string temp1;
            temp1 = jobTemp.Attribute1__c+'-'+jobTemp.Attribute3__c.replace('\'','');
            if(selectedFailMode!='' && selectedFailMode != null){
                
                if(selectedFailMode==temp1){
                    invalidFailMode=false;
                    break;
                }
                else{
                    invalidFailMode = true;
                }
            }
           
        }
        // GSSC-290 calling checkCoverage on failmode tab off karthik G
        system.debug('accountcodeeditonfm'+accountcodeeditonfm);
        system.debug('failmodeloadval'+failmodeloadval);
        checkCoverageonfm = false;
          if(claimsRec.Information_Only_Claim__c ==false &&( (accountcodeeditonfm ==null && (failmodeloadval == '' || failmodeloadval== null)) || (accountcodeeditonfm ==false && (failmodeloadval == '' || failmodeloadval== null)) || (accountcodeeditonfm== true && (failmodeloadval == '' || failmodeloadval== null))) ){
               
          system.debug('before calling getcov');
          checkCoverage();
             system.debug('after calling get cov');
             checkCoverageonfm = true;
             failureinfochange = false;
          }
        system.debug('checkCoverageonfm'+checkCoverageonfm);
         system.debug('failureinfochange'+failureinfochange);
    }
    public void checkFaultCode(){
        selectedFaultCodeValue=selectedFaultCode;
        //invalidFaultCode=false;
        system.debug('selectedFaultCode>>>'+selectedFaultCode);
        //Story 188014 code changes start
        transient List<CSS_SMN_FaultCode__c> tempList = [select FC_Desc__c from CSS_SMN_FaultCode__c where SMN__c=: psnRec.Service_Model__c];
        //faultCodeMap = new Map<String,String>();
        if(selectedFaultCode!='' && selectedFaultCode != null && tempList != null && tempList.size()>0){
            for(CSS_SMN_FaultCode__c lst : tempList){
                if(selectedFaultCode == lst.FC_Desc__c){
                    invalidFaultCode=false;
                    break;
                }else{
                    invalidFaultCode=true;
                }
            }
        }else{
            invalidFaultCode=false;
        }
        //Story 188014 code changes End
        tempList = null;
        system.debug('invalidFaultCode****'+invalidFaultCode);
    }
    
    public Set<String> getfailurenames(){
        return failureNameList;
        
    }
    
    public  Map<String, string> getComponentCodes(){
        system.debug('componentCodeMapSiebl.size()****'+componentCodeMap);
        return componentCodeMap;
    }
    
    public Map<String, string> getSystemCodes(){
        return systemCodeMap;
    }
    
    //Added code in below method for getting description along with Fail mode code as pert Band of Brother #152400,-By RAJESH 9th Aug 2018 
    public List<String> getFailModes(){ 
        List<CSS_JobEventTemporary__c> tempList = [select Attribute1__C,Active__c,Attribute3__c from CSS_JobEventTemporary__c where key__c='FailModes' and Active__c= true  limit 1000];
        system.debug('tempList>>'+tempList.size());
        List<String> tempStr = new List<String>();
        failModeSet = new Set<String>();
        for(CSS_JobEventTemporary__c lst : tempList){
            string temp1;
            temp1 = lst.Attribute3__c.replace('\'','');
            if(temp1 != null && temp1 != ''){
                tempStr.add(lst.Attribute1__c +'-'+temp1);
            }
            if(!failModeSet.contains(lst.Attribute1__c +'-'+temp1))
                failModeSet.add(lst.Attribute1__c +'-'+temp1);
        }
        return tempStr;
    }
    
    
    //method for fault codes to display with description for the story #152401
    /* public map<String,String> getFaultCodes(){
/*List<CSS_JobEventTemporary__c> tempList = [select Attribute1__c,Attribute3__c from CSS_JobEventTemporary__c where key__c='CDSFaultCodes'];
faultCodeMap = new Map<String,String>();
for(CSS_JobEventTemporary__c lst : tempList){
string temp;
temp = lst.Attribute1__c + '-' + lst.Attribute3__c.replace('\'\\','');
faultCodeMap.put(temp,temp);
}
return faultCodeMap;
}*/
    
    public void changefailmode(){
        system.debug('************** selectedFailMode'+selectedFailMode);
        selectedFailModeValue=selectedFailMode;
        system.debug('************** selectedFailModeValue'+selectedFailModeValue);
          
    }
    
    /*  public void changefaultcode(){
system.debug('************** selectedFaultCode'+selectedFaultCode);

}*/
    
    public void changeSystemcode(){
        system.debug('selectedCompCode>>>'+selectedCompCode);
        String selSysCodee;
        accCodeSelected = '';
        payCodeSelected = '';
        selectedCompCode = '';
                     //Start code As per Task #191282,-By RAJESH 23rd Aug 2019    
        coverageFound='false';
         pleaseselacc = false;
        errornotcovfound=false;
          failureinfochange = true; //GSSC-290 karthik G added 
   //End As per Task #191282,-By RAJESH 23rd Aug 2019
        componentCodeMap = new map<string,string>();
        if(selectedSysCode.length()>2)
            selSysCodee=selectedSysCode.substring(0,2);
//Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020        
        list<CSS_JobEventTemporary__c> jetSC = [select Attribute1__C,Attribute3__c, Attribute4__c,Attribute5__c,Active__c,Attribute13__C,Attribute7__c from CSS_JobEventTemporary__c
                                                where key__c='FailCodes' and Attribute1__c != null and Attribute1__c =: selSysCodee and Active__c=true];
        
        if(selSysCodee != null)
        {
            selectedCompCode = '';
            for(CSS_JobEventTemporary__c jetRec : jetSC)
            {
                if(jetRec.Attribute5__c!=null){
                    string compDesc1 = jetRec.Attribute4__c+'-'+jetRec.Attribute5__c;
                    compDesc1 = compDesc1.replace('\'',''); 
                    componentCodeMap.put(compDesc1, compDesc1);
                    
                }
            }
            
            
        }
        if(systemCodeMap!=null && systemCodeMap.size()>0){
            if((selectedCustFName==null || selectedCustFName=='') && selectedSysCode!='' && selectedSysCode != null){
                if(systemCodeMap.containskey(selectedSysCode)){
                    invalidSysCode = false;
                }else{
                    invalidSysCode = true;
                }
            }else{
                invalidSysCode = false;
            }
        }
        jetSC = new list<CSS_JobEventTemporary__c>();
        showDisabledAC = false;
    }
    
    public void changeComponentCode(){
        /* if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
selectedCompCodeValue=selectedCompCode;
}Anirudh commented 7/1*/
        showDisabledAC = false;
    }
    
    //onChange of pre Defined Failure Name
    public boolean unlistedFailure{get;set;}
    public void changeFailures(){
        custFailureNameList = new map<string,string>();//Anirudh Changes
        custFailureNameSysCodeMap = new map<string,string>();
        custFailureNameCompCodeMap = new map<string,string>();
        accCodeSelected = '';
        payCodeSelected = '';
             //Start code As per Task #191282,-By RAJESH 23rd Aug 2019    
        coverageFound='false';
         pleaseselacc = false;
        errornotcovfound=false;
        failureinfochange = true; // GSSC-290 karthik G added 
        system.debug('failureinfochange'+failureinfochange);
   //End As per Task #191282,-By RAJESH 23rd Aug 2019
        Bool=false;
        selectedFNameValue=selectedFName;
        system.debug('failureNameWithSystemCodeMap'+failureNameWithSystemCodeMap);
        system.debug('failureNameWithSystemCodeMap'+failureNameWithCompCodeMap);
        system.debug('failureNameWithSystemCodeMap'+failureNameWithFailureIdMap);
        if(selectedFName !=null && selectedFName != '' &&  selectedFName.toLowerCase() != 'unlisted'){        
            selectedSysCode =  failureNameWithSystemCodeMap.get(selectedFName) ;  
            selectedCompCode =  failureNameWithCompCodeMap.get(selectedFName); 
            selectedFailureID = failureNameWithFailureIdMap.get(selectedFName);
            selectedCustFName = '';
            unlistedFailure = false;
            // Story- GSSC-75
            if(selectedSysCode!= null && selectedSysCode!= '' && (selectedSysCode.startsWith('EQ') || selectedSysCode.startsWith('WE'))) {
                Bool = true;
            }
            // Story- GSSC-75
            system.debug('selectedSysCode****'+selectedSysCode);
            system.debug('selectedCompCode****'+selectedCompCode);
        }else if(selectedFName == null || selectedFName == ''){
            selectedSysCode =  '';  
            selectedCompCode =  ''; 
            selectedFailureID = '';
            selectedCustFName = '';
            unlistedFailure = false;
        }
        //load system code and component code from siebel when failureName is 'Unlisted'
        if(selectedFName !=null &&  selectedFName != '' && selectedFName.toLowerCase() == 'unlisted'){
            selectedSysCode =  '';  
            selectedCompCode =  ''; 
            selectedFailureID = '';
            selectedCustFName = '';
            unlistedFailure = true;
            String sysDesc;
            String compDesc;
//Have added Active__c!=false condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020            
            List<CSS_JobEventTemporary__c> jobEventTemp = [select id,Attribute1__C,Attribute3__c, Attribute5__c,Attribute4__c,Attribute7__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C!=null and Attribute4__c!=null and Active__c!=false];
            if(jobEventTemp != null && jobEventTemp.size()>0){
                integer i = 0;
                integer templistsize = jobEventTemp.size();
                while(i<templistsize)
                {
                    
                    if(jobEventTemp[i].Attribute7__c != null){
                        sysDesc = jobEventTemp[i].Attribute1__C+'-'+jobEventTemp[i].Attribute3__c;
                        sysDesc = sysDesc.replace('\'','');
                        
                        systemCodeMap.put(sysDesc, sysDesc);
                        if(jobEventTemp[i].Attribute7__c != null && jobEventTemp[i].Attribute7__c != '' ){
                            String temp = jobEventTemp[i].Attribute7__c.replace('\'','');
                            if(temp != null && temp != ''){
                                custFailureNameList.put(temp,temp);}
                            else{
                                custFailureNameList.put(jobEventTemp[i].Attribute7__c,jobEventTemp[i].Attribute7__c);   
                            }
                        }
                        
                        if(jobEventTemp[i].Attribute7__c != null && jobEventTemp[i].Attribute7__c != '' && jobEventTemp[i].Attribute1__C != null && jobEventTemp[i].Attribute1__C != '') {
                            custFailureNameSysCodeMap.put(jobEventTemp[i].Attribute7__c, jobEventTemp[i].Attribute1__C+'-'+(jobEventTemp[i].Attribute3__c != null ? jobEventTemp[i].Attribute3__c : ''));
                        }
                        if(jobEventTemp[i].Attribute7__c != null && jobEventTemp[i].Attribute7__c != '' && jobEventTemp[i].Attribute4__c != null &&
                           jobEventTemp[i].Attribute4__c != '')
                            custFailureNameCompCodeMap.put(jobEventTemp[i].Attribute7__c, jobEventTemp[i].Attribute4__c+'-'+(jobEventTemp[i].Attribute5__c != null ? jobEventTemp[i].Attribute5__c : ''));
                        
                    }
                    i++;
                }
                
            }
            
        } 
        system.debug('failureNameList wenchin' + failureNameList);
        if(failureNameList!=null && failureNameList.size()>0){
            system.debug('Today inside failureNameList' + failureNameList);
            if(selectedFName != null && selectedFName != ''){
                if(failureNameList.contains(selectedFName)){
                    invalidFailure=false;
                }else{
                    invalidFailure = true;
                }
            }else{
                invalidFailure = false;
            }
        }
        
        system.debug('Today invalidFailure' + invalidFailure);
        if(invalidFailure == false)
            showDisabledAC = false;
        
        system.debug('Today showDisabledAC' + showDisabledAC);
    }        
    
    Public void changeCustFailures(){
        
        try{
            system.debug('selectedCustFName>>'+ selectedCustFName);
            selectedCustFNameValue=selectedCustFName;
            system.debug('custFailureNameSysCodeMap***'+ custFailureNameSysCodeMap);
            system.debug('custFailureNameCompCodeMap***'+ custFailureNameCompCodeMap);
            accCodeSelected = '';
            payCodeSelected = '';
                 //Start code As per Task #191282,-By RAJESH 23rd Aug 2019    
        coverageFound='false';
         pleaseselacc = false;
        errornotcovfound=false;
         failureinfochange = true; //GSSC-290 karthik G added 
   //End As per Task #191282,-By RAJESH 23rd Aug 2019
            if(selectedCustFName!=null &&  selectedCustFName!= ''){
                
                system.debug('selectedSysCode>>'+ selectedSysCode);
                system.debug('selectedCompCode>>'+ selectedCompCode);
//Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020                
                List<CSS_JobEventTemporary__c>  jobEvSCCC=[select  Attribute1__c,Attribute4__c,Attribute5__c ,Attribute3__c
                                                           from CSS_JobEventTemporary__c 
                                                           where key__c='FailCodes' and Active__c=true and Attribute7__c =: selectedCustFName];
                if(jobEvSCCC != null && jobEvSCCC.size()>0){                                             
                    selectedSysCode =  jobEvSCCC[0].Attribute1__C+'-'+(jobEvSCCC[0].Attribute3__c != null ? jobEvSCCC[0].Attribute3__c : '');  
                    selectedCompCode =  jobEvSCCC[0].Attribute4__C+'-'+(jobEvSCCC[0].Attribute5__c != null ? jobEvSCCC[0].Attribute5__c : ''); 
                }
                //selectedSysCode = selectedSysCodevalue;
                //selectedCompCode = selectedCompCodevalue;
                jobEvSCCC = new list<CSS_JobEventTemporary__c>();
            }else{
                selectedSysCode = '';
                selectedCompCode = '';
            }
            
            if(custFailureNameList!=null && custFailureNameList.size()>0){
                custFailureNameList.put('Unlisted','Unlisted');
                if(selectedCustFName!=null && selectedCustFName!=''){
                    if(custFailureNameList.containskey(selectedCustFName)){
                        invalidCustFailure = false;
                    }else{
                        invalidCustFailure = true;
                        selectedSysCode = '';
                        selectedCompCode = '';
                    }
                }else{
                    invalidCustFailure = false;
                }
                
            }
            
            if(invalidCustFailure == false)
                showDisabledAC = false;
            system.debug('selectedSysCode>>>'+selectedSysCode);
            system.debug('selectedCompCode>>>'+selectedCompCode);
            system.debug('invalidCustFailure>>>'+invalidCustFailure);
            
        }
        catch(Exception e){
            System.debug('Exception Calling changeFailures :' + e.getLineNumber() + ' '+ e.getMessage());
        }
        
    }
    
    
    //Below method is added to retry the warranty webservice if any of the displayed solution component's accountcode status is failure(User story 183076)
    public List<CSS_Solution_Component__c> warrantyFailureSolCompList;
    public List<CSS_Solution_Component__c> warrantyFailureSolCompUpdateList;
    public PageReference retry(){
        try{
            system.debug('***inside retry***');
            
            //Initialise warrantyfailure lists
            warrantyFailureSolCompList = new List<CSS_Solution_Component__c>();
            warrantyFailureSolCompUpdateList = new List<CSS_Solution_Component__c>();
            CSS_Solution_Component__c compToUpdate = new CSS_Solution_Component__c();
            
            //Query to get all components with account code null and account code call status as failure
            warrantyFailureSolCompList = [select Id, Failure_Measure__c, SysCodeAndCompCode__c, Type__c, System_Code__c, Component_Code__c, Fail_Code_Editable__c, AccountCode__c, Selected_Component__c, name,Component_Id__c,Solutions__c,Service_Job__c,AccountCode_Call_Status__c,solutions__r.FaultCode__c from CSS_Solution_Component__c where CSS_Claims__c=:Wid and AccountCode_Call_Status__c = 'Failure' and (AccountCode__c = '' or AccountCode__c = null)];
            system.debug('***warrantyFailureSolCompList***'+warrantyFailureSolCompList +'******size****'+warrantyFailureSolCompList.size());
            
            if(warrantyFailureSolCompList != null){
                system.debug('***insideifwarr***');
                
                
                //Iterate the warrantyfailure list to get the updated component data from warrantycoverage_syncCall webservice method
                for(CSS_Solution_Component__c solComp: warrantyFailureSolCompList){
                    
                    String systemCode;
                    String compCode;
                    String selectedFailCodeMod;
                    
                    /*if(solComp.Fail_Code_Editable__c != null && solComp.Fail_Code_Editable__c != ''){
selectedFailCodeMod = solComp.Fail_Code_Editable__c.right(4);
if(selectedFailCodeMod != null && selectedFailCodeMod != ''){
systemCode = selectedFailCodeMod.left(2);
compCode =  selectedFailCodeMod.right(2);
}

}*/
                    if(solComp.SysCodeAndCompCode__c != null && solComp.SysCodeAndCompCode__c != ''){
                        //selectedFailCodeMod = solComp.SysCodeAndCompCode__c;
                        //if(selectedFailCodeMod != null && selectedFailCodeMod != ''){
                        systemCode = solComp.SysCodeAndCompCode__c.left(2);
                        compCode =  solComp.SysCodeAndCompCode__c.right(2);
                        //}
                        
                    }
                    
                    if(solComp.Type__c != null && solComp.Type__c != ''){
                        
                        {
                            
                            system.debug('***claimsRec.CSS_PSNs__r[0].ApplicationCode__c***'+claimsRec.CSS_PSNs__r[0].ApplicationCode__c);      
                            if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='130' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='210' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='220' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='310' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='320' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='410'){
                                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,systemCode,compCode,'','',solComp.id,solComp.Selected_Component__c,solComp.Component_Id__c,'','Second Call', '',true,claimsRec.Name);
                            }
                            else{
                                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Product_Hours__c),'Hours',psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,systemCode,compCode,'','',solComp.id,solComp.Selected_Component__c,solComp.Component_Id__c,'','Second Call', '',true,claimsRec.Name);
                                
                            }
                            // compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,psnRec.Failure_Point__c,solComp.Failure_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,systemCode,compCode,'','',solComp.id,solComp.Selected_Component__c,solComp.Component_Id__c,'','Second Call', '',true);
                        }
                        //compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,psnRec.Failure_Point__c,solComp.Failure_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'','',solComp.id,solComp.Selected_Component__c,solComp.Component_Id__c,'','Second Call', '',true);
                    }
                    else{
                        if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='130' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='210' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='220' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='310' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='320' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='410'){
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,systemCode,compCode,'','',solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true,claimsRec.Name);
                            
                            
                        }
                        else{
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Product_Hours__c),'Hours',psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,systemCode,compCode,'','',solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true,claimsRec.Name);
                            
                            
                        }
                    }
                    
                    //compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,psnRec.Failure_Point__c,solComp.Failure_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'','',solComp.id,solComp.Selected_Component__c,solComp.Component_Id__c,'','Second Call', '',true);
                    
                    system.debug('***compToUpdate-retry***'+compToUpdate);
                    
                    //Add returned component data to warrantyFailureSolCompUpdateList
                    if(compToUpdate != null)
                        warrantyFailureSolCompUpdateList.add(compToUpdate);
                }
            }
            
            //Update all the warrantyfailurecomponents to the database
            if(warrantyFailureSolCompUpdateList != null){
                update warrantyFailureSolCompUpdateList;
            }            
            
        }
        catch(exception e){
            system.debug('inside retry exception -->'+ e.getmessage() + e.getLineNumber());
        }
        return null;
    }
    
    public void checkCoverage(){
        try{
             if(checkCoverageonfm == null || checkCoverageonfm != true ||   failureinfochange == true  ) { 
            blankfield = false;
            String selectedSysCodeNew;
            String selectedCompCodenew;
            if(selectedSysCode.length()>2)
                selectedSysCodeNew=selectedSysCode.substring(0,2);
            if(selectedCompCode.length()>2)
                selectedCompCodenew=selectedCompCode.substring(0,2);
            if(selectedFailMode.length()>2)
                selectedFailMode=selectedFailMode.substring(0,2);
            if(selectedFaultCode!=null && selectedFaultCode.contains('-')){
                String[] sFaultCode=selectedFaultCode.split('-')  ;
                selectedFaultCode=sFaultCode[0];
            }
            system.debug('selectedSysCodeNew'+ selectedSysCodeNew);
             system.debug('selectedCompCodenew'+ selectedCompCodenew);
            compToUpdate = new CSS_Solution_Component__c();
            CSS_Claims__c  claimsRec = new CSS_Claims__c();  
            CSS_PSN__c  psnRec = new CSS_PSN__c();
            lstPCvalues = new list<selectoption>();
            mapAccCode = new Map<string,String>();
            showDisabledAC = false;
            //Added PACCAR_Converted_to_PW__c field in below query as part of the story GSSC-71
            claimsRec =[Select Id,IsDealerCreatedClaim__c, Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c, PACCAR_PW_AutoSelected__c, No_Failure_PACCAR_Flag__c, PACCAR_Converted_to_PW__c, Catastrophic__c,Customer_Name__c,Location__c,Dealer_Service_Job__c,CSS_Job__r.ApplicationCode__c,Dealer_Service_Job__r.ApplicationCode__c,Location_Code__c,ReconEngineFlag__c,CSS_Job__c,CSS_Job__r.name,CSS_Job__r.createddate,Shop_Work_Order__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,CoverageResponse__c, 
                        (Select Id,Name,PSN__c,Service_Model__c,Application__c,License_Plate_State__c,ApplicationCode__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c,Calibration_After__c,Calibration_Before__c,Revision_After__c,Revision_Before__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id= :WId];
            if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                psnRec = claimsRec.CSS_PSNs__r.get(0);}
            
            css_solution_component__c solComp = new css_solution_component__c();
            try{
                solcomp = [select id,name,Failure_Point__c,Failure_Measure__c,Part_Warranty_Start_Date__c,Selected_Component__c,Component_Id__c from css_solution_component__c where name=:selectedFName and Component_Code__c=:selectedCompCodeNew and System_Code__c=:selectedSysCodeNew and Failure_Mode__c=:selectedFailMode limit 1];
                system.debug('*******solcomp**8'+solcomp);
            }
            catch(Exception ex){
                system.debug('Exception in Save Expense method'+ ex.getMessage()+' '+ex.getLineNumber());
               
                if(!Test.isRunningTest()){
                    compToUpdate.AccountCodeEdit__c = ' '; 
                }
            }
            String Appcodepass;
            if(psnRec.ApplicationCode__c==null) {
                if(claimsRec.CSS_Job__c!=null)
                    Appcodepass = claimsRec.CSS_Job__r.ApplicationCode__c;          
                else if(claimsRec.Dealer_Service_Job__c!=null)
                    Appcodepass = claimsRec.Dealer_Service_Job__r.ApplicationCode__c;  
            }
            else{
                Appcodepass = psnRec.ApplicationCode__c;
            }
            
            try{
                
                string accCodeEdit = '';
                if(accCodeReturned != null && accCodeReturned != '')
                    accCodeEdit = accCodeReturned;
                else      
                {
                 accCodeSelected= accCodeSelected.replace('Select One', '');
                 accCodeSelected = accCodeSelected.right(2).trim();
                 accCodeEdit = accCodeSelected;
                }
                    
                
                
                String failpoint;
                if(psnRec.Product_Hours__c > 0){
                    failpoint = String.valueof(psnRec.Product_Hours__c);
                }
                else{
                    failpoint = String.valueof(psnRec.Mileage__c);
                }
                if(solcomp!=null){
                    system.debug('karthik G '+solcomp);
                    if(claimsRec.ReconEngineFlag__c!=null && claimsRec.ReconEngineFlag__c=='Y'){
                         if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='130' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='210' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='220' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='310' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='320' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='410'){
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCodeNew,SelectedCompCodeNew,'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', claimsRec.ReconEngineFlag__c,true, claimsRec.Name); //Removed Component_Id__c, sending as blank as we no need not to send for failures karthik G + Karthik G Added as part of 190587 accCodeEdit.
                        }
                        else{
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Product_Hours__c),'Hours',psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCodeNew,SelectedCompCodeNew,'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', claimsRec.ReconEngineFlag__c,true, claimsRec.Name);//removed Component_Id__c, sending as blank as we no need not to send for failures karthik G + Karthik G Added as part of 190587 accCodeEdit.
                        }
                     }
                    else{
                        if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='130' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='210' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='220' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='310' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='320' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='410'){
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCodeNew,SelectedCompCodeNew,'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true, claimsRec.Name);  //Karthik G Added as part of 190587 accCodeEdit.
                        }
                        else{
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Product_Hours__c),'Hours',psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCodeNew,SelectedCompCodeNew,'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true, claimsRec.Name); // Karthik G Added as part of 190587 accCodeEdit.
                        }
                     }
                     if(compToUpdate != null && compToUpdate.AccountCode_Call_Status__c != null && compToUpdate.AccountCode_Call_Status__c != 'Failure')
                        warrantyDetError=false;
                    else 
                        warrantyDetError=true;
                  
                }
                 system.debug('karthik error '+warrantyDetError);
                
            }
            catch(Exception ex){
                compToUpdate.AccountCodeEdit__c = ' ';
            }
             system.debug('compToUpdate.AccountCodeEdit__c'+compToUpdate.AccountCodeEdit__c);
            if(compToUpdate != null && compToUpdate.AccountCodeEdit__c != null && compToUpdate.AccountCodeEdit__c != ' '){
                coverageFound = 'true';
                errornotcovfound=false;
                accCodeSelected = compToUpdate.AccountCodeEdit__c;
                
                payCodeSelected = compToUpdate.Pay_Code__c;
                SET<String> fixedAccountCodes  = new SET<String>{'New Parts Warranty 62','Recon Component Warranty 97',
                    'Recon Defective Parts 41 (Failed from stock)','Service Tool Warranty 52',
                    'New Defective Parts 35 (Failed from stock)'};
                        
                        
                        string orgtype=css_utility.getOrgType(userinfo.getUserId());
                List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
                if(orgtype=='DISTR')
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' order by Attribute2__c asc limit 1000];
                else
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Attribute15__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                if(jobEventTemp.size() > 0){
                    accCodes = new List<SelectOption>();
                    List<SelectOption> accCodesNew = new List<SelectOption>();
                    accCodes.add(new SelectOption('Select One','Select One'));
                    
                    accCodesNew.add(new SelectOption(accCodeSelected,accCodeSelected));
                    //system.debug('PSN_NAME'+ psnRec.name);
                    if(claimsRec.CSS_Job__c==null && (psnRec.PSN__c== '10000000' || psnRec.PSN__c== '27000000')){
                        system.debug('inside fixed');
                        for(String s: fixedAccountCodes){
                            if(s != accCodeSelected)
                                accCodes.add(new SelectOption(s,s));    
                        }
                        
                    }
                    else{
                        system.debug('outside fixed');
                        for(CSS_JobEventTemporary__c j : jobEventTemp){
                            string s = j.Attribute2__c+' '+ j.Attribute3__c;
                            if(s != accCodeSelected)
                                accCodesNew.add(new SelectOption(s,s));
                             
                        }
                        
                    }
                    accCodesNew.sort();
                    accCodes.addAll(accCodesNew);
                    
                    //Preparing PayCodeList
                    List<CSS_JobEventTemporary__c> lstpayCodeReason = [select Attribute3__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes' and Attribute3__c =:accCodeSelected.right(2).trim()];
                    // system.debug('PayCodeReason**'+lstpayCodeReason);
                    for(CSS_JobEventTemporary__c jet: lstpayCodeReason){
                        
                        if(jet.Reason__c !=null){
                            mapAccCode.put(jet.Attribute3__c,jet.Reason__c);
                        }
                    }
                    lstPCvalues = getPayCodesList(accCodeSelected.right(2).trim());
                    //update compToUpdate;
                    if(payCodeSelected != null && payCodeSelected != '')
                        lstPCValues.add(new SelectOption(payCodeSelected,payCodeSelected));
                                        
                }         
            }
            else {
                system.debug('karthik G else');
                warrantyCompFailure = false;
                coveragefound='false';
                 pleaseselacc = true;
                accCodeSelected = '';
                accCodeReturned = '';
                SET<String> fixedAccountCodes  = new SET<String>{'New Parts Warranty 62','Recon Component Warranty 97',
                    'Recon Defective Parts 41 (Failed from stock)','Service Tool Warranty 52',
                    'New Defective Parts 35 (Failed from stock)'};
                     
                string orgtype=css_utility.getOrgType(userinfo.getUserId());
                List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
                if(orgtype=='DISTR')
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' order by Attribute2__c asc limit 1000];
                else
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Attribute15__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                if(jobEventTemp.size() > 0){
                    accCodes = new List<SelectOption>();
                    accCodes.add(new SelectOption('Select One','Select One'));
                    if(claimsRec.CSS_Job__c==null && (psnRec.PSN__c== '10000000' || psnRec.PSN__c== '27000000')){
                        system.debug('inside fixed');
                        for(String s: fixedAccountCodes){
                            accCodes.add(new SelectOption(s,s));    
                        }
                    }
                    else{
                        system.debug('Inside Else');
                        for(CSS_JobEventTemporary__c j : jobEventTemp){
                            string s = j.Attribute2__c+' '+ j.Attribute3__c;
                            accCodes.add(new SelectOption(s,s));
                        }
                    }    
                    
                }         
                List<CSS_JobEventTemporary__c> lstpayCodeReason = [select Attribute3__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes' and Attribute3__c =:accCodeReturned.right(2).trim()];
                 for(CSS_JobEventTemporary__c jet: lstpayCodeReason){
                    if(jet.Reason__c !=null){
                        mapAccCode.put(jet.Attribute3__c,jet.Reason__c);
                    }
                }
                 lstPCvalues = getPayCodesList(accCodeReturned.right(2).trim());
                
            }
            getCoverageType();
          }
        }
        catch(Exception ex){
            system.debug('Catch Check Coverage'+ ex.getmessage()+' '+ex.getLineNumber());
        }
    }
    
    public void getPayCodesonAccCodeChange(){
        system.debug('InsideAccChangeMethod**');
        
        clearPopup(); // clearPopup inturn calls getCoverageType();
        showDisabledAC=false; //added for the defect#181102
        coverageFound='false';
         pleaseselacc = false;
        AuthorizationNumber = '';
        Coveredpartspercentage='';
        CoverageLaborpercentage='';
        ApprovalCode = '';
        blankField=false;
        checkPartsWarrStartDt = false;
        failureinfochange = true; 
        /*if(accCodeSelected != 'EMISSION WARRANTY 70'){FCErrorVal = false;}*/
        system.debug('AccCodeSelected**'+accCodeSelected);
        mapAccCode = new Map<string,String>();
        lstPCvalues = new list<selectoption>();
        List<CSS_JobEventTemporary__c> lstpayCodeReason = [select Attribute3__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes' and Attribute3__c =:accCodeSelected.right(2).trim()];
          system.debug('PayCodeReason**'+lstpayCodeReason);
        for(CSS_JobEventTemporary__c jet: lstpayCodeReason){
            
            if(jet.Reason__c !=null){
                mapAccCode.put(jet.Attribute3__c,jet.Reason__c);
            }
        }
        // system.debug('mapAccCode**'+mapAccCode); 
        payCodeSelected = '';
        lstPCvalues = getPayCodesList(accCodeSelected.right(2).trim());
        
        css_solution_component__c solnComp = new css_solution_component__c();
        custSelect = solnComp.Customer_Take_Possession__c;
        if(custSelect != null){
            solnComp.Customer_Take_Possession__c = custSelect;
        }
        else{
            if(accCodeSelected!=null && (accCodeSelected.contains('62') || accCodeSelected.contains('97'))){
                solnComp.Customer_Take_Possession__c = 'Yes';
            }
            else {
                if(accCodeSelected!=null && (accCodeSelected.contains('35') || accCodeSelected.contains('41'))){
                    solnComp.Customer_Take_Possession__c = 'No';
                }
            }
            
        }
        
    }
    
    //Constructor
    public CG_CL_ClaimsFailuresOverviewCompNew(){
        
        
        
        //Possession = '';
        claimsRec = new CSS_Claims__c();
        partCoverageFound ='';
        errornotcovfound = false;
        dateErrFlag=false; 
        higherdateErrFlag=false;
        invalidFaultCode=false;
        checkCoverageonfm = false;
        //warrantyFailure = false;
        psnRec = new CSS_PSN__c();
        compont = new css_solution_component__c();
        clonecompont=new css_solution_component__c();
        datebyLocaleValue = css_utility.getFormattedDate();
        failureNameList = new Set<String>();
        //componentCodeList = new Set<String>();
        //systemCodeList = new Set<String>();
        componentCodeMap = new Map<string,string>();
        systemCodeMap = new Map<string, string>();
        faultCodeList = new Set<String>();
        failemodeList = new Set<String>();
        failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithFailureIdMap = new Map<String,String>();
        failureNameWithCompCodeMap = new Map<String,String>();
        custFailureNameCompCodeMap = new Map<String,String>();
        custFailureNameSysCodeMap = new Map<String,String>();
        custFailureNameCompCodeMap = new Map<String,String>();
        custFailureNameList=new Map<String,String>();
        //sysCodeCustFailureNameMap = new Map<String,String>();
        
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        showDisabledAC = true;
        system.debug('****Id***'+Wid);
        noclvalueborder = false;
        invalidAppCode = false;
        addFailureLink = false;
        addCampLink = false;
        //noPopup = false;
        // custSelect = '';
        radioYes = '';
        radioSelect = false;
        //Commented as per story The Office 164459
        //OneaccCodeBool = '';
        solCompListOne=false;
        disableparts=false;
        ShowCoverageCheck=true;
        invalidFailure=false;
        invalidCustFailure=false;
        String orgtype=css_utility.getOrgType(userinfo.getUserId());
        if (orgtype != null && orgtype != ''){
            if (orgtype == 'DISTR'){
                //displayERPButtonDist = false;
                //displayERPButtonDist = true;
                //isDealer = false;
                system.debug('orgtype---->'+orgtype);
                //system.debug('displayERPButtonDist---->'+displayERPButtonDist);
            }else if(orgtype == 'DLR') {
                //isDealer = true;
            }
        }
        
        if(Wid != null){
            
            getAllFailuresData();
            //Added PACCAR_Converted_to_PW__c field in below query as part of the story GSSC-71
            claimsRec =[Select id,Failures_ODM_Status__c, Parts_ODM_Status__c, SRTs_ODM_Status__c,Automotive_App_Flag__c,name,Catastrophic__c, PACCAR_PW_AutoSelected__c, No_Failure_PACCAR_Flag__c, PACCAR_Converted_to_PW__c, Account__r.Type,IsDealerCreatedClaim__c,CSS_PACCAR_Auth_Track__c,Parts_Warranty_Claim_Only__c,PACCAR_Auth_Required__c,PACCAR_Flag__c,CSS_Job__c,CSS_Job__r.Qsol_Engine_Family_Code__c,Dealer_Service_Job__c,CSS_Job__r.ApplicationCode__c,Dealer_Service_Job__r.ApplicationCode__c,CSS_Job__r.Service_Model__c,ReconEngineFlag__c,Location_Code__c,CoverageResponse__c,Information_Only_Claim__c,Multi_PSN_Claim__c,
                        (Select Application__c,Failure_Point__c,PSN__c,Qsol_Engine_Family_Code__c,Service_Model__c,Product_Hours__c,Mileage__c,Failure_Date__c,License_Plate_State__c,Before_In_Service__c,Calibration_After__c,Calibration_Before__c,Revision_After__c,Mileage_Measure__c, ApplicationCode__c, Warranty_Start_Date__c, Revision_Before__c from CSS_PSNs__r) from CSS_Claims__c WHERE ID =: wid];
            system.debug('*******claimsRec' + claimsRec);
            system.debug('*******claimsRec.Account__r.Type*****' + claimsRec.Account__r.Type);
            
            // if(claimsRec.Account__r.Type!=null && claimsRec.Account__r.Type!='' && claimsRec.Account__r.Type=='Dealer Account'){
            DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type);
            if(DealerTypeFlag ==true){
                dealerLocation=true;
            }
            else
                dealerLocation=false;
            if(claimsRec.CSS_PSNs__r.size()>0){
                psnRec = claimsRec.CSS_PSNs__r[0];    
            }
            
            
            solCompCampATC = [select Id,Claim_FailCode__c,Fail_Code__c, Selected_Component__c, Type__c from CSS_Solution_Component__c where Type__c in ('Campaign','ATC') and CSS_Claims__c =:claimsRec.id  and Status__c='Approved' and Selected_Component__c = true];
            system.debug('solCompCampATC'+solCompCampATC);
            
            
            
            if(solCompCampATC.size()>0)
            {
                solCompListOne = true;
            }else
            {
                solCompListOne = false;
            }
        }
        getAccCodeList();
        getclaimTypes();
        // system.debug('****after returned from method***');
        //system.debug('FName:'+selectedFName);
        //system.debug('SysCode:'+selectedSysCode);
        //system.debug('CompCode:'+selectedCompCode);
        
        //isDealer = true;
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType!=null && userType!= '') {
            if(userType == 'DLR') {
                isDealer = true;
            }else if(userType == 'DISTR') {
                isDealer = false;
            }
        }
        
        if(claimsRec.CSS_PSNs__r != null && claimsRec.CSS_PSNs__r.size()>0 && claimsRec.Multi_PSN_Claim__c == true && psnRec.Before_In_Service__c == true 
           && claimsRec.css_job__c == null){
               isMultiPSNEnabled = true;
           }
        
        //if(isDealer && claimsRec.CSS_PSNs__r[0].Multi_PSN_Claim__c == true && claimsRec.CSS_PSNs__r[0].Before_In_Service__c == false)
        if(claimsRec.Multi_PSN_Claim__c == true && psnRec.Before_In_Service__c == false){
            addFailureLink = true;
        }else{
            addFailureLink = false;
        }
        
        //if(isDealer && solCompListOne && claimsRec.CSS_PSNs__r[0].Multi_PSN_Claim__c == true && claimsRec.CSS_PSNs__r[0].Before_In_Service__c == true)
        if(solCompListOne && claimsRec.Multi_PSN_Claim__c == true && psnRec.Before_In_Service__c == true){
            addCampLink = true;
        }else{
            addCampLink = false;
        }
        callFaultCodesOnFocus();//Anirudh Changes
        //SRTFailurenamesOnLoad();
        //SRTFailurenames();//Anirudh Changes
    }
    
    public void onRadio(){
        radioYes = 'Yes';
    }
    
    //Method to load all failures data on page load
    public void getAllFailuresData(){
        try{
            listfailClaimspWrapper = new list<failureClaimsWrapper>();
            mapAccCode = new Map<string,String>();
            //lstpaycode = new list<string>();
            lstPaycodeValues = new List<SelectOption>();
            sjobIds = new Set<Id>();
            ////Added 3 fields from object into below Query as per defect #158390 and #158388,-By RAJESH on 13th Aug 2018
            // system.debug('***inside getallfailuresdata method****');
            //dispFailuresList = [Select id, name, CSS_Account_Formula__c, AccountCodeType__c, AccountCodeEdit__c, Selected_Component__c, Claims_Failure_Select__c, Solutions__c, Solutions__r.Service_Job__c,Solutions__r.FaultCode__r.Name, Solutions__r.FaultCode__r.RelatedFaultCode__c,Solutions__r.Symptom__r.Name,Solutions__r.Symptom__c, Service_Job__c, CSS_Claims__c, AccountCode__c, System_Code__c, Component_Code__c, Pay_Code__c from CSS_Solution_Component__c where CSS_Claims__c =: Wid and Solutions__c != null];
            // dispFailuresList = [Select id, name, CSS_Account_Formula__c, AccountCodeType__c, AccountCodeEdit__c, Selected_Component__c, Claims_Failure_Select__c, Solutions__c, Solutions__r.Service_Job__c,Solutions__r.FaultCode__r.Name, Solutions__r.FaultCode__r.RelatedFaultCode__c,Solutions__r.Symptom__r.Name,Solutions__r.Symptom__c, Service_Job__c, CSS_Claims__c, AccountCode__c, System_Code__c, Component_Code__c, Pay_Code__c from CSS_Solution_Component__c where CSS_Claims__c =: Wid and Selected_Component__c = true and Solutions__c != null]; // Kalpana: 136638
            dispFailuresList = [Select id, name, Failure_Mode__C,CSS_Account_Formula__c,FailMode_Desc__c,ComponentCode_Desc__c,SystemCode_Desc__c, AccountCodeType__c, AccountCodeEdit__c, Selected_Component__c, Claims_Failure_Select__c, Solutions__c, Solutions__r.Service_Job__c,Solutions__r.FaultCode__r.Name, Solutions__r.FaultCode__r.RelatedFaultCode__c,Solutions__r.Symptom__r.Name,Solutions__r.Symptom__c, Service_Job__c, CSS_Claims__c, AccountCode__c, System_Code__c, Component_Code__c, Pay_Code__c, Claim_Type__c, AccountCode_Call_Status__c from CSS_Solution_Component__c where CSS_Claims__c =: Wid and Selected_Component__c = true and type__C NOT IN ('TSB', 'TRP','ATC','Campaign')];
            //  system.debug('***dispfailureslist****'+dispFailuresList);
            /*List<CSS_Solution_Component__c> dispFailuresListFA = [Select id, CSS_Claims__c, Selected_Component__c, Type__c, AccountCode_Call_Status__c from CSS_Solution_Component__c where CSS_Claims__c =: Wid and Type__c IN ('TRP','ATC','Campaign') AND AccountCode_Call_Status__c = 'Failure' limit 1];
system.debug('dispFailuresListFA-->'+dispFailuresListFA.size());
if(dispFailuresListFA != null && dispFailuresListFA.size() > 0){
warrantyFailure = true;
}
system.debug('warrantyFailure-->'+warrantyFailure);*/
            
            if(dispFailuresList!=null && dispFailuresList.size()>0){
                for(css_solution_component__c SolComp1: dispFailuresList){
                    if(solComp1.Solutions__r.Service_Job__c != null){
                        //   system.debug('****servicejob****'+solComp1.Solutions__r.Service_Job__c);
                        sjobIds.add(solComp1.Solutions__r.Service_Job__c);
                    }
                }
                
                sympQAList = [select id, name,Type__c,Answers__c, (select id,Answers__c from CSS_SymptomQA__r) from CSS_SymptomQA__c where Job_Order__c IN: sjobIds];
                //  system.debug('****sympQAList***'+sympQAList);
                
                if(sympQAList !=null && sympQAList.size()>0){
                    for(CSS_SymptomQA__c sympQA:sympQAList){
                        if(sympQA.type__c == 'SearchString'){
                            //  system.debug('****sympQA.CSS_SymptomQA__r****'+sympQA.CSS_SymptomQA__r);
                            for(CSS_SymptomQA__c sympQAobj:sympQA.CSS_SymptomQA__r){
                                if(!fcSympMap.containsKey(sympQA.Id)){
                                    fcSympMap.put(sympQA.Id,new List<String>());
                                    fcSympMap.get(sympQA.Id).add(sympQAobj.Answers__c);
                                }
                                else{
                                    fcSympMap.get(sympQA.Id).add(sympQAobj.Answers__c);
                                }
                            }
                        }
                    }
                    
                }
                
                //  system.debug('****fcSympMap***'+fcSympMap);
                
                for(css_solution_component__c SolComp1: dispFailuresList){
                    //if(SolComp1.AccountCode__c !=null){
                    //LstAccCodes.add(SolComp1.AccountCode__c);
                    if(SolComp1.CSS_Account_Formula__c !=null && SolComp1.CSS_Account_Formula__c.trim() !=''){
                        LstAccCodes.add(SolComp1.CSS_Account_Formula__c.right(2).trim());
                        ////   system.debug('AccountCodeType__c**'+SolComp1.AccountCodeType__c);
                        system.debug('AccountCode__c**'+SolComp1.AccountCode__c);
                        //  system.debug('****RelatedFaultCode__c****'+solComp1.Solutions__r.FaultCode__r.RelatedFaultCode__c);
                    }
                }
                //   system.debug('ListofAccountCodes**'+LstAccCodes);
                List<CSS_JobEventTemporary__c> payCodeJETList = [select Attribute3__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes' and Attribute3__c IN :LstAccCodes];
                ////  system.debug('Reason**'+payCodeJETList);         
                for(CSS_JobEventTemporary__c jet: payCodeJETList){
                    // LstReasons.add(JET.Reason__c);
                    if(jet.Reason__c !=null){
                        mapAccCode.put(jet.Attribute3__c,jet.Reason__c);
                    }
                }
                //system.debug('mapAccCode**'+mapAccCode); 
                
                
                
                for(CSS_Solution_Component__c solcomp : dispFailuresList){
                    system.debug('***inside solcomp****');
                    String fcSymp;
                    if(solcomp != null){
                        
                        system.debug('***solcomp.Solutions__r.FaultCode__c****'+solcomp.Solutions__r.FaultCode__c);
                        system.debug('***solComp.Solutions__r.Symptom__r.Name****'+solComp.Solutions__r.Symptom__r.Name);
                        if(solcomp.Solutions__r.FaultCode__c != null){
                            system.debug('***insidefcIF');
                            fcSymp = solComp.Solutions__r.FaultCode__r.Name;
                        }
                        if(solComp.Solutions__r.Symptom__r.Name != '' && solcomp.Solutions__r.Symptom__r.Name != null){
                            system.debug('***insidesympIF');
                            fcSymp = solComp.Solutions__r.Symptom__r.Name;
                        }
                        
                        lstPaycodeValues = new List<SelectOption>();
                        //if(solComp.AccountCode__c !=null && solComp.AccountCode__c.trim() !='')
                        //lstPaycodeValues = getPayCodesList(solComp.AccountCode__c);
                        if(solComp.CSS_Account_Formula__c !=null && solComp.CSS_Account_Formula__c.trim() !='')
                            lstPaycodeValues = getPayCodesList(solComp.CSS_Account_Formula__c.right(2).trim());
                        if(solComp.CSS_Account_Formula__c !=null && solComp.CSS_Account_Formula__c.trim() !='')
                            lstPaycodeValues = getPayCodesList(solComp.CSS_Account_Formula__c.right(2).trim());
                        if(solComp.CSS_Account_Formula__c ==null || solComp.CSS_Account_Formula__c =='')
                            solComp.AccountCode__c = '02';
                        if(claimsRec.Information_Only_Claim__c == True){
                            solComp.Pay_Code__c = 'A';
                        }
                        /* if(solComp.CSS_Account_Formula__c !=null && solComp.CSS_Account_Formula__c.trim() !='')
                              accountcodeeditonfm = true;
                              system.debug('accountcodeeditonfm'+accountcodeeditonfm);
                              if(solComp.Failure_Mode__c!=null && solComp.Failure_Mode__c!='')
                              failmodeloadval = solComp.Failure_Mode__c;
                              system.debug('failmodeloadval'+failmodeloadval);*/
                        listfailClaimspWrapper.add(new failureClaimsWrapper(
                            solComp.CSS_Claims__c,
                            solComp.Id,
                            solComp.Solutions__c,
                            solComp.Claims_Failure_Select__c,
                            fcSymp,
                            solComp.name,
                            //Added 3 fields as per defect #158390 and #158388,-By RAJESH on 13th Aug 2018              
                            solComp.System_Code__c,
                            solComp.SystemCode_Desc__c,
                            solComp.Component_Code__c,
                            solComp.ComponentCode_Desc__c,
                            solComp.Failure_Mode__c, //Kalpana: 136638
                            solComp.FailMode_Desc__c,
                            solComp.CSS_Account_Formula__c,
                            solComp.Pay_Code__c,
                            lstPaycodeValues, 
                            fcSympMap.get(solComp.Solutions__r.Symptom__c),
                            solComp.Service_Job__c, //kalpana: 137806
                            solComp.Claim_Type__c
                        ));
                    }
                    system.debug('***fcSymp***'+fcSymp);
                    system.debug('***solComp.Failure_Mode__c***'+solComp.Failure_Mode__c);
                    system.debug('***solComp.FailMode_Desc__c***'+solComp.FailMode_Desc__c);
                } 
            }
            system.debug('***listfailClaimspWrapper****'+listfailClaimspWrapper);  
        }
        catch(Exception ex){
            System.debug('in catch of getAllFailuresData>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
    //Method for getting PayCode values  
    public List<SelectOption> getPayCodesList(String accCodeKey) {
        List<SelectOption> lstPaycodeValues;
        String reason1;
        try {
            lstPaycodeValues = new List<SelectOption>();
            lstpaycode = new list<string>();
            system.debug('accCodeKey'+accCodeKey);
            system.debug('mapAccCode'+mapAccCode);
            reason1 = mapAccCode.get(accCodeKey);
            system.debug('Reason1**'+reason1);
            List<CG_payCodeResJ2A> accountCodeResponse;
            if(reason1 != null){
                accountCodeResponse = (List<CG_payCodeResJ2A>)JSON.deserializeStrict(reason1, List<CG_payCodeResJ2A>.class);
                system.debug('accountCodeResponse-->'+accountCodeResponse);
            }
            if(accountCodeResponse !=null && accountCodeResponse.size()>0){
                //lstpaycode = new list<string>();
                for(integer i=0;i<accountCodeResponse.size();i++)
                {
                    String strLstPC=accountCodeResponse[i].paycode;
                    if(!lstpaycode.contains(strLstPC)){
                        lstpaycode.add(accountCodeResponse[i].paycode);
                    }
                }
            }
            system.debug('lstpaycode**'+lstpaycode);
            if(lstpaycode !=null && lstpaycode.size()>0)
                lstPaycodeValues = getPayCodes(lstpaycode);
            
        }catch(Exception e)  {
            system.debug('EXCEPTION of getPayCodesList method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return lstPaycodeValues;
    }
    
    //Method for getting PayCode values  
    public List<SelectOption> getPayCodes(List<String> lstpaycode) {
        List<SelectOption> lstPCValues;
        try {
            lstPCValues=new List<SelectOption>();
            System.debug('lstpaycode>>>'+lstpaycode);
            for(integer i=0;i<lstpaycode.size();i++){
                lstPCValues.add(new SelectOption(lstpaycode[i],lstpaycode[i]));
            }
            system.debug('lstPCValues**'+lstPCValues);
            /*  if(payCodeSelected != null && payCodeSelected != '')
lstPCValues.add(new SelectOption(payCodeSelected,payCodeSelected));*/
            system.debug('lstPCValuesAfter**'+lstPCValues);
        }catch(Exception e)  {
            system.debug('EXCEPTION of getPayCodes method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return lstPCValues;
    }
    
    //Resetting the updated data to the previous values 
    public void resetAllData(){
        getAllFailuresData();
    }
    
    public Map<string,string> getGsqcustFailurenameslist() { 
        
        //List<String> tempStr = new List<String>();
        //tempStr.add('Siebel failure');
        return custFailureNameList;
    }
    
    //function to reset the selectedvalues when cancel is pressed
    public void cancelPopup(){
        selectedFName =   '';
        selectedCompId = ''; 
        accCodeSelected = '';
        selectedSysCode = ''; 
        selectedFailureID = '';
        selectedCompCode = ''; 
        selectedFailMode = ''; 
        payCodeSelected= '';
        accountcodeeditonfm=  false;
        failmodeloadval='';
        FCErrorVal = false;
        lstPCvalues= new List<SelectOption>();
        selectedFaultCode = ''; 
        blankfield = false;
        checkPartsWarrStartDt = false;
        solCompExistsFlag = 'false';
        selectedCustFName = '';
        //Commented as per story The Office 164459
        //OneaccCodeBool = '';
        isMultiPSNErrorExist = false;
        errornotcovfound = false;
        Bool = false;
        //warrantyFailure = false;
        clearPopup();
    }
    
    //function to close the deletepopup
    public void closeDeletePopup(){
        deleteCompId=null;    
    }
    
    public PageReference deleteSolRecordWOPSN(){
        system.debug('inside deleteSolRecordWOPSN method');
        system.debug('deleteCompId***'+deleteCompId);        
        if(deleteCompId!=null){
            try{
                
                //deleting all associated line items
                deleteSolRecord();
                
                /* //old code
CSS_Solution_Component__c deleteSol = [select Id, FailCode_Formula__c, CSS_Account_Formula__c
from CSS_Solution_Component__c
where id=: deleteCompId];
CSS_Parts_Options__c[] Parts = [Select id,Option_Number__c from CSS_Parts_Options__c
where RecordType.Name = 'Parts' and CSS_Claims__c =: Wid and FailurepartId__c =:deleteCompId order by Part_Name__c];

CSS_SRT__c[] SRTList = [select Id from CSS_SRT__c 
where Type__c = '99Time' AND Account_Code_Description__c =: deleteSol.CSS_Account_Formula__c
AND Fail_Code_Description__c =: deleteSol.FailCode_Formula__c];
if(Parts != null && Parts.size() > 0)
delete Parts;
if(SRTList != null && SRTList.size() > 0)
delete SRTList;
delete deleteSol;  */
                
                
                
                /**** ater delete checking policy claim for other failures *******/
                
                set<String> policyACset = new set<String>();  
                List<CSS_JobEventTemporary__c> jobEventTemp = [SELECT Id, Attribute1__c,Attribute2__c, Attribute3__c, Attribute4__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' AND Attribute1__c ='POL' ];
                if(jobEventTemp != null && jobEventTemp.size() > 0){
                    for(CSS_JobEventTemporary__c temp : jobEventTemp) {
                        policyACset.add(temp.Attribute2__c + ' ' + temp.Attribute3__c);
                    }
                }
                
                system.debug('policyACset' + '  '+ policyACset);
                
                
                
                Map<Id, list<CSS_Solution_Component__c>> ClaimsSCMap = new Map<Id, list<CSS_Solution_Component__c>>();
                List<CSS_Solution_Component__c> solutionList = [Select id,AccountCode__c,CSS_Account_Formula__c,CSS_CoverageType__c, CSS_Claims__c 
                                                                from CSS_Solution_Component__c where CSS_Claims__c = :Wid ];//order by CSS_Claims__c
                
                system.debug('solutionList' + '  ' + solutionList);
                List<CSS_Solution_Component__c> tempSCList;
                if(solutionList != null && solutionList.size()>0){
                    for(CSS_Solution_Component__c sol : solutionList) {
                        if(ClaimsSCMap.containsKey(sol.CSS_Claims__c)) {
                            tempSCList = ClaimsSCMap.get(sol.CSS_Claims__c);
                            tempSCList.add(sol);
                        } else {
                            tempSCList = new List<CSS_Solution_Component__c>();
                            tempSCList.add(sol);
                            ClaimsSCMap.put(sol.CSS_Claims__c, tempSCList);
                        }
                    }
                }
                
                system.debug('ClaimsSCMap' + '  ' + ClaimsSCMap);
                
                set<Id> updateClaimIdSet = new set<Id>();
                Boolean isPolicyClaim;
                if(ClaimsSCMap != null && ClaimsSCMap.size() >0) {
                    for(Id claimsId : ClaimsSCMap.keyset()) {
                        List<CSS_Solution_Component__c> tempSCLists = ClaimsSCMap.get(claimsId);
                        system.debug('tempSCLists' + '  ' + tempSCLists);
                        if(tempSCLists.size()>0){
                            for(CSS_Solution_Component__c sol : tempSCLists) {
                                if(policyACset.contains(sol.CSS_Account_Formula__c)) {
                                    updateClaimIdSet.add(claimsId);
                                    isPolicyClaim = true;
                                    break;
                                }
                                else{
                                    isPolicyClaim = false;
                                }
                            }
                        }
                    }
                }
                system.debug('updateClaimIdSet ' + '   ' + updateClaimIdSet);
                system.debug('isPolicyClaim' + ' ' + isPolicyClaim);
                list<CSS_Claims__c> claimPolicyList = new list<CSS_Claims__c>();
                
                if(isPolicyClaim == true){
                    system.debug('inside if isPolicyClaim' + ' ' + isPolicyClaim);
                    for(Id claimsId : updateClaimIdSet) {
                        CSS_Claims__c claimPol = new CSS_Claims__c();
                        claimPol.id = claimsId;
                        claimPol.PolicyClaim__c = true;
                        claimPolicyList.add(claimPol);
                    }
                    
                }
                else {
                    system.debug(' inside else isPolicyClaim' + ' ' + isPolicyClaim);
                    CSS_Claims__c claimPol = new CSS_Claims__c();
                    claimPol.id = Wid;
                    system.debug(' claimPol.id' + ' ' + claimPol.id);
                    claimPol.PolicyClaim__c = false;
                    claimPolicyList.add(claimPol);
                    
                }
                
                if(claimPolicyList != null && claimPolicyList.size() >0)
                    update claimPolicyList;
                system.debug('claimPolicyList' +  '  ' + claimPolicyList); 
                
                /**** End ater delete checking policy claim for other failures *******/
                
                
            }catch(Exception e){
                System.debug('exception in DeleteSolRecord function'+e.getMessage() + ' ' + e.getLineNumber());
            }
            
            PageReference  pageRef = new pageReference('/apex/CG_ClaimsFC?id='+wid);
            pageRef.setRedirect(true);
            return pageRef;
        }
        
        return null;
        
    }
    public boolean mileageProdHrsError{get;set;}
    //function to delete the Solution Component Record on Delete Button with Multi PSN
    public PageReference deleteSolRecord(){
        system.debug('inside deleteSolRecord method');
        system.debug('deleteCompId***'+deleteCompId);        
        if(deleteCompId!=null){
            Boolean multipleFailuresFlag = false;
            try{
                CSS_Solution_Component__c deleteSol = [select Id, Fail_Code__c, FailCode_Formula__c, CSS_Account_Formula__c
                                                       from CSS_Solution_Component__c
                                                       where id=: deleteCompId];
                String failCodeSelected = deleteSol.Fail_Code__c;
                
                //Step1:
                List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>([select Id, Fail_Code__c, FailCode_Formula__c, CSS_Account_Formula__c
                                                                                                   from CSS_Solution_Component__c where CSS_Claims__c=:Wid and Fail_Code__c=:deleteSol.Fail_Code__c and Type__c !='CAMPAIGN' and Type__c !='TRP' and Type__c !='ATC']);
                if(solCompList != null && solCompList.size() > 1)
                    multipleFailuresFlag = true;
                System.debug('deleteSol.Fail_Code__c>>>:'+deleteSol.Fail_Code__c+' multipleFailuresFlag>>:'+multipleFailuresFlag);
                
                //Deletion of SRTs
                CSS_SRT__c[] SRTList = new List<CSS_SRT__c>([select Id,FailCode__c,AccountCode_Formula__c from CSS_SRT__c where FailCode__c !=null and FailCode__c =: deleteSol.Fail_Code__c and CSS_Claims__c=:Wid 
                                                             and Type__c !='Field Action' and Type__c !='Field Action Access' and Type__c !='CAMPAIGN' and Type__c !='TRP' and Type__c !='ATC']);
                if(SRTList != null && SRTList.size() > 0){
                    if(!multipleFailuresFlag){
                        //Single Failure case
                        delete SRTList;
                        System.debug('11 SRTList>>:'+SRTList.size());
                    }else{
                        System.debug('22 deleteSol.Fail_Code__c>>>:'+deleteSol.Fail_Code__c+' multipleFailuresFlag>>:'+multipleFailuresFlag);
                        //Multiple Failures case
                        List<CSS_SRT__c> deleteSRTList = new List<CSS_SRT__c>();
                        for(CSS_SRT__c srtObj:SRTList){
                            if(deleteSol.CSS_Account_Formula__c !=null && srtObj.AccountCode_Formula__c !=null 
                               && deleteSol.CSS_Account_Formula__c == srtObj.AccountCode_Formula__c){ //need to check only account code 2 digit???
                                   deleteSRTList.add(srtObj);
                                   System.debug('222 Id>>:'+srtObj.Id+' srtObj.AccountCode_Formula__c>>:'+srtObj.AccountCode_Formula__c+' deleteSol.CSS_Account_Formula__c>:'+deleteSol.CSS_Account_Formula__c);
                               }
                        }
                        if(deleteSRTList != null && deleteSRTList.size() > 0)
                            delete deleteSRTList;
                    }
                }
                
                system.debug('after delete SRTs...***'+deleteCompId);
                //Deletion of Parts, OCs, TTML
                CSS_Parts_Options__c[] partsList = new List<CSS_Parts_Options__c>([Select Id,Option_Number__c,Fail_Code__c,Get_Fail_Code_Formula__c,Account_Code__c from CSS_Parts_Options__c where CSS_Claims__c =: Wid and (Fail_Code__c !=null or Get_Fail_Code_Formula__c !=null) ]);
                if(partsList != null && partsList.size() > 0){
                    List<CSS_Parts_Options__c> partsListTemp = new List<CSS_Parts_Options__c>();
                    if(!multipleFailuresFlag){
                        //Single Failure case
                        for(CSS_Parts_Options__c partObj:partsList){
                            if( (partObj.Fail_Code__c !=null && partObj.Fail_Code__c.Right(4)==deleteSol.Fail_Code__c) 
                               || (partObj.Get_Fail_Code_Formula__c !=null && partObj.Get_Fail_Code_Formula__c.contains('-') && partObj.Get_Fail_Code_Formula__c.Right(4)==deleteSol.Fail_Code__c) ){
                                   partsListTemp.add(partObj);
                                   System.debug('111 partsListTemp>>:'+partsListTemp.size());
                               }
                        }
                        if(partsListTemp != null && partsListTemp.size() > 0)
                            delete partsListTemp;
                        
                    }else{
                        System.debug('222 deleteSol.Fail_Code__c>>>:'+deleteSol.Fail_Code__c+' multipleFailuresFlag>>:'+multipleFailuresFlag);
                        //Multiple Failures case
                        system.debug('PartsList**'+partsList);
                        for(CSS_Parts_Options__c partObj:partsList){
                            if( (partObj.Fail_Code__c !=null && partObj.Fail_Code__c.Right(4)==deleteSol.Fail_Code__c 
                                 && partObj.Account_Code__c !=null && deleteSol.CSS_Account_Formula__c !=null && partObj.Account_Code__c==deleteSol.CSS_Account_Formula__c) 
                               || (partObj.Get_Fail_Code_Formula__c !=null && partObj.Get_Fail_Code_Formula__c.contains('-') && partObj.Get_Fail_Code_Formula__c.Right(4)==deleteSol.Fail_Code__c 
                                   && partObj.Account_Code__c !=null && deleteSol.CSS_Account_Formula__c !=null && partObj.Account_Code__c==deleteSol.CSS_Account_Formula__c) ){ //need to check only account code 2 digit???
                                       partsListTemp.add(partObj);
                                       System.debug('222 Id>>:'+partObj.Id+' partObj.Account_Code__c>>:'+partObj.Account_Code__c+' deleteSol.CSS_Account_Formula__c>:'+deleteSol.CSS_Account_Formula__c);
                                   }
                        }
                        if(partsListTemp != null && partsListTemp.size() > 0)
                            delete partsListTemp;
                    }
                }
                system.debug('after delete Parts...***'+deleteCompId);
                
                //finally delete selected solComp
                system.debug('1before deletion deleteCompId:'+deleteCompId);
                List<Id> solCompIdList = new List<Id>();
                solCompIdList.add(deleteCompId);
                CG_CL_UpdateFailureODMStatus.updateODMStatusForFailuresCall(solCompIdList); //calling ODM to update statuses
                delete deleteSol;
                system.debug('2after deletion deleteCompId:'+deleteCompId);
                
                
                //159053 start
                //RAJESH Start
                system.debug('isMultiPSNEnabled:'+isMultiPSNEnabled);
                if(isMultiPSNEnabled !=null && isMultiPSNEnabled){
                    List<CSS_PSN__c> psnList = new List<CSS_PSN__c>([select Id, Name, CSS_Claims__c, Warranty_Start_Date__c, Primary__c, Before_In_Service__c, PSN__c,Product_Hours__c,Mileage__c 
                                                                     from  CSS_PSN__c where CSS_Claims__c=: Wid AND Primary__c=false]);
                    if(psnList != null && psnList.size() > 0)
                        delete psnList;
                    //159053 End
                    system.debug('psnList888888'+psnList);
                    system.debug('psnList.size()888888'+psnList.size());
                }
                //RAJESH END
                //106
                 List<CSS_Solution_Component__c> compList = new List<CSS_Solution_Component__c>([select Id, Fail_Code__c, FailCode_Formula__c, CSS_Account_Formula__c
                                                                                                   from CSS_Solution_Component__c where CSS_Claims__c=:Wid  and Type__c !='CAMPAIGN' and Type__c !='TRP' and Type__c !='ATC']);
                 try{
            
            //compList = [SELECT Id, Component_Id__c,FailCode_Formula__c,CSS_Account_Formula__c, Type__c, CampaignLaborPercentage__c FROM 
                       // CSS_Solution_Component__c where  CSS_Claims__c =:claimsRec.id and Selected_Component__c = : true];
            system.debug('compList--'+compList);
            for(CSS_Solution_Component__c solComp:compList){
                system.debug('solComp.CSS_Account_Formula__c--'+solComp.CSS_Account_Formula__c);
                system.debug('claimsRec.Automotive_App_Flag__c--'+claimsRec.Automotive_App_Flag__c);
                system.debug('psnRec.License_Plate_State__c--'+psnRec.License_Plate_State__c);
                system.debug('psnRec.Mileage__c--'+ psnRec.Mileage__c);
                system.debug('psnRec.Product_Hours__c--'+psnRec.Product_Hours__c);
                if(solComp.CSS_Account_Formula__c != null && solComp.CSS_Account_Formula__c != '' && solComp.CSS_Account_Formula__c.contains('70')){
                    if(claimsRec.Automotive_App_Flag__c == 'Y' && psnRec.License_Plate_State__c == 'CA - California'){
                        if((psnRec.Mileage__c == null || psnRec.Mileage__c == 0) || (psnRec.Product_Hours__c == null || psnRec.Product_Hours__c == 0)){
                            //workJob.Id = Wid;
                            //workJob.MileageProdHrsError__c = 'Error';
                            mileageProdHrsError = true;
                        }
                        else{
                            //workJob.Id = Wid;
                            //workJob.MileageProdHrsError__c = 'Success';
                            mileageProdHrsError = false;
                        }
                    }

                }

            }
            CSS_Claims__c mileageProdHrsErrorUpd = new CSS_Claims__c();
            mileageProdHrsErrorUpd.Id = claimsRec.id;
            system.debug('mileageProdHrsError--'+mileageProdHrsError);
            if(mileageProdHrsError == true){
                mileageProdHrsErrorUpd.MileageProdHrsError__c = 'Error';
            }
            else{
                mileageProdHrsErrorUpd.MileageProdHrsError__c = 'Success';
            }

            CSS_Claims__c clmObj = [Select id,name, (Select id,name from CSS_Solution_Components__r),
                                    (select id from CSS_SRTs__r),
                                    (select id from CSS_Parts_Options__r) from CSS_Claims__c where id=:claimsRec.id];
            system.debug('clmObj***'+clmObj);
            if(clmObj != null && clmObj.CSS_Solution_Components__r != null && clmObj.CSS_Solution_Components__r.size()>0 && clmObj.CSS_SRTs__r != null && clmObj.CSS_SRTs__r.size()>0 && clmObj.CSS_Parts_Options__r != null && clmObj.CSS_Parts_Options__r.size()>0)
            {}else{
                mileageProdHrsErrorUpd.Failures_ODM_Status__c='';
                mileageProdHrsErrorUpd.SRTs_ODM_Status__c='';
                mileageProdHrsErrorUpd.Parts_ODM_Status__c='';
            }
            update mileageProdHrsErrorUpd;
            system.debug('mileageProdHrsErrorUpd.MileageProdHrsError__c--'+mileageProdHrsErrorUpd.MileageProdHrsError__c);
        }
        catch(Exception ex){
            System.debug('Page Action >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
               
                
                //106END
                
            }catch(Exception e){
                System.debug('exception in DeleteSolRecord function '+e.getMessage() + ' ' + e.getLineNumber());
            }
            
            PageReference  pageRef = new pageReference('/apex/CG_ClaimsFC?id='+wid);
            pageRef.setRedirect(true);
            return pageRef;
        }
        
        return null;
        
    }
    
    //Method for delete the only multi psn records on popup save #159053
    public PageReference deletePSNRecord(){
        system.debug('inside Delete method on popup save');
        system.debug('selectedCompId***'+selectedCompId);
        if(selectedCompId!=null){
            system.debug('selectedCompId  Inside');
            
            //deleting all associated line items
            deleteCompId = selectedCompId;
            deleteSolRecord();
            deleteCompId = null;
            
            //below code is not needed since deleting in above called method
            CSS_PSN__c[] psnList = [select Id, Name, CSS_Claims__c, Warranty_Start_Date__c, Primary__c, Before_In_Service__c, PSN__c,Product_Hours__c,Mileage__c 
                                    from  CSS_PSN__c 
                                    where CSS_Claims__c=: Wid AND Primary__c=false];
            system.debug('psnList888888'+psnList);
            system.debug('psnList.size()888888'+psnList.size());
            if(psnList != null && psnList.size() > 0)
                delete psnList;
            
        }
        return null;
    }
    
    //function to load the values when edit button is pressed
    public void loadPopup() {
        try{
            showDisabledAC = false;    
            isMultiPSNErrorExist = false;
            errornotcovfound = false;
            dateErrFlag=false; 
            higherdateErrFlag=false;
            failureDate=null;
            Bool=false;
            system.debug('selectedCompId***'+selectedCompId);
            //query the respected solution component record
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
            solCompList =[Select Name, Over_The_Counter__c, FailMode_Desc__c,CSS_Custom_Failure__c,ComponentCode_Desc__c,SystemCode_Desc__c,FaultCode_Desc__c,id,Component_Id__c,Claim_Type__c,Authorization_Number__c,Covered_Parts__c,Covered_Labor__c,Approval_Code__c,AccountCodeEdit__c,System_Code__c,Component_Code__c,Failure_Mode__c,CSS_Account_Formula__c,Pay_Code__c,Part_Warranty_Start_Date__c, Failure_Date__c, Failure_Point__c,Customer_Take_Possession__c, Failure_Measure__c,Fault_Code__c,Solutions__c,Solutions__r.FaultCode__c,Solutions__r.Symptom__r.Name,Solutions__r.FaultCode__r.Name,Solutions__r.Symptom__c from CSS_Solution_Component__c where ID =:selectedCompId];
            system.debug('solCompList***'+solCompList);
            system.debug('solCompList[0].Failure_Point__c***'+solCompList[0].Failure_Point__c);
            system.debug('solCompList[0].Failure_Date__c***'+solCompList[0].Failure_Date__c);
            system.debug('solCompList[0].Part_Warranty_Start_Date__c***'+solCompList[0].Part_Warranty_Start_Date__c);
            //put the record in the selected variable to reflect in the edit popup
            if(solCompList.size()>0){
                coverageFound = 'false';
                selectedFName =  solCompList[0].Name ;
                selectedSysCode = solCompList[0].System_Code__c; 
                selectedCompCode =solCompList[0].Component_Code__c; 
                selectedFailureID = solCompList[0].Component_Id__c;
                selectedCustFName = solCompList[0].CSS_Custom_Failure__c;
                if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
                    system.debug('selectedCompCode'+selectedCompCode);
                    system.debug('insidesaveandunloisted');
                    if(selectedSysCode.length()>2)
                        selectedSysCode=selectedSysCode.substring(0,2);
                    if(selectedCompCode.length()>2)
                        selectedCompCode=selectedCompCode.substring(0,2);
                    system.debug('selectedSysCode'+selectedSysCode);
                    system.debug('selectedCompCode'+selectedCompCode);
                    
                    if(selectedSysCode != null && selectedSysCode != '' && selectedCompCode!=null && selectedCompCode!='') {
            //Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020            
                        List<CSS_JobEventTemporary__c> tempList = [select Attribute1__C,Attribute4__c,Attribute7__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C=:selectedSysCode and Attribute4__c=:selectedCompCode and Active__c=true];
                        if(tempList!=null && tempList.size()>0)
                            selectedCustFName =tempList[0].Attribute7__c;
                        system.debug('Coming to popUpSave Method USE CASE : 3'+ solCompList[0].Name);
                        
                    }
                }
                
                if(solCompList[0].SystemCode_Desc__c != null && solCompList[0].SystemCode_Desc__c != '' && solCompList[0].ComponentCode_Desc__c != '' && solCompList[0].ComponentCode_Desc__c != null){
                    selectedSysCode = solCompList[0].SystemCode_Desc__c; 
                    selectedCompCode = solCompList[0].ComponentCode_Desc__c; 
                }
                else{
                    selectedSysCode = solCompList[0].System_Code__c; 
                    selectedCompCode = solCompList[0].Component_Code__c;
                }
                
                selectedCompId = solCompList[0].id; 
                accCodeSelected = solCompList[0].CSS_Account_Formula__c;
                selectedFailMode = solCompList[0].Failure_Mode__c ; 
                system.debug('selectedFailMode vlaue'+selectedFailMode);
                selectedFaultCode = solCompList[0].Fault_Code__c;
                payCodeSelected=   solCompList[0].Pay_Code__c ;
                AuthorizationNumber = solCompList[0].Authorization_Number__c;
                Coveredpartspercentage = solCompList[0].Covered_Parts__c;
                CoverageLaborpercentage = solCompList[0].Covered_Labor__c;
                ApprovalCode = solCompList[0].Approval_Code__c;
                compont.Part_Warranty_Start_Date__c = solCompList[0].Part_Warranty_Start_Date__c ;
                compont.Failure_Date__c = solCompList[0].Failure_Date__c ; 
                compont.Failure_Point__c = solCompList[0].Failure_Point__c ;
                compont.name = solCompList[0].name ;
                compont.FailMode_Desc__c=solCompList[0].FailMode_Desc__c;
                compont.FaultCode_Desc__c=solCompList[0].FaultCode_Desc__c;
                compont.SystemCode_Desc__c=solCompList[0].SystemCode_Desc__c;
                compont.ComponentCode_Desc__c=solCompList[0].ComponentCode_Desc__c;
                compont.System_Code__c=solCompList[0].System_Code__c;
                compont.Component_Code__c=solCompList[0].Component_Code__c;
                compont.Over_The_Counter__c = solCompList[0].Over_The_Counter__c; //GSSC-298
                oldOTCValue = solCompList[0].Over_The_Counter__c; //GSSC-298
                oldFailCode = solCompList[0].System_Code__c.trim()+solCompList[0].Component_Code__c.trim();//GSSC-298
                oldAccCode = solCompList[0].CSS_Account_Formula__c;//GSSC-298
                //if(compont.Customer_Take_Possession__c!=null && compont.Customer_Take_Possession__c!='')
                Possession = solCompList[0].Customer_Take_Possession__c ;
                failureMeasure = solCompList[0].Failure_Measure__c;
                claimTypeSelected = solCompList[0].Claim_Type__c;
                
            }
            //Added below code as per Band of Brother story #152406,#152400 and #152399,-By RAJESH 08th Aug 2018       
            if(selectedFailMode!= null && selectedFailMode!=''){
                List<CSS_JobEventTemporary__c>  jobEvFM=[select Attribute1__c,Active__c, Attribute3__c 
                                                         from CSS_JobEventTemporary__c 
                                                         where key__c='FailModes' and Active__c= true limit 1000];
                system.debug('jFM>>>'+jobEvFM.size());  
                for(CSS_JobEventTemporary__c jFM : jobEvFM){
                    if(selectedFailMode==jFM.Attribute1__c){
                        selectedFailMode = selectedFailMode+'-'+ jFM.Attribute3__c; 
                    }
                    system.debug('jFM>>>'+jobEvFM.size());  
                } 
            }
     //GSSC-290 
        system.debug('selectedFailMode'+selectedFailMode);
        if(selectedFailMode!=null && selectedFailMode!=''){
        failmodeloadval = selectedFailMode;
        }
        else
         failmodeloadval ='';
          system.debug('failmodeloadval'+failmodeloadval);
      //GSSC-290
            
            Map<String, CSS_JobEventTemporary__c> mapJET = new Map<String,CSS_JobEventTemporary__c>();
//Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020            
            for(CSS_JobEventTemporary__c lstjet : [select Attribute1__c,Attribute3__c,Attribute2__c,Attribute4__c,Attribute5__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Active__c=true]){
                string temp = lstjet.Attribute1__c+lstjet.Attribute4__c;
                if(!mapJET.containsKey(temp)){
                    mapJET.put(temp,lstjet);
                }
                
            }
            if(selectedSysCode!= null && selectedCompCode!= null){
                //List<CSS_JobEventTemporary__c>  jobEvSCCC=[select  Attribute1__c,Attribute4__c,Attribute5__c ,Attribute3__c
                // from CSS_JobEventTemporary__c 
                // where key__c='FailCodes' limit 1000];
                string temp1 = selectedSysCode+selectedCompCode;
                if(mapJET!= null){
                    CSS_JobEventTemporary__c jobEveRec = new CSS_JobEventTemporary__c();
                    jobEveRec = mapJET.get(temp1);
                    //if(jobEveRec.Attribute4__c==det.ComponentCode && jobEveRec.Attribute1__c==det.SystemCode){
                    
                    if(jobEveRec != null && selectedSysCode==jobEveRec.Attribute1__c && selectedCompCode == jobEveRec.Attribute4__c){
                        selectedSysCode=selectedSysCode+'-'+jobEveRec.Attribute3__c;
                        selectedCompCode=selectedCompCode+'-'+jobEveRec.Attribute5__c;
                    }
                    //}
                    
                }
                /* for(CSS_JobEventTemporary__c jSCCC :jobEvSCCC){
if(selectedSysCode==jSCCC.Attribute1__c && selectedCompCode == jSCCC.Attribute4__c){
selectedSysCode=selectedSysCode+'-'+jSCCC.Attribute3__c;
selectedCompCode=selectedCompCode+'-'+jSCCC.Attribute5__c;
}
//if(selectedCompCode==jSCCC.Attribute4__c){

//}
}*/
            }
            system.debug('solCompList[0].Fault_Code__c' +solCompList[0].Fault_Code__c);
            system.debug('solCompList[0].Solutions__r.Symptom__r.Name'+solCompList[0].Solutions__r.Symptom__r.Name);
            
            Boolean NumericFaultCode;
            if(solCompList[0].Fault_Code__c != null && solCompList[0].Fault_Code__c != ''){
                selectedFaultCode = solCompList[0].Fault_Code__c;
            }
            else if(solCompList[0].Solutions__r.Symptom__r.Name != null && solCompList[0].Solutions__r.Symptom__r.Name != ''){
                
                selectedFaultCode = solCompList[0].Solutions__r.Symptom__r.Name;
            }
            else
                selectedFaultCode = solCompList[0].Solutions__r.FaultCode__r.Name;
            
            if( selectedFaultCode != null && selectedFaultCode.contains('-')){
                string[] SFC = selectedFaultCode.split('-');
                NumericFaultCode =SFC[0].isNumeric();
            }
            else
                NumericFaultCode = false;
            
            if(selectedFaultCode != null && (!NumericFaultCode || selectedFaultCode == '')){
                
                selectedFaultCode = '';
            }
            
            system.debug('After selectedFaultCode ' +selectedFaultCode);
            
            
            if(selectedFaultCode!= null && selectedFaultCode!= null){
                //Story 188014 code changes start
                List<CSS_SMN_FaultCode__c> tempList = [select FC_Desc__c,Fault_Code__c from CSS_SMN_FaultCode__c where SMN__c=: psnRec.Service_Model__c];
                for(CSS_SMN_FaultCode__c jSCCC :tempList){
                    if(selectedFaultCode == jSCCC.Fault_Code__c){
                        selectedFaultCode = jSCCC.FC_Desc__c;
                    }
                    
                }
               tempList = null; 
               //Story 188014 code changes start
            }
            //End  
            
            system.debug('selectedFaultCode>>' + selectedFaultCode);
            
            if(accCodeSelected != null && accCodeSelected != ''){
                oldAccountCode=accCodeSelected;
                showDisabledAC = false;
                 accountcodeeditonfm = true;// GSSC-290
                string orgtype=css_utility.getOrgType(userinfo.getUserId());
                User usr;
                usr = css_utility.getUserAttributes(userinfo.getUserId());
                string userRole = usr.UserRoleName__c;
                List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
                if (orgtype=='DISTR' || userrole.contains('Factory')){
                    system.debug('inside distru');
                    //Added claimsRec.PACCAR_Converted_to_PW__c == true condition below as part of the story GSSC-71
                    if(claimsRec.PACCAR_Converted_to_PW__c == true || (claimsRec.No_Failure_PACCAR_Flag__c == true && claimsRec.Parts_Warranty_Claim_Only__c == true) || claimsRec.PACCAR_PW_AutoSelected__c == true || (claimsRec.IsDealerCreatedClaim__c && claimsRec.Parts_Warranty_Claim_Only__c && claimsRec.PACCAR_Auth_Required__c 
                                                                                                                                                                          && claimsRec.PACCAR_Flag__c && !claimsRec.CSS_PACCAR_Auth_Track__c)) {
                          jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' AND Attribute1__c in ('POL', 'NPW', 'RPW') order by Attribute2__c asc];
                      } else {
                          jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' order by Attribute2__c asc];
                      }
                }
                else{//Added claimsRec.PACCAR_Converted_to_PW__c == true condition below as part of the story GSSC-71
                    if(claimsRec.PACCAR_Converted_to_PW__c == true || (claimsRec.No_Failure_PACCAR_Flag__c == true && claimsRec.Parts_Warranty_Claim_Only__c == true) || claimsRec.PACCAR_PW_AutoSelected__c == true || (claimsRec.IsDealerCreatedClaim__c && claimsRec.Parts_Warranty_Claim_Only__c && claimsRec.PACCAR_Auth_Required__c 
                                                                                                                                                                          && claimsRec.PACCAR_Flag__c && !claimsRec.CSS_PACCAR_Auth_Track__c)) {
                          jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' AND Attribute1__c in ('NPW','RPW') order by Attribute2__c asc];
                      } else {
                          jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Attribute15__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                      }
                }
                
                
                if(jobEventTemp.size() > 0){
                    system.debug('jobEventTemp.size()-->'+jobEventTemp.size());
                    system.debug('jobEventTempData-->'+jobEventTemp);
                    accCodes = new List<SelectOption>();
                    List<SelectOption> accCodesNew = new List<SelectOption>();
                    accCodes.add(new SelectOption('Select One','Select One'));
                    accCodesNew.add(new SelectOption(accCodeSelected,accCodeSelected));
                    for(CSS_JobEventTemporary__c j : jobEventTemp){
                        string s = j.Attribute2__c+' '+ j.Attribute3__c;
                        //accCodes.add(new SelectOption(j.Attribute2__c,s));
                        if(s != accCodeSelected)
                            accCodesNew.add(new SelectOption(s,s));
                        //accCode = accCodeSelected;  
                    }
                    accCodesNew.sort();
                    accCodes.addAll(accCodesNew);
                }
                lstPCvalues = getPayCodesList(accCodeSelected.right(2).trim());
            }
            /*  else{
showDisabledAC = true;
}*/
            // Story- GSSC-75
            if(selectedSysCode!= null && selectedSysCode!= '' && (selectedSysCode.startsWith('EQ') || selectedSysCode.startsWith('WE'))) {
                Bool = true;
            }
            // Story- GSSC-75
            getCoverageType();
            validatedisabilityparts();
            updateSRTFailNames();
            
        }
        catch(Exception e)  {
            system.debug('EXCEPTION of failureoverview method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }  
    }
    
    //Method for getting Failure Popup on Account code-159053
    public Boolean DeletePopupAC(){
        system.debug('Inside DeletePopupAC');
        system.debug('accCodeSelected****'+accCodeSelected);
        system.debug('oldAccountCode*****'+oldAccountCode);
        if(accCodeSelected != null && accCodeSelected != '' && oldAccountCode != null && oldAccountCode.trim() !='' 
           && claimsRec.CSS_PSNs__r != null && claimsRec.CSS_PSNs__r.size()>0 && claimsRec.Multi_PSN_Claim__c == true 
           && psnRec.Before_In_Service__c == true ){
               system.debug('Inside if oldAccountCode');
               if(accCodeSelected!=oldAccountCode) {
                   system.debug('Inside if accCodeSelected');
                   showFailurePopup=true;
                   return true;
               }     
               else{
                   system.debug('Inside else');
                   showFailurePopup=false;
                   return false;
               }
           }
        //End
        return false;
    }
    //End
    
    //Method for saving Claim's Failures Overview Data
    public PageReference saveClaimFailOvervwData(){
        noclvalueborder = false;
        try {
            List<CSS_Solution_Component__c> lstSolCompToBeUpdated = new List<CSS_Solution_Component__c>();
            if(listfailClaimspWrapper != null && listfailClaimspWrapper.size()>0){
                for(failureClaimsWrapper fcw : listfailClaimspWrapper){
                    CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
                    solComp.Id = fcw.CompIds;
                    solComp.Claims_Failure_Select__c = fcw.selectedComponent;
                    solComp.CSS_Claims__c = fcw.ClaimsId;
                    //solComp.AccountCode__c = fcw.accountCode;
                    //Added mapping for 3 fields as per defect #158390 and #158388,-By RAJESH on 13th Aug 2018        
                    solComp.System_Code__c = fcw.systemCode;
                    solComp.SystemCode_Desc__c = fcw.systemCodeDes;
                    solComp.Component_Code__c = fcw.compCode;
                    solComp.ComponentCode_Desc__c = fcw.compCodeDes;
                    solComp.Failure_Mode__c = fcw.FailMode;
                    solComp.FailMode_Desc__c = fcw.FailModeDes;
                    if(claimsRec.Information_Only_Claim__c == true)
                    {
                        solComp.Pay_Code__c = 'A';
                    }else{
                        solComp.Pay_Code__c = fcw.payCode;
                        system.debug('Paycode***' + fcw.payCode);
                    }
                    solComp.Solutions__c= fcw.solIds; 
                    
                    User usr;
                    usr = css_utility.getUserAttributes(userinfo.getUserId());
                    string userRole = usr.UserRoleName__c;
                    
                    if((fcw.claimType=='' || fcw.claimType==null || fcw.claimType=='Select One') && !userRole.contains('Factory')){
                        noclvalueborder= true;    
                    }
                    else{
                        solComp.Claim_Type__c= fcw.claimType; 
                        solComp.Selected_Claim_Type__c= fcw.claimType;
                    }
                    //solComp.Pay_Code__c = fcw.payCode;
                    lstSolCompToBeUpdated.add(solComp);
                }
                
                system.debug('updatelist1***' + lstSolCompToBeUpdated);
                system.debug('noclvalueborder***' + noclvalueborder);
                
                
                if(lstSolCompToBeUpdated != null && lstSolCompToBeUpdated.size()>0 && !noclvalueborder){
                    update lstSolCompToBeUpdated;
                    system.debug('updatelist***' + lstSolCompToBeUpdated);
                }
            }
        }catch(Exception e)  {
            system.debug('EXCEPTION of saveClaimFailOvervwData method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }   
        PageReference  pageRef = new pageReference('/apex/CG_ClaimsFC?id='+wid);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    public class failureClaimsWrapper{
        public Id ClaimsId {get;set;}
        public Id CompIds {get;set;}
        public Id solIds {get;set;}
        public Boolean selectedComponent {get;set;}
        public String faultSympCode {get;set;}
        public String failureName {get;set;} 
        public String systemCode {get;set;}
        public String systemCodeDes {get;set;}
        public String compCode {get;set;}
        public String compCodeDes {get;set;}
        public string FailMode {get;set;} // Kalpana: 136638
        public String FailModeDes {get;set;}
        public String accountCode {get;set;} 
        public String payCode {get;set;}
        public List<SelectOption> PayCodes {get;set;}
        public List<String> relsympStringList{get;set;}        
        public Id JobId {get;set;}
        public String claimType {get;set;}
        public failureClaimsWrapper(Id ClaimsId,Id CompIds,Id solIds,Boolean selectedComponent,String faultSympCode,string failureName, string systemCode,string systemCodeDes,string compCode,string compCodeDes,string FailMode,string FailModeDes,String accountCode,String payCode,List<SelectOption> PayCodes,List<String> relsympStringList, string JobId, string claimType){
            this.ClaimsId = ClaimsId;
            this.CompIds = CompIds;
            this.solIds = solIds;
            this.selectedComponent = selectedComponent;
            this.faultSympCode=faultSympCode;
            this.failureName = failureName;
            this.systemCode = systemCode;
            this.systemCodeDes = systemCodeDes;
            this.compCode = compCode;
            this.compCodeDes = compCodeDes;
            this.FailMode = FailMode;
            this.FailModeDes = FailModeDes;
            this.accountCode = accountCode;
            this.payCode = payCode;
            this.PayCodes = PayCodes;
            this.relsympStringList = relsympStringList;
            this.JobId = JobId;
            this.claimType = claimType;
        }
    }
    public Boolean dateErrFlag{get;set;}  
    public Boolean higherdateErrFlag{get;set;}
    public string FailureDateHidden{get;set;}
    public Date failureDate{get;set;}
    public Date failureDate1{get;set;}
    public Date tempfailureDate;
    public Date solcompfailureDate;
    
    public void CompareDates(){
        dateErrFlag = false;
        higherdateErrFlag = false;
        if(failureDate!=null){
            if(failureDate<warrantyDate){
                dateErrFlag = true;
            }
            if(failureDate>date.today()){
                higherdateErrFlag = true; 
                if(compont.Failure_Date__c==null){
                    tempfailureDate=psnRec.Failure_Date__c;
                    psnRec.Failure_Date__c = system.TODAY();
                }
                else {
                    if(compont != null){
                        tempfailureDate=compont.Failure_Date__c;
                        compont.Failure_Date__c = system.TODAY(); 
                    }
                    
                }
            }
        }
        if(warrantyDate!=null && warrantyDate>System.TODAY())checkPartsWarrStartDt = true;
        else  checkPartsWarrStartDt = false;
    }
    
    public String getPossession() {
        return Possession;
    }
    
    public void setManager(String Possession) { this.Possession = Possession; }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }
    
    public PageReference popUpSave(){
        system.debug('Inside popUpSave method...selectedCompId>>:'+selectedCompId);
        system.debug('Inside popUpSave method...selectedFailureID>>:'+selectedFailureID);
        system.debug('failureNameWithFailureIdMap>>'+ failureNameWithFailureIdMap);
        system.debug('selectedSysCode---'+selectedSysCode);
        system.debug('selectedCompCode---'+selectedCompCode);
        system.debug('selectedFailMode---'+selectedFailMode);
        system.debug('invalidFaultCode---'+invalidFaultCode);
        system.debug('selectedFName---'+selectedFName);
        system.debug('oldOTCValue-->'+oldOTCValue);
        system.debug('oldFailCode-->'+oldFailCode);
        system.debug('oldAccCode-->'+oldAccCode);
        checkFaultCode();
        
        system.debug('After checkFaultCode method call invalidFaultCode---'+invalidFaultCode);
        CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
        //if(failureNameWithFailureIdMap!=null)
        //selectedFailureID = failureNameWithFailureIdMap.get(selectedFName);
        //system.debug('Inside popUpSave method...selectedFailureID1>>:'+selectedFailureID);
        PageReference pageRef;
        Boolean isMultiPSNEnabled = false;
        errornotcovfound = false;
        isMultiPSNErrorExist = false;
        stopFailureSave = false;
        chkClickonPartsCoverage = false;
        partCoverageFound = '';
        radioSelect=false;
        system.debug('selectedFailMode---'+selectedFailMode);
        system.debug('selectedFailModevalue---'+selectedFailModevalue);
        
        try {
            if(claimsRec.CSS_PSNs__r != null && claimsRec.CSS_PSNs__r.size()>0 && claimsRec.Multi_PSN_Claim__c == true && psnRec.Before_In_Service__c == true 
               && claimsRec.css_job__c == null){
                   isMultiPSNEnabled = true;
               }
            //Added PACCAR_Converted_to_PW__c field in below query as part of the story GSSC-71
            claimsRec =[Select Id, SP_INSHOP_LABOR_RATE__c, Failures_ODM_Status__c, Catastrophic__c, Automotive_App_Flag__c, PACCAR_PW_AutoSelected__c, No_Failure_PACCAR_Flag__c, PACCAR_Converted_to_PW__c, IsDealerCreatedClaim__c,Account__r.Type,Customer_Name__c,Location__c,PACCAR_Flag__c ,CSS_PACCAR_Auth_Track__c ,Parts_Warranty_Claim_Only__c,PACCAR_Auth_Required__c ,Dealer_Service_Job__c,Location_Code__c,ReconEngineFlag__c,CSS_Job__c,CSS_Job__r.name,CSS_Job__r.createddate,Shop_Work_Order__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,CoverageResponse__c,Information_Only_Claim__c,Multi_PSN_Claim__c, 
                        (Select Id,Name,PSN__c,Service_Model__c,Application__c,License_Plate_State__c,ApplicationCode__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,Qsol_Engine_Family_Code__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c,Calibration_After__c,Calibration_Before__c,Revision_After__c,Revision_Before__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id= :WId];
            
            system.debug('claimsRec---'+claimsRec);
            selectedFaultCodeValue=selectedFaultCode;
            String selectedSysCodeDesc=selectedSysCode;
            String selectedCompCodeDesc=selectedCompCode;
            //system.debug('***selectedFailMode***'+selectedFailMode);
            String selectedFailModeDesc=selectedFailMode;
            String selectedFaultCodeDesc=selectedFaultCode;
            //if(selectedFailModeValue!=null){
            if(selectedFailModeValue !=null  || selectedFailMode !=null){ //changed above condition
                if(selectedFailModeValue !=null){
                    selectedFailModeDesc=selectedFailModeValue;
                    selectedFailMode=selectedFailModeValue;
                }else if(selectedFailMode !=null){
                    selectedFailModeDesc=selectedFailMode;
                    //selectedFailMode=selectedFailMode;
                }
                
            }
            
            else{
                //selectedFailModeDesc= compont.FailMode_Desc__c;
                //selectedFailMode=compont.FailMode_Desc__c;
                system.debug('***else selectedFailModeDesc/selectedFailModeValue***'+selectedFailModeDesc+' compont.FailMode_Desc__c>:'+compont.FailMode_Desc__c);
                system.debug('***else selectedFailMode***'+selectedFailMode);
            }
            system.debug('************** selectedFaultCodeValue'+selectedFaultCodeValue);
            system.debug('************** selectedFaultCode'+selectedFaultCode);
            if(selectedFaultCodeValue!=null){
                selectedFaultCodeDesc= selectedFaultCodeValue;
                selectedFaultCode=selectedFaultCodeValue;
                system.debug('************** if selectedFaultCode'+selectedFaultCode);
            }
            else{
                //selectedFaultCodeDesc= compont.FaultCode_Desc__c;
                //selectedFaultCode=compont.FaultCode_Desc__c;
                system.debug('************** else selectedFaultCode'+selectedFaultCode);
            }
            if(selectedSysCode!=null){
                selectedSysCodeDesc= selectedSysCode;
            }
            
            if(selectedCompCode!=null){
                selectedCompCodeDesc= selectedCompCode;
            }
            
            
            if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
                if(selectedCustFName != null && selectedCustFName != ''){
                    solComp.CSS_Custom_Failure__c = selectedCustFName;
                    solComp.Name = selectedCustFName;
                }
                else{
                    system.debug('Test233'+selectedSysCode+'$$'+selectedCompCode);
                    if(selectedSysCode != null && selectedSysCode != ''&& selectedCompCode!=null && selectedCompCode!='') {
                        SelectSysCode = selectedSysCode.substring(0,2);
                        SelectComCode = selectedCompCode.substring(0,2);
                        system.debug('Testcodes'+SelectSysCode+'Ccode'+SelectComCode);
//Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020                        
                        List<CSS_JobEventTemporary__c> tempList = [select Attribute1__C,Attribute4__c,Attribute7__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C=:SelectSysCode and Attribute4__c=:SelectComCode and Active__c=true];
                        if(tempList!=null && tempList.size()>0 && tempList[0].Attribute7__c !=null && tempList[0].Attribute7__c !=''){
                            solComp.Name=tempList[0].Attribute7__c;
                            system.debug('Testcodes1'+solComp.Name);
                        }
                        else
                        {
                            //system.debug('Insideelse'+selectedSysCode+selectedCompCode);
                            solComp.Name=selectedSysCode.substring(0,2)+selectedCompCode.substring(0,2);
                            system.debug('Testcodes2'+solComp.Name);
                            //system.debug('solnComp.Name-----'+solComp.Name);
                        }
                        
                    } 
                }
                
                String solCompName = solComp.Name;
                String updatedSolCompName = '';
                if(solCompName != null && solCompName.length() > 0){
                    String[] splitPhrase = solCompName.trim().split(' ');
                    
                    for(integer i = 0; i < splitPhrase.size(); i++){
                        if(i == 0 || i == (splitPhrase.size()-1) ){
                            updatedSolCompName += (splitPhrase[i].substring(0,1).toUpperCase())+(splitPhrase[i].substring(1).toLowerCase())+' ';
                        }else{
                            updatedSolCompName += splitPhrase[i].toLowerCase()+' ';
                        }
                    }
                }
                system.debug('updatedSolCompName****'+updatedSolCompName);
                system.debug('failureNameWithFailureIdMap****'+failureNameWithFailureIdMap);
                if(failureNameWithFailureIdMap!=null)
                    system.debug('****solComp.Name1***'+updatedSolCompName);
                if(updatedSolCompName != null)
                    updatedSolCompName = updatedSolCompName.trim();
                selectedFailureID = failureNameWithFailureIdMap.get(updatedSolCompName);
                system.debug('Inside popUpSave method...selectedFailureID2>>:'+selectedFailureID);
            }
            else{
                if(failureNameWithFailureIdMap!=null)
                    selectedFailureID = failureNameWithFailureIdMap.get(selectedFName);
                system.debug('Inside popUpSave method...selectedFailureID3>>:'+selectedFailureID);
            }
            
            system.debug('***selectedFailureID**'+selectedFailureID);
            system.debug('selectedSysCode'+selectedSysCode);
            if(selectedSysCode!=null && selectedSysCode.length()>2)
                selectedSysCode = selectedSysCode.substring(0,2);
            // system.debug('***selectedCompCode***'+selectedCompCode);
            if(selectedCompCode!=null && selectedCompCode.length()>2)
                selectedCompCode = selectedCompCode.substring(0,2);
            if(selectedFailMode != null && selectedFailMode.length()>2)
                selectedFailMode=selectedFailMode.substring(0,2);
            if(selectedFaultCode!=null && selectedFaultCode.contains('-')){
                String[] sFaultCode=selectedFaultCode.split('-')  ;
                selectedFaultCode=sFaultCode[0];
            }
            //system.debug('***selectedCompCode***'+selectedCompCode);
            
            //check if the Failcode Account Code combination already Exists
            //string strFailCode = selectedSysCode+selectedCompCode+selectedFailMode; // kalpana: Commented as per the defect 145965
            system.debug('accCodeReturned'+accCodeReturned);
            string strFailCode = selectedSysCode+selectedCompCode;
            string accCodeEdit;
            if(accCodeReturned != '' && accCodeReturned != null){
                accCodeEdit = accCodeReturned;
            }
            else{
                accCodeSelected= accCodeSelected.replace('Select One', ''); //Karthik G added as part of 190587
                accCodeEdit = accCodeSelected;
            }
              system.debug('accCodeSelected'+accCodeSelected);
                system.debug('accCodeEdit'+accCodeEdit);
            errormsgfailpoint = false;
            FCErrorval = false;
            blankField = false;
            solCompExistsFlag = 'false';
            // system.debug('accCodeEdit**'+accCodeEdit);
            //system.debug('strFailCode**'+strFailCode);
            //system.debug('Wid**'+Wid);
            onChangeofAppCode();
            List<CSS_Solution_Component__c> solCompExists= new List<CSS_Solution_Component__c>();
            if((strFailCode != null && strFailCode != '') && (accCodeEdit != null && accCodeEdit != '' && accCodeEdit != 'Select One')){
                try{
                    solCompExists = [select id,fail_code__c,accountcodeedit__c from CSS_Solution_Component__c where Claim_FailCode__c=:strFailCode and accountcodeedit__c=:accCodeEdit and css_claims__C =:wid];
                }
                catch(Exception ex){
                    //continue; To Avoid blue screen issue
                }
            }
            system.debug('[*'+solCompExists);
            system.debug('Inside PopupSave**'+dispFailuresList.size());
            system.debug('selectedCompId PopupSave**'+selectedCompId);
            //if(solCompExists.size()>0){
             if(selectedCompId!=null){
            if(solCompExists != null && solCompExists.size()>0 && solCompExists[0].id == selectedCompId)
                solCompExistsFlag = 'false';
             }
            else if(solCompExists != null && solCompExists.size()>0 && dispFailuresList.size()==1 && selectedCompId != null)
                solCompExistsFlag = 'false';
            else if(solCompExists != null && solCompExists.size()>0 && dispFailuresList.size()>=1){  // && selectedCompId==null //commented as part of the story 182222
                solCompExistsFlag = 'true';}
            system.debug('Inside popUpSavesolCompExistsFlag**'+solCompExistsFlag);
            
            
            /*CSS_Solution_Component__c solCompTobeUpdated = new CSS_Solution_Component__c();
solCompTobeUpdated = [select id,fail_code__c from css_solution_component__c where fail_code__c=:strFailCode and css_claims__C = :wid limit 1];*/
            // system.debug('selectedCompId'+selectedCompId);
            if(selectedCompId!=null && selectedCompId!='')
            {solComp.id=selectedCompId;}
            
            //else{solComp.id = null;} 
            System.debug('selectedFNameValue$$$$'+selectedFNameValue);
            if(selectedFNameValue!=null){
                if(selectedFNameValue != 'Unlisted')
                    solComp.Name=selectedFNameValue;
            }
            else{
                if(compont!=null && compont.name!=null)
                    solComp.Name=compont.name;
                else
                    solComp.Name=selectedFName;
            }
            System.debug('selectedFaultValue$$$$'+compont.FailMode_Desc__c);
            System.debug('selectedFModeValue$$$$'+selectedFailModeValue);
            //solComp.FailMode_Desc__c=compont.FailMode_Desc__c;
            System.debug('selectedFMode$$$$'+solComp.FailMode_Desc__c);  
            
            
            //solComp.Name = selectedFName;
            solComp.CSS_Claims__c = Wid;
            if(accCodeEdit != 'Select One' && partCoverageFound != 'false') {
                system.debug('entered into ifffff');
                solComp.AccountCodeEdit__c = accCodeEdit;
            }
            else
            {
                
                solComp.AccountCodeEdit__c = '';
                system.debug('entered into elsee'+solComp.AccountCodeEdit__c);
            }
            solComp.Claim_Type__c = claimTypeSelected;  //kalpana:story 142788
            //Prabhakar addded these 3 fields
            if(compont.Failure_Point__c != null)
                solComp.Failure_Point__c = compont.Failure_Point__c;
            else
                solComp.Failure_Point__c = null;
            if(compont.Failure_Date__c != null)
                solComp.Failure_Date__c = compont.Failure_Date__c;
            //Commenting below code as part of defect GSSC-424
            //else
            //    solComp.Failure_Date__c = psnRec.Failure_Date__c;
            
            solComp.Over_The_Counter__c = compont.Over_The_Counter__c; //GSSC-298
            
            solComp.AccountCode__c = compont.AccountCode__c;
            //solComp.AccountCodeEdit__c = compont.AccountCodeEdit__c;
            solComp.AccountCodeEdit__c = accCodeEdit;
            solComp.SystemCode_Desc__c = selectedSysCodeDesc;
            solComp.ComponentCode_Desc__c = selectedCompCodeDesc;
            system.debug('****selectedSysCodeDesc'+selectedSysCodeDesc);
            solComp.FailMode_Desc__c  = selectedFailModeDesc;
            solComp.FaultCode_Desc__c  = selectedFaultCodeDesc;
            solComp.System_Code__c = selectedSysCode;
            solComp.Component_Code__c = selectedCompCode;
            solComp.Failure_Mode__c = selectedFailMode;
            /////////////////////////////////////////////
            selectedCompCode = selectedCompCodeDesc;
            selectedFailMode = selectedFailModeDesc;
            selectedFaultCode = selectedFaultCodeDesc;
            selectedSysCode =  selectedSysCodeDesc;
            /////////////////////////////////////////////
            
            //system.debug('****selectedFailMode'+selectedFailMode);
            //solComp.Failure_Mode__c = selectedFailMode;
            solComp.Component_Id__c = selectedFailureID;
            solComp.ODM_Penalty__c = ''; // Added to fix defect 186492
            if(compont.Part_Warranty_Start_Date__c != null)solComp.Part_Warranty_Start_Date__c = compont.Part_Warranty_Start_Date__c;
            else solComp.Part_Warranty_Start_Date__c = null;
            
            solComp.Fault_Code__c = selectedFaultCode;
            
            /*if(claimsRec.Information_Only_Claim__c == True && (claimsRec.css_job__c == null && claimsRec.Dealer_Service_Job__c==null) 
&& (solComp.CSS_Account_Formula__c ==null || solComp.CSS_Account_Formula__c =='') && isDealer==true){
solComp.Pay_Code__c ='A';
solComp.AccountCode__c = '02';
}
else
solComp.Pay_Code__c = payCodeSelected;*/
            solComp.AccountCodeEdit__c = accCodeEdit;
            system.debug('solComp.Pay_Code__c 007 '+solComp.Pay_Code__c);
            system.debug('isDealer 008 '+isDealer);
            system.debug('compToUpdate 009 '+compToUpdate);
            if(isDealer){
                if(claimsRec.Information_Only_Claim__c == True && (solComp.CSS_Account_Formula__c ==null || solComp.CSS_Account_Formula__c =='')){
                       solComp.Pay_Code__c ='A';
                       solComp.AccountCode__c = 'NEW PRODUCT WARRANTY 67';
                   }
                if(compToUpdate == null && claimsRec.Information_Only_Claim__c != True){
                    system.debug('inside if');
                    solComp.Pay_Code__c = 'D';
                }else if(compToUpdate !=null && claimsRec.Information_Only_Claim__c != True && (compToUpdate.Pay_Code__c==null || compToUpdate.Pay_Code__c.trim()=='') ){
                    system.debug('inside else');
                    solComp.Pay_Code__c = 'D';
                    
                    //solComp.Pay_Code__c = compToUpdate.Pay_Code__c;
                }
                else if(compToUpdate !=null && claimsRec.Information_Only_Claim__c != True && compToUpdate.Pay_Code__c !=null && compToUpdate.Pay_Code__c.trim() !=''){
                    solComp.Pay_Code__c = compToUpdate.Pay_Code__c;
                }
            } else {
                system.debug('inside else007'+ payCodeSelected);
                
                if(payCodeSelected != null && payCodeSelected != '')
                    solComp.Pay_Code__c = payCodeSelected;
                else{
                    if(claimsRec.Information_Only_Claim__c == True && (solComp.CSS_Account_Formula__c ==null || solComp.CSS_Account_Formula__c =='')){
                        solComp.Pay_Code__c = 'A';
                        solComp.AccountCode__c = 'NEW PRODUCT WARRANTY 67';
                    }
                }
                //if((solComp.Pay_Code__c == null || solComp.Pay_Code__c == '') && compToUpdate != null)
                //solComp.Pay_Code__c = compToUpdate.Pay_Code__c; 
                //if(claimsRec != null && claimsRec.Account__c != null && claimsRec.Account__r.Type != null && claimsRec.Account__r.Type == 'Dealer Account')
                //solComp.Pay_Code__c = 'D';
                //else 
                //solComp.Pay_Code__c = payCodeSelected;
                
                system.debug('inside else007+'+ solComp.Pay_Code__c);
            }
            solComp.Selected_Component__c = true;
            if(failureMeasure != null && failureMeasure != '')
                solComp.Failure_Measure__c=failureMeasure; 
            solcomp.Authorization_Number__c= AuthorizationNumber;
            solcomp.Covered_Parts__c= Coveredpartspercentage;
            solcomp.Covered_Labor__c= CoverageLaborpercentage;
            solComp.Approval_Code__c = ApprovalCode;
            system.debug('prabhucustSelect'+custSelect);
            if(Possession != null){
                solComp.Customer_Take_Possession__c = Possession;//compont
                system.debug('prabhusolComp.Customer_Take_Possession__c'+solComp.Customer_Take_Possession__c);
            }
            
            solComp.Customer_Take_Possession__c = custSelect;
            if(compToUpdate != null){
                solComp.CoveredLaborHrs__c = compToUpdate.CoveredLaborHrs__c;
                solComp.CoveredMealsLodgingAmt__c = compToUpdate.CoveredMealsLodgingAmt__c;
                solComp.CoveredOCAmount__c = compToUpdate.CoveredOCAmount__c;
                solComp.CoveredPartsQty__c = compToUpdate.CoveredPartsQty__c;
                solComp.CoveredTowingMiles__c = compToUpdate.CoveredTowingMiles__c;
                solComp.CoveredTravelLabor__c = compToUpdate.CoveredTravelLabor__c;
                solComp.CoveredTravelMiles__c = compToUpdate.CoveredTravelMiles__c;   
                solComp.CertificateNumber__c = compToUpdate.CertificateNumber__c;//This one we are going to pass the CAP Claims
                solComp.GetAccountCodeServiceRun__c = compToUpdate.GetAccountCodeServiceRun__c;
                solComp.AccountCode_Call_Status__c = compToUpdate.AccountCode_Call_Status__c;
                //solComp.CampaignPartsPercentage__c = compToUpdate.CampaignPartsPercentage__c; 
                solComp.CoveredTravelBaseFareAmt__c=compToUpdate.CoveredTravelBaseFareAmt__c;
            }
            //solComp.Unique_Component__c = selectedFName+selectedSysCode+selectedCompCode+selectedFailMode;
            system.debug('accCodeSelected**'+accCodeSelected);
            system.debug('selectedFaultCode**'+selectedFaultCode);
               system.debug('accCodeSelected**'+accCodeSelected);
            /*if(((accCodeSelected != null && accCodeSelected != '' && !accCodeSelected.contains('70')) || (accCodeReturned != null && accCodeReturned != '' && !accCodeReturned.contains('70'))) && (selectedFaultCode == null || selectedFaultCode == '')){
                FCErrorval = true;
                blankField = true;
                // system.debug('InsideEmission**');   
            }*/
            
            //Added Code for displaying error message based on Coverage Type (CAP) -- GAP Sprint 148103 Rajasekhar H       
            //if(claimsRec.CoverageResponse__c != null && claimsRec.CoverageResponse__c != ''){
            if(claimsRec.CoverageResponse__c != null && claimsRec.CoverageResponse__c != '' && !claimsRec.CoverageResponse__c.contains('Error')){
                basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                basicCoverageDetails = (CSS_getBasicCoverageResponseJ2A) JSON.deserialize(claimsRec.CoverageResponse__c, CSS_getBasicCoverageResponseJ2A.class);
                //system.debug('basicCoverageDetails coverage resp' + basicCoverageDetails.Header);
                for (CSS_getBasicCoverageResponseJ2A.extendedCoverageDetails covdet: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.extendedCoverageDetails) {
                    for(CSS_getBasicCoverageResponseJ2A.coverageDetails c: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails) {
                        if(accCodeSelected != null &&  (accCodeSelected.contains('62') || accCodeSelected.contains('35') || accCodeSelected.contains('97') || accCodeSelected.contains('41'))) {
                            //if (c.CoverageType == 'CAP' && accCodeSelected.contains('62') || accCodeSelected.contains('35') || accCodeSelected.contains('97') || accCodeSelected.contains('41')) {
                            system.debug('covdet.BeginHours***'+covdet.BeginHours);
                            system.debug('compont.Failure_Point__c***'+compont.Failure_Point__c);
                            system.debug('covdet.BeginMiles***'+covdet.BeginMiles);
                            if (failureMeasure.equalsIgnoreCase('Hours'))
                                if(decimal.valueof(covdet.BeginHours) < compont.Failure_Point__c){
                                    errormsgfailpoint=true;
                                }
                            if (failureMeasure.equalsIgnoreCase('Miles'))
                                if(decimal.valueof(covdet.BeginMiles) < compont.Failure_Point__c)
                            {
                                errormsgfailpoint=true;
                            }
                            if (failureMeasure.equalsIgnoreCase('Kilometers'))
                                covdet.BeginMiles = String.ValueOf((Decimal.valueOf(covdet.BeginMiles) / 0.621371).setScale(0));
                            if(decimal.valueof(covdet.BeginMiles) < compont.Failure_Point__c)
                            {
                                errormsgfailpoint=true;
                            }
                        }   
                    }
                }
                
                
            }
            
            
            system.debug('chkClickonPartsCoverage**'+chkClickonPartsCoverage);
            system.debug('partcoverageFound**'+partcoverageFound+'partcoverageFound**'+coverageFound);
            system.debug('coverageType'+coverageType+'accCodeEdit'+accCodeEdit);
            
            //if(selectedFName==' ' ||  selectedSysCode=='' || selectedCompCode=='' || selectedFailMode=='' || accCodeEdit=='' || payCodeSelected=='' || failureMeasure=='' || AuthorizationNumber=='' || ApprovalCode=='' || compont.Part_Warranty_Start_Date__c == null || compont.Failure_Date__c == null || compont.Failure_Point__c==null)
            if((selectedFName=='' || selectedFName==null) || (selectedSysCode=='' || selectedSysCode==null) || (selectedCompCode=='' || selectedCompCode==null) || 
               (selectedFailMode=='' || selectedFailMode==null) || (accCodeEdit=='' || accCodeEdit==null || accCodeEdit=='Select One') || (payCodeSelected=='' || payCodeSelected==null) ||  (claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One') || 
               (failureMeasure=='' || failureMeasure==null) || (AuthorizationNumber=='' || AuthorizationNumber==null) || (ApprovalCode=='' || ApprovalCode==null) || 
               compont.Part_Warranty_Start_Date__c == null || compont.Failure_Date__c == null || compont.Failure_Point__c==null || compont.Customer_Take_Possession__c==null)
            {
                
                if((selectedFName=='' || selectedFName==null) || (selectedSysCode=='' || selectedSysCode==null) || (selectedCompCode=='' || selectedCompCode==null) || 
                   (selectedFailMode=='' || selectedFailMode==null)){
                       blankField=true;
                       system.debug('Normal IF');
                   }
                User usr;
                usr = css_utility.getUserAttributes(userinfo.getUserId());
                string userRole = usr.UserRoleName__c;
                
                //system.debug('orgtype--->'+orgtype);
                //system.debug('Regionterritory--->'+Regionterritory.Region__c);
                system.debug('userRole--->'+userRole);
                
                if(accCodeEdit!='' && accCodeEdit!=null && accCodeEdit!='Select One'){
                    if((claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One')&& claimsRec.IsDealerCreatedClaim__c == false && !userRole.contains('Factory')){
                        blankField=true;
                        system.debug('claimTypeIF1');
                    }
                    
                    If(accCodeEdit.contains('62') || accCodeEdit.contains('35') || accCodeEdit.contains('97') || accCodeEdit.contains('41')) 
                    {   
                        system.debug('insideprabhu');
                        if((claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One') && DealerTypeFlag ==false){
                            blankField=true;
                            system.debug('claimTypeIF1');
                        }
                        
                        if((compont.Part_Warranty_Start_Date__c == null || compont.Failure_Point__c==null))
                        { blankField=true;
                         system.debug('InsidePartsIF1');
                        }
                        system.debug('compont.Failure_Date__c--'+compont.Failure_Date__c);
                        if(compont.Failure_Date__c == null){// &&  psnRec.Failure_Date__c == null){ //Commented as part of defect GSSC-424
                            blankField=true;
                            system.debug('InsidePartsIF2'+blankField);
                        }
                        
                    }
                    
                    custSelect = solComp.Customer_Take_Possession__c;
                    
                    if(custSelect != null && custSelect != '' ){
                        solComp.Customer_Take_Possession__c = custSelect;
                    }
                    else{
                        if(accCodeEdit!=null && (accCodeEdit.contains('62') || accCodeEdit.contains('97'))){
                            solComp.Customer_Take_Possession__c = 'Yes';
                            system.debug('Testpossession'+solComp.Customer_Take_Possession__c);
                        }
                        else {
                            if(accCodeEdit!=null && (accCodeEdit.contains('35') || accCodeEdit.contains('41'))){
                                solComp.Customer_Take_Possession__c = 'No';
                                system.debug('Testpossession1'+solComp.Customer_Take_Possession__c);
                            }
                        }
                        
                    }
                    
                    
                    //182849
                    If(accCodeEdit.contains('62') && solComp.Customer_Take_Possession__c =='No'){
                        solComp.AccountCodeEdit__c='PARTS WARRANTY - DEFECT FROM STOCK 35';
                    }
                    
                    If(accCodeEdit.contains('97') && solComp.Customer_Take_Possession__c =='No'){
                        solComp.AccountCodeEdit__c='RECON PART - DEFECT FROM STOCK 41';
                    }
                    
                    If(accCodeEdit.contains('35') && solComp.Customer_Take_Possession__c =='yes'){
                        solComp.AccountCodeEdit__c='NEW PARTS WARRANTY 62';
                    }
                    If(accCodeEdit.contains('41') && solComp.Customer_Take_Possession__c =='yes'){
                        solComp.AccountCodeEdit__c='RECON PARTS WARRANTY 97';
                    }
                    //end
                    //Added  "coverageType=='OTH'" in else if condition for validatting ApprovalCode as per Simpsons document #128755, By -RAJESH 30th May 2018
                    accCodeEdit = accCodeEdit.right(2).trim(); // Karthik G Added as part of #190587
                    if((coverageType=='POL' || coverageType=='OTH') && coverageFound=='false' && accCodeEdit!=null && accCodeEdit!='')
                    { 
                        system.debug('POL ElseIF and OTH elseif ');
                        if((AuthorizationNumber=='' || AuthorizationNumber==null) || (ApprovalCode=='' || ApprovalCode==null)|| ((payCodeSelected=='' || payCodeSelected==null)&& isDealer==false)){
                            //if((ApprovalCode=='' || ApprovalCode==null) || (payCodeSelected=='' || payCodeSelected==null)){
                            if(((ApprovalCode=='' || ApprovalCode==null) ||payCodeSelected=='' || payCodeSelected==null) && isDealer==true){
                                blankField=false;
                            }else if(ApprovalCode=='' || ApprovalCode==null) {//|| payCodeSelected=='' || payCodeSelected==null)
                                blankField=true;
                            }
                        }
                    }
                    if((coverageType!='POL' && coverageType!='OTH') && 
                        coverageFound=='false' && accCodeEdit!=null && accCodeEdit!='' && (!accCodeEdit.contains('62') && 
                        !accCodeEdit.contains('35') && !accCodeEdit.contains('97') && !accCodeEdit.contains('41') &&
                        !accCodeEdit.contains('52'))) {  
                        system.debug('NON POL and NON OTH');
                        String Appcodepass;
                        if(psnRec.ApplicationCode__c==null) {
                            if(claimsRec.CSS_Job__c!=null)
                                Appcodepass = claimsRec.CSS_Job__r.ApplicationCode__c;          
                            else if(claimsRec.Dealer_Service_Job__c!=null)
                                Appcodepass = claimsRec.Dealer_Service_Job__r.ApplicationCode__c;  
                        }
                        else{
                            Appcodepass = psnRec.ApplicationCode__c;
                        }
                        compToUpdate = new CSS_Solution_Component__c();
                        //if(failureMeasure == null || failureMeasure == '' || failureMeasure == 'Hours')
                        //failureMeasure = 'Miles';
                        //compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(solComp.Failure_Point__c),solComp.Failure_Measure__c,psnRec.ApplicationCode__c,claimsRec.CSS_PSNs__r[0].Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true);
                       system.debug('compont.Failure_Point__c'+compont.Failure_Point__c);
                         system.debug('selectedFName'+selectedFName);
                         system.debug('compont.Failure_Date__c'+compont.Failure_Date__c);
                         system.debug('psnRec.Failure_Date__c'+psnRec.Failure_Date__c);
                         system.debug('compont.Part_Warranty_Start_Date__c'+compont.Part_Warranty_Start_Date__c);
                        
                         accCodeEdit = accCodeEdit.right(2).trim(); // Karthik G Added as part of #190587
                           system.debug('checkCoverageonfm'+checkCoverageonfm);
                            system.debug('failureinfochange'+failureinfochange);
                        if(checkCoverageonfm == null || checkCoverageonfm != true ||   failureinfochange == true || accCodeEdit!= '' ) { // GSSC-290 karthik G 
                       if(compont.Failure_Point__c!=null && selectedFName!=null && (compont.Failure_Date__c != null || psnRec.Failure_Date__c != null) && compont.Part_Warranty_Start_Date__c != null){
                            system.debug('inside if');
                            if(failureMeasure != null && failureMeasure != ''){
                                compont.Failure_Measure__c = failureMeasure;
                            }
                            
                            if(compont.Failure_Measure__c == null || compont.Failure_Measure__c == ''){
                                if(failureMeasure != null && failureMeasure != '')
                                    compont.Failure_Measure__c = failureMeasure;
                                else
                                    failureMeasure = 'Miles';
                            }
                            else
                                failureMeasure = compont.Failure_Measure__c;
                            
                            system.debug('failureMeasure-->'+failureMeasure);
                                  system.debug('accCodeEdit'+accCodeEdit);
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),compont.Failure_Date__c,string.valueof(solComp.Failure_Point__c),failureMeasure,psnRec.ApplicationCode__c,compont.Part_Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true,claimsRec.Name);
                        }
                        else{
                            system.debug('inside else');
                            system.debug('accCodeEdit'+accCodeEdit);
                           
                            if(claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='130' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='210' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='220' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='310' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='320' || claimsRec.CSS_PSNs__r[0].ApplicationCode__c=='410'){
                                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCode.substring(0,2),SelectedCompCode.substring(0,2),'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true,claimsRec.Name);
                            }
                            else{
                                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Product_Hours__c),'Hours',psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCode.substring(0,2),SelectedCompCode.substring(0,2),'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true,claimsRec.Name);
                            }
                        }
                    }
                        // compToUpdate= CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(solComp.Failure_Point__c),failureMeasure,Appcodepass,claimsRec.CSS_PSNs__r[0].Warranty_Start_Date__c,SelectedsysCode.substring(0,2),SelectedCompCode.substring(0,2),'',accCodeEdit.right(2),solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true);
                        
                        //Added Validation for Inside Out Sprint #183076-- Rajasekhar H//
                        if(compToUpdate.AccountCode_Call_Status__c != null && compToUpdate.AccountCode_Call_Status__c == 'Failure')
                            warrantyDetError=true;
                        else 
                            warrantyDetError=false;
                        //End
                        
                        if(compToUpdate != null){
                            solComp.CoveredLaborHrs__c = compToUpdate.CoveredLaborHrs__c;
                            solComp.CoveredMealsLodgingAmt__c = compToUpdate.CoveredMealsLodgingAmt__c;
                            solComp.CoveredOCAmount__c = compToUpdate.CoveredOCAmount__c;
                            solComp.CoveredPartsQty__c = compToUpdate.CoveredPartsQty__c;
                            solComp.CoveredTowingMiles__c = compToUpdate.CoveredTowingMiles__c;
                            solComp.CoveredTravelLabor__c = compToUpdate.CoveredTravelLabor__c;
                            solComp.CoveredTravelMiles__c = compToUpdate.CoveredTravelMiles__c;   
                            solComp.CertificateNumber__c = compToUpdate.CertificateNumber__c;//This one we are going to pass the CAP Claims
                            solComp.GetAccountCodeServiceRun__c = compToUpdate.GetAccountCodeServiceRun__c;
                            solComp.AccountCode_Call_Status__c = compToUpdate.AccountCode_Call_Status__c;
                            //solComp.CampaignPartsPercentage__c = compToUpdate.CampaignPartsPercentage__c; 
                            solComp.CoveredTravelBaseFareAmt__c=compToUpdate.CoveredTravelBaseFareAmt__c;
                        }
                        if(compToUpdate.AccountCodeEdit__c != null && compToUpdate.AccountCodeEdit__c != ' '){
                            coverageFound = 'true';
                            errornotcovfound = false;
                        }
                        else{
                            coverageFound = 'false';
                            IF(claimsRec.Information_Only_Claim__c != true){
                            if(checkCoverageonfm == null || checkCoverageonfm != true ||   failureinfochange == true ||  accCodeEdit!= '' ) {
                               errornotcovfound = true;
                          }
                        }
                        }
                        if((payCodeSelected=='' || payCodeSelected==null) && isDealer==true && blankField !=true){
                            blankField=false;
                        }else if(payCodeSelected=='' || payCodeSelected==null){
                            blankField=true;
                        }
                    }
                    //172626
                    
                    if((coverageType!='POL' || coverageType!='OTH') && (coverageFound=='false' || coverageFound=='true') && accCodeEdit!=null && accCodeEdit!='' && accCodeEdit!='Select One' && (accCodeEdit.contains('62') || accCodeEdit.contains('35') || accCodeEdit.contains('97') || accCodeEdit.contains('41') || accCodeEdit.contains('52'))){
                        
                        if((coverageFound == 'true' || coverageFound == 'false') && partCoverageFound == 'true' && blankField==false && radioSelect==false){
                            system.debug('Helloo');
                            stopFailureSave = false;
                        }
                        else if((coverageFound == 'true' || coverageFound == 'false') && partCoverageFound == 'false' && blankField==false && radioSelect==false){
                            system.debug('Helloo2');
                            stopFailureSave = true;
                        } 
                        else if((coverageFound == 'true' || coverageFound == 'false') && chkClickonPartsCoverage == false && blankField==false && radioSelect==false){
                            system.debug('inside 3rd condition');
                            
                            try{
                                if(selectedSysCode.length()>2)
                                    selectedSysCode=selectedSysCode.substring(0,2);
                                if(selectedCompCode.length()>2)
                                    selectedCompCode=selectedCompCode.substring(0,2);
                                if(selectedFailMode.length()>2)
                                    selectedFailMode=selectedFailMode.substring(0,2);
                                if(selectedFaultCode!=null && selectedFaultCode.contains('-')){
                                    String[] sFaultCode=selectedFaultCode.split('-')  ;
                                    selectedFaultCode=sFaultCode[0];
                                }
                                //CSS_Solution_Component__c compToUpdate = new CSS_Solution_Component__c();
                                compToUpdate = new CSS_Solution_Component__c(); // Added as per defect 173485
                                system.debug('in check part coverage');
                                if(compont.Failure_Measure__c == null)
                                    compont.Failure_Measure__c = 'Miles';
                                //Assign Parts Warranty Values    
                                if(partsWarranty == null || partsWarranty == ''){
                                    if(accCodeSelected.contains('62') || accCodeSelected.contains('35')){
                                        partsWarranty = 'New Parts Warranty';
                                    }           
                                    else {
                                        if(accCodeSelected.contains('97') || accCodeSelected.contains('41')){
                                            partsWarranty = 'Recon Parts Warranty';
                                        }
                                    }
                                }
                                
                                date failureDate;
                                if(compont.Failure_Date__c != null)
                                    failureDate = compont.Failure_Date__c;
                                else
                                    failureDate = psnRec.Failure_Date__c;
                                css_solution_component__c solComp1 = new css_solution_component__c();
                                try{
                                    solcomp1 = [select id,name,Failure_Point__c,Failure_Measure__c,Part_Warranty_Start_Date__c,Selected_Component__c,Customer_Take_Possession__c from css_solution_component__c where name=:selectedFName and Component_Code__c=:selectedCompCode and System_Code__c=:selectedSysCode and Failure_Mode__c=:selectedFailMode limit 1];
                                }
                                catch(Exception ex){
                                    compToUpdate.AccountCodeEdit__c = ' '; // To avoid Blue Screen Error
                                }
                                String Appcodepass;
                                if(psnRec.ApplicationCode__c==null) {
                                    if(claimsRec.CSS_Job__c!=null)
                                        Appcodepass = claimsRec.CSS_Job__r.ApplicationCode__c;          
                                    else if(claimsRec.Dealer_Service_Job__c!=null)
                                        Appcodepass = claimsRec.Dealer_Service_Job__r.ApplicationCode__c;  
                                }
                                else{
                                    Appcodepass = psnRec.ApplicationCode__c;
                                }               compToUpdate = new CSS_Solution_Component__c();
                                
                                //if(failureMeasure == null || failureMeasure == '' || failureMeasure == 'Hours')
                                //failureMeasure = 'Miles';
                                
                                system.debug('failureMeasure-->'+failureMeasure);
                                
                                if(failureMeasure != null && failureMeasure != ''){
                                    compont.Failure_Measure__c = failureMeasure;
                                }
                                
                                if(compont.Failure_Measure__c == null || compont.Failure_Measure__c == ''){
                                    if(failureMeasure != null && failureMeasure != '')
                                        compont.Failure_Measure__c = failureMeasure;
                                    else
                                        failureMeasure = 'Miles';
                                }
                                else
                                    failureMeasure = compont.Failure_Measure__c;
                                
                                system.debug('failureMeasure-->'+failureMeasure);
                                system.debug('checkCoverageonfm-->'+checkCoverageonfm);
                                system.debug('failureinfochange-->'+failureinfochange);
                                system.debug(' accCodeEdit'+ accCodeEdit!= '');
                                if(checkCoverageonfm == null || checkCoverageonfm != true ||   failureinfochange == true ||  accCodeEdit!= '' ) { // GSSC-290 karthik G 
                                if(claimsRec.ReconEngineFlag__c!=null && claimsRec.ReconEngineFlag__c=='Y'){
                                    System.debug('entered in to reconengine'+claimsRec.ReconEngineFlag__c);
                                    // compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,claimsRec.Location_Code__c,failureDate,string.valueof(compont.Failure_Point__c),failureMeasure,Appcodepass,compont.Part_Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,selectedFaultCode,'98',solComp1.id,solComp1.Selected_Component__c,'',partsWarranty,'Second Call', '',true);
                                    compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,claimsRec.Location_Code__c,failureDate,string.valueof(compont.Failure_Point__c),failureMeasure,Appcodepass,compont.Part_Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,selectedFaultCode,accCodeEdit,solComp1.id,solComp1.Selected_Component__c,'',partsWarranty,'Second Call', '',true,claimsRec.Name); // Karthik G Added accCodeEdit instead of 98 as per story 190587
                                    
                                }
                                else{
                                    System.debug('entered in else to reconengine'+claimsRec.ReconEngineFlag__c);
                                    // compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,claimsRec.Location_Code__c,failureDate,string.valueof(compont.Failure_Point__c),failureMeasure,Appcodepass,compont.Part_Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,selectedFaultCode,accCodeEdit.right(2),solComp1.id,solComp1.Selected_Component__c,'',partsWarranty,'Second Call', '',true);
                                    compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,claimsRec.Location_Code__c,failureDate,string.valueof(compont.Failure_Point__c),failureMeasure,Appcodepass,compont.Part_Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,selectedFaultCode,accCodeEdit.right(2),solComp1.id,solComp1.Selected_Component__c,'',partsWarranty,'Second Call', '',true,claimsRec.Name);   
                                    
                                }
                          }
                                system.debug('compToUpdate-->'+compToUpdate);
                                if(compToUpdate.AccountCode_Call_Status__c != 'Failure' && ((compToUpdate.CoveredLaborHrs__c != '' && compToUpdate.CoveredLaborHrs__c!=null && compToUpdate.CoveredLaborHrs__c != '0') || 
                                                                                            (compToUpdate.CoveredMealsLodgingAmt__c != '' && compToUpdate.CoveredMealsLodgingAmt__c != null && compToUpdate.CoveredMealsLodgingAmt__c != '0') || 
                                                                                            (compToUpdate.CoveredOCAmount__c != '' && compToUpdate.CoveredOCAmount__c!=null && compToUpdate.CoveredOCAmount__c != '0') || 
                                                                                            (compToUpdate.CoveredPartsQty__c != '' && compToUpdate.CoveredPartsQty__c!=null && compToUpdate.CoveredPartsQty__c != '0') || 
                                                                                            (compToUpdate.CoveredTowingMiles__c != '' && compToUpdate.CoveredTowingMiles__c!=null && compToUpdate.CoveredTowingMiles__c != '0') || 
                                                                                            (compToUpdate.CoveredTravelLabor__c != '' && compToUpdate.CoveredTravelLabor__c!=null && compToUpdate.CoveredTravelLabor__c != '0') || 
                                                                                            (compToUpdate.CoveredTravelMiles__c != '' && compToUpdate.CoveredTravelMiles__c!=null && compToUpdate.CoveredTravelMiles__c != '0'))){
                                                                                                system.debug('partCoverageFound'+partCoverageFound);
                                                                                                partCoverageFound = 'true';
                                                                                                stopFailureSave = false;
                                                                                             
                                                                                            }
                                else{
                                    
                                    system.debug('in else condition'+partCoverageFound +accCodeEdit+accCodeSelected);
                                    partCoverageFound = 'false';
                                    stopFailureSave = true;
                                    selectedCompCode = selectedCompCodeDesc;
                                    selectedFailMode = selectedFailModeDesc;
                                    selectedFaultCode = selectedFaultCodeDesc;
                                    selectedSysCode =  selectedSysCodeDesc;
                                    
                                }
                                if(compToUpdate != null){
                                    solComp.CoveredLaborHrs__c = compToUpdate.CoveredLaborHrs__c;
                                    solComp.CoveredMealsLodgingAmt__c = compToUpdate.CoveredMealsLodgingAmt__c;
                                    solComp.CoveredOCAmount__c = compToUpdate.CoveredOCAmount__c;
                                    solComp.CoveredPartsQty__c = compToUpdate.CoveredPartsQty__c;
                                    solComp.CoveredTowingMiles__c = compToUpdate.CoveredTowingMiles__c;
                                    solComp.CoveredTravelLabor__c = compToUpdate.CoveredTravelLabor__c;
                                    solComp.CoveredTravelMiles__c = compToUpdate.CoveredTravelMiles__c;   
                                    solComp.CertificateNumber__c = compToUpdate.CertificateNumber__c;//This one we are going to pass the CAP Claims
                                    solComp.GetAccountCodeServiceRun__c = compToUpdate.GetAccountCodeServiceRun__c;
                                    solComp.AccountCode_Call_Status__c = compToUpdate.AccountCode_Call_Status__c;
                                    //solComp.CampaignPartsPercentage__c = compToUpdate.CampaignPartsPercentage__c; 
                                    solComp.CoveredTravelBaseFareAmt__c=compToUpdate.CoveredTravelBaseFareAmt__c;
                                }
                                
                            }
                            catch(Exception ex){
                                partCoverageFound ='false';
                                system.debug('Catch Check Coverage'+ ex.getmessage()+' '+ex.getLineNumber());
                            }
                            
                        }
                    }
                    
                }
                
                else {
                    if(!isDealer && claimsRec.Information_Only_Claim__c!=true)
                        blankField=true;
                    else{
                        if(claimsRec.Information_Only_Claim__c!=true)
                            blankField=true;
                    }
                    system.debug('ELSE');}
                system.debug('blankField**'+blankField);
                
                
            }
            
            if(solComp.Part_Warranty_Start_Date__c!=null && solComp.Part_Warranty_Start_Date__c>System.TODAY())checkPartsWarrStartDt = true;
            else checkPartsWarrStartDt = false;
            if(tempfailureDate==null) tempfailureDate =solComp.Failure_Date__c;
            if(tempfailureDate>date.today() && failureDate!=null )higherdateErrFlag = true; 
            else higherdateErrFlag = false;
            //if(solComp.Part_Warranty_Start_Date__c!=null && solComp.Failure_Date__c<solComp.Part_Warranty_Start_Date__c && failureDate!=null)dateErrFlag = true;
            if(solComp.Part_Warranty_Start_Date__c!=null && solComp.Failure_Date__c<solComp.Part_Warranty_Start_Date__c){
                dateErrFlag = true;
            }
            else{
                dateErrFlag = false;
            }
            
            
             selectedCompCode = selectedCompCodeDesc;
             selectedFailMode = selectedFailModeDesc;
             selectedFaultCode = selectedFaultCodeDesc;
             selectedSysCode =  selectedSysCodeDesc;
         
            
            system.debug('FCErrorval**'+FCErrorval);
            system.debug('solComp**'+solComp);
            system.debug('solComp**'+solComp.id);
            system.debug('solCompExists**'+solCompExists);
            system.debug('solCompExistsFlag**'+solCompExistsFlag);
            system.debug('custSelect-->'+custSelect);
            system.debug('solComp>>>>>'+solComp);
            system.debug('stopFailureSave>>>>>'+stopFailureSave);
            system.debug('errornotcovfound>>>>>'+errornotcovfound);
            system.debug('warrantyDetError>>>>>'+warrantyDetError);
            system.debug('radioSelect>>>>>'+radioSelect);
            system.debug('FCErrorval>>>>>'+FCErrorval);
            system.debug('solCompExistsFlag>>>>>'+solCompExistsFlag);
            system.debug('blankField>>>>>'+blankField);
            system.debug('invalidAppCode>>>>>'+invalidAppCode);
            system.debug('checkPartsWarrStartDt>>>>>'+checkPartsWarrStartDt);
            system.debug('*****claimsRec.Multi_PSN_Claim__c>>:'+claimsRec.Multi_PSN_Claim__c); 
            system.debug('higherdateErrFlag----->>>>>'+higherdateErrFlag);
            system.debug('dateErrFlag'+dateErrFlag);
            system.debug('tempfailureDate-------'+tempfailureDate);
            system.debug('failureDate------------'+failureDate);
            
            
            system.debug('selectedFailMode---'+selectedFailMode);
            system.debug('selectedFaultCode---'+selectedFaultCode);
            system.debug('invalidFaultCode---'+invalidFaultCode);
            system.debug('invalidCompCode---'+invalidCompCode);
            system.debug('invalidSysCode---'+invalidSysCode);
            system.debug('invalidCustFailure---'+invalidCustFailure);
            system.debug('invalidFailure---'+invalidFailure);
            system.debug('invalidFailMode-->'+invalidFailMode);
            if(coverageType=='POL' || coverageType=='OTH'){//Changes for 190430.As srts were being called twice since the below flag was not being set as true in turn srt_fetched flag was also false whic made srts to fetch multiple times.Anirudh
                solComp.GetAccountCodeServiceRun__c = true;
            }
            
            if((solComp != null && (stopFailureSave != true && errornotcovfound != true && warrantyDetError!=true && radioSelect != true && FCErrorval != true && solCompExistsFlag !='true' && blankField != true && invalidAppCode != true &&  checkPartsWarrStartDt != true  && dateErrFlag != true
                                    && (invalidFailMode != true) && (invalidFaultCode != true) && invalidCompCode != true && invalidSysCode != true && invalidCustFailure != true && invalidFailure != true && (claimsRec.Multi_PSN_Claim__c != true))) 
               || (solComp != null && (stopFailureSave != true && errornotcovfound != true && warrantyDetError != true && radioSelect != true && FCErrorval != true && solCompExistsFlag !='true' && blankField == false && invalidAppCode != true &&  checkPartsWarrStartDt != true  && dateErrFlag != true && higherdateErrFlag != true && (invalidFailMode != true) && (invalidFaultCode != true) && invalidCompCode != true && invalidSysCode != true && invalidCustFailure != true && invalidFailure != true
                                      ))){
                                          
                                          
                                          system.debug('Anirudh Entered if');
                                          if(isMultiPSNEnabled){
                                              if(accCodeSelected.contains('67')){
                                                  system.debug('before upsert.inside if..');
                                                  Boolean flag = DeletePopupAC();
                                                  system.debug('***8flag***'+flag);
                                                  if(flag){
                                                      showFailurePopup = true;
                                                      return null;
                                                  }
                                                  system.debug('before upsert...');
                                                  system.debug('1-->'+solComp.Over_The_Counter__c);
                                                  //GSSC-298 - START
                                                  if(oldOTCValue == false && solComp.Over_The_Counter__c == true){
                                                      otcFailure_ChildEntityUpdate(solComp, oldFailCode, oldAccCode, selectedSysCode.LEFT(2)+selectedCompCode.LEFT(2), solComp.AccountCodeEdit__c, solComp.CSS_Claims__c, claimsRec.SP_INSHOP_LABOR_RATE__c);
                                                      solComp.SRT_Fetched__c = false;
                                                  }
                                                  //GSSC-298 - END
                                                  upsert solComp solComp.id;
                                              }else{
                                                  system.debug('**8inside else...');
                                                  isMultiPSNErrorExist = true;
                                                  return null;
                                              }
                                          }else{
                                              system.debug('*****before saving solComp************');
                                              system.debug('2-->'+solComp.Over_The_Counter__c);
                                              //GSSC-298 - START
                                              if(oldOTCValue == false && solComp.Over_The_Counter__c == true){
                                                  otcFailure_ChildEntityUpdate(solComp, oldFailCode, oldAccCode, selectedSysCode+selectedCompCode, solComp.AccountCodeEdit__c, solComp.CSS_Claims__c, claimsRec.SP_INSHOP_LABOR_RATE__c);
                                                  solComp.SRT_Fetched__c = false;
                                              }
                                              //GSSC-298 - END
                                              upsert solComp solComp.id;
                                              system.debug('update'+solComp);
                                          }
                                          
                                          //update RevisionBefore/After on PSN
                                          if(selectedSysCode!= null && selectedSysCode!= '' && (selectedSysCode.startsWith('EQ') || selectedSysCode.startsWith('WE'))) {
                                              update psnRec;
                                          }
                                          
                                          if(claimsRec != null && solComp !=null && solComp.Pay_Code__c != 'A'){
                                              claimsRec.Failures_ODM_Status__c='YTBV';
                                              update claimsRec;
                                          }
                                          //Calling GSQ Parts.
                                          CSS_FN_SRT.FetchGSQParts(solComp.id, Wid);
                                          
                                          system.debug('Upsert is done Successfully**'); 
                                          system.debug('SolComp**'+solComp);
                                          pageRef = new pageReference('/apex/CG_ClaimsFC?id='+wid); 
                                          pageRef.setRedirect(true);
                                          //return pageRef;
                                          
                                      }
            
            else {   pageRef  = null;}
            
            //GSSC-106 -- Added Condition to check for Mileage and Product Hours //
           /* system.debug('accCodeSelected--'+accCodeSelected);
            system.debug('claimsRec.Automotive_App_Flag__c--'+claimsRec.Automotive_App_Flag__c);
            system.debug('psnRec.License_Plate_State__c--'+psnRec.License_Plate_State__c);
            
            claimsRec.MileageProdHrsError__c = 'Success';
            if(accCodeSelected.contains('70') && claimsRec.Automotive_App_Flag__c == 'Y' && psnRec.License_Plate_State__c == 'CA - California'){
                if((psnRec.Mileage__c == null || psnRec.Mileage__c == 0) || (psnRec.Product_Hours__c == null || psnRec.Product_Hours__c == 0)){
                    claimsRec.Id = Wid;
                    claimsRec.MileageProdHrsError__c = 'Error'; 
                }
                else{
                    claimsRec.Id = Wid;
                    claimsRec.MileageProdHrsError__c = 'Success';
                }
            }
            update claimsRec;*/
            //106
            try{
            
            List<CSS_Solution_Component__c>compList = [SELECT Id, Component_Id__c,FailCode_Formula__c,CSS_Account_Formula__c, Type__c, CampaignLaborPercentage__c FROM 
                        CSS_Solution_Component__c where  CSS_Claims__c =:claimsRec.id and Selected_Component__c = : true];
            system.debug('compList--'+compList);
            for(CSS_Solution_Component__c solComp1:compList){
                system.debug('solComp.CSS_Account_Formula__c--'+solComp1.CSS_Account_Formula__c);
                system.debug('claimsRec.Automotive_App_Flag__c--'+claimsRec.Automotive_App_Flag__c);
                system.debug('psnRec.License_Plate_State__c--'+psnRec.License_Plate_State__c);
                system.debug('psnRec.Mileage__c--'+ psnRec.Mileage__c);
                system.debug('psnRec.Product_Hours__c--'+psnRec.Product_Hours__c);
                if(solComp1.CSS_Account_Formula__c != null && solComp1.CSS_Account_Formula__c != '' && solComp1.CSS_Account_Formula__c.contains('70')){
                    if(claimsRec.Automotive_App_Flag__c == 'Y' && psnRec.License_Plate_State__c == 'CA - California'){
                        if((psnRec.Mileage__c == null || psnRec.Mileage__c == 0) || (psnRec.Product_Hours__c == null || psnRec.Product_Hours__c == 0)){
                            //workJob.Id = Wid;
                            //workJob.MileageProdHrsError__c = 'Error';
                            mileageProdHrsError = true;
                        }
                        else{
                            //workJob.Id = Wid;
                            //workJob.MileageProdHrsError__c = 'Success';
                            mileageProdHrsError = false;
                        }
                    }

                }

            }
            CSS_Claims__c mileageProdHrsErrorUpd = new CSS_Claims__c();
            mileageProdHrsErrorUpd.Id = claimsRec.id;
            system.debug('mileageProdHrsError--'+mileageProdHrsError);
            if(mileageProdHrsError == true){
                mileageProdHrsErrorUpd.MileageProdHrsError__c = 'Error';
            }
            else{
                mileageProdHrsErrorUpd.MileageProdHrsError__c = 'Success';
            }

            update mileageProdHrsErrorUpd;
            system.debug('mileageProdHrsErrorUpd.MileageProdHrsError__c--'+mileageProdHrsErrorUpd.MileageProdHrsError__c);
        }
        catch(Exception ex){
            System.debug('save >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
            
            
            //106 END
            
        }catch(Exception e)  {
            system.debug('EXCEPTION of PopupSave method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            clearPopup();
        }    
        return PageRef;
    }
    
    public void getAccCodeList(){
        string orgtype=css_utility.getOrgType(userinfo.getUserId());
        User usr;
        usr = css_utility.getUserAttributes(userinfo.getUserId());
        string userRole = usr.UserRoleName__c;
        List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
        if (orgtype=='DISTR' || userrole.contains('Factory')){
            system.debug('inside distru');
            //Added claimsRec.PACCAR_Converted_to_PW__c == true condition below as part of the story GSSC-71
            if(claimsRec.PACCAR_Converted_to_PW__c == true || (claimsRec.No_Failure_PACCAR_Flag__c == true && claimsRec.Parts_Warranty_Claim_Only__c == true) || claimsRec.PACCAR_PW_AutoSelected__c == true || (claimsRec.IsDealerCreatedClaim__c && claimsRec.Parts_Warranty_Claim_Only__c && claimsRec.PACCAR_Auth_Required__c && claimsRec.PACCAR_Flag__c && !claimsRec.CSS_PACCAR_Auth_Track__c))
            {
                showDisabledAC=false;
                ShowCoverageCheck = false;
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' AND Attribute1__c in ('POL', 'NPW', 'RPW') order by Attribute2__c asc];
                
            }
            else
            {
                showDisabledAC=true;
                ShowCoverageCheck=true;
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' order by Attribute2__c asc];
            }
            
        }
        else{
            //Added claimsRec.PACCAR_Converted_to_PW__c == true condition below as part of the story GSSC-71
            if(claimsRec.PACCAR_Converted_to_PW__c == true || (claimsRec.No_Failure_PACCAR_Flag__c == true && claimsRec.Parts_Warranty_Claim_Only__c == true) || claimsRec.PACCAR_PW_AutoSelected__c == true || (claimsRec.IsDealerCreatedClaim__c && claimsRec.Parts_Warranty_Claim_Only__c && claimsRec.PACCAR_Auth_Required__c && claimsRec.PACCAR_Flag__c && !claimsRec.CSS_PACCAR_Auth_Track__c))
            {
                
                showDisabledAC=false;
                ShowCoverageCheck = false;
                
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' AND Attribute1__c in ('NPW','RPW') order by Attribute2__c asc];
                
            }
            else{
                showDisabledAC=true;
                ShowCoverageCheck=true;
                system.debug('ShowCoverageCheck'+ShowCoverageCheck);
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Attribute15__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
            }
            
        }
        
        if(jobEventTemp.size() > 0){
            system.debug('jobEventTemp.size()-->'+jobEventTemp.size());
            system.debug('jobEventTempData-->'+jobEventTemp);
            accCodes = new List<SelectOption>();
            accCodes.add(new SelectOption('Select One','Select One'));
            
            for(CSS_JobEventTemporary__c j : jobEventTemp){
                string s = j.Attribute2__c+' '+ j.Attribute3__c;
                //accCodes.add(new SelectOption(j.Attribute2__c,s));
                accCodes.add(new SelectOption(s,s));
                //accCode = accCodeSelected;  
            }
        }        
    }
    
    public void onAddClick(){
        
        showDisabledAC = true;
        disableparts=false;
        failmodeloadval = '';
        clearPopup();
        //DeletePopupAC();
        if((compont.CSS_Account_Formula__c != null && compont.CSS_Account_Formula__c != '') && (compont.AccountCodeEdit__c == null || compont.AccountCodeEdit__c == ''))
            accCodeWS = compont.CSS_Account_Formula__c.Trim();
        system.debug('accCodeWS' + accCodeWS);
        if(compont.Parts_Warranty__c != null && compont.Parts_Warranty__c != '')
            partsWarranty = compont.Parts_Warranty__c;
        if(compont.Customer_Take_Possession__c != null && compont.Customer_Take_Possession__c != '')
            custSelect = compont.Customer_Take_Possession__c;
        if(compont.Failure_Measure__c != null && compont.Failure_Measure__c != '')
            failureMeasure = compont.Failure_Measure__c;
        updateSRTFailNames();
        //coverageType='';
    }
    
    public void checkPartCoverage(){
        string selFC = '';
        if(selectedFaultCode != null && selectedFaultCode != '')
            selFC = selectedFaultCode.substring(0,2);
        try{
            chkClickonPartsCoverage = true;
            //Commented below code for the observation raised for the closed defect#190301 
            /* if(selectedSysCode.length()>2)
selectedSysCode=selectedSysCode.substring(0,2);
if(selectedCompCode.length()>2)
selectedCompCode=selectedCompCode.substring(0,2);*/            if(selectedFailMode.length()>2)
    selectedFailMode=selectedFailMode.substring(0,2);
            if(selectedFaultCode!=null && selectedFaultCode.contains('-')){
                String[] sFaultCode=selectedFaultCode.split('-')  ;
                selectedFaultCode=sFaultCode[0];
            }
            compToUpdate = new CSS_Solution_Component__c(); // Added as per defect 173485
            
            if(failureMeasure != null && failureMeasure != ''){
                compont.Failure_Measure__c = failureMeasure;
            }
            
            if(compont.Failure_Measure__c == null || compont.Failure_Measure__c == ''){
                if(failureMeasure != null && failureMeasure != ''){
                    compont.Failure_Measure__c = failureMeasure;
                }
                else{
                    compont.Failure_Measure__c = 'Miles';//Added as part of GSSC-217
                    failureMeasure = 'Miles';
                }
            }
            else
                failureMeasure = compont.Failure_Measure__c;
            
            system.debug('failureMeasure-->'+failureMeasure);
            
            //Assign Parts Warranty Values      
            if(partsWarranty == null || partsWarranty == ''){
                if(accCodeSelected.contains('62') || accCodeSelected.contains('35')){
                    partsWarranty = 'New Parts Warranty';
                }           
                else{
                    if(accCodeSelected.contains('97') || accCodeSelected.contains('41')){
                        partsWarranty = 'Recon Parts Warranty';
                    }
                }
            }    
            date failureDate;
            if(compont.Failure_Date__c != null)
                failureDate = compont.Failure_Date__c;
            else
                failureDate = psnRec.Failure_Date__c;
            css_solution_component__c solComp = new css_solution_component__c();
            try{
                solcomp = [select id,name,Failure_Point__c,Failure_Measure__c,Part_Warranty_Start_Date__c,Selected_Component__c,Customer_Take_Possession__c from css_solution_component__c where name=:selectedFName and Component_Code__c=:selectedCompCode.substring(0,2) and System_Code__c=:selectedSysCode.substring(0,2) and Failure_Mode__c=:selectedFailMode limit 1];
            }
            catch(Exception ex){
                compToUpdate.AccountCodeEdit__c = ' '; // To avoid Blue Screen Error
            }
            String Appcodepass;
            if(psnRec.ApplicationCode__c==null) {
                if(claimsRec.CSS_Job__c!=null)
                    Appcodepass = claimsRec.CSS_Job__r.ApplicationCode__c;          
                else if(claimsRec.Dealer_Service_Job__c!=null)
                    Appcodepass = claimsRec.Dealer_Service_Job__r.ApplicationCode__c;  
            }
            else{
                Appcodepass = psnRec.ApplicationCode__c;
            }
             String tempAC = accCodeSelected != null && accCodeSelected != '' ? accCodeSelected.right(2) : '';
            if(claimsRec.ReconEngineFlag__c!=null && claimsRec.ReconEngineFlag__c=='Y'){
                System.debug('entered in to reconengine'+claimsRec.ReconEngineFlag__c);
                //compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,claimsRec.Location_Code__c,failureDate,string.valueof(compont.Failure_Point__c),compont.Failure_Measure__c,Appcodepass,compont.Part_Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,selectedFaultCode,'98',solComp.id,solComp.Selected_Component__c,'',partsWarranty,'Second Call', '',true, claimsRec.Name);
                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,claimsRec.Location_Code__c,failureDate,string.valueof(compont.Failure_Point__c),compont.Failure_Measure__c,Appcodepass,compont.Part_Warranty_Start_Date__c,SelectedsysCode.substring(0,2),SelectedCompCode.substring(0,2),selFC,tempAC,solComp.id,solComp.Selected_Component__c,'',partsWarranty,'Second Call', '',true, claimsRec.Name); //Commented above and added this to avoid Ending position outofbounds issue with selectedFaultCode,UAT Observation
            }
            else{
                System.debug('entered in else to reconengine'+claimsRec.ReconEngineFlag__c);
               
                //compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,claimsRec.Location_Code__c,failureDate,string.valueof(compont.Failure_Point__c),failureMeasure,Appcodepass,compont.Part_Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,selectedFaultCode,tempAC,solComp.id,solComp.Selected_Component__c,'',partsWarranty,'Second Call', '',true, claimsRec.Name);   
                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,claimsRec.Location_Code__c,failureDate,string.valueof(compont.Failure_Point__c),failureMeasure,Appcodepass,compont.Part_Warranty_Start_Date__c,SelectedsysCode.substring(0,2),SelectedCompCode.substring(0,2),selFC,tempAC,solComp.id,solComp.Selected_Component__c,'',partsWarranty,'Second Call', '',true, claimsRec.Name);  //Commented above and added this to avoid Ending position outofbounds issue with selectedFaultCode,UAT Observation
            }
            system.debug('Testres'+compToUpdate);
            //Added Validation for Inside Out Sprint #183076-- Rajasekhar H//
            if(compToUpdate != null && compToUpdate.AccountCode_Call_Status__c != null && compToUpdate.AccountCode_Call_Status__c != 'Failure')
                warrantyDetError=false;
            else 
                warrantyDetError=true;
            //End
            
            if(compToUpdate != null && compToUpdate.AccountCode_Call_Status__c != null && compToUpdate.AccountCode_Call_Status__c == 'Failure'){
                warrantyCompFailure = true;
                system.debug('Test343');
            }
            else{
                warrantyCompFailure = false;
                if(compToUpdate != null && ((compToUpdate.CoveredLaborHrs__c != '' && compToUpdate.CoveredLaborHrs__c != null && compToUpdate.CoveredLaborHrs__c != '0') || 
                                            (compToUpdate.CoveredMealsLodgingAmt__c != '' && compToUpdate.CoveredMealsLodgingAmt__c != null && compToUpdate.CoveredMealsLodgingAmt__c != '0') || 
                                            (compToUpdate.CoveredOCAmount__c != '' && compToUpdate.CoveredOCAmount__c != null && compToUpdate.CoveredOCAmount__c != '0') || 
                                            (compToUpdate.CoveredPartsQty__c != '' && compToUpdate.CoveredPartsQty__c != null && compToUpdate.CoveredPartsQty__c != '0') || 
                                            (compToUpdate.CoveredTowingMiles__c != '' && compToUpdate.CoveredTowingMiles__c != null && compToUpdate.CoveredTowingMiles__c != '0') || 
                                            (compToUpdate.CoveredTravelLabor__c != '' && compToUpdate.CoveredTravelLabor__c != null && compToUpdate.CoveredTravelLabor__c != '0') || 
                                            (compToUpdate.CoveredTravelMiles__c != '' && compToUpdate.CoveredTravelMiles__c != null && compToUpdate.CoveredTravelMiles__c != '0'))){
                                                partCoverageFound = 'true';
                                                if(compToUpdate != null && compToUpdate.AccountCodeEdit__c != null)
                                                    compToUpdate.AccountCodeEdit__c = compToUpdate.AccountCodeEdit__c.trim();
                                                if(compToUpdate != null && compToUpdate.AccountCodeEdit__c != '')
                                                    accCodeSelected = compToUpdate.AccountCodeEdit__c;
                                                system.debug('accCodeSelected' + accCodeSelected);
                                            }
                else{
                    system.debug('in else condition');
                    partCoverageFound = 'false';
                    if(compToUpdate != null){
                        compToUpdate.AccountCodeEdit__c = '';
                    }
                }
            }
        }
        catch(Exception ex){
            partCoverageFound ='false';
            system.debug('Catch Check Coverage'+ ex.getmessage()+' '+ex.getLineNumber());
        }
    }
    
    public void clearPopup(){
        invalidFailure = false;
        invalidCustFailure = false;
        invalidSysCode = false;
        invalidCompCode = false;
        invalidFailMode = false;
        invalidFaultCode = false;
        failureDate=null;
        compont.AccountCode__c = null;
        compont.AccountCodeEdit__c = null;
        partsWarranty = '';
        custSelect = '';
        errornotcovfound = false;
        if( !(selectedCompId != null && selectedCompId != '' && disableparts)){
            compont.Failure_Point__c = null; 
            compont.Part_Warranty_Start_Date__c = null;
            compont.Failure_Date__c = null;
            failureMeasure = '';
            dateErrFlag=false; 
            higherdateErrFlag=false;
        }
        compont.Authorization_Number__c = null;
        compont.Approval_Code__c = null;
        compont.Pay_Code__c = null;
        coverageFound = '';
        solCompExistsFlag = '';
        partCoverageFound = '';
        claimTypeSelected = 'Select One';
        Possession = '';
        compont.Over_The_Counter__c = false; //GSSC-298
        getCoverageType();
        //Added claimsRec.PACCAR_Converted_to_PW__c == true condition below as part of the story GSSC-71
        if(claimsRec.PACCAR_Converted_to_PW__c == true || (claimsRec.No_Failure_PACCAR_Flag__c == true && claimsRec.Parts_Warranty_Claim_Only__c == true) || claimsRec.PACCAR_PW_AutoSelected__c == true || (claimsRec.IsDealerCreatedClaim__c && claimsRec.Parts_Warranty_Claim_Only__c && claimsRec.PACCAR_Auth_Required__c && claimsRec.PACCAR_Flag__c && !claimsRec.CSS_PACCAR_Auth_Track__c)){
            showDisabledAC=false;
            ShowCoverageCheck = false;
        }
        else{
            showDisabledAC=true;
            ShowCoverageCheck=true;
        }
    }
    
    public void getCoverageType(){
        if(accCodeSelected != null){
            try{
                coverageType = [select Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' and Account_Code__c = :accCodeSelected].Attribute1__c;
            }catch(exception ex){
                coverageType = '';
            }
        } else coverageType = '';
    }
    
    
    
    public void validatedisabilityparts(){
        string orgtype=css_utility.getOrgType(userinfo.getUserId());
        User usr;
        usr = css_utility.getUserAttributes(userinfo.getUserId());
        string userRole = usr.UserRoleName__c;
        if ((( !dealerLocation &&(claimsRec.CSS_Job__c==null ||  claimsRec.CSS_Job__c==''))  ||dealerLocation )  && selectedCompId != null && selectedCompId != '' ){
            switch on coverageType{
                when 'NPW','RPW','RRW'{
                    disableparts=true;
                } when else{
                    disableparts=false;
                }
            }
        } else{
            disableparts=false; 
        }
        
    }
    
    public List<SelectOption>  getclaimTypes(){
        claimTypes = new List<SelectOption>();
        claimTypes = CG_BL_Claims.getClaimType(Wid,claimsRec.Location_Code__c,'ClaimsFC');
        //claimTypes.sort();
        return claimTypes;
    }
    //GSSC-298
    public void otcFailure_ChildEntityUpdate(CSS_Solution_Component__c solComp, String oldFC, String oldAC, String newFailCode, String newAccCode, Id claimId, String inShopRate){
        system.debug('solComp-->'+solComp);
        system.debug('failCode-->'+newFailCode);
        system.debug('accCode-->'+newAccCode);
        system.debug('claimId-->'+claimId);
        Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
        Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
        List<CSS_SRT__c> srtLst = new List<CSS_SRT__c>();
        List<CSS_Parts_Options__c> partLst = new List<CSS_Parts_Options__c>();
        List<CSS_Parts_Options__c> partLstDel = new List<CSS_Parts_Options__c>();
        srtLst = [SELECT Id, SRT_ID__c, FailCode__c, Fail_Code_Description__c, AccountCode_Formula__c FROM CSS_SRT__c WHERE (CSS_Claims__c =: claimId AND SRT_ID__c IN ('00-902-00','00-904-00')) OR 
                            (CSS_Claims__c =: claimId AND Type__c != '99Time' AND Type__c != 'Field Action' AND FailCode__c =: oldFC AND AccountCode_Formula__c =: oldAC AND SRT_ID__c != '00-10S-00') ];
    
        partLst = [SELECT Id, RecordTypeId, Item__c, Get_Fail_Code_Formula__c, Account_Code__c FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: claimId AND 
                            (RecordTypeId =: recTypeIdTTML OR RecordTypeId =: recTypeIdOC) AND Get_Fail_Code_Formula__c != null AND Get_Fail_Code_Formula__c != '' AND Get_Fail_Code_Formula__c != 'Select One' AND
                            Account_Code__c != null AND Account_Code__c != '' AND Account_Code__c != 'Select One'];
        for(CSS_Parts_Options__c po : partLst){
            if(po.RecordTypeId == recTypeIdTTML){
                String tempFC = po.Get_Fail_Code_Formula__c.RIGHT(4);
                if(tempFC == oldFC && po.Account_Code__c == oldAC){
                    partLstDel.add(po);
                }
            }
            else if(po.RecordTypeId == recTypeIdOC){
                if(po.Item__c == 'COMMERCIAL TRAVEL' || po.Item__c == 'TOWING'){
                    String tempFC = po.Get_Fail_Code_Formula__c.RIGHT(4);
                    if(tempFC == oldFC && po.Account_Code__c == oldAC){
                        partLstDel.add(po);
                    }
                }
            }
        }
        if(srtLst != null && srtLst.size() > 0){
            delete srtLst;
        }
        if(partLstDel != null && partLstDel.size() > 0){
            delete partLstDel;
        }
    }
}