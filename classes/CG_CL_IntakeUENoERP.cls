/**********************************************************************
Name:CG_CL_IntakeUENoERP
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is used for NoERP system's Unit&Engine functionalities
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M         12/20/2017      Redesigning Development                    
***********************************************************************/ 
public class CG_CL_IntakeUENoERP {

    //Global Veriables
    public CG_CL_IntakeUE mainContr{set; get;}
    public CG_CL_IntakeVH mainContrVH{set; get;}
    public CG_CL_IntakeRJ mainContrRJ{set; get;}
    public String PageName {get;set;}

    public Date EtoConversion{get;set;}  //added by moulika
    public String ESN{get;set;} //added by moulika

    public Date billdateVal{get;set;} //added by moulika

    public boolean faildtwsdtflag{get;set;}//Story 147384 Rupesh
    public boolean faildtshdtflag{get;set;}//Story 147384 Rupesh

    public ID Wid {get;set;}

    public Boolean show_ue_pnl {get; set;}
    public boolean bmsEnabled {get;set;}

    public Boolean displaySrvModPopup {get;set;}

    public string errorMessage{get;set;}
    public string equipmentId {get;set;}//added by Agassi for story 144598
    public string sEngineFamilyCode {get; set;}

    public date siebelWarrantyDate=null;
    public String siebelSMN;
    public string siebVIN;
    public string siebAppCode;
    public string WrapperRequestEng;

    public boolean showOutageError{get;set;}
    public boolean showOutageError1{get;set;} //ROD 111715 & 111716 by venkat
    public Boolean recconFlag{get;set;} //ROD Defect 111715 & 111716 by venkat

    //public string sServiceModel {get; set;}

    public boolean psncheck{get;set;}
    public boolean HHSPSMNFlg{get;set;}
    public boolean HHSPACCSFlg{get;set;}
     public string sServiceModel {get; set;}
    public string sWarrantyDt {get; set;}

    public string mil_measure;
    public string fail_measure;
    public Boolean displayPopup7 {get;set;}
    public Boolean displaycertPopup {get;set;}
    public Boolean displaySrvModPopup1 {get;set;}
    Public string state{get;set;}
    Public string failuredthidden{get;set;}
    public string productAppcode{get;set;}
    public string productAppdesc{get;set;}
 public boolean prodcodeErrormessage{get;set;}
    /* Added as per Story# 64030 start*/
    public String filterApplication {get;set;}
    public String filterCategory;
    public String filterCategory2;
    public String filterCategory3;
    public String filterCategory4;
    public String filterCategory5;

    public String filterComplaintType;
    public String filterComplaintType2;
    public String filterComplaintType3;
    public String filterComplaintType4;
    public String filterComplaintType5;
    /* Added as per Story# 64030 end*/

    public DateTime dt_WarrantyDt { get; set; }

    public String getWarrantyDate() {
        //css_utility cUtil = new css_utility();
        String locale_formatted_date_time_value='';
        if(dt_WarrantyDt!=null){
            locale_formatted_date_time_value= dt_WarrantyDt.format('dd MMM YYYY', 'GMT'); //Get formatted String from Utility Class
        }
        return locale_formatted_date_time_value; //return the string
    }

    public DateTime dt_FailureDt { get; set; }

    public String getFailureDt() {
        //css_utility cUtil = new css_utility();
        String locale_formatted_date_time_value='';
        if(dt_FailureDt != null){
            locale_formatted_date_time_value = dt_FailureDt.format('dd MMM YYYY', 'GMT'); //Get formatted String from Utility Class
        }
        return locale_formatted_date_time_value; //return the string
    }    

    //public String appCode;
    public string EmailAddress {get;set;}
    public string EmailAddress1 {get;set;}
    //map<string,string> mapDescriptionToCode;
    //public string selectedLocation {get;set;}
    public string comm {get;set;}
    List<SelectOption> options;

    Transient public List<CSS_CampTsbTrp__c> lstCAM {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTRP {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTSB {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstATC {get; set;}

    Transient List<CSS_CampTsbTrp__c> qsolCTTP {get;set;}
    Transient map<string,CSS_CampTsbTrp__c> qsolCTTPMap = new map<string,CSS_CampTsbTrp__c>(); //Defect fix 95870
    Transient map<string,CSS_CampTsbTrp__c> qsolCampMap = new map<string,CSS_CampTsbTrp__c>(); //Defect 95870 fix
    @testvisible Transient List<CSS_CampTsbTrp__c> lstQSOLDocs;
    //Transient List<AggregateResult> lmake = new List<AggregateResult>();
    //Transient List<CSS_Make_Model_Access__c> lmodel = new List<CSS_Make_Model_Access__c>();

    Transient List<AggregateResult> lcountry = new List<AggregateResult>();
    Transient List<CSS_CountryStateValues__c> lstate = new List<CSS_CountryStateValues__c>();

    Transient List<AggregateResult> lUnitType = new List<AggregateResult>();
    Transient List<CSS_JobEventTemporary__c> lSubType = new List<CSS_JobEventTemporary__c>();

    public boolean callStartRequestFromBMSPopup; //??
    public CSS_UnitOutboundJSON2Apex UnitOutboundDetails{get;set;} //??
    public string callingLocation{get;set;}
    public Boolean contactshowOutageError {get;set;}

    public Boolean UnitLookUpPopup{get;set;}

    static String ESN;
    public boolean reqAppBoolean {get;set;}
    public boolean checkFailureDateerror{get;set;}
    
   
    public string licensePlateSate{get;set;}

    public String LoginUserProfName;//Public variable to get profle name to be used in constuctor

    public CG_CL_IntakeUENoERP()
    {
        system.debug('***lstCAM***'+lstCAM);
        system.debug('***lstTRP***'+lstTRP);
        system.debug('***lstTSB***'+lstTSB);
        system.debug('***lstATC***'+lstATC );
        system.debug('licensePlate--'+licensePlateSate);
        checkFailureDateerror = false;
        system.debug('higherdateErrFlag***'+higherdateErrFlag);
        //Check the profile Name
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        LoginUserProfName = PROFILE[0].Name;
        system.debug('LoginUserProfName'+LoginUserProfName);
        
        system.debug('mainContr.workJob--'+mainContrRJ);
        // licensePlate = mainContr.workJob.License_Plate__c;
        // system.debug('licensePlate in Readonly--'+licensePlate);
    }


    public void showPopup7() {
        displayPopup7 = true;
    }

    //Moulika Added for Story - 148884
    public Date warrantyDate{get;set;}
    public Boolean higherdateErrFlag{get;set;}
    public Boolean builddateErrFlag{get;set;}
    public Boolean ReadonlyBIS{get; set;}
    public void CompareDates()
    {
        system.debug('Hi');
        system.debug('warranty***'+warrantyDate);
        system.debug('higherdateErrFlag***'+higherdateErrFlag);
        system.debug('=======>'+date.today());
        //system.debug('=======>'+(warrantyDate > date.today());
        higherdateErrFlag = false;
        builddateErrFlag=false;
        if(warrantyDate > date.today())
        {
            higherdateErrFlag = true;
        }

        system.debug('***mainContr.workJob.Before_In_Service__c**'+mainContr.workJob.Before_In_Service__c);
        system.debug('***mainContr.workJob.Warranty_Start_Date__c**'+mainContr.workJob.Warranty_Start_Date__c);

        if(warrantyDate !=null && mainContr.workJob.Before_In_Service__c==false){
            system.debug('**1**');
            ReadonlyBIS =true;
        }
        else{
            system.debug('**2**');
            ReadonlyBIS=false;
            mainContr.workJob.Warranty_Start_Date__c=null;
        }

        if(ESN == '10000000' || ESN == '27000000' || EtoConversion != NULL)
        {
            builddateErrFlag=false;
        }
        else if(warrantyDate < billdateVal){
            builddateErrFlag=true;
            mainContr.workJob.Warranty_Start_Date__c = null;  
        }  
        system.debug('higherdateErrFlag***'+higherdateErrFlag);

    }

    public Boolean ReadonlyWSD{get; set;}
    public void onChangeBIS(){
        system.debug('**insideonChangeBIS'+mainContr.workJob.Before_In_Service__c);
        system.debug('**WSD'+mainContr.workJob.Warranty_Start_Date__c);
        if(mainContr.workJob.Warranty_Start_Date__c == null && mainContr.workJob.Before_In_Service__c==true){
            system.debug('**1**');
            ReadonlyWSD=true;
        }
        else{
            system.debug('**2**');
            ReadonlyWSD=false;
        }
    }

    /* Select Option list */
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers));
        //options.add(new SelectOption('Hours',system.Label.css_hours)); 
        return options;
    } 


    //Action Methods Start
    public void startRequestNullPSN()
    {
        mainContr.workJob.ESN__c='';
        mainContr.workJob.Unit_Number__c='';
        startRequest();
        //Defect:80886 By Shanthi
        //mainContr.workJob.Before_In_Service__c = false;
        //end
        //story:86422 By Ekta 
        //When PSN not available default Make/Model to 'Unlisted/All'
        if(mainContr.workJob.PSN_Not_Available__c == true){
            mainContr.filterMake = 'UNLISTED';
            mainContr.filterModel ='ALL';
            mainContr.workJob.Make__c = mainContr.filterMake;  
            mainContr.workJob.Model__c= mainContr.filterModel; 
            mainContr.filterApplication = '';
            prodcodeErrormessage = false ;
            mainContr.workJob.ProductAppcodeErrorflag__c=false;
            //changes for story 86422 end
             mainContr.PSNFlag=false;//story#183077
             displaySrvModPopup=false;
        }
        else{
            mainContr.PSNFlag=false;//story#183077
            displaySrvModPopup=false;
        }
    }

