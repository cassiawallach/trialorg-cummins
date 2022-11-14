/**************************************************************************
Name: CSS_JobPlanOverviewControllerNew
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is the controller of CSS_JobPlan landing page
=======================================================================
=======================================================================
***************************************************************************/

public class CSS_JobPlanOverviewControllerNew {

    //Kalpana
    public boolean errornotcovfound{get;set;}
    public string AuthNumber{get;set;}
    public string licenseplate{get;set;}
    public string ApprovalCode{get;set;}
    public string PayCode{get;set;}
    public string coverageType{get;set;}
    public String ProfileName{get;set;}
    public string datebyLocaleValue {get;set;}
    public string workjobStatus;
    public Integer complaintcounter{set;get;}
    public Integer coveragecounter{set;get;}
    public Integer causecounter{set;get;}
    public Integer correctioncounter{set;get;}
    public boolean accQuoteFlag{set; get;}
    public string NotesBody {get;set;}
    public id recTypeIdpart ;
    public list<CSS_Parts_Options__c> sendparts;
    public list<string> faultList {get; set;}
    public list<string> partlist {get; set;}
    public list<string> partlistFAULT {get; set;}
    public List<CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails> listcertificatedetails{get;set;}
    public CSS_getBasicCoverageResponseJ2A basicCoverageDetails{get;set;}
    public string failCodeSelected{get;set;}
    public string accCodeSelected{get;set;}
    public string failCodeEditable{get;set;}
    public string accCodeEditable{get;set;}
    public string compName{get;set;}
    public string componentId{get;set;}
    public string compID1{get;set;}
    public string fcWS{get;set;}
    public string acWS{get;set;}
    public string fcPopup{get;set;}
    public string acPopup{get;set;}
    public string recordId{get;set;}
    public boolean displayMPopUp{get;set;}
    public string selAccCode{get;set;}
    public Boolean failCodeChange{get;set;}
    public Boolean warrantyFailure{get;set;}
    public Boolean warrantyCompFailure{get;set;}
    public string partsWarranty{get;set;}
    public string custSelect{get;set;}
    public string failureMeasure{get;set;}
    public string faultCode{get;set;}
    public string coverageFound{get;set;}
    public boolean pleaseselacc{get;set;}
    public string payCodeSelected{get;set;}
    public string failmode{get;set;}
    public string claimtype{get;set;}
    public string accountCodeType{get;set;}
    public boolean displayERPButton{get;set;}
    public boolean displayERPButtonDist{get;set;}
    public boolean displayERPButtonDlr{get;set;}
    public boolean displaySendERP_Button{get;set;}
    public string selectedFNameValue{get;set;}
    public string selectedFailModeValue {get;set;}
    public string selectedFaultCodeValue {get;set;}
    public string selectedSysCodeValue {get;set;}//System Codes
    public string selectedCompCodeValue {get;set;}//Com Codes
    public string selectedFName{get;set;}//Faiulre Names
    public string selectedSysCode {get;set;}//System Codes
    public string selectedCompCode {get;set;}//Com Codes
    public Set<String> failureNameList{get;set;}//faliureNameList
    public Set<String> componentCodeList{get;set;}
    public Set<String> systemCodeList{get;set;}
    public Set<String> faultCodeList{get;set;}
    public Map<String,String> failureNameWithSystemCodeMap{get;set;}
    public Map<String,String> failureNameWithCompCodeMap{get;set;}
    public Map<String,String> FailureNameWithFailureIDMap {get; set;}
    public String failureSolCompID ;
    public transient Map<String,String> custFailureNameSysCodeMap{get;set;}
    public  transient Map<String,String> custFailureNameCompCodeMap{get;set;}
    public  Map<String,String> sysCodeCustFailureNameMap{get;set;}
    public Boolean blankField{get;set;}
    public Boolean warrantyDetError{get;set;}//Added for Inside Out Sprint
    public string selectedFailMode {get;set;}
    public Boolean FCErrorval {get;set;}
    public boolean errormsgfailpoint{get;set;}
    public string selectedFaultCode {get;set;}//Claim Types
    public Boolean selectedAccFormula {get;set;}//CSS_Account_Formula values
    public CSS_Solution_Component__c compToUpdate {get;set;}
    public List<SelectOption> lstPCvalues{get;set;}
    public Map<string,String> mapAccCode;
    public list<string> lstpaycode {get;set;}
    public List<SelectOption> claimTypes{get;set;}
    public string FailureDtHidden{get;set;}
    public ID sympQAId{get;set;}
    public Boolean isDealer {get;set;}
    public string selectedCustFName {get;set;}
    public string selectedCustFNameValue {get;set;}
    public list<CSS_Job_Order__c> licenselst;


    //public Boolean issymptomcodecheck{get;set;}
    public string invalidAppCode{get;set;}
    public string appCodeSelected{get;set;}
    public string licenseplateSelected{get;set;}
    //Start
    public string claimTypeSelected{get;set;}
    public string solCompExistsFlag{get;set;}
    public string accCodeReturned {get;set;}
    public string AuthorizationNumber{get;set;}
    public String partCoverageFound {get;set;}
    public string selectedCompId{get;set;}
    public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
    public Boolean sendfailtoERP{get;set;}
    public string authNumbers{get;set;}
    public boolean checkPartsWarrStartDt{get;set;}
    public Boolean stopFailureSave{get;set;}
    public Boolean chkClickonPartsCoverage{get;set;}
    public  Map<string,string> custFailureNameList {get;set;}
    public String SelectSysCode;
    public String SelectComCode;
    public String oldFailCode;
    public String oldAccCode;
    public Boolean invalidFailure{get;set;}
    public Boolean invalidCustFailure{get;set;}
    public Boolean invalidSysCode{get;set;}
    public Boolean invalidCompCode{get;set;}
    public Boolean invalidFailMode{get;set;}
    public Boolean invalidFaultCode{get;set;}
    public map<string,string> systemCodeMap{get;set;} //Added as part of design change
   public map<string,string> componentCodeMap{get;set;} //Added as part of design change
    public Boolean showResolutionRequired{get;set;}//ROD Defect 179167 Added by Rajesh Narra 
    public Boolean showRepairRequired {get;set;}//ROD Defect 179167 Added by Rajesh Narra
    public Boolean showLicensePlateRequired {get;set;} // Added for story GSSC-55
    //function to load the values when edit button is pressed
    public boolean accountcodeeditonfm{get;set;}// GSSC-290
    public String failmodeloadval{get;set;}// GSSC-290
    public boolean checkCoverageonfm{get;set;}// GSSC-290
    public boolean failureinfochange{get;set;} // GSSC-290




