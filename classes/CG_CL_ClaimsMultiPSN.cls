/**********************************************************************
Name:CG_CL_ClaimsMultiPSN
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                    
-------  
We are using this Page Controller for Claims Multi PSN  Chevron.
======================================================
======================================================
History                                                            
-------                                                            
VERSION             AUTHOR                        DATE                  DETAIL                                 
1.0 -   Rajesh Pasupuleti/Surender M/Kalpana      8/20/2018           INITIAL DEVELOPMENT & MultiPSN functionalities
***********************************************************************/
public class CG_CL_ClaimsMultiPSN{

    public CG_CL_ClaimsMultiPSN controllerRef{get;set;}
    public Id cId{get;set;}
    public CSS_Claims__c claimsRec{set;get;}
    public CSS_PSN__c psnRec{set;get;}
    public List<MultiPSNWrapper> lstMPSNWrapper {get;set;}
    public List<MultiPSNWrapper> lstMPSNWrapper2 {get;set;}
    public Set<MultiPSNWrapper> setMPSNWrapper {get;set;}
    public List<CSS_PSN__c> lstPSNrec {get;set;}
    public Map<Id, String> removeIdsMap = new Map<Id, String>();
    public integer selectedRemoveRow {get;set;}
    public Integer assignedParts{get;set;}
    public String selectedPSN {get;set;}
    public String selectedMIKMHR {get;set;}
    public Integer selectedRowNo {get;set;}
    public Boolean selectedBIS {get;set;}
    public Boolean multiPSNErrorMsg{get;set;}
    public Boolean multiPSNRedBorder{get;set;}
    public String selectedWSD {get;set;}
    public String errorMsg {get;set;}
    public String errorMsg_test {get;set;}
    //public List<CSS_Solution_Component__c> solComps;
    public Boolean mandateBool {get;set;}
    public Boolean blankField {get;set;}
    public Boolean ErrorMessage {get;set;}
    public Boolean WSDErrorMessage {get;set;}
    public Set<String> psnSet;
    public string validationBIS{get; set;}
    public string datebyLocaleValue {get;set;}
    public Boolean mPsnROFlag {get;set;}
    public Boolean failureerror {get;set;}
    public CG_PACCAR_Flag_SP_Info_Mapping__c paccarCustomSettingValues {get;set;}
    //Constructor.
    public CG_CL_ClaimsMultiPSN()
    {
        selectedMIKMHR='MI';
        datebyLocaleValue = css_utility.getFormattedDate();
        system.debug('datebyLocaleValue**'+datebyLocaleValue);
        System.debug('IN CG_CL_ClaimsWarranty constructor...');
        //errorMsg = 'TestError';
        ErrorMessage = false;
        failureerror=false;
        multiPSNErrorMsg=false;
        multiPSNRedBorder=false;
        blankField = false;
        validationBIS='';
        lstPSNrec = new List<CSS_PSN__c>();
        psnSet = new Set<String>();
        try {
            controllerRef = this;
            cId=ApexPages.CurrentPage().getParameters().get('Id');
            system.debug('MyClaimId**'+cId);
            if(cId == null){
                claimsRec = new CSS_Claims__c();
                psnRec = new CSS_PSN__c();
            }else{
                claimsRec =[Select Id, Failures_ODM_Status__c,IsCopyclaim__c,isAutomatedCopyClaim__c,Parts_ODM_Status__c, SRTs_ODM_Status__c, ODM_Status__c, Territory_Class__c, FieldActionWebServiceResult__c, CSS_Channel_Code__c, SP_PACCAR__c, PACCAR_Flag__c, Css_paccar_approve_reject_flag__c, PACCAR_Auth_Required__c, Customer_Name__c,ReconEngineFlag__c, Location__c,Dealer_Service_Job__r.Name,Location_Code__c,Information_Only_Claim__c,Multi_PSN_Claim__c,CSS_Job__c,CSS_Job__r.name,CSS_Job__r.createddate,Shop_Work_Order__c,CreatedDate,LastModifiedDate,Name,Region__c,Territory__c,CoverageResponse__c,Status__c,Account__r.type,Catastrophic__c,IsDealerCreatedClaim__c,
                            (Select Id,Name,PSN__c,Service_Model__c,Application__c,ApplicationCode__c,Failure_Date__c,Failure_Point__c,Mileage__c,Mileage_Measure__c,
                             Calibration_After__c,Calibration_Before__c,VIN__c,Before_In_Service__c,Primary__c,
                             Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c, PACCAR_Flag__c 
                             from CSS_PSNs__r 
                             where Primary__c=true Limit 1) 
                            from CSS_Claims__c
                            where id= :cId];

                if(claimsRec.CSS_PSNs__r != null && !claimsRec.CSS_PSNs__r.isEmpty() && claimsRec.CSS_PSNs__r.size()>0) {
                    psnRec = claimsRec.CSS_PSNs__r.get(0);
                    psnSet.add(psnRec.PSN__c);
                }else
                    psnRec = new CSS_PSN__c(); 
                //mil_measure = psnRec.Mileage_Measure__c;  //need to delete this
                system.debug('claimsRec>>>>:'+claimsRec);
                system.debug('claimsRec.Region'+claimsRec.Region__c);
                system.debug('claimsRec.Territory'+claimsRec.Territory__c);
                system.debug('psnRec>>>>:'+psnRec);
            }
            //code for MPSN Read Only Page story 171834
            UserRole urRole;
            system.debug('UserInfo.getUserRoleId()**'+UserInfo.getUserRoleId());
            if(UserInfo.getUserRoleId()!=null)
                urRole = [Select name from UserRole where id=:UserInfo.getUserRoleId()];
            system.debug('urRole**'+urRole);

            boolean DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type);

            if(claimsRec != null  && DealerTypeFlag==true && urRole != null && urRole.name != 'Factory'&& claimsRec.Catastrophic__c == true){
                mPsnROFlag = true;  
            }


            //Code for mandatory fields story 155733
            //solComps = new List<CSS_Solution_Component__c>();
            mandateBool = false;
            //story 173516, to skip Warranty AuthFlag Validation for InfoOnly Claims
            if(claimsRec.Information_Only_Claim__c && claimsRec.IsDealerCreatedClaim__c)
                mandateBool = false;
            else{
                //Calibration fields error message logic below - GSSC-30
                /*List<CSS_SRT__c> ecmFlagSRTList = new List<CSS_SRT__c>([select Id, ECM_Flag__c, isPerformed__c, SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =:cId and ECM_Flag__c = true and (isPerformed__c=true or SRT_AccessiblityCheck__c=true) Limit 1]);
                if(ecmFlagSRTList !=null && ecmFlagSRTList.size()>0){
                    mandateBool = true;
                }*/

                //Below code is needed to remove as per GSS-30
                /*if(!Test.isRunningTest()){
                    solComps = [select Id, Claim_FailCode__c,Fail_Code__c,type__c,Selected_Component__c from CSS_Solution_Component__c where CSS_Claims__c =:claimsRec.id  AND ((Type__c NOT IN ('TSB','TRP','Campaign','CAM','ATC') AND Selected_Component__c = true) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved' AND Selected_Component__c = true))];
                }else{
                    solComps = [select Id, Claim_FailCode__c,Fail_Code__c,type__c,Selected_Component__c from CSS_Solution_Component__c where CSS_Claims__c =:claimsRec.id  AND ((Type__c NOT IN ('TSB','TRP','Campaign','CAM','ATC') AND Selected_Component__c = true) OR (Type__c IN ('Campaign','ATC') AND Status__c='Approved' AND Selected_Component__c = true)) limit 500];
                }
                system.debug('solComps'+solComps);
                if(solComps != null && solComps.Size()>0){
                    for(css_solution_component__c SC: solComps){
                        system.debug('SC**'+SC);
                        system.debug('SC.FailCode**'+SC.Fail_Code__c);
                        system.debug('SC.Claim_FailCode__c**'+SC.Claim_FailCode__c);
                        if(SC.type__c == 'Campaign' || SC.type__c == 'CAM' || SC.type__c == 'ATC'){
                            if((SC.Fail_Code__c != null && SC.Fail_Code__c != '') && SC.Fail_Code__c.substring(0,2) == 'EQ' || SC.Fail_Code__c.substring(0,3) == 'WEQ')
                                mandateBool = true;
                            //break;
                        }
                        else{
                            if((SC.Claim_FailCode__c != null && SC.Claim_FailCode__c != '') && SC.Claim_FailCode__c.substring(0,2) == 'EQ' || SC.Claim_FailCode__c.substring(0,3) == 'WEQ')
                                mandateBool = true;
                            // break;
                        }
                        break;

                    }
                }*/
            }
            system.debug('mandatebool'+mandateBool);
            buildMPSNWrapper();

        }
        catch(Exception e)  
        {
            system.debug('EXCEPTION of CG_CL_ClaimsMultiPSN constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('returning from CG_CL_ClaimsMultiPSN constructor...');


        //Code to populate Region and territory
        //Account RegionTerritory = css_utility.getRegionTerritory((claimsRec ==null ? '': claimsRec.Location_Code__c));
        //System.debug('REGION-R'+RegionTerritory.Region__c);
        //System.debug('REGION-T'+RegionTerritory.Territory__c);
    }

    public void buildMPSNWrapper(){
        //Building MPSN Wrapper
        // 1.Query the Exissting DAta and build wrapper
        // //   2.Empty Wrapper
        lstMPSNWrapper = new List<MultiPSNWrapper>();
        setMPSNWrapper = new Set<MultiPSNWrapper>();
        lstPSNrec = new List<CSS_PSN__c>([Select Id,Name,Failure_Point__c,PSN__c,VIN__c,Service_Model__c,Application__c,Failure_Date__c,Mileage__c,Mileage_Measure__c,Revision_After__c,Revision_Before__c,
                                          Before_In_Service__c,Calibration_After__c,Calibration_Before__c,Warranty_Start_Date__c,Product_Hours__c,CoverageFlag__c, CSS_Claims__c from CSS_PSN__c where css_claims__c = :cId and primary__c != true]);
        system.debug('lstPSNrec>>>>+++!!+!!'+lstPSNrec);
        if(lstPSNrec.size()>0){
            Boolean isSiebWSD = false;
            for(integer i=0;i<lstPSNrec.size();i++){
                //setMPSNWrapper.add(new MultiPSNWrapper(i,lstPSNrec[i].id,lstPSNrec[i].Psn__c,'',lstPSNrec[i].Warranty_Start_Date__c,lstPSNrec[i].Before_In_Service__c,lstPSNrec[i].VIN__c,lstPSNrec[i].Calibration_Before__c,lstPSNrec[i].Revision_Before__c,lstPSNrec[i].Calibration_After__c,lstPSNrec[i].Revision_After__c,false,false,false));
                if(lstPSNrec[i].Warranty_Start_Date__c !=null)
                    isSiebWSD = true;
                if(lstPSNrec[i].Mileage_Measure__c=='MI'){
                    selectedMIKMHR='MI';
                }
                else if(lstPSNrec[i].Mileage_Measure__c=='KM'){
                    selectedMIKMHR='KM';
                }
                else if(lstPSNrec[i].Mileage_Measure__c=='HR'){
                    selectedMIKMHR='HR';
                }
                Boolean blankField = false;
                if(((lstPSNrec[i].Calibration_Before__c == null || lstPSNrec[i].Calibration_Before__c == '') || (lstPSNrec[i].Revision_Before__c == null || lstPSNrec[i].Revision_Before__c == '') || 
                    (lstPSNrec[i].Calibration_After__c == null || lstPSNrec[i].Calibration_After__c == '') || (lstPSNrec[i].Revision_After__c == null || lstPSNrec[i].Revision_After__c == ''))){
                    system.debug('wrapper inside if psnlist.blankField');
                    List<CSS_SRT__c> ecmFlagSRTList = new List<CSS_SRT__c>([select Id, ECM_Flag__c, isPerformed__c, SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =:cId and ECM_Flag__c = true and (isPerformed__c=true or SRT_AccessiblityCheck__c=true) Limit 1]);
                    if(ecmFlagSRTList !=null && ecmFlagSRTList.size()>0){
                        mandateBool = true;
                        blankField = true;
                    }
                }
                setMPSNWrapper.add(new MultiPSNWrapper(i,lstPSNrec[i].id,lstPSNrec[i].Psn__c,lstPSNrec[i].Failure_Point__c,FormatDate(lstPSNrec[i].Warranty_Start_Date__c),lstPSNrec[i].Before_In_Service__c,lstPSNrec[i].VIN__c,lstPSNrec[i].Calibration_Before__c,lstPSNrec[i].Revision_Before__c,lstPSNrec[i].Calibration_After__c,lstPSNrec[i].Revision_After__c,blankField,false,false,isSiebWSD,false,null,false,false));
                //setMPSNWrapper.add(new MultiPSNWrapper(i,lstPSNrec[i].id,lstPSNrec[i].Psn__c,'',string.valueof(lstPSNrec[i].Warranty_Start_Date__c),lstPSNrec[i].Before_In_Service__c,lstPSNrec[i].VIN__c,lstPSNrec[i].Calibration_Before__c,lstPSNrec[i].Revision_Before__c,lstPSNrec[i].Calibration_After__c,lstPSNrec[i].Revision_After__c,false,false,false,isSiebWSD,false,null,false));
                psnSet.add(lstPSNrec[i].Psn__c); //adding all PSNs
            }
            if(lstPSNrec.size()<=9) {
                system.debug('lstPSNrec.size()>>>>+++!!+!!'+lstPSNrec.size());
                for(integer i=0;i<10-lstPSNrec.size();i++){
                    CSS_Psn__c  newPsn =  new CSS_Psn__c();
                    newPsn.psn__c = '';
                    newPsn.Warranty_Start_Date__c = null ;
                    newPsn.Before_In_Service__c = false;
                    newPsn.VIN__c = '';
                    newPsn.Calibration_Before__c = null;
                    newPsn.Calibration_After__c = '';
                    newPsn.Revision_After__c = '';
                    newPsn.Revision_Before__c = null;
                    try{
                        setMPSNWrapper.add(new MultiPSNWrapper(lstPSNrec.size()+i,null,newPsn.PSN__c,'',String.valueOf(newPsn.Warranty_Start_Date__c),newPsn.Before_In_Service__c,newPsn.VIN__c,newPsn.Calibration_Before__c,newPsn.Revision_Before__c,newPsn.Calibration_After__c,newPsn.Revision_After__c,false,false,false,false,false,null,false,false));
                    }catch(Exception ex){
                        System.debug('in catch of getallCustomPartsData1 of CSS_GSQParts adding wrapper>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                    }
                    System.debug('setMPSNWrapper>>>:'+setMPSNWrapper);
                }
                system.debug('lstPSNrec>>>>>>>>>>:'+lstPSNrec);
            }
            system.debug('setMPSNWrapper exist>>>>>>>>>>:'+setMPSNWrapper);
        }else{
            system.debug('Inside else');
            for(integer i=0;i<10;i++){
                CSS_Psn__c  newPsn =  new CSS_Psn__c();
                newPsn.psn__c = '';
                newPsn.Warranty_Start_Date__c = null ;
                newPsn.Before_In_Service__c = false;
                newPsn.Calibration_Before__c = null;
                newPsn.Calibration_After__c = '';
                newPsn.Revision_After__c = '';
                newPsn.Revision_Before__c = null;
                try{
                    setMPSNWrapper.add(new MultiPSNWrapper(lstPSNrec.size()+i,null,newPsn.Psn__c,'',String.valueOf(newPsn.Warranty_Start_Date__c),newPsn.Before_In_Service__c,newPsn.VIN__c,newPsn.Calibration_Before__c,newPsn.Revision_Before__c,newPsn.Calibration_After__c,newPsn.Revision_After__c,false,false,false,false,false,null,false,false));
                }catch(Exception ex){
                    System.debug('in catch of MPSNWrapper Block>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                }
            }
            system.debug('setMPSNWrapper else>>>>>>>>>>:'+setMPSNWrapper);
        }
        if(setMPSNWrapper.size()>0){
            lstMPSNWrapper.addAll(setMPSNWrapper);
            system.debug('lstMPSNWrapper>>>>>>>'+lstMPSNWrapper.size());
        }
    }

    //Naviagation to Warranty Coverage.
    public PageReference nvClaimsIntake(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsIntake'); 
        }else{
            //saveMPSNRecords(); //Allowing user to navigate to Warranty Overview, though there are errors on Multi-PSN chev, as the user might want to uncheck the Mulit-PSN check box.
            CampaignsWSCall();
            saveMPSNRecords();
            if((errorMsg==null || errorMsg=='') && failureerror==false){
                pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId);}
            else{
                String chevError = Label.CSS_Please_correct_the_errors_before_proceeding+'<br/>';
                chevError = chevError + errorMsg;
                errorMsg = chevError;
                return null;
            }
        }
        return pageRef;
    }

    //Naviagation to Failures and Campaigns.
    public PageReference nvClaimsWC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsWarranty'); 
        }else{
            CampaignsWSCall();
            saveMPSNRecords();
            if((errorMsg==null || errorMsg=='') && failureerror==false){
                pageRef = new pageReference('/apex/CG_ClaimsWarranty?id='+cId);}
            else{
                String chevError = Label.CSS_Please_correct_the_errors_before_proceeding+'<br/>';
                chevError = chevError + errorMsg;
                errorMsg = chevError;
                return null;
            }
        }
        return pageRef;
    }

    //Naviagation to View History.
    public PageReference nvClaimsVH(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVH'); 
        }else{
            CampaignsWSCall();
            saveMPSNRecords();
            if((errorMsg==null || errorMsg=='') && failureerror==false){
                pageRef = new pageReference('/apex/CG_ClaimsVH?id='+cId);} 
            else{
                String chevError = Label.CSS_Please_correct_the_errors_before_proceeding+'<br/>';
                chevError = chevError + errorMsg;
                errorMsg = chevError;
                return null;
            }
        }
        return pageRef;
    }

