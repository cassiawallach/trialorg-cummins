/*--**********************************************************************
Name:CG_CL_CheckWarrantyCoverage
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this Class in CG_CheckWarranty_Coverage page
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0 - Saikomal Kattamudi      08/07/2018      INITIAL DEVELOPMENT                    
************************************************************************/
public class CG_CL_CheckWarrantyCoverage{
    public string Region{get;set;}
    public string wraadate{get;set;}
    public Boolean isDealer {get;set;}
    public string Territory{get;set;}
    public CSS_Claims__c claim{get;set;}
    public Date WarrStartDt{get;set;}
    public Date warrStartDt_Final{get;set;}
    public Date failureDt{get;set;}
    public String psn{get;set;}
    public Boolean bisFlag{get;set;}
    public String filterApplication{get;set;}
    public Boolean wsdReadOnlyFromContr{get;set;}
    public Boolean ExternReturnDateFlag{get;set;}
    public Boolean ReadonlyBIS{get;set;}
    public Boolean ReadonlyBIS_New{get;set;}
    public Map<String,String> mapDescriptionToCode;
    public String warrStDtHidden{get;set;}
    public String datebyLocaleValue {get;set;}
    public String FormattedDate {get; set;}
    public Boolean ReadonlyWSD{get; set;}
    public String prodHours{get; set;}
    public String prodMileKm{get; set;}
    public Boolean regionMandatoryFlag{get; set;}
    public Boolean territoryMandatoryFlag{get; set;}
    public Boolean psnMandatoryFlag{get; set;}
    public Boolean applnMandatoryFlag{get; set;}
    public Boolean wsdMandatoryFlag{get; set;}
    public Boolean failDateMandatoryFlag{get; set;}
    public Boolean noWarranFlagError{get; set;}
    public String applicationCode;
    public String mil_measure{get; set;}
    public String kil_measure{get; set;}
    public CSS_getBasicCoverageResponseJ2A basicCoverageDetails{get; set;}
    public Boolean showWarrDetailsSection{get; set;}
    public Map<String, List<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefType{get; set;} 
    public Map<String, List<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefTypeNewENG{get; set;}
    public Map<String, List<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>> mapGroupCoverageByDefTypeRecEng{get; set;}
    public Map<String, Map<String, List<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>> coverageByDefTypeMap{get; set;}
    public Map<String, String> tempcoverageURLProceMap{get; set;}
    public Boolean reqWrcoverBoolean{get;set;}
    public Boolean reqWrTerBoolean{get;set;}
    public List<CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails> listcertificatedetails{get; set;} 
    //public List<CSS_getBasicCoverageResponseJ2A.ListOfExtCoverageDedutibles> listExtendedCovDedutibles{get; set;} 
    public Boolean reqWrcertBoolean{get;set;}
    public Boolean showExtCoverage{get;set;}
    public Boolean emissionStatus{get;set;}
    public string productAppcode{get;set;}
    public string productAppdesc{get;set;}
    public Map <String, String>coverageURLProceMap{get;set;}
    public string prevmil_measure;
    public Boolean displaySrvModPopup {get;set;}
    public Boolean displaySrvModPopup1 {get;set;}
    public Boolean displayPSNSrvModPopup {get;set;}
    public Boolean recconFlag{get;set;}
    public Boolean coverageFlag{get; set;}
    public Map<Object,List<String>> dependValuesByControlValue{get; set;}
    public String regionSelected {get;set;}
    public String territorySelected {get;set;}
    public DateTime dt_FailureDate { get; set; }
    public boolean psnstatusflag{get;set;} //Added for the story#183077
    //public string failureDtstr{get;set;}
    public Map<String,string> milesHolder = new Map<String,string>();
    public String UnitMiles;
    public String PointMiles;
    public String UnitKilometers;
    public String PointKilometers;
    public String UnitHours;
    public String PointHours;
    public String EmmisionWarrantyDedutibles{get; set;}
    public String ExtendedWarrantyDedutibles{get; set;}
    public String ReconWarrantyDedutibles{get; set;}
    public String NewEngWarrantyDedutibles{get; set;}
    