    public void loadPopup() {
        invalidFailure =false;
        invalidCustFailure = false;
        invalidSysCode=false;
        invalidCompCode=false;
        invalidFailMode=false;
        invalidFaultCode=false;
        dateErrFlag=false;
        higherdateErrFlag=false;
        failureDate=null;
        selectedCustFNameValue = null;
        checkCoverageonfm = false;

        getCompID();
        errornotcovfound = false;
        //query the respected solution component record
        List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>();
        List<CSS_Job_Order__c>jobList = new List<CSS_Job_Order__c>();
        //Added only Fault_Code__c field into below query  as per SIT story #150030, -By RAJESH 25th june 2018
        //solCompList =[Select Name,id,Claim_Type__c,Fault_Code__c,Authorization_Number__c,Approval_Code__c,AccountCodeEdit__c,System_Code__c,Component_Code__c,Failure_Mode__c,CSS_Account_Formula__c,Pay_Code__c,Part_Warranty_Start_Date__c, Failure_Date__c, Failure_Point__c, Failure_Measure__c from CSS_Solution_Component__c where ID =:componentId];
        solCompList =[Select Name,id,Fail_Code__c,Claim_Type__c,Fault_Code__c,CSS_Custom_Failure__c,Authorization_Number__c,AccountCode__c,AccountCodeType__c,Approval_Code__c,AccountCodeEdit__c,System_Code__c,SystemCode_Desc__c,Component_Code__c,ComponentCode_Desc__c,Failure_Mode__c,CSS_Account_Formula__c,Pay_Code__c,Part_Warranty_Start_Date__c, Failure_Date__c, Failure_Point__c, Failure_Measure__c,Solutions__c,Solutions__r.FaultCode__c,Solutions__r.Symptom__r.Name,Solutions__r.FaultCode__r.Name,Solutions__r.Symptom__c from CSS_Solution_Component__c where ID =:componentId];
        jobList = [select id,Name,License_Plate__c from CSS_Job_Order__c where id=:wid];
        system.debug('solCompList***'+solCompList);
        system.debug('Sympton_QA----->' + solCompList[0].Solutions__r.Symptom__c);
        /*system.debug('solCompList[0].Failure_Point__c***'+solCompList[0].Failure_Point__c);
system.debug('solCompList[0].Failure_Date__c***'+solCompList[0].Failure_Date__c);
system.debug('solCompList[0].Part_Warranty_Start_Date__c***'+solCompList[0].Part_Warranty_Start_Date__c);*/
        //put the record in the selected variable to reflect in the edit popup
        if(solCompList.size()>0){
            coverageFound = '';
            partcoverageFound = '';
            selectedFName =  solCompList[0].Name ;
            // system.debug('selectedFName***'+selectedFName);
            //selectedCompId = solCompList[0].id;
            selectedSysCode = solCompList[0].System_Code__c;
            selectedCompCode =solCompList[0].Component_Code__c;
            selectedFailMode = solCompList[0].Failure_Mode__c ;
            system.debug('selectedFailMode'+selectedFailMode);
            selectedCustFName = solCompList[0].CSS_Custom_Failure__c;
            oldFailCode = solCompList[0].Fail_Code__c;
            oldAccCode = solCompList[0].CSS_Account_Formula__c;
            system.debug('oldFailCode-->'+oldFailCode);
            system.debug('oldAccCode-->'+oldAccCode);
            system.debug('selectedSysCode'+selectedSysCode);
            system.debug('selectedSysCode'+selectedSysCode);
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
                    List<CSS_JobEventTemporary__c> tempList = [select Attribute1__C,Attribute4__c,Attribute7__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C=:selectedSysCode and Attribute4__c=:selectedCompCode];
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
            componentId = solCompList[0].id;
            // accCodeSelected = solCompList[0].CSS_Account_Formula__c;
            if(solCompList[0].AccountCodeEdit__c != null && solCompList[0].AccountCodeEdit__c != '') //to display account code in Eit Popup, which is getting displayed on troubleshoot overview
                accCodeSelected = solCompList[0].AccountCodeEdit__c;
            else if(solCompList[0].AccountCode__c != null && solCompList[0].AccountCode__c != '' && solCompList[0].AccountCodeType__c!=null) //to display account code in Eit Popup, which is getting displayed on troubleshoot overview
            {
                string [] acCodeType = solCompList[0].AccountCodeType__c.split('-');
                system.debug('acCodeType[1]**'+acCodeType[1]);
                //accCodeSelected = solCompList[0].AccountCodeType__c+solCompList[0].AccountCode__c;
                accCodeSelected = acCodeType[1]+''+solCompList[0].AccountCode__c;
                // system.debug('accCodeSelected***'+accCodeSelected);
            }
            // GSSC-290 Karthik G 
            if(accCodeSelected!=null && accCodeSelected!= '')
                accountcodeeditonfm = true;

            // GSSC-290 Karthik G end

            //  Start- Displaying Fault code on Popup as per SIT story #150030,-By RAJESH 25th June 2018 ->Not in Scope
            //selectedFaultCode = solCompList[0].Fault_Code__c ;
            //End
            //  system.debug('solCompList[0].Pay_Code__c***'+solCompList[0].Pay_Code__c);
            payCodeSelected = solCompList[0].Pay_Code__c ;
            // system.debug('payCodeSelected***'+payCodeSelected);
            compont.Pay_Code__c = solCompList[0].Pay_Code__c ;
            // system.debug('compont.Pay_Code__c***'+compont.Pay_Code__c);
            AuthorizationNumber = solCompList[0].Authorization_Number__c;
            // system.debug('solCompList[0].Authorization_Number__c***'+solCompList[0].Authorization_Number__c);
            compont.Authorization_Number__c = solCompList[0].Authorization_Number__c;
            // system.debug('compont.Authorization_Number__c***'+compont.Authorization_Number__c);
            // system.debug('solCompList[0].Approval_Code__c***'+solCompList[0].Approval_Code__c);
            compont.Approval_Code__c = solCompList[0].Approval_Code__c;
            // system.debug('compont.Approval_Code__c***'+compont.Approval_Code__c);
            appCodeSelected = solCompList[0].Approval_Code__c;
            // system.debug('compont.Authorization_Number__c***'+appCodeSelected);
            //compont.pay_code__c = solCompList[0].Pay_Code__c ;
            compont.Part_Warranty_Start_Date__c = solCompList[0].Part_Warranty_Start_Date__c ;
            compont.Failure_Date__c = solCompList[0].Failure_Date__c ;
            compont.Failure_Point__c = solCompList[0].Failure_Point__c ;
            failureMeasure = solCompList[0].Failure_Measure__c;
            claimTypeSelected = solCompList[0].Claim_Type__c;
            authNumbers=solCompList[0].Authorization_Number__c;
            sympQAId = solCompList[0].Solutions__r.Symptom__c;
            system.debug('test11'+selectedFailMode);
            if(solCompList[0].CSS_Account_Formula__c != null)
            {
                system.debug('seleceted Formula1--->'+String.valueOf(solCompList[0].CSS_Account_Formula__c));
                system.debug('seleceted Formula--->'+String.valueOf(solCompList[0].CSS_Account_Formula__c));
                String emmision = String.valueOf(solCompList[0].CSS_Account_Formula__c);
                system.debug('Emmision ---->'+emmision);
                if(emmision != null || emmision != '')
                    selectedAccFormula = emmision.containsIgnoreCase('Emissions Warranty 70');
                system.debug('seleceted Formula--->'+selectedAccFormula);
            }
            system.debug('solCompList[0].Fault_Code__c' +solCompList[0].Fault_Code__c);
            system.debug('solCompList[0].Solutions__r.Symptom__r.Name'+solCompList[0].Solutions__r.Symptom__r.Name);
            if(solCompList[0].Fault_Code__c != null && solCompList[0].Fault_Code__c != ''){
                selectedFaultCode = solCompList[0].Fault_Code__c;
            }
            else if(solCompList[0].Solutions__r.Symptom__r.Name != null && solCompList[0].Solutions__r.Symptom__r.Name != ''){

                selectedFaultCode = solCompList[0].Solutions__r.Symptom__r.Name;
            }
            else
                selectedFaultCode = solCompList[0].Solutions__r.FaultCode__r.Name;


            //selectedFaultCode = solCompList[0].Solutions__r.Symptom__r.Name;//for Story 149958 code added by Agassi
            if(selectedFaultCode != null && (!selectedFaultCode.isNumeric() || selectedFaultCode == '')){

                selectedFaultCode = '';
            }//*///for story 149958 code end added by Agassi

            system.debug('Today selectedFaultCod ' + selectedFaultCode);
            compont.id = componentId;
            //compont.Pay_Code__c = solCompList[0].Pay_Code__c ;
            //compont.Approval_Code__c = solCompList[0].Approval_Code__c;
            //update compont;
            system.debug(selectedFailMode + 'selectedFailMode123***');
            if(selectedFailMode!= null && selectedFailMode!=''){
                List<CSS_JobEventTemporary__c>  jobEvFM=[select Attribute1__c,Active__c, Attribute3__c
                                                         from CSS_JobEventTemporary__c
                                                         where key__c='FailModes' and Active__c= true ];
                for(CSS_JobEventTemporary__c jFM : jobEvFM){
                    if(selectedFailMode==jFM.Attribute1__c){
                        selectedFailMode = selectedFailMode+'-'+ jFM.Attribute3__c;
                        system.debug('test33'+selectedFailMode);
                    }
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
        }
        /*if(jobList.size()>0){
        licenseplateSelected = jobList[0].License_Plate__c;
    }*/
        if(selectedFaultCode!= null && selectedFaultCode!= null){
            //Story 188014 code changes start
            system.debug(selectedFaultCode + 'workJob.Service_Model__c*****');

            List<CSS_SMN_FaultCode__c> tempList = [select FC_Desc__c,Fault_Code__c from CSS_SMN_FaultCode__c where SMN__c=: workJob.Service_Model__c];
            for(CSS_SMN_FaultCode__c jSCCC :tempList){
                if(selectedFaultCode == jSCCC.Fault_Code__c){
                    selectedFaultCode = jSCCC.FC_Desc__c;
                }

            }
            tempList = null; 
            //Story 188014 code changes start
        }  // changing as per jungle book sprint story 167921
        // changing as per jungle book sprint story 167921
        /* if(selectedSysCode!= null && selectedCompCode!= null){
List<CSS_JobEventTemporary__c>  jobEvSCCC=[select  Attribute1__c,Attribute4__c,Attribute5__c ,Attribute3__c
from CSS_JobEventTemporary__c
where key__c='FailCodes' ];
for(CSS_JobEventTemporary__c jSCCC :jobEvSCCC){
//if(selectedSysCode==jSCCC.Attribute1__c){
//  selectedSysCode=selectedSysCode+'-'+jSCCC.Attribute3__c;
//}
if(selectedCompCode==jSCCC.Attribute4__c){
selectedCompCode=selectedCompCode+'-'+jSCCC.Attribute5__c;
}
}
}*/

        if(selectedSysCode!= null && selectedCompCode!= null){
            List<CSS_JobEventTemporary__c>  jobEvSCCC=[select  Attribute1__c,Attribute4__c,Attribute5__c ,Attribute3__c
                                                       from CSS_JobEventTemporary__c
                                                       where key__c='FailCodes' ];


            for(CSS_JobEventTemporary__c jSCCC :jobEvSCCC){
                if(selectedSysCode==jSCCC.Attribute1__c && selectedCompCode == jSCCC.Attribute4__c){
                    selectedSysCode=selectedSysCode+'-'+jSCCC.Attribute3__c.toUpperCase();
                    selectedCompCode=selectedCompCode+'-'+jSCCC.Attribute5__c;
                    system.debug(' selectedSysCode--->'+ selectedSysCode);
                    system.debug('selectedCompCode'+selectedCompCode);
                }
            }
        }

        //komal

        //end
        if(accCodeSelected != null && accCodeSelected != ''){
            // showDisabledAC = false;
            //List<CSS_JobEventTemporary__c> jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' order by Attribute2__c asc];
            // string orgtype=css_utility.getOrgType(userinfo.getUserId());
            Account Regionterritory = css_utility.getRegionTerritory(workJob.Creator_Location__c);
            string orgtype;
            boolean dlrOrgType=css_utility.getAccounttype(workJob.Account__r.Type);
            if(dlrOrgType == false){
                orgtype = 'DISTR';
            }

            User usr;
            usr = css_utility.getUserAttributes(userinfo.getUserId());
            string userRole = usr.UserRoleName__c;


            if(userRole!= null && userRole != '' && (userRole.contains('Factory') || userRole.contains('DFSE') || userRole.contains('CFSE')))
            {
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
            }
            else{
                if (orgtype=='DISTR'){
                    system.debug('Inside DISTR');
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                }
                else{
                    if(Regionterritory.Region__c != null && Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA'){
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Attribute15__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                    else{
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','REW','RPW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                }
            }
            if(jobEventTemp.size() > 0){
                system.debug('jobEventTemp.size()-->'+jobEventTemp.size());
                system.debug('jobEventTempData-->'+jobEventTemp);
                accCodes = new List<SelectOption>();
                List<SelectOption> accCodesNew = new List<SelectOption>();
                accCodes.add(new SelectOption('Select One','Select One'));
                accCodesNew.add(new SelectOption(accCodeSelected,accCodeSelected));
                Set<String> setStr = new Set<String>();
                setStr.add(accCodeSelected);
                for(CSS_JobEventTemporary__c j : jobEventTemp){
                    string s = j.Attribute2__c+' '+ j.Attribute3__c;
                    //accCodes.add(new SelectOption(j.Attribute2__c,s));
                    if(!setStr.contains(s)){
                        accCodesNew.add(new SelectOption(s,s));
                        setStr.add(s);
                    }
                    //accCode = accCodeSelected;
                }
                accCodesNew.sort();
                accCodes.addAll(accCodesNew);
            }
            // system.debug('compont.Approval_Code__c1***'+compont.Approval_Code__c);
            getPayCodesonAccCodeChangeOnLoad();
            //  system.debug('compont.Approval_Code__c2***'+compont.Approval_Code__c);
            //lstPCvalues = getPayCodesList(accCodeSelected.right(2).trim());
        }
        else{
            showDisabledAC = true;
        }
        //clearPopup();
        //system.debug('compont.Approval_Code__c3***'+compont.Approval_Code__c);
        getCoverageType();
        // system.debug('compont.Approval_Code__c4***'+compont.Approval_Code__c);
        system.debug('accCodeSelected'+accCodeSelected);
        system.debug('coverageFound'+coverageFound);
        // system.debug('compont.Authorization_Number__c123***'+compont.Authorization_Number__c);
        //if(accCodeSelected != null && accCodeSelected != '')
        //  lstPCvalues = getPayCodesList(accCodeSelected.right(2).trim());
    }



    public Boolean InsertFlag{get;set;}
    public void onAddClick(){
        // getCompID();
        InsertFlag = true; // Flag to cover SAVE from Add
        showDisabledAC = true;
        clearPopup();
        system.debug('compont' + '  '+ compont);
        if(compont != null){
            if((compont.CSS_Account_Formula__c != null && compont.CSS_Account_Formula__c != '') && (compont.AccountCodeEdit__c == null || compont.AccountCodeEdit__c == ''))
                accCodeWS = compont.CSS_Account_Formula__c.Trim();
            if(compont.Parts_Warranty__c != null && compont.Parts_Warranty__c != '')
                partsWarranty = compont.Parts_Warranty__c;
            if(compont.Customer_Take_Possession__c != null && compont.Customer_Take_Possession__c != '')
                custSelect = compont.Customer_Take_Possession__c;
            if(compont.Failure_Measure__c != null && compont.Failure_Measure__c != '')
                failureMeasure = compont.Failure_Measure__c;
            //coverageType='';
        }
    }



    public Date failureDate{get;set;}
    public Date failureDate1{get;set;}
    public Date warrantyDate{get;set;}
    public Boolean dateErrFlag{get;set;}
    public Boolean higherdateErrFlag{get;set;}
    public string warrStDtHidden{get;set;}
    public Date partsWarrDt{get;set;}
    public Date tempfailureDate;

    public void CompareDates(){

        if(failureDate != null){
            if(compont.Failure_Date__c==null)
                compont.Failure_Date__c = failureDate;
            else {
                if(compont != null)
                    compont.Failure_Date__c = failureDate;
            }
        }
        else if(failureDate1 != null){
            if(compont.Failure_Date__c==null)
                compont.Failure_Date__c = failureDate;
            else {
                if(compont != null)
                    compont.Failure_Date__c = failureDate1;
            }
            failureDate = failureDate1;
        }
        dateErrFlag = false;
        higherdateErrFlag = false;
        if(failureDate!=null){
            if(failureDate<warrantyDate){
                dateErrFlag = true;
                system.debug('LESSTHAN**');}
            if(failureDate>date.today()){
                higherdateErrFlag = true;

                if(compont.Failure_Date__c==null){
                    tempfailureDate=psnRec.Failure_Date__c;
                    workjob.Failure_Date__c = system.TODAY();
                }

                else {
                    if(compont != null){
                        tempfailureDate=compont.Failure_Date__c;
                        compont.Failure_Date__c = system.TODAY();
                    }

                }

                system.debug('GREATER**');

            } else{
              tempfailureDate=compont.Failure_Date__c;
            }
        }
        system.debug('warrantyDate--'+warrantyDate);

        if(warrantyDate!=null && warrantyDate>System.TODAY()){
            checkPartsWarrStartDt = true;
        }
        else{
            checkPartsWarrStartDt = false;
        }
        system.debug('checkPartsWarrStartDt--'+checkPartsWarrStartDt);
    }

    //function to reset the selectedvalues when cancel is pressed
    public void cancelPopup(){
        system.debug('enteringintocancelpop'+selectedCustFName);
        selectedFName =   '';
        selectedCompCode = '';
        accCodeSelected = '';
        selectedSysCode = '';
        selectedCompCode = '';
        selectedFailMode = '';
        payCodeSelected= '';
        accountcodeeditonfm=  false;
        failmodeloadval='';
        FCErrorVal = false;
        lstPCvalues= new List<SelectOption>();
        selectedFaultCode = '';
        blankfield = false;
        selectedCustFName = '';
        solCompExistsFlag = 'false';
        errornotcovfound = false;
        warrantyDetError = false;
        clearPopup();
    }

    public Map<string,string> getGsqcustFailurenameslist() {

        return custFailureNameList;
    }

    public PageReference Validations(){
        mainSOQL();
        PageReference pageRef;
        try {
            string sSYScode = '';
            string sCOMPcode = '';

            if(selectedSysCode != null && selectedSysCode.contains('-')) {
                list<string> sscList = selectedSysCode.split('-');
                sSYScode = sscList[0];
            } else
                sSYScode = selectedSysCode;

            if(selectedCompCode != null && selectedCompCode.contains('-')) {
                list<string> sccList = selectedCompCode.split('-');
                sCOMPcode = sccList[0];
            } else
                sCOMPcode = selectedCompCode;
            if(failureMeasure==null || failureMeasure==''){
                failureMeasure = 'Miles';
            }
            system.debug('failureMeasure@@@'+failureMeasure);

            string strFailCode = sSYScode+sCOMPcode;
            string accCodeEdit;
            if(accCodeReturned != '' && accCodeReturned != null)
                accCodeEdit = accCodeReturned;
            else
                accCodeEdit = accCodeSelected;
            errormsgfailpoint = false;
            FCErrorval = false;
            blankField = false;
            set<string> tempblankfieldset = new set<string>();
            tempblankfieldset.add('false');

            errornotcovfound = false;
            solCompExistsFlag = 'false';
            chkClickonPartsCoverage = false;
            partcoverageFound = '';
            stopFailureSave = false;
            Map<Id, CSS_Solution_Component__c> solCompExists = new Map<Id, CSS_Solution_Component__c>([select id,fail_code__c,accountcodeedit__c,Selected_Component__c from CSS_Solution_Component__c where SysCodeAndCompCode__c =:strFailCode and accountcodeedit__c =:accCodeEdit and Service_Job__c =:wid and Selected_Component__c=true]);
            system.debug('solCompExists><>'+solCompExists);
            if(solCompExists != null && solCompExists.size() > 0) {
                system.debug('solCompExists.size()><>'+solCompExists.size());
                if(solCompExists.size() == 1) {
                    set<Id> SolIdSet = new set<Id>();
                    for(ID Ids : solCompExists.keyset()){
                        SolIdSet.add(Ids);
                        system.debug('SolIdSet><>'+SolIdSet);
                    }
                    system.debug('componentId><>'+componentId);
                    if(SolIdSet.contains(componentId)){
                        solCompExistsFlag = 'false';
                        system.debug('solCompExistsFlag'+solCompExistsFlag);
                    }
                    else
                    {
                        solCompExistsFlag = 'true';
                        system.debug('solCompExistsFlag'+solCompExistsFlag);
                    }
                } else
                    solCompExistsFlag = 'true';
            } else
                solCompExistsFlag = 'false';

            if((accCodeSelected == 'EMISSION WARRANTY 70' || accCodeSelected == 'Emissions Warranty70' || accCodeSelected == 'Emissions Warranty 70' || accCodeReturned == 'EMISSION WARRANTY 70') && (selectedFaultCode == null || selectedFaultCode == '')){
                FCErrorval = true;
                tempblankfieldset.add('true');

            }
            if(workJob.CoverageResponse__c != null && workJob.CoverageResponse__c != '' && !workJob.CoverageResponse__c.contains('Error')){
                basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                basicCoverageDetails = (CSS_getBasicCoverageResponseJ2A) JSON.deserialize(workJob.CoverageResponse__c, CSS_getBasicCoverageResponseJ2A.class);
                system.debug('basicCoverageDetails coverage resp' + basicCoverageDetails.Header);
                for (CSS_getBasicCoverageResponseJ2A.extendedCoverageDetails covdet: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.extendedCoverageDetails) {
                    for(CSS_getBasicCoverageResponseJ2A.coverageDetails c: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails) {
                        if ((accCodeSelected != null) && (accCodeSelected.contains('62') || accCodeSelected.contains('35') || accCodeSelected.contains('97') || accCodeSelected.contains('41'))) {
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
            css_solution_component__c solComp = new css_solution_component__c();
            try{
                solcomp = [select id,name,Failure_Point__c,Failure_Measure__c,Part_Warranty_Start_Date__c,Selected_Component__c from css_solution_component__c where name=:selectedFName and Component_Code__c=:selectedCompCode and System_Code__c=:selectedSysCode and Failure_Mode__c=:selectedFailMode limit 1];
            }
            catch(Exception ex){
                if(compToUpdate != null)
                    compToUpdate.AccountCodeEdit__c = ' '; // To avoid Blue Screen Error
            }


            string ERPSystem = workJob.Account__r.ERP_System__c;
            if((selectedFName=='' || selectedFName==null) || (selectedSysCode=='' || selectedSysCode==null) || (selectedCompCode=='' || selectedCompCode==null) ||
               (selectedFailMode=='' || selectedFailMode==null) || (accCodeEdit=='' || accCodeEdit==null || accCodeEdit=='Select One') || (payCodeSelected=='' || payCodeSelected==null) || (claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One') ||
               (failureMeasure=='' || failureMeasure==null) || (appCodeSelected=='' || appCodeSelected==null) ||
               compont.Part_Warranty_Start_Date__c == null || compont.Failure_Date__c == null || compont.Failure_Point__c==null)
            {
                if((selectedFName=='' || selectedFName==null) || (selectedSysCode=='' || selectedSysCode==null) || (selectedCompCode=='' || selectedCompCode==null) ||
                   ((selectedFailMode=='' || selectedFailMode==null) && (accCodeEdit==null || accCodeEdit=='' || accCodeEdit=='Select One'))){

                    tempblankfieldset.add('true');

                }
                else if(coverageFound=='false' && (accCodeEdit=='' || accCodeEdit==null || accCodeEdit=='Select One')){

                    tempblankfieldset.add('false');


                }

                if((selectedFailMode=='' || selectedFailMode==null) && (accCodeEdit!=null || accCodeEdit!='' || accCodeEdit!='Select One')){
                    tempblankfieldset.add('true');
                }

                if(accCodeEdit!='' && accCodeEdit!=null && accCodeEdit!='Select One'){
                    if((claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One') && displayERPButtonDlr == true){
                        tempblankfieldset.add('false');

                    }

                    if((claimTypeSelected=='' || claimTypeSelected==null || claimTypeSelected=='Select One') && ERPSystem=='One BMS' && isDealer == false)
                    {

                        tempblankfieldset.add('true');

                    }
                    If(accCodeEdit.contains('62') || accCodeEdit.contains('35') || accCodeEdit.contains('97') || accCodeEdit.contains('41'))
                    {
                        if(payCodeSelected=='' || payCodeSelected==null || payCodeSelected == 'Select One' && displayERPButtonDlr == true){
                            tempblankfieldset.add('false');
                        }
                        if((payCodeSelected=='' || payCodeSelected==null || payCodeSelected == 'Select One') && ERPSystem=='One BMS'){
                            tempblankfieldset.add('true');
                        }
                        if(compont.Failure_Date__c == null &&  workjob.Failure_Date__c == null){
                            tempblankfieldset.add('true');

                        }
                    }
                    else if((coverageType=='POL' || coverageType=='OTH') && accCodeEdit!=null && accCodeEdit!='' && accCodeEdit!='Select One')
                    {
                        if((appCodeSelected=='' || appCodeSelected==null) ){

                            tempblankfieldset.add('true');
                        }
                        else{

                            tempblankfieldset.add('false');
                            errornotcovfound = false;
                        }
                    }
                    else if((coverageType!='POL' || coverageType!='OTH') && coverageFound=='false' && accCodeEdit!=null && accCodeEdit!='' && accCodeEdit!='Select One' && (!accCodeEdit.contains('62') && !accCodeEdit.contains('35') && !accCodeEdit.contains('97') && !accCodeEdit.contains('41') && !accCodeEdit.contains('52'))){
                        if(checkCoverageonfm == null || checkCoverageonfm != true ||   failureinfochange == true || accCodeEdit!= '' ){ // GSSC-290 karthik G 
                            String tempAC;
                            if(accCodeSelected != null && accCodeSelected != '' && accCodeSelected != 'Select One'){
                                tempAC = accCodeSelected.RIGHT(2);
                            }
                            else{
                                tempAC = '';
                            }
                            system.debug('tempAC>>>>'+tempAC);
                            if(workJob.ApplicationCode__c=='130' || workJob.ApplicationCode__c=='210' || workJob.ApplicationCode__c=='220' || workJob.ApplicationCode__c=='310' || workJob.ApplicationCode__c=='320' || workJob.ApplicationCode__c=='410'){
                                system.debug('**********Entered ApplicationCode__c**************');
                                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workjob.Failure_Date__c,
                                                                                       string.valueof(workJob.Mileage__c),workJob.Mileage_Measure__c, workJob.ApplicationCode__c,workjob.Warranty_Start_Date__c,SelectedsysCode.Left(2),SelectedCompCode.Left(2),faultCode,tempAC,componentId,compont.Selected_Component__c,'',partsWarranty,'Second Call', workjob.ReconEngineFlag__c, false,workJob.Name);
                            }
                            else{
                                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workjob.Failure_Date__c,
                                                                                       string.valueof(workJob.CSS_Hours__c),'Hours', workJob.ApplicationCode__c,workjob.Warranty_Start_Date__c,SelectedsysCode.Left(2),SelectedCompCode.Left(2),faultCode,tempAC,componentId,compont.Selected_Component__c,'',partsWarranty,'Second Call', workjob.ReconEngineFlag__c, false,workJob.Name);
                            }


                            if(compToUpdate.AccountCodeEdit__c != null && compToUpdate.AccountCodeEdit__c != ' '){

                                coverageFound = 'true';
                                errornotcovfound = false;

                            }
                            else{
                                coverageFound = 'false';
                                if(checkCoverageonfm == null || checkCoverageonfm != true ||   failureinfochange == true ||  accCodeEdit!= '' ) {
                                    errornotcovfound = true;
                                }
                                system.debug('**********errornotcovfound**************'+errornotcovfound);

                            }
                            if(coverageType!='POL'){
                                if((payCodeSelected=='' || payCodeSelected==null || payCodeSelected == 'Select One') && displayERPButtonDlr==true){
                                    //blankField=false;
                                    tempblankfieldset.add('false');
                                }
                                else  if((payCodeSelected=='' || payCodeSelected==null || payCodeSelected == 'Select One') && ERPSystem=='One BMS'){
                                    // blankField=true;
                                    tempblankfieldset.add('true');
                                }

                            }
                        }    
                    }

                    //Failure
                    if((coverageType!='POL' || coverageType!='OTH') && accCodeEdit!=null && accCodeEdit!='' && accCodeEdit!='Select One' && (accCodeEdit.contains('62') || accCodeEdit.contains('35') || accCodeEdit.contains('97') || accCodeEdit.contains('41') || accCodeEdit.contains('52'))){
                        system.debug('inside'+coverageType+'partcoverageFound'+partcoverageFound+'coverageFound'+coverageFound);
                        if((coverageFound == 'true' || coverageFound == 'false') && partcoverageFound == 'true' && (tempblankfieldset!=null && !tempblankfieldset.contains('true'))){
                            system.debug('Helloo');
                            stopFailureSave = false;
                        }
                        else if((coverageFound == 'true' || coverageFound == 'false') && partcoverageFound == 'false' && (tempblankfieldset!=null && !tempblankfieldset.contains('true'))){
                            system.debug('Helloo2');
                            stopFailureSave = true;
                        }
                        else if((coverageFound == 'true' || coverageFound == 'false') && chkClickonPartsCoverage == false && (tempblankfieldset!=null && !tempblankfieldset.contains('true'))){

                            String selectedFailCodeMod;
                            String sysCode;
                            String componentCode;

                            List<String> failCodeSplit = new List<String>();
                            if(failCodeSelected!=null && failCodeSelected!='')
                                failCodeSplit = failCodeSelected.split('-');

                            if(failCodeSplit.size() > 1 && failCodeSplit[1] != null && failCodeSplit[1] != ''){
                                selectedFailCodeMod = failCodeSplit[1] .left(4);
                            }

                            if(selectedFailCodeMod != null && selectedFailCodeMod != ''){
                                sysCode = selectedFailCodeMod.left(2);
                                componentCode =  selectedFailCodeMod.right(2);
                            }
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
                                failureDate = workjob.Failure_Date__c;

                            String tempAC;
                            if(accCodeSelected != null && accCodeSelected != '' && accCodeSelected != 'Select One'){
                                tempAC = accCodeSelected.RIGHT(2);
                            }
                            else{
                                tempAC = '';
                            }

                            if(checkCoverageonfm == null || checkCoverageonfm != true ||   failureinfochange == true || accCodeEdit!= '' ){ // GSSC-290 karthik G 
                                // compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),failureDate,string.valueof(compont.Failure_Point__c),compont.Failure_Measure__c,workJob.ApplicationCode__c,compont.Part_Warranty_Start_Date__c,SelectedsysCode.Left(2),SelectedCompCode.Left(2),faultCode,tempAC,componentId,compont.Selected_Component__c,'',partsWarranty,'Second Call', workjob.ReconEngineFlag__c, false,workJob.Name); 
                                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),failureDate,string.valueof(compont.Failure_Point__c),failureMeasure,workJob.ApplicationCode__c,compont.Part_Warranty_Start_Date__c,SelectedsysCode.Left(2),SelectedCompCode.Left(2),faultCode,tempAC,componentId,compont.Selected_Component__c,'',partsWarranty,'Second Call', workjob.ReconEngineFlag__c, false,workJob.Name); 
                            }
                            //Added Validation for Inside Out Sprint #183076-- Rajasekhar H//
                            if(compToUpdate!= null && compToUpdate.AccountCode_Call_Status__c != null && compToUpdate.AccountCode_Call_Status__c != 'Failure'){
                                warrantyDetError=false;
                            }
                            else
                                warrantyDetError=true;
                            //End

                            if(compToUpdate!=null && compToUpdate.AccountCode__c != null && compToUpdate.AccountCode__c != '' && compToUpdate.AccountCode_Call_Status__c != 'Failure' && ( (compToUpdate.CoveredLaborHrs__c != '' && compToUpdate.CoveredLaborHrs__c != '0') ||
                                                                                                          (compToUpdate.CoveredMealsLodgingAmt__c != '' && compToUpdate.CoveredMealsLodgingAmt__c != '0') ||
                                                                                                          (compToUpdate.CoveredOCAmount__c != '' && compToUpdate.CoveredOCAmount__c != '0') ||
                                                                                                          (compToUpdate.CoveredPartsQty__c != '' && compToUpdate.CoveredPartsQty__c != '0') ||
                                                                                                          (compToUpdate.CoveredTowingMiles__c != '' && compToUpdate.CoveredTowingMiles__c != '0') ||
                                                                                                          (compToUpdate.CoveredTravelLabor__c != '' && compToUpdate.CoveredTravelLabor__c != '0') ||
                                                                                                          (compToUpdate.CoveredTravelMiles__c != '' && compToUpdate.CoveredTravelMiles__c != '0'))){
                                partcoverageFound = 'true';
                                stopFailureSave = false;

                            }
                            else{
                                partcoverageFound = 'false';
                                stopFailureSave = true;

                            }
                            system.debug('partcoverageFound--'+partcoverageFound);
                        }
                        system.debug('stopFailureSave'+stopFailureSave);

                    }


                }
            }
            if(tempblankfieldset.contains('true')){
                blankField=true;
            }
            else{
                blankField=false;
            }
        }catch(Exception e)  {
            system.debug('EXCEPTION of PopupSave method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            clearPopup();
        }
        return PageRef;
    }
    CSS_PSN__c psnRec = new CSS_PSN__c();
    //End

    public void onChangeofLicensePlate(){
        system.debug('onChangeofLicensePlate'+licenseplateSelected);
        if(licenseplateSelected == ''){
            licenseplateSelected = 'Select One';
        }
    }

    public void onChangeofAppCode(){
        invalidAppCode = '';
        if(appCodeSelected != null && appCodeSelected != ''){
            string validappCode;
            try{
                validappCode = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute4__c,Attribute5__c, Reason__c, Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'ApprovalAuthCode' AND Attribute4__c=:appCodeSelected].Attribute5__c;

            }
            catch(exception Err){
                system.debug('TEST'+Err.getMessage()+' Appy'+Err.getLineNumber());
            }
            if(validappCode == 'Y'){
                invalidAppCode = 'false';

            }
            else
                invalidAppCode='true';
        }
        else
            invalidAppCode = 'false';


    }


    public void checkFailMode(){
        system.debug('selectedFailMode---'+selectedFailMode);
        //invalidFailMode=false;
        //if(componentCodeList!=null && componentCodeList.size()>0){
        coverageFound = 'false';
        for(CSS_JobEventTemporary__c jobTemp:[select Attribute1__C,Attribute3__c,Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailModes' and Active__c= true]){
            string temp1;
            temp1 = jobTemp.Attribute1__c+'-'+jobTemp.Attribute3__c.replace('\'\\','');
            if(selectedFailMode!='' && selectedFailMode != null){
                system.debug('temp1***' + temp1 + selectedFailMode);
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
        if((accountcodeeditonfm ==null && (failmodeloadval == '' || failmodeloadval== null)) || (accountcodeeditonfm ==false && (failmodeloadval == '' || failmodeloadval== null)) || (accountcodeeditonfm== true && (failmodeloadval == '' || failmodeloadval== null)) ){

            system.debug('before calling getcov');
            checkCoverageNew();
            system.debug('after calling get cov');
            checkCoverageonfm = true;
            failureinfochange = false;
        }
        system.debug('checkCoverageonfm'+checkCoverageonfm);
        system.debug('failureinfochange'+failureinfochange);

        //}
    }

    public void checkFaultCode(){

        //Story 188014 code changes start
        transient List<CSS_SMN_FaultCode__c> tempList = [select FC_Desc__c from CSS_SMN_FaultCode__c where SMN__c=: workJob.Service_Model__c];
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
    }
    public Set<String> getfailurenames(){
        return failureNameList;
    }

    public Set<String> getComponentCodes(){

        return componentCodeList;

    }

    public Set<String> getSystemCodes(){

        return systemCodeList;

    }

    public List<String> getFailModes() {
        List<CSS_JobEventTemporary__c> tempList = [select Attribute1__C,Attribute3__c,Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailModes' and Active__c= true];
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


    public List<String> getFaultCodes(){

        List<String> tempStr = new List<String>();
        //Story 188014 code changes start
        List<CSS_SMN_FaultCode__c> tempList = [select FC_Desc__c from CSS_SMN_FaultCode__c where SMN__c=: workJob.Service_Model__c];
        for(CSS_SMN_FaultCode__c lst : tempList){
            //string temp;
            //temp = lst.Attribute1__c + '-' + lst.Attribute3__c.replace('\'','');
            tempStr.add(lst.FC_Desc__c);
        }

        //Story 188014 code changes end
        tempList = null;
        return tempStr;
    }

    public void getPayCodesonAccCodeChange(){

        clearPopup(); // clearPopup inturn calls getCoverageType();
        system.debug('Calling karthik');
        errornotcovfound = false;//Added Prabhakar
        coverageFound='false';
        pleaseselacc =false;
        AuthorizationNumber = '';
        ApprovalCode = '';
        blankField=false;
        invalidAppCode = 'false';
        dateErrFlag = false;
        higherdateErrFlag = false;
        FCErrorval = false;
        selectedAccFormula = null;
        checkPartsWarrStartDt = false;
        failureinfochange = true; //GSSC-290 karthik G added 

        if(accCodeSelected.containsIgnoreCase('Emissions Warranty70') || accCodeSelected.containsIgnoreCase('Emissions Warranty70'))
        {
            selectedAccFormula = true;
        }else{
            selectedAccFormula = false;
        }
        mapAccCode = new Map<string,String>();
        lstPCvalues = new list<selectoption>();
        List<CSS_JobEventTemporary__c> lstpayCodeReason = [select Attribute3__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes' and Attribute3__c =:accCodeSelected.right(2).trim()];
        for(CSS_JobEventTemporary__c jet: lstpayCodeReason){

            if(jet.Reason__c !=null){
                mapAccCode.put(jet.Attribute3__c,jet.Reason__c);
            }
        }

        lstPCvalues = getPayCodesList(accCodeSelected.right(2).trim());
        system.debug('lstPCvalues>>>'+lstPCvalues);
    }

    public void getPayCodesonAccCodeChangeOnLoad(){
        coverageFound='false';
        pleaseselacc = false;
        AuthorizationNumber = '';
        ApprovalCode = '';
        blankField=false;
        invalidAppCode = 'false';
        dateErrFlag = false;
        higherdateErrFlag = false;
        FCErrorval = false;
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
        system.debug('mapAccCode**'+mapAccCode);
        //payCodeSelected = '';
        lstPCvalues = getPayCodesList(accCodeSelected.right(2).trim());
        system.debug('accCodeSelected'+accCodeSelected);
        //getCoverageType();
        system.debug('coverageType'+coverageType);

    }

    public List<SelectOption>  getclaimTypes(){
        claimTypes = new List<SelectOption>();
        system.debug('Location***'+workjob.CSS_Job_Location_Code__c);
        claimTypes = CG_BL_Claims.getClaimType(Wid,workjob.CSS_Job_Location_Code__c,'ClaimsFC');
        system.debug('ClaimTypes***'+claimTypes);

        //claimTypes.sort();
        return claimTypes;

    }

    public void checkCoverageNew(){

        try{
            if(checkCoverageonfm == null || checkCoverageonfm != true ||   failureinfochange == true  ) { 
                system.debug('newnew');
                mainSOQL();
                blankfield = false;
                partcoverageFound = '';
                compToUpdate = new CSS_Solution_Component__c();
                CSS_Claims__c  claimsRec = new CSS_Claims__c();
                CSS_PSN__c  psnRec = new CSS_PSN__c();
                lstPCvalues = new list<selectoption>();
                mapAccCode = new Map<string,String>();
                showDisabledAC = false;
                string accCodeEdit;
                system.debug('accCodeReturned'+accCodeReturned);
                system.debug('accCodeSelected'+accCodeSelected);
                if(accCodeReturned != '' && accCodeReturned != null){
                    accCodeEdit = accCodeReturned;
                }
                else{
                    
                    accCodeSelected= accCodeSelected !=null ? accCodeSelected.replace('Select One', '') : '';
                    accCodeEdit = accCodeSelected;
                    system.debug('accCodeEdit>>>'+accCodeEdit);
                }
                accCodeEdit = accCodeEdit.right(2).trim();
                system.debug('accCodeEdit>>>'+accCodeEdit);
                css_solution_component__c solComp = new css_solution_component__c();
                try{
                    solcomp = [select id,name,Failure_Point__c,Failure_Measure__c,Part_Warranty_Start_Date__c,Selected_Component__c from css_solution_component__c where name=:selectedFName and Component_Code__c=:selectedCompCode and System_Code__c=:selectedSysCode and Failure_Mode__c=:selectedFailMode limit 1];
                }
                catch(Exception ex){
                    compToUpdate.AccountCodeEdit__c = ' '; // To avoid Blue Screen Error
                }
                system.debug('solcomp'+solcomp);
                if(solcomp!=null){
                    if(SelectedsysCode != null && SelectedsysCode != '')
                        SelectedsysCode = SelectedsysCode.Left(2);
                    if(SelectedCompCode != null && SelectedCompCode != '')
                        SelectedCompCode = SelectedCompCode.Left(2);
                    system.debug('checkCoverageonfm'+checkCoverageonfm);
                    system.debug('failureinfochange'+failureinfochange);
                    system.debug('accCodeEdit'+accCodeEdit);
                    system.debug('accCodeSelected'+accCodeSelected);

                    if((solComp.Failure_Point__c != null && string.valueof(solComp.Failure_Point__c) != '') && 
                       (solComp.Failure_Measure__c != null && solComp.Failure_Measure__c != '')){
                        if(workJob.ApplicationCode__c=='130' || workJob.ApplicationCode__c=='210' || 
                           workJob.ApplicationCode__c=='220' || workJob.ApplicationCode__c=='310' || 
                           workJob.ApplicationCode__c=='320' || workJob.ApplicationCode__c=='410'){
                            system.debug('**********Entered ApplicationCode__c**************');
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workjob.ESN__c,(workjob.CSS_Job_Location_Code__c).right(5),
                                                                                   workjob.Failure_Date__c,string.valueof(workJob.Mileage__c),
                                                                                   workJob.Mileage_Measure__c,workjob.ApplicationCode__c,
                                                                                   workjob.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',accCodeEdit,
                                                                                   solComp.id,solComp.Selected_Component__c,'','','Second Call', 
                                                                                   workjob.ReconEngineFlag__c, false,workJob.Name);
                            system.debug('workJob.ApplicationCode__c'+workJob.ApplicationCode__c);
                        }
                        else{
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workjob.ESN__c,(workjob.CSS_Job_Location_Code__c).right(5),
                                                                                   workjob.Failure_Date__c,string.valueof(workJob.CSS_Hours__c),'Hours',workjob.ApplicationCode__c,workjob.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', workjob.ReconEngineFlag__c, false,workJob.Name);
                            system.debug('workJob.ApplicationCode__c'+workJob.ApplicationCode__c);
                        }


                        //compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workjob.ESN__c,(workjob.CSS_Job_Location_Code__c).right(5),workjob.Failure_Date__c,string.valueof(solComp.Failure_Point__c),solComp.Failure_Measure__c,workjob.ApplicationCode__c,workjob.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'','',solComp.id,solComp.Selected_Component__c,'','','Second Call', workjob.ReconEngineFlag__c, false);
                    }
                    else{
                        if(workJob.ApplicationCode__c=='130' || workJob.ApplicationCode__c=='210' || 
                           workJob.ApplicationCode__c=='220' || workJob.ApplicationCode__c=='310' || workJob.ApplicationCode__c=='320' ||
                           workJob.ApplicationCode__c=='410'){
                            system.debug('**********Else ApplicationCode__c**************');
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workjob.ESN__c,(workjob.CSS_Job_Location_Code__c).right(5),
                                                                                   workjob.Failure_Date__c,string.valueof(workJob.Mileage__c),
                                                                                   workJob.Mileage_Measure__c,workjob.ApplicationCode__c,
                                                                                   workjob.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',accCodeEdit,
                                                                                   solComp.id,solComp.Selected_Component__c,'','','Second Call', 
                                                                                   workjob.ReconEngineFlag__c, false,workJob.Name);
                            system.debug('workJob.ApplicationCode__c'+workJob.ApplicationCode__c);
                            // compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workjob.ESN__c,(workjob.CSS_Job_Location_Code__c).right(5),workjob.Failure_Date__c,string.valueof(workjob.Mileage__c),workjob.Mileage_Measure__c == null || workjob.Mileage_Measure__c == ''? 'Miles' : workjob.Mileage_Measure__c,workjob.ApplicationCode__c,workjob.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'','',solComp.id,solComp.Selected_Component__c,'','','Second Call', workjob.ReconEngineFlag__c, false);
                        }
                        else{
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workjob.ESN__c,(workjob.CSS_Job_Location_Code__c).right(5),
                                                                                   workjob.Failure_Date__c,string.valueof(workJob.CSS_Hours__c),'Hours',workjob.ApplicationCode__c,workjob.Warranty_Start_Date__c,SelectedsysCode,SelectedCompCode,'',accCodeEdit,solComp.id,solComp.Selected_Component__c,'','','Second Call', workjob.ReconEngineFlag__c, false,workJob.Name);
                            system.debug('workJob.ApplicationCode__c'+workJob.ApplicationCode__c);
                        }
                    }

                }

                //Added Validation for Inside Out Sprint #183076-- Rajasekhar H//  
                if(compToUpdate!=null && compToUpdate.AccountCode_Call_Status__c != null && compToUpdate.AccountCode_Call_Status__c != 'Failure')
                    warrantyDetError=false;
                else
                    warrantyDetError=true;
                //End

                if(compToUpdate!=null && compToUpdate.AccountCodeEdit__c != null && compToUpdate.AccountCodeEdit__c != ' '){
                    system.debug('InsideAccountCodeIF**');
                    system.debug('compToUpdate.AccountCodeEdit__c**'+compToUpdate.AccountCodeEdit__c);
                    coverageFound = 'true';
                    errornotcovfound = false;
                    //accCodeReturned = compToUpdate.AccountCodeEdit__c;
                    accCodeSelected = compToUpdate.AccountCodeEdit__c;
                    //accCodeReturned = 'CMP-Campaign / Recalls 65'; // For Testing Purpose
                    //payCodeSelected = 'I';
                    payCodeSelected = compToUpdate.Pay_Code__c;

                    //string orgtype=css_utility.getOrgType(userinfo.getUserId());
                    Account Regionterritory = css_utility.getRegionTerritory(workJob.Creator_Location__c);
                    string orgtype;
                    boolean dlrOrgType=css_utility.getAccounttype(workJob.Account__r.Type);
                    if(dlrOrgType == false){
                        orgtype = 'DISTR';
                    }

                    User usr;
                    usr = css_utility.getUserAttributes(userinfo.getUserId());
                    string userRole = usr.UserRoleName__c;

                    system.debug('orgtype--->'+orgtype);
                    //system.debug('Regionterritory--->'+Regionterritory.Region__c);
                    system.debug('userRole--->'+userRole);

                    //List<CSS_JobEventTemporary__c> jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' order by Attribute2__c asc];
                    if(userRole.contains('Factory') || userRole.contains('DFSE') || userRole.contains('CFSE'))
                    {
                        List<CSS_JobEventTemporary__c> jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                    else{
                        if (orgtype=='DISTR'){
                            system.debug('Inside DISTR');
                            List<CSS_JobEventTemporary__c> jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                            system.debug('jobEventTemp--'+jobEventTemp);
                        }
                        else{
                            if(Regionterritory.Region__c != null && Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA'){
                                List<CSS_JobEventTemporary__c> jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c, Attribute15__c FROM CSS_JobEventTemporary__c WHERE Attribute15__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                            }
                            else{
                                List<CSS_JobEventTemporary__c> jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                            }
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
                            accCodesNew.add(new SelectOption(s,s));
                            //accCode = accCodeSelected;
                        }
                        accCodesNew.sort();
                        accCodes.addAll(accCodesNew);

                        //Preparing PayCodeList
                        List<CSS_JobEventTemporary__c> lstpayCodeReason = [select Attribute3__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes' and Attribute3__c =:accCodeSelected.right(2).trim()];
                        system.debug('PayCodeReason**'+lstpayCodeReason);
                        for(CSS_JobEventTemporary__c jet: lstpayCodeReason){

                            if(jet.Reason__c !=null){
                                mapAccCode.put(jet.Attribute3__c,jet.Reason__c);
                            }
                        }
                        system.debug('mapAccCode**'+mapAccCode);

                        lstPCvalues = getPayCodesList(accCodeSelected.right(2).trim());
                        //update compToUpdate;

                        system.debug('solcomp**'+solcomp);
                        system.debug('compToUpdate**'+compToUpdate);
                    }
                }
                else {
                    system.debug('InsideAccountCodeElseIF**');
                    warrantyCompFailure = false;
                    coveragefound='false';
                    pleaseselacc = true;
                    accCodeSelected = '';
                    accCodeReturned = '';

                    //Preparing AccountCode List
                    //List<CSS_JobEventTemporary__c> jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Key__c = 'AccountCodes' order by Attribute2__c asc];
                    // string orgtype=css_utility.getOrgType(userinfo.getUserId());
                    string orgtype;
                    boolean dlrOrgType=css_utility.getAccounttype(workJob.Account__r.Type);
                    if(dlrOrgType == false){
                        orgtype = 'DISTR';
                    }

                    Account Regionterritory = css_utility.getRegionTerritory(workJob.Creator_Location__c);

                    User usr;
                    usr = css_utility.getUserAttributes(userinfo.getUserId());
                    string userRole = usr.UserRoleName__c;

                    system.debug('orgtype--->'+orgtype);
                    //system.debug('Regionterritory--->'+Regionterritory.Region__c);
                    system.debug('userRole--->'+userRole);

                    if(userRole.contains('Factory') || userRole.contains('DFSE') || userRole.contains('CFSE'))
                    {
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                    else{
                        if (orgtype=='DISTR'){
                            system.debug('Inside DISTR');
                            jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                        }
                        else{
                            if(Regionterritory.Region__c != null && Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA'){
                                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Attribute15__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                            }
                            else{
                                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                            }
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


                        system.debug('Query--->'+jobEventTemp);
                        system.debug('lstaccCodes--->'+accCodes);
                    }
                    //Preparing PayCodeList

                    List<CSS_JobEventTemporary__c> lstpayCodeReason = [select Attribute3__c,Reason__c from CSS_JobEventTemporary__c where key__c = 'AccountCodes' and Attribute3__c =:accCodeReturned.right(2).trim()];
                    system.debug('PayCodeReason**'+lstpayCodeReason);
                    for(CSS_JobEventTemporary__c jet: lstpayCodeReason){

                        if(jet.Reason__c !=null){
                            mapAccCode.put(jet.Attribute3__c,jet.Reason__c);
                        }
                    }
                    system.debug('mapAccCode**'+mapAccCode);

                    lstPCvalues = getPayCodesList(accCodeReturned.right(2).trim());

                    system.debug('solcomp**'+solcomp);
                    system.debug('compToUpdate**'+compToUpdate);

                }
                getCoverageType();
                system.debug('coverageFound>>>**'+coverageFound);
            }
        }
        catch(Exception ex){
            system.debug('Catch Check Coverage'+ ex.getmessage()+' '+ex.getLineNumber());
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
        }catch(Exception e)  {
            system.debug('EXCEPTION of getPayCodes method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return lstPCValues;
    }
    public void changefailmode(){

        selectedFailModeValue=selectedFailMode;
        system.debug('selectedFailModeValue selectedFailModeValue'+selectedFailModeValue);
        system.debug('selectedFailMode selectedFailMode'+selectedFailMode);
    }
    public void changefaultcode(){
        system.debug('selectedFaultCode selectedFaultCode'+selectedFaultCode);
        selectedFaultCodeValue=selectedFaultCode;
    }

    public PageReference getCompID() {
        displayMPopUp = true;

        compont = new css_solution_component__c();
        compID1 = componentId;
        if(accCodeEditable != null && accCodeEditable != '')
            accCodeEditable = accCodeEditable.trim();
        boolean accCodeExist = false;
        if(accCodes != null){
            for(SelectOption aCode: accCodes){
                if(aCode.getValue() == accCodeEditable){
                    accCodeExist = true;
                    break;
                }
            }
            if(accCodeExist == false && accCodeEditable != ''){
                accCodes.add(new SelectOption(accCodeEditable,accCodeEditable));
                accCodes.remove(0);
                accCodes.sort();
                accCodes.add(0,(new SelectOption('Select one','Select One')));
            }
        }
        if(componentId != null)
            compont = [SELECT Id, name,FailMode_Desc__c,FaultCode_Desc__c,SystemCode_Desc__c,ComponentCode_Desc__c,System_Code__c,Component_Code__c,FailCode_Formula__c, AccountCodeEdit__c, Fail_Code_Editable__c, CSS_Account_Formula__c, Parts_Warranty__c, Customer_Take_Possession__c, Claim_Type__c,Failure_Mode__c,Part_Warranty_Start_Date__c, Failure_Date__c, Failure_Point__c, Failure_Measure__c, Selected_Component__c, Solutions__r.FaultCode__c, AccountCode__c, Authorization_Number__c, Approval_Code__c, Pay_Code__c FROM CSS_Solution_Component__c WHERE Id =: componentId];

        faultCode = compont.solutions__r.FaultCode__c;
        system.debug('faultCodeEdit'+faultCode);

        if(failCodeEditable != compont.Fail_Code_Editable__c)
            failCodeEditable = compont.Fail_Code_Editable__c;
        if(failCodeEditable != null && failCodeEditable != ''){
            failCodeSelected = failCodeEditable;
        }
        else{
            if(fcWS !=null && fcWS != '')
                failCodeSelected = compName+'-'+fcWS;
        }

        if(failCodeEditable== null || failCodeEditable == '' || failCodeEditable == 'Select One'){
            failCodeChange = true;
            system.debug('fcWS--'+fcWS);
            system.debug('compName--'+compName);
            if(fcWS != null && fcWS != '')
                showDisabledAC = true;
            else
                showDisabledAC = false;
        }
        else{
            failCodeChange = false;
            showDisabledAC = false;
        }
        fcPopup = failCodeSelected;
        if(accCodeEditable!=null && accCodeEditable!=''){
            showDisabledAC = false;
            accCodeSelected = accCodeEditable;
        }
        else if(accountCodeType!=null && accountCodeType!=''){
            showDisabledAC = false;
            accCodeSelected = accountCodeType;
        }
        else
            showDisabledAC = true;
        system.debug('accCodeEditable--'+accCodeEditable);
        /*if((accCodeEditable != null && accCodeEditable != '') || (compont.CSS_Account_Formula__c != null && compont.CSS_Account_Formula__c != ''))
showDisabledAC = true;
else {
if(fcWS != null && fcWS != '')
showDisabledAC = true;
else
showDisabledAC = false;
}*/
        if((compont.CSS_Account_Formula__c != null && compont.CSS_Account_Formula__c != '') && (compont.AccountCodeEdit__c == null || compont.AccountCodeEdit__c == ''))
            accCodeWS = compont.CSS_Account_Formula__c.Trim();

        if(compont.Parts_Warranty__c != null && compont.Parts_Warranty__c != '')
            partsWarranty = compont.Parts_Warranty__c;
        if(compont.Customer_Take_Possession__c != null && compont.Customer_Take_Possession__c != '')
            custSelect = compont.Customer_Take_Possession__c;
        if(compont.Failure_Measure__c != null && compont.Failure_Measure__c != '')
            failureMeasure = compont.Failure_Measure__c;
        getCoverageType();
        return null;
    }

    public void failCodeChangeGO(){
        system.debug('inside failCodeChangeGO');
        showDisabledAC = false;
        accCodeSelected = '';
        accCodeWS = '';
        if(failCodeSelected == null || failCodeSelected == '' || failCodeSelected == 'Select One')
            failCodeChange = true;
        else
            failCodeChange = false;
    }

    public void mainSOQL(){
        /* workJob=[Select Id,Name,AccessCode__c,Account__r.ERP_System__c,Email_Address__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Cstmr_Contacts_Phone__c,Shop_Work_Order__c, Application__c, Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
Repair_Location__c,Before_In_Service__c,ProductApplicationCode__c,CSS_Channel_Of_Distribution__c,SP_ClaimAllowedDays__c,SP_CMISPExpirationDate__c,SP_LTAFlag__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,EditComplaint__c,EditCorrection__c,EditCoverage__c,EditCause__c,MarineFlag__c,OemCode__c,EtoConversionDate__c,
Phone_Number__c,Quote_ID__c, Previous_Status__c,Sub_Type__c, Category__c, Category_Desc__c, Complaint_Type__c, Complaint_Type_Desc__c, Model__c,Creator_Location__c, Control_Number__c,Equipment_ID__c,DesignPhaseCode__c,warrantyIndicatorFlag__c,
Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,SP_PrimaryOEMCode__c,SP_OutfileAllClaims__c,CSS_Job_Location_Code__c, CSS_Resolution__c,CSS_Feedback_Comments__c,ProductApplicationDesp__c,
ESN__c, Mileage__c,Contact_ID__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c,SP_PACCAR__c,SP_Region__c,SP_RegionCode__c,SP_AccountStatus__c,SP_TerritoryCode__c,BillToCode__c,BuildDate__c,Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Actual_Technician_Time__c,ApplicationCode__c,
Service_Model_N__c, Miles_or_Km__c, CSS_Hours__c
from CSS_Job_Order__c where id= :Wid]; */
        workJob=[Select Id,SPDataWebserviceResult__c,ODM_Status_Message__c,PACCAR_Auth_Required__c,Name,CSS_Travel_Rate__c,SP_CutOffClaimAmt__c,CSS_In_Shop_Labor_Rate__c,CSS_Field_Service_Labor_Rate__c,SP_BusinessUnit__c,SP_CampaignTRP__c,   SP_CommunicationMethod__c, SP_CommunicationOccurrence__c, SP_CostEffectiveExclusion__c, SP_DisableWebAccessFlag__c, SP_DistributorHQCode__c, SP_DistributorHQName__c, SP_DSID__c, SP_DTNAFlag__c, SP_FreezeSubmitButton__c, SP_GroupName__c,  SP_MaxClaimAmt__c, SP_NewOEM__c,   SP_PMUSplitPayment__c, SP_Policy__c,  SP_PrimaryOEMName__c, SP_ProductCertification__c, SP_PromotionId__c, SP_PSBUProductCertification__c,  SP_RepairLevel__c,    SP_TechActualHoursRequired__c, SP_ViewDollarAmount__c,  SP_WarrantyEmail__c, SP_WarrantyFax__c, SP_WarrantyTrainingCertification__c,  SP_WWSPSSPFlag__c, ReconEngineFlag__c, AccessCode__c,Account__c,Account__r.ERP_System__c,Email_Address__c,BMSWSStatus__c,BMSStatus__c,Customer_Name__c,Cstmr_Contacts_Phone__c,Shop_Work_Order__c,
                 Application__c,Application_Desc__c, BMS_Last_Name__c, DSID_WorkGroup__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c, First_Name__c,
                 Repair_Location__c,Before_In_Service__c,Sp_TERRITORY__c,CSS_Channel_Code__c,ProductApplicationCode__c,CSS_Channel_Of_Distribution__c,SP_ClaimAllowedDays__c,SP_CMISPExpirationDate__c,SP_LTAFlag__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c,  Service_Model__c, VIN__c, Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,
                 DSID__c, DSID_Creation_Timestamp__c,account__r.RSS_RESP_BRANCH_CODE__c,DSID_Status__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Customer_Code__c,Status__c,EditComplaint__c,EditCorrection__c,EditCoverage__c,EditCause__c,MarineFlag__c,OemCode__c,EtoConversionDate__c,
                 Phone_Number__c,SP_WarrantyTrainingStatus__c,SP_Country__c,EngineFamilyName__c,SP_State__c,SP_SCMDollarAmt__c,Automotive_App_Flag__c,Quote_ID__c, Previous_Status__c,Sub_Type__c, Category__c, Category_Desc__c, Complaint_Type__c, Complaint_Type_Desc__c, Model__c,Creator_Location__c, Control_Number__c,Equipment_ID__c,DesignPhaseCode__c,warrantyIndicatorFlag__c,
                 Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,OwnerId,JobLocation__c,SP_PrimaryOEMCode__c,SP_OutfileAllClaims__c,CSS_Job_Location_Code__c, CSS_Resolution__c,CSS_Feedback_Comments__c,ProductApplicationDesp__c,License_Plate__c,
                 ESN__c, Non_SRT_Details__c,Mileage__c,CoverageResponse__c ,Account__r.Type,SP_WarrantyCertificationEndDate__c,Territory_Class__c,Territory_Class_Name__c,Contact_ID__c,CSS_Hours__c, Mileage_Measure__c, chevron_page__c, General_Symptoms__c,SP_PACCAR__c,SP_Region__c,SP_RegionCode__c,SP_AccountStatus__c,SP_TerritoryCode__c,BillToCode__c,BuildDate__c,Assigned_To__c, LastModifiedDate,CreatedDate,ESN_Locked__c,Actual_Technician_Time__c,ApplicationCode__c,SP_SCMDeductiblePercentage__c
                 from CSS_Job_Order__c where id= :Wid];
        system.debug('-->Creator_Location__c<--'+workJob.Creator_Location__c);
        system.debug('-->chevron_page__c<--'+workJob.chevron_page__c);
        system.debug('-->Application__c--'+workJob.Application__c);
        system.debug('-->ApplicationCode__c<--'+workJob.ApplicationCode__c);
    }

    public CSS_JobPlanOverviewControllerNew() {
        invalidAppCode = 'false';
        dateErrFlag = false;
        higherdateErrFlag = false;
        blankField = false;
        FCErrorval= false;
        checkCoverageonfm = false;
        showResolutionRequired = false;//Added by Rajesh Narra
        showRepairRequired = false;//Added by Rajesh Narra
        failureinfochange= false;
        failureNameList = new Set<String>();
        componentCodeList = new Set<String>();
        systemCodeList = new Set<String>();
        failureNameWithSystemCodeMap = new Map<String,String>();
        failureNameWithCompCodeMap = new Map<String,String>();
        FailureNameWithFailureIDMap = new Map<String,String>();
        custFailureNameSysCodeMap = new Map<String,String>();
        custFailureNameCompCodeMap = new Map<String,String>();
        sysCodeCustFailureNameMap = new Map<String,String>();
        custFailureNameList=new Map<String,String>();
        warrantyFailure = false;
        datebyLocaleValue = css_utility.getFormattedDate();
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        workjobStatus=ApexPages.CurrentPage().getParameters().get('status');
        string partsUr = ApexPages.CurrentPage().getParameters().get('joPa');

        try {
            mainSOQL();
            displayERPButton = css_utility.showQuotePage(UserInfo.getUserId(), workJob.Creator_Location__c);
            String orgtype=css_utility.getOrgType(userinfo.getUserId());
            if (orgtype != null && orgtype != ''){
                if (orgtype == 'DISTR'){
                    displayERPButtonDist = true;
                    isDealer = false;
                    system.debug('orgtype---->'+orgtype);
                    system.debug('displayERPButtonDist---->'+displayERPButtonDist);
                }else if(orgtype == 'DLR') {
                    isDealer = true;
                }else {
                    displayERPButtonDlr = true;
                    system.debug('displayERPButtonDlr ---->'+displayERPButtonDlr);
                }
            }

            displaySendERP_Button = css_utility.getclaimsapprove(UserInfo.getUserId());
            system.debug('displaySendERP_Button-->'+displaySendERP_Button);
            buildConcatenatedFailCodes();
            System.debug('****workJob.EditComplaint__c'+workJob.EditComplaint__c);

            System.debug('****counter'+correctioncounter);

            system.debug('workjob status '+workjobStatus);
            css_header_nav__c CS = css_header_nav__c.getInstance(UserInfo.getProfileId());

            string userId = UserInfo.getUserId();
            system.debug('userId*****'+userId);

            //Modified as per story# 76192
            bmsEnabled=css_utility.getBMSEnabled(workJob.Creator_Location__c);
            system.debug('bmsEnabled - Intake'+bmsEnabled);

            showJobPlanBlocks(true,false,false,false, false,false,true);
            //partsListWrap = getListWrap();

            getclaimTypes();
            checkspdata = false;
            /*if(workJob.CSS_Travel_Rate__c=='0'|| string.isBlank(workJob.CSS_Travel_Rate__c) || (string.isBlank(workJob.CSS_In_Shop_Labor_Rate__c) || (string.isNotBlank(workJob.CSS_In_Shop_Labor_Rate__c) && double.valueOf(workJob.CSS_In_Shop_Labor_Rate__c)==0))){
system.debug('Testing:- FetchSPData Starts here>>>>');
workJob = CG_BL_Intake.fetchSPData(workJob, workJob.creator_location__c, null, workJob.Failure_Date__c, null);
checkspdata=true;
}*/
        }
        catch(Exception e)  {
            system.debug('in the exception of JobPlan Controller'+e.getLinenumber()+e.getmessage());
        }
    }
    public boolean checkspdata = false;
    public ID Wid;
    public css_job_order__c workJob {get;set;}
    public List<CSS_SymptomQA__c> sympList = new List<CSS_SymptomQA__c>();
    public List<CSS_Solutions__c> solutionList = new List<CSS_Solutions__c>();
    public List<CSS_Solution_Component__c> compPartsList = new List<CSS_Solution_Component__c>();
    public List<CSS_Solution_Component__c> compRepList = new List<CSS_Solution_Component__c>();
    public CSS_Solution_Component__c compont {get;set;}
    @TestVisible
    List<CSS_Fault_Code__c> allFaultCodes = new List<CSS_Fault_Code__c>();
    public List<CSS_WPR_JobPlanOverview> partsListWrap{get;set;}
    public CSS_WPR_JobPlanOverview partsWrap;
    public CSS_WPR_JobPlanOverview partsFCWrap;
    public List<CSS_WPR_JobPlanOverview.solCompWrapper>  lstsolComponentWrap = new List<CSS_WPR_JobPlanOverview.solCompWrapper>();
    public List<CSS_WPR_JobPlanOverview.solCompWrapper>  lstsolComponentFCWrap = new List<CSS_WPR_JobPlanOverview.solCompWrapper>();
    public CSS_WPR_JobPlanOverview.solWrapper solWrap;
    public CSS_WPR_JobPlanOverview.solWrapper solWrap1;

    public string jo_btn_cls { get; set; }
    public string srt_btn_cls { get; set; }
    public string prt_btn_cls { get; set; }
    public string war_btn_cls { get; set; }
    public string nar_btn_cls { get; set; }
    public string qt_btn_cls { get; set; }

    public string jo_chv_sts { get; set; }
    public string srt_chv_sts { get; set; }
    public string prt_chv_sts { get; set; }
    public string war_chv_sts { get; set; }
    public string nar_chv_sts { get; set; }
    public string qt_chv_sts { get; set; }

    public string jo_txt_sts { get; set; }
    public string srt_txt_sts { get; set; }
    public string prt_txt_sts { get; set; }
    public string war_txt_sts { get; set; }
    public string nar_txt_sts { get; set; }
    public string qt_txt_sts { get; set; }

    public string jo_txt_val { get; set; }
    public string srt_txt_val { get; set; }
    public string prt_txt_val { get; set; }
    public string war_txt_val { get; set; }
    public string nar_txt_val { get; set; }
    public string qt_txt_val { get; set; }


    public Boolean show_jo_pnl { get; set; }
    public Boolean show_narr_pnl { get; set; }
    public Boolean show_srt_pnl { get; set; }
    public Boolean show_prt_pnl { get; set; }
    public Boolean show_war_pnl { get; set; }
    public Boolean show_jpq_pnl { get; set; }
    public Boolean show_jov_pnl { get; set; }


    public string mil_measure;
    public string comm {get;set;}
    public string jobLocation;

    public Boolean displayPopup {get;set;}
    // public Attachment attachObj{get;set;}
    // public Boolean enableAcceptQuote;
    // public boolean dsidStatus {get;set;}
    public boolean bmsEnabled {get;set;}

    /******* Method for Chevrons Initialization ****/
    public void showJobPlanBlocks(boolean jo_stat,boolean srt_stat,boolean prt_stat, boolean war_stat, boolean jo_narr,boolean jpq_stat,boolean jov_stat)
    {
        show_jo_pnl = jo_stat;
        show_narr_pnl = jo_narr;
        show_srt_pnl = srt_stat;
        show_prt_pnl = prt_stat;
        show_war_pnl = war_stat;
        show_jpq_pnl = jpq_stat;
        show_jov_pnl = jov_stat;
        if (jo_stat)
        {
            jo_btn_cls = 'chev_jpo_img_active';
            srt_btn_cls = 'chev_jpsrt_img_open';
            prt_btn_cls = 'chev_jpparts_img_open';
            war_btn_cls = 'chev_wr_img_open';
            nar_btn_cls = 'chev_jpnarrative_img_open';//check
            qt_btn_cls = 'chev_jpquote_img_open';

            jo_chv_sts = 'sactive';
            srt_chv_sts = 'sopen';
            prt_chv_sts = 'sopen';
            war_chv_sts = 'sopen';
            nar_chv_sts = 'sopen';
            qt_chv_sts = 'sopen';

            jo_txt_sts =  'chev_text_active';
            srt_txt_sts =  'chev_text_open';
            prt_txt_sts =  'chev_text_open';
            war_txt_sts =  'chev_text_open';
            nar_txt_sts =  'chev_text_open';
            qt_txt_sts =  'chev_text_open';

            jo_txt_val = 'Customer';
            srt_txt_val = '';
            prt_txt_val = '';
            war_txt_val = '';
            nar_txt_val = '';
            qt_txt_val = '';
        }
    }


    // Below method implemented as part of GSSC 385 
    public void saveRootCause(){
        system.debug('Today partsListWrap '+ partsListWrap);
        List<css_solution_component__c> lstSCRT = new List<css_solution_component__c>();
        css_solution_component__c SCRT;
        if(partsListWrap != null && partsListWrap.size() >0) {
            for(CSS_WPR_JobPlanOverview  wrap1 : partsListWrap){
                for(CSS_WPR_JobPlanOverview.solWrapper  wrap2 : wrap1.solList){
                    for(CSS_WPR_JobPlanOverview.solCompWrapper  wrap3 : wrap2.solCompWrap){
                        SCRT  = new css_solution_component__c();
                        SCRT.id=wrap3.compId;
                        
                        if(wrap3.JPORootCause == null || wrap3.JPORootCause == false){
                             SCRT.Root_Cause__c= false;
                        }
                        else{
                        SCRT.Root_Cause__c= wrap3.JPORootCause;
                        }
                        
                        system.debug('inside for loops');
                        lstSCRT.add(SCRT);    
                    }
                }
            }
        }
        
        system.debug('lstSCRT>> ' + lstSCRT);
        if(lstSCRT!=null && lstSCRT.size()>0)
            update lstSCRT; // DML for RootCause field based on overview selection.

        //START - Reduplication Logic. GSSC-385-3 By Krishna.
        if(lstSCRT != null && lstSCRT.size() > 0) {
            //set<Id> solCompSet = new set<Id>();
            Map<Id, Boolean> solCompRootcauseMap = new Map<Id, Boolean>();
            list<CSS_SRT__c> repairSRTFinal = new list<CSS_SRT__c>();
            List<CSS_SRT__c> selctedSRTList = new List<CSS_SRT__c>();
            List<CSS_SRT__c> unSelctedSRTList = new List<CSS_SRT__c>();
            
            //Map<Id, List<CSS_SRT__c>> selectedSolCompSRTMap = new Map<Id, List<CSS_SRT__c>>();
            //Map<Id, List<CSS_SRT__c>> unSelectedSolCompSRTMap = new Map<Id, List<CSS_SRT__c>>();
            
            //Map<Id, List<CSS_SRT__c>> solCompSRTListMap = new Map<Id, List<CSS_SRT__c>>();
            
            for(css_solution_component__c sol : lstSCRT) {
                solCompRootcauseMap.put(sol.Id, sol.Root_Cause__c);
                //solCompSet.add(sol.Id);
            }
            system.debug('solCompRootcauseMap>> ' + solCompRootcauseMap);
            List<CSS_SRT__c> sjlist = new List<CSS_SRT__c>();
            //adding 2 fields on Feb4th 2020 by Krishna.
            sjlist = [SELECT id,Job_Order__c, isPerformed__c, Component_Id__c, SRT_ID__c,Assignment__c,SRT_Access_Code__c,
Account_Code__c, Account_Code_Description__c, FailCode__c, Fail_Code_Description__c, CSS_Root_Cause_Failure__c, isDuplicateRootCause__c
                        FROM CSS_SRT__c 
                        WHERE Job_Order__c =: Wid and (type__c ='Repair' or type__c='Repair Access') and 
                            SRT_ID__c != '0' and Component_Id__c IN : solCompRootcauseMap.keyset()];
                            
            for(CSS_SRT__c srt : sjlist) {
                if(srt.Component_Id__c != null) {
                    Boolean selected = solCompRootcauseMap.get(srt.Component_Id__c);
                    if(selected) 
                        selctedSRTList.add(srt);
                    else 
                        unSelctedSRTList.add(srt);
                }
            }
            
            system.debug('selctedSRTList>> ' + selctedSRTList);
            system.debug('unSelctedSRTList>> ' + unSelctedSRTList);
            
            //Call Reduplciation Logic for Selected root cause.
            list<CSS_SRT__c> selectedSRTsafterDupList = ReDuplicationLogic(selctedSRTList);

            //Call Blank and isPerformed__c as false on unselected Root cause.
            /*for(CSS_SRT__c srt : unSelctedSRTList) {
                srt.isPerformed__c = false;
                srt.Account_Code__c = '';
                srt.Account_Code_Description__c = '';
                srt.FailCode__c = '';
                srt.Fail_Code_Description__c = '';
            }*/
            
            //Newly Added by Krishna on Feb4th 2020.
            for(CSS_SRT__c srt : unSelctedSRTList) { 
                srt.isPerformed__c = false;
                srt.CSS_Root_Cause_Failure__c = null;
                srt.isDuplicateRootCause__c = false;
            }
            //Newly Added by Krishna on Feb4th 2020.
            //
            System.debug('selectedSRTsafterDupList SIZE '+selectedSRTsafterDupList.size() + ' selectedSRTsafterDupList '+ selectedSRTsafterDupList);
            if(selectedSRTsafterDupList != null && selectedSRTsafterDupList.size() >0)
                repairSRTFinal.addall(selectedSRTsafterDupList);
            
            System.debug('unSelctedSRTList SIZE '+unSelctedSRTList.size() + ' unSelctedSRTList '+ unSelctedSRTList);
            if(unSelctedSRTList != null && unSelctedSRTList.size() >0)
                repairSRTFinal.addall(unSelctedSRTList);
                
            System.debug('repairSRTFinal SIZE '+repairSRTFinal.size() + ' repairSRTFinal '+ repairSRTFinal);
            for(CSS_SRT__c srt : repairSRTFinal) {
                if(srt.SRT_ID__c == '00-724-00') 
                    system.debug(srt);
            }
            if(repairSRTFinal != null && repairSRTFinal.size() >0)
                update repairSRTFinal;  
        }
        //END - Reduplication Logic. GSSC-385-3 By Krishna.
    }
    
    /*public void saveRootCause(){
        system.debug('Today partsListWrap '+ partsListWrap);
        List<css_solution_component__c> lstSCRT = new List<css_solution_component__c>();
        css_solution_component__c SCRT;
        for(CSS_WPR_JobPlanOverview  wrap1 : partsListWrap){
            for(CSS_WPR_JobPlanOverview.solWrapper  wrap2 : wrap1.solList){
                for(CSS_WPR_JobPlanOverview.solCompWrapper  wrap3 : wrap2.solCompWrap){
                    SCRT  = new css_solution_component__c();
                    SCRT.id=wrap3.compId;

                    if(wrap3.JPORootCause == null || wrap3.JPORootCause == false){
                        SCRT.Root_Cause__c= false;
                    }
                    else{
                        SCRT.Root_Cause__c= wrap3.JPORootCause;
                    }

                    system.debug('inside for loops');
                    lstSCRT.add(SCRT);    
                }
            }
        }

        system.debug('lstSCRT>> ' + lstSCRT);
        if(lstSCRT!=null && lstSCRT.size()>0)
            update lstSCRT; // DML for RootCause field based on overview selection.

        //START - Reduplication Logic. GSSC-385-3 By Krishna.
        if(lstSCRT != null && lstSCRT.size() > 0) {
            //set<Id> solCompSet = new set<Id>();
            Map<Id, Boolean> solCompRootcauseMap = new Map<Id, Boolean>();
            list<CSS_SRT__c> repairSRTFinal = new list<CSS_SRT__c>();
            List<CSS_SRT__c> selctedSRTList = new List<CSS_SRT__c>();
            List<CSS_SRT__c> unSelctedSRTList = new List<CSS_SRT__c>();

            //Map<Id, List<CSS_SRT__c>> selectedSolCompSRTMap = new Map<Id, List<CSS_SRT__c>>();
            //Map<Id, List<CSS_SRT__c>> unSelectedSolCompSRTMap = new Map<Id, List<CSS_SRT__c>>();

            //Map<Id, List<CSS_SRT__c>> solCompSRTListMap = new Map<Id, List<CSS_SRT__c>>();

            for(css_solution_component__c sol : lstSCRT) {
                solCompRootcauseMap.put(sol.Id, sol.Root_Cause__c);
                //solCompSet.add(sol.Id);
            }
            List<CSS_SRT__c> sjlist = new List<CSS_SRT__c>();
            sjlist = [SELECT id,Job_Order__c, isPerformed__c, Component_Id__c, SRT_ID__c,Assignment__c,SRT_Access_Code__c,
                      Account_Code__c, Account_Code_Description__c, FailCode__c, Fail_Code_Description__c
                      FROM CSS_SRT__c 
                      WHERE Job_Order__c =: Wid and (type__c ='Repair' or type__c='Repair Access') and 
                      SRT_ID__c != '0' and Component_Id__c IN : solCompRootcauseMap.keyset()];

            for(CSS_SRT__c srt : sjlist) {
                if(srt.Component_Id__c != null) {
                    Boolean selected = solCompRootcauseMap.get(srt.Component_Id__c);
                    if(selected) 
                        selctedSRTList.add(srt);
                    else 
                        unSelctedSRTList.add(srt);
                }
            }

            //Call Reduplciation Logic for Selected root cause.
            list<CSS_SRT__c> selectedSRTsafterDupList = ReDuplicationLogic(selctedSRTList);

            //Call Blank and isPerformed__c as false on unselected Root cause.
            for(CSS_SRT__c srt : unSelctedSRTList) {
                srt.isPerformed__c = false;
                srt.Account_Code__c = '';
                srt.Account_Code_Description__c = '';
                srt.FailCode__c = '';
                srt.Fail_Code_Description__c = '';
            }

            System.debug('selectedSRTsafterDupList SIZE '+selectedSRTsafterDupList.size() + ' selectedSRTsafterDupList '+ selectedSRTsafterDupList);
            if(selectedSRTsafterDupList != null && selectedSRTsafterDupList.size() >0)
                repairSRTFinal.addall(selectedSRTsafterDupList);

            System.debug('unSelctedSRTList SIZE '+unSelctedSRTList.size() + ' unSelctedSRTList '+ unSelctedSRTList);
            if(unSelctedSRTList != null && unSelctedSRTList.size() >0)
                repairSRTFinal.addall(unSelctedSRTList);

            System.debug('repairSRTFinal SIZE '+repairSRTFinal.size() + ' repairSRTFinal '+ repairSRTFinal);
            if(repairSRTFinal != null && repairSRTFinal.size() >0)
                update repairSRTFinal;  
        }
        //END - Reduplication Logic. GSSC-385-3 By Krishna.
    }*/

    //Reduplciation Logic for Selected root cause.  GSSC-385-3 By Krishna.
    /*
    public list<CSS_SRT__c> ReDuplicationLogic(List<CSS_SRT__c> selctedSRTList){
        list<CSS_SRT__c> selectedSRTsafterDupList = new list<CSS_SRT__c>();
        map<string, List<CSS_SRT__c>> repairSRTCodeMap = new map<string, List<CSS_SRT__c>>();

        for(CSS_SRT__c repair : selctedSRTList) {
            if(repair.Assignment__c=='PRIMARY' || repair.Assignment__c=='ALTERNATIVE' || repair.Assignment__c=='PROGRESSIVE DAMAGE') {
                if(repairSRTCodeMap.containsKey(repair.SRT_ID__c)){
                    List<CSS_SRT__c> slist = repairSRTCodeMap.get(repair.SRT_ID__c);
                    slist.add(repair);
                    repairSRTCodeMap.put(repair.SRT_ID__c,slist);
                } else {
                    repairSRTCodeMap.put(repair.SRT_ID__c,new List<CSS_SRT__c>{repair}); 
                }
            } else {
                //mark is performed as true and add to final list.
                repair.isPerformed__c = true;
                selectedSRTsafterDupList.add(repair);
            }
        }

        System.debug('repairSRTCodeMap SIZE '+repairSRTCodeMap.size());
        System.debug('repairSRTCodeMap '+repairSRTCodeMap);

        for(string srtId : repairSRTCodeMap.keySet()) {
            List<CSS_SRT__c> slist = repairSRTCodeMap.get(srtId);
            if(slist != null && slist.size() > 0) {
                if(slist.size() == 1) {
                    //mark is performed as true and add to final list.
                    slist[0].isPerformed__c = true;
                    selectedSRTsafterDupList.add(slist[0]);
                    //repairSRTFinal.add(slist[0]);
                } else {
                    map<Integer, CSS_SRT__c> assignAccessCodeSRTMap = new map<Integer, CSS_SRT__c>();//assignment + Accesscode
                    CSS_SRT__c srtHighest = new CSS_SRT__c();
                    for(CSS_SRT__c srt : slist) {
                        if(srt.Assignment__c == 'PRIMARY') {
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                assignAccessCodeSRTMap.put(6, srt);
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                assignAccessCodeSRTMap.put(5, srt);
                            }
                        } else if(srt.Assignment__c == 'ALTERNATIVE') {
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                assignAccessCodeSRTMap.put(4, srt);
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                assignAccessCodeSRTMap.put(3, srt);
                            }
                        } else if(srt.Assignment__c == 'PROGRESSIVE DAMAGE') {
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                assignAccessCodeSRTMap.put(2, srt);
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                assignAccessCodeSRTMap.put(1, srt);
                            }
                        }
                    }
                    List<Integer> assignmentAccessWeight = new list<Integer>();
                    for(integer i : assignAccessCodeSRTMap.KeySet())
                        assignmentAccessWeight.add(i);
                    assignmentAccessWeight.sort();

                    //Find Highest ranking SRT.
                    integer assignAccessHighestWeight = assignmentAccessWeight[assignmentAccessWeight.size() -1];
                    srtHighest = assignAccessCodeSRTMap.get(assignAccessHighestWeight);
                    string compId = srtHighest.Component_Id__c;
                    srtHighest.isPerformed__c = true;
                    selectedSRTsafterDupList.add(srtHighest);
                    //repairSRTFinal.add(srtHighest);

                    //Find Non Highest Ranking SRT.
                    if(assignAccessCodeSRTMap != null && assignAccessCodeSRTMap.size() > 1) {
                        for(integer i=0; i <= assignmentAccessWeight.size()-2; i++) {   //changed -1 to -2 for ommiting highest rank.
                            CSS_SRT__c srtLow = new CSS_SRT__c();
                            srtLow = assignAccessCodeSRTMap.get(i);
                            if(srtLow != null) {
                                srtHighest.isPerformed__c = false;
                                srtLow.CSS_Root_Cause_Failure__c = compId;
                                srtLow.isDuplicateRootCause__c = true;
                                selectedSRTsafterDupList.add(srtLow);
                            }
                        }
                    }
                }
            }
        }
        System.debug('selectedSRTsafterDupList SIZE '+selectedSRTsafterDupList.size());
        System.debug('selectedSRTsafterDupList '+selectedSRTsafterDupList);
        return selectedSRTsafterDupList;
    } 
*/
    public list<CSS_SRT__c> ReDuplicationLogic(List<CSS_SRT__c> selctedSRTList){
        list<CSS_SRT__c> selectedSRTsafterDupList = new list<CSS_SRT__c>();
    map<string, List<CSS_SRT__c>> repairSRTCodeMap = new map<string, List<CSS_SRT__c>>();
    system.debug('selctedSRTList**'+selctedSRTList);
    for(CSS_SRT__c repair : selctedSRTList) {
    if(repair.Assignment__c=='PRIMARY' || repair.Assignment__c=='ALTERNATIVE' || repair.Assignment__c=='PROGRESSIVE DAMAGE') {
    if(repairSRTCodeMap.containsKey(repair.SRT_ID__c)){
    List<CSS_SRT__c> slist = repairSRTCodeMap.get(repair.SRT_ID__c);
    slist.add(repair);
    repairSRTCodeMap.put(repair.SRT_ID__c,slist);
    } else {
    repairSRTCodeMap.put(repair.SRT_ID__c,new List<CSS_SRT__c>{repair}); 
    }
    } else {
        //mark is performed as true and add to final list.
        //repair.isPerformed__c = true; //commanted by Krishna for defect: GSSC-532.
        selectedSRTsafterDupList.add(repair);
    }
    }

System.debug('repairSRTCodeMap SIZE '+repairSRTCodeMap.size());
        System.debug('repairSRTCodeMap '+repairSRTCodeMap);

for(string srtId : repairSRTCodeMap.keySet()) {
            List<CSS_SRT__c> slist = repairSRTCodeMap.get(srtId);
            system.debug('slist**'+slist);
            if(slist != null && slist.size() > 0) {
                if(slist.size() == 1) {
                    //mark is performed as true and add to final list.
                    if(slist[0].Assignment__c == 'PRIMARY') //As per defect 569, based on assignment making isPerformed__C = true.
                    slist[0].isPerformed__c = true;
                    //else
                    //slist[0].isPerformed__c = false;
                slist[0].CSS_Root_Cause_Failure__c = null;//Feb4th 2020
                slist[0].isDuplicateRootCause__c = false;//Feb4th 2020
                selectedSRTsafterDupList.add(slist[0]);
                    //repairSRTFinal.add(slist[0]);
                    system.debug('InsideIf**'+selectedSRTsafterDupList);
                } 
                else {
                    system.debug('InsideElse**'+selectedSRTsafterDupList);
                    map<Integer, List<CSS_SRT__c>> assignAccessCodeSRTMap = new map<Integer, List<CSS_SRT__c>>();//assignment + Accesscode
                    List<CSS_SRT__c> srtHighest = new List<CSS_SRT__c>();
                    
                    for(CSS_SRT__c srt : slist) {
                        //List<CSS_SRT__c> tempSRTList = new List<CSS_SRT__c>();
                        if(srt.Assignment__c == 'PRIMARY') {
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                //tempSRTList.add(srt);
                                //assignAccessCodeSRTMap.put(6, tempSRTList);
                                if(assignAccessCodeSRTMap.containsKey(6)){
                                    List<CSS_SRT__c> tempSRTList = assignAccessCodeSRTMap.get(6);
                                    tempSRTList.add(srt);
                                    assignAccessCodeSRTMap.put(6, tempSRTList);
                                } else {
                                    assignAccessCodeSRTMap.put(6, new List<CSS_SRT__c> { srt });
                                }
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                //tempSRTList.add(srt);
                                //assignAccessCodeSRTMap.put(5, tempSRTList);
                                if(assignAccessCodeSRTMap.containsKey(5)){
                                    List<CSS_SRT__c> tempSRTList = assignAccessCodeSRTMap.get(5);
                                    tempSRTList.add(srt);
                                    assignAccessCodeSRTMap.put(5, tempSRTList);
                                } else {
                                    assignAccessCodeSRTMap.put(5, new List<CSS_SRT__c> { srt });
                                }
                            }
                        } else if(srt.Assignment__c == 'ALTERNATIVE') {
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                //tempSRTList.add(srt);
                                //assignAccessCodeSRTMap.put(4, tempSRTList);
                                if(assignAccessCodeSRTMap.containsKey(4)){
                                    List<CSS_SRT__c> tempSRTList = assignAccessCodeSRTMap.get(4);
                                    tempSRTList.add(srt);
                                    assignAccessCodeSRTMap.put(4, tempSRTList);
                                } else {
                                    assignAccessCodeSRTMap.put(4, new List<CSS_SRT__c> { srt });
                                }
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                //tempSRTList.add(srt);
                                //assignAccessCodeSRTMap.put(3, tempSRTList);
                                if(assignAccessCodeSRTMap.containsKey(3)){
                                    List<CSS_SRT__c> tempSRTList = assignAccessCodeSRTMap.get(3);
                                    tempSRTList.add(srt);
                                    assignAccessCodeSRTMap.put(3, tempSRTList);
                                } else {
                                    assignAccessCodeSRTMap.put(3, new List<CSS_SRT__c> { srt });
                                }
                            }
                        } else if(srt.Assignment__c == 'PROGRESSIVE DAMAGE') {
                            if(srt.SRT_Access_Code__c=='A' || srt.SRT_Access_Code__c=='B' || srt.SRT_Access_Code__c=='C' || srt.SRT_Access_Code__c=='D'){
                                //tempSRTList.add(srt);
                                //assignAccessCodeSRTMap.put(2, tempSRTList);
                                if(assignAccessCodeSRTMap.containsKey(2)){
                                    List<CSS_SRT__c> tempSRTList = assignAccessCodeSRTMap.get(2);
                                    tempSRTList.add(srt);
                                    assignAccessCodeSRTMap.put(2, tempSRTList);
                                } else {
                                    assignAccessCodeSRTMap.put(2, new List<CSS_SRT__c> { srt });
                                }
                            }
                            if(srt.SRT_Access_Code__c=='R'){
                                //tempSRTList.add(srt);
                                //assignAccessCodeSRTMap.put(1, tempSRTList);
                                if(assignAccessCodeSRTMap.containsKey(1)){
                                    List<CSS_SRT__c> tempSRTList = assignAccessCodeSRTMap.get(1);
                                    tempSRTList.add(srt);
                                    assignAccessCodeSRTMap.put(1, tempSRTList);
                                } else {
                                    assignAccessCodeSRTMap.put(1, new List<CSS_SRT__c> { srt });
                                }
                            }
                        }
                    }
                    system.debug('assignAccessCodeSRTMap ' + assignAccessCodeSRTMap);
                    List<Integer> assignmentAccessWeight = new list<Integer>();
                    for(integer i : assignAccessCodeSRTMap.KeySet())
                        assignmentAccessWeight.add(i);
                    assignmentAccessWeight.sort();

                    //Find Highest ranking SRT.
                    integer assignAccessHighestWeight = assignmentAccessWeight[assignmentAccessWeight.size() -1];
                    srtHighest = assignAccessCodeSRTMap.get(assignAccessHighestWeight);
                    system.debug('srtHighest ' + srtHighest);
                    string compId = srtHighest[0].Component_Id__c;
                    if(srtHighest[0].Assignment__c == 'PRIMARY') //As per defect 569, based on assignment making isPerformed__C = true.
                        srtHighest[0].isPerformed__c = true;
                    //else
                        //srtHighest.isPerformed__c = false;
                    //srtHighest.isPerformed__c = true;
                    srtHighest[0].CSS_Root_Cause_Failure__c = null;//Feb4th 2020
                srtHighest[0].isDuplicateRootCause__c = false;//Feb4th 2020
            selectedSRTsafterDupList.add(srtHighest[0]);
                    //repairSRTFinal.add(srtHighest);
                    //system.debug('selectedSRTsafterDupList*Kal**'+selectedSRTsafterDupList);
                    //Find Non Highest Ranking SRT.
                    for(List<CSS_SRT__c> srtLst : assignAccessCodeSRTMap.values()) {
                        for(CSS_SRT__c srt:srtLst){
                            if(srt.Id != srtHighest[0].Id) {
                                srt.isPerformed__c = false;
                                srt.CSS_Root_Cause_Failure__c = compId;
                                srt.isDuplicateRootCause__c = true;
                                selectedSRTsafterDupList.add(srt);
                            }
                        }
                    }
                    system.debug('selectedSRTsafterDupList*Kal2**'+selectedSRTsafterDupList);
                    /*
                     * if(assignAccessCodeSRTMap != null && assignAccessCodeSRTMap.size() > 1) {
                        for(integer i=0; i <= assignmentAccessWeight.size()-2; i++) {   //changed -1 to -2 for ommiting highest rank.
                            CSS_SRT__c srtLow = new CSS_SRT__c();
                            srtLow = assignAccessCodeSRTMap.get(i);
                            if(srtLow != null) {
                                srtHighest.isPerformed__c = false;
                                srtLow.CSS_Root_Cause_Failure__c = compId;
                                srtLow.isDuplicateRootCause__c = true;
                                    selectedSRTsafterDupList.add(srtLow);
                            }
                        }
                        system.debug('selectedSRTsafterDupList*Kal2**'+selectedSRTsafterDupList);
                    }
                    */
                }
            }
        }
        System.debug('selectedSRTsafterDupList SIZE '+selectedSRTsafterDupList.size());
        System.debug('selectedSRTsafterDupList '+selectedSRTsafterDupList);
        return selectedSRTsafterDupList;
} 
    //Reduplciation Logic for Selected root cause.  GSSC-385-3 By Krishna.


    public string ChkFieldBlank()
    {
        //Modified as per story# 64030
        //if ((workJob.Customer_Name__c == null) && (workJob.Shop_Work_Order__c == null) &&(workJob.Application__c == null) && (workJob.Unit_number__c == null) && (workJob.Mileage__c == null)&& (workJob.ESN__c== null)
        if ((workJob.Customer_Name__c == null) && (workJob.Shop_Work_Order__c == null) &&(workJob.Application_Desc__c == null) && (workJob.Unit_number__c == null) && (workJob.Mileage__c == null)&& (workJob.ESN__c== null)
            && (workJob.General_Symptoms__c == null))
        {
            //  System.Debug('in BLANK==============');
            return 'BLANK';
        }
        //Modified as per story# 64030
        //else if ((workJob.Customer_Name__c == null || workJob.Customer_Name__c == '') || (workJob.Application__c == null || workJob.Application__c == ''))
        else if ((workJob.Customer_Name__c == null || workJob.Customer_Name__c == '') || (workJob.Application_Desc__c == null || workJob.Application_Desc__c == ''))
        {
            //  System.Debug('in VALIDATE==============');
            return 'VALIDATE';
        }
        else
        {
            // System.Debug('in FILLED==============');
            return 'FILLED';
        }
    }
    public PageReference jobplan_jo()
    {
        css_job_order__c worecord= new css_job_order__c();
        showJobPlanBlocks(true,false,false,false,false,false,true);

        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {

            worecord.chevron_page__c = 'jo';
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;
            worecord.SPDataWebserviceResult__c = workJob.SPDataWebserviceResult__c;
            checkspdata=false;
            /* if(checkspdata)
{

worecord = CG_BL_Intake.mapSPData(workJob, worecord);
checkspdata=false;
system.debug('Worecord after mapSPdata>>'+worecord);
}*/

            if (Wid != null)
            {
                worecord.id=workJob.id;
                update worecord;

            }
        }
        PageReference pageRef = new pageReference('/apex/CSS_JobPlan?id='+worecord.id);
        pageRef.setRedirect(true);
        return pageRef;

    }

    public PageReference jobplan_srt(){
        css_job_order__c worecord= new css_job_order__c();
        /*if (ChkFieldBlank() =='BLANK'){
return null;
}
else{*/
        worecord.chevron_page__c = 'srt';
        worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
        worecord.Unit_Number__c = workJob.Unit_Number__c;
        worecord.SPDataWebserviceResult__c = workJob.SPDataWebserviceResult__c;
        if(checkspdata){
            worecord.CSS_Travel_Rate__c = workJob.CSS_Travel_Rate__c;
            worecord.CSS_In_Shop_Labor_Rate__c = workJob.CSS_In_Shop_Labor_Rate__c;
            system.debug('Worecord after mapSPdata>>'+worecord);
        }
        if (Wid != null){
            worecord.id=workJob.id;
            update worecord;
            //updateFailCodeComponents();
        }
        //}

        saveRootCause(); // GSSC -385

        CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
        contr.covLimitValidation(Wid, null, null, null);
        contr.covLimitValidationJob(Wid, null);  //Added as part of the story GSSC-50
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanSRT?id='+worecord.id);
        pageRef.setRedirect(true);
        return pageRef;
    }

    //Method for part Cheveron
    public PageReference jobplan_prt(){
        css_job_order__c worecord= new css_job_order__c();
        /*if (ChkFieldBlank() =='BLANK'){
return null;
}
else{*/
        worecord.chevron_page__c = 'prt';
        worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
        worecord.Unit_Number__c = workJob.Unit_Number__c;
        worecord.SPDataWebserviceResult__c = workJob.SPDataWebserviceResult__c;
        if(checkspdata){
            worecord.CSS_Travel_Rate__c = workJob.CSS_Travel_Rate__c;
            worecord.CSS_In_Shop_Labor_Rate__c = workJob.CSS_In_Shop_Labor_Rate__c;
        }
        if (Wid != null){
            worecord.id=workJob.id;
            update worecord;
        }
        //}

        saveRootCause(); // GSSC -385
        CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
        contr.covLimitValidation(Wid, null, null, null);
        contr.covLimitValidationJob(Wid, null);  //Added as part of the story GSSC-50
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanParts?id='+wid);
        pageRef.setRedirect(true);
        return pageRef;
    }

    //method for Waranty Cheveron
    public PageReference jobplan_war(){
        css_job_order__c worecord= new css_job_order__c();
        /*if (ChkFieldBlank() =='BLANK'){
return null;
}
else{*/
        if(checkspdata){
            worecord.CSS_Travel_Rate__c = workJob.CSS_Travel_Rate__c;
            worecord.CSS_In_Shop_Labor_Rate__c = workJob.CSS_In_Shop_Labor_Rate__c;
        }
        worecord.chevron_page__c = 'war';
        worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
        worecord.Unit_Number__c = workJob.Unit_Number__c;
        worecord.SPDataWebserviceResult__c = workJob.SPDataWebserviceResult__c;
        if (Wid != null){
            worecord.id=workJob.id;
            update worecord;
        }
        //}
        saveRootCause(); // GSSC -385
        CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
        contr.covLimitValidation(Wid, null, null, null);
        contr.covLimitValidationJob(Wid, null);  //Added as part of the story GSSC-50
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanWarranty?id='+worecord.id);
        pageRef.setRedirect(true);
        return pageRef;
    }

    //Method to activate Narrative cheveron
    public PageReference jobplan_narr(){
        css_job_order__c worecord= new css_job_order__c();
        /*if (ChkFieldBlank() =='BLANK'){
return null;
}
else{*/
        if(checkspdata){
            worecord.CSS_Travel_Rate__c = workJob.CSS_Travel_Rate__c;
            worecord.CSS_In_Shop_Labor_Rate__c = workJob.CSS_In_Shop_Labor_Rate__c;
        }
        worecord.chevron_page__c = 'narr';
        worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
        worecord.Unit_Number__c = workJob.Unit_Number__c;
        worecord.SPDataWebserviceResult__c = workJob.SPDataWebserviceResult__c;
        if(Wid != null){
            worecord.id=workJob.id;
            update worecord;
        }
        //}
        saveRootCause(); // GSSC -385

        CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
        contr.covLimitValidation(Wid, null, null, null);
        contr.covLimitValidationJob(Wid, null);  //Added as part of the story GSSC-50
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanNarrative?id='+worecord.id);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public void updatestatus(){
        system.debug('inside the method after page load');
        parts();
        if(workJob.status__c!='Job Plan' && workJob.status__c!='Repair'){
            workJob.Previous_Status__c=workJob.Status__c;
            workJob.status__c='Job Plan';
            system.debug('inside the method after page load&&&&&&&&&');

            update  workJob;
            //TO Fetch Warranty Dertails


        }
    }

    public void parts(){
        system.debug('inside the method parts METHOD...');
        //  if(Wid != null){
        //code for parts webservice invokation - Start.
        map<Id,CSS_Solution_Component__c> solCompMap = new map<Id,CSS_Solution_Component__c>([Select Id,Component_Id__c,Service_Job__c,Fail_Code__c ,(Select Id,FailurepartId__c,Service_Job__c from CSS_Parts_Options__r) from CSS_Solution_Component__c where Service_Job__c = : workJob.Id]);
        system.debug('-->solCompMap<--'+solCompMap);
        map<Id,list<string>> jobIdFailureCodeMap = new map<Id,list<string>>();

        if(solCompMap != null && !solCompMap.isEmpty()){
            for(CSS_Solution_Component__c solCompRec : solCompMap.values()){
                if(solCompRec.CSS_Parts_Options__r == null || solCompRec.CSS_Parts_Options__r.isEmpty()){
                    if(jobIdFailureCodeMap.get(solCompRec.Service_Job__c) != null){
                        jobIdFailureCodeMap.get(solCompRec.Service_Job__c).add(solCompRec.Component_Id__c);
                    }else{
                        list<string> failureIds = new list<string>();
                        failureIds.add(solCompRec.Component_Id__c);
                        jobIdFailureCodeMap.put(solCompRec.Service_Job__c,failureIds);
                    }
                }
            }
        }

        if(jobIdFailureCodeMap != null && !jobIdFailureCodeMap.isEmpty()){
            list<string> simlist = new list<string>();
            set<string> failduniq = new set<string>();
            list<string> faillistun = new list<string>();
            for(Id JobId : jobIdFailureCodeMap.keySet()){

                if(jobIdFailureCodeMap.get(JobId) != null && !jobIdFailureCodeMap.get(JobId).isEmpty()){
                    simlist.addall(jobIdFailureCodeMap.get(JobId));

                    // SRTPartsIns.PartsSRTREq.DataArea.FailureID = jobIdFailureCodeMap.get(JobId);
                    // SRTPartsIns.invokeparts();
                }
            }
            failduniq.addall(simlist);
            faillistun.addall(failduniq);
            CSS_SRTParts SRTPartsIns = new CSS_SRTParts ();
            if(faillistun != null){
                system.debug('inside unique list');
                //SRTPartsIns.PartsSRTREq.DataArea.FailureID =  faillistun;
                system.debug('jobplancheck');
                // SRTPartsIns.invokeparts();
            }
        }

        //code for parts webservice invokation - End.
        //  }

    }


    public PageReference pgSave(){
        // System.Debug('**in jobplan=============='+workJob.Customer_Name__c);

        css_job_order__c worecord= new css_job_order__c();

//Commented the below code as the button save is not used and was deleting field action rcords
        /*if (ChkFieldBlank() =='BLANK')
        {
            //reqBoolean='true';
            return null;
        }
        else
        {

            worecord.Customer_Name__c=workJob.Customer_Name__c;
            worecord.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
            worecord.ESN__c = workJob.ESN__c;
            //Modifed as per story# 79153
            //worecord.Category__c = workJob.Category__c;
            worecord.Category_Desc__c = workJob.Category_Desc__c;
            worecord.Mileage__c = workJob.Mileage__c;
            worecord.Mileage_Measure__c = mil_measure;
            worecord.Failure_Date__c=workJob.Failure_Date__c;
            worecord.Failure_Point__c = workJob.Failure_Point__c;
            worecord.General_Symptoms__c=workJob.General_Symptoms__c;
            worecord.Service_Model__c = workJob.Service_Model__c;
            worecord.VIN__c = workJob.VIN__c;
            worecord.Warranty_Start_Date__c=workJob.Warranty_Start_Date__c;
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;
            worecord.Actual_Technician_Time__c = workJob.Actual_Technician_Time__c;
            //Defect Fix - 75783
            worecord.Status__c='Job Plan';
            // Defect fix 59457
            saveCheckBox();
            if (Wid == null)
            {
                worecord.jobLocation__c=jobLocation;
                insert worecord;
                Wid = worecord.id;
                updateFailCodeComponents();
                PageReference pageRef = new pageReference('/apex/CSS_JobPlan?id='+worecord.id);
                pageRef.setRedirect(true);
                return pageRef;
            }
            else
            {
                System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                update worecord;
                System.Debug('record updated====='+worecord);
                updateFailCodeComponents();
                return null;
            }
        }*/
        return null;
    }


    public pagereference saveCheckBox(){
        if(comm !='' && comm !=null ){
            system.debug('JobID' +Wid);
            Note x = new Note();
            x.Title = 'CAMPCOMMENTS';
            x.ParentId = Wid;
            x.Body = comm;
            insert x;
        }
        return null;
    }
    /* Popup Code */
    public void showPopup(){
        displayPopup = true;
    }
    public void closePopup() {
        displayPopup = false;
    }

    public PageReference redirectPopup()
    {
        displayPopup = false;
        PageReference p=new Pagereference('/apex/CSS_Job_Detail?nto=HOME');
        p.setRedirect(true);
        return p;
    }
    public CSS_SRTComponentLookupResponseJ2A response;
    public List<SelectOption> options{get;set;}

    public list<string> lstConcatenatedFailCodes{get;set;}//set to store all concatenated values
    //Method to get the response from the job event temporary object and building concatenated failcodes
    public void buildConcatenatedFailCodes() {
        try{
            lstConcatenatedFailCodes = new list<String>();
            system.debug('output -->'+workJob);
            system.debug('1'+workJob.Service_Model__c);
            system.debug('2'+workJob.Qsol_Engine_Family_Code__c);
            String smn_engFamCode = workJob.Service_Model__c + ';;' + workJob.Qsol_Engine_Family_Code__c;
            system.debug('123----->'+smn_engFamCode);
            CSS_JobEventTemporary__c jobEventTemp = new CSS_JobEventTemporary__c();
            jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Key__c, Reason__c FROM CSS_JobEventTemporary__c WHERE Attribute3__c =: smn_engFamCode and Key__c = 'getFailureCodesSRT' limit 1];
            system.debug('456------>'+jobEventTemp);
            response = (CSS_SRTComponentLookupResponseJ2A)JSON.deserialize(jobEventTemp.Reason__c,CSS_SRTComponentLookupResponseJ2A.class);
            system.debug('-->response<--'+response);
            system.debug('-->compPartsList<--'+compPartsList);
            if(response != null && compPartsList != null && compPartsList.size()>0 &&
               response.DataArea != null && response.DataArea.size() > 0){
                options = new List<SelectOption>();
                options.add(new SelectOption('Select One','Select One'));
                //building map of failid as key and component name as value
                for(CSS_SRTComponentLookupResponseJ2A.DataArea da : response.DataArea){
                    for(CSS_Solution_Component__c cmp : compPartsList){

                        if(cmp.Component_Id__c == da.FailureID){
                            string s = cmp.name + '-' + da.SystemCode + da.ComponentCode;
                            options.add(new SelectOption(s,s));
                            lstConcatenatedFailCodes.add(s);
                            break;
                        }//end of if failid check
                    }//end of inner for loop
                }//end of outer for loop
            }//end of if null checks
            //getConcatenatedFailCodes();
            system.debug('lstConcatenatedFailCodes--->'+lstConcatenatedFailCodes);
            system.debug('options---->'+options);
        }//end of try
        catch(Exception ex){
            system.debug('Exception on getting SRT Component Load method -->' + ex.getmessage()+ex.getLinenumber());
            //return null;
        }//end of catch

    }//end of buildConcatenatedFailCodes method

    public String ParentSolName {get;set;} //Kalpana story 117208 display Parent Solution Name for a Nested Solution
    public List<CSS_WPR_JobPlanOverview> getListWrap(){
        try{
            ProfileName = [SELECT Name FROM Profile WHERE Id=:userInfo.getProfileId() LIMIT 1].Name;
            system.debug('ProfileName**'+ProfileName);
            CSS_WPR_JobPlanOverview.solWrapper solFCWrap;
            //CSS_WPR_JobPlanOverview.solCompWrapper solComponentWrap;GSSC-725
            CSS_WPR_JobPlanOverview.solCompWrapper solComponentWrap = new CSS_WPR_JobPlanOverview.solCompWrapper();//GSSC-725 Changes by anirudh as attempt to dereference null error is coming up since it is not initialised.
            CSS_WPR_JobPlanOverview.solCompWrapper solComponentFCWrap;
            //List<CSS_WPR_JobPlanOverview.solCompWrapper>  lstsolComponentWrap = new List<CSS_WPR_JobPlanOverview.solCompWrapper>();
            partsListWrap = new List<CSS_WPR_JobPlanOverview>();

            system.debug('allFaultCodesBefore****'+allFaultCodes);
            //For Fault Codes
            AggregateResult[]  sequence = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Wid];
            integer maxSeq = integer.valueOf(sequence [0].get('maxSeq'));
            system.debug('maxSeq--->'+maxSeq);
            //if(!Test.isRunningTest()){
            allFaultCodes = [Select Primary_Fault_Code__c, isPole__c,CreatedDate,PoleMessage__c ,Sequence__c,FaultCode__c, Mod__c,name,
                             Fault_Code_Type__c,RelatedFaultCode__c, Related_Fault_Code__c,Number_of_Solutions__c
                             from CSS_Fault_Code__c
                             where Job_Order__c=:Wid and Sequence__c=:maxSeq order by Order__c,sequence__c ];
            //End Fault Codes
            //}
            system.debug('allFaultCodesAfter****'+allFaultCodes);
            //For Symptom
            sympList = [select Id,name,Job_Order__c,Caption__c,type__c,(select SearchString__c,name,answers__c,Sequence__c,Type__c from CSS_SymptomQA__r order by createddate asc) ,
                        Number_of_Solutions__c,(select name,symptom__c,Solution_Title__c,Diagnostic_Response__c  from CSS_Solutions__r)
                        from CSS_SymptomQA__c where job_order__c=:Wid and type__c='SearchString'
                        and ( user_name__c = null or ( user_name__c =:userinfo.getUserId() and createdDate >: System.now().addMinutes(-30) ))];
            system.debug('sympList****'+sympList);
            //End Symptom

            solutionList = [select id,Case_Name__c,Name,Solution_Title__c,Service_Job__c,Diagnostic_Response__c,Repair_Response__c,Symptom__c,Search_String__c,FaultCode__c,Out_Of_Order__c,Symptom__r.Name,CSS_Nested_Solutions__c,CSS_Nested_Solutions__r.Name,
                            (select name,SRT_ID__c,Diagnosis_Time__c,id,SRT_Time__c, Repair_Time__c ,Type__c,Response_Message__c ,Access_Code_A__c,SRT_AccessiblityCheck__c,Solution_Title__c,Solution_Number__c,SRT_Status_Message__c,isPerformed__c,SRT_Quantity__c  from CSS_SRTS__r)
                            from CSS_Solutions__c where Service_Job__c=:Wid order by LastModifiedDate desc];
            //for adding nested solution

            /*Set<Id>solutionIdswithNested=new Set<Id>();
Map<id,CSS_Solutions__c>mapOfIdandSolObj=new Map<id,CSS_Solutions__c>();
for(CSS_Solutions__c sol:solutionList){
//solutionIdswithNested.add(sol.id);
mapOfIdandSolObj.put(sol.id,sol);
}       */

            //End here

            compPartsList = [select name,action__c,Component_Id__c,Selected_Component__c,Solutions__c,Quantity__c,Service_Job__c,Fail_Code_Editable__c,AccountCodeEdit__c,
                             (select id,name,selected_part__c,FailurepartId__c from CSS_Parts_Options__r ) from CSS_Solution_Component__c where Service_Job__c=:Wid];

            compRepList = new List<CSS_Solution_Component__c>([select name,action__c,Component_Id__c,System_Code__c,Component_Code__c,Failure_Date__c,Failure_Point__c,Customer_Take_Possession__c,Part_Warranty_Start_Date__c,Failure_Measure__c,CSS_Account_Formula__c,Selected_Component__c,Solutions__c,Quantity__c,Service_Job__c,Fail_Code__c ,Fail_Code_Editable__c,AccountCodeEdit__c,AccountCode__c,AccountCodeType__c,Authorization_Number__C,Approval_Code__c,Pay_Code__c,CSS_CoverageType__c,
                                                               Claim_Type__c,Failure_Mode__c,FailMode_Desc__c,Root_Cause__c,(select name,SRT_ID__c,id, Diagnosis_Time__c , SRT_Time__c, Repair_Time__c , Type__c,Access_Code_A__c,Solution_Title__c,Solution_Number__c,Response_Message__c ,isPerformed__c,SRT_Quantity__c,Assignment__c from CSS_SRTS__r)
                                                               from CSS_Solution_Component__c where Service_Job__c=:Wid]);
            System.debug('compRepLis>>:>>t'+compRepList.size());
            //Story- 111469 Call the method to build the concatenated fail codes
            buildConcatenatedFailCodes();
            //end Story- 111469
            //Fault Code Wrapper

            //story 11470 start
            getAccountCodes();
            //story 11470 end

            String orgType = css_utility.getOrgType(userInfo.getUserId());
            Boolean isClaimEnabled = css_utility.getclaimsapprove(userInfo.getUserId());

            system.debug('orgType--->'+orgType);
            system.debug('isClaimEnabled--->'+isClaimEnabled);

            set<string> failModestring = new set<string>();
            Map<string,string> failmodedescMap = new map<string,string>();
            for(CSS_Solution_Component__c solCompRep : compRepList){
                failModestring.add(solCompRep.Failure_Mode__c);
            }


            List<CSS_JobEventTemporary__c> jobtempList = new List<CSS_JobEventTemporary__c>([select Attribute1__C,Attribute3__c,Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailModes' and Active__c= true and Attribute1__c IN : failModestring]);
            for(CSS_JobEventTemporary__c temp : jobtempList){
                failmodedescMap.put(temp.Attribute1__C, temp.Attribute3__c);
            }
            jobtempList = null;
            system.debug('failmodedescMap--->'+failmodedescMap);

            system.debug('allFaultCodes--->'+allFaultCodes);
            for(CSS_Fault_Code__c fc : allFaultCodes){
                decimal timeFcDiag = 0.0;
                decimal timeFcRep = 0.0;
                integer iDiagFcTime;
                integer iFcMinutes;
                string sDFcTime;
                integer iFcHour;
                integer iRepFcTime;
                integer iRepFcMinutes;
                integer iRepFcHour;
                string sRFcTime;
                sDFcTime = '';
                partsFCWrap = new CSS_WPR_JobPlanOverview();
                if(fc.Number_of_Solutions__c!=null){
                    partsFCWrap.name = fc.name;
                }
                if(fc.RelatedFaultCode__c!=null || fc.RelatedFaultCode__c!=''){
                    partsFCWrap.relatedName.add(fc.RelatedFaultCode__c);
                }
                partlist = new List<String>();
                for(CSS_Solutions__c solFc:solutionList){
                    solFCWrap = new CSS_WPR_JobPlanOverview.solWrapper();
                    partlist = new List<String>();
                    if(solFc.FaultCode__c!=null || solFc.FaultCode__c!=''){
                        if(solFc.FaultCode__c == fc.id){

                            solFCWrap.solNumber = solFc.name;
                            solFCWrap.solTitle = solFc.Solution_Title__c;
                            solFCWrap.solResponse = solFc.Diagnostic_Response__c;
                            solFCWrap.outOfOrder = solFc.Out_Of_Order__c;
                            if(solFC.css_Nested_Solutions__c != null){
                                if(!String.isBlank(solFC.CSS_Nested_Solutions__r.Name))
                                    solFCWrap.ParentSolName = solFC.CSS_Nested_Solutions__r.Name;
                                //solFCWrap.ParentSolName = [Select id,Name from Css_Solutions__c where id=:solFC.css_Nested_Solutions__c].Name; Defect number 175408
                            }
                            else solFCWrap.ParentSolName = '';
                        }
                        //System.debug('The solwrap is'+solFCWrap);
                        if(solFCWrap.solNumber!=null){
                            partsFCWrap.solList.add(solFCWrap);
                        }
                        if(solFc.CSS_SRTS__r!=null && !solFc.CSS_SRTS__r.isEmpty()){
                            for(integer i=0;i<solFc.CSS_SRTS__r.size();i++){
                                if(solFc.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Diagnosis') && solFc.CSS_SRTS__r[i].Solution_Number__c == solFc.id && fc.id == solFc.FaultCode__c && solFc.CSS_SRTS__r[i].isPerformed__c == true){
                                    if(solFc.Diagnostic_Response__c == 'Most likely the solution' || solFc.Diagnostic_Response__c == 'Not the solution'){
                                        timeFcDiag = timeFcDiag + solFc.CSS_SRTS__r[i].Diagnosis_Time__c;
                                    }
                                }
                            }
                            partsFCWrap.diagTime = string.valueof(timeFcDiag);
                        }
                        lstsolComponentFCWrap = new List<CSS_WPR_JobPlanOverview.solCompWrapper>();
                        List<string> lstAccCodeType = new List<string>();
                        /*list<string> failmodeslist = new list<string>();
for(CSS_Solution_Component__c rec : compRepList){
if(rec.Failure_Mode__c !=null && rec.Failure_Mode__c.trim() !=''){
if(rec.Failure_Mode__c.contains('-'))
failmodeslist.add(rec.Failure_Mode__c.split('-')[0]);
}
                    }*/
                        integer selectedcount = 0;
                        for(CSS_Solution_Component__c solCompFcRep : compRepList){
                            if(solCompFcRep.Selected_Component__c==true)
                                selectedcount +=1;
                        }

                        for(CSS_Solution_Component__c solCompFcRep : compRepList){
                            solComponentFCWrap = new CSS_WPR_JobPlanOverview.solCompWrapper();
                            if(solCompFcRep!=null){
                                //Story start 111469
                                if(options != null && options.size() > 0){
                                    solComponentFCWrap.lstConcatenatedFailcodes = options;
                                }
                                //end story 111469

                                //story# 111470 start
                                if(accCodes != null && accCodes.size() > 0){
                                    solComponentFCWrap.lstAccountCodes = accCodes;
                                }
                                //story# 111470 end
                                if(solCompFcRep.Solutions__c == solFc.id){

                                    solFCWrap.hasComponent = true;
                                    solComponentFCWrap.compId=solCompFcRep.Id;
                                    solComponentFCWrap.selectedcomp=solCompFcRep.Selected_Component__c;
                                    if(solCompFcRep.Selected_Component__c==true){
                                        solComponentFCWrap.failcodelist=solCompFcRep.Fail_Code__c;
                                        solComponentFCWrap.compName=solCompFcRep.name;

                                        // Added JPORootCause as part of GSSC-385 story 2

                                        if((orgType == 'DLR' && isClaimEnabled == true) && (selectedcount == 1 && solCompFcRep.Root_Cause__c == false))
                                            solComponentFCWrap.JPORootCause =true;
                                        else
                                            solComponentFCWrap.JPORootCause = solCompFcRep.Root_Cause__c;

                                        solComponentFCWrap.accountCode = solCompFcRep.AccountCode__c;
                                        lstAccCodeType = new List<string>();
                                        if(solCompFcRep.AccountCodeType__c != null && solCompFcRep.AccountCodeType__c != ''){
                                            if((solCompFcRep.AccountCodeType__c).contains('-')){
                                                lstAccCodeType = solCompFcRep.AccountCodeType__c.split('-');

                                                if(lstAccCodeType != null && lstAccCodeType.size() > 0){
                                                    // Commented below two lines - Satish - Defect# 118981
                                                    solComponentFCWrap.accountCodeType = lstAccCodeType[1];
                                                    //  solComponentFCWrap.accountCodeType = lstAccCodeType[1].ToUppercase();
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        solComponentFCWrap.JPORootCause = false; 
                                    }
                                    solComponentFCWrap.failcodeEditable = solCompFcRep.Fail_Code_Editable__c;
                                    solComponentFCWrap.accountCodeEditable = solCompFcRep.AccountCodeEdit__c;
                                    //system.debug('in constructor FailMode+Claimtype**'+solCompFcRep.Failure_Mode__c+solCompFcRep.Claim_Type__c);
                                    solComponentFCWrap.failmode = solCompFcRep.Failure_Mode__c;

                                    if(solCompFcRep.Failure_Mode__c !=null && solCompFcRep.Failure_Mode__c.trim() !=''){
                                        String failMode = solCompFcRep.Failure_Mode__c;
                                        if(solCompFcRep.Failure_Mode__c.contains('-'))
                                            failMode = solCompFcRep.Failure_Mode__c.split('-')[0]; //for #163195
                                        /*List<CSS_JobEventTemporary__c> tempList = new List<CSS_JobEventTemporary__c>([select Attribute1__C,Attribute3__c,Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailModes' and Active__c= true and Attribute1__c=:failMode limit 1 ]);
if(tempList !=null && tempList.size()>0)
solComponentFCWrap.failmodedesc = tempList.get(0).Attribute3__c;*/
                                        //if(tempevents.containsKey(failMode)){
                                        //  solComponentFCWrap.failmodedesc = tempevents.get(failMode);//Anirudh Commented as there is an existing list which is re used below.
                                        //}
                                        if(failmodedescMap != null && failmodedescMap.size() >0 && failmodedescMap.containsKey(failMode)){
                                            solComponentWrap.failmodedesc =failmodedescMap.get(failMode);
                                        }
                                    }
                                    system.debug('11 solComponentFCWrap.failmodedesc>>:'+solComponentFCWrap.failmodedesc);

                                    solComponentFCWrap.claimtype = solCompFcRep.Claim_Type__c;
                                    if(solCompFcRep.CSS_CoverageType__c == 'POL'){
                                        if(!ProfileName.containsIgnoreCase('Dealer')){
                                            if(solCompFcRep.Authorization_Number__c != null && solCompFcRep.Approval_Code__c != null && solCompFcRep.Pay_Code__c != null && solCompFcRep.Pay_Code__c != 'Select One'){
                                                solComponentFCWrap.isAuthorized = 'true';
                                            }
                                            else solComponentFCWrap.isAuthorized = 'false';
                                        }
                                        else if(solCompFcRep.Authorization_Number__c != null && solCompFcRep.Approval_Code__c != null){
                                            solComponentFCWrap.isAuthorized = 'true';

                                        }
                                        else solComponentFCWrap.isAuthorized = 'false';
                                    }
                                    lstsolComponentFCWrap.add(solComponentFCWrap);

                                    system.debug(' Today lstsolComponentFCWrap' + ' ' + lstsolComponentFCWrap);

                                    for(integer i=0;i<solCompFcRep.CSS_SRTS__r.size();i++){
                                        if(solCompFcRep.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Repair') && solCompFcRep.CSS_SRTS__r[i].Solution_Number__c == solFc.id && fc.id == solFc.FaultCode__c && solCompFcRep.CSS_SRTS__r[i].isPerformed__c == true){
                                            timeFcRep = timeFcRep + solCompFcRep.CSS_SRTS__r[i].Repair_Time__c;
                                        }
                                        partsFCWrap.repTime = string.valueof(timeFcRep);
                                    }
                                    partsFCWrap.failcode = solCompFcRep.Fail_Code__c;
                                    //system.debug('partsFCWrap.failcode --> '+ partsFCWrap.failcode +  solCompFcRep.Fail_Code__c + solFCWrap.failcodelst);
                                    //solFCWrap.failcodelst.add(solCompFcRep.Fail_Code__c);

                                }
                            }
                        }
                        if(lstsolComponentFCWrap!=null){
                            solFCWrap.solCompWrap=lstsolComponentFCWrap;
                        }
                    }


                    for(CSS_Solution_Component__c solCompFc : compPartsList){

                        if(solCompFc.Solutions__c == solFc.id ){
                            solFCWrap.hasComponent = true;
                            //System.debug('ABC');
                            if(solCompFc.CSS_Parts_Options__r!=null && !solCompFc.CSS_Parts_Options__r.isEmpty() && fc.id == solFc.FaultCode__c){
                                //System.debug('ABCD');
                                for(integer i=0;i<solCompFc.CSS_Parts_Options__r.size();i++){
                                    //System.debug('ABCDE');
                                    if(solCompFc.id == solCompFc.CSS_Parts_Options__r[i].FailurepartId__c){
                                        //System.debug('ABCDEF');
                                        partsFCWrap.partsList.add(solCompFc.CSS_Parts_Options__r[i].name);

                                        if(solCompFc.CSS_Parts_Options__r[i].selected_part__c== true){
                                            partlist.add(solCompFc.CSS_Parts_Options__r[i].name);

                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(partlist!=null && !partlist.isEmpty() ){
                        solFCWrap.partsListCount=partlist;


                    }

                    //system.debug('partsFCWrap--->'+partsFCWrap);
                }
                if(partsFCWrap.Name!=null){
                    partsListWrap.add(partsFCWrap);
                }
            }
            //End Fault Code Wrapper
            //Symptom Wrapper Code
            //system.debug('Before sympList loop...'+sympList);
            for(CSS_SymptomQA__c symp : sympList){
                decimal timeDiag = 0.0;
                decimal timeRep = 0.0;
                integer iDiagTime;
                integer iMinutes;
                string sDTime;
                integer iHour;
                integer iRepTime;
                integer iRepMinutes;
                integer iRepHour;
                string sRTime;
                sDTime = '';
                partsWrap = new CSS_WPR_JobPlanOverview();
                if(symp.Type__c == 'SearchString'){
                    partsWrap.name = symp.Name;
                }
                if(symp.CSS_SymptomQA__r!=null && !symp.CSS_SymptomQA__r.isEmpty()){
                    for(integer i=0;i<symp.CSS_SymptomQA__r.size();i++){
                        if(symp.CSS_SymptomQA__r[i].Type__c.equalsIgnoreCase('QA') && symp.CSS_SymptomQA__r[i].SearchString__c == symp.id){
                            partsWrap.relatedName.add(symp.CSS_SymptomQA__r[i].Answers__c);
                        }
                    }
                }
                faultList = new list<string>();
                partlist = new List<String>();
                //set<id>setOfnestedSolution=new set<id>();//for nested solution
                for(CSS_Solutions__c sol:solutionList){
                    solWrap = new CSS_WPR_JobPlanOverview.solWrapper();
                    // solWrap1 = new CSS_WPR_JobPlanOverview.solWrapper();
                    partlist = new List<String>();
                    //system.debug('Looping Solution>>> '+sol.Name+'  For the Symptom>>>'+sol.symptom__r.Name);
                    if(sol.Symptom__c!=null && sol.Symptom__r.Name==symp.Name) {
                        if(symp.id == sol.Symptom__c && symp.Caption__c == sol.Search_String__c) {
                            //if(sol.Symptom__c == 'a1C3B000000QU1s' && sol.Search_String__c == 'smoke' ){
                            solWrap.solNumber = sol.name;
                            solWrap.solTitle = sol.Solution_Title__c;
                            solWrap.solResponse = sol.Diagnostic_Response__c;
                            solWrap.outOfOrder = sol.Out_Of_Order__c;
                            //system.debug('DON**');
                        }
                        if(sol.css_Nested_Solutions__c != null && solutionList.size()<=100)
                        {
                            //solWrap.ParentSolName = [Select id,Name from Css_Solutions__c where id=:sol.css_Nested_Solutions__c].Name;
                            if(!String.isBlank(sol.CSS_Nested_Solutions__r.Name))
                                solWrap.ParentSolName = sol.CSS_Nested_Solutions__r.Name;
                            //[Select id,Name from Css_Solutions__c where id=:sol.css_Nested_Solutions__c].Name; Defect number 175408
                            //system.debug('** Par Name'+solWrap.ParentSolName);
                        }
                        else solWrap.ParentSolName = '';
                        if(solWrap.solNumber!=null){
                            partsWrap.solList.add(solWrap);
                            //setOfnestedSolution.add(sol.id);//nested solution


                        }
                        /*if(solWrap1.solNumber!=null){
partsWrap.solList.add(solWrap1);}*/
                        //////if it has nested solution

                        /* if(String.isNotBlank(sol.CSS_Nested_Solutions__c) && !setOfnestedSolution.contains(sol.CSS_Nested_Solutions__c)){
CSS_WPR_JobPlanOverview.solWrapper solNestedWrap = new CSS_WPR_JobPlanOverview.solWrapper();
CSS_Solutions__c nestedSolution =mapOfIdandSolObj.get(sol.CSS_Nested_Solutions__c);
if(nestedSolution!=null){
solNestedWrap.solNumber = nestedSolution.name;
solNestedWrap.solTitle = nestedSolution.Solution_Title__c;
solNestedWrap.solResponse = nestedSolution.Diagnostic_Response__c;
solNestedWrap.outOfOrder = nestedSolution.Out_Of_Order__c;
solNestedWrap.solutionid=nestedSolution.id;
solNestedWrap.SymptomId=nestedSolution.Symptom__c;
partsWrap.solList.add(solNestedWrap);
setOfnestedSolution.add(sol.CSS_Nested_Solutions__c);
}
}

//ends here
} */


                        if(sol.CSS_SRTS__r!=null && !sol.CSS_SRTS__r.isEmpty()){
                            for(integer i=0;i<sol.CSS_SRTS__r.size();i++){
                                if(sol.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Diagnosis') && sol.CSS_SRTS__r[i].Solution_Number__c == sol.id && symp.id == sol.Symptom__c && sol.CSS_SRTS__r[i].isPerformed__c == true){
                                    if(sol.Diagnostic_Response__c == 'Most likely the solution' || sol.Diagnostic_Response__c == 'Not the solution'){
                                        timeDiag = timediag + sol.CSS_SRTS__r[i].Diagnosis_Time__c;
                                    }
                                }
                            }
                            partsWrap.diagTime = string.valueof(timeDiag);
                        }
                        //}
                        //}        //  failiCodes = new list<string>();
                        //system.debug('22 compRepList -->'+compRepList.size()+' compRepList>>>:'+compRepList);
                        //  lstsolComponentWrap = new List<CSS_WPR_JobPlanOverview.solCompWrapper>();

                        //for(CSS_WPR_JobPlanOverview.solWrapper solWrap :partsWrap.solList){
                        lstsolComponentWrap = new List<CSS_WPR_JobPlanOverview.solCompWrapper>();
                        List<string> lstAcctCodeType = new List<string>();

                        // Below for loop as part of GSSC -385
                        integer selectedcountSym = 0;
                        for(CSS_Solution_Component__c solCompFcRep : compRepList){
                            if(solCompFcRep.Selected_Component__c==true) { 
                                selectedcountSym +=1;
                            }
                        }
                        system.debug(' GSSC-385 selectedcountSym ' + selectedcountSym);

                        for(CSS_Solution_Component__c solCompRep : compRepList){
                            solComponentWrap = new CSS_WPR_JobPlanOverview.solCompWrapper();
                            if(solCompRep!=null){
                                //story 111469 assigning the concatenated values
                                if(options != null && options.size() >0){
                                    solComponentWrap.lstConcatenatedFailcodes = options;
                                }
                                //end story 111469

                                //story# 111470 start
                                if(accCodes != null && accCodes.size() >0){
                                    solComponentWrap.lstAccountCodes = accCodes;
                                }
                                //story# 111470 end
                                if(solCompRep.Solutions__c == sol.id){
                                    //system.debug('Looping Component>>> '+solCompRep.Name+'  For the Solution>>>'+sol.Name);
                                    solWrap.hasComponent = true;
                                    //system.debug('adding component to wrapper');
                                    solComponentWrap.compId=solCompRep.Id;

                                    solComponentWrap.selectedcomp=solCompRep.Selected_Component__c;
                                    if(solCompRep.Selected_Component__c==true){
                                        solComponentWrap.failcodelist=solCompRep.Fail_Code__c;
                                        solComponentWrap.compName=solCompRep.name;
                                        // Added JPORootCause as part of GSSC-385 story 2

                                        if((orgType == 'DLR' && isClaimEnabled == true) &&(selectedcountSym == 1 && solCompRep.Root_Cause__c==false))
                                            solComponentWrap.JPORootCause = True;                                   
                                        else
                                            solComponentWrap.JPORootCause =solCompRep.Root_Cause__c; 

                                        solComponentWrap.accountCode = solCompRep.AccountCode__c;
                                        lstAcctCodeType = new List<string>();

                                        if(solCompRep.AccountCodeType__c != null && solCompRep.AccountCodeType__c != ''){
                                            if((solCompRep.AccountCodeType__c).contains('-')){
                                                lstAcctCodeType = solCompRep.AccountCodeType__c.split('-');
                                                if(lstAcctCodeType != null && lstAcctCodeType.size() > 0){
                                                    // Commented below two lines - Satish - Defect# 118981
                                                    //solComponentWrap.accountCodeType = solCompRep.AccountCodeType__c;
                                                    solComponentWrap.accountCodeType = lstAcctCodeType[1].ToUppercase();
                                                }
                                            }
                                            else{
                                                solComponentWrap.accountCodeType = solCompRep.AccountCodeType__c.ToUppercase();
                                            }
                                        }
                                    }
                                    else{
                                        solComponentWrap.JPORootCause = false; 
                                    }

                                    solComponentWrap.failcodeEditable=solCompRep.Fail_Code_Editable__c;
                                    solComponentWrap.accountCodeEditable = solCompRep.AccountCodeEdit__c;
                                    //system.debug('22 FailMode+Claimtype**'+solCompRep.Failure_Mode__c+solCompRep.Claim_Type__c);
                                    solComponentWrap.failmode = solCompRep.Failure_Mode__c;

                                    if(solCompRep.Failure_Mode__c !=null && solCompRep.Failure_Mode__c.trim() !=''){
                                        String failMode = solCompRep.Failure_Mode__c;
                                        if(solCompRep.Failure_Mode__c.contains('-'))
                                            failMode = solCompRep.Failure_Mode__c.split('-')[0]; //for #163195
                                        //List<CSS_JobEventTemporary__c> tempList = new List<CSS_JobEventTemporary__c>([select Attribute1__C,Attribute3__c,Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailModes' and Attribute1__c=:failMode limit 1 ]);
                                        //if(tempList !=null && tempList.size()>0)
                                        //solComponentWrap.failmodedesc = tempList.get(0).Attribute3__c;
                                        if(failmodedescMap != null && failmodedescMap.size() >0)
                                            solComponentWrap.failmodedesc =failmodedescMap.get(failMode);
                                    }
                                    //system.debug('22 solComponentWrap.failmodedesc>>:'+solComponentWrap.failmodedesc);

                                    solComponentWrap.claimtype = solCompRep.Claim_Type__c;
                                    if(solCompRep.CSS_CoverageType__c == 'POL'){
                                        if(!ProfileName.containsIgnoreCase('Dealer')){
                                            if(solCompRep.Authorization_Number__c != null && solCompRep.Approval_Code__c != null && solCompRep.Pay_Code__c != null && solCompRep.Pay_Code__c != 'Select One'){
                                                solComponentWrap.isAuthorized = 'true';
                                            }
                                            else solComponentWrap.isAuthorized = 'false';
                                        }
                                        else if(solCompRep.Authorization_Number__c != null && solCompRep.Approval_Code__c != null){
                                            solComponentWrap.isAuthorized = 'true';
                                        }
                                        else solComponentWrap.isAuthorized = 'false';
                                    }
                                    lstsolComponentWrap.add(solComponentWrap);
                                    system.debug(' Today lstsolComponentWrap-->'+lstsolComponentWrap);

                                    //Adding Solution Components End
                                    for(integer i=0;i<solCompRep.CSS_SRTS__r.size();i++){
                                        if(solCompRep.CSS_SRTS__r[i].Type__c.equalsIgnoreCase('Repair') && solCompRep.CSS_SRTS__r[i].Solution_Number__c == sol.id && symp.id == sol.Symptom__c && solCompRep.CSS_SRTS__r[i].isPerformed__c == true){
                                            timeRep = timeRep + solCompRep.CSS_SRTS__r[i].Repair_Time__c;
                                        }
                                        partsWrap.repTime = string.valueof(timeRep);
                                    }
                                    partsWrap.failcode = solCompRep.Fail_Code__c;
                                    if(solCompRep.Fail_Code__c != null){
                                        faultList.add(solCompRep.Fail_Code__c);
                                    }

                                }
                            }

                        }
                        system.debug('outputfromcontroller-->'+lstsolComponentWrap);
                        if(lstsolComponentWrap!=null){
                            solWrap.solCompWrap=lstsolComponentWrap;
                        }
                        system.debug('Your solution wrapper is -->'+solWrap);
                        if(faultList != null && solWrap.hasComponent == true){
                            system.debug('FaultList --> '+faultList);
                            solWrap.failcodelst= faultList;
                        }
                    }

                    // }//for if

                    for(CSS_Solution_Component__c solComp : compPartsList){
                        if(solComp.Solutions__c == sol.id ){
                            solWrap.hasComponent = true;
                            if(solComp.CSS_Parts_Options__r!=null && !solComp.CSS_Parts_Options__r.isEmpty() && symp.id == sol.Symptom__c){

                                System.debug('ABCD');
                                for(integer i=0;i<solComp.CSS_Parts_Options__r.size();i++){
                                    System.debug('ABCDE');
                                    if(solComp.id == solComp.CSS_Parts_Options__r[i].FailurepartId__c){
                                        System.debug('ABCDEF');
                                        partsWrap.partsList.add(solComp.CSS_Parts_Options__r[i].name);
                                        if(solComp.CSS_Parts_Options__r[i].selected_part__c== true){
                                            partlist.add(solComp.CSS_Parts_Options__r[i].name);

                                        }
                                    }
                                }
                            }
                        }

                    }
                    if(partlist!=null && !partlist.isEmpty() ){
                        solWrap.partsListCount=partlist;


                    }
                }
                //  }//for solution

                if(partsWrap.Name!=null){
                    partsListWrap.add(partsWrap);
                }
                System.debug('The partswrap is'+partsListWrap);


            }
            List<CSS_Solution_Component__c> LstSolComp1=[select id,name,system_code__c,Claim_Type__c,Create_User__c,Change_User__c,Component_Code__c,Failure_Mode__c,FailMode_Desc__c from CSS_Solution_Component__c where Service_Job__r.name=:workJob.name AND ((Type__c != null AND Performed_Review__c = true) OR (Type__c = null AND Selected_Component__c = true) )];
            system.debug('LstSolComp1--'+LstSolComp1);
            if(LstSolComp1 != null && LstSolComp1.size()>0){
                sendfailtoERP = true;
                system.debug('Inside IF');
            }
            else{
                sendfailtoERP = false;
                system.debug('Inside ELSE');
            }

        }
        catch(exception e){
            system.debug('Job Plan Controller Exception --> '+ e.getLineNumber() + ' ' +e.getMessage() );
        }
        //partsListWrap[0].lstConcatenatedFailCodes = lstConcatenatedFailCodes;
        return partsListWrap;
    }


    public list<string> lstAccountCodes{get;set;}
    public List<SelectOption> accCodes{get;set;}

    public void getAccountCodes() {
        try{
            lstAccountCodes = new list<String>();

            //string orgtype=css_utility.getOrgType(userinfo.getUserId());
            Profile profile1 = [SELECT Id, Name FROM Profile WHERE Id =: userinfo.getProfileId() limit 1];
            String orgtype = profile1.Name;
            Account Regionterritory = css_utility.getRegionTerritory(workJob.Creator_Location__c);

            User usr;
            usr = css_utility.getUserAttributes(userinfo.getUserId());
            string userRole = usr.UserRoleName__c;

            system.debug('orgtype--->'+orgtype);
            //system.debug('Regionterritory--->'+Regionterritory.Region__c);
            system.debug('userRole--->'+userRole);

            if(userRole.contains('Factory') || userRole.contains('DFSE') || userRole.contains('CFSE'))
            {
                jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
            }
            else{
                if (orgtype.ContainsIgnoreCase('DISTR')){
                    system.debug('Inside DISTR');
                    jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Key__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                }
                else{
                    if(Regionterritory != null && Regionterritory.Region__c != null && Regionterritory.Region__c.toUpperCase() == 'NORTH AMERICA'){
                        //jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Attribute7__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c,Attribute15__c FROM CSS_JobEventTemporary__c WHERE Attribute15__c != null and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
                    else{
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c,Attribute5__c FROM CSS_JobEventTemporary__c WHERE Attribute1__c IN ('OTH','POL','NPW','RPW','REW','RRW') and Key__c = 'AccountCodes' order by Attribute2__c asc];
                    }
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
                    //lstAccountCodes.add(j.Attribute2__c);
                    lstAccountCodes.add(s);
                }
            }
            //getAccountCodes1();
            system.debug('Query--->'+jobEventTemp);
            system.debug('lstAccountCodes--->'+lstAccountCodes);
        }
        catch(Exception ex){
            system.debug('Exception on getting SRT Component Load method -->' + ex.getmessage() + ex.getLineNumber());

        }

    }//end of buildConcatenatedFailCodes method
    //story# 111470 end




    //Method to get list of Account Codes
    public List<SelectOption> accCodes1{get;set;}
    List<CSS_JobEventTemporary__c> jobEventTemp = new List<CSS_JobEventTemporary__c>();
    public List<SelectOption> getAccountCodes1(){
        system.debug('lstAccountCodes--->'+lstAccountCodes);
        accCodes1 = new List<SelectOption>();
        if(lstAccountCodes != null){
            for(string s : lstAccountCodes){
                accCodes1.add(new SelectOption(s,s));
            }
        }
        return accCodes1;
    }

    public CSS_Solution_Component__c solnCompRec {get;set;}
    public PageReference updateFailCodeComponents(){
        showLicensePlateRequired = false;
        PageReference pageref;
        String selectedSysCode1;
        String selectedCompCode1;
        String selectedFailMode1;
        String selectedFaultCode1;
        try{
            licenseplate=workJob.License_Plate__c;
            licenseplateSelected = workJob.License_Plate__c;
            system.debug('before validations' + ' ' + invalidAppCode);
            Validations();
            system.debug('after validations' + ' ' + invalidAppCode);

            //  if(invalidAppCode == 'true')
            onChangeofAppCode();

            system.debug('** in updateFailCodeComponents **'+partsListWrap);
            system.debug('failCodeSelected**'+failCodeSelected);
            system.debug('accCodeSelected**'+accCodeSelected);
            system.debug('accCodeWS**'+accCodeWS);
            system.debug('selectedFaultCode+RAJESH**'+selectedFaultCode);
            system.debug('FName:'+selectedFName);
            system.debug('failM1*****'+selectedFailMode);
            system.debug('failN*****'+selectedFNameValue);
            system.debug('failNM*****'+selectedFailModeValue);
            system.debug('Today licenseplateSelected > ' + licenseplateSelected);
            system.debug('Today workJob.License_Plate__c > ' + workJob.License_Plate__c);
            //system.debug('***selectedSysCode***'+selectedSysCode);
            // system.debug('***selectedCompCode***'+selectedCompCode);
            //selectedFailModeValue=selectedFailMode;//Commented based on defect #176570
            selectedFaultCodeValue = selectedFaultCode;
            String selectedSysCodeDesc=selectedSysCode;
            String selectedCompCodeDesc=selectedCompCode;
            //system.debug('***selectedFailMode$$***'+compont.FailMode_Desc__c);
            String selectedFailModeDesc=selectedFailMode;
            String selectedFaultCodeDesc=selectedFaultCode;
            CSS_Solution_Component__c solnComp = new CSS_Solution_Component__c();

            //siva ganesh added logic for story #GSSC-55
            if(accCodeSelected == 'EMISSION WARRANTY 70'){
                if(licenseplateSelected == null || licenseplateSelected == '' || licenseplateSelected == 'Select One' ){
                    //  if(workJob.License_Plate__c=='Select One' || workJob.License_Plate__c== null || workJob.License_Plate__c== '' ){
                    workJob.License_Plate__c='Select One';
                    system.debug('Today Inside If');
                    showLicensePlateRequired = true;
                    return null;
                    //}
                }
                else{
                    if(licenseplateSelected == 'Select One' || licenseplateSelected == null || licenseplateSelected == ''){
                        system.debug('Today Inside else');
                        showLicensePlateRequired = true;
                        return null;
                    }
                }

            }else{
                showLicensePlateRequired = false;
            }

            system.debug('Today showLicensePlateRequired > ' + showLicensePlateRequired);
            if(licenseplate!=null || licenseplate!=''){
                workJob.License_Plate__c= licenseplate;
                update workJob;
            }

            if(selectedFailModeValue!=null){
                selectedFailModeDesc=selectedFailModeValue;
                selectedFailMode=selectedFailModeValue;
                system.debug('***selectedFailMode1***'+selectedFailModeDesc + '$$'+selectedFailMode);
            }
            else{
                //selectedFailModeDesc= compont.FailMode_Desc__c;
                //selectedFailMode=compont.FailMode_Desc__c;
                system.debug('***selectedFailMode2***'+selectedFailModeDesc + '$$'+selectedFailMode);
            }
            if(selectedFaultCodeValue!=null && selectedFaultCodeValue!=''){
                selectedFaultCodeDesc= selectedFaultCodeValue;
                selectedFaultCode=selectedFaultCodeValue;
                system.debug('selectedFaultCodeValue**'+selectedFaultCodeValue);
            }
            else{
                //selectedFaultCodeDesc= compont.FaultCode_Desc__c;
                //selectedFaultCode=compont.FaultCode_Desc__c;
            }
            if(selectedSysCodeValue!=null){
                selectedSysCodeDesc= selectedSysCodeValue;
                //selectedSysCode=selectedSysCodeValue;
            }
            /*  else{
if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
//selectedSysCodeDesc= compont.SystemCode_Desc__c;
//selectedSysCode=compont.System_Code__c;
}
} */
            if(selectedCompCodeValue!=null){
                selectedCompCodeDesc= selectedCompCodeValue;
                selectedCompCode=selectedCompCodeValue;
            }
            /* else{
if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
// selectedCompCodeDesc= compont.ComponentCode_Desc__c;
//selectedCompCode=compont.Component_Code__c;
}
} */

            if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
                if(selectedCustFName != null && selectedCustFName != ''){
                    system.debug('Testinside'+selectedCustFName);
                    solnComp.CSS_Custom_Failure__c = selectedCustFName;
                    solnComp.Name = selectedCustFName;
                }
                else{
                    system.debug('Test233'+selectedSysCode+'$$'+selectedCompCode);
                    if(selectedSysCode != null && selectedSysCode != ''&& selectedCompCode!=null && selectedCompCode!=''){
                        SelectSysCode = selectedSysCode.substring(0,2);
                        SelectComCode = selectedCompCode.substring(0,2);
                        List<CSS_JobEventTemporary__c> tempList = [select Attribute1__C,Attribute4__c,Attribute7__c from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C=:SelectSysCode and Attribute4__c=:SelectComCode];
                        if(tempList!=null && tempList.size()>0 && tempList[0].Attribute7__c !=null && tempList[0].Attribute7__c !=''){
                            solnComp.Name=tempList[0].Attribute7__c;
                        }
                        else{
                            solnComp.Name=selectedSysCode.substring(0,2)+selectedCompCode.substring(0,2);
                        }
                    }
                }
            }
            else{
                if(selectedFName != null){
                    solnComp.Name = selectedFName;
                }
            }

            if(selectedSysCode.length()>2)
                selectedSysCode1 = selectedSysCode.substring(0,2);
            if(selectedCompCode.length()>2)
                selectedCompCode1 = selectedCompCode.substring(0,2);
            if(selectedFailMode!=null && selectedFailMode.length()>2)
                selectedFailMode1=selectedFailMode.substring(0,2);
            system.debug('selectedFaultCode-->'+selectedFaultCode);
            if(selectedFaultCode!=null && selectedFaultCode!='' && selectedFaultCode.contains('-')){
                String[] sFaultCode=selectedFaultCode.split('-')  ;
                selectedFaultCode1=sFaultCode[0];
            }
            system.debug('selectedFaultCode1-->'+selectedFaultCode1);
            //CSS_Solution_Component__c solnComp = new CSS_Solution_Component__c();
            CSS_Solution_Component__c solnComponent = new CSS_Solution_Component__c();
            CSS_SymptomQA__c sympQA = new CSS_SymptomQA__c();
            if(compID1 != null){
                /*solnComponent = [SELECT Id, FailCode_Formula__c, Fail_Code__c, AccountCodeType__c, Fail_Code_Editable__c,CSS_Account_Formula__c,
CoveredLaborHrs__c, CoveredMealsLodgingAmt__c, CoveredOCAmount__c, CoveredPartsQty__c,
CoveredTowingMiles__c, CoveredTravelLabor__c, CoveredTravelMiles__c,Failure_Mode__c,Claim_Type__c,Fault_Code__c
FROM CSS_Solution_Component__c WHERE Id =: compID1]; */
                solnComponent = [SELECT Id, FailCode_Formula__c, Fail_Code__c, AccountCodeType__c, Fail_Code_Editable__c,CSS_Account_Formula__c,
                                 CoveredLaborHrs__c, CoveredMealsLodgingAmt__c, CoveredOCAmount__c, CoveredPartsQty__c, CreatedById,
                                 CoveredTowingMiles__c, CoveredTravelLabor__c, CoveredTravelMiles__c,Failure_Mode__c,Claim_Type__c
                                 FROM CSS_Solution_Component__c WHERE Id =: compID1];
                if(sympQAId != null)
                    sympQA = [select Id,Name from CSS_SymptomQA__c where Id =:sympQAId];
                system.debug('SympList--->' + sympQA);
            }

            //css_solution_component__c compToUpdate = new css_solution_component__c();
            // solnCompRec = [SELECT Id, solutions__r.FaultCode__c,AccountCode__c,Selected_Component__c FROM CSS_Solution_Component__c WHERE Id =: componentId];

            // compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workJob.Failure_Date__c,string.valueof(workJob.Failure_Point__c),workJob.Failure_Point_Measure__c,workJob.ApplicationCode__c,workJob.Warranty_Start_Date__c,selectedSysCode1,selectedCompCode1,solCompRec.solutions__r.FaultCode__c,solCompRec.AccountCode__c,componentId,solCompRec.Selected_Component__c,'','','Second Call', workjob.ReconEngineFlag__c, false);
            if(SelectedsysCode!=null)
                solnComp.System_Code__c = SelectedsysCode;
            if(SelectedCompCode!=null)
                solnComp.Component_Code__c = SelectedCompCode;
            if(failCodeSelected != null)
            {
                system.debug('failCodeSelectedIF**');
                if(compID1 != null){
                    solnComp.Id = compID1;
                    //Start- Passing  "selectedFaultCode" value to Object Fault_Code__c field as per SIT story #150030, -By  RAJESH 25th June 2018
                    solnComp.Fault_Code__c = selectedFaultCode1;
                    system.debug('selectedFaultCode+RAJESH**'+selectedFaultCode1+solnComp.Fault_Code__c);
                    //End
                }
                if(failCodeSelected != 'Select One' && solnComponent.Fail_Code__c == null){
                    solnComp.Fail_Code_Editable__c = failCodeSelected;
                }
                else{
                    solnComp.Fail_Code_Editable__c = '';
                    //accCodeSelected = '';
                }
                if(accCodeSelected != null && accCodeSelected != 'Select One' && accCodeSelected != ''){
                    system.debug('accCodeSelected inside if -->'+accCodeSelected);
                    solnComp.AccountCodeEdit__c = accCodeSelected;
                    string Querystr;
                    Integer intIndex;
                    string QueryAccCode;
                    if(accCodeSelected != 'Select One' && accCodeSelected != '') {
                        Querystr = accCodeSelected.right(2);
                        Querystr = Querystr.trim();
                        //intIndex = accCodeSelected.indexOf(Querystr);
                        //QueryAccCode = accCodeSelected.left(intIndex);
                        QueryAccCode = (accCodeSelected.left(accCodeSelected.length()-2)).trim();
                        //QueryAccCode = QueryAccCode.trim();
                        system.debug('AccountCode*'+QueryAccCode);
                    }
                    //solnComp.AccountCode__c = accCodeSelected;
                    solnComp.AccountCode__c = Querystr;
                    solnComp.accountCodeType__c = QueryAccCode;
                }
                else{
                    solnComp.AccountCode__c = '';
                    solnComp.AccountCodeEdit__c = '';
                    // solnComp.AccountCodeEdit__c = accCodeWS; //kalpana story# 117207
                    system.debug('UpdatedAccCodeEdit'+accCodeWS);
                }
            }
            else if(accCodeSelected != null && accCodeSelected != 'Select One')
            {
                system.debug('accCodeSelectedIF**');
                if(componentId != null){
                    solnComp.Id = componentId;}
                string Querystr;
                Integer intIndex;
                string QueryAccCode;
                if(accCodeSelected != 'Select One' && accCodeSelected != '') {
                    Querystr = accCodeSelected.right(2);
                    Querystr = Querystr.trim();
                    intIndex = accCodeSelected.indexOf(Querystr);
                    QueryAccCode = accCodeSelected.left(intIndex);
                    QueryAccCode = QueryAccCode.trim();
                    system.debug('AccountCode*'+QueryAccCode);
                }
                solnComp.AccountCodeEdit__c = accCodeSelected;
                //solnComp.AccountCode__c = accCodeSelected;
                solnComp.AccountCode__c = Querystr;
                solnComp.accountCodeType__c = QueryAccCode;
            }
            else
            {
                if(componentId != null){
                    solnComp.Id = componentId;}
                //solnComp.AccountCodeEdit__c = '';
                solnComp.AccountCodeEdit__c = accCodeWS; //kalpana22122017
                system.debug('UpdatedAccCodeEdit'+accCodeWS);
            }

            if(failCodeSelected == null || failCodeSelected == '' || failCodeSelected == 'Select One')  // need to be commented: kalpanaa
            {
                solnComp.AccountCodeType__c = '';
                solnComp.AccountCode__c = '';
                //solnComp.Claim_Type__c = '';
                // solnComp.Failure_Mode__c = '';
            }
            system.debug('AccCodeType**'+solnComponent.AccountCodeType__c);
            /*if(solnComponent.AccountCodeType__c != null)
solnComp.AccountCodeEdit__c = '';*/

            if(partsWarranty != null){
                solnComp.Parts_Warranty__c = partsWarranty;
            }
            else{
                if( accCodeSelected!=null && (accCodeSelected.contains('62') || accCodeSelected.contains('35'))){
                    solnComp.Parts_Warranty__c = 'New Parts Warranty';
                }
                else {
                    if(accCodeSelected!=null && (accCodeSelected.contains('97') || accCodeSelected.contains('41'))){
                        solnComp.Parts_Warranty__c = 'Recon Parts Warranty';
                    }
                }
            }
            system.debug('custSelect**'+custSelect);
            if(custSelect != null && custSelect != '' ){
                solnComp.Customer_Take_Possession__c = custSelect;
            }
            else{
                if(accCodeSelected!=null && (accCodeSelected.contains('62') || accCodeSelected.contains('97'))){
                    solnComp.Customer_Take_Possession__c = 'Yes';
                    system.debug('Testpos'+solnComp.Customer_Take_Possession__c);
                }
                else {
                    if(accCodeSelected!=null && (accCodeSelected.contains('35') || accCodeSelected.contains('41'))){
                        solnComp.Customer_Take_Possession__c = 'No';
                        system.debug('Testpos1'+solnComp.Customer_Take_Possession__c);
                    }
                }

            }

            User usr;
            usr = css_utility.getUserAttributes(userinfo.getUserId());
            string userRole = usr.UserRoleName__c;
            //182849
            if(!userRole.contains('Factory')){
                if(accCodeSelected!=null && (accCodeSelected.contains('62') && solnComp.Customer_Take_Possession__c == 'No')){

                    solnComp.AccountCodeEdit__c = 'PARTS WARRANTY - DEFECT FROM STOCK 35 ';
                    solnComp.AccountCode__c= null;
                }
                if(accCodeSelected!=null && (accCodeSelected.contains('97') && solnComp.Customer_Take_Possession__c == 'No')){

                    solnComp.AccountCodeEdit__c = 'RECON PART - DEFECT FROM STOCK 41 ';
                    solnComp.AccountCode__c= null;
                }


                if(accCodeSelected!=null && (accCodeSelected.contains('35') && solnComp.Customer_Take_Possession__c == 'yes')){

                    solnComp.AccountCodeEdit__c = 'NEW PARTS WARRANTY 62';
                    solnComp.AccountCode__c= null;
                }
                if(accCodeSelected!=null && (accCodeSelected.contains('41') && solnComp.Customer_Take_Possession__c == 'yes')){

                    solnComp.AccountCodeEdit__c = 'RECON PARTS WARRANTY 97 ';
                    solnComp.AccountCode__c= null;
                }
            }
            //end

            if(failureMeasure != null){
                solnComp.Failure_Measure__c = failureMeasure;
            }
            else{
                solnComp.Failure_Measure__c = 'Miles';
            }
            if(compont != null) {  //Kalpana 146954 to cover SAve functionality from "Add"
                system.debug('Inside Compont**');
                if(compont.Part_Warranty_Start_Date__c != null)
                    solnComp.Part_Warranty_Start_Date__c = compont.Part_Warranty_Start_Date__c;
                else
                    solnComp.Part_Warranty_Start_Date__c = null;

                /*if(solnComp.Part_Warranty_Start_Date__c!=null && solnComp.Part_Warranty_Start_Date__c>System.TODAY()){
checkPartsWarrStartDt = true;
}
else{
checkPartsWarrStartDt = false;
}*/
                system.debug('compont.Failure_Date__c'+compont.Failure_Date__c);
                if(compont.Failure_Date__c != null)
                    solnComp.Failure_Date__c = compont.Failure_Date__c;
                else
                    solnComp.Failure_Date__c = failureDate;
                if(compont.Failure_Date__c==null && failureDate== null) 
                    solnComp.Failure_Date__c = workjob.Failure_Date__c;

                if(compont.Failure_Point__c != null)
                    solnComp.Failure_Point__c = compont.Failure_Point__c;
                else
                    solnComp.Failure_Point__c = null;

                if(compont.Authorization_Number__c != null)
                    solnComp.Authorization_Number__c = compont.Authorization_Number__c;
                else
                    solnComp.Authorization_Number__c = null;


                if(compont.Approval_Code__c != null)
                    solnComp.Approval_Code__c = appCodeSelected;
                else
                    solnComp.Approval_Code__c = null;

                if(payCodeSelected != null && payCodeSelected != '')
                {solnComp.Pay_Code__c = payCodeSelected;
                 compont.Pay_Code__c = payCodeSelected;
                }
            }
            if(coverageType != null) // Kalpana Story# 121073
                solnComp.CSS_CoverageType__c = coverageType;
            if(claimTypeSelected == null || claimTypeSelected =='Select One')
                solnComp.claim_type__C = '';
            else
                solnComp.claim_type__C = claimTypeSelected;
            if(selectedFailMode1 != null)
                solnComp.Failure_Mode__c = selectedFailMode1;
            system.debug('FM1***--'+solnComp.Failure_Mode__c);
            if(selectedFailModeDesc != null)
                solnComp.FailMode_Desc__c = selectedFailModeDesc;
            system.debug('FMd1***--'+solnComp.FailMode_Desc__c);
            if(selectedFaultCodeDesc != null)
                solnComp.FaultCode_Desc__c = selectedFaultCodeDesc;
            if(selectedCompCodeDesc != null)
                solnComp.ComponentCode_Desc__c = selectedCompCodeDesc;
            if(selectedSysCodeDesc != null)
                solnComp.SystemCode_Desc__c = selectedSysCodeDesc;
            if(failureSolCompID != null)
                solnComp.Component_Id__c = failureSolCompID;
            //if(selectedFName != null)
            // solnComp.Name = selectedFName;
            /*if(selectedFNameValue!=null)
solnComp.Name=selectedFNameValue;
else{
if(compont!=null && compont.name!=null)
solnComp.Name=compont.name;
else
solnComp.Name=selectedFName;
}  */
            if(authNumbers != null)
                solnComp.Authorization_Number__c = authNumbers;

            if(selectedSysCode1 != null)
                solnComp.System_Code__c = selectedSysCode1;
            if(selectedCompCode1 != null)
                solnComp.Component_Code__c = selectedCompCode1;
            if(compToUpdate != null && compToUpdate.CertificateNumber__c != null )
                solnComp.CertificateNumber__c = compToUpdate.CertificateNumber__c;//This one we are going to pass the CAP Claims

            if(isDealer){
                if(compToUpdate ==null){
                    solnComp.Pay_Code__c = 'D';
                }else if(compToUpdate !=null && (compToUpdate.Pay_Code__c==null || compToUpdate.Pay_Code__c.trim()=='') ){
                    solnComp.Pay_Code__c = 'D';
                    //solnComp.Pay_Code__c = compToUpdate.Pay_Code__c;
                }
            }
            if(compToUpdate != null){
                solnComp.GetAccountCodeServiceRun__c = compToUpdate.GetAccountCodeServiceRun__c;
                solnComp.AccountCode_Call_Status__c = compToUpdate.AccountCode_Call_Status__c;
            }

            system.debug('output-->'+solnComp);
            system.debug('FCErrorval-->'+FCErrorval);
            system.debug('solCompExistsFlag-->'+solCompExistsFlag);
            system.debug('blankField-->'+blankField);
            system.debug('invalidAppCode-->'+invalidAppCode);
            system.debug('dateErrFlag-->'+dateErrFlag);
            system.debug('higherdateErrFlag-->'+higherdateErrFlag);
            system.debug('checkPartsWarrStartDt--'+checkPartsWarrStartDt);
            system.debug('InsertFlag 2775' + '  ' +InsertFlag);
            //Added below try catch as part of the defect # 191466
            try{
                //Update symptom name with fault code only when symptom name contains salesforce id
                Id sfId = Id.valueOf(sympQA.Name);
                if(selectedFaultCode1 != '' && selectedFaultCode1 != null)
                {
                    if(sympQA != null)
                        sympQA.Name = selectedFaultCode1;
                    if(sympQAId != null)
                        sympQA.Id = sympQAId;

                    if(sympQA != null && sympQAId!=null)
                        update sympQA;
                }
            }
            catch(exception ex){
                //Do nothing - means symptom name is valid 
            }
            if(solnComp.Part_Warranty_Start_Date__c!=null && solnComp.Part_Warranty_Start_Date__c>System.TODAY())checkPartsWarrStartDt = true;
            else checkPartsWarrStartDt = false;
            if(tempfailureDate==null) tempfailureDate =solnComp.Failure_Date__c;
            if(tempfailureDate>date.today() && failureDate!=null)higherdateErrFlag = true;
            else higherdateErrFlag = false;
            if(solnComp.Part_Warranty_Start_Date__c!=null && solnComp.Failure_Date__c<solnComp.Part_Warranty_Start_Date__c && failureDate!=null)dateErrFlag = true;
            else dateErrFlag = false;
            system.debug('coverageType'+coverageType);
            system.debug('solnComp--->'+solnComp);
            system.debug('stopFailureSave--->'+stopFailureSave);
            system.debug('errornotcovfound--->'+errornotcovfound);
            system.debug('warrantyDetError--->'+warrantyDetError);
            system.debug('FCErrorval--->'+FCErrorval);
            system.debug('solCompExistsFlag--->'+solCompExistsFlag);
            system.debug('blankField--->'+blankField);
            system.debug('invalidAppCode--->'+invalidAppCode);
            system.debug('dateErrFlag--->'+dateErrFlag);
            system.debug('higherdateErrFlag--->'+higherdateErrFlag);
            system.debug('checkPartsWarrStartDt--->'+checkPartsWarrStartDt);
            
            for(CSS_WPR_JobPlanOverview  wrap1 : partsListWrap){
                for(CSS_WPR_JobPlanOverview.solWrapper  wrap2 : wrap1.solList){
                    for(CSS_WPR_JobPlanOverview.solCompWrapper  wrap3 : wrap2.solCompWrap){
                        if(solnComp.Id == wrap3.compId){
                            
                            if(wrap3.JPORootCause == null || wrap3.JPORootCause == false){
                                 solnComp.Root_Cause__c= false;
                            }
                            else{
                            solnComp.Root_Cause__c= wrap3.JPORootCause;
                            }
                            
                        }
                    }
                }
            }
            
            if(solnComp != null && (stopFailureSave ==false && errornotcovfound == false && warrantyDetError!=true &&  FCErrorval == false && solCompExistsFlag !='true' && blankField == false && invalidAppCode == 'false'  && higherdateErrFlag == false && dateErrFlag==false
                                    && checkPartsWarrStartDt == false && invalidFailMode==false && invalidFaultCode == false && invalidCompCode == false && invalidSysCode == false && invalidCustFailure == false && invalidFailure == false)){
                if(InsertFlag == true)  // To cover SAVE functionality from "Add"
                {
                    system.debug('inside insert flag');
                    Insert solnComp;
                    system.debug('inside insert flag'+solnComp);
                }
                else{
                    if(compToUpdate!=null) //Adding logic for Defect#173460
                    {
                        if(compToUpdate.CoveredLaborHrs__c != '' && compToUpdate.CoveredLaborHrs__c != '0')
                            solnComp.CoveredLaborHrs__c=compToUpdate.CoveredLaborHrs__c;
                        else
                            solnComp.CoveredLaborHrs__c='0';
                        if(compToUpdate.CoveredMealsLodgingAmt__c != '' && compToUpdate.CoveredMealsLodgingAmt__c != '0')
                            solnComp.CoveredMealsLodgingAmt__c = compToUpdate.CoveredMealsLodgingAmt__c;
                        else
                            solnComp.CoveredMealsLodgingAmt__c='0';
                        if(compToUpdate.CoveredOCAmount__c != '' && compToUpdate.CoveredOCAmount__c != '0')
                            solnComp.CoveredOCAmount__c = compToUpdate.CoveredOCAmount__c;
                        else
                            solnComp.CoveredOCAmount__c='0';
                        if(compToUpdate.CoveredPartsQty__c != '' && compToUpdate.CoveredPartsQty__c != '0')
                            solnComp.CoveredPartsQty__c=compToUpdate.CoveredPartsQty__c;
                        else
                            solnComp.CoveredPartsQty__c='0';
                        if(compToUpdate.CoveredTowingMiles__c != '' && compToUpdate.CoveredTowingMiles__c != '0')
                            solnComp.CoveredTowingMiles__c=compToUpdate.CoveredTowingMiles__c;
                        else
                            solnComp.CoveredTowingMiles__c='0';
                        if(compToUpdate.CoveredTravelLabor__c != '' && compToUpdate.CoveredTravelLabor__c != '0')
                            solnComp.CoveredTravelLabor__c=compToUpdate.CoveredTravelLabor__c;
                        else
                            solnComp.CoveredTravelLabor__c='0';
                        if(compToUpdate.CoveredTravelMiles__c != '' && compToUpdate.CoveredTravelMiles__c != '0')
                            solnComp.CoveredTravelMiles__c=compToUpdate.CoveredTravelMiles__c;
                        else
                            solnComp.CoveredTravelMiles__c='0';
                        if(compToUpdate.CampaignPartsPercentage__c != '' && compToUpdate.CampaignPartsPercentage__c != '0')
                            solnComp.CampaignPartsPercentage__c=compToUpdate.CampaignPartsPercentage__c;
                        else
                            solnComp.CampaignPartsPercentage__c='0';
                        if(compToUpdate.CoveredTravelBaseFareAmt__c != '' && compToUpdate.CoveredTravelBaseFareAmt__c != '0')
                            solnComp.CoveredTravelBaseFareAmt__c=compToUpdate.CoveredTravelBaseFareAmt__c;
                        else
                            solnComp.CoveredTravelBaseFareAmt__c='0';
                        if(compToUpdate.WarrantyId__c != '' && compToUpdate.WarrantyId__c != '0')
                            solnComp.WarrantyId__c=compToUpdate.WarrantyId__c;
                        else
                            solnComp.WarrantyId__c='0';
                        if(compToUpdate.CampaignLaborPercentage__c != '' && compToUpdate.CampaignLaborPercentage__c != '0')
                            solnComp.CampaignLaborPercentage__c=compToUpdate.CampaignLaborPercentage__c;
                        else
                            solnComp.CampaignLaborPercentage__c='0';
                        if(compToUpdate.CampaignOCPercentage__c != '' && compToUpdate.CampaignOCPercentage__c != '0')
                            solnComp.CampaignOCPercentage__c=compToUpdate.CampaignOCPercentage__c;
                        else
                            solnComp.CampaignOCPercentage__c='0';
                        if(compToUpdate.CampaignTowingPercentage__c != '' && compToUpdate.CampaignTowingPercentage__c != '0')
                            solnComp.CampaignTowingPercentage__c=compToUpdate.CampaignTowingPercentage__c;
                        else
                            solnComp.CampaignTowingPercentage__c='0';
                        if(compToUpdate.CampaignTravelPercentage__c != '' && compToUpdate.CampaignTravelPercentage__c != '0')
                            solnComp.CampaignTravelPercentage__c=compToUpdate.CampaignTravelPercentage__c;
                        else
                            solnComp.CampaignTravelPercentage__c='0';
                        if(compToUpdate.DeductibleAmount__c != '' && compToUpdate.DeductibleAmount__c != '0')
                            solnComp.DeductibleAmount__c=compToUpdate.DeductibleAmount__c;
                        else
                            solnComp.DeductibleAmount__c='0';
                        //if(compToUpdate.CertificateNumber__c != '' && compToUpdate.CertificateNumber__c != '0')
                        solnComp.CertificateNumber__c=compToUpdate.CertificateNumber__c;
                        //else
                        //solnComp.CertificateNumber__c='0';
                    }
                    else{
                        if(coverageType == 'OTH' || coverageType == 'POL'){
                            solnComp.CoveredLaborHrs__c='0';
                            solnComp.CoveredMealsLodgingAmt__c='0';
                            solnComp.CoveredOCAmount__c='0';
                            solnComp.CoveredPartsQty__c='0';
                            solnComp.CoveredTowingMiles__c='0';
                            solnComp.CoveredTravelLabor__c='0';
                            solnComp.CoveredTravelMiles__c='0';
                            solnComp.CampaignPartsPercentage__c='0';
                            solnComp.CoveredTravelBaseFareAmt__c='0';
                            solnComp.WarrantyId__c='0';
                            solnComp.CampaignLaborPercentage__c='0';
                            solnComp.CampaignOCPercentage__c='0';
                            solnComp.CampaignTowingPercentage__c='0';
                            solnComp.CampaignTravelPercentage__c='0';
                            solnComp.DeductibleAmount__c='0';
                        }
                    }
                    //Added as part of the story 183428, 184816
                    system.debug('oldFailCode-->'+oldFailCode);
                    system.debug('oldAccCode-->'+oldAccCode);
                    system.debug('newFailCode-->'+solnComp.System_Code__c+solnComp.Component_Code__c);
                    system.debug('newAccCode-->'+solnComp.AccountCodeEdit__c);
                    if((oldFailCode != solnComp.System_Code__c+solnComp.Component_Code__c) || (oldAccCode != solnComp.AccountCodeEdit__c)){
                        CG_CL_UpdateJob_FC_AC_ChildEntities contr = new CG_CL_UpdateJob_FC_AC_ChildEntities();
                        contr.updateFailCodeAccCode(oldFailCode, oldAccCode, solnComp.System_Code__c+solnComp.Component_Code__c, solnComp.AccountCodeEdit__c, solnComp, Wid, coverageType);
                    }
                    update solnComp;
                    system.debug('solnComp update '+solnComp);
                }

                //delete the 99SRT record  START when failcode and Accountcode changes
                List<CSS_Solution_Component__c> solutionComponentList = new List<CSS_Solution_Component__c>();
                Set<String> failAcocuntCodeSet = new Set<String>();

                //Fetching data from CSS Solution Components.
                for(CSS_Solution_Component__c solComp : [select Id, Type__c, CSS_Account_Formula__c, Fail_Code__c, FailCode_Formula__c, Selected_Component__c
                                                         From CSS_Solution_Component__c
                                                         where (Selected_Component__c = true OR Type__c IN ('CAMPAIGN','ATC','TRP'))
                                                         AND Service_Job__c=:Wid]) {
                    if(solComp.Selected_Component__c == true){
                        if(solComp.FailCode_Formula__c != null) {
                            system.debug('insideSolCompTrue****'+solComp.FailCode_Formula__c);
                            string s = solComp.FailCode_Formula__c + ':' + solComp.CSS_Account_Formula__c;
                            failAcocuntCodeSet.add(s);

                        }
                    }
                    else if(solComp.Type__c == 'CAMPAIGN' || solComp.Type__c == 'TRP' || solComp.Type__c == 'ATC'){
                        if(solComp.Fail_Code__c != null) {
                            system.debug('insidefieldaction****'+solComp.Fail_Code__c);
                            string s = solComp.Fail_Code__c + ':' + solComp.CSS_Account_Formula__c;
                            failAcocuntCodeSet.add(s);

                        }
                    }
                }
                String key;
                List<CSS_SRT__c> srtToDelete = new List<CSS_SRT__c>();
                String notesNarrative;
                CSS_job_Order__c jobOrderTemp = new CSS_Job_Order__c();
                system.debug('failAcocuntCodeSet****'+failAcocuntCodeSet);
                notesNarrative='';
                List<CSS_SRT__c> srtToUpdLst = [SELECT Id, Account_Code_Description__c, Fail_Code_Description__c, Component_Id__c, Component_Id__r.Name FROM CSS_SRT__c WHERE Job_order__c=:Wid AND
                                                Type__c='99Time' AND Component_Id__c =: componentId];
                system.debug('srtToUpdLst'+srtToUpdLst);
                system.debug('solnComp.CoveredLaborHrs__c-->'+solnComp.CoveredLaborHrs__c);

                CSS_SRT__c srtToUpd = new CSS_SRT__c();
                if(srtToUpdLst != null && srtToUpdLst.size() > 0){
                    srtToUpd.Id = srtToUpdLst[0].Id;
                    if((solnComp.CoveredLaborHrs__c != null && solnComp.CoveredLaborHrs__c != '' && double.valueof(solnComp.CoveredLaborHrs__c) > 0) || (coverageType == 'OTH' || coverageType == 'POL')){
                        srtToUpd.Fail_Code_Description__c = srtToUpdLst[0].Component_Id__r.Name+'-'+solnComp.System_Code__c+solnComp.Component_Code__c;
                        srtToUpd.Account_Code_Description__c = solnComp.AccountCodeEdit__c;
                    }
                    else{
                        // srtToDelete.add(srtToUpd);//commented delete functionality as per defect #188128-new functionality implemented as per vignesh words-,By RAJESH june 14th 2019]
                        system.debug('***enter inside else part***');
                        srtToUpd.Fail_Code_Description__c = srtToUpdLst[0].Component_Id__r.Name+'-'+solnComp.System_Code__c+solnComp.Component_Code__c;
                        srtToUpd.Account_Code_Description__c = '';
                    }
                }
                system.debug('srtToUpd-->'+srtToUpd);
                system.debug('srtToDelete-->'+srtToDelete);
                if(failAcocuntCodeSet.size()>0){
                    for(CSS_SRT__c srt : [SELECT Id,Account_Code_Description__c,Fail_Code_Description__c,SRT_Notes__c FROM CSS_SRT__c
                                          WHERE Job_order__c=:Wid AND
                                          Type__c='99Time' AND Fail_Code_Description__c != null]){
                        key = srt.Fail_Code_Description__c +':' + srt.Account_Code_Description__c;
                        system.debug('key****'+key);
                        if(!failAcocuntCodeSet.contains(key)){
                            //srtToDelete.add(srt);
                        }
                        else{
                            if(srt.SRT_Notes__c != '' && srt.SRT_Notes__c != null)
                                notesNarrative += srt.SRT_Notes__c + '\n';
                        }
                    }
                }
                system.debug('srtToUpd'+srtToUpd);
                if(srtToUpd != null && srtToUpd.Id != null){
                    update srtToUpd;
                }
                if(srtToDelete.size()>0){
                    delete srtToDelete;
                }
                //Delete the 99SRT record END

                //Defect - 161207
                if(Wid!=null){
                    if(notesNarrative!='' || notesNarrative==''){
                        jobOrderTemp.id=wid;
                        jobOrderTemp.Non_SRT_Details__c = notesNarrative;
                        update jobOrderTemp;
                    }
                }
                system.debug('SolnComp**'+solnComp);
                pageRef = new PageReference('/apex/Css_jobplan?id='+wid);
                pageRef.setRedirect(true);


                displayMpopup = false;
            }
            else{
                pageRef = null;
                system.debug('NOT SAVED');
            }
        }catch(exception e){
            system.debug('Entered into catch block of Update Fail Components method in job plan controller' + e.getmessage() + ' ' + e.getLineNumber());
        }
        return pageref;


    }
    public Boolean displayClosePopup {get;set;}
    public boolean showResolution{get;set;}
    public boolean showResolutionWithRepair{get;set;}
    public boolean showRepairs{get;set;}
    public List<CSS_Solutions__c> responseValues{get;set;}
    public Boolean nocamptsbtrps{get;set;}
    public List<selectOption> responseOptions{get;set;}
    public List<selectOption> resolutionOptions{get;set;}
    public boolean showRepairErrorMessage{get;set;}
    public list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
    public css_job_order__c closeJob{get;set;}
    set<Id> solutionIds = new set<Id>();
    list<CSS_Solutions__c> outOfOrderSolList = new list<CSS_Solutions__c>();
    public string newQuoteStr{get;set;}
    public integer countquote{get;set;}
    public Boolean displayBMSuserClosePopup {get;set;}
    public Boolean bmsUserCloseFlag;
    public Boolean requiredBMSMessage {get;set;}
    public boolean dsidStatus {get;set;}
    public void closeSession_close()
    {
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        cancelSJWrapperObj1.errorFlag = false;
        cancelSJWrapperObj1.errorMessage = '';
        cancelSJWrapperObj1.serviceJob = workJob;
        displayClosePopup=false;
    }
    public List<CSS_Fault_Code__c> fauCod;
    public PageReference closeSession(){
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        cancelSJWrapperObj1.errorFlag = false;
        cancelSJWrapperObj1.errorMessage = '';
        cancelSJWrapperObj1.serviceJob = workJob;
        system.debug('selectedCompId***'+componentId);
        user u = css_utility.getUserAttributes(UserInfo.getUserId());
        CSS_EDSAuthentication.getEDSUpdateTnR(workJob.DSID__c, u.FederationIdentifier, workJob.Customer_Name__c, workJob.Make__c, workJob.Model__c, workJob.AccessCode__c, workJob.Equipment_ID__c, workJob.Failure_Point__c, workJob.Failure_Point_Measure__c, workJob.Unit_Number__c,workJob.ESN__c,workJob.Shop_Work_Order__c);
        css_dsidclose dscl = new css_dsidclose();
        AggregateResult[]  fc = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Wid];
        System.debug('One 4');
        if(fc.size()>0){
            System.debug('One 5');
            integer maxSeq = integer.valueOf(fc[0].get('maxSeq'));
            System.debug('One 6');
            fauCod = [select Primary_Fault_Code__c, FaultCode__c,Name, Fault_Code_Type__c, Related_Fault_Code__c from CSS_Fault_Code__c
                      where Job_Order__c=:Wid and Sequence__c=:maxSeq and FaultCode__c !=Null and (Fault_Code_Type__c='APD-P' OR Fault_Code_Type__c='APD-R' OR Fault_Code_Type__c='BPD')];
        }
        //if (Wid != null && dsidIndi != null && dsidIndi.containsIgnoreCase('O'))
        if(Wid!=null)
        {
            closeJob = [Select id,DSID__c, (Select Id,Name, Case_Name__c, Service_Job__c,Repair_response__c,Out_Of_Order__c,Rank__c,Solution_Title__c ,
                                            Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r where service_job__c =:Wid), (Select id, name , performed__c, performed_review__c,
                                                                                                                                   Reviewed__c from CSS_CampTsbTrp__r where job_order__C=:Wid and( performed_review__c=True and performed__c=False))
                        from CSS_Job_Order__c where id= :Wid];
            System.debug('closeJob'+closeJob);

            countquote = 0;
            AggregateResult[] quoteAgg;
            quoteAgg = [Select count(Id) countquote from CSS_Quote__c where Service_Job__c =:Wid ];
            countquote = integer.valueOf(quoteAgg[0].get('countquote'));
            System.Debug('>>>>>countquote '+countquote);
            //Fixed for non bms user
            if (bmsEnabled == true && (workJob.Customer_Code__c == null || workJob.Unit_Number__c== null || workJob.Shop_Work_Order__c == null || countquote==0)){
                System.Debug('>>>>>Inside bmsFistFlag '+bmsUserCloseFlag);
                bmsUserCloseFlag = true;
            }

            PageReference pr;
            resolutionOptions= new list<selectOption>();

            if(Wid!=null) {
                List<Schema.PicklistEntry> ple = CSS_Job_Order__c.CSS_Resolution__c.getDescribe().getPicklistValues();
                if(ple != null && !ple.isEmpty()){
                    for(Schema.PicklistEntry f : ple){
                        resolutionOptions.add(new SelectOption(f.getLabel(), f.getValue()));
                    }
                }
                responseValues = new list<CSS_Solutions__c>();
                responseOptions = new List<selectOption>();
                List<Schema.PicklistEntry> pickVal = CSS_Solutions__c.Repair_response__c.getDescribe().getPicklistValues();
                if(pickVal != null && !pickVal.isEmpty()){
                    for(Schema.PicklistEntry values : pickVal){
                        responseOptions.add(new SelectOption(values.getLabel(), values.getValue()));
                    }
                }
            }
            system.debug('Inside close Method');
            list<CSS_Solutions__c> successSols = new List<CSS_Solutions__c>();
            list<CSS_Solutions__c> noSolPostivelyVerified = new list<CSS_Solutions__c>();
            list<css_CampTsbTrp__c> tsbTrpToBePerformed = new list<css_CampTsbTrp__c>();

            System.debug('closeJob campstsbtrps'+closejob.CSS_CampTsbTrp__r);
            for(CSS_CampTsbTrp__c camptsbtrps :closejob.CSS_CampTsbTrp__r) {
                if(camptsbtrps.performed_review__c && !camptsbtrps.performed__c){
                    tsbTrpToBePerformed.add(camptsbtrps);
                    showResolution= FALSE;
                    System.debug('CampTsbTrps'+tsbTrpToBePerformed);
                }
            }
            if(tsbTrpToBePerformed.isEmpty())   {
                System.debug('disd value'+closeJob.DSID__c);

                System.debug('Entered 1st loop');
                System.debug('b4 for iteration'+closeJob.CSS_Solutions__r);
                for(CSS_Solutions__c verfiedSols : closeJob.CSS_Solutions__r){
                    solutionIds.add(verfiedSols.Id);
                    if(verfiedSols.Out_Of_Order__c){
                        outOfOrderSolList.add(verfiedSols);
                        System.debug('out of order list'+outOfOrderSolList);
                    }
                    if( ( verfiedSols.Diagnostic_Response__c != null &&
                         verfiedSols.Diagnostic_Response__c.equalsIgnoreCase('Most Likely the Solution') ) &&
                       verfiedSols.Repair_Response__c!=null && verfiedSols.Repair_Response__c.contains('Successful')) {
                        successSols.add(verfiedSols);
                    }
                }   //end of for loop
                /* code for Update EDS webservice */
                css_accessSrtCompOutTo_Eds updateEDS = new css_accessSrtCompOutTo_Eds(solutionIds,workjob.DSID__c);

                if(workjob.DSID__c!= null && !string.isBlank(workJob.DSID__c)){
                    System.debug('entered if disd loop');
                    //css_accessSrtCompOutToEds updateEDS = new css_accessSrtCompOutToEds(solutionIds,workjob.DSID__c);
                    //updateEDS.accessSRTs();
                    //updateEDS.solComponents();
                    //updateEDS.outOfOrder(outOfOrderSolList);
                    System.debug('exiting if disd loop');
                }//end of If

                system.debug('successSols**'+successSols);
                system.debug('bmsUserCloseFlag**'+bmsUserCloseFlag);
                if(!successSols.isEmpty() && bmsUserCloseFlag != true){
                    updateEDS.accessSRTs();
                    updateEDS.solComponents();
                    updateEDS.outOfOrder(outOfOrderSolList);
                    updateEDS.insiteFaultCodes(fauCod,workjob.DSID__c);
                    dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                    if(dsidStatus) {workJob.DSID_Status__c='Closed';}
                    update workJob;
                    pr = pgSaveFinish();
                } else {
                    System.debug('Entered else loop');
                    jobClosePopup();
                    displayClosePopup = true;
                }
            } else {
                System.debug('Entered 4th loop');
                jobClosePopup();
                displayClosePopup = true;
            }
            system.debug('displayClosePopup'+displayClosePopup);
            //updateFailCodeComponents();
            return pr;
        } else{return null;}
    }
    public PageReference pgSaveFinish()
    {
        System.Debug('in pgSaveFinish==============');
        css_job_order__c worecord= new css_job_order__c();

        //   CSS_JobOrderWrapper wrap = new CSS_JobOrderWrapper(workJob,filterMake,filterModel,mil_measure,fail_measure);
        //   worecord = wrap.worecord;
        worecord.Previous_Status__c = workJob.Status__c;
        worecord.Status__c='Closed';
        worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
        worecord.Unit_Number__c = workJob.Unit_Number__c;
        worecord.Actual_Technician_Time__c = workJob.Actual_Technician_Time__c;
        saveCheckBox();
        System.debug('worecord'+worecord);
        if (Wid == null)
        {
            worecord.jobLocation__c=jobLocation;
            insert worecord;
            Wid = worecord.id;
        }
        else
        {
            System.Debug('value of customer===='+workJob.customer_name__c);
            worecord.id=workJob.id;
            update worecord;
            System.Debug('record updated====='+worecord);
        }

        PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME');
        pageRef.setRedirect(true);
        return pageRef;
    }
    public void jobClosePopup(){

        if (Wid != null)
        {
            list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
            responseValues = new List<css_solutions__c>();
            System.debug('Solutions for the entire Job:-->'+workJob.CSS_Solutions__r);
            if(closeJob != null){
                System.debug('Solutions for the entire Job:-->'+closeJob.CSS_Solutions__r);

                if(closeJob.CSS_CampTsbTrp__r == null || closeJob.CSS_CampTsbTrp__r.isEmpty()) {
                    nocamptsbtrps=false;
                    if(closeJob.CSS_Solutions__r == null || closeJob.CSS_Solutions__r.isEmpty()){
                        System.debug('Cond1');
                        showResolution = TRUE;
                        showRepairs = FALSE;
                    }else{
                        List<CSS_Solutions__c> repairSolutions = new List<CSS_Solutions__c>();
                        list<CSS_Solutions__c> noSolPostivelyVerified = new list<CSS_Solutions__c>();

                        System.debug('Solutions for the entire Job:-->'+workJob.CSS_Solutions__r);
                        for(CSS_Solutions__c soluRec : closeJob.CSS_Solutions__r){
                            if(soluRec.Diagnostic_Response__c != null && soluRec.Diagnostic_Response__c.equalsIgnoreCase('Most Likely the Solution')){
                                repairSolutions.add(soluRec);
                            }

                        } System.debug('repairSolutions'+repairSolutions);
                        if( noSolPostivelyVerified.isEmpty()){
                            System.debug('Cond2'+noSolPostivelyVerified);
                            showResolution = TRUE;
                            showRepairs = FALSE;
                            System.debug('Cond2showResolution'+showResolution);
                        }
                        if(repairSolutions.isEmpty()){
                            System.debug('Cond3'+repairSolutions);
                            showResolution = TRUE;
                            showRepairs = FALSE;
                        }else{
                            list<CSS_Solutions__c> noRepairList = new list<CSS_Solutions__c>();
                            for(CSS_Solutions__c solRec:repairSolutions){
                                if(solRec.Repair_Response__c == null){
                                    noRepairList.add(solRec);
                                    responseValues.add(solRec);
                                } else if(solRec.Repair_Response__c.contains('Successful')){
                                    postRepairList.add(solRec);
                                }
                            }

                            if(!noRepairList.isEmpty()){
                                System.debug('Cond3'+noRepairList);
                                showResolution = FALSE;
                                showRepairs = TRUE;
                            }

                            if(noRepairList.isEmpty() && postRepairList.isEmpty()){
                                System.debug('Cond4'+noRepairList+''+postRepairList);
                                showResolution = TRUE;
                                showRepairs = FALSE;
                                System.debug('Cond4showResolution'+showResolution);
                            }

                        }
                    } }
                else{
                    nocamptsbtrps= true;
                }
            }
        }
    }
    public transient List<CSS_Parts_Options__c> partsList = new List<CSS_Parts_Options__c>();
    public transient List<CSS_Solution_Component__c> compList = new List<CSS_Solution_Component__c>();
    public List<CSS_Parts_Options__c> eprPartList = new List<CSS_Parts_Options__c>();
    public List<CSS_Parts_Options__c> eprPartListNew = new List<CSS_Parts_Options__c>();
    public void jobPlanAction(){
        system.debug('in jobPlanAction...');
        try{
            getSRTFailurenamesOnLoad();//Added as part of design change
            partsList = [select Id, Name, Selected_part__c, FailurepartId__c, Service_partnumber__c, Account_Code__c, Fail_Code__c, Service_Job__c, ReturnToFactory__c from CSS_Parts_Options__c where Service_Job__c =: Wid AND ReturnToFactory__c = ''];
            //compList = [SELECT Id, Component_Id__c, Type__c FROM CSS_Solution_Component__c WHERE (Type__c = 'ATC' OR Type__c = 'Campaign' OR Type__c = 'TRP') AND Service_Job__c=:Wid]; // Commented and added below query, as we need to call the Field Action SRT service only when we have performed_review__c = true Components //story 190513
            compList = [SELECT Id, Component_Id__c, Type__c FROM CSS_Solution_Component__c WHERE Service_Job__c=:Wid AND ((Type__c = 'ATC' OR Type__c = 'Campaign' OR Type__c = 'TRP') AND Performed_Review__c = true)];
            if(bmsEnabled==true){
                system.debug('bmsEnabled+++++'+bmsEnabled);
                callUpdateUnitandWo();
            }

            system.debug('***insidejobPlanAction****');

            //Code added as part of development of User story 115653 - starts
            //If account code call status for any of the displayed sol component is failure, make warrantyFailure as false and display error message in visualforce page.
            for(CSS_Solution_Component__c solComp:[select name,Component_Id__c,Solutions__c,Service_Job__c,AccountCode_Call_Status__c from CSS_Solution_Component__c where Service_Job__c=:Wid]){
                system.debug('****status****'+solComp.AccountCode_Call_Status__c);
                if(solComp.AccountCode_Call_Status__c == 'Failure'){
                    system.debug('***InsidewarrantyfailureIf***');
                    warrantyFailure = true;
                    break;
                }
                system.debug('**warrantyFailure**'+warrantyFailure);
            }
            //Code added as part of development of User story 115653 - ends

            //Return to Factory(EPR Flag) callout
            eprPartList = CSS_FN_SIEBEL.getPartsReturn(partsList);
            //Commented below code as per story 190513, its moved to RJ PAges
            //Field Action SRT callout
            /*List<CSS_SRT__c> srtsListTemp = new List<CSS_SRT__c>([Select Id from CSS_SRT__c where Job_Order__c =: Wid and (Type__c = 'Field Action' OR Type__c = 'Field Action Access')]);
        system.debug(' srtsListTemp.size()**'+ srtsListTemp.size());
        if(srtsListTemp != null && srtsListTemp.size()==0 && compList !=null && compList.size()>0){
            CG_BL_Campaigns.callFieldActionSRT(compList,Wid);
        }*/

            if(eprPartList.size() > 0)
                update eprPartList;

            //181525 - Duplicate Failures.
            List<CSS_Solution_Component__c> jobPlanSolList = [SELECT Id, name, AccountCode__c, AccountCodeType__c, AccountCodeEdit__c, Fail_Code__c, CSS_Account_Formula__c
                                                              FROM CSS_Solution_Component__c
                                                              WHERE (Type__c = '' OR Type__c = null) AND Service_Job__c=:Wid AND Fail_Code__c != null AND CSS_Account_Formula__c != null
                                                              ORDER BY CSS_Failure_Sequence_Number__c];

            Map<string, List<CSS_Solution_Component__c>> DuplicateSolMap = new Map<string, List<CSS_Solution_Component__c>>();
            List<CSS_Solution_Component__c> duplicateFailureList = new list<CSS_Solution_Component__c>();
            //Map of Fail code + Account code and Solution component
            if(jobPlanSolList.size()>0){
                for(CSS_Solution_Component__c sctemp : jobPlanSolList) {
                    string solKey = sctemp.Fail_Code__c + sctemp.AccountCode__c;
                    if(DuplicateSolMap.containsKey(solKey)){
                        List<CSS_Solution_Component__c> fclist = DuplicateSolMap.get(solKey);
                        fclist.add(sctemp);
                        duplicateFailureList.add(sctemp);
                        DuplicateSolMap.put(solKey, fclist);
                    } else {
                        DuplicateSolMap.put(solKey, new List<CSS_Solution_Component__c> { sctemp });
                    }
                }
            }

            system.debug('duplicateFailureList >>> ' + duplicateFailureList);
            set<Id> dupSolIdSet = new set<Id>();
            Map<Id, string> mapFailureFC = new Map<Id, string>(); //GSSC-567

            for(CSS_Solution_Component__c dupSol : duplicateFailureList) {//jobPlanSolList){ - Defect 190514
                dupSol.AccountCode__c = '';
                dupSol.AccountCodeType__c = '';
                dupSol.AccountCodeEdit__c = '';
                mapFailureFC.put(dupSol.Id, dupSol.Fail_Code__c);//GSSC-567
                dupSolIdSet.add(dupSol.Id);
            }
            system.debug('duplicateFailureList >>> ' + duplicateFailureList);

            if(duplicateFailureList != null && duplicateFailureList.size() > 0) {
                list<CSS_Parts_Options__c> dupPartsList = [SELECT Id, name, FailurepartId__c, Account_Code__c  FROM CSS_Parts_Options__c WHERE FailurepartId__c IN : dupSolIdSet];

                for(CSS_Parts_Options__c dupParts : dupPartsList) {
                    dupParts.Account_Code__c = '';
                }

                list<CSS_SRT__c> dupSRTList = [SELECT Id, Name, Account_Code__c, Account_Code_Description__c FROM CSS_SRT__c WHERE Component_Id__c IN : dupSolIdSet];

                for(CSS_SRT__c dupSRT : dupSRTList) {
                    dupSRT.Account_Code__c = '';
                    dupSRT.Account_Code_Description__c = '';
                    dupSRT.SRT_Warrantable__c = '0';//Defect 190514
                    //GSSC-567 START
                    if(mapFailureFC != null && dupSRT.Component_Id__c != null){
                        dupSRT.FailCode__c = mapFailureFC.get(dupSRT.Component_Id__c);
                    }
                    //GSSC-567 END
                }

                update duplicateFailureList;

                if(dupPartsList != null && dupPartsList.size() > 0)
                    update dupPartsList;

                if(dupSRTList != null && dupSRTList.size() > 0)
                    update dupSRTList;

            }

            partsListWrap = getListWrap();
            //181525 - Duplicate Failures.
            if(workJob.CSS_Travel_Rate__c=='0'|| string.isBlank(workJob.CSS_Travel_Rate__c) || (string.isBlank(workJob.CSS_In_Shop_Labor_Rate__c) || (string.isNotBlank(workJob.CSS_In_Shop_Labor_Rate__c) && double.valueOf(workJob.CSS_In_Shop_Labor_Rate__c)==0))){
                system.debug('Testing:- FetchSPData Starts here>>>>');
                workJob = CG_BL_Intake.fetchSPData(workJob, workJob.creator_location__c, null, workJob.Failure_Date__c, null);
                checkspdata=true;
            }
            system.debug('workJob>>>>'+workJob);
        }catch(exception e){
            system.debug('exception in jobplanaction with the error ' + e.getMessage() + ' at the line ' + e.getLineNumber());
        }
    }
    /****Method to Update Unit Inbound and WO Inbound*******/
    public CSS_unitInboundJSON2Apex UIResp{get;set;}
    public void callUpdateUnitandWo(){
        try{
            if(workJob.BMSWSStatus__c=='UI'){
                //Call Unit Inbound Webservice
                callUnitInboundGeneric();
                //Call WO Inbound Webservice
                callCreateWoqtInbound('WO');
                workJob.BMSWSStatus__c = '';
                update workJob;

            }
        }catch(exception e){
            system.debug('callUnitInbound-----------'+e.getLineNumber()+e.getMessage());
        }
    }
    public string BMSReferenceNumber;
    public string BMSQuoteNumber;
    public string DefaultInshop;
    public void callCreateWoqtInbound(String OrderType){
        try{
            // String BMSQuoteNumber;
            system.debug('inside');

            system.debug('inside&&&&&$$$$$$$$$$$');
            if(workJob.Repair_Location__c == 'Mobile'){
                DefaultInshop = 'N';
            }else{DefaultInshop = 'Y';}
            datetime currentDate = System.now();
            string currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00';
            //updated as per story 83165 (baby blue)
            //string currDate = currentDate.format('dd-MM-YYYY HH:MM:SS z','GMT') ;
            //Call the WOQT Inbound BMS webservice to get the Quote Number .
            //Modified as per story# 64030
            //CSS_BMSWOQTInboundJSON2APEX woqtRes = CSS_WS_BMS.callBMSWOQTInboundService(workJob.Name,OrderType,workJob.Customer_Code__c,DefaultInshop,currDate,currDate,'Customer',CSS_utility.getSubStringValue(workJob.First_Name__c, 0, 15) + ',' + CSS_utility.getSubStringValue(workJob.BMS_Last_Name__c, 0, 15) ,workJob.Cstmr_Contacts_Phone__c,workJob.Sub_Type__c,workJob.Unit_Number__c,workJob.Model__c,workJob.Make__c,workJob.Service_Model__c,workJob.Qsol_Engine_Family_Code__c,workJob.ESN__c,workJob.Application__c,workJob.Creator_Location__c,(workJob.Contact_ID__c == null ? '' : workJob.Contact_ID__c));
            CSS_BMSWOQTInboundJSON2APEX woqtRes = CSS_WS_BMS.callBMSWOQTInboundService(workJob.Name,OrderType,workJob.Customer_Code__c,DefaultInshop,currDate,currDate,'Customer',CSS_utility.getSubStringValue(workJob.First_Name__c, 0, 15) + ',' + CSS_utility.getSubStringValue(workJob.BMS_Last_Name__c, 0, 15) ,workJob.Cstmr_Contacts_Phone__c,workJob.Sub_Type__c,workJob.Unit_Number__c,workJob.Model__c,workJob.Make__c,workJob.Service_Model__c,workJob.Qsol_Engine_Family_Code__c,workJob.ESN__c,workJob.Application_Desc__c,workJob.Creator_Location__c,(workJob.Contact_ID__c == null ? '' : workJob.Contact_ID__c),(workJob.Email_Address__c == null ? '' : workJob.Email_Address__c),(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'));
            system.debug('woqtRes>>>>>>>>'+woqtRes);
            if(OrderType=='WOQT')
                BMSQuoteNumber = woqtRes.DataArea.WOReferenceNumber;
            else if(OrderType == 'WO'){
                if(woqtRes.DataArea.WOReferenceNumber != null && woqtRes.DataArea.WOReferenceNumber != '0')
                    BMSReferenceNumber = woqtRes.DataArea.WOReferenceNumber;
            }
            system.debug('BMSReferenceNumber>>>>*****'+BMSReferenceNumber);
            //BMSReferenceNumber = workJob.Shop_Work_Order__c;
            system.debug('BMSQuoteNumber>>>>*****'+BMSQuoteNumber);
            if(OrderType == 'WO'){
                if(woqtRes.DataArea !=null && woqtRes.Header!=null && woqtRes.Header.Status!=null && woqtRes.Header.Status=='SUCCESS' && woqtRes.DataArea.WOReferenceNumber != null && woqtRes.DataArea.WOReferenceNumber.trim() != '0')
                {
                    if(workJob.BMSStatus__c !=null && workJob.BMSStatus__c.trim() !=''){
                        workJob.BMSStatus__c = workJob.BMSStatus__c + ','+'WC1';
                    }else {
                        workJob.BMSStatus__c = 'WC1';
                    }
                    system.debug('BMSStatus__c+++++++++++++'+workJob.BMSStatus__c);
                }
                if(woqtRes.Header.Status=='ERROR')
                    workJob.BMSStatus__c = 'WC0';
            }


        }catch(exception ex){
            System.debug('Exception in CSS_WS_BMS.callBMSWOQTInboundService: '+ex.getMessage());
        }
    }
    /******* Call Unit Inbound Generic Method *******/
    public void callUnitInboundGeneric(){
        system.debug('UnitNumber>>>>>'+workJob.Unit_Number__c);
        system.debug('BMSStatus>>>>>>'+workJob.BMSStatus__c);
        if(workJob.Unit_Number__c !=null && !workJob.BMSStatus__c.contains('UI0')){
            //Modified as per story# 64030
            //string applicationCode = css_utility.getCodes('Application Code',workJob.Application__c,null,null);
            string applicationCode = css_utility.getCodes('Application Code',workJob.Application_Desc__c,null,null);
            String FailureDateForUnitInbound;
            if(workJob.Failure_Date__c != null){
                datetime FailureDt = workJob.Failure_Date__c;
                FailureDateForUnitInbound = FailureDt.format('dd-MMM-YYYY','GMT') + ' ' + '13:00:00';
            }
            String WarrantyStartDateforUnitInbound;
            if(workJob.Warranty_Start_Date__c != null){
                datetime WrntyDt = workJob.Warranty_Start_Date__c;
                WarrantyStartDateforUnitInbound = WrntyDt.format('dd-MMM-YYYY','GMT');
            }
            //Call the Unit Inbound Service
            UIResp = new CSS_unitInboundJSON2Apex();
            //making a call to update the details
            UIResp = CSS_WS_BMS.callUnitInbound(workJob.Customer_Code__c,workJob.Unit_Number__c,workJob.Unit_Type__c,workJob.Model__c,workJob.VIN__c,workJob.Make__c,workJob.Service_Model__c,workJob.ESN__c,workJob.Qsol_Engine_Family_Code__c,applicationCode,workJob.Creator_Location__c,workJob.Mileage_Measure__c,string.valueof(workJob.Mileage__c),string.valueof(workJob.CSS_Hours__c),(FailureDateForUnitInbound == null ? '' : FailureDateForUnitInbound),(WarrantyStartDateforUnitInbound == null ? '' : WarrantyStartDateforUnitInbound),workJob.AccessCode__c);
            system.debug('UIResp>>>>>>>>'+UIResp);

            workJob.Unit_Number__c= UIResp.DataArea.UnitNumber;
            if(UIResp.DataArea !=null && UIResp.Header!=null && UIResp.Header.Status!=null && UIResp.Header.Status=='SUCCESS' && UIResp.DataArea.UnitNumber != null && UIResp.DataArea.UnitNumber.trim() != '')
            {
                if(workJob.BMSStatus__c !=null && workJob.BMSStatus__c.trim() !=''){
                    workJob.BMSStatus__c = workJob.BMSStatus__c + ','+'UI0';
                }else {
                    workJob.BMSStatus__c = 'UI0';
                }
                system.debug('BMSStatus__c+++++++++++++'+workJob.BMSStatus__c);
            }

        }
    }
    /******* End Call Unit Inbound Generic Method ****/


    public void Cancel()
    {
        css_job_order__c worecord= new css_job_order__c();
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        if (ChkFieldBlank() =='BLANK')
        {
            /*PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME');
pageRef.setRedirect(true);
return pageRef;*/
        }
        else
        {
            System.Debug('inside cancel');

            //  CSS_JobOrderWrapper wrap = new CSS_JobOrderWrapper(workJob,filterMake,filterModel,mil_measure,fail_measure);
            //   worecord = wrap.worecord;
            //worecord.Location_Certification__c=workjob.Location_Certification__c;
            worecord.Status__c='Canceled';
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;
            // Defect fix 59457
            //saveCheckBox(); commented by Rajesh Narra on 6/22/2018
            if (Wid == null)
            {
                System.Debug('inside CancelNull');
                worecord.jobLocation__c=jobLocation;
                insert worecord;
                Wid = worecord.id;
                /*PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME');
pageRef.setRedirect(true);
return pageRef;*/
                cancelSJWrapperObj1.errorFlag = false;
                cancelSJWrapperObj1.errorMessage = '';
                cancelSJWrapperObj1.serviceJob = worecord;
            }
            else
            {
                System.Debug('value of customer===='+workJob.customer_name__c);
                /*worecord.id=workJob.id;
update worecord;
System.Debug('inside CancelBlank====='+worecord);
PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME');
pageRef.setRedirect(true);
return pageRef;*/
                system.debug('insideelseNoSWO');
                system.debug('** ERP System'+workJob.Account__r);
                system.debug('** erp sys 111'+workJob.Account__r.ERP_System__c);
                if(workJob.Account__r.ERP_System__c == 'One BMS'){
                    cancelSJWrapperObj1 = CG_BL_Intake.cancel(workJob,worecord);
                    //Defect Fix 151641
                    if(cancelSJWrapperObj1!=null && cancelSJWrapperObj1.errorFlag == false){
                        system.debug('**noerrors');
                        worecord.id=workJob.id;
                        Update worecord;
                    }
                }
                else{
                    worecord.id=workJob.id;
                    update worecord;
                    cancelSJWrapperObj1.errorFlag = false;
                    cancelSJWrapperObj1.errorMessage = '';
                    cancelSJWrapperObj1.serviceJob = worecord;
                }

                //Wid = cancelSJWrapperObj1.serviceJob.id;
                system.debug('cancelSJWrapperObj1.serviceJob.id'+cancelSJWrapperObj1.serviceJob.id);
            }

            saveCheckBox();
        }

    }

    public PageReference saveAndCloseJob()
        //void to  PageReference switch is done by  Roopa defect number 178147
    {
        // if(dsidIndi != null && dsidIndi.containsIgnoreCase('O'))
        if (Wid != null)
        {
            requiredBMSMessage =false;
            showResolutionRequired =false;//ROD Defect 179167 Added by Rajesh Narra                                    
            showResolutionWithRepair = false;//ROD Defect 179167 Added by Rajesh Narra                        
            showRepairRequired = false;//ROD Defect 179167 Added by Rajesh Narra 
            if ((bmsEnabled ==true)&&(workJob.Customer_Code__c==null || workJob.Unit_Number__c==null || workJob.Shop_Work_Order__c==null)){
                requiredBMSMessage = TRUE;
                System.debug('Entered error');            
                return null;
            }
            css_accessSrtCompOutTo_Eds updateEDS = new css_accessSrtCompOutTo_Eds(solutionIds,workjob.DSID__c);
            //system.debug('checkingownerornot----->'+dsidIndi);
            System.debug('Entered Pg SaveFinish MEthod');
            css_dsidclose dscl = new css_dsidclose();
            //PageReference pageRef;
            System.debug('41');
            System.debug('requiredBMSMessage  ' + requiredBMSMessage);
            if(showRepairs  && !showResolutionWithRepair){
                System.debug('42');
                list<CSS_Solutions__c> negatRepairs = new list<CSS_Solutions__c>();
                List<CSS_Solutions__c> negatPosRepairs = new List<CSS_Solutions__c>();
                System.debug('43');
                if(!responseValues.isEmpty()){
                    System.debug('44');
                    for(CSS_Solutions__c solRec : responseValues){
                        System.debug('45');

                        if(!String.isBlank(solRec.Repair_Response__c) && !solRec.Repair_Response__c.contains('Successful')){
                            System.debug('46');
                            System.debug('Entered neg if Loop:');
                            negatRepairs.add(solRec);
                            System.debug('47');
                        }else if(solRec.Repair_Response__c != null && solRec.Repair_Response__c.contains('Successful')){
                            negatPosRepairs.add(solRec);
                        }else if(solRec.Repair_Response__c == null){
                            System.debug('48');
                            //showRepairErrorMessage = TRUE; ROD Defect 179167 Added by Rajesh Narra 
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please select repair response for the below solutions'));
                            //return null;
                        }
                    }//end of For
                    System.debug('B4 MEthod'+negatRepairs+' '+responseValues+''+negatRepairs.size()+' '+responseValues.size());

                    if(negatRepairs.isEmpty() && negatPosRepairs.isEmpty()){
                        showRepairRequired = false;//ROD Defect 179167 Added by Rajesh Narra 
                        showRepairErrorMessage = True;
                        cancelSJWrapperObj1.errorFlag=true;//ROD Defect 179167 Added by Rajesh Narra 
                    }else if(!negatRepairs.isEmpty() && !responseValues.isEmpty() && negatRepairs.size() == responseValues.size() && workJob.CSS_Resolution__c == null){
                        showRepairRequired = true;///ROD Defect 179167 Added by Rajesh Narra 
                        showRepairErrorMessage = false;
                        cancelSJWrapperObj1.errorFlag=true;//ROD Defect 179167 Added by Rajesh Narra 
                        showResolutionWithRepair=true;//ROD Defect 179167 Added by Rajesh Narra 
                    }else if(!negatPosRepairs.isEmpty() && !responseValues.isEmpty() && negatPosRepairs.size() != responseValues.size() && workJob.CSS_Resolution__c == null){
                        showRepairRequired = true;//ROD Defect 179167 Added by Rajesh Narra 
                        showRepairErrorMessage = false;
                        cancelSJWrapperObj1.errorFlag=true;//ROD Defect 179167 Added by Rajesh Narra 
                        showResolutionWithRepair=true;//ROD Defect 179167 Added by Rajesh Narra 
                    }else{
                        System.debug('50');
                        System.debug('Entered else Loop with repairs:');

                        showResolutionWithRepair = FALSE;
                        if(requiredBMSMessage == TRUE){
                            showRepairErrorMessage = FALSE;
                        }
                        cancelSJWrapperObj1.errorFlag=false;//ROD Defect 179167 Added by Rajesh Narra 
                        workJob.Status__c='Closed';
                        System.debug('51');
                        updateEDS.accessSRTs();
                        updateEDS.solComponents();
                        updateEDS.outOfOrder(outOfOrderSolList);
                        updateEDS.insiteFaultCodes(fauCod,workjob.DSID__c);
                        dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                        if(dsidStatus) {
                            workJob.DSID_Status__c='Closed';
                        }                         
                        if(workJob.Account__r.ERP_System__c=='One BMS'){
                            cancelSJWrapperObj1 = CG_BL_Intake.closeServiceJob(workJob);
                            if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == true){

                            }
                            else if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == false){
                                system.debug('**noerrors');
                                update workJob;
                            }
                        }
                        else{
                            if(requiredBMSMessage == false)//ROD Defect 179167 Added by Rajesh Narra 
                                update workJob;
                        }
                        if(!responseValues.isEmpty() && requiredBMSMessage == false){ //ROD Defect 179167 Added by Rajesh Narra 
                            update responseValues;
                        }
                        if(requiredBMSMessage == false){
                            cancelSJWrapperObj1.errorFlag=false;// Added by Rajesh Narra
                            pageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); // This code is uncommented by Roopa  178147
                            pageRef.setRedirect(true);// This code is uncommented by Roopa  178147
                        }else{
                            if(requiredBMSMessage == TRUE)
                                showRepairErrorMessage = TRUE;
                            cancelSJWrapperObj1.errorFlag=true;
                        }               
                    }
                }
            }//end of If repairs

            if(!postRepairList.isEmpty()){
                System.debug('52');
                showResolution = false;
                showRepairs = false;
                if(!showResolutionWithRepair || !showResolution){
                    if(workJob.CSS_Resolution__c != null){ 
                        System.debug('53');
                        workJob.Status__c='Closed';
                        updateEDS.accessSRTs();
                        updateEDS.solComponents();
                        updateEDS.outOfOrder(outOfOrderSolList);
                        updateEDS.insiteFaultCodes(fauCod,workjob.DSID__c);
                        dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                        if(dsidStatus) {
                            workJob.DSID_Status__c='Closed';
                        } 
                        if(workJob.Account__r.ERP_System__c=='One BMS'){
                            cancelSJWrapperObj1 = CG_BL_Intake.closeServiceJob(workJob);
                            if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == true){

                            }
                            else if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == false){
                                system.debug('**noerrors');
                                update workJob;
                            }
                        }
                        else{
                            update workJob; 
                        }                        
                        if(!responseValues.isEmpty()){
                            System.debug('54');
                            update responseValues;
                        } 
                        pageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); // This code is uncommented by Roopa  178147
                        pageRef.setRedirect(true);// This code is uncommented by Roopa  178147
                    }
                }    
            }

            if(showResolutionWithRepair || showResolution){
                System.debug('55');
                if(workJob.CSS_Resolution__c != null){     
                    System.debug('56');
                    workJob.Status__c='Closed';
                    updateEDS.insiteFaultCodes(fauCod,workjob.DSID__c);
                    updateEDS.accessSRTs();
                    updateEDS.solComponents();
                    updateEDS.outOfOrder(outOfOrderSolList);
                    dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                    System.debug('57');
                    if(dsidStatus) {
                        workJob.DSID_Status__c='Closed';                        
                    } 
                    if(workJob.Account__r.ERP_System__c=='One BMS'){
                        cancelSJWrapperObj1 = CG_BL_Intake.closeServiceJob(workJob);
                        if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == true){

                        }
                        else if(cancelSJWrapperObj1 != null && cancelSJWrapperObj1.errorFlag == false){
                            system.debug('**noerrors');
                            update workJob;
                        }
                    }
                    else{
                        if(requiredBMSMessage == false)//ROD Defect 179167 Added by Rajesh Narra 
                            update workJob;    
                    }                    
                    if(!responseValues.isEmpty() && requiredBMSMessage == false){//ROD Defect 179167 Added by Rajesh Narra 
                        System.debug('58');
                        update responseValues;
                    }
                    if(requiredBMSMessage == false){
                        cancelSJWrapperObj1.errorFlag=false;//ROD Defect 179167 Added by Rajesh Narra 
                        pageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); // This code is uncommented by Roopa  178147
                        pageRef.setRedirect(true);// This code is uncommented by Roopa  178147
                    }else{
                        cancelSJWrapperObj1.errorFlag=true;
                    }
                }else{
                    showResolutionRequired=true;//ROD Defect 179167 Added by Rajesh Narra                     
                    cancelSJWrapperObj1.errorFlag=true;//ROD Defect 179167 Added by Rajesh Narra 
                }
            }    

            System.Debug('record updated====='+workJob);            
            return null;
            //return pageRef;// This code is uncommented by Roopa  178147
        }
        else{ 
            return null; // This code is uncommented by Roopa  178147
        }   
    }   

    //method for Job Plan Quote Cheveron
    public PageReference jobplan_jpq(){
        css_job_order__c worecord= new css_job_order__c();
        /*if (ChkFieldBlank() =='BLANK'){
return null;
}
else{*/
        if(checkspdata && workJob != null){
            //if( && workJob.CSS_Travel_Rate__c != null && workJob.CSS_Travel_Rate__c != '')
                worecord.CSS_Travel_Rate__c = workJob.CSS_Travel_Rate__c;
            //if(workJob != null && workJob.CSS_Travel_Rate__c != null && workJob.CSS_Travel_Rate__c != '')
            worecord.CSS_In_Shop_Labor_Rate__c = workJob.CSS_In_Shop_Labor_Rate__c;
        }
        if(workJob != null) { 
            worecord.chevron_page__c = 'jpq';
            worecord.BMSWSStatus__c = workJob.BMSWSStatus__c;
            worecord.Unit_Number__c = workJob.Unit_Number__c;
            worecord.SPDataWebserviceResult__c = workJob.SPDataWebserviceResult__c;
            if (Wid != null){
                worecord.id=workJob.id;
                update worecord;
            }
        }
        //}
        CG_CL_CoverageLimitExceedValidation contr = new CG_CL_CoverageLimitExceedValidation();
        contr.covLimitValidation(Wid, null, null, null);
        contr.covLimitValidationJob(Wid, null);  //Added as part of the story GSSC-50
        PageReference pageRef = new pageReference('/apex/CSS_JobPlanQuote?id='+worecord.id);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public CSS_Solution_Component__c solCompRec {get;set;}
    public String accCodeWS {get;set;}
    public Boolean showDisabledAC {get;set;}
    public Boolean showEditLink {get;set;}
    public void partssave(){
        try{
            system.debug('****insidepartssave***');
            system.debug('componentId-->'+componentId);
            system.debug('failCodeSelected-->'+failCodeSelected);
            system.debug('accCodeSelected-->'+accCodeSelected);

            String systemCode;
            String compCode;
            String selectedFailCodeMod;
            CSS_Solution_Component__c compToUpdate = new CSS_Solution_Component__c();

            selectedFailCodeMod = failCodeSelected.right(4);
            if(selectedFailCodeMod != null && selectedFailCodeMod != ''){
                systemCode = selectedFailCodeMod.left(2);
                compCode =  selectedFailCodeMod.right(2);
            }

            solCompRec = [SELECT Id, solutions__r.FaultCode__c,AccountCode__c,Selected_Component__c FROM CSS_Solution_Component__c WHERE Id =: componentId];

            //calling Get Warranty determination web service
            system.debug('workjobESN-->'+workJob.ESN__c);
            system.debug('creator loc-->'+(workJob.Creator_Location__c).right(5));
            system.debug('failuredate-->'+workJob.Failure_Date__c);
            system.debug('failurepoint-->'+string.valueof(workJob.Failure_Point__c));
            system.debug('failurepointmeasure-->'+workJob.Failure_Point_Measure__c);
            system.debug('appcode-->'+workJob.ApplicationCode__c);
            system.debug('warrantystartdate-->'+workJob.Warranty_Start_Date__c);
            system.debug('systemCode-->'+systemCode);
            system.debug('compCode-->'+compCode);
            system.debug('faultcode-->'+solCompRec.solutions__r.FaultCode__c);
            system.debug('aaccountcode-->'+solCompRec.AccountCode__c);
            system.debug('componentId-->'+componentId);
            system.debug('selcomp-->'+solCompRec.Selected_Component__c);
            if(workJob.ApplicationCode__c=='130' || workJob.ApplicationCode__c=='210' || workJob.ApplicationCode__c=='220' || workJob.ApplicationCode__c=='310' || workJob.ApplicationCode__c=='320' || workJob.ApplicationCode__c=='410'){
                system.debug('workJob.ApplicationCode__c'+workJob.ApplicationCode__c);
                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workJob.Failure_Date__c,string.valueof(workJob.Mileage__c),workJob.Mileage_Measure__c,workJob.ApplicationCode__c,workJob.Warranty_Start_Date__c,systemCode,compCode,solCompRec.solutions__r.FaultCode__c,solCompRec.AccountCode__c,componentId,solCompRec.Selected_Component__c,'','','Second Call', workjob.ReconEngineFlag__c, false,workJob.Name);
            }
            else{
                system.debug('*****elseApplicationCode__c***** ');
                compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workJob.Failure_Date__c,string.valueof(workJob.CSS_Hours__c),'Hours',workJob.ApplicationCode__c,workJob.Warranty_Start_Date__c,systemCode,compCode,solCompRec.solutions__r.FaultCode__c,solCompRec.AccountCode__c,componentId,solCompRec.Selected_Component__c,'','','Second Call', workjob.ReconEngineFlag__c, false,workJob.Name);
            }


            // compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workJob.Failure_Date__c,string.valueof(workJob.Failure_Point__c),workJob.Failure_Point_Measure__c,workJob.ApplicationCode__c,workJob.Warranty_Start_Date__c,systemCode,compCode,solCompRec.solutions__r.FaultCode__c,solCompRec.AccountCode__c,componentId,solCompRec.Selected_Component__c,'','','Second Call', workjob.ReconEngineFlag__c, false);

            //system.debug('AccCodeEdit**'+compToUpdate.AccountCodeEdit__c);
            if(compToUpdate != null)
                compToUpdate.Fail_Code_Editable__c = failCodeSelected;
                
            if(compToUpdate != null && compToUpdate.AccountCodeType__c != '' && compToUpdate.AccountCode__c != ''){
                //accCodeWS = (compToUpdate.AccountCodeType__c.subStringAfter('-') + ' ' + compToUpdate.AccountCode__c).Trim();
                accCodeSelected = (compToUpdate.AccountCodeType__c.subStringAfter('-') + ' ' + compToUpdate.AccountCode__c).Trim();
                //accCodeSelected = '';
                system.debug('ONE');
            }
            if(compToUpdate != null && compToUpdate.AccountCodeEdit__c!=null && compToUpdate.AccountCodeEdit__c != ''){ //Kalpana story#117207
                //accCodeWS = compToUpdate.AccountCodeEdit__c.Trim();
                accCodeSelected = compToUpdate.AccountCodeEdit__c.Trim();
                coverageType = '';

                //accCodeSelected = '';
                system.debug('TWO');
            }
            else{
                accCodeWS = '';
                system.debug('THREE');
                accCodeSelected = '';
                //getAccountCodes();
            }
            if(accCodeWS != null && compToUpdate != null)
                compToUpdate.AccountCodeEdit__c = '';
            if(compToUpdate != null && compToUpdate.AccountCode_Call_Status__c != null && compToUpdate.AccountCode_Call_Status__c == 'Failure'){
                warrantyCompFailure = false;
                showDisabledAC = false;
            }
            else{
                warrantyCompFailure = true;
                showDisabledAC = true;
            }

            system.debug('*****compwarrntystatus****'+compToUpdate.AccountCode_Call_Status__c);
            system.debug('****warrantyCompFailure****'+warrantyCompFailure);
            system.debug('accCodeSelected--'+accCodeSelected);
            // update compToUpdate;
            accCodeSelected = accCodeSelected.trim();
            if(accCodeSelected != null && accCodeSelected != ''){
                if(accCodes == null)
                    accCodes = new List<SelectOption>();
                accCodes.add(new SelectOption(accCodeSelected,accCodeSelected));
                accCodes.remove(0);
                accCodes.sort();
                accCodes.add(0,(new SelectOption('Select one','Select One')));
            }
            showEditLink = true;
            // getAccountCodes();
            PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl().substringBefore('?')+'?id='+workJob.Id);
            ReturnPage.setRedirect(true);
        }

        catch(exception e){
            system.debug('inside partssave exception -->'+ e.getmessage() + e.getLineNumber());
        }
    }

    //Below method is added to retry the warranty webservice if any of the displayed solution component's accountcode status is failure(User story 115653)
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
            warrantyFailureSolCompList = [select Id, Type__c, SysCodeAndCompCode__c, System_Code__c, Component_Code__c, Fail_Code_Editable__c, AccountCode__c, Selected_Component__c, name,Component_Id__c,Solutions__c,Service_Job__c,AccountCode_Call_Status__c,solutions__r.FaultCode__c from CSS_Solution_Component__c where Service_Job__c=:Wid and AccountCode_Call_Status__c = 'Failure' and (AccountCode__c = '' or AccountCode__c = null)];
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

                    system.debug('***inside forretry***');
                    system.debug('workjobESN-->'+workJob.ESN__c);
                    system.debug('creator loc-->'+(workJob.Creator_Location__c).right(5));
                    system.debug('failuredate-->'+workJob.Failure_Date__c);
                    system.debug('failurepoint-->'+string.valueof(workJob.Failure_Point__c));
                    system.debug('failurepointmeasure-->'+workJob.Failure_Point_Measure__c);
                    system.debug('appcode-->'+workJob.ApplicationCode__c);
                    system.debug('warrantystartdate-->'+workJob.Warranty_Start_Date__c);
                    system.debug('systemCode-->'+systemCode);
                    system.debug('compCode-->'+compCode);
                    system.debug('faultcode-->'+solComp.solutions__r.FaultCode__c);
                    system.debug('aaccountcode-->'+solComp.AccountCode__c);
                    system.debug('componentId-->'+componentId);
                    system.debug('selcomp-->'+solComp.Selected_Component__c);



                    if(solComp.Type__c != null && solComp.Type__c != ''){
                        if(workJob.ApplicationCode__c=='130' || workJob.ApplicationCode__c=='210' || workJob.ApplicationCode__c=='220' || workJob.ApplicationCode__c=='310' || workJob.ApplicationCode__c=='320' || workJob.ApplicationCode__c=='410'){
                            system.debug('****Enter ApplicationCode__c****');
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workJob.Failure_Date__c,string.valueof(workJob.Mileage__c),workJob.Mileage_Measure__c,workJob.ApplicationCode__c,workJob.Warranty_Start_Date__c,systemCode,compCode,solComp.solutions__r.FaultCode__c,solComp.AccountCode__c,solComp.Id,solComp.Selected_Component__c,solComp.Component_Id__c,'','Second Call', workjob.ReconEngineFlag__c, false,workJob.Name);
                        }
                        else{

                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workJob.Failure_Date__c,string.valueof(workJob.CSS_Hours__c),'Hours',workJob.ApplicationCode__c,workJob.Warranty_Start_Date__c,systemCode,compCode,solComp.solutions__r.FaultCode__c,solComp.AccountCode__c,solComp.Id,solComp.Selected_Component__c,solComp.Component_Id__c,'','Second Call', workjob.ReconEngineFlag__c, false, workJob.Name);
                        }
                        // compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workJob.Failure_Date__c,string.valueof(workJob.Failure_Point__c),workJob.Mileage_Measure__c,workJob.ApplicationCode__c,workJob.Warranty_Start_Date__c,systemCode,compCode,solComp.solutions__r.FaultCode__c,solComp.AccountCode__c,solComp.Id,solComp.Selected_Component__c,solComp.Component_Id__c,'','Second Call', workjob.ReconEngineFlag__c, false);
                    }
                    else{
                        if(workJob.ApplicationCode__c=='130' || workJob.ApplicationCode__c=='210' || workJob.ApplicationCode__c=='220' || workJob.ApplicationCode__c=='310' || workJob.ApplicationCode__c=='320' || workJob.ApplicationCode__c=='410'){

                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workJob.Failure_Date__c,string.valueof(workJob.Mileage__c),workJob.Mileage_Measure__c,workJob.ApplicationCode__c,workJob.Warranty_Start_Date__c,systemCode,compCode,solComp.solutions__r.FaultCode__c,solComp.AccountCode__c,solComp.Id,solComp.Selected_Component__c,'','','Second Call', workjob.ReconEngineFlag__c, false,workJob.Name);
                        }
                        else{
                            system.debug('****Else ApplicationCode__c****');
                            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workJob.Failure_Date__c,string.valueof(workJob.CSS_Hours__c),'Hours',workJob.ApplicationCode__c,workJob.Warranty_Start_Date__c,systemCode,compCode,solComp.solutions__r.FaultCode__c,solComp.AccountCode__c,solComp.Id,solComp.Selected_Component__c,'','','Second Call', workjob.ReconEngineFlag__c, false,workJob.Name);
                        }
                        // compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),workJob.Failure_Date__c,string.valueof(workJob.Failure_Point__c),workJob.Mileage_Measure__c,workJob.ApplicationCode__c,workJob.Warranty_Start_Date__c,systemCode,compCode,solComp.solutions__r.FaultCode__c,solComp.AccountCode__c,solComp.Id,solComp.Selected_Component__c,'','','Second Call', workjob.ReconEngineFlag__c, false);
                    }
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
            system.debug('partsWarranty--'+partsWarranty);
            system.debug('custSelect--'+custSelect);
            system.debug('failureMeasure--'+failureMeasure);
            system.debug('failCode-->'+failCodeSelected);
            system.debug('faultCode'+faultCode);
            system.debug('componentId--'+componentId);
            //system.debug('***Application__c***'+workjob.Application__c);
            //system.debug('***ApplicationCode__c***'+workjob.ApplicationCode__c);
            system.debug('SysCode:'+selectedSysCode);
            system.debug('CompCode:'+selectedCompCode);
            partcoverageFound='';
            chkClickonPartsCoverage = true;
            CSS_Solution_Component__c compToUpdate = new CSS_Solution_Component__c();

            String selectedFailCodeMod;
            String sysCode;
            String componentCode;

            if(selectedSysCode != null && selectedSysCode != '')
                sysCode = selectedSysCode.left(2);
            if(selectedCompCode != null && selectedCompCode != '')
                componentCode =  selectedCompCode.left(2);

            if(compont != null && compont.Failure_Measure__c == null || compont.Failure_Measure__c=='')
                compont.Failure_Measure__c = 'Miles';   //commented and covered above as per story #182800
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
                failureDate = workjob.Failure_Date__c;

            String tempAC;
            if(accCodeSelected != null && accCodeSelected != '' && accCodeSelected != 'Select One'){
                tempAC = accCodeSelected.RIGHT(2);
            }
            else{
                tempAC = '';
            }
            if(failureMeasure==null || failureMeasure==''){
                failureMeasure = 'Miles';
            }
            system.debug('failureMeasure@@@'+failureMeasure);
            //182800
            //if(workJob.ApplicationCode__c=='130' || workJob.ApplicationCode__c=='210' || workJob.ApplicationCode__c=='220' || workJob.ApplicationCode__c=='310' || workJob.ApplicationCode__c=='320' || workJob.ApplicationCode__c=='410'){

            // compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),failureDate,
            // string.valueof(compont.Failure_Point__c),compont.Failure_Measure__c, workJob.ApplicationCode__c,compont.Part_Warranty_Start_Date__c,sysCode,componentCode,faultCode,tempAC,componentId,compont.Selected_Component__c,'',partsWarranty,'Second Call', workjob.ReconEngineFlag__c, false, workJob.Name);
            compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),failureDate,
                                                                   string.valueof(compont.Failure_Point__c),failureMeasure, workJob.ApplicationCode__c,compont.Part_Warranty_Start_Date__c,sysCode,componentCode,faultCode,tempAC,componentId,compont.Selected_Component__c,'',partsWarranty,'Second Call', workjob.ReconEngineFlag__c, false, workJob.Name);

            /*}
else{
compToUpdate = CSS_FN_SIEBEL.getWarrantyDetailCoverage(workJob.ESN__c,(workJob.Creator_Location__c).right(5),failureDate,
string.valueof(workJob.CSS_Hours__c),'Hours', workJob.ApplicationCode__c,compont.Part_Warranty_Start_Date__c,sysCode,componentCode,faultCode,tempAC,componentId,compont.Selected_Component__c,'',partsWarranty,'Second Call', workjob.ReconEngineFlag__c, false);
}*/
            // 182800 end

            //Added for Inside Out Sprint #183076 -- Rajasekhar H//
            system.debug('compToUpdate--'+compToUpdate);
            if(compToUpdate!=null && compToUpdate.AccountCode_Call_Status__c != null && compToUpdate.AccountCode_Call_Status__c != 'Failure')
                warrantyDetError=false;
            else
                warrantyDetError=true;
            //End

            if(compToUpdate != null && compToUpdate.AccountCode_Call_Status__c != null && compToUpdate.AccountCode_Call_Status__c == 'Failure'){
                warrantyCompFailure = true;
            }
            else{
                warrantyCompFailure = false;
                if(compToUpdate!=null && compToUpdate.AccountCode__c != null && compToUpdate.AccountCode__c != '' && ((compToUpdate.CoveredLaborHrs__c != '' && compToUpdate.CoveredLaborHrs__c != '0') ||
                                                                                                                      (compToUpdate.CoveredMealsLodgingAmt__c != '' && compToUpdate.CoveredMealsLodgingAmt__c != '0') ||
                                                                                                                      (compToUpdate.CoveredOCAmount__c != '' && compToUpdate.CoveredOCAmount__c != '0') ||
                                                                                                                      (compToUpdate.CoveredPartsQty__c != '' && compToUpdate.CoveredPartsQty__c != '0') ||
                                                                                                                      (compToUpdate.CoveredTowingMiles__c != '' && compToUpdate.CoveredTowingMiles__c != '0') ||
                                                                                                                      (compToUpdate.CoveredTravelLabor__c != '' && compToUpdate.CoveredTravelLabor__c != '0') ||
                                                                                                                      (compToUpdate.CoveredTravelMiles__c != '' && compToUpdate.CoveredTravelMiles__c != '0'))){
                    partcoverageFound = 'true';

                    compToUpdate.AccountCodeEdit__c = compToUpdate.AccountCodeEdit__c.trim();
                    if(compToUpdate != null && compToUpdate.AccountCodeEdit__c != '')
                        accCodeSelected = compToUpdate.AccountCodeEdit__c;
                }
                else{
                    partcoverageFound = 'false';
                    if(custSelect == 'Yes'){
                        if(compToUpdate != null){
                            compToUpdate.AccountCodeEdit__c = '';
                        }
                    }
                    else{
                        if(partsWarranty == 'New Parts Warranty'){
                            if(compToUpdate != null){
                                compToUpdate.AccountCodeEdit__c = 'PARTS WARRANTY 35';
                            }
                        }
                        else{
                            if(compToUpdate != null){
                                compToUpdate.AccountCodeEdit__c = 'RECON STOCK PART 41';
                            }
                        }
                    }
                }
            }
        }
        catch(Exception ex){
            system.debug('Catch Check Coverage'+ ex.getmessage()+' '+ex.getLineNumber());
        }

        system.debug('compToUpdate--'+warrantyDetError);
    }

    public void clearPopup(){
        partsWarranty = '';
        custSelect = '';

        failureMeasure = '';
        if(compont != null){
            compont.Part_Warranty_Start_Date__c = null;
            compont.Failure_Date__c = null;
            compont.Failure_Point__c = null;
            compont.Authorization_Number__c = null;
            authNumbers=null;
            compont.Approval_Code__c = null;
            compont.Pay_Code__c = null;}
        workjob.Failure_Date__c = null;
        coverageFound = null;
        partcoverageFound = '';
        getCoverageType();


        //kalpana 146126
        AuthorizationNumber = '';
        ApprovalCode = '';
        blankField=false;
        invalidAppCode = 'false';
        solCompExistsFlag = 'false';
        dateErrFlag = false;
        higherdateErrFlag = false;
        failureDate=null;
        FCErrorval = false;
        invalidFailure =false;
        invalidCustFailure = false;
        invalidSysCode=false;
        invalidCompCode=false;
        invalidFailMode=false;
        invalidFaultCode=false;
    }
    public void getCoverageType(){
        /*String Querystr;
String QueryAccCode;
if(accCodeSelected != 'Select One' && accCodeSelected != '') {
Querystr = accCodeSelected.right(2);
Querystr = Querystr.trim();
Integer intIndex = accCodeSelected.indexOf(Querystr);
QueryAccCode = accCodeSelected.left(intIndex);
QueryAccCode = QueryAccCode.trim();
system.debug('AccountCode*'+QueryAccCode);
system.debug('intIndex*'+intIndex);
}
system.debug('QueryString**'+Querystr);*/
        ProfileName = [SELECT Name FROM Profile WHERE Id=:userInfo.getProfileId() LIMIT 1].Name;
        system.debug('ProfileName**'+ProfileName);
        //if(Querystr != null){
        if(accCodeSelected != null){
            try{
                //coverageType = [select Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' and Attribute2__c = :QueryAccCode and Attribute3__c = :Querystr].Attribute1__c;
                coverageType = [select Id, Attribute1__c, Attribute2__c, Attribute3__c, Attribute5__c, Key__c from CSS_JobEventTemporary__c where Key__c = 'AccountCodes' and Account_Code__c = :accCodeSelected limit 1].Attribute1__c;
                system.debug('CoverageType**'+coverageType);
            }
            catch(exception ex){
                coverageType = '';
            }
        }
        else
            coverageType = '';
    }
    public string SuccessNDErrorMsg{get;set;}
    public CSS_Job_Order__c sJob;// = new CSS_Job_Order__c();
    //SendFailure to ERP
    public void SendFailurestoERP(){

        //CG_BL_ODM

        //Call ODM Header Validation Service
        /*  CG_BL_ODM.callODMHeaderValidationService(workJob,null,null,'JOB',compRepList);

//Call ODM Failure Validation Service
CG_BL_ODM.callODMFailureValidationService(workJob,null,null,'JOB',compRepList); */
        //Added the ODM Status ODM_Status__c in the query by Rajesh Narra
        List<CSS_Solution_Component__c> LstSolComp=[select id,name,system_code__c,action__c,Component_Id__c,Claim_Type__c,ODM_Status__c,Create_User__c,Customer_Take_Possession__c,Change_User__c,
                                                    Component_Code__c,RoadRelay_Warranty__c,CSS_Account_Formula__c,Selected_Component__c,Solutions__c,Quantity__c,Service_Job__c,Fail_Code__c,Fail_Code_Editable__c,
                                                    AccountCodeEdit__c,AccountCode__c,AccountCodeType__c,Authorization_Number__C,Approval_Code__c,Pay_Code__c,CSS_CoverageType__c,
                                                    Failure_Date__c,Part_Warranty_Start_Date__c,Parts_Warranty__c,Failure_Measure__c,Failure_Point__c,Failure_Mode__c, Selected_Claim_Type__c from CSS_Solution_Component__c where Service_Job__r.name=:workJob.name AND ((Type__c != null AND Performed_Review__c = true) OR (Type__c = null AND Selected_Component__c = true))];
        //Call ODM Header Validation Service
        boolean headerValidation = CG_BL_ODM.callODMHeaderValidationService(workJob,null,null,'JOB',LstSolComp,'JobPlanOverview');

        //Call ODM Failure Validation Service
        boolean FailureValidation =CG_BL_ODM.callODMFailureValidationService(workJob,null,null,'JOB',LstSolComp,'JobPlanOverview');

        SuccessNDErrorMsg ='';
        BMSQuoteNumber ='';
        if(workJob.Repair_Location__c == 'Mobile'){
            DefaultInshop = 'N';
        }else{DefaultInshop = 'Y';}
        datetime currentDate = System.now();
        string currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00';

        if(headerValidation == false && FailureValidation == false){
            if(workJob.Quote_ID__c == null){
                CSS_BMSWOQTInboundJSON2APEX woqtRes;
                If(!Test.isRunningTest())
                    woqtRes = CSS_WS_BMS.callBMSWOQTInboundService(workJob.Name,'WOQT',workJob.Customer_Code__c,DefaultInshop,currDate,currDate,'Customer',CSS_utility.getSubStringValue(workJob.First_Name__c, 0, 15) + ',' + CSS_utility.getSubStringValue(workJob.BMS_Last_Name__c, 0, 15) ,workJob.Cstmr_Contacts_Phone__c,workJob.Sub_Type__c,workJob.Unit_Number__c,workJob.Model__c,workJob.Make__c,workJob.Service_Model__c,workJob.Qsol_Engine_Family_Code__c,workJob.ESN__c,workJob.Application_Desc__c,workJob.Creator_Location__c,(workJob.Contact_ID__c == null ? '' : workJob.Contact_ID__c),(workJob.Email_Address__c == null ? '' : workJob.Email_Address__c),(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'));
                Else
                    woqtRes = CSS_WS_BMS.callBMSWOQTInboundService(workJob.Name,'WOQT',workJob.Customer_Code__c,DefaultInshop,currDate,currDate,'Customer',CSS_utility.getSubStringValue(workJob.First_Name__c, 0, 15) + ',' + CSS_utility.getSubStringValue(workJob.BMS_Last_Name__c, 0, 15) ,workJob.Cstmr_Contacts_Phone__c,workJob.Sub_Type__c,workJob.Unit_Number__c,workJob.Model__c,workJob.Make__c,workJob.Service_Model__c,workJob.Qsol_Engine_Family_Code__c,workJob.ESN__c,workJob.Application_Desc__c,workJob.Creator_Location__c,(workJob.Contact_ID__c == null ? '' : workJob.Contact_ID__c),(workJob.Email_Address__c == null ? '' : workJob.Email_Address__c),'Test User','Test User');
                system.debug('woqtRes>>>>>>>>'+woqtRes);
                BMSQuoteNumber = woqtRes.DataArea.WOReferenceNumber;

            }

            //List<CSS_Solution_Component__c> LstSolComp=[select id,name,system_code__c,Claim_Type__c,Create_User__c,Change_User__c,Component_Code__c,Failure_Mode__c, Selected_Claim_Type__c from CSS_Solution_Component__c where Service_Job__r.name=:workJob.name AND (Type__c != null OR (Type__c = null AND Selected_Component__c = true))];
            //Replaced Performed__c with Performed_Review__c in the query by Rajesh Narra to send only the selected failures to the ERP system
            //List<CSS_Solution_Component__c> LstSolComp=[select id,name,system_code__c,Claim_Type__c,Create_User__c,Change_User__c,Component_Code__c,Failure_Mode__c, Selected_Claim_Type__c from CSS_Solution_Component__c where Service_Job__r.name=:workJob.name AND ((Type__c != null AND Performed_Review__c = true) OR (Type__c = null AND Selected_Component__c = true))];

            //List<CSS_Solution_Component__c> LstSolComp=[select id,name,system_code__c,Claim_Type__c,Create_User__c,Change_User__c,Component_Code__c,Failure_Mode__c,AccountCode__c,Pay_Code__c,Service_Job__r.ESN__c,CertificateNumber__c, Authorization_Number__c, Failure_Date__c,Service_Job__r.Warranty_Start_Date__c,Service_Job__r.Service_Model_N__c,Service_Job__r.Make__c,Service_Job__r.Model__c,Service_Job__r.Unit_Type__c,Service_Job__r.ApplicationCode__c, Service_Job__r.Mileage__c,Service_Job__r.Miles_or_Km__c,Service_Job__r.CSS_Hours__c,Approval_Code__c,Service_Job__r.DistributorCode__c, Selected_Claim_Type__c from CSS_Solution_Component__c where Service_Job__r.name=:workJob.name AND ((Type__c != null AND Performed_Review__c = true) OR (Type__c = null AND Selected_Component__c = true))];

            if(LstSolComp != null && LstSolComp.size()>0){
                sendfailtoERP=true;
            }
            else
                sendfailtoERP=false;



            System.debug('=======> Solution Components List==>' +LstSolComp);
            // list<CSS_Solution_Component__c> SolCompCampTRP = [select id,name,system_code__c,Claim_Type__c,Create_User__c,Change_User__c,Component_Code__c,Failure_Mode__c from CSS_Solution_Component__c where Type__c in ('Campaign', 'TRP', 'ATC') and Service_Job__c =:wid and Performed_Review__c = true and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))];
            CG_OP_OAGWrapper failureres = CG_SL_BMS.sendFailurecode(workJob.Creator_Location__c,workJob.name,workJob.Creator_Location__c.left(5),workJob.Creator_Location__c.right(5),workJob.Customer_Code__c,'WOQT',((workJob.Quote_ID__c == null || workJob.Quote_ID__c == '') ? BMSQuoteNumber : workJob.Quote_ID__c),LstSolComp);
            CG_SendFailurecodestoBMSOutPutWrapper CSWrap;
            System.debug('=======> failureres' +failureres);
            sJob = new CSS_Job_Order__c();
            sJob.Id = workJob.Id;
            sJob.BMSStatus__c = failureres.bmsStatus;
            system.debug('BMS Status-->'+failureres.bmsStatus);
            if(failureres !=null && failureres.response!=null){
                CSWrap = (CG_SendFailurecodestoBMSOutPutWrapper)JSON.deserialize(failureres.response.getBody(),CG_SendFailurecodestoBMSOutPutWrapper.class);
            }
            IF(CSWrap!=null && CSWrap.Header.status=='SUCCESS'){
                SuccessNDErrorMsg = Label.CSS_FailureCodeSuccessMsg;
            }
            else
            {
                SuccessNDErrorMsg = Label.CSS_FailureCodeErrorMsg;
            }
            system.debug('BMSQuoteNumber'+BMSQuoteNumber);


            List<CSS_Solution_Component__c> LstSolComp1=[select id,name,system_code__c,CreatedById,Claim_Type__c,Create_User__c,Change_User__c,Component_Code__c,Failure_Mode__c,CSS_Account_Formula__c,Pay_Code__c,Service_Job__r.ESN__c,CertificateNumber__c, Authorization_Number__c, Service_Job__r.Failure_Date__c,Service_Job__r.Warranty_Start_Date__c,Service_Job__r.Service_Model__c,Service_Job__r.Make__c,Service_Job__r.Model__c,Service_Job__r.Unit_Type__c,Service_Job__r.ApplicationCode__c, Service_Job__r.Mileage__c,Service_Job__r.Mileage_Measure__c,Service_Job__r.CSS_Hours__c,Approval_Code__c,Service_Job__r.DistributorCode__c, Selected_Claim_Type__c,DeductibleAmount__c,CoveredTravelLabor__c,CoveredTravelMiles__c,CoveredTowingMiles__c,Type__c from CSS_Solution_Component__c where Service_Job__r.name=:workJob.name AND ((Type__c != null AND Performed_Review__c = true) OR (Type__c = null AND Selected_Component__c = true)) AND CSS_Account_Formula__c != null AND CSS_Account_Formula__c!= '' AND CSS_Account_Formula__c!= 'Select One' AND Claim_Type__c != null AND Claim_Type__c!= '' AND Claim_Type__c!= 'Select One'];
            // call send ClaimHeader to BMS
            CG_SL_BMS.sendClaimHeadertoBMS(workJob.Creator_Location__c,workJob.name,workJob.Creator_Location__c.left(5),workJob.Creator_Location__c.right(5),workJob.Customer_Code__c,'WOQT',((workJob.Quote_ID__c == null || workJob.Quote_ID__c == '') ? BMSQuoteNumber : workJob.Quote_ID__c ),LstSolComp1, workJob);

            if(BMSQuoteNumber != null && BMSQuoteNumber != '')
                createQuoteRecord(BMSQuoteNumber);
        }
        CG_BL_ODM.calljobODMHeaderFailureValidationService('JOB');
        system.debug('sJob-->'+sJob);
        if(sJob != null)
            update sJob;
    }
    //  public List<CSS_Quote__c> quoteList = null;
    //  public CSS_Quote__c quoteObj {get; set;}
    /* public void getAttachmentData() {
System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into getAttachmentData $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
//List<CSS_Quote__c> quoteList = null;
List<Attachment> attachList = null;
try{
quoteList = new List<CSS_Quote__c>([Select Id, Name, LastModifiedDate, OrderReference__c, Quote_decline_Reason__c, AcceptQuote__c from CSS_Quote__c where Service_Job__c=:workJob.Id order By LastModifiedDate DESC limit 1]);
System.debug('quoteList size>>>>>>>>>>>>>>>:'+quoteList.size());
if(quoteList.size()<=0)
return;
quoteObj = quoteList.get(0);
}catch(Exception ex){
System.debug('in catch getAttachmentData >>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
} finally {
quoteList=null;attachList=null;
}
} */


    public void createQuoteRecord(String QuoteId){
        //getAttachmentData();
        //system.debug('Upsert ----> '+ BMSQuoteNumber + workJob.Id);
        CSS_Quote__c qt = new CSS_Quote__c();
        qt.OrderReference__c=QuoteId;
        qt.Service_Job__c=workJob.Id;

        insert qt;

        CSS_Job_Order__c ServJob = new CSS_Job_Order__c();
        ServJob.Id = workJob.Id;
        ServJob.Quote_ID__c = QuoteId;
        update ServJob;

    }
    /*Added as part of change*/
    public void getSRTFailurenamesOnLoad(){


        if((selectedFName==null ||  selectedFName.toLowerCase() != 'unlisted') && wid!=null){
            if(failureNameList.size()==0 && workJob.ESN__c != null && workJob.Service_Model__c!=null && workJob.Qsol_Engine_Family_Code__c!=null){
                CSS_SRTComponentLookupResponseJ2A failureCodeDetails;
                try{


                    CSS_JobEventTemporary__c[] jobEventTemp;
                    String smn_engFamCode = workJob.Service_Model__c + ';;' + workJob.Qsol_Engine_Family_Code__c;
                    try{
                        jobEventTemp = [SELECT Id, Attribute1__c, Attribute2__c, Attribute3__c, Reason__c, Key__c FROM CSS_JobEventTemporary__c WHERE Attribute3__c =: smn_engFamCode  AND Key__c = 'getFailureCodesSRT' AND CreatedDate = LAST_N_DAYS:7 LIMIT 1];
                    }
                    catch(exception Err){
                    }

                    system.debug('job even temp'+jobEventTemp);

                    if(jobEventTemp.size()==0){

                        CSS_FN_SRT controller = new CSS_FN_SRT();

                        failureCodeDetails = controller.getFailureCodesSRT(workJob.Service_Model__c,workJob.Qsol_Engine_Family_Code__c, 'en');

                        System.debug('failureCodeDetails :' + failureCodeDetails);

                        String output = JSON.serialize(failureCodeDetails);
                        CSS_JobEventTemporary__c jobEventTempRec = new CSS_JobEventTemporary__c();
                        jobEventTempRec.Attribute1__c = workJob.Service_Model__c;
                        jobEventTempRec.Attribute2__c = workJob.Qsol_Engine_Family_Code__c;
                        jobEventTempRec.Attribute3__c = workJob.Service_Model__c + ';;' + workJob.Qsol_Engine_Family_Code__c;
                        jobEventTempRec.Reason__c = output;
                        jobEventTempRec.Key__c = 'GetFailureCodesSRT';
                        insert jobEventTempRec;

                        for(CSS_SRTComponentLookupResponseJ2A.DataArea data: failureCodeDetails.DataArea){

                            failureNameList.add(data.FailureName);

                            failureNameWithSystemCodeMap.put(data.FailureName,data.SystemCode);
                            systemCodeList.add(data.SystemCode);
                            failureNameWithCompCodeMap.put(data.FailureName,data.ComponentCode);
                            componentCodeList.add(data.ComponentCode);
                            system.debug('**data.ComponentCode**'+data.ComponentCode);
                            FailureNameWithFailureIDMap.put(data.FailureName,data.FailureID);
                        }
                    }
                    else {

                        system.debug('jobEventTemp.Reason__c'+jobEventTemp[0].Reason__c);
                        if(jobEventTemp[0].Reason__c != null){
                            failureCodeDetails = (CSS_SRTComponentLookupResponseJ2A)JSON.deserializeStrict(jobEventTemp[0].Reason__c, CSS_SRTComponentLookupResponseJ2A.class);
                            system.debug('failureCodeDetails-->'+failureCodeDetails);
                        }
                        if(failureCodeDetails.DataArea !=null){

                            for(CSS_SRTComponentLookupResponseJ2A.DataArea det: failureCodeDetails.DataArea){

                                String strFN=det.FailureName;
                                if(!failureNameList.contains(strFN)){
                                    failureNameList.add(det.FailureName);

                                    String strSC=det.SystemCode;

                                    systemCodeList.add(det.SystemCode);
                                    system.debug('**det.SystemCode**'+det.SystemCode);
                                    failureNameWithSystemCodeMap.put(strFN,strSC);

                                    String strCC=det.ComponentCode;

                                    componentCodeList.add(det.ComponentCode);
                                    system.debug('**det.ComponentCode**'+det.ComponentCode);
                                    failureNameWithCompCodeMap.put(strFN,strCC);
                                    FailureNameWithFailureIDMap.put(det.FailureName,det.FailureID);
                                }
                            }
                        }


                    }
                    failureNameList.add('Unlisted');
                    system.debug('SysCoddeLsit**'+systemCodeList);
                    system.debug('CompCodeLsit**'+componentCodeList);
                }
                catch(Exception e){
                    System.debug('Exception Calling getFailureCodesSRT :' + e.getLineNumber() + ' '+ e.getMessage());
                }

            }
        }
    }
    public void changeFailures_New(){

        system.debug('selectedFName>>'+ selectedFName);
        selectedFNameValue=selectedFName;

        accCodeSelected = '';
        payCodeSelected ='';
        //Start code As per Task #191282,-By RAJESH 23rd Aug 2019    
        coverageFound='false';
        pleaseselacc=false;
        errornotcovfound=false;
        //End As per Task #191282,-By RAJESH 23rd Aug 2019  
        failureinfochange = true; //GSSC-290
        system.debug('failureinfochange'+failureinfochange);
        failmodeloadval =''; //GSSC-290
        if(selectedFName!=null &&  selectedFName.toLowerCase() != 'unlisted'){


            selectedSysCode =  failureNameWithSystemCodeMap.get(selectedFName) ;
            selectedCompCode =  failureNameWithCompCodeMap.get(selectedFName);
            failureSolCompID = FailureNameWithFailureIDMap.get(selectedFName);
            selectedCustFName = '';
            system.debug('selectedSysCode>>'+ selectedSysCode);
            system.debug('selectedCompCode>>'+ selectedCompCode);
            if(selectedSysCode!= null && selectedCompCode!= null){
//Have added Active__c!=false condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020
                List<CSS_JobEventTemporary__c>  jobEvSCCC=[select  Attribute1__c,Attribute4__c,Attribute5__c ,Attribute3__c
                                                           from CSS_JobEventTemporary__c
                                                           where key__c='FailCodes' AND Active__c!=false];
                for(CSS_JobEventTemporary__c jSCCC :jobEvSCCC){
                    if(selectedSysCode==jSCCC.Attribute1__c && selectedCompCode == jSCCC.Attribute4__c){
                        selectedSysCode=selectedSysCode+'-'+jSCCC.Attribute3__c;
                        selectedCompCode=selectedCompCode+'-'+jSCCC.Attribute5__c;
                        system.debug('selectedSysCode>>'+ selectedSysCode);
                        system.debug('selectedCompCode>>'+ selectedCompCode);
                    }

                }
            }
        }
        else if(selectedFName == null || selectedFName == ''){
            selectedSysCode =  '';
            selectedCompCode =  '';
            selectedCustFName = '';
        }
        //Getting List from Siebel: Kalpana
        if(selectedFName!=null &&  selectedFName.toLowerCase() == 'unlisted'){
            selectedSysCode =  '';
            selectedCompCode =  '';
            selectedCustFName = '';

            system.debug('enteringintounlisted'+selectedFName);
            String sysDesc;
            String compDesc;
            custFailureNameSysCodeMap = new map<string,string>();//Added as part of design changes
            custFailureNameCompCodeMap = new map<string,string>();
//Have added Active__c!=false condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 7th Feb 2020            
            List<CSS_JobEventTemporary__c> jobEventTemp = [select Attribute1__C,Attribute3__c,Attribute7__c, Attribute5__c,Attribute4__c,Active__c,Attribute13__C from CSS_JobEventTemporary__c where key__c='FailCodes' and Attribute1__C!=null and Attribute4__c!=null and Active__c!=false];
            if(jobEventTemp != null && jobEventTemp.size()>0){

                systemCodeList = new Set<string>();
                custFailureNameList=new Map<String,String>();
                systemCodeMap=new map<string,string>();
                integer i = 0;
                integer templistsize = jobEventTemp.size();
                while(i<templistsize)
                {

                    if(jobEventTemp[i].Attribute7__c != null){
                        sysDesc = jobEventTemp[i].Attribute1__C+'-'+jobEventTemp[i].Attribute3__c;
                        sysDesc = sysDesc.replace('\'','');
                        systemCodeList.add(sysDesc);
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
        /*Validation logic for predefined failures*/
        if(failureNameList!=null && failureNameList.size()>0){
            if(selectedFName != null && selectedFName != ''){
                if(failureNameList.contains(selectedFName)){
                    invalidFailure=false;
                }else{
                    invalidFailure = true;
                }
            }
        }

    }
    Public void changeCustFailures_New(){

        try{
            system.debug('selectedCustFName>>'+ selectedCustFName);
            selectedCustFNameValue=selectedCustFName;
            accCodeSelected = '';
            payCodeSelected = '';
            //Start code As per Task #191282,-By RAJESH 23rd Aug 2019    
            coverageFound='false';
            pleaseselacc=false;
            errornotcovfound=false;
            //End As per Task #191282,-By RAJESH 23rd Aug 2019
            failureinfochange = true; //GSSC-290
            failmodeloadval =''; //GSSC-290
            if(selectedCustFName!=null &&  selectedCustFName!= ''){

                system.debug('selectedSysCode>>'+ selectedSysCode);
                system.debug('selectedCompCode>>'+ selectedCompCode);
//Have added Active__c=true condition in below query for getting only active system and component codes as per story #GSSC-495,-By RAJESH 10th Feb 2020                
                List<CSS_JobEventTemporary__c>  jobEvSCCC=[select  Attribute1__c,Attribute4__c,Attribute5__c ,Attribute3__c,Active__c
                                                           from CSS_JobEventTemporary__c
                                                           where key__c='FailCodes' and Active__c=true and Attribute7__c =:selectedCustFName ];
                if(jobEvSCCC != null && jobEvSCCC.size()>0){
                    selectedSysCode =  jobEvSCCC[0].Attribute1__C+'-'+(jobEvSCCC[0].Attribute3__c != null ? jobEvSCCC[0].Attribute3__c : '');
                    selectedCompCode =  jobEvSCCC[0].Attribute4__C+'-'+(jobEvSCCC[0].Attribute5__c != null ? jobEvSCCC[0].Attribute5__c : '');
                }

                jobEvSCCC = new list<CSS_JobEventTemporary__c>();
            }else{
                selectedSysCode ='';
                selectedCompCode ='';
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
            system.debug('selectedSysCode>>>'+selectedSysCode);
            system.debug('selectedCompCode>>>'+selectedCompCode);
            system.debug('invalidCustFailure>>>'+invalidCustFailure);
            system.debug('karthikaccCodeSelected>>>'+accCodeSelected);

        }
        catch(Exception e){
            System.debug('Exception Calling changeFailures :' + e.getLineNumber() + ' '+ e.getMessage());
        }

    }
    public void changeSystemcode_New(){
        system.debug('selectedCompCode>>>'+selectedCompCode);
        String selSysCodee;
        selectedCompCode = '';
        system.debug('accCodeSelectedbefore'+accCodeSelected);
        accCodeSelected = '';
        payCodeSelected = '';
        system.debug('payCodeSelected'+payCodeSelected);
        //Start code As per Task #191282,-By RAJESH 23rd Aug 2019    
        coverageFound='false';
        pleaseselacc=false;
        errornotcovfound=false;
        //End As per Task #191282,-By RAJESH 23rd Aug 2019
        failureinfochange = true; //GSSC-290
        failmodeloadval =''; //GSSC-290
        componentCodeMap = new map<string,string>();
        componentCodeList=new set<string>();
        if(selectedSysCode.length()>2)
            selSysCodee=selectedSysCode.substring(0,2);
        system.debug('selSysCodee '+selSysCodee);
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
                    componentCodeList.add(compDesc1);

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
    }
    public void checkCompCode(){
        accCodeSelected = '';
        payCodeSelected = '';
        //Start code As per Task #191282,-By RAJESH 23rd Aug 2019    
        coverageFound='false';
        pleaseselacc=false;
        errornotcovfound=false;
        //End As per Task #191282,-By RAJESH 23rd Aug 2019
        failureinfochange = true; //GSSC-290
        if(componentCodeList!=null && componentCodeList.size()>0){
            if((selectedCustFName==null || selectedCustFName=='') && selectedCompCode!='' && selectedCompCode != null){
                if(componentCodeList.contains(selectedCompCode)){
                   invalidCompCode = false;
                }else{
                    invalidCompCode = true;
                }
            }
            else{
                invalidCompCode = false;
            }
        }
    }

    //siva ganesh added logic for story #GSSC-55
    public List<SelectOption> getlicensePlateList() { 
        Schema.DescribeFieldResult fieldResult = CSS_Job_Order__c.License_Plate__c.getDescribe();
        List<Schema.PicklistEntry> lstLPValues = fieldResult.getPicklistValues();
        System.debug('Picklist::'+ lstLPValues);
        List<SelectOption> lstLPValues1=new List<SelectOption>();
        lstLPValues1.add(new SelectOption('',' Select One '));

        for( Schema.PicklistEntry entry : lstLPValues){
            lstLPValues1.add(new SelectOption(entry.getValue(),entry.getLabel()));
        }
        system.debug('LstAppValues1---->'+lstLPValues1);

        return lstLPValues1;

    }

}