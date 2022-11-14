/**********************************************************************
Name: CG_CL_ClaimsSRTEditPopUp
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This class is used for SRT Edit Popup functionalities
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                    DATE                DETAIL                                 
1.0     Surender M/Arpita        04/16/2018     INITIAL DEVELOPMENT & Implementation of SRT Edit Popup functionalities
***********************************************************************/
public class CG_CL_ClaimsSRTEditPopUp{

    public string searchDiagValue{get;set;}
    public Boolean selectedAccess{get;set;}
    public Boolean selectedAdmin{get;set;}
    public Boolean selectedDiag{get;set;}
    public Boolean selectedRepair{get;set;}
    public String selectedPickVal{get;set;}
    public String claimsId;
    public String accordionType{get;set;}
    public string pgName{get;set;}
    public boolean chkReqField{get;set;}
    public String seleFailCode{get;set;}

    public String selectedFailCode{get;set;}
    public integer selectedSRTId{get;set;}
    public List<SelectOption> failCodes{get;set;}
    //public List<SelectOption> accCodes{get;set;}

    public List<CSS_srt__c> lstDisplaySRT{get;set;}
    public List<CSS_srt__c> lstFilteredSRT{get;set;} //main wrapper list
    public List<CSS_srt__c> lstFilteredSRT2; 
    public List<srtWrapperClass> lstSelectedSRTWrapper{get;set;} //Selected wrapper list
    public List<srtWrapperClass> lstSelectedSRTWrapper2{get;set;} //Selected wrapper list
    public Integer removedRowNo{get;set;}
    public String Typ;
    public Boolean displayPopup{get;set;}
    Transient List<CSS_Srt__c> additionalSRTList = new List<CSS_Srt__c>();
    public boolean excessRecFlag{get;set;}
    public boolean noSearchResultDiagFlag{get;set;}
    Map<String,CSS_srt__c> srtMap = new Map<String,CSS_srt__c>();
    Set<Id> srtIDs = new Set<Id>();
    Map<String,CSS_srt__c> srtRemoveMap = new Map<String,CSS_srt__c>();
    List<CSS_Srt__c> existSRTList = new List<CSS_Srt__c>();
    public Map<String,Set<String>> failAccountCodeMap{get;set;}
    //Map<String,srtWrapperClass> srtWrapperSave = new Map<String,srtWrapperClass>();
    Boolean removeRow;
    Integer i=0;
    Set<String> removedKeySet;
    Set<String> removedSRTCode;
    public Boolean isAutomatedClaim{get;set;}
    public String jobId{get;set;}
    public String claimAccessCode{get;set;}
    public List<CSS_JobEventTemporary__c> jobEventLst;
    public String coverageType;
    public boolean isDealer;
    public Map<String,Set<String>> srtIdFcodeAssignmentMap{get;set;}
    public Map<String,Set<String>> srtIdFcodeAssignmentMapRep{get;set;}
    public Boolean srtNotAllowedErr{get;set;}
    String srtAccCode;
    public Map<String, String> failCodeGSQSRTMap = new Map<String, String>();
    public Boolean GSQErrorExists{get;set;}
    public Set<String> SRTID;
    public Boolean dupSRTFound{get;set;}
    public List<CSS_Claims__c> claimsRecList{get;set;}