    //Naviagation to Customer Complaint.
    public PageReference nvClaimsCC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsCC'); 
        }else{
            CampaignsWSCall();
            saveMPSNRecords();
            if((errorMsg==null || errorMsg=='') && failureerror==false){
                pageRef = new pageReference('/apex/CG_ClaimsCC?id='+cId); }
            else{
                String chevError = Label.CSS_Please_correct_the_errors_before_proceeding+'<br/>';
                chevError = chevError + errorMsg;
                errorMsg = chevError;
                return null;
            } 
        }
        return pageRef;
    }

    //Naviagation to Failures and Campaigns.
    public PageReference nvClaimsFC(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsFC'); 
        }else{
            CampaignsWSCall();
            saveMPSNRecords();
            if((errorMsg==null || errorMsg=='') && failureerror==false){
                pageRef = new pageReference('/apex/CG_ClaimsFC?id='+cId);} 
            else{
                String chevError = Label.CSS_Please_correct_the_errors_before_proceeding+'<br/>';
                chevError = chevError + errorMsg;
                errorMsg = chevError;
                return null;
            } 
        }
        return pageRef;
    }

    //Naviagation to Parts and Other Claimbles.
    public PageReference nvClaimsPOC(){
        // ValidationPSN();
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            //ErrorMessage = true;
            pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles'); 
        }else{
            CampaignsWSCall();
            saveMPSNRecords();
            if((errorMsg==null || errorMsg=='') && failureerror==false){

                pageRef = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId); 
            }
            else{
                String chevError = Label.CSS_Please_correct_the_errors_before_proceeding+'<br/>';
                chevError = chevError + errorMsg;
                errorMsg = chevError;
                return null;
            }
        }      
        return pageRef;
    }

    //Naviagation to SRTs.
    public PageReference nvClaimsSRTs(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsSRTs'); 
        }else{
            CampaignsWSCall();
            saveMPSNRecords();
            if((errorMsg==null || errorMsg=='') && failureerror==false){
                pageRef = new pageReference('/apex/CG_ClaimsSRTs?id='+cId);} 
            else{
                String chevError = Label.CSS_Please_correct_the_errors_before_proceeding+'<br/>';
                chevError = chevError + errorMsg;
                errorMsg = chevError;
                return null;
            } 
        }
        return pageRef;
    }

    //Naviagation to Job Notes.
    public PageReference nvClaimsJobNotes(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsJobNotes'); 
        }else{
            CampaignsWSCall();
            saveMPSNRecords();
            if((errorMsg==null || errorMsg=='') && failureerror==false){
                pageRef = new pageReference('/apex/CG_ClaimsJobNotes?id='+cId);}
            else{
                String chevError = Label.CSS_Please_correct_the_errors_before_proceeding+'<br/>';
                chevError = chevError + errorMsg;
                errorMsg = chevError;
                return null;
            }
        }
        return pageRef;
    }

    //Naviagation to Verify and Submit
    public PageReference nvClaimsVS(){
        PageReference pageRef;
        //cId = saveClaim(cId, 'Draft');

        if(cId==null){
            pageRef = new pageReference('/apex/CG_ClaimsVS'); 
        }else{
            CampaignsWSCall();
            saveMPSNRecords();
            if((errorMsg==null || errorMsg=='') && failureerror==false){
                pageRef = new pageReference('/apex/CG_ClaimsVS?id='+cId);}
            else{
                String chevError = Label.CSS_Please_correct_the_errors_before_proceeding+'<br/>';
                chevError = chevError + errorMsg;
                errorMsg = chevError;
                return null;
            }        
        }
        return pageRef;
    }

    //Bottom save button
    public PageReference pgSave(){


        //ValidationPSN();
        PageReference returnPage;
        system.debug('*****Inside pgSave Method**'+lstMPSNWrapper); 
        system.debug('*****SAVe Size**'+lstMPSNWrapper.size());
        saveMPSNRecords();
        system.debug('**** after save errorMsg>>:'+errorMsg);
        system.debug('**** failureerror after save errorMsg>>:'+failureerror);
        if((errorMsg==null || errorMsg=='') ){
            returnPage = new PageReference('/apex/CG_ClaimsMultiPSN?id='+cId);
            returnPage.setRedirect(true);
            return returnPage;
        }else
            return null;
    }


    //Bottom save button
    public PageReference pgSave_Old()
        // public void pgSave()
    {
        //ValidationPSN();
        PageReference ReturnPage;
        system.debug('*****Inside Save Method**'+lstMPSNWrapper); 
        system.debug('*****SAVe Size**'+lstMPSNWrapper.size());
        for(integer k=0;k<lstMPSNWrapper.size();k++){
            if(lstMPSNWrapper[k].PSN != null && lstMPSNWrapper[k].PSN != ''){
                ErrorMessage = false;
                //return null;
                break;
            }
            else{
                ErrorMessage = true;
                errorMsg=Label.CSS_Enter_at_least_one_Product_Serial_Number;
                //return null;
            }
        }
        system.debug('ErrorMessage**'+ErrorMessage);
        //CreateMPSN();

        if(ErrorMessage == false)           
            saveMPSNRecords();

        system.debug('ErrorMessage>>:'+ErrorMessage+' errorMsg>>:'+errorMsg);
        if((errorMsg==null || errorMsg=='') && ErrorMessage==false){
            ReturnPage = new PageReference('/apex/CG_ClaimsMultiPSN?id='+cId);
            ReturnPage.setRedirect(true);
            return ReturnPage;
        }
        else
            return null;
    }

    //Method for saving the MPSN Records
    public CSS_PSN__c psnDetails2 {get;set;}
    public List<CSS_PSN__c> lstpsnDetails {get;set;}
    //Method for delete the MPSN records
    public void deleteMPSN(){
        System.debug('in delete MPSN');
        try{
            List<CSS_PSN__c> toDeletempsnList = new list<CSS_PSN__c>();
            List<CSS_PSN__c> deletempsnList   = new List<CSS_PSN__c>(
                [select Id,Name,PSN__c,VIN__c,Service_Model__c,Revision_After__c,Revision_Before__c,Before_In_Service__c,Calibration_After__c,Calibration_Before__c,Warranty_Start_Date__c, CSS_Claims__c 
                 from CSS_PSN__c                           
                 where Id in:removeIdsMap.keySet()]);
            if(deletempsnList.size()>0){
                for(CSS_PSN__c Dpsn: deletempsnList){
                    for(MultiPSNWrapper  mpsnlist:lstMPSNWrapper ){
                        if(Dpsn.id==mpsnlist.ids){  
                            toDeletempsnList.add(Dpsn); 
                            System.debug('delete list');}
                        else{
                        }

                    }     
                }
                if(toDeletempsnList.size()>0)
                    delete toDeletempsnList;
            }
            removeIdsMap = new Map<Id, String>();
        }catch(Exception ex) {
            System.debug('in catch of delete MPSN>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    //End 


    //Method to save the part's records from Popup
    public void saveMPSNRecords(){
        system.debug('Inside saveMPSNRecords Method');
        system.debug('Inside WSDErrorMessage'+WSDErrorMessage);
        Integer count =0; 
        Boolean errorExists = false;
        failureerror=false;
        errorMsg = '';
        mandateBool = false;
        set<boolean> tempfailcheck=new set<boolean>();
        List<CSS_PSN__c> selectedMPSNList = new list<CSS_PSN__c>();
        try{
            system.debug(' count'+count);
            system.debug('wrapper sizeb'+lstMPSNWrapper.size());        
            System.debug('removeIdsMap.keySet().size>>>>>>:'+removeIdsMap.keySet().size());
            System.debug('The lstMPSNWrapper savelist list is>>>>>>>>>:'+lstMPSNWrapper);

            for(MultiPSNWrapper psnlist:lstMPSNWrapper){
                if(
                    (psnlist.PSN !=null && psnlist.PSN !='') || (psnlist.Ids != null) ||
                    (psnlist.VIN !=null && psnlist.VIN !='') || 
                    (psnlist.failurePoint !=null && psnlist.failurePoint !='') || 
                    (psnlist.calibrationBefore !=null && psnlist.calibrationBefore !='') ||
                    (psnlist.revisionBefore !=null && psnlist.revisionBefore !='') || 
                    (psnlist.calibrationAfter !=''&& psnlist.calibrationAfter !=null) ||
                    (psnlist.revisionAfter !='' && psnlist.revisionAfter !=null) 
                ){                            
                    count=count+1;
                    system.debug(' count'+count);
                }
            }

            if(count!=0){
                System.debug('lstMPSNWrapper size before save>>>:'+lstMPSNWrapper.size()+' The lstMPSNWrapper save list is>>>>>>>>>:'+lstMPSNWrapper);
                Set<String> allErrorMsgsSet = new Set<String>();
                for(MultiPSNWrapper psnlist:lstMPSNWrapper ){
                    system.debug('wrapper inside for ');
                    system.debug('wrapper psnlist.ids '+psnlist.ids);
                    psnlist.blankField = false;
                    if((psnlist.PSN==null || psnlist.PSN=='')){
                        system.debug('Inside for');
                        continue;
                    }
                    if(

                        (psnlist.PSN==null || psnlist.PSN=='') &&
                        (psnlist.VIN==null || psnlist.VIN=='') && 
                        (psnlist.failurePoint==null || psnlist.failurePoint=='') && 
                        (psnlist.calibrationBefore==null || psnlist.calibrationBefore=='') &&
                        (psnlist.revisionBefore==null || psnlist.revisionBefore=='') && 
                        (psnlist.calibrationAfter ==''|| psnlist.calibrationAfter == null) &&
                        (psnlist.revisionAfter =='' || psnlist.revisionAfter == null) 
                    ){
                        system.debug('Inside for IF');
                        if(psnlist.ids != null && String.valueOf(psnlist.ids).trim() !=''){
                            removeIdsMap.put(psnlist.ids, String.valueOf(psnlist.ids));
                        }
                    }

                    if((psnlist.PSN!=null && psnlist.PSN!='') || (psnlist.ids!=null)){

                        //Code for consolidating all errors captured on PSNTabOff
                        //if(psnlist.PSNError==true || psnlist.blankField==true || psnlist.WSDErrorMessage==true || psnlist.WSDFDError==true){ 
                        //Kalpana Commented above line and added below one. Removed WSDErrorMsg from the condition as it is a save validation, which will be covered in the next IF loop.
                        system.debug('psnlist.PSNError--->'+psnlist.PSNError+' blankField>>:'+psnlist.blankField+' psnlist.WSDFDError>>:'+psnlist.WSDFDError+' errorMsgsSet>>:'+psnlist.errorMsgsSet);
                        if(psnlist.PSNError==true || psnlist.blankField==true || psnlist.WSDFDError==true){
                            if(psnlist.errorMsgsSet !=null)
                                allErrorMsgsSet.addAll(psnlist.errorMsgsSet);
                            system.debug('psnlist.errorMsgsSet**'+psnlist.errorMsgsSet);
                            system.debug('allErrorMsgsSet**'+allErrorMsgsSet);
                            system.debug('psnlist.PSN--->'+psnlist.PSN);
                        }
                        //End
                        system.debug('psnlist.WSD--->'+psnlist.WSD);
                        system.debug('errorMsg--->'+errorMsg);
                        system.debug('WSDErrorMessage '+psnlist.WSDErrorMessage);
                        system.debug('WSDErrorMessage+errorMsg '+errorMsg);
                        //****************************************** End **********************************************************

                        if(psnRec !=null && psnRec.Before_In_Service__c && !psnlist.BIS){
                            List<CSS_Solution_Component__c> failuresList = new List<CSS_Solution_Component__c>([Select id, name, Failure_Mode__C,CSS_Account_Formula__c,AccountCodeType__c, AccountCodeEdit__c, 
                                                                                                                Selected_Component__c, Claims_Failure_Select__c, Service_Job__c, CSS_Claims__c, AccountCode__c, System_Code__c, Component_Code__c, 
                                                                                                                Component_Id__c, Pay_Code__c, Claim_Type__c from CSS_Solution_Component__c where CSS_Claims__c =:cId and CSS_Account_Formula__c !=null 
                                                                                                                and Selected_Component__c = true and type__C NOT IN ('TSB', 'TRP','ATC','Campaign','CAM') LIMIT 1]);
                            if(failuresList !=null && failuresList.size()>0){
                                psnlist.PSNError = true;
                                errorMsg= Label.CG_Only_BIS_PSN_s_are_allowed_with_Failures;
                                if(psnlist.errorMsgsSet == null || psnlist.errorMsgsSet.size()<=0){
                                    Set<String> errorMsgsSet = new Set<String>();
                                    errorMsgsSet.add(errorMsg);
                                    psnlist.errorMsgsSet = errorMsgsSet;
                                    allErrorMsgsSet.add(errorMsg);
                                }else{
                                    psnlist.errorMsgsSet.add(errorMsg);
                                    allErrorMsgsSet.addAll(psnlist.errorMsgsSet);
                                }
                            }
                            /* else //commented because PSNError exists from other validation error also
                            psnlist.PSNError = false; */
                        }
                        //RAJESH Start
                        if((psnlist.failurePoint==null || psnlist.failurePoint=='') && psnlist.PSNError==false){
                            psnlist.isfailurerror=true;
                            errorMsg= Label.CG_Please_enter_value;
                            if(psnlist.errorMsgsSet == null || psnlist.errorMsgsSet.size()<=0){
                                Set<String> errorMsgsSet = new Set<String>();
                                errorMsgsSet.add(errorMsg);
                                psnlist.errorMsgsSet = errorMsgsSet;
                                allErrorMsgsSet.add(errorMsg);
                            }
                            else{
                                psnlist.errorMsgsSet.add(errorMsg);
                                allErrorMsgsSet.addAll(psnlist.errorMsgsSet);
                            }
                        }
                        else{
                            psnlist.isfailurerror=false;
                        }
                        if((psnlist.WSD==null || psnlist.WSD=='') && psnlist.BIS==false && psnlist.PSNError==false){
                            psnlist.WSDErrorMessage=true;                        
                            errorMsg= Label.CG_Please_enter_value;
                            if(psnlist.errorMsgsSet == null || psnlist.errorMsgsSet.size()<=0){
                                Set<String> errorMsgsSet = new Set<String>();
                                errorMsgsSet.add(errorMsg);
                                psnlist.errorMsgsSet = errorMsgsSet;
                                allErrorMsgsSet.add(errorMsg);
                            }else{
                                psnlist.errorMsgsSet.add(errorMsg);
                                allErrorMsgsSet.addAll(psnlist.errorMsgsSet);
                            }
                        }
                        else{ //Kalpana defect 163778
                            psnlist.WSDErrorMessage=false; 
                        }
                        //RAJESH END

                        if(((psnlist.calibrationBefore == null || psnlist.calibrationBefore == '') || (psnlist.revisionBefore == null || psnlist.revisionBefore == '') || 
                            (psnlist.calibrationAfter == null || psnlist.calibrationAfter == '') || (psnlist.revisionAfter == null || psnlist.revisionAfter == '')) && psnlist.PSNError==false){ //&& mandateBool == true
                            system.debug('wrapper inside if psnlist.blankField');
                             //blankField = true;
                             // psnlist.blankField = true; commented as part of GSSC-435
                            if(!mandateBool){
                                List<CSS_SRT__c> ecmFlagSRTList = new List<CSS_SRT__c>([select Id, ECM_Flag__c, isPerformed__c, SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =:cId and ECM_Flag__c = true and (isPerformed__c=true or SRT_AccessiblityCheck__c=true) Limit 1]);
                                if(ecmFlagSRTList !=null && ecmFlagSRTList.size()>0){
                                    mandateBool = true;
                                    psnlist.blankField = true;
                                    errorMsg= Label.CalibrationErrorPinkBox;
                                    //errorMsg= Label.CG_Please_enter_value;
                                    if(psnlist.errorMsgsSet == null || psnlist.errorMsgsSet.size()<=0){
                                        Set<String> errorMsgsSet = new Set<String>();
                                        errorMsgsSet.add(errorMsg);
                                        psnlist.errorMsgsSet = errorMsgsSet;
                                        allErrorMsgsSet.add(errorMsg);
                                    }else{
                                        psnlist.errorMsgsSet.add(errorMsg);
                                        allErrorMsgsSet.addAll(psnlist.errorMsgsSet);
                                    }
                                }
                            }
                        }
                        else{
                            psnlist.blankField = false;
                        }
                        //if(psnlist.PSN!=null && psnlist.PSN!=''){
                        system.debug('wrapper inside psnlist.PSN '+psnlist.PSN);
                        system.debug('wrapper inside psnlist.blankField '+psnlist.blankField);
                        system.debug('wrapper inside psnlist.PSNError '+psnlist.PSNError);
                        system.debug('wrapper inside else if psnlist.WSD '+psnlist.WSD);
                        
                        //if(psnlist.PSN!=null && psnlist.PSN!='' && psnlist.blankField == false && ErrorMessage == false && psnlist.WSD!=null && psnlist.WSD!=''){
                        //Added  "psnlist.WSDFDError==false " below if condition as per defect #163303,By RAJESH 18-09-2018
                        CSS_PSN__c psnDetails = new CSS_PSN__c();
                        if(psnlist.PSN !=null && psnlist.PSN !='' && psnlist.PSNError == false && psnlist.blankField == false  && ErrorMessage == false && psnlist.WSDErrorMessage == false && psnlist.WSDFDError==false && psnlist.isfailurerror==false){
                            system.debug('wrapper inside else if savelist... ');
                            psnDetails.PSN__c                 = psnlist.PSN;
                            psnDetails.VIN__c                 = psnlist.VIN;

                            //psnDetails.Warranty_Start_Date__c = psnlist.WSD;
                            system.debug('psnlist.WSD**'+psnlist.WSD);
                            //system.debug('formatted psnlist.WSD**'+css_utility.formatDateFromGuidanzFormat(psnlist.WSD));
                            //system.debug('psnlist.WSD**'+psnlist.WSD+' Date WSD>>:'+Date.valueOf(psnlist.WSD));
                            //psnDetails.Warranty_Start_Date__c = Date.valueOf(psnlist.WSD);
                            if(psnlist.WSD !=null && psnlist.WSD.trim() !=''){

                                psnDetails.Warranty_Start_Date__c = css_utility.formatDateIntoLocale(psnlist.WSD); 
                                system.debug('TEST**'+psnDetails.Warranty_Start_Date__c);
                                // psnDetails.Warranty_Start_Date__c = Date.Valueof(FormatDate(Date.valueof(psnlist.WSD))); 
                            }

                            psnDetails.Mileage_Measure__c     = selectedMIKMHR;
                            psnDetails.Failure_Point__c       = psnlist.failurePoint;
                            psnDetails.Before_In_Service__c   = psnlist.BIS;
                            psnDetails.Calibration_Before__c  = psnlist.calibrationBefore;
                            psnDetails.Revision_Before__c     = psnlist.revisionBefore;
                            psnDetails.Calibration_After__c   = psnlist.calibrationAfter;
                            psnDetails.Revision_After__c      = psnlist.revisionAfter;
                            psnDetails.CSS_Claims__c          = cId;
                            psnDetails.Id                     = psnlist.ids;
                            selectedMPSNList.add(psnDetails);
                        }else{
                            errorExists = true;
                        }
                        System.debug('lstMPSNWrapper size After save>>>:'+lstMPSNWrapper.size()+' The lstMPSNWrapper save list is>>>>>>>>>:'+lstMPSNWrapper);
                    }
                }//myif

                system.debug('errorExists>>:'+errorExists);

                if(errorExists){
                    //here consolidate unique error messages & display
                    if(allErrorMsgsSet !=null && allErrorMsgsSet.size()>0){
                        errorMsg = '';
                        for(String msg: allErrorMsgsSet){
                            //errorMsg = errorMsg + '\n' + msg; //1
                            errorMsg += msg+'<br/>';
                        }
                    }
                    return;
                }

                system.debug('before save selectedMPSNList>>'+selectedMPSNList);
                if(selectedMPSNList.size()>0 || !errorExists){
                    upsert selectedMPSNList;
                    System.debug('after upsert selectedCustPartsList size>>>>:'+selectedMPSNList.size());
                    //Commented below line as part of the defect # 189704
                    //updateSRTs();

                    //Delete Code
                    /* try{
if(removeIdsMap.keySet().size()>0){
deleteMPSN();
updateSRTs();
}
}*/
                    try{
                        system.debug('removeIdsMapInSave****'+removeIdsMap);
                        if(removeIdsMap.keySet().size()>0){
                            for(integer i =0;i<removeIdsMap.keySet().size();i++){
                                for(integer j=0;j<lstMPSNWrapper.size();j++){
                                    system.debug('lstMPSNWrapper[j]***'+lstMPSNWrapper[j]);
                                    system.debug('lstMPSNWrapper[j].ids***'+lstMPSNWrapper[j].ids);
                                    system.debug('removeIdsMap.get(lstMPSNWrapper[j].ids)**'+removeIdsMap.get(lstMPSNWrapper[j].ids));
                                    system.debug('removeIdsMap.ContainsKey(lstMPSNWrapper[j].ids)**'+removeIdsMap.ContainsKey(lstMPSNWrapper[j].ids));
                                    if(removeIdsMap.ContainsKey(lstMPSNWrapper[j].ids) && ((removeIdsMap.get(lstMPSNWrapper[j].ids))!=lstMPSNWrapper[j].PSN.trim())){
                                        system.debug('Inside**');
                                        deleteMPSN();
                                    }
                                }
                            }
                            //deleteMPSN();
                            //Commented below line as part of the defect # 189704
                            //updateSRTs();
                        }
                        //Added below line as part of the defect # 189704
                        updateSRTs();
                    }
                    catch(Exception ex) {
                        System.debug('first in catch of Delete--saveCustomParts of MultiPSN>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
                    }

                }
            }
        }
        catch(Exception ex) 
        {
            System.debug('second in catch of saveCustomParts of MultiPSN>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    //End

    //Updating Quantity & %Requested for SRTs 00-901,00-902-00,00-904-00
    public void updateSRTs(){
        try{
            List<CSS_SRT__c> srtList;
            if(!Test.isRunningTest()){
                srtList = new List<CSS_SRT__c>([Select Id,Step_Id__c,SRT_ID__c,Type__c,SRT_Warrantable__c,SRT_Title__c,SRT_Quantity__c,CSS_Claims__c,CSS_Claims__r.Total_PSN_Count__c                                        
                                                from CSS_SRT__c where CSS_Claims__c =:cId and (SRT_ID__c='00-901-00' or SRT_ID__c='00-902-00' or SRT_ID__c='00-904-00')]);
            } else {
                srtList = new List<CSS_SRT__c>([Select Id,Step_Id__c,SRT_ID__c,Type__c,SRT_Warrantable__c,SRT_Title__c,SRT_Quantity__c,CSS_Claims__c,CSS_Claims__r.Total_PSN_Count__c                                        
                                                from CSS_SRT__c where CSS_Claims__c =:cId and (SRT_ID__c='00-901-00' or SRT_ID__c='00-902-00' or SRT_ID__c='00-904-00') limit 1]);
            }
            system.debug('srtList size:'+srtList.size());
            if(srtList ==null || srtList.size()<=0)
                return;
            for(CSS_SRT__c srtObj: srtList){
                system.debug('srtObj.CSS_Claims__r.Total_PSN_Count__c-->'+srtObj.CSS_Claims__r.Total_PSN_Count__c);
                srtObj.SRT_Quantity__c = srtObj.CSS_Claims__r.Total_PSN_Count__c;
                if(srtObj.SRT_Warrantable__c !=null && srtObj.SRT_Warrantable__c.trim() !='' && Integer.valueOf(srtObj.SRT_Warrantable__c) >50)
                    srtObj.SRT_Warrantable__c = '50';
                //if(srtObj.SRT_Hours_Percentage__c !=null && srtObj.SRT_Hours_Percentage__c >50)
                //srtObj.SRT_Hours_Percentage__c = 50;
            }
            update srtList;

        }catch(Exception ex) 
        {
            System.debug('second in catch of updateSRTs of MultiPSN>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }


    //****************************************Method for Reset the data**************************************************************8
    public void resetMPSNRecords(){
        errorMsg = '';
        // saveMPSNRecords();
        buildMPSNWrapper();
        //psnSet.remove(selectedPSN); // is this needed??
    }
    //************************************************END *********************************************************
    //created for story no: 155747
    public PageReference ValidationPSN(){
        //  public void ValidationPSN(){
        //ErrorMessage = false;
        system.debug('entering to ValidationPSN method..........');
        PageReference ReturnPage;
        system.debug('lstPSNrec.size().....' +lstPSNrec.size());
        if(lstPSNrec.size()==0){
            ErrorMessage = true;
            system.debug('ErrorMessage--->'+ErrorMessage);
            system.debug('entering to ValidationPSN method1111..........');
            ReturnPage = new PageReference('/apex/CG_ClaimsMultiPSN?id='+cId);
            ReturnPage.setRedirect(true);
            //  return null;
        }
        else{
            ErrorMessage = false;
            ReturnPage = new pageReference('/apex/CG_ClaimsPartsandOtherClaimbles?id='+cId); 
            // nvClaimsPOC(); // Kalpana Commented it
        }
        return ReturnPage;
    }
    //Method for Adding 10 Rows
    public void AddRows(){
        try{
            if(lstMPSNWrapper.size()<=60){
                lstMPSNWrapper2=lstMPSNWrapper.clone();
                lstMPSNWrapper.clear();

                lstMPSNWrapper2.add(new MultiPSNWrapper(lstMPSNWrapper2.size(),null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,null,false,false));
                lstMPSNWrapper2.add(new MultiPSNWrapper(lstMPSNWrapper2.size(),null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,null,false,false));
                lstMPSNWrapper2.add(new MultiPSNWrapper(lstMPSNWrapper2.size(),null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,null,false,false));
                lstMPSNWrapper2.add(new MultiPSNWrapper(lstMPSNWrapper2.size(),null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,null,false,false));
                lstMPSNWrapper2.add(new MultiPSNWrapper(lstMPSNWrapper2.size(),null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,null,false,false));
                lstMPSNWrapper2.add(new MultiPSNWrapper(lstMPSNWrapper2.size(),null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,null,false,false));
                lstMPSNWrapper2.add(new MultiPSNWrapper(lstMPSNWrapper2.size(),null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,null,false,false));
                lstMPSNWrapper2.add(new MultiPSNWrapper(lstMPSNWrapper2.size(),null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,null,false,false));
                lstMPSNWrapper2.add(new MultiPSNWrapper(lstMPSNWrapper2.size(),null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,null,false,false));
                if(lstMPSNWrapper2.size() < 69)
                    lstMPSNWrapper2.add(new MultiPSNWrapper(lstMPSNWrapper2.size(),null,null,null,null,null,null,null,null,null,null,false,false,false,false,false,null,false,false));
                lstMPSNWrapper=lstMPSNWrapper2.clone();
                lstMPSNWrapper2.clear(); 
            }
        }catch(Exception ex) {
            System.debug('in catch of AddRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    //Method for Removing the Row
    public void removingRow(){
        System.debug('assignedParts '+assignedParts);
        System.debug('selectedRemoveRow '+selectedRemoveRow);
        //errorMsg = '';
        try{
            lstMPSNWrapper2=lstMPSNWrapper.clone();
            lstMPSNWrapper.clear();
            system.debug('lstMPSNWrapper2.size()'+lstMPSNWrapper2.size());

            for(Integer i=0;i<lstMPSNWrapper2.size();i++){
                if(lstMPSNWrapper2[i].counting==selectedRemoveRow){
                    System.debug('Selected Remove Row '+selectedRemoveRow);
                    System.debug('lstMPSNWrapper2[i].counting '+lstMPSNWrapper2[i].counting);
                    if(lstMPSNWrapper2[i].ids != null && String.valueOf(lstMPSNWrapper2[i].ids).trim() !=''){
                        // removeIdsMap.put(lstMPSNWrapper2[i].ids, String.valueOf(lstMPSNWrapper2[i].ids));
                        removeIdsMap.put(lstMPSNWrapper2[i].ids, lstMPSNWrapper2[i].PSN);
                    }
                    lstMPSNWrapper2[i].PSN='';
                    lstMPSNWrapper2[i].failurePoint='';
                    lstMPSNWrapper2[i].WSD=null;
                    lstMPSNWrapper2[i].VIN='';
                    lstMPSNWrapper2[i].BIS=false;
                    lstMPSNWrapper2[i].calibrationBefore= '';
                    lstMPSNWrapper2[i].revisionBefore='';
                    lstMPSNWrapper2[i].calibrationAfter='';
                    lstMPSNWrapper2[i].revisionAfter='';
                    lstMPSNWrapper2[i].blankField=false;
                    lstMPSNWrapper2[i].isfailurerror = false;

                    /* if(lstMPSNWrapper2[i].ids != null && String.valueOf(lstMPSNWrapper2[i].ids).trim() !=''){
removeIdsMap.put(lstMPSNWrapper2[i].ids, String.valueOf(lstMPSNWrapper2[i].ids));
}*/
                    System.debug('removeIdsMap>>>:'+removeIdsMap);
                    //listpartWrapper2.remove(i);
                }
            }

            lstMPSNWrapper=lstMPSNWrapper2.clone();

            lstMPSNWrapper2.clear();
            system.debug('lstMPSNWrapper'+lstMPSNWrapper);
        }catch(Exception ex) {
            System.debug('in catch of removingRow of CSS_GSQParts>>>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    //public string testing{get;set;}
    public CSS_getEngineDataResponseJ2A engineData{get;set;}

    //PSN TabOff functionality
    public void psnTabOff(){
        engineData = null; //newly added
        errorMsg = '';
        integer i = 0;
        System.debug('in psnTabOff method.....');
        //testing= 'rerendersuccessful';
        validationBIS = '';
        // errorMsg = 'test';
        //CSS_getEngineDataResponseJ2A engineData; //commented temporarily
        // String errorMsg;
        try{
            //lstMPSNWrapper[0].VIN = 'Anirudh';
            System.debug('selectedPSN>>>:'+selectedPSN);
            system.debug('selectedRowNo**'+selectedRowNo);
            system.debug('lstMPSNWrapper**'+lstMPSNWrapper);
            system.debug('lstMPSNWrapper.size**'+lstMPSNWrapper.size());
            System.debug('psnRec.Service_Model__c>>>:'+psnRec.Service_Model__c);
            System.debug('psnRec.Before_In_Service__c>>>:'+psnRec.Before_In_Service__c);
            System.debug('psnRec.>>>:'+psnRec);

            /* if(selectedPSN ==null && selectedPSN.trim() =='')
return;*/


            //code for checking PSN already present
            /*if(selectedPSN !=null && selectedPSN.trim() !=''){
if(psnSet.contains(selectedPSN)){
// psnSet.add(selectedPSN);
errorMsg = Label.CG_PSN_is_already_present;
updateWrapperErrors(true,false,errorMsg);
return;
}else{
psnSet.add(selectedPSN);
}
}
else if(selectedPSN == null || selectedPSN.trim() == ''){
//Code to nullify all the fields, if PSN is nullified by user.
updateWrapper(engineData);
return;
}*/

            //Another code for checking PSN already present
            List<String> psnList = new List<String>();
            if(selectedPSN !=null && selectedPSN.trim() !=''){
                if(lstMPSNWrapper != null && lstMPSNWrapper.size() > 0){
                    psnList.add(psnRec.PSN__c);
                    for(i=0;i<lstMPSNWrapper.size();i++){
                        if(lstMPSNWrapper[i].PSN !=null && lstMPSNWrapper[i].PSN.trim() !='' && lstMPSNWrapper[i].counting != selectedRowNo)
                            psnList.add(lstMPSNWrapper[i].PSN);
                    }
                    if(psnList.contains(selectedPSN)){
                        errorMsg = Label.CG_PSN_is_already_present;
                        updateWrapperErrors(true,false,errorMsg);
                        return;
                    }
                }
            }else if(selectedPSN == null || selectedPSN.trim() == ''){
                //Code to nullify all the fields, if PSN is nullified by user.
                updateWrapper(engineData);
                return;
            }


            /*if(psnRec ==null || !psnRec.Primary__c || psnRec.PSN__c ==null || psnRec.PSN__c.trim() =='' 
|| psnRec.Service_Model__c ==null || psnRec.Service_Model__c.trim()==''){
errorMsg = Label.CG_Primary_PSN_SMN_is_not_available;
updateWrapperErrors(true,false,errorMsg);
return;
}*/

            //Step: GetEnginaData WS execution
            CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
            CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
            jidi.ESN = selectedPSN;
            System.debug('engineData+jidi'+jidi);
            wrapobj.DataArea = jidi;
            System.debug('***selectedPSN***'+selectedPSN);
            System.debug('***selectedPSN isNumeric()***'+selectedPSN.isNumeric());
            System.debug('***selectedPSN isAlphanumeric()***'+selectedPSN.isAlphanumeric());

            //Code Added for Shrek #187052 -- Rajasekhar Hindupur
            if(selectedPSN!=null){
                if(selectedPSN.isNumeric() && (selectedPSN.length() < 8 || selectedPSN.length() > 8)){
                    System.debug('***enter inside sub 1st if part***');
                    errorMsg = Label.CG_MPSN_NOT_VALID;
                    updateWrapperErrors(true,false,errorMsg);
                    return;
                }
                else if((selectedPSN.isAlphanumeric()==true && selectedPSN.isNumeric()==false) && (selectedPSN.length() < 8 || selectedPSN.length() > 8)){
                    System.debug('***enter inside sub 4th if part***'); 
                    errorMsg='';
                    updateWrapperErrors(false,false,errorMsg);
                    return;
                }

                else if(selectedPSN.isAlphanumeric() && selectedPSN.isNumeric()==false && selectedPSN.length() == 8 ){
                    System.debug('***enter inside sub 3rd if part***');
                    errorMsg = Label.CG_MPSN_NOT_VALID;
                    updateWrapperErrors(true,false,errorMsg);
                    return;
                }

            }
            //End 
            engineData = CSS_WS_SBL.getEngineData(wrapobj); 
            //System.debug('***engineData***'+engineData);
            //Code Added for Shrek #187052 -- Rajasekhar Hindupur
            //System.debug('***engineData.DataArea.Esn***'+engineData.DataArea.Esn);
            //System.debug('***engineData.Header.Status***'+engineData.Header.Status);
            //System.debug('***selectedPSN isAlphanumeric()***'+selectedPSN.isAlphanumeric());
            if(engineData != null && engineData.DataArea != null){
                if(engineData.DataArea.Esn != null && engineData.DataArea.Esn.isNumeric() && engineData.DataArea.Esn.length() == 8 && engineData.DataArea.ServiceModelName ==''){
                    System.debug('***enter inside sub 2nd if part***'); 
                    errorMsg = Label.CG_MPSN_NOT_VALID;
                    updateWrapperErrors(true,false,errorMsg);
                    return;
                    System.debug('***multiPSNErrorMsg***'+multiPSNErrorMsg);
                }                   
            }else{
                System.debug('***enter inside dataarea null if part***');
                errorMsg = Label.CG_MPSN_NOT_VALID;
                updateWrapperErrors(true,false,errorMsg);
                return;
            }            
            //end

            System.debug('after getEngineData...'+engineData);
            if(engineData == null){
                errorMsg = Label.CG_PSN_FLAG;
                System.debug('in engine data failure...');
                updateWrapperErrors(true,false,errorMsg);
                css_utility.LogOutIntError('SBL get EngineData','SBL get EngineData', 'RESPONSE IS NULL', 'SBL');
                return;
            }

            System.debug('engineData.DataArea.WarrantyStartDate>>>:'+engineData.DataArea.WarrantyStartDate);
            System.debug('engineData.DataArea.BuildDate>>>:'+engineData.DataArea.BuildDate);
            /*validationBIS=engineData.DataArea.WarrantyStartDate;
if(validationBIS != null && validationBIS != '')
system.debug('validationBIS****'+validationBIS);*/
            //onChangeofWSD();

            system.debug('SMN**'+engineData.DataArea.ServiceModelName.touppercase());
            if(psnRec.Service_Model__c.touppercase() != engineData.DataArea.ServiceModelName.touppercase()){
                errorMsg = Label.CG_Service_Model_must_be_same_as_primary_PSN;
                System.debug('before returning from SMN...errorMsg:'+errorMsg);
                updateWrapperErrors(true,false,errorMsg);
                return;
            }

            //engineData.DataArea.WarrantyStartDate ='2018-09-10T00:00:00.000-05:00';
            //engineData.DataArea.BuildDate ='2018-01-12T00:00:00.000-05:00';
            if(engineData.DataArea.WarrantyStartDate !=null && engineData.DataArea.WarrantyStartDate.trim() !='' 
               && engineData.DataArea.BuildDate !=null && engineData.DataArea.BuildDate.trim() !=''){ 
                //engineData.DataArea.WarrantyStartDate < engineData.DataArea.BuildDate){
                Date wsd = css_utility.formatedDateOfSiebelDate(engineData.DataArea.WarrantyStartDate);
                Date bDate = css_utility.formatedDateOfSiebelDate(engineData.DataArea.BuildDate);
                System.debug('wsd>>>:'+wsd);
                System.debug('bDate>>:'+bDate);
                if(wsd !=null && bDate !=null && bDate>wsd ){
                    errorMsg = Label.CG_Warranty_Start_Date_must_be_later_than_Engine_Build_Date;
                    updateWrapperErrors(true,true,errorMsg);
                    return;
                }
            }
            system.debug('engineData.DataArea.PACCARFlag'+engineData.DataArea.PACCARFlag);
            system.debug('claimsRec.PACCAR_Flag__c'+claimsRec.PACCAR_Flag__c);
            system.debug('claimsRec.Css_paccar_approve_reject_flag__c'+claimsRec.Css_paccar_approve_reject_flag__c);
            system.debug('claimsRec.PACCAR_Auth_Required__c'+claimsRec.PACCAR_Auth_Required__c);
            /*if(claimsRec.Account__r.Type == 'Dealer Account' && engineData.DataArea.PACCARFlag == 'Y' && ((claimsRec.PACCAR_Auth_Required__c == true && claimsRec.Css_paccar_approve_reject_flag__c != 'Approved') || (claimsRec.SP_PACCAR__c != 'Y' && claimsRec.PACCAR_Auth_Required__c == false && claimsRec.PACCAR_Flag__c == false))){//claimsRec.PACCAR_Flag__c != true){
errorMsg = Label.CG_PACCAR_Multi_PSN_Flag_Error;
updateWrapperErrors(true,true,errorMsg);
return;
}*/

            boolean DealerTypeFlag = CSS_utility.getAccounttype(claimsRec.Account__r.Type); 

            if(DealerTypeFlag==true){
                String temp = claimsRec.Territory_Class__c +'-'+ claimsRec.CSS_Channel_Code__c;
                system.debug('setPACCAR_Flag(engineData.DataArea.ServiceModelName)'+setPACCAR_Flag(engineData.DataArea.ServiceModelName));
                if(temp != null && temp != ''){
                    paccarCustomSettingValues = CG_PACCAR_Flag_SP_Info_Mapping__c.getValues(temp);
                }
                system.debug('paccarCustomSettingValues'+paccarCustomSettingValues);
                system.debug('engineData.DataArea.PACCARFlag'+engineData.DataArea.PACCARFlag);
                if(claimsRec.SP_PACCAR__c == 'Y'){
                    //do nothing
                }
                else if(setPACCAR_Flag(engineData.DataArea.ServiceModelName) == true){
                    //do nothing
                }
                else if(claimsRec.SP_PACCAR__c != 'Y' && setPACCAR_Flag(engineData.DataArea.ServiceModelName) == false){
                    if(paccarCustomSettingValues == null || (claimsRec.PACCAR_Auth_Required__c == true && claimsRec.Css_paccar_approve_reject_flag__c == 'Approved')){
                        //do nothing
                    }
                    else if(paccarCustomSettingValues != null && psnRec.PACCAR_Flag__c != 'Y' && engineData.DataArea.PACCARFlag == 'Y'){ //(claimsRec.PACCAR_Auth_Required__c == true && claimsRec.Css_paccar_approve_reject_flag__c != 'Approved')
                        errorMsg = Label.CG_PACCAR_Multi_PSN_Flag_Error;
                        updateWrapperErrors(true,true,errorMsg);
                        return;
                    }
                }
            }

            //assign errors/data to wrapper for selected row
            System.debug('equalled selectedPSN>>>:'+selectedPSN+' selectedRowNo>>:'+selectedRowNo);
            System.debug('engineData.DataArea.WarrantyStartDate>>>:'+engineData.DataArea.WarrantyStartDate);
            System.debug('engineData.DataArea.BuildDate......>'+engineData.DataArea.BuildDate);

            //Step: Querying GetCampaigns
            List<CSS_Solution_Component__c> solCompList = new List<CSS_Solution_Component__c>([select Selected_Claim_Type__c,Type__C, Name,Component_Id__c,Fail_Code__c,
                                                                                               Failure_Mode__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,
                                                                                               Campaign_Start_Date__c,CampaignTravelPercentage__c,Service_Job__c,Performed__c,Performed_Review__c,Reviewed__c,URL__C,Approval_Code__c,
                                                                                               AccountCodeEdit__c,Pay_Code__c,AccountCodeType__c,AccountCode__c,Selected_Component__c
                                                                                               from CSS_Solution_Component__c where Type__c in ('Campaign','CAM','ATC') and CSS_Claims__c =:claimsRec.id  and Status__c='Approved' 
                                                                                               and Selected_Component__c=true LIMIT 1]);
            System.debug('before Campaigns...solCompList>>:'+solCompList.size());
            if(solCompList !=null && solCompList.size()>0){
                errorMsg = CG_BL_Claims.validateGetCampaigns(selectedPSN, psnRec.Failure_Date__c, claimsRec.Region__C, cId, solCompList.get(0).Type__c, solCompList.get(0).Component_id__c);
                if(errorMsg !=null && errorMsg.trim() !=''){
                    System.debug('111 after Campaigns...');
                    updateWrapperErrors(true,false,errorMsg);
                    System.debug('before return...');
                    return;
                    System.debug('after return...');
                }
                System.debug('after Campaigns...');
            }

            //Step:Check validations here
            //if failure is added, don't call below GetCampaigns WS
            if(psnRec.Before_In_Service__c){
                System.debug('in BIS...claimsRec.Location__c>>:'+claimsRec.Location__c+' LocCode>>:'+claimsRec.Location_Code__c);
                //Step: WarrantyDetailCoverage WS execution
                //calling WarrantyDetailCoverage service here
                List<CSS_Solution_Component__c> failuresList = new List<CSS_Solution_Component__c>([Select id, name, Failure_Mode__C,CSS_Account_Formula__c,AccountCodeType__c, AccountCodeEdit__c, 
                                                                                                    Selected_Component__c, Claims_Failure_Select__c, Service_Job__c, CSS_Claims__c, AccountCode__c, System_Code__c, Component_Code__c, 
                                                                                                    Component_Id__c, Pay_Code__c, Claim_Type__c from CSS_Solution_Component__c where CSS_Claims__c =:cId and CSS_Account_Formula__c !=null 
                                                                                                    and Selected_Component__c = true and type__C NOT IN ('TSB', 'TRP','ATC','Campaign','CAM') LIMIT 1]);
                System.debug('IN BIS...failuresList>>:'+failuresList.size() +' solCompList>>:'+solCompList);
                if((failuresList ==null || failuresList.size()<0) && (solCompList ==null || solCompList.size()<0) ){ //later uncomment it this validation should happen FC only
                    System.debug('No Failure or Campaign/ATC found as saved/selected...');
                    return; //this scenario should not happen
                }

                if(failuresList !=null && failuresList.size()>0){
                    CSS_Solution_Component__c comp = failuresList.get(0);
                    /*CSS_Solution_Component__c additionalComp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(selectedPSN,claimsRec.Location_Code__c.right(5),psnRec.Failure_Date__c,
string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,
comp.System_Code__c,comp.Component_Code__c,'','',null,false,null,'','Second Call', claimsRec.ReconEngineFlag__c, true); */
                    system.debug('*****comp.CSS_Account_Formula__c***'+comp.CSS_Account_Formula__c);
                    CSS_Solution_Component__c additionalComp = CSS_FN_SIEBEL.getWarrantyDetailCoverage(selectedPSN,claimsRec.Location_Code__c.right(5),psnRec.Failure_Date__c,
                                                                                                       string.valueof(psnRec.Mileage__c),psnRec.Mileage_Measure__c,psnRec.ApplicationCode__c,psnRec.Warranty_Start_Date__c,
                                                                                                       comp.System_Code__c,comp.Component_Code__c,'','',comp.id,false,'','','Second Call', claimsRec.ReconEngineFlag__c, true,claimsRec.Name); 
                    system.debug('*****additionalComp***'+additionalComp);
                    if(comp.CSS_Account_Formula__c != additionalComp.AccountCodeEdit__c){
                        errorMsg = Label.CG_PSN_does_not_have_coverage_available_for_selected_Failure_Campaign_ATC; //No Coverage Found for Failure
                        System.debug('before returning from No Coverage of Failure...errorMsg:'+errorMsg);
                        updateWrapperErrors(true,false,errorMsg);
                        return;
                    }
                }

            }else{
                //if BIS unchecked, only Campaigns will be there as part of #154237
                //Checking campaigns is done above
            }

            updateWrapper(engineData); //Updating Wrapper finally
            //psnSet.add(selectedPSN); //adding all PSNs to Set
            System.debug('before returning...psnSet:'+psnSet);
            system.debug('engineData.DataArea.PACCARFlag'+engineData.DataArea.PACCARFlag);
            system.debug('claimsRec.PACCAR_Flag__c'+claimsRec.PACCAR_Flag__c);
        }catch(Exception ex){
            System.debug('in catch of psnTabOff of CG_CL_ClaimsMultiPSNComp>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
            //errorMsg = Label.CG_Web_Service_failure_Please_try_again_later;
            updateWrapperErrors(true,false,errorMsg);
        }finally{

        }   
    }

    public void onChangeofBIS(){
        errorMsg = '';
        integer i = 0;
        system.debug('in onChangeofBIS SelectedBIS**'+selectedBIS);
        system.debug('lstMPSNWrapper**'+lstMPSNWrapper);
        system.debug('selectedRowNo**'+selectedRowNo);
        if(selectedBIS){
            if(lstMPSNWrapper != null && lstMPSNWrapper.size() > 0){
                for(i=0;i<lstMPSNWrapper.size();i++){
                    if(lstMPSNWrapper[i].counting==selectedRowNo){
                        lstMPSNWrapper[i].WSD=null;
                        break;
                    }
                }
            }
        }



    }
    // public Boolean ReadOnlyBIS{get;set;}
    Public String warrStDtHidden{get;set;}
    public void onChangeofWSD(){
        //errorMsg = '';
        integer i = 0;
        system.debug('in onChangeofWSD SelectedWSD**'+selectedWSD);
        system.debug('lstMPSNWrapper**'+lstMPSNWrapper);
        system.debug('selectedRowNo**'+selectedRowNo);
        //if(selectedWSD == null || selectedWSD == ''){
        //return;
        //}
        // if(validationBIS!=null || selectedWSD!=null || (warrStDtHidden!=null && warrStDtHidden!='')){
        //ReadOnlyBIS = true;
        if(selectedWSD != null && selectedWSD != ''){
            if(lstMPSNWrapper != null && lstMPSNWrapper.size() > 0){
                for(i=0;i<lstMPSNWrapper.size();i++){
                    if(lstMPSNWrapper[i].counting==selectedRowNo){
                        //selectedWSD = '2018-08-26T00:00:00.000-04:00';
                        //system.debug('selectedWSDinDATEFormat**'+Date.Valueof(selectedWSD));
                        system.debug('claimsRec.CSS_PSNs__r.get(0).Failure_Date__c**'+claimsRec.CSS_PSNs__r.get(0).Failure_Date__c);

                        //WSD future date validation
                        Date wsdObj = css_utility.convertStringToDate(selectedWSD);


                        system.debug('wsdObj>>:'+wsdObj);
                        system.debug('currentDate>>:'+System.TODAY());
                        if(wsdObj > System.TODAY()){
                            //if(selectedWSD > string.valueof(System.TODAY())){
                            system.debug(' validation occured...wsdObj>>:'+wsdObj);
                            lstMPSNWrapper[i].WSDFDError=true;
                            //lstMPSNWrapper[i].PSNError=true;
                            errorMsg = Label.CG_Warranty_Start_Date_should_be_less_than_or_equal_to_current_date;
                            lstMPSNWrapper[i].WSD = '';
                            Set<String> errorMsgsSet = new Set<String>();
                            errorMsgsSet.add(errorMsg);
                            lstMPSNWrapper[i].errorMsgsSet = errorMsgsSet;
                        }
                        // else if(claimsRec.CSS_PSNs__r.get(0).Failure_Date__c !=null && wsdObj > claimsRec.CSS_PSNs__r.get(0).Failure_Date__c){
                        if(selectedWSD!=null && date.parse(selectedWSD) > claimsRec.CSS_PSNs__r.get(0).Failure_Date__c){
                            lstMPSNWrapper[i].WSDFDError=true;
                            //lstMPSNWrapper[i].PSNError=true;
                            errorMsg = Label.CG_Warranty_Start_Date_cannot_be_later_than_Failure_Date;
                            lstMPSNWrapper[i].WSD = selectedWSD;
                            Set<String> errorMsgsSet = new Set<String>();
                            errorMsgsSet.add(errorMsg);
                            lstMPSNWrapper[i].errorMsgsSet = errorMsgsSet; 
                        }
                        /*else if(engineData !=null && engineData.DataArea !=null && engineData.DataArea.BuildDate !=null){
Date wsd = css_utility.convertStringToDate(selectedWSD);
Date bDate = css_utility.formatedDateOfSiebelDate(engineData.DataArea.BuildDate);
System.debug('wsd>>>:'+wsd);
System.debug('bDate>>:'+bDate);
if(wsd !=null && bDate !=null && bDate>wsd ){
system.debug(' validation2 occured...wsdObj>>:'+wsdObj);
lstMPSNWrapper[i].WSDFDError=true;
//lstMPSNWrapper[i].PSNError=true;
errorMsg = Label.CG_Warranty_Start_Date_must_be_later_than_Engine_Build_Date;
lstMPSNWrapper[i].WSD = selectedWSD;
Set<String> errorMsgsSet = new Set<String>();
errorMsgsSet.add(errorMsg);
lstMPSNWrapper[i].errorMsgsSet = errorMsgsSet;
}
}*/
                        else if(engineData !=null && engineData.DataArea !=null && engineData.DataArea.BuildDate !=null && css_utility.formatedDateOfSiebelDate(engineData.DataArea.BuildDate) != null && css_utility.convertStringToDate(selectedWSD) != null && css_utility.formatedDateOfSiebelDate(engineData.DataArea.BuildDate)>css_utility.convertStringToDate(selectedWSD)){
                            system.debug(' validation2 occured...wsdObj>>:'+wsdObj);
                            lstMPSNWrapper[i].WSDFDError=true;
                            //lstMPSNWrapper[i].PSNError=true;
                            errorMsg = Label.CG_Warranty_Start_Date_must_be_later_than_Engine_Build_Date;
                            lstMPSNWrapper[i].WSD = selectedWSD;
                            Set<String> errorMsgsSet = new Set<String>();
                            errorMsgsSet.add(errorMsg);
                            lstMPSNWrapper[i].errorMsgsSet = errorMsgsSet;
                        }

                        else{
                            system.debug('In ELSE**');
                            //errorMsg = '';
                            lstMPSNWrapper[i].WSDFDError = false;
                            lstMPSNWrapper[i].WSDFDError = false;
                            lstMPSNWrapper[i].errorMsgsSet = new Set<String>();
                            lstMPSNWrapper[i].WSD = selectedWSD;
                        }

                        if((!lstMPSNWrapper[i].WSDFDError) && (!lstMPSNWrapper[i].isfailurerror))
                        {
                            errorMsg = '';
                        }

                        //if((lstMPSNWrapper[i].WSD!=null && lstMPSNWrapper[i].WSD!='') || (warrStDtHidden!=null && warrStDtHidden!='')){
                        //if(selectedWSD!=null && Date.Valueof(selectedWSD) > claimsRec.CSS_PSNs__r.get(0).Failure_Date__c){
                        //lstMPSNWrapper[i].WSD = selectedWSD;
                        //lstMPSNWrapper[i].BIS=false;
                        break;
                    }
                }
            }
        }else{
            if(lstMPSNWrapper != null && lstMPSNWrapper.size() > 0){
                for(i=0;i<lstMPSNWrapper.size();i++){
                    if(lstMPSNWrapper[i].counting==selectedRowNo){
                        errorMsg = '';
                        lstMPSNWrapper[i].WSDFDError = false;
                        lstMPSNWrapper[i].WSD = selectedWSD;
                        lstMPSNWrapper[i].errorMsgsSet = new Set<String>();
                        break;
                    }
                }
            }

        }
    }
    //}
    //******************************************************************Methods for getting Redio Button value*******************************************
    public List<SelectOption> getlistSelected() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('MI','MI')); 
        options.add(new SelectOption('KM','KM'));
        options.add(new SelectOption('HR','HR'));
        return options; 
    }
    public void selectedRedioButton(){
        system.debug('selectedMIKMHR-Cus'+selectedMIKMHR);
        if(selectedMIKMHR=='MI'){
            selectedMIKMHR='MI';
        }
        else if(selectedMIKMHR=='KM'){
            selectedMIKMHR='KM';
        }
        else{
            selectedMIKMHR='HR';
        }
    }
    //********************************** End *********************************************End****************************************************
    //Multi PSn Wrapper Class
    public Class MultiPSNWrapper{
        public Integer counting {get;set;}
        public Id ids {get;set;}
        public String PSN {get;set;}
        public String failurePoint {get;set;}
        //public Date WSD {get;set;}
        public String WSD {get;set;}
        public Boolean BIS {get;set;}
        public String VIN {get;set;}
        public String calibrationBefore {get;set;}
        public String revisionBefore {get;set;}
        public String calibrationAfter {get;set;}
        public String revisionAfter {get;set;}
        public Boolean blankField {get;set;}
        public Boolean WSDErrorMessage {get;set;}
        public Boolean PSNError {get;set;}
        public Boolean isSiebWSD {get;set;}
        public Boolean WSDFDError {get;set;}
        public Set<String> errorMsgsSet {get;set;}
        public Boolean isSiebVIN {get;set;}
        public Boolean isfailurerror {get;set;}

        public MultiPSNWrapper(Integer counting,Id ids,String PSN,string failurePoint,String WSD,Boolean BIS,String VIN,
                               String calibrationBefore,String revisionBefore,String calibrationAfter,String revisionAfter,
                               Boolean blankField, Boolean PSNError,Boolean WSDErrorMessage,Boolean isSiebWSD,Boolean WSDFDError,
                               Set<String> errorMsgsSet,Boolean isSiebVIN,Boolean isfailurerror) {
            this.counting = counting;
            this.ids = ids;
            this.PSN = PSN;
            this.failurePoint = failurePoint;
            this.WSD = WSD;
            this.BIS = BIS;
            this.VIN = VIN;
            this.calibrationBefore = calibrationBefore;
            this.revisionBefore = revisionBefore;
            this.calibrationAfter = calibrationAfter;
            this.revisionAfter = revisionAfter;
            this.blankField = blankField;
            this.WSDErrorMessage = WSDErrorMessage;
            this.PSNError = PSNError;
            this.isSiebWSD = isSiebWSD;
            this.WSDFDError = WSDFDError;
            this.errorMsgsSet = errorMsgsSet;
            this.isSiebVIN = isSiebVIN;
            this.isfailurerror = isfailurerror;
        }        
    }

    public void updateWrapperErrors(Boolean PSNError, Boolean WSDErrorMessage, String errorMsg){
        try{
            Integer i = 0;
            set<string> tempsetstring= new set<string>();
            if(lstMPSNWrapper != null && lstMPSNWrapper.size() > 0){
                System.debug('in lstMPSNWrapper loop...');
                for(i=0;i<lstMPSNWrapper.size();i++){
                    if(lstMPSNWrapper[i].counting == selectedRowNo){
                        System.debug('equalled selectedPSN>>>:'+selectedPSN);
                        //lstMPSNWrapper[i].PSN='';
                        System.debug('***WSDErrorMessage>>>:'+WSDErrorMessage);                  
                        if(WSDErrorMessage){
                            lstMPSNWrapper[i].WSDErrorMessage=true;
                        }
                        lstMPSNWrapper[i].failurePoint='';
                        lstMPSNWrapper[i].VIN = '';
                        lstMPSNWrapper[i].BIS=false;
                        lstMPSNWrapper[i].calibrationBefore= '';
                        lstMPSNWrapper[i].revisionBefore='';
                        lstMPSNWrapper[i].calibrationAfter='';
                        lstMPSNWrapper[i].revisionAfter='';
                        lstMPSNWrapper[i].blankField=false;
                        System.debug('**PSNError>>>:'+PSNError); 
                        if(PSNError){
                            lstMPSNWrapper[i].PSNError=true;
                        }
                        Set<String> errorMsgsSet = new Set<String>();
                        errorMsgsSet.add(errorMsg);
                        lstMPSNWrapper[i].errorMsgsSet = errorMsgsSet;
                        system.debug('***errorMsgsSet**'+errorMsgsSet);
                    }
                    if(lstMPSNWrapper[i].errorMsgsSet!=null && lstMPSNWrapper[i].errorMsgsSet.size()>0){
                        system.debug('***lstMPSNWrapper[i].errorMsgsSet***'+lstMPSNWrapper[i].errorMsgsSet);
                        tempsetstring.addall(lstMPSNWrapper[i].errorMsgsSet);
                        system.debug('tempsetstring'+tempsetstring);

                    }  

                }
                /*  As per defect # 189292 we don't have requirment,if we need have below code otherwise no need,-By RAJESH July 9th 2019
                if(tempsetstring!=null && tempsetstring.size()>0){
                     errorMsg_test = '';
                     for(string indivendulMess:tempsetstring){
                         errorMsg_test+=indivendulMess;
                         system.debug('***indivendulMess***'+indivendulMess);
                     }
                     system.debug('***errorMsg_test outside for***'+errorMsg_test);
                  }*/
            }
        }catch(Exception ex){
            System.debug('in catch of updateWrapperErrors of CG_CL_ClaimsMultiPSNComp>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{

        }    
    }

    public void updateWrapper(CSS_getEngineDataResponseJ2A engineData){
        try{
            Integer i = 0;
            string[] DateVals;
            Date dateObj;
            if(lstMPSNWrapper != null && lstMPSNWrapper.size() > 0){
                System.debug('in lstMPSNWrapper loop...');
                for(i=0;i<lstMPSNWrapper.size();i++){
                    if(lstMPSNWrapper[i].counting == selectedRowNo){
                        System.debug('equalled selectedPSN>>>:'+selectedPSN);
                        if(selectedPSN!=null && selectedPSN!=''){
                            lstMPSNWrapper[i].failurePoint='';
                            lstMPSNWrapper[i].WSD = null; //added 20 Sept
                            lstMPSNWrapper[i].VIN=''; //added 20 Sept
                            //engineData.DataArea.WarrantyStartDate = ''; //temp testing line
                            if(engineData.DataArea.WarrantyStartDate !=null && engineData.DataArea.WarrantyStartDate.trim() !=''){
                                system.debug('engineData.DataArea.WarrantyStartDate**'+engineData.DataArea.WarrantyStartDate);
                                //Cross VErify whether its giving the proper date
                                dateObj = Date.valueOf(engineData.DataArea.WarrantyStartDate); //css_utility.formatedDate(engineData.DataArea.WarrantyStartDate); //Date.valueOf(engineData.DataArea.WarrantyStartDate);
                                system.debug('dateObj**'+dateObj);
                                //lstMPSNWrapper[i].WSD = DateTime.newInstance(dateObj.year(),dateObj.month(),dateObj.day()).format('yyyy/mm/dd');//mm/dd/yyyy
                                String WSDate = String.ValueOf(Date.valueOf(engineData.DataArea.WarrantyStartDate)); //cross chheck the format
                                System.debug('WSDate**'+WSDate);
                                DateVals = WSDate.split('-');
                                System.debug('DateVals**'+DateVals);
                                //lstMPSNWrapper[i].WSD = String.ValueOf(Date.valueOf(engineData.DataArea.WarrantyStartDate));
                                //lstMPSNWrapper[i].WSD = DateVals[1]+'/'+DateVals[2]+'/'+DateVals[0];
                                ///lstMPSNWrapper[i].WSD = DateVals[2]+'/'+DateVals[1]+'/'+DateVals[0];
                                if(dateObj != null)
                                    lstMPSNWrapper[i].WSD = FormatDate(dateObj);
                                system.debug('lstMPSNWrapper[i].WSD**'+lstMPSNWrapper[i].WSD);
                                //lstMPSNWrapper[i].WSD = css_utility.formatedDate(engineData.DataArea.WarrantyStartDate);
                                //lstMPSNWrapper[i].WSD = engineData.DataArea.WarrantyStartDate !=null ? (engineData.DataArea.WarrantyStartDate).split('T')[0] : '';
                            }
                            System.debug('engineData.DataArea.vin>>>:'+engineData.DataArea.vin);
                            If(engineData.DataArea.vin!=null && engineData.DataArea.vin!=''){
                                //if(engineData.DataArea.vin.toLowerCase()=='unknown'){
                                if(engineData.DataArea.vin=='unknown'){
                                    system.debug('set**');
                                    lstMPSNWrapper[i].VIN='';
                                    lstMPSNWrapper[i].isSiebVIN = false;
                                    // lstMPSNWrapper[i].isfailurerror = false;

                                }
                                else{
                                    system.debug('inside else of vin not unkown');
                                    lstMPSNWrapper[i].VIN = engineData.DataArea.vin;
                                    lstMPSNWrapper[i].isSiebVIN = true;
                                    //   lstMPSNWrapper[i].isfailurerror = true;
                                }
                            }
                            // lstMPSNWrapper[i].VIN = engineData.DataArea.vin;
                            //eqipmentId = string.valueOf(engineData.DataArea.EquipmentId); ??
                            lstMPSNWrapper[i].BIS=false;
                            lstMPSNWrapper[i].calibrationBefore= '';
                            lstMPSNWrapper[i].revisionBefore='';
                            lstMPSNWrapper[i].calibrationAfter='';
                            lstMPSNWrapper[i].revisionAfter='';
                            lstMPSNWrapper[i].blankField=false; 
                            lstMPSNWrapper[i].blankField=false;
                            lstMPSNWrapper[i].PSNError=false;
                            //if(DateVals!=null)
                            if(engineData.DataArea.WarrantyStartDate !=null && engineData.DataArea.WarrantyStartDate.trim() !='')
                                lstMPSNWrapper[i].isSiebWSD=true;
                            else
                                lstMPSNWrapper[i].isSiebWSD=false;
                            Set<String> errorMsgsSet = new Set<String>();
                            if(dateObj!=null && dateObj > claimsRec.CSS_PSNs__r.get(0).Failure_Date__c){
                                lstMPSNWrapper[i].WSDFDError=true;
                                errorMsg = Label.CG_Warranty_Start_Date_cannot_be_later_than_Failure_Date;
                                errorMsgsSet.add(errorMsg);
                                lstMPSNWrapper[i].errorMsgsSet = errorMsgsSet;
                            }else
                                lstMPSNWrapper[i].errorMsgsSet =  errorMsgsSet;
                            system.debug(' updateWrapper lstMPSNWrapper[i]>>>' +  lstMPSNWrapper[i]);
                        }
                        else{
                            system.debug('Entered PSN NULL**');
                            psnSet.remove(lstMPSNWrapper[i].PSN); //removing old stored value

                            lstMPSNWrapper[i].PSN='';
                            lstMPSNWrapper[i].failurePoint='';
                            lstMPSNWrapper[i].WSD = null;
                            lstMPSNWrapper[i].VIN='';
                            lstMPSNWrapper[i].isSiebVIN = false;
                            lstMPSNWrapper[i].isfailurerror = false;
                            lstMPSNWrapper[i].BIS=false;
                            lstMPSNWrapper[i].calibrationBefore= '';
                            lstMPSNWrapper[i].revisionBefore='';
                            lstMPSNWrapper[i].calibrationAfter='';
                            lstMPSNWrapper[i].revisionAfter='';
                            lstMPSNWrapper[i].blankField=false; 
                            lstMPSNWrapper[i].blankField=false;
                            lstMPSNWrapper[i].PSNError=false;
                            lstMPSNWrapper[i].isSiebWSD=false;
                            Set<String> errorMsgsSet = new Set<String>();
                            lstMPSNWrapper[i].WSDFDError=false;
                            lstMPSNWrapper[i].WSDErrorMessage=false;
                            errorMsg = '';
                            errorMsgsSet.add(errorMsg);
                            lstMPSNWrapper[i].errorMsgsSet = errorMsgsSet;
                        }
                    }
                }
            }

        }catch(Exception ex){
            System.debug('in catch of updateWrapper of CG_CL_ClaimsMultiPSNComp>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }finally{

        }    
    }
    public String FormattedDate{get;set;}
    public String FormatDate(Date d){
        try{
            //Date d = Date.valueof(validationBIS); 
            FormattedDate = css_utility.FormatDate(d);
        }catch(exception e){ 
            system.debug('in catch FormatDate exception>>>:'+ e.getLineNumber() + ' '+ e.getMessage());
        }
        return FormattedDate;
    }
    public boolean setPACCAR_Flag(String mpsn_smn){
        List<CSS_Accreditation__c> accredLst = new List<CSS_Accreditation__c>();
        accredLst = [SELECT Id FROM CSS_Accreditation__c WHERE OEM_Code__c IN ('68','232','326','327') AND StartDate__c <: psnRec.Failure_Date__c AND EndDate__c >=: psnRec.Failure_Date__c  AND  Service_Model_Name__c =: mpsn_smn AND Account__c =: claimsRec.Account__c];
        //system.debug('accredLst'+accredLst[0].Id);
        system.debug('accredLst'+accredLst.size());
        if(accredLst != null && accredLst.size() > 0)
            return true;
        else
            return false;
    }
    public void CampaignsWSCall(){
        // calling FieldAction WebService in case of failure response on chevron navigation
        if(claimsRec.FieldActionWebServiceResult__c == 'Error'){
            string FailureDateString;
            if(psnRec.Failure_Date__c != null){
                FailureDateString = DateTime.newInstance(psnRec.Failure_Date__c.year(),psnRec.Failure_Date__c.month(),psnRec.Failure_Date__c.day()).format('dd-MMM-YY');
            }
            claimsRec.FieldActionWebServiceResult__c = CG_BL_Campaigns.callGetCampaignsWebServiceforClaimsOnChevronChangeClaim(psnRec.PSN__c, FailureDateString, claimsRec.Region__c,'', 'CSS', 'GetCampaign', 'UniqueID', 'CSSWarranty', psnRec.CSS_Claims__c);
            claimsRec.Id = cId;
            if(claimsRec.Id != null){
                update claimsRec; 
            }
        }
    }
}