/**********************************************************************
    Name:CG_CL_ClaimsUEOneBMS
    Copyright Â© 2017  Cummins
    ======================================================
    ======================================================
    Purpose:                                                            
    -------  
    This class is used for Claims Unit&Engine One BMS functionalities
    ======================================================
    ======================================================
    History                                                            
    -------                                                            
    VERSION  AUTHOR            DATE                DETAIL                                 
    1.0     Surender M         02/05/2018      INITIAL DEVELOPMENT                    
    ***********************************************************************/ 
public class CG_CL_ClaimsUEOneBMS {
    boolean recursupd = true; //code added for story#161007
    public CG_CL_ClaimsIntake mainContr{get;
                                        //Below code added for story#161007
                                        set{
                                            mainContr = value;
                                            //Below code added for story#161007
                                            if((mainContr.claimsrec.IsCopyclaim__c==true) && recursupd==true)
                                            {
                                                system.debug('cpyclaim startss>>');
                                                state='stopupdate';
                                                system.debug('start request starts>>');
                                                startRequest();
                                                system.debug('MakeWSDReadOnly starts>>');
                                                MakeWSDReadOnly();
                                                system.debug('getCampaignDetails starts>>');
                                                getCampaignDetails();
                                                system.debug('MakeBISReadOnly starts>>');
                                                MakeBISReadOnly();
                                                system.debug('updateproductappcodestarts>>');
                                                updateproductappcode();
                                                system.debug('Copy claims ends>>');
                                                recursupd = false;
                                                state=null;
                                            }
                                        }}
    public string warrStDtHidden{get;set;}
    public string FailureStDtHidden{get;set;} //Defect#150716
    public string sEngineFamilyCode {get; set;}
    public string equipmentId {get;set;}//added by Agassi for story 144598
    public String siebVIN{get; set;}
    public Date billdateVal{get;set;} //added by moulika
    public Date EtoConversion{get;set;}  //added by moulika
    public String PSN{get;set;}//added by moulika
    public Boolean ReadonlyBIS{get; set;}
    public Boolean ReadonlyWSD{get; set;}
    public Boolean ExternReturnDateFlag{get; set;}
    public boolean checkFailureDateerror{get;set;}
    public Boolean recconFlag{get;set;}//added by venkat for 156819
    public Boolean displayPSNSrvModPopup {get;set;} // Added by Rajasekhar H for 154597
    //public boolean failureDategttoday{get;set}
    Public string state{get;set;}
    public boolean checkAccount{get;set;} //Added by Gopal for 152389
    public String productAppdesc{get;set;}
    public String productAppcode{get;set;}
    public Boolean dispFDWSDErrorMsg {get;set;}
    public Boolean dispFDShipDateErrorMsg {get;set;}
    public boolean prodcodeErrormessage{get;set;}


    string orgtype;

    public CG_CL_ClaimsUEOneBMS(){ 
        //   
        checkFailureDateerror = false;
        dispFDWSDErrorMsg = false;
        dispFDShipDateErrorMsg = false;
        orgtype=css_utility.getOrgType(userinfo.getuserid());
        system.debug('orgtype'+orgtype);
        //system.debug('mainContr.cId**' + mainContr.cId);
        if(orgtype.containsIgnoreCase('DLR'))
        {
            checkAccount=false;
        }
        else{

            checkAccount=true;
        }
    }

