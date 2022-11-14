/**********************************************************************
Name: css_srtEditPopupController
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This class is used for SRT Edit Popup functionalities
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                    DATE                DETAIL                                 
1.0     Surender M/Arpita        08/06/2018     INITIAL DEVELOPMENT & Implementation of SRT Edit Popup functionalities
***********************************************************************/
public class css_srtEditPopupController{

    public string searchDiagValue{get;set;}
    public Boolean selectedAccess{get;set;}
    public Boolean selectedAdmin{get;set;}
    public Boolean selectedDiag{get;set;}
    public Boolean selectedRepair{get;set;}
    public String selectedPickVal{get;set;}

    public String JobId;
    //public String claimsId;
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
    //Set<Id> srtIDs = new Set<Id>();
    Map<String,CSS_srt__c> srtRemoveMap = new Map<String,CSS_srt__c>();
    List<CSS_Srt__c> existSRTList = new List<CSS_Srt__c>();
    public Map<String,Set<String>> failAccountCodeMap{get;set;}
    //public List<CSS_JobEventTemporary__c> jobEventLst;
    // public String coverageType;
    //public boolean isDealer;
    //Map<String,srtWrapperClass> srtWrapperSave = new Map<String,srtWrapperClass>();
    Boolean removeRow;
    Integer i=0;
    Set<String> removedKeySet;
    Set<String> removedSRTCode;
    public Boolean isAutomatedClaim{get;set;}
    public String accessCode{get;set;}

    public List<CSS_srt__c> lstPrivateSRT{get;set;} //Private SRT List
    public Map<String,Set<String>> srtIdFcodeAssignmentMap{get;set;}
    public Map<String,Set<String>> srtIdFcodeAssignmentMapRep{get;set;}
    public list<CSS_JobEventTemporary__c> JETFA{get;set;}
    public Map<String,CSS_JobEventTemporary__c> accCodeMapJET = new Map<String,CSS_JobEventTemporary__c>();
    public Boolean srtNotAllowedErr{get;set;}
    public Boolean LaborRateCheck{get;set;}
    public Map<String, String> failCodeGSQSRTMap = new Map<String, String>();
    public Boolean GSQErrorExists{get;set;}
    Set<String> SRTIDs;
    public Boolean dupSRTFound{get;set;}