    public Static Boolean serviceFailed{get;set;} //Added as part of the story GSSC-82
    public Static CSS_Integration_Error__c errorDetail{get;set;} //Added as part of the story GSSC-82
    public CG_CL_ClaimsSRTEditPopUp()
    {
        try{
            errorDetail = new CSS_Integration_Error__c(); //Added as part of the story GSSC-82
            serviceFailed = false; //Added as part of the story GSSC-82
            GSQErrorExists = false;
            failCodeGSQSRTMap = new Map<String, String>();
            isAutomatedClaim = false;
            removedKeySet = new Set<String>();
            removedSRTCode = new set<string>();
            failAccountCodeMap = new  Map<String, Set<String>>();
            failCodes =  new List<SelectOption>();
            chkReqField = false;
            lstSelectedSRTWrapper = new list<srtWrapperClass>();
            lstSelectedSRTWrapper2 = new list<srtWrapperClass>();
            displayPopup = true;
            removeRow=false;
            claimsId=ApexPages.CurrentPage().getParameters().get('ClaimsId');
            Typ=ApexPages.CurrentPage().getParameters().get('type');
            accordionType=ApexPages.CurrentPage().getParameters().get('type');
            pgName = ApexPages.CurrentPage().getParameters().get('pgName');
            system.debug('claimsId*'+claimsId);
            system.debug('accordionType>>>:'+accordionType);
            system.debug('pgName*'+pgName);
            dupSRTFound = false;
            css_header_nav__c rswBotton = css_header_nav__c.getInstance(UserInfo.getUserId());
            // isDealer = rswBotton.RSWButtonEnable__c;

            lstDisplaySRT = new List<css_srt__c>();
            if(ClaimsId != null){
                claimsRecList = new List<CSS_Claims__c>([Select Id ,Name, AccessCode__c,Total_PSN_Count__c, CSS_Job__c, Account__r.Type from CSS_Claims__c where Id=:ClaimsId]); //removed CSS_Job__c !=null and  where clause and added in below if condition
                if(claimsRecList !=null && claimsRecList.size()>0){
                    if(claimsRecList[0].CSS_Job__c !=null){
                        isAutomatedClaim = true;
                        jobId = claimsRecList.get(0).CSS_Job__c;
                        system.debug('jobId>>>:'+jobId);
                    }
                    claimAccessCode = claimsRecList.get(0).AccessCode__c;
                    boolean DealerTypeFlag = CSS_utility.getAccounttype(claimsRecList.get(0).Account__r.Type);               
                    system.debug('DealerTypeFlag-->'+DealerTypeFlag);
                    if(DealerTypeFlag== true){
                        isDealer = true;
                    }
                    else{
                        isDealer = false;
                    }
                }

                jobEventLst = [select Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c,Account_Code__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes'];
                system.debug('jobEventLst*size***'+jobEventLst.size());

                //failCodes = getfailcodeDropDown(); //Commented as part of the story GSSC-298
                loadSavedSRTs();
                lstDisplaySRT = CSS_WS_SRT.getAllClaimsDigRepSRTs(claimsId,'');
                system.debug('lstDisplaySRT>>:'+lstDisplaySRT);
                system.debug('lstDisplaySRT size>>:'+lstDisplaySRT.size());
                for(integer i=0;i<lstDisplaySRT.size();i++){
                    system.debug('***accescodeA'+lstDisplaySRT[i].SRT_ID__c);
                    //system.debug('***srttime'+lstDisplaySRT[i].SRT_Time__c);
                    system.debug('***srttype'+lstDisplaySRT[i].SRT_Type__c);
                    system.debug('***type'+lstDisplaySRT[i].Type__c);
                }

                //SRT Groups validation code #162539
                GSQSRTMapPrepare();

                /*List<CSS_SRT__c> srtlstUI = new List<CSS_SRT__c>();
                srtlstUI = [select Id,SRT_ID__c, Assignment__c, Component_Id__c, FailCode__c, Component_Id__r.Type__c, SRT_Title__c,SRT_Quantity__c,Additional_SRT_Calculated__c,SRT_Time__c,Access_Code__c,
                            SRT_Hours_Percentage__c,Adjustment_Reason__c,Job_Order__c,SRT_Select__c,isPerformed__c,srt_category__c,type__c, Extended_Hours__c,SRT_Estimate__c from CSS_SRT__c where 
                            ((Type__c = 'Field Action') OR (Type__c = 'Repair' AND Component_Id__c != null)) and CSS_Claims__c =:claimsId];
                system.debug(srtlstUI.size());*/ // Variable seems to be not used anywhere, hence commenting
                srtIdFcodeAssignmentMap = new Map<String,Set<String>>();
                srtIdFcodeAssignmentMapRep = new Map<String,Set<String>>();
                List<CSS_Solution_Component__c> failureAndCamp = new List<CSS_Solution_Component__c>();
                failureAndCamp = [SELECT Id, SysCodeAndCompCode__c, Type__c, (SELECT Id, SRT_ID__c, Assignment__c, Component_Id__c, FailCode__c FROM CSS_SRTs__r) FROM CSS_Solution_Component__c WHERE CSS_Claims__c =:claimsId];
                system.debug('failureAndCamp '+failureAndCamp);
                for(CSS_Solution_Component__c sc : failureAndCamp){
                    for(CSS_SRT__c srt : sc.CSS_SRTS__r){
                        if(srt.Assignment__c == 'NOT CLAIMABLE'){
                            Set<String> lstSRT = new Set<String>();
                            if((sc.Type__c != null && sc.Type__c != '') && (sc.Type__c.equalsIgnoreCase('Campaign') || sc.Type__c.equalsIgnoreCase('ATC') || sc.Type__c.equalsIgnoreCase('TRP'))){
                                if(!srtIdFcodeAssignmentMap.containsKey(sc.SysCodeAndCompCode__c)){
                                    lstSRT.add(srt.SRT_ID__c);
                                    srtIdFcodeAssignmentMap.put(sc.SysCodeAndCompCode__c,lstSRT);
                                }
                                else{
                                    lstSRT = srtIdFcodeAssignmentMap.get(sc.SysCodeAndCompCode__c);
                                    lstSRT.add(srt.SRT_ID__c);
                                    srtIdFcodeAssignmentMap.put(sc.SysCodeAndCompCode__c,lstSRT);
                                }
                            }
                            else{
                                if(!srtIdFcodeAssignmentMapRep.containsKey(sc.SysCodeAndCompCode__c)){
                                    lstSRT.add(srt.SRT_ID__c);
                                    srtIdFcodeAssignmentMapRep.put(sc.SysCodeAndCompCode__c,lstSRT);
                                }
                                else{
                                    lstSRT = srtIdFcodeAssignmentMapRep.get(sc.SysCodeAndCompCode__c);
                                    lstSRT.add(srt.SRT_ID__c);
                                    srtIdFcodeAssignmentMapRep.put(sc.SysCodeAndCompCode__c,lstSRT);
                                }
                            }
                        }
                    }
                }
            }
        }
        catch(Exception ex){
            System.debug('in catch of CG_CL_ClaimsSRTEditPopUp constructor>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage()); 

        }    
    }

    public void loadSavedSRTs(){
        try{


            system.debug('accordionType--'+accordionType);
            removedKeySet = new Set<String>();
            removedSRTCode=new set<string>();
            lstSelectedSRTWrapper = new list<srtWrapperClass>();
            //load existing saved SRTs
            //existSRTList = new List<CSS_Srt__c>([select id, SRT_ID__c,SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and SRT_Category__c=:accordionType]);
            //if(isAutomatedClaim == true){// && isDealer == true
            system.debug('isAutomatedClaim-->'+isAutomatedClaim);
            system.debug('isDealer-->'+isDealer);
            if((isAutomatedClaim == true && isDealer == true) || (isAutomatedClaim == false && isDealer == true) || (isAutomatedClaim == false && isDealer == false)){ 
                system.debug('Inside IF');
                if(accordionType == 'AdditionalDiag'){
                    //existSRTList = new List<CSS_Srt__c>([select id, SRT_ID__c, Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and (Type__c = 'Diagnosis' OR Type__c = 'Diag Access' OR SRT_Category__c=:accordionType)]);
                    //existSRTList = new List<CSS_Srt__c>([select id, SRT_ID__c, IsPopUpSRT__c, Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and SRT_ID__c !='0' and (((Type__c = 'Diagnosis' OR Type__c = 'Diag Access') AND SRT_Category__c NOT IN('Campaign','ATC','TRP','AdditionalRep')) OR SRT_Category__c=:accordionType)]);
                    // existSRTList = new List<CSS_Srt__c>([select id, SRT_ID__c, IsPopUpSRT__c,Assignment__c, Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and SRT_ID__c !='0' and (isPerformed__c = true OR SRT_AccessiblityCheck__c=true) and (((Type__c = 'Diagnosis' OR Type__c = 'Diag Access')  AND (SRT_Category__c NOT IN('Campaign','ATC','TRP','AdditionalRep') OR SRT_Category__c=:accordionType)) OR (SRT_Category__c = 'AdditionalDiag' OR Assignment__c = 'DIAGNOSTIC'))]);
                    // Defect 191763 Removed Assignment == '' OR Assignment == null condition as non srts were being displayed.
                   // existSRTList = new List<CSS_Srt__c>([select id, SRT_ID__c,Flex_Flag__c, ECM_Flag__c, isUserEntered__c,SRT_Warrantable__c,IsPopUpSRT__c,Assignment__c, Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId AND SRT_ID__c !='0' AND (isPerformed__c = true OR SRT_AccessiblityCheck__c=true) and (((Type__c = 'Diagnosis' OR Type__c = 'Diag Access')  AND (SRT_Category__c NOT IN('Campaign','ATC','TRP','AdditionalRep') OR SRT_Category__c=:accordionType)) or Assignment__c = 'DIAGNOSTIC')]); //Added SRT_Category__c condition for Defect GSSC-555
                   existSRTList = new List<CSS_Srt__c>([select id, SRT_ID__c,Flex_Flag__c, ECM_Flag__c, isUserEntered__c,SRT_Warrantable__c,IsPopUpSRT__c,Assignment__c, 
                                                          Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, 
                                                          SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,
                                                          Access_Code_R__c,SRT_Time__c,Access_Code__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c 
                                                          where CSS_Claims__c =: claimsId AND SRT_ID__c !='0' 
                                                          AND (isPerformed__c = true OR SRT_AccessiblityCheck__c=true) 
                                                          and ((Type__c = 'Diagnosis' OR Type__c = 'Diag Access')  OR (Assignment__c='DIAGNOSTIC')
                                                                OR (SRT_Category__c NOT IN('Campaign','ATC','TRP','AdditionalRep') AND SRT_Category__c=:accordionType))]); //Added OR in between (Type and SRT_Category__c)condition for Defect GSSC-560
                    system.debug('Inside existSRTList diag'+existSRTList);
                } else if(accordionType == 'AdditionalRep')
                    existSRTList = new List<CSS_Srt__c>([select id,SRT_ID__c,IsPopUpSRT__c,Flex_Flag__c,ECM_Flag__c,isUserEntered__c,SRT_Warrantable__c,Assignment__c, Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and SRT_ID__c !='0' and Assignment__c != 'NOT CLAIMABLE' and (isPerformed__c = true OR SRT_AccessiblityCheck__c=true) and(((((Type__c = 'Repair' OR Type__c = 'Repair Access') AND Assignment__c != 'DIAGNOSTIC')) AND SRT_Category__c NOT IN('Campaign','ATC','TRP','AdditionalDiag')) OR SRT_Category__c=:accordionType)]);// Query modified as part of defect 191727- Excluded assignment diagnostic values as they are being shown from diagnostic accordion
                else if(accordionType == 'Campaign')
                    existSRTList = new List<CSS_Srt__c>([select id,SRT_ID__c,IsPopUpSRT__c,Flex_Flag__c,ECM_Flag__c,isUserEntered__c,SRT_Warrantable__c,Assignment__c, Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and SRT_ID__c !='0' and Assignment__c != 'NOT CLAIMABLE' and (isPerformed__c = true OR SRT_AccessiblityCheck__c=true)and (srt_type__c = 'Campaign' OR SRT_Category__c=:accordionType)]);//and Component_Id__r.Selected_Component__c=true
                else if(accordionType == 'TRP')
                    //existSRTList = new List<CSS_Srt__c>([select id, SRT_ID__c, Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and (srt_type__c = 'TRP' OR srt_type__c = 'Field Action' OR srt_type__c = 'Field Action Access' OR SRT_Category__c=:accordionType)]);
                    existSRTList = new List<CSS_Srt__c>([select id,SRT_ID__c,IsPopUpSRT__c,isUserEntered__c,Flex_Flag__c,ECM_Flag__c,SRT_Warrantable__c,Assignment__c, Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and SRT_ID__c !='0' and Assignment__c != 'NOT CLAIMABLE' and (isPerformed__c = true OR SRT_AccessiblityCheck__c=true) and (srt_type__c = 'TRP' OR SRT_Category__c=:accordionType)]); 
                else if(accordionType == 'ATC')
                    existSRTList = new List<CSS_Srt__c>([select id,SRT_ID__c,IsPopUpSRT__c,isUserEntered__c,Flex_Flag__c,ECM_Flag__c,SRT_Warrantable__c,Assignment__c, Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and SRT_ID__c !='0' and Assignment__c != 'NOT CLAIMABLE' and (isPerformed__c = true OR SRT_AccessiblityCheck__c=true) and (srt_type__c = 'ATC'  OR SRT_Category__c=:accordionType)]); 
            }
            else{
                system.debug('Inside ELSE');
                if(accordionType == 'AdditionalDiag'){
                    existSRTList = new List<CSS_Srt__c>([select id,SRT_ID__c,IsPopUpSRT__c,Flex_Flag__c,ECM_Flag__c, isUserEntered__c,SRT_Warrantable__c,Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and SRT_ID__c !='0' and (isPerformed__c = true OR SRT_AccessiblityCheck__c=true) and SRT_Category__c=:accordionType]);
                }
                else{
                    existSRTList = new List<CSS_Srt__c>([select id,SRT_ID__c,IsPopUpSRT__c,Flex_Flag__c,ECM_Flag__c, isUserEntered__c,SRT_Warrantable__c,Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Access_Code__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and SRT_ID__c !='0' and (isPerformed__c = true OR SRT_AccessiblityCheck__c=true) and SRT_Category__c=:accordionType and Assignment__c != 'NOT CLAIMABLE']);
                }
            }
            i=0;
            if(existSRTList ==null || existSRTList.size()<=0)
                return;

            List<SelectOption> options =  new List<SelectOption>();
            /*options.add(new SelectOption('Select One','Select One'));*/
            for(CSS_Srt__c srtObj :existSRTList){
                i=i+1;
                //GSSC-298 - START
                List<SelectOption> failCodelst = new List<SelectOption>();
                failCodelst = fetchFailcodeDropDown(srtObj.SRT_ID__c);
                //GSSC-298 - END
                system.debug('srtObj.FailCode__c****'+srtObj.FailCode__c);
                options = getAccountCodeOptionList(srtObj.FailCode__c);
                string SRTType;
                system.debug('srtObj.Type__c****'+srtObj.Type__c);
                if(srtObj.Type__c != 'Field Action'){
                    if(srtObj.SRT_Type__c != null && srtObj.SRT_Type__c != '')
                        SRTType = srtObj.SRT_Type__c;
                    else
                        SRTType = srtObj.Type__c;
                }
                else
                    SRTType = srtObj.SRT_Type__c;
                
                
                system.debug('srtObj.FailCode__c>>>:'+srtObj.FailCode__c+' options>>>:'+options);
                lstSelectedSRTWrapper.add(new srtWrapperClass(i, 
                                                              srtObj.Id,
                                                              srtObj.CSS_Claims__c,
                                                              srtObj.SRT_ID__c,
                                                              srtObj.SRT_Title__c,
                                                              Integer.valueOf(srtObj.SRT_Quantity__c),
                                                              srtObj.Step_Id__c,
                                                              failCodelst,//null, //Commented null and added failCodelst as part of the story GSSC-298
                                                              options,
                                                              srtObj.FailCode__c,
                                                              srtObj.Account_Code__c,
                                                              //srtObj.Type__c,
                                                              //srtObj.SRT_Type__c,
                                                              SRTType,
                                                              accordionType,
                                                              srtObj.Access_Code_A__c,
                                                              srtObj.Access_Code_B__c,
                                                              srtObj.Access_Code_C__c,
                                                              srtObj.Access_Code_D__c,
                                                              srtObj.Access_Code_R__c,
                                                              srtObj.SRT_Time__c,
                                                              srtObj.Access_Code__c, //Kalpana, Added as per defect 165357
                                                              srtObj.Solution_Number__c,
                                                              srtObj.IsPopUpSRT__c,
                                                              srtObj.isUserEntered__c,
                                                              srtObj.SRT_Warrantable__c,
                                                              srtObj.Flex_Flag__c,
                                                              srtObj.ECM_Flag__c)); 
            }
            system.debug('lstSelectedSRTWrapper size>>:'+lstSelectedSRTWrapper.size());
            system.debug('lstSelectedSRTWrapper >>:'+lstSelectedSRTWrapper);
        }catch(Exception ex) {
            System.debug('in catch of loadSavedSRTs>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }


    public void searchDiagSRTCodeAndDescription(){
        try{
            noSearchResultDiagFlag = false;
            excessRecFlag=false;
            system.debug('inside the diag srchSrtCode Method '+lstFilteredSRT);
            system.debug('selectedAccess***** '+selectedAccess);
            system.debug('selectedAdmin**** '+selectedAdmin);
            system.debug('selectedDiag**** '+selectedDiag);
            system.debug('selectedRepair*** '+selectedRepair);
            system.debug('selectedPickVal*** '+selectedPickVal);
            system.debug('lstDisplaySRTInside**'+lstDisplaySRT);
            system.debug('-->Outside searchDiagValue <--'+searchDiagValue);

            Integer count=0;
            String selGroupCode;
            String SRTGroupCode;
            List<CSS_srt__c> lstSrchdDiagSrt;
            lstFilteredSRT = new list<CSS_srt__c>();
            for(css_srt__c srtObj: lstDisplaySRT){


                if(count < 100){
                    excessRecFlag = false;
                    if((selectedAccess == true && srtObj.SRT_Type__c == 'Access')|| (selectedAdmin == true && srtObj.SRT_Type__c == 'Admin') || (selectedDiag == true && srtObj.SRT_Type__c == 'Diagnostic') || (selectedRepair == true && srtObj.SRT_Type__c == 'Repair') || (selectedAccess == false && selectedAdmin == false && selectedDiag == false && selectedRepair == false)){
                        //system.debug('InsidefirstIF****');
                        if(selectedPickVal != 'All'){
                            selGroupCode = selectedPickVal.LEFT(2);                        
                            // system.debug('InsidefirstIFsrtObj.SRT_ID__c****'+srtObj.SRT_ID__c);
                            if(srtObj.SRT_ID__c != null && srtObj.SRT_ID__c != '')
                                SRTGroupCode = srtObj.SRT_ID__c.LEFT(2);
                        }
                        system.debug('InsidefirstIF****'+selGroupCode);
                        system.debug('InsidefirstIFSRTGroupCode****'+SRTGroupCode);
                        if((selectedPickVal != 'All' && SRTGroupCode == selGroupCode) || selectedPickVal == 'All'){
                            system.debug('InsidesecIF****');
                            if(string.isNotBlank(searchDiagValue) && searchDiagValue.length() >= 2){
                                system.debug('InsidethirdIF****');
                                lstSrchdDiagSrt = new list<CSS_srt__c>();
                                if(srtObj.SRT_ID__c.containsIgnoreCase(searchDiagValue) || srtObj.SRT_Title__c.containsIgnoreCase(searchDiagValue)){
                                    system.debug('Inside4IF****');
                                    IF(srtObj.SRT_ID__c.containsIgnoreCase('00-10S-00'))
                                        srtObj.Admi_Check__c=TRUE;
                                    lstFilteredSRT.add(srtObj);
                                    count=count+1;
                                }
                            }
                            else if((string.isBlank(searchDiagValue) && selectedPickVal == 'All' && (srtObj.SRT_Group_Desc__c !=''|| srtObj.SRT_Group_Desc__c !=null))||(string.isBlank(searchDiagValue) && (SRTGroupCode == selGroupCode) && (srtObj.SRT_Group_Desc__c != '' || srtObj.SRT_Group_Desc__c !=null))){
                                system.debug('Insidefirstelse****');
                                IF(srtObj.SRT_ID__c.containsIgnoreCase('00-10S-00'))
                                    srtObj.Admi_Check__c=TRUE;
                                lstFilteredSRT.add(srtObj);
                                count=count+1;
                            }
                        }   
                    }
                } 
                else{
                    system.debug('InsideSECelse****');
                    excessRecFlag = true;
                    break;
                } 

            }
            system.debug('lstFilteredSRT****'+lstFilteredSRT+'size**'+lstFilteredSRT.size());
            if(lstFilteredSRT.size() == 0){
                noSearchResultDiagFlag = true;
            }
            else{
                //Added for the story#172625
                ValidateAdminSRT();
            }
        }catch(Exception ex) {
            System.debug('in catch of searchDiagSRTCodeAndDescription>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }

    }


    public void addSelectedSRTs(){
        try{
            chkReqField = false;
            System.debug('listpartWrapper IN addSelectedSRTs lstSelectedSRTWrapper>>>:'+lstSelectedSRTWrapper);
            //lstSelectedSRTWrapper = new list<srtWrapperClass>(); //not needed this line and added tempararily 
            System.debug('in addSelectedSRTs... listpartWrapper size>>>:'+lstSelectedSRTWrapper.size()+' listpartWrapper>>:'+lstSelectedSRTWrapper);

            if(lstFilteredSRT == null || lstFilteredSRT.size()<=0)
                return;
            lstSelectedSRTWrapper2=lstSelectedSRTWrapper.clone();
            lstSelectedSRTWrapper.clear();
            lstFilteredSRT2 = lstFilteredSRT.clone();
            lstFilteredSRT.clear();
            system.debug('lstFilteredSRT***'+lstFilteredSRT2);
            List<SelectOption> options =  new List<SelectOption>();
            options.add(new SelectOption('Select One','Select One'));
            //Changes as per story 173936
            list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
            if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){ //Added if condition as part of the story GSSC-297
                lstSolComp= [SELECT Id, SysCodeAndCompCode__c, CoveredLaborHrs__c, CSS_CoverageType__c,FailCode_Formula__c , CSS_Claims__c,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CampaignOCPercentage__c,Selected_Component__c,Type__c  from CSS_Solution_Component__c where CSS_Claims__c =:ClaimsId and FailCode_Formula__c!=null and Selected_Component__c= true and Type__c NOT IN ('TRP','ATC','Campaign') AND Over_The_Counter__c != true ORDER BY CSS_Failure_Sequence_Number__c ASC]; //Added Over_The_Counter__c != true condition as part of the story GSSC-297
            }else{
                lstSolComp= [SELECT Id, In_Shop_SRT_Limit_Flag__c, CoveredLaborHrs__c, CSS_CoverageType__c,CampaignLaborPercentage__c, SysCodeAndCompCode__c, FailCode_Formula__c , CSS_Claims__c,CSS_Account_Formula__c,CoveredPartsQty__c,CoveredOCAmount__c ,AccountCodeEdit__c,AccountCodeType__c,AccountCode__c,CampaignOCPercentage__c,Selected_Component__c,Type__c  from CSS_Solution_Component__c where CSS_Claims__c =:ClaimsId and FailCode_Formula__c!=null and Selected_Component__c= true and Type__c IN ('TRP','ATC','Campaign') ORDER BY CSS_Failure_Sequence_Number__c ASC];
            }
            system.debug('Anirudh fcode autopopulate'+lstSolComp.size());
            //GSSC-297
            Set<String> accCodeSet = new Set<String>();
            for(CSS_Solution_Component__c sc : lstSolComp){
                if(sc.CSS_Account_Formula__c != null && sc.CSS_Account_Formula__c != '' && sc.CSS_Account_Formula__c != 'Select One' && !accCodeSet.contains(sc.CSS_Account_Formula__c)){
                    accCodeSet.add(sc.CSS_Account_Formula__c);
                }
            }
            //GSSC-297
            String failCode1;
            String[] tempStr;
            String AccCode;
            String failCode;
            Boolean FAInshopFalse;
            Map<String,List<CSS_Solution_Component__c>> failureFAMap = new Map<String,List<CSS_Solution_Component__c>>();
            Map<String,List<CSS_Solution_Component__c>> solCmpMap = new Map<String,List<CSS_Solution_Component__c>>();
            if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                if(lstSolComp != null && lstSolComp.size() > 0){
                    List<CSS_Solution_Component__c> tempList;
                    for(CSS_Solution_Component__c slcp : lstSolComp){
                        String FARec;
                        if(slcp.Type__c == 'Campaign' || slcp.Type__c == 'TRP' || slcp.Type__c == 'ATC')
                            FARec='FieldAction';
                        else
                            FARec='Failure';
                        if(solCmpMap.containsKey(FARec)){
                            tempList = solCmpMap.get(FARec);
                            system.debug('tempList'+tempList);
                            tempList.add(slcp);
                            system.debug('tempList'+tempList);
                            solCmpMap.put(FARec, tempList);
                        }
                        else{
                            tempList = new List<CSS_Solution_Component__c>();
                            tempList.add(slcp);
                            solCmpMap.put(FARec, tempList);
                        }
                    }
                    
                    tempList = new List<CSS_Solution_Component__c>();
                    List<CSS_Solution_Component__c> tempListFA = new List<CSS_Solution_Component__c>();
                    Map<String,List<CSS_Solution_Component__c>> accSolCmpMap = new Map<String,List<CSS_Solution_Component__c>>();
                    List<CSS_Solution_Component__c> accSlCmp;
                    tempList = solCmpMap.get('Failure');
                    if(tempList!=null && tempList.size() >1){
                        for(CSS_Solution_Component__c sc:tempList){
                            if(accSolCmpMap.containsKey(sc.CSS_Account_Formula__c)){
                                accSlCmp=accSolCmpMap.get(sc.CSS_Account_Formula__c);
                                accSlCmp.add(sc);
                                accSolCmpMap.put(sc.CSS_Account_Formula__c,accSlCmp);
                            }
                            else{
                                accSlCmp = new List<CSS_Solution_Component__c>();
                                accSlCmp.add(sc);
                                accSolCmpMap.put(sc.CSS_Account_Formula__c, accSlCmp);
                            }
                        }
                    }
                    if(tempList !=null && tempList.size() >0){
                        if((tempList.size() == 1 && tempList[0].CoveredLaborHrs__c != null && Double.valueOf(tempList[0].CoveredLaborHrs__c) >0) || (tempList[0].CSS_CoverageType__c == 'OTH' || tempList[0].CSS_CoverageType__c == 'POL')){
                            failCode =  String.valueof(tempList[0].FailCode_Formula__c);
                            accCode = tempList[0].CSS_Account_Formula__c;
                        }
                        else if((tempList.size() > 1 && accSolCmpMap != null && accSolCmpMap.size() == 1 && tempList[0].CoveredLaborHrs__c != null && Double.valueOf(tempList[0].CoveredLaborHrs__c) >0 && tempList[0].CSS_CoverageType__c != 'NPW' && tempList[0].CSS_CoverageType__c != 'RPW' && tempList[0].CSS_CoverageType__c != 'RRW' && tempList[0].CSS_CoverageType__c != 'POL' && tempList[0].CSS_CoverageType__c != 'OTH') || (tempList.size() > 1 && accSolCmpMap != null && accSolCmpMap.size() == 1 && (tempList[0].CSS_CoverageType__c == 'OTH' || tempList[0].CSS_CoverageType__c == 'POL'))){
                            failCode =  String.valueof(tempList[0].FailCode_Formula__c);
                            accCode = tempList[0].CSS_Account_Formula__c;
                        }
                        else{
                            failCode =  'Select One';
                            accCode = 'Select One';
                        }
                        
                    }
                }
                if(failCode != null && failCode.contains('-')){
                    tempStr = failCode.split('-');
                    system.debug('tempStr size '+tempStr.size());
                    if(tempStr.size()==2){
                        system.debug('insideFCIF '+tempStr[1]);
                        failCode1=tempStr[1].trim();
                    }
                    else if(tempStr.size()==3){
                        failCode1=tempStr[2].trim();
                    }
                    else if(tempStr.size()==4){
                        failCode1=tempStr[3].trim();
                    }
                }
                else{
                    failCode1=failCode;
                }
            }
            else{
                system.debug('insideelse111');
                if(lstSolComp != null && lstSolComp.size() > 0){
                    List<CSS_Solution_Component__c> tempList;
                    for(CSS_Solution_Component__c slcp : lstSolComp){
                        String InshopFlag;
                        if(slcp.In_Shop_SRT_Limit_Flag__c == true)
                            InshopFlag='Y';
                        else
                            InshopFlag='N';
                        if(solCmpMap.containsKey(InshopFlag)){
                            tempList = solCmpMap.get(InshopFlag);
                            system.debug('tempList'+tempList);
                            tempList.add(slcp);
                            system.debug('tempList'+tempList);
                            solCmpMap.put(InshopFlag, tempList);
                        }
                        else{
                            tempList = new List<CSS_Solution_Component__c>();
                            tempList.add(slcp);
                            solCmpMap.put(InshopFlag, tempList);
                        }
                    }
                    tempList = new List<CSS_Solution_Component__c>();
                    for(String slcmpKey: solCmpMap.keySet()){
                        tempList = solCmpMap.get(slcmpKey);
                        if(slcmpKey == 'N' && tempList.size()==1){
                            if((tempList[0].CampaignLaborPercentage__c != null && tempList[0].CampaignLaborPercentage__c != '' && Double.valueOf(tempList[0].CampaignLaborPercentage__c) >0 && (tempList[0].CSS_CoverageType__c != 'OTH' && tempList[0].CSS_CoverageType__c != 'POL')) || (tempList[0].CSS_CoverageType__c == 'OTH' || tempList[0].CSS_CoverageType__c == 'POL')){
                                if(tempList[0].FailCode_Formula__c.contains('-')){
                                    tempStr = tempList[0].FailCode_Formula__c.split('-');
                                    system.debug('tempStr size '+tempStr.size());
                                    if(tempStr.size()==2){
                                        system.debug('insideFCIF '+tempStr[1]);
                                        failCode1=tempStr[1].trim();
                                    }
                                    else if(tempStr.size()==3){
                                        failCode1=tempStr[2].trim();
                                    }
                                    else if(tempStr.size()==4){
                                        failCode1=tempStr[3].trim();
                                    }
                                }
                                else{
                                    failCode1=tempList.size() > 0 ? tempList[0].FailCode_Formula__c : '';
                                }
                                system.debug('CSS_Account_Formula__c****'+tempList[0].CSS_Account_Formula__c);
                                AccCode=tempList[0].CSS_Account_Formula__c;
                            }
                        }
                        else
                            continue;
                        
                    }
                }
                system.debug('***failCode1**'+failCode1+'****AccCode***'+AccCode);
            }


            if((lstSolComp != null && lstSolComp.size()==1) || (accCodeSet != null && accCodeSet.size() == 1)){ //Added condition (accCodeSet != null && accCodeSet.size() == 1) as part of the story GSSC-297
                system.debug('Anirudh Entered if autopopulate'+failCode1);
                system.debug('Anirudh Entered if autopopulate**AccCode***'+AccCode);
                //options = getAccountCodeOptionList(failCode1);
                system.debug('Anirudh Entered if autopopulate**options***'+options);
                for(CSS_Srt__c srtObj :lstFilteredSRT2){
                    if(srtObj.SRT_Select__c == true){
                        i=i+1;
                        //GSSC-298 - START
                        List<SelectOption> failCodelst = new List<SelectOption>();
                        failCodelst = fetchFailcodeDropDown(srtObj.SRT_ID__c);
                        options = getAccountCodeOptionList(failCode1);
                        //GSSC-298 - END
                        lstSelectedSRTWrapper2.add(new srtWrapperClass(i, 
                                                                       srtObj.Id,
                                                                       srtObj.CSS_Claims__c,
                                                                       srtObj.SRT_ID__c,
                                                                       srtObj.SRT_Title__c,
                                                                       1, 
                                                                       srtObj.Step_Id__c,
                                                                       failCodelst,//null, //Commented null and added failCodelst as part of the story GSSC-298
                                                                       options,
                                                                       failCode1,
                                                                       //lstSolComp[0].CSS_Account_Formula__c,
                                                                       AccCode,
                                                                       //srtObj.Type__c,
                                                                       srtObj.SRT_Type__c,
                                                                       accordionType,
                                                                       srtObj.Access_Code_A__c,
                                                                       srtObj.Access_Code_B__c,
                                                                       srtObj.Access_Code_C__c,
                                                                       srtObj.Access_Code_D__c,
                                                                       srtObj.Access_Code_R__c,
                                                                       srtObj.SRT_Time__c,
                                                                       srtObj.Access_Code__c, //Kalpana, Added as per defect 165357
                                                                       srtObj.Solution_Number__c,
                                                                       true,
                                                                       srtObj.isUserEntered__c,
                                                                       srtObj.SRT_Warrantable__c,
                                                                       srtObj.Flex_Flag__c,
                                                                       srtObj.ECM_Flag__c));

                        srtObj.SRT_Select__c = false;
                        if(removedSRTCode.size()>0 && (srtObj.SRT_ID__c.contains('00-10S-00') || srtObj.SRT_ID__c.contains('00-724')|| srtObj.SRT_ID__c.contains('00-901') || srtObj.SRT_ID__c.contains('00-902') || srtObj.SRT_ID__c.contains('00-904') || srtObj.SRT_ID__c.contains('00-400') || srtObj.SRT_ID__c.contains('00-401') || srtObj.SRT_ID__c.contains('00-404')  ))
                            removedSRTCode.add(srtObj.SRT_ID__c);

                    }
                    lstFilteredSRT.add(srtObj);
                }
            }
            else{
                system.debug('Anirudh Entered else autopopulate');
                for(CSS_Srt__c srtObj :lstFilteredSRT2){
                    if(srtObj.SRT_Select__c == true){
                        i=i+1;
                        //GSSC-298
                        List<SelectOption> failCodelst = new List<SelectOption>();
                        failCodelst = fetchFailcodeDropDown(srtObj.SRT_ID__c);
                        //GSSC-298
                        lstSelectedSRTWrapper2.add(new srtWrapperClass(i, 
                                                                       srtObj.Id,
                                                                       srtObj.CSS_Claims__c,
                                                                       srtObj.SRT_ID__c,
                                                                       srtObj.SRT_Title__c,
                                                                       1, 
                                                                       srtObj.Step_Id__c,
                                                                       failCodelst,//null, //Commented null and added failCodelst as part of the story GSSC-298
                                                                       options,
                                                                       srtObj.FailCode__c,
                                                                       srtObj.Account_Code__c,
                                                                       //srtObj.Type__c,
                                                                       srtObj.SRT_Type__c,
                                                                       accordionType,
                                                                       srtObj.Access_Code_A__c,
                                                                       srtObj.Access_Code_B__c,
                                                                       srtObj.Access_Code_C__c,
                                                                       srtObj.Access_Code_D__c,
                                                                       srtObj.Access_Code_R__c,
                                                                       srtObj.SRT_Time__c,
                                                                       srtObj.Access_Code__c, //Kalpana, Added as per defect 165357
                                                                       srtObj.Solution_Number__c,
                                                                       true,
                                                                       srtObj.isUserEntered__c,
                                                                       srtObj.SRT_Warrantable__c,
                                                                       srtObj.Flex_Flag__c,
                                                                       srtObj.ECM_Flag__c));

                        srtObj.SRT_Select__c = false;
                        if(removedSRTCode.size()>0 && (srtObj.SRT_ID__c.contains('00-10S-00') || srtObj.SRT_ID__c.contains('00-724')|| srtObj.SRT_ID__c.contains('00-901') || srtObj.SRT_ID__c.contains('00-902') || srtObj.SRT_ID__c.contains('00-904') || srtObj.SRT_ID__c.contains('00-400') || srtObj.SRT_ID__c.contains('00-401') || srtObj.SRT_ID__c.contains('00-404')  ))
                            removedSRTCode.add(srtObj.SRT_ID__c);
                    }
                    System.debug('i****'+i);
                    lstFilteredSRT.add(srtObj);
                }
            }
            lstSelectedSRTWrapper=lstSelectedSRTWrapper2.clone();
            lstSelectedSRTWrapper2.clear(); 

            if(lstSelectedSRTWrapper.size()>0){
                SelectedSRTAdminVal();

            }




            System.debug('in addSelectedSRTs... listpartWrapper size>>>:'+lstSelectedSRTWrapper.size()+' listpartWrapper>>:'+lstSelectedSRTWrapper);
        }catch(Exception ex) {
            System.debug('in catch of addSelectedSRTs>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    } 

    public void saveSelectedSRTs(){
        system.debug('inside saveSelectedSRTs');
        try{
            //do validations here
            chkReqField = false;
            srtNotAllowedErr = false;
            GSQErrorExists = false;

            //List<CSS_srt__c> lstSRTToBeSaved = new List<CSS_srt__c>();
            srtMap = new  Map<String,CSS_srt__c>();
            system.debug('lstSelectedSRTWrapper--'+lstSelectedSRTWrapper);
            if(lstSelectedSRTWrapper != null && lstSelectedSRTWrapper.size()>0){
                system.debug('lstSelectedSRTWrapper*****'+lstSelectedSRTWrapper);
                /*for(srtWrapperClass srtWrap : lstSelectedSRTWrapper){
                    srtWrapperSave.put(srtWrap.srtCode+srtWrap.selectedFailCode+srtWrap.selectedAccountCode,srtWrap);
                }*/
                system.debug('***Type***'+Typ);
                List<String> lstType = new List<String>();
                if(Typ=='AdditionalDiag'){
                    lstType.add('Diagnosis');
                    lstType.add('Diag Access');

                }
                else if(Typ=='AdditionalRep'){
                    lstType.add('Repair Access');
                    lstType.add('Repair');

                }
                else if(Typ=='Campaign' || Typ=='ATC' || Typ=='TRP'){
                    lstType.add('Field Action');
                    lstType.add('Field Action Access');

                }
                system.debug('***lstType***'+lstType);

                //AggregateResult[] groupedResults= [SELECT MAX(SRT_Order__c),type__c,srt_category__c FROM CSS_SRT__c WHERE css_claims__c =:claimsId GROUP BY type__c,srt_category__c HAVING type__c in:lstType or srt_category__c =: Typ];
                AggregateResult[] groupedResults= [SELECT MAX(SRT_Order__c) FROM CSS_SRT__c WHERE css_claims__c =:claimsId and  (type__c in:lstType or srt_category__c =: Typ)];

                Decimal sortOrder=0;
                if(groupedResults != null && groupedResults.size() > 0){
                    sortOrder=(Decimal)groupedResults[0].get('expr0')!=NULL?(Decimal)groupedResults[0].get('expr0'):0;
                    system.debug('sortorder*******' + sortOrder);
                }

                system.debug('sortorder>>>>>>>>>' + sortOrder);
                integer i =0;  
                for(srtWrapperClass srtWrap : lstSelectedSRTWrapper){

                    if(srtWrap.selectedFailCode == 'Select One'){
                        srtWrap.mandateFailCode = true;
                        chkReqField = true; 
                    }
                    else{
                        srtWrap.mandateFailCode = false;            
                    }
                    if(srtWrap.selectedAccountCode == 'Select One'){
                        srtWrap.mandateAccCode = true; 
                        chkReqField = true;
                    }
                    else{
                        srtWrap.mandateAccCode = false; 
                    }

                    system.debug('chkReqField'+chkReqField);
                    Set<String> srtTemp = new Set<String>();
                    if(srtWrap.selectedFailCode != null && srtWrap.selectedFailCode != '' && srtWrap.selectedFailCode != 'Select One'){ 
                        if(Typ=='Campaign' || Typ=='ATC' || Typ=='TRP'){
                            if(srtIdFcodeAssignmentMap != null)
                                srtTemp = srtIdFcodeAssignmentMap.get(srtWrap.selectedFailCode);
                            if(srtTemp != null && srtTemp.size() > 0 && srtTemp.contains(srtWrap.srtCode)){
                                srtNotAllowedErr = true;
                                srtWrap.mandateFailCode = true;
                                return;
                            }else{
                                srtNotAllowedErr = false;
                                srtWrap.mandateFailCode = false;
                            }
                        }
                        else if(Typ=='AdditionalRep'){
                            if(srtIdFcodeAssignmentMapRep != null)
                                srtTemp = srtIdFcodeAssignmentMapRep.get(srtWrap.selectedFailCode);
                            if(srtTemp != null && srtTemp.size() > 0 && srtTemp.contains(srtWrap.srtCode)){
                                srtNotAllowedErr = true;
                                srtWrap.mandateFailCode = true;
                                return;
                            }else{
                                srtNotAllowedErr = false;
                                srtWrap.mandateFailCode = false;
                            }
                            system.debug(srtNotAllowedErr);
                            system.debug(srtWrap.mandateFailCode);
                        }
                    }
                    if(chkReqField == true){
                        return;   
                    }
                    system.debug('chkReqField'+chkReqField);

                    system.debug('selectedFailCode>:'+srtWrap.selectedFailCode+' SRTId:'+srtWrap.srtCode+' failCodeGSQSRTMap>:'+failCodeGSQSRTMap);
                    system.debug('failCodeGSQSRTMap>:'+failCodeGSQSRTMap.containsKey(srtWrap.selectedFailCode));
                    //SRT GSG Gropus Validation code start
                    if(srtWrap.srtCode !=null && srtWrap.srtCode.trim() !='' && srtWrap.srtCode !='0'){
                        String srtGrpCode = srtWrap.srtCode.LEFT(2);
                        if( (Typ=='AdditionalDiag' || Typ=='AdditionalRep') && failCodeGSQSRTMap !=null && failCodeGSQSRTMap.containsKey(srtWrap.selectedFailCode) && (srtGrpCode=='TS' || srtGrpCode=='FC' || srtGrpCode=='TT' || srtGrpCode=='IB' 
                                                                                                                   || srtGrpCode=='IC' || srtGrpCode=='IM' || srtGrpCode=='IX' || srtGrpCode=='CE' || srtGrpCode=='CN' || srtGrpCode=='MC' || srtGrpCode=='PT' 
                                                                                                                   || srtGrpCode=='QU' || srtGrpCode=='T7' || srtGrpCode=='TG' ) ){ //add conditions here 
                            system.debug('inside if conditions srtWrap.selectedFailCode>:'+srtWrap.selectedFailCode+' GSQErrorExists:'+GSQErrorExists);
                            srtWrap.mandateFailCode = true;
                            GSQErrorExists = true;
                            return;
                            system.debug('after return GSQErrorExists>:'+GSQErrorExists);
                            //break;   
                        }
                    }
                    //SRT GSG Gropus Validation code end

                    //String key = srtWrap.srtCode+srtWrap.selectedFailCode+srtWrap.selectedAccountCode;

                    String key;
                    system.debug('srtWrap.srtCode***'+srtWrap.srtCode+'   **srtWrap.solNumber**'+srtWrap.solNumber);
                    if(srtWrap.solNumber != null){
                        key = srtWrap.solNumber+srtWrap.srtCode+srtWrap.selectedFailCode+srtWrap.selectedAccountCode;
                    }
                    else{
                        key = srtWrap.srtCode+srtWrap.selectedFailCode+srtWrap.selectedAccountCode;
                    }
                    system.debug('key***'+key);
                    if(srtMap.containsKey(key) && srtWrap.FlexFlag == false){
                        Integer qty = Integer.valueOf(srtMap.get(key).SRT_Quantity__c);
                        system.debug('if(srtMap.get(key).SRT_ID__c)>>'+srtMap.get(key).SRT_ID__c);
                        string tmpstr= string.valueOf(srtMap.get(key).SRT_ID__c);
                        qty = qty + srtWrap.quantity;
                        CSS_srt__c srtObj = srtMap.get(key);
                        if(tmpstr.contains('00-10S-00') || tmpstr.contains('00-901') || tmpstr.contains('00-902') || tmpstr.contains('00-904') ) // removed 724,400,401,404 as per defect # 190008
                            srtObj.SRT_Quantity__c=1;
                        else
                            srtObj.SRT_Quantity__c = qty;

                        /*if(srtObj.SRT_Order__c==null){
                            i++;
                        srtObj.SRT_Order__c=sortOrder+i;

                        }*/

                        srtMap.put(key,srtObj);
                        //srtMap.get(key).SRT_Quantity__c = srtMap.get(key).SRT_Quantity__c + srtWrap.quantity;                        
                        system.debug('insidemaocintainskey***'+srtMap.get(key).SRT_Quantity__c);
                    }else{
                        system.debug('insideelse***');
                        CSS_srt__c srtObj = new CSS_srt__c();
                        srtObj.Id = srtWrap.id;
                        srtObj.CSS_Claims__c =srtWrap.claimsId;
                        srtObj.SRT_ID__c = srtWrap.srtCode;
                        srtObj.Flex_Flag__c = srtWrap.FlexFlag;//Story - GSSC - 24
                        srtObj.ECM_Flag__c = srtWrap.ecmFlag;//Story - GSSC - 30
                        system.debug('insideelse*** SRT_ID__c'+ srtObj.SRT_ID__c);

                        if(srtObj.SRT_ID__c!=null && srtObj.SRT_ID__c!='')
                        {
                            string strtemp1 = string.valueOf(srtObj.SRT_ID__c);

                            if(strtemp1.contains('00-10S-00') ||  strtemp1.contains('00-901') || strtemp1.contains('00-902') || strtemp1.contains('00-904')) // removed 724,400,401,404 as per defect # 190008
                                srtObj.SRT_Quantity__c =1;
                            else
                                srtObj.SRT_Quantity__c = srtWrap.quantity;
                        }
                        else
                            srtObj.SRT_Quantity__c = srtWrap.quantity;

                        srtObj.SRT_Title__c = srtWrap.srtDesc;
                        srtObj.Step_Id__c = srtWrap.stepId;
                        srtObj.FailCode__c = srtWrap.selectedFailCode;
                        srtObj.Account_Code__c = srtWrap.selectedAccountCode;
                        srtObj.Access_Code_A__c = srtWrap.accessCodeA;
                        srtObj.Access_Code_B__c = srtWrap.accessCodeB;
                        srtObj.Access_Code_C__c = srtWrap.accessCodeC;
                        srtObj.Access_Code_D__c = srtWrap.accessCodeD;
                        srtObj.Access_Code_R__c = srtWrap.accessCodeR;
                        srtObj.SRT_Time__c = srtWrap.SRTTime;
                        //Defect 191815
                        srtObj.isUserEntered__c = srtWrap.isUserEntered;
                        //Kalpana, Added as per defect 165357 -- START
                        if(srtWrap.AccessCode!=null && srtWrap.AccessCode!=''){
                            system.debug('srtWrap.AccessCode**'+srtWrap.AccessCode);
                            srtObj.Access_Code__c = srtWrap.AccessCode;
                            srtObj.SRT_Access_Code__c=srtWrap.AccessCode;//Story#172627
                        }
                        else{
                            //Commented below line as part of defect fix for defect 173328
                            //srtObj.Access_Code__c = claimAccessCode;
                            //if(srtWrap.accessCodeR ==null || srtWrap.accessCodeR <=0)
                            if( srtObj.Access_Code_A__c==0 && srtObj.Access_Code_B__c==0 && srtObj.Access_Code_C__c==0 && srtObj.Access_Code_D__c==0 && srtObj.Access_Code_R__c!=0)
                            {   //srtObj.Access_Code__c = claimAccessCode;
                                srtObj.Access_Code__c = 'R'; //Claim access code adding here
                                srtObj.SRT_Access_Code__c='R';//Story#172627
                            }
                            else
                            {
                                //srtObj.Access_Code__c = 'R'; 
                                srtObj.Access_Code__c = claimAccessCode;//for 173328
                                srtObj.SRT_Access_Code__c=claimAccessCode;//Story#172627
                            }
                            system.debug('srtObj.Access_Code__c:'+srtObj.Access_Code__c+' claimAccessCode:'+claimAccessCode);
                        }
                        //Kalpana, Added as per defect 165357 -- END

                        if(srtWrap.srtType !=null && srtWrap.srtType.equalsIgnoreCase('Diagnostic'))
                            srtWrap.srtType = 'Diagnosis';

                        if(srtWrap.srtType != null && srtWrap.srtType != '' && !srtWrap.srtType.equalsIgnoreCase('Campaign') && !srtWrap.srtType.equalsIgnoreCase('ATC') && !srtWrap.srtType.equalsIgnoreCase('TRP'))
                            srtObj.Type__c = srtWrap.srtType; //Type
                        else
                            srtObj.Type__c = 'Field Action';
                        srtObj.SRT_Type__c = srtWrap.srtType; //SRT Type
                        srtObj.SRT_Category__c = srtWrap.accordionType; //SRT SRT_Category__c as AccordionType__c
                        //srtObj.SRT_Category__c = srtWrap.accordionType; 
                        //srtObj.AccordionType__c = srtWrap.srtType; //SRT AccordionType__c
                        //if(isAutomatedClaim)
                        if((srtWrap.solNumber == null || srtWrap.solNumber =='') && srtWrap.isPopupSRT != false){
                            srtObj.IsPopUpSRT__c = true; //for Bold/Unbold
                        }
                        else
                            srtObj.IsPopUpSRT__c = false; //for Unbold 

                        if(srtWrap.selectedAccountCode != '' && srtWrap.selectedAccountCode != null){
                            //defect 191815
                            if(srtWrap.srtWarrantable!=null && srtWrap.srtWarrantable !='')
                                srtObj.SRT_Warrantable__c = srtWrap.srtWarrantable;
                            else
                                srtObj.SRT_Warrantable__c = '100';
                            //srtObj.SRT_Hours_Percentage__c = 100;
                        }
                        else{
                            //defect 191815
                            if(srtWrap.srtWarrantable!=null && srtWrap.srtWarrantable !='')
                                srtObj.SRT_Warrantable__c = srtWrap.srtWarrantable;
                            else
                                srtObj.SRT_Warrantable__c = '0';
                            //srtObj.SRT_Hours_Percentage__c = 0;
                        }

                        if(srtWrap.srtType !=null && !srtWrap.srtType.equalsIgnoreCase('Access')){
                            srtObj.isPerformed__c = true;
                        }
                        if(srtWrap.srtType !=null && srtWrap.srtType.equalsIgnoreCase('Access')){
                            srtObj.SRT_AccessiblityCheck__c = true;
                        }

                        if(srtWrap.id==null && srtWrap.id==null ){
                            i++;
                            system.debug('srtObj.SRT_Order__c***'+srtObj.SRT_Order__c);
                            srtObj.SRT_Order__c=sortOrder+i;
                            system.debug('srtObj.SRT_Order__c***'+srtObj.SRT_Order__c);
                        }
                        //lstSRTToBeSaved.add(srtObj);

                        srtMap.put(key,srtObj);
                        system.debug('srtMap***'+srtMap);                        
                    }
                }

                existSRTList = new List<CSS_Srt__c>([select id, SRT_ID__c,SRT_Category__c, Type__c, SRT_Type__c, FailCode__c, Account_Code__c, SRT_Quantity__c,SRT_Time__c,Flex_Flag__c,ECM_Flag__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and SRT_Category__c=:accordionType and Flex_Flag__c = false]);
                if(existSRTList !=null && existSRTList.size()>0)
                    for(CSS_SRT__c srtObj: existSRTList){
                        CSS_SRT__c srtObjTemp;
                        String Key=srtObj.SRT_ID__c+srtObj.FailCode__c+srtObj.Account_Code__c;
                        if(srtMap.containsKey(Key)){
                            srtObjTemp=srtMap.get(Key);
                            system.debug('if(srtMap.get(key).SRT_ID__c)>>'+srtMap.get(key).SRT_ID__c);
                            string tmpstr= string.valueOf(srtMap.get(key).SRT_ID__c);

                            if(tmpstr.contains('00-10S-00') || tmpstr.contains('00-901') || tmpstr.contains('00-902') || tmpstr.contains('00-904') )  // removed 724,400,401,404 as per defect # 190008
                                srtObjTemp.SRT_Quantity__c=1;

                            srtObjTemp.id = srtobj.id; //here updating existing db id on to unique records is sufficient
                            srtMap.put(key,srtObjTemp);                  
                        }
                    }

                system.debug('List tobe upserted***'+srtMap.values());
                //if(lstSRTToBeSaved != null && lstSRTToBeSaved.size()>0)
                //upsert lstSRTToBeSaved;
                if(srtMap != null && srtMap.size()>0){
                    //upsert srtMap.values();
                    Database.UpsertResult[] results = Database.upsert(srtMap.values());
                    system.debug('results***'+results);
                }
            }

            //Delete permanantly from sf db for removed SRTs
            if(removedKeySet !=null && removedKeySet.size()>0){
                delete [Select id from CSS_SRT__c where id IN:removedKeySet];
            }


            //query updated list from db & populate here
            loadSavedSRTs();


        }catch(exception ex){
            System.debug('in catch of saveSelectedSRTs>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }     
    }

    public void saveAndCloseSelectedSRTs(){
        saveSelectedSRTs();
    }


    public void removingRow(){
        System.debug('listpartWrapper IN REMOVE ROW lstSelectedSRTWrapper>>>L'+lstSelectedSRTWrapper);
        chkReqField = false;
        String failCode;
        String srtCode;
        String accCode;
        removeRow=true;
        try{
            lstSelectedSRTWrapper2=lstSelectedSRTWrapper.clone();
            lstSelectedSRTWrapper.clear();
            for(Integer i=0;i<lstSelectedSRTWrapper2.size();i++){
                //String key = lstSelectedSRTWrapper2[i].srtCode+lstSelectedSRTWrapper2[i].selectedFailCode+lstSelectedSRTWrapper2[i].selectedAccountCode;
                if(lstSelectedSRTWrapper2[i].counting==removedRowNo){
                    System.debug('removedRowNo>>: '+removedRowNo);
                    System.debug('lstSelectedSRTWrapper2[i].counting '+lstSelectedSRTWrapper2[i].counting);
                    /*if(srtRemoveMap.containsKey(key)){
 srtRemoveMap.get(key).SRT_Quantity__c = srtRemoveMap.get(key).SRT_Quantity__c - lstSelectedSRTWrapper2[i].quantity;                        
                        system.debug('insidemaocintainskey***'+srtRemoveMap.get(key).SRT_Quantity__c);
                    }
                    else{
                        system.debug('insideelse***remo');
                        srtRemoveID.add(lstSelectedSRTWrapper2[i].id);
                    }*/
                    if(lstSelectedSRTWrapper2[i].id!=null)
                        removedKeySet.add(lstSelectedSRTWrapper2[i].id);


                    //failCode = lstSelectedSRTWrapper2[i].selectedFailCode;
                    //srtCode = lstSelectedSRTWrapper2[i].srtCode;   
                    //accCode = lstSelectedSRTWrapper2[i].selectedAccountCode;
                    lstSelectedSRTWrapper2.remove(i);
                    break;
                }
            } 

            system.debug('****failcode****'+failCode);
            system.debug('****srtCode****'+srtCode);
            system.debug('****accCode****'+accCode);
            /*
            if(failCode !=null && srtCode != null && accCode != null){
                system.debug('****inside if failcode****');
                delete [Select id from CSS_SRT__c where SRT_ID__c =: srtCode and FailCode__c =: failCode and  Account_Code__c =: accCode];    
            }*/

            lstSelectedSRTWrapper=lstSelectedSRTWrapper2.clone();
            lstSelectedSRTWrapper2.clear();


        }catch(Exception ex) {
            System.debug('in catch of removingRow of removingRow>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }


    public List<SelectOption> getGroupList() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = CSS_SRT__c.SRT_Group_Desc__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues(); 
        options.add(new SelectOption('All', 'All'));           
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    } 

    /*Commented below method as part of the story GSSC-298
    public List<SelectOption> getfailcodeDropDown(){  
        List<SelectOption> options;
        try{
            system.debug('***inside getfailcodeDropDown method...');
            options =  new List<SelectOption>();
            Set<string> sortableSet = new  Set<string>();
            List<string> sortable = new  List<string>();
            failAccountCodeMap = new  Map<String, Set<String>>();
            List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
            system.debug('ClaimsId****'+claimsId);
            if(claimsId !=null){
                if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){ //Added "Over_The_Counter__c != true" in below queries as part of the story GSSC-298
                    solsComp= [SELECT Id, SysCodeAndCompCode__c,Fail_Code__c, CSS_Account_Formula__c,CoveredLaborHrs__c,CampaignLaborPercentage__c,Selected_Component__c,Type__c,FailCode_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =:claimsId and SysCodeAndCompCode__c!=null and Selected_Component__c= true and Type__c NOT IN ('TRP','ATC','Campaign') AND Over_The_Counter__c != true]; //and Selected_Component__c= true];       
                }else{
                    solsComp= [SELECT Id, SysCodeAndCompCode__c,Fail_Code__c, CampaignLaborPercentage__c, CSS_Account_Formula__c, CoveredLaborHrs__c, Selected_Component__c, Type__c,FailCode_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =:claimsId and SysCodeAndCompCode__c!=null  and Type__c IN ('TRP','ATC','Campaign') and Selected_Component__c= true AND Over_The_Counter__c != true]; //and Selected_Component__c= true];    
                }
            }
            options.add(new SelectOption('Select One','Select One'));
            system.debug('solCompList***'+solsComp);
            if(solsComp.size()>0){
                Set<string> acCodeSet;
                for(CSS_Solution_Component__c f: solsComp)  {
                    if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                        if(jobEventLst != null){
                            for(CSS_JobEventTemporary__c jobEntObj : jobEventLst){
                                if(jobEntObj.Account_Code__c == f.CSS_Account_Formula__c){
                                    coverageType = jobEntObj.Attribute1__c;
                                }
                            }
                        }
                        system.debug('coverageType***'+coverageType);
                    }
                    if(f.SysCodeAndCompCode__c !='Select One'){
                        //sortableSet.add(f.FailCode_Formula__c);
                        if(failAccountCodeMap.containsKey(f.Fail_Code__c)){
                            system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                            acCodeSet = failAccountCodeMap.get(f.Fail_Code__c);
                            if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                                if(coverageType == 'OTH' || coverageType == 'POL'){
                                    sortableSet.add(f.FailCode_Formula__c);
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                else{
                                    if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                                        if(f.Type__c != 'TRP' && f.Type__c !='ATC' && f.Type__c !='Campaign'){
                                            if(f.CoveredLaborHrs__c != null && f.CoveredLaborHrs__c != '' && Double.valueOf(f.CoveredLaborHrs__c) >0 && f.Selected_Component__c== true){
                                                sortableSet.add(f.FailCode_Formula__c);
                                                acCodeSet.add(f.CSS_Account_Formula__c);
                                            }
                                        }
                                        else{ 
                                            if(f.CampaignLaborPercentage__c != null && f.CampaignLaborPercentage__c != '' && Double.valueOf(f.CampaignLaborPercentage__c) >0 ){
                                                sortableSet.add(f.FailCode_Formula__c);
                                                acCodeSet.add(f.CSS_Account_Formula__c);
                                            }
                                        }
                                    }
                                    else{
                                        if(f.CampaignLaborPercentage__c != null && f.CampaignLaborPercentage__c != '' && Double.valueOf(f.CampaignLaborPercentage__c) >0 ){
                                            sortableSet.add(f.FailCode_Formula__c);
                                            acCodeSet.add(f.CSS_Account_Formula__c);
                                        }
                                    }
                                }

                            }
                            system.debug('**acCodeSet*'+f.Fail_Code__c+'***'+acCodeSet);
                            //failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                            failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                        }else{
                            system.debug('**insidecontainkey---else');
                            acCodeSet = new Set<string>();
                            if(f.CSS_Account_Formula__c != null){
                                if(coverageType == 'OTH' || coverageType == 'POL'){
                                    sortableSet.add(f.FailCode_Formula__c);
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                else{
                                    if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                                        if(f.Type__c != 'TRP' && f.Type__c !='ATC' && f.Type__c !='Campaign'){
                                            if(f.CoveredLaborHrs__c != null && f.CoveredLaborHrs__c != '' && Double.valueOf(f.CoveredLaborHrs__c) >0 && f.Selected_Component__c== true){
                                                sortableSet.add(f.FailCode_Formula__c);
                                                acCodeSet.add(f.CSS_Account_Formula__c);
                                            }
                                        }
                                        else{ 
                                            if(f.CampaignLaborPercentage__c != null && f.CampaignLaborPercentage__c != '' && Double.valueOf(f.CampaignLaborPercentage__c) >0 ){
                                                sortableSet.add(f.FailCode_Formula__c);
                                                acCodeSet.add(f.CSS_Account_Formula__c);
                                            }
                                        }
                                    }
                                    else{
                                        if(f.CampaignLaborPercentage__c != null && f.CampaignLaborPercentage__c != '' && Double.valueOf(f.CampaignLaborPercentage__c) >0 ){
                                            sortableSet.add(f.FailCode_Formula__c);
                                            acCodeSet.add(f.CSS_Account_Formula__c);
                                        }
                                    }
                                }
                            }
                            system.debug('**acCodeSet*'+f.Fail_Code__c+'***'+acCodeSet);
                            failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                        }
                    }
                }
            }
            if(sortableSet.size()>0){
                sortable.AddAll(sortableSet);}
            sortable.sort();
            if (sortable.size()>0){
                for(String s:sortable)    
                {   
                    String[] tempStr;
                    if(s !='Select One'){
                        tempStr = s.split('-');
                        system.debug('***str***'+tempStr[1]);
                    } 
                    if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                        options.add(new selectOption(tempStr[1],s));   
                    }
                    else{
                        String s1 = s.RIGHT(6);
                        String sTemp = s1.LEFT(4);
                        String sTemp1 = s1.LEFT(6);
                        options.add(new selectOption(sTemp1,s));
                    }
                }   
            }
        }catch(Exception ex) {
            System.debug('in catch of getfailcodeDropDown>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return options;
    }*/

    //Added below method as part of the story GSSC-298
    public List<SelectOption> fetchFailcodeDropDown(String srtId){  
        List<SelectOption> options;
        try{
            system.debug('***inside fetchFailcodeDropDown method...');
            options =  new List<SelectOption>();
            Set<string> sortableSet = new  Set<string>();
            List<string> sortable = new  List<string>();
            failAccountCodeMap = new  Map<String, Set<String>>();
            List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
            system.debug('ClaimsId****'+claimsId);
            if(claimsId !=null){
                if(srtId == '00-901-00'){
                    if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){ 
                        solsComp= [SELECT Id, SysCodeAndCompCode__c,Fail_Code__c, CSS_Account_Formula__c,CoveredLaborHrs__c,CampaignLaborPercentage__c,Selected_Component__c,Type__c,FailCode_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =:claimsId and SysCodeAndCompCode__c!=null and Selected_Component__c= true and Type__c NOT IN ('TRP','ATC','Campaign')];
                    }else{
                        solsComp= [SELECT Id, SysCodeAndCompCode__c,Fail_Code__c, CampaignLaborPercentage__c, CSS_Account_Formula__c, CoveredLaborHrs__c, Selected_Component__c, Type__c,FailCode_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =:claimsId and SysCodeAndCompCode__c!=null  and Type__c IN ('TRP','ATC','Campaign') and Selected_Component__c= true];
                    }
                }
                else{
                    if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){ 
                        solsComp= [SELECT Id, SysCodeAndCompCode__c,Fail_Code__c, CSS_Account_Formula__c,CoveredLaborHrs__c,CampaignLaborPercentage__c,Selected_Component__c,Type__c,FailCode_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =:claimsId and SysCodeAndCompCode__c!=null and Selected_Component__c= true and Type__c NOT IN ('TRP','ATC','Campaign') AND Over_The_Counter__c != true];
                    }else{
                        solsComp= [SELECT Id, SysCodeAndCompCode__c,Fail_Code__c, CampaignLaborPercentage__c, CSS_Account_Formula__c, CoveredLaborHrs__c, Selected_Component__c, Type__c,FailCode_Formula__c from CSS_Solution_Component__c where CSS_Claims__c =:claimsId and SysCodeAndCompCode__c!=null  and Type__c IN ('TRP','ATC','Campaign') and Selected_Component__c= true AND Over_The_Counter__c != true];
                    }
                }
            }
            options.add(new SelectOption('Select One','Select One'));
            system.debug('solCompList***'+solsComp);
            if(solsComp.size()>0){
                Set<string> acCodeSet;
                for(CSS_Solution_Component__c f: solsComp)  {
                    if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                        if(jobEventLst != null){
                            for(CSS_JobEventTemporary__c jobEntObj : jobEventLst){
                                if(jobEntObj.Account_Code__c == f.CSS_Account_Formula__c){
                                    coverageType = jobEntObj.Attribute1__c;
                                }
                            }
                        }
                        system.debug('coverageType***'+coverageType);
                    }
                    if(f.SysCodeAndCompCode__c !='Select One'){
                        //sortableSet.add(f.FailCode_Formula__c);
                        if(failAccountCodeMap.containsKey(f.Fail_Code__c)){
                            system.debug('**insidecontainkey**'+f.CSS_Account_Formula__c);
                            acCodeSet = failAccountCodeMap.get(f.Fail_Code__c);
                            if(f.CSS_Account_Formula__c != null && f.CSS_Account_Formula__c !='Select One' && f.CSS_Account_Formula__c !=''){
                                if(coverageType == 'OTH' || coverageType == 'POL'){
                                    sortableSet.add(f.FailCode_Formula__c);
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                else{
                                    if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                                        if(f.Type__c != 'TRP' && f.Type__c !='ATC' && f.Type__c !='Campaign'){
                                            if(f.CoveredLaborHrs__c != null && f.CoveredLaborHrs__c != '' && Double.valueOf(f.CoveredLaborHrs__c) >0 && f.Selected_Component__c== true){
                                                sortableSet.add(f.FailCode_Formula__c);
                                                acCodeSet.add(f.CSS_Account_Formula__c);
                                            }
                                        }
                                        else{ 
                                            if(f.CampaignLaborPercentage__c != null && f.CampaignLaborPercentage__c != '' && Double.valueOf(f.CampaignLaborPercentage__c) >0 ){
                                                sortableSet.add(f.FailCode_Formula__c);
                                                acCodeSet.add(f.CSS_Account_Formula__c);
                                            }
                                        }
                                    }
                                    else{
                                        if(f.CampaignLaborPercentage__c != null && f.CampaignLaborPercentage__c != '' && Double.valueOf(f.CampaignLaborPercentage__c) >0 ){
                                            sortableSet.add(f.FailCode_Formula__c);
                                            acCodeSet.add(f.CSS_Account_Formula__c);
                                        }
                                    }
                                }

                            }
                            system.debug('**acCodeSet*'+f.Fail_Code__c+'***'+acCodeSet);
                            //failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                            failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                        }else{
                            system.debug('**insidecontainkey---else');
                            acCodeSet = new Set<string>();
                            if(f.CSS_Account_Formula__c != null){
                                if(coverageType == 'OTH' || coverageType == 'POL'){
                                    sortableSet.add(f.FailCode_Formula__c);
                                    acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                else{
                                    if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                                        if(f.Type__c != 'TRP' && f.Type__c !='ATC' && f.Type__c !='Campaign'){
                                            if(f.CoveredLaborHrs__c != null && f.CoveredLaborHrs__c != '' && Double.valueOf(f.CoveredLaborHrs__c) >0 && f.Selected_Component__c== true){
                                                sortableSet.add(f.FailCode_Formula__c);
                                                acCodeSet.add(f.CSS_Account_Formula__c);
                                            }
                                        }
                                        else{ 
                                            if(f.CampaignLaborPercentage__c != null && f.CampaignLaborPercentage__c != '' && Double.valueOf(f.CampaignLaborPercentage__c) >0 ){
                                                sortableSet.add(f.FailCode_Formula__c);
                                                acCodeSet.add(f.CSS_Account_Formula__c);
                                            }
                                        }
                                    }
                                    else{
                                        if(f.CampaignLaborPercentage__c != null && f.CampaignLaborPercentage__c != '' && Double.valueOf(f.CampaignLaborPercentage__c) >0 ){
                                            sortableSet.add(f.FailCode_Formula__c);
                                            acCodeSet.add(f.CSS_Account_Formula__c);
                                        }
                                    }
                                }
                            }
                            system.debug('**acCodeSet*'+f.Fail_Code__c+'***'+acCodeSet);
                            failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                        }
                    }
                }
            }
            if(sortableSet.size()>0){
                sortable.AddAll(sortableSet);}
            sortable.sort();
            if (sortable.size()>0){
                for(String s:sortable)    
                {   
                    String[] tempStr;
                    if(s !='Select One'){
                        tempStr = s.split('-');
                        system.debug('***str***'+tempStr[1]);
                    } 
                    if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                       // options.add(new selectOption(tempStr[1],s));   //GSSC-271, commented to fix the issue and added below
                        options.add(new selectOption(tempStr[tempStr.size()-1],s));  
                       //options.add(new selectOption(s.Right(4),s));   //GSSC-271, this also works.
                       system.debug('S**'+s);
                       system.debug('Options**'+options);
                    }
                    else{
                        String s1 = s.RIGHT(6);
                        String sTemp = s1.LEFT(4);
                        String sTemp1 = s1.LEFT(6);
                        options.add(new selectOption(sTemp1,s));
                    }
                }   
            }
        }catch(Exception ex) {
            System.debug('in catch of fetchFailcodeDropDown>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return options;
    }
    
    public void onChangeofFailCode(){
        try{
            system.debug('in onChangeofFailCode');
            system.debug('selectedFailCode>>>>>>>>>>: '+selectedFailCode);
            system.debug('selectedSRTId>>>>>>>>>>: '+selectedSRTId);
            if(selectedFailCode.length()>4)
                //selectedFailCode = selectedFailCode.LEFT(4);
                selectedFailCode = selectedFailCode.LEFT(6);

            system.debug('selectedFailCode>>>>>>>>>>: '+selectedFailCode);
            List<SelectOption> options = getAccountCodeOptionList(selectedFailCode);
            system.debug('returned accode options>>:' +options);
            for(srtWrapperClass srtWrap : lstSelectedSRTWrapper){
                if(srtWrap.counting == selectedSRTId){
                    system.debug('matched selectedSRTId>>:' +selectedSRTId);
                    srtWrap.lstAccountCodes = options;
                    srtWrap.selectedAccountCode = srtAccCode;
                    break;
                }
            }

        }catch(Exception ex) {
            System.debug('in catch of onChangeofFailCode>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }

    }

    public List<SelectOption> getAccountCodeOptionList(String selectedFailCode){
        List<SelectOption> options;
        try{
            system.debug('failAccountCodeMap****'+failAccountCodeMap);
            options =  new List<SelectOption>();
            //options.add(new SelectOption('Select One','Select One'));
            String failCode1;
            String[] tempStr;
            if(selectedFailCode != null){
                if(selectedFailCode.contains('-')){
                    tempStr = selectedFailCode.split('-');
                    if(tempStr[1].length()>4){
                        failCode1=tempStr[1].LEFT(4);
                    }
                    else{
                        failCode1=tempStr[1];
                    }
                }
                else{
                    if(selectedFailCode.length()>4){
                        //failCode1=selectedFailCode.LEFT(4);
                        failCode1=selectedFailCode.LEFT(6);
                    }
                    else{
                        failCode1=selectedFailCode;
                    }
                }
            }
            if(failCode1==null || failAccountCodeMap ==null || failAccountCodeMap.size()<=0 || !failAccountCodeMap.containsKey(failCode1)){
                options.add(new SelectOption('Select One','Select One'));//Defect#152557 code added by Agassi
                return options;
            }

            List<string> sortable = new  List<string>();

            system.debug('**selectedFailCode**'+failCode1);

            if(failAccountCodeMap.containsKey(failCode1)){
                options.add(new SelectOption('Select One','Select One'));
                system.debug('**insidefailaccMap');
                Set<string> acCodeSet = failAccountCodeMap.get(failCode1);
                if(acCodeSet.size()>0){
                    sortable.AddAll(acCodeSet);}
                sortable.sort();
                if (sortable.size()>0){
                    if(sortable.size()==1){
                        srtAccCode=sortable[0];
                    }else{
                        srtAccCode='Select One';
                    }
                    for(String s:sortable){    
                        options.add(new selectOption(s,s));                    
                    }
                }
            }
            system.debug('***final ac options' + options);
        }catch(Exception ex) {
            System.debug('in catch of getAccountCodeOptionList>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return options;
    }


    public void GSQSRTMapPrepare() {
        try{
            system.debug('***inside GSQSRTMapPrepare');
            //SRT Groups validation code #162539 start
            if(!isAutomatedClaim)
                return; //returning here itself if it is manual claim

            Map<String, String> diagGSQMap = new Map<String, String>();
            List<CSS_Solutions__c> solutionList = new List<CSS_Solutions__c>([select Id,Name,Case_Name__c,Solution_Title__c,Service_Job__r.AccessCode__c,Service_Job__r.Equipment_ID__c,Service_Job__c,Diagnostic_Response__c,Repair_Response__c,Symptom__r.Name,FaultCode__r.Name,
                                                                              (select name,SRT_ID__c,Repair_Access_Calculated__c,Job_Order__r.Name,Job_Order__r.AccessCode__c,Additional_SRT_Calculated__c,Diagnosis_Time__c,SRT_Decimal_Time__c,id,step_id__c,SRT_Time__c,Component_Id__c ,Type__c,Response_Message__c ,Repair_Time__c,Access_Code_A__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,Assignment__c,SRT_Status_Message__c,SRT_Title__c ,isPerformed__c,ECM_Flag__c,SRT_Quantity__c,SRT_Notes__c ,SRT_Warrantable__c,
                                                                               Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Account_Code__c,FailCode__c,Access_Code_S1__c,Access_Code_S2__c,Access_Code_S3__c,Access_Code_S4__c,Access_Code_S5__c,Access_Code_S6__c,Access_Code_S7__c,Access_Code_S8__c,Access_Code_S9__c,S1_Description__c,S2_Description__c,S3_Description__c,S4_Description__c,Diag_Access_Time__c,
                                                                               S5_Description__c,SRT_Access_Code__c,Access_Code__c,S6_Description__c,S7_Description__c,S8_Description__c,S9_Description__c,Special_Access_Code__c,Special_Access_Code_Desc__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code_Saved__c,Extended_Hours__c,SRT_Estimate__c from CSS_SRTS__r where CSS_Claims__c=null order by SRT_Order__c asc)
                                                                              from CSS_Solutions__c where Service_Job__c=:jobId]);

            system.debug('solutionList size>>>:'+solutionList);
            //solutionList loop
            if(solutionList == null || solutionList.size()<=0)
                return;
            for(CSS_Solutions__c sol : solutionList){
                if(sol.Diagnostic_Response__c !=null && (sol.Diagnostic_Response__c == 'Most likely the solution' || sol.Diagnostic_Response__c == 'Not the solution') 
                   && sol.CSS_SRTS__r !=null && !sol.CSS_SRTS__r.isEmpty() ){
                    for(CSS_SRT__c srt : sol.CSS_SRTS__r){
                        if((srt.Type__c !=null && srt.Type__c.equalsIgnoreCase('Diagnosis')) ){ //|| srt.Type__c.equalsIgnoreCase('Diag Access')) && srt.Solution_Number__c == sol.id){
                            diagGSQMap.put(sol.Id, sol.Name);
                            break;
                        }
                    }
                }
            }
            system.debug('diagGSQMap>>>:'+diagGSQMap);

            if(diagGSQMap !=null && diagGSQMap.size()>0){
                List<CSS_Solution_Component__c> componentList = new List<CSS_Solution_Component__c>([select Id,Name,action__c,Component_Id__c,CampaignLaborPercentage__c, System_Code__c,Component_Code__c,AccountCode__c,Type__c,FailCode_Formula__c,AccountCodeEdit__c ,Fail_Code__c,Solutions__r.Diagnostic_Response__c,Fail_Code_Editable__c,CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredTowingMiles__c,CoveredTravelLabor__c,CoveredTravelMiles__c,Solutions__c,Solutions__r.id,Quantity__c,Service_Job__c,Service_Job__r.AccessCode__c,Selected_Component__c, Solutions__r.Repair_Response__c ,Solutions__r.Symptom__r.Name,Solutions__r.FaultCode__r.Name,CSS_Account_Formula__c 
                                                                                                     //(select name,SRT_ID__c,Job_Engine_Access_Code__c,Extended_Hours__c,Job_Order__r.Name,Job_Order__r.AccessCode__c,Repair_Access_Calculated__c,step_id__c,SRT_Time__c,Account_Code__c,FailCode__c,Type__c,Additional_SRT_Calculated__c,Repair_Time__c,SRT_AccessiblityCheck__c,Diag_Access_Time__c,Diagnosis_Time__c,SRT_Decimal_Time__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Component_Id__c ,Solution_Title__c,Solution_Number__c,Assignment__c,SRT_Title__c ,Response_Message__c ,isPerformed__c,SRT_Quantity__c,SRT_Notes__c ,SRT_Warrantable__c,SRT_Order__c,Access_Code__c,SRT_Estimate__c,Adjustment_Reason__c
                                                                                                     //from CSS_SRTS__r where CSS_Claims__c=null and Assignment__c IN ('Primary', 'Progressive Damage','Alternative') order by Assignment__c desc ) 
                                                                                                     from CSS_Solution_Component__c where CSS_Claims__c=:ClaimsId]); //Service_Job__c=:jobId and
                system.debug('componentList size>>>:'+componentList.size());
                if(componentList !=null && componentList.size()>0){
                    for(CSS_Solution_Component__c sc : componentList){
                        if(sc.Solutions__c !=null && sc.Type__c !='Campaign' && sc.Type__c !='TRP' && sc.Type__c !='ATC' 
                           && diagGSQMap !=null && diagGSQMap.containsKey(sc.Solutions__c)){
                            //failCodeGSQSRTMap.put(sc.FailCode_Formula__c, true);
                            if(sc.FailCode_Formula__c !=null && sc.FailCode_Formula__c.contains('-'))
                                failCodeGSQSRTMap.put(sc.FailCode_Formula__c.split('-')[1], sc.Solutions__c);
                        }
                    }
                }
            }
            system.debug('final...failCodeGSQSRTMap>:' + failCodeGSQSRTMap);
            //FaultCode check??

            //SRT Groups validation code #162539 end

        }catch(Exception ex) {
            System.debug('in catch of GSQSRTMapPrepare>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        system.debug('returning from GSQSRTMapPrepare...');
    }


    public void ValidateAdminSRT(){
        set<string> tempadmin=new set<string>();
        list<css_srt__c> existSRTList1=new list<css_srt__c>();
        existSRTList1=[select id, SRT_ID__c,Assignment__c,Admi_Check__c, IsPopUpSRT__c, Solution_Number__c, SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c, CSS_Claims__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,Flex_Flag__c,ECM_Flag__c,Access_Code__c FROM CSS_SRT__c where CSS_Claims__c =: claimsId and SRT_ID__c !='0'  and Assignment__c != 'NOT CLAIMABLE'];
        system.debug('existSRTList1 '+existSRTList1);
        if(existSRTList1.size()>0)
        {
            for(css_srt__c srtobj:existSRTList1)
            {
                system.debug('srtobj.SRT_ID__c '+srtobj.SRT_ID__c+''+lstFilteredSRT); 
                //if(srtobj.SRT_ID__c.contains('00-10S-00') || srtobj.SRT_ID__c.contains('00-724')|| srtobj.SRT_ID__c.contains('00-901') || srtobj.SRT_ID__c.contains('00-902') || srtobj.SRT_ID__c.contains('00-904') || srtobj.SRT_ID__c.contains('00-400') || srtobj.SRT_ID__c.contains('00-401') || srtobj.SRT_ID__c.contains('00-404')) 
                if(srtobj.SRT_ID__c!=null && srtobj.SRT_ID__c!='' && (srtobj.SRT_ID__c.contains('00-724')|| srtobj.SRT_ID__c.contains('00-901') || srtobj.SRT_ID__c.contains('00-902') || srtobj.SRT_ID__c.contains('00-904') || srtobj.SRT_ID__c.contains('00-400') || srtobj.SRT_ID__c.contains('00-401') || srtobj.SRT_ID__c.contains('00-404'))) 
                {

                    for(css_srt__c filtersrtobj:lstFilteredSRT)
                    {

                        if(filtersrtobj.SRT_ID__c == srtobj.SRT_ID__c){

                            if((srtobj.SRT_ID__c.contains('00-901') || srtobj.SRT_ID__c.contains('00-902') || srtobj.SRT_ID__c.contains('00-904')) && srtobj.IsPopUpSRT__c==false)
                            {
                                tempadmin.add('00-901-00');
                                tempadmin.add('00-902-00');
                                tempadmin.add('00-904-00');  
                            }

                            else if((srtobj.SRT_ID__c.contains('00-401') || srtobj.SRT_ID__c.contains('00-404') || srtobj.SRT_ID__c.contains('00-400') || srtobj.SRT_ID__c.contains('00-724')) && srtobj.IsPopUpSRT__c==false)
                            {
                                system.debug('srtobj.Assignment__c>'+srtobj.Assignment__c+'srtobj.SRT_ID__c>>'+srtobj.SRT_ID__c);
                                if(string.valueOf(srtobj.Assignment__c) != 'UNLISTED' && string.valueOf(srtobj.Assignment__c) != 'Not Applicable' && string.valueOf(srtobj.Assignment__c) != 'Unlisted' && string.valueOf(srtobj.Assignment__c) != 'NOT APPLICABLE')
                                    filtersrtobj.Admi_Check__c=true;
                            }
                            /* else if(srtobj.SRT_ID__c.contains('00-10S-00')){
                                filtersrtobj.Admi_Check__c=true;
                        }*/
                            else if((srtobj.SRT_ID__c.contains('00-401') || srtobj.SRT_ID__c.contains('00-404') || srtobj.SRT_ID__c.contains('00-400') || srtobj.SRT_ID__c.contains('00-724') || srtobj.SRT_ID__c.contains('00-901') || srtobj.SRT_ID__c.contains('00-902') || srtobj.SRT_ID__c.contains('00-904')) && srtobj.IsPopUpSRT__c==true)
                            {
                                filtersrtobj.Admi_Check__c=true;
                            }
                            else
                            {
                                if(removedSRTCode.size()>0 && removedSRTCode.contains(srtobj.SRT_ID__c))
                                    filtersrtobj.Admi_Check__c=true;
                            }

                        }
                        else{

                            if(filtersrtobj.SRT_ID__c.contains('00-901') || filtersrtobj.SRT_ID__c.contains('00-902') || filtersrtobj.SRT_ID__c.contains('00-904')){
                                if((srtobj.SRT_ID__c.contains('00-901') || srtobj.SRT_ID__c.contains('00-902') || srtobj.SRT_ID__c.contains('00-904')) && srtobj.IsPopUpSRT__c==false){
                                    tempadmin.add('00-901-00');
                                    tempadmin.add('00-902-00');
                                    tempadmin.add('00-904-00');  
                                }
                                else{
                                    if(removedSRTCode.size()>0 && removedSRTCode.contains(filtersrtobj.SRT_ID__c))
                                        filtersrtobj.Admi_Check__c=true;
                                }
                            }

                            /*else if(filtersrtobj.SRT_ID__c=='00-10S-00')
 {
      filtersrtobj.Admi_Check__c=true;
 }*/
                            else
                            {
                                if(removedSRTCode.size()>0 && removedSRTCode.contains(filtersrtobj.SRT_ID__c))
                                    filtersrtobj.Admi_Check__c=true;
                            }

                        }
                    }
                }

            }

            if(tempadmin.size()>0)
            {

                for(css_srt__c filtersrtobj1:lstFilteredSRT)
                {
                    system.debug('filtersrtobj1'+filtersrtobj1);
                    if(tempadmin.contains(filtersrtobj1.SRT_ID__c)){
                        filtersrtobj1.Admi_Check__c=true;
                    }

                }
            }
        }
    }

    public void SelectedSRTAdminVal()
    {
        for(srtWrapperClass srtwrap:lstSelectedSRTWrapper)
        {
            if(srtwrap.srtCode.contains('00-10S-00') || srtwrap.srtCode.contains('00-724')|| srtwrap.srtCode.contains('00-901') || srtwrap.srtCode.contains('00-902') || srtwrap.srtCode.contains('00-904') || srtwrap.srtCode.contains('00-400') || srtwrap.srtCode.contains('00-401') || srtwrap.srtCode.contains('00-404')){
                for(css_srt__c filtersrtobj:lstFilteredSRT){
                    if(filtersrtobj.SRT_ID__c == srtwrap.srtCode)
                        filtersrtobj.Admi_Check__c=true;

                }
            }

        }
    }


    /*public List<SelectOption> getAccountCodeDropDown1() {
        List<SelectOption> options =  new List<SelectOption>();
        try{
            system.debug('***inside getaccountcodedropdown');
            List<string> sortable = new  List<string>();
            options.add(new SelectOption('Select One','Select One'));
            system.debug('***inside options' + options);
            system.debug('****seleFailCode>>:'+seleFailCode);
            if(failAccountCodeMap ==null || failAccountCodeMap.size()<=0 || seleFailCode==null)
                return options;

            if(failAccountCodeMap.containsKey(seleFailCode)){
                Set<string> acCodeSet = failAccountCodeMap.get(seleFailCode);
                if(acCodeSet.size()>0){
                    sortable.AddAll(acCodeSet);}
                sortable.sort();
                if (sortable.size()>0){
                    for(String s:sortable){    
                        options.add(new selectOption(s,s));                    
                    }   
                }
            }
            system.debug('***inside options' + options);
        }catch(Exception ex) {
            System.debug('in catch of getAccountCodeDropDown1>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return options;
    }*/


    /*public List<SelectOption> getAccountCodeDropDown() {
        List<SelectOption> options =  new List<SelectOption>();
        Set<string> sortableSet = new  Set<string>();
        List<string> sortable = new  List<string>();
        String acccode;
        List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
        system.debug('ClaimsId****'+claimsId);
        if(claimsId !=null && (accordionType == 'Diagnosis' || accordionType == 'Repair')){
            solsComp= [SELECT Id, AccountCodeEdit__c,AccountCode__c, Service_Job__c,Type__c from CSS_Solution_Component__c where CSS_Claims__c =:claimsId and FailCode_Formula__c!=null and Type__c NOT IN ('TRP','ATC','Campaign')]; //and Selected_Component__c= true];    
        }
        else{
            solsComp= [SELECT Id, AccountCodeEdit__c,AccountCode__c, Service_Job__c,Type__c from CSS_Solution_Component__c where CSS_Claims__c =:claimsId and FailCode_Formula__c!=null and Type__c IN ('TRP','ATC','Campaign')]; //and Selected_Component__c= true];    
        }
        options.add(new SelectOption('Select One','Select One'));
        system.debug('solCompList***'+solsComp);
        if(solsComp.size()>0){
            for(CSS_Solution_Component__c f:solsComp)  {
                if(f.AccountCode__c != null){
                    if(f.AccountCode__c!='Select One')
                        sortableSet.add(f.AccountCode__c);
                }
                else if (f.AccountCodeEdit__c != null){
                    if(f.AccountCodeEdit__c!='Select One')
                        acccode = f.AccountCodeEdit__c; //f.AccountCodeEdit__c.RIGHT(2);
                    sortableSet.add(acccode);                    
                }

            }
        }
        if(sortableSet.size()>0){
            sortable.AddAll(sortableSet);}
        sortable.sort();
        if (sortable.size()>0){
            for(String s:sortable)    
            {    
                options.add(new selectOption(s,s));                    
            }   
        }
        return Options;      
    } */
    public void checkDuplicateSRTs(){
        system.debug('insidecheckdup****');
        system.debug('lstSelectedSRTWrapper****'+lstSelectedSRTWrapper.size()+'*****'+lstSelectedSRTWrapper);
        //system.debug('lstFilteredSRT****'+lstFilteredSRT.size()+'*****'+lstFilteredSRT);
        List<String> excludeSRTsDuplicateCheckList = new List<String>();
        String ESRTDCLValues = Label.CG_ExcludeSRTsDuplicateCheck;
        list<CSS_srt__c> lstSRTDupCheck = new list<CSS_srt__c>();
        if(ESRTDCLValues != null && ESRTDCLValues != '') {
            excludeSRTsDuplicateCheckList = ESRTDCLValues.split(',');
        }
        SRTID=new Set<String>();
        lstSRTDupCheck=[select name,SRT_ID__c,Job_Order__r.Name,id,step_id__c,Component_Id__c ,Type__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c,Flex_Flag__c,ECM_Flag__c from CSS_SRT__c where SRT_ID__c != '' and SRT_ID__c != '0' and css_claims__c =: claimsId AND (((solution_number__c != null and solution_number__r.Diagnostic_Response__c!=null and (Type__c IN ('Diagnosis','Diag Access') and (srt_category__c = null or srt_category__c = '')))or(srt_category__c!= null and srt_category__c = 'AdditionalDiag') or (solution_number__c=null and ((Type__c IN ('Repair','Repair Access') and srt_category__c = null and  Assignment__c = 'Diagnostic')))) or ((Assignment__c IN ('Primary', 'Progressive Damage','Alternative') OR Assignment__c = Null) and (((solution_number__r.Diagnostic_Response__c!=null and solution_number__r.Diagnostic_Response__c = 'Most likely the solution') and (Type__c != null and Type__c != '' and Type__c IN ('Repair','Repair Access') and srt_category__c = null)) or (srt_category__c!= null and srt_category__c = 'AdditionalRep') or (solution_number__c=null and ((Type__c IN ('Repair' ,'Repair Access') and srt_category__c = null and (Assignment__c!='Diagnostics' or Assignment__c!='DIAGNOSTIC')))))) or ((Assignment__c != 'NOT CLAIMABLE' and ((Type__c != null and Type__c != '' and Type__c = 'Field Action' and (srt_category__c = null or srt_category__c = '') and srt_type__c IN ('Campaign','TRP','ATC')) or (Type__c != null and Type__c != '' and Type__c = 'Field Action Access' and Component_Id__r.type__c IN ('Campaign','TRP','ATC')) or (srt_category__c!= null and srt_category__c!= '' and srt_category__c IN ('Campaign','TRP','ATC'))))))];

        if(lstSRTDupCheck!=null && lstSRTDupCheck.size()>0){
            for(CSS_srt__c srtObj:lstSRTDupCheck){
                SRTID.add(srtObj.SRT_ID__c.LEFT(6));
            }
        }
        system.debug('ALreadypresentSRTID****'+'*****'+SRTIDs);
        if(lstFilteredSRT != null && lstFilteredSRT.size() > 0){
            for(css_srt__c srtObj : lstFilteredSRT){
                String temp = srtObj.SRT_ID__c != null && srtObj.SRT_ID__c != '' ? srtObj.SRT_ID__c.LEFT(6) : '';
                if(lstSelectedSRTWrapper != null && lstSelectedSRTWrapper.size() > 0){
                    for(srtWrapperClass srt : lstSelectedSRTWrapper){
                        String temp1 = srt.srtCode != null && srt.srtCode != '' ? srt.srtCode.LEFT(6) : '';
                        if(((SRTID != null && SRTID.contains(temp)) || temp == temp1) && srtObj.srt_select__c == true && excludeSRTsDuplicateCheckList != null && !(excludeSRTsDuplicateCheckList.contains(temp))){
                            system.debug('***dupfound---lstSelectedSRTWrapper***'+'**srtcode***'+srt.srtCode.LEFT(6)+'***srtid***'+srtObj.SRT_ID__c.LEFT(6));
                            srtObj.IsDuplicateSRT__c = true;
                        }
                        else{
                            system.debug('***dupfound---indiedelse2lstFilteredSRT*');
                            srtObj.IsDuplicateSRT__c = false;
                        }
                    }
                }
                else{
                    if((SRTID != null && SRTID.contains(temp)) && srtObj.srt_select__c == true && excludeSRTsDuplicateCheckList != null && !(excludeSRTsDuplicateCheckList.contains(temp))){
                        srtObj.IsDuplicateSRT__c = true;
                    }
                    else{
                        system.debug('***dupfound---indiedelse2lstFilteredSRT*');
                        srtObj.IsDuplicateSRT__c = false;
                    }
                }
                system.debug('***srtObj.IsDuplicateSRT__c**'+srtObj.IsDuplicateSRT__c);
                //system.debug('***dupSRTFound**'+dupSRTFound);

            }
            for(CSS_srt__c srtRec: lstFilteredSRT){
                if(srtRec.IsDuplicateSRT__c==true){
                    dupSRTFound=true;
                    break;
                }
                else
                    dupSRTFound=false;
            }
        }
        system.debug('***dupSRTFound**'+dupSRTFound);

    }
    //Added as part of the story GSSC-82
    public void getErrorDetails(){
        try{
            if(CG_CL_ClaimsSRTEditPopUp.serviceFailed){
                insert errorDetail;
            } 
        }catch(exception e){

        }

    }
    public class srtWrapperClass {
        public Integer counting {get;set;}
        public Id id {get;set;}
        public Id claimsId {get;set;}
        public String srtCode {get;set;}
        public String srtDesc {get;set;}
        public Integer quantity {get;set;}
        public String stepId {get;set;}
        public list<SelectOption> lstFailCodes{get;set;}
        public list<SelectOption> lstAccountCodes{get;set;}
        public String selectedFailCode {get;set;}
        public String selectedAccountCode {get;set;}
        //public String type {get;set;}
        public String srtType {get;set;}
        public String accordionType {get;set;}
        public Boolean mandateFailCode{get;set;}
        public Boolean mandateAccCode{get;set;}
        public Decimal accessCodeA{get;set;}
        public Decimal accessCodeB{get;set;}
        public Decimal accessCodeC{get;set;}
        public Decimal accessCodeD{get;set;}
        public Decimal accessCodeR{get;set;}
        public Decimal SRTTime {get;set;} 
        public string AccessCode {get;set;} //Kalpana, Added as per defect 165357
        public string solNumber {get;set;}
        public Boolean isPopupSRT {get;set;}
        public Boolean isUserEntered {get;set;}
        public String srtWarrantable {get;set;}
        public Boolean FlexFlag{get;set;}
        public Boolean ecmFlag{get;set;}

        public srtWrapperClass(Integer counting,Id id,Id claimsId,String srtCode,String srtDesc,Integer quantity,String stepId,list<SelectOption> lstFailCodes,list<SelectOption> lstAccountCodes,String selectedFailCode,String selectedAccountCode,String srtType,String accordionType,Decimal accessCodeA,Decimal accessCodeB,Decimal accessCodeC,Decimal accessCodeD,Decimal accessCodeR,Decimal SRTTime,string AccessCode,string solNumber, Boolean isPopupSRT,Boolean isUserEntered,string srtWarrantable,Boolean FlexFlag,Boolean ecmFlag){
            this.counting = counting;
            this.id = id;
            this.claimsId = claimsId;
            this.srtCode = srtCode;
            this.srtDesc = srtDesc;
            this.quantity = quantity;
            this.stepId = stepId;
            this.lstFailCodes = lstFailCodes;
            this.lstAccountCodes = lstAccountCodes;
            this.selectedFailCode = selectedFailCode;
            this.selectedAccountCode = selectedAccountCode;
            //this.type = type;
            this.srtType = srtType;
            this.accordionType = accordionType;
            this.mandateFailCode = mandateFailCode;
            this.mandateAccCode = mandateAccCode;
            this.accessCodeA = accessCodeA;
            this.accessCodeB = accessCodeB;
            this.accessCodeC = accessCodeC;
            this.accessCodeD = accessCodeD;
            this.accessCodeR = accessCodeR;
            this.SRTTime = SRTTime;
            this.AccessCode = AccessCode;
            this.solNumber = solNumber;
            this.isPopupSRT = isPopupSRT;
            this.isUserEntered = isUserEntered;
            this.srtWarrantable = srtWarrantable;
            this.FlexFlag = FlexFlag;
            this.ecmFlag = ecmFlag;
        }        
    }
}