      public void  MakeBISReadOnly() 
    {
        try{
        system.debug('InsideBIS**');
        system.debug('mainContr.psnRec.Warranty_Start_Date__c**'+mainContr.psnRec.Warranty_Start_Date__c);
        system.debug('warrStDtHidden**'+warrStDtHidden);
        system.debug('Bill Date**'+billdateVal);
        CompareDates();
        system.debug('aftercom');
        mainContr.wsdReadOnlyFromContr = false;
        IF(mainContr.psnRec.Warranty_Start_Date__c != null && (warrStDtHidden != '' && warrStDtHidden != null))
        {
            system.debug('InsideBISIF**');
            ReadonlyBIS = true;
            //ReadonlyWSD = false;
        }
        else
        {
            ReadonlyBIS = false;
        }

       }
        catch(exception e){
            system.debug('EXCEPTION of CG_CL_IntakeUENoERP - MakeBISReadOnly Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }


    public void  MakeWSDReadOnly() {
        system.debug('InsideWSD**');
        system.debug('mainContr.psnRec.Before_In_Service__c**'+mainContr.psnRec.Before_In_Service__c);
        IF(mainContr.psnRec.Before_In_Service__c != null && mainContr.psnRec.Before_In_Service__c == true)
        {system.debug('InsideWSDIF**');
         ReadonlyWSD = true;}
        else{
            ReadonlyWSD = false;
            mainContr.warrantyStartDateValidate = false;
        }
    }

    public void searchConfigUnit()
    {
        try{
            system.debug('Make Value' + mainContr.filterMake);
            system.debug('Model Value' + mainContr.filterModel);

            if (sEngineFamilyCode ==null && mainContr !=null && mainContr.psnRec !=null)
                sEngineFamilyCode=mainContr.psnRec.Qsol_Engine_Family_Code__c;

            //To get updated values onChange 
            List<CSS_Make_Model_Access__c> eqIdList =  new List<CSS_Make_Model_Access__c>([select Access__c, EquipmentId__c from CSS_Make_Model_Access__c where RecordType.Name = 'SRTData' and make__c=:mainContr.filterMake and model__c=:mainContr.filterModel and EngineFamilyCode__c=:sEngineFamilyCode LIMIT 1]);
            if (eqIdList !=null && eqIdList.size() >0){
                system.debug('Make Value:' + mainContr.filterMake);
                equipmentId = eqIdList[0].EquipmentId__c; 
                //mainContr.workJob.AccessCode__c = eqIdList[0].Access__c;
            }

            mainContr.filterUnitType = css_utility.getUnitype(mainContr.filterMake,mainContr.filterModel,sEngineFamilyCode,equipmentId);
            mainContr.psnRec.Unit_Type__c = mainContr.filterUnitType;
            //mainContr.filterUnitType = mainContr.workJob.Unit_Type__c;
            system.debug('Search Config'+mainContr.psnRec.Unit_Type__c);
        }catch(Exception ex){
            System.debug('in catch of searchConfigUnit of cliamsueonebms>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    public void checkFailureDate(){

        system.debug('mainContr.psnRec.Failure_Date__c' + mainContr.psnRec.Failure_Date__c);
        if(mainContr.psnRec!=null)
        {
            system.debug('mainContr.psnRec.Failure_Date__c' + mainContr.psnRec.Failure_Date__c);
            if(mainContr.psnRec.Failure_Date__c!=null && mainContr.psnRec.Failure_Date__c<System.TODAY())
            {
                checkFailureDateerror = true;
            }
            else
                checkFailureDateerror = false;
        }
    }

    public void noOnPopUp(){
        mainContr.psnRec.PSN__c = mainContr.existingPSN;
    }

    public void yesOnPopUp(){
        startRequest();
        //Delete related records
        List<CSS_Parts_Options__c> delParts = [SELECT Id, CSS_Claims__c FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: mainContr.cId];
        system.debug('delParts++'+delParts);
        List<CSS_SRT__c> delSRTs = [SELECT Id, CSS_Claims__c FROM CSS_SRT__c WHERE CSS_Claims__c =: mainContr.cId];
        system.debug('delSRTs++'+delSRTs);
        List<CSS_Solution_Component__c> delFailures = [SELECT Id, CSS_Claims__c FROM CSS_Solution_Component__c WHERE CSS_Claims__c =: mainContr.cId];
        system.debug('delFailures++'+delFailures);
        List<Attachment> delAttachment = [SELECT Id, ParentId FROM Attachment WHERE ParentId =: mainContr.cId];
        List<CSS_PSN__c> delPSNs = [SELECT Id, CSS_Claims__c, Primary__c FROM CSS_PSN__c WHERE CSS_Claims__c =: mainContr.cId AND Primary__c != true];
        List<Note> delNotes = [SELECT Id, ParentId FROM Note WHERE ParentId =: mainContr.cId];
        List<CSS_Claim_Submission__c> delClaimSubmission = [SELECT Id, CSS_Claims__c FROM CSS_Claim_Submission__c WHERE CSS_Claims__c =: mainContr.cID];
        mainContr.claimsRec.CoverageResponse__c = '';
        mainContr.claimsRec.Claims_General_Symptoms__c = '';
        mainContr.claimsRec.Claims_Category_Desc__c = '';
        mainContr.claimsRec.Claims_Category2_Desc__c = '';
        mainContr.claimsRec.Claims_Category3_Desc__c = '';
        mainContr.claimsRec.Claims_Category4_Desc__c = '';
        mainContr.claimsRec.Claims_Category5_Desc__c = '';
        mainContr.claimsRec.Complaint_Type_Desc__c = '';
        mainContr.claimsRec.Complaint_Type2_Desc__c = '';
        mainContr.claimsRec.Complaint_Type3_Desc__c = '';
        mainContr.claimsRec.Complaint_Type4_Desc__c = '';
        mainContr.claimsRec.Complaint_Type5_Desc__c = '';
        mainContr.claimsRec.Claims_Preventive_Maintenance__c = '';
        mainContr.claimsRec.Claims_Expedited_Service__c  = '';
        mainContr.claimsRec.EditCause__c  = '';
        mainContr.claimsRec.EditCorrection__c  = '';
        mainContr.claimsRec.EditCoverage__c  = '';
        mainContr.claimsRec.EditComplaint__c  = '';
        mainContr.claimsRec.TSR1__c  = '';
        mainContr.claimsRec.TSR2__c  = '';
        mainContr.claimsRec.TSR3__c  = '';
        mainContr.claimsRec.TSR4__c  = '';
        mainContr.claimsRec.TSR5__c  = '';
        mainContr.claimsRec.TSR6__c  = '';
        mainContr.claimsRec.TSR7__c  = '';
        mainContr.claimsRec.TSR8__c  = '';
        mainContr.claimsRec.TSR9__c  = '';
        mainContr.claimsRec.TSR10__c  = '';
        mainContr.claimsRec.Actual_Technician_Time__c = null;
        mainContr.psnRec.License_Plate_State__c = 'Select One'; 
        mainContr.psnRec.Unit_Number__c = '';
        mainContr.psnRec.Mileage__c = null;
        mainContr.psnRec.Product_Hours__c = null;
        mainContr.psnRec.Before_In_Service__c = false;
        mainContr.psnRec.Mission_Disabling__c = false;
        mainContr.psnRec.Calibration_Before__c = '';
        mainContr.psnRec.Revision_Before__c = '';
        mainContr.psnRec.Calibration_After__c = '';
        mainContr.psnRec.Revision_After__c = '';
        mainContr.psnRec.Justification__c = '';
        mainContr.psnRec.Failure_Date__c = system.today();
        mainContr.psnRec.Failure_Date__c = system.today();
        mainContr.claimsRec.Multi_PSN_Claim__c = false;
        //mainContr.psnRec.Multi_PSN_Claim__c = false;
        mainContr.claimsRec.Distributor_Authorization_FN__c = '';
        mainContr.claimsRec.Distributor_Authorization_LN__c = '';
        mainContr.claimsRec.Distributor_Authorization_WWID__c = '';
        mainContr.claimsRec.PACCAR_Authorization_FN__c = '';
        mainContr.claimsRec.PACCAR_Authorization_LN__c = '';
        mainContr.claimsRec.PACCAR_Authorization_WWID__c = '';
        mainContr.claimsRec.Not_Authorized_Comments__c = '';
        mainContr.claimsRec.ODM_Status__c = 'YTBV';
        mainContr.claimsRec.ODM_Status_Message__c = '';
        mainContr.claimsRec.ODM_Status_Code__c = '';
        mainContr.claimsRec.ODM_Pre_submit_Status__c = 'YTBV';
        mainContr.claimsRec.ODM_Pre_submit_Status_Message__c = '';
        //mainContr.claimsRec.PACCAR_Flag__c = false;
        mainContr.claimsRec.PACCAR_Auth_Required__c = false;
        if(delParts.size() > 0)
            delete delParts;
        if(delSRTs.size() > 0)
            delete delSRTs;
        if(delFailures.size() > 0)
            delete delFailures;
        if(delAttachment.size() > 0)
            delete delAttachment;
        if(delPSNs.size() > 0)
            delete delPSNs;
        if(delNotes.size() > 0)
            delete delNotes;
        if(delClaimSubmission.size() > 0)
            delete delClaimSubmission;
        update mainContr.claimsRec;
        update mainContr.psnRec;
    }

    public void  startRequest() 
    {
        system.debug('Inside Start Request Method');
        mainContr.startRequestCalled = true; //GSSC-240
        displayPSNSrvModPopup = false;
        mainContr.mainFlag = 'true';
        String sEngineFamilyCode;
        String sServiceModel;
        Date siebelWarrantyDate=null;
        String siebelSMN;
        string etoConversiondt;
        if(mainContr.claimsrec.IsCopyclaim__c!=true)
            mainContr.psnRec.Warranty_Start_Date__c = null;
        system.debug(' startRequest --------->mainContr.psnRec.Warranty_Start_Date__c'+  mainContr.psnRec.Warranty_Start_Date__c);
        mainContr.prodcodeErrormessage = false;
        system.debug('mainContr.prodcodeErrormessage '+  mainContr.prodcodeErrormessage);
        mainContr.psnRec.ProductAppcodeErrorflag__c=false;
        system.debug('mainContr.psnRec.ProductAppcodeErrorflag__c'+ mainContr.psnRec.ProductAppcodeErrorflag__c);
        // String siebAppCode;

        List<CSS_Solution_Component__c> updateSolCompList = new List<CSS_Solution_Component__c>();
        List<CSS_Parts_Options__c> updatePartOption = new List<CSS_Parts_Options__c>();
        LIst<CSS_SRT__c> updateSRT = new List<CSS_SRT__c>();
        LIst<CSS_Accreditation__c> accredList = new List<CSS_Accreditation__c>();

        EtoConversion = mainContr.claimsRec.EtoConversionDate__c;

        //String siebMake;
        //String siebModel;
        try{



            system.debug('mainContr.psnRec.Failure_Date__c' + mainContr.psnRec.Failure_Date__c);
            if(mainContr.psnRec!=null)
            {
                system.debug('mainContr.psnRec.Failure_Date__c' + mainContr.psnRec.Failure_Date__c);
                if(mainContr.psnRec.Failure_Date__c!=null && mainContr.psnRec.Failure_Date__c>System.TODAY())
                {       

                    checkFailureDateerror = true;
                    if(mainContr.tempFailureDate!=null)
                        mainContr.psnRec.Failure_Date__c = mainContr.tempFailureDate;
                    else
                        mainContr.psnRec.Failure_Date__c = system.today();
                }
                else{
                    checkFailureDateerror = false;
                    system.debug('**No Error***Shows today date.****'+System.TODAY());
                    mainContr.tempFailureDate = mainContr.psnRec.Failure_Date__c;
                    //mainContr.psnRec.Failure_Date__c= system.today();
                    //mainContr.psnRec.Before_In_Service__c=null;
                    system.debug('mainContr.tempFailureDate'+mainContr.tempFailureDate);
                }

            }
            system.debug('showWarrantyDateError**' + checkFailureDateerror);
            PSN=mainContr.psnRec.PSN__c;

            system.debug('in StartRequest>>> mainContr.psnRec.PSN__c '+ mainContr.psnRec.PSN__c);
            mainContr.psnRec.VIN__c = '';
            siebVIN = '';
            if (mainContr.psnRec.PSN__c =='' || mainContr.psnRec.PSN__c == null){
                mainContr.psnRec.Service_Model__c = '';
                mainContr.psnRec.Warranty_Start_Date__c =null;
                mainContr.filterMake='';
                maincontr.claimsRec.CG_Get_Engine_data_flag__c=false;//Story#183077
            } else {
                //86408 [Training] Popup Box not displaying for invalid ESN enter for the second attempt. - By Krishna at 30-03-2017  
                siebelSMN = '';
                // siebAppCode= '';
                siebelWarrantyDate= null;
                system.debug('state' + ' ' + state);
                if(state == NULL)
                {
                   // mainContr.psnRec.Failure_Date__c= system.today();
                    mainContr.psnRec.Before_In_Service__c=false;
                }
                //mainContr.psnRec.Application_Desc__c = ''; need to check this
                siebVIN='';
                if(mainContr.claimsRec !=null && mainContr.claimsRec.TSR1__c!='' || mainContr.claimsRec.TSR1__c !=null )
                {
                    mainContr.claimsRec.TSR1__c = null;
                }
                if(mainContr.claimsRec !=null && mainContr.claimsRec.TSR2__c!='' || mainContr.claimsRec.TSR2__c !=null )
                {
                    mainContr.claimsRec.TSR2__c = null;
                }
                if(mainContr.claimsRec !=null && mainContr.claimsRec.TSR3__c!='' || mainContr.claimsRec.TSR3__c !=null )
                {
                    mainContr.claimsRec.TSR3__c = null;
                }
                if(mainContr.claimsRec !=null && mainContr.claimsRec.TSR4__c!='' || mainContr.claimsRec.TSR4__c !=null )
                {
                    mainContr.claimsRec.TSR4__c = null;
                }
                if(mainContr.claimsRec !=null && mainContr.claimsRec.TSR5__c!='' || mainContr.claimsRec.TSR5__c !=null )
                {
                    mainContr.claimsRec.TSR5__c = null;
                }
                if(mainContr.claimsRec !=null && mainContr.claimsRec.TSR6__c!='' || mainContr.claimsRec.TSR6__c !=null )
                {
                    mainContr.claimsRec.TSR6__c = null;
                }
                if(mainContr.claimsRec !=null && mainContr.claimsRec.TSR7__c!='' || mainContr.claimsRec.TSR7__c !=null )
                {
                    mainContr.claimsRec.TSR7__c = null;
                }
                if(mainContr.claimsRec !=null && mainContr.claimsRec.TSR8__c!='' || mainContr.claimsRec.TSR8__c !=null )
                {
                    mainContr.claimsRec.TSR8__c = null;
                }
                if(mainContr.claimsRec !=null && mainContr.claimsRec.TSR9__c!='' || mainContr.claimsRec.TSR9__c !=null )
                {
                    mainContr.claimsRec.TSR9__c = null;
                }
                if(mainContr.claimsRec !=null && mainContr.claimsRec.TSR10__c!='' || mainContr.claimsRec.TSR10__c !=null )
                {
                    mainContr.claimsRec.TSR10__c = null;
                }
                if(mainContr.claimsRec !=null &&  mainContr.claimsRec.Catastrophic__c !=null )
                {
                    mainContr.claimsRec.Catastrophic__c =false;
                }
                if(mainContr.claimsRec !=null && mainContr.claimsRec.Authorization_Comments__c!='' || mainContr.claimsRec.Authorization_Comments__c !=null )
                {
                    mainContr.claimsRec.Authorization_Comments__c = null;
                }


                CSS_getEngineDataResponseJ2A rDataPlate = new CSS_getEngineDataResponseJ2A(); //GSSC_97, ROD:Qsol changes
                
                //Calling SiebelWS to get data 63173-Start
                CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
                CSS_getEngineDataResponseJ2A  engineData;
                CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
                jidi.ESN=mainContr.psnRec.PSN__c;
                wrapobj.DataArea = jidi;

                engineData = CSS_WS_SBL.getEngineData(wrapobj);

                system.debug('Testebgineda'+engineData);

                if((engineData==null || engineData.DataArea == null) || (engineData.Header ==null || engineData.Header.Status==null 
                       || engineData.Header.Status.trim()=='' || engineData.Header.Status.touppercase() !='SUCCESS') )
                {
                try{
                     rDataPlate = CG_BL_Intake.GetEngineDataPlateQSOL(mainContr.psnRec.PSN__c); //GSSC_97, ROD:Qsol changes
                    system.debug('rDataPlate>>>'+rDataPlate);

                    //start Moulika
                    //String Billdate=rDataPlate.buildDate;
                    String Billdate;
                    if(rDataPlate != null && rDataPlate.DataArea !=null)
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
                }catch(exception e){
                    system.debug('Entered into catch block of QSOL Webservice Call'+e.getMessage()+ ' ' + e.getLineNumber());
                }
                    
                }    
                
            //if( (rDataPlate == null || rDataPlate.DataArea == null) &&  (engineData == null || engineData.DataArea == null || !engineData.Header.Status.contains('Success')))
            if( (rDataPlate == null) &&  (engineData == null || !engineData.Header.Status.contains('Success')))//GSSC-329
                {
                //mainContr.PSNFlag=true;
                 mainContr.claimsRec.CG_Get_Engine_data_flag__c=true;
                        
                        CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                        intEngError.Processed_Data__c =  String.valueOf(wrapobj);
                        intEngError.Response_Body__c = 'Service Failed Or No Data Found';
                        intEngError.Service_Job_Number__c = mainContr.claimsRec.Name;
                        intEngError.Service_Name__c = 'GetEngineDataService';
                        intEngError.Source__c = 'SIEBEL';
                        //intEngError.WWID__c = FedId; 
                        
                        insert intEngError;
                        system.debug('TEstlog'+intEngError);
                
            }
            else{
                       // mainContr.PSNFlag=false;
                        if(mainContr != null && mainContr.claimsRec != null) // Added null check
                       mainContr.claimsRec.CG_Get_Engine_data_flag__c=false;
                    }
                /*end*/
                system.debug(' mainContr.PSNFlag>>>>'+ mainContr.PSNFlag);
                system.debug('engineData>>>>'+engineData);
                if (engineData !=null && engineData.DataArea != null && engineData.Header.Status.contains('Success')){
                    //  if (String.valueOf(engineData.DataArea.ProdAppDesc)!='')
                    //     siebAppCode = css_utility.getCodes('Application Code',string.valueOf(engineData.DataArea.ProdAppDesc),null,null);
                    // if(siebAppCode !='' || siebAppCode !=null){
                    //     system.debug('siebelApp>>>:'+string.valueOf(engineData.DataArea.ProdAppDesc));

                    //added below snippet to default returned value to Application picklist if it's already there if not don't add/default(bms users) - Vignesh
                    List<SelectOption> applicationPL = getApplication();
                    Set<String> listOfApplication = new Set<String>();
                    for(SelectOption sOption : applicationPL) {
                        listOfApplication.add(sOption.getValue());
                    }
                    // if(listOfApplication.contains(String.valueOf(engineData.DataArea.ProdAppDesc)))

                    List<CSS_List_Of_Values__c> ListOfValues = CSS_List_Of_Values__c.getall().values();//As per defect 153864 by vamshi                       
                    System.debug('ListOfValues....'+ListOfValues);
                    for(Integer i = 0; i < ListOfValues.size() ; i++){
                        if(ListOfValues[i].Code__c == engineData.DataArea.EngineAppCode){
                            mainContr.filterApplication = ListOfValues[i].Picklist_Values_1__c;
                            break;
                        } 
                        else{
                            mainContr.filterApplication = '';
                        }
                    }      
                    //mainContr.filterApplication = String.valueOf(engineData.DataArea.ProdAppDesc);
                    // }                    
                    if (String.valueOf(engineData.DataArea.ServiceModelName)!=''  )
                        siebelSMN = engineData.DataArea.ServiceModelName;

                    if (String.valueOf(engineData.DataArea.WarrantyStartDate)!='')               
                    { siebelWarrantyDate = date.valueOf(String.valueOf(engineData.DataArea.WarrantyStartDate));
                     system.debug('siebelWarrantyDate**'+siebelWarrantyDate);

                     //Engine Equipment ID added for story144598
                     if(engineData.DataArea.EquipmentId != ''){
                         equipmentId = string.valueOf(engineData.DataArea.EquipmentId);
                         system.debug('Equipment Id' + equipmentId);
                     }

                     /* date MonDate = siebelWarrantyDate;
    system.debug('MonDate**'+MonDate);
    date NewDate = new date("dd-mon-yyyy");
    string currDate = NewDate.format(MonDate);
    system.debug('MyyDate**'+currDate);*/
                     /*datetime currentDate= siebelWarrantyDate;
    string currDate = currentDate.format('YYYY-MM-dd','GMT'); //+ 'T' + currentDate.format('HH:mm:ss','GMT');
    system.debug('currentDate**'+currentDate);
    system.debug('currDate**'+currDate);*/
                    }

                    if (String.valueOf(engineData.DataArea.Manufacturer) !=''){
                        mainContr.filterMake = engineData.DataArea.Manufacturer;
                        //Chking if Make exists in CSS
                        //mainContr.filterMake = css_utility.getMake(mainContr.filterMake);
                        mainContr.filterMake = css_utility.getMake(mainContr.filterMake, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);//Code updated for story 144598
                    }else{ 

                        // mainContr.filterMake = '';
                    }
                    system.debug('Model--->'+string.valueOf(engineData.DataArea.Model));
                    if (String.valueOf(engineData.DataArea.Manufacturer) !='' && String.valueOf(engineData.DataArea.Model) !='' ){
                        mainContr.filterModel= engineData.DataArea.Model;
                        //chking if Model exists
                        //mainContr.filterModel = css_utility.getModel(mainContr.filterMake,mainContr.filterModel);
                        mainContr.filterModel = css_utility.getModel(mainContr.filterMake,mainContr.filterModel,engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);//Code updated for story 144598
                    }else{

                        // mainContr.filterModel = '';
                    }
                    //Unit Configuration
                    system.debug('Unit Configuration'+string.valueOf(engineData.DataArea.EquipmentConfiguration));
                    if(string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){
                        if(engineData.DataArea.EquipmentConfiguration !=null && engineData.DataArea.EquipmentConfiguration !='')
                            mainContr.filterUnitType = engineData.DataArea.EquipmentConfiguration;
                        //else
                        //mainContr.filterUnitType = css_utility.getUnitype(mainContr.filterMake,mainContr.filterModel);
                        mainContr.filterUnitType = css_utility.getUnitype(mainContr.filterMake,mainContr.filterModel,mainContr.filterUnitType,engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);//Code update for story 144598
                        system.debug('CSS_UTILITY----->' +mainContr.filterUnitType);
                    }else{
                        //mainContr.filterUnitType = '';
                    }
                    if (String.valueOf(engineData.DataArea.vin) !='' && string.valueOf(engineData.DataArea.vin) !='' ){
                        siebVIN = string.valueOf(engineData.DataArea.vin);
                    }


                    // add new engine data new fields
                    mainContr.claimsRec.BillToCode__c = engineData.DataArea.EngineBillToCode;
                    mainContr.claimsRec.ProductApplicationDesp__c = engineData.DataArea.ProdAppDesc;
                    mainContr.claimsRec.ProductApplicationCode__c = engineData.DataArea.ProdAppCode;
                    if(engineData.DataArea.BuildDate != null && engineData.DataArea.BuildDate !=''){
                        mainContr.claimsRec.BuildDate__c = Date.valueOf(engineData.DataArea.BuildDate);}
                    mainContr.claimsRec.DesignPhaseCode__c = engineData.DataArea.DesignPhaseCode;
                    mainContr.claimsRec.EngineFamilyCode__c = engineData.DataArea.EngineFamilyCode;
                    if(engineData.DataArea.EtoConversionDate != null && engineData.DataArea.EtoConversionDate !=''){
                        mainContr.claimsRec.EtoConversionDate__c = Date.valueOf(engineData.DataArea.EtoConversionDate);
                        etoConversiondt = engineData.DataArea.EtoConversionDate;
                        //added for 156819 by venkat
                        System.debug('** Anirudh EngineData'+engineData.DataArea.ETOOldESN);
                        if(engineData.DataArea.ETOOldESN != null && engineData.DataArea.ETOOldESN.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(engineData.DataArea.ETOOldESN));
                        System.debug('** ReconFlag'+recconFlag);
                        if(recconFlag == true){
                            mainContr.claimsRec.ReconEngineFlag__c = 'Y';
                        }
                        else{
                            mainContr.claimsRec.ReconEngineFlag__c = 'N';
                        }
                    }
                    else{
                        system.debug('mainContr.psnRec.PSN__c'+mainContr.psnRec.PSN__c);
                        /*if(mainContr.claimsRec.ESN__c != null && mainContr.claimsRec.ESN__c.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(mainContr.claimsRec.ESN__c));*/
                        if(mainContr.psnRec.PSN__c != null && mainContr.psnRec.PSN__c.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(mainContr.psnRec.PSN__c));
                        System.debug('** ReconFlag'+recconFlag);
                        if(recconFlag == true){
                            mainContr.claimsRec.ReconEngineFlag__c = 'Y';
                        }
                        else{
                            mainContr.claimsRec.ReconEngineFlag__c = 'N';
                        }
                    }
                    system.debug('engineData.DataArea.PACCARFlag'+engineData.DataArea.PACCARFlag);
                    mainContr.psnRec.PACCAR_Flag__c = engineData.DataArea.PACCARFlag;
                    mainContr.claimsRec.MarineFlag__c = engineData.DataArea.MarineAppFlag;
                    mainContr.claimsRec.OemCode__c = engineData.DataArea.OEMSPCode;
                    system.debug('engineData.DataArea.ProdAppCode>>>>>>'+engineData.DataArea);
                    mainContr.claimsRec.ProductApplicationDesp__c = engineData.DataArea.ProdAppDesc;
                    mainContr.claimsRec.ProductApplicationCode__c = engineData.DataArea.ProdAppCode;
                    mainContr.claimsRec.warrantyIndicatorFlag__c = (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'Y' ? 'N' : (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'N' ? 'Y' : '')) ;
                    //mainContr.claimsRec.warrantyIndicatorFlag__c = (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'Y' ? 'Y' : (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'N' ? 'N' : '')) ;
                    
                    mainContr.claimsRec.Automotive_App_Flag__c  = engineData.DataArea.AutomotiveAppFlag;
                    //EtoConversion = mainContr.claimsRec.EtoConversionDate__c;

                    //Story# 153520
                    system.debug('***EngineFamilyName**'+engineData.DataArea.EngineFamilyName);
                    system.debug('***ShipDate**'+engineData.DataArea.ShipDate);
                    system.debug('***ETOOldESN**'+engineData.DataArea.ETOOldESN);
                    mainContr.claimsRec.EngineFamilyName__c = engineData.DataArea.EngineFamilyName;
                    if(engineData.DataArea.ShipDate != null && engineData.DataArea.ShipDate !='')
                        mainContr.claimsRec.ShipDate__c = Date.valueOf(engineData.DataArea.ShipDate);
                    mainContr.claimsRec.ETOOldESN__c = engineData.DataArea.ETOOldESN;

                    system.debug('engineData.DataArea.ProdAppDesc'+ engineData.DataArea.ProdAppDesc);
                    productAppdesc =  engineData.DataArea.ProdAppDesc;

                    system.debug('engineData.DataArea.ProdAppCode'+ engineData.DataArea.ProdAppCode);
                    productAppcode = engineData.DataArea.ProdAppCode;

                }
                else{
                    mainContr.filterMake = '';
                    mainContr.filterModel = '';
                    mainContr.filterUnitType = '';
                    // mainContr.psnRec.Failure_Date__c= system.today();
                    // mainContr.psnRec.Before_In_Service__c=null;



                    //mainContr.TSR2__c=null;
                    if(mainContr.claimsRec.Id != null){
                        for(CSS_Solution_Component__c solObj: [Select id , ODM_Status__c, CSS_Claims__c from CSS_Solution_Component__c where CSS_Claims__c =: mainContr.claimsRec.Id]){
                            solObj.ODM_Status__c = 'YTBV';
                            updateSolCompList.add(solObj);

                        }
                        for(CSS_Parts_Options__c partObj: [Select id , ODM_Status__c, CSS_Claims__c from CSS_Parts_Options__c where CSS_Claims__c =: mainContr.claimsRec.Id]){
                            partObj.ODM_Status__c = 'YTBV';
                            updatePartOption.add(partObj);

                        }
                        for(CSS_SRT__c srtObj: [Select id , ODM_Status__c, CSS_Claims__c from CSS_SRT__c where CSS_Claims__c =: mainContr.claimsRec.Id]){
                            srtObj.ODM_Status__c = 'YTBV';
                            updateSRT.add(srtObj);

                        }

                        //if(mainContr.claimsRec.ESN__c.isNumeric())
                        //  recconFlag = css_utility.getReconEngine(decimal.valueof(mainContr.claimsRec.ESN__c));
                        if(mainContr.psnRec.PSN__c.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(mainContr.psnRec.PSN__c));
                        System.debug('** ReconFlag'+recconFlag);
                        if(recconFlag == true){
                            mainContr.claimsRec.ReconEngineFlag__c = 'Y';
                        }
                        else{
                            mainContr.claimsRec.ReconEngineFlag__c = 'N';
                        }
                    }



                }
                //End Calling SiebelWS to get data 63173


               sServiceModel = (rDataPlate != null && rDataPlate.DataArea != null? rDataPlate.DataArea.ServiceModelName : '');
                //sServiceModel = rDataPlate.DataArea.ServiceModelName;

                //Added Conditions to Display the popup by Rajasekhar H for Story #154597 I-Survived

                /* if((sServiceModel == null || sServiceModel == '') && (siebelSMN==null || siebelSMN == '')){
                            if(mainContr.psnRec.PSN__c.isNumeric() && mainContr.psnRec.PSN__c.length() == 8){
                                system.debug('SMN'+sServiceModel);
                            system.debug('entered one');
                            displayPSNSrvModPopup=true;
                            }
                         /*else if(mainContr.psnRec.PSN__c.isNumeric() && mainContr.psnRec.PSN__c.length() == 9){
                                system.debug('SMN'+sServiceModel);
                            system.debug('entered one');
                            displayPSNSrvModPopup=true;
                            }*/

                /* else if(mainContr.psnRec.PSN__c.isAlphaNumeric() && mainContr.psnRec.PSN__c.length() == 8){
                        system.debug('entered two');
                            displayPSNSrvModPopup=true;
                    }
                }

                       if((sServiceModel == null || sServiceModel == '') || (siebelSMN==null || siebelSMN == '')){
                          if(mainContr.psnRec.PSN__c.length() > 8 && mainContr.psnRec.PSN__c.isNumeric()) {
                           system.debug('entered three');
                    //if((mainContr.psnRec.PSN__c.length() < 8 || mainContr.psnRec.PSN__c.length() > 8) && mainContr.psnRec.PSN__c.isNumeric()){
                 displayPSNSrvModPopup=true;
                        system.debug('displayPSNSrvModPopup1'+displayPSNSrvModPopup);
                        System.debug('mainContr.psnRec.PSN__c.isNumeric()'+mainContr.psnRec.PSN__c.isNumeric());
                        System.debug('mainContr.psnRec.PSN__c.length()'+mainContr.psnRec.PSN__c.length());
                    }

    System.debug('mainContr.psnRec.PSN__c.isAlphaNumeric()'+mainContr.psnRec.PSN__c.isAlphaNumeric());
                   /* if((mainContr.psnRec.PSN__c.length() < 8 || mainContr.psnRec.PSN__c.length() > 8) && mainContr.psnRec.PSN__c.isAlphaNumeric()){
                                               system.debug('entered four');
                        displayPSNSrvModPopup=false;
                        system.debug('displayPSNSrvModPopup2'+displayPSNSrvModPopup);
                    }*/
                //}

                //End of Conditions for Story #154597 I-Survived




                if ((sServiceModel =='' || sServiceModel==null) && (siebelSMN !='' && siebelSMN != null)){                    
                    sServiceModel = siebelSMN;
                }
                mainContr.psnRec.Service_Model__c = sServiceModel;
                system.debug('SMN>>>:'+siebelSMN+' '+mainContr.psnRec.Service_Model__c);
                //  system.debug('Data is siebelSMN>>:'+siebelSMN+' siebAppCode>>:'+siebAppCode+' siebelWarrantyDate>>:'+siebelWarrantyDate+' filterMake>>:'+mainContr.filterMake+' filterModel>>:'+mainContr.filterModel);
                //Kalpana Added Code for 154597
                if(mainContr.ClaimsRec.css_job__c == null){
                    if((sServiceModel == null || sServiceModel == '') && mainContr.psnRec.PSN__c.length() == 8){
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
                }    
               // if(rDataPlate != null && rDataPlate.technicalConfig != null){
                /*if(rDataPlate!=null && rDataPlate.DataArea !=null && rDataPlate.DataArea.EquipmentConfiguration != null ){
                    sEngineFamilyCode = rDataPlate.DataArea.EquipmentConfiguration.substring(1,3);}
                else{
                    sEngineFamilyCode = engineData.DataArea.EngineFamilyCode; 
                }*/
                if(engineData.DataArea.EngineFamilyCode != null ){
                    sEngineFamilyCode =engineData.DataArea.EngineFamilyCode;                        
                }else{
                    sEngineFamilyCode = rDataPlate.DataArea.EngineFamilyCode;
                }
                
                
                mainContr.psnRec.Qsol_Engine_Family_Code__c=sEngineFamilyCode;


                if (string.valueof(siebelWarrantyDate) !=''  && string.valueof(siebelWarrantyDate) != null){
                    mainContr.psnRec.Warranty_Start_Date__c=siebelWarrantyDate;
                    mainContr.wsdReadOnlyFromContr = true;
                    System.debug('MyDate**'+mainContr.psnRec.Warranty_Start_Date__c.year() + '-' + mainContr.psnRec.Warranty_Start_Date__c.month() + '-' + mainContr.psnRec.Warranty_Start_Date__c.day());
                    //mainContr.FormattedDate = CG_BL_Intake.FormatDate(mainContr.psnRec.Warranty_Start_Date__c);

                    system.debug('Checking siebel warranty>>:'+mainContr.psnRec.Warranty_Start_Date__c+siebelWarrantyDate);
                    mainContr.psnRec.Before_In_Service__c = false;
                    mainContr.ExternReturnDateFlag = true;
                    ExternReturnDateFlag = true;
                    ReadonlyBIS=false;
                }else if (rDataPlate!=null && rDataPlate.DataArea !=null && rDataPlate.DataArea.warrantyStartDate != null && rDataPlate.DataArea.warrantyStartDate != '') {
                    //system.debug('Checking dataplate warranty'+rDataPlate.warrantyStart);
                    //mainContr.psnRec.Warranty_Start_Date__c  = CG_BL_Intake.parseQSOLDate(rDataPlate.warrantyStart);
                    system.debug('Checking dataplate warranty'+mainContr.psnRec.Warranty_Start_Date__c);
                    try{
                        if(rDataPlate!=null && rDataPlate.DataArea !=null)
                            mainContr.psnRec.Warranty_Start_Date__c = parseQSOLDate(rDataPlate.DataArea.warrantyStartDate);
                        //mainContr.psnRec.Warranty_Start_Date__c  = CG_BL_Intake.parseQSOLDate(rDataPlate.warrantyStart);
                    }catch(Exception e){
                        system.debug('EXCEPTION of warrantyStart date convertion CG_CL_ClaimsUEOneBMS  >>>:'+e.getMessage() + ' Line No>>>:' + e.getLineNumber() + ' Cause>>:' +e.getCause());
                    }

                    /*system.debug('Checking dataplate warranty'+mainContr.psnRec.Warranty_Start_Date__c);
    string myDate = string.valueof(mainContr.psnRec.Warranty_Start_Date__c);
    system.debug('Checking dataplate warranty**'+myDate);*/
                    mainContr.psnRec.Before_In_Service__c =  false;
                    mainContr.ExternReturnDateFlag = true;
                    ExternReturnDateFlag = true;
                    ReadonlyBIS=false;
                    mainContr.wsdReadOnlyFromContr = true;
                    /*datetime currentDate= date.valueof(rDataPlate.warrantyStart);
    string currDate = currentDate.format('YYYY-MM-dd','GMT'); //+ 'T' + currentDate.format('HH:mm:ss','GMT');
    system.debug('currentDate**'+currentDate);
    system.debug('currDate**'+currDate);*/
                }else{
                    system.debug('Checking before in service');
                    //mainContr.psnRec.Warranty_Start_Date__c = null;
                    mainContr.wsdReadOnlyFromContr = false; 
                    mainContr.ExternReturnDateFlag = false;
                    ExternReturnDateFlag = false;
                }
                /*mainContr.psnRec.VIN__c = (rDataPlate != null ? rDataPlate.data[0].vin : ''); //Added for CUBS defect # 78702
                if((rDataPlate != null && (rDataPlate.data[0].vin == '' || rDataPlate.data[0].vin == null)) && (siebVIN !='' && siebVIN !=null)){
                    mainContr.psnRec.VIN__c = siebVIN;
                }*/

                if( rDataPlate!=null && rDataPlate.DataArea !=null && rDataPlate.DataArea.vin != null && rDataPlate.DataArea.vin != ''){
                    mainContr.psnRec.VIN__c = rDataPlate.DataArea.vin;
                }else{
                    mainContr.psnRec.VIN__c = (siebVIN != null && siebVIN != '' ? siebVIN : '');
                }
                if (mainContr.filterMake !='' && mainContr.filterMake != null){
                    mainContr.psnRec.Make__c = mainContr.filterMake;                  
                }
                if (mainContr.filterModel != '' && mainContr.filterModel!= null){
                    mainContr.psnRec.Model__c= mainContr.filterModel;
                }
                if(mainContr.filterUnitType != '' && mainContr.filterUnitType != null){
                    mainContr.psnRec.Unit_Type__c=mainContr.filterUnitType;
                }
                System.debug('sServiceModel: '+sServiceModel);

               //Calling GetCampaigns & QSOL URLs
                if(mainContr.psnRec.Failure_Date__c !=null){
                    mainContr.region = '';
                    CSS_accountLanguage__c accountlang = css_utility.getLanguage(mainContr.userObj.LanguageLocaleKey);
                    system.debug('mainContr.userObj**'+mainContr.userObj);
                    system.debug('mainContr.userObj.User_Location__c**'+mainContr.userObj.User_Location__c);
                    system.debug('accountlang**'+accountlang);
                    system.debug('Maincontol'+mainContr.psnRec.Id);
                    system.debug('Maincontol'+mainContr.PsnId);
                    List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(mainContr.psnRec.PSN__c, sServiceModel, mainContr.psnRec.Failure_Date__c, accountlang.CSS_QsolLanguage__c, mainContr.psnRec.Id);
                    //system.debug('campaignsList**'+campaignsList+'**size**'+campaignsList.size());
                    /*if(campaignsList == null){
                    mainContr.claimsRec.FieldActionWebServiceResult__c = 'Error'; }
                    else{
                        mainContr.claimsRec.FieldActionWebServiceResult__c = 'Success';
                    }*/
                    if(campaignsList !=null && campaignsList.size()>0)
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
                   
                     if(campaignsList !=null && campaignsList.size()>=4){
                         
                        List<CSS_CampTsbTrp__c> campaigns4List = new List<CSS_CampTsbTrp__c>();
                        campaigns4List = campaignsList.get(4);
                        integer capsize = campaigns4List.size();
                         
                    if(campaignsList.get(4).get(capsize-1).Type__c=='FAError'){
                       if(campaignsList.get(4).get(capsize-1).Doc_Num__c=='Error') {
                            mainContr.claimsRec.FieldActionWebServiceResult__c = 'Error';
                            system.debug('campagins inside if');
                        }else{
                             mainContr.claimsRec.FieldActionWebServiceResult__c = 'Success';
                             system.debug('campagins inside else');
                             }
                  
                    }
                }
                
                system.debug('sama mainContr.claimsRec.FieldActionWebServiceResult__c>>' + mainContr.claimsRec.FieldActionWebServiceResult__c );
                    
                    mainContr.region = mainContr.claimsRec.Account__r.Region__c;
                    try{
                        //if(campaignsList !=null && campaignsList.size()>=5){
                            //system.debug('outsidecapaignSPData**'+campaignsList.get(5).get(0).Type__c);
                            //if(campaignsList.get(5).get(0).Type__c=='SPData'){
                                system.debug('mainContr.claimsRec.Account__c**'+mainContr.claimsRec.Account__c);
                                system.debug('mainContr.userObj.User_Location__c...'+mainContr.userObj.User_Location__c);
                                system.debug('mainContr.claimsRec.Location_Code__c-->'+mainContr.claimsRec.Location_Code__c);
                                if(mainContr.userObj.User_Location__c != null)
                                    accredList = [SELECT id, EndDate__c,Service_Model_Name__c,StartDate__c,Account__c,Account__r.Location__c FROM CSS_Accreditation__c where Account__r.Location__c =: mainContr.userObj.User_Location__c];
                                
                                String selectedLocation;
                                selectedLocation = mainContr.claimsRec.Location_Code__c;
                                if(selectedLocation==null || selectedLocation==''){
                                    //selectedLocation = ([select Id,User_Location__c,FederationIdentifier,LanguageLocaleKey from User where id=:UserInfo.getUserId() LIMIT 1]).User_Location__c;
                                    selectedLocation = mainContr.LocationManualClaims;
                                }
                                String spCode = selectedLocation.trim().right(5); //take last 5 digits here
                                system.debug('first spCode>:'+spCode);
                                spCode = spCode.trim();
                                
                                String failureDateStr = DateTime.newInstance(mainContr.psnRec.Failure_Date__c.year(),mainContr.psnRec.Failure_Date__c.month(),mainContr.psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                                System.debug('failureDateStr>>>:'+failureDateStr+' spCode>>:'+spCode);
                                
                                CSS_GetServiceProviderResponse outputRes = CSS_FN_SIEBEL.getServiceProviderDataWrapper(spCode.trim(), '', failureDateStr,mainContr.ClaimsRec.Name);
                                //CSS_GetServiceProviderResponse outputRes = (CSS_GetServiceProviderResponse)JSON.deserializeStrict(serviceProviderResponse.getbody(), CSS_GetServiceProviderResponse.class);
                                system.debug('Response Data'+outputRes);
                                mainContr.spDataWrapper = outputRes;
                                if(outputRes!=null){
                                    mainContr.claimsRec.SPDataWebserviceResult__c='Success';
                                    system.debug('outputRes.DataArea.ChannelOfDistribution>>>>>>'+outputRes.DataArea.ChannelOfDistribution);
                                    mainContr.claimsRec.SP_CHANNEL_OF_DISTRIBUTION__c = outputRes.DataArea.ChannelOfDistribution;
                                    mainContr.claimsRec.CSS_Channel_Of_Distribution__c = outputRes.DataArea.ChannelOfDistribution;
                                    mainContr.claimsRec.SP_CLAIM_ALLOWED_DAYS__c = outputRes.DataArea.ClaimAllowedDays;
                                    mainContr.claimsRec.SP_CMI_SP_EXPIRATION__c = outputRes.DataArea.CMISPExpirationDate;
                                    mainContr.claimsRec.SP_LTA_FLAG__c = outputRes.DataArea.LTAFlag;
                                    mainContr.claimsRec.SP_OUTFILE_ALL_CLAIMS__c = outputRes.DataArea.OutfileAllClaims;
                                    mainContr.claimsRec.SP_PACCAR__c = outputRes.DataArea.PACCAR;    
                                    mainContr.claimsRec.SP_REGION__c = outputRes.DataArea.Region; 
                                    mainContr.claimsRec.SP_ACCOUNT_STATUS__c = outputRes.DataArea.AccountStatus; 
                                    mainContr.claimsRec.SP_TERRITORY_CODE__c = outputRes.DataArea.TerritoryCode; 
                                    mainContr.claimsRec.SP_Group_Name__c = outputRes.DataArea.GroupName; 
                                    mainContr.claimsRec.SP_TERRITORY__c  = outputRes.DataArea.Territory; 
                                    mainContr.claimsRec.SP_REGIONCODE__c = outputRes.DataArea.RegionCode; 
                                    mainContr.claimsRec.CSS_Channel_Code__c = outputRes.DataArea.ChannelCode;
                                    mainContr.claimsRec.Territory_Class__c = outputRes.DataArea.TerritoryCode; 
                                    mainContr.claimsRec.Territory_Class_Name__c = outputRes.DataArea.Territory; 
                                    mainContr.claimsRec.SP_PromotionId__c = outputRes.DataArea.PromotionId;
                                    mainContr.claimsRec.SP_Country__c = outputRes.DataArea.SPCountry;
                                    mainContr.claimsRec.CSS_Travel_Rate__c = outputRes.DataArea.TravelRate;//Added By RAJESH as per "I Survived" sprint story #152967,-By RAJESH 27th July 2018
                                    mainContr.claimsRec.SP_INSHOP_LABOR_RATE__c = outputRes.DataArea.InShopLaborRate; //Added by Rajesh Narra
                                    mainContr.claimsRec.SP_FIELD_SERVICE_LABOR_RATE__c = outputRes.DataArea.FieldServiceLaborRate;// Added by Rajesh Narra
                                    mainContr.claimsRec.SP_SCMDeductiblePercentage__c = outputRes.DataArea.SCMDeductiblePercentage;
                                    mainContr.claimsRec.SP_State__c = outputRes.DataArea.State;
                                    mainContr.claimsRec.SP_WarrantyTrainingStatus__c = outputRes.DataArea.warrantyTrainingStatus;
                                    mainContr.claimsRec.SP_SCMDollarAmt__c = outputRes.DataArea.SCMDollarAmt;
                                    mainContr.claimsRec.SP_PrimaryOEMCode__c = outputRes.DataArea.PrimaryOEMCode;
                                    mainContr.claimsRec.SP_WarrantyCertificationEndDate__c = outputRes.DataArea.WarrantyCertificationEndDate;
    
                                    String AccountId;
                                    //String WRCertificationFlag;
                                    Boolean WRCertificationFlag;
                                    Boolean ProductCrtification;
                                    String warrTrainingStatus;
                                    Date CertEndDate;
    
                                    if(mainContr.claimsRec.Id == null){
                                        system.debug('LocationManualClaims'+mainContr.LocationManualClaims);
                                        String selectedLocCode = mainContr.LocationManualClaims.trim().right(5);
                                        Account Acc = [select id,Warranty_Training_Status__c,Warranty_Training_Certification__c,CERTIFICATION_END_DATE__c,WR_Certfication_Flag__c,Product_Certification__c from Account where IAM_Service_Provider_Code__c =: selectedLocCode or IAM_Service_Provider_Code__c =: selectedLocCode limit 1];
                                        system.debug('Anirudh Acc>>>>>>'+Acc);
                                        AccountId = Acc.id;
                                        //WRCertificationFlag = Acc.WR_Certfication_Flag__c;
                                        WRCertificationFlag = Acc.Warranty_Training_Certification__c;
                                        ProductCrtification = Acc.Product_Certification__c;
                                        warrTrainingStatus = Acc.Warranty_Training_Status__c;
                                        CertEndDate = Acc.CERTIFICATION_END_DATE__c;
                                    }else{
                                        AccountId = mainContr.claimsRec.Account__c;
                                        //WRCertificationFlag = mainContr.claimsRec.Account__r.WR_Certfication_Flag__c;
                                        WRCertificationFlag = mainContr.claimsRec.Account__r.Warranty_Training_Certification__c;
                                        ProductCrtification = mainContr.claimsRec.Account__r.Product_Certification__c;
                                        warrTrainingStatus = mainContr.claimsRec.Account__r.Warranty_Training_Status__c;
                                        CertEndDate = mainContr.claimsRec.Account__r.CERTIFICATION_END_DATE__c;
                                    }
    
    
                                    map<String,String> accCerts = CG_BL_Intake.getCertificationStatus(mainContr.psnRec.Service_Model__c,mainContr.psnRec.Failure_Date__c,AccountId,WRCertificationFlag,ProductCrtification,warrTrainingStatus,CertEndDate);
                                    if(accCerts.containsKey('certStatus')){                       
                                        mainContr.claimsRec.Product_Certification__c=accCerts.get('certStatus');
                                    }
                                    system.debug('mainContr.claimsRec.Product_Certification__c'+mainContr.claimsRec.Product_Certification__c);
                                    //story - 153618
                                    Boolean isActive = true;
                                    Boolean dupSMNisActive;
                                    Date warrantyCertDate;
                                    Map<String,List<CSS_Accreditation__c>> accredMap = new Map<String,List<CSS_Accreditation__c>>();
                                    Set<String> smnSet = new Set<String>();
                                    List<CSS_Accreditation__c> accList = new List<CSS_Accreditation__c>();
                                    system.debug('****mainContr.claimsRec.SP_WarrantyCertificationEndDate__c**'+mainContr.claimsRec.SP_WarrantyCertificationEndDate__c);
    
                                    if(mainContr.claimsRec.SP_WarrantyCertificationEndDate__c!=null && mainContr.claimsRec.SP_WarrantyCertificationEndDate__c!='')
                                        warrantyCertDate = Date.valueOf(mainContr.claimsRec.SP_WarrantyCertificationEndDate__c) +180;
                                    //system.debug('****warrantyCertDate**'+warrantyCertDate);
                                    //system.debug('****accredList**'+accredList.size()+'****'+accredList);
                                    for(CSS_Accreditation__c accredObj:accredList){
                                        smnSet.add(accredObj.Service_Model_Name__c);
                                        if(!accredMap.containsKey(accredObj.Service_Model_Name__c)){
                                            accredMap.put(accredObj.Service_Model_Name__c,new List<CSS_Accreditation__c>());
                                        }
                                        accredMap.get(accredObj.Service_Model_Name__c).add(accredObj);
                                    }
                                    //system.debug('****accredMap**'+accredMap.size());
                                    //system.debug('****mainContr.psnRec.Failure_Date__c**'+mainContr.psnRec.Failure_Date__c);
                                    for(String s:accredMap.keySet()){
                                        dupSMNisActive = false;
                                        accList=accredMap.get(s);
                                        if(isActive==false){
                                            break;
                                        }
                                        //system.debug('****accList.size**'+accList.size());
    
                                        for(CSS_Accreditation__c accredObj: accList){
                                            if((mainContr.psnRec.Failure_Date__c >= accredObj.StartDate__c && mainContr.psnRec.Failure_Date__c <= accredObj.EndDate__c)){
                                                system.debug('***insidedupSMNisActiveTrue*'+accredObj.StartDate__c+'****end**'+accredObj.EndDate__c);
                                                dupSMNisActive=true;
                                                break;
                                            }
                                            else{
                                                dupSMNisActive=false;
                                                system.debug('***insidedupSMNisActivefalse*'+accredObj.StartDate__c+'****end**'+accredObj.EndDate__c);
                                                if(dupSMNisActive == false && accList.size()==1){
                                                    isActive=false;
                                                }
                                            }
                                        }
    
                                    }
                                    //163193
                                    system.debug('outputRes.DataArea.WarrantyTrainingCertification****' + outputRes.DataArea.WarrantyTrainingCertification);
                                    if(outputRes.DataArea.WarrantyTrainingCertification == 'N'){
                                        system.debug('Not Applicable');
                                        mainContr.claimsRec.Warranty_Authorization_Flag__c = 'Not Applicable';
                                    }
                                    else if(outputRes.DataArea.WarrantyTrainingCertification == 'Y' && (mainContr.claimsRec.SP_WarrantyTrainingStatus__c != 'R' && mainContr.claimsRec.SP_WarrantyTrainingStatus__c != Null && mainContr.claimsRec.SP_WarrantyTrainingStatus__c != '')){
                                        system.debug('Certified');
                                        mainContr.claimsRec.Warranty_Authorization_Flag__c = 'Certified';
                                    }else if(outputRes.DataArea.WarrantyTrainingCertification == 'Y' && (mainContr.claimsRec.SP_WarrantyTrainingStatus__c == 'R' || mainContr.claimsRec.SP_WarrantyTrainingStatus__c == Null || mainContr.claimsRec.SP_WarrantyTrainingStatus__c =='' ) && (mainContr.psnRec.Failure_Date__c > warrantyCertDate || warrantyCertDate==Null)){
                                        system.debug('Not Certified');
                                        mainContr.claimsRec.Warranty_Authorization_Flag__c = 'Not Certified';
                                    }else{
                                        system.debug('Certified');
                                        mainContr.claimsRec.Warranty_Authorization_Flag__c = 'Certified';
                                    }
    
                                    if(outputRes.DataArea.ProductCertification =='Y'){
                                        /*if(accredList !=null && accredList.size()>0){
                                                for(CSS_Accreditation__c accredObj: accredList){
                                                    if(!(mainContr.psnRec.Failure_Date__c >= accredObj.StartDate__c && mainContr.psnRec.Failure_Date__c <= accredObj.EndDate__c)){
                                                        isActive=false;
                                                        break;
                                                    }
                                                }
                                            }
                                            system.debug('****isActive**'+isActive);
                                            system.debug('****mainContr.psnRec.Failure_Date__c**'+mainContr.psnRec.Failure_Date__c);
                                            system.debug('****outputRes.DataArea.WarrantyTrainingCertification**'+outputRes.DataArea.WarrantyTrainingCertification);*/
                                        //Use Case 1
                                        if(isActive == true && (mainContr.psnRec.Failure_Date__c <= warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                                            mainContr.claimsRec.Pending_Authorization__c = 'Not Applicable';
                                        }
                                        //Use Case 2
                                        else if(isActive == false && (mainContr.psnRec.Failure_Date__c <= warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                                            mainContr.claimsRec.Pending_Authorization__c = 'Authorization Required';
                                        }
                                        // Use Case 3
                                        else if(isActive == true && (mainContr.psnRec.Failure_Date__c > warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                                            mainContr.claimsRec.Pending_Authorization__c = 'Authorization Required';
                                        }
                                        //Use Case 4
                                        else if(isActive == false && (mainContr.psnRec.Failure_Date__c > warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                                            mainContr.claimsRec.Pending_Authorization__c = 'Authorization Required';
                                        }
                                        //use case 7
                                        else if(isActive == true && outputRes.DataArea.WarrantyTrainingCertification == 'N'){
                                            mainContr.claimsRec.Pending_Authorization__c = 'Not Applicable';
                                        }
                                        //use case 8
                                        else if(isActive == false && outputRes.DataArea.WarrantyTrainingCertification == 'N'){
                                            mainContr.claimsRec.Pending_Authorization__c = 'Authorization Required';
                                        }
                                    }
                                    else if(outputRes.DataArea.ProductCertification =='N'){
                                        //Use Case 5
                                        if(mainContr.psnRec.Failure_Date__c > warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y'){
                                            mainContr.claimsRec.Pending_Authorization__c = 'Authorization Required';
                                        }
                                        //Use Case 6
                                        else if(mainContr.psnRec.Failure_Date__c <= warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y'){
                                            mainContr.claimsRec.Pending_Authorization__c = 'Not Applicable';
                                        }
                                        //Use Case 9
                                        else if(outputRes.DataArea.WarrantyTrainingCertification == 'N'){
                                            mainContr.claimsRec.Pending_Authorization__c = 'Not Applicable';
                                        }
    
                                    }
                                    system.debug('****mainContr.claimsRec.Pending_Authorization__c**'+mainContr.claimsRec.Pending_Authorization__c);
                           // }
                        //}
                            }
                            else{
                                mainContr.claimsRec.SPDataWebserviceResult__c='Error';
                            }
                        if(orgtype.containsIgnoreCase('DLR') || orgtype.containsIgnoreCase('DISTR')){
                            if( (mainContr.psnRec.Failure_Date__c!=null) && (mainContr.psnRec.Before_In_Service__c==false) && ( mainContr.psnRec.Failure_Date__c < mainContr.psnRec.Warranty_Start_Date__c )){
                                dispFDWSDErrorMsg = true;
                            }
                            else{
                                dispFDWSDErrorMsg = false;
                            }

                            if( (mainContr.psnRec.Failure_Date__c!=null) && (mainContr.psnRec.Before_In_Service__c==false) && ( mainContr.psnRec.Failure_Date__c < mainContr.claimsRec.ShipDate__c )){
                                dispFDShipDateErrorMsg = true;
                            }
                            else{
                                dispFDShipDateErrorMsg = false;
                            }
                        }

                    }catch(Exception e){
                        system.debug('EXCEPTION of CSS_GetServiceProviderResponse convertion CG_CL_ClaimsUEOneBMS  >>>:'+e.getMessage() + ' Line No>>>:' + e.getLineNumber() + ' Cause>>:' +e.getCause());
                    }
                    System.debug('after retrive psnRec.Region__c>>>>>:'+mainContr.region+'campaignsList>>:'+campaignsList);
                }

                /*system.debug('mainContr.psnRec.Failure_Date__c' + mainContr.psnRec.Failure_Date__c);
    if(mainContr.psnRec!=null)
    {
    system.debug('mainContr.psnRec.Failure_Date__c' + mainContr.psnRec.Failure_Date__c);
    if(mainContr.psnRec.Failure_Date__c!=null && mainContr.psnRec.Failure_Date__c>System.TODAY())
    {
    checkFailureDateerror = true;
    }
    else
    checkFailureDateerror = false;
    }
   system.debug('showWarrantyDateError**' + checkFailureDateerror); */

            }
            system.debug('StopRequest>>> mainContr.psnRec.PSN__c '+ mainContr.psnRec.PSN__c);

        }catch(exception e){
            system.debug('EXCEPTION of startRequest CG_CL_ClaimsUEOneBMS  >>>:'+e.getMessage() + ' Line No>>>:' + e.getLineNumber() + ' Cause>>:' +e.getCause());
        }
     
        if(mainContr.claimsRec.CG_Get_Engine_data_flag__c!=null && !mainContr.claimsRec.CG_Get_Engine_data_flag__c){
        if(mainContr.filterApplication== null || mainContr.filterApplication== ''){
            CSS_PSN__c PSNobj = new CSS_PSN__c();
            try{ 
                PSNobj = [select id, PSN__c,ApplicationCode__c, Application__c from CSS_PSN__c where PSN__c =: mainContr.psnRec.PSN__c order by CreatedDate Desc Limit 1];
            }
            catch(Exception e){
            }
            if(PSNobj != null){
                mainContr.filterApplication = PSNobj.Application__c;
                system.debug('PSNobj'+PSNobj);
                system.debug('PSNobj.Application__c'+PSNobj.Application__c);
            } else{
                mainContr.filterApplication = '';
                mainContr.psnRec.ProductAppcodeErrorflag__c = false;
                mainContr.prodcodeErrormessage = false;
            }

        }
        if(mainContr.filterApplication!= null || mainContr.filterApplication!= '' || mainContr.filterApplication != 'Select One'){
            system.debug('insidethe else for the appcode');
            updateproductappcode();
            system.debug('updateproductappcode on startRequest');
            if(mainContr.psnRec.ProductAppcodeErrorflag__c == true){
                system.debug('mainContr.psnRec.ProductAppcodeErrorflag__c'+mainContr.psnRec.ProductAppcodeErrorflag__c);
                mainContr.filterApplication = '';
                mainContr.psnRec.ProductAppcodeErrorflag__c = false;
                mainContr.prodcodeErrormessage = false;

            }
        }     
        }
    }

    public void spdataAssign(CSS_GetServiceProviderResponse outputRes) {
        LIst<CSS_Accreditation__c> accredList = new List<CSS_Accreditation__c>();

        mainContr.claimsRec.SP_CHANNEL_OF_DISTRIBUTION__c = outputRes.DataArea.ChannelOfDistribution;
        mainContr.claimsRec.CSS_Channel_Of_Distribution__c = outputRes.DataArea.ChannelOfDistribution;
        mainContr.claimsRec.SP_CLAIM_ALLOWED_DAYS__c = outputRes.DataArea.ClaimAllowedDays;
        mainContr.claimsRec.SP_CMI_SP_EXPIRATION__c = outputRes.DataArea.CMISPExpirationDate;
        mainContr.claimsRec.SP_LTA_FLAG__c = outputRes.DataArea.LTAFlag;
        mainContr.claimsRec.SP_OUTFILE_ALL_CLAIMS__c = outputRes.DataArea.OutfileAllClaims;
        mainContr.claimsRec.SP_PACCAR__c = outputRes.DataArea.PACCAR;    
        mainContr.claimsRec.SP_REGION__c = outputRes.DataArea.Region; 
        mainContr.claimsRec.SP_ACCOUNT_STATUS__c = outputRes.DataArea.AccountStatus; 
        mainContr.claimsRec.SP_TERRITORY_CODE__c = outputRes.DataArea.TerritoryCode; 
        mainContr.claimsRec.SP_Group_Name__c = outputRes.DataArea.GroupName; 
        mainContr.claimsRec.SP_TERRITORY__c  = outputRes.DataArea.Territory; 
        mainContr.claimsRec.SP_REGIONCODE__c = outputRes.DataArea.RegionCode; 
        mainContr.claimsRec.CSS_Channel_Code__c = outputRes.DataArea.ChannelCode;
        mainContr.claimsRec.Territory_Class__c = outputRes.DataArea.TerritoryCode; 
        mainContr.claimsRec.Territory_Class_Name__c = outputRes.DataArea.Territory; 
        mainContr.claimsRec.SP_PromotionId__c = outputRes.DataArea.PromotionId;
        mainContr.claimsRec.CSS_Travel_Rate__c = outputRes.DataArea.TravelRate;//Added By RAJESH as per "I Survived" sprint story #152967,-By RAJESH 27th July 2018
        mainContr.claimsRec.SP_INSHOP_LABOR_RATE__c = outputRes.DataArea.InShopLaborRate; //Added by Rajesh Narra
        mainContr.claimsRec.SP_FIELD_SERVICE_LABOR_RATE__c = outputRes.DataArea.FieldServiceLaborRate;// Added by Rajesh Narra 
        system.debug('mainContr>>> '+ mainContr);
        if(mainContr.userObj.User_Location__c != null)
           accredList = [SELECT id, EndDate__c,Service_Model_Name__c,StartDate__c,Account__c,Account__r.Location__c FROM CSS_Accreditation__c where Account__r.Location__c =: mainContr.userObj.User_Location__c];

        Boolean isActive = true;
        Boolean dupSMNisActive;
        Date warrantyCertDate;
        Map<String,List<CSS_Accreditation__c>> accredMap = new Map<String,List<CSS_Accreditation__c>>();
        Set<String> smnSet = new Set<String>();
        List<CSS_Accreditation__c> accList = new List<CSS_Accreditation__c>();
        //system.debug('****mainContr.claimsRec.SP_WarrantyCertificationEndDate__c**'+mainContr.claimsRec.SP_WarrantyCertificationEndDate__c);
        warrantyCertDate = Date.valueOf(mainContr.claimsRec.SP_WarrantyCertificationEndDate__c) +180;
        //system.debug('****warrantyCertDate**'+warrantyCertDate);
        //system.debug('****accredList**'+accredList.size()+'****'+accredList);
        for(CSS_Accreditation__c accredObj:accredList){
            smnSet.add(accredObj.Service_Model_Name__c);
            if(!accredMap.containsKey(accredObj.Service_Model_Name__c)){
                accredMap.put(accredObj.Service_Model_Name__c,new List<CSS_Accreditation__c>());
            }
            accredMap.get(accredObj.Service_Model_Name__c).add(accredObj);
        }
        //system.debug('****accredMap**'+accredMap.size());
        //system.debug('****mainContr.psnRec.Failure_Date__c**'+mainContr.psnRec.Failure_Date__c);
        for(String s:accredMap.keySet()){
            dupSMNisActive = false;
            accList=accredMap.get(s);
            if(isActive==false){
                break;
            }
            system.debug('****accList.size**'+accList.size());

            for(CSS_Accreditation__c accredObj: accList){
                if((mainContr.psnRec.Failure_Date__c >= accredObj.StartDate__c && mainContr.psnRec.Failure_Date__c <= accredObj.EndDate__c)){
                    //system.debug('***insidedupSMNisActiveTrue*'+accredObj.StartDate__c+'****end**'+accredObj.EndDate__c);
                    dupSMNisActive=true;
                    break;
                }
                else{
                    dupSMNisActive=false;
                    //system.debug('***insidedupSMNisActivefalse*'+accredObj.StartDate__c+'****end**'+accredObj.EndDate__c);
                    if(dupSMNisActive == false && accList.size()==1){
                        isActive=false;
                    }
                }
            }

        }

        //163193
        system.debug('outputRes.DataArea.WarrantyTrainingCertification'+outputRes.DataArea.WarrantyTrainingCertification);
        if(outputRes.DataArea.WarrantyTrainingCertification == 'N'){
            system.debug('Not Applicable');
            mainContr.claimsRec.Warranty_Authorization_Flag__c = 'Not Applicable';
        }
        else if(outputRes.DataArea.WarrantyTrainingCertification == 'Y' && (mainContr.claimsRec.SP_WarrantyTrainingStatus__c != 'R' && mainContr.claimsRec.SP_WarrantyTrainingStatus__c != Null && mainContr.claimsRec.SP_WarrantyTrainingStatus__c != '')){
            system.debug('Certified');
            mainContr.claimsRec.Warranty_Authorization_Flag__c = 'Certified';
        }else if(outputRes.DataArea.WarrantyTrainingCertification == 'Y' && (mainContr.claimsRec.SP_WarrantyTrainingStatus__c == 'R' || mainContr.claimsRec.SP_WarrantyTrainingStatus__c == Null || mainContr.claimsRec.SP_WarrantyTrainingStatus__c == '') && (mainContr.psnRec.Failure_Date__c > warrantyCertDate || warrantyCertDate==Null)){
            system.debug('Not Certified');
            mainContr.claimsRec.Warranty_Authorization_Flag__c = 'Not Certified';
        }else{
            system.debug('Certified');
            mainContr.claimsRec.Warranty_Authorization_Flag__c = 'Certified';
        }

        //system.debug('****outputRes.DataArea.ProductCertification**'+outputRes.DataArea.ProductCertification+'***isActive***'+isActive+'***wrtnytraningcert**'+outputRes.DataArea.WarrantyTrainingCertification);
        if(outputRes.DataArea.ProductCertification =='Y'){
            /*if(accredList !=null && accredList.size()>0){
    for(CSS_Accreditation__c accredObj: accredList){
        if(!(mainContr.psnRec.Failure_Date__c >= accredObj.StartDate__c && mainContr.psnRec.Failure_Date__c <= accredObj.EndDate__c)){
            isActive=false;
            break;
        }
    }
}*/
            //Use Case 1
            if(isActive == true && (mainContr.psnRec.Failure_Date__c <= warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                mainContr.claimsRec.Pending_Authorization__c = 'Not Applicable';
            }
            //Use Case 2
            else if(isActive == false && (mainContr.psnRec.Failure_Date__c <= warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                mainContr.claimsRec.Pending_Authorization__c = 'Authorization Required';
            }
            // Use Case 3
            else if(isActive == true && (mainContr.psnRec.Failure_Date__c > warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                mainContr.claimsRec.Pending_Authorization__c = 'Authorization Required';
            }
            //Use Case 4
            else if(isActive == false && (mainContr.psnRec.Failure_Date__c > warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y')){
                mainContr.claimsRec.Pending_Authorization__c = 'Authorization Required';
            }
            //use case 7
            else if(isActive == true && (mainContr.claimsRec.SP_WarrantyTrainingStatus__c == 'R' || mainContr.claimsRec.SP_WarrantyTrainingStatus__c == Null || mainContr.claimsRec.SP_WarrantyTrainingStatus__c =='')){
                mainContr.claimsRec.Pending_Authorization__c = 'Not Applicable';
            }
            //use case 8
            else if(isActive == false && (mainContr.claimsRec.SP_WarrantyTrainingStatus__c == 'R' || mainContr.claimsRec.SP_WarrantyTrainingStatus__c == Null || mainContr.claimsRec.SP_WarrantyTrainingStatus__c =='')){
                mainContr.claimsRec.Pending_Authorization__c = 'Authorization Required';
            }
        } else if(outputRes.DataArea.ProductCertification =='N'){
            //Use Case 5
            if(mainContr.psnRec.Failure_Date__c > warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y'){
                mainContr.claimsRec.Pending_Authorization__c = 'Authorization Required';
            }
            //Use Case 6
            else if(mainContr.psnRec.Failure_Date__c <= warrantyCertDate  && outputRes.DataArea.WarrantyTrainingCertification == 'Y'){
                mainContr.claimsRec.Pending_Authorization__c = 'Not Applicable';
            }
            //Use Case 9
            else if(outputRes.DataArea.WarrantyTrainingCertification == 'N'){
                mainContr.claimsRec.Pending_Authorization__c = 'Not Applicable';
            }

        }
        system.debug('****mainContr.claimsRec.Pending_Authorization__c**'+mainContr.claimsRec.Pending_Authorization__c);
    }

    //Added as part of defect 152593
    public void getCampaignDetails(){
        String sServiceModel;
        LIst<CSS_Accreditation__c> accredList = new List<CSS_Accreditation__c>();

        String AccountId;
        //String WRCertificationFlag;
        Boolean WRCertificationFlag;
        Boolean ProductCrtification;
        String warrTrainingStatus;
        Date CertEndDate;

        if(mainContr.claimsRec.Id == null){
            system.debug('LocationManualClaims'+mainContr.LocationManualClaims);
            String selectedLocCode = mainContr.LocationManualClaims.trim().right(5);
            system.debug('selectedLocCode-->'+selectedLocCode);
            Account Acc = [select id,WR_Certfication_Flag__c,Warranty_Training_Certification__c,Warranty_Training_Status__c,CERTIFICATION_END_DATE__c,Product_Certification__c from Account where IAM_Service_Provider_Code__c =: selectedLocCode or IAM_Service_Provider_Code__c =: selectedLocCode limit 1];
            system.debug('Anirudh Acc>>>>>>'+Acc);
            AccountId = Acc.id;
            //WRCertificationFlag = Acc.WR_Certfication_Flag__c;
            WRCertificationFlag = Acc.Warranty_Training_Certification__c;
            ProductCrtification = Acc.Product_Certification__c;
            warrTrainingStatus = Acc.Warranty_Training_Status__c;
            CertEndDate = Acc.CERTIFICATION_END_DATE__c;
        }else{
            AccountId = mainContr.claimsRec.Account__c;
            //WRCertificationFlag = mainContr.claimsRec.Account__r.WR_Certfication_Flag__c;
            WRCertificationFlag = mainContr.claimsRec.Account__r.Warranty_Training_Certification__c;
            ProductCrtification = mainContr.claimsRec.Account__r.Product_Certification__c;
            warrTrainingStatus = mainContr.claimsRec.Account__r.Warranty_Training_Status__c;
            CertEndDate = mainContr.claimsRec.Account__r.CERTIFICATION_END_DATE__c;
        }


        map<String,String> accCerts = CG_BL_Intake.getCertificationStatus(mainContr.psnRec.Service_Model__c,mainContr.psnRec.Failure_Date__c,AccountId,WRCertificationFlag,ProductCrtification,warrTrainingStatus,CertEndDate);
        if(accCerts.containsKey('certStatus')){                       
            mainContr.claimsRec.Product_Certification__c=accCerts.get('certStatus');
        }

        if(mainContr.psnRec!=null)
        {
            if(orgtype.containsIgnoreCase('DLR') || orgtype.containsIgnoreCase('DISTR')){
                if( (mainContr.psnRec.Failure_Date__c!=null) && (mainContr.psnRec.Before_In_Service__c==false) && ( mainContr.psnRec.Failure_Date__c < mainContr.psnRec.Warranty_Start_Date__c )){
                    dispFDWSDErrorMsg = true;
                }
                else{
                    dispFDWSDErrorMsg = false;
                }

                if( (mainContr.psnRec.Failure_Date__c!=null) && (mainContr.psnRec.Before_In_Service__c==false) && ( mainContr.psnRec.Failure_Date__c < mainContr.claimsRec.ShipDate__c )){
                    dispFDShipDateErrorMsg = true;
                }
                else{
                    dispFDShipDateErrorMsg = false;
                }
            }

            system.debug('mainContr.psnRec.Failure_Date__c' + mainContr.psnRec.Failure_Date__c);
            if(mainContr.psnRec.Failure_Date__c!=null && mainContr.psnRec.Failure_Date__c>System.TODAY())
            {       

                checkFailureDateerror = true;
                if(mainContr.tempFailureDate!=null)
                    mainContr.psnRec.Failure_Date__c = mainContr.tempFailureDate;
                else
                   mainContr.psnRec.Failure_Date__c = system.today();
            }
            else{
                checkFailureDateerror = false;
                system.debug('**No Error***Shows today date.****'+System.TODAY());
                mainContr.tempFailureDate = mainContr.psnRec.Failure_Date__c;
                //mainContr.psnRec.Failure_Date__c= system.today();
                //mainContr.psnRec.Before_In_Service__c=null;
                system.debug('mainContr.tempFailureDate'+mainContr.tempFailureDate);
            }

        }

        //Calling GetCampaigns & QSOL URLs
        if(mainContr.psnRec.Failure_Date__c !=null){
            mainContr.region = '';
            CSS_accountLanguage__c accountlang = css_utility.getLanguage(mainContr.userObj.LanguageLocaleKey);
            system.debug('mainContr.userObj**'+mainContr.userObj);
            system.debug('accountlang**'+accountlang);
            List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(mainContr.psnRec.PSN__c, sServiceModel, mainContr.psnRec.Failure_Date__c, accountlang.CSS_QsolLanguage__c, mainContr.psnRec.Id);
            /*if(campaignsList == null){
                mainContr.claimsRec.FieldActionWebServiceResult__c = 'Error';}
                else{
                mainContr.claimsRec.FieldActionWebServiceResult__c = 'Success';}*/
            if(campaignsList !=null && campaignsList.size()>0)
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
            mainContr.region = mainContr.claimsRec.Account__r.Region__c;
            try{
                system.debug('campaignsList >>> ' + campaignsList);
                //if(campaignsList !=null && campaignsList.size()>=5){
                   // if(campaignsList.get(5).get(0).Type__c=='SPData'){
                        //if(mainContr.userObj.User_Location__c != null)
                        //  accredList = [SELECT id, EndDate__c,Service_Model_Name__c,StartDate__c,Account__c,Account__r.Location__c FROM CSS_Accreditation__c where Account__r.Location__c =: mainContr.userObj.User_Location__c];


                        //CSS_GetServiceProviderResponse outputRes = (CSS_GetServiceProviderResponse)JSON.deserializeStrict(campaignsList.get(5).get(0).Name, CSS_GetServiceProviderResponse.class);
                       // mainContr.spDataWrapper = outputRes;
                       // system.debug('outputRes.DataArea.ChannelOfDistribution>>>>>>'+outputRes.DataArea.ChannelOfDistribution);
                       
                        String selectedLocation;
                        selectedLocation = mainContr.claimsRec.Location_Code__c;
                        if(selectedLocation==null || selectedLocation==''){
                            selectedLocation = ([select Id,User_Location__c,FederationIdentifier,LanguageLocaleKey from User where id=:UserInfo.getUserId() LIMIT 1]).User_Location__c;
                        }
                        String spCode = selectedLocation.trim().right(5); //take last 5 digits here
                        system.debug('first spCode>:'+spCode);
                        spCode = spCode.trim();
                        
                        String failureDateStr = DateTime.newInstance(mainContr.psnRec.Failure_Date__c.year(),mainContr.psnRec.Failure_Date__c.month(),mainContr.psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
                        System.debug('failureDateStr>>>:'+failureDateStr+' spCode>>:'+spCode);
                        
                        CSS_GetServiceProviderResponse outputRes = CSS_FN_SIEBEL.getServiceProviderDataWrapper(spCode.trim(), '', failureDateStr,mainContr.ClaimsRec.Name);
                        if(outputRes!=null){
                            mainContr.claimsRec.SPDataWebserviceResult__c='Success';
                            spdataAssign(outputRes);
                        }
                        else
                            mainContr.claimsRec.SPDataWebserviceResult__c='Error';
                        //story - 153618

                   // }
               // }
            }catch(Exception e){
                system.debug('EXCEPTION of CSS_GetServiceProviderResponse convertion CG_CL_ClaimsUEOneBMS  >>>:'+e.getMessage() + ' Line No>>>:' + e.getLineNumber() + ' Cause>>:' +e.getCause());
            }
            System.debug('after retrive psnRec.Region__c>>>>>:'+mainContr.region+'campaignsList>>:'+campaignsList);
        }

    }

    /* Select Option list */
    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.CSS_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers));
        //options.add(new SelectOption('Hours',system.Label.css_hours)); 
        return options;
    }  

    //Moulika Added for Story - 148884
    public Date warrantyDate{get;set;}
    public Boolean higherdateErrFlag{get;set;}
    public Boolean builddateErrFlag{get;set;}
    public void CompareDates(){
        try{
        system.debug('karthikKKK');
        higherdateErrFlag = false;
        builddateErrFlag=false;
         
        if(mainContr.psnRec.Warranty_Start_Date__c != null){
           
            if(mainContr.psnRec.Warranty_Start_Date__c > date.today()){
                
                higherdateErrFlag = true;
                //added the below line for the defect 152838 by venkat
                mainContr.psnRec.Warranty_Start_Date__c = null;
            }
        }else if(warrStDtHidden!= null &&  warrStDtHidden!='')
        {
          
            if(date.parse(warrStDtHidden)>date.today()){
                higherdateErrFlag = true;   
            }
        }
        if(PSN == '10000000' || PSN == '27000000' || EtoConversion != NULL)
        {
            
            builddateErrFlag=false;
        }
        else if(mainContr.psnRec.Warranty_Start_Date__c != null){
            
            if(mainContr.psnRec.Warranty_Start_Date__c < billdateVal){
                builddateErrFlag = true;
            }
        }else if(warrStDtHidden!= null && warrStDtHidden!=''  && billdateVal!=null)
        {
          
            if(date.parse(warrStDtHidden)< billdateVal){
                builddateErrFlag = true;            
            }            
        }

        }
        catch(exception e){
            system.debug('EXCEPTION of CG_CL_IntakeUENoERP - comapredates  Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
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
            lstApplications.add(new SelectOption('',' Select One '));
            //lstApplications.add(new SelectOption('','----Select One----'));
            system.debug('resJSON>>>'+resJSON);
            system.debug('resJSON.DataArea>>>'+resJSON.DataArea);
            system.debug('resJSON.DataArea.Details>>>'+resJSON.DataArea.Details);
            if(resJSON  != null && resJSON.DataArea != null && resJSON.DataArea.Details != null ){
                for(CSS_WPR_SBL_ApplicationResJSON.Details det : resJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y'){
                        lstApplications.add(new SelectOption(det.Description,det.ApplicationCode+' - '+det.Description));
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
        system.debug('sEngineFamilyCode'+sEngineFamilyCode);
        system.debug('mainContr.filterApplication'+mainContr.filterApplication);
        system.debug('mainContr.psnRec.Qsol_Engine_Family_Code__c'+mainContr.psnRec.Qsol_Engine_Family_Code__c);

        return CG_BL_Intake.getMake(sEngineFamilyCode, mainContr.filterApplication, mainContr.psnRec.Qsol_Engine_Family_Code__c);
    }

    public List<SelectOption> getModel() {
        return CG_BL_Intake.getModel(mainContr.filterMake, sEngineFamilyCode, mainContr.filterApplication, mainContr.psnRec.Qsol_Engine_Family_Code__c);
    }
    @testvisible
    private Date parseQSOLDate(String myDate) {
        String[] myDateOnly = myDate.split(' ');

        String sMonth = myDateOnly[1];
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

        Integer myIntDate = integer.valueOf(myDateOnly[0]);
        Integer myIntMonth = integer.valueOf(sMM);
        Integer myIntYear = integer.valueOf(myDateOnly[2]);
        Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        return d;

    }

    public List<SelectOption> getUnitType() {
        System.debug('mainContr.claimsRec.Location_Code__c>>>:'+mainContr.claimsRec.Location_Code__c);
        return CG_BL_Intake.getUnitType(mainContr.claimsRec.Id, mainContr.claimsRec.Location_Code__c);
    }

    /*
    public List<SelectOption> getSubType() {
    //return CG_BL_Intake.getSubType(mainContr.claimsRec.Id, mainContr.claimsRec.Location__c);

    }*/
    public String getFormatDate(){

        try{
            Date d = mainContr.psnRec.Warranty_Start_Date__c; 

            mainContr.FormattedDate = css_utility.FormatDate(d);
        }catch(exception e){ 
            system.debug('in catch DateModel exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return mainContr.FormattedDate;
    }

   //SN -Story- 114974 - get function to return formatted Failure date
    public string getFormattedFailureDate(){
        String failureDate;
        try{
            Date d = mainContr.psnRec.Failure_Date__c; 

            failureDate = css_utility.FormatDate(d);
        }catch(exception e){ 
            system.debug('in catch DateModel exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return failureDate;
    }


    public List<SelectOption> getJustification() { 
        //Modified as per story# 64030
        //Schema.DescribeFieldResult fieldResult = Css_job_order__c.application__c.getDescribe();
        Schema.DescribeFieldResult fieldResult = Css_psn__c.Justification__c.getDescribe();
        List<Schema.PicklistEntry> lstJustValues = fieldResult.getPicklistValues();
        System.debug('Picklist::'+ lstJustValues);

        //css_job_order__c c = new css_job_order__c();
        //lstAppValues = getPickLstValues(c,'application__c');
        List<SelectOption> lstJustValues1=new List<SelectOption>();
        //lstJustValues1.add(new SelectOption('--None--','--None--'));
        for( Schema.PicklistEntry entry : lstJustValues){
            lstJustValues1.add(new SelectOption(entry.getValue(),entry.getLabel()));
        }
        system.debug('LstAppValues1---->'+lstJustValues1);
        //System.debug(entry.getLabel() +'----->'+ entry.getValue());
        return lstJustValues1;

    }

    public List<SelectOption> getlicensePlateList() { 
        //Modified as per story# 64030
        //Schema.DescribeFieldResult fieldResult = Css_job_order__c.application__c.getDescribe();
        Schema.DescribeFieldResult fieldResult = Css_psn__c.License_Plate_State__c.getDescribe();
        List<Schema.PicklistEntry> lstLPValues = fieldResult.getPicklistValues();
        System.debug('Picklist::'+ lstLPValues);

        //css_job_order__c c = new css_job_order__c();
        //lstAppValues = getPickLstValues(c,'application__c');
        List<SelectOption> lstLPValues1=new List<SelectOption>();
        lstLPValues1.add(new SelectOption('',' Select One '));
        //lstJustValues1.add(new SelectOption('--None--','--None--'));
        for( Schema.PicklistEntry entry : lstLPValues){
            lstLPValues1.add(new SelectOption(entry.getValue(),entry.getLabel()));
        }
        system.debug('LstAppValues1---->'+lstLPValues1);
        //System.debug(entry.getLabel() +'----->'+ entry.getValue());
        return lstLPValues1;

    }

    /*
           public  Boolean prodcodeErrormessage{get;set;} 

        public void updateproductappcode(){
            system.debug('inside updateproductappcode method');
            CSS_JobEventTemporary__c JETproductcode = new CSS_JobEventTemporary__c();
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

            try{
                JETproductcode = [select id, Attribute1__c, Attribute2__c,Attribute3__c, Attribute5__c, Active__c,Key__c from CSS_JobEventTemporary__c  where Key__c = 'MarketingApplicationCodes' and  Attribute3__c =: mainContr.filterApplication and Attribute2__c=: appCode Limit 1];
                prodcodeErrormessage = false;
            }
            catch(Exception ex ){
                prodcodeErrormessage = true;

            }
            system.debug('prodcodeErrormessage'+prodcodeErrormessage);
        }*/

    public void updateproductappcode(){   
        if(mainContr.claimsRec.CG_Get_Engine_data_flag__c!=null && !mainContr.claimsRec.CG_Get_Engine_data_flag__c){
        system.debug('updateproductappcode');
        system.debug('productAppdesc '+ productAppdesc);
        system.debug('productAppcode' +productAppcode);
        system.debug('mainContr.claimsRec.ProductApplicationDesp__c '+ mainContr.claimsRec.ProductApplicationDesp__c);
        system.debug('mainContr.claimsRec.ProductApplicationCode__c' +mainContr.claimsRec.ProductApplicationCode__c);
        system.debug('!mainContr.filterMake'+mainContr.filterMake);
        system.debug('mainContr.filterModel'+mainContr.filterModel);
        prodcodeErrormessage = false ;
        mainContr.psnRec.ProductAppcodeErrorflag__c=false;
        if(mainContr.filterApplication== ''||mainContr.filterApplication== null || mainContr.filterApplication== 'Select One'){
            system.debug('mainContr.filterApplication'+mainContr.filterApplication);
            prodcodeErrormessage = false;
            mainContr.psnRec.ProductAppcodeErrorflag__c=false;
        }
        else{
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
                //JETproductcode = [select id, Attribute1__c, Attribute2__c,Attribute3__c, Attribute5__c, Active__c,Key__c from CSS_JobEventTemporary__c  where Key__c = 'MarketingApplicationCodes' and   Attribute1__c =: productAppcode and Attribute3__c=: productAppdesc Limit 1];
                JETproductcode = [select id, Attribute1__c, Attribute2__c,Attribute3__c, Attribute5__c, Active__c,Key__c from CSS_JobEventTemporary__c  where Key__c = 'MarketingApplicationCodes' and   Attribute1__c =: mainContr.claimsRec.ProductApplicationCode__c and Attribute3__c=: mainContr.claimsRec.ProductApplicationDesp__c Limit 1];
                system.debug('JETproductcode'+ JETproductcode);
                system.debug('JETproductcode.Attribute2__c'+ JETproductcode.Attribute2__c);
                system.debug('mainContr.filterApplication'+ mainContr.filterApplication);
                system.debug('JETproductcode.Attribute5__c'+ JETproductcode.Attribute5__c);
                system.debug('appCode'+ appCode);

                if(JETproductcode.Attribute2__c != appCode || JETproductcode.Attribute5__c != mainContr.filterApplication){
                    try{
                        JETproductcode1 = [select id, Attribute1__c, Attribute2__c,Attribute3__c, Attribute5__c, Active__c,Key__c from CSS_JobEventTemporary__c  where Key__c = 'MarketingApplicationCodes' and   Attribute2__c =: appCode and Attribute5__c=: mainContr.filterApplication Limit 1];
                        system.debug('JETproductcode1'+ JETproductcode1);

                        mainContr.prodcodeErrormessage = true;

                        mainContr.psnRec.ProductAppcodeErrorflag__c=true;
                        system.debug('mainContr.prodcodeErrormessage'+mainContr.prodcodeErrormessage);
                        system.debug('mainContr.psnRec.ProductAppcodeErrorflag__c'+mainContr.psnRec.ProductAppcodeErrorflag__c);
                    }catch(Exception err) {
                        mainContr.prodcodeErrormessage = false;
                        system.debug(' inside EXC ');
                        mainContr.psnRec.ProductAppcodeErrorflag__c=false;
                        system.debug('mainContr.prodcodeErrormessage'+mainContr.prodcodeErrormessage);
                        system.debug('mainContr.psnRec.ProductAppcodeErrorflag__c'+mainContr.psnRec.ProductAppcodeErrorflag__c);
                    }

                }
                else{
                    mainContr.prodcodeErrormessage = false ;
                    system.debug(' inside else main EXC');
                    mainContr.psnRec.ProductAppcodeErrorflag__c=false;
                    system.debug('mainContr.prodcodeErrormessage'+mainContr.prodcodeErrormessage);
                    system.debug('mainContr.psnRec.ProductAppcodeErrorflag__c'+mainContr.psnRec.ProductAppcodeErrorflag__c);

                }

                mainContr.filterModel= mainContr.psnRec.Model__c;
                mainContr.filterMake= mainContr.psnRec.Make__c;
                system.debug(' mainContr.filterModel****'+ mainContr.filterModel);
                system.debug(' mainContr.filterMake****'+ mainContr.filterMake);

            }
            catch(Exception ex ){
                mainContr.prodcodeErrormessage = false ;
                system.debug(' inside main EXC');
                mainContr.psnRec.ProductAppcodeErrorflag__c=false;
                system.debug('mainContr.prodcodeErrormessage'+mainContr.prodcodeErrormessage);
                system.debug('mainContr.psnRec.ProductAppcodeErrorflag__c'+mainContr.psnRec.ProductAppcodeErrorflag__c);
            }
        }
    }}


}