    //ESN onTabOff method
    public void  startRequest() {
        try{
            system.debug('StartRequest>>>');
            system.debug('mainContr>>>'+mainContr);
            system.debug('mainContr.workJob.ESN__c '+ mainContr.workJob.ESN__c);
            system.debug('displaySrvModPopup '+ displaySrvModPopup);
            ESN = mainContr.workJob.ESN__c;
             mainContr.startRequestCalled = true;
            EtoConversion = mainContr.workJob.EtoConversionDate__c;
            siebelWarrantyDate=null;
            mainContr.workjob.VIN__c = '';
            higherdateErrFlag = false;
            builddateErrFlag=false;
            faildtwsdtflag=false;
            faildtshdtflag=false;
            prodcodeErrormessage = false;
             system.debug('mainContr.prodcodeErrormessage '+  mainContr.prodcodeErrormessage); mainContr.workJob.ProductAppcodeErrorflag__c=false;
            system.debug('mainContr.workJob.ProductAppcodeErrorflag__c'+ mainContr.workJob.ProductAppcodeErrorflag__c);
            // .vin = '';

            //Story-146298
            /*   if (mainContr.workJob.ESN__c !='' && mainContr.workJob.ESN__c !=null){
                system.debug('InsideFDgreaterthantoday>>>');
                if(mainContr.workJob.Failure_Date__c!=null && mainContr.workJob.Failure_Date__c>System.TODAY())
                {
                    checkFailureDateerror = true;
                    if(mainContr.tempFailureDate!=null)
                        mainContr.workJob.Failure_Date__c = mainContr.tempFailureDate;
                    else
                        mainContr.workJob.Failure_Date__c = system.today();
                }
                else{
                    checkFailureDateerror = false;
                    mainContr.tempFailureDate = mainContr.workJob.Failure_Date__c;
                }

            } */
            //Story-146298 End

            if (mainContr.workJob != null && (mainContr.workJob.ESN__c =='' || mainContr.workJob.ESN__c ==null)){
                system.debug('Entered first If ');
                mainContr.workJob.Service_Model__c = '';
                mainContr.workJob.VIN__c = '';
                mainContr.workJob.Warranty_Start_Date__c =null;
                mainContr.workJob.Location_Certification__c='';
                mainContr.workJob.VIN_Flag__c = false;
                mainContr.workJob.Application_Desc__c = '';
                mainContr.workJob.Vin__c= '';
                // workjob.Application__c='';
                sEngineFamilyCode=null;
                showOutageError1= false; //Venkat:added for ROD Defect 111715 & 111716
                //workjob.Before_In_Service__c = true;
                mainContr.filterMake='';
                 mainContr.PSNFlag=false;//story#183077

            } else {
                system.debug('Entered first Else');
                //86408 [Training] Popup Box not displaying for invalid ESN enter for the second attempt. - By Krishna at 30-03-2017  
                siebelSMN = '';
                siebAppCode= '';
                siebelWarrantyDate= null;

                if(callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true){ // Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                    mainContr.filterMake= '';
                    mainContr.filterModel= '';
                }
                //Modified as per story# 64030
                //workJob.Application__c = '';
                mainContr.workJob.Application_Desc__c = '';
                mainContr.workJob.Vin__c= '';
                system.debug('state' + ' ' + state);
                if(state == NULL && mainContr.workJob.IsAppointment__c != null && mainContr.workJob.IsAppointment__c == 'No')
                {
                    mainContr.workJob.Failure_Date__c=system.today(); //added as part of story#148886
                    mainContr.workJob.Before_In_Service__c= null;
                }
                siebVIN='';
                //86408 [Training] Popup Box not displaying for invalid ESN enter for the second attempt. - By Krishna at 30-03-2017
                //
              /*  CSS_quickserveCumminsComWebservices.ModelName rDataPlate; 
                rDataPlate = new CSS_quickserveCumminsComWebservices.ModelName();  */
                CSS_getEngineDataResponseJ2A rDataPlate = new CSS_getEngineDataResponseJ2A(); //GSSC_97, ROD:Qsol changes
                /*CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc rQSOLDocs = new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
                List<CSS_quickserveCumminsComWebservices.WarrantyDoc> wCAMTSBTRB = new List<CSS_quickserveCumminsComWebservices.WarrantyDoc>();   
                string sQSOLConn;
                if(!Test.isRunningTest()){
                    sQSOLConn = CSS_getConnnectionDetails.getConnection('QSOL').Key__c;
                }
                else{
                    sQSOLConn = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                }
                //lDocType = new List<STRING>{'CAM','TRP','TSB'};

                //Get Dataplate information from QSOL based on ESN
                CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wsCall;*/

                try{
                    //Get Dataplate information from QSOL based on ESN
                    //wsCall = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
                  //  rDataPlate = wsCall.getEngineDataplate(sQSOLConn, mainContr.workJob.ESN__c);
                     rDataPlate = CG_BL_Intake.GetEngineDataPlateQSOL(mainContr.workJob.ESN__c); //GSSC_97, ROD:Qsol changes
                    system.debug('rDataPlate>>>'+rDataPlate);//There is no ship date here
                    //start Moulika
                   // String Billdate=rDataPlate.buildDate; 
                    String Billdate;
                    if(rDataPlate != null)
                    Billdate=rDataPlate.DataArea.BuildDate;
                    System.debug('The Bill date is:'+Billdate);
                    Map <String, Integer> monthNames = new Map <String, Integer> {'Jan'=>1, 'Feb'=>2, 'Mar'=>3, 'Apr'=>4, 'May'=>5, 'Jun'=>6, 'Jul'=>7, 'Aug'=>8, 'Sep'=>9, 'Oct'=>10, 'Nov'=>11, 'Dec'=>12};
                    if(Billdate!=null && Billdate!=''){    
                        List <String> stringParts = Billdate.split(' ');
                        billdateVal = Date.newInstance(Integer.valueOf(stringParts[2]), monthNames.get(stringParts[1]), Integer.valueOf(stringParts[0]));
                        System.debug('The date is:'+billdateVal);
                    }
                    else{
                        billdateVal=null; 
                    }
                    //end


                }
                catch(exception e){
                    System.debug('Error Message:'+e.getMessage());
                }
                /* CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wsCall = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
rDataPlate = wsCall.getEngineDataplate(sQSOLConn, mainContr.workJob.ESN__c);
system.debug('rDataPlate>>>'+rDataPlate); */
                //Calling SiebelWS to get data 63173-Start

                /*   CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
CSS_getEngineDataResponseJ2A  engineData;
CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
jidi.ESN=mainContr.workJob.ESN__c;
wrapobj.DataArea = jidi;

engineData = CSS_WS_SBL.getEngineData(wrapobj); */
                System.debug('Error2 Message>>');
                CSS_getEngineDataResponseJ2A  engineData;
                try{

                    //Calling SiebelWS to get data 63173-Start
                    CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
                    CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
                    jidi.ESN=mainContr.workJob.ESN__c;
                    wrapobj.DataArea = jidi;
                    engineData = CSS_WS_SBL.getEngineData(wrapobj);
                    WrapperRequestEng = String.valueOf(wrapobj);
                }catch(exception e){
                    System.debug('Error Message:'+e.getMessage());
                }
               /*Story:183077*/
              // if((rDataPlate!=null && rDataPlate.ResponseMessage!=null && rDataPlate.ResponseMessage.contains('SUCCESS')) || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
               //+++++Commenting below and writing anothe block of code below, as per GSSC-98 ROD Qsol Changes+++++
              /* if(rDataPlate!=null  || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
                mainContr.PSNFlag=false;
                else {
                mainContr.PSNFlag=true;
                 CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                intEngError.Processed_Data__c =  WrapperRequestEng;
                intEngError.Response_Body__c = 'Access Denied';
                intEngError.Service_Job_Number__c = mainContr.workJob.Name;
                intEngError.Service_Name__c = 'GetEngineDataService';
                intEngError.Source__c = 'SIEBEL';
                //intEngError.WWID__c = FedId; 
                
                insert intEngError;
                }*/
                   //ROD Changes GSSC_97, As per latest update, QSOL Service call is stopped and data is retrieved from Asset
            //if( (rDataPlate == null || rDataPlate.DataArea == null) &&  (engineData == null || engineData.DataArea == null || !engineData.Header.Status.contains('Success')))
           if( (rDataPlate == null) &&  (engineData == null || !engineData.Header.Status.contains('Success'))) //GSSC-329
            {
                
                mainContr.workJob.Get_Engine_data_flag__c=true; //GSSC-329
                mainContr.PSNFlag=true;
                CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                intEngError.Processed_Data__c =  WrapperRequestEng;
                intEngError.Response_Body__c = 'Service Failed Or No Data Found';
                intEngError.Service_Job_Number__c = mainContr.workJob.Name;
                intEngError.Service_Name__c = 'GetEngineDataService';
                intEngError.Source__c = 'SIEBEL';
                //intEngError.WWID__c = FedId; 
                
                insert intEngError;
                
            }
            else{
                        mainContr.PSNFlag=false;
                mainContr.workJob.Get_Engine_data_flag__c=false; 
                    }
                
                
               /*end*/
                system.debug('engineData>>>>'+engineData);

                system.debug('Data>>>>'+rDataPlate);
                //Source of Truth
                if(rDataPlate != null && engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')){

                    system.debug('First block>>>>>>>');
                    mainContr.workJob.PSN_PACCAR_Flag__c = engineData.DataArea.PACCARFlag;
                    //if ( engineData.DataArea != null && engineData.Header.Status.contains('Success')){ //code added by roopa
                    //Application Code SOT is only Siebel
                    // As per defect 152086 ProdAppDesc is replaced with EngineAppDesc for populating application based on ESN
                    //if ( string.valueOf(engineData.DataArea.ProdAppDesc) !='' )
                    if(engineData.DataArea.EquipmentId != ''){
                        equipmentId = string.valueOf(engineData.DataArea.EquipmentId);
                        system.debug('Equipment Id' + equipmentId);
                    }

                    mainContr.workJob.Automotive_App_Flag__c = engineData.DataArea.AutomotiveAppFlag;

                    // if (string.valueOf(engineData.DataArea.ProdAppDesc) !='' ){ 
                    //   siebAppCode = css_utility.getCodes('Application Code',string.valueOf(engineData.DataArea.EngineAppDesc),null,null);//vam  
                    // system.debug('Vamshi>>>'+siebAppCode);
                    //}                   

                    // if( siebAppCode !='' && siebAppCode !=null){
                    // system.debug('siebelApp'+string.valueOf(engineData.DataArea.ProdAppDesc));//vam
                    //added below snippet to default returned value to Application picklist if it's already there if not don't add/default(bms users) - Vignesh
                    //Defect 108199
                    List<SelectOption> applicationPL = getApplication(); //commented since not using
                    Set<String> listOfApplication = new Set<String>();
                    for(SelectOption sOption : applicationPL) {
                        listOfApplication.add(sOption.getValue());
                    }

                    // if(listOfApplication.contains(string.valueOf(engineData.DataArea.ProdAppDesc)))


                    system.debug('engineData.DataArea.EngineAppCode)'+engineData.DataArea.EngineAppCode);
                    List<CSS_List_Of_Values__c> ListOfValues = CSS_List_Of_Values__c.getall().values();//As per defect 152086 by vamshi                       
                    for(Integer i = 0; i < ListOfValues.size() ; i++){
                        if(ListOfValues[i].Code__c == engineData.DataArea.EngineAppCode && ListOfValues[i].Type__c == 'Application Code'){ // As per defect 175482 by Rajesh N
                            mainContr.filterApplication = ListOfValues[i].Picklist_Values_1__c;
                            break;
                        } 
                        else{
                            mainContr.filterApplication = '';
                        }
                    }                                                     
                    // mainContr.filterApplication= string.valueOf(engineData.DataArea.EngineAppDesc);//vam
                    system.debug('Vamshi>>>'+mainContr.filterApplication);
                    // mainContr.filterApplication= string.valueOf(engineData.DataArea.EngineAppCode);
                    //}
                    //system.debug('mainContr.filterApplication>>>>'+mainContr.filterApplication);

					//SMN SOT=SBL now - since not calling QSOL service because of Asset as part of GSSC-692
                    if (engineData.DataArea.ServiceModelName !=null && string.valueOf(engineData.DataArea.ServiceModelName).trim() !=''  )
                            siebelSMN= engineData.DataArea.ServiceModelName;
                    sServiceModel = siebelSMN;
                    /* // SMN SOT1=QSOL and SOT2=SBL  //commented below code -- GSSC-692
                    sServiceModel = rDataPlate.DataArea.ServiceModelName;
                    if ((sServiceModel =='' || sServiceModel==null) ){ 
                        if (string.valueOf(engineData.DataArea.ServiceModelName) !=''  )
                            siebelSMN= engineData.DataArea.ServiceModelName; 
                        sServiceModel = siebelSMN;
                    }*/
                    mainContr.workJob.Service_Model__c = sServiceModel;

                    //WSD SOT1=SBL and SOT2=QSOL
                    if (string.valueOf(engineData.DataArea.WarrantyStartDate) !='')               
                        siebelWarrantyDate = date.valueOf(string.valueOf(engineData.DataArea.WarrantyStartDate));
                    if (string.valueof(siebelWarrantyDate) !=''  && string.valueof(siebelWarrantyDate) != null){
                        mainContr.workJob.Warranty_Start_Date__c=siebelWarrantyDate;
                        system.debug('Checking siebel warranty'+mainContr.workJob.Warranty_Start_Date__c+siebelWarrantyDate);
                        mainContr.workJob.Before_In_Service__c = false;
                    }else if (rDataPlate.DataArea.warrantyStartDate != null && rDataPlate.DataArea.warrantyStartDate != '') {
                        mainContr.workJob.Warranty_Start_Date__c  = parseQSOLDate(rDataPlate.DataArea.warrantyStartDate);
                       // system.debug('Checking dataplate warranty'+mainContr.workJob.warrantyStartDate+parseQSOLDate(rDataPlate.DataArea.warrantyStart));
                        mainContr.workJob.Before_In_Service__c =  false;
                    }else{
                        system.debug('Checking before in service');
                        mainContr.workJob.Warranty_Start_Date__c = null;
                        //mainContr.workJob.Before_In_Service__c = false;
                    }

                    //VIN SOT1=QSOL and SOT2=SBL
                    mainContr.workJob.VIN__c = rDataPlate.DataArea.vin; // Sai: 4/11/2017 Added for CUBS defect # 78702
                    if(rDataPlate.DataArea.vin != '' && rDataPlate.DataArea.vin !=null){ // code added by roopa
                        //mainContr.workJob.VIN__c = rDataPlate.vin; Sai: 4/11/2017 Commented CUBS for defect # 78702
                        mainContr.workJob.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                    }else{  
                        if (string.valueOf(engineData.DataArea.vin) !='' && string.valueOf(engineData.DataArea.vin) !='' ){
                            siebVIN = string.valueOf(engineData.DataArea.vin);
                            mainContr.workJob.VIN__c = siebVIN;
                            mainContr.workJob.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                        }
                    }
                    if((mainContr.workJob.ESN__c !='' && mainContr.workJob.ESN__c!= null) && (mainContr.workJob.VIN__c == '' || mainContr.workJob.VIN__c == null)) // Sai:4/11/2017: Added this for CUBS Story # 88616
                        mainContr.workJob.VIN_Flag__c = true;

                    //Engine_Family_Code SOT1=QSOL and SOT2=SBL
                    /*if(rDataPlate.DataArea.EquipmentConfiguration != null ){
                        sEngineFamilyCode = rDataPlate.DataArea.EquipmentConfiguration.substring(1,3);
                        mainContr.workJob.Qsol_Engine_Family_Code__c=sEngineFamilyCode;
                    }else{
                        mainContr.workJob.Qsol_Engine_Family_Code__c=engineData.DataArea.EngineFamilyCode;
                    }*/
                    
                    if(engineData.DataArea.EngineFamilyCode != null ){
                        mainContr.workJob.Qsol_Engine_Family_Code__c=engineData.DataArea.EngineFamilyCode;                        
                    }else{
                        sEngineFamilyCode = rDataPlate.DataArea.EngineFamilyCode;
                        mainContr.workJob.Qsol_Engine_Family_Code__c=sEngineFamilyCode;
                    }

                    //Make SOT1=SBL 
                    if ((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true) && string.valueOf(engineData.DataArea.Manufacturer)!=''){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                        mainContr.filterMake= engineData.DataArea.Manufacturer;
                        //Chking if Make exists in CSS SRT WEB
                        //mainContr.filterMake = css_utility.getMake(mainContr.filterMake);  //commented bcz no EngineFamilyCode & EquipmentId
                        mainContr.filterMake = css_utility.getMake(mainContr.filterMake, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                    }else{   
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)) // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                           
                            mainContr.filterMake = '';
                    }

                    //Model SOT1=SBL 
                    system.debug('Model--->'+string.valueOf(engineData.DataArea.Model));
                    if ((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)  && string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                        mainContr.filterModel= engineData.DataArea.Model;
                        //chking if Model exists in CSS SRT WEB
                        //mainContr.filterModel = css_utility.getModel(mainContr.filterMake,mainContr.filterModel); //commented bcz no EngineFamilyCode & EquipmentId
                        mainContr.filterModel = css_utility.getModel(mainContr.filterMake,mainContr.filterModel, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                    }else{
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true) )  // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                            mainContr.filterModel = '';
                    }

                    //Unit Configuration
                    system.debug('Unit Configuration'+string.valueOf(engineData.DataArea.EquipmentConfiguration));
                    if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)  && string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                        if(engineData.DataArea.EquipmentConfiguration !=null && engineData.DataArea.EquipmentConfiguration !=''){
                            mainContr.filterUnitType = engineData.DataArea.EquipmentConfiguration;
                            system.debug('Assign Unit Cinfig--->'+mainContr.filterUnitType);
                            //chking if Make, Model, EquipmentConfiguration exists in CSS SRT WEB
                            if(mainContr.filterUnitType != null && mainContr.filterUnitType != ''){
                                mainContr.filterUnitType = css_utility.getUnitype(mainContr.filterMake, mainContr.filterModel, mainContr.filterUnitType, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                                system.debug('SRT Web Unit Cinfig--->'+mainContr.filterUnitType);
                            }
                            /* This line of code is added by Rajesh Narra on 10-15-2018 to fix the issue for equipment configuration, if the equipment configuration has mismatch between Siebel and SRT Web*/
                            if(mainContr.filterUnitType == null || mainContr.filterUnitType == ''){
                                mainContr.filterUnitType = css_utility.getUnitype(mainContr.filterMake, mainContr.filterModel, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                                system.debug('SRT Web Unit Cinfig--->'+mainContr.filterUnitType);
                            }                        
                        }else
                            //mainContr.filterUnitType = css_utility.getUnitype(mainContr.filterMake,mainContr.filterModel,mainContr.filterUnitType); //not needed
                            //mainContr.filterUnitType = css_utility.getUnitype(mainContr.filterMake,mainContr.filterModel);
                            mainContr.filterUnitType = '';
                        system.debug('CSS_UTILITY----->' +mainContr.filterUnitType);
                    }else{
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)) // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                            mainContr.filterUnitType = '';
                    }