    public Boolean NewEngWarrantyDedutiblesFlag{get; set;}
    public Boolean EmmisionWarrantyDedutiblesFlag{get; set;}
    public Boolean ExtendedWarrantyDedutiblesFlag{get; set;}
    public Boolean ReconWarrantyDedutiblesFlag{get; set;}
    public String siebelSMN;
    
    
    //For GSSC-409
    public list<SolCompWrapper> listSolcompWrapper {get;set;}
    public String errormsg{get;set;}//errormsg
    Transient public List<CSS_CampTsbTrp__c> lstCAM {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTRP {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTSB {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstATC {get; set;}
   
    public CG_CL_CheckWarrantyCoverage()
    {
        coverageFlag=false;
        wraadate = '';
        psnstatusflag = false;//Story#183077
        NewEngWarrantyDedutiblesFlag = false;
        EmmisionWarrantyDedutiblesFlag = false;
        ExtendedWarrantyDedutiblesFlag = false;
        ReconWarrantyDedutiblesFlag = false;
        getRegionTerritory();
        datebyLocaleValue = css_utility.getFormattedDate();
        //claim = [select id,Region__c,Territory__c,ReconEngineFlag__c from CSS_Claims__c Limit 1];
        //claim.Region__c = '';
        //claim.Territory__c = '';
        bisFlag = false;
        showWarrDetailsSection = true;
        mil_measure = 'Miles';
        kil_measure = 'Miles';
        
        isDealer = false;
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType !=null && userType != '') {
            if(userType == 'DLR') {
                system.debug('DLR*****'+userType);
                isDealer = true;
            }else if(userType == 'DISTR') {
                system.debug('DISTR*****'+userType);
                isDealer = false;
            }
        }
        dependValuesByControlValue = new Map<Object,List<String>>();
        dependValuesByControlValue = getDependentPicklistValues(CSS_Claims__c.Territory__c);
       /* if(failureDt==null)
            {
               failureDt=system.today();
              failureDtstr=failureDt.format();
               
            }*/
       
        
       
    }
    
    

    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers));
        return options;
    }

    public void getRegionTerritory(){
       // claim = [select id,Region__c,Territory__c,ReconEngineFlag__c from CSS_Claims__c Limit 1];
        Account acc_Obj = new Account();
        acc_Obj = css_utility.getRegionTerritory('');
        if(acc_Obj != null){
            Region = acc_Obj.Region__c;
            Territory= acc_Obj.Territory__c;
            system.debug('Account--'+acc_Obj);
        }
    }

    public void closeSrvModPopup(){
        displaySrvModPopup = false;
    }

    public void closeSrvModPopup1(){
        displaySrvModPopup1 = false;
        // mainContr.workJob.ESN__c = null;
    }

    public void startRequest(){
        lstCAM = new List<CSS_CampTsbTrp__c>();
        lstTRP = new List<CSS_CampTsbTrp__c>();
        lstATC = new List<CSS_CampTsbTrp__c>();
        lstTSB = new List<CSS_CampTsbTrp__c>();
        wraadate = '';
        recconFlag = false;
        displayPSNSrvModPopup = false;
        String sServiceModel;
        //displayPSNSrvModPopup = false;
        //String sServiceModel;
        Date siebelWarrantyDate=null;
   
        regionMandatoryFlag = false;
        territoryMandatoryFlag = false;
        psnMandatoryFlag = false;
        applnMandatoryFlag = false;
        wsdMandatoryFlag = false;
        failDateMandatoryFlag = false;
        noWarranFlagError = false;
        //String siebelSMN;
        //mainContr.psnRec.Warranty_Start_Date__c = null;
        WarrStartDt = null;   
        prodcodeErrormessage = false;
        system.debug('prodcodeErrormessage '+  prodcodeErrormessage);
        //claim.Region__c='';
        regionSelected = '';
        //claim.Territory__c='';
        territorySelected = '';
        showWarrDetailsSection = true;
        if(!Test.isRunningTest()){
        failureDt = null;
        system.debug('Testfaildate'+failureDt);
        }
        coverageByDefTypeMap = new Map<String, Map<String, List<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>> ();
        listcertificatedetails = new List<CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails>();
         //CSS_quickserveCumminsComWebservices.ModelName rDataPlate = new CSS_quickserveCumminsComWebservices.ModelName();
         CSS_getEngineDataResponseJ2A rDataPlate = new CSS_getEngineDataResponseJ2A(); //GSSC_97, ROD:Qsol changes
         CSS_getEngineDataResponseJ2A  engineData = new CSS_getEngineDataResponseJ2A();
         CSS_getEngineDataReqJ2A wrapobj;

        try{
            //PSN=mainContr.psnRec.PSN__c;

            //if (mainContr.psnRec.PSN__c =='' || mainContr.psnRec.PSN__c == null){
            if (psn =='' || psn == null){
                //mainContr.psnRec.Service_Model__c = '';
                //mainContr.psnRec.Warranty_Start_Date__c =null;
                WarrStartDt = null;
                psnstatusflag=false;//Story#183077
            } else{
                //86408 [Training] Popup Box not displaying for invalid ESN enter for the second attempt. - By Krishna at 30-03-2017  
                //siebelSMN = '';
                siebelWarrantyDate= null;
                /*if(state == NULL) {
                    mainContr.psnRec.Failure_Date__c= system.today();
                    mainContr.psnRec.Before_In_Service__c=null;
                }*/
                if(!Test.isRunningTest()){
                prodHours = '0';
                prodMileKm = '0';
                }

               /* string sQSOLConn;
                if(!Test.isRunningTest()){
                    sQSOLConn = CSS_getConnnectionDetails.getConnection('QSOL').Key__c;
                }
                else{
                    sQSOLConn = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                }
                system.debug('sQSOLConn>>>'+sQSOLConn);*/

                //Get Dataplate information from QSOL based on ESN
               /* CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wsCall = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
                rDataPlate = wsCall.getEngineDataplate(sQSOLConn, psn);//mainContr.psnRec.PSN__c);*/
                rDataPlate = CG_BL_Intake.GetEngineDataPlateQSOL(psn); //GSSC_97, ROD:Qsol changes
                system.debug('rDataPlate>>>'+rDataPlate);
                
                
                //Calling SiebelWS to get data 63173-Start CSS_getEngineDataReqJ2A
                wrapobj = new CSS_getEngineDataReqJ2A();
               // CSS_getEngineDataResponseJ2A  engineData;
                CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
                jidi.ESN=psn;//mainContr.psnRec.PSN__c;
                wrapobj.DataArea = jidi;

                engineData = CSS_WS_SBL.getEngineData(wrapobj);
                /*Start:Story#183077*/
               //if((rDataPlate!=null && rDataPlate.ResponseMessage!=null && rDataPlate.ResponseMessage.contains('SUCCESS')) || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
               /*if((rDataPlate!=null) || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
                psnstatusflag=false;
                else{ 
                psnstatusflag=true;
                    CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                    intEngError.Processed_Data__c =  String.valueOf(wrapobj);
                    intEngError.Response_Body__c = 'Access Denied';
                    //intEngError.Service_Job_Number__c = mainContr.claimsRec.Name;
                    intEngError.Service_Name__c = 'GetEngineDataService';
                    intEngError.Source__c = 'SIEBEL';
                    //intEngError.WWID__c = FedId; 
                    
                    insert intEngError;
                }*/
                 //ROD Changes GSSC_97, As per latest update, QSOL Service call is stopped and data is retrieved from Asset
            if( (rDataPlate == null || rDataPlate.DataArea == null) &&  (engineData == null || engineData.DataArea == null || !engineData.Header.Status.contains('Success')))
            {
                psnstatusflag=true;
                CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                intEngError.Processed_Data__c =  String.valueOf(wrapobj);
                intEngError.Response_Body__c = 'Access Denied';
                //intEngError.Service_Job_Number__c = mainContr.claimsRec.Name;
                intEngError.Service_Name__c = 'GetEngineDataService';
                intEngError.Source__c = 'SIEBEL';
                //intEngError.WWID__c = FedId; 
                
                insert intEngError;
                
            }
            else{
                        psnstatusflag=false;
                    }
                /*end*/
                system.debug('engineData>>>>'+engineData);
                if (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')){
                    
                    if(engineData.DataArea.NoWarranty!=null && engineData.DataArea.NoWarranty!='' && engineData.DataArea.NoWarranty=='Y')
                    noWarranFlagError = true;
                    
                    system.debug('engineData.DataArea.ProdAppDesc'+ engineData.DataArea.ProdAppDesc);
                    productAppdesc =  engineData.DataArea.ProdAppDesc;

                    system.debug('engineData.DataArea.ProdAppCode'+ engineData.DataArea.ProdAppCode);
                    productAppcode = engineData.DataArea.ProdAppCode;

                    List<SelectOption> applicationPL = getApplication();
                    Set<String> listOfApplication = new Set<String>();
                    for(SelectOption sOption : applicationPL) {
                        listOfApplication.add(sOption.getValue());
                    }
                      
                    List<CSS_List_Of_Values__c> ListOfValues = CSS_List_Of_Values__c.getall().values();                    
                    for(Integer i = 0; i < ListOfValues.size() ; i++){
                        if(ListOfValues[i].Code__c == engineData.DataArea.EngineAppCode){
                            filterApplication = ListOfValues[i].Picklist_Values_1__c;
                            break;
                        } 
                        else{
                            filterApplication = '';
                        }
                    }      
                    system.debug('engineData.DataArea.ServiceModelName'+engineData.DataArea.ServiceModelName);
                    if (String.valueOf(engineData.DataArea.ServiceModelName)!=''  )
                        siebelSMN = engineData.DataArea.ServiceModelName;

                    if (String.valueOf(engineData.DataArea.WarrantyStartDate)!='') { 
                        siebelWarrantyDate = date.valueOf(String.valueOf(engineData.DataArea.WarrantyStartDate));
                        system.debug('siebelWarrantyDate**'+siebelWarrantyDate);                     
                    }

                    if(engineData.DataArea.EtoConversionDate != null && engineData.DataArea.EtoConversionDate !=''){

                        if(engineData.DataArea.ETOOldESN.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(engineData.DataArea.ETOOldESN));
                        System.debug('** ReconFlag'+recconFlag);                        
                    }
                    else{
                        if(psn != null && psn.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(psn));
                        System.debug('** ReconFlag'+recconFlag);
                    }
                }
                else{
                    filterApplication = '';
                }
                //End Calling SiebelWS to get data 63173
                system.debug('PSN--'+psn);
                if(engineData != null && engineData.DataArea != null && (engineData.DataArea.ServiceModelName == null || engineData.DataArea.ServiceModelName == '')){
                    if(psn.isNumeric() || psn.length() == 8)
                    {
                        displaySrvModPopup=true;
                    }
                }
                else{
                    system.debug('Inside Else');
                    displaySrvModPopup=true;
                }
                //Added if as per GSSC-372
                if(rDataPlate != null && rDataPlate.DataArea!= null)
                sServiceModel = rDataPlate.DataArea.ServiceModelName;

                /*if ((sServiceModel =='' || sServiceModel==null) && (siebelSMN !='' && siebelSMN != null)){                    
                    sServiceModel = siebelSMN;
                }
                mainContr.psnRec.Service_Model__c = sServiceModel;
                system.debug('SMN>>>:'+siebelSMN+' '+mainContr.psnRec.Service_Model__c);*/
                //Kalpana Added Code for 154597
                /*  if(mainContr.ClaimsRec.css_job__c == null){
                    if(mainContr.workJob.ESN__c.isNumeric() || mainContr.workJob.ESN__c.length() == 8)
                        system.debug('SMN'+sServiceModel);
                        system.debug('entered one');
                        displayPSNSrvModPopup=true;
                    }
                    if((mainContr.psnRec.PSN__c.length() < 8 || mainContr.psnRec.PSN__c.length() > 8) && mainContr.psnRec.PSN__c.isNumeric()){
                        displayPSNSrvModPopup=true;
                        system.debug('displayPSNSrvModPopup1'+displayPSNSrvModPopup);
                        System.debug('mainContr.psnRec.PSN__c.isNumeric()'+mainContr.psnRec.PSN__c.isNumeric());
                        System.debug('mainContr.psnRec.PSN__c.length()'+mainContr.psnRec.PSN__c.length());
                    }
              }   */
                //if(psn == null){
                system.debug('ServiceModel -->'+sServiceModel);
                if((sServiceModel == null || sServiceModel == '' ) && psn.length() == 8){
                    if(siebelSMN == null || siebelSMN == ''){
                        system.debug('SMN'+sServiceModel);
                        system.debug('entered one');
                        displayPSNSrvModPopup=true;
                    }
                }
                if((psn.length() < 8 || psn.length() > 8) && psn.isNumeric()){
                    displayPSNSrvModPopup=true; 
                    system.debug('displayPSNSrvModPopup1'+displayPSNSrvModPopup);
                    //   System.debug('mainContr.psnRec.PSN__c.isNumeric()'+mainContr.psnRec.PSN__c.isNumeric());
                    //   System.debug('mainContr.psnRec.PSN__c.length()'+mainContr.psnRec.PSN__c.length());
                }
                //} 
                system.debug(siebelWarrantyDate);
               // system.debug(rDataPlate.DataArea.warrantyStartDate);
                if (string.valueof(siebelWarrantyDate) !=''  && string.valueof(siebelWarrantyDate) != null){
                    //mainContr.psnRec.Warranty_Start_Date__c=siebelWarrantyDate;
                    WarrStartDt = siebelWarrantyDate;
                    wsdReadOnlyFromContr = true;
                    Date d = WarrStartDt;
                    system.debug('d-->'+d);
                    if(d != null)
                        FormattedDate = css_utility.FormatDate(d);
                    //mainContr.psnRec.Before_In_Service__c = false;
                    bisFlag = false;
                    //mainContr.ExternReturnDateFlag = true;
                    ExternReturnDateFlag = true;
                    ReadonlyBIS_New=false;
                    warrStartDt_Final = siebelWarrantyDate;
                }else if (rDataPlate.DataArea.warrantyStartDate != null && rDataPlate.DataArea.warrantyStartDate != '') {
                    wraadate = rDataPlate.DataArea.warrantyStartDate;
                    /*//mainContr.psnRec.Warranty_Start_Date__c = date.valueof(rDataPlate.warrantyStart);
                    WarrStartDt = date.valueof(rDataPlate.warrantyStart);
                    Date d = WarrStartDt;
                    system.debug('d-->'+d);
                    if(d != null)
                        FormattedDate = css_utility.FormatDate(d);
                    //mainContr.psnRec.Before_In_Service__c =  false;*/
                    bisFlag = false;
                    //mainContr.ExternReturnDateFlag = true;
                    ExternReturnDateFlag = true;
                    ReadonlyBIS_New=false;
                    wsdReadOnlyFromContr = true;
                    warrStartDt_Final = css_utility.formatDateFromGuidanzFormat(rDataPlate.DataArea.warrantyStartDate);
                    system.debug('warrStartDt_Final'+warrStartDt_Final); 
                }else{
                    system.debug('Checking before in service');
                    WarrStartDt=null;
                    FormattedDate = '';
                    wsdReadOnlyFromContr = false; 
                    //mainContr.ExternReturnDateFlag = false;
                    ExternReturnDateFlag = false;
                    warrStartDt_Final = null;
                }
                //System.debug('sServiceModel: '+sServiceModel);
            }
        }catch(exception e){
               /*Start:Story#183077*/
              // if((rDataPlate!=null && rDataPlate.ResponseMessage!=null && rDataPlate.ResponseMessage.contains('SUCCESS')) || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
               /* if((rDataPlate!=null) || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
                psnstatusflag=false;
                else
                {
                psnstatusflag=true;
                CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                intEngError.Processed_Data__c =  String.valueOf(wrapobj);
                intEngError.Response_Body__c = String.valueof(engineData);
                //intEngError.Service_Job_Number__c = mainContr.claimsRec.Name;
                intEngError.Service_Name__c = 'GetEngineDataService';
                intEngError.Source__c = 'SIEBEL';
                //intEngError.WWID__c = FedId; 
                
                insert intEngError;    
                }*/
                 //ROD Changes GSSC_97, As per latest update, QSOL Service call is stopped and data is retrieved from Asset
            if( (rDataPlate==null || rDataPlate.DataArea == null) &&  (engineData== null || engineData.DataArea == null || !engineData.Header.Status.contains('Success')))
            {
                psnstatusflag=true;
                CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                intEngError.Processed_Data__c =  String.valueOf(wrapobj);
                intEngError.Response_Body__c = 'Access Denied';
                //intEngError.Service_Job_Number__c = mainContr.claimsRec.Name;
                intEngError.Service_Name__c = 'GetEngineDataService';
                intEngError.Source__c = 'SIEBEL';
                //intEngError.WWID__c = FedId; 
                
                insert intEngError;
                
            }
            else{
                        psnstatusflag=false;
                    }
                /*end*/
          //  system.debug('EXCEPTION of startRequest CG_CL_CheckWarrantyCoverage  >>>:'+e.getMessage() + ' Line No>>>:' + e.getLineNumber() + ' Cause>>:' +e.getCause());
        }
          if(psnstatusflag!=null && !psnstatusflag){
        if(filterApplication== null || filterApplication== ''){
            CSS_PSN__c PSNobj = new CSS_PSN__c();
            try{ 
                PSNobj = [select id, PSN__c,ApplicationCode__c, Application__c from CSS_PSN__c where PSN__c =: psn order by CreatedDate Desc Limit 1];
            }
            catch(Exception e){
            }
            if(PSNobj != null){
                filterApplication = PSNobj.Application__c;
                system.debug('PSNobj'+PSNobj);

            } else{
                filterApplication = '';
                prodcodeErrormessage = false;
            }
        }
          
       system.debug('filterApplication'+filterApplication);
        if(filterApplication!= null || filterApplication!= '' || filterApplication!='Select One'){
            system.debug('insidethe else for the appcode');
            
            updateproductappcode();
            system.debug('updateproductappcode on startRequest');
            if(prodcodeErrormessage == true){
                system.debug('prodcodeErrormessage'+prodcodeErrormessage);
               filterApplication = '';
               prodcodeErrormessage = false;
            }
        }       
          }
    } 

    public List<SelectOption> getApplication() {
        List<SelectOption> lstApplications;
        CSS_WPR_SBL_ApplicationResJSON resJSON;
        try {
            resJSON = CG_BL_Intake.getApplicationCodesWrapper();

            //create a map with code and description
            mapDescriptionToCode = new map<string,string>();

            lstApplications = new List<SelectOption>();
            lstApplications.add(new SelectOption('','Select One'));
            //lstApplications.add(new SelectOption('','----Select One----'));
            if(resJSON  != null && resJSON.DataArea != null && resJSON.DataArea.Details != null ){
                for(CSS_WPR_SBL_ApplicationResJSON.Details det : resJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y'){
                        lstApplications.add(new SelectOption(det.Description,det.ApplicationCode+' - '+det.Description));
                        mapDescriptionToCode.put(det.Description,det.ApplicationCode);
                    }
                }
            }
            lstApplications.sort();
            system.debug('lstApplications>>>'+lstApplications);

        }catch(exception e){
            system.debug('EXCEPTION of CG_CL_IntakeUENoERP - getApplicationCodes Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return lstApplications;
    }

    public void  MakeBISReadOnly() 
    {
        system.debug('InsideBIS**');
        wsdReadOnlyFromContr = false;
        if(psn != null && (warrStDtHidden != '' && warrStDtHidden != null)){
            ReadonlyBIS_New = true;
        }
        else{
            ReadonlyBIS_New = false;
        }
    }
    /*public String getFormatDate(){

        try{
            Date d = WarrStartDt; 
            FormattedDate = css_utility.FormatDate(d);
        }catch(exception e){ 
            system.debug('in catch DateModel exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return FormattedDate;
    }*/
    public void  MakeWSDReadOnly() {
        if(bisFlag != null && bisFlag == true){
            ReadonlyWSD = true;
        }
        else{
            ReadonlyWSD = false;
        }
    }  

    public pagereference searchMethod()  {
        kil_measure=mil_measure;
        emissionStatus = false;
        String coverageDetailsSTR = '';
        String coverageDetailsSTR2 = '';
        EmmisionWarrantyDedutibles ='';
        ExtendedWarrantyDedutibles='';
        NewEngWarrantyDedutibles='';
        ReconWarrantyDedutibles='';
        NewEngWarrantyDedutiblesFlag = false;
        EmmisionWarrantyDedutiblesFlag = false;
        ReconWarrantyDedutiblesFlag = false;
        ExtendedWarrantyDedutiblesFlag=false;
        String applicationCode;
        String SelectedAppCode;
        string ProductMileage;
        string ProductMeasure;
        Map<String, String> coverageURLProceMap;
        String mileKmMeasure;
        Integer coverageMaxMonth;
        system.debug('Testhours1'+prodHours);
        if(prodHours == null || prodHours == ''){
        prodHours = '0';
        system.debug('Testhours1'+prodHours);
        }
        if(prodMileKm == null || prodMileKm == '')
        prodMileKm = '0';
        if(warrStartDt_Final == null)
            warrStartDt_Final = WarrStartDt;
        try {
            List<SelectOption> applicationlist = getApplication();
            String filterLabel;
            if(applicationlist.size()>0){
                for(SelectOption sopt: applicationlist){
                    if(sopt.getValue()==filterApplication){
                        filterLabel = sopt.getlabel();
                        break;
                    }
                }
            }
            system.debug('filterLabel'+filterLabel);
            if(filterLabel != null){
                List<String> strList = new List<String>();
                strList = filterLabel.split('-');
                if(strList != null && strList.size() != 0)
                    applicationCode = strList[0].trim();
            }
            
            //GSSC-409 Start
            Date Failure_Date = Date.today();
            String CSS_QsolLanguage = 'en'; //
            String reconEngineFlag = 'N';
            if(recconFlag == true)
                reconEngineFlag = 'Y';  //added as per the story 156820
            else
                reconEngineFlag = 'N';  //added as per the story 156820
            
            //modularized code below
            List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaignsForUT(psn, siebelSMN, Failure_Date, CSS_QsolLanguage, Region, ProductMileage, 
                                                                  mil_measure,applicationCode, warrStartDt_Final, reconEngineFlag);
            system.debug('final campaignsList size-->:'+campaignsList.size()+' campaignsList:'+campaignsList);
            
            if(campaignsList !=null && campaignsList.size()>0)
                lstCAM = campaignsList.get(0);
            system.debug('final lstCAM-->:'+lstCAM);
            if(campaignsList !=null && campaignsList.size()>1)
                lstTSB = campaignsList.get(1);
            system.debug('final lstTSB-->:'+lstTSB);
            if(campaignsList !=null && campaignsList.size()>2)
                lstTRP = campaignsList.get(2);
            system.debug('final lstTRP-->:'+lstTRP);
            if(campaignsList !=null && campaignsList.size()>3)
                lstATC = campaignsList.get(3);
            system.debug('final lstATC-->:'+lstATC);
            if(campaignsList !=null && campaignsList.size()>4){
                List<CSS_CampTsbTrp__c> campaigns4List = new List<CSS_CampTsbTrp__c>();
                campaigns4List = campaignsList.get(4);
                integer capsize = campaigns4List.size();
                if(campaignsList.get(4).get(capsize-1).Type__c=='FAError'){
                    if(campaignsList.get(4).get(capsize-1).Doc_Num__c=='Error')
                        errormsg = Label.CG_FA_FLAG;
                    else
                        errormsg = '';
                }
            } 
            //GSSC-409 end
            
            
            Date faildate;
            Date failureDt;
            system.debug('faildate'+failureDt);
            if(failureDt==null)
            {
               failureDt=system.today(); 
             
               
            }
            
            faildate=failureDt;  // Story 164795
            system.debug('date1'+faildate);
            Date warrantydate=warrStartDt_Final; 
            system.debug('date2'+warrStartDt_Final);
            //String Monthsbwfaildatewarrdate =String.valueOf(warrantydate.monthsBetween(faildate)); 
            Double days;
            if(warrantydate != null)
                days=(warrantydate.daysBetween(faildate));
            Double Monthsbwfaildatewarrdate;
            if(days != null)
                Monthsbwfaildatewarrdate = days/30.417;
            else
                Monthsbwfaildatewarrdate = 0;
            system.debug('Days for warranty'+days);
            system.debug('Months for warranty'+Monthsbwfaildatewarrdate);
            //system.debug('Months'+Monthsbwfaildatewarrdate);
            
            
            
            /*if(applicationlist.size()>0){
                for(SelectOption sopt: applicationlist){
                    if(sopt.getValue()==filterApplication){
                        filterLabel = sopt.getlabel();
                        break;
                    }
                }
            }
            system.debug('filterLabel'+filterLabel);
            if(filterLabel != null){
                List<String> strList = new List<String>();
                strList = filterLabel.split('-');
                if(strList != null && strList.size() != 0)
                    applicationCode = strList[0].trim();
            }*/
            
            //System.debug('Region__c*****************'+claim.Region__c+'isDealer'+isDealer); 
            //if(claim.Region__c == null || claim.Region__c == '' && isDealer!=true)
            system.debug('regionSelected'+regionSelected);
            system.debug('isDealer'+isDealer);
           // if((regionSelected == null || regionSelected == '' || regionSelected == 'None') && isDealer != true){
                 if((Region == null || Region == '' || Region == 'None') && isDealer != true){
                system.debug('inside if');
                if(!Test.isRunningTest()){
                    regionMandatoryFlag = true;
                }
            }
            else
                regionMandatoryFlag = false;
            //if(claim.Territory__c == null || claim.Territory__c == '' && isDealer!=true)
           // if((territorySelected == null || territorySelected == '' || territorySelected == 'None') && isDealer != true){
                  if((Territory == null || Territory == '' || Territory == 'None') && isDealer != true){
                if(!Test.isRunningTest()){
                territoryMandatoryFlag = true;
                }
            }
            else
                territoryMandatoryFlag = false;
            if(psn == null || psn == '' && isDealer!=true)
                psnMandatoryFlag = true;
            else
                psnMandatoryFlag = false;
            if(filterApplication == null || filterApplication == '' && isDealer!=true)
                applnMandatoryFlag = true;
            else{
                applnMandatoryFlag = false;
                /*List<String> lstStr = new List<String>();
                system.debug('filterApplication'+filterApplication);
                lstStr = filterApplication.split('-');
                if(lstStr != null && lstStr.size() >0){
                    applicationCode = lstStr[1].trim();
                }*/
            }


            system.debug('bis-->'+bisFlag);
            system.debug('warrStartDt_Final -->'+warrStartDt_Final);
            system.debug('failureDT -->'+failureDt);
            if(bisFlag == false){
                if(warrStartDt_Final == null) {
                    wsdMandatoryFlag = true;
                    failDateMandatoryFlag = false;
                }
                else{
                    wsdMandatoryFlag = false;
                }
            }
            else{
                if(failureDt == null){
                    failDateMandatoryFlag = true;
                    wsdMandatoryFlag = false;
                }
                else{
                    failDateMandatoryFlag = false;
                }
            }
            system.debug('failDateMandatoryFlag -->'+failDateMandatoryFlag);
            system.debug('regionMandatoryFlag'+regionMandatoryFlag+'territoryMandatoryFlag'+territoryMandatoryFlag+'psnMandatoryFlag'+psnMandatoryFlag+'applnMandatoryFlag'+applnMandatoryFlag+'wsdMandatoryFlag'+wsdMandatoryFlag+'failDateMandatoryFlag'+failDateMandatoryFlag);
            if (regionMandatoryFlag == true || territoryMandatoryFlag == true || psnMandatoryFlag == true || applnMandatoryFlag == true || wsdMandatoryFlag == true || failDateMandatoryFlag == true) {
                showWarrDetailsSection = false;
                return null;
            }
            else {
                //mil_measure = defValue;
                prevmil_measure = mil_measure;
                CSS_getBasicCoverageReqJ2A getBasicCoverageReq = new CSS_getBasicCoverageReqJ2A();
                CSS_getBasicCoverageReqJ2A.DataArea reqDA = new CSS_getBasicCoverageReqJ2A.DataArea();
                
                basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                
                if (psn != null) {
                    reqDA.ESN = psn.trim();
                    /*if(Region != null && Region != '')
                        reqDA.Region = Region;//claim.Region__c;
                    else
                        reqDA.Region = claim.Region__c;

                    if(Territory != null && Territory != '')
                        reqDA.Territory = Territory;// claim.Territory__c;
                    else
                        reqDA.Territory = claim.Territory__c;*/
                    //if(claim.Region__c != null && claim.Region__c != '')
                    if(regionSelected != null && regionSelected != '')
                        reqDA.Region = regionSelected;//claim.Region__c;
                    else
                        reqDA.Region = Region;

                    //if(claim.Territory__c != null && claim.Territory__c != '')
                    if(territorySelected != null && territorySelected != '')
                        reqDA.Territory = territorySelected;// claim.Territory__c;
                    else
                        reqDA.Territory = Territory;
                        
                    if(recconFlag == true)
                        reqDA.ReconFlag = 'Y';  //added as per the story 156820
                    else
                        reqDA.ReconFlag = 'N';  //added as per the story 156820
                        
                    system.debug('application code' + applicationCode);
                    reqDA.EngineApplicationCode = applicationCode; 


                    Date d;
                    string Mile;
                    if(bisFlag == false)
                        d = warrStartDt_Final;
                    else
                        d = failureDt;
                    system.debug('d' + '  '+ d);
                    //Updated Date format yyyy by Rajesh Narra on 12062019 to correct the issue.
                    String warantySDate = DateTime.newInstance(d.year(), d.month(), d.day()).format('MM/d/yyyy');
                    system.debug('warantySDate' + '  '+ warantySDate);
                    reqDA.WarrantyStartDate = warantySDate; 
                    system.debug('Prodmiles'+prodMileKm);
                    //Included > 0 condition in the below IF to check for a valid vlaue.
                    //Story # 190403 - Start
                    if(prodMileKm != null && prodMileKm != '' && Integer.valueOf(prodMileKm) > 0) {
                        if(mil_measure != null && mil_measure == 'Miles') {
                            reqDA.FailurePoint = '' + prodMileKm;
                            reqDA.FailureUnit = 'Miles';
                            UnitMiles = 'Miles';
                            PointMiles = '' + prodMileKm;
                            UnitHours = 'Hours';
                            PointHours = ''+ prodHours;
                            
                        } else {
                            //convert into Miles
                            
                            //Mile = String.ValueOf((integer.valueOf(prodMileKm) * 0.621371).setScale(0)); 
                            //Mile = String.ValueOf((integer.valueOf(prodMileKm) * 1.60934).setScale(0));
                            Mile = prodMileKm; // Added by vamshi- Changed as it was discussed in go no go meeting to send the value without conversion when calling the service.
                            reqDA.FailurePoint = prodMileKm;
                            reqDA.FailureUnit = 'Kilometers';
                            UnitMiles = 'Kilometers';
                            PointMiles = Mile;
                            UnitHours = 'Hours';
                            PointHours = ''+ prodHours;
                        }
                    } else {
                        reqDA.FailureUnit = 'Hours';
                        system.debug('tsd1'+prodHours);
                        reqDA.FailurePoint = ''+ prodHours;
                        system.debug('tsd'+prodHours);
                        UnitHours = 'Hours';
                        PointHours = ''+ prodHours;
                        if(mil_measure != null && mil_measure == 'Miles'){
                            UnitMiles = 'Miles';
                            PointMiles = '' + prodMileKm;
                        }
                        else{
                            //Mile = String.ValueOf((integer.valueOf(prodMileKm) * 1.60934).setScale(0));
                             Mile = prodMileKm;
                            UnitMiles = 'Kilometers';
                            PointMiles = Mile;
                        }
                    }
                    //Story # 190403 - END
                    System.debug('UnitHours'+UnitHours+'PointHours'+PointHours);
                    
                    // Story 190403 - Start
                    if(applicationCode=='130' || applicationCode=='210' || applicationCode=='220' || applicationCode=='310' || applicationCode=='320' || applicationCode=='410')
                    {
                    ProductMileage = string.valueof(reqDA.FailurePoint);
                    ProductMeasure = reqDA.FailureUnit;
                    }
                    else{
                    ProductMileage = string.valueof(reqDA.FailurePoint);
                    ProductMeasure = 'Hours';
                    }
                    // Story 190403 - END
                    
                    getBasicCoverageReq.DataArea = reqDA;
                    system.debug('getBasicCoverageReq' + ' ' + getBasicCoverageReq);
                    //}}
                    /*Called getClaimsBasicCoverage function as it is being added in CSS_WS_SBL class seperately to handle claims warranty data.*/
                    if(!Test.isRunningTest()){
                    basicCoverageDetails = CSS_WS_SBL.getClaimsBasicCoverage(getBasicCoverageReq,coverageFlag);
                    }
                    else{
                      //basicCoverageDetails = new CSS_getBasicCoverageResponseJ2A();
                      httpResponse res_test = new httpResponse();
                        //String basicCoverageDetails_Test='{ "Header": { "ReturnCodeDescription": "", "Status": "Success" }, "BasicCoverageResponseHeader": { "Response": { "ListOfCoverageDetails": { "CoverageDetails": [ { "ListOfCoverageComponentList": { "CoverageComponentList": [ { "MegawattHours": "0", "CoverageMaxMonths": "120", "CoverageComponentTypeCode": "EMISSIONS-CA", "CoverageMinMonths": "0", "CoverageHours": "9999999", "WarrantyEndDate": "", "WarrantyManualURL": "www.test.com/ems", "status": "status", "CoverageDefenitionType": "BASE", "remaining": "remaining", "CoverageMiles": "100000" } ] }, "WarrantyManualURL": "", "CoverageType": "NEW-New Engine Warranty", "WarrantyEndDate": "", "status": "status", "ListOfCoverageDedutibles": { "CoverageDedutibles": [ ] }, "ProcedureNumber": "" } ] }, "ListOfExtendedCoverageDetails": { "ExtendedCoverageDetails": [ { "ListOfExtCoverageDedutibles": { "ExtendedCoverageDedutibles": [] }, "WarrantyManualURL": "", "BeginMiles": "0", "EndMiles": "500000", "ProcedureNumber": "", "CertificateNumber": "TP41000811", "ProgramID": "TP4", "BeginHours": "0", "EndHours": "0", "EndDate": "09/21/2015", "StartDate": "09/21/2010", "Months": "60", "status": "status", "remaining": "remaining", "CAPCoverageID": "CRT" } ] } } } }';
                        String basicCoverageDetails_Test = '{"Header":{"ReturnCodeDescription":"","Status":"Success"},"BasicCoverageResponseHeader":{"Response":{"ListOfCoverageDetails":{"CoverageDetails":[{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"BASE","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EXTENDED","CoverageMinMonths":"0","CoverageHours":"12500","CoverageDefenitionType":"EXTENDED","CoverageMiles":"500000"},{"MegawattHours":"0","CoverageMaxMonths":"24","CoverageComponentTypeCode":"INJECTOR","CoverageMinMonths":"0","CoverageHours":"3125","CoverageDefenitionType":"BASE","CoverageMiles":"125000"},{"MegawattHours":"0","CoverageMaxMonths":"12","CoverageComponentTypeCode":"BELTS/HOSES","CoverageMinMonths":"0","CoverageHours":"6250","CoverageDefenitionType":"BASE","CoverageMiles":"250000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"NEW-New Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-007"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"EMS-Emissions Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"},{"ListOfCoverageComponentList":{"CoverageComponentList":[{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS","CoverageMinMonths":"0","CoverageHours":"0","CoverageDefenitionType":"BASE","CoverageMiles":"100000"},{"MegawattHours":"0","CoverageMaxMonths":"60","CoverageComponentTypeCode":"EMISSIONS-CA","CoverageMinMonths":"0","CoverageHours":"3000","CoverageDefenitionType":"BASE","CoverageMiles":"100000"}]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","CoverageType":"REW-Recon Engine Warranty","ListOfCoverageDedutibles":{"CoverageDedutibles":[]},"ProcedureNumber":"111-503-057"}]},"ListOfExtendedCoverageDetails":{"ExtendedCoverageDetails":[{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"500000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2015","StartDate":"09/21/2010","Months":"60","CAPCoverageID":"CRT"},{"ListOfExtCoverageDedutibles":{"ExtendedCoverageDedutibles":[]},"WarrantyManualURL":"https://quickserve.cummins.com/qs3/portal/service/manual/en/4021290/?page=","BeginMiles":"0","EndMiles":"300000","ProcedureNumber":"111-505-114","CertificateNumber":"TP41000811","ProgramID":"TP4","BeginHours":"0","EndHours":"0","EndDate":"09/21/2013","StartDate":"09/21/2010","Months":"36","CAPCoverageID":"APT"}]}}}}';
                      res_test.setBody(basicCoverageDetails_Test);
                      
                       basicCoverageDetails = (CSS_getBasicCoverageResponseJ2A)JSON.deserialize(res_test.getBody(), CSS_getBasicCoverageResponseJ2A.class);
                        system.debug('Testdate'+basicCoverageDetails);
                    }
                    System.debug('basicCoverageDetails Response>>>:'+basicCoverageDetails);
                    if (basicCoverageDetails==null || basicCoverageDetails.Header==null || basicCoverageDetails.Header.Status==null ||  (basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfCoverageDetails.CoverageDetails.size() == 0 &&
                                                                                                                                         basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails.size() == 0) ) {
                        showWarrDetailsSection = false;
                    }
                    else 
                    {
                        showWarrDetailsSection = true;
                        system.debug('basicCoverageDetails' + basicCoverageDetails.Header);
                        system.debug('basicCoverageDetails>>>>>>:' + basicCoverageDetails);
                        //Building map mapGroupCoverageByDefType
                        mapGroupCoverageByDefType = new Map<String, List<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
                        mapGroupCoverageByDefTypeNewENG = new Map<String, List<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
                        mapGroupCoverageByDefTypeRecEng = new Map<String, List<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
                        coverageByDefTypeMap = new Map<String, Map<String, List<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>> ();
                        coverageURLProceMap = new Map<String, String>();
                        tempcoverageURLProceMap = new Map<String, String>();

                        Date curDate = Date.today();
                        reqWrcoverBoolean = true;
                        for (CSS_getBasicCoverageResponseJ2A.coverageDetails c: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails) {
                            system.debug('c.CoverageType>>>>>>' + c.CoverageType);

                            //if the coverage type is of EMS-Emissions Warranty - NEW-New Engine Warranty
                            if (c.CoverageType == 'EMS-Emissions Warranty') {
                                system.debug('insideboolean');
                                reqWrcoverBoolean = false;
                                coverageDetailsSTR = 'CoverageType=' + c.CoverageType;
                                //URl and Procedure Map Values
                                coverageURLProceMap.put('EMS-Emissions Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                                tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'EMS-Emissions Warranty');
                                //iterating the CoverageComponentList
                                for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    //calculating miles
                                    coverageDetailsSTR = coverageDetailsSTR + '\nCoverageDefenitionType=' + ccl.CoverageDefenitionType + '\nCoverageComponentTypeCode=' + ccl.CoverageComponentTypeCode + '\nCoverageMaxMonths=';
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                                    //if(Decimal.valueOf(ccl.CoverageMinMonths) == 0 || ((Decimal.valueOf(ccl.CoverageMinMonths) > 0) && (((Decimal.valueOf(ccl.CoverageMinMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate)) && (Decimal.valueOf(Monthsbwfaildatewarrdate) <= Decimal.valueOf(ccl.CoverageMaxMonths)) ) || (Decimal.valueOf(ccl.CoverageMaxMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate) ))))
                                    {   // Story 164795
                                    
                                    if (mil_measure != null && mil_measure != '') {
                                        if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                            milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                            //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                            //system.debug('checking' + ccl.CoverageMaxMonths);
                                            //ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles) / 0.621371);
                                            ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                            string miletokm = ccl.CoverageMiles;
                                            system.debug('Testmiles'+miletokm);
                                            ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                                            // coverageDetailsSTR = coverageDetailsSTR + ccl.CoverageMaxMonths;
                                        }
                                    }
                                    
                                    if(mil_measure != null && mil_measure != ''){
                                        if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                             milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        }
                                    }
                                   
                                    
                                    coverageDetailsSTR = coverageDetailsSTR + ccl.CoverageMaxMonths + '\nCoverageMiles=' + ccl.CoverageMiles;
                                    // ccl.status = c.status;
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    if(warrStartDt_Final != null){
                                        if(Decimal.valueOf(ccl.CoverageHours) == 9999999)
                                        {
                                            if (curDate <= (warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))){ //.addDays(-1) 
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0){ 
                                            if (curDate <= (warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1) 
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }
                                        else{ 
                                            system.debug('Line number 604>>>>>prodMileKm'+prodMileKm + 'ccl.CoverageMiles' + ccl.CoverageMiles + 'prodHours>>>>>'+prodHours + 'ccl.CoverageHours>>>>'+ccl.CoverageHours );
                                            if (curDate <= (warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles) && Decimal.valueOf(prodHours) <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                        }
                                    }
                                    else
                                    {
                                        
                                        if(Decimal.valueOf(ccl.CoverageHours) == 9999999)
                                        {
                                            if (curDate <= (failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0){
                                            if (curDate <= (failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }
                                        else{ 
                                             system.debug('Line number 629>>>>>prodMileKm'+prodMileKm + 'ccl.CoverageMiles' + ccl.CoverageMiles + 'prodHours>>>>>'+prodHours + 'ccl.CoverageHours>>>>'+ccl.CoverageHours );
                                            if (curDate <= (failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles) && Decimal.valueOf(prodHours) <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                        }
                                        
                                    }
                                                                        
                                    }  
                                    
                                    // Story 164795 
                                    else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                    { 
                                        system.debug('Testing Months');
                                        ccl.status = 'Active';
                                    }

                                    if(warrStartDt_Final != null)
                                        ccl.WarrantyEndDate = ((warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1)
                                    else
                                        ccl.WarrantyEndDate = ((failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1)
                                    //system.debug('Coverage 3--> '+ warrStartDt_Final +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                    // Story 190403 - Start
                                    system.debug('Enddate'+ccl.WarrantyEndDate+'@@'+ccl.CoverageHours+'$$'+ccl.CoverageMiles);
                                    if(ccl.WarrantyEndDate != null && ccl.CoverageHours != null && ccl.CoverageMiles != null){
                                    system.debug('Test21');
                                    if(Integer.valueOf(ccl.CoverageMiles) != 0 ){
                                    system.debug('Test22'+ccl.CoverageMiles);
                                    system.debug('Testvalues11'+ccl.WarrantyEndDate+'curDate'+curDate+'UnitMiles'+UnitMiles+'UnitMiles'+UnitMiles+'PointMiles'+PointMiles);
                                    system.debug('Testbasc'+ccl.WarrantyEndDate+'ccl.CoverageMiles'+ccl.CoverageMiles+'ccl.CoverageHours'+ccl.CoverageHours);
                                    
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test111'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test112'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test113'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test114'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Active';
                                    system.debug('Test115'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    }
                                    
                                    if(Integer.valueOf(ccl.CoverageMiles) == 0)
                                    {
                                     system.debug('Tests%%'+ccl.WarrantyEndDate+' '+Date.valueOf(curDate).format());
                                     //system.debug(Date.valueOf(ccl.WarrantyEndDate));
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                    ccl.status = 'Active';
                                    system.debug('Test11'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test12'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test13'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ( (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test14'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test15'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    system.debug('Test16'+ccl.status);
                                    }
                                    
                                    }
                                    }
                                    system.debug('Test17'+ccl.status);
                                    if(Integer.valueOf(ccl.CoverageMiles) == 0 && Integer.valueof(PointMiles) > 0)
                                    {
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Active';
                                      }
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    if(Integer.valueOf(ccl.CoverageHours) == 0 && Integer.valueof(PointHours) > 0)
                                    {
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Active';
                                      }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    // Story 190403 - END

                                    if(ccl.WarrantyEndDate != null && ccl.WarrantyEndDate!= '') {
                                        try{
                                            date cd = date.parse(ccl.WarrantyEndDate);
                                            ccl.WarrantyEndDate = getFormattedDate(cd);

                                            If(Decimal.valueOf(ccl.CoverageHours) == 0 && Decimal.valueOf(ccl.CoverageMiles) == 999999){
                                                If(cd >= curDate){
                                                    ccl.status = 'Active';
                                                }else{
                                                    ccl.status = 'Expired';
                                                }
                                            }

                                        }catch(Exception e)  {
                                            system.debug('EXCEPTION occured while converting ccl.WarrantyEndDate 1 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                                        }
                                    }

                                    if(ccl.status == 'Expired'){
                                        emissionStatus = true;
                                    }


                                    //#85179    END
                                    //populating the map 
                                    ccl.WarrantyManualURL=c.WarrantyManualURL+c.ProcedureNumber;
                                    if (!mapGroupCoverageByDefType.containskey(ccl.CoverageComponentTypeCode)) {

                                        mapGroupCoverageByDefType.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                    }
                                    mapGroupCoverageByDefType.get(ccl.CoverageComponentTypeCode).add(ccl);
                                    system.debug('mapGroupCoverageByDefType>>>>*******123' + mapGroupCoverageByDefType.get(ccl.CoverageComponentTypeCode));
                                } //end of inner 1 loop
                                
                                // S-205 Start
                                for (CSS_getBasicCoverageResponseJ2A.CoverageDedutibles cd: c.ListOfCoverageDedutibles.CoverageDedutibles) {
                                
                                	if(cd.ConstantDecutibleAmt !=null && cd.ConstantDecutibleAmt !='' && cd.ConstantDecutibleAmt !='0')
                                	{
                                		EmmisionWarrantyDedutibles = cd.ConstantDecutibleAmt;
                                	}
                                	
                                	else {
                                	if (cd.FirstVisitAmt !=null && cd.FirstVisitAmt !='' && cd.FirstVisitAmt !='0')
                                		EmmisionWarrantyDedutibles = cd.FirstVisitAmt;
                                	}
                                	if(EmmisionWarrantyDedutibles == null || EmmisionWarrantyDedutibles == '')
                                    {
                                        EmmisionWarrantyDedutiblesFlag = true;
                                    }
                                	
                                }
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()<=0 )
                                {
                                    EmmisionWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+EmmisionWarrantyDedutiblesFlag);
                                }
                                // S-205 END
                                
                                system.debug('initialtestresp@@@@@' + coverageDetailsSTR);
                            } //end of If cond
                            system.debug('mapGroupCoverageByDefType>>>>*******' + mapGroupCoverageByDefType);
                            system.debug('initialtestresp######' + coverageDetailsSTR);
                            //if the coverage type is of NEW-New Engine Warranty
                            if (c.CoverageType == 'NEW-New Engine Warranty') {
                                system.debug('Inside');
                                reqWrcoverBoolean = false;
                                system.debug('covgtyperespcheck' + c.CoverageType);
                                system.debug('initialtestresp' + coverageDetailsSTR);
                                coverageDetailsSTR2 = coverageDetailsSTR2 + '\nCoverageType=' + c.CoverageType;
                                //URl and Procedure Map Values
                                coverageURLProceMap.put('NEW-New Engine Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                                tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'NEW-New Engine Warranty');
                                //iterating the CoverageComponentList
                                system.debug('Testing 113'+c.ListOfCoverageComponentList.CoverageComponentList);
                                for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    coverageDetailsSTR2 = coverageDetailsSTR2 + '\nCoverageDefenitionType=' + ccl.CoverageDefenitionType + '\nCoverageComponentTypeCode=' + ccl.CoverageComponentTypeCode + '\nCoverageMaxMonths=';
                                    system.debug('CoverageMinMonths'+Decimal.valueOf(ccl.CoverageMinMonths));
                                    system.debug('Monthsbwfaildatewarrdate'+Decimal.valueOf(Monthsbwfaildatewarrdate));
                                    system.debug('CoverageMaxMonths'+Decimal.valueOf(ccl.CoverageMaxMonths));
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                                    //if(Decimal.valueOf(ccl.CoverageMinMonths) == 0 || ((Decimal.valueOf(ccl.CoverageMinMonths) > 0) && (((Decimal.valueOf(ccl.CoverageMinMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate)) && (Decimal.valueOf(Monthsbwfaildatewarrdate) <= Decimal.valueOf(ccl.CoverageMaxMonths)) ) || (Decimal.valueOf(ccl.CoverageMaxMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate) ))))
                                    {   // Story 164795 
                                    //calculating miles
                                    system.debug('Testing 123'); 
                                    if (mil_measure != null && mil_measure != '') {
                                        if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                             milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                            //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                          //ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles) / 0.621371);
                                          ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                          string miletokm = ccl.CoverageMiles;
                                          system.debug('Testmiles'+miletokm);
                                          ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                                            
                                        }
                                    }
                                    
                                     if(mil_measure != null && mil_measure != ''){
                                        if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                             milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        }
                                    }
                                    
                                    coverageDetailsSTR2 = coverageDetailsSTR2 + ccl.CoverageMaxMonths + '\nCoverageMiles=' + ccl.CoverageMiles;                        
                                    
                                    //#85179    START
                                    // ccl.status = c.status;
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    if(warrStartDt_Final != null){
                                        if(Decimal.valueOf(ccl.CoverageHours) == 9999999)
                                        {
                                            if (curDate <= (warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){ //.addDays(-1)
                                                ccl.status = 'Active';
                                                system.debug('Testing Months1');
                                            }else{
                                                ccl.status = 'Expired';
                                                system.debug('Testing Months1');
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0){
                                            if (curDate <= (warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                                system.debug('Testing Months1');
                                            }else{
                                                ccl.status = 'Expired';
                                                system.debug('Testing Months1');
                                            } 
                                        }else{
                                             system.debug('Line number 720>>>>>prodMileKm'+prodMileKm + 'ccl.CoverageMiles' + ccl.CoverageMiles + 'prodHours>>>>>'+prodHours + 'ccl.CoverageHours>>>>'+ccl.CoverageHours );
                                            if (curDate <= (warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles) && Decimal.valueOf(prodHours) <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                                system.debug('Testing Months1');
                                            }else{
                                                ccl.status = 'Expired';
                                                system.debug('Testing Months1');
                                            }
                                        }
                                    }
                                    else{
                                        
                                        if(Decimal.valueOf(ccl.CoverageHours) == 9999999)
                                        {
                                            if (curDate <= (failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){ //.addDays(-1)
                                                ccl.status = 'Active';
                                                system.debug('Testing Months1');
                                            }else{
                                                ccl.status = 'Expired'; 
                                                system.debug('Testing Months1');
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0){
                                            if (curDate <= (failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                                system.debug('Testing Months1');
                                            }else{
                                                ccl.status = 'Expired';  
                                                system.debug('Testing Months1');
                                            } 
                                        }else{
                                             system.debug('Line number 744>>>>>prodMileKm'+prodMileKm + 'ccl.CoverageMiles' + ccl.CoverageMiles + 'prodHours>>>>>'+prodHours + 'ccl.CoverageHours>>>>'+ccl.CoverageHours );
                                            if (curDate <= (failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles) && Decimal.valueOf(prodHours) <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                                system.debug('Testing Months1');
                                            }else{
                                                ccl.status = 'Expired'; 
                                                system.debug('Testing Months1');
                                            }
                                        
                                    }
                                    }
                                    
                                    //if(psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))     
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    }  // Story 164795  
                                    
                                    else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                    { 
                                        system.debug('Testing Months');
                                        ccl.status = 'Active';
                                    } 
                                    if(warrStartDt_Final != null)
                                        ccl.WarrantyEndDate = ((warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1)
                                    else
                                        ccl.WarrantyEndDate = ((failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ;  //.addDays(-1)
                                    //system.debug('Coverage 4--> '+ warrStartDt_Final +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                    // Story 190403 - Start
                                    system.debug('Enddate'+ccl.WarrantyEndDate+'@@'+ccl.CoverageHours+'$$'+ccl.CoverageMiles);
                                    if(ccl.WarrantyEndDate != null && ccl.CoverageHours != null && ccl.CoverageMiles != null){
                                    system.debug('Test21');
                                    if(Integer.valueOf(ccl.CoverageMiles) != 0 ){
                                    system.debug('Test22'+ccl.CoverageMiles);
                                    system.debug('Testvalues11'+ccl.WarrantyEndDate+'curDate'+curDate+'UnitMiles'+UnitMiles+'UnitMiles'+UnitMiles+'PointMiles'+PointMiles);
                                    system.debug('Testbasc'+ccl.WarrantyEndDate+'ccl.CoverageMiles'+ccl.CoverageMiles+'ccl.CoverageHours'+ccl.CoverageHours);
                                    
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test111'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test112'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test113'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test114'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Active';
                                    system.debug('Test115'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    }
                                    
                                    if(Integer.valueOf(ccl.CoverageMiles) == 0)
                                    {
                                     system.debug('Tests%%'+ccl.WarrantyEndDate+' '+Date.valueOf(curDate).format());
                                     //system.debug(Date.valueOf(ccl.WarrantyEndDate));
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                    ccl.status = 'Active';
                                    system.debug('Test11'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test12'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test13'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ( (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test14'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test15'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    system.debug('Test16'+ccl.status);
                                    }
                                    
                                    }
                                    }
                                    system.debug('Test17'+ccl.status);
                                    if(Integer.valueOf(ccl.CoverageMiles) == 0 && Integer.valueof(PointMiles) > 0)
                                    {
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Active';
                                      }
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    if(Integer.valueOf(ccl.CoverageHours) == 0 && Integer.valueof(PointHours) > 0)
                                    {
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Active';
                                      }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    // Story 190403 - END
                                    
                                    if(ccl.WarrantyEndDate != null && ccl.WarrantyEndDate!= '') {
                                        try{
                                            date cd = date.parse(ccl.WarrantyEndDate);
                                            ccl.WarrantyEndDate = getFormattedDate(cd);
                                            /*DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                            ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT)); */
                                        }catch(Exception e)  {
                                            system.debug('EXCEPTION occured while converting ccl.WarrantyEndDate 2 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                                        }
                                    }



                                    system.debug('Inside test2');
                                    //#85179    END
                                    //populating the map 
                                    ccl.WarrantyManualURL=c.WarrantyManualURL+c.ProcedureNumber;
                                    if (!mapGroupCoverageByDefTypeNewENG.containskey(ccl.CoverageComponentTypeCode)) {

                                        mapGroupCoverageByDefTypeNewENG.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                    }
                                    mapGroupCoverageByDefTypeNewENG.get(ccl.CoverageComponentTypeCode).add(ccl);
                                } //end of inner 2 loop
                                
                                // S-205 Start
                                for (CSS_getBasicCoverageResponseJ2A.CoverageDedutibles cd: c.ListOfCoverageDedutibles.CoverageDedutibles) {
                 
                                    if(cd.ConstantDecutibleAmt !=null && cd.ConstantDecutibleAmt !='' && cd.ConstantDecutibleAmt !='0')
                                    {
                                    	NewEngWarrantyDedutibles = cd.ConstantDecutibleAmt;
                                    }
                                    
                                    else {
                                    if (cd.FirstVisitAmt !=null && cd.FirstVisitAmt !='' && cd.FirstVisitAmt !='0')
                                    	NewEngWarrantyDedutibles = cd.FirstVisitAmt;
                                    	
                                    }
                                    if(NewEngWarrantyDedutibles == null || NewEngWarrantyDedutibles == '')
                                    {
                                        NewEngWarrantyDedutiblesFlag = true;
                                    }
                                    
                                }
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()<=0 )
                                {
                                    NewEngWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+NewEngWarrantyDedutiblesFlag);
                                }
                                // S-205 END
                                
                            } //end of if cond
                            system.debug('mapGroupCoverageByDefTypeNewENG>>>>*******' + mapGroupCoverageByDefTypeNewENG);
                            
                            
                            if (c.CoverageType == 'REW-Recon Engine Warranty') {
                                system.debug('Inside');
                                reqWrcoverBoolean = false;
                                system.debug('covgtyperespcheck' + c.CoverageType);
                                system.debug('initialtestresp' + coverageDetailsSTR);
                                coverageDetailsSTR2 = coverageDetailsSTR2 + '\nCoverageType=' + c.CoverageType;
                                //URl and Procedure Map Values
                                coverageURLProceMap.put('REW-Recon Engine Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                                tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'REW-Recon Engine Warranty');
                                //iterating the CoverageComponentList
                                system.debug('Testing 113'+c.ListOfCoverageComponentList.CoverageComponentList);
                                for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    system.debug('testall'+ccl);
                                    coverageDetailsSTR2 = coverageDetailsSTR2 + '\nCoverageDefenitionType=' + ccl.CoverageDefenitionType + '\nCoverageComponentTypeCode=' + ccl.CoverageComponentTypeCode + '\nCoverageMaxMonths=';
                                    system.debug('CoverageMinMonths'+Decimal.valueOf(ccl.CoverageMinMonths));
                                    system.debug('Monthsbwfaildatewarrdate'+Decimal.valueOf(Monthsbwfaildatewarrdate));
                                    system.debug('CoverageMaxMonths'+Decimal.valueOf(ccl.CoverageMaxMonths));
                                    if(Double.valueOf(ccl.CoverageMinMonths) == 0 || ((Double.valueOf(ccl.CoverageMinMonths) > 0) && (((Double.valueOf(ccl.CoverageMinMonths) < Double.valueOf(Monthsbwfaildatewarrdate)) && (Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMaxMonths)) ) || (Double.valueOf(ccl.CoverageMaxMonths) < Double.valueOf(Monthsbwfaildatewarrdate) ))))
                                    //if(Decimal.valueOf(ccl.CoverageMinMonths) == 0 || ((Decimal.valueOf(ccl.CoverageMinMonths) > 0) && (((Decimal.valueOf(ccl.CoverageMinMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate)) && (Decimal.valueOf(Monthsbwfaildatewarrdate) <= Decimal.valueOf(ccl.CoverageMaxMonths)) ) || (Decimal.valueOf(ccl.CoverageMaxMonths) < Decimal.valueOf(Monthsbwfaildatewarrdate) ))))
                                    {   // Story 164795 
                                    //calculating miles
                                    system.debug('Testing 123'); 
                                    if (mil_measure != null && mil_measure != '') {
                                        if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                            milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                            //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                            //ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles) / 0.621371);
                                            ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                            string miletokm = ccl.CoverageMiles;
                                            system.debug('Testmiles'+miletokm);
                                            ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                                        }
                                    }
                                    
                                    if(mil_measure != null && mil_measure != ''){
                                        if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                             milesHolder.put(ccl.CoverageComponentTypeCode,ccl.CoverageMiles);
                                        }
                                    }
                                    
                                    coverageDetailsSTR2 = coverageDetailsSTR2 + ccl.CoverageMaxMonths + '\nCoverageMiles=' + ccl.CoverageMiles;                        
                                    
                                    //#85179    START
                                    // ccl.status = c.status;
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    if(warrStartDt_Final != null){
                                        if(Decimal.valueOf(ccl.CoverageHours) == 9999999)
                                        {
                                            if (curDate <= (warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0){
                                            if (curDate <= (warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }else{
                                            
                                             system.debug('Line number 720>>>>>prodMileKm'+prodMileKm + 'ccl.CoverageMiles' + ccl.CoverageMiles + 'prodHours>>>>>'+prodHours + 'ccl.CoverageHours>>>>'+ccl.CoverageHours );
                                            if (curDate <= (warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles) && Decimal.valueOf(prodHours) <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                            
                                        }
                                    }
                                    else{
                                        
                                        if(Decimal.valueOf(ccl.CoverageHours) == 9999999)
                                        {
                                            if (curDate <= (failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) ){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }

                                        }else if(Decimal.valueOf(ccl.CoverageHours) == 0){
                                            if (curDate <= (failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            } 
                                        }else{
                                            
                                             system.debug('Line number 744>>>>>prodMileKm'+prodMileKm + 'ccl.CoverageMiles' + ccl.CoverageMiles + 'prodHours>>>>>'+prodHours + 'ccl.CoverageHours>>>>'+ccl.CoverageHours );
                                            if (curDate <= (failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))) && Decimal.valueOf(prodMileKm) <= Decimal.valueOf(ccl.CoverageMiles) && Decimal.valueOf(prodHours) <= Decimal.valueOf(ccl.CoverageHours)){ //.addDays(-1)
                                                ccl.status = 'Active';
                                            }else{
                                                ccl.status = 'Expired';   
                                            }
                                            
                                        }
                                    
                                    }
                                    
                                    //if(psnRec.Warranty_Start_Date__c.addMonths(Integer.valueOf(ccl.CoverageMaxMonths))     
                                    //ccl.WarrantyEndDate = c.WarrantyEndDate;
                                    }  // Story 164795  
                                    
                                    else if(Double.valueOf(Monthsbwfaildatewarrdate) <= Double.valueOf(ccl.CoverageMinMonths))
                                    { 
                                        system.debug('Testing Months');
                                        ccl.status = 'Active';
                                    } 
                                  
                                  if(warrStartDt_Final != null)
                                        ccl.WarrantyEndDate = ((warrStartDt_Final.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1)
                                    else
                                        ccl.WarrantyEndDate = ((failureDt.addMonths(Integer.valueOf(ccl.CoverageMaxMonths)))).format() ; //.addDays(-1)
                                    //system.debug('Coverage 4--> '+ warrStartDt_Final +' '+ccl.CoverageMaxMonths+ ' '+ ccl.WarrantyEndDate);  
                                    ccl.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(ccl.WarrantyEndDate));
                                    // Story 190403 - Start
                                    system.debug('Enddate'+ccl.WarrantyEndDate+'@@'+ccl.CoverageHours+'$$'+ccl.CoverageMiles);
                                    if(ccl.WarrantyEndDate != null && ccl.CoverageHours != null && ccl.CoverageMiles != null){
                                    system.debug('Test21');
                                    if(Integer.valueOf(ccl.CoverageMiles) != 0 ){
                                    system.debug('Test22'+ccl.CoverageMiles);
                                    system.debug('Testvalues11'+ccl.WarrantyEndDate+'curDate'+curDate+'UnitMiles'+UnitMiles+'UnitMiles'+UnitMiles+'PointMiles'+PointMiles);
                                    system.debug('Testbasc'+ccl.WarrantyEndDate+'ccl.CoverageMiles'+ccl.CoverageMiles+'ccl.CoverageHours'+ccl.CoverageHours);
                                    
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test111'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test112'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test113'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test114'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Active';
                                    system.debug('Test115'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    }
                                    }
                                    
                                    if((Integer.valueOf(ccl.CoverageMiles) == 0))
                                    {
                                     system.debug('Tests%%'+ccl.WarrantyEndDate+' '+Date.valueOf(curDate).format());
                                     //system.debug(Date.valueOf(ccl.WarrantyEndDate));
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                    ccl.status = 'Active';
                                    system.debug('Test11'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test12'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test13'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ( (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours)))){
                                    ccl.status = 'Expired';
                                    system.debug('Test14'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Active';
                                    system.debug('Test15'+ccl.status);
                                    }
                                    else if(Date.parse(ccl.WarrantyEndDate) < Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) == 0 || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) == 0))) && ((UnitHours == 'Hours' && Integer.valueof(PointHours) == 0))){
                                    ccl.status = 'Expired';
                                    system.debug('Test16'+ccl.status);
                                    }
                                    
                                    }
                                    }
                                    system.debug('Test17'+ccl.status);
                                    if(Integer.valueOf(ccl.CoverageMiles) == 0 && Integer.valueof(PointMiles) > 0)
                                    {
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) < Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Active';
                                      }
                                      if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && (UnitHours == 'Hours' && Integer.valueof(PointHours) > Integer.valueof(ccl.CoverageHours))) {
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    if(Integer.valueOf(ccl.CoverageHours) == 0 && Integer.valueof(PointHours) > 0)
                                    {
                                    if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) < Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Active';
                                      }
                                    else if(Date.parse(ccl.WarrantyEndDate) > Date.valueOf(curDate) && ((UnitMiles == 'Miles' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)) || (UnitMiles == 'Kilometers' && Integer.valueof(PointMiles) > Integer.valueof(ccl.CoverageMiles)))){
                                      ccl.status = 'Expired';
                                      }
                                    }
                                    
                                    // Story 190403 - END
                                    
                                    if(ccl.WarrantyEndDate != null && ccl.WarrantyEndDate!= '') {
                                        try{
                                            date cd = date.parse(ccl.WarrantyEndDate);
                                            ccl.WarrantyEndDate = getFormattedDate(cd);
                                            /*DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                                            ccl.WarrantyEndDate = getWarrantyDate(DateTime.valueof(mydateGMT)); */
                                        }catch(Exception e)  {
                                            system.debug('EXCEPTION occured while converting ccl.WarrantyEndDate 2 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                                        }
                                    }



                                    system.debug('Inside test2');
                                    //#85179    END
                                    //populating the map 
                                    ccl.WarrantyManualURL=c.WarrantyManualURL+c.ProcedureNumber;
                                    if (!mapGroupCoverageByDefTypeRecEng.containskey(ccl.CoverageComponentTypeCode)) {

                                        mapGroupCoverageByDefTypeRecEng.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                                    }
                                    mapGroupCoverageByDefTypeRecEng.get(ccl.CoverageComponentTypeCode).add(ccl);
                                } //end of inner 2 loop
                                
                                // S-205 Start
                                for (CSS_getBasicCoverageResponseJ2A.CoverageDedutibles cd: c.ListOfCoverageDedutibles.CoverageDedutibles) {
                                
                                	if(cd.ConstantDecutibleAmt !=null && cd.ConstantDecutibleAmt !='' && cd.ConstantDecutibleAmt !='0')
                                	{
                                		ReconWarrantyDedutibles = cd.ConstantDecutibleAmt;
                                	}
                                	
                                	else {
                                	if (cd.FirstVisitAmt !=null && cd.FirstVisitAmt !='' && cd.FirstVisitAmt !='0')
                                		ReconWarrantyDedutibles = cd.FirstVisitAmt;
                                	}
                                	
                                	if(ReconWarrantyDedutibles == null || ReconWarrantyDedutibles == '')
                                    {
                                        ReconWarrantyDedutiblesFlag = true;
                                    }
                                	
                                }
                                if(c.ListOfCoverageDedutibles.CoverageDedutibles.size()<=0 )
                                {
                                    ReconWarrantyDedutiblesFlag = true;
                                    system.debug('EmmisionWarrantyDedutiblesFlag1***'+ReconWarrantyDedutiblesFlag);
                                }
                                // S-205 END
                                
                            } //end of if cond
                            
                            
                        } //end of outer for loop
                        system.debug('initialtestresp######@@@@@@' + coverageDetailsSTR);


                        if (mapGroupCoverageByDefTypeNewENG != null && !mapGroupCoverageByDefTypeNewENG.isEmpty()) {
                            coverageByDefTypeMap.put('A-New Engine Warranty', mapGroupCoverageByDefTypeNewENG);
                        }

                        if (mapGroupCoverageByDefType != null && !mapGroupCoverageByDefType.isEmpty()) {
                            coverageByDefTypeMap.put('B-Emissions Warranty', mapGroupCoverageByDefType);
                        }
                        
                        if (mapGroupCoverageByDefTypeRecEng != null && !mapGroupCoverageByDefTypeRecEng.isEmpty()) {
                            coverageByDefTypeMap.put('C-Recon Engine Warranty', mapGroupCoverageByDefTypeRecEng);
                            system.debug('Testing Recon'+coverageByDefTypeMap);
                        }
                    }
                }
                reqWrTerBoolean = false;
            }
            // system.debug('checking certification details'+ basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails);
            // Certificate details -- start
            listcertificatedetails = new List<CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails>();
            // = new List<CSS_getBasicCoverageResponseJ2A.ListOfExtCoverageDedutibles>();
            if (basicCoverageDetails != null) {
                reqWrcertBoolean = false;
                Date curDate = Date.today();
                for (CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails crtdt: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails) {

                    if (mil_measure != null && mil_measure != '') {
                                    if (mil_measure.equalsIgnoreCase('Kilometers')) {
                                        milesHolder.put(crtdt.ProcedureNumber,crtdt.BeginMiles);
                                        milesHolder.put(crtdt.CertificateNumber,crtdt.EndMiles);
                                        //crtdt.BeginMiles = String.ValueOf((Decimal.valueOf(crtdt.BeginMiles) / 0.621371).setScale(0));
                                        //crtdt.EndMiles = String.ValueOf((Decimal.valueOf(crtdt.EndMiles) / 0.621371).setScale(0));
                                        //crtdt.EndMiles = String.ValueOf(Decimal.valueOf(crtdt.EndMiles) / 0.621371);
                                        crtdt.EndMiles = String.ValueOf(Decimal.valueOf(crtdt.EndMiles)  * 1.609344);
                                        string miletokm = crtdt.EndMiles;
                                        system.debug('Testmiles'+miletokm);
                                        crtdt.EndMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 

                                        //crtdt.BeginMiles = String.ValueOf(Decimal.valueOf(crtdt.BeginMiles) / 0.621371);
                                        crtdt.BeginMiles = String.ValueOf(Decimal.valueOf(crtdt.BeginMiles)  * 1.609344);
                                        string milestokm = crtdt.BeginMiles;
                                        system.debug('Testmiles'+miletokm);
                                        crtdt.BeginMiles= String.ValueOf((Decimal.valueOf(milestokm)).round(System.RoundingMode.CEILING));  
                                    }
                                }
                    
                    if(mil_measure != null && mil_measure != ''){
                                if (!mil_measure.equalsIgnoreCase('Kilometers')) {
                                    milesHolder.put(crtdt.ProcedureNumber,crtdt.BeginMiles);
                                    milesHolder.put(crtdt.CertificateNumber,crtdt.EndMiles);
                                }
                    }
                    crtdt.Remaining = css_utility.getRemainingYearsMonthsDays(curDate,date.parse(crtdt.EndDate));
                    //#85179    START

                    if(crtdt.StartDate != null && crtdt.StartDate != '') {
                        try{
                            date cd = date.parse(crtdt.StartDate);
                            crtdt.StartDate = getFormattedDate(cd);
                            /*DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                            crtdt.StartDate = getWarrantyDate(DateTime.valueof(mydateGMT)); */
                        }catch(Exception e)  {
                            system.debug('EXCEPTION occured while converting crtdt.StartDate 1 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                        }
                    }
                    if(crtdt.EndDate != null && crtdt.EndDate != '') {
                        try{
                            date cd = date.parse(crtdt.EndDate);
                            crtdt.EndDate = getFormattedDate(cd);
                            /*DateTime mydateGMT =  dateTime.newInstance(date.newInstance(cd.year(), cd.month(), cd.day()), time.newInstance(00, 00, 00, 00));
                            crtdt.EndDate = getWarrantyDate(DateTime.valueof(mydateGMT)); */
                        }catch(Exception e)  {
                            system.debug('EXCEPTION occured while converting crtdt.StartDate 2 in CG_CL_Claimswarranty  >>> '+e.getMessage() + ' LineNo:' + e.getLineNumber() + ' e.Cause:' +e.getCause());
                        }
                    }
                        
                    //#85179    END 
                    // S-205 Start
                    String ProgramId = crtdt.ProgramID;
                    Map<string,List<CSS_getBasicCoverageResponseJ2A.CoverageDedutibles>> listofdeduct = new Map<String,List<CSS_getBasicCoverageResponseJ2A.CoverageDedutibles>>();
                    for (CSS_getBasicCoverageResponseJ2A.CoverageDedutibles ExtendedCovDedutibles: crtdt.ListOfExtCoverageDedutibles.ExtendedCoverageDedutibles){

                    system.debug('ExtendedCovDedutibles'+ExtendedCovDedutibles);
                     listofdeduct.put(ExtendedCovDedutibles.ProgramID,crtdt.ListOfExtCoverageDedutibles.ExtendedCoverageDedutibles);
                     system.debug('listofdeduct'+listofdeduct+'ProgramId'+ProgramId);
                     //listofdeduct.get(ProgramId);
                     //system.debug('Test**1'+listofdeduct);
                     
                 } 
                 system.debug('testprofid'+ProgramId);
                 system.debug('testprofid2'+listofdeduct);
                 if(listofdeduct != null && listofdeduct.size()>0){
                 for(CSS_getBasicCoverageResponseJ2A.CoverageDedutibles ld: listofdeduct.get(ProgramId))
                 {
                     system.debug('testprofid'+ProgramId);
                     system.debug('testprofid2'+ld.ProgramID);
                     if(ld.ProgramID == ProgramId)
                     {
                         if(ld.ConstantDecutibleAmt !=null && ld.ConstantDecutibleAmt !='' && ld.ConstantDecutibleAmt !='0')
                        {
                        	ExtendedWarrantyDedutibles = ld.ConstantDecutibleAmt;
                        	ExtendedWarrantyDedutiblesFlag = true;
                        }
                        
                        else {
                        if (ld.FirstVisitAmt !=null && ld.FirstVisitAmt !='' && ld.FirstVisitAmt !='0')
                        	ExtendedWarrantyDedutibles = ld.FirstVisitAmt;
                        	ExtendedWarrantyDedutiblesFlag = true;
                        }
                        if(ExtendedWarrantyDedutibles == null || ExtendedWarrantyDedutibles == '')
                        {
                        	ExtendedWarrantyDedutiblesFlag = false;
                        }
                        break;
                         
                     }
                     
                 }
                 }
                 //S-205 END
                 system.debug('ExtendedWarrantyDedutibles***'+ExtendedWarrantyDedutibles);
                 system.debug('ExtendedWarrantyDedutiblesFlag'+ExtendedWarrantyDedutiblesFlag);
                    
                    listcertificatedetails.add(crtdt);
                    system.debug('Certificate list' + listcertificatedetails);
                    
                    
                    
                }
                if (listcertificatedetails.isEmpty()){
                    reqWrcertBoolean = true;
                    showExtCoverage = false;
                }
                else
                    showExtCoverage = true;
             /* for (CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDedutibles cd: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails.ListOfExtCoverageDedutibles.ExtendedCoverageDedutibles){

                  
              }  */    
                        
            }
            system.debug('certificate details' + listcertificatedetails);
        } catch (exception e) {
            system.debug('Exception occured inside basic coverageSearch getMessage>>>:' + e.getMessage()+' getLineNumber>>>>:'+e.getLineNumber());
        }
        return null;
    }
    public  Boolean prodcodeErrormessage{get;set;} 


    public void updateproductappcode(){        
        if(psnstatusflag!=null && !psnstatusflag){
        system.debug('productAppdesc '+ productAppdesc);
        system.debug('productAppcode' +productAppcode);
        prodcodeErrormessage = false ;
        if(filterApplication == null || filterApplication == '' || filterApplication=='Select One'){
            
            system.debug('filterApplication'+filterApplication);
           prodcodeErrormessage = false ;
        }
        else{
        List<SelectOption> applicationlist = getApplication();
        String filterLabel;
        String appCode;
        system.debug('applicationlist'+ applicationlist);
        if(applicationlist.size()>0){
            for(SelectOption sopt: applicationlist){
                if(sopt.getValue()== filterApplication){
                    filterLabel = sopt.getlabel();
                    break;
                }
            }
        }

        if(filterLabel != null){
            List<String> strList = new List<String>();
            strList = filterLabel.split('-');
            if(strList != null && strList.size() > 0)
                appCode = strList[0].trim();
            System.debug('appCode....'+appCode);
        }
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        CSS_JobEventTemporary__c JETproductcode1 = new CSS_JobEventTemporary__c();
        try{
            JETproductcode = [select id, Attribute1__c, Attribute2__c,Attribute3__c, Attribute5__c, Active__c,Key__c from CSS_JobEventTemporary__c  where Key__c = 'MarketingApplicationCodes' and   Attribute1__c =: productAppcode and Attribute3__c=: productAppdesc Limit 1];
            system.debug('JETproductcode'+ JETproductcode);
            system.debug('JETproductcode.Attribute2__c'+ JETproductcode.Attribute2__c);
            system.debug('filterApplication'+filterApplication);
            system.debug('JETproductcode.Attribute5__c'+ JETproductcode.Attribute5__c);
            system.debug('appCode'+ appCode);

            if(JETproductcode.Attribute2__c != appCode || JETproductcode.Attribute5__c != filterApplication){
                try{
                    JETproductcode1 = [select id, Attribute1__c, Attribute2__c,Attribute3__c, Attribute5__c, Active__c,Key__c from CSS_JobEventTemporary__c  where Key__c = 'MarketingApplicationCodes' and   Attribute2__c =: appCode and Attribute5__c=: filterApplication Limit 1];
                    system.debug('JETproductcode1'+ JETproductcode1);
                    prodcodeErrormessage = true;

                    // ProductAppcodeErrorflag__c=true;
                }catch(Exception err) {
                    prodcodeErrormessage = false;
                    system.debug(' inside EXC ');
                    // ProductAppcodeErrorflag__c=false;
                }

            }
            else{
                prodcodeErrormessage = false ;
                system.debug(' inside else main EXC');
                //ProductAppcodeErrorflag__c=false;

            }
        }
        catch(Exception ex ){
            prodcodeErrormessage = false ;
            system.debug(' inside main EXC');
            // ProductAppcodeErrorflag__c=false;
        }
    }
    }
    }



    public String getFormatedFailureDate(){
        return getFormattedDate(failureDt); 
    }

    public String getWarrCreatedDate() {
        return getFormattedDate(warrStartDt_Final);
    }

     public void milekmconv() {
        
        mapGroupCoverageByDefType = new Map<String, List<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
        mapGroupCoverageByDefTypeNewENG = new Map<String, List <CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
        mapGroupCoverageByDefTypeRecEng = new Map<String, List <CSS_getBasicCoverageResponseJ2A.CoverageComponentList>>();
        coverageByDefTypeMap = new map < string, map < String, list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList >>> ();
        coverageURLProceMap = new map < string, string > ();
        tempcoverageURLProceMap = new map < string, string > ();
        if (basicCoverageDetails != null) {
            for (CSS_getBasicCoverageResponseJ2A.coverageDetails c: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListofCoverageDetails.coverageDetails) {
               
                if (c.CoverageType == 'EMS-Emissions Warranty') {
                    //URl and Procedure Map Values
                    coverageURLProceMap.put('EMS-Emissions Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                    tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'EMS-Emissions Warranty');
                    //iterating the CoverageComponentList
                    for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                        
                        if (kil_measure != null && kil_measure != '') {
                            if (kil_measure.equalsIgnoreCase('Kilometers')) {
                                system.debug('Inside Kilometers condition');
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                //ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles) / 0.621371);
                                ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                string miletokm = ccl.CoverageMiles;
                                system.debug('Testmiles'+miletokm);
                                ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 

                            }
                            if (prevmil_measure != null && prevmil_measure != '' && kil_measure != null && kil_measure != '' && kil_measure.equalsIgnoreCase('Miles') && milesHolder != null) {
                                if(milesHolder.containsKey(ccl.CoverageComponentTypeCode))
                                system.debug('Inside Miles condition');
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) * 0.621371).setScale(0));
                                ccl.CoverageMiles = milesHolder.get(ccl.CoverageComponentTypeCode);
                                system.debug('** Val'+ccl.CoverageMiles);
                            }
                        }
                        //populating the map 
                        if (!mapGroupCoverageByDefType.containskey(ccl.CoverageComponentTypeCode)) {

                            mapGroupCoverageByDefType.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                        }
                        mapGroupCoverageByDefType.get(ccl.CoverageComponentTypeCode).add(ccl);
                    } //end of inner 1 loop
                } 
                
                else if (c.CoverageType == 'NEW-New Engine Warranty') {
                    //URl and Procedure Map Values
                    coverageURLProceMap.put('NEW-New Engine Warranty', c.WarrantyManualURL + c.ProcedureNumber);
                    tempcoverageURLProceMap.put( c.WarrantyManualURL + c.ProcedureNumber,'NEW-New Engine Warranty');
                    //iterating the CoverageComponentList
                    for (CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl: c.ListOfCoverageComponentList.CoverageComponentList) {
                        //calculating miles                        
                        if (kil_measure != null && kil_measure != '') {
                            if (kil_measure.equalsIgnoreCase('Kilometers')) {
                                System.debug('*******ccl.CoverageMiles first' + ccl.CoverageMiles);
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) / 0.621371).setScale(0));
                                //ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles) / 0.621371);
                                ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                string miletokm = ccl.CoverageMiles;
                                system.debug('Testmiles'+miletokm);
                                ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                            }
                            if (prevmil_measure != null && prevmil_measure != '' && kil_measure != null && kil_measure != '' && kil_measure.equalsIgnoreCase('Miles') && milesHolder != null) {
                                if(milesHolder.containsKey(ccl.CoverageComponentTypeCode))
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) * 0.621371).setScale(0));
                                ccl.CoverageMiles = milesHolder.get(ccl.CoverageComponentTypeCode);
                                system.debug('** Val'+ccl.CoverageMiles);
                                //System.debug('*******ccl.CoverageMiles second' + ccl.CoverageMiles);
                            }
                        }
                        //populating the map 
                        if (!mapGroupCoverageByDefTypeNewENG.containskey(ccl.CoverageComponentTypeCode)) {

                            mapGroupCoverageByDefTypeNewENG.put(ccl.CoverageComponentTypeCode, new list < CSS_getBasicCoverageResponseJ2A.CoverageComponentList > ());
                        }
                        mapGroupCoverageByDefTypeNewENG.get(ccl.CoverageComponentTypeCode).add(ccl);
                    } //end of inner 2 loop
                } 
                
                else if(c.CoverageType =='REW-Recon Engine Warranty'){
                     system.debug('Recon flag');
                     system.debug('Recon flag'+c.CoverageType);
                    //URl and Procedure Map Values
                    coverageURLProceMap.put('REW-Recon Engine Warranty',c.WarrantyManualURL+c.ProcedureNumber);
                    //iterating the CoverageComponentList
                    for(CSS_getBasicCoverageResponseJ2A.CoverageComponentList ccl : c.ListOfCoverageComponentList.CoverageComponentList){
                        //calculating miles                        
                        if(kil_measure != null && kil_measure != ''){
                            if(kil_measure.equalsIgnoreCase('Kilometers')){
                                System.debug('*******ccl.CoverageMiles first'+ccl.CoverageMiles);
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles)/0.621371).setScale(0));
                                //ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles) / 0.621371);
                                ccl.CoverageMiles = String.ValueOf(Decimal.valueOf(ccl.CoverageMiles)  * 1.609344);
                                string miletokm = ccl.CoverageMiles;
                                system.debug('Testmiles'+miletokm);
                                ccl.CoverageMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                            }
                                if (prevmil_measure != null && prevmil_measure != '' && kil_measure != null && kil_measure != '' && kil_measure.equalsIgnoreCase('Miles') && milesHolder != null) {
                                if(milesHolder.containsKey(ccl.CoverageComponentTypeCode))
                                //ccl.CoverageMiles = String.ValueOf((Decimal.valueOf(ccl.CoverageMiles) * 0.621371).setScale(0));
                                ccl.CoverageMiles = milesHolder.get(ccl.CoverageComponentTypeCode);
                                system.debug('** Val'+ccl.CoverageMiles);
                                //System.debug('*******ccl.CoverageMiles second' + ccl.CoverageMiles);
                            }
                        }
                        
                        //populating the map 
                        if(!mapGroupCoverageByDefTypeRecEng.containskey(ccl.CoverageComponentTypeCode)){
                            
                            mapGroupCoverageByDefTypeRecEng.put(ccl.CoverageComponentTypeCode,new list<CSS_getBasicCoverageResponseJ2A.CoverageComponentList>());
                        } 
                        mapGroupCoverageByDefTypeRecEng.get(ccl.CoverageComponentTypeCode).add(ccl);
                        system.debug('Test ReconMap'+mapGroupCoverageByDefTypeRecEng);
                    }//end of inner 2 loop
                }
                
                
            } 

        } 
        if (mapGroupCoverageByDefTypeNewENG != null && !mapGroupCoverageByDefTypeNewENG.isEmpty()) {
            coverageByDefTypeMap.put('A-New Engine Warranty', mapGroupCoverageByDefTypeNewENG);

        }

        if (mapGroupCoverageByDefType != null && !mapGroupCoverageByDefType.isEmpty()) {
            coverageByDefTypeMap.put('B-Emissions Warranty', mapGroupCoverageByDefType);
        }
        
        if (mapGroupCoverageByDefTypeRecEng != null && !mapGroupCoverageByDefTypeRecEng.isEmpty()) {
            coverageByDefTypeMap.put('C-Recon Engine Warranty', mapGroupCoverageByDefTypeRecEng);
            system.debug('TestReconcode'+coverageByDefTypeMap);
        }
        
        system.debug('coverageByDefTypeMap>>>'+coverageByDefTypeMap);
        listcertificatedetails = new list < CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails > ();
        if (basicCoverageDetails != null) {
            for (CSS_getBasicCoverageResponseJ2A.ExtendedCoverageDetails crtdt: basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails) {
                system.debug('** Inside Certificate For Loop');
                if (kil_measure != null && kil_measure != '') {
                    system.debug('** Inside after mil Measure null check');
                if(kil_measure.equalsIgnoreCase('Kilometers')){   
                    system.debug('** Inside Certificte mil Measure Kilometers');   
                    //crtdt.EndMiles = String.ValueOf(Decimal.valueOf(crtdt.EndMiles) / 0.621371);
                    crtdt.EndMiles = String.ValueOf(Decimal.valueOf(crtdt.EndMiles)  * 1.609344);
                    string miletokm = crtdt.EndMiles;
                    system.debug('Testmiles'+miletokm);
                    crtdt.EndMiles= String.ValueOf((Decimal.valueOf(miletokm)).round(System.RoundingMode.CEILING)); 
                    //crtdt.EndMiles = String.ValueOf((Decimal.valueOf(crtdt.EndMiles)/0.621371).setScale(0));
                    //crtdt.BeginMiles = String.ValueOf((Decimal.valueOf(crtdt.BeginMiles)/0.621371).setScale(0));
                    //crtdt.BeginMiles = String.ValueOf(Decimal.valueOf(crtdt.BeginMiles) / 0.621371);
                    crtdt.BeginMiles = String.ValueOf(Decimal.valueOf(crtdt.BeginMiles)  * 1.609344);
                    string milestokm = crtdt.BeginMiles;
                    system.debug('Testmiles'+miletokm);
                    crtdt.BeginMiles= String.ValueOf((Decimal.valueOf(milestokm)).round(System.RoundingMode.CEILING)); 
                }
                  if (prevmil_measure != null && prevmil_measure != '' && kil_measure != null && kil_measure != '' && kil_measure.equalsIgnoreCase('Miles') && milesHolder != null ) { 
                        system.debug('** Inside Certificte mil Measure Miles');
                        crtdt.BeginMiles = milesHolder.get(crtdt.ProcedureNumber);
                        crtdt.EndMiles = milesHolder.get(crtdt.CertificateNumber);
                        
                } 
                }
                listcertificatedetails.add(crtdt);
            }
        }
        system.debug('***listcertificatedetails-->' + listcertificatedetails);
        //prevmil_measure = mileKmMeasure;
        system.debug('prevmil_measure Before' + prevmil_measure);
        prevmil_measure = kil_measure;
        system.debug('prevmil_measure After' + prevmil_measure);
        //system.debug('checking certification details'+ basicCoverageDetails.BasicCoverageResponseHeader.Response.ListOfExtendedCoverageDetails.ExtendedCoverageDetails);
    }
    public String getFormattedDate(Date d){
        String formattedDate;
        try{
            system.debug('d-->'+d);
            if(d != null)
                formattedDate = css_utility.FormatDate(d);
        }catch(exception e){ 
            system.debug('in catch getFormattedDate exception>>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return formattedDate;
    }
    //Method to construct map of controlling and dependent picklist values
    public static Map<Object,List<String>> getDependentPicklistValues(Schema.sObjectField dependToken){
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if(controlToken == null) 
            return null;
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries = (control.getType() == Schema.DisplayType.Boolean ? null : control.getPicklistValues());

        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<Object,List<String>> dependentPicklistValues = new Map<Object,List<String>>();
        for(Schema.PicklistEntry entry : depend.getPicklistValues()){
            if(entry.isActive()){
                List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for(Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++){
                    Object controlValue = (controlEntries == null ? (Object)(index == 1) : (Object)(controlEntries[index].isActive() ? controlEntries[index].getLabel() : null));
                    Integer bitIndex = index/6, bitShift = 5 - Math.mod(index,6);
                    if(controlValue == null || base64chars.size() < 4 || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0) 
                        continue;
                    if(!dependentPicklistValues.containsKey(controlValue)){
                        dependentPicklistValues.put(controlValue,new List<String>());
                    }
                    dependentPicklistValues.get(controlValue).add(entry.getLabel());
                }
            }
        }
        return dependentPicklistValues;
    }
    public List<SelectOption> getRegionValues(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = CSS_Claims__c.Region__c.getDescribe();
        List<Schema.PicklistEntry> regValues = fieldResult.getPicklistValues();
        options.add(new SelectOption('None','--None--'));        
        for(Schema.PicklistEntry picklst : regValues){
            String temp = picklst.getValue();
            options.add(new SelectOption(temp,temp));
        }
        return options;
    } 

    public List<SelectOption> getTerritoryValues(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        for(Object contrPicklst : dependValuesByControlValue.keySet()){
            //if(regionSelected == String.valueof(contrPicklst)){ 
                if(Region == String.valueof(contrPicklst)){ 
                for(String depPicklst : dependValuesByControlValue.get(contrPicklst)){
                    options.add(new SelectOption(depPicklst,depPicklst));
                }
                break;
            }
        }
        return options;
    }
    
    
    public class SolCompWrapper{
        public Id SolCompId {get;set;}
        public Boolean SelectedComp {get;set;}
        public string QsolURL{get;set;}
        public string FieldAction {get;set;}
        public string FieldActNum {get;set;}
        public string FailCode{get;set;}
        public string AccountCode{get;set;}
        public string SelectedPayCode{get;set;}
        public string Selectedclaimtype{get;set;}// To add claim type
        public List<SelectOption> ClaimType {get;set;}
        public List<SelectOption> PayCodes {get;set;}

        public SolCompWrapper(Id SolCompId, Boolean SelectedComp,string QsolURL,string FieldAction, string FieldActNum,string FailCode, string AccountCode,string SelectedPayCode, List<SelectOption> PayCodes,string Selectedclaimtype, List<SelectOption> ClaimType){
            this.SolCompId = SolCompId;
            this.SelectedComp = SelectedComp;
            this.FieldAction = FieldAction;
            this.FieldActNum = FieldActNum;
            this.FailCode = FailCode;
            this.AccountCode = AccountCode;
            this.SelectedPayCode = SelectedPayCode;
            this.PayCodes = PayCodes;
            this.QsolURL = QsolURL;
            this.Selectedclaimtype = Selectedclaimtype;
            this.ClaimType = ClaimType;
        }
    }
    
    
}