/**********************************************************************
Name:CG_CL_ClaimsFailuresOverviewComp
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
public class CG_CL_ClaimsFailuresOverviewComp{ 

    //Variable declaration
    public Id Wid {get;set;}
    public boolean errornotcovfound{get;set;}
    public String Possession{get;set;}
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
    public string selectedFName{get;set;}//Faiulre Names
    public string selectedSysCode {get;set;}//System Codes
    public string selectedFailureID {get;set;}//Failure Ids
    public string selectedCompCode {get;set;}//Com Codes
    public string accCodeReturned {get;set;}
    public string accCodeSelected {get;set;}
    public List<SelectOption> lstPCvalues{get;set;}
    public string coverageFound {get;set;}
    public string coverageType{get;set;}
    public string selectedFailMode {get;set;}
    public Boolean warrantyCompFailure {get;set;}
    public List<SelectOption> accCodes{get;set;}
    public string payCodeSelected {get;set;}//Pay Codes
    public string selectedFaultCode {get;set;}//Claim Types
    public string AuthorizationNumber{get;set;}
    public string ApprovalCode{get;set;}
    public boolean showDisabledAC {get;set;}
    public CSS_Claims__c claimsRec{get;set;}
    public CSS_PSN__c psnRec{get;set;}
    public Set<String> failureNameList{get;set;}//faliureNameList
    public Set<String> componentCodeList{get;set;}
    public Set<String> systemCodeList{get;set;}
    public Set<String> faultCodeList{get;set;}
    public Set<String> failemodeList{get;set;}
    public Map<String,String> failureNameWithSystemCodeMap{get;set;}
    public Map<String,String> failureNameWithFailureIdMap{get;set;}
    public Map<String,String> failureNameWithCompCodeMap{get;set;}
    public string selectedCompId{get;set;}
    public string deleteCompId{get;set;}
    public String accCodeWS {get;set;}
    public CSS_Solution_Component__c compont {get;set;}
    public string partsWarranty{get;set;}
    public String custSelect{get;set;}
    public string datebyLocaleValue {get;set;}
    public css_job_order__c workJob {get;set;}
    public string failureMeasure{get;set;}
    public string warrStDtHidden{get;set;}

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

    //function to fetch the failure name, system code and component code from GetFailureCodeSRT webservice
    //public Set<String> SRTFailurenames() { 

    //Added method for validated against the list of Approval Code which are received from Siebel by -RAJESH 29th May 
    public Boolean invalidAppCode{get;set;}
    public void onChangeofAppCode(){
        //  system.debug('**ApprovalCode**'+ApprovalCode);
        invalidAppCode = false;
        if(ApprovalCode != null && ApprovalCode != ''){
            string validappCode;
            try{
                validappCode = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute4__c,Attribute5__c, Reason__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'ApprovalAuthCode' AND Attribute4__c=:ApprovalCode limit 1].Attribute5__c ;
                //  system.debug('**validappCode**'+validappCode);
            }
            catch(exception Err){
            }
            if(validappCode == 'Y'){
                // system.debug('insideY**validappCode**'+validappCode);
                invalidAppCode = false;
                //  system.debug('**invalidAppCode**'+invalidAppCode);

            }
            else{ 
                // system.debug('insideelse**validappCode**'+validappCode);
                invalidAppCode=true;
            }
            // system.debug('**invalidAppCode**'+invalidAppCode);
        }
    }


    public void SRTFailurenames() { 
        //public List<Css_solution_component__c> getFailureNames(){
        system.debug('Inside FailuureNames**');
        //system.debug('****Id***'+Wid);
        system.debug('****failureNames List***'+failureNameList);
        system.debug('****failureNameList***'+failureNameList.size());
        //  system.debug('SelectedFname**'+selectedFName);
        //  system.debug('claimsRec**'+claimsRec);


        if((selectedFName==null ||  selectedFName.toLowerCase() != 'unlisted') && wid!=null){ //Kalpana, Changed Condition to handle Unlisted scenario: Not to call SRT Service
            // if(wid!=null){
            system.debug('Inside NOT Unlisted**');
            //system.debug('claimsRec.CSS_PSNs__r**'+claimsRec.CSS_PSNs__r);
            //system.debug('claimsRec.CSS_PSNs__r[0].Service_Model__c**'+claimsRec.CSS_PSNs__r[0].Service_Model__c);
            //system.debug('claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c**'+claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c);
            //check if the failureName list is already populated and Service Modal and PSN is not null
            if(failureNameList.size()==0 && claimsRec.CSS_PSNs__r != null && claimsRec.CSS_PSNs__r.size() > 0 && claimsRec.CSS_PSNs__r[0].Service_Model__c!=null && claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c!=null){
                CSS_SRTComponentLookupResponseJ2A failureCodeDetails;
                try{
                    //  system.debug('claimsRec**'+claimsRec);
                    //List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
                    CSS_JobEventTemporary__c[] jobEventTemp;// = new CSS_JobEventTemporary__c();
                    String smn_engFamCode = claimsRec.CSS_PSNs__r[0].Service_Model__c + ';;' + claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c;
                    // system.debug('****smn_engFamCode***'+smn_engFamCode);
                    try{
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Reason__c, Key__c FROM CSS_JobEventTemporary__c WHERE Attribute3__c =: smn_engFamCode  AND Key__c = 'getFailureCodesSRT' AND CreatedDate = LAST_N_DAYS:7 LIMIT 1];
                    }
                    catch(exception Err){
                    }

                      system.debug('job even temp'+jobEventTemp);

                    if(jobEventTemp.size()==0){

                        CSS_FN_SRT controller = new CSS_FN_SRT();

                        //Added value unlisted value 

                        //call the SRT webservice based on Service Modal and Engine Code   
                        failureCodeDetails = controller.getFailureCodesSRT(claimsRec.CSS_PSNs__r[0].Service_Model__c,claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c, 'en');

                        System.debug('failureCodeDetails :' + failureCodeDetails);
                        //Insert FaliureCode Details to Job Event Temp Object : Kalpana
                        String output = JSON.serialize(failureCodeDetails);
                        System.debug('output :' + output);
                        CSS_JobEventTemporary__c jobEventTempRec = new CSS_JobEventTemporary__c();
                        jobEventTempRec.Attribute1__c = claimsRec.CSS_PSNs__r[0].Service_Model__c;
                        jobEventTempRec.Attribute2__c = claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c;
                        jobEventTempRec.Attribute3__c = claimsRec.CSS_PSNs__r[0].Service_Model__c + ';;' + claimsRec.CSS_PSNs__r[0].Qsol_Engine_Family_Code__c; 
                        jobEventTempRec.Reason__c = output;
                        jobEventTempRec.Key__c = 'GetFailureCodesSRT';
                        insert jobEventTempRec;
                        //put all the failureName , SystemCode and Component code in a List
                        for(CSS_SRTComponentLookupResponseJ2A.DataArea data: failureCodeDetails.DataArea){
                            //data.FailureName = data.FailureName.remove('\'');
                            failureNameList.add(data.FailureName);

                            failureNameWithSystemCodeMap.put(data.FailureName,data.SystemCode);
                            failureNameWithFailureIdMap.put(data.FailureName,data.FailureID);
                            systemCodeList.add(data.SystemCode);
                            failureNameWithCompCodeMap.put(data.FailureName,data.ComponentCode);
                            componentCodeList.add(data.ComponentCode);
                        } 
                    }//if(jobEventTemp.isEmpty())
                    else {
                        //for(CSS_JobEventTemporary__c JET: jobEventTemp){
                        //Added below query as per Band of Brother story #152406 and #152399,-By RAJESH 07th Aug 2018                
                        // changed below code as per the Do it now sprint story 167921
                        //List<CSS_JobEventTemporary__c> lstJobEvnRec ;
                        //stJobEvnRec=[select Attribute1__c,Attribute3__c,Attribute2__c,Attribute4__c,Attribute5__c
                        // from CSS_JobEventTemporary__c 
                        //where key__c='FailCodes' ];
                        //End    

                        Map<String, CSS_JobEventTemporary__c> mapJET = new Map<String,CSS_JobEventTemporary__c>();
                        for(CSS_JobEventTemporary__c lstjet : [select Attribute1__c,Attribute3__c,Attribute2__c,Attribute4__c,Attribute5__c from CSS_JobEventTemporary__c where key__c='FailCodes']){
                            string temp = lstjet.Attribute1__c+lstjet.Attribute4__c;
                            if(!mapJET.containsKey(temp)){
                                mapJET.put(temp,lstjet);
                            }

                        }
                        //system.debug('**lstJobEvnRec**'+lstJobEvnRec);
                        //system.debug('jobEventTemp.Reason__c'+jobEventTemp[0].Reason__c);
                        if(jobEventTemp[0].Reason__c != null){
                            failureCodeDetails = (CSS_SRTComponentLookupResponseJ2A)JSON.deserializeStrict(jobEventTemp[0].Reason__c, CSS_SRTComponentLookupResponseJ2A.class);
                            system.debug('failureCodeDetails-->'+failureCodeDetails);
                        }
                        system.debug('failureCodeDetails.DataArea'+failureCodeDetails.DataArea);

                        if(failureCodeDetails.DataArea !=null){
                            //lstpaycode = new list<string>();
                            //  if(lstJobEvnRec!=null){ 
                            for(CSS_SRTComponentLookupResponseJ2A.DataArea det: failureCodeDetails.DataArea){
                                String strFN=det.FailureName;
                                String strCC=det.ComponentCode;
                                String strSC=det.SystemCode;
                                if(!failureNameList.contains(strFN)){
                                    failureNameList.add(det.FailureName);                                            
                                    systemCodeList.add(det.SystemCode);
                                    //failureNameWithSystemCodeMap.put(strFN,strSC);
                                    //Added below code as per Band of Brother story #152406 and #152399,-By RAJESH 07th Aug 2018                            
                                    system.debug('**det.SystemCode**'+det.SystemCode);
                                    system.debug('**det.ComponentCode**'+det.ComponentCode);
                                    system.debug('**det.FailureName**'+det.FailureName);
                                    //Added here the map as part of defect 165459   
                                    failureNameWithFailureIdMap.put(det.FailureName,det.FailureID);
                                    // changed below code as per the Do it now sprint story 167921
                                    string temp1 = det.SystemCode+det.ComponentCode;
                                    if(mapJET!= null){
                                        CSS_JobEventTemporary__c jobEveRec = new CSS_JobEventTemporary__c();
                                        jobEveRec = mapJET.get(temp1);
                                        if(jobEveRec != null && jobEveRec.Attribute4__c==det.ComponentCode && jobEveRec.Attribute1__c==det.SystemCode){
                                            //system.debug('jobEveRec.Attribute4__c*****'+jobEveRec.Attribute4__c);
                                            String CombinationValu=string.valueof(strCC+'-'+jobEveRec.Attribute5__c);
                                            failureNameWithCompCodeMap.put(strFN,CombinationValu);
                                            String CombinationValu1=string.valueof(strSC+'-'+jobEveRec.Attribute3__c);
                                            failureNameWithSystemCodeMap.put(strFN,CombinationValu1); 
                                            //commented here the map as part of defect 165459  
                                            //failureNameWithFailureIdMap.put(det.FailureName,det.FailureID);
                                            //system.debug('failureNameWithFailureIdMap*****'+failureNameWithFailureIdMap);
                                        }

                                    }
                                    // commented below code as per the Do it now sprint story 167921
                                    /*for(CSS_JobEventTemporary__c jobEveRec:lstJobEvnRec){ 
                            if(jobEveRec.Attribute4__c==det.ComponentCode && jobEveRec.Attribute1__c==det.SystemCode){
                                //system.debug('jobEveRec.Attribute4__c*****'+jobEveRec.Attribute4__c);
                                String CombinationValu=string.valueof(strCC+'-'+jobEveRec.Attribute5__c);
                                failureNameWithCompCodeMap.put(strFN,CombinationValu);
                                String CombinationValu1=string.valueof(strSC+'-'+jobEveRec.Attribute3__c);
                                failureNameWithSystemCodeMap.put(strFN,CombinationValu1); 
                                //commented here the map as part of defect 165459  
                                //failureNameWithFailureIdMap.put(det.FailureName,det.FailureID);
                                //system.debug('failureNameWithFailureIdMap*****'+failureNameWithFailureIdMap);
                            }
                            /* else{
failureNameWithCompCodeMap.put(strFN,strCC);
}*/
                                    //system.debug('jobEveRec.Attribute1__c*****'+jobEveRec.Attribute1__c);
                                    /*if(jobEveRec.Attribute1__c==det.SystemCode){
                                String CombinationValu1=string.valueof(strSC+'-'+jobEveRec.Attribute3__c);
                                failureNameWithSystemCodeMap.put(strFN,CombinationValu1);   
                                system.debug('failureNameWithSystemCodeMap*****'+failureNameWithSystemCodeMap);
                                system.debug(' System code Match');
                            }*/
                                    /* else{
failureNameWithSystemCodeMap.put(strFN,strsC);
}*/

                                    // }
                                    if(failureNameWithCompCodeMap.get(strFN)==null || failureNameWithCompCodeMap.get(strFN)=='')
                                        failureNameWithCompCodeMap.put(strFN,strCC);
                                    if(failureNameWithSystemCodeMap.get(strFN)==null || failureNameWithSystemCodeMap.get(strFN)=='')
                                        failureNameWithSystemCodeMap.put(strFN,strsC);
                                    //END         
                                }


                                //if(!componentCodeList.contains(strCC)){
                                componentCodeList.add(det.ComponentCode);
                                //failureNameWithCompCodeMap.put(strFN,strCC);
                                // }
                            }
                            //}
                        }

                        //}
                    }
                    failureNameList.add('Unlisted');

                }
                catch(Exception e){
                    System.debug('Exception Calling getFailureCodesSRT :' + e.getLineNumber() + ' '+ e.getMessage());
                }

            }
        }
        //load system code and component code from siebel when failureName is 'Unlisted'
        if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
            system.debug('Inside Unlisted**');
            String sysDesc;
            String compDesc;
            //Added "Attribute4__c" into below query as per Band of Brother sprint story #152402,-By RAJESH 06 Aug 2018            
            List<CSS_JobEventTemporary__c> jobEventTemp = [select Attribute1__C,Attribute3__c, Attribute4__c,Attribute5__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailCodes' limit 1000];
            //end 
            system.debug('SiebelLsit**'+jobEventTemp);
            system.debug('*8SiebelLsit+**Attribute3__c'+jobEventTemp[0].Attribute3__c);
            system.debug('**SiebelLsit+**Attribute5__c'+jobEventTemp[0].Attribute5__c);
            if(jobEventTemp != null && jobEventTemp.size()>0){
                componentCodeList = new Set<string>();
                systemCodeList = new Set<string>();
                //systemCodeList.add('SEIBEL');
                // componentCodeList.add('SEIBEL');
                for(CSS_JobEventTemporary__c JET: jobEventTemp)
                {
                    //Added "Attribute3__c" into below as per Band of Brother sprint story #152399,-By RAJESH 06 Aug 2018               
                    //systemCodeList.add(JET.Attribute1__C);
                    //systemCodeList.add(JET.Attribute1__C+'-'+JET.Attribute3__c);
                    //Added "Attribute5__c" into below as per Band of Brother sprint story #152402,-By RAJESH 06 Aug 2018                
                    //componentCodeList.add(JET.Attribute4__c);
                    //componentCodeList.add(JET.Attribute4__c+'-'+JET.Attribute5__c);
                    sysDesc = JET.Attribute1__C+'-'+JET.Attribute3__c;
                    compDesc = JET.Attribute4__c+'-'+JET.Attribute5__c;
                    systemCodeList.add(sysDesc);
                    componentCodeList.add(compDesc);
                }
                system.debug('systemCodeListSiebel**'+systemCodeList);
                system.debug('componentCodeListSiebl**'+componentCodeList);

            }

        } 
        system.debug('Inside FailuureNames Size**' + failureNameList.size());

        // return failureNameList;

    }
    public Set<String> getfailurenames(){
        return failureNameList;

    }


    public Set<String> getComponentCodes(){
        //  system.debug('systemCodeListSiebel in function**'+componentCodeList);
        return componentCodeList;

    }

    public Set<String> getSystemCodes(){
        // system.debug('systemCodeList in function**'+systemCodeList);
        return systemCodeList;

    }
    /*public void EnableCoverageBtn(){
selectedFName = '';
selectedSysCode = '';
selectedCompCode='';
}*/



    /*public List<CSS_JobEventTemporary__c> getFailModes() 
{   

return [select Attribute1__C,Attribute3__c, Attribute5__c,Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailModes'];

}*/

    //Added code in below method for getting description along with Fail mode code as pert Band of Brother #152400,-By RAJESH 9th Aug 2018 
    public List<String> getFailModes() 
    { 
        List<CSS_JobEventTemporary__c> tempList = [select Attribute1__C,Attribute3__c from CSS_JobEventTemporary__c where key__c='FailModes' limit 1000];
        List<String> tempStr = new List<String>();
        for(CSS_JobEventTemporary__c lst : tempList){
            string temp1;
            temp1 = lst.Attribute3__c.replace('\'\\','');
            if(temp1 != null && temp1 != ''){
                tempStr.add(lst.Attribute1__c +'-'+temp1);
            }
        }
        return tempStr;
    }

    /*public List<CSS_JobEventTemporary__c> getFaultCodes() 
{   
system.debug('Inside getFaultCodes');
return [select Attribute1__c,Attribute3__c from CSS_JobEventTemporary__c where key__c='CDSFaultCodes' limit 1000];//Attribute1__c

}*/
    //method for fault codes to display with description for the story #152401
    public List<String> getFaultCodes(){
        List<CSS_JobEventTemporary__c> tempList = [select Attribute1__c,Attribute3__c from CSS_JobEventTemporary__c where key__c='CDSFaultCodes' limit 1000];
        List<String> tempStr = new List<String>();
        for(CSS_JobEventTemporary__c lst : tempList){
            string temp;
            temp = lst.Attribute3__c.replace('\'\\','');
            tempStr.add(lst.Attribute1__c+'-'+temp);
        }
        return tempStr;
    }


    /*public set<String> getFaultCodes() 
{   
system.debug('Inside getFaultCodes');
return faultCodeList;

}*/
    /* public void FaultCodeslst() 
{  
system.debug('Inside getFaultCodes');
List<CSS_JobEventTemporary__c> lstJE = new List<CSS_JobEventTemporary__c>();
lstJE = [select Attribute1__c,Attribute3__c from CSS_JobEventTemporary__c where key__c='CDSFaultCodes' limit 1000];//Attribute1__c 
if(lstJE != null && lstJE.size()>0){
faultCodeList = new set<string>();
for(CSS_JobEventTemporary__c je: lstJE){
string s = je.Attribute1__c +'-'+ je.Attribute3__c;
faultCodeList.add(s);
}
}
//return [select Attribute1__c,Attribute3__c from CSS_JobEventTemporary__c where key__c='CDSFaultCodes' limit 1000];//Attribute1__c
}*/
    public void changeFailures(){
        Bool=false;
        //system.debug('selectedFName>>'+ selectedFName);
        if(selectedFName!=null &&  selectedFName.toLowerCase() != 'unlisted'){
            system.debug('failureNameWithSystemCodeMap>>'+ failureNameWithSystemCodeMap);           
            selectedSysCode =  failureNameWithSystemCodeMap.get(selectedFName) ;  

            system.debug('failureNameWithCompCodeMap>>'+ failureNameWithCompCodeMap);
            selectedCompCode =  failureNameWithCompCodeMap.get(selectedFName); 

            system.debug('failureNameWithFailureIdMap>>'+ failureNameWithFailureIdMap);
            selectedFailureID = failureNameWithFailureIdMap.get(selectedFName);

            system.debug('selectedSysCode>>'+ selectedSysCode);
            system.debug('selectedFName>>'+ selectedFName);
            system.debug('selectedCompCode>>'+ selectedCompCode);
            system.debug('selectedFailureID>>'+ selectedFailureID);
            if(selectedSysCode!= null && selectedSysCode!= '' && (selectedSysCode.startsWith('EQ') || selectedSysCode.startsWith('WE'))) {
                Bool = true;
            }
            //if(( selectedSysCode!= null && selectedSysCode!= '') && selectedSysCode.startsWith('EQ') || selectedSysCode.startsWith('WE'))
            //Bool = true;
        }
        //Getting List from Siebel: Kalpana
        if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
            String sysDesc;
            String compDesc;
            List<CSS_JobEventTemporary__c> jobEventTemp = [select Attribute1__C,Attribute3__c, Attribute5__c,Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailCodes' limit 1000];
            //   system.debug('SiebelLsit**'+jobEventTemp);
            if(jobEventTemp != null && jobEventTemp.size()>0){
                componentCodeList = new Set<string>();
                systemCodeList = new Set<string>();
                //systemCodeList.add('SEIBEL');
                //componentCodeList.add('SEIBEL');
                for(CSS_JobEventTemporary__c JET: jobEventTemp)
                {
                    //systemCodeList.add(JET.Attribute1__C);
                    //componentCodeList.add(JET.Attribute4__c);
                    sysDesc = JET.Attribute1__C+'-'+JET.Attribute3__c;
                    compDesc = JET.Attribute4__c+'-'+JET.Attribute5__c;
                    systemCodeList.add(sysDesc);
                    componentCodeList.add(compDesc);
                }
                // system.debug('systemCodeListSiebel**'+systemCodeList);
                //  system.debug('componentCodeListSiebl**'+componentCodeList);

            }

        }
        // List<CSS_JobEventTemporary__c> Failmodelst = getFailModes();

    }        


    public List<SelectOption> getselectedSCodes() 
    {

        return null;    

    }

    public void changeSCodes()
    {}
    public void checkCoverage(){
        try{
            blankfield = false;
            system.debug('FName:'+selectedFName);
            //system.debug('SysCode:'+selectedSysCode);
            //  system.debug('CompCode:'+selectedCompCode);
            //  system.debug('Wid**:'+Wid);
            /* selectedFName = 'Crankcase Breather Tube';
selectedSysCode = 'BB';
selectedCompCode = 'TU';*/
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
            compToUpdate = new CSS_Solution_Component__c();
            CSS_Claims__c  claimsRec = new CSS_Claims__c();  
            CSS_PSN__c  psnRec = new CSS_PSN__c();
            lstPCvalues = new list<selectoption>();
            mapAccCode = new Map<string,String>();
            showDisabledAC = false;
            //string accCode;
            claimsRec =[Select Id,Customer_Name__c,Location__c,Dealer_Service_Job__c,Location_Code__c,ReconEngineFlag__c,CSS_Job__c,CSS_Job__r.name,CSS_Job__r.createddate,Shop_Work_Order__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,CoverageResponse__c, 
                        (Select Id,Name,PSN__c,Service_Model__c,Application__c,License_Plate_State__c,ApplicationCode__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c,Calibration_After__c,Calibration_Before__c,Revision_After__c,Revision_Before__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id= :WId];
            if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                psnRec = claimsRec.CSS_PSNs__r.get(0);}
            //system.debug('claimsRec**'+claimsRec);  
            //system.debug('psnRec**'+psnRec);
            //system.debug('psnRec**'+psnRec.Warranty_Start_Date__c);
            css_solution_component__c solComp = new css_solution_component__c();
            try{
                system.debug('*******selectedFName**8'+selectedFName);
                system.debug('*******selectedCompCode**8'+selectedCompCode);
                system.debug('*******selectedSysCode**8'+selectedSysCode);
                system.debug('*******selectedFailMode**8'+selectedFailMode);
                solcomp = [select id,name,Failure_Point__c,Failure_Measure__c,Part_Warranty_Start_Date__c,Selected_Component__c from css_solution_component__c where name=:selectedFName and Component_Code__c=:selectedCompCode and System_Code__c=:selectedSysCode and Failure_Mode__c=:selectedFailMode limit 1];
                system.debug('*******solcomp**8'+solcomp);
            }
            catch(Exception ex){
                system.debug('Exception in Save Expense method'+ ex.getMessage()+' '+ex.getLineNumber());
                system.debug('*******catch block**8');
                if(!Test.isRunningTest()){
                compToUpdate.AccountCodeEdit__c = ' '; // To avoid Blue Screen Error
                }
            }
            //system.debug('solcomp'+solcomp);
            //try{
            // if(solcomp!=null && claimsRec.ReconEngineFlag__c=='y'){
            /* if(solcomp!=null){

    if((solComp.Failure_Point__c != null && string.valueof(solComp.Failure_Point__c) != '') && (solComp.Failure_Measure__c != null && solComp.Failure_Measure__c != '')){
        compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(solComp.Failure_Point__c),solComp.Failure_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',null,solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true);
    }
    else{
        compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',null,solComp.id,solComp.Selected_Component__c,'','','Second Call', '', true);
    }
}*/

            // }
            try{

                if(solcomp!=null){

                    if((solComp.Failure_Point__c != null && string.valueof(solComp.Failure_Point__c) != '') && (solComp.Failure_Measure__c != null && solComp.Failure_Measure__c != '')){
                       system.debug('Failure_Point__c'+solComp.Failure_Point__c+solComp.Failure_Measure__c);
                        if(claimsRec.ReconEngineFlag__c!=null && claimsRec.ReconEngineFlag__c=='y'){
                            system.debug('enter ReconEngineFlag__c flagyyyyyyy'+claimsRec.ReconEngineFlag__c);
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(solComp.Failure_Point__c),solComp.Failure_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'','98',solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true);
                        }
                        else{
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(solComp.Failure_Point__c),solComp.Failure_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',null,solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true);
                        }
                    }
                    else{
                        if(claimsRec.ReconEngineFlag__c!=null && claimsRec.ReconEngineFlag__c=='y'){
                            system.debug('enter ReconEngineFlag__c flagyyyyyyy');
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'','98',solComp.id,solComp.Selected_Component__c,'','','Second Call', '', true);
                        }
                        else{
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',null,solComp.id,solComp.Selected_Component__c,'','','Second Call', '', true);
                        }
                    }
                }

            }
            catch(Exception ex){
                //coveragefound='false';
                // accCodeSelected = '';
                system.debug('inside catch compToUpdate.AccountCodeEdit__c**'+compToUpdate);
                compToUpdate.AccountCodeEdit__c = ' ';
            }

            system.debug('compToUpdate.AccountCodeEdit__c**'+compToUpdate);
            if(compToUpdate.AccountCodeEdit__c != null && compToUpdate.AccountCodeEdit__c != ' ')
            {
                //  system.debug('InsideAccountCodeIF**');
                //system.debug('compToUpdate.AccountCodeEdit__c**'+compToUpdate.AccountCodeEdit__c);
                coverageFound = 'true';
                //accCodeReturned = compToUpdate.AccountCodeEdit__c;
                accCodeSelected = compToUpdate.AccountCodeEdit__c;
                 system.debug('accCodeSelected'+accCodeSelected);
                //accCodeReturned = 'CMP-Campaign / Recalls 65'; // For Testing Purpose
                //payCodeSelected = 'I';
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
                    //  system.debug('jobEventTemp.size()-->'+jobEventTemp.size());
                    //system.debug('jobEventTempData-->'+jobEventTemp);
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
                        /*for(CSS_JobEventTemporary__c j : jobEventTemp){
string s = j.Attribute2__c+' '+ j.Attribute3__c;
//accCodes.add(new SelectOption(j.Attribute2__c,s));
system.debug('String s' + s);
if(fixedAccountCodes.contains(s))
accCodes.add(new SelectOption(s,s));
//accCode = accCodeSelected;  
}*/
                    }
                    else{
                        system.debug('outside fixed');
                        for(CSS_JobEventTemporary__c j : jobEventTemp){
                            string s = j.Attribute2__c+' '+ j.Attribute3__c;
                            //accCodes.add(new SelectOption(j.Attribute2__c,s));
                            if(s != accCodeSelected)
                                accCodesNew.add(new SelectOption(s,s));
                            //accCode = accCodeSelected;  
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
                    // system.debug('mapAccCode**'+mapAccCode); 

                    lstPCvalues = getPayCodesList(accCodeSelected.right(2).trim());
                    //update compToUpdate;
                    if(payCodeSelected != null && payCodeSelected != '')
                        lstPCValues.add(new SelectOption(payCodeSelected,payCodeSelected));
                    // system.debug('solcomp**'+solcomp);  
                    // system.debug('compToUpdate**'+compToUpdate);                     
                }         
            }
            else {
                system.debug('InsideAccountCodeElseIF**');
                warrantyCompFailure = false;
                coveragefound='false';
                accCodeSelected = '';
                accCodeReturned = '';
                SET<String> fixedAccountCodes  = new SET<String>{'New Parts Warranty 62','Recon Component Warranty 97',
                                                                 'Recon Defective Parts 41 (Failed from stock)','Service Tool Warranty 52',
                                                                 'New Defective Parts 35 (Failed from stock)'};

                //Preparing AccountCode List
                string orgtype=css_utility.getOrgType(userinfo.getUserId());
                List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
                if(orgtype=='DISTR')
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' order by Attribute2__c asc limit 1000];
                else
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Attribute15__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                if(jobEventTemp.size() > 0){
                    //system.debug('jobEventTemp.size()-->'+jobEventTemp.size());
                    // system.debug('jobEventTempData-->'+jobEventTemp);
                    accCodes = new List<SelectOption>();
                    accCodes.add(new SelectOption('Select One','Select One'));
                    if(claimsRec.CSS_Job__c==null && (psnRec.PSN__c== '10000000' || psnRec.PSN__c== '27000000')){
                        system.debug('inside fixed');
                        for(String s: fixedAccountCodes){
                            accCodes.add(new SelectOption(s,s));    
                        }
                        /*for(CSS_JobEventTemporary__c j : jobEventTemp){
string s = j.Attribute2__c+' '+ j.Attribute3__c;
//accCodes.add(new SelectOption(j.Attribute2__c,s));
system.debug('String s' + s);
if(fixedAccountCodes.contains(s))
accCodes.add(new SelectOption(s,s));
//accCode = accCodeSelected;  
}*/
                    }
                    else{
                        system.debug('Inside Else');
                        for(CSS_JobEventTemporary__c j : jobEventTemp){
                            string s = j.Attribute2__c+' '+ j.Attribute3__c;
                            //accCodes.add(new SelectOption(j.Attribute2__c,s));
                            accCodes.add(new SelectOption(s,s));
                            //accCode = accCodeSelected;  
                        }
                    }    


                    // system.debug('Query--->'+jobEventTemp);
                    // system.debug('lstaccCodes--->'+accCodes); 
                }         
                //Preparing PayCodeList
                List<CSS_JobEventTemporary__c> lstpayCodeReason = [select Attribute3__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes' and Attribute3__c =:accCodeReturned.right(2).trim()];
                //system.debug('PayCodeReason**'+lstpayCodeReason);
                for(CSS_JobEventTemporary__c jet: lstpayCodeReason){

                    if(jet.Reason__c !=null){
                        mapAccCode.put(jet.Attribute3__c,jet.Reason__c);
                    }
                }
                // system.debug('mapAccCode**'+mapAccCode); 

                lstPCvalues = getPayCodesList(accCodeReturned.right(2).trim());

                // system.debug('solcomp**'+solcomp);  
                // system.debug('compToUpdate**'+compToUpdate);
            }
            getCoverageType();

        }
        catch(Exception ex){
            system.debug('Catch Check Coverage'+ ex.getmessage()+' '+ex.getLineNumber());
        }
    }

    public void getPayCodesonAccCodeChange(){
        system.debug('InsideAccChangeMethod**');

        /*try{
//coverageType = [select Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' and Attribute2__c = :QueryAccCode and Attribute3__c = :Querystr].Attribute1__c;
coverageType = [select Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' and Account_Code__c = :accCodeSelected].Attribute1__c;
system.debug('CoverageType**'+coverageType);
}
catch(exception ex){
coverageType = '';
}*/
        clearPopup(); // clearPopup inturn calls getCoverageType();
        coverageFound='false';
        AuthorizationNumber = '';
        ApprovalCode = '';
        blankField=false;
        checkPartsWarrStartDt = false;
        /*if(accCodeSelected != 'EMISSION WARRANTY 70'){FCErrorVal = false;}*/
        system.debug('AccCodeSelected**'+accCodeSelected);
        mapAccCode = new Map<string,String>();
        lstPCvalues = new list<selectoption>();
        List<CSS_JobEventTemporary__c> lstpayCodeReason = [select Attribute3__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes' and Attribute3__c =:accCodeSelected.right(2).trim()];
        //  system.debug('PayCodeReason**'+lstpayCodeReason);
        for(CSS_JobEventTemporary__c jet: lstpayCodeReason){

            if(jet.Reason__c !=null){
                mapAccCode.put(jet.Attribute3__c,jet.Reason__c);
            }
        }
        // system.debug('mapAccCode**'+mapAccCode); 
        payCodeSelected = '';
        lstPCvalues = getPayCodesList(accCodeSelected.right(2).trim());


    }

    //Constructor
    public CG_CL_ClaimsFailuresOverviewComp(){

        //Possession = '';
        claimsRec = new CSS_Claims__c();
        partCoverageFound ='';
        errornotcovfound = false;
        psnRec = new CSS_PSN__c();
        compont = new css_solution_component__c();
        datebyLocaleValue = css_utility.getFormattedDate();
        failureNameList = new Set<String>();
        componentCodeList = new Set<String>();
        systemCodeList = new Set<String>();
        faultCodeList = new Set<String>();
        failemodeList = new Set<String>();
        failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithFailureIdMap = new Map<String,String>();
        failureNameWithCompCodeMap = new Map<String,String>();
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

            claimsRec =[Select id,CSS_Job__c,CSS_Job__r.Qsol_Engine_Family_Code__c,Dealer_Service_Job__c ,CSS_Job__r.Service_Model__c,ReconEngineFlag__c,Location_Code__c,CoverageResponse__c,Information_Only_Claim__c,Multi_PSN_Claim__c,
                        (Select Application__c,ApplicationCode__c,PSN__c,Qsol_Engine_Family_Code__c,Service_Model__c,Failure_Date__c,License_Plate_State__c,Before_In_Service__c,Calibration_After__c,Calibration_Before__c,Revision_After__c,Revision_Before__c from CSS_PSNs__r) from CSS_Claims__c WHERE ID =: wid];
            system.debug('*******claimsRec' + claimsRec);
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

    }

    public void onRadio()
    {
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
            dispFailuresList = [Select id, name, Failure_Mode__C,CSS_Account_Formula__c,FailMode_Desc__c,ComponentCode_Desc__c,SystemCode_Desc__c, AccountCodeType__c, AccountCodeEdit__c, Selected_Component__c, Claims_Failure_Select__c, Solutions__c, Solutions__r.Service_Job__c,Solutions__r.FaultCode__r.Name, Solutions__r.FaultCode__r.RelatedFaultCode__c,Solutions__r.Symptom__r.Name,Solutions__r.Symptom__c, Service_Job__c, CSS_Claims__c, AccountCode__c, System_Code__c, Component_Code__c, Pay_Code__c, Claim_Type__c from CSS_Solution_Component__c where CSS_Claims__c =: Wid and Selected_Component__c = true and type__C NOT IN ('TSB', 'TRP','ATC','Campaign')];
            //  system.debug('***dispfailureslist****'+dispFailuresList);

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


                /*string AccCode;
string AccCodeKey;
for(css_solution_component__c SolComp: dispFailuresList){ //this loop is needed ???
if(SolComp.AccountCode__c != null){
AccCode = SolComp.AccountCode__c;
AccCodeKey= SolComp.AccountCode__c;
Reason1 = mapAccCode.get(AccCodeKey);

system.debug('Reason1**'+Reason1);
List<CG_payCodeResJ2A> accountCodeResponse;
if(Reason1 != null){
accountCodeResponse = (List<CG_payCodeResJ2A>)JSON.deserializeStrict(Reason1, List<CG_payCodeResJ2A>.class);

system.debug('accountCodeResponse-->'+accountCodeResponse);
}
if(accountCodeResponse !=null && accountCodeResponse.size()>0){
lstpaycode = new list<string>();
for(integer i=0;i<accountCodeResponse.size();i++)
{
String strLstPC=accountCodeResponse[i].paycode;
if(!lstpaycode.contains(strLstPC)){
lstpaycode.add(accountCodeResponse[i].paycode);
}
}
}
system.debug('lstpaycode**'+lstpaycode);
lstPaycodeValues = getPayCodes(lstpaycode); //this should be called from below loop ??? by passing 
}
}*/

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
                        if(solComp.CSS_Account_Formula__c ==null && solComp.CSS_Account_Formula__c =='')
                            solComp.AccountCode__c = '02';
                        if(claimsRec.Information_Only_Claim__c == True){
                            solComp.Pay_Code__c = 'A';
                        }
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
        FCErrorVal = false;
        lstPCvalues= new List<SelectOption>();
        selectedFaultCode = ''; 
        blankfield = false;
        checkPartsWarrStartDt = false;
        solCompExistsFlag = 'false';
        //Commented as per story The Office 164459
        //OneaccCodeBool = '';
        isMultiPSNErrorExist = false;
        errornotcovfound = false;
        Bool = false;
        clearPopup();
    }

    //function to close the deletepopup
    public void closeDeletePopup(){
        deleteCompId=null;    
    }
    //
    public PageReference deleteSolRecordWOPSN(){
        system.debug('inside Delete method');
        system.debug('deleteCompId***'+deleteCompId);        
        if(deleteCompId!=null){

            try{
                CSS_Solution_Component__c deleteSol = [select Id, FailCode_Formula__c, CSS_Account_Formula__c
                                                       from CSS_Solution_Component__c
                                                       where id=: deleteCompId];
                CSS_Parts_Options__c[] Parts = [Select id,Option_Number__c from CSS_Parts_Options__c
                                                where RecordType.Name = 'Parts' and CSS_Claims__c =: Wid and FailurepartId__c =:deleteCompId order by Part_Name__c];

                CSS_SRT__c[] SRTList = [select Id from CSS_SRT__c 
                                        where Type__c = '99Time' AND Account_Code_Description__c =: deleteSol.CSS_Account_Formula__c
                                        AND Fail_Code_Description__c =: deleteSol.FailCode_Formula__c];
                delete deleteSol;  



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


                if(Parts != null && Parts.size() > 0)
                    delete Parts;
                if(SRTList != null && SRTList.size() > 0)
                    delete SRTList;          

            }catch(Exception e){
                System.debug('exception in DeleteSolRecord function'+e.getMessage() + ' ' + e.getLineNumber());
            }

            PageReference  pageRef = new pageReference('/apex/CG_ClaimsFC?id='+wid);
            pageRef.setRedirect(true);
            return pageRef;
        }

        return null;

    }

    //function to delete the Solution Component Record on Delete Button with Multi PSN
    public PageReference deleteSolRecord(){
        system.debug('inside Delete method');
        system.debug('deleteCompId***'+deleteCompId);        
        if(deleteCompId!=null){

            try{
                CSS_Solution_Component__c deleteSol = [select Id, FailCode_Formula__c, CSS_Account_Formula__c
                                                       from CSS_Solution_Component__c
                                                       where id=: deleteCompId];
                CSS_Parts_Options__c[] Parts = [Select id,Option_Number__c from CSS_Parts_Options__c
                                                where RecordType.Name = 'Parts' and CSS_Claims__c =: Wid and FailurepartId__c =:deleteCompId order by Part_Name__c];

                CSS_SRT__c[] SRTList = [select Id from CSS_SRT__c 
                                        where Type__c = '99Time' AND Account_Code_Description__c =: deleteSol.CSS_Account_Formula__c
                                        AND Fail_Code_Description__c =: deleteSol.FailCode_Formula__c];
                delete deleteSol;  

                if(Parts != null && Parts.size() > 0)
                    delete Parts;
                if(SRTList != null && SRTList.size() > 0)
                    delete SRTList;
                //159053 start
                //RAJESH Start
                if(isMultiPSNEnabled){
                    List<CSS_PSN__c> psnList = new List<CSS_PSN__c>([select Id, Name, CSS_Claims__c, Warranty_Start_Date__c, Primary__c, Before_In_Service__c, PSN__c 
                                                                     from  CSS_PSN__c where CSS_Claims__c=: Wid AND Primary__c=false]);
                    if(psnList != null && psnList.size() > 0)
                        delete psnList;
                    //159053 End
                    system.debug('psnList888888'+psnList);
                    system.debug('psnList.size()888888'+psnList.size());
                }
                //RAJESH END



            }catch(Exception e){
                System.debug('exception in DeleteSolRecord function'+e.getMessage() + ' ' + e.getLineNumber());
            }

            PageReference  pageRef = new pageReference('/apex/CG_ClaimsFC?id='+wid);
            pageRef.setRedirect(true);
            return pageRef;
        }

        return null;

    }
    //Method for delete the only psn records on popup save 
    public PageReference deletePSNRecord(){
        system.debug('inside Delete method on popup save');
        system.debug('selectedCompId***'+selectedCompId);
        if(selectedCompId!=null){
            system.debug('selectedCompId  Inside');
            CSS_PSN__c[] psnList = [select Id, Name, CSS_Claims__c, Warranty_Start_Date__c, Primary__c, Before_In_Service__c, PSN__c 
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
        isMultiPSNErrorExist = false;
        errornotcovfound = false;
        Bool=false;
        system.debug('selectedCompId***'+selectedCompId);
        //query the respected solution component record
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        solCompList =[Select Name,id,Component_Id__c, Claim_Type__c,Authorization_Number__c,Approval_Code__c,AccountCodeEdit__c,System_Code__c,Component_Code__c,Failure_Mode__c,CSS_Account_Formula__c,Pay_Code__c,Part_Warranty_Start_Date__c, Failure_Date__c, Failure_Point__c,Customer_Take_Possession__c, Failure_Measure__c,Fault_Code__c from CSS_Solution_Component__c where ID =:selectedCompId];
        system.debug('solCompList***'+solCompList);
        system.debug('solCompList[0].Failure_Point__c***'+solCompList[0].Failure_Point__c);
        system.debug('solCompList[0].Failure_Date__c***'+solCompList[0].Failure_Date__c);
        system.debug('solCompList[0].Part_Warranty_Start_Date__c***'+solCompList[0].Part_Warranty_Start_Date__c);
        //put the record in the selected variable to reflect in the edit popup
        if(solCompList.size()>0){
            coverageFound = 'false';
            selectedFName =  solCompList[0].Name ;
            selectedCompId = solCompList[0].id; 
            accCodeSelected = solCompList[0].CSS_Account_Formula__c;
            selectedSysCode = solCompList[0].System_Code__c; 
            selectedFailureID = solCompList[0].Component_Id__c;
            selectedCompCode =solCompList[0].Component_Code__c; 
            selectedFailMode = solCompList[0].Failure_Mode__c ; 
            system.debug('selectedFailMode vlaue'+selectedFailMode);
            selectedFaultCode = solCompList[0].Fault_Code__c;
            payCodeSelected=   solCompList[0].Pay_Code__c ;
            AuthorizationNumber = solCompList[0].Authorization_Number__c;
            ApprovalCode = solCompList[0].Approval_Code__c;
            compont.Part_Warranty_Start_Date__c = solCompList[0].Part_Warranty_Start_Date__c ;
            compont.Failure_Date__c = solCompList[0].Failure_Date__c ; 
            compont.Failure_Point__c = solCompList[0].Failure_Point__c ;
            //if(compont.Customer_Take_Possession__c!=null && compont.Customer_Take_Possession__c!='')
            Possession = solCompList[0].Customer_Take_Possession__c ;
            failureMeasure = solCompList[0].Failure_Measure__c;
            claimTypeSelected = solCompList[0].Claim_Type__c;

        }
        //Added below code as per Band of Brother story #152406,#152400 and #152399,-By RAJESH 08th Aug 2018       
        if(selectedFailMode!= null && selectedFailMode!=''){
            List<CSS_JobEventTemporary__c>  jobEvFM=[select Attribute1__c, Attribute3__c 
                                                     from CSS_JobEventTemporary__c 
                                                     where key__c='FailModes' limit 1000];
            for(CSS_JobEventTemporary__c jFM : jobEvFM){
                if(selectedFailMode==jFM.Attribute1__c){
                    selectedFailMode = selectedFailMode+'-'+ jFM.Attribute3__c; 
                }
            }
        }

        Map<String, CSS_JobEventTemporary__c> mapJET = new Map<String,CSS_JobEventTemporary__c>();
        for(CSS_JobEventTemporary__c lstjet : [select Attribute1__c,Attribute3__c,Attribute2__c,Attribute4__c,Attribute5__c from CSS_JobEventTemporary__c where key__c='FailCodes']){
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
        if(selectedFaultCode!= null && selectedFaultCode!= null){
            List<CSS_JobEventTemporary__c>  jobEvSCCC=[select  Attribute1__c,Attribute3__c
                                                       from CSS_JobEventTemporary__c 
                                                       where key__c='CDSFaultCodes' limit 1000];
            for(CSS_JobEventTemporary__c jSCCC :jobEvSCCC){
                if(selectedFaultCode==jSCCC.Attribute1__c){
                    selectedFaultCode=selectedFaultCode+'-'+jSCCC.Attribute3__c;
                }

            }
        }
        //End    

        if(accCodeSelected != null && accCodeSelected != ''){
            oldAccountCode=accCodeSelected;
            showDisabledAC = false;
            string orgtype=css_utility.getOrgType(userinfo.getUserId());
            List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
            if(orgtype=='DISTR')
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' order by Attribute2__c asc limit 1000];
            else
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Attribute15__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];   
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
        else{
            showDisabledAC = true;
        }

        if(selectedSysCode!= null && selectedSysCode!= '' && (selectedSysCode.startsWith('EQ') || selectedSysCode.startsWith('WE'))) {
            Bool = true;
        }

        //clearPopup();
        getCoverageType();
        system.debug('accCodeSelected'+accCodeSelected);
        system.debug('coverageFound'+coverageFound);
        //if(accCodeSelected != null && accCodeSelected != '')
        //  lstPCvalues = getPayCodesList(accCodeSelected.right(2).trim());
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
    public void saveClaimFailOvervwData(){
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
    }

    //Added 3 string fields as per defect #158390 and #158388,-By RAJESH on 13th Aug 2018
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

    public void CompareDates(){
        if(warrantyDate!=null && warrantyDate>System.TODAY()){
            checkPartsWarrStartDt = true;
        }
        else{
            checkPartsWarrStartDt = false;
        }
        system.debug('checkPartsWarrStartDt--'+checkPartsWarrStartDt);
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


    //public string FCError {get;set;}
    public Boolean FCErrorval {get;set;}
    public string solCompExistsFlag{get;set;}
    public Boolean blankField{get;set;}
    public String OneaccCodeBool{get;set;}
    public Boolean isMultiPSNErrorExist{get;set;}

    public PageReference popUpSave(){
        system.debug('Inside popUpSave method...selectedCompId>>:'+selectedCompId);
        PageReference pageRef;
        Boolean isMultiPSNEnabled = false;
        errornotcovfound = false;
        isMultiPSNErrorExist = false;
        //Commented as per story The Office 164459
        //OneaccCodeBool = '';
        radioSelect=false;
        Bool=false;
        system.debug('custSelect'+custSelect);
        system.debug('**claimsRec.Multi_PSN_Claim__c'+claimsRec.Multi_PSN_Claim__c);
        //system.debug('claimsRec.CSS_PSNs__r[0].Before_In_Service__c'+claimsRec.CSS_PSNs__r[0].Before_In_Service__c);
        system.debug('dispFailuresList>>:'+dispFailuresList.size()+' accCodeSelected>>:'+accCodeSelected);
        //159053
        //DeletePopupAC();
        system.debug('Inside DeletePopupAC');
        system.debug('accCodeSelected****'+accCodeSelected);
        system.debug('oldAccountCode*****'+oldAccountCode);
        system.debug('claimsRec.CSS_PSNs__r*****'+claimsRec.CSS_PSNs__r);
        system.debug('claimsRec.CSS_PSNs__r.size()*****'+claimsRec.CSS_PSNs__r.size());

        try {

            //if(claimsRec.Multi_PSN_Claim__c == true && claimsRec.CSS_PSNs__r[0].Before_In_Service__c == true 
            //&& dispFailuresList.size()==1 && claimsRec.css_job__c == null){ //commenting dispFailuresList.size()==1 since not required all times for save

            if(claimsRec.CSS_PSNs__r != null && claimsRec.CSS_PSNs__r.size()>0 && claimsRec.Multi_PSN_Claim__c == true && psnRec.Before_In_Service__c == true 
               && claimsRec.css_job__c == null){
                isMultiPSNEnabled = true;
            }
            claimsRec =[Select Id,Account__r.Type,Customer_Name__c,Location__c,Dealer_Service_Job__c,Location_Code__c,ReconEngineFlag__c,CSS_Job__c,CSS_Job__r.name,CSS_Job__r.createddate,Shop_Work_Order__c,LastModifiedDate,Name, ESN__c, createdDate,Region__c,Territory__c,CoverageResponse__c,Information_Only_Claim__c,Multi_PSN_Claim__c, 
                        (Select Id,Name,PSN__c,Service_Model__c,Application__c,License_Plate_State__c,ApplicationCode__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,
                         Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c,Calibration_After__c,Calibration_Before__c,Revision_After__c,Revision_Before__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                        from CSS_Claims__c where id= :WId];
            //Commented as per story The Office 164459
            /*
if(isMultiPSNEnabled){
/*system.debug('***MultiPSN***'+claimsRec.CSS_PSNs__r[0].Multi_PSN_Claim__c);
    system.debug('***BeforeinService***'+claimsRec.CSS_PSNs__r[0].Before_In_Service__c);
    system.debug('***FailureListSize***'+dispFailuresList.size());
     system.debug('***Job- Null***'+claimsRec.css_job__c);
    system.debug('***dispFailuresList***'+dispFailuresList);
system.debug('***Inside if***');
for(css_solution_component__c SC: dispFailuresList){
    if(SC.CSS_Account_Formula__c !=null && SC.CSS_Account_Formula__c !=''){
        system.debug('***Boolean Outisde Loop- False***'+OneaccCodeBool);
        system.debug('***Account Code Formula***'+SC.CSS_Account_Formula__c);
        if(accCodeSelected == SC.CSS_Account_Formula__c){
            //Commented as per story The Office 164459
            //OneaccCodeBool = 'true';
            system.debug('***Boolean Outisde Loop-True***'+OneaccCodeBool);
        }else {
            if(dispFailuresList.size() !=1){
                //Commented as per story The Office 164459
            //OneaccCodeBool = 'false';
            //break;
            }
        }
    }
}
}*/

            system.debug(' after ***selectedSysCode***'+selectedSysCode);
            // system.debug('***selectedCompCode***'+selectedCompCode);
            String selectedSysCodeDesc=selectedSysCode;
            String selectedCompCodeDesc=selectedCompCode;
            //system.debug('***selectedFailMode***'+selectedFailMode);
            String selectedFailModeDesc=selectedFailMode;
            String selectedFaultCodeDesc=selectedFaultCode;
            if(selectedSysCode.length()>2)
                selectedSysCode = selectedSysCode.substring(0,2);
            // system.debug('***selectedCompCode***'+selectedCompCode);
            if(selectedCompCode.length()>2)
                selectedCompCode = selectedCompCode.substring(0,2);
            if(selectedFailMode.length()>2)
                selectedFailMode=selectedFailMode.substring(0,2);
            if(selectedFaultCode!=null && selectedFaultCode.contains('-')){
                String[] sFaultCode=selectedFaultCode.split('-')  ;
                selectedFaultCode=sFaultCode[0];
            }
            //system.debug('***selectedCompCode***'+selectedCompCode);

            //check if the Failcode Account Code combination already Exists
            //string strFailCode = selectedSysCode+selectedCompCode+selectedFailMode; // kalpana: Commented as per the defect 145965
            string strFailCode = selectedSysCode+selectedCompCode;
            string accCodeEdit;
            if(accCodeReturned != '' && accCodeReturned != null)
                accCodeEdit = accCodeReturned;
            else
                accCodeEdit = accCodeSelected;
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
            //if(solCompExists.size()>0){
            if(solCompExists.size()>0 && selectedCompId==null){
                solCompExistsFlag = 'true';}
            // system.debug('Inside PopupSave**');
            CSS_Solution_Component__c solComp = new CSS_Solution_Component__c();
            /*CSS_Solution_Component__c solCompTobeUpdated = new CSS_Solution_Component__c();
solCompTobeUpdated = [select id,fail_code__c from css_solution_component__c where fail_code__c=:strFailCode and css_claims__C = :wid limit 1];*/
            // system.debug('selectedCompId'+selectedCompId);
            if(selectedCompId!=null && selectedCompId!='')
            {solComp.id=selectedCompId;}

            //else{solComp.id = null;}
            solComp.Name = selectedFName;
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
            else
                solComp.Failure_Date__c = psnRec.Failure_Date__c;

            solComp.AccountCode__c = compont.AccountCode__c;
            // solComp.AccountCodeEdit__c = compont.AccountCodeEdit__c;
            solComp.AccountCodeEdit__c = accCodeEdit;
            solComp.SystemCode_Desc__c = selectedSysCodeDesc;
            solComp.ComponentCode_Desc__c = selectedCompCodeDesc;
            system.debug('Anirudh****selectedSysCodeDesc'+selectedSysCodeDesc);
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
            if(compont.Part_Warranty_Start_Date__c != null)
                solComp.Part_Warranty_Start_Date__c = compont.Part_Warranty_Start_Date__c;
            else
                solComp.Part_Warranty_Start_Date__c = null;
            //solComp.Component_Code__c = selectedFaultCode; //Outof Scope
            //Start  code for passing selectedFaultCode value to object field on Fault_Code__c as per SIT story #150030,By -RAJESH 25th June 2018

            if(solComp.Part_Warranty_Start_Date__c!=null && solComp.Part_Warranty_Start_Date__c>System.TODAY())
            {
                checkPartsWarrStartDt = true;
            }
            else{
                checkPartsWarrStartDt = false;
            }

            //system.debug('checkPartsWarrStartDt Save--'+checkPartsWarrStartDt);

            solComp.Fault_Code__c = selectedFaultCode;
            // system.debug('**RAJESH+selectedFaultCode'+selectedFaultCode+'**Object Field Value**'+solComp.Fault_Code__c);
            //End 
            if(claimsRec.Information_Only_Claim__c == True){
                solComp.Pay_Code__c ='A';
            }
            else
            solComp.Pay_Code__c = payCodeSelected;
            system.debug('solComp.Pay_Code__c'+solComp.Pay_Code__c);
            system.debug('isDealer'+isDealer);
            system.debug('compToUpdate'+compToUpdate);
            if(isDealer){
                if(compToUpdate == null){
                    system.debug('inside if');
                    solComp.Pay_Code__c = 'D';
                }else if(compToUpdate !=null && (compToUpdate.Pay_Code__c==null || compToUpdate.Pay_Code__c.trim()=='') ){
                    system.debug('inside else');
                    solComp.Pay_Code__c = 'D';
                    
                    //solComp.Pay_Code__c = compToUpdate.Pay_Code__c;
                }
                else if(compToUpdate !=null && compToUpdate.Pay_Code__c !=null && compToUpdate.Pay_Code__c.trim() !=''){
                    solComp.Pay_Code__c = compToUpdate.Pay_Code__c;
                }
            } else {
                if(solComp.Pay_Code__c == null || solComp.Pay_Code__c == '')
                    solComp.Pay_Code__c = compToUpdate.Pay_Code__c;
            }
            solComp.Selected_Component__c = true;
            if(failureMeasure != null && failureMeasure != '')
                solComp.Failure_Measure__c=failureMeasure; 
            solcomp.Authorization_Number__c= AuthorizationNumber;
            solComp.Approval_Code__c = ApprovalCode;
            system.debug('prabhucustSelect'+custSelect);
            if(Possession != null){
                solComp.Customer_Take_Possession__c = Possession;//compont
                system.debug('prabhusolComp.Customer_Take_Possession__c'+solComp.Customer_Take_Possession__c);
            }
            //solComp.Customer_Take_Possession__c = custSelect;
            if(compToUpdate != null){
                solComp.CoveredLaborHrs__c = compToUpdate.CoveredLaborHrs__c;
                solComp.CoveredMealsLodgingAmt__c = compToUpdate.CoveredMealsLodgingAmt__c;
                solComp.CoveredOCAmount__c = compToUpdate.CoveredOCAmount__c;
                solComp.CoveredPartsQty__c = compToUpdate.CoveredPartsQty__c;
                solComp.CoveredTowingMiles__c = compToUpdate.CoveredTowingMiles__c;
                solComp.CoveredTravelLabor__c = compToUpdate.CoveredTravelLabor__c;
                solComp.CoveredTravelMiles__c = compToUpdate.CoveredTravelMiles__c;   
                solComp.CertificateNumber__c = compToUpdate.CertificateNumber__c;//This one we are going to pass the CAP Claims
                //solComp.CampaignPartsPercentage__c = compToUpdate.CampaignPartsPercentage__c; 
                solComp.CoveredTravelBaseFareAmt__c=compToUpdate.CoveredTravelBaseFareAmt__c;
            }
            //solComp.Unique_Component__c = selectedFName+selectedSysCode+selectedCompCode+selectedFailMode;
            system.debug('accCodeSelected**'+accCodeSelected);
            system.debug('selectedFaultCode**'+selectedFaultCode);
            if((accCodeSelected == 'EMISSION WARRANTY 70' || accCodeReturned == 'EMISSION WARRANTY 70') && (selectedFaultCode == null || selectedFaultCode == '')){
                FCErrorval = true;
                blankField = true;
                // system.debug('InsideEmission**');   
            }
            /*if(custSelect == null || custSelect == ''){
//if(custSelect != 'Yes' || custSelect != 'No'){
radioSelect = true;
}
else{
radioSelect = false;
}*/

            //Added Code for displaying error message based on Coverage Type (CAP) -- GAP Sprint 148103 Rajasekhar H       
            if(claimsRec.CoverageResponse__c != null && claimsRec.CoverageResponse__c != ''){
                basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                basicCoverageDetails = (CSS_getBasicCoverageResponseJ2A) JSON.deserialize(claimsRec.CoverageResponse__c, CSS_getBasicCoverageResponseJ2A.class);
                //system.debug('basicCoverageDetails coverage resp' + basicCoverageDetails.Header);
                for (CSS_getBasicCoverageResponseJ2A.extendedCoverageDetails covdet: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.extendedCoverageDetails) {
                    for(CSS_getBasicCoverageResponseJ2A.coverageDetails c: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails) {
                        if (accCodeSelected.contains('62') || accCodeSelected.contains('35') || accCodeSelected.contains('97') || accCodeSelected.contains('41')) {
                            //if (c.CoverageType == 'CAP' && accCodeSelected.contains('62') || accCodeSelected.contains('35') || accCodeSelected.contains('97') || accCodeSelected.contains('41')) {
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

            /*   system.debug('selectedFName**'+selectedFName); 
system.debug('selectedSysCode**'+selectedSysCode); 
system.debug('selectedCompCode**'+selectedCompCode); 
system.debug('selectedFailMode**'+selectedFailMode); 
system.debug('accCodeEdit**'+accCodeEdit); 
system.debug('payCodeSelected**'+payCodeSelected); 
system.debug('failureMeasure**'+failureMeasure); 
system.debug('AuthorizationNumber**'+AuthorizationNumber); 
system.debug('ApprovalCode**'+ApprovalCode); 
system.debug('compont.Part_Warranty_Start_Date__c**'+compont.Part_Warranty_Start_Date__c); 
system.debug('compont.Failure_Date__c**'+compont.Failure_Date__c); 
system.debug('selectedFName**'+selectedFName); 
system.debug('selectedFailureID**'+selectedFailureID); 
system.debug('selectedFName**'+selectedFName); 
system.debug('selectedFName**'+selectedFName); 

system.debug('selectedFailMode**'+selectedFailMode); */
            //if(selectedFName==' ' ||  selectedSysCode=='' || selectedCompCode=='' || selectedFailMode=='' || accCodeEdit=='' || payCodeSelected=='' || failureMeasure=='' || AuthorizationNumber=='' || ApprovalCode=='' || compont.Part_Warranty_Start_Date__c == null || compont.Failure_Date__c == null || compont.Failure_Point__c==null)
            if((selectedFName=='' || selectedFName==null) || (selectedSysCode=='' || selectedSysCode==null) || (selectedCompCode=='' || selectedCompCode==null) || 
               (selectedFailMode=='' || selectedFailMode==null) || (accCodeEdit=='' || accCodeEdit==null || accCodeEdit=='Select One') || (payCodeSelected=='' || payCodeSelected==null) ||  (claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One') || 
               (failureMeasure=='' || failureMeasure==null) || (AuthorizationNumber=='' || AuthorizationNumber==null) || (ApprovalCode=='' || ApprovalCode==null) || 
               compont.Part_Warranty_Start_Date__c == null || compont.Failure_Date__c == null || compont.Failure_Point__c==null || compont.Customer_Take_Possession__c==null)
            {

                /* if((claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One') && isDealer == false){
    blankField=true;
    system.debug('claimTypeIF');
}

else if((claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One') && isDealer==true){
    blankField=false;
    system.debug('claimTypeIF');
}*/
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
                    if((claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One')&& isDealer == false && !userRole.contains('Factory')){
                        blankField=true;
                        system.debug('claimTypeIF1');
                    }
                    /*else if((claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One')&& isDealer==true){
        blankField=false;
        system.debug('claimTypeIF1');
    }*/
                    //IF((CONTAINS(accCodeEdit,'62') || CONTAINS(accCodeEdit,'35') || CONTAINS(accCodeEdit,'97') || CONTAINS(accCodeEdit,'41')){
                    If(accCodeEdit.contains('62') || accCodeEdit.contains('35') || accCodeEdit.contains('97') || accCodeEdit.contains('41')) 
                    {   
                        system.debug('insideprabhu');
                        if((claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One') && claimsRec.Account__r.Type.contains('Distributor Account')){
                            blankField=true;
                            system.debug('claimTypeIF1');
                        }
                        If(((accCodeEdit.contains('62') || accCodeEdit.contains('35') || accCodeEdit.contains('97') || accCodeEdit.contains('41')) && isDealer == false)
                           || ((accCodeEdit.contains('62') || accCodeEdit.contains('97')) && isDealer == true)){
                            if(solComp.Customer_Take_Possession__c==null || solComp.Customer_Take_Possession__c=='' || Possession==''){
                                system.debug('insideposses');
                                radioSelect=true;
                                //blankField = true;
                            }
                        }
                        if((compont.Part_Warranty_Start_Date__c == null || compont.Failure_Point__c==null))
                        { blankField=true;
                         system.debug('InsidePartsIF1');
                        }
                        if(compont.Failure_Date__c == null &&  psnRec.Failure_Date__c == null){
                            blankField=true;
                            system.debug('InsidePartsIF2');
                        }

                    }
                    //Added  "coverageType=='OTH'" in else if condition for validatting ApprovalCode as per Simpsons document #128755, By -RAJESH 30th May 2018
                    else if((coverageType=='POL' || coverageType=='OTH') && coverageFound=='false' && accCodeEdit!=null && accCodeEdit!='')
                    { 
                        system.debug('POL ElseIF and OTH elseif ');
                        if((AuthorizationNumber=='' || AuthorizationNumber==null) || (ApprovalCode=='' || ApprovalCode==null)|| ((payCodeSelected=='' || payCodeSelected==null)&& isDealer==false)){
                            //if((ApprovalCode=='' || ApprovalCode==null) || (payCodeSelected=='' || payCodeSelected==null)){
                            if(((ApprovalCode=='' || ApprovalCode==null) ||payCodeSelected=='' || payCodeSelected==null) && isDealer==true){
                                blankField=false;
                            }else if((ApprovalCode=='' || ApprovalCode==null) || payCodeSelected=='' || payCodeSelected==null){
                                blankField=true;
                            }
                        }
                    }
                    else if((coverageType!='POL' || coverageType=='OTH') && coverageFound=='false' && accCodeEdit!=null && accCodeEdit!=''){
                        system.debug('NON POL and NON OTH');
                        compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(solComp.Failure_Point__c),solComp.Failure_Measure__c,psnRec.ApplicationCode__c,claimsRec.CSS_PSNs__r[0].Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true);
                        system.debug('compToUpdate.AccountCodeEdit__c'+compToUpdate.AccountCodeEdit__c);
                        if(compToUpdate.AccountCodeEdit__c != null && compToUpdate.AccountCodeEdit__c != ' '){
                            system.debug('**********Entered compToUpdate**************'+compToUpdate.AccountCodeEdit__c);
                            system.debug('**********errornotcovfound**************'+errornotcovfound);
                            coverageFound = 'true';
                            errornotcovfound = false;

                        }
                        else{
                            coverageFound = 'false';
                            errornotcovfound = true;
                            system.debug('**********errornotcovfound**************'+errornotcovfound);

                        }
                        if((payCodeSelected=='' || payCodeSelected==null) && isDealer==true && blankField !=true){
                            blankField=false;
                        }else if(payCodeSelected=='' || payCodeSelected==null){
                            blankField=true;
                        }
                    }
                    //Condition for if check coverage is not found, user select the account code and type OTH or POL allow to save the failure
                    /*if((coverageType=='POL' || coverageType=='OTH') && coverageFound=='false' && accCodeEdit!=null && accCodeEdit!=''){
                        system.debug('**********Entered into POL OTH**************');
                        blankField=false;

                    }
                    else if((coverageType!='POL' || coverageType!='OTH') && coverageFound=='false' && accCodeEdit!=null && accCodeEdit!=''){
                     system.debug('**********Entered into Non ----POL OTH**************');
                        compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,(claimsRec.Location_Code__c).right(5),psnRec.Failure_Date__c,string.valueof(solComp.Failure_Point__c),solComp.Failure_Measure__c,psnRec.ApplicationCode__c,claimsRec.CSS_PSNs__r[0].Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', '',true);
                        system.debug('compToUpdate.AccountCodeEdit__c'+compToUpdate.AccountCodeEdit__c);
                        if(compToUpdate.AccountCodeEdit__c != null && compToUpdate.AccountCodeEdit__c != ' '){
                            system.debug('**********Entered compToUpdate**************'+compToUpdate.AccountCodeEdit__c);
                            system.debug('**********errornotcovfound**************'+errornotcovfound);
                            coverageFound = 'true';
                            errornotcovfound = false;

                        }
                        else{
                            coverageFound = 'false';
                            errornotcovfound = true;
                            system.debug('**********errornotcovfound**************'+errornotcovfound);

                        }
                    }*/


                    /* if(((AuthorizationNumber=='' || AuthorizationNumber==null) || (ApprovalCode=='' || ApprovalCode==null)) && (compont.Part_Warranty_Start_Date__c != null && ((compont.Failure_Date__c != null && psnRec.Failure_Date__c == null) || (compont.Failure_Date__c == null && psnRec.Failure_Date__c != null)) && compont.Failure_Point__c!=null))
{ blankField = false;
system.debug('First If');
}
else if(((AuthorizationNumber!='' && AuthorizationNumber!=null) && (ApprovalCode!='' && ApprovalCode!=null)) && (compont.Part_Warranty_Start_Date__c == null || compont.Failure_Date__c == null || compont.Failure_Point__c==null))
{ blankField = false;
system.debug('Else If');
}
/* else if(((AuthorizationNumber=='' || AuthorizationNumber==null) && (ApprovalCode=='' || ApprovalCode==null)) && (compont.Part_Warranty_Start_Date__c == null || compont.Failure_Date__c == null || compont.Failure_Point__c==null))
{ blankField = false;}*/

                    // else if(claimTypeSelected!='Select One' || claimTypeSelected!='' || claimTypeSelected!=null){blankField=false;}

                    /* else if((AuthorizationNumber=='' || AuthorizationNumber==null) && (ApprovalCode=='' || ApprovalCode==null) && (compont.Part_Warranty_Start_Date__c == null || compont.Failure_Date__c == null || compont.Failure_Point__c==null))
{ 
blankField = true;
system.debug('InsideELSE');
}*/
                }

                else {blankField=true;
                      system.debug('ELSE');}
                system.debug('blankField**'+blankField);


            }
            system.debug('FCErrorval**'+FCErrorval);
            system.debug('solComp**'+solComp);
            system.debug('solComp**'+solComp.id);
            system.debug('solCompExists**'+solCompExists);
            system.debug('solCompExistsFlag**'+solCompExistsFlag);
            // if(solComp != null && (FCErrorval == false && solCompExists == null)){
            //if(selectedCompId == null){ // To Cover SAve from Add POP
            system.debug('custSelect-->'+custSelect);

            /*if(radioYes == '' || radioYes == null){
radioSelect = true;
}*/
            system.debug('prabhusolcomp'+solComp);
            system.debug('FCErrorval>>:'+FCErrorval+' solCompExistsFlag>>:'+solCompExistsFlag+' blankField>>:'+blankField+' invalidAppCode>:'
                         +invalidAppCode+' OneaccCodeBool>>:'+OneaccCodeBool+' checkPartsWarrStartDt>>:'+checkPartsWarrStartDt+' accCodeSelected>>>:'+accCodeSelected);
            system.debug('*****claimsRec.Multi_PSN_Claim__c>>:'+claimsRec.Multi_PSN_Claim__c);
            system.debug('*****solComp>:'+solComp);
            system.debug('*****OneaccCodeBool>:'+OneaccCodeBool);
            // if(solComp != null && (FCErrorval == false && solCompExistsFlag !='true' && blankField == false && invalidAppCode == false && OneaccCodeBool == 'true' && checkPartsWarrStartDt == false)){ //radioSelect == false && 
            if( (solComp != null && (errornotcovfound==false && radioSelect== false && FCErrorval == false && solCompExistsFlag !='true' && blankField == false && invalidAppCode == false &&  checkPartsWarrStartDt == false 
                                     && (claimsRec.Multi_PSN_Claim__c == false || claimsRec.Multi_PSN_Claim__c == null))) 
               //||radioSelect== false && (solComp != null && (FCErrorval == false && solCompExistsFlag !='true' && blankField == false && invalidAppCode == false &&  checkPartsWarrStartDt == false 
               //&& OneaccCodeBool == 'true'))){ //radioSelect == false && OneaccCodeBool == 'true' &&
               || (solComp != null && (errornotcovfound==false && radioSelect== false && FCErrorval == false && solCompExistsFlag !='true' && blankField == false && invalidAppCode == false &&  checkPartsWarrStartDt == false 
                                      ))){

                if(isMultiPSNEnabled){
                    //if(accCodeSelected == 'New Engine Warranty 67'){
                    if(accCodeSelected.contains('New Engine Warranty 67')){
                        system.debug('before upsert.inside if..');
                        Boolean flag = DeletePopupAC();
                        system.debug('***8flag***'+flag);
                        if(flag){
                            showFailurePopup = true;
                            return null;
                        }
                        system.debug('before upsert...');
                        upsert solComp solComp.id;
                    }else{
                        system.debug('**8inside else...');
                        isMultiPSNErrorExist = true;
                        return null;
                    }
                }else{
                    ///if(solComp != null && OneaccCodeBool == false){
                    //upsert solComp solComp.Unique_Component__c;
                    system.debug('*****before saving solComp************');  
                    upsert solComp solComp.id;
                    system.debug('update'+solComp);
                }

                //update RevisionBefore/After on PSN
                if(selectedSysCode!= null && selectedSysCode!= '' && (selectedSysCode.startsWith('EQ') || selectedSysCode.startsWith('WE'))) {
                    update psnRec;
                }


                //CSS_FN_SRT.FetchGSQParts(solComp.id,Wid);
                // }
                /*  else // To Cover Save from Edit POP
// {
if(solComp != null && (FCErrorval == false && blankField == false && invalidAppCode == false)){
update solComp ;
}
//  }*/

                //DELETE  99SRT record  START 
                List<CSS_Solution_Component__c> solutionComponentList = new List<CSS_Solution_Component__c>();
                Set<String> failAcocuntCodeSet = new Set<String>();

                //Fetching data from CSS Solution Components.
                for(CSS_Solution_Component__c solCom : [select Id, CSS_Account_Formula__c, FailCode_Formula__c, Selected_Component__c
                                                        From CSS_Solution_Component__c
                                                        where Selected_Component__c = true AND CSS_Account_Formula__c != null AND FailCode_Formula__c != null
                                                        AND CSS_Claims__c=:Wid]) {
                    if(solCom.CSS_Account_Formula__c != null && solCom.FailCode_Formula__c != null) {
                        string s = solCom.FailCode_Formula__c + ':' + solCom.CSS_Account_Formula__c;
                        failAcocuntCodeSet.add(s);

                    }
                }
                system.debug('failAcocuntCodeSet** '+failAcocuntCodeSet);
                String key;
                List<CSS_SRT__c> srtToDelete = new List<CSS_SRT__c>();
                //fetching existing 99SRT records
                if(failAcocuntCodeSet.size()>0){
                    for(CSS_SRT__c srt : [SELECT Id,Account_Code_Description__c,Fail_Code_Description__c FROM CSS_SRT__c                 
                                          WHERE CSS_Claims__c=:Wid AND 
                                          Type__c='99Time'  AND
                                          Account_Code_Description__c != null AND Fail_Code_Description__c != null]){
                        key = srt.Fail_Code_Description__c +':' + srt.Account_Code_Description__c;
                        system.debug('key** '+key);
                        if(!failAcocuntCodeSet.contains(key)){
                            system.debug('srtToDelete** ');
                            srtToDelete.add(srt);    
                        }
                    }
                }
                system.debug('srtToDelete** '+srtToDelete);
                if(srtToDelete.size()>0){
                    delete srtToDelete;
                }
                //Delete the 99SRT record END

                //Calling GSQ Parts.
                CSS_FN_SRT.FetchGSQParts(solComp.id, Wid);

                system.debug('Upsert is done Successfully**'); 
                system.debug('SolComp**'+solComp);
                pageRef = new pageReference('/apex/CG_ClaimsFC?id='+wid); 
                pageRef.setRedirect(true);
                //return pageRef;

            }

            else {   pageRef  = null;}
            //clearPopup();

        }catch(Exception e)  {
            system.debug('EXCEPTION of PopupSave method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            clearPopup();
        }    
        //onChangeofAppCode();
        return PageRef;
    }
    public void getAccCodeList(){
        string orgtype=css_utility.getOrgType(userinfo.getUserId());
        List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
        if (orgtype=='DISTR'){
            system.debug('inside distru');
            jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' order by Attribute2__c asc];
        }
        else
            jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Attribute15__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];

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
        clearPopup();
        //DeletePopupAC();
        if((compont.CSS_Account_Formula__c != null && compont.CSS_Account_Formula__c != '') && (compont.AccountCodeEdit__c == null || compont.AccountCodeEdit__c == ''))
            accCodeWS = compont.CSS_Account_Formula__c.Trim();
        if(compont.Parts_Warranty__c != null && compont.Parts_Warranty__c != '')
            partsWarranty = compont.Parts_Warranty__c;
        // if(compont.Customer_Take_Possession__c != null && compont.Customer_Take_Possession__c != '')
        // custSelect = compont.Customer_Take_Possession__c;
        if(compont.Failure_Measure__c != null && compont.Failure_Measure__c != '')
            failureMeasure = compont.Failure_Measure__c;
        //coverageType='';
    }

    public void checkPartCoverage(){
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
            css_solution_component__c solComp = new css_solution_component__c();
            try{
                solcomp = [select id,name,Failure_Point__c,Failure_Measure__c,Part_Warranty_Start_Date__c,Selected_Component__c,Customer_Take_Possession__c from css_solution_component__c where name=:selectedFName and Component_Code__c=:selectedCompCode and System_Code__c=:selectedSysCode and Failure_Mode__c=:selectedFailMode limit 1];
            }
            catch(Exception ex){
                compToUpdate.AccountCodeEdit__c = ' '; // To avoid Blue Screen Error
            }
            if(claimsRec.ReconEngineFlag__c!=null && claimsRec.ReconEngineFlag__c=='y'){
                System.debug('entered in to reconengine'+claimsRec.ReconEngineFlag__c);
                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,claimsRec.Location_Code__c,failureDate,string.valueof(compont.Failure_Point__c),compont.Failure_Measure__c,psnRec.ApplicationCode__c,compont.Part_Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,selectedFaultCode,'98',solComp.id,solComp.Selected_Component__c,'',partsWarranty,'Second Call', '',true);
            }
            else{
                System.debug('entered in else to reconengine'+claimsRec.ReconEngineFlag__c);
                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(psnRec.PSN__c,claimsRec.Location_Code__c,failureDate,string.valueof(compont.Failure_Point__c),compont.Failure_Measure__c,psnRec.ApplicationCode__c,compont.Part_Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,selectedFaultCode,'',solComp.id,solComp.Selected_Component__c,'',partsWarranty,'Second Call', '',true);   
            }

            system.debug('AccCodeEdit**'+compToUpdate.AccountCodeEdit__c);
            //compToUpdate.CoveredLaborHrs__c = '9999999999';
            if(compToUpdate.AccountCode_Call_Status__c == 'Failure'){
                warrantyCompFailure = true;
                //partCoverageFound ='false';
            }
            else{
                //partCoverageFound ='true';
                warrantyCompFailure = false;
                if((compToUpdate.CoveredLaborHrs__c != '' && compToUpdate.CoveredLaborHrs__c != '0') || 
                   (compToUpdate.CoveredMealsLodgingAmt__c != '' && compToUpdate.CoveredMealsLodgingAmt__c != '0') || 
                   (compToUpdate.CoveredOCAmount__c != '' && compToUpdate.CoveredOCAmount__c != '0') || 
                   (compToUpdate.CoveredPartsQty__c != '' && compToUpdate.CoveredPartsQty__c != '0') || 
                   (compToUpdate.CoveredTowingMiles__c != '' && compToUpdate.CoveredTowingMiles__c != '0') || 
                   (compToUpdate.CoveredTravelLabor__c != '' && compToUpdate.CoveredTravelLabor__c != '0') || 
                   (compToUpdate.CoveredTravelMiles__c != '' && compToUpdate.CoveredTravelMiles__c != '0')){
                    partCoverageFound = 'true';
                    compToUpdate.AccountCodeEdit__c = compToUpdate.AccountCodeEdit__c.trim();
                    if(compToUpdate.AccountCodeEdit__c != '')
                        accCodeSelected = compToUpdate.AccountCodeEdit__c;
                }
                else{
                    system.debug('in else condition');
                    partCoverageFound = 'false';
                    //if(custSelect == 'Yes'){
                    compToUpdate.AccountCodeEdit__c = '';
                    //}
                    /*else{
if(partsWarranty == 'New Parts Warranty'){
compToUpdate.AccountCodeEdit__c = 'PARTS WARRANTY 35';
}
else{
compToUpdate.AccountCodeEdit__c = 'RECON STOCK PART 41';
}
}*/
                }
            }

            /*if(compToUpdate != null) //kalpana story#117207
update compToUpdate;*/

        }
        catch(Exception ex){
            partCoverageFound ='false';
            system.debug('Catch Check Coverage'+ ex.getmessage()+' '+ex.getLineNumber());
        }
    }
    public void clearPopup(){
        compont.AccountCode__c = null;
        compont.AccountCodeEdit__c = null;
        partsWarranty = '';
        custSelect = '';
        errornotcovfound = false;
        compont.Part_Warranty_Start_Date__c = null;
        compont.Failure_Date__c = null;
        failureMeasure = '';
        compont.Failure_Point__c = null;
        compont.Authorization_Number__c = null;
        compont.Approval_Code__c = null;
        compont.Pay_Code__c = null;
        coverageFound = '';
        solCompExistsFlag = '';
        partCoverageFound = '';
        claimTypeSelected = 'Select One';
        Possession = '';
        getCoverageType();
    }
    public void getCoverageType(){
        system.debug('Inside Method ');
        system.debug('**8accCodeSelected**'+accCodeSelected);
        if(accCodeSelected != null){
            try{
                system.debug('Inside if Method ');
                coverageType = [select Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' and Account_Code__c = :accCodeSelected].Attribute1__c;
                system.debug('CoverageType**'+coverageType);
            }
            catch(exception ex){
                coverageType = '';
            }
        }
        else
            coverageType = '';
    }
    public List<SelectOption>  getclaimTypes(){
        claimTypes = new List<SelectOption>();
        system.debug('Location***'+claimsRec.Location_Code__c);
        claimTypes = CG_BL_Claims.getClaimType(Wid,claimsRec.Location_Code__c,'ClaimsFC');
        system.debug('ClaimTypes***'+claimTypes);

        //claimTypes.sort();
        return claimTypes;
        /*list<string> templststrclaimType = new list<string>();
list<string> lstClaimType
List<CSS_JobEventTemporary__c> jobEventTemp = [SELECT Id, Attribute1__c, Attribute3__c,Reason__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c = 'Claimtype' and Key__c = :claimsRec.Location_Code__c];
if(jobEventTemp.size() > 0){
system.debug('jobEventTemp.size()-->'+jobEventTemp.size());
system.debug('jobEventTempData-->'+jobEventTemp);
claimTypes = new List<SelectOption>();
claimTypes.add(new SelectOption('Select One','Select One'));

for(CSS_JobEventTemporary__c j : jobEventTemp){
string claimTypeReason = j.Reason__c;
lststrclaimType = claimTypeReason.split(',');
if(lststrclaimType.size>0)
{
for(integer i=0;i<lststrclaimType.size();i++)
{
system.debug('ClaimType**'+lststrclaimType[i].left());
string s = lststrclaimType[i].left();

claimTypes.add(new SelectOption(s,s));

}
}
}*/
    }
}