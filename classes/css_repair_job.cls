/**********************************************************************
Name:css_repair_job
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR              DATE                   DETAIL                       
1.0 - Satish Manchirala   1/21/2016 9:02 AM      INITIAL DEVELOPMENT          
2.0 - Roopa Gadipudi      2/9/2016 5:06 PM       UDAC WIRE FRAME CHANGES      
3.0 - Varun Sinha                                Added some functionalities related to EDS, fault codes repairs and result summary(accordion).
3.0 - Anirudh             2/11/2016              Coding Standards
4.0 - Krishnamoorthi  28/07/2017     Defect 92817
5.0 - Rajesh Narra    10/24/2017      Added bmsEnabled to the CSS_JobOrderWrapper constructor
6.0-  Roopa Gadipudi   04/09/2018    modified startRequest() method as part of ROD Defect 130006 
***********************************************************************/


public class css_repair_job
{
    public Id vMore_JobId {
        get;
        set {
            vMore_JobId = value;
            
        }
    }
    //Modify by Manjari
    public Boolean isReadUser{get;set;} 
    public Boolean ESNLocked{get;set;}
    public css_repair_job controllerRef{set;get;}
    //End 
    
    public boolean faildtwsdtflag{get;set;}//Story 147384 Rupesh
    public boolean faildtshdtflag{get;set;}//Story 147384 Rupesh
    
    public String SubStatusPrevValue{get;set;}
    public String ShowSubStatuspopup{get;set;}
    public Boolean isUnitInboundStatusEnabled{set;get;}
    public String filterUnitType{get;set;}
    public String filterSubType{get;set;}
    public string EmailAddress {get;set;}
    public id selectedRepairJobID {get; set;}
    public string EmailAddress1 {get;set;}
    public boolean showOutageError1{get;set;} //ROD Defect 111715 & 111716 by venkat
    public Boolean recconFlag{get;set;} //ROD Defect 111715 & 111716 by venkat
    public List<CSS_CampTsbTrp__c> lstALL {get;set;}
    public List<CSS_Solution_Component__c> solCompCTTP {get;set;}
    public CG_cancelServiceJobWrapper cancelSJWrapperObj1{get;set;}
     public boolean prodcodeErrormessage{get;set;}
      public string productAppdesc{get;set;}
    public string productAppcode{get;set;}
    public boolean PSNFlag{get;set;}//story#183077
    public Boolean isClaimEnabled {get;set;}
    public Boolean isJoblocClaimEnabled {get;set;}
     public Boolean isCreateClaimButtonEnabled {get;set;}
     public Boolean isCreateClaimButtonDisabled {get;set;}
     public boolean isFactory{get;set;} 
    public List<CSS_UserLocation__c> checkclaims = new List<CSS_UserLocation__c>();
    public string WrapperRequestEng;
    public Boolean showResolutionRequired{get;set;}//ROD Defect 179167 Added by Rajesh Narra 
    public Boolean showRepairRequired {get;set;}//ROD Defect 179167 Added by Rajesh Narra
    public Static Boolean showRepairResolution {get;set;}//ROD Defect 179167 Added by Rajesh Narra
    public string licensePlate{set;get;}
    Public void mainSOQL(){
        //Added field Get_Engine_data_flag__c for story#183007
        workJob=[Select Id,Account__r.Warranty_Training_Certification__c,PSN_PACCAR_Flag__c, Account__r.Warranty_Training_Status__c, Account__r.CERTIFICATION_END_DATE__c,Region__c,Territory_Class__c,Get_Engine_data_flag__c,PACCAR_Auth_Required__c,ProductApplicationDesp__c,ProductApplicationCode__c,Name,Claim_ID__c,BMSStatus__c,Customer_Name__c,Account__r.isCampTrp__c,TSR_EscalateNumber__c,ProductAppcodeErrorflag__c,Date_in_Shop__c,Customer_Code__c,Contact_ID__c,Shop_Work_Order__c,Cstmr_Contacts_Phone__c,Address__c,City__c,CSS_State__c,ZipCode__c,Country__c,CSS_Charge_Account_Status__c,Sub_Type__c,Application__c, Application_Desc__c,DSID_WorkGroup__c, Unit_Number__c, Unit_Type__c, Date_in__c, INSITE_UpdateTimeStamp__c,
                 First_Name__c,BMS_Last_Name__c,Account__c,Account__r.type,Account__r.WR_Certfication_Flag__c,SP_ProductCertification__c,Failure_Date__c, Failure_Point__c, Failure_Point_Measure__c, Service_Model__c, VIN__c,VIN_Flag__c,PSN_Not_Available__c,Warranty_Start_Date__c,Make__c, Qsol_Engine_Family_Code__c,Repair_Location__c,
                 DSID__c, DSID_Creation_Timestamp__c, DSID_Status__c,Email_Address__c,Email_check_box__c, Repeat_Or_Recent_Calc__c, DSID_UpdateTimestamp__c,Status__c,Primary_Segment__c,Before_In_Service__c,Before_Image__c,After_Image__c,
                 Phone_Number__c,Previous_Status__c,warrantyIndicatorFlag__c,Account__r.Product_Certification__c,ShipDate__c, Category__c, Complaint_Type__c,Category2__c,Complaint_Type2__c,Category3__c,Complaint_Type3__c,Category4__c,Complaint_Type4__c,Category5__c,Complaint_Type5__c, Category_Desc__c, Category2_Desc__c, Category3_Desc__c, Category4_Desc__c, Category5_Desc__c, Complaint_Type_Desc__c, Complaint_Type2_Desc__c, Complaint_Type3_Desc__c, Complaint_Type4_Desc__c, Complaint_Type5_Desc__c,Preventive_Maintenance__c,Expedited_Service__c, Model__c,Creator_Location__c, Control_Number__c,
                 Assigned_to__r.Name,Additional_Tech1__r.Name,Additional_Tech2__r.Name,Additional_Tech3__r.Name,Additional_Tech4__r.Name,Additional_Tech5__r.Name,Additional_Tech6__r.Name,Additional_Tech7__r.Name,Additional_Tech8__r.Name,Additional_Tech9__r.Name,OwnerId,JobLocation__c, CSS_Job_Location_Code__c, ESN_Locked__c,Warranty_Authorization_Flag__c,Location_Certification__c,License_Plate__c,
                 ESN__c, Mileage__c,Automotive_App_Flag__c ,CSS_Hours__c,SPDataWebserviceResult__c,FieldActionWebServiceResult__c,Mileage_Measure__c, chevron_page__c, General_Symptoms__c, Assigned_To__c, LastModifiedDate,CreatedDate, Sub_Status__c,LastUpdateSubStatus__c,Actual_Technician_Time__c,Quote_ID__c,Account__r.ERP_System__c,CSS_Mission_Disabling__c,
                 (Select Id,Body,title,CreatedBy.firstname,CreatedBy.lastname,CreatedDate from Notes Order By CreatedDate DESC),
                 (Select name,Sequence__c,ECM_Number__c,ECM_Image_Name__c from css_ecm__r where ECM_Number__c=:0  order by Sequence__c desc)
                 from CSS_Job_Order__c where id= :Wid];
        
    }
    //story 86427
    public boolean BMSCustSearchPopup {get;set;}
    public CSS_customerOutboundJSON2Apex customerDetail{get;set;}
    public List<CSS_customerOutboundJSON2Apex.DataArea> paginatedCustDetails {get;set;}
    public List<CSS_customerOutboundJSON2Apex.DataArea> fullCustDetails {get;set;}
    public String selectedCustCode{get;set;}
    public string strCntry{get;set;}
    public string strCntryState{get;set;}
    public string datebyLocaleValue {get;set;}
    //story 86427
    public boolean DealerTypeFlag {get;set;}
    public css_repair_job() {
        isCreateClaimButtonEnabled=false;
        isCreateClaimButtonDisabled = false;
        isFactory=false;
        controllerRef = this;
        Wid=ApexPages.CurrentPage().getParameters().get('id');
        pgName=ApexPages.CurrentPage().getParameters().get('pgflag');
        rpid=ApexPages.CurrentPage().getParameters().get('rpHistory');
        String QId = ApexPages.CurrentPage().getParameters().get('DSID');
        strEDSCodes=ApexPages.CurrentPage().getParameters().get('EDSCodes');
        String NTO = ApexPages.CurrentPage().getParameters().get('nto');
        system.debug('NTO..'+NTO);
        system.debug('rpid..'+rpid);
        system.debug('pgName..'+pgName);
        System.debug('strEDSCodes :'+strEDSCodes);
        showRepairs = false;
        showResolutionWithRepair = FALSE;
        string userId = UserInfo.getUserId();
        //To Check If the User Location is BMS Enabled
        // bmsEnabled=css_utility.getBMSEnabled(userId);
        
        showResolutionRequired = false;//Added by Rajesh Narra
        showRepairRequired = false;//Added by Rajesh Narra
        
        system.debug('bmsEnabled - Intake'+bmsEnabled);  
        ShowSubStatuspopup = 'false';
        css_header_nav__c CS = css_header_nav__c.getInstance(UserInfo.getProfileId());
        datebyLocaleValue = css_utility.getFormattedDate();
        //Variables for Profiles restriction - Start
        
        // profileList = new list<Profile>([Select Id,Name from Profile where Id=:UserInfo.getProfileId()]);
        //Variables for Profiles restriction - End
        system.debug('going to call getLocations');
        getLocations();
        
        if (Wid == null) {
            
            mil_measure = 'Miles';
            fail_measure = 'Miles';
            css_redirect();
        }
        else  {
            try {
                
                mainSOQL();
                //Added as part os Zoopito story#164116
                /* if((workJOb.Claim_ID__c==null) && ( workJOb.Account__r.type== 'Dealer Account'))
                {
                  isCreateClaimButtonEnabled=true;  
                }
            else{
                isCreateClaimButtonEnabled=false;  
            }
             System.debug('isCreateClaimButtonEnabled...'+isCreateClaimButtonEnabled);*/
                 if(workJob.License_Plate__c != null && workJob.License_Plate__c !='')
                     {
                         licensePlate = workJob.License_Plate__c;
                     }
             //170265
                tndverification();
            //End
                isJoblocClaimEnabled = false;
                if(Userinfo.getUserId()!=null)
                {
                    checkclaims =[select Enable_Claim__c,Location_code__c,isClaims__c from CSS_UserLocation__c where UserId__c=:Userinfo.getUserId() and Enable_Claim__c = true and isActive__c = true and Location_Source__c = 'ARF' and AccountId__c =:workJob.Account__c];
                    if(checkclaims.size()>0){
                        isClaimEnabled = true;
                        for (CSS_UserLocation__c jobloc: checkclaims){
                            if(jobloc.Location_code__c ==  workJob.Creator_Location__c){                            
                                isJoblocClaimEnabled = true; 
                                break;
                            } 
                            
                        }
                    }
                    else{
                        isClaimEnabled = false;
                        
                    }
                    system.debug('isClaimEnabled'+isClaimEnabled);
                }
                system.debug('dhanvi**'+workJob);
                if(workJob.DSID__c!=null){
                    isUnitInboundStatusEnabled=false;
                }
                
                
               
                //End Story      
                //Added Code for Service Job Logs - Start
                if(workJob != null) {
                    /*Story183077*/
                    if(workJob.Get_Engine_data_flag__c!=NULL)
                    PSNFlag=workJob.Get_Engine_data_flag__c;
                    /*end*/
                    
                    DealerTypeFlag = CSS_utility.getAccounttype(workJOb.Account__r.Type);
                    //Added as part os Zoopito story#164116
                    //if((workJOb.Claim_ID__c==null) && ( workJOb.Account__r.type== 'Dealer Account'))
                    if((workJOb.Claim_ID__c==null) && ( DealerTypeFlag==true))
                    {
                      isCreateClaimButtonEnabled=true;  
                    }
                    //else if((workJOb.Claim_ID__c!=null) && ( workJOb.Account__r.type== 'Dealer Account')){
                    else if(workJOb.Claim_ID__c!=null) {
                        //if(workJOb.Account__r.type== 'Dealer Account')
                        if(DealerTypeFlag==true)
                            isCreateClaimButtonDisabled = true;  
                        else
                            isCreateClaimButtonDisabled = false;
                    }
             System.debug('isCreateClaimButtonEnabled...'+isCreateClaimButtonEnabled);
                    
                    if(workJob.ESN_Locked__c!=null){
                        ESNLocked = workJob.ESN_Locked__c;
                    }
                    try{
                        if(workJob != null && workJob.ESN__c != null && workJob.ESN__c != ''){
                            // added for ROD Defect 111715 & 111716 by Venkat
                            if(workJob.ESN__c.isNumeric())
                            {
                                recconFlag = css_utility.getReconEngine(decimal.valueof(workJob.ESN__c));
                            }
                            else
                                recconFlag = false;
                            showOutageError1 = false;
                            if(recconFlag == true){
                                showOutageError1= true;
                                workJob.ReconEngineFlag__c = 'Y';
                            }
                            else{
                                showOutageError1= false;
                                workJob.ReconEngineFlag__c = 'N';
                            }
                        }
                        
                    }
                    Catch(exception e){
                        System.debug('catching exception>>>>'+e);
                    }
                    if(workJob.Notes != null && !workJob.Notes.isEmpty()){
                        for(Note noteRec:workJob.Notes){
                            if(noteRec.title.equalsIgnoreCase('Bold')){
                                if(noteRec.Body != null){
                                    if(!noteRec.Body.contains(userId)){
                                        noteRec.Body += ','+userId;
                                    }
                                }else{
                                    noteRec.Body = userId;
                                }
                                notesList.add(noteRec);
                            }
                        }
                        
                    } 
                    //Get QSOL Docs for existing ESN
                    
                }
                
                //checking BMS Status 'UI0' or not
                /* System.debug('workJob.BMSStatus__c>>>>>>>>>>>>>:'+workJob.BMSStatus__c);
if(workJob !=null && workJob.BMSStatus__c !=null && workJob.BMSStatus__c.contains('UI0')){
System.debug('if inner.....'+workJob.BMSStatus__c);
isUnitInboundStatusEnabled=true;
}else{
System.debug('else inner.....');
isUnitInboundStatusEnabled=false;              
}*/
                
                if (workJob.Unit_Type__c==null || workJob.Unit_Type__c=='----None----' || workJob.Unit_Type__c==''){
                    filterUnitType = '----None----';
                }else{
                    filterUnitType = workJob.Unit_Type__c;
                }
                if (workJob.Sub_Type__c==null || workJob.Sub_Type__c=='----None----' || workJob.Sub_Type__c==''){
                    //filterSubType = '----None----';}else{
                    filterSubType = 'IS';
                }else{
                    filterSubType = workJob.Sub_Type__c;
                }
                
                
                if (workJob.Email_Address__c !=null && workJob.Email_Address__c !=''){
                    string[] EmailAdd;
                    EmailAdd = workJob.Email_Address__c.split('@');
                    EmailAddress = EmailAdd[0];
                    EmailAddress1 = EmailAdd[1];
                }
                else{
                    EmailAddress = '';
                    EmailAddress1 = '';
                }
                
                
                /*  Defect 63819 Code Begins - Displaying Diagnosis and Repair Time in Job Over View*/
                digTime=0.00;
                repTime=0.00;
                
                // List<CSS_SRT__c> lstDiagRepTime = new List<CSS_SRT__c>([Select id, type__c,diagnosis_time__c,isPerformed__c,SRT_Decimal_Time__c,srt_time__c, job_order__c, Component_Id__r.Selected_Component__c from css_srt__c where job_order__c =:Wid]);
                List<CSS_SRT__c> lstDiagRepTime = new List<CSS_SRT__c>([Select id, Extended_Hours__c,Additional_SRT_Calculated__c, type__c,Repair_Time__c,Assignment__c,diagnosis_time__c,isPerformed__c,SRT_Id__c,SRT_Decimal_Time__c,srt_time__c, job_order__c, Solution_Number__c , Solution_Number__r.Repair_Response__c , Component_Id__r.Selected_Component__c from css_srt__c where job_order__c =:Wid]);
                
                /* for loop for iterating srts to retrive Diagnosis & SRT Time */ 
                if(lstDiagRepTime.size()>0){
                    for(css_srt__c srtTimes : lstDiagRepTime){
                        System.debug('entered for loop:');
                        //if(srtTimes.type__c!=null && srtTimes.type__c.equalsIgnorecase('Diagnosis')&& srtTimes.diagnosis_time__c!=null){
                        System.debug('srtTimes.type__c:'+srtTimes.type__c);
                        System.debug('srtTimes.diagnosis_time__c:'+srtTimes.diagnosis_time__c);
                        System.debug('srtTimes.isPerformed__c:'+srtTimes.isPerformed__c);
                        System.debug('srtTimes.Solution_Number__c:'+srtTimes.Solution_Number__c);
                        if(srtTimes.type__c!=null && srtTimes.type__c.equalsIgnorecase('Diagnosis')&& srtTimes.diagnosis_time__c!=null && srtTimes.isPerformed__c==true && srtTimes.Solution_Number__c !=null){ //Kalpana Added isPerformed & Solution number condition
                            //digTime = digTime + srtTimes.diagnosis_time__c;
                            if(srtTimes.Extended_Hours__c != null)
                                digTime = digTime + srtTimes.Extended_Hours__c;
                            system.debug('digTime**'+digTime);
                            //DecdigTime = digTime;
                        }
                        if(srtTimes.type__c!=null && srtTimes.type__c.equalsIgnoreCase('Diagnosis') && srtTimes.isPerformed__c==true){
                            if(srtTimes.Solution_Number__c == null){
                                SYSTEM.DEBUG('Anirudh Entered if Additional srt');
                                
                                digTime= digTime+ srtTimes.Additional_SRT_Calculated__c; 
                            }
                        }
                        
                        system.debug('Anirudh Entered outside if Assignment check'+srtTimes.type__c + ' ' + srtTimes.Component_Id__r.Selected_Component__c + ' ' + srtTimes.isPerformed__c);
                        if(srtTimes.type__c!=null && srtTimes.type__c.equalsIgnoreCase('Repair') && srtTimes.Component_Id__r.Selected_Component__c && srtTimes.isPerformed__c==true && srtTimes.Solution_Number__r.Repair_Response__c != null){
                            if(srtTimes.Assignment__c =='Primary' || srtTimes.Assignment__c=='Progressive Damage' || srtTimes.Assignment__c == 'Alternative'){
                                //repTime= repTime+srtTimes.Repair_Time__c;
                                repTime= repTime+(srtTimes.Extended_Hours__c != null ? srtTimes.Extended_Hours__c : 0.0);
                                system.debug('Anirudh Entered inside if Assignment check'+ '  ' + srtTimes.Repair_Time__c + ' ' +srtTimes.type__c + ' ' + srtTimes.Component_Id__r.Selected_Component__c + ' ' + srtTimes.isPerformed__c);
                            }
                            SYSTEM.DEBUG('Anirudh Entered outside if Additional srt'+srtTimes.Solution_Number__c);
                        }
                        if(srtTimes.type__c!=null && srtTimes.type__c.equalsIgnoreCase('Repair')&& srtTimes.srt_time__c!=null && srtTimes.isPerformed__c==true){
                            if(srtTimes.Solution_Number__c == null){
                                SYSTEM.DEBUG('Anirudh Entered if Additional srt');
                                
                                repTime= repTime+ srtTimes.Additional_SRT_Calculated__c; 
                            }
                        }
                        System.Debug('shanthi srt time'+repTime + ' ' +srtTimes.SRT_Id__c + '  ' +srtTimes.srt_time__c);
                        
                        
                        
                    }// end of For loop
                }// end of if loop
                
                /*  Defect 63819 Code Ends - Displaying Diagnosis and Repair Time in Job Over View*/
                
                //Added Code for Service Job Logs - End
                system.debug('pgName'+pgName);
                if (workJob.Mileage_Measure__c==null || workJob.Mileage_Measure__c==''){
                    mil_measure = 'Miles';} else{
                        mil_measure = workJob.Mileage_Measure__c;}
                CampNotes();
                
                jobAttach = new List<Attachment>([Select Id,Name,Description,parentid, LastModifiedDate from attachment where parentid= :Wid and (NOT Description like 'CG_%.eif') and (NOT Name like 'CGJBTLATT03%')]);
                
                if (workJob.Mileage_Measure__c==null || workJob.Mileage_Measure__c==''){
                    mil_measure = 'Miles';} else{
                        mil_measure = workJob.Mileage_Measure__c;}
                
                if (workJob.Failure_Point_Measure__c==null || workJob.Failure_Point_Measure__c==''){
                    fail_measure = 'Miles';} else{
                        fail_measure = workJob.Failure_Point_Measure__c;}
                if ( workJob.Failure_Date__c == null){
                    workJob.Failure_Date__c =  date.today();} else{
                        workJob.Failure_Date__c = workJob.Failure_Date__c;}
                
                if (workJob.Make__c==null || workJob.Make__c==''){
                    filterMake = '----Select One ----';}else{
                        filterMake = workJob.Make__c;
                    }
                if (workJob.Sub_Status__c!=null || workJob.Sub_Status__c!=''){              
                    selectedSubStatusVal = workJob.Sub_Status__c;
                }  
                system.debug('filterApplication>>>'+workJob.Application_Desc__c);
                if (workJob.Application_Desc__c==null || workJob.Application_Desc__c==''){
                    filterApplication = '----None----';}else{
                        filterApplication = workJob.Application_Desc__c;
                    }
                
                if (workJob.Category_Desc__c==null || workJob.Category_Desc__c==''){
                    filterCategory = '----None----';}else{
                        filterCategory = workJob.Category_Desc__c;
                    }
                if (workJob.Category2_Desc__c==null || workJob.Category2_Desc__c==''){
                    filterCategory2 = '----None----';}else{
                        filterCategory2 = workJob.Category2_Desc__c;
                    }
                if (workJob.Category3_Desc__c==null || workJob.Category3_Desc__c==''){
                    filterCategory3 = '----None----';}else{
                        filterCategory3 = workJob.Category3_Desc__c;
                    }
                if (workJob.Category4_Desc__c==null || workJob.Category4_Desc__c==''){
                    filterCategory4 = '----None----';}else{
                        filterCategory4 = workJob.Category4_Desc__c;
                    }
                if (workJob.Category5_Desc__c==null || workJob.Category5_Desc__c==''){
                    filterCategory5 = '----None----';}else{
                        filterCategory5 = workJob.Category5_Desc__c;
                    }
                if (workJob.Complaint_Type_Desc__c==null || workJob.Complaint_Type_Desc__c==''){
                    filterComplaintType = '----None----';}else{
                        filterComplaintType = workJob.Complaint_Type_Desc__c;
                    }
                if (workJob.Complaint_Type2_Desc__c==null || workJob.Complaint_Type2_Desc__c==''){
                    filterComplaintType2 = '----None----';}else{
                        filterComplaintType2 = workJob.Complaint_Type2_Desc__c;
                    }
                if (workJob.Complaint_Type3_Desc__c==null || workJob.Complaint_Type3_Desc__c==''){
                    filterComplaintType3 = '----None----';}else{
                        filterComplaintType3 = workJob.Complaint_Type3_Desc__c;
                    }
                if (workJob.Complaint_Type4_Desc__c==null || workJob.Complaint_Type4_Desc__c==''){
                    filterComplaintType4 = '----None----';}else{
                        filterComplaintType4 = workJob.Complaint_Type4_Desc__c;
                    }
                if (workJob.Complaint_Type5_Desc__c==null || workJob.Complaint_Type5_Desc__c==''){
                    filterComplaintType5 = '----None----';}else{
                        filterComplaintType5 = workJob.Complaint_Type5_Desc__c;
                    }
                
                
                if (workJob.Model__c==null || workJob.Model__c==''){
                    filterModel = '----None----';}else{
                        filterModel = workJob.Model__c;
                    }
                
                /* Set the appropriate page for Repair */
                if (QId != null) {
                    showRepairBlocks(false,false,false, true,false);
                }
                else {
                    showRepairBlocks(true,false,false, false,false); 
                }
                
                if (strEDSCodes != null) {
                    showRepairBlocks(false,false,false, true,false);
                }
                if (rpid=='RJ'){
                    //repair_rj();
                    workJob.chevron_page__c = 'rj';
                }
                if (pgName=='JO'){
                    workJob.chevron_page__c = 'jo';
                } 
                if (pgName=='VH'){
                    workJob.chevron_page__c = 'vh';
                }  
                if (pgName=='VI'){
                    workJob.chevron_page__c = 'vi';
                }
                
                if(pgName == 'RJ'){
                    workJob.chevron_page__c = 'rj';
                } 
               if (pgName=='RM' || NTO=='DET'){
                    workJob.chevron_page__c = 'rm';
                }
                
                if (workJob.chevron_page__c == 'jo') { showRepairBlocks(true,false,false, false,false); }
                else if (workJob.chevron_page__c == 'vh') { showRepairBlocks(false,true,false, false,false);}
                else if (workJob.chevron_page__c == 'rm') { showRepairBlocks(false,false,false,true, false); }
                else if (workJob.chevron_page__c == 'rj') { showRepairBlocks(false,false,false, false, true); }
                else{ showRepairBlocks(true,false,false, false,false); }
                reqBoolean=false;
                reqShopBoolean=false;
                reqAppBoolean=false;
                reqMakeBoolean=false;
                reqMdlBoolean=false;
                reqCatBoolean=false;
                reqComtypBoolean=false;
                reqESNBoolean=false;
                //reqATTBoolean = false;
                ShowSubStatuspopup = (String)Cache.Session.get('ShowSubStatuspopup2');
                isReadUser = false;
                
                
                /* commenting below code since moved thiscode PagaAction method i.e., to QsolDocs method
//Get Campaigns
List<CSS_Solution_Component__c> solCompCTTP = [select Type__c,URL__c,  Component_Id__c, Campaign_Description__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_Solution_Component__c where Service_Job__c= :workJob.Id AND Type__c in('Campaign','TRP','ATC') and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))  order by Type__c ];
lstQSOLDocs = new List<CSS_CampTsbTrp__c>([Select Id, Type__c, Job_Order__c,ESN__c, Doc_Num__c, 
Doc_Title__c, URL__c, Reviewed__c,Performed__c,
Performed_Review__c,Cu_Language__c from CSS_CampTsbTrp__c
where Job_Order__c = :workJob.Id and ESN__c = :workJob.ESN__c
order by Performed_Review__c desc]);
system.debug('lstSOLCOMPDocs++++++'+solCompCTTP);
system.debug('lstQSOLDocs++++++'+lstQSOLDocs);
if (lstQSOLDocs.size()>0) {
lstCAM = new List<CSS_CampTsbTrp__c>();
lstTSB = new List<CSS_CampTsbTrp__c>();
lstTRP = new List<CSS_CampTsbTrp__c>();
lstATC = new List<CSS_CampTsbTrp__c>();
for (CSS_CampTsbTrp__c recQSOLDocs : lstQSOLDocs ) {
if (recQSOLDocs.Type__c == 'CAM') { lstCAM.add(recQSOLDocs); }
if (recQSOLDocs.Type__c == 'TSB') { lstTSB.add(recQSOLDocs); }
if (recQSOLDocs.Type__c == 'TRP') { lstTRP.add(recQSOLDocs); }
if (recQSOLDocs.Type__c == 'ATC') { lstATC.add(recQSOLDocs); }
}
}
System.debug('####### before adding QSOL links $$$$$$$$$ solCompCTTP>>:'+solCompCTTP+' lstQSOLDocs>:'+lstQSOLDocs);
if(solCompCTTP != null && solCompCTTP.size()>0 && lstQSOLDocs !=null && lstQSOLDocs.size()>0){
System.debug('####### before adding QSOL links $$$$$$$$$');
List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.addQSOLLinksToSiebelData(workjob.Id, solCompCTTP, lstCAM, lstTRP, lstATC);
if(campaignsList !=null && campaignsList.size()>=0)
lstCAM = campaignsList.get(0);
if(campaignsList !=null && campaignsList.size()>=1)
lstTRP = campaignsList.get(1);
if(campaignsList !=null && campaignsList.size()>=2)
lstATC = campaignsList.get(2);
system.debug('campaignsList>>>:'+campaignsList);
System.debug('####### final lstCAM $$$$$$$$$:'+lstCAM);
System.debug('####### final lstTRP $$$$$$$$$:'+lstTRP);
System.debug('####### final lstATC $$$$$$$$$:'+lstATC);
}
*/
                
            }
            catch(Exception e)  {
                system.debug('Repair Constructor '+ e.getLineNumber() + ' : '+e.getMessage());
            }
            //Modified by Manjari
            string getValue = css_utility.getDSIDEditIndicator(userinfo.getUserId(),workJob.DSID__c, workJob.DSID_WorkGroup__c);
            system.debug('@@getValue'+getValue);
            if(getValue == 'N' || getValue == 'G')
                isReadUser = true;    
            
            //End
        }
    }
    
    public void CampNotes(){
        
        if(Workjob.Notes != null && !workjob.Notes.isEmpty()){
            workjob2 = new List<Note>();
            for(Note b : workjob.Notes){
                if(b.title.equalsIgnoreCase('CAMPCOMMENTS')){
                    workjob2.add(b);
                }
                
            }
        }
        
        
    } 
    //Moulika Added for Story - 148884
    public Date warrantyDate{get;set;}
    public Boolean higherdateErrFlag{get;set;}
    public Boolean ReadonlyBIS{get; set;}
    public void CompareDates()
    {
        system.debug('warranty***'+warrantyDate);
        higherdateErrFlag = false;
        if(warrantyDate>date.today())
        {
            higherdateErrFlag = true;
            system.debug('GREATER**');
            //Commented below code as part of revised story - 148884
            //warrantyDate = null;
            //workJob.Warranty_Start_Date__c = null;
        }
        
        system.debug('***workJob.Before_In_Service__c**'+workJob.Before_In_Service__c);
        system.debug('***workJob.Warranty_Start_Date__c**'+workJob.Warranty_Start_Date__c);
        
        if(warrantyDate !=null && workJob.Before_In_Service__c==false){
            system.debug('**1**');
            ReadonlyBIS =true;
        }
        else{
            system.debug('**2**');
            ReadonlyBIS=false;
            workJob.Warranty_Start_Date__c=null;
        }
        
    }
    public void getCampaignDetails()
    {
        system.debug('Inside On Change function.Repair Review.');
        /*Story 147384: Rupesh*/
        /*********************************************************************************************************************************************/
        system.debug('JOB FDT:'+workJob.Failure_Date__c);
        system.debug('JOB BIS:'+workJob.Before_In_Service__c);
        system.debug('JOB WSDT:'+workJob.Warranty_Start_Date__c);
        system.debug('JOB SHPDT:'+workJob.ShipDate__c);
        /*Failure Date > WSD validation START*/
        if( (workJob.Failure_Date__c!=null) && (workJob.Before_In_Service__c==false) && ( workJob.Failure_Date__c < workJob.Warranty_Start_Date__c ))
        {
            System.debug('Failure Date should be after the Warranty Start Date'); 
            faildtwsdtflag=true;
            System.debug('Failure Date Set flag: '+faildtwsdtflag); 
        }
        /*Failure Date > WSD validation END*/
        else
            faildtwsdtflag=false;
        /*********************************************************************************************************************************************/
        /*Failure Date > ShipDate validation*/
        if(workJob.Failure_Date__c!=null)
            
        {
            //Just to supply the dummy value..to be deleted when WService works well
            if(workJob.ShipDate__c!=null)
            {
                if((workJob.Failure_Date__c) < (workJob.ShipDate__c))
                {
                    //system.debug('JOB SHPDT: Failure Date should be after the Ship Date: '+ShipDate);
                    faildtshdtflag=true;
                    system.debug('JOB SHPDT: Ship date flag is set to: '+faildtshdtflag);
                }
                else
                    faildtshdtflag = false;
            }
            map<String,String> accCerts = CG_BL_Intake.getCertificationStatus(workJob.Service_Model__c,workJob.Failure_Date__c,workJob.Account__c,workJob.Account__r.Warranty_Training_Certification__c,workJob.Account__r.Product_Certification__c, workJob.Account__r.Warranty_Training_Status__c, workJob.Account__r.CERTIFICATION_END_DATE__c);
                    if(accCerts.containsKey('warrCertFlag')){                       
                        workJob.Location_Certification__c=accCerts.get('certStatus');
                        workJob.Warranty_Authorization_Flag__c=accCerts.get('warrCertFlag');
                    }
                    if (workJob.Location_Certification__c =='NotCert'){
                        displaycertPopup = true;
                    }
        }
        
        
    
               system.debug('CSS_Job_Location__c'+workJob.Creator_Location__c);
                    string spCode = workJob.Creator_Location__c.right(5);
                    string failureDateStr;
                    Date FailureDate = date.valueOf(workJob.Failure_Date__c);
                    failureDateStr = DateTime.newInstance(FailureDate.year(),FailureDate.month(),FailureDate.day()).format('dd-MMM-YY'); 
                    CSS_GetServiceProviderResponse serviceProviderResponse = CSS_FN_SIEBEL.getServiceProviderDataWrapper(spCode.trim(), '', failureDateStr,workJob.Name);
                    system.debug('spCode'+spCode);
                    system.debug('failureDateStr'+failureDateStr);
                    system.debug('serviceProviderResponse'+serviceProviderResponse);
                    
                    if(serviceProviderResponse!=null){
                        workJob.SPDataWebserviceResult__c='Success';
                        workJob.CSS_In_Shop_Labor_Rate__c = serviceProviderResponse.DataArea.InShopLaborRate;
                    }
                    else
                    workJob.SPDataWebserviceResult__c='Error';
                    //workJob.SPDataWebserviceResult__c  = CG_BL_Intake.fetchSPData(workJob, workJob.creator_location__c, null, workJob.Failure_Date__c, null).SPDataWebserviceResult__c;
        /*********************************************************************************************************************************************/
    }
    
    
    
    
    
    
    
    public Boolean ReadonlyWSD{get; set;}
    public void onChangeBIS(){
        system.debug('**insideonChangeBIS'+workJob.Before_In_Service__c);
        system.debug('**WSD'+workJob.Warranty_Start_Date__c);
        if(workJob.Warranty_Start_Date__c == null && workJob.Before_In_Service__c==true){
            system.debug('**1**');
            ReadonlyWSD=true;
        }
        else{
            system.debug('**2**');
            ReadonlyWSD=false;
        }
    }
    
    //Prabhakar Added below Code (19/03) for Defect#134296
    public String getFailureDate() {
        //css_utility cUtil = new css_utility();
        DateTime fDate = workJob.Failure_Date__c;
        String locale_formatted_date_time_value = '';
        if(fDate != null)
            locale_formatted_date_time_value = fDate.format('M/d/yyyy', 'GMT'); //Get formatted String from Utility Class YYYY modified to yyyy
        return locale_formatted_date_time_value; //return the string
    }
    /* Required String input Parameters to be passed */
    //3. WO-WOQT Inbound request param variables 
    static String CSSJobID;
    static String ESN;
    static String Model;
    static String Make;
    static String Mobile;
    static string ServiceModelName1;
    static String DistributorCode;
    static String BranchCode;
    static String OrderType;
    static String CustomerNumber;
    static String Inshop;
    static String CreateDate;
    static String PromisedDate;
    static String BillType;
    static String CustNamePhone;
    static String SubType;
    static String UnitNumber;
    static String EngineFamily;
    static String Application; 
    //4. WO Comment Inbound request param variables
    //public boolean esnLock{get;set;}
    static String DistributorNumber;
    static String Branchnumber;
    //static String OrderType;
    //static String BMSReferenceNumber;
    static String CommentType; 
    static String Comment;
    /* create Job Order for the page AC*/
    