                    if (mainContr.filterMake !='' && mainContr.filterMake != null){
                        mainContr.workJob.Make__c = mainContr.filterMake;                  
                    }
                    if (mainContr.filterModel != '' && mainContr.filterModel!= null){
                        mainContr.workJob.Model__c=mainContr.filterModel;
                    }
                    if(mainContr.filterUnitType != '' && mainContr.filterUnitType != null){
                        mainContr.workJob.Unit_Type__c=mainContr.filterUnitType;
                    }

                    if(mainContr.workJob.Service_Model__c == null || mainContr.workJob.Service_Model__c == ''){
                        system.debug('mainContr.workJob.Service_Model__c1'+mainContr.workJob.Service_Model__c);
                        if(mainContr.workJob.ESN__c.isNumeric() || mainContr.workJob.ESN__c.length() == 8)
                            // system.debug('enterning if');
                            displaySrvModPopup=true;
                    }


                    //add new engine data new fields
                    mainContr.workJob.BillToCode__c = engineData.DataArea.EngineBillToCode;
                    if(engineData.DataArea.BuildDate != null && engineData.DataArea.BuildDate !=''){
                        mainContr.workJob.BuildDate__c = Date.valueOf(engineData.DataArea.BuildDate);}
                    mainContr.workJob.DesignPhaseCode__c = engineData.DataArea.DesignPhaseCode;
                    mainContr.workJob.EngineFamilyCode__c = engineData.DataArea.EngineFamilyCode;
                    system.debug('engineData.DataArea.EtoConversionDate**'+engineData.DataArea.EtoConversionDate);
                    if(engineData.DataArea.EtoConversionDate != null && engineData.DataArea.EtoConversionDate !=''){
                        // Kalpana Added null check
                        mainContr.workJob.EtoConversionDate__c = Date.valueOf(engineData.DataArea.EtoConversionDate);

                        // added for ROD Defect 111715 & 111716 by Venkat
                        if(engineData.DataArea.ETOOldESN.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(engineData.DataArea.ETOOldESN));
                        System.debug('** ReconFlag'+recconFlag);
                        showOutageError1 = false;
                        if(recconFlag == true){
                            showOutageError1= true;
                            mainContr.workJob.ReconEngineFlag__c = 'Y';
                        }
                        else{
                            showOutageError1= false;
                            mainContr.workJob.ReconEngineFlag__c = 'N';
                        }
                    }
                    else{
                        // added for ROD Defect 111715 & 111716 by Venkat
                        if(mainContr.workJob.ESN__c.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(mainContr.workJob.ESN__c));
                        System.debug('** ReconFlag'+recconFlag);
                        showOutageError1 = false;
                        if(recconFlag == true){
                            showOutageError1= true;
                            mainContr.workJob.ReconEngineFlag__c = 'Y';
                        }
                        else{
                            showOutageError1= false;
                            mainContr.workJob.ReconEngineFlag__c = 'N';
                        }
                    }