    public Static Boolean serviceFailed{get;set;} //Added as part of the story GSSC-82
    public Static CSS_Integration_Error__c errorDetail{get;set;} //Added as part of the story GSSC-82
    public css_srtEditPopupController()
    {
        try{
            errorDetail = new CSS_Integration_Error__c(); //Added as part of the story GSSC-82
            serviceFailed = false; //Added as part of the story GSSC-82
            system.debug('serviceFailed***'+serviceFailed);
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
            LaborRateCheck=false;
            JobId=ApexPages.CurrentPage().getParameters().get('JobOrderId');
            //claimsId=ApexPages.CurrentPage().getParameters().get('ClaimsId');
            Typ=ApexPages.CurrentPage().getParameters().get('type');
            accordionType=ApexPages.CurrentPage().getParameters().get('type');
            pgName = ApexPages.CurrentPage().getParameters().get('pgName');
            system.debug('JobId>>>:'+JobId);
            system.debug('accordionType>>>:'+accordionType);
            system.debug('pgName*'+pgName);
            dupSRTFound=false;
            //isDealer = false;
            //css_header_nav__c cssHeaderObject = css_header_nav__c.getInstance();
            //system.debug('cssHeaderObject--- ' + cssHeaderObject);
            //if(cssHeaderObject != null)
            //isDealer = cssHeaderObject.RSWButtonEnable__c;


            JETFA = new list<CSS_JobEventTemporary__c>();
            JETFA = [select id,Attribute1__c,Attribute2__c,Attribute3__c,key__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes'];
            for(CSS_JobEventTemporary__c jet : JETFA){
                string temp = jet.Attribute2__c+jet.Attribute3__c; 
                if(!accCodeMapJET.containskey(temp))
                    accCodeMapJET.put(temp,jet);
            }


            lstDisplaySRT = new List<css_srt__c>();
            if(JobId != null){
                List<CSS_Job_Order__c> jobRecList = new List<CSS_Job_Order__c>([Select Id ,Name,CSS_In_Shop_Labor_Rate__c, AccessCode__c from CSS_Job_Order__c where Id=:JobId]);
                if(jobRecList !=null && jobRecList.size()>0){
                    // isAutomatedClaim = true;
                    accessCode = jobRecList.get(0).AccessCode__c;
                    if(string.isNotBlank(jobRecList[0].CSS_In_Shop_Labor_Rate__c) && jobRecList[0].CSS_In_Shop_Labor_Rate__c!='0')
                        LaborRateCheck=false;
                    else
                        LaborRateCheck=true;
                }

                //jobEventLst = [select Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c,Account_Code__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes'];
                // system.debug('jobEventLst*size***'+jobEventLst.size());

                failCodes = getfailcodeDropDown();
                loadSavedSRTs();
                if(!Test.isRunningTest()){
                	lstDisplaySRT = CSS_WS_SRT.getAllDigRepSRTs(JobId,'');
                }
                //lstDisplaySRT = CSS_WS_SRT.getAllClaimsDigRepSRTs(claimsId,'');
                system.debug('lstDisplaySRT**'+lstDisplaySRT+'size**'+lstDisplaySRT.size());
                //  for(i=0;i<lstDisplaySRT.size();i++){
                //system.debug('***srtid***'+lstDisplaySRT[i].SRT_ID__c);
                // system.debug('***accesscode***'+lstDisplaySRT[i].Access_Code__c);

                //}
                if(!Test.isRunningTest()){
                	lstPrivateSRT = CG_BL_BMS.getBMSPrivateSRTs(JobId); //Private SRT List
                }
                //system.debug('lstPrivateSRT size>>:'+lstPrivateSRT.size());

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
                            (Component_Id__r.Type__c IN ('Campaign','TRP','ATC') OR (Type__c = 'Repair' AND Component_Id__c != null)) and Job_Order__c =:JobId];
                system.debug('****'+srtlstUI.size());*/ // Variable seems to be not used anywhere, hence commenting
                srtIdFcodeAssignmentMap = new Map<String,Set<String>>();
                srtIdFcodeAssignmentMapRep = new Map<String,Set<String>>();
                List<CSS_Solution_Component__c> failureAndCamp = new List<CSS_Solution_Component__c>();
                failureAndCamp = [SELECT Id, Fail_Code__c, SysCodeAndCompCode__c, Type__c, (SELECT Id, SRT_ID__c, Assignment__c, Component_Id__c, FailCode__c FROM CSS_SRTs__r) FROM CSS_Solution_Component__c WHERE Service_Job__c =:JobId];
                system.debug('****failureAndCamp***'+failureAndCamp);
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
            System.debug('in catch of Css_srtEditPopUp constructor>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage()); 
        }    
    }


    public void loadSavedSRTs(){
        system.debug('*****inside loadSavedSRTs****');
        try{
            removedKeySet = new Set<String>();
            removedSRTCode=new set<string>();
            lstSelectedSRTWrapper = new list<srtWrapperClass>();
            //load existing saved SRTs
            if(accordionType == 'AdditionalDiag'){
                //existSRTList = new List<CSS_Srt__c>([select id, SRT_ID__c,Admi_Check__c,IsPopUpSRT__c,isPerformed__c,SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c,Job_Order__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c FROM CSS_SRT__c where Job_Order__c =: JobId and isPerformed__c=true and ((Type__c = 'Diagnosis' OR Type__c = 'Diag Access') OR (SRT_Category__c = 'AdditionalDiag' OR Assignment__c = 'DIAGNOSTIC'))]);
               // existSRTList = new List<CSS_Srt__c>([select id,Solution_Number__c, SRT_ID__c, Flex_Flag__c,ECM_Flag__c,Admi_Check__c,IsPopUpSRT__c,isPerformed__c,SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c,Job_Order__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c where Job_Order__c =: JobId and (isPerformed__c=true OR SRT_AccessiblityCheck__c=true) and SRT_ID__c !='0' and (((Type__c = 'Diagnosis' OR Type__c = 'Diag Access')  AND (SRT_Category__c NOT IN('Campaign','ATC','TRP','AdditionalRep') OR SRT_Category__c=:accordionType)))]); //OR (SRT_Category__c = 'AdditionalDiag' OR Assignment__c = 'DIAGNOSTIC')
               existSRTList = new List<CSS_Srt__c>([select id,Solution_Number__c,Assignment__c, SRT_ID__c, Flex_Flag__c,ECM_Flag__c,Admi_Check__c,IsPopUpSRT__c,isPerformed__c,SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c,Job_Order__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c where Job_Order__c =: JobId and (isPerformed__c=true OR SRT_AccessiblityCheck__c=true) and SRT_ID__c !='0' and (((Type__c = 'Diagnosis' OR Type__c = 'Diag Access') OR (Assignment__c='DIAGNOSTIC') OR (SRT_Category__c NOT IN('Campaign','ATC','TRP','AdditionalRep') AND SRT_Category__c=:accordionType)))]); //OR (SRT_Category__c = 'AdditionalDiag' OR Assignment__c = 'DIAGNOSTIC') //Added 'OR' condition in b/w Type__c and SRT_Category__c as per Defect#GSSC-594
          
            }
            else if(accordionType == 'AdditionalRep'){
                //   existSRTList = new List<CSS_Srt__c>([select id, SRT_ID__c,Admi_Check__c,IsPopUpSRT__c,isPerformed__c,SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c,Job_Order__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,SRT_AccessiblityCheck__c FROM CSS_SRT__c where Job_Order__c =: JobId and (isPerformed__c=true OR SRT_AccessiblityCheck__c=true) and SRT_ID__c !='0' and (Type__c = 'Repair' OR Type__c = 'Repair Access')  AND (SRT_Category__c NOT IN('Campaign','ATC','TRP','AdditionalDiag') OR SRT_Category__c=:accordionType)]);
                existSRTList = new List<CSS_Srt__c>([select id,Solution_Number__c, SRT_ID__c,Admi_Check__c, Flex_Flag__c,ECM_Flag__c,IsPopUpSRT__c,isPerformed__c,SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c,Job_Order__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,SRT_AccessiblityCheck__c,component_id__c,Component_Id__r.CSS_Account_Formula__c FROM CSS_SRT__c where Job_Order__c =: JobId and (isPerformed__c=true OR SRT_AccessiblityCheck__c=true) and SRT_ID__c !='0' and Assignment__c != 'DIAGNOSTIC' and (((Type__c = 'Repair' OR Type__c = 'Repair Access')  AND (SRT_Category__c NOT IN('Campaign','ATC','TRP','AdditionalDiag') OR SRT_Category__c=:accordionType)) OR (SRT_Category__c = 'AdditionalRep'))]); 
            }
            else if(accordionType == 'Campaign'){
                existSRTList = new List<CSS_Srt__c>([select id,Solution_Number__c, SRT_ID__c,Admi_Check__c, Flex_Flag__c,ECM_Flag__c,IsPopUpSRT__c,isPerformed__c,SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c,Job_Order__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,SRT_AccessiblityCheck__c,Component_Id__c,Component_Id__r.Type__c FROM CSS_SRT__c where Job_Order__c =: JobId and (isPerformed__c=true OR SRT_AccessiblityCheck__c=true) and SRT_ID__c !='0' and ((srt_type__c = 'Campaign' and Component_Id__r.Performed_Review__c = true) OR SRT_Category__c=:accordionType OR ((Type__c = 'Field Action' OR Type__c = 'Field Action Access') and Component_Id__r.Type__c='CAMPAIGN') )]); // and Component_Id__r.Performed_Review__c = true  -- Added query cond. as part of 189389 -- Modified the performed condition  as per defect 190631
            }
            else if(accordionType == 'TRP'){
                existSRTList = new List<CSS_Srt__c>([select id,Solution_Number__c, SRT_ID__c,Admi_Check__c, Flex_Flag__c,ECM_Flag__c,IsPopUpSRT__c,isPerformed__c,SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c,Job_Order__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,SRT_AccessiblityCheck__c,Component_Id__c,Component_Id__r.Type__c FROM CSS_SRT__c where Job_Order__c =: JobId and (isPerformed__c=true OR SRT_AccessiblityCheck__c=true)  and SRT_ID__c !='0' and ((srt_type__c = 'TRP' and Component_Id__r.Performed_Review__c = true) OR SRT_Category__c=:accordionType OR ((Type__c = 'Field Action' OR Type__c = 'Field Action Access') and Component_Id__r.Type__c='TRP') )]); //-- Modified the performed condition  as per defect 190631
            }
            else if(accordionType == 'ATC'){
                existSRTList = new List<CSS_Srt__c>([select id,Solution_Number__c, SRT_ID__c,Admi_Check__c, Flex_Flag__c,ECM_Flag__c,IsPopUpSRT__c,isPerformed__c,SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c,Job_Order__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c,SRT_AccessiblityCheck__c,Component_Id__c,Component_Id__r.Type__c FROM CSS_SRT__c where Job_Order__c =: JobId and (isPerformed__c=true OR SRT_AccessiblityCheck__c=true) and SRT_ID__c !='0' and ((srt_type__c = 'ATC' and Component_Id__r.Performed_Review__c = true) OR SRT_Category__c=:accordionType OR ((Type__c = 'Field Action' OR Type__c = 'Field Action Access') and Component_Id__r.Type__c='ATC') )]); //-- Modified the performed condition  as per defect 190631
            }
            else{
                existSRTList = new List<CSS_Srt__c>([select id,Solution_Number__c, SRT_ID__c,Admi_Check__c, Flex_Flag__c,ECM_Flag__c,IsPopUpSRT__c,SRT_Title__c,Step_Id__c,SRT_Category__c,Type__c,SRT_Type__c,FailCode__c, Account_Code__c, SRT_Quantity__c,Job_Order__c,Access_Code__c,Access_Code_A__c,Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,SRT_Time__c FROM CSS_SRT__c where Job_Order__c =: JobId and SRT_Category__c=:accordionType]);
            }
            i=0;
            system.debug('*****existSRTList****'+existSRTList);
            if(existSRTList ==null || existSRTList.size()<=0)
                return;

            List<SelectOption> options =  new List<SelectOption>();
            /*options.add(new SelectOption('Select One','Select One'));*/
            for(CSS_Srt__c srtObj :existSRTList){
                i=i+1;
                //options = getAccountCodeOptionList(srtObj.FailCode__c);
                system.debug('srtObj.SRT_ID__c**'+srtObj.SRT_ID__c+'srtObj.FailCode__c>>>:'+srtObj.FailCode__c+' options>>>:'+options);
                string failcode;
                /*if(srtObj.FailCode__c != null && srtObj.FailCode__c != '')
                failcode=srtObj.FailCode__c.RIGHT(4);
                else 
                failcode='';*/
                //failcode='WUSS';
                if(srtObj.FailCode__c != null && srtObj.FailCode__c != '' && (!srtObj.FailCode__c.contains('-') && srtObj.FailCode__c.length()<=4)){
                    /* if(srtObj.FailCode__c.length()>4)
                      failcode=srtObj.FailCode__c.LEFT(6);
                      else*/
                    system.debug('insideif**');
                    failcode=srtObj.FailCode__c.LEFT(4);
                }
                else if(srtObj.FailCode__c != null && srtObj.FailCode__c != '' && (srtObj.FailCode__c.contains('-') || srtObj.FailCode__c.length()>4 )){
                    system.debug('insideelse**');
                    if(srtObj.FailCode__c.contains('-')){
                        string[] failcodeswith = srtObj.FailCode__c.split('-');
                        if(failcodeswith != null && failcodeswith.size()>0){
                            if(failcodeswith[1].length()>4)
                                failcode=failcodeswith[1].RIGHT(6);
                            else
                                failcode=failcodeswith[1].RIGHT(4);
                        }
                    }
                    else{
                        failcode=srtObj.FailCode__c.LEFT(6);
                    }
                }
                else
                    failcode='';
                system.debug('failcode'+failcode);
                if(failcode!=null && failcode!=''){
                    if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                        options = getAccountCodeOptionList(failcode.LEFT(4));
                    }
                    else{
                        options = getAccountCodeOptionList(failcode);
                    }
                }
                else
                    options = getAccountCodeOptionList(failcode);

                string SRTType;
                if(srtObj.Type__c != 'Field Action'){
                    if(srtObj.SRT_Type__c != null && srtObj.SRT_Type__c != '')
                        SRTType = srtObj.SRT_Type__c;
                    else
                        SRTType = srtObj.Type__c;
                }
                else
                    SRTType = srtObj.SRT_Type__c;
                system.debug('SRTType$$$$'+SRTType);

                lstSelectedSRTWrapper.add(new srtWrapperClass(i, 
                                                              srtObj.Id,
                                                              srtObj.Job_Order__c,
                                                              srtObj.SRT_ID__c,
                                                              srtObj.SRT_Title__c,
                                                              Integer.valueOf(srtObj.SRT_Quantity__c),
                                                              srtObj.Step_Id__c,
                                                              null,
                                                              options,
                                                              //srtObj.FailCode__c,
                                                              failcode,
                                                              //srtObj.Account_Code__c != null && srtObj.Account_Code__c != ''?srtObj.Account_Code__c:srtObj.Component_Id__r.CSS_Account_Formula__c,
                                                              srtObj.Account_Code__c,
                                                              //srtObj.Type__c,
                                                              //srtObj.SRT_Type__c,
                                                              SRTType,
                                                              accordionType,
                                                              srtObj.Access_Code__c,
                                                              srtObj.Access_Code_A__c,
                                                              srtObj.Access_Code_B__c,
                                                              srtObj.Access_Code_C__c,
                                                              srtObj.Access_Code_D__c,
                                                              srtObj.Access_Code_R__c,
                                                              srtObj.SRT_Time__c,
                                                              srtObj.IsPopUpSRT__c,
                                                              srtObj.SRT_AccessiblityCheck__c,
                                                              srtObj.Flex_Flag__c,
                                                              srtObj.Solution_Number__c,
                                                              srtObj.ECM_Flag__c));
            }
            system.debug('lstSelectedSRTWrapper****'+lstSelectedSRTWrapper);
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
                ValidateAdminSRT();
            }
        }catch(Exception ex) {
            System.debug('in catch of searchDiagSRTCodeAndDescription>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }

    }

	public List<CSS_Solution_Component__c> lstSolCompTest = new List<CSS_Solution_Component__c>();
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
            //GSSC-297 - START
            list<CSS_Solution_Component__c> lstSolComp = new list<CSS_Solution_Component__c>();
            
            if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                //Added Root_Cause__c field and condition Root_Cause__c = true in where clause in below query as part of the story GSSC-385(User story 4)
                lstSolComp = [SELECT Id,Type__c,In_Shop_SRT_Limit_Flag__c,CSS_CoverageType__c, Root_Cause__c, SysCodeAndCompCode__c, Fail_Code__c, CSS_Account_Formula__c, Solutions__c, CoveredLaborHrs__c, CampaignLaborPercentage__c, Selected_Component__c,FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =:JobId and SysCodeAndCompCode__c!=null and Selected_Component__c= true and Type__c NOT IN ('TRP','ATC','Campaign') AND Root_Cause__c = true ORDER BY CSS_Failure_Sequence_Number__c ASC]; //and Selected_Component__c= true];    
            }else{
                lstSolComp = [SELECT Id,Type__c,In_Shop_SRT_Limit_Flag__c, CSS_CoverageType__c,SysCodeAndCompCode__c, Fail_Code__c, CSS_Account_Formula__c, Solutions__c, CoveredLaborHrs__c, CampaignLaborPercentage__c, Selected_Component__c,FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =:JobId and SysCodeAndCompCode__c!=null and Type__c IN ('TRP','ATC','Campaign') and Performed_Review__c = true ORDER BY CSS_Failure_Sequence_Number__c ASC]; //and Selected_Component__c= true];    
            }
            if(Test.isRunningTest()){
                lstSolComp.addAll(lstSolCompTest);
            }
            Set<String> accCodeSet = new Set<String>();
            for(CSS_Solution_Component__c sc : lstSolComp){
                if(sc.CSS_Account_Formula__c != null && sc.CSS_Account_Formula__c != '' && sc.CSS_Account_Formula__c != 'Select One' && !accCodeSet.contains(sc.CSS_Account_Formula__c)){
                    accCodeSet.add(sc.CSS_Account_Formula__c);
                }
            }
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
            /*if(lstSolComp.size() > 0 && lstSolComp[0].FailCode_Formula__c.contains('-')){
                tempStr = lstSolComp[0].FailCode_Formula__c.split('-');
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
                failCode1=lstSolComp.size() > 0 ? lstSolComp[0].FailCode_Formula__c : '';
            } 
            if((lstSolComp != null && lstSolComp.size()==1) || (accCodeSet != null && accCodeSet.size() == 1)){
                options = getAccountCodeOptionList(failCode1);
            }*/
            
            //GSSC-297 - END

            for(CSS_Srt__c srtObj :lstFilteredSRT2){
                if(srtObj.SRT_Select__c == true){
                    i=i+1;
                    options = getAccountCodeOptionList(failCode1);
                    lstSelectedSRTWrapper2.add(new srtWrapperClass(i, 
                                                                   srtObj.Id,
                                                                   srtObj.Job_Order__c,
                                                                   srtObj.SRT_ID__c,
                                                                   srtObj.SRT_Title__c,
                                                                   1, 
                                                                   srtObj.Step_Id__c,
                                                                   null,
                                                                   options,
                                                                   ((lstSolComp != null && lstSolComp.size()==1) || (accCodeSet != null && accCodeSet.size() == 1)) ? failCode1 : srtObj.FailCode__c, //Added ternary operator as part of the story GSSC-297
                                                                   ((lstSolComp != null && lstSolComp.size()==1) || (accCodeSet != null && accCodeSet.size() == 1)) ? lstSolComp[0].CSS_Account_Formula__c : srtObj.Account_Code__c, //Added ternary operator as part of the story GSSC-297
                                                                   //srtObj.Type__c,
                                                                   srtObj.SRT_Type__c,
                                                                   accordionType,
                                                                   srtObj.Access_Code__c,
                                                                   srtObj.Access_Code_A__c,
                                                                   srtObj.Access_Code_B__c,
                                                                   srtObj.Access_Code_C__c,
                                                                   srtObj.Access_Code_D__c,
                                                                   srtObj.Access_Code_R__c,
                                                                   srtObj.SRT_Time__c,
                                                                   true,
                                                                   srtObj.SRT_AccessiblityCheck__c,
                                                                   srtObj.Flex_Flag__c,
                                                                   srtObj.Solution_Number__c,
                                                                   srtObj.ECM_Flag__c));

                    srtObj.SRT_Select__c = false; 
                    if(removedSRTCode.size()>0 && (srtObj.SRT_ID__c.contains('00-10S-00') || srtObj.SRT_ID__c.contains('00-724')|| srtObj.SRT_ID__c.contains('00-901') || srtObj.SRT_ID__c.contains('00-902') || srtObj.SRT_ID__c.contains('00-904') || srtObj.SRT_ID__c.contains('00-400') || srtObj.SRT_ID__c.contains('00-401') || srtObj.SRT_ID__c.contains('00-404')  ))
                        removedSRTCode.add(srtObj.SRT_ID__c);
                }
                System.debug('i****'+i);
                lstFilteredSRT.add(srtObj);
            }

            //lstSelectedSRTWrapper2.add(new srtWrapperClass(id,srtCode,srtDesc, quantity,lstFailCodes,lstAccountCodes,selectedFailCode,selectedAccountCode));
            //lstSelectedSRTWrapper2.add(new srtWrapperClass(1, null,'TestCode','Test Desc', 1,null,null,null,null)); //testing purpose added
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
        GSQErrorExists = false;
        system.debug('inside saveSelectedSRTs');
        try{
            //do validations here
            chkReqField = false;

            //List<CSS_srt__c> lstSRTToBeSaved = new List<CSS_srt__c>();
            srtMap = new  Map<String,CSS_srt__c>();
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
                AggregateResult[] groupedResults= [SELECT MAX(SRT_Order__c) FROM CSS_SRT__c WHERE Job_Order__c =:JobId and  (type__c in:lstType or srt_category__c =: Typ)];

                Decimal sortOrder=0;
                if(groupedResults != null && groupedResults.size() > 0){
                    sortOrder=(Decimal)groupedResults[0].get('expr0')!=NULL?(Decimal)groupedResults[0].get('expr0'):0;
                    system.debug('sortorder*******' + sortOrder);
                }

                system.debug('sortorder>>>>>>>>>' + sortOrder);
                integer i =0;  
                for(srtWrapperClass srtWrap : lstSelectedSRTWrapper){

                    /*if(srtWrap.selectedFailCode == 'Select One'){
                        srtWrap.mandateFailCode = true;
                        chkReqField = true; 
                    }
                    else{
                        srtWrap.mandateFailCode = false;            
                    }*/
                    system.debug('srtWrap.srtcode'+srtWrap.srtcode);
                    system.debug('srtWrap.selectedFailCode'+srtWrap.selectedFailCode);
                    system.debug('srtWrap.lstFailCodes'+srtWrap.lstFailCodes);
                    system.debug('srtWrap.selectedAccountCode'+srtWrap.selectedAccountCode);
                    system.debug('srtWrap.lstAccountCodes'+srtWrap.lstAccountCodes);
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

                    // if(srtWrap.selectedAccountCode == 'Select One'){
                    //if((srtWrap.selectedAccountCode == 'Select One' || srtWrap.selectedAccountCode == '' || srtWrap.selectedAccountCode == null) && isDealer){ //added for defeect 158406
                    //srtWrap.mandateAccCode = true; 
                    //chkReqField = true;
                    //} else{
                    //srtWrap.mandateAccCode = false; 
                    //}
                    if(chkReqField == true){
                        return;   
                    }

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
                    if(srtWrap.solNumber != null){
                        key = srtWrap.solNumber+srtWrap.srtCode+srtWrap.selectedFailCode+srtWrap.selectedAccountCode;
                    }
                    else{
                        key = srtWrap.srtCode+srtWrap.selectedFailCode+srtWrap.selectedAccountCode;
                    }
                    system.debug('key***'+key);
                    if(srtMap.containsKey(key) && srtWrap.FlexFlag == false){
                        Integer qty = Integer.valueOf(srtMap.get(key).SRT_Quantity__c);
                        qty = qty + srtWrap.quantity;
                        system.debug('if(srtMap.get(key).SRT_ID__c)>>'+srtMap.get(key).SRT_ID__c);
                        string tmpstr= string.valueOf(srtMap.get(key).SRT_ID__c);

                        CSS_srt__c srtObj = srtMap.get(key);

                        if(tmpstr.contains('00-10S-00') || tmpstr.contains('00-724')|| tmpstr.contains('00-901') || tmpstr.contains('00-902') || tmpstr.contains('00-904') || tmpstr.contains('00-400') || tmpstr.contains('00-401') || tmpstr.contains('00-404')  )
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
                    }else {
                        system.debug('insideelse***');
                        CSS_srt__c srtObj = new CSS_srt__c();
                        srtObj.Id = srtWrap.id;
                        srtObj.Job_Order__c = srtWrap.JobId;
                        srtObj.SRT_ID__c = srtWrap.srtCode;
                        system.debug('insideelse*** SRT_ID__c'+ srtObj.SRT_ID__c);
                        srtObj.SRT_Title__c = srtWrap.srtDesc;
                        srtObj.Step_Id__c = srtWrap.stepId;
                        srtObj.Flex_Flag__c = srtWrap.FlexFlag;
                        srtObj.ECM_Flag__c = srtWrap.ecmFlag;

                        if(srtObj.SRT_ID__c !=null && srtObj.SRT_ID__c !='' && srtObj.SRT_ID__c !='0'){
                            string strtemp1 = string.valueOf(srtObj.SRT_ID__c);
                            if(strtemp1.contains('00-10S-00') || strtemp1.contains('00-724')|| strtemp1.contains('00-901') || strtemp1.contains('00-902') || strtemp1.contains('00-904') || strtemp1.contains('00-400') || strtemp1.contains('00-401') || strtemp1.contains('00-404')  )
                                srtObj.SRT_Quantity__c =1;
                            else
                                srtObj.SRT_Quantity__c = srtWrap.quantity;
                        }
                        else
                            srtObj.SRT_Quantity__c = srtWrap.quantity;

                        if(srtWrap.selectedFailCode != null && srtWrap.selectedFailCode != '' && srtWrap.selectedFailCode != 'Select One'){
                            srtObj.FailCode__c = srtWrap.selectedFailCode;
                            srtObj.Account_Code__c = (LaborRateCheck == false ? srtWrap.selectedAccountCode : '');
                        }
                        else if(srtWrap.selectedFailCode == 'Select One'){
                            srtObj.FailCode__c = srtWrap.selectedFailCode;
                            srtObj.Account_Code__c = srtWrap.selectedAccountCode;
                        }
                        srtObj.Access_Code_A__c = srtWrap.accessCodeA;
                        srtObj.Access_Code_B__c = srtWrap.accessCodeB;
                        srtObj.Access_Code_C__c = srtWrap.accessCodeC;
                        srtObj.Access_Code_D__c = srtWrap.accessCodeD;
                        srtObj.Access_Code_R__c = srtWrap.accessCodeR;
                        //Kalpana, Added as per defect 165357 -- START
                        if(srtWrap.accessCode!=null && srtWrap.accessCode!=''){
                            system.debug('srtWrap.AccessCode**'+srtWrap.AccessCode);
                            srtObj.Access_Code__c = srtWrap.accessCode; 
                            srtobj.SRT_Access_Code__c=srtWrap.accessCode;//Added as part of the story#172627
                        }
                        else{
                            //Commented below line as part of defect fix for defect 173328
                            if( srtObj.Access_Code_A__c==0 && srtObj.Access_Code_B__c==0 && srtObj.Access_Code_C__c==0 && srtObj.Access_Code_D__c==0 && srtObj.Access_Code_R__c!=0)
                            {  
                                srtObj.Access_Code__c = 'R';
                                srtObj.SRT_Access_Code__c = 'R'; //Added as part of story#172627
                            }
                            else
                            {
                                srtObj.Access_Code__c = accessCode; //Job access code adding here for 173328
                                srtObj.SRT_Access_Code__c = accessCode; //Added as part of story#172627
                            }
                            system.debug('srtObj.Access_Code__c:'+srtObj.Access_Code__c+' job AccessCode:'+accessCode);
                        }
                        //Kalpana, Added as per defect 165357 -- END

                        srtObj.SRT_Time__c = srtWrap.SRTTime;
                        system.debug('***srtType1'+srtWrap.srtType);
                        if(srtWrap.srtType !=null && srtWrap.srtType.equalsIgnoreCase('Diagnostic'))
                            srtWrap.srtType = 'Diagnosis';

                        if(srtWrap.srtType != null && srtWrap.srtType != '' && srtWrap.isAccChklstSRT != true){ //GSSC-179 Defect fix
                            if(srtWrap.srtType != null && srtWrap.srtType != '' && !srtWrap.srtType.equalsIgnoreCase('Campaign') && !srtWrap.srtType.equalsIgnoreCase('ATC') && !srtWrap.srtType.equalsIgnoreCase('TRP'))
                                srtObj.Type__c = srtWrap.srtType; //Type
                            else
                                srtObj.Type__c = 'Field Action';
                        }
                        srtObj.SRT_Type__c = srtWrap.srtType; //SRT Type

                        system.debug('***srtType'+srtWrap.srtType);
                        system.debug('***srtObj.SRT_Type__c'+srtObj.SRT_Type__c);
                        system.debug('***Type__c'+srtObj.Type__c);
                        system.debug('srtObj'+srtObj);
                        srtObj.SRT_Category__c = srtWrap.accordionType; //SRT SRT_Category__c as AccordionType__c
                        //srtObj.AccordionType__c = srtWrap.srtType; //SRT AccordionType__c
                        //if(isAutomatedClaim)
                        if(srtWrap.isPopupSRT!=false)
                            srtObj.IsPopUpSRT__c = true; //for Bold/Unbold 

                        if(srtWrap.selectedAccountCode != null && srtWrap.selectedAccountCode != '')
                            srtObj.SRT_Warrantable__c = '100';
                        else
                            srtObj.SRT_Warrantable__c = '0';

                        if(srtWrap.srtType !=null && !srtWrap.srtType.equalsIgnoreCase('Access') && srtWrap.isAccChklstSRT == false){
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
                        system.debug('srtMap***srtObj'+srtObj);                        
                    }
                }
                
                system.debug('srtMap before existSRT List--'+srtMap);
                existSRTList = new List<CSS_Srt__c>([select id, SRT_ID__c,SRT_Category__c, Type__c, SRT_Type__c, FailCode__c, Account_Code__c, SRT_Quantity__c,SRT_Time__c,Flex_Flag__c,ECM_Flag__c FROM CSS_SRT__c where Job_Order__c =: JobId and SRT_Category__c=:accordionType and Flex_Flag__c =false]);
                if(existSRTList !=null && existSRTList.size()>0)
                    for(CSS_SRT__c srtObj: existSRTList){
                        CSS_SRT__c srtObjTemp;
                        String Key=srtObj.SRT_ID__c+srtObj.FailCode__c+srtObj.Account_Code__c;
                        if(srtMap.containsKey(Key)){
                            srtObjTemp=srtMap.get(Key);
                            system.debug('if(srtMap.get(key).SRT_ID__c)>>'+srtMap.get(key).SRT_ID__c);
                            string tmpstr= string.valueOf(srtMap.get(key).SRT_ID__c);

                            if((tmpstr != null && tmpstr != '') && (tmpstr.contains('00-10S-00') || tmpstr.contains('00-724')|| tmpstr.contains('00-901') || tmpstr.contains('00-902') || tmpstr.contains('00-904') || tmpstr.contains('00-400') || tmpstr.contains('00-401') || tmpstr.contains('00-404')  ))
                                srtObjTemp.SRT_Quantity__c=1;


                            srtObjTemp.id = srtobj.id; //here updating existing db id on to unique records is sufficient
                            if(LaborRateCheck == true)
                                srtObjTemp.Account_Code__c = '';
                            srtMap.put(key,srtObjTemp);                  
                        }
                    }
                    
                system.debug('srtMap before existSRT List--'+srtMap);

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
            /*CG_CL_CoverageLimitExceedValidation callingSRTClaimedHour= new CG_CL_CoverageLimitExceedValidation();
            callingSRTClaimedHour.covLimitValidationSRT(JobId,null);*/

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

    public List<SelectOption> getfailcodeDropDown(){  
        List<SelectOption> options;
        try{
            system.debug('***inside getfailcodeDropDown method...');
            options =  new List<SelectOption>();
            Set<string> sortableSet = new  Set<string>();
            List<string> sortable = new  List<string>();
            failAccountCodeMap = new  Map<String, Set<String>>();
            List<CSS_Solution_Component__c> solsComp = new List<CSS_Solution_Component__c>();
            system.debug('JobId****'+JobId);
            if(JobId !=null){
                if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                    //Added Root_Cause__c field and condition Root_Cause__c = true in where clause in below query as part of the story GSSC-385(User story 4)
                    solsComp= [SELECT Id, Root_Cause__c, Fail_Code__c, SysCodeAndCompCode__c, CSS_Account_Formula__c, Solutions__c, CoveredLaborHrs__c, CampaignLaborPercentage__c, Selected_Component__c,FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =:JobId and SysCodeAndCompCode__c!=null and Selected_Component__c= true and Type__c NOT IN ('TRP','ATC','Campaign') and Root_Cause__c = true]; //and Selected_Component__c= true];    
                }else{
                    solsComp= [SELECT Id, Fail_Code__c, SysCodeAndCompCode__c, CSS_Account_Formula__c, Solutions__c, CoveredLaborHrs__c, CampaignLaborPercentage__c, Selected_Component__c,FailCode_Formula__c from CSS_Solution_Component__c where Service_Job__c =:JobId and SysCodeAndCompCode__c!=null and Type__c IN ('TRP','ATC','Campaign') and Performed_Review__c = true]; //and Selected_Component__c= true];    
                }
            }
            options.add(new SelectOption('Select One','Select One'));
            system.debug('solCompList***'+solsComp);
            if(solsComp.size()>0){
                Set<string> acCodeSet;
                for(CSS_Solution_Component__c f: solsComp)  {
                    system.debug('f.Fail_Code__c***'+f.SysCodeAndCompCode__c);
                    String  coverageType;
                    if(f.SysCodeAndCompCode__c !='Select One'){
                        sortableSet.add(f.FailCode_Formula__c);
                        if(f.CSS_Account_Formula__c != null){
                            string temp = f.CSS_Account_Formula__c.substring(0,f.CSS_Account_Formula__c.length()-3);
                            string temp1 = f.CSS_Account_Formula__c.substring(f.CSS_Account_Formula__c.length()-3,f.CSS_Account_Formula__c.length()); 
                            system.debug('temp--->>>>'+temp);
                            system.debug('temp1--->>>>'+temp1);
                            temp1 = temp1.trim();
                            temp = temp.trim();
                            string temp2 = temp + temp1;
                            CSS_JobEventTemporary__c jetSingle = new CSS_JobEventTemporary__c();
                            jetSingle = accCodeMapJET.get(temp2);
                            if(jetSingle!= null){
                                coverageType = jetSingle.Attribute1__c;
                            }
                        }
                        system.debug('coverageType***'+coverageType);
                        if(failAccountCodeMap.containsKey(f.SysCodeAndCompCode__c)){
                            system.debug('**insidecontainkey**');
                            acCodeSet = failAccountCodeMap.get(f.SysCodeAndCompCode__c);

                            if(f.CSS_Account_Formula__c != null){

                                if((accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep')){
                                    if((coverageType == 'OTH' || coverageType == 'POL') && LaborRateCheck == false){
                                        acCodeSet.add(f.CSS_Account_Formula__c);
                                    }
                                    else if(f.CSS_Account_Formula__c !='Select One' && Integer.valueOf(f.CoveredLaborHrs__c) >0 && f.Selected_Component__c== true && LaborRateCheck == false)
                                        acCodeSet.add(f.CSS_Account_Formula__c);
                                    else if(f.CSS_Account_Formula__c !='Select One' && Integer.valueOf(f.CampaignLaborPercentage__c) >0 && (f.Type__c == 'TRP'|| f.Type__c =='ATC'||f.Type__c =='Campaign') && LaborRateCheck == false)
                                        acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                else{
                                    if(f.CSS_Account_Formula__c !='Select One' && LaborRateCheck == false)
                                        acCodeSet.add(f.CSS_Account_Formula__c);
                                }

                            }
                            system.debug('**acCodeSet*'+f.SysCodeAndCompCode__c+'***'+acCodeSet);
                            //failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
                            failAccountCodeMap.put(f.Fail_Code__c, acCodeSet);
                        }else{
                            system.debug('**insidecontainkey---else');
                            acCodeSet = new Set<string>();
                            if(f.CSS_Account_Formula__c != null){
                                /*if(jobEventLst != null){
                                    for(CSS_JobEventTemporary__c jobEntObj : jobEventLst){
                                        if(jobEntObj.Account_Code__c == f.CSS_Account_Formula__c){
                                            coverageType = jobEntObj.Attribute1__c;
                                        }
                                    }
                                }
                                system.debug('coverageType***'+coverageType);*/
                                if((accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep') && (coverageType != 'OTH' && coverageType != 'POL') && LaborRateCheck == false){
                                    if((coverageType != null && coverageType != '') && coverageType == 'OTH' || coverageType == 'POL'){
                                        acCodeSet.add(f.CSS_Account_Formula__c);
                                    }
                                    if(f.CSS_Account_Formula__c !='Select One' && f.CoveredLaborHrs__c != null && Integer.valueOf(f.CoveredLaborHrs__c) >0 && f.Selected_Component__c== true)
                                        acCodeSet.add(f.CSS_Account_Formula__c);
                                    else if(f.CSS_Account_Formula__c !='Select One' && f.CampaignLaborPercentage__c != null && Integer.valueOf(f.CampaignLaborPercentage__c) >0 && (f.Type__c == 'TRP'|| f.Type__c =='ATC'||f.Type__c =='Campaign'))
                                        acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                                else{
                                    if(f.CSS_Account_Formula__c !='Select One' && LaborRateCheck == false)
                                        acCodeSet.add(f.CSS_Account_Formula__c);
                                }
                            }
                            system.debug('**acCodeSet*'+f.SysCodeAndCompCode__c+'***'+acCodeSet);
                            //failAccountCodeMap.put(f.SysCodeAndCompCode__c, acCodeSet);
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
                        if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                            options.add(new selectOption(tempStr[1],s));   
                        }
                        else{
                            String s1 = s.RIGHT(6);
                            //String sTemp = s1.LEFT(4);
                            options.add(new selectOption(s1,s));   
                        }
                    } 
                }   
            }
        }catch(Exception ex) {
            System.debug('in catch of getfailcodeDropDown>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return options;
    }


    public void onChangeofFailCode(){
        try{
            system.debug('in onChangeofFailCode');
            system.debug('selectedFailCode>>>>>>>>>>: '+selectedFailCode);
            system.debug('selectedSRTId>>>>>>>>>>: '+selectedSRTId);
            system.debug('failAccountCodeMap>>>>>>:'+failAccountCodeMap);
            
            if(selectedFailCode!=null && selectedFailCode!=''){
                if(accordionType == 'AdditionalDiag' || accordionType == 'AdditionalRep'){
                    selectedFailCode=selectedFailCode.LEFT(4);
                }
                else{
                    selectedFailCode=selectedFailCode;
                }
            }
            List<SelectOption> options = getAccountCodeOptionList(selectedFailCode);
            Set<string> acCodeSet = failAccountCodeMap.get(selectedFailCode);
            List<String> LstAC = new List<String>();
            system.debug('acCodeSet-->'+acCodeSet);
            if(acCodeSet != null && acCodeSet.size()>0){
                LstAC.addAll(acCodeSet);
                system.debug('LstAC-->'+LstAC.size());
            }
            String SAcode;
            if(LstAC != null && LstAC.size() > 0){
                SAcode = LstAC.get(0);
            }
            else{
                SAcode = 'Select One';
            }
            system.debug('SAcode : ' +SAcode);
            system.debug('returned accode options>>:' +options);
            for(srtWrapperClass srtWrap : lstSelectedSRTWrapper){
                if(srtWrap.counting == selectedSRTId){
                    system.debug('matched selectedSRTId>>:' +selectedSRTId);
                    srtWrap.lstAccountCodes = options;
                    if(options.size() > 2){
                        srtWrap.selectedAccountCode = 'Select One';
                    }
                    else{
                        srtWrap.selectedAccountCode = SAcode;
                    }
                    break;
                }
            }

        }catch(Exception ex) {
            System.debug('in catch of onChangeofFailCode>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }

    }

    public List<SelectOption> getAccountCodeOptionList(String selectedFailCode){
        system.debug('****Entering AccountCode***'+selectedFailCode);
        List<SelectOption> options;
        try{
            options =  new List<SelectOption>();
            //options.add(new SelectOption('Select One','Select One'));
            //  if(selectedFailCode==null || failAccountCodeMap ==null || failAccountCodeMap.size()<=0 || !failAccountCodeMap.containsKey(selectedFailCode)){
            options.add(new SelectOption('Select One','Select One')); //Defect#152557 code added by Agassi.
            //    return options;
            //  }

            List<string> sortable = new  List<string>();
            system.debug('****failAccountCodeMap***'+failAccountCodeMap);
            if(failAccountCodeMap.containsKey(selectedFailCode)){
                Set<string> acCodeSet = failAccountCodeMap.get(selectedFailCode);
                if(acCodeSet.size()>0){
                    sortable.AddAll(acCodeSet);}
                sortable.sort();
                if (sortable.size()>0){
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

    public List<SelectOption> getAccountCodeDropDown1() {
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
    }


    public void GSQSRTMapPrepare() {
        try{
            system.debug('***inside GSQSRTMapPrepare');
            //SRT Groups validation code #162539 start
            Map<String, String> diagGSQMap = new Map<String, String>();
            List<CSS_Solutions__c> solutionList = new List<CSS_Solutions__c>([select Id,Name,Case_Name__c,Solution_Title__c,Service_Job__r.AccessCode__c,Service_Job__r.Equipment_ID__c,Service_Job__c,Diagnostic_Response__c,Repair_Response__c,Symptom__r.Name,FaultCode__r.Name,
                                                                              (select name,SRT_ID__c,Repair_Access_Calculated__c,Job_Order__r.Name,Job_Order__r.AccessCode__c,Additional_SRT_Calculated__c,Diagnosis_Time__c,SRT_Decimal_Time__c,id,step_id__c,SRT_Time__c,Component_Id__c ,Type__c,Response_Message__c ,Repair_Time__c,Access_Code_A__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,Assignment__c,SRT_Status_Message__c,SRT_Title__c ,isPerformed__c,ECM_Flag__c,SRT_Quantity__c,SRT_Notes__c ,SRT_Warrantable__c,
                                                                               Access_Code_B__c,Access_Code_C__c,Access_Code_D__c,Access_Code_R__c,Account_Code__c,FailCode__c,Access_Code_S1__c,Access_Code_S2__c,Access_Code_S3__c,Access_Code_S4__c,Access_Code_S5__c,Access_Code_S6__c,Access_Code_S7__c,Access_Code_S8__c,Access_Code_S9__c,S1_Description__c,S2_Description__c,S3_Description__c,S4_Description__c,Diag_Access_Time__c,
                                                                               S5_Description__c,SRT_Access_Code__c,Access_Code__c,S6_Description__c,S7_Description__c,S8_Description__c,S9_Description__c,Special_Access_Code__c,Special_Access_Code_Desc__c,SRT_Order__c,Job_Engine_Access_Code__c,Access_Code_Saved__c,Extended_Hours__c,SRT_Estimate__c from CSS_SRTS__r where CSS_Claims__c=null order by SRT_Order__c asc)
                                                                              from CSS_Solutions__c where Service_Job__c=:JobID]);

            system.debug('solutionList size>>>:'+solutionList.size());
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
                                                                                                     from CSS_Solution_Component__c where Service_Job__c=:JobID and CSS_Claims__c=null]);
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
        list<CSS_SRT__c> srtlist= new list<CSS_SRT__C>();
        set<string> tempadmin=new set<string>();
        srtlist=[select name,SRT_ID__c,Assignment__c,Admi_Check__c,IsPopUpSRT__c,Job_Order__r.Name,id,step_id__c,Component_Id__c ,Type__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c,Flex_Flag__c,ECM_Flag__c from CSS_SRT__c where CSS_Claims__c=null and Job_Order__c =: JobId and (((Solution_Number__c != null and Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' and (Type__c = 'Diagnosis' or Type__c = 'Diag Access' or (Component_Id__c != null and Assignment__c IN ('Primary', 'Progressive Damage','Alternative') and (Type__c = 'Repair Access' or Type__c='Repair')))) or (Solution_Number__c = null and (srt_category__c='AdditionalDiag' or srt_category__c='AdditionalRep'))) or (Assignment__c != 'NOT CLAIMABLE' AND Assignment__c != 'NOT APPLICABLE' AND Assignment__c != 'UNLISTED' and Component_Id__r.Type__c IN ('Campaign','TRP','ATC') and Component_Id__r.Performed_Review__c = true and Component_Id__r.Status__c='Approved' and ((Component_Id__r.Complete_Indicator__c=true and Component_Id__r.Multiple_Times__c=true) OR (Component_Id__r.Complete_Indicator__c=false and Component_Id__r.Multiple_Times__c=true) OR (Component_Id__r.Complete_Indicator__c=false and Component_Id__r.Multiple_Times__c=false))) or (Solution_Number__c = null and component_id__c = null and isPopupSRT__c = true and srt_category__c IN ('Campaign','TRP','ATC')))];
        if(srtlist.size()>0)
        {
            for(css_srt__c srtobj:srtlist)
            {
                //if(srtobj.SRT_ID__c.contains('00-10S-00') || srtobj.SRT_ID__c.contains('00-724')|| srtobj.SRT_ID__c.contains('00-901') || srtobj.SRT_ID__c.contains('00-902') || srtobj.SRT_ID__c.contains('00-904') || srtobj.SRT_ID__c.contains('00-400') || srtobj.SRT_ID__c.contains('00-401') || srtobj.SRT_ID__c.contains('00-404')) 
                if(srtobj.SRT_ID__c!=null && srtobj.SRT_ID__c!='' && (srtobj.SRT_ID__c.contains('00-724')|| srtobj.SRT_ID__c.contains('00-901') || srtobj.SRT_ID__c.contains('00-902') || srtobj.SRT_ID__c.contains('00-904') || srtobj.SRT_ID__c.contains('00-400') || srtobj.SRT_ID__c.contains('00-401') || srtobj.SRT_ID__c.contains('00-404'))) 
                {
                    for(css_srt__c filtersrtobj:lstFilteredSRT)
                    {
                        if(filtersrtobj.SRT_ID__c == srtobj.SRT_ID__c)
                        {


                            if((srtobj.SRT_ID__c.contains('00-901') || srtobj.SRT_ID__c.contains('00-902') || srtobj.SRT_ID__c.contains('00-904')) && srtobj.IsPopUpSRT__c==false )
                            {
                                tempadmin.add('00-901-00');
                                tempadmin.add('00-902-00');
                                tempadmin.add('00-904-00');  

                            }

                            else if((srtobj.SRT_ID__c.contains('00-401') || srtobj.SRT_ID__c.contains('00-404') || srtobj.SRT_ID__c.contains('00-400') || srtobj.SRT_ID__c.contains('00-724')) && srtobj.IsPopUpSRT__c==false)
                            {
                                if(string.valueOf(srtobj.Assignment__c) != 'UNLISTED' && string.valueOf(srtobj.Assignment__c) != 'Not Applicable' && string.valueOf(srtobj.Assignment__c) != 'Unlisted' && string.valueOf(srtobj.Assignment__c) != 'NOT APPLICABLE')
                                    filtersrtobj.Admi_Check__c=true;

                            }
                            /* else if(srtobj.SRT_ID__c == '00-10S-00')
    {
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
                        else
                        {
                            if(filtersrtobj.SRT_ID__c.contains('00-901') || filtersrtobj.SRT_ID__c.contains('00-902') || filtersrtobj.SRT_ID__c.contains('00-904'))
                            {
                                if((srtobj.SRT_ID__c.contains('00-901') || srtobj.SRT_ID__c.contains('00-902') || srtobj.SRT_ID__c.contains('00-904')) && srtobj.IsPopUpSRT__c==false)
                                {
                                    tempadmin.add('00-901-00');
                                    tempadmin.add('00-902-00');
                                    tempadmin.add('00-904-00');  

                                }
                                else
                                {
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
        }
        if(tempadmin.size()>0)
        {
            for(css_srt__c filtersrtobj1:lstFilteredSRT)
            {
                if(tempadmin.contains(filtersrtobj1.SRT_ID__c))
                    filtersrtobj1.Admi_Check__c=true;
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
        system.debug('lstFilteredSRT****'+lstFilteredSRT.size()+'*****'+lstFilteredSRT);
        List<String> excludeSRTsDuplicateCheckList = new List<String>();
        String ESRTDCLValues = Label.CG_ExcludeSRTsDuplicateCheck;
        list<CSS_srt__c> lstSRTDupCheck = new list<CSS_srt__c>();
        if(ESRTDCLValues != null && ESRTDCLValues != '') {
            excludeSRTsDuplicateCheckList = ESRTDCLValues.split(',');
        }
        SRTIDs=new Set<String>();
        lstSRTDupCheck=[select name,SRT_ID__c,Job_Order__r.Name,id,step_id__c,Component_Id__c ,Type__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,SRT_Title__c ,isPerformed__c,SRT_Quantity__c,Flex_Flag__c,ECM_Flag__c from CSS_SRT__c where CSS_Claims__c=null and SRT_ID__c != '' and SRT_ID__c != '0' and Job_Order__c =: JobId and (((Solution_Number__c != null and Solution_Number__r.Diagnostic_Response__c = 'Most likely the solution' and (Type__c = 'Diagnosis' or Type__c = 'Diag Access' or Type__c = 'Repair Access' or (Component_Id__c != null and Assignment__c IN ('Primary', 'Progressive Damage','Alternative') and (Type__c='Repair')))) or (Solution_Number__c = null and (srt_category__c='AdditionalDiag' or srt_category__c='AdditionalRep'))) or (Assignment__c != 'NOT CLAIMABLE' AND Assignment__c != 'NOT APPLICABLE' AND Assignment__c != 'UNLISTED' and Component_Id__r.Type__c IN ('Campaign','TRP','ATC') and Component_Id__r.Performed_Review__c = true and Component_Id__r.Status__c='Approved' and ((Component_Id__r.Complete_Indicator__c=true and Component_Id__r.Multiple_Times__c=true) OR (Component_Id__r.Complete_Indicator__c=false and Component_Id__r.Multiple_Times__c=true) OR (Component_Id__r.Complete_Indicator__c=false and Component_Id__r.Multiple_Times__c=false))) or (Solution_Number__c = null and component_id__c = null and isPopupSRT__c = true and srt_category__c IN ('Campaign','TRP','ATC')))];
        if(lstSRTDupCheck!=null && lstSRTDupCheck.size()>0){
            for(CSS_srt__c srtObj:lstSRTDupCheck){
                SRTIDs.add(srtObj.SRT_ID__c.LEFT(6));
            }
        }
        system.debug('ALreadypresentSRTID****'+'*****'+SRTIDs);
        if(lstFilteredSRT != null && lstFilteredSRT.size() > 0){
            for(css_srt__c srtObj : lstFilteredSRT){
                String temp = srtObj.SRT_ID__c != null && srtObj.SRT_ID__c != '' ? srtObj.SRT_ID__c.LEFT(6) : '';
                if(lstSelectedSRTWrapper != null && lstSelectedSRTWrapper.size() > 0){
                    for(srtWrapperClass srt : lstSelectedSRTWrapper){
                        String temp1 = srt.srtCode != null && srt.srtCode != '' ? srt.srtCode.LEFT(6) : '';
                        if(((SRTIDs != null && SRTIDs.contains(temp)) || temp == temp1) && srtObj.srt_select__c == true && excludeSRTsDuplicateCheckList != null && !(excludeSRTsDuplicateCheckList.contains(temp))){
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
                    if((SRTIDs != null && SRTIDs.contains(temp)) && srtObj.srt_select__c == true && excludeSRTsDuplicateCheckList != null && !(excludeSRTsDuplicateCheckList.contains(temp))){
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
            if(css_srtEditPopupController.serviceFailed){
                insert errorDetail;
            } 
        }catch(exception e){

        }

    }

    public class srtWrapperClass {
        public Integer counting {get;set;}
        public Id id {get;set;}
        public Id jobId {get;set;}
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
        public string accessCode {get;set;} //Kalpana, Added as per defect 165357
        public Decimal accessCodeA{get;set;}
        public Decimal accessCodeB{get;set;}
        public Decimal accessCodeC{get;set;}
        public Decimal accessCodeD{get;set;}
        public Decimal accessCodeR{get;set;}
        public Decimal SRTTime {get;set;}
        public Boolean isPopupSRT {get;set;}
        public Boolean isAccChklstSRT {get;set;}
        public Boolean FlexFlag{get;set;}
        public string solNumber {get;set;}
        public Boolean ecmFlag{get;set;}

        public srtWrapperClass(Integer counting,Id id,Id jobId,String srtCode,String srtDesc,Integer quantity,String stepId,list<SelectOption> lstFailCodes,list<SelectOption> lstAccountCodes,String selectedFailCode,String selectedAccountCode,String srtType,String accordionType,String accessCode,Decimal accessCodeA,Decimal accessCodeB,Decimal accessCodeC,Decimal accessCodeD,Decimal accessCodeR,Decimal SRTTime,Boolean isPopupSRT, Boolean isAccChklstSRT, Boolean FlexFlag,string solNumber,Boolean ecmFlag){
            this.counting = counting;
            this.id = id;
            this.jobId = jobId;
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
            this.accessCode = accessCode;
            this.accessCodeA = accessCodeA;
            this.accessCodeB = accessCodeB;
            this.accessCodeC = accessCodeC;
            this.accessCodeD = accessCodeD;
            this.accessCodeR = accessCodeR;
            this.SRTTime = SRTTime;
            this.isPopupSRT = isPopupSRT;
            this.isAccChklstSRT = isAccChklstSRT;
            this.FlexFlag = FlexFlag;
            this.solNumber = solNumber;
            this.ecmFlag = ecmFlag;
        }        
    }
}