    public Boolean showJobPlanBoolean{get;set;}
    
    
    public void tndverification(){
        boolean solVer; 
        solVer=false; 
        try{
            //if(bmsEnabled == false){
            //bmsEnabled = (Boolean)Cache.Session.get('local.CSSPartition.UserBMSEnabled');
//Commented the below if condition completely and covered new if condition as per story #170265,-By RAJESH 23rd APR 2019
          /*  System.debug('bmsEnabled>>>:'+bmsEnabled);
            if(bmsEnabled == null || bmsEnabled==false){
                List<CSS_Solutions__c> solutionList= [Select Id,Diagnostic_Response__c,CSS_Nested_Solutions__c, CSS_Nested_Solutions__r.Name, CSS_Nested_Solutions__r.Case_Name__c from CSS_Solutions__c where Service_Job__c= :workJob.Id];        
                for(CSS_Solutions__c sol: solutionList){       
                    System.debug('in bmsEnabled false loop11...');
                    if(sol.Diagnostic_Response__c == 'Most likely the solution'){   
                        System.debug('in bmsEnabled false loop22...');
                        solVer= true;       
                    }  
                } 
            }*/
        System.debug('***workJob.Status__c***'+workJob.Status__c);
        System.debug('***workJob.Account__r.ERP_System__c***'+workJob.Account__r.ERP_System__c);
        System.debug('***workJob.BMSStatus__c***'+workJob.BMSStatus__c);
        if(workJob.Account__r.ERP_System__c.containsIgnoreCase('One BMS') || workJob.Account__r.ERP_System__c.containsIgnoreCase('BMS Legacy')){
         if(workJob.BMSStatus__c!=null && workJob.BMSStatus__c.contains('WC1')){
                solVer= true;
            }
            else{
                solVer= false;
            }
        }
        else{
                solVer= true;
        }
            
        }catch(Exception ex){
            System.debug('in catch of tndverification of CSS_repair_job >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        system.debug('tndverification>>>:'+solVer);
        showJobPlanBoolean=solVer; 
        
    }
    public boolean isDealer{get;set;}
    public string getLocations()
    {
        system.debug('inside get locations method');
        User usr;
        string LocationName;
        string orgtype=css_utility.getOrgType(userinfo.getUserId());
        try{
        if(orgtype=='DLR')
            isDealer = true;
        else
            isDealer = false;
        if (Wid == null){    
            //usr=css_utility.getUserAttributes(userinfo.getUserId());
            //string role=usr.UserRoleName__c;
            string role = (String)Cache.Session.get('local.CSSPartition.UserRoleName');
            
            system.debug('isDealer'+orgtype);
            if (orgtype=='DLR'){
                
                LocationName = role.removeEndIgnoreCase('user').removeEndIgnoreCase('manager').removeEndIgnoreCase('executive');
                system.debug('isDealer'+isDealer);
            }else{
                
                if(role.contains('-')==true)
                    LocationName = role.substringAfter('-');
                else
                    LocationName = role;
            } 
            jobLocation=LocationName;
        }else{
            //    system.debug('workjob.JobLocation__c;'+workjob.JobLocation__c);
            if(workjob != null)
                LocationName=workjob.JobLocation__c;
            //system.debug('4444'+LocationName);
        }
        system.debug('isDealer2'+isDealer);
        }
        catch(exception e){
            system.debug('in catch block of getLocation at line number'+e.getLineNumber()+'with error message'+e.getMessage());
        }
        //system.debug('5555'+LocationName);
        return LocationName;
    }
    public void updateNotes(){  
        try{
            String UserLocation = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
            if(UserLocation != workJob.Creator_Location__c){
                css_utility.setSessionVariables(workJob.Creator_Location__c);
                bmsEnabled = (Boolean)Cache.Session.get('local.CSSPartition.UserBMSEnabled');
            }else{
                bmsEnabled = (Boolean)Cache.Session.get('local.CSSPartition.UserBMSEnabled');
                system.debug('Anirudh BMS Enabled>>>>'+bmsEnabled);
                if(bmsEnabled == null){
                    css_utility.setSessionVariables(workJob.Creator_Location__c);
                    bmsEnabled = (Boolean)Cache.Session.get('local.CSSPartition.UserBMSEnabled');
                }
            }
            accountlang = css_utility.getLanguage((String)Cache.Session.get('local.CSSPartition.UserLanguageLocaleKey'));
            system.debug('accountlang>>>>>>'+accountlang);
            isReadUser = false;
            
            dsidIndi = '';
            Cache.Session.put('local.CSSPartition.DSIDIndicator', 'Blank'); 
            if(workJob.DSID__c!=null){
                dsidIndi = css_utility.getDSIDEditIndicator(userinfo.getUserId(),workJob.DSID__c, workJob.DSID_WorkGroup__c);
                if(dsidIndi != null) {
                    Cache.Session.put('local.CSSPartition.DSIDIndicator', dsidIndi);
                    system.debug('@@getValue'+dsidIndi);
                }
            }
            tndverification();
            if(dsidIndi == 'N' || dsidIndi == 'G')
                isReadUser = true;
            
            
            system.debug('accountlang>>>>:'+accountlang);
            getQSOLDocs();  //getSiebelQSOLCampaigns();
            //commented only tndverification method and calling same in custoctors because we should cover the same functionality in CSS_SymEDSSolutionsPage as well,story #170265 -By RAJESH 26th Apr 2019    
          //  tndverification();
          
          if(workJob.FieldActionWebServiceResult__c =='Error'){
                string FailureDateString;
                if(workJob.Failure_Date__c != null){
                    FailureDateString = DateTime.newInstance(workJob.Failure_Date__c.year(),workJob.Failure_Date__c.month(),workJob.Failure_Date__c.day()).format('dd-MMM-YY');
                }
                CG_BL_Campaigns.callGetCampaignsWebServiceOnChevronChangeJob(workJob.ESN__c, FailureDateString, workJob.Region__c, workJob.Territory_Class__c, 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', workJob.Name, workJob.Id);
                //to fetch the updated webservice error flags
                if(Wid != null){
                    workJob.FieldActionWebServiceResult__c = [Select Id,FieldActionWebServiceResult__c from CSS_Job_Order__c where id= :Wid].FieldActionWebServiceResult__c;
                }
            }
          
          if(workJob != null){
            update workJob;
            }
            //End
            
            update notesList; 
        }catch(exception e){
            system.debug('Entered in Catch Update notes of repair controller'+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }
    
    
    public void getQSOLDocs(){
        try{
            lstCAM = new List<CSS_CampTsbTrp__c>();
            lstTRP = new List<CSS_CampTsbTrp__c>();
            lstTSB = new List<CSS_CampTsbTrp__c>();
            lstATC = new List<CSS_CampTsbTrp__c>();
            system.debug('in pageload getQSOLDocs before calling CG_BL_Intake.getSiebelQSOLCampaigns>>>');
            List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getSiebelQSOLCampaigns(workJob.Id, workJob.ESN__c, accountlang.CSS_QsolLanguage__c, workJob.Service_Model__c, workJob.Failure_Date__c);
            system.debug('in pageload getQSOLDocs after calling CG_BL_Intake.getSiebelQSOLCampaigns campaignsList>>>:'+campaignsList);
             
            if(campaignsList !=null && campaignsList.size()>0)
                lstTSB = campaignsList.get(0);
            if(campaignsList !=null && campaignsList.size()>1)
                lstCAM = campaignsList.get(1);
            if(campaignsList !=null && campaignsList.size()>2)
                lstTRP = campaignsList.get(2);
            if(campaignsList !=null && campaignsList.size()>3)
                lstATC = campaignsList.get(3);
            
            //below code should be deleted
            /*lstALL = new List<CSS_CampTsbTrp__c>();
if(lstCAM != null && !lstCAM.isEmpty())
lstALL.addAll(lstCAM);
if(lstTRP != null && !lstTRP.isEmpty())
lstALL.addAll(lstTRP);
if(lstATC != null && !lstATC.isEmpty())
lstALL.addAll(lstATC);
system.debug('in getQSOLDocs...lstALL>>>:'+lstALL);*/
            
        } catch(exception e) {
            system.debug('EXCEPTION of css_repair_job getQSOLDocs method >>> '+e.getMessage() + e.getLineNumber());
        }
    }
    
    public String region{get;set;}
    Transient List<CSS_CampTsbTrp__c> lstQSOLDocs;
    public Integer timeinMinutes{get;set;}
    public Integer timeinhours {get;set;}
    public string sServiceModel {get; set;}
    public String dispDTime{get;set;}
    public String dispRepTime{get;set;}
    public Decimal digTime{get;set;}
    public Decimal repTime{get;set;}
    public Decimal NewrepTime{get;set;}
    public Decimal NewdigTime{get;set;}
    public Integer NewdigMin{get;set;}
    public Integer NewrepMin{get;set;}
    public boolean bmsEnabled {get;set;}
    public String selectedSubStatusVal {get;set;}
    public string dsidIndi{get;set;}//67550
    list<Note> notesList = new list<Note>();
    public Boolean isPrioritized {get; set;}
    public css_job_order__c workJob {get;set;}
    Transient List<CSS_CampTsbTrp__c> qsolCTTP {get;set;}
    public List<Note> workJob2 {get;set;}
    Transient public List<CSS_CampTsbTrp__c> lstCAM {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTRP {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstTSB {get; set;}
    Transient public List<CSS_CampTsbTrp__c> lstATC {get; set;}
    public string comm {get;set;}
    public List<Attachment> jobAttach {get;set;}
    public String description {get;set;}
    public String description1 {get;set;}
    public String description2 {get;set;}
    public String description3 {get;set;}
    public Blob fileBody {get;set;}
    public Blob fileBody2 {get;set;}//MN
    public Blob fileBody3 {get;set;}
    public String fileName {get;set;}
    public String fileName2 {get;set;}
    public String fileName3 {get;set;}
    public ID Wid;
    public string jobLocation;
    public boolean reqBoolean {get;set;}
    public boolean reqATTBoolean {get;set;} 
    public boolean reqShopBoolean {get;set;}
    public boolean reqAppBoolean {get;set;}
    public boolean reqMakeBoolean {get;set;}
    public boolean reqMdlBoolean {get;set;}
    public boolean reqCatBoolean {get;set;}
    public boolean reqComtypBoolean {get;set;}
    public boolean reqESNBoolean {get;set;}
    public string rpid;
    public string strEDSCodes;
    public String filterMake;
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
    
    public String filterModel;
    public Boolean displaycertPopup {get;set;}
    public Boolean displaySrvModPopup {get;set;}
    public Boolean displaySrvModPopup1 {get;set;}
    
    
    public string mil_measure;
    public string fail_measure;
    public List<AggregateResult> lmake = new List<AggregateResult>();
    public List<CSS_Make_Model_Access__c> lmodel = new List<CSS_Make_Model_Access__c>();
    
    
    public string jo_btn_cls { get; set; }    
    public string vh_btn_cls { get; set; }
    public string vi_btn_cls { get; set; }
    public string ts_btn_cls { get; set; }
    public string rj_btn_cls { get; set; }
    
    public string jo_chv_sts { get; set; }    
    public string vh_chv_sts { get; set; }
    public string vi_chv_sts { get; set; }
    public string ts_chv_sts { get; set; }
    public string rj_chv_sts { get; set; }
    
    public string jo_txt_sts { get; set; }    
    public string vh_txt_sts { get; set; }
    public string vi_txt_sts { get; set; }
    public string ts_txt_sts { get; set; }
    public string rj_txt_sts { get; set; }
    
    public string jo_txt_val { get; set; }   
    public string vh_txt_val { get; set; } 
    public string vi_txt_val { get; set; }
    public string ts_txt_val { get; set; }  
    public string rj_txt_val { get; set; }
    
    public Boolean displayPopup {get;set;}
    public Boolean displayPopup1 {get;set;}
    public Boolean displayPopup4 {get;set;}
    public Boolean displayPopup5 {get;set;}
    public Boolean displayPopup6 {get;set;}
    
    public Boolean displayPopup8 {get;set;}
    
    public Boolean show_jo_pnl { get; set; }  
    public Boolean show_vh_pnl { get; set; } 
    public Boolean show_vi_pnl { get; set; } 
    public Boolean show_ts_pnl { get; set; }  
    public Boolean show_rj_pnl { get; set; }  
    
    public boolean dsidStatus {get;set;}
    public String atthId{get; set;}
    public String delatthId{get; set;}
    public String atthName{get; set;} 
    public integer rowcount {get;set;}   
    list<Profile> profileList;
    public string pgName;
    string DSID{get;set;}
    public string getDSID(){
        DSID = workJob.DSID__c;
        return DSID;
    }
    
    public void closeSrvModPopup(){
        displaySrvModPopup = false;
    }
    public void closeSrvModPopup1(){
        displaySrvModPopup1 = false;
    }
    
    public List<SelectOption> getMake() {
        List<SelectOption> MakeList = new List<SelectOption>(); 
        try {
            String recordTypeIdSRT =  Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
            //Commented by Rajesh Narra on 10/16/2018  [Select Id, Name from RecordType where Name = 'SRTData' limit 1].Id;
            //added Status__c = \'ACTIVE\' for the defect 135113 by venkat
            string strMKQuery='Select Make__c, count(UniqueKey__c) From CSS_Make_Model_Access__c where Status__c = \'ACTIVE\' and RecordTypeId=\''+recordTypeIdSRT+'\' ';
            string engFamilyCode;
            system.debug('filterApplication>>>>:'+filterApplication);
            
            if (sEngineFamilyCode!=null){
                engFamilyCode=sEngineFamilyCode;
            }else{
                engFamilyCode=workJob.Qsol_Engine_Family_Code__c;
            }
            system.debug('engFamilyCode>>>:'+engFamilyCode+' filterApplication>>>:'+filterApplication);
            
            if(engFamilyCode!=null && engFamilyCode!=''){
                strMKQuery=strMKQuery+ 'AND EngineFamilyCode__c=\''+ engFamilyCode+'\' ';
            }
            
            if(filterApplication != null && filterApplication !='' && filterApplication.contains('AUTOMOTIVE')){
                strMKQuery=strMKQuery+ 'AND ApplicationCategory__c in (\'A\', \'B\') ';
            }else  if(filterApplication != null && filterApplication !='' && filterApplication.contains('WORLDWIDE OFF-HIGHWAY')){
                strMKQuery=strMKQuery+ 'AND ApplicationCategory__c in (\'B\', \'I\') ';
            }
            
            strMKQuery=strMKQuery+ 'group by Make__c Order By Make__c asc LIMIT 999';
            system.debug('strMKQuery>>>>:'+strMKQuery);
            lmake=Database.query(strMKQuery);
            
            MakeList = new List<SelectOption>();
            MakeList.add(new SelectOption('','----None----'));
            for(AggregateResult mk: lmake)
            {  
                if(mk.get('Make__c')!=null && mk.get('Make__c')!='')
                    MakeList.add(new SelectOption((string)mk.get('Make__c'), (string)mk.get('Make__c')));
            }
            /*if(workJob.PSN_Not_Available__c == true){
filterMake = 'UNLISTED';
workjob.Make__c = filterMake;  
//changes for story 86422 end
} */
        }
        catch(exception e)
        {
            system.debug('Catch Make exeption:'+ e.getLineNumber() + ' ' + e.getMessage());
            
        }
        return MakeList;
    }
    
    public List<SelectOption> getModel(){      
        List<SelectOption> ModelList = new List<SelectOption>();
        string engFamilyCode;
        try {
            String recordTypeIdSRT = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId(); 
            // Commented by Rajesh Narra on 10/16/2018  [Select Id, Name from RecordType where Name = 'SRTData' limit 1].Id;
            //added Status__c = \'ACTIVE\' for the defect 135113 by Venkat
            string strQuery='Select id,Model__c  From CSS_Make_Model_Access__c where Status__c = \'ACTIVE\' and RecordTypeId=\''+recordTypeIdSRT+'\' AND Make__c=\''+ filterMake+'\' ';
            if (sEngineFamilyCode!=null ){
                engFamilyCode=sEngineFamilyCode;
            }else{
                engFamilyCode=workJob.Qsol_Engine_Family_Code__c;
            }
            if(engFamilyCode!=null && engFamilyCode!=''){
                strQuery=strQuery+ ' AND EngineFamilyCode__c=\''+engFamilyCode+'\' ';
            }
            
            if(filterApplication != null && filterApplication !='' && filterApplication.contains('AUTOMOTIVE')){
                strQuery=strQuery+ 'AND ApplicationCategory__c in (\'A\', \'B\') ';
            }else if(filterApplication != null && filterApplication !='' && filterApplication.contains('WORLDWIDE OFF-HIGHWAY')){
                strQuery=strQuery+ 'AND ApplicationCategory__c in (\'B\', \'I\') ';
            }
            strQuery=strQuery+ ' Order By Model__c asc LIMIT 999';
            
            system.debug('Model strQuery>>>>:'+strQuery);
            lmodel=Database.query(strQuery);
            system.debug('Rajesh+lmodel'+lmodel);
            ModelList.add(new SelectOption('','----None----'));
            for(CSS_Make_Model_Access__c temp1: lmodel)
            {
                ModelList.add(new SelectOption(temp1.Model__c,temp1.Model__c));
                //system.debug('Model strQuery'+ModelList);
            }
            
            
            //changes for story 86422 Ekta
            /* if(workJob.PSN_Not_Available__c == true){
filterModel ='ALL';
workjob.Model__c=filterModel; 
//changes for story 86422 end
}*/
        }
        catch(exception e)
        { 
            system.debug('in catch Model exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return ModelList;
    }
    
    
    
    public String getfilterMake() 
    {
        return filterMake;
    }
    public void setfilterMake(String mfilterMake) 
    {
        this.filterMake = mfilterMake; 
    }
    public String getfilterModel() 
    {
        return filterModel;
    }
    public void setfilterModel(String mfilterModel) 
    {
        this.filterModel = mfilterModel;
    }
    public void fetchModelRecords() {
        
    }
    public String getfail_measure() 
    {
        return fail_measure;
    }
    public void setfail_measure(String failmeasure) 
    {
        this.fail_measure = failmeasure;
    }
    
    public String getfilterCategory() 
    {
        System.debug('********getfilterCategory'+filterCategory );
        return filterCategory;
    }
    public void setfilterCategory(String mfilterCategory) 
    {
        this.filterCategory = mfilterCategory; 
        System.debug('********setfilterCategory'+mfilterCategory);
    }
    public String getfilterCategory2() 
    {
        System.debug('********getfilterCategory2'+filterCategory2 );
        return filterCategory2;
    }
    public void setfilterCategory2(String mfilterCategory2) 
    {
        this.filterCategory2 = mfilterCategory2; 
        System.debug('********setfilterCategory2'+mfilterCategory2);
    }
    public String getfilterCategory3() 
    {
        System.debug('********getfilterCategory3'+filterCategory3);
        return filterCategory3;
    }
    public void setfilterCategory3(String mfilterCategory3) 
    {
        this.filterCategory3 = mfilterCategory3; 
        System.debug('********setfilterCategory3'+mfilterCategory3);
    }
    public String getfilterCategory4() 
    {
        System.debug('********getfilterCategory4'+filterCategory4 );
        return filterCategory4;
    }
    public void setfilterCategory4(String mfilterCategory4) 
    {
        this.filterCategory4 = mfilterCategory4; 
        System.debug('********setfilterCategory4'+mfilterCategory4);
    }
    public String getfilterCategory5() 
    {
        System.debug('********getfilterCategory5'+filterCategory5 );
        return filterCategory5;
    }
    public void setfilterCategory5(String mfilterCategory5) 
    {
        this.filterCategory5 = mfilterCategory5; 
        System.debug('********setfilterCategory5'+mfilterCategory5);
    }
    
    public String getfilterComplaintType() 
    {
        System.debug('********getfilterComplaintType'+filterComplaintType);
        return filterComplaintType;
        
    }
    public void setfilterComplaintType(String mfilterComplaintType) 
    {
        this.filterComplaintType = mfilterComplaintType; 
        System.debug('********setfilterComplaintType'+mfilterComplaintType);
    }
    public String getfilterComplaintType2() 
    {
        System.debug('********getfilterComplaintType2'+filterComplaintType2);
        return filterComplaintType2;
        
    }
    public void setfilterComplaintType2(String mfilterComplaintType2) 
    {
        this.filterComplaintType2 = mfilterComplaintType2; 
        System.debug('********setfilterComplaintType2'+mfilterComplaintType2);
    }
    public String getfilterComplaintType3() 
    {
        System.debug('********getfilterComplaintType3'+filterComplaintType3);
        return filterComplaintType3;
        
    }
    public void setfilterComplaintType3(String mfilterComplaintType3) 
    {
        this.filterComplaintType3 = mfilterComplaintType3; 
        System.debug('********setfilterComplaintType3'+mfilterComplaintType3);
    }
    public String getfilterComplaintType4() 
    {
        System.debug('********getfilterComplaintType4'+filterComplaintType4);
        return filterComplaintType4;
        
    }
    public void setfilterComplaintType4(String mfilterComplaintType4) 
    {
        this.filterComplaintType4 = mfilterComplaintType4; 
        System.debug('********setfilterComplaintType4'+mfilterComplaintType4);
    }
    public String getfilterComplaintType5() 
    {
        System.debug('********getfilterComplaintType5'+filterComplaintType5);
        return filterComplaintType5;
        
    }
    public void setfilterComplaintType5(String mfilterComplaintType5) 
    {
        this.filterComplaintType5 = mfilterComplaintType5; 
        System.debug('********setfilterComplaintType5'+mfilterComplaintType5);
    }
    
    public PageReference css_redirect()
    {
        PageReference pageRef = new pageReference('/apex/CSS_JobRepair?id='+Wid); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /*   public PageReference delAttachment()
{
if (atthId != null)
{
Attachment AttachmenttoDel=new Attachment(id=atthId);
delete AttachmenttoDel;
PageReference pageRef = new pageReference('/apex/CSS_JobRepair?id='+wid); 
//  PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl().substringBefore('?')+'?id='+Wid); 
pageRef.setRedirect(true);
return pageRef;
}
else
{
return null;
}
}*/
    
    //Rajesh code satrt
    public PageReference delAttachment()
        
    {
        System.debug('shan attchid'+atthId);
        if (atthId!= null)
        {
            Attachment AttachmenttoDel=new Attachment(id=atthId);
            
            //Rajesh Code start 
            Attachment Attalist =[select name,id,body,parentid from Attachment where id=:atthId];            
            CSS_JobHistory__c DeleteHiscRec = new CSS_JobHistory__c();
            DeleteHiscRec.CSS_Object_Name__c = 'Attachment';
            DeleteHiscRec.CSS_Job_Id__c = Wid;
            system.debug('CSS_Job_Id__c--->'+DeleteHiscRec.CSS_Job_Id__c);
            DeleteHiscRec.CSS_Field_Name__c ='Attachment';
            DeleteHiscRec.CSS_Old_Value__c = 'Deleted';
            DeleteHiscRec.CSS_New_Value__c = Attalist.name;
            system.debug('CSS_New_Value__c--->'+DeleteHiscRec.CSS_New_Value__c);
            if(DeleteHiscRec!=null){
                insert DeleteHiscRec;
            } 
            system.debug('DeleteHiscRec--->'+DeleteHiscRec);
            
            delete AttachmenttoDel;
            system.debug('AttachmenttoDel--->'+AttachmenttoDel);
            // PageReference pageRef = new pageReference('/apex/CSS_JobRepairRj?id='+wid); 
            // PageReference pageRef = new pageReference('/apex/CSS_JobRepair?id='+wid);
            // PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            
            //string sdeepId = ApexPages.currentPage().getUrl().substringafter('&');
            // string url = ApexPages.currentPage().getUrl();
            //PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl().substringBefore('?')+'?id='+Wid + '&' + sdeepId); 
            pageReference ReturnPage = ApexPages.currentPage(); 
            Id id = ReturnPage.getParameters().get('Id');
            Id symid= ReturnPage.getParameters().get('symid');
            Id fcid= ReturnPage.getParameters().get('fcid');
            String rank= ReturnPage.getParameters().get('rank');
            
            
            ReturnPage.getParameters().clear();
            ReturnPage.getParameters().put('Id', id);
            ReturnPage.getParameters().put('fcid', fcid);
            ReturnPage.getParameters().put('rank', rank);
            ReturnPage.getParameters().put('symid', symid);
            ReturnPage.setRedirect(true);
            return ReturnPage ;
            
        }
        else
        {
            system.debug('shanthi else--->');
            return null;
        }
    }
    //Rajesh Code end
    public PageReference editAttachment()
    {
        system.debug('edit description' +atthId);
        if (atthId != null)
        {
            Attachment AttachmenttoUpd=new Attachment(id=atthId,description=description);
            update AttachmenttoUpd;
            /// PageReference pageRef = new pageReference('/apex/CSS_JobRepair?id='+wid); 
            //  PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl().substringBefore('?')+'?id='+Wid);
            //PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            pageReference ReturnPage = ApexPages.currentPage(); 
            Id id = ReturnPage.getParameters().get('Id');
            Id symid= ReturnPage.getParameters().get('symid');
            Id fcid= ReturnPage.getParameters().get('fcid');
            String rank= ReturnPage.getParameters().get('rank');
            
            
            ReturnPage.getParameters().clear();
            ReturnPage.getParameters().put('Id', id);
            ReturnPage.getParameters().put('fcid', fcid);
            ReturnPage.getParameters().put('rank', rank);
            ReturnPage.getParameters().put('symid', symid);
            ReturnPage.setRedirect(true);
            return ReturnPage ;
        }
        else
        {
            return null;
        }
    }
    
    public PageReference repair_jo()
    {
        css_job_order__c worecord= new css_job_order__c();
        showRepairBlocks(true,false,false, false,false);
        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {
            worecord.PSN_PACCAR_Flag__c=workJob.PSN_PACCAR_Flag__c;
            worecord.Customer_Name__c=workJob.Customer_Name__c;
            worecord.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
            worecord.Application_Desc__c = filterApplication;
            worecord.Unit_number__c = workJob.Unit_number__c;
            worecord.ESN__c = workJob.ESN__c;
            worecord.Make__c = filterMake;
            worecord.Model__c = filterModel;
            worecord.Category_Desc__c = filterCategory;
            worecord.Category2_Desc__c = filterCategory2;
            worecord.Category3_Desc__c = filterCategory3;
            worecord.Category4_Desc__c = filterCategory4;
            worecord.Category5_Desc__c = filterCategory5;
            worecord.Complaint_Type_Desc__c = filterComplaintType;
            worecord.Complaint_Type2_Desc__c = filterComplaintType2;
            worecord.Complaint_Type3_Desc__c = filterComplaintType3;
            worecord.Complaint_Type4_Desc__c = filterComplaintType4;
            worecord.Complaint_Type5_Desc__c = filterComplaintType5;
            //worecord.Complaint_Type__c = workJob.Complaint_Type__c;
            worecord.Mileage__c = workJob.Mileage__c;
            worecord.CSS_Hours__c = workJob.CSS_Hours__c;    
            worecord.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
            worecord.Mileage_Measure__c = mil_measure;
            worecord.Failure_Date__c=workJob.Failure_Date__c;
            worecord.Failure_Point__c = workJob.Failure_Point__c;
            worecord.Unit_Type__c=workJob.Unit_Type__c;
            worecord.Sub_Type__c=filterSubType;
            worecord.Failure_Point_Measure__c = fail_measure;
            worecord.General_Symptoms__c=workJob.General_Symptoms__c;
            /*worecord.Category2__c=workJob.Category2__c;
worecord.Complaint_Type2__c=workJob.Complaint_Type2__c;
worecord.Category3__c=workJob.Category3__c;
worecord.Complaint_Type3__c=workJob.Complaint_Type3__c;
worecord.Category4__c=workJob.Category4__c;
worecord.Complaint_Type4__c=workJob.Complaint_Type4__c;
worecord.Category5__c=workJob.Category5__c;
worecord.Complaint_Type5__c=workJob.Complaint_Type5__c;*/
            worecord.Preventive_Maintenance__c=workJob.Preventive_Maintenance__c;
            worecord.Expedited_Service__c=workJob.Expedited_Service__c;
            worecord.VIN__c = workJob.VIN__c;
            worecord.VIN_Flag__c = workJob.VIN_Flag__c;
            worecord.License_Plate__c = workJob.License_Plate__c;
            worecord.chevron_page__c = 'jo';
            worecord.Status__c='Repair';
            // Defect fix 59457
            //saveCheckBox(); //Commented as per the story 190513
            if (Wid != null)
            {
                worecord.id=workJob.id;
                if(workjob.warranty_start_date__c != null){
                    worecord.before_in_service__c = false;
                }else{worecord.before_in_service__c = true;}
                update worecord;
                // return null;
            }
        }
        //Sai:9/28 for INC000005560691 Defect 95870. Commented below line.
        //PageReference pageRef = new pageReference('/apex/CSS_JobRepair?id='+worecord.id); 
        PageReference pageRef = new pageReference('/apex/CSS_JobRepair_JO?id='+worecord.id);
        pageRef.setRedirect(true);
        return pageRef;
        
    }
    public PageReference repair_vh()
    {
        css_job_order__c worecord= new css_job_order__c();
        showRepairBlocks(false,true,false, false,false);
        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {
            worecord.PSN_PACCAR_Flag__c=workJob.PSN_PACCAR_Flag__c;
            worecord.Customer_Name__c=workJob.Customer_Name__c;
            worecord.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
            worecord.General_Symptoms__c=workJob.General_Symptoms__c;
            worecord.Category_Desc__c = filterCategory;
            worecord.Category2_Desc__c = filterCategory2;
            worecord.Category3_Desc__c = filterCategory3;
            worecord.Category4_Desc__c = filterCategory4;
            worecord.Category5_Desc__c = filterCategory5;
            worecord.Complaint_Type_Desc__c = filterComplaintType;
            worecord.Complaint_Type2_Desc__c = filterComplaintType2;
            worecord.Complaint_Type3_Desc__c = filterComplaintType3;
            worecord.Complaint_Type4_Desc__c = filterComplaintType4;
            worecord.Complaint_Type5_Desc__c = filterComplaintType5;
            //worecord.Complaint_Type__c = workJob.Complaint_Type__c;
            /*worecord.Category2__c=workJob.Category2__c;
worecord.Complaint_Type2__c=workJob.Complaint_Type2__c;
worecord.Category3__c=workJob.Category3__c;
worecord.Complaint_Type3__c=workJob.Complaint_Type3__c;
worecord.Category4__c=workJob.Category4__c;
worecord.Complaint_Type4__c=workJob.Complaint_Type4__c;
worecord.Category5__c=workJob.Category5__c;
worecord.Complaint_Type5__c=workJob.Complaint_Type5__c;*/
            worecord.Unit_Type__c=workJob.Unit_Type__c;
            worecord.Sub_Type__c=filterSubType;
            worecord.Preventive_Maintenance__c=workJob.Preventive_Maintenance__c;
            worecord.Expedited_Service__c=workJob.Expedited_Service__c;
            // Defect#48619
            worecord.Application_Desc__c=filterApplication;
            worecord.Unit_Number__c=workJob.Unit_Number__c;
            worecord.ESN__c=workJob.ESN__c;
            worecord.Mileage__c=workJob.Mileage__c;
            worecord.CSS_Hours__c=workJob.CSS_Hours__c;
            worecord.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
            worecord.Mileage_Measure__c=mil_measure;
            worecord.Make__c = filterMake;
            worecord.Model__c = filterModel;
            worecord.Failure_Date__c=workJob.Failure_Date__c;
            worecord.Failure_Point__c = workJob.Failure_Point__c;
            worecord.Failure_Point_Measure__c = fail_measure;
            worecord.chevron_page__c = 'vh';
            //worecord.Previous_Status__c = workJob.Status__c;
            worecord.Status__c='Repair';
            worecord.VIN__c = workJob.VIN__c;
            worecord.VIN_Flag__c = workJob.VIN_Flag__c;
            // Defect fix 59457
            //saveCheckBox(); //Commented as per the story 190513
            
            if (Wid != null)
            {
                //  System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                if(workjob.warranty_start_date__c != null){
                    worecord.before_in_service__c = false;
                }else{worecord.before_in_service__c = true;}
                update worecord;
                //  System.Debug('record updated====='+worecord);
            }
        } 
        //Sai:9/28 for INC000005560691 Defect 95870. Commented below line.
        //PageReference pageRef = new pageReference('/apex/CSS_JobRepair?id='+worecord.id); 
        PageReference pageRef = new pageReference('/apex/CSS_JobRepair_VH?id='+worecord.id); 
        pageRef.setRedirect(true);
        return pageRef;
    }    
    
    public PageReference repair_vi()
    {
        //css_job_order__c worecord= new css_job_order__c();
        showRepairBlocks(false,false,true,false,false);
        PageReference pageRef = new pageReference('/apex/CSS_JobRepair?id='+wid); 
        return pageRef;
    } 
    
    public PageReference repair_rm()
    {
        css_job_order__c worecord= new css_job_order__c();
        showRepairBlocks(false,false,false, true,false); 
        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {
            worecord.PSN_PACCAR_Flag__c=workJob.PSN_PACCAR_Flag__c;
            worecord.Customer_Name__c=workJob.Customer_Name__c;
            worecord.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
            worecord.Application_Desc__c = filterApplication;
            worecord.Category_Desc__c = filterCategory;
            worecord.Category2_Desc__c = filterCategory2;
            worecord.Category3_Desc__c = filterCategory3;
            worecord.Category4_Desc__c = filterCategory4;
            worecord.Category5_Desc__c = filterCategory5;
            worecord.Complaint_Type_Desc__c = filterComplaintType;
            worecord.Complaint_Type2_Desc__c = filterComplaintType2;
            worecord.Complaint_Type3_Desc__c = filterComplaintType3;
            worecord.Complaint_Type4_Desc__c = filterComplaintType4;
            worecord.Complaint_Type5_Desc__c = filterComplaintType5;
            //worecord.Complaint_Type__c = workJob.Complaint_Type__c;
            /*worecord.Category2__c=workJob.Category2__c;
worecord.Complaint_Type2__c=workJob.Complaint_Type2__c;
worecord.Category3__c=workJob.Category3__c;
worecord.Complaint_Type3__c=workJob.Complaint_Type3__c;
worecord.Category4__c=workJob.Category4__c;
worecord.Complaint_Type4__c=workJob.Complaint_Type4__c;
worecord.Category5__c=workJob.Category5__c;
worecord.Complaint_Type5__c=workJob.Complaint_Type5__c;*/
            worecord.Preventive_Maintenance__c=workJob.Preventive_Maintenance__c;
            worecord.Expedited_Service__c=workJob.Expedited_Service__c;
            worecord.Unit_number__c = workJob.Unit_number__c;
            worecord.ESN__c = workJob.ESN__c;
            worecord.Mileage__c = workJob.Mileage__c;
            worecord.CSS_Hours__c = workJob.CSS_Hours__c;
            worecord.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
            worecord.Unit_Type__c=workJob.Unit_Type__c;
            worecord.Sub_Type__c=filterSubType;
            worecord.Mileage_Measure__c = mil_measure;
            worecord.Make__c = filterMake;
            worecord.Model__c = filterModel;
            worecord.Failure_Date__c=workJob.Failure_Date__c;
            worecord.Failure_Point__c = workJob.Failure_Point__c;
            worecord.Failure_Point_Measure__c = fail_measure;
            worecord.General_Symptoms__c=workJob.General_Symptoms__c;
            worecord.VIN__c = workJob.VIN__c;
            worecord.VIN_Flag__c = workJob.VIN_Flag__c;
            worecord.chevron_page__c = 'rm';
            //worecord.Previous_Status__c = workJob.Status__c;
            worecord.Status__c='Repair';
            // Defect fix 59457
            //saveCheckBox(); Commented as per story 190513
            if (Wid != null)
            {
                System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                if(workjob.warranty_start_date__c != null){
                    worecord.before_in_service__c = false;
                }else{worecord.before_in_service__c = true;}
                update worecord;
                System.Debug('record updated====='+worecord);
                //   return null;
            }
        } 
        PageReference pageRef = new pageReference('/apex/CSS_JobRepair?id='+worecord.id); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public PageReference repair_rj()
    {
        css_job_order__c worecord= new css_job_order__c();
        showRepairBlocks(false,false,false,false,true);
        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {
            worecord.Customer_Name__c=workJob.Customer_Name__c;
            worecord.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
            worecord.Application_Desc__c = filterApplication;
            worecord.Category_Desc__c = filterCategory;
            worecord.Category2_Desc__c = filterCategory2;
            worecord.Category3_Desc__c = filterCategory3;
            worecord.Category4_Desc__c = filterCategory4;
            worecord.Category5_Desc__c = filterCategory5;
            worecord.Complaint_Type_Desc__c = filterComplaintType;
            worecord.Complaint_Type2_Desc__c = filterComplaintType2;
            worecord.Complaint_Type3_Desc__c = filterComplaintType3;
            worecord.Complaint_Type4_Desc__c = filterComplaintType4;
            worecord.Complaint_Type5_Desc__c = filterComplaintType5;
            //worecord.Complaint_Type__c = workJob.Complaint_Type__c;
            /*worecord.Category2__c=workJob.Category2__c;
worecord.Complaint_Type2__c=workJob.Complaint_Type2__c;
worecord.Category3__c=workJob.Category3__c;
worecord.Complaint_Type3__c=workJob.Complaint_Type3__c;
worecord.Category4__c=workJob.Category4__c;
worecord.Complaint_Type4__c=workJob.Complaint_Type4__c;
worecord.Category5__c=workJob.Category5__c;
worecord.Complaint_Type5__c=workJob.Complaint_Type5__c;*/
            worecord.Preventive_Maintenance__c=workJob.Preventive_Maintenance__c;
            worecord.Expedited_Service__c=workJob.Expedited_Service__c;
            worecord.Unit_Type__c=workJob.Unit_Type__c;
            worecord.Sub_Type__c=filterSubType;
            worecord.Unit_number__c = workJob.Unit_number__c;
            worecord.ESN__c = workJob.ESN__c;
            worecord.Mileage__c = workJob.Mileage__c;
            worecord.CSS_Hours__c = workJob.CSS_Hours__c;
            worecord.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
            worecord.Mileage_Measure__c = mil_measure;
            worecord.Make__c = filterMake;
            worecord.Model__c = filterModel;
            worecord.Failure_Date__c=workJob.Failure_Date__c;
            worecord.Failure_Point__c = workJob.Failure_Point__c;
            worecord.Failure_Point_Measure__c = fail_measure;
            worecord.General_Symptoms__c=workJob.General_Symptoms__c;
            worecord.VIN__c = workJob.VIN__c;
            worecord.VIN_Flag__c = workJob.VIN_Flag__c;
            worecord.chevron_page__c = 'rj';
            //worecord.Previous_Status__c = workJob.Status__c;
            worecord.Status__c='Repair';
            // Defect fix 59457
            //saveCheckBox(); //Commented as per the story 190513
            if (Wid != null)
            {
                System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                if(workjob.warranty_start_date__c != null){
                    worecord.before_in_service__c = false;
                }else{worecord.before_in_service__c = true;}
                update worecord;
                System.Debug('record updated====='+worecord);
                //  return null;
            }
        } 
        PageReference pageRef = new pageReference('/apex/CSS_JobRepairRJ?id='+worecord.id); 
        //PageReference pageRef = new pageReference('/apex/CSS_JobRepair?id='+worecord.id); 
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /*  public PageReference Cancel()
{
return null;
}   */

    public String filterCountry;
    public String filterState;
    
    //82020- Story87378 Reminder when canceling a job - Krishna on 19-06-2017.
    public Boolean displaycancelModPopup {get;set;}
    
    public void showcancelpopup(){
        displaycancelModPopup = true;
    }
    
    public void cancelModPopup(){
        displaycancelModPopup = false;
    }
    //82020- Story87378 Reminder when canceling a job - Krishna on 19-06-2017.
    
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
            system.debug(workJob);
            //  CSS_JobOrderWrapper wrap = new CSS_JobOrderWrapper(workJob,filterMake,filterModel,mil_measure,fail_measure,filterCountry,filterState,bmsEnabled);
            CSS_JobOrderWrapper wrap = new CSS_JobOrderWrapper(workJob,filterMake,filterModel,mil_measure,fail_measure,filterCountry,filterState,bmsEnabled,EmailAddress,EmailAddress1,false);
            
            System.Debug('inside cancel11');
            worecord = wrap.worecord;
            worecord.Location_Certification__c=workjob.Location_Certification__c;
            //worecord.Previous_Status__c = workJob.Status__c;
            worecord.Status__c='Canceled';
            // Story - 67555 DS Read Only - start
            System.Debug('dsidIndi dsidIndi' + dsidIndi);
            //if(dsidIndi != null && dsidIndi.containsIgnoreCase('O')){ 
            if((dsidIndi != null && dsidIndi.containsIgnoreCase('O')) || (dsidIndi != null && dsidIndi.containsIgnoreCase('N')) || (dsidIndi != null && dsidIndi.containsIgnoreCase('G'))){
                // Defect fix 59457
                //saveCheckBox(); commented by Rajesh Narra on 6/22/2018
                if (Wid == null)
                {
                    System.Debug('inside CancelNull');
                    worecord.jobLocation__c=jobLocation;
                    insert worecord;
                    Wid = worecord.id;
                    //PageReference pageRef = new pageReference('/apex/CSS_JobIntake?id='+worecord.id);
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
                    system.debug('** '+workJob.Account__r.ERP_System__c);
                    if(workJob.Account__r.ERP_System__c == 'One BMS'){
                        cancelSJWrapperObj1 = CG_BL_Intake.cancel(workJob,worecord);
                        //Defect Fix 151641
                        if(cancelSJWrapperObj1!=null && cancelSJWrapperObj1.errorFlag == false){
                            system.debug('**noerrors');
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
                
                /*PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
pageRef.setRedirect(true);
return pageRef; */
            }
            else if(dsidIndi==null || dsidIndi==''){
                
                System.Debug('value of customer===='+workJob.customer_name__c);
                /*worecord.id=workJob.id;
update worecord;
System.Debug('inside CancelBlank====='+worecord);
PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
pageRef.setRedirect(true);
return pageRef;*/
                system.debug('** '+workJob.Account__r.ERP_System__c);
                if(workJob.Account__r.ERP_System__c == 'One BMS'){
                    cancelSJWrapperObj1 = CG_BL_Intake.cancel(workJob,worecord);
                    //Defect Fix 151641
                    if(cancelSJWrapperObj1!=null && cancelSJWrapperObj1.errorFlag == false){
                        system.debug('**noerrors');
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
            }else {
                system.debug('****did not enter any ifelse***');    
                
            } 
            //saveCheckBox(); //Commented as per the story 190513
        }
        // Story - 67555 DS Read Only - end
        
        /*PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
pageRef.setRedirect(true);
return pageRef;*/
        //return null;
    }  
    /*Job cancel defect fix code end */
    /* Save the Job Order then redirect to job intake page in view format*/
    
    public PageReference pgCustSave()
    {
        //moulika-start
        if(higherdateErrFlag == true)
        {
            warrantyDate = null;
        }
        //moulika-end
        css_job_order__c woCust= new css_job_order__c();
        
        woCust.Customer_Name__c=workJob.Customer_Name__c;
        woCust.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
        woCust.CSS_Hours__c=workJob.CSS_Hours__c;
        woCust.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
        woCust.Warranty_Start_Date__c=workJob.Warranty_Start_Date__c;//Defect 78458
        woCust.id=workJob.id;
        
        woCust.Customer_Code__c = workJob.Customer_Code__c;
        woCust.Phone_Number__c = workJob.Phone_Number__c;
        woCust.First_Name__c = workJob.First_Name__c;
        woCust.BMS_Last_Name__c = workJob.BMS_Last_Name__c;
        woCust.Cstmr_Contacts_Phone__c = workJob.Cstmr_Contacts_Phone__c;
        woCust.Address__c = workJob.Address__c;
        woCust.City__c = workJob.City__c;
        woCust.CSS_State__c = workJob.CSS_State__c;
        woCust.ZipCode__c = workJob.ZipCode__c;
        woCust.Primary_Segment__c = workJob.Primary_Segment__c;
        woCust.Country__c = workJob.Country__c;
        woCust.CSS_Charge_Account_Status__c = workJob.CSS_Charge_Account_Status__c;
        woCust.Contact_ID__c = workJob.Contact_ID__c;
        woCust.Email_Address__c = workJob.Email_Address__c;
        woCust.Email_check_box__c = workJob.Email_check_box__c;
        if(workJob.Email_check_box__c==true){
            woCust.Email_Address__c='declined@cummins.com';
        }   
        else{
            if(EmailAddress == null)
                EmailAddress = '';
            if(EmailAddress1 == null)
                EmailAddress1 = '';    
            if((EmailAddress == null || EmailAddress == '') && (EmailAddress1 == null || EmailAddress1 == ''))
                woCust.Email_Address__c='';
            else
                woCust.Email_Address__c=EmailAddress+'@'+EmailAddress1;
        }
        update woCust;
        PageReference pageRef12 = new pageReference('/apex/CSS_JobRepairRj?id='+Wid); 
        pageRef12.setRedirect(true);
        return pageRef12;
    } 
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Miles',system.Label.css_Miles));
        options.add(new SelectOption('Kilometers',system.Label.CSS_Kilometers));
        //options.add(new SelectOption('Hours',system.Label.css_hours)); 
        return options;
    }
    
    public String getmil_measure() 
    {
        return mil_measure;
    }
    public void setmil_measure(String mmeasure) 
    {
        this.mil_measure = mmeasure; 
    }
    
    public PageReference pgSave()
    {
        System.Debug('in intake_cu==============');
        css_job_order__c worecord= new css_job_order__c();
        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {
            worecord.SPDataWebserviceResult__c=workJob.SPDataWebserviceResult__c;
            worecord.PSN_PACCAR_Flag__c = workJob.PSN_PACCAR_Flag__c;
            worecord.Automotive_App_Flag__c = workJob.Automotive_App_Flag__c;
            worecord.Location_Certification__c=workjob.Location_Certification__c;
            worecord.Assigned_To__c = workJob.Assigned_To__c;
            worecord.Additional_Tech1__c=workJob.Additional_Tech1__c;
            worecord.Additional_Tech2__c=workJob.Additional_Tech2__c;
            worecord.Customer_Name__c=workJob.Customer_Name__c;
            worecord.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
            worecord.Application_Desc__c = filterApplication;
            worecord.Unit_number__c = workJob.Unit_number__c;
            worecord.ESN__c = workJob.ESN__c;
            worecord.Qsol_Engine_Family_Code__c = workjob.Qsol_Engine_Family_Code__c;
            worecord.Mileage__c = workJob.Mileage__c;
            worecord.CSS_Hours__c = workJob.CSS_Hours__c;
            worecord.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
            worecord.General_Symptoms__c=workJob.General_Symptoms__c;
            worecord.Category_Desc__c = filterCategory;
            worecord.Category2_Desc__c = filterCategory2;
            worecord.Category3_Desc__c = filterCategory3;
            worecord.Category4_Desc__c = filterCategory4;
            worecord.Category5_Desc__c = filterCategory5;
            worecord.Complaint_Type_Desc__c = filterComplaintType;
            worecord.Complaint_Type2_Desc__c = filterComplaintType2;
            worecord.Complaint_Type3_Desc__c = filterComplaintType3;
            worecord.Complaint_Type4_Desc__c = filterComplaintType4;
            worecord.Complaint_Type5_Desc__c = filterComplaintType5;
            /* worecord.Category2_Desc__c=workJob.Category2__c;
worecord.Complaint_Type2__c=workJob.Complaint_Type2__c;
worecord.Category3__c=workJob.Category3__c;
worecord.Complaint_Type3__c=workJob.Complaint_Type3__c;
worecord.Category4__c=workJob.Category4__c;
worecord.Complaint_Type4__c=workJob.Complaint_Type4__c;
worecord.Category5__c=workJob.Category5__c;
worecord.Complaint_Type5__c=workJob.Complaint_Type5__c;*/
            worecord.Preventive_Maintenance__c=workJob.Preventive_Maintenance__c;
            worecord.Expedited_Service__c=workJob.Expedited_Service__c;
            //worecord.Complaint_Type__c = workJob.Complaint_Type__c;
            worecord.Unit_Type__c=workJob.Unit_Type__c;
            worecord.Sub_Type__c=filterSubType;
            worecord.Make__c = filterMake;
            worecord.Model__c = filterModel;
            worecord.License_Plate__c = workJob.License_Plate__c;
            worecord.Mileage_Measure__c = mil_measure;
            if(workJob.Failure_Date__c != null && workJob.Failure_Date__c > system.today()){ //Added for defect number 188494 
                worecord.Failure_Date__c = system.today();
            }else{
                worecord.Failure_Date__c=workJob.Failure_Date__c;
            }
            worecord.Failure_Point__c = workJob.Failure_Point__c;
            worecord.Failure_Point_Measure__c = fail_measure;
            worecord.Warranty_Start_Date__c = workJob.Warranty_Start_Date__c;//Defect 78458
            worecord.VIN__c = workJob.VIN__c;
            worecord.VIN_Flag__c = workJob.VIN_Flag__c;
            worecord.Actual_Technician_Time__c = workJob.Actual_Technician_Time__c;
            //start Code added by roopa for story 109319
            worecord.Customer_Code__c = workJob.Customer_Code__c;
            worecord.Phone_Number__c = workJob.Phone_Number__c;
            worecord.First_Name__c = workJob.First_Name__c;
            worecord.BMS_Last_Name__c = workJob.BMS_Last_Name__c;
            worecord.Cstmr_Contacts_Phone__c = workJob.Cstmr_Contacts_Phone__c;
            worecord.Address__c = workJob.Address__c;
            worecord.City__c = workJob.City__c;
            worecord.CSS_State__c = workJob.CSS_State__c;
            worecord.ZipCode__c = workJob.ZipCode__c;
            worecord.Primary_Segment__c = workJob.Primary_Segment__c;
            worecord.Country__c = workJob.Country__c;
            worecord.CSS_Charge_Account_Status__c = workJob.CSS_Charge_Account_Status__c;
            worecord.Contact_ID__c = workJob.Contact_ID__c;
            worecord.Email_Address__c = workJob.Email_Address__c;
            worecord.Email_check_box__c = workJob.Email_check_box__c;
            /*story 183077*/
             if((workJob.DSID__c==null || workJob.DSID__c=='' || string.isBlank(workJob.DSID__c) )&& PSNFlag!=null)
            worecord.Get_Engine_data_flag__c=PSNFlag;
          /* end */
            if(workJob.Email_check_box__c==true){
                worecord.Email_Address__c='declined@cummins.com';
            }   
            else{
                if(EmailAddress == null)
                    EmailAddress = '';
                if(EmailAddress1 == null)
                    EmailAddress1 = '';    
                if((EmailAddress == null || EmailAddress == '') && (EmailAddress1 == null || EmailAddress1 == ''))
                    worecord.Email_Address__c='';
                else
                    worecord.Email_Address__c=EmailAddress+'@'+EmailAddress1;
            }
            
            //end Code added by roopa for story 109319
            // Defect fix 59457
            //saveCheckBox(); //Commented as per the story 190513
            
            if (Wid != null)
            {
                System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                if(workjob.warranty_start_date__c != null){
                    worecord.before_in_service__c = false;
                }else{worecord.before_in_service__c = true;}
                update worecord;
                System.Debug('record updated====='+worecord);
            }
            //  return null;
        }
        
        //   PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl().substringBefore('?')+'?id='+Wid); 
        PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl());  //   Defetc fix  89415
        ReturnPage.setRedirect(true);
        return ReturnPage; 
        //return null;
        
    } 
    
    public PageReference pgSaveFinish()
    {
        System.Debug('in pgSaveFinish==============');
        css_dsidclose dscls = new css_dsidclose();
        css_job_order__c worecord= new css_job_order__c();
        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        else
        {
            /* if(bmsEnabled==true){
system.debug('Inside else statement');
callCreateWoAndUpdateComment();
} */
            worecord.Location_Certification__c=workjob.Location_Certification__c;
            worecord.Assigned_To__c = workJob.Assigned_To__c;
            worecord.Additional_Tech1__c=workJob.Additional_Tech1__c;
            worecord.Additional_Tech2__c=workJob.Additional_Tech2__c;
            worecord.Customer_Name__c=workJob.Customer_Name__c;
            worecord.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
            worecord.Application_Desc__c = filterApplication;
            worecord.Unit_number__c = workJob.Unit_number__c;
            worecord.ESN__c = workJob.ESN__c;
            worecord.Mileage__c = workJob.Mileage__c;
            worecord.CSS_Hours__c = workJob.CSS_Hours__c;
            worecord.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
            worecord.Qsol_Engine_Family_Code__c = workjob.Qsol_Engine_Family_Code__c;
            worecord.Make__c = filterMake;
            worecord.Model__c = filterModel;            
            worecord.Mileage_Measure__c = mil_measure;
            if(workJob.Failure_Date__c != null && workJob.Failure_Date__c > system.today()){
               workJob.Failure_Date__c = system.today();
            }else{
               worecord.Failure_Date__c=workJob.Failure_Date__c;
            }
            worecord.Failure_Point__c = workJob.Failure_Point__c;
            worecord.css_resolution__c = workjob.css_resolution__c;
            worecord.CSS_Feedback_Comments__c = workjob.CSS_Feedback_Comments__c;
            worecord.DSID__c = workjob.DSID__c;
            worecord.Failure_Point_Measure__c = fail_measure;
            worecord.Category_Desc__c = filterCategory;
            worecord.Category2_Desc__c = filterCategory2;
            worecord.Category3_Desc__c = filterCategory3;
            worecord.Category4_Desc__c = filterCategory4;
            worecord.Category5_Desc__c = filterCategory5;
            worecord.Complaint_Type_Desc__c = filterComplaintType;
            worecord.Complaint_Type2_Desc__c = filterComplaintType2;
            worecord.Complaint_Type3_Desc__c = filterComplaintType3;
            worecord.Complaint_Type4_Desc__c = filterComplaintType4;
            worecord.Complaint_Type5_Desc__c = filterComplaintType5;
            //Story 97304 Ekta
            worecord.Actual_Technician_Time__c = workJob.Actual_Technician_Time__c;
            //worecord.Complaint_Type__c = workJob.Complaint_Type__c;
            /*worecord.Category2__c=workJob.Category2__c;
worecord.Complaint_Type2__c=workJob.Complaint_Type2__c;
worecord.Category3__c=workJob.Category3__c;
worecord.Complaint_Type3__c=workJob.Complaint_Type3__c;
worecord.Category4__c=workJob.Category4__c;
worecord.Complaint_Type4__c=workJob.Complaint_Type4__c;
worecord.Category5__c=workJob.Category5__c;
worecord.Complaint_Type5__c=workJob.Complaint_Type5__c;*/
            worecord.Unit_Type__c=workJob.Unit_Type__c;
            worecord.Sub_Type__c=filterSubType;
            worecord.Preventive_Maintenance__c=workJob.Preventive_Maintenance__c;
            worecord.Expedited_Service__c=workJob.Expedited_Service__c;
            worecord.General_Symptoms__c=workJob.General_Symptoms__c;
            worecord.Previous_Status__c=workJob.Status__c;
            worecord.Status__c='Closed';
            worecord.VIN__c = workJob.VIN__c;
            worecord.VIN_Flag__c = workJob.VIN_Flag__c;
              worecord.License_Plate__c = workJob.License_Plate__c;
            
            // Story - 67555 DS Read Only - start
            system.debug('checking the user'+dsidIndi);
            //if (Wid != null && dsidIndi != null && dsidIndi.containsIgnoreCase('O'))
            if(Wid!=null)
            { 
                // Defect fix 59457
                // Calling the web service in closeSession Method
                // dsidStatus = dscls.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                // if(dsidStatus) {worecord.DSID_Status__c='Closed';} 
                
                //saveCheckBox(); //Commented as per the story 190513
                
                System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                update worecord;
                System.Debug('record updated====='+worecord);
            }
            PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
            pageRef.setRedirect(true);
            return pageRef;
            /* else{
system.debug('read only user');
return null;
}*/
            // Story - 67555 DS Read Only - end  
        }
    }
    
    public List<css_job_order__c> getViewHistory()
    {
        List<css_job_order__c> woList =new List<css_job_order__c>();
        woList=[select id,name,Assigned_To__c from css_job_order__c where ESN__c = :workJob.ESN__c ];
        return woList;
    }
    
    public string ChkFieldBlank()
    {
        
        if ((workJob.Customer_Name__c == null) && (workJob.Shop_Work_Order__c == null) &&(filterApplication == null) && (workJob.Unit_number__c == null) && (workJob.Mileage__c == null)&& (workJob.CSS_Hours__c == null)&& (workJob.ESN__c== null) 
            && (workJob.General_Symptoms__c == null))
        {
            //  System.Debug('in BLANK==============');
            return 'BLANK';
        }
        else if ((workJob.Customer_Name__c == null || workJob.Customer_Name__c == '') || (filterApplication == null || filterApplication == ''))
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
    public void showRepairBlocks(boolean jo_stat,boolean vh_stat, boolean vi_stat, boolean ts_stat,boolean rj_stat)
    { 
        show_jo_pnl = jo_stat;
        show_vh_pnl = vh_stat;
        show_vi_pnl = vi_stat;
        show_ts_pnl = ts_stat;
        show_rj_pnl = rj_stat;
        
        if (jo_stat)
        {
            jo_btn_cls = 'chev_cu_img_active';
            vh_btn_cls = 'chev_vh_img_open';
            vi_btn_cls = 'chev_vi_img_disable';
            ts_btn_cls = 'chev_rmb_img_open';
            rj_btn_cls = 'chev_rj_img_open';
            
            jo_chv_sts = 'sactive';
            vh_chv_sts = 'sopen';
            vi_chv_sts = 'sdisable';
            ts_chv_sts = 'sopen';
            rj_chv_sts = 'sopen';
            
            jo_txt_sts =  'chev_text_active';
            vh_txt_sts =  'chev_text_open';
            vi_txt_sts =  'chev_text_disable';
            ts_txt_sts =  'chev_text_open';
            rj_txt_sts =  'chev_text_open';
            
            jo_txt_val = 'Customer';
            vh_txt_val = '';
            vi_txt_val = '';
            ts_txt_val = '';
            rj_txt_val = '';
        }
        else if (vh_stat)
        {
            jo_btn_cls = 'chev_cu_img_open';
            vh_btn_cls = 'chev_vh_img_active';
            vi_btn_cls = 'chev_vi_img_disable';
            ts_btn_cls = 'chev_rmb_img_open';
            rj_btn_cls = 'chev_rj_img_open';
            
            jo_chv_sts = 'sopen';
            vh_chv_sts = 'sactive';
            vi_chv_sts = 'sdisable';
            ts_chv_sts = 'sopen';
            rj_chv_sts = 'sopen';
            
            jo_txt_sts =  'chev_text_open';
            vh_txt_sts =  'chev_text_active';
            vi_txt_sts =  'chev_text_disable';
            ts_txt_sts =  'chev_text_open';
            rj_txt_sts =  'chev_text_open';
            
            jo_txt_val = '';
            vh_txt_val = 'History';
            vi_txt_val = '';
            ts_txt_val = '';
            rj_txt_val = '';
        }
        else if (vi_stat)
        {
            jo_btn_cls = 'chev_cu_img_open';
            vh_btn_cls = 'chev_vh_img_open';
            vi_btn_cls = 'chev_vi_img_disable';
            ts_btn_cls = 'chev_rmb_img_open';
            rj_btn_cls = 'chev_rj_img_open';
            
            jo_chv_sts = 'sopen';
            vh_chv_sts = 'sopen';
            vi_chv_sts = 'sdisable';
            ts_chv_sts = 'sopen';
            rj_chv_sts = 'sopen';
            
            jo_txt_sts =  'chev_text_open';
            vh_txt_sts =  'chev_text_open';
            vi_txt_sts =  'chev_text_disable';
            ts_txt_sts =  'chev_text_open';
            rj_txt_sts =  'chev_text_open';
            
            jo_txt_val = '';
            vh_txt_val = '';
            vi_txt_val = 'Inspect';
            ts_txt_val = '';
            rj_txt_val = '';
        }
        else if (ts_stat)
        {
            jo_btn_cls = 'chev_cu_img_open';
            vh_btn_cls = 'chev_vh_img_open';
            vi_btn_cls = 'chev_vi_img_disable';
            ts_btn_cls = 'chev_rmb_img_active';
            rj_btn_cls = 'chev_rj_img_open';
            
            jo_chv_sts = 'sopen';
            vh_chv_sts = 'sopen';
            vi_chv_sts = 'sdisable';
            ts_chv_sts = 'sactive';
            rj_chv_sts = 'sopen';
            
            jo_txt_sts =  'chev_text_open';
            vh_txt_sts =  'chev_text_open';
            vi_txt_sts =  'chev_text_disable';
            ts_txt_sts =  'chev_text_active';
            rj_txt_sts =  'chev_text_open';
            
            jo_txt_val = '';
            vh_txt_val = '';
            vi_txt_val = '';
            ts_txt_val = 'Diagnosis';
            rj_txt_val = '';
        }
        else if (rj_stat)
        {
            jo_btn_cls = 'chev_cu_img_open';
            vh_btn_cls = 'chev_vh_img_open';
            vi_btn_cls = 'chev_vi_img_disable';
            ts_btn_cls = 'chev_rmb_img_open';
            rj_btn_cls = 'chev_rj_img_active';
            
            jo_chv_sts = 'sopen';
            vh_chv_sts = 'sopen';
            vi_chv_sts = 'sdisable';
            ts_chv_sts = 'sopen';
            rj_chv_sts = 'sactive';
            
            jo_txt_sts =  'chev_text_open';
            vh_txt_sts =  'chev_text_open';
            vi_txt_sts =  'chev_text_disable';
            ts_txt_sts =  'chev_text_open';
            rj_txt_sts =  'chev_text_active';
            
            jo_txt_val = '';
            vh_txt_val = '';
            vi_txt_val = '';
            ts_txt_val = '';
            rj_txt_val = 'Review';
        }
        else
        {
            jo_btn_cls = 'chev_cu_img_active';
            vh_btn_cls = 'chev_vh_img_open';
            vi_btn_cls = 'chev_vi_img_disable';
            ts_btn_cls = 'chev_rmb_img_open';
            rj_btn_cls = 'chev_rj_img_open';
            
            jo_chv_sts = 'sactive';
            vh_chv_sts = 'sopen';
            vi_chv_sts = 'sdisable';
            ts_chv_sts = 'sopen';
            rj_chv_sts = 'sopen';
            
            jo_txt_sts =  'chev_text_active';
            vh_txt_sts =  'chev_text_open';
            vi_txt_sts =  'chev_text_disable';
            ts_txt_sts =  'chev_text_open';
            rj_txt_sts =  'chev_text_open';
            
            jo_txt_val = 'Customer';
            vh_txt_val = '';
            vi_txt_val = '';
            ts_txt_val = '';
            rj_txt_val = '';
        }
    }      
    /* Popup Code */
    public void showPopup() {
        //Defect fix - 65391
        if( workJob.DSID_WorkGroup__c != null && workJob.DSID__c!=null ){
            
            System.debug('call ExitDSID WebServicecalled ParamterinIFFFF>>>>>>>>>'+workJob.DSID_WorkGroup__c+''+workJob.DSID__c);
            System.debug('call getEXITDSID WebServicecalled>>>>>>>>>');
            // Story - 67555 DS Read Only - start
            system.debug('checkin user'+dsidIndi);
            if(dsidIndi != null && dsidIndi.containsIgnoreCase('O')){
                system.debug('checking owner'+dsidIndi);
                CSS_EDSAuthentication.exitDSID(workJob.DSID_WorkGroup__c,workJob.DSID__c);
            }
            // Story - 67555 DS Read Only - end  
        }
        displayPopup = true;
    }
    
    public void closePopup() {
        displayPopup = false;
    }
    //Commented by venkat for story 97472
    /*public void closeSubStatusPopup() {
Cache.Session.put('ShowSubStatuspopup2', 'false');       
}*/
    public PageReference redirectPopup()
    {    
        displayPopup = false;
        PageReference p=new Pagereference('/apex/CSS_Job_Detail?nto=HOME');
        p.setRedirect(true);
        return p;
    } 
    public void showPopup1() {
        system.debug ('Before:: inside ShowPopup1:' + displayPopup1);
        displayPopup1 = true;
        system.debug ('After:: inside ShowPopup1:' + displayPopup1);
    }
    
    public void closePopup1() {
        description1 ='';
        description2 ='';
        description3 ='';
        displayPopup1 = false;
        fileBody = null;
        fileBody2 = null;
        fileBody3 = null;
    }
    public void showPopup4() {
        displayPopup4 = true;
    }
    
    public void closePopup4() {
        displayPopup4 = false;
    } 
    public void showPopup5() {
        displayPopup5 = true;
        atthName='';
        system.debug(' attachment' +atthId);
        List<Attachment> edtAttach = new List<Attachment>([Select Id, Name, Description from attachment where id= :atthId]);
        description = edtAttach[0].Description;
        
        atthName = edtAttach[0].Name;
        system.debug('atthName***'+atthName);
    }
    
    public void closePopup5() {
        displayPopup5 = false;
    } 
    public void showPopup6() {
        displayPopup6 = true;
    }
    
    public void closePopup6() {
        displayPopup6 = false;
    } 
    
    /* Begin Code for the JOb Closure Story - 56604 */
    public css_job_order__c closeJob {get;set;}
    public Boolean displayClosePopup {get;set;}
    public boolean showResolution{get;set;}
    public boolean showResolutionWithRepair{get;set;}
    public boolean showRepairs{get;set;}
    public list<CSS_Solutions__c> solutions {get;set;}
    public List<CSS_Solutions__c> responseValues{get;set;}
    public Boolean nocamptsbtrps{get;set;}
    public boolean HHSPSMNFlg{get;set;}
    public boolean HHSPACCSFlg{get;set;}
    public List<selectOption> responseOptions{get;set;}
    public List<selectOption> resolutionOptions{get;set;}
    public boolean showRepairErrorMessage{get;set;}
    list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
    set<Id> solutionIds = new set<Id>();
    list<CSS_Solutions__c> outOfOrderSolList = new list<CSS_Solutions__c>();
    public string newQuoteStr{get;set;}
    public integer countquote{get;set;}
    public Boolean requiredBMSMessage {get;set;}
    public Boolean bmsUserCloseFlag=false;
    
    public void closeSession_close()
    {
        system.debug('inside method--->');
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        cancelSJWrapperObj1.errorFlag = false;
        cancelSJWrapperObj1.errorMessage = '';
        cancelSJWrapperObj1.serviceJob = workJob;
        displayClosePopup=false;
    }
    public List<CSS_Fault_Code__c> faultCodes;
    
    public date siebelWarrantyDate;
    public String siebelSMN;
    public string siebVIN;
    public string siebAppCode;
    
    public PageReference closeSession(){
        system.debug('in closeSession method...');
        PageReference pr = null;
        cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
        cancelSJWrapperObj1.errorFlag = false;
        cancelSJWrapperObj1.errorMessage = '';
        cancelSJWrapperObj1.serviceJob = workJob;
        // Defect fix - 75751
        try{
            //user u = css_utility.getUserAttributes(UserInfo.getUserId());
            CSS_EDSAuthentication.getEDSUpdateTnR(workJob.DSID__c, (String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'), workJob.Customer_Name__c, workJob.Make__c, workJob.Model__c, workJob.AccessCode__c, workJob.Equipment_ID__c, workJob.Mileage__c, workJob.Mileage_Measure__c, workJob.Unit_Number__c,workJob.ESN__c,workJob.Shop_Work_Order__c); 
            faultCodes = new List<CSS_Fault_Code__c>();
            AggregateResult[]  fc = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Wid];
            if(fc.size()>0){
                integer maxSeq = integer.valueOf(fc[0].get('maxSeq'));
                System.debug('One 6');
                faultCodes = [select Primary_Fault_Code__c, FaultCode__c,Name, Fault_Code_Type__c, Related_Fault_Code__c from CSS_Fault_Code__c 
                              where Job_Order__c=:Wid and Sequence__c=:maxSeq and FaultCode__c !=Null and (Fault_Code_Type__c='APD-P' OR Fault_Code_Type__c='APD-R' OR Fault_Code_Type__c='BPD')];
            }
            css_dsidclose dscl = new css_dsidclose();
            // if (Wid != null && dsidIndi != null && dsidIndi.containsIgnoreCase('O')){
            if(Wid!=null){
                closeJob = [Select id,DSID__c,(Select Id,Name, Case_Name__c,Out_Of_Order__c,Rank__c,Service_Job__c,Repair_response__c,Solution_Title__c ,
                                               Solution__c,Diagnostic_Response__c FROM CSS_Solutions__r where service_job__c=:Wid),
                            (Select id, name , performed__c, performed_review__c, Reviewed__c from CSS_CampTsbTrp__r where( job_order__C=:Wid and( performed_review__c=True and performed__c=False)))                    
                            from css_job_order__c where id=:Wid];
                resolutionOptions= new list<selectOption>();
                countquote = 0;
                AggregateResult[] quoteAgg;
                quoteAgg = [Select count(Id) countquote from CSS_Quote__c where Service_Job__c =:Wid ];
                countquote = integer.valueOf(quoteAgg[0].get('countquote'));
                //Fixed for non bms user
                if (bmsEnabled == true && (workJob.Customer_Code__c == null || workJob.Unit_Number__c== null || workJob.Shop_Work_Order__c == null || countquote==0)){
                    System.Debug('>>>>>Inside bmsFistFlag '+bmsUserCloseFlag);
                    bmsUserCloseFlag = true;
                }
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
                system.debug(closeJob.CSS_Solutions__r+'Inside close Method'+closeJob.CSS_CampTsbTrp__r);
                list<CSS_Solutions__c> successSols = new List<CSS_Solutions__c>();
                list<CSS_Solutions__c> noSolPostivelyVerified = new list<CSS_Solutions__c>();
                list<css_CampTsbTrp__c> tsbTrpToBePerformed = new list<css_CampTsbTrp__c>();
                for(CSS_CampTsbTrp__c camptsbtrps :closeJob.CSS_CampTsbTrp__r) {
                    if(camptsbtrps.performed_review__c && !camptsbtrps.performed__c){
                        tsbTrpToBePerformed.add(camptsbtrps);
                        showResolution = FALSE;
                        System.debug('CampTsbTrps'+tsbTrpToBePerformed);
                    }
                }
                if(tsbTrpToBePerformed.isEmpty())   {
                    System.debug('Entered 1st loop');
                    for(CSS_Solutions__c verfiedSols :closeJob.CSS_Solutions__r){
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
                    css_accessSrtCompOutTo_Eds updateEDS = new css_accessSrtCompOutTo_Eds(solutionIds,workjob.DSID__c);
                    /* Beginning code for Update EDS webservice */
                    if(closeJob.DSID__c!= null && !string.isBlank(closeJob.DSID__c)){
                        System.debug('entered if disd loop');
                        
                        //updateEDS.accessSRTs();
                        //updateEDS.solComponents();
                        //updateEDS.outOfOrder(outOfOrderSolList);
                        System.debug('11 exiting if disd loop');
                    }//end of If 
                    System.debug('after 11 exiting if disd loop');
                    /* Ending code for Update EDS webservice */
                    System.debug('successSols isEmpty>>:'+successSols.isEmpty()+' bmsUserCloseFlag>>:'+bmsUserCloseFlag);
                    if(!successSols.isEmpty() && bmsUserCloseFlag != true){
                        System.debug('22 successSols isEmpty>>:'+successSols.isEmpty()+' bmsUserCloseFlag>>:'+bmsUserCloseFlag);
                        updateEDS.accessSRTs();
                        updateEDS.solComponents();
                        updateEDS.outOfOrder(outOfOrderSolList);
                        updateEDS.insiteFaultCodes(faultCodes,workjob.DSID__c);
                        dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                        System.debug('before  pgSaveFinish');
                        pr = pgSaveFinish();
                        System.debug('after pgSaveFinish');
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
                
            }
            if(bmsEnabled==true){
                system.debug('Inside else statement');
                callCreateWoAndUpdateComment();
            } 
            //else{return null;}
            cancelSJWrapperObj1 = new CG_cancelServiceJobWrapper();
            cancelSJWrapperObj1.errorFlag= false;
            cancelSJWrapperObj1.errorMessage = '';
            
        }
        catch(exception e){
            
        }
        return pr;      
    } 
    public void jobClosePopup(){
        //if (Wid != null && dsidIndi != null && dsidIndi.containsIgnoreCase('O'))
        if(Wid!=null)
        {
            list<CSS_Solutions__c> postRepairList = new list<CSS_Solutions__c>();
            responseValues = new List<css_solutions__c>();
            System.debug('Solutions for the entire Job:-->'+closeJob.CSS_Solutions__r);
            if(workJob != null){
                System.debug('Solutions for the entire Job:-->'+workJob.CSS_Solutions__r);
                
                if(closeJob.CSS_CampTsbTrp__r == null || closeJob.CSS_CampTsbTrp__r.isEmpty()) {
                    nocamptsbtrps=false;
                    if(closeJob.CSS_Solutions__r == null || closeJob.CSS_Solutions__r.isEmpty()){
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
                            showResolution = TRUE;  
                        }
                        if(repairSolutions.isEmpty()){
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
                                showResolution = FALSE;
                                showRepairs = TRUE;                                                     
                            }
                            
                            if(noRepairList.isEmpty() && postRepairList.isEmpty()){
                                showResolution = TRUE;
                                showRepairs = FALSE;
                            }                        
                            
                        }
                    } }   
                else{
                    nocamptsbtrps= true;
                }            
            }
        }          
    }
    public void createQuote( string quoteStr){
        css_quote__c quote = new css_quote__c();
        quote.Service_Job__c = workJob.id;
        quote.OrderReference__c = workJob.Quote_ID__c;
        insert quote;        
    }
    PageReference pageRef;
    
    public PageReference saveAndCloseJob() //void to  PageReference switch is done by  Rajesh Narra on 01-25 -2019 defect number 169425
    {
        requiredBMSMessage =false;
        showResolutionRequired =false;//ROD Defect 179167 Added by Rajesh Narra                         
        showRepairRequired = false;//ROD Defect 179167 Added by Rajesh Narra 
        //showRepairErrorMessage = false;//ROD Defect 179167 Added by Rajesh Narra 
        system.debug('** BMS Enabled'+bmsEnabled);
        if ((bmsEnabled ==true)&&(workJob.Customer_Code__c==null || workJob.Unit_Number__c==null || workJob.Shop_Work_Order__c==null || workJob.Quote_ID__c =='')){
            requiredBMSMessage = TRUE;
            System.debug('Entered error');            
            //return null;
        }
        css_accessSrtCompOutTo_Eds updateEDS = new css_accessSrtCompOutTo_Eds(solutionIds,workjob.DSID__c);
        //if(dsidIndi != null && dsidIndi.containsIgnoreCase('O')){
        if(Wid!=null){
            System.debug('Entered Pg SaveFinish MEthod');
            css_dsidclose dscl = new css_dsidclose();
            
            System.debug('@@showRepairs'+showRepairs);
            System.debug('@@showResolutionWithRepair'+showResolutionWithRepair);
            if(showRepairs == null){
                showRepairs = FALSE;
            }
            if(showResolutionWithRepair == null || showResolutionWithRepair == TRUE  ){ // added showResolutionWithRepair == True
                showResolutionWithRepair = FALSE;
            }
            System.debug('@@showResolutionWithRepair1'+showResolutionWithRepair);
            System.debug('@@showRepairs'+showRepairs);
            if(showRepairs && !showResolutionWithRepair){
              
                list<CSS_Solutions__c> negatRepairs = new list<CSS_Solutions__c>();
                List<CSS_Solutions__c> negatPosRepairs = new List<CSS_Solutions__c>();
                if(!responseValues.isEmpty()){
                    for(CSS_Solutions__c solRec : responseValues){
                        if(solRec.Repair_Response__c != null && !solRec.Repair_Response__c.contains('Successful')){
                            System.debug('Entered neg if Loop:');
                            negatRepairs.add(solRec);
                        }else if(solRec.Repair_Response__c != null && solRec.Repair_Response__c.contains('Successful')){
                            negatPosRepairs.add(solRec);
                        }else if(solRec.Repair_Response__c == null){
                            //showRepairErrorMessage = TRUE; ROD Defect 179167 Added by Rajesh Narra 
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.error,'Please select repair response for the below solutions'));
                            //return null;
                        }
                    }//end of For
                    System.debug('B4 MEthod');
                    
                   /* if(!negatRepairs.isEmpty() && !responseValues.isEmpty() && negatRepairs.size() == responseValues.size()){
                        System.debug('Entered If Loop:');
                        
                        showResolutionWithRepair = TRUE;
                        //return null; 
                    }*/
                    
                     if(negatRepairs.isEmpty() && negatPosRepairs.isEmpty()){
                        showRepairRequired = false;//ROD Defect 179167 Added by Rajesh Narra 
                        showRepairErrorMessage = True;
                        cancelSJWrapperObj1.errorFlag=true;//ROD Defect 179167 Added by Rajesh Narra 
                    }else if(!negatRepairs.isEmpty() && !responseValues.isEmpty() && negatRepairs.size() != responseValues.size() && workJob.CSS_Resolution__c == null){
                        showRepairRequired = true;//ROD Defect 179167 Added by Rajesh Narra 
                        showRepairErrorMessage = false;
                        cancelSJWrapperObj1.errorFlag=true;//ROD Defect 179167 Added by Rajesh Narra 
                        showResolutionWithRepair=true;//ROD Defect 179167 Added by Rajesh Narra
                    }else if(!negatPosRepairs.isEmpty() && !responseValues.isEmpty() && negatPosRepairs.size() != responseValues.size() && workJob.CSS_Resolution__c == null){
                        showRepairRequired = true;//ROD Defect 179167 Added by Rajesh Narra 
                        showRepairErrorMessage = false;
                        cancelSJWrapperObj1.errorFlag=true;//ROD Defect 179167 Added by Rajesh Narra 
                        showResolutionWithRepair=true;//ROD Defect 179167 Added by Rajesh Narra 
                    }else{
                        System.debug('Entered else Loop with repairs:');
                        showResolutionWithRepair = FALSE;
                        if(requiredBMSMessage == TRUE){
                            showRepairErrorMessage = FALSE;
                         }
                        cancelSJWrapperObj1.errorFlag=false;//ROD Defect 179167 Added by Rajesh Narra 
                        updateEDS.accessSRTs();
                        updateEDS.solComponents();
                        updateEDS.outOfOrder(outOfOrderSolList);
                        updateEDS.insiteFaultCodes(faultCodes,workjob.DSID__c);
                        workJob.Status__c='Closed';
                        dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                        system.debug('****dsidStatus**+'+ dsidStatus);
                        if(dsidStatus !=null && dsidStatus) {
                            workJob.DSID_Status__c='Closed';
                        }
                        
                        //update workJob;
                        if(workJob.Quote_ID__c!=''){ // && showRepairErrorMessage !=TRUE 
                            createQuote(workJob.Quote_ID__c);
                            System.debug('Quote1');
                            System.debug('inside1stelse@@workJob.Quote_ID__c***'+workJob.Quote_ID__c+'***showRepairErrorMessage**'+showRepairErrorMessage);
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
                                if(requiredBMSMessage == false)
                                update workJob;
                            }
                        }
                        if(!responseValues.isEmpty() && requiredBMSMessage == false){ //ROD Defect 179167 Added by Rajesh Narra 
                            update responseValues;
                        }
                        if(requiredBMSMessage == false){
                            cancelSJWrapperObj1.errorFlag=false;// Added by Rajesh Narra
                            pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); // This code is uncommented by Rajesh Narra on 01-25 -2019 169425
                            pageRef.setRedirect(true); // This code is uncommented by Rajesh Narra on 01-25 -2019 169425
                        }else{
                            if(requiredBMSMessage == TRUE)
                                showRepairErrorMessage = TRUE;
                            cancelSJWrapperObj1.errorFlag=true;
                        }  
                    } 
                }
            }//end of If repairs
          
            if(!postRepairList.isEmpty()){
                system.debug('insode second if');
                showResolution = false;
                showRepairs = false;
                if(!showResolutionWithRepair || !showResolution){
                    if(workJob.CSS_Resolution__c != null){
                        workJob.Status__c='Closed';
                        updateEDS.accessSRTs();
                        updateEDS.solComponents();
                        updateEDS.outOfOrder(outOfOrderSolList);
                        updateEDS.insiteFaultCodes(faultCodes,workjob.DSID__c);
                        dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                        system.debug('****dsidStatus**+'+ dsidStatus);
                        if(dsidStatus !=null && dsidStatus) {
                            workJob.DSID_Status__c='Closed';
                        } 
                        //update workJob;
                        if(workJob.Quote_ID__c!='' && showRepairErrorMessage !=TRUE){
                            createQuote(workJob.Quote_ID__c);
                            System.debug('Quote2');
                            System.debug('insidethirdif@@workJob.Quote_ID__c***'+workJob.Quote_ID__c+'***showRepairErrorMessage**'+showRepairErrorMessage+'****accerpsystem***'+workJob.Account__r.ERP_System__c);
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
                        }
                        if(!responseValues.isEmpty()){
                            update responseValues;
                        }  
                        pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME');  // This code is uncommented by Rajesh Narra on 01-25 -2019 169425
                        pageRef.setRedirect(true); // This code is uncommented by Rajesh Narra on 01-25 -2019 169425
                        
                    }
                }    
            }
          
            
            if(!showResolutionWithRepair || !showResolution){
                system.debug('insode third if'); 
                system.debug('insode third if1'+workJob.CSS_Resolution__c);
                if(workJob.CSS_Resolution__c != null){ 
                    workJob.Status__c='Closed';
                    updateEDS.insiteFaultCodes(faultCodes,workjob.DSID__c);
                    updateEDS.accessSRTs();
                    updateEDS.solComponents();
                    updateEDS.outOfOrder(outOfOrderSolList);
                    dsidStatus = dscl.Closedsid(workJob.css_resolution__c,workjob.css_feedback_comments__c,workjob.DSID__c);
                    system.debug('****dsidStatus**+'+ dsidStatus);
                    if(dsidStatus !=null && dsidStatus) {
                        workJob.DSID_Status__c='Closed';
                    } 
                    /*//update workJob;
                    if(!responseValues.isEmpty()){
                    update responseValues;
                    } */
                    if(workJob.Quote_ID__c!='' && showRepairErrorMessage !=TRUE){
                        createQuote(workJob.Quote_ID__c);
                        System.debug('insidethirdif@@workJob.Quote_ID__c***'+workJob.Quote_ID__c+'***showRepairErrorMessage**'+showRepairErrorMessage+'****accerpsystem***'+workJob.Account__r.ERP_System__c);
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
                    }
                    /*pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME');  // This code is uncommented by Rajesh Narra on 01-25 -2019 169425
                    pageRef.setRedirect(true); // This code is uncommented by Rajesh Narra on 01-25 -2019 169425
                    update workJob;
                    if(!responseValues.isEmpty()){
                        update responseValues;
                    } */
                    if(requiredBMSMessage == false){
                        cancelSJWrapperObj1.errorFlag=false;// Added by Rajesh Narra
                        pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); // This code is uncommented by Roopa  178147
                        pageRef.setRedirect(true);// This code is uncommented by Roopa  178147
                    }else{
                        cancelSJWrapperObj1.errorFlag=true;
                    }
                }else{
                    showResolutionRequired=true;//Added by Rajesh Narra.                    
                    cancelSJWrapperObj1.errorFlag=true;//Added by Rajesh Narra.
                }
            }    
            System.Debug('requiredBMSMessage====='+requiredBMSMessage);
            System.Debug('record updated====='+workJob);            
            return pageRef; //Defect number 125589
        }else{
            return null; //Defect number 125589
            
        }  
    } 
    /* End of Code for the Job Closure Story - 56604 */
    
        /* End of Code for the Job Closure Story - 56604 */
    
    
    
    
    /* code added for tsps and trps  start*/
    //Transient  map<string,CSS_CampTsbTrp__c> qsolCTTPMap = new map<string,CSS_CampTsbTrp__c>(); //Defect fix 95870
    
    public List<CSS_CampTsbTrp__c> getALLRecords_old(){
        system.debug('in getALLRecords...accountlang>>>:'+accountlang);
        // system.debug('qsolCTTP'+qsolCTTP);
        // List<CSS_CampTsbTrp__c> CTT = new  List<CSS_CampTsbTrp__c>();
        //   List<CSS_CampTsbTrp__c> qsolCTTP;
        try{
            /* qsolCTTP = [select Type__c,URL__c,  Doc_Num__c, Doc_Title__c, Performed__c,Performed_Review__c,Reviewed__c from CSS_CampTsbTrp__c where Job_Order__c= :Wid AND Type__c != 'TSB' order by Type__c LIMIT 1000];
for(CSS_CampTsbTrp__c campRec : qsolCTTP){
system.debug('**Inside For Loop **');
qsolCTTPMap.put(campRec.Doc_Num__c,campRec);
if(qsolCampMap != null && !qsolCampMap.isEmpty()){
system.debug('qsolCampMap.get(campRec.Doc_Num__c).URL__c-->'+qsolCampMap.get(campRec.Doc_Num__c).URL__c);
if(qsolCampMap.get(campRec.Doc_Num__c) != null && qsolCampMap.get(campRec.Doc_Num__c).URL__c != null){
campRec.URL__c = qsolCampMap.get(campRec.Doc_Num__c).URL__c;
}
}
} */
            
            /***Modularized Code START *** Story# 118800*/
            User userObj;
            if(userObj == null){
                userObj = css_utility.getUserAttributes(Userinfo.getUserId());
            }
            accountlang = css_utility.getLanguage(userObj.LanguageLocaleKey);
            system.debug('accountlang**'+accountlang);
            lstALL = new List<CSS_CampTsbTrp__c>();
            
            /*List<CSS_CampTsbTrp__c> lstCAM = new List<CSS_CampTsbTrp__c>();
List<CSS_CampTsbTrp__c> lstTRP = new List<CSS_CampTsbTrp__c>();
List<CSS_CampTsbTrp__c> lstTSB = new List<CSS_CampTsbTrp__c>();
List<CSS_CampTsbTrp__c> lstATC = new List<CSS_CampTsbTrp__c>();
List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getSiebelQSOLCampaigns(workJob.Id, workJob.ESN__c, accountlang.CSS_QsolLanguage__c, workJob.Service_Model__c, workJob.Failure_Date__c);
if(campaignsList !=null && campaignsList.size()>=0)
lstCAM = campaignsList.get(0);
if(campaignsList !=null && campaignsList.size()>=1)
lstTSB = campaignsList.get(1);
if(campaignsList !=null && campaignsList.size()>=2)
lstTRP = campaignsList.get(2);
if(campaignsList !=null && campaignsList.size()>=3)
lstATC = campaignsList.get(3); */
            
            lstALL.addAll(lstCAM);
            lstALL.addAll(lstTRP);
            lstALL.addAll(lstATC);
            system.debug('in getALLRecords...lstALL>>>:'+lstALL);
            
        }
        catch(exception e){
            
        }
        //return qsolCTTP;
        return lstALL;
    }
    
    public List<CSS_Solution_Component__c> getALLRecords(){
        system.debug('in getALLRecords...accountlang>>>:'+accountlang);
        try{
            //new code start
            solCompCTTP = new List<CSS_Solution_Component__c>([select Id, Type__c,URL__c,  Component_Id__c, Campaign_Description__c, Performed__c,Performed_Review__c,Reviewed__c,Fail_Code__c,css_account_formula__c from CSS_Solution_Component__c where Service_Job__c= :Wid AND Type__c in('Campaign','TRP','ATC') and Status__c='Approved' and ((Complete_Indicator__c=true and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=true) OR (Complete_Indicator__c=false and Multiple_Times__c=false))  order by Type__c LIMIT 1000]);
            //Get QSOL Docs for existing ESN
            List<CSS_CampTsbTrp__c> lstQSOLDocs = new List<CSS_CampTsbTrp__c>([Select Id, Type__c, Job_Order__c,ESN__c, Doc_Num__c, 
                                                                               Doc_Title__c, URL__c, Reviewed__c,Performed__c,
                                                                               Performed_Review__c,Cu_Language__c from CSS_CampTsbTrp__c
                                                                               where Job_Order__c = :Wid and ESN__c = :workJob.ESN__c and Type__c !='TSB' 
                                                                               order by Performed_Review__c desc]);
            //add qsol links
            solCompCTTP = CG_BL_Intake.addQSOLLinksToSiebelQueryList(solCompCTTP, lstQSOLDocs);
            //new code end
        }catch(exception ex){
            System.debug('in catch of getALLRecords of css_repair_job >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return solCompCTTP;
    }
    
    
    public integer getCamps(){
        /*list<CSS_CampTsbTrp__c> qsol = new list<CSS_CampTsbTrp__c>();
system.debug('checkingcamp'+qsolCTTP);
if(qsolCTTP != null){
system.debug('checkingcamp');
for(CSS_CampTsbTrp__c qsolcam : qsolCTTP){
system.debug('checkingcamp'+qsolcam);
if(qsolcam.type__c.equalsIgnoreCase('CAM')){
qsol.add(qsolcam);
}
}
}
return qsol.size();*/
        
        if(lstCAM != null){
            return lstCAM.size();
        }else
            return 0;
    }
    public integer getTrps(){
        /*list<CSS_CampTsbTrp__c> qsol1 = new list<CSS_CampTsbTrp__c>();
system.debug('checking'+qsolCTTP);
if(qsolCTTP != null){
for(CSS_CampTsbTrp__c qsoltrp : qsolCTTP){
system.debug('checking the tsbs'+qsoltrp);
if(qsoltrp.type__c.equalsIgnoreCase('TRP')){
qsol1.add(qsoltrp);
}
}
}
return qsol1.size();*/
        
        if(lstTRP != null){
            return lstTRP.size();
        }else
            return 0;
    }
    
    public integer getAtcs(){
        /*list<CSS_CampTsbTrp__c> qsol2 = new list<CSS_CampTsbTrp__c>();
if(qsolCTTP != null){
for(CSS_CampTsbTrp__c qsolatc : qsolCTTP){
if(qsolatc.type__c.equalsIgnoreCase('ATC')){
qsol2.add(qsolatc);
}
}
}
return qsol2.size();*/
        
        if(lstATC != null){
            return lstATC.size();
        }else
            return 0;
    } 
    
    public integer getTsbs(){
        /*list<CSS_CampTsbTrp__c> qsol3 = new list<CSS_CampTsbTrp__c>();
system.debug('nooftsbs------>');
if(lstQSOLDocs != null){
system.debug('nooftsbs&&&&&');
for(CSS_CampTsbTrp__c qsoltsbs : lstQSOLDocs){
if(qsoltsbs.type__c.equalsIgnoreCase('TSB')){
qsol3.add(qsoltsbs);
system.debug('nooftsbs####@@@@@'+qsol3);
}
}
}
return qsol3.size();*/
        
        if(lstTSB != null){
            return lstTSB.size();
        }else
            return 0;
    }     
    /* code added for tsps and trps ended */
    
    public void saveCampNotesCheckBox(){
        mainSOQL();
        CampNotes();
        //saveCheckBox();  //Commented as per the story 190513  
    }
    
    
    /* Field Actions Popup show based on selection/unselection */
    public boolean showCampaignPopup{get;set;}
    public pageReference showFieldActionPopup(){
        showCampaignPopup = false;
        System.debug('inside showFieldActionPopup:'+solCompCTTP);
        //Saving Comments first
        if(comm !='' && comm !=null ){
            system.debug('JobID' +Wid);
            Note x = new Note();
            x.Title = 'CAMPCOMMENTS';
            x.ParentId = Wid;  
            x.Body = comm;

            insert x;
        }
        List<CSS_Solution_Component__c> solCompCampTRP = [select Selected_Claim_Type__c,Type__C,css_claims__r.Information_Only_Claim__c, Name,Component_Id__c,Fail_Code__c,Failure_Mode__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,Campaign_Start_Date__c,CampaignTravelPercentage__c,Service_Job__c,Performed__c,Performed_Review__c,Reviewed__c,URL__C,Approval_Code__c,AccountCodeEdit__c,Pay_Code__c,AccountCodeType__c,AccountCode__c,Selected_Component__c 
               from CSS_Solution_Component__c where Type__c in ('Campaign','TRP','ATC') and Service_Job__c =:Wid  and Status__c='Approved'];
        Map<String, Boolean> existingSelection = new Map<String, Boolean>();
        for(css_solution_component__c SolComp1: SolCompCampTRP){
             existingSelection.put(SolComp1.Component_Id__c, SolComp1.Performed_Review__c);
        }
        if(solCompCTTP != null && !solCompCTTP.isEmpty()){
                for(CSS_Solution_Component__c fcw : solCompCTTP){
                system.debug('fcw.SelectedComp--->'+fcw.Performed_Review__c);
                system.debug('inside if fcw.FieldActNum.'+fcw.Component_Id__c);
                /*if(fcw.Performed_Review__c == false){  
                    showCampaignPopup = true;
                    break;
                    system.debug('inside if showFieldActionPopup'+showCampaignPopup);
                }*/
                if(fcw.Performed_Review__c == false && existingSelection.containsKey(fcw.Component_Id__c) && existingSelection.get(fcw.Component_Id__c) == true){ //to find out unselected FieldActions which are selected previously
                    showCampaignPopup = true;
                    break;
                    system.debug('inside if showCampaignPopup'+showCampaignPopup);
                }
            }
    }
    if(showCampaignPopup)
        return null;
    else{
        saveCheckBoxComp_New();
    }
    
    PageReference ReturnPage = new PageReference('/apex/CSS_JobRepairRj?id='+Wid); 
        ReturnPage.setRedirect(true);
        return ReturnPage;
    }
    
    //Commented below method & written another method as saveCheckBoxComp_New as per story #190513
    /* public pagereference saveCheckBox(){
        try{
            if(comm.trim() !='' && comm.trim() !=null ){
                system.debug('JobID' +Wid);
                Note x = new Note();
                x.Title = 'CAMPCOMMENTS';
                x.ParentId = Wid;  
                x.Body = comm;
                insert x;
            }
            
            //new code start
            System.debug('before updating solCompCTTP>>>:'+solCompCTTP);
            if(solCompCTTP != null && !solCompCTTP.isEmpty()){
                update solCompCTTP;
                System.debug('after updating solCompCTTP>>>:'+solCompCTTP);
            }
            //new code end
            
        PageReference ReturnPage = new PageReference('/apex/CSS_JobRepairRj?id='+Wid); 
        ReturnPage.setRedirect(true);
        return ReturnPage;
            
        }catch(exception ex){
            System.debug('in catch of saveCheckBox of css_repair_job >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        return null;
    }*/
    
    public pageReference saveCheckBoxComp_New(){
        system.debug('inside saveCheckBoxComp_New in css_tnd_job');
        try{
        //Saving Comments first
        /*if(comm !='' && comm !=null ){
            system.debug('JobID' +Wid);
            Note x = new Note();
            x.Title = 'CAMPCOMMENTS';
            x.ParentId = Wid;  
            x.Body = comm;

            insert x;
        }*/
        
        List<CSS_Solution_Component__c> solCompCampTRP = [select Selected_Claim_Type__c,Type__C,css_claims__r.Information_Only_Claim__c, Name,Component_Id__c,Fail_Code__c,Failure_Mode__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,Campaign_Start_Date__c,CampaignTravelPercentage__c,Service_Job__c,Performed__c,Performed_Review__c,Reviewed__c,URL__C,Approval_Code__c,AccountCodeEdit__c,Pay_Code__c,AccountCodeType__c,AccountCode__c,Selected_Component__c 
                                      from CSS_Solution_Component__c where Type__c in ('Campaign','TRP','ATC') and Service_Job__c =:Wid  and Status__c='Approved'];
        Map<String, Boolean> existingSelection = new Map<String, Boolean>();
         for(css_solution_component__c SolComp1: SolCompCampTRP){
                    existingSelection.put(SolComp1.Component_Id__c, SolComp1.Performed_Review__c);
                }
                System.debug('ExistingsolCompCampTRP>>>:'+solCompCampTRP);
        System.debug('existingSelection>>>:'+existingSelection);
        if(solCompCTTP != null && !solCompCTTP.isEmpty()){
            //To delete associated line items of CAM/ATC/TRP & prepare delete lists -- #190513-Start
            Map<string,string> failAccCodeMap = new Map<string,string>();
            Set<String> nonSelFieldAction = new Set<String>();
            Set<String> SelFieldAction = new Set<String>();
            for(CSS_Solution_Component__c fcw : solCompCTTP){
                system.debug('fcw.SelectedComp--->'+fcw.Performed_Review__c);
                system.debug('inside if fcw.FieldActNum.'+fcw.Component_Id__c);
                if((fcw.Performed_Review__c == false && existingSelection.get(fcw.Component_Id__c)) 
                   || (fcw.Performed_Review__c == false && existingSelection.containsKey(fcw.Component_Id__c) && existingSelection.get(fcw.Component_Id__c) == false)){ //to find out unselected FieldActions which are selected previously
               // showCampaignPopup = true;
                    system.debug('inside if fcw.SelectedComp.'+fcw.Performed_Review__c);
                    failAccCodeMap.put(fcw.Fail_Code__c,fcw.css_account_formula__c);
                    nonSelFieldAction.add(fcw.Component_Id__c);
                    fcw.Selected_Component__c = false; // to keep it in sync with Performed_Review__c
                }
                else if(fcw.Performed_Review__c == true && existingSelection.containsKey(fcw.Component_Id__c) && existingSelection.get(fcw.Component_Id__c) == false){ //to find out selected FieldActions which are not selected previously
                    SelFieldAction.add(fcw.Component_Id__c); 
                    fcw.Selected_Component__c = true; // to keep it in sync with Performed_Review__c
                }
                else {
                    continue; //to ignore already selected & saved FieldActions for not retriggering FieldActionSRTs/Parts
                }
            }
            system.debug('failAccCodeMap**'+failAccCodeMap);
            system.debug('nonSelFieldAction**'+nonSelFieldAction);
            system.debug('SelFieldAction**'+SelFieldAction);
            
            List<css_srt__c> srtList = [Select id,Component_Id__c,Component_Id__r.Component_Id__c,FailCode__c, AccountCode_Formula__c from css_Srt__c where Job_Order__c = :Wid AND 
                                    (Type__c IN ('Admin','Field Action','Field Action Access','CAMPAIGN','TRP','ATC','99Time') OR SRT_Category__c IN ('CAMPAIGN','TRP','ATC'))];
            system.debug('srtList**'+srtList);
            
            List<css_srt__c> deletesrtList = new List<css_srt__c>();
            for(css_Srt__c srt:srtList){
                system.debug('Inside SRT ELSE**'+srt.FailCode__c);
                system.debug('Inside SRT ELSE1**'+srt.AccountCode_Formula__c);
                if(srt.FailCode__c != null && srt.FailCode__c != ''){
                    if((srt.AccountCode_Formula__c != null && srt.AccountCode_Formula__c != '') && (srt.FailCode__c != null && srt.FailCode__c != '') && failAccCodeMap.get(srt.FailCode__c) == srt.AccountCode_Formula__c)
                        deletesrtList.add(srt);
                    else if((srt.AccountCode_Formula__c == null || srt.AccountCode_Formula__c == '') && (failAccCodeMap.get(srt.FailCode__c) != null && failAccCodeMap.get(srt.FailCode__c) != ''))
                        deletesrtList.add(srt);
                }
                else{
                    if(nonSelFieldAction.contains(srt.Component_Id__r.Component_Id__c)){
                        deletesrtList.add(srt);
                    }
                }
            }
            system.debug('deletesrtList'+deletesrtList);
            //query for associated Parts
            List<CSS_Parts_Options__c> partsList = [select id,Fail_Code__c,FailurepartId__c,Get_Fail_Code_Formula__c,Account_Code__c,recordtype.name,Parts_Type__c from CSS_Parts_Options__c
                                                    where Service_Job__c = :Wid AND ((recordtype.name = 'Parts' AND parts_type__c = 'Custom') OR (recordtype.name = 'Parts' AND FailurepartId__r.type__c IN ('CAMPAIGN','TRP','ATC')) OR recordtype.name IN('OtherClaimables','TTML'))];
            system.debug('partsList**'+partsList);
            List<CSS_Parts_Options__c> deletepartsList = new List<CSS_Parts_Options__c>();
            for(CSS_Parts_Options__c part: partsList){
                system.debug('Inside ELSE**'+part.Get_Fail_Code_Formula__c);
                system.debug('Inside ELSE1**'+part.Account_Code__c);
                if((part.Get_Fail_Code_Formula__c != null && part.Get_Fail_Code_Formula__c != '') && (part.Account_Code__c != null && part.Account_Code__c != '') && failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) == part.Account_Code__c ){
                    system.debug('Inside SET**');
                    deletepartsList.add(part);
                }
                //else if((part.Get_Fail_Code_Formula__c != null && part.Get_Fail_Code_Formula__c != '') && (part.Account_Code__c == null || part.Account_Code__c == '') && (failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != null && failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != '') )
                else if((part.Get_Fail_Code_Formula__c != null && part.Get_Fail_Code_Formula__c != '') && (part.Account_Code__c == null || part.Account_Code__c == '' || part.Account_Code__c == 'Select One') && (failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != null && failAccCodeMap.get(part.Get_Fail_Code_Formula__c.Right(6)) != '') )  //Task 191433
                deletepartsList.add(part);
            }
            system.debug('deletepartsList'+deletepartsList);
        
            //CG_OP_OAGWrapper ReselectResp = new CG_OP_OAGWrapper();
                if(SelFieldAction != null && SelFieldAction.size()>0){
                    String FailureDateString = DateTime.newInstance(workJob.Failure_Date__c.year(),workJob.Failure_Date__c.month(),workJob.Failure_Date__c.day()).format('dd-MMM-YY');
                        CG_BL_Campaigns.callGetCampaignsWebServiceforReselectonJob(workJob.esn__c, FailureDateString,'','', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty',workJob.id,SelFieldAction, nonSelFieldAction);
                    }
                
            //Update Field Actions then delete prepared line items lists
            update solCompCTTP;
            System.debug('after updating solCompCTTP>>>:'+solCompCTTP);
            
            //Deleting associated line items here
            if(deletesrtList != null && deletesrtList.size()>0)
                delete deletesrtList;
            if(deletepartsList != null && deletepartsList.size()>0)
                delete deletepartsList;
            //To delete associated line items of CAM/ATC/TRP & prepare delete lists -- #190513-End
        }
        
        }catch(exception ex){
            System.debug('in catch of saveCheckBox of css_repair_job >>>>>>>>>>>>>>>getLineNumber is ::'+ex.getLineNumber()+' Exception Message>>>is ::'+ex.getMessage());
        }
        //return null;
        PageReference ReturnPage = new PageReference('/apex/CSS_JobRepairRj?id='+Wid); 
        ReturnPage.setRedirect(true);
        return ReturnPage;
    }
    
    
    
    public PageReference processUpload() {
        system.debug('insideprocessUpload');
        try 
        {
            system.debug('insidecondattach');
            //Database.SaveResult attachmentResult = saveStandardAttachment(Wid);
            boolean attachmentResult = saveStandardAttachment(Wid);
            if (attachmentResult == false) {
                
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                           'Could not save attachment.'));            
                return null;
            } 
            else{
                fileBody = null;
                fileBody2 = null;
                fileBody3 = null;
                //closePopup1();
            }
            
        } catch (Exception e) {
            system.debug('Exception message in SaveStandard'+e.getMessage());
            system.debug('Exception line in SaveStandard'+e.getLineNumber());
            ApexPages.AddMessages(e);
            return null;
        }
        //PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl());
        
        
        
        pageReference ReturnPage = ApexPages.currentPage(); 
        Id id = ReturnPage.getParameters().get('Id');
        Id symid= ReturnPage.getParameters().get('symid');
        Id fcid= ReturnPage.getParameters().get('fcid');
        String rank= ReturnPage.getParameters().get('rank');
        
        
        ReturnPage.getParameters().clear();
        ReturnPage.getParameters().put('Id', id);
        ReturnPage.getParameters().put('fcid', fcid);
        ReturnPage.getParameters().put('rank', rank);
        ReturnPage.getParameters().put('symid', symid);
        
        // PageReference ReturnPage = new PageReference('/apex/CSS_JobRepair?id='+Wid); 
        //   PageReference ReturnPage = new PageReference(ApexPages.currentPage().getUrl().substringBefore('?')+'?id='+Wid); 
        ReturnPage.setRedirect(true);
        return ReturnPage; 
    }
    @TestVisible
    //Rajesh Code start for Audit trail
    private boolean saveStandardAttachment(Id parentId) 
    {
        boolean Success = false;
        //Database.SaveResult result;
        Database.SaveResult result1;
        Database.SaveResult result2;
        Database.SaveResult result3;
        Database.SaveResult resultHist1;
        Database.SaveResult resultHist2;
        Database.SaveResult resultHist3;
        
        if(fileBody != null || fileBody2 != null || fileBody3 != null )
        { 
            Attachment attachment = new Attachment();
            attachment.body = this.fileBody;
            attachment.name = this.fileName;
            attachment.description = description1;
            attachment.parentId = parentId; 
            
            Attachment attachment2 = new Attachment();
            attachment2.body = this.fileBody2;
            attachment2.name = this.fileName2;
            attachment2.description = description2;
            attachment2.parentId = parentId;
            
            Attachment attachment3 = new Attachment();
            attachment3.body = this.fileBody3;
            attachment3.name = this.fileName3;
            attachment3.description = description3;
            attachment3.parentId = parentId;
            
            CSS_JobHistory__c InsertHistRec = new CSS_JobHistory__c();
            InsertHistRec.CSS_Object_Name__c = 'Attachment';
            InsertHistRec.CSS_Field_Name__c = this.fileName;
            InsertHistRec.CSS_Old_Value__c = 'Added';
            InsertHistRec.CSS_New_Value__c = this.fileName;
            InsertHistRec.CSS_Job_Id__c =wid;
            
            CSS_JobHistory__c InsertHistRec2 = new CSS_JobHistory__c();
            InsertHistRec2.CSS_Object_Name__c = 'Attachment';
            InsertHistRec2.CSS_Field_Name__c = this.fileName;
            InsertHistRec2.CSS_Old_Value__c = 'Added';
            InsertHistRec2.CSS_New_Value__c = this.fileName2;
            InsertHistRec2.CSS_Job_Id__c =wid;
            
            CSS_JobHistory__c InsertHistRec3 = new CSS_JobHistory__c();
            InsertHistRec3.CSS_Object_Name__c = 'Attachment';
            InsertHistRec3.CSS_Field_Name__c = this.fileName;
            InsertHistRec3.CSS_Old_Value__c = 'Added';
            InsertHistRec3.CSS_New_Value__c = this.fileName3;
            InsertHistRec3.CSS_Job_Id__c =wid;
            
            if (fileBody != null)
            {
                result1 = Database.insert(attachment);
                resultHist1 = Database.insert(InsertHistRec);
                System.debug('result1--->'+result1);
                System.debug('resultHist1--->'+resultHist1);
            }
            if (fileBody2 != null)
            {
                result2 = Database.insert(attachment2);
                resultHist2 = Database.insert(InsertHistRec2);
                System.debug('resultHist2--->'+resultHist2);
            }
            if (fileBody3 != null)
            {
                result3 = Database.insert(attachment3);
                resultHist3 = Database.insert(InsertHistRec3);
                System.debug('resultHist3--->'+resultHist3);
            }
            if((fileBody != null && result1.isSuccess() == false) || (fileBody2 != null && result2.isSuccess() == false)
               || (fileBody3 != null && result3.isSuccess() == false ))
                Success = false;
            else
                Success = true;            
        } 
        return Success ;
    }
    //Rajesh Code End
    public PageReference popupSave()
    {
        System.Debug('in intake_cu==============');
        css_job_order__c worecord= new css_job_order__c();
        if ((filterApplication == null) && (workJob.Unit_number__c == null) && (workJob.Mileage__c == null)&& (workJob.CSS_Hours__c == null)&& (workJob.ESN__c== null))
        {
            return null;
        }
        else
        {
            worecord.Customer_Name__c=workJob.Customer_Name__c;
            worecord.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
            //      if(workJob.Date_in_Shop__c!=null)
            //    worecord.Date_In__c = datetime.newInstance(workJob.Date_in_Shop__c.year(), workJob.Date_in_Shop__c.month(),workJob.Date_in_Shop__c.day(),12,0,0);
            //   worecord.Date_in_Shop__c = workJob.Date_in_Shop__c;
            worecord.Application_Desc__c = filterApplication;
            worecord.Unit_number__c = workJob.Unit_number__c;
            worecord.ESN__c = workJob.ESN__c;
            worecord.Mileage__c = workJob.Mileage__c;
            worecord.CSS_Hours__c = workJob.CSS_Hours__c;
            worecord.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
            worecord.Unit_Type__c=workJob.Unit_Type__c;
            worecord.Sub_Type__c=filterSubType;
            worecord.Make__c = filterMake;
            worecord.Model__c = filterModel;            
            worecord.Mileage_Measure__c = mil_measure;
            worecord.Failure_Date__c=workJob.Failure_Date__c;
            worecord.Failure_Point__c = workJob.Failure_Point__c;
            worecord.Failure_Point_Measure__c = fail_measure;
            worecord.VIN__c = workJob.VIN__c;
            worecord.VIN_Flag__c = workJob.VIN_Flag__c;
            //     worecord.Service_Model__c = workJob.Service_Model__c;
            //     worecord.VIN__c = workJob.VIN__c;
            //     worecord.Warranty_Start_Date__c=workJob.Warranty_Start_Date__c;
            worecord.General_Symptoms__c=workJob.General_Symptoms__c;
            if (Wid == null)
            {
                insert worecord;
                Wid = worecord.id;
                PageReference pageRef = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
                pageRef.setRedirect(true);
                return pageRef;
            }
            else
            {
                System.Debug('value of customer===='+workJob.customer_name__c);
                worecord.id=workJob.id;
                update worecord;
                System.Debug('record inserted====='+worecord);
                return null;
            }
        }
    }
    public PageReference DeleteFile() 
    {
        try
        {
            Attachment attachment = new Attachment(parentid= Wid);
            delete jobAttach;
        }
        catch(Exception e){
            //handle error
        }
        return null;
    }
    public Boolean displayPopup7 {get;set;}
    public Id jobId{get;set;}
    private CSS_Job_Order__c Job_Order {get;set;} 
    public string sEngineFamilyCode {get; set;}
    public string equipmentId {get;set;}//added by Agassi for story 144598
    public void showPopup7() {
        
        displayPopup7 = true;
    }
    
    public void closePopup7() {
        displayPopup7 = false;
    } 
    
    
    
    public PageReference pgCompSave()
    {
        css_job_order__c woComp= new css_job_order__c();
        woComp.Category_Desc__c = filterCategory;
        woComp.Category2_Desc__c = filterCategory2;
        woComp.Category3_Desc__c = filterCategory3;
        woComp.Category4_Desc__c = filterCategory4;
        woComp.Category5_Desc__c = filterCategory5;
        woComp.Complaint_Type_Desc__c = filterComplaintType;
        woComp.Complaint_Type2_Desc__c = filterComplaintType2;
        woComp.Complaint_Type3_Desc__c = filterComplaintType3;
        woComp.Complaint_Type4_Desc__c = filterComplaintType4;
        woComp.Complaint_Type5_Desc__c = filterComplaintType5;
        woComp.License_Plate__c = licensePlate;
        //woComp.Complaint_Type__c = workJob.Complaint_Type__c;
        woComp.General_Symptoms__c=workJob.General_Symptoms__c;
        woComp.Preventive_Maintenance__c=workJob.Preventive_Maintenance__c;
        woComp.id=workJob.id;
        update woComp;
        PageReference pageRef12 = new pageReference('/apex/CSS_JobRepairRj?id='+Wid); 
        pageRef12.setRedirect(true);
        return pageRef12;
    }
    
    public PageReference pgUISave()
    {
        
        css_job_order__c woUI= new css_job_order__c();
        woUI.SPDataWebserviceResult__c=workJob.SPDataWebserviceResult__c;
        
        if (ChkFieldBlank() =='BLANK')
        {
            return null;
        }
        /*  if ((workJob.Application__c == null) && (workJob.Unit_number__c == null) && (workJob.Mileage__c == null)&& (workJob.ESN__c== null))
{
return null;
} */
        else
        {
            
             // karthik G added  below logic GSSC-333
       List<SelectOption> applicationlist = getApplication();
        String filterLabel;
        String appCode;
        system.debug('applicationlist'+ applicationlist);
        if(applicationlist != null){
            if(applicationlist.size()>0){
                for(SelectOption sopt: applicationlist){
                    if(sopt.getValue()==filterApplication){
                        filterLabel = sopt.getlabel();
                        break;
                    }
                }
            }
        }

        if(filterLabel != null){
            List<String> strList = new List<String>();
            strList = filterLabel.split('-');
            if(strList != null && strList.size() > 0)
                appCode = strList[0].trim();
        }
            
            
            woUI.ApplicationCode__c = appCode;
            system.debug('woUI.ApplicationCode__c'+woUI.ApplicationCode__c);
            if(woUI.ApplicationCode__c == '130' || woUI.ApplicationCode__c == '210' ||woUI.ApplicationCode__c == '220' || woUI.ApplicationCode__c == '310' || woUI.ApplicationCode__c =='320' || woUI.ApplicationCode__c =='410')
                    woUI.Automotive_App_Flag__c = 'Y';
                else
                    woUI.Automotive_App_Flag__c = 'N';
       // karthik G end  GSSC-333 
            //woUI.SPDataWebserviceResult__c=workJob.SPDataWebserviceResult__c;
            woUI.PSN_PACCAR_Flag__c = workJob.PSN_PACCAR_Flag__c;
            woUI.Application_Desc__c = filterApplication;
            woUI.Unit_number__c = workJob.Unit_number__c;
            woUI.ESN__c = workJob.ESN__c;
            woUI.Qsol_Engine_Family_Code__c = workjob.Qsol_Engine_Family_Code__c;
            woUI.CSS_Hours__c = workJob.CSS_Hours__c;
            woUI.Mileage__c = workJob.Mileage__c;
            woUI.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
            woUI.Mileage_Measure__c = mil_measure;
            woUI.License_Plate__c=licensePlate;
            woUI.Make__c = filterMake;
            woUI.Model__c = filterModel;
            if(workJob.Failure_Date__c != null && workJob.Failure_Date__c > system.today()){ //Added for defect number 188494 
                woUI.Failure_Date__c = system.today();
            }else{
                woUI.Failure_Date__c=workJob.Failure_Date__c;
            }
            woUI.Failure_Point__c = workJob.Failure_Point__c;
            woUI.Failure_Point_Measure__c = fail_measure;
            woUI.Unit_Type__c=workJob.Unit_Type__c;
            woUI.Sub_Type__c=filterSubType;
            woUI.VIN__c = workJob.VIN__c;            
            woUI.VIN_Flag__c = workJob.VIN_Flag__c;
            woUI.Warranty_Start_Date__c=workJob.Warranty_Start_Date__c;
            woUI.Service_Model__c = workJob.Service_Model__c;
            woUI.Location_Certification__c=workjob.Location_Certification__c;
            woUI.ProductApplicationDesp__c = workJob.ProductApplicationDesp__c;
            woUI.ProductApplicationCode__c = workJob.ProductApplicationCode__c;
            woUI.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
           /*Story183077*/
            if(PSNFlag!=null)
            woUI.Get_Engine_data_flag__c=PSNFlag;
            /*end*/
            //  woUI.VIN__c = workJob.VIN__c;
            //   woUI.Warranty_Start_Date__c=workJob.Warranty_Start_Date__c;
            woUI.id=workJob.id;
            woUI.ReconEngineFlag__c = workJob.ReconEngineFlag__c;
            woUI.CSS_In_Shop_Labor_Rate__c = workJob.CSS_In_Shop_Labor_Rate__c;
            if(workjob.warranty_start_date__c != null){
                woUI.before_in_service__c = false;
            }else{woUI.before_in_service__c = true;}
            system.debug('woUI.CSS_In_Shop_Labor_Rate__c'+woUI.CSS_In_Shop_Labor_Rate__c);
            update woUI;
            system.debug('woUI.CSS_In_Shop_Labor_Rate__c After update'+woUI.CSS_In_Shop_Labor_Rate__c);
            PageReference pageRef12 = new pageReference('/apex/CSS_JobRepairRj?id='+Wid); 
            pageRef12.setRedirect(true);
            return pageRef12;
            
        }
    }
    
    /*datetime insitetimestamp;
public datetime getInsiteTimeStamp(){
insitetimestamp = [select INSITE_UpdateTimeStamp__c from  CSS_Job_Order__c where id=:Wid ].INSITE_UpdateTimeStamp__c;
System.debug('The timestamp is>>>>'+insitetimestamp);
return insitetimestamp;
}*/
    datetime insitetimestamp;
    public string getInsiteTimeStamp(){
        string insitestamp;
        insitetimestamp = workJob.INSITE_UpdateTimeStamp__c;
        if (insitetimestamp !=null) {
            insitestamp=string.valueof(insitetimestamp.format('dd MMM yyyy - hh:mm a z'));
        }
        return insitestamp;
    }
    /* datetime insitetimestamp;
public string getInsiteTimeStamp(){
string insitestamp;
insitetimestamp = [select INSITE_UpdateTimeStamp__c from  CSS_Job_Order__c where id=:Wid ].INSITE_UpdateTimeStamp__c;
if(insitetimestamp!=null){
insitestamp=string.valueof(insitetimestamp.format('dd MMM yyyy - hh:mm a z'));
}
return insitestamp;
}*/
    public integer getRepair(){
        AggregateResult[] repair;
        //Added Repair Response condition for defect 63663
        repair = [Select count(Case_Name__c) countRepair from CSS_Solutions__c where Service_Job__c=:Wid and Case_Name__c!=Null and (Not Name like 'a0%')
                  and Repair_Response__c in ('Repair Successful.','Repair Successful with additional parts/procedures.')];
        integer repairCount = integer.valueOf(repair[0].get('countRepair'));
        System.debug('The solutions is>>>>>>>>!!!!!!'+repairCount);
        return repairCount;
    }
    /* public string getDSID(){
string dsid;
dsid = [select DSID__c from  CSS_Job_Order__c where id=:Wid].DSID__c;
return dsid;
}*/
    /* public List<CSS_Fault_Code__c> getFaultCodes()
{
List<CSS_Fault_Code__c> faultCodes;
AggregateResult[]  fc = [Select max(Sequence__c) maxSeq from CSS_Fault_Code__c where Job_Order__c=:Wid];
if(fc.size()>0){
integer maxSeq = integer.valueOf(fc[0].get('maxSeq'));
faultCodes = [select Primary_Fault_Code__c, FaultCode__c, Fault_Code_Type__c, Related_Fault_Code__c from CSS_Fault_Code__c 
where Job_Order__c=:Wid and Sequence__c=:maxSeq and FaultCode__c !=Null and (Fault_Code_Type__c='APD-P' OR Fault_Code_Type__c='APD-R' OR Fault_Code_Type__c='BPD')];
for ( CSS_Fault_Code__c prCodes: faultCodes) {
if (prCodes.Fault_Code_Type__c.startsWith('APD')) {
isPrioritized = true;
} else if (prCodes.Fault_Code_Type__c.startsWith('BPD')){
isPrioritized = true;
}
else {
isPrioritized = false;
}
}
}
return faultCodes;     
}*/ 
    
    @TestVisible private Date parseQSOLDate(String myDate) {
    
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
    
    /** To make a call on change of esn; HHP Story ***/
    /*  public void  startRequest() {
try{
siebelWarrantyDate=null;
workJob.VIN__c = '';
if (workJob.ESN__c =='' || workJob.ESN__c ==null){
workjob.Service_Model__c = '';
workjob.VIN__c = '';
workjob.Warranty_Start_Date__c =null;
workjob.Location_Certification__c='';
workjob.Application_Desc__c='';
workJob.VIN_Flag__c = false;
showOutageError1= false;
//workjob.Before_In_Service__c = true;
//workJob.Make__C = '--None--';
//workJob.Model__c = '--None--';
//workJob.Qsol_Engine_Family_Code__c = '';
sEngineFamilyCode='';
filterMake = '';
filterModel = '';
//workJob.Make__C = null;
//workJob.Model__c = null;
} else {
//added for ROD Defect 111715 & 111716 by Venkat
if(workJob.ESN__c.isNumeric())
{
recconFlag = css_utility.getReconEngine(decimal.valueof(workJob.ESN__c));
}
else
recconFlag = false;
showOutageError1 = false;
if(recconFlag == true){
showOutageError1= true;
}
else
showOutageError1= false;
// On change of ESN, replacing BMS Unit Inbound status UI0 to Blank
if(workJob.BMSStatus__c !=null && workJob.BMSStatus__c.trim() !='')
workJob.BMSStatus__c = workJob.BMSStatus__c.replace('UI0','');
CSS_quickserveCumminsComWebservices.ModelName rDataPlate = new CSS_quickserveCumminsComWebservices.ModelName();                                
CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc rQSOLDocs = new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
List<CSS_quickserveCumminsComWebservices.WarrantyDoc> wCAMTSBTRB = new List<CSS_quickserveCumminsComWebservices.WarrantyDoc>();                
string sQSOLConn;
if(!Test.isRunningTest()){
sQSOLConn = CSS_getConnnectionDetails.getConnection('QSOL').Key__c;
}
else{
sQSOLConn = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
}

//Get Dataplate information from QSOL based on ESN
CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wsCall = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
rDataPlate = wsCall.getEngineDataplate(sQSOLConn, workJob.ESN__c);
system.debug('rDataPlate>>>'+rDataPlate);
//Calling SiebelWS to get data 63173-Start

CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
CSS_getEngineDataResponseJ2A  engineData;
CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
jidi.ESN=workJob.ESN__c;
wrapobj.DataArea = jidi;
engineData = CSS_WS_SBL.getEngineData(wrapobj);
system.debug('engineData>>>>'+engineData);
if (engineData.DataArea != null && engineData.Header.Status.contains('Success')){
if ( string.valueOf(engineData.DataArea.ProdAppDesc)!='' )
siebAppCode = css_utility.getCodes('Application Code',string.valueOf(engineData.DataArea.ProdAppDesc),null,null);
if( siebAppCode !='' || siebAppCode!=null){   
system.debug('siebelApp'+string.valueOf(engineData.DataArea.ProdAppDesc));
//added below snippet to default returned value to Application picklist if it's already there if not don't add/default(bms users) - Vignesh
//Defect 108199
//List<SelectOption> applicationPL = getApplicationCodes();
List<SelectOption> applicationPL = getApplication();
Set<String> listOfApplication = new Set<String>();
for(SelectOption sOption : applicationPL) {
listOfApplication.add(sOption.getValue());
}
if(bmsEnabled==TRUE){
if(listOfApplication.contains(string.valueOf(engineData.DataArea.ProdAppDesc)))
//Defect 108199
// workJob.Application_Desc__c= engineData.DataArea.ProdAppDesc;
filterApplication= string.valueOf(engineData.DataArea.ProdAppDesc);
}
else
//Defect 108199
// workJob.Application_Desc__c= engineData.DataArea.ProdAppDesc;
filterApplication= string.valueOf(engineData.DataArea.ProdAppDesc);
}
if ( string.valueOf(engineData.DataArea.ServiceModelName)!=''  )
siebelSMN= engineData.DataArea.ServiceModelName;

if (string.valueOf(engineData.DataArea.WarrantyStartDate)!='')               
siebelWarrantyDate = date.valueOf(string.valueOf(engineData.DataArea.WarrantyStartDate));

if ( callStartRequestFromBMSPopup != true && string.valueOf(engineData.DataArea.Manufacturer)!=''){
filterMake= engineData.DataArea.Manufacturer;
//Chking if Make exists in CSS
filterMake = css_utility.getMake(filterMake);
}else{
if(callStartRequestFromBMSPopup != true)
filterMake = '';
}

if (callStartRequestFromBMSPopup != true && string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){
filterModel= engineData.DataArea.Model;
//chking if Model exists
filterModel = css_utility.getModel(filterMake,filterModel);
}else{
if(callStartRequestFromBMSPopup != true)
filterModel = '';
}
if (string.valueOf(engineData.DataArea.vin)!='' && string.valueOf(engineData.DataArea.vin) !='' ){
siebVIN = string.valueOf(engineData.DataArea.vin);
}
}
else{
if(callStartRequestFromBMSPopup != true){
filterMake = '';
filterModel = '';
}
} 
//Calling SiebelWS to get data 63173-End


if ((sServiceModel =='' || sServiceModel==null) && (siebelSMN!='' && siebelSMN!= null)){                    
sServiceModel = siebelSMN;
}
if(sServiceModel =='' || sServiceModel==null)
{
sServiceModel = rDataPlate.servicemodel;
}
workjob.Service_Model__c = sServiceModel;
sServiceModel = rDataPlate.servicemodel;
if(rDataPlate.technicalConfig != null){
sEngineFamilyCode = rDataPlate.technicalConfig.substring(1,3);
workjob.Qsol_Engine_Family_Code__c = sEngineFamilyCode;
}
System.debug('QSOL retrived EngineFamilyCode in Repair>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+sEngineFamilyCode);

if(string.valueof(siebelWarrantyDate)!='' && string.valueof(siebelWarrantyDate)!= null){
workjob.Warranty_Start_Date__c=siebelWarrantyDate;
system.debug('Checking siebel warranty'+workjob.Warranty_Start_Date__c+siebelWarrantyDate);     
workjob.Before_In_Service__c = false;
}
else if (rDataPlate.warrantyStart != null && rDataPlate.warrantyStart != '') {
workjob.Warranty_Start_Date__c  = parseQSOLDate(rDataPlate.warrantyStart);
system.debug('Checking dataplate warranty'+workjob.Warranty_Start_Date__c+parseQSOLDate(rDataPlate.warrantyStart));
workjob.Before_In_Service__c =  false;      
}else{      
system.debug('Checking before in service');     
workjob.Warranty_Start_Date__c = null;      
//workjob.Before_In_Service__c = true;
}
workjob.VIN__c = rDataPlate.vin;
if(rDataPlate.vin!= '' || rDataPlate.vin!=null){
//workjob.VIN__c = rDataPlate.vin;
workjob.VIN_Flag__c=false;
}
if((rDataPlate.vin == '' || rDataPlate.vin == null) && (siebVIN!='' && siebVIN!=null)){
workjob.VIN__c = siebVIN;
workjob.VIN_Flag__c=false;
}
if((workJob.ESN__c!='' && workJob.ESN__c!= null) && (rDataPlate.vin == '' || siebVIN == null)) // Sai:4/11/2017: Added this for CUBS Story # 88616
{    
workjob.VIN_Flag__c = true;
workjob.VIN__c = '';
}
if ( filterMake !='' && filterMake != null){
workjob.Make__c = filterMake;                  
}
if ( filterModel != '' && filterModel!= null){
workjob.Model__c=filterModel;
}
System.debug('sServiceModel: '+sServiceModel);
if(sServiceModel != null && sServiceModel != ''){
Set<String> hhpSet = new Set<String>();
for(CSS_Listof_HHP_SMNS__c hhp: CSS_Listof_HHP_SMNS__c.getAll().Values()){
hhpSet.add(hhp.Listof_HHP_SMN__c);
}
//Id userId = UserInfo.getUserId();
//User user = [select Product_Group_Access__c from user where Id = :userId];
if(hhpSet.contains(sServiceModel)){
HHSPSMNFlg=true;
// add to Audit trial : ‘Engine Identified as a Cummins High HorsePower Engine’
if('PGA01'.endsWithIgnoreCase((String)Cache.Session.get('local.CSSPartition.UserEDSPorductGroupAccess'))){
HHSPACCSFlg=true;
// add to Audit trial : ‘User is certified to work on HHP Engine’
}else{
HHSPACCSFlg=false;
displaySrvModPopup1=true;
}
}else{
HHSPSMNFlg=false;
}
}else{
if(workJob.ESN__c.isNumeric() || workJob.ESN__c.length() == 8)
displaySrvModPopup=true;

}
if(HHSPACCSFlg==true || HHSPSMNFlg==false){
/*** Commenting Existing Code, as we are getting Campaigns from Campaign WS ***/
    /*system.debug('inside*$$$$'+sServiceModel);
//Get Campaign Information from QSOL based on ESN
lstCAM = new List<CSS_CampTsbTrp__c>();
system.debug('checking user lang'+accountlang.CSS_QsolLanguage__c);
rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,workJob.ESN__c,'CAM',accountlang.CSS_QsolLanguage__c);
system.debug('inside user lang'+accountlang.CSS_QsolLanguage__c);
if(rQSOLDocs !=null){                                
wCAMTSBTRB = rQSOLDocs.item;
if(wCAMTSBTRB!=null){
for(integer i=0;i<wCAMTSBTRB.size();i++){
CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
ctt1.Name = 'CAM' ;
ctt1.Type__c = 'CAM' ;
ctt1.Job_Order__c = workJob.Id;
ctt1.ESN__c = workJob.ESN__c;
ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
ctt1.URL__c = wCAMTSBTRB[i].url; 
ctt1.Cu_Language__c = accountlang.CSS_QsolLanguage__c;
lstCAM .add(ctt1);
} // End CAM Method Call
}
}

//Get Campaign Information from QSOL based on ESN
lstTSB = new List<CSS_CampTsbTrp__c>();
system.debug('qsol language'+accountlang.CSS_QsolLanguage__c);
rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,workJob.ESN__c,'TSB',accountlang.CSS_QsolLanguage__c);
if(rQSOLDocs !=null){
wCAMTSBTRB = rQSOLDocs.item;
if(wCAMTSBTRB!=null){
for(integer i=0;i<wCAMTSBTRB.size();i++){
CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
ctt1.Name = 'TSB' ;
ctt1.Type__c = 'TSB' ;
ctt1.Job_Order__c = workJob.Id;
ctt1.ESN__c = workJob.ESN__c;
ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
ctt1.Cu_Language__c = accountlang.CSS_QsolLanguage__c;
ctt1.URL__c = wCAMTSBTRB[i].url;
/*   String s1 = string.valueof(wCAMTSBTRB[i].url);  
system.debug('**s1**'+s1);
ctt1.URL__c = s1.substringBeforeLast('/');  
ctt1.Cu_Language__c = 'en'; 
ctt1.File_Name__c = s1.substringAfterLast('/'); */
    
    /*  lstTSB .add(ctt1);
} // End TSB Method Call
}
}

//Get Campaign Information from QSOL based on ESN
lstTRP = new List<CSS_CampTsbTrp__c>();
rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,workJob.ESN__c,'TRP',accountlang.CSS_QsolLanguage__c);
if(rQSOLDocs !=null){
wCAMTSBTRB = rQSOLDocs.item;
if(wCAMTSBTRB!=null){
for(integer i=0;i<wCAMTSBTRB.size();i++){
CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
ctt1.Name = 'TRP' ;
ctt1.Type__c = 'TRP' ;
ctt1.Job_Order__c = workJob.Id;
ctt1.ESN__c = workJob.ESN__c;
ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
ctt1.URL__c = wCAMTSBTRB[i].url;
ctt1.Cu_Language__c = accountlang.CSS_QsolLanguage__c;
lstTRP .add(ctt1);
} // End TRB Method Call
}
}       


//Get ATC Information from QSOL based on ESN
lstATC = new List<CSS_CampTsbTrp__c>();
rQSOLDocs = wsCall.getWarrantyDocs(sQSOLConn,workJob.ESN__c,'ATC',accountlang.CSS_QsolLanguage__c);
if(rQSOLDocs !=null){
wCAMTSBTRB = rQSOLDocs.item;
if(wCAMTSBTRB!=null){
for(integer i=0;i<wCAMTSBTRB.size();i++){
CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
ctt1.Name = 'ATC' ;
ctt1.Type__c = 'ATC' ;
ctt1.Job_Order__c = workJob.Id;
ctt1.ESN__c = workJob.ESN__c;
ctt1.Doc_Num__c = wCAMTSBTRB[i].docNumber;
ctt1.Doc_Title__c = wCAMTSBTRB[i].docTitle;
ctt1.URL__c = wCAMTSBTRB[i].url;
ctt1.Cu_Language__c = accountlang.CSS_QsolLanguage__c;
lstATC.add(ctt1);
} // End ATC Method Call
}
}




//End All CAM, TSB & TRB
system.debug('Value of LIST=='+ lstTRP);
//workjob.Location_Certification__c=getCertificationStatus(sServiceModel);
map<String,String> accCerts = getCertificationStatus(sServiceModel);
if(accCerts.containsKey('warrCertFlag')){                       
workjob.Location_Certification__c=accCerts.get('certStatus');
workjob.Warranty_Authorization_Flag__c=accCerts.get('warrCertFlag');
}
if (workjob.Location_Certification__c =='Red'){
displaycertPopup = true;
}  */
    /*** Story# 118800 Adding Code to call Campaign WS ***/
    //new list preparation// Commenting below code temporarily, as we dont need it now
    /*region = '';
List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getCampaigns(workJob.ESN__c, workJob.Service_Model__c, workJob.Failure_Date__c, accountlang.CSS_QsolLanguage__c, workJob.Id);
system.debug('after ws call mainContr.region>>>:'+region);
//modularized code below for getting Campaigns
//List<List<CSS_CampTsbTrp__c>> campaignsList = CG_BL_Intake.getQSOLDocs(mainContr.workJob.Id, mainContr.workJob.ESN__c, mainContr.accountlang.CSS_QsolLanguage__c);
if(campaignsList !=null && campaignsList.size()>=0)
lstCAM = campaignsList.get(0);
if(campaignsList !=null && campaignsList.size()>=1)
lstTSB = campaignsList.get(1);
if(campaignsList !=null && campaignsList.size()>=2)
lstTRP = campaignsList.get(2);
if(campaignsList !=null && campaignsList.size()>=3)
lstATC = campaignsList.get(3);
if(campaignsList !=null && campaignsList.size()>=4){
if(campaignsList.get(4).get(0).Type__c=='Region')
region = campaignsList.get(4).get(0).Name;
}
System.debug('after retrive workJob.Region__c>>>>:'+region);
//End All CAM,ATC, TSB & TRB
system.debug('campaignsList ==:'+ campaignsList);


//mainContr.workJob.Location_Certification__c=getCertificationStatus(sServiceModel);
map<String,String> accCerts = CG_BL_Intake.getCertificationStatus(workjob.Service_Model__c);
if(accCerts.containsKey('warrCertFlag')){                       
workJob.Location_Certification__c=accCerts.get('certStatus');
workJob.Warranty_Authorization_Flag__c=accCerts.get('warrCertFlag');
}
if (workJob.Location_Certification__c =='Red'){
displaycertPopup = true;
}

}

//Call SRT Make & Model based on QSOL Dataplate Calls ****-Disabled for Release 2
/*
if (sServiceModel != '' && sServiceModel != null && sEngineFamilyCode != '' && sEngineFamilyCode != null)
{
string accessToken = CSS_SRT.receiveToken();
HttpRequest req = new HttpRequest();
req.setEndpoint('https://services-dev.cummins.com/css/getServiceModel');
req.setHeader('Content-Type','application/json');
req.setHeader('Authorization', 'Bearer '+accessToken);
string accessRequest = '{"Header":{"Sender":{"MessageID": "unique message ID at SF","SenderID": "SF","ServiceName": "MakeAndModel"},"Target": {"TargetID": "SRT"}},';
accessRequest = accessRequest + '"DataArea": {"EngineFamilyCode": "' + sEngineFamilyCode + '","ServiceModelName": "' ;
accessRequest = accessRequest + sServiceModel + '","DateTime": "' + Datetime.now().format('YYYY-MM-dd') ;
accessRequest = accessRequest + 'T' + Datetime.now().format('HH:mm:ss') ;
accessRequest = accessRequest + '000Z", "EffectiveDateTime": "' + Datetime.now().format('YYYY-MM-dd');
accessRequest = accessRequest + 'T' + Datetime.now().format('HH:mm:ss') + '000Z"}}'; 
System.debug('The accessRequest is!@!@#'+accessRequest);
req.setBody(accessRequest);
req.setMethod('POST');
//req.setTimeout(120000);
Http http = new Http();    
HTTPResponse res = http.send(req);
string jSONRequestBody = res.getBody();
//CSS_J2AAccessStepDetails_SRT wo1 = (CSS_J2AAccessStepDetails_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AAccessStepDetails_SRT.class);
System.debug('JSON Response='+jSONRequestBody);
}

}
}catch(exception e){
//Defect Fix for ID - 62081
workjob.Service_Model__c = '';
workjob.VIN__c = '';
workjob.Warranty_Start_Date__c =null;
workjob.Location_Certification__c='';


}
}  */
    
    public void  startRequest() {
        try{
            siebelWarrantyDate=null;
            workJob.VIN__c = '';
            higherdateErrFlag = false;
            if (workJob.ESN__c =='' || workJob.ESN__c ==null){
                workjob.Service_Model__c = '';
                workjob.VIN__c = '';
                
                workjob.Warranty_Start_Date__c =null;
                workjob.Location_Certification__c='';
                workjob.Application_Desc__c='';
                workJob.VIN_Flag__c = false;
                showOutageError1= false;
                //workjob.Before_In_Service__c = true;
                //workJob.Make__C = '--None--';
                //workJob.Model__c = '--None--';
                //workJob.Qsol_Engine_Family_Code__c = '';
                sEngineFamilyCode='';
                filterMake = '';
                filterModel = '';
                faildtwsdtflag=false;
                faildtshdtflag=false;
               //  PSNFlag=false;//Story#183077
                //workJob.Make__C = null;
                //workJob.Model__c = null;
            } else {
                filterMake = '';
                filterModel = '';
                workJob.Make__c = '';
                workJob.Model__c = '';
                faildtwsdtflag=false;
                faildtshdtflag=false;
                workJob.Failure_Date__c=system.today();
                workJob.Before_In_Service__c= null;
                //added for ROD Defect 111715 & 111716 by Venkat
                if(workJob.ESN__c.isAlphanumeric())
                {
                    recconFlag = css_utility.getReconEngine(decimal.valueof(workJob.ESN__c));
                }
                else
                    recconFlag = false;
                showOutageError1 = false;
                
                if(recconFlag == true){
                    showOutageError1= true;
                    workJob.ReconEngineFlag__c = 'Y';
                }
                else{
                    showOutageError1= false;
                    workJob.ReconEngineFlag__c = 'N';
                }
                // On change of ESN, replacing BMS Unit Inbound status UI0 to Blank
                if(workJob.BMSStatus__c !=null && workJob.BMSStatus__c.trim() !='')
                    workJob.BMSStatus__c = workJob.BMSStatus__c.replace('UI0','');
                    CSS_getEngineDataResponseJ2A rDataPlate = new CSS_getEngineDataResponseJ2A(); //GSSC_97, ROD:Qsol changes
                /*CSS_quickserveCumminsComWebservices.ModelName rDataPlate; 
                rDataPlate = new CSS_quickserveCumminsComWebservices.ModelName();                                
                CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc rQSOLDocs = new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
                List<CSS_quickserveCumminsComWebservices.WarrantyDoc> wCAMTSBTRB = new List<CSS_quickserveCumminsComWebservices.WarrantyDoc>();                
                string sQSOLConn;
                if(!Test.isRunningTest()){
                    sQSOLConn = CSS_getConnnectionDetails.getConnection('QSOL').Key__c;
                }
                else{
                    sQSOLConn = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                }
                
                //Get Dataplate information from QSOL based on ESN
                
                CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wsCall;*/
                
                try{
                    //Get Dataplate information from QSOL based on ESN
                    /*wsCall = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
                    rDataPlate = wsCall.getEngineDataplate(sQSOLConn, workJob.ESN__c);*/
                    rDataPlate = CG_BL_Intake.GetEngineDataPlateQSOL(workJob.ESN__c); //GSSC_97, ROD:Qsol changes
                    system.debug('rDataPlate>>>'+rDataPlate);
                }
                catch(exception e){
                    System.debug('Error Message:'+e.getMessage());
                }
                /*  CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 wsCall = new CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
rDataPlate = wsCall.getEngineDataplate(sQSOLConn, workJob.ESN__c);
system.debug('rDataPlate>>>'+rDataPlate); */
                //Calling SiebelWS to get data 63173-Start
                
                CSS_getEngineDataResponseJ2A  engineData;
                try{
                    
                    //Calling SiebelWS to get data 63173-Start
                    CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
                    
                    CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
                    jidi.ESN=workJob.ESN__c;
                    wrapobj.DataArea = jidi;
                    engineData = CSS_WS_SBL.getEngineData(wrapobj);
                    WrapperRequestEng = String.valueOf(wrapobj);
                }catch(exception e){
                    System.debug('Error Message:'+e.getMessage());
                }
                /*Story#183077*/
               // if((rDataPlate!=null && rDataPlate.ResponseMessage!=null && rDataPlate.ResponseMessage.contains('SUCCESS')) || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
               /* if(rDataPlate!=null || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
                PSNFlag=false;
                else {
                    PSNFlag=true;
                    
                    CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                    intEngError.Processed_Data__c =  WrapperRequestEng;
                    intEngError.Response_Body__c = 'Access Denied';
                    intEngError.Service_Job_Number__c = workJob.Name;
                    intEngError.Service_Name__c = 'GetEngineDataService';
                    intEngError.Source__c = 'SIEBEL';
                    //intEngError.WWID__c = FedId; 
                    
                    insert intEngError;
                }*/
                 //ROD Changes GSSC_97, As per latest update, QSOL Service call is stopped and data is retrieved from Asset
            //if( (rDataPlate == null || rDataPlate.DataArea == null) &&  (engineData == null || engineData.DataArea == null || !engineData.Header.Status.contains('Success')))
            if( (rDataPlate == null ) &&  (engineData == null || !engineData.Header.Status.contains('Success'))) //GSSC-329
            {
                PSNFlag=true;
                workJob.Get_Engine_data_flag__c=true; //GSSC-329
                CSS_Integration_Error__c intEngError = new CSS_Integration_Error__c();
                intEngError.Processed_Data__c =  WrapperRequestEng;
                intEngError.Response_Body__c = 'Service Failed Or No Data Found';
                intEngError.Service_Job_Number__c = workJob.Name;
                intEngError.Service_Name__c = 'GetEngineDataService';
                intEngError.Source__c = 'SIEBEL';
                //intEngError.WWID__c = FedId; 
                
                insert intEngError;
                
            }
            else{
                        PSNFlag=false;
                        workJob.Get_Engine_data_flag__c=false; //GSSC-329
                    }
                /*end*/
                system.debug('engineData>>>>'+engineData);
                
                /*    CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
CSS_getEngineDataResponseJ2A  engineData;
CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
jidi.ESN=workJob.ESN__c;
wrapobj.DataArea = jidi;
engineData = CSS_WS_SBL.getEngineData(wrapobj); */
                
                //Source of Truth
                if(rDataPlate != null && engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')){
                    workJob.PSN_PACCAR_Flag__c = engineData.DataArea.PACCARFlag;
                    workJob.Automotive_App_Flag__c = engineData.DataArea.AutomotiveAppFlag;
                    if (string.valueOf(engineData.DataArea.NoWarranty) !='')
                    workJob.warrantyIndicatorFlag__c = (engineData.DataArea.NoWarranty == 'Y' ? 'N' : 'Y'); //Story 124
                    //if ( engineData.DataArea != null && engineData.Header.Status.contains('Success')){ //code added by roopa
                    //Application Code SOT is only Siebel
                    if ( string.valueOf(engineData.DataArea.EngineAppDesc)!='' )
                        siebAppCode = css_utility.getCodes('Application Code',string.valueOf(engineData.DataArea.EngineAppDesc),null,null);
                    
                    if( siebAppCode !='' && siebAppCode!=null){   
                        system.debug('siebelApp'+string.valueOf(engineData.DataArea.EngineAppDesc));
                        //added below snippet to default returned value to Application picklist if it's already there if not don't add/default(bms users) - Vignesh
                        //Defect 108199
                        //List<SelectOption> applicationPL = getApplicationCodes();
                        List<SelectOption> applicationPL = getApplication();
                        Set<String> listOfApplication = new Set<String>();
                        for(SelectOption sOption : applicationPL) {
                            listOfApplication.add(sOption.getValue());
                        }
                        if(bmsEnabled==TRUE){
                            if(listOfApplication.contains(string.valueOf(engineData.DataArea.EngineAppDesc)))
                                //Defect 108199
                                // workJob.Application_Desc__c= engineData.DataArea.ProdAppDesc;
                                filterApplication= string.valueOf(engineData.DataArea.EngineAppDesc);
                        }
                        else
                            //Defect 108199
                            // workJob.Application_Desc__c= engineData.DataArea.ProdAppDesc;
                            filterApplication= string.valueOf(engineData.DataArea.EngineAppDesc);
                    }
                    
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
                    workJob.Service_Model__c = sServiceModel;
                    
                    //WSD SOT1=SBL and SOT2=QSOL
                    if (string.valueOf(engineData.DataArea.WarrantyStartDate) !='')               
                        siebelWarrantyDate = date.valueOf(string.valueOf(engineData.DataArea.WarrantyStartDate));
                    if (string.valueof(siebelWarrantyDate) !=''  && string.valueof(siebelWarrantyDate) != null){
                        workJob.Warranty_Start_Date__c=siebelWarrantyDate;
                        system.debug('Checking siebel warranty'+workJob.Warranty_Start_Date__c+siebelWarrantyDate);
                        workJob.Before_In_Service__c = false;
                    }else if (rDataPlate.DataArea.warrantyStartDate != null && rDataPlate.DataArea.warrantyStartDate != '') {
                        workJob.Warranty_Start_Date__c  = parseQSOLDate(rDataPlate.DataArea.warrantyStartDate);
                        system.debug('Checking dataplate warranty'+workJob.Warranty_Start_Date__c+parseQSOLDate(rDataPlate.DataArea.warrantyStartDate));
                        workJob.Before_In_Service__c =  false;
                    }else{
                        system.debug('Checking before in service');
                        workJob.Warranty_Start_Date__c = null;
                        //mainContr.workJob.Before_In_Service__c = false;
                    }
                    
                    //VIN SOT1=QSOL and SOT2=SBL
                    workJob.VIN__c = rDataPlate.DataArea.vin; // Sai: 4/11/2017 Added for CUBS defect # 78702
                    if(rDataPlate.DataArea.vin != '' && rDataPlate.DataArea.vin !=null){ // code added by roopa
                        //mainContr.workJob.VIN__c = rDataPlate.vin; Sai: 4/11/2017 Commented CUBS for defect # 78702
                        workJob.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                    }else{  
                        if (string.valueOf(engineData.DataArea.vin) !='' && string.valueOf(engineData.DataArea.vin) !='' ){
                            siebVIN = string.valueOf(engineData.DataArea.vin);
                            workJob.VIN__c = siebVIN;
                            workJob.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                        }
                    }
                    if((workJob.ESN__c !='' && workJob.ESN__c!= null) && (workJob.VIN__c == '' || workJob.VIN__c == null)) // Sai:4/11/2017: Added this for CUBS Story # 88616
                        workJob.VIN_Flag__c = true;
                    
                    if(engineData.DataArea.EquipmentId != ''){
                        equipmentId = string.valueOf(engineData.DataArea.EquipmentId);
                        system.debug('Equipment Id' + equipmentId);
                    }
                    
                    //Engine_Family_Code SOT1=QSOL and SOT2=SBL
                    /*if(rDataPlate.DataArea.EquipmentConfiguration != null ){
                        sEngineFamilyCode = rDataPlate.DataArea.EquipmentConfiguration.substring(1,3);
                        workJob.Qsol_Engine_Family_Code__c=sEngineFamilyCode;
                    }else{
                        workJob.Qsol_Engine_Family_Code__c=engineData.DataArea.EngineFamilyCode;
                    }*/
                    if(engineData.DataArea.EngineFamilyCode != null ){
                        workJob.Qsol_Engine_Family_Code__c=engineData.DataArea.EngineFamilyCode;                        
                    }else{
                        sEngineFamilyCode = rDataPlate.DataArea.EngineFamilyCode;
                        workJob.Qsol_Engine_Family_Code__c=sEngineFamilyCode;
                    }
                    
                    //Make SOT1=SBL 
                    if ((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true) && string.valueOf(engineData.DataArea.Manufacturer)!=''){ //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                        filterMake= engineData.DataArea.Manufacturer;
                        //Chking if Make exists in CSS
                        //filterMake = css_utility.getMake(filterMake);
                        filterMake = css_utility.getMake(filterMake,engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                    }else{   
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)) //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                            filterMake = '';
                    }
                    
                    //Model SOT1=SBL 
                    system.debug('Model--->'+string.valueOf(engineData.DataArea.Model));
                    if ((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true) && string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){ //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                        filterModel= engineData.DataArea.Model;
                        //chking if Model exists
                        //filterModel = css_utility.getModel(filterMake,filterModel);
                        filterModel = css_utility.getModel(filterMake,filterModel, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                    }else{
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)) //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                            filterModel = '';
                    }
                    //Unit Configuration
                    system.debug('Unit Configuration'+string.valueOf(engineData.DataArea.EquipmentConfiguration));
                    if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true) && string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){ //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                        if(engineData.DataArea.EquipmentConfiguration !=null && engineData.DataArea.EquipmentConfiguration !='')
                            filterUnitType = engineData.DataArea.EquipmentConfiguration;
                        //else
                        //filterUnitType = css_utility.getUnitype(filterMake,filterModel);
                        if(filterUnitType != null && filterUnitType != ''){
                            filterUnitType = css_utility.getUnitype(filterMake,filterModel, filterUnitType, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);//Code updated for story 144598
                            system.debug('CSS_UTILITY----->' +filterUnitType);
                        }
                        /* This line of code is added by Rajesh Narra on 10-15-2018 to fix the issue for equipment configuration, if the equipment configuration has mismatch between Siebel and SRT Web*/
                        if(filterUnitType == null || filterUnitType == ''){
                            filterUnitType = css_utility.getUnitype(filterMake, filterModel, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                            system.debug('SRT Web Unit Cinfig--->'+filterUnitType);
                        }              
                    }else{
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)) //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                            filterUnitType = '';
                    }
                    
                    
                    if (filterMake !='' && filterMake != null){
                        workJob.Make__c = filterMake;                  
                    }
                    if (filterModel != '' && filterModel!= null){
                        workJob.Model__c=filterModel;
                    }
                    if (filterUnitType != '' && filterUnitType!= null){
                        workJob.Unit_Type__c=filterUnitType;
                    }
                    
                    if(workJob.Service_Model__c == null || workJob.Service_Model__c == ''){
                        //if(workJob.ESN__c.isNumeric() || workJob.ESN__c.length() == 8)
                        displaySrvModPopup=true;
                    }
                    
                     productAppdesc =  engineData.DataArea.ProdAppDesc;
                     productAppcode = engineData.DataArea.ProdAppCode;
                     workJob.ProductApplicationDesp__c = engineData.DataArea.ProdAppDesc;
                     workJob.ProductApplicationCode__c = engineData.DataArea.ProdAppCode;
                    
                }else if(rDataPlate != null && (engineData == null || engineData.DataArea == null || !engineData.Header.Status.contains('Success'))){
                    // SMN SOT1=QSOL and SOT2=SBL  
                    workJob.Service_Model__c = rDataPlate.DataArea.ServiceModelName;
                    
                    //WSD SOT1=SBL and SOT2=QSOL
                    if (rDataPlate.DataArea.warrantyStartDate != null && rDataPlate.DataArea.warrantyStartDate != '') {
                        workJob.Warranty_Start_Date__c  = parseQSOLDate(rDataPlate.DataArea.warrantyStartDate);
                        system.debug('Checking dataplate warranty'+workJob.Warranty_Start_Date__c+parseQSOLDate(rDataPlate.DataArea.warrantyStartDate));
                        workJob.Before_In_Service__c =  false;
                    }else{
                        system.debug('Checking before in service');
                        workJob.Warranty_Start_Date__c = null;
                        //mainContr.workJob.Before_In_Service__c = false;
                    }
                    
                    //VIN SOT1=QSOL and SOT2=SBL
                    workJob.VIN__c = rDataPlate.DataArea.vin; // Sai: 4/11/2017 Added for CUBS defect # 78702
                    if(rDataPlate.DataArea.vin != '' && rDataPlate.DataArea.vin !=null){ // code added by roopa
                        //mainContr.workJob.VIN__c = rDataPlate.vin; Sai: 4/11/2017 Commented CUBS for defect # 78702
                        workJob.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                    }
                    if((workJob.ESN__c !='' && workJob.ESN__c!= null) && (workJob.VIN__c == '' || workJob.VIN__c == null)) // Sai:4/11/2017: Added this for CUBS Story # 88616
                        workJob.VIN_Flag__c = true;
                    
                    if(engineData.DataArea.EquipmentId != ''){
                        equipmentId = string.valueOf(engineData.DataArea.EquipmentId);
                        system.debug('Equipment Id' + equipmentId);
                    }
                    
                    //Engine_Family_Code SOT1=QSOL and SOT2=SBL
                    if(rDataPlate.DataArea.EquipmentConfiguration != null ){
                        sEngineFamilyCode = rDataPlate.DataArea.EquipmentConfiguration.substring(1,3);
                        workJob.Qsol_Engine_Family_Code__c=sEngineFamilyCode;
                    }
                    
                    if(workJob.Service_Model__c == null || workJob.Service_Model__c == ''){
                        //if(workJob.ESN__c.isNumeric() || workJob.ESN__c.length() == 8)
                        displaySrvModPopup=true;
                    }
                    
                }else if(rDataPlate == null && engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success') ){
                    workJob.PSN_PACCAR_Flag__c = engineData.DataArea.PACCARFlag;
                    //Application Code SOT is only Siebel
                    
                    //Application Code SOT is only Siebel
                    if ( string.valueOf(engineData.DataArea.EngineAppDesc)!='' )
                        siebAppCode = css_utility.getCodes('Application Code',string.valueOf(engineData.DataArea.EngineAppDesc),null,null);
                    
                    if( siebAppCode !='' && siebAppCode!=null){   
                        system.debug('siebelApp'+string.valueOf(engineData.DataArea.EngineAppDesc));
                        //added below snippet to default returned value to Application picklist if it's already there if not don't add/default(bms users) - Vignesh
                        //Defect 108199
                        //List<SelectOption> applicationPL = getApplicationCodes();
                        List<SelectOption> applicationPL = getApplication();
                        Set<String> listOfApplication = new Set<String>();
                        for(SelectOption sOption : applicationPL) {
                            listOfApplication.add(sOption.getValue());
                        }
                        if(bmsEnabled==TRUE){
                            if(listOfApplication.contains(string.valueOf(engineData.DataArea.EngineAppDesc)))
                                //Defect 108199
                                // workJob.Application_Desc__c= engineData.DataArea.ProdAppDesc;
                                filterApplication= string.valueOf(engineData.DataArea.EngineAppDesc);
                        }
                        else
                            //Defect 108199
                            // workJob.Application_Desc__c= engineData.DataArea.ProdAppDesc;
                            filterApplication= string.valueOf(engineData.DataArea.EngineAppDesc);
                    }
                    
                    /*    if ( string.valueOf(engineData.DataArea.ProdAppDesc)!='' )
siebAppCode = css_utility.getCodes('Application Code',string.valueOf(engineData.DataArea.ProdAppDesc),null,null);
if( siebAppCode !='' || siebAppCode!=null){
//system.debug('siebelApp'+string.valueOf(engineData.DataArea.ProdAppDesc));
//added below snippet to default returned value to Application picklist if it's already there if not don't add/default(bms users) - Vignesh
//Defect 108199
/*List<SelectOption> applicationPL = getApplication(); //commented since not using
Set<String> listOfApplication = new Set<String>();
for(SelectOption sOption : applicationPL) {
listOfApplication.add(sOption.getValue());
}
filterApplication= string.valueOf(engineData.DataArea.ProdAppDesc);
}
*/
                    
                    // SMN SOT1=QSOL and SOT2=SBL  
                    workJob.Service_Model__c = engineData.DataArea.ServiceModelName;
                    
                    //WSD SOT1=SBL and SOT2=QSOL
                    if (string.valueOf(engineData.DataArea.WarrantyStartDate) !='')               
                        siebelWarrantyDate = date.valueOf(string.valueOf(engineData.DataArea.WarrantyStartDate));
                    if (string.valueof(siebelWarrantyDate) !=''  && string.valueof(siebelWarrantyDate) != null){
                        workJob.Warranty_Start_Date__c=siebelWarrantyDate;
                        system.debug('Checking siebel warranty'+workJob.Warranty_Start_Date__c+siebelWarrantyDate);
                        workJob.Before_In_Service__c = false;
                    }else{
                        system.debug('Checking before in service');
                        workJob.Warranty_Start_Date__c = null;
                        //mainContr.workJob.Before_In_Service__c = false;
                    }
                    
                    //VIN SOT1=QSOL and SOT2=SBL
                    if (string.valueOf(engineData.DataArea.vin) !='' && string.valueOf(engineData.DataArea.vin) !='' ){
                        siebVIN = string.valueOf(engineData.DataArea.vin);
                        workJob.VIN__c = siebVIN;
                        workJob.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                    }
                    if((workJob.ESN__c !='' && workJob.ESN__c!= null) && (workJob.VIN__c == '' || workJob.VIN__c == null)) // Sai:4/11/2017: Added this for CUBS Story # 88616
                        workJob.VIN_Flag__c = true;
                    
                    //Engine_Family_Code SOT1=QSOL and SOT2=SBL
                    workJob.Qsol_Engine_Family_Code__c=engineData.DataArea.EngineFamilyCode;
                    
                    //Make SOT1=SBL 
                     if ((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true) && string.valueOf(engineData.DataArea.Manufacturer)!=''){ //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                        filterMake= engineData.DataArea.Manufacturer;
                        //Chking if Make exists in CSS
                        //filterMake = css_utility.getMake(filterMake);
                        filterMake = css_utility.getMake(filterMake,engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                    }else{   
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)) //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                            filterMake = '';
                    }
                    
                    //Model SOT1=SBL 
                    system.debug('Model--->'+string.valueOf(engineData.DataArea.Model));
                    if ((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true) && string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){ //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                        filterModel= engineData.DataArea.Model;
                        //chking if Model exists
                        //filterModel = css_utility.getModel(filterMake,filterModel);
                        filterModel = css_utility.getModel(filterMake,filterModel, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                    }else{
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)) //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                            filterModel = '';
                    }
                    //Unit Configuration
                    system.debug('Unit Configuration'+string.valueOf(engineData.DataArea.EquipmentConfiguration));
                    if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true) && string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){ //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                        if(engineData.DataArea.EquipmentConfiguration !=null && engineData.DataArea.EquipmentConfiguration !='')
                            filterUnitType = engineData.DataArea.EquipmentConfiguration;
                        //else                        
                        //filterUnitType = css_utility.getUnitype(filterMake,filterModel);
                        if(filterUnitType != null && filterUnitType != ''){
                            filterUnitType = css_utility.getUnitype(filterMake,filterModel, filterUnitType, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);//Code updated for story 144598
                            system.debug('CSS_UTILITY----->' +filterUnitType);
                        }
                        /* This line of code is added by Rajesh Narra on 10-15-2018 to fix the issue for equipment configuration, if the equipment configuration has mismatch between Siebel and SRT Web*/
                        if(filterUnitType == null || filterUnitType == ''){
                            filterUnitType = css_utility.getUnitype(filterMake, filterModel, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                            system.debug('SRT Web Unit Cinfig--->'+filterUnitType);
                        }                
                    }else{
                        if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)) //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                            filterUnitType = '';
                    }
                    
                    if (filterMake !='' && filterMake != null){
                        workJob.Make__c = filterMake;                  
                    }
                    if (filterModel != '' && filterModel!= null){
                        workJob.Model__c=filterModel;
                    }
                    if (filterUnitType != '' && filterUnitType!= null){
                        workJob.Unit_Type__c=filterUnitType;
                    }
                    
                    if(workJob.Service_Model__c == null || workJob.Service_Model__c == ''){
                        if(workJob.ESN__c.isNumeric() || workJob.ESN__c.length() == 8)
                        displaySrvModPopup=true;
                    }
                    
                      productAppdesc =  engineData.DataArea.ProdAppDesc;
                      productAppcode = engineData.DataArea.ProdAppCode;
                      workJob.ProductApplicationDesp__c = engineData.DataArea.ProdAppDesc;
                      workJob.ProductApplicationCode__c = engineData.DataArea.ProdAppCode;
                    
                }else{
                    
                    if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)){ //Rajesh: 178700 callStartRequestFromBMSPopup == true to autopopulate it from SRT Web
                        filterMake = '';
                        filterModel = '';
                    }
                    
                    
                    
                }
                
                // End SOT 
                
                
                
                //    Start SOT CODE 
                /*   system.debug('engineData>>>>'+engineData);
if (engineData.DataArea != null && engineData.Header.Status.contains('Success')){
if ( string.valueOf(engineData.DataArea.ProdAppDesc)!='' )
siebAppCode = css_utility.getCodes('Application Code',string.valueOf(engineData.DataArea.ProdAppDesc),null,null);
if( siebAppCode !='' || siebAppCode!=null){   
system.debug('siebelApp'+string.valueOf(engineData.DataArea.ProdAppDesc));
//added below snippet to default returned value to Application picklist if it's already there if not don't add/default(bms users) - Vignesh
//Defect 108199
//List<SelectOption> applicationPL = getApplicationCodes();
List<SelectOption> applicationPL = getApplication();
Set<String> listOfApplication = new Set<String>();
for(SelectOption sOption : applicationPL) {
listOfApplication.add(sOption.getValue());
}
if(bmsEnabled==TRUE){
if(listOfApplication.contains(string.valueOf(engineData.DataArea.ProdAppDesc)))
//Defect 108199
// workJob.Application_Desc__c= engineData.DataArea.ProdAppDesc;
filterApplication= string.valueOf(engineData.DataArea.ProdAppDesc);
}
else
//Defect 108199
// workJob.Application_Desc__c= engineData.DataArea.ProdAppDesc;
filterApplication= string.valueOf(engineData.DataArea.ProdAppDesc);
}
if ( string.valueOf(engineData.DataArea.ServiceModelName)!=''  )
siebelSMN= engineData.DataArea.ServiceModelName;

if (string.valueOf(engineData.DataArea.WarrantyStartDate)!='')               
siebelWarrantyDate = date.valueOf(string.valueOf(engineData.DataArea.WarrantyStartDate));

if ( callStartRequestFromBMSPopup != true && string.valueOf(engineData.DataArea.Manufacturer)!=''){
filterMake= engineData.DataArea.Manufacturer;
//Chking if Make exists in CSS
filterMake = css_utility.getMake(filterMake);
}else{
if(callStartRequestFromBMSPopup != true)
filterMake = '';
}

if (callStartRequestFromBMSPopup != true && string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){
filterModel= engineData.DataArea.Model;
//chking if Model exists
filterModel = css_utility.getModel(filterMake,filterModel);
}else{
if(callStartRequestFromBMSPopup != true)
filterModel = '';
}
if (string.valueOf(engineData.DataArea.vin)!='' && string.valueOf(engineData.DataArea.vin) !='' ){
siebVIN = string.valueOf(engineData.DataArea.vin);
}
}
else{
if(callStartRequestFromBMSPopup != true){
filterMake = '';
filterModel = '';
}
} 
//Calling SiebelWS to get data 63173-End


if ((sServiceModel =='' || sServiceModel==null) && (siebelSMN!='' && siebelSMN!= null)){                    
sServiceModel = siebelSMN;
}
if(sServiceModel =='' || sServiceModel==null)
{
sServiceModel = rDataPlate.servicemodel;
}
workjob.Service_Model__c = sServiceModel;
sServiceModel = rDataPlate.servicemodel;
if(rDataPlate.technicalConfig != null){
sEngineFamilyCode = rDataPlate.technicalConfig.substring(1,3);
workjob.Qsol_Engine_Family_Code__c = sEngineFamilyCode;
}
System.debug('QSOL retrived EngineFamilyCode in Repair>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>:'+sEngineFamilyCode);

if(string.valueof(siebelWarrantyDate)!='' && string.valueof(siebelWarrantyDate)!= null){
workjob.Warranty_Start_Date__c=siebelWarrantyDate;
system.debug('Checking siebel warranty'+workjob.Warranty_Start_Date__c+siebelWarrantyDate);     
workjob.Before_In_Service__c = false;
}
else if (rDataPlate.warrantyStart != null && rDataPlate.warrantyStart != '') {
workjob.Warranty_Start_Date__c  = parseQSOLDate(rDataPlate.warrantyStart);
system.debug('Checking dataplate warranty'+workjob.Warranty_Start_Date__c+parseQSOLDate(rDataPlate.warrantyStart));
workjob.Before_In_Service__c =  false;      
}else{      
system.debug('Checking before in service');     
workjob.Warranty_Start_Date__c = null;      
//workjob.Before_In_Service__c = true;
}
workjob.VIN__c = rDataPlate.vin;
if(rDataPlate.vin!= '' || rDataPlate.vin!=null){
//workjob.VIN__c = rDataPlate.vin;
workjob.VIN_Flag__c=false;
}
if((rDataPlate.vin == '' || rDataPlate.vin == null) && (siebVIN!='' && siebVIN!=null)){
workjob.VIN__c = siebVIN;
workjob.VIN_Flag__c=false;
}
if((workJob.ESN__c!='' && workJob.ESN__c!= null) && (rDataPlate.vin == '' || siebVIN == null)) // Sai:4/11/2017: Added this for CUBS Story # 88616
{    
workjob.VIN_Flag__c = true;
workjob.VIN__c = '';
}
if ( filterMake !='' && filterMake != null){
workjob.Make__c = filterMake;                  
}
if ( filterModel != '' && filterModel!= null){
workjob.Model__c=filterModel;
}
*/
                //  END SOT CODE 
                
                System.debug(' workJob.Service_Model__c: '+ workJob.Service_Model__c);
                if( workJob.Service_Model__c != null &&  workJob.Service_Model__c != ''){
                    Set<String> hhpSet = new Set<String>();
                    for(CSS_Listof_HHP_SMNS__c hhp: CSS_Listof_HHP_SMNS__c.getAll().Values()){
                        hhpSet.add(hhp.Listof_HHP_SMN__c);
                    }
                    //Id userId = UserInfo.getUserId();
                    //User user = [select Product_Group_Access__c from user where Id = :userId];
                    if(hhpSet.contains(workJob.Service_Model__c)){
                        HHSPSMNFlg=true;
                        // add to Audit trial : ‘Engine Identified as a Cummins High HorsePower Engine’
                        if('PGA01'.endsWithIgnoreCase((String)Cache.Session.get('local.CSSPartition.UserEDSPorductGroupAccess'))){
                            HHSPACCSFlg=true;
                            // add to Audit trial : ‘User is certified to work on HHP Engine’
                        }else{
                            HHSPACCSFlg=false;
                            displaySrvModPopup1=true;
                        }
                    }else{
                        HHSPSMNFlg=false;
                    }
                }else{
                     if(workJob.ESN__c.isNumeric() || workJob.ESN__c.length() == 8)
                    displaySrvModPopup=true;
                    
                }
                if(HHSPACCSFlg==true || HHSPSMNFlg==false){
                    
                    
                    
                }
                
                map<String,String> accCerts = CG_BL_Intake.getCertificationStatus(workJob.Service_Model__c,workJob.Failure_Date__c,workJob.Account__c,workJob.Account__r.Warranty_Training_Certification__c,workJob.Account__r.Product_Certification__c, workJob.Account__r.Warranty_Training_Status__c, workJob.Account__r.CERTIFICATION_END_DATE__c);
                    if(accCerts.containsKey('warrCertFlag')){                       
                        workJob.Location_Certification__c=accCerts.get('certStatus');
                        workJob.Warranty_Authorization_Flag__c=accCerts.get('warrCertFlag');
                    }
                    if (workJob.Location_Certification__c =='NotCert'){
                        displaycertPopup = true;
                    }
                workJob.SPDataWebserviceResult__c  = CG_BL_Intake.fetchSPData(workJob,workJob.creator_location__c, null, workJob.Failure_Date__c, null).SPDataWebserviceResult__c;
                //Call SRT Make & Model based on QSOL Dataplate Calls ****-Disabled for Release 2
                
            }
        }catch(exception e){
            //Defect Fix for ID - 62081
            workjob.Service_Model__c = '';
            workjob.VIN__c = '';
            workjob.Warranty_Start_Date__c =null;
            workjob.Location_Certification__c='';
            
            
        }
        