                    mainContr.workJob.MarineFlag__c = engineData.DataArea.MarineAppFlag;
                    mainContr.workJob.OemCode__c = engineData.DataArea.OEMSPCode;
                    //mainContr.workJob.ProductApplicationDesp__c = engineData.DataArea.ProdAppCode; //As per defect 152086
                    mainContr.workJob.ProductApplicationDesp__c = engineData.DataArea.ProdAppDesc;
                    mainContr.workJob.ProductApplicationCode__c = engineData.DataArea.ProdAppCode;
                    system.debug('Vamshi test>>>>'+mainContr.workJob.ProductApplicationDesp__c);
                    mainContr.workJob.warrantyIndicatorFlag__c = (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'Y' ? 'N' : (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'N' ? 'Y' : '')) ;   

                    //Story# 153520
                    system.debug('***EngineFamilyName**'+engineData.DataArea.EngineFamilyName);
                    system.debug('***ShipDate**'+engineData.DataArea.ShipDate);
                    system.debug('***ETOOldESN**'+engineData.DataArea.ETOOldESN);
                    mainContr.workJob.EngineFamilyName__c = engineData.DataArea.EngineFamilyName;
                    if(engineData.DataArea.ShipDate != null && engineData.DataArea.ShipDate !='')
                        mainContr.workJob.ShipDate__c = Date.valueOf(engineData.DataArea.ShipDate);
                    mainContr.workJob.ETOOldESN__c = engineData.DataArea.ETOOldESN;
                    system.debug('engineData.DataArea.ProdAppDesc'+ engineData.DataArea.ProdAppDesc);
                    productAppdesc =  engineData.DataArea.ProdAppDesc;

                    system.debug('engineData.DataArea.ProdAppCode'+ engineData.DataArea.ProdAppCode);
                    productAppcode = engineData.DataArea.ProdAppCode;

                }else if(rDataPlate != null && (engineData == null || engineData.DataArea == null || !engineData.Header.Status.contains('Success'))){

                    system.debug('second block>>>>>>>');
                    // SMN SOT1=QSOL and SOT2=SBL  
                    mainContr.workJob.Service_Model__c = rDataPlate.DataArea.Model;

                    //WSD SOT1=SBL and SOT2=QSOL
                    if (rDataPlate.DataArea.warrantyStartDate != null && rDataPlate.DataArea.warrantyStartDate != '') {
                        mainContr.workJob.Warranty_Start_Date__c  = parseQSOLDate(rDataPlate.DataArea.warrantyStartDate);
                        //system.debug('Checking dataplate warranty'+mainContr.workJob.Warranty_Start_Date__c+parseQSOLDate(rDataPlate.DataArea.warrantyStart));
                        mainContr.workJob.Before_In_Service__c =  false;
                    }else{
                        system.debug('Checking before in service');
                        mainContr.workJob.Warranty_Start_Date__c = null;
                        //mainContr.workJob.Before_In_Service__c = false;
                    }

                    //VIN SOT1=QSOL and SOT2=SBL
                    mainContr.workJob.VIN__c = rDataPlate.DataArea.vin; // Sai: 4/11/2017 Added for CUBS defect # 78702
                    if(rDataPlate.DataArea.vin != '' && rDataPlate.DataArea.vin !=null){ // code added by roopa
                        //mainContr.workJob.VIN__c = rDataPlate.vin; Sai: 4/11/2017 Commented CUBS for defect # 78702
                        mainContr.workJob.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                    }
                    if((mainContr.workJob.ESN__c !='' && mainContr.workJob.ESN__c!= null) && (mainContr.workJob.VIN__c == '' || mainContr.workJob.VIN__c == null)) // Sai:4/11/2017: Added this for CUBS Story # 88616
                        mainContr.workJob.VIN_Flag__c = true;

                    if(engineData.DataArea!= null && engineData.DataArea.EquipmentId != ''){
                        equipmentId = string.valueOf(engineData.DataArea.EquipmentId);
                        system.debug('Equipment Id' + equipmentId);
                    }


                    //Engine_Family_Code SOT1=QSOL and SOT2=SBL
                    /*if(rDataPlate.DataArea.EquipmentConfiguration != null ){
                        sEngineFamilyCode = rDataPlate.DataArea.EquipmentConfiguration.substring(1,3);
                        mainContr.workJob.Qsol_Engine_Family_Code__c=sEngineFamilyCode;
                    }*/
                    if(rDataPlate.DataArea.EngineFamilyCode != null ){
                        sEngineFamilyCode = rDataPlate.DataArea.EngineFamilyCode;
                        mainContr.workJob.Qsol_Engine_Family_Code__c=sEngineFamilyCode;
                    }

                    if(mainContr.workJob.Service_Model__c == null || mainContr.workJob.Service_Model__c == ''){
                        system.debug('mainContr.workJob.Service_Model__c2'+mainContr.workJob.Service_Model__c);
                        if(mainContr.workJob.ESN__c.isNumeric() || mainContr.workJob.ESN__c.length() == 8)
                            //  system.debug('popupshow message');
                            displaySrvModPopup=true;
                    }

                    if(mainContr.workJob.ESN__c.isNumeric())
                        recconFlag = css_utility.getReconEngine(decimal.valueof(mainContr.workJob.ESN__c));
                    System.debug('** ReconFlag'+recconFlag);
                    showOutageError1 = false;
                    if(recconFlag == true){
                        showOutageError1= true;
                        mainContr.workJob.ReconEngineFlag__c = 'Y';
                    }
                    else{
                        showOutageError1= false;
                        mainContr.workJob.ReconEngineFlag__c = 'N';
                    }

                }
                else if(rDataPlate == null && engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success') ){
                    system.debug('third block>>>>>>>');
                    mainContr.workJob.PSN_PACCAR_Flag__c = engineData.DataArea.PACCARFlag;
                    //Application Code SOT is only Siebel
                    // As per defect 152086 ProdAppDesc is replaced with EngineAppDesc for populating application based on ESN
                    //  if ( string.valueOf(engineData.DataArea.ProdAppDesc)!='' ){
                    //      siebAppCode = css_utility.getCodes('Application Code',string.valueOf(engineData.DataArea.ProdAppDesc),null,null);//vam
                    // }
                    // if( siebAppCode !='' && siebAppCode!=null){
                    //     system.debug('siebelApp'+string.valueOf(engineData.DataArea.ProdAppDesc));//vam
                    //added below snippet to default returned value to Application picklist if it's already there if not don't add/default(bms users) - Vignesh
                    //Defect 108199
                    List<SelectOption> applicationPL = getApplication(); //commented since not using
                    Set<String> listOfApplication = new Set<String>();
                    for(SelectOption sOption : applicationPL) {
                        listOfApplication.add(sOption.getValue());
                    }
                    system.debug('mainContr.filterApplication>>>>'+mainContr.filterApplication);
                    //mainContr.filterApplication= string.valueOf(engineData.DataArea.ProdAppDesc);

                    List<CSS_List_Of_Values__c> ListOfValues = CSS_List_Of_Values__c.getall().values();//As per defect 152086 by vamshi                       
                    for(Integer i = 0; i < ListOfValues.size() ; i++){
                        if(ListOfValues[i].Code__c == engineData.DataArea.EngineAppCode && ListOfValues[i].Type__c == 'Application Code'){ // As per defect 175482 by Rajesh N
                            mainContr.filterApplication = ListOfValues[i].Picklist_Values_1__c;
                            break;
                        } 
                        else{
                            mainContr.filterApplication = '';
                        }
                    }  

                    // mainContr.filterApplication= string.valueOf(engineData.DataArea.ProdAppDesc);//vam
                    //mainContr.filterApplication= string.valueOf(engineData.DataArea.EngineAppCode);
                    // }

                    // SMN SOT1=QSOL and SOT2=SBL  
                    mainContr.workJob.Service_Model__c = engineData.DataArea.ServiceModelName;

                    //WSD SOT1=SBL and SOT2=QSOL
                    if (string.valueOf(engineData.DataArea.WarrantyStartDate) !='')               
                        siebelWarrantyDate = date.valueOf(string.valueOf(engineData.DataArea.WarrantyStartDate));
                    if (string.valueof(siebelWarrantyDate) !=''  && string.valueof(siebelWarrantyDate) != null){
                        mainContr.workJob.Warranty_Start_Date__c=siebelWarrantyDate;
                        system.debug('Checking siebel warranty'+mainContr.workJob.Warranty_Start_Date__c+siebelWarrantyDate);
                        mainContr.workJob.Before_In_Service__c = false;
                    }else{
                        system.debug('Checking before in service');
                        mainContr.workJob.Warranty_Start_Date__c = null;
                        //mainContr.workJob.Before_In_Service__c = false;
                    }

                    //VIN SOT1=QSOL and SOT2=SBL
                    if (string.valueOf(engineData.DataArea.vin) !='' && string.valueOf(engineData.DataArea.vin) !='' ){
                        siebVIN = string.valueOf(engineData.DataArea.vin);
                        mainContr.workJob.VIN__c = siebVIN;
                        mainContr.workJob.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                    }
                    if((mainContr.workJob.ESN__c !='' && mainContr.workJob.ESN__c!= null) && (mainContr.workJob.VIN__c == '' || mainContr.workJob.VIN__c == null)) // Sai:4/11/2017: Added this for CUBS Story # 88616
                        mainContr.workJob.VIN_Flag__c = true;

                    //Engine_Family_Code SOT1=QSOL and SOT2=SBL
                    mainContr.workJob.Qsol_Engine_Family_Code__c=engineData.DataArea.EngineFamilyCode;

                    //Make SOT1=SBL 
                    if ((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true) && string.valueOf(engineData.DataArea.Manufacturer)!=''){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                        //if(engineData.DataArea.EquipmentConfiguration !=null && engineData.DataArea.EquipmentConfiguration !=''){
                        mainContr.filterMake= engineData.DataArea.Manufacturer;
                        //Chking if Make exists in CSS SRT WEB
                        //mainContr.filterMake = css_utility.getMake(mainContr.filterMake); //commented bcz no EngineFamilyCode & EquipmentId
                        mainContr.filterMake = css_utility.getMake(mainContr.filterMake, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                    }else{   
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true))
                            mainContr.filterMake = '';
                    }

                    //Model SOT1=SBL 
                    system.debug('Model--->'+string.valueOf(engineData.DataArea.Model));
                    if ((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true) && string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                        mainContr.filterModel= engineData.DataArea.Model;
                        //chking if Model exists in CSS SRT WEB
                        //mainContr.filterModel = css_utility.getModel(mainContr.filterMake,mainContr.filterModel); //commented bcz no EngineFamilyCode & EquipmentId
                        mainContr.filterModel = css_utility.getModel(mainContr.filterMake, mainContr.filterModel, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                    }else{
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true))
                            mainContr.filterModel = '';
                    }

                    //Unit Configuration
                    system.debug('Unit Configuration'+string.valueOf(engineData.DataArea.EquipmentConfiguration));
                    if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true) && string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !=''){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                        if(engineData.DataArea.EquipmentConfiguration !=null && engineData.DataArea.EquipmentConfiguration !=''){
                            mainContr.filterUnitType = engineData.DataArea.EquipmentConfiguration;
                            //chking if Make, Model, EquipmentConfiguration exists in CSS SRT WEB
                            if(mainContr.filterUnitType != null && mainContr.filterUnitType != ''){
                                mainContr.filterUnitType = css_utility.getUnitype(mainContr.filterMake, mainContr.filterModel, mainContr.filterUnitType, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                                system.debug('SRT Web Unit Cinfig--->'+mainContr.filterUnitType);
                            }
                            /* This line of code is added by Rajesh Narra on 10-15-2018 to fix the issue for equipment configuration, if the equipment configuration has mismatch between Siebel and SRT Web*/
                            if(mainContr.filterUnitType == null || mainContr.filterUnitType == ''){
                                mainContr.filterUnitType = css_utility.getUnitype(mainContr.filterMake, mainContr.filterModel, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                                system.debug('SRT Web Unit Cinfig--->'+mainContr.filterUnitType);
                            }

                        }else
                            //mainContr.filterUnitType = css_utility.getUnitype(mainContr.filterMake,mainContr.filterModel,mainContr.filterUnitType); //not needed
                            //mainContr.filterUnitType = css_utility.getUnitype(mainContr.filterMake,mainContr.filterModel);
                            mainContr.filterUnitType = '';
                        system.debug('CSS_UTILITY----->' +mainContr.filterUnitType);
                    }else{
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true))
                            mainContr.filterUnitType = '';
                    }

                    if (mainContr.filterMake !='' && mainContr.filterMake != null){
                        mainContr.workJob.Make__c = mainContr.filterMake;                  
                    }
                    if (mainContr.filterModel != '' && mainContr.filterModel!= null){
                        mainContr.workJob.Model__c=mainContr.filterModel;
                    }
                    if(mainContr.filterUnitType != '' && mainContr.filterUnitType != null){
                        mainContr.workJob.Unit_Type__c=mainContr.filterUnitType;
                    }

                    if(mainContr.workJob.Service_Model__c == null || mainContr.workJob.Service_Model__c == ''){
                        system.debug('mainContr.workJob.Service_Model__c3'+mainContr.workJob.Service_Model__c);
                        system.debug('mainContr.workJob.Service_Model__c'+mainContr.workJob.Service_Model__c);
                        if(mainContr.workJob.ESN__c.isNumeric() || mainContr.workJob.ESN__c.length() == 8)
                            displaySrvModPopup=true;
                    }

                    //add new engine data new fields
                    mainContr.workJob.BillToCode__c = engineData.DataArea.EngineBillToCode;
                    if(engineData.DataArea.BuildDate != null && engineData.DataArea.BuildDate !=''){
                        mainContr.workJob.BuildDate__c = Date.valueOf(engineData.DataArea.BuildDate);}
                    mainContr.workJob.DesignPhaseCode__c = engineData.DataArea.DesignPhaseCode;
                    mainContr.workJob.EngineFamilyCode__c = engineData.DataArea.EngineFamilyCode;
                    system.debug('engineData.DataArea.EtoConversionDate**'+engineData.DataArea.EtoConversionDate);
                    if(engineData.DataArea.EtoConversionDate != null && engineData.DataArea.EtoConversionDate !='')  // Kalpana Added null check
                    {
                        mainContr.workJob.EtoConversionDate__c = Date.valueOf(engineData.DataArea.EtoConversionDate);

                        if(engineData.DataArea.ETOOldESN.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(engineData.DataArea.ETOOldESN));
                        System.debug('** ReconFlag'+recconFlag);
                        showOutageError1 = false;
                        if(recconFlag == true){
                            showOutageError1= true;
                            mainContr.workJob.ReconEngineFlag__c = 'Y';
                        }
                        else{
                            showOutageError1= false;
                            mainContr.workJob.ReconEngineFlag__c = 'N';
                        }
                    }
                    else{
                        if(mainContr.workJob.ESN__c.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(mainContr.workJob.ESN__c));
                        System.debug('** ReconFlag'+recconFlag);
                        showOutageError1 = false;
                        if(recconFlag == true){
                            showOutageError1= true;
                            mainContr.workJob.ReconEngineFlag__c = 'Y';
                        }
                        else{
                            showOutageError1= false;
                            mainContr.workJob.ReconEngineFlag__c = 'N';
                        }
                    }
                    mainContr.workJob.MarineFlag__c = engineData.DataArea.MarineAppFlag;
                    mainContr.workJob.OemCode__c = engineData.DataArea.OEMSPCode;
                    //mainContr.workJob.ProductApplicationDesp__c = engineData.DataArea.ProdAppCode; // As per defect 152086

                    mainContr.workJob.ProductApplicationDesp__c = engineData.DataArea.ProdAppDesc;
                    mainContr.workJob.ProductApplicationCode__c = engineData.DataArea.ProdAppCode;


                    mainContr.workJob.warrantyIndicatorFlag__c = (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'Y' ? 'N' : (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'N' ? 'Y' : '')) ;   

                    //Story# 153520
                    system.debug('***EngineFamilyName**'+engineData.DataArea.EngineFamilyName);
                    system.debug('***ShipDate**'+engineData.DataArea.ShipDate);
                    system.debug('***ETOOldESN**'+engineData.DataArea.ETOOldESN);
                    mainContr.workJob.EngineFamilyName__c = engineData.DataArea.EngineFamilyName;
                    if(engineData.DataArea.ShipDate != null && engineData.DataArea.ShipDate !='')
                        mainContr.workJob.ShipDate__c = Date.valueOf(engineData.DataArea.ShipDate);
                    mainContr.workJob.ETOOldESN__c = engineData.DataArea.ETOOldESN;

                }else{

                    if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)){
                        mainContr.filterMake = '';
                        mainContr.filterModel = '';
                    }



                }

                System.debug('mainContr.workJob.Service_Model__c4: '+mainContr.workJob.Service_Model__c);

                if(mainContr.workJob.Service_Model__c != null && mainContr.workJob.Service_Model__c != ''){
                    Set<String> hhpSet = new Set<String>();
                    for(CSS_Listof_HHP_SMNS__c hhp: CSS_Listof_HHP_SMNS__c.getAll().Values()){
                        hhpSet.add(hhp.Listof_HHP_SMN__c);
                    }
                    Id userId = UserInfo.getUserId();
                    User user = [select Product_Group_Access__c from user where Id = :userId];
                    if(hhpSet.contains(mainContr.workJob.Service_Model__c)){
                        HHSPSMNFlg=true;
                        // Moved to the end of method >> add to Audit trial  : â€˜Engine Identified as a Cummins High HorsePower Engineâ€™
                        //css_functionality.addToJobHistory('CSS_Job_Order__c',workjob.Id,'Status__c','','Engine Identified as a Cummins High HorsePower Engine');
                        if('PGA01'.endsWithIgnoreCase(user.Product_Group_Access__c)){
                            HHSPACCSFlg=true;
                            // Moved to the end of method >> add to Audit trial : â€˜User is certified to work on HHP Engineâ€™
                            //css_functionality.addToJobHistory('CSS_Job_Order__c',workjob.Id,'Status__c','','User is certified to work on HHP Engine');
                        }else{
                            HHSPACCSFlg=false;
                            displaySrvModPopup1=true;
                        }
                    }else{
                        HHSPSMNFlg=false;
                    }
                }else{
                    if(mainContr.workJob.ESN__c.isNumeric() || mainContr.workJob.ESN__c.length() == 8)
                        displaySrvModPopup=true;
                }

                if(HHSPACCSFlg==true || HHSPSMNFlg==false){
                    system.debug('inside*$$$$'+mainContr.workJob.Service_Model__c);
                    system.debug('ESN*$$$$'+mainContr.workJob.ESN__c);
                    system.debug('FailDate*$$$$'+mainContr.workJob.Failure_Date__c);
                    system.debug('Lang*$$$$'+mainContr.accountlang.CSS_QsolLanguage__c);
                    system.debug('JOBID*$$$$'+mainContr.workJob.Id);

                    //new list preparation
                    mainContr.region = '';
                    List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(mainContr.workJob.ESN__c, mainContr.workJob.Service_Model__c, mainContr.workJob.Failure_Date__c, mainContr.accountlang.CSS_QsolLanguage__c, mainContr.workJob.Id);
                    system.debug('campaignsList--'+campaignsList);
                   /* if(campaignsList == null){
                        mainContr.workJob.FieldActionWebServiceResult__c = 'Error';
                    }
                    else{
                        mainContr.workJob.FieldActionWebServiceResult__c = 'Success';
                    } */
                    
                    //modularized code below
                    //List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getQSOLDocs(mainContr.workJob.Id, mainContr.workJob.ESN__c, mainContr.accountlang.CSS_QsolLanguage__c);
                    if(campaignsList !=null && campaignsList.size()>=0)
                        mainContr.lstCAM = campaignsList.get(0);
                    if(campaignsList !=null && campaignsList.size()>=1)
                        mainContr.lstTSB = campaignsList.get(1);
                    if(campaignsList !=null && campaignsList.size()>=2)
                        mainContr.lstTRP = campaignsList.get(2);
                    if(campaignsList !=null && campaignsList.size()>=3)
                        mainContr.lstATC = campaignsList.get(3);
                    /*if(campaignsList !=null && campaignsList.size()>=4){
                        if(campaignsList.get(4).get(0).Type__c=='Region')
                            mainContr.region = campaignsList.get(4).get(0).Name;
                    }*/ 
                    if(campaignsList !=null && campaignsList.size()>4){
                        
                        List<CSS_CampTsbTrp__c> campaigns4List = new List<CSS_CampTsbTrp__c>();
                        campaigns4List = campaignsList.get(4);
                        integer capsize = campaigns4List.size();
                        
                        if(campaignsList.get(4).get(capsize-1).Type__c=='FAError'){
                            if(campaignsList.get(4).get(capsize-1).Doc_Num__c=='Error')
                                mainContr.workJob.FieldActionWebServiceResult__c = 'Error';
                            else
                                mainContr.workJob.FieldActionWebServiceResult__c = 'Success';
                        }
                    } 
                        
                    mainContr.region = mainContr.workJob.Account__r.Region__c;
                    System.debug('after retrive workJob.Region__c>>>>:'+mainContr.region);
                    //End All CAM,ATC, TSB & TRB
                    system.debug('Value of LIST=='+ mainContr.lstTRP);
                    System.debug('mainContr.workJob.FieldActionWebServiceResult__c>>>>:'+mainContr.workJob.FieldActionWebServiceResult__c);
                    //workjob.Location_Certification__c=getCertificationStatus(sServiceModel);

                }
                map<String,String> accCerts = CG_BL_Intake.getCertificationStatus(mainContr.workJob.Service_Model__c,mainContr.workJob.Failure_Date__c,mainContr.workJob.Account__c,mainContr.workJob.Account__r.Warranty_Training_Certification__c,mainContr.workJob.Account__r.Product_Certification__c, mainContr.workJob.Account__r.Warranty_Training_Status__c, mainContr.workJob.Account__r.CERTIFICATION_END_DATE__c);
                system.debug('accCerts--'+accCerts);
                if(accCerts.containsKey('warrCertFlag')){                       
                    mainContr.workjob.Location_Certification__c=accCerts.get('certStatus');
                    mainContr.workjob.Warranty_Authorization_Flag__c=accCerts.get('warrCertFlag');
                }
                if (mainContr.workjob.Location_Certification__c =='NotCert'){
                    displaycertPopup = true;
                }  
                system.debug('StopRequest>>>');
                system.debug('mainContr.workJob.ESN__c '+ mainContr.workJob.ESN__c);
                system.debug('displaySrvModPopup '+ displaySrvModPopup);
                state=null;
                system.debug('else last state' + ' ' + state);
                system.debug('mainContr.workJob.ESN__c '+ mainContr.workJob.CSS_Hours__c );
                system.debug('mainContr.workJob.ESN__c '+ mainContr.workJob.Mileage__c);
            }
        }catch(exception e){
            system.debug('EXCEPTION of startRequest CG_CL_IntakeUELegacyBMS  >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
            //Defect Fix for ID - 62081
            if(mainContr!=null && mainContr.workJob!=null){
            mainContr.workJob.Service_Model__c = '';
            mainContr.workJob.VIN__c = '';
            mainContr.workJob.Warranty_Start_Date__c =null;
            mainContr.workJob.Location_Certification__c='';}
        }

        //updateproductappcode();    
         if(mainContr.PSNFlag!=null && !mainContr.PSNFlag){
        if(mainContr.filterApplication== null || mainContr.filterApplication== '') {
            CSS_PSN__c PSNobj = new CSS_PSN__c();
            try{ 
               system.debug('mainContr.workJob.ESN__c' + mainContr.workJob.ESN__c);
                PSNobj = [select id, PSN__c,ApplicationCode__c, Application__c from CSS_PSN__c where PSN__c =: mainContr.workJob.ESN__c order by CreatedDate Desc Limit 1];
           system.debug('PSNobj'+PSNobj);
            }
            catch(Exception e){
            }
            if(PSNobj != null){
                system.debug('PSNobj.Application__c'+PSNobj.Application__c);
                mainContr.filterApplication = PSNobj.Application__c;
             //   system.debug('PSNobj'+PSNobj);

            } else{
                mainContr.filterApplication = '';
                system.debug('mainContr.filterApplication'+mainContr.filterApplication);
                mainContr.workJob.ProductAppcodeErrorflag__c = false;
                prodcodeErrormessage = false;
            }
        }

        system.debug('mainContr.filterApplication'+mainContr.filterApplication);
        if(mainContr.filterApplication!= null || mainContr.filterApplication!= '' || mainContr.filterApplication!='Select One'){
            system.debug('insidethe else for the appcode');
            updateproductappcode();
            system.debug('updateproductappcode on startRequest');
            if(mainContr.workJob.ProductAppcodeErrorflag__c == true){
                system.debug('mainContr.workJob.ProductAppcodeErrorflag__c'+mainContr.workJob.ProductAppcodeErrorflag__c);
                mainContr.filterApplication = '';
                mainContr.workJob.ProductAppcodeErrorflag__c = false;
                prodcodeErrormessage = false;
            }
        }
         }

    }
    //Added as part of defect 152593
    public void getCampaignDetails()
    {

        if (mainContr.workJob.ESN__c !='' && mainContr.workJob.ESN__c !=null)
        {

            system.debug('Inside On Change function.');
            /*Story 147384: Rupesh*/
            /*********************************************************************************************************************************************/
            system.debug('JOB FDT:'+mainContr.workJob.Failure_Date__c);
            system.debug('JOB BIS:'+mainContr.workJob.Before_In_Service__c);
            system.debug('JOB WSDT:'+mainContr.workJob.Warranty_Start_Date__c);
            system.debug('JOB SHPDT:'+mainContr.workJob.ShipDate__c);

            /*********************************************************************************************************************************************/
            //Check the profile Name
            if(LoginUserProfName.contains ('Advanced') ||LoginUserProfName.contains ('advanced')) 
            {
                /*system.debug('Advanced User is logged In.');
            else
                system.debug('Advanced User is NOT logged In.');*/   
                /*Failure Date > WSD validation*/
                if( (mainContr.workJob.Failure_Date__c!=null) && (mainContr.workJob.Before_In_Service__c==false) && ( mainContr.workJob.Failure_Date__c < mainContr.workJob.Warranty_Start_Date__c ))
                {
                    System.debug('Failure Date should be after the Warranty Start Date'); 
                    faildtwsdtflag=true;
                    System.debug('Failure Date Set flag: '+faildtwsdtflag); 
                }
                else
                    faildtwsdtflag=false;
                /*Failure Date > ShipDate validation*/
                if(mainContr.workJob.Failure_Date__c!=null)

                {
                    //Just to supply the dummy value..to be deleted when WService works well
                    if(mainContr.workJob.ShipDate__c!=null)
                    {
                        if((mainContr.workJob.Failure_Date__c) < (mainContr.workJob.ShipDate__c))
                        {
                            //system.debug('JOB SHPDT: Failure Date should be after the Ship Date: '+ShipDate);
                            faildtshdtflag=true;
                            system.debug('JOB SHPDT: Ship date flag is set to: '+faildtshdtflag);
                        }
                        else
                            faildtshdtflag=false;
                    }

                }

            }
            /*********************************************************************************************************************************************/
            if(mainContr.workJob.Failure_Date__c!=null && mainContr.workJob.Failure_Date__c>System.TODAY())
            {
                checkFailureDateerror = true;
                if(mainContr.tempFailureDate!=null)
                    mainContr.workJob.Failure_Date__c = mainContr.tempFailureDate;
                else
                    mainContr.workJob.Failure_Date__c = system.today();
            }
            else
            {
                checkFailureDateerror = false;
                mainContr.tempFailureDate = mainContr.workJob.Failure_Date__c;
            }




        
            map<String,String> accCerts = CG_BL_Intake.getCertificationStatus(mainContr.workJob.Service_Model__c,mainContr.workJob.Failure_Date__c,mainContr.workJob.Account__c,mainContr.workJob.Account__r.Warranty_Training_Certification__c,mainContr.workJob.Account__r.Product_Certification__c, mainContr.workJob.Account__r.Warranty_Training_Status__c, mainContr.workJob.Account__r.CERTIFICATION_END_DATE__c);
            if(accCerts.containsKey('warrCertFlag')){                       
                mainContr.workjob.Location_Certification__c=accCerts.get('certStatus');
                mainContr.workjob.Warranty_Authorization_Flag__c=accCerts.get('warrCertFlag');
            }
            if (mainContr.workjob.Location_Certification__c =='NotCert'){
                displaycertPopup = true;
            } 
        } 
        
          //Created below method as part of the story#189951 & commented respected code in below
            getfieldactionmethod();
            

        if(HHSPACCSFlg==true || HHSPSMNFlg==false){
            system.debug('inside*$$$$'+mainContr.workJob.Service_Model__c);
            system.debug('ESN*$$$$'+mainContr.workJob.ESN__c);
            system.debug('FailDate*$$$$'+mainContr.workJob.Failure_Date__c);
            system.debug('Lang*$$$$'+mainContr.accountlang.CSS_QsolLanguage__c);
            system.debug('JOBID*$$$$'+mainContr.workJob.Id);

            //new list preparation
            mainContr.region = '';
            
          
            //Commented below code for the story#189951
          //  List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(mainContr.workJob.ESN__c, mainContr.workJob.Service_Model__c, mainContr.workJob.Failure_Date__c, mainContr.accountlang.CSS_QsolLanguage__c, mainContr.workJob.Id);

            //modularized code below
            //List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getQSOLDocs(mainContr.workJob.Id, mainContr.workJob.ESN__c, mainContr.accountlang.CSS_QsolLanguage__c);
           
            //start:Commented below code for the story#189951
          /*  if(campaignsList !=null && campaignsList.size()>=0)
                mainContr.lstCAM = campaignsList.get(0);
            if(campaignsList !=null && campaignsList.size()>=1)
                mainContr.lstTSB = campaignsList.get(1);
            if(campaignsList !=null && campaignsList.size()>=2)
                mainContr.lstTRP = campaignsList.get(2);
            if(campaignsList !=null && campaignsList.size()>=3)
                mainContr.lstATC = campaignsList.get(3);*/
                /*end*/
                
            /*if(campaignsList !=null && campaignsList.size()>=4){
                if(campaignsList.get(4).get(0).Type__c=='Region')
                    mainContr.region = campaignsList.get(4).get(0).Name;
            }*/
            
        /*    if(campaignsList !=null && campaignsList.size()>=4){
                if(campaignsList.get(4).get(0).Type__c=='FAError'){
                    if(campaignsList.get(4).get(0).Doc_Num__c=='Error')
                        mainContr.workJob.FieldActionWebServiceResult__c = 'Error';
                    else
                        mainContr.workJob.FieldActionWebServiceResult__c = 'Success';
                }
            } */
            mainContr.region = mainContr.workJob.Account__r.Region__c;
            System.debug('after retrive workJob.Region__c>>>>:'+mainContr.region);
            //End All CAM,ATC, TSB & TRB
            system.debug('Value of LIST=='+ mainContr.lstTRP);

            //workjob.Location_Certification__c=getCertificationStatus(sServiceModel);
           
        }
        
        css_job_order__c workJob = CG_BL_Intake.fetchSPData(mainContr.workJob, mainContr.workJob.creator_location__c, null, mainContr.workJob.Failure_Date__c, null);
        system.debug('fetchSPData workJob>>>>>>>>>' + workJob);
          //163193
    }


    /*
* This method is used for IA ESN Go button functionality
*/
    public void esnGo(){
        System.debug('entered into esnGo method...mainContr.workJob.ESN_IA>>>:'+mainContr.workJob.ESN_IA__c);
        try{
            if(mainContr.workJob.ESN_IA__c != null){
                mainContr.workJob.ESN__c = mainContr.workJob.ESN_IA__c;
            }
            //calling ESN taboff method
            startRequest();
        }catch(Exception ex){
            System.debug('in catch of esnGo of CG_CL_IntakeUENoERP>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    public List<SelectOption> getApplication() {
        List<SelectOption> lstApplications;
        CSS_WPR_SBL_ApplicationResJSON resJSON;
        try {
            resJSON = CG_BL_Intake.getApplicationCodesWrapper();

            //create a map with code and description
            mainContr.mapDescriptionToCode = new map<string,string>();

            lstApplications = new List<SelectOption>();
            lstApplications.add(new SelectOption('','Select One'));

            if(resJSON  != null && resJSON.DataArea != null && resJSON.DataArea.Details != null ){
                for(CSS_WPR_SBL_ApplicationResJSON.Details det : resJSON.DataArea.Details ){
                  if(det.ActiveFlag == 'Y' && det.ApplicationCode!='890' && det.ApplicationCode!='891'){  // karthik G added as part of GSSC-512
                        lstApplications.add(new SelectOption(det.Description,det.ApplicationCode+' - '+det.Description));
                        //populating description to code map 
                        mainContr.mapDescriptionToCode.put(det.Description,det.ApplicationCode);
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

    public List<SelectOption> getMake() {
        return CG_BL_Intake.getMake(sEngineFamilyCode, mainContr.filterApplication, mainContr.workJob.Qsol_Engine_Family_Code__c);
    }

    public List<SelectOption> getModel() {
        return CG_BL_Intake.getModel(mainContr.filterMake, sEngineFamilyCode, mainContr.filterApplication, mainContr.workJob.Qsol_Engine_Family_Code__c);
    }


    @testvisible
    private Date parseQSOLDate(String myDate) {
         String[] myDateOnly = myDate.split('-');
        String sMonth = (myDateOnly.size()>0 && myDateOnly != null)?myDateOnly[1]:'';
        String sMM='0';
        if (sMonth == 'Jan') { sMM = '1' ;}
        else if (sMonth == 'Feb') { sMM = '2' ;}
        else if (sMonth == 'Mar') { sMM = '3' ;}
        else if (sMonth == 'Apr') { sMM = '4' ;}
        else if (sMonth == 'May') { sMM = '5' ;}
        else if (sMonth == 'Jun') { sMM = '6' ;}
        else if (sMonth == 'Jul') { sMM = '7' ;}
        else if (sMonth == 'Aug') { sMM = '8' ;}
        else if (sMonth == 'Sep') { sMM = '9' ;}
        else if (sMonth == 'Oct') { sMM = '10' ;}
        else if (sMonth == 'Nov') { sMM = '11' ;}
        else { sMM = '12' ;}

        Integer myIntDate = integer.valueOf(myDateOnly[2]);
        Integer myIntMonth = integer.valueOf(sMonth);
        Integer myIntYear = integer.valueOf(myDateOnly[0]);
        Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        system.debug('date'+d);
        return d;

    }

    /* code added for tsps and trps  start*/

    public List<CSS_CampTsbTrp__c> getALLRecords(){

        system.debug('qsolCTTP'+qsolCTTP);
        List<CSS_CampTsbTrp__c> CTT = new  List<CSS_CampTsbTrp__c>();
        //   List<CSS_CampTsbTrp__c> qsolCTTP;
        try{
            qsolCTTP = [select Type__c,URL__c,  Doc_Num__c, Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :Wid AND Type__c !='TSB'  order by Type__c LIMIT 1000];
            for(CSS_CampTsbTrp__c campRec : qsolCTTP){
                system.debug('**Inside For Loop **');
                qsolCTTPMap.put(campRec.Doc_Num__c,campRec);
                if(qsolCampMap != null && !qsolCampMap.isEmpty()){
                    system.debug('qsolCampMap.get(campRec.Doc_Num__c).URL__c-->'+qsolCampMap.get(campRec.Doc_Num__c).URL__c);
                    if(qsolCampMap.get(campRec.Doc_Num__c) != null && qsolCampMap.get(campRec.Doc_Num__c).URL__c != null){
                        campRec.URL__c = qsolCampMap.get(campRec.Doc_Num__c).URL__c;
                    }
                }
            }
        }
        catch(exception e){

        }
        return qsolCTTP;
    }
    public integer getCamps(){
        list<CSS_CampTsbTrp__c> qsol = new list<CSS_CampTsbTrp__c>();
        if(qsolCTTP != null){
            for(CSS_CampTsbTrp__c qsolcam : qsolCTTP){
                if(qsolcam.type__c.equalsIgnoreCase('CAM')){
                    qsol.add(qsolcam);
                }
            }
        }
        return qsol.size();
    }
    public integer getTrps(){
        list<CSS_CampTsbTrp__c> qsol1 = new list<CSS_CampTsbTrp__c>();
        if(qsolCTTP != null){
            for(CSS_CampTsbTrp__c qsoltrp : qsolCTTP){
                if(qsoltrp.type__c.equalsIgnoreCase('TRP')){
                    qsol1.add(qsoltrp);
                }
            }
        }
        return qsol1.size();
    }
    //Added as per story#63175
    public integer getAtcs(){
        list<CSS_CampTsbTrp__c> qsol2 = new list<CSS_CampTsbTrp__c>();
        if(qsolCTTP != null){
            for(CSS_CampTsbTrp__c qsolatc : qsolCTTP){
                if(qsolatc.type__c.equalsIgnoreCase('ATC')){
                    qsol2.add(qsolatc);
                }
            }
        }
        return qsol2.size();
    }
    public integer getTsbs(){
        list<CSS_CampTsbTrp__c> qsol3 = new list<CSS_CampTsbTrp__c>();
        if(lstQSOLDocs != null){
            for(CSS_CampTsbTrp__c qsoltsbs : lstQSOLDocs){
                if(qsoltsbs.type__c.equalsIgnoreCase('TSB')){
                    qsol3.add(qsoltsbs);
                }
            }
        }
        return qsol3.size();
    }

    public void closecertPopup() {
        displaycertPopup = false;
    }

    public void closeSrvModPopup(){
        displaySrvModPopup = false;
    }

    public void closeSrvModPopup1(){
        displaySrvModPopup1 = false;
        mainContr.workJob.ESN__c = null;
    }


    /* Save Job Order with rebels */
    public PageReference pgSaveFinish()
    {
        System.Debug('in pgSaveFinish===============');
        css_job_order__c worecord= new css_job_order__c();
        worecord.Unit_Type__c=mainContr.filterUnitType;
        worecord.Sub_Type__c=mainContr.filterSubType;
        worecord.License_Plate__c=mainContr.workJob.License_Plate__c;
        //Added as per Story# 64030
        system.debug('filterApplication - pgSaveFinish'+mainContr.filterApplication);
        worecord.Application_Desc__c=mainContr.filterApplication;
        //Added as per Story# 79153
        String appCode;
        if(mainContr.filterApplication != '' && mainContr.mapDescriptionToCode != null){
            appCode = mainContr.mapDescriptionToCode.get(mainContr.filterApplication);
        }
        worecord.ApplicationCode__c=appCode;
        //worecord.Previous_Status__c = mainContr.workJob.Status__c; not needed in Intake
        worecord.Status__c='Closed';
        if (HHSPSMNFlg && !HHSPACCSFlg)
        {
            // log into Audit trial - â€˜User is NOT certified to work on HHP Engine, job has been closedâ€™            
            css_functionality.addToJobHistory('CSS_Job_Order__c',mainContr.workjob.Id,'Status__c','','User is NOT certified to work on HHP Engine, job has been closed');
        }
        System.debug('worecord'+worecord);
        if (mainContr.Wid == null){
            List<CSS_UserLocation__c> lstUserLocations = [SELECT isActive__c,isPrimary__c,UserId__c,Location_Name__c,Location_code__c
                                                          FROM CSS_UserLocation__c
                                                          WHERE UserId__c = : UserInfo.getUserId() AND isActive__c = true and isPrimary__c=true 
                                                          ORDER BY Location_Name__c asc limit 1];
            System.debug('lstUserLocations>>>:'+lstUserLocations);
            if(lstUserLocations.size()>0){
                worecord.jobLocation__c = lstUserLocations.get(0).Location_Name__c;
                worecord.CSS_Job_Location_Code__c = lstUserLocations.get(0).Location_code__c;
            }
            insert worecord;
            mainContr.Wid = worecord.id;
        }else{
            System.Debug('value of customer===='+mainContr.workJob.customer_name__c);
            worecord.id=mainContr.workJob.id;
            if(mainContr.workjob.Warranty_Start_Date__c != null){     
                worecord.Before_In_Service__c = false;      
            }else{//worecord.Before_In_Service__c = false;
            }
            update worecord;
            System.Debug('record updated====='+worecord);
        }
        PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
        pageRef.setRedirect(true);
        return pageRef;
    }


    public void updateproductappcode(){  
        if(mainContr.PSNFlag!=null && !mainContr.PSNFlag){
        system.debug('productAppdesc '+ productAppdesc);
        system.debug('productAppcode' +productAppcode);
         if(mainContr.workJob.PSN_Not_Available__c!=true && mainContr.workJob.ESN__c!='' && mainContr.workJob.ESN__c!=null){
        if(mainContr.filterApplication== ''||mainContr.filterApplication== null || mainContr.filterApplication== 'Select One'){
            system.debug('mainContr.filterApplication'+mainContr.filterApplication);
        prodcodeErrormessage = false;
        mainContr.workJob.ProductAppcodeErrorflag__c=false;
        }else{
        List<SelectOption> applicationlist = getApplication();
        String filterLabel;
        String appCode;
        system.debug('applicationlist'+ applicationlist);
        if(applicationlist.size()>0){
            for(SelectOption sopt: applicationlist){
                if(sopt.getValue()==mainContr.filterApplication){
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
        }
        CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
        CSS_JobEventTemporary__c JETproductcode1 = new CSS_JobEventTemporary__c();
        try{
           try{
               //JETproductcode = [select id, Attribute1__c, Attribute2__c,Attribute3__c, Attribute5__c, Active__c,Key__c from CSS_JobEventTemporary__c  where Key__c = 'MarketingApplicationCodes' and   Attribute1__c =: productAppcode and Attribute3__c=: productAppdesc Limit 1];
            JETproductcode = [select id, Attribute1__c, Attribute2__c,Attribute3__c, Attribute5__c, Active__c,Key__c from CSS_JobEventTemporary__c  where Key__c = 'MarketingApplicationCodes' and   Attribute1__c =: mainContr.workJob.ProductApplicationCode__c and Attribute3__c=: mainContr.workJob.ProductApplicationDesp__c Limit 1];
           }catch(Exception ex){
           system.debug(' inside else main EXC'+ex.getLineNumber()+ ex.getmessage());
           }
            system.debug('JETproductcode'+ JETproductcode);
            system.debug('JETproductcode.Attribute2__c'+ JETproductcode.Attribute2__c);
            system.debug('mainContr.filterApplication'+ mainContr.filterApplication);
            system.debug('JETproductcode.Attribute5__c'+ JETproductcode.Attribute5__c);
            system.debug('appCode'+ appCode);

            if(JETproductcode.Attribute2__c != appCode || JETproductcode.Attribute5__c != mainContr.filterApplication){
                try{
                    JETproductcode1 = [select id, Attribute1__c, Attribute2__c,Attribute3__c, Attribute5__c, Active__c,Key__c from CSS_JobEventTemporary__c  where Key__c = 'MarketingApplicationCodes' and   Attribute2__c =: appCode and Attribute5__c=: mainContr.filterApplication Limit 1];
                    system.debug('JETproductcode1'+ JETproductcode1);
                    prodcodeErrormessage = true;

                    mainContr.workJob.ProductAppcodeErrorflag__c=true;
                    system.debug('mainContr.workJob.ProductAppcodeErrorflag__c'+mainContr.workJob.ProductAppcodeErrorflag__c);
                }catch(Exception err) {
                    prodcodeErrormessage = false;
                    system.debug(' inside EXC ');
                    mainContr.workJob.ProductAppcodeErrorflag__c=false;
                    system.debug('mainContr.workJob.ProductAppcodeErrorflag__c'+mainContr.workJob.ProductAppcodeErrorflag__c);
                }

            }
            else{
                prodcodeErrormessage = false ;
                system.debug(' inside else main EXC');
                mainContr.workJob.ProductAppcodeErrorflag__c=false;
                    system.debug('mainContr.workJob.ProductAppcodeErrorflag__c'+mainContr.workJob.ProductAppcodeErrorflag__c);

            }
            
            
            mainContr.filterModel= mainContr.workJob.Model__c;
            mainContr.filterMake= mainContr.workJob.Make__c;
            system.debug('mainContr.filterMake'+mainContr.filterMake);
            system.debug('mainContr.filterModel'+mainContr.filterModel);
                    system.debug('mainContr.workJob.ProductAppcodeErrorflag__c'+mainContr.workJob.ProductAppcodeErrorflag__c);
        }
        catch(Exception ex ){
            prodcodeErrormessage = false ;
            system.debug(' inside main EXC'+ex.getLineNumber()+ex.getmessage());
            mainContr.workJob.ProductAppcodeErrorflag__c=false;
                    system.debug('mainContr.workJob.ProductAppcodeErrorflag__c'+mainContr.workJob.ProductAppcodeErrorflag__c);
        }
    }
    }
        }
         /*Start:Added for the story#189951*/
         getfieldactionmethod();
         /*end*/
    }
    /*Start:Added for the story#189951*/
    public void getfieldactionmethod(){
        try{
            
            system.debug('getfieldactionmethod enter');
            system.debug('mainContr.workJob.ESN__c'+mainContr.workJob.ESN__c);
            system.debug('mainContr.workJob.Service_Model__c'+mainContr.workJob.Service_Model__c);
            system.debug('mainContr.workJob.Failure_Date__c'+mainContr.workJob.Failure_Date__c);
            system.debug('mainContr.accountlang.CSS_QsolLanguage__c'+mainContr.accountlang.CSS_QsolLanguage__c);
            system.debug('mainContr.workJob.Id'+mainContr.workJob.Id);
            system.debug('mainContr.workJob.Service_Model__c'+mainContr.workJob.Service_Model__c);
                       
             if (mainContr.workJob.ESN__c !='' && mainContr.workJob.ESN__c !=null){
              
                    List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(mainContr.workJob.ESN__c, mainContr.workJob.Service_Model__c, mainContr.workJob.Failure_Date__c, mainContr.accountlang.CSS_QsolLanguage__c, mainContr.workJob.Id);
                       if(campaignsList !=null && campaignsList.size()>=0)
                        mainContr.lstCAM = campaignsList.get(0);
                       if(campaignsList !=null && campaignsList.size()>=1)
                        mainContr.lstTSB = campaignsList.get(1);
                       if(campaignsList !=null && campaignsList.size()>=2)
                        mainContr.lstTRP = campaignsList.get(2);
                       if(campaignsList !=null && campaignsList.size()>=3)
                        mainContr.lstATC = campaignsList.get(3);
                        system.debug('mainContr.lstCAM'+mainContr.lstCAM);
            
        }
        }catch(exception e){
            system.debug('Exception occurs in field action webservices'+e.getmessage());
        }
    }
    /*end*/
    
      //siva ganesh added logic for story GSSC-55
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