             if(filterApplication== null || filterApplication== ''){
            CSS_PSN__c PSNobj = new CSS_PSN__c();
            try{ 
                PSNobj = [select id, PSN__c,ApplicationCode__c, Application__c from CSS_PSN__c where PSN__c =: workJob.ESN__c order by CreatedDate Desc Limit 1];
            }
            catch(Exception e){
            }
            if(PSNobj != null){
                filterApplication = PSNobj.Application__c;
                system.debug('PSNobj'+PSNobj);

            } else{
                filterApplication = '';
                system.debug('filterApplication'+filterApplication);
                workJob.ProductAppcodeErrorflag__c = false;
                prodcodeErrormessage = false;
            }
        }
        
        system.debug('filterApplication'+filterApplication);
        if(filterApplication!= null ||filterApplication!= '' || filterApplication!='Select One'){
            system.debug('insidethe else for the appcode');
            updateproductappcode();
            system.debug('updateproductappcode on startRequest');
            if(workJob.ProductAppcodeErrorflag__c == true){
                system.debug('workJob.ProductAppcodeErrorflag__c'+workJob.ProductAppcodeErrorflag__c);
               filterApplication = '';
               workJob.ProductAppcodeErrorflag__c = false;
               prodcodeErrormessage = false;
            }
        }
     
        
    }
    
    public void searchConfigUnit()
    {
        try{
            workJob.Unit_Type__c = '';
        system.debug('css_repair_job FilterMake' + filterMake);
        system.debug('css_repair_job FilterModel' + filterModel);
            if (sEngineFamilyCode ==null && workJob !=null)
                sEngineFamilyCode=workJob.Qsol_Engine_Family_Code__c;
        //To get updated values onChange
        List<CSS_Make_Model_Access__c> eqIdList =  new List<CSS_Make_Model_Access__c>([select Access__c, EquipmentId__c from CSS_Make_Model_Access__c where RecordType.Name = 'SRTData' and make__c=:filterMake and model__c=:filterModel and EngineFamilyCode__c=:sEngineFamilyCode LIMIT 1]);
          if (eqIdList !=null && eqIdList.size() >0){
              system.debug('Make Value:' + filterMake);
                equipmentId = eqIdList[0].EquipmentId__c; 
                workJob.AccessCode__c = eqIdList[0].Access__c;
          }
            
         system.debug('css_repair_job equipmentId' + equipmentId);
        system.debug('css_repair_job sEngineFamilyCode' + sEngineFamilyCode);
            
        filterUnitType = css_utility.getUnitype(filterMake,filterModel,sEngineFamilyCode,equipmentId);
        system.debug('Unit_Type' + filterUnitType);
        workJob.Unit_Type__c = filterUnitType;
        system.debug('Unit_Type' +workJob.Unit_Type__c);
        }catch(Exception ex){
            System.debug('in catch of searchConfigUnit of css_repair_job>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }//end #145255
    
    public void startRequestBMS(){
        isUnitInboundStatusEnabled=false;
        startRequest();
        //To call Unit lookup Service if the user is a BMS user
        if(callStartRequestFromBMSPopup != true){
            if(HHSPACCSFlg==true || HHSPSMNFlg==false){
                if(bmsEnabled==true){
                    system.debug('---workJob.ESN__c-->'+workJob.ESN__c);
                    if(workJob.ESN__c!=null || workJob.ESN__c!=''){
                        callingLocation = 'ESN';
                        getBMSUnitDetails();  
                    }
                }
            }
        }
        if (HHSPSMNFlg == true){
            system.debug('calling HHSPSMNFlg=true');
            css_functionality.addToJobHistory('CSS_Job_Order__c',workjob.Id,'Status__c','','Engine Identified as a Cummins High HorsePower Engine');
        }
        if (HHSPACCSFlg == true){
            system.debug('calling HHSPSMNFlg=true');
            css_functionality.addToJobHistory('CSS_Job_Order__c',workjob.Id,'Status__c','','User is certified to work on HHP Engine');                    
        }
    } 
    /*** End of Code for making a call on change of ESN, HHP Story ***/
    /*** Method to make a ws call to BMS for Unit lookup and show them in a POP UP ***/
    public CSS_UnitOutboundJSON2Apex UnitOutboundDetails{get;set;}
    public boolean showOutageError{get;set;}        
    public string errorMessage{get;set;}
    public string callingLocation{get;set;}
    public Boolean AdditionalUnitLookupPopup{get;set;}
    public void getBMSUnitDetailsfromUnitNumber(){
        callingLocation = '';
        getBMSUnitDetails();
    }
    public void getBMSUnitDetails(){
        try{
            UnitOutboundDetails = new CSS_UnitOutboundJSON2Apex();
            //making a callout to get the details
            CSS_FN_BMS BMSFunctionality = new CSS_FN_BMS();
            if(callingLocation != null && callingLocation != '' && callingLocation == 'ESN'){
                if(workJob.Customer_Code__c!= null && workJob.Customer_Code__c != '' && workJob.ESN__c != null && workJob.ESN__c != '')
                    UnitOutboundDetails = BMSFunctionality.getBMSUnitLookupDetails(workJob.Customer_Code__c,workJob.ESN__c,'',workJob.Creator_Location__c);
            }else{
                if(workJob.Customer_Code__c!= null && workJob.Customer_Code__c != '')
                    UnitOutboundDetails = BMSFunctionality.getBMSUnitLookupDetails(workJob.Customer_Code__c,(workJob.ESN__c == null ? '' : workJob.ESN__c), (workJob.Unit_Number__c == null ? '' : workJob.Unit_Number__c),workJob.Creator_Location__c);
            }
            // workJob.Unit_Number__c = UnitOutboundDetails.DataArea.UnitNumber;
            System.debug('Anirudh test');
            System.debug('UnitOutboundDetails********'+UnitOutboundDetails);
            if(UnitOutboundDetails.DataArea!=null && !UnitOutboundDetails.DataArea.isempty()){
                if(callingLocation != null && callingLocation == 'ESN'){
                    UnitLookUpPopup=true;
                }
            }else{
                filterUnitType = '';
            }
            showOutageError= false; 
            if(UnitOutboundDetails !=null && UnitOutboundDetails.Header.Status == 'SYSTEM'){
                system.debug('system outage error*******>>>');
                showOutageError = true;
                errorMessage = System.Label.CSS_Unit_Service_Down;
                //errorMessage = 'Unit number not found, please capture unit number';
                workJob.Unit_Number__c='';
                filterUnitType = '';
            }
            //Checking if there is no Customer records return from the server displaying the message Stroy-7105
            else if( UnitOutboundDetails != null && UnitOutboundDetails.Header.Status == 'ERROR'){
                system.debug('list is empty popup ******');
                //CSS_PageErrorHandlingUtility.showInfo('No data available.  Please create customer account.');
                showOutageError = true;
                errorMessage = System.Label.CSS_UnitOutbound_NoData; 
                workJob.Unit_Number__c='';
                filterUnitType = '';
            }
        }catch(exception e){
            system.debug('Entered Unit Lookup Catch Block'+' Error LineNO:'+e.getLineNumber()+' Exception Msg:'+e.getMessage());
        }
    }
    public Boolean UnitLookUpPopup{get;set;}
    public String selectedUnitNumber{get;set;}
    public void selectedBMSUnitNumber(){
        system.debug('selBMSUnitNumber [[[[[[[[[[[[[[[[[[[]]]]]]]]]]]');
        //selectedUnitNumber = System.currentPagereference().getParameters().get('BMSUnitNumber');
        system.debug('selectedUnitNumber '+ selectedUnitNumber);             
    }
    public void selectedUnitDetails(){
        UnitLookUpPopup=false; 
        system.debug('selectedUnitNumber: '+selectedUnitNumber);
        if(selectedUnitNumber != null && selectedUnitNumber != ''){
            system.debug('selectedUnitNumber: '+UnitOutboundDetails.DataArea);
            if ( UnitOutboundDetails.DataArea != null && !UnitOutboundDetails.DataArea.isEmpty() ) {
                for(CSS_UnitOutboundJSON2Apex.DataArea ud:UnitOutboundDetails.DataArea){
                    system.debug('inside Loop: '+ud.UnitNumber);
                    if(selectedUnitNumber == ud.UnitNumber ){                
                        system.debug('inside Loop Id: '+ud.CustomerCode);
                        workJob.Unit_Number__c = ud.UnitNumber; 
                        //filterUnitType = ud.UnitType; // added code for story 102591  Rajesh Narra commented this code to autopopulate equipment configuration from SRT Web  defect number 178700 
                        break;
                    }
                }
                callingLocation = '';
                UnitOutboundDetails = null;
            }
        }
    }
    public boolean callStartRequestFromBMSPopup;
    public String selectedBMSESN{get;set;}
    public void selectedESNnUnitDetails(){
        system.debug('selectedUnitNumber: '+selectedUnitNumber);
        if(selectedUnitNumber != null && selectedUnitNumber != ''){
            system.debug('selectedUnitNumber: '+UnitOutboundDetails.DataArea);
            if ( UnitOutboundDetails.DataArea != null && !UnitOutboundDetails.DataArea.isEmpty() ) {
                for(CSS_UnitOutboundJSON2Apex.DataArea ud:UnitOutboundDetails.DataArea){
                    system.debug('inside Loop: '+ud.UnitNumber);
                    if(selectedUnitNumber.trim() == ud.UnitNumber.trim() && selectedBMSESN.trim() == ud.ESN.trim()){                  
                        system.debug('inside Loop Id: '+ud.CustomerCode);
                        workJob.Unit_Number__c = ud.UnitNumber;
                        //filterUnitType = ud.UnitType; // added code for story 102591, Rajesh Narra commented this code to autopopulate equipment configuration from SRT Web  defect number 178700 
                        //workJob.Unit_Type__c = ud.UnitType;
                        workJob.ESN__c = ud.ESN;
                        //filterMake = ud.Manufacturer;//'FORETRAVEL';// Rajesh Narra commented this code to autopopulate Make from SRT Web  defect number 178700
                        //filterModel = ud.Model; Rajesh Narra commented this code to autopopulate Model from SRT Web  defect number 178700
                        break;
                    }
                } 
                callStartRequestFromBMSPopup = true;
                startRequestBMS();
                callStartRequestFromBMSPopup = false;
                callingLocation = '';
            }
        }
    }
    public void closeBMSUnitDetails(){
        UnitLookUpPopup=false; 
    }
    public boolean reqUNumBoolean {get; set;}
    public boolean reqCusNumBoolean {get; set;}
    public boolean reqFrstNamBoolean {get; set;}
    public boolean reqLastNamBoolean {get; set;}
    public boolean reqCstmrContactPhnBoolean {get; set;}
    public boolean reqCstmrContactPhntotalchar {get; set;}//92817
    public boolean reqUTBoolean {get; set;}
    public boolean reqPhnnoBoolean {get; set;}//92817
    public boolean reqPhnnototalchar {get; set;}//92817
    public boolean allFieldsValidate {get; set;}
    public boolean reqEmailBoolean {get; set;}
    public boolean reqEmailInvalidBoolean {get; set;}
    
    public pagereference ShowErrorMessagePanels() {
        system.debug('workJob.Actual_Technician_Time__c' + workJob.Actual_Technician_Time__c);
        if (workJob.Actual_Technician_Time__c==null &&  isdealer == true)  {
            
            reqATTBoolean=true;
            system.debug('Inside Ifffff'+reqATTBoolean);
            //reqShopBoolean=true;
            allFieldsValidate = true;
        } else {
            
            reqATTBoolean=false;
            system.debug('Inside Elseeeeee'+reqATTBoolean);
            allFieldsValidate = false; 
        }
        
        return null;
        
    }
    
    public PageReference validateBeforeSave()
    {
        System.debug('entered validateBeforeSave');
        reqCstmrContactPhnBoolean = false;//92817
        reqCstmrContactPhntotalchar = false;//92817
        reqPhnnoBoolean = false;//92817
        reqPhnnototalchar = false;//92817
        allFieldsValidate = false;
        reqATTBoolean=false;
        //Defect fix - 65391
        if( workJob.DSID_WorkGroup__c != null && workJob.DSID__c!=null ){
            
            System.debug('call ExitDSID WebServicecalled ParamterinIFFFF>>>>>>>>>'+workJob.DSID_WorkGroup__c+''+workJob.DSID__c);
            System.debug('call getEXITDSID WebServicecalled>>>>>>>>>');
            // Story - 67555 DS Read Only - start
            system.debug('checkin user'+dsidIndi);
            if(dsidIndi != null && dsidIndi.containsIgnoreCase('O')){
                CSS_EDSAuthentication.exitDSID(workJob.DSID_WorkGroup__c,workJob.DSID__c);
            }
            // Story - 67555 DS Read Only - end 
        }
        System.Debug('in pgSaveAssign==============');
        css_job_order__c worecord= new css_job_order__c();
        
        workJob.Make__c = filterMake;
        workJob.Model__c = filterModel;
        workJob.Application_Desc__c = filterApplication;
        workJob.Category_Desc__c = filterCategory;
        workJob.Complaint_Type_Desc__c = filterComplaintType;
        workJob.Category2_Desc__c=filterCategory2;
        workJob.Category3_Desc__c=filterCategory3;
        workJob.Category4_Desc__c=filterCategory4;
        workJob.Category5_Desc__c=filterCategory5;
        
        workJob.Complaint_Type2_Desc__c=filterComplaintType2;
        workJob.Complaint_Type3_Desc__c=filterComplaintType3;
        workJob.Complaint_Type4_Desc__c=filterComplaintType4;
        workJob.Complaint_Type5_Desc__c=filterComplaintType5;
        if ((workJob.Customer_Name__c==null || workJob.Customer_Name__c=='')&& workJob.PSN_Not_Available__c == false)  {
            reqBoolean=true;
            //reqShopBoolean=true;
            allFieldsValidate = true;
            system.debug('Testing 1');
            return null;
        } else {
            reqBoolean=false;
            //reqShopBoolean=false;
            allFieldsValidate = false; 
        }
        
        system.debug('workJob.Shop_Work_Order__c' + workJob.Shop_Work_Order__c);
        //Added Condition to display error message if SWO is null Rajasekhar H Silicon Valley for #158101
        if((workJob.Shop_Work_Order__c==null || workJob.Shop_Work_Order__c=='') && isDealer == true) {
            reqShopBoolean=true;
            allFieldsValidate = true;
            return null;
        } else {
            reqShopBoolean=false; 
            allFieldsValidate = false;
        }
        
        //End of Condition
        
        system.debug('workJob.Actual_Technician_Time__c' + workJob.Actual_Technician_Time__c + 'isdealer>>>' + isdealer);
        //commneted as part of story GSSC-108
        /*if (workJob.Actual_Technician_Time__c==null && isdealer == true)  {
            
            reqATTBoolean=true;
            //reqShopBoolean=true;
            allFieldsValidate = true;
            system.debug('Inside If'+reqATTBoolean);
            return null;
        } else {
            
            reqATTBoolean=false;
            system.debug('Inside elseeeeeeeee'+reqATTBoolean);
            allFieldsValidate = false; 
        }*/
        
        system.debug('workJob.Customer_Code__c' + workJob.Customer_Code__c);
        if (bmsEnabled==true && (workJob.Customer_Code__c == null || workJob.Customer_Code__c == '') && workJob.PSN_Not_Available__c == false){
            reqCusNumBoolean=true;
            allFieldsValidate=true;
            return null;  
        }else{
            reqCusNumBoolean = false;
            allFieldsValidate=false;
        }
        
        //START - 92817
        system.debug('workJob.Phone_Number__c ' + workJob.Phone_Number__c);
        if (bmsEnabled==true) {
            boolean Error = false;
            if(workJob.Phone_Number__c != null)
                Error = css_utility.CheckPhoneNoIsValid(workJob.Phone_Number__c);
            
            if(workJob.Phone_Number__c == null || workJob.Phone_Number__c == '') {
                reqPhnnoBoolean = true;
                reqPhnnototalchar = false;
                allFieldsValidate = true;
                return null; 
            } else if(Error) {
                reqPhnnoBoolean = false;
                reqPhnnototalchar = true;
                allFieldsValidate = true;
                return null; 
            } else if(!Error) {
                reqPhnnoBoolean = false;
                reqPhnnototalchar = false; 
                allFieldsValidate = false;
            }
        } else {
            reqPhnnoBoolean = false;
            reqPhnnototalchar = false; 
            allFieldsValidate = false;
        }
        //END - 92817
        if (bmsEnabled==true && (workJob.First_Name__c == null || workJob.First_Name__c == '')){
            reqFrstNamBoolean = true;
            allFieldsValidate=true;
            return null;  
        }else{
            reqFrstNamBoolean = false;
            allFieldsValidate=false;
        }
        
        if (bmsEnabled==true && (workJob.BMS_Last_Name__c == null || workJob.BMS_Last_Name__c == '')){
            reqLastNamBoolean = true;
            allFieldsValidate=true;
            return null;  
        }else{
            reqLastNamBoolean = false;
            allFieldsValidate=false;
        }
        
        //START - 92817
        system.debug('workJob.Cstmr_Contacts_Phone__c ' + workJob.Cstmr_Contacts_Phone__c);
        if (bmsEnabled==true) {
            boolean Error = false;
            if(workJob.Cstmr_Contacts_Phone__c != null)
                Error = css_utility.CheckPhoneNoIsValid(workJob.Cstmr_Contacts_Phone__c);
            
            if(workJob.Cstmr_Contacts_Phone__c == null || workJob.Cstmr_Contacts_Phone__c == '') {
                reqCstmrContactPhnBoolean = true;
                reqCstmrContactPhntotalchar = false;
                allFieldsValidate=true;
                return null; 
            } else if(Error) {
                reqCstmrContactPhnBoolean = false;
                reqCstmrContactPhntotalchar = true;
                allFieldsValidate=true;
                return null; 
            } else if(!Error) {
                reqCstmrContactPhnBoolean = false;
                reqCstmrContactPhntotalchar = false; 
                allFieldsValidate=false;
            }
        } else {
            reqCstmrContactPhnBoolean = false;
            reqCstmrContactPhntotalchar = false; 
            allFieldsValidate=false;
        }
        //END - 92817
        //start97401
        if (bmsEnabled==true && (workJob.Email_Address__c == null || workJob.Email_Address__c == '')){
            reqEmailBoolean=true;
            allFieldsValidate=true;
            reqEmailInvalidBoolean=true;
            return null;  
        }
        else{
            if(workJob != null && workJob.Email_Address__c != null && workJob.Email_Address__c != ''){   // coded added by roopa for email story
                reqEmailBoolean = css_utility.validateEmail(workJob.Email_Address__c);
                
                if(reqEmailBoolean == false){
                    system.debug('Inside Email IF');
                    reqEmailInvalidBoolean = true;
                    allFieldsValidate=true;
                    return null;
                    //reqEmailBoolean = false;
                }
                else{
                    system.debug('Inside Email ELSE');
                    reqEmailBoolean = false;
                    allFieldsValidate=false;
                    reqEmailInvalidBoolean=false;
                }
            }
        }
        if (bmsEnabled==true && (workJob.Unit_Number__c==null || workJob.Unit_Number__c=='') && workJob.PSN_Not_Available__c == false)  {
            reqUNumBoolean=true;
            allFieldsValidate = true;
            return null;
        }
        else{
            reqUNumBoolean=false;
            allFieldsValidate = false;
        }
        //end 97401
        if (bmsEnabled==true && (workJob.Unit_Type__c==null || workJob.Unit_Type__c=='----None----' || workJob.Unit_Type__c=='') && workJob.PSN_Not_Available__c == false){
            reqUNumBoolean=true;
            allFieldsValidate = true;
            return null;
        }else{
            reqUNumBoolean=false;
            allFieldsValidate = false;
        }
        if (bmsEnabled==true && (workJob.Sub_Type__c==null || workJob.Sub_Type__c=='----None----' || workJob.Sub_Type__c=='') && workJob.PSN_Not_Available__c == false){
            reqUNumBoolean=true;
            allFieldsValidate = true;
            return null;
        }else{
            reqUNumBoolean=false;
            allFieldsValidate = false;
        }
        
        if (workJob.Application_Desc__c==null || workJob.Application_Desc__c=='')  {
            reqAppBoolean=true;
            allFieldsValidate = true;
            system.debug('Testing 2');
            return null;
        }
        else{
            reqAppBoolean=false;
            allFieldsValidate = false;
        }
        if (workJob.ESN__c==null || workJob.ESN__c=='')  {
            reqESNBoolean=true;
            allFieldsValidate = true;
            workJob.Get_Engine_data_flag__c=PSNFlag;//story#183077
            system.debug('Testing 3');
            return null;
        }else{
            reqESNBoolean=false;
            allFieldsValidate = false;
            workJob.Get_Engine_data_flag__c=PSNFlag;//story#183077
        }
        if (workJob.Make__c==null || workJob.Make__c=='')  {
            reqMakeBoolean=true;
            allFieldsValidate = true;
            system.debug('Testing 41');
            return null;
            
        }else{
            reqMakeBoolean=false;
            allFieldsValidate = false;
        }
        if (workJob.Model__c==null || workJob.Model__c=='')  {
            reqMdlBoolean=true;
            allFieldsValidate = true;
            system.debug('Testing 42');
            return null;
        }else{
            reqMdlBoolean=false;
            allFieldsValidate = false;
        }
        if ((workJob.Category_Desc__c == null || workJob.Category_Desc__c == '' || workJob.Category_Desc__c == '----None----') && workJob.PSN_Not_Available__c == false)  {
            reqCatBoolean=true;
            allFieldsValidate = true;
            system.debug('Testing 43');
            return null;
        }
        else{
            reqCatBoolean=false;
            allFieldsValidate = false;
        }
        if ((workJob.Complaint_Type_Desc__c==null || workJob.Complaint_Type_Desc__c=='' || workJob.Complaint_Type_Desc__c == '----None----') && workJob.PSN_Not_Available__c == false)  {
            reqComtypBoolean=true;
            allFieldsValidate = true;
            system.debug('Testing 6');
            return null;
            
        }else{
            reqComtypBoolean=false;
            allFieldsValidate = false;
        }
        
        if(bmsEnabled==true  && (filterUnitType=='' || filterUnitType==null || filterUnitType=='----None----')){
            system.debug('InsidePSNNotAvchk>>'+reqUTBoolean);
            reqUTBoolean=true;
            allFieldsValidate = true;
            return null;
        }
        else
        {
            reqUTBoolean=false;
            allFieldsValidate = false;
        }
        
        if(bmsEnabled==true && (workJob.Unit_Number__c=='' || workJob.Unit_Number__c==null || workJob.Unit_Number__c=='----None----')&& workJob.PSN_Not_Available__c == false){
            system.debug('InsidePSNNotAvchk>>'+reqUNumBoolean);
            reqUNumBoolean=true;
            allFieldsValidate = true;
            return null;
        }
        else{ reqUNumBoolean=false;
             allFieldsValidate = false;
            }
        
        
        if (ChkFieldBlank() =='VALIDATE')
        {
            
            System.Debug('in pgSaveAssign blank==============');
            return null;
        }
        else
        {
            //Added below code for story# 77160
            if(bmsEnabled==true){
                system.debug('Inside If statement');
                callCreateWoAndUpdateComment();
            } 
            worecord.SPDataWebserviceResult__c=workJob.SPDataWebserviceResult__c;
            worecord.PSN_PACCAR_Flag__c = workJob.PSN_PACCAR_Flag__c;
            worecord.Assigned_To__c = workJob.Assigned_To__c;
            worecord.Additional_Tech1__c=workJob.Additional_Tech1__c;
            worecord.Additional_Tech2__c=workJob.Additional_Tech2__c;
            worecord.Customer_Name__c=workJob.Customer_Name__c;
            worecord.Shop_Work_Order__c=workJob.Shop_Work_Order__c;
            worecord.Make__c=filterMake;
            worecord.Model__c=filterModel;
            worecord.Location_Certification__c=workjob.Location_Certification__c;
            worecord.Application_Desc__c = filterApplication;
            worecord.Unit_number__c = workJob.Unit_number__c;
            worecord.ESN__c = workJob.ESN__c;
            worecord.Qsol_Engine_Family_Code__c = workjob.Qsol_Engine_Family_Code__c;
            worecord.Mileage__c = workJob.Mileage__c;
            worecord.CSS_Hours__c = workJob.CSS_Hours__c;
            worecord.warrantyIndicatorFlag__c = workJob.warrantyIndicatorFlag__c;
            worecord.Mileage_Measure__c = mil_measure;
            if(workJob.Failure_Date__c != null && workJob.Failure_Date__c > system.today()){ //Added for defect number 188494 
                worecord.Failure_Date__c = system.today();
            }else{
                worecord.Failure_Date__c=workJob.Failure_Date__c;
            }
            worecord.Failure_Point__c = workJob.Failure_Point__c;
            worecord.Failure_Point_Measure__c = fail_measure;
            worecord.VIN__c = workJob.VIN__c;            
            worecord.VIN_Flag__c = workJob.VIN_Flag__c;
            worecord.Warranty_Start_Date__c=workJob.Warranty_Start_Date__c;//Defect 78458
            worecord.Category_Desc__c = filterCategory;
            worecord.Category2_Desc__c = filterCategory2;
            worecord.Category3_Desc__c = filterCategory3;
            worecord.Category4_Desc__c = filterCategory4;
            worecord.Category5_Desc__c = filterCategory5;
            worecord.Complaint_Type_Desc__c = filterComplaintType;
            worecord.Complaint_Type2_Desc__c = filterComplaintType2;
            worecord.Complaint_Type3_Desc__c = filterComplaintType3;
            worecord.Complaint_Type4_Desc__c = filterComplaintType4;
            worecord.Complaint_Type5_Desc__c = filterComplaintType5;
            worecord.Preventive_Maintenance__c=workJob.Preventive_Maintenance__c;
            worecord.Expedited_Service__c=workJob.Expedited_Service__c;
            worecord.General_Symptoms__c=workJob.General_Symptoms__c;
            worecord.Previous_Status__c=workJob.Status__c;
            worecord.BMSStatus__c = workJob.BMSStatus__c;
            worecord.isWOServiceFailure__c = workJob.isWOServiceFailure__c; //GSSC-86
            worecord.Customer_Code__c = workJob.Customer_Code__c;
            worecord.Phone_Number__c = workJob.Phone_Number__c;
            worecord.First_Name__c = workJob.First_Name__c;
            worecord.BMS_Last_Name__c = workJob.BMS_Last_Name__c;
            worecord.Cstmr_Contacts_Phone__c = workJob.Cstmr_Contacts_Phone__c;
            //added the below by venkat G for defect 126387
            system.debug('Email Address '+workJob.Email_Address__c);
            system.debug('Email Address chkbox'+workJob.Email_check_box__c);
            //worecord.Email_Address__c = workJob.Email_Address__c;
            // The code is added by Rajesh Narra on 4/12/2018 to not save the @ symbol for the email address field 
            if(EmailAddress!=null && EmailAddress!='' && EmailAddress1!=null && EmailAddress1!=''){
                worecord.Email_Address__c=EmailAddress+'@'+EmailAddress1;
            }else{
                worecord.Email_Address__c='';
            }
            
            //worecord.Email_Address__c=EmailAddress+'@'+EmailAddress1; Commented by Rajesh Narra on 4/12/2018
            worecord.Email_check_box__c = workJob.Email_check_box__c;
            If(workJob.Email_check_box__c == true){
                worecord.Email_Address__c = 'declined@cummins.com';
            }
            system.debug('Email Address123 '+worecord.Email_Address__c);
            // worecord.Email_check_box__c = workJob.Email_check_box__c;
            worecord.Address__c = workJob.Address__c;
            worecord.City__c = workJob.City__c;
            worecord.CSS_State__c = workJob.CSS_State__c;
            worecord.ZipCode__c = workJob.ZipCode__c;
            worecord.Primary_Segment__c = workJob.Primary_Segment__c;
            worecord.Country__c = workJob.Country__c;
            worecord.CSS_Charge_Account_Status__c = workJob.CSS_Charge_Account_Status__c;
            worecord.Contact_ID__c = workJob.Contact_ID__c;
            worecord.Unit_Type__c=workJob.Unit_Type__c;
            worecord.Sub_Type__c=filterSubType;
            worecord.Service_Model__c = workJob.Service_Model__c;
            worecord.Actual_Technician_Time__c = workJob.Actual_Technician_Time__c;
            /*story#183077*/
            if(workJob.DSID__c==null || workJob.DSID__c=='' || string.isBlank(workJob.DSID__c))
            worecord.Get_Engine_data_flag__c=PSNFlag;
            /*end*/
            // Defect fix 59457
            //saveCheckBox(); //Commenting the method as per story 190513
            if (Wid != null)
            {  
                //  System.Debug('value of customer===='+workJob.customer_name__c);
                //  Call RSW Claiminfo Service to send data to RSW
                // CSS_RSWClaimInfo.sendClaimInfoToRSW(workJob);
                worecord.id=workJob.id;
                if(workjob.warranty_start_date__c != null){
                    worecord.before_in_service__c = false;
                }else{worecord.before_in_service__c = true;}
                /***************************************************************************************/     
                //Story Number   : 71585 
                //Description    : As a technician I need Before & After Images saved to the job order
                //Implemented By : Shanthi
                /****************************************************************************************/   
                if(workjob.css_ecm__r!=null){
                    string ECMImage;
                    system.debug('ECM Data Before'+workjob.css_ecm__r);
                    List<css_ecm__c> ecmlist = workjob.css_ecm__r;
                    for(css_ecm__c ecm : ecmlist ){
                        system.debug('ECM Data'+ecm);
                        
                        if(ecm.ECM_Image_Name__c!='NA' && ecm.ECM_Image_Name__c!='na'){
                            
                            
                            String afterimage = ecm.ECM_Image_Name__c+'.eif';
                            if(workjob.Before_Image__c!= afterimage ){
                                worecord.after_image__c =afterimage ;  
                                break;
                            }
                        }
                    }
                    //System.debug('shanthi @@@@@@@'+worecord.after_image__c  );
                    // System.debug('shanthi ecm image @@@@@@@'+c.ECM_Image_Name__c   );
                }
                //End of story: 71585
                
                update worecord;
                //  System.Debug('record updated====='+worecord);
                
               
            }
        }
        
        // Story 190625
        
        PageReference pageRef12;
         if(workjob.Sub_Status__c!= 'Claim in Progress'){
               Cache.Session.put('ShowSubStatuspopup2', 'true');
               pageRef12 = new pageReference('/apex/CSS_JobRepairRj?id='+Wid); 
          }
          else{
               pageRef12 = new pageReference('/apex/CSS_Job_Detail?nto=HOME');  
          }
       
        pageRef12.setRedirect(true);
        return pageRef12;
    } 
    //158790
    public boolean substatuscheck{get;set;}
    public PageReference pgSaveAssign()
    {
        PageReference pageRef12;
        Cache.Session.put('ShowSubStatuspopup2', 'false');
        css_job_order__c worecord= new css_job_order__c();
        worecord.Id = workJob.Id;
        if (workJob.Status__c =='Triage & Diagnosis/Repair' || workJob.Status__c =='Repair' ){
            worecord.Previous_Status__c=workJob.Status__c;
            worecord.Status__c='Review';
        }
        else{
            if(workJob.Warranty_Start_Date__c > date.today() && workJob.Status__c=='Repair')
                worecord.Warranty_Start_Date__c =null;
        }
        SubStatusPrevValue=workJob.Sub_Status__c;
        system.debug('SubStatusPrevValue>>>>>>>'+SubStatusPrevValue);
        system.debug('selectedSubStatusVal--'+selectedSubStatusVal);
        if(SubStatusPrevValue != selectedSubStatusVal){
            worecord.Sub_Status__c =selectedSubStatusVal;
            worecord.LastUpdateSubStatus__c= system.now();
        }
        update worecord;
        
       // PageReference pageRef12 = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
       if(selectedSubStatusVal == null || selectedSubStatusVal =='' || selectedSubStatusVal == '--Select One--'){
            substatuscheck = true;
            system.debug('substatuscheck1111'+substatuscheck);
            // pageRef12 = null;
            return null;
            
        }
        else{
            substatuscheck = false;
            system.debug('substatuscheck2222'+substatuscheck);
            pageRef12 = new pageReference('/apex/CSS_Job_Detail?nto=HOME'); 
        }
       // pageRef12.setRedirect(true);
        return pageRef12;
        
    }
    public void callRSWlink()
    {   
        system.debug('callRSWlink');
        if (Wid != null ) //&& workjob.Actual_Technician_Time__c != null // karthik G commented as GSSC-691
        {
            reqATTBoolean = false;
            allFieldsValidate = false;
            system.debug('Inside If123--'+reqATTBoolean);
            //update workjob; Commented this scenario to fix the RSW issue  as part of the defect Number  168213 
            //  Call RSW Claiminfo Service to send data to RSW
            System.Debug('Before RSW Call');
            CSS_RSWClaimInfo.sendClaimInfoToRSW(workJob);
            //worecord.id=workJob.id;
            //update worecord;
            System.Debug('After RSW Call');
        } else {
            reqATTBoolean = true;
            allFieldsValidate = true;
            system.debug('Inside Else--'+reqATTBoolean);
        }system.debug('reqATTBoolean' + ' ' +reqATTBoolean);
        
        
        
        //return null;
    }
    
    public pagereference callWarrantyoverviewlink()
        
    {
        system.debug('callWarrantyoverviewlink');
        PageReference pg;
        CG_CL_CreateClaims_Table createclaimcontrl = new CG_CL_CreateClaims_Table();
        system.debug('selectedRepairJobID'+ selectedRepairJobID);
        createclaimcontrl.selectedJob = selectedRepairJobID;
        createclaimcontrl.createdfrom = 'Repair RJ';
        createclaimcontrl.CreateNeGclaim();
        
        if(createclaimcontrl.newClaim.id==null)
        {
            pg = new pageReference('/apex/CG_ClaimsIntake'); 
        }
        else
        {
            pg = new pageReference('/apex/CG_ClaimsIntake?id='+createclaimcontrl.newClaim.id); 
        }
        return pg;
        //return null;        
    }
    
    /*
public void callRSWlink()
{    
if(workjob.Actual_Technician_Time__c != null) {
//reqATTBoolean = false;
//allFieldsValidate = false;
if (Wid != null){
//  Call RSW Claiminfo Service to send data to RSW
System.Debug('Before RSW Call');
CSS_RSWClaimInfo.sendClaimInfoToRSW(workJob);
System.Debug('After RSW Call');
}
} else {
//reqATTBoolean = true;
//allFieldsValidate = true;
}
//return null;
}*/
    
    /*
public boolean callRSWlink()
{    
if(workjob.Actual_Technician_Time__c != null) {
reqATTBoolean = false;
if (Wid != null) {
//  Call RSW Claiminfo Service to send data to RSW
System.Debug('Before RSW Call');
CSS_RSWClaimInfo.sendClaimInfoToRSW(workJob);
//worecord.id=workJob.id;
//update worecord;
System.Debug('After RSW Call');
return true;
}
return false;
} else {
reqATTBoolean = true;
return false;
}
return false;
}
*/
    
    public user userlang{get; set;}
    public CSS_accountLanguage__c accountlang{get; set;}
    Transient public list<CSS_CampTsbTrp__c> campList{get;set;}
    Transient map<string,CSS_CampTsbTrp__c> qsolCampMap = new map<string,CSS_CampTsbTrp__c>();
    list<CSS_CampTsbTrp__c> qsolCTTP9 = new list<CSS_CampTsbTrp__c>();
    // Method to call quick serve on page load - start
    public void qsollanguage(){
        list<CSS_CampTsbTrp__c> qsolla1 = new list<CSS_CampTsbTrp__c>();
        list<CSS_CampTsbTrp__c> qsolla2 = new list<CSS_CampTsbTrp__c>();       
        
        system.debug('**above user Lang');
        system.debug('**after user Lang');
        
        system.debug('checking qsolcttp9'+qsolCTTP9);   
        if(lstQSOLDocs != null && !lstQSOLDocs.isEmpty()){  
            //for(CSS_CampTsbTrp__c camp : qsolCTTP9){
            if(lstQSOLDocs[0].Cu_Language__c != null && lstQSOLDocs[0].Cu_Language__c != accountlang.CSS_QsolLanguage__c ){                    
                qsolla1.add(lstQSOLDocs[0]);                       
            }
            if(lstQSOLDocs[0].Cu_Language__c != null && lstQSOLDocs[0].Cu_Language__c == accountlang.CSS_QsolLanguage__c ){                    
                qsolla2.add(lstQSOLDocs[0]);                       
            }
            //}
            if(Wid != null && workjob.ESN__c != null && (!qsolla1.isEmpty()|| !qsolla2.isEmpty())){
                campList = CSS_QuickServe.getQsolDocSaveLang(workjob.Id, workjob.ESN__c, accountlang.CSS_QsolLanguage__c);
                if(campList != null && !campList.isEmpty()){
                    for(CSS_CampTsbTrp__c campRec : campList){
                        qsolCampMap.put(campRec.Doc_Num__c,campRec);
                    }
                }
            }
        }      
        
    } 
    
    
    
    
    // Method to call quick serve on page load - end
    
    public String myBase64String {get;set;} 
    // Method for helpful resources - start
    public string gettoken(){
        long currentTime = System.now().getTime();
        string token = 'CSS'+'|'+(String.valueOf(currentTime));
        myBase64String = EncodingUtil.base64Encode(Blob.valueof(token));
        return myBase64String;
    }
    /***** Commenting Below code as it is moved to Job Plan *****/
    /*  
// Method for helpful resources - end 
public String SolCompToBMS='';
public String RepResponse;
public String BMSFailureID;
public string BMSFailureID2;
//Method to Send the Repair and component values to BMS
public String cause(){
BMSFailureID='';
for(CSS_Solutions__c solutions : Solutions){

if(solutions.Repair_Response__c != null && (solutions.Repair_Response__c.equalsIgnoreCase('Repair Successful.') || solutions.Repair_Response__c.equalsIgnoreCase('Repair Successful with additional parts/procedures.'))){
RepResponse = 'Repair Notes' + '=' + solutions.Repair_Notes__c + '\\n' + 'SolutionID' + '=' + solutions.Name + '\\n' + 'Solution Title' + '=' + solutions.Solution_Title__c;
system.debug('RepResponse>>>>*****'+RepResponse);
if(!solutions.CSS_Solution_Components__r.isempty()){
system.debug('solutions.CSS_Solution_Components__r>>>>*****'+solutions.CSS_Solution_Components__r); 
for(CSS_Solution_Component__c components : solutions.CSS_Solution_Components__r){
if(components.Component_Id__c==''){
system.debug('components.Component_Id__c 1 '+components.Component_Id__c);
}else if(components.Component_Id__c!=null && components.Selected_Component__c == true){
system.debug('components.Component_Id__c 2 '+components.Component_Id__c);
BMSFailureID = BMSFailureID + '\\n' + 'Failure Name' + '=' + components.Name + '\\n' + 'Quantity' + '=' + components.Quantity__c;
}
}
}

system.debug('BMSFailureID>>>> '+BMSFailureID);
SolCompToBMS = SolCompToBMS + '\\n' + RepResponse +  BMSFailureID;
system.debug('After SolCompToBMS*****************'+SolCompToBMS);
}
system.debug('for...........'); 
}
system.debug('inside Cause>>>>'+SolCompToBMS + '\\n' + workJob.Name);
return SolCompToBMS + '\\n' + 'CSS Job ID' + '=' + workJob.Name;
} */
    // Method to call the WO-WOQT Inbound to create work order  and WO Comment Inbound webservice to update the Comments(S-67572) .
    public string DefaultInshop;
    public CSS_unitInboundJSON2Apex UIResp{get;set;}
    public void callCreateWoAndUpdateComment(){
        try{
            if(workJob.Unit_Number__c !=null){
                string applicationCode = css_utility.getCodes('Application Code',workjob.application_Desc__c,null,null);
                //Prabhakar Added below Code (19/03) for Defect#134296
                String FailureDateForUnitInbound;
                if(workJob.Failure_Date__c != null){
                    datetime FailureDt = workJob.Failure_Date__c;
                    FailureDateForUnitInbound = FailureDt.format('dd-MMM-yyyy','GMT') + ' ' + '13:00:00';
                }
                String WarrantyStartDateforUnitInbound;
                if(workJob.Warranty_Start_Date__c != null){
                    datetime WrntyDt = workJob.Warranty_Start_Date__c;
                    WarrantyStartDateforUnitInbound = WrntyDt.format('dd-MMM-yyyy','GMT');
                }
                //Call the Unit Inbound Service
                UIResp = new CSS_unitInboundJSON2Apex();
                //making a call to update the details
                System.debug('Before calling callUnitInbound-- QSOL EngineFamilyCode in Repair>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>workJob.Qsol_Engine_Family_Code__c:'+workJob.Qsol_Engine_Family_Code__c);
                // UIResp = CSS_WS_BMS.callUnitInbound(workJob.Customer_Code__c,workJob.Unit_Number__c,filterUnitType,workJob.Model__c,workJob.VIN__c,workJob.Make__c,workJob.Service_Model__c,workJob.ESN__c,workJob.Qsol_Engine_Family_Code__c,applicationCode,workJob.Creator_Location__c,workJob.Mileage_Measure__c,string.valueof(workJob.Mileage__c),string.valueof(workJob.CSS_Hours__c),string.valueof(workJob.Failure_Date__c),string.valueof(workJob.Warranty_Start_Date__c));
                //Prabhakar Added below Code (19/03) for Defect#134296
                String milMeasureUC;
                if(workJob.Mileage_Measure__c != null && workJob.Mileage_Measure__c != ''){
                    milMeasureUC = workJob.Mileage_Measure__c.toUpperCase();
                }
                UIResp = CSS_WS_BMS.callUnitInbound(workJob.Customer_Code__c,workJob.Unit_Number__c,filterUnitType,workJob.Model__c,workJob.VIN__c,workJob.Make__c,workJob.Service_Model__c,workJob.ESN__c,workJob.Qsol_Engine_Family_Code__c,applicationCode,workJob.Creator_Location__c,milMeasureUC,string.valueof(workJob.Mileage__c),string.valueof(workJob.CSS_Hours__c),(FailureDateForUnitInbound == null ? '' : FailureDateForUnitInbound),(WarrantyStartDateforUnitInbound == null ? '' : WarrantyStartDateforUnitInbound),workJob.AccessCode__c);
                system.debug('UIResp>>>>>>>>'+UIResp);
                if(UIResp.DataArea !=null && UIResp.Header!=null && UIResp.Header.Status!=null && UIResp.Header.Status=='SUCCESS' && UIResp.DataArea.UnitNumber != null && UIResp.DataArea.UnitNumber.trim() != '')
                {
                    workJob.Unit_Number__c= UIResp.DataArea.UnitNumber;//
                    if(workJob.BMSStatus__c !=null && workJob.BMSStatus__c.trim() !=''){
                        workJob.BMSStatus__c = workJob.BMSStatus__c + ','+'UI0';
                    }else {
                        workJob.BMSStatus__c = 'UI0';
                    }
                    system.debug('BMSStatus__c+++++++++++++'+workJob.BMSStatus__c);
                }
                if(UIResp.Header.Status == 'ERROR' || UIResp.Header.Status.trim() == 'ERROR' || (UIResp.DataArea != null && (UIResp.DataArea.UnitNumber == null || UIResp.DataArea.UnitNumber == ''))){ //GSSC-86
                    system.debug('Inside If1**');
                    workJob.isWOServiceFailure__c = true;
                }
            }
            
            if(workJob.Repair_Location__c == 'Mobile'){
                DefaultInshop = 'N';
            }else{DefaultInshop = 'Y';}
             datetime currentDate_Failuredate = System.now();
            String currentTimeZoneInfo = currentDate_Failuredate.format('yyyy-MM-dd\'T\'HH:mm:ss'); //Added 187666 
            String failurDateToString = String.valueOf(workJob.Failure_Date__c);//Added 187666, Modified the Created date to Failure Date to based on story number 182481
            String currentTimeStampVal = currentTimeZoneInfo.Right(8);//Added 187666 
            DateTime currDateTimeInfo  = datetime.valueOf(failurDateToString+' '+currentTimeStampVal);//Added 187666 
            String currDate = currDateTimeInfo.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss'); //Added 187666
            
             //datetime currentDate_Failuredate = System.now(); 
            //datetime currentDate = workJob.Failure_Date__c;
            //string currDate = currentDate.format('YYYY-MM-dd','GMT')+ 'T' + currentDate_Failuredate.format('HH:mm:ss','GMT');
            //datetime promDate = workJob.Date_in_Shop__c;
            //datetime promDate2 = promDate.addhours(12);
            //system.debug('Anirudh myTime>>>>>>>>>>'+promDate2);
            //string prDate =  promDate2.format('YYYY-MM-dd','GMT') + 'T' + promDate2.format('hh:mm:ss','GMT');
            //Call the WO-WOQT Inbound BMS webservice to get the WOReferenceNumber .
            //if(workJob.PSN_Not_Available__c == true)
            //  workJob.Unit_Number__c = '';
            System.debug('Before calling callBMSWOQTInboundService-- QSOL EngineFamilyCode in Repair>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>workJob.Qsol_Engine_Family_Code__c:'+workJob.Qsol_Engine_Family_Code__c);
            if(UIResp.DataArea !=null && UIResp.Header!=null && UIResp.Header.Status!=null && UIResp.Header.Status=='SUCCESS' && UIResp.DataArea.UnitNumber != null && UIResp.DataArea.UnitNumber.trim() != ''){ //GSSC-86, if UnitInbound is success, then only call the WOQT and Comment Services.
            CSS_BMSWOQTInboundJSON2APEX woqtRes = CSS_WS_BMS.callBMSWOQTInboundService(workJob.Name,'WO',workJob.Customer_Code__c,DefaultInshop,currDate,currDate,'Customer',CSS_utility.getSubStringValue(workJob.First_Name__c, 0, 15) + ',' + CSS_utility.getSubStringValue(workJob.BMS_Last_Name__c, 0, 15) ,workJob.Cstmr_Contacts_Phone__c,filterSubType,workJob.Unit_Number__c,workJob.Model__c,workJob.Make__c,workJob.Service_Model__c,workJob.Qsol_Engine_Family_Code__c,workJob.ESN__c,workJob.Application_Desc__c,workJob.Creator_Location__c,(workJob.Contact_ID__c == null ? '' : workJob.Contact_ID__c),(workJob.Email_Address__c == null ? '' : workJob.Email_Address__c),(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'));
            system.debug('woqtRes>>>>>>>>'+woqtRes);
            if(woqtRes.DataArea.WOReferenceNumber != null && woqtRes.DataArea.WOReferenceNumber != '' && woqtRes.DataArea.WOReferenceNumber != '0') // Updated WOReferenceNumber  not equal to null based on the defect number 187062 
                workJob.Shop_Work_Order__c = woqtRes.DataArea.WOReferenceNumber;
            if(woqtRes.DataArea.ContactID != null && woqtRes.DataArea.ContactID != '0')
                workJob.Contact_ID__c = woqtRes.DataArea.ContactID;
            if(woqtRes.DataArea !=null && woqtRes.Header!=null && woqtRes.Header.Status!=null && woqtRes.Header.Status=='SUCCESS' && woqtRes.DataArea.WOReferenceNumber != null && woqtRes.DataArea.WOReferenceNumber.trim() != '0')
            {
                if(workJob.BMSStatus__c !=null && workJob.BMSStatus__c.trim() !=''){
                    workJob.BMSStatus__c = workJob.BMSStatus__c + ','+'WC1';
                }else {
                    workJob.BMSStatus__c = 'WC1';
                }
                system.debug('BMSStatus__c+++++++++++++'+workJob.BMSStatus__c);
            }
           // if(woqtRes.Header.Status=='ERROR')
            if(woqtRes.Header.Status=='ERROR' || woqtRes.Header.Status.trim()=='ERROR' || (woqtRes.DataArea != null && (woqtRes.DataArea.WOReferenceNumber == null || woqtRes.DataArea.WOReferenceNumber == ''))){ //GSSC-86, commented above condition
                workJob.BMSStatus__c = 'WC0';
                workJob.isWOServiceFailure__c = true; //GSSC-86
             }
                //workJob.BMSStatus__c = 'WC0';
            /***** Commenting Below code as it is moved to Job Plan *****/
            
            //  Call the WO Comment Inbound BMS Webservice to update the Comment .
            /*  Comment= cause();
if(workJob.Shop_Work_Order__c !='0'){
CSS_WOCommentInboundJson2Apex woCommentRes = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c,workJob.Name, 'WO', 
workJob.Shop_Work_Order__c, 'CORRECTION' , Comment); 

}   */
            Comment = concatenateStrings();
             if(woqtRes.Header.Status!=null && (woqtRes.Header.Status=='SUCCESS' || woqtRes.Header.Status.trim()=='SUCCESS')){ //GSSC-86
            if(workJob.Shop_Work_Order__c!='0'){
                String Comment1;    
                if(Comment!='' && Comment!=null){
                    Comment1 = Comment.replace('\r\n','\\n');
                    Comment1= Comment1.replace('\n','\\n');
                } 
                System.debug('Comment1*******'+Comment1);
                CSS_WOCommentInboundJson2Apex woCommentRes1 = CSS_WS_BMS.callWOCommentInboundService(workJob.Creator_Location__c,workJob.Name,'WO', 
                                                                                                     workJob.Shop_Work_Order__c, 'COMPLAINT' , Comment1,(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),currDate,currDate);
            }
             }
            }
        }catch(exception ex){
            System.debug('Exception in callCreateWoAndUpdateComment: '+ex.getMessage()+'****'+ex.getLineNumber());
        }
    }
    
    
    public String concatenateStrings(){
        System.debug('entered into concatenateStrings.............');
        return (string.isBlank(workJob.General_Symptoms__c) ? '' : workJob.General_Symptoms__c);
    } 
    
    public String getLocCode() {
        String CreatorLocation;
        if(workJob !=null && workJob.Creator_Location__c !=null && workJob.Creator_Location__c !='')
        {CreatorLocation = workJob.Creator_Location__c;}
        else{
            //User user = css_utility.getUserAttributes(userInfo.getUserId());
            CreatorLocation = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode'); 
        }   
        String LocCode;
        if(CreatorLocation!=null && CreatorLocation!= ''){ 
            system.debug('CreaLocaCode***'+CreatorLocation);
            Integer JobLocLength = CreatorLocation.Length();
            Integer Index = JobLocLength-5;
            system.debug('JobLocLength***'+JobLocLength);
            system.debug('Index***'+Index);
            LocCode = CreatorLocation.substring(Index,CreatorLocation.Length());
            system.debug('JobLocCode***'+LocCode);
        }                         
        return LocCode; 
    } 
    
    public List<SelectOption> getUnitType() {
        List<SelectOption> UnitTypeList; 
        try {
            string strLoc;
            if (Wid == null){
                //Id userId = UserInfo.getUserId();
                //User usr = css_utility.getUserAttributes(userId);
                strLoc = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
            }else 
            {
                strLoc = workJob.Creator_Location__c;
            }
            CSS_JobEventTemporary__c[] lUnitType;
            system.debug('lUnitType***');
            lUnitType=[select Reason__c from CSS_JobEventTemporary__c where attribute1__c='UnitTypes' and Key__c=:strLoc];
            
            map<string, object> mpUnitType=(map<string, object>)JSON.deserializeUntyped(lUnitType[0].Reason__c);
            system.debug('mpUnitType-->'+mpUnitType); 
            
            UnitTypeList = new List<SelectOption>();
            UnitTypeList.add(new SelectOption('','----None----'));
            
            for(string ut: mpUnitType.keyset()){
                //system.debug('ss'+ut+ mpUnitType.get(ut));
                UnitTypeList.add(new SelectOption(ut, (string)mpUnitType.get(ut)));
            }
            
            UnitTypeList.sort();
        }
        catch(exception e)
        {}
        return UnitTypeList;
    }
    public List<SelectOption> getApplicationCodes() { 
        Schema.DescribeFieldResult fieldResult = Css_job_order__c.application_Desc__c.getDescribe();
        List<Schema.PicklistEntry> lstAppValues = fieldResult.getPicklistValues();
        System.debug('Picklist::'+ lstAppValues);
        
        //css_job_order__c c = new css_job_order__c();
        //lstAppValues = getPickLstValues(c,'application__c');
        List<SelectOption> LstAppValues1=new List<SelectOption>();
        LstAppValues1.add(new SelectOption('--None--','--None--'));
        for( Schema.PicklistEntry entry : lstAppValues){
            LstAppValues1.add(new SelectOption(entry.getValue(),entry.getLabel()));
        }
        system.debug('LstAppValues1---->'+LstAppValues1);
        //System.debug(entry.getLabel() +'----->'+ entry.getValue());
        return LstAppValues1;
        
    }
    public List<SelectOption> getSubType() {
        List<SelectOption> SubTypeList; 
        
        try {
            string strLoc;
            if (Wid == null){
                //Id userId = UserInfo.getUserId();
                //User usr = css_utility.getUserAttributes(userId);
                strLoc = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
            }else 
            {
                strLoc = workJob.Creator_Location__c;
            }
            
            system.debug('lSubType Loc-->'+strLoc);
            CSS_JobEventTemporary__c[] lSubType;
            lSubType=[select Reason__c from CSS_JobEventTemporary__c where attribute1__c='SubType' and Key__c=:strLoc];
            
            map<string, object> mpSubType=(map<string, object>)JSON.deserializeUntyped(lSubType[0].Reason__c);
            system.debug('mpSubType-->'+mpSubType); 
            
            SubTypeList = new List<SelectOption>();
            //SubTypeList.add(new SelectOption('','----None----'));
            String defaultValue;
            for(string st: mpSubType.keyset()){
                //system.debug('st'+st+ mpSubType.get(st));
                SubTypeList.add(new SelectOption(st, st + ' - ' + (string)mpSubType.get(st)));
                defaultValue = st = ' - ' + (string)mpSubType.get(st);
                if(defaultValue == 'IS'){
                    filterSubType = defaultValue;
                }
                
            }
            system.debug('inside mpSubType-->' + SubTypeList);
            SubTypeList.sort();
        }
        catch(exception e)
        {
            system.debug('Sub Type error msg'+ e.getMessage());
            
        }
        return SubTypeList;
    }
    //story 86427
    public string bmscustErrorMessage{get;set;}
    public void getBMSCustDetails(){
        //initializing the error block lable 
        
        try{
            if ((workJob.Customer_Name__c!=null && workJob.Customer_Name__c!='') || (workJob.Customer_Code__c!=null && workJob.Customer_Code__c!='')) 
            {
                showOutageError = false; 
                BMSCustSearchPopup=true;
                // To get User Location
                //Id userId = UserInfo.getUserId();
                //User usr = css_utility.getUserAttributes(userId);
                //string usrLoc = (String)Cache.Session.get('local.CSSPartition.UserPrimaryLocationCode');
                customerDetail = new CSS_customerOutboundJSON2Apex();
                
                String custParam = Apexpages.currentPage().getParameters().get('custNameParam');
                system.debug('param value>>>'+custParam);
                
                if(custParam != null && custParam == 'CustomerParam'){
                    workJob.Customer_Code__c = '';
                }
                else{
                    workJob.Customer_Name__c = '';
                }
                
                //workJob.Customer_Code__c workJob.Customer_Name__c
                customerDetail = CSS_WS_BMS.callCustOutboundService(workJob.Customer_Name__c,workJob.Customer_Code__c,workJob.Creator_Location__c);
                system.debug('in intake job customerDetail >>> '+customerDetail );
                if(customerDetail !=null && customerDetail.Header.Status == 'ERROR'){
                    system.debug('system outage error*******>>>');
                    showOutageError = true;
                    if(customerDetail.Header!=null && customerDetail.Header.ReturnCodeDescription == 'Customer not Found'){
                        //errorMessage = 'No data available.  Please create customer account.';
                        bmscustErrorMessage = System.Label.CSS_Cust_No_Data_Available;
                    }
                    else{
                        bmscustErrorMessage = customerDetail.Header.ReturnCodeDescription;
                    }    
                }
                //Checking if there is no Customer records return from the server displaying the message Stroy-7105
                else if(customerDetail != null && customerDetail.DataArea.isEmpty()){
                    system.debug('list is empty popup ******');
                    //CSS_PageErrorHandlingUtility.showInfo('No data available.  Please create customer account.');
                    showOutageError = true;
                    bmscustErrorMessage = System.Label.CSS_Cust_No_Data_Available;
                }else{
                    fullCustDetails = customerDetail.DataArea;
                    paginatedCustDetails = new List<CSS_customerOutboundJSON2Apex.DataArea>();
                    for(Integer i=0;i<1000;i++){
                        if(i<1000)
                            paginatedCustDetails.add(fullCustDetails.get(i));
                    }
                    fullCustDetails = new List<CSS_customerOutboundJSON2Apex.DataArea>(); 
                    customerDetail = null;
                    //trimListSize();                    
                }
            }
        }
        catch(Exception ex){
            System.debug('Excepton in CSS_WS_BMS.callCustOutboundService: '+ex.getMessage());            
        }
    }
    
    
    public void selectedCustDetails(){
        
        BMSCustSearchPopup=false; 
        //system.debug('selectedCustCode: '+selectedCustCode);
        if(selectedCustCode != null && selectedCustCode != ''){
            system.debug('selectedCustCode: '+paginatedCustDetails);
            if ( paginatedCustDetails != null && !paginatedCustDetails.isEmpty() ) {
                for(CSS_customerOutboundJSON2Apex.DataArea dt:paginatedCustDetails){
                    system.debug('inside Loop: '+dt.CustomerCode);
                    if(selectedCustCode == dt.CustomerCode ){                
                        system.debug('inside Loop Id: '+dt.CustomerCode);
                        workJob.Customer_Name__c = dt.CustomerName;
                        workJob.Customer_Code__c = dt.CustomerCode;
                        workJob.Phone_Number__c = '(' + dt.AreaCode + ')' + ' ' + dt.PhoneNumber;
                        // workJob.Contact_Name__c = dt.CustomerName;
                        //workJob.Cstmr_Contacts_Phone__c = 
                        workJob.Address__c = dt.LocationAddressline1 + ' ' + dt.LocationAddressline2 + ' ' + dt.LocationAddressline3;
                        workJob.City__c = dt.City;
                        filterState=dt.State;
                        filterCountry=dt.country;
                        //Added if condition for defect 108703
                        if (dt.country!=null && dt.country!='' && dt.State!=null && dt.State!=''){
                            strCntryState= css_utility.getStateDesc(dt.country,dt.State);}
                        workJob.CSS_State__c = strCntryState;//css_utility.getStdPicklistCode('User', 'Statecode', dt.State, 'LBL'); //dt.State;
                        System.debug('State++++++++'+css_utility.getStateDesc(dt.country,dt.State));
                        workJob.ZipCode__c = dt.Postalcode1;
                        //Added if condition for defect 108703
                        if (dt.country!=null && dt.country !=''){
                            strCntry = css_utility.getCountryDesc(dt.country);}
                        workJob.Country__c = strCntry; //css_utility.getStdPicklistCode('User', 'Countrycode', dt.country, 'LBL');  //'United Sates';//dt.country;
                        workJob.CSS_Charge_Account_Status__c = dt.PaymentType;
                        workJob.First_Name__c = '';
                        workJob.BMS_Last_Name__c = '';
                        workJob.Cstmr_Contacts_Phone__c = '';
                        //workJob.Shop_Work_Order__c
                        workJob.bmsCreateAccount__c = true; 
                        workJob.Unit_Number__c = '';
                    }
                }
                workJob.Contact_ID__c = '';
                system.debug('paginatedCustDetails>>>>>>>>'+paginatedCustDetails);
                paginatedCustDetails.clear();
            }
        }
        selectedCustCode = null;
    }
    
    public void closeBMSCustDetails(){
        BMSCustSearchPopup=false;
        UnitLookUpPopup=false;
        if(paginatedCustDetails != null && !paginatedCustDetails.isEmpty())
            paginatedCustDetails.clear();
    }
    
    public void selectedBMSCustCode(){
        system.debug('selectedCustCode [[[[[[[[[[[[[[[[[[[]]]]]]]]]]]');
        //selectedCustCode = ApexPages.currentPage().getParameters().get('BMSCustCode');
        system.debug('selectedCustCode '+ selectedCustCode);             
    }
    //code for contact look up 
    public Boolean BMSContactSearchPopup{get;set;}
    public Boolean contactshowOutageError {get;set;}
    public string bmsContacterrorMessage {get;set;}
    public CSS_BMSContactLookupResponseJ2A CustomerContactDetails{get;set;}
    public void ContactLookup(){
        system.debug('inside contact look up >>>>>>>');
        BMSContactSearchPopup = true;
        CSS_FN_BMS BMSFunctionality = new CSS_FN_BMS();
        CustomerContactDetails = BMSFunctionality.getBMSContactDetails(workJob.Customer_Code__c, workJob.Creator_Location__c);
        system.debug('response body>>>>CustomerContactDetails'+CustomerContactDetails);
        if(CustomerContactDetails !=null && CustomerContactDetails.Header.Status == 'ERROR'){
            system.debug('system outage error*******>>>');
            contactshowOutageError = true;
            if(CustomerContactDetails.Header!=null && CustomerContactDetails.Header.ReturnCodeDescription == 'Contact not Found'){
                //errorMessage = 'No data available.  Please create customer account.';
                bmsContacterrorMessage = System.Label.CSS_bms_Contact_NotAvailable;
            }
            else{
                bmsContacterrorMessage = CustomerContactDetails.Header.ReturnCodeDescription;
            }    
        }
        //Checking if there is no Customer records return from the server displaying the message Stroy-7105
        else if(CustomerContactDetails != null && CustomerContactDetails.DataArea.isEmpty()){
            system.debug('list is empty popup ******');
            //CSS_PageErrorHandlingUtility.showInfo('No data available.  Please create customer account.');
            contactshowOutageError = true;
            bmsContacterrorMessage = System.Label.CSS_bms_Contact_NotAvailable;
        }
    }
    public String selectedContactID{get;set;}
    public void selectedContactDetails(){
        
        BMSContactSearchPopup=false; 
        //system.debug('selectedContactID: '+selectedContactID);
        if(selectedContactID != null && selectedContactID != ''){
            system.debug('CustomerContactDetails: '+CustomerContactDetails);
            if ( CustomerContactDetails != null) {
                for(CSS_BMSContactLookupResponseJ2A.DataArea dt:CustomerContactDetails.DataArea){
                    if(selectedContactID == dt.ContactID ){                
                        system.debug('inside Loop Id: '+dt.ContactID);
                        workJob.First_Name__c = dt.FirstName;
                        workJob.BMS_Last_Name__c = dt.LastName;
                        workJob.Cstmr_Contacts_Phone__c = '(' + dt.PhoneAreaCode + ')' + ' ' + dt.PhoneNumber;
                        workJob.Contact_ID__c = dt.ContactID;
                        //Prabhakar Added below Code (19/03) for Defect#134296
                        if(dt.Email != null && dt.Email != '' && dt.Email.contains('@')) {
                            string[] emails = dt.Email.split('@');
                            EmailAddress = emails[0];
                            EmailAddress1 = emails[1];
                            workJob.Email_check_box__c = false;
                        }
                        if(dt.Email == null || dt.Email == ''){
                            EmailAddress = '';
                            EmailAddress1 = '';
                            workJob.Email_check_box__c = false;
                        }
                    }
                }
                CustomerContactDetails = null;  
            }
        }
        selectedContactID = null;
        contactshowOutageError = false;
    }
    public void closeBMSContDetails(){
        BMSContactSearchPopup = false;
        contactshowOutageError = false;
    }
    
    map<string,string> mapDescriptionToCode;
    //Methhod to get Application codes and Description values from siebel web service
    
    public List<SelectOption> getApplication() {
        List<SelectOption> lstApplications ; 
        try {
            
            CSS_JobEventTemporary__c[] applicationCodes;
            
            applicationCodes = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'ApplicationCodes'];
            system.debug('applicationCodes>>>'+applicationCodes);
            string jsonResponse = applicationCodes[0].Reason__c;
            CSS_WPR_SBL_ApplicationResJSON resJSON;
            //jsonResponse='{"DataArea": {"Details": [{"ApplicationCode": "123","Description": "abc","BusinessUnit": "EBU","AutomotiveFlag": "Y","MarineFlag": "","ActiveFlag": "N","DefaultUom": "miles"},{"ApplicationCode": "555","Description": "zxcv","BusinessUnit": "PSBU","AutomotiveFlag": "","MarineFlag": "N","ActiveFlag": "Y","DefaultUom": "miles"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
            resJSON = (CSS_WPR_SBL_ApplicationResJSON)JSON.deserialize(jsonResponse ,CSS_WPR_SBL_ApplicationResJSON.class);
            
            //create a map with code and description
            mapDescriptionToCode = new map<string,string>();
            
            lstApplications = new List<SelectOption>();
            lstApplications.add(new SelectOption('','Select One'));
            
            if(resJSON  != null && resJSON.DataArea != null && resJSON.DataArea.Details != null ){
                for(CSS_WPR_SBL_ApplicationResJSON.Details det : resJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.ApplicationCode!='890' && det.ApplicationCode!='891'){
                        lstApplications.add(new SelectOption(det.Description,det.ApplicationCode+' - '+det.Description));
                    }
                    
                    //populating description to code map 
                    mapDescriptionToCode.put(det.Description,det.ApplicationCode);
                }
            }
            
            system.debug('lstApplications>>>'+lstApplications);
            
            lstApplications.sort();
        }
        catch(exception e)
        {}
        return lstApplications;
    }
    
    //Method to get Category values from siebel web service
    Transient  CSS_WPR_SBL_CatComplaintsListResJSON  resCatCompJSON;
    public List<SelectOption> getCategoryList() {
        Transient List<SelectOption> lstCategory; 
        Transient Set<SelectOption> setCategory;
        try {
            
            Transient CSS_JobEventTemporary__c[] Categories;
            
            Categories = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'CategoryComplaintCodes'];
            system.debug('Categories>>>'+Categories);
            string jsonResponse = Categories[0].Reason__c;
            
            //jsonResponse='{"DataArea": {"Details": [{"ComplaintCode": "123","Description": "abc","BusinessUnit": "EBU","ActiveFlag": "Y","Category": "aaa"},{"ComplaintCode": "345","Description": "tavdg","BusinessUnit": "PSBU","ActiveFlag": "N","Category": "bbb"}]},"Header": {"ReturnCodeDescription": "","Status": "Success"}}';
            resCatCompJSON = (CSS_WPR_SBL_CatComplaintsListResJSON )JSON.deserialize(jsonResponse ,CSS_WPR_SBL_CatComplaintsListResJSON .class);
            
            lstCategory = new List<SelectOption>();
            setCategory= new Set<SelectOption>();
            lstCategory.add(new SelectOption('','----None----'));
            
            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y'){
                        
                        //lstCategory.add(new SelectOption(det.Category,det.Category));
                        setCategory.add(new SelectOption(det.Category,det.Category));
                        
                    }
                }
                lstCategory.addAll(setCategory);
            }
            
            system.debug('lstCategory>>>'+lstCategory);
            
            //lstCategory.sort();
        }
        catch(exception e)
        {}
        return lstCategory;
    }
    
    //Method to get Complaint Type values from siebel web service
    public List<SelectOption> getComplaintTypeList() {
        List<SelectOption> lstComplaint; 
        try {
            
            system.debug('filterCategory>>>'+filterCategory);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);
            
            lstComplaint = new List<SelectOption>();
            lstComplaint.add(new SelectOption('','----None----'));
            
            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    system.debug('det.Category*>>>'+det.Category);
                        system.debug('det.ActiveFlag*>>>'+det.ActiveFlag);
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory){
                        lstComplaint.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }
            
            system.debug('lstComplaint>>>'+lstComplaint);
            
            lstComplaint.sort();
        }
        catch(exception e)
        {}
        return lstComplaint;
    }
    
    //Method to get Complaint Type2 values from siebel web service
    public List<SelectOption> getComplaintTypeList2() {
        List<SelectOption> lstComplaint2; 
        try {
            
            system.debug('filterCategory2>>>'+filterCategory2);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);
            
            lstComplaint2 = new List<SelectOption>();
            lstComplaint2.add(new SelectOption('','----None----'));
            
            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory2){
                        lstComplaint2.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }
            
            system.debug('lstComplaint2>>>'+lstComplaint2);
            
            lstComplaint2.sort();
        }
        catch(exception e)
        {}
        return lstComplaint2;
    }
    
    //Method to get Complaint Type3 values from siebel web service
    public List<SelectOption> getComplaintTypeList3() {
        List<SelectOption> lstComplaint3; 
        try {
            
            system.debug('filterCategory3>>>'+filterCategory3);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);
            
            lstComplaint3 = new List<SelectOption>();
            lstComplaint3.add(new SelectOption('','----None----'));
            
            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory3){
                        lstComplaint3.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }
            
            system.debug('lstComplaint3>>>'+lstComplaint3);
            
            lstComplaint3.sort();
        }
        catch(exception e)
        {}
        return lstComplaint3;
    }
    
    //Method to get Complaint Type4 values from siebel web service
    public List<SelectOption> getComplaintTypeList4() {
        List<SelectOption> lstComplaint4; 
        try {
            
            system.debug('filterCategory4>>>'+filterCategory4);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);
            
            lstComplaint4 = new List<SelectOption>();
            lstComplaint4.add(new SelectOption('','----None----'));
            
            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory4){
                        lstComplaint4.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }
            
            system.debug('lstComplaint4>>>'+lstComplaint4);
            
            lstComplaint4.sort();
        }
        catch(exception e)
        {}
        return lstComplaint4;
    }
    
    //Method to get Complaint Type5 values from siebel web service
    public List<SelectOption> getComplaintTypeList5() {
        List<SelectOption> lstComplaint5; 
        try {
            
            system.debug('filterCategory5>>>'+filterCategory5);
            system.debug('resCatCompJSON>>>'+resCatCompJSON);
            
            lstComplaint5 = new List<SelectOption>();
            lstComplaint5.add(new SelectOption('','----None----'));
            
            if(resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null){
                for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                    if(det.ActiveFlag == 'Y' && det.Category == filterCategory5){
                        lstComplaint5.add(new SelectOption(det.Description,det.Description));
                    }
                }
            }
            
            system.debug('lstComplaint5>>>'+lstComplaint5);
            
            lstComplaint5.sort();
        }
        catch(exception e)
        {}
        return lstComplaint5;
    }
    
    //story 86427  
    
    
    public string sEncryptToken {get; set;}
    public string sEndPoint {get; set;}
    public Integer statusCode {get;set;}
    public String statusMessage{get;set;}
    public String sFileName{get;set;}
    public String attachId{get;set;}
    
    //########### New Azure Insite Images Code Start ################
    public void getFile(){
        System.debug('in getFile method...');
        css_utility utilityObj;
        try{
            //I-20190609-111230668-EB2C1D72.eif 
            //I-20190601-121230702-EB2C1D84.eif 
            //SI-20190501-101230703-EB2C1D90.eif 
            //I-20190121-211426769-EB2C1D71.eif 
            String sFileName = Apexpages.currentPage().getParameters().get('fileName');
            utilityObj = new css_utility();
            //attachId = utilityObj.getInsiteImageAzureFile(sFileName, Wid);
            List<String> outputs = utilityObj.getInsiteImageAzureFile(sFileName, Wid);
            attachId = outputs.get(0);
            statusCode = Integer.valueOf(outputs.get(1));
            
        }catch(exception ex) {
            System.debug('in catch of getFile of css_tnd_job>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        utilityObj = null; //nullifying after completion of operation to clear memory for performance
    }
    //########### New Azure Insite Images Code End
    
    
    public void blankUnitonCustCodeChange(){
        system.debug('Anirudh workJob.Customer_Code__c>>>>>>'+workJob.Customer_Code__c);
        if(workJob.Customer_Code__c == null || workJob.Customer_Code__c == '')
            workJob.Unit_Number__c = '';
        system.debug('Anirudh workJob.Unit_Number__c>>>>>>'+workJob.Unit_Number__c);
    }
    
    
    //added by venkat for defect 135781
    /*public transient List<CSS_Solution_Component__c> compList = new List<CSS_Solution_Component__c>();
    public void jobPlanAction(){ //Commented this, as we moved it to RJ Pages . Story 190513
        try{
            system.debug('In SRT field Action Call Method - Repair RJ');
            compList = [SELECT Id, Component_Id__c, Type__c,Performed_Review__c,Service_Job__c FROM CSS_Solution_Component__c WHERE (Type__c = 'ATC' OR Type__c = 'Campaign' OR Type__c = 'TRP') AND Performed_Review__c = true AND Service_Job__c=:Wid];
            //Field Action SRT callout
            List<CSS_SRT__c> srtsListTemp = new List<CSS_SRT__c>([Select Id from CSS_SRT__c where Job_Order__c =: Wid and (Type__c = 'Field Action' OR Type__c = 'Field Action Access')]);          
            system.debug('srtsListTemp--'+srtsListTemp.size());
            if(srtsListTemp != null && srtsListTemp.size()==0 && compList !=null && compList.size()>0)
                CG_BL_Campaigns.callFieldActionSRT(compList,Wid);
            
            
        }catch(exception e){
            system.debug('exception in jobplanaction with the error ' + e.getMessage() + ' at the line ' + e.getLineNumber());
        }  
    }*/
    
         public void updateproductappcode(){
        system.debug('in updateproductappcode method ');
        prodcodeErrormessage = false ;
        workJob.ProductAppcodeErrorflag__c=false;
        system.debug('productAppdesc '+ productAppdesc);
        system.debug('productAppcode' +productAppcode);
        system.debug('mainContr.workJob.ProductApplicationDesp__c '+ workJob.ProductApplicationDesp__c);
        system.debug('mainContr.ProductApplicationCode__c' +workJob.ProductApplicationCode__c);
         if(workJob.ESN__c!='' && workJob.ESN__c!=null) {
        if(filterApplication== ''||filterApplication== null || filterApplication== 'Select One'){
            system.debug('filterApplication'+filterApplication);
        prodcodeErrormessage = false;
        workJob.ProductAppcodeErrorflag__c=false;
        }else{
        List<SelectOption> applicationlist = getApplication();
        String filterLabel;
        String appCode;
        system.debug('applicationlist'+ applicationlist);
        if(applicationlist.size()>0){
            for(SelectOption sopt: applicationlist){
                if(sopt.getValue()==filterApplication){
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
            JETproductcode = [select id, Attribute1__c, Attribute2__c,Attribute3__c, Attribute5__c, Active__c,Key__c from CSS_JobEventTemporary__c  where Key__c = 'MarketingApplicationCodes' and   Attribute1__c =: workJob.ProductApplicationCode__c and Attribute3__c=: workJob.ProductApplicationDesp__c Limit 1];
            system.debug('JETproductcode'+ JETproductcode);
            system.debug('JETproductcode.Attribute2__c'+ JETproductcode.Attribute2__c);
            system.debug('filterApplication'+ filterApplication);
            system.debug('JETproductcode.Attribute5__c'+ JETproductcode.Attribute5__c);
            system.debug('appCode'+ appCode);

            if(JETproductcode.Attribute2__c != appCode || JETproductcode.Attribute5__c != filterApplication){
                try{
                    JETproductcode1 = [select id, Attribute1__c, Attribute2__c,Attribute3__c, Attribute5__c, Active__c,Key__c from CSS_JobEventTemporary__c  where Key__c = 'MarketingApplicationCodes' and   Attribute2__c =: appCode and Attribute5__c=: filterApplication Limit 1];
                    system.debug('JETproductcode1'+ JETproductcode1);
                    prodcodeErrormessage = true;

                   workJob.ProductAppcodeErrorflag__c=true;
                }catch(Exception err) {
                    prodcodeErrormessage = false;
                    system.debug(' inside EXC ');
                    workJob.ProductAppcodeErrorflag__c=false;
                }

            }
            else{
                prodcodeErrormessage = false ;
                system.debug(' inside else main EXC');
               workJob.ProductAppcodeErrorflag__c=false;

            }
            filterModel= workJob.Model__c;
            filterMake= workJob.Make__c;
        }
        catch(Exception ex ){
            prodcodeErrormessage = false ;
            system.debug(' inside main EXC');
            workJob.ProductAppcodeErrorflag__c=false;
        }
    }
         }          
    }
    